//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 28th June 2021
//
// Contains the instruction execution methods for the
// rv32i_cpu base class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32i_cpu).
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

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <iterator>
#include <cstring>
#include <cstdlib>

#include "rv32i_cpu.h"

// -------------------------------------------------------------------------
// METHODS
// -------------------------------------------------------------------------

// Constructor
rv32i_cpu::rv32i_cpu(FILE* dbg_fp) : dasm_fp(dbg_fp)
{
    // No callback functions registered by default
    p_mem_callback           = NULL;
    p_unimp_callback         = NULL;

    // Cycle count set to 0
    cycle_count              = 0;

    // Instructions retired count set to 0
    instret_count            = 0;

    // Default the timer compare to max value
    mtimecmp                 = (uint64_t)(-1);

    // Default the current instruction to an unimplemented instruction
    curr_instr               = 0x00000000;

    // Default the load/store address
    access_addr              = 0x00000000;

    reset_vector             = RV32I_RESET_VECTOR;

    cmp_instr                = false;
    RV32_IADDR_ALIGN_MASK = 0x00000003;

    abi_en                   = true;
    use_cycles_for_mtime     = false;
    use_external_timer       = false;

    // Reset state
    reset();

    // Set up decode tables for RV32I, as per The RISC-V Instruction Set Manual,
    // Volume I: RISC-V Unprivileged ISA V20191213 chapter 24

    // Initialise tertiary tables to reserved instruction
    for (int i = 0; i < RV32I_NUM_TERTIARY_OPCODES; i++)
    {
        sri_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        arith_tbl[i]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        sll_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        slli_tbl[i]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        slt_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        sltu_tbl[i]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        srr_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        xor_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        or_tbl[i]      = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
        and_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
    }

    // Seconary table for load instructions (decoded on funct3)
    int idx = 0;
    load_tbl[idx++]    = {false, lb_str,       RV32I_INSTR_FMT_I,   &rv32i_cpu::lb };       /* LB */
    load_tbl[idx++]    = {false, lh_str,       RV32I_INSTR_FMT_I,   &rv32i_cpu::lh };       /* LH */
    load_tbl[idx++]    = {false, lw_str,       RV32I_INSTR_FMT_I,   &rv32i_cpu::lw };       /* LW */
    load_tbl[idx++]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    load_tbl[idx++]    = {false, lbu_str,      RV32I_INSTR_FMT_I,   &rv32i_cpu::lbu };      /* LBU*/
    load_tbl[idx++]    = {false, lhu_str,      RV32I_INSTR_FMT_I,   &rv32i_cpu::lhu };      /* LHU*/
    load_tbl[idx++]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    load_tbl[idx++]    = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/

    // Seconary table for store instructions (decoded on funct3)
    idx = 0;
    store_tbl[idx++]   = {false, sb_str,       RV32I_INSTR_FMT_S,   &rv32i_cpu::sb };       /* SB */
    store_tbl[idx++]   = {false, sh_str,       RV32I_INSTR_FMT_S,   &rv32i_cpu::sh };       /* SH */
    store_tbl[idx++]   = {false, sw_str,       RV32I_INSTR_FMT_S,   &rv32i_cpu::sw };       /* SW */
    store_tbl[idx++]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    store_tbl[idx++]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    store_tbl[idx++]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    store_tbl[idx++]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    store_tbl[idx++]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/

    // Seconary table for branch instructions (decoded on funct3)
    idx = 0;
    branch_tbl[idx++]  = {false, beq_str,      RV32I_INSTR_FMT_B,   &rv32i_cpu::beq };      /*BEQ*/
    branch_tbl[idx++]  = {false, bne_str,      RV32I_INSTR_FMT_B,   &rv32i_cpu::bne };      /*BNE*/
    branch_tbl[idx++]  = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    branch_tbl[idx++]  = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    branch_tbl[idx++]  = {false, blt_str,      RV32I_INSTR_FMT_B,   &rv32i_cpu::blt };      /*BLT*/
    branch_tbl[idx++]  = {false, bge_str,      RV32I_INSTR_FMT_B,   &rv32i_cpu::bge };      /*BGE*/
    branch_tbl[idx++]  = {false, bltu_str,     RV32I_INSTR_FMT_B,   &rv32i_cpu::bltu };     /*BLTU*/
    branch_tbl[idx++]  = {false, bgeu_str,     RV32I_INSTR_FMT_B,   &rv32i_cpu::bgeu };     /*BGEU*/

    // Tertiary table for shift right immediate instructions (decoded on funct7)
    sri_tbl[0x00]      = {false, srli_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::srli };     /*SRLI*/
    sri_tbl[0x20]      = {false, srai_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::srai };     /*SRAI*/

    // Seconary table for immediate operations instructions (decoded on funct3)
    idx = 0;
    op_imm_tbl[idx++]  = {false, addi_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::addi };     /*ADDI*/
    INIT_TBL_WITH_SUBTBL(op_imm_tbl[idx], slli_tbl); idx++;                                 /*SLLI*/
    op_imm_tbl[idx++]  = {false, slti_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::slti };     /*SLTI*/
    op_imm_tbl[idx++]  = {false, sltiu_str,    RV32I_INSTR_FMT_I,   &rv32i_cpu::sltiu };    /*SLTIU*/
    op_imm_tbl[idx++]  = {false, xori_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::xori };     /*XORI*/
    INIT_TBL_WITH_SUBTBL(op_imm_tbl[idx], sri_tbl); idx++;                                  /*SRLI and SRAI*/
    op_imm_tbl[idx++]  = {false, ori_str,      RV32I_INSTR_FMT_I,   &rv32i_cpu::ori };      /*ORI*/
    op_imm_tbl[idx++]  = {false, andi_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::andi };     /*ANDI*/

    // Tertiary table for arithmetic instructions (decoded on funct7)
    arith_tbl[0x00]    = {false, add_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::addr };     /*ADD*/
    arith_tbl[0x20]    = {false, sub_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::subr };     /*SUB*/

    // Tertiary table for shift left register to register instructions (decoded on funct7)
    sll_tbl[0x00]      = {false, sll_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::sllr };     /*SLL*/
 
    // Tertiary table for set-less-than register to register instructions (decoded on funct7)
    slt_tbl[0x00]      = {false, slt_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::sltr };     /*SLT*/
    sltu_tbl[0x00]     = {false, sltu_str,     RV32I_INSTR_FMT_R,   &rv32i_cpu::sltur };    /*SLTU*/

    // Tertiary table for shift right register to register instructions (decoded on funct7)
    srr_tbl[0x00]      = {false, srl_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::srlr };     /*SRL*/
    srr_tbl[0x20]      = {false, sra_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::srar };     /*SRA*/

    // Tertiary table for logic operation register to register instructions (decoded on funct7)
    xor_tbl[0x00]      = {false, xor_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::xorr };     /*XOR*/
    or_tbl[0x00]       = {false, or_str,       RV32I_INSTR_FMT_R,   &rv32i_cpu::orr };      /*OR*/
    and_tbl[0x00]      = {false, and_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::andr };     /*AND*/

    // Tertiary table for immediate operations instructions (decoded on funct7)
    slli_tbl[0x00]     = {false, slli_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::slli };

    // Seconary table for register to register operations instructions (decoded on funct3)
    idx = 0;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], arith_tbl); idx++;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], sll_tbl);   idx++;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], slt_tbl);   idx++;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], sltu_tbl);  idx++; 
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], xor_tbl);   idx++;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], srr_tbl);   idx++; 
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], or_tbl);    idx++;
    INIT_TBL_WITH_SUBTBL(op_tbl[idx], and_tbl);   idx++; 

    // Update decode table with extended instructions
    idx = 0;
    // Tertiary table for ECALL and EBREAK instructions (decoded on funct12 = imm_i)
    e_tbl[idx++]       = {false, ecall_str,    RV32I_INSTR_FMT_R,   &rv32i_cpu::ecall };    /*ECALL*/
    e_tbl[idx++]       = {false, ebrk_str,     RV32I_INSTR_FMT_R,   &rv32i_cpu::ebreak };   /*EBREAK*/
    e_tbl[idx++]       = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };
    e_tbl[idx++]       = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved };

    // Secondary table for system instructions (decoded on funct3)
    idx = 0;
    INIT_TBL_WITH_SUBTBL(sys_tbl[idx], e_tbl); idx++;                                       /*ECALL/EBREAK*/
    for (idx = 1; idx < RV32I_NUM_SECONDARY_OPCODES; idx++)
    {
        sys_tbl[idx]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved }; /*RSVD*/
    }

    // Primary decode table (decoded on opcode)
    idx = 0;
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], load_tbl); idx++;                                /*LOAD */
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*LOAD-FP*/ 
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*custom-0*/
    primary_tbl[idx++] = {false, fence_str,    RV32I_INSTR_FMT_I,   &rv32i_cpu::fence};     /*MISC-MEM*/
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], op_imm_tbl); idx++;                              /*OP-IMM*/
    primary_tbl[idx++] = {false, auipc_str,    RV32I_INSTR_FMT_U,   &rv32i_cpu::auipc};     /*AUIPC*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*OP-IMM-32*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*48b*/
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], store_tbl); idx++;                               /*STORE*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*STORE-FP*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*custom-1*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*AMO*/
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], op_tbl); idx++;                                  /*OP*/
    primary_tbl[idx++] = {false, lui_str,      RV32I_INSTR_FMT_R,   &rv32i_cpu::lui};       /*LUI*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*OP-32*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*64b*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*MADD*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*MSUB*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*NMSUB*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*NMADD*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*OP-FP*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*RSVD*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*RSVD128*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*48b*/
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], branch_tbl); idx++;                              /*BRANCH*/
    primary_tbl[idx++] = {false, jalr_str,     RV32I_INSTR_FMT_I,   &rv32i_cpu::jalr};      /*JALR*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*RSVD*/
    primary_tbl[idx++] = {false, jal_str,      RV32I_INSTR_FMT_J,   &rv32i_cpu::jal};       /*JAL*/
    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], sys_tbl); idx++;                                 /*SYSTEM*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*RSVD*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*RSVD128*/
    primary_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};  /*>=80b*/

};

// -----------------------------------------------------------
// Reset
// -----------------------------------------------------------

void rv32i_cpu::reset()
{
    // Set current HART to be the only currently supported one
    curr_hart = 0;

    trap = 0;

    // Set default privilege level
    state.priv_lvl = RV32_PRIV_MACHINE;

    // Set disassemble default state
    disassemble = false;
    rt_disassem = true; // TODO: default to false

    str_idx = 0;

    // Initialise register state for each supported HART
    for (unsigned idx = 0; idx < RV32I_NUM_OF_HARTS; idx++)
    {
        state.hart[idx].pc   = reset_vector;
    }

}

// -----------------------------------------------------------
// Entry point to run code
//-----------------------------------------------------------

int rv32i_cpu::run(rv32i_cfg_s &cfg)
{
    int error = 0;
    unsigned instr_count;

    // Set disassemble switches
    rt_disassem            = cfg.rt_dis;
    disassemble            = cfg.dis_en;
    abi_en                 = cfg.abi_en;
    use_cycles_for_mtime   = cfg.use_cycles_for_mtime;
    use_external_timer     = cfg.use_external_timer;

    // Set halt switches
    halt_rsvd_instr        = cfg.hlt_on_inst_err;
    halt_ecall             = cfg.hlt_on_ecall;
    halt_ebreak            = cfg.hlt_on_ebreak;

    // If a new start address specified, update the reset vector
    if (cfg.update_rst_vec)
    {
        reset_vector             = cfg.new_rst_vec;
        state.hart[curr_hart].pc = reset_vector;

        // Should only do this once
        cfg.update_rst_vec       = false;
    }

    // If a new stack pointer specified, update the sp register
    if (cfg.update_sp)
    {
        state.hart[curr_hart].x[2] = cfg.new_sp;
    }

    rv32i_decode_t        decode;
    rv32i_decode_table_t* p_entry;

    for (instr_count = 0; 
         (cfg.num_instr == 0 || instr_count < cfg.num_instr) && !error && !(cfg.en_brk_on_addr && cfg.brk_addr == state.hart[curr_hart].pc);
         instr_count++)
    {
        // Firstly, check interrupt status
        if (!process_interrupts())
        {
            // Fetch instruction
            curr_instr = fetch_instruction();

            // Decode
            p_entry = primary_decode(curr_instr, decode);

            // Execute
            if (p_entry != NULL)
            {
                error = execute(decode, p_entry);
            }
            // If no entry in the table, run 'reserved' instruction to allow for any unimp callback processing
            else
            {
                rv32i_decode_table_t rsvd_entry = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
                error = execute(decode, &rsvd_entry);
            }

            // Process any illegal instruction exceptions
            if (error == SIGILL && !halt_rsvd_instr)
            {
                process_trap(RV32I_ILLEGAL_INSTR);
                error = 0;
            }
        }
    }

    if (cfg.en_brk_on_addr && cfg.brk_addr == state.hart[curr_hart].pc)
    {
        error = SIGTERM;
    }
    else if (cfg.num_instr != 0 && instret_count >= cfg.num_instr)
    {
        error = SIGTRAP;
    }

    return error;
}

// -----------------------------------------------------------
// Execute an instruction
// -----------------------------------------------------------

int  rv32i_cpu::execute(rv32i_decode_t& decode, rv32i_decode_table_t* p_entry)
{
    int error = 0;

 
    (this->*p_entry->p)(&decode);
 
    // Update cycle count and instructions retired count. By default, the timing model
    // assumes 1 cycle for each instruction. For jumps and branches, additional cycles
    // are added in the instruction methods. For memory accesses, the external callbacks
    // return wait state counts, which are added.
    cycle_count   += RV32I_DEFAULT_INSTR_CYCLE_COUNT;
    instret_count += 1;

    // If an illegal/unimplemented instruction, or halt on a system instruction, flag to calling function
    if (trap == SIGILL || ((halt_ecall || halt_ebreak) && (trap == SIGTERM || trap == SIGTRAP)))
    {
        error = trap;

        // Clear trap condition
        trap = 0;
    }

    return error;
}

// -----------------------------------------------------------
// Primary Decode method
//
// Decode all possible fields here to reflect a logic
// implementation to extract values without full decode
// 
// Returns NULL on a failed decode, or a pointer to an
// instruction function.
// -----------------------------------------------------------

rv32i_decode_table_t* rv32i_cpu::primary_decode(const opcode_t instr, rv32i_decode_t& decoded_data)
{

    rv32i_decode_table_t* p_entry = NULL;

    // Extract the different fields from the instruction
    decoded_data.instr  = instr;
    decoded_data.opcode = (instr & RV32I_MASK_OPCODE)  >> RV32I_OPCODE_START_BIT;
    decoded_data.funct3 = (instr & RV32I_MASK_FUNCT_3) >> RV32I_FUNCT_3_START_BIT;
    decoded_data.funct7 = (instr & RV32I_MASK_FUNCT_7) >> RV32I_FUNCT_7_START_BIT;

    decoded_data.rd  = (instr & RV32I_MASK_Rx_RD)  >> RV32I_Rx_RD_START_BIT;
    decoded_data.rs1 = (instr & RV32I_MASK_Rx_RS1) >> RV32I_Rx_RS1_START_BIT;
    decoded_data.rs2 = (instr & RV32I_MASK_Rx_RS2) >> RV32I_Rx_RS2_START_BIT;

    decoded_data.imm_i = SIGN_EXT12((instr & RV32I_MASK_IMM_I) >> RV32I_IMM_I_START_BIT);

    // U type has immediate bits in matching instruction bit positions (incl. sign bit)
    decoded_data.imm_u = (instr & RV32I_MASK_IMM_U);

    decoded_data.imm_s = SIGN_EXT12((((instr & RV32I_MASK_IMM_S_11_5)  >> RV32I_IMM_S_11_5_START_BIT) << 5) |
                                    (((instr & RV32I_MASK_IMM_S_4_0)   >> RV32I_IMM_S_4_0_START_BIT) << 0));

    decoded_data.imm_b = SIGN_EXT13((((instr & RV32I_MASK_IMM_B_12)    >> RV32I_IMM_B_12_START_BIT) << 12) |
                                    (((instr & RV32I_MASK_IMM_B_11)    >> RV32I_IMM_B_11_START_BIT)   << 11) |
                                    (((instr & RV32I_MASK_IMM_B_10_5)  >> RV32I_IMM_B_10_5_START_BIT) <<  5) |
                                    (((instr & RV32I_MASK_IMM_B_4_1)   >> RV32I_IMM_B_4_1_START_BIT)  <<  1));

    decoded_data.imm_j = SIGN_EXT21((((instr & RV32I_MASK_IMM_J_20)    >> RV32I_IMM_J_20_START_BIT) << 20) |
                                    (((instr & RV32I_MASK_IMM_J_19_12) >> RV32I_IMM_J_19_12_START_BIT) << 12) |
                                    (((instr & RV32I_MASK_IMM_J_11)    >> RV32I_IMM_J_11_START_BIT)    << 11) |
                                    (((instr & RV32I_MASK_IMM_J_10_1)  >> RV32I_IMM_J_10_1_START_BIT)  <<  1));

    // Check this is a 32 bit instruction before proceeding
    if ((decoded_data.opcode & RV32I_MASK_32BIT_INSTR) == RV32I_MASK_32BIT_INSTR)
    {
        // For non-compressed instructions the bottom 2 opcode bits are always 1,
        // so can be discarded for decode
        p_entry = &primary_tbl[decoded_data.opcode >> 2];

        // Follow the tables down to until an instruction entry
        if (p_entry->sub_table)
        {
            // Get secondary table entry, if there is one
            p_entry = &p_entry->ref.p_entry[decoded_data.funct3];

            // Get tertiary table entry, if there is one
            if (p_entry->sub_table)
            {
                // Get entry indexed by funct7, unless a system opcode with funct3 = 0 (ECALL/EBREAK),
                // where funct12 is used instead (= imm_i)
                if (decoded_data.opcode == RV32I_SYS_OPCODE && decoded_data.funct3 == 0)
                {
                    // Mask imm value to ensure within table bounds.
                    // TODO: Should really check funct7 which differentiates xRET types
                    p_entry = &p_entry->ref.p_entry[decoded_data.imm_i & 0x1f];
                }
                else
                {
                    p_entry = &p_entry->ref.p_entry[decoded_data.funct7];
                }

                // It is illegal, in the base class, to have a fourth level of sub-table.
                // Call virtual function so child classes can handle separately. Base
                // class method returns NULL
                if (p_entry->sub_table)
                {
                    decode_exception(p_entry, decoded_data);
                }
            }
        }
    }

#ifdef RV32E_EXTENSION
    // If E extensions enabled, it is illegal to have register references
    // greater than x15
    if (decoded_data.rd  >= RV32I_NUM_OF_REGISTERS  ||
        decoded_data.rs1 >= RV32I_NUM_OF_REGISTERS  ||
        decoded_data.rs2 >= RV32I_NUM_OF_REGISTERS)
    {
        p_entry = NULL;
    }
#endif

    // Copy the instruction entry information to the decoded_data structure
    if (p_entry != NULL)
    {
        decoded_data.entry = p_entry->ref.entry;
    }
    // Unimplemented instruction
    else
    {
        decoded_data.entry = {reserved_str, RV32I_INSTR_FMT_S};
    }

    return p_entry;
}

// -------------------------------------------------------------------------
//  Memory access methods
// -------------------------------------------------------------------------

uint32_t rv32i_cpu::read_mem (const uint32_t byte_addr, const int type, bool &fault)
{
    uint32_t rd_val = 0;
    uint32_t word;

    fault = false;

    int  mem_callback_delay    = 1;

    // Check alignment
    if (((byte_addr & 0x1) && type != RV32I_MEM_RD_ACCESS_BYTE) ||
        ((byte_addr & 0x3) != 0x00 && (type == RV32I_MEM_RD_ACCESS_WORD || type == RV32I_MEM_RD_ACCESS_INSTR)))
    {
        process_trap((type == RV32I_MEM_RD_ACCESS_INSTR) ? RV32I_IADDR_MISALIGNED : RV32I_LADDR_MISALIGNED);
        fault = true;
        return 0;
    }

    // Check if accessing the real time clock memory mapped csr register
    if (!use_external_timer && (byte_addr & 0xfffffff8) == RV32I_RTCLOCK_ADDRESS) 
    {
        rd_val = (uint32_t)(real_time_us() >> ((byte_addr & 0x00000004) ? 32 : 0));
    }
    // Check if accessing the memory mapped time compare register
    else if (!use_external_timer && (byte_addr & 0xfffffff8) == RV32I_RTCLOCK_CMP_ADDRESS) 
    {
        rd_val = (uint32_t)(mtimecmp >> ((byte_addr & 0x00000004) ? 32 : 0)); 
    }
    // If a callback registered for memory accesses call it now,
    // unless accessing the memory mapped real time clock CSR register
    else if (p_mem_callback != NULL)
    {
        // Execute callback function
        mem_callback_delay = p_mem_callback(byte_addr, rd_val, type, cycle_count);
    }

    // If no external processing of read, access the internal memory.
    if (mem_callback_delay == RV32I_EXT_MEM_NOT_PROCESSED)
    {
        // Check input is a valid address
        if (byte_addr >= RV32I_INT_MEM_BYTES)
        {
            // Flag as a bus error only if this is not a debug access, as debugger may try
            // to inspect non-valid addresses.
            if (!(type & (int)RV32I_MEM_DBG_MASK))
            {
                process_trap(RV32I_LOAD_ACCESS_FAULT);
                fault = true;
            }
            return 0;
        }

        word = (internal_mem[byte_addr + 0] << 0) |
               (internal_mem[byte_addr + 1] << 8) |
               (internal_mem[byte_addr + 2] << 16) |
               (internal_mem[byte_addr + 3] << 24);

        switch (type & RV32I_MEM_NOT_DBG_MASK)
        {
        case RV32I_MEM_RD_ACCESS_BYTE:
            rd_val = word & 0xff;
            break;
        case RV32I_MEM_RD_ACCESS_HWORD:
            rd_val = word & 0xffff;
            break;
        case RV32I_MEM_RD_ACCESS_INSTR:
        case RV32I_MEM_RD_ACCESS_WORD:
            rd_val = word;
            break;
        default:
            fprintf(stderr, "***ERROR: invalid read access type (%d)\n", type);
            exit(USER_ERROR);
            break;
        }
    }
    else
    {
        cycle_count += mem_callback_delay;
    }

    return rd_val;
}

void rv32i_cpu::write_mem (const uint32_t byte_addr, const uint32_t data, const int type, bool &fault)
{
    int       mem_callback_delay    = 1;
    uint32_t  word = data;

    fault = false;

    // Check alignment
    if (((byte_addr & 0x1) && type != RV32I_MEM_WR_ACCESS_BYTE) ||
        ((byte_addr & 0x3) != 0x00 && (type == RV32I_MEM_WR_ACCESS_WORD || type == RV32I_MEM_WR_ACCESS_INSTR)))
    {
        process_trap((type == RV32I_MEM_WR_ACCESS_INSTR) ? RV32I_IADDR_MISALIGNED : RV32I_ST_AMO_ADDR_MISALIGNED);
        fault = true;
        return;
    }

    if (!use_external_timer && (byte_addr & 0xfffffff8) == RV32I_RTCLOCK_ADDRESS) 
    {
        // At this time, don't write as this is a free running RT clock,
        // but have to handle to avoid attempt to write to internal
        // memory at an out-of-range address 
    }
    // Check if accessing the memory mapped time compare register
    else if (!use_external_timer && (byte_addr & 0xfffffff8) == RV32I_RTCLOCK_CMP_ADDRESS) 
    {
        // Accessing upper word
        if (byte_addr & 0x00000004)
        {
            mtimecmp &= 0xFFFFFFFFULL;
            mtimecmp |= (uint64_t)word << 32;
        }
        // Accessing lower word
        else
        {
            mtimecmp &= 0xFFFFFFFF00000000ULL;
            mtimecmp |= (uint64_t)word;
        }
    }
    // If a callback registered for memory accesses call it now
    else if (p_mem_callback != NULL)
    {
        // Execute callback function
        mem_callback_delay = p_mem_callback(byte_addr, word, type, cycle_count);
    }

    // If no external processing of write, access the internal memory.
    if (mem_callback_delay == RV32I_EXT_MEM_NOT_PROCESSED)
    {

        // Check input is a valid address
        if (byte_addr >= RV32I_INT_MEM_BYTES) 
        {
            process_trap(RV32I_ST_AMO_ACCESS_FAULT);
            fault = true;
            return;
        }


        else
        {
            switch (type)
            {
            case RV32I_MEM_WR_ACCESS_BYTE:
                internal_mem[byte_addr + 0] = word & 0xff;
                break;
            case RV32I_MEM_WR_ACCESS_HWORD:
                internal_mem[byte_addr + 0] = (word >> 0) & 0xff;
                internal_mem[byte_addr + 1] = (word >> 8) & 0xff;
                break;
            case RV32I_MEM_WR_ACCESS_INSTR:
            case RV32I_MEM_WR_ACCESS_WORD:
                internal_mem[byte_addr + 0] = (word >> 0) & 0xff;
                internal_mem[byte_addr + 1] = (word >> 8) & 0xff;
                internal_mem[byte_addr + 2] = (word >> 16) & 0xff;
                internal_mem[byte_addr + 3] = (word >> 24) & 0xff;
                break;
            default:
                fprintf(stderr, "***ERROR: invalid write access type (%d)\n", type);
                exit(USER_ERROR);
                break;
            }
        }
    }
    else
    {
        cycle_count += mem_callback_delay;
    }
}

// ===========================================================
// Instruction methods
//===========================================================

// -----------------------------------------------------------
// Illegal/unimplemented instructions end up here
//
void rv32i_cpu::reserved(const p_rv32i_decode_t d)
{
    int32_t cb_rtn_value = RV32I_UNIMP_NOT_PROCESSED;
    unimp_args_t cb_args;

    RV32I_DISASSEM_SYS_TYPE(cmp_instr ? cmp_instr_code : d->instr , d->entry.instr_name);

    // If an unimplented callback is registered call it now...
    if (p_unimp_callback != NULL)
    {
        // Initialise the callback arguments structure with current state
        std::copy(std::begin(state.hart[curr_hart].x), std::end(state.hart[curr_hart].x), std::begin(cb_args.regs));
        cb_args.pc                  = state.hart[curr_hart].pc;
        cb_args.is_compressed_instr = cmp_instr;
        cb_args.compressed_instr    = cmp_instr_code;

        // Call the user's registered callback function
        cb_rtn_value = p_unimp_callback(d, cb_args);
    }

    // If the callback returned a 'not processed' status when called (or because none was registered),
    // raise an illegal instruction trap.
    if (cb_rtn_value == RV32I_UNIMP_NOT_PROCESSED)
    {
        if (rt_disassem)
            fprintf(dasm_fp, "**ERROR: Illegal/Unsupported instruction\n");

        trap = SIGILL;
    }
    // If a trap was returned by the callback, update the trap value for processing by calling method
    // and increment the PC
    else if (cb_args.trap != 0)
    {
        fprintf(dasm_fp, "**ERROR: extension instruction returned a trap (%d)\n", cb_args.trap);

        trap = cb_args.trap;
    }
    // If no trap, update any new state from the callback
    else
    {
        // If PC updated, update state
        if (cb_args.pc_updated)
        {
            state.hart[curr_hart].pc = cb_args.pc;
        }
        else
        {
            increment_pc();
        }

        // If the registers updated, update state
        if (cb_args.regs_updated)
        {
            std::copy(std::begin(cb_args.regs), std::end(cb_args.regs), std::begin(state.hart[curr_hart].x));

            // Ensure x[0] remains as 0
            state.hart[curr_hart].x[0] = 0;
        }
    }
}

// -----------------------------------------------------------
// Arithmetic immediate instructions
//
void rv32i_cpu::addi(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] + (int32_t)d->imm_i;
    }

    increment_pc();
}

void rv32i_cpu::slti(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((int32_t)state.hart[curr_hart].x[d->rs1] < (int32_t)d->imm_i) ? 1 : 0;
    }

    increment_pc();
}

void rv32i_cpu::sltiu(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((uint32_t)state.hart[curr_hart].x[d->rs1] < (uint32_t)d->imm_i) ? 1 : 0;
    }

    increment_pc();
}

void rv32i_cpu::xori(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] ^ d->imm_i;
    }

    increment_pc();
}

void rv32i_cpu::ori(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] | d->imm_i;
    }

    increment_pc();
}

void rv32i_cpu::andi(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] & d->imm_i;
    }

    increment_pc();
}

void rv32i_cpu::slli(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i & RV32I_MASK_IMM_I_SHAMT);

    if (d->instr & RV32I_SHIFT_RSVD_BIT_MASK)
    {
        process_trap(RV32I_ILLEGAL_INSTR);
    }
    else
    {
        if (d->rd)
        {
            state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] << (d->imm_i & RV32I_MASK_IMM_I_SHAMT);
        }

        increment_pc();
    }
}

void rv32i_cpu::srli(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i & RV32I_MASK_IMM_I_SHAMT);

    if (d->instr & RV32I_SHIFT_RSVD_BIT_MASK)
    {
        process_trap(RV32I_ILLEGAL_INSTR);
    }
    else
    {
        if (d->rd)
        {
            state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] >> (d->imm_i & RV32I_MASK_IMM_I_SHAMT);
        }

        increment_pc();
    }
}

void rv32i_cpu::srai(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i & RV32I_MASK_IMM_I_SHAMT);

    if (d->instr & RV32I_SHIFT_RSVD_BIT_MASK)
    {
        process_trap(RV32I_ILLEGAL_INSTR);
    }
    else
    {
        if (d->rd)
        {
            state.hart[curr_hart].x[d->rd] = ((uint32_t)state.hart[curr_hart].x[d->rs1] >> (d->imm_i & RV32I_MASK_IMM_I_SHAMT)) |
                (((uint32_t)state.hart[curr_hart].x[d->rs1] & MASK_SIGN_BIT32) ? ~(WORD_MASK >> d->imm_i) : 0);
        }

        increment_pc();
    }
}

// -----------------------------------------------------------
// Arithmetic register to register instructions
//
void rv32i_cpu::addr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] + (uint32_t)state.hart[curr_hart].x[d->rs2];
    }

    increment_pc();
}

void rv32i_cpu::subr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] - (uint32_t)state.hart[curr_hart].x[d->rs2];
    }

    increment_pc();
}

void rv32i_cpu::sllr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] << (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT);
    }

    increment_pc();
}

void rv32i_cpu::sltr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((int32_t)state.hart[curr_hart].x[d->rs1] < (int32_t)state.hart[curr_hart].x[d->rs2]) ? 1 : 0;
    }

    increment_pc();
}

void rv32i_cpu::sltur(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((uint32_t)state.hart[curr_hart].x[d->rs1] < (uint32_t)state.hart[curr_hart].x[d->rs2]) ? 1 : 0;
    }

    increment_pc();
}

void rv32i_cpu::xorr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] ^ (uint32_t)state.hart[curr_hart].x[d->rs2];
    }

    increment_pc();
}

void rv32i_cpu::srlr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] >> (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT);
    }

    increment_pc();
}

void rv32i_cpu::srar(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = ((uint32_t)state.hart[curr_hart].x[d->rs1] >> (state.hart[curr_hart].x[d->rs2] & RV32I_MASK_IMM_I_SHAMT)) |
                                        ((state.hart[curr_hart].x[d->rs1] & MASK_SIGN_BIT32) ? ~(WORD_MASK >> state.hart[curr_hart].x[d->rs2]) : 0);
    }

    increment_pc();
}

void rv32i_cpu::orr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] | (uint32_t)state.hart[curr_hart].x[d->rs2];
    }

    increment_pc();
}

void rv32i_cpu::andr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_R_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->rs2);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].x[d->rs1] & (uint32_t)state.hart[curr_hart].x[d->rs2];
    }

    increment_pc();
}

// -----------------------------------------------------------
// Upper immediate instructions
//
void rv32i_cpu::auipc(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_U_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_u);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = d->imm_u + (uint32_t)state.hart[curr_hart].pc;
    }

    increment_pc();
}

void rv32i_cpu::lui(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_U_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->imm_u);

    if (d->rd)
    {
        state.hart[curr_hart].x[d->rd] = d->imm_u;
    }

    increment_pc();
}

// -----------------------------------------------------------
// Load/store instructions
//
void rv32i_cpu::lb(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IL_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_BYTE, access_fault);

        if (!access_fault)
        {
            rd_val = SIGN_EXT8(rd_val);
            state.hart[curr_hart].x[d->rd] = rd_val;
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32i_cpu::lh(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IL_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_HWORD, access_fault);

        if (!access_fault)
        {
            rd_val = SIGN_EXT16(rd_val);
            state.hart[curr_hart].x[d->rd] = rd_val;
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32i_cpu::lw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IL_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_WORD, access_fault);

        if (!access_fault)
        {
            state.hart[curr_hart].x[d->rd] = rd_val;
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32i_cpu::lbu(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IL_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_BYTE, access_fault);

        if (!access_fault)
        {
            state.hart[curr_hart].x[d->rd] = rd_val;
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32i_cpu::lhu(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_IL_TYPE(d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i;

        uint32_t rd_val = read_mem(access_addr, MEM_RD_ACCESS_HWORD, access_fault);

        if (!access_fault)
        {
            state.hart[curr_hart].x[d->rd] = rd_val;
            cycle_count += RV32I_LOAD_EXTRA_CYCLES;
        }
    }

    if (!access_fault)
    {
        increment_pc();
    }
}

void rv32i_cpu::sb(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_S_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_s);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_s;

        write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] & BYTE_MASK, MEM_WR_ACCESS_BYTE, access_fault);
    }

    if (!access_fault)
    {
        cycle_count += RV32I_STORE_EXTRA_CYCLES;
        increment_pc();
    }
}

void rv32i_cpu::sh(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_S_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_s);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_s;

        write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2] & HWORD_MASK, MEM_WR_ACCESS_HWORD, access_fault);
    }

    if (!access_fault)
    {
        increment_pc();
        cycle_count += RV32I_STORE_EXTRA_CYCLES;  // openPCIE: was LOAD
    }
}

void rv32i_cpu::sw(const p_rv32i_decode_t d)
{
    bool access_fault = false;

    RV32I_DISASSEM_S_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_s);

    if (!disassemble)
    {
        access_addr = (uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_s;

        write_mem(access_addr, (uint32_t)state.hart[curr_hart].x[d->rs2], MEM_WR_ACCESS_WORD, access_fault);
    }

    if (!access_fault)
    {
        increment_pc();
        cycle_count += RV32I_STORE_EXTRA_CYCLES;  // openPCIE: was LOAD
    }
}

// -----------------------------------------------------------
// Branch instructions
//
void rv32i_cpu::beq(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (uint32_t)state.hart[curr_hart].x[d->rs1] == (uint32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::bne(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (uint32_t)state.hart[curr_hart].x[d->rs1] != (uint32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::blt(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (int32_t)state.hart[curr_hart].x[d->rs1] < (int32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::bge(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (int32_t)state.hart[curr_hart].x[d->rs1] >= (int32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::bltu(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (uint32_t)state.hart[curr_hart].x[d->rs1] < (uint32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    };
}

void rv32i_cpu::bgeu(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_B_TYPE(d->instr, d->entry.instr_name, d->rs1, d->rs2, d->imm_b);

    access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_b;

    if (!disassemble && (uint32_t)state.hart[curr_hart].x[d->rs1] >= (uint32_t)state.hart[curr_hart].x[d->rs2])
    {
        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_BRANCH_TAKEN_EXTRA_CYCLES;
            RV32I_DISASSEM_PC_JUMP;
        }
    }
    else
    {
        increment_pc();
    }
}

// -----------------------------------------------------------
// Jump and link instructions
//
void rv32i_cpu::jal(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_J_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->imm_j);
    RV32I_DISASSEM_PC_JUMP;

    if (!disassemble)
    {

        access_addr = (uint32_t)state.hart[curr_hart].pc + d->imm_j;

        // Check for misalignment on target address
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            if (d->rd)
            {
                state.hart[curr_hart].x[d->rd] = (uint32_t)state.hart[curr_hart].pc + (cmp_instr ? 2 : 4);
            }

            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_JUMP_INSTR_EXTRA_CYCLES;
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::jalr(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_I_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name, d->rd, d->rs1, d->imm_i);
    RV32I_DISASSEM_PC_JUMP;

    if (!disassemble)
    {
        uint32_t next_pc = (uint32_t)state.hart[curr_hart].pc + (cmp_instr ? 2 : 4);

        access_addr = ((uint32_t)state.hart[curr_hart].x[d->rs1] + d->imm_i) & 0xfffffffe;  // Clear bottom bit

        // Check for address misalignment
        if (access_addr & RV32_IADDR_ALIGN_MASK)
        {
            process_trap(RV32I_IADDR_MISALIGNED);
        }
        else
        {
            state.hart[curr_hart].pc = access_addr;
            cycle_count += RV32I_JUMP_INSTR_EXTRA_CYCLES;

            if (d->rd)
            {
                state.hart[curr_hart].x[d->rd] = next_pc;
            }
        }
    }
    else
    {
        increment_pc();
    }

}

// -----------------------------------------------------------
// Fence instruction
//
// Note that in this ISS, all instructions are completed
// before executing the next, so no out-of-order memory
// accesses can occur between harts or external models. Thus
// FENCE/FENCE.I route here and does nothing.
//
void rv32i_cpu::fence(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_IF_TYPE(d->instr, d->entry.instr_name, d->imm_i);

    increment_pc();
}

// -----------------------------------------------------------
// System instructions
//
void rv32i_cpu::ecall(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_SYS_TYPE(d->instr, d->entry.instr_name);
    RV32I_DISASSEM_PC_JUMP;

    if (!disassemble)
    {
        if (halt_ecall)
        {
            trap = SIGTERM;
        }
        else
        {
            process_trap(RV32I_ENV_CALL_M_MODE);
        }
    }
    else
    {
        increment_pc();
    }
}

void rv32i_cpu::ebreak(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_SYS_TYPE(cmp_instr ? cmp_instr_code : d->instr, d->entry.instr_name);
    RV32I_DISASSEM_PC_JUMP;

    if (!disassemble)
    {
        if (halt_ebreak)
        {
            trap = SIGTRAP;
        }
        else
        {
            process_trap(RV32I_BREAK_POINT);
        }
    }
    else
    {
        increment_pc();
        trap = halt_ebreak ? SIGTRAP : trap;
    }
}
