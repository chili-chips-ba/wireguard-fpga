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
//   1) Optional standalone tests of external SDRAM/DMEM, UART, DAC and ADC 
//
//   2) UART_RX Polling/Servicing with Command Parser
//   3) Dispatch of ADC and DAC Commands
//   4) Dispatch of ADC Responses
//   5) ADC Response upload via UART_TX: Return of ADC measurement results
// 
// The latter 4 are implemented in a non-blocking way, without forcing the
// CPU to wait, essentially allowing multi-tasking even without an OS.
//
//--------------------------------------------------------------------------
// This is a bare-metal (aka non-hosted / freestanding) program!
//  For more, see:
//    - http://cs107e.github.io/guides/gcc
//    - https://godbolt.org/z/4hzWrcqW6
//    - https://popovicu.com/posts/bare-metal-programming-risc-v
//    - https://blog.feabhas.com/2022/02/working-with-strings-in-embedded-c
//    - https://gcc.gnu.org/onlinedocs/gcc/Inline.html
//
//  Reach out to us if you desire to upgrade this project to a hosted env,
//   such as FreeRTOS
//==========================================================================

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#include "soc.h"
#include "memtest.h"
#include "uart.h"
#include "dac.h"
#include "adc.h"


/**********************************************************************
 * Function:    cmd_recv()
 *
 * Description: This function is the central part of UART_RX servicing, 
 *              and intended to be called periodically. For speed, it
 *              does not take any arguments, but instead operates
 *              directly with global variables. 
 *
 *              It char-by-char receives command from UART HW, dissects 
 *              it on-the-fly, discarding following characters:
 *                 - Command-Start: '$'
 *                 - Separators   : ',' '\r'
 *                 - Command-End  : '\n'
 *              and, as they arrive, converting arguments from ASCII
 *              to binary. The input command format is:
 *
 *                   $id,<arg1>,<arg2>,<arg3>\r\n
 *
 *              all in ASCII. Output is a parsed command, organized
 *              into a structure (see cmd_t in soc.h), all in binary.
 *
 *              This design is capable of receiving a new command while 
 *              earlier command is in the execution pipe. Should a 3rd
 *              command start arriving before the 2nd assembled command 
 *              can be dispatched for execution (such as if targeted HW 
 *              resource is still busy executing an earlier command), 
 *              the new command is discarded. The 'crx_flag.rdy' semaphore 
 *              is used for this determination. Implementations with 
 *              command queue deeper than 1 are also possible.
 *
 *              This function is implemented using low-level RTL style.
 *              Such approach reduces storage needs and equalizes parser 
 *              workload across multiple polling cycles, so increasing 
 *              CPU availability for other tasks in the main polling loop.
 *
 * Returns:     None. All handshake is through global semaphores
 **********************************************************************/
                                  // global variables for:

register  uart_rx_t uart_rx asm("t5");

char      crx_asc[CRX_ASC_SIZE];  // buffer that stores ASCII of a received command element
uint8_t   crx_asc_idx;            // index into next free spot in that buffer
uint32_t  crx_bin;                // corresponding binary value for that ASCII string
cmd_t     crx = {0,0,0,0};        // newly received command

cmd_flag_t crx_flag = {0, 0, 0};

static inline void cmd_recv() __attribute__((always_inline));
static inline void cmd_recv() {
//void cmd_recv() {

   // poll UART_RX:
   //  Due to Clear-on-Read nature of VALID and OFLOW flags, this MUST
   //  BE ONE SHOT READ. Otherwise, the value of flags could be lost
   uart_rx.all = CSR->uart_rx.all;

   // exit right away if UART_RX data is not ready
   if (!uart_rx.fld.valid) return;

   // exit out and ABORT command for UART_RX overflow
   if (uart_rx.fld.oflow) {
      crx_flag.active = 0x00;

      CSR->misc.fld.error = 0x1; // UART_RX_OVERFLOW
      return;
   }

   // otherwise, parse the received data. '$' Command-Start
   // character is discarded and used to prep the reception
   // of new Command, but only when the earlier-assembled
   // Command is not pending. This is to say that we will
   // not sacrifice the properly received Command for the
   // sake of a new Command. Instead, we will sacrifice the
   // new Command.
   //
   // However, '$' that arrives while another Command is
   // being assembled will interrupt it. Instead, it will
   // start another Command. In such situation, it does not
   // make sense to try to complete the earlier Command.
   if (uart_rx.fld.data == '$') {
      if (crx_flag.rdy == 0xFF) {
         CSR->misc.fld.error = 0x2; // ANOTHER_CMD_PENDING (drop new Cmd)
      }
      else {
         if (crx_flag.active == 0xFF) {
            CSR->misc.fld.error = 0x3; // ANOTHER_CMD_IN_RX (interrupt it and start new Cmd)
         }

         crx_flag.active = 0xFF;

         crx_asc_idx = 0;
         crx.anum    = 0;
         crx.id      = 0;
         crx.arg1    = 0;
         crx.arg2    = 0;
         crx.arg3    = 0;
          
         CSR->misc.fld.error = 0x0;
      }
      return;
   }
    
   // discard all characters that arrive prior to '$',
   // or after '$' that failed to start a new Command
   if (crx_flag.active == 0x00) {
      CSR->misc.fld.error = 0x4; // UNEXPECTED_CHAR
      return;
   }

   // after receiving '$':
   //  - ',' and <CR> are element delimiters, and removed
   //  - <LF> is Command-End, also removed, terminating session
   //  - numerical characters are converted from ASCII to binary
   //  - reception of any other character ABORTs command.
   //      That is, spaces and letters are not allowed
   switch (uart_rx.fld.data) {
    
      //------
      // convert multi-digit ASCII string that represents 
      // decimal number (as opposed to Hex) into plain binary.
      // Only 4 command elements are allowed: ID + 3 Arguments
      case ',':
      case '\r': 
        if (crx.anum < 4) {
           crx_bin = 0;
            
           for (uint8_t i=0; i < crx_asc_idx; i++) {
              crx_bin = 10*crx_bin + (crx_asc[i] - '0');
           }
            
           switch (crx.anum) {
              case 0: crx.id   = (uint8_t)crx_bin; break;
              case 1: crx.arg1 =          crx_bin; break;
              case 2: crx.arg2 =          crx_bin; break;
              case 3: crx.arg3 =          crx_bin;
           }
            
           crx_asc_idx = 0;
           crx.anum++;
        }
        break;    
    
      //------
      // Command-End. Discard it, updating flags
      case '\n':
        crx_flag.active = 0x00;
        crx_flag.rdy    = 0xFF; // command is now ready for execution
        break;
    
      //------
      // store ASCII values from '0' to '9'. Reception of
      // any other character, or more characters than allowed,
      // will ABORT command, i.e. force waiting for new '$'
      default:
        if (   (uart_rx.fld.data < '0')
            || (uart_rx.fld.data > '9')
            || (crx_asc_idx > CRX_ASC_SIZE-1) )
        {
           crx_flag.active = 0x00;
           CSR->misc.fld.error = 0x5; // ILLEGAL_CMD_CHAR
        }   
        // save new data, then increment index
        else {
           crx_asc[crx_asc_idx++] = uart_rx.fld.data;
        }
   }
}


/**********************************************************************
 * Function:    cmd_dispatch()
 *
 * Description: This function dispatches the earlier received and
 *              parsed Command. Implemented in a way that won't block
 *              other CPU functions.
 *
 *              The currently-supported commands are:
 *                $1,time_us,test\r\n
 *                   id=1: ADC1-StartMeasurement-and-ReturnResults
 *                   arg1: measurement time in microseconds. Value 0 here
 *                         will trigger one-and-only-one measurement,
 *                         which is very convenient for tuning the ADC
 *                   arg2: 1 instructs ADC RTL to locally generate data
 *
 *                $2,time_us,test\r\n       -> same, only for ADC2
 *               
 *                $3,hann_step,sin_tune\r\n -> DAC1-StartPing
 *                $4,hann_step,sin_tune\r\n -> DAC2-StartPing
 *
 * Returns:     None. For speed, all handshake is through global semaphores
 **********************************************************************/

// FUTURE: first step towards creating a CmdQueue
//cmd_t  cmd;  

// ADC is a Non-Posted resource: It requires additional handling
// after kicking-off a measurement
adc_tx_t adc_tx;

// DAC is Posted resource: Kick-and-Forget
dac_tx_t dac_tx;

// collections of flags for management of Non-Posted commands
task_t task = {0};

static inline void cmd_dispatch() __attribute__((always_inline));
static inline void cmd_dispatch() {
//void cmd_dispatch() {

   // exit out right away if new command is not ready
   if (crx_flag.rdy == 0x00) return;

   // in this initial version, we consider new command processed
   // right away, even if it ends up being discarded. The following
   // line is what's causing loss of command if it ends up not
   // started in the code that follows
   crx_flag.rdy = 0x00;      

   if (crx.anum != 3) {
      CSR->misc.fld.error = 0x6; // INVALID_ANUM
      return;
   }

   switch (crx.id) {
    
      //--ADC commands are Non-Posted and include Return-Results.
      //  We DROP NEW ADC COMMAND IF THE EARLIER ONE IS STILL RUNNING!
      //
      //  Instead of discarding, a future implementation could add
      //  a queue that would hold this excessive command, such as:
      //    cmd = crx;
      //
      //while (CSR -> adc1_rx.fld.busy);
      //--\ wait for ADC1 "not busy", to then start it
      //--/  (*) given 'adc1_started' flag, this waiting is not needed
      case 1:
        if (task.fld.adc1_started == 0xFF) {
           CSR->misc.fld.error = 0x7; // ADC1_CMD_DROPPED
        }
        else {           
           adc_tx.fld.time_us    = crx.arg1;
           adc_tx.fld.test       = crx.arg2;
           CSR->adc1_tx.all      = adc_tx.all; // this write starts ADC1
            
           task.fld.adc1_started = 0xFF;
           CSR->gpo.fld.led_off  = 0x2; // VISUAL DEBUG: turn on 1st LED
        }
        break;
       
      case 2:
        if (task.fld.adc2_started == 0xFF) {
           CSR->misc.fld.error = 0x8; // ADC2_CMD_DROPPED
        }
        else {           
           adc_tx.fld.time_us    = crx.arg1;
           adc_tx.fld.test       = crx.arg2;
           CSR->adc2_tx.all      = adc_tx.all; // this write starts ADC2
            
           task.fld.adc2_started = 0xFF;
           CSR->gpo.fld.led_off  = 0x1; // VISUAL DEBUG: turn on 2nd LED
        }
        break;
       
      //--DAC Commands are Kick-and-Forget (aka Posted): There
      //  is nothing else to do upon starting DAC operation
      //
      //  We DROP NEW DAC COMMAND IF THE EARLIER ONE IS STILL RUNNING!
      case 3: 
        if (CSR->dac1_tx.fld.busy) {
           CSR->misc.fld.error = 0x9; // DAC1_CMD_DROPPED
        }
        else {
           dac_tx.fld.hann_step = crx.arg1;
           dac_tx.fld.sin_tune  = crx.arg2;
           CSR->dac1_tx.all     = dac_tx.all; // this write starts DAC1
            
           CSR->gpo.fld.led_off = 0x0; // VISUAL DEBUG: turn on both LEDs
        }
        break;
    
      case 4: 
        if (CSR->dac2_tx.fld.busy) {
           CSR->misc.fld.error = 0xA; // DAC2_CMD_DROPPED
        }
        else {
           dac_tx.fld.hann_step = crx.arg1;
           dac_tx.fld.sin_tune  = crx.arg2;
           CSR->dac2_tx.all     = dac_tx.all; // this write starts DAC2
            
           CSR->gpo.fld.led_off = 0x0; // VISUAL DEBUG: turn on both LEDs
        }
        break;
    
      //------
      // unsupported command: Turn off all LEDs
      default: 
         CSR->misc.fld.error  = 0xB; // INVALID_CMD_ID
         CSR->gpo.fld.led_off = 0x3;
   }
}


/**********************************************************************
 * Function:    rsp_dispatch()
 *
 * Description: This function applies only to Non-Posted Commands, such
 *              as ADC, where the work is not completed with measurement
 *              kick-off, but must also:
 *                1) wait for the end of measurement
 *                2) upload the measurement results
 *
 *              Since we have two ADCs, but only one UART_TX, and also
 *              allow both ADCs to be measuring at the same time (such
 *              as to sense two different angles of the "sonar echo"),
 *              this function is also responsible for allocation of the
 *              common UART_TX resource to these two concurrent users. 
 *
 *              The arbitration algorithm is simple:
 *                - first come, first served
 *                - ADC1 gets precedence is they both arrive at same time
 *                - an ongoing transfer cannot be interrupted
 *
 *              This function is implemented in a way that won't block
 *              other CPU functions.
 *
 * Returns:     None. For speed, all handshake is through global semaphores
 **********************************************************************/

adc_rx_t adc_rx;
byte4_t  adc_num_bytes;
uint8_t  adc_byte_cnt;
volatile uint32_t *adc_sdram_addr;

static inline void rsp_dispatch() __attribute__((always_inline));
static inline void rsp_dispatch() {
//void rsp_dispatch() {

   //___when UART_TX is busy, there is no point in doing anything else
   //  here, hence wait for it to free up 
   if (task.hal.adc_uarting != 0x0000) return;

   //___when ADC1 is started, first wait for it to finish the measurement
   if ((task.fld.adc1_started == 0xFF) && !CSR->adc1_tx.fld.busy) {

      // retrieve 'sample_cnt' and prep for uploading ADC1 data. We
      // don't check for sample_cnt=0, as even time_us=0 yields 1 sample
      adc_rx.all           = CSR->adc1_rx.all; 
      adc_num_bytes.fld.b0 = 1; // temporarily used for ADC_ID
      adc_sdram_addr       = SDRAM_ADC1_ADDRESS;

      adc_byte_cnt          = 0;
      task.fld.adc1_uarting = 0xFF;
   }

   //___when ADC2 is started, first wait for it to finish the measurement
   else if ((task.fld.adc2_started == 0xFF) && !CSR->adc2_tx.fld.busy) {

      // retrieve 'sample_cnt' and prep for uploading ADC1 data. We
      // don't check for sample_cnt=0, as even time_us=0 yields 1 sample
      adc_rx.all           = CSR->adc2_rx.all;
      adc_num_bytes.fld.b0 = 2; // temporarily used for ADC_ID
      adc_sdram_addr       = SDRAM_ADC2_ADDRESS;

      adc_byte_cnt          = 0;
      task.fld.adc2_uarting = 0xFF;
   }
}


/**********************************************************************
 * Function:    rsp_sdram2uart()
 *
 * Description: Upload the measurement results via UART.
 *
 *   The format of ReturnResults is:
 *      $id,num_bytes,xxxxxxxxxx.........xxxxxx\r\n
 *    
 *   where:    
 *    - <id> is 1 or 2, in binary (non-ASCII)
 *    - <num_bytes> is the number of bytes that follow, in binary/non-ASCII
 *    - <x> is one byte in binary format. 
 *        One ADC sample is made of 3 bytes, ordered from MSByte to LSByte
 *    
 *   To facilitate testing with ordinary terminals, pure ASCII format is
 *   also provided.
 *    
 *   As far as the recipient of this response is concerned, the number of
 *   bytes is arbitrary. For simplicity, we transfer the entire batch of
 *   ADC measurement data in one shot. Our <num_bytes> is therefore always
 *   divisible by 3. It is also possible to devise a scheme where return
 *   data from two ADC channels is chunked up and interleaved, so that
 *   the upload of one channel is not blocking the other, allowing both
 *   to proceed in a pseudo-parallel fashion, appearing to be concurrent
 *
 *   This function is implemented in a way that won't block
 *   other CPU functions.
 *
 * Returns:     None. For speed, all handshake is through global semaphores
 **********************************************************************/

byte4_t  adc_sample;
int32_t  adc_sample_cnt;

static inline void rsp_sdram2uart() __attribute__((always_inline));
static inline void rsp_sdram2uart() {
//void rsp_sdram2uart() {

   // with this line being always checked in the main loop,
   //  its conditions have to be short and efficient
  if (CSR->uart_tx.fld.busy || (task.hal.adc_uarting == 0x0000)) return;

   // UART_TX has a 16-deep FIFO: 
   //  Keep the FIFO full to maximize utilization of serial line
   // do {
     switch (adc_byte_cnt) {
       
     //===header===
      case 0: // RSP_START
         CSR -> uart_tx.fld.data = '$'; // send '$' to UART_TX
         break;

     //- - - - - - - - - - - - - - -
     #ifdef ADC_SDRAM2UART_BINARY
      case 1: // RSP_ID
         CSR -> uart_tx.fld.data = adc_num_bytes.fld.b0;
         break;

      case 2: // separator
         CSR -> uart_tx.fld.data = ',';
         break;

      case 3: // NUM_BYTES[2]
         adc_num_bytes.all = mul3(adc_rx.fld.sample_cnt);
         CSR -> uart_tx.fld.data = adc_num_bytes.fld.b2;
         break;
      case 4: // NUM_BYTES[1]
         CSR -> uart_tx.fld.data = adc_num_bytes.fld.b1;
         break;
      case 5: // NUM_BYTES[0]
         CSR -> uart_tx.fld.data = adc_num_bytes.fld.b0;
         break;

      case 6: // separator
         CSR -> uart_tx.fld.data = ',';
         adc_sample_cnt = 0;
         break;
       
     //===samples===
      case 7: // SAMPLE_BYTE[2]
         // retrieve 3-byte sample from SDRAM and send MSByte
         adc_sample.all = *adc_sdram_addr;
         CSR -> uart_tx.fld.data = adc_sample.fld.b2;
         break;
      case 8: // SAMPLE_BYTE[1]
         CSR -> uart_tx.fld.data = adc_sample.fld.b1;
         break;
      case 9: // SAMPLE_BYTE[0]
         CSR -> uart_tx.fld.data = adc_sample.fld.b0;
       
         // rinse-and-repeat, until all samples are sent
         adc_sample_cnt++;
         adc_sdram_addr++;

         if (adc_sample_cnt != adc_rx.fld.sample_cnt) {
            adc_byte_cnt = 6;
         }  
         break;

     //- - - - - - - - - - - - - - -
     #else // !ADC_SDRAM2UART_BINARY
      case 1: // RSP_ID
         CSR -> uart_tx.fld.data = adc_num_bytes.fld.b0 + 48;
         break;

      case 2: // separator
         CSR -> uart_tx.fld.data = ',';
         break;

      case 3: // NUM_BYTES[2]
         adc_num_bytes.all = mul3(adc_rx.fld.sample_cnt);
         uart_send_hex (adc_num_bytes.fld.b2, 2); 
         break;
      case 4: // NUM_BYTES[1]
         uart_send_hex (adc_num_bytes.fld.b1, 2);
         break;
      case 5: // NUM_BYTES[0]
         uart_send_hex (adc_num_bytes.fld.b0, 2);
         break;

      case 6: // separator
         CSR -> uart_tx.fld.data = ',';
         adc_sample_cnt = 0;
         break;
       
     //===samples===
      case 7: // SAMPLE_BYTE[2]
         // retrieve 3-byte sample from SDRAM and send MSByte
         adc_sample.all = *adc_sdram_addr; 
         uart_send_hex (adc_sample.fld.b2, 2);
         break;
      case 8: // SAMPLE_BYTE[1]
         uart_send_hex (adc_sample.fld.b1, 2);
         break;
      case 9: // SAMPLE_BYTE[0]
         uart_send_hex (adc_sample.fld.b0, 2);
       
         // rinse-and-repeat, until all samples are sent
         adc_sample_cnt++;
         adc_sdram_addr++;
       
         if (adc_sample_cnt != adc_rx.fld.sample_cnt) {
            adc_byte_cnt = 6;
         }  
         break;
     #endif 
     //- - - - - - - - - - - - - - -

     //===footer===
      case 10: // RSP_END[1]
         CSR -> uart_tx.fld.data = '\r';

         // Before declaring the completion of ADC measurement, we have
         // to wait for all SDRAM samples to be uploaded. Otherwise a
         // new measurement may start and override samples that have not
         // been uploaded. We do it here to free up access to new Cmd as
         // soon as possible ("\r\n" transfer over slow UART takes a while)
         if (task.fld.adc1_uarting == 0xFF) task.fld.adc1_started = 0x00;
         if (task.fld.adc2_uarting == 0xFF) task.fld.adc2_started = 0x00;

         break;
       
      case 11: // RSP_END[0]
         CSR -> uart_tx.fld.data = '\n';

         if (task.fld.adc1_uarting == 0xFF) task.fld.adc1_uarting = 0x00;
         if (task.fld.adc2_uarting == 0xFF) task.fld.adc2_uarting = 0x00;
   }

   // prep the next byte
   adc_byte_cnt++;

   //} while (   (task.fld.tx_uarting == 0xFF)
   //         && !CSR->uart_tx.fld.busy);
}

     
/**********************************************************************
 * Main
 *---------------------------------------------------------------------
 * Despite not having an OS, we implemented a degree of concurrency and
 * rudimentary multi-tasking, allowing reception of new commands while
 * the earlier ones are still in execution. Provided new commands are 
 * for different targets, in addition to supporting their reception, we
 * can also dispatch them w/o waiting for the completion of already 
 * dispatched tasks.However, should a target be busy when new command 
 * arrives for it, this program will not wait, i.e. it will not block 
 * the CPU. Instead, it'll SILENTLY DISCARD the new command, and keep
 * going. It's worth noting here that HW does not allow interrupting a
 * command that has already started. 
 *
 * In follow on projects, we can consider:
 *  -implementing back channel for reporting discarded commands (Errors)
 *  -waiting instead of immediately discarding, possibly with timeout
 *  -possibly also returning XOFF, or implementing another Flow Control
 *   mechanism that would tell Master to stop sending additional commands
 *  -implementing queue for these excessive commands
 *  -this new CmdQueue could also use XOFF-and-Wait approach when full
 *  -or devise and implement another mechanism
 *
 * For speed, we strive to streamline function calls in the main loop, \
 * and maximize the use of inlined code.
 **********************************************************************/
void main() {

//=======================
// Standalone point tests of peripheral resources. Used to validate
// the hardware part of system and illustrate HW/SW handshake. They
// are all blocking / not designed to extract maximum performance
//=======================

// start with both LEDs turned off
CSR->gpo.fld.led_off = 0x3;

#ifdef MEMTEST
   mem_test();
#endif // MEMTEST

#ifdef UART_TEST
   uart_test();
#endif // UART_TEST

#ifdef DAC_TEST
   dac_test();
#endif //DAC_TEST

#ifdef ADC_TEST
   adc_test();
#endif //ADC_TEST

   
//=======================
// Master loop. This is the "production", non-blocking code
//=======================
   while (1) {
     cmd_recv();       // service UART_RX and parse Command
     cmd_dispatch();   // send Command to its target resource

     rsp_dispatch();   // decide which of two ADC samples to upload
     rsp_sdram2uart(); // upload those samples to PC, via UART
   }
}

//==========================================================================
// End-of-File
//==========================================================================
