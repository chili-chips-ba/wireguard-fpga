//=============================================================
//
// Copyright (c) 2025 Simon Southwell. All rights reserved.
//
// Date: 16th April 2025
//
// Contains the instruction execution methods for the
// rv32zbb_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32zbb_cpu).
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

#include "rv32zbb_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32zbb_cpu::rv32zbb_cpu(FILE* dbgfp) : RV32_ZBB_INHERITANCE_CLASS(dbgfp)
{
    // Tertiary table
    and_tbl[0x20]  = {false, andn_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::andn };     /*ANDN*/
    or_tbl[0x20]   = {false, orn_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::orn };      /*ORN*/
    xor_tbl[0x20]  = {false, xnor_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::xnor };     /*XNOR*/

    or_tbl[0x05]   = {false, max_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::maxs };     /*MAX*/
    and_tbl[0x05]  = {false, maxu_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::maxu };     /*MAXU*/
    xor_tbl[0x05]  = {false, min_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::mins };     /*MIN*/
    srr_tbl[0x05]  = {false, minu_str,      RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::minu };     /*MINU*/

    xor_tbl[0x04]  = {false, zexth_str,     RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::zexth };    /*ZEXT.H*/

    sll_tbl[0x30]  = {false, rol_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::rol};      /*ROL*/
    srr_tbl[0x30]  = {false, ror_str,       RV32I_INSTR_FMT_R,   (pFunc_t)&rv32zbb_cpu::ror};      /*ROR*/

    sri_tbl[0x30]  = {false, rori_str,      RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbb_cpu::rori};     /*ROI*/
    sri_tbl[0x14]  = {false, orcb_str,      RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbb_cpu::orcb};     /*ORC.B*/
    sri_tbl[0x34]  = {false, rev8_str,      RV32I_INSTR_FMT_I,   (pFunc_t)&rv32zbb_cpu::rev8};     /*REV8*/

    INIT_TBL_WITH_SUBTBL(slli_tbl[0x30], cxx_tbl);
    INIT_TBL_WITH_SUBTBL(slli_tbl[0x30], cxx_tbl);

    for (int idx = 0; idx < RV32I_NUM_QUARTERNARY_OPCODES; idx++)
    {
        cxx_tbl[idx]  = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
    }

    cxx_tbl[0x0]     = {false, clz_str,      RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::clz };
    cxx_tbl[0x1]     = {false, ctz_str,      RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::ctz };
    cxx_tbl[0x2]     = {false, cpop_str,     RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::cpop };
    cxx_tbl[0x4]     = {false, setxb_str,    RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::sextb };
    cxx_tbl[0x5]     = {false, setxh_str,    RV32I_INSTR_FMT_ZBB, (pFunc_t)&rv32zbb_cpu::sexth };
}

// -----------------------------------------------------------
// RV32ZBB instruction methods
// -----------------------------------------------------------

// Instruction execution method prototypes
void rv32zbb_cpu::andn (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] & (uint32_t)(~state.hart[curr_hart].x[d->rs2]);
    }

    increment_pc();
}

void rv32zbb_cpu::orn (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] | (uint32_t)(~state.hart[curr_hart].x[d->rs2]);
    }

    increment_pc();
}

void rv32zbb_cpu::xnor (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] ^ (uint32_t)(~state.hart[curr_hart].x[d->rs2]);
    }

    increment_pc();
}

void rv32zbb_cpu::clz (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        int bidx;

        for (bidx = 31; bidx >= 0; bidx--)
        {
            if ((state.hart[curr_hart].x[d->rs1] >> bidx) & 1)
            {
                break;
            }
        }

        state.hart[curr_hart].x[d->rd] = (uint64_t)(31-(int64_t)bidx);
    }

    increment_pc();
}

void rv32zbb_cpu::ctz (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        int bidx;

        for (bidx = 0; bidx < 32; bidx++)
        {
            if ((state.hart[curr_hart].x[d->rs1] >> bidx) & 1)
            {
                break;
            }
        }

        state.hart[curr_hart].x[d->rd] = (uint64_t)bidx;
    }

    increment_pc();
}

void rv32zbb_cpu::cpop (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        int bidx;
        int ones_count = 0;

        for (bidx = 0; bidx < 32; bidx++)
        {
            if ((state.hart[curr_hart].x[d->rs1] >> bidx) & 1)
            {
                ones_count++;
            }
        }

        state.hart[curr_hart].x[d->rd] = ones_count;
    }

    increment_pc();
}

void rv32zbb_cpu::maxs (const p_rv32i_decode_t d)
{

    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (int32_t)state.hart[curr_hart].x[d->rs1] > (int32_t)state.hart[curr_hart].x[d->rs2] ? 
                                                     (uint32_t)state.hart[curr_hart].x[d->rs1] :
                                                     (uint32_t)state.hart[curr_hart].x[d->rs2] ;
    }

    increment_pc();
}

void rv32zbb_cpu::maxu (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] > (uint32_t)state.hart[curr_hart].x[d->rs2] ? 
            (uint32_t)state.hart[curr_hart].x[d->rs1] :
            (uint32_t)state.hart[curr_hart].x[d->rs2] ;
    }

    increment_pc();
}

void rv32zbb_cpu::mins (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (int32_t)state.hart[curr_hart].x[d->rs1] < (int32_t)state.hart[curr_hart].x[d->rs2] ? 
            (uint32_t)state.hart[curr_hart].x[d->rs1] :
            (uint32_t)state.hart[curr_hart].x[d->rs2] ;
    }

    increment_pc();
}

void rv32zbb_cpu::minu (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] < (uint32_t)state.hart[curr_hart].x[d->rs2] ? 
            (uint32_t)state.hart[curr_hart].x[d->rs1] :
            (uint32_t)state.hart[curr_hart].x[d->rs2] ;
    }

    increment_pc();
}

void rv32zbb_cpu::sextb (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] & 0xffULL) | ((state.hart[curr_hart].x[d->rs1] & 0x80) ? ~0xffULL : 0);
    }

    increment_pc();
}

void rv32zbb_cpu::sexth (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] & 0xffffULL) | ((state.hart[curr_hart].x[d->rs1] & 0x8000) ? ~0xffffULL : 0);
    }

    increment_pc();
}

void rv32zbb_cpu::zexth (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] & 0xffffULL);
    }

    increment_pc();
}

void rv32zbb_cpu::rol (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        int shamnt = state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT;

        uint64_t top_bits = state.hart[curr_hart].x[d->rs1] >> (32 - shamnt);
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] << shamnt) | top_bits;
    }

    increment_pc();
}

void rv32zbb_cpu::ror (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        int shamnt = state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT;

        uint64_t bottom_bits = state.hart[curr_hart].x[d->rs1] << (32 - shamnt);
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] >> shamnt) | bottom_bits;
    }

    increment_pc();
}

void rv32zbb_cpu::rori (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        int shamnt = d->rs2 & RV32I_MASK_IMM_I_SHAMT;

        uint64_t bottom_bits = state.hart[curr_hart].x[d->rs1] << (32 - shamnt);
        state.hart[curr_hart].x[d->rd] = (state.hart[curr_hart].x[d->rs1] >> shamnt) | bottom_bits;

    }

    increment_pc();
}

void rv32zbb_cpu::orcb (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((state.hart[curr_hart].x[d->rs1] & 0x000000ff) ? 0x000000ff : 0) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0x0000ff00) ? 0x0000ff00 : 0) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0x00ff0000) ? 0x00ff0000 : 0) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0xff000000) ? 0xff000000 : 0);
    }

    increment_pc();
}

void rv32zbb_cpu::rev8 (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ZBB_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((state.hart[curr_hart].x[d->rs1] & 0x000000ff) << 24) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0x0000ff00) <<  8) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0x00ff0000) >>  8) |
                                         ((state.hart[curr_hart].x[d->rs1] & 0xff000000) >> 24);
    }

    increment_pc();
}

