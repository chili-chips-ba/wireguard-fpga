/*
 * period_check.v: Determines if the given input has a stable value.
 * author: Till Mahlburg
 * year: 2019
 * organization: Universität Leipzig
 * license: ISC
 *
 */

`timescale 1 ns / 1 ps

module period_check (
	input RST,
	input PWRDWN,
	input clk,
	input [31:0] period_length,
	output reg period_stable);

	/* tracks the last period length measured */
	integer period_length_last;

	/* checks if the measured period length didn't change since the last rising edge of the clk */
	always @(posedge clk or posedge RST or posedge PWRDWN) begin
		if (PWRDWN) begin
			period_stable <= 1'bx;
			period_length_last <= 0;
		end else if (RST) begin
			period_stable <= 1'b0;
			period_length_last <= 0;
		end else if (period_length == period_length_last && period_length != 0) begin
			period_stable <= 1'b1;
			period_length_last <= period_length;
		end else begin
			period_stable <= 1'b0;
			period_length_last <= period_length;
		end
	end

endmodule