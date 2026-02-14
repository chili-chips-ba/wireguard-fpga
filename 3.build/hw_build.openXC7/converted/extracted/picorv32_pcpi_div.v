// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

module picorv32_pcpi_div (
	clk,
	resetn,
	pcpi_valid,
	pcpi_insn,
	pcpi_rs1,
	pcpi_rs2,
	pcpi_wr,
	pcpi_rd,
	pcpi_wait,
	pcpi_ready
);
	input clk;
	input resetn;
	input pcpi_valid;
	input [31:0] pcpi_insn;
	input [31:0] pcpi_rs1;
	input [31:0] pcpi_rs2;
	output reg pcpi_wr;
	output reg [31:0] pcpi_rd;
	output reg pcpi_wait;
	output reg pcpi_ready;
	reg instr_div;
	reg instr_divu;
	reg instr_rem;
	reg instr_remu;
	wire instr_any_div_rem = |{instr_div, instr_divu, instr_rem, instr_remu};
	reg pcpi_wait_q;
	wire start = pcpi_wait && !pcpi_wait_q;
	always @(posedge clk) begin
		instr_div <= 0;
		instr_divu <= 0;
		instr_rem <= 0;
		instr_remu <= 0;
		if ((((resetn && pcpi_valid) && !pcpi_ready) && (pcpi_insn[6:0] == 7'b0110011)) && (pcpi_insn[31:25] == 7'b0000001))
			(* full_case, parallel_case *)
			case (pcpi_insn[14:12])
				3'b100: instr_div <= 1;
				3'b101: instr_divu <= 1;
				3'b110: instr_rem <= 1;
				3'b111: instr_remu <= 1;
				default:
					;
			endcase
		pcpi_wait <= instr_any_div_rem && resetn;
		pcpi_wait_q <= pcpi_wait && resetn;
	end
	reg [31:0] dividend;
	reg [62:0] divisor;
	reg [31:0] quotient;
	reg [31:0] quotient_msk;
	reg running;
	reg outsign;
	always @(posedge clk) begin
		pcpi_ready <= 0;
		pcpi_wr <= 0;
		pcpi_rd <= 'bx;
		if (!resetn)
			running <= 0;
		else if (start) begin
			running <= 1;
			dividend <= ((instr_div || instr_rem) && pcpi_rs1[31] ? -pcpi_rs1 : pcpi_rs1);
			divisor <= ((instr_div || instr_rem) && pcpi_rs2[31] ? -pcpi_rs2 : pcpi_rs2) << 31;
			outsign <= ((instr_div && (pcpi_rs1[31] != pcpi_rs2[31])) && |pcpi_rs2) || (instr_rem && pcpi_rs1[31]);
			quotient <= 0;
			quotient_msk <= 33'sd2147483648;
		end
		else if (!quotient_msk && running) begin
			running <= 0;
			pcpi_ready <= 1;
			pcpi_wr <= 1;
			if (instr_div || instr_divu)
				pcpi_rd <= (outsign ? -quotient : quotient);
			else
				pcpi_rd <= (outsign ? -dividend : dividend);
		end
		else begin
			if (divisor <= dividend) begin
				dividend <= dividend - divisor;
				quotient <= quotient | quotient_msk;
			end
			divisor <= divisor >> 1;
			quotient_msk <= quotient_msk >> 1;
		end
	end
endmodule