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
//   - UART test code,
//       serves primarily as a demo on how to operate UART resource from SW
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

/**********************************************************************
 * Function:    uart_send_char()
 *
 * Description: Sends a single characters to UART HW Controller
 *
 * Returns:     None
 **********************************************************************/
void uart_send_char (char c) {
   // wait for HW "not busy", then send the byte/character
   while (CSR -> uart_tx.fld.busy);
   CSR -> uart_tx.fld.data = c;
}

/**********************************************************************
 * Function:    uart_send_hex()
 *
 * Description: Converts decimal to a string of ASCII HEX characters
 *              and sends them to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send_hex (unsigned int val, int digits) {
   for (int i = (4*digits) - 4; i >= 0; i -= 4)
      uart_send_char("0123456789ABCDEF"[(val >> i) % 16]);
}

/**********************************************************************
 * Function:    uart_send()
 *
 * Description: Sends a string of characters to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send (const char *s) {
   while (*s) uart_send_char(*(s++));
}


#ifdef UART_TEST
/**********************************************************************
 * Function:    uart_recv()
 *
 * Description: Receive data from UART HW until CR arrives,
 *              printing echo
 *
 * Returns:     None
 **********************************************************************/
void uart_recv(char *s) {
  uint32_t uart_rx;

  // keep reading from UART until user enters <ENTER>,
  //  or allocated buffer is exhausted
  //  (UART_RXBUF_SIZE-1) opens space to append NULL
  for (int i=0; i<(UART_RXBUF_SIZE-1); i++) {

      // wait for HW to collect one byte/character
      //  (*) due to Clear-on-Read nature of VALID and OFLOW flags,
      //      this MUST BE ONE SHOT READ. Otherwise, both data and
      //      flags could be lost
      //
      // (**) since this is a tight loop, we in this case
      //      don't need to look at 'uart_rx.fld.oflow'
      do {
         uart_rx = CSR->uart_rx.all;
      } while (!(uart_rx & UART_RX_VALID));

      // store received data and print it back (echo function)
      *s = (char)(uart_rx & UART_RX_DATA);
      uart_send_char(*s);

      // <LF> indicates end of user input: Append NULL and exit
      if ((*s == '\n') || (i == UART_RXBUF_SIZE-1)) {
         s++;
         *s = '\0';
         break;
      }

      s++;
   };
}

/**********************************************************************
 * Function:    uart_test()
 *
 * Description: Simple test of UART input/output, with gaming mindset.
 *              The objectives are to:
 *               - test the RTL implementation of all relevant logic
 *               - illustrate the handshake between SW and HW
 *               - provide a foundation for development of "production"
 *                 code for UART resource
 *
 * Returns:     None
 **********************************************************************/
void uart_test(void) {
   const char *rx_expd = "Mi smo FPGA raja\r\n";
   char        rx_data[UART_RXBUF_SIZE];
   char       *rx_data_ptr;
   int         result;

   uart_send((char*)"\r\n\nSelam eduSOC Hackers!\r\n");
   uart_send((char*)"Try guessing 3 times what I'm thinking, then press <ENTER>.\r\n");

   for (int i=3; i>0; i--) {
      //take input from UART and store it into allocated buffer
      rx_data_ptr = &rx_data[0];
      uart_recv(rx_data_ptr);

      uart_send((char*)"\r\n\n\tYou entered: ");
      uart_send(rx_data_ptr);

      // check received data
      if (strcmp(rx_expd, rx_data_ptr) == 0) {
          CSR -> gpo.fld.led_off = 0b10; // turn on first LED
          uart_send((char*)"\r\n\t| You hit it! :-)\r\n");
          break;

      // mismatch
      } else {
          CSR -> gpo.fld.led_off = 0b11; // turn off all LEDs
          uart_send((char*)"\r\n\t| Sorry, you missed it.");

          if (i>1) {
            uart_send((char*)"\r\n\t| ...Try again. Credit left: ");
            uart_send_hex(i-1, 1);
            uart_send((char*)"\r\n\n\n");
          }
      }
   }

   uart_send((char*)"\r\nDONE!\r\n");
}
#endif // UART_TEST


#ifdef RISCV_TEST
/**********************************************************************
 * Function:    uart_tests_info(int cmd)
 *
 * Description: Sends RISC-V test info to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_tests_info(int cmd) {

   char *tests_list[] = {
    "OK!\r\n\r\n",
    "ERROR!\r\n\r\n",
    "add", "addi", "and", "andi", "auipc",
    "beq", "bge", "bgeu", "blt", "bltu", "bne", "jal", "jalr",
    "lb", "lbu", "lh", "lhu", "lui", "lw",
    "ma_data", "or", "ori",
    "sb", "sh", "simple",
    "sll", "slli", "slt", "slti", "sltiu", "sltu",
    "sra", "srai", "srl", "srli",
    "sub", "sw",
    "xor", "xori",
    "breakpoint", "csr",
    "illegal", "lh-misaligned",
    "lw-misaligned", "ma_addr",
    "ma_fetch", "mcsr",
    "sbreak", "scall",
    "sh-misaligned", "shamt",
    "sw-misaligned", "zicntr"};

   // UART signalizes test start and result
   if (cmd == 0 || cmd == 1) {
      uart_send(tests_list[cmd]);
   }
   else {
      char message [32];

      char *prefix = "Testing: ";
      char *mes_ptr = message;
      char *tst_ptr = tests_list[cmd];

      while (*prefix)
      {
         *mes_ptr++ = *prefix++;
      }

      while (*tst_ptr)
      {
         *mes_ptr++ = *tst_ptr++;
      }

      *mes_ptr++ =  '\r';
      *mes_ptr++ =  '\n';
      *mes_ptr++ =  '\0';

      uart_send(message);
   }
}
#endif // RISCV_TESTS

//==========================================================================
// End-of-File
//==========================================================================
