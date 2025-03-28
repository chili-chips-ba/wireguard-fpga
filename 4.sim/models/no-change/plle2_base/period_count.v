/*
 * period_count.v: Measures the length of the period of the input signal.
 * author: Till Mahlburg
 * year: 2019-2020
 * organization: Universität Leipzig
 * license: ISC
 *
 */

`timescale 1 ns / 1 ps

module period_count #(
	/* set the precision of the period count */
	parameter RESOLUTION = 0.01) (
	input RST,
	input PWRDWN,
	input clk,
	output reg [31:0] period_length_1000);

	integer period_counter;

	/* count up continuously with the given resolution */
	always begin
		#0.001
		if (RST) begin
			period_counter <= 0;
		end else begin
			period_counter <= period_counter + 1;
		end
		#(RESOLUTION - 0.001);
	end

	/* output counted value and reset counter on every rising clk edge */
	always @(posedge clk or posedge RST or posedge PWRDWN) begin
		if (PWRDWN || RST) begin
			period_length_1000 <= 0;
		end else begin
			period_length_1000 <= (period_counter * RESOLUTION * 1000);
			period_counter <= 0;
		end
	end

endmodule