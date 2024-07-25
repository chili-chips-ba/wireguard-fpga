
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
//  /   /         Filename: ddr_phy_v4_0_phy_ocd_po_cntlr.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Manipulates phaser out stg2f and stg3 on behalf of
// scan and DQS centering.
//
// Maintains a shadow of the phaser out stg2f and stg3 tap settings.
// The stg3 shadow is 6 bits, just like the phaser out.  stg2f is
// 8 bits.  This allows the po_cntlr to track how far past the stg2f
// saturation points we have gone when stepping to the limits of stg3.
// This way we're can stay in sync when we step back from the saturation
// limits.
//
// Looks at the edge values and determines which case has been
// detected by the scan.  Uses the results to drive the centering.
//
// Main state machine waits until it sees reset_scan go to zero.  While
// waiting it is writing the initialzation values to the stg2 and stg3
// shadows.  When reset_scan goes low, taps_set is pulsed.  This
// tells the sampling block to begin sampling.  When the sampling
// block has finished sampling this setting of the phaser out taps,
// is signals by setting samp_done.  When the main state machine
// sees samp_done it sets the next value in the phaser out and
// waits for the phaser out to be ready before beginning the next
// sample.
//
// Turns out phy_init is sensitive to the length of the ocal_num_samples_done
// pulse.  Something like a precharge and activate time.  Added feature
// to resume_wait to wait at least 32 cycles between assertion and
// subsequent deassertion of ocal_num_samples_done.
//
// Also turns out phy_init needs help to get into consistent
// starting state for complex cal.  This can be done by preseting
// ocal_num_samples_done to one.  Then waiting for 32 fabric clocks,
// turn off _done and then assert _resume.
//
// Scanning algorithm.
//
// Phaser manipulation algoritm.
// 
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ocd_po_cntlr #
  (parameter DQS_CNT_WIDTH       = 3,
   parameter DQS_WIDTH           = 8,
   parameter nCK_PER_CLK         = 4,
   parameter SAMPLES             = 128,
   parameter TCQ                 = 100)
  (/*AUTOARG*/
  // Outputs
  scan_done, ocal_num_samples_done_r, oclkdelay_center_calib_start,
  oclkdelay_center_calib_done, oclk_center_write_resume, ocd2stg2_inc,
  ocd2stg2_dec, ocd2stg3_inc, ocd2stg3_dec, stg3, simp_stg3_final,
  cmplx_stg3_final, simp_stg3_final_sel, ninety_offsets,
  scanning_right, ocd_ktap_left, ocd_ktap_right, ocd_edge_detect_rdy,
  taps_set, use_noise_window, ocal_scan_win_not_found,
  // Inputs
  clk, rst, reset_scan, oclkdelay_init_val, lim2ocal_stg3_right_lim,
  lim2ocal_stg3_left_lim, complex_oclkdelay_calib_start,
  po_counter_read_val, oclkdelay_calib_cnt, mmcm_edge_detect_done,
  mmcm_lbclk_edge_aligned, poc_backup, phy_rddata_en_3, zero2fuzz,
  fuzz2zero, oneeighty2fuzz, fuzz2oneeighty, z2f, f2z, o2f, f2o,
  scan_right, samp_done, wl_po_fine_cnt_sel, po_rdy
  );

  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2
 
  input clk;
  input rst;
 
  input reset_scan;
  reg scan_done_r;
  output scan_done;
  assign scan_done = scan_done_r;
  output [5:0] simp_stg3_final_sel;

  reg cmplx_samples_done_ns, cmplx_samples_done_r;
  always @(posedge clk) cmplx_samples_done_r <= #TCQ cmplx_samples_done_ns;
  output ocal_num_samples_done_r;
  assign ocal_num_samples_done_r = cmplx_samples_done_r;

  // Write Level signals during OCLKDELAY calibration
  input [5:0] oclkdelay_init_val;
  input [5:0] lim2ocal_stg3_right_lim;
  input [5:0] lim2ocal_stg3_left_lim;

  input complex_oclkdelay_calib_start;

  reg oclkdelay_center_calib_start_ns, oclkdelay_center_calib_start_r;
  always @(posedge clk) oclkdelay_center_calib_start_r <= #TCQ oclkdelay_center_calib_start_ns;
  output oclkdelay_center_calib_start;
  assign oclkdelay_center_calib_start = oclkdelay_center_calib_start_r;

  reg oclkdelay_center_calib_done_ns, oclkdelay_center_calib_done_r;
  always @(posedge clk) oclkdelay_center_calib_done_r <= #TCQ oclkdelay_center_calib_done_ns;
  output oclkdelay_center_calib_done;
  assign oclkdelay_center_calib_done = oclkdelay_center_calib_done_r;

  reg oclk_center_write_resume_ns, oclk_center_write_resume_r;
  always @(posedge clk) oclk_center_write_resume_r <= #TCQ oclk_center_write_resume_ns;
  output oclk_center_write_resume;
  assign oclk_center_write_resume = oclk_center_write_resume_r;

  reg ocd2stg2_inc_r, ocd2stg2_dec_r, ocd2stg3_inc_r, ocd2stg3_dec_r;
  output ocd2stg2_inc, ocd2stg2_dec, ocd2stg3_inc, ocd2stg3_dec;
  assign ocd2stg2_inc = ocd2stg2_inc_r;
  assign ocd2stg2_dec = ocd2stg2_dec_r;
  assign ocd2stg3_inc = ocd2stg3_inc_r;
  assign ocd2stg3_dec = ocd2stg3_dec_r;

  // Remember, two stage 2 steps for every stg 3 step.  And we need a sign bit.
  reg [8:0] stg2_ns, stg2_r;
  always @(posedge clk) stg2_r <= #TCQ stg2_ns;
 
  reg [5:0] stg3_ns, stg3_r;
  always @(posedge clk) stg3_r <= #TCQ stg3_ns;
  output [5:0] stg3;
  assign stg3 = stg3_r;

  input [5:0] wl_po_fine_cnt_sel;
  
  input [8:0] po_counter_read_val;
  reg [5:0] po_counter_read_val_r;
  always @(posedge clk) po_counter_read_val_r <= #TCQ po_counter_read_val[5:0];

  reg [DQS_WIDTH*6-1:0] simp_stg3_final_ns, simp_stg3_final_r, cmplx_stg3_final_ns, cmplx_stg3_final_r;
  always @(posedge clk) simp_stg3_final_r <= #TCQ simp_stg3_final_ns;
  always @(posedge clk) cmplx_stg3_final_r <= #TCQ cmplx_stg3_final_ns;
  output [DQS_WIDTH*6-1:0] simp_stg3_final, cmplx_stg3_final;
  assign simp_stg3_final = simp_stg3_final_r;
  assign cmplx_stg3_final = cmplx_stg3_final_r;
  
  input [DQS_CNT_WIDTH:0] oclkdelay_calib_cnt;
  wire [DQS_WIDTH*6-1:0] simp_stg3_final_shft = simp_stg3_final_r >> oclkdelay_calib_cnt * 6;
  assign simp_stg3_final_sel = simp_stg3_final_shft[5:0];
  wire [5:0] stg3_init = complex_oclkdelay_calib_start ? simp_stg3_final_sel : oclkdelay_init_val;
  
  wire signed [8:0] stg2_steps = stg3_r > stg3_init 
                                   ? -9'sd2 * $signed({3'b0, (stg3_r - stg3_init)})
                                   : 9'sd2 * $signed({3'b0, (stg3_init - stg3_r)});

  wire signed [8:0] stg2_target_ns = $signed({3'b0, wl_po_fine_cnt_sel}) + stg2_steps;
  reg signed [8:0] stg2_target_r;
  always @ (posedge clk) stg2_target_r <= #TCQ stg2_target_ns;

  reg [5:0] stg2_final_ns, stg2_final_r;
  always @(posedge clk) stg2_final_r <= #TCQ stg2_final_ns;
  always @(*) stg2_final_ns = stg2_target_r[8] == 1'b1
	                        ? 6'd0
	                        : stg2_target_r > 9'd63
	                          ? 6'd63
	                          : stg2_target_r[5:0];
						   
  wire final_stg2_inc = stg2_final_r > po_counter_read_val_r;
  wire final_stg2_dec = stg2_final_r < po_counter_read_val_r;
  
  wire left_lim = stg3_r == lim2ocal_stg3_left_lim;
  wire right_lim = stg3_r == lim2ocal_stg3_right_lim;

  reg [1:0] ninety_offsets_ns, ninety_offsets_r;
  always @(posedge clk) ninety_offsets_r <= #TCQ ninety_offsets_ns;
  output [1:0] ninety_offsets;
  assign ninety_offsets = ninety_offsets_r;

  reg scanning_right_ns, scanning_right_r;
  always @(posedge clk) scanning_right_r <= #TCQ scanning_right_ns;
  output scanning_right;
  assign scanning_right = scanning_right_r;

  reg ocd_ktap_left_ns, ocd_ktap_left_r, ocd_ktap_right_ns, ocd_ktap_right_r;
  always @(posedge clk) ocd_ktap_left_r <= #TCQ ocd_ktap_left_ns;
  always @(posedge clk) ocd_ktap_right_r <= #TCQ ocd_ktap_right_ns;
  output ocd_ktap_left, ocd_ktap_right;
  assign ocd_ktap_left = ocd_ktap_left_r;
  assign ocd_ktap_right = ocd_ktap_right_r;

  reg ocd_edge_detect_rdy_ns, ocd_edge_detect_rdy_r;
  always @(posedge clk) ocd_edge_detect_rdy_r <= #TCQ ocd_edge_detect_rdy_ns;
  output ocd_edge_detect_rdy;
  assign ocd_edge_detect_rdy = ocd_edge_detect_rdy_r;
  
  input mmcm_edge_detect_done;
  input mmcm_lbclk_edge_aligned;
  input poc_backup;
  reg poc_backup_ns, poc_backup_r;
  always @(posedge clk) poc_backup_r <= #TCQ poc_backup_ns;

  reg taps_set_r;
  output taps_set;
  assign taps_set = taps_set_r;

  input phy_rddata_en_3;

  input [5:0] zero2fuzz, fuzz2zero, oneeighty2fuzz, fuzz2oneeighty;
  input z2f, f2z, o2f, f2o;

  wire zero = f2z && z2f;
  wire noise = z2f && f2o;
  wire oneeighty = f2o && o2f;

  reg win_not_found;
  reg [1:0] ninety_offsets_final_ns, ninety_offsets_final_r;
  always @(posedge clk) ninety_offsets_final_r <= #TCQ ninety_offsets_final_ns;
  reg [5:0] left, right, current_edge;
  always @(*) begin
    left = lim2ocal_stg3_left_lim;
    right = lim2ocal_stg3_right_lim;
    ninety_offsets_final_ns = 2'd0;
    win_not_found = 1'b0;
    if (zero) begin
      left = fuzz2zero;
      right = zero2fuzz;
    end
    else if (noise) begin
      left = zero2fuzz;
      right = fuzz2oneeighty;
      ninety_offsets_final_ns = 2'd1;
    end
    else if (oneeighty) begin
      left = fuzz2oneeighty;
      right = oneeighty2fuzz;
      ninety_offsets_final_ns = 2'd2;
    end
    else if (z2f) begin
      right = zero2fuzz;
    end
    else if (f2o) begin
      left = fuzz2oneeighty;
      ninety_offsets_final_ns = 2'd2;
    end
    else if (f2z) begin
      left = fuzz2zero;
    end
    else win_not_found = 1'b1;
    current_edge = ocd_ktap_left_r ? left : right;
  end // always @ begin

  output use_noise_window;
  assign use_noise_window = ninety_offsets == 2'd1;

  reg ocal_scan_win_not_found_ns, ocal_scan_win_not_found_r;
  always @(posedge clk) ocal_scan_win_not_found_r <= #TCQ ocal_scan_win_not_found_ns;
  output ocal_scan_win_not_found;
  assign ocal_scan_win_not_found = ocal_scan_win_not_found_r;

  wire inc_po_ns = current_edge > stg3_r;
  wire dec_po_ns = current_edge < stg3_r;
  reg inc_po_r, dec_po_r;
  always @(posedge clk) inc_po_r <= #TCQ inc_po_ns;
  always @(posedge clk) dec_po_r <= #TCQ dec_po_ns;

  input scan_right;
  
  wire left_stop = left_lim || scan_right;
  wire right_stop = right_lim || o2f;

  // POC samples every other fabric clock.
  localparam POC_SAMPLE_CLEAR_WAIT = SAMPLES * 2 > 15 ? SAMPLES * 2 : 15;
  localparam MAX_RESUME_WAIT = POC_SAMPLE_CLEAR_WAIT > 31 ? POC_SAMPLE_CLEAR_WAIT : 31;
  localparam RESUME_WAIT_WIDTH = clogb2(MAX_RESUME_WAIT + 1);

  reg [RESUME_WAIT_WIDTH-1:0] resume_wait_ns, resume_wait_r;
  always @(posedge clk) resume_wait_r <= #TCQ resume_wait_ns;

  wire resume_wait = |resume_wait_r;
  
  reg po_done_ns, po_done_r;
  always @(posedge clk) po_done_r <= #TCQ po_done_ns;
  
  input samp_done;
  
  input po_rdy;
  
  reg up_ns, up_r;
  always @(posedge clk) up_r <= #TCQ up_ns;
  
  reg [1:0] two_ns, two_r;
  always @(posedge clk) two_r <= #TCQ two_ns;

 
/*  wire stg2_zero = ~|stg2_r;
  wire [8:0] stg2_2_zero = stg2_r[8] ? 9'd0 
                                     : stg2_r > 9'd63
                                       ? 9'd63
                                       : stg2_r; */

  reg [3:0] sm_ns, sm_r;
  always @(posedge clk) sm_r <= #TCQ sm_ns;

  reg phy_rddata_en_3_second_ns, phy_rddata_en_3_second_r;
  always @(posedge clk) phy_rddata_en_3_second_r <= #TCQ phy_rddata_en_3_second_ns;
  always @(*) phy_rddata_en_3_second_ns = ~reset_scan && (phy_rddata_en_3 
                                                    ? ~phy_rddata_en_3_second_r 
                                                    : phy_rddata_en_3_second_r);
  wire use_samp_done = nCK_PER_CLK == 2 ? phy_rddata_en_3 && phy_rddata_en_3_second_r : phy_rddata_en_3;

  reg po_center_wait;
  reg po_slew;
  reg po_finish_scan;
  
  always @(*) begin

  // Default next state assignments.

    cmplx_samples_done_ns = cmplx_samples_done_r;
    cmplx_stg3_final_ns = cmplx_stg3_final_r;
    scanning_right_ns = scanning_right_r;
    ninety_offsets_ns = ninety_offsets_r;
    ocal_scan_win_not_found_ns = ocal_scan_win_not_found_r;
    ocd_edge_detect_rdy_ns = ocd_edge_detect_rdy_r;
    ocd_ktap_left_ns = ocd_ktap_left_r;
    ocd_ktap_right_ns = ocd_ktap_right_r;
    ocd2stg2_inc_r = 1'b0;
    ocd2stg2_dec_r = 1'b0;
    ocd2stg3_inc_r = 1'b0;
    ocd2stg3_dec_r = 1'b0;
    oclkdelay_center_calib_start_ns = oclkdelay_center_calib_start_r;
    oclkdelay_center_calib_done_ns = 1'b0;
    oclk_center_write_resume_ns = oclk_center_write_resume_r;
    po_center_wait = 1'b0;
    po_done_ns = po_done_r;
    po_finish_scan = 1'b0;
    po_slew = 1'b0;
    poc_backup_ns = poc_backup_r;
    scan_done_r = 1'b0;
    simp_stg3_final_ns = simp_stg3_final_r;
    sm_ns = sm_r;
    taps_set_r = 1'b0;
    up_ns = up_r;
    stg2_ns = stg2_r;
    stg3_ns = stg3_r;
    two_ns = two_r;
    resume_wait_ns = resume_wait_r;
    
    if (rst == 1'b1) begin
      
  // RESET next states
      cmplx_samples_done_ns = 1'b0;
      ocal_scan_win_not_found_ns = 1'b0;
      ocd_ktap_left_ns = 1'b0;
      ocd_ktap_right_ns = 1'b0;
      ocd_edge_detect_rdy_ns = 1'b0;
      oclk_center_write_resume_ns = 1'b0;
      oclkdelay_center_calib_start_ns = 1'b0;
      po_done_ns = 1'b1;
      resume_wait_ns = 5'd0;
      sm_ns = /*AK("READY")*/4'd0;
      
    end else
      
  // State based actions and next states. 
      case (sm_r)

        /*AL("READY")*/4'd0:begin
	  poc_backup_ns = 1'b0;
	  stg2_ns = {3'b0, wl_po_fine_cnt_sel};
          stg3_ns = stg3_init;
	  scanning_right_ns = 1'b0;
	  if (complex_oclkdelay_calib_start) cmplx_samples_done_ns = 1'b1;
	  if (!reset_scan && ~resume_wait) begin
	    cmplx_samples_done_ns = 1'b0;
	    ocal_scan_win_not_found_ns = 1'b0;
	    taps_set_r = 1'b1;
	    sm_ns = /*AK("SAMPLING")*/4'd1;
	  end
        end

        /*AL("SAMPLING")*/4'd1:begin
	    if (samp_done && use_samp_done) begin
	      if (complex_oclkdelay_calib_start) cmplx_samples_done_ns = 1'b1;
	      scanning_right_ns = scanning_right_r || left_stop;
	      if (right_stop && scanning_right_r) begin
		oclkdelay_center_calib_start_ns = 1'b1;
		ocd_ktap_left_ns = 1'b1;
		ocal_scan_win_not_found_ns = win_not_found;
		sm_ns = /*AK("SLEW_PO")*/4'd3;
	      end else begin
		if (scanning_right_ns) ocd2stg3_inc_r = 1'b1;
		else ocd2stg3_dec_r = 1'b1;
	        sm_ns = /*AK("PO_WAIT")*/4'd2;
	      end
	    end
	end

	/*AL("PO_WAIT")*/4'd2:begin
	    if (po_done_r && ~resume_wait) begin
	      taps_set_r = 1'b1;
	      sm_ns = /*AK("SAMPLING")*/4'd1;
	      cmplx_samples_done_ns = 1'b0;
	    end
	end

	/*AL("SLEW_PO")*/4'd3:begin
	    po_slew = 1'b1;
	    ninety_offsets_ns = |ninety_offsets_final_r ? 2'b01 : 2'b00;
	    if (~resume_wait) begin
	      if (po_done_r) begin
                if (inc_po_r) ocd2stg3_inc_r = 1'b1;
                else if (dec_po_r) ocd2stg3_dec_r = 1'b1;
	        else if (~resume_wait) begin
		  cmplx_samples_done_ns = 1'b0;
                  sm_ns = /*AK("ALIGN_EDGES")*/4'd4;
		  oclk_center_write_resume_ns = 1'b1;
	        end
	      end // if (po_done)
	    end
	end // case: 3'd3

	/*AL("ALIGN_EDGES")*/4'd4:
	    if (~resume_wait) begin 
	      if (mmcm_edge_detect_done) begin
	        ocd_edge_detect_rdy_ns = 1'b0;
      	        if (ocd_ktap_left_r) begin
		  ocd_ktap_left_ns = 1'b0;
		  ocd_ktap_right_ns = 1'b1;
		  oclk_center_write_resume_ns = 1'b0;
	          sm_ns = /*AK("SLEW_PO")*/4'd3;
	         end else if (ocd_ktap_right_r) begin
		   ocd_ktap_right_ns = 1'b0;
		   sm_ns =  /*AK("WAIT_ONE")*/4'd5;
		 end else if (~mmcm_lbclk_edge_aligned) begin
		    sm_ns = /*AK("DQS_STOP_WAIT")*/4'd6;
		    oclk_center_write_resume_ns = 1'b0;  
	         end else begin
                     if (ninety_offsets_r != ninety_offsets_final_r && ocd_edge_detect_rdy_r) begin
                       ninety_offsets_ns = ninety_offsets_r + 2'b01;
		       sm_ns = /*AK("WAIT_ONE")*/4'd5;
		     end else begin
		       oclk_center_write_resume_ns = 1'b0;
		       poc_backup_ns = poc_backup;
//		       stg2_ns = stg2_2_zero;
                       sm_ns = /*AK("FINISH_SCAN")*/4'd8;
	             end
		  end // else: !if(~mmcm_lbclk_edge_aligned)
	      end else ocd_edge_detect_rdy_ns = 1'b1;
	    end // if (~resume_wait)


       /*AL("WAIT_ONE")*/4'd5:
	 sm_ns = /*AK("ALIGN_EDGES")*/4'd4;
	
       /*AL("DQS_STOP_WAIT")*/4'd6:
	 if (~resume_wait) begin
	   ocd2stg3_dec_r = 1'b1;
	   sm_ns = /*AK("CENTER_PO_WAIT")*/4'd7;
	 end

       /*AL("CENTER_PO_WAIT")*/4'd7: begin
	   po_center_wait = 1'b1;    // Kludge to get around limitation of the AUTOs symbols.
           if (po_done_r) begin
             sm_ns = /*AK("ALIGN_EDGES")*/4'd4;	  
             oclk_center_write_resume_ns = 1'b1;
	   end
       end
	   
       /*AL("FINISH_SCAN")*/4'd8: begin
	 po_finish_scan = 1'b1;
	 if (resume_wait_r == 5'd1) begin
           if (~poc_backup_r) begin
             oclkdelay_center_calib_done_ns = 1'b1;
	     oclkdelay_center_calib_start_ns = 1'b0;
	   end
	 end
	 if (~resume_wait) begin
	   if (po_rdy)
	     if (poc_backup_r) begin
               ocd2stg3_inc_r = 1'b1;
	       poc_backup_ns = 1'b0;
	     end 
             else if (~final_stg2_inc && ~final_stg2_dec) begin
	       if (complex_oclkdelay_calib_start) cmplx_stg3_final_ns[oclkdelay_calib_cnt*6+:6] = stg3_r;
	       else simp_stg3_final_ns[oclkdelay_calib_cnt*6+:6] = stg3_r;
	       sm_ns = /*AK("READY")*/4'd0;
	       scan_done_r = 1'b1;
	     end else begin
	       ocd2stg2_inc_r = final_stg2_inc;
	       ocd2stg2_dec_r = final_stg2_dec;
	     end
	 end // if (~resume_wait)
      end // case: 4'd8
	
      endcase // case (sm_r)

    if (ocd2stg3_inc_r) begin
      stg3_ns = stg3_r + 6'h1;
      up_ns = 1'b0;
    end
    if (ocd2stg3_dec_r) begin
      stg3_ns = stg3_r - 6'h1;
      up_ns = 1'b1;
    end
    if (ocd2stg3_inc_r || ocd2stg3_dec_r) begin
      po_done_ns = 1'b0;
      two_ns = 2'b00;
    end

    if (~po_done_r)
      if (po_rdy)
         if (two_r == 2'b10 || po_center_wait || po_slew || po_finish_scan) po_done_ns = 1'b1;
         else begin
	   two_ns = two_r + 2'b1;
           if (up_r) begin
             stg2_ns = stg2_r + 9'b1;
	     if (stg2_r >= 9'd0 && stg2_r < 9'd63) ocd2stg2_inc_r = 1'b1;
	   end else begin
             stg2_ns = stg2_r - 9'b1;
	     if (stg2_r > 9'd0 && stg2_r <= 9'd63) ocd2stg2_dec_r = 1'b1;
	   end
	 end // else: !if(two_r == 2'b10)

    if (ocd_ktap_left_ns && ~ocd_ktap_left_r) resume_wait_ns = 'b1;
    else if (oclk_center_write_resume_ns && ~oclk_center_write_resume_r) 
      resume_wait_ns = POC_SAMPLE_CLEAR_WAIT[RESUME_WAIT_WIDTH-1:0];
    else if (~oclk_center_write_resume_ns && oclk_center_write_resume_r) resume_wait_ns = 'd15;
    else if (cmplx_samples_done_ns & ~cmplx_samples_done_r || 
             complex_oclkdelay_calib_start & reset_scan ||
             poc_backup_r & ocd2stg3_inc_r) resume_wait_ns = 'd31;
    else if (|resume_wait_r) resume_wait_ns = resume_wait_r - 'd1;
    
  end // always @ begin
  
endmodule // mig_7series_v4_2_ddr_phy_ocd_po_cntlr

// Local Variables:
// verilog-autolabel-prefix: "4'd"
// End:

