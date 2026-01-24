// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 3rd January 2025
//
// Class definition of UDP server example test program
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

#ifndef _UDP_TEST_BASE_H_
#define _UDP_TEST_BASE_H_

#include "udpPrintPkt.h"

class udpTestBase : public udpPrintPkt
{
public:


                     udpTestBase(int nodeIn) : node(nodeIn), pUdp(NULL)
                     {
                     };

    // Virtual function to be provided by the derived test class
    virtual uint32_t runTest     () = 0;

    // Simulation control methods
    void            sleepForever() {if (pUdp != NULL) while(true) pUdp->UdpVpSendIdle(20000000);};
    void            haltSim     () {if (pUdp != NULL) pUdp->UdpVpSetHalt(1);};

    // Callback function needs to be static to allow it to be used as an
    // argument in the callback registration function. It will be passed
    // the 'this' pointer of its class object in hdl, so can access methods
    // via this pointer.
    static void     rxCallback (udpIpPg::rxInfo_t rx_info, void* hdl)
    {

        // Display the received packet
        ((udpTestBase*)hdl)->printRxPkt(rx_info, ((udpTestBase*)hdl)->node);

        // Append packet to the receive queue
        ((udpTestBase*)hdl)->rxQueue.push_back(rx_info);
    }

protected:
    // Node number of this object
    int                            node;

    // Pointer to the UDP/IP packet generator object
    udpIpPg*                       pUdp;

    // Receiver queue
    std::vector<udpIpPg::rxInfo_t> rxQueue;

};

#endif
