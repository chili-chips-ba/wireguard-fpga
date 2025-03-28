/*
 * dyn_reconf.v: Handles the reconfiguration process of the pll.
 * author: Till Mahlburg
 * year: 2020
 * organization: Universität Leipzig
 * license: ISC
 *
 */

/* TODO: 	- check RESERVED bits for change (not allowed in the actual PLL)
 *			- FiltReg (Device dependent)
 *			- PowerReg: How does it work? According to documentation, it
 *			  should be completely set to high for DRP, but how is it set to
 *			  without DRP?
 *			- LockReg (Device dependent)
 * 			- DivReg: What purpose does edge have here?
 *			- MMCME: FRAC(ClkReg2)
 */

`timescale 1 ns / 1 ps

module dyn_reconf (
	input RST,
	input PWRDWN,

	input [6:0] DADDR,
	input DCLK,
	input DEN,
	input DWE,
	input [15:0] DI,

	/* needed for internal calculation
	 * is equal to clkfb period after lock is achieved */
	input [31:0] vco_period_1000,

	output reg [15:0] DO,
	output reg DRDY,

	output reg [31:0] CLKOUT0_DIVIDE,
	output reg [31:0] CLKOUT1_DIVIDE,
	output reg [31:0] CLKOUT2_DIVIDE,
	output reg [31:0] CLKOUT3_DIVIDE,
	output reg [31:0] CLKOUT4_DIVIDE,
	output reg [31:0] CLKOUT5_DIVIDE,
	output reg [31:0] CLKOUT6_DIVIDE,

	output reg [31:0] CLKOUT0_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT1_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT2_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT3_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT4_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT5_DUTY_CYCLE_1000,
	output reg [31:0] CLKOUT6_DUTY_CYCLE_1000,

	output reg [31:0] CLKOUT0_PHASE,
	output reg [31:0] CLKOUT1_PHASE,
	output reg [31:0] CLKOUT2_PHASE,
	output reg [31:0] CLKOUT3_PHASE,
	output reg [31:0] CLKOUT4_PHASE,
	output reg [31:0] CLKOUT5_PHASE,
	output reg [31:0] CLKOUT6_PHASE,

	output reg [31:0] CLKFBOUT_MULT_F_1000,
	output reg [31:0] CLKFBOUT_PHASE,

	output reg [31:0] DIVCLK_DIVIDE);

	wire [31:0] CLKOUT_DIVIDE[0:6];
	wire [31:0] CLKOUT_DUTY_CYCLE[0:6];
	wire [31:0] CLKOUT_PHASE[0:6];
	wire [31:0] CLKFBOUT_MULT_;
	wire [31:0] CLKFBOUT_PHASE_;
	wire [31:0] DIVCLK_DIVIDE_;

	/* registers for dynamic output reconfiguration */
	reg [15:0] ClkReg1[0:6];
	reg [15:0] ClkReg1_FB;

	reg [15:0] ClkReg2[0:6];
	reg [15:0] ClkReg2_FB;

	reg [15:0] DivReg;

	reg [15:0] LockReg[1:3];

	reg [15:0] FiltReg[1:2];

	reg [15:0] PowerReg;

	genvar i;

	generate
		for (i = 0; i <= 6; i = i + 1) begin : generate_attributes
			assign CLKOUT_DIVIDE[i] = ClkReg1[i][11:6] + ClkReg1[i][5:0];
			assign CLKOUT_DUTY_CYCLE[i] = ((ClkReg1[i][11:6] + (ClkReg2[i][7] / 2.0)) / (ClkReg1[i][11:6] + ClkReg1[i][5:0])) * 1000;
			assign CLKOUT_PHASE[i] = ((((vco_period_1000 / 1000.0) / 8.0) * ClkReg1[i][15:13]) + ((vco_period_1000 / 1000.0) * ClkReg2[i][5:0]));
		end
	endgenerate

	assign CLKFBOUT_MULT_ = ClkReg1_FB[11:6] + ClkReg1_FB[5:0];
	assign CLKFBOUT_PHASE_ = ((((vco_period_1000 / 1000.0) / 8) * ClkReg1_FB[15:13]) + ((vco_period_1000 / 1000.0) * ClkReg2_FB[5:0]));
	assign DIVCLK_DIVIDE_ = DivReg[11:6] + DivReg[5:0];

	always @(posedge DCLK or posedge RST or posedge PWRDWN) begin
		if (PWRDWN) begin
			DRDY <= 1'bx;
			DO <= 16'hXXXX;
		end else if (RST) begin
			DO <= 16'h0000;

			ClkReg1[0] <= 0;
			ClkReg1[1] <= 0;
			ClkReg1[2] <= 0;
			ClkReg1[3] <= 0;
			ClkReg1[4] <= 0;
			ClkReg1[5] <= 0;
			ClkReg1[6] <= 0;

			ClkReg2[0] <= 0;
			ClkReg2[1] <= 0;
			ClkReg2[2] <= 0;
			ClkReg2[3] <= 0;
			ClkReg2[4] <= 0;
			ClkReg2[5] <= 0;
			ClkReg2[6] <= 0;

			ClkReg1_FB <= 0;
			ClkReg2_FB <= 0;

			DivReg <= 0;

			LockReg[1] <= 0;
			LockReg[2] <= 0;
			LockReg[3] <= 0;

			PowerReg <= 16'h1111;
			FiltReg[1] <= 0;
			FiltReg[2] <= 0;

			DRDY <= 1'b1;
		end else if (DEN) begin
			DRDY <= 1'b0;
			/* Write */
			if (DWE) begin
				case (DADDR)
					7'h06 : ClkReg1[5] <= DI;
					7'h07 : ClkReg2[5] <= DI;
					7'h08 : ClkReg1[0] <= DI;
					7'h09 : ClkReg2[0] <= DI;
					7'h0A : ClkReg1[1] <= DI;
					7'h0B : ClkReg2[1] <= DI;
					7'h0C : ClkReg1[2] <= DI;
					7'h0D : ClkReg2[2] <= DI;
					7'h0E : ClkReg1[3] <= DI;
					7'h0F : ClkReg2[3] <= DI;
					7'h10 : ClkReg1[4] <= DI;
					7'h11 : ClkReg2[4] <= DI;
					7'h12 : ClkReg1[6] <= DI;
					7'h13 : ClkReg2[6] <= DI;
					7'h14 : ClkReg1_FB <= DI;
					7'h15 : ClkReg2_FB <= DI;
					7'h16 : DivReg <= DI;
					7'h18 : begin
						LockReg[1] <= DI;
						$display("This register has no functionality yet.");
					end
					7'h19 : begin
						LockReg[2] <= DI;
						$display("This register has no functionality yet.");
					end
					7'h1A : begin
						LockReg[3] <= DI;
						$display("This register has no functionality yet.");
					end
					7'h28 : begin
						PowerReg <= DI;
						$display("This register has no functionality yet.");
					end
					7'h4E : begin
						FiltReg[1] <= DI;
						$display("This register has no functionality yet.");
					end
					7'h4F : begin
						FiltReg[2] <= DI;
						$display("This register has no functionality yet.");
					end
					default : begin
						$display("There is no register under this address.");
						$finish;
					end
				endcase
			/* Read */
			end else begin
				case (DADDR)
					7'h06 : DO <= ClkReg1[5];
					7'h07 : DO <= ClkReg2[5];
					7'h08 : DO <= ClkReg1[0];
					7'h09 : DO <= ClkReg2[0];
					7'h0A : DO <= ClkReg1[1];
					7'h0B : DO <= ClkReg2[1];
					7'h0C : DO <= ClkReg1[2];
					7'h0D : DO <= ClkReg2[2];
					7'h0E : DO <= ClkReg1[3];
					7'h0F : DO <= ClkReg2[3];
					7'h10 : DO <= ClkReg1[4];
					7'h11 : DO <= ClkReg2[4];
					7'h12 : DO <= ClkReg1[6];
					7'h13 : DO <= ClkReg2[6];
					7'h14 : DO <= ClkReg1_FB;
					7'h15 : DO <= ClkReg2_FB;
					7'h16 : DO <= DivReg;
					7'h18 : DO <= LockReg[1];
					7'h19 : DO <= LockReg[2];
					7'h1A : DO <= LockReg[3];
					7'h28 : DO <= PowerReg;
					7'h4E : DO <= FiltReg[1];
					7'h4F : DO <= FiltReg[2];
					default : begin
						$display("There is no register under this address.");
						$finish;
					end
				endcase
			end
		end else if (DRDY == 1'b0) begin
			DO <= 0;

			/* PHASE */
			if (ClkReg2_FB[6]) begin
				CLKFBOUT_MULT_F_1000 <= 1000;
			end else begin
				CLKFBOUT_MULT_F_1000 <= CLKFBOUT_MULT_ * 1000;
			end

			/* MX */
			if (ClkReg2_FB[9:8] == 2'b00) begin
				CLKFBOUT_PHASE <= CLKFBOUT_PHASE_;
			end else begin
				$display("MX has to be 2'b00.");
				$finish();
			end

			/* NO COUNT */
			if (DivReg[12]) begin
				DIVCLK_DIVIDE <= 1;
			end else begin
				DIVCLK_DIVIDE <= DIVCLK_DIVIDE_;
			end

			/* MX */
			if (ClkReg2[0][9:8] == 2'b00)
				CLKOUT0_PHASE <= CLKOUT_PHASE[0];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[1][9:8] == 2'b00)
				CLKOUT1_PHASE <= CLKOUT_PHASE[1];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[2][9:8] == 2'b00)
				CLKOUT2_PHASE <= CLKOUT_PHASE[2];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[3][9:8] == 2'b00)
				CLKOUT3_PHASE <= CLKOUT_PHASE[3];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[4][9:8] == 2'b00)
				CLKOUT4_PHASE <= CLKOUT_PHASE[4];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[5][9:8] == 2'b00)
				CLKOUT5_PHASE <= CLKOUT_PHASE[5];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end
			if (ClkReg2[6][9:8] == 2'b00)
				CLKOUT6_PHASE <= CLKOUT_PHASE[6];
			else begin
				$display("MX has to be 2'b00.");
				$finish();
			end

			/* NO COUNT */
			if (ClkReg2[0][6]) begin
				CLKOUT0_DIVIDE <= 1;
				CLKOUT0_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT0_DIVIDE <= CLKOUT_DIVIDE[0];
				CLKOUT0_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[0];
			end

			if (ClkReg2[1][6]) begin
				CLKOUT1_DIVIDE <= 1;
				CLKOUT1_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT1_DIVIDE <= CLKOUT_DIVIDE[1];
				CLKOUT1_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[0];
			end

			if (ClkReg2[2][6]) begin
				CLKOUT2_DIVIDE <= 1;
				CLKOUT2_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT2_DIVIDE <= CLKOUT_DIVIDE[2];
				CLKOUT2_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[2];
			end

			if (ClkReg2[3][6]) begin
				CLKOUT3_DIVIDE <= 1;
				CLKOUT3_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT3_DIVIDE <= CLKOUT_DIVIDE[3];
				CLKOUT3_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[3];
			end

			if (ClkReg2[4][6]) begin
				CLKOUT4_DIVIDE <= 1;
				CLKOUT4_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT4_DIVIDE <= CLKOUT_DIVIDE[4];
				CLKOUT4_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[4];
			end

			if (ClkReg2[4][6]) begin
				CLKOUT4_DIVIDE <= 1;
				CLKOUT4_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT4_DIVIDE <= CLKOUT_DIVIDE[4];
				CLKOUT4_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[4];
			end

			if (ClkReg2[5][6]) begin
				CLKOUT5_DIVIDE <= 1;
				CLKOUT5_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT5_DIVIDE <= CLKOUT_DIVIDE[5];
				CLKOUT5_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[5];
			end

			if (ClkReg2[6][6]) begin
				CLKOUT6_DIVIDE <= 1;
				CLKOUT6_DUTY_CYCLE_1000 <= 0.5 * 1000;
			end else begin
				CLKOUT6_DIVIDE <= CLKOUT_DIVIDE[6];
				CLKOUT6_DUTY_CYCLE_1000 <= CLKOUT_DUTY_CYCLE[6];
			end
			DRDY <= 1'b1;
		end
	end


endmodule
