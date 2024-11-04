//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 24th July 2021
//
// Contains the class definition for the rv32m_cpu derived class
//
// This file is part of the M extended RISC-V instruction
// set simulator (rv32m_cpu).
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

#ifndef _RV32M_CPU_H_
#define _RV32M_CPU_H_

#include "rv32_extensions.h"
#include "rv32i_cpu_hdr.h"
#include "rv32csr_cpu.h"
#include RV32M_INCLUDE

class rv32m_cpu : public RV32_M_INHERITANCE_CLASS
{
public:
             LIBRISCV32_API      rv32m_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32m_cpu()   { };

private:
    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    const char mul_str     [DISASSEM_STR_SIZE] = "mul      ";
    const char mulh_str    [DISASSEM_STR_SIZE] = "mulh     ";
    const char mulhsu_str  [DISASSEM_STR_SIZE] = "mulhsu   ";
    const char mulhu_str   [DISASSEM_STR_SIZE] = "mulhu    ";
    const char div_str     [DISASSEM_STR_SIZE] = "div      ";
    const char divu_str    [DISASSEM_STR_SIZE] = "divu     ";
    const char rem_str     [DISASSEM_STR_SIZE] = "rem      ";
    const char remu_str    [DISASSEM_STR_SIZE] = "remu     ";

    // ------------------------------------------------
    // Private member functions
    // ------------------------------------------------

    // M extension instructions
    void mul                             (const p_rv32i_decode_t);
    void mulh                            (const p_rv32i_decode_t);
    void mulhsu                          (const p_rv32i_decode_t);
    void mulhu                           (const p_rv32i_decode_t);
    void div                             (const p_rv32i_decode_t);
    void divu                            (const p_rv32i_decode_t);
    void rem                             (const p_rv32i_decode_t);
    void remu                            (const p_rv32i_decode_t);

protected:


};

#endif
