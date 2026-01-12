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
//   Timer library
//==========================================================================

#include "timer.h"

static uint32_t rdcycle(void)
{
    uint32_t cycles;
    __asm__ __volatile__("rdcycle %0" : "=r"(cycles));
    return cycles;
}

void delay_us(uint32_t us)
{
    uint32_t start = rdcycle();
    uint32_t wait_cycles = us * CYCLES_PER_US;

    while ((rdcycle() - start) < wait_cycles)
    {
        __asm__ __volatile__("" ::: "memory");
    }
}

void delay_ms(uint32_t ms)
{
    while (ms--)
        delay_us(1000);
}
