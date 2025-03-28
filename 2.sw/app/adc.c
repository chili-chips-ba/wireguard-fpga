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
//   - ADC test code,
//       serves primarily as a demo on how to operate ADCs from SW
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
#include "uart.h"
#include "adc.h"

#ifdef ADC_TEST

/**********************************************************************
 * Function:    adc_start()
 *
 * Description: Starts the designated ADC with specified time_us
 *              and test parameters. For time_us=0 setting, we are
 *              purposely allowing to trigger one measurement, as
 *              that's very convenient for tuning the ADC
 *
 * Returns:     None
 **********************************************************************/
void adc_start (volatile adc_tx_t *adc_ptr, uint32_t time_us, uint8_t test) {
    // populate ADC values from the function arguments
    adc_tx_t adc_tx;
    adc_tx.fld.time_us = time_us;
    adc_tx.fld.test    = test;

    // wait for "not busy" from designated ADC, then write the new
    // value, which also starts the measurement on the specified ADC
    while (adc_ptr->fld.busy);
    adc_ptr -> all = adc_tx.all; // this write starts the ADC
}

/**********************************************************************
 * Function:    adc_sdram2uart()
 *
 * Description: Transfers collected ADC samples from SDRAM to UART,
 * using following format:
 *    $id,num_bytes,xxxxxxxxxx.........xxxxxx\r\n
 *
 * where:
 *  - <id> is 1 or 2, in binary (non-ASCII)
 *  - <num_bytes> is the number of bytes that follow, in binary/non-ASCII
 *  - <x> is one byte in binary format.
 *      One ADC sample is comprised of 3 bytes, ordered from MSB to LSB
 *
 * As far as the recipient of this response is concerned, the number
 * of bytes is arbitrary. For simplicity, we transfer the entire batch
 * of ADC measurement data in one shot, thus our <num_bytes> is always
 * divisible by 3
 *
 * Returns:     None
 **********************************************************************/
void adc_sdram2uart (uint8_t id) {
    adc_rx_t           adc_rx;
    byte4_t            num_bytes;
    byte4_t            sample;
    volatile uint32_t *sdram_addr;

    // prep the pointers based on ADC target: 1 or 2
    if (id == 1) {
       adc_rx.all = CSR->adc1_rx.all;
       sdram_addr = SDRAM_ADC1_ADDRESS;
    }
    else if (id == 2) {
       adc_rx.all = CSR->adc2_rx.all;
       sdram_addr = SDRAM_ADC2_ADDRESS;
    }
    else return;

    // retreive the number of received samples
    num_bytes.all = mul3(adc_rx.fld.sample_cnt);

    // send command header
    uart_send_char('$');

#ifdef ADC_SDRAM2UART_BINARY
    //-----------------------------------
    // Send in binary format. More compact, but
    // harder to receive on a standard terminal
    //-----------------------------------
    uart_send_char(id);
    uart_send_char(',');
    uart_send_char(num_bytes.fld.b2); // 3 x sample_cnt[16]
    uart_send_char(num_bytes.fld.b1); // 3 x sample_cnt[15:8]
    uart_send_char(num_bytes.fld.b0); // 3 x sample_cnt[7:0]
    uart_send_char(',');

    // retrieve data from SDRAM, then send it out byte-by-byte
    for (uint32_t i = 0; i < adc_rx.fld.sample_cnt; i++) {
      sample.all = *sdram_addr;

      uart_send_char(sample.fld.b2); // sample[23:16]
      uart_send_char(sample.fld.b1); // sample[15: 8]
      uart_send_char(sample.fld.b0); // sample[ 7: 0]

      sdram_addr++;
    }

#else
    //-----------------------------------
    // Send in ASCII HEX format. Easy to receive, but
    // one sample now consumes 6 bytes instead of 3
    //-----------------------------------
    uart_send_hex (id, 1);
    uart_send_char(',');
    uart_send_hex (num_bytes.all, 6); // 3 x sample_cnt
    uart_send_char(',');

    // retrieve data from SDRAM, then send it out
    for (uint32_t i = 0; i < adc_rx.fld.sample_cnt; i++) {
      sample.all = *sdram_addr;
      uart_send_hex (sample.all, 6); // sample[23:0]

      // this comma is not part of the spec, but can be added for easier debug
      //uart_send_char(',');

      sdram_addr++;
    }
#endif

    // send command footer
    uart_send((char*)"\r\n");
}


/**********************************************************************
 * Function:    adc_test()
 *
 * Description: Test and demo of ADC operation. It consists of:
 *              1) start the measurement of given duration
 *              2) wait for ADC to complete the measurement
 *              3) transfer samples from SDRAM to UART
 *                  (prior to this, the ADC DMA has loaded them to SDRAM)
 *
 *              The objectives of this function are to:
 *               - test the RTL implementation of all relevant logic
 *               - illustrate the handshake between SW and HW
 *               - be simple and straightforward
 *               - provide a foundation for development of "production"
 *                 code for ADC resource
 *
 *              While easy to follow, this function is blocking for
 *              the CPU. In other words, the CPU is waiting for:
 *                - ADC to finish the measurement
 *                     to start sending results to UART
 *                - then UART to finish the sending
 *
 *              That's a significant time that the CPU is essentially
 *              out of commission for any other task. See 'main.c' for
 *              a 'real-world' implementation with multi-tasking.
 *
 *              We can say that ADC is a "Non-Posted" resource, i.e.
 *              one that needs additional handling after the kick-off.
 *
 * Returns:     None
 **********************************************************************/
void adc_test(void) {
    // Predefined values for testing
    uint32_t time_us = 0;  // example value, adjust as needed
    uint8_t  test    = 1;  // must be 1 when board with real ADC is not plugged in

    adc_rx_t adc1_rx;
    adc_rx_t adc2_rx;

    volatile uint32_t *adc1_sdram_addr = SDRAM_ADC1_ADDRESS;
    volatile uint32_t *adc2_sdram_addr = SDRAM_ADC2_ADDRESS;

    uint32_t adc1_sdram_rdat, adc2_sdram_rdat;

    for (int i=1; i<11; i += 3) {
       // 1) Start both ADCs for measurement of given duration
       adc_start (&(CSR->adc1_tx), time_us, test);

       time_us += i;
       adc_start (&(CSR->adc2_tx), time_us, test);

       test = !test;


       // The following code section creates CPU reads concurrently with
       // ADC DMA writes, which is for testing CPU-vs-ADC and ADC1-vs-ADC2
       // arbitration logic. While we don't need it in normal operation,
       // in real-world multi-tasking cases we may have a situation when
       // ADC1 DMA is writing into SDRAM, while CPU is reading ADC2
       // samples from it, or vice versa. The real-world application
       // code should disallow CPU from reading ADC1 samples while
       // ADC1 DMA is writing them to SDRAM. Th same goes for ADC2.

       /*
       do {
          adc1_sdram_rdat = *adc1_sdram_addr;
          adc2_sdram_rdat = *adc2_sdram_addr;
       } while ((CSR->adc1_tx.fld.busy) || (CSR->adc2_tx.fld.busy));
       */


       // 2) Wait for "not busy" from both ADCs: This blocks CPU!
       while ((CSR->adc1_tx.fld.busy) || (CSR->adc2_tx.fld.busy));


       // 3) Data is DMA'd to SDRAM at this point. Transfer it to UART.
       //    This also blocks CPU!
       adc_sdram2uart (1);
       adc_sdram2uart (2);


       /*
       ----------------------------------------------------------------
        OLD: CPU cannot keep up with both ADCs.
             We now have hardware DMA for transfer of samples to SDRAM
       ----------------------------------------------------------------
       // Turn off both LEDs
       CSR -> gpo.fld.led_off = 0b11;

       // Servicing of both ADCs. To maximize CPU throughput:
       //  1) We do it inline, w/o function calls
       //  2) We don't maintain separate sample counters, but
       //      calculate them later on, when transfer is over
       adc1_rx.all = 0;
       adc2_rx.all = 0;

       do {
          //---ADC1
          if (!adc1_rx.fld.last) {
             adc1_rx.all = CSR->adc1_rx.all; // poll

             // transfer data if this read contains valid sample
             if (adc1_rx.fld.valid) {
                *adc1_sdram_addr = adc1_rx.all;
                 adc1_sdram_addr++;
             }

             // indicate ADC1 overflow using lower LED
             if (adc1_rx.fld.oflow) CSR -> gpo.fld.led_off = 0b10;
          }

          //---ADC2
          if (!adc2_rx.fld.last) {
            adc2_rx.all = CSR->adc2_rx.all; // poll

             // transfer data if this read contains valid sample
             if (adc2_rx.fld.valid) {
                *adc2_sdram_addr = adc2_rx.all;
                 adc2_sdram_addr++;
             }

             // indicate ADC2 overflow using upper LED
             if (adc2_rx.fld.oflow) CSR -> gpo.fld.led_off = 0b01;
          }
       } while (!adc1_rx.fld.last && !adc2_rx.fld.last);
       */
    }
}
#endif // ADC_TEST

//==========================================================================
// End-of-File
//==========================================================================
