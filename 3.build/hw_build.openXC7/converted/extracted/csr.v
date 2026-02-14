// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

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