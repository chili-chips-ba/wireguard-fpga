//*****************************************************************************
// (c) Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
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
//  /   /         Filename: ddr_phy_rdlvl.v
// /___/   /\     Date Last Modified: $Date: 2011/06/24 14:49:00 $
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  Read leveling Stage1 calibration logic
//  NOTES:
//    1. Window detection with PRBS pattern.
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_rdlvl.v,v 1.2 2011/06/24 14:49:00 mgeorge Exp $
**$Date: 2011/06/24 14:49:00 $
**$Author: mgeorge $
**$Revision: 1.2 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_phy_rdlvl.v,v $
******************************************************************************/

`timescale 1ps/1ps

(* use_dsp48 = "no" *)

module mig_7series_v4_2_ddr_phy_rdlvl #
  (
   parameter TCQ             = 100,    // clk->out delay (sim only)
   parameter nCK_PER_CLK     = 2,      // # of memory clocks per CLK
   parameter CLK_PERIOD      = 3333,   // Internal clock period (in ps)
   parameter DQ_WIDTH        = 64,     // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,      // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,      // # of DQS (strobe)
   parameter DRAM_WIDTH      = 8,      // # of DQ per DQS
   parameter RANKS           = 1,      // # of DRAM ranks
   parameter PER_BIT_DESKEW  = "ON",   // Enable per-bit DQ deskew
   parameter SIM_CAL_OPTION  = "NONE", // Skip various calibration steps
   parameter DEBUG_PORT      = "OFF",  // Enable debug port
   parameter DRAM_TYPE       = "DDR3",  // Memory I/F type: "DDR3", "DDR2"
   parameter OCAL_EN         = "ON",
   parameter IDELAY_ADJ      = "ON",
   parameter PI_DIV2_INCDEC  = "TRUE"
   )
  (
   input                        clk,
   input                        rst,
   // Calibration status, control signals
   input                        mpr_rdlvl_start,
   output                       mpr_rdlvl_done,
   output reg                   mpr_last_byte_done,
   output                       mpr_rnk_done,
   input                        rdlvl_stg1_start,
   output                       rdlvl_stg1_done /* synthesis syn_maxfan = 30 */,
   output                       rdlvl_stg1_rnk_done,
   output reg                   rdlvl_stg1_err,
   output                       mpr_rdlvl_err,
   output                       rdlvl_err,
   output reg                   rdlvl_prech_req,
   output                       rdlvl_last_byte_done,
   output reg                   rdlvl_assrt_common,
   input                        prech_done,
   input                        phy_if_empty,
   input [4:0]                  idelaye2_init_val,
   // Captured data in fabric clock domain
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] rd_data,
   // Decrement initial Phaser_IN Fine tap delay
   input                        dqs_po_dec_done,
   input [5:0]                  pi_counter_read_val,
   // Stage 1 calibration outputs
   output reg                   pi_fine_dly_dec_done,
   output reg                   pi_en_stg2_f,
   output reg                   pi_stg2_f_incdec,
   output reg                   pi_stg2_load,
   output reg [5:0]             pi_stg2_reg_l,
   output [DQS_CNT_WIDTH:0]     pi_stg2_rdlvl_cnt,
   // To DQ IDELAY required to find left edge of
   // valid window
   output                       idelay_ce,
   output                       idelay_inc,
   input                        idelay_ld,
   input [DQS_CNT_WIDTH:0]      wrcal_cnt,
   // Only output if Per-bit de-skew enabled
   output reg [5*RANKS*DQ_WIDTH-1:0] dlyval_dq,
   //output to prevent read during PI movement
   output reg                     rdlvl_pi_incdec,
   // Debug Port
   output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_first_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_second_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_tap_cnt,
   output [5*DQS_WIDTH*RANKS-1:0] dbg_dq_idelay_tap_cnt,

   input                        dbg_idel_up_all,
   input                        dbg_idel_down_all,
   input                        dbg_idel_up_cpt,
   input                        dbg_idel_down_cpt,
   input [DQS_CNT_WIDTH-1:0]    dbg_sel_idel_cpt,
   input                        dbg_sel_all_idel_cpt,
   output [255:0]               dbg_phy_rdlvl
   );

  // minimum time (in IDELAY taps) for which capture data must be stable for
  // algorithm to consider a valid data eye to be found. The read leveling
  // logic will ignore any window found smaller than this value. Limitations
  // on how small this number can be is determined by: (1) the algorithmic
  // limitation of how many taps wide the data eye can be (3 taps), and (2)
  // how wide regions of "instability" that occur around the edges of the
  // read valid window can be (i.e. need to be able to filter out "false"
  // windows that occur for a short # of taps around the edges of the true
  // data window, although with multi-sampling during read leveling, this is
  // not as much a concern) - the larger the value, the more protection
  // against "false" windows
  localparam MIN_EYE_SIZE = 16;

  // Length of calibration sequence (in # of words)
  localparam CAL_PAT_LEN = 8;
  // Read data shift register length
  localparam RD_SHIFT_LEN = CAL_PAT_LEN / (2*nCK_PER_CLK);

  // # of cycles required to perform read data shift register compare
  // This is defined as from the cycle the new data is loaded until
  // signal found_edge_r is valid
  localparam RD_SHIFT_COMP_DELAY = 5;

  // worst-case # of cycles to wait to ensure that both the SR and
  // PREV_SR shift registers have valid data, and that the comparison
  // of the two shift register values is valid. The "+1" at the end of
  // this equation is a fudge factor, I freely admit that
  localparam SR_VALID_DELAY = (2 * RD_SHIFT_LEN) + RD_SHIFT_COMP_DELAY + 1;

  // # of clock cycles to wait after changing tap value or read data MUX
  // to allow: (1) tap chain to settle, (2) for delayed input to propagate
  // thru ISERDES, (3) for the read data comparison logic to have time to
  // output the comparison of two consecutive samples of the settled read data
  // The minimum delay is 16 cycles, which should be good enough to handle all
  // three of the above conditions for the simulation-only case with a short
  // training pattern. For H/W (or for simulation with longer training
  // pattern), it will take longer to store and compare two consecutive
  // samples, and the value of this parameter will reflect that
  // put the maximum number for 2:1 mode
  localparam PIPE_WAIT_CNT = (nCK_PER_CLK == 2) ? 31 : (SR_VALID_DELAY < 8) ? 16
                                                     : (SR_VALID_DELAY + 8);

  // # of read data samples to examine when detecting whether an edge has
  // occured during stage 1 calibration. Width of local param must be
  // changed as appropriate. Note that there are two counters used, each
  // counter can be changed independently of the other - they are used in
  // cascade to create a larger counter
  localparam [11:0] DETECT_EDGE_SAMPLE_CNT0 = 12'h001; //12'hFFF;
  localparam [11:0] DETECT_EDGE_SAMPLE_CNT1 = 12'h001;   // 12'h1FF Must be > 0

  localparam [5:0] CAL1_IDLE                 = 6'h00;
  localparam [5:0] CAL1_NEW_DQS_WAIT         = 6'h01;
  localparam [5:0] CAL1_STORE_FIRST_WAIT     = 6'h02;
  localparam [5:0] CAL1_PAT_DETECT           = 6'h03;
  localparam [5:0] CAL1_DQ_IDEL_TAP_INC      = 6'h04;
  localparam [5:0] CAL1_DQ_IDEL_TAP_INC_WAIT = 6'h05;
  localparam [5:0] CAL1_DQ_IDEL_TAP_DEC      = 6'h06;
  localparam [5:0] CAL1_DQ_IDEL_TAP_DEC_WAIT = 6'h07;
  localparam [5:0] CAL1_DETECT_EDGE          = 6'h08;
  localparam [5:0] CAL1_IDEL_INC_CPT         = 6'h09;
  localparam [5:0] CAL1_IDEL_INC_CPT_WAIT    = 6'h0A;
  localparam [5:0] CAL1_CALC_IDEL            = 6'h0B;
  localparam [5:0] CAL1_IDEL_DEC_CPT         = 6'h0C;
  localparam [5:0] CAL1_IDEL_DEC_CPT_WAIT    = 6'h0D;
  localparam [5:0] CAL1_NEXT_DQS             = 6'h0E;
  localparam [5:0] CAL1_DONE                 = 6'h0F;
  localparam [5:0] CAL1_PB_STORE_FIRST_WAIT  = 6'h10;
  localparam [5:0] CAL1_PB_DETECT_EDGE       = 6'h11;
  localparam [5:0] CAL1_PB_INC_CPT           = 6'h12;
  localparam [5:0] CAL1_PB_INC_CPT_WAIT      = 6'h13;
  localparam [5:0] CAL1_PB_DEC_CPT_LEFT      = 6'h14;
  localparam [5:0] CAL1_PB_DEC_CPT_LEFT_WAIT = 6'h15;
  localparam [5:0] CAL1_PB_DETECT_EDGE_DQ    = 6'h16;
  localparam [5:0] CAL1_PB_INC_DQ            = 6'h17;
  localparam [5:0] CAL1_PB_INC_DQ_WAIT       = 6'h18;
  localparam [5:0] CAL1_PB_DEC_CPT           = 6'h19;
  localparam [5:0] CAL1_PB_DEC_CPT_WAIT      = 6'h1A;
  localparam [5:0] CAL1_REGL_LOAD            = 6'h1B;
  localparam [5:0] CAL1_RDLVL_ERR            = 6'h1C;
  localparam [5:0] CAL1_MPR_NEW_DQS_WAIT     = 6'h1D;
  localparam [5:0] CAL1_VALID_WAIT           = 6'h1E;
  localparam [5:0] CAL1_MPR_PAT_DETECT       = 6'h1F;
  localparam [5:0] CAL1_NEW_DQS_PREWAIT      = 6'h20;
  localparam [5:0] CAL1_RD_STOP_FOR_PI_INC   = 6'h21;
  localparam [5:0] CAL1_CENTER_WAIT          = 6'h22;

  integer    a;
  integer    b;
  integer    d;
  integer    e;
  integer    f;
  integer    h;
  integer    g;
  integer    i;
  integer    j;
  integer    k;
  integer    l;
  integer    m;
  integer    n;
  integer    r;
  integer    p;
  integer    q;
  integer    s;
  integer    t;
  integer    u;
  integer    w;
  integer    ce_i;
  integer    ce_rnk_i;
  integer    aa;
  integer    bb;
  integer    cc;
  integer    dd;
  genvar     x;
  genvar     z;

  reg [DQS_CNT_WIDTH:0]   cal1_cnt_cpt_r;
  wire [DQS_CNT_WIDTH+2:0]cal1_cnt_cpt_timing;
  reg [DQS_CNT_WIDTH:0]   cal1_cnt_cpt_timing_r;
  reg                     cal1_dq_idel_ce;
  reg                     cal1_dq_idel_inc;
  reg                     cal1_dlyce_cpt_r;
  reg                     cal1_dlyinc_cpt_r;
  reg                     cal1_dlyce_dq_r;
  reg                     cal1_dlyinc_dq_r;
  reg                     cal1_wait_cnt_en_r;
  reg [4:0]               cal1_wait_cnt_r;
  reg                     cal1_wait_r;
  reg [DQ_WIDTH-1:0]      dlyce_dq_r;
  reg                     dlyinc_dq_r;
  reg [4:0]               dlyval_dq_reg_r [0:RANKS-1][0:DQ_WIDTH-1];
  reg                     cal1_prech_req_r;
  reg [5:0]               cal1_state_r;
  reg [5:0]               cal1_state_r1;
  reg [5:0]               cal1_state_r2;
  reg [5:0]               cal1_state_r3;
  reg [5:0]               cnt_idel_dec_cpt_r;
  reg [3:0]               cnt_shift_r;
  reg                     detect_edge_done_r;
  reg [5:0]               right_edge_taps_r;
  reg [5:0]               first_edge_taps_r;
  reg                     found_edge_r;
  reg                     found_first_edge_r;
  reg                     found_second_edge_r;
  reg                     found_stable_eye_r;
  reg                     found_stable_eye_last_r;
  reg                     found_edge_all_r;
  reg [5:0]               tap_cnt_cpt_r;
  reg                     tap_limit_cpt_r;
  reg [4:0]               idel_tap_cnt_dq_pb_r;
  reg                     idel_tap_limit_dq_pb_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r;
  reg                     mux_rd_valid_r;
  reg                     new_cnt_cpt_r;
  reg [RD_SHIFT_LEN-1:0]  old_sr_fall0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_fall1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_rise0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_rise1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_fall2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_fall3_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_rise2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  old_sr_rise3_r [DRAM_WIDTH-1:0];
  reg [DRAM_WIDTH-1:0]    old_sr_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_fall1_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_fall2_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_fall3_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_rise2_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_rise3_r;
  reg [4:0]               pb_cnt_eye_size_r [DRAM_WIDTH-1:0];
  reg [DRAM_WIDTH-1:0]    pb_detect_edge_done_r;
  reg [DRAM_WIDTH-1:0]    pb_found_edge_last_r;
  reg [DRAM_WIDTH-1:0]    pb_found_edge_r;
  reg [DRAM_WIDTH-1:0]    pb_found_first_edge_r;
  reg [DRAM_WIDTH-1:0]    pb_found_stable_eye_r;
  reg [DRAM_WIDTH-1:0]    pb_last_tap_jitter_r;
  reg             pi_en_stg2_f_timing;
  reg             pi_stg2_f_incdec_timing;
  reg             pi_stg2_load_timing;
  reg [5:0]           pi_stg2_reg_l_timing;
  reg [DRAM_WIDTH-1:0]    prev_sr_diff_r;
  reg [RD_SHIFT_LEN-1:0]  prev_sr_fall0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_fall1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_rise0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_rise1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_fall2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_fall3_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_rise2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  prev_sr_rise3_r [DRAM_WIDTH-1:0];
  reg [DRAM_WIDTH-1:0]    prev_sr_match_cyc2_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_fall1_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_fall2_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_fall3_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_rise2_r;
  reg [DRAM_WIDTH-1:0]    prev_sr_match_rise3_r;
  wire [DQ_WIDTH-1:0]     rd_data_rise0;
  wire [DQ_WIDTH-1:0]     rd_data_fall0;
  wire [DQ_WIDTH-1:0]     rd_data_rise1;
  wire [DQ_WIDTH-1:0]     rd_data_fall1;
  wire [DQ_WIDTH-1:0]     rd_data_rise2;
  wire [DQ_WIDTH-1:0]     rd_data_fall2;
  wire [DQ_WIDTH-1:0]     rd_data_rise3;
  wire [DQ_WIDTH-1:0]     rd_data_fall3;
  reg                     samp_cnt_done_r;
  reg                     samp_edge_cnt0_en_r;
  reg [11:0]              samp_edge_cnt0_r;
  reg                     samp_edge_cnt1_en_r;
  reg [11:0]              samp_edge_cnt1_r;
  reg [DQS_CNT_WIDTH:0]   rd_mux_sel_r;
  reg [5:0]               second_edge_taps_r;
  reg [RD_SHIFT_LEN-1:0]  sr_fall0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise0_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise1_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_fall3_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise2_r [DRAM_WIDTH-1:0];
  reg [RD_SHIFT_LEN-1:0]  sr_rise3_r [DRAM_WIDTH-1:0];
  reg                     store_sr_r;
  reg                     store_sr_req_pulsed_r;
  reg                     store_sr_req_r;
  reg                     sr_valid_r;
  reg                     sr_valid_r1;
  reg                     sr_valid_r2;
  reg [DRAM_WIDTH-1:0]    old_sr_diff_r;
  reg [DRAM_WIDTH-1:0]    old_sr_match_cyc2_r;
  reg                     pat0_data_match_r;
  reg                     pat1_data_match_r;
  wire                    pat_data_match_r;
  wire [RD_SHIFT_LEN-1:0] pat0_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_fall3 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_fall3 [3:0];
  reg [DRAM_WIDTH-1:0]    pat0_match_fall0_r;
  reg                     pat0_match_fall0_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_fall1_r;
  reg                     pat0_match_fall1_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_fall2_r;
  reg                     pat0_match_fall2_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_fall3_r;
  reg                     pat0_match_fall3_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_rise0_r;
  reg                     pat0_match_rise0_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_rise1_r;
  reg                     pat0_match_rise1_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_rise2_r;
  reg                     pat0_match_rise2_and_r;
  reg [DRAM_WIDTH-1:0]    pat0_match_rise3_r;
  reg                     pat0_match_rise3_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall0_r;
  reg                     pat1_match_fall0_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall1_r;
  reg                     pat1_match_fall1_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall2_r;
  reg                     pat1_match_fall2_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_fall3_r;
  reg                     pat1_match_fall3_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise0_r;
  reg                     pat1_match_rise0_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise1_r;
  reg                     pat1_match_rise1_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise2_r;
  reg                     pat1_match_rise2_and_r;
  reg [DRAM_WIDTH-1:0]    pat1_match_rise3_r;
  reg                     pat1_match_rise3_and_r;
  reg [4:0]               idelay_tap_cnt_r [0:RANKS-1][0:DQS_WIDTH-1];
  reg [5*DQS_WIDTH*RANKS-1:0] idelay_tap_cnt_w;
  reg [4:0]               idelay_tap_cnt_slice_r;
  reg                     idelay_tap_limit_r;

  wire [RD_SHIFT_LEN-1:0] pat0_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat0_rise3 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] pat1_rise3 [3:0];

  wire [RD_SHIFT_LEN-1:0] idel_pat0_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_rise3 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat0_fall3 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_rise0 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_fall0 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_rise1 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_fall1 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_rise2 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_fall2 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_rise3 [3:0];
  wire [RD_SHIFT_LEN-1:0] idel_pat1_fall3 [3:0];

  reg [DRAM_WIDTH-1:0]    idel_pat0_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_fall1_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_rise2_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_fall2_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_rise3_r;
  reg [DRAM_WIDTH-1:0]    idel_pat0_match_fall3_r;

  reg [DRAM_WIDTH-1:0]    idel_pat1_match_rise0_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_fall0_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_rise1_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_fall1_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_rise2_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_fall2_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_rise3_r;
  reg [DRAM_WIDTH-1:0]    idel_pat1_match_fall3_r;

  reg                     idel_pat0_match_rise0_and_r;
  reg                     idel_pat0_match_fall0_and_r;
  reg                     idel_pat0_match_rise1_and_r;
  reg                     idel_pat0_match_fall1_and_r;
  reg                     idel_pat0_match_rise2_and_r;
  reg                     idel_pat0_match_fall2_and_r;
  reg                     idel_pat0_match_rise3_and_r;
  reg                     idel_pat0_match_fall3_and_r;

  reg                     idel_pat1_match_rise0_and_r;
  reg                     idel_pat1_match_fall0_and_r;
  reg                     idel_pat1_match_rise1_and_r;
  reg                     idel_pat1_match_fall1_and_r;
  reg                     idel_pat1_match_rise2_and_r;
  reg                     idel_pat1_match_fall2_and_r;
  reg                     idel_pat1_match_rise3_and_r;
  reg                     idel_pat1_match_fall3_and_r;

  reg                     idel_pat0_data_match_r;
  reg                     idel_pat1_data_match_r;

  reg                     idel_pat_data_match;
  reg                     idel_pat_data_match_r;

  reg [4:0]               idel_dec_cnt;

  reg [5:0]               rdlvl_dqs_tap_cnt_r [0:RANKS-1][0:DQS_WIDTH-1];
  reg [1:0]               rnk_cnt_r;
  reg                     rdlvl_rank_done_r;

  reg [3:0]               done_cnt;
  reg [1:0]               regl_rank_cnt;
  reg [DQS_CNT_WIDTH:0]   regl_dqs_cnt;
  reg [DQS_CNT_WIDTH:0]   regl_dqs_cnt_r;
  wire [DQS_CNT_WIDTH+2:0]regl_dqs_cnt_timing;
  reg                     regl_rank_done_r;
  reg                     rdlvl_stg1_start_r;

  reg                     dqs_po_dec_done_r1;
  reg                     dqs_po_dec_done_r2;
  reg                     fine_dly_dec_done_r1;
  reg                     fine_dly_dec_done_r2;
  reg                     fine_dly_dec_done_r3;
  reg                     fine_dly_dec_done_r4;
  reg [3:0]               wait_cnt_r;
  reg [5:0]               pi_rdval_cnt;
  reg                     pi_cnt_dec;

  reg                     mpr_valid_r;
  reg                     mpr_valid_r1;
  reg                     mpr_valid_r2;
  reg                     mpr_rd_rise0_prev_r;
  reg                     mpr_rd_fall0_prev_r;
  reg                     mpr_rd_rise1_prev_r;
  reg                     mpr_rd_fall1_prev_r;
  reg                     mpr_rd_rise2_prev_r;
  reg                     mpr_rd_fall2_prev_r;
  reg                     mpr_rd_rise3_prev_r;
  reg                     mpr_rd_fall3_prev_r;
  reg                     mpr_rdlvl_done_r;
  reg                     mpr_rdlvl_done_r1;
  reg                     mpr_rdlvl_done_r2;
  reg                     mpr_rdlvl_start_r;
  reg                     mpr_rank_done_r;
  reg [2:0]               stable_idel_cnt;
  reg                     inhibit_edge_detect_r;
  reg                     idel_pat_detect_valid_r;
  reg                     idel_mpr_pat_detect_r;
  reg                     mpr_pat_detect_r;
  reg                     mpr_dec_cpt_r;
  reg                     idel_adj_inc;   //IDELAY adjustment
  wire [1:0]              idelay_adj;
  wire                    pb_detect_edge_setup;
  wire                    pb_detect_edge;
  // Debug
  reg [6*DQS_WIDTH-1:0] dbg_cpt_first_edge_taps;
  reg [6*DQS_WIDTH-1:0] dbg_cpt_second_edge_taps;
  reg [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_tap_cnt_w;
  reg rdlvl_stg1_done_int;
  reg rdlvl_stg1_done_int_r1, rdlvl_stg1_done_int_r2, rdlvl_stg1_done_int_r3;
  reg rdlvl_last_byte_done_int;
  reg rdlvl_last_byte_done_int_r1, rdlvl_last_byte_done_int_r2, rdlvl_last_byte_done_int_r3;


  //IDELAY adjustment setting for -1
  //2'b10 : IDELAY - 1
  //2'b01 : IDELAY + 1
  //2'b00 : No IDELAY adjustment
  assign idelay_adj = (IDELAY_ADJ == "ON") ? 2'b10: 2'b00;

  //***************************************************************************
  // Debug
  //***************************************************************************

  always @(*) begin
    for (d = 0; d < RANKS; d = d + 1) begin
      for (e = 0; e < DQS_WIDTH; e = e + 1) begin
        idelay_tap_cnt_w[(5*e+5*DQS_WIDTH*d)+:5] = idelay_tap_cnt_r[d][e];
        dbg_cpt_tap_cnt_w[(6*e+6*DQS_WIDTH*d)+:6] = rdlvl_dqs_tap_cnt_r[d][e];
      end
    end
  end

  assign mpr_rdlvl_err         = rdlvl_stg1_err & (!mpr_rdlvl_done);
  assign rdlvl_err              = rdlvl_stg1_err & (mpr_rdlvl_done);


  assign dbg_phy_rdlvl[0]      = rdlvl_stg1_start;
  assign dbg_phy_rdlvl[1]      = pat_data_match_r;
  assign dbg_phy_rdlvl[2]      = mux_rd_valid_r;
  assign dbg_phy_rdlvl[3]      = idelay_tap_limit_r;
  assign dbg_phy_rdlvl[8:4]    = 'b0;
  assign dbg_phy_rdlvl[14:9]   = cal1_state_r[5:0];
  assign dbg_phy_rdlvl[20:15]  = cnt_idel_dec_cpt_r;
  assign dbg_phy_rdlvl[21]     = found_first_edge_r;
  assign dbg_phy_rdlvl[22]     = found_second_edge_r;
  assign dbg_phy_rdlvl[23]     = found_edge_r;
  assign dbg_phy_rdlvl[24]     = store_sr_r;
  // [40:25] previously used for sr, old_sr shift registers. If connecting
  // these signals again, don't forget to parameterize based on RD_SHIFT_LEN
  assign dbg_phy_rdlvl[40:25]  = 'b0;
  assign dbg_phy_rdlvl[41]     = sr_valid_r;
  assign dbg_phy_rdlvl[42]     = found_stable_eye_r;
  assign dbg_phy_rdlvl[48:43]  = tap_cnt_cpt_r;
  assign dbg_phy_rdlvl[54:49]  = first_edge_taps_r;
  assign dbg_phy_rdlvl[60:55]  = second_edge_taps_r;
  assign dbg_phy_rdlvl[64:61]  = cal1_cnt_cpt_timing_r;
  assign dbg_phy_rdlvl[65]     = cal1_dlyce_cpt_r;
  assign dbg_phy_rdlvl[66]     = cal1_dlyinc_cpt_r;
  assign dbg_phy_rdlvl[67]     = found_edge_r;
  assign dbg_phy_rdlvl[68]     = found_first_edge_r;
  assign dbg_phy_rdlvl[73:69]  = 'b0;
  assign dbg_phy_rdlvl[74]     = idel_pat_data_match;
  assign dbg_phy_rdlvl[75]     = idel_pat0_data_match_r;
  assign dbg_phy_rdlvl[76]     = idel_pat1_data_match_r;
  assign dbg_phy_rdlvl[77]     = pat0_data_match_r;
  assign dbg_phy_rdlvl[78]     = pat1_data_match_r;
  assign dbg_phy_rdlvl[79+:5*DQS_WIDTH*RANKS] = idelay_tap_cnt_w;
  assign dbg_phy_rdlvl[170+:8] = mux_rd_rise0_r;
  assign dbg_phy_rdlvl[178+:8] = mux_rd_fall0_r;
  assign dbg_phy_rdlvl[186+:8] = mux_rd_rise1_r;
  assign dbg_phy_rdlvl[194+:8] = mux_rd_fall1_r;
  assign dbg_phy_rdlvl[202+:8] = mux_rd_rise2_r;
  assign dbg_phy_rdlvl[210+:8] = mux_rd_fall2_r;
  assign dbg_phy_rdlvl[218+:8] = mux_rd_rise3_r;
  assign dbg_phy_rdlvl[226+:8] = mux_rd_fall3_r;

  //***************************************************************************
  // Debug output
  //***************************************************************************

  // CPT taps
  assign dbg_cpt_first_edge_cnt  = dbg_cpt_first_edge_taps;
  assign dbg_cpt_second_edge_cnt = dbg_cpt_second_edge_taps;
  assign dbg_cpt_tap_cnt         = dbg_cpt_tap_cnt_w;
  assign dbg_dq_idelay_tap_cnt   = idelay_tap_cnt_w;

  // Record first and second edges found during CPT calibration

  generate
    always @(posedge clk)
      if (rst || (rdlvl_stg1_start && ~rdlvl_stg1_start_r)) begin
        dbg_cpt_first_edge_taps  <= #TCQ 'b0;
        dbg_cpt_second_edge_taps <= #TCQ 'b0;
      end else if ((SIM_CAL_OPTION == "FAST_CAL") & (cal1_state_r1 == CAL1_CALC_IDEL)) begin
        //for (ce_rnk_i = 0; ce_rnk_i < RANKS; ce_rnk_i = ce_rnk_i + 1) begin: gen_dbg_cpt_rnk
          for (ce_i = 0; ce_i < DQS_WIDTH; ce_i = ce_i + 1) begin: gen_dbg_cpt_edge
            if (found_first_edge_r)
              dbg_cpt_first_edge_taps[(6*ce_i)+:6]
                  <= #TCQ first_edge_taps_r;
            if (found_second_edge_r)
              dbg_cpt_second_edge_taps[(6*ce_i)+:6]
                  <= #TCQ second_edge_taps_r;
          end
        //end
      end else if (cal1_state_r == CAL1_CALC_IDEL) begin
        // Record tap counts of first and second edge edges during
        // CPT calibration for each DQS group. If neither edge has
        // been found, then those taps will remain 0
          if (found_first_edge_r)
            dbg_cpt_first_edge_taps[((cal1_cnt_cpt_timing <<2) + (cal1_cnt_cpt_timing <<1))+:6]
              <= #TCQ first_edge_taps_r;
          if (found_second_edge_r)
            dbg_cpt_second_edge_taps[((cal1_cnt_cpt_timing <<2) + (cal1_cnt_cpt_timing <<1))+:6]
              <= #TCQ second_edge_taps_r;
      end
  endgenerate

  assign rdlvl_stg1_rnk_done = rdlvl_rank_done_r;// || regl_rank_done_r;
  assign mpr_rnk_done        = mpr_rank_done_r;
  assign mpr_rdlvl_done      = ((DRAM_TYPE == "DDR3") && (OCAL_EN == "ON")) ? //&& (SIM_CAL_OPTION == "NONE")
                                mpr_rdlvl_done_r : 1'b1;

   //**************************************************************************
   // DQS count to hard PHY during write calibration using Phaser_OUT Stage2
   // coarse delay
   //**************************************************************************
   assign pi_stg2_rdlvl_cnt = (((PI_DIV2_INCDEC == "TRUE") && (cal1_state_r3 == CAL1_REGL_LOAD)) || ((PI_DIV2_INCDEC == "FALSE") && (cal1_state_r == CAL1_REGL_LOAD))) ? regl_dqs_cnt_r : cal1_cnt_cpt_r;
   assign rdlvl_stg1_done   = (PI_DIV2_INCDEC == "TRUE") ? rdlvl_stg1_done_int_r3 : rdlvl_stg1_done_int;
   assign rdlvl_last_byte_done = (PI_DIV2_INCDEC == "TRUE") ? rdlvl_last_byte_done_int_r3 : rdlvl_last_byte_done_int;

   always @ (posedge clk) begin
     rdlvl_stg1_done_int_r1 <= #TCQ rdlvl_stg1_done_int;
     rdlvl_stg1_done_int_r2 <= #TCQ rdlvl_stg1_done_int_r1;
     rdlvl_stg1_done_int_r3 <= #TCQ rdlvl_stg1_done_int_r2;
     rdlvl_last_byte_done_int_r1 <= #TCQ rdlvl_last_byte_done_int;
     rdlvl_last_byte_done_int_r2 <= #TCQ rdlvl_last_byte_done_int_r1;
     rdlvl_last_byte_done_int_r3 <= #TCQ rdlvl_last_byte_done_int_r2;
   end

   assign idelay_ce  = cal1_dq_idel_ce;
   assign idelay_inc = cal1_dq_idel_inc;

  //***************************************************************************
  // Assert calib_in_common in FAST_CAL mode for IDELAY tap increments to all
  // DQs simultaneously
  //***************************************************************************

  always @(posedge clk) begin
    if (rst)
      rdlvl_assrt_common <= #TCQ 1'b0;
    else if ((SIM_CAL_OPTION == "FAST_CAL") & rdlvl_stg1_start &
            !rdlvl_stg1_start_r)
      rdlvl_assrt_common <= #TCQ 1'b1;
    else if (!idel_pat_data_match_r & idel_pat_data_match)
      rdlvl_assrt_common <= #TCQ 1'b0;
  end

  //***************************************************************************
  // Data mux to route appropriate bit to calibration logic - i.e. calibration
  // is done sequentially, one bit (or DQS group) at a time
  //***************************************************************************

  generate
    if (nCK_PER_CLK == 4) begin: rd_data_div4_logic_clk
      assign rd_data_rise0 = rd_data[DQ_WIDTH-1:0];
      assign rd_data_fall0 = rd_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign rd_data_rise1 = rd_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign rd_data_fall1 = rd_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
      assign rd_data_rise2 = rd_data[5*DQ_WIDTH-1:4*DQ_WIDTH];
      assign rd_data_fall2 = rd_data[6*DQ_WIDTH-1:5*DQ_WIDTH];
      assign rd_data_rise3 = rd_data[7*DQ_WIDTH-1:6*DQ_WIDTH];
      assign rd_data_fall3 = rd_data[8*DQ_WIDTH-1:7*DQ_WIDTH];
    end else begin: rd_data_div2_logic_clk
      assign rd_data_rise0 = rd_data[DQ_WIDTH-1:0];
      assign rd_data_fall0 = rd_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign rd_data_rise1 = rd_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign rd_data_fall1 = rd_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
    end
  endgenerate

  always @(posedge clk) begin
    rd_mux_sel_r <= #TCQ cal1_cnt_cpt_r;
  end

  // Register outputs for improved timing.
  // NOTE: Will need to change when per-bit DQ deskew is supported.
  //       Currenly all bits in DQS group are checked in aggregate
  generate
    genvar mux_i;
    for (mux_i = 0; mux_i < DRAM_WIDTH; mux_i = mux_i + 1) begin: gen_mux_rd
      always @(posedge clk) begin
        mux_rd_rise0_r[mux_i] <= #TCQ rd_data_rise0[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_fall0_r[mux_i] <= #TCQ rd_data_fall0[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_rise1_r[mux_i] <= #TCQ rd_data_rise1[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_fall1_r[mux_i] <= #TCQ rd_data_fall1[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_rise2_r[mux_i] <= #TCQ rd_data_rise2[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_fall2_r[mux_i] <= #TCQ rd_data_fall2[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_rise3_r[mux_i] <= #TCQ rd_data_rise3[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
        mux_rd_fall3_r[mux_i] <= #TCQ rd_data_fall3[DRAM_WIDTH*rd_mux_sel_r +
                                                    mux_i];
      end
    end
  endgenerate

  //***************************************************************************
  // MPR Read Leveling
  //***************************************************************************

  // storing the previous read data for checking later. Only bit 0 is used
  // since MPR contents (01010101) are available generally on DQ[0] per
  // JEDEC spec.
   always @(posedge clk)begin
     if ((cal1_state_r == CAL1_MPR_NEW_DQS_WAIT) ||
        ((cal1_state_r == CAL1_MPR_PAT_DETECT) && (idel_pat_detect_valid_r)))begin
       mpr_rd_rise0_prev_r <= #TCQ mux_rd_rise0_r[0];
       mpr_rd_fall0_prev_r <= #TCQ mux_rd_fall0_r[0];
       mpr_rd_rise1_prev_r <= #TCQ mux_rd_rise1_r[0];
       mpr_rd_fall1_prev_r <= #TCQ mux_rd_fall1_r[0];
       mpr_rd_rise2_prev_r <= #TCQ mux_rd_rise2_r[0];
       mpr_rd_fall2_prev_r <= #TCQ mux_rd_fall2_r[0];
       mpr_rd_rise3_prev_r <= #TCQ mux_rd_rise3_r[0];
       mpr_rd_fall3_prev_r <= #TCQ mux_rd_fall3_r[0];
     end
   end

   generate
    if (nCK_PER_CLK == 4) begin: mpr_4to1
   // changed stable count of 2 IDELAY taps at 78 ps resolution
   always @(posedge clk) begin
      if (rst | (cal1_state_r == CAL1_NEW_DQS_PREWAIT) |
         //(cal1_state_r == CAL1_DETECT_EDGE) |
         (mpr_rd_rise0_prev_r != mux_rd_rise0_r[0]) |
         (mpr_rd_fall0_prev_r != mux_rd_fall0_r[0]) |
         (mpr_rd_rise1_prev_r != mux_rd_rise1_r[0]) |
         (mpr_rd_fall1_prev_r != mux_rd_fall1_r[0]) |
         (mpr_rd_rise2_prev_r != mux_rd_rise2_r[0]) |
         (mpr_rd_fall2_prev_r != mux_rd_fall2_r[0]) |
         (mpr_rd_rise3_prev_r != mux_rd_rise3_r[0]) |
         (mpr_rd_fall3_prev_r != mux_rd_fall3_r[0]))
        stable_idel_cnt <= #TCQ 3'd0;
      else if ((|idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing]) &
               ((cal1_state_r == CAL1_MPR_PAT_DETECT) &
               (idel_pat_detect_valid_r))) begin
        if ((mpr_rd_rise0_prev_r == mux_rd_rise0_r[0]) &
            (mpr_rd_fall0_prev_r == mux_rd_fall0_r[0]) &
            (mpr_rd_rise1_prev_r == mux_rd_rise1_r[0]) &
            (mpr_rd_fall1_prev_r == mux_rd_fall1_r[0]) &
            (mpr_rd_rise2_prev_r == mux_rd_rise2_r[0]) &
            (mpr_rd_fall2_prev_r == mux_rd_fall2_r[0]) &
            (mpr_rd_rise3_prev_r == mux_rd_rise3_r[0]) &
            (mpr_rd_fall3_prev_r == mux_rd_fall3_r[0]) &
            (stable_idel_cnt < 3'd2))
          stable_idel_cnt <= #TCQ stable_idel_cnt + 1;
      end
   end

   always @(posedge clk) begin
     if (rst |
         (mpr_rd_rise0_prev_r & ~mpr_rd_fall0_prev_r &
          mpr_rd_rise1_prev_r & ~mpr_rd_fall1_prev_r &
          mpr_rd_rise2_prev_r & ~mpr_rd_fall2_prev_r &
          mpr_rd_rise3_prev_r & ~mpr_rd_fall3_prev_r))
       inhibit_edge_detect_r <= 1'b1;
     // Wait for settling time after idelay tap increment before
     // de-asserting inhibit_edge_detect_r
     else if ((cal1_state_r == CAL1_MPR_PAT_DETECT) &
              (idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] > 5'd1) &
              (~mpr_rd_rise0_prev_r & mpr_rd_fall0_prev_r &
               ~mpr_rd_rise1_prev_r & mpr_rd_fall1_prev_r &
               ~mpr_rd_rise2_prev_r & mpr_rd_fall2_prev_r &
               ~mpr_rd_rise3_prev_r & mpr_rd_fall3_prev_r))
       inhibit_edge_detect_r <= 1'b0;
   end

   //checking for transition from 01010101 to 10101010
   always @(posedge clk)begin
     if (rst | (cal1_state_r == CAL1_MPR_NEW_DQS_WAIT) |
         inhibit_edge_detect_r)
       idel_mpr_pat_detect_r     <= #TCQ 1'b0;
     // 10101010 is not the correct pattern
     else if ((mpr_rd_rise0_prev_r & ~mpr_rd_fall0_prev_r &
               mpr_rd_rise1_prev_r & ~mpr_rd_fall1_prev_r &
               mpr_rd_rise2_prev_r & ~mpr_rd_fall2_prev_r &
               mpr_rd_rise3_prev_r & ~mpr_rd_fall3_prev_r) ||
              ((stable_idel_cnt < 3'd2) & (cal1_state_r == CAL1_MPR_PAT_DETECT)
               && (idel_pat_detect_valid_r)))
              //|| (idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] < 5'd2))
       idel_mpr_pat_detect_r     <= #TCQ 1'b0;
     // 01010101 to 10101010 is the correct transition
     else if ((~mpr_rd_rise0_prev_r & mpr_rd_fall0_prev_r &
               ~mpr_rd_rise1_prev_r & mpr_rd_fall1_prev_r &
               ~mpr_rd_rise2_prev_r & mpr_rd_fall2_prev_r &
               ~mpr_rd_rise3_prev_r & mpr_rd_fall3_prev_r) &
               (stable_idel_cnt == 3'd2) &
               ((mpr_rd_rise0_prev_r != mux_rd_rise0_r[0]) ||
                (mpr_rd_fall0_prev_r != mux_rd_fall0_r[0]) ||
                (mpr_rd_rise1_prev_r != mux_rd_rise1_r[0]) ||
                (mpr_rd_fall1_prev_r != mux_rd_fall1_r[0]) ||
                (mpr_rd_rise2_prev_r != mux_rd_rise2_r[0]) ||
                (mpr_rd_fall2_prev_r != mux_rd_fall2_r[0]) ||
                (mpr_rd_rise3_prev_r != mux_rd_rise3_r[0]) ||
                (mpr_rd_fall3_prev_r != mux_rd_fall3_r[0])))
       idel_mpr_pat_detect_r     <= #TCQ 1'b1;
   end
    end else if (nCK_PER_CLK == 2) begin: mpr_2to1
      // changed stable count of 2 IDELAY taps at 78 ps resolution
      always @(posedge clk) begin
         if (rst | (cal1_state_r == CAL1_MPR_NEW_DQS_WAIT) |
            (mpr_rd_rise0_prev_r != mux_rd_rise0_r[0]) |
            (mpr_rd_fall0_prev_r != mux_rd_fall0_r[0]) |
            (mpr_rd_rise1_prev_r != mux_rd_rise1_r[0]) |
            (mpr_rd_fall1_prev_r != mux_rd_fall1_r[0]))
           stable_idel_cnt <= #TCQ 3'd0;
         else if ((idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] > 5'd0) &
                  ((cal1_state_r == CAL1_MPR_PAT_DETECT) &
                  (idel_pat_detect_valid_r))) begin
           if ((mpr_rd_rise0_prev_r == mux_rd_rise0_r[0]) &
               (mpr_rd_fall0_prev_r == mux_rd_fall0_r[0]) &
               (mpr_rd_rise1_prev_r == mux_rd_rise1_r[0]) &
               (mpr_rd_fall1_prev_r == mux_rd_fall1_r[0]) &
               (stable_idel_cnt < 3'd2))
             stable_idel_cnt <= #TCQ stable_idel_cnt + 1;
         end
      end

      always @(posedge clk) begin
        if (rst |
            (mpr_rd_rise0_prev_r & ~mpr_rd_fall0_prev_r &
             mpr_rd_rise1_prev_r & ~mpr_rd_fall1_prev_r))
          inhibit_edge_detect_r <= 1'b1;
        else if ((cal1_state_r == CAL1_MPR_PAT_DETECT) &
                 (idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] > 5'd1) &
                 (~mpr_rd_rise0_prev_r & mpr_rd_fall0_prev_r &
                  ~mpr_rd_rise1_prev_r & mpr_rd_fall1_prev_r))
          inhibit_edge_detect_r <= 1'b0;
      end

      //checking for transition from 01010101 to 10101010
      always @(posedge clk)begin
        if (rst | (cal1_state_r == CAL1_MPR_NEW_DQS_WAIT) |
            inhibit_edge_detect_r)
          idel_mpr_pat_detect_r     <= #TCQ 1'b0;
        // 1010 is not the correct pattern
        else if ((mpr_rd_rise0_prev_r & ~mpr_rd_fall0_prev_r &
                  mpr_rd_rise1_prev_r & ~mpr_rd_fall1_prev_r) ||
                 ((stable_idel_cnt < 3'd2) & (cal1_state_r == CAL1_MPR_PAT_DETECT)
                 & (idel_pat_detect_valid_r)))
                 // ||(idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] < 5'd2))
          idel_mpr_pat_detect_r     <= #TCQ 1'b0;
        // 0101 to 1010 is the correct transition
        else if ((~mpr_rd_rise0_prev_r & mpr_rd_fall0_prev_r &
                  ~mpr_rd_rise1_prev_r & mpr_rd_fall1_prev_r) &
                  (stable_idel_cnt == 3'd2) &
                  ((mpr_rd_rise0_prev_r != mux_rd_rise0_r[0]) ||
                   (mpr_rd_fall0_prev_r != mux_rd_fall0_r[0]) ||
                   (mpr_rd_rise1_prev_r != mux_rd_rise1_r[0]) ||
                   (mpr_rd_fall1_prev_r != mux_rd_fall1_r[0])))
          idel_mpr_pat_detect_r     <= #TCQ 1'b1;
      end
    end
  endgenerate



  // Registered signal indicates when mux_rd_rise/fall_r is valid
  always @(posedge clk)
    mux_rd_valid_r <= #TCQ ~phy_if_empty;


  //***************************************************************************
  // Decrement initial Phaser_IN fine delay value before proceeding with
  // read calibration
  //***************************************************************************

     always @(posedge clk) begin
       dqs_po_dec_done_r1 <= #TCQ dqs_po_dec_done;
       dqs_po_dec_done_r2 <= #TCQ dqs_po_dec_done_r1;
       fine_dly_dec_done_r2 <= #TCQ fine_dly_dec_done_r1;
       fine_dly_dec_done_r3 <= #TCQ fine_dly_dec_done_r2;
       fine_dly_dec_done_r4 <= #TCQ fine_dly_dec_done_r3;
       if (PI_DIV2_INCDEC == "TRUE")
         pi_fine_dly_dec_done <= #TCQ fine_dly_dec_done_r4;
       else
       pi_fine_dly_dec_done <= #TCQ fine_dly_dec_done_r2;
     end

     always @(posedge clk) begin
       if (rst || pi_cnt_dec)
         wait_cnt_r <= #TCQ 'd8;
       else if (dqs_po_dec_done_r2 && (wait_cnt_r > 'd0))
         wait_cnt_r <= #TCQ wait_cnt_r - 1;
     end

     always @(posedge clk) begin
     if (rst) begin
       pi_rdval_cnt    <= #TCQ 'd0;
     end else if (dqs_po_dec_done_r1 && ~dqs_po_dec_done_r2) begin
       pi_rdval_cnt    <= #TCQ pi_counter_read_val;
     end else if (pi_rdval_cnt > 'd0) begin
       if (pi_cnt_dec)
         pi_rdval_cnt  <= #TCQ pi_rdval_cnt - 1;
       else
         pi_rdval_cnt  <= #TCQ pi_rdval_cnt;
     end else if (pi_rdval_cnt == 'd0) begin
       pi_rdval_cnt    <= #TCQ pi_rdval_cnt;
     end
   end

   always @(posedge clk) begin
     if (rst || (pi_rdval_cnt == 'd0))
       pi_cnt_dec      <= #TCQ 1'b0;
     else if (dqs_po_dec_done_r2 && (pi_rdval_cnt > 'd0)
                  && (wait_cnt_r == 'd1))
       pi_cnt_dec      <= #TCQ 1'b1;
     else
       pi_cnt_dec      <= #TCQ 1'b0;
   end

   always @(posedge clk) begin
     if (rst) begin
       fine_dly_dec_done_r1 <= #TCQ 1'b0;
     end else if (((pi_cnt_dec == 'd1) && (pi_rdval_cnt == 'd1)) ||
                  (dqs_po_dec_done_r2 && (pi_rdval_cnt == 'd0))) begin
       fine_dly_dec_done_r1 <= #TCQ 1'b1;
     end
   end

  //***************************************************************************
  // Demultiplexor to control Phaser_IN delay values
  //***************************************************************************

  // Read DQS
  always @(posedge clk) begin
    if (rst) begin
      pi_en_stg2_f_timing     <= #TCQ 'b0;
      pi_stg2_f_incdec_timing <= #TCQ 'b0;
    end else if (pi_cnt_dec) begin
      pi_en_stg2_f_timing     <= #TCQ 'b1;
      pi_stg2_f_incdec_timing <= #TCQ 'b0;
    end else if (cal1_dlyce_cpt_r) begin
      if ((SIM_CAL_OPTION == "NONE") ||
          (SIM_CAL_OPTION == "FAST_WIN_DETECT")) begin
        // Change only specified DQS
        pi_en_stg2_f_timing     <= #TCQ 1'b1;
        pi_stg2_f_incdec_timing <= #TCQ cal1_dlyinc_cpt_r;
      end else if (SIM_CAL_OPTION == "FAST_CAL") begin
        // if simulating, and "shortcuts" for calibration enabled, apply
        // results to all DQSs (i.e. assume same delay on all
        // DQSs).
        pi_en_stg2_f_timing     <= #TCQ 1'b1;
        pi_stg2_f_incdec_timing <= #TCQ cal1_dlyinc_cpt_r;
      end
    end else begin
      pi_en_stg2_f_timing     <= #TCQ 'b0;
      pi_stg2_f_incdec_timing <= #TCQ 'b0;
    end
  end

  // registered for timing
  always @(posedge clk) begin
    pi_en_stg2_f     <= #TCQ pi_en_stg2_f_timing;
    pi_stg2_f_incdec <= #TCQ pi_stg2_f_incdec_timing;
  end

   // This counter used to implement settling time between
   // Phaser_IN rank register loads to different DQSs
   always @(posedge clk) begin
     if (rst)
       done_cnt <= #TCQ 'b0;
     else if (((cal1_state_r == CAL1_REGL_LOAD) &&
               (cal1_state_r1 == CAL1_NEXT_DQS)) ||
              ((done_cnt == 4'd1) && (cal1_state_r != CAL1_DONE)))
       done_cnt <= #TCQ 4'b1010;
     else if (done_cnt > 'b0)
       done_cnt <= #TCQ done_cnt - 1;
   end

   // During rank register loading the rank count must be sent to
   // Phaser_IN via the phy_ctl_wd?? If so phy_init will have to
   // issue NOPs during rank register loading with the appropriate
   // rank count
   always @(posedge clk) begin
     if (rst || (regl_rank_done_r == 1'b1))
       regl_rank_done_r <= #TCQ 1'b0;
     else if ((regl_dqs_cnt == DQS_WIDTH-1) &&
              (regl_rank_cnt != RANKS-1) &&
              (done_cnt == 4'd1))
       regl_rank_done_r <= #TCQ 1'b1;
   end

   // Temp wire for timing.
   // The following in the always block below causes timing issues
   // due to DSP block inference
   // 6*regl_dqs_cnt.
   // replacing this with two left shifts + 1 left shift to avoid
   // DSP multiplier.
   assign regl_dqs_cnt_timing = {2'd0, regl_dqs_cnt};

   // Load Phaser_OUT rank register with rdlvl delay value
   // for each DQS per rank.
   always @(posedge clk) begin
     if (rst || (done_cnt == 4'd0)) begin
       pi_stg2_load_timing    <= #TCQ 'b0;
       pi_stg2_reg_l_timing   <= #TCQ 'b0;
     end else if ((cal1_state_r == CAL1_REGL_LOAD) &&
                  (regl_dqs_cnt <= DQS_WIDTH-1) && (done_cnt == 4'd1)) begin
       pi_stg2_load_timing  <= #TCQ 'b1;
       pi_stg2_reg_l_timing <= #TCQ
         rdlvl_dqs_tap_cnt_r[rnk_cnt_r][regl_dqs_cnt];
     end else begin
       pi_stg2_load_timing  <= #TCQ 'b0;
       pi_stg2_reg_l_timing <= #TCQ 'b0;
     end
   end

   // registered for timing
   always @(posedge clk) begin
     pi_stg2_load  <= #TCQ pi_stg2_load_timing;
     pi_stg2_reg_l <= #TCQ pi_stg2_reg_l_timing;
   end

   always @(posedge clk) begin
     if (rst || (done_cnt == 4'd0) ||
         (mpr_rdlvl_done_r1 && ~mpr_rdlvl_done_r2))
       regl_rank_cnt   <= #TCQ 2'b00;
     else if ((cal1_state_r == CAL1_REGL_LOAD) &&
              (regl_dqs_cnt == DQS_WIDTH-1) && (done_cnt == 4'd1)) begin
       if (regl_rank_cnt == RANKS-1)
         regl_rank_cnt  <= #TCQ regl_rank_cnt;
       else
         regl_rank_cnt <= #TCQ regl_rank_cnt + 1;
     end
   end

   always @(posedge clk) begin
     if (rst || (done_cnt == 4'd0) ||
         (mpr_rdlvl_done_r1 && ~mpr_rdlvl_done_r2))
       regl_dqs_cnt    <= #TCQ {DQS_CNT_WIDTH+1{1'b0}};
     else if ((cal1_state_r == CAL1_REGL_LOAD) &&
              (regl_dqs_cnt == DQS_WIDTH-1) && (done_cnt == 4'd1)) begin
       if (regl_rank_cnt == RANKS-1)
         regl_dqs_cnt  <= #TCQ regl_dqs_cnt;
       else
         regl_dqs_cnt  <= #TCQ 'b0;
     end else if ((cal1_state_r == CAL1_REGL_LOAD) && (regl_dqs_cnt != DQS_WIDTH-1)
                  && (done_cnt == 4'd1))
       regl_dqs_cnt  <= #TCQ regl_dqs_cnt + 1;
     else
       regl_dqs_cnt  <= #TCQ regl_dqs_cnt;
   end


   always @(posedge clk)
     regl_dqs_cnt_r <= #TCQ regl_dqs_cnt;
  //*****************************************************************
  // DQ Stage 1 CALIBRATION INCREMENT/DECREMENT LOGIC:
  // The actual IDELAY elements for each of the DQ bits is set via the
  // DLYVAL parallel load port. However, the stage 1 calibration
  // algorithm (well most of it) only needs to increment or decrement the DQ
  // IDELAY value by 1 at any one time.
  //*****************************************************************

  // Chip-select generation for each of the individual counters tracking
  // IDELAY tap values for each DQ
  generate
    for (z = 0; z < DQS_WIDTH; z = z + 1) begin: gen_dlyce_dq
      always @(posedge clk)
        if (rst)
          dlyce_dq_r[DRAM_WIDTH*z+:DRAM_WIDTH] <= #TCQ 'b0;
        else
          if (SIM_CAL_OPTION == "SKIP_CAL")
            // If skipping calibration altogether (only for simulation), no
            // need to set DQ IODELAY values - they are hardcoded
            dlyce_dq_r[DRAM_WIDTH*z+:DRAM_WIDTH] <= #TCQ 'b0;
          else if (SIM_CAL_OPTION == "FAST_CAL") begin
            // If fast calibration option (simulation only) selected, DQ
            // IODELAYs across all bytes are updated simultaneously
            // (although per-bit deskew within DQS[0] is still supported)
            for (h = 0; h < DRAM_WIDTH; h = h + 1) begin
              dlyce_dq_r[DRAM_WIDTH*z + h] <= #TCQ cal1_dlyce_dq_r;
            end
          end else if ((SIM_CAL_OPTION == "NONE") ||
                   (SIM_CAL_OPTION == "FAST_WIN_DETECT")) begin
            if (cal1_cnt_cpt_r == z) begin
              for (g = 0; g < DRAM_WIDTH; g = g + 1) begin
                dlyce_dq_r[DRAM_WIDTH*z + g]
                <= #TCQ cal1_dlyce_dq_r;
              end
            end else
              dlyce_dq_r[DRAM_WIDTH*z+:DRAM_WIDTH] <= #TCQ 'b0;
          end
    end
  endgenerate

  // Also delay increment/decrement control to match delay on DLYCE
  always @(posedge clk)
    if (rst)
      dlyinc_dq_r <= #TCQ 1'b0;
    else
      dlyinc_dq_r <= #TCQ cal1_dlyinc_dq_r;


  // Each DQ has a counter associated with it to record current read-leveling
  // delay value
  always @(posedge clk)
    // Reset or skipping calibration all together
    if (rst | (SIM_CAL_OPTION == "SKIP_CAL")) begin
      for (aa = 0; aa < RANKS; aa = aa + 1) begin: rst_dlyval_dq_reg_r
        for (bb = 0; bb < DQ_WIDTH; bb = bb + 1)
          dlyval_dq_reg_r[aa][bb] <= #TCQ 'b0;
      end
    end else if (SIM_CAL_OPTION == "FAST_CAL") begin
      for (n = 0; n < RANKS; n = n + 1) begin: gen_dlyval_dq_reg_rnk
        for (r = 0; r < DQ_WIDTH; r = r + 1) begin: gen_dlyval_dq_reg
          if (dlyce_dq_r[r]) begin
            if (dlyinc_dq_r)
              dlyval_dq_reg_r[n][r] <= #TCQ dlyval_dq_reg_r[n][r] + 5'h01;
            else
              dlyval_dq_reg_r[n][r] <= #TCQ dlyval_dq_reg_r[n][r] - 5'h01;
          end
        end
      end
    end else begin
      if (dlyce_dq_r[cal1_cnt_cpt_r]) begin
        if (dlyinc_dq_r)
          dlyval_dq_reg_r[rnk_cnt_r][cal1_cnt_cpt_r] <= #TCQ
            dlyval_dq_reg_r[rnk_cnt_r][cal1_cnt_cpt_r] + 5'h01;
        else
          dlyval_dq_reg_r[rnk_cnt_r][cal1_cnt_cpt_r] <= #TCQ
            dlyval_dq_reg_r[rnk_cnt_r][cal1_cnt_cpt_r] - 5'h01;
      end
    end

  // Register for timing (help with logic placement)
  always @(posedge clk) begin
    for (cc = 0; cc < RANKS; cc = cc + 1) begin: dlyval_dq_assgn
      for (dd = 0; dd < DQ_WIDTH; dd = dd + 1)
        dlyval_dq[((5*dd)+(cc*DQ_WIDTH*5))+:5] <= #TCQ dlyval_dq_reg_r[cc][dd];
      end
  end

  //***************************************************************************
  // Generate signal used to delay calibration state machine - used when:
  //  (1) IDELAY value changed
  //  (2) RD_MUX_SEL value changed
  // Use when a delay is necessary to give the change time to propagate
  // through the data pipeline (through IDELAY and ISERDES, and fabric
  // pipeline stages)
  //***************************************************************************


  // List all the stage 1 calibration wait states here.
    // verilint STARC-2.7.3.3b off
  always @(posedge clk)
    if ((cal1_state_r == CAL1_NEW_DQS_WAIT) ||
        (cal1_state_r == CAL1_MPR_NEW_DQS_WAIT) ||
        (cal1_state_r == CAL1_NEW_DQS_PREWAIT) ||
        (cal1_state_r == CAL1_VALID_WAIT) ||
        (cal1_state_r == CAL1_PB_STORE_FIRST_WAIT) ||
        (cal1_state_r == CAL1_PB_INC_CPT_WAIT) ||
        (cal1_state_r == CAL1_PB_DEC_CPT_LEFT_WAIT) ||
        (cal1_state_r == CAL1_PB_INC_DQ_WAIT) ||
        (cal1_state_r == CAL1_PB_DEC_CPT_WAIT) ||
        (cal1_state_r == CAL1_IDEL_INC_CPT_WAIT) ||
        (cal1_state_r == CAL1_IDEL_DEC_CPT_WAIT) ||
        (cal1_state_r == CAL1_STORE_FIRST_WAIT) ||
        (cal1_state_r == CAL1_DQ_IDEL_TAP_INC_WAIT) ||
        (cal1_state_r == CAL1_DQ_IDEL_TAP_DEC_WAIT) ||
        (cal1_state_r == CAL1_CENTER_WAIT) ||
        (cal1_state_r == CAL1_RD_STOP_FOR_PI_INC))
      cal1_wait_cnt_en_r <= #TCQ 1'b1;
    else
      cal1_wait_cnt_en_r <= #TCQ 1'b0;
// verilint STARC-2.7.3.3b on
  always @(posedge clk)
    if (!cal1_wait_cnt_en_r) begin
      cal1_wait_cnt_r <= #TCQ 5'b00000;
      cal1_wait_r     <= #TCQ 1'b1;
    end else begin
      if (cal1_wait_cnt_r != PIPE_WAIT_CNT - 1) begin
        cal1_wait_cnt_r <= #TCQ cal1_wait_cnt_r + 1;
        cal1_wait_r     <= #TCQ 1'b1;
      end else begin
        // Need to reset to 0 to handle the case when there are two
        // different WAIT states back-to-back
        cal1_wait_cnt_r <= #TCQ 5'b00000;
        cal1_wait_r     <= #TCQ 1'b0;
      end
    end

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
      rdlvl_prech_req <= #TCQ 1'b0;
    else
      rdlvl_prech_req <= #TCQ cal1_prech_req_r;

  //***************************************************************************
  // Serial-to-parallel register to store last RDDATA_SHIFT_LEN cycles of
  // data from ISERDES. The value of this register is also stored, so that
  // previous and current values of the ISERDES data can be compared while
  // varying the IODELAY taps to see if an "edge" of the data valid window
  // has been encountered since the last IODELAY tap adjustment
  //***************************************************************************

  //***************************************************************************
  // Shift register to store last RDDATA_SHIFT_LEN cycles of data from ISERDES
  // NOTE: Written using discrete flops, but SRL can be used if the matching
  //   logic does the comparison sequentially, rather than parallel
  //***************************************************************************

  generate
    genvar rd_i;
    if (nCK_PER_CLK == 4) begin: gen_sr_div4
      if (RD_SHIFT_LEN == 1) begin: gen_sr_len_eq1
        for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
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
        end
      end else if (RD_SHIFT_LEN > 1) begin: gen_sr_len_gt1
        for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
              sr_rise0_r[rd_i] <= #TCQ {sr_rise0_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise0_r[rd_i]};
              sr_fall0_r[rd_i] <= #TCQ {sr_fall0_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall0_r[rd_i]};
              sr_rise1_r[rd_i] <= #TCQ {sr_rise1_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise1_r[rd_i]};
              sr_fall1_r[rd_i] <= #TCQ {sr_fall1_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall1_r[rd_i]};
              sr_rise2_r[rd_i] <= #TCQ {sr_rise2_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise2_r[rd_i]};
              sr_fall2_r[rd_i] <= #TCQ {sr_fall2_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall2_r[rd_i]};
              sr_rise3_r[rd_i] <= #TCQ {sr_rise3_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise3_r[rd_i]};
              sr_fall3_r[rd_i] <= #TCQ {sr_fall3_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall3_r[rd_i]};
            end
          end
        end
      end
    end else if (nCK_PER_CLK == 2) begin: gen_sr_div2
      if (RD_SHIFT_LEN == 1) begin: gen_sr_len_eq1
        for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
              sr_rise0_r[rd_i] <= #TCQ {mux_rd_rise0_r[rd_i]};
              sr_fall0_r[rd_i] <= #TCQ {mux_rd_fall0_r[rd_i]};
              sr_rise1_r[rd_i] <= #TCQ {mux_rd_rise1_r[rd_i]};
              sr_fall1_r[rd_i] <= #TCQ {mux_rd_fall1_r[rd_i]};
            end
          end
        end
      end else if (RD_SHIFT_LEN > 1) begin: gen_sr_len_gt1
        for (rd_i = 0; rd_i < DRAM_WIDTH; rd_i = rd_i + 1) begin: gen_sr
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
              sr_rise0_r[rd_i] <= #TCQ {sr_rise0_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise0_r[rd_i]};
              sr_fall0_r[rd_i] <= #TCQ {sr_fall0_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall0_r[rd_i]};
              sr_rise1_r[rd_i] <= #TCQ {sr_rise1_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_rise1_r[rd_i]};
              sr_fall1_r[rd_i] <= #TCQ {sr_fall1_r[rd_i][RD_SHIFT_LEN-2:0],
                                        mux_rd_fall1_r[rd_i]};
            end
          end
        end
      end
    end
  endgenerate

  //***************************************************************************
  // Conversion to pattern calibration
  //***************************************************************************

  // Pattern for DQ IDELAY calibration

  //*****************************************************************
  // Expected data pattern when DQ shifted to the right such that
  // DQS before the left edge of the DVW:
  // Based on pattern of ({rise,fall}) =
  //   0x1, 0xB, 0x4, 0x4, 0xB, 0x9
  // Each nibble will look like:
  //   bit3: 0, 1, 0, 0, 1, 1
  //   bit2: 0, 0, 1, 1, 0, 0
  //   bit1: 0, 1, 0, 0, 1, 0
  //   bit0: 1, 1, 0, 0, 1, 1
  // Or if the write is early it could look like:
  //   0x4, 0x4, 0xB, 0x9, 0x6, 0xE
  //   bit3: 0, 0, 1, 1, 0, 1
  //   bit2: 1, 1, 0, 0, 1, 1
  //   bit1: 0, 0, 1, 0, 1, 1
  //   bit0: 0, 0, 1, 1, 0, 0
  // Change the hard-coded pattern below accordingly as RD_SHIFT_LEN
  // and the actual training pattern contents change
  //*****************************************************************

  generate
    if (nCK_PER_CLK == 4) begin: gen_pat_div4
      // Pattern for DQ IDELAY increment

      // Target pattern for "early write"
      assign {idel_pat0_rise0[3], idel_pat0_rise0[2],
              idel_pat0_rise0[1], idel_pat0_rise0[0]} = 4'h1;
      assign {idel_pat0_fall0[3], idel_pat0_fall0[2],
              idel_pat0_fall0[1], idel_pat0_fall0[0]} = 4'h7;
      assign {idel_pat0_rise1[3], idel_pat0_rise1[2],
              idel_pat0_rise1[1], idel_pat0_rise1[0]} = 4'hE;
      assign {idel_pat0_fall1[3], idel_pat0_fall1[2],
              idel_pat0_fall1[1], idel_pat0_fall1[0]} = 4'hC;
      assign {idel_pat0_rise2[3], idel_pat0_rise2[2],
              idel_pat0_rise2[1], idel_pat0_rise2[0]} = 4'h9;
      assign {idel_pat0_fall2[3], idel_pat0_fall2[2],
              idel_pat0_fall2[1], idel_pat0_fall2[0]} = 4'h2;
      assign {idel_pat0_rise3[3], idel_pat0_rise3[2],
              idel_pat0_rise3[1], idel_pat0_rise3[0]} = 4'h4;
      assign {idel_pat0_fall3[3], idel_pat0_fall3[2],
              idel_pat0_fall3[1], idel_pat0_fall3[0]} = 4'hB;

      // Target pattern for "on-time write"
      assign {idel_pat1_rise0[3], idel_pat1_rise0[2],
              idel_pat1_rise0[1], idel_pat1_rise0[0]} = 4'h4;
      assign {idel_pat1_fall0[3], idel_pat1_fall0[2],
              idel_pat1_fall0[1], idel_pat1_fall0[0]} = 4'h9;
      assign {idel_pat1_rise1[3], idel_pat1_rise1[2],
              idel_pat1_rise1[1], idel_pat1_rise1[0]} = 4'h3;
      assign {idel_pat1_fall1[3], idel_pat1_fall1[2],
              idel_pat1_fall1[1], idel_pat1_fall1[0]} = 4'h7;
      assign {idel_pat1_rise2[3], idel_pat1_rise2[2],
              idel_pat1_rise2[1], idel_pat1_rise2[0]} = 4'hE;
      assign {idel_pat1_fall2[3], idel_pat1_fall2[2],
              idel_pat1_fall2[1], idel_pat1_fall2[0]} = 4'hC;
      assign {idel_pat1_rise3[3], idel_pat1_rise3[2],
              idel_pat1_rise3[1], idel_pat1_rise3[0]} = 4'h9;
      assign {idel_pat1_fall3[3], idel_pat1_fall3[2],
              idel_pat1_fall3[1], idel_pat1_fall3[0]} = 4'h2;


      // Correct data valid window for "early write"
      assign {pat0_rise0[3], pat0_rise0[2],
              pat0_rise0[1], pat0_rise0[0]} = 4'h7;
      assign {pat0_fall0[3], pat0_fall0[2],
              pat0_fall0[1], pat0_fall0[0]} = 4'hE;
      assign {pat0_rise1[3], pat0_rise1[2],
              pat0_rise1[1], pat0_rise1[0]} = 4'hC;
      assign {pat0_fall1[3], pat0_fall1[2],
              pat0_fall1[1], pat0_fall1[0]} = 4'h9;
      assign {pat0_rise2[3], pat0_rise2[2],
              pat0_rise2[1], pat0_rise2[0]} = 4'h2;
      assign {pat0_fall2[3], pat0_fall2[2],
              pat0_fall2[1], pat0_fall2[0]} = 4'h4;
      assign {pat0_rise3[3], pat0_rise3[2],
              pat0_rise3[1], pat0_rise3[0]} = 4'hB;
      assign {pat0_fall3[3], pat0_fall3[2],
              pat0_fall3[1], pat0_fall3[0]} = 4'h1;

      // Correct data valid window for "on-time write"
      assign {pat1_rise0[3], pat1_rise0[2],
              pat1_rise0[1], pat1_rise0[0]} = 4'h9;
      assign {pat1_fall0[3], pat1_fall0[2],
              pat1_fall0[1], pat1_fall0[0]} = 4'h3;
      assign {pat1_rise1[3], pat1_rise1[2],
              pat1_rise1[1], pat1_rise1[0]} = 4'h7;
      assign {pat1_fall1[3], pat1_fall1[2],
              pat1_fall1[1], pat1_fall1[0]} = 4'hE;
      assign {pat1_rise2[3], pat1_rise2[2],
              pat1_rise2[1], pat1_rise2[0]} = 4'hC;
      assign {pat1_fall2[3], pat1_fall2[2],
              pat1_fall2[1], pat1_fall2[0]} = 4'h9;
      assign {pat1_rise3[3], pat1_rise3[2],
              pat1_rise3[1], pat1_rise3[0]} = 4'h2;
      assign {pat1_fall3[3], pat1_fall3[2],
              pat1_fall3[1], pat1_fall3[0]} = 4'h4;

    end else if (nCK_PER_CLK == 2) begin: gen_pat_div2

            // Pattern for DQ IDELAY increment

      // Target pattern for "early write"
      assign idel_pat0_rise0[3] = 2'b01;
      assign idel_pat0_fall0[3] = 2'b00;
      assign idel_pat0_rise1[3] = 2'b10;
      assign idel_pat0_fall1[3] = 2'b11;

      assign idel_pat0_rise0[2] = 2'b00;
      assign idel_pat0_fall0[2] = 2'b10;
      assign idel_pat0_rise1[2] = 2'b11;
      assign idel_pat0_fall1[2] = 2'b10;

      assign idel_pat0_rise0[1] = 2'b00;
      assign idel_pat0_fall0[1] = 2'b11;
      assign idel_pat0_rise1[1] = 2'b10;
      assign idel_pat0_fall1[1] = 2'b01;

      assign idel_pat0_rise0[0] = 2'b11;
      assign idel_pat0_fall0[0] = 2'b10;
      assign idel_pat0_rise1[0] = 2'b00;
      assign idel_pat0_fall1[0] = 2'b01;


      // Target pattern for "on-time write"
      assign idel_pat1_rise0[3] = 2'b01;
      assign idel_pat1_fall0[3] = 2'b11;
      assign idel_pat1_rise1[3] = 2'b01;
      assign idel_pat1_fall1[3] = 2'b00;

      assign idel_pat1_rise0[2] = 2'b11;
      assign idel_pat1_fall0[2] = 2'b01;
      assign idel_pat1_rise1[2] = 2'b00;
      assign idel_pat1_fall1[2] = 2'b10;

      assign idel_pat1_rise0[1] = 2'b01;
      assign idel_pat1_fall0[1] = 2'b00;
      assign idel_pat1_rise1[1] = 2'b10;
      assign idel_pat1_fall1[1] = 2'b11;

      assign idel_pat1_rise0[0] = 2'b00;
      assign idel_pat1_fall0[0] = 2'b10;
      assign idel_pat1_rise1[0] = 2'b11;
      assign idel_pat1_fall1[0] = 2'b10;


      // Correct data valid window for "early write"
      assign pat0_rise0[3] = 2'b00;
      assign pat0_fall0[3] = 2'b10;
      assign pat0_rise1[3] = 2'b11;
      assign pat0_fall1[3] = 2'b10;

      assign pat0_rise0[2] = 2'b10;
      assign pat0_fall0[2] = 2'b11;
      assign pat0_rise1[2] = 2'b10;
      assign pat0_fall1[2] = 2'b00;

      assign pat0_rise0[1] = 2'b11;
      assign pat0_fall0[1] = 2'b10;
      assign pat0_rise1[1] = 2'b01;
      assign pat0_fall1[1] = 2'b00;

      assign pat0_rise0[0] = 2'b10;
      assign pat0_fall0[0] = 2'b00;
      assign pat0_rise1[0] = 2'b01;
      assign pat0_fall1[0] = 2'b11;

      // Correct data valid window for "on-time write"
      assign pat1_rise0[3] = 2'b11;
      assign pat1_fall0[3] = 2'b01;
      assign pat1_rise1[3] = 2'b00;
      assign pat1_fall1[3] = 2'b10;

      assign pat1_rise0[2] = 2'b01;
      assign pat1_fall0[2] = 2'b00;
      assign pat1_rise1[2] = 2'b10;
      assign pat1_fall1[2] = 2'b11;

      assign pat1_rise0[1] = 2'b00;
      assign pat1_fall0[1] = 2'b10;
      assign pat1_rise1[1] = 2'b11;
      assign pat1_fall1[1] = 2'b10;

      assign pat1_rise0[0] = 2'b10;
      assign pat1_fall0[0] = 2'b11;
      assign pat1_rise1[0] = 2'b10;
      assign pat1_fall1[0] = 2'b00;
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

        // DQ IDELAY pattern detection
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == idel_pat0_rise0[pt_i%4])
            idel_pat0_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == idel_pat0_fall0[pt_i%4])
            idel_pat0_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == idel_pat0_rise1[pt_i%4])
            idel_pat0_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == idel_pat0_fall1[pt_i%4])
            idel_pat0_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == idel_pat0_rise2[pt_i%4])
            idel_pat0_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == idel_pat0_fall2[pt_i%4])
            idel_pat0_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == idel_pat0_rise3[pt_i%4])
            idel_pat0_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == idel_pat0_fall3[pt_i%4])
            idel_pat0_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == idel_pat1_rise0[pt_i%4])
            idel_pat1_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == idel_pat1_fall0[pt_i%4])
            idel_pat1_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == idel_pat1_rise1[pt_i%4])
            idel_pat1_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == idel_pat1_fall1[pt_i%4])
            idel_pat1_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == idel_pat1_rise2[pt_i%4])
            idel_pat1_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == idel_pat1_fall2[pt_i%4])
            idel_pat1_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == idel_pat1_rise3[pt_i%4])
            idel_pat1_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == idel_pat1_fall3[pt_i%4])
            idel_pat1_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

        // DQS DVW pattern detection
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat0_rise0[pt_i%4])
            pat0_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat0_fall0[pt_i%4])
            pat0_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat0_rise1[pt_i%4])
            pat0_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat0_fall1[pt_i%4])
            pat0_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall1_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise2_r[pt_i] == pat0_rise2[pt_i%4])
            pat0_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == pat0_fall2[pt_i%4])
            pat0_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == pat0_rise3[pt_i%4])
            pat0_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == pat0_fall3[pt_i%4])
            pat0_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

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

          if (sr_rise2_r[pt_i] == pat1_rise2[pt_i%4])
            pat1_match_rise2_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_rise2_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall2_r[pt_i] == pat1_fall2[pt_i%4])
            pat1_match_fall2_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_fall2_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise3_r[pt_i] == pat1_rise3[pt_i%4])
            pat1_match_rise3_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_rise3_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall3_r[pt_i] == pat1_fall3[pt_i%4])
            pat1_match_fall3_r[pt_i] <= #TCQ 1'b1;
          else
            pat1_match_fall3_r[pt_i] <= #TCQ 1'b0;
        end

      end

      // Combine pattern match "subterms" for DQ-IDELAY stage
      always @(posedge clk) begin
        idel_pat0_match_rise0_and_r <= #TCQ &idel_pat0_match_rise0_r;
        idel_pat0_match_fall0_and_r <= #TCQ &idel_pat0_match_fall0_r;
        idel_pat0_match_rise1_and_r <= #TCQ &idel_pat0_match_rise1_r;
        idel_pat0_match_fall1_and_r <= #TCQ &idel_pat0_match_fall1_r;
        idel_pat0_match_rise2_and_r <= #TCQ &idel_pat0_match_rise2_r;
        idel_pat0_match_fall2_and_r <= #TCQ &idel_pat0_match_fall2_r;
        idel_pat0_match_rise3_and_r <= #TCQ &idel_pat0_match_rise3_r;
        idel_pat0_match_fall3_and_r <= #TCQ &idel_pat0_match_fall3_r;
        idel_pat0_data_match_r <= #TCQ (idel_pat0_match_rise0_and_r &&
                                        idel_pat0_match_fall0_and_r &&
                                        idel_pat0_match_rise1_and_r &&
                                        idel_pat0_match_fall1_and_r &&
                                        idel_pat0_match_rise2_and_r &&
                                        idel_pat0_match_fall2_and_r &&
                                        idel_pat0_match_rise3_and_r &&
                                        idel_pat0_match_fall3_and_r);
      end

      always @(posedge clk) begin
        idel_pat1_match_rise0_and_r <= #TCQ &idel_pat1_match_rise0_r;
        idel_pat1_match_fall0_and_r <= #TCQ &idel_pat1_match_fall0_r;
        idel_pat1_match_rise1_and_r <= #TCQ &idel_pat1_match_rise1_r;
        idel_pat1_match_fall1_and_r <= #TCQ &idel_pat1_match_fall1_r;
        idel_pat1_match_rise2_and_r <= #TCQ &idel_pat1_match_rise2_r;
        idel_pat1_match_fall2_and_r <= #TCQ &idel_pat1_match_fall2_r;
        idel_pat1_match_rise3_and_r <= #TCQ &idel_pat1_match_rise3_r;
        idel_pat1_match_fall3_and_r <= #TCQ &idel_pat1_match_fall3_r;
        idel_pat1_data_match_r <= #TCQ (idel_pat1_match_rise0_and_r &&
                                        idel_pat1_match_fall0_and_r &&
                                        idel_pat1_match_rise1_and_r &&
                                        idel_pat1_match_fall1_and_r &&
                                        idel_pat1_match_rise2_and_r &&
                                        idel_pat1_match_fall2_and_r &&
                                        idel_pat1_match_rise3_and_r &&
                                        idel_pat1_match_fall3_and_r);
      end

      always @(*)
        idel_pat_data_match <= #TCQ idel_pat0_data_match_r |
                                    idel_pat1_data_match_r;

      always @(posedge clk)
        idel_pat_data_match_r <= #TCQ idel_pat_data_match;

      // Combine pattern match "subterms" for DQS-PHASER_IN stage
      always @(posedge clk) begin
        pat0_match_rise0_and_r <= #TCQ &pat0_match_rise0_r;
        pat0_match_fall0_and_r <= #TCQ &pat0_match_fall0_r;
        pat0_match_rise1_and_r <= #TCQ &pat0_match_rise1_r;
        pat0_match_fall1_and_r <= #TCQ &pat0_match_fall1_r;
        pat0_match_rise2_and_r <= #TCQ &pat0_match_rise2_r;
        pat0_match_fall2_and_r <= #TCQ &pat0_match_fall2_r;
        pat0_match_rise3_and_r <= #TCQ &pat0_match_rise3_r;
        pat0_match_fall3_and_r <= #TCQ &pat0_match_fall3_r;
        pat0_data_match_r <= #TCQ (pat0_match_rise0_and_r &&
                                   pat0_match_fall0_and_r &&
                                   pat0_match_rise1_and_r &&
                                   pat0_match_fall1_and_r &&
                                   pat0_match_rise2_and_r &&
                                   pat0_match_fall2_and_r &&
                                   pat0_match_rise3_and_r &&
                                   pat0_match_fall3_and_r);
      end

      always @(posedge clk) begin
        pat1_match_rise0_and_r <= #TCQ &pat1_match_rise0_r;
        pat1_match_fall0_and_r <= #TCQ &pat1_match_fall0_r;
        pat1_match_rise1_and_r <= #TCQ &pat1_match_rise1_r;
        pat1_match_fall1_and_r <= #TCQ &pat1_match_fall1_r;
        pat1_match_rise2_and_r <= #TCQ &pat1_match_rise2_r;
        pat1_match_fall2_and_r <= #TCQ &pat1_match_fall2_r;
        pat1_match_rise3_and_r <= #TCQ &pat1_match_rise3_r;
        pat1_match_fall3_and_r <= #TCQ &pat1_match_fall3_r;
        pat1_data_match_r <= #TCQ (pat1_match_rise0_and_r &&
                                   pat1_match_fall0_and_r &&
                                   pat1_match_rise1_and_r &&
                                   pat1_match_fall1_and_r &&
                                   pat1_match_rise2_and_r &&
                                   pat1_match_fall2_and_r &&
                                   pat1_match_rise3_and_r &&
                                   pat1_match_fall3_and_r);
      end

      assign pat_data_match_r = pat0_data_match_r | pat1_data_match_r;

    end else if (nCK_PER_CLK == 2) begin: gen_pat_match_div2
      for (pt_i = 0; pt_i < DRAM_WIDTH; pt_i = pt_i + 1) begin: gen_pat_match

        // DQ IDELAY pattern detection
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == idel_pat0_rise0[pt_i%4])
            idel_pat0_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == idel_pat0_fall0[pt_i%4])
            idel_pat0_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == idel_pat0_rise1[pt_i%4])
            idel_pat0_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == idel_pat0_fall1[pt_i%4])
            idel_pat0_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat0_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == idel_pat1_rise0[pt_i%4])
            idel_pat1_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == idel_pat1_fall0[pt_i%4])
            idel_pat1_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == idel_pat1_rise1[pt_i%4])
            idel_pat1_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == idel_pat1_fall1[pt_i%4])
            idel_pat1_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            idel_pat1_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

        // DQS DVW pattern detection
        always @(posedge clk) begin
          if (sr_rise0_r[pt_i] == pat0_rise0[pt_i%4])
            pat0_match_rise0_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise0_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall0_r[pt_i] == pat0_fall0[pt_i%4])
            pat0_match_fall0_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall0_r[pt_i] <= #TCQ 1'b0;

          if (sr_rise1_r[pt_i] == pat0_rise1[pt_i%4])
            pat0_match_rise1_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_rise1_r[pt_i] <= #TCQ 1'b0;

          if (sr_fall1_r[pt_i] == pat0_fall1[pt_i%4])
            pat0_match_fall1_r[pt_i] <= #TCQ 1'b1;
          else
            pat0_match_fall1_r[pt_i] <= #TCQ 1'b0;
        end

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

      end

        // Combine pattern match "subterms" for DQ-IDELAY stage
      always @(posedge clk) begin
        idel_pat0_match_rise0_and_r <= #TCQ &idel_pat0_match_rise0_r;
        idel_pat0_match_fall0_and_r <= #TCQ &idel_pat0_match_fall0_r;
        idel_pat0_match_rise1_and_r <= #TCQ &idel_pat0_match_rise1_r;
        idel_pat0_match_fall1_and_r <= #TCQ &idel_pat0_match_fall1_r;
        idel_pat0_data_match_r <= #TCQ (idel_pat0_match_rise0_and_r &&
                                        idel_pat0_match_fall0_and_r &&
                                        idel_pat0_match_rise1_and_r &&
                                        idel_pat0_match_fall1_and_r);
      end

      always @(posedge clk) begin
        idel_pat1_match_rise0_and_r <= #TCQ &idel_pat1_match_rise0_r;
        idel_pat1_match_fall0_and_r <= #TCQ &idel_pat1_match_fall0_r;
        idel_pat1_match_rise1_and_r <= #TCQ &idel_pat1_match_rise1_r;
        idel_pat1_match_fall1_and_r <= #TCQ &idel_pat1_match_fall1_r;
        idel_pat1_data_match_r <= #TCQ (idel_pat1_match_rise0_and_r &&
                                        idel_pat1_match_fall0_and_r &&
                                        idel_pat1_match_rise1_and_r &&
                                        idel_pat1_match_fall1_and_r);
      end

      always @(posedge clk) begin
        if (sr_valid_r2)
          idel_pat_data_match <= #TCQ idel_pat0_data_match_r |
                                      idel_pat1_data_match_r;
      end

      //assign idel_pat_data_match = idel_pat0_data_match_r |
      //                             idel_pat1_data_match_r;

      always @(posedge clk)
        idel_pat_data_match_r <= #TCQ idel_pat_data_match;

      // Combine pattern match "subterms" for DQS-PHASER_IN stage
      always @(posedge clk) begin
        pat0_match_rise0_and_r <= #TCQ &pat0_match_rise0_r;
        pat0_match_fall0_and_r <= #TCQ &pat0_match_fall0_r;
        pat0_match_rise1_and_r <= #TCQ &pat0_match_rise1_r;
        pat0_match_fall1_and_r <= #TCQ &pat0_match_fall1_r;
        pat0_data_match_r <= #TCQ (pat0_match_rise0_and_r &&
                                   pat0_match_fall0_and_r &&
                                   pat0_match_rise1_and_r &&
                                   pat0_match_fall1_and_r);
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
      end

      assign pat_data_match_r = pat0_data_match_r | pat1_data_match_r;

    end

  endgenerate


  always @(posedge clk) begin
    rdlvl_stg1_start_r <= #TCQ rdlvl_stg1_start;
    mpr_rdlvl_done_r1  <= #TCQ mpr_rdlvl_done_r;
    mpr_rdlvl_done_r2  <= #TCQ mpr_rdlvl_done_r1;
    mpr_rdlvl_start_r  <= #TCQ mpr_rdlvl_start;
  end

  //***************************************************************************
  // First stage calibration: Capture clock
  //***************************************************************************

  //*****************************************************************
  // Keep track of how many samples have been written to shift registers
  // Every time RD_SHIFT_LEN samples have been written, then we have a
  // full read training pattern loaded into the sr_* registers. Then assert
  // sr_valid_r to indicate that: (1) comparison between the sr_* and
  // old_sr_* and prev_sr_* registers can take place, (2) transfer of
  // the contents of sr_* to old_sr_* and prev_sr_* registers can also
  // take place
  //*****************************************************************
// verilint STARC-2.2.3.3 off
  always @(posedge clk)
    if (rst || (mpr_rdlvl_done_r && ~rdlvl_stg1_start)) begin
      cnt_shift_r <= #TCQ 'b1;
      sr_valid_r  <= #TCQ 1'b0;
      mpr_valid_r <= #TCQ 1'b0;
    end else begin
      if (mux_rd_valid_r && mpr_rdlvl_start && ~mpr_rdlvl_done_r) begin
        if (cnt_shift_r == 'b0)
          mpr_valid_r <= #TCQ 1'b1;
        else begin
          mpr_valid_r <= #TCQ 1'b0;
          cnt_shift_r <= #TCQ cnt_shift_r + 1;
        end
      end else
        mpr_valid_r <= #TCQ 1'b0;

      if (mux_rd_valid_r && rdlvl_stg1_start) begin
        if (cnt_shift_r == RD_SHIFT_LEN-1) begin
          sr_valid_r <= #TCQ 1'b1;
          cnt_shift_r <= #TCQ 'b0;
        end else begin
          sr_valid_r <= #TCQ 1'b0;
          cnt_shift_r <= #TCQ cnt_shift_r + 1;
        end
      end else
        // When the current mux_rd_* contents are not valid, then
        // retain the current value of cnt_shift_r, and make sure
        // that sr_valid_r = 0 to prevent any downstream loads or
        // comparisons
        sr_valid_r <= #TCQ 1'b0;
    end
// verilint STARC-2.2.3.3 on
  //*****************************************************************
  // Logic to determine when either edge of the data eye encountered
  // Pre- and post-IDELAY update data pattern is compared, if they
  // differ, than an edge has been encountered. Currently no attempt
  // made to determine if the data pattern itself is "correct", only
  // whether it changes after incrementing the IDELAY (possible
  // future enhancement)
  //*****************************************************************

  // One-way control for ensuring that state machine request to store
  // current read data into OLD SR shift register only occurs on a
  // valid clock cycle. The FSM provides a one-cycle request pulse.
  // It is the responsibility of the FSM to wait the worst-case time
  // before relying on any downstream results of this load.
  always @(posedge clk)
    if (rst)
      store_sr_r      <= #TCQ 1'b0;
    else begin
      if (store_sr_req_r)
        store_sr_r <= #TCQ 1'b1;
      else if ((sr_valid_r || mpr_valid_r) && store_sr_r)
        store_sr_r <= #TCQ 1'b0;
    end

  // Transfer current data to old data, prior to incrementing delay
  // Also store data from current sampling window - so that we can detect
  // if the current delay tap yields data that is "jittery"
  generate
    if (nCK_PER_CLK == 4) begin: gen_old_sr_div4
    for (z = 0; z < DRAM_WIDTH; z = z + 1) begin: gen_old_sr
      always @(posedge clk) begin
        if (sr_valid_r || mpr_valid_r) begin
          // Load last sample (i.e. from current sampling interval)
          prev_sr_rise0_r[z] <= #TCQ sr_rise0_r[z];
          prev_sr_fall0_r[z] <= #TCQ sr_fall0_r[z];
          prev_sr_rise1_r[z] <= #TCQ sr_rise1_r[z];
          prev_sr_fall1_r[z] <= #TCQ sr_fall1_r[z];
          prev_sr_rise2_r[z] <= #TCQ sr_rise2_r[z];
          prev_sr_fall2_r[z] <= #TCQ sr_fall2_r[z];
          prev_sr_rise3_r[z] <= #TCQ sr_rise3_r[z];
          prev_sr_fall3_r[z] <= #TCQ sr_fall3_r[z];
        end
        if ((sr_valid_r || mpr_valid_r) && store_sr_r) begin
          old_sr_rise0_r[z] <= #TCQ sr_rise0_r[z];
          old_sr_fall0_r[z] <= #TCQ sr_fall0_r[z];
          old_sr_rise1_r[z] <= #TCQ sr_rise1_r[z];
          old_sr_fall1_r[z] <= #TCQ sr_fall1_r[z];
          old_sr_rise2_r[z] <= #TCQ sr_rise2_r[z];
          old_sr_fall2_r[z] <= #TCQ sr_fall2_r[z];
          old_sr_rise3_r[z] <= #TCQ sr_rise3_r[z];
          old_sr_fall3_r[z] <= #TCQ sr_fall3_r[z];
        end
      end
    end
    end else if (nCK_PER_CLK == 2) begin: gen_old_sr_div2
      for (z = 0; z < DRAM_WIDTH; z = z + 1) begin: gen_old_sr
        always @(posedge clk) begin
          if (sr_valid_r || mpr_valid_r) begin
            prev_sr_rise0_r[z] <= #TCQ sr_rise0_r[z];
            prev_sr_fall0_r[z] <= #TCQ sr_fall0_r[z];
            prev_sr_rise1_r[z] <= #TCQ sr_rise1_r[z];
            prev_sr_fall1_r[z] <= #TCQ sr_fall1_r[z];
          end
          if ((sr_valid_r || mpr_valid_r) && store_sr_r) begin
            old_sr_rise0_r[z] <= #TCQ sr_rise0_r[z];
            old_sr_fall0_r[z] <= #TCQ sr_fall0_r[z];
            old_sr_rise1_r[z] <= #TCQ sr_rise1_r[z];
            old_sr_fall1_r[z] <= #TCQ sr_fall1_r[z];
          end
        end
      end
    end
  endgenerate

  //*******************************************************
  // Match determination occurs over 3 cycles - pipelined for better timing
  //*******************************************************

  // Match valid with # of cycles of pipelining in match determination
  always @(posedge clk) begin
    sr_valid_r1  <= #TCQ sr_valid_r;
    sr_valid_r2  <= #TCQ sr_valid_r1;
    mpr_valid_r1 <= #TCQ mpr_valid_r;
    mpr_valid_r2 <= #TCQ mpr_valid_r1;
  end

  generate
    if (nCK_PER_CLK == 4) begin: gen_sr_match_div4
    for (z = 0; z < DRAM_WIDTH; z = z + 1) begin: gen_sr_match
      always @(posedge clk) begin
        // CYCLE1: Compare all bits in DQS grp, generate separate term for
        //  each bit over four bit times. For example, if there are 8-bits
        //  per DQS group, 32 terms are generated on cycle 1
        // NOTE: Structure HDL such that X on data bus will result in a
        //  mismatch. This is required for memory models that can drive the
        //  bus with X's to model uncertainty regions (e.g. Denali)
        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise0_r[z] == old_sr_rise0_r[z]))
          old_sr_match_rise0_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_rise0_r[z] <= #TCQ old_sr_match_rise0_r[z];
        else
          old_sr_match_rise0_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall0_r[z] == old_sr_fall0_r[z]))
          old_sr_match_fall0_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_fall0_r[z] <= #TCQ old_sr_match_fall0_r[z];
        else
          old_sr_match_fall0_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise1_r[z] == old_sr_rise1_r[z]))
          old_sr_match_rise1_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_rise1_r[z] <= #TCQ old_sr_match_rise1_r[z];
        else
          old_sr_match_rise1_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall1_r[z] == old_sr_fall1_r[z]))
          old_sr_match_fall1_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_fall1_r[z] <= #TCQ old_sr_match_fall1_r[z];
        else
          old_sr_match_fall1_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise2_r[z] == old_sr_rise2_r[z]))
          old_sr_match_rise2_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_rise2_r[z] <= #TCQ old_sr_match_rise2_r[z];
        else
          old_sr_match_rise2_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall2_r[z] == old_sr_fall2_r[z]))
          old_sr_match_fall2_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_fall2_r[z] <= #TCQ old_sr_match_fall2_r[z];
        else
          old_sr_match_fall2_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise3_r[z] == old_sr_rise3_r[z]))
          old_sr_match_rise3_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_rise3_r[z] <= #TCQ old_sr_match_rise3_r[z];
        else
          old_sr_match_rise3_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall3_r[z] == old_sr_fall3_r[z]))
          old_sr_match_fall3_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          old_sr_match_fall3_r[z] <= #TCQ old_sr_match_fall3_r[z];
        else
          old_sr_match_fall3_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise0_r[z] == prev_sr_rise0_r[z]))
          prev_sr_match_rise0_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_rise0_r[z] <= #TCQ prev_sr_match_rise0_r[z];
        else
          prev_sr_match_rise0_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall0_r[z] == prev_sr_fall0_r[z]))
          prev_sr_match_fall0_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_fall0_r[z] <= #TCQ prev_sr_match_fall0_r[z];
        else
          prev_sr_match_fall0_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise1_r[z] == prev_sr_rise1_r[z]))
          prev_sr_match_rise1_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_rise1_r[z] <= #TCQ prev_sr_match_rise1_r[z];
        else
          prev_sr_match_rise1_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall1_r[z] == prev_sr_fall1_r[z]))
          prev_sr_match_fall1_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_fall1_r[z] <= #TCQ prev_sr_match_fall1_r[z];
        else
          prev_sr_match_fall1_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise2_r[z] == prev_sr_rise2_r[z]))
          prev_sr_match_rise2_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_rise2_r[z] <= #TCQ prev_sr_match_rise2_r[z];
        else
          prev_sr_match_rise2_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall2_r[z] == prev_sr_fall2_r[z]))
          prev_sr_match_fall2_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_fall2_r[z] <= #TCQ prev_sr_match_fall2_r[z];
        else
          prev_sr_match_fall2_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_rise3_r[z] == prev_sr_rise3_r[z]))
          prev_sr_match_rise3_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_rise3_r[z] <= #TCQ prev_sr_match_rise3_r[z];
        else
          prev_sr_match_rise3_r[z] <= #TCQ 1'b0;

        if ((pat_data_match_r || mpr_valid_r1) && (sr_fall3_r[z] == prev_sr_fall3_r[z]))
          prev_sr_match_fall3_r[z] <= #TCQ 1'b1;
        else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
          prev_sr_match_fall3_r[z] <= #TCQ prev_sr_match_fall3_r[z];
        else
          prev_sr_match_fall3_r[z] <= #TCQ 1'b0;

        // CYCLE2: Combine all the comparisons for every 8 words (rise0,
        //  fall0,rise1, fall1) in the calibration sequence. Now we're down
        //  to DRAM_WIDTH terms
          old_sr_match_cyc2_r[z] <= #TCQ
                                    old_sr_match_rise0_r[z] &
                                  old_sr_match_fall0_r[z] &
                                  old_sr_match_rise1_r[z] &
                                  old_sr_match_fall1_r[z] &
                                  old_sr_match_rise2_r[z] &
                                  old_sr_match_fall2_r[z] &
                                  old_sr_match_rise3_r[z] &
                                  old_sr_match_fall3_r[z];
          prev_sr_match_cyc2_r[z] <= #TCQ
                                     prev_sr_match_rise0_r[z] &
                                   prev_sr_match_fall0_r[z] &
                                   prev_sr_match_rise1_r[z] &
                                   prev_sr_match_fall1_r[z] &
                                   prev_sr_match_rise2_r[z] &
                                   prev_sr_match_fall2_r[z] &
                                   prev_sr_match_rise3_r[z] &
                                   prev_sr_match_fall3_r[z];

        // CYCLE3: Invert value (i.e. assert when DIFFERENCE in value seen),
        //  and qualify with pipelined valid signal) - probably don't need
        //  a cycle just do do this....
        if (sr_valid_r2 || mpr_valid_r2) begin
          old_sr_diff_r[z]  <= #TCQ ~old_sr_match_cyc2_r[z];
          prev_sr_diff_r[z] <= #TCQ ~prev_sr_match_cyc2_r[z];
        end else begin
          old_sr_diff_r[z]  <= #TCQ 'b0;
          prev_sr_diff_r[z] <= #TCQ 'b0;
        end
        end
      end
    end if (nCK_PER_CLK == 2) begin: gen_sr_match_div2
      for (z = 0; z < DRAM_WIDTH; z = z + 1) begin: gen_sr_match
        always @(posedge clk) begin
          if ((sr_valid_r || mpr_valid_r1) && (sr_rise0_r[z] == old_sr_rise0_r[z]))
            old_sr_match_rise0_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            old_sr_match_rise0_r[z] <= #TCQ old_sr_match_rise0_r[z];
          else
            old_sr_match_rise0_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_fall0_r[z] == old_sr_fall0_r[z]))
            old_sr_match_fall0_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            old_sr_match_fall0_r[z] <= #TCQ old_sr_match_fall0_r[z];
          else
            old_sr_match_fall0_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_rise1_r[z] == old_sr_rise1_r[z]))
            old_sr_match_rise1_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            old_sr_match_rise1_r[z] <= #TCQ old_sr_match_rise1_r[z];
          else
            old_sr_match_rise1_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_fall1_r[z] == old_sr_fall1_r[z]))
            old_sr_match_fall1_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            old_sr_match_fall1_r[z] <= #TCQ old_sr_match_fall1_r[z];
          else
            old_sr_match_fall1_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_rise0_r[z] == prev_sr_rise0_r[z]))
            prev_sr_match_rise0_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            prev_sr_match_rise0_r[z] <= #TCQ prev_sr_match_rise0_r[z];
          else
            prev_sr_match_rise0_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_fall0_r[z] == prev_sr_fall0_r[z]))
            prev_sr_match_fall0_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            prev_sr_match_fall0_r[z] <= #TCQ prev_sr_match_fall0_r[z];
          else
            prev_sr_match_fall0_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_rise1_r[z] == prev_sr_rise1_r[z]))
            prev_sr_match_rise1_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            prev_sr_match_rise1_r[z] <= #TCQ prev_sr_match_rise1_r[z];
          else
            prev_sr_match_rise1_r[z] <= #TCQ 1'b0;

          if ((sr_valid_r || mpr_valid_r1) && (sr_fall1_r[z] == prev_sr_fall1_r[z]))
            prev_sr_match_fall1_r[z] <= #TCQ 1'b1;
          else if (~mpr_valid_r1 && mpr_rdlvl_start && ~mpr_rdlvl_done_r)
            prev_sr_match_fall1_r[z] <= #TCQ prev_sr_match_fall1_r[z];
          else
            prev_sr_match_fall1_r[z] <= #TCQ 1'b0;

          old_sr_match_cyc2_r[z] <= #TCQ
                                    old_sr_match_rise0_r[z] &
                                    old_sr_match_fall0_r[z] &
                                    old_sr_match_rise1_r[z] &
                                    old_sr_match_fall1_r[z];
          prev_sr_match_cyc2_r[z] <= #TCQ
                                     prev_sr_match_rise0_r[z] &
                                     prev_sr_match_fall0_r[z] &
                                     prev_sr_match_rise1_r[z] &
                                     prev_sr_match_fall1_r[z];

          // CYCLE3: Invert value (i.e. assert when DIFFERENCE in value seen),
          //  and qualify with pipelined valid signal) - probably don't need
          //  a cycle just do do this....
          if (sr_valid_r2 || mpr_valid_r2) begin
            old_sr_diff_r[z]  <= #TCQ ~old_sr_match_cyc2_r[z];
            prev_sr_diff_r[z] <= #TCQ ~prev_sr_match_cyc2_r[z];
          end else begin
            old_sr_diff_r[z]  <= #TCQ 'b0;
            prev_sr_diff_r[z] <= #TCQ 'b0;
          end
        end
     end
    end
  endgenerate

  //***************************************************************************
  // First stage calibration: DQS Capture
  //***************************************************************************


  //*******************************************************
  // Counters for tracking # of samples compared
  // For each comparision point (i.e. to determine if an edge has
  // occurred after each IODELAY increment when read leveling),
  // multiple samples are compared in order to average out the effects
  // of jitter. If any one of these samples is different than the "old"
  // sample corresponding to the previous IODELAY value, then an edge
  // is declared to be detected.
  //*******************************************************

  // Two cascaded counters are used to keep track of # of samples compared,
  // in order to make it easier to meeting timing on these paths. Once
  // optimal sampling interval is determined, it may be possible to remove
  // the second counter
  always @(posedge clk)
    samp_edge_cnt0_en_r <= #TCQ
                          (cal1_state_r == CAL1_PAT_DETECT) ||
                          (cal1_state_r == CAL1_DETECT_EDGE) ||
                          (cal1_state_r == CAL1_PB_DETECT_EDGE) ||
                          (cal1_state_r == CAL1_PB_DETECT_EDGE_DQ);

  // First counter counts # of samples compared
  always @(posedge clk)
    if (rst)
      samp_edge_cnt0_r <= #TCQ 'b0;
    else begin
      if (!samp_edge_cnt0_en_r)
        // Reset sample counter when not in any of the "sampling" states
        samp_edge_cnt0_r <= #TCQ 'b0;
      else if (sr_valid_r2 || mpr_valid_r2)
        // Otherwise, count # of samples compared
        samp_edge_cnt0_r <= #TCQ samp_edge_cnt0_r + 1;
    end

  // Counter #2 enable generation
  always @(posedge clk)
    if (rst)
      samp_edge_cnt1_en_r <= #TCQ 1'b0;
    else begin
      // Assert pulse when correct number of samples compared
      if ((samp_edge_cnt0_r == DETECT_EDGE_SAMPLE_CNT0) &&
          (sr_valid_r2 || mpr_valid_r2))
        samp_edge_cnt1_en_r <= #TCQ 1'b1;
      else
        samp_edge_cnt1_en_r <= #TCQ 1'b0;
    end

  // Counter #2
  always @(posedge clk)
    if (rst)
      samp_edge_cnt1_r <= #TCQ 'b0;
    else
      if (!samp_edge_cnt0_en_r)
        samp_edge_cnt1_r <= #TCQ 'b0;
      else if (samp_edge_cnt1_en_r)
        samp_edge_cnt1_r <= #TCQ samp_edge_cnt1_r + 1;

  always @(posedge clk)
    if (rst)
      samp_cnt_done_r <= #TCQ 1'b0;
    else begin
      if (!samp_edge_cnt0_en_r)
        samp_cnt_done_r <= #TCQ 'b0;
      else if ((SIM_CAL_OPTION == "FAST_CAL") ||
               (SIM_CAL_OPTION == "FAST_WIN_DETECT")) begin
        if (samp_edge_cnt0_r == SR_VALID_DELAY-1)
          // For simulation only, stay in edge detection mode a minimum
          // amount of time - just enough for two data compares to finish
          samp_cnt_done_r <= #TCQ 1'b1;
      end else begin
        if (samp_edge_cnt1_r == DETECT_EDGE_SAMPLE_CNT1)
          samp_cnt_done_r <= #TCQ 1'b1;
      end
    end

  //*****************************************************************
  // Logic to keep track of (on per-bit basis):
  //  1. When a region of stability preceded by a known edge occurs
  //  2. If for the current tap, the read data jitters
  //  3. If an edge occured between the current and previous tap
  //  4. When the current edge detection/sampling interval can end
  // Essentially, these are a series of status bits - the stage 1
  // calibration FSM monitors these to determine when an edge is
  // found. Additional information is provided to help the FSM
  // determine if a left or right edge has been found.
  //****************************************************************

  assign pb_detect_edge_setup
    = (cal1_state_r == CAL1_STORE_FIRST_WAIT) ||
      (cal1_state_r == CAL1_PB_STORE_FIRST_WAIT) ||
      (cal1_state_r == CAL1_PB_DEC_CPT_LEFT_WAIT);

  assign pb_detect_edge
    = (cal1_state_r == CAL1_PAT_DETECT) ||
      (cal1_state_r == CAL1_DETECT_EDGE) ||
      (cal1_state_r == CAL1_PB_DETECT_EDGE) ||
      (cal1_state_r == CAL1_PB_DETECT_EDGE_DQ);

  generate
    for (z = 0; z < DRAM_WIDTH; z = z + 1) begin: gen_track_left_edge
      always @(posedge clk) begin
        if (pb_detect_edge_setup) begin
          // Reset eye size, stable eye marker, and jitter marker before
          // starting new edge detection iteration
          pb_cnt_eye_size_r[z]     <= #TCQ 5'd0;
          pb_detect_edge_done_r[z] <= #TCQ 1'b0;
          pb_found_stable_eye_r[z] <= #TCQ 1'b0;
          pb_last_tap_jitter_r[z]  <= #TCQ 1'b0;
          pb_found_edge_last_r[z]  <= #TCQ 1'b0;
          pb_found_edge_r[z]       <= #TCQ 1'b0;
          pb_found_first_edge_r[z] <= #TCQ 1'b0;
        end else if (pb_detect_edge) begin
          // Save information on which DQ bits are already out of the
          // data valid window - those DQ bits will later not have their
          // IDELAY tap value incremented
          pb_found_edge_last_r[z] <= #TCQ pb_found_edge_r[z];

          if (!pb_detect_edge_done_r[z]) begin
            if (samp_cnt_done_r) begin
              // If we've reached end of sampling interval, no jitter on
              // current tap has been found (although an edge could have
              // been found between the current and previous taps), and
              // the sampling interval is complete. Increment the stable
              // eye counter if no edge found, and always clear the jitter
              // flag in preparation for the next tap.
              pb_last_tap_jitter_r[z]  <= #TCQ 1'b0;
              pb_detect_edge_done_r[z] <= #TCQ 1'b1;
              if (!pb_found_edge_r[z] && !pb_last_tap_jitter_r[z]) begin
                // If the data was completely stable during this tap and
                // no edge was found between this and the previous tap
                // then increment the stable eye counter "as appropriate"
                if (pb_cnt_eye_size_r[z] != MIN_EYE_SIZE-1)
                  pb_cnt_eye_size_r[z] <= #TCQ pb_cnt_eye_size_r[z] + 1;
                else //if (pb_found_first_edge_r[z])
                  // We've reached minimum stable eye width
                  pb_found_stable_eye_r[z] <= #TCQ 1'b1;
              end else begin
                // Otherwise, an edge was found, either because of a
                // difference between this and the previous tap's read
                // data, and/or because the previous tap's data jittered
                // (but not the current tap's data), then just set the
                // edge found flag, and enable the stable eye counter
                pb_cnt_eye_size_r[z]     <= #TCQ 5'd0;
                pb_found_stable_eye_r[z] <= #TCQ 1'b0;
                pb_found_edge_r[z]       <= #TCQ 1'b1;
                pb_detect_edge_done_r[z] <= #TCQ 1'b1;
              end
            end else if (prev_sr_diff_r[z]) begin
              // If we find that the current tap read data jitters, then
              // set edge and jitter found flags, "enable" the eye size
              // counter, and stop sampling interval for this bit
              pb_cnt_eye_size_r[z]     <= #TCQ 5'd0;
              pb_found_stable_eye_r[z] <= #TCQ 1'b0;
              pb_last_tap_jitter_r[z]  <= #TCQ 1'b1;
              pb_found_edge_r[z]       <= #TCQ 1'b1;
              pb_found_first_edge_r[z] <= #TCQ 1'b1;
              pb_detect_edge_done_r[z] <= #TCQ 1'b1;
            end else if (old_sr_diff_r[z] || pb_last_tap_jitter_r[z]) begin
              // If either an edge was found (i.e. difference between
              // current tap and previous tap read data), or the previous
              // tap exhibited jitter (which means by definition that the
              // current tap cannot match the previous tap because the
              // previous tap gave unstable data), then set the edge found
              // flag, and "enable" eye size counter. But do not stop
              // sampling interval - we still need to check if the current
              // tap exhibits jitter
              pb_cnt_eye_size_r[z]     <= #TCQ 5'd0;
              pb_found_stable_eye_r[z] <= #TCQ 1'b0;
              pb_found_edge_r[z]       <= #TCQ 1'b1;
              pb_found_first_edge_r[z] <= #TCQ 1'b1;
            end
          end
        end else begin
          // Before every edge detection interval, reset "intra-tap" flags
          pb_found_edge_r[z]       <= #TCQ 1'b0;
          pb_detect_edge_done_r[z] <= #TCQ 1'b0;
        end
      end
    end
  endgenerate

  // Combine the above per-bit status flags into combined terms when
  // performing deskew on the aggregate data window
  always @(posedge clk) begin
    detect_edge_done_r <= #TCQ &pb_detect_edge_done_r;
    found_edge_r       <= #TCQ |pb_found_edge_r;
    found_edge_all_r   <= #TCQ &pb_found_edge_r;
    found_stable_eye_r <= #TCQ &pb_found_stable_eye_r;
  end

  // last IODELAY "stable eye" indicator is updated only after
  // detect_edge_done_r is asserted - so that when we do find the "right edge"
  // of the data valid window, found_edge_r = 1, AND found_stable_eye_r = 1
  // when detect_edge_done_r = 1 (otherwise, if found_stable_eye_r updates
  // immediately, then it never possible to have found_stable_eye_r = 1
  // when we detect an edge - and we'll never know whether we've found
  // a "right edge")
  always @(posedge clk)
    if (pb_detect_edge_setup)
      found_stable_eye_last_r <= #TCQ 1'b0;
    else if (detect_edge_done_r)
      found_stable_eye_last_r <= #TCQ found_stable_eye_r;

  //*****************************************************************
  // Keep track of DQ IDELAYE2 taps used
  //*****************************************************************

  // Added additional register stage to improve timing
  always @(posedge clk)
    if (rst)
      idelay_tap_cnt_slice_r <= 5'h0;
    else
      idelay_tap_cnt_slice_r <= idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing];

  always @(posedge clk)
    if (rst || (SIM_CAL_OPTION == "SKIP_CAL")) begin //|| new_cnt_cpt_r
      for (s = 0; s < RANKS; s = s + 1) begin
        for (t = 0; t < DQS_WIDTH; t = t + 1) begin
          idelay_tap_cnt_r[s][t] <= #TCQ idelaye2_init_val;
        end
      end
    end else if (SIM_CAL_OPTION == "FAST_CAL") begin
      for (u = 0; u < RANKS; u = u + 1) begin
        for (w = 0; w < DQS_WIDTH; w = w + 1) begin
          if (cal1_dq_idel_ce) begin
            if (cal1_dq_idel_inc)
              idelay_tap_cnt_r[u][w] <= #TCQ idelay_tap_cnt_r[u][w] + 1;
            else
              idelay_tap_cnt_r[u][w] <= #TCQ idelay_tap_cnt_r[u][w] - 1;
          end
        end
      end
    end else if ((rnk_cnt_r == RANKS-1) && (RANKS == 2) &&
                    rdlvl_rank_done_r && (cal1_state_r == CAL1_IDLE)) begin
      for (f = 0; f < DQS_WIDTH; f = f + 1) begin
        idelay_tap_cnt_r[rnk_cnt_r][f] <= #TCQ idelay_tap_cnt_r[(rnk_cnt_r-1)][f];
      end
    end else if (cal1_dq_idel_ce) begin
      if (cal1_dq_idel_inc)
        idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] <= #TCQ idelay_tap_cnt_slice_r + 5'h1;
      else
        idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing] <= #TCQ idelay_tap_cnt_slice_r - 5'h1;
    end else if (idelay_ld)
      idelay_tap_cnt_r[0][wrcal_cnt] <= #TCQ 5'b00000;

  always @(posedge clk)
    if (rst || new_cnt_cpt_r)
      idelay_tap_limit_r <= #TCQ 1'b0;
    else if (idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_r] == 'd31)
      idelay_tap_limit_r <= #TCQ 1'b1;

  //*****************************************************************
  // keep track of edge tap counts found, and current capture clock
  // tap count
  //*****************************************************************

  always @(posedge clk)
    if (rst || new_cnt_cpt_r ||
        (mpr_rdlvl_done_r1 && ~mpr_rdlvl_done_r2))
      tap_cnt_cpt_r   <= #TCQ 'b0;
    else if (cal1_dlyce_cpt_r) begin
      if (cal1_dlyinc_cpt_r)
        tap_cnt_cpt_r <= #TCQ tap_cnt_cpt_r + 1;
      else if (tap_cnt_cpt_r != 'd0)
        tap_cnt_cpt_r <= #TCQ tap_cnt_cpt_r - 1;
    end

  always @(posedge clk)
    if (rst || new_cnt_cpt_r ||
       (cal1_state_r1 == CAL1_DQ_IDEL_TAP_INC) ||
       (mpr_rdlvl_done_r1 && ~mpr_rdlvl_done_r2))
      tap_limit_cpt_r <= #TCQ 1'b0;
    else if (tap_cnt_cpt_r == 6'd63)
      tap_limit_cpt_r <= #TCQ 1'b1;

   always @(posedge clk)
     cal1_cnt_cpt_timing_r <= #TCQ cal1_cnt_cpt_r;

   assign cal1_cnt_cpt_timing = {2'b00, cal1_cnt_cpt_r};

   // Storing DQS tap values at the end of each DQS read leveling
   always @(posedge clk) begin
     if (rst) begin
       for (a = 0; a < RANKS; a = a + 1) begin: rst_rdlvl_dqs_tap_count_loop
         for (b = 0; b < DQS_WIDTH; b = b + 1)
           rdlvl_dqs_tap_cnt_r[a][b] <= #TCQ 'b0;
       end
     end else if ((SIM_CAL_OPTION == "FAST_CAL") & (cal1_state_r1 == CAL1_NEXT_DQS)) begin
       for (p = 0; p < RANKS; p = p +1) begin: rdlvl_dqs_tap_rank_cnt
         for(q = 0; q < DQS_WIDTH; q = q +1) begin: rdlvl_dqs_tap_cnt
           rdlvl_dqs_tap_cnt_r[p][q] <= #TCQ tap_cnt_cpt_r;
         end
       end
     end else if (SIM_CAL_OPTION == "SKIP_CAL") begin
       for (j = 0; j < RANKS; j = j +1) begin: rdlvl_dqs_tap_rnk_cnt
         for(i = 0; i < DQS_WIDTH; i = i +1) begin: rdlvl_dqs_cnt
           rdlvl_dqs_tap_cnt_r[j][i] <= #TCQ 6'd31;
         end
       end
     end else if (cal1_state_r1 == CAL1_NEXT_DQS) begin
       rdlvl_dqs_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing_r] <= #TCQ tap_cnt_cpt_r;
     end
   end


  // Counter to track maximum DQ IODELAY tap usage during the per-bit
  // deskew portion of stage 1 calibration
  always @(posedge clk)
    if (rst) begin
      idel_tap_cnt_dq_pb_r   <= #TCQ 'b0;
      idel_tap_limit_dq_pb_r <= #TCQ 1'b0;
    end else
      if (new_cnt_cpt_r) begin
        idel_tap_cnt_dq_pb_r   <= #TCQ 'b0;
        idel_tap_limit_dq_pb_r <= #TCQ 1'b0;
      end else if (|cal1_dlyce_dq_r) begin
        if (cal1_dlyinc_dq_r)
          idel_tap_cnt_dq_pb_r <= #TCQ idel_tap_cnt_dq_pb_r + 1;
        else
          idel_tap_cnt_dq_pb_r <= #TCQ idel_tap_cnt_dq_pb_r - 1;

        if (idel_tap_cnt_dq_pb_r == 31)
          idel_tap_limit_dq_pb_r <= #TCQ 1'b1;
        else
          idel_tap_limit_dq_pb_r <= #TCQ 1'b0;
      end


  //*****************************************************************

  always @(posedge clk) begin
    cal1_state_r1 <= #TCQ cal1_state_r;
    cal1_state_r2 <= #TCQ cal1_state_r1;
    cal1_state_r3 <= #TCQ cal1_state_r2;
  end

  always @(posedge clk)
    if (rst) begin
      cal1_cnt_cpt_r        <= #TCQ 'b0;
      cal1_dlyce_cpt_r      <= #TCQ 1'b0;
      cal1_dlyinc_cpt_r     <= #TCQ 1'b0;
      cal1_dq_idel_ce       <= #TCQ 1'b0;
      cal1_dq_idel_inc      <= #TCQ 1'b0;
      cal1_prech_req_r      <= #TCQ 1'b0;
      cal1_state_r          <= #TCQ CAL1_IDLE;
      cnt_idel_dec_cpt_r    <= #TCQ 6'bxxxxxx;
      found_first_edge_r    <= #TCQ 1'b0;
      found_second_edge_r   <= #TCQ 1'b0;
      right_edge_taps_r     <= #TCQ 6'b000000;
      first_edge_taps_r     <= #TCQ 6'bxxxxxx;
      new_cnt_cpt_r         <= #TCQ 1'b0;
      rdlvl_stg1_done_int       <= #TCQ 1'b0;
      rdlvl_stg1_err        <= #TCQ 1'b0;
      second_edge_taps_r    <= #TCQ 6'bxxxxxx;
      store_sr_req_pulsed_r <= #TCQ 1'b0;
      store_sr_req_r        <= #TCQ 1'b0;
      rnk_cnt_r             <= #TCQ 2'b00;
      rdlvl_rank_done_r     <= #TCQ 1'b0;
      idel_dec_cnt          <= #TCQ 'd0;
      rdlvl_last_byte_done_int  <= #TCQ 1'b0;
      idel_pat_detect_valid_r <= #TCQ 1'b0;
      mpr_rank_done_r       <= #TCQ 1'b0;
      mpr_last_byte_done    <= #TCQ 1'b0;
      idel_adj_inc          <= #TCQ 1'b0;
      if (OCAL_EN == "ON")
        mpr_rdlvl_done_r      <= #TCQ 1'b0;
      else
        mpr_rdlvl_done_r      <= #TCQ 1'b1;
        mpr_dec_cpt_r           <= #TCQ 1'b0;
        rdlvl_pi_incdec         <= #TCQ 1'b0;
    end else begin
      // default (inactive) states for all "pulse" outputs
      // verilint STARC-2.2.3.3 off
      cal1_prech_req_r    <= #TCQ 1'b0;
      cal1_dlyce_cpt_r    <= #TCQ 1'b0;
      cal1_dlyinc_cpt_r   <= #TCQ 1'b0;
      cal1_dq_idel_ce     <= #TCQ 1'b0;
      cal1_dq_idel_inc    <= #TCQ 1'b0;
      new_cnt_cpt_r       <= #TCQ 1'b0;
      store_sr_req_pulsed_r <= #TCQ 1'b0;
      store_sr_req_r      <= #TCQ 1'b0;

      case (cal1_state_r)

        CAL1_IDLE: begin
          rdlvl_rank_done_r    <= #TCQ 1'b0;
          rdlvl_last_byte_done_int <= #TCQ 1'b0;
          mpr_rank_done_r      <= #TCQ 1'b0;
          mpr_last_byte_done   <= #TCQ 1'b0;
          if (mpr_rdlvl_start && ~mpr_rdlvl_start_r) begin
            rdlvl_pi_incdec <= #TCQ 1'b0;
            cal1_state_r  <= #TCQ CAL1_MPR_NEW_DQS_WAIT;
          end else begin
            rdlvl_pi_incdec    <= #TCQ 1'b1;
            if (rdlvl_stg1_start && ~rdlvl_stg1_start_r) begin
              if (SIM_CAL_OPTION == "SKIP_CAL")
                cal1_state_r  <= #TCQ CAL1_REGL_LOAD;
              else if (SIM_CAL_OPTION == "FAST_CAL")
                cal1_state_r  <= #TCQ CAL1_NEXT_DQS;
              else begin
                new_cnt_cpt_r <= #TCQ 1'b1;
                cal1_state_r  <= #TCQ CAL1_NEW_DQS_WAIT;
              end
            end
          end
        end

        CAL1_MPR_NEW_DQS_WAIT: begin
          cal1_prech_req_r  <= #TCQ 1'b0;
          if (!cal1_wait_r && mpr_valid_r)
            cal1_state_r <= #TCQ CAL1_MPR_PAT_DETECT;
        end

        // Wait for the new DQS group to change
        // also gives time for the read data IN_FIFO to
        // output the updated data for the new DQS group
        CAL1_NEW_DQS_WAIT: begin
          rdlvl_rank_done_r    <= #TCQ 1'b0;
          rdlvl_last_byte_done_int <= #TCQ 1'b0;
          mpr_rank_done_r      <= #TCQ 1'b0;
          mpr_last_byte_done   <= #TCQ 1'b0;
          cal1_prech_req_r     <= #TCQ 1'b0;
          if (|pi_counter_read_val) begin //VK_REVIEW
            mpr_dec_cpt_r      <= #TCQ 1'b1;
            cal1_state_r       <= #TCQ CAL1_IDEL_DEC_CPT;
            cnt_idel_dec_cpt_r <= #TCQ pi_counter_read_val;
            rdlvl_pi_incdec    <= #TCQ 1'b1;  //every byte dec first so no read needed
          end else if (!cal1_wait_r) begin
            rdlvl_pi_incdec <= #TCQ 1'b0;

            // Store "previous tap" read data. Technically there is no
            // "previous" read data, since we are starting a new DQS
            // group, so we'll never find an edge at tap 0 unless the
            // data is fluctuating/jittering
            store_sr_req_r <= #TCQ 1'b1;
            // If per-bit deskew is disabled, then skip the first
            // portion of stage 1 calibration
            if (PER_BIT_DESKEW == "OFF")
              cal1_state_r <= #TCQ CAL1_STORE_FIRST_WAIT;
            else if (PER_BIT_DESKEW == "ON")
              cal1_state_r <= #TCQ CAL1_PB_STORE_FIRST_WAIT;
          end else
            rdlvl_pi_incdec    <= #TCQ 1'b1;  //every byte dec first so no read needed
        end
        //*****************************************************************
        // Per-bit deskew states
        //*****************************************************************

        // Wait state following storage of initial read data
        CAL1_PB_STORE_FIRST_WAIT:
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_PB_DETECT_EDGE;

        // Look for an edge on all DQ bits in current DQS group
        CAL1_PB_DETECT_EDGE:
          if (detect_edge_done_r) begin
            if (found_stable_eye_r) begin
              // If we've found the left edge for all bits (or more precisely,
              // we've found the left edge, and then part of the stable
              // window thereafter), then proceed to positioning the CPT clock
              // right before the left margin
              cnt_idel_dec_cpt_r <= #TCQ MIN_EYE_SIZE + 1;
              cal1_state_r       <= #TCQ CAL1_PB_DEC_CPT_LEFT;
            end else begin
              // If we've reached the end of the sampling time, and haven't
              // yet found the left margin of all the DQ bits, then:
              if (!tap_limit_cpt_r) begin
                // If we still have taps left to use, then store current value
                // of read data, increment the capture clock, and continue to
                // look for (left) edges
                store_sr_req_r <= #TCQ 1'b1;
                cal1_state_r    <= #TCQ CAL1_PB_INC_CPT;
              end else begin
                // If we ran out of taps moving the capture clock, and we
                // haven't finished edge detection, then reset the capture
                // clock taps to 0 (gradually, one tap at a time...
                // then exit the per-bit portion of the algorithm -
                // i.e. proceed to adjust the capture clock and DQ IODELAYs as
                cnt_idel_dec_cpt_r <= #TCQ 6'd63;
                cal1_state_r       <= #TCQ CAL1_PB_DEC_CPT;
              end
            end
          end

        // Increment delay for DQS
        CAL1_PB_INC_CPT: begin
          cal1_dlyce_cpt_r  <= #TCQ 1'b1;
          cal1_dlyinc_cpt_r <= #TCQ 1'b1;
          cal1_state_r      <= #TCQ CAL1_PB_INC_CPT_WAIT;
        end

        // Wait for IODELAY for both capture and internal nodes within
        // ISERDES to settle, before checking again for an edge
        CAL1_PB_INC_CPT_WAIT: begin
          cal1_dlyce_cpt_r  <= #TCQ 1'b0;
          cal1_dlyinc_cpt_r <= #TCQ 1'b0;
          if (!cal1_wait_r) begin
            cal1_state_r <= #TCQ CAL1_PB_DETECT_EDGE;

          end
        end
        // We've found the left edges of the windows for all DQ bits
        // (actually, we found it MIN_EYE_SIZE taps ago) Decrement capture
        // clock IDELAY to position just outside left edge of data window
        CAL1_PB_DEC_CPT_LEFT:
          if (cnt_idel_dec_cpt_r == 6'b000000)
            cal1_state_r <= #TCQ CAL1_PB_DEC_CPT_LEFT_WAIT;
          else begin
            cal1_dlyce_cpt_r   <= #TCQ 1'b1;
            cal1_dlyinc_cpt_r  <= #TCQ 1'b0;
            cnt_idel_dec_cpt_r <= #TCQ cnt_idel_dec_cpt_r - 1;
          end

        CAL1_PB_DEC_CPT_LEFT_WAIT:
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_PB_DETECT_EDGE_DQ;

        // If there is skew between individual DQ bits, then after we've
        // positioned the CPT clock, we will be "in the window" for some
        // DQ bits ("early" DQ bits), and "out of the window" for others
        // ("late" DQ bits). Increase DQ taps until we are out of the
        // window for all DQ bits
        CAL1_PB_DETECT_EDGE_DQ:
          if (detect_edge_done_r)
            if (found_edge_all_r) begin
              // We're out of the window for all DQ bits in this DQS group
              // We're done with per-bit deskew for this group - now decr
              // capture clock IODELAY tap count back to 0, and proceed
              // with the rest of stage 1 calibration for this DQS group
              cnt_idel_dec_cpt_r <= #TCQ tap_cnt_cpt_r;
              cal1_state_r       <= #TCQ CAL1_PB_DEC_CPT;
            end else
              if (!idel_tap_limit_dq_pb_r)
                // If we still have DQ taps available for deskew, keep
                // incrementing IODELAY tap count for the appropriate DQ bits
                cal1_state_r <= #TCQ CAL1_PB_INC_DQ;
              else begin
                // Otherwise, stop immediately (we've done the best we can)
                // and proceed with rest of stage 1 calibration
                cnt_idel_dec_cpt_r <= #TCQ tap_cnt_cpt_r;
                cal1_state_r <= #TCQ CAL1_PB_DEC_CPT;
              end

        CAL1_PB_INC_DQ: begin
          // Increment only those DQ for which an edge hasn't been found yet
          cal1_dlyce_dq_r  <= #TCQ ~pb_found_edge_last_r;
          cal1_dlyinc_dq_r <= #TCQ 1'b1;
          cal1_state_r     <= #TCQ CAL1_PB_INC_DQ_WAIT;
        end

        CAL1_PB_INC_DQ_WAIT:
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_PB_DETECT_EDGE_DQ;

        // Decrement capture clock taps back to initial value
        CAL1_PB_DEC_CPT:
          if (cnt_idel_dec_cpt_r == 6'b000000)
            cal1_state_r <= #TCQ CAL1_PB_DEC_CPT_WAIT;
          else begin
            cal1_dlyce_cpt_r   <= #TCQ 1'b1;
            cal1_dlyinc_cpt_r  <= #TCQ 1'b0;
            cnt_idel_dec_cpt_r <= #TCQ cnt_idel_dec_cpt_r - 1;
          end

        // Wait for capture clock to settle, then proceed to rest of
        // state 1 calibration for this DQS group
        CAL1_PB_DEC_CPT_WAIT:
          if (!cal1_wait_r) begin
            store_sr_req_r <= #TCQ 1'b1;
            cal1_state_r    <= #TCQ CAL1_STORE_FIRST_WAIT;
          end

        // When first starting calibration for a DQS group, save the
        // current value of the read data shift register, and use this
        // as a reference. Note that for the first iteration of the
        // edge detection loop, we will in effect be checking for an edge
        // at IODELAY taps = 0 - normally, we are comparing the read data
        // for IODELAY taps = N, with the read data for IODELAY taps = N-1
        // An edge can only be found at IODELAY taps = 0 if the read data
        // is changing during this time (possible due to jitter)
        CAL1_STORE_FIRST_WAIT: begin
          mpr_dec_cpt_r  <= #TCQ 1'b0;
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_PAT_DETECT;
        end

        CAL1_VALID_WAIT: begin
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_MPR_PAT_DETECT;
        end

        CAL1_MPR_PAT_DETECT: begin
          rdlvl_pi_incdec <= #TCQ 1'b0;
          // MPR read leveling for centering DQS in valid window before
          // OCLKDELAYED calibration begins in order to eliminate read issues
          if (idel_pat_detect_valid_r == 1'b0) begin
            cal1_state_r  <= #TCQ CAL1_VALID_WAIT;
            idel_pat_detect_valid_r <= #TCQ 1'b1;
          end else if (idel_pat_detect_valid_r && idel_mpr_pat_detect_r) begin
            cal1_state_r  <= #TCQ CAL1_DETECT_EDGE;
            idel_dec_cnt  <= #TCQ 'd0;
          end else if (!idelay_tap_limit_r)
            cal1_state_r  <= #TCQ CAL1_DQ_IDEL_TAP_INC;
          else
            cal1_state_r  <= #TCQ CAL1_RDLVL_ERR;
        end

        CAL1_PAT_DETECT: begin
          // All DQ bits associated with a DQS are pushed to the right one IDELAY
          // tap at a time until first rising DQS is in the tri-state region
          // before first rising edge window.
          // The detect_edge_done_r condition included to support averaging
          // during IDELAY tap increments
          rdlvl_pi_incdec <= #TCQ 1'b0;
          if (detect_edge_done_r) begin
            if (idel_pat_data_match) begin
              case (idelay_adj)
                2'b01: begin
                  cal1_state_r <= CAL1_DQ_IDEL_TAP_INC;
                  idel_dec_cnt <= #TCQ 5'd0;
                  idel_adj_inc <= #TCQ 1'b1;
                end
                2'b10: begin   //DEC by 1
                  cal1_state_r  <= #TCQ  CAL1_DQ_IDEL_TAP_DEC ;
                  idel_dec_cnt  <= #TCQ 5'd1;
                  idel_adj_inc  <= #TCQ 1'b0;
                end
                default: begin
                  cal1_state_r  <= #TCQ CAL1_DETECT_EDGE;
                  idel_dec_cnt  <= #TCQ 5'd0;
                  idel_adj_inc  <= #TCQ 1'b0;
                end
              endcase
            end else if (!idelay_tap_limit_r) begin
              cal1_state_r  <= #TCQ CAL1_DQ_IDEL_TAP_INC;
            end else begin
              cal1_state_r  <= #TCQ CAL1_RDLVL_ERR;
            end
          end
        end

        // Increment IDELAY tap by 1 for DQ bits in the byte being calibrated
        // until left edge of valid window detected
        CAL1_DQ_IDEL_TAP_INC: begin
          cal1_dq_idel_ce         <= #TCQ 1'b1;
          cal1_dq_idel_inc        <= #TCQ 1'b1;
          cal1_state_r            <= #TCQ CAL1_DQ_IDEL_TAP_INC_WAIT;
          idel_pat_detect_valid_r <= #TCQ 1'b0;
        end

        CAL1_DQ_IDEL_TAP_INC_WAIT: begin
          cal1_dq_idel_ce     <= #TCQ 1'b0;
          cal1_dq_idel_inc    <= #TCQ 1'b0;
          if (!cal1_wait_r) begin
            idel_adj_inc        <= #TCQ 1'b0;
            if (idel_adj_inc)
              cal1_state_r <= #TCQ CAL1_DETECT_EDGE;
            else  if (~mpr_rdlvl_done_r & (DRAM_TYPE == "DDR3"))
              cal1_state_r <= #TCQ CAL1_MPR_PAT_DETECT;
            else
              cal1_state_r <= #TCQ CAL1_PAT_DETECT;
          end
        end

        // Decrement by 2 IDELAY taps once idel_pat_data_match detected
        CAL1_DQ_IDEL_TAP_DEC: begin
          cal1_dq_idel_inc    <= #TCQ 1'b0;
          cal1_state_r        <= #TCQ CAL1_DQ_IDEL_TAP_DEC_WAIT;
          if (idel_dec_cnt >= 'd0)
            cal1_dq_idel_ce     <= #TCQ 1'b1;
          else
            cal1_dq_idel_ce     <= #TCQ 1'b0;
          if (idel_dec_cnt > 'd0)
            idel_dec_cnt <= #TCQ idel_dec_cnt - 1;
          else
            idel_dec_cnt <= #TCQ idel_dec_cnt;
        end

        CAL1_DQ_IDEL_TAP_DEC_WAIT: begin
          cal1_dq_idel_ce     <= #TCQ 1'b0;
          cal1_dq_idel_inc    <= #TCQ 1'b0;
          if (!cal1_wait_r) begin
            if ((idel_dec_cnt > 'd0) || (pi_rdval_cnt > 'd0))
              cal1_state_r <= #TCQ CAL1_DQ_IDEL_TAP_DEC;
            else if (mpr_dec_cpt_r)
              cal1_state_r <= #TCQ CAL1_STORE_FIRST_WAIT;
            else
              cal1_state_r <= #TCQ CAL1_DETECT_EDGE;
          end
        end

        // Check for presence of data eye edge. During this state, we
        // sample the read data multiple times, and look for changes
        // in the read data, specifically:
        //   1. A change in the read data compared with the value of
        //      read data from the previous delay tap. This indicates
        //      that the most recent tap delay increment has moved us
        //      into either a new window, or moved/kept us in the
        //      transition/jitter region between windows. Note that this
        //      condition only needs to be checked for once, and for
        //      logistical purposes, we check this soon after entering
        //      this state (see comment in CAL1_DETECT_EDGE below for
        //      why this is done)
        //   2. A change in the read data while we are in this state
        //      (i.e. in the absence of a tap delay increment). This
        //      indicates that we're close enough to a window edge that
        //      jitter will cause the read data to change even in the
        //      absence of a tap delay change
        CAL1_DETECT_EDGE: begin
          // Essentially wait for the first comparision to finish, then
          // store current data into "old" data register. This store
          // happens now, rather than later (e.g. when we've have already
          // left this state) in order to avoid the situation the data that
          // is stored as "old" data has not been used in an "active
          // comparison" - i.e. data is stored after the last comparison
          // of this state. In this case, we can miss an edge if the
          // following sequence occurs:
          //   1. Comparison completes in this state - no edge found
          //   2. "Momentary jitter" occurs which "pushes" the data out the
          //      equivalent of one delay tap
          //   3. We store this jittered data as the "old" data
          //   4. "Jitter" no longer present
          //   5. We increment the delay tap by one
          //   6. Now we compare the current with the "old" data - they're
          //      the same, and no edge is detected
          // NOTE: Given the large # of comparisons done in this state, it's
          //  highly unlikely the above sequence will occur in actual H/W

          // Wait for the first load of read data into the comparison
          // shift register to finish, then load the current read data
          // into the "old" data register. This allows us to do one
          // initial comparision between the current read data, and
          // stored data corresponding to the previous delay tap
          idel_pat_detect_valid_r <= #TCQ 1'b0;
          if (!store_sr_req_pulsed_r) begin
            // Pulse store_sr_req_r only once in this state
            store_sr_req_r        <= #TCQ 1'b1;
            store_sr_req_pulsed_r <= #TCQ 1'b1;
          end else begin
            store_sr_req_r        <= #TCQ 1'b0;
            store_sr_req_pulsed_r <= #TCQ 1'b1;
          end

          // Continue to sample read data and look for edges until the
          // appropriate time interval (shorter for simulation-only,
          // much, much longer for actual h/w) has elapsed
          if (detect_edge_done_r) begin
            if (tap_limit_cpt_r)
              // Only one edge detected and ran out of taps since only one
              // bit time worth of taps available for window detection. This
              // can happen if at tap 0 DQS is in previous window which results
              // in only left edge being detected. Or at tap 0 DQS is in the
              // current window resulting in only right edge being detected.
              // Depending on the frequency this case can also happen if at
              // tap 0 DQS is in the left noise region resulting in only left
              // edge being detected.
              cal1_state_r <= #TCQ CAL1_CALC_IDEL;
            else if (found_edge_r) begin
              // Sticky bit - asserted after we encounter an edge, although
              // the current edge may not be considered the "first edge" this
              // just means we found at least one edge
              found_first_edge_r <= #TCQ 1'b1;

              // Only the right edge of the data valid window is found
              // Record the inner right edge tap value
              if (!found_first_edge_r && found_stable_eye_last_r) begin
                if (tap_cnt_cpt_r == 'd0)
                  right_edge_taps_r <= #TCQ 'd0;
                else
                  right_edge_taps_r <= #TCQ tap_cnt_cpt_r;
              end

              // Both edges of data valid window found:
              // If we've found a second edge after a region of stability
              // then we must have just passed the second ("right" edge of
              // the window. Record this second_edge_taps = current tap-1,
              // because we're one past the actual second edge tap, where
              // the edge taps represent the extremes of the data valid
              // window (i.e. smallest & largest taps where data still valid
              if (found_first_edge_r && found_stable_eye_last_r) begin
                found_second_edge_r <= #TCQ 1'b1;
                second_edge_taps_r <= #TCQ tap_cnt_cpt_r - 1;
                cal1_state_r <= #TCQ CAL1_CALC_IDEL;
              end else begin
                // Otherwise, an edge was found (just not the "second" edge)
                // Assuming DQS is in the correct window at tap 0 of Phaser IN
                // fine tap. The first edge found is the right edge of the valid
                // window and is the beginning of the jitter region hence done!
                first_edge_taps_r <= #TCQ tap_cnt_cpt_r;
                //wait for read stop before PI increament
                cal1_state_r <= #TCQ CAL1_RD_STOP_FOR_PI_INC;
              end
            end else
              // Otherwise, if we haven't found an edge....
              // If we still have taps left to use, then keep incrementing
              //wait for read stop before PI increament
              cal1_state_r <= #TCQ CAL1_RD_STOP_FOR_PI_INC;
          end
        end

        //before increment PI, read command sending should be stopped.
        //Also need to wait existing read is finished
        CAL1_RD_STOP_FOR_PI_INC: begin
          rdlvl_pi_incdec    <= #TCQ 1'b1;
          if (!cal1_wait_r)
            cal1_state_r    <= #TCQ CAL1_IDEL_INC_CPT;
        end

        // Increment Phaser_IN delay for DQS
        CAL1_IDEL_INC_CPT: begin
          cal1_state_r        <= #TCQ CAL1_IDEL_INC_CPT_WAIT;
          if (~tap_limit_cpt_r) begin
            cal1_dlyce_cpt_r    <= #TCQ 1'b1;
            cal1_dlyinc_cpt_r   <= #TCQ 1'b1;
          end else begin
            cal1_dlyce_cpt_r    <= #TCQ 1'b0;
            cal1_dlyinc_cpt_r   <= #TCQ 1'b0;
          end
        end

        // Wait for Phaser_In to settle, before checking again for an edge
        CAL1_IDEL_INC_CPT_WAIT: begin
          cal1_dlyce_cpt_r    <= #TCQ 1'b0;
          cal1_dlyinc_cpt_r   <= #TCQ 1'b0;
          if (!cal1_wait_r) begin
            cal1_state_r <= #TCQ CAL1_DETECT_EDGE;
            rdlvl_pi_incdec <= #TCQ 1'b0;    //return to normal read
          end
        end

        // Calculate final value of Phaser_IN taps. At this point, one or both
        // edges of data eye have been found, and/or all taps have been
        // exhausted looking for the edges
        // NOTE: We're calculating the amount to decrement by, not the
        //  absolute setting for DQS.
        CAL1_CALC_IDEL: begin
         // CASE1: If 2 edges found.
          if (found_second_edge_r)
            cnt_idel_dec_cpt_r
              <=  #TCQ ((second_edge_taps_r -
                         first_edge_taps_r)>>1) + 1;
          else if (right_edge_taps_r > 6'd0)
            // Only right edge detected
            // right_edge_taps_r is the inner right edge tap value
            // hence used for calculation
            cnt_idel_dec_cpt_r
              <=  #TCQ (tap_cnt_cpt_r - (right_edge_taps_r>>1));
          else if (found_first_edge_r)
            // Only left edge detected
            cnt_idel_dec_cpt_r
              <=  #TCQ ((tap_cnt_cpt_r - first_edge_taps_r)>>1);
          else
            cnt_idel_dec_cpt_r
              <=  #TCQ (tap_cnt_cpt_r>>1);
          // Now use the value we just calculated to decrement CPT taps
          // to the desired calibration point
          //cal1_state_r <= #TCQ CAL1_IDEL_DEC_CPT;
          cal1_state_r <= #TCQ CAL1_CENTER_WAIT;
          rdlvl_pi_incdec <= #TCQ 1'b1;
        end

        CAL1_CENTER_WAIT: begin
          if(!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_IDEL_DEC_CPT;
        end
        // decrement capture clock for final adjustment - center
        // capture clock in middle of data eye. This adjustment will occur
        // only when both the edges are found usign CPT taps. Must do this
        // incrementally to avoid clock glitching (since CPT drives clock
        // divider within each ISERDES)
        CAL1_IDEL_DEC_CPT: begin
          cal1_dlyce_cpt_r  <= #TCQ 1'b1;
          cal1_dlyinc_cpt_r <= #TCQ 1'b0;
          // once adjustment is complete, we're done with calibration for
          // this DQS, repeat for next DQS
          cnt_idel_dec_cpt_r <= #TCQ cnt_idel_dec_cpt_r - 1;
          if (cnt_idel_dec_cpt_r == 6'b000001) begin
            if (mpr_dec_cpt_r) begin
              if (|idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing]) begin
                idel_dec_cnt  <= #TCQ idelay_tap_cnt_r[rnk_cnt_r][cal1_cnt_cpt_timing];
                cal1_state_r  <= #TCQ CAL1_DQ_IDEL_TAP_DEC;
              end else
                cal1_state_r  <= #TCQ CAL1_STORE_FIRST_WAIT;
            end else
              cal1_state_r <= #TCQ CAL1_NEXT_DQS;
          end else
            cal1_state_r <= #TCQ CAL1_IDEL_DEC_CPT_WAIT;
        end

        CAL1_IDEL_DEC_CPT_WAIT: begin
          cal1_dlyce_cpt_r  <= #TCQ 1'b0;
          cal1_dlyinc_cpt_r <= #TCQ 1'b0;
          if (!cal1_wait_r)
            cal1_state_r <= #TCQ CAL1_IDEL_DEC_CPT;
        end

        // Determine whether we're done, or have more DQS's to calibrate
        // Also request precharge after every byte, as appropriate
        CAL1_NEXT_DQS: begin
          //if (mpr_rdlvl_done_r || (DRAM_TYPE == "DDR2"))
            cal1_prech_req_r  <= #TCQ 1'b1;
          //else
          //  cal1_prech_req_r  <= #TCQ 1'b0;
          cal1_dlyce_cpt_r  <= #TCQ 1'b0;
          cal1_dlyinc_cpt_r <= #TCQ 1'b0;
          // Prepare for another iteration with next DQS group
          found_first_edge_r  <= #TCQ 1'b0;
          found_second_edge_r <= #TCQ 1'b0;
          first_edge_taps_r <= #TCQ 'd0;
          second_edge_taps_r <= #TCQ 'd0;
          right_edge_taps_r    <= #TCQ 'd0;
          if ((SIM_CAL_OPTION == "FAST_CAL") ||
              (cal1_cnt_cpt_r >= DQS_WIDTH-1)) begin
            if (mpr_rdlvl_done_r) begin
              rdlvl_last_byte_done_int <= #TCQ 1'b1;
              mpr_last_byte_done   <= #TCQ 1'b0;
            end else begin
              rdlvl_last_byte_done_int <= #TCQ 1'b0;
              mpr_last_byte_done   <= #TCQ 1'b1;
            end
          end

          // Wait until precharge that occurs in between calibration of
          // DQS groups is finished
          if (prech_done) begin // || (~mpr_rdlvl_done_r & (DRAM_TYPE == "DDR3"))) begin
            if (SIM_CAL_OPTION == "FAST_CAL") begin
              //rdlvl_rank_done_r <= #TCQ 1'b1;
              rdlvl_last_byte_done_int <= #TCQ 1'b0;
              mpr_last_byte_done   <= #TCQ 1'b0;
              cal1_state_r <= #TCQ CAL1_DONE; //CAL1_REGL_LOAD;
            end else if (cal1_cnt_cpt_r >= DQS_WIDTH-1) begin
              if (~mpr_rdlvl_done_r) begin
                mpr_rank_done_r <= #TCQ 1'b1;
                // if (rnk_cnt_r == RANKS-1) begin
                  // All DQS groups in all ranks done
                cal1_state_r <= #TCQ CAL1_DONE;
                cal1_cnt_cpt_r <= #TCQ 'b0;
                // end else begin
                  // // Process DQS groups in next rank
                  // rnk_cnt_r      <= #TCQ rnk_cnt_r + 1;
                  // new_cnt_cpt_r  <= #TCQ 1'b1;
                  // cal1_cnt_cpt_r <= #TCQ 'b0;
                  // cal1_state_r   <= #TCQ CAL1_IDLE;
                // end
              end else begin
                // All DQS groups in a rank done
                rdlvl_rank_done_r <= #TCQ 1'b1;
                if (rnk_cnt_r == RANKS-1) begin
                  // All DQS groups in all ranks done
                  cal1_state_r <= #TCQ CAL1_REGL_LOAD;
                end else begin
                  // Process DQS groups in next rank
                  rnk_cnt_r      <= #TCQ rnk_cnt_r + 1;
                  new_cnt_cpt_r  <= #TCQ 1'b1;
                  cal1_cnt_cpt_r <= #TCQ 'b0;
                  cal1_state_r   <= #TCQ CAL1_IDLE;
                end
              end
            end else begin
              // Process next DQS group
              new_cnt_cpt_r  <= #TCQ 1'b1;
              cal1_cnt_cpt_r <= #TCQ cal1_cnt_cpt_r + 1;
              cal1_state_r   <= #TCQ CAL1_NEW_DQS_PREWAIT;
            end
          end
        end

        CAL1_NEW_DQS_PREWAIT: begin
          if (!cal1_wait_r) begin
            rdlvl_pi_incdec <= #TCQ 1'b0;
            if (~mpr_rdlvl_done_r & (DRAM_TYPE == "DDR3"))
                cal1_state_r  <= #TCQ CAL1_MPR_NEW_DQS_WAIT;
            else
              cal1_state_r   <= #TCQ CAL1_NEW_DQS_WAIT;
          end
        end

        // Load rank registers in Phaser_IN
        CAL1_REGL_LOAD: begin
          rdlvl_rank_done_r <= #TCQ 1'b0;
          mpr_rank_done_r   <= #TCQ 1'b0;
          cal1_prech_req_r  <= #TCQ 1'b0;
          cal1_cnt_cpt_r    <= #TCQ 'b0;
          rnk_cnt_r         <= #TCQ 2'b00;
          if ((regl_rank_cnt == RANKS-1) &&
              ((regl_dqs_cnt == DQS_WIDTH-1) && (done_cnt == 4'd1))) begin
            cal1_state_r <= #TCQ CAL1_DONE;
            rdlvl_last_byte_done_int <= #TCQ 1'b0;
            mpr_last_byte_done   <= #TCQ 1'b0;
          end else
            cal1_state_r <= #TCQ CAL1_REGL_LOAD;
        end

        CAL1_RDLVL_ERR: begin
          rdlvl_stg1_err <= #TCQ 1'b1;
        end

        // Done with this stage of calibration
        // if used, allow DEBUG_PORT to control taps
        CAL1_DONE: begin
          mpr_rdlvl_done_r  <= #TCQ 1'b1;
          cal1_prech_req_r  <= #TCQ 1'b0;
          if (~mpr_rdlvl_done_r && (OCAL_EN=="ON") && (DRAM_TYPE == "DDR3")) begin
            rdlvl_stg1_done_int   <= #TCQ 1'b0;
            cal1_state_r <= #TCQ CAL1_IDLE;
          end else
            rdlvl_stg1_done_int   <= #TCQ 1'b1;
        end

      endcase
    end
// verilint STARC-2.2.3.3 on




endmodule

