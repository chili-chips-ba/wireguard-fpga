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
//  /   /         Filename: mig_7series_v4_2_poc_top.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Tue 15 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: Phaser out calibration top.
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_top #
  (parameter LANE_CNT_WIDTH             = 2,
   parameter MMCM_SAMP_WAIT             = 10,
   parameter PCT_SAMPS_SOLID            = 95,
   parameter POC_USE_METASTABLE_SAMP    = "FALSE",
   parameter TCQ                        = 100,
   parameter CCENABLE                   = 0,
   parameter SCANFROMRIGHT              = 0,
   parameter SAMPCNTRWIDTH              = 8,
   parameter SAMPLES                    = 128,
   parameter TAPCNTRWIDTH               = 7,
   parameter TAPSPERKCLK		=112)
  (/*AUTOARG*/
  // Outputs
  psincdec, poc_error, dbg_poc, psen, rise_lead_right,
  rise_trail_right, mmcm_edge_detect_done, mmcm_lbclk_edge_aligned,
  poc_backup,
  // Inputs
  use_noise_window, rst, psdone, poc_sample_pd, pd_out,
  ninety_offsets, mmcm_edge_detect_rdy, lane, ktap_at_right_edge,
  ktap_at_left_edge, clk
  );

  localparam SMWIDTH = 2;
  
  /*AUTOINPUT*/
  // Beginning of automatic inputs (from unused autoinst inputs)
  input			clk;			// To u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v, ...
  input			ktap_at_left_edge;	// To u_poc_meta of mig_7series_v4_2_poc_meta.v, ...
  input			ktap_at_right_edge;	// To u_poc_meta of mig_7series_v4_2_poc_meta.v, ...
  input [LANE_CNT_WIDTH-1:0] lane;		// To u_poc_cc of mig_7series_v4_2_poc_cc.v
  input			mmcm_edge_detect_rdy;	// To u_poc_meta of mig_7series_v4_2_poc_meta.v, ...
  input [1:0]		ninety_offsets;		// To u_poc_meta of mig_7series_v4_2_poc_meta.v
  input			pd_out;			// To u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  input			poc_sample_pd;		// To u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  input			psdone;			// To u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  input			rst;			// To u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v, ...
  input			use_noise_window;	// To u_poc_meta of mig_7series_v4_2_poc_meta.v
  // End of automatics
  /*AUTOOUTPUT*/
  // Beginning of automatic outputs (from unused autoinst outputs)
  output [1023:0]	dbg_poc;		// From u_poc_cc of mig_7series_v4_2_poc_cc.v
  output		poc_error;		// From u_poc_cc of mig_7series_v4_2_poc_cc.v
  output		psincdec;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  // End of automatics
  /*AUTOwire*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [TAPCNTRWIDTH+1:0] diff;			// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  wire [TAPCNTRWIDTH:0]	edge_center;		// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  wire [TAPCNTRWIDTH-1:0] fall_lead_center;	// From u_edge_center of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] fall_lead_left;	// From u_edge_left of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] fall_lead_right;	// From u_edge_right of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] fall_trail_center;	// From u_edge_center of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] fall_trail_left;	// From u_edge_left of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] fall_trail_right;	// From u_edge_right of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] left;			// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  wire [TAPCNTRWIDTH-1:0] right;		// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  wire [TAPCNTRWIDTH-1:0] rise_lead_center;	// From u_edge_center of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] rise_lead_left;	// From u_edge_left of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] rise_trail_center;	// From u_edge_center of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] rise_trail_left;	// From u_edge_left of mig_7series_v4_2_poc_edge_store.v
  wire [TAPCNTRWIDTH-1:0] run;			// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire			run_end;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [1:0]		run_ends;		// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  wire			run_polarity;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire			run_too_small;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [SAMPCNTRWIDTH-1:0] samp_cntr;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [SAMPCNTRWIDTH:0] samples;		// From u_poc_cc of mig_7series_v4_2_poc_cc.v
  wire [SAMPCNTRWIDTH:0] samps_hi;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [SAMPCNTRWIDTH:0] samps_hi_held;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire			samps_one;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [SAMPCNTRWIDTH:0] samps_solid_thresh;	// From u_poc_cc of mig_7series_v4_2_poc_cc.v
  wire			samps_zero;		// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [SMWIDTH-1:0]	sm;			// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [TAPCNTRWIDTH-1:0] tap;			// From u_poc_tap_base of mig_7series_v4_2_poc_tap_base.v
  wire [TAPCNTRWIDTH:0]	window_center;		// From u_poc_meta of mig_7series_v4_2_poc_meta.v
  // End of automatics

  output psen;
  output [TAPCNTRWIDTH-1:0] rise_lead_right;
  output [TAPCNTRWIDTH-1:0] rise_trail_right;
  output mmcm_edge_detect_done;
  output mmcm_lbclk_edge_aligned;
  output poc_backup;

  mig_7series_v4_2_poc_tap_base #
    (/*AUTOINSTPARAM*/
     // Parameters
     .MMCM_SAMP_WAIT			(MMCM_SAMP_WAIT),
     .POC_USE_METASTABLE_SAMP		(POC_USE_METASTABLE_SAMP),
     .SAMPCNTRWIDTH			(SAMPCNTRWIDTH),
     .SMWIDTH				(SMWIDTH),
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_poc_tap_base
    (/*AUTOINST*/
     // Outputs
     .psen				(psen),
     .psincdec				(psincdec),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_polarity			(run_polarity),
     .run_too_small			(run_too_small),
     .samp_cntr				(samp_cntr[SAMPCNTRWIDTH-1:0]),
     .samps_hi				(samps_hi[SAMPCNTRWIDTH:0]),
     .samps_hi_held			(samps_hi_held[SAMPCNTRWIDTH:0]),
     .samps_one				(samps_one),
     .samps_zero			(samps_zero),
     .sm				(sm[SMWIDTH-1:0]),
     .tap				(tap[TAPCNTRWIDTH-1:0]),
     // Inputs
     .clk				(clk),
     .pd_out				(pd_out),
     .poc_sample_pd			(poc_sample_pd),
     .psdone				(psdone),
     .rst				(rst),
     .samples				(samples[SAMPCNTRWIDTH:0]),
     .samps_solid_thresh		(samps_solid_thresh[SAMPCNTRWIDTH:0]));

  mig_7series_v4_2_poc_meta #
    (/*AUTOINSTPARAM*/
     // Parameters
     .SCANFROMRIGHT			(SCANFROMRIGHT),
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_poc_meta
    (/*AUTOINST*/
     // Outputs
     .diff				(diff[TAPCNTRWIDTH+1:0]),
     .edge_center			(edge_center[TAPCNTRWIDTH:0]),
     .left				(left[TAPCNTRWIDTH-1:0]),
     .mmcm_edge_detect_done		(mmcm_edge_detect_done),
     .mmcm_lbclk_edge_aligned		(mmcm_lbclk_edge_aligned),
     .poc_backup			(poc_backup),
     .right				(right[TAPCNTRWIDTH-1:0]),
     .run_ends				(run_ends[1:0]),
     .window_center			(window_center[TAPCNTRWIDTH:0]),
     // Inputs
     .clk				(clk),
     .ktap_at_left_edge			(ktap_at_left_edge),
     .ktap_at_right_edge		(ktap_at_right_edge),
     .mmcm_edge_detect_rdy		(mmcm_edge_detect_rdy),
     .ninety_offsets			(ninety_offsets[1:0]),
     .rise_lead_center			(rise_lead_center[TAPCNTRWIDTH-1:0]),
     .rise_lead_left			(rise_lead_left[TAPCNTRWIDTH-1:0]),
     .rise_lead_right			(rise_lead_right[TAPCNTRWIDTH-1:0]),
     .rise_trail_center			(rise_trail_center[TAPCNTRWIDTH-1:0]),
     .rise_trail_left			(rise_trail_left[TAPCNTRWIDTH-1:0]),
     .rise_trail_right			(rise_trail_right[TAPCNTRWIDTH-1:0]),
     .rst				(rst),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_polarity			(run_polarity),
     .run_too_small			(run_too_small),
     .use_noise_window			(use_noise_window));

  /*mig_7series_v4_2_poc_edge_store AUTO_TEMPLATE "edge_\(.*\)$" (
   .\(.*\)lead                          (\1lead_@@"vl-bits"),
   .\(.*\)trail                         (\1trail_@@"vl-bits"),
   .select0                             (ktap_at_@_edge),
   .select1                             (1'b1),)*/
  
  mig_7series_v4_2_poc_edge_store #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_edge_right
    (/*AUTOINST*/
     // Outputs
     .fall_lead				(fall_lead_right[TAPCNTRWIDTH-1:0]), // Templated
     .fall_trail			(fall_trail_right[TAPCNTRWIDTH-1:0]), // Templated
     .rise_lead				(rise_lead_right[TAPCNTRWIDTH-1:0]), // Templated
     .rise_trail			(rise_trail_right[TAPCNTRWIDTH-1:0]), // Templated
     // Inputs
     .clk				(clk),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_polarity			(run_polarity),
     .select0				(ktap_at_right_edge),	 // Templated
     .select1				(1'b1),			 // Templated
     .tap				(tap[TAPCNTRWIDTH-1:0]));

  mig_7series_v4_2_poc_edge_store #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_edge_left
    (/*AUTOINST*/
     // Outputs
     .fall_lead				(fall_lead_left[TAPCNTRWIDTH-1:0]), // Templated
     .fall_trail			(fall_trail_left[TAPCNTRWIDTH-1:0]), // Templated
     .rise_lead				(rise_lead_left[TAPCNTRWIDTH-1:0]), // Templated
     .rise_trail			(rise_trail_left[TAPCNTRWIDTH-1:0]), // Templated
     // Inputs
     .clk				(clk),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_polarity			(run_polarity),
     .select0				(ktap_at_left_edge),	 // Templated
     .select1				(1'b1),			 // Templated
     .tap				(tap[TAPCNTRWIDTH-1:0]));

  wire not_ktap_at_right_edge = ~ktap_at_right_edge;
  wire not_ktap_at_left_edge = ~ktap_at_left_edge;
  /*mig_7series_v4_2_poc_edge_store AUTO_TEMPLATE "edge_\(.*\)$" (
   .\(.*\)lead                          (\1lead_@@"vl-bits"),
   .\(.*\)trail                         (\1trail_@@"vl-bits"),
   .select0                             (not_ktap_at_right_edge),
   .select1                             (not_ktap_at_left_edge),)*/

  mig_7series_v4_2_poc_edge_store #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_edge_center
    (/*AUTOINST*/
     // Outputs
     .fall_lead				(fall_lead_center[TAPCNTRWIDTH-1:0]), // Templated
     .fall_trail			(fall_trail_center[TAPCNTRWIDTH-1:0]), // Templated
     .rise_lead				(rise_lead_center[TAPCNTRWIDTH-1:0]), // Templated
     .rise_trail			(rise_trail_center[TAPCNTRWIDTH-1:0]), // Templated
     // Inputs
     .clk				(clk),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_polarity			(run_polarity),
     .select0				(not_ktap_at_right_edge), // Templated
     .select1				(not_ktap_at_left_edge), // Templated
     .tap				(tap[TAPCNTRWIDTH-1:0]));

  mig_7series_v4_2_poc_cc #
    (/*AUTOINSTPARAM*/
     // Parameters
     .CCENABLE				(CCENABLE),
     .LANE_CNT_WIDTH			(LANE_CNT_WIDTH),
     .PCT_SAMPS_SOLID			(PCT_SAMPS_SOLID),
     .SAMPCNTRWIDTH			(SAMPCNTRWIDTH),
     .SAMPLES				(SAMPLES),
     .SMWIDTH				(SMWIDTH),
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TCQ				(TCQ))
  u_poc_cc
    (/*AUTOINST*/
     // Outputs
     .dbg_poc				(dbg_poc[1023:0]),
     .poc_error				(poc_error),
     .samples				(samples[SAMPCNTRWIDTH:0]),
     .samps_solid_thresh		(samps_solid_thresh[SAMPCNTRWIDTH:0]),
     // Inputs
     .clk				(clk),
     .diff				(diff[TAPCNTRWIDTH+1:0]),
     .edge_center			(edge_center[TAPCNTRWIDTH:0]),
     .fall_lead_center			(fall_lead_center[TAPCNTRWIDTH-1:0]),
     .fall_lead_left			(fall_lead_left[TAPCNTRWIDTH-1:0]),
     .fall_lead_right			(fall_lead_right[TAPCNTRWIDTH-1:0]),
     .fall_trail_center			(fall_trail_center[TAPCNTRWIDTH-1:0]),
     .fall_trail_left			(fall_trail_left[TAPCNTRWIDTH-1:0]),
     .fall_trail_right			(fall_trail_right[TAPCNTRWIDTH-1:0]),
     .ktap_at_left_edge			(ktap_at_left_edge),
     .ktap_at_right_edge		(ktap_at_right_edge),
     .lane				(lane[LANE_CNT_WIDTH-1:0]),
     .left				(left[TAPCNTRWIDTH-1:0]),
     .mmcm_edge_detect_done		(mmcm_edge_detect_done),
     .mmcm_edge_detect_rdy		(mmcm_edge_detect_rdy),
     .mmcm_lbclk_edge_aligned		(mmcm_lbclk_edge_aligned),
     .poc_backup			(poc_backup),
     .psen				(psen),
     .right				(right[TAPCNTRWIDTH-1:0]),
     .rise_lead_center			(rise_lead_center[TAPCNTRWIDTH-1:0]),
     .rise_lead_left			(rise_lead_left[TAPCNTRWIDTH-1:0]),
     .rise_lead_right			(rise_lead_right[TAPCNTRWIDTH-1:0]),
     .rise_trail_center			(rise_trail_center[TAPCNTRWIDTH-1:0]),
     .rise_trail_left			(rise_trail_left[TAPCNTRWIDTH-1:0]),
     .rise_trail_right			(rise_trail_right[TAPCNTRWIDTH-1:0]),
     .rst				(rst),
     .run				(run[TAPCNTRWIDTH-1:0]),
     .run_end				(run_end),
     .run_ends				(run_ends[1:0]),
     .run_polarity			(run_polarity),
     .run_too_small			(run_too_small),
     .samp_cntr				(samp_cntr[SAMPCNTRWIDTH-1:0]),
     .samps_hi				(samps_hi[SAMPCNTRWIDTH:0]),
     .samps_hi_held			(samps_hi_held[SAMPCNTRWIDTH:0]),
     .samps_one				(samps_one),
     .samps_zero			(samps_zero),
     .sm				(sm[SMWIDTH-1:0]),
     .tap				(tap[TAPCNTRWIDTH-1:0]),
     .window_center			(window_center[TAPCNTRWIDTH:0]));

endmodule // mig_7series_v4_2_poc_top

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-extensions:(".v")
// End:

