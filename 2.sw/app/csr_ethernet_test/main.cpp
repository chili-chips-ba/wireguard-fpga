/**
 * @file main.cpp
 * @brief Test program for Ethernet CSR (simple bridge)
 */

#include <stdint.h>
#include "wireguard_libs.h"
#include "wireguard_regs.h"
#include "ethernet.h"

eth_raw_packet_t packet;

int main(void)
{
   volatile csr_vp_t* csr = new csr_vp_t();
   
   while (1) {
      if (eth_receive_packet(csr, &packet)) {
         csr->gpio->led2(1);
         if (packet.src == 1) {
            packet.dst = 2;
            packet.bypass_all = 1;
            eth_send_packet(csr, &packet);
         } else if (packet.src == 2) {
            packet.dst = 1;
            packet.bypass_all = 1;
            eth_send_packet(csr, &packet);
         }
      } else {
         csr->gpio->led2(0);
      }
   }

   return 0;
}