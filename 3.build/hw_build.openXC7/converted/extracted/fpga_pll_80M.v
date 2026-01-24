// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

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