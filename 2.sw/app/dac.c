//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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
//   - DAC test code,
//      serves primarily as a demo on how to operate DACs from SW
//
//--------------------------------------------------------------------------
// This is a bare-metal (aka non-hosted / freestanding) program!
//  For more, see:
//    - http://cs107e.github.io/guides/gcc
//    - https://godbolt.org/z/4hzWrcqW6
//    - https://popovicu.com/posts/bare-metal-programming-risc-v
//
//  Reach out to us if you desire to upgrade this project to a hosted env,
//   such as FreeRTOS
//==========================================================================

#include "soc.h"
#include "dac.h"

#ifdef DAC_TEST

/**********************************************************************
 * Function:    dac_start()
 *
 * Description: Starts the designated DAC with specified sine wave
 *              tuning parameter and Hann window step size.
 *
 * Returns:     None
 **********************************************************************/
void dac_start (volatile dac_tx_t *dac_ptr, uint16_t hann_step, uint16_t sin_tune) {
    // populate DAC values from the function arguments
    dac_tx_t dac_tx;
    dac_tx.fld.hann_step = hann_step;
    dac_tx.fld.sin_tune  = sin_tune;

    // wait for "not busy" from designated DAC, then write the new value,
    // which also starts the specified DAC
    while (dac_ptr -> fld.busy);
    dac_ptr -> all = dac_tx.all;
}


/**********************************************************************
 * Function:    dac_test()
 *
 * Description: Simple test of DAC output by setting predefined sine
 *              wave tune and Hann window parameters.
 *
 *              The objectives are to:
 *               - test the RTL implementation of all relevant logic
 *               - illustrate the handshake between SW and HW
 *               - provide a foundation for development of "production"
 *                 code for DAC resource
 *
 * Returns:     None
 **********************************************************************/
void dac_test(void) {
    // Predefined values for testing
    uint32_t hann_step = 6;    // Example value, adjust as needed
    uint32_t sin_tune  = 7767; // Example value, adjust as needed

    // Start DAC with sine wave tune and Hann window step size
    //   (*) example value, adjust as needed
    for (int i=0; i<200; i += 10) {
       hann_step += i;
       sin_tune  += i;
       dac_start (&(CSR->dac1_tx), hann_step, sin_tune);

       hann_step += i;
       sin_tune  += i;
       dac_start (&(CSR->dac2_tx), hann_step, sin_tune);

       // Indicate that DACs were started
       CSR -> gpo.fld.led_off = 0b01;

       // DAC is a "Posted" (aka Kick-and-Forget) resource, one that
       // does not need any additional handling after the kick-off
    }
}
#endif // DAC_TEST


//==========================================================================
// End-of-File
//==========================================================================
