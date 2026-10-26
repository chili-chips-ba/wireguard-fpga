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
uint32_t eth_send_packet (eth_raw_packet_t* packet) {
   uint32_t i;
   uint32_t empty;
   if (CSR_GET(cpu_fifo.rx.status, CSR__CPU_FIFO__RX__STATUS__TREADY)) {
      i = 0;

      CSR_RMW(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TUSER_DST, packet->dst);
      CSR_RMW(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TUSER_SRC, packet->src);
      CSR_RMW(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_STAGE, packet->bypass_stage);
      CSR_RMW(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TUSER_BYPASS_ALL, packet->bypass_all);

      while (1) {
         CSR_REG32(cpu_fifo.rx.data_31_0) = *((uint32_t*)(packet->payload + i));
         CSR_REG32(cpu_fifo.rx.data_63_32) = *((uint32_t*)(packet->payload + i + 4));
         CSR_REG32(cpu_fifo.rx.data_95_64) = *((uint32_t*)(packet->payload + i + 8));
         CSR_REG32(cpu_fifo.rx.data_127_96) = *((uint32_t*)(packet->payload + i + 12));

         i += 16;

         if (i < packet->len) {
            CSR_SET(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TKEEP, 0xFFFF);
            CSR_SET(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TLAST, 0);
            CSR_SET(cpu_fifo.rx.trigger, CSR__CPU_FIFO__RX__TRIGGER__TVALID, 1);
         } else {
            empty = i - packet->len;
            CSR_SET(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TKEEP, 0xFFFF >> empty);
            CSR_SET(cpu_fifo.rx.control, CSR__CPU_FIFO__RX__CONTROL__TLAST, 1);
            CSR_SET(cpu_fifo.rx.trigger, CSR__CPU_FIFO__RX__TRIGGER__TVALID, 1);
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
uint32_t eth_receive_packet (eth_raw_packet_t* packet) {
   uint32_t len = 0;
   uint16_t keep;
   packet->dst = 0;
   packet->bypass_stage = 0;
   packet->bypass_all = 0;
   if (CSR_GET(cpu_fifo.tx.status, CSR__CPU_FIFO__TX__STATUS__TVALID)) {
      packet->src = CSR_GET(cpu_fifo.tx.control, CSR__CPU_FIFO__TX__CONTROL__TUSER_SRC);
      while (1) {
         if (len <= ETH_MAX_FRAME_LENGTH - 16) {
            *((uint32_t*)(packet->payload + len)) = CSR_REG32(cpu_fifo.tx.data_31_0);
            *((uint32_t*)(packet->payload + len + 4)) = CSR_REG32(cpu_fifo.tx.data_63_32);
            *((uint32_t*)(packet->payload + len + 8)) = CSR_REG32(cpu_fifo.tx.data_95_64);
            *((uint32_t*)(packet->payload + len + 12)) = CSR_REG32(cpu_fifo.tx.data_127_96);
         }

         if (CSR_GET(cpu_fifo.tx.control, CSR__CPU_FIFO__TX__CONTROL__TLAST)) {
            keep = CSR_GET(cpu_fifo.tx.control, CSR__CPU_FIFO__TX__CONTROL__TKEEP);
            while (keep & 1) {
                len++;
                keep >>= 1;
            }
            packet->len = (len < ETH_MAX_FRAME_LENGTH) ? len : ETH_MAX_FRAME_LENGTH;
            CSR_SET(cpu_fifo.tx.trigger, CSR__CPU_FIFO__TX__TRIGGER__TREADY, 1);
            return packet->len;
         } else {
            len += 16;
            CSR_SET(cpu_fifo.tx.trigger, CSR__CPU_FIFO__TX__TRIGGER__TREADY, 1);
         }
      }
   } else {
      return 0;
   }
}

//==========================================================================
// End-of-File
//==========================================================================
