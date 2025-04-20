#ifndef ADC_H
#define ADC_H

#include <stdint.h>

#ifdef ADC_TEST
void adc_start      (volatile adc_tx_t *adc_ptr, uint32_t time_us, uint8_t test);
void adc_sdram2uart (uint8_t id);
void adc_test       (void);
#endif // ADC_TEST

#endif // ADC_H

