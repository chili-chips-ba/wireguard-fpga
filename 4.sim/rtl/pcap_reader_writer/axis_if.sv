// SPDX-FileCopyrightText: 2025 Amina Tankovic
//
// SPDX-License-Identifier: MIT

interface axis_if #
(
    parameter DATA_WIDTH = 512,
    parameter KEEP_WIDTH = DATA_WIDTH/8
)
(
    input logic            clk,
    input logic            rst
);

    logic                  ready;
    logic                  valid;
    logic [DATA_WIDTH-1:0] data;
    logic                  last;
    logic [KEEP_WIDTH-1:0] keep;

    modport out (
        input    clk,
        input    rst,
        input    ready,
        output   valid,
        output   data,
        output   last,
        output   keep
    );

    modport in (
        input    clk,
        input    rst,
        output   ready,
        input    valid,
        input    data,
        input    last,
        input    keep
    );
endinterface

