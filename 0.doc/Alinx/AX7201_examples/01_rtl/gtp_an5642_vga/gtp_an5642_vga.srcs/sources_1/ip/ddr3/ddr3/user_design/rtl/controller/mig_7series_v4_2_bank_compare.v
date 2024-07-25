//*****************************************************************************
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor                : Xilinx
// \   \   \/     Version               : %version
//  \   \         Application           : MIG
//  /   /         Filename              : bank_compare.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Tue Jun 30 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           :
//Reference         :
//Revision History  :
//*****************************************************************************

// This block stores the request for this bank machine.
//
// All possible new requests are compared against the request stored
// here.  The compare results are shared with the bank machines and
// is used to determine where to enqueue a new request.

`timescale 1ps/1ps

module mig_7series_v4_2_bank_compare #
  (parameter BANK_WIDTH               = 3,
   parameter TCQ = 100,
   parameter BURST_MODE               = "8",
   parameter COL_WIDTH                = 12,
   parameter DATA_BUF_ADDR_WIDTH      = 8,
   parameter ECC                      = "OFF",
   parameter RANK_WIDTH               = 2,
   parameter RANKS                    = 4,
   parameter ROW_WIDTH                = 16)
  (/*AUTOARG*/
  // Outputs
  req_data_buf_addr_r, req_periodic_rd_r, req_size_r, rd_wr_r,
  req_rank_r, req_bank_r, req_row_r, req_wr_r, req_priority_r,
  rb_hit_busy_r, rb_hit_busy_ns, row_hit_r, maint_hit, col_addr,
  req_ras, req_cas, row_cmd_wr, row_addr, rank_busy_r,
  // Inputs
  clk, idle_ns, idle_r, data_buf_addr, periodic_rd_insert, size, cmd,
  sending_col, rank, periodic_rd_rank_r, bank, row, col, hi_priority,
  maint_rank_r, maint_zq_r, maint_sre_r, auto_pre_r, rd_half_rmw, act_wait_r
  );

  input clk;

  input idle_ns;
  input idle_r;

  input [DATA_BUF_ADDR_WIDTH-1:0]data_buf_addr;
  output reg [DATA_BUF_ADDR_WIDTH-1:0] req_data_buf_addr_r;
  wire [DATA_BUF_ADDR_WIDTH-1:0] req_data_buf_addr_ns =
                                   idle_r
                                     ? data_buf_addr
                                     : req_data_buf_addr_r;
  always @(posedge clk) req_data_buf_addr_r <= #TCQ req_data_buf_addr_ns;

  input periodic_rd_insert;

  reg req_periodic_rd_r_lcl;
  wire req_periodic_rd_ns = idle_ns
                             ? periodic_rd_insert
                             : req_periodic_rd_r_lcl;
  always @(posedge clk) req_periodic_rd_r_lcl <= #TCQ req_periodic_rd_ns;
  output wire req_periodic_rd_r;
  assign req_periodic_rd_r = req_periodic_rd_r_lcl;

  input size;
  wire req_size_r_lcl;
  generate
    if (BURST_MODE == "4") begin : burst_mode_4
      assign req_size_r_lcl = 1'b0;
    end
    else
      if (BURST_MODE == "8") begin : burst_mode_8
        assign req_size_r_lcl = 1'b1;
      end
      else
        if (BURST_MODE == "OTF") begin : burst_mode_otf
          reg req_size;
          wire req_size_ns = idle_ns
                                 ? (periodic_rd_insert || size)
                                 : req_size;
          always @(posedge clk) req_size <= #TCQ req_size_ns;
          assign req_size_r_lcl = req_size;
        end
  endgenerate
  output wire req_size_r;
  assign req_size_r = req_size_r_lcl;



  input [2:0] cmd;
  reg [2:0] req_cmd_r;
  wire [2:0] req_cmd_ns = idle_ns
                            ? (periodic_rd_insert ? 3'b001 : cmd)
                            : req_cmd_r;
   
  always @(posedge clk) req_cmd_r <= #TCQ req_cmd_ns;

`ifdef MC_SVA
  rd_wr_only_wo_ecc: assert property
    (@(posedge clk) ((ECC != "OFF") || idle_ns || ~|req_cmd_ns[2:1]));
`endif
  
  input sending_col;
  reg rd_wr_r_lcl;
  wire rd_wr_ns = idle_ns 
                    ? ((req_cmd_ns[1:0] == 2'b11) || req_cmd_ns[0])
                    : ~sending_col && rd_wr_r_lcl;
  always @(posedge clk) rd_wr_r_lcl <= #TCQ rd_wr_ns;
  output wire rd_wr_r;
  assign rd_wr_r = rd_wr_r_lcl;

  input [RANK_WIDTH-1:0] rank;
  input [RANK_WIDTH-1:0] periodic_rd_rank_r;
  reg [RANK_WIDTH-1:0] req_rank_r_lcl = {RANK_WIDTH{1'b0}};
  reg [RANK_WIDTH-1:0] req_rank_ns = {RANK_WIDTH{1'b0}};
  generate
    if (RANKS != 1) begin
      always @(/*AS*/idle_ns or periodic_rd_insert
               or periodic_rd_rank_r or rank or req_rank_r_lcl) req_rank_ns = idle_ns
                                  ? periodic_rd_insert
                                      ? periodic_rd_rank_r
                                      : rank
                                  : req_rank_r_lcl;
      always @(posedge clk) req_rank_r_lcl <= #TCQ req_rank_ns;
    end
  endgenerate
  output wire [RANK_WIDTH-1:0] req_rank_r;
  assign req_rank_r = req_rank_r_lcl;

  input [BANK_WIDTH-1:0] bank;
  reg [BANK_WIDTH-1:0] req_bank_r_lcl;
  wire [BANK_WIDTH-1:0] req_bank_ns = idle_ns ? bank : req_bank_r_lcl;
  always @(posedge clk) req_bank_r_lcl <= #TCQ req_bank_ns;
  output wire[BANK_WIDTH-1:0] req_bank_r;
  assign req_bank_r = req_bank_r_lcl;

  input [ROW_WIDTH-1:0] row;
  reg [ROW_WIDTH-1:0] req_row_r_lcl;
  wire [ROW_WIDTH-1:0] req_row_ns = idle_ns ? row : req_row_r_lcl;
  always @(posedge clk) req_row_r_lcl <= #TCQ req_row_ns;
  output wire [ROW_WIDTH-1:0] req_row_r;
  assign req_row_r = req_row_r_lcl;

  // Make req_col_r as wide as the max row address.  This
  // makes it easier to deal with indexing different column widths.
  input [COL_WIDTH-1:0] col;
  reg [15:0] req_col_r = 16'b0;
  wire [COL_WIDTH-1:0] req_col_ns = idle_ns ? col : req_col_r[COL_WIDTH-1:0];
  always @(posedge clk) req_col_r[COL_WIDTH-1:0] <= #TCQ req_col_ns;

  reg req_wr_r_lcl;
  wire req_wr_ns = idle_ns 
                    ? ((req_cmd_ns[1:0] == 2'b11) || ~req_cmd_ns[0])
                    : req_wr_r_lcl;
  always @(posedge clk) req_wr_r_lcl <= #TCQ req_wr_ns;
  output wire req_wr_r;
  assign req_wr_r = req_wr_r_lcl;

  input hi_priority;
  output reg req_priority_r;
  wire req_priority_ns = idle_ns ? hi_priority : req_priority_r;
  always @(posedge clk) req_priority_r <= #TCQ req_priority_ns;

  wire rank_hit = (req_rank_r_lcl == (periodic_rd_insert
                                       ? periodic_rd_rank_r
                                       : rank));
  wire bank_hit = (req_bank_r_lcl == bank);
  wire rank_bank_hit = rank_hit && bank_hit;

  output reg rb_hit_busy_r;       // rank-bank hit on non idle row machine
  wire  rb_hit_busy_ns_lcl;
  assign rb_hit_busy_ns_lcl = rank_bank_hit && ~idle_ns;
  output wire  rb_hit_busy_ns;
  assign rb_hit_busy_ns = rb_hit_busy_ns_lcl;

  wire row_hit_ns = (req_row_r_lcl == row);
  output reg row_hit_r;

  always @(posedge clk) rb_hit_busy_r <= #TCQ rb_hit_busy_ns_lcl;
  always @(posedge clk) row_hit_r <= #TCQ row_hit_ns;

  input [RANK_WIDTH-1:0] maint_rank_r;
  input maint_zq_r;
  input maint_sre_r;
  output wire maint_hit;
  assign maint_hit = (req_rank_r_lcl == maint_rank_r) || maint_zq_r || maint_sre_r;

// Assemble column address.  Structure to be the same
// width as the row address.  This makes it easier
// for the downstream muxing.  Depending on the sizes
// of the row and column addresses, fill in as appropriate.
  input auto_pre_r;
  input rd_half_rmw;
  reg [15:0] col_addr_template = 16'b0;
  always @(/*AS*/auto_pre_r or rd_half_rmw or req_col_r
           or req_size_r_lcl) begin
    col_addr_template = req_col_r;
    col_addr_template[10] = auto_pre_r && ~rd_half_rmw;
    col_addr_template[11] = req_col_r[10];
    col_addr_template[12] = req_size_r_lcl;
    col_addr_template[13] = req_col_r[11];
  end
  output wire [ROW_WIDTH-1:0] col_addr;
  assign col_addr = col_addr_template[ROW_WIDTH-1:0];

  output wire req_ras;
  output wire req_cas;
  output wire row_cmd_wr;
  input act_wait_r;
  assign req_ras = 1'b0;
  assign req_cas = 1'b1;
  assign row_cmd_wr = act_wait_r;

  output reg [ROW_WIDTH-1:0] row_addr;
  always @(/*AS*/act_wait_r or req_row_r_lcl) begin
    row_addr = req_row_r_lcl;
// This causes all precharges to be precharge single bank command.
    if (~act_wait_r) row_addr[10] = 1'b0;
  end

// Indicate which, if any, rank this bank machine is busy with.
// Not registering the result would probably be more accurate, but
// would create timing issues.  This is used for refresh banking, perfect
// accuracy is not required.
  localparam ONE = 1;
  output reg [RANKS-1:0] rank_busy_r;
  wire [RANKS-1:0] rank_busy_ns = {RANKS{~idle_ns}} & (ONE[RANKS-1:0] << req_rank_ns);
  always @(posedge clk) rank_busy_r <= #TCQ rank_busy_ns;

endmodule // bank_compare

