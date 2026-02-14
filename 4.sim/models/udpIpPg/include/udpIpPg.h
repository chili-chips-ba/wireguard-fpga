// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2024 - 2025 Simon Southwell. All rights reserved.
//
// Date: 19th December 2024
//
// Class header for UDP/IPv4 packet generation
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

#ifndef _UDP_IP_PG_H_
#define _UDP_IP_PG_H_

#include <stdio.h>
#include <stdint.h>

#include "udpVProc.h"

class udpIpPg  : public udpVProc
{
public:

    // --------------------------------------------
    // Static constants
    // --------------------------------------------

    // Version
    static const uint32_t major_version        = 1;
    static const uint32_t minor_version        = 0;
    static const uint32_t patch_version        = 5;

    // CRC32 parameters
    static const uint32_t POLY                 = 0xEDB88320;  /* 0x04C11DB7 bit reversed */
    static const uint32_t INIT                 = 0xFFFFFFFF;

    // Nominal 10G clock frequency (Hz)
    static const uint32_t CLK10G_FREQ          = 156250000;

    // IPv4 parameters
    static const uint32_t IPV4_MULTICAST_ADDR  = 0x00000000;
    static const uint32_t IPV4_SUBNET_MASK     = 0xffffffff;
    static const uint32_t IPV4_MIN_HDR_LEN     = 5;  // DWORDS
    static const uint32_t IPV4_SRC_ADDR_OFFSET = 3;  // DWORDS

    // UDP parameters
    static const uint32_t IPV4_DST_ADDR_OFFSET = 4;  // DWORDS
    static const uint32_t UDP_MIN_HDR_LEN      = 2;  // DWORDS
    static const uint32_t UDP_CHKSUM_OFFSET    = 6; // BYTES
    static const uint32_t UDP_PROTOCOL_NUM     = 17;

    // Receiver error masks
    static const uint32_t RX_BAD_CRC           = 0x0001;
    static const uint32_t RX_WRONG_MAC_ADDR    = 0x0002;
    static const uint32_t RX_BAD_IPV4_CHECKSUM = 0x0004;
    static const uint32_t RX_WRONG_IPV4_ADDR   = 0x0008;
    static const uint32_t RX_BAD_UDP_CHECKSUM  = 0x0010;
    static const uint32_t RX_WRONG_UDP_PORT    = 0x0020;

    // --------------------------------------------
    // Type definitions
    // --------------------------------------------

    // Structure for received packet information
    typedef struct {
        uint64_t mac_src_addr;
        uint32_t ipv4_src_addr;
        uint32_t udp_src_port;
        uint32_t udp_dst_port;
        uint8_t  rx_payload[ETH_MTU];
        uint32_t rx_len;
    } rxInfo_t;

    // Structure definition for transmit parameters
    typedef class {
    public:
        // UDP controls
        uint32_t dst_port;

        // IPV4 parameters
        uint32_t ip_dst_addr ;

        // MAC parameters
        uint64_t mac_dst_addr;
    } udpConfig_t;

    // Type definition for user callback function to receive packets
    typedef void (*pUsrRxCbFunc_t) (rxInfo_t rx_info, void* hdl);

    // --------------------------------------------
    // Constructor
    // --------------------------------------------

    udpIpPg  (uint32_t nodeIn, uint32_t ipv4AddrIn, uint64_t macAddrIn, uint32_t udpPortIn) :
                                        udpVProc(nodeIn),
                                        ipv4_addr(ipv4AddrIn),
                                        mac_addr(macAddrIn),
                                        udp_port(udpPortIn)
    {
        usrRxCbFunc                    = NULL;
    };

    // --------------------------------------------
    // Public methods
    // --------------------------------------------

    // Function to register user callback function to receive packets
    void           registerUsrRxCbFunc (pUsrRxCbFunc_t pFunc, void* hdlIn) { usrRxCbFunc = pFunc; hdl = hdlIn;};

    // Method to generate a UDP/IPv4 packet
    uint32_t       genUdpIpPkt         (udpConfig_t &cfg, uint32_t* frm_buf, uint32_t* payload, uint32_t payload_len);

    void           getVersionString    (char* version_str, uint32_t maxlen = 12) {
                                            snprintf(version_str, maxlen, "%d.%d.%d", major_version, minor_version, patch_version);}

private:

    // --------------------------------------------
    // Private methods
    // --------------------------------------------

    // Method to construct an ethernet frame with (optional) payload
    uint32_t       ethFrame            (uint32_t* eth_frame,  uint32_t* payload, uint32_t payload_len, uint64_t dst_addr);


    // Method to construct an IPV4 frame with (optional) payload
    uint32_t       ipv4Frame           (uint32_t* ipv4_frame,
                                        uint32_t* payload,
                                        uint32_t  payload_len,
                                        uint32_t  ipv4_dst_addr,
                                        bool      add_udp_chksum = true);

    // Method to construct a UDP segment with (optional) payload
    uint32_t       udpSegment          (uint32_t* udp_seg,
                                        uint32_t* payload,
                                        uint32_t  payload_len,
                                        uint32_t  dst_port);

    // Method for processing raw receive data
    uint32_t       processFrame        (uint32_t* rx_buff, uint32_t rx_len);

    // Ethernet CR32 calculation method
    uint32_t       crc32               (uint32_t* buf, uint32_t len, uint32_t poly = POLY, uint32_t init = INIT, bool debug = false);

    // Method to calculate IP4v checksum. Also used (in ipv4frame) to calculate UDP checksum
    uint32_t       ipv4_chksum         (uint32_t* buf, uint32_t len, bool debug = false);

    // Method to extract receive data
    void           extractRx           (void);

    // --------------------------------------------
    // Private member variables
    // --------------------------------------------

    // This node's UDP port number
    uint32_t       udp_port;

    // This node's IPV4 address
    uint32_t       ipv4_addr;

    // This node's MAC address
    uint64_t       mac_addr;

    // Pointer to the user's receive callback function
    pUsrRxCbFunc_t usrRxCbFunc;

    // Handle passed in with callback registration as pointer to calling class instance ('this' pointer).
    // Used to reference specific instances' methods and member variables.
    void*          hdl;
};

#endif
