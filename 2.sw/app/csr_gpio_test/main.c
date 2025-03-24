/**
 * @file main.c
 * @brief Test program for GPIO CSR
 */

#include <stdint.h>
#include "csr.h"

void delay(uint32_t count) {
   volatile uint32_t i;
   for (i = 0; i < count; i++);
}

int main(void)
{
   volatile csr_t *csr = (volatile csr_t*)0x20000000;
   
   while (1) {
      csr->gpio.f.led2 = 1;
      csr->gpio.f.led1 = csr->gpio.f.key1;
      delay(1000000);
      csr->gpio.f.led2 = 0;
      csr->gpio.f.led1 = csr->gpio.f.key1;
      delay(1000000);
   }
   
   return 0;
}