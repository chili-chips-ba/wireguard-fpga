// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 5th August 2021
//
// This file is part of the rv32_cpu instruction set simulator.
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

#ifndef _RV32_CPU_GDB_H_
#define _RV32_CPU_GDB_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include "rv32.h"

// -------------------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------------------

#if defined (_WIN32) || defined (_WIN64)

// -------------------------------------------------------------------------
// DEFINITIONS (windows)
// -------------------------------------------------------------------------

// Define the max supported winsocket spec. major and minor numbers
# define VER_MAJOR           2
# define VER_MINOR           2

# define BAUDRATE             CBR_19200
# define PTY_HDL              HANDLE

// -------------------------------------------------------------------------
// TYPEDEFS (windows)
// -------------------------------------------------------------------------

// Map the socket type for windows  
#include <Winsock2.h>
typedef SOCKET rv32gdb_skt_t;
    
#else
    
// -------------------------------------------------------------------------
// TYPEDEFS (Linux)
// -------------------------------------------------------------------------

// Map the socket type for Linux  
typedef long long rv32gdb_skt_t;

// -------------------------------------------------------------------------
// DEFINITIONS (Linux)
// -------------------------------------------------------------------------

# define BAUDRATE             B19200
# define PTY_HDL              rv32gdb_skt_t

// Map some windows function names to the file access Linux equivalents
# define closesocket         close
# define ZeroMemory          bzero

#endif

#define RV32GDB_OK                                     0
#define RV32GDB_ERR                                    -1
 
#define IP_BUFFER_SIZE                                 1024
#define OP_BUFFER_SIZE                                 1024
#define PTY_ERROR                                      RV32GDB_ERR
#define GDB_ACK_CHAR                                   '+'
#define GDB_NAK_CHAR                                   '-'
#define GDB_SOP_CHAR                                   '$'
#define GDB_EOP_CHAR                                   '#'
#define GDB_MEM_DELIM_CHAR                             ':'
#define GDB_BIN_ESC                                    0x7d
#define GDB_BIN_XOR_VAL                                0x20
#define HEX_CHAR_MAP                                   {'0', '1', '2', '3', \
                                                        '4', '5', '6', '7', \
                                                        '8', '9', 'a', 'b', \
                                                        'c', 'd', 'e', 'f'}

#define MAXBACKLOG                                     5

#define RV32I_MEM_NOT_DBG_MASK                         0x0f
#define RV32I_MEM_DBG_MASK                             0x10

#define RV32I_MEM_RD_GDB_BYTE                          (MEM_RD_ACCESS_BYTE | RV32I_MEM_DBG_MASK) 
#define RV32I_MEM_RNW_MASK                             0x4

// Execution types
#define RV32_FOREVER                                   (-1)
#define RV32_ONCE                                      1

#define RV32_RUN_FROM_RESET                            0
#define RV32_RUN_CONTINUE                              1
#define RV32_RUN_SINGLE_STEP                           2
#define RV32_RUN_TICK                                  3

// Break point types
#define RV32_USER_BREAK                                1
#define RV32_LOCK_BREAK                                2
#define RV32_DISASSEMBLE_BREAK                         3
#define RV32_HW_BREAKPOINT_BREAK                       4
#define RV32_HW_WATCHPOINT_BREAK                       5
#define RV32_SINGLE_STEP_BREAK                         6
#define RV32_TICK_BREAK                                7
#define RV32_RESET_BREAK                               8
#define RV32_INT_BREAK                                 9
#define RV32_BUS_ERROR_BREAK                           10
#define RV32_DIV_ZERO_BREAK                            11
#define RV32_ILLEGAL_INSTR                             12

// -------------------------------------------------------------------------
// MACRO DEFINITIONS
// -------------------------------------------------------------------------                               

#define HIHEXCHAR(_x) hexchars[((_x) & 0xf0) >> 4]
#define LOHEXCHAR(_x) hexchars[ (_x) & 0x0f]

#define CHAR2NIB(_x) (((_x) >= '0' && (_x) <= '9') ? (_x) - '0': \
                      ((_x) >= 'a' && (_x) <= 'f') ? (10 + (_x) - 'a'): \
                                                     (10 + (_x) - 'A'))

#define BUFBYTE(_b,_i,_v) {     \
    _b[_i]     = HIHEXCHAR(_v); \
    _b[(_i)+1] = LOHEXCHAR(_v); \
    _i        += 2;             \
}
#define BUFWORD(_b,_i,_v) {     \
    BUFBYTE(_b,_i,(_v) >> 24);  \
    BUFBYTE(_b,_i,(_v) >> 16);  \
    BUFBYTE(_b,_i,(_v) >>  8);  \
    BUFBYTE(_b,_i,(_v) >>  0);  \
}

#define BUFWORDLE(_b,_i,_v) {   \
    BUFBYTE(_b,_i,(_v) >>  0);  \
    BUFBYTE(_b,_i,(_v) >>  8);  \
    BUFBYTE(_b,_i,(_v) >> 16);  \
    BUFBYTE(_b,_i,(_v) >> 24);  \
}

#define BUFOK(_b,_i,_c) {_c += _b[_i] = 'O'; _c += _b[_i+1] = 'K'; _i+=2;}

#define BUFERR(_e,_b,_i,_c) {_c += _b[_i] = 'E'; _c += _b[_i+1] = HIHEXCHAR(_e); _c += _b[_i+2] = LOHEXCHAR(_e); _i+=3;}

// -------------------------------------------------------------------------
// ENUMERATIONS
// -------------------------------------------------------------------------

// Indexes/IDs of RV32 registers that match GDB's expectations
enum lm32gdb_regs_e 
{
  RV32_REG_R0,  RV32_REG_R1,  RV32_REG_R2,  RV32_REG_R3,   
  RV32_REG_R4,  RV32_REG_R5,  RV32_REG_R6,  RV32_REG_R7,
  RV32_REG_R8,  RV32_REG_R9,  RV32_REG_R10, RV32_REG_R11,
  RV32_REG_R12, RV32_REG_R13, RV32_REG_R14, RV32_REG_R15,
  RV32_REG_R16, RV32_REG_R17, RV32_REG_R18, RV32_REG_R19,
  RV32_REG_R20, RV32_REG_R21, RV32_REG_R22, RV32_REG_R23,
  RV32_REG_R24, RV32_REG_R25, RV32_REG_R26, RV32_REG_R27,
  RV32_REG_R28, RV32_REG_R29, RV32_REG_R30, RV32_REG_R31,
  RV32_REG_PC,
  NUM_REGS
};

// -------------------------------------------------------------------------
// PUBLIC PROTOTYPES
// -------------------------------------------------------------------------

extern int rv32gdb_process_gdb (rv32* cpu, int port_num, rv32i_cfg_s &cfg);

#endif   
