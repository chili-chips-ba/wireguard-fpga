//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 12th July 2021
//
// Contains the definitions for the rv32csr_cpu derived class
//
// This file is part of the Zicsr extended RISC-V instruction
// set simulator (rv32csr_cpu).
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#ifndef _RV32CSR_CPU_HDR_H_
#define _RV32CSR_CPU_HDR_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdint>

#include "rv32i_cpu.h"

// -------------------------------------------------------------------------
// Zicsr extension constants
// -------------------------------------------------------------------------

class rv32csr_consts
{
public:

    static const uint32_t RV32CSR_PRIMARY_TBL_SYS_OFFSET               = 28;

    static const uint32_t RV32CSR_MXLEN32                              = 0x40000000;
                                                       
    static const uint32_t RV32CSR_EXT_A                                = 0x00000001;
    static const uint32_t RV32CSR_EXT_B                                = 0x00000002;
    static const uint32_t RV32CSR_EXT_C                                = 0x00000004;
    static const uint32_t RV32CSR_EXT_D                                = 0x00000008;
    static const uint32_t RV32CSR_EXT_E                                = 0x00000010;
    static const uint32_t RV32CSR_EXT_F                                = 0x00000020;
    static const uint32_t RV32CSR_EXT_G                                = 0x00000040;
    static const uint32_t RV32CSR_EXT_H                                = 0x00000080;
    static const uint32_t RV32CSR_EXT_I                                = 0x00000100;
    static const uint32_t RV32CSR_EXT_J                                = 0x00000200;
    static const uint32_t RV32CSR_EXT_K                                = 0x00000400;
    static const uint32_t RV32CSR_EXT_L                                = 0x00000800;
    static const uint32_t RV32CSR_EXT_M                                = 0x00001000;
    static const uint32_t RV32CSR_EXT_N                                = 0x00002000;
    static const uint32_t RV32CSR_EXT_O                                = 0x00004000;
    static const uint32_t RV32CSR_EXT_P                                = 0x00008000;
    static const uint32_t RV32CSR_EXT_Q                                = 0x00010000;
    static const uint32_t RV32CSR_EXT_R                                = 0x00020000;
    static const uint32_t RV32CSR_EXT_S                                = 0x00040000;
    static const uint32_t RV32CSR_EXT_T                                = 0x00080000;
    static const uint32_t RV32CSR_EXT_U                                = 0x00100000;
    static const uint32_t RV32CSR_EXT_V                                = 0x00200000;
    static const uint32_t RV32CSR_EXT_W                                = 0x00400000;
    static const uint32_t RV32CSR_EXT_X                                = 0x00800000;
    static const uint32_t RV32CSR_EXT_Y                                = 0x01000000;
    static const uint32_t RV32CSR_EXT_Z                                = 0x02000000;

// CSR address bit fields
    static const uint32_t RV32CSR_ADDR_PRIV_MASK                       = 0x300;
    static const uint32_t RV32CSR_USER_PRIV                            = 0x000;
    static const uint32_t RV32CSR_SUPERVISOR_PRIV                      = 0x100;
    static const uint32_t RV32CSR_HYPERVISOR_PRIV                      = 0x200;
    static const uint32_t RV32CSR_MACHINE_PRIV                         = 0x300;

// CSR register addresses

// Floating point CSR addresses
    static const uint32_t RV32CSR_ADDR_FFLAGS                          = 0x001;
    static const uint32_t RV32CSR_ADDR_FRM                             = 0x002;
    static const uint32_t RV32CSR_ADDR_FCSR                            = 0x003;

// Machine information
    static const uint32_t RV32CSR_ADDR_MVENDORID                       = 0xf11;
    static const uint32_t RV32CSR_ADDR_MARCHID                         = 0xf12;
    static const uint32_t RV32CSR_ADDR_MIMPID                          = 0xf13;
    static const uint32_t RV32CSR_ADDR_MHARTID                         = 0xf14;

// Machine Trap Setup
    static const uint32_t RV32CSR_ADDR_MSTATUS                         = 0x300;
    static const uint32_t RV32CSR_ADDR_MISA                            = 0x301;
    static const uint32_t RV32CSR_ADDR_MEDELEG                         = 0x302;
    static const uint32_t RV32CSR_ADDR_MIDELEG                         = 0x303;
    static const uint32_t RV32CSR_ADDR_MIE                             = 0x304;
    static const uint32_t RV32CSR_ADDR_MTVEC                           = 0x305;
    static const uint32_t RV32CSR_ADDR_MCOUNTEREN                      = 0x306;

// Machine Trap Handling
    static const uint32_t RV32CSR_ADDR_MSCRATCH                        = 0x340;
    static const uint32_t RV32CSR_ADDR_MEPC                            = 0x341;
    static const uint32_t RV32CSR_ADDR_MCAUSE                          = 0x342;
    static const uint32_t RV32CSR_ADDR_MTVAL                           = 0x343;
    static const uint32_t RV32CSR_ADDR_MIP                             = 0x344;

// Machine Memory protection
    static const uint32_t RV32CSR_ADDR_PMPCFG0                         = 0x3A0;
    static const uint32_t RV32CSR_ADDR_PMPCFG1                         = 0x3A1;
    static const uint32_t RV32CSR_ADDR_PMPCFG2                         = 0x3A2;
    static const uint32_t RV32CSR_ADDR_PMPCFG3                         = 0x3A3;
    static const uint32_t RV32CSR_ADDR_PMPADDR0                        = 0x3B0;
    static const uint32_t RV32CSR_ADDR_PMPADDR1                        = 0x3B1;
    static const uint32_t RV32CSR_ADDR_PMPADDR2                        = 0x3B2;
    static const uint32_t RV32CSR_ADDR_PMPADDR3                        = 0x3B3;
    static const uint32_t RV32CSR_ADDR_PMPADDR4                        = 0x3B4;
    static const uint32_t RV32CSR_ADDR_PMPADDR5                        = 0x3B5;
    static const uint32_t RV32CSR_ADDR_PMPADDR6                        = 0x3B6;
    static const uint32_t RV32CSR_ADDR_PMPADDR7                        = 0x3B7;
    static const uint32_t RV32CSR_ADDR_PMPADDR8                        = 0x3B8;
    static const uint32_t RV32CSR_ADDR_PMPADDR9                        = 0x3B9;
    static const uint32_t RV32CSR_ADDR_PMPADDR10                       = 0x3BA;
    static const uint32_t RV32CSR_ADDR_PMPADDR11                       = 0x3BB;
    static const uint32_t RV32CSR_ADDR_PMPADDR12                       = 0x3BC;
    static const uint32_t RV32CSR_ADDR_PMPADDR13                       = 0x3BD;
    static const uint32_t RV32CSR_ADDR_PMPADDR14                       = 0x3BE;
    static const uint32_t RV32CSR_ADDR_PMPADDR15                       = 0x3BF;

// Machine Counter/Timers
    static const uint32_t RV32CSR_ADDR_MCYCLE                          = 0xB00;
    static const uint32_t RV32CSR_ADDR_MINSTRET                        = 0xB02;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER3                    = 0xB03;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER4                    = 0xB04;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER5                    = 0xB05;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER6                    = 0xB06;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER7                    = 0xB07;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER8                    = 0xB08;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER9                    = 0xB09;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER10                   = 0xB0A;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER11                   = 0xB0B;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER12                   = 0xB0C;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER13                   = 0xB0D;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER14                   = 0xB0E;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER15                   = 0xB0F;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER16                   = 0xB10;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER17                   = 0xB11;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER18                   = 0xB12;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER19                   = 0xB13;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER20                   = 0xB14;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER21                   = 0xB15;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER22                   = 0xB16;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER23                   = 0xB17;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER24                   = 0xB18;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER25                   = 0xB19;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER26                   = 0xB1A;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER27                   = 0xB1B;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER28                   = 0xB1C;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER29                   = 0xB1D;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER30                   = 0xB1E;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER31                   = 0xB1F;
    static const uint32_t RV32CSR_ADDR_MCYCLEH                         = 0xB80;
    static const uint32_t RV32CSR_ADDR_MINSTRETH                       = 0xB82;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER3H                   = 0xB83;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER4H                   = 0xB84;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER5H                   = 0xB85;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER6H                   = 0xB86;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER7H                   = 0xB87;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER8H                   = 0xB88;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER9H                   = 0xB89;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER10H                  = 0xB8A;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER11H                  = 0xB8B;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER12H                  = 0xB8C;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER13H                  = 0xB8D;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER14H                  = 0xB8E;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER15H                  = 0xB8F;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER16H                  = 0xB90;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER17H                  = 0xB91;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER18H                  = 0xB92;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER19H                  = 0xB93;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER20H                  = 0xB94;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER21H                  = 0xB95;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER22H                  = 0xB96;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER23H                  = 0xB97;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER24H                  = 0xB98;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER25H                  = 0xB99;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER26H                  = 0xB9A;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER27H                  = 0xB9B;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER28H                  = 0xB9C;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER29H                  = 0xB9D;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER30H                  = 0xB9E;
    static const uint32_t RV32CSR_ADDR_MHPMCOUNTER31H                  = 0xB9F;

// Machine counter setup
    static const uint32_t RV32CSR_ADDR_MCOUNTINHIBIT                   = 0x320;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT3                      = 0x323;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT4                      = 0x324;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT5                      = 0x325;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT6                      = 0x326;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT7                      = 0x327;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT8                      = 0x328;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT9                      = 0x329;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT10                     = 0x32A;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT11                     = 0x32B;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT12                     = 0x32C;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT13                     = 0x32D;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT14                     = 0x32E;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT15                     = 0x32F;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT16                     = 0x330;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT17                     = 0x331;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT18                     = 0x332;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT19                     = 0x333;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT20                     = 0x334;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT21                     = 0x335;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT22                     = 0x336;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT23                     = 0x337;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT24                     = 0x338;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT25                     = 0x339;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT26                     = 0x33A;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT27                     = 0x33B;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT28                     = 0x33C;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT29                     = 0x33D;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT30                     = 0x33E;
    static const uint32_t RV32CSR_ADDR_MHPMEVENT31                     = 0x33F;

// Debug/Trace registers
    static const uint32_t RV32CSR_ADDR_TSELECT                         = 0x7A0;
    static const uint32_t RV32CSR_ADDR_TDATA1                          = 0x7A1;
    static const uint32_t RV32CSR_ADDR_TDATA2                          = 0x7A2;
    static const uint32_t RV32CSR_ADDR_TDATA3                          = 0x7A3;

    static const uint32_t RV32CSR_ADDR_DCSR                            = 0x7B0;
    static const uint32_t RV32CSR_ADDR_DPC                             = 0x7B1;
    static const uint32_t RV32CSR_ADDR_DSCRATCH0                       = 0x7B2;
    static const uint32_t RV32CSR_ADDR_DSCRATCH1                       = 0x7B3;

// CSR write masks (from perspective of CSR instructions)
    static const uint32_t RV32CSR_MISA_WR_MASK                         = 0x00000000; /* can't update in this implementation */
    static const uint32_t RV32CSR_MSTATUS_WR_MASK                      = 0x00000088;
    static const uint32_t RV32CSR_MIP_WR_MASK                          = 0x00000000;
    static const uint32_t RV32CSR_MIE_WR_MASK                          = 0x00000888;
    static const uint32_t RV32CSR_MTVEC_WR_MASK                        = 0xffffffff;
    static const uint32_t RV32CSR_MCYCLE_WR_MASK                       = 0xffffffff;
    static const uint32_t RV32CSR_MINSTRET_WR_MASK                     = 0xffffffff;
    static const uint32_t RV32CSR_MHPMCOUNTERX_WR_MASK                 = 0x00000000; /* Reg implemented, counter not. */
    static const uint32_t RV32CSR_MHPMEVENTX_WR_MASK                   = 0x00000000; /* Reg implemented, hardwired 0 */
    static const uint32_t RV32CSR_MCOUNTEREN_WR_MASK                   = 0x00000000;
    static const uint32_t RV32CSR_MCOUNTINHIBIT_WR_MASK                = 0x00000001;
    static const uint32_t RV32CSR_MSCRATCH_WR_MASK                     = 0xffffffff;
    static const uint32_t RV32CSR_MEPC_WR_MASK                         = 0xfffffffe;
    static const uint32_t RV32CSR_MCAUSE_WR_MASK                       = 0xffffffff;
    static const uint32_t RV32CSR_MTVAL_WR_MASK                        = 0xffffffff;
    static const uint32_t RV32CSR_FFLAGS_WR_MASK                       = 0x0000001f;
    static const uint32_t RV32CSR_FRM_WR_MASK                          = 0x00000007;
    static const uint32_t RV32CSR_FCSR_WR_MASK                         = 0x000000ff;

    static const uint32_t RV32CSR_MSTATUS_FS_MASK                      = 0x00006000;
    static const uint32_t RV32CSR_MSTATUS_FS_OFF                       = 0x00000000;
    static const uint32_t RV32CSR_MSTATUS_FS_INITIAL                   = 0x00002000;
    static const uint32_t RV32CSR_MSTATUS_FS_CLEAN                     = 0x00004000;
    static const uint32_t RV32CSR_MSTATUS_FS_DIRTY                     = 0x00006000;

// CSR memory protection registers are implemented but currently hardwired to 0
    static const uint32_t RV32CSR_PMPX_WR_MASK                         = 0x00000000;

// MIP bit masks
    static const uint32_t RV32CSR_MEIP_BITMASK                         = 0x800;
    static const uint32_t RV32CSR_MTIP_BITMASK                         = 0x080;
    static const uint32_t RV32CSR_MSIP_BITMASK                         = 0x008;

// MIE bit masks
    static const uint32_t RV32CSR_MEIE_BITMASK                         = 0x800;
    static const uint32_t RV32CSR_MTIE_BITMASK                         = 0x080;
    static const uint32_t RV32CSR_MSIE_BITMASK                         = 0x008;

// MSTATUS bit masks
    static const uint32_t RV32CSR_MIE_BITMASK                          = 0x00000008;
    static const uint32_t RV32CSR_MPIE_BITMASK                         = 0x00000080;
    static const uint32_t RV32CSR_MPP_BITMASK                          = 0x00001800;
    static const uint32_t RV32CSR_MPRV_BITMASK                         = 0x00010000;

    static const uint32_t RV32CSR_MTVEC_MODE_MASK                      = 0x00000003;
    static const uint32_t RV32CSR_MTVEC_MODE_DIRECT                    = 0x00000000;
    static const uint32_t RV32CSR_MTVEC_MODE_VECTORED                  = 0x00000001;

// Interrupt causes
    static const uint32_t RV32CSR_MCAUSE_INT_MASK                      = 0x80000000;
    static const uint32_t RV32CSR_INT_MSW_CAUSE                        = (0x00000003 | RV32CSR_MCAUSE_INT_MASK);
    static const uint32_t RV32CSR_INT_MTIM_CAUSE                       = (0x00000007 | RV32CSR_MCAUSE_INT_MASK);
    static const uint32_t RV32CSR_INT_MEXT_CAUSE                       = (0x0000000B | RV32CSR_MCAUSE_INT_MASK);
};

// -------------------------------------------------------------------------
// Macros
// -------------------------------------------------------------------------

// CSR operation decode on fmt fields
#define RV32CSR_OP_RW(_op)                             ((_op & 0x3) == 0x1)
#define RV32CSR_OP_RS(_op)                             ((_op & 0x3) == 0x2)
#define RV32CSR_OP_RC(_op)                             ((_op & 0x3) == 0x3)
#define RV32CSR_IMM(_op)                               (_op  & 0x4)

#endif