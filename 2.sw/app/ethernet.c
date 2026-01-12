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
//   Ethernet library
//==========================================================================

#include "ethernet.h"

/**********************************************************************
 * Function:    eth_send_packet()
 *
 * Description: Sends a raw Ethernet packet to the CPU Rx FIFO
 *
 * Returns:     Length of the sent packet
 **********************************************************************/
uint32_t eth_send_packet (volatile csr_vp_t* csr, eth_raw_packet_t* packet) {
   uint32_t i;
   uint32_t empty;
   if (csr->cpu_fifo->rx->status->tready()) {
      i = 0;

      csr->cpu_fifo->rx->control->tuser_dst(packet->dst);
      csr->cpu_fifo->rx->control->tuser_src(packet->src);
      csr->cpu_fifo->rx->control->tuser_bypass_stage(packet->bypass_stage);
      csr->cpu_fifo->rx->control->tuser_bypass_all(packet->bypass_all);

      while (1) {
         csr->cpu_fifo->rx->data_31_0->tdata(*((uint32_t*)(packet->payload + i)));
         csr->cpu_fifo->rx->data_63_32->tdata(*((uint32_t*)(packet->payload + i + 4)));
         csr->cpu_fifo->rx->data_95_64->tdata(*((uint32_t*)(packet->payload + i + 8)));
         csr->cpu_fifo->rx->data_127_96->tdata(*((uint32_t*)(packet->payload + i + 12)));

         i += 16;

         if (i < packet->len) {
            csr->cpu_fifo->rx->control->tkeep(0xFFFF);
            csr->cpu_fifo->rx->control->tlast(0);
            csr->cpu_fifo->rx->trigger->tvalid(1);
         } else {
            empty = i - packet->len;
            csr->cpu_fifo->rx->control->tkeep(0xFFFF >> empty);
            csr->cpu_fifo->rx->control->tlast(1);
            csr->cpu_fifo->rx->trigger->tvalid(1);
            return packet->len;
         }
      }
   } else {
      return 0;
   }
}

/**********************************************************************
 * Function:    eth_receive_packet()
 *
 * Description: Receives a raw Ethernet packet from the CPU Tx FIFO
 *
 * Returns:     Length of the received packet
 **********************************************************************/
uint32_t eth_receive_packet (volatile csr_vp_t* csr, eth_raw_packet_t* packet) {
   uint32_t len = 0;
   uint16_t keep;
   packet->dst = 0;
   packet->bypass_stage = 0;
   packet->bypass_all = 0;
   if (csr->cpu_fifo->tx->status->tvalid()) {
      packet->src = csr->cpu_fifo->tx->control->tuser_src();
      while (1) {
         if (len <= ETH_MAX_FRAME_LENGTH - 16) {
            *((uint32_t*)(packet->payload + len)) = csr->cpu_fifo->tx->data_31_0->tdata();
            *((uint32_t*)(packet->payload + len + 4)) = csr->cpu_fifo->tx->data_63_32->tdata();
            *((uint32_t*)(packet->payload + len + 8)) = csr->cpu_fifo->tx->data_95_64->tdata();
            *((uint32_t*)(packet->payload + len + 12)) = csr->cpu_fifo->tx->data_127_96->tdata();
         }

         if (csr->cpu_fifo->tx->control->tlast()) {
            keep = csr->cpu_fifo->tx->control->tkeep();
            while (keep & 1) {
                len++;
                keep >>= 1;
            }
            packet->len = (len < ETH_MAX_FRAME_LENGTH) ? len : ETH_MAX_FRAME_LENGTH;
            csr->cpu_fifo->tx->trigger->tready(1);
            return packet->len;
         } else {
            len += 16;
            csr->cpu_fifo->tx->trigger->tready(1);
         }
      }
   } else {
      return 0;
   }
}

//==========================================================================
// End-of-File
//==========================================================================
