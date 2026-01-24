// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

module ethernet_phy (
	e1_reset,
	e1_mdc,
	e1_mdio,
	e2_reset,
	e2_mdc,
	e2_mdio,
	e3_reset,
	e3_mdc,
	e3_mdio,
	e4_reset,
	e4_mdc,
	e4_mdio
);
	output wire e1_reset;
	output wire e1_mdc;
	inout wire e1_mdio;
	output wire e2_reset;
	output wire e2_mdc;
	inout wire e2_mdio;
	output wire e3_reset;
	output wire e3_mdc;
	inout wire e3_mdio;
	output wire e4_reset;
	output wire e4_mdc;
	inout wire e4_mdio;
	assign e1_reset = 1'b1;
	assign e2_reset = 1'b1;
	assign e3_reset = 1'b1;
	assign e4_reset = 1'b1;
endmodule
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
module clk_rst_gen (
	clk_p,
	clk_n,
	rst_n,
	sys_clk,
	sys_rst,
	sys_rst_n,
	eth_gtx_clk,
	eth_gtx_rst
);
	input clk_p;
	input clk_n;
	input rst_n;
	output wire sys_clk;
	output wire sys_rst;
	output wire sys_rst_n;
	output wire eth_gtx_clk;
	output wire eth_gtx_rst;
	wire clk;
	wire clk_in;
	IBUFDS #(
		.DIFF_TERM("TRUE"),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("LVDS_25")
	) u_bufds_clk(
		.I(clk_p),
		.IB(clk_n),
		.O(clk_in)
	);
	BUFG u_bufg_clk(
		.I(clk_in),
		.O(clk)
	);
	wire sys_pll_locked;
	wire sys_pll_clk;
	wire sys_reset;
	fpga_pll_80M u_sys_pll(
		.clk(clk),
		.rst_n(rst_n),
		.sys_pll_clk(sys_pll_clk),
		.sys_pll_locked(sys_pll_locked)
	);
	sync_reset #(.N(4)) sys_sync_reset_inst(
		.clk(sys_pll_clk),
		.rst(~sys_pll_locked),
		.out(sys_reset)
	);
	assign sys_rst = sys_reset;
	assign sys_rst_n = ~sys_reset;
	assign sys_clk = sys_pll_clk;
	wire eth_pll_locked;
	wire eth_pll_clk;
	fpga_pll_125M u_eth_pll(
		.clk(clk),
		.rst_n(rst_n),
		.eth_pll_clk(eth_pll_clk),
		.eth_pll_locked(eth_pll_locked)
	);
	sync_reset #(.N(4)) eth_sync_reset_inst(
		.clk(eth_pll_clk),
		.rst(~eth_pll_locked),
		.out(eth_gtx_rst)
	);
	assign eth_gtx_clk = eth_pll_clk;
endmodule
module picorv32 (
	clk,
	resetn,
	trap,
	mem_valid,
	mem_instr,
	mem_ready,
	mem_addr,
	mem_wdata,
	mem_wstrb,
	mem_rdata,
	mem_la_read,
	mem_la_write,
	mem_la_addr,
	mem_la_wdata,
	mem_la_wstrb,
	pcpi_valid,
	pcpi_insn,
	pcpi_rsrc1,
	pcpi_rsrc2,
	pcpi_rdst,
	pcpi_wr,
	pcpi_wait,
	pcpi_ready,
	irq,
	eoi,
	trace_valid,
	trace_data
);
	reg _sv2v_0;
	parameter [31:0] PROGADDR_RESET = 32'h00100000;
	parameter [31:0] STACKADDR = 32'hffffffff;
	parameter [0:0] COMPRESSED_ISA = 0;
	parameter [0:0] TWO_STAGE_SHIFT = 1;
	parameter [0:0] TWO_CYCLE_COMPARE = 0;
	parameter [0:0] TWO_CYCLE_ALU = 0;
	parameter [0:0] LATCHED_MEM_RDATA = 0;
	parameter [0:0] BARREL_SHIFTER = 0;
	parameter [0:0] ENABLE_MUL = 0;
	parameter [0:0] ENABLE_FAST_MUL = 0;
	parameter [0:0] ENABLE_DIV = 0;
	parameter [0:0] ENABLE_REGS_DUALPORT = 1;
	parameter [0:0] ENABLE_REGS_16_31 = 1;
	parameter [0:0] ENABLE_PCPI = 0;
	parameter [0:0] ENABLE_COUNTERS = 0;
	parameter [0:0] ENABLE_COUNTERS64 = 0;
	parameter [0:0] ENABLE_TRACE = 0;
	parameter [0:0] ENABLE_IRQ = 0;
	parameter [0:0] ENABLE_IRQ_QREGS = 0;
	parameter [0:0] ENABLE_IRQ_TIMER = 0;
	parameter [31:0] MASKED_IRQ = 32'h00000000;
	parameter [31:0] LATCHED_IRQ = 32'hffffffff;
	parameter [31:0] PROGADDR_IRQ = 32'h00000010;
	parameter [0:0] CATCH_MISALIGN = 1;
	parameter [0:0] CATCH_ILLINSN = 1;
	parameter [0:0] REGS_INIT_ZERO = 0;
	input clk;
	input resetn;
	output reg trap;
	output reg mem_valid;
	output reg mem_instr;
	input mem_ready;
	output reg [31:0] mem_addr;
	output reg [31:0] mem_wdata;
	output reg [3:0] mem_wstrb;
	input [31:0] mem_rdata;
	output wire mem_la_read;
	output wire mem_la_write;
	output wire [31:0] mem_la_addr;
	output reg [31:0] mem_la_wdata;
	output reg [3:0] mem_la_wstrb;
	output reg pcpi_valid;
	output reg [31:0] pcpi_insn;
	output wire [31:0] pcpi_rsrc1;
	output wire [31:0] pcpi_rsrc2;
	input [31:0] pcpi_rdst;
	input pcpi_wr;
	input pcpi_wait;
	input pcpi_ready;
	input [31:0] irq;
	output reg [31:0] eoi;
	output reg trace_valid;
	output reg [35:0] trace_data;
	localparam signed [31:0] IRQ_TIMER = 0;
	localparam signed [31:0] IRQ_EBREAK = 1;
	localparam signed [31:0] IRQ_BUSERROR = 2;
	localparam signed [31:0] IRQREGS_OFFSET = (ENABLE_REGS_16_31 ? 32 : 16);
	localparam signed [31:0] REGFILE_SIZE = (ENABLE_REGS_16_31 ? 32 : 16) + ((4 * ENABLE_IRQ) * ENABLE_IRQ_QREGS);
	localparam signed [31:0] REGINDEX_BITS = (ENABLE_REGS_16_31 ? 5 : 4) + (ENABLE_IRQ * ENABLE_IRQ_QREGS);
	localparam WITH_PCPI = ((ENABLE_PCPI | ENABLE_MUL) | ENABLE_FAST_MUL) | ENABLE_DIV;
	localparam [35:0] TRACE_BRANCH = 36'b000100000000000000000000000000000000;
	localparam [35:0] TRACE_ADDR = 36'b001000000000000000000000000000000000;
	localparam [35:0] TRACE_IRQ = 36'b100000000000000000000000000000000000;
	reg [31:0] reg_pc;
	reg [31:0] reg_next_pc;
	reg [31:0] reg_op1;
	reg [31:0] reg_op2;
	reg [31:0] reg_out;
	reg [4:0] reg_sh;
	reg [31:0] next_insn_opcode;
	wire [31:0] next_pc;
	reg irq_delay;
	reg irq_active;
	reg [31:0] irq_mask;
	reg [31:0] irq_pending;
	reg [31:0] irq_timer;
	reg [63:0] count_cycle;
	reg [63:0] count_instr;
	reg [31:0] cpuregs [0:REGFILE_SIZE - 1];
	integer i;
	initial if (REGS_INIT_ZERO)
		for (i = 0; i < REGFILE_SIZE; i = i + 1)
			cpuregs[i] = 0;
	wire [32:1] sv2v_tmp_71214;
	assign sv2v_tmp_71214 = 1'sb0;
	always @(*) pcpi_insn = sv2v_tmp_71214;
	assign pcpi_rsrc1 = reg_op1;
	assign pcpi_rsrc2 = reg_op2;
	wire pcpi_mul_wr;
	wire [31:0] pcpi_mul_rdst;
	wire pcpi_mul_wait;
	wire pcpi_mul_ready;
	wire pcpi_div_wr;
	wire [31:0] pcpi_div_rdst;
	wire pcpi_div_wait;
	wire pcpi_div_ready;
	reg pcpi_int_wr;
	reg [31:0] pcpi_int_rdst;
	reg pcpi_int_wait;
	reg pcpi_int_ready;
	generate
		if (ENABLE_FAST_MUL) begin : _enable_fast_mul
			picorv32_pcpi_fast_mul pcpi_mul(
				.clk(clk),
				.resetn(resetn),
				.pcpi_valid(pcpi_valid),
				.pcpi_insn(pcpi_insn),
				.pcpi_rs1(pcpi_rsrc1),
				.pcpi_rs2(pcpi_rsrc2),
				.pcpi_wr(pcpi_mul_wr),
				.pcpi_rd(pcpi_mul_rdst),
				.pcpi_wait(pcpi_mul_wait),
				.pcpi_ready(pcpi_mul_ready)
			);
		end
		else if (ENABLE_MUL) begin : _enable_mul
			picorv32_pcpi_mul pcpi_mul(
				.clk(clk),
				.resetn(resetn),
				.pcpi_valid(pcpi_valid),
				.pcpi_insn(pcpi_insn),
				.pcpi_rs1(pcpi_rsrc1),
				.pcpi_rs2(pcpi_rsrc2),
				.pcpi_wr(pcpi_mul_wr),
				.pcpi_rd(pcpi_mul_rdst),
				.pcpi_wait(pcpi_mul_wait),
				.pcpi_ready(pcpi_mul_ready)
			);
		end
		else begin : _no_hw_mul
			assign pcpi_mul_wr = 1'sb0;
			assign pcpi_mul_rdst = 1'sb0;
			assign pcpi_mul_wait = 1'sb0;
			assign pcpi_mul_ready = 1'sb0;
		end
		if (ENABLE_DIV) begin : _enable_div
			picorv32_pcpi_div pcpi_div(
				.clk(clk),
				.resetn(resetn),
				.pcpi_valid(pcpi_valid),
				.pcpi_insn(pcpi_insn),
				.pcpi_rs1(pcpi_rsrc1),
				.pcpi_rs2(pcpi_rsrc2),
				.pcpi_wr(pcpi_div_wr),
				.pcpi_rd(pcpi_div_rdst),
				.pcpi_wait(pcpi_div_wait),
				.pcpi_ready(pcpi_div_ready)
			);
		end
		else begin : _no_hw_div
			assign pcpi_div_wr = 1'sb0;
			assign pcpi_div_rdst = 1'sb0;
			assign pcpi_div_wait = 1'sb0;
			assign pcpi_div_ready = 1'sb0;
		end
	endgenerate
	always @(*) begin
		pcpi_int_wait = ((ENABLE_PCPI & pcpi_wait) | ((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_wait)) | (ENABLE_DIV & pcpi_div_wait);
		pcpi_int_ready = ((ENABLE_PCPI & pcpi_ready) | ((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_ready)) | (ENABLE_DIV & pcpi_div_ready);
		pcpi_int_wr = 1'sb0;
		pcpi_int_rdst = 1'sb0;
		if (ENABLE_PCPI & pcpi_ready) begin
			pcpi_int_wr = pcpi_wr;
			pcpi_int_rdst = pcpi_rdst;
		end
		else if ((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_ready) begin
			pcpi_int_wr = pcpi_mul_wr;
			pcpi_int_rdst = pcpi_mul_rdst;
		end
		else if (ENABLE_DIV & pcpi_div_ready) begin
			pcpi_int_wr = pcpi_div_wr;
			pcpi_int_rdst = pcpi_div_rdst;
		end
	end
	reg [1:0] mem_state;
	reg [1:0] mem_wordsize;
	reg [31:0] mem_rdata_word;
	reg [31:0] mem_rdata_q;
	reg mem_do_prefetch;
	reg mem_do_rinst;
	reg mem_do_rdata;
	reg mem_do_wdata;
	wire mem_xfer;
	reg mem_la_secondword;
	reg mem_la_firstword_reg;
	reg last_mem_valid;
	wire mem_la_firstword = ((COMPRESSED_ISA & (mem_do_prefetch | mem_do_rinst)) & next_pc[1]) & !mem_la_secondword;
	wire mem_la_firstword_xfer = (COMPRESSED_ISA & mem_xfer) & (last_mem_valid ? mem_la_firstword_reg : mem_la_firstword);
	reg prefetched_high_word;
	reg clear_prefetched_high_word;
	reg [15:0] mem_16bit_buffer;
	wire [31:0] mem_rdata_latched_noshuffle;
	wire [31:0] mem_rdata_latched;
	wire mem_la_use_prefetched_high_word = ((COMPRESSED_ISA & mem_la_firstword) & prefetched_high_word) & ~clear_prefetched_high_word;
	assign mem_xfer = (mem_valid & mem_ready) | (mem_la_use_prefetched_high_word & mem_do_rinst);
	wire mem_busy = |{mem_do_prefetch, mem_do_rinst, mem_do_rdata, mem_do_wdata};
	wire mem_done = (resetn & (((mem_xfer & |mem_state) & |{mem_do_rinst, mem_do_rdata, mem_do_wdata}) | (&mem_state & mem_do_rinst))) & (~mem_la_firstword | (~&mem_rdata_latched[1:0] & mem_xfer));
	assign mem_la_write = (resetn & (mem_state == 2'd0)) & mem_do_wdata;
	assign mem_la_read = resetn & (((~mem_la_use_prefetched_high_word & (mem_state == 2'd0)) & ((mem_do_rinst | mem_do_prefetch) | mem_do_rdata)) | ((((COMPRESSED_ISA & mem_xfer) & (last_mem_valid ? mem_la_firstword_reg : mem_la_firstword)) & ~mem_la_secondword) & (&mem_rdata_latched[1:0])));
	assign mem_la_addr[1:0] = 2'd0;
	assign mem_la_addr[31:2] = (mem_do_prefetch | mem_do_rinst ? next_pc[31:2] + {29'd0, mem_la_firstword_xfer} : reg_op1[31:2]);
	assign mem_rdata_latched_noshuffle = (mem_xfer | LATCHED_MEM_RDATA ? mem_rdata : mem_rdata_q);
	assign mem_rdata_latched = (COMPRESSED_ISA && mem_la_use_prefetched_high_word ? {16'bxxxxxxxxxxxxxxxx, mem_16bit_buffer} : (COMPRESSED_ISA && mem_la_secondword ? {mem_rdata_latched_noshuffle[15:0], mem_16bit_buffer} : (COMPRESSED_ISA && mem_la_firstword ? {16'bxxxxxxxxxxxxxxxx, mem_rdata_latched_noshuffle[31:16]} : mem_rdata_latched_noshuffle)));
	always @(posedge clk)
		if (!resetn) begin
			mem_la_firstword_reg <= 1'sb0;
			last_mem_valid <= 1'sb0;
		end
		else begin
			if (!last_mem_valid)
				mem_la_firstword_reg <= mem_la_firstword;
			last_mem_valid <= mem_valid && !mem_ready;
		end
	always @(*)
		(* full_case *)
		case (mem_wordsize)
			2'd0: begin
				mem_la_wdata = reg_op2;
				mem_la_wstrb = 4'b1111;
				mem_rdata_word = mem_rdata;
			end
			2'd1: begin
				mem_la_wdata = {2 {reg_op2[15:0]}};
				mem_la_wstrb = (reg_op1[1] ? 4'b1100 : 4'b0011);
				(* full_case, parallel_case *)
				case (reg_op1[1])
					1'b0: mem_rdata_word = {16'b0000000000000000, mem_rdata[15:0]};
					1'b1: mem_rdata_word = {16'b0000000000000000, mem_rdata[31:16]};
					default:
						;
				endcase
			end
			2'd2: begin
				mem_la_wdata = {4 {reg_op2[7:0]}};
				mem_la_wstrb = 4'b0001 << reg_op1[1:0];
				(* full_case, parallel_case *)
				case (reg_op1[1:0])
					2'b00: mem_rdata_word = {24'b000000000000000000000000, mem_rdata[7:0]};
					2'b01: mem_rdata_word = {24'b000000000000000000000000, mem_rdata[15:8]};
					2'b10: mem_rdata_word = {24'b000000000000000000000000, mem_rdata[23:16]};
					2'b11: mem_rdata_word = {24'b000000000000000000000000, mem_rdata[31:24]};
					default:
						;
				endcase
			end
			default: begin
				mem_la_wdata = reg_op2;
				mem_la_wstrb = 4'b1111;
				mem_rdata_word = mem_rdata;
			end
		endcase
	always @(posedge clk) begin
		if (mem_xfer) begin
			mem_rdata_q <= (COMPRESSED_ISA ? mem_rdata_latched : mem_rdata);
			next_insn_opcode <= (COMPRESSED_ISA ? mem_rdata_latched : mem_rdata);
			if (mem_instr == 1'b0) begin
				if (mem_wstrb == {4 {1'sb0}})
					;
			end
		end
		if ((COMPRESSED_ISA && mem_done) && (mem_do_prefetch || mem_do_rinst))
			(* full_case, parallel_case *)
			case (mem_rdata_latched[1:0])
				2'b00:
					(* full_case, parallel_case *)
					case (mem_rdata_latched[15:13])
						3'b000: begin
							mem_rdata_q[14:12] <= 3'b000;
							mem_rdata_q[31:30] <= 2'd0;
							mem_rdata_q[29:26] <= mem_rdata_latched[10:7];
							mem_rdata_q[25:24] <= mem_rdata_latched[12:11];
							mem_rdata_q[23] <= mem_rdata_latched[5];
							mem_rdata_q[22] <= mem_rdata_latched[6];
							mem_rdata_q[21:20] <= 2'd0;
						end
						3'b010: begin
							mem_rdata_q[31:20] <= {5'b00000, mem_rdata_latched[5], mem_rdata_latched[12:10], mem_rdata_latched[6], 2'b00};
							mem_rdata_q[14:12] <= 3'b010;
						end
						3'b110: begin
							{mem_rdata_q[31:25], mem_rdata_q[11:7]} <= {5'b00000, mem_rdata_latched[5], mem_rdata_latched[12:10], mem_rdata_latched[6], 2'b00};
							mem_rdata_q[14:12] <= 3'b010;
						end
						default:
							;
					endcase
				2'b01:
					(* full_case, parallel_case *)
					case (mem_rdata_latched[15:13])
						3'b000: begin
							mem_rdata_q[14:12] <= 3'b000;
							mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
						end
						3'b010: begin
							mem_rdata_q[14:12] <= 3'b000;
							mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
						end
						3'b011:
							if (mem_rdata_latched[11:7] == 2) begin
								mem_rdata_q[14:12] <= 3'b000;
								mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[4:3], mem_rdata_latched[5], mem_rdata_latched[2], mem_rdata_latched[6], 4'b0000});
							end
							else
								mem_rdata_q[31:12] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
						3'b100: begin
							if (mem_rdata_latched[11:10] == 2'b00) begin
								mem_rdata_q[31:25] <= 7'b0000000;
								mem_rdata_q[14:12] <= 3'b101;
							end
							if (mem_rdata_latched[11:10] == 2'b01) begin
								mem_rdata_q[31:25] <= 7'b0100000;
								mem_rdata_q[14:12] <= 3'b101;
							end
							if (mem_rdata_latched[11:10] == 2'b10) begin
								mem_rdata_q[14:12] <= 3'b111;
								mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
							end
							if (mem_rdata_latched[12:10] == 3'b011) begin
								if (mem_rdata_latched[6:5] == 2'b00)
									mem_rdata_q[14:12] <= 3'b000;
								if (mem_rdata_latched[6:5] == 2'b01)
									mem_rdata_q[14:12] <= 3'b100;
								if (mem_rdata_latched[6:5] == 2'b10)
									mem_rdata_q[14:12] <= 3'b110;
								if (mem_rdata_latched[6:5] == 2'b11)
									mem_rdata_q[14:12] <= 3'b111;
								mem_rdata_q[31:25] <= (mem_rdata_latched[6:5] == 2'd0 ? 7'b0100000 : 7'b0000000);
							end
						end
						3'b110: begin
							mem_rdata_q[14:12] <= 3'b000;
							{mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8]} <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:5], mem_rdata_latched[2], mem_rdata_latched[11:10], mem_rdata_latched[4:3]});
						end
						3'b111: begin
							mem_rdata_q[14:12] <= 3'b001;
							{mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8]} <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:5], mem_rdata_latched[2], mem_rdata_latched[11:10], mem_rdata_latched[4:3]});
						end
						default:
							;
					endcase
				2'b10:
					(* full_case, parallel_case *)
					case (mem_rdata_latched[15:13])
						3'b000: begin
							mem_rdata_q[31:25] <= 7'b0000000;
							mem_rdata_q[14:12] <= 3'b001;
						end
						3'b010: begin
							mem_rdata_q[31:20] <= {4'b0000, mem_rdata_latched[3:2], mem_rdata_latched[12], mem_rdata_latched[6:4], 2'b00};
							mem_rdata_q[14:12] <= 3'b010;
						end
						3'b100: begin
							if ((mem_rdata_latched[12] == 0) && (mem_rdata_latched[6:2] == 0)) begin
								mem_rdata_q[14:12] <= 3'b000;
								mem_rdata_q[31:20] <= 12'b000000000000;
							end
							if ((mem_rdata_latched[12] == 0) && (mem_rdata_latched[6:2] != 0)) begin
								mem_rdata_q[14:12] <= 3'b000;
								mem_rdata_q[31:25] <= 7'b0000000;
							end
							if (((mem_rdata_latched[12] != 0) && (mem_rdata_latched[11:7] != 0)) && (mem_rdata_latched[6:2] == 0)) begin
								mem_rdata_q[14:12] <= 3'b000;
								mem_rdata_q[31:20] <= 12'b000000000000;
							end
							if ((mem_rdata_latched[12] != 0) && (mem_rdata_latched[6:2] != 0)) begin
								mem_rdata_q[14:12] <= 3'b000;
								mem_rdata_q[31:25] <= 7'b0000000;
							end
						end
						3'b110: begin
							{mem_rdata_q[31:25], mem_rdata_q[11:7]} <= {4'b0000, mem_rdata_latched[8:7], mem_rdata_latched[12:9], 2'b00};
							mem_rdata_q[14:12] <= 3'b010;
						end
						default:
							;
					endcase
				default:
					;
			endcase
	end
	task empty_statement;
		;
	endtask
	always @(posedge clk)
		if (resetn && !trap) begin
			if ((mem_do_prefetch || mem_do_rinst) || mem_do_rdata)
				empty_statement;
			if (mem_do_prefetch || mem_do_rinst)
				empty_statement;
			if (mem_do_rdata)
				empty_statement;
			if (mem_do_wdata)
				empty_statement;
			if ((mem_state == 2'd2) || (mem_state == 2'd3))
				empty_statement;
		end
	always @(posedge clk) begin
		if (!resetn || trap) begin
			if (!resetn)
				mem_state <= 1'sb0;
			if (!resetn || mem_ready)
				mem_valid <= 1'sb0;
			mem_la_secondword <= 1'sb0;
			prefetched_high_word <= 1'sb0;
		end
		else begin
			if (mem_la_read || mem_la_write) begin
				mem_addr <= mem_la_addr;
				mem_wstrb <= mem_la_wstrb & {4 {mem_la_write}};
			end
			if (mem_la_write)
				mem_wdata <= mem_la_wdata;
			(* full_case, parallel_case *)
			case (mem_state)
				2'd0: begin
					if (|{mem_do_prefetch, mem_do_rinst, mem_do_rdata} == 1'b1) begin
						mem_valid <= ~mem_la_use_prefetched_high_word;
						mem_instr <= mem_do_prefetch | mem_do_rinst;
						mem_wstrb <= 1'sb0;
						mem_state <= 2'd1;
					end
					if (mem_do_wdata) begin
						mem_valid <= 1'b1;
						mem_instr <= 1'b0;
						mem_state <= 2'd2;
					end
				end
				2'd1: begin
					empty_statement;
					empty_statement;
					empty_statement;
					empty_statement;
					if (mem_xfer) begin
						if (COMPRESSED_ISA && mem_la_read) begin
							mem_valid <= 1;
							mem_la_secondword <= 1;
							if (!mem_la_use_prefetched_high_word)
								mem_16bit_buffer <= mem_rdata[31:16];
						end
						else begin
							mem_valid <= 0;
							mem_la_secondword <= 0;
							if (COMPRESSED_ISA && !mem_do_rdata) begin
								if (~&mem_rdata[1:0] || mem_la_secondword) begin
									mem_16bit_buffer <= mem_rdata[31:16];
									prefetched_high_word <= 1;
								end
								else
									prefetched_high_word <= 0;
							end
							mem_state <= (mem_do_rinst | mem_do_rdata ? 2'd0 : 2'd3);
						end
					end
				end
				2'd2: begin
					empty_statement;
					empty_statement;
					if (mem_xfer) begin
						mem_valid <= 1'sb0;
						mem_state <= 2'd0;
					end
				end
				2'd3: begin
					empty_statement;
					empty_statement;
					if (mem_do_rinst)
						mem_state <= 2'd0;
				end
				default:
					;
			endcase
		end
		if (clear_prefetched_high_word)
			prefetched_high_word <= 0;
	end
	reg instr_lui;
	reg instr_auipc;
	reg instr_jal;
	reg instr_jalr;
	reg instr_beq;
	reg instr_bne;
	reg instr_blt;
	reg instr_bge;
	reg instr_bltu;
	reg instr_bgeu;
	reg instr_lb;
	reg instr_lh;
	reg instr_lw;
	reg instr_lbu;
	reg instr_lhu;
	reg instr_sb;
	reg instr_sh;
	reg instr_sw;
	reg instr_addi;
	reg instr_slti;
	reg instr_sltiu;
	reg instr_xori;
	reg instr_ori;
	reg instr_andi;
	reg instr_slli;
	reg instr_srli;
	reg instr_srai;
	reg instr_add;
	reg instr_sub;
	reg instr_sll;
	reg instr_slt;
	reg instr_sltu;
	reg instr_xor;
	reg instr_srl;
	reg instr_sra;
	reg instr_or;
	reg instr_and;
	reg instr_rdcycle;
	reg instr_rdcycleh;
	reg instr_rdinstr;
	reg instr_rdinstrh;
	reg instr_ecall_ebreak;
	reg instr_getq;
	reg instr_setq;
	reg instr_retirq;
	reg instr_maskirq;
	reg instr_waitirq;
	reg instr_timer;
	wire instr_trap;
	reg [REGINDEX_BITS - 1:0] decoded_rdst;
	reg [REGINDEX_BITS - 1:0] decoded_rsrc1;
	reg [REGINDEX_BITS - 1:0] decoded_rsrc2;
	reg [31:0] decoded_imm;
	reg [31:0] decoded_imm_uj;
	reg decoder_trigger;
	reg decoder_trigger_q;
	reg decoder_pseudo_trigger;
	reg decoder_pseudo_trigger_q;
	reg compressed_instr;
	reg is_lui_auipc_jal;
	reg is_lb_lh_lw_lbu_lhu;
	reg is_slli_srli_srai;
	reg is_jalr_addi_slti_sltiu_xori_ori_andi;
	reg is_sb_sh_sw;
	reg is_sll_srl_sra;
	reg is_lui_auipc_jal_jalr_addi_add_sub;
	reg is_slti_blt_slt;
	reg is_sltiu_bltu_sltu;
	reg is_beq_bne_blt_bge_bltu_bgeu;
	reg is_lbu_lhu_lw;
	reg is_alu_reg_imm;
	reg is_alu_reg_reg;
	reg is_compare;
	assign instr_trap = (CATCH_ILLINSN || WITH_PCPI) && !{instr_lui, instr_auipc, instr_jal, instr_jalr, instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu, instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw, instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_slli, instr_srli, instr_srai, instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and, instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh, instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer};
	wire is_rdcycle_rdcycleh_rdinstr_rdinstrh;
	assign is_rdcycle_rdcycleh_rdinstr_rdinstrh = |{instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh};
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	always @(posedge clk) begin
		is_lui_auipc_jal <= |{instr_lui, instr_auipc, instr_jal};
		is_lui_auipc_jal_jalr_addi_add_sub <= |{instr_lui, instr_auipc, instr_jal, instr_jalr, instr_addi, instr_add, instr_sub};
		is_slti_blt_slt <= |{instr_slti, instr_blt, instr_slt};
		is_sltiu_bltu_sltu <= |{instr_sltiu, instr_bltu, instr_sltu};
		is_lbu_lhu_lw <= |{instr_lbu, instr_lhu, instr_lw};
		is_compare <= |{is_beq_bne_blt_bge_bltu_bgeu, instr_slti, instr_slt, instr_sltiu, instr_sltu};
		if (mem_do_rinst && mem_done) begin
			instr_lui <= mem_rdata_latched[6:0] == 7'b0110111;
			instr_auipc <= mem_rdata_latched[6:0] == 7'b0010111;
			instr_jal <= mem_rdata_latched[6:0] == 7'b1101111;
			instr_jalr <= (mem_rdata_latched[6:0] == 7'b1100111) && (mem_rdata_latched[14:12] == 3'b000);
			instr_retirq <= ((mem_rdata_latched[6:0] == 7'b0001011) && (mem_rdata_latched[31:25] == 7'b0000010)) && ENABLE_IRQ;
			instr_waitirq <= ((mem_rdata_latched[6:0] == 7'b0001011) && (mem_rdata_latched[31:25] == 7'b0000100)) && ENABLE_IRQ;
			is_beq_bne_blt_bge_bltu_bgeu <= mem_rdata_latched[6:0] == 7'b1100011;
			is_lb_lh_lw_lbu_lhu <= mem_rdata_latched[6:0] == 7'b0000011;
			is_sb_sh_sw <= mem_rdata_latched[6:0] == 7'b0100011;
			is_alu_reg_imm <= mem_rdata_latched[6:0] == 7'b0010011;
			is_alu_reg_reg <= mem_rdata_latched[6:0] == 7'b0110011;
			{decoded_imm_uj[31:20], decoded_imm_uj[10:1], decoded_imm_uj[11], decoded_imm_uj[19:12], decoded_imm_uj[0]} <= sv2v_cast_32_signed($signed({mem_rdata_latched[31:12], 1'b0}));
			decoded_rdst <= mem_rdata_latched[11:7];
			decoded_rsrc1 <= mem_rdata_latched[19:15];
			decoded_rsrc2 <= mem_rdata_latched[24:20];
			if ((((mem_rdata_latched[6:0] == 7'b0001011) && (mem_rdata_latched[31:25] == 7'b0000000)) && ENABLE_IRQ) && ENABLE_IRQ_QREGS)
				decoded_rsrc1[REGINDEX_BITS - 1] <= 1;
			if (((mem_rdata_latched[6:0] == 7'b0001011) && (mem_rdata_latched[31:25] == 7'b0000010)) && ENABLE_IRQ)
				decoded_rsrc1 <= (ENABLE_IRQ_QREGS ? IRQREGS_OFFSET : 3);
			compressed_instr <= 0;
			if (COMPRESSED_ISA && (mem_rdata_latched[1:0] != 2'b11)) begin
				compressed_instr <= 1;
				decoded_rdst <= 0;
				decoded_rsrc1 <= 0;
				decoded_rsrc2 <= 0;
				{decoded_imm_uj[31:11], decoded_imm_uj[4], decoded_imm_uj[9:8], decoded_imm_uj[10], decoded_imm_uj[6], decoded_imm_uj[7], decoded_imm_uj[3:1], decoded_imm_uj[5], decoded_imm_uj[0]} <= sv2v_cast_32_signed($signed({mem_rdata_latched[12:2], 1'b0}));
				(* full_case, parallel_case *)
				case (mem_rdata_latched[1:0])
					2'b00:
						(* full_case, parallel_case *)
						case (mem_rdata_latched[15:13])
							3'b000: begin
								is_alu_reg_imm <= |mem_rdata_latched[12:5];
								decoded_rsrc1 <= 2;
								decoded_rdst <= 8 + mem_rdata_latched[4:2];
							end
							3'b010: begin
								is_lb_lh_lw_lbu_lhu <= 1;
								decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
								decoded_rdst <= 8 + mem_rdata_latched[4:2];
							end
							3'b110: begin
								is_sb_sh_sw <= 1;
								decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
								decoded_rsrc2 <= 8 + mem_rdata_latched[4:2];
							end
							default:
								;
						endcase
					2'b01:
						(* full_case, parallel_case *)
						case (mem_rdata_latched[15:13])
							3'b000: begin
								is_alu_reg_imm <= 1;
								decoded_rdst <= mem_rdata_latched[11:7];
								decoded_rsrc1 <= mem_rdata_latched[11:7];
							end
							3'b001: begin
								instr_jal <= 1;
								decoded_rdst <= 1;
							end
							3'b010: begin
								is_alu_reg_imm <= 1;
								decoded_rdst <= mem_rdata_latched[11:7];
								decoded_rsrc1 <= 0;
							end
							3'b011:
								if (mem_rdata_latched[12] || mem_rdata_latched[6:2]) begin
									if (mem_rdata_latched[11:7] == 2) begin
										is_alu_reg_imm <= 1;
										decoded_rdst <= mem_rdata_latched[11:7];
										decoded_rsrc1 <= mem_rdata_latched[11:7];
									end
									else begin
										instr_lui <= 1;
										decoded_rdst <= mem_rdata_latched[11:7];
										decoded_rsrc1 <= 0;
									end
								end
							3'b100: begin
								if (!mem_rdata_latched[11] && !mem_rdata_latched[12]) begin
									is_alu_reg_imm <= 1;
									decoded_rdst <= 8 + mem_rdata_latched[9:7];
									decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
									decoded_rsrc2 <= mem_rdata_latched[6:2];
								end
								if (mem_rdata_latched[11:10] == 2'b10) begin
									is_alu_reg_imm <= 1;
									decoded_rdst <= 8 + mem_rdata_latched[9:7];
									decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
								end
								if (mem_rdata_latched[12:10] == 3'b011) begin
									is_alu_reg_reg <= 1;
									decoded_rdst <= 8 + mem_rdata_latched[9:7];
									decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
									decoded_rsrc2 <= 8 + mem_rdata_latched[4:2];
								end
							end
							3'b101: instr_jal <= 1;
							3'b110: begin
								is_beq_bne_blt_bge_bltu_bgeu <= 1;
								decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
								decoded_rsrc2 <= 0;
							end
							3'b111: begin
								is_beq_bne_blt_bge_bltu_bgeu <= 1;
								decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
								decoded_rsrc2 <= 0;
							end
							default:
								;
						endcase
					2'b10:
						(* full_case, parallel_case *)
						case (mem_rdata_latched[15:13])
							3'b000:
								if (!mem_rdata_latched[12]) begin
									is_alu_reg_imm <= 1;
									decoded_rdst <= mem_rdata_latched[11:7];
									decoded_rsrc1 <= mem_rdata_latched[11:7];
									decoded_rsrc2 <= mem_rdata_latched[6:2];
								end
							3'b010:
								if (mem_rdata_latched[11:7]) begin
									is_lb_lh_lw_lbu_lhu <= 1;
									decoded_rdst <= mem_rdata_latched[11:7];
									decoded_rsrc1 <= 2;
								end
							3'b100: begin
								if (((mem_rdata_latched[12] == 0) && (mem_rdata_latched[11:7] != 0)) && (mem_rdata_latched[6:2] == 0)) begin
									instr_jalr <= 1;
									decoded_rdst <= 0;
									decoded_rsrc1 <= mem_rdata_latched[11:7];
								end
								if ((mem_rdata_latched[12] == 0) && (mem_rdata_latched[6:2] != 0)) begin
									is_alu_reg_reg <= 1;
									decoded_rdst <= mem_rdata_latched[11:7];
									decoded_rsrc1 <= 0;
									decoded_rsrc2 <= mem_rdata_latched[6:2];
								end
								if (((mem_rdata_latched[12] != 0) && (mem_rdata_latched[11:7] != 0)) && (mem_rdata_latched[6:2] == 0)) begin
									instr_jalr <= 1;
									decoded_rdst <= 1;
									decoded_rsrc1 <= mem_rdata_latched[11:7];
								end
								if ((mem_rdata_latched[12] != 0) && (mem_rdata_latched[6:2] != 0)) begin
									is_alu_reg_reg <= 1;
									decoded_rdst <= mem_rdata_latched[11:7];
									decoded_rsrc1 <= mem_rdata_latched[11:7];
									decoded_rsrc2 <= mem_rdata_latched[6:2];
								end
							end
							3'b110: begin
								is_sb_sh_sw <= 1;
								decoded_rsrc1 <= 2;
								decoded_rsrc2 <= mem_rdata_latched[6:2];
							end
							default:
								;
						endcase
					default:
						;
				endcase
			end
		end
		if (decoder_trigger && !decoder_pseudo_trigger) begin
			pcpi_insn <= (WITH_PCPI ? mem_rdata_q : 'bx);
			instr_beq <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b000);
			instr_bne <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b001);
			instr_blt <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b100);
			instr_bge <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b101);
			instr_bltu <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b110);
			instr_bgeu <= is_beq_bne_blt_bge_bltu_bgeu && (mem_rdata_q[14:12] == 3'b111);
			instr_lb <= is_lb_lh_lw_lbu_lhu && (mem_rdata_q[14:12] == 3'b000);
			instr_lh <= is_lb_lh_lw_lbu_lhu && (mem_rdata_q[14:12] == 3'b001);
			instr_lw <= is_lb_lh_lw_lbu_lhu && (mem_rdata_q[14:12] == 3'b010);
			instr_lbu <= is_lb_lh_lw_lbu_lhu && (mem_rdata_q[14:12] == 3'b100);
			instr_lhu <= is_lb_lh_lw_lbu_lhu && (mem_rdata_q[14:12] == 3'b101);
			instr_sb <= is_sb_sh_sw && (mem_rdata_q[14:12] == 3'b000);
			instr_sh <= is_sb_sh_sw && (mem_rdata_q[14:12] == 3'b001);
			instr_sw <= is_sb_sh_sw && (mem_rdata_q[14:12] == 3'b010);
			instr_addi <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b000);
			instr_slti <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b010);
			instr_sltiu <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b011);
			instr_xori <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b100);
			instr_ori <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b110);
			instr_andi <= is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b111);
			instr_slli <= (is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b001)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_srli <= (is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b101)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_srai <= (is_alu_reg_imm && (mem_rdata_q[14:12] == 3'b101)) && (mem_rdata_q[31:25] == 7'b0100000);
			instr_add <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b000)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_sub <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b000)) && (mem_rdata_q[31:25] == 7'b0100000);
			instr_sll <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b001)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_slt <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b010)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_sltu <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b011)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_xor <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b100)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_srl <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b101)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_sra <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b101)) && (mem_rdata_q[31:25] == 7'b0100000);
			instr_or <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b110)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_and <= (is_alu_reg_reg && (mem_rdata_q[14:12] == 3'b111)) && (mem_rdata_q[31:25] == 7'b0000000);
			instr_rdcycle <= (((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11000000000000000010)) || ((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11000000000100000010))) && ENABLE_COUNTERS;
			instr_rdcycleh <= ((((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11001000000000000010)) || ((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11001000000100000010))) && ENABLE_COUNTERS) && ENABLE_COUNTERS64;
			instr_rdinstr <= ((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11000000001000000010)) && ENABLE_COUNTERS;
			instr_rdinstrh <= (((mem_rdata_q[6:0] == 7'b1110011) && (mem_rdata_q[31:12] == 'b11001000001000000010)) && ENABLE_COUNTERS) && ENABLE_COUNTERS64;
			instr_ecall_ebreak <= (((mem_rdata_q[6:0] == 7'b1110011) && !mem_rdata_q[31:21]) && !mem_rdata_q[19:7]) || (COMPRESSED_ISA && (mem_rdata_q[15:0] == 16'h9002));
			instr_getq <= (((mem_rdata_q[6:0] == 7'b0001011) && (mem_rdata_q[31:25] == 7'b0000000)) && ENABLE_IRQ) && ENABLE_IRQ_QREGS;
			instr_setq <= (((mem_rdata_q[6:0] == 7'b0001011) && (mem_rdata_q[31:25] == 7'b0000001)) && ENABLE_IRQ) && ENABLE_IRQ_QREGS;
			instr_maskirq <= ((mem_rdata_q[6:0] == 7'b0001011) && (mem_rdata_q[31:25] == 7'b0000011)) && ENABLE_IRQ;
			instr_timer <= (((mem_rdata_q[6:0] == 7'b0001011) && (mem_rdata_q[31:25] == 7'b0000101)) && ENABLE_IRQ) && ENABLE_IRQ_TIMER;
			is_slli_srli_srai <= is_alu_reg_imm && |{(mem_rdata_q[14:12] == 3'b001) && (mem_rdata_q[31:25] == 7'b0000000), (mem_rdata_q[14:12] == 3'b101) && (mem_rdata_q[31:25] == 7'b0000000), (mem_rdata_q[14:12] == 3'b101) && (mem_rdata_q[31:25] == 7'b0100000)};
			is_jalr_addi_slti_sltiu_xori_ori_andi <= instr_jalr || (is_alu_reg_imm && |{mem_rdata_q[14:12] == 3'b000, mem_rdata_q[14:12] == 3'b010, mem_rdata_q[14:12] == 3'b011, mem_rdata_q[14:12] == 3'b100, mem_rdata_q[14:12] == 3'b110, mem_rdata_q[14:12] == 3'b111});
			is_sll_srl_sra <= is_alu_reg_reg && |{(mem_rdata_q[14:12] == 3'b001) && (mem_rdata_q[31:25] == 7'b0000000), (mem_rdata_q[14:12] == 3'b101) && (mem_rdata_q[31:25] == 7'b0000000), (mem_rdata_q[14:12] == 3'b101) && (mem_rdata_q[31:25] == 7'b0100000)};
			is_lui_auipc_jal_jalr_addi_add_sub <= 0;
			is_compare <= 0;
			(* full_case, parallel_case *)
			case (1'b1)
				instr_jal: decoded_imm <= decoded_imm_uj;
				|{instr_lui, instr_auipc}: decoded_imm <= mem_rdata_q[31:12] << 12;
				|{instr_jalr, is_lb_lh_lw_lbu_lhu, is_alu_reg_imm}: decoded_imm <= $signed(mem_rdata_q[31:20]);
				is_beq_bne_blt_bge_bltu_bgeu: decoded_imm <= $signed({mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8], 1'b0});
				is_sb_sh_sw: decoded_imm <= $signed({mem_rdata_q[31:25], mem_rdata_q[11:7]});
				default: decoded_imm <= 1'bx;
			endcase
		end
		if (!resetn) begin
			is_beq_bne_blt_bge_bltu_bgeu <= 0;
			is_compare <= 0;
			instr_beq <= 0;
			instr_bne <= 0;
			instr_blt <= 0;
			instr_bge <= 0;
			instr_bltu <= 0;
			instr_bgeu <= 0;
			instr_addi <= 0;
			instr_slti <= 0;
			instr_sltiu <= 0;
			instr_xori <= 0;
			instr_ori <= 0;
			instr_andi <= 0;
			instr_add <= 0;
			instr_sub <= 0;
			instr_sll <= 0;
			instr_slt <= 0;
			instr_sltu <= 0;
			instr_xor <= 0;
			instr_srl <= 0;
			instr_sra <= 0;
			instr_or <= 0;
			instr_and <= 0;
		end
	end
	reg [2:0] cpu_state;
	reg [1:0] irq_state;
	reg set_mem_do_rinst;
	reg set_mem_do_rdata;
	reg set_mem_do_wdata;
	reg latched_store;
	reg latched_stalu;
	reg latched_branch;
	reg latched_compr;
	reg latched_trace;
	reg latched_is_lu;
	reg latched_is_lh;
	reg latched_is_lb;
	reg [REGINDEX_BITS - 1:0] latched_rdst;
	reg [31:0] current_pc;
	assign next_pc = (latched_store & latched_branch ? reg_out & 32'hfffffffe : reg_next_pc);
	reg [3:0] pcpi_timeout_counter;
	reg pcpi_timeout;
	reg [31:0] next_irq_pending;
	reg do_waitirq;
	reg [31:0] alu_out;
	reg [31:0] alu_out_q;
	reg alu_out_0;
	reg alu_out_0_q;
	reg alu_wait;
	reg alu_wait_2;
	reg [31:0] alu_add_sub;
	reg [31:0] alu_shl;
	reg [31:0] alu_shr;
	reg alu_eq;
	reg alu_ltu;
	reg alu_lts;
	generate
		if (TWO_CYCLE_ALU) begin : _2cycle_alu
			always @(posedge clk) begin
				alu_add_sub <= (instr_sub ? reg_op1 - reg_op2 : reg_op1 + reg_op2);
				alu_eq <= reg_op1 == reg_op2;
				alu_lts <= $signed(reg_op1) < $signed(reg_op2);
				alu_ltu <= reg_op1 < reg_op2;
				alu_shl <= reg_op1 << reg_op2[4:0];
				alu_shr <= sv2v_cast_32_signed($signed({(instr_sra || instr_srai ? reg_op1[31] : 1'b0), reg_op1}) >>> reg_op2[4:0]);
			end
		end
		else begin : _1cycle_alu
			always @(*) begin
				alu_add_sub = (instr_sub ? reg_op1 - reg_op2 : reg_op1 + reg_op2);
				alu_eq = reg_op1 == reg_op2;
				alu_lts = $signed(reg_op1) < $signed(reg_op2);
				alu_ltu = reg_op1 < reg_op2;
				alu_shl = reg_op1 << reg_op2[4:0];
				alu_shr = sv2v_cast_32_signed($signed({(instr_sra || instr_srai ? reg_op1[31] : 1'b0), reg_op1}) >>> reg_op2[4:0]);
			end
		end
	endgenerate
	always @(*) begin
		alu_out_0 = 1'sbx;
		(* full_case, parallel_case *)
		case (1'b1)
			instr_beq: alu_out_0 = alu_eq;
			instr_bne: alu_out_0 = !alu_eq;
			instr_bge: alu_out_0 = !alu_lts;
			instr_bgeu: alu_out_0 = !alu_ltu;
			is_slti_blt_slt & (!TWO_CYCLE_COMPARE | ~{instr_beq, instr_bne, instr_bge, instr_bgeu}): alu_out_0 = alu_lts;
			is_sltiu_bltu_sltu && (!TWO_CYCLE_COMPARE | ~{instr_beq, instr_bne, instr_bge, instr_bgeu}): alu_out_0 = alu_ltu;
			default:
				;
		endcase
		alu_out = 'bx;
		(* full_case, parallel_case *)
		case (1'b1)
			is_lui_auipc_jal_jalr_addi_add_sub: alu_out = alu_add_sub;
			is_compare: alu_out = alu_out_0;
			instr_xori | instr_xor: alu_out = reg_op1 ^ reg_op2;
			instr_ori | instr_or: alu_out = reg_op1 | reg_op2;
			instr_andi | instr_and: alu_out = reg_op1 & reg_op2;
			BARREL_SHIFTER & (instr_sll | instr_slli): alu_out = alu_shl;
			BARREL_SHIFTER & (((instr_srl | instr_srli) | instr_sra) | instr_srai): alu_out = alu_shr;
			default:
				;
		endcase
	end
	reg clear_prefetched_high_word_q;
	always @(posedge clk) clear_prefetched_high_word_q <= clear_prefetched_high_word;
	always @(*) begin
		if (_sv2v_0)
			;
		clear_prefetched_high_word = clear_prefetched_high_word_q;
		if (!prefetched_high_word)
			clear_prefetched_high_word = 1'sb0;
		if ((latched_branch || (irq_state != {2 {1'sb0}})) || !resetn)
			clear_prefetched_high_word = COMPRESSED_ISA;
	end
	reg cpuregs_write;
	reg cpuregs_we;
	reg [31:0] cpuregs_wrdata;
	reg [31:0] cpuregs_rsrc1;
	reg [31:0] cpuregs_rsrc2;
	reg [REGINDEX_BITS - 1:0] decoded_rsrc;
	reg [31:0] wdat_branch;
	reg [31:0] wdat_store;
	reg [31:0] wdat_irq_pc;
	reg [31:0] wdat_irq;
	always @(*) begin
		if (_sv2v_0)
			;
		wdat_branch = reg_pc + (latched_compr ? 32'd2 : 32'd4);
		wdat_store = (latched_stalu ? alu_out_q : reg_out);
		wdat_irq_pc = reg_next_pc | {31'd0, latched_compr};
		wdat_irq = irq_pending & ~irq_mask;
		cpuregs_write = 1'b0;
		cpuregs_wrdata = 1'sbx;
		if (cpu_state == 3'd1)
			(* full_case, parallel_case *)
			case (1'b1)
				latched_branch: begin
					cpuregs_wrdata = wdat_branch;
					cpuregs_write = 1'b1;
				end
				~latched_branch & latched_store: begin
					cpuregs_wrdata = wdat_store;
					cpuregs_write = 1'b1;
				end
				ENABLE_IRQ & irq_state[0]: begin
					cpuregs_wrdata = wdat_irq_pc;
					cpuregs_write = 1'b1;
				end
				ENABLE_IRQ & irq_state[1]: begin
					cpuregs_wrdata = wdat_irq;
					cpuregs_write = 1'b1;
				end
				default:
					;
			endcase
		cpuregs_we = (resetn & cpuregs_write) & (latched_rdst != 0);
	end
	always @(posedge clk)
		if (cpuregs_we == 1'b1)
			cpuregs[latched_rdst] <= cpuregs_wrdata;
	always @(*) begin
		decoded_rsrc = 1'sbx;
		if (ENABLE_REGS_DUALPORT) begin
			cpuregs_rsrc1 = (decoded_rsrc1 != {REGINDEX_BITS {1'sb0}} ? cpuregs[decoded_rsrc1] : {32 {1'sb0}});
			cpuregs_rsrc2 = (decoded_rsrc2 != {REGINDEX_BITS {1'sb0}} ? cpuregs[decoded_rsrc2] : {32 {1'sb0}});
		end
		else begin
			decoded_rsrc = (cpu_state == 3'd3 ? decoded_rsrc2 : decoded_rsrc1);
			cpuregs_rsrc1 = (decoded_rsrc != {REGINDEX_BITS {1'sb0}} ? cpuregs[decoded_rsrc] : {32 {1'sb0}});
			cpuregs_rsrc2 = cpuregs_rsrc1;
		end
	end
	wire launch_next_insn;
	assign launch_next_insn = ((cpu_state == 3'd1) & decoder_trigger) & (((~ENABLE_IRQ | irq_delay) | irq_active) | ~(irq_pending & ~irq_mask));
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	always @(posedge clk) begin
		trap <= 1'sb0;
		reg_sh <= 1'sbx;
		reg_out <= 1'sbx;
		set_mem_do_rinst = 1'b0;
		set_mem_do_rdata = 1'b0;
		set_mem_do_wdata = 1'b0;
		alu_out_0_q <= alu_out_0;
		alu_out_q <= alu_out;
		alu_wait <= 1'sb0;
		alu_wait_2 <= 1'sb0;
		if (WITH_PCPI && CATCH_ILLINSN) begin
			if ((resetn && pcpi_valid) && !pcpi_int_wait) begin
				if (pcpi_timeout_counter)
					pcpi_timeout_counter <= pcpi_timeout_counter - 1;
			end
			else
				pcpi_timeout_counter <= ~0;
			pcpi_timeout <= !pcpi_timeout_counter;
		end
		if (ENABLE_COUNTERS) begin
			count_cycle <= (resetn ? count_cycle + 1 : 0);
			if (!ENABLE_COUNTERS64)
				count_cycle[63:32] <= 0;
		end
		else begin
			count_cycle <= 1'sbx;
			count_instr <= 1'sbx;
		end
		next_irq_pending = (ENABLE_IRQ ? irq_pending & LATCHED_IRQ : {32 {1'sbx}});
		if ((ENABLE_IRQ && ENABLE_IRQ_TIMER) && irq_timer) begin
			if ((irq_timer - 1) == {32 {1'sb0}})
				next_irq_pending[IRQ_TIMER] = 1'b1;
			irq_timer <= irq_timer - 1;
		end
		if (ENABLE_IRQ)
			next_irq_pending = next_irq_pending | irq;
		decoder_trigger <= mem_do_rinst & mem_done;
		decoder_trigger_q <= decoder_trigger;
		decoder_pseudo_trigger <= 1'sb0;
		decoder_pseudo_trigger_q <= decoder_pseudo_trigger;
		do_waitirq <= 1'sb0;
		trace_valid <= 1'sb0;
		if (!ENABLE_TRACE)
			trace_data <= 1'sbx;
		if (!resetn) begin
			reg_pc <= PROGADDR_RESET;
			reg_next_pc <= PROGADDR_RESET;
			if (ENABLE_COUNTERS)
				count_instr <= 1'sb0;
			latched_stalu <= 1'sb0;
			latched_branch <= 1'sb0;
			latched_trace <= 1'sb0;
			latched_is_lu <= 1'sb0;
			latched_is_lh <= 1'sb0;
			latched_is_lb <= 1'sb0;
			latched_store <= 1'b1;
			latched_rdst <= 2'd2;
			reg_out <= STACKADDR;
			pcpi_valid <= 1'sb0;
			pcpi_timeout <= 1'sb0;
			irq_active <= 1'sb0;
			irq_delay <= 1'sb0;
			irq_mask <= 1'sb1;
			irq_state <= 1'sb0;
			irq_timer <= 1'sb0;
			eoi <= 1'sb0;
			next_irq_pending = 1'sb0;
			cpu_state <= 3'd1;
		end
		else
			(* full_case, parallel_case *)
			case (cpu_state)
				3'd0: trap <= 1'b1;
				3'd1: begin
					mem_do_rinst <= ~decoder_trigger & ~do_waitirq;
					mem_wordsize <= 2'd0;
					current_pc = reg_next_pc;
					(* full_case, parallel_case *)
					case (1'b1)
						latched_branch & latched_store: current_pc = wdat_store & 32'hfffffffe;
						ENABLE_IRQ & irq_state[0]: begin
							current_pc = PROGADDR_IRQ;
							irq_active <= 1'b1;
							mem_do_rinst <= 1'b1;
						end
						ENABLE_IRQ & irq_state[1]: begin
							eoi <= wdat_irq;
							next_irq_pending = next_irq_pending & irq_mask;
						end
						default:
							;
					endcase
					if (ENABLE_TRACE && latched_trace) begin
						latched_trace <= 0;
						trace_valid <= 1;
						if (latched_branch)
							trace_data <= ((irq_active ? TRACE_IRQ : 36'd0) | TRACE_BRANCH) | (current_pc & 32'hfffffffe);
						else
							trace_data <= (irq_active ? TRACE_IRQ : 36'd0) | (latched_stalu ? alu_out_q : reg_out);
					end
					reg_pc <= current_pc;
					reg_next_pc <= current_pc;
					latched_store <= 1'sb0;
					latched_stalu <= 1'sb0;
					latched_branch <= 1'sb0;
					latched_is_lu <= 1'sb0;
					latched_is_lh <= 1'sb0;
					latched_is_lb <= 1'sb0;
					latched_rdst <= decoded_rdst;
					latched_compr <= compressed_instr;
					if (ENABLE_IRQ & ((((decoder_trigger & ~irq_active) & ~irq_delay) & |(irq_pending & ~irq_mask)) | (irq_state != {2 {1'sb0}}))) begin
						irq_state <= (irq_state == 2'b00 ? 2'b01 : (irq_state == 2'b01 ? 2'b10 : 2'b00));
						latched_compr <= latched_compr;
						if (ENABLE_IRQ_QREGS)
							latched_rdst <= IRQREGS_OFFSET | irq_state[0];
						else
							latched_rdst <= (irq_state[0] ? 4 : 3);
					end
					else if ((ENABLE_IRQ && (decoder_trigger || do_waitirq)) && instr_waitirq) begin
						if (irq_pending) begin
							latched_store <= 1'b1;
							reg_out <= irq_pending;
							reg_next_pc <= current_pc + (compressed_instr ? 2 : 4);
							mem_do_rinst <= 1'b1;
						end
						else
							do_waitirq <= 1'b1;
					end
					else if (decoder_trigger == 1'b1) begin
						irq_delay <= irq_active;
						reg_next_pc <= current_pc + (compressed_instr ? 2 : 4);
						if (ENABLE_TRACE)
							latched_trace <= 1;
						if (ENABLE_COUNTERS) begin
							count_instr <= count_instr + 1;
							if (!ENABLE_COUNTERS64)
								count_instr[63:32] <= 0;
						end
						if (instr_jal) begin
							mem_do_rinst <= 1'b1;
							reg_next_pc <= current_pc + decoded_imm_uj;
							latched_branch <= 1'b1;
						end
						else begin
							mem_do_rinst <= 1'b0;
							mem_do_prefetch <= ~instr_jalr & ~instr_retirq;
							cpu_state <= 3'd2;
						end
					end
				end
				3'd2: begin
					reg_op1 <= 1'sbx;
					reg_op2 <= 1'sbx;
					(* full_case, parallel_case *)
					case (1'b1)
						(CATCH_ILLINSN || WITH_PCPI) && instr_trap:
							if (WITH_PCPI) begin
								reg_op1 <= cpuregs_rsrc1;
								if (ENABLE_REGS_DUALPORT) begin
									pcpi_valid <= 1;
									reg_sh <= cpuregs_rsrc2;
									reg_op2 <= cpuregs_rsrc2;
									if (pcpi_int_ready) begin
										mem_do_rinst <= 1;
										pcpi_valid <= 0;
										reg_out <= pcpi_int_rdst;
										latched_store <= pcpi_int_wr;
										cpu_state <= 3'd1;
									end
									else if (CATCH_ILLINSN && (pcpi_timeout || instr_ecall_ebreak)) begin
										pcpi_valid <= 1'sb0;
										if ((ENABLE_IRQ && !irq_mask[IRQ_EBREAK]) && !irq_active) begin
											next_irq_pending[IRQ_EBREAK] = 1'b1;
											cpu_state <= 3'd1;
										end
										else
											cpu_state <= 3'd0;
									end
								end
								else
									cpu_state <= 3'd3;
							end
							else if ((ENABLE_IRQ && !irq_mask[IRQ_EBREAK]) && !irq_active) begin
								next_irq_pending[IRQ_EBREAK] = 1'b1;
								cpu_state <= 3'd1;
							end
							else
								cpu_state <= 3'd0;
						ENABLE_COUNTERS & is_rdcycle_rdcycleh_rdinstr_rdinstrh: begin
							(* full_case, parallel_case *)
							case (1'b1)
								instr_rdcycle: reg_out <= count_cycle[31:0];
								instr_rdcycleh && ENABLE_COUNTERS64: reg_out <= count_cycle[63:32];
								instr_rdinstr: reg_out <= count_instr[31:0];
								instr_rdinstrh && ENABLE_COUNTERS64: reg_out <= count_instr[63:32];
								default:
									;
							endcase
							latched_store <= 1;
							cpu_state <= 3'd1;
						end
						is_lui_auipc_jal: begin
							reg_op1 <= (instr_lui ? 0 : reg_pc);
							reg_op2 <= decoded_imm;
							if (TWO_CYCLE_ALU)
								alu_wait <= 1;
							else
								mem_do_rinst <= mem_do_prefetch;
							cpu_state <= 3'd4;
						end
						(ENABLE_IRQ && ENABLE_IRQ_QREGS) && instr_getq: begin
							reg_out <= cpuregs_rsrc1;
							latched_store <= 1;
							cpu_state <= 3'd1;
						end
						(ENABLE_IRQ && ENABLE_IRQ_QREGS) && instr_setq: begin
							reg_out <= cpuregs_rsrc1;
							latched_rdst <= latched_rdst | IRQREGS_OFFSET;
							latched_store <= 1;
							cpu_state <= 3'd1;
						end
						ENABLE_IRQ && instr_retirq: begin
							reg_out <= (CATCH_MISALIGN ? cpuregs_rsrc1 & 32'hfffffffe : cpuregs_rsrc1);
							eoi <= 0;
							irq_active <= 0;
							latched_branch <= 1;
							latched_store <= 1;
							cpu_state <= 3'd1;
						end
						ENABLE_IRQ && instr_maskirq: begin
							latched_store <= 1;
							reg_out <= irq_mask;
							irq_mask <= cpuregs_rsrc1 | MASKED_IRQ;
							cpu_state <= 3'd1;
						end
						(ENABLE_IRQ && ENABLE_IRQ_TIMER) && instr_timer: begin
							latched_store <= 1;
							reg_out <= irq_timer;
							irq_timer <= cpuregs_rsrc1;
							cpu_state <= 3'd1;
						end
						is_lb_lh_lw_lbu_lhu && !instr_trap: begin
							reg_op1 <= cpuregs_rsrc1;
							cpu_state <= 3'd7;
							mem_do_rinst <= 1;
						end
						is_slli_srli_srai && !BARREL_SHIFTER: begin
							reg_op1 <= cpuregs_rsrc1;
							reg_sh <= decoded_rsrc2;
							cpu_state <= 3'd5;
						end
						is_jalr_addi_slti_sltiu_xori_ori_andi, is_slli_srli_srai && BARREL_SHIFTER: begin
							reg_op1 <= cpuregs_rsrc1;
							reg_op2 <= (is_slli_srli_srai && BARREL_SHIFTER ? decoded_rsrc2 : decoded_imm);
							if (TWO_CYCLE_ALU)
								alu_wait <= 1;
							else
								mem_do_rinst <= mem_do_prefetch;
							cpu_state <= 3'd4;
						end
						default: begin
							reg_op1 <= cpuregs_rsrc1;
							if (ENABLE_REGS_DUALPORT) begin
								reg_sh <= cpuregs_rsrc2[4:0];
								reg_op2 <= cpuregs_rsrc2;
								(* full_case, parallel_case *)
								case (1'b1)
									is_sb_sh_sw: begin
										cpu_state <= 3'd6;
										mem_do_rinst <= 1;
									end
									is_sll_srl_sra && !BARREL_SHIFTER: cpu_state <= 3'd5;
									default: begin
										if (TWO_CYCLE_ALU || (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu)) begin
											alu_wait_2 <= TWO_CYCLE_ALU && (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu);
											alu_wait <= 1;
										end
										else
											mem_do_rinst <= mem_do_prefetch;
										cpu_state <= 3'd4;
									end
								endcase
							end
							else
								cpu_state <= 3'd3;
						end
					endcase
				end
				3'd3: begin
					reg_sh <= cpuregs_rsrc2[4:0];
					reg_op2 <= cpuregs_rsrc2;
					(* full_case, parallel_case *)
					case (1'b1)
						WITH_PCPI && instr_trap: begin
							pcpi_valid <= 1;
							if (pcpi_int_ready) begin
								mem_do_rinst <= 1;
								pcpi_valid <= 0;
								reg_out <= pcpi_int_rdst;
								latched_store <= pcpi_int_wr;
								cpu_state <= 3'd1;
							end
							else if (CATCH_ILLINSN && (pcpi_timeout || instr_ecall_ebreak)) begin
								pcpi_valid <= 0;
								if ((ENABLE_IRQ && !irq_mask[IRQ_EBREAK]) && !irq_active) begin
									next_irq_pending[IRQ_EBREAK] = 1'b1;
									cpu_state <= 3'd1;
								end
								else
									cpu_state <= 3'd0;
							end
						end
						is_sb_sh_sw: begin
							cpu_state <= 3'd6;
							mem_do_rinst <= 1;
						end
						is_sll_srl_sra && !BARREL_SHIFTER: cpu_state <= 3'd5;
						default: begin
							if (TWO_CYCLE_ALU || (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu)) begin
								alu_wait_2 <= TWO_CYCLE_ALU && (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu);
								alu_wait <= 1;
							end
							else
								mem_do_rinst <= mem_do_prefetch;
							cpu_state <= 3'd4;
						end
					endcase
				end
				3'd4: begin
					reg_out <= reg_pc + decoded_imm;
					if ((TWO_CYCLE_ALU || TWO_CYCLE_COMPARE) && (alu_wait || alu_wait_2)) begin
						mem_do_rinst <= mem_do_prefetch && !alu_wait_2;
						alu_wait <= alu_wait_2;
					end
					else if (is_beq_bne_blt_bge_bltu_bgeu) begin
						latched_rdst <= 1'sb0;
						latched_store <= (TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0);
						latched_branch <= (TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0);
						if (mem_done)
							cpu_state <= 3'd1;
						if ((TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0)) begin
							decoder_trigger <= 1'b0;
							set_mem_do_rinst = 1'b1;
						end
					end
					else begin
						latched_branch <= instr_jalr;
						latched_store <= 1'b1;
						latched_stalu <= 1'b1;
						cpu_state <= 3'd1;
					end
				end
				3'd5: begin
					latched_store <= 1'b1;
					if (reg_sh == 0) begin
						reg_out <= reg_op1;
						mem_do_rinst <= mem_do_prefetch;
						cpu_state <= 3'd1;
					end
					else if (TWO_STAGE_SHIFT && (reg_sh >= 4)) begin
						(* full_case, parallel_case *)
						case (1'b1)
							instr_slli || instr_sll: reg_op1 <= reg_op1 << 4;
							instr_srli || instr_srl: reg_op1 <= reg_op1 >> 4;
							instr_srai || instr_sra: reg_op1 <= $signed(reg_op1) >>> 4;
							default:
								;
						endcase
						reg_sh <= sv2v_cast_5(reg_sh - 4);
					end
					else begin
						(* full_case, parallel_case *)
						case (1'b1)
							instr_slli || instr_sll: reg_op1 <= reg_op1 << 1;
							instr_srli || instr_srl: reg_op1 <= reg_op1 >> 1;
							instr_srai || instr_sra: reg_op1 <= $signed(reg_op1) >>> 1;
							default:
								;
						endcase
						reg_sh <= sv2v_cast_5(reg_sh - 1);
					end
				end
				3'd6: begin
					if (ENABLE_TRACE)
						reg_out <= reg_op2;
					if (!mem_do_prefetch || mem_done) begin
						if (!mem_do_wdata) begin
							(* full_case, parallel_case *)
							case (1'b1)
								instr_sb: mem_wordsize <= 2'd2;
								instr_sh: mem_wordsize <= 2'd1;
								instr_sw: mem_wordsize <= 2'd0;
								default:
									;
							endcase
							if (ENABLE_TRACE) begin
								trace_valid <= 1'b1;
								trace_data <= ((irq_active ? TRACE_IRQ : 36'd0) | TRACE_ADDR) | ((reg_op1 + decoded_imm) & 32'hffffffff);
							end
							reg_op1 <= reg_op1 + decoded_imm;
							set_mem_do_wdata = 1'b1;
						end
						if (!mem_do_prefetch && mem_done) begin
							cpu_state <= 3'd1;
							decoder_trigger <= 1;
							decoder_pseudo_trigger <= 1;
						end
					end
				end
				3'd7: begin
					latched_store <= 1;
					if (!mem_do_prefetch || mem_done) begin
						if (!mem_do_rdata) begin
							(* full_case, parallel_case *)
							case (1'b1)
								instr_lb | instr_lbu: mem_wordsize <= 2'd2;
								instr_lh | instr_lhu: mem_wordsize <= 2'd1;
								instr_lw: mem_wordsize <= 2'd0;
								default:
									;
							endcase
							latched_is_lu <= is_lbu_lhu_lw;
							latched_is_lh <= instr_lh;
							latched_is_lb <= instr_lb;
							if (ENABLE_TRACE) begin
								trace_valid <= 1;
								trace_data <= ((irq_active ? TRACE_IRQ : 36'd0) | TRACE_ADDR) | ((reg_op1 + decoded_imm) & 32'hffffffff);
							end
							reg_op1 <= reg_op1 + decoded_imm;
							set_mem_do_rdata = 1'b1;
						end
						if (!mem_do_prefetch && mem_done) begin
							(* full_case, parallel_case *)
							case (1'b1)
								latched_is_lu: reg_out <= mem_rdata_word;
								latched_is_lh: reg_out <= $signed(mem_rdata_word[15:0]);
								latched_is_lb: reg_out <= $signed(mem_rdata_word[7:0]);
								default:
									;
							endcase
							decoder_trigger <= 1;
							decoder_pseudo_trigger <= 1;
							cpu_state <= 3'd1;
						end
					end
				end
				default:
					;
			endcase
		if ((CATCH_MISALIGN && resetn) && (mem_do_rdata || mem_do_wdata)) begin
			if ((mem_wordsize == 2'd0) && (reg_op1[1:0] != {2 {1'sb0}})) begin
				if ((ENABLE_IRQ && !irq_mask[IRQ_BUSERROR]) && !irq_active)
					next_irq_pending[IRQ_BUSERROR] = 1'b1;
				else
					cpu_state <= 3'd0;
			end
			if ((mem_wordsize == 2'd1) & (reg_op1[0] != 1'b0)) begin
				if ((ENABLE_IRQ && !irq_mask[IRQ_BUSERROR]) && !irq_active)
					next_irq_pending[IRQ_BUSERROR] = 1'b1;
				else
					cpu_state <= 3'd0;
			end
		end
		if (((CATCH_MISALIGN && resetn) && mem_do_rinst) && (COMPRESSED_ISA ? reg_pc[0] : |reg_pc[1:0])) begin
			if ((ENABLE_IRQ && !irq_mask[IRQ_BUSERROR]) && !irq_active)
				next_irq_pending[IRQ_BUSERROR] = 1'b1;
			else
				cpu_state <= 3'd0;
		end
		if (((!CATCH_ILLINSN && decoder_trigger_q) && !decoder_pseudo_trigger_q) && instr_ecall_ebreak)
			cpu_state <= 3'd0;
		if (!resetn || mem_done) begin
			mem_do_prefetch <= 1'b0;
			mem_do_rinst <= 1'b0;
			mem_do_rdata <= 1'b0;
			mem_do_wdata <= 1'b0;
		end
		if (set_mem_do_rinst)
			mem_do_rinst <= 1'b1;
		if (set_mem_do_rdata)
			mem_do_rdata <= 1'b1;
		if (set_mem_do_wdata)
			mem_do_wdata <= 1'b1;
		irq_pending <= next_irq_pending & ~MASKED_IRQ;
		if (!CATCH_MISALIGN) begin
			if (COMPRESSED_ISA) begin
				reg_pc[0] <= 1'sb0;
				reg_next_pc[0] <= 1'sb0;
			end
			else begin
				reg_pc[1:0] <= 1'sb0;
				reg_next_pc[1:0] <= 1'sb0;
			end
		end
		current_pc = 1'sbx;
	end
	initial _sv2v_0 = 0;
endmodule
module picorv32_pcpi_mul (
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
	parameter STEPS_AT_ONCE = 1;
	parameter CARRY_CHAIN = 4;
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
	reg instr_mul;
	reg instr_mulh;
	reg instr_mulhsu;
	reg instr_mulhu;
	wire instr_any_mul = |{instr_mul, instr_mulh, instr_mulhsu, instr_mulhu};
	wire instr_any_mulh = |{instr_mulh, instr_mulhsu, instr_mulhu};
	wire instr_rs1_signed = |{instr_mulh, instr_mulhsu};
	wire instr_rs2_signed = |{instr_mulh};
	reg pcpi_wait_q;
	wire mul_start = pcpi_wait && !pcpi_wait_q;
	always @(posedge clk) begin
		instr_mul <= 0;
		instr_mulh <= 0;
		instr_mulhsu <= 0;
		instr_mulhu <= 0;
		if (((resetn && pcpi_valid) && (pcpi_insn[6:0] == 7'b0110011)) && (pcpi_insn[31:25] == 7'b0000001))
			(* full_case, parallel_case *)
			case (pcpi_insn[14:12])
				3'b000: instr_mul <= 1;
				3'b001: instr_mulh <= 1;
				3'b010: instr_mulhsu <= 1;
				3'b011: instr_mulhu <= 1;
				default:
					;
			endcase
		pcpi_wait <= instr_any_mul;
		pcpi_wait_q <= pcpi_wait;
	end
	reg [63:0] rs1;
	reg [63:0] rs2;
	reg [63:0] rd;
	reg [63:0] rdx;
	reg [63:0] next_rs1;
	reg [63:0] next_rs2;
	reg [63:0] this_rs2;
	reg [63:0] next_rd;
	reg [63:0] next_rdx;
	reg [63:0] next_rdt;
	reg [6:0] mul_counter;
	reg mul_waiting;
	reg mul_finish;
	integer i;
	integer j;
	always @(*) begin
		next_rd = rd;
		next_rdx = rdx;
		next_rs1 = rs1;
		next_rs2 = rs2;
		for (i = 0; i < STEPS_AT_ONCE; i = i + 1)
			begin
				this_rs2 = (next_rs1[0] ? next_rs2 : 0);
				if (CARRY_CHAIN == 0) begin
					next_rdt = (next_rd ^ next_rdx) ^ this_rs2;
					next_rdx = (((next_rd & next_rdx) | (next_rd & this_rs2)) | (next_rdx & this_rs2)) << 1;
					next_rd = next_rdt;
				end
				else begin
					next_rdt = 0;
					for (j = 0; j < 64; j = j + CARRY_CHAIN)
						{next_rdt[(j + CARRY_CHAIN) - 1], next_rd[j+:CARRY_CHAIN]} = (next_rd[j+:CARRY_CHAIN] + next_rdx[j+:CARRY_CHAIN]) + this_rs2[j+:CARRY_CHAIN];
					next_rdx = next_rdt << 1;
				end
				next_rs1 = next_rs1 >> 1;
				next_rs2 = next_rs2 << 1;
			end
	end
	always @(posedge clk) begin
		mul_finish <= 0;
		if (!resetn)
			mul_waiting <= 1;
		else if (mul_waiting) begin
			if (instr_rs1_signed)
				rs1 <= $signed(pcpi_rs1);
			else
				rs1 <= $unsigned(pcpi_rs1);
			if (instr_rs2_signed)
				rs2 <= $signed(pcpi_rs2);
			else
				rs2 <= $unsigned(pcpi_rs2);
			rd <= 0;
			rdx <= 0;
			mul_counter <= (instr_any_mulh ? 63 - STEPS_AT_ONCE : 31 - STEPS_AT_ONCE);
			mul_waiting <= !mul_start;
		end
		else begin
			rd <= next_rd;
			rdx <= next_rdx;
			rs1 <= next_rs1;
			rs2 <= next_rs2;
			mul_counter <= mul_counter - STEPS_AT_ONCE;
			if (mul_counter[6]) begin
				mul_finish <= 1;
				mul_waiting <= 1;
			end
		end
	end
	always @(posedge clk) begin
		pcpi_wr <= 0;
		pcpi_ready <= 0;
		if (mul_finish && resetn) begin
			pcpi_wr <= 1;
			pcpi_ready <= 1;
			pcpi_rd <= (instr_any_mulh ? rd >> 32 : rd);
		end
	end
endmodule
module picorv32_pcpi_fast_mul (
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
	parameter EXTRA_MUL_FFS = 0;
	parameter EXTRA_INSN_FFS = 0;
	parameter MUL_CLKGATE = 0;
	input clk;
	input resetn;
	input pcpi_valid;
	input [31:0] pcpi_insn;
	input [31:0] pcpi_rs1;
	input [31:0] pcpi_rs2;
	output wire pcpi_wr;
	output wire [31:0] pcpi_rd;
	output wire pcpi_wait;
	output wire pcpi_ready;
	reg instr_mul;
	reg instr_mulh;
	reg instr_mulhsu;
	reg instr_mulhu;
	wire instr_any_mul = |{instr_mul, instr_mulh, instr_mulhsu, instr_mulhu};
	wire instr_any_mulh = |{instr_mulh, instr_mulhsu, instr_mulhu};
	wire instr_rs1_signed = |{instr_mulh, instr_mulhsu};
	wire instr_rs2_signed = |{instr_mulh};
	reg shift_out;
	reg [3:0] active;
	reg [32:0] rs1;
	reg [32:0] rs2;
	reg [32:0] rs1_q;
	reg [32:0] rs2_q;
	reg [63:0] rd;
	reg [63:0] rd_q;
	wire pcpi_insn_valid = (pcpi_valid && (pcpi_insn[6:0] == 7'b0110011)) && (pcpi_insn[31:25] == 7'b0000001);
	reg pcpi_insn_valid_q;
	always @(*) begin
		instr_mul = 0;
		instr_mulh = 0;
		instr_mulhsu = 0;
		instr_mulhu = 0;
		if (resetn && (EXTRA_INSN_FFS ? pcpi_insn_valid_q : pcpi_insn_valid))
			(* full_case, parallel_case *)
			case (pcpi_insn[14:12])
				3'b000: instr_mul = 1;
				3'b001: instr_mulh = 1;
				3'b010: instr_mulhsu = 1;
				3'b011: instr_mulhu = 1;
				default:
					;
			endcase
	end
	always @(posedge clk) begin
		pcpi_insn_valid_q <= pcpi_insn_valid;
		if (!MUL_CLKGATE || active[0]) begin
			rs1_q <= rs1;
			rs2_q <= rs2;
		end
		if (!MUL_CLKGATE || active[1])
			rd <= $signed((EXTRA_MUL_FFS ? rs1_q : rs1)) * $signed((EXTRA_MUL_FFS ? rs2_q : rs2));
		if (!MUL_CLKGATE || active[2])
			rd_q <= rd;
	end
	always @(posedge clk) begin
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
		end
		else
			active[0] <= 0;
		active[3:1] <= active;
		shift_out <= instr_any_mulh;
		if (!resetn)
			active <= 0;
	end
	assign pcpi_wr = active[(EXTRA_MUL_FFS ? 3 : 1)];
	assign pcpi_wait = 0;
	assign pcpi_ready = active[(EXTRA_MUL_FFS ? 3 : 1)];
	assign pcpi_rd = (shift_out ? (EXTRA_MUL_FFS ? rd_q : rd) >> 32 : (EXTRA_MUL_FFS ? rd_q : rd));
endmodule
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
module imem (
	clk,
	arst_n,
	rvld,
	rrdy,
	raddr,
	rdat,
	we,
	waddr,
	wdat
);
	parameter signed [31:0] NUM_WORDS = 8192;
	input wire clk;
	input wire arst_n;
	input wire rvld;
	output reg rrdy;
	input wire [31:2] raddr;
	output reg [31:0] rdat;
	input wire we;
	input wire [31:2] waddr;
	input wire [31:0] wdat;
	localparam ADDR_MSB = $clog2(NUM_WORDS) + 1;
	reg [31:0] mem [0:NUM_WORDS - 1];
	wire [ADDR_MSB:2] raddr_int;
	wire [ADDR_MSB:2] waddr_int;
	assign raddr_int = raddr[ADDR_MSB:2];
	assign waddr_int = waddr[ADDR_MSB:2];
	initial begin
		mem['h0] = 32'h00001517;
		mem['h1] = 32'h23050513;
		mem['h2] = 32'h10000597;
		mem['h3] = 32'hff858593;
		mem['h4] = 32'h10000617;
		mem['h5] = 32'h00860613;
		mem['h6] = 32'h00c5dc63;
		mem['h7] = 32'h00052683;
		mem['h8] = 32'h00d5a023;
		mem['h9] = 32'h00450513;
		mem['ha] = 32'h00458593;
		mem['hb] = 32'hfec5c8e3;
		mem['hc] = 32'h10000517;
		mem['hd] = 32'hfe850513;
		mem['he] = 32'h10001597;
		mem['hf] = 32'h3f458593;
		mem['h10] = 32'h00b55863;
		mem['h11] = 32'h00052023;
		mem['h12] = 32'h00450513;
		mem['h13] = 32'hfeb54ce3;
		mem['h14] = 32'h10008117;
		mem['h15] = 32'hfb010113;
		mem['h16] = 32'h10000197;
		mem['h17] = 32'h7c018193;
		mem['h18] = 32'h00a54533;
		mem['h19] = 32'h00b5c5b3;
		mem['h1a] = 32'h00c64633;
		mem['h1b] = 32'h530000ef;
		mem['h1c] = 32'h0000006f;
		mem['h1d] = 32'h00452783;
		mem['h1e] = 32'h0087a783;
		mem['h1f] = 32'h0007a783;
		mem['h20] = 32'h0007a783;
		mem['h21] = 32'hfe07c8e3;
		mem['h22] = 32'h00452783;
		mem['h23] = 32'h0087a783;
		mem['h24] = 32'h0007a783;
		mem['h25] = 32'h00b78023;
		mem['h26] = 32'h00008067;
		mem['h27] = 32'h0a058a63;
		mem['h28] = 32'hfe010113;
		mem['h29] = 32'h00912a23;
		mem['h2a] = 32'h00058493;
		mem['h2b] = 32'h01212823;
		mem['h2c] = 32'h00a00593;
		mem['h2d] = 32'h00050913;
		mem['h2e] = 32'h00048513;
		mem['h2f] = 32'h00812c23;
		mem['h30] = 32'h00112e23;
		mem['h31] = 32'h01312623;
		mem['h32] = 32'h01412423;
		mem['h33] = 32'h701000ef;
		mem['h34] = 32'h01051513;
		mem['h35] = 32'h01055513;
		mem['h36] = 32'h00100413;
		mem['h37] = 32'h06857e63;
		mem['h38] = 32'h00900a13;
		mem['h39] = 32'h00040593;
		mem['h3a] = 32'h00048513;
		mem['h3b] = 32'h6e1000ef;
		mem['h3c] = 32'h03050593;
		mem['h3d] = 32'h0ff5f593;
		mem['h3e] = 32'h00090513;
		mem['h3f] = 32'hf79ff0ef;
		mem['h40] = 32'h00040593;
		mem['h41] = 32'h00048513;
		mem['h42] = 32'h70d000ef;
		mem['h43] = 32'h01051493;
		mem['h44] = 32'h00a00593;
		mem['h45] = 32'h00040513;
		mem['h46] = 32'h6b5000ef;
		mem['h47] = 32'h00040993;
		mem['h48] = 32'h01051413;
		mem['h49] = 32'h0104d493;
		mem['h4a] = 32'h01045413;
		mem['h4b] = 32'hfb3a6ce3;
		mem['h4c] = 32'h01c12083;
		mem['h4d] = 32'h01812403;
		mem['h4e] = 32'h01412483;
		mem['h4f] = 32'h01012903;
		mem['h50] = 32'h00c12983;
		mem['h51] = 32'h00812a03;
		mem['h52] = 32'h02010113;
		mem['h53] = 32'h00008067;
		mem['h54] = 32'h03000593;
		mem['h55] = 32'hf21ff06f;
		mem['h56] = 32'h00241793;
		mem['h57] = 32'h00f40433;
		mem['h58] = 32'h00141413;
		mem['h59] = 32'h01041413;
		mem['h5a] = 32'h01045413;
		mem['h5b] = 32'hf71ff06f;
		mem['h5c] = 32'hff010113;
		mem['h5d] = 32'h00812423;
		mem['h5e] = 32'h00912223;
		mem['h5f] = 32'h00112623;
		mem['h60] = 32'h00050493;
		mem['h61] = 32'h00058413;
		mem['h62] = 32'h00044583;
		mem['h63] = 32'h00058a63;
		mem['h64] = 32'h00048513;
		mem['h65] = 32'h00140413;
		mem['h66] = 32'heddff0ef;
		mem['h67] = 32'hfedff06f;
		mem['h68] = 32'h00c12083;
		mem['h69] = 32'h00812403;
		mem['h6a] = 32'h00412483;
		mem['h6b] = 32'h01010113;
		mem['h6c] = 32'h00008067;
		mem['h6d] = 32'hff010113;
		mem['h6e] = 32'h00112623;
		mem['h6f] = 32'h00812423;
		mem['h70] = 32'h00912223;
		mem['h71] = 32'h00058493;
		mem['h72] = 32'h0005c583;
		mem['h73] = 32'h00050413;
		mem['h74] = 32'hecdff0ef;
		mem['h75] = 32'h00040513;
		mem['h76] = 32'h02e00593;
		mem['h77] = 32'he99ff0ef;
		mem['h78] = 32'h0014c583;
		mem['h79] = 32'h00040513;
		mem['h7a] = 32'heb5ff0ef;
		mem['h7b] = 32'h00040513;
		mem['h7c] = 32'h02e00593;
		mem['h7d] = 32'he81ff0ef;
		mem['h7e] = 32'h0024c583;
		mem['h7f] = 32'h00040513;
		mem['h80] = 32'he9dff0ef;
		mem['h81] = 32'h00040513;
		mem['h82] = 32'h02e00593;
		mem['h83] = 32'he69ff0ef;
		mem['h84] = 32'h00040513;
		mem['h85] = 32'h00812403;
		mem['h86] = 32'h0034c583;
		mem['h87] = 32'h00c12083;
		mem['h88] = 32'h00412483;
		mem['h89] = 32'h01010113;
		mem['h8a] = 32'he75ff06f;
		mem['h8b] = 32'h00100613;
		mem['h8c] = 32'h00010837;
		mem['h8d] = 32'h00050713;
		mem['h8e] = 32'h00000793;
		mem['h8f] = 32'h40a60633;
		mem['h90] = 32'hfff80893;
		mem['h91] = 32'h00e606b3;
		mem['h92] = 32'h02b6f663;
		mem['h93] = 32'h00074683;
		mem['h94] = 32'h00174303;
		mem['h95] = 32'h00869693;
		mem['h96] = 32'h0066e6b3;
		mem['h97] = 32'h00d787b3;
		mem['h98] = 32'h0107e663;
		mem['h99] = 32'h0117f7b3;
		mem['h9a] = 32'h00178793;
		mem['h9b] = 32'h00270713;
		mem['h9c] = 32'hfd5ff06f;
		mem['h9d] = 32'hffe5f713;
		mem['h9e] = 32'h02b77463;
		mem['h9f] = 32'h00e50533;
		mem['ha0] = 32'h00054703;
		mem['ha1] = 32'h00871713;
		mem['ha2] = 32'h00e787b3;
		mem['ha3] = 32'h00010737;
		mem['ha4] = 32'h00e7e863;
		mem['ha5] = 32'h01079793;
		mem['ha6] = 32'h0107d793;
		mem['ha7] = 32'h00178793;
		mem['ha8] = 32'hfff7c513;
		mem['ha9] = 32'h01051513;
		mem['haa] = 32'h01055513;
		mem['hab] = 32'h00008067;
		mem['hac] = 32'h100016b7;
		mem['had] = 32'h4286a703;
		mem['hae] = 32'h100017b7;
		mem['haf] = 32'hc2878793;
		mem['hb0] = 32'h00f707b3;
		mem['hb1] = 32'h00a70733;
		mem['hb2] = 32'h42e6a423;
		mem['hb3] = 32'h000016b7;
		mem['hb4] = 32'h80068693;
		mem['hb5] = 32'h00e6d463;
		mem['hb6] = 32'h00100073;
		mem['hb7] = 32'h00078513;
		mem['hb8] = 32'h00008067;
		mem['hb9] = 32'hff010113;
		mem['hba] = 32'h00812423;
		mem['hbb] = 32'h00001437;
		mem['hbc] = 32'h07840413;
		mem['hbd] = 32'h0045d793;
		mem['hbe] = 32'h00f407b3;
		mem['hbf] = 32'h00912223;
		mem['hc0] = 32'h00058493;
		mem['hc1] = 32'h0007c583;
		mem['hc2] = 32'h00f4f493;
		mem['hc3] = 32'h01212023;
		mem['hc4] = 32'h00112623;
		mem['hc5] = 32'h00050913;
		mem['hc6] = 32'h00940433;
		mem['hc7] = 32'hd59ff0ef;
		mem['hc8] = 32'h00044583;
		mem['hc9] = 32'h00812403;
		mem['hca] = 32'h00c12083;
		mem['hcb] = 32'h00412483;
		mem['hcc] = 32'h00090513;
		mem['hcd] = 32'h00012903;
		mem['hce] = 32'h01010113;
		mem['hcf] = 32'hd39ff06f;
		mem['hd0] = 32'h00052783;
		mem['hd1] = 32'h0007a783;
		mem['hd2] = 32'h0187a783;
		mem['hd3] = 32'h0007a783;
		mem['hd4] = 32'h0007a783;
		mem['hd5] = 32'h0017f793;
		mem['hd6] = 32'h1e078e63;
		mem['hd7] = 32'h00052783;
		mem['hd8] = 32'hffff8637;
		mem['hd9] = 32'hffff08b7;
		mem['hda] = 32'h0007a783;
		mem['hdb] = 32'hfff60613;
		mem['hdc] = 32'h0107a783;
		mem['hdd] = 32'h0007a683;
		mem['hde] = 32'h0005c783;
		mem['hdf] = 32'h0077f713;
		mem['he0] = 32'h0006a783;
		mem['he1] = 32'hff87f793;
		mem['he2] = 32'h00e7e7b3;
		mem['he3] = 32'h00f6a023;
		mem['he4] = 32'h00052783;
		mem['he5] = 32'h0007a783;
		mem['he6] = 32'h0107a783;
		mem['he7] = 32'h0007a683;
		mem['he8] = 32'h0015c783;
		mem['he9] = 32'h0077f793;
		mem['hea] = 32'h00379713;
		mem['heb] = 32'h0006a783;
		mem['hec] = 32'hfc77f793;
		mem['hed] = 32'h00e7e7b3;
		mem['hee] = 32'h00f6a023;
		mem['hef] = 32'h00052783;
		mem['hf0] = 32'h0007a783;
		mem['hf1] = 32'h0107a783;
		mem['hf2] = 32'h0007a683;
		mem['hf3] = 32'h0025c783;
		mem['hf4] = 32'h0017f793;
		mem['hf5] = 32'h00679713;
		mem['hf6] = 32'h0006a783;
		mem['hf7] = 32'hfbf7f793;
		mem['hf8] = 32'h00e7e7b3;
		mem['hf9] = 32'h00f6a023;
		mem['hfa] = 32'h00052783;
		mem['hfb] = 32'h0007a783;
		mem['hfc] = 32'h0107a783;
		mem['hfd] = 32'h0007a683;
		mem['hfe] = 32'h0035c783;
		mem['hff] = 32'h0017f793;
		mem['h100] = 32'h00779713;
		mem['h101] = 32'h0006a783;
		mem['h102] = 32'hf7f7f793;
		mem['h103] = 32'h00e7e7b3;
		mem['h104] = 32'h00f6a023;
		mem['h105] = 32'h00858713;
		mem['h106] = 32'h00000793;
		mem['h107] = 32'h00052683;
		mem['h108] = 32'h00072803;
		mem['h109] = 32'h01078793;
		mem['h10a] = 32'h0006a683;
		mem['h10b] = 32'h01070713;
		mem['h10c] = 32'h0006a683;
		mem['h10d] = 32'h0006a683;
		mem['h10e] = 32'h0106a023;
		mem['h10f] = 32'h00052683;
		mem['h110] = 32'hff472803;
		mem['h111] = 32'h0006a683;
		mem['h112] = 32'h0046a683;
		mem['h113] = 32'h0006a683;
		mem['h114] = 32'h0106a023;
		mem['h115] = 32'h00052683;
		mem['h116] = 32'hff872803;
		mem['h117] = 32'h0006a683;
		mem['h118] = 32'h0086a683;
		mem['h119] = 32'h0006a683;
		mem['h11a] = 32'h0106a023;
		mem['h11b] = 32'h00052683;
		mem['h11c] = 32'hffc72803;
		mem['h11d] = 32'h0006a683;
		mem['h11e] = 32'h00c6a683;
		mem['h11f] = 32'h0006a683;
		mem['h120] = 32'h0106a023;
		mem['h121] = 32'h0045a683;
		mem['h122] = 32'h04d7fe63;
		mem['h123] = 32'h00052683;
		mem['h124] = 32'h0006a683;
		mem['h125] = 32'h0106a683;
		mem['h126] = 32'h0006a803;
		mem['h127] = 32'h00082683;
		mem['h128] = 32'h0116e6b3;
		mem['h129] = 32'h00d82023;
		mem['h12a] = 32'h00052683;
		mem['h12b] = 32'h0006a683;
		mem['h12c] = 32'h0106a683;
		mem['h12d] = 32'h0006a803;
		mem['h12e] = 32'h00082683;
		mem['h12f] = 32'h00c6f6b3;
		mem['h130] = 32'h00d82023;
		mem['h131] = 32'h00052683;
		mem['h132] = 32'h0006a683;
		mem['h133] = 32'h0146a683;
		mem['h134] = 32'h0006a803;
		mem['h135] = 32'h00082683;
		mem['h136] = 32'h0016e693;
		mem['h137] = 32'h00d82023;
		mem['h138] = 32'hf3dff06f;
		mem['h139] = 32'h00052703;
		mem['h13a] = 32'h40d787b3;
		mem['h13b] = 32'h00072703;
		mem['h13c] = 32'h01072703;
		mem['h13d] = 32'h00072603;
		mem['h13e] = 32'h00010737;
		mem['h13f] = 32'hfff70693;
		mem['h140] = 32'h00062703;
		mem['h141] = 32'h40f6d7b3;
		mem['h142] = 32'h01079793;
		mem['h143] = 32'h00d77733;
		mem['h144] = 32'h00f767b3;
		mem['h145] = 32'h00f62023;
		mem['h146] = 32'h00052783;
		mem['h147] = 32'h000086b7;
		mem['h148] = 32'h0007a783;
		mem['h149] = 32'h0107a783;
		mem['h14a] = 32'h0007a703;
		mem['h14b] = 32'h00072783;
		mem['h14c] = 32'h00d7e7b3;
		mem['h14d] = 32'h00f72023;
		mem['h14e] = 32'h00052783;
		mem['h14f] = 32'h0007a783;
		mem['h150] = 32'h0147a783;
		mem['h151] = 32'h0007a703;
		mem['h152] = 32'h00072783;
		mem['h153] = 32'h0017e793;
		mem['h154] = 32'h00f72023;
		mem['h155] = 32'h00008067;
		mem['h156] = 32'h0ff5f593;
		mem['h157] = 32'h00000793;
		mem['h158] = 32'h00c78a63;
		mem['h159] = 32'h00f50733;
		mem['h15a] = 32'h00b70023;
		mem['h15b] = 32'h00178793;
		mem['h15c] = 32'hff1ff06f;
		mem['h15d] = 32'h00008067;
		mem['h15e] = 32'h00000793;
		mem['h15f] = 32'h00c78e63;
		mem['h160] = 32'h00f58733;
		mem['h161] = 32'h00074683;
		mem['h162] = 32'h00f50733;
		mem['h163] = 32'h00178793;
		mem['h164] = 32'h00d70023;
		mem['h165] = 32'hfe9ff06f;
		mem['h166] = 32'h00008067;
		mem['h167] = 32'hf9010113;
		mem['h168] = 32'h02800513;
		mem['h169] = 32'h06112623;
		mem['h16a] = 32'h06812423;
		mem['h16b] = 32'h06912223;
		mem['h16c] = 32'h07212023;
		mem['h16d] = 32'h05312e23;
		mem['h16e] = 32'h05412c23;
		mem['h16f] = 32'h05512a23;
		mem['h170] = 32'h05612823;
		mem['h171] = 32'h05712623;
		mem['h172] = 32'h05812423;
		mem['h173] = 32'h05912223;
		mem['h174] = 32'h05a12023;
		mem['h175] = 32'h03b12e23;
		mem['h176] = 32'hcd9ff0ef;
		mem['h177] = 32'h00050413;
		mem['h178] = 32'h00800513;
		mem['h179] = 32'hccdff0ef;
		mem['h17a] = 32'h00050993;
		mem['h17b] = 32'h01c00513;
		mem['h17c] = 32'hcc1ff0ef;
		mem['h17d] = 32'h00050913;
		mem['h17e] = 32'h00400513;
		mem['h17f] = 32'h200004b7;
		mem['h180] = 32'hcb1ff0ef;
		mem['h181] = 32'h00952023;
		mem['h182] = 32'h00a92023;
		mem['h183] = 32'h00400513;
		mem['h184] = 32'hca1ff0ef;
		mem['h185] = 32'h00448793;
		mem['h186] = 32'h00f52023;
		mem['h187] = 32'h00a92223;
		mem['h188] = 32'h00400513;
		mem['h189] = 32'hc8dff0ef;
		mem['h18a] = 32'h00848793;
		mem['h18b] = 32'h00f52023;
		mem['h18c] = 32'h00a92423;
		mem['h18d] = 32'h00400513;
		mem['h18e] = 32'hc79ff0ef;
		mem['h18f] = 32'h00c48793;
		mem['h190] = 32'h00f52023;
		mem['h191] = 32'h00a92623;
		mem['h192] = 32'h00400513;
		mem['h193] = 32'hc65ff0ef;
		mem['h194] = 32'h01048793;
		mem['h195] = 32'h00f52023;
		mem['h196] = 32'h00a92823;
		mem['h197] = 32'h00400513;
		mem['h198] = 32'hc51ff0ef;
		mem['h199] = 32'h01448793;
		mem['h19a] = 32'h00f52023;
		mem['h19b] = 32'h00a92a23;
		mem['h19c] = 32'h00400513;
		mem['h19d] = 32'hc3dff0ef;
		mem['h19e] = 32'h01848793;
		mem['h19f] = 32'h00f52023;
		mem['h1a0] = 32'h00a92c23;
		mem['h1a1] = 32'h0129a023;
		mem['h1a2] = 32'h01c00513;
		mem['h1a3] = 32'hc25ff0ef;
		mem['h1a4] = 32'h00050913;
		mem['h1a5] = 32'h00400513;
		mem['h1a6] = 32'hc19ff0ef;
		mem['h1a7] = 32'h01c48793;
		mem['h1a8] = 32'h00f52023;
		mem['h1a9] = 32'h00a92023;
		mem['h1aa] = 32'h00400513;
		mem['h1ab] = 32'hc05ff0ef;
		mem['h1ac] = 32'h02048793;
		mem['h1ad] = 32'h00f52023;
		mem['h1ae] = 32'h00a92223;
		mem['h1af] = 32'h00400513;
		mem['h1b0] = 32'hbf1ff0ef;
		mem['h1b1] = 32'h02448793;
		mem['h1b2] = 32'h00f52023;
		mem['h1b3] = 32'h00a92423;
		mem['h1b4] = 32'h00400513;
		mem['h1b5] = 32'hbddff0ef;
		mem['h1b6] = 32'h02848793;
		mem['h1b7] = 32'h00f52023;
		mem['h1b8] = 32'h00a92623;
		mem['h1b9] = 32'h00400513;
		mem['h1ba] = 32'hbc9ff0ef;
		mem['h1bb] = 32'h02c48793;
		mem['h1bc] = 32'h00f52023;
		mem['h1bd] = 32'h00a92823;
		mem['h1be] = 32'h00400513;
		mem['h1bf] = 32'hbb5ff0ef;
		mem['h1c0] = 32'h03048793;
		mem['h1c1] = 32'h00f52023;
		mem['h1c2] = 32'h00a92a23;
		mem['h1c3] = 32'h00400513;
		mem['h1c4] = 32'hba1ff0ef;
		mem['h1c5] = 32'h03448793;
		mem['h1c6] = 32'h00f52023;
		mem['h1c7] = 32'h00a92c23;
		mem['h1c8] = 32'h0129a223;
		mem['h1c9] = 32'h01342023;
		mem['h1ca] = 32'h01000513;
		mem['h1cb] = 32'hb85ff0ef;
		mem['h1cc] = 32'h00050913;
		mem['h1cd] = 32'h00400513;
		mem['h1ce] = 32'hb79ff0ef;
		mem['h1cf] = 32'h03848793;
		mem['h1d0] = 32'h00f52023;
		mem['h1d1] = 32'h00a92023;
		mem['h1d2] = 32'h00400513;
		mem['h1d3] = 32'hb65ff0ef;
		mem['h1d4] = 32'h03c48793;
		mem['h1d5] = 32'h00f52023;
		mem['h1d6] = 32'h00a92223;
		mem['h1d7] = 32'h00400513;
		mem['h1d8] = 32'hb51ff0ef;
		mem['h1d9] = 32'h04048793;
		mem['h1da] = 32'h00f52023;
		mem['h1db] = 32'h00a92423;
		mem['h1dc] = 32'h00400513;
		mem['h1dd] = 32'hb3dff0ef;
		mem['h1de] = 32'h04448793;
		mem['h1df] = 32'h00f52023;
		mem['h1e0] = 32'h00a92623;
		mem['h1e1] = 32'h01242223;
		mem['h1e2] = 32'h00400513;
		mem['h1e3] = 32'hb25ff0ef;
		mem['h1e4] = 32'h04848793;
		mem['h1e5] = 32'h00f52023;
		mem['h1e6] = 32'h200009b7;
		mem['h1e7] = 32'h00a42423;
		mem['h1e8] = 32'h00c40a13;
		mem['h1e9] = 32'h04c48493;
		mem['h1ea] = 32'h07c98a93;
		mem['h1eb] = 32'h00c00513;
		mem['h1ec] = 32'hb01ff0ef;
		mem['h1ed] = 32'h00050913;
		mem['h1ee] = 32'h00400513;
		mem['h1ef] = 32'haf5ff0ef;
		mem['h1f0] = 32'h00952023;
		mem['h1f1] = 32'h00a92023;
		mem['h1f2] = 32'h00400513;
		mem['h1f3] = 32'hae5ff0ef;
		mem['h1f4] = 32'h00448793;
		mem['h1f5] = 32'h00f52023;
		mem['h1f6] = 32'h00a92223;
		mem['h1f7] = 32'h00400513;
		mem['h1f8] = 32'had1ff0ef;
		mem['h1f9] = 32'h00848793;
		mem['h1fa] = 32'h00f52023;
		mem['h1fb] = 32'h00a92423;
		mem['h1fc] = 32'h012a2023;
		mem['h1fd] = 32'h00c48493;
		mem['h1fe] = 32'h004a0a13;
		mem['h1ff] = 32'hfb5498e3;
		mem['h200] = 32'h00400513;
		mem['h201] = 32'haadff0ef;
		mem['h202] = 32'h00050913;
		mem['h203] = 32'h00400513;
		mem['h204] = 32'haa1ff0ef;
		mem['h205] = 32'h00952023;
		mem['h206] = 32'h00a92023;
		mem['h207] = 32'h01242e23;
		mem['h208] = 32'h00400513;
		mem['h209] = 32'ha8dff0ef;
		mem['h20a] = 32'h08098793;
		mem['h20b] = 32'h00f52023;
		mem['h20c] = 32'h02a42023;
		mem['h20d] = 32'h00400513;
		mem['h20e] = 32'ha79ff0ef;
		mem['h20f] = 32'h08498993;
		mem['h210] = 32'h01352023;
		mem['h211] = 32'h000014b7;
		mem['h212] = 32'h08c48593;
		mem['h213] = 32'h02a42223;
		mem['h214] = 32'h00040513;
		mem['h215] = 32'h91dff0ef;
		mem['h216] = 32'h000015b7;
		mem['h217] = 32'h0bc58593;
		mem['h218] = 32'h00040513;
		mem['h219] = 32'h90dff0ef;
		mem['h21a] = 32'h08c48593;
		mem['h21b] = 32'h00040513;
		mem['h21c] = 32'h901ff0ef;
		mem['h21d] = 32'h000015b7;
		mem['h21e] = 32'h0ec58593;
		mem['h21f] = 32'h00040513;
		mem['h220] = 32'h8f1ff0ef;
		mem['h221] = 32'h000015b7;
		mem['h222] = 32'h10458593;
		mem['h223] = 32'h00040513;
		mem['h224] = 32'h8e1ff0ef;
		mem['h225] = 32'h10000937;
		mem['h226] = 32'h00090593;
		mem['h227] = 32'h00040513;
		mem['h228] = 32'h915ff0ef;
		mem['h229] = 32'h000015b7;
		mem['h22a] = 32'h11c58593;
		mem['h22b] = 32'h00040513;
		mem['h22c] = 32'h00090493;
		mem['h22d] = 32'h8bdff0ef;
		mem['h22e] = 32'h00448593;
		mem['h22f] = 32'h00040513;
		mem['h230] = 32'h8f5ff0ef;
		mem['h231] = 32'h000015b7;
		mem['h232] = 32'h13858593;
		mem['h233] = 32'h00040513;
		mem['h234] = 32'h8a1ff0ef;
		mem['h235] = 32'h0084c583;
		mem['h236] = 32'h00040513;
		mem['h237] = 32'h100009b7;
		mem['h238] = 32'ha05ff0ef;
		mem['h239] = 32'h03a00593;
		mem['h23a] = 32'h00040513;
		mem['h23b] = 32'hf88ff0ef;
		mem['h23c] = 32'h0094c583;
		mem['h23d] = 32'h00040513;
		mem['h23e] = 32'h01898c93;
		mem['h23f] = 32'h9e9ff0ef;
		mem['h240] = 32'h03a00593;
		mem['h241] = 32'h00040513;
		mem['h242] = 32'hf6cff0ef;
		mem['h243] = 32'h00a4c583;
		mem['h244] = 32'h00040513;
		mem['h245] = 32'h00090a13;
		mem['h246] = 32'h9cdff0ef;
		mem['h247] = 32'h03a00593;
		mem['h248] = 32'h00040513;
		mem['h249] = 32'hf50ff0ef;
		mem['h24a] = 32'h00b4c583;
		mem['h24b] = 32'h00040513;
		mem['h24c] = 32'h01ec8a93;
		mem['h24d] = 32'h9b1ff0ef;
		mem['h24e] = 32'h03a00593;
		mem['h24f] = 32'h00040513;
		mem['h250] = 32'hf34ff0ef;
		mem['h251] = 32'h00c4c583;
		mem['h252] = 32'h00040513;
		mem['h253] = 32'h00ec8b13;
		mem['h254] = 32'h995ff0ef;
		mem['h255] = 32'h03a00593;
		mem['h256] = 32'h00040513;
		mem['h257] = 32'hf18ff0ef;
		mem['h258] = 32'h00d4c583;
		mem['h259] = 32'h00040513;
		mem['h25a] = 32'h97dff0ef;
		mem['h25b] = 32'h000015b7;
		mem['h25c] = 32'h15458593;
		mem['h25d] = 32'h00040513;
		mem['h25e] = 32'hff8ff0ef;
		mem['h25f] = 32'h00e48593;
		mem['h260] = 32'h00040513;
		mem['h261] = 32'h831ff0ef;
		mem['h262] = 32'h000015b7;
		mem['h263] = 32'h17058593;
		mem['h264] = 32'h00040513;
		mem['h265] = 32'hfdcff0ef;
		mem['h266] = 32'h0124c583;
		mem['h267] = 32'h00040513;
		mem['h268] = 32'h000014b7;
		mem['h269] = 32'hef8ff0ef;
		mem['h26a] = 32'h18c48593;
		mem['h26b] = 32'h00040513;
		mem['h26c] = 32'hfc0ff0ef;
		mem['h26d] = 32'h000015b7;
		mem['h26e] = 32'h19058593;
		mem['h26f] = 32'h00040513;
		mem['h270] = 32'hfb0ff0ef;
		mem['h271] = 32'h608c8793;
		mem['h272] = 32'h00f12423;
		mem['h273] = 32'h00f12623;
		mem['h274] = 32'h000c8023;
		mem['h275] = 32'h000c9123;
		mem['h276] = 32'h00042703;
		mem['h277] = 32'h00472703;
		mem['h278] = 32'h01872703;
		mem['h279] = 32'h00072703;
		mem['h27a] = 32'h00072703;
		mem['h27b] = 32'h00177713;
		mem['h27c] = 32'h10070c63;
		mem['h27d] = 32'h00042703;
		mem['h27e] = 32'h000c8b93;
		mem['h27f] = 32'h01898693;
		mem['h280] = 32'h00472703;
		mem['h281] = 32'h5f000513;
		mem['h282] = 32'h01072703;
		mem['h283] = 32'h00072703;
		mem['h284] = 32'h00072703;
		mem['h285] = 32'h00375713;
		mem['h286] = 32'h00777713;
		mem['h287] = 32'h00ec80a3;
		mem['h288] = 32'h00000713;
		mem['h289] = 32'h06e56263;
		mem['h28a] = 32'h00042603;
		mem['h28b] = 32'h00462603;
		mem['h28c] = 32'h00062603;
		mem['h28d] = 32'h00062603;
		mem['h28e] = 32'h00062603;
		mem['h28f] = 32'h00c6a423;
		mem['h290] = 32'h00042603;
		mem['h291] = 32'h00462603;
		mem['h292] = 32'h00462603;
		mem['h293] = 32'h00062603;
		mem['h294] = 32'h00062603;
		mem['h295] = 32'h00c6a623;
		mem['h296] = 32'h00042603;
		mem['h297] = 32'h00462603;
		mem['h298] = 32'h00862603;
		mem['h299] = 32'h00062603;
		mem['h29a] = 32'h00062603;
		mem['h29b] = 32'h00c6a823;
		mem['h29c] = 32'h00042603;
		mem['h29d] = 32'h00462603;
		mem['h29e] = 32'h00c62603;
		mem['h29f] = 32'h00062603;
		mem['h2a0] = 32'h00062603;
		mem['h2a1] = 32'h00c6aa23;
		mem['h2a2] = 32'h00042603;
		mem['h2a3] = 32'h01068693;
		mem['h2a4] = 32'h00462603;
		mem['h2a5] = 32'h01062603;
		mem['h2a6] = 32'h00062603;
		mem['h2a7] = 32'h00062603;
		mem['h2a8] = 32'h00f65613;
		mem['h2a9] = 32'h00167613;
		mem['h2aa] = 32'h06060c63;
		mem['h2ab] = 32'h00042683;
		mem['h2ac] = 32'h0046a683;
		mem['h2ad] = 32'h0106a683;
		mem['h2ae] = 32'h0006a683;
		mem['h2af] = 32'h0026d683;
		mem['h2b0] = 32'h0016f613;
		mem['h2b1] = 32'h00060863;
		mem['h2b2] = 32'h00170713;
		mem['h2b3] = 32'h0016d693;
		mem['h2b4] = 32'hff1ff06f;
		mem['h2b5] = 32'h60000693;
		mem['h2b6] = 32'h00e6f463;
		mem['h2b7] = 32'h60000713;
		mem['h2b8] = 32'h00eca223;
		mem['h2b9] = 32'h00042703;
		mem['h2ba] = 32'h00472703;
		mem['h2bb] = 32'h01472703;
		mem['h2bc] = 32'h00072683;
		mem['h2bd] = 32'h0006a703;
		mem['h2be] = 32'h00176713;
		mem['h2bf] = 32'h00e6a023;
		mem['h2c0] = 32'h004ca703;
		mem['h2c1] = 32'h04071063;
		mem['h2c2] = 32'h00842703;
		mem['h2c3] = 32'h00072683;
		mem['h2c4] = 32'h0006a703;
		mem['h2c5] = 32'hdff77713;
		mem['h2c6] = 32'h00e6a023;
		mem['h2c7] = 32'h3500006f;
		mem['h2c8] = 32'h00042603;
		mem['h2c9] = 32'h01070713;
		mem['h2ca] = 32'h00462603;
		mem['h2cb] = 32'h01462603;
		mem['h2cc] = 32'h00062583;
		mem['h2cd] = 32'h0005a603;
		mem['h2ce] = 32'h00166613;
		mem['h2cf] = 32'h00c5a023;
		mem['h2d0] = 32'hee5ff06f;
		mem['h2d1] = 32'h00842703;
		mem['h2d2] = 32'h00072683;
		mem['h2d3] = 32'h0006a703;
		mem['h2d4] = 32'h20076713;
		mem['h2d5] = 32'h00e6a023;
		mem['h2d6] = 32'h014ccc03;
		mem['h2d7] = 32'h00800713;
		mem['h2d8] = 32'h2eec1463;
		mem['h2d9] = 32'h015cc703;
		mem['h2da] = 32'h00600693;
		mem['h2db] = 32'h18d70663;
		mem['h2dc] = 32'h2c071c63;
		mem['h2dd] = 32'h016cc703;
		mem['h2de] = 32'h04000693;
		mem['h2df] = 32'h0f077713;
		mem['h2e0] = 32'h2cd71463;
		mem['h2e1] = 32'h01fcc683;
		mem['h2e2] = 32'h00100713;
		mem['h2e3] = 32'h2ae69e63;
		mem['h2e4] = 32'h000015b7;
		mem['h2e5] = 32'h1c058593;
		mem['h2e6] = 32'h00040513;
		mem['h2e7] = 32'hdd4ff0ef;
		mem['h2e8] = 32'h004cd583;
		mem['h2e9] = 32'h00040513;
		mem['h2ea] = 32'hcf4ff0ef;
		mem['h2eb] = 32'h18c48593;
		mem['h2ec] = 32'h00040513;
		mem['h2ed] = 32'hdbcff0ef;
		mem['h2ee] = 32'h00000713;
		mem['h2ef] = 32'h00400613;
		mem['h2f0] = 32'h00ea06b3;
		mem['h2f1] = 32'h026bc583;
		mem['h2f2] = 32'h0006c683;
		mem['h2f3] = 32'h26d59e63;
		mem['h2f4] = 32'h00170713;
		mem['h2f5] = 32'h001b8b93;
		mem['h2f6] = 32'hfec714e3;
		mem['h2f7] = 32'h02acc683;
		mem['h2f8] = 32'h00800713;
		mem['h2f9] = 32'h26e69263;
		mem['h2fa] = 32'h02bcc703;
		mem['h2fb] = 32'h24071e63;
		mem['h2fc] = 32'h001cc703;
		mem['h2fd] = 32'h00600613;
		mem['h2fe] = 32'h000b0593;
		mem['h2ff] = 32'h60ec8423;
		mem['h300] = 32'h00100713;
		mem['h301] = 32'h60ec85a3;
		mem['h302] = 32'h004ca703;
		mem['h303] = 32'h610c8513;
		mem['h304] = 32'h60eca623;
		mem['h305] = 32'h965ff0ef;
		mem['h306] = 32'h00600613;
		mem['h307] = 32'h008a0593;
		mem['h308] = 32'h616c8513;
		mem['h309] = 32'h955ff0ef;
		mem['h30a] = 32'h00450737;
		mem['h30b] = 32'h00870713;
		mem['h30c] = 32'h60ecae23;
		mem['h30d] = 32'h018cd703;
		mem['h30e] = 32'h00400613;
		mem['h30f] = 32'h00090593;
		mem['h310] = 32'h62ec9023;
		mem['h311] = 32'h62ac8513;
		mem['h312] = 32'h01ff0737;
		mem['h313] = 32'h62eca223;
		mem['h314] = 32'h620c9123;
		mem['h315] = 32'h620c9423;
		mem['h316] = 32'h921ff0ef;
		mem['h317] = 32'h00400613;
		mem['h318] = 32'h022c8593;
		mem['h319] = 32'h62ec8513;
		mem['h31a] = 32'h911ff0ef;
		mem['h31b] = 32'h01400593;
		mem['h31c] = 32'h61ec8513;
		mem['h31d] = 32'hdb8ff0ef;
		mem['h31e] = 32'h00851713;
		mem['h31f] = 32'h00855513;
		mem['h320] = 32'h00a76533;
		mem['h321] = 32'h02ecd703;
		mem['h322] = 32'h004ca603;
		mem['h323] = 32'h62ac9423;
		mem['h324] = 32'h62ec9b23;
		mem['h325] = 32'h030cd703;
		mem['h326] = 32'hfd660613;
		mem['h327] = 32'h032c8593;
		mem['h328] = 32'h63ac8513;
		mem['h329] = 32'h62ec9c23;
		mem['h32a] = 32'h620c9923;
		mem['h32b] = 32'h620c9a23;
		mem['h32c] = 32'h8c9ff0ef;
		mem['h32d] = 32'h004ca583;
		mem['h32e] = 32'h624b0513;
		mem['h32f] = 32'hfde58593;
		mem['h330] = 32'hd6cff0ef;
		mem['h331] = 32'h00851713;
		mem['h332] = 32'h00c12583;
		mem['h333] = 32'h00855513;
		mem['h334] = 32'h00a76533;
		mem['h335] = 32'h62ac9a23;
		mem['h336] = 32'h00040513;
		mem['h337] = 32'he64ff0ef;
		mem['h338] = 32'h000015b7;
		mem['h339] = 32'h1fc58593;
		mem['h33a] = 32'h00040513;
		mem['h33b] = 32'hc84ff0ef;
		mem['h33c] = 32'h004cd583;
		mem['h33d] = 32'h1400006f;
		mem['h33e] = 32'h000017b7;
		mem['h33f] = 32'h1d478593;
		mem['h340] = 32'h00040513;
		mem['h341] = 32'hc6cff0ef;
		mem['h342] = 32'h004cd583;
		mem['h343] = 32'h00040513;
		mem['h344] = 32'hb8cff0ef;
		mem['h345] = 32'h18c48593;
		mem['h346] = 32'h00040513;
		mem['h347] = 32'hc54ff0ef;
		mem['h348] = 32'h017cc683;
		mem['h349] = 32'h00100713;
		mem['h34a] = 32'h12e69063;
		mem['h34b] = 32'h018cc703;
		mem['h34c] = 32'h11871c63;
		mem['h34d] = 32'h016cc703;
		mem['h34e] = 32'h019cc683;
		mem['h34f] = 32'h00d76733;
		mem['h350] = 32'h0ff77713;
		mem['h351] = 32'h10071263;
		mem['h352] = 32'h00400613;
		mem['h353] = 32'h00ea06b3;
		mem['h354] = 32'h02ebc583;
		mem['h355] = 32'h0006c683;
		mem['h356] = 32'h0ed59863;
		mem['h357] = 32'h00170713;
		mem['h358] = 32'h001b8b93;
		mem['h359] = 32'hfec714e3;
		mem['h35a] = 32'h01ccc703;
		mem['h35b] = 32'h001cc683;
		mem['h35c] = 32'h0c071c63;
		mem['h35d] = 32'h01dcc703;
		mem['h35e] = 32'h00100613;
		mem['h35f] = 32'h0cc71663;
		mem['h360] = 32'h60ec85a3;
		mem['h361] = 32'h00600613;
		mem['h362] = 32'h02a00713;
		mem['h363] = 32'h000a8593;
		mem['h364] = 32'h610c8513;
		mem['h365] = 32'h60dc8423;
		mem['h366] = 32'h60eca623;
		mem['h367] = 32'hfdcff0ef;
		mem['h368] = 32'h008a0593;
		mem['h369] = 32'h00600613;
		mem['h36a] = 32'h616c8513;
		mem['h36b] = 32'hfccff0ef;
		mem['h36c] = 32'h01000737;
		mem['h36d] = 32'h60870713;
		mem['h36e] = 32'h60ecae23;
		mem['h36f] = 32'h04060737;
		mem['h370] = 32'h100007b7;
		mem['h371] = 32'h00870713;
		mem['h372] = 32'h00878593;
		mem['h373] = 32'h62eca023;
		mem['h374] = 32'h00600613;
		mem['h375] = 32'h20000713;
		mem['h376] = 32'h626c8513;
		mem['h377] = 32'h62ec9223;
		mem['h378] = 32'hf98ff0ef;
		mem['h379] = 32'h00400613;
		mem['h37a] = 32'h00090593;
		mem['h37b] = 32'h62cc8513;
		mem['h37c] = 32'hf88ff0ef;
		mem['h37d] = 32'h00600613;
		mem['h37e] = 32'h000a8593;
		mem['h37f] = 32'h630c8513;
		mem['h380] = 32'hf78ff0ef;
		mem['h381] = 32'h00400613;
		mem['h382] = 32'h024c8593;
		mem['h383] = 32'h636c8513;
		mem['h384] = 32'hf68ff0ef;
		mem['h385] = 32'h00812583;
		mem['h386] = 32'h00040513;
		mem['h387] = 32'hd24ff0ef;
		mem['h388] = 32'h000017b7;
		mem['h389] = 32'h1e878593;
		mem['h38a] = 32'h00040513;
		mem['h38b] = 32'hb44ff0ef;
		mem['h38c] = 32'h60ccd583;
		mem['h38d] = 32'h00040513;
		mem['h38e] = 32'ha64ff0ef;
		mem['h38f] = 32'h18c48593;
		mem['h390] = 32'h00040513;
		mem['h391] = 32'hb2cff0ef;
		mem['h392] = 32'h001cc683;
		mem['h393] = 32'h00100713;
		mem['h394] = 32'h0ee69a63;
		mem['h395] = 32'h00200713;
		mem['h396] = 32'h00ec8023;
		mem['h397] = 32'h00dc81a3;
		mem['h398] = 32'h01898593;
		mem['h399] = 32'h00040513;
		mem['h39a] = 32'hcd8ff0ef;
		mem['h39b] = 32'h00442703;
		mem['h39c] = 32'h00072703;
		mem['h39d] = 32'h00072703;
		mem['h39e] = 32'h00072583;
		mem['h39f] = 32'hb405dae3;
		mem['h3a0] = 32'h0ff5f713;
		mem['h3a1] = 32'h01200693;
		mem['h3a2] = 32'hb4d704e3;
		mem['h3a3] = 32'h01010b93;
		mem['h3a4] = 32'h00000c13;
		mem['h3a5] = 32'h00800d13;
		mem['h3a6] = 32'h07f00d93;
		mem['h3a7] = 32'h0ff5f593;
		mem['h3a8] = 32'h00bb8023;
		mem['h3a9] = 32'h00a00793;
		mem['h3aa] = 32'h02f58263;
		mem['h3ab] = 32'h00d00793;
		mem['h3ac] = 32'h0af59463;
		mem['h3ad] = 32'h00d00593;
		mem['h3ae] = 32'h00040513;
		mem['h3af] = 32'h9b8ff0ef;
		mem['h3b0] = 32'h00a00593;
		mem['h3b1] = 32'h00040513;
		mem['h3b2] = 32'h9acff0ef;
		mem['h3b3] = 32'h000b8023;
		mem['h3b4] = 32'h0ffc7c13;
		mem['h3b5] = 32'hae0c0ee3;
		mem['h3b6] = 32'h000015b7;
		mem['h3b7] = 32'h00040513;
		mem['h3b8] = 32'h21058593;
		mem['h3b9] = 32'ha8cff0ef;
		mem['h3ba] = 32'h01010593;
		mem['h3bb] = 32'h00040513;
		mem['h3bc] = 32'ha80ff0ef;
		mem['h3bd] = 32'h18c48593;
		mem['h3be] = 32'h00040513;
		mem['h3bf] = 32'ha74ff0ef;
		mem['h3c0] = 32'h000015b7;
		mem['h3c1] = 32'h00040513;
		mem['h3c2] = 32'h21c58593;
		mem['h3c3] = 32'ha64ff0ef;
		mem['h3c4] = 32'h000c0593;
		mem['h3c5] = 32'h00040513;
		mem['h3c6] = 32'h984ff0ef;
		mem['h3c7] = 32'h18c48593;
		mem['h3c8] = 32'h00040513;
		mem['h3c9] = 32'ha4cff0ef;
		mem['h3ca] = 32'h01014583;
		mem['h3cb] = 32'h00040513;
		mem['h3cc] = 32'hbb4ff0ef;
		mem['h3cd] = 32'h18c48593;
		mem['h3ce] = 32'h00040513;
		mem['h3cf] = 32'ha34ff0ef;
		mem['h3d0] = 32'ha91ff06f;
		mem['h3d1] = 32'h00200613;
		mem['h3d2] = 32'hf2c692e3;
		mem['h3d3] = 32'h00ec8023;
		mem['h3d4] = 32'h00ec81a3;
		mem['h3d5] = 32'hf0dff06f;
		mem['h3d6] = 32'h01a58463;
		mem['h3d7] = 32'h05b59a63;
		mem['h3d8] = 32'h020c0863;
		mem['h3d9] = 32'h00800593;
		mem['h3da] = 32'h00040513;
		mem['h3db] = 32'h908ff0ef;
		mem['h3dc] = 32'h02000593;
		mem['h3dd] = 32'h00040513;
		mem['h3de] = 32'h8fcff0ef;
		mem['h3df] = 32'h00800593;
		mem['h3e0] = 32'h00040513;
		mem['h3e1] = 32'hfffb8b93;
		mem['h3e2] = 32'hfffc0c13;
		mem['h3e3] = 32'h8e8ff0ef;
		mem['h3e4] = 32'h00442603;
		mem['h3e5] = 32'h00062603;
		mem['h3e6] = 32'h00062603;
		mem['h3e7] = 32'h00062583;
		mem['h3e8] = 32'hfe05d8e3;
		mem['h3e9] = 32'h01f00793;
		mem['h3ea] = 32'heefc1ae3;
		mem['h3eb] = 32'hf21ff06f;
		mem['h3ec] = 32'h00040513;
		mem['h3ed] = 32'h8c0ff0ef;
		mem['h3ee] = 32'h001b8b93;
		mem['h3ef] = 32'h001c0c13;
		mem['h3f0] = 32'hfd1ff06f;
		mem['h3f1] = 32'h06054063;
		mem['h3f2] = 32'h0605c663;
		mem['h3f3] = 32'h00058613;
		mem['h3f4] = 32'h00050593;
		mem['h3f5] = 32'hfff00513;
		mem['h3f6] = 32'h02060c63;
		mem['h3f7] = 32'h00100693;
		mem['h3f8] = 32'h00b67a63;
		mem['h3f9] = 32'h00c05863;
		mem['h3fa] = 32'h00161613;
		mem['h3fb] = 32'h00169693;
		mem['h3fc] = 32'hfeb66ae3;
		mem['h3fd] = 32'h00000513;
		mem['h3fe] = 32'h00c5e663;
		mem['h3ff] = 32'h40c585b3;
		mem['h400] = 32'h00d56533;
		mem['h401] = 32'h0016d693;
		mem['h402] = 32'h00165613;
		mem['h403] = 32'hfe0696e3;
		mem['h404] = 32'h00008067;
		mem['h405] = 32'h00008293;
		mem['h406] = 32'hfb5ff0ef;
		mem['h407] = 32'h00058513;
		mem['h408] = 32'h00028067;
		mem['h409] = 32'h40a00533;
		mem['h40a] = 32'h0005d863;
		mem['h40b] = 32'h40b005b3;
		mem['h40c] = 32'hf9dff06f;
		mem['h40d] = 32'h40b005b3;
		mem['h40e] = 32'h00008293;
		mem['h40f] = 32'hf91ff0ef;
		mem['h410] = 32'h40a00533;
		mem['h411] = 32'h00028067;
		mem['h412] = 32'h00008293;
		mem['h413] = 32'h0005ca63;
		mem['h414] = 32'h00054c63;
		mem['h415] = 32'hf79ff0ef;
		mem['h416] = 32'h00058513;
		mem['h417] = 32'h00028067;
		mem['h418] = 32'h40b005b3;
		mem['h419] = 32'hfe0558e3;
		mem['h41a] = 32'h40a00533;
		mem['h41b] = 32'hf61ff0ef;
		mem['h41c] = 32'h40b00533;
		mem['h41d] = 32'h00028067;
		mem['h41e] = 32'h33323130;
		mem['h41f] = 32'h37363534;
		mem['h420] = 32'h42413938;
		mem['h421] = 32'h46454443;
		mem['h422] = 32'h00000000;
		mem['h423] = 32'h3d3d3d3d;
		mem['h424] = 32'h3d3d3d3d;
		mem['h425] = 32'h3d3d3d3d;
		mem['h426] = 32'h3d3d3d3d;
		mem['h427] = 32'h3d3d3d3d;
		mem['h428] = 32'h3d3d3d3d;
		mem['h429] = 32'h3d3d3d3d;
		mem['h42a] = 32'h3d3d3d3d;
		mem['h42b] = 32'h3d3d3d3d;
		mem['h42c] = 32'h3d3d3d3d;
		mem['h42d] = 32'h0a0d3d3d;
		mem['h42e] = 32'h00000000;
		mem['h42f] = 32'h20202020;
		mem['h430] = 32'h57202020;
		mem['h431] = 32'h47657269;
		mem['h432] = 32'h64726175;
		mem['h433] = 32'h47504620;
		mem['h434] = 32'h79622041;
		mem['h435] = 32'h69684320;
		mem['h436] = 32'h6843696c;
		mem['h437] = 32'h20737069;
		mem['h438] = 32'h20202020;
		mem['h439] = 32'h0a0d2020;
		mem['h43a] = 32'h00000000;
		mem['h43b] = 32'h7774654e;
		mem['h43c] = 32'h206b726f;
		mem['h43d] = 32'h666e6f63;
		mem['h43e] = 32'h72756769;
		mem['h43f] = 32'h6f697461;
		mem['h440] = 32'h000a0d6e;
		mem['h441] = 32'h49202d2d;
		mem['h442] = 32'h64612050;
		mem['h443] = 32'h73657264;
		mem['h444] = 32'h20203a73;
		mem['h445] = 32'h20202020;
		mem['h446] = 32'h00002020;
		mem['h447] = 32'h2d2d0a0d;
		mem['h448] = 32'h62755320;
		mem['h449] = 32'h2074656e;
		mem['h44a] = 32'h6b73616d;
		mem['h44b] = 32'h2020203a;
		mem['h44c] = 32'h20202020;
		mem['h44d] = 32'h00000000;
		mem['h44e] = 32'h2d2d0a0d;
		mem['h44f] = 32'h43414d20;
		mem['h450] = 32'h64646120;
		mem['h451] = 32'h73736572;
		mem['h452] = 32'h2020203a;
		mem['h453] = 32'h20202020;
		mem['h454] = 32'h00000000;
		mem['h455] = 32'h2d2d0a0d;
		mem['h456] = 32'h66654420;
		mem['h457] = 32'h746c7561;
		mem['h458] = 32'h74616720;
		mem['h459] = 32'h79617765;
		mem['h45a] = 32'h2020203a;
		mem['h45b] = 32'h00000000;
		mem['h45c] = 32'h2d2d0a0d;
		mem['h45d] = 32'h66654420;
		mem['h45e] = 32'h746c7561;
		mem['h45f] = 32'h746e6920;
		mem['h460] = 32'h61667265;
		mem['h461] = 32'h203a6563;
		mem['h462] = 32'h00000000;
		mem['h463] = 32'h00000a0d;
		mem['h464] = 32'h2d2d2d2d;
		mem['h465] = 32'h2d2d2d2d;
		mem['h466] = 32'h2d2d2d2d;
		mem['h467] = 32'h2d2d2d2d;
		mem['h468] = 32'h2d2d2d2d;
		mem['h469] = 32'h2d2d2d2d;
		mem['h46a] = 32'h2d2d2d2d;
		mem['h46b] = 32'h2d2d2d2d;
		mem['h46c] = 32'h2d2d2d2d;
		mem['h46d] = 32'h2d2d2d2d;
		mem['h46e] = 32'h0a0d2d2d;
		mem['h46f] = 32'h00000000;
		mem['h470] = 32'h4e203c3c;
		mem['h471] = 32'h505f5445;
		mem['h472] = 32'h4f544f52;
		mem['h473] = 32'h4d43495f;
		mem['h474] = 32'h00203a50;
		mem['h475] = 32'h4e203c3c;
		mem['h476] = 32'h505f5445;
		mem['h477] = 32'h4f544f52;
		mem['h478] = 32'h5052415f;
		mem['h479] = 32'h0000203a;
		mem['h47a] = 32'h4e203e3e;
		mem['h47b] = 32'h505f5445;
		mem['h47c] = 32'h4f544f52;
		mem['h47d] = 32'h5052415f;
		mem['h47e] = 32'h0000203a;
		mem['h47f] = 32'h4e203e3e;
		mem['h480] = 32'h505f5445;
		mem['h481] = 32'h4f544f52;
		mem['h482] = 32'h4d43495f;
		mem['h483] = 32'h00203a50;
		mem['h484] = 32'h65636552;
		mem['h485] = 32'h64657669;
		mem['h486] = 32'h0000203a;
		mem['h487] = 32'h65636552;
		mem['h488] = 32'h64657669;
		mem['h489] = 32'h6e656c20;
		mem['h48a] = 32'h3a687467;
		mem['h48b] = 32'h00000020;
		mem['h48c] = 32'h6301a8c0;
		mem['h48d] = 32'h00ffffff;
		mem['h48e] = 32'haecccaca;
		mem['h48f] = 32'ha8c00100;
		mem['h490] = 32'h0001fe01;
		mem['h491] = 32'h00000000;
	end
	always @(posedge clk) begin
		rdat <= mem[raddr_int];
		if (we == 1'b1)
			mem[waddr_int] <= wdat;
	end
	always @(negedge arst_n or posedge clk)
		if (arst_n == 1'b0)
			rrdy <= 1'sb0;
		else
			rrdy <= rvld & ~rrdy;
endmodule
module fpga_pll_125M (
	clk,
	rst_n,
	eth_pll_clk,
	eth_pll_locked
);
	input wire clk;
	input wire rst_n;
	output wire eth_pll_clk;
	output wire eth_pll_locked;
	wire eth_pll_rst = ~rst_n;
	wire eth_pll_clkfb;
	wire eth_pll_out;
	PLLE2_BASE #(
		.CLKFBOUT_MULT(5),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(5.0),
		.CLKOUT0_DIVIDE(8),
		.CLKOUT1_DIVIDE(1),
		.CLKOUT2_DIVIDE(1),
		.CLKOUT3_DIVIDE(1),
		.CLKOUT4_DIVIDE(1),
		.CLKOUT5_DIVIDE(1),
		.CLKOUT0_DUTY_CYCLE(0.5),
		.CLKOUT1_DUTY_CYCLE(0.5),
		.CLKOUT2_DUTY_CYCLE(0.5),
		.CLKOUT3_DUTY_CYCLE(0.5),
		.CLKOUT4_DUTY_CYCLE(0.5),
		.CLKOUT5_DUTY_CYCLE(0.5),
		.CLKOUT0_PHASE(0.0),
		.CLKOUT1_PHASE(0.0),
		.CLKOUT2_PHASE(0.0),
		.CLKOUT3_PHASE(0.0),
		.CLKOUT4_PHASE(0.0),
		.CLKOUT5_PHASE(0.0),
		.DIVCLK_DIVIDE(1)
	) eth_pll(
		.CLKOUT0(eth_pll_out),
		.CLKOUT1(),
		.CLKOUT2(),
		.CLKOUT3(),
		.CLKOUT4(),
		.CLKOUT5(),
		.CLKFBOUT(eth_pll_clkfb),
		.CLKFBIN(eth_pll_clkfb),
		.LOCKED(eth_pll_locked),
		.CLKIN1(clk),
		.PWRDWN(0),
		.RST(eth_pll_rst)
	);
	BUFG eth_gtx_bufg_inst(
		.I(eth_pll_out),
		.O(eth_pll_clk)
	);
endmodule
module fpga_pll_80M (
	clk,
	rst_n,
	sys_pll_clk,
	sys_pll_locked
);
	input wire clk;
	input wire rst_n;
	output wire sys_pll_clk;
	output wire sys_pll_locked;
	wire sys_pll_rst = ~rst_n;
	wire sys_pll_clkfb;
	wire sys_pll_out;
	PLLE2_BASE #(
		.CLKFBOUT_MULT(4),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(5.0),
		.CLKOUT0_DIVIDE(10),
		.CLKOUT1_DIVIDE(1),
		.CLKOUT2_DIVIDE(1),
		.CLKOUT3_DIVIDE(1),
		.CLKOUT4_DIVIDE(1),
		.CLKOUT5_DIVIDE(1),
		.CLKOUT0_DUTY_CYCLE(0.5),
		.CLKOUT1_DUTY_CYCLE(0.5),
		.CLKOUT2_DUTY_CYCLE(0.5),
		.CLKOUT3_DUTY_CYCLE(0.5),
		.CLKOUT4_DUTY_CYCLE(0.5),
		.CLKOUT5_DUTY_CYCLE(0.5),
		.CLKOUT0_PHASE(0.0),
		.CLKOUT1_PHASE(0.0),
		.CLKOUT2_PHASE(0.0),
		.CLKOUT3_PHASE(0.0),
		.CLKOUT4_PHASE(0.0),
		.CLKOUT5_PHASE(0.0),
		.DIVCLK_DIVIDE(1)
	) sys_pll(
		.CLKOUT0(sys_pll_out),
		.CLKOUT1(),
		.CLKOUT2(),
		.CLKOUT3(),
		.CLKOUT4(),
		.CLKOUT5(),
		.CLKFBOUT(sys_pll_clkfb),
		.CLKFBIN(sys_pll_clkfb),
		.LOCKED(sys_pll_locked),
		.CLKIN1(clk),
		.PWRDWN(0),
		.RST(sys_pll_rst)
	);
	BUFG sys_clk_bufg_inst(
		.I(sys_pll_out),
		.O(sys_pll_clk)
	);
endmodule
module csr (
	clk,
	rst,
	s_cpuif_req,
	s_cpuif_req_is_wr,
	s_cpuif_addr,
	s_cpuif_wr_data,
	s_cpuif_wr_biten,
	s_cpuif_req_stall_wr,
	s_cpuif_req_stall_rd,
	s_cpuif_rd_ack,
	s_cpuif_rd_err,
	s_cpuif_rd_data,
	s_cpuif_wr_ack,
	s_cpuif_wr_err,
	hwif_in,
	hwif_out
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire s_cpuif_req;
	input wire s_cpuif_req_is_wr;
	input wire [7:0] s_cpuif_addr;
	input wire [31:0] s_cpuif_wr_data;
	input wire [31:0] s_cpuif_wr_biten;
	output wire s_cpuif_req_stall_wr;
	output wire s_cpuif_req_stall_rd;
	output wire s_cpuif_rd_ack;
	output wire s_cpuif_rd_err;
	output wire [31:0] s_cpuif_rd_data;
	output wire s_cpuif_wr_ack;
	output wire s_cpuif_wr_err;
	input wire [176:0] hwif_in;
	output wire [425:0] hwif_out;
	wire cpuif_req;
	wire cpuif_req_is_wr;
	wire [7:0] cpuif_addr;
	wire [31:0] cpuif_wr_data;
	wire [31:0] cpuif_wr_biten;
	wire cpuif_req_stall_wr;
	wire cpuif_req_stall_rd;
	wire cpuif_rd_ack;
	wire cpuif_rd_err;
	wire [31:0] cpuif_rd_data;
	wire cpuif_wr_ack;
	wire cpuif_wr_err;
	assign cpuif_req = s_cpuif_req;
	assign cpuif_req_is_wr = s_cpuif_req_is_wr;
	assign cpuif_addr = s_cpuif_addr;
	assign cpuif_wr_data = s_cpuif_wr_data;
	assign cpuif_wr_biten = s_cpuif_wr_biten;
	assign s_cpuif_req_stall_wr = cpuif_req_stall_wr;
	assign s_cpuif_req_stall_rd = cpuif_req_stall_rd;
	assign s_cpuif_rd_ack = cpuif_rd_ack;
	assign s_cpuif_rd_err = cpuif_rd_err;
	assign s_cpuif_rd_data = cpuif_rd_data;
	assign s_cpuif_wr_ack = cpuif_wr_ack;
	assign s_cpuif_wr_err = cpuif_wr_err;
	wire cpuif_req_masked;
	assign cpuif_req_stall_rd = 1'sb0;
	assign cpuif_req_stall_wr = 1'sb0;
	assign cpuif_req_masked = (cpuif_req & !(!cpuif_req_is_wr & cpuif_req_stall_rd)) & !(cpuif_req_is_wr & cpuif_req_stall_wr);
	reg [33:0] decoded_reg_strb;
	wire decoded_req;
	wire decoded_req_is_wr;
	wire [31:0] decoded_wr_data;
	wire [31:0] decoded_wr_biten;
	function automatic signed [7:0] sv2v_cast_8_signed;
		input reg signed [7:0] inp;
		sv2v_cast_8_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		decoded_reg_strb[33] = cpuif_req_masked & (cpuif_addr == 8'h00);
		decoded_reg_strb[32] = cpuif_req_masked & (cpuif_addr == 8'h04);
		decoded_reg_strb[31] = cpuif_req_masked & (cpuif_addr == 8'h08);
		decoded_reg_strb[30] = cpuif_req_masked & (cpuif_addr == 8'h0c);
		decoded_reg_strb[29] = cpuif_req_masked & (cpuif_addr == 8'h10);
		decoded_reg_strb[28] = cpuif_req_masked & (cpuif_addr == 8'h14);
		decoded_reg_strb[27] = cpuif_req_masked & (cpuif_addr == 8'h18);
		decoded_reg_strb[26] = cpuif_req_masked & (cpuif_addr == 8'h1c);
		decoded_reg_strb[25] = cpuif_req_masked & (cpuif_addr == 8'h20);
		decoded_reg_strb[24] = cpuif_req_masked & (cpuif_addr == 8'h24);
		decoded_reg_strb[23] = cpuif_req_masked & (cpuif_addr == 8'h28);
		decoded_reg_strb[22] = cpuif_req_masked & (cpuif_addr == 8'h2c);
		decoded_reg_strb[21] = cpuif_req_masked & (cpuif_addr == 8'h30);
		decoded_reg_strb[20] = cpuif_req_masked & (cpuif_addr == 8'h34);
		decoded_reg_strb[19] = cpuif_req_masked & (cpuif_addr == 8'h38);
		decoded_reg_strb[18] = cpuif_req_masked & (cpuif_addr == 8'h3c);
		decoded_reg_strb[17] = cpuif_req_masked & (cpuif_addr == 8'h40);
		decoded_reg_strb[16] = cpuif_req_masked & (cpuif_addr == 8'h44);
		decoded_reg_strb[15] = cpuif_req_masked & (cpuif_addr == 8'h48);
		begin : sv2v_autoblock_1
			reg signed [31:0] i0;
			for (i0 = 0; i0 < 4; i0 = i0 + 1)
				begin
					decoded_reg_strb[3 + (((3 - i0) * 3) + 2)] = cpuif_req_masked & (cpuif_addr == (8'h4c + (sv2v_cast_8_signed(i0) * 8'h0c)));
					decoded_reg_strb[3 + (((3 - i0) * 3) + 1)] = cpuif_req_masked & (cpuif_addr == (8'h50 + (sv2v_cast_8_signed(i0) * 8'h0c)));
					decoded_reg_strb[3 + ((3 - i0) * 3)] = cpuif_req_masked & (cpuif_addr == (8'h54 + (sv2v_cast_8_signed(i0) * 8'h0c)));
				end
		end
		decoded_reg_strb[2] = cpuif_req_masked & (cpuif_addr == 8'h7c);
		decoded_reg_strb[1] = cpuif_req_masked & (cpuif_addr == 8'h80);
		decoded_reg_strb[0] = cpuif_req_masked & (cpuif_addr == 8'h84);
	end
	assign decoded_req = cpuif_req_masked;
	assign decoded_req_is_wr = cpuif_req_is_wr;
	assign decoded_wr_data = cpuif_wr_data;
	assign decoded_wr_biten = cpuif_wr_biten;
	reg [385:0] field_combo;
	reg [359:0] field_storage;
	always @(*) begin : sv2v_autoblock_2
		reg [31:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[359-:32];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[33] && decoded_req_is_wr) begin
			next_c = (field_storage[359-:32] & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
			load_next_c = 1'sb1;
		end
		field_combo[385-:32] = next_c;
		field_combo[353] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[359-:32] <= 32'h00000000;
		else if (field_combo[353])
			field_storage[359-:32] <= field_combo[385-:32];
	assign hwif_out[425-:32] = field_storage[359-:32];
	always @(*) begin : sv2v_autoblock_3
		reg [31:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[327-:32];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[32] && decoded_req_is_wr) begin
			next_c = (field_storage[327-:32] & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
			load_next_c = 1'sb1;
		end
		field_combo[352-:32] = next_c;
		field_combo[320] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[327-:32] <= 32'h00000000;
		else if (field_combo[320])
			field_storage[327-:32] <= field_combo[352-:32];
	assign hwif_out[393-:32] = field_storage[327-:32];
	always @(*) begin : sv2v_autoblock_4
		reg [31:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[295-:32];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[31] && decoded_req_is_wr) begin
			next_c = (field_storage[295-:32] & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
			load_next_c = 1'sb1;
		end
		field_combo[319-:32] = next_c;
		field_combo[287] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[295-:32] <= 32'h00000000;
		else if (field_combo[287])
			field_storage[295-:32] <= field_combo[319-:32];
	assign hwif_out[361-:32] = field_storage[295-:32];
	always @(*) begin : sv2v_autoblock_5
		reg [31:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[263-:32];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[30] && decoded_req_is_wr) begin
			next_c = (field_storage[263-:32] & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
			load_next_c = 1'sb1;
		end
		field_combo[286-:32] = next_c;
		field_combo[254] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[263-:32] <= 32'h00000000;
		else if (field_combo[254])
			field_storage[263-:32] <= field_combo[286-:32];
	assign hwif_out[329-:32] = field_storage[263-:32];
	always @(*) begin : sv2v_autoblock_6
		reg [2:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[231-:3];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[231-:3] & ~decoded_wr_biten[2:0]) | (decoded_wr_data[2:0] & decoded_wr_biten[2:0]);
			load_next_c = 1'sb1;
		end
		field_combo[253-:3] = next_c;
		field_combo[250] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[231-:3] <= 3'h0;
		else if (field_combo[250])
			field_storage[231-:3] <= field_combo[253-:3];
	assign hwif_out[297-:3] = field_storage[231-:3];
	always @(*) begin : sv2v_autoblock_7
		reg [2:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[228-:3];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[228-:3] & ~decoded_wr_biten[5:3]) | (decoded_wr_data[5:3] & decoded_wr_biten[5:3]);
			load_next_c = 1'sb1;
		end
		field_combo[249-:3] = next_c;
		field_combo[246] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[228-:3] <= 3'h0;
		else if (field_combo[246])
			field_storage[228-:3] <= field_combo[249-:3];
	assign hwif_out[294-:3] = field_storage[228-:3];
	always @(*) begin : sv2v_autoblock_8
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[225];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[225] & ~decoded_wr_biten[6:6]) | (decoded_wr_data[6:6] & decoded_wr_biten[6:6]);
			load_next_c = 1'sb1;
		end
		field_combo[245] = next_c;
		field_combo[244] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[225] <= 1'h0;
		else if (field_combo[244])
			field_storage[225] <= field_combo[245];
	assign hwif_out[291] = field_storage[225];
	always @(*) begin : sv2v_autoblock_9
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[224];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[224] & ~decoded_wr_biten[7:7]) | (decoded_wr_data[7:7] & decoded_wr_biten[7:7]);
			load_next_c = 1'sb1;
		end
		field_combo[243] = next_c;
		field_combo[242] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[224] <= 1'h0;
		else if (field_combo[242])
			field_storage[224] <= field_combo[243];
	assign hwif_out[290] = field_storage[224];
	always @(*) begin : sv2v_autoblock_10
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[223];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[223] & ~decoded_wr_biten[15:15]) | (decoded_wr_data[15:15] & decoded_wr_biten[15:15]);
			load_next_c = 1'sb1;
		end
		field_combo[241] = next_c;
		field_combo[240] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[223] <= 1'h0;
		else if (field_combo[240])
			field_storage[223] <= field_combo[241];
	assign hwif_out[289] = field_storage[223];
	always @(*) begin : sv2v_autoblock_11
		reg [15:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[222-:16];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[29] && decoded_req_is_wr) begin
			next_c = (field_storage[222-:16] & ~decoded_wr_biten[31:16]) | (decoded_wr_data[31:16] & decoded_wr_biten[31:16]);
			load_next_c = 1'sb1;
		end
		field_combo[239-:16] = next_c;
		field_combo[223] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[222-:16] <= 16'h0000;
		else if (field_combo[223])
			field_storage[222-:16] <= field_combo[239-:16];
	assign hwif_out[288-:16] = field_storage[222-:16];
	always @(*) begin : sv2v_autoblock_12
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[206];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[28] && decoded_req_is_wr) begin
			next_c = (field_storage[206] & ~decoded_wr_biten[0:0]) | (decoded_wr_data[0:0] & decoded_wr_biten[0:0]);
			load_next_c = 1'sb1;
		end
		else begin
			next_c = 1'sb0;
			load_next_c = 1'sb1;
		end
		field_combo[222] = next_c;
		field_combo[221] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[206] <= 1'h0;
		else if (field_combo[221])
			field_storage[206] <= field_combo[222];
	assign hwif_out[272] = field_storage[206];
	always @(*) begin : sv2v_autoblock_13
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[205];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[21] && decoded_req_is_wr) begin
			next_c = (field_storage[205] & ~decoded_wr_biten[0:0]) | (decoded_wr_data[0:0] & decoded_wr_biten[0:0]);
			load_next_c = 1'sb1;
		end
		else begin
			next_c = 1'sb0;
			load_next_c = 1'sb1;
		end
		field_combo[220] = next_c;
		field_combo[219] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[205] <= 1'h0;
		else if (field_combo[219])
			field_storage[205] <= field_combo[220];
	assign hwif_out[271] = field_storage[205];
	assign hwif_out[270] = decoded_reg_strb[19];
	always @(*) begin : sv2v_autoblock_14
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[204];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[18] && decoded_req_is_wr) begin
			next_c = (field_storage[204] & ~decoded_wr_biten[0:0]) | (decoded_wr_data[0:0] & decoded_wr_biten[0:0]);
			load_next_c = 1'sb1;
		end
		else begin
			next_c = decoded_reg_strb[19];
			load_next_c = 1'sb1;
		end
		field_combo[218] = next_c;
		field_combo[217] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[204] <= 1'h0;
		else if (field_combo[217])
			field_storage[204] <= field_combo[218];
	assign hwif_out[269] = field_storage[204];
	always @(*) begin : sv2v_autoblock_15
		reg [7:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[203-:8];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[17] && decoded_req_is_wr) begin
			next_c = (field_storage[203-:8] & ~decoded_wr_biten[7:0]) | (decoded_wr_data[7:0] & decoded_wr_biten[7:0]);
			load_next_c = 1'sb1;
		end
		field_combo[216-:8] = next_c;
		field_combo[208] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[203-:8] <= 8'h00;
		else if (field_combo[208])
			field_storage[203-:8] <= field_combo[216-:8];
	assign hwif_out[268-:8] = field_storage[203-:8];
	assign hwif_out[260] = (decoded_reg_strb[17] && decoded_req_is_wr) && |decoded_wr_biten[7:0];
	always @(*) begin : sv2v_autoblock_16
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[195];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[16] && decoded_req_is_wr) begin
			next_c = (field_storage[195] & ~decoded_wr_biten[0:0]) | (decoded_wr_data[0:0] & decoded_wr_biten[0:0]);
			load_next_c = 1'sb1;
		end
		else begin
			next_c = (decoded_reg_strb[17] && decoded_req_is_wr) && |decoded_wr_biten[7:0];
			load_next_c = 1'sb1;
		end
		field_combo[207] = next_c;
		field_combo[206] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[195] <= 1'h0;
		else if (field_combo[206])
			field_storage[195] <= field_combo[207];
	assign hwif_out[259] = field_storage[195];
	always @(*) begin : sv2v_autoblock_17
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[194];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[15] && decoded_req_is_wr) begin
			next_c = (field_storage[194] & ~decoded_wr_biten[8:8]) | (decoded_wr_data[8:8] & decoded_wr_biten[8:8]);
			load_next_c = 1'sb1;
		end
		field_combo[205] = next_c;
		field_combo[204] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[194] <= 1'h0;
		else if (field_combo[204])
			field_storage[194] <= field_combo[205];
	assign hwif_out[258] = field_storage[194];
	always @(*) begin : sv2v_autoblock_18
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[193];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[15] && decoded_req_is_wr) begin
			next_c = (field_storage[193] & ~decoded_wr_biten[9:9]) | (decoded_wr_data[9:9] & decoded_wr_biten[9:9]);
			load_next_c = 1'sb1;
		end
		field_combo[203] = next_c;
		field_combo[202] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[193] <= 1'h0;
		else if (field_combo[202])
			field_storage[193] <= field_combo[203];
	assign hwif_out[257] = field_storage[193];
	genvar _gv_i0_1;
	generate
		for (_gv_i0_1 = 0; _gv_i0_1 < 4; _gv_i0_1 = _gv_i0_1 + 1) begin : genblk1
			localparam i0 = _gv_i0_1;
			always @(*) begin : sv2v_autoblock_19
				reg [15:0] next_c;
				reg load_next_c;
				if (_sv2v_0)
					;
				next_c = field_storage[1 + (((3 - i0) * 48) + 47)-:16];
				load_next_c = 1'sb0;
				if (decoded_reg_strb[3 + (((3 - i0) * 3) + 1)] && decoded_req_is_wr) begin
					next_c = (field_storage[1 + (((3 - i0) * 48) + 47)-:16] & ~decoded_wr_biten[15:0]) | (decoded_wr_data[15:0] & decoded_wr_biten[15:0]);
					load_next_c = 1'sb1;
				end
				field_combo[2 + (((3 - i0) * 50) + 49)-:16] = next_c;
				field_combo[2 + (((3 - i0) * 50) + 33)] = load_next_c;
			end
			always @(posedge clk)
				if (rst)
					field_storage[1 + (((3 - i0) * 48) + 47)-:16] <= 16'h0000;
				else if (field_combo[2 + (((3 - i0) * 50) + 33)])
					field_storage[1 + (((3 - i0) * 48) + 47)-:16] <= field_combo[2 + (((3 - i0) * 50) + 49)-:16];
			assign hwif_out[65 + (((3 - i0) * 48) + 47)-:16] = field_storage[1 + (((3 - i0) * 48) + 47)-:16];
			always @(*) begin : sv2v_autoblock_20
				reg [31:0] next_c;
				reg load_next_c;
				if (_sv2v_0)
					;
				next_c = field_storage[1 + (((3 - i0) * 48) + 31)-:32];
				load_next_c = 1'sb0;
				if (decoded_reg_strb[3 + ((3 - i0) * 3)] && decoded_req_is_wr) begin
					next_c = (field_storage[1 + (((3 - i0) * 48) + 31)-:32] & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
					load_next_c = 1'sb1;
				end
				field_combo[2 + (((3 - i0) * 50) + 32)-:32] = next_c;
				field_combo[2 + ((3 - i0) * 50)] = load_next_c;
			end
			always @(posedge clk)
				if (rst)
					field_storage[1 + (((3 - i0) * 48) + 31)-:32] <= 32'h00000000;
				else if (field_combo[2 + ((3 - i0) * 50)])
					field_storage[1 + (((3 - i0) * 48) + 31)-:32] <= field_combo[2 + (((3 - i0) * 50) + 32)-:32];
			assign hwif_out[65 + (((3 - i0) * 48) + 31)-:32] = field_storage[1 + (((3 - i0) * 48) + 31)-:32];
		end
	endgenerate
	always @(*) begin : sv2v_autoblock_21
		reg [0:0] next_c;
		reg load_next_c;
		if (_sv2v_0)
			;
		next_c = field_storage[-0];
		load_next_c = 1'sb0;
		if (decoded_reg_strb[2] && decoded_req_is_wr) begin
			next_c = (field_storage[-0] & ~decoded_wr_biten[1:1]) | (decoded_wr_data[1:1] & decoded_wr_biten[1:1]);
			load_next_c = 1'sb1;
		end
		field_combo[1] = next_c;
		field_combo[0] = load_next_c;
	end
	always @(posedge clk)
		if (rst)
			field_storage[-0] <= 1'h0;
		else if (field_combo[0])
			field_storage[-0] <= field_combo[1];
	assign hwif_out[64] = field_storage[-0];
	assign hwif_out[63-:16] = 16'hcaca;
	assign hwif_out[47-:16] = 16'hccae;
	assign hwif_out[31-:16] = 16'h0000;
	assign hwif_out[15-:8] = 8'h02;
	assign hwif_out[7-:8] = 8'h00;
	assign cpuif_wr_ack = decoded_req & decoded_req_is_wr;
	assign cpuif_wr_err = 1'sb0;
	reg readback_err;
	reg readback_done;
	reg [31:0] readback_data;
	wire [31:0] readback_array [0:33];
	assign readback_array[0][31:0] = (decoded_reg_strb[33] && !decoded_req_is_wr ? field_storage[359-:32] : {32 {1'sb0}});
	assign readback_array[1][31:0] = (decoded_reg_strb[32] && !decoded_req_is_wr ? field_storage[327-:32] : {32 {1'sb0}});
	assign readback_array[2][31:0] = (decoded_reg_strb[31] && !decoded_req_is_wr ? field_storage[295-:32] : {32 {1'sb0}});
	assign readback_array[3][31:0] = (decoded_reg_strb[30] && !decoded_req_is_wr ? field_storage[263-:32] : {32 {1'sb0}});
	assign readback_array[4][2:0] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[231-:3] : {3 {1'sb0}});
	assign readback_array[4][5:3] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[228-:3] : {3 {1'sb0}});
	assign readback_array[4][6:6] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[225] : 1'b0);
	assign readback_array[4][7:7] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[224] : 1'b0);
	assign readback_array[4][14:8] = 1'sb0;
	assign readback_array[4][15:15] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[223] : 1'b0);
	assign readback_array[4][31:16] = (decoded_reg_strb[29] && !decoded_req_is_wr ? field_storage[222-:16] : {16 {1'sb0}});
	assign readback_array[5][0:0] = (decoded_reg_strb[28] && !decoded_req_is_wr ? field_storage[206] : 1'b0);
	assign readback_array[5][31:1] = 1'sb0;
	assign readback_array[6][0:0] = (decoded_reg_strb[27] && !decoded_req_is_wr ? hwif_in[176] : 1'b0);
	assign readback_array[6][31:1] = 1'sb0;
	assign readback_array[7][31:0] = (decoded_reg_strb[26] && !decoded_req_is_wr ? hwif_in[175-:32] : {32 {1'sb0}});
	assign readback_array[8][31:0] = (decoded_reg_strb[25] && !decoded_req_is_wr ? hwif_in[143-:32] : {32 {1'sb0}});
	assign readback_array[9][31:0] = (decoded_reg_strb[24] && !decoded_req_is_wr ? hwif_in[111-:32] : {32 {1'sb0}});
	assign readback_array[10][31:0] = (decoded_reg_strb[23] && !decoded_req_is_wr ? hwif_in[79-:32] : {32 {1'sb0}});
	assign readback_array[11][2:0] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[47-:3] : {3 {1'sb0}});
	assign readback_array[11][5:3] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[44-:3] : {3 {1'sb0}});
	assign readback_array[11][6:6] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[41] : 1'b0);
	assign readback_array[11][7:7] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[40] : 1'b0);
	assign readback_array[11][14:8] = 1'sb0;
	assign readback_array[11][15:15] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[39] : 1'b0);
	assign readback_array[11][31:16] = (decoded_reg_strb[22] && !decoded_req_is_wr ? hwif_in[38-:16] : {16 {1'sb0}});
	assign readback_array[12][0:0] = (decoded_reg_strb[21] && !decoded_req_is_wr ? field_storage[205] : 1'b0);
	assign readback_array[12][31:1] = 1'sb0;
	assign readback_array[13][0:0] = (decoded_reg_strb[20] && !decoded_req_is_wr ? hwif_in[22] : 1'b0);
	assign readback_array[13][31:1] = 1'sb0;
	assign readback_array[14][7:0] = (decoded_reg_strb[19] && !decoded_req_is_wr ? hwif_in[21-:8] : {8 {1'sb0}});
	assign readback_array[14][29:8] = 1'sb0;
	assign readback_array[14][30:30] = (decoded_reg_strb[19] && !decoded_req_is_wr ? hwif_in[13] : 1'b0);
	assign readback_array[14][31:31] = (decoded_reg_strb[19] && !decoded_req_is_wr ? hwif_in[12] : 1'b0);
	assign readback_array[15][0:0] = (decoded_reg_strb[18] && !decoded_req_is_wr ? field_storage[204] : 1'b0);
	assign readback_array[15][31:1] = 1'sb0;
	assign readback_array[16][7:0] = (decoded_reg_strb[17] && !decoded_req_is_wr ? field_storage[203-:8] : {8 {1'sb0}});
	assign readback_array[16][30:8] = 1'sb0;
	assign readback_array[16][31:31] = (decoded_reg_strb[17] && !decoded_req_is_wr ? hwif_in[11] : 1'b0);
	assign readback_array[17][0:0] = (decoded_reg_strb[16] && !decoded_req_is_wr ? field_storage[195] : 1'b0);
	assign readback_array[17][31:1] = 1'sb0;
	assign readback_array[18][0:0] = (decoded_reg_strb[15] && !decoded_req_is_wr ? hwif_in[10] : 1'b0);
	assign readback_array[18][1:1] = (decoded_reg_strb[15] && !decoded_req_is_wr ? hwif_in[9] : 1'b0);
	assign readback_array[18][7:2] = 1'sb0;
	assign readback_array[18][8:8] = (decoded_reg_strb[15] && !decoded_req_is_wr ? field_storage[194] : 1'b0);
	assign readback_array[18][9:9] = (decoded_reg_strb[15] && !decoded_req_is_wr ? field_storage[193] : 1'b0);
	assign readback_array[18][31:10] = 1'sb0;
	genvar _gv_i0_2;
	generate
		for (_gv_i0_2 = 0; _gv_i0_2 < 4; _gv_i0_2 = _gv_i0_2 + 1) begin : genblk2
			localparam i0 = _gv_i0_2;
			assign readback_array[(i0 * 3) + 19][1:0] = (decoded_reg_strb[3 + (((3 - i0) * 3) + 2)] && !decoded_req_is_wr ? hwif_in[1 + (((3 - i0) * 2) + 1)-:2] : {2 {1'sb0}});
			assign readback_array[(i0 * 3) + 19][31:2] = 1'sb0;
			assign readback_array[(i0 * 3) + 20][15:0] = (decoded_reg_strb[3 + (((3 - i0) * 3) + 1)] && !decoded_req_is_wr ? field_storage[1 + (((3 - i0) * 48) + 47)-:16] : {16 {1'sb0}});
			assign readback_array[(i0 * 3) + 20][31:16] = 1'sb0;
			assign readback_array[(i0 * 3) + 21][31:0] = (decoded_reg_strb[3 + ((3 - i0) * 3)] && !decoded_req_is_wr ? field_storage[1 + (((3 - i0) * 48) + 31)-:32] : {32 {1'sb0}});
		end
	endgenerate
	assign readback_array[31][0:0] = (decoded_reg_strb[2] && !decoded_req_is_wr ? hwif_in[-0] : 1'b0);
	assign readback_array[31][1:1] = (decoded_reg_strb[2] && !decoded_req_is_wr ? field_storage[-0] : 1'b0);
	assign readback_array[31][31:2] = 1'sb0;
	assign readback_array[32][15:0] = (decoded_reg_strb[1] && !decoded_req_is_wr ? 16'hcaca : {16 {1'sb0}});
	assign readback_array[32][31:16] = (decoded_reg_strb[1] && !decoded_req_is_wr ? 16'hccae : {16 {1'sb0}});
	assign readback_array[33][15:0] = (decoded_reg_strb[0] && !decoded_req_is_wr ? 16'h0000 : {16 {1'sb0}});
	assign readback_array[33][23:16] = (decoded_reg_strb[0] && !decoded_req_is_wr ? 8'h02 : {8 {1'sb0}});
	assign readback_array[33][31:24] = (decoded_reg_strb[0] && !decoded_req_is_wr ? 8'h00 : {8 {1'sb0}});
	always @(*) begin : sv2v_autoblock_22
		reg [31:0] readback_data_var;
		if (_sv2v_0)
			;
		readback_done = decoded_req & ~decoded_req_is_wr;
		readback_err = 1'sb0;
		readback_data_var = 1'sb0;
		begin : sv2v_autoblock_23
			reg signed [31:0] i;
			for (i = 0; i < 34; i = i + 1)
				readback_data_var = readback_data_var | readback_array[i];
		end
		readback_data = readback_data_var;
	end
	assign cpuif_rd_ack = readback_done;
	assign cpuif_rd_data = readback_data;
	assign cpuif_rd_err = readback_err;
	initial _sv2v_0 = 0;
endmodule
module top (
	clk_p,
	clk_n,
	rst_n,
	e1_reset,
	e1_mdc,
	e1_mdio,
	e1_rxc,
	e1_rxdv,
	e1_rxer,
	e1_rxd,
	e1_txc,
	e1_gtxc,
	e1_txen,
	e1_txer,
	e1_txd,
	e2_reset,
	e2_mdc,
	e2_mdio,
	e2_rxc,
	e2_rxdv,
	e2_rxer,
	e2_rxd,
	e2_txc,
	e2_gtxc,
	e2_txen,
	e2_txer,
	e2_txd,
	e3_reset,
	e3_mdc,
	e3_mdio,
	e3_rxc,
	e3_rxdv,
	e3_rxer,
	e3_rxd,
	e3_txc,
	e3_gtxc,
	e3_txen,
	e3_txer,
	e3_txd,
	e4_reset,
	e4_mdc,
	e4_mdio,
	e4_rxc,
	e4_rxdv,
	e4_rxer,
	e4_rxd,
	e4_txc,
	e4_gtxc,
	e4_txen,
	e4_txer,
	e4_txd,
	uart_rx,
	uart_tx,
	key_in,
	led
);
	input clk_p;
	input clk_n;
	input rst_n;
	output wire e1_reset;
	output wire e1_mdc;
	inout e1_mdio;
	input e1_rxc;
	input e1_rxdv;
	input e1_rxer;
	input [7:0] e1_rxd;
	input e1_txc;
	output wire e1_gtxc;
	output wire e1_txen;
	output wire e1_txer;
	output wire [7:0] e1_txd;
	output wire e2_reset;
	output wire e2_mdc;
	inout e2_mdio;
	input e2_rxc;
	input e2_rxdv;
	input e2_rxer;
	input [7:0] e2_rxd;
	input e2_txc;
	output wire e2_gtxc;
	output wire e2_txen;
	output wire e2_txer;
	output wire [7:0] e2_txd;
	output wire e3_reset;
	output wire e3_mdc;
	inout e3_mdio;
	input e3_rxc;
	input e3_rxdv;
	input e3_rxer;
	input [7:0] e3_rxd;
	input e3_txc;
	output wire e3_gtxc;
	output wire e3_txen;
	output wire e3_txer;
	output wire [7:0] e3_txd;
	output wire e4_reset;
	output wire e4_mdc;
	inout e4_mdio;
	input e4_rxc;
	input e4_rxdv;
	input e4_rxer;
	input [7:0] e4_rxd;
	input e4_txc;
	output wire e4_gtxc;
	output wire e4_txen;
	output wire e4_txer;
	output wire [7:0] e4_txd;
	input uart_rx;
	output wire uart_tx;
	input [1:0] key_in;
	output wire [1:0] led;
	wire sys_clk;
	wire sys_rst;
	wire sys_rst_n;
	wire eth_gtx_clk;
	wire eth_gtx_rst;
	clk_rst_gen u_clk_rst_gen(
		.clk_p(clk_p),
		.clk_n(clk_n),
		.rst_n(rst_n),
		.sys_clk(sys_clk),
		.sys_rst(sys_rst),
		.sys_rst_n(sys_rst_n),
		.eth_gtx_clk(eth_gtx_clk),
		.eth_gtx_rst(eth_gtx_rst)
	);
	generate
		if (1) begin : from_cpu
			wire clk;
			wire rst;
			reg tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign from_cpu.clk = sys_clk;
	assign from_cpu.rst = sys_rst;
	generate
		if (1) begin : from_eth_1
			wire clk;
			wire rst;
			reg tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign from_eth_1.clk = sys_clk;
	assign from_eth_1.rst = sys_rst;
	generate
		if (1) begin : from_eth_2
			wire clk;
			wire rst;
			reg tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign from_eth_2.clk = sys_clk;
	assign from_eth_2.rst = sys_rst;
	generate
		if (1) begin : from_eth_3
			wire clk;
			wire rst;
			reg tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign from_eth_3.clk = sys_clk;
	assign from_eth_3.rst = sys_rst;
	generate
		if (1) begin : from_eth_4
			wire clk;
			wire rst;
			reg tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign from_eth_4.clk = sys_clk;
	assign from_eth_4.rst = sys_rst;
	generate
		if (1) begin : to_cpu
			wire clk;
			wire rst;
			wire tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign to_cpu.clk = sys_clk;
	assign to_cpu.rst = sys_rst;
	generate
		if (1) begin : to_eth_1
			wire clk;
			wire rst;
			wire tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign to_eth_1.clk = sys_clk;
	assign to_eth_1.rst = sys_rst;
	generate
		if (1) begin : to_eth_2
			wire clk;
			wire rst;
			wire tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign to_eth_2.clk = sys_clk;
	assign to_eth_2.rst = sys_rst;
	generate
		if (1) begin : to_eth_3
			wire clk;
			wire rst;
			wire tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign to_eth_3.clk = sys_clk;
	assign to_eth_3.rst = sys_rst;
	generate
		if (1) begin : to_eth_4
			wire clk;
			wire rst;
			wire tready;
			wire tvalid;
			wire [127:0] tdata;
			wire tlast;
			wire [15:0] tkeep;
			wire tuser_bypass_all;
			wire tuser_bypass_stage;
			wire [2:0] tuser_src;
			wire [2:0] tuser_dst;
			wire [7:0] tid;
		end
	endgenerate
	assign to_eth_4.clk = sys_clk;
	assign to_eth_4.rst = sys_rst;
	wire [176:0] to_csr;
	wire [425:0] from_csr;
	localparam NUM_WORDS_IMEM = 8192;
	localparam NUM_WORDS_DMEM = 8192;
	generate
		if (1) begin : bus_cpu
			wire arst_n;
			wire clk;
			reg vld;
			wire rdy;
			localparam soc_pkg_SOC_DATAW = 32;
			localparam soc_pkg_SOC_BYTES = 4;
			localparam soc_pkg_SOC_ADDRL = 2;
			localparam soc_pkg_SOC_ADDRW = 32;
			reg [31:soc_pkg_SOC_ADDRL] addr;
			reg [3:0] we;
			reg [31:0] wdat;
			wire [31:0] rdat;
		end
	endgenerate
	assign bus_cpu.arst_n = sys_rst_n;
	assign bus_cpu.clk = sys_clk;
	generate
		if (1) begin : bus_uart
			wire arst_n;
			wire clk;
			wire vld;
			wire rdy;
			localparam soc_pkg_SOC_DATAW = 32;
			localparam soc_pkg_SOC_BYTES = 4;
			localparam soc_pkg_SOC_ADDRL = 2;
			localparam soc_pkg_SOC_ADDRW = 32;
			wire [31:soc_pkg_SOC_ADDRL] addr;
			wire [3:0] we;
			wire [31:0] wdat;
			wire [31:0] rdat;
		end
	endgenerate
	assign bus_uart.arst_n = sys_rst_n;
	assign bus_uart.clk = sys_clk;
	generate
		if (1) begin : bus_dmem
			wire arst_n;
			wire clk;
			wire vld;
			wire rdy;
			localparam soc_pkg_SOC_DATAW = 32;
			localparam soc_pkg_SOC_BYTES = 4;
			localparam soc_pkg_SOC_ADDRL = 2;
			localparam soc_pkg_SOC_ADDRW = 32;
			wire [31:soc_pkg_SOC_ADDRL] addr;
			wire [3:0] we;
			wire [31:0] wdat;
			reg [31:0] rdat;
		end
	endgenerate
	assign bus_dmem.arst_n = sys_rst_n;
	assign bus_dmem.clk = sys_clk;
	generate
		if (1) begin : bus_csr
			wire arst_n;
			wire clk;
			wire vld;
			wire rdy;
			localparam soc_pkg_SOC_DATAW = 32;
			localparam soc_pkg_SOC_BYTES = 4;
			localparam soc_pkg_SOC_ADDRL = 2;
			localparam soc_pkg_SOC_ADDRW = 32;
			wire [31:soc_pkg_SOC_ADDRL] addr;
			wire [3:0] we;
			wire [31:0] wdat;
			wire [31:0] rdat;
		end
	endgenerate
	assign bus_csr.arst_n = sys_rst_n;
	assign bus_csr.clk = sys_clk;
	wire imem_cpu_rstn;
	wire imem_we;
	wire [31:2] imem_waddr;
	wire [31:0] imem_wdat;
	localparam _param_EFD4F_ADDR_RESET = 32'h00000000;
	localparam _param_EFD4F_NUM_WORDS_IMEM = NUM_WORDS_IMEM;
	generate
		if (1) begin : u_cpu
			reg _sv2v_0;
			localparam [31:0] ADDR_RESET = _param_EFD4F_ADDR_RESET;
			localparam signed [31:0] NUM_WORDS_IMEM = _param_EFD4F_NUM_WORDS_IMEM;
			wire imem_cpu_rstn;
			wire imem_we;
			wire [31:2] imem_waddr;
			wire [31:0] imem_wdat;
			wire cpu_valid;
			reg cpu_instr;
			reg cpu_ready;
			wire [31:0] cpu_addr;
			wire [31:0] cpu_wdata;
			wire [3:0] cpu_wstrb;
			reg [31:0] cpu_rdata;
			reg imem_vld;
			wire imem_rdy;
			wire [31:0] imem_rdat;
			always @(*) begin : _decode
				if (_sv2v_0)
					;
				cpu_instr = cpu_addr[31:28] == {4 {1'sb0}};
				imem_vld = cpu_valid & cpu_instr;
				top.bus_cpu.vld = cpu_valid & ~cpu_instr;
				top.bus_cpu.we = cpu_wstrb;
				top.bus_cpu.addr = cpu_addr[31:2];
				top.bus_cpu.wdat = cpu_wdata;
				if (cpu_instr == 1'b1) begin
					cpu_ready = imem_rdy;
					cpu_rdata = imem_rdat;
				end
				else begin
					cpu_ready = top.bus_cpu.rdy;
					cpu_rdata = top.bus_cpu.rdat;
				end
			end
			wire trace_valid;
			wire [35:0] trace_data;
			localparam [0:0] sv2v_uu_u_cpu_ext_pcpi_wr_0 = 1'sb0;
			localparam [0:0] sv2v_uu_u_cpu_ext_pcpi_wait_0 = 1'sb0;
			localparam [0:0] sv2v_uu_u_cpu_ext_pcpi_ready_0 = 1'sb0;
			localparam [31:0] sv2v_uu_u_cpu_ext_irq_0 = 1'sb0;
			picorv32 #(
				.PROGADDR_RESET(ADDR_RESET),
				.STACKADDR(32'h10008000),
				.COMPRESSED_ISA(0),
				.TWO_STAGE_SHIFT(1),
				.TWO_CYCLE_COMPARE(0),
				.TWO_CYCLE_ALU(0),
				.LATCHED_MEM_RDATA(0),
				.BARREL_SHIFTER(0),
				.ENABLE_MUL(0),
				.ENABLE_FAST_MUL(0),
				.ENABLE_DIV(0),
				.ENABLE_REGS_DUALPORT(1),
				.ENABLE_REGS_16_31(1),
				.ENABLE_PCPI(0),
				.ENABLE_COUNTERS(0),
				.ENABLE_COUNTERS64(0),
				.ENABLE_TRACE(0),
				.ENABLE_IRQ(0),
				.ENABLE_IRQ_QREGS(0),
				.ENABLE_IRQ_TIMER(0),
				.MASKED_IRQ(32'h00000000),
				.LATCHED_IRQ(32'hffffffff),
				.PROGADDR_IRQ(32'h00000010),
				.CATCH_MISALIGN(1),
				.CATCH_ILLINSN(1),
				.REGS_INIT_ZERO(0)
			) u_cpu(
				.clk(top.bus_cpu.clk),
				.resetn(top.bus_cpu.arst_n & imem_cpu_rstn),
				.trap(),
				.mem_valid(cpu_valid),
				.mem_instr(),
				.mem_ready(cpu_ready),
				.mem_addr(cpu_addr),
				.mem_wdata(cpu_wdata),
				.mem_wstrb(cpu_wstrb),
				.mem_rdata(cpu_rdata),
				.mem_la_read(),
				.mem_la_write(),
				.mem_la_addr(),
				.mem_la_wdata(),
				.mem_la_wstrb(),
				.pcpi_valid(),
				.pcpi_insn(),
				.pcpi_rsrc1(),
				.pcpi_rsrc2(),
				.pcpi_wr(sv2v_uu_u_cpu_ext_pcpi_wr_0),
				.pcpi_wait(sv2v_uu_u_cpu_ext_pcpi_wait_0),
				.pcpi_ready(sv2v_uu_u_cpu_ext_pcpi_ready_0),
				.irq(sv2v_uu_u_cpu_ext_irq_0),
				.eoi(),
				.trace_valid(trace_valid),
				.trace_data(trace_data)
			);
			imem #(.NUM_WORDS(NUM_WORDS_IMEM)) u_imem(
				.clk(top.bus_cpu.clk),
				.arst_n(top.bus_cpu.arst_n),
				.rvld(imem_vld),
				.rrdy(imem_rdy),
				.raddr(cpu_addr[31:2]),
				.rdat(imem_rdat),
				.we(imem_we),
				.waddr(imem_waddr),
				.wdat(imem_wdat)
			);
			initial _sv2v_0 = 0;
		end
	endgenerate
	assign u_cpu.imem_cpu_rstn = imem_cpu_rstn;
	assign u_cpu.imem_we = imem_we;
	assign u_cpu.imem_waddr = imem_waddr;
	assign u_cpu.imem_wdat = imem_wdat;
	generate
		if (1) begin : u_fabric
			wire cpu_ack;
			reg uart_busy;
			wire uart_done;
			assign top.bus_dmem.addr = (cpu_ack ? top.bus_cpu.addr : top.bus_uart.addr);
			assign top.bus_dmem.we = (cpu_ack ? top.bus_cpu.we : top.bus_uart.we);
			assign top.bus_dmem.wdat = (cpu_ack ? top.bus_cpu.wdat : top.bus_uart.wdat);
			assign top.bus_csr.addr = (cpu_ack ? top.bus_cpu.addr : top.bus_uart.addr);
			assign top.bus_csr.we = (cpu_ack ? top.bus_cpu.we : top.bus_uart.we);
			assign top.bus_csr.wdat = (cpu_ack ? top.bus_cpu.wdat : top.bus_uart.wdat);
			wire dmem_sel;
			wire csr_sel;
			assign dmem_sel = (cpu_ack ? top.bus_cpu.addr[31:28] == 4'd1 : top.bus_uart.addr[31:28] == 4'd1);
			assign csr_sel = (cpu_ack ? top.bus_cpu.addr[31:29] == 3'd1 : top.bus_uart.addr[31:29] == 3'd1);
			assign top.bus_dmem.vld = (top.bus_uart.vld | top.bus_cpu.vld) & dmem_sel;
			assign top.bus_csr.vld = (top.bus_uart.vld | top.bus_cpu.vld) & csr_sel;
			assign top.bus_uart.rdy = (dmem_sel ? top.bus_dmem.rdy & uart_busy : (csr_sel ? top.bus_csr.rdy & uart_busy : 1'b0));
			assign top.bus_uart.rdat = (dmem_sel ? top.bus_dmem.rdat : (csr_sel ? top.bus_csr.rdat : {32 {1'sb0}}));
			assign top.bus_cpu.rdy = (dmem_sel ? top.bus_dmem.rdy & ~uart_busy : (csr_sel ? top.bus_csr.rdy & ~uart_busy : 1'b0));
			assign top.bus_cpu.rdat = (dmem_sel ? top.bus_dmem.rdat : (csr_sel ? top.bus_csr.rdat : {32 {1'sb0}}));
			always @(negedge top.bus_cpu.arst_n or posedge top.bus_cpu.clk)
				if (top.bus_cpu.arst_n == 1'b0)
					uart_busy <= 1'b0;
				else
					uart_busy <= (uart_busy ? ~uart_done | top.bus_uart.vld : {top.bus_cpu.vld, top.bus_uart.vld} == 2'b01);
			assign uart_done = (dmem_sel & top.bus_dmem.rdy) | (csr_sel & top.bus_csr.rdy);
			assign cpu_ack = top.bus_cpu.vld & ~uart_busy;
		end
	endgenerate
	localparam _param_7AE19_NUM_WORDS = NUM_WORDS_DMEM;
	generate
		if (1) begin : u_dmem
			reg _sv2v_0;
			localparam NUM_WORDS = _param_7AE19_NUM_WORDS;
			localparam ADDR_MSB = 14;
			localparam soc_pkg_SOC_DATAW = 32;
			localparam soc_pkg_SOC_BYTES = 4;
			localparam soc_pkg_SOC_ADDRL = 2;
			reg [ADDR_MSB:soc_pkg_SOC_ADDRL] addr;
			reg [3:0] we;
			reg write;
			always @(*) begin
				if (_sv2v_0)
					;
				addr = top.bus_dmem.addr[ADDR_MSB:soc_pkg_SOC_ADDRL];
				we = (top.bus_dmem.vld ? top.bus_dmem.we : {4 {1'sb0}});
				write = |top.bus_dmem.we;
			end
			reg [31:0] mem [0:8191];
			always @(posedge top.bus_dmem.clk) begin
				top.bus_dmem.rdat <= mem[addr];
				begin : sv2v_autoblock_1
					reg signed [31:0] i;
					for (i = 0; i < soc_pkg_SOC_BYTES; i = i + 1)
						if (we[i] == 1'b1)
							mem[addr][i * 8+:8] <= top.bus_dmem.wdat[i * 8+:8];
				end
			end
			reg rdy_rd;
			always @(negedge top.bus_dmem.arst_n or posedge top.bus_dmem.clk)
				if (top.bus_dmem.arst_n == 1'b0)
					rdy_rd <= 1'sb0;
				else
					rdy_rd <= (top.bus_dmem.vld & ~write) & ~top.bus_dmem.rdy;
			assign top.bus_dmem.rdy = write | rdy_rd;
			initial _sv2v_0 = 0;
		end
		if (1) begin : u_soc_csr
			wire [176:0] hwif_in;
			wire [425:0] hwif_out;
			wire [31:0] s_cpuif_wr_biten;
			assign s_cpuif_wr_biten[31:24] = (top.bus_csr.we[3] ? {8 {1'sb1}} : {8 {1'sb0}});
			assign s_cpuif_wr_biten[23:16] = (top.bus_csr.we[2] ? {8 {1'sb1}} : {8 {1'sb0}});
			assign s_cpuif_wr_biten[15:8] = (top.bus_csr.we[1] ? {8 {1'sb1}} : {8 {1'sb0}});
			assign s_cpuif_wr_biten[7:0] = (top.bus_csr.we[0] ? {8 {1'sb1}} : {8 {1'sb0}});
			assign top.bus_csr.rdy = 1'b1;
			localparam csr_pkg_CSR_MIN_ADDR_WIDTH = 8;
			csr csr_inst(
				.clk(top.bus_csr.clk),
				.rst(~top.bus_csr.arst_n),
				.s_cpuif_req(top.bus_csr.vld),
				.s_cpuif_req_is_wr(|top.bus_csr.we),
				.s_cpuif_addr({top.bus_csr.addr[7:2], 2'b00}),
				.s_cpuif_wr_data(top.bus_csr.wdat),
				.s_cpuif_wr_biten(s_cpuif_wr_biten),
				.s_cpuif_req_stall_wr(),
				.s_cpuif_req_stall_rd(),
				.s_cpuif_rd_ack(),
				.s_cpuif_rd_err(),
				.s_cpuif_rd_data(top.bus_csr.rdat),
				.s_cpuif_wr_ack(),
				.s_cpuif_wr_err(),
				.hwif_in(hwif_in),
				.hwif_out(hwif_out)
			);
		end
	endgenerate
	assign u_soc_csr.hwif_in = to_csr;
	assign from_csr = u_soc_csr.hwif_out;
	generate
		if (1) begin : u_uart
			reg _sv2v_0;
			wire arst_n;
			wire clk;
			wire uart_rx;
			reg uart_tx;
			wire [425:0] from_csr;
			reg [176:0] to_csr;
			wire imem_cpu_rstn;
			wire imem_we;
			wire [31:2] imem_waddr;
			wire [31:0] imem_wdat;
			reg [5:0] state;
			reg [5:0] state_next;
			localparam [7:0] C_SOP = 8'h12;
			localparam [7:0] C_EOP = 8'h14;
			localparam [7:0] C_IMPR = 8'h05;
			localparam [7:0] C_ACK = 8'h06;
			localparam [7:0] C_TOUT = 8'h07;
			localparam [7:0] C_BUSW = 8'h0e;
			localparam [7:0] C_BUSR = 8'h0f;
			localparam [7:0] C_IMWR = 8'h1a;
			reg tick_1us;
			localparam soc_pkg_PERIOD_PS = 12500;
			localparam soc_pkg_NUM_1US_CLKS = 79;
			localparam soc_pkg_CNT_1US_WIDTH = 7;
			reg [6:0] cnt_1us;
			always @(negedge arst_n or posedge clk)
				if (arst_n == 1'b0) begin
					tick_1us <= 1'b0;
					cnt_1us <= 1'sb0;
				end
				else begin
					begin : sv2v_autoblock_2
						reg [6:0] sv2v_tmp_cast;
						sv2v_tmp_cast = 78;
						tick_1us <= cnt_1us == sv2v_tmp_cast;
					end
					if (tick_1us == 1'b1)
						cnt_1us <= 1'sb0;
					else begin : sv2v_autoblock_3
						reg [6:0] sv2v_tmp_cast_1;
						sv2v_tmp_cast_1 = 1;
						cnt_1us <= cnt_1us + sv2v_tmp_cast_1;
					end
				end
			reg [1:0] uart_rx_ff;
			always @(negedge arst_n or posedge clk)
				if (arst_n == 1'b0)
					uart_rx_ff <= 1'sb1;
				else
					uart_rx_ff <= {uart_rx_ff[0], uart_rx};
			wire uart_rx_sync;
			assign uart_rx_sync = uart_rx_ff[1];
			localparam [3:0] RX_WAIT_D0 = 4'd13;
			localparam [3:0] RX_WAIT_D1 = 4'd7;
			localparam [3:0] RX_WAIT_D2 = 4'd8;
			localparam [3:0] RX_WAIT_D3 = 4'd8;
			localparam [3:0] RX_WAIT_D4 = 4'd7;
			localparam [3:0] RX_WAIT_D5 = 4'd8;
			localparam [3:0] RX_WAIT_D6 = 4'd8;
			localparam [3:0] RX_WAIT_D7 = 4'd7;
			localparam [3:0] RX_WAIT_STOP = 4'd8;
			(* fsm_encoding = "none" *) reg [3:0] rx_state;
			reg [3:0] rx_cnt1us;
			reg rx_cnt1us_is0;
			reg rx_nextbit;
			reg [7:0] rx_shift;
			reg rx_fifo_we;
			wire rx_fifo_full;
			reg rx_oflow;
			wire rx_fifo_empty;
			always @(*) begin
				if (_sv2v_0)
					;
				rx_cnt1us_is0 = rx_cnt1us == {4 {1'sb0}};
				rx_nextbit = tick_1us & rx_cnt1us_is0;
				to_csr[13] = rx_oflow;
				to_csr[12] = ~rx_fifo_empty;
				rx_fifo_we = rx_nextbit & (rx_state == 4'd8);
			end
			always @(negedge arst_n or posedge clk)
				if (arst_n == 1'b0) begin
					rx_state <= 4'd14;
					rx_cnt1us <= 1'sb0;
					rx_shift <= 1'sb0;
					rx_oflow <= 1'b0;
				end
				else begin
					if ((tick_1us == 1'b1) && (rx_state != 4'd14))
						rx_cnt1us <= rx_cnt1us - 4'd1;
					if ({rx_fifo_we, rx_fifo_full} == 2'b11)
						rx_oflow <= 1'b1;
					else if (from_csr[270] == 1'b1)
						rx_oflow <= 1'b0;
					(* full_case, parallel_case *)
					case (rx_state)
						4'd14: begin
							rx_cnt1us <= RX_WAIT_D0;
							if (uart_rx_sync == 1'b0)
								rx_state <= 4'd0;
						end
						4'd8:
							if (rx_nextbit == 1'b1)
								rx_state <= 4'd14;
						default:
							if (rx_nextbit == 1'b1) begin
								rx_shift <= {uart_rx_sync, rx_shift[7:1]};
								(* full_case, parallel_case *)
								case (rx_state)
									4'd0: begin
										rx_cnt1us <= RX_WAIT_D1;
										rx_state <= 4'd1;
									end
									4'd1: begin
										rx_cnt1us <= RX_WAIT_D2;
										rx_state <= 4'd2;
									end
									4'd2: begin
										rx_cnt1us <= RX_WAIT_D3;
										rx_state <= 4'd3;
									end
									4'd3: begin
										rx_cnt1us <= RX_WAIT_D4;
										rx_state <= 4'd4;
									end
									4'd4: begin
										rx_cnt1us <= RX_WAIT_D5;
										rx_state <= 4'd5;
									end
									4'd5: begin
										rx_cnt1us <= RX_WAIT_D6;
										rx_state <= 4'd6;
									end
									4'd6: begin
										rx_cnt1us <= RX_WAIT_D7;
										rx_state <= 4'd7;
									end
									4'd7: begin
										rx_cnt1us <= RX_WAIT_STOP;
										rx_state <= 4'd8;
									end
									default:
										;
								endcase
							end
					endcase
				end
			reg bus_vld;
			wire [8:1] sv2v_tmp_u_rx_fifo_dout_comb;
			always @(*) to_csr[21-:8] = sv2v_tmp_u_rx_fifo_dout_comb;
			sync_fifo_ram #(
				.DWIDTH(8),
				.AWIDTH(4)
			) u_rx_fifo(
				.arst_n(arst_n),
				.clk(clk),
				.din(rx_shift),
				.we(~bus_vld & rx_fifo_we),
				.re(from_csr[270]),
				.dcount(),
				.empty(rx_fifo_empty),
				.full(rx_fifo_full),
				.dout_comb(sv2v_tmp_u_rx_fifo_dout_comb),
				.dout()
			);
			localparam [3:0] TX_WAIT_START = 4'd9;
			localparam [3:0] TX_WAIT_D0 = 4'd7;
			localparam [3:0] TX_WAIT_D1 = 4'd8;
			localparam [3:0] TX_WAIT_D2 = 4'd8;
			localparam [3:0] TX_WAIT_D3 = 4'd7;
			localparam [3:0] TX_WAIT_D4 = 4'd8;
			localparam [3:0] TX_WAIT_D5 = 4'd8;
			localparam [3:0] TX_WAIT_D6 = 4'd7;
			localparam [3:0] TX_WAIT_D7 = 4'd8;
			localparam [3:0] TX_WAIT_STOP = 4'd8;
			(* fsm_encoding = "none" *) reg [3:0] tx_state;
			reg [3:0] tx_cnt1us;
			reg tx_cnt1us_is0;
			reg tx_nextbit;
			wire [7:0] tx_data;
			reg tx_fifo_re;
			wire tx_fifo_empty;
			always @(*) begin
				if (_sv2v_0)
					;
				tx_cnt1us_is0 = tx_cnt1us == {4 {1'sb0}};
				tx_nextbit = tick_1us & tx_cnt1us_is0;
				tx_fifo_re = tx_nextbit & (tx_state == 4'd8);
			end
			always @(negedge arst_n or posedge clk)
				if (arst_n == 1'b0) begin
					tx_state <= 4'd14;
					tx_cnt1us <= 1'sb0;
					uart_tx <= 1'b1;
				end
				else begin
					if ((tick_1us == 1'b1) && (tx_state != 4'd14))
						tx_cnt1us <= tx_cnt1us - 4'd1;
					(* full_case, parallel_case *)
					case (tx_state)
						4'd14: begin
							uart_tx <= 1'b1;
							tx_cnt1us <= TX_WAIT_START;
							if (tx_fifo_empty == 1'b0)
								tx_state <= 4'd15;
						end
						4'd15:
							if (tick_1us == 1'b1) begin
								uart_tx <= 1'b0;
								if (tx_cnt1us_is0 == 1'b1) begin
									uart_tx <= tx_data[0];
									tx_cnt1us <= TX_WAIT_D0;
									tx_state <= 4'd0;
								end
							end
						4'd0:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[1];
								tx_cnt1us <= TX_WAIT_D1;
								tx_state <= 4'd1;
							end
						4'd1:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[2];
								tx_cnt1us <= TX_WAIT_D2;
								tx_state <= 4'd2;
							end
						4'd2:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[3];
								tx_cnt1us <= TX_WAIT_D3;
								tx_state <= 4'd3;
							end
						4'd3:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[4];
								tx_cnt1us <= TX_WAIT_D4;
								tx_state <= 4'd4;
							end
						4'd4:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[5];
								tx_cnt1us <= TX_WAIT_D5;
								tx_state <= 4'd5;
							end
						4'd5:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[6];
								tx_cnt1us <= TX_WAIT_D6;
								tx_state <= 4'd6;
							end
						4'd6:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= tx_data[7];
								tx_cnt1us <= TX_WAIT_D7;
								tx_state <= 4'd7;
							end
						4'd7:
							if (tx_nextbit == 1'b1) begin
								uart_tx <= 1'b1;
								tx_cnt1us <= TX_WAIT_STOP;
								tx_state <= 4'd8;
							end
						4'd8:
							if (tx_nextbit == 1'b1)
								tx_state <= 4'd14;
						default:
							;
					endcase
				end
			wire uart_tx_busy;
			reg uart_tx_valid;
			reg uart_tx_valid_next;
			reg [7:0] uart_tx_data;
			reg [7:0] uart_tx_data_next;
			wire [1:1] sv2v_tmp_6DCD1;
			assign sv2v_tmp_6DCD1 = uart_tx_busy;
			always @(*) to_csr[11] = sv2v_tmp_6DCD1;
			sync_fifo_ram #(
				.DWIDTH(8),
				.AWIDTH(4)
			) u_tx_fifo(
				.arst_n(arst_n),
				.clk(clk),
				.din((bus_vld ? uart_tx_data : from_csr[268-:8])),
				.we((bus_vld ? uart_tx_valid : from_csr[259])),
				.re(tx_fifo_re),
				.dcount(),
				.empty(tx_fifo_empty),
				.full(uart_tx_busy),
				.dout_comb(tx_data),
				.dout()
			);
			wire [7:0] uart_rx_data;
			wire uart_rx_valid;
			assign uart_rx_data = rx_shift;
			assign uart_rx_valid = rx_fifo_we;
			reg cpu_rstn;
			reg cpu_rstn_next;
			reg [15:0] data_length;
			reg [15:0] data_length_next;
			reg [15:0] data_cnt;
			reg [15:0] data_cnt_next;
			reg ram_wen;
			reg ram_wen_next;
			reg [31:0] ram_data;
			reg [31:0] ram_data_next;
			reg [31:0] ram_addr;
			reg [31:0] ram_addr_next;
			reg bus_vld_next;
			reg [3:0] bus_we;
			reg [3:0] bus_we_next;
			reg [31:0] bus_addr;
			reg [31:0] bus_addr_next;
			reg [31:0] bus_rdat;
			reg [31:0] bus_rdat_next;
			reg [31:0] bus_wdat;
			reg [31:0] bus_wdat_next;
			reg [7:0] checksum;
			reg [7:0] checksum_next;
			reg [21:0] timeout;
			reg [21:0] timeout_next;
			always @(negedge arst_n or posedge clk)
				if (arst_n == 1'b0) begin
					state <= 6'd0;
					cpu_rstn <= 1'b1;
					data_length <= 1'sb0;
					data_cnt <= 1'sb0;
					ram_wen <= 1'b0;
					ram_addr <= 1'sb0;
					ram_data <= 1'sb0;
					bus_vld <= 1'b0;
					bus_we <= 1'sb0;
					bus_addr <= 32'h10000000;
					bus_rdat <= 1'sb0;
					bus_wdat <= 1'sb0;
					checksum <= 1'sb0;
					timeout <= 1'sb0;
					uart_tx_valid <= 1'b0;
					uart_tx_data <= 1'sb0;
				end
				else begin
					state <= state_next;
					cpu_rstn <= cpu_rstn_next;
					data_length <= data_length_next;
					data_cnt <= data_cnt_next;
					ram_wen <= ram_wen_next;
					ram_addr <= ram_addr_next;
					ram_data <= ram_data_next;
					bus_vld <= bus_vld_next;
					bus_we <= bus_we_next;
					bus_addr <= bus_addr_next;
					bus_rdat <= bus_rdat_next;
					bus_wdat <= bus_wdat_next;
					checksum <= checksum_next;
					timeout <= timeout_next;
					uart_tx_valid <= uart_tx_valid_next;
					uart_tx_data <= uart_tx_data_next;
				end
			always @(*) begin
				if (_sv2v_0)
					;
				state_next = state;
				cpu_rstn_next = cpu_rstn;
				data_length_next = data_length;
				data_cnt_next = data_cnt;
				ram_wen_next = ram_wen;
				ram_addr_next = ram_addr;
				ram_data_next = ram_data;
				bus_vld_next = bus_vld;
				bus_we_next = bus_we;
				bus_addr_next = bus_addr;
				bus_rdat_next = bus_rdat;
				bus_wdat_next = bus_wdat;
				checksum_next = checksum;
				timeout_next = timeout;
				uart_tx_valid_next = uart_tx_valid;
				uart_tx_data_next = uart_tx_data;
				(* full_case, parallel_case *)
				case (state)
					6'd0:
						if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_SOP)) begin
							bus_vld_next = 1'b1;
							state_next = 6'd1;
						end
					6'd1:
						if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_IMPR)) begin
							cpu_rstn_next = 1'b0;
							data_cnt_next = 1'sb0;
							checksum_next = 1'sb0;
							timeout_next = 1'sb0;
							state_next = 6'd2;
						end
						else if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_BUSW)) begin
							checksum_next = 1'sb0;
							timeout_next = 1'sb0;
							state_next = 6'd10;
						end
						else if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_BUSR)) begin
							checksum_next = 1'sb0;
							timeout_next = 1'sb0;
							state_next = 6'd21;
						end
						else if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_IMWR)) begin
							checksum_next = 1'sb0;
							timeout_next = 1'sb0;
							state_next = 6'd32;
						end
						else if ((uart_rx_valid == 1'b1) && (uart_rx_data == C_EOP)) begin
							bus_vld_next = 1'b0;
							state_next = 6'd0;
						end
					6'd2:
						if (uart_rx_valid == 1'b1) begin
							data_length_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd3;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd3:
						if (uart_rx_valid == 1'b1) begin
							data_length_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd4;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd4:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd5;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd5:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd6;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd6:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[23:16] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd7;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd7:
						if (uart_rx_valid == 1'b1) begin
							data_cnt_next = data_cnt + 1;
							ram_data_next[31:24] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							ram_addr_next = {14'd0, data_cnt, 2'd0};
							ram_wen_next = 1'b1;
							uart_tx_data_next = C_ACK;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd8;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd8:
						if (data_cnt == data_length) begin
							ram_wen_next = 1'b0;
							uart_tx_data_next = checksum;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd9;
						end
						else begin
							ram_wen_next = 1'b0;
							uart_tx_valid_next = 1'b0;
							timeout_next = 1'sb0;
							state_next = 6'd4;
						end
					6'd9: begin
						cpu_rstn_next = 1'b1;
						uart_tx_valid_next = 1'b0;
						state_next = 6'd1;
					end
					6'd10:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd11;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd11:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd12;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd12:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[23:16] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd13;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd13:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[31:24] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd14;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd14:
						if (uart_rx_valid == 1'b1) begin
							bus_wdat_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd15;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd15:
						if (uart_rx_valid == 1'b1) begin
							bus_wdat_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd16;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd16:
						if (uart_rx_valid == 1'b1) begin
							bus_wdat_next[23:16] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd17;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd17:
						if (uart_rx_valid == 1'b1) begin
							bus_wdat_next[31:24] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd18;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd18:
						if (uart_rx_valid == 1'b1) begin
							bus_we_next = uart_rx_data[3:0];
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd19;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd19: begin
						bus_we_next = 1'sb0;
						uart_tx_data_next = checksum;
						uart_tx_valid_next = 1'b1;
						state_next = 6'd20;
					end
					6'd20: begin
						uart_tx_valid_next = 1'b0;
						state_next = 6'd1;
					end
					6'd21:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd22;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd22:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd23;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd23:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[23:16] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd24;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd24:
						if (uart_rx_valid == 1'b1) begin
							bus_addr_next[31:24] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd25;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd25:
						if (top.bus_uart.rdy == 1'b1) begin
							bus_rdat_next = top.bus_uart.rdat;
							timeout_next = 1'sb0;
							state_next = 6'd26;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd26: begin
						uart_tx_data_next = bus_rdat[7:0];
						checksum_next = checksum + bus_rdat[7:0];
						uart_tx_valid_next = 1'b1;
						state_next = 6'd27;
					end
					6'd27: begin
						uart_tx_data_next = bus_rdat[15:8];
						checksum_next = checksum + bus_rdat[15:8];
						uart_tx_valid_next = 1'b1;
						state_next = 6'd28;
					end
					6'd28: begin
						uart_tx_data_next = bus_rdat[23:16];
						checksum_next = checksum + bus_rdat[23:16];
						uart_tx_valid_next = 1'b1;
						state_next = 6'd29;
					end
					6'd29: begin
						uart_tx_data_next = bus_rdat[31:24];
						checksum_next = checksum + bus_rdat[31:24];
						uart_tx_valid_next = 1'b1;
						state_next = 6'd30;
					end
					6'd30: begin
						uart_tx_data_next = checksum;
						uart_tx_valid_next = 1'b1;
						state_next = 6'd31;
					end
					6'd31: begin
						uart_tx_valid_next = 1'b0;
						state_next = 6'd1;
					end
					6'd32:
						if (uart_rx_valid == 1'b1) begin
							ram_addr_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd33;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd33:
						if (uart_rx_valid == 1'b1) begin
							ram_addr_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd34;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd34:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[7:0] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd35;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd35:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[15:8] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd36;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd36:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[23:16] = uart_rx_data;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd37;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd37:
						if (uart_rx_valid == 1'b1) begin
							ram_data_next[31:24] = uart_rx_data;
							ram_wen_next = 1'b1;
							checksum_next = checksum + uart_rx_data;
							timeout_next = 1'sb0;
							state_next = 6'd38;
						end
						else if (timeout[21:21] == 1'b1) begin
							uart_tx_data_next = C_TOUT;
							uart_tx_valid_next = 1'b1;
							state_next = 6'd40;
						end
						else if (tick_1us == 1'b1)
							timeout_next = timeout + 22'd1;
					6'd38: begin
						ram_wen_next = 1'b0;
						uart_tx_data_next = checksum;
						uart_tx_valid_next = 1'b1;
						state_next = 6'd39;
					end
					6'd39: begin
						uart_tx_valid_next = 1'b0;
						state_next = 6'd1;
					end
					6'd40: begin
						uart_tx_valid_next = 1'b0;
						ram_wen_next = 1'b0;
						cpu_rstn_next = 1'b1;
						bus_vld_next = 1'b0;
						state_next = 6'd0;
					end
					default: begin
						state_next = state;
						cpu_rstn_next = cpu_rstn;
						data_length_next = data_length;
						data_cnt_next = data_cnt;
						ram_wen_next = ram_wen;
						ram_addr_next = ram_addr;
						ram_data_next = ram_data;
						bus_vld_next = bus_vld;
						bus_we_next = bus_we;
						bus_addr_next = bus_addr;
						bus_rdat_next = bus_rdat;
						bus_wdat_next = bus_wdat;
						checksum_next = checksum;
						timeout_next = timeout;
						uart_tx_valid_next = uart_tx_valid;
						uart_tx_data_next = uart_tx_data;
					end
				endcase
			end
			assign imem_cpu_rstn = cpu_rstn;
			assign imem_we = ram_wen;
			assign imem_waddr[31:2] = ram_addr[31:2];
			assign imem_wdat = ram_data;
			assign top.bus_uart.vld = bus_vld;
			assign top.bus_uart.we = bus_we;
			assign top.bus_uart.addr[31:2] = bus_addr[31:2];
			assign top.bus_uart.wdat = bus_wdat;
			initial _sv2v_0 = 0;
		end
	endgenerate
	assign u_uart.arst_n = sys_rst_n;
	assign u_uart.clk = sys_clk;
	assign u_uart.uart_rx = uart_rx;
	assign uart_tx = u_uart.uart_tx;
	assign u_uart.from_csr = from_csr;
	assign to_csr = u_uart.to_csr;
	assign imem_cpu_rstn = u_uart.imem_cpu_rstn;
	assign imem_we = u_uart.imem_we;
	assign imem_waddr = u_uart.imem_waddr;
	assign imem_wdat = u_uart.imem_wdat;
	generate
		if (1) begin : u_cpu_fifo
			wire [425:0] from_csr;
			wire [176:0] to_csr;
			axis_fifo #(
				.DEPTH(4096),
				.DATA_WIDTH(128),
				.USER_WIDTH(8),
				.FRAME_FIFO(1),
				.DROP_WHEN_FULL(1)
			) tx_fifo(
				.clk(top.to_cpu.clk),
				.rst(top.to_cpu.rst),
				.s_axis_tdata(top.to_cpu.tdata),
				.s_axis_tkeep(top.to_cpu.tkeep),
				.s_axis_tvalid(top.to_cpu.tvalid),
				.s_axis_tready(top.to_cpu.tready),
				.s_axis_tlast(top.to_cpu.tlast),
				.s_axis_tuser({top.to_cpu.tuser_bypass_all, top.to_cpu.tuser_bypass_stage, top.to_cpu.tuser_src, top.to_cpu.tuser_dst}),
				.s_axis_tid(),
				.s_axis_tdest(),
				.m_axis_tdata({to_csr[79-:32], to_csr[111-:32], to_csr[143-:32], to_csr[175-:32]}),
				.m_axis_tkeep(to_csr[38-:16]),
				.m_axis_tvalid(to_csr[22]),
				.m_axis_tready(from_csr[271]),
				.m_axis_tlast(to_csr[39]),
				.m_axis_tuser({to_csr[40], to_csr[41], to_csr[44-:3], to_csr[47-:3]}),
				.m_axis_tid(),
				.m_axis_tdest(),
				.pause_req(),
				.pause_ack(),
				.status_depth(),
				.status_depth_commit(),
				.status_overflow(),
				.status_bad_frame(),
				.status_good_frame()
			);
			axis_fifo #(
				.DEPTH(4096),
				.DATA_WIDTH(128),
				.USER_WIDTH(8),
				.FRAME_FIFO(1),
				.DROP_WHEN_FULL(1)
			) rx_fifo(
				.clk(top.to_cpu.clk),
				.rst(top.to_cpu.rst),
				.s_axis_tdata({from_csr[329-:32], from_csr[361-:32], from_csr[393-:32], from_csr[425-:32]}),
				.s_axis_tkeep(from_csr[288-:16]),
				.s_axis_tvalid(from_csr[272]),
				.s_axis_tready(to_csr[176]),
				.s_axis_tlast(from_csr[289]),
				.s_axis_tuser({from_csr[290], from_csr[291], from_csr[294-:3], from_csr[297-:3]}),
				.s_axis_tid(),
				.s_axis_tdest(),
				.m_axis_tdata(top.from_cpu.tdata),
				.m_axis_tkeep(top.from_cpu.tkeep),
				.m_axis_tvalid(top.from_cpu.tvalid),
				.m_axis_tready(top.from_cpu.tready),
				.m_axis_tlast(top.from_cpu.tlast),
				.m_axis_tuser({top.from_cpu.tuser_bypass_all, top.from_cpu.tuser_bypass_stage, top.from_cpu.tuser_src, top.from_cpu.tuser_dst}),
				.m_axis_tid(),
				.m_axis_tdest(),
				.pause_req(),
				.pause_ack(),
				.status_depth(),
				.status_depth_commit(),
				.status_overflow(),
				.status_bad_frame(),
				.status_good_frame()
			);
		end
	endgenerate
	assign u_cpu_fifo.from_csr = from_csr;
	assign to_csr = u_cpu_fifo.to_csr;
	assign led[1] = ~from_csr[257];
	assign led[0] = ~from_csr[258];
	assign to_csr[9] = ~key_in[1];
	assign to_csr[10] = ~key_in[0];
	generate
		if (1) begin : u_dpe
			wire [425:0] from_csr;
			wire [176:0] to_csr;
			if (1) begin : muxed_1
				wire clk;
				wire rst;
				wire tready;
				wire tvalid;
				wire [127:0] tdata;
				wire tlast;
				wire [15:0] tkeep;
				wire tuser_bypass_all;
				wire tuser_bypass_stage;
				wire [2:0] tuser_src;
				wire [2:0] tuser_dst;
				wire [7:0] tid;
			end
			assign muxed_1.clk = top.from_cpu.clk;
			assign muxed_1.rst = top.from_cpu.rst;
			if (1) begin : muxed_2
				wire clk;
				wire rst;
				wire tready;
				wire tvalid;
				wire [127:0] tdata;
				wire tlast;
				wire [15:0] tkeep;
				wire tuser_bypass_all;
				wire tuser_bypass_stage;
				wire [2:0] tuser_src;
				wire [2:0] tuser_dst;
				wire [7:0] tid;
			end
			assign muxed_2.clk = top.from_cpu.clk;
			assign muxed_2.rst = top.from_cpu.rst;
			if (1) begin : mux
				reg _sv2v_0;
				wire pause;
				reg is_idle;
				reg [3:0] state;
				reg [3:0] next_state;
				if (1) begin : to_dpe_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_dpe_sbuff.clk = top.from_cpu.clk;
				assign to_dpe_sbuff.rst = top.from_cpu.rst;
				always @(posedge top.from_cpu.clk)
					if (top.from_cpu.rst)
						state <= 4'd0;
					else
						state <= next_state;
				always @(*) begin
					if (_sv2v_0)
						;
					next_state = state;
					(* full_case, parallel_case *)
					case (state)
						4'd0:
							if (!pause)
								next_state = 4'd1;
						4'd1:
							if (top.from_cpu.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd2;
							else if (pause)
								next_state = 4'd0;
							else if (!top.from_cpu.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd3;
						4'd2:
							if ((top.from_cpu.tlast && top.from_cpu.tvalid) && to_dpe_sbuff.tready)
								next_state = (pause ? 4'd0 : 4'd3);
						4'd3:
							if (top.from_eth_1.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd4;
							else if (pause)
								next_state = 4'd0;
							else if (!top.from_eth_1.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd5;
						4'd4:
							if ((top.from_eth_1.tlast && top.from_eth_1.tvalid) && to_dpe_sbuff.tready)
								next_state = (pause ? 4'd0 : 4'd5);
						4'd5:
							if (top.from_eth_2.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd6;
							else if (pause)
								next_state = 4'd0;
							else if (!top.from_eth_2.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd7;
						4'd6:
							if ((top.from_eth_2.tlast && top.from_eth_2.tvalid) && to_dpe_sbuff.tready)
								next_state = (pause ? 4'd0 : 4'd7);
						4'd7:
							if (top.from_eth_3.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd8;
							else if (pause)
								next_state = 4'd0;
							else if (!top.from_eth_3.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd9;
						4'd8:
							if ((top.from_eth_3.tlast && top.from_eth_3.tvalid) && to_dpe_sbuff.tready)
								next_state = (pause ? 4'd0 : 4'd9);
						4'd9:
							if (top.from_eth_4.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd10;
							else if (pause)
								next_state = 4'd0;
							else if (!top.from_eth_4.tvalid && to_dpe_sbuff.tready)
								next_state = 4'd1;
						4'd10:
							if ((top.from_eth_4.tlast && top.from_eth_4.tvalid) && to_dpe_sbuff.tready)
								next_state = (pause ? 4'd0 : 4'd1);
						default: next_state = state;
					endcase
				end
				localparam dpe_pkg_DPE_ADDR_CPU = 3'h0;
				localparam dpe_pkg_DPE_ADDR_ETH_1 = 3'h1;
				localparam dpe_pkg_DPE_ADDR_ETH_2 = 3'h2;
				localparam dpe_pkg_DPE_ADDR_ETH_3 = 3'h3;
				localparam dpe_pkg_DPE_ADDR_ETH_4 = 3'h4;
				always @(*) begin
					if (_sv2v_0)
						;
					is_idle = 1'b0;
					to_dpe_sbuff.tvalid = 1'b0;
					to_dpe_sbuff.tdata = 1'sb0;
					to_dpe_sbuff.tlast = 1'b0;
					to_dpe_sbuff.tkeep = 1'sb0;
					to_dpe_sbuff.tuser_bypass_all = 1'b0;
					to_dpe_sbuff.tuser_bypass_stage = 1'b0;
					to_dpe_sbuff.tuser_src = 1'sb0;
					to_dpe_sbuff.tuser_dst = 1'sb0;
					top.from_cpu.tready = 1'b0;
					top.from_eth_1.tready = 1'b0;
					top.from_eth_2.tready = 1'b0;
					top.from_eth_3.tready = 1'b0;
					top.from_eth_4.tready = 1'b0;
					(* full_case, parallel_case *)
					case (state)
						4'd0: is_idle = !top.u_dpe.muxed_1.tvalid;
						4'd1, 4'd2: begin
							is_idle = 1'b0;
							to_dpe_sbuff.tvalid = top.from_cpu.tvalid;
							to_dpe_sbuff.tdata = top.from_cpu.tdata;
							to_dpe_sbuff.tlast = top.from_cpu.tlast;
							to_dpe_sbuff.tkeep = top.from_cpu.tkeep;
							to_dpe_sbuff.tuser_bypass_all = top.from_cpu.tuser_bypass_all;
							to_dpe_sbuff.tuser_bypass_stage = top.from_cpu.tuser_bypass_stage;
							to_dpe_sbuff.tuser_src = dpe_pkg_DPE_ADDR_CPU;
							to_dpe_sbuff.tuser_dst = top.from_cpu.tuser_dst;
							top.from_cpu.tready = to_dpe_sbuff.tready;
						end
						4'd3, 4'd4: begin
							is_idle = 1'b0;
							to_dpe_sbuff.tvalid = top.from_eth_1.tvalid;
							to_dpe_sbuff.tdata = top.from_eth_1.tdata;
							to_dpe_sbuff.tlast = top.from_eth_1.tlast;
							to_dpe_sbuff.tkeep = top.from_eth_1.tkeep;
							to_dpe_sbuff.tuser_bypass_all = top.from_eth_1.tuser_bypass_all;
							to_dpe_sbuff.tuser_bypass_stage = top.from_eth_1.tuser_bypass_stage;
							to_dpe_sbuff.tuser_src = dpe_pkg_DPE_ADDR_ETH_1;
							to_dpe_sbuff.tuser_dst = top.from_eth_1.tuser_dst;
							top.from_eth_1.tready = to_dpe_sbuff.tready;
						end
						4'd5, 4'd6: begin
							is_idle = 1'b0;
							to_dpe_sbuff.tvalid = top.from_eth_2.tvalid;
							to_dpe_sbuff.tdata = top.from_eth_2.tdata;
							to_dpe_sbuff.tlast = top.from_eth_2.tlast;
							to_dpe_sbuff.tkeep = top.from_eth_2.tkeep;
							to_dpe_sbuff.tuser_bypass_all = top.from_eth_2.tuser_bypass_all;
							to_dpe_sbuff.tuser_bypass_stage = top.from_eth_2.tuser_bypass_stage;
							to_dpe_sbuff.tuser_src = dpe_pkg_DPE_ADDR_ETH_2;
							to_dpe_sbuff.tuser_dst = top.from_eth_2.tuser_dst;
							top.from_eth_2.tready = to_dpe_sbuff.tready;
						end
						4'd7, 4'd8: begin
							is_idle = 1'b0;
							to_dpe_sbuff.tvalid = top.from_eth_3.tvalid;
							to_dpe_sbuff.tdata = top.from_eth_3.tdata;
							to_dpe_sbuff.tlast = top.from_eth_3.tlast;
							to_dpe_sbuff.tkeep = top.from_eth_3.tkeep;
							to_dpe_sbuff.tuser_bypass_all = top.from_eth_3.tuser_bypass_all;
							to_dpe_sbuff.tuser_bypass_stage = top.from_eth_3.tuser_bypass_stage;
							to_dpe_sbuff.tuser_src = dpe_pkg_DPE_ADDR_ETH_3;
							to_dpe_sbuff.tuser_dst = top.from_eth_3.tuser_dst;
							top.from_eth_3.tready = to_dpe_sbuff.tready;
						end
						4'd9, 4'd10: begin
							is_idle = 1'b0;
							to_dpe_sbuff.tvalid = top.from_eth_4.tvalid;
							to_dpe_sbuff.tdata = top.from_eth_4.tdata;
							to_dpe_sbuff.tlast = top.from_eth_4.tlast;
							to_dpe_sbuff.tkeep = top.from_eth_4.tkeep;
							to_dpe_sbuff.tuser_bypass_all = top.from_eth_4.tuser_bypass_all;
							to_dpe_sbuff.tuser_bypass_stage = top.from_eth_4.tuser_bypass_stage;
							to_dpe_sbuff.tuser_src = dpe_pkg_DPE_ADDR_ETH_4;
							to_dpe_sbuff.tuser_dst = top.from_eth_4.tuser_dst;
							top.from_eth_4.tready = to_dpe_sbuff.tready;
						end
						default: is_idle = !top.u_dpe.muxed_1.tvalid;
					endcase
				end
				if (1) begin : skid_buffer_to_dpe
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.mux.to_dpe_sbuff.clk),
						.rst(top.u_dpe.mux.to_dpe_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.mux.to_dpe_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.mux.to_dpe_sbuff.tready),
						.s_axis_tdata(top.u_dpe.mux.to_dpe_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.mux.to_dpe_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.mux.to_dpe_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.mux.to_dpe_sbuff.tuser_bypass_all, top.u_dpe.mux.to_dpe_sbuff.tuser_bypass_stage, top.u_dpe.mux.to_dpe_sbuff.tuser_src, top.u_dpe.mux.to_dpe_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.mux.to_dpe_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.u_dpe.muxed_1.tvalid),
						.m_axis_tready(top.u_dpe.muxed_1.tready),
						.m_axis_tdata(top.u_dpe.muxed_1.tdata),
						.m_axis_tkeep(top.u_dpe.muxed_1.tkeep),
						.m_axis_tlast(top.u_dpe.muxed_1.tlast),
						.m_axis_tuser({top.u_dpe.muxed_1.tuser_bypass_all, top.u_dpe.muxed_1.tuser_bypass_stage, top.u_dpe.muxed_1.tuser_src, top.u_dpe.muxed_1.tuser_dst}),
						.m_axis_tid(top.u_dpe.muxed_1.tid),
						.m_axis_tdest()
					);
				end
				initial _sv2v_0 = 0;
			end
			assign mux.pause = from_csr[64];
			assign to_csr[-0] = mux.is_idle;
			if (1) begin : switch
				reg _sv2v_0;
				if (1) begin : outp_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign outp_sbuff.clk = top.u_dpe.muxed_1.clk;
				assign outp_sbuff.rst = top.u_dpe.muxed_1.rst;
				assign top.u_dpe.muxed_1.tready = outp_sbuff.tready;
				localparam dpe_pkg_DPE_ADDR_CPU = 3'h0;
				localparam dpe_pkg_DPE_ADDR_ETH_1 = 3'h1;
				localparam dpe_pkg_DPE_ADDR_ETH_2 = 3'h2;
				localparam dpe_pkg_DPE_ADDR_ETH_3 = 3'h3;
				localparam dpe_pkg_DPE_ADDR_ETH_4 = 3'h4;
				always @(*) begin
					if (_sv2v_0)
						;
					outp_sbuff.tvalid = top.u_dpe.muxed_1.tvalid;
					outp_sbuff.tdata = top.u_dpe.muxed_1.tdata;
					outp_sbuff.tkeep = top.u_dpe.muxed_1.tkeep;
					outp_sbuff.tlast = top.u_dpe.muxed_1.tlast;
					outp_sbuff.tuser_bypass_all = top.u_dpe.muxed_1.tuser_bypass_all;
					outp_sbuff.tuser_bypass_stage = 1'b0;
					outp_sbuff.tuser_src = top.u_dpe.muxed_1.tuser_src;
					if ((top.u_dpe.muxed_1.tuser_bypass_all == 1'b0) && (top.u_dpe.muxed_1.tuser_bypass_stage == 1'b0))
						(* full_case, parallel_case *)
						case (top.u_dpe.muxed_1.tuser_src)
							dpe_pkg_DPE_ADDR_CPU: outp_sbuff.tuser_dst = dpe_pkg_DPE_ADDR_ETH_1;
							dpe_pkg_DPE_ADDR_ETH_1: outp_sbuff.tuser_dst = dpe_pkg_DPE_ADDR_CPU;
							dpe_pkg_DPE_ADDR_ETH_2: outp_sbuff.tuser_dst = dpe_pkg_DPE_ADDR_CPU;
							dpe_pkg_DPE_ADDR_ETH_3: outp_sbuff.tuser_dst = dpe_pkg_DPE_ADDR_ETH_4;
							dpe_pkg_DPE_ADDR_ETH_4: outp_sbuff.tuser_dst = dpe_pkg_DPE_ADDR_ETH_3;
							default: outp_sbuff.tuser_dst = top.u_dpe.muxed_1.tuser_dst;
						endcase
					else
						outp_sbuff.tuser_dst = top.u_dpe.muxed_1.tuser_dst;
				end
				if (1) begin : skid_buffer_outp
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.switch.outp_sbuff.clk),
						.rst(top.u_dpe.switch.outp_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.switch.outp_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.switch.outp_sbuff.tready),
						.s_axis_tdata(top.u_dpe.switch.outp_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.switch.outp_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.switch.outp_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.switch.outp_sbuff.tuser_bypass_all, top.u_dpe.switch.outp_sbuff.tuser_bypass_stage, top.u_dpe.switch.outp_sbuff.tuser_src, top.u_dpe.switch.outp_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.switch.outp_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.u_dpe.muxed_2.tvalid),
						.m_axis_tready(top.u_dpe.muxed_2.tready),
						.m_axis_tdata(top.u_dpe.muxed_2.tdata),
						.m_axis_tkeep(top.u_dpe.muxed_2.tkeep),
						.m_axis_tlast(top.u_dpe.muxed_2.tlast),
						.m_axis_tuser({top.u_dpe.muxed_2.tuser_bypass_all, top.u_dpe.muxed_2.tuser_bypass_stage, top.u_dpe.muxed_2.tuser_src, top.u_dpe.muxed_2.tuser_dst}),
						.m_axis_tid(top.u_dpe.muxed_2.tid),
						.m_axis_tdest()
					);
				end
				initial _sv2v_0 = 0;
			end
			if (1) begin : demux
				reg _sv2v_0;
				if (1) begin : from_dpe_sbuff
					wire clk;
					wire rst;
					wire tready;
					wire tvalid;
					wire [127:0] tdata;
					wire tlast;
					wire [15:0] tkeep;
					wire tuser_bypass_all;
					wire tuser_bypass_stage;
					wire [2:0] tuser_src;
					wire [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign from_dpe_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign from_dpe_sbuff.rst = top.u_dpe.muxed_2.rst;
				if (1) begin : to_cpu_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_cpu_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign to_cpu_sbuff.rst = top.u_dpe.muxed_2.rst;
				if (1) begin : to_eth_1_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_eth_1_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign to_eth_1_sbuff.rst = top.u_dpe.muxed_2.rst;
				if (1) begin : to_eth_2_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_eth_2_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign to_eth_2_sbuff.rst = top.u_dpe.muxed_2.rst;
				if (1) begin : to_eth_3_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_eth_3_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign to_eth_3_sbuff.rst = top.u_dpe.muxed_2.rst;
				if (1) begin : to_eth_4_sbuff
					wire clk;
					wire rst;
					wire tready;
					reg tvalid;
					reg [127:0] tdata;
					reg tlast;
					reg [15:0] tkeep;
					reg tuser_bypass_all;
					reg tuser_bypass_stage;
					reg [2:0] tuser_src;
					reg [2:0] tuser_dst;
					wire [7:0] tid;
				end
				assign to_eth_4_sbuff.clk = top.u_dpe.muxed_2.clk;
				assign to_eth_4_sbuff.rst = top.u_dpe.muxed_2.rst;
				localparam dpe_pkg_DPE_ADDR_BCAST = 3'h7;
				localparam dpe_pkg_DPE_ADDR_CPU = 3'h0;
				localparam dpe_pkg_DPE_ADDR_ETH_1 = 3'h1;
				localparam dpe_pkg_DPE_ADDR_ETH_2 = 3'h2;
				localparam dpe_pkg_DPE_ADDR_ETH_3 = 3'h3;
				localparam dpe_pkg_DPE_ADDR_ETH_4 = 3'h4;
				assign from_dpe_sbuff.tready = ((((((from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_CPU) && (from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_BCAST)) | to_cpu_sbuff.tready) & (((from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_ETH_1) && (from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_BCAST)) | to_eth_1_sbuff.tready)) & (((from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_ETH_2) && (from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_BCAST)) | to_eth_2_sbuff.tready)) & (((from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_ETH_3) && (from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_BCAST)) | to_eth_3_sbuff.tready)) & (((from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_ETH_4) && (from_dpe_sbuff.tuser_dst != dpe_pkg_DPE_ADDR_BCAST)) | to_eth_4_sbuff.tready);
				always @(*) begin
					if (_sv2v_0)
						;
					if ((from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_CPU) || (from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_BCAST)) begin
						to_cpu_sbuff.tvalid = from_dpe_sbuff.tvalid;
						to_cpu_sbuff.tdata = from_dpe_sbuff.tdata;
						to_cpu_sbuff.tkeep = from_dpe_sbuff.tkeep;
						to_cpu_sbuff.tlast = from_dpe_sbuff.tlast;
						to_cpu_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
						to_cpu_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
						to_cpu_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
						to_cpu_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
					end
					else begin
						to_cpu_sbuff.tvalid = 1'b0;
						to_cpu_sbuff.tdata = 1'sb0;
						to_cpu_sbuff.tkeep = 1'sb0;
						to_cpu_sbuff.tlast = 1'sb0;
						to_cpu_sbuff.tuser_bypass_all = 1'b0;
						to_cpu_sbuff.tuser_bypass_stage = 1'b0;
						to_cpu_sbuff.tuser_src = 1'sb0;
						to_cpu_sbuff.tuser_dst = 1'sb0;
					end
					if ((from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_ETH_1) || (from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_BCAST)) begin
						to_eth_1_sbuff.tvalid = from_dpe_sbuff.tvalid;
						to_eth_1_sbuff.tdata = from_dpe_sbuff.tdata;
						to_eth_1_sbuff.tkeep = from_dpe_sbuff.tkeep;
						to_eth_1_sbuff.tlast = from_dpe_sbuff.tlast;
						to_eth_1_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
						to_eth_1_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
						to_eth_1_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
						to_eth_1_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
					end
					else begin
						to_eth_1_sbuff.tvalid = 1'b0;
						to_eth_1_sbuff.tdata = 1'sb0;
						to_eth_1_sbuff.tkeep = 1'sb0;
						to_eth_1_sbuff.tlast = 1'sb0;
						to_eth_1_sbuff.tuser_bypass_all = 1'b0;
						to_eth_1_sbuff.tuser_bypass_stage = 1'b0;
						to_eth_1_sbuff.tuser_src = 1'sb0;
						to_eth_1_sbuff.tuser_dst = 1'sb0;
					end
					if ((from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_ETH_2) || (from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_BCAST)) begin
						to_eth_2_sbuff.tvalid = from_dpe_sbuff.tvalid;
						to_eth_2_sbuff.tdata = from_dpe_sbuff.tdata;
						to_eth_2_sbuff.tkeep = from_dpe_sbuff.tkeep;
						to_eth_2_sbuff.tlast = from_dpe_sbuff.tlast;
						to_eth_2_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
						to_eth_2_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
						to_eth_2_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
						to_eth_2_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
					end
					else begin
						to_eth_2_sbuff.tvalid = 1'b0;
						to_eth_2_sbuff.tdata = 1'sb0;
						to_eth_2_sbuff.tkeep = 1'sb0;
						to_eth_2_sbuff.tlast = 1'sb0;
						to_eth_2_sbuff.tuser_bypass_all = 1'b0;
						to_eth_2_sbuff.tuser_bypass_stage = 1'b0;
						to_eth_2_sbuff.tuser_src = 1'sb0;
						to_eth_2_sbuff.tuser_dst = 1'sb0;
					end
					if ((from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_ETH_3) || (from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_BCAST)) begin
						to_eth_3_sbuff.tvalid = from_dpe_sbuff.tvalid;
						to_eth_3_sbuff.tdata = from_dpe_sbuff.tdata;
						to_eth_3_sbuff.tkeep = from_dpe_sbuff.tkeep;
						to_eth_3_sbuff.tlast = from_dpe_sbuff.tlast;
						to_eth_3_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
						to_eth_3_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
						to_eth_3_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
						to_eth_3_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
					end
					else begin
						to_eth_3_sbuff.tvalid = 1'b0;
						to_eth_3_sbuff.tdata = 1'sb0;
						to_eth_3_sbuff.tkeep = 1'sb0;
						to_eth_3_sbuff.tlast = 1'sb0;
						to_eth_3_sbuff.tuser_bypass_all = 1'b0;
						to_eth_3_sbuff.tuser_bypass_stage = 1'b0;
						to_eth_3_sbuff.tuser_src = 1'sb0;
						to_eth_3_sbuff.tuser_dst = 1'sb0;
					end
					if ((from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_ETH_4) || (from_dpe_sbuff.tuser_dst == dpe_pkg_DPE_ADDR_BCAST)) begin
						to_eth_4_sbuff.tvalid = from_dpe_sbuff.tvalid;
						to_eth_4_sbuff.tdata = from_dpe_sbuff.tdata;
						to_eth_4_sbuff.tkeep = from_dpe_sbuff.tkeep;
						to_eth_4_sbuff.tlast = from_dpe_sbuff.tlast;
						to_eth_4_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
						to_eth_4_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
						to_eth_4_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
						to_eth_4_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
					end
					else begin
						to_eth_4_sbuff.tvalid = 1'b0;
						to_eth_4_sbuff.tdata = 1'sb0;
						to_eth_4_sbuff.tkeep = 1'sb0;
						to_eth_4_sbuff.tlast = 1'sb0;
						to_eth_4_sbuff.tuser_bypass_all = 1'b0;
						to_eth_4_sbuff.tuser_bypass_stage = 1'b0;
						to_eth_4_sbuff.tuser_src = 1'sb0;
						to_eth_4_sbuff.tuser_dst = 1'sb0;
					end
				end
				if (1) begin : skid_buffer_from_dpe
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.muxed_2.clk),
						.rst(top.u_dpe.muxed_2.rst),
						.s_axis_tvalid(top.u_dpe.muxed_2.tvalid),
						.s_axis_tready(top.u_dpe.muxed_2.tready),
						.s_axis_tdata(top.u_dpe.muxed_2.tdata),
						.s_axis_tkeep(top.u_dpe.muxed_2.tkeep),
						.s_axis_tlast(top.u_dpe.muxed_2.tlast),
						.s_axis_tuser({top.u_dpe.muxed_2.tuser_bypass_all, top.u_dpe.muxed_2.tuser_bypass_stage, top.u_dpe.muxed_2.tuser_src, top.u_dpe.muxed_2.tuser_dst}),
						.s_axis_tid(top.u_dpe.muxed_2.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.u_dpe.demux.from_dpe_sbuff.tvalid),
						.m_axis_tready(top.u_dpe.demux.from_dpe_sbuff.tready),
						.m_axis_tdata(top.u_dpe.demux.from_dpe_sbuff.tdata),
						.m_axis_tkeep(top.u_dpe.demux.from_dpe_sbuff.tkeep),
						.m_axis_tlast(top.u_dpe.demux.from_dpe_sbuff.tlast),
						.m_axis_tuser({top.u_dpe.demux.from_dpe_sbuff.tuser_bypass_all, top.u_dpe.demux.from_dpe_sbuff.tuser_bypass_stage, top.u_dpe.demux.from_dpe_sbuff.tuser_src, top.u_dpe.demux.from_dpe_sbuff.tuser_dst}),
						.m_axis_tid(top.u_dpe.demux.from_dpe_sbuff.tid),
						.m_axis_tdest()
					);
				end
				if (1) begin : skid_buffer_to_cpu
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.demux.to_cpu_sbuff.clk),
						.rst(top.u_dpe.demux.to_cpu_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.demux.to_cpu_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.demux.to_cpu_sbuff.tready),
						.s_axis_tdata(top.u_dpe.demux.to_cpu_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.demux.to_cpu_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.demux.to_cpu_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.demux.to_cpu_sbuff.tuser_bypass_all, top.u_dpe.demux.to_cpu_sbuff.tuser_bypass_stage, top.u_dpe.demux.to_cpu_sbuff.tuser_src, top.u_dpe.demux.to_cpu_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.demux.to_cpu_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.to_cpu.tvalid),
						.m_axis_tready(top.to_cpu.tready),
						.m_axis_tdata(top.to_cpu.tdata),
						.m_axis_tkeep(top.to_cpu.tkeep),
						.m_axis_tlast(top.to_cpu.tlast),
						.m_axis_tuser({top.to_cpu.tuser_bypass_all, top.to_cpu.tuser_bypass_stage, top.to_cpu.tuser_src, top.to_cpu.tuser_dst}),
						.m_axis_tid(top.to_cpu.tid),
						.m_axis_tdest()
					);
				end
				if (1) begin : skid_buffer_to_eth_1
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.demux.to_eth_1_sbuff.clk),
						.rst(top.u_dpe.demux.to_eth_1_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.demux.to_eth_1_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.demux.to_eth_1_sbuff.tready),
						.s_axis_tdata(top.u_dpe.demux.to_eth_1_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.demux.to_eth_1_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.demux.to_eth_1_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.demux.to_eth_1_sbuff.tuser_bypass_all, top.u_dpe.demux.to_eth_1_sbuff.tuser_bypass_stage, top.u_dpe.demux.to_eth_1_sbuff.tuser_src, top.u_dpe.demux.to_eth_1_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.demux.to_eth_1_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.to_eth_1.tvalid),
						.m_axis_tready(top.to_eth_1.tready),
						.m_axis_tdata(top.to_eth_1.tdata),
						.m_axis_tkeep(top.to_eth_1.tkeep),
						.m_axis_tlast(top.to_eth_1.tlast),
						.m_axis_tuser({top.to_eth_1.tuser_bypass_all, top.to_eth_1.tuser_bypass_stage, top.to_eth_1.tuser_src, top.to_eth_1.tuser_dst}),
						.m_axis_tid(top.to_eth_1.tid),
						.m_axis_tdest()
					);
				end
				if (1) begin : skid_buffer_to_eth_2
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.demux.to_eth_2_sbuff.clk),
						.rst(top.u_dpe.demux.to_eth_2_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.demux.to_eth_2_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.demux.to_eth_2_sbuff.tready),
						.s_axis_tdata(top.u_dpe.demux.to_eth_2_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.demux.to_eth_2_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.demux.to_eth_2_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.demux.to_eth_2_sbuff.tuser_bypass_all, top.u_dpe.demux.to_eth_2_sbuff.tuser_bypass_stage, top.u_dpe.demux.to_eth_2_sbuff.tuser_src, top.u_dpe.demux.to_eth_2_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.demux.to_eth_2_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.to_eth_2.tvalid),
						.m_axis_tready(top.to_eth_2.tready),
						.m_axis_tdata(top.to_eth_2.tdata),
						.m_axis_tkeep(top.to_eth_2.tkeep),
						.m_axis_tlast(top.to_eth_2.tlast),
						.m_axis_tuser({top.to_eth_2.tuser_bypass_all, top.to_eth_2.tuser_bypass_stage, top.to_eth_2.tuser_src, top.to_eth_2.tuser_dst}),
						.m_axis_tid(top.to_eth_2.tid),
						.m_axis_tdest()
					);
				end
				if (1) begin : skid_buffer_to_eth_3
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.demux.to_eth_3_sbuff.clk),
						.rst(top.u_dpe.demux.to_eth_3_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.demux.to_eth_3_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.demux.to_eth_3_sbuff.tready),
						.s_axis_tdata(top.u_dpe.demux.to_eth_3_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.demux.to_eth_3_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.demux.to_eth_3_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.demux.to_eth_3_sbuff.tuser_bypass_all, top.u_dpe.demux.to_eth_3_sbuff.tuser_bypass_stage, top.u_dpe.demux.to_eth_3_sbuff.tuser_src, top.u_dpe.demux.to_eth_3_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.demux.to_eth_3_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.to_eth_3.tvalid),
						.m_axis_tready(top.to_eth_3.tready),
						.m_axis_tdata(top.to_eth_3.tdata),
						.m_axis_tkeep(top.to_eth_3.tkeep),
						.m_axis_tlast(top.to_eth_3.tlast),
						.m_axis_tuser({top.to_eth_3.tuser_bypass_all, top.to_eth_3.tuser_bypass_stage, top.to_eth_3.tuser_src, top.to_eth_3.tuser_dst}),
						.m_axis_tid(top.to_eth_3.tid),
						.m_axis_tdest()
					);
				end
				if (1) begin : skid_buffer_to_eth_4
					axis_register #(
						.DATA_WIDTH(128),
						.USER_WIDTH(8),
						.ID_WIDTH(8)
					) sbuff(
						.clk(top.u_dpe.demux.to_eth_4_sbuff.clk),
						.rst(top.u_dpe.demux.to_eth_4_sbuff.rst),
						.s_axis_tvalid(top.u_dpe.demux.to_eth_4_sbuff.tvalid),
						.s_axis_tready(top.u_dpe.demux.to_eth_4_sbuff.tready),
						.s_axis_tdata(top.u_dpe.demux.to_eth_4_sbuff.tdata),
						.s_axis_tkeep(top.u_dpe.demux.to_eth_4_sbuff.tkeep),
						.s_axis_tlast(top.u_dpe.demux.to_eth_4_sbuff.tlast),
						.s_axis_tuser({top.u_dpe.demux.to_eth_4_sbuff.tuser_bypass_all, top.u_dpe.demux.to_eth_4_sbuff.tuser_bypass_stage, top.u_dpe.demux.to_eth_4_sbuff.tuser_src, top.u_dpe.demux.to_eth_4_sbuff.tuser_dst}),
						.s_axis_tid(top.u_dpe.demux.to_eth_4_sbuff.tid),
						.s_axis_tdest(1'sb0),
						.m_axis_tvalid(top.to_eth_4.tvalid),
						.m_axis_tready(top.to_eth_4.tready),
						.m_axis_tdata(top.to_eth_4.tdata),
						.m_axis_tkeep(top.to_eth_4.tkeep),
						.m_axis_tlast(top.to_eth_4.tlast),
						.m_axis_tuser({top.to_eth_4.tuser_bypass_all, top.to_eth_4.tuser_bypass_stage, top.to_eth_4.tuser_src, top.to_eth_4.tuser_dst}),
						.m_axis_tid(top.to_eth_4.tid),
						.m_axis_tdest()
					);
				end
				initial _sv2v_0 = 0;
			end
		end
	endgenerate
	assign u_dpe.from_csr = from_csr;
	assign to_csr = u_dpe.to_csr;
	generate
		if (1) begin : u_eth_1
			wire gtx_clk;
			wire gtx_rst;
			wire gmii_rx_clk;
			wire [7:0] gmii_rxd;
			wire gmii_rx_dv;
			wire gmii_rx_er;
			wire mii_tx_clk;
			wire gmii_tx_clk;
			wire [7:0] gmii_txd;
			wire gmii_tx_en;
			wire gmii_tx_er;
			wire [1:0] speed;
			eth_mac_1g_gmii_fifo #(
				.TARGET("XILINX"),
				.IODDR_STYLE("IODDR"),
				.CLOCK_INPUT_STYLE("BUFG"),
				.AXIS_DATA_WIDTH(128),
				.AXIS_KEEP_ENABLE(1),
				.AXIS_KEEP_WIDTH(16),
				.ENABLE_PADDING(1),
				.MIN_FRAME_LENGTH(64),
				.TX_FIFO_DEPTH(4096),
				.TX_FRAME_FIFO(1),
				.RX_FIFO_DEPTH(4096),
				.RX_FRAME_FIFO(1)
			) eth(
				.gtx_clk(gtx_clk),
				.gtx_rst(gtx_rst),
				.logic_clk(top.to_eth_1.clk),
				.logic_rst(top.to_eth_1.rst),
				.tx_axis_tdata(top.to_eth_1.tdata),
				.tx_axis_tkeep(top.to_eth_1.tkeep),
				.tx_axis_tvalid(top.to_eth_1.tvalid),
				.tx_axis_tready(top.to_eth_1.tready),
				.tx_axis_tlast(top.to_eth_1.tlast),
				.tx_axis_tuser(1'sb0),
				.rx_axis_tdata(top.from_eth_1.tdata),
				.rx_axis_tkeep(top.from_eth_1.tkeep),
				.rx_axis_tvalid(top.from_eth_1.tvalid),
				.rx_axis_tready(top.from_eth_1.tready),
				.rx_axis_tlast(top.from_eth_1.tlast),
				.rx_axis_tuser(),
				.gmii_rx_clk(gmii_rx_clk),
				.gmii_rxd(gmii_rxd),
				.gmii_rx_dv(gmii_rx_dv),
				.gmii_rx_er(gmii_rx_er),
				.mii_tx_clk(mii_tx_clk),
				.gmii_tx_clk(gmii_tx_clk),
				.gmii_txd(gmii_txd),
				.gmii_tx_en(gmii_tx_en),
				.gmii_tx_er(gmii_tx_er),
				.tx_fifo_overflow(),
				.tx_fifo_bad_frame(),
				.tx_fifo_good_frame(),
				.rx_error_bad_frame(),
				.rx_error_bad_fcs(),
				.rx_fifo_overflow(),
				.rx_fifo_bad_frame(),
				.rx_fifo_good_frame(),
				.tx_error_underflow(),
				.speed(speed),
				.cfg_ifg(8'd12),
				.cfg_tx_enable(1'b1),
				.cfg_rx_enable(1'b1)
			);
		end
	endgenerate
	assign u_eth_1.gtx_clk = eth_gtx_clk;
	assign u_eth_1.gtx_rst = eth_gtx_rst;
	assign u_eth_1.gmii_rx_clk = e1_rxc;
	assign u_eth_1.gmii_rxd = e1_rxd;
	assign u_eth_1.gmii_rx_dv = e1_rxdv;
	assign u_eth_1.gmii_rx_er = e1_rxer;
	assign u_eth_1.mii_tx_clk = e1_txc;
	assign e1_gtxc = u_eth_1.gmii_tx_clk;
	assign e1_txd = u_eth_1.gmii_txd;
	assign e1_txen = u_eth_1.gmii_tx_en;
	assign e1_txer = u_eth_1.gmii_tx_er;
	assign to_csr[8-:2] = u_eth_1.speed;
	generate
		if (1) begin : u_eth_2
			wire gtx_clk;
			wire gtx_rst;
			wire gmii_rx_clk;
			wire [7:0] gmii_rxd;
			wire gmii_rx_dv;
			wire gmii_rx_er;
			wire mii_tx_clk;
			wire gmii_tx_clk;
			wire [7:0] gmii_txd;
			wire gmii_tx_en;
			wire gmii_tx_er;
			wire [1:0] speed;
			eth_mac_1g_gmii_fifo #(
				.TARGET("XILINX"),
				.IODDR_STYLE("IODDR"),
				.CLOCK_INPUT_STYLE("BUFG"),
				.AXIS_DATA_WIDTH(128),
				.AXIS_KEEP_ENABLE(1),
				.AXIS_KEEP_WIDTH(16),
				.ENABLE_PADDING(1),
				.MIN_FRAME_LENGTH(64),
				.TX_FIFO_DEPTH(4096),
				.TX_FRAME_FIFO(1),
				.RX_FIFO_DEPTH(4096),
				.RX_FRAME_FIFO(1)
			) eth(
				.gtx_clk(gtx_clk),
				.gtx_rst(gtx_rst),
				.logic_clk(top.to_eth_2.clk),
				.logic_rst(top.to_eth_2.rst),
				.tx_axis_tdata(top.to_eth_2.tdata),
				.tx_axis_tkeep(top.to_eth_2.tkeep),
				.tx_axis_tvalid(top.to_eth_2.tvalid),
				.tx_axis_tready(top.to_eth_2.tready),
				.tx_axis_tlast(top.to_eth_2.tlast),
				.tx_axis_tuser(1'sb0),
				.rx_axis_tdata(top.from_eth_2.tdata),
				.rx_axis_tkeep(top.from_eth_2.tkeep),
				.rx_axis_tvalid(top.from_eth_2.tvalid),
				.rx_axis_tready(top.from_eth_2.tready),
				.rx_axis_tlast(top.from_eth_2.tlast),
				.rx_axis_tuser(),
				.gmii_rx_clk(gmii_rx_clk),
				.gmii_rxd(gmii_rxd),
				.gmii_rx_dv(gmii_rx_dv),
				.gmii_rx_er(gmii_rx_er),
				.mii_tx_clk(mii_tx_clk),
				.gmii_tx_clk(gmii_tx_clk),
				.gmii_txd(gmii_txd),
				.gmii_tx_en(gmii_tx_en),
				.gmii_tx_er(gmii_tx_er),
				.tx_fifo_overflow(),
				.tx_fifo_bad_frame(),
				.tx_fifo_good_frame(),
				.rx_error_bad_frame(),
				.rx_error_bad_fcs(),
				.rx_fifo_overflow(),
				.rx_fifo_bad_frame(),
				.rx_fifo_good_frame(),
				.tx_error_underflow(),
				.speed(speed),
				.cfg_ifg(8'd12),
				.cfg_tx_enable(1'b1),
				.cfg_rx_enable(1'b1)
			);
		end
	endgenerate
	assign u_eth_2.gtx_clk = eth_gtx_clk;
	assign u_eth_2.gtx_rst = eth_gtx_rst;
	assign u_eth_2.gmii_rx_clk = e2_rxc;
	assign u_eth_2.gmii_rxd = e2_rxd;
	assign u_eth_2.gmii_rx_dv = e2_rxdv;
	assign u_eth_2.gmii_rx_er = e2_rxer;
	assign u_eth_2.mii_tx_clk = e2_txc;
	assign e2_gtxc = u_eth_2.gmii_tx_clk;
	assign e2_txd = u_eth_2.gmii_txd;
	assign e2_txen = u_eth_2.gmii_tx_en;
	assign e2_txer = u_eth_2.gmii_tx_er;
	assign to_csr[6-:2] = u_eth_2.speed;
	generate
		if (1) begin : u_eth_3
			wire gtx_clk;
			wire gtx_rst;
			wire gmii_rx_clk;
			wire [7:0] gmii_rxd;
			wire gmii_rx_dv;
			wire gmii_rx_er;
			wire mii_tx_clk;
			wire gmii_tx_clk;
			wire [7:0] gmii_txd;
			wire gmii_tx_en;
			wire gmii_tx_er;
			wire [1:0] speed;
			eth_mac_1g_gmii_fifo #(
				.TARGET("XILINX"),
				.IODDR_STYLE("IODDR"),
				.CLOCK_INPUT_STYLE("BUFG"),
				.AXIS_DATA_WIDTH(128),
				.AXIS_KEEP_ENABLE(1),
				.AXIS_KEEP_WIDTH(16),
				.ENABLE_PADDING(1),
				.MIN_FRAME_LENGTH(64),
				.TX_FIFO_DEPTH(4096),
				.TX_FRAME_FIFO(1),
				.RX_FIFO_DEPTH(4096),
				.RX_FRAME_FIFO(1)
			) eth(
				.gtx_clk(gtx_clk),
				.gtx_rst(gtx_rst),
				.logic_clk(top.to_eth_3.clk),
				.logic_rst(top.to_eth_3.rst),
				.tx_axis_tdata(top.to_eth_3.tdata),
				.tx_axis_tkeep(top.to_eth_3.tkeep),
				.tx_axis_tvalid(top.to_eth_3.tvalid),
				.tx_axis_tready(top.to_eth_3.tready),
				.tx_axis_tlast(top.to_eth_3.tlast),
				.tx_axis_tuser(1'sb0),
				.rx_axis_tdata(top.from_eth_3.tdata),
				.rx_axis_tkeep(top.from_eth_3.tkeep),
				.rx_axis_tvalid(top.from_eth_3.tvalid),
				.rx_axis_tready(top.from_eth_3.tready),
				.rx_axis_tlast(top.from_eth_3.tlast),
				.rx_axis_tuser(),
				.gmii_rx_clk(gmii_rx_clk),
				.gmii_rxd(gmii_rxd),
				.gmii_rx_dv(gmii_rx_dv),
				.gmii_rx_er(gmii_rx_er),
				.mii_tx_clk(mii_tx_clk),
				.gmii_tx_clk(gmii_tx_clk),
				.gmii_txd(gmii_txd),
				.gmii_tx_en(gmii_tx_en),
				.gmii_tx_er(gmii_tx_er),
				.tx_fifo_overflow(),
				.tx_fifo_bad_frame(),
				.tx_fifo_good_frame(),
				.rx_error_bad_frame(),
				.rx_error_bad_fcs(),
				.rx_fifo_overflow(),
				.rx_fifo_bad_frame(),
				.rx_fifo_good_frame(),
				.tx_error_underflow(),
				.speed(speed),
				.cfg_ifg(8'd12),
				.cfg_tx_enable(1'b1),
				.cfg_rx_enable(1'b1)
			);
		end
	endgenerate
	assign u_eth_3.gtx_clk = eth_gtx_clk;
	assign u_eth_3.gtx_rst = eth_gtx_rst;
	assign u_eth_3.gmii_rx_clk = e3_rxc;
	assign u_eth_3.gmii_rxd = e3_rxd;
	assign u_eth_3.gmii_rx_dv = e3_rxdv;
	assign u_eth_3.gmii_rx_er = e3_rxer;
	assign u_eth_3.mii_tx_clk = e3_txc;
	assign e3_gtxc = u_eth_3.gmii_tx_clk;
	assign e3_txd = u_eth_3.gmii_txd;
	assign e3_txen = u_eth_3.gmii_tx_en;
	assign e3_txer = u_eth_3.gmii_tx_er;
	assign to_csr[4-:2] = u_eth_3.speed;
	generate
		if (1) begin : u_eth_4
			wire gtx_clk;
			wire gtx_rst;
			wire gmii_rx_clk;
			wire [7:0] gmii_rxd;
			wire gmii_rx_dv;
			wire gmii_rx_er;
			wire mii_tx_clk;
			wire gmii_tx_clk;
			wire [7:0] gmii_txd;
			wire gmii_tx_en;
			wire gmii_tx_er;
			wire [1:0] speed;
			eth_mac_1g_gmii_fifo #(
				.TARGET("XILINX"),
				.IODDR_STYLE("IODDR"),
				.CLOCK_INPUT_STYLE("BUFG"),
				.AXIS_DATA_WIDTH(128),
				.AXIS_KEEP_ENABLE(1),
				.AXIS_KEEP_WIDTH(16),
				.ENABLE_PADDING(1),
				.MIN_FRAME_LENGTH(64),
				.TX_FIFO_DEPTH(4096),
				.TX_FRAME_FIFO(1),
				.RX_FIFO_DEPTH(4096),
				.RX_FRAME_FIFO(1)
			) eth(
				.gtx_clk(gtx_clk),
				.gtx_rst(gtx_rst),
				.logic_clk(top.to_eth_4.clk),
				.logic_rst(top.to_eth_4.rst),
				.tx_axis_tdata(top.to_eth_4.tdata),
				.tx_axis_tkeep(top.to_eth_4.tkeep),
				.tx_axis_tvalid(top.to_eth_4.tvalid),
				.tx_axis_tready(top.to_eth_4.tready),
				.tx_axis_tlast(top.to_eth_4.tlast),
				.tx_axis_tuser(1'sb0),
				.rx_axis_tdata(top.from_eth_4.tdata),
				.rx_axis_tkeep(top.from_eth_4.tkeep),
				.rx_axis_tvalid(top.from_eth_4.tvalid),
				.rx_axis_tready(top.from_eth_4.tready),
				.rx_axis_tlast(top.from_eth_4.tlast),
				.rx_axis_tuser(),
				.gmii_rx_clk(gmii_rx_clk),
				.gmii_rxd(gmii_rxd),
				.gmii_rx_dv(gmii_rx_dv),
				.gmii_rx_er(gmii_rx_er),
				.mii_tx_clk(mii_tx_clk),
				.gmii_tx_clk(gmii_tx_clk),
				.gmii_txd(gmii_txd),
				.gmii_tx_en(gmii_tx_en),
				.gmii_tx_er(gmii_tx_er),
				.tx_fifo_overflow(),
				.tx_fifo_bad_frame(),
				.tx_fifo_good_frame(),
				.rx_error_bad_frame(),
				.rx_error_bad_fcs(),
				.rx_fifo_overflow(),
				.rx_fifo_bad_frame(),
				.rx_fifo_good_frame(),
				.tx_error_underflow(),
				.speed(speed),
				.cfg_ifg(8'd12),
				.cfg_tx_enable(1'b1),
				.cfg_rx_enable(1'b1)
			);
		end
	endgenerate
	assign u_eth_4.gtx_clk = eth_gtx_clk;
	assign u_eth_4.gtx_rst = eth_gtx_rst;
	assign u_eth_4.gmii_rx_clk = e4_rxc;
	assign u_eth_4.gmii_rxd = e4_rxd;
	assign u_eth_4.gmii_rx_dv = e4_rxdv;
	assign u_eth_4.gmii_rx_er = e4_rxer;
	assign u_eth_4.mii_tx_clk = e4_txc;
	assign e4_gtxc = u_eth_4.gmii_tx_clk;
	assign e4_txd = u_eth_4.gmii_txd;
	assign e4_txen = u_eth_4.gmii_tx_en;
	assign e4_txer = u_eth_4.gmii_tx_er;
	assign to_csr[2-:2] = u_eth_4.speed;
	ethernet_phy u_phy(
		.e1_reset(e1_reset),
		.e1_mdc(e1_mdc),
		.e1_mdio(e1_mdio),
		.e2_reset(e2_reset),
		.e2_mdc(e2_mdc),
		.e2_mdio(e2_mdio),
		.e3_reset(e3_reset),
		.e3_mdc(e3_mdc),
		.e3_mdio(e3_mdio),
		.e4_reset(e4_reset),
		.e4_mdc(e4_mdc),
		.e4_mdio(e4_mdio)
	);
endmodule
