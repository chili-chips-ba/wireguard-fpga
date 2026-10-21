//=============================================================
// 
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 15th April 2025
//
// Contains the instruction execution methods for the
// rv32zbs_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32zbs_cpu).
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

#include "rv32zbs_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32zbs_cpu::rv32zbs_cpu(FILE* dbgfp) : RV32_ZBS_INHERITANCE_CLASS(dbgfp)
{
    // Flag if *all* B extensions present (defined in auto-generated rv32_extensions.h)
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA]   |=  RV32CSR_EXT_B_CONFIG;

    sll_tbl[0x14]  = {false, bset_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbs_cpu::bset };     /*BSET*/
    sll_tbl[0x24]  = {false, bclr_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbs_cpu::bclr };     /*BCLR*/
    sll_tbl[0x34]  = {false, binv_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbs_cpu::binv };     /*BINV*/
    srr_tbl[0x24]  = {false, bext_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbs_cpu::bext };     /*BEXT*/
 
    slli_tbl[0x14] = {false, bseti_str,     RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbs_cpu::bseti};     /*BSETI*/
    slli_tbl[0x24] = {false, bclri_str,     RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbs_cpu::bclri};     /*BCLRI*/
    slli_tbl[0x34] = {false, binvi_str,     RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbs_cpu::binvi};     /*BINVI*/
    sri_tbl[0x24]  = {false, bexti_str,     RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbs_cpu::bexti};     /*BEXTI*/
}

// -----------------------------------------------------------
// RV32ZBS instruction methods
// -----------------------------------------------------------

void rv32zbs_cpu::bclr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] & ~(1ULL << (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}

void rv32zbs_cpu::bclri(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] & ~(1ULL << (d->rs2 & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}

void rv32zbs_cpu::bext(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)((state.hart[curr_hart].x[d->rs1] >> (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT)) & 1ULL);
    }

    increment_pc();
}

void rv32zbs_cpu::bexti(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)((state.hart[curr_hart].x[d->rs1] >> (d->rs2 & RV32I_MASK_IMM_I_SHAMT)) & 1ULL);
    }

    increment_pc();
}

void rv32zbs_cpu::binv(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] ^ (1ULL << (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}

void rv32zbs_cpu::binvi(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] ^ (1ULL << (d->rs2 & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}

void rv32zbs_cpu::bset(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] | (1ULL << (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}

void rv32zbs_cpu::bseti(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)(state.hart[curr_hart].x[d->rs1] | (1ULL << (d->rs2 & RV32I_MASK_IMM_I_SHAMT)));
    }

    increment_pc();
}
