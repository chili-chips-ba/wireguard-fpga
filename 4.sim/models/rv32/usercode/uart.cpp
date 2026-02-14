// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
// 
// Copyright (c) 2022 Simon Southwell. All rights reserved.
//
// Date: 20th January 2022
//
// Model for a 16450 UART
//
// This file is part of the rv32_cpu ISS linux system model.
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdint>
#include <cstdio>
#if defined _WIN32 || defined _WIN64
#include <conio.h>
#else
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#endif

#include "uart.h"

// -------------------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------------------

#define UART_RBR_REG                   0x00
#define UART_IER_REG                   0x04
#define UART_IIR_REG                   0x08
#define UART_LCR_REG                   0x0C
#define UART_MCR_REG                   0x10
#define UART_LSR_REG                   0x14
#define UART_MSR_REG                   0x18
#define UART_DIV_REG                   0x1c

#define UART_RBR_WR_MASK               0x000000ff
#define UART_IER_WR_MASK               0x0000000f
#define UART_LCR_WR_MASK               0x0000007f
#define UART_MCR_WR_MASK               0x00000003
#define UART_DIV_WR_MASK               0x0000000f

#define UART_LSR_DR_BIT                0x01
#define UART_LSR_OE_BIT                0x02
#define UART_LSR_PE_BIT                0x04
#define UART_LSR_FE_BIT                0x08
#define UART_LSR_BI_BIT                0x10
#define UART_LSR_THRR_BIT              0x20
#define UART_LSR_TEMT_BIT              0x40

#define UART_IER_RBRI_BIT              0x01
#define UART_IER_THRI_BIT              0x02
#define UART_IER_RLSI_BIT              0x04
#define UART_IER_MSI_BIT               0x08

#define UART_INT_ID_NONE               0x01
#define UART_INT_ID_ERR                0x06
#define UART_INT_ID_RDR                0x04
#define UART_INT_ID_EMP                0x02
#define UART_INT_ID_MST                0x00

#define UART_LSR_RST_VAL               (UART_LSR_THRR_BIT | UART_LSR_TEMT_BIT)
#define UART_REGS_RST_VALS             {0, 0, 0, 0, 0, UART_LSR_RST_VAL, 0, 0}

#define TERMINATE_STR_LEN 8
#if defined _WIN32 || defined _WIN32
#define NEWLINE_CHAR                   0x0d
#else
#define NEWLINE_CHAR                   0x0a
#endif

// Hide input function specifics for ease of future updating
#define OUTPUT_TTY(_x)                 putchar(_x)
#define INPUT_RDY_TTY                  _kbhit
#define GET_INPUT_TTY                  _getch

// -------------------------------------------------------------------------
// LOCAL CONSTANTS
// -------------------------------------------------------------------------

static const uint32_t terminate_str[TERMINATE_STR_LEN] = {'#', '!', 'e', 'x', 'i', 't', '!', NEWLINE_CHAR};

// -------------------------------------------------------------------------
// LOCAL STATICS
// -------------------------------------------------------------------------

uart_state_t uart_state = {
    {0, 0, 0, 0},
    {false, false, false, false},
    {UART_REGS_RST_VALS,
     UART_REGS_RST_VALS,
     UART_REGS_RST_VALS,
     UART_REGS_RST_VALS}
};

#if !(defined _WIN32) && !defined(_WIN64)
// -------------------------------------------------------------------------
// Keyboard input LINUX/CYGWIN emulation functions
// -------------------------------------------------------------------------


// Implement _kbhit() locally for non-windows platforms
int _kbhit(void)
{
  struct termios oldt, newt;
  int ch;
  int oldf;
 
  tcgetattr(STDIN_FILENO, &oldt);
  newt           = oldt;
  newt.c_lflag &= ~(ICANON | ECHO);

  tcsetattr(STDIN_FILENO, TCSANOW, &newt);
  oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
  fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
 
  ch = getchar();
 
  tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
  fcntl(STDIN_FILENO, F_SETFL, oldf);
 
  if(ch != EOF)
  {
      ungetc(ch, stdin);
      return 1;
  }
 
  return 0;
}

// getchar() is okay for _getch() on non-windows platforms
#define _getch getchar

#endif

// -------------------------------------------------------------------------
// uart_write()
//
// UART model register write function.
//
// -------------------------------------------------------------------------

void uart_write(const uint32_t address, const uint32_t data, const int cntx)
{
    switch(address)
    {
    case UART_RBR_REG:
        // Print the character
        OUTPUT_TTY(data & UART_RBR_WR_MASK);

        // Flush the output
        fflush(stdout);

        // Clear the TEMPT and THRR (aka THRE) bit
        uart_state.uart_regs[cntx][UART_LSR_REG >> 2] = uart_state.uart_regs[cntx][UART_LSR_REG >> 2] & ~(UART_LSR_TEMT_BIT | UART_LSR_THRR_BIT);
        uart_state.int_pending[cntx] = false;
        break;

    case UART_IER_REG:
        uart_state.uart_regs[cntx][UART_IER_REG >> 2] = data & UART_IER_WR_MASK;
        break;

    case UART_LCR_REG:
        uart_state.uart_regs[cntx][UART_LCR_REG >> 2] = data & UART_LCR_WR_MASK;
        break;

    case UART_MCR_REG:
        uart_state.uart_regs[cntx][UART_MCR_REG >> 2] = data & UART_MCR_WR_MASK;
        break;

    case UART_DIV_REG:
        uart_state.uart_regs[cntx][UART_DIV_REG >> 2] = data & 0xffff;
        break;

    default:
        break;
    }
}

// -------------------------------------------------------------------------
// uart_read()
//
// UART model register read function.
//
// -------------------------------------------------------------------------

void uart_read(const uint32_t address, uint32_t* data, const int cntx)
{
    *data = 0;
    switch(address)
    {
    case UART_RBR_REG:
        *data = uart_state.uart_regs[cntx][UART_RBR_REG >> 2];
        uart_state.uart_regs[cntx][UART_LSR_REG >> 2] &= ~UART_LSR_DR_BIT;
        break;

    case UART_IIR_REG:
        *data = uart_state.uart_regs[cntx][UART_IIR_REG >> 2];
        break;

    case UART_LSR_REG:
        *data = uart_state.uart_regs[cntx][UART_LSR_REG >> 2];
        break;

    case UART_MSR_REG:
        *data = uart_state.uart_regs[cntx][UART_MSR_REG >> 2];
        break;
    }
}

// -------------------------------------------------------------------------
// uart_tick()
//
// UART model tick/interrupt function. Called regularly, with time stamp
// and generates interrupts, and updates register state.
//
// -------------------------------------------------------------------------

bool uart_tick(const time_t time, bool &terminate, const bool kbd_connected, const int cntx)
{
    bool irq = false;

    // If we're transmitting, but start time is 0, TX has just started
    if ((uart_state.uart_regs[cntx][UART_LSR_REG >> 2] & (UART_LSR_TEMT_BIT | UART_LSR_THRR_BIT)) == 0 && uart_state.start_time[cntx] == 0)
    {
        // Load start time with current time
        uart_state.start_time[cntx] = time;
    }

    // When a transmission time has elapsed (assuming start, stop, parity and 8 data bits),
    // clear the time and set the transmit status
    if (time >= (uart_state.start_time[cntx] + UART_TICKS_PER_BIT))
    {
        // Clear start time
        uart_state.start_time[cntx] = 0;
        uart_state.uart_regs[cntx][UART_LSR_REG >> 2] |= UART_LSR_TEMT_BIT | UART_LSR_THRR_BIT;
    }

    // When UART with keyboard connected, and input is waiting, get the value and put in RBR register,
    // then flag data ready status
    if (kbd_connected && INPUT_RDY_TTY())
    {
        // Since only one UART can be the input, only need one terminate index state
        static int term_idx = 0;

        // Get the input character and put in the RBR register
        uint32_t  cur = GET_INPUT_TTY() & 0xffU;
        uart_state.uart_regs[cntx][UART_RBR_REG >> 2] = cur;

        // Set the data received flag in the LSR register
        uart_state.uart_regs[cntx][UART_LSR_REG >> 2] |= UART_LSR_DR_BIT;

        // If the input character matches the current termination character...
        if (cur == terminate_str[term_idx])
        {
            // Increment the index to the next character in the table.
            term_idx++;
            if (term_idx == TERMINATE_STR_LEN)
            {
                terminate = true;
            }
        }
        // Character did not match the next termination character, so reset the index
        else
        {
            // If the failing character is also the first of the terminating characters,
            // set index to 1, otherwise reset to 0.
            term_idx = (cur == terminate_str[0]) ? 1 : 0;
        }
    }

    // Update interrupts...

    // By default, the status is that there are no interrupts pending
    uart_state.uart_regs[cntx][UART_IIR_REG >> 2] = UART_INT_ID_NONE;

    // Overrun error interrupt (PE, FE and BI not yet supported)
    if ((uart_state.uart_regs[cntx][UART_LSR_REG >> 2] & UART_LSR_OE_BIT) &&
        (uart_state.uart_regs[cntx][UART_IER_REG >> 2] & UART_IER_RLSI_BIT))
    {
        irq = true;
        uart_state.int_pending[cntx] = true;
        uart_state.uart_regs[cntx][UART_IIR_REG >> 2] = UART_INT_ID_ERR;
    }
    // Data received
    else if ((uart_state.uart_regs[cntx][UART_LSR_REG >> 2] & UART_LSR_DR_BIT) &&
             (uart_state.uart_regs[cntx][UART_IER_REG >> 2] & UART_IER_RBRI_BIT))
    {
        irq = true;
        uart_state.int_pending[cntx] = true;
        uart_state.uart_regs[cntx][UART_IIR_REG >> 2] = UART_INT_ID_RDR;
    }
    // Transmit buffer empty (transmit ready to send)
    else if ((uart_state.uart_regs[cntx][UART_LSR_REG >> 2] & UART_LSR_THRR_BIT) &&
             (uart_state.uart_regs[cntx][UART_IER_REG >> 2] & UART_IER_THRI_BIT))
    {
        irq = true;
        uart_state.int_pending[cntx] = true;
        uart_state.uart_regs[cntx][UART_IIR_REG >> 2] = UART_INT_ID_EMP;
    }

    return irq;
}

// -------------------------------------------------------------------------
// get_uart_state()
//
// Utility function to get the UARTS's entire internal state, for use
// in save and restore functionality.
//
// -------------------------------------------------------------------------

uart_state_t get_uart_state(void)
{
    return uart_state;
}

// -------------------------------------------------------------------------
// set_uart_state()
//
// Utility function to set the UARTS's entire internal state, for use
// in save and restore functionality.
//
// -------------------------------------------------------------------------

void set_uart_state (const uart_state_t state)
{
    uart_state = state;
}

// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

int uart_reg_access(const uint32_t byte_addr, uint32_t& data, const int type, const uint32_t uart0_base_addr)
{
    int processed = RV32I_EXT_MEM_NOT_PROCESSED;
    
    // If accessing the UART addresses then process here
    if ((byte_addr & UART_REG_ADDR_MASK) == uart0_base_addr)
    {
        processed = 0;
        
        // If writing to the UART registers, call the model's write function
        if (type == MEM_WR_ACCESS_BYTE || type == MEM_WR_ACCESS_HWORD || type == MEM_WR_ACCESS_WORD)
        {
            uart_write(byte_addr & 0x1f, data & 0xff);
        }
        else if (type == MEM_RD_ACCESS_BYTE || type == MEM_RD_ACCESS_HWORD || type == MEM_RD_ACCESS_WORD)
        {
            uint32_t rxdata;
            uart_read(byte_addr & 0x1f, &rxdata);
            data = rxdata;
        }
    }
    
    return processed;
}
