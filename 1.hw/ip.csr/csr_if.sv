//==========================================================================
// Copyright (C) 2023 Chili.CHIPS*ba
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
//  - SOC-specific interface for Config and Status Registers (CSR)
//  - Provides structured CSR I/O
//==========================================================================

interface csr_if ();
   import csr_pkg::*;
   
// UART_TX
   logic        uart_tx_write;
   logic        uart_tx_busy;
   logic [7:0]  uart_tx_data;

// UART_RX
   logic        uart_rx_read;
   uart_rx_t    uart_rx;
                
// ADC1_TX
   logic        adc1_tx_write;
   logic        adc1_tx_busy;
   logic        adc1_tx_test;
   logic [14:0] adc1_tx_time_us;
   
// ADC1_RX
   adc_rx_t     adc1_rx;
                
// ADC2_TX
   logic        adc2_tx_write;
   logic        adc2_tx_busy;
   logic        adc2_tx_test;
   logic [14:0] adc2_tx_time_us;
   
// ADC2_RX
   adc_rx_t     adc2_rx;
                
// DAC1
   logic        dac1_write;
   logic        dac1_busy;
   logic [9:0]  dac1_hann_step;
   logic [14:0] dac1_sin_tune;

// DAC2
   logic        dac2_write;
   logic        dac2_busy;
   logic [9:0]  dac2_hann_step;
   logic [14:0] dac2_sin_tune;

// GPIO
   gpo_t        gpo;
   gpi_t        gpi;
   
// MISC
   misc_t       misc;


  //---------------------------------------- 
  // master/CPU side
  //---------------------------------------- 
   modport MST (
     output uart_tx_write,
            uart_tx_data,
            uart_rx_read,

            adc1_tx_write,
            adc1_tx_test,
            adc1_tx_time_us,

            adc2_tx_write,
            adc2_tx_test,
            adc2_tx_time_us,

            dac1_write,
            dac1_hann_step,
            dac1_sin_tune,

            dac2_write,
            dac2_hann_step,
            dac2_sin_tune,

            gpo,
            misc,

     input  uart_tx_busy,
            uart_rx,

            adc1_tx_busy,
            adc1_rx,

            adc2_tx_busy,
            adc2_rx,

            dac1_busy,
            dac2_busy,

            gpi
   );

  //---------------------------------------- 
  // Slave/Peripheral side
  //---------------------------------------- 
   modport SLV_UART (
     input  uart_tx_write,
            uart_tx_data,
            uart_rx_read,

     output uart_tx_busy,
            uart_rx
   );

   modport SLV_ADC (
     input  adc1_tx_write,
            adc1_tx_test,
            adc1_tx_time_us,

            adc2_tx_write,
            adc2_tx_test,
            adc2_tx_time_us,

     output adc1_tx_busy,
            adc1_rx,

            adc2_tx_busy,
            adc2_rx
   );

   modport SLV_DAC (
     input  dac1_write,
            dac1_hann_step,
            dac1_sin_tune,

            dac2_write,
            dac2_hann_step,
            dac2_sin_tune,

     output dac1_busy,
            dac2_busy
   );

endinterface: csr_if

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/2  JI: initial creation    
 2024/3/1  JI: added ADC1/2_RX, GPO and GPI I/O
 2024/3/28 JI: added DAC1/2
 2024/4/22 JI: added MISC
*/
