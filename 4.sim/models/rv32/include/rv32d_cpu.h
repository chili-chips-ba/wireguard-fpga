//=============================================================
//
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 30th July 2021
//
// Contains the class definition for the rv32d_cpu derived class
//
// This file is part of the M extended RISC-V instruction
// set simulator (rv32d_cpu).
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

#ifndef _RV32D_CPU_H_
#define _RV32D_CPU_H_

#include <cmath>
#include <cfenv>
#include <climits>

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu_hdr.h"
#include RV32D_INCLUDE

class rv32d_cpu : public RV32_D_INHERITANCE_CLASS
{
public:
             LIBRISCV32_API      rv32d_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32d_cpu()   { };

private:
    // Add an RV32F instruction secondary table here.
    rv32i_decode_table_t  fdop_tbl      [RV32I_NUM_SECONDARY_OPCODES];

    // OP-FP tertiary table (decoded on funct7)
    rv32i_decode_table_t  fd_tbl        [RV32I_NUM_TERTIARY_OPCODES];

    // Quarternary table (decoded on funct3 via decode_exception method)
    rv32i_decode_table_t  fsgnjd_tbl    [RV32I_NUM_SECONDARY_OPCODES];
    rv32i_decode_table_t  fminmaxd_tbl  [RV32I_NUM_SECONDARY_OPCODES];
    rv32i_decode_table_t  fcmpd_tbl     [RV32I_NUM_SECONDARY_OPCODES];
    rv32i_decode_table_t  fclassd_tbl   [RV32I_NUM_SECONDARY_OPCODES];

    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    const char fld_str           [DISASSEM_STR_SIZE] = "fld      ";
    const char fsd_str           [DISASSEM_STR_SIZE] = "fsd      ";
    const char fmaddd_str        [DISASSEM_STR_SIZE] = "fmadd.d  ";
    const char fmsubd_str        [DISASSEM_STR_SIZE] = "fmsub.d  ";
    const char fnmsubd_str       [DISASSEM_STR_SIZE] = "fnmsub.d ";
    const char fnmaddd_str       [DISASSEM_STR_SIZE] = "fnmadd.d ";
    const char faddd_str         [DISASSEM_STR_SIZE] = "fadd.d   ";
    const char fsubd_str         [DISASSEM_STR_SIZE] = "fsub.d   ";
    const char fmuld_str         [DISASSEM_STR_SIZE] = "fmul.d   ";
    const char fdivd_str         [DISASSEM_STR_SIZE] = "fdiv.d   ";
    const char fsqrtd_str        [DISASSEM_STR_SIZE] = "fsqrt.d  ";
    const char fsgnjd_str        [DISASSEM_STR_SIZE] = "fsgnj.d  ";
    const char fsgnjnd_str       [DISASSEM_STR_SIZE] = "fsgnjn.d ";
    const char fsgnjxd_str       [DISASSEM_STR_SIZE] = "fsgnjx.d ";
    const char fmind_str         [DISASSEM_STR_SIZE] = "fmin.d   ";
    const char fmaxd_str         [DISASSEM_STR_SIZE] = "fmax.d   ";
    const char fcvtwd_str        [DISASSEM_STR_SIZE] = "fcvt.w.d ";
    const char fcvtwud_str       [DISASSEM_STR_SIZE] = "fcvt.wu.d";
    const char feqd_str          [DISASSEM_STR_SIZE] = "feq.d    ";
    const char fltd_str          [DISASSEM_STR_SIZE] = "flt.d    ";
    const char fled_str          [DISASSEM_STR_SIZE] = "fle.s    ";
    const char fclassd_str       [DISASSEM_STR_SIZE] = "fclass.d ";
    const char fcvtdw_str        [DISASSEM_STR_SIZE] = "fcvt.d.w ";
    const char fcvtdwu_str       [DISASSEM_STR_SIZE] = "fcvt.d.wu";
    
    // New to RV32D
    const char fcvtsd_str        [DISASSEM_STR_SIZE] = "fcvt.s.d ";
    const char fcvtds_str        [DISASSEM_STR_SIZE] = "fcvt.d.s ";

    int        curr_rnd_method;

    // ------------------------------------------------
    // Private member functions
    // ------------------------------------------------

    // CSR access routines
    uint32_t csr_wr_mask(const uint32_t addr, bool& unimp);
    uint32_t access_csr(const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t rs1_uimm);

    // Updates the floating point rounding method
    void update_rm(int req_rnd_method);

    // Handles flotaing point exceptions
    void handle_fexceptions();

    void decode_exception(rv32i_decode_table_t*& p_entry, rv32i_decode_t& d)
    {
        // Have the possibility of a fourth level decode on funct3
        if (p_entry->sub_table)
        {
            p_entry = &p_entry->ref.p_entry[d.funct3];
        }
        else
        {
            p_entry = NULL;
        }
    }

    double map_uint_to_double(uint64_t& num)
    {
        return *((double *) & num);
    }

    uint64_t map_double_to_uint(double& num, bool make_pos = true)
    {
        // Map double to unit32_t. If NaN, ensure sign bit is clear
        return *((uint64_t*)&num) & ((std::isnan(num) & make_pos )? 0x7fffffffffffffffUL : 0xffffffffffffffffUL);
    }

protected:

    // RV32D extension instruction methods
    void fld                             (const p_rv32i_decode_t);
    void fsd                             (const p_rv32i_decode_t);
    void fmaddd                          (const p_rv32i_decode_t);
    void fmsubd                          (const p_rv32i_decode_t);
    void fnmsubd                         (const p_rv32i_decode_t);
    void fnmaddd                         (const p_rv32i_decode_t);
    void faddd                           (const p_rv32i_decode_t);
    void fsubd                           (const p_rv32i_decode_t);
    void fmuld                           (const p_rv32i_decode_t);
    void fdivd                           (const p_rv32i_decode_t);
    void fsqrtd                          (const p_rv32i_decode_t);
    void fsgnjd                          (const p_rv32i_decode_t);
    void fsgnjnd                         (const p_rv32i_decode_t);
    void fsgnjxd                         (const p_rv32i_decode_t);
    void fmind                           (const p_rv32i_decode_t);
    void fmaxd                           (const p_rv32i_decode_t);
    void fcvtwd                          (const p_rv32i_decode_t);
    void feqd                            (const p_rv32i_decode_t);
    void fltd                            (const p_rv32i_decode_t);
    void fled                            (const p_rv32i_decode_t);
    void fclassd                         (const p_rv32i_decode_t);
    void fcvtdw                          (const p_rv32i_decode_t);
    
    void fcvtsd                          (const p_rv32i_decode_t);
    void fcvtds                          (const p_rv32i_decode_t);
};

#endif
