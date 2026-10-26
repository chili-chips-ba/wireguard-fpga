// SPDX-FileCopyrightText: 2022 Chili.CHIPS
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// eduBOS5 ALU: RV32I (ADD, SUB, COMPARISONS, SHIFTS)
// 1 cycle to output - outputs are flopped
// GOWIN_FAST_OP uses Gowin ALU54 DSP for timing closure
//==========================================================================
module edubos5_alu
  import edubos5_pkg::*;
#(
    parameter bit GOWIN_FAST_OP = 1'b1,
    // 1: the shift is computed before its register, like add/sub (3-stage
    // pipeline: its inputs have 2 cycles). 0: after it, from registered inputs
    parameter bit SHIFT_PRE_REG = 1'b0
) (
    input logic clk,
    input logic reset,  // DSP reset, GOWIN_FAST_OP only
    input logic ce,     // load enable for all ALU registers

    input cpu_data_t aluin_1,
    input cpu_data_t aluin_2,

    input logic [4:0] shamt,

    input logic        aluimm_dec,
    input logic        jalr_dec,        //uses alu_plus res
    input logic        funct7_5,
    input logic        funct7_5_instr,  // funct7_5 before its register, SHIFT_PRE_REG only
    input funct3_alu_t funct3,

    output cpu_data_t alu_out,

    output logic eq,
    output logic ltu,
    output logic lt
);
  //-----------------------------------------
  // Functions combo
  //-----------------------------------------
  logic [31:0] alu_xor, alu_or, alu_and;
  logic [31:0] shifter, shifter_in;

  always_comb begin : _alu_calc
    alu_xor = aluin_1 ^ aluin_2;
    alu_or  = aluin_1 | aluin_2;
    alu_and = aluin_1 & aluin_2;
  end : _alu_calc

  //------------------------------------------------------
  // flopping alu outputs, barrel roll inputs, and functs
  //------------------------------------------------------
  logic [31:0] alu_and_reg, alu_xor_reg, alu_or_reg;
  logic aluin_1_31_reg, aluin_2_31_reg;

  funct3_alu_t funct3_alu_reg;

  always_ff @(posedge clk) begin : _alu_pipe
    if (ce) begin
      aluin_1_31_reg <= aluin_1[31];
      aluin_2_31_reg <= aluin_2[31];

      alu_and_reg    <= alu_and;
      alu_xor_reg    <= alu_xor;
      alu_or_reg     <= alu_or;

      funct3_alu_reg <= funct3;
    end
  end : _alu_pipe

  //----------------------------------------------------------------------
  // Addition / subtraction, registered: alu_minus_reg[32] is the borrow
  //----------------------------------------------------------------------
  logic [31:0] alu_plus_reg;
  logic [32:0] alu_minus_reg;

  if (GOWIN_FAST_OP) begin : g_dsp
    // DSP ALU54 module for fast addition/substraction (108 MHz Fmax target)
    logic [32:0] alu_dsp_plus, alu_dsp_minus;
    logic [54:0] NC_caso_plus, NC_caso_minus;  // ALU54 cascade out, unused

    Gowin_ALU54plus u_alu54_plus_dsp (
        .clk  (clk),           //i
        .ce   (ce),            //i
        .reset(reset),         //i
        .a    (aluin_1),       //i
        .b    (aluin_2),       //i
        .dout (alu_dsp_plus),  //o
        .caso (NC_caso_plus)   //o
    );

    Gowin_ALU54minus u_alu54_minus_dsp (
        .clk  (clk),            //i
        .ce   (ce),             //i
        .reset(reset),          //i
        .a    (aluin_1),        //i
        .b    (aluin_2),        //i
        .dout (alu_dsp_minus),  //o
        .caso (NC_caso_minus)   //o
    );

    assign alu_plus_reg  = alu_dsp_plus[31:0];
    assign alu_minus_reg = alu_dsp_minus;
  end : g_dsp
  else begin : g_lut
    logic NC_reset;  // no DSP to reset
    assign NC_reset = reset;

    always_ff @(posedge clk) begin : _alu_add_sub
      if (ce) begin
        alu_plus_reg  <= aluin_1 + aluin_2;
        alu_minus_reg <= {1'b0, aluin_1} + {1'b1, ~aluin_2} + 33'd1;
      end
    end : _alu_add_sub
  end : g_lut

  //---------------------------------------------------------------
  // Barrel roll: SLL flips its input and its output, so one right shifter
  // serves all three shifts
  //---------------------------------------------------------------
  assign shifter_in = (funct3 == SLL) ? flip32(aluin_1) : aluin_1;

  if (SHIFT_PRE_REG) begin : g_shift_pre
    // registered result: the shift is no longer on the write-back path
    logic NC_funct7_5;  // the registered copy: not used here
    assign NC_funct7_5 = funct7_5;

    always_ff @(posedge clk) begin : _alu_shift
      if (ce) begin
        shifter <= cpu_data_t'($signed({funct7_5_instr & aluin_1[31], shifter_in}) >>> shamt);
      end
    end : _alu_shift
  end : g_shift_pre
  else begin : g_shift_post
    logic [31:0] shifter_in_reg;
    logic [ 4:0] shamt_reg;
    logic        NC_funct7_5_instr;  // the shift reads the registered copy
    assign NC_funct7_5_instr = funct7_5_instr;

    always_ff @(posedge clk) begin : _alu_shift_in
      if (ce) begin
        shifter_in_reg <= shifter_in;
        shamt_reg      <= shamt;
      end
    end : _alu_shift_in

    assign shifter = cpu_data_t'($signed(
        {funct7_5 & aluin_1_31_reg, shifter_in_reg}
    ) >>> shamt_reg);
  end : g_shift_post

  //---------------------------------------------------------------
  // Extracting comparisons outputs from calculations
  //---------------------------------------------------------------
  always_comb begin : _alu_outputs
    eq  = (alu_minus_reg[31:0] == '0);
    ltu = alu_minus_reg[32];
    lt  = (aluin_1_31_reg ^ aluin_2_31_reg) ? aluin_1_31_reg : alu_minus_reg[32];
  end : _alu_outputs

  //---------------
  // ALU output mux
  //---------------
  always_comb begin : _alu_output_mux
    unique case (funct3_alu_reg)
      ADD_SUB: begin
        if (aluimm_dec | (funct7_5 == 1'b0) | jalr_dec) begin
          alu_out = alu_plus_reg;
        end
        else begin
          alu_out = alu_minus_reg[31:0];
        end
      end
      //comparisons: Signed Less Than; Unsigned Less Than
      SLT:  alu_out = {31'b0, lt};
      SLTU: alu_out = {31'b0, ltu};

      //shifts: Logical Left; Logical Right/Arithmetic
      SLL:     alu_out = flip32(shifter);
      SRL_SRA: alu_out = shifter;

      //logic operations
      XOR: alu_out = alu_xor_reg;
      OR:  alu_out = alu_or_reg;
      AND: alu_out = alu_and_reg;
    endcase
  end : _alu_output_mux
endmodule : edubos5_alu

// -----------------------------------------------------------------------------
// Project:     openPCIE
// Description: NLnet-sponsored open-source implementation
// Version:     1.0
// Date:        May 7, 2024
// -----------------------------------------------------------------------------
