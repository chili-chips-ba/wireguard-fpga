//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 26th July 2021
//
// Contains the instruction execution methods for the
// rv32f_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32f_cpu).
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

#include "rv32f_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32f_cpu::rv32f_cpu(FILE* dbgfp) : RV32_F_INHERITANCE_CLASS(dbgfp)
{
    int idx;

    // Advertise 'F' extensions
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA]   |=  RV32CSR_EXT_F;

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
        fsgnjs_tbl[i]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fminmaxs_tbl[i] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fmv_tbl[i]      = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fcmp_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
    }

    // Setup quarternary tables (decoded on funct3 via decode_exception method)
    idx = 0;
    fsgnjs_tbl[idx++]   = { false, fsgnjs_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjs };
    fsgnjs_tbl[idx++]   = { false, fsgnjns_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjns };
    fsgnjs_tbl[idx++]   = { false, fsgnjxs_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjxs };

    idx = 0;
    fminmaxs_tbl[idx++] = { false, fmins_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmins };
    fminmaxs_tbl[idx++] = { false, fmaxs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmaxs };

    idx = 0;
    fmv_tbl[idx++]      = { false, fmvxw_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmvxw };
    fmv_tbl[idx++]      = { false, fclasss_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fclasss };

    idx = 0;
    fcmp_tbl[idx++]     = { false, fles_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fles };
    fcmp_tbl[idx++]     = { false, flts_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::flts };
    fcmp_tbl[idx++]     = { false, feqs_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::feqs };

    // Tertiary table for OP-FP
    fs_tbl[0x00]        = { false, fadds_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fadds };
    fs_tbl[0x04]        = { false, fsubs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsubs };
    fs_tbl[0x08]        = { false, fmuls_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmuls };
    fs_tbl[0x0c]        = { false, fdivs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fdivs };
    fs_tbl[0x2c]        = { false, fsqrts_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsqrts };
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x10], fsgnjs_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x14], fminmaxs_tbl);
    fs_tbl[0x60]        = { false, fcvtws_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fcvtws };  // FCVT.W.S and FCVT.WU.S
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x70], fmv_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x50], fcmp_tbl);
    fs_tbl[0x68]        = { false, fcvtsw_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fcvtsw };  // FCVT.S.W and FCVT.S.WU
    fs_tbl[0x78]        = { false, fmvwx_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmvwx };

    // For all combinations of funct3, point to the tertiary fsop_tbl. 
    // Will decode funct3 in quarternary tables. Avoids large
    // and complex table initialisation on all combinations of rm.
    // This effectively pushes funct3 decode to a quarternary decode
    // from secondary.
    for (int i = 0; i < RV32I_NUM_SECONDARY_OPCODES; i++)
    {
        INIT_TBL_WITH_SUBTBL(fsop_tbl[i], fs_tbl);
    }

    primary_tbl[0x01]  = {false, flw_str,          RV32I_INSTR_FMT_I, (pFunc_t)&rv32f_cpu::flw};      /*LOAD-FP*/
    primary_tbl[0x09]  = {false, fsw_str,          RV32I_INSTR_FMT_S, (pFunc_t)&rv32f_cpu::fsw};      /*STORE-FP*/

    idx = 0x10;
    primary_tbl[idx++] = {false, fmadds_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fmadds};  /*MADD*/
    primary_tbl[idx++] = {false, fmsubs_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fmsubs};  /*MSUB*/
    primary_tbl[idx++] = {false, fnmsubs_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fnmsubs}; /*NMSUB*/
    primary_tbl[idx++] = {false, fnmadds_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fnmadds}; /*NMADD*/

    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], fsop_tbl); idx++;
}

// -----------------------------------------------------------
// Floating point CSR register access methods
// -----------------------------------------------------------

uint32_t rv32f_cpu::access_csr(const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t rs1_uimm)
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

uint32_t rv32f_cpu::csr_wr_mask(const uint32_t addr, bool& unimp)
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
    // to clear then, despite [2] Sec. 3.1.6.5 stating it's a read
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

void rv32f_cpu::update_rm(int req_rnd_method)
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

void rv32f_cpu::handle_fexceptions()
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

void rv32f_cpu::flw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IFS_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint64_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault) | 0xffffffff00000000UL;

        if (!access_fault)
        {
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
            state.hart[curr_hart].f[d->rd] = rd_val;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32f_cpu::fsw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_SFS_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_s);

    if (!disassemble)
    {
        // Enabling stores only when MSTATUS FS bits != 0 (off)
        if (state.hart->csr[RV32CSR_ADDR_MSTATUS] & RV32CSR_MSTATUS_FS_MASK)
        {
            access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_s;

            write_mem(access_addr, (uint32_t)state.hart[curr_hart].f[d->rs2], MEM_WR_ACCESS_WORD, access_fault);
        }
    }

    if (!access_fault)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    }
}

void rv32f_cpu::fmadds(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));

    // Make sure this is a 32 bit single precision instruction (botttom 2 bits of funct7)
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;

        // Map register values stored in uint32_t types to floats
        float rs1_val = map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val = map_uint_to_float(state.hart[curr_hart].f[d->rs2]);
        float rs3_val = map_uint_to_float(state.hart[curr_hart].f[d->funct7 >> 2]);

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

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);
        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fmsubs (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2)& BIT5_MASK));

    update_rm(d->funct3);

    // Make sure this is a 32 bit single precision instrucions
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);
        float rs3_val =  map_uint_to_float(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = (rs1_val * rs2_val) - rs3_val;
        }
        catch (...)
        {
            
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fnmsubs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2) & BIT5_MASK));
    
    // Make sure this is a 32 bit single precision instrucions
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);
        float rs3_val =  map_uint_to_float(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = -1.0F * (rs1_val * rs2_val) + rs3_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fnmadds(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R4_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2, ((d->imm_s >> 2)& BIT5_MASK));

    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);
        float rs3_val =  map_uint_to_float(state.hart[curr_hart].f[d->funct7 >> 2]);

        update_rm(d->funct3);

        try
        {
            rd_val = -1.0F * (rs1_val * rs2_val) - rs3_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fadds(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val + rs2_val;
        }
        catch (...)
        {

        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fsubs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val - rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions(); 

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fmuls(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val * rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fdivs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);
    
    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
        float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

        update_rm(d->funct3);

        try
        {
            rd_val = rs1_val / rs2_val;
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fsqrts(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    // Make sure this is a 32 bit single precision instruction
    if (d->funct7 & BIT2_MASK)
    {
        reserved(d);
    }
    else
    {
        float rd_val;
        float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);

        update_rm(d->funct3);

        try
        {
            rd_val = sqrt(rs1_val);
        }
        catch (...)
        {
        }

        handle_fexceptions();

        state.hart[curr_hart].f[d->rd] =  map_float_to_uint(rd_val);

        cycle_count += RV32I_FLOAT_EXTRA_CYCLES;
    }

    increment_pc();
}

void rv32f_cpu::fsgnjs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     (state.hart[curr_hart].f[d->rs2] & SIGN32_BIT);

    increment_pc();
}

void rv32f_cpu::fsgnjns(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     (~state.hart[curr_hart].f[d->rs2] & SIGN32_BIT);

    increment_pc();
}

void rv32f_cpu::fsgnjxs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);
    state.hart[curr_hart].f[d->rd] = (state.hart[curr_hart].f[d->rs1] & ~SIGN32_BIT) | 
                                     ((state.hart[curr_hart].f[d->rs1] ^ state.hart[curr_hart].f[d->rs2]) & SIGN32_BIT);

    increment_pc();
}

void rv32f_cpu::fmins(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rd_val;
    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) && std::isnan(rs2_val))
    {
        rd_val = NAN;
    }
    else if (state.hart[curr_hart].f[d->rs1] == RV32I_SNANF && !std::isnan(rs2_val))
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

    state.hart[curr_hart].f[d->rd] =  map_float_to_uint(rd_val);

    increment_pc();
}

void rv32f_cpu::fmaxs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rd_val;
    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) && std::isnan(rs2_val))
    {
        rd_val = NAN;
    }
    else if (state.hart[curr_hart].f[d->rs1] == RV32I_SNANF && !std::isnan(rs2_val))
    {
        rd_val = rs2_val;

        state.hart[curr_hart].csr[RV32CSR_ADDR_FCSR]   |= RV32I_NV;
        state.hart[curr_hart].csr[RV32CSR_ADDR_FFLAGS] |= RV32I_NV;
    }
    else if (state.hart[curr_hart].f[d->rs2] == RV32I_SNANF && !std::isnan(rs1_val))
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

    state.hart[curr_hart].f[d->rd] =  map_float_to_uint(rd_val);

    increment_pc();
}

void rv32f_cpu::feqs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

    if (std::isnan(rs1_val) || std::isnan(rs2_val))
    {
        state.hart[curr_hart].x[d->rd] = 0;

        if (state.hart[curr_hart].f[d->rs1] == RV32I_SNANF)
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

void rv32f_cpu::flts(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

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

void rv32f_cpu::fles   (const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RF_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    float rs2_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs2]);

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

void rv32f_cpu::fclasss(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT1_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2); 

    float      rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);
    uint32_t* p_rs1_uint = (uint32_t*)&rs1_val;

    switch (std::fpclassify(rs1_val))
    {
    case FP_INFINITE:
        state.hart[curr_hart].x[d->rd] = (rs1_val == INFINITY) ? (1 << 7) : (1 << 0);
        break;
    case FP_NAN:
        state.hart[curr_hart].x[d->rd] = (*p_rs1_uint == (uint32_t)RV32I_QNANF) ? (1 << 9) : (1 << 8);
        break;
    case FP_ZERO: 
        state.hart[curr_hart].x[d->rd] = (*p_rs1_uint & SIGN32_BIT) ? (1 << 3) : (1 << 4);
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

void rv32f_cpu::fcvtsw(const p_rv32i_decode_t d)
{
    if (d->rs2)
    {
        d->entry.instr_name = fcvtswu_str;
    }
    RV32I_DISASSEM_RFCVT2_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    update_rm(d->funct3);

    float rd_val = d->rs2 ? (float)state.hart[curr_hart].x[d->rs1] : (float((int32_t)state.hart[curr_hart].x[d->rs1]));

    state.hart[curr_hart].f[d->rd] = map_float_to_uint(rd_val);

    increment_pc();
}

void rv32f_cpu::fcvtws(const p_rv32i_decode_t d)
{
    if (d->rs2)
    {
        d->entry.instr_name = fcvtwus_str;
    }
    RV32I_DISASSEM_RFCVT1_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    float rs1_val =  map_uint_to_float(state.hart[curr_hart].f[d->rs1]);

    update_rm(d->funct3);

    state.hart[curr_hart].x[d->rd] = (d->rs2 ? ((uint32_t)rs1_val) : ((int32_t)rs1_val));

    float cmp = nearbyintf(rs1_val);

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

void rv32f_cpu::fmvwx(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT2_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].f[d->rd] = state.hart[curr_hart].x[d->rs1];

    increment_pc();
}

void rv32f_cpu::fmvxw(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_RFCVT1_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].f[d->rs1];

    increment_pc();
}
