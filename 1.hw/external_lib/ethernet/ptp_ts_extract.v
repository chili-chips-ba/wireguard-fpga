// Copyright (c) 2019 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * PTP timestamp extract module
 */
module ptp_ts_extract #
(
    parameter TS_WIDTH = 96,
    parameter TS_OFFSET = 1,
    parameter USER_WIDTH = TS_WIDTH+TS_OFFSET
)
(
    input  wire                   clk,
    input  wire                   rst,

    /*
     * AXI stream input
     */
    input  wire                   s_axis_tvalid,
    input  wire                   s_axis_tlast,
    input  wire [USER_WIDTH-1:0]  s_axis_tuser,

    /*
     * Timestamp output
     */
    output wire [TS_WIDTH-1:0]    m_axis_ts,
    output wire                   m_axis_ts_valid
);

reg frame_reg = 1'b0;

assign m_axis_ts = s_axis_tuser >> TS_OFFSET;
assign m_axis_ts_valid = s_axis_tvalid && !frame_reg;

always @(posedge clk) begin
    if (s_axis_tvalid) begin
        frame_reg <= !s_axis_tlast;
    end

    if (rst) begin
        frame_reg <= 1'b0;
    end
end

endmodule

`resetall
