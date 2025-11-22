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
#include "PcapReplay.h"

using pcapreplay::Manager;
using RxRecorderCtx = pcapreplay::Manager::RxRecorderCtx;

// Global TX start-time queues for mapping RX timestamps to TX schedule
static std::deque<uint64_t> g_tx_times_node2;
static std::mutex           g_tx_mtx_node2;
static std::deque<uint64_t> g_tx_times_node4;
static std::mutex           g_tx_mtx_node4;
static pcapreplay::MergeLogger g_merge_node2;
static pcapreplay::MergeLogger g_merge_node4;

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

static constexpr uint64_t NODE1_INIT_TICKS  = 1;
static constexpr uint64_t NODE3_INIT_TICKS  = 1;
static constexpr uint64_t NODE1_INIT_NS     = NODE1_INIT_TICKS * pcapreplay::GMII_TICK_NS;
static constexpr uint64_t NODE3_INIT_NS     = NODE3_INIT_TICKS * pcapreplay::GMII_TICK_NS;

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

    std::string in1 = Manager::GetEnvOr("PCAP_IN_1", "./rtl/pcap_reader_writer/test_udp_rand.pcap");
    VPrint("Node1: replaying %s\n", in1.c_str());
    bool rewrite = Manager::GetEnvBool("PCAP_REWRITE", true);
    static pcapio::Writer tx1;
    std::string tx1p = Manager::GetEnvOr("PCAP_TX_OUT_1", "./output/tx_node1.pcap");
    try {
        std::filesystem::create_directories(std::filesystem::path(tx1p).parent_path());
    } catch(...) {}
    tx1.open(tx1p, pcapio::TimeRes::Nanos);
    std::string merge2p = Manager::GetEnvOr("PCAP_MERGE_OUT_2", "./output/merge_node2.pcap");
    if (!merge2p.empty() && merge2p != "0")
        g_merge_node2.init(merge2p);
    Manager::ReplayPcap(pUdp, in1.c_str(), rewrite,
                        NODE1_MAC_ADDR, NODE2_MAC_ADDR,
                        NODE1_IPV4_ADDR, NODE2_IPV4_ADDR,
                        (uint16_t)NODE2_UDP_PORT,
                        &tx1,
                        &g_tx_times_node2,
                        &g_tx_mtx_node2,
                        NODE1_INIT_NS,
                        &g_merge_node2);
}

// ----------------------------------------------------------------------------
// VUserMain2: Node2 records to PCAP
// ----------------------------------------------------------------------------
extern "C" void VUserMain2(void) {
    VPrint("Node2: PCAP record init\n");
    udpIpPg pUdp(2, NODE2_IPV4_ADDR, NODE2_MAC_ADDR, NODE2_UDP_PORT);

    std::string out2 = Manager::GetEnvOr("PCAP_OUT_2", "./output/node2_out.pcap");
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
    ctx2.min_latency_ns  = Manager::GetEnvU64("PCAP_MIN_LATENCY_NS", 0);
    ctx2.merge_logger    = &g_merge_node2;
    ctx2.local_mac = NODE2_MAC_ADDR;
    ctx2.local_ip  = NODE2_IPV4_ADDR;
    Manager::RegisterRecorder(pUdp, &ctx2);
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

    std::string in3 = Manager::GetEnvOr("PCAP_IN_1", "./rtl/pcap_reader_writer/test_udp_rand.pcap");
    VPrint("Node3: replaying %s\n", in3.c_str());
    bool rewrite = Manager::GetEnvBool("PCAP_REWRITE", true);
    static pcapio::Writer tx3;
    std::string tx3p = Manager::GetEnvOr("PCAP_TX_OUT_3", "./output/tx_node3.pcap");
    try {
        std::filesystem::create_directories(std::filesystem::path(tx3p).parent_path());
    } catch(...) {}
    tx3.open(tx3p, pcapio::TimeRes::Nanos);
    std::string merge4p = Manager::GetEnvOr("PCAP_MERGE_OUT_4", "./output/merge_node4.pcap");
    if (!merge4p.empty() && merge4p != "0")
        g_merge_node4.init(merge4p);
    Manager::ReplayPcap(pUdp, in3.c_str(), rewrite,
                        NODE3_MAC_ADDR, NODE4_MAC_ADDR,
                        NODE3_IPV4_ADDR, NODE4_IPV4_ADDR,
                        (uint16_t)NODE4_UDP_PORT,
                        &tx3,
                        &g_tx_times_node4,
                        &g_tx_mtx_node4,
                        NODE3_INIT_NS,
                        &g_merge_node4);
}

// ----------------------------------------------------------------------------
// VUserMain4: Node4 records to PCAP
// ----------------------------------------------------------------------------
extern "C" void VUserMain4(void) {
    VPrint("Node4: PCAP record init\n");
    udpIpPg pUdp(4, NODE4_IPV4_ADDR, NODE4_MAC_ADDR, NODE4_UDP_PORT);

    std::string out4 = Manager::GetEnvOr("PCAP_OUT_4", "./output/node4_out.pcap");
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
    ctx4.min_latency_ns  = Manager::GetEnvU64("PCAP_MIN_LATENCY_NS", 0);
    ctx4.merge_logger    = &g_merge_node4;
    ctx4.local_mac = NODE4_MAC_ADDR;
    ctx4.local_ip  = NODE4_IPV4_ADDR;
    Manager::RegisterRecorder(pUdp, &ctx4);
    while (true)
        pUdp.UdpVpSendIdle(1);
}
