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
