// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

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