// =============================================================
//
// VProc user code for WireGuard test bench udpPgIp BFM nodes
//
// Copyright (c) 2025 Simon Southwell. Confidential
//
// This file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this file. If not, see <http://www.gnu.org/licenses/>.
//
// =============================================================

#include <cstdio>
#include <cstdint>
#include "VProcClass.h"
#include "udpIpPg.h"

// ----------------------------------------------------------------------------
// Node definitions: MAC/IP/UDP ports
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

#define PAYLOAD_LEN      64
#define PKT_BUF_SIZE     (2*1024)

static uint8_t  payload[PKT_BUF_SIZE];
static uint32_t frmBuf[PKT_BUF_SIZE];

// ----------------------------------------------------------------------------
// Generic RX callback: print packet info
// ----------------------------------------------------------------------------
static void rxCallback(udpIpPg::rxInfo_t info) {
    std::printf("\n=== Received packet on node %u ===\n", info.udp_dst_port == NODE2_UDP_PORT ? 2u : 4u);
    std::printf("  MAC src      = %012lX\n", (unsigned long)info.mac_src_addr);
    std::printf("  IPv4 src     = %08X\n", info.ipv4_src_addr);
    std::printf("  UDP src port = %04X\n", info.udp_src_port);
    std::printf("  UDP dst port = %04X\n", info.udp_dst_port);
    std::printf("  Payload (%u bytes):\n", info.rx_len);
    for (uint32_t i = 0; i < info.rx_len; ++i) {
        std::printf(" %02X", info.rx_payload[i]);
        if ((i & 0xF) == 0xF) std::printf("\n");
    }
    std::printf("\n=== End receive ===\n");
}

// ----------------------------------------------------------------------------
// VUserMain1: Node1 sends to Node2
// ----------------------------------------------------------------------------
extern "C" void VUserMain1(void) {
    VPrint("Node1: initializing packet generator\n");
    udpIpPg pUdp(1, NODE1_IPV4_ADDR, NODE1_MAC_ADDR, NODE1_UDP_PORT);

    VPrint("Node1: delaying 1ms for init...\n");
    for (int i = 0; i < 125000; ++i) pUdp.UdpVpSendIdle(1);

    for (uint32_t i = 0; i < PAYLOAD_LEN; ++i) payload[i] = uint8_t(i);

    udpIpPg::udpConfig_t cfg;
    cfg.mac_dst_addr = NODE2_MAC_ADDR;
    cfg.ip_dst_addr  = NODE2_IPV4_ADDR;
    cfg.dst_port     = NODE2_UDP_PORT;

    uint32_t frameLen = pUdp.genUdpIpPkt(cfg, frmBuf, reinterpret_cast<uint32_t*>(payload), PAYLOAD_LEN);
    VPrint("Node1: frameLen = %u bytes\n", frameLen);

    std::printf("Node1: sending frame bytes:\n");
    for (uint32_t i = 0; i < frameLen; ++i) {
        printf("%02X ", frmBuf[i] & 0xFF);
        if ((i & 0xF) == 0xF) printf("\n");
    }
    std::printf("\n");

    pUdp.UdpVpSendRawEthFrame(frmBuf, frameLen);
    VPrint("Node1: frame sent to Node2\n");

    while (true) pUdp.UdpVpSendIdle(1);
}

// ----------------------------------------------------------------------------
// VUserMain2: Node2 receives
// ----------------------------------------------------------------------------
extern "C" void VUserMain2(void) {
    VPrint("Node2: initializing receiver\n");
    udpIpPg pUdp(2, NODE2_IPV4_ADDR, NODE2_MAC_ADDR, NODE2_UDP_PORT);
    pUdp.registerUsrRxCbFunc([](udpIpPg::rxInfo_t info, void*){ rxCallback(info); }, nullptr);
    while (true) pUdp.UdpVpSendIdle(1);
}

// ----------------------------------------------------------------------------
// VUserMain3: Node3 sends to Node4
// ----------------------------------------------------------------------------
extern "C" void VUserMain3(void) {
    VPrint("Node3: initializing packet generator\n");
    udpIpPg pUdp(3, NODE3_IPV4_ADDR, NODE3_MAC_ADDR, NODE3_UDP_PORT);
    VPrint("Node3: delaying 1ms for init...\n");

    for (int i = 0; i < 250000; ++i) pUdp.UdpVpSendIdle(1);
    for (uint32_t i = 0; i < PAYLOAD_LEN; ++i) payload[i] = uint8_t(i);

    udpIpPg::udpConfig_t cfg3{NODE4_UDP_PORT, NODE4_IPV4_ADDR, NODE4_MAC_ADDR};

    uint32_t frameLen = pUdp.genUdpIpPkt(cfg3, frmBuf, reinterpret_cast<uint32_t*>(payload), PAYLOAD_LEN);

    VPrint("Node3: frameLen = %u bytes\n", frameLen);

    std::printf("Node3: sending frame bytes:\n");
    for (uint32_t i = 0; i < frameLen; ++i) {
        printf("%02X ", frmBuf[i] & 0xFF);
        if ((i & 0xF) == 0xF) printf("\n");
    }
    std::printf("\n");

    pUdp.UdpVpSendRawEthFrame(frmBuf, frameLen);
    VPrint("Node3: frame sent to Node4\n");

    while (true) pUdp.UdpVpSendIdle(1);
}

// ----------------------------------------------------------------------------
// VUserMain4: Node4 receives
// ----------------------------------------------------------------------------
extern "C" void VUserMain4(void) {
    VPrint("Node4: initializing receiver\n");
    udpIpPg pUdp(4, NODE4_IPV4_ADDR, NODE4_MAC_ADDR, NODE4_UDP_PORT);
    pUdp.registerUsrRxCbFunc([](udpIpPg::rxInfo_t info, void*){ rxCallback(info); }, nullptr);
    while (true) pUdp.UdpVpSendIdle(1);
}
