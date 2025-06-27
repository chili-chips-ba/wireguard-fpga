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

#include <stdio.h>
#include <stdint.h>

#include "VProcClass.h"

// ----------------------------------------------------------------------------
// VProc node main entry points for udpIpPg nodes
// ----------------------------------------------------------------------------

// these must match the Verilog defines
#define TXD_ADDR   0x0
#define TXC_ADDR   0x1
#define HLT_ADDR   0x3

extern "C" void VUserMain1(void)
{
    const int node = 1;

    VPrint("UDP/IPv4 node %d\n\n", node);

    VProc* vp = new VProc(node);

    static uint8_t pkt[] = {
        // Dest MAC
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        // Src MAC
        0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
        // EtherType (0x0800 – IPv4)
        0x08, 0x00,
        // Payload
        0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,
        0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,
        0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,
        0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,
        // FCS/CRC32
        0xAB, 0x15, 0x36, 0xC7
    };
    const size_t len = sizeof(pkt);

    const uint32_t SEND_BITS = 0x1;

    while(true) {
        for (size_t i = 0; i < len; ++i) {
            vp->write(TXD_ADDR, pkt[i]);
            vp->write(TXC_ADDR, SEND_BITS);
        }
    }

    VPrint("UDP‐PG done sending %u bytes\n", (unsigned)len);

    vp->write(HLT_ADDR, 1);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}

extern "C" void VUserMain2(void)
{
    const int node = 2;

    VPrint("UDP/IPv4 node %d\n\n", node);

    // Create VProc access object for this node
    VProc* vp = new VProc(node);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}

extern "C" void VUserMain3(void)
{
    const int node = 3;

    VPrint("UDP/IPv4 node %d\n\n", node);

    // Create VProc access object for this node
    VProc* vp = new VProc(node);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}
extern "C" void VUserMain4(void)
{
    const int node = 4;

    VPrint("UDP/IPv4 node %d\n\n", node);

    // Create VProc access object for this node
    VProc* vp = new VProc(node);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}