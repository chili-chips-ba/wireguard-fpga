//--------------------------------------------------------------------------
// Improved by Chili.CHIPS (2023/24)
//--------------------------------------------------------------------------

/***************************************************************
 * picorv32_pcpi_div
 ***************************************************************/

module picorv32_pcpi_div (
   input             clk, resetn,

   input             pcpi_valid,
   input      [31:0] pcpi_insn,
   input      [31:0] pcpi_rs1,
   input      [31:0] pcpi_rs2,

   output reg        pcpi_wr,
   output reg [31:0] pcpi_rd,
   output reg        pcpi_wait,
   output reg        pcpi_ready
);
   reg instr_div, instr_divu, instr_rem, instr_remu;
   wire instr_any_div_rem = |{instr_div, instr_divu, instr_rem, instr_remu};

   reg pcpi_wait_q;
   wire start = pcpi_wait && !pcpi_wait_q;

   always_ff @(posedge clk) begin
      instr_div <= 0;
      instr_divu <= 0;
      instr_rem <= 0;
      instr_remu <= 0;

      if (resetn && pcpi_valid && !pcpi_ready && pcpi_insn[6:0] == 7'b0110011 && pcpi_insn[31:25] == 7'b0000001) begin
         unique case (pcpi_insn[14:12])
            3'b100: instr_div <= 1;
            3'b101: instr_divu <= 1;
            3'b110: instr_rem <= 1;
            3'b111: instr_remu <= 1;
            default: begin end        
         endcase
      end

      pcpi_wait <= instr_any_div_rem && resetn;
      pcpi_wait_q <= pcpi_wait && resetn;
   end

   reg [31:0] dividend;
   reg [62:0] divisor;
   reg [31:0] quotient;
   reg [31:0] quotient_msk;
   reg running;
   reg outsign;

   always_ff @(posedge clk) begin
      pcpi_ready <= 0;
      pcpi_wr <= 0;
      pcpi_rd <= 'bx;

      if (!resetn) begin
         running <= 0;
      end else
      if (start) begin
         running <= 1;
         dividend <= (instr_div || instr_rem) && pcpi_rs1[31] ? -pcpi_rs1 : pcpi_rs1;
         divisor <= ((instr_div || instr_rem) && pcpi_rs2[31] ? -pcpi_rs2 : pcpi_rs2) << 31;
         outsign <= (instr_div && (pcpi_rs1[31] != pcpi_rs2[31]) && |pcpi_rs2) || (instr_rem && pcpi_rs1[31]);
         quotient <= 0;
         quotient_msk <= 1 << 31;
      end else
      if (!quotient_msk && running) begin
         running <= 0;
         pcpi_ready <= 1;
         pcpi_wr <= 1;
`ifdef RISCV_FORMAL_ALTOPS
      unique case (1)
         instr_div : pcpi_rd <= (pcpi_rs1 - pcpi_rs2) ^ 32'h7f8529ec;
         instr_divu: pcpi_rd <= (pcpi_rs1 - pcpi_rs2) ^ 32'h10e8fd70;
         instr_rem : pcpi_rd <= (pcpi_rs1 - pcpi_rs2) ^ 32'h8da68fa5;
         instr_remu: pcpi_rd <= (pcpi_rs1 - pcpi_rs2) ^ 32'h3138d0e1;
         default: begin end        
      endcase
`else
      if (instr_div || instr_divu)
         pcpi_rd <= outsign ? -quotient : quotient;
      else
         pcpi_rd <= outsign ? -dividend : dividend;
`endif
      end else begin
         if (divisor <= dividend) begin
            dividend <= dividend - divisor;
            quotient <= quotient | quotient_msk;
         end
         divisor <= divisor >> 1;
`ifdef RISCV_FORMAL_ALTOPS
         quotient_msk <= quotient_msk >> 5;
`else
         quotient_msk <= quotient_msk >> 1;
`endif
      end
   end // always_ff @ (posedge clk)

endmodule: picorv32_pcpi_div
