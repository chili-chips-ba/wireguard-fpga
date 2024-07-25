//*****************************************************************************
// (c) Copyright 2009 - 2012 Xilinx, Inc. All rights reserved.
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
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version:%version
//  \   \         Application: MIG
//  /   /         Filename: mig_7series_v4_2_poc_cc.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Tue 20 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: Phaser out characterization and control.  Logic to interface with
// Chipscope and control.  Intended to support real time observation.  Largely
// not generated for production implementations.
//
// Also generates debug bus. Concept is a dynamic portion that can be used
// to examine the POC while it is operating, and a logging portion that
// stores per lane results.
//
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_cc #
  (parameter TCQ                        = 100,
   parameter CCENABLE                   = 0,
   parameter LANE_CNT_WIDTH             = 2,
   parameter PCT_SAMPS_SOLID            = 95,
   parameter SAMPCNTRWIDTH              = 8,
   parameter SAMPLES                    = 128,
   parameter SMWIDTH                    = 2,
   parameter TAPCNTRWIDTH               = 7)
  (/*AUTOARG*/
  // Outputs
  samples, samps_solid_thresh, poc_error, dbg_poc,
  // Inputs
  psen, clk, rst, ktap_at_right_edge, ktap_at_left_edge,
  mmcm_lbclk_edge_aligned, mmcm_edge_detect_done, fall_lead_right,
  fall_trail_right, rise_lead_right, rise_trail_right, fall_lead_left,
  fall_trail_left, rise_lead_left, rise_trail_left, fall_lead_center,
  fall_trail_center, rise_lead_center, rise_trail_center, lane,
  mmcm_edge_detect_rdy, poc_backup, sm, tap, run, run_end,
  run_polarity, run_too_small, samp_cntr, samps_hi, samps_hi_held,
  samps_zero, samps_one, run_ends, diff, left, right, window_center,
  edge_center
  );

  // Remember SAMPLES is whole number counting.  Zero corresponds to one sample.
  localparam integer SAMPS_SOLID_THRESH = (SAMPLES+1) * PCT_SAMPS_SOLID * 0.01;

  output [SAMPCNTRWIDTH:0] samples, samps_solid_thresh;
  input psen;

  input clk, rst;
  input ktap_at_right_edge, ktap_at_left_edge;

  input mmcm_lbclk_edge_aligned;
  wire reset_aligned_cnt = rst || ktap_at_right_edge || ktap_at_left_edge || mmcm_lbclk_edge_aligned;
  
  input mmcm_edge_detect_done;
  reg mmcm_edge_detect_done_r;
  always @(posedge clk) mmcm_edge_detect_done_r <= #TCQ mmcm_edge_detect_done;
  wire done = mmcm_edge_detect_done && ~mmcm_edge_detect_done_r;
  
  
  reg [6:0] aligned_cnt_r;
  wire [6:0] aligned_cnt_ns = reset_aligned_cnt ? 7'b0 : aligned_cnt_r + {6'b0, done};
  always @(posedge clk) aligned_cnt_r <= #TCQ aligned_cnt_ns;

  reg poc_error_r;
  wire poc_error_ns = ~rst && (aligned_cnt_r[6] || poc_error_r);
  always @(posedge clk) poc_error_r <= #TCQ poc_error_ns;
  output poc_error;
  assign poc_error = poc_error_r;
  
  input [TAPCNTRWIDTH-1:0] fall_lead_right, fall_trail_right, rise_lead_right, rise_trail_right;
  input [TAPCNTRWIDTH-1:0] fall_lead_left, fall_trail_left, rise_lead_left, rise_trail_left;
  input [TAPCNTRWIDTH-1:0] fall_lead_center, fall_trail_center, rise_lead_center, rise_trail_center;


  generate if (CCENABLE == 0) begin : no_characterization
    assign samples = SAMPLES[SAMPCNTRWIDTH:0];
    assign samps_solid_thresh = SAMPS_SOLID_THRESH[SAMPCNTRWIDTH:0];
  end else begin : characterization
  end endgenerate

  reg [1023:0] dbg_poc_r;
  output [1023:0] dbg_poc;
  assign dbg_poc = dbg_poc_r;
  input [LANE_CNT_WIDTH-1:0] lane;

  input mmcm_edge_detect_rdy;
  input poc_backup;
  input [SMWIDTH-1:0] sm;
  input [TAPCNTRWIDTH-1:0] tap;
  input [TAPCNTRWIDTH-1:0] run;
  input run_end;
  input run_polarity;
  input run_too_small;
  input [SAMPCNTRWIDTH-1:0] samp_cntr;
  input [SAMPCNTRWIDTH:0] samps_hi;
  input [SAMPCNTRWIDTH:0] samps_hi_held;
  input samps_zero, samps_one;
  input [1:0] run_ends;
  input [TAPCNTRWIDTH+1:0] diff;

  always @(*) begin
    dbg_poc_r[99:0] = 'b0;
    dbg_poc_r[1023:900] = 'b0;
    dbg_poc_r[0] = mmcm_edge_detect_rdy;
    dbg_poc_r[1] = mmcm_edge_detect_done;
    dbg_poc_r[2] = ktap_at_right_edge;
    dbg_poc_r[3] = ktap_at_left_edge;
    dbg_poc_r[4] = mmcm_lbclk_edge_aligned;
    dbg_poc_r[5] = poc_backup;
    dbg_poc_r[6+:SMWIDTH] = sm;
    dbg_poc_r[10+:TAPCNTRWIDTH] = tap;
    dbg_poc_r[20+:TAPCNTRWIDTH] = run;
    dbg_poc_r[30] = run_end;
    dbg_poc_r[31] = run_polarity;
    dbg_poc_r[32] = run_too_small;
    dbg_poc_r[33+:SAMPCNTRWIDTH] = samp_cntr;
    dbg_poc_r[49+:SAMPCNTRWIDTH+1] = samps_hi;
    dbg_poc_r[66+:SAMPCNTRWIDTH+1] = samps_hi_held;
    dbg_poc_r[83] = samps_zero;
    dbg_poc_r[84] = samps_one;
    dbg_poc_r[86:85] = run_ends;
    dbg_poc_r[87+:TAPCNTRWIDTH+2] = diff;
  end // always @ (*)

  input [TAPCNTRWIDTH-1:0] left, right;
  input [TAPCNTRWIDTH:0] window_center, edge_center;

  reg [899:100] dbg_poc_ns;
  always @(posedge clk) dbg_poc_r[899:100] <= #TCQ dbg_poc_ns;

  always @(*) begin
    if (rst) dbg_poc_ns = 'b0;
    else begin
      dbg_poc_ns = dbg_poc_r[899:100];
      if (mmcm_edge_detect_rdy && lane < 8) begin
	dbg_poc_ns[(lane+1)*100] = poc_backup;
	dbg_poc_ns[(lane+1)*100+1] = dbg_poc_ns[(lane+1)*100+1] || run_too_small;
        dbg_poc_ns[(lane+1)*100+10+:TAPCNTRWIDTH] = left;
        dbg_poc_ns[(lane+1)*100+20+:TAPCNTRWIDTH] = right;
	dbg_poc_ns[(lane+1)*100+30+:TAPCNTRWIDTH+1] = window_center;
	dbg_poc_ns[(lane+1)*100+41+:TAPCNTRWIDTH+1] = edge_center;
      end
    end
  end
  
endmodule // mig_7series_v4_2_poc_cc

