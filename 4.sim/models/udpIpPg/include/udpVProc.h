// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2024 -2025 Simon Southwell. All rights reserved.
//
// Date: 19th December 2024
//
// Class for UDP/IPv4 packet generation access to udp_ip_pg.v
// VProc based Verilog component.
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

#ifndef _UDP_VPROC_H_
#define _UDP_VPROC_H_

#include <stdio.h>
#include <stdint.h>

extern "C" {
#include "VUser.h"
}

class udpVProc
{

protected :

    // Virtual method, provided by derived class, where received data is sent
    virtual uint32_t processFrame (uint32_t* rx_buf, uint32_t rx_len) = 0;

    // The VProc node for the udpClient HDL model
    int              node;

public:

    // --------------------------------------------
    // Static constants
    // --------------------------------------------

    // udpClient VProc address offsets
    static const uint32_t TXD_ADDR             = 0;
    static const uint32_t TXC_ADDR             = 1;
    static const uint32_t TICKS_ADDR           = 2;
    static const uint32_t HALT_ADDR            = 3;

    // Ethernet tags and frame delimeters
    static const uint32_t IDLE                 = 0x07;
    static const uint32_t SOF                  = 0xfb;
    static const uint32_t EoF                  = 0xfd;
    static const uint32_t PREAMBLE             = 0x55;
    static const uint32_t SFD                  = 0xd5;

    static const uint32_t RX_VALID_MASK        = 0x01;
    static const uint32_t RX_ERROR_MASK        = 0x02;
    static const uint32_t TX_ERROR_MASK        = 0x100;
    static const uint32_t TX_CTRL_IDLE         = 0x00;
    static const uint32_t TX_CTRL_VALID        = 0x01;
    static const uint32_t TX_CTRL_ERROR        = 0x03;

    // Ethernet parameters and header dimensions
    static const uint32_t ETH_MTU              = 1500;
    static const uint32_t ETH_PREAMBLE         = 8;  // BYTES
    static const uint32_t ETH_802_1Q_LEN       = 4;  // BYTES
    static const uint32_t ETH_CRC_LEN          = 4;  // BYTES
    static const uint32_t ETH_HDR_LEN          = 14; // BYTES

    // --------------------------------------------
    // Constructor
    // --------------------------------------------

    udpVProc(int nodeIn) : node(nodeIn)
    {
        currTickCount                  = 0xffffffff;
        receiving_frame                = false;
        rx_idx                         = 0;
    };

    // --------------------------------------------------
    // Method to idle for specified number of cycles
    // --------------------------------------------------

    uint32_t UdpVpSendIdle(uint32_t ticks)
    {
        uint32_t error = 0;
        uint32_t currTicks;

        VWrite(TXD_ADDR, IDLE,         true, node);
        VWrite(TXC_ADDR, TX_CTRL_IDLE, true, node);

        // Get start time
        for (int idx = 0; idx < ticks; idx++)
        {
            VRead(TICKS_ADDR, &currTicks, true, node);

            UdpVpExtractRx();
        }

        return error;
    }

    // --------------------------------------------------
    // Method to send a pre-prepared (raw) ethernet frame
    // --------------------------------------------------
    uint32_t UdpVpSendRawEthFrame(uint32_t* frame, uint32_t len)
    {
        uint32_t error = 0;

        // Construct 64 bit TXD words and associated TXC byte from frame data,
        // flushed to 64 bit boundary
        for (int idx = 0; idx < len; idx++)
        {
            // Send out byte
            VWrite(TXD_ADDR, frame[idx] & 0xff, true, node);

            // TX control bit
#ifdef GENERATE_SOF_EOF
            uint32_t txc = (frame[idx] & TX_ERROR_MASK) ? TX_CTRL_ERROR : (idx == 0 || idx == (len-1)) ? 0 : TX_CTRL_VALID;
#else
            uint32_t txc = (frame[idx] & TX_ERROR_MASK) ? TX_CTRL_ERROR : TX_CTRL_VALID;
#endif
            VWrite(TXC_ADDR, txc, true, node);

            // Extract RX data and advance tick
            UdpVpExtractRx();
        }

        UdpVpSendIdle(1);

        return error;
    }

    // --------------------------------------------------
    // Method to set the halt output signal
    // --------------------------------------------------
    void UdpVpSetHalt(uint32_t val) {VWrite(HALT_ADDR, val & 0x1, false, node);}

private:

    // --------------------------------------------------
    // Method to extract received data from VProc input
    // interface.
    // --------------------------------------------------
    void UdpVpExtractRx ()
    {
        uint32_t rxd, rxc;
        uint32_t clk_count;
        bool     error_detected;

        // If the current tick count is uninitialised, fetch clock tick count from the HDL,
        // else increment for each read cycle.
        if (currTickCount == 0xffffffff)
        {
            VRead(TICKS_ADDR, &currTickCount, true, node);
        }
        else
        {
            currTickCount++;
        }

        // Read the input pins: the 8 bits of data and 2 of control
        VRead(TXD_ADDR, &rxd,     true,  node);
        VRead(TXC_ADDR, &rxc,     false, node);

        // Extract the data byte, with bit 8 as the control bit
        uint32_t rxbyte = rxd & 0xff;

        // If not receiving a frame already, and a new frame detected,
        // flag receiving and reset the RX buffer index
        if (!receiving_frame && (rxc & RX_VALID_MASK))
        {
            receiving_frame = true;
            error_detected  = false;
            rx_idx          = 0;
        }

        // If receving a frame...
        if (receiving_frame)
        {
            // If an end-of-frame detected, clear the receiving frame state, and call the
            // method to process the data,
            if (!(rxc & RX_VALID_MASK))
            {
                receiving_frame = false;

                // Calculate length of preamble and SFD (could be variable)
                int pidx = 0;
                while (rx_buf[pidx] == PREAMBLE || rx_buf[pidx] == SFD)
                {
                    pidx++;
                }

                // Process input if no errors were seen
                if (!error_detected)
                {
                    // Process input, subtracting the Premable and SFD
                    processFrame(&rx_buf[pidx], rx_idx-pidx);
                }
            }
            // Whilst receiving a frame, place it in the receive buffer
            else
            {
                error_detected |= rxc & RX_ERROR_MASK;
                if (rx_idx == (ETH_MTU + ETH_HDR_LEN + ETH_PREAMBLE + ETH_CRC_LEN + ETH_802_1Q_LEN))
                {
                    printf("WARNING: received packet of maximum size without completing frame. Terminating packet\n");
                    receiving_frame = false;
                    error_detected  = true;
                }
                else
                {
                    rx_buf[rx_idx++] = rxbyte;
                }
            }
        }
    }

    // -------------------------------------------------
    // Private member variables
    // -------------------------------------------------

    // Clock tick count (nominally at 6.4ns) to give timing
    uint32_t       currTickCount;

    // State flag to indicate actively receiving data
    bool           receiving_frame;

    // Receive buffer and index. Buffer size is the maximum for largest payload, plus headers
    uint32_t       rx_buf[ETH_MTU + ETH_HDR_LEN + ETH_PREAMBLE + ETH_CRC_LEN + ETH_802_1Q_LEN];
    uint32_t       rx_idx;

};

#endif
