//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 26th July 2021
//
// Contains the instruction execution methods for the
// rv32a_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32a_cpu).
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

#include "rv32a_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32a_cpu::rv32a_cpu(FILE* dbgfp) : RV32_A_INHERITANCE_CLASS(dbgfp)
{
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA] |=  RV32CSR_EXT_A;

    // Initialise the AMOW tertiary table for reserved instruction method
    for (int i = 0; i < RV32I_NUM_TERTIARY_OPCODES; i++)
    {
        amow_tbl[i]               = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    }

    // Set the AMOW table for all four combinations of the funct7 ar and rl bits
    // to the same instruction method (will decode those bits locally)---[1] Sec 8
    for (int i = 0; i < 4; i++)
    {
        amow_tbl[(0x02 << 2) + i] = { false, lrw_str,     RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::lrw };      /*LR.W*/
        amow_tbl[(0x03 << 2) + i] = { false, scw_str,     RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::scw };      /*SC.W*/
        amow_tbl[(0x01 << 2) + i] = { false, amoswap_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amoswapw }; /*AMOSWAP.W*/
        amow_tbl[(0x00 << 2) + i] = { false, amoadd_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amoaddw };  /*AMOADD.W*/
        amow_tbl[(0x04 << 2) + i] = { false, amoxor_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amoxorw };  /*AMOXOR.W*/
        amow_tbl[(0x0c << 2) + i] = { false, amoand_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amoandw };  /*AMOAND.W*/
        amow_tbl[(0x08 << 2) + i] = { false, amoor_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amoorw };   /*AMOOR.W*/
        amow_tbl[(0x10 << 2) + i] = { false, amomin_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amominw };  /*AMOMIN.W*/
        amow_tbl[(0x14 << 2) + i] = { false, amomax_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amomaxw };  /*AMOMAX.W*/
        amow_tbl[(0x18 << 2) + i] = { false, amominu_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amominuw }; /*AMOMINU.W*/
        amow_tbl[(0x1c << 2) + i] = { false, amomaxu_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32a_cpu::amomaxuw }; /*AMOMAXU.W*/
    }

    // Initialise the AMO secondary table for reserved instruction method
    for (int i = 0; i < RV32I_NUM_SECONDARY_OPCODES; i++)
    {
        amo_tbl[i]                = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };        /*RSVD*/
    }

    // Funct3 is always 2 for all 32 bit RV32A instructions
    INIT_TBL_WITH_SUBTBL(amo_tbl[0x02],     amow_tbl);

    // Update primary table entry for AMO to point to amo_tbl
    INIT_TBL_WITH_SUBTBL(primary_tbl[0x0b], amo_tbl);
}

// -----------------------------------------------------------
// RV32A instruction methods
// -----------------------------------------------------------

void rv32a_cpu::lrw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;

            state.hart[curr_hart].x[d->rd] = rd_val;

            rsvd_mem.active     = true;
            rsvd_mem.start_addr = access_addr & ~(rsvd_mem_block_bytes - 1);
            rsvd_mem.end_addr   = rsvd_mem.start_addr + rsvd_mem_block_bytes - 1;
        }
    }

    if (!access_fault || disassemble)
    {
        increment_pc();
    }
}

void rv32a_cpu::scw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        if (rsvd_mem.active && access_addr >= rsvd_mem.start_addr && (access_addr + 3) <= rsvd_mem.end_addr)
        {
            write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2], MEM_WR_ACCESS_WORD, access_fault);

            if (!access_fault)
            {
                cycle_count += RV32I_STORE_EXTRA_CYCLES;
            }

            state.hart[curr_hart].x[d->rd] = 0;
        }
        else
        {
            state.hart[curr_hart].x[d->rd] = 1;
        }

        rsvd_mem.active                    = false;
    }

    if (!access_fault || disassemble)
    {
        increment_pc();
    }
}

void rv32a_cpu::amoswapw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_STORE_EXTRA_CYCLES;
            state.hart[curr_hart].x[d->rd] = rd_val;
            write_mem((uint32_t)access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2], MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        increment_pc();
    }
}

void rv32a_cpu::amoaddw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
            state.hart[curr_hart].x[d->rd] = rd_val;
            write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] + rd_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    }
}

void rv32a_cpu::amoxorw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
            state.hart[curr_hart].x[d->rd] = rd_val;
            write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] ^ rd_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    }
}

void rv32a_cpu::amoandw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
            state.hart[curr_hart].x[d->rd] = rd_val;
            write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] & rd_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    };
}

void rv32a_cpu::amoorw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_RA_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
            state.hart[curr_hart].x[d->rd] = rd_val;
            write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] | rd_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    }
}

void rv32a_cpu::amominw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;

            state.hart[curr_hart].x[d->rd] = rd_val;

            uint32_t wr_val = ((int32_t)rd_val < (int32_t)state.hart[curr_hart].x[d->rs2]) ? rd_val : (uint32_t)state.hart[curr_hart].x[d->rs2];

            write_mem(access_addr, wr_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    };
}

void rv32a_cpu::amomaxw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;

            state.hart[curr_hart].x[d->rd] = rd_val;

            uint32_t wr_val = ((int32_t)rd_val > (int32_t)state.hart[curr_hart].x[d->rs2]) ? rd_val : (uint32_t)state.hart[curr_hart].x[d->rs2];

            write_mem(access_addr, wr_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    };
}

void rv32a_cpu::amominuw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;

            state.hart[curr_hart].x[d->rd] = rd_val;

            uint32_t wr_val = (rd_val < (uint32_t)state.hart[curr_hart].x[d->rs2]) ? rd_val : (uint32_t)state.hart[curr_hart].x[d->rs2];

            write_mem(access_addr, wr_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    };
}

void rv32a_cpu::amomaxuw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1];

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;

            state.hart[curr_hart].x[d->rd] = rd_val;

            uint32_t wr_val = (rd_val > (uint32_t)state.hart[curr_hart].x[d->rs2]) ? rd_val : (uint32_t)state.hart[curr_hart].x[d->rs2];

            write_mem(access_addr, wr_val, MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault || disassemble)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    };
}