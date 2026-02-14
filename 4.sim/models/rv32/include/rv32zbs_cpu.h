// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 15th April 2025
//
// Contains the class definition for the rv32zbs_cpu derived class
//
// This file is part of the ZBS extended RISC-V instruction
// set simulator (rv32zbs_cpu).
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

#ifndef _RV32ZBS_CPU_H_
#define _RV32ZBS_CPU_H_

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu.h"
#include RV32ZBS_INCLUDE

class rv32zbs_cpu : public RV32_ZBS_INHERITANCE_CLASS
{
public:

    // ------------------------------------------------
    // Constructors/destructors
    // ------------------------------------------------

             LIBRISCV32_API      rv32zbs_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32zbs_cpu()   { };

protected:
    rv32i_decode_table_t  cxx_tbl        [RV32I_NUM_TERTIARY_OPCODES];
private:

    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    // Constant strings for instructions

    const char bclr_str   [DISASSEM_STR_SIZE] = "bclr     ";
    const char bclri_str  [DISASSEM_STR_SIZE] = "bclri    ";
    const char bext_str   [DISASSEM_STR_SIZE] = "bext     ";
    const char bexti_str  [DISASSEM_STR_SIZE] = "bexti    ";
    const char binv_str   [DISASSEM_STR_SIZE] = "binv     ";
    const char binvi_str  [DISASSEM_STR_SIZE] = "binvi    ";
    const char bset_str   [DISASSEM_STR_SIZE] = "bset     ";
    const char bseti_str  [DISASSEM_STR_SIZE] = "bseti    ";

    // ------------------------------------------------
    // Private methods
    // ------------------------------------------------

    // Instruction execution method prototypes

    void        bclr                       (const p_rv32i_decode_t d);
    void        bclri                      (const p_rv32i_decode_t d);
    void        bext                       (const p_rv32i_decode_t d);
    void        bexti                      (const p_rv32i_decode_t d);
    void        binv                       (const p_rv32i_decode_t d);
    void        binvi                      (const p_rv32i_decode_t d);
    void        bset                       (const p_rv32i_decode_t d);
    void        bseti                      (const p_rv32i_decode_t d);

};

#endif
