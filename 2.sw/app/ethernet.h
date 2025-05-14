#ifndef ETHERNET_H
#define ETHERNET_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "wireguard_regs.h"
#include "string_bare.h"

typedef struct {
   uint8_t  dst;
   uint8_t  src;
   uint8_t  bypass_stage;
   uint8_t  bypass_all;
   uint32_t len;
   uint8_t  payload[1536];
} eth_raw_packet_t;

uint32_t eth_send_packet    (csr_vp_t* csr, eth_raw_packet_t* packet);
uint32_t eth_receive_packet (csr_vp_t* csr, eth_raw_packet_t* packet);

#ifdef __cplusplus
}
#endif

#endif // ETHERNET_H
