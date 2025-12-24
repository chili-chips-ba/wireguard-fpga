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
