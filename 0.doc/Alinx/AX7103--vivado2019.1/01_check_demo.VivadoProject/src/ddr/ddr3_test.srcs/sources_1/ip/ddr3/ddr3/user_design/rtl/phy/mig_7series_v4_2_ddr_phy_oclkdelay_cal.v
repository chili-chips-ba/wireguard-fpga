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

module mig_7series_v4_2_ddr_phy_oclkdelay_cal #
  (parameter TCQ                    = 100,
   parameter nCK_PER_CLK            = 4,
   parameter DRAM_WIDTH             = 8,
   parameter DQS_CNT_WIDTH          = 3,
   parameter DQS_WIDTH              = 8,
   parameter DQ_WIDTH               = 64,
   parameter MMCM_SAMP_WAIT         = 10,
   parameter OCAL_SIMPLE_SCAN_SAMPS = 2,
   parameter PCT_SAMPS_SOLID        = 95,
   parameter POC_USE_METASTABLE_SAMP = "FALSE",
   parameter SCAN_PCT_SAMPS_SOLID   = 95,
   parameter SIM_CAL_OPTION         = "NONE",
   parameter SAMPCNTRWIDTH          = 8,
   parameter SAMPLES	            = 128,
   parameter TAPCNTRWIDTH           = 7,
   parameter TAPSPERKCLK            = 56,
   parameter BYPASS_COMPLEX_OCAL    = "FALSE")
  (/*AUTOARG*/
  // Outputs
  wrlvl_final, rd_victim_sel, psincdec, psen, poc_error, po_stg23_sel,
  po_stg23_incdec, po_en_stg23, oclkdelay_center_calib_start,
  oclkdelay_center_calib_done, oclk_prech_req,
  oclk_center_write_resume, oclk_calib_resume,
  ocal_num_samples_done_r, lim2init_write_request, dbg_poc,
  complex_wrlvl_final, complex_oclkdelay_calib_done,
  oclkdelay_calib_cnt, dbg_phy_oclkdelay_cal, dbg_oclkdelay_rd_data,
  oclkdelay_calib_done, lim_done, dbg_ocd_lim,
  // Inputs
  wl_po_fine_cnt, rst, psdone, prech_done, prbs_o,
  prbs_ignore_last_bytes, prbs_ignore_first_byte, poc_sample_pd,
  po_counter_read_val, phy_rddata_en, phy_rddata, oclkdelay_init_val,
  oclkdelay_calib_start, ocal_num_samples_inc, metaQ,
  complex_oclkdelay_calib_start, clk
  );

  /*AUTOINPUT*/
  // Beginning of automatic inputs (from unused autoinst inputs)
  input			clk;			// To u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v, ...
  input			complex_oclkdelay_calib_start;// To u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v, ...
  input			metaQ;			// To u_poc of mig_7series_v4_2_poc_top.v
  input			ocal_num_samples_inc;	// To u_ocd_samp of mig_7series_v4_2_ddr_phy_ocd_samp.v
  input			oclkdelay_calib_start;	// To u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  input [5:0]		oclkdelay_init_val;	// To u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v, ...
  input [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rddata;// To u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v
  input			phy_rddata_en;		// To u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  input [8:0]		po_counter_read_val;	// To u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v, ...
  input			poc_sample_pd;		// To u_poc of mig_7series_v4_2_poc_top.v
  input			prbs_ignore_first_byte;	// To u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v
  input			prbs_ignore_last_bytes;	// To u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v
  input [2*nCK_PER_CLK*DQ_WIDTH-1:0] prbs_o;	// To u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v
  input			prech_done;		// To u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v, ...
  input			psdone;			// To u_poc of mig_7series_v4_2_poc_top.v
  input			rst;			// To u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v, ...
  input [6*DQS_WIDTH-1:0] wl_po_fine_cnt;	// To u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  // End of automatics
  /*AUTOOUTPUT*/
  // Beginning of automatic outputs (from unused autoinst outputs)
  output		complex_oclkdelay_calib_done;// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  output		complex_wrlvl_final;	// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  output [1023:0]	dbg_poc;		// From u_poc of mig_7series_v4_2_poc_top.v
  output		lim2init_write_request;	// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  output		ocal_num_samples_done_r;// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  output		oclk_calib_resume;	// From u_ocd_samp of mig_7series_v4_2_ddr_phy_ocd_samp.v
  output		oclk_center_write_resume;// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  output		oclk_prech_req;		// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  output		oclkdelay_center_calib_done;// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  output		oclkdelay_center_calib_start;// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  output		po_en_stg23;		// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  output		po_stg23_incdec;	// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  output		po_stg23_sel;		// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  output		poc_error;		// From u_poc of mig_7series_v4_2_poc_top.v
  output		psen;			// From u_poc of mig_7series_v4_2_poc_top.v
  output		psincdec;		// From u_poc of mig_7series_v4_2_poc_top.v
  output [2:0]		rd_victim_sel;		// From u_ocd_samp of mig_7series_v4_2_ddr_phy_ocd_samp.v
  output		wrlvl_final;		// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  // End of automatics
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire			f2o;			// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire			f2z;			// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire [5:0]		fuzz2oneeighty;		// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire [5:0]		fuzz2zero;		// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire			ktap_at_left_edge;	// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  wire			ktap_at_right_edge;	// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  wire			lim2init_prech_req;	// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire [5:0]		lim2ocal_stg3_left_lim;	// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire [5:0]		lim2ocal_stg3_right_lim;// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2poc_ktap_right;	// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2poc_rdy;		// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2stg2_dec;		// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2stg2_inc;		// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2stg3_dec;		// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim2stg3_inc;		// From u_ocd_lim of mig_7series_v4_2_ddr_phy_ocd_lim.v
  wire			lim_start;		// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire [1:0]		match;			// From u_ocd_data of mig_7series_v4_2_ddr_phy_ocd_data.v
  wire			mmcm_edge_detect_done;	// From u_poc of mig_7series_v4_2_poc_top.v
  wire			mmcm_edge_detect_rdy;	// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  wire			mmcm_lbclk_edge_aligned;// From u_poc of mig_7series_v4_2_poc_top.v
  wire [1:0]		ninety_offsets;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			o2f;			// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire			ocd2stg2_dec;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd2stg2_inc;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd2stg3_dec;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd2stg3_inc;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd_cntlr2stg2_dec;	// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire			ocd_edge_detect_rdy;	// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd_ktap_left;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd_ktap_right;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			ocd_prech_req;		// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire [5:0]		oneeighty2fuzz;		// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire			phy_rddata_en_1;	// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire			phy_rddata_en_2;	// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire			phy_rddata_en_3;	// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire			po_rdy;			// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  wire			poc_backup;		// From u_poc of mig_7series_v4_2_poc_top.v
  wire			reset_scan;		// From u_ocd_cntlr of mig_7series_v4_2_ddr_phy_ocd_cntlr.v
  wire [TAPCNTRWIDTH-1:0] rise_lead_right;	// From u_poc of mig_7series_v4_2_poc_top.v
  wire [TAPCNTRWIDTH-1:0] rise_trail_right;	// From u_poc of mig_7series_v4_2_poc_top.v
  wire			samp_done;		// From u_ocd_samp of mig_7series_v4_2_ddr_phy_ocd_samp.v
  wire [1:0]		samp_result;		// From u_ocd_samp of mig_7series_v4_2_ddr_phy_ocd_samp.v
  wire			scan_done;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			scan_right;		// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire			scanning_right;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire [5:0]		simp_stg3_final_sel;	// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire [5:0]		stg3;			// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			taps_set;		// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire			use_noise_window;	// From u_ocd_po_cntlr of mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v
  wire [5:0]		wl_po_fine_cnt_sel;	// From u_ocd_mux of mig_7series_v4_2_ddr_phy_ocd_mux.v
  wire			z2f;			// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  wire [5:0]		zero2fuzz;		// From u_ocd_edge of mig_7series_v4_2_ddr_phy_ocd_edge.v
  // End of automatics
  wire [DQS_WIDTH*6-1:0] simp_stg3_final, cmplx_stg3_final;
  wire ocal_scan_win_not_found;


  output [DQS_CNT_WIDTH:0] oclkdelay_calib_cnt;
  output [255:0] dbg_phy_oclkdelay_cal;
  output [16*DRAM_WIDTH-1:0] dbg_oclkdelay_rd_data;
  output oclkdelay_calib_done;

  output lim_done;
  output [255:0] dbg_ocd_lim;
  
  // Debug signals
  assign dbg_phy_oclkdelay_cal[0] = f2o;  
  assign dbg_phy_oclkdelay_cal[1] = f2z;
  assign dbg_phy_oclkdelay_cal[2] = o2f;
  assign dbg_phy_oclkdelay_cal[3] = z2f;
  assign dbg_phy_oclkdelay_cal[4+:6] = fuzz2oneeighty;
  assign dbg_phy_oclkdelay_cal[10+:6] = fuzz2zero;
  assign dbg_phy_oclkdelay_cal[16+:6] = oneeighty2fuzz;
  assign dbg_phy_oclkdelay_cal[22+:6] = zero2fuzz;
  assign dbg_phy_oclkdelay_cal[28+:3] = oclkdelay_calib_cnt;
  assign dbg_phy_oclkdelay_cal[31] = oclkdelay_calib_start;
  assign dbg_phy_oclkdelay_cal[32] = lim_done;
  assign dbg_phy_oclkdelay_cal[33+:6] =lim2ocal_stg3_left_lim ;
  assign dbg_phy_oclkdelay_cal[39+:6] = lim2ocal_stg3_right_lim ;
  assign dbg_phy_oclkdelay_cal[45+:8] = po_counter_read_val[8:0];
  assign dbg_phy_oclkdelay_cal[53+:54] = simp_stg3_final[DQS_WIDTH*6-1:0];
  assign dbg_phy_oclkdelay_cal[107] = ocal_scan_win_not_found;  
  assign dbg_phy_oclkdelay_cal[108] = oclkdelay_center_calib_start;
  assign dbg_phy_oclkdelay_cal[109] = oclkdelay_center_calib_done;
  assign dbg_phy_oclkdelay_cal[115:110] = stg3[5:0];
  
  /*mig_7series_v4_2_ddr_phy_ocd_lim AUTO_TEMPLATE(
   .TDQSS_DEGREES                       (),
   .wl_po_fine_cnt                      (wl_po_fine_cnt_sel[5:0]),
   .poc2lim_detect_done                 (mmcm_edge_detect_done),
   .poc2lim_fall_align_taps_.*          ({TAPCNTRWIDTH{1'b0}}),
   .poc2lim_rise_align_taps_lead        (rise_lead_right),
   .poc2lim_rise_align_taps_trail       (rise_trail_right),); */

  mig_7series_v4_2_ddr_phy_ocd_lim #
    (/*AUTOINSTPARAM*/
     // Parameters
     .BYPASS_COMPLEX_OCAL		(BYPASS_COMPLEX_OCAL),
     .DQS_CNT_WIDTH			(DQS_CNT_WIDTH),
     .DQS_WIDTH				(DQS_WIDTH),
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ),
     .TDQSS_DEGREES			())			 // Templated
  u_ocd_lim
    (/*AUTOINST*/
     // Outputs
     .dbg_ocd_lim			(dbg_ocd_lim[255:0]),
     .lim2init_prech_req		(lim2init_prech_req),
     .lim2init_write_request		(lim2init_write_request),
     .lim2ocal_stg3_left_lim		(lim2ocal_stg3_left_lim[5:0]),
     .lim2ocal_stg3_right_lim		(lim2ocal_stg3_right_lim[5:0]),
     .lim2poc_ktap_right		(lim2poc_ktap_right),
     .lim2poc_rdy			(lim2poc_rdy),
     .lim2stg2_dec			(lim2stg2_dec),
     .lim2stg2_inc			(lim2stg2_inc),
     .lim2stg3_dec			(lim2stg3_dec),
     .lim2stg3_inc			(lim2stg3_inc),
     .lim_done				(lim_done),
     // Inputs
     .clk				(clk),
     .lim_start				(lim_start),
     .oclkdelay_calib_cnt		(oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
     .oclkdelay_calib_done		(oclkdelay_calib_done),
     .oclkdelay_init_val		(oclkdelay_init_val[5:0]),
     .po_rdy				(po_rdy),
     .poc2lim_detect_done		(mmcm_edge_detect_done), // Templated
     .poc2lim_fall_align_taps_lead	({TAPCNTRWIDTH{1'b0}}),	 // Templated
     .poc2lim_fall_align_taps_trail	({TAPCNTRWIDTH{1'b0}}),	 // Templated
     .poc2lim_rise_align_taps_lead	(rise_lead_right),	 // Templated
     .poc2lim_rise_align_taps_trail	(rise_trail_right),	 // Templated
     .prech_done			(prech_done),
     .rst				(rst),
     .simp_stg3_final_sel		(simp_stg3_final_sel[5:0]),
     .wl_po_fine_cnt			(wl_po_fine_cnt_sel[5:0])); // Templated

  /*mig_7series_v4_2_poc_top AUTO_TEMPLATE(
   .CCENABLE                            (0),
   .LANE_CNT_WIDTH                      (DQS_CNT_WIDTH),
   .SCANFROMRIGHT                       (1),
   .lane                                (oclkdelay_calib_cnt[DQS_CNT_WIDTH-1:0]),
   .pd_out                              (metaQ),); */

  mig_7series_v4_2_poc_top #
    (/*AUTOINSTPARAM*/
     // Parameters
     .CCENABLE				(0),			 // Templated
     .LANE_CNT_WIDTH			(DQS_CNT_WIDTH),	 // Templated
     .MMCM_SAMP_WAIT			(MMCM_SAMP_WAIT),
     .PCT_SAMPS_SOLID			(PCT_SAMPS_SOLID),
     .POC_USE_METASTABLE_SAMP		(POC_USE_METASTABLE_SAMP),
     .SAMPCNTRWIDTH			(SAMPCNTRWIDTH),
     .SAMPLES				(SAMPLES),
     .SCANFROMRIGHT			(1),			 // Templated
     .TAPCNTRWIDTH			(TAPCNTRWIDTH),
     .TAPSPERKCLK			(TAPSPERKCLK),
     .TCQ				(TCQ))
  u_poc
    (/*AUTOINST*/
     // Outputs
     .dbg_poc				(dbg_poc[1023:0]),
     .mmcm_edge_detect_done		(mmcm_edge_detect_done),
     .mmcm_lbclk_edge_aligned		(mmcm_lbclk_edge_aligned),
     .poc_backup			(poc_backup),
     .poc_error				(poc_error),
     .psen				(psen),
     .psincdec				(psincdec),
     .rise_lead_right			(rise_lead_right[TAPCNTRWIDTH-1:0]),
     .rise_trail_right			(rise_trail_right[TAPCNTRWIDTH-1:0]),
     // Inputs
     .clk				(clk),
     .ktap_at_left_edge			(ktap_at_left_edge),
     .ktap_at_right_edge		(ktap_at_right_edge),
     .lane				(oclkdelay_calib_cnt[DQS_CNT_WIDTH-1:0]), // Templated
     .mmcm_edge_detect_rdy		(mmcm_edge_detect_rdy),
     .ninety_offsets			(ninety_offsets[1:0]),
     .pd_out				(metaQ),		 // Templated
     .poc_sample_pd			(poc_sample_pd),
     .psdone				(psdone),
     .rst				(rst),
     .use_noise_window			(use_noise_window));

  /*mig_7series_v4_2_ddr_phy_ocd_mux AUTO_TEMPLATE(
   .po_stg3_incdec               (),
   .po_en_stg3                   (),); */

  mig_7series_v4_2_ddr_phy_ocd_mux #
    (/*AUTOINSTPARAM*/
     // Parameters
     .DQS_CNT_WIDTH			(DQS_CNT_WIDTH),
     .DQS_WIDTH				(DQS_WIDTH),
     .TCQ				(TCQ))
  u_ocd_mux
    (/*AUTOINST*/
     // Outputs
     .ktap_at_left_edge			(ktap_at_left_edge),
     .ktap_at_right_edge		(ktap_at_right_edge),
     .mmcm_edge_detect_rdy		(mmcm_edge_detect_rdy),
     .oclk_prech_req			(oclk_prech_req),
     .po_en_stg23			(po_en_stg23),
     .po_en_stg3			(),			 // Templated
     .po_rdy				(po_rdy),
     .po_stg23_incdec			(po_stg23_incdec),
     .po_stg23_sel			(po_stg23_sel),
     .po_stg3_incdec			(),			 // Templated
     .wl_po_fine_cnt_sel		(wl_po_fine_cnt_sel[5:0]),
     // Inputs
     .clk				(clk),
     .lim2init_prech_req		(lim2init_prech_req),
     .lim2poc_ktap_right		(lim2poc_ktap_right),
     .lim2poc_rdy			(lim2poc_rdy),
     .lim2stg2_dec			(lim2stg2_dec),
     .lim2stg2_inc			(lim2stg2_inc),
     .lim2stg3_dec			(lim2stg3_dec),
     .lim2stg3_inc			(lim2stg3_inc),
     .ocd2stg2_dec			(ocd2stg2_dec),
     .ocd2stg2_inc			(ocd2stg2_inc),
     .ocd2stg3_dec			(ocd2stg3_dec),
     .ocd2stg3_inc			(ocd2stg3_inc),
     .ocd_cntlr2stg2_dec		(ocd_cntlr2stg2_dec),
     .ocd_edge_detect_rdy		(ocd_edge_detect_rdy),
     .ocd_ktap_left			(ocd_ktap_left),
     .ocd_ktap_right			(ocd_ktap_right),
     .ocd_prech_req			(ocd_prech_req),
     .oclkdelay_calib_cnt		(oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
     .rst				(rst),
     .wl_po_fine_cnt			(wl_po_fine_cnt[6*DQS_WIDTH-1:0]));
  
  mig_7series_v4_2_ddr_phy_ocd_data #
    (/*AUTOINSTPARAM*/
     // Parameters
     .DQS_CNT_WIDTH			(DQS_CNT_WIDTH),
     .DQ_WIDTH				(DQ_WIDTH),
     .TCQ				(TCQ),
     .nCK_PER_CLK			(nCK_PER_CLK))
  u_ocd_data
    (/*AUTOINST*/
     // Outputs
     .match				(match[1:0]),
     // Inputs
     .clk				(clk),
     .complex_oclkdelay_calib_start	(complex_oclkdelay_calib_start),
     .oclkdelay_calib_cnt		(oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
     .phy_rddata			(phy_rddata[2*nCK_PER_CLK*DQ_WIDTH-1:0]),
     .phy_rddata_en_1			(phy_rddata_en_1),
     .prbs_ignore_first_byte		(prbs_ignore_first_byte),
     .prbs_ignore_last_bytes		(prbs_ignore_last_bytes),
     .prbs_o				(prbs_o[2*nCK_PER_CLK*DQ_WIDTH-1:0]),
     .rst				(rst));
  
  mig_7series_v4_2_ddr_phy_ocd_samp #
    (/*AUTOINSTPARAM*/
     // Parameters
     .OCAL_SIMPLE_SCAN_SAMPS		(OCAL_SIMPLE_SCAN_SAMPS),
     .SCAN_PCT_SAMPS_SOLID		(SCAN_PCT_SAMPS_SOLID),
     .SIM_CAL_OPTION			(SIM_CAL_OPTION),
     .TCQ				(TCQ),
     .nCK_PER_CLK			(nCK_PER_CLK))
  u_ocd_samp
    (/*AUTOINST*/
     // Outputs
     .oclk_calib_resume			(oclk_calib_resume),
     .rd_victim_sel			(rd_victim_sel[2:0]),
     .samp_done				(samp_done),
     .samp_result			(samp_result[1:0]),
     // Inputs
     .clk				(clk),
     .complex_oclkdelay_calib_start	(complex_oclkdelay_calib_start),
     .match				(match[1:0]),
     .ocal_num_samples_inc		(ocal_num_samples_inc),
     .phy_rddata_en_1			(phy_rddata_en_1),
     .phy_rddata_en_2			(phy_rddata_en_2),
     .reset_scan			(reset_scan),
     .rst				(rst),
     .taps_set				(taps_set));

  mig_7series_v4_2_ddr_phy_ocd_edge #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TCQ				(TCQ))
  u_ocd_edge
    (/*AUTOINST*/
     // Outputs
     .f2o				(f2o),
     .f2z				(f2z),
     .fuzz2oneeighty			(fuzz2oneeighty[5:0]),
     .fuzz2zero				(fuzz2zero[5:0]),
     .o2f				(o2f),
     .oneeighty2fuzz			(oneeighty2fuzz[5:0]),
     .scan_right			(scan_right),
     .z2f				(z2f),
     .zero2fuzz				(zero2fuzz[5:0]),
     // Inputs
     .clk				(clk),
     .phy_rddata_en_2			(phy_rddata_en_2),
     .reset_scan			(reset_scan),
     .samp_done				(samp_done),
     .samp_result			(samp_result[1:0]),
     .scanning_right			(scanning_right),
     .stg3				(stg3[5:0]));

  /*mig_7series_v4_2_ddr_phy_ocd_cntlr AUTO_TEMPLATE(
   .oclk_init_delay_done                (),); */
  
  mig_7series_v4_2_ddr_phy_ocd_cntlr #
    (/*AUTOINSTPARAM*/
     // Parameters
     .DQS_CNT_WIDTH			(DQS_CNT_WIDTH),
     .DQS_WIDTH				(DQS_WIDTH),
     .TCQ				(TCQ))
  u_ocd_cntlr
    (/*AUTOINST*/
     // Outputs
     .complex_oclkdelay_calib_done	(complex_oclkdelay_calib_done),
     .complex_wrlvl_final		(complex_wrlvl_final),
     .lim_start				(lim_start),
     .ocd_cntlr2stg2_dec		(ocd_cntlr2stg2_dec),
     .ocd_prech_req			(ocd_prech_req),
     .oclk_init_delay_done		(),			 // Templated
     .oclkdelay_calib_cnt		(oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
     .oclkdelay_calib_done		(oclkdelay_calib_done),
     .phy_rddata_en_1			(phy_rddata_en_1),
     .phy_rddata_en_2			(phy_rddata_en_2),
     .phy_rddata_en_3			(phy_rddata_en_3),
     .reset_scan			(reset_scan),
     .wrlvl_final			(wrlvl_final),
     // Inputs
     .clk				(clk),
     .complex_oclkdelay_calib_start	(complex_oclkdelay_calib_start),
     .lim_done				(lim_done),
     .oclkdelay_calib_start		(oclkdelay_calib_start),
     .phy_rddata_en			(phy_rddata_en),
     .po_counter_read_val		(po_counter_read_val[8:0]),
     .po_rdy				(po_rdy),
     .prech_done			(prech_done),
     .rst				(rst),
     .scan_done				(scan_done));

  
  mig_7series_v4_2_ddr_phy_ocd_po_cntlr #
    (/*AUTOINSTPARAM*/
     // Parameters
     .DQS_CNT_WIDTH			(DQS_CNT_WIDTH),
     .DQS_WIDTH				(DQS_WIDTH),
     .SAMPLES				(SAMPLES),
     .TCQ				(TCQ),
     .nCK_PER_CLK			(nCK_PER_CLK))
  u_ocd_po_cntlr
    (.cmplx_stg3_final			(cmplx_stg3_final[DQS_WIDTH*6-1:0]),
     .ocal_scan_win_not_found		(ocal_scan_win_not_found),
     .simp_stg3_final			(simp_stg3_final[DQS_WIDTH*6-1:0]),
     /*AUTOINST*/
     // Outputs
     .ninety_offsets			(ninety_offsets[1:0]),
     .ocal_num_samples_done_r		(ocal_num_samples_done_r),
     .ocd2stg2_dec			(ocd2stg2_dec),
     .ocd2stg2_inc			(ocd2stg2_inc),
     .ocd2stg3_dec			(ocd2stg3_dec),
     .ocd2stg3_inc			(ocd2stg3_inc),
     .ocd_edge_detect_rdy		(ocd_edge_detect_rdy),
     .ocd_ktap_left			(ocd_ktap_left),
     .ocd_ktap_right			(ocd_ktap_right),
     .oclk_center_write_resume		(oclk_center_write_resume),
     .oclkdelay_center_calib_done	(oclkdelay_center_calib_done),
     .oclkdelay_center_calib_start	(oclkdelay_center_calib_start),
     .scan_done				(scan_done),
     .scanning_right			(scanning_right),
     .simp_stg3_final_sel		(simp_stg3_final_sel[5:0]),
     .stg3				(stg3[5:0]),
     .taps_set				(taps_set),
     .use_noise_window			(use_noise_window),
     // Inputs
     .clk				(clk),
     .complex_oclkdelay_calib_start	(complex_oclkdelay_calib_start),
     .f2o				(f2o),
     .f2z				(f2z),
     .fuzz2oneeighty			(fuzz2oneeighty[5:0]),
     .fuzz2zero				(fuzz2zero[5:0]),
     .lim2ocal_stg3_left_lim		(lim2ocal_stg3_left_lim[5:0]),
     .lim2ocal_stg3_right_lim		(lim2ocal_stg3_right_lim[5:0]),
     .mmcm_edge_detect_done		(mmcm_edge_detect_done),
     .mmcm_lbclk_edge_aligned		(mmcm_lbclk_edge_aligned),
     .o2f				(o2f),
     .oclkdelay_calib_cnt		(oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
     .oclkdelay_init_val		(oclkdelay_init_val[5:0]),
     .oneeighty2fuzz			(oneeighty2fuzz[5:0]),
     .phy_rddata_en_3			(phy_rddata_en_3),
     .po_counter_read_val		(po_counter_read_val[8:0]),
     .po_rdy				(po_rdy),
     .poc_backup			(poc_backup),
     .reset_scan			(reset_scan),
     .rst				(rst),
     .samp_done				(samp_done),
     .scan_right			(scan_right),
     .wl_po_fine_cnt_sel		(wl_po_fine_cnt_sel[5:0]),
     .z2f				(z2f),
     .zero2fuzz				(zero2fuzz[5:0]));
  
   
endmodule // mig_7series_v4_2_ddr_phy_oclkdelay_cal

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-extensions:(".v")
// End:

