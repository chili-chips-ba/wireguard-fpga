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
//  /   /         Filename: ddr_phy_oclkdelay_cal.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Center write DQS in write DQ valid window using Phaser_Out Stage3
//         delay
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ocd_lim #
  (parameter TAPCNTRWIDTH    = 7,
   parameter DQS_CNT_WIDTH   = 3,
   parameter DQS_WIDTH       = 9,
   parameter TCQ             = 100,
   parameter TAPSPERKCLK     = 56,
   parameter TDQSS_DEGREES   = 60,
   parameter BYPASS_COMPLEX_OCAL = "FALSE")
  (/*AUTOARG*/
   // Outputs
   lim2init_write_request, lim2init_prech_req, lim2poc_rdy, lim2poc_ktap_right,
   lim2stg3_inc, lim2stg3_dec, lim2stg2_inc, lim2stg2_dec, lim_done,
   lim2ocal_stg3_right_lim, lim2ocal_stg3_left_lim, dbg_ocd_lim,
   // Inputs
   clk, rst, lim_start, po_rdy, poc2lim_rise_align_taps_lead,
   poc2lim_rise_align_taps_trail, poc2lim_fall_align_taps_lead,
   poc2lim_fall_align_taps_trail, oclkdelay_init_val, wl_po_fine_cnt,
   simp_stg3_final_sel, oclkdelay_calib_done, poc2lim_detect_done,
   prech_done, oclkdelay_calib_cnt
   );
  
  function [TAPCNTRWIDTH:0] mod_sub (input [TAPCNTRWIDTH-1:0] a, 
                                     input [TAPCNTRWIDTH-1:0] b, 
                                     input integer base); 
  begin
    mod_sub = (a>=b) ? a-b : a+base[TAPCNTRWIDTH-1:0]-b;
  end
  endfunction // mod_sub

  input clk;
  input rst;

  input lim_start;
  input po_rdy;
  input [TAPCNTRWIDTH-1:0] poc2lim_rise_align_taps_lead;
  input [TAPCNTRWIDTH-1:0] poc2lim_rise_align_taps_trail;
  input [TAPCNTRWIDTH-1:0] poc2lim_fall_align_taps_lead;
  input [TAPCNTRWIDTH-1:0] poc2lim_fall_align_taps_trail;
  input [5:0]              oclkdelay_init_val;
  input [5:0]              wl_po_fine_cnt;
  input [5:0]              simp_stg3_final_sel;
  input                    oclkdelay_calib_done;
  input                    poc2lim_detect_done;
  input                    prech_done;
  input [DQS_CNT_WIDTH:0]  oclkdelay_calib_cnt;
  
  
  output lim2init_write_request;
  output lim2init_prech_req;
  output lim2poc_rdy;
  output lim2poc_ktap_right;  // I think this can be defaulted.
  output lim2stg3_inc;
  output lim2stg3_dec;
  output lim2stg2_inc;
  output lim2stg2_dec;
  output lim_done;
  output [5:0] lim2ocal_stg3_right_lim;
  output [5:0] lim2ocal_stg3_left_lim;
  output [255:0] dbg_ocd_lim; 
  
  // Stage 3 taps can move an additional + or - 60 degrees from the write level position
  // Convert 60 degrees to MMCM taps. 360/60=6.
  //localparam real DIV_FACTOR = 360/TDQSS_DEGREES;
  //localparam real TDQSS_LIM_MMCM_TAPS = TAPSPERKCLK/DIV_FACTOR;
  localparam DIV_FACTOR = 360/TDQSS_DEGREES;
  localparam TDQSS_LIM_MMCM_TAPS = TAPSPERKCLK/DIV_FACTOR;
  localparam WAIT_CNT = 15;
  
  localparam IDLE             = 14'b00_0000_0000_0001;
  localparam INIT             = 14'b00_0000_0000_0010;
  localparam WAIT_WR_REQ      = 14'b00_0000_0000_0100;
  localparam WAIT_POC_DONE    = 14'b00_0000_0000_1000;
  localparam WAIT_STG3        = 14'b00_0000_0001_0000;
  localparam STAGE3_INC       = 14'b00_0000_0010_0000;
  localparam STAGE3_DEC       = 14'b00_0000_0100_0000;
  localparam STAGE2_INC       = 14'b00_0000_1000_0000;
  localparam STAGE2_DEC       = 14'b00_0001_0000_0000;
  localparam STG3_INCDEC_WAIT = 14'b00_0010_0000_0000;
  localparam STG2_INCDEC_WAIT = 14'b00_0100_0000_0000;
  localparam STAGE2_TAP_CHK   = 14'b00_1000_0000_0000;
  localparam PRECH_REQUEST    = 14'b01_0000_0000_0000;
  localparam LIMIT_DONE       = 14'b10_0000_0000_0000;

// Flip-flops  
  reg [5:0]             stg3_init_val;
  reg [13:0]            lim_state;
  reg                   lim_start_r;
  reg                   ktap_right_r;
  reg                   write_request_r;
  reg                   prech_req_r;
  reg                   poc_ready_r;
  reg                   wait_cnt_en_r;
  reg                   wait_cnt_done;
  reg [3:0]             wait_cnt_r;
  reg [5:0]             stg3_tap_cnt;
  reg [5:0]             stg2_tap_cnt;
  reg [5:0]             stg3_left_lim;
  reg [5:0]             stg3_right_lim;
  reg [DQS_WIDTH*6-1:0] cmplx_stg3_left_lim;
  reg [DQS_WIDTH*6-1:0] simp_stg3_left_lim;
  reg [DQS_WIDTH*6-1:0] cmplx_stg3_right_lim;
  reg [DQS_WIDTH*6-1:0] simp_stg3_right_lim;
  reg [5:0]             stg3_dec_val;
  reg [5:0]             stg3_inc_val;
  reg                   detect_done_r;
  reg                   stg3_dec_r;
  reg                   stg2_inc_r;
  reg                   stg3_inc2init_val_r;
  reg                   stg3_inc2init_val_r1;
  reg                   stg3_dec2init_val_r;
  reg                   stg3_dec2init_val_r1;
  reg                   stg3_dec_req_r;
  reg                   stg3_inc_req_r;
  reg                   stg2_dec_req_r;
  reg                   stg2_inc_req_r;
  reg                   stg3_init_dec_r;
  reg [TAPCNTRWIDTH:0]  mmcm_current;
  reg [TAPCNTRWIDTH:0]  mmcm_init_trail;
  reg [TAPCNTRWIDTH:0]  mmcm_init_lead;
  reg                   done_r;
  
  reg [13:0]            lim_nxt_state;
  reg                   ktap_right;
  reg                   write_request;
  reg                   prech_req;
  reg                   poc_ready;
  reg                   stg3_dec;
  reg                   stg2_inc;
  reg                   stg3_inc2init_val;
  reg                   stg3_dec2init_val;
  reg                   stg3_dec_req;
  reg                   stg3_inc_req;
  reg                   stg2_dec_req;
  reg                   stg2_inc_req;
  reg                   stg3_init_dec;
  reg                   done;
  reg                   oclkdelay_calib_done_r;
  
  wire [TAPCNTRWIDTH:0] mmcm_sub_dec = mod_sub (mmcm_init_trail, mmcm_current, TAPSPERKCLK);
  wire [TAPCNTRWIDTH:0] mmcm_sub_inc = mod_sub (mmcm_current, mmcm_init_lead, TAPSPERKCLK);
  
  /***************************************************************************/
  // Debug signals
  /***************************************************************************/
  
  assign dbg_ocd_lim[0+:DQS_WIDTH*6]    = simp_stg3_left_lim[DQS_WIDTH*6-1:0];
  assign dbg_ocd_lim[54+:DQS_WIDTH*6]   = simp_stg3_right_lim[DQS_WIDTH*6-1:0];
  assign dbg_ocd_lim[255:108]           = 'd0;

  
  
  
  assign lim2init_write_request    = write_request_r;
  assign lim2init_prech_req        = prech_req_r;
  assign lim2poc_ktap_right        = ktap_right_r;
  assign lim2poc_rdy               = poc_ready_r;
  assign lim2ocal_stg3_left_lim    = stg3_left_lim;
  assign lim2ocal_stg3_right_lim   = stg3_right_lim;
  assign lim2stg3_dec              = stg3_dec_req_r;
  assign lim2stg3_inc              = stg3_inc_req_r;
  assign lim2stg2_dec              = stg2_dec_req_r;
  assign lim2stg2_inc              = stg2_inc_req_r;
  assign lim_done                  = done_r;
  

/**************************Wait Counter Start*********************************/
// Wait counter enable for wait states WAIT_WR_REQ and WAIT_STG3
// To avoid DQS toggling when stage2 and 3 taps are moving   
  always @(posedge clk) begin
    if ((lim_state == WAIT_WR_REQ) ||
        (lim_state == WAIT_STG3) ||
		(lim_state == INIT))
      wait_cnt_en_r <= #TCQ 1'b1;
    else
      wait_cnt_en_r <= #TCQ 1'b0;
  end

// Wait counter for wait states WAIT_WR_REQ and WAIT_STG3
// To avoid DQS toggling when stage2 and 3 taps are moving  
  always @(posedge clk) begin
    if (!wait_cnt_en_r) begin
      wait_cnt_r      <= #TCQ 'b0;
      wait_cnt_done   <= #TCQ 1'b0;
    end else begin
      if (wait_cnt_r != WAIT_CNT - 1) begin
        wait_cnt_r     <= #TCQ wait_cnt_r + 1;
        wait_cnt_done  <= #TCQ 1'b0;
      end else begin
        wait_cnt_r     <= #TCQ 'b0;        
        wait_cnt_done  <= #TCQ 1'b1;
      end
    end
  end
/**************************Wait Counter End***********************************/
 
// Flip-flops

  always @(posedge clk) begin
    if (rst)
      oclkdelay_calib_done_r <= #TCQ 1'b0;
    else
      oclkdelay_calib_done_r <= #TCQ oclkdelay_calib_done;
  end

  always @(posedge clk) begin
    if (rst)
	  stg3_init_val <= #TCQ oclkdelay_init_val;
	else if (oclkdelay_calib_done)
	  stg3_init_val <= #TCQ simp_stg3_final_sel;
	else
	  stg3_init_val <= #TCQ oclkdelay_init_val;
  end

  always @(posedge clk) begin
    if (rst) begin
	  lim_state           <= #TCQ IDLE;
	  lim_start_r         <= #TCQ 1'b0;
	  ktap_right_r        <= #TCQ 1'b0;
	  write_request_r     <= #TCQ 1'b0;
	  prech_req_r         <= #TCQ 1'b0;
	  poc_ready_r         <= #TCQ 1'b0;
	  detect_done_r       <= #TCQ 1'b0;
	  stg3_dec_r          <= #TCQ 1'b0;
	  stg2_inc_r          <= #TCQ 1'b0;
	  stg3_inc2init_val_r <= #TCQ 1'b0;
	  stg3_inc2init_val_r1<= #TCQ 1'b0;
	  stg3_dec2init_val_r <= #TCQ 1'b0;
	  stg3_dec2init_val_r1<= #TCQ 1'b0;
	  stg3_dec_req_r      <= #TCQ 1'b0;
	  stg3_inc_req_r      <= #TCQ 1'b0;
	  stg2_dec_req_r      <= #TCQ 1'b0;
	  stg2_inc_req_r      <= #TCQ 1'b0;
	  done_r              <= #TCQ 1'b0;
	  stg3_dec_val        <= #TCQ 'd0;
	  stg3_inc_val        <= #TCQ 'd0;
	  stg3_init_dec_r     <= #TCQ 1'b0;
	end else begin
	  lim_state           <= #TCQ lim_nxt_state;
	  lim_start_r         <= #TCQ lim_start;
	  ktap_right_r        <= #TCQ ktap_right;
	  write_request_r     <= #TCQ write_request;
	  prech_req_r         <= #TCQ prech_req;
	  poc_ready_r         <= #TCQ poc_ready;
	  detect_done_r       <= #TCQ poc2lim_detect_done;
	  stg3_dec_r          <= #TCQ stg3_dec;
	  stg2_inc_r          <= #TCQ stg2_inc;
	  stg3_inc2init_val_r <= #TCQ stg3_inc2init_val;
	  stg3_inc2init_val_r1<= #TCQ stg3_inc2init_val_r;
	  stg3_dec2init_val_r <= #TCQ stg3_dec2init_val;
	  stg3_dec2init_val_r1<= #TCQ stg3_dec2init_val_r;
	  stg3_dec_req_r      <= #TCQ stg3_dec_req;
	  stg3_inc_req_r      <= #TCQ stg3_inc_req;
	  stg2_dec_req_r      <= #TCQ stg2_dec_req;
	  stg2_inc_req_r      <= #TCQ stg2_inc_req;
	  stg3_init_dec_r     <= #TCQ stg3_init_dec;
	  done_r              <= #TCQ done;
	  if (stg3_init_val > (('d63 - wl_po_fine_cnt)/2))
	    stg3_dec_val      <= #TCQ (stg3_init_val - ('d63 - wl_po_fine_cnt)/2);
	  else
	    stg3_dec_val      <= #TCQ 'd0;
	  if (stg3_init_val < 'd63 - ((wl_po_fine_cnt)/2))
	    stg3_inc_val      <= #TCQ (stg3_init_val + (wl_po_fine_cnt)/2);
	  else
	    stg3_inc_val      <= #TCQ 'd63;
	end
  end

// Keeping track of stage 3 tap count  
  always @(posedge clk) begin
    if (rst)
	  stg3_tap_cnt <= #TCQ stg3_init_val;
	else if ((lim_state == IDLE) || (lim_state == INIT))
	  stg3_tap_cnt <= #TCQ stg3_init_val;
	else if (lim_state == STAGE3_INC)
	  stg3_tap_cnt <= #TCQ stg3_tap_cnt + 1;
	else if (lim_state == STAGE3_DEC)
	  stg3_tap_cnt <= #TCQ stg3_tap_cnt - 1;
  end
  
// Keeping track of stage 2 tap count  
  always @(posedge clk) begin
    if (rst)
	  stg2_tap_cnt <= #TCQ 'd0;
	else if ((lim_state == IDLE) || (lim_state == INIT))
	  stg2_tap_cnt <= #TCQ wl_po_fine_cnt;
	else if (lim_state == STAGE2_INC)
	  stg2_tap_cnt <= #TCQ stg2_tap_cnt + 1;
	else if (lim_state == STAGE2_DEC)
	  stg2_tap_cnt <= #TCQ stg2_tap_cnt - 1;
  end
  
// Keeping track of MMCM tap count
  always @(posedge clk) begin
    if (rst) begin
	  mmcm_init_trail <= #TCQ 'd0;
	  mmcm_init_lead  <= #TCQ 'd0;
	end else if (poc2lim_detect_done && !detect_done_r) begin
	  if (stg3_tap_cnt == stg3_dec_val)
	    mmcm_init_trail <= #TCQ poc2lim_rise_align_taps_trail;
	  if (stg3_tap_cnt == stg3_inc_val)
	    mmcm_init_lead  <= #TCQ poc2lim_rise_align_taps_lead;
	end  
  end
  
  always @(posedge clk) begin
    if (rst) begin
	  mmcm_current    <= #TCQ 'd0;
	end else if (stg3_dec_r) begin
	  if (stg3_tap_cnt == stg3_dec_val)
	    mmcm_current <= #TCQ mmcm_init_trail;
	  else
	    mmcm_current <= #TCQ poc2lim_rise_align_taps_lead;
	end else begin
	  if (stg3_tap_cnt == stg3_inc_val)
	    mmcm_current <= #TCQ mmcm_init_lead;
	  else
	    mmcm_current <= #TCQ poc2lim_rise_align_taps_trail;
	end 
  end

// Record Stage3 Left Limit
  always @(posedge clk) begin
    if (rst) begin
	  stg3_left_lim       <= #TCQ 'd0;
	  simp_stg3_left_lim  <= #TCQ 'd0;
	  cmplx_stg3_left_lim <= #TCQ 'd0;
	end else if (stg3_inc2init_val_r && !stg3_inc2init_val_r1) begin
	  stg3_left_lim <= #TCQ stg3_tap_cnt;
	  if (oclkdelay_calib_done)
	    cmplx_stg3_left_lim[oclkdelay_calib_cnt*6+:6] <= #TCQ stg3_tap_cnt;
	  else
	    simp_stg3_left_lim[oclkdelay_calib_cnt*6+:6] <= #TCQ stg3_tap_cnt;
	end else if (lim_start && !lim_start_r)
	  stg3_left_lim <= #TCQ 'd0;
  end

// Record Stage3 Right Limit
  always @(posedge clk) begin
    if (rst) begin
	  stg3_right_lim       <= #TCQ 'd0;
	  cmplx_stg3_right_lim <= #TCQ 'd0;
	  simp_stg3_right_lim <= #TCQ 'd0;
	end else if (stg3_dec2init_val_r && !stg3_dec2init_val_r1) begin
	  stg3_right_lim <= #TCQ stg3_tap_cnt;
	  if (oclkdelay_calib_done)
	    cmplx_stg3_right_lim[oclkdelay_calib_cnt*6+:6] <= #TCQ stg3_tap_cnt;
	  else
	    simp_stg3_right_lim[oclkdelay_calib_cnt*6+:6] <= #TCQ stg3_tap_cnt;
	end else if (lim_start && !lim_start_r)
	  stg3_right_lim <= #TCQ 'd0;
  end  
  
  always @(*) begin
	  lim_nxt_state     = lim_state;
	  ktap_right        = ktap_right_r;
	  write_request     = write_request_r;
	  prech_req         = prech_req_r;
	  poc_ready         = poc_ready_r;
	  stg3_dec          = stg3_dec_r;
	  stg2_inc          = stg2_inc_r;
	  stg3_inc2init_val = stg3_inc2init_val_r;
	  stg3_dec2init_val = stg3_dec2init_val_r;
	  stg3_dec_req      = stg3_dec_req_r;
	  stg3_inc_req      = stg3_inc_req_r;
	  stg2_inc_req      = stg2_inc_req_r;
	  stg2_dec_req      = stg2_dec_req_r;
	  stg3_init_dec     = stg3_init_dec_r;
	  done              = done_r;

	
	  case(lim_state)
	    IDLE: begin
	      if (lim_start && !lim_start_r) begin
                lim_nxt_state = INIT;
                stg3_dec      = 1'b1;
                stg2_inc      = 1'b1;
                stg3_init_dec = 1'b1;
                done          = 1'b0;
	      end
	      //New start of limit module for complex oclkdelay calib
              else if (oclkdelay_calib_done && !oclkdelay_calib_done_r && (BYPASS_COMPLEX_OCAL == "FALSE")) begin
                done          = 1'b0;
              end
	    end
	    INIT: begin
	      ktap_right     = 1'b1;
		  // Initial stage 2 increment to 63 for left limit
		  if (wait_cnt_done)
  	        lim_nxt_state  = STAGE2_TAP_CHK;
	    end
	    // Wait for DQS to toggle before asserting poc_ready
	    WAIT_WR_REQ: begin
	      write_request  = 1'b1;
	      if (wait_cnt_done) begin
	  	    poc_ready      = 1'b1;
	  	    lim_nxt_state  = WAIT_POC_DONE;
	  	  end
	    end
	    // Wait for POC detect done signal
	    WAIT_POC_DONE: begin
	  	  if (poc2lim_detect_done) begin
	  	    write_request  = 1'b0;
			poc_ready      = 1'b0;
	  	    lim_nxt_state  = WAIT_STG3;
	  	  end
	    end
	    // Wait for DQS to stop toggling before stage3 inc/dec
	    WAIT_STG3: begin
	      if (wait_cnt_done) begin
	  	    if (stg3_dec_r) begin
	  	    // Check for Stage 3 underflow and MMCM tap limit
	  	      if ((stg3_tap_cnt > 'd0) && (mmcm_sub_dec < TDQSS_LIM_MMCM_TAPS))
	  	        lim_nxt_state  = STAGE3_DEC;
	  		  else begin
	  		    stg3_dec          = 1'b0;
	  		    stg3_inc2init_val = 1'b1;
	  		    lim_nxt_state     = STAGE3_INC;
	  		  end
	  	    end else begin // Stage 3 being incremented
	  	    // Check for Stage 3 overflow and MMCM tap limit
	  	      if ((stg3_tap_cnt < 'd63) && (mmcm_sub_inc < TDQSS_LIM_MMCM_TAPS))
	  	        lim_nxt_state  = STAGE3_INC;
	  		  else begin
	  		    stg3_dec2init_val = 1'b1;
                lim_nxt_state  = STAGE3_DEC;
              end
            end			
	  	  end
	    end
	    STAGE3_INC: begin
	      stg3_inc_req   = 1'b1;
	  	  lim_nxt_state  = STG3_INCDEC_WAIT;
	    end
	    STAGE3_DEC: begin
	      stg3_dec_req   = 1'b1;   
	  	  lim_nxt_state  = STG3_INCDEC_WAIT;
	    end
	    // Wait for stage3 inc/dec to complete (po_rdy)
	    STG3_INCDEC_WAIT: begin
	      stg3_dec_req   = 1'b0;
	  	  stg3_inc_req   = 1'b0;
	      if (!stg3_dec_req_r && !stg3_inc_req_r && po_rdy) begin
		    if (stg3_init_dec_r) begin
			  // Initial decrement of stage 3
			  if (stg3_tap_cnt > stg3_dec_val)
			    lim_nxt_state  = STAGE3_DEC;
			  else begin
			    lim_nxt_state  = WAIT_WR_REQ;
				stg3_init_dec  = 1'b0;
			  end
	        end else if (stg3_dec2init_val_r) begin 
			  if (stg3_tap_cnt > stg3_init_val)
	  	        lim_nxt_state  = STAGE3_DEC;
			  else
			    lim_nxt_state  = STAGE2_TAP_CHK;
	  	    end else if (stg3_inc2init_val_r) begin
			  if (stg3_tap_cnt < stg3_inc_val)
	  	        lim_nxt_state  = STAGE3_INC;
			  else
			    lim_nxt_state  = STAGE2_TAP_CHK;
	  	    end else begin
	  	      lim_nxt_state  = WAIT_WR_REQ;
			end
	  	  end
	    end
	    // Check for overflow and underflow of stage2 taps
	    STAGE2_TAP_CHK: begin
	      if (stg3_dec2init_val_r) begin
		    // Increment stage 2 to write level tap value at the end of limit detection
	  	    if (stg2_tap_cnt < wl_po_fine_cnt)
	  	      lim_nxt_state  = STAGE2_INC;
	        else begin
	          lim_nxt_state     = PRECH_REQUEST;	  		  
	  	    end
	  	  end else if (stg3_inc2init_val_r) begin
		    // Decrement stage 2 to '0' to determine right limit
	  	    if (stg2_tap_cnt > 'd0)
	  	      lim_nxt_state  = STAGE2_DEC;
	  	    else begin
	  	      lim_nxt_state     = PRECH_REQUEST;
	  		  stg3_inc2init_val = 1'b0;
	  	    end
		  end else if (stg2_inc_r && (stg2_tap_cnt < 'd63)) begin
		    // Initial increment to 63
	  	    lim_nxt_state  = STAGE2_INC;
          end else begin
            lim_nxt_state  = STG3_INCDEC_WAIT;
			stg2_inc       = 1'b0;
		  end
	    end
	    STAGE2_INC: begin
	      stg2_inc_req = 1'b1;
	  	  lim_nxt_state  = STG2_INCDEC_WAIT;
	    end
	    STAGE2_DEC: begin
	      stg2_dec_req = 1'b1;
	  	  lim_nxt_state  = STG2_INCDEC_WAIT;
	    end
	    // Wait for stage3 inc/dec to complete (po_rdy)
	    STG2_INCDEC_WAIT: begin
	      stg2_inc_req = 1'b0;
	  	  stg2_dec_req = 1'b0;
	  	  if (!stg2_inc_req_r && !stg2_dec_req_r && po_rdy)
	  	    lim_nxt_state  = STAGE2_TAP_CHK;
	    end
		PRECH_REQUEST: begin
		  prech_req = 1'b1;
		  if (prech_done) begin
		    prech_req       = 1'b0;
		    if (stg3_dec2init_val_r)
			  lim_nxt_state = LIMIT_DONE;
			else
		      lim_nxt_state = WAIT_WR_REQ;
		  end
		end
	    LIMIT_DONE: begin
	      done              = 1'b1;
	  	  ktap_right        = 1'b0;
		  stg3_dec2init_val = 1'b0;
		  lim_nxt_state     = IDLE;
	    end
	    default: begin
	      lim_nxt_state = IDLE;
	    end
	  endcase
  end
  

endmodule //mig_7_series_v4_0_ddr_phy_ocd_lim


