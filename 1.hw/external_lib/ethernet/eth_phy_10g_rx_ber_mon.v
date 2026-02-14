// Copyright (c) 2018 Alex Forencich
//
// SPDX-License-Identifier: MIT

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * 10G Ethernet PHY BER monitor
 */
module eth_phy_10g_rx_ber_mon #
(
    parameter HDR_WIDTH = 2,
    parameter COUNT_125US = 125000/6.4
)
(
    input  wire                  clk,
    input  wire                  rst,

    /*
     * SERDES interface
     */
    input  wire [HDR_WIDTH-1:0]  serdes_rx_hdr,

    /*
     * Status
     */
    output wire                  rx_high_ber
);

// bus width assertions
initial begin
    if (HDR_WIDTH != 2) begin
        $error("Error: HDR_WIDTH must be 2");
        $finish;
    end
end

parameter COUNT_WIDTH = $clog2($rtoi(COUNT_125US));

localparam [1:0]
    SYNC_DATA = 2'b10,
    SYNC_CTRL = 2'b01;

reg [COUNT_WIDTH-1:0] time_count_reg = COUNT_125US, time_count_next;
reg [3:0] ber_count_reg = 4'd0, ber_count_next;

reg rx_high_ber_reg = 1'b0, rx_high_ber_next;

assign rx_high_ber = rx_high_ber_reg;

always @* begin
    if (time_count_reg > 0) begin
        time_count_next = time_count_reg-1;
    end else begin
        time_count_next = time_count_reg;
    end
    ber_count_next = ber_count_reg;

    rx_high_ber_next = rx_high_ber_reg;

    if (serdes_rx_hdr == SYNC_CTRL || serdes_rx_hdr == SYNC_DATA) begin
        // valid header
        if (ber_count_reg != 4'd15) begin
            if (time_count_reg == 0) begin
                rx_high_ber_next = 1'b0;
            end
        end
    end else begin
        // invalid header
        if (ber_count_reg == 4'd15) begin
            rx_high_ber_next = 1'b1;
        end else begin
            ber_count_next = ber_count_reg + 1;
            if (time_count_reg == 0) begin
                rx_high_ber_next = 1'b0;
            end
        end
    end
    if (time_count_reg == 0) begin
        // 125 us timer expired
        ber_count_next = 4'd0;
        time_count_next = COUNT_125US;
    end
end

always @(posedge clk) begin
    time_count_reg <= time_count_next;
    ber_count_reg <= ber_count_next;
    rx_high_ber_reg <= rx_high_ber_next;

    if (rst) begin
        time_count_reg <= COUNT_125US;
        ber_count_reg <= 4'd0;
        rx_high_ber_reg <= 1'b0;
    end
end

endmodule

`resetall
