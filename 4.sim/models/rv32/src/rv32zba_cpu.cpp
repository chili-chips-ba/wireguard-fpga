//=============================================================
// 
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 14th April 2025
//
// Contains the instruction execution methods for the
// rv32zba_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32zba_cpu).
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

#include "rv32zba_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32zba_cpu::rv32zba_cpu(FILE* dbgfp) : RV32_ZBA_INHERITANCE_CLASS(dbgfp)
{

    slt_tbl[0x10] = {false, sh1add_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zba_cpu::sh1add };     /*SH1ADD*/
    xor_tbl[0x10] = {false, sh2add_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zba_cpu::sh2add };     /*SH2ADD*/
    or_tbl[0x10]  = {false, sh3add_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zba_cpu::sh3add };     /*SH3ADD*/

}

// -----------------------------------------------------------
// RV32ZBA instruction methods
// -----------------------------------------------------------

// Common Zba shift address instruction execution method
void rv32zba_cpu::shxadd(const p_rv32i_decode_t d, const uint32_t shamt)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs2] + (state.hart[curr_hart].x[d->rs1] << shamt));
    }

    increment_pc();
}


