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
// Description:
//   Network protocol stack library
//==========================================================================

#include "network.h"

/**********************************************************************
 * Function:    net_str_parse_ip()
 *
 * Description: Parses IP address from string (xxx.xxx.xxx.xxx)
 *
 * Returns:     1 if successful, 0 otherwise
 * write function without using scanf sscanf from stdlib
 **********************************************************************/
uint8_t net_str_parse_ip(const char* str, ip_t *ip) {
   int part = 0;
   int value = 0;
   ip_t temp_ip = {0, 0, 0, 0};
   while (*str != '\n' && *str != '\0') {
      if (*str >= '0' && *str <= '9') {
         value = value * 10 + (*str - '0');
         if (value > 255) {
            return 0; // Invalid value
         }
      } else if (*str == '.') {
         if (part >= 3) {
            return 0; // Too many parts
         }
         temp_ip[part++] = (uint8_t)value;
         value = 0;
      } else {
         return 0; // Invalid character
      }
      str++;
   }
   if (part != 3) {
      return 0; // Not enough parts
   }
   (*ip)[0] = temp_ip[0];
   (*ip)[1] = temp_ip[1];
   (*ip)[2] = temp_ip[2];
   (*ip)[3] = (uint8_t)value;
   return 1; // Success
}

/**********************************************************************
 * Function:    net_calculate_checksum()
 *
 * Description: Calculates 16-bit one's complement checksum
 *
 * Returns:     Checksum
 **********************************************************************/
uint16_t net_calculate_checksum(const uint8_t *data, size_t len) {
   uint32_t sum = 0;

   size_t i;
   for (i = 0; i + 1 < len; i += 2) {
      uint16_t word = ((uint16_t)data[i] << 8) | data[i + 1];
      sum += word;

      if (sum > 0xFFFF) {
         sum = (sum & 0xFFFF) + 1;
      }
   }

   if (i < len) {
      uint16_t word = ((uint16_t)data[i] << 8);
      sum += word;

      if (sum > 0xFFFF) {
         sum = (sum & 0xFFFF) + 1;
      }
   }

   return (uint16_t)(~sum & 0xFFFF);
}

/**********************************************************************
 * Function:    net_parse_packet_header()
 *
 * Description: Parses Ethernet packet header
 *
 * Returns:     Protocol type
 **********************************************************************/
net_protocol_t net_parse_packet_header (eth_raw_packet_t* packet) {
   net_hdr_eth_t* hdr_eth = (net_hdr_eth_t*)(packet->payload);
   net_hdr_ipv4_t* hdr_ipv4 = (net_hdr_ipv4_t*)(packet->payload + sizeof(net_hdr_eth_t));
   if (hdr_eth->ethertype[0] == 0x08 && hdr_eth->ethertype[1] == 0x06) {
      return NET_PROTO_ARP;
   } else if (hdr_eth->ethertype[0] == 0x08 && hdr_eth->ethertype[1] == 0x00 && hdr_ipv4->version == 4) {
      if (hdr_ipv4->protocol == 1) {
         return NET_PROTO_ICMP;
      } else if (hdr_ipv4->protocol == 17) {
         return NET_PROTO_UDP;
      }
   }
   return NET_PROTO_UNKNOWN;
}

/**********************************************************************
 * Function:    net_process_arp()
 *
 * Description: Executes Address Resolution Protocol by:
 *               - processing ARP request, and generating ARP reply, or
 *               - processing ARP reply, and updating ARP cache
 * Returns:     1 if ARP reply is generated, 0 otherwise
 **********************************************************************/
uint8_t net_process_arp (net_config_t*     config,
                         net_arp_cache_t*  arp_cache,
                         eth_raw_packet_t* rx_packet,
                         eth_raw_packet_t* tx_packet) {
   // Get Ethernet and ARP headers to RX and TX packets
   net_hdr_eth_t* rx_hdr_eth = (net_hdr_eth_t*)(rx_packet->payload);
   net_hdr_arp_t* rx_hdr_arp = (net_hdr_arp_t*)(rx_packet->payload + sizeof(net_hdr_eth_t));
   net_hdr_eth_t* tx_hdr_eth = (net_hdr_eth_t*)(tx_packet->payload);
   net_hdr_arp_t* tx_hdr_arp = (net_hdr_arp_t*)(tx_packet->payload + sizeof(net_hdr_eth_t));
   // Check if hardware type is Ethernet (0x0001)
   if (rx_hdr_arp->htype[0] != 0x00 || rx_hdr_arp->htype[1] != 0x01) {
      return 0;
   }
   // Check if protocol type is IPv4 (0x0800)
   if (rx_hdr_arp->ptype[0] != 0x08 || rx_hdr_arp->ptype[1] != 0x00) {
      return 0;
   }
   // Check if targeted to my IP
   if (memcmp(rx_hdr_arp->tpa, config->ip, 4) != 0) {
      return 0;
   }
   // Check if opcode is request (0x0001)
   if (rx_hdr_arp->oper[0] == 0x00 && rx_hdr_arp->oper[1] == 0x01) {
      // Assemble ARP reply
      tx_packet->dst = rx_packet->src;
      tx_packet->bypass_all = 1;
      tx_packet->len = 42;
      memcpy(tx_hdr_eth->dst_mac, rx_hdr_arp->sha, 6);
      memcpy(tx_hdr_eth->src_mac, config->mac, 6);
      tx_hdr_eth->ethertype[0] = 0x08;
      tx_hdr_eth->ethertype[1] = 0x06;
      tx_hdr_arp->htype[0] = 0x00;
      tx_hdr_arp->htype[1] = 0x01;
      tx_hdr_arp->ptype[0] = 0x08;
      tx_hdr_arp->ptype[1] = 0x00;
      tx_hdr_arp->hlen = 0x06;
      tx_hdr_arp->plen = 0x04;
      tx_hdr_arp->oper[0] = 0x00;
      tx_hdr_arp->oper[1] = 0x02;
      memcpy(tx_hdr_arp->sha, config->mac, 6);
      memcpy(tx_hdr_arp->spa, config->ip, 4);
      memcpy(tx_hdr_arp->tha, rx_hdr_arp->sha, 6);
      memcpy(tx_hdr_arp->tpa, rx_hdr_arp->spa, 4);
      return 1;
   // else, check if opcode is response (0x0002)
   } else if (rx_hdr_arp->oper[0] == 0x00 && rx_hdr_arp->oper[1] == 0x02) {
      // TODO: update ARP cache
   }
   return 0;
}

/**********************************************************************
 * Function:    net_process_icmp()
 *
 * Description: Executes Internet Control Message Protocol by:
 *               - processing ICMP Echo, and generating Echo reply
 * Returns:     1 if ICMP Echo reply is generated, 0 otherwise
 **********************************************************************/
uint8_t net_process_icmp (net_config_t*     config,
                          eth_raw_packet_t* rx_packet,
                          eth_raw_packet_t* tx_packet) {
   // Get Ethernet, IPv4 and ICMP headers to RX and TX packets
   net_hdr_eth_t* rx_hdr_eth = (net_hdr_eth_t*)(rx_packet->payload);
   net_hdr_ipv4_t* rx_hdr_ipv4 = (net_hdr_ipv4_t*)(rx_packet->payload + sizeof(net_hdr_eth_t));
   net_hdr_icmp_t* rx_hdr_icmp = (net_hdr_icmp_t*)(rx_packet->payload + sizeof(net_hdr_eth_t) + sizeof(net_hdr_ipv4_t));
   net_hdr_eth_t* tx_hdr_eth = (net_hdr_eth_t*)(tx_packet->payload);
   net_hdr_ipv4_t* tx_hdr_ipv4 = (net_hdr_ipv4_t*)(tx_packet->payload + sizeof(net_hdr_eth_t));
   net_hdr_icmp_t* tx_hdr_icmp = (net_hdr_icmp_t*)(tx_packet->payload + sizeof(net_hdr_eth_t) + sizeof(net_hdr_ipv4_t));
   uint16_t checksum;
   // Check if targeted to my IP
   if (memcmp(rx_hdr_ipv4->daddr, config->ip, 4) != 0) {
      return 0;
   }
   // Check if type is Echo request
   if (rx_hdr_icmp->type == 0x08 && rx_hdr_icmp->code == 0x00) {
      // Assemble ICMP Echo reply
      tx_packet->dst = rx_packet->src;
      tx_packet->bypass_all = 1;
      tx_packet->len = rx_packet->len;
      memcpy(tx_hdr_eth->dst_mac, rx_hdr_eth->src_mac, 6);
      memcpy(tx_hdr_eth->src_mac, config->mac, 6);
      tx_hdr_eth->ethertype[0] = 0x08;
      tx_hdr_eth->ethertype[1] = 0x00;
      tx_hdr_ipv4->ihl = 5;
      tx_hdr_ipv4->version = 4;
      tx_hdr_ipv4->tos = 0x00;
      tx_hdr_ipv4->tot_len[0] = rx_hdr_ipv4->tot_len[0];
      tx_hdr_ipv4->tot_len[1] = rx_hdr_ipv4->tot_len[1];
      tx_hdr_ipv4->id[0] = 0x00;
      tx_hdr_ipv4->id[1] = 0x00;
      tx_hdr_ipv4->frag_off = 0;
      tx_hdr_ipv4->ttl = 0xFF;
      tx_hdr_ipv4->protocol = 1;
      tx_hdr_ipv4->check[0] = 0x00;
      tx_hdr_ipv4->check[1] = 0x00;
      memcpy(tx_hdr_ipv4->saddr, config->ip, 4);
      memcpy(tx_hdr_ipv4->daddr, rx_hdr_ipv4->saddr, 4);
      checksum = net_calculate_checksum((uint8_t*)(tx_packet->payload + sizeof(net_hdr_eth_t)), 20);
      tx_hdr_ipv4->check[0] = (checksum >> 8) & 0xFF;
      tx_hdr_ipv4->check[1] = checksum & 0xFF;
      tx_hdr_icmp->type = 0x00;
      tx_hdr_icmp->code = 0x00;
      tx_hdr_icmp->checksum[0] = 0x00;
      tx_hdr_icmp->checksum[1] = 0x00;
      tx_hdr_icmp->id[0] = rx_hdr_icmp->id[0];
      tx_hdr_icmp->id[1] = rx_hdr_icmp->id[1];
      tx_hdr_icmp->sequence[0] = rx_hdr_icmp->sequence[0];
      tx_hdr_icmp->sequence[1] = rx_hdr_icmp->sequence[1];
      memcpy(tx_packet->payload + sizeof(net_hdr_eth_t) + sizeof(net_hdr_ipv4_t) + sizeof(net_hdr_icmp_t),
             rx_packet->payload + sizeof(net_hdr_eth_t) + sizeof(net_hdr_ipv4_t) + sizeof(net_hdr_icmp_t), rx_packet->len - 42);
      checksum = net_calculate_checksum((uint8_t*)tx_hdr_icmp, rx_packet->len - 34);
      tx_hdr_icmp->checksum[0] = (checksum >> 8) & 0xFF;
      tx_hdr_icmp->checksum[1] = checksum & 0xFF;
      return 1;
   } else {
      return 0;
   }
}

//==========================================================================
// End-of-File
//==========================================================================
