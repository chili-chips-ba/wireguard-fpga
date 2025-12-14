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