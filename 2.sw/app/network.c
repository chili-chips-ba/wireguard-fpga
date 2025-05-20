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
