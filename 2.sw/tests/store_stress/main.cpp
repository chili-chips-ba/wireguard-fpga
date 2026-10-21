// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

/**
 * @file main.cpp
 * @brief Store stress for #61: the CPU stores to DMEM back to back (words
 *        and bytes) and reads everything back, while the test bench drives
 *        UART bus writes (UART_BUS_STRESS). A lost store shows as a
 *        read-back error. Results go to a fixed DMEM word for the checker.
 */

#include <stdint.h>

#define HAMMER_WORDS 256
#define HAMMER       ((volatile uint32_t*)0x10009000u)  // clear of busw (0x10008000) and stack
#define RESULT       ((volatile uint32_t*)0x1000F000u)  // [0] magic [1] passes [2] errors
#define MAGIC        0x57AB1E00u

int main(void)
{
   uint32_t passes = 0;
   uint32_t errors = 0;

   RESULT[0] = MAGIC;
   for (;;) {
      volatile uint8_t* bytes = (volatile uint8_t*)HAMMER;

      // words, then one byte lane per word
      for (uint32_t i = 0; i < HAMMER_WORDS; i++) {
         HAMMER[i] = (passes << 16) ^ i;
      }
      for (uint32_t i = 0; i < HAMMER_WORDS; i++) {
         bytes[4 * i + (i & 3)] = (uint8_t)(passes + i);
      }

      for (uint32_t i = 0; i < HAMMER_WORDS; i++) {
         uint32_t exp   = (passes << 16) ^ i;
         uint32_t shift = 8 * (i & 3);
         exp = (exp & ~(0xFFu << shift)) | ((uint32_t)(uint8_t)(passes + i) << shift);
         if (HAMMER[i] != exp) {
            errors++;
         }
      }

      passes++;
      RESULT[1] = passes;
      RESULT[2] = errors;
   }
   return 0;
}
