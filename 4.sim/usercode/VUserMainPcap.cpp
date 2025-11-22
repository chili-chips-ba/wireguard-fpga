//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description: VProc application that replays arbitrary PCAP streams via
//              udpIpPg nodes and records received UDP traffic back to PCAP.
//==========================================================================

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>
#include <filesystem>
#include <deque>
#include <mutex>

#include "VProcClass.h"
extern "C" {
#include "VUser.h"
}
#include "udpIpPg.h"
#include "udpVProc.h"
#include "PcapIO.h"

// Forward decls for helpers
static bool getenv_bool(const char* key, bool defval);
static uint64_t getenv_u64(const char* key, uint64_t defval);

// Global TX start-time queues for mapping RX timestamps to TX schedule
static std::deque<uint64_t> g_tx_times_node2;
static std::mutex           g_tx_mtx_node2;
static std::deque<uint64_t> g_tx_times_node4;
static std::mutex           g_tx_mtx_node4;

// ----------------------------------------------------------------------------
// Node definitions: MAC/IP/UDP ports (same as in VUserMainUdp.cpp)
// ----------------------------------------------------------------------------
#define NODE1_MAC_ADDR   0xd89ef3887ec3ULL  // D8:9E:F3:88:7E:C3
#define NODE1_IPV4_ADDR  0xc0a81908        // 192.168.25.8
#define NODE1_UDP_PORT   0x0400            // UDP port 1024

#define NODE2_MAC_ADDR   0x90324b070bd1ULL  // 90:32:4B:07:0B:D1
#define NODE2_IPV4_ADDR  0xc0a89801        // 192.168.152.1
#define NODE2_UDP_PORT   0x0401            // UDP port 1025

#define NODE3_MAC_ADDR   0xAABBCCDDEEFFULL  // example MAC for Node3
#define NODE3_IPV4_ADDR  0xc0a80103        // 192.168.1.3
#define NODE3_UDP_PORT   0x0500            // UDP port 1280

#define NODE4_MAC_ADDR   0x112233445566ULL  // example MAC for Node4
#define NODE4_IPV4_ADDR  0xc0a80104        // 192.168.1.4
#define NODE4_UDP_PORT   0x0501            // UDP port 1281

static constexpr uint64_t GMII_TICK_NS      = 8ull;
static constexpr uint64_t NODE1_INIT_TICKS  = 0ull;
static constexpr uint64_t NODE3_INIT_TICKS  = 0ull;
static constexpr uint64_t NODE1_INIT_NS     = NODE1_INIT_TICKS * GMII_TICK_NS;
static constexpr uint64_t NODE3_INIT_NS     = NODE3_INIT_TICKS * GMII_TICK_NS;

// In this testbench, udp_ip_pg tick increments on GMII clk (125MHz)
// so one tick corresponds to 8ns.
static inline uint64_t ticks_for_ns(uint64_t ns) {
    // Round up division to avoid scheduling before target time
    return (ns + (GMII_TICK_NS - 1)) / GMII_TICK_NS;
}

// Ethernet CRC32 (FCS) calculation: reflected polynomial 0xEDB88320,
// init 0xFFFFFFFF, final xor 0xFFFFFFFF, append little-endian.
static uint32_t eth_crc32(const uint8_t* data, size_t len) {
    uint32_t crc = 0xFFFFFFFFu;
    for (size_t i = 0; i < len; ++i) {
        uint32_t b = data[i];
        crc ^= b;
        for (int j = 0; j < 8; ++j) {
            uint32_t mask = -(int)(crc & 1u);
            crc = (crc >> 1) ^ (0xEDB88320u & mask);
        }
    }
    return ~crc;
}

// ----------------------------------------------------------------------------
// Utilities for frame build (for RX writer fallback)
// ----------------------------------------------------------------------------
static inline void be_put16(uint8_t* p, uint16_t v) {
    p[0] = uint8_t((v >> 8) & 0xFF);
    p[1] = uint8_t(v & 0xFF);
}
static inline void be_put32(uint8_t* p, uint32_t v) {
    p[0] = uint8_t((v >> 24) & 0xFF);
    p[1] = uint8_t((v >> 16) & 0xFF);
    p[2] = uint8_t((v >> 8) & 0xFF);
    p[3] = uint8_t(v & 0xFF);
}
static inline void mac_to_bytes(uint64_t mac48, uint8_t* out6) {
    // mac48 uses lower 48 bits
    out6[0] = (uint8_t)((mac48 >> 40) & 0xFF);
    out6[1] = (uint8_t)((mac48 >> 32) & 0xFF);
    out6[2] = (uint8_t)((mac48 >> 24) & 0xFF);
    out6[3] = (uint8_t)((mac48 >> 16) & 0xFF);
    out6[4] = (uint8_t)((mac48 >> 8)  & 0xFF);
    out6[5] = (uint8_t)( mac48        & 0xFF);
}

static uint16_t ipv4_checksum(const uint8_t* hdr, size_t len) {
    // Internet checksum over IPv4 header
    uint32_t sum = 0;
    for (size_t i = 0; i + 1 < len; i += 2) {
        sum += (hdr[i] << 8) | hdr[i + 1];
    }
    if (len & 1) {
        sum += (hdr[len - 1] << 8);
    }
    while (sum >> 16) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    return (uint16_t)(~sum);
}

static uint16_t udp_checksum_ipv4(uint32_t src_ip, uint32_t dst_ip, const uint8_t* udp, size_t len) {
    // Pseudo-header + UDP header+payload checksum
    uint32_t sum = 0;
    auto add16 = [&](uint16_t v) { sum += v; };
    add16((uint16_t)(src_ip >> 16));
    add16((uint16_t)(src_ip & 0xFFFF));
    add16((uint16_t)(dst_ip >> 16));
    add16((uint16_t)(dst_ip & 0xFFFF));
    add16(0x0011); // protocol 17
    add16((uint16_t)len);
    for (size_t i = 0; i + 1 < len; i += 2) {
        add16((udp[i] << 8) | udp[i + 1]);
    }
    if (len & 1) {
        add16((uint16_t)(udp[len - 1] << 8));
    }
    while (sum >> 16) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    uint16_t res = (uint16_t)(~sum);
    return res == 0 ? 0xFFFF : res; // RFC768: 0x0000 on wire, but 0xFFFF for zero sum pre-complement
}

// Build minimal Ethernet+IPv4+UDP frame from rxInfo and known local addresses.
// Note: This is a fallback to produce a valid packet for Wireshark if raw frame
// bytes are not available from udpIpPg.
static std::vector<uint8_t> build_eth_ipv4_udp_frame(const udpIpPg::rxInfo_t &info,
                                                     uint64_t local_mac,
                                                     uint32_t local_ip)
{
    const uint16_t eth_type = 0x0800; // IPv4
    const uint8_t ihl_ver = 0x45;     // IPv4, 20-byte header
    const uint8_t tos = 0x00;
    const uint16_t udp_len = (uint16_t)(8 + info.rx_len);
    const uint16_t ip_tot_len = (uint16_t)(20 + udp_len);
    const uint16_t id = 0x0000;
    const uint16_t flags_frag = 0x0000;
    const uint8_t ttl = 64;
    const uint8_t proto = 17;

    std::vector<uint8_t> pkt;
    pkt.resize(14 + 20 + 8 + info.rx_len);
    uint8_t *p = pkt.data();

    // Ethernet
    mac_to_bytes(local_mac, p + 0);
    mac_to_bytes(info.mac_src_addr, p + 6);
    be_put16(p + 12, eth_type);

    // IPv4 header
    p[14] = ihl_ver;
    p[15] = tos;
    be_put16(p + 16, ip_tot_len);
    be_put16(p + 18, id);
    be_put16(p + 20, flags_frag);
    p[22] = ttl;
    p[23] = proto;
    be_put16(p + 24, 0); // checksum placeholder
    be_put32(p + 26, info.ipv4_src_addr);
    be_put32(p + 30, local_ip);
    // checksum
    be_put16(p + 24, ipv4_checksum(p + 14, 20));

    // UDP header
    be_put16(p + 34, (uint16_t)info.udp_src_port);
    be_put16(p + 36, (uint16_t)info.udp_dst_port);
    be_put16(p + 38, udp_len);
    be_put16(p + 40, 0); // checksum placeholder

    // Payload
    std::memcpy(p + 42, info.rx_payload, info.rx_len);

    // UDP checksum over pseudo-header + UDP
    uint16_t ucs = udp_checksum_ipv4(info.ipv4_src_addr, local_ip, p + 34, udp_len);
    be_put16(p + 40, ucs);

    return pkt;
}

// ----------------------------------------------------------------------------
// RX writer: records packets to PCAP with arrival timestamps
// ----------------------------------------------------------------------------
struct RxRecorderCtx {
    pcapio::Writer writer;
    uint32_t node_id = 0;          // VProc node id to read tick counter
    bool     started = false;
    uint32_t last_tick = 0;        // last observed tick (for wrap detection)
    uint64_t tick_wraps = 0;       // number of 32-bit wraps seen
    std::deque<uint64_t>* tx_times = nullptr; // queue of scheduled start times (ns)
    std::mutex*           tx_mtx   = nullptr;
    uint64_t sched_offset_ns = 0;  // absolute time offset before first packet
    uint64_t min_latency_ns = 0;   // enforced minimum latency after TX schedule
};

static void rx_record_callback(udpIpPg::rxInfo_t info, void* hdl) {
    auto *ctx = reinterpret_cast<RxRecorderCtx*>(hdl);
    if (!ctx)
        return;

    // Default: measured arrival time based on HDL tick count (8ns/tick)
    uint32_t ticks = 0;
    VRead(udpVProc::TICKS_ADDR, &ticks, true, (int)ctx->node_id);
    if (!ctx->started) {
        ctx->started    = true;
        ctx->last_tick  = ticks;
    }
    // Detect 32-bit tick wrap to keep timestamps monotonic
    if (ticks < ctx->last_tick) {
        ctx->tick_wraps++;
    }
    ctx->last_tick = ticks;
    uint64_t rx_ticks64 = (ctx->tick_wraps << 32) | (uint64_t)ticks;
    uint64_t ts_ns_abs  = rx_ticks64 * GMII_TICK_NS;

    // Pull scheduled TX start for this packet (relative to first packet)
    uint64_t tx_sched_abs = ctx->sched_offset_ns;
    if (ctx->tx_times && ctx->tx_mtx) {
        std::lock_guard<std::mutex> lk(*ctx->tx_mtx);
        if (!ctx->tx_times->empty()) {
            tx_sched_abs = ctx->tx_times->front();
            ctx->tx_times->pop_front();
        }
    }

    // Ensure recorded timestamp is never earlier than scheduled start plus any enforced latency
    uint64_t min_ts = tx_sched_abs + ctx->min_latency_ns;
    if (ts_ns_abs < min_ts) {
        ts_ns_abs = min_ts;
    }

    // Fallback: build a minimal Ethernet+IPv4+UDP frame
    uint64_t local_mac = 0;
    uint32_t local_ip  = 0;
    if (ctx->node_id == 2) {
        local_mac = NODE2_MAC_ADDR;
        local_ip = NODE2_IPV4_ADDR;
    }
    else if (ctx->node_id == 4) {
        local_mac = NODE4_MAC_ADDR;
        local_ip = NODE4_IPV4_ADDR;
    }

    std::vector<uint8_t> frame = build_eth_ipv4_udp_frame(info, local_mac, local_ip);

    VPrint("RX rec: len=%u src=%u.%u.%u.%u:%u -> dst=%u.%u.%u.%u:%u\n",
           (unsigned)frame.size(),
           (info.ipv4_src_addr >> 24) & 0xFF, (info.ipv4_src_addr >> 16) & 0xFF,
           (info.ipv4_src_addr >> 8) & 0xFF, info.ipv4_src_addr & 0xFF,
           info.udp_src_port,
           (local_ip >> 24) & 0xFF, (local_ip >> 16) & 0xFF,
           (local_ip >> 8) & 0xFF, local_ip & 0xFF,
           info.udp_dst_port);

    uint32_t ts_sec  = (uint32_t)(ts_ns_abs / 1000000000ull);
    uint32_t ts_frac = (uint32_t)(ts_ns_abs % 1000000000ull);
    ctx->writer.write(ts_sec, ts_frac, frame);
}

// ----------------------------------------------------------------------------
// TX side: replay PCAP frames with timing
// ----------------------------------------------------------------------------
// Try to rewrite IPv4 UDP frames' L2/L3/L4 destination/source to match our nodes,
// so that udpIpPg receiver will accept them. Only applied if 'rewrite' is true.
static void rewrite_ipv4_udp_inplace(std::vector<uint8_t>& d,
                                     uint64_t mac_src, uint64_t mac_dst,
                                     uint32_t ip_src,  uint32_t ip_dst,
                                     uint16_t udp_dst_port)
{
    if (d.size() < 42)
        return;
    // EtherType
    if (!((d[12] == 0x08) && (d[13] == 0x00)))
        return;
    // IPv4 header length
    size_t ip_off = 14;
    size_t ihl = (d[ip_off] & 0x0F) * 4;
    if (ihl < 20 || d.size() < ip_off + ihl + 8)
        return;
    // Protocol
    if (d[ip_off + 9] != 17)
        return; // not UDP

    // Overwrite MACs
    auto wrmac=[&](size_t off, uint64_t mac){
        d[off+0] = (uint8_t)((mac >> 40) & 0xFF);
        d[off+1] = (uint8_t)((mac >> 32) & 0xFF);
        d[off+2] = (uint8_t)((mac >> 24) & 0xFF);
        d[off+3] = (uint8_t)((mac >> 16) & 0xFF);
        d[off+4] = (uint8_t)((mac >> 8) & 0xFF);
        d[off+5] = (uint8_t)( mac        & 0xFF);
    };
    wrmac(0, mac_dst);
    wrmac(6, mac_src);

    // Overwrite IPs
    d[ip_off + 12] = (uint8_t)((ip_src >> 24) & 0xFF);
    d[ip_off + 13] = (uint8_t)((ip_src >> 16) & 0xFF);
    d[ip_off + 14] = (uint8_t)((ip_src >> 8) & 0xFF);
    d[ip_off + 15] = (uint8_t)( ip_src        & 0xFF);

    d[ip_off + 16] = (uint8_t)((ip_dst >> 24) & 0xFF);
    d[ip_off + 17] = (uint8_t)((ip_dst >> 16) & 0xFF);
    d[ip_off + 18] = (uint8_t)((ip_dst >> 8) & 0xFF);
    d[ip_off + 19] = (uint8_t)( ip_dst        & 0xFF);

    // Clear IP header checksum before recompute
    d[ip_off + 10] = 0; d[ip_off + 11] = 0;
    // Recompute IP header checksum
    uint16_t ipcs = ipv4_checksum(&d[ip_off], ihl);
    d[ip_off + 10] = (uint8_t)((ipcs >> 8) & 0xFF);
    d[ip_off + 11] = (uint8_t)( ipcs       & 0xFF);

    // Overwrite UDP dst port
    size_t udp_off = ip_off + ihl;
    d[udp_off + 2] = (uint8_t)((udp_dst_port >> 8) & 0xFF);
    d[udp_off + 3] = (uint8_t)( udp_dst_port       & 0xFF);

    // Clear UDP checksum
    d[udp_off + 6] = 0; d[udp_off + 7] = 0;
    // Compute UDP checksum over pseudo-header + UDP segment
    uint16_t ucs = udp_checksum_ipv4(ip_src, ip_dst, &d[udp_off], d.size() - udp_off);
    d[udp_off + 6] = (uint8_t)((ucs >> 8) & 0xFF);
    d[udp_off + 7] = (uint8_t)( ucs       & 0xFF);
}

static void replay_pcap(udpIpPg &pUdp, const char* path,
                        bool rewrite,
                        uint64_t mac_src=0, uint64_t mac_dst=0,
                        uint32_t ip_src=0,  uint32_t ip_dst=0,
                        uint16_t udp_dst_port=0,
                        pcapio::Writer* tx_dump=nullptr,
                        std::deque<uint64_t>* tx_times=nullptr,
                        std::mutex* tx_mtx=nullptr,
                        uint64_t sched_offset_ns=0) {
    pcapio::Reader r;
    if (!r.open(path)) {
        VPrint("PCAP: failed to open %s\n", path);
        return;
    }
    VPrint("PCAP: replaying %s (res=%s)\n", path, r.time_res() == pcapio::TimeRes::Nanos ? "ns" : "us");

    bool first = true;
    uint64_t base_ns = 0;
    uint64_t waited_ticks = 0;
    pcapio::Reader::Packet pkt;
    int dbg_count = 0;
    while (r.next(pkt)) {
        uint64_t cur_ns = (r.time_res() == pcapio::TimeRes::Nanos)
                        ? ((uint64_t)pkt.ts_sec * 1000000000ull + pkt.ts_frac)
                        : ((uint64_t)pkt.ts_sec * 1000000000ull + (uint64_t)pkt.ts_frac * 1000ull);
        if (first) {
            base_ns = cur_ns;
            first = false;
        }
        uint64_t delta_ns = cur_ns - base_ns;

        // Wait only the additional ticks since last packet
        uint64_t target_ticks = ticks_for_ns(delta_ns);
        if (target_ticks > waited_ticks) {
            uint64_t add = target_ticks - waited_ticks;
            for (uint64_t i = 0; i < add; ++i) {
                pUdp.UdpVpSendIdle(1);
            }
            waited_ticks += add;
        }

        // Optional debug: dump basic L2/L3 info for first few frames
        if (dbg_count < 5) {
            const auto &d = pkt.data;
            if (d.size() >= 14) {
                uint16_t eth = (uint16_t)(d[12] << 8 | d[13]);
                VPrint("TX frame len=%u eth=0x%04X\n", (unsigned)d.size(), eth);
                if (eth == 0x0800 && d.size() >= 34) {
                    uint8_t proto = d[23];
                    VPrint("  IPv4 proto=%u src=%u.%u.%u.%u dst=%u.%u.%u.%u\n",
                           proto,
                           d[26], d[27], d[28], d[29],
                           d[30], d[31], d[32], d[33]);
                    if (proto == 17 && d.size() >= 42) {
                        uint16_t sp = (uint16_t)(d[34] << 8 | d[35]);
                        uint16_t dp = (uint16_t)(d[36] << 8 | d[37]);
                        VPrint("  UDP %u -> %u\n", sp, dp);
                    }
                }
            }
            dbg_count++;
        }

        // Optionally rewrite L2/L3/L4 for IPv4/UDP frames so Node receives
        if (rewrite) {
            rewrite_ipv4_udp_inplace(pkt.data, mac_src, mac_dst, ip_src, ip_dst, udp_dst_port);
            if (dbg_count < 5) {
                const auto &d = pkt.data;
                VPrint("  REW: dstMAC=%02X:%02X:%02X:%02X:%02X:%02X srcMAC=%02X:%02X:%02X:%02X:%02X:%02X\n",
                       d[0],d[1],d[2],d[3],d[4],d[5], d[6],d[7],d[8],d[9],d[10],d[11]);
                if (d.size() >= 42) {
                    VPrint("  REW: src=%u.%u.%u.%u dst=%u.%u.%u.%u dport=%u\n",
                           d[26], d[27], d[28], d[29], d[30], d[31], d[32], d[33], (unsigned)((d[36]<<8)|d[37]));
                }
            }
        }

        // Optional TX dump (body without preamble/FCS) for Wireshark
        if (tx_dump && tx_dump->good()) {
            static uint32_t tns = 0;
            tx_dump->write(0, tns, pkt.data);
            tns += 1000; // +1us step
        }

        // Record scheduled TX start time so RX can write timestamps >= input schedule
        if (tx_times && tx_mtx) {
            std::lock_guard<std::mutex> lk(*tx_mtx);
            tx_times->push_back(sched_offset_ns + delta_ns);
        }

        // Build TX stream (configurable preamble/FCS)
        bool add_preamble = getenv_bool("PCAP_TX_PREAMBLE", true);
        bool add_fcs      = getenv_bool("PCAP_TX_FCS",      true);
        std::vector<uint8_t> tx;
        tx.reserve((add_preamble?8:0) + pkt.data.size() + (add_fcs?4:0));
        // 7 bytes 0x55 preamble + 1 byte SFD 0xD5
        if (add_preamble) {
            for (int i = 0; i < 7; ++i) {
                tx.push_back(0x55);
            }
            tx.push_back(0xD5);
        }
        // Body (from destination MAC onwards)
        tx.insert(tx.end(), pkt.data.begin(), pkt.data.end());
        // FCS over body only (no preamble/SFD)
        if (add_fcs) {
            uint32_t fcs = eth_crc32(pkt.data.data(), pkt.data.size());
            tx.push_back((uint8_t)(fcs & 0xFF));
            tx.push_back((uint8_t)((fcs >> 8) & 0xFF));
            tx.push_back((uint8_t)((fcs >> 16) & 0xFF));
            tx.push_back((uint8_t)((fcs >> 24) & 0xFF));
        }
        if (dbg_count < 5) {
            VPrint("  TX built len=%u (preamble=%u fcs=%u)\n", (unsigned)tx.size(), add_preamble?1:0, add_fcs?1:0);
        }

        // Send raw frame: present bytes as uint32_t elements (low byte used)
        const uint32_t len = (uint32_t)tx.size();
        std::vector<uint32_t> frame(len);
        for (uint32_t i = 0; i < len; ++i) {
            frame[i] = tx[i];
        }
        pUdp.UdpVpSendRawEthFrame(frame.data(), len);

        // Account for transmission time in the schedule so the START of each
        // frame aligns to the input PCAP timestamps. One byte transmitted per
        // tick, and UdpVpSendRawEthFrame adds a trailing idle tick.
        waited_ticks += (uint64_t)len + 1;
    }
    // Idle forever afterwards
    while (true)
        pUdp.UdpVpSendIdle(1);
}

// ----------------------------------------------------------------------------
// Helpers to read environment variable with default
// ----------------------------------------------------------------------------
static std::string getenv_or(const char* key, const char* defval) {
    const char* v = std::getenv(key);
    if (v && *v)
        return std::string(v);
    return std::string(defval);
}

static uint64_t getenv_u64(const char* key, uint64_t defval) {
    const char* v = std::getenv(key);
    if (!v || !*v)
        return defval;
    char* end = nullptr;
    uint64_t parsed = std::strtoull(v, &end, 0);
    if (end && *end == '\0')
        return parsed;
    return defval;
}

static bool getenv_bool(const char* key, bool defval)
{
    const char* v = std::getenv(key);
    if (!v || !*v)
        return defval;
    if (v[0] == '0' || v[0] == 'n' || v[0] == 'N' || v[0] == 'f' || v[0] == 'F')
        return false;
    return true;
}

// ----------------------------------------------------------------------------
// VUserMain1: Node1 replays PCAP to Node2
// ----------------------------------------------------------------------------
extern "C" void VUserMain1(void) {
    VPrint("Node1: PCAP replay init\n");
    udpIpPg pUdp(1, NODE1_IPV4_ADDR, NODE1_MAC_ADDR, NODE1_UDP_PORT);

    // Small initial idle to let the system settle
    for (uint64_t i = 0; i < NODE1_INIT_TICKS; ++i) {
        pUdp.UdpVpSendIdle(1); // ~1ms
    }

    std::string in1 = getenv_or("PCAP_IN_1", "./rtl/pcap_reader_writer/test_udp_rand.pcap");
    VPrint("Node1: replaying %s\n", in1.c_str());
    bool rewrite = getenv_or("PCAP_REWRITE", "1") != "0";
    static pcapio::Writer tx1;
    std::string tx1p = getenv_or("PCAP_TX_OUT_1", "./output/tx_node1.pcap");
    try {
        std::filesystem::create_directories(std::filesystem::path(tx1p).parent_path());
    } catch(...) {}
    tx1.open(tx1p, pcapio::TimeRes::Nanos);
    replay_pcap(pUdp, in1.c_str(), rewrite,
                NODE1_MAC_ADDR, NODE2_MAC_ADDR,
                NODE1_IPV4_ADDR, NODE2_IPV4_ADDR,
                (uint16_t)NODE2_UDP_PORT,
                &tx1,
                &g_tx_times_node2,
                &g_tx_mtx_node2,
                NODE1_INIT_NS);
}

// ----------------------------------------------------------------------------
// VUserMain2: Node2 records to PCAP
// ----------------------------------------------------------------------------
extern "C" void VUserMain2(void) {
    VPrint("Node2: PCAP record init\n");
    udpIpPg pUdp(2, NODE2_IPV4_ADDR, NODE2_MAC_ADDR, NODE2_UDP_PORT);

    std::string out2 = getenv_or("PCAP_OUT_2", "./output/node2_out.pcap");
    // Ensure directory exists
    try {
        std::filesystem::create_directories(std::filesystem::path(out2).parent_path());
    } catch(...) {}
    static RxRecorderCtx ctx2;
    if (!ctx2.writer.open(out2, pcapio::TimeRes::Nanos)) {
        VPrint("Node2: failed to open %s for write\n", out2.c_str());
    }
    ctx2.node_id = 2;
    ctx2.tx_times = &g_tx_times_node2;
    ctx2.tx_mtx   = &g_tx_mtx_node2;
    ctx2.sched_offset_ns = NODE1_INIT_NS;
    ctx2.min_latency_ns  = getenv_u64("PCAP_MIN_LATENCY_NS", 0);
    pUdp.registerUsrRxCbFunc(rx_record_callback, &ctx2);
    while (true)
        pUdp.UdpVpSendIdle(1);
}

// ----------------------------------------------------------------------------
// VUserMain3: Node3 replays PCAP to Node4
// ----------------------------------------------------------------------------
extern "C" void VUserMain3(void) {
    VPrint("Node3: PCAP replay init\n");
    udpIpPg pUdp(3, NODE3_IPV4_ADDR, NODE3_MAC_ADDR, NODE3_UDP_PORT);

    for (uint64_t i = 0; i < NODE3_INIT_TICKS; ++i) {
        pUdp.UdpVpSendIdle(1); // ~2ms
    }

    std::string in3 = getenv_or("PCAP_IN_1", "./rtl/pcap_reader_writer/test_udp_rand.pcap");
    VPrint("Node3: replaying %s\n", in3.c_str());
    bool rewrite = getenv_or("PCAP_REWRITE", "1") != "0";
    static pcapio::Writer tx3;
    std::string tx3p = getenv_or("PCAP_TX_OUT_3", "./output/tx_node3.pcap");
    try {
        std::filesystem::create_directories(std::filesystem::path(tx3p).parent_path());
    } catch(...) {}
    tx3.open(tx3p, pcapio::TimeRes::Nanos);
    replay_pcap(pUdp, in3.c_str(), rewrite,
                NODE3_MAC_ADDR, NODE4_MAC_ADDR,
                NODE3_IPV4_ADDR, NODE4_IPV4_ADDR,
                (uint16_t)NODE4_UDP_PORT,
                &tx3,
                &g_tx_times_node4,
                &g_tx_mtx_node4,
                NODE3_INIT_NS);
}

// ----------------------------------------------------------------------------
// VUserMain4: Node4 records to PCAP
// ----------------------------------------------------------------------------
extern "C" void VUserMain4(void) {
    VPrint("Node4: PCAP record init\n");
    udpIpPg pUdp(4, NODE4_IPV4_ADDR, NODE4_MAC_ADDR, NODE4_UDP_PORT);

    std::string out4 = getenv_or("PCAP_OUT_4", "./output/node4_out.pcap");
    // Ensure directory exists
    try {
        std::filesystem::create_directories(std::filesystem::path(out4).parent_path());
    } catch(...) {}
    static RxRecorderCtx ctx4;
    if (!ctx4.writer.open(out4, pcapio::TimeRes::Nanos)) {
        VPrint("Node4: failed to open %s for write\n", out4.c_str());
    }
    ctx4.node_id = 4;
    ctx4.tx_times = &g_tx_times_node4;
    ctx4.tx_mtx   = &g_tx_mtx_node4;
    ctx4.sched_offset_ns = NODE3_INIT_NS;
    ctx4.min_latency_ns  = getenv_u64("PCAP_MIN_LATENCY_NS", 0);
    pUdp.registerUsrRxCbFunc(rx_record_callback, &ctx4);
    while (true)
        pUdp.UdpVpSendIdle(1);
}
