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
//  /   /         Filename: mig_7series_v4_2_poc_tap_base.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Tue 15 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: All your taps are belong to us.
//
//In general, this block should be able to start up with a random initialization of
//the various counters.  But its probably easier, more normative and quicker time to solution
//to just initialize to zero with rst.
//
// Following deassertion of reset, endlessly increments the MMCM delay with PSEN.  For
// each MMCM tap it samples the phase detector output a programmable number of times.  
// When the sampling count is achieved, PSEN is pulsed and sampling of the next MMCM
// tap begins.
//
// Following a PSEN, sampling pauses for MMCM_SAMP_WAIT clocks.  This is workaround
// for a bug in the MMCM where its output may have noise for a period following
// the PSEN.
//
// Samples are taken every other fabric clock.  This is because the MMCM phase shift
// clock operates at half the fabric clock.  The reason for this is unknown.
//
// At the end of the sampling period, a filtering step is implemented.  samps_solid_thresh
// is the minumum number of samples that must be seen to declare a solid zero or one.  If
// neithr the one and zero samples cross this threshold, then the sampple is declared fuzz.
//
// A "run_polarity" bit is maintained. It is set appropriately whenever a solid sample
// is observed.
//
// A "run" counter is maintained.  If the current sample is fuzz, or opposite polarity
// from a previous sample, then the run counter is reset.  If the current sample is the
// same polarity run_polarity, then the run counter is incremented.
//
// If a run_polarity reversal or fuzz is observed and the run counter is not zero
// then the run_end strobe is pulsed.
// 
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_tap_base #
  (parameter MMCM_SAMP_WAIT             = 10,
   parameter POC_USE_METASTABLE_SAMP    = "FALSE",
   parameter TCQ                        = 100,
   parameter SAMPCNTRWIDTH              = 8,
   parameter SMWIDTH                    = 2,
   parameter TAPCNTRWIDTH               = 7,
   parameter TAPSPERKCLK                = 112)
  (/*AUTOARG*/
  // Outputs
  psincdec, psen, run, run_end, run_too_small, run_polarity,
  samp_cntr, samps_hi, samps_hi_held, tap, sm, samps_zero, samps_one,
  // Inputs
  pd_out, clk, samples, samps_solid_thresh, psdone, rst,
  poc_sample_pd
  );

  
  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2
  
  input pd_out;
  input clk;
  input [SAMPCNTRWIDTH:0] samples, samps_solid_thresh;
  input psdone;
  input rst;

  localparam ONE = 1;

  localparam SAMP_WAIT_WIDTH = clogb2(MMCM_SAMP_WAIT);
  reg [SAMP_WAIT_WIDTH-1:0] samp_wait_ns, samp_wait_r;
  always @(posedge clk) samp_wait_r <= #TCQ samp_wait_ns;

  reg pd_out_r;
  always @(posedge clk) pd_out_r <= #TCQ pd_out;
  wire pd_out_sel = POC_USE_METASTABLE_SAMP == "TRUE" ? pd_out_r : pd_out;

  output psincdec;
  assign psincdec = 1'b1;
  output psen;
  reg psen_int;
  assign psen = psen_int;
 
  reg [TAPCNTRWIDTH-1:0] run_r;
   reg [TAPCNTRWIDTH-1:0] run_ns;
  always @(posedge clk) run_r <= #TCQ run_ns;
  output [TAPCNTRWIDTH-1:0] run;
  assign run = run_r;

  output run_end;
  reg run_end_int;
  assign run_end = run_end_int;

  output run_too_small;
  reg run_too_small_r, run_too_small_ns;
  always @(*) run_too_small_ns = run_end && (run <  TAPSPERKCLK/4);
  always @(posedge clk) run_too_small_r <= #TCQ run_too_small_ns;
  assign run_too_small = run_too_small_r;
  
  reg run_polarity_r;
  reg run_polarity_ns;
  always @(posedge clk) run_polarity_r <= #TCQ run_polarity_ns;
  output run_polarity;
  assign run_polarity = run_polarity_r;

  reg [SAMPCNTRWIDTH-1:0] samp_cntr_r;
  reg [SAMPCNTRWIDTH-1:0] samp_cntr_ns;
  always @(posedge clk) samp_cntr_r <= #TCQ samp_cntr_ns;
  output [SAMPCNTRWIDTH-1:0] samp_cntr;
  assign samp_cntr = samp_cntr_r;

  reg [SAMPCNTRWIDTH:0] samps_hi_r;
  reg [SAMPCNTRWIDTH:0] samps_hi_ns;
  always @(posedge clk) samps_hi_r <= #TCQ samps_hi_ns;
  output [SAMPCNTRWIDTH:0] samps_hi;
  assign samps_hi = samps_hi_r;

  reg [SAMPCNTRWIDTH:0] samps_hi_held_r;
  reg [SAMPCNTRWIDTH:0] samps_hi_held_ns;
  always @(posedge clk) samps_hi_held_r <= #TCQ samps_hi_held_ns;
  output [SAMPCNTRWIDTH:0] samps_hi_held;
  assign samps_hi_held = samps_hi_held_r;

  reg [TAPCNTRWIDTH-1:0] tap_ns, tap_r;
  always @(posedge clk) tap_r <= #TCQ tap_ns;
  output [TAPCNTRWIDTH-1:0] tap;
  assign tap = tap_r;
  
  reg [SMWIDTH-1:0] sm_ns;
  reg [SMWIDTH-1:0] sm_r;
  always @(posedge clk) sm_r <= #TCQ sm_ns;
  output [SMWIDTH-1:0] sm;
  assign sm = sm_r;

  reg samps_zero_ns, samps_zero_r, samps_one_ns, samps_one_r;
  always @(posedge clk) samps_zero_r <= #TCQ samps_zero_ns;
  always @(posedge clk) samps_one_r <= #TCQ samps_one_ns;
  output samps_zero, samps_one;
  assign samps_zero = samps_zero_r;
  assign samps_one = samps_one_r;

  // Interesting corner case... what if both samps_zero and samps_one are
  // hi?  Could happen for small sample counts and reasonable values of
  // PCT_SAMPS_SOLID.  Doesn't affect samps_solid.  run_polarity assignment
  // consistently breaks tie with samps_one_r.
  wire [SAMPCNTRWIDTH:0] samps_lo = samples + ONE[SAMPCNTRWIDTH:0] - samps_hi_r;
  always @(*) begin
    samps_zero_ns = samps_zero_r;
    samps_one_ns = samps_one_r;
    samps_zero_ns = samps_lo >= samps_solid_thresh;
    samps_one_ns = samps_hi_r >= samps_solid_thresh;
  end // always @ begin
  wire new_polarity = run_polarity_ns ^ run_polarity_r;

  input poc_sample_pd;

  always @(*) begin
    
    if (rst == 1'b1) begin
      
 // RESET next states
      psen_int = 1'b0;
      sm_ns = /*AUTOLINK("SAMPLE")*/2'd0;
      run_polarity_ns = 1'b0;
      run_ns = {TAPCNTRWIDTH{1'b0}};
      run_end_int = 1'b0;
      samp_cntr_ns = {SAMPCNTRWIDTH{1'b0}};
      samps_hi_ns = {SAMPCNTRWIDTH+1{1'b0}};
      tap_ns = {TAPCNTRWIDTH{1'b0}};
      samp_wait_ns = MMCM_SAMP_WAIT[SAMP_WAIT_WIDTH-1:0];
      samps_hi_held_ns = {SAMPCNTRWIDTH+1{1'b0}};
    end else begin

 // Default next states;
      psen_int = 1'b0;
      sm_ns = sm_r;
      run_polarity_ns = run_polarity_r;
      run_ns = run_r;
      run_end_int = 1'b0;
      samp_cntr_ns = samp_cntr_r;
      samps_hi_ns = samps_hi_r;
      tap_ns = tap_r;
      samp_wait_ns = samp_wait_r;
      if (|samp_wait_r) samp_wait_ns = samp_wait_r - ONE[SAMP_WAIT_WIDTH-1:0];
      samps_hi_held_ns = samps_hi_held_r;

// State based actions and next states. 
      case (sm_r)
        /*AL("SAMPLE")*/2'd0: begin
	  if (~|samp_wait_r && poc_sample_pd | POC_USE_METASTABLE_SAMP == "TRUE") begin
	    if (POC_USE_METASTABLE_SAMP == "TRUE") samp_wait_ns = ONE[SAMP_WAIT_WIDTH-1:0];
	    if ({1'b0, samp_cntr_r} == samples) sm_ns = /*AK("COMPUTE")*/2'd1;
	    samps_hi_ns = samps_hi_r + {{SAMPCNTRWIDTH{1'b0}}, pd_out_sel};
	    samp_cntr_ns = samp_cntr_r + ONE[SAMPCNTRWIDTH-1:0];
	  end
        end
	
	/*AL("COMPUTE")*/2'd1:begin
	   sm_ns = /*AK("PSEN")*/2'd2;
        end

        /*AL("PSEN")*/2'd2:begin
	  sm_ns = /*AK("PSDONE_WAIT")*/2'd3;
	  psen_int = 1'b1;
	  samp_cntr_ns = {SAMPCNTRWIDTH{1'b0}};
	  samps_hi_ns = {SAMPCNTRWIDTH+1{1'b0}};
	  samps_hi_held_ns = samps_hi_r;
	  tap_ns = (tap_r < TAPSPERKCLK[TAPCNTRWIDTH-1:0] - ONE[TAPCNTRWIDTH-1:0])
	             ? tap_r + ONE[TAPCNTRWIDTH-1:0]
		     : {TAPCNTRWIDTH{1'b0}};

	  if (run_polarity_r) begin
	    if (samps_zero_r) run_polarity_ns = 1'b0;
	  end else begin
	    if (samps_one_r) run_polarity_ns = 1'b1;
	  end
	  if (new_polarity) begin
            run_ns ={TAPCNTRWIDTH{1'b0}};
	    run_end_int = 1'b1;
	  end else run_ns = run_r + ONE[TAPCNTRWIDTH-1:0];
        end

        /*AL("PSDONE_WAIT")*/2'd3:begin
	  samp_wait_ns = MMCM_SAMP_WAIT[SAMP_WAIT_WIDTH-1:0] - ONE[SAMP_WAIT_WIDTH-1:0];
	  if (psdone) sm_ns = /*AK("SAMPLE")*/2'd0;
        end
	
      endcase // case (sm_r)
    end // else: !if(rst == 1'b1)
  end // always @ (*)

endmodule // mig_7series_v4_2_poc_tap_base

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-extensions:(".v")
// verilog-autolabel-prefix: "2'd"
// End:

