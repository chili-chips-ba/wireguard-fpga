// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

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