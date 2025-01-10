//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 3rd January 2025
//
// Class to format and print out a UDP packet from a received
// rxInfo_t packet. Meant to be inherited by the UDP test
// classes.
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#ifndef _UDP_PRINT_PKT_
#define _UDP_PRINT_PKT_

#include "udpIpPg.h"

class udpPrintPkt
{
public:
    // Constructor
    udpPrintPkt() {};

    // Method to print out formatted receive data
    void printRxPkt(udpIpPg::rxInfo_t &rx_info, int nodenum)
    {

#ifdef NEWPREFIX
        sprintf(strbuf, "%s(%d)%s%s(%d)", (nodenum ? "client" : "server"),
                                           nodenum ^ 1,
                                           "=>",
                                          (nodenum ? "server" : "client"),
                                           nodenum);
#else
        sprintf(strbuf, "Node%d", nodenum);
#endif

        VPrint("%s: Source MAC Addr...........: ", strbuf);
        for (int idx = 0; idx < 6; idx++)
        {
            VPrint("%02lX", (unsigned long)((rx_info.mac_src_addr >> 8*(5-idx)) & 0xff));
            if (idx != 5)
                VPrint("-");
            else
                VPrint("\n");
        }

        VPrint("%s: Source IPv4 Addr..........: ", strbuf);
        for (int idx = 0; idx < 4; idx++)
        {
            VPrint("%02d", (rx_info.ipv4_src_addr >> 8*(3-idx)) & 0xff);
            if (idx != 3)
                VPrint(".");
            else
                VPrint("\n");
        }

        VPrint("%s: Source UDP port...........: 0x%04x\n", strbuf, rx_info.udp_src_port);
        VPrint("%s: Destination UDP port......: 0x%04x\n", strbuf, rx_info.udp_dst_port);

        VPrint("\n");
    }
private:

    char strbuf[1024];

};

#endif