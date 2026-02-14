// Copyright (c) 2019 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4-Stream frame length measurement
 */
module axis_frame_len #
(
    // Width of AXI stream interfaces in bits
    parameter DATA_WIDTH = 64,
    // Propagate tkeep signal
    // If disabled, tkeep assumed to be 1'b1
    parameter KEEP_ENABLE = (DATA_WIDTH>8),
    // tkeep signal width (words per cycle)
    parameter KEEP_WIDTH = ((DATA_WIDTH+7)/8),
    // Width of length counter
    parameter LEN_WIDTH = 16
)
(
    input  wire                   clk,
    input  wire                   rst,

    /*
     * AXI monitor
     */
    input  wire [KEEP_WIDTH-1:0]  monitor_axis_tkeep,
    input  wire                   monitor_axis_tvalid,
    input  wire                   monitor_axis_tready,
    input  wire                   monitor_axis_tlast,

    /*
     * Status
     */
    output wire [LEN_WIDTH-1:0]   frame_len,
    output wire                   frame_len_valid
);

reg [LEN_WIDTH-1:0] frame_len_reg = 0, frame_len_next;
reg frame_len_valid_reg = 1'b0, frame_len_valid_next;

assign frame_len = frame_len_reg;
assign frame_len_valid = frame_len_valid_reg;

integer offset, i, bit_cnt;

always @* begin
    frame_len_next = frame_len_reg;
    frame_len_valid_next = 1'b0;

    if (frame_len_valid_reg) begin
        frame_len_next = 0;
    end

    if (monitor_axis_tready && monitor_axis_tvalid) begin
        // valid transfer cycle

        if (monitor_axis_tlast) begin
            // end of frame
            frame_len_valid_next = 1'b1;
        end

        // increment frame length by number of words transferred
        if (KEEP_ENABLE) begin
            bit_cnt = 0;
            for (i = 0; i <= KEEP_WIDTH; i = i + 1) begin
                if (monitor_axis_tkeep == ({KEEP_WIDTH{1'b1}}) >> (KEEP_WIDTH-i)) bit_cnt = i;
            end
            frame_len_next = frame_len_next + bit_cnt;
        end else begin
            frame_len_next = frame_len_next + 1;
        end
    end
end

always @(posedge clk) begin
    frame_len_reg <= frame_len_next;
    frame_len_valid_reg <= frame_len_valid_next;

    if (rst) begin
        frame_len_reg <= 0;
        frame_len_valid_reg <= 0;
    end
end

endmodule

`resetall
