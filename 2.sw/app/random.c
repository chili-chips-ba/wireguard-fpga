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
//   Random number generation library
//==========================================================================

#include "random.h"
#include "uart.h"
#include "timer.h"  // cycles(): the csr.cycle counter

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
    uint32_t samples[16];
    for (uint8_t i = 0; i < 16; i++)
    {
        uint32_t temp = cycles();
        temp ^= temp >> 7;
        temp *= 0x6C078965; // randomizing constant
        temp ^= temp >> 11;
        temp += 0x5D588B65; // randomizing constant
        samples[i] = temp;
        small_delay();
    }

    uintptr_t sp = (uintptr_t)&sp;

    uint8_t input[sizeof(samples) + sizeof(sp)];
    memcpy(input, samples, sizeof(samples));
    memcpy(input + sizeof(samples), &sp, sizeof(sp));

    hash(out, 32, NULL, 0, input, sizeof(input));

    memset(samples, 0, sizeof(samples));
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
