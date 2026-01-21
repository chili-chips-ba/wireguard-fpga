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

/**
 * @file main.cpp
 * @brief Test program for CSR HAL: GPIO, UART, Ethernet
 */

#include <stdint.h>
#include "wireguard_libs.h"
#include "wireguard_regs.h"
#include "uart.h"
#include "ethernet.h"

eth_raw_packet_t packet;

int main(void)
{
   volatile csr_vp_t* csr = new csr_vp_t();
   char rx_data[UART_RXBUF_SIZE];

   // Turn on LED2
   csr->gpio->led2(1);
   // Set LED1 to the value of KEY1
   csr->gpio->led1(csr->gpio->key1());

   // Send Hello world to UART
   uart_send(csr, "Hello world!\r\n");

   // Receive (and echo) the text terminated with CRLF
   while(!uart_recv(csr, rx_data));

   // Receive Ethernet packet for CPU FIFO
   while (!eth_receive_packet(csr, &packet));
   // If packet is received from eth1
   // forward it to eth2, and vice versa
   if (packet.src == 1) {
      packet.dst = 2;
      packet.bypass_all = 1;
      eth_send_packet(csr, &packet);
   } else if (packet.src == 2) {
      packet.dst = 1;
      packet.bypass_all = 1;
      eth_send_packet(csr, &packet);
   }

   return 0;
}
