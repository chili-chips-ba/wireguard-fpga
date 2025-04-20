/**
 * @file main.cpp
 * @brief Test program for UART and GPIO CSR
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
   csr_vp_t* csr = new csr_vp_t();
   char rx_data[UART_RXBUF_SIZE];
   
   csr->gpio->led2(1);
   csr->gpio->led1(csr->gpio->key1());
   delay(1000000);
   csr->gpio->led2(0);
   csr->gpio->led1(csr->gpio->key1());
   delay(1000000);
   
   uart_send(csr, "Hello world!\r\n");

   uart_test(csr);
   
   while (1) {
      uart_recv(csr, rx_data);
   }

   return 0;
}
