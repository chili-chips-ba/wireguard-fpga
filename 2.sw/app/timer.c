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
//   Timer library
//==========================================================================

#include "timer.h"
#include "wireguard_regs.h"

// System clock cycles from the csr.cycle counter, not rdcycle: eduBOS5 has
// no CSR instructions (any SYSTEM instruction halts it, e.g. the ebreak
// error stops in main.cpp and wireguard_libs.cpp)
uint32_t cycles(void)
{
    static volatile csr_vp_t* csr = 0;
    if (!csr)
        csr = new csr_vp_t();
    return csr->cycle->count();
}

void delay_us(uint32_t us)
{
    uint32_t start = cycles();
    uint32_t wait_cycles = us * CYCLES_PER_US;

    while ((cycles() - start) < wait_cycles)
    {
        __asm__ __volatile__("" ::: "memory");
    }
}

void delay_ms(uint32_t ms)
{
    while (ms--)
        delay_us(1000);
}
