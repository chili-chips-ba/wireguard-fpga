#ifndef TIMER_H
#define TIMER_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define CPU_FREQ_HZ 80000000UL  // 80 MHz CPU clock
#define CYCLES_PER_US (CPU_FREQ_HZ / 1000000UL)
#define CYCLES_PER_MS (CPU_FREQ_HZ / 1000UL)

void delay_us(uint32_t us);
void delay_ms(uint32_t ms);

#ifdef __cplusplus
}
#endif

#endif // TIMER_H
