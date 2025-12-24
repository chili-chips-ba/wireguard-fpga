//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
//   - UART library
//==========================================================================

#include "uart.h"

/**********************************************************************
 * Function:    uart_send_char()
 *
 * Description: Sends a single characters to UART HW Controller
 *
 * Returns:     None
 **********************************************************************/
void uart_send_char (volatile csr_vp_t* csr, char c) {
   // wait for HW "not busy", then send the byte/character
   while (csr->uart->tx->busy());
   csr->uart->tx->data(c);
}

/**********************************************************************
 * Function:    uart_send_hex()
 *
 * Description: Converts decimal to a string of ASCII HEX characters
 *              and sends them to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send_hex (volatile csr_vp_t* csr, unsigned int val, int digits) {
   for (int i = (4*digits) - 4; i >= 0; i -= 4)
      uart_send_char(csr, "0123456789ABCDEF"[(val >> i) % 16]);
}

/**********************************************************************
 * Function:    uart_send_dec()
 *
 * Description: Converts 0-255 decimal value to a string of
 *              ASCII characters and sends them to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send_dec(volatile csr_vp_t* csr, uint16_t val) {
   if (val == 0) {
      uart_send_char(csr, '0');
      return;
   }

   uint16_t divisor = 1;

   while (divisor <= val / 10) {
      divisor *= 10;
   }

   while (divisor > 0) {
      uint16_t digit = val / divisor;
      uart_send_char(csr, digit + '0');
      val -= digit * divisor;
      divisor /= 10;
   }
}

/**********************************************************************
 * Function:    uart_send()
 *
 * Description: Sends a string of characters to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send (volatile csr_vp_t* csr, const char *s) {
   while (*s) uart_send_char(csr, *(s++));
}

/**********************************************************************
 * Function:    uart_send_ip()
 *
 * Description: Sends IP address (xxx.xxx.xxx.xxx) to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send_ip(volatile csr_vp_t* csr, const uint8_t *ip) {
   uart_send_dec(csr, ip[0]);
   uart_send_char(csr, '.');
   uart_send_dec(csr, ip[1]);
   uart_send_char(csr, '.');
   uart_send_dec(csr, ip[2]);
   uart_send_char(csr, '.');
   uart_send_dec(csr, ip[3]);
}

/**********************************************************************
 * Function:    uart_send_ip()
 *
 * Description: Sends MAC address (xx:xx:xx:xx:xx:xx) to UART
 *
 * Returns:     None
 **********************************************************************/
void uart_send_mac(volatile csr_vp_t* csr, const uint8_t *mac) {
   uart_send_hex(csr, mac[0], 2);
   uart_send_char(csr, ':');
   uart_send_hex(csr, mac[1], 2);
   uart_send_char(csr, ':');
   uart_send_hex(csr, mac[2], 2);
   uart_send_char(csr, ':');
   uart_send_hex(csr, mac[3], 2);
   uart_send_char(csr, ':');
   uart_send_hex(csr, mac[4], 2);
   uart_send_char(csr, ':');
   uart_send_hex(csr, mac[5], 2);
}

/**********************************************************************
 * Function:    uart_recv()
 *
 * Description: Receive data from UART HW until <CR> or <CR><LF>
 *              arrives, printing echo
 *
 * Returns:     None
 **********************************************************************/
uint8_t uart_recv(volatile csr_vp_t* csr, char *s) {
   uint32_t uart_rx;

   // Check for available data:
   uart_rx = csr->uart->rx->full();
   if (uart_rx & UART_RX_VALID) {
      // if SOP received, ignore RX;
      if ((uart_rx & UART_RX_DATA) == UART_SOP)
         return 0;
      
      // otherwise, keep reading from UART until user enters <ENTER>,
      //  or allocated buffer is exhausted
      //  (UART_RXBUF_SIZE-1) opens space to append NULL
      int i = 0;
      while (i < UART_RXBUF_SIZE-1) {
         // Store received character
         *s = (char)(uart_rx & UART_RX_DATA);
         
         // <CR> or <CR><LF> indicates end of user input
         // Ignore <LF> and exit
         if (*s == '\n') {
            break;
         // On <CR> echo back <CR><LF> and exit
         } else if (*s == '\r') {
            uart_send_char(csr, '\r');
            uart_send_char(csr, '\n');
            break;
         } else {
            // On <BS> or <DEL> remove previously received
            //  character and echo back <BS><SPACE><BS>;
            if (*s == '\b' || *s == UART_DEL) {
               if (i > 0) {
                  s--;
                  i--;
                  uart_send_char(csr, '\b');
                  uart_send_char(csr, ' ');
                  uart_send_char(csr, '\b');
               }               
            // otherwise, echo back and append received character
            } else {
               uart_send_char(csr, *s);
               s++;
               i++;
            }            
         }

         // wait for HW to collect one byte/character
         //  (*) due to Clear-on-Read nature of VALID and OFLOW flags,
         //      this MUST BE ONE SHOT READ. Otherwise, both data and
         //      flags could be lost
         //
         // (**) since this is a tight loop, we in this case
         //      don't need to look at 'uart_rx.fld.oflow'
         do {
            uart_rx = csr->uart->rx->full();
         } while (!(uart_rx & UART_RX_VALID));
      };
      
      // Append NULL
      *s = '\0';
      
      return i;
   } else {
      return 0;
   }
}

#ifdef UART_TEST
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
void uart_test(volatile csr_vp_t* csr) {
   const char *rx_expd = "Mi smo FPGA raja";
   char        rx_data[UART_RXBUF_SIZE];
   char       *rx_data_ptr;
   int         result;

   uart_send(csr, (char*)"\r\n\nSelam eduSOC Hackers!\r\n");
   uart_send(csr, (char*)"Try guessing 3 times what I'm thinking, then press <ENTER>.\r\n");

   for (int i=3; i>0; i--) {
      //take input from UART and store it into allocated buffer
      rx_data_ptr = &rx_data[0];
      while(!uart_recv(csr, rx_data_ptr));

      uart_send(csr, (char*)"\r\n\n\tYou entered: ");
      uart_send(csr, rx_data_ptr);

      // check received data
      if (strcmp(rx_expd, rx_data_ptr) == 0) {
          //CSR -> gpo.fld.led_off = 0b10; // turn on first LED
          uart_send(csr, (char*)"\r\n\t| You hit it! :-)\r\n");
          break;

      // mismatch
      } else {
          //CSR -> gpo.fld.led_off = 0b11; // turn off all LEDs
          uart_send(csr, (char*)"\r\n\t| Sorry, you missed it.");

          if (i>1) {
            uart_send(csr, (char*)"\r\n\t| ...Try again. Credit left: ");
            uart_send_hex(csr, i-1, 1);
            uart_send(csr, (char*)"\r\n\n\n");
          }
      }
   }

   uart_send(csr, (char*)"\r\nDONE!\r\n");
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
void uart_tests_info(volatile csr_vp_t* csr, int cmd) {

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
      uart_send(csr, tests_list[cmd]);
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

      uart_send(csr, message);
   }
}
#endif // RISCV_TESTS

//==========================================================================
// End-of-File
//==========================================================================
