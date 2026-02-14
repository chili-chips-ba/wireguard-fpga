// SPDX-FileCopyrightText: 2015 Clifford Wolf
// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: MIT

//--------------------------------------------------------------------------
// Improved by Chili.CHIPS (2023/24)
//--------------------------------------------------------------------------

module picorv32_pcpi_fast_mul #(
   parameter EXTRA_MUL_FFS = 0,
   parameter EXTRA_INSN_FFS = 0,
   parameter MUL_CLKGATE = 0
) (
   input             clk, resetn,

   input             pcpi_valid,
   input      [31:0] pcpi_insn,
   input      [31:0] pcpi_rs1,
   input      [31:0] pcpi_rs2,

   output            pcpi_wr,
   output     [31:0] pcpi_rd,
   output            pcpi_wait,
   output            pcpi_ready
);
   reg instr_mul, instr_mulh, instr_mulhsu, instr_mulhu;
   wire instr_any_mul = |{instr_mul, instr_mulh, instr_mulhsu, instr_mulhu};
   wire instr_any_mulh = |{instr_mulh, instr_mulhsu, instr_mulhu};
   wire instr_rs1_signed = |{instr_mulh, instr_mulhsu};
   wire instr_rs2_signed = |{instr_mulh};

   reg shift_out;
   reg [3:0] active;
   reg [32:0] rs1, rs2, rs1_q, rs2_q;
   reg [63:0] rd, rd_q;

   wire pcpi_insn_valid = pcpi_valid && pcpi_insn[6:0] == 7'b0110011 && pcpi_insn[31:25] == 7'b0000001;
   reg pcpi_insn_valid_q;

   always @* begin
      instr_mul = 0;
      instr_mulh = 0;
      instr_mulhsu = 0;
      instr_mulhu = 0;

      if (resetn && (EXTRA_INSN_FFS ? pcpi_insn_valid_q : pcpi_insn_valid)) begin
         unique case (pcpi_insn[14:12])
            3'b000: instr_mul = 1;
            3'b001: instr_mulh = 1;
            3'b010: instr_mulhsu = 1;
            3'b011: instr_mulhu = 1;
            default: begin end
         endcase
      end
   end

   always_ff @(posedge clk) begin
      pcpi_insn_valid_q <= pcpi_insn_valid;
      if (!MUL_CLKGATE || active[0]) begin
         rs1_q <= rs1;
         rs2_q <= rs2;
      end
      if (!MUL_CLKGATE || active[1]) begin
         rd <= $signed(EXTRA_MUL_FFS ? rs1_q : rs1) * $signed(EXTRA_MUL_FFS ? rs2_q : rs2);
      end
      if (!MUL_CLKGATE || active[2]) begin
         rd_q <= rd;
      end
   end

   always_ff @(posedge clk) begin
      if (instr_any_mul && !(EXTRA_MUL_FFS ? active[3:0] : active[1:0])) begin
         if (instr_rs1_signed)
            rs1 <= $signed(pcpi_rs1);
         else
            rs1 <= $unsigned(pcpi_rs1);

         if (instr_rs2_signed)
            rs2 <= $signed(pcpi_rs2);
         else
            rs2 <= $unsigned(pcpi_rs2);
         active[0] <= 1;
      end else begin
         active[0] <= 0;
      end

      active[3:1] <= active;
      shift_out <= instr_any_mulh;

      if (!resetn) active <= 0;
   end

   assign pcpi_wr = active[EXTRA_MUL_FFS ? 3 : 1];
   assign pcpi_wait = 0;
   assign pcpi_ready = active[EXTRA_MUL_FFS ? 3 : 1];
`ifdef RISCV_FORMAL_ALTOPS
   assign pcpi_rd =
           instr_mul    ? (pcpi_rs1 + pcpi_rs2) ^ 32'h5876063e :
           instr_mulh   ? (pcpi_rs1 + pcpi_rs2) ^ 32'hf6583fb7 :
           instr_mulhsu ? (pcpi_rs1 - pcpi_rs2) ^ 32'hecfbe137 :
           instr_mulhu  ? (pcpi_rs1 + pcpi_rs2) ^ 32'h949ce5e8 : 1'bx;
`else
   assign pcpi_rd = shift_out ? (EXTRA_MUL_FFS ? rd_q : rd) >> 32 : (EXTRA_MUL_FFS ? rd_q : rd);
`endif
endmodule: picorv32_pcpi_fast_mul
