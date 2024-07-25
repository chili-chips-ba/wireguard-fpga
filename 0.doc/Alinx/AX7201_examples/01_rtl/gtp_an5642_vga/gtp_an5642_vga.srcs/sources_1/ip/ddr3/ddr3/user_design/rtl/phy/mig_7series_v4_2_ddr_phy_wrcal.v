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
// \   \   \/     Version:
//  \   \         Application: MIG
//  /   /         Filename: ddr_phy_wrcal.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:35:09 $
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  Write calibration logic to align DQS to correct CK edge
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_wrcal.v,v 1.1 2011/06/02 08:35:09 mishra Exp $
**$Date: 2011/06/02 08:35:09 $
**$Author:
**$Revision:
**$Source:
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_wrcal #
  (
   parameter TCQ             = 100,    // clk->out delay (sim only)
   parameter nCK_PER_CLK     = 2,      // # of memory clocks per CLK
   parameter CLK_PERIOD      = 2500,
   parameter DQ_WIDTH        = 64,     // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,      // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,      // # of DQS (strobe)
   parameter DRAM_WIDTH      = 8,      // # of DQ per DQS
   parameter PRE_REV3ES      = "OFF",  // Delay O/Ps using Phaser_Out fine dly
   parameter SIM_CAL_OPTION  = "NONE"  // Skip various calibration steps
   )
  (
   input                        clk,
   input                        rst,
   // Calibration status, control signals
   input                        wrcal_start,
   input                        wrcal_rd_wait,
   input                        wrcal_sanity_chk,
   input                        dqsfound_retry_done,
   input                        phy_rddata_en,
   output                       dqsfound_retry,
   output                       wrcal_read_req,
   output reg                   wrcal_act_req,
   output reg                   wrcal_done,
   output reg                   wrcal_pat_err,
   output reg                   wrcal_prech_req,
   output reg                   temp_wrcal_done,
   output reg                   wrcal_sanity_chk_done,
   input                        prech_done,
   // Captured data in resync clock domain
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] rd_data,
   // Write level values of Phaser_Out coarse and fine
   // delay taps required to load Phaser_Out register
   input [3*DQS_WIDTH-1:0]      wl_po_coarse_cnt,
   input [6*DQS_WIDTH-1:0]      wl_po_fine_cnt,
   input                        wrlvl_byte_done,
   output reg                   wrlvl_byte_redo,
   output reg                   early1_data,
   output reg                   early2_data,
   // DQ IDELAY
   output reg                   idelay_ld,
   output reg                   wrcal_pat_resume,   // to phy_init for write
   output reg [DQS_CNT_WIDTH:0] po_stg2_wrcal_cnt,
   output                       phy_if_reset,

   // Debug Port
   output [6*DQS_WIDTH-1:0]     dbg_final_po_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]     dbg_final_po_coarse_tap_cnt,
   output [99:0]                dbg_phy_wrcal
   );

  // Length of calibration sequence (in # of words)
  //localparam CAL_PAT_LEN = 8;

  // Read data shift register length
  localparam RD_SHIFT_LEN = 1; //(nCK_PER_CLK == 4) ? 1 : 2;

  // # of reads for reliable read capture
  localparam NUM_READS = 2;

  // # of cycles to wait after changing RDEN count value
  localparam RDEN_WAIT_CNT = 12;

  localparam  COARSE_CNT = (CLK_PERIOD/nCK_PER_CLK <= 2500) ? 3 : 6;
  localparam  FINE_CNT   = (CLK_PERIOD/nCK_PER_CLK <= 2500) ? 22 : 44;


  localparam CAL2_IDLE            = 4'h0;
  localparam CAL2_READ_WAIT       = 4'h1;
  localparam CAL2_NEXT_DQS        = 4'h2;
  localparam CAL2_WRLVL_WAIT      = 4'h3;
  localparam CAL2_IFIFO_RESET     = 4'h4;
  localparam CAL2_DQ_IDEL_DEC     = 4'h5;
  localparam CAL2_DONE            = 4'h6;
  localparam CAL2_SANITY_WAIT     = 4'h7;
  localparam CAL2_ERR             = 4'h8;

  integer                 i,j,k,l,m,p,q,d;

  reg [2:0]               po_coarse_tap_cnt [0:DQS_WIDTH-1];
  reg [3*DQS_WIDTH-1:0]   po_coarse_tap_cnt_w;
  reg [5:0]               po_fine_tap_cnt [0:DQS_WIDTH-1];
  reg [6*DQS_WIDTH-1:0]   po_fine_tap_cnt_w;
 reg [DQS_CNT_WIDTH:0] wrcal_dqs_cnt_r/* synthesis syn_maxfan = 10 */;
  reg [4:0]               not_empty_wait_cnt;
  reg [3:0]               tap_inc_wait_cnt;
  reg                     cal2_done_r;
  reg                     cal2_done_r1;
  reg                     cal2_prech_req_r;
  reg [3:0]               cal2_state_r;
  reg [3:0]               cal2_state_r1;
  reg [2:0]               wl_po_coarse_cnt_w [0:DQS_WIDTH-1];
  reg [5:0]               wl_po_fine_cnt_w [0:DQS_WIDTH-1];
  reg                     cal2_if_reset;
  reg                     wrcal_pat_resume_r;
  reg                     wrcal_pat_resume_r1;
  reg                     wrcal_pat_resume_r2;
  reg                     wrcal_pat_resume_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r;
  reg                     pat_data_match_r;
  reg                     pat1_data_match_r;
  reg                     pat1_data_match_r1;
  reg                     pat2_data_match_r;
  reg                     pat_data_match_valid_r;
  wire [RD_SHIFT_LEN-1:0] pat_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_fall3 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat2_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat2_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_fall3 [3:0];
  wire [RD_SHIFT_LEN-1:0] early1_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early1_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early2_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early2_fall1 [3:0];
  reg [DRAM_WIDTH-1:0]    pat_match_fall0_r;
  reg                     pat_match_fall0_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_fall1_r;
  reg                     pat_match_fall1_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_fall2_r;
  reg                     pat_match_fall2_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_fall3_r;
  reg                     pat_match_fall3_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_rise0_r;
  reg                     pat_match_rise0_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_rise1_r;
  reg                     pat_match_rise1_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_rise2_r;
  reg                     pat_match_rise2_and_r;
  reg [DRAM_WIDTH-1:0]    pat_match_rise3_r;
  reg                     pat_match_rise3_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall1_r;
  reg [DRAM_WIDTH-1:0]    pat2_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    pat2_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    pat2_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    pat2_match_fall1_r;
  reg                     pat1_match_rise0_and_r;
  reg                     pat1_match_rise1_and_r;
  reg                     pat1_match_fall0_and_r;
  reg                     pat1_match_fall1_and_r;
  reg                     pat2_match_rise0_and_r;
  reg                     pat2_match_rise1_and_r;
  reg                     pat2_match_fall0_and_r;
  reg                     pat2_match_fall1_and_r;
  reg                     early1_data_match_r;
  reg                     early1_data_match_r1;
  reg [DRAM_WIDTH-1:0]    early1_match_fall0_r;
  reg                     early1_match_fall0_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_fall1_r;
  reg                     early1_match_fall1_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_fall2_r;
  reg                     early1_match_fall2_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_fall3_r;
  reg                     early1_match_fall3_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_rise0_r;
  reg                     early1_match_rise0_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_rise1_r;
  reg                     early1_match_rise1_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_rise2_r;
  reg                     early1_match_rise2_and_r;
  reg [DRAM_WIDTH-1:0]    early1_match_rise3_r;
  reg                     early1_match_rise3_and_r;
  reg                     early2_data_match_r;
  reg [DRAM_WIDTH-1:0]    early2_match_fall0_r;
  reg                     early2_match_fall0_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_fall1_r;
  reg                     early2_match_fall1_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_fall2_r;
  reg                     early2_match_fall2_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_fall3_r;
  reg                     early2_match_fall3_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_rise0_r;
  reg                     early2_match_rise0_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_rise1_r;
  reg                     early2_match_rise1_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_rise2_r;
  reg                     early2_match_rise2_and_r;
  reg [DRAM_WIDTH-1:0]    early2_match_rise3_r;
  reg                     early2_match_rise3_and_r;
  wire [RD_SHIFT_LEN-1:0] pat_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat_rise3 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat2_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat2_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] early_rise3 [3:0];
  wire [RD_SHIFT_LEN-1:0] early1_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early1_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] early2_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] early2_rise1 [3:0];
  wire [DQ_WIDTH-1:0]     rd_data_rise0;
  wire [DQ_WIDTH-1:0]     rd_data_fall0;
  wire [DQ_WIDTH-1:0]     rd_data_rise1;
  wire [DQ_WIDTH-1:0]     rd_data_fall1;
  wire [DQ_WIDTH-1:0]     rd_data_rise2;
  wire [DQ_WIDTH-1:0]     rd_data_fall2;
  wire [DQ_WIDTH-1:0]     rd_data_rise3;
  wire [DQ_WIDTH-1:0]     rd_data_fall3;
  reg [DQS_CNT_WIDTH:0]   rd_mux_sel_r;
  reg                     rd_active_posedge_r;
  reg                     rd_active_r;
  reg                     rd_active_r1;
  reg                     rd_active_r2;
  reg                     rd_active_r3;
  reg                     rd_active_r4;
  reg                     rd_active_r5;
  reg [RD_SHIFT_LEN-1:0]  sr_fall0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall3_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise3_r [DRAM_WIDTH-1:0];
  reg                     wrlvl_byte_done_r;
  reg                     idelay_ld_done;
  reg                     pat1_detect;
  reg                     early1_detect;
  reg                     wrcal_sanity_chk_r;
  reg                     wrcal_sanity_chk_err;


  //***************************************************************************
  // Debug
  //***************************************************************************

  always @(*) begin
    for (d = 0; d < DQS_WIDTH; d = d + 1) begin
      po_fine_tap_cnt_w[(6*d)+:6]   = po_fine_tap_cnt[d];
      po_coarse_tap_cnt_w[(3*d)+:3] = po_coarse_tap_cnt[d];
    end
  end

  assign dbg_final_po_fine_tap_cnt   = po_fine_tap_cnt_w;
  assign dbg_final_po_coarse_tap_cnt = po_coarse_tap_cnt_w;

  generate
    if (nCK_PER_CLK == 4) begin: match_data_4
      assign dbg_phy_wrcal[0]    = pat_data_match_r;
    end else begin:match_data_2
      assign dbg_phy_wrcal[0]    = 1'b0;
    end
  endgenerate
  assign dbg_phy_wrcal[4:1]  = cal2_state_r1[3:0];
  assign dbg_phy_wrcal[5]    = wrcal_sanity_chk_err;
  assign dbg_phy_wrcal[6]    = wrcal_start;
  assign dbg_phy_wrcal[7]    = wrcal_done;
  assign dbg_phy_wrcal[8]    = pat_data_match_valid_r;
  assign dbg_phy_wrcal[13+:DQS_CNT_WIDTH]= wrcal_dqs_cnt_r;
  assign dbg_phy_wrcal[17+:5]  = not_empty_wait_cnt;
  assign dbg_phy_wrcal[22]     = early1_data;
  assign dbg_phy_wrcal[23]     = early2_data;
  assign dbg_phy_wrcal[24+:8]     = mux_rd_rise0_r;
  assign dbg_phy_wrcal[32+:8]     = mux_rd_fall0_r;
  assign dbg_phy_wrcal[40+:8]     = mux_rd_rise1_r;
  assign dbg_phy_wrcal[48+:8]     = mux_rd_fall1_r;
  generate
    if (nCK_PER_CLK == 4) begin: mux_data_4
      assign dbg_phy_wrcal[56+:8]     = mux_rd_rise2_r;
      assign dbg_phy_wrcal[64+:8]     = mux_rd_fall2_r;
      assign dbg_phy_wrcal[72+:8]     = mux_rd_rise3_r;
      assign dbg_phy_wrcal[80+:8]     = mux_rd_fall3_r;
    end else begin: mux_data_2
      assign dbg_phy_wrcal[56+:8] = {8{1'b0}};
      assign dbg_phy_wrcal[64+:8] = {8{1'b0}};
      assign dbg_phy_wrcal[72+:8] = {8{1'b0}};
      assign dbg_phy_wrcal[80+:8] = {8{1'b0}};
    end
  endgenerate
  assign dbg_phy_wrcal[88]     = early1_data_match_r;
  assign dbg_phy_wrcal[89]     = early2_data_match_r;
  assign dbg_phy_wrcal[90]     = wrcal_sanity_chk_r & pat_data_match_valid_r;
  assign dbg_phy_wrcal[91]     = wrcal_sanity_chk_r;
  assign dbg_phy_wrcal[92]     = wrcal_sanity_chk_done;

  assign dqsfound_retry        = 1'b0;
  assign wrcal_read_req        = 1'b0;
  assign phy_if_reset          = cal2_if_reset;

   //**************************************************************************
   // DQS count to hard PHY during write calibration using Phaser_OUT Stage2
   // coarse delay
   //**************************************************************************

   always @(posedge clk) begin
     po_stg2_wrcal_cnt  <= #TCQ wrcal_dqs_cnt_r;
     wrlvl_byte_done_r  <= #TCQ wrlvl_byte_done;
     wrcal_sanity_chk_r <= #TCQ wrcal_sanity_chk;
   end

  //***************************************************************************
  // Data mux to route appropriate byte to calibration logic - i.e. calibration
  // is done sequentially, one byte (or DQS group) at a time
  //***************************************************************************

  generate
    if (nCK_PER_CLK == 4) begin: gen_rd_data_div4
      assign rd_data_rise0 = rd_data[DQ_WIDTH-1:0];
      assign rd_data_fall0 = rd_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign rd_data_rise1 = rd_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign rd_data_fall1 = rd_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
      assign rd_data_rise2 = rd_data[5*DQ_WIDTH-1:4*DQ_WIDTH];
      assign rd_data_fall2 = rd_data[6*DQ_WIDTH-1:5*DQ_WIDTH];
      assign rd_data_rise3 = rd_data[7*DQ_WIDTH-1:6*DQ_WIDTH];
      assign rd_data_fall3 = rd_data[8*DQ_WIDTH-1:7*DQ_WIDTH];
    end else if (nCK_PER_CLK == 2) begin: gen_rd_data_div2
      assign rd_data_rise0 = rd_data[DQ_WIDTH-1:0];
      assign rd_data_fall0 = rd_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign rd_data_rise1 = rd_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign rd_data_fall1 = rd_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
    end
  endgenerate

  //**************************************************************************
  // Final Phaser OUT coarse and fine delay taps after write calibration
  // Sum of taps used during write leveling taps and write calibration
  //**************************************************************************

  always @(*) begin
    for (m = 0; m < DQS_WIDTH; m = m + 1) begin
      wl_po_coarse_cnt_w[m] = wl_po_coarse_cnt[3*m+:3];
      wl_po_fine_cnt_w[m]   = wl_po_fine_cnt[6*m+:6];
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      for (p = 0; p < DQS_WIDTH; p = p + 1) begin
        po_coarse_tap_cnt[p] <= #TCQ {3{1'b0}};
        po_fine_tap_cnt[p]   <= #TCQ {6{1'b0}};
      end
    end else if (cal2_done_r && ~cal2_done_r1) begin
      for (q = 0; q < DQS_WIDTH; q = q + 1) begin
        po_coarse_tap_cnt[q] <= #TCQ wl_po_coarse_cnt_w[i];
        po_fine_tap_cnt[q]   <= #TCQ wl_po_fine_cnt_w[i];
      end
    end
  end

  always @(posedge clk) begin
    rd_mux_sel_r <= #TCQ wrcal_dqs_cnt_r;
  end

  // Register outputs for improved timing.
  // NOTE: Will need to change when per-bit DQ deskew is supported.
  //       Currenly all bits in DQS group are checked in aggregate
  generate
    genvar mux_i;
    if (nCK_PER_CLK == 4) begin: gen_mux_rd_div4
      for (mux_i = 0; mux_i < DRAM_WIDTH; mux_i = mux_i + 1) begin: gen_mux_rd
        always @(posedge clk) begin
          mux_rd_rise0_r[mux_i] <= #TCQ rd_data_rise0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall0_r[mux_i] <= #TCQ rd_data_fall0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_rise1_r[mux_i] <= #TCQ rd_data_rise1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall1_r[mux_i] <= #TCQ rd_data_fall1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_rise2_r[mux_i] <= #TCQ rd_data_rise2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall2_r[mux_i] <= #TCQ rd_data_fall2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_rise3_r[mux_i] <= #TCQ rd_data_rise3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall3_r[mux_i] <= #TCQ rd_data_fall3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        end
      end
    end else if (nCK_PER_CLK == 2) begin: gen_mux_rd_div2
      for (mux_i = 0; mux_i < DRAM_WIDTH; mux_i = mux_i + 1) begin: gen_mux_rd
        always @(posedge clk) begin
          mux_rd_rise0_r[mux_i] <= #TCQ rd_data_rise0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall0_r[mux_i] <= #TCQ rd_data_fall0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_rise1_r[mux_i] <= #TCQ rd_data_rise1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
          mux_rd_fall1_r[mux_i] <= #TCQ rd_data_fall1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        end
      end
    end
  endgenerate

  //***************************************************************************
  // generate request to PHY_INIT logic to issue precharged. Required when
  // calibration can take a long time (during which there are only constant
  // reads present on this bus). In this case need to issue perioidic
  // precharges to avoid tRAS violation. This signal must meet the following
  // requirements: (1) only transition from 0->1 when prech is first needed,
  // (2) stay at 1 and only transition 1->0 when RDLVL_PRECH_DONE asserted
  //***************************************************************************

  always @(posedge clk)
    if (rst)
      wrcal_prech_req <= #TCQ 1'b0;
    else
      // Combine requests from all stages here
      wrcal_prech_req <= #TCQ cal2_prech_req_r;

  //***************************************************************************
  // Shift register to store last RDDATA_SHIFT_LEN cycles of data from ISERDES
  // NOTE: Written using discrete flops, but SRL can be used if the matching
  //   logic does the comparison sequentially, rather than parallel
  //***************************************************************************

  generate
    genvar rd_i;
    if (nCK_PER_CLK == 4) begin: gen_sr_div4
      for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
        always @(posedge clk) begin
          sr_rise0_r[rd_i] <= #TCQ mux_rd_rise0_r[rd_i];
          sr_fall0_r[rd_i] <= #TCQ mux_rd_fall0_r[rd_i];
          sr_rise1_r[rd_i] <= #TCQ mux_rd_rise1_r[rd_i];
          sr_fall1_r[rd_i] <= #TCQ mux_rd_fall1_r[rd_i];
          sr_rise2_r[rd_i] <= #TCQ mux_rd_rise2_r[rd_i];
          sr_fall2_r[rd_i] <= #TCQ mux_rd_fall2_r[rd_i];
          sr_rise3_r[rd_i] <= #TCQ mux_rd_rise3_r[rd_i];
          sr_fall3_r[rd_i] <= #TCQ mux_rd_fall3_r[rd_i];
        end
      end
    end else if (nCK_PER_CLK == 2) begin: gen_sr_div2
      for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
        always @(posedge clk) begin
          sr_rise0_r[rd_i] <= #TCQ mux_rd_rise0_r[rd_i];
          sr_fall0_r[rd_i] <= #TCQ mux_rd_fall0_r[rd_i];
          sr_rise1_r[rd_i] <= #TCQ mux_rd_rise1_r[rd_i];
          sr_fall1_r[rd_i] <= #TCQ mux_rd_fall1_r[rd_i];
        end
      end
    end
  endgenerate

 //***************************************************************************
  // Write calibration:
  // During write leveling DQS is aligned to the nearest CK edge that may not
  // be the correct CK edge. Write calibration is required to align the DQS to
  // the correct CK edge that clocks the write command.
  // The Phaser_Out coarse delay line is adjusted if required to add a memory
  // clock cycle of delay in order to read back the expected pattern.
  //***************************************************************************

  always @(posedge clk) begin
    rd_active_r         <= #TCQ phy_rddata_en;
    rd_active_r1        <= #TCQ rd_active_r;
    rd_active_r2        <= #TCQ rd_active_r1;
    rd_active_r3        <= #TCQ rd_active_r2;
    rd_active_r4        <= #TCQ rd_active_r3;
    rd_active_r5        <= #TCQ rd_active_r4;
  end

  //*****************************************************************
  // Expected data pattern when properly received by read capture
  // logic:
  // Based on pattern of ({rise,fall}) =
  //   0xF, 0x0, 0xA, 0x5, 0x5, 0xA, 0x9, 0x6
  // Each nibble will look like:
  //   bit3: 1, 0, 1, 0, 0, 1, 1, 0
  //   bit2: 1, 0, 0, 1, 1, 0, 0, 1
  //   bit1: 1, 0, 1, 0, 0, 1, 0, 1
  //   bit0: 1, 0, 0, 1, 1, 0, 1, 0
  // Change the hard-coded pattern below accordingly as RD_SHIFT_LEN
  // and the actual training pattern contents change
  //*****************************************************************

  generate
    if (nCK_PER_CLK == 4) begin: gen_pat_div4
    // FF00AA5555AA9966
      assign pat_rise0[3] = 1'b1;
      assign pat_fall0[3] = 1'b0;
      assign pat_rise1[3] = 1'b1;
      assign pat_fall1[3] = 1'b0;
      assign pat_rise2[3] = 1'b0;
      assign pat_fall2[3] = 1'b1;
      assign pat_rise3[3] = 1'b1;
      assign pat_fall3[3] = 1'b0;

      assign pat_rise0[2] = 1'b1;
      assign pat_fall0[2] = 1'b0;
      assign pat_rise1[2] = 1'b0;
      assign pat_fall1[2] = 1'b1;
      assign pat_rise2[2] = 1'b1;
      assign pat_fall2[2] = 1'b0;
      assign pat_rise3[2] = 1'b0;
      assign pat_fall3[2] = 1'b1;

      assign pat_rise0[1] = 1'b1;
      assign pat_fall0[1] = 1'b0;
      assign pat_rise1[1] = 1'b1;
      assign pat_fall1[1] = 1'b0;
      assign pat_rise2[1] = 1'b0;
      assign pat_fall2[1] = 1'b1;
      assign pat_rise3[1] = 1'b0;
      assign pat_fall3[1] = 1'b1;

      assign pat_rise0[0] = 1'b1;
      assign pat_fall0[0] = 1'b0;
      assign pat_rise1[0] = 1'b0;
      assign pat_fall1[0] = 1'b1;
      assign pat_rise2[0] = 1'b1;
      assign pat_fall2[0] = 1'b0;
      assign pat_rise3[0] = 1'b1;
      assign pat_fall3[0] = 1'b0;

      // Pattern to distinguish between early write and incorrect read
      // BB11EE4444EEDD88
      assign early_rise0[3] = 1'b1;
      assign early_fall0[3] = 1'b0;
      assign early_rise1[3] = 1'b1;
      assign early_fall1[3] = 1'b0;
      assign early_rise2[3] = 1'b0;
      assign early_fall2[3] = 1'b1;
      assign early_rise3[3] = 1'b1;
      assign early_fall3[3] = 1'b1;

      assign early_rise0[2] = 1'b0;
      assign early_fall0[2] = 1'b0;
      assign early_rise1[2] = 1'b1;
      assign early_fall1[2] = 1'b1;
      assign early_rise2[2] = 1'b1;
      assign early_fall2[2] = 1'b1;
      assign early_rise3[2] = 1'b1;
      assign early_fall3[2] = 1'b0;

      assign early_rise0[1] = 1'b1;
      assign early_fall0[1] = 1'b0;
      assign early_rise1[1] = 1'b1;
      assign early_fall1[1] = 1'b0;
      assign early_rise2[1] = 1'b0;
      assign early_fall2[1] = 1'b1;
      assign early_rise3[1] = 1'b0;
      assign early_fall3[1] = 1'b0;

      assign early_rise0[0] = 1'b1;
      assign early_fall0[0] = 1'b1;
      assign early_rise1[0] = 1'b0;
      assign early_fall1[0] = 1'b0;
      assign early_rise2[0] = 1'b0;
      assign early_fall2[0] = 1'b0;
      assign early_rise3[0] = 1'b1;
      assign early_fall3[0] = 1'b0;

    end else if (nCK_PER_CLK == 2) begin: gen_pat_div2
      // First cycle pattern FF00AA55
      assign pat1_rise0[3] = 1'b1;
      assign pat1_fall0[3] = 1'b0;
      assign pat1_rise1[3] = 1'b1;
      assign pat1_fall1[3] = 1'b0;

      assign pat1_rise0[2] = 1'b1;
      assign pat1_fall0[2] = 1'b0;
      assign pat1_rise1[2] = 1'b0;
      assign pat1_fall1[2] = 1'b1;

      assign pat1_rise0[1] = 1'b1;
      assign pat1_fall0[1] = 1'b0;
      assign pat1_rise1[1] = 1'b1;
      assign pat1_fall1[1] = 1'b0;

      assign pat1_rise0[0] = 1'b1;
      assign pat1_fall0[0] = 1'b0;
      assign pat1_rise1[0] = 1'b0;
      assign pat1_fall1[0] = 1'b1;

      // Second cycle pattern 55AA9966
      assign pat2_rise0[3] = 1'b0;
      assign pat2_fall0[3] = 1'b1;
      assign pat2_rise1[3] = 1'b1;
      assign pat2_fall1[3] = 1'b0;

      assign pat2_rise0[2] = 1'b1;
      assign pat2_fall0[2] = 1'b0;
      assign pat2_rise1[2] = 1'b0;
      assign pat2_fall1[2] = 1'b1;

      assign pat2_rise0[1] = 1'b0;
      assign pat2_fall0[1] = 1'b1;
      assign pat2_rise1[1] = 1'b0;
      assign pat2_fall1[1] = 1'b1;

      assign pat2_rise0[0] = 1'b1;
      assign pat2_fall0[0] = 1'b0;
      assign pat2_rise1[0] = 1'b1;
      assign pat2_fall1[0] = 1'b0;

      //Pattern to distinguish between early write and incorrect read
      // First cycle pattern AA5555AA
      assign early1_rise0[3] = 2'b1;
      assign early1_fall0[3] = 2'b0;
      assign early1_rise1[3] = 2'b0;
      assign early1_fall1[3] = 2'b1;

      assign early1_rise0[2] = 2'b0;
      assign early1_fall0[2] = 2'b1;
      assign early1_rise1[2] = 2'b1;
      assign early1_fall1[2] = 2'b0;

      assign early1_rise0[1] = 2'b1;
      assign early1_fall0[1] = 2'b0;
      assign early1_rise1[1] = 2'b0;
      assign early1_fall1[1] = 2'b1;

      assign early1_rise0[0] = 2'b0;
      assign early1_fall0[0] = 2'b1;
      assign early1_rise1[0] = 2'b1;
      assign early1_fall1[0] = 2'b0;

      // Second cycle pattern 9966BB11
      assign early2_rise0[3] = 2'b1;
      assign early2_fall0[3] = 2'b0;
      assign early2_rise1[3] = 2'b1;
      assign early2_fall1[3] = 2'b0;

      assign early2_rise0[2] = 2'b0;
      assign early2_fall0[2] = 2'b1;
      assign early2_rise1[2] = 2'b0;
      assign early2_fall1[2] = 2'b0;

      assign early2_rise0[1] = 2'b0;
      assign early2_fall0[1] = 2'b1;
      assign early2_rise1[1] = 2'b1;
      assign early2_fall1[1] = 2'b0;

      assign early2_rise0[0] = 2'b1;
      assign early2_fall0[0] = 2'b0;
      assign early2_rise1[0] = 2'b1;
      assign early2_fall1[0] = 2'b1;
    end
  endgenerate

  // Each bit of each byte is compared to expected pattern.
  // This was done to prevent (and "drastically decrease") the chance that
  // invalid data clocked in when the DQ bus is tri-state (along with a
  // combination of the correct data) will resemble the expected data
  // pattern. A better fix for this is to change the training pattern and/or
  // make the pattern longer.
  generate
    genvar pt_i;
    if (nCK_PER_CLK == 4) begin: gen_pat_match_div4
      for (pt_i = 0; pt_i < DRAM_WIDTH; pt_i = pt_i + 1) begin: gen_pat_match
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat_rise0[pt_i%4])
            pat_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat_fall0[pt_i%4])
            pat_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat_rise1[pt_i%4])
            pat_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat_fall1[pt_i%4])
            pat_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == pat_rise2[pt_i%4])
            pat_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == pat_fall2[pt_i%4])
            pat_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == pat_rise3[pt_i%4])
            pat_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == pat_fall3[pt_i%4])
            pat_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            pat_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat_rise1[pt_i%4])
            early1_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat_fall1[pt_i%4])
            early1_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat_rise2[pt_i%4])
            early1_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat_fall2[pt_i%4])
            early1_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == pat_rise3[pt_i%4])
            early1_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == pat_fall3[pt_i%4])
            early1_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == early_rise0[pt_i%4])
            early1_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == early_fall0[pt_i%4])
            early1_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat_rise2[pt_i%4])
            early2_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat_fall2[pt_i%4])
            early2_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat_rise3[pt_i%4])
            early2_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat_fall3[pt_i%4])
            early2_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == early_rise0[pt_i%4])
            early2_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == early_fall0[pt_i%4])
            early2_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == early_rise1[pt_i%4])
            early2_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == early_fall1[pt_i%4])
            early2_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end
      end


       always @(posedge clk) begin
         pat_match_rise0_and_r <= #TCQ &pat_match_rise0_r;
         pat_match_fall0_and_r <= #TCQ &pat_match_fall0_r;
         pat_match_rise1_and_r <= #TCQ &pat_match_rise1_r;
         pat_match_fall1_and_r <= #TCQ &pat_match_fall1_r;
         pat_match_rise2_and_r <= #TCQ &pat_match_rise2_r;
         pat_match_fall2_and_r <= #TCQ &pat_match_fall2_r;
         pat_match_rise3_and_r <= #TCQ &pat_match_rise3_r;
         pat_match_fall3_and_r <= #TCQ &pat_match_fall3_r;
         pat_data_match_r <= #TCQ (pat_match_rise0_and_r &&
                                   pat_match_fall0_and_r &&
                                   pat_match_rise1_and_r &&
                                   pat_match_fall1_and_r &&
                                   pat_match_rise2_and_r &&
                                   pat_match_fall2_and_r &&
                                   pat_match_rise3_and_r &&
                                   pat_match_fall3_and_r);
         pat_data_match_valid_r <= #TCQ rd_active_r3;
       end

       always @(posedge clk) begin
         early1_match_rise0_and_r <= #TCQ &early1_match_rise0_r;
         early1_match_fall0_and_r <= #TCQ &early1_match_fall0_r;
         early1_match_rise1_and_r <= #TCQ &early1_match_rise1_r;
         early1_match_fall1_and_r <= #TCQ &early1_match_fall1_r;
         early1_match_rise2_and_r <= #TCQ &early1_match_rise2_r;
         early1_match_fall2_and_r <= #TCQ &early1_match_fall2_r;
         early1_match_rise3_and_r <= #TCQ &early1_match_rise3_r;
         early1_match_fall3_and_r <= #TCQ &early1_match_fall3_r;
         early1_data_match_r <= #TCQ (early1_match_rise0_and_r &&
                                   early1_match_fall0_and_r &&
                                   early1_match_rise1_and_r &&
                                   early1_match_fall1_and_r &&
                                   early1_match_rise2_and_r &&
                                   early1_match_fall2_and_r &&
                                   early1_match_rise3_and_r &&
                                   early1_match_fall3_and_r);
       end

       always @(posedge clk) begin
         early2_match_rise0_and_r <= #TCQ &early2_match_rise0_r;
         early2_match_fall0_and_r <= #TCQ &early2_match_fall0_r;
         early2_match_rise1_and_r <= #TCQ &early2_match_rise1_r;
         early2_match_fall1_and_r <= #TCQ &early2_match_fall1_r;
         early2_match_rise2_and_r <= #TCQ &early2_match_rise2_r;
         early2_match_fall2_and_r <= #TCQ &early2_match_fall2_r;
         early2_match_rise3_and_r <= #TCQ &early2_match_rise3_r;
         early2_match_fall3_and_r <= #TCQ &early2_match_fall3_r;
         early2_data_match_r <= #TCQ (early2_match_rise0_and_r &&
                                   early2_match_fall0_and_r &&
                                   early2_match_rise1_and_r &&
                                   early2_match_fall1_and_r &&
                                   early2_match_rise2_and_r &&
                                   early2_match_fall2_and_r &&
                                   early2_match_rise3_and_r &&
                                   early2_match_fall3_and_r);
       end

    end else if (nCK_PER_CLK == 2) begin: gen_pat_match_div2

      for (pt_i = 0; pt_i < DRAM_WIDTH; pt_i = pt_i + 1) begin: gen_pat_match
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat1_rise0[pt_i%4])
            pat1_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat1_fall0[pt_i%4])
            pat1_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat1_rise1[pt_i%4])
            pat1_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat1_fall1[pt_i%4])
            pat1_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat2_rise0[pt_i%4])
            pat2_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            pat2_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat2_fall0[pt_i%4])
            pat2_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            pat2_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat2_rise1[pt_i%4])
            pat2_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            pat2_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat2_fall1[pt_i%4])
            pat2_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            pat2_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == early1_rise0[pt_i%4])
            early1_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == early1_fall0[pt_i%4])
            early1_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == early1_rise1[pt_i%4])
            early1_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == early1_fall1[pt_i%4])
            early1_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            early1_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

        // early2 in this case does not mean 2 cycles early but
        // the second cycle of read data in 2:1 mode
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == early2_rise0[pt_i%4])
            early2_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == early2_fall0[pt_i%4])
            early2_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == early2_rise1[pt_i%4])
            early2_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == early2_fall1[pt_i%4])
            early2_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            early2_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end
      end

        always @(posedge clk) begin
          pat1_match_rise0_and_r <= #TCQ &pat1_match_rise0_r;
          pat1_match_fall0_and_r <= #TCQ &pat1_match_fall0_r;
          pat1_match_rise1_and_r <= #TCQ &pat1_match_rise1_r;
          pat1_match_fall1_and_r <= #TCQ &pat1_match_fall1_r;
          pat1_data_match_r <= #TCQ (pat1_match_rise0_and_r &&
                                    pat1_match_fall0_and_r &&
                                    pat1_match_rise1_and_r &&
                                    pat1_match_fall1_and_r);
          pat1_data_match_r1     <= #TCQ pat1_data_match_r;

          pat2_match_rise0_and_r <= #TCQ &pat2_match_rise0_r && rd_active_r3;
          pat2_match_fall0_and_r <= #TCQ &pat2_match_fall0_r && rd_active_r3;
          pat2_match_rise1_and_r <= #TCQ &pat2_match_rise1_r && rd_active_r3;
          pat2_match_fall1_and_r <= #TCQ &pat2_match_fall1_r && rd_active_r3;
          pat2_data_match_r <= #TCQ (pat2_match_rise0_and_r &&
                                    pat2_match_fall0_and_r &&
                                    pat2_match_rise1_and_r &&
                                    pat2_match_fall1_and_r);

          // For 2:1 mode, read valid is asserted for 2 clock cycles -
          // here we generate a "match valid" pulse that is only 1 clock
          // cycle wide that is simulatenous when the match calculation
          // is complete
          pat_data_match_valid_r <= #TCQ rd_active_r4 & ~rd_active_r5;
        end

        always @(posedge clk) begin
         early1_match_rise0_and_r <= #TCQ &early1_match_rise0_r;
         early1_match_fall0_and_r <= #TCQ &early1_match_fall0_r;
         early1_match_rise1_and_r <= #TCQ &early1_match_rise1_r;
         early1_match_fall1_and_r <= #TCQ &early1_match_fall1_r;
         early1_data_match_r <= #TCQ (early1_match_rise0_and_r &&
                                      early1_match_fall0_and_r &&
                                      early1_match_rise1_and_r &&
                                      early1_match_fall1_and_r);
         early1_data_match_r1 <= #TCQ early1_data_match_r;

         early2_match_rise0_and_r <= #TCQ &early2_match_rise0_r && rd_active_r3;
         early2_match_fall0_and_r <= #TCQ &early2_match_fall0_r && rd_active_r3;
         early2_match_rise1_and_r <= #TCQ &early2_match_rise1_r && rd_active_r3;
         early2_match_fall1_and_r <= #TCQ &early2_match_fall1_r && rd_active_r3;
         early2_data_match_r <= #TCQ (early2_match_rise0_and_r &&
                                      early2_match_fall0_and_r &&
                                      early2_match_rise1_and_r &&
                                      early2_match_fall1_and_r);
       end

    end
  endgenerate

  // Need to delay it by 3 cycles in order to wait for Phaser_Out
  // coarse delay to take effect before issuing a write command
  always @(posedge clk) begin
    wrcal_pat_resume_r1 <= #TCQ wrcal_pat_resume_r;
    wrcal_pat_resume_r2 <= #TCQ wrcal_pat_resume_r1;
    wrcal_pat_resume    <= #TCQ wrcal_pat_resume_r2;
  end

  always @(posedge clk) begin
    if (rst)
      tap_inc_wait_cnt <= #TCQ 'd0;
    else if ((cal2_state_r == CAL2_DQ_IDEL_DEC) ||
             (cal2_state_r == CAL2_IFIFO_RESET) ||
             (cal2_state_r == CAL2_SANITY_WAIT))
      tap_inc_wait_cnt <= #TCQ tap_inc_wait_cnt + 1;
    else
      tap_inc_wait_cnt <= #TCQ 'd0;
  end

  always @(posedge clk) begin
    if (rst)
      not_empty_wait_cnt <= #TCQ 'd0;
    else if ((cal2_state_r == CAL2_READ_WAIT) && wrcal_rd_wait)
      not_empty_wait_cnt <= #TCQ not_empty_wait_cnt + 1;
    else
      not_empty_wait_cnt <= #TCQ 'd0;
  end

  always @(posedge clk)
    cal2_state_r1 <= #TCQ cal2_state_r;

  //*****************************************************************
  // Write Calibration state machine
  //*****************************************************************

  // when calibrating, check to see if the expected pattern is received.
  // Otherwise delay DQS to align to correct CK edge.
  // NOTES:
  //  1. An error condition can occur due to two reasons:
  //    a. If the matching logic does not receive the expected data
  //       pattern. However, the error may be "recoverable" because
  //       the write calibration is still in progress. If an error is
  //       found the write calibration logic delays DQS by an additional
  //       clock cycle and restarts the pattern detection process.
  //       By design, if the write path timing is incorrect, the correct
  //       data pattern will never be detected.
  //    b. Valid data not found even after incrementing Phaser_Out
  //       coarse delay line.


  always @(posedge clk) begin
    if (rst) begin
      wrcal_dqs_cnt_r       <= #TCQ 'b0;
      cal2_done_r           <= #TCQ 1'b0;
      cal2_prech_req_r      <= #TCQ 1'b0;
      cal2_state_r          <= #TCQ CAL2_IDLE;
      wrcal_pat_err         <= #TCQ 1'b0;
      wrcal_pat_resume_r    <= #TCQ 1'b0;
      wrcal_act_req         <= #TCQ 1'b0;
      cal2_if_reset         <= #TCQ 1'b0;
      temp_wrcal_done       <= #TCQ 1'b0;
      wrlvl_byte_redo       <= #TCQ 1'b0;
      early1_data           <= #TCQ 1'b0;
      early2_data           <= #TCQ 1'b0;
      idelay_ld             <= #TCQ 1'b0;
      idelay_ld_done        <= #TCQ 1'b0;
      pat1_detect           <= #TCQ 1'b0;
      early1_detect         <= #TCQ 1'b0;
      wrcal_sanity_chk_done <= #TCQ 1'b0;
      wrcal_sanity_chk_err  <= #TCQ 1'b0;
    end else begin
      cal2_prech_req_r <= #TCQ 1'b0;
      case (cal2_state_r)
        CAL2_IDLE: begin
          wrcal_pat_err         <= #TCQ 1'b0;
          if (wrcal_start) begin
            cal2_if_reset  <= #TCQ 1'b0;
            if (SIM_CAL_OPTION == "SKIP_CAL")
              // If skip write calibration, then proceed to end.
              cal2_state_r <= #TCQ CAL2_DONE;
            else
              cal2_state_r <= #TCQ CAL2_READ_WAIT;
          end
        end

        // General wait state to wait for read data to be output by the
        // IN_FIFO
        CAL2_READ_WAIT: begin
          wrcal_pat_resume_r <= #TCQ 1'b0;
          cal2_if_reset      <= #TCQ 1'b0;
          // Wait until read data is received, and pattern matching
          // calculation is complete. NOTE: Need to add a timeout here
          // in case for some reason data is never received (or rather
          // the PHASER_IN and IN_FIFO think they never receives data)
          if (pat_data_match_valid_r && (nCK_PER_CLK == 4)) begin
            if (pat_data_match_r)
              // If found data match, then move on to next DQS group
              cal2_state_r <= #TCQ CAL2_NEXT_DQS;
            else begin
              if (wrcal_sanity_chk_r)
                cal2_state_r <= #TCQ CAL2_ERR;
              // If writes are one or two cycles early then redo
              // write leveling for the byte
              else if (early1_data_match_r) begin
                early1_data <= #TCQ 1'b1;
                early2_data <= #TCQ 1'b0;
                wrlvl_byte_redo <= #TCQ 1'b1;
                cal2_state_r    <= #TCQ CAL2_WRLVL_WAIT;
              end else if (early2_data_match_r) begin
                early1_data <= #TCQ 1'b0;
                early2_data <= #TCQ 1'b1;
                wrlvl_byte_redo <= #TCQ 1'b1;
                cal2_state_r    <= #TCQ CAL2_WRLVL_WAIT;
              // Read late due to incorrect MPR idelay value
              // Decrement Idelay to '0'for the current byte
              end else if (~idelay_ld_done) begin
                cal2_state_r <= #TCQ CAL2_DQ_IDEL_DEC;
                idelay_ld    <= #TCQ 1'b1;
              end else
                cal2_state_r <= #TCQ CAL2_ERR;
            end
          end else if (pat_data_match_valid_r && (nCK_PER_CLK == 2)) begin
            if ((pat1_data_match_r1 && pat2_data_match_r) ||
                (pat1_detect && pat2_data_match_r))
              // If found data match, then move on to next DQS group
              cal2_state_r <= #TCQ CAL2_NEXT_DQS;
            else if (pat1_data_match_r1 && ~pat2_data_match_r) begin
              cal2_state_r <= #TCQ CAL2_READ_WAIT;
              pat1_detect  <= #TCQ 1'b1;
            end else begin
              // If writes are one or two cycles early then redo
              // write leveling for the byte
              if (wrcal_sanity_chk_r)
                cal2_state_r <= #TCQ CAL2_ERR;
              else if ((early1_data_match_r1 && early2_data_match_r) ||
                  (early1_detect && early2_data_match_r)) begin
                early1_data <= #TCQ 1'b1;
                early2_data <= #TCQ 1'b0;
                wrlvl_byte_redo <= #TCQ 1'b1;
                cal2_state_r    <= #TCQ CAL2_WRLVL_WAIT;
              end else if (early1_data_match_r1 && ~early2_data_match_r) begin
                early1_detect <= #TCQ 1'b1;
                cal2_state_r  <= #TCQ CAL2_READ_WAIT;
              // Read late due to incorrect MPR idelay value
              // Decrement Idelay to '0'for the current byte
              end else if (~idelay_ld_done) begin
                cal2_state_r <= #TCQ CAL2_DQ_IDEL_DEC;
                idelay_ld    <= #TCQ 1'b1;
              end else
                cal2_state_r <= #TCQ CAL2_ERR;
            end
          end else if (not_empty_wait_cnt == 'd31)
            cal2_state_r <= #TCQ CAL2_ERR;
        end

        CAL2_WRLVL_WAIT: begin
          early1_detect <= #TCQ 1'b0;
          if (wrlvl_byte_done && ~wrlvl_byte_done_r)
            wrlvl_byte_redo   <= #TCQ 1'b0;
          if (wrlvl_byte_done) begin
            if (rd_active_r1 && ~rd_active_r) begin
            cal2_state_r  <= #TCQ CAL2_IFIFO_RESET;
            cal2_if_reset <= #TCQ 1'b1;
            early1_data   <= #TCQ 1'b0;
            early2_data   <= #TCQ 1'b0;
          end
        end
        end

        CAL2_DQ_IDEL_DEC: begin
          if (tap_inc_wait_cnt == 'd4) begin
            idelay_ld      <= #TCQ 1'b0;
            cal2_state_r   <= #TCQ CAL2_IFIFO_RESET;
            cal2_if_reset  <= #TCQ 1'b1;
            idelay_ld_done <= #TCQ 1'b1;
          end
        end

        CAL2_IFIFO_RESET: begin
          if (tap_inc_wait_cnt == 'd15) begin
            cal2_if_reset      <= #TCQ 1'b0;
            if (wrcal_sanity_chk_r)
              cal2_state_r       <= #TCQ CAL2_DONE;
            else if (idelay_ld_done) begin
              wrcal_pat_resume_r <= #TCQ 1'b1;
              cal2_state_r       <= #TCQ CAL2_READ_WAIT;
            end else
              cal2_state_r       <= #TCQ CAL2_IDLE;
          end
        end

        // Final processing for current DQS group. Move on to next group
        CAL2_NEXT_DQS: begin
          // At this point, we've just found the correct pattern for the
          // current DQS group.

          // Request bank/row precharge, and wait for its completion. Always
          // precharge after each DQS group to avoid tRAS(max) violation
                    //verilint STARC-2.2.3.3 off
          if (wrcal_sanity_chk_r && (wrcal_dqs_cnt_r != DQS_WIDTH-1)) begin
            cal2_prech_req_r   <= #TCQ 1'b0;
            wrcal_dqs_cnt_r    <= #TCQ wrcal_dqs_cnt_r + 1;
            cal2_state_r       <= #TCQ CAL2_SANITY_WAIT;
          end else
            cal2_prech_req_r  <= #TCQ 1'b1;
          idelay_ld_done    <= #TCQ 1'b0;
          pat1_detect       <= #TCQ 1'b0;
          if (prech_done)
            if (((DQS_WIDTH == 1) || (SIM_CAL_OPTION == "FAST_CAL")) ||
                (wrcal_dqs_cnt_r == DQS_WIDTH-1)) begin
              // If either FAST_CAL is enabled and first DQS group is
              // finished, or if the last DQS group was just finished,
              // then end of write calibration
              if (wrcal_sanity_chk_r) begin
                cal2_if_reset    <= #TCQ 1'b1;
                cal2_state_r     <= #TCQ CAL2_IFIFO_RESET;
              end else
                cal2_state_r     <= #TCQ CAL2_DONE;
            end else begin
              // Continue to next DQS group
              wrcal_dqs_cnt_r    <= #TCQ wrcal_dqs_cnt_r + 1;
              cal2_state_r       <= #TCQ CAL2_READ_WAIT;
            end
        end
    //verilint STARC-2.2.3.3 on
        CAL2_SANITY_WAIT: begin
          if (tap_inc_wait_cnt == 'd15) begin
            cal2_state_r       <= #TCQ CAL2_READ_WAIT;
            wrcal_pat_resume_r <= #TCQ 1'b1;
          end
        end

        // Finished with read enable calibration
        CAL2_DONE: begin
          if (wrcal_sanity_chk && ~wrcal_sanity_chk_r) begin
            cal2_done_r     <= #TCQ 1'b0;
            wrcal_dqs_cnt_r <= #TCQ 'd0;
            cal2_state_r    <= #TCQ CAL2_IDLE;
          end else
            cal2_done_r      <= #TCQ 1'b1;
            cal2_prech_req_r <= #TCQ 1'b0;
            cal2_if_reset    <= #TCQ 1'b0;
            if (wrcal_sanity_chk_r)
              wrcal_sanity_chk_done <= #TCQ 1'b1;
        end

        // Assert error signal indicating that writes timing is incorrect
        CAL2_ERR: begin
          wrcal_pat_resume_r <= #TCQ 1'b0;
          if (wrcal_sanity_chk_r)
            wrcal_sanity_chk_err <= #TCQ 1'b1;
          else
            wrcal_pat_err      <= #TCQ 1'b1;
          cal2_state_r       <= #TCQ CAL2_ERR;
        end
      endcase
    end
  end

  // Delay assertion of wrcal_done for write calibration by a few cycles after
  // we've reached CAL2_DONE
  always @(posedge clk)
    if (rst)
      cal2_done_r1  <= #TCQ 1'b0;
    else
      cal2_done_r1  <= #TCQ cal2_done_r;

  always @(posedge clk)
    if (rst || (wrcal_sanity_chk && ~wrcal_sanity_chk_r))
      wrcal_done <= #TCQ 1'b0;
    else if (cal2_done_r)
      wrcal_done <= #TCQ 1'b1;

endmodule

