// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

#ifndef NETWORK_H
#define NETWORK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "wireguard_regs.h"
#include "string_bare.h"
#include "ethernet.h"

typedef enum {
   NET_PROTO_UNKNOWN,
   NET_PROTO_ARP,
   NET_PROTO_ICMP,
   NET_PROTO_UDP
} net_protocol_t;

typedef uint8_t ip_t[4];
typedef uint8_t mac_t[6];

typedef struct {
   ip_t     ip;
   ip_t     sub_mask;
   mac_t    mac;
   ip_t     def_gw;
   uint8_t  def_if;
} net_config_t;

typedef struct {
   uint8_t  count;
   ip_t     ip[128];
   mac_t    mac[128];
} net_arp_cache_t;

typedef struct {
   uint8_t  dst_mac[6];
   uint8_t  src_mac[6];
   uint8_t  ethertype[2];
} net_hdr_eth_t;

typedef struct {
   uint8_t  htype[2];
   uint8_t  ptype[2];
   uint8_t  hlen;
   uint8_t  plen;
   uint8_t  oper[2];
   uint8_t  sha[6];
   uint8_t  spa[4];
   uint8_t  tha[6];
   uint8_t  tpa[4];
} net_hdr_arp_t;

typedef struct {
   uint8_t  ihl :4;
   uint8_t  version :4;
   uint8_t  tos;
   uint8_t  tot_len[2];
   uint8_t  id[2];
   uint16_t frag_off;
   uint8_t  ttl;
   uint8_t  protocol;
   uint8_t  check[2];
   uint8_t  saddr[4];
   uint8_t  daddr[4];
} net_hdr_ipv4_t;

typedef struct {
   uint8_t  type;
   uint8_t  code;
   uint8_t  checksum[2];
   uint8_t  id[2];
   uint8_t  sequence[2];
} net_hdr_icmp_t;

uint8_t        net_str_parse_ip        (const char*       str,
                                        ip_t*             ip);
uint16_t       net_calculate_checksum  (const uint8_t* data, size_t len);
net_protocol_t net_parse_packet_header (eth_raw_packet_t* packet);
uint8_t        net_process_arp         (net_config_t*     config,
                                        net_arp_cache_t*  arp_cache,
                                        eth_raw_packet_t* rx_packet,
                                        eth_raw_packet_t* tx_packet);
uint8_t        net_process_icmp        (net_config_t*     config,
                                        eth_raw_packet_t* rx_packet,
                                        eth_raw_packet_t* tx_packet);

#ifdef __cplusplus
}
#endif

#endif // NETWORK_H
