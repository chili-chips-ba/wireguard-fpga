/*
 * plle2_base.v: Simulates the PLLE2_BASE pll of the xilinx 7 series. This
 * is just a wrapper around the actual logic found in pll.v
 * author: Till Mahlburg
 * year: 2019-2020
 * organization: Universität Leipzig
 * license: ISC
 *
 */

`timescale 1 ns / 1 ps

/* A reference for the interface can be found in Xilinx UG953 page 509ff */
module PLLE2_BASE #(
	/* not implemented */
	parameter BANDWIDTH 			= "OPTIMIZED",

	parameter CLKFBOUT_MULT 		= 5,
	parameter CLKFBOUT_PHASE 		= 0.0,

	/* is ignored, but should be set */
	parameter CLKIN1_PERIOD			= 0.0,

	parameter CLKOUT0_DIVIDE		= 1,
	parameter CLKOUT1_DIVIDE		= 1,
	parameter CLKOUT2_DIVIDE		= 1,
	parameter CLKOUT3_DIVIDE		= 1,
	parameter CLKOUT4_DIVIDE		= 1,
	parameter CLKOUT5_DIVIDE		= 1,

	parameter CLKOUT0_DUTY_CYCLE	= 0.5,
	parameter CLKOUT1_DUTY_CYCLE	= 0.5,
	parameter CLKOUT2_DUTY_CYCLE	= 0.5,
	parameter CLKOUT3_DUTY_CYCLE	= 0.5,
	parameter CLKOUT4_DUTY_CYCLE	= 0.5,
	parameter CLKOUT5_DUTY_CYCLE	= 0.5,

	parameter CLKOUT0_PHASE			= 0.0,
	parameter CLKOUT1_PHASE			= 0.0,
	parameter CLKOUT2_PHASE			= 0.0,
	parameter CLKOUT3_PHASE			= 0.0,
	parameter CLKOUT4_PHASE			= 0.0,
	parameter CLKOUT5_PHASE			= 0.0,

	parameter DIVCLK_DIVIDE			= 1,

	/* both not implemented */
	parameter REF_JITTER1			= 0.0,
	parameter STARTUP_WAIT			= "FALSE",

	/* Setting the FPGA model and speed grade allows a more realistic
	 * simulation. Default values are the most restrictive */
	parameter FPGA_TYPE				= "ARTIX",
	parameter SPEED_GRADE 			= "-1")(
	output 	CLKOUT0,
	output 	CLKOUT1,
	output 	CLKOUT2,
	output 	CLKOUT3,
	output 	CLKOUT4,
	output 	CLKOUT5,
	/* PLL feedback output. */
	output 	CLKFBOUT,

	output	LOCKED,

	input 	CLKIN1,
	/* PLL feedback input. Is ignored in this implementation, but should be connected to CLKFBOUT for internal feedback. */
	input 	CLKFBIN,

	/* Used to power down instatiated but unused PLLs */
	input	PWRDWN,
	input	RST);

	wire	[15:0] DO;
	wire	DRDY;

	pll #(
 		.BANDWIDTH(BANDWIDTH),
 		.CLKFBOUT_MULT_F(CLKFBOUT_MULT),
		.CLKFBOUT_PHASE(CLKFBOUT_PHASE),
		.CLKIN1_PERIOD(CLKIN1_PERIOD),
		.CLKIN2_PERIOD(0.000),

		.CLKOUT0_DIVIDE_F(CLKOUT0_DIVIDE),
		.CLKOUT1_DIVIDE(CLKOUT1_DIVIDE),
		.CLKOUT2_DIVIDE(CLKOUT2_DIVIDE),
		.CLKOUT3_DIVIDE(CLKOUT3_DIVIDE),
		.CLKOUT4_DIVIDE(CLKOUT4_DIVIDE),
		.CLKOUT5_DIVIDE(CLKOUT5_DIVIDE),

		.CLKOUT0_DUTY_CYCLE(CLKOUT0_DUTY_CYCLE),
		.CLKOUT1_DUTY_CYCLE(CLKOUT1_DUTY_CYCLE),
		.CLKOUT2_DUTY_CYCLE(CLKOUT2_DUTY_CYCLE),
		.CLKOUT3_DUTY_CYCLE(CLKOUT3_DUTY_CYCLE),
		.CLKOUT4_DUTY_CYCLE(CLKOUT4_DUTY_CYCLE),
		.CLKOUT5_DUTY_CYCLE(CLKOUT5_DUTY_CYCLE),

		.CLKOUT0_PHASE(CLKOUT0_PHASE),
		.CLKOUT1_PHASE(CLKOUT1_PHASE),
		.CLKOUT2_PHASE(CLKOUT2_PHASE),
		.CLKOUT3_PHASE(CLKOUT3_PHASE),
		.CLKOUT4_PHASE(CLKOUT4_PHASE),
		.CLKOUT5_PHASE(CLKOUT5_PHASE),

		.DIVCLK_DIVIDE(DIVCLK_DIVIDE),
		.REF_JITTER1(REF_JITTER1),
		.REF_JITTER2(0.010),
		.STARTUP_WAIT(STARTUP_WAIT),
		.COMPENSATION("ZHOLD"),

		.MODULE_TYPE("PLLE2_BASE"),

		.FPGA_TYPE(FPGA_TYPE),
		.SPEED_GRADE(SPEED_GRADE))
	plle2_base (
		.CLKOUT0(CLKOUT0),
		.CLKOUT1(CLKOUT1),
		.CLKOUT2(CLKOUT2),
		.CLKOUT3(CLKOUT3),
		.CLKOUT4(CLKOUT4),
		.CLKOUT5(CLKOUT5),

		.CLKFBOUT(CLKFBOUT),
		.LOCKED(LOCKED),

		.CLKIN1(CLKIN1),
		.CLKIN2(1'b0),
		.CLKINSEL(1'b1),

		.PWRDWN(PWRDWN),
		.RST(RST),
		.CLKFBIN(CLKFBIN),

		.DADDR(7'h00),
		.DCLK(1'b0),
		.DEN(1'b0),
		.DWE(1'b0),
		.DI(16'h0),

		.DO(DO),
		.DRDY(DRDY)
	);
endmodule
