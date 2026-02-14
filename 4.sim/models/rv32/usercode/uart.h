// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
// 
// Copyright (c) 2022 Simon Southwell. All rights reserved.
//
// Date: 20th January 2022
//
// Header for a model of a 16450 UART
//
// This file is part of the rv32_cpu ISS .
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
// along with ths code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#ifndef _UART_H_
#define _UART_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include "rv32i_cpu_hdr.h"

// -------------------------------------------------------------------------
// PUBLIC DEFINES
// -------------------------------------------------------------------------

// The  UART has 8 registers
#define UART_NUM_REGS                   8
#define UART_REG_ADDR_MASK              0xffffffe0

// Up to 4 UART contexts supported
#define MAX_NUM_UARTS                   4

// Number of clock cycles for each bit (for timing modelling). Change to match system clock and baud rate.
#define UART_TICKS_PER_BIT              1

// -------------------------------------------------------------------------
// PUBLIC TYPE DEFINITIONS
// -------------------------------------------------------------------------

typedef struct
{
    time_t               start_time[MAX_NUM_UARTS];
    bool                 int_pending[MAX_NUM_UARTS];
    uint32_t             uart_regs[MAX_NUM_UARTS][UART_NUM_REGS];
} uart_state_t;

// -------------------------------------------------------------------------
// PUBLIC FUNCTION DEFINITIONS
// -------------------------------------------------------------------------

extern void              uart_write      (const uint32_t address, const uint32_t data, const int cntx = 0);
extern void              uart_read       (const uint32_t address, uint32_t* data,      const int cntx = 0);
extern bool              uart_tick       (const time_t   time,    bool &terminate,     const bool kbd_connected = false, const int cntx = 0);
extern uart_state_t      get_uart_state  (void);
extern void              set_uart_state  (const uart_state_t state);
extern int               uart_reg_access (const uint32_t byte_addr, uint32_t& data, const int type, const uint32_t uart0_base_addr);
#endif
