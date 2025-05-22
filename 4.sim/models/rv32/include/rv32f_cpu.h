//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 26th July 2021
//
// Contains the class definition for the rv32f_cpu derived class
//
// This file is part of the M extended RISC-V instruction
// set simulator (rv32f_cpu).
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

#ifndef _RV32F_CPU_H_
#define _RV32F_CPU_H_

#include <cmath>
#include <cfenv>
#include <climits>

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu_hdr.h"
#include RV32F_INCLUDE

class rv32f_cpu : public RV32_F_INHERITANCE_CLASS
{
public:

    const char flw_str           [DISASSEM_STR_SIZE] = "flw      ";
    const char fsw_str           [DISASSEM_STR_SIZE] = "fsw      ";
    const char fmadds_str        [DISASSEM_STR_SIZE] = "fmadd.s  ";
    const char fmsubs_str        [DISASSEM_STR_SIZE] = "fmsub.s  ";
    const char fnmsubs_str       [DISASSEM_STR_SIZE] = "fnmsub.s ";
    const char fnmadds_str       [DISASSEM_STR_SIZE] = "fnmadd.s ";
    const char fadds_str         [DISASSEM_STR_SIZE] = "fadd.s   ";
    const char fsubs_str         [DISASSEM_STR_SIZE] = "fsub.s   ";
    const char fmuls_str         [DISASSEM_STR_SIZE] = "fmul.s   ";
    const char fdivs_str         [DISASSEM_STR_SIZE] = "fdiv.s   ";
    const char fsqrts_str        [DISASSEM_STR_SIZE] = "fsqrt.s  ";
    const char fsgnjs_str        [DISASSEM_STR_SIZE] = "fsgnj.s  ";
    const char fsgnjns_str       [DISASSEM_STR_SIZE] = "fsgnjn.s ";
    const char fsgnjxs_str       [DISASSEM_STR_SIZE] = "fsgnjx.s ";
    const char fmins_str         [DISASSEM_STR_SIZE] = "fmin.s   ";
    const char fmaxs_str         [DISASSEM_STR_SIZE] = "fmax.s   ";
    const char fcvtws_str        [DISASSEM_STR_SIZE] = "fcvt.w.s ";
    const char fcvtwus_str       [DISASSEM_STR_SIZE] = "fcvt.wu.s";
    const char fmvxw_str         [DISASSEM_STR_SIZE] = "fmv.x.w  ";
    const char feqs_str          [DISASSEM_STR_SIZE] = "feq.s    ";
    const char flts_str          [DISASSEM_STR_SIZE] = "flt.s    ";
    const char fles_str          [DISASSEM_STR_SIZE] = "fle.s    ";
    const char fclasss_str       [DISASSEM_STR_SIZE] = "fclass.s ";
    const char fcvtsw_str        [DISASSEM_STR_SIZE] = "fcvt.s.w ";
    const char fcvtswu_str       [DISASSEM_STR_SIZE] = "fcvt.s.wu";
    const char fmvwx_str         [DISASSEM_STR_SIZE] = "fmv.w.x  ";

             LIBRISCV32_API      rv32f_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32f_cpu()   { };

protected:
    // Add an RV32F instruction secondary table here.
    rv32i_decode_table_t  fsop_tbl      [RV32I_NUM_SECONDARY_OPCODES];

    // OP-FP tertiary table (decoded on funct7)
    rv32i_decode_table_t  fs_tbl        [RV32I_NUM_TERTIARY_OPCODES];

    // Quarternary table (decoded on funct3 via decode_exception method)
    rv32i_decode_table_t  fsgnjs_tbl    [RV32I_NUM_QUARTERNARY_OPCODES];
    rv32i_decode_table_t  fminmaxs_tbl  [RV32I_NUM_QUARTERNARY_OPCODES];
    rv32i_decode_table_t  fcmp_tbl      [RV32I_NUM_QUARTERNARY_OPCODES];
    rv32i_decode_table_t  fmv_tbl       [RV32I_NUM_QUARTERNARY_OPCODES];

private:

    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    int        curr_rnd_method;

    // ------------------------------------------------
    // Virtual member functions
    // ------------------------------------------------

    // These functions are virtual so that they can be overridden,
    // if need be, by the rv32d_cpu class, which implements its own
    // versions (even when the same functionality) so that it does
    // not rely on the presence of this class in the class hierarchy.

    // CSR access routines
    virtual uint32_t csr_wr_mask   (const uint32_t addr, bool& unimp);
    virtual uint32_t access_csr    (const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t rs1_uimm);

    // Updates the floating point rounding method
    virtual void update_rm         (int req_rnd_method);

    // Handles floating point exceptions
    virtual void handle_fexceptions();

    // ------------------------------------------------
    // Private member functions
    // ------------------------------------------------

    float map_uint_to_float(uint64_t& num)
    {
        return *((float*)&num);
    }

    uint32_t map_float_to_uint(float& num, bool make_pos = true)
    {
        // Map float to unit32_t. If NaN, ensure sign bit is clear
        return *((uint32_t*)&num) & ((std::isnan(num) & make_pos )? 0x7fffffff : 0xffffffff);
    }

protected:

    // RV32F extension instruction methods
    void flw                             (const p_rv32i_decode_t);
    void fsw                             (const p_rv32i_decode_t);
    void fmadds                          (const p_rv32i_decode_t);
    void fmsubs                          (const p_rv32i_decode_t);
    void fnmsubs                         (const p_rv32i_decode_t);
    void fnmadds                         (const p_rv32i_decode_t);
    void fadds                           (const p_rv32i_decode_t);
    void fsubs                           (const p_rv32i_decode_t);
    void fmuls                           (const p_rv32i_decode_t); 
    void fdivs                           (const p_rv32i_decode_t);
    void fsqrts                          (const p_rv32i_decode_t);
    void fsgnjs                          (const p_rv32i_decode_t);
    void fsgnjns                         (const p_rv32i_decode_t);
    void fsgnjxs                         (const p_rv32i_decode_t);
    void fmins                           (const p_rv32i_decode_t);
    void fmaxs                           (const p_rv32i_decode_t);
    void fcvtws                          (const p_rv32i_decode_t);
    void feqs                            (const p_rv32i_decode_t);
    void flts                            (const p_rv32i_decode_t);
    void fles                            (const p_rv32i_decode_t);
    void fclasss                         (const p_rv32i_decode_t);
    void fcvtsw                          (const p_rv32i_decode_t);
    void fmvwx                           (const p_rv32i_decode_t);
    void fmvxw                           (const p_rv32i_decode_t);

    virtual void decode_exception (rv32i_decode_table_t*& p_entry, rv32i_decode_t& d)
    {
        // Have the possibility of a fourth level decode on funct3
        if (p_entry && p_entry->sub_table)
        {
            p_entry = &p_entry->ref.p_entry[d.funct3];
        }
        else
        {
            p_entry = NULL;
        }
    }
};

#endif
