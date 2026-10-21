//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 12th July 2021
//
// Contains the instruction execution methods for the
// rv32csr_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32csr_cpu).
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

#include "rv32csr_cpu.h"

class rv32csr_cpu;

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32csr_cpu::rv32csr_cpu(FILE* dbgfp) : RV32_ZICSR_INHERITANCE_CLASS(dbgfp)
{
    int idx = 0;

    // No callback functions registered by default
    p_int_callback = NULL;

    // Initialise interrupt wakeup time to time 0
    interrupt_wakeup_time = 0;

    // Update decode table with extended instructions

    // Tertiary table for ECALL, EBREAK and MRET instructions (decoded on funct12 = imm_i)
    // Skip ecall and ebreak entries, populated in the base class, and add mret
    idx += 2;
    e_tbl[idx++]   = {false, mret_str,     RV32I_INSTR_FMT_R,   (pFunc_t)&rv32csr_cpu::mret };     /*MRET*/
    
    // Secondary table for system instructions (decoded on funct3)
    idx = 1;                                                                                       // Skip updating to e_tbl, as done in base class
    sys_tbl[idx++] = {false, csrrw_str,    RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrw };
    sys_tbl[idx++] = {false, csrrs_str,    RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrs };
    sys_tbl[idx++] = {false, csrrc_str,    RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrc };
    sys_tbl[idx++] = {false, reserved_str, RV32I_INSTR_ILLEGAL, (pFunc_t)&rv32csr_cpu::reserved };
    sys_tbl[idx++] = {false, csrrwi_str,   RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrwi };
    sys_tbl[idx++] = {false, csrrsi_str,   RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrsi };
    sys_tbl[idx++] = {false, csrrci_str,   RV32I_INSTR_FMT_I,   (pFunc_t)&rv32csr_cpu::csrrci };

    // Set values of MSTATUS and MISA CSRs
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA] = RV32CSR_MXLEN32 | RV32CSR_EXT_I;
#ifdef RV32E_EXTENSION
    state.hart[curr_hart].csr[RV32CSR_ADDR_MISA] |= RV32CSR_EXT_E;
#endif
    state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] = RV32CSR_MPP_BITMASK;                                   // In this model, MPP is always machine level

}

// -----------------------------------------------------------
// Reset
// -----------------------------------------------------------

void rv32csr_cpu::reset()
{
    RV32_ZICSR_INHERITANCE_CLASS::reset();

    state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] = ~(RV32CSR_MIE_BITMASK | RV32CSR_MPRV_BITMASK);

    state.hart[curr_hart].csr[RV32CSR_ADDR_MCAUSE]  = 0;

}

// -----------------------------------------------------------
// Trap handling
// -----------------------------------------------------------

void rv32csr_cpu::process_trap(int trap_type)
{
    uint32_t offset = 0;

    state.hart[curr_hart].csr[RV32CSR_ADDR_MEPC]   = (uint32_t)state.hart[curr_hart].pc;
    state.hart[curr_hart].csr[RV32CSR_ADDR_MCAUSE] = trap_type;

    // Vol2: 3.1.17
    if (trap_type == RV32I_IADDR_MISALIGNED || trap_type == RV32I_LADDR_MISALIGNED ||
        trap_type == RV32I_ST_AMO_ADDR_MISALIGNED)
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_MTVAL] = get_last_access_addr();
    }
    else if (trap_type == RV32I_ILLEGAL_INSTR)
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_MTVAL] = get_curr_instruction();
    }
    else
    {
        state.hart[curr_hart].csr[RV32CSR_ADDR_MTVAL] = 0;
    }

    // If this is an asynchronous interrupt and MTVEC is in vectored mode,
    // calculate the offset for the trap.
    if (trap_type & RV32CSR_MCAUSE_INT_MASK)
    {
        RV32I_DISASSEM_INT_PC_JUMP;

        if ((state.hart[curr_hart].csr[RV32CSR_ADDR_MTVEC] & RV32CSR_MTVEC_MODE_MASK) == RV32CSR_MTVEC_MODE_VECTORED)
        {
            offset = 4 * (trap_type & ~RV32CSR_MCAUSE_INT_MASK);
        }
    }

    state.hart[curr_hart].pc = (state.hart[curr_hart].csr[RV32CSR_ADDR_MTVEC] & ~RV32CSR_MTVEC_MODE_MASK) + offset;
    cycle_count += RV32I_TRAP_EXTRA_CYCLES;
}

int rv32csr_cpu::process_interrupts()
{
    bool fault;

    // Firstly update pending statuses in the MIP CSR register

    // If an interrupt callback registered, call it if current cycle count
    // at, or beyond, scheduled wakeup count.
    if (p_int_callback != NULL && clk_cycles() >=  (uint32_t)interrupt_wakeup_time)
    {
        // Get interrupt vector. IRQ[2] is for software interrupts, 
        // IRQ[1] is for external timer, IRQ[0] is for external interrupts.

        uint32_t irq = (*p_int_callback)(clk_cycles(), &interrupt_wakeup_time);

        // Update the MIP CSR MEIP bit with interrupt status
        if (irq & 0x1)
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] |= RV32CSR_MEIP_BITMASK;
        }
        else
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] &= ~RV32CSR_MEIP_BITMASK;
        }

        // If using an external interrupt timer, inspect IRQ bit 1
        if (use_external_timer)
        {
            if (irq & 0x2)
            {
                state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] |= RV32CSR_MTIP_BITMASK;
            }
            else
            {
                state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] &= ~RV32CSR_MTIP_BITMASK;
            }
        }

        // Software IRQ in bit 2
        if (irq & 0x4)
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] |= RV32CSR_MSIP_BITMASK;
        }
        else
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] &= ~RV32CSR_MSIP_BITMASK;
        }
    }

    // If not using external timer, read internal timer model compare register and check against current time
    if (!use_external_timer)
    {
        // Check timer compare
        // openPCIE: read_mem() charges a memory cycle per read, i.e. 2 cycles
        // on every instruction; this is a register check, not an access
        rv32i_time_t cycles = cycle_count;
        uint64_t mtimcmp = (uint64_t)read_mem(RV32I_RTCLOCK_CMP_ADDRESS, MEM_RD_ACCESS_WORD, fault) |
                          ((uint64_t)read_mem(RV32I_RTCLOCK_CMP_ADDRESS + 4, MEM_RD_ACCESS_WORD, fault) << 32);
        cycle_count = cycles;
        
        // If timer greater than compare register, set the pending bit, else clear it
        if (real_time_us() >= mtimcmp)
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] |= RV32CSR_MTIP_BITMASK;
        }
        else
        {
            state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] &= ~RV32CSR_MTIP_BITMASK;
        }
    }

    // Raise interrupts, depending on enable statuses

    // Check for global interrupt enable bit in mstatus before processing pending interrupts
    if (state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] & RV32CSR_MIE_BITMASK)
    {
        // If external pending and enabled...
        if ((state.hart[curr_hart].csr[RV32CSR_ADDR_MIE] & RV32CSR_MEIE_BITMASK) && (state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] & RV32CSR_MEIP_BITMASK))
        {
            // Set MSTATUS MPIE and clear MIE
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] |= RV32CSR_MPIE_BITMASK;
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] &= ~RV32CSR_MIE_BITMASK;

            process_trap(RV32CSR_INT_MEXT_CAUSE);
            return 1;
        }
        // Else if timer pending and enabled...
        else if ((state.hart[curr_hart].csr[RV32CSR_ADDR_MIE] & RV32CSR_MTIE_BITMASK) && (state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] & RV32CSR_MTIP_BITMASK))
        {
            // Set MSTATUS MPIE and clear MIE
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] |= RV32CSR_MPIE_BITMASK;
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] &= ~RV32CSR_MIE_BITMASK;

            process_trap(RV32CSR_INT_MTIM_CAUSE);
            return 1;
        }
        // else if software enabled and pending...
        else if ((state.hart[curr_hart].csr[RV32CSR_ADDR_MIE] & RV32CSR_MSIE_BITMASK) && (state.hart[curr_hart].csr[RV32CSR_ADDR_MIP] & RV32CSR_MSIP_BITMASK))
        {
            // Set MSTATUS MPIE and clear MIE
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] |= RV32CSR_MPIE_BITMASK;
            state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] &= ~RV32CSR_MIE_BITMASK;

            process_trap(RV32CSR_INT_MSW_CAUSE);
            return 1;
        }
    }

    return 0;
}

// -----------------------------------------------------------
// Update cycle and instruction counts
// -----------------------------------------------------------
void rv32csr_cpu::update_csr_counts(void)
{
    state.hart[curr_hart].csr[RV32CSR_ADDR_MCYCLE]    = clk_cycles() & 0xffffffff;
    state.hart[curr_hart].csr[RV32CSR_ADDR_MCYCLEH]   = (clk_cycles() >> 32) & 0xffffffff;
    state.hart[curr_hart].csr[RV32CSR_ADDR_MINSTRET]  = inst_retired() & 0xffffffff;
    state.hart[curr_hart].csr[RV32CSR_ADDR_MINSTRETH] = (inst_retired() >> 32) & 0xffffffff;

    // Mirror the  counts in the user space registers
    state.hart[curr_hart].csr[RV32CSR_ADDR_CYCLE]     = state.hart[curr_hart].csr[RV32CSR_ADDR_MCYCLE];
    state.hart[curr_hart].csr[RV32CSR_ADDR_CYCLEH]    = state.hart[curr_hart].csr[RV32CSR_ADDR_MCYCLEH];
    state.hart[curr_hart].csr[RV32CSR_ADDR_INSTRET]   = state.hart[curr_hart].csr[RV32CSR_ADDR_MINSTRET];
    state.hart[curr_hart].csr[RV32CSR_ADDR_INSTRETH]  = state.hart[curr_hart].csr[RV32CSR_ADDR_MINSTRETH];
}

// -----------------------------------------------------------
// CSR access methods
// -----------------------------------------------------------

uint32_t rv32csr_cpu::access_csr(const unsigned funct3, const uint32_t addr, const uint32_t rd, const uint32_t rs1_uimm)
{
    uint32_t value;
    uint32_t error  = 0;
    uint32_t prev_rd_value = 0;

    // Validate access
    uint32_t priv_reqd_level = (addr & RV32CSR_PRIV_MASK) >> RV32CSR_RIV_START_BIT;
    bool     csr_rnw         = ((addr & RV32CSR_RW_MASK) == RV32CSR_RW_MASK);          // All RW bits set == readonly

    bool     unimplemented = false;
    uint32_t wr_mask;

    // Check sufficient privilege level and register implemented
    if (state.priv_lvl < priv_reqd_level)
    {
        error = 1;
    }
    else
    {
        // Fetch write mask (0 for read only reg), or flag as unimplemented CSR register
        wr_mask = csr_wr_mask(addr, unimplemented);

        // Read CSR registers
        if (rd && !unimplemented)
        {
            prev_rd_value = (uint32_t)state.hart[curr_hart].x[rd];

            // Take this opportunity to update the cycle count and instructions retired registers
            update_csr_counts();

            state.hart[curr_hart].x[rd] = state.hart[curr_hart].csr[addr & 0xfff];
        }

        // Write to CSR registers
        if (rs1_uimm || RV32CSR_OP_RW(funct3))
        {
            // Accessing a writable register
            if (!csr_rnw && !unimplemented)
            {
                if (RV32CSR_IMM(funct3))
                {
                    value = rs1_uimm & 0xfff;
                }
                else
                {
                    value = (rd != rs1_uimm) ? (uint32_t)state.hart[curr_hart].x[rs1_uimm] : prev_rd_value;
                }

                if (RV32CSR_OP_RW(funct3))
                {
                    state.hart[curr_hart].csr[addr & 0xfff] = (state.hart[curr_hart].csr[addr & 0xfff] & ~((uint64_t)wr_mask)) | (value & wr_mask);
                }
                else if (RV32CSR_OP_RS(funct3))
                {
                    state.hart[curr_hart].csr[addr & 0xfff] |= (value & wr_mask);
                }
                else if (RV32CSR_OP_RC(funct3))
                {
                    state.hart[curr_hart].csr[addr & 0xfff] &= (uint32_t)~(value & wr_mask);
                }
            }
            // Attempted to write to a read only or unimplemented CSR register
            else
            {
                error = 1;
            }
        }
    }

    if (error)
    {
        process_trap(RV32I_ILLEGAL_INSTR);
    }

    return error;
}

// Return write mask (bit set equals writable) for given CSR
uint32_t rv32csr_cpu::csr_wr_mask(const uint32_t addr, bool &unimp)
{
    uint32_t mask = 0;

    unimp = false;

    switch (addr)
    {
        // Read only registers
        case RV32CSR_ADDR_MVENDORID:
        case RV32CSR_ADDR_MARCHID:
        case RV32CSR_ADDR_MIMPID:
        case RV32CSR_ADDR_MHARTID:

            break;
        // Trap setup
        case RV32CSR_ADDR_MSTATUS:
            mask = RV32CSR_MSTATUS_WR_MASK;
            break;
        case RV32CSR_ADDR_MISA:
            mask = RV32CSR_MISA_WR_MASK;
            break;
        case RV32CSR_ADDR_MIE:
            mask = RV32CSR_MIE_WR_MASK;
            break;
        case RV32CSR_ADDR_MTVEC:
            mask = RV32CSR_MTVEC_WR_MASK;
            break;
        case RV32CSR_ADDR_MCOUNTEREN:
            mask = RV32CSR_MCOUNTEREN_WR_MASK;
            break;
        case RV32CSR_ADDR_MSCRATCH:
            mask = RV32CSR_MSCRATCH_WR_MASK;
            break;
        case RV32CSR_ADDR_MEPC:
            mask = RV32CSR_MEPC_WR_MASK;
            break;
        case RV32CSR_ADDR_MCAUSE:
            mask = RV32CSR_MCAUSE_WR_MASK;
            break;
        case RV32CSR_ADDR_MTVAL:
            mask = RV32CSR_MTVAL_WR_MASK;
            break;
        case RV32CSR_ADDR_MIP:
            mask = RV32CSR_MIP_WR_MASK;
            break;
        case RV32CSR_ADDR_MCYCLE:
        case RV32CSR_ADDR_MCYCLEH:
            mask = RV32CSR_MCYCLE_WR_MASK;
            break;
        case RV32CSR_ADDR_CYCLE:
        case RV32CSR_ADDR_CYCLEH:
            mask = RV32CSR_CYCLE_WR_MASK;
            break;
        case RV32CSR_ADDR_MINSTRET:
        case RV32CSR_ADDR_MINSTRETH:
            mask = RV32CSR_MINSTRET_WR_MASK;
            break;
        case RV32CSR_ADDR_INSTRET:
        case RV32CSR_ADDR_INSTRETH:
            mask = RV32CSR_INSTRET_WR_MASK;
            break;
        case RV32CSR_ADDR_MCOUNTINHIBIT:
            mask = RV32CSR_MCOUNTINHIBIT_WR_MASK;
            break;
        default:
            // First check the ranges of the multiple counters RV32
            if ((addr >= RV32CSR_ADDR_MHPMCOUNTER3  && addr <= RV32CSR_ADDR_MHPMCOUNTER31) ||
                (addr >= RV32CSR_ADDR_MHPMCOUNTER3H && addr <= RV32CSR_ADDR_MHPMCOUNTER31H))
            {
                mask = RV32CSR_MHPMCOUNTERX_WR_MASK;
            }
            else if (addr >= RV32CSR_ADDR_MHPMEVENT3  && addr <= RV32CSR_ADDR_MHPMEVENT31)
            {
                mask = RV32CSR_MHPMEVENTX_WR_MASK;
            }
            else if (addr >= RV32CSR_ADDR_PMPCFG0 && addr <= RV32CSR_ADDR_PMPADDR15)
            {
                mask = RV32CSR_PMPX_WR_MASK;
            }
            else
            {
                unimp = true;
            }
            break;
    }

    return  mask;
}

// -----------------------------------------------------------
// Zicsr instructions
//
void rv32csr_cpu::csrrw(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSR_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

void rv32csr_cpu::csrrs(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSR_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

void rv32csr_cpu::csrrc(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSR_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

void rv32csr_cpu::csrrwi(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSRI_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

void rv32csr_cpu::csrrsi(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSRI_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

void rv32csr_cpu::csrrci(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_ICSRI_TYPE(d->instr, d->entry.instr_name, d->rd, d->imm_i & BIT12_MASK, d->rs1);

    if (disassemble || !access_csr(d->funct3, d->imm_i & BIT12_MASK, d->rd, d->rs1))
    {
        increment_pc();
    }
}

// -----------------------------------------------------------
// System instructions
//

void rv32csr_cpu::mret(const p_rv32i_decode_t d)
{
    RV32I_DISASSEM_SYS_TYPE(d->instr, d->entry.instr_name);
    RV32I_DISASSEM_PC_JUMP;

    if (!disassemble)
    {
        // Set MSTATUS MIE to MPIE. Note: MPP is not updated to user mode as this is not yet supported.
        state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] &= ~RV32CSR_MIE_BITMASK;
        state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] |= (state.hart[curr_hart].csr[RV32CSR_ADDR_MSTATUS] & RV32CSR_MPIE_BITMASK) ? RV32CSR_MIE_BITMASK : 0;

        state.hart[curr_hart].pc = state.hart[curr_hart].csr[RV32CSR_ADDR_MEPC];
    }
    else
    {
        increment_pc();
    }
}
