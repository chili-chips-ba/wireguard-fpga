// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

module sync_fifo_ram (
	arst_n,
	clk,
	din,
	we,
	re,
	dcount,
	empty,
	full,
	dout_comb,
	dout
);
	reg _sv2v_0;
	parameter DWIDTH = 16;
	parameter AWIDTH = 4;
	input wire arst_n;
	input wire clk;
	input wire [DWIDTH - 1:0] din;
	input wire we;
	input wire re;
	output reg [AWIDTH:0] dcount;
	output reg empty;
	output wire full;
	output reg [DWIDTH - 1:0] dout_comb;
	output reg [DWIDTH - 1:0] dout;
	wire we_protected;
	wire re_protected;
	reg [AWIDTH - 1:0] wr_addr;
	reg [AWIDTH - 1:0] rd_addr;
	assign full = dcount[AWIDTH];
	assign we_protected = we & ~full;
	assign re_protected = re & ~empty;
	function automatic [AWIDTH - 1:0] sv2v_cast_5D39C;
		input reg [AWIDTH - 1:0] inp;
		sv2v_cast_5D39C = inp;
	endfunction
	function automatic [(AWIDTH >= 0 ? AWIDTH + 1 : 1 - AWIDTH) - 1:0] sv2v_cast_331F7;
		input reg [(AWIDTH >= 0 ? AWIDTH + 1 : 1 - AWIDTH) - 1:0] inp;
		sv2v_cast_331F7 = inp;
	endfunction
	always @(negedge arst_n or posedge clk) begin : _fifo_ctrl
		if (arst_n == 1'b0) begin
			dcount <= 1'sb0;
			wr_addr <= 1'sb0;
			rd_addr <= 1'sb0;
			empty <= 1'b1;
		end
		else begin
			if (we_protected == 1'b1)
				wr_addr <= sv2v_cast_5D39C(wr_addr + sv2v_cast_5D39C(1));
			if (re_protected == 1'b1)
				rd_addr <= sv2v_cast_5D39C(rd_addr + sv2v_cast_5D39C(1));
			(* full_case, parallel_case *)
			case ({we_protected, re_protected})
				2'b01: begin
					dcount <= sv2v_cast_331F7(dcount - sv2v_cast_331F7(1));
					empty <= ~|dcount[AWIDTH:1];
				end
				2'b10: begin
					dcount <= sv2v_cast_331F7(dcount + sv2v_cast_331F7(1));
					empty <= 1'b0;
				end
				default:
					;
			endcase
		end
	end
	(* ram_style = "distributed" *) reg [DWIDTH - 1:0] mem [0:(2 ** AWIDTH) - 1];
	always @(*) begin
		if (_sv2v_0)
			;
		dout_comb = mem[rd_addr];
	end
	always @(posedge clk) begin
		if (re_protected == 1'b1)
			dout <= dout_comb;
		if (we_protected == 1'b1)
			mem[wr_addr] <= din;
	end
	initial _sv2v_0 = 0;
endmodule