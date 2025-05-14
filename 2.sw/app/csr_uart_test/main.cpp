/**
 * @file main.cpp
 * @brief Test program for UART CSR
 */

#include <stdint.h>
#include "wireguard_libs.h"
#include "wireguard_regs.h"
#include "uart.h"

void delay(uint32_t count) {
   volatile uint32_t i;
   for (i = 0; i < count; i++);
}

int main(void)
{
   volatile csr_vp_t* csr = new csr_vp_t();
   char rx_data[UART_RXBUF_SIZE];
   
   uart_send(csr, "Hello world!\r\n");
   uart_test(csr);
   
   while (1) {
      uart_recv(csr, rx_data);
   }

   return 0;
}