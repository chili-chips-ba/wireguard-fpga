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
