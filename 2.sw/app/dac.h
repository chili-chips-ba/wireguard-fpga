#ifndef DAC_H
#define DAC_H

#include <stdint.h>

void dac_start (volatile dac_tx_t *dac_ptr, uint16_t hann_step, uint16_t sin_tune);

#ifdef DAC_TEST
void dac_test  (void);
#endif // DAC_TEST

#endif // DAC_H

