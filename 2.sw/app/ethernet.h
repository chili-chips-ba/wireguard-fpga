#ifndef ETHERNET_H
#define ETHERNET_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "wireguard_regs.h"

typedef struct {
   uint8_t  dst;
   uint8_t  src;
   uint8_t  bypass_stage;
   uint8_t  bypass_all;
   uint32_t len;
   uint8_t  payload[1536];
} eth_raw_packet_t;

#define DPE_ADDR_CPU   0
#define DPE_ADDR_ETH_1 1
#define DPE_ADDR_ETH_2 2
#define DPE_ADDR_ETH_3 3
#define DPE_ADDR_ETH_4 4
#define DPE_ADDR_BCAST 7

uint32_t eth_send_packet    (volatile csr_vp_t* csr, eth_raw_packet_t* packet);
uint32_t eth_receive_packet (volatile csr_vp_t* csr, eth_raw_packet_t* packet);

#ifdef __cplusplus
}
#endif

#endif // ETHERNET_H
