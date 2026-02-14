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
module ssio_sdr_out_diff #
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

    output wire             output_clk_p,
    output wire             output_clk_n,
    output wire [WIDTH-1:0] output_q_p,
    output wire [WIDTH-1:0] output_q_n
);

wire output_clk;
wire [WIDTH-1:0] output_q;

ssio_sdr_out #(
    .TARGET(TARGET),
    .IODDR_STYLE(IODDR_STYLE),
    .WIDTH(WIDTH)
)
ssio_ddr_out_inst(
    .clk(clk),
    .input_d(input_d),
    .output_clk(output_clk),
    .output_q(output_q)
);

genvar n;

generate

if (TARGET == "XILINX") begin
    OBUFDS
    clk_obufds_inst (
        .I(output_clk),
        .O(output_clk_p),
        .OB(output_clk_n)
    );
    for (n = 0; n < WIDTH; n = n + 1) begin
        OBUFDS
        data_obufds_inst (
            .I(output_q[n]),
            .O(output_q_p[n]),
            .OB(output_q_n[n])
        );
    end
end else if (TARGET == "ALTERA") begin
    ALT_OUTBUF_DIFF
    clk_outbuf_diff_inst (
        .i(output_clk),
        .o(output_clk_p),
        .obar(output_clk_n)
    );
    for (n = 0; n < WIDTH; n = n + 1) begin
        ALT_OUTBUF_DIFF
        data_outbuf_diff_inst (
            .i(output_q[n]),
            .o(output_q_p[n]),
            .obar(output_q_n[n])
        );
    end
end else begin
    assign output_clk_p = output_clk;
    assign output_clk_n = ~output_clk;
    assign output_q_p = output_q;
    assign output_q_n = ~output_q;
end

endgenerate

endmodule

`resetall
