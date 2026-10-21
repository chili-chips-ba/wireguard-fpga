//=============================================================
// 
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 23rd April 2025
//
// Contains the instruction execution methods for the
// rv32zbc_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32zbc_cpu).
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

#include "rv32zbc_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32zbc_cpu::rv32zbc_cpu(FILE* dbgfp) : RV32_ZBC_INHERITANCE_CLASS(dbgfp)
{

    sll_tbl[0x05]   = {false, clmul_str,        RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbc_cpu::clmul  };     /*CMUL*/
    sltu_tbl[0x05]  = {false, clmulh_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbc_cpu::clmulh };     /*CMULH*/
    slt_tbl[0x05]   = {false, clmulr_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbc_cpu::clmulr };     /*CMULR*/

}

// -----------------------------------------------------------
// RV32ZBC instruction methods
// -----------------------------------------------------------

void rv32zbc_cpu::clmul(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        uint64_t product = 0;

        for (int bidx = 0; bidx < 32; bidx++)
        {
             product ^= ((state.hart[curr_hart].x[d->rs2] >> bidx) & 1) ? (state.hart[curr_hart].x[d->rs1] << bidx) : 0;
        }

        state.hart[curr_hart].x[d->rd] = product;
    }

    increment_pc();
}

void rv32zbc_cpu::clmulh(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        uint64_t product = 0;

        for (int bidx = 1; bidx < 32; bidx++)
        {
            product ^= ((state.hart[curr_hart].x[d->rs2] >> bidx) & 1) ? (state.hart[curr_hart].x[d->rs1] >> (32 - bidx)) : 0;
        }

        state.hart[curr_hart].x[d->rd] = product;
    }

    increment_pc();
}

void rv32zbc_cpu::clmulr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        uint64_t product = 0;

        for (int bidx = 0; bidx < 32; bidx++)
        {
            product ^= ((state.hart[curr_hart].x[d->rs2] >> bidx) & 1) ? (state.hart[curr_hart].x[d->rs1] >> (32 - 1 - bidx)) : 0;
        }

        state.hart[curr_hart].x[d->rd] = product;
    }

    increment_pc();
}


