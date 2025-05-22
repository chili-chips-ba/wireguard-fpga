//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 14th April 2025
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

#ifndef _RV32ZBA_CPU_H_
#define _RV32ZBA_CPU_H_

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu.h"
#include RV32ZBA_INCLUDE

class rv32zba_cpu : public RV32_ZBA_INHERITANCE_CLASS
{
public:

    // ------------------------------------------------
    // Constructors/destructors
    // ------------------------------------------------

             LIBRISCV32_API      rv32zba_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32zba_cpu()   { };


private:

    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    // Constant strings for instructions

    const char sh1add_str   [DISASSEM_STR_SIZE] = "sh1add   ";
    const char sh2add_str   [DISASSEM_STR_SIZE] = "sh2add   ";
    const char sh3add_str   [DISASSEM_STR_SIZE] = "sh3add   ";

    // ------------------------------------------------
    // Private methods
    // ------------------------------------------------

    // Instruction execution method prototypes

    void        shxadd                     (const p_rv32i_decode_t d, const uint32_t shamt);
    inline void sh1add                     (const p_rv32i_decode_t d) {shxadd(d, 1);};
    inline void sh2add                     (const p_rv32i_decode_t d) {shxadd(d, 2);};
    inline void sh3add                     (const p_rv32i_decode_t d) {shxadd(d, 3);};

};

#endif
