//==========================================================================
// Copyright (C) 2024-2026 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Random number generation library
//==========================================================================

#include "random.h"
#include "uart.h"

// Inline function to read cycle counter from RISC-V CPU
static uint32_t rdcycle(void)
{
    uint32_t cycles;
    asm volatile("rdcycle %0" : "=r"(cycles));
    return cycles;
}

// Inline function to cause a small delay
static void small_delay(void)
{
    for (volatile int i = 0; i < 1000; i++)
    {
        asm volatile("nop");
    }
}

/*
 * Generate 32 random bytes.
 * Mixes current and previous cycle counts with BLAKE2s.
 * This is not cryptographically secure on its own, but provides
 * a decent entropy source for embedded use.
 */
void random_32bytes(uint8_t *out)
{
    uint32_t cycles[16];
    for (uint8_t i = 0; i < 16; i++)
    {
        uint32_t temp = rdcycle();
        temp ^= temp >> 7;
        temp *= 0x6C078965; // randomizing constant
        temp ^= temp >> 11;
        temp += 0x5D588B65; // randomizing constant
        cycles[i] = temp;
        small_delay();
    }

    uintptr_t sp = (uintptr_t)&sp;

    uint8_t input[sizeof(cycles) + sizeof(sp)];
    memcpy(input, cycles, sizeof(cycles));
    memcpy(input + sizeof(cycles), &sp, sizeof(sp));

    hash(out, 32, NULL, 0, input, sizeof(input));

    memset(cycles, 0, sizeof(cycles));
    memset(input, 0, sizeof(input));
}

/*
 * Returns a random 32-bit integer in the inclusive range [min, max].
 * Uses rejection sampling to avoid modulo bias.
 */
uint32_t random_range(uint32_t min, uint32_t max)
{
    if (max <= min) return min;

    uint8_t buffer[32];
    random_32bytes(buffer);

    uint32_t val;
    memcpy(&val, buffer, sizeof(val));
    memset(buffer, 0, sizeof(buffer));

    return min + (val % (max - min + 1));
}
