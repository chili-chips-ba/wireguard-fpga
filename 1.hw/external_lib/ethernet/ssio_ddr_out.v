// Copyright (c) 2016-2018 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Generic source synchronous DDR output
 */
module ssio_ddr_out #
(
    // target ("SIM", "GENERIC", "XILINX", "ALTERA")
    parameter TARGET = "GENERIC",
    // IODDR style ("IODDR", "IODDR2")
    // Use IODDR for Virtex-4, Virtex-5, Virtex-6, 7 Series, Ultrascale
    // Use IODDR2 for Spartan-6
    parameter IODDR_STYLE = "IODDR2",
    // Use 90 degree clock for transmit ("TRUE", "FALSE")
    parameter USE_CLK90 = "TRUE",
    // Width of register in bits
    parameter WIDTH = 1
)
(
    input  wire             clk,
    input  wire             clk90,

    input  wire [WIDTH-1:0] input_d1,
    input  wire [WIDTH-1:0] input_d2,

    output wire             output_clk,
    output wire [WIDTH-1:0] output_q
);

wire ref_clk = USE_CLK90 == "TRUE" ? clk90 : clk;

oddr #(
    .TARGET(TARGET),
    .IODDR_STYLE(IODDR_STYLE),
    .WIDTH(1)
)
clk_oddr_inst (
    .clk(ref_clk),
    .d1(1'b1),
    .d2(1'b0),
    .q(output_clk)
);

oddr #(
    .TARGET(TARGET),
    .IODDR_STYLE(IODDR_STYLE),
    .WIDTH(WIDTH)
)
data_oddr_inst (
    .clk(clk),
    .d1(input_d1),
    .d2(input_d2),
    .q(output_q)
);

endmodule

`resetall
