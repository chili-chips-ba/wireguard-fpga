/*
 * pll.v: Simulates the pll of the xilinx 7 series. This is used by the
 * frontend files "plle2_base.v" and "plle2_adv.v"
 * author: Till Mahlburg
 * year: 2019-2020
 * organization: Universität Leipzig
 * license: ISC
 *
 */

`timescale 1 ns / 1 ps

/* A reference for the interface can be found in Xilinx UG953 page 503ff */
module pll #(
	/* not implemented */
	parameter BANDWIDTH 			= "OPTIMIZED",

	parameter CLKFBOUT_MULT_F		= 5.0,
	parameter CLKFBOUT_PHASE 		= 0.0,

	/* need to be set */
	parameter CLKIN1_PERIOD			= 0.0,
	parameter CLKIN2_PERIOD			= 0.0,

	parameter CLKOUT0_DIVIDE_F		= 1.0,
	parameter CLKOUT1_DIVIDE		= 1,
	parameter CLKOUT2_DIVIDE		= 1,
	parameter CLKOUT3_DIVIDE		= 1,
	parameter CLKOUT4_DIVIDE		= 1,
	parameter CLKOUT5_DIVIDE		= 1,
	parameter CLKOUT6_DIVIDE		= 1,

	parameter CLKOUT0_DUTY_CYCLE	= 0.5,
	parameter CLKOUT1_DUTY_CYCLE	= 0.5,
	parameter CLKOUT2_DUTY_CYCLE	= 0.5,
	parameter CLKOUT3_DUTY_CYCLE	= 0.5,
	parameter CLKOUT4_DUTY_CYCLE	= 0.5,
	parameter CLKOUT5_DUTY_CYCLE	= 0.5,
	parameter CLKOUT6_DUTY_CYCLE	= 0.5,

	parameter CLKOUT0_PHASE			= 0.0,
	parameter CLKOUT1_PHASE			= 0.0,
	parameter CLKOUT2_PHASE			= 0.0,
	parameter CLKOUT3_PHASE			= 0.0,
	parameter CLKOUT4_PHASE			= 0.0,
	parameter CLKOUT5_PHASE			= 0.0,
	parameter CLKOUT6_PHASE			= 0.0,

	parameter CLKOUT4_CASCADE		= "FALSE",

	parameter DIVCLK_DIVIDE			= 1,

	/* not implemented */
	parameter REF_JITTER1			= 0.010,
	parameter REF_JITTER2			= 0.010,
	parameter STARTUP_WAIT			= "FALSE",
	parameter COMPENSATION			= "ZHOLD",

	/* this is additional, optional information for determining the
	 * correct hardware limits. By default it uses the most restrictive
	 * model */
	parameter FPGA_TYPE				= "ARTIX",
	parameter SPEED_GRADE			= "-1",

	/* just for internal use */
	parameter MODULE_TYPE			= "PLLE2_BASE")(
	output CLKOUT0,
	output CLKOUT0B,
	output CLKOUT1,
	output CLKOUT1B,
	output CLKOUT2,
	output CLKOUT2B,
	output CLKOUT3,
	output CLKOUT3B,
	output CLKOUT4,
	output CLKOUT5,
	output CLKOUT6,
	/* PLL feedback output. */
	output CLKFBOUT,
	output CLKFBOUTB,

	output LOCKED,

	input CLKIN1,
	input CLKIN2,
	/* Select input clk. 1 for CLKIN1, 0 for CLKIN2 */
	input CLKINSEL,
	/* PLL feedback input. Is ignored in this implementation, but should be connected to CLKFBOUT for internal feedback. */
	input CLKFBIN,

	/* Used to power down instatiated but unused PLLs */
	input PWRDWN,
	input RST,

	/* Dynamic reconfiguration ports */
	/* register address to write to or read from */
	input [6:0] DADDR,
	/* reference clk */
	input DCLK,
	/* enable dynamic reconfiguration (read only) */
	input DEN,
	/* enable writing */
	input DWE,
	/* what to write */
	input [15:0] DI,
	/* read values */
	output [15:0] DO,
	/* ready flag for next operation */
	output DRDY);

	/* assign inverted outputs */
	assign CLKOUT0B = ~CLKOUT0;
	assign CLKOUT1B = ~CLKOUT1;
	assign CLKOUT2B = ~CLKOUT2;
	assign CLKOUT3B = ~CLKOUT3;
	assign CLKFBOUTB = ~CLKFBOUT;

	/* gets assigned to the chosen CLKIN */
	reg clkin;
	wire [31:0] clkin_period_length_1000;

	/* internal values */
	reg [31:0] CLKOUT_DIVIDE_INT_1000[0:6];
	reg [31:0] CLKOUT_DUTY_CYCLE_INT_1000[0:6];
	reg signed [31:0] CLKOUT_PHASE_INT_1000[0:6];
	reg [31:0] CLKFBOUT_MULT_F_INT_1000;
	reg signed [31:0] CLKFBOUT_PHASE_INT_1000;
	reg [31:0] DIVCLK_DIVIDE_INT;
	wire CLKOUT_INT[0:6];

	assign CLKOUT0 = CLKOUT_INT[0];
	assign CLKOUT1 = CLKOUT_INT[1];
	assign CLKOUT2 = CLKOUT_INT[2];
	assign CLKOUT3 = CLKOUT_INT[3];
	assign CLKOUT4 = CLKOUT_INT[4];
	assign CLKOUT5 = CLKOUT_INT[5];
	assign CLKOUT6 = CLKOUT_INT[6];

	/* Used to determine the period length of the divided CLK */
	period_count #(
		.RESOLUTION(0.01))
	period_count (
		.RST(RST),
		.PWRDWN(PWRDWN),
		.clk(clkin),
		.period_length_1000(clkin_period_length_1000));

	wire period_stable;

	/* Used to delay the output of the period until it's stable */
	period_check period_check (
		.RST(RST),
		.PWRDWN(PWRDWN),
		.clk(clkin),
		.period_length((clkin_period_length_1000 / 1000.0)),
		.period_stable(period_stable));

	wire out[0:6];
	wire [31:0] out_period_length_1000[0:6];
	wire lock[0:6];

	/* frequency generators */
	genvar i;

	generate
		for (i = 0; i <= 6; i = i + 1) begin : fg
			freq_gen fg (
				.M_1000(CLKFBOUT_MULT_F_INT_1000),
				.D(DIVCLK_DIVIDE_INT),
				.O_1000(CLKOUT_DIVIDE_INT_1000[i]),
				.RST(RST),
				.PWRDWN(PWRDWN),
				.period_stable(period_stable),
				.ref_period_1000((clkin_period_length_1000)),
				.clk(clkin),
				.out(out[i]),
				.out_period_length_1000(out_period_length_1000[i]));
		end
	endgenerate

	/* phase shift */
	generate
		for (i = 0; i <= 6; i = i + 1) begin : ps
			phase_shift ps (
				.RST(RST),
				.PWRDWN(PWRDWN),
				.clk(out[i]),
				.shift_1000(CLKOUT_PHASE_INT_1000[i] + CLKFBOUT_PHASE_INT_1000),
				.duty_cycle(CLKOUT_DUTY_CYCLE_INT_1000[i] / 10),
				.clk_period_1000(out_period_length_1000[i]),
				.lock(lock[i]),
				.clk_shifted(CLKOUT_INT[i]));
		end
	endgenerate

	wire fb_out;
	wire [31:0] fb_out_period_length_1000;
	wire fb_lock;

	/* CLKOUTFB */
	freq_gen fb_fg (
		.M_1000(CLKFBOUT_MULT_F_INT_1000),
		.D(DIVCLK_DIVIDE_INT),
		.O_1000(1000.0),
		.RST(RST),
		.PWRDWN(PWRDWN),
		.period_stable(period_stable),
		.ref_period_1000((clkin_period_length_1000)),
		.clk(clkin),
		.out(fb_out),
		.out_period_length_1000(fb_out_period_length_1000));

	phase_shift fb_ps (
		.RST(RST),
		.PWRDWN(PWRDWN),
		.clk(fb_out),
		.shift_1000(CLKFBOUT_PHASE_INT_1000),
		.clk_period_1000(fb_out_period_length_1000),
		.duty_cycle(50),
		.lock(fb_lock),
		.clk_shifted(CLKFBOUT));

	/* dynamically set values */
	wire [31:0] CLKOUT_DIVIDE_DYN[0:6];
	wire [31:0] CLKOUT_DUTY_CYCLE_DYN_1000[0:6];
	wire signed [31:0] CLKOUT_PHASE_DYN[0:6];
	wire [31:0] CLKFBOUT_MULT_F_DYN_1000;
	wire signed [31:0] CLKFBOUT_PHASE_DYN;
	wire [31:0] DIVCLK_DIVIDE_DYN;

	/* reconfiguration */
	dyn_reconf dyn_reconf (
		.RST(RST),
		.PWRDWN(PWRDWN),

		.vco_period_1000(fb_out_period_length_1000),

		.DADDR(DADDR),
		.DCLK(DCLK),
		.DEN(DEN),
		.DWE(DWE),
		.DI(DI),
		.DO(DO),
		.DRDY(DRDY),

		.CLKOUT0_DIVIDE(CLKOUT_DIVIDE_DYN[0]),
		.CLKOUT0_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[0]),
		.CLKOUT0_PHASE(CLKOUT_PHASE_DYN[0]),

		.CLKOUT1_DIVIDE(CLKOUT_DIVIDE_DYN[1]),
		.CLKOUT1_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[1]),
		.CLKOUT1_PHASE(CLKOUT_PHASE_DYN[1]),

		.CLKOUT2_DIVIDE(CLKOUT_DIVIDE_DYN[2]),
		.CLKOUT2_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[2]),
		.CLKOUT2_PHASE(CLKOUT_PHASE_DYN[2]),

		.CLKOUT3_DIVIDE(CLKOUT_DIVIDE_DYN[3]),
		.CLKOUT3_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[3]),
		.CLKOUT3_PHASE(CLKOUT_PHASE_DYN[3]),

		.CLKOUT4_DIVIDE(CLKOUT_DIVIDE_DYN[4]),
		.CLKOUT4_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[4]),
		.CLKOUT4_PHASE(CLKOUT_PHASE_DYN[4]),

		.CLKOUT5_DIVIDE(CLKOUT_DIVIDE_DYN[5]),
		.CLKOUT5_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[5]),
		.CLKOUT5_PHASE(CLKOUT_PHASE_DYN[5]),

		.CLKOUT6_DIVIDE(CLKOUT_DIVIDE_DYN[6]),
		.CLKOUT6_DUTY_CYCLE_1000(CLKOUT_DUTY_CYCLE_DYN_1000[6]),
		.CLKOUT6_PHASE(CLKOUT_PHASE_DYN[6]),

		.CLKFBOUT_MULT_F_1000(CLKFBOUT_MULT_F_DYN_1000),
		.CLKFBOUT_PHASE(CLKFBOUT_PHASE_DYN),

		.DIVCLK_DIVIDE(DIVCLK_DIVIDE_DYN));


	/* lock detection using the lock information given by the phase shift modules */
	assign LOCKED = lock[0] & lock[1] & lock[2] & lock[3] & lock[4] & lock[5] & lock[6] & fb_lock;

	/* set clkin to the correct CLKIN */
	always @* begin
		if (CLKINSEL === 1'b1) begin
			clkin = CLKIN1;
		end else if (CLKINSEL === 1'b0) begin
			clkin = CLKIN2;
		end
	end

	integer k;
	/* set the internal values to the dynamically set */
	always @* begin
		for (k = 0; k <= 6; k = k + 1) begin
			if (CLKOUT_DIVIDE_DYN[k] != 0)
				CLKOUT_DIVIDE_INT_1000[k] = CLKOUT_DIVIDE_DYN[k] * 1000;
			if (CLKOUT_DUTY_CYCLE_DYN_1000[k] != 0)
				CLKOUT_DUTY_CYCLE_INT_1000[k] = CLKOUT_DUTY_CYCLE_DYN_1000[k];
			if (CLKOUT_PHASE_DYN[k] != 0)
				CLKOUT_PHASE_INT_1000[k] = CLKOUT_PHASE_DYN[k] * 1000;
		end
		if (CLKFBOUT_MULT_F_DYN_1000 != 0)
			CLKFBOUT_MULT_F_INT_1000 = CLKFBOUT_MULT_F_DYN_1000;
		if (CLKFBOUT_PHASE_DYN != 0)
			CLKFBOUT_PHASE_INT_1000 = CLKFBOUT_PHASE_DYN * 1000;
		if (DIVCLK_DIVIDE_DYN != 0)
			DIVCLK_DIVIDE_INT = DIVCLK_DIVIDE_DYN;
	end

	/* assign initial values */
	integer vco_min;
	integer vco_max;
	initial begin
		CLKOUT_DIVIDE_INT_1000[0] = CLKOUT0_DIVIDE_F * 1000;
		CLKOUT_DIVIDE_INT_1000[1] = CLKOUT1_DIVIDE * 1000;
		CLKOUT_DIVIDE_INT_1000[2] = CLKOUT2_DIVIDE * 1000;
		CLKOUT_DIVIDE_INT_1000[3] = CLKOUT3_DIVIDE * 1000;
		if (CLKOUT4_CASCADE == "FALSE") begin
			CLKOUT_DIVIDE_INT_1000[4] = CLKOUT4_DIVIDE * 1000;
			CLKOUT_DIVIDE_INT_1000[6] = CLKOUT6_DIVIDE * 1000;
		end else if (CLKOUT4_CASCADE == "TRUE") begin
			CLKOUT_DIVIDE_INT_1000[4] = CLKOUT4_DIVIDE * CLKOUT6_DIVIDE * 1000;
			CLKOUT_DIVIDE_INT_1000[6] = 1000;
		end
		CLKOUT_DIVIDE_INT_1000[5] = CLKOUT5_DIVIDE * 1000;

		CLKOUT_DUTY_CYCLE_INT_1000[0] = CLKOUT0_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[1] = CLKOUT1_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[2] = CLKOUT2_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[3] = CLKOUT3_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[4] = CLKOUT4_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[5] = CLKOUT5_DUTY_CYCLE * 1000;
		CLKOUT_DUTY_CYCLE_INT_1000[6] = CLKOUT6_DUTY_CYCLE * 1000;

		CLKOUT_PHASE_INT_1000[0] = CLKOUT0_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[1] = CLKOUT1_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[2] = CLKOUT2_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[3] = CLKOUT3_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[4] = CLKOUT4_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[5] = CLKOUT5_PHASE * 1000;
		CLKOUT_PHASE_INT_1000[6] = CLKOUT6_PHASE * 1000;

		CLKFBOUT_MULT_F_INT_1000 = CLKFBOUT_MULT_F * 1000;
		CLKFBOUT_PHASE_INT_1000 = CLKFBOUT_PHASE * 1000;
		DIVCLK_DIVIDE_INT = DIVCLK_DIVIDE;

		/* set up limits correctly */
		case (FPGA_TYPE)
			"ARTIX":
				case (SPEED_GRADE)
					"-3": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 2133;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1600;
						end
					"-2": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1866;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1440;
						end
					"-1", "-1LI", "-2LE": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1600;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1200;
						end
					default: begin
							$display("The speed grade given is not valid. Please choose one of the following: -3, -2, -2LE, -1, -1LI");
							$display("Exiting simulation...");
							$finish;
						end
				endcase
			"KINTEX":
				case (SPEED_GRADE)
					"-3": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 2133;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1600;
						end
					"-2", "-2LI": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1866;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1440;
						end
					"-1", "-1M", "-1LM", "-1Q", "-2LE": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1600;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1200;
						end
					default: begin
							$display("The speed grade given is not valid. Please choose one of the following: -3, -2, -2LI, -2LE, -1, -1M, -1LM, -1Q");
							$display("Exiting simulation...");
							$finish;
						end
				endcase
			"VIRTEX":
				case (SPEED_GRADE)
					"-3": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 2133;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1600;
						end
					"-2", "-2L", "-2LG": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1833;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1440;
						end
					"-1", "-1M": if (MODULE_TYPE == "PLLE2_ADV" || MODULE_TYPE == "PLLE2_BASE") begin
							vco_min = 800;
							vco_max = 1600;
						end else if (MODULE_TYPE == "MMCME2_BASE") begin
							vco_min = 600;
							vco_max = 1200;
						end
					default: begin
							$display("The speed grade given is not valid. Please choose one of the following: -3, -2, -2L, -2LG, -1, -1M");
							$display("Exiting simulation...");
							$finish;
						end
				endcase
			default: begin
					$display("The FPGA type given is not recognized. Please choose one of the following: ARTIX, VIRTEX, KINTEX");
					$display("Exiting simulation...");
					$finish;
				end
		endcase
	end

	integer l;
	reg invalid = 1'b0;
	/* check values for validity */
	always @(*) begin
		/* the same for each version of the pll/mmcm */
		if (!(BANDWIDTH == "OPTIMIZED" || BANDWIDTH == "HIGH" || BANDWIDTH == "LOW")) begin
			$display("BANDWIDTH doesn't match any of its allowed inputs.");
			invalid = 1'b1;
		end else if (CLKIN1_PERIOD < 0.000 || CLKIN1_PERIOD > 52.631) begin
			$display("CLKIN1_PERIOD is not in the allowed range (0 - 52.631).");
			invalid = 1'b1;
		end else if (CLKIN2_PERIOD < 0.000 || CLKIN2_PERIOD > 52.631) begin
			$display("CLKIN2_PERIOD is not in the allowed range (0 - 52.631).");
			invalid = 1'b1;
		end else if (CLKFBOUT_PHASE_INT_1000 < -360000 || CLKFBOUT_PHASE_INT_1000 > 360000) begin
			$display("CLKFBOUT_PHASE is not in the allowed range (-360-360).");
			invalid = 1'b1;
		end else if (DIVCLK_DIVIDE_INT < 1 || DIVCLK_DIVIDE_INT > 56) begin
			$display("DIVCLK_DIVIDE is not in the allowed range (1-56).");
			invalid = 1'b1;
		end else if (REF_JITTER1 < 0.000 || REF_JITTER1 > 0.999) begin
			$display("REF_JITTER1 is not in the allowed range (0.000 - 0.999).");
			invalid = 1'b1;
		end else if (REF_JITTER2 < 0.000 || REF_JITTER2 > 0.999) begin
			$display("REF_JITTER2 is not in the allowed range (0.000 - 0.999).");
			invalid = 1'b1;
		end else if (!(STARTUP_WAIT == "FALSE" || STARTUP_WAIT == "TRUE")) begin
			$display("STARTUP_WAIT doesn't match any of its allowed inputs");
			invalid = 1'b1;
		end else if (!(COMPENSATION == "ZHOLD" || COMPENSATION == "BUF_IN" || COMPENSATION == "EXTERNAL" || COMPENSATION == "INTERNAL")) begin
			$display("COMPENSATION doesn't match any of its allowed inputs");
			invalid = 1'b1;
		end else if (!(CLKOUT4_CASCADE == "TRUE" || CLKOUT4_CASCADE == "FALSE")) begin
			$display("CLKOUT4_CASCADE doesn't match any of its allowed inputs");
			invalid = 1'b1;
		end

		for (l = 0; l <= 6; l = l + 1) begin
			if (l != 0) begin
				if ((CLKOUT_DIVIDE_INT_1000[l] / 1000.0) < 1 || (CLKOUT_DIVIDE_INT_1000[l] / 1000.0) > 128 || ((((CLKOUT_DIVIDE_INT_1000[l] / 1000.0) - $floor((CLKOUT_DIVIDE_INT_1000[l] / 1000.0)) > 0.001)))) begin
					$display("CLKOUT%0d_DIVIDE is not in the allowed range (1-128) or it is a floating point number", l);
					invalid = 1'b1;
				end
			end
			if (CLKOUT_DUTY_CYCLE_INT_1000[l] < 1 || CLKOUT_DUTY_CYCLE_INT_1000[l] > 999) begin
				$display("CLKOUT%0d_DUTY_CYCLE is not in the allowed range(0.001-0.999)", l);
				invalid = 1'b1;
			end else if (CLKOUT_PHASE_INT_1000[l] < -360000 || CLKOUT_PHASE_INT_1000[l] > 360000) begin
				$display("CLKOUT%0d_PHASE is not in the allowed range(-360.000-360.000)", l);
				invalid = 1'b1;
			end
		end

		/* different on pll and mmcm */
		if (MODULE_TYPE == "PLLE2_BASE" || MODULE_TYPE == "PLLE2_ADV") begin
			if (CLKFBOUT_MULT_F_INT_1000 < 2000 || CLKFBOUT_MULT_F_INT_1000 > 64000 || ((CLKFBOUT_MULT_F_INT_1000 / 1000.0) - $floor((CLKFBOUT_MULT_F_INT_1000 / 1000.0)) > 0.001)) begin
				$display("CLKFBOUT_MULT is not in the allowed range (2-64) or a floating point number.");
				invalid = 1'b1;
			end else if ((CLKOUT_DIVIDE_INT_1000[0] / 1000.0) < 1 || (CLKOUT_DIVIDE_INT_1000[0] / 1000.0) > 128 || (((CLKOUT_DIVIDE_INT_1000[0] / 1000.0) - $floor((CLKOUT_DIVIDE_INT_1000[0] / 1000.0)) > 0.001))) begin
				$display("CLKOUT0_DIVIDE is not in the allowed range (1-128) or it is a floating point number");
				invalid = 1'b1;
			end
		end else if (MODULE_TYPE == "MMCME2_BASE") begin
			if (CLKFBOUT_MULT_F_INT_1000 < 2000 || CLKFBOUT_MULT_F_INT_1000 > 64000) begin
				$display("CLKFBOUT_MULT_F is not in the allowed range (2.000-64.000)");
				invalid = 1'b1;
			end else if (CLKOUT_DIVIDE_INT_1000[0] < 1000 || CLKOUT_DIVIDE_INT_1000[0] > 128000) begin
				$display("CLKOUT0_DIVIDE_F is not in the allowed range(2.000-64.000)");
				invalid = 1'b1;
			end
		end

		if (CLKINSEL == 1 && ((CLKFBOUT_MULT_F_INT_1000 / (CLKIN1_PERIOD * 1.0 * DIVCLK_DIVIDE)) < vco_min || (CLKFBOUT_MULT_F_INT_1000 / (CLKIN1_PERIOD * 1.0 * DIVCLK_DIVIDE_INT)) > vco_max)) begin
			$display("The calculated VCO frequency is not in the allowed range (%0d-%0d). Change either CLKFBOUT_MULT_F, CLKIN1_PERIOD or DIVCLK_DIVIDE to an appropiate value.", vco_min, vco_max);
			$display("To calculate the VCO frequency use this formula: (CLKFBOUT_MULT_F * 1000) / (CLKIN1_PERIOD * DIVCLK_DIVIDE).");
			$display("Currently the value is %0f.", (CLKFBOUT_MULT_F_INT_1000 / (CLKIN1_PERIOD * 1.0 * DIVCLK_DIVIDE_INT)));
			invalid = 1'b1;
		end else if (CLKINSEL == 0 && ((CLKFBOUT_MULT_F_INT_1000 / (CLKIN2_PERIOD * 1.0 * DIVCLK_DIVIDE)) < vco_min || (CLKFBOUT_MULT_F_INT_1000 / (CLKIN2_PERIOD * 1.0 * DIVCLK_DIVIDE_INT)) > vco_max)) begin
			$display("The calculated VCO frequency is not in the allowed range (%0d-%0d). Change either CLKFBOUT_MULT_F, CLKIN2_PERIOD or DIVCLK_DIVIDE to an appropiate value.", vco_min, vco_max);
			$display("To calculate the VCO frequency use this formula: (CLKFBOUT_MULT_F * 1000) / (CLKIN2_PERIOD * DIVCLK_DIVIDE).");
			$display("Currently the value is %0f.", (CLKFBOUT_MULT_F_INT_1000 / (CLKIN2_PERIOD * 1.0 * DIVCLK_DIVIDE_INT)));
			invalid = 1'b1;
		end


		/* NOTE: delete this to simulate even if there are invalid values */
		if (invalid) begin
			$display("Exiting simulation...");
			$finish;
		end
	end
endmodule
