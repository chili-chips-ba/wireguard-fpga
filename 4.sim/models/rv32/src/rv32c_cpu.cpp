//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 6th September 2021
//
// Contains methods for the rv32c_cpu class
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

#include "rv32c_cpu.h"

// ----------------------------------------------------
// Overloaded method to process 16 bit instructions
// ----------------------------------------------------

uint32_t rv32c_cpu::fetch_instruction()
{
    uint32_t instr;

    // 16 bit aligned PC...
    if (state.hart[curr_hart].pc & 0x2)
    {
        // Fetch word, with PC aligned to 32 bits, and extract upper half word
        state.hart[curr_hart].pc -= 2;
        uint32_t instr_hword      = RV32_C_INHERITANCE_CLASS::fetch_instruction() >> 16;
        state.hart[curr_hart].pc += 2;   

        // If a compressed instruction do a compressed instruction decode from 
        // the 16 held instruction bits
        if ((instr_hword & 0x3) != RV32I_MASK_32BIT_INSTR)
        {
            cmp_instr              = true;

            // Convert to a 32 bit instruction
            instr = compressed_decode(instr_hword);
        }
        // 32 bit instruction
        else
        {
            cmp_instr               = false;

            // Fetch next aligned 32 bits
            state.hart[curr_hart].pc += 2;
            uint32_t instr_next_hword = RV32_C_INHERITANCE_CLASS::fetch_instruction() & 0xffff;
            state.hart[curr_hart].pc -= 2;

            // 32 bit instruction is the upper half word bits, plus lower 16 bits of next instruction word
            instr                  = instr_hword | (instr_next_hword << 16);
        }
    }
    // 32 bit aligned PC
    else
    {
        // Fetch 32 bits of instruction
        instr = RV32_C_INHERITANCE_CLASS::fetch_instruction();

        // If a compressed instruction, do a compressed instruction decode
        if ((instr & 0x3) != RV32I_MASK_32BIT_INSTR)
        {
            cmp_instr              = true;
            instr                 &= 0xffff;

            // Convert to a 32 bit instruction
            instr = compressed_decode(instr);
        }
        // A 32 bit instruction
        else
        {
            cmp_instr              = false;
        }
    }

    return instr;
};

// ----------------------------------------------------
// Compressed instrction decode conversion method
// ----------------------------------------------------

uint32_t rv32c_cpu::compressed_decode(const opcode_t instr)
{
    uint32_t imm;

    uint32_t rtn_instr = instr;

    uint32_t opcode    = instr         & 0x03;
    uint32_t funct3    = (instr >> 13) & 0x07;
    uint32_t funct4    = (instr >> 12) & 0x01;


    cmp_instr_code     = instr;

    // Check for defined illegal compressed instruction ([1] sec 16.5)
    if (instr == rv32c_illegal_instr)
    {
        rtn_instr = 0;
    }
    // Quadrant 0 instructions
    else if (opcode == 0)
    {
        uint32_t rdtick   = ((instr >> 2) & 0x7) | 0x8;
        uint32_t rs1tick  = ((instr >> 7) & 0x7) | 0x8;
        uint32_t rs2tick  = ((instr >> 2) & 0x7) | 0x8;

        switch (funct3)
        {
        // C.ADDI4SPN => ADDI rd, sp, imm*4
        case 0:
            // Immediate = imm[5:4|9:6|2|3]
            imm = (((instr >> 6)  & 0x1) << 2) |
                  (((instr >> 5)  & 0x1) << 3) |
                  (((instr >> 11) & 0x3) << 4) |
                  (((instr >> 7)  & 0xf) << 6);

            // sp = x2, funct3 = 0 rd = c.rd + 8
            rtn_instr = addi_opcode | (rdtick << 7) | (sp_reg << 15) | (imm << 20);
            break;

        // C.FLD => FLD rd, imm*8(rs1+8)
        case 1:
            imm = (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  5) & 0x3) << 6);

            rtn_instr = fld_opcode | (fwidth_dbl << 12) | (rdtick << 7) | (rs1tick << 15) | (imm << 20);
            break;

        // C.LW
        case 2:
            imm = (((instr >>  6) & 0x1) << 2) |
                  (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  5) & 0x1) << 6);

            rtn_instr = lw_opcode | (width_word << 12) | (rdtick << 7) | (rs1tick << 15) | (imm << 20);
            break;

        // C.FLW => FLW rd, imm*4(rs1+8)
        case 3:
            imm = (((instr >>  6) & 0x1) << 2) |
                  (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  5) & 0x1) << 6);

            rtn_instr = flw_opcode | (fwidth_sgl << 12) | (rdtick << 7) | (rs1tick << 15) | (imm << 20);
            break;

        // Reserved
        case 4:
            rtn_instr = 0;
            break;

        // C.FSD
        case 5:
            imm = (((instr >> 6)  & 0x1) << 2) |
                  (((instr >> 10) & 0x7) << 3) |
                  (((instr >> 5)  & 0x1) << 6);

            rtn_instr = fsd_opcode | (fwidth_dbl << 12) | (rs1tick << 15) | (rs2tick << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);
            break;
 
        // C.SW
        case 6:
            imm = (((instr >>  6) & 0x1) << 2) |
                  (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  5) & 0x1) << 6);

            rtn_instr = sw_opcode | (width_word << 12) | (rs1tick << 15) | (rs2tick << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);

            break;

        // C.FSW
        case 7:
            
            imm = (((instr >>  6) & 0x1) << 2) |
                  (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  5) & 0x1) << 6);

            rtn_instr = fsw_opcode | (fwidth_sgl << 12) | (rs1tick << 15) | (rs2tick << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);
            break;
        }
    }
    // Quadrant 1 instructions
    else if (opcode == 1)
    {
        uint32_t rdtick   = ((instr >> 7) & 0x7) | 0x8;
        uint32_t rs1tick  = ((instr >> 7) & 0x7) | 0x8;
        uint32_t rs2tick  = ((instr >> 2) & 0x7) | 0x8;

        uint32_t rs1q1 = (instr >> 7) & 0x1f;
        uint32_t rdq1  = (instr >> 7) & 0x1f;

        switch (funct3)
        {
        // C.ADDI => ADDI rd, rd, imm
        case 0:
            imm = (((instr >>  2) & 0x1f) << 0)  |
                  (((instr >> 12) & 0x01) << 5) ;
            imm = SIGN_EXT6(imm);

            rtn_instr = addi_opcode | (rdq1 << 7) | (rs1q1 << 15) | (imm << 20);
            break;

        // C.JAL => JAL ra, rs1, 0
        case 1:
            imm = (((instr >>  3) & 0x07) <<  1) |
                  (((instr >> 11) & 0x01) <<  4) |
                  (((instr >>  2) & 0x01) <<  5) |
                  (((instr >>  7) & 0x01) <<  6) |
                  (((instr >>  6) & 0x01) <<  7) |
                  (((instr >>  9) & 0x03) <<  8) |
                  (((instr >>  8) & 0x01) << 10) |
                  (((instr >> 12) & 0x01) << 11);
            imm = SIGN_EXT12(imm);

            rtn_instr = j_opcode | (0x1 << 7) | (((imm >> 1) & 0x3ff) << 21) | (((imm >> 11) & 0x1) << 20) | (((imm >> 12) & 0xff) << 12) | (((imm >> 20) & 0x1) << 31);
            break;

        // LI => ADDI rd, x0, imm
        case 2:
            imm = (((instr >>  2) & 0x1f) << 0)  |
                  (((instr >> 12) & 0x01) << 5) ;
            imm = SIGN_EXT6(imm);

            rtn_instr = addi_opcode | (rdq1 << 7) | (0 << 15) | (imm << 20);
            break;

        // LUI/ADDI16SP
        case 3:
            // ADDI16SP => ADDI x2, x2, imm
            if (rdq1 == 2)
            {
                imm = (((instr >>  6) & 0x01) << 4) |
                      (((instr >>  2) & 0x01) << 5) |
                      (((instr >>  5) & 0x01) << 6) |
                      (((instr >>  3) & 0x03) << 7) |
                      (((instr >> 12) & 0x01) << 9);
                imm = SIGN_EXT10(imm);

                rtn_instr = addi_opcode | (rdq1 << 7) | (rs1q1 << 15) | (imm << 20);
            }
            // LUI => LUI rd, imm
            else
            {
                imm = (((instr >> 2) & 0x1f) << 12) | (((instr >> 12) & 0x1) << 17);
                imm = SIGN_EXT18(imm);

                rtn_instr = lui_opcode | (rdq1 << 7) | imm;
            }
            break;

        // MISC-ALU
        case 4:
        {
            uint32_t sub_select_rs1 = (instr >> 10) & 0x03;
            uint32_t sub_select_rs2 = (instr >> 5) & 0x03;

            // RV64/RV128 only or reserved
            if (funct4 && sub_select_rs1 == 3)
            {
                rtn_instr = 0;
            }
            else
            {
                // C.SRLI
                if (sub_select_rs1 == 0)
                {
                    imm = (((instr >> 2)  & 0x1f) << 0) |
                          (((instr >> 12) & 0x01) << 5);

                    rtn_instr = addi_opcode | (rdtick << 7) | (rs1tick << 15) | (0x05 << 12) | (imm << 20);
                }
                // C.SRAI
                else if (sub_select_rs1 == 1)
                {
                    imm = (((instr >> 2)  & 0x1f) << 0) |
                          (((instr >> 12) & 0x01) << 5);

                    rtn_instr = addi_opcode | (rdtick << 7) | (rs1tick << 15) | (0x05 << 12) | (imm << 20) | (1 << 30);
                }
                // C.ANDI
                else if (sub_select_rs1 == 2)
                {
                    imm = (((instr >> 2) & 0x1f) << 0) |
                          (((instr >> 12) & 0x01) << 5);
                    imm = SIGN_EXT6(imm);

                    rtn_instr = addi_opcode | (rdtick << 7) | (rs1tick << 15) | (0x07 << 12) | (imm << 20);
                }
                else
                {
                    // C.SUB
                    if (sub_select_rs2 == 0)
                    {
                        rtn_instr = add_opcode | (rdtick << 7) | (rs1tick << 15) | (rs2tick << 20) | (0 << 12) | (1 << 30);
                    }
                    // C.XOR
                    else if (sub_select_rs2 == 1)
                    {
                        rtn_instr = add_opcode | (rdtick << 7) | (rs1tick << 15) | (rs2tick << 20) | (4 << 12);
                    }
                    // C.OR
                    else if (sub_select_rs2 == 2)
                    {
                        rtn_instr = add_opcode | (rdtick << 7) | (rs1tick << 15) | (rs2tick << 20) | (6 << 12);
                    }
                    // C.AND
                    else
                    {
                        rtn_instr = add_opcode | (rdtick << 7) | (rs1tick << 15) | (rs2tick << 20) | (7 << 12);
                    }
                }
            }
            break;
        }

        // C.J => JAL ra, imm
        case 5:
            imm = (((instr >>  3) & 0x07) <<  1) |
                  (((instr >> 11) & 0x01) <<  4) |
                  (((instr >>  2) & 0x01) <<  5) |
                  (((instr >>  7) & 0x01) <<  6) |
                  (((instr >>  6) & 0x01) <<  7) |
                  (((instr >>  9) & 0x03) <<  8) |
                  (((instr >>  8) & 0x01) << 10) |
                  (((instr >> 12) & 0x01) << 11);
            imm = SIGN_EXT12(imm);

            rtn_instr = j_opcode | (0x0 << 7) | (((imm >> 1) & 0x3ff) << 21) | (((imm >> 11) & 0x1) << 20) | (((imm >> 12) & 0xff) << 12) | (((imm >> 20) & 0x1) << 31);
            break;

        // C.BEQZ
        case 6:
            imm = (((instr >>  3) & 0x03) << 1) |
                  (((instr >> 10) & 0x03) << 3) |
                  (((instr >>  2) & 0x01) << 5) |
                  (((instr >>  5) & 0x03) << 6) |
                  (((instr >> 12) & 0x01) << 8);
            imm = SIGN_EXT9(imm);

            rtn_instr = branch_opcode | (rs1tick << 15) | (0 << 20) | (0 << 12) | (((imm >> 1) & 0x0f) << 8) | (((imm >> 5) & 0x3f) << 25) | (((imm >> 11) & 0x01) << 7) | (((imm >> 12) & 0x01) << 31);
            break;

        // C.BNEZ
        case 7:
            imm = (((instr >>  3) & 0x03) << 1) |
                  (((instr >> 10) & 0x03) << 3) |
                  (((instr >>  2) & 0x01) << 5) |
                  (((instr >>  5) & 0x03) << 6) |
                  (((instr >> 12) & 0x01) << 8);
            imm = SIGN_EXT9(imm);

            rtn_instr = branch_opcode | (rs1tick << 15) | (0 << 20) | (1 << 12) | (((imm >> 1) & 0x0f) << 8) | (((imm >> 5) & 0x3f) << 25) | (((imm >> 11) & 0x01) << 7) | (((imm >> 12) & 0x01) << 31);
            break;
        }
    }
    // Quadrant 2 instructions
    else if (opcode == 2)
    {
        uint32_t rs1q2 = (instr >> 7) & 0x1f;
        uint32_t rs2q2 = (instr >> 2) & 0x1f;
        uint32_t rdq2  = (instr >> 7) & 0x1f;

        switch (funct3)
        {
        // C.SLLI => slli rd, rd, imm
        case 0:
            imm = (((instr >> 2)  & 0x1f) << 0) |
                  (((instr >> 12) & 0x01) << 5);

            rtn_instr = addi_opcode | (rdq2 << 7) | (rs1q2 << 15) | (1 << 12) | (imm << 20);
            break;

        // C.FLDSP => fld rd, imm*8(x2)
        case 1:
            imm = (((instr >>  5) & 0x03) << 3) |
                  (((instr >> 12) & 0x01) << 5) |
                  (((instr >>  2) & 0x07) << 6);

            rtn_instr = fld_opcode | (fwidth_dbl << 12) | (rdq2 << 7) | (sp_reg << 15) | (imm << 20);
            break;

        // C.LWSP => lw rd, imm*4(x2)
        case 2:
            imm = (((instr >>  4) & 0x07) << 2) |
                  (((instr >> 12) & 0x01) << 5) |
                  (((instr >>  2) & 0x03) << 6);

            rtn_instr = lw_opcode | (rdq2 << 7) | (sp_reg << 15) | (2 << 12) | (imm << 20);
            break;

        // C.FLWSP => flw rd, imm*4(x2)
        case 3:
            imm = (((instr >>  4) & 0x07) << 2) |
                  (((instr >> 12) & 0x01) << 5) |
                  (((instr >>  2) & 0x03) << 6);

            rtn_instr = fld_opcode | (fwidth_sgl << 12) | (rdq2 << 7) | (sp_reg << 15) |(imm << 20);
            break;

        // C.EBREAK, C.JALR, C.MV, C.ADD
        case 4:
            if (funct4)
            {
                // C.EBREAK => ebreak
                if (rs2q2 == 0 && rs1q2 == 0)
                {
                    rtn_instr = ebreak_opcode | (1 << 20);
                }
                // C.JALR => jalr x1, 0(rs1)
                else if (rs2q2 == 0 && rs1q2 != 0)
                {
                    rtn_instr = jalr_opcode | (ra_reg << 7) | (rs1q2 << 15);
                }
                // C.ADD =>  add rd, rd, rs2
                else
                {
                    rtn_instr = add_opcode | (rdq2 << 7) | (rs1q2 << 15) | (rs2q2 << 20);
                }
            }
            else
            {
                // C.JR => jalr x0, 0(rs1)
                if (rs2q2 == 0)
                {
                    rtn_instr = jalr_opcode  | (rs1q2 << 15);
                }
                // C.MV => add rd, x0, rs2 (could have mapped to addi rd, rs2, 0)
                else
                {
                    rtn_instr = add_opcode | (rdq2 << 7) | (rs2q2 << 20);
                }
            }
            break;

        // C.FSDSP => fsd rs2, imm*8(x2)
        case 5:
            imm = (((instr >> 10) & 0x7) << 3) |
                  (((instr >>  7) & 0x7) << 6);

            rtn_instr = fsd_opcode | (fwidth_dbl << 12) | (sp_reg << 15) | (rs2q2 << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);
            break;

        // C.SWSP
        case 6:
            imm = (((instr >>  9) & 0xf) << 2) |
                  (((instr >>  7) & 0x3) << 6);
            
            rtn_instr = sw_opcode | (width_word << 12) | (sp_reg << 15) | (rs2q2 << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);
            break;

        // C.FSWSP = fsw rs2, imm*4(x2)
        case 7:
            imm = (((instr >>  9) & 0xf) << 2) |
                  (((instr >>  7) & 0x3) << 6);

            rtn_instr = fsw_opcode | (fwidth_sgl << 12) | (sp_reg << 15) | (rs2q2 << 20) | ((imm & 0x1f) << 7) | ((imm >> 5) << 25);
            break;
        }
    }

    return rtn_instr;
};
