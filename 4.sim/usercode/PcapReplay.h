// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description: Header-only helper utilities for replaying PCAP input streams
//              and recording RX traffic with realistic timestamps.
//==========================================================================

#pragma once

#include <cstdint>
#include <deque>
#include <filesystem>
#include <mutex>
#include <string>
#include <vector>
#include <cstdlib>
#include <cstring>

#include "udpIpPg.h"
#include "udpVProc.h"
#include "PcapIO.h"

namespace pcapreplay {

inline constexpr uint64_t GMII_TICK_NS = 8ull;

// ----------------------------------------------------------------------------
// MergeLogger: optional helper to interleave TX/RX streams into single PCAP
// ----------------------------------------------------------------------------
class MergeLogger {
public:
    bool init(const std::string& path) {
        if (path.empty())
            return false;
        std::lock_guard<std::mutex> lk(mtx_);
        if (enabled_)
            return true;
        std::filesystem::path p(path);
        auto parent = p.parent_path();
        if (!parent.empty()) {
            try {
                std::filesystem::create_directories(parent);
            } catch(...) {}
        }
        if (!writer_.open(path, pcapio::TimeRes::Nanos)) {
            VPrint("MergeLogger: failed to open %s\n", path.c_str());
            return false;
        }
        enabled_ = true;
        return true;
    }

    bool enabled() const { return enabled_; }

    void log(uint64_t ts_ns, const std::vector<uint8_t>& frame) {
        if (!enabled_)
            return;
        std::lock_guard<std::mutex> lk(mtx_);
        uint32_t ts_sec  = (uint32_t)(ts_ns / 1000000000ull);
        uint32_t ts_frac = (uint32_t)(ts_ns % 1000000000ull);
        writer_.write(ts_sec, ts_frac, frame);
    }

private:
    pcapio::Writer writer_;
    bool enabled_ = false;
    mutable std::mutex mtx_;
};

class Manager {
public:
    struct RxRecorderCtx {
        pcapio::Writer writer;
        uint32_t node_id = 0;
        bool     started = false;
        uint32_t last_tick = 0;
        uint64_t tick_wraps = 0;
        std::deque<uint64_t>* tx_times = nullptr;
        std::mutex*           tx_mtx   = nullptr;
        uint64_t sched_offset_ns = 0;
        uint64_t min_latency_ns  = 0;
        uint64_t local_mac = 0;
        uint32_t local_ip  = 0;
        MergeLogger* merge_logger = nullptr;
    };

    // Convenience wrappers for reading environment overrides with defaults.
    static std::string GetEnvOr(const char* key, const char* defval);
    static bool GetEnvBool(const char* key, bool defval);
    static uint64_t GetEnvU64(const char* key, uint64_t defval);

    // Replays packets from a PCAP file over the provided udpIpPg instance.
    static void ReplayPcap(udpIpPg &pUdp,
                           const char* path,
                           bool rewrite,
                           uint64_t mac_src,
                           uint64_t mac_dst,
                           uint32_t ip_src,
                           uint32_t ip_dst,
                           uint16_t udp_dst_port,
                           pcapio::Writer* tx_dump,
                           std::deque<uint64_t>* tx_times,
                           std::mutex* tx_mtx,
                           uint64_t sched_offset_ns,
                           MergeLogger* merge_logger = nullptr);

    // Registers the RX callback that timestamps and stores arriving packets.
    static void RegisterRecorder(udpIpPg &pUdp, RxRecorderCtx* ctx);

private:
    // Rewrites MAC/IP/UDP headers of a packet so the DUT accepts it.
    static void RewriteIpv4UdpInplace(std::vector<uint8_t>& data,
                                      uint64_t mac_src, uint64_t mac_dst,
                                      uint32_t ip_src, uint32_t ip_dst,
                                      uint16_t udp_dst_port);
    // RX callback used by udpIpPg to feed packets into the recorder.
    static void RxRecordCallback(udpIpPg::rxInfo_t info, void* hdl);
    // Builds a synthetic Ethernet/IP/UDP frame when raw RX bytes aren't available.
    static std::vector<uint8_t> BuildFallbackFrame(const udpIpPg::rxInfo_t &info,
                                                   uint64_t local_mac,
                                                   uint32_t local_ip);
    // Utility helpers shared across replay and record paths.
    static uint64_t TicksForNs(uint64_t ns);
    static uint32_t EthCrc32(const uint8_t* data, size_t len);
    static void MacToBytes(uint64_t mac48, uint8_t* out6);
    static inline void BePut16(uint8_t* p, uint16_t v) {
        p[0] = static_cast<uint8_t>((v >> 8) & 0xFF);
        p[1] = static_cast<uint8_t>(v & 0xFF);
    }
    static inline void BePut32(uint8_t* p, uint32_t v) {
        p[0] = static_cast<uint8_t>((v >> 24) & 0xFF);
        p[1] = static_cast<uint8_t>((v >> 16) & 0xFF);
        p[2] = static_cast<uint8_t>((v >> 8) & 0xFF);
        p[3] = static_cast<uint8_t>(v & 0xFF);
    }
    static uint16_t Ipv4Checksum(const uint8_t* hdr, size_t len);
    static uint16_t UdpChecksumIpv4(uint32_t src_ip, uint32_t dst_ip,
                                    const uint8_t* udp, size_t len);
    static uint64_t WireTicksFromFrameSize(size_t frame_body_len);
};

} // namespace pcapreplay

namespace pcapreplay {

inline uint64_t Manager::TicksForNs(uint64_t ns) {
    return (ns + (GMII_TICK_NS - 1)) / GMII_TICK_NS;
}

inline uint32_t Manager::EthCrc32(const uint8_t* data, size_t len) {
    uint32_t crc = 0xFFFFFFFFu;
    for (size_t i = 0; i < len; ++i) {
        crc ^= data[i];
        for (int j = 0; j < 8; ++j) {
            uint32_t mask = -(int)(crc & 1u);
            crc = (crc >> 1) ^ (0xEDB88320u & mask);
        }
    }
    return ~crc;
}

inline void Manager::MacToBytes(uint64_t mac48, uint8_t* out6) {
    out6[0] = static_cast<uint8_t>((mac48 >> 40) & 0xFF);
    out6[1] = static_cast<uint8_t>((mac48 >> 32) & 0xFF);
    out6[2] = static_cast<uint8_t>((mac48 >> 24) & 0xFF);
    out6[3] = static_cast<uint8_t>((mac48 >> 16) & 0xFF);
    out6[4] = static_cast<uint8_t>((mac48 >> 8) & 0xFF);
    out6[5] = static_cast<uint8_t>(mac48 & 0xFF);
}

inline uint16_t Manager::Ipv4Checksum(const uint8_t* hdr, size_t len) {
    uint32_t sum = 0;
    for (size_t i = 0; i + 1 < len; i += 2) {
        sum += (uint16_t)(hdr[i] << 8 | hdr[i + 1]);
    }
    if (len & 1) {
        sum += (uint16_t)(hdr[len - 1] << 8);
    }
    while (sum >> 16) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    return (uint16_t)(~sum);
}

inline uint16_t Manager::UdpChecksumIpv4(uint32_t src_ip, uint32_t dst_ip,
                                         const uint8_t* udp, size_t len) {
    uint32_t sum = 0;
    auto add16 = [&](uint16_t v) { sum += v; };
    add16((uint16_t)(src_ip >> 16));
    add16((uint16_t)(src_ip & 0xFFFF));
    add16((uint16_t)(dst_ip >> 16));
    add16((uint16_t)(dst_ip & 0xFFFF));
    add16(0x0011);
    add16((uint16_t)len);
    for (size_t i = 0; i + 1 < len; i += 2) {
        add16((uint16_t)(udp[i] << 8 | udp[i + 1]));
    }
    if (len & 1) {
        add16((uint16_t)(udp[len - 1] << 8));
    }
    while (sum >> 16) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    uint16_t res = (uint16_t)(~sum);
    return res == 0 ? 0xFFFF : res;
}

inline std::vector<uint8_t> Manager::BuildFallbackFrame(const udpIpPg::rxInfo_t &info,
                                                        uint64_t local_mac,
                                                        uint32_t local_ip) {
    const uint16_t eth_type = 0x0800;
    const uint8_t ihl_ver = 0x45;
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

    MacToBytes(local_mac, p + 0);
    MacToBytes(info.mac_src_addr, p + 6);
    BePut16(p + 12, eth_type);

    p[14] = ihl_ver;
    p[15] = tos;
    BePut16(p + 16, ip_tot_len);
    BePut16(p + 18, id);
    BePut16(p + 20, flags_frag);
    p[22] = ttl;
    p[23] = proto;
    BePut16(p + 24, 0);
    BePut32(p + 26, info.ipv4_src_addr);
    BePut32(p + 30, local_ip);
    BePut16(p + 24, Ipv4Checksum(p + 14, 20));

    BePut16(p + 34, (uint16_t)info.udp_src_port);
    BePut16(p + 36, (uint16_t)info.udp_dst_port);
    BePut16(p + 38, udp_len);
    BePut16(p + 40, 0);

    std::memcpy(p + 42, info.rx_payload, info.rx_len);

    uint16_t ucs = UdpChecksumIpv4(info.ipv4_src_addr, local_ip, p + 34, udp_len);
    BePut16(p + 40, ucs);
    return pkt;
}

inline void Manager::RewriteIpv4UdpInplace(std::vector<uint8_t>& d,
                                           uint64_t mac_src, uint64_t mac_dst,
                                           uint32_t ip_src,  uint32_t ip_dst,
                                           uint16_t udp_dst_port) {
    if (d.size() < 42)
        return;
    if (!((d[12] == 0x08) && (d[13] == 0x00)))
        return;
    size_t ip_off = 14;
    size_t ihl = (d[ip_off] & 0x0F) * 4;
    if (ihl < 20 || d.size() < ip_off + ihl + 8)
        return;
    if (d[ip_off + 9] != 17)
        return;

    auto wrmac = [&](size_t off, uint64_t mac) {
        d[off+0] = (uint8_t)((mac >> 40) & 0xFF);
        d[off+1] = (uint8_t)((mac >> 32) & 0xFF);
        d[off+2] = (uint8_t)((mac >> 24) & 0xFF);
        d[off+3] = (uint8_t)((mac >> 16) & 0xFF);
        d[off+4] = (uint8_t)((mac >> 8) & 0xFF);
        d[off+5] = (uint8_t)( mac        & 0xFF);
    };
    wrmac(0, mac_dst);
    wrmac(6, mac_src);

    d[ip_off + 12] = (uint8_t)((ip_src >> 24) & 0xFF);
    d[ip_off + 13] = (uint8_t)((ip_src >> 16) & 0xFF);
    d[ip_off + 14] = (uint8_t)((ip_src >> 8) & 0xFF);
    d[ip_off + 15] = (uint8_t)( ip_src        & 0xFF);

    d[ip_off + 16] = (uint8_t)((ip_dst >> 24) & 0xFF);
    d[ip_off + 17] = (uint8_t)((ip_dst >> 16) & 0xFF);
    d[ip_off + 18] = (uint8_t)((ip_dst >> 8) & 0xFF);
    d[ip_off + 19] = (uint8_t)( ip_dst        & 0xFF);

    d[ip_off + 10] = 0; d[ip_off + 11] = 0;
    uint16_t ipcs = Ipv4Checksum(&d[ip_off], ihl);
    d[ip_off + 10] = (uint8_t)((ipcs >> 8) & 0xFF);
    d[ip_off + 11] = (uint8_t)( ipcs       & 0xFF);

    size_t udp_off = ip_off + ihl;
    d[udp_off + 2] = (uint8_t)((udp_dst_port >> 8) & 0xFF);
    d[udp_off + 3] = (uint8_t)( udp_dst_port       & 0xFF);

    d[udp_off + 6] = 0; d[udp_off + 7] = 0;
    uint16_t ucs = UdpChecksumIpv4(ip_src, ip_dst, &d[udp_off], d.size() - udp_off);
    d[udp_off + 6] = (uint8_t)((ucs >> 8) & 0xFF);
    d[udp_off + 7] = (uint8_t)( ucs       & 0xFF);
}

inline std::string Manager::GetEnvOr(const char* key, const char* defval) {
    const char* v = std::getenv(key);
    if (v && *v)
        return std::string(v);
    return std::string(defval);
}

inline bool Manager::GetEnvBool(const char* key, bool defval) {
    const char* v = std::getenv(key);
    if (!v || !*v)
        return defval;
    if (v[0] == '0' || v[0] == 'n' || v[0] == 'N' || v[0] == 'f' || v[0] == 'F')
        return false;
    return true;
}

inline uint64_t Manager::GetEnvU64(const char* key, uint64_t defval) {
    const char* v = std::getenv(key);
    if (!v || !*v)
        return defval;
    char* end = nullptr;
    uint64_t parsed = std::strtoull(v, &end, 0);
    if (end && *end == '\0')
        return parsed;
    return defval;
}

inline uint64_t Manager::WireTicksFromFrameSize(size_t frame_body_len) {
    uint64_t ticks = frame_body_len;
    if (GetEnvBool("PCAP_TX_PREAMBLE", true)) {
        ticks += 8;
    }
    if (GetEnvBool("PCAP_TX_FCS", true)) {
        ticks += 4;
    }
    ticks += 1; // idle tick inserted between frames
    return ticks;
}

inline void Manager::ReplayPcap(udpIpPg &pUdp,
                                const char* path,
                                bool rewrite,
                                uint64_t mac_src,
                                uint64_t mac_dst,
                                uint32_t ip_src,
                                uint32_t ip_dst,
                                uint16_t udp_dst_port,
                                pcapio::Writer* tx_dump,
                                std::deque<uint64_t>* tx_times,
                                std::mutex* tx_mtx,
                                uint64_t sched_offset_ns,
                                MergeLogger* merge_logger) {
    pcapio::Reader r;
    if (!r.open(path)) {
        VPrint("PCAP: failed to open %s\n", path);
        return;
    }
    VPrint("PCAP: replaying %s (res=%s)\n", path,
           r.time_res() == pcapio::TimeRes::Nanos ? "ns" : "us");

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
        uint64_t tx_abs_ns = sched_offset_ns + delta_ns;
        uint64_t target_ticks = TicksForNs(delta_ns);
        if (target_ticks > waited_ticks) {
            uint64_t add = target_ticks - waited_ticks;
            for (uint64_t i = 0; i < add; ++i) {
                pUdp.UdpVpSendIdle(1);
            }
            waited_ticks += add;
        }

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

        if (rewrite) {
            RewriteIpv4UdpInplace(pkt.data, mac_src, mac_dst, ip_src, ip_dst, udp_dst_port);
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

        if (tx_dump && tx_dump->good()) {
            static uint32_t tns = 0;
            tx_dump->write(0, tns, pkt.data);
            tns += 1000;
        }

        if (merge_logger && merge_logger->enabled()) {
            merge_logger->log(tx_abs_ns, pkt.data);
        }

        if (tx_times && tx_mtx) {
            std::lock_guard<std::mutex> lk(*tx_mtx);
            tx_times->push_back(tx_abs_ns);
        }

        bool add_preamble = GetEnvBool("PCAP_TX_PREAMBLE", true);
        bool add_fcs      = GetEnvBool("PCAP_TX_FCS",      true);
        std::vector<uint8_t> tx;
        tx.reserve((add_preamble?8:0) + pkt.data.size() + (add_fcs?4:0));
        if (add_preamble) {
            for (int i = 0; i < 7; ++i) {
                tx.push_back(0x55);
            }
            tx.push_back(0xD5);
        }
        tx.insert(tx.end(), pkt.data.begin(), pkt.data.end());
        if (add_fcs) {
            uint32_t fcs = EthCrc32(pkt.data.data(), pkt.data.size());
            tx.push_back((uint8_t)(fcs & 0xFF));
            tx.push_back((uint8_t)((fcs >> 8) & 0xFF));
            tx.push_back((uint8_t)((fcs >> 16) & 0xFF));
            tx.push_back((uint8_t)((fcs >> 24) & 0xFF));
        }
        if (dbg_count < 5) {
            VPrint("  TX built len=%u (preamble=%u fcs=%u)\n", (unsigned)tx.size(), add_preamble?1:0, add_fcs?1:0);
        }

        const uint32_t len = (uint32_t)tx.size();
        std::vector<uint32_t> frame(len);
        for (uint32_t i = 0; i < len; ++i) {
            frame[i] = tx[i];
        }
        pUdp.UdpVpSendRawEthFrame(frame.data(), len);
        waited_ticks += (uint64_t)len + 1;
    }
    while (true)
        pUdp.UdpVpSendIdle(1);
}

inline void Manager::RegisterRecorder(udpIpPg &pUdp, RxRecorderCtx* ctx) {
    pUdp.registerUsrRxCbFunc(RxRecordCallback, ctx);
}

inline void Manager::RxRecordCallback(udpIpPg::rxInfo_t info, void* hdl) {
    auto *ctx = reinterpret_cast<RxRecorderCtx*>(hdl);
    if (!ctx)
        return;

    uint32_t ticks = 0;
    VRead(udpVProc::TICKS_ADDR, &ticks, true, (int)ctx->node_id);
    if (!ctx->started) {
        ctx->started    = true;
        ctx->last_tick  = ticks;
    }
    if (ticks < ctx->last_tick) {
        ctx->tick_wraps++;
    }
    ctx->last_tick = ticks;
    uint64_t rx_ticks64 = (ctx->tick_wraps << 32) | (uint64_t)ticks;
    uint64_t ts_ns_abs  = rx_ticks64 * GMII_TICK_NS;

    uint64_t tx_sched_abs = ctx->sched_offset_ns;
    if (ctx->tx_times && ctx->tx_mtx) {
        std::lock_guard<std::mutex> lk(*ctx->tx_mtx);
        if (!ctx->tx_times->empty()) {
            tx_sched_abs = ctx->tx_times->front();
            ctx->tx_times->pop_front();
        }
    }

    uint64_t min_ts = tx_sched_abs + ctx->min_latency_ns;

    std::vector<uint8_t> frame = BuildFallbackFrame(info, ctx->local_mac, ctx->local_ip);

    uint64_t frame_ticks = WireTicksFromFrameSize(frame.size());
    uint64_t frame_ns = frame_ticks * GMII_TICK_NS;
    uint64_t ts_ns_start = ts_ns_abs;
    if (ts_ns_start >= frame_ns) {
        ts_ns_start -= frame_ns;
    }
    if (ts_ns_start < min_ts) {
        ts_ns_start = min_ts;
    }

    VPrint("RX rec: len=%u src=%u.%u.%u.%u:%u -> dst=%u.%u.%u.%u:%u\n",
           (unsigned)frame.size(),
           (info.ipv4_src_addr >> 24) & 0xFF, (info.ipv4_src_addr >> 16) & 0xFF,
           (info.ipv4_src_addr >> 8) & 0xFF, info.ipv4_src_addr & 0xFF,
           info.udp_src_port,
           (ctx->local_ip >> 24) & 0xFF, (ctx->local_ip >> 16) & 0xFF,
           (ctx->local_ip >> 8) & 0xFF, ctx->local_ip & 0xFF,
           info.udp_dst_port);

    uint32_t ts_sec  = (uint32_t)(ts_ns_start / 1000000000ull);
    uint32_t ts_frac = (uint32_t)(ts_ns_start % 1000000000ull);
    ctx->writer.write(ts_sec, ts_frac, frame);

    if (ctx->merge_logger && ctx->merge_logger->enabled()) {
        ctx->merge_logger->log(ts_ns_start, frame);
    }
}

} // namespace pcapreplay
