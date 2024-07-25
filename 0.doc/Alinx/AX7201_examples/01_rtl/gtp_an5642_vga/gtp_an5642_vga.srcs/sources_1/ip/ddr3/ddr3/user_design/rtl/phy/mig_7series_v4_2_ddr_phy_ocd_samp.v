//*****************************************************************************
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
// \   \   \/     Version: %version
//  \   \         Application: MIG
//  /   /         Filename: ddr_phy_v4_0_phy_ocd_samp.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Controls the number of samples and generates an aggregate
//sampling result.
//
// The following shows the nesting of the sampling loop.  Nominally built
// to accomodate the "complex" sampling protocol.  Adapted for use with
// "simple" samplng.
//
//                    simple                    complex
//                                 
// samples            OCAL_SIMPLE_SCAN_SAMPS    1 or 50 Depends on SIM_CAL_OPTION
//   rd_victim_sel    0                         0 to 7
//     data_cnt       1                         157
//
// First it collects comparison results provided on the
// two bit "match" bus.  A particular phaser tap setting may be recorded one
// or many times depending on various parameter settings.  
// The two bit match bus corresponds to comparisons for the
// zero or rising phase, and the oneeighty or falling phase.  The "aggregate"
// starts out as NULL and then begins collecting comparison results
// when phy_rddata_en_1 is high.  The first result is always set into
// the aggregate result.  Subsequent results that match aggregate, don't
// make any change.  Subsequent compare results that don't match cause the aggregate
// to turn to FUZZ.
//
// A "sample" is defined as a single DRAM burst for the simple step, and
// an entire 157 DRAM data bursts across the 8 victim bits for complex.
//
// Once all samples have been taken, the samp_result is computed by
// comparing the number of successful compares against the threshold.
//
// The second function is to track and control the number of samples.  For 
// "simple" data, the number of samples is set by OCAL_SIMPLE_SCAN_SAMPS.  
// For "complex" data, nominally
// the complex data pattern consists of a sequence of 157 DRAM chunks.  This
// sequence is run with each bit in the byte designated as the "victim".  This sequence
// is repeated 50 times, although when SIM_CAL_OPTION is set to none "NONE", it is only
// repeated once.
//
// This block generates oclk_calib_resume.  For the simple pattern, a single DRAM
// burst is returned  For complex its 157  which indicates the start of the 157*50
// sequence for a bit.  samp_done is pulsed.
//
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ocd_samp #
  (parameter nCK_PER_CLK             = 4,
   parameter OCAL_SIMPLE_SCAN_SAMPS  = 2,
   parameter SCAN_PCT_SAMPS_SOLID    = 95,
   parameter TCQ                     = 100,
   parameter SIM_CAL_OPTION          = "NONE")
  (/*AUTOARG*/
  // Outputs
  samp_done, oclk_calib_resume, rd_victim_sel, samp_result,
  // Inputs
  complex_oclkdelay_calib_start, clk, rst, reset_scan,
  ocal_num_samples_inc, match, phy_rddata_en_1, taps_set,
  phy_rddata_en_2
  );

  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2

  localparam ONE = 1;

  localparam CMPLX_DATA_CNT = nCK_PER_CLK == 2 ? 157 * 2 : 157;
  localparam SIMP_DATA_CNT = nCK_PER_CLK == 2 ? 2 : 1;

  localparam DATA_CNT_WIDTH = nCK_PER_CLK == 2 ? 9 : 8;

  localparam CMPLX_SAMPS = SIM_CAL_OPTION == "NONE" ? 50 : 1;
 
  // Plus one because were counting in natural numbers. 
  localparam SAMP_CNT_WIDTH = clogb2(OCAL_SIMPLE_SCAN_SAMPS > CMPLX_SAMPS 
                                       ? OCAL_SIMPLE_SCAN_SAMPS : CMPLX_SAMPS) + 1;

  // Remember SAMPLES is natural number counting.  One corresponds to one sample.
  localparam integer SIMP_SAMPS_SOLID_THRESH = OCAL_SIMPLE_SCAN_SAMPS * SCAN_PCT_SAMPS_SOLID * 0.01;
  localparam integer SIMP_SAMPS_HALF_THRESH = SIMP_SAMPS_SOLID_THRESH/2;
  localparam integer CMPLX_SAMPS_SOLID_THRESH = CMPLX_SAMPS * SCAN_PCT_SAMPS_SOLID * 0.01;
  localparam integer CMPLX_SAMPS_HALF_THRESH = CMPLX_SAMPS_SOLID_THRESH/2;

  input complex_oclkdelay_calib_start;
  
  wire [SAMP_CNT_WIDTH-1:0] samples =  complex_oclkdelay_calib_start
			                 ? CMPLX_SAMPS[SAMP_CNT_WIDTH-1:0]	       
                                         : OCAL_SIMPLE_SCAN_SAMPS[SAMP_CNT_WIDTH-1:0];
  
  localparam [1:0] NULL       = 2'b11,
                   FUZZ       = 2'b00,
                   ONEEIGHTY  = 2'b10,
                   ZERO       = 2'b01;
 
  input clk;
  input rst;

  input reset_scan;

  // Given the need to count phy_data_en, this is not useful.
  input ocal_num_samples_inc;
  
  input [1:0] match;

  input phy_rddata_en_1;
  
  input taps_set;

  reg samp_done_ns, samp_done_r;
  always @(posedge clk) samp_done_r <= #TCQ samp_done_ns;
  output samp_done;
  assign samp_done = samp_done_r;

  input phy_rddata_en_2;
  wire samp_valid = samp_done_r && phy_rddata_en_2;

  reg [1:0] agg_samp_ns, agg_samp_r;
  always @(posedge clk) agg_samp_r <= #TCQ agg_samp_ns;

  reg oclk_calib_resume_ns, oclk_calib_resume_r;
  always @(posedge clk) oclk_calib_resume_r <= #TCQ oclk_calib_resume_ns;
  output oclk_calib_resume;
  assign oclk_calib_resume = oclk_calib_resume_r;

  // Complex data counting.
  // Inner most loop.  157 phy_data_en.
  reg [DATA_CNT_WIDTH-1:0] data_cnt_ns, data_cnt_r;
  always @(posedge clk) data_cnt_r <= #TCQ data_cnt_ns;

  // Nominally, 50 samples of the above 157 phy_data_en.
  reg [SAMP_CNT_WIDTH-1:0] samps_ns, samps_r;
  always @(posedge clk) samps_r <= #TCQ samps_ns;

  // Step through the 8 bits in the byte.
  reg [2:0] rd_victim_sel_ns, rd_victim_sel_r;
  always @(posedge clk) rd_victim_sel_r <= #TCQ rd_victim_sel_ns;
  output [2:0] rd_victim_sel;
  assign rd_victim_sel = rd_victim_sel_r;

  reg [SAMP_CNT_WIDTH-1:0] zero_ns, zero_r, oneeighty_ns, oneeighty_r;
  always @(posedge clk) zero_r <= #TCQ zero_ns;
  always @(posedge clk) oneeighty_r <= #TCQ oneeighty_ns;

  wire [SAMP_CNT_WIDTH-1:0] samp_thresh = (complex_oclkdelay_calib_start 
                                            ? CMPLX_SAMPS_SOLID_THRESH[SAMP_CNT_WIDTH-1:0]
                                            : SIMP_SAMPS_SOLID_THRESH[SAMP_CNT_WIDTH-1:0]);

  wire [SAMP_CNT_WIDTH-1:0] samp_half_thresh = (complex_oclkdelay_calib_start 
                                                 ? CMPLX_SAMPS_HALF_THRESH[SAMP_CNT_WIDTH-1:0]
                                                 : SIMP_SAMPS_HALF_THRESH[SAMP_CNT_WIDTH-1:0]);

  wire zero_ge_thresh = zero_r >= samp_thresh;
  wire zero_le_half_thresh =  zero_r <= samp_half_thresh;
  wire oneeighty_ge_thresh = oneeighty_r >= samp_thresh;
  wire oneeighty_le_half_thresh = oneeighty_r <= samp_half_thresh;
  
  reg [1:0] samp_result_ns, samp_result_r;
  always @(posedge clk) samp_result_r <= #TCQ samp_result_ns;
  always @(*) 
    if (rst) samp_result_ns = 'b0;
    else begin
      samp_result_ns = samp_result_r;
      if (samp_valid) begin
	if (~samp_result_r[0] && zero_ge_thresh) samp_result_ns[0] = 'b1;
        if (samp_result_r[0] && zero_le_half_thresh) samp_result_ns[0] = 'b0;
	if (~samp_result_r[1] && oneeighty_ge_thresh) samp_result_ns[1] = 'b1;
        if (samp_result_r[1] && oneeighty_le_half_thresh) samp_result_ns[1] = 'b0;
      end
    end
  
  output [1:0] samp_result;
  assign samp_result = samp_result_ns;

  reg [0:0] sm_ns, sm_r;
  always @(posedge clk) sm_r <= #TCQ sm_ns;

  wire [DATA_CNT_WIDTH-1:0] data_cnt = complex_oclkdelay_calib_start 
                                         ? CMPLX_DATA_CNT[DATA_CNT_WIDTH-1:0] 
                                         : SIMP_DATA_CNT[DATA_CNT_WIDTH-1:0];
  wire [2:0] rd_victim_end = complex_oclkdelay_calib_start ? 3'h7 : 3'h0;
  wire data_end = data_cnt_r == ONE[DATA_CNT_WIDTH-1:0];
  wire samp_end = samps_r == ONE[SAMP_CNT_WIDTH-1:0];
  
  // Primary state machine.
  
  always @(*) begin

  // Default next state assignments.

    agg_samp_ns = agg_samp_r;
    data_cnt_ns = data_cnt_r;
    oclk_calib_resume_ns = 1'b0;
    oneeighty_ns = oneeighty_r;
    rd_victim_sel_ns = rd_victim_sel_r;
    samp_done_ns = samp_done_r;
    samps_ns = samps_r;
    sm_ns = sm_r;
    zero_ns = zero_r;
    
    if (rst == 1'b1) begin
  // RESET next states
      sm_ns = /*AK("READY")*/1'd0;
      
    end else
      
  // State based actions and next states. 
      case (sm_r)

        /*AL("READY")*/1'd0:begin
	  agg_samp_ns = NULL;
	  data_cnt_ns = data_cnt;
	  oneeighty_ns = 'b0;
	  zero_ns = 'b0;
	  rd_victim_sel_ns = 3'b0;
	  samps_ns = complex_oclkdelay_calib_start ? CMPLX_SAMPS[SAMP_CNT_WIDTH-1:0]
                                                   : OCAL_SIMPLE_SCAN_SAMPS[SAMP_CNT_WIDTH-1:0];
	 
	  
	  if (taps_set) begin
	    samp_done_ns = 1'b0;
	    sm_ns = /*AK("AWAITING_DATA")*/1'd1;
	    oclk_calib_resume_ns = 1'b1;
	  end
        end

        /*AL("AWAITING_DATA")*/1'd1:begin
	  if (phy_rddata_en_1) begin

	    case (agg_samp_r)
	      NULL : if (~&match) agg_samp_ns = match;
	      ZERO, ONEEIGHTY : if (~(agg_samp_r == match || &match)) agg_samp_ns = FUZZ;
	      FUZZ : ;
	    endcase // case (agg_samp_r)

	    if (~data_end) data_cnt_ns = data_cnt_r - ONE[DATA_CNT_WIDTH-1:0];
	    else begin
	      data_cnt_ns = data_cnt;
	      if (rd_victim_end != rd_victim_sel_r) rd_victim_sel_ns = rd_victim_sel_r + 3'h1;
	      else begin
		rd_victim_sel_ns = 3'h0;
		if (agg_samp_ns == ZERO) zero_ns = zero_r + ONE[SAMP_CNT_WIDTH-1:0];
	        if (agg_samp_ns == ONEEIGHTY) oneeighty_ns = oneeighty_r + ONE[SAMP_CNT_WIDTH-1:0];
		agg_samp_ns = NULL;
		if (~samp_end) samps_ns = samps_r - ONE[SAMP_CNT_WIDTH-1:0];
		else samp_done_ns = 1'b1;
	      end
	    end
    
      	    if (samp_done_ns) sm_ns = /*AK("READY")*/1'd0;
	    else oclk_calib_resume_ns = ~complex_oclkdelay_calib_start && data_end;
	  end
	end
	
      endcase // case (sm_r)
  end // always @ begin
  
   
endmodule // mig_7series_v4_2_ddr_phy_ocd_samp

// Local Variables:
// verilog-autolabel-prefix: "1'd"
// End:

