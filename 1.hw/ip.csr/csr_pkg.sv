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
// Description: This is a package with declarations of SOC-specific Control 
//    and Status registers. This is the DNA of register set. It is purposely 
//    structured and formal, to facilitate future automation/scripted generation.
//
//    It is also designed for preservation of FPGA resources. Writeable 
//    registers therefore don't have HW readback path. Instead, SW can use 
//    own variables in places where readback is needed. And, since SW 
//    variables are in RAM, they cost less than FPGA flip-flops and LUTs.
//==========================================================================

package csr_pkg;
 //import soc_pkg::clog2;
   
//-----------------------------------------------------------
// UART_TX
//-----------------------------------------------------------
// To send a byte over UART, SW must:
//   1) wait  for  'UART_TX.busy=0'
//   2) write into 'UART_TX.data' the value it wants to send 
//
// The write into this register, when 'busy=0', triggers UART transfer.
// The SW writes that come while 'busy=1' are ignored. HW therefore does 
// not allow SW to corrupt transfer that may already be going on. Such SW
// writes are lost and must be reattempted until executed for 'busy=0'.
//
// UART parameters are set in HW hardware to 115.2kbps, 1 Stop, 0 Parity.
// It is not possible for SW to change them.

   localparam ADDR_UART_TX = 'h0;

   typedef struct packed {       // MIXED
                                 //-------      
      logic [31:31] busy;        // [31]   RD_ONLY: 1 when HW cannot take another 'data'
    //logic [30:8]  rsvd;        // [30:8]
      logic [7:0]   data;        // [7:0]  WR_ONLY: Data to send out
   } uart_tx_t;                  //------- 
   

//-----------------------------------------------------------
// UART_RX
//-----------------------------------------------------------
// HW is constantly monitoring UART serial input. Whenever a byte is collected,
// HW presents it on 'UART_RX.data' slice, sets 'valid=1', and continues looking
// for more. SW is expected to poll 'valid'. The poll in which SW sees 1 on 'valid'
// is the read from which it should also take 'data'. Such SW read clears 'valid' 
// and 'oflow' flags, indicating to HW that the 'data' has exchanged hands. It 
// also pulls new 'data' value (if any) from the RxFIFO.
//
// SW polling is expected to be frequent enough to free up 'data' before HW comes
// around to place a new value into it. Should HW see that 'data' is still NOT 
// consumed (i.e. 'valid=1') at the time a new value is ready for placement, it
// will drop the new value and raise 'oflow' flag. HW thus conveys to the SW that
// one or  more data bytes have been lost in handoff. This potential loss would 
// be the result of SW inability to keep up with HW.

   localparam ADDR_UART_RX = 'h1;

   typedef struct packed {       // MIXED
                                 //-------      
      logic [31:31] valid;       // [31]    ROL_CLR: 1 when 'data' is valid
      logic [30:30] oflow;       // [30]    ROL_CLR: 1 when some 'data' bytes are lost
    //logic [29:8]  rsvd;        // [29:8]  
      logic [7:0]   data;        // [7:0]   ROL_CLR: Received data. New value is pulled
   } uart_rx_t;                  //-------           from FIFO for read with 'valid=1'


//-----------------------------------------------------------
// ADC1_TX
//-----------------------------------------------------------
// Similarly to UART_TX, to initiate ADC1 measurement, SW must:
//   1) wait  for  'ADC1_TX.busy=0'
//   2) write into 'ADC1_TX.time_us' the desired duration of measurement
//   3) optionally write 1 into 'ADC1_TX.test'. Instead of triggerring the
//      actual ADC1, HW will then start send internally-generated incrementing 
//      test pattern. This is useful for debug and validation of HW/SW handoff
//      without real ADC.
//
// The write into this register, when 'busy=0', triggers the measurement.
// The SW writes that come while 'busy=1' are ignored. HW therefore does not 
// allow SW to interrupt a measurement that's already in progress. Such SW 
// writes are lost and must be reattempted until executed for 'busy=0'.
//
// The measurement automatically stops with the expiry of 'time_us', whose
// value was set with the write that kicked off the ADC1.

   localparam ADDR_ADC1_TX = 'h2;

   typedef struct packed {       // MIXED
                                 //-------      
      logic [31:31] busy;        // [31]    RD_ONLY: 1 when a measurement is active
    //logic [30:16] rsvd;        // [30:16]
      logic [15:15] test;        // [15]    WR_ONLY: 1 to use locally-generated incrementing samples
      logic [14:0]  time_us;     // [14:0]  WR_ONLY: Duration of ADC conversion in us.
   } adc_tx_t;                   //-------           Zero means none. Max is 32_767 usec


//-----------------------------------------------------------
// ADC1_RX
//-----------------------------------------------------------

/* OLD:
// When SW initiates ADC1 measurement by writting into ADC1_TX address while 'busy=0',
// the HW starts assembling ADC samples from serial bits, or sending locally-generated
// test pattern. This register is used to receive them, using the same handshake as
// UART_RX. The ADC1_RX logic of 'valid' and 'oflow' is therefore identical to that of
// UART_RX. The only difference is that the samples from ADC are arriving more often 
// than data from UART. SW polling must therefore also be more frequent to avoid
// overflows. Max ADC sampling rate is 2.5MSPS.
//
// Another difference is that the ADC samples are not arriving at arbitrary times, but 
// only within 'time_us' period from the ADC kick off. While ADC activity is very busy
// during that time, it completely stops thereafter, freeing up the SW for tasks other
// than ADC polling. Given that the duration of ADC activity is controlled by 'time_us',
// to relinquish SW from the need to keep track of time, HW is also supplying 'last' 
// flag: 1 means that the corresponding 'data' is the final sample of the measurement.

   localparam ADDR_ADC1_RX = 'h3;

   typedef struct packed {       // MIXED
                                 //-------
      logic [31:31] valid;       // [31]    ROL_CLR: 1 when 'data' is valid
      logic [30:30] oflow;       // [30]    ROL_CLR: 1 when some 'data' samples are lost
      logic [29:29] last;        // [29]    ROL_CLR: 1 for the final sample in the session
    //logic [28:24] rsvd;        // [28:24]  
      logic [23:0]  data;        // [23:0]  RD_ONLY: Received 24-bit data sample
   } adc_rx_t;                   //-------
*/

/* NEW: 
// CPU cannot keep up with polling two ADCs and transferring their data to SDRAM.
// We are now using DMA from ADC straight into SDRAM. With that, ADC only tells 
// the CPU how many samples have been transferred. The handshake is:
//   - upon initiating a measurement, the CPU keeps polling 'ADC1/2_TX.busy'
//   - when corresponding 'busy' drops to 0, that's the end of measurement
//   - the samples are at that time already in SDRAM
//   - ADC1/2_RX registers then contain the number of transferred samples
//   - with 32_767usec max measurement time, and max sample arrival rate of 2.25MSPS,
//      the max number of samples is 73_726. We therefore allocate space for 0x1_2000 
//      samples per channel, which is cca 288kB of SDRAM. Given that one sample takes
//      2 and not 4 bytes, by using more compact data packing, we could even get away 
//      with 3/4 of that size.
*/

   localparam ADDR_ADC1_RX = 'h3;

   typedef struct packed {       // RD_ONLY
                                 //-------
    //logic [31:17] rsvd;        // [31:17]  
      logic [16:0]  sample_cnt;  // [16:0]  RD_ONLY: Number of samples in SDRAM.
   } adc_rx_t;                   //-------           Max is 73_726

//-----------------------------------------------------------
// ADC2_TX/RX. Identical to ADC1, only for ADC2.
   localparam ADDR_ADC2_TX = 'h4;
   localparam ADDR_ADC2_RX = 'h5;

//-----------------------------------------------------------
// General-Programmable-Outputs. Currently only for LED
   localparam ADDR_GPO = 'h6;

   typedef struct packed {       // WR_ONLY
                                 //-------
    //logic [31:2]  rsvd;        // [31:2]
      logic [1:0]   led_off;     // [1:0]   1 to turn-off LED[4:3]
   } gpo_t;                      //-------

   localparam gpo_t INIT_GPO = '0;

//-----------------------------------------------------------
// General-Programmable-Inputs
   localparam ADDR_GPI = 'h7;

   typedef struct packed {       // RD_ONLY  
                                 //-------
    //logic [31:1]  rsvd;        // [31:1]  
      logic [0:0]   key_on;      // [0]     1 when S1 key is pressed
   } gpi_t;                      //-------

//-----------------------------------------------------------
// DAC1/2
//-----------------------------------------------------------
// Write into these two registers start the process of sending 'Ping'
// to the corresponding DAC, but only if another Ping is not already
// running, i.e. if 'busy=0'

   localparam ADDR_DAC1 = 'h8;
   localparam ADDR_DAC2 = 'h9;

   typedef struct packed {       // MIXED
                                 //-------      
      logic [31:31] busy;        // [31]    RD_ONLY: 1 when Ping is running
    //logic [30:26] rsvd;        // [30:26]
      logic [25:16] hann_step;   // [25:16] WR_ONLY: duration of the Ping
    //logic [15:15] rsvd;        // [15]
      logic [14:0]  sin_tune;    // [14:0]  WR_ONLY: frequency of the carrier sinewave
   } dac_t;                      //-------

   localparam dac_t INIT_DAC = '0;

//-----------------------------------------------------------
// Misc
//-----------------------------------------------------------
   localparam ADDR_MISC = 'hA;

   typedef struct packed {       // WR_ONLY
                                 //-------
    //logic [31:4] rsvd;         // [31:4]
      logic [3:0] error;         // [3:0]
   } misc_t;                     //-------

   localparam misc_t INIT_MISC = '0;


//-----------------------------------------------------------
// Housekeeping
//-----------------------------------------------------------
   localparam CSR_ADDR_MAX = ADDR_MISC;
   
   localparam CSR_ADDR_MSB = $clog2(CSR_ADDR_MAX + 1) + 1;
   // number of bits needed to hold the highest CSR address
   // plus (2-1), because addressing is in the full 32-bit words
                        
   typedef struct packed {
      logic uart_tx;
      logic uart_rx;

      logic adc1_tx;
      logic adc1_rx;

      logic adc2_tx;
      logic adc2_rx;

      logic gpo;
      logic gpi;

      logic dac1;
      logic dac2;

      logic misc;
   } sel_t;

endpackage: csr_pkg

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/2  JI: initial creation    
 2024/3/1  JI: Streamlined HW/SW handshake for area efficiency.
               Added full explanation.
               Added ADC1/2_RX, GPO and GPI registers.
 2024/3/28 JI: Added DAC1/2
 2024/4/22 JI: Added MISC
*/
