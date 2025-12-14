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