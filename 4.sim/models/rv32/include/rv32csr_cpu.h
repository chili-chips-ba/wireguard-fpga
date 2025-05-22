//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 12th July 2021
//
// Contains the class definition for the rv32csr_cpu derived class
//
// This file is part of the Zicsr extended RISC-V instruction
// set simulator (rv32csr_cpu).
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

#ifndef _RV32CSR_CPU_H_
#define _RV32CSR_CPU_H_

#include "rv32_extensions.h"
#include "rv32csr_cpu_hdr.h"
#include RV32CSR_INCLUDE

class rv32csr_cpu : public rv32csr_consts, public RV32_ZICSR_INHERITANCE_CLASS
{
public:
             LIBRISCV32_API      rv32csr_cpu      (FILE* dbgfp = stdout);
    virtual  LIBRISCV32_API      ~rv32csr_cpu()   { };

    LIBRISCV32_API void          register_int_callback          (p_rv32i_intcallback_t callback_func) { p_int_callback = callback_func; };

    // Overload run method
    LIBRISCV32_API int           run(rv32i_cfg_s& cfg)
    {
        // Call base run method
        int rstatus =  RV32_ZICSR_INHERITANCE_CLASS::run(cfg);

        // Ensure cycle and instruction retired CSR counts are up to date
        // before returning in case the CSR registers are dumped.
        update_csr_counts();

        return rstatus;
    }

private:
    // ------------------------------------------------
    // Private member variables
    // ------------------------------------------------

    // Pointer to interrupt callback function
    p_rv32i_intcallback_t p_int_callback;

    rv32i_time_t          interrupt_wakeup_time;

    const char mret_str    [DISASSEM_STR_SIZE] = "mret     ";
    const char csrrw_str   [DISASSEM_STR_SIZE] = "csrrw    ";
    const char csrrs_str   [DISASSEM_STR_SIZE] = "csrrs    ";
    const char csrrc_str   [DISASSEM_STR_SIZE] = "csrrc    ";
    const char csrrwi_str  [DISASSEM_STR_SIZE] = "csrrwi   ";
    const char csrrsi_str  [DISASSEM_STR_SIZE] = "csrrsi   ";
    const char csrrci_str  [DISASSEM_STR_SIZE] = "csrrci   ";

    // ------------------------------------------------
    // Private member functions
    // ------------------------------------------------

    // Overloaded reset function
    void reset                           (void);

    // Overload processing of traps
    void process_trap(int trap_type);

    // Process interrupts
    int  process_interrupts();

    // Return from trap instruction
    void mret                            (const p_rv32i_decode_t);

    // Zicsr instructions
    void csrrw                           (const p_rv32i_decode_t);
    void csrrs                           (const p_rv32i_decode_t);
    void csrrc                           (const p_rv32i_decode_t);
    void csrrwi                          (const p_rv32i_decode_t);
    void csrrsi                          (const p_rv32i_decode_t);
    void csrrci                          (const p_rv32i_decode_t);

protected:
    // CSR access method
    virtual uint32_t access_csr          (const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t value);

    // Return write mask (bit set equals writable) for given CSR, with unimplemented status flag
    virtual uint32_t csr_wr_mask         (const uint32_t addr, bool& unimp);

    // Update cycle and instrunction retired CSR register counts
    void update_csr_counts(void);

};

#endif
