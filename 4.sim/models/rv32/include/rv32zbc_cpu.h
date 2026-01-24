// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 23rd April 2025
//
// Contains the class definition for the rv32zba_cpu derived class
//
// This file is part of the ZBA extended RISC-V instruction
// set simulator (rv32zba_cpu).
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

#ifndef _RV32ZBC_CPU_H_
#define _RV32ZBC_CPU_H_

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu.h"
#include RV32ZBC_INCLUDE

class rv32zbc_cpu : public RV32_ZBC_INHERITANCE_CLASS
{
public:

    // ------------------------------------------------
    // Constructors/destructors
    // ------------------------------------------------

             LIBRISCV32_API      rv32zbc_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32zbc_cpu()   { };


private:

    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    // Constant strings for instructions

    const char clmul_str   [DISASSEM_STR_SIZE] = "clmul    ";
    const char clmulh_str  [DISASSEM_STR_SIZE] = "clmulh   ";
    const char clmulr_str  [DISASSEM_STR_SIZE] = "clmulr   ";

    // ------------------------------------------------
    // Private methods
    // ------------------------------------------------

    // Instruction execution method prototypes

    void clmul                      (const p_rv32i_decode_t d);
    void clmulh                     (const p_rv32i_decode_t d);
    void clmulr                     (const p_rv32i_decode_t d);

};

#endif
