//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
// Description:
//   - Network protocol stack library
//==========================================================================

#include "network.h"

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
   // Check if opcode is request (0x0001)
   if (rx_hdr_arp->oper[0] == 0x00 && rx_hdr_arp->oper[1] == 0x01) {
      // Check if targeted to myself
      if (memcmp(rx_hdr_arp->tpa, config->ip, 4) == 0) {
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
      }
   // else, check if opcode is response (0x0002)
   } else if (rx_hdr_arp->oper[0] == 0x00 && rx_hdr_arp->oper[1] == 0x02) {
      // TODO: update ARP cache
   }
   return 0;
}

//==========================================================================
// End-of-File
//==========================================================================
