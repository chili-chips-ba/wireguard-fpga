// Copyright (c) 2016-2018 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Generic source synchronous SDR output
 */
module ssio_sdr_out #
(
    // target ("SIM", "GENERIC", "XILINX", "ALTERA")
    parameter TARGET = "GENERIC",
    // IODDR style ("IODDR", "IODDR2")
    // Use IODDR for Virtex-4, Virtex-5, Virtex-6, 7 Series, Ultrascale
    // Use IODDR2 for Spartan-6
    parameter IODDR_STYLE = "IODDR2",
    // Width of register in bits
    parameter WIDTH = 1
)
(
    input  wire             clk,

    input  wire [WIDTH-1:0] input_d,

    output wire             output_clk,
    output wire [WIDTH-1:0] output_q
);

oddr #(
    .TARGET(TARGET),
    .IODDR_STYLE(IODDR_STYLE),
    .WIDTH(1)
)
clk_oddr_inst (
    .clk(clk),
    .d1(1'b0),
    .d2(1'b1),
    .q(output_clk)
);

(* IOB = "TRUE" *)
reg [WIDTH-1:0] output_q_reg = {WIDTH{1'b0}};

assign output_q = output_q_reg;

always @(posedge clk) begin
    output_q_reg <= input_d;
end

endmodule

`resetall
