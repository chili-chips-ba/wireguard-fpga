//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 30th July 2021
//
// Contains the instruction execution methods for the
// rv32d_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32d_cpu).
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

#include "rv32d_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32d_cpu::rv32d_cpu(FILE* dbgfp) : RV32_D_INHERITANCE_CLASS(dbgfp)
{
    int idx;

    // Advertise 'F' extensions
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA]   |=  RV32CSR_EXT_D;

    // Initialise FS field to Initial
    state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] = (state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] & ~RV32CSR_MSTATUS_FS_MASK) | RV32CSR_MSTATUS_FS_INITIAL;

    curr_rnd_method = RV32I_RMM;
    fesetround(FE_TONEAREST);
    feclearexcept(FE_ALL_EXCEPT);

    // Quarternary tables for floating point, decoded in funct3.
    // For OP-FP instructions not using 'rm' field in funct3 place.

    // Initialise quarternary table to reserved instruction method
    for (int i = 0; i < RV32I_NUM_SECONDARY_OPCODES; i++)
    {
        fsgnjd_tbl[i]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fminmaxd_tbl[i] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fclassd_tbl[i]  = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fcmpd_tbl[i]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
    }

    // Setup quarternary tables (decoded on funct3 via decode_exception method)
    idx = 0;
    fsgnjd_tbl[idx++]   = { false, fsgnjd_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fsgnjd };
    fsgnjd_tbl[idx++]   = { false, fsgnjnd_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fsgnjnd };
    fsgnjd_tbl[idx++]   = { false, fsgnjxd_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fsgnjxd };

    idx = 0;
    fminmaxd_tbl[idx++] = { false, fmind_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fmind };
    fminmaxd_tbl[idx++] = { false, fmaxd_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fmaxd };

    fclassd_tbl[0x01]   = { false, fclassd_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fclassd };

    idx = 0;
    fcmpd_tbl[idx++]     = { false, fled_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fled };
    fcmpd_tbl[idx++]     = { false, fltd_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fltd };
    fcmpd_tbl[idx++]     = { false, feqd_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::feqd };

    // Tertiary table for OP-FP
    fs_tbl[0x01]        = { false, faddd_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::faddd };
    fs_tbl[0x05]        = { false, fsubd_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fsubd };
    fs_tbl[0x09]        = { false, fmuld_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fmuld };
    fs_tbl[0x0d]        = { false, fdivd_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fdivd };
    fs_tbl[0x2d]        = { false, fsqrtd_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fsqrtd };
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x11], fsgnjd_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x15], fminmaxd_tbl);
    fs_tbl[0x61]        = { false, fcvtwd_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fcvtwd };  // FCVT.W.D and FCVT.WU.D
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x71], fclassd_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x51], fcmpd_tbl);
    fs_tbl[0x69]        = { false, fcvtdw_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fcvtdw };  // FCVT.D.W and FCVT.D.WU

    fs_tbl[0x20]        = { false, fcvtsd_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fcvtsd };
    fs_tbl[0x21]        = { false, fcvtds_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32d_cpu::fcvtds };

    // Update the primary table for non OP-FP RV32D instructions, overriding
    // the entries set by rv32f_cpu class (if present). The D instructions
    // do final decode, and call single precision methods, if available (else reserved).
    primary_tbl[0x01]  = {false, fld_str,          RV32I_INSTR_FMT_I, (pFunc_t)&rv32d_cpu::fld};      //LOAD-FP
    primary_tbl[0x09]  = {false, fsd_str,          RV32I_INSTR_FMT_S, (pFunc_t)&rv32d_cpu::fsd};      //STORE-FP

    idx = 0x10;
    primary_tbl[idx++] = {false, fmaddd_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32d_cpu::fmaddd};  //MADD (both .S and .D)
    primary_tbl[idx++] = {false, fmsubd_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32d_cpu::fmsubd};  //MSUB (both .S and .D)
    primary_tbl[idx++] = {false, fnmsubd_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32d_cpu::fnmsubd}; //NMSUB (both .S and .D)
    primary_tbl[idx++] = {false, fnmaddd_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32d_cpu::fnmaddd}; //NMADD (both .S and .D)

    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], fsop_tbl); idx++;

}

// -----------------------------------------------------------
// Floating point CSR register access methods
// -----------------------------------------------------------

uint32_t rv32d_cpu::access_csr(const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t rs1_uimm)
{
    uint32_t error = 0;
    
    // Call parent class's access_csr function.
    if (!(error = RV32_F_INHERITANCE_CLASS::access_csr(funct3, addr, rd, rs1_uimm)))
    {
        // If no error, check if access was to floating point CSRs. Since FRM and FFLAGS are
        // copies of FCSR fields, if any are updated, the relevant other registers need
        // updating too. Note, FRM occupies bottom three bits, but FCSR copy starts from
        // bit 5.
        switch (addr)
        {
        case RV32CSR_ADDR_FFLAGS:
            state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   = (state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   & ~RV32CSR_FFLAGS_WR_MASK) |
                                                             (state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] & RV32CSR_FFLAGS_WR_MASK);
            break;
        case RV32CSR_ADDR_FRM:
            state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   = (state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR] & ~(RV32CSR_FRM_WR_MASK << 5)) | 
                                                             ((state.hart[curr_hart].csr[RV32CSR_ADDR_FRM] & RV32CSR_FRM_WR_MASK ) << 5);
            break;
        case RV32CSR_ADDR_FCSR:
            state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] =  state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR] & RV32CSR_FFLAGS_WR_MASK;
            state.hart[curr_hart].csr[RV32CSR_ADDR_FRM]    = (state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR] >> 5) & RV32CSR_FRM_WR_MASK;
            break;
        default:
            break;
        }
    }

    return error;
}

// -----------------------------------------------------------
// Overloaded CSR write mask method
// -----------------------------------------------------------

uint32_t rv32d_cpu::csr_wr_mask(const uint32_t addr, bool& unimp)
{
    // Offer the access to the ancestor classes first
    uint32_t mask =  RV32_F_INHERITANCE_CLASS::csr_wr_mask(addr, unimp);

    // If not implemented in the parent classes, decode here
    if (unimp)
    {
        unimp = false;

        switch (addr)
        {
        case RV32CSR_ADDR_FFLAGS:
            mask = RV32CSR_FFLAGS_WR_MASK;
            break;
        case RV32CSR_ADDR_FRM:
            mask = RV32CSR_FRM_WR_MASK;
            break;
        case RV32CSR_ADDR_FCSR:
            mask = RV32CSR_FCSR_WR_MASK;
            break;
        default:
            mask = 0;
            unimp = true;
            break;
        }
    }

    // The MSTATUS FS bits are made writable in this class to satisfy
    // test 13 of risv-tests/isa/rv32mi/csr.S which writes to these bits
    // to clear them, despite [2] Sec. 3.1.6.5 stating it's a read
    // only field. fsw stores are disabled when FS == 0 (off).
    if (addr == RV32CSR_ADDR_MSTATUS)
    {
        mask |= RV32CSR_MSTATUS_FS_MASK;
    }

    return mask;
}

// -----------------------------------------------------------
// RV32F floating point control and exception methods
// -----------------------------------------------------------

void rv32d_cpu::update_rm(int req_rnd_method)
{
    // If requested method is dynamic, get dynamic setting from FRM,
    // else use argument value.
    int rnd_method = (req_rnd_method == RV32I_DYN) ? (uint32_t)state.hart->csr[RV32CSR_ADDR_FRM] : 
                                                     req_rnd_method;

    // Only set if there's a change.
    if (curr_rnd_method != rnd_method)
    {
        switch (rnd_method)
        {
        // Only four methods are defined for rounding in fenv.h so,
        // for now, combine RMM and new method of RNE.
        case RV32I_RNE:
        case RV32I_RMM:
            fesetround(FE_TONEAREST);
            break;
        case RV32I_RTZ:
            fesetround(FE_TOWARDZERO);
            break;
        case RV32I_RDN:
            fesetround(FE_DOWNWARD);
            break;
        case RV32I_RUP:
            fesetround(FE_UPWARD);
            break;
        }

        // Update current rounding to that just set
        curr_rnd_method = rnd_method;
    }
}

void rv32d_cpu::handle_fexceptions()
{
    // Update the CSR status, mapping from underlying exception
    // values to the flags in FCSR and FFLAGS.

    if (fetestexcept(FE_INVALID))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }

    if (fetestexcept(FE_OVERFLOW))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_OF;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_OF;
    }

    if (fetestexcept(FE_DIVBYZERO))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_DZ;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_DZ;
    }

    if (fetestexcept(FE_UNDERFLOW))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_UF;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_UF;
    }

    if (fetestexcept(FE_INEXACT))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NX;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NX;
    }

    feclearexcept(FE_ALL_EXCEPT);
}

// -----------------------------------------------------------
// RV32F instruction methods
// -----------------------------------------------------------

void rv32d_cpu::fld(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    if (d->funct3 != 0x3)
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = flw_str;
        RV32_D_INHERITANCE_CLASS::flw(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_IFS_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

        if (!disassemble)
        {
            access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

            uint64_t rd_val = (uint64_t)read_mem(access_addr+4, MEM_RD_ACCESS_WORD, access_fault);
                     rd_val = (rd_val << 32) | (uint64_t)read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

            if (!access_fault)
            {
                cycle_count += RV32I_LOAD_EXTRA_CYCLES * 2 + 1;
                state.hart[curr_hart].f[d->rd] = rd_val;
            }
        }

        if (!access_fault)
        {
            increment_pc();
        }
    }
}

void rv32d_cpu::fsd(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    if (d->funct3 != 0x3)
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = fsw_str;
        RV32_D_INHERITANCE_CLASS::fsw(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_SFS_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_s);

        if (!disassemble)
        {
            // Enabling stores only when MSTATUS FS bits != 0 (off)
            if (state.hart->csr[RV32CSR_ADDR_MSTATUS] & RV32CSR_MSTATUS_FS_MASK)
            {
                access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_s;

                write_mem(access_addr,   (uint32_t)state.hart[curr_hart].f[d->rs2], MEM_WR_ACCESS_WORD, access_fault);
                write_mem(access_addr+4, (uint32_t)(state.hart[curr_hart].f[d->rs2] >> 32), MEM_WR_ACCESS_WORD, access_fault);
            }
        }

        if (!access_fault)
        {
            cycle_count += RV32I_STORE_EXTRA_CYCLES * 2 + 1;
            increment_pc();
        }
    }
}

void rv32d_cpu::fmaddd(const p_rv32i_decode_t d)
{
    if (!(d->funct7 & BIT2_MASK))
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = fmadds_str;
        RV32_D_INHERITANCE_CLASS::fmadds(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));

        double rd_val;

        // Map register values stored in uint32_t types to floats
        double rs1_val = map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val = map_uint_to_double(state.hart[curr_hart].f[d->rs2]);
        double rs3_val = map_uint_to_double(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = (rs1_val * rs2_val) + rs3_val;
        }
        catch (...)
        {
            /* do nothing */
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;

        increment_pc();
    }
}

void rv32d_cpu::fmsubd (const p_rv32i_decode_t d)
{
    if (!(d->funct7 & BIT2_MASK))
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = fmsubs_str;
        RV32_D_INHERITANCE_CLASS::fmsubs(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));

        update_rm(d->funct3);

        double rd_val;
        double rs1_val = map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val = map_uint_to_double(state.hart[curr_hart].f[d->rs2]);
        double rs3_val = map_uint_to_double(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = (rs1_val * rs2_val) - rs3_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;

        increment_pc();
    }
}

void rv32d_cpu::fnmsubd(const p_rv32i_decode_t d)
{
    if (!(d->funct7 & BIT2_MASK))
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = fnmsubs_str;
        RV32_D_INHERITANCE_CLASS::fnmsubs(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));

        double rd_val;
        double rs1_val = map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val = map_uint_to_double(state.hart[curr_hart].f[d->rs2]);
        double rs3_val = map_uint_to_double(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = -1.0F * (rs1_val * rs2_val) + rs3_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;

        increment_pc();
    }
}

void rv32d_cpu::fnmaddd(const p_rv32i_decode_t d)
{
    if (!(d->funct7 & BIT2_MASK))
    {
#if RV32_D_INHERITANCE_CLASS == rv32f_cpu
        rv32i_decode_t d_f = *d;
        d_f.entry.instr_name = fnmadds_str;
        RV32_D_INHERITANCE_CLASS::fnmadds(&d_f);
#else
        reserved(d);
#endif
    }
    else
    {
        RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));

        double rd_val;
        double rs1_val = map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val = map_uint_to_double(state.hart[curr_hart].f[d->rs2]);
        double rs3_val = map_uint_to_double(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = -1.0F * (rs1_val * rs2_val) - rs3_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;

        increment_pc();
    }
}

void rv32d_cpu::faddd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a double precision instruction
    if ((d->funct7 & BIT2_MASK) != 0x01)
    {
        reserved(d);
    }
    else
    {
        double rd_val;
        double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val + rs2_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32d_cpu::fsubd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a double precision instruction
    if ((d->funct7 & BIT2_MASK) != 0x01)
    {
        reserved(d);
    }
    else
    {
        double rd_val;
        double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val - rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions(); 

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32d_cpu::fmuld(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a double precision instruction
    if ((d->funct7 & BIT2_MASK) != 0x01)
    {
        reserved(d);
    }
    else
    {
        double rd_val;
        double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val * rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32d_cpu::fdivd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);
    
    // Make sure this is a double precision instruction
    if ((d->funct7 & BIT2_MASK) != 0x01)
    {
        reserved(d);
    }
    else
    {
        double rd_val;
        double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
        double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val / rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32d_cpu::fsqrtd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a double precision instruction
    if ((d->funct7 & BIT2_MASK) != 0x01)
    {
        reserved(d);
    }
    else
    {
        double rd_val;
        double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);

        update_rm(d->funct3);

        try
        {
            rd_val = sqrt(rs1_val);
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] =  map_double_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32d_cpu::fsgnjd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     (state.hart[curr_hart].f[d->rs2] & SIGN32_BIT);

    increment_pc();
}

void rv32d_cpu::fsgnjnd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     (~state.hart[curr_hart].f[d->rs2] & SIGN32_BIT);

    increment_pc();
}

void rv32d_cpu::fsgnjxd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);
    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     ((state.hart[curr_hart].f[d->rs1] ^ state.hart[curr_hart].f[d->rs2]) & SIGN32_BIT);

    increment_pc();
}

void rv32d_cpu::fmind(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rd_val;
    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) && std::isnan(rs2_val))
    {
        rd_val = nan("");
    }
    else if (state.hart[curr_hart].f[d->rs1] == RV32I_SNAND && !std::isnan(rs2_val))
    {
        rd_val = rs1_val;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else if (rs1_val == -0.0 || rs2_val == -0.0)
    {
        rd_val = -0.0;
    }
    else
    {
        rd_val = (rs1_val < rs2_val) ? rs1_val : rs2_val;
    }

    state.hart[curr_hart].f[d->rd] =  map_double_to_uint(rd_val);

    increment_pc();
}

void rv32d_cpu::fmaxd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rd_val;
    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) && std::isnan(rs2_val))
    {
        rd_val = nan("");
    }
    else if (state.hart[curr_hart].f[d->rs1] == RV32I_SNAND && !std::isnan(rs2_val))
    {
        rd_val = rs2_val;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else if (state.hart[curr_hart].f[d->rs2] == RV32I_SNAND && !std::isnan(rs1_val))
    {
        rd_val = rs1_val;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else if (rs1_val == -0.0 || rs2_val == -0.0)
    {
        rd_val = 0.0;
    }
    else
    {
        rd_val = (rs1_val > rs2_val) ? rs1_val : rs2_val;
    }

    state.hart[curr_hart].f[d->rd] =  map_double_to_uint(rd_val);

    increment_pc();
}

void rv32d_cpu::feqd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) || std::isnan(rs2_val))
    {
        state.hart[curr_hart].x[d->rd] = 0;

        if (state.hart[curr_hart].f[d->rs1] == RV32I_SNAND)
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
            state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
        }
    }
    else
    {
        state.hart[curr_hart].x[d->rd] = (rs1_val == rs2_val) ? 1 : 0;
    }

    increment_pc();
}

void rv32d_cpu::fltd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) || std::isnan(rs2_val))
    {
        state.hart[curr_hart].x[d->rd] = 0;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else
    {
        state.hart[curr_hart].x[d->rd] = (rs1_val < rs2_val) ? 1 : 0;
    }

    increment_pc();
}

void rv32d_cpu::fled(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    double rs2_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) || std::isnan(rs2_val))
    {
        state.hart[curr_hart].x[d->rd] = 0;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else
    {
        state.hart[curr_hart].x[d->rd] = (rs1_val <= rs2_val) ? 1 : 0;
    }

    increment_pc();
}

void rv32d_cpu::fclassd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT1_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double      rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);
    uint64_t* p_rs1_uint = (uint64_t*)&rs1_val;

    switch (std::fpclassify(rs1_val))
    {
    case FP_INFINITE:
        state.hart[curr_hart].x[d->rd] = (rs1_val == INFINITY) ? (1 << 7) : (1 << 0);
        break;
    case FP_NAN:
        state.hart[curr_hart].x[d->rd] = (*p_rs1_uint == RV32I_QNAND) ? (1 << 9) : (1 << 8);
        break;
    case FP_ZERO: 
        state.hart[curr_hart].x[d->rd] = (*p_rs1_uint & SIGN64_BIT) ? (1 << 3) : (1 << 4);
        break;
    case FP_SUBNORMAL:
        state.hart[curr_hart].x[d->rd] = (rs1_val < 0.0) ? (1 << 2) : (1 << 5);
        break;
    case FP_NORMAL:
        state.hart[curr_hart].x[d->rd] = (rs1_val < 0.0) ? (1 << 1) : (1 << 6);
        break;
    }

    increment_pc();
}

void rv32d_cpu::fcvtdw(const p_rv32i_decode_t d)
{
    if (d->rs2)
    {
        d->entry.instr_name = fcvtdwu_str;
    }
    RV32I_DISASSEM_RFCVT2_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    update_rm(d->funct3);

    double rd_val = d->rs2 ? (double)state.hart[curr_hart].x[d->rs1] : (double((int32_t)state.hart[curr_hart].x[d->rs1]));

    state.hart[curr_hart].f[d->rd] = map_double_to_uint(rd_val);

    increment_pc();
}

void rv32d_cpu::fcvtwd(const p_rv32i_decode_t d)
{
    if (d->rs2)
    {
        d->entry.instr_name = fcvtwud_str;
    }
    RV32I_DISASSEM_RFCVT1_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    double rs1_val =  map_uint_to_double(state.hart[curr_hart].f[d->rs1]);

    update_rm(d->funct3);

    state.hart[curr_hart].x[d->rd] = (d->rs2 ? ((uint32_t)rs1_val) : ((int32_t)rs1_val));

    double cmp = nearbyint(rs1_val);

    if (d->rs2 && (cmp < 0 || cmp > (powf(2.0, 32.0) - 1.0) || std::isnan(rs1_val) || rs1_val == INFINITY || rs1_val == -INFINITY))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;

        state.hart[curr_hart].x[d->rd] = (cmp < 0.0 || rs1_val == -INFINITY) ? 0 : UINT_MAX;
    }
    else if (!d->rs2 && (cmp < powf(-2.0, 31.0) || cmp >(powf(2.0, 31.0) - 1.0) || std::isnan(rs1_val) || rs1_val == INFINITY  || rs1_val == -INFINITY))
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;

        state.hart[curr_hart].x[d->rd] = (cmp < powf(-2.0, 31.0) || rs1_val == -INFINITY) ? INT_MIN : INT_MAX;

    }
    else if (cmp != rs1_val)
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NX;
    }

    increment_pc();
}

void rv32d_cpu::fcvtsd(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT3_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2); 

    update_rm(d->funct3);

    // Point to rs1 as a double
    double* prs1_d = (double*)&state.hart[curr_hart].f[d->rs1];

    // Convert rs1 to single precision
    float   rd_f  = (float)*prs1_d;

    // Point to result as a 32 bit integer
    uint32_t* prd_uint = (uint32_t*)&rd_f;

    // Save in rd register
    state.hart[curr_hart].f[d->rd] = (uint64_t)*prd_uint | 0xffffffff00000000UL;

    increment_pc();
}

void rv32d_cpu::fcvtds(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT3_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    uint32_t rs1 = (uint32_t)(state.hart[curr_hart].f[d->rs1] & 0xffffffffUL);

    // Point to rs1 as a float
    float* prs1_d = (float*)&rs1;

    // Convert rs1 to double precision
    double   rd_d  = (double)*prs1_d;

    // Point to result as a 64 bit integer
    uint64_t* prd_uint = (uint64_t*)&rd_d;

    // [1] Sec 12.2
    if (std::isnan(rd_d))
    {
        *prd_uint = RV32I_QNAND;
    }

    // Save in rd register
    state.hart[curr_hart].f[d->rd] = *prd_uint;

    increment_pc();
}
