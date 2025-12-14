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