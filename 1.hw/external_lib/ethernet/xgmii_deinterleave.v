// Copyright (c) 2016-2018 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * XGMII control/data deinterleave
 */
module xgmii_deinterleave
(
    input  wire [72:0] input_xgmii_dc,

    output wire [63:0] output_xgmii_d,
    output wire [7:0]  output_xgmii_c
);

assign output_xgmii_d[7:0] = input_xgmii_dc[7:0];
assign output_xgmii_c[0] = input_xgmii_dc[8];
assign output_xgmii_d[15:8] = input_xgmii_dc[16:9];
assign output_xgmii_c[1] = input_xgmii_dc[17];
assign output_xgmii_d[23:16] = input_xgmii_dc[25:18];
assign output_xgmii_c[2] = input_xgmii_dc[26];
assign output_xgmii_d[31:24] = input_xgmii_dc[34:27];
assign output_xgmii_c[3] = input_xgmii_dc[35];
assign output_xgmii_d[39:32] = input_xgmii_dc[43:36];
assign output_xgmii_c[4] = input_xgmii_dc[44];
assign output_xgmii_d[47:40] = input_xgmii_dc[52:45];
assign output_xgmii_c[5] = input_xgmii_dc[53];
assign output_xgmii_d[55:48] = input_xgmii_dc[61:54];
assign output_xgmii_c[6] = input_xgmii_dc[62];
assign output_xgmii_d[63:56] = input_xgmii_dc[70:63];
assign output_xgmii_c[7] = input_xgmii_dc[71];

endmodule

`resetall
