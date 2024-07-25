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
//  /   /         Filename: mig_7series_v4_2_poc_meta.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Tue 15 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: Phaser output calibration meta controller.
//
// Compute center of the window  set up with with the ktap_left, 
// ktap_right dance (hereafter "the window").  Also compute center of the 
// edge (hereafter "the edge") to be aligned in the center
// of this window.
//
// Following the ktap_left/right dance, the to be centered edge is 
// always left at the right edge of the window
// if SCANFROMRIGHT == 1, and the left edge otherwise.  
//
// An assumption is the rise(0) case has a window wider than the noise on the
// edge.  The noise case with the possibly narrow window
// will always be shifted by 90.  And the fall(180) case is shifted by
// 90 twice.  Hence when we start, we can assume the center of the
// edge is to the right/left of the the window center.
//
// The actual hardware does not necessarily monotonically appear to
// move the window centers.  Because of noise, it is possible for the
// centered edge to move opposite the expected direction with a tap increment.
//
// This problem is solved by computing the absolute difference between
// the centers and the circular distance between the centers.  These will
// be the same until the difference transits through zero.  Then the circular
// difference will jump to almost the value of TAPSPERKCLK.
//
// The window center computation is done at 1/2 tap increments to maintain
// resolution through the divide by 2 for centering.
//
// There is a corner case of when the shift is greater than 180 degress.  In
// this case the absolute difference and the circular difference will be
// unequal at the beginning of the alignment.  This is solved by latching
// if they are equal at the end of each cycle.  The completion must see
// that they were equal in the previous cycle, but are not equal in this cycle.
//
// Since the phaser out steps are of unknown size, it is possible to overshoot
// the center.  The previous difference is recorded and if its less than the current
// difference, poc_backup is driven high.
//
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_meta #
  (parameter SCANFROMRIGHT              = 0,
   parameter TCQ                        = 100,
   parameter TAPCNTRWIDTH               = 7,
   parameter TAPSPERKCLK                = 112)
  (/*AUTOARG*/
  // Outputs
  run_ends, mmcm_edge_detect_done, edge_center, left, right,
  window_center, diff, poc_backup, mmcm_lbclk_edge_aligned,
  // Inputs
  rst, clk, mmcm_edge_detect_rdy, run_too_small, run, run_end,
  run_polarity, rise_lead_right, rise_trail_left, rise_lead_center,
  rise_trail_center, rise_trail_right, rise_lead_left, ninety_offsets,
  use_noise_window, ktap_at_right_edge, ktap_at_left_edge
  );

  localparam NINETY = TAPSPERKCLK/4;
  
  function [TAPCNTRWIDTH-1:0] offset (input [TAPCNTRWIDTH-1:0] a, 
                                      input [1:0] b,
                                      input integer base);
    integer offset_ii;
    begin
      offset_ii = (a + b * NINETY) < base
                     ? (a + b * NINETY) 
                     : (a + b * NINETY - base);
      offset = offset_ii[TAPCNTRWIDTH-1:0];
    end
  endfunction // offset

  function [TAPCNTRWIDTH-1:0] mod_sub (input [TAPCNTRWIDTH-1:0] a, 
                                       input [TAPCNTRWIDTH-1:0] b,
                                       input integer base); 
    begin
      mod_sub = (a>=b) ? a-b : a+base-b;
    end
  endfunction // mod_sub

  function [TAPCNTRWIDTH:0] center (input [TAPCNTRWIDTH-1:0] left, 
                                    input [TAPCNTRWIDTH-1:0] diff,
                                    input integer base);
    integer center_ii;
    begin
      center_ii = ({left, 1'b0} + diff < base * 2)
                    ? {left, 1'b0} + diff + 32'h0
	            : {left, 1'b0} + diff - base * 2;
      center = center_ii[TAPCNTRWIDTH:0];
    end
  endfunction // center

  input rst;
  input clk;


  input mmcm_edge_detect_rdy;

  reg [1:0] run_ends_r;

  input run_too_small;
  reg run_too_small_r1, run_too_small_r2, run_too_small_r3;

  always @ (posedge clk) run_too_small_r1 <= #TCQ run_too_small & (run_ends_r == 'd1);  //align with run_end_r1;
  always @ (posedge clk) run_too_small_r2 <= #TCQ run_too_small_r1;
  always @ (posedge clk) run_too_small_r3 <= #TCQ run_too_small_r2;

  wire reset_run_ends = rst || ~mmcm_edge_detect_rdy || run_too_small_r3 ;

  // This input used only for the SVA.
  input [TAPCNTRWIDTH-1:0] run;
  
  input run_end;
  reg run_end_r, run_end_r1, run_end_r2, run_end_r3;
  always @(posedge clk) run_end_r <= #TCQ run_end;
  always @(posedge clk) run_end_r1 <= #TCQ run_end_r;
  always @(posedge clk) run_end_r2 <= #TCQ run_end_r1;
  always @(posedge clk) run_end_r3 <= #TCQ run_end_r2;

  input run_polarity;
  reg run_polarity_held_ns, run_polarity_held_r;
  always @(posedge clk) run_polarity_held_r <= #TCQ run_polarity_held_ns;
  always @(*) run_polarity_held_ns = run_end ? run_polarity : run_polarity_held_r;
  
  reg [1:0] run_ends_ns;
  always @(posedge clk) run_ends_r <= #TCQ run_ends_ns;
  always @(*) begin
    run_ends_ns = run_ends_r;
    if (reset_run_ends) run_ends_ns = 2'b0;
    else case (run_ends_r) 
           2'b00 : run_ends_ns = run_ends_r + {1'b0, run_end_r3 && run_polarity_held_r};
	   2'b01, 2'b10 : run_ends_ns = run_ends_r + {1'b0, run_end_r3};
	  endcase // case (run_ends_r)
  end // always @ begin
  output [1:0] run_ends;
  assign run_ends = run_ends_r;

  reg done_r;
  wire done_ns = mmcm_edge_detect_rdy && &run_ends_r;
  always @(posedge clk) done_r <= #TCQ done_ns;
  output mmcm_edge_detect_done;
  assign mmcm_edge_detect_done = done_r;  

  input [TAPCNTRWIDTH-1:0] rise_lead_right;
  input [TAPCNTRWIDTH-1:0] rise_trail_left;
  input [TAPCNTRWIDTH-1:0] rise_lead_center;
  input [TAPCNTRWIDTH-1:0] rise_trail_center;
  input [TAPCNTRWIDTH-1:0] rise_trail_right;
  input [TAPCNTRWIDTH-1:0] rise_lead_left;

  input [1:0] ninety_offsets;
  wire [1:0] offsets = SCANFROMRIGHT == 1 ? ninety_offsets : 2'b00 - ninety_offsets;

  wire [TAPCNTRWIDTH-1:0] rise_lead_center_offset_ns = offset(rise_lead_center, offsets, TAPSPERKCLK);
  wire [TAPCNTRWIDTH-1:0] rise_trail_center_offset_ns = offset(rise_trail_center, offsets, TAPSPERKCLK);
  reg [TAPCNTRWIDTH-1:0] rise_lead_center_offset_r, rise_trail_center_offset_r;
  always @(posedge clk) rise_lead_center_offset_r <= #TCQ rise_lead_center_offset_ns;
  always @(posedge clk) rise_trail_center_offset_r <= #TCQ rise_trail_center_offset_ns;

  wire [TAPCNTRWIDTH-1:0] edge_diff_ns = mod_sub(rise_trail_center_offset_r, rise_lead_center_offset_r, TAPSPERKCLK);
  reg [TAPCNTRWIDTH-1:0] edge_diff_r;
  always @(posedge clk) edge_diff_r <= #TCQ edge_diff_ns;
  
  wire [TAPCNTRWIDTH:0] edge_center_ns = center(rise_lead_center_offset_r, edge_diff_r, TAPSPERKCLK);
  reg [TAPCNTRWIDTH:0] edge_center_r;
  always @(posedge clk) edge_center_r <= #TCQ edge_center_ns;
  output [TAPCNTRWIDTH:0] edge_center;
  assign edge_center = edge_center_r;

  input use_noise_window;
  output [TAPCNTRWIDTH-1:0] left, right;
  assign left = use_noise_window ? rise_lead_left : rise_trail_left;
  assign right = use_noise_window ? rise_trail_right : rise_lead_right;

  wire [TAPCNTRWIDTH-1:0] center_diff_ns = mod_sub(right, left, TAPSPERKCLK);
  reg [TAPCNTRWIDTH-1:0] center_diff_r;
  always @(posedge clk) center_diff_r <= #TCQ center_diff_ns;
  
  wire [TAPCNTRWIDTH:0] window_center_ns = center(left, center_diff_r, TAPSPERKCLK);
  reg [TAPCNTRWIDTH:0] window_center_r;
  always @(posedge clk) window_center_r <= #TCQ window_center_ns;
  output [TAPCNTRWIDTH:0] window_center;
  assign window_center = window_center_r;

  localparam TAPSPERKCLKX2 = TAPSPERKCLK * 2;

  wire [TAPCNTRWIDTH+1:0] left_center = {1'b0, SCANFROMRIGHT == 1 ? window_center_r : edge_center_r};
  wire [TAPCNTRWIDTH+1:0] right_center = {1'b0, SCANFROMRIGHT == 1 ? edge_center_r : window_center_r};
			  
  wire [TAPCNTRWIDTH+1:0] diff_ns = right_center >= left_center
                                     ? right_center - left_center
                                     : right_center + TAPSPERKCLKX2[TAPCNTRWIDTH+1:0] - left_center;
  
  reg [TAPCNTRWIDTH+1:0] diff_r;
  always @(posedge clk) diff_r <= #TCQ diff_ns;
  output [TAPCNTRWIDTH+1:0] diff;
  assign diff = diff_r;

  wire [TAPCNTRWIDTH+1:0] abs_diff = diff_r > TAPSPERKCLKX2[TAPCNTRWIDTH+1:0]/2
                                       ? TAPSPERKCLKX2[TAPCNTRWIDTH+1:0] - diff_r
                                       : diff_r;

  reg [TAPCNTRWIDTH+1:0] prev_ns, prev_r;
  always @(posedge clk) prev_r <= #TCQ prev_ns;
  always @(*) prev_ns = done_ns ? diff_r : prev_r;

  input ktap_at_right_edge;
  input ktap_at_left_edge;
  
  wire centering = !(ktap_at_right_edge || ktap_at_left_edge);
  wire diffs_eq = abs_diff == diff_r;
  reg diffs_eq_ns, diffs_eq_r;
  always @(*) diffs_eq_ns = centering && ((done_r && done_ns) ? diffs_eq : diffs_eq_r);
  always @(posedge clk) diffs_eq_r <= #TCQ diffs_eq_ns;

  reg edge_aligned_r;
  reg prev_valid_ns, prev_valid_r;
  always @(posedge clk) prev_valid_r <= #TCQ prev_valid_ns;
  always @(*) prev_valid_ns = (~rst && ~ktap_at_right_edge && ~ktap_at_left_edge && ~edge_aligned_r) && prev_valid_r | done_ns;

  wire indicate_alignment = ~rst && centering && done_ns;
  wire edge_aligned_ns = indicate_alignment && (~|diff_r || ~diffs_eq & diffs_eq_r);
  always @(posedge clk) edge_aligned_r <= #TCQ edge_aligned_ns;

  reg poc_backup_r;
  wire poc_backup_ns = edge_aligned_ns && abs_diff > prev_r;
  always @(posedge clk) poc_backup_r <= #TCQ poc_backup_ns;
  output poc_backup;
  assign poc_backup = poc_backup_r;

  output mmcm_lbclk_edge_aligned;
  assign mmcm_lbclk_edge_aligned = edge_aligned_r;
  
endmodule // mig_7series_v4_2_poc_meta

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-extensions:(".v")
// End:

