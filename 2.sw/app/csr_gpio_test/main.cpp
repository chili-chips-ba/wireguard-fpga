/**
 * @file main.cpp
 * @brief Test program for GPIO CSR
 */

#include <stdint.h>
#include "wireguard_libs.h"
#include "wireguard_regs.h"

void delay(uint32_t count) {
   volatile uint32_t i;
   for (i = 0; i < count; i++);
}

int main(void)
{
   csr_vp_t* csr = new csr_vp_t();

   while (1) {
      csr->gpio->led2(1);
      csr->gpio->led1(csr->gpio->key1());
      delay(10);
      csr->gpio->led2(0);
      csr->gpio->led1(csr->gpio->key1());
      delay(10);
   }

   return 0;
}