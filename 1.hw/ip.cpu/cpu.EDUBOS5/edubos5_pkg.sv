// SPDX-FileCopyrightText: 2022 CHILI.CHIPS.LLC
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//  Common declarations used within eduBos5 processor design
//==========================================================================

package edubos5_pkg;

  //bare essentials
  typedef enum logic {
    LO = 1'b0,
    HI = 1'b1
  } bin_t;

  typedef logic [31:0] cpu_data_t;
  typedef logic [31:2] cpu_pc_t;  // program counter for up to 4GByte code space in 4-byte words
  typedef logic [31:0] cpu_addr_t; // CPU address type, 2048 locations for now, 2LSB for byte-select

  //instruction opcode with corresponding decode
  typedef enum logic [6:0] {
    ALUREG = 7'b0110011,  //-\ ALU Data
    ALUIMM = 7'b0010011,  //-/ instructions

    BRNCH = 7'b1100011
    ,                     //-\
    JALR  = 7'b1100111,  // | Code flow
    JAL   = 7'b1101111,  // | instructions
    AUIPC = 7'b0010111,  //-/

    LUI   = 7'b0110111,  //-\ Load/Store
    LOAD  = 7'b0000011,  // | instructions
    STORE = 7'b0100011,  //-/

    FENCE = 7'b0001111,  //- memory ordering, nop for now

    SYSTEM = 7'b1110011  //- special
  } opcode_t;

  typedef struct packed {
    logic ALUREG;  //[10]
    logic ALUIMM;  //[9]

    logic BRNCH;  //[8]
    logic JALR;   //[7]
    logic JAL;    //[6]
    logic AUIPC;  //[5]

    logic LUI;    //[4]
    logic LOAD;   //[3]
    logic STORE;  //[2]

    logic FENCE;  //[1]

    logic SYSTEM;  //[0]
  } instr_decode_t;

  //funct3 types for ALUIMM, ALUREG instructions
  typedef enum logic [2:0] {
    ADD_SUB = 3'b000,
    SLL     = 3'b001,
    SLT     = 3'b010,
    SLTU    = 3'b011,
    XOR     = 3'b100,
    SRL_SRA = 3'b101,
    OR      = 3'b110,
    AND     = 3'b111
  } funct3_alu_t;

  //funct3 types for BRANCH instructions
  typedef enum logic [2:0] {
    BEQ  = 3'b000,
    BNE  = 3'b001,
    BLT  = 3'b100,
    BGE  = 3'b101,
    BLTU = 3'b110,
    BGEU = 3'b111
  } funct3_brnch_t;
  //funct3 types for LOAD instructions
  typedef enum logic [2:0] {
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101
  } funct3_load_t;
  //funct3 types for STORE instructions
  typedef enum logic [2:0] {
    SB = 3'b000,
    SH = 3'b001,
    SW = 3'b010
  } funct3_store_t;
  //Write-enable, byte select
  typedef enum logic [3:0] {
    NOWR      = 4'b0000,
    BYTE1     = 4'b0001,
    BYTE2     = 4'b0010,
    BYTE3     = 4'b0100,
    BYTE4     = 4'b1000,
    HALFWORD1 = 4'b0011,
    HALFWORD2 = 4'b1100,
    WORD      = 4'b1111
  } we_bs_t;
  //funct7 types
  typedef enum logic [6:0] {
    SEL_FIRST  = 7'b000_0000,  //default, or selects first (ADD_SUB ADD would be selected)
    SEL_SECOND = 7'b010_0000
  } funct7_t;  //only ALUREG and ALUIMM instr
  //shared func3 fields differentiated in grp_imm_t
  // 6 instruction type groups (part that's selected by opcode)
  typedef struct packed {
    funct7_t     func7;  // [31:25]
    logic [4:0]  rs2;    // [24:20]
    logic [4:0]  rs1;    // [19:15]
    funct3_alu_t func3;  // [14:12]
    logic [4:0]  rd;     // [11:7]
  } grp_reg2reg_t;

  typedef struct packed {
    logic [11:0]  imm11_0;  // [31:20]
    logic [4:0]   rs1;      // [19:15]
    funct3_load_t func3;    // [14:12]
    logic [4:0]   rd;       // [11:7]
  } grp_imm_t;  // for LOAD instruction

  typedef struct packed {
    logic [31:12] imm31_12;  // [31:12]
    logic [4:0]   rd;        // [11:7]
  } grp_uimm_t;  // for LUI instruction

  typedef struct packed {
    logic [11:5]   imm11_5;  // [31:25]
    logic [4:0]    rs2;      // [24:20]
    logic [4:0]    rs1;      // [19:15]
    funct3_store_t func3;    // [14:12]
    logic [4:0]    imm4_0;   // [11:7]
  } grp_store_t;  // for STORE instruction

  typedef struct packed {
    logic          imm12;    // [31]
    logic [10:5]   imm10_5;  // [30:25]
    logic [4:0]    rs2;      // [24:20]
    logic [4:0]    rs1;      // [19:15]
    funct3_brnch_t func3;    // [14:12]
    logic [4:1]    imm4_1;   // [11:8]
    logic          imm11;    // [7]
  } grp_brnch_t;  // for BRANCH instruction

  typedef struct packed {
    logic         imm20;     // [31]
    logic [10:1]  imm10_1;   // [30:21]
    logic         imm11;     // [20]
    logic [19:12] imm19_12;  // [19:12]
    logic [4:0]   rd;        // [11:7]
  } grp_jump_t;  // for JUMP instruction

  //union declaration for variable parts of instruction, [31:7]
  typedef union packed {
    grp_reg2reg_t reg2reg;  //[31:7]-InstrGroup#1
    grp_imm_t     imm;      //[31:7]-InstrGroup#2
    grp_uimm_t    uimm;     //[31:7]-InstrGroup#3
    grp_store_t   store;    //[31:7]-InstrGroup#4
    grp_brnch_t   brnch;    //[31:7]-InstrGroup#5
    grp_jump_t    jump;     //[31:7]-InstrGroup#6
  } grp_t;

  //complete instruction contains invariable opcode
  //  and opcode-dependent, variable parts
  typedef struct packed {
    grp_t    grp;     //[31:7]
    opcode_t opcode;  //[6:0]
  } instr_t;

  //neccessary for the ALU shifts
  function automatic logic [31:0] flip32(input logic [31:0] x);
    logic [31:0] y;
    for (int i = 0; i < 32; i++) begin
      y[i] = x[31-i];
    end
    return y;
  endfunction

endpackage : edubos5_pkg

// -----------------------------------------------------------------------------
// Project:     openPCIE
// Description: NLnet-sponsored open-source implementation
// Version:     1.0
// Date:        Aug 30, 2022
// -----------------------------------------------------------------------------
