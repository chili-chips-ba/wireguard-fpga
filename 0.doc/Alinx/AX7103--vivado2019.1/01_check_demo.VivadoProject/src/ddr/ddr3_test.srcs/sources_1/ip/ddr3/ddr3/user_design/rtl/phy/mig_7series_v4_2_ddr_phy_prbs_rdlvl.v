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
//  /   /         Filename: ddr_phy_prbs_rdlvl.v
// /___/   /\     Date Last Modified: $Date: 2011/06/24 14:49:00 $
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  PRBS Read leveling calibration logic
//  NOTES:
//    1. Window detection with PRBS pattern.
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_prbs_rdlvl.v,v 1.2 2011/06/24 14:49:00 mgeorge Exp $
**$Date: 2011/06/24 14:49:00 $
**$Author: mgeorge $
**$Revision: 1.2 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_phy_prbs_rdlvl.v,v $
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_prbs_rdlvl #
  (
   parameter TCQ             = 100,    // clk->out delay (sim only)
   parameter nCK_PER_CLK     = 2,      // # of memory clocks per CLK
   parameter DQ_WIDTH        = 64,     // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,      // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,      // # of DQS (strobe)
   parameter DRAM_WIDTH      = 8,      // # of DQ per DQS
   parameter RANKS           = 1,      // # of DRAM ranks
   parameter SIM_CAL_OPTION  = "NONE", // Skip various calibration steps
   parameter PRBS_WIDTH      = 8,      // PRBS generator output width
   parameter FIXED_VICTIM    = "TRUE",  // No victim rotation when "TRUE"
   parameter FINE_PER_BIT    = "ON",
   parameter CENTER_COMP_MODE = "ON",
   parameter PI_VAL_ADJ       = "ON"
   )
  (
   input                        clk,
   input                        rst,
   // Calibration status, control signals
   input                        prbs_rdlvl_start,
   (* max_fanout = 100 *) output reg                   prbs_rdlvl_done,
   output reg                   prbs_last_byte_done,
   output reg                   prbs_rdlvl_prech_req,
   input                        complex_sample_cnt_inc,
   input                        prech_done,
   input                        phy_if_empty,
   // Captured data in fabric clock domain
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] rd_data,
   //Expected data from PRBS generator
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] compare_data,
   // Decrement initial Phaser_IN Fine tap delay
   input [5:0]                  pi_counter_read_val,
   // Stage 1 calibration outputs
   output reg                   pi_en_stg2_f,
   output reg                   pi_stg2_f_incdec,
   output [255:0]               dbg_prbs_rdlvl,
   output [DQS_CNT_WIDTH:0]     pi_stg2_prbs_rdlvl_cnt,   
   output reg [2:0]             rd_victim_sel,
   output reg                   complex_victim_inc,
   output reg                   reset_rd_addr,
   
   output reg [6*DQS_WIDTH*RANKS-1:0] prbs_final_dqs_tap_cnt_r,
   output reg [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_first_edge_taps,
   output reg [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_second_edge_taps,
   output reg [DRAM_WIDTH-1:0]        fine_delay_incdec_pb,  //fine_delay decreament per bit
   output reg                         fine_delay_sel,        //fine delay selection - actual update of fine delay
   output reg                         num_samples_done_r,
   input                              complex_act_start,     //read is done. ready for PI movement
   output                             complex_init_pi_dec_done,  //Initial PI incdec is done. ready for start
   output reg                         complex_pi_incdec_done    //PI incdec is done. ready for Read
   );



  
  localparam [5:0] PRBS_IDLE                 = 6'h00;
  localparam [5:0] PRBS_NEW_DQS_WAIT         = 6'h01;
  localparam [5:0] PRBS_PAT_COMPARE          = 6'h02;
  localparam [5:0] PRBS_DEC_DQS              = 6'h03;
  localparam [5:0] PRBS_DEC_DQS_WAIT         = 6'h04;
  localparam [5:0] PRBS_INC_DQS              = 6'h05;
  localparam [5:0] PRBS_INC_DQS_WAIT         = 6'h06;
  localparam [5:0] PRBS_CALC_TAPS            = 6'h07;
  localparam [5:0] PRBS_NEXT_DQS             = 6'h08;
  localparam [5:0] PRBS_NEW_DQS_PREWAIT      = 6'h09;
  localparam [5:0] PRBS_DONE                 = 6'h0A;
  localparam [5:0] PRBS_CALC_TAPS_PRE        = 6'h0B;
  localparam [5:0] PRBS_CALC_TAPS_WAIT       = 6'h0C;

  localparam [5:0] FINE_PI_DEC               = 6'h0D;  //go back to all fail or back to center
  localparam [5:0] FINE_PI_DEC_WAIT          = 6'h0E;  //wait for PI tap dec settle
  localparam [5:0] FINE_PI_INC               = 6'h0F;  //increse up to 1 fail 
  localparam [5:0] FINE_PI_INC_WAIT          = 6'h10;  //wait for PI tap int settle
  localparam [5:0] FINE_PAT_COMPARE_PER_BIT  = 6'h11;  //compare per bit error and check left/right/gain/loss
  localparam [5:0] FINE_CALC_TAPS            = 6'h12;  //setup fine_delay_incdec_pb for better window size
  localparam [5:0] FINE_CALC_TAPS_WAIT       = 6'h13;  //wait for ROM value for dec cnt
  localparam [5:0] RD_DONE_WAIT_FOR_PI_INC_INC   = 6'h14;  //wait for read is done before PI inc
  localparam [5:0] RD_DONE_WAIT_FOR_PI_INC_DEC   = 6'h15;  //wait for read is done before PI dec

  localparam [11:0] NUM_SAMPLES_CNT  = (SIM_CAL_OPTION == "NONE") ? 'd12 : 12'h001; //MG from 50  
  localparam [11:0] NUM_SAMPLES_CNT1 = (SIM_CAL_OPTION == "NONE") ? 'd20 : 12'h001;  
  localparam [11:0] NUM_SAMPLES_CNT2 = (SIM_CAL_OPTION == "NONE") ? 'd10 : 12'h001;   

  //minimum valid window for centering
  localparam MIN_WIN = 8;
  localparam [MIN_WIN-1:0] MATCH_ALL_ONE = {MIN_WIN{1'b1}};
  localparam [MIN_WIN-1:0] MIN_PASS = {MIN_WIN{1'b0}};             //8'b00000000
  localparam [MIN_WIN-1:0] MIN_LEFT = {1'b1,{{MIN_WIN-1}{1'b0}}};  //8'b10000000

  wire [DQS_CNT_WIDTH+2:0]prbs_dqs_cnt_timing;
  reg [DQS_CNT_WIDTH+2:0] prbs_dqs_cnt_timing_r;
  reg [DQS_CNT_WIDTH:0]   prbs_dqs_cnt_r;
  reg                     prbs_prech_req_r;
  reg [5:0]               prbs_state_r;
  reg [5:0]               prbs_state_r1;
  reg                     wait_state_cnt_en_r;
  reg [3:0]               wait_state_cnt_r;
  reg                     cnt_wait_state;
  reg                     err_chk_invalid;
 // reg                     found_edge_r;
  reg                     prbs_found_1st_edge_r;
  reg                     prbs_found_2nd_edge_r;
  reg [5:0]               prbs_1st_edge_taps_r;
 // reg                     found_stable_eye_r;
  reg [5:0]               prbs_dqs_tap_cnt_r;
  reg [5:0]               prbs_dec_tap_calc_plus_3;
  reg [5:0]               prbs_dec_tap_calc_minus_3;
  reg                     prbs_dqs_tap_limit_r;
  reg [5:0]               prbs_inc_tap_cnt;
  reg [5:0]               prbs_dec_tap_cnt;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r1;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r2;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r3;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall0_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall1_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise0_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise1_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall2_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_fall3_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise2_r4;
  reg [DRAM_WIDTH-1:0]    mux_rd_rise3_r4;
  reg                     mux_rd_valid_r;
  reg                     rd_valid_r1;
  reg                     rd_valid_r2;
  reg                     rd_valid_r3;
  reg                     new_cnt_dqs_r;
  reg                     prbs_tap_en_r;
  reg                     prbs_tap_inc_r;
  reg                     pi_en_stg2_f_timing;
  reg                     pi_stg2_f_incdec_timing;
  wire [DQ_WIDTH-1:0]     rd_data_rise0;
  wire [DQ_WIDTH-1:0]     rd_data_fall0;
  wire [DQ_WIDTH-1:0]     rd_data_rise1;
  wire [DQ_WIDTH-1:0]     rd_data_fall1;
  wire [DQ_WIDTH-1:0]     rd_data_rise2;
  wire [DQ_WIDTH-1:0]     rd_data_fall2;
  wire [DQ_WIDTH-1:0]     rd_data_rise3;
  wire [DQ_WIDTH-1:0]     rd_data_fall3;
  wire [DQ_WIDTH-1:0]     compare_data_r0;
  wire [DQ_WIDTH-1:0]     compare_data_f0;
  wire [DQ_WIDTH-1:0]     compare_data_r1;
  wire [DQ_WIDTH-1:0]     compare_data_f1;
  wire [DQ_WIDTH-1:0]     compare_data_r2;
  wire [DQ_WIDTH-1:0]     compare_data_f2;
  wire [DQ_WIDTH-1:0]     compare_data_r3;
  wire [DQ_WIDTH-1:0]     compare_data_f3;
  reg [DRAM_WIDTH-1:0]    compare_data_rise0_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_fall0_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_rise1_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_fall1_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_rise2_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_fall2_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_rise3_r1;
  reg [DRAM_WIDTH-1:0]    compare_data_fall3_r1;
  reg [DQS_CNT_WIDTH:0]   rd_mux_sel_r;
  reg [5:0]               prbs_2nd_edge_taps_r;
  
 // reg [6*DQS_WIDTH*RANKS-1:0] prbs_final_dqs_tap_cnt_r;
  reg [5:0]               rdlvl_cpt_tap_cnt;
  reg                     prbs_rdlvl_start_r;
  
  reg                     compare_err;
  reg                     compare_err_r0;
  reg                     compare_err_f0;
  reg                     compare_err_r1;
  reg                     compare_err_f1;
  reg                     compare_err_r2;
  reg                     compare_err_f2;
  reg                     compare_err_r3;
  reg                     compare_err_f3;
  reg                     compare_err_latch;
  
  reg                     samples_cnt1_en_r;
  reg                     samples_cnt2_en_r;
  reg [11:0]              samples_cnt_r;
  reg                     num_samples_done_ind;  //indicate num_samples_done_r is set in FINE_PAT_COMPARE_PER_BIT to prevent victim_sel_rd out of sync
  reg [DQS_WIDTH-1:0]     prbs_tap_mod;
   
  //reg [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_first_edge_taps;
  //reg [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_second_edge_taps;
  
   //**************************************************************************
   // signals for per-bit algorithm of fine_delay calculations
   //**************************************************************************
  reg [6*DRAM_WIDTH-1:0] left_edge_pb;           //left edge value per bit
  reg [6*DRAM_WIDTH-1:0] right_edge_pb;          //right edge value per bit
  reg [MIN_WIN*DRAM_WIDTH-1:0] match_flag_pb;    //5 consecutive match flag per bit
  reg [MIN_WIN-1:0]            match_flag_and;   //5 consecute match flag of all bits (1: all bit fail)
  reg [MIN_WIN-1:0]            match_flag_or;    //5 consecute match flag of all bits (1: any  bit fail)
  reg [DRAM_WIDTH-1:0]   left_edge_found_pb;     //left_edge found per bit - use for loss calculation 
  reg [DRAM_WIDTH-1:0]   left_edge_updated;      //left edge was updated for this PI tap - used for largest left edge /ref bit update
  reg [DRAM_WIDTH-1:0]   right_edge_found_pb;    //right_edge found per bit - use for gail calulation and smallest right edge update 
  reg                    right_edge_found;       //smallest right_edge found   
  reg [DRAM_WIDTH*6-1:0] left_loss_pb;           //left_edge loss per bit
  reg [DRAM_WIDTH*6-1:0] right_gain_pb;          //right_edge gain per bit
  reg [DRAM_WIDTH-1:0]   ref_bit;                //bit number which has largest left edge (with smaller right edge)
  reg [DRAM_WIDTH-1:0]   bit_cnt;                //bit number used to calculate ref bit
  reg [DRAM_WIDTH-1:0]   ref_bit_per_bit;        //bit flags which have largest left edge
  reg [5:0]              ref_right_edge;         //ref_bit right edge - keep the smallest edge of ref bits
  reg [5:0]              largest_left_edge;      //biggest left edge of per bit - will be left edge of byte
  reg [5:0]              smallest_right_edge;    //smallest right edge of per bit - will be right edge of byte
  reg [5:0]              fine_pi_dec_cnt;        //Phase In tap decrement count (to go back to '0' or center)
  reg [6:0]              center_calc;            //used for calculate the dec tap for centering
  reg [5:0]              right_edge_ref;         //ref_bit right edge
  reg [5:0]              left_edge_ref;          //ref_bit left edge

  reg [DRAM_WIDTH-1:0]   compare_err_pb;         //compare error per bit
  reg [DRAM_WIDTH-1:0]   compare_err_pb_latch_r; //sticky compare error per bit used for left/right edge
  reg                    compare_err_pb_and;     //indicate all bit fail
  reg                    compare_err_pb_or;      //indicate any bit fail
  reg                    fine_inc_stage;         //fine_inc_stage (1: increment all except ref_bit, 0: only inc for gain bit)
  reg [1:0]              stage_cnt;              //stage cnt (0,1: fine delay inc stage, 2: fine delay dec stage)
  wire                   fine_calib;             //turn on/off fine delay calibration

  reg [5:0]              mem_out_dec;
  reg [5:0]              dec_cnt;
  reg                    fine_dly_error;        //indicate it has wrong left/right edge 
  reg                    edge_det_error;        //indicate it has wrong left/right edge 

  wire                   center_comp;
  wire                   pi_adj;

  reg                    no_err_win_detected;
  reg                    no_err_win_detected_latch;
  reg [1:0]              valid_window_cnt;     //number of valid window in the scan
  reg                    double_window_ind;    //indication of double window 

  //if inital PI dec is not done, init SM should wait until it is done
  reg                    complex_init_pi_dec_done_r;  //if inital PI dec is not done, init SM should wait until it is done
  wire                   complex_rdlvl_err;

   //**************************************************************************
   // DQS count to hard PHY during write calibration using Phaser_OUT Stage2
   // coarse delay 
   //**************************************************************************
   assign pi_stg2_prbs_rdlvl_cnt = prbs_dqs_cnt_r; 

   //fine delay turn on
   assign fine_calib    = (FINE_PER_BIT=="ON")? 1:0;
   assign center_comp   = (CENTER_COMP_MODE == "ON")? 1: 0;
   assign pi_adj        = (PI_VAL_ADJ == "ON")?1:0;
   
   //Debug error flag
   assign complex_rdlvl_err = fine_dly_error | edge_det_error;

   //initial dec is only happening for per-bit 
   assign complex_init_pi_dec_done = fine_calib? complex_init_pi_dec_done_r : 1'b1;

   assign dbg_prbs_rdlvl[0+:6]  = left_edge_pb[0+:6];
   assign dbg_prbs_rdlvl[7:6]  = left_loss_pb[0+:2];
   assign dbg_prbs_rdlvl[8+:6]  = left_edge_pb[6+:6];  
   assign dbg_prbs_rdlvl[15:14]  = left_loss_pb[6+:2];
   assign dbg_prbs_rdlvl[16+:6] = left_edge_pb[12+:6] ;
   assign dbg_prbs_rdlvl[23:22]  = left_loss_pb[12+:2];
   assign dbg_prbs_rdlvl[24+:6] = left_edge_pb[18+:6] ;
   assign dbg_prbs_rdlvl[31:30]  = left_loss_pb[18+:2];
   assign dbg_prbs_rdlvl[32+:6] = left_edge_pb[24+:6];
   assign dbg_prbs_rdlvl[39:38]  = left_loss_pb[24+:2];
   assign dbg_prbs_rdlvl[40+:6] = left_edge_pb[30+:6];
   assign dbg_prbs_rdlvl[47:46]  = left_loss_pb[30+:2];
   assign dbg_prbs_rdlvl[48+:6] = left_edge_pb[36+:6];
   assign dbg_prbs_rdlvl[55:54]  = left_loss_pb[36+:2];
   assign dbg_prbs_rdlvl[56+:6] = left_edge_pb[42+:6];
   assign dbg_prbs_rdlvl[63:62]  = left_loss_pb[42+:2];

   assign dbg_prbs_rdlvl[64+:6]  = right_edge_pb[0+:6];
   assign dbg_prbs_rdlvl[71:70]  = right_gain_pb[0+:2];
   assign dbg_prbs_rdlvl[72+:6]  = right_edge_pb[6+:6] ;
   assign dbg_prbs_rdlvl[79:78]  = right_gain_pb[6+:2];
   assign dbg_prbs_rdlvl[80+:6]  = right_edge_pb[12+:6];
   assign dbg_prbs_rdlvl[87:86]  = right_gain_pb[12+:2];
   assign dbg_prbs_rdlvl[88+:6]  = right_edge_pb[18+:6];
   assign dbg_prbs_rdlvl[95:94]  = right_gain_pb[18+:2];
   assign dbg_prbs_rdlvl[96+:6]  = right_edge_pb[24+:6];
   assign dbg_prbs_rdlvl[103:102]  = right_gain_pb[24+:2];
   assign dbg_prbs_rdlvl[104+:6] = right_edge_pb[30+:6];
   assign dbg_prbs_rdlvl[111:110]  = right_gain_pb[30+:2];
   assign dbg_prbs_rdlvl[112+:6] = right_edge_pb[36+:6];
   assign dbg_prbs_rdlvl[119:118]  = right_gain_pb[36+:2];
   assign dbg_prbs_rdlvl[120+:6] = right_edge_pb[42+:6]; 
   assign dbg_prbs_rdlvl[127:126]  = right_gain_pb[42+:2];
 
   assign dbg_prbs_rdlvl[128+:6] = pi_counter_read_val;
   assign dbg_prbs_rdlvl[134+:6] = prbs_dqs_tap_cnt_r;

   assign dbg_prbs_rdlvl[140]    = prbs_found_1st_edge_r;
   assign dbg_prbs_rdlvl[141]    = prbs_found_2nd_edge_r;
   assign dbg_prbs_rdlvl[142]    = compare_err;
   assign dbg_prbs_rdlvl[143]    = phy_if_empty;
   assign dbg_prbs_rdlvl[144]    = prbs_rdlvl_start;
   assign dbg_prbs_rdlvl[145]    = prbs_rdlvl_done;
   assign dbg_prbs_rdlvl[146+:5] = prbs_dqs_cnt_r;
   assign dbg_prbs_rdlvl[151+:6] = left_edge_pb[prbs_dqs_cnt_r*6+:6] ;
   assign dbg_prbs_rdlvl[157+:6] = right_edge_pb[prbs_dqs_cnt_r*6+:6];
   assign dbg_prbs_rdlvl[163+:6] = {2'h0,complex_victim_inc, rd_victim_sel[2:0]};
   assign dbg_prbs_rdlvl[169+:6] =right_gain_pb[prbs_dqs_cnt_r*6+:6] ;
   assign dbg_prbs_rdlvl[177:175] = ref_bit[2:0];

   assign dbg_prbs_rdlvl[178+:6] = prbs_state_r1[5:0];
   assign dbg_prbs_rdlvl[184] = rd_valid_r2;
   assign dbg_prbs_rdlvl[185] = compare_err_r0;
   assign dbg_prbs_rdlvl[186] = compare_err_f0;
   assign dbg_prbs_rdlvl[187] = compare_err_r1;
   assign dbg_prbs_rdlvl[188] = compare_err_f1;
   assign dbg_prbs_rdlvl[189] = compare_err_r2;
   assign dbg_prbs_rdlvl[190] = compare_err_f2;
   assign dbg_prbs_rdlvl[191] = compare_err_r3;
   assign dbg_prbs_rdlvl[192] = compare_err_f3;
   assign dbg_prbs_rdlvl[193+:8] = left_edge_found_pb;
   assign dbg_prbs_rdlvl[201+:8] = right_edge_found_pb;
   assign dbg_prbs_rdlvl[209+:6] =largest_left_edge ;
   assign dbg_prbs_rdlvl[215+:6] =smallest_right_edge ;
   assign dbg_prbs_rdlvl[221+:8] = fine_delay_incdec_pb;
   assign dbg_prbs_rdlvl[229] = fine_delay_sel;
   assign dbg_prbs_rdlvl[230+:8] = compare_err_pb_latch_r;
   assign dbg_prbs_rdlvl[238+:6] = fine_pi_dec_cnt;
   assign dbg_prbs_rdlvl[244+:5] = match_flag_and[4:0]; 
   assign dbg_prbs_rdlvl[249+:2] = stage_cnt;
   assign dbg_prbs_rdlvl[251] =  fine_inc_stage;
   assign dbg_prbs_rdlvl[252] =  compare_err_pb_and;
   assign dbg_prbs_rdlvl[253] =  right_edge_found;
   assign dbg_prbs_rdlvl[254] =  complex_rdlvl_err;
   assign dbg_prbs_rdlvl[255] = double_window_ind;
   
  //**************************************************************************   
  // Record first and second edges found during calibration
  //**************************************************************************
  generate
    always @(posedge clk)
      if (rst) begin
        dbg_prbs_first_edge_taps  <= #TCQ 'b0;
        dbg_prbs_second_edge_taps <= #TCQ 'b0;
      end else if (prbs_state_r == PRBS_CALC_TAPS) begin
        // Record tap counts of first and second edge edges during
        // calibration for each DQS group. If neither edge has
        // been found, then those taps will remain 0
          if (prbs_found_1st_edge_r)
            dbg_prbs_first_edge_taps[(prbs_dqs_cnt_timing_r*6)+:6]  
              <= #TCQ prbs_1st_edge_taps_r;
          if (prbs_found_2nd_edge_r)
            dbg_prbs_second_edge_taps[(prbs_dqs_cnt_timing_r*6)+:6] 
              <= #TCQ prbs_2nd_edge_taps_r;
      end else if (prbs_state_r == FINE_CALC_TAPS) begin
        if(stage_cnt == 'd2) begin
            dbg_prbs_first_edge_taps[(prbs_dqs_cnt_timing_r*6)+:6]  
              <= #TCQ largest_left_edge;
            dbg_prbs_second_edge_taps[(prbs_dqs_cnt_timing_r*6)+:6] 
            <= #TCQ smallest_right_edge; 
        end
      end
  endgenerate
 
 //double window indication flag
  always @ (posedge clk)
    if (rst) double_window_ind <= #TCQ 1'd0;
    else double_window_ind  <= #TCQ double_window_ind? 1'b1: (valid_window_cnt > 1);

 //padded calculation
  always @ (smallest_right_edge or largest_left_edge)
    center_calc <= {1'b0, smallest_right_edge} + {1'b0,largest_left_edge};  
  //***************************************************************************
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
      assign compare_data_r0 = compare_data[DQ_WIDTH-1:0];
      assign compare_data_f0 = compare_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign compare_data_r1 = compare_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign compare_data_f1 = compare_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
      assign compare_data_r2 = compare_data[5*DQ_WIDTH-1:4*DQ_WIDTH];
      assign compare_data_f2 = compare_data[6*DQ_WIDTH-1:5*DQ_WIDTH];
      assign compare_data_r3 = compare_data[7*DQ_WIDTH-1:6*DQ_WIDTH];
      assign compare_data_f3 = compare_data[8*DQ_WIDTH-1:7*DQ_WIDTH];
    end else begin: rd_data_div2_logic_clk
      assign rd_data_rise0 = rd_data[DQ_WIDTH-1:0];
      assign rd_data_fall0 = rd_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign rd_data_rise1 = rd_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign rd_data_fall1 = rd_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
      assign compare_data_r0 = compare_data[DQ_WIDTH-1:0];
      assign compare_data_f0 = compare_data[2*DQ_WIDTH-1:DQ_WIDTH];
      assign compare_data_r1 = compare_data[3*DQ_WIDTH-1:2*DQ_WIDTH];
      assign compare_data_f1 = compare_data[4*DQ_WIDTH-1:3*DQ_WIDTH];
      assign compare_data_r2 = 'h0;
      assign compare_data_f2 = 'h0;
      assign compare_data_r3 = 'h0;
      assign compare_data_f3 = 'h0;
    end
  endgenerate

  always @(posedge clk) begin
    rd_mux_sel_r <= #TCQ prbs_dqs_cnt_r;
  end

  // Register outputs for improved timing.
  // NOTE: Will need to change when per-bit DQ deskew is supported.
  //       Currenly all bits in DQS group are checked in aggregate
  generate
    genvar mux_i;
    for (mux_i = 0; mux_i < DRAM_WIDTH; mux_i = mux_i + 1) begin: gen_mux_rd
      always @(posedge clk) begin
        mux_rd_rise0_r1[mux_i] <= #TCQ rd_data_rise0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_fall0_r1[mux_i] <= #TCQ rd_data_fall0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_rise1_r1[mux_i] <= #TCQ rd_data_rise1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_fall1_r1[mux_i] <= #TCQ rd_data_fall1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_rise2_r1[mux_i] <= #TCQ rd_data_rise2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_fall2_r1[mux_i] <= #TCQ rd_data_fall2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_rise3_r1[mux_i] <= #TCQ rd_data_rise3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        mux_rd_fall3_r1[mux_i] <= #TCQ rd_data_fall3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        //Compare data
        compare_data_rise0_r1[mux_i]  <= #TCQ compare_data_r0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_fall0_r1[mux_i]  <= #TCQ compare_data_f0[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_rise1_r1[mux_i]  <= #TCQ compare_data_r1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_fall1_r1[mux_i]  <= #TCQ compare_data_f1[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_rise2_r1[mux_i]  <= #TCQ compare_data_r2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_fall2_r1[mux_i]  <= #TCQ compare_data_f2[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_rise3_r1[mux_i]  <= #TCQ compare_data_r3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
        compare_data_fall3_r1[mux_i]  <= #TCQ compare_data_f3[DRAM_WIDTH*rd_mux_sel_r + mux_i];
      end
    end
  endgenerate
  
  generate
    genvar muxr2_i;
    if (nCK_PER_CLK == 4) begin: gen_mux_div4
        for (muxr2_i = 0; muxr2_i < DRAM_WIDTH; muxr2_i = muxr2_i + 1) begin: gen_rd_4
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
              mux_rd_rise0_r2[muxr2_i] <= #TCQ mux_rd_rise0_r1[muxr2_i];
              mux_rd_fall0_r2[muxr2_i] <= #TCQ mux_rd_fall0_r1[muxr2_i];
              mux_rd_rise1_r2[muxr2_i] <= #TCQ mux_rd_rise1_r1[muxr2_i];
              mux_rd_fall1_r2[muxr2_i] <= #TCQ mux_rd_fall1_r1[muxr2_i];
              mux_rd_rise2_r2[muxr2_i] <= #TCQ mux_rd_rise2_r1[muxr2_i];
              mux_rd_fall2_r2[muxr2_i] <= #TCQ mux_rd_fall2_r1[muxr2_i];
              mux_rd_rise3_r2[muxr2_i] <= #TCQ mux_rd_rise3_r1[muxr2_i];
              mux_rd_fall3_r2[muxr2_i] <= #TCQ mux_rd_fall3_r1[muxr2_i];
            end
           //pipeline stage
            mux_rd_rise0_r3[muxr2_i] <= #TCQ mux_rd_rise0_r2[muxr2_i];
            mux_rd_fall0_r3[muxr2_i] <= #TCQ mux_rd_fall0_r2[muxr2_i];
            mux_rd_rise1_r3[muxr2_i] <= #TCQ mux_rd_rise1_r2[muxr2_i];
            mux_rd_fall1_r3[muxr2_i] <= #TCQ mux_rd_fall1_r2[muxr2_i];
            mux_rd_rise2_r3[muxr2_i] <= #TCQ mux_rd_rise2_r2[muxr2_i];
            mux_rd_fall2_r3[muxr2_i] <= #TCQ mux_rd_fall2_r2[muxr2_i];
            mux_rd_rise3_r3[muxr2_i] <= #TCQ mux_rd_rise3_r2[muxr2_i];
            mux_rd_fall3_r3[muxr2_i] <= #TCQ mux_rd_fall3_r2[muxr2_i];
          //pipeline stage
            mux_rd_rise0_r4[muxr2_i] <= #TCQ mux_rd_rise0_r3[muxr2_i];
            mux_rd_fall0_r4[muxr2_i] <= #TCQ mux_rd_fall0_r3[muxr2_i];
            mux_rd_rise1_r4[muxr2_i] <= #TCQ mux_rd_rise1_r3[muxr2_i];
            mux_rd_fall1_r4[muxr2_i] <= #TCQ mux_rd_fall1_r3[muxr2_i];
            mux_rd_rise2_r4[muxr2_i] <= #TCQ mux_rd_rise2_r3[muxr2_i];
            mux_rd_fall2_r4[muxr2_i] <= #TCQ mux_rd_fall2_r3[muxr2_i];
            mux_rd_rise3_r4[muxr2_i] <= #TCQ mux_rd_rise3_r3[muxr2_i];
            mux_rd_fall3_r4[muxr2_i] <= #TCQ mux_rd_fall3_r3[muxr2_i];
          end
                end
    end else if (nCK_PER_CLK == 2) begin: gen_mux_div2
        for (muxr2_i = 0; muxr2_i < DRAM_WIDTH; muxr2_i = muxr2_i + 1) begin: gen_rd_2
          always @(posedge clk) begin
            if (mux_rd_valid_r) begin
              mux_rd_rise0_r2[muxr2_i] <= #TCQ mux_rd_rise0_r1[muxr2_i];
              mux_rd_fall0_r2[muxr2_i] <= #TCQ mux_rd_fall0_r1[muxr2_i];
              mux_rd_rise1_r2[muxr2_i] <= #TCQ mux_rd_rise1_r1[muxr2_i];
              mux_rd_fall1_r2[muxr2_i] <= #TCQ mux_rd_fall1_r1[muxr2_i];      
              mux_rd_rise2_r2[muxr2_i] <= 'h0;
              mux_rd_fall2_r2[muxr2_i] <= 'h0;
              mux_rd_rise3_r2[muxr2_i] <= 'h0;
              mux_rd_fall3_r2[muxr2_i] <= 'h0;
            end
            mux_rd_rise0_r3[muxr2_i] <= #TCQ mux_rd_rise0_r2[muxr2_i];
            mux_rd_fall0_r3[muxr2_i] <= #TCQ mux_rd_fall0_r2[muxr2_i];
            mux_rd_rise1_r3[muxr2_i] <= #TCQ mux_rd_rise1_r2[muxr2_i];
            mux_rd_fall1_r3[muxr2_i] <= #TCQ mux_rd_fall1_r2[muxr2_i];
            mux_rd_rise2_r3[muxr2_i] <= 'h0;
            mux_rd_fall2_r3[muxr2_i] <= 'h0;
            mux_rd_rise3_r3[muxr2_i] <= 'h0;
            mux_rd_fall3_r3[muxr2_i] <= 'h0;

            //pipeline stage
            mux_rd_rise0_r4[muxr2_i] <= #TCQ mux_rd_rise0_r3[muxr2_i];
            mux_rd_fall0_r4[muxr2_i] <= #TCQ mux_rd_fall0_r3[muxr2_i];
            mux_rd_rise1_r4[muxr2_i] <= #TCQ mux_rd_rise1_r3[muxr2_i];
            mux_rd_fall1_r4[muxr2_i] <= #TCQ mux_rd_fall1_r3[muxr2_i];
            mux_rd_rise2_r4[muxr2_i] <= 'h0;
            mux_rd_fall2_r4[muxr2_i] <= 'h0;
            mux_rd_rise3_r4[muxr2_i] <= 'h0;
            mux_rd_fall3_r4[muxr2_i] <= 'h0;
          end
        end
    end
  endgenerate

  
  // Registered signal indicates when mux_rd_rise/fall_r is valid
  always @(posedge clk) begin
    mux_rd_valid_r <= #TCQ ~phy_if_empty && prbs_rdlvl_start;
    rd_valid_r1    <= #TCQ mux_rd_valid_r;
    rd_valid_r2    <= #TCQ rd_valid_r1;
    rd_valid_r3    <= #TCQ rd_valid_r2;
  end
  


  
// Counter counts # of samples compared
// Reset sample counter when not "sampling"
// Otherwise, count # of samples compared
// Same counter is shared for three samples checked
  always @(posedge clk)
    if (rst)
      samples_cnt_r <= #TCQ 'b0;
    else if (samples_cnt_r == NUM_SAMPLES_CNT) begin
      samples_cnt_r <= #TCQ 'b0;
    end else if (complex_sample_cnt_inc) begin
      samples_cnt_r <= #TCQ samples_cnt_r + 1;
      /*if (!rd_valid_r1 ||
          (prbs_state_r == PRBS_DEC_DQS_WAIT) ||
          (prbs_state_r == PRBS_INC_DQS_WAIT) ||
          (prbs_state_r == PRBS_DEC_DQS) ||
          (prbs_state_r == PRBS_INC_DQS) ||
          (samples_cnt_r == NUM_SAMPLES_CNT) ||
          (samples_cnt_r == NUM_SAMPLES_CNT1))
        samples_cnt_r <= #TCQ 'b0;
      else if (rd_valid_r1 && 
               (((samples_cnt_r < NUM_SAMPLES_CNT) && ~samples_cnt1_en_r) ||
                ((samples_cnt_r < NUM_SAMPLES_CNT1) && ~samples_cnt2_en_r) ||
                ((samples_cnt_r < NUM_SAMPLES_CNT2) && samples_cnt2_en_r)))
        samples_cnt_r <= #TCQ samples_cnt_r + 1;*/
    end

// Count #2 enable generation
// Assert when correct number of samples compared
  always @(posedge clk)
    if (rst)
      samples_cnt1_en_r <= #TCQ 1'b0;
    else begin 
      if ((prbs_state_r == PRBS_IDLE) || 
          (prbs_state_r == PRBS_DEC_DQS) ||
          (prbs_state_r == PRBS_INC_DQS) ||
          (prbs_state_r == FINE_PI_INC) ||
          (prbs_state_r == PRBS_NEW_DQS_PREWAIT))
        samples_cnt1_en_r <= #TCQ 1'b0;
      else if ((samples_cnt_r == NUM_SAMPLES_CNT) && rd_valid_r1)
        samples_cnt1_en_r <= #TCQ 1'b1;
    end

// Counter #3 enable generation
// Assert when correct number of samples compared
  always @(posedge clk)
    if (rst)
      samples_cnt2_en_r <= #TCQ 1'b0;
    else begin 
      if ((prbs_state_r == PRBS_IDLE) || 
          (prbs_state_r == PRBS_DEC_DQS) ||
          (prbs_state_r == PRBS_INC_DQS) ||
          (prbs_state_r == FINE_PI_INC) ||
          (prbs_state_r == PRBS_NEW_DQS_PREWAIT))
        samples_cnt2_en_r <= #TCQ 1'b0;
      else if ((samples_cnt_r == NUM_SAMPLES_CNT1) && rd_valid_r1 && samples_cnt1_en_r)
        samples_cnt2_en_r <= #TCQ 1'b1;
    end

// Victim selection logic
  always @(posedge clk)
    if (rst)
      rd_victim_sel    <= #TCQ 'd0;
    else if (num_samples_done_r)
      rd_victim_sel    <= #TCQ 'd0;
    else if (samples_cnt_r == NUM_SAMPLES_CNT) begin
      if (rd_victim_sel < 'd7)
        rd_victim_sel    <= #TCQ rd_victim_sel + 1;
    end
    
// Output row count increment pulse to phy_init
  always @(posedge clk)
    if (rst)
      complex_victim_inc <= #TCQ 1'b0;
    else if (samples_cnt_r == NUM_SAMPLES_CNT)
      complex_victim_inc <= #TCQ 1'b1;
    else
      complex_victim_inc <= #TCQ 1'b0;
    
generate
  if (FIXED_VICTIM == "TRUE") begin: victim_fixed
    always @(posedge clk)
      if (rst)
        num_samples_done_r <= #TCQ 1'b0;
      else if ((prbs_state_r == PRBS_DEC_DQS) ||
            (prbs_state_r == PRBS_INC_DQS)||
            (prbs_state_r == FINE_PI_INC) ||
            (prbs_state_r == FINE_PI_DEC))
        num_samples_done_r <= #TCQ 'b0;
      else if (samples_cnt_r == NUM_SAMPLES_CNT)
        num_samples_done_r <= #TCQ 1'b1;
  end else begin: victim_not_fixed
    always @(posedge clk)
      if (rst)
        num_samples_done_r <= #TCQ 1'b0;
      else if ((prbs_state_r == PRBS_DEC_DQS) ||
            (prbs_state_r == PRBS_INC_DQS)||
            (prbs_state_r == FINE_PI_INC) ||
            (prbs_state_r == FINE_PI_DEC))
        num_samples_done_r <= #TCQ 'b0;
      else if ((samples_cnt_r == NUM_SAMPLES_CNT) && (rd_victim_sel == 'd7))
        num_samples_done_r <= #TCQ 1'b1;
  end
endgenerate
    
  
  //***************************************************************************
  // Compare Read Data for the byte being Leveled with Expected data from PRBS
  // generator. Resulting compare_err signal used to determine read data valid
  // edge.
  //***************************************************************************
  generate
    if (nCK_PER_CLK == 4) begin: cmp_err_4to1
      always @ (posedge clk) begin
        if (rst || new_cnt_dqs_r || (prbs_state_r == PRBS_INC_DQS) || (prbs_state_r == PRBS_DEC_DQS)) begin
              compare_err    <= #TCQ 1'b0;
              compare_err_r0 <= #TCQ 1'b0;
              compare_err_f0 <= #TCQ 1'b0;
              compare_err_r1 <= #TCQ 1'b0;
              compare_err_f1 <= #TCQ 1'b0;
              compare_err_r2 <= #TCQ 1'b0;
              compare_err_f2 <= #TCQ 1'b0;
              compare_err_r3 <= #TCQ 1'b0;
              compare_err_f3 <= #TCQ 1'b0;
            end else if (rd_valid_r2) begin
              compare_err_r0  <= #TCQ (mux_rd_rise0_r3 != compare_data_rise0_r1);
              compare_err_f0  <= #TCQ (mux_rd_fall0_r3 != compare_data_fall0_r1);
              compare_err_r1  <= #TCQ (mux_rd_rise1_r3 != compare_data_rise1_r1);
              compare_err_f1  <= #TCQ (mux_rd_fall1_r3 != compare_data_fall1_r1);
              compare_err_r2  <= #TCQ (mux_rd_rise2_r3 != compare_data_rise2_r1);
              compare_err_f2  <= #TCQ (mux_rd_fall2_r3 != compare_data_fall2_r1);
              compare_err_r3  <= #TCQ (mux_rd_rise3_r3 != compare_data_rise3_r1);
              compare_err_f3  <= #TCQ (mux_rd_fall3_r3 != compare_data_fall3_r1);
              compare_err     <= #TCQ (compare_err_r0 | compare_err_f0 |
                                       compare_err_r1 | compare_err_f1 |
                                                           compare_err_r2 | compare_err_f2 |
                                                           compare_err_r3 | compare_err_f3);
            end
      end
        end else begin: cmp_err_2to1
          always @ (posedge clk) begin
        if (rst || new_cnt_dqs_r || (prbs_state_r == PRBS_INC_DQS) || (prbs_state_r == PRBS_DEC_DQS)) begin
              compare_err    <= #TCQ 1'b0;
              compare_err_r0 <= #TCQ 1'b0;
              compare_err_f0 <= #TCQ 1'b0;
              compare_err_r1 <= #TCQ 1'b0;
              compare_err_f1 <= #TCQ 1'b0;
            end else if (rd_valid_r2) begin
              compare_err_r0  <= #TCQ (mux_rd_rise0_r3 != compare_data_rise0_r1);
              compare_err_f0  <= #TCQ (mux_rd_fall0_r3 != compare_data_fall0_r1);
              compare_err_r1  <= #TCQ (mux_rd_rise1_r3 != compare_data_rise1_r1);
              compare_err_f1  <= #TCQ (mux_rd_fall1_r3 != compare_data_fall1_r1);
              compare_err     <= #TCQ (compare_err_r0 | compare_err_f0 |
                                       compare_err_r1 | compare_err_f1);
            end
      end
        end
  endgenerate

  //Sticky bit compare_err
  always @ (posedge clk)
    if (prbs_state_r == PRBS_PAT_COMPARE)
      compare_err_latch <= #TCQ compare_err? 1'b1: compare_err_latch;
    else 
      compare_err_latch <= #TCQ 1'b0;
          
//***************************************************************************
// Decrement initial Phaser_IN fine delay value before proceeding with
// read calibration
//***************************************************************************
  
  
//***************************************************************************
// Demultiplexor to control Phaser_IN delay values
//***************************************************************************

// Read DQS
  always @(posedge clk) begin
    if (rst) begin
      pi_en_stg2_f_timing     <= #TCQ 'b0;
      pi_stg2_f_incdec_timing <= #TCQ 'b0;
    end else if (prbs_tap_en_r) begin
// Change only specified DQS
      pi_en_stg2_f_timing     <= #TCQ 1'b1;  
      pi_stg2_f_incdec_timing <= #TCQ prbs_tap_inc_r;
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
      prbs_rdlvl_prech_req <= #TCQ 1'b0;
    else
      prbs_rdlvl_prech_req <= #TCQ prbs_prech_req_r;

//*****************************************************************
// keep track of edge tap counts found, and current capture clock
// tap count
//*****************************************************************

  always @(posedge clk)
    if (rst) begin
      prbs_dqs_tap_cnt_r   <= #TCQ 'b0;
      rdlvl_cpt_tap_cnt    <= #TCQ 'b0;
    end else if (new_cnt_dqs_r) begin
      prbs_dqs_tap_cnt_r   <= #TCQ pi_counter_read_val;
      rdlvl_cpt_tap_cnt    <= #TCQ pi_counter_read_val;
    end else if (prbs_tap_en_r) begin
      if (prbs_tap_inc_r)
        prbs_dqs_tap_cnt_r <= #TCQ prbs_dqs_tap_cnt_r + 1;
      else if (prbs_dqs_tap_cnt_r != 'd0)
        prbs_dqs_tap_cnt_r <= #TCQ prbs_dqs_tap_cnt_r - 1;
    end
    
  always @(posedge clk)
    if (rst) begin
      prbs_dec_tap_calc_plus_3  <= #TCQ 'b0;
      prbs_dec_tap_calc_minus_3 <= #TCQ 'b0;
    end else if (new_cnt_dqs_r) begin
      prbs_dec_tap_calc_plus_3  <= #TCQ 'b000011;
      prbs_dec_tap_calc_minus_3 <= #TCQ 'b111100;
    end else begin
      prbs_dec_tap_calc_plus_3  <= #TCQ (prbs_dqs_tap_cnt_r  - rdlvl_cpt_tap_cnt + 3);
      prbs_dec_tap_calc_minus_3 <= #TCQ (prbs_dqs_tap_cnt_r  - rdlvl_cpt_tap_cnt - 3);
    end

  always @(posedge clk)
    if (rst || new_cnt_dqs_r)
      prbs_dqs_tap_limit_r <= #TCQ 1'b0;
    else if (prbs_dqs_tap_cnt_r == 6'd63)
      prbs_dqs_tap_limit_r <= #TCQ 1'b1;
    else
      prbs_dqs_tap_limit_r <= #TCQ 1'b0;

  // Temp wire for timing.
   // The following in the always block below causes timing issues
   // due to DSP block inference
   // 6*prbs_dqs_cnt_r.
   // replacing this with two left shifts + one left shift  to avoid
   // DSP multiplier.

  assign prbs_dqs_cnt_timing = {2'd0, prbs_dqs_cnt_r};


  always @(posedge clk)
    prbs_dqs_cnt_timing_r <= #TCQ prbs_dqs_cnt_timing;
    

   // Storing DQS tap values at the end of each DQS read leveling
   always @(posedge clk) begin
     if (rst) begin
       prbs_final_dqs_tap_cnt_r <= #TCQ 'b0;
     end else if ((prbs_state_r == PRBS_NEXT_DQS) && (prbs_state_r1 != PRBS_NEXT_DQS)) begin
        prbs_final_dqs_tap_cnt_r[(prbs_dqs_cnt_timing_r*6)+:6]
           <= #TCQ prbs_dqs_tap_cnt_r;
     end
   end




  //*****************************************************************
  
  always @(posedge clk) begin
    prbs_state_r1      <= #TCQ prbs_state_r;
    prbs_rdlvl_start_r <= #TCQ prbs_rdlvl_start;
  end
    
// Wait counter for wait states
  always @(posedge clk)
    if ((prbs_state_r == PRBS_NEW_DQS_WAIT) ||
        (prbs_state_r == PRBS_INC_DQS_WAIT) ||
        (prbs_state_r == PRBS_DEC_DQS_WAIT) ||
        (prbs_state_r == FINE_PI_DEC_WAIT)  ||
        (prbs_state_r == FINE_PI_INC_WAIT)  ||
        (prbs_state_r == PRBS_NEW_DQS_PREWAIT))
      wait_state_cnt_en_r <= #TCQ 1'b1;
    else
      wait_state_cnt_en_r <= #TCQ 1'b0;
     
  always @(posedge clk)
    if (!wait_state_cnt_en_r) begin
      wait_state_cnt_r <= #TCQ 'b0;
      cnt_wait_state   <= #TCQ 1'b0;
    end else begin
      if (wait_state_cnt_r < 'd15) begin
        wait_state_cnt_r <= #TCQ wait_state_cnt_r + 1;
        cnt_wait_state   <= #TCQ 1'b0;
      end else begin
        // Need to reset to 0 to handle the case when there are two
        // different WAIT states back-to-back
        wait_state_cnt_r <= #TCQ 'b0;        
        cnt_wait_state   <= #TCQ 1'b1;
      end
    end

  always @ (posedge clk)
    err_chk_invalid <= #TCQ (wait_state_cnt_r < 'd14);
   

//*****************************************************************
// compare error checking per-bit
//****************************************************************

  generate 
    genvar pb_i;
    if (nCK_PER_CLK == 4) begin: cmp_err_pb_4to1
      for(pb_i=0 ; pb_i<DRAM_WIDTH; pb_i=pb_i+1) begin
        always @ (posedge clk) begin
          //prevent error check during PI inc/dec and wait
          if (rst || new_cnt_dqs_r || (prbs_state_r == FINE_PI_INC) || (prbs_state_r == FINE_PI_DEC) || 
         (err_chk_invalid && ((prbs_state_r == FINE_PI_DEC_WAIT)||(prbs_state_r == FINE_PI_INC_WAIT)))) 
            compare_err_pb[pb_i]  <= #TCQ 1'b0;
          else if (rd_valid_r2) 
            compare_err_pb[pb_i]  <= #TCQ (mux_rd_rise0_r3[pb_i] != compare_data_rise0_r1[pb_i]) |  
                                          (mux_rd_fall0_r3[pb_i] != compare_data_fall0_r1[pb_i]) |  
                                          (mux_rd_rise1_r3[pb_i] != compare_data_rise1_r1[pb_i]) |  
                                          (mux_rd_fall1_r3[pb_i] != compare_data_fall1_r1[pb_i]) |  
                                          (mux_rd_rise2_r3[pb_i] != compare_data_rise2_r1[pb_i]) |  
                                          (mux_rd_fall2_r3[pb_i] != compare_data_fall2_r1[pb_i]) |  
                                          (mux_rd_rise3_r3[pb_i] != compare_data_rise3_r1[pb_i]) |  
                                          (mux_rd_fall3_r3[pb_i] != compare_data_fall3_r1[pb_i]) ; 
        end //always
      end  //for
    end else begin: cmp_err_pb_2to1
      for(pb_i=0 ; pb_i<DRAM_WIDTH; pb_i=pb_i+1) begin
        always @ (posedge clk) begin
          if (rst || new_cnt_dqs_r || (prbs_state_r == FINE_PI_INC) || (prbs_state_r == FINE_PI_DEC) || 
          (err_chk_invalid && ((prbs_state_r == FINE_PI_DEC_WAIT)||(prbs_state_r == FINE_PI_INC_WAIT)))) 
            compare_err_pb[pb_i]  <= #TCQ 1'b0;
          else if (rd_valid_r2) 
            compare_err_pb[pb_i]  <= #TCQ (mux_rd_rise0_r3[pb_i] != compare_data_rise0_r1[pb_i]) |  
                                          (mux_rd_fall0_r3[pb_i] != compare_data_fall0_r1[pb_i]) |  
                                          (mux_rd_rise1_r3[pb_i] != compare_data_rise1_r1[pb_i]) |  
                                          (mux_rd_fall1_r3[pb_i] != compare_data_fall1_r1[pb_i]) ;  
        end //always
      end  //for
    end  //if
  endgenerate

  //generate stick error bit - left/right edge 
  generate 
  genvar pb_r;
    for(pb_r=0; pb_r<DRAM_WIDTH; pb_r=pb_r+1) begin
      always @ (posedge clk) begin
        if((prbs_state_r == FINE_PI_INC) | (prbs_state_r == FINE_PI_DEC) | 
          (~cnt_wait_state && ((prbs_state_r == FINE_PI_INC_WAIT)|(prbs_state_r == FINE_PI_DEC_WAIT)))) 
          compare_err_pb_latch_r[pb_r] <= #TCQ 1'b0;
        else 
          compare_err_pb_latch_r[pb_r] <= #TCQ compare_err_pb[pb_r]? 1'b1:compare_err_pb_latch_r[pb_r];  
      end
    end
  endgenerate

  //checking all/any bit has error  
  always @ (posedge clk) begin
    if(rst | (prbs_state_r == FINE_PI_INC) | (prbs_state_r == FINE_PI_DEC) | 
      (~cnt_wait_state && ((prbs_state_r == FINE_PI_INC_WAIT)|(prbs_state_r == FINE_PI_DEC_WAIT)))) begin 
	  compare_err_pb_and <= #TCQ 1'b0;
	  compare_err_pb_or  <= #TCQ 1'b0;
    end
	else begin
          compare_err_pb_and <= #TCQ &compare_err_pb? 1'b1: compare_err_pb_and;
	  compare_err_pb_or  <= #TCQ |compare_err_pb? 1'b1: compare_err_pb_or; 
	end
  end

  //in stage 0, if left edge found, update ref_bit (one hot)
  always @ (posedge clk) begin
    if (rst | (prbs_state_r == PRBS_NEW_DQS_WAIT)) begin
      ref_bit_per_bit <= #TCQ 'd0;
    end else if ((prbs_state_r == FINE_PI_INC) && (stage_cnt=='b0)) begin
      if(|left_edge_updated) ref_bit_per_bit <= #TCQ left_edge_updated;
    end
  end

  //ref bit with samllest right edge 
  //if bit 1 and 3 are set to ref_bit_per_bit but bit 1 has smaller right edge, bit is selected as ref_bit
  always @ (posedge clk) begin
    if(rst | (prbs_state_r == PRBS_NEW_DQS_WAIT)) begin
      bit_cnt <= #TCQ 'd0;
      ref_right_edge <= #TCQ 6'h3f;
      ref_bit <= #TCQ 'd0;
    end else if ((prbs_state_r == FINE_CALC_TAPS_WAIT) && (stage_cnt == 'b0) && (bit_cnt < DRAM_WIDTH)) begin
      bit_cnt <= #TCQ bit_cnt +'b1;
      if ((ref_bit_per_bit[bit_cnt]==1'b1) && (right_edge_pb[bit_cnt*6+:6]<= ref_right_edge)) begin
        ref_bit <= #TCQ bit_cnt;
        ref_right_edge <= #TCQ right_edge_pb[bit_cnt*6+:6];
      end
    end
  end

  //pipe lining for reference bit left/right edge
  always @ (posedge clk) begin
    left_edge_ref <= #TCQ left_edge_pb[ref_bit*6+:6];
    right_edge_ref <= #TCQ right_edge_pb[ref_bit*6+:6];
  end

  //left_edge/right_edge/left_loss/right_gain update 
  generate
  genvar eg;
  for(eg=0; eg<DRAM_WIDTH; eg = eg+1) begin
    always @ (posedge clk) begin
      if(rst | (prbs_state_r == PRBS_NEW_DQS_WAIT)) begin
        match_flag_pb[eg*MIN_WIN+:MIN_WIN] <= #TCQ MATCH_ALL_ONE;  //8'hff
        left_edge_pb[eg*6+:6] <= #TCQ 'b0;
        right_edge_pb[eg*6+:6] <= #TCQ 6'h3f;
        left_edge_found_pb[eg] <= #TCQ 1'b0;
        right_edge_found_pb[eg] <= #TCQ 1'b0;
        left_loss_pb[eg*6+:6] <= #TCQ 'b0;
        right_gain_pb[eg*6+:6] <= #TCQ 'b0;
        left_edge_updated[eg]  <= #TCQ 'b0;
      end else begin 
        if((prbs_state_r == FINE_PAT_COMPARE_PER_BIT) && num_samples_done_r) begin  
            //left edge is updated when match flag becomes 10000000 (1 fail ,8 success)
            if(match_flag_pb[eg*MIN_WIN+:MIN_WIN]== MIN_LEFT && compare_err_pb_latch_r[eg]==0) begin 
              left_edge_pb[eg*6+:6] <= #TCQ prbs_dqs_tap_cnt_r- (MIN_WIN-1);
              left_edge_found_pb[eg] <= #TCQ 1'b1;  //used for update largest_left_edge
              left_edge_updated[eg] <= #TCQ 1'b1;
              //check the loss of bit - update only for left edge found
              if(~left_edge_found_pb[eg]) 
                left_loss_pb[eg*6+:6] <= #TCQ (left_edge_ref > prbs_dqs_tap_cnt_r -(MIN_WIN-1))? 'd0
                                 : prbs_dqs_tap_cnt_r-(MIN_WIN-1)-left_edge_ref;
            //right edge is updated when match flag becomes 000000001 (8 success, 1 fail)
            end else if (match_flag_pb[eg*MIN_WIN+:MIN_WIN]== MIN_PASS  && compare_err_pb_latch_r[eg]) begin 
               right_edge_pb[eg*6+:6] <= #TCQ prbs_dqs_tap_cnt_r-1;
               right_edge_found_pb[eg] <= #TCQ 1'b1;
               //check the gain of bit - update only for right edge found
               if(~right_edge_found_pb[eg])  
                 right_gain_pb[eg*6+:6] <= #TCQ (right_edge_ref > prbs_dqs_tap_cnt_r-1)?
                                           ((right_edge_pb[eg*6 +:6] > prbs_dqs_tap_cnt_r-1)? 0: prbs_dqs_tap_cnt_r-1- right_edge_pb[eg*6+:6]):
                                           ((right_edge_pb[eg*6+:6] > right_edge_ref)? 0 : right_edge_ref - right_edge_pb[eg*6+:6]);
           //no right edge found
           end else if (prbs_dqs_tap_cnt_r == 6'h3f && ~right_edge_found_pb[eg]) begin
             right_edge_pb[eg*6+:6] <= #TCQ 6'h3f;
             right_edge_found_pb[eg] <= #TCQ 1'b1;
             //right edge at 63. gain = max(0, ref_bit_right_tap - prev_right_edge)
             right_gain_pb[eg*6+:6] <= #TCQ (right_edge_ref > right_edge_pb[eg*6+:6])?
                                   (right_edge_ref - right_edge_pb[eg*6+:6]) : 0;
           end
           //update match flag - shift and update
           match_flag_pb[eg*MIN_WIN+:MIN_WIN] <= #TCQ {match_flag_pb[(eg*MIN_WIN)+:(MIN_WIN-1)],compare_err_pb_latch_r[eg]};
         end else if (prbs_state_r == FINE_PI_DEC) begin
           left_edge_found_pb[eg] <= #TCQ 1'b0;
           right_edge_found_pb[eg] <= #TCQ 1'b0;
           left_loss_pb[eg*6+:6] <= #TCQ 'b0;
           right_gain_pb[eg*6+:6] <= #TCQ 'b0; 
           match_flag_pb[eg*MIN_WIN+:MIN_WIN] <= #TCQ MATCH_ALL_ONE ;  //new fix
           left_edge_updated[eg] <= #TCQ 'b0;   //used only for update largest ref_bit and largest_left_edge
         end else if (prbs_state_r == FINE_PI_INC) begin
           left_edge_updated[eg] <= #TCQ 'b0;   //used only for update largest ref_bit and largest_left_edge
         end
       end
     end  //always
   end //for
   endgenerate

   //update fine_delay according to loss/gain value per bit
   generate 
   genvar f_pb;
   for(f_pb=0; f_pb<DRAM_WIDTH; f_pb=f_pb+1) begin
     always @ (posedge clk) begin
       if(rst | prbs_state_r == PRBS_NEW_DQS_WAIT ) begin
         fine_delay_incdec_pb[f_pb] <= #TCQ 1'b0;
       end else if((prbs_state_r == FINE_CALC_TAPS_WAIT) && (bit_cnt == DRAM_WIDTH)) begin 
         if(stage_cnt == 'd0) fine_delay_incdec_pb[f_pb] <= #TCQ (f_pb==ref_bit)? 1'b0:1'b1;  //only for initial stage
         else if(stage_cnt == 'd1) fine_delay_incdec_pb[f_pb] <= #TCQ (right_gain_pb[f_pb*6+:6]>left_loss_pb[f_pb*6+:6])?1'b1:1'b0;
       end
     end
   end
   endgenerate
  
   //fine inc stage (stage cnt 0,1,2), fine dec stage (stage cnt 3)
   always @ (posedge clk) begin
     if (rst)
       fine_inc_stage <= #TCQ 'b1;
     else
       fine_inc_stage <= #TCQ (stage_cnt!='d3);
   end
//*****************************************************************
  
  always @(posedge clk)
    if (rst) begin
      prbs_dqs_cnt_r        <= #TCQ 'b0;
      prbs_tap_en_r         <= #TCQ 1'b0;
      prbs_tap_inc_r        <= #TCQ 1'b0;
      prbs_prech_req_r      <= #TCQ 1'b0;
      prbs_state_r          <= #TCQ PRBS_IDLE;
      prbs_found_1st_edge_r <= #TCQ 1'b0;
      prbs_found_2nd_edge_r <= #TCQ 1'b0;
      prbs_1st_edge_taps_r  <= #TCQ 6'bxxxxxx;
      prbs_inc_tap_cnt      <= #TCQ 'b0;
      prbs_dec_tap_cnt      <= #TCQ 'b0;
      new_cnt_dqs_r         <= #TCQ 1'b0;
      if (SIM_CAL_OPTION == "FAST_CAL")
        prbs_rdlvl_done       <= #TCQ 1'b1;
      else
        prbs_rdlvl_done       <= #TCQ 1'b0;
      prbs_2nd_edge_taps_r  <= #TCQ 6'bxxxxxx;
      prbs_last_byte_done   <= #TCQ 1'b0;
      prbs_tap_mod          <= #TCQ 'd0;
      reset_rd_addr         <= #TCQ 'b0;
      fine_pi_dec_cnt       <= #TCQ 'b0; 
      match_flag_and        <= #TCQ MATCH_ALL_ONE;
      match_flag_or         <= #TCQ MATCH_ALL_ONE;
      no_err_win_detected   <= #TCQ 1'b0; 
      no_err_win_detected_latch   <= #TCQ 1'b0; 
      valid_window_cnt      <= 2'd0;
      stage_cnt             <= #TCQ 2'b00;
      right_edge_found      <= #TCQ 1'b0;
      largest_left_edge     <= #TCQ 6'b000000;
      smallest_right_edge   <= #TCQ 6'b111111;
      num_samples_done_ind  <= #TCQ 'b0;
      fine_delay_sel        <= #TCQ 'b0;
      fine_dly_error        <= #TCQ 'b0;
      edge_det_error        <= #TCQ 'b0;
      complex_pi_incdec_done <= #TCQ 1'b0;
      complex_init_pi_dec_done_r <= #TCQ 1'b0;
    end else begin
      
      case (prbs_state_r)
        
        PRBS_IDLE: begin
          prbs_last_byte_done  <= #TCQ 1'b0;
          prbs_prech_req_r     <= #TCQ 1'b0;
          if (prbs_rdlvl_start && ~prbs_rdlvl_start_r) begin
            if (SIM_CAL_OPTION == "SKIP_CAL" || SIM_CAL_OPTION == "FAST_CAL") begin
              prbs_state_r  <= #TCQ PRBS_DONE;
              reset_rd_addr <= #TCQ 1'b1;
            end else begin
              new_cnt_dqs_r <= #TCQ 1'b1;            
              prbs_state_r  <= #TCQ PRBS_NEW_DQS_WAIT;
              fine_pi_dec_cnt <= #TCQ pi_counter_read_val;//.
            end
          end
        end
        
        // Wait for the new DQS group to change
        // also gives time for the read data IN_FIFO to
        // output the updated data for the new DQS group
        PRBS_NEW_DQS_WAIT: begin
          reset_rd_addr <= #TCQ 'b0;
          prbs_last_byte_done <= #TCQ 1'b0;
          prbs_prech_req_r    <= #TCQ 1'b0;
          stage_cnt           <= #TCQ 2'b0;
          match_flag_and        <= #TCQ MATCH_ALL_ONE;
          match_flag_or         <= #TCQ MATCH_ALL_ONE;
          no_err_win_detected   <= #TCQ 1'b0;
          no_err_win_detected_latch   <= #TCQ 1'b0;
          if (cnt_wait_state) begin
            new_cnt_dqs_r <= #TCQ 1'b0;
            prbs_state_r  <= #TCQ fine_calib? FINE_PI_DEC:PRBS_PAT_COMPARE;
            //For normal, it doesn't have initial pi incdec
            complex_pi_incdec_done <= #TCQ fine_calib? complex_pi_incdec_done: 1'b1;
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
        //      this state (see comment in PRBS_PAT_COMPARE below for 
        //      why this is done)
        //   2. A change in the read data while we are in this state
        //      (i.e. in the absence of a tap delay increment). This
        //      indicates that we're close enough to a window edge that
        //      jitter will cause the read data to change even in the
        //      absence of a tap delay change 
        PRBS_PAT_COMPARE: begin
          // Continue to sample read data and look for edges until the
          // appropriate time interval (shorter for simulation-only, 
          // much, much longer for actual h/w) has elapsed
          //comparision started - wait for next PI movement after read
          complex_pi_incdec_done <= #TCQ 1'b0;  //need to be wait for new incdec done 
          if (num_samples_done_r) begin
            if (prbs_dqs_tap_limit_r)
              // Only one edge detected and ran out of taps since only one
              // bit time worth of taps available for window detection. This
              // can happen if at tap 0 DQS is in previous window which results
              // in only left edge being detected. Or at tap 0 DQS is in the
              // current window resulting in only right edge being detected.
              // Depending on the frequency this case can also happen if at
              // tap 0 DQS is in the left noise region resulting in only left
              // edge being detected.
              prbs_state_r <= #TCQ PRBS_CALC_TAPS_PRE;
            else if (compare_err_latch || (prbs_dqs_tap_cnt_r == 'd0)) begin 
              // Sticky bit - asserted after we encounter an edge, although
              // the current edge may not be considered the "first edge" this
              // just means we found at least one edge
              prbs_found_1st_edge_r <= #TCQ 1'b1;
              
              // Both edges of data valid window found:
              // If we've found a second edge after a region of stability
              // then we must have just passed the second ("right" edge of
              // the window. Record this second_edge_taps = current tap-1, 
              // because we're one past the actual second edge tap, where 
              // the edge taps represent the extremes of the data valid 
              // window (i.e. smallest & largest taps where data still valid
              if (prbs_found_1st_edge_r) begin
                prbs_found_2nd_edge_r <= #TCQ 1'b1;
                prbs_2nd_edge_taps_r  <= #TCQ prbs_dqs_tap_cnt_r - 1;
                prbs_state_r          <= #TCQ PRBS_CALC_TAPS_PRE;
              end else begin
                // Otherwise, an edge was found (just not the "second" edge)
                // Assuming DQS is in the correct window at tap 0 of Phaser IN
                // fine tap. The first edge found is the right edge of the valid
                // window and is the beginning of the jitter region hence done!
                if (compare_err_latch)
                  prbs_1st_edge_taps_r <= #TCQ prbs_dqs_tap_cnt_r + 1;
                else
                  prbs_1st_edge_taps_r <= #TCQ 'd0;
                
                prbs_inc_tap_cnt     <= #TCQ rdlvl_cpt_tap_cnt - prbs_dqs_tap_cnt_r;           
                prbs_state_r         <= #TCQ RD_DONE_WAIT_FOR_PI_INC_INC;
              end
            end else begin
              // Otherwise, if we haven't found an edge.... 
              // If we still have taps left to use, then keep incrementing
              if (prbs_found_1st_edge_r)
                //prbs_state_r  <= #TCQ PRBS_INC_DQS;
                prbs_state_r  <= #TCQ RD_DONE_WAIT_FOR_PI_INC_INC;
              else
                //prbs_state_r  <= #TCQ PRBS_DEC_DQS;
                prbs_state_r  <= #TCQ RD_DONE_WAIT_FOR_PI_INC_DEC;
            end
          end 
        end
        
        // Increment Phaser_IN delay for DQS
        PRBS_INC_DQS: begin
          prbs_state_r        <= #TCQ PRBS_INC_DQS_WAIT;
          if (prbs_inc_tap_cnt > 'd0)
            prbs_inc_tap_cnt <= #TCQ prbs_inc_tap_cnt - 1;
          if (~prbs_dqs_tap_limit_r) begin
            prbs_tap_en_r    <= #TCQ 1'b1;
            prbs_tap_inc_r   <= #TCQ 1'b1;
          end
        end

        // Wait for Phaser_In to settle, before checking again for an edge 
        // only all INC is done, incdec done is asserted 
        PRBS_INC_DQS_WAIT: begin
          prbs_tap_en_r    <= #TCQ 1'b0;
          prbs_tap_inc_r   <= #TCQ 1'b0; 
          if (cnt_wait_state) begin
            if (prbs_inc_tap_cnt > 'd0)
              prbs_state_r <= #TCQ PRBS_INC_DQS;  //centering
            else begin
              prbs_state_r <= #TCQ PRBS_PAT_COMPARE;
              complex_pi_incdec_done <= #TCQ 1'b1;
            end
          end
        end
          
        // Calculate final value of Phaser_IN taps. At this point, one or both
        // edges of data eye have been found, and/or all taps have been
        // exhausted looking for the edges
        // NOTE: The amount to be decrement by is calculated, not the
        //  absolute setting for DQS.
        // CENTER compensation with shift by 1 
        //wait finishing the read before PI dec to center
        PRBS_CALC_TAPS: begin
          if (center_comp) begin
            prbs_dec_tap_cnt <= #TCQ (dec_cnt[5] & dec_cnt[0])? 'd32: dec_cnt + pi_adj;
            fine_dly_error <= #TCQ (dec_cnt[5] & dec_cnt[0])? 1'b1: fine_dly_error; //sticky bit
            prbs_state_r <= #TCQ RD_DONE_WAIT_FOR_PI_INC_DEC;
          end else begin  //No center compensation
            if (prbs_found_2nd_edge_r && prbs_found_1st_edge_r) begin
            // Both edges detected
              prbs_dec_tap_cnt 
                <=  #TCQ ((prbs_2nd_edge_taps_r -
                         prbs_1st_edge_taps_r)>>1) + 1 + pi_adj;  
              edge_det_error <= #TCQ edge_det_error? 1'b1: 
                                (prbs_1st_edge_taps_r >= prbs_2nd_edge_taps_r);
            end else if (~prbs_found_2nd_edge_r && prbs_found_1st_edge_r) begin
            // Only left edge detected 
              prbs_dec_tap_cnt 
                <=  #TCQ ((prbs_dqs_tap_cnt_r - prbs_1st_edge_taps_r)>>1) + pi_adj;  
            end else begin
            // No edges detected
              edge_det_error <= #TCQ 1'b1;
              prbs_dec_tap_cnt 
                <=  #TCQ (prbs_dqs_tap_cnt_r>>1) + pi_adj;  
            end
            // Now use the value we just calculated to decrement CPT taps
            // to the desired calibration point
            //wait finishing the read before PI dec to center
            prbs_state_r <= #TCQ RD_DONE_WAIT_FOR_PI_INC_DEC;
          end
        end
        
        // decrement capture clock for final adjustment - center
        // capture clock in middle of data eye. This adjustment will occur
        // only when both the edges are found usign CPT taps. Must do this
        // incrementally to avoid clock glitching (since CPT drives clock
        // divider within each ISERDES)
        PRBS_DEC_DQS: begin
          prbs_tap_en_r  <= #TCQ 1'b1;
          prbs_tap_inc_r <= #TCQ 1'b0;
          // once adjustment is complete, we're done with calibration for
          // this DQS, repeat for next DQS
          if (prbs_dec_tap_cnt > 'd0)
            prbs_dec_tap_cnt <= #TCQ prbs_dec_tap_cnt - 1;
          if (prbs_dec_tap_cnt == 6'b000001) begin
            prbs_state_r <= #TCQ PRBS_NEXT_DQS;
            //only all DEC is done, incdec done is asserted  
            complex_pi_incdec_done <= #TCQ 1'b1;   
          end else
            prbs_state_r <= #TCQ PRBS_DEC_DQS_WAIT;
        end

        PRBS_DEC_DQS_WAIT: begin
          prbs_tap_en_r  <= #TCQ 1'b0;
          prbs_tap_inc_r <= #TCQ 1'b0;
          if (cnt_wait_state) begin
            if (prbs_dec_tap_cnt > 'd0)
              prbs_state_r <= #TCQ PRBS_DEC_DQS;
            else begin 
              //PI movement is done, go to read and compare
              complex_pi_incdec_done <= #TCQ 1'b1;
              prbs_state_r <= #TCQ PRBS_PAT_COMPARE;
            end
          end
        end

        // Determine whether we're done, or have more DQS's to calibrate
        // Also request precharge after every byte, as appropriate
        PRBS_NEXT_DQS: begin
          //Need to do initial dec for per-bit algorithm
          complex_init_pi_dec_done_r <= #TCQ 1'b0;
          reset_rd_addr <= #TCQ 'b1;  
          prbs_prech_req_r  <= #TCQ 1'b1;
          prbs_tap_en_r  <= #TCQ 1'b0;
          prbs_tap_inc_r <= #TCQ 1'b0;
          // Prepare for another iteration with next DQS group
          prbs_found_1st_edge_r <= #TCQ 1'b0;
          prbs_found_2nd_edge_r <= #TCQ 1'b0;
          prbs_1st_edge_taps_r  <= #TCQ 'd0;
          prbs_2nd_edge_taps_r  <= #TCQ 'd0;
          largest_left_edge       <= #TCQ 6'b000000;
          smallest_right_edge     <= #TCQ 6'b111111;
          if (prbs_dqs_cnt_r >= DQS_WIDTH-1) begin
            prbs_last_byte_done <= #TCQ 1'b1;
          end
           
          // Wait until precharge that occurs in between calibration of
          // DQS groups is finished
          if (prech_done) begin
            prbs_prech_req_r <= #TCQ 1'b0;
            if (prbs_dqs_cnt_r >= DQS_WIDTH-1) begin
              // All DQS groups done
              prbs_state_r <= #TCQ PRBS_DONE;
            end else begin
              // Process next DQS group
              new_cnt_dqs_r  <= #TCQ 1'b1;
              prbs_dqs_cnt_r <= #TCQ prbs_dqs_cnt_r + 1;
              prbs_state_r   <= #TCQ PRBS_NEW_DQS_PREWAIT;
            end
          end
        end
        
        PRBS_NEW_DQS_PREWAIT: begin
          if (cnt_wait_state) begin
            prbs_state_r <= #TCQ PRBS_NEW_DQS_WAIT;
            fine_pi_dec_cnt <= #TCQ pi_counter_read_val;//.
          end
        end
       
        PRBS_CALC_TAPS_PRE:
        begin
          //Wait for new PI movement
          complex_pi_incdec_done <= #TCQ 1'b0;
          prbs_state_r <= #TCQ fine_calib? PRBS_NEXT_DQS:PRBS_CALC_TAPS_WAIT;
          if(center_comp && ~fine_calib) begin
            if(prbs_found_1st_edge_r) largest_left_edge <= #TCQ prbs_1st_edge_taps_r;
            else largest_left_edge <= #TCQ 6'd0;
            if(prbs_found_2nd_edge_r) smallest_right_edge <= #TCQ prbs_2nd_edge_taps_r;
            else smallest_right_edge <= #TCQ 6'd63;
          end
        end

       //wait for center compensation
        PRBS_CALC_TAPS_WAIT:
        begin
          prbs_state_r <= #TCQ PRBS_CALC_TAPS;
        end
        //if it is fine_inc stage (first/second stage): dec to 0
        //if it is fine_dec stage (third stage): dec to center
        FINE_PI_DEC: begin
          fine_delay_sel <= #TCQ 'b0; 
          if(fine_pi_dec_cnt > 0) begin
            prbs_tap_en_r  <= #TCQ 1'b1;
            prbs_tap_inc_r <= #TCQ 1'b0;
            fine_pi_dec_cnt <= #TCQ fine_pi_dec_cnt - 'd1;
          end
          prbs_state_r <= #TCQ FINE_PI_DEC_WAIT;
        end
        //wait for phaser_in tap decrement. 
        //if first/second stage is done, goes to FINE_PI_INC
        //if last stage is done, goes to NEXT_DQS
        //All PI DEC is done, incdec done is asserted
        FINE_PI_DEC_WAIT: begin
          prbs_tap_en_r  <= #TCQ 1'b0;
          prbs_tap_inc_r <= #TCQ 1'b0;
          if(cnt_wait_state) begin
            if(fine_pi_dec_cnt >0)
              prbs_state_r <= #TCQ FINE_PI_DEC;
            else begin 
              complex_pi_incdec_done <= #TCQ 1'b1;
              if(fine_inc_stage)
                prbs_state_r <= #TCQ FINE_PAT_COMPARE_PER_BIT;   //start from pi tap "0"
              else 
                prbs_state_r <= #TCQ PRBS_CALC_TAPS_PRE;  //finish the process and go to the next DQS
            end
          end
        end
           
        //finish the read before PI increament
        RD_DONE_WAIT_FOR_PI_INC_INC: begin
          if(complex_act_start)
            prbs_state_r <= #TCQ fine_calib? FINE_PI_INC: PRBS_INC_DQS;
        end
          
        FINE_PI_INC: begin
          //prevent left edge update after valid window found
          if(|left_edge_updated && ~no_err_win_detected_latch) largest_left_edge <= #TCQ prbs_dqs_tap_cnt_r- (MIN_WIN-1); 
          
          if (no_err_win_detected) begin
          //ignore previous right edge updated if valid window shown after
            right_edge_found <= #TCQ 'b0; 
          end else if(|right_edge_found_pb && ~right_edge_found) begin
            smallest_right_edge <= #TCQ prbs_dqs_tap_cnt_r -1 ;
            right_edge_found <= #TCQ 'b1;
          end 
          //until minimum window is detected, left edge can be updated
          //once minimum window is detected, no further left edge update will be done
          if(no_err_win_detected) no_err_win_detected_latch <= #TCQ 1'b1;
          prbs_state_r <= #TCQ FINE_PI_INC_WAIT;
          if(~prbs_dqs_tap_limit_r) begin
            prbs_tap_en_r    <= #TCQ 1'b1;
            prbs_tap_inc_r   <= #TCQ 1'b1;
          end
        end
       
        //wait for phase_in tap increment
        //need to do pattern compare for every bit
        FINE_PI_INC_WAIT: begin
          prbs_tap_en_r    <= #TCQ 1'b0;
          prbs_tap_inc_r   <= #TCQ 1'b0; 
          if (cnt_wait_state) begin
              prbs_state_r <= #TCQ FINE_PAT_COMPARE_PER_BIT;
              //PI movement is done, go to read and compare
              complex_pi_incdec_done <= #TCQ 1'b1;
          end
        end
        
        //compare per bit data and update flags,left/right edge
        FINE_PAT_COMPARE_PER_BIT: begin
          //comparision started - initial pi dec is done, wait for another pi movement after read
          complex_init_pi_dec_done_r <= #TCQ 1'b1;
          complex_pi_incdec_done <= #TCQ 1'b0;
          if(num_samples_done_r) begin  //sampling boundary
            //update and_flag - shift and add
            match_flag_and <= #TCQ {match_flag_and[MIN_WIN-2:0],compare_err_pb_and};
            match_flag_or  <= #TCQ {match_flag_or[MIN_WIN-2:0],compare_err_pb_or};

            //to solve false left/right edge detection
            if({match_flag_or[MIN_WIN-2:0],compare_err_pb_or} == MIN_PASS) begin  //if it detect minimum window
              no_err_win_detected <= #TCQ 1'b1;
              valid_window_cnt    <= #TCQ valid_window_cnt + 'd1;
            end else begin
              no_err_win_detected <= #TCQ 1'b0;
            end
            //if it is consecutive 8 passing taps followed by fail or tap limit (finish the search)
            //don't go to fine_FINE_CALC_TAPS to prevent to skip whole stage
            //Or if all right edge are found
            if((match_flag_and == MIN_PASS && compare_err_pb_and && (prbs_dqs_tap_cnt_r > MIN_WIN )) || prbs_dqs_tap_limit_r || (&right_edge_found_pb)) begin 
              prbs_state_r <= #TCQ FINE_CALC_TAPS; 
              //if all right edge are alined (all right edge found at the same time), update smallest right edge in here
              //doesnt need to set right_edge_found to 1 since it is not used after this stage
              if(!right_edge_found) smallest_right_edge <= #TCQ prbs_dqs_tap_cnt_r-1;                
            end else begin
              prbs_state_r <= #TCQ RD_DONE_WAIT_FOR_PI_INC_INC;  //keep increase until all fail 
            end
            num_samples_done_ind <= num_samples_done_r;
          end 
        end
        //for fine_inc stage, inc all fine delay
        //for fine_dec stage, apply dec fine delay for specific bits (by calculating the loss/gain)
        //                    put phaser_in taps to the center
        FINE_CALC_TAPS: begin
          if(num_samples_done_ind || num_samples_done_r) begin
            num_samples_done_ind <= #TCQ 'b0; //indicate num_samples_done_r is set 
            right_edge_found <= #TCQ 1'b0;  //reset right edge found
            match_flag_and <= #TCQ MATCH_ALL_ONE;   //reset match flag for all bits
            match_flag_or  <= #TCQ MATCH_ALL_ONE;   //reset match flag for all bits
            no_err_win_detected <= #TCQ 1'b0;
            no_err_win_detected_latch <= #TCQ 1'b0;
            prbs_state_r <= #TCQ FINE_CALC_TAPS_WAIT;
            valid_window_cnt <= #TCQ 2'd0;          //reset valid window counter
          end
        end

        FINE_CALC_TAPS_WAIT: begin  //wait for ROM read out
          if(stage_cnt == 'd2) begin  //last stage : back to center
            if(center_comp) begin
              fine_pi_dec_cnt <= #TCQ (dec_cnt[5]&dec_cnt[0])? 'd32: prbs_dqs_tap_cnt_r - smallest_right_edge + dec_cnt - 1 + pi_adj ;  //going to the center value & shift by 1
              fine_dly_error <= #TCQ (dec_cnt[5]&dec_cnt[0]) ? 1'b1: fine_dly_error;
            end else begin
              fine_pi_dec_cnt <= #TCQ prbs_dqs_tap_cnt_r - center_calc[6:1] - center_calc[0] + pi_adj;  //going to the center value & shift left by 1
              fine_dly_error <= #TCQ 1'b0;
            end
          end else begin
            fine_pi_dec_cnt <= #TCQ prbs_dqs_tap_cnt_r; 
          end
          if (bit_cnt == DRAM_WIDTH) begin
            fine_delay_sel <= #TCQ 'b1;
            stage_cnt <= #TCQ stage_cnt + 1;
            prbs_state_r <= #TCQ RD_DONE_WAIT_FOR_PI_INC_DEC;
          end

        end
        
        //wait for finishing the read before PI movement
        RD_DONE_WAIT_FOR_PI_INC_DEC: begin
          if (complex_act_start & ~complex_rdlvl_err) 
            prbs_state_r <= #TCQ fine_calib? FINE_PI_DEC: PRBS_DEC_DQS;
        end

        // Done with this stage of calibration
        PRBS_DONE: begin
          prbs_prech_req_r    <= #TCQ 1'b0;
          prbs_last_byte_done <= #TCQ 1'b0;
          prbs_rdlvl_done     <= #TCQ ~complex_rdlvl_err;
          reset_rd_addr       <= #TCQ 1'b0;
        end

      endcase
    end

  //ROM generation for dec counter
  always @ (largest_left_edge or smallest_right_edge) begin
    case ({largest_left_edge, smallest_right_edge})
      12'd0    :  mem_out_dec = 6'b111111;
      12'd1    :  mem_out_dec = 6'b111111;
      12'd2    :  mem_out_dec = 6'b111111;
      12'd3    :  mem_out_dec = 6'b111111;
      12'd4    :  mem_out_dec = 6'b111111;
      12'd5    :  mem_out_dec = 6'b111111;
      12'd6    :  mem_out_dec = 6'b000100;
      12'd7    :  mem_out_dec = 6'b000101;
      12'd8    :  mem_out_dec = 6'b000101;
      12'd9    :  mem_out_dec = 6'b000110;
      12'd10   :  mem_out_dec = 6'b000110;
      12'd11   :  mem_out_dec = 6'b000111;
      12'd12   :  mem_out_dec = 6'b001000;
      12'd13   :  mem_out_dec = 6'b001000;
      12'd14   :  mem_out_dec = 6'b001001;
      12'd15   :  mem_out_dec = 6'b001010;
      12'd16   :  mem_out_dec = 6'b001010;
      12'd17   :  mem_out_dec = 6'b001011;
      12'd18   :  mem_out_dec = 6'b001011;
      12'd19   :  mem_out_dec = 6'b001100;
      12'd20   :  mem_out_dec = 6'b001100;
      12'd21   :  mem_out_dec = 6'b001100;
      12'd22   :  mem_out_dec = 6'b001100;
      12'd23   :  mem_out_dec = 6'b001101;
      12'd24   :  mem_out_dec = 6'b001100;
      12'd25   :  mem_out_dec = 6'b001100;
      12'd26   :  mem_out_dec = 6'b001101;
      12'd27   :  mem_out_dec = 6'b001110;
      12'd28   :  mem_out_dec = 6'b001110;
      12'd29   :  mem_out_dec = 6'b001111;
      12'd30   :  mem_out_dec = 6'b010000;
      12'd31   :  mem_out_dec = 6'b010001;
      12'd32   :  mem_out_dec = 6'b010001;
      12'd33   :  mem_out_dec = 6'b010010;
      12'd34   :  mem_out_dec = 6'b010010;
      12'd35   :  mem_out_dec = 6'b010010;
      12'd36   :  mem_out_dec = 6'b010011;
      12'd37   :  mem_out_dec = 6'b010100;
      12'd38   :  mem_out_dec = 6'b010100;
      12'd39   :  mem_out_dec = 6'b010101;
      12'd40   :  mem_out_dec = 6'b010101;
      12'd41   :  mem_out_dec = 6'b010110;
      12'd42   :  mem_out_dec = 6'b010110;
      12'd43   :  mem_out_dec = 6'b010111;
      12'd44   :  mem_out_dec = 6'b011000;
      12'd45   :  mem_out_dec = 6'b011001;
      12'd46   :  mem_out_dec = 6'b011001;
      12'd47   :  mem_out_dec = 6'b011010;
      12'd48   :  mem_out_dec = 6'b011010;
      12'd49   :  mem_out_dec = 6'b011011;
      12'd50   :  mem_out_dec = 6'b011011;
      12'd51   :  mem_out_dec = 6'b011100;
      12'd52   :  mem_out_dec = 6'b011100;
      12'd53   :  mem_out_dec = 6'b011100;
      12'd54   :  mem_out_dec = 6'b011100;
      12'd55   :  mem_out_dec = 6'b011100;
      12'd56   :  mem_out_dec = 6'b011100;
      12'd57   :  mem_out_dec = 6'b011100;
      12'd58   :  mem_out_dec = 6'b011100;
      12'd59   :  mem_out_dec = 6'b011101;
      12'd60   :  mem_out_dec = 6'b011110;
      12'd61   :  mem_out_dec = 6'b011111;
      12'd62   :  mem_out_dec = 6'b100000;
      12'd63   :  mem_out_dec = 6'b100000;
      12'd64   :  mem_out_dec = 6'b111111;
      12'd65   :  mem_out_dec = 6'b111111;
      12'd66   :  mem_out_dec = 6'b111111;
      12'd67   :  mem_out_dec = 6'b111111;
      12'd68   :  mem_out_dec = 6'b111111;
      12'd69   :  mem_out_dec = 6'b111111;
      12'd70   :  mem_out_dec = 6'b111111;
      12'd71   :  mem_out_dec = 6'b000100;
      12'd72   :  mem_out_dec = 6'b000100;
      12'd73   :  mem_out_dec = 6'b000101;
      12'd74   :  mem_out_dec = 6'b000110;
      12'd75   :  mem_out_dec = 6'b000111;
      12'd76   :  mem_out_dec = 6'b000111;
      12'd77   :  mem_out_dec = 6'b001000;
      12'd78   :  mem_out_dec = 6'b001001;
      12'd79   :  mem_out_dec = 6'b001001;
      12'd80   :  mem_out_dec = 6'b001010;
      12'd81   :  mem_out_dec = 6'b001010;
      12'd82   :  mem_out_dec = 6'b001011;
      12'd83   :  mem_out_dec = 6'b001011;
      12'd84   :  mem_out_dec = 6'b001011;
      12'd85   :  mem_out_dec = 6'b001011;
      12'd86   :  mem_out_dec = 6'b001011;
      12'd87   :  mem_out_dec = 6'b001100;
      12'd88   :  mem_out_dec = 6'b001011;
      12'd89   :  mem_out_dec = 6'b001100;
      12'd90   :  mem_out_dec = 6'b001100;
      12'd91   :  mem_out_dec = 6'b001101;
      12'd92   :  mem_out_dec = 6'b001110;
      12'd93   :  mem_out_dec = 6'b001111;
      12'd94   :  mem_out_dec = 6'b001111;
      12'd95   :  mem_out_dec = 6'b010000;
      12'd96   :  mem_out_dec = 6'b010001;
      12'd97   :  mem_out_dec = 6'b010001;
      12'd98   :  mem_out_dec = 6'b010010;
      12'd99   :  mem_out_dec = 6'b010010;
      12'd100  :  mem_out_dec = 6'b010011;
      12'd101  :  mem_out_dec = 6'b010011;
      12'd102  :  mem_out_dec = 6'b010100;
      12'd103  :  mem_out_dec = 6'b010100;
      12'd104  :  mem_out_dec = 6'b010100;
      12'd105  :  mem_out_dec = 6'b010101;
      12'd106  :  mem_out_dec = 6'b010110;
      12'd107  :  mem_out_dec = 6'b010111;
      12'd108  :  mem_out_dec = 6'b010111;
      12'd109  :  mem_out_dec = 6'b011000;
      12'd110  :  mem_out_dec = 6'b011001;
      12'd111  :  mem_out_dec = 6'b011001;
      12'd112  :  mem_out_dec = 6'b011010;
      12'd113  :  mem_out_dec = 6'b011010;
      12'd114  :  mem_out_dec = 6'b011011;
      12'd115  :  mem_out_dec = 6'b011011;
      12'd116  :  mem_out_dec = 6'b011011;
      12'd117  :  mem_out_dec = 6'b011011;
      12'd118  :  mem_out_dec = 6'b011011;
      12'd119  :  mem_out_dec = 6'b011011;
      12'd120  :  mem_out_dec = 6'b011011;
      12'd121  :  mem_out_dec = 6'b011011;
      12'd122  :  mem_out_dec = 6'b011100;
      12'd123  :  mem_out_dec = 6'b011101;
      12'd124  :  mem_out_dec = 6'b011110;
      12'd125  :  mem_out_dec = 6'b011110;
      12'd126  :  mem_out_dec = 6'b011111;
      12'd127  :  mem_out_dec = 6'b100000;
      12'd128  :  mem_out_dec = 6'b111111;
      12'd129  :  mem_out_dec = 6'b111111;
      12'd130  :  mem_out_dec = 6'b111111;
      12'd131  :  mem_out_dec = 6'b111111;
      12'd132  :  mem_out_dec = 6'b111111;
      12'd133  :  mem_out_dec = 6'b111111;
      12'd134  :  mem_out_dec = 6'b111111;
      12'd135  :  mem_out_dec = 6'b111111;
      12'd136  :  mem_out_dec = 6'b000100;
      12'd137  :  mem_out_dec = 6'b000101;
      12'd138  :  mem_out_dec = 6'b000101;
      12'd139  :  mem_out_dec = 6'b000110;
      12'd140  :  mem_out_dec = 6'b000110;
      12'd141  :  mem_out_dec = 6'b000111;
      12'd142  :  mem_out_dec = 6'b001000;
      12'd143  :  mem_out_dec = 6'b001001;
      12'd144  :  mem_out_dec = 6'b001001;
      12'd145  :  mem_out_dec = 6'b001010;
      12'd146  :  mem_out_dec = 6'b001010;
      12'd147  :  mem_out_dec = 6'b001010;
      12'd148  :  mem_out_dec = 6'b001010;
      12'd149  :  mem_out_dec = 6'b001010;
      12'd150  :  mem_out_dec = 6'b001010;
      12'd151  :  mem_out_dec = 6'b001011;
      12'd152  :  mem_out_dec = 6'b001010;
      12'd153  :  mem_out_dec = 6'b001011;
      12'd154  :  mem_out_dec = 6'b001100;
      12'd155  :  mem_out_dec = 6'b001101;
      12'd156  :  mem_out_dec = 6'b001101;
      12'd157  :  mem_out_dec = 6'b001110;
      12'd158  :  mem_out_dec = 6'b001111;
      12'd159  :  mem_out_dec = 6'b010000;
      12'd160  :  mem_out_dec = 6'b010000;
      12'd161  :  mem_out_dec = 6'b010001;
      12'd162  :  mem_out_dec = 6'b010001;
      12'd163  :  mem_out_dec = 6'b010010;
      12'd164  :  mem_out_dec = 6'b010010;
      12'd165  :  mem_out_dec = 6'b010011;
      12'd166  :  mem_out_dec = 6'b010011;
      12'd167  :  mem_out_dec = 6'b010100;
      12'd168  :  mem_out_dec = 6'b010100;
      12'd169  :  mem_out_dec = 6'b010101;
      12'd170  :  mem_out_dec = 6'b010101;
      12'd171  :  mem_out_dec = 6'b010110;
      12'd172  :  mem_out_dec = 6'b010111;
      12'd173  :  mem_out_dec = 6'b010111;
      12'd174  :  mem_out_dec = 6'b011000;
      12'd175  :  mem_out_dec = 6'b011001;
      12'd176  :  mem_out_dec = 6'b011001;
      12'd177  :  mem_out_dec = 6'b011010;
      12'd178  :  mem_out_dec = 6'b011010;
      12'd179  :  mem_out_dec = 6'b011010;
      12'd180  :  mem_out_dec = 6'b011010;
      12'd181  :  mem_out_dec = 6'b011010;
      12'd182  :  mem_out_dec = 6'b011010;
      12'd183  :  mem_out_dec = 6'b011010;
      12'd184  :  mem_out_dec = 6'b011010;
      12'd185  :  mem_out_dec = 6'b011011;
      12'd186  :  mem_out_dec = 6'b011100;
      12'd187  :  mem_out_dec = 6'b011100;
      12'd188  :  mem_out_dec = 6'b011101;
      12'd189  :  mem_out_dec = 6'b011110;
      12'd190  :  mem_out_dec = 6'b011111;
      12'd191  :  mem_out_dec = 6'b100000;
      12'd192  :  mem_out_dec = 6'b111111;
      12'd193  :  mem_out_dec = 6'b111111;
      12'd194  :  mem_out_dec = 6'b111111;
      12'd195  :  mem_out_dec = 6'b111111;
      12'd196  :  mem_out_dec = 6'b111111;
      12'd197  :  mem_out_dec = 6'b111111;
      12'd198  :  mem_out_dec = 6'b111111;
      12'd199  :  mem_out_dec = 6'b111111;
      12'd200  :  mem_out_dec = 6'b111111;
      12'd201  :  mem_out_dec = 6'b000100;
      12'd202  :  mem_out_dec = 6'b000100;
      12'd203  :  mem_out_dec = 6'b000101;
      12'd204  :  mem_out_dec = 6'b000110;
      12'd205  :  mem_out_dec = 6'b000111;
      12'd206  :  mem_out_dec = 6'b001000;
      12'd207  :  mem_out_dec = 6'b001000;
      12'd208  :  mem_out_dec = 6'b001001;
      12'd209  :  mem_out_dec = 6'b001001;
      12'd210  :  mem_out_dec = 6'b001001;
      12'd211  :  mem_out_dec = 6'b001001;
      12'd212  :  mem_out_dec = 6'b001001;
      12'd213  :  mem_out_dec = 6'b001001;
      12'd214  :  mem_out_dec = 6'b001001;
      12'd215  :  mem_out_dec = 6'b001010;
      12'd216  :  mem_out_dec = 6'b001010;
      12'd217  :  mem_out_dec = 6'b001011;
      12'd218  :  mem_out_dec = 6'b001011;
      12'd219  :  mem_out_dec = 6'b001100;
      12'd220  :  mem_out_dec = 6'b001101;
      12'd221  :  mem_out_dec = 6'b001110;
      12'd222  :  mem_out_dec = 6'b001111;
      12'd223  :  mem_out_dec = 6'b001111;
      12'd224  :  mem_out_dec = 6'b010000;
      12'd225  :  mem_out_dec = 6'b010000;
      12'd226  :  mem_out_dec = 6'b010001;
      12'd227  :  mem_out_dec = 6'b010001;
      12'd228  :  mem_out_dec = 6'b010010;
      12'd229  :  mem_out_dec = 6'b010010;
      12'd230  :  mem_out_dec = 6'b010011;
      12'd231  :  mem_out_dec = 6'b010011;
      12'd232  :  mem_out_dec = 6'b010011;
      12'd233  :  mem_out_dec = 6'b010100;
      12'd234  :  mem_out_dec = 6'b010100;
      12'd235  :  mem_out_dec = 6'b010101;
      12'd236  :  mem_out_dec = 6'b010110;
      12'd237  :  mem_out_dec = 6'b010111;
      12'd238  :  mem_out_dec = 6'b011000;
      12'd239  :  mem_out_dec = 6'b011000;
      12'd240  :  mem_out_dec = 6'b011001;
      12'd241  :  mem_out_dec = 6'b011001;
      12'd242  :  mem_out_dec = 6'b011001;
      12'd243  :  mem_out_dec = 6'b011001;
      12'd244  :  mem_out_dec = 6'b011001;
      12'd245  :  mem_out_dec = 6'b011001;
      12'd246  :  mem_out_dec = 6'b011001;
      12'd247  :  mem_out_dec = 6'b011001;
      12'd248  :  mem_out_dec = 6'b011010;
      12'd249  :  mem_out_dec = 6'b011010;
      12'd250  :  mem_out_dec = 6'b011011;
      12'd251  :  mem_out_dec = 6'b011100;
      12'd252  :  mem_out_dec = 6'b011101;
      12'd253  :  mem_out_dec = 6'b011110;
      12'd254  :  mem_out_dec = 6'b011110;
      12'd255  :  mem_out_dec = 6'b011111;
      12'd256  :  mem_out_dec = 6'b111111;
      12'd257  :  mem_out_dec = 6'b111111;
      12'd258  :  mem_out_dec = 6'b111111;
      12'd259  :  mem_out_dec = 6'b111111;
      12'd260  :  mem_out_dec = 6'b111111;
      12'd261  :  mem_out_dec = 6'b111111;
      12'd262  :  mem_out_dec = 6'b111111;
      12'd263  :  mem_out_dec = 6'b111111;
      12'd264  :  mem_out_dec = 6'b111111;
      12'd265  :  mem_out_dec = 6'b111111;
      12'd266  :  mem_out_dec = 6'b000100;
      12'd267  :  mem_out_dec = 6'b000101;
      12'd268  :  mem_out_dec = 6'b000110;
      12'd269  :  mem_out_dec = 6'b000110;
      12'd270  :  mem_out_dec = 6'b000111;
      12'd271  :  mem_out_dec = 6'b001000;
      12'd272  :  mem_out_dec = 6'b001000;
      12'd273  :  mem_out_dec = 6'b001000;
      12'd274  :  mem_out_dec = 6'b001000;
      12'd275  :  mem_out_dec = 6'b001000;
      12'd276  :  mem_out_dec = 6'b001000;
      12'd277  :  mem_out_dec = 6'b001000;
      12'd278  :  mem_out_dec = 6'b001000;
      12'd279  :  mem_out_dec = 6'b001001;
      12'd280  :  mem_out_dec = 6'b001001;
      12'd281  :  mem_out_dec = 6'b001010;
      12'd282  :  mem_out_dec = 6'b001011;
      12'd283  :  mem_out_dec = 6'b001100;
      12'd284  :  mem_out_dec = 6'b001101;
      12'd285  :  mem_out_dec = 6'b001101;
      12'd286  :  mem_out_dec = 6'b001110;
      12'd287  :  mem_out_dec = 6'b001111;
      12'd288  :  mem_out_dec = 6'b001111;
      12'd289  :  mem_out_dec = 6'b010000;
      12'd290  :  mem_out_dec = 6'b010000;
      12'd291  :  mem_out_dec = 6'b010001;
      12'd292  :  mem_out_dec = 6'b010001;
      12'd293  :  mem_out_dec = 6'b010010;
      12'd294  :  mem_out_dec = 6'b010010;
      12'd295  :  mem_out_dec = 6'b010011;
      12'd296  :  mem_out_dec = 6'b010010;
      12'd297  :  mem_out_dec = 6'b010011;
      12'd298  :  mem_out_dec = 6'b010100;
      12'd299  :  mem_out_dec = 6'b010101;
      12'd300  :  mem_out_dec = 6'b010110;
      12'd301  :  mem_out_dec = 6'b010110;
      12'd302  :  mem_out_dec = 6'b010111;
      12'd303  :  mem_out_dec = 6'b011000;
      12'd304  :  mem_out_dec = 6'b011000;
      12'd305  :  mem_out_dec = 6'b011000;
      12'd306  :  mem_out_dec = 6'b011000;
      12'd307  :  mem_out_dec = 6'b011000;
      12'd308  :  mem_out_dec = 6'b011000;
      12'd309  :  mem_out_dec = 6'b011000;
      12'd310  :  mem_out_dec = 6'b011000;
      12'd311  :  mem_out_dec = 6'b011001;
      12'd312  :  mem_out_dec = 6'b011001;
      12'd313  :  mem_out_dec = 6'b011010;
      12'd314  :  mem_out_dec = 6'b011011;
      12'd315  :  mem_out_dec = 6'b011100;
      12'd316  :  mem_out_dec = 6'b011100;
      12'd317  :  mem_out_dec = 6'b011101;
      12'd318  :  mem_out_dec = 6'b011110;
      12'd319  :  mem_out_dec = 6'b011111;
      12'd320  :  mem_out_dec = 6'b111111;
      12'd321  :  mem_out_dec = 6'b111111;
      12'd322  :  mem_out_dec = 6'b111111;
      12'd323  :  mem_out_dec = 6'b111111;
      12'd324  :  mem_out_dec = 6'b111111;
      12'd325  :  mem_out_dec = 6'b111111;
      12'd326  :  mem_out_dec = 6'b111111;
      12'd327  :  mem_out_dec = 6'b111111;
      12'd328  :  mem_out_dec = 6'b111111;
      12'd329  :  mem_out_dec = 6'b111111;
      12'd330  :  mem_out_dec = 6'b111111;
      12'd331  :  mem_out_dec = 6'b000100;
      12'd332  :  mem_out_dec = 6'b000101;
      12'd333  :  mem_out_dec = 6'b000110;
      12'd334  :  mem_out_dec = 6'b000111;
      12'd335  :  mem_out_dec = 6'b001000;
      12'd336  :  mem_out_dec = 6'b000111;
      12'd337  :  mem_out_dec = 6'b000111;
      12'd338  :  mem_out_dec = 6'b000111;
      12'd339  :  mem_out_dec = 6'b000111;
      12'd340  :  mem_out_dec = 6'b000111;
      12'd341  :  mem_out_dec = 6'b000111;
      12'd342  :  mem_out_dec = 6'b001000;
      12'd343  :  mem_out_dec = 6'b001001;
      12'd344  :  mem_out_dec = 6'b001001;
      12'd345  :  mem_out_dec = 6'b001010;
      12'd346  :  mem_out_dec = 6'b001011;
      12'd347  :  mem_out_dec = 6'b001011;
      12'd348  :  mem_out_dec = 6'b001100;
      12'd349  :  mem_out_dec = 6'b001101;
      12'd350  :  mem_out_dec = 6'b001110;
      12'd351  :  mem_out_dec = 6'b001110;
      12'd352  :  mem_out_dec = 6'b001111;
      12'd353  :  mem_out_dec = 6'b001111;
      12'd354  :  mem_out_dec = 6'b010000;
      12'd355  :  mem_out_dec = 6'b010000;
      12'd356  :  mem_out_dec = 6'b010001;
      12'd357  :  mem_out_dec = 6'b010001;
      12'd358  :  mem_out_dec = 6'b010001;
      12'd359  :  mem_out_dec = 6'b010010;
      12'd360  :  mem_out_dec = 6'b010010;
      12'd361  :  mem_out_dec = 6'b010011;
      12'd362  :  mem_out_dec = 6'b010100;
      12'd363  :  mem_out_dec = 6'b010100;
      12'd364  :  mem_out_dec = 6'b010101;
      12'd365  :  mem_out_dec = 6'b010110;
      12'd366  :  mem_out_dec = 6'b010111;
      12'd367  :  mem_out_dec = 6'b011000;
      12'd368  :  mem_out_dec = 6'b010111;
      12'd369  :  mem_out_dec = 6'b010111;
      12'd370  :  mem_out_dec = 6'b010111;
      12'd371  :  mem_out_dec = 6'b010111;
      12'd372  :  mem_out_dec = 6'b010111;
      12'd373  :  mem_out_dec = 6'b010111;
      12'd374  :  mem_out_dec = 6'b011000;
      12'd375  :  mem_out_dec = 6'b011001;
      12'd376  :  mem_out_dec = 6'b011001;
      12'd377  :  mem_out_dec = 6'b011010;
      12'd378  :  mem_out_dec = 6'b011010;
      12'd379  :  mem_out_dec = 6'b011011;
      12'd380  :  mem_out_dec = 6'b011100;
      12'd381  :  mem_out_dec = 6'b011101;
      12'd382  :  mem_out_dec = 6'b011101;
      12'd383  :  mem_out_dec = 6'b011110;
      12'd384  :  mem_out_dec = 6'b111111;
      12'd385  :  mem_out_dec = 6'b111111;
      12'd386  :  mem_out_dec = 6'b111111;
      12'd387  :  mem_out_dec = 6'b111111;
      12'd388  :  mem_out_dec = 6'b111111;
      12'd389  :  mem_out_dec = 6'b111111;
      12'd390  :  mem_out_dec = 6'b111111;
      12'd391  :  mem_out_dec = 6'b111111;
      12'd392  :  mem_out_dec = 6'b111111;
      12'd393  :  mem_out_dec = 6'b111111;
      12'd394  :  mem_out_dec = 6'b111111;
      12'd395  :  mem_out_dec = 6'b111111;
      12'd396  :  mem_out_dec = 6'b000101;
      12'd397  :  mem_out_dec = 6'b000110;
      12'd398  :  mem_out_dec = 6'b000110;
      12'd399  :  mem_out_dec = 6'b000111;
      12'd400  :  mem_out_dec = 6'b000110;
      12'd401  :  mem_out_dec = 6'b000110;
      12'd402  :  mem_out_dec = 6'b000110;
      12'd403  :  mem_out_dec = 6'b000110;
      12'd404  :  mem_out_dec = 6'b000110;
      12'd405  :  mem_out_dec = 6'b000111;
      12'd406  :  mem_out_dec = 6'b001000;
      12'd407  :  mem_out_dec = 6'b001000;
      12'd408  :  mem_out_dec = 6'b001001;
      12'd409  :  mem_out_dec = 6'b001001;
      12'd410  :  mem_out_dec = 6'b001010;
      12'd411  :  mem_out_dec = 6'b001011;
      12'd412  :  mem_out_dec = 6'b001100;
      12'd413  :  mem_out_dec = 6'b001100;
      12'd414  :  mem_out_dec = 6'b001101;
      12'd415  :  mem_out_dec = 6'b001110;
      12'd416  :  mem_out_dec = 6'b001110;
      12'd417  :  mem_out_dec = 6'b001111;
      12'd418  :  mem_out_dec = 6'b001111;
      12'd419  :  mem_out_dec = 6'b010000;
      12'd420  :  mem_out_dec = 6'b010000;
      12'd421  :  mem_out_dec = 6'b010000;
      12'd422  :  mem_out_dec = 6'b010001;
      12'd423  :  mem_out_dec = 6'b010001;
      12'd424  :  mem_out_dec = 6'b010010;
      12'd425  :  mem_out_dec = 6'b010011;
      12'd426  :  mem_out_dec = 6'b010011;
      12'd427  :  mem_out_dec = 6'b010100;
      12'd428  :  mem_out_dec = 6'b010101;
      12'd429  :  mem_out_dec = 6'b010110;
      12'd430  :  mem_out_dec = 6'b010111;
      12'd431  :  mem_out_dec = 6'b010111;
      12'd432  :  mem_out_dec = 6'b010110;
      12'd433  :  mem_out_dec = 6'b010110;
      12'd434  :  mem_out_dec = 6'b010110;
      12'd435  :  mem_out_dec = 6'b010110;
      12'd436  :  mem_out_dec = 6'b010110;
      12'd437  :  mem_out_dec = 6'b010111;
      12'd438  :  mem_out_dec = 6'b010111;
      12'd439  :  mem_out_dec = 6'b011000;
      12'd440  :  mem_out_dec = 6'b011001;
      12'd441  :  mem_out_dec = 6'b011001;
      12'd442  :  mem_out_dec = 6'b011010;
      12'd443  :  mem_out_dec = 6'b011011;
      12'd444  :  mem_out_dec = 6'b011011;
      12'd445  :  mem_out_dec = 6'b011100;
      12'd446  :  mem_out_dec = 6'b011101;
      12'd447  :  mem_out_dec = 6'b011110;
      12'd448  :  mem_out_dec = 6'b111111;
      12'd449  :  mem_out_dec = 6'b111111;
      12'd450  :  mem_out_dec = 6'b111111;
      12'd451  :  mem_out_dec = 6'b111111;
      12'd452  :  mem_out_dec = 6'b111111;
      12'd453  :  mem_out_dec = 6'b111111;
      12'd454  :  mem_out_dec = 6'b111111;
      12'd455  :  mem_out_dec = 6'b111111;
      12'd456  :  mem_out_dec = 6'b111111;
      12'd457  :  mem_out_dec = 6'b111111;
      12'd458  :  mem_out_dec = 6'b111111;
      12'd459  :  mem_out_dec = 6'b111111;
      12'd460  :  mem_out_dec = 6'b111111;
      12'd461  :  mem_out_dec = 6'b000101;
      12'd462  :  mem_out_dec = 6'b000110;
      12'd463  :  mem_out_dec = 6'b000110;
      12'd464  :  mem_out_dec = 6'b000110;
      12'd465  :  mem_out_dec = 6'b000110;
      12'd466  :  mem_out_dec = 6'b000110;
      12'd467  :  mem_out_dec = 6'b000110;
      12'd468  :  mem_out_dec = 6'b000110;
      12'd469  :  mem_out_dec = 6'b000111;
      12'd470  :  mem_out_dec = 6'b000111;
      12'd471  :  mem_out_dec = 6'b001000;
      12'd472  :  mem_out_dec = 6'b001000;
      12'd473  :  mem_out_dec = 6'b001001;
      12'd474  :  mem_out_dec = 6'b001010;
      12'd475  :  mem_out_dec = 6'b001011;
      12'd476  :  mem_out_dec = 6'b001011;
      12'd477  :  mem_out_dec = 6'b001100;
      12'd478  :  mem_out_dec = 6'b001101;
      12'd479  :  mem_out_dec = 6'b001110;
      12'd480  :  mem_out_dec = 6'b001110;
      12'd481  :  mem_out_dec = 6'b001110;
      12'd482  :  mem_out_dec = 6'b001111;
      12'd483  :  mem_out_dec = 6'b001111;
      12'd484  :  mem_out_dec = 6'b010000;
      12'd485  :  mem_out_dec = 6'b010000;
      12'd486  :  mem_out_dec = 6'b010000;
      12'd487  :  mem_out_dec = 6'b010001;
      12'd488  :  mem_out_dec = 6'b010001;
      12'd489  :  mem_out_dec = 6'b010010;
      12'd490  :  mem_out_dec = 6'b010011;
      12'd491  :  mem_out_dec = 6'b010100;
      12'd492  :  mem_out_dec = 6'b010101;
      12'd493  :  mem_out_dec = 6'b010101;
      12'd494  :  mem_out_dec = 6'b010110;
      12'd495  :  mem_out_dec = 6'b010110;
      12'd496  :  mem_out_dec = 6'b010110;
      12'd497  :  mem_out_dec = 6'b010110;
      12'd498  :  mem_out_dec = 6'b010101;
      12'd499  :  mem_out_dec = 6'b010101;
      12'd500  :  mem_out_dec = 6'b010110;
      12'd501  :  mem_out_dec = 6'b010111;
      12'd502  :  mem_out_dec = 6'b010111;
      12'd503  :  mem_out_dec = 6'b011000;
      12'd504  :  mem_out_dec = 6'b011000;
      12'd505  :  mem_out_dec = 6'b011001;
      12'd506  :  mem_out_dec = 6'b011010;
      12'd507  :  mem_out_dec = 6'b011010;
      12'd508  :  mem_out_dec = 6'b011011;
      12'd509  :  mem_out_dec = 6'b011100;
      12'd510  :  mem_out_dec = 6'b011101;
      12'd511  :  mem_out_dec = 6'b011101;
      12'd512  :  mem_out_dec = 6'b111111;
      12'd513  :  mem_out_dec = 6'b111111;
      12'd514  :  mem_out_dec = 6'b111111;
      12'd515  :  mem_out_dec = 6'b111111;
      12'd516  :  mem_out_dec = 6'b111111;
      12'd517  :  mem_out_dec = 6'b111111;
      12'd518  :  mem_out_dec = 6'b111111;
      12'd519  :  mem_out_dec = 6'b111111;
      12'd520  :  mem_out_dec = 6'b111111;
      12'd521  :  mem_out_dec = 6'b111111;
      12'd522  :  mem_out_dec = 6'b111111;
      12'd523  :  mem_out_dec = 6'b111111;
      12'd524  :  mem_out_dec = 6'b111111;
      12'd525  :  mem_out_dec = 6'b111111;
      12'd526  :  mem_out_dec = 6'b000100;
      12'd527  :  mem_out_dec = 6'b000101;
      12'd528  :  mem_out_dec = 6'b000100;
      12'd529  :  mem_out_dec = 6'b000100;
      12'd530  :  mem_out_dec = 6'b000100;
      12'd531  :  mem_out_dec = 6'b000101;
      12'd532  :  mem_out_dec = 6'b000101;
      12'd533  :  mem_out_dec = 6'b000110;
      12'd534  :  mem_out_dec = 6'b000111;
      12'd535  :  mem_out_dec = 6'b000111;
      12'd536  :  mem_out_dec = 6'b000111;
      12'd537  :  mem_out_dec = 6'b001000;
      12'd538  :  mem_out_dec = 6'b001001;
      12'd539  :  mem_out_dec = 6'b001010;
      12'd540  :  mem_out_dec = 6'b001011;
      12'd541  :  mem_out_dec = 6'b001011;
      12'd542  :  mem_out_dec = 6'b001100;
      12'd543  :  mem_out_dec = 6'b001101;
      12'd544  :  mem_out_dec = 6'b001101;
      12'd545  :  mem_out_dec = 6'b001101;
      12'd546  :  mem_out_dec = 6'b001110;
      12'd547  :  mem_out_dec = 6'b001110;
      12'd548  :  mem_out_dec = 6'b001110;
      12'd549  :  mem_out_dec = 6'b001111;
      12'd550  :  mem_out_dec = 6'b010000;
      12'd551  :  mem_out_dec = 6'b010000;
      12'd552  :  mem_out_dec = 6'b010001;
      12'd553  :  mem_out_dec = 6'b010001;
      12'd554  :  mem_out_dec = 6'b010010;
      12'd555  :  mem_out_dec = 6'b010010;
      12'd556  :  mem_out_dec = 6'b010011;
      12'd557  :  mem_out_dec = 6'b010100;
      12'd558  :  mem_out_dec = 6'b010100;
      12'd559  :  mem_out_dec = 6'b010100;
      12'd560  :  mem_out_dec = 6'b010100;
      12'd561  :  mem_out_dec = 6'b010100;
      12'd562  :  mem_out_dec = 6'b010100;
      12'd563  :  mem_out_dec = 6'b010101;
      12'd564  :  mem_out_dec = 6'b010101;
      12'd565  :  mem_out_dec = 6'b010110;
      12'd566  :  mem_out_dec = 6'b010111;
      12'd567  :  mem_out_dec = 6'b010111;
      12'd568  :  mem_out_dec = 6'b010111;
      12'd569  :  mem_out_dec = 6'b011000;
      12'd570  :  mem_out_dec = 6'b011001;
      12'd571  :  mem_out_dec = 6'b011010;
      12'd572  :  mem_out_dec = 6'b011010;
      12'd573  :  mem_out_dec = 6'b011011;
      12'd574  :  mem_out_dec = 6'b011100;
      12'd575  :  mem_out_dec = 6'b011101;
      12'd576  :  mem_out_dec = 6'b111111;
      12'd577  :  mem_out_dec = 6'b111111;
      12'd578  :  mem_out_dec = 6'b111111;
      12'd579  :  mem_out_dec = 6'b111111;
      12'd580  :  mem_out_dec = 6'b111111;
      12'd581  :  mem_out_dec = 6'b111111;
      12'd582  :  mem_out_dec = 6'b111111;
      12'd583  :  mem_out_dec = 6'b111111;
      12'd584  :  mem_out_dec = 6'b111111;
      12'd585  :  mem_out_dec = 6'b111111;
      12'd586  :  mem_out_dec = 6'b111111;
      12'd587  :  mem_out_dec = 6'b111111;
      12'd588  :  mem_out_dec = 6'b111111;
      12'd589  :  mem_out_dec = 6'b111111;
      12'd590  :  mem_out_dec = 6'b111111;
      12'd591  :  mem_out_dec = 6'b000100;
      12'd592  :  mem_out_dec = 6'b000011;
      12'd593  :  mem_out_dec = 6'b000011;
      12'd594  :  mem_out_dec = 6'b000100;
      12'd595  :  mem_out_dec = 6'b000101;
      12'd596  :  mem_out_dec = 6'b000101;
      12'd597  :  mem_out_dec = 6'b000110;
      12'd598  :  mem_out_dec = 6'b000110;
      12'd599  :  mem_out_dec = 6'b000111;
      12'd600  :  mem_out_dec = 6'b000111;
      12'd601  :  mem_out_dec = 6'b001000;
      12'd602  :  mem_out_dec = 6'b001001;
      12'd603  :  mem_out_dec = 6'b001010;
      12'd604  :  mem_out_dec = 6'b001010;
      12'd605  :  mem_out_dec = 6'b001011;
      12'd606  :  mem_out_dec = 6'b001100;
      12'd607  :  mem_out_dec = 6'b001101;
      12'd608  :  mem_out_dec = 6'b001101;
      12'd609  :  mem_out_dec = 6'b001101;
      12'd610  :  mem_out_dec = 6'b001110;
      12'd611  :  mem_out_dec = 6'b001110;
      12'd612  :  mem_out_dec = 6'b001110;
      12'd613  :  mem_out_dec = 6'b001111;
      12'd614  :  mem_out_dec = 6'b010000;
      12'd615  :  mem_out_dec = 6'b010000;
      12'd616  :  mem_out_dec = 6'b010000;
      12'd617  :  mem_out_dec = 6'b010001;
      12'd618  :  mem_out_dec = 6'b010001;
      12'd619  :  mem_out_dec = 6'b010010;
      12'd620  :  mem_out_dec = 6'b010010;
      12'd621  :  mem_out_dec = 6'b010011;
      12'd622  :  mem_out_dec = 6'b010011;
      12'd623  :  mem_out_dec = 6'b010100;
      12'd624  :  mem_out_dec = 6'b010011;
      12'd625  :  mem_out_dec = 6'b010011;
      12'd626  :  mem_out_dec = 6'b010100;
      12'd627  :  mem_out_dec = 6'b010100;
      12'd628  :  mem_out_dec = 6'b010101;
      12'd629  :  mem_out_dec = 6'b010110;
      12'd630  :  mem_out_dec = 6'b010110;
      12'd631  :  mem_out_dec = 6'b010111;
      12'd632  :  mem_out_dec = 6'b010111;
      12'd633  :  mem_out_dec = 6'b011000;
      12'd634  :  mem_out_dec = 6'b011001;
      12'd635  :  mem_out_dec = 6'b011001;
      12'd636  :  mem_out_dec = 6'b011010;
      12'd637  :  mem_out_dec = 6'b011011;
      12'd638  :  mem_out_dec = 6'b011100;
      12'd639  :  mem_out_dec = 6'b011100;
      12'd640  :  mem_out_dec = 6'b111111;
      12'd641  :  mem_out_dec = 6'b111111;
      12'd642  :  mem_out_dec = 6'b111111;
      12'd643  :  mem_out_dec = 6'b111111;
      12'd644  :  mem_out_dec = 6'b111111;
      12'd645  :  mem_out_dec = 6'b111111;
      12'd646  :  mem_out_dec = 6'b111111;
      12'd647  :  mem_out_dec = 6'b111111;
      12'd648  :  mem_out_dec = 6'b111111;
      12'd649  :  mem_out_dec = 6'b111111;
      12'd650  :  mem_out_dec = 6'b111111;
      12'd651  :  mem_out_dec = 6'b111111;
      12'd652  :  mem_out_dec = 6'b111111;
      12'd653  :  mem_out_dec = 6'b111111;
      12'd654  :  mem_out_dec = 6'b111111;
      12'd655  :  mem_out_dec = 6'b111111;
      12'd656  :  mem_out_dec = 6'b000011;
      12'd657  :  mem_out_dec = 6'b000011;
      12'd658  :  mem_out_dec = 6'b000100;
      12'd659  :  mem_out_dec = 6'b000100;
      12'd660  :  mem_out_dec = 6'b000101;
      12'd661  :  mem_out_dec = 6'b000110;
      12'd662  :  mem_out_dec = 6'b000110;
      12'd663  :  mem_out_dec = 6'b000111;
      12'd664  :  mem_out_dec = 6'b000111;
      12'd665  :  mem_out_dec = 6'b001000;
      12'd666  :  mem_out_dec = 6'b001001;
      12'd667  :  mem_out_dec = 6'b001001;
      12'd668  :  mem_out_dec = 6'b001010;
      12'd669  :  mem_out_dec = 6'b001011;
      12'd670  :  mem_out_dec = 6'b001100;
      12'd671  :  mem_out_dec = 6'b001100;
      12'd672  :  mem_out_dec = 6'b001100;
      12'd673  :  mem_out_dec = 6'b001101;
      12'd674  :  mem_out_dec = 6'b001101;
      12'd675  :  mem_out_dec = 6'b001101;
      12'd676  :  mem_out_dec = 6'b001110;
      12'd677  :  mem_out_dec = 6'b001111;
      12'd678  :  mem_out_dec = 6'b001111;
      12'd679  :  mem_out_dec = 6'b010000;
      12'd680  :  mem_out_dec = 6'b010000;
      12'd681  :  mem_out_dec = 6'b010000;
      12'd682  :  mem_out_dec = 6'b010001;
      12'd683  :  mem_out_dec = 6'b010001;
      12'd684  :  mem_out_dec = 6'b010010;
      12'd685  :  mem_out_dec = 6'b010010;
      12'd686  :  mem_out_dec = 6'b010011;
      12'd687  :  mem_out_dec = 6'b010011;
      12'd688  :  mem_out_dec = 6'b010011;
      12'd689  :  mem_out_dec = 6'b010011;
      12'd690  :  mem_out_dec = 6'b010100;
      12'd691  :  mem_out_dec = 6'b010100;
      12'd692  :  mem_out_dec = 6'b010101;
      12'd693  :  mem_out_dec = 6'b010101;
      12'd694  :  mem_out_dec = 6'b010110;
      12'd695  :  mem_out_dec = 6'b010111;
      12'd696  :  mem_out_dec = 6'b010111;
      12'd697  :  mem_out_dec = 6'b011000;
      12'd698  :  mem_out_dec = 6'b011000;
      12'd699  :  mem_out_dec = 6'b011001;
      12'd700  :  mem_out_dec = 6'b011010;
      12'd701  :  mem_out_dec = 6'b011011;
      12'd702  :  mem_out_dec = 6'b011011;
      12'd703  :  mem_out_dec = 6'b011100;
      12'd704  :  mem_out_dec = 6'b111111;
      12'd705  :  mem_out_dec = 6'b111111;
      12'd706  :  mem_out_dec = 6'b111111;
      12'd707  :  mem_out_dec = 6'b111111;
      12'd708  :  mem_out_dec = 6'b111111;
      12'd709  :  mem_out_dec = 6'b111111;
      12'd710  :  mem_out_dec = 6'b111111;
      12'd711  :  mem_out_dec = 6'b111111;
      12'd712  :  mem_out_dec = 6'b111111;
      12'd713  :  mem_out_dec = 6'b111111;
      12'd714  :  mem_out_dec = 6'b111111;
      12'd715  :  mem_out_dec = 6'b111111;
      12'd716  :  mem_out_dec = 6'b111111;
      12'd717  :  mem_out_dec = 6'b111111;
      12'd718  :  mem_out_dec = 6'b111111;
      12'd719  :  mem_out_dec = 6'b111111;
      12'd720  :  mem_out_dec = 6'b111111;
      12'd721  :  mem_out_dec = 6'b000011;
      12'd722  :  mem_out_dec = 6'b000100;
      12'd723  :  mem_out_dec = 6'b000100;
      12'd724  :  mem_out_dec = 6'b000101;
      12'd725  :  mem_out_dec = 6'b000101;
      12'd726  :  mem_out_dec = 6'b000110;
      12'd727  :  mem_out_dec = 6'b000111;
      12'd728  :  mem_out_dec = 6'b000111;
      12'd729  :  mem_out_dec = 6'b000111;
      12'd730  :  mem_out_dec = 6'b001000;
      12'd731  :  mem_out_dec = 6'b001001;
      12'd732  :  mem_out_dec = 6'b001010;
      12'd733  :  mem_out_dec = 6'b001011;
      12'd734  :  mem_out_dec = 6'b001011;
      12'd735  :  mem_out_dec = 6'b001100;
      12'd736  :  mem_out_dec = 6'b001100;
      12'd737  :  mem_out_dec = 6'b001101;
      12'd738  :  mem_out_dec = 6'b001101;
      12'd739  :  mem_out_dec = 6'b001101;
      12'd740  :  mem_out_dec = 6'b001110;
      12'd741  :  mem_out_dec = 6'b001110;
      12'd742  :  mem_out_dec = 6'b001111;
      12'd743  :  mem_out_dec = 6'b010000;
      12'd744  :  mem_out_dec = 6'b001111;
      12'd745  :  mem_out_dec = 6'b010000;
      12'd746  :  mem_out_dec = 6'b010000;
      12'd747  :  mem_out_dec = 6'b010001;
      12'd748  :  mem_out_dec = 6'b010001;
      12'd749  :  mem_out_dec = 6'b010010;
      12'd750  :  mem_out_dec = 6'b010010;
      12'd751  :  mem_out_dec = 6'b010011;
      12'd752  :  mem_out_dec = 6'b010010;
      12'd753  :  mem_out_dec = 6'b010011;
      12'd754  :  mem_out_dec = 6'b010011;
      12'd755  :  mem_out_dec = 6'b010100;
      12'd756  :  mem_out_dec = 6'b010101;
      12'd757  :  mem_out_dec = 6'b010101;
      12'd758  :  mem_out_dec = 6'b010110;
      12'd759  :  mem_out_dec = 6'b010110;
      12'd760  :  mem_out_dec = 6'b010111;
      12'd761  :  mem_out_dec = 6'b010111;
      12'd762  :  mem_out_dec = 6'b011000;
      12'd763  :  mem_out_dec = 6'b011001;
      12'd764  :  mem_out_dec = 6'b011010;
      12'd765  :  mem_out_dec = 6'b011010;
      12'd766  :  mem_out_dec = 6'b011011;
      12'd767  :  mem_out_dec = 6'b011100;
      12'd768  :  mem_out_dec = 6'b111111;
      12'd769  :  mem_out_dec = 6'b111111;
      12'd770  :  mem_out_dec = 6'b111111;
      12'd771  :  mem_out_dec = 6'b111111;
      12'd772  :  mem_out_dec = 6'b111111;
      12'd773  :  mem_out_dec = 6'b111111;
      12'd774  :  mem_out_dec = 6'b111111;
      12'd775  :  mem_out_dec = 6'b111111;
      12'd776  :  mem_out_dec = 6'b111111;
      12'd777  :  mem_out_dec = 6'b111111;
      12'd778  :  mem_out_dec = 6'b111111;
      12'd779  :  mem_out_dec = 6'b111111;
      12'd780  :  mem_out_dec = 6'b111111;
      12'd781  :  mem_out_dec = 6'b111111;
      12'd782  :  mem_out_dec = 6'b111111;
      12'd783  :  mem_out_dec = 6'b111111;
      12'd784  :  mem_out_dec = 6'b111111;
      12'd785  :  mem_out_dec = 6'b111111;
      12'd786  :  mem_out_dec = 6'b000011;
      12'd787  :  mem_out_dec = 6'b000100;
      12'd788  :  mem_out_dec = 6'b000101;
      12'd789  :  mem_out_dec = 6'b000101;
      12'd790  :  mem_out_dec = 6'b000110;
      12'd791  :  mem_out_dec = 6'b000110;
      12'd792  :  mem_out_dec = 6'b000110;
      12'd793  :  mem_out_dec = 6'b000111;
      12'd794  :  mem_out_dec = 6'b001000;
      12'd795  :  mem_out_dec = 6'b001001;
      12'd796  :  mem_out_dec = 6'b001010;
      12'd797  :  mem_out_dec = 6'b001010;
      12'd798  :  mem_out_dec = 6'b001011;
      12'd799  :  mem_out_dec = 6'b001100;
      12'd800  :  mem_out_dec = 6'b001100;
      12'd801  :  mem_out_dec = 6'b001100;
      12'd802  :  mem_out_dec = 6'b001101;
      12'd803  :  mem_out_dec = 6'b001101;
      12'd804  :  mem_out_dec = 6'b001110;
      12'd805  :  mem_out_dec = 6'b001110;
      12'd806  :  mem_out_dec = 6'b001111;
      12'd807  :  mem_out_dec = 6'b010000;
      12'd808  :  mem_out_dec = 6'b001111;
      12'd809  :  mem_out_dec = 6'b001111;
      12'd810  :  mem_out_dec = 6'b010000;
      12'd811  :  mem_out_dec = 6'b010000;
      12'd812  :  mem_out_dec = 6'b010001;
      12'd813  :  mem_out_dec = 6'b010001;
      12'd814  :  mem_out_dec = 6'b010010;
      12'd815  :  mem_out_dec = 6'b010010;
      12'd816  :  mem_out_dec = 6'b010010;
      12'd817  :  mem_out_dec = 6'b010011;
      12'd818  :  mem_out_dec = 6'b010011;
      12'd819  :  mem_out_dec = 6'b010100;
      12'd820  :  mem_out_dec = 6'b010100;
      12'd821  :  mem_out_dec = 6'b010101;
      12'd822  :  mem_out_dec = 6'b010110;
      12'd823  :  mem_out_dec = 6'b010110;
      12'd824  :  mem_out_dec = 6'b010110;
      12'd825  :  mem_out_dec = 6'b010111;
      12'd826  :  mem_out_dec = 6'b011000;
      12'd827  :  mem_out_dec = 6'b011001;
      12'd828  :  mem_out_dec = 6'b011001;
      12'd829  :  mem_out_dec = 6'b011010;
      12'd830  :  mem_out_dec = 6'b011011;
      12'd831  :  mem_out_dec = 6'b011100;
      12'd832  :  mem_out_dec = 6'b111111;
      12'd833  :  mem_out_dec = 6'b111111;
      12'd834  :  mem_out_dec = 6'b111111;
      12'd835  :  mem_out_dec = 6'b111111;
      12'd836  :  mem_out_dec = 6'b111111;
      12'd837  :  mem_out_dec = 6'b111111;
      12'd838  :  mem_out_dec = 6'b111111;
      12'd839  :  mem_out_dec = 6'b111111;
      12'd840  :  mem_out_dec = 6'b111111;
      12'd841  :  mem_out_dec = 6'b111111;
      12'd842  :  mem_out_dec = 6'b111111;
      12'd843  :  mem_out_dec = 6'b111111;
      12'd844  :  mem_out_dec = 6'b111111;
      12'd845  :  mem_out_dec = 6'b111111;
      12'd846  :  mem_out_dec = 6'b111111;
      12'd847  :  mem_out_dec = 6'b111111;
      12'd848  :  mem_out_dec = 6'b111111;
      12'd849  :  mem_out_dec = 6'b111111;
      12'd850  :  mem_out_dec = 6'b111111;
      12'd851  :  mem_out_dec = 6'b000100;
      12'd852  :  mem_out_dec = 6'b000100;
      12'd853  :  mem_out_dec = 6'b000101;
      12'd854  :  mem_out_dec = 6'b000101;
      12'd855  :  mem_out_dec = 6'b000110;
      12'd856  :  mem_out_dec = 6'b000110;
      12'd857  :  mem_out_dec = 6'b000111;
      12'd858  :  mem_out_dec = 6'b001000;
      12'd859  :  mem_out_dec = 6'b001001;
      12'd860  :  mem_out_dec = 6'b001001;
      12'd861  :  mem_out_dec = 6'b001010;
      12'd862  :  mem_out_dec = 6'b001011;
      12'd863  :  mem_out_dec = 6'b001100;
      12'd864  :  mem_out_dec = 6'b001100;
      12'd865  :  mem_out_dec = 6'b001100;
      12'd866  :  mem_out_dec = 6'b001100;
      12'd867  :  mem_out_dec = 6'b001101;
      12'd868  :  mem_out_dec = 6'b001101;
      12'd869  :  mem_out_dec = 6'b001110;
      12'd870  :  mem_out_dec = 6'b001111;
      12'd871  :  mem_out_dec = 6'b001111;
      12'd872  :  mem_out_dec = 6'b001110;
      12'd873  :  mem_out_dec = 6'b001111;
      12'd874  :  mem_out_dec = 6'b001111;
      12'd875  :  mem_out_dec = 6'b010000;
      12'd876  :  mem_out_dec = 6'b010000;
      12'd877  :  mem_out_dec = 6'b010001;
      12'd878  :  mem_out_dec = 6'b010001;
      12'd879  :  mem_out_dec = 6'b010010;
      12'd880  :  mem_out_dec = 6'b010010;
      12'd881  :  mem_out_dec = 6'b010010;
      12'd882  :  mem_out_dec = 6'b010011;
      12'd883  :  mem_out_dec = 6'b010100;
      12'd884  :  mem_out_dec = 6'b010100;
      12'd885  :  mem_out_dec = 6'b010101;
      12'd886  :  mem_out_dec = 6'b010101;
      12'd887  :  mem_out_dec = 6'b010110;
      12'd888  :  mem_out_dec = 6'b010110;
      12'd889  :  mem_out_dec = 6'b010111;
      12'd890  :  mem_out_dec = 6'b011000;
      12'd891  :  mem_out_dec = 6'b011000;
      12'd892  :  mem_out_dec = 6'b011001;
      12'd893  :  mem_out_dec = 6'b011010;
      12'd894  :  mem_out_dec = 6'b011011;
      12'd895  :  mem_out_dec = 6'b011011;
      12'd896  :  mem_out_dec = 6'b111111;
      12'd897  :  mem_out_dec = 6'b111111;
      12'd898  :  mem_out_dec = 6'b111111;
      12'd899  :  mem_out_dec = 6'b111111;
      12'd900  :  mem_out_dec = 6'b111111;
      12'd901  :  mem_out_dec = 6'b111111;
      12'd902  :  mem_out_dec = 6'b111111;
      12'd903  :  mem_out_dec = 6'b111111;
      12'd904  :  mem_out_dec = 6'b111111;
      12'd905  :  mem_out_dec = 6'b111111;
      12'd906  :  mem_out_dec = 6'b111111;
      12'd907  :  mem_out_dec = 6'b111111;
      12'd908  :  mem_out_dec = 6'b111111;
      12'd909  :  mem_out_dec = 6'b111111;
      12'd910  :  mem_out_dec = 6'b111111;
      12'd911  :  mem_out_dec = 6'b111111;
      12'd912  :  mem_out_dec = 6'b111111;
      12'd913  :  mem_out_dec = 6'b111111;
      12'd914  :  mem_out_dec = 6'b111111;
      12'd915  :  mem_out_dec = 6'b111111;
      12'd916  :  mem_out_dec = 6'b000100;
      12'd917  :  mem_out_dec = 6'b000101;
      12'd918  :  mem_out_dec = 6'b000101;
      12'd919  :  mem_out_dec = 6'b000110;
      12'd920  :  mem_out_dec = 6'b000110;
      12'd921  :  mem_out_dec = 6'b000111;
      12'd922  :  mem_out_dec = 6'b001000;
      12'd923  :  mem_out_dec = 6'b001000;
      12'd924  :  mem_out_dec = 6'b001001;
      12'd925  :  mem_out_dec = 6'b001010;
      12'd926  :  mem_out_dec = 6'b001011;
      12'd927  :  mem_out_dec = 6'b001011;
      12'd928  :  mem_out_dec = 6'b001011;
      12'd929  :  mem_out_dec = 6'b001100;
      12'd930  :  mem_out_dec = 6'b001100;
      12'd931  :  mem_out_dec = 6'b001101;
      12'd932  :  mem_out_dec = 6'b001101;
      12'd933  :  mem_out_dec = 6'b001110;
      12'd934  :  mem_out_dec = 6'b001110;
      12'd935  :  mem_out_dec = 6'b001111;
      12'd936  :  mem_out_dec = 6'b001110;
      12'd937  :  mem_out_dec = 6'b001110;
      12'd938  :  mem_out_dec = 6'b001111;
      12'd939  :  mem_out_dec = 6'b001111;
      12'd940  :  mem_out_dec = 6'b010000;
      12'd941  :  mem_out_dec = 6'b010000;
      12'd942  :  mem_out_dec = 6'b010001;
      12'd943  :  mem_out_dec = 6'b010001;
      12'd944  :  mem_out_dec = 6'b010010;
      12'd945  :  mem_out_dec = 6'b010010;
      12'd946  :  mem_out_dec = 6'b010011;
      12'd947  :  mem_out_dec = 6'b010011;
      12'd948  :  mem_out_dec = 6'b010100;
      12'd949  :  mem_out_dec = 6'b010100;
      12'd950  :  mem_out_dec = 6'b010101;
      12'd951  :  mem_out_dec = 6'b010110;
      12'd952  :  mem_out_dec = 6'b010110;
      12'd953  :  mem_out_dec = 6'b010111;
      12'd954  :  mem_out_dec = 6'b010111;
      12'd955  :  mem_out_dec = 6'b011000;
      12'd956  :  mem_out_dec = 6'b011001;
      12'd957  :  mem_out_dec = 6'b011010;
      12'd958  :  mem_out_dec = 6'b011010;
      12'd959  :  mem_out_dec = 6'b011011;
      12'd960  :  mem_out_dec = 6'b111111;
      12'd961  :  mem_out_dec = 6'b111111;
      12'd962  :  mem_out_dec = 6'b111111;
      12'd963  :  mem_out_dec = 6'b111111;
      12'd964  :  mem_out_dec = 6'b111111;
      12'd965  :  mem_out_dec = 6'b111111;
      12'd966  :  mem_out_dec = 6'b111111;
      12'd967  :  mem_out_dec = 6'b111111;
      12'd968  :  mem_out_dec = 6'b111111;
      12'd969  :  mem_out_dec = 6'b111111;
      12'd970  :  mem_out_dec = 6'b111111;
      12'd971  :  mem_out_dec = 6'b111111;
      12'd972  :  mem_out_dec = 6'b111111;
      12'd973  :  mem_out_dec = 6'b111111;
      12'd974  :  mem_out_dec = 6'b111111;
      12'd975  :  mem_out_dec = 6'b111111;
      12'd976  :  mem_out_dec = 6'b111111;
      12'd977  :  mem_out_dec = 6'b111111;
      12'd978  :  mem_out_dec = 6'b111111;
      12'd979  :  mem_out_dec = 6'b111111;
      12'd980  :  mem_out_dec = 6'b111111;
      12'd981  :  mem_out_dec = 6'b000100;
      12'd982  :  mem_out_dec = 6'b000101;
      12'd983  :  mem_out_dec = 6'b000110;
      12'd984  :  mem_out_dec = 6'b000110;
      12'd985  :  mem_out_dec = 6'b000111;
      12'd986  :  mem_out_dec = 6'b000111;
      12'd987  :  mem_out_dec = 6'b001000;
      12'd988  :  mem_out_dec = 6'b001001;
      12'd989  :  mem_out_dec = 6'b001010;
      12'd990  :  mem_out_dec = 6'b001010;
      12'd991  :  mem_out_dec = 6'b001011;
      12'd992  :  mem_out_dec = 6'b001011;
      12'd993  :  mem_out_dec = 6'b001011;
      12'd994  :  mem_out_dec = 6'b001100;
      12'd995  :  mem_out_dec = 6'b001100;
      12'd996  :  mem_out_dec = 6'b001101;
      12'd997  :  mem_out_dec = 6'b001110;
      12'd998  :  mem_out_dec = 6'b001110;
      12'd999  :  mem_out_dec = 6'b001110;
      12'd1000 :  mem_out_dec = 6'b001101;
      12'd1001 :  mem_out_dec = 6'b001110;
      12'd1002 :  mem_out_dec = 6'b001110;
      12'd1003 :  mem_out_dec = 6'b001111;
      12'd1004 :  mem_out_dec = 6'b001111;
      12'd1005 :  mem_out_dec = 6'b010000;
      12'd1006 :  mem_out_dec = 6'b010000;
      12'd1007 :  mem_out_dec = 6'b010001;
      12'd1008 :  mem_out_dec = 6'b010001;
      12'd1009 :  mem_out_dec = 6'b010010;
      12'd1010 :  mem_out_dec = 6'b010011;
      12'd1011 :  mem_out_dec = 6'b010011;
      12'd1012 :  mem_out_dec = 6'b010100;
      12'd1013 :  mem_out_dec = 6'b010100;
      12'd1014 :  mem_out_dec = 6'b010101;
      12'd1015 :  mem_out_dec = 6'b010110;
      12'd1016 :  mem_out_dec = 6'b010110;
      12'd1017 :  mem_out_dec = 6'b010110;
      12'd1018 :  mem_out_dec = 6'b010111;
      12'd1019 :  mem_out_dec = 6'b011000;
      12'd1020 :  mem_out_dec = 6'b011001;
      12'd1021 :  mem_out_dec = 6'b011001;
      12'd1022 :  mem_out_dec = 6'b011010;
      12'd1023 :  mem_out_dec = 6'b011011;
      12'd1024 :  mem_out_dec = 6'b111111;
      12'd1025 :  mem_out_dec = 6'b111111;
      12'd1026 :  mem_out_dec = 6'b111111;
      12'd1027 :  mem_out_dec = 6'b111111;
      12'd1028 :  mem_out_dec = 6'b111111;
      12'd1029 :  mem_out_dec = 6'b111111;
      12'd1030 :  mem_out_dec = 6'b111111;
      12'd1031 :  mem_out_dec = 6'b111111;
      12'd1032 :  mem_out_dec = 6'b111111;
      12'd1033 :  mem_out_dec = 6'b111111;
      12'd1034 :  mem_out_dec = 6'b111111;
      12'd1035 :  mem_out_dec = 6'b111111;
      12'd1036 :  mem_out_dec = 6'b111111;
      12'd1037 :  mem_out_dec = 6'b111111;
      12'd1038 :  mem_out_dec = 6'b111111;
      12'd1039 :  mem_out_dec = 6'b111111;
      12'd1040 :  mem_out_dec = 6'b111111;
      12'd1041 :  mem_out_dec = 6'b111111;
      12'd1042 :  mem_out_dec = 6'b111111;
      12'd1043 :  mem_out_dec = 6'b111111;
      12'd1044 :  mem_out_dec = 6'b111111;
      12'd1045 :  mem_out_dec = 6'b111111;
      12'd1046 :  mem_out_dec = 6'b000100;
      12'd1047 :  mem_out_dec = 6'b000101;
      12'd1048 :  mem_out_dec = 6'b000101;
      12'd1049 :  mem_out_dec = 6'b000110;
      12'd1050 :  mem_out_dec = 6'b000110;
      12'd1051 :  mem_out_dec = 6'b000111;
      12'd1052 :  mem_out_dec = 6'b001000;
      12'd1053 :  mem_out_dec = 6'b001001;
      12'd1054 :  mem_out_dec = 6'b001001;
      12'd1055 :  mem_out_dec = 6'b001010;
      12'd1056 :  mem_out_dec = 6'b001010;
      12'd1057 :  mem_out_dec = 6'b001011;
      12'd1058 :  mem_out_dec = 6'b001011;
      12'd1059 :  mem_out_dec = 6'b001100;
      12'd1060 :  mem_out_dec = 6'b001100;
      12'd1061 :  mem_out_dec = 6'b001100;
      12'd1062 :  mem_out_dec = 6'b001100;
      12'd1063 :  mem_out_dec = 6'b001100;
      12'd1064 :  mem_out_dec = 6'b001100;
      12'd1065 :  mem_out_dec = 6'b001100;
      12'd1066 :  mem_out_dec = 6'b001101;
      12'd1067 :  mem_out_dec = 6'b001101;
      12'd1068 :  mem_out_dec = 6'b001110;
      12'd1069 :  mem_out_dec = 6'b001111;
      12'd1070 :  mem_out_dec = 6'b010000;
      12'd1071 :  mem_out_dec = 6'b010000;
      12'd1072 :  mem_out_dec = 6'b010001;
      12'd1073 :  mem_out_dec = 6'b010001;
      12'd1074 :  mem_out_dec = 6'b010010;
      12'd1075 :  mem_out_dec = 6'b010010;
      12'd1076 :  mem_out_dec = 6'b010011;
      12'd1077 :  mem_out_dec = 6'b010011;
      12'd1078 :  mem_out_dec = 6'b010100;
      12'd1079 :  mem_out_dec = 6'b010101;
      12'd1080 :  mem_out_dec = 6'b010101;
      12'd1081 :  mem_out_dec = 6'b010110;
      12'd1082 :  mem_out_dec = 6'b010110;
      12'd1083 :  mem_out_dec = 6'b010111;
      12'd1084 :  mem_out_dec = 6'b011000;
      12'd1085 :  mem_out_dec = 6'b011000;
      12'd1086 :  mem_out_dec = 6'b011001;
      12'd1087 :  mem_out_dec = 6'b011010;
      12'd1088 :  mem_out_dec = 6'b111111;
      12'd1089 :  mem_out_dec = 6'b111111;
      12'd1090 :  mem_out_dec = 6'b111111;
      12'd1091 :  mem_out_dec = 6'b111111;
      12'd1092 :  mem_out_dec = 6'b111111;
      12'd1093 :  mem_out_dec = 6'b111111;
      12'd1094 :  mem_out_dec = 6'b111111;
      12'd1095 :  mem_out_dec = 6'b111111;
      12'd1096 :  mem_out_dec = 6'b111111;
      12'd1097 :  mem_out_dec = 6'b111111;
      12'd1098 :  mem_out_dec = 6'b111111;
      12'd1099 :  mem_out_dec = 6'b111111;
      12'd1100 :  mem_out_dec = 6'b111111;
      12'd1101 :  mem_out_dec = 6'b111111;
      12'd1102 :  mem_out_dec = 6'b111111;
      12'd1103 :  mem_out_dec = 6'b111111;
      12'd1104 :  mem_out_dec = 6'b111111;
      12'd1105 :  mem_out_dec = 6'b111111;
      12'd1106 :  mem_out_dec = 6'b111111;
      12'd1107 :  mem_out_dec = 6'b111111;
      12'd1108 :  mem_out_dec = 6'b111111;
      12'd1109 :  mem_out_dec = 6'b111111;
      12'd1110 :  mem_out_dec = 6'b111111;
      12'd1111 :  mem_out_dec = 6'b000100;
      12'd1112 :  mem_out_dec = 6'b000100;
      12'd1113 :  mem_out_dec = 6'b000101;
      12'd1114 :  mem_out_dec = 6'b000110;
      12'd1115 :  mem_out_dec = 6'b000111;
      12'd1116 :  mem_out_dec = 6'b000111;
      12'd1117 :  mem_out_dec = 6'b001000;
      12'd1118 :  mem_out_dec = 6'b001001;
      12'd1119 :  mem_out_dec = 6'b001001;
      12'd1120 :  mem_out_dec = 6'b001010;
      12'd1121 :  mem_out_dec = 6'b001010;
      12'd1122 :  mem_out_dec = 6'b001011;
      12'd1123 :  mem_out_dec = 6'b001011;
      12'd1124 :  mem_out_dec = 6'b001011;
      12'd1125 :  mem_out_dec = 6'b001011;
      12'd1126 :  mem_out_dec = 6'b001011;
      12'd1127 :  mem_out_dec = 6'b001011;
      12'd1128 :  mem_out_dec = 6'b001011;
      12'd1129 :  mem_out_dec = 6'b001011;
      12'd1130 :  mem_out_dec = 6'b001100;
      12'd1131 :  mem_out_dec = 6'b001101;
      12'd1132 :  mem_out_dec = 6'b001110;
      12'd1133 :  mem_out_dec = 6'b001110;
      12'd1134 :  mem_out_dec = 6'b001111;
      12'd1135 :  mem_out_dec = 6'b010000;
      12'd1136 :  mem_out_dec = 6'b010000;
      12'd1137 :  mem_out_dec = 6'b010001;
      12'd1138 :  mem_out_dec = 6'b010001;
      12'd1139 :  mem_out_dec = 6'b010010;
      12'd1140 :  mem_out_dec = 6'b010010;
      12'd1141 :  mem_out_dec = 6'b010011;
      12'd1142 :  mem_out_dec = 6'b010100;
      12'd1143 :  mem_out_dec = 6'b010100;
      12'd1144 :  mem_out_dec = 6'b010100;
      12'd1145 :  mem_out_dec = 6'b010101;
      12'd1146 :  mem_out_dec = 6'b010110;
      12'd1147 :  mem_out_dec = 6'b010110;
      12'd1148 :  mem_out_dec = 6'b010111;
      12'd1149 :  mem_out_dec = 6'b011000;
      12'd1150 :  mem_out_dec = 6'b011000;
      12'd1151 :  mem_out_dec = 6'b011001;
      12'd1152 :  mem_out_dec = 6'b111111;
      12'd1153 :  mem_out_dec = 6'b111111;
      12'd1154 :  mem_out_dec = 6'b111111;
      12'd1155 :  mem_out_dec = 6'b111111;
      12'd1156 :  mem_out_dec = 6'b111111;
      12'd1157 :  mem_out_dec = 6'b111111;
      12'd1158 :  mem_out_dec = 6'b111111;
      12'd1159 :  mem_out_dec = 6'b111111;
      12'd1160 :  mem_out_dec = 6'b111111;
      12'd1161 :  mem_out_dec = 6'b111111;
      12'd1162 :  mem_out_dec = 6'b111111;
      12'd1163 :  mem_out_dec = 6'b111111;
      12'd1164 :  mem_out_dec = 6'b111111;
      12'd1165 :  mem_out_dec = 6'b111111;
      12'd1166 :  mem_out_dec = 6'b111111;
      12'd1167 :  mem_out_dec = 6'b111111;
      12'd1168 :  mem_out_dec = 6'b111111;
      12'd1169 :  mem_out_dec = 6'b111111;
      12'd1170 :  mem_out_dec = 6'b111111;
      12'd1171 :  mem_out_dec = 6'b111111;
      12'd1172 :  mem_out_dec = 6'b111111;
      12'd1173 :  mem_out_dec = 6'b111111;
      12'd1174 :  mem_out_dec = 6'b111111;
      12'd1175 :  mem_out_dec = 6'b111111;
      12'd1176 :  mem_out_dec = 6'b000100;
      12'd1177 :  mem_out_dec = 6'b000101;
      12'd1178 :  mem_out_dec = 6'b000101;
      12'd1179 :  mem_out_dec = 6'b000110;
      12'd1180 :  mem_out_dec = 6'b000111;
      12'd1181 :  mem_out_dec = 6'b000111;
      12'd1182 :  mem_out_dec = 6'b001000;
      12'd1183 :  mem_out_dec = 6'b001001;
      12'd1184 :  mem_out_dec = 6'b001001;
      12'd1185 :  mem_out_dec = 6'b001010;
      12'd1186 :  mem_out_dec = 6'b001010;
      12'd1187 :  mem_out_dec = 6'b001010;
      12'd1188 :  mem_out_dec = 6'b001010;
      12'd1189 :  mem_out_dec = 6'b001010;
      12'd1190 :  mem_out_dec = 6'b001010;
      12'd1191 :  mem_out_dec = 6'b001010;
      12'd1192 :  mem_out_dec = 6'b001010;
      12'd1193 :  mem_out_dec = 6'b001011;
      12'd1194 :  mem_out_dec = 6'b001100;
      12'd1195 :  mem_out_dec = 6'b001100;
      12'd1196 :  mem_out_dec = 6'b001101;
      12'd1197 :  mem_out_dec = 6'b001110;
      12'd1198 :  mem_out_dec = 6'b001111;
      12'd1199 :  mem_out_dec = 6'b010000;
      12'd1200 :  mem_out_dec = 6'b010000;
      12'd1201 :  mem_out_dec = 6'b010000;
      12'd1202 :  mem_out_dec = 6'b010001;
      12'd1203 :  mem_out_dec = 6'b010001;
      12'd1204 :  mem_out_dec = 6'b010010;
      12'd1205 :  mem_out_dec = 6'b010011;
      12'd1206 :  mem_out_dec = 6'b010011;
      12'd1207 :  mem_out_dec = 6'b010100;
      12'd1208 :  mem_out_dec = 6'b010100;
      12'd1209 :  mem_out_dec = 6'b010100;
      12'd1210 :  mem_out_dec = 6'b010101;
      12'd1211 :  mem_out_dec = 6'b010110;
      12'd1212 :  mem_out_dec = 6'b010110;
      12'd1213 :  mem_out_dec = 6'b010111;
      12'd1214 :  mem_out_dec = 6'b011000;
      12'd1215 :  mem_out_dec = 6'b011001;
      12'd1216 :  mem_out_dec = 6'b111111;
      12'd1217 :  mem_out_dec = 6'b111111;
      12'd1218 :  mem_out_dec = 6'b111111;
      12'd1219 :  mem_out_dec = 6'b111111;
      12'd1220 :  mem_out_dec = 6'b111111;
      12'd1221 :  mem_out_dec = 6'b111111;
      12'd1222 :  mem_out_dec = 6'b111111;
      12'd1223 :  mem_out_dec = 6'b111111;
      12'd1224 :  mem_out_dec = 6'b111111;
      12'd1225 :  mem_out_dec = 6'b111111;
      12'd1226 :  mem_out_dec = 6'b111111;
      12'd1227 :  mem_out_dec = 6'b111111;
      12'd1228 :  mem_out_dec = 6'b111111;
      12'd1229 :  mem_out_dec = 6'b111111;
      12'd1230 :  mem_out_dec = 6'b111111;
      12'd1231 :  mem_out_dec = 6'b111111;
      12'd1232 :  mem_out_dec = 6'b111111;
      12'd1233 :  mem_out_dec = 6'b111111;
      12'd1234 :  mem_out_dec = 6'b111111;
      12'd1235 :  mem_out_dec = 6'b111111;
      12'd1236 :  mem_out_dec = 6'b111111;
      12'd1237 :  mem_out_dec = 6'b111111;
      12'd1238 :  mem_out_dec = 6'b111111;
      12'd1239 :  mem_out_dec = 6'b111111;
      12'd1240 :  mem_out_dec = 6'b111111;
      12'd1241 :  mem_out_dec = 6'b000100;
      12'd1242 :  mem_out_dec = 6'b000100;
      12'd1243 :  mem_out_dec = 6'b000101;
      12'd1244 :  mem_out_dec = 6'b000110;
      12'd1245 :  mem_out_dec = 6'b000111;
      12'd1246 :  mem_out_dec = 6'b001000;
      12'd1247 :  mem_out_dec = 6'b001000;
      12'd1248 :  mem_out_dec = 6'b001001;
      12'd1249 :  mem_out_dec = 6'b001001;
      12'd1250 :  mem_out_dec = 6'b001001;
      12'd1251 :  mem_out_dec = 6'b001001;
      12'd1252 :  mem_out_dec = 6'b001001;
      12'd1253 :  mem_out_dec = 6'b001001;
      12'd1254 :  mem_out_dec = 6'b001001;
      12'd1255 :  mem_out_dec = 6'b001001;
      12'd1256 :  mem_out_dec = 6'b001010;
      12'd1257 :  mem_out_dec = 6'b001010;
      12'd1258 :  mem_out_dec = 6'b001011;
      12'd1259 :  mem_out_dec = 6'b001100;
      12'd1260 :  mem_out_dec = 6'b001101;
      12'd1261 :  mem_out_dec = 6'b001110;
      12'd1262 :  mem_out_dec = 6'b001110;
      12'd1263 :  mem_out_dec = 6'b001111;
      12'd1264 :  mem_out_dec = 6'b001111;
      12'd1265 :  mem_out_dec = 6'b010000;
      12'd1266 :  mem_out_dec = 6'b010000;
      12'd1267 :  mem_out_dec = 6'b010001;
      12'd1268 :  mem_out_dec = 6'b010001;
      12'd1269 :  mem_out_dec = 6'b010010;
      12'd1270 :  mem_out_dec = 6'b010011;
      12'd1271 :  mem_out_dec = 6'b010011;
      12'd1272 :  mem_out_dec = 6'b010011;
      12'd1273 :  mem_out_dec = 6'b010100;
      12'd1274 :  mem_out_dec = 6'b010100;
      12'd1275 :  mem_out_dec = 6'b010101;
      12'd1276 :  mem_out_dec = 6'b010110;
      12'd1277 :  mem_out_dec = 6'b010111;
      12'd1278 :  mem_out_dec = 6'b011000;
      12'd1279 :  mem_out_dec = 6'b011000;
      12'd1280 :  mem_out_dec = 6'b111111;
      12'd1281 :  mem_out_dec = 6'b111111;
      12'd1282 :  mem_out_dec = 6'b111111;
      12'd1283 :  mem_out_dec = 6'b111111;
      12'd1284 :  mem_out_dec = 6'b111111;
      12'd1285 :  mem_out_dec = 6'b111111;
      12'd1286 :  mem_out_dec = 6'b111111;
      12'd1287 :  mem_out_dec = 6'b111111;
      12'd1288 :  mem_out_dec = 6'b111111;
      12'd1289 :  mem_out_dec = 6'b111111;
      12'd1290 :  mem_out_dec = 6'b111111;
      12'd1291 :  mem_out_dec = 6'b111111;
      12'd1292 :  mem_out_dec = 6'b111111;
      12'd1293 :  mem_out_dec = 6'b111111;
      12'd1294 :  mem_out_dec = 6'b111111;
      12'd1295 :  mem_out_dec = 6'b111111;
      12'd1296 :  mem_out_dec = 6'b111111;
      12'd1297 :  mem_out_dec = 6'b111111;
      12'd1298 :  mem_out_dec = 6'b111111;
      12'd1299 :  mem_out_dec = 6'b111111;
      12'd1300 :  mem_out_dec = 6'b111111;
      12'd1301 :  mem_out_dec = 6'b111111;
      12'd1302 :  mem_out_dec = 6'b111111;
      12'd1303 :  mem_out_dec = 6'b111111;
      12'd1304 :  mem_out_dec = 6'b111111;
      12'd1305 :  mem_out_dec = 6'b111111;
      12'd1306 :  mem_out_dec = 6'b000100;
      12'd1307 :  mem_out_dec = 6'b000101;
      12'd1308 :  mem_out_dec = 6'b000110;
      12'd1309 :  mem_out_dec = 6'b000110;
      12'd1310 :  mem_out_dec = 6'b000111;
      12'd1311 :  mem_out_dec = 6'b001000;
      12'd1312 :  mem_out_dec = 6'b001000;
      12'd1313 :  mem_out_dec = 6'b001000;
      12'd1314 :  mem_out_dec = 6'b001000;
      12'd1315 :  mem_out_dec = 6'b001000;
      12'd1316 :  mem_out_dec = 6'b001000;
      12'd1317 :  mem_out_dec = 6'b001000;
      12'd1318 :  mem_out_dec = 6'b001000;
      12'd1319 :  mem_out_dec = 6'b001001;
      12'd1320 :  mem_out_dec = 6'b001001;
      12'd1321 :  mem_out_dec = 6'b001010;
      12'd1322 :  mem_out_dec = 6'b001011;
      12'd1323 :  mem_out_dec = 6'b001100;
      12'd1324 :  mem_out_dec = 6'b001100;
      12'd1325 :  mem_out_dec = 6'b001101;
      12'd1326 :  mem_out_dec = 6'b001110;
      12'd1327 :  mem_out_dec = 6'b001111;
      12'd1328 :  mem_out_dec = 6'b001111;
      12'd1329 :  mem_out_dec = 6'b001111;
      12'd1330 :  mem_out_dec = 6'b010000;
      12'd1331 :  mem_out_dec = 6'b010000;
      12'd1332 :  mem_out_dec = 6'b010001;
      12'd1333 :  mem_out_dec = 6'b010001;
      12'd1334 :  mem_out_dec = 6'b010010;
      12'd1335 :  mem_out_dec = 6'b010011;
      12'd1336 :  mem_out_dec = 6'b010010;
      12'd1337 :  mem_out_dec = 6'b010011;
      12'd1338 :  mem_out_dec = 6'b010100;
      12'd1339 :  mem_out_dec = 6'b010101;
      12'd1340 :  mem_out_dec = 6'b010110;
      12'd1341 :  mem_out_dec = 6'b010110;
      12'd1342 :  mem_out_dec = 6'b010111;
      12'd1343 :  mem_out_dec = 6'b011000;
      12'd1344 :  mem_out_dec = 6'b111111;
      12'd1345 :  mem_out_dec = 6'b111111;
      12'd1346 :  mem_out_dec = 6'b111111;
      12'd1347 :  mem_out_dec = 6'b111111;
      12'd1348 :  mem_out_dec = 6'b111111;
      12'd1349 :  mem_out_dec = 6'b111111;
      12'd1350 :  mem_out_dec = 6'b111111;
      12'd1351 :  mem_out_dec = 6'b111111;
      12'd1352 :  mem_out_dec = 6'b111111;
      12'd1353 :  mem_out_dec = 6'b111111;
      12'd1354 :  mem_out_dec = 6'b111111;
      12'd1355 :  mem_out_dec = 6'b111111;
      12'd1356 :  mem_out_dec = 6'b111111;
      12'd1357 :  mem_out_dec = 6'b111111;
      12'd1358 :  mem_out_dec = 6'b111111;
      12'd1359 :  mem_out_dec = 6'b111111;
      12'd1360 :  mem_out_dec = 6'b111111;
      12'd1361 :  mem_out_dec = 6'b111111;
      12'd1362 :  mem_out_dec = 6'b111111;
      12'd1363 :  mem_out_dec = 6'b111111;
      12'd1364 :  mem_out_dec = 6'b111111;
      12'd1365 :  mem_out_dec = 6'b111111;
      12'd1366 :  mem_out_dec = 6'b111111;
      12'd1367 :  mem_out_dec = 6'b111111;
      12'd1368 :  mem_out_dec = 6'b111111;
      12'd1369 :  mem_out_dec = 6'b111111;
      12'd1370 :  mem_out_dec = 6'b111111;
      12'd1371 :  mem_out_dec = 6'b000101;
      12'd1372 :  mem_out_dec = 6'b000101;
      12'd1373 :  mem_out_dec = 6'b000110;
      12'd1374 :  mem_out_dec = 6'b000111;
      12'd1375 :  mem_out_dec = 6'b001000;
      12'd1376 :  mem_out_dec = 6'b000111;
      12'd1377 :  mem_out_dec = 6'b000111;
      12'd1378 :  mem_out_dec = 6'b000111;
      12'd1379 :  mem_out_dec = 6'b000111;
      12'd1380 :  mem_out_dec = 6'b000111;
      12'd1381 :  mem_out_dec = 6'b000111;
      12'd1382 :  mem_out_dec = 6'b001000;
      12'd1383 :  mem_out_dec = 6'b001001;
      12'd1384 :  mem_out_dec = 6'b001001;
      12'd1385 :  mem_out_dec = 6'b001010;
      12'd1386 :  mem_out_dec = 6'b001010;
      12'd1387 :  mem_out_dec = 6'b001011;
      12'd1388 :  mem_out_dec = 6'b001100;
      12'd1389 :  mem_out_dec = 6'b001101;
      12'd1390 :  mem_out_dec = 6'b001110;
      12'd1391 :  mem_out_dec = 6'b001110;
      12'd1392 :  mem_out_dec = 6'b001111;
      12'd1393 :  mem_out_dec = 6'b001111;
      12'd1394 :  mem_out_dec = 6'b010000;
      12'd1395 :  mem_out_dec = 6'b010000;
      12'd1396 :  mem_out_dec = 6'b010001;
      12'd1397 :  mem_out_dec = 6'b010001;
      12'd1398 :  mem_out_dec = 6'b010010;
      12'd1399 :  mem_out_dec = 6'b010010;
      12'd1400 :  mem_out_dec = 6'b010010;
      12'd1401 :  mem_out_dec = 6'b010011;
      12'd1402 :  mem_out_dec = 6'b010100;
      12'd1403 :  mem_out_dec = 6'b010100;
      12'd1404 :  mem_out_dec = 6'b010101;
      12'd1405 :  mem_out_dec = 6'b010110;
      12'd1406 :  mem_out_dec = 6'b010111;
      12'd1407 :  mem_out_dec = 6'b010111;
      12'd1408 :  mem_out_dec = 6'b111111;
      12'd1409 :  mem_out_dec = 6'b111111;
      12'd1410 :  mem_out_dec = 6'b111111;
      12'd1411 :  mem_out_dec = 6'b111111;
      12'd1412 :  mem_out_dec = 6'b111111;
      12'd1413 :  mem_out_dec = 6'b111111;
      12'd1414 :  mem_out_dec = 6'b111111;
      12'd1415 :  mem_out_dec = 6'b111111;
      12'd1416 :  mem_out_dec = 6'b111111;
      12'd1417 :  mem_out_dec = 6'b111111;
      12'd1418 :  mem_out_dec = 6'b111111;
      12'd1419 :  mem_out_dec = 6'b111111;
      12'd1420 :  mem_out_dec = 6'b111111;
      12'd1421 :  mem_out_dec = 6'b111111;
      12'd1422 :  mem_out_dec = 6'b111111;
      12'd1423 :  mem_out_dec = 6'b111111;
      12'd1424 :  mem_out_dec = 6'b111111;
      12'd1425 :  mem_out_dec = 6'b111111;
      12'd1426 :  mem_out_dec = 6'b111111;
      12'd1427 :  mem_out_dec = 6'b111111;
      12'd1428 :  mem_out_dec = 6'b111111;
      12'd1429 :  mem_out_dec = 6'b111111;
      12'd1430 :  mem_out_dec = 6'b111111;
      12'd1431 :  mem_out_dec = 6'b111111;
      12'd1432 :  mem_out_dec = 6'b111111;
      12'd1433 :  mem_out_dec = 6'b111111;
      12'd1434 :  mem_out_dec = 6'b111111;
      12'd1435 :  mem_out_dec = 6'b111111;
      12'd1436 :  mem_out_dec = 6'b000101;
      12'd1437 :  mem_out_dec = 6'b000110;
      12'd1438 :  mem_out_dec = 6'b000111;
      12'd1439 :  mem_out_dec = 6'b000111;
      12'd1440 :  mem_out_dec = 6'b000110;
      12'd1441 :  mem_out_dec = 6'b000110;
      12'd1442 :  mem_out_dec = 6'b000110;
      12'd1443 :  mem_out_dec = 6'b000110;
      12'd1444 :  mem_out_dec = 6'b000110;
      12'd1445 :  mem_out_dec = 6'b000111;
      12'd1446 :  mem_out_dec = 6'b000111;
      12'd1447 :  mem_out_dec = 6'b001000;
      12'd1448 :  mem_out_dec = 6'b001001;
      12'd1449 :  mem_out_dec = 6'b001001;
      12'd1450 :  mem_out_dec = 6'b001010;
      12'd1451 :  mem_out_dec = 6'b001011;
      12'd1452 :  mem_out_dec = 6'b001100;
      12'd1453 :  mem_out_dec = 6'b001100;
      12'd1454 :  mem_out_dec = 6'b001101;
      12'd1455 :  mem_out_dec = 6'b001110;
      12'd1456 :  mem_out_dec = 6'b001110;
      12'd1457 :  mem_out_dec = 6'b001111;
      12'd1458 :  mem_out_dec = 6'b001111;
      12'd1459 :  mem_out_dec = 6'b010000;
      12'd1460 :  mem_out_dec = 6'b010000;
      12'd1461 :  mem_out_dec = 6'b010001;
      12'd1462 :  mem_out_dec = 6'b010001;
      12'd1463 :  mem_out_dec = 6'b010010;
      12'd1464 :  mem_out_dec = 6'b010010;
      12'd1465 :  mem_out_dec = 6'b010011;
      12'd1466 :  mem_out_dec = 6'b010011;
      12'd1467 :  mem_out_dec = 6'b010100;
      12'd1468 :  mem_out_dec = 6'b010101;
      12'd1469 :  mem_out_dec = 6'b010110;
      12'd1470 :  mem_out_dec = 6'b010110;
      12'd1471 :  mem_out_dec = 6'b010111;
      12'd1472 :  mem_out_dec = 6'b111111;
      12'd1473 :  mem_out_dec = 6'b111111;
      12'd1474 :  mem_out_dec = 6'b111111;
      12'd1475 :  mem_out_dec = 6'b111111;
      12'd1476 :  mem_out_dec = 6'b111111;
      12'd1477 :  mem_out_dec = 6'b111111;
      12'd1478 :  mem_out_dec = 6'b111111;
      12'd1479 :  mem_out_dec = 6'b111111;
      12'd1480 :  mem_out_dec = 6'b111111;
      12'd1481 :  mem_out_dec = 6'b111111;
      12'd1482 :  mem_out_dec = 6'b111111;
      12'd1483 :  mem_out_dec = 6'b111111;
      12'd1484 :  mem_out_dec = 6'b111111;
      12'd1485 :  mem_out_dec = 6'b111111;
      12'd1486 :  mem_out_dec = 6'b111111;
      12'd1487 :  mem_out_dec = 6'b111111;
      12'd1488 :  mem_out_dec = 6'b111111;
      12'd1489 :  mem_out_dec = 6'b111111;
      12'd1490 :  mem_out_dec = 6'b111111;
      12'd1491 :  mem_out_dec = 6'b111111;
      12'd1492 :  mem_out_dec = 6'b111111;
      12'd1493 :  mem_out_dec = 6'b111111;
      12'd1494 :  mem_out_dec = 6'b111111;
      12'd1495 :  mem_out_dec = 6'b111111;
      12'd1496 :  mem_out_dec = 6'b111111;
      12'd1497 :  mem_out_dec = 6'b111111;
      12'd1498 :  mem_out_dec = 6'b111111;
      12'd1499 :  mem_out_dec = 6'b111111;
      12'd1500 :  mem_out_dec = 6'b111111;
      12'd1501 :  mem_out_dec = 6'b000101;
      12'd1502 :  mem_out_dec = 6'b000110;
      12'd1503 :  mem_out_dec = 6'b000110;
      12'd1504 :  mem_out_dec = 6'b000110;
      12'd1505 :  mem_out_dec = 6'b000110;
      12'd1506 :  mem_out_dec = 6'b000101;
      12'd1507 :  mem_out_dec = 6'b000101;
      12'd1508 :  mem_out_dec = 6'b000110;
      12'd1509 :  mem_out_dec = 6'b000111;
      12'd1510 :  mem_out_dec = 6'b000111;
      12'd1511 :  mem_out_dec = 6'b001000;
      12'd1512 :  mem_out_dec = 6'b001000;
      12'd1513 :  mem_out_dec = 6'b001001;
      12'd1514 :  mem_out_dec = 6'b001010;
      12'd1515 :  mem_out_dec = 6'b001011;
      12'd1516 :  mem_out_dec = 6'b001011;
      12'd1517 :  mem_out_dec = 6'b001100;
      12'd1518 :  mem_out_dec = 6'b001101;
      12'd1519 :  mem_out_dec = 6'b001110;
      12'd1520 :  mem_out_dec = 6'b001110;
      12'd1521 :  mem_out_dec = 6'b001110;
      12'd1522 :  mem_out_dec = 6'b001111;
      12'd1523 :  mem_out_dec = 6'b001111;
      12'd1524 :  mem_out_dec = 6'b010000;
      12'd1525 :  mem_out_dec = 6'b010000;
      12'd1526 :  mem_out_dec = 6'b010001;
      12'd1527 :  mem_out_dec = 6'b010001;
      12'd1528 :  mem_out_dec = 6'b010001;
      12'd1529 :  mem_out_dec = 6'b010010;
      12'd1530 :  mem_out_dec = 6'b010011;
      12'd1531 :  mem_out_dec = 6'b010100;
      12'd1532 :  mem_out_dec = 6'b010101;
      12'd1533 :  mem_out_dec = 6'b010101;
      12'd1534 :  mem_out_dec = 6'b010110;
      12'd1535 :  mem_out_dec = 6'b010110;
      12'd1536 :  mem_out_dec = 6'b111111;
      12'd1537 :  mem_out_dec = 6'b111111;
      12'd1538 :  mem_out_dec = 6'b111111;
      12'd1539 :  mem_out_dec = 6'b111111;
      12'd1540 :  mem_out_dec = 6'b111111;
      12'd1541 :  mem_out_dec = 6'b111111;
      12'd1542 :  mem_out_dec = 6'b111111;
      12'd1543 :  mem_out_dec = 6'b111111;
      12'd1544 :  mem_out_dec = 6'b111111;
      12'd1545 :  mem_out_dec = 6'b111111;
      12'd1546 :  mem_out_dec = 6'b111111;
      12'd1547 :  mem_out_dec = 6'b111111;
      12'd1548 :  mem_out_dec = 6'b111111;
      12'd1549 :  mem_out_dec = 6'b111111;
      12'd1550 :  mem_out_dec = 6'b111111;
      12'd1551 :  mem_out_dec = 6'b111111;
      12'd1552 :  mem_out_dec = 6'b111111;
      12'd1553 :  mem_out_dec = 6'b111111;
      12'd1554 :  mem_out_dec = 6'b111111;
      12'd1555 :  mem_out_dec = 6'b111111;
      12'd1556 :  mem_out_dec = 6'b111111;
      12'd1557 :  mem_out_dec = 6'b111111;
      12'd1558 :  mem_out_dec = 6'b111111;
      12'd1559 :  mem_out_dec = 6'b111111;
      12'd1560 :  mem_out_dec = 6'b111111;
      12'd1561 :  mem_out_dec = 6'b111111;
      12'd1562 :  mem_out_dec = 6'b111111;
      12'd1563 :  mem_out_dec = 6'b111111;
      12'd1564 :  mem_out_dec = 6'b111111;
      12'd1565 :  mem_out_dec = 6'b111111;
      12'd1566 :  mem_out_dec = 6'b000100;
      12'd1567 :  mem_out_dec = 6'b000100;
      12'd1568 :  mem_out_dec = 6'b000100;
      12'd1569 :  mem_out_dec = 6'b000100;
      12'd1570 :  mem_out_dec = 6'b000100;
      12'd1571 :  mem_out_dec = 6'b000101;
      12'd1572 :  mem_out_dec = 6'b000101;
      12'd1573 :  mem_out_dec = 6'b000110;
      12'd1574 :  mem_out_dec = 6'b000111;
      12'd1575 :  mem_out_dec = 6'b000111;
      12'd1576 :  mem_out_dec = 6'b000111;
      12'd1577 :  mem_out_dec = 6'b001000;
      12'd1578 :  mem_out_dec = 6'b001001;
      12'd1579 :  mem_out_dec = 6'b001010;
      12'd1580 :  mem_out_dec = 6'b001010;
      12'd1581 :  mem_out_dec = 6'b001011;
      12'd1582 :  mem_out_dec = 6'b001100;
      12'd1583 :  mem_out_dec = 6'b001101;
      12'd1584 :  mem_out_dec = 6'b001101;
      12'd1585 :  mem_out_dec = 6'b001101;
      12'd1586 :  mem_out_dec = 6'b001110;
      12'd1587 :  mem_out_dec = 6'b001110;
      12'd1588 :  mem_out_dec = 6'b001111;
      12'd1589 :  mem_out_dec = 6'b001111;
      12'd1590 :  mem_out_dec = 6'b010000;
      12'd1591 :  mem_out_dec = 6'b010001;
      12'd1592 :  mem_out_dec = 6'b010001;
      12'd1593 :  mem_out_dec = 6'b010001;
      12'd1594 :  mem_out_dec = 6'b010010;
      12'd1595 :  mem_out_dec = 6'b010010;
      12'd1596 :  mem_out_dec = 6'b010011;
      12'd1597 :  mem_out_dec = 6'b010011;
      12'd1598 :  mem_out_dec = 6'b010100;
      12'd1599 :  mem_out_dec = 6'b010100;
      12'd1600 :  mem_out_dec = 6'b111111;
      12'd1601 :  mem_out_dec = 6'b111111;
      12'd1602 :  mem_out_dec = 6'b111111;
      12'd1603 :  mem_out_dec = 6'b111111;
      12'd1604 :  mem_out_dec = 6'b111111;
      12'd1605 :  mem_out_dec = 6'b111111;
      12'd1606 :  mem_out_dec = 6'b111111;
      12'd1607 :  mem_out_dec = 6'b111111;
      12'd1608 :  mem_out_dec = 6'b111111;
      12'd1609 :  mem_out_dec = 6'b111111;
      12'd1610 :  mem_out_dec = 6'b111111;
      12'd1611 :  mem_out_dec = 6'b111111;
      12'd1612 :  mem_out_dec = 6'b111111;
      12'd1613 :  mem_out_dec = 6'b111111;
      12'd1614 :  mem_out_dec = 6'b111111;
      12'd1615 :  mem_out_dec = 6'b111111;
      12'd1616 :  mem_out_dec = 6'b111111;
      12'd1617 :  mem_out_dec = 6'b111111;
      12'd1618 :  mem_out_dec = 6'b111111;
      12'd1619 :  mem_out_dec = 6'b111111;
      12'd1620 :  mem_out_dec = 6'b111111;
      12'd1621 :  mem_out_dec = 6'b111111;
      12'd1622 :  mem_out_dec = 6'b111111;
      12'd1623 :  mem_out_dec = 6'b111111;
      12'd1624 :  mem_out_dec = 6'b111111;
      12'd1625 :  mem_out_dec = 6'b111111;
      12'd1626 :  mem_out_dec = 6'b111111;
      12'd1627 :  mem_out_dec = 6'b111111;
      12'd1628 :  mem_out_dec = 6'b111111;
      12'd1629 :  mem_out_dec = 6'b111111;
      12'd1630 :  mem_out_dec = 6'b111111;
      12'd1631 :  mem_out_dec = 6'b000100;
      12'd1632 :  mem_out_dec = 6'b000011;
      12'd1633 :  mem_out_dec = 6'b000011;
      12'd1634 :  mem_out_dec = 6'b000100;
      12'd1635 :  mem_out_dec = 6'b000100;
      12'd1636 :  mem_out_dec = 6'b000101;
      12'd1637 :  mem_out_dec = 6'b000110;
      12'd1638 :  mem_out_dec = 6'b000110;
      12'd1639 :  mem_out_dec = 6'b000111;
      12'd1640 :  mem_out_dec = 6'b000111;
      12'd1641 :  mem_out_dec = 6'b001000;
      12'd1642 :  mem_out_dec = 6'b001001;
      12'd1643 :  mem_out_dec = 6'b001001;
      12'd1644 :  mem_out_dec = 6'b001010;
      12'd1645 :  mem_out_dec = 6'b001011;
      12'd1646 :  mem_out_dec = 6'b001100;
      12'd1647 :  mem_out_dec = 6'b001101;
      12'd1648 :  mem_out_dec = 6'b001101;
      12'd1649 :  mem_out_dec = 6'b001101;
      12'd1650 :  mem_out_dec = 6'b001110;
      12'd1651 :  mem_out_dec = 6'b001110;
      12'd1652 :  mem_out_dec = 6'b001110;
      12'd1653 :  mem_out_dec = 6'b001111;
      12'd1654 :  mem_out_dec = 6'b010000;
      12'd1655 :  mem_out_dec = 6'b010000;
      12'd1656 :  mem_out_dec = 6'b010001;
      12'd1657 :  mem_out_dec = 6'b010001;
      12'd1658 :  mem_out_dec = 6'b010001;
      12'd1659 :  mem_out_dec = 6'b010010;
      12'd1660 :  mem_out_dec = 6'b010010;
      12'd1661 :  mem_out_dec = 6'b010011;
      12'd1662 :  mem_out_dec = 6'b010011;
      12'd1663 :  mem_out_dec = 6'b010100;
      12'd1664 :  mem_out_dec = 6'b111111;
      12'd1665 :  mem_out_dec = 6'b111111;
      12'd1666 :  mem_out_dec = 6'b111111;
      12'd1667 :  mem_out_dec = 6'b111111;
      12'd1668 :  mem_out_dec = 6'b111111;
      12'd1669 :  mem_out_dec = 6'b111111;
      12'd1670 :  mem_out_dec = 6'b111111;
      12'd1671 :  mem_out_dec = 6'b111111;
      12'd1672 :  mem_out_dec = 6'b111111;
      12'd1673 :  mem_out_dec = 6'b111111;
      12'd1674 :  mem_out_dec = 6'b111111;
      12'd1675 :  mem_out_dec = 6'b111111;
      12'd1676 :  mem_out_dec = 6'b111111;
      12'd1677 :  mem_out_dec = 6'b111111;
      12'd1678 :  mem_out_dec = 6'b111111;
      12'd1679 :  mem_out_dec = 6'b111111;
      12'd1680 :  mem_out_dec = 6'b111111;
      12'd1681 :  mem_out_dec = 6'b111111;
      12'd1682 :  mem_out_dec = 6'b111111;
      12'd1683 :  mem_out_dec = 6'b111111;
      12'd1684 :  mem_out_dec = 6'b111111;
      12'd1685 :  mem_out_dec = 6'b111111;
      12'd1686 :  mem_out_dec = 6'b111111;
      12'd1687 :  mem_out_dec = 6'b111111;
      12'd1688 :  mem_out_dec = 6'b111111;
      12'd1689 :  mem_out_dec = 6'b111111;
      12'd1690 :  mem_out_dec = 6'b111111;
      12'd1691 :  mem_out_dec = 6'b111111;
      12'd1692 :  mem_out_dec = 6'b111111;
      12'd1693 :  mem_out_dec = 6'b111111;
      12'd1694 :  mem_out_dec = 6'b111111;
      12'd1695 :  mem_out_dec = 6'b111111;
      12'd1696 :  mem_out_dec = 6'b000011;
      12'd1697 :  mem_out_dec = 6'b000011;
      12'd1698 :  mem_out_dec = 6'b000100;
      12'd1699 :  mem_out_dec = 6'b000100;
      12'd1700 :  mem_out_dec = 6'b000101;
      12'd1701 :  mem_out_dec = 6'b000101;
      12'd1702 :  mem_out_dec = 6'b000110;
      12'd1703 :  mem_out_dec = 6'b000111;
      12'd1704 :  mem_out_dec = 6'b000111;
      12'd1705 :  mem_out_dec = 6'b001000;
      12'd1706 :  mem_out_dec = 6'b001000;
      12'd1707 :  mem_out_dec = 6'b001001;
      12'd1708 :  mem_out_dec = 6'b001010;
      12'd1709 :  mem_out_dec = 6'b001011;
      12'd1710 :  mem_out_dec = 6'b001100;
      12'd1711 :  mem_out_dec = 6'b001100;
      12'd1712 :  mem_out_dec = 6'b001100;
      12'd1713 :  mem_out_dec = 6'b001101;
      12'd1714 :  mem_out_dec = 6'b001101;
      12'd1715 :  mem_out_dec = 6'b001110;
      12'd1716 :  mem_out_dec = 6'b001110;
      12'd1717 :  mem_out_dec = 6'b001111;
      12'd1718 :  mem_out_dec = 6'b001111;
      12'd1719 :  mem_out_dec = 6'b010000;
      12'd1720 :  mem_out_dec = 6'b010000;
      12'd1721 :  mem_out_dec = 6'b010000;
      12'd1722 :  mem_out_dec = 6'b010001;
      12'd1723 :  mem_out_dec = 6'b010001;
      12'd1724 :  mem_out_dec = 6'b010010;
      12'd1725 :  mem_out_dec = 6'b010010;
      12'd1726 :  mem_out_dec = 6'b010011;
      12'd1727 :  mem_out_dec = 6'b010011;
      12'd1728 :  mem_out_dec = 6'b111111;
      12'd1729 :  mem_out_dec = 6'b111111;
      12'd1730 :  mem_out_dec = 6'b111111;
      12'd1731 :  mem_out_dec = 6'b111111;
      12'd1732 :  mem_out_dec = 6'b111111;
      12'd1733 :  mem_out_dec = 6'b111111;
      12'd1734 :  mem_out_dec = 6'b111111;
      12'd1735 :  mem_out_dec = 6'b111111;
      12'd1736 :  mem_out_dec = 6'b111111;
      12'd1737 :  mem_out_dec = 6'b111111;
      12'd1738 :  mem_out_dec = 6'b111111;
      12'd1739 :  mem_out_dec = 6'b111111;
      12'd1740 :  mem_out_dec = 6'b111111;
      12'd1741 :  mem_out_dec = 6'b111111;
      12'd1742 :  mem_out_dec = 6'b111111;
      12'd1743 :  mem_out_dec = 6'b111111;
      12'd1744 :  mem_out_dec = 6'b111111;
      12'd1745 :  mem_out_dec = 6'b111111;
      12'd1746 :  mem_out_dec = 6'b111111;
      12'd1747 :  mem_out_dec = 6'b111111;
      12'd1748 :  mem_out_dec = 6'b111111;
      12'd1749 :  mem_out_dec = 6'b111111;
      12'd1750 :  mem_out_dec = 6'b111111;
      12'd1751 :  mem_out_dec = 6'b111111;
      12'd1752 :  mem_out_dec = 6'b111111;
      12'd1753 :  mem_out_dec = 6'b111111;
      12'd1754 :  mem_out_dec = 6'b111111;
      12'd1755 :  mem_out_dec = 6'b111111;
      12'd1756 :  mem_out_dec = 6'b111111;
      12'd1757 :  mem_out_dec = 6'b111111;
      12'd1758 :  mem_out_dec = 6'b111111;
      12'd1759 :  mem_out_dec = 6'b111111;
      12'd1760 :  mem_out_dec = 6'b111111;
      12'd1761 :  mem_out_dec = 6'b000011;
      12'd1762 :  mem_out_dec = 6'b000011;
      12'd1763 :  mem_out_dec = 6'b000100;
      12'd1764 :  mem_out_dec = 6'b000101;
      12'd1765 :  mem_out_dec = 6'b000101;
      12'd1766 :  mem_out_dec = 6'b000110;
      12'd1767 :  mem_out_dec = 6'b000111;
      12'd1768 :  mem_out_dec = 6'b000111;
      12'd1769 :  mem_out_dec = 6'b000111;
      12'd1770 :  mem_out_dec = 6'b001000;
      12'd1771 :  mem_out_dec = 6'b001001;
      12'd1772 :  mem_out_dec = 6'b001010;
      12'd1773 :  mem_out_dec = 6'b001011;
      12'd1774 :  mem_out_dec = 6'b001011;
      12'd1775 :  mem_out_dec = 6'b001100;
      12'd1776 :  mem_out_dec = 6'b001100;
      12'd1777 :  mem_out_dec = 6'b001101;
      12'd1778 :  mem_out_dec = 6'b001101;
      12'd1779 :  mem_out_dec = 6'b001101;
      12'd1780 :  mem_out_dec = 6'b001110;
      12'd1781 :  mem_out_dec = 6'b001111;
      12'd1782 :  mem_out_dec = 6'b001111;
      12'd1783 :  mem_out_dec = 6'b010000;
      12'd1784 :  mem_out_dec = 6'b010000;
      12'd1785 :  mem_out_dec = 6'b010000;
      12'd1786 :  mem_out_dec = 6'b010000;
      12'd1787 :  mem_out_dec = 6'b010001;
      12'd1788 :  mem_out_dec = 6'b010001;
      12'd1789 :  mem_out_dec = 6'b010010;
      12'd1790 :  mem_out_dec = 6'b010010;
      12'd1791 :  mem_out_dec = 6'b010011;
      12'd1792 :  mem_out_dec = 6'b111111;
      12'd1793 :  mem_out_dec = 6'b111111;
      12'd1794 :  mem_out_dec = 6'b111111;
      12'd1795 :  mem_out_dec = 6'b111111;
      12'd1796 :  mem_out_dec = 6'b111111;
      12'd1797 :  mem_out_dec = 6'b111111;
      12'd1798 :  mem_out_dec = 6'b111111;
      12'd1799 :  mem_out_dec = 6'b111111;
      12'd1800 :  mem_out_dec = 6'b111111;
      12'd1801 :  mem_out_dec = 6'b111111;
      12'd1802 :  mem_out_dec = 6'b111111;
      12'd1803 :  mem_out_dec = 6'b111111;
      12'd1804 :  mem_out_dec = 6'b111111;
      12'd1805 :  mem_out_dec = 6'b111111;
      12'd1806 :  mem_out_dec = 6'b111111;
      12'd1807 :  mem_out_dec = 6'b111111;
      12'd1808 :  mem_out_dec = 6'b111111;
      12'd1809 :  mem_out_dec = 6'b111111;
      12'd1810 :  mem_out_dec = 6'b111111;
      12'd1811 :  mem_out_dec = 6'b111111;
      12'd1812 :  mem_out_dec = 6'b111111;
      12'd1813 :  mem_out_dec = 6'b111111;
      12'd1814 :  mem_out_dec = 6'b111111;
      12'd1815 :  mem_out_dec = 6'b111111;
      12'd1816 :  mem_out_dec = 6'b111111;
      12'd1817 :  mem_out_dec = 6'b111111;
      12'd1818 :  mem_out_dec = 6'b111111;
      12'd1819 :  mem_out_dec = 6'b111111;
      12'd1820 :  mem_out_dec = 6'b111111;
      12'd1821 :  mem_out_dec = 6'b111111;
      12'd1822 :  mem_out_dec = 6'b111111;
      12'd1823 :  mem_out_dec = 6'b111111;
      12'd1824 :  mem_out_dec = 6'b111111;
      12'd1825 :  mem_out_dec = 6'b111111;
      12'd1826 :  mem_out_dec = 6'b000011;
      12'd1827 :  mem_out_dec = 6'b000100;
      12'd1828 :  mem_out_dec = 6'b000100;
      12'd1829 :  mem_out_dec = 6'b000101;
      12'd1830 :  mem_out_dec = 6'b000110;
      12'd1831 :  mem_out_dec = 6'b000110;
      12'd1832 :  mem_out_dec = 6'b000110;
      12'd1833 :  mem_out_dec = 6'b000111;
      12'd1834 :  mem_out_dec = 6'b001000;
      12'd1835 :  mem_out_dec = 6'b001001;
      12'd1836 :  mem_out_dec = 6'b001010;
      12'd1837 :  mem_out_dec = 6'b001010;
      12'd1838 :  mem_out_dec = 6'b001011;
      12'd1839 :  mem_out_dec = 6'b001100;
      12'd1840 :  mem_out_dec = 6'b001100;
      12'd1841 :  mem_out_dec = 6'b001100;
      12'd1842 :  mem_out_dec = 6'b001101;
      12'd1843 :  mem_out_dec = 6'b001101;
      12'd1844 :  mem_out_dec = 6'b001110;
      12'd1845 :  mem_out_dec = 6'b001110;
      12'd1846 :  mem_out_dec = 6'b001111;
      12'd1847 :  mem_out_dec = 6'b010000;
      12'd1848 :  mem_out_dec = 6'b001111;
      12'd1849 :  mem_out_dec = 6'b001111;
      12'd1850 :  mem_out_dec = 6'b010000;
      12'd1851 :  mem_out_dec = 6'b010000;
      12'd1852 :  mem_out_dec = 6'b010001;
      12'd1853 :  mem_out_dec = 6'b010001;
      12'd1854 :  mem_out_dec = 6'b010010;
      12'd1855 :  mem_out_dec = 6'b010010;
      12'd1856 :  mem_out_dec = 6'b111111;
      12'd1857 :  mem_out_dec = 6'b111111;
      12'd1858 :  mem_out_dec = 6'b111111;
      12'd1859 :  mem_out_dec = 6'b111111;
      12'd1860 :  mem_out_dec = 6'b111111;
      12'd1861 :  mem_out_dec = 6'b111111;
      12'd1862 :  mem_out_dec = 6'b111111;
      12'd1863 :  mem_out_dec = 6'b111111;
      12'd1864 :  mem_out_dec = 6'b111111;
      12'd1865 :  mem_out_dec = 6'b111111;
      12'd1866 :  mem_out_dec = 6'b111111;
      12'd1867 :  mem_out_dec = 6'b111111;
      12'd1868 :  mem_out_dec = 6'b111111;
      12'd1869 :  mem_out_dec = 6'b111111;
      12'd1870 :  mem_out_dec = 6'b111111;
      12'd1871 :  mem_out_dec = 6'b111111;
      12'd1872 :  mem_out_dec = 6'b111111;
      12'd1873 :  mem_out_dec = 6'b111111;
      12'd1874 :  mem_out_dec = 6'b111111;
      12'd1875 :  mem_out_dec = 6'b111111;
      12'd1876 :  mem_out_dec = 6'b111111;
      12'd1877 :  mem_out_dec = 6'b111111;
      12'd1878 :  mem_out_dec = 6'b111111;
      12'd1879 :  mem_out_dec = 6'b111111;
      12'd1880 :  mem_out_dec = 6'b111111;
      12'd1881 :  mem_out_dec = 6'b111111;
      12'd1882 :  mem_out_dec = 6'b111111;
      12'd1883 :  mem_out_dec = 6'b111111;
      12'd1884 :  mem_out_dec = 6'b111111;
      12'd1885 :  mem_out_dec = 6'b111111;
      12'd1886 :  mem_out_dec = 6'b111111;
      12'd1887 :  mem_out_dec = 6'b111111;
      12'd1888 :  mem_out_dec = 6'b111111;
      12'd1889 :  mem_out_dec = 6'b111111;
      12'd1890 :  mem_out_dec = 6'b111111;
      12'd1891 :  mem_out_dec = 6'b000100;
      12'd1892 :  mem_out_dec = 6'b000100;
      12'd1893 :  mem_out_dec = 6'b000101;
      12'd1894 :  mem_out_dec = 6'b000101;
      12'd1895 :  mem_out_dec = 6'b000110;
      12'd1896 :  mem_out_dec = 6'b000110;
      12'd1897 :  mem_out_dec = 6'b000111;
      12'd1898 :  mem_out_dec = 6'b001000;
      12'd1899 :  mem_out_dec = 6'b001001;
      12'd1900 :  mem_out_dec = 6'b001001;
      12'd1901 :  mem_out_dec = 6'b001010;
      12'd1902 :  mem_out_dec = 6'b001011;
      12'd1903 :  mem_out_dec = 6'b001100;
      12'd1904 :  mem_out_dec = 6'b001100;
      12'd1905 :  mem_out_dec = 6'b001100;
      12'd1906 :  mem_out_dec = 6'b001100;
      12'd1907 :  mem_out_dec = 6'b001101;
      12'd1908 :  mem_out_dec = 6'b001110;
      12'd1909 :  mem_out_dec = 6'b001110;
      12'd1910 :  mem_out_dec = 6'b001111;
      12'd1911 :  mem_out_dec = 6'b001111;
      12'd1912 :  mem_out_dec = 6'b001111;
      12'd1913 :  mem_out_dec = 6'b001111;
      12'd1914 :  mem_out_dec = 6'b001111;
      12'd1915 :  mem_out_dec = 6'b010000;
      12'd1916 :  mem_out_dec = 6'b010000;
      12'd1917 :  mem_out_dec = 6'b010001;
      12'd1918 :  mem_out_dec = 6'b010001;
      12'd1919 :  mem_out_dec = 6'b010010;
      12'd1920 :  mem_out_dec = 6'b111111;
      12'd1921 :  mem_out_dec = 6'b111111;
      12'd1922 :  mem_out_dec = 6'b111111;
      12'd1923 :  mem_out_dec = 6'b111111;
      12'd1924 :  mem_out_dec = 6'b111111;
      12'd1925 :  mem_out_dec = 6'b111111;
      12'd1926 :  mem_out_dec = 6'b111111;
      12'd1927 :  mem_out_dec = 6'b111111;
      12'd1928 :  mem_out_dec = 6'b111111;
      12'd1929 :  mem_out_dec = 6'b111111;
      12'd1930 :  mem_out_dec = 6'b111111;
      12'd1931 :  mem_out_dec = 6'b111111;
      12'd1932 :  mem_out_dec = 6'b111111;
      12'd1933 :  mem_out_dec = 6'b111111;
      12'd1934 :  mem_out_dec = 6'b111111;
      12'd1935 :  mem_out_dec = 6'b111111;
      12'd1936 :  mem_out_dec = 6'b111111;
      12'd1937 :  mem_out_dec = 6'b111111;
      12'd1938 :  mem_out_dec = 6'b111111;
      12'd1939 :  mem_out_dec = 6'b111111;
      12'd1940 :  mem_out_dec = 6'b111111;
      12'd1941 :  mem_out_dec = 6'b111111;
      12'd1942 :  mem_out_dec = 6'b111111;
      12'd1943 :  mem_out_dec = 6'b111111;
      12'd1944 :  mem_out_dec = 6'b111111;
      12'd1945 :  mem_out_dec = 6'b111111;
      12'd1946 :  mem_out_dec = 6'b111111;
      12'd1947 :  mem_out_dec = 6'b111111;
      12'd1948 :  mem_out_dec = 6'b111111;
      12'd1949 :  mem_out_dec = 6'b111111;
      12'd1950 :  mem_out_dec = 6'b111111;
      12'd1951 :  mem_out_dec = 6'b111111;
      12'd1952 :  mem_out_dec = 6'b111111;
      12'd1953 :  mem_out_dec = 6'b111111;
      12'd1954 :  mem_out_dec = 6'b111111;
      12'd1955 :  mem_out_dec = 6'b111111;
      12'd1956 :  mem_out_dec = 6'b000100;
      12'd1957 :  mem_out_dec = 6'b000101;
      12'd1958 :  mem_out_dec = 6'b000101;
      12'd1959 :  mem_out_dec = 6'b000110;
      12'd1960 :  mem_out_dec = 6'b000110;
      12'd1961 :  mem_out_dec = 6'b000111;
      12'd1962 :  mem_out_dec = 6'b001000;
      12'd1963 :  mem_out_dec = 6'b001000;
      12'd1964 :  mem_out_dec = 6'b001001;
      12'd1965 :  mem_out_dec = 6'b001010;
      12'd1966 :  mem_out_dec = 6'b001011;
      12'd1967 :  mem_out_dec = 6'b001011;
      12'd1968 :  mem_out_dec = 6'b001011;
      12'd1969 :  mem_out_dec = 6'b001100;
      12'd1970 :  mem_out_dec = 6'b001100;
      12'd1971 :  mem_out_dec = 6'b001101;
      12'd1972 :  mem_out_dec = 6'b001101;
      12'd1973 :  mem_out_dec = 6'b001110;
      12'd1974 :  mem_out_dec = 6'b001111;
      12'd1975 :  mem_out_dec = 6'b001111;
      12'd1976 :  mem_out_dec = 6'b001110;
      12'd1977 :  mem_out_dec = 6'b001110;
      12'd1978 :  mem_out_dec = 6'b001111;
      12'd1979 :  mem_out_dec = 6'b001111;
      12'd1980 :  mem_out_dec = 6'b010000;
      12'd1981 :  mem_out_dec = 6'b010000;
      12'd1982 :  mem_out_dec = 6'b010001;
      12'd1983 :  mem_out_dec = 6'b010001;
      12'd1984 :  mem_out_dec = 6'b111111;
      12'd1985 :  mem_out_dec = 6'b111111;
      12'd1986 :  mem_out_dec = 6'b111111;
      12'd1987 :  mem_out_dec = 6'b111111;
      12'd1988 :  mem_out_dec = 6'b111111;
      12'd1989 :  mem_out_dec = 6'b111111;
      12'd1990 :  mem_out_dec = 6'b111111;
      12'd1991 :  mem_out_dec = 6'b111111;
      12'd1992 :  mem_out_dec = 6'b111111;
      12'd1993 :  mem_out_dec = 6'b111111;
      12'd1994 :  mem_out_dec = 6'b111111;
      12'd1995 :  mem_out_dec = 6'b111111;
      12'd1996 :  mem_out_dec = 6'b111111;
      12'd1997 :  mem_out_dec = 6'b111111;
      12'd1998 :  mem_out_dec = 6'b111111;
      12'd1999 :  mem_out_dec = 6'b111111;
      12'd2000 :  mem_out_dec = 6'b111111;
      12'd2001 :  mem_out_dec = 6'b111111;
      12'd2002 :  mem_out_dec = 6'b111111;
      12'd2003 :  mem_out_dec = 6'b111111;
      12'd2004 :  mem_out_dec = 6'b111111;
      12'd2005 :  mem_out_dec = 6'b111111;
      12'd2006 :  mem_out_dec = 6'b111111;
      12'd2007 :  mem_out_dec = 6'b111111;
      12'd2008 :  mem_out_dec = 6'b111111;
      12'd2009 :  mem_out_dec = 6'b111111;
      12'd2010 :  mem_out_dec = 6'b111111;
      12'd2011 :  mem_out_dec = 6'b111111;
      12'd2012 :  mem_out_dec = 6'b111111;
      12'd2013 :  mem_out_dec = 6'b111111;
      12'd2014 :  mem_out_dec = 6'b111111;
      12'd2015 :  mem_out_dec = 6'b111111;
      12'd2016 :  mem_out_dec = 6'b111111;
      12'd2017 :  mem_out_dec = 6'b111111;
      12'd2018 :  mem_out_dec = 6'b111111;
      12'd2019 :  mem_out_dec = 6'b111111;
      12'd2020 :  mem_out_dec = 6'b111111;
      12'd2021 :  mem_out_dec = 6'b000100;
      12'd2022 :  mem_out_dec = 6'b000101;
      12'd2023 :  mem_out_dec = 6'b000110;
      12'd2024 :  mem_out_dec = 6'b000110;
      12'd2025 :  mem_out_dec = 6'b000111;
      12'd2026 :  mem_out_dec = 6'b000111;
      12'd2027 :  mem_out_dec = 6'b001000;
      12'd2028 :  mem_out_dec = 6'b001001;
      12'd2029 :  mem_out_dec = 6'b001010;
      12'd2030 :  mem_out_dec = 6'b001010;
      12'd2031 :  mem_out_dec = 6'b001011;
      12'd2032 :  mem_out_dec = 6'b001011;
      12'd2033 :  mem_out_dec = 6'b001011;
      12'd2034 :  mem_out_dec = 6'b001100;
      12'd2035 :  mem_out_dec = 6'b001101;
      12'd2036 :  mem_out_dec = 6'b001101;
      12'd2037 :  mem_out_dec = 6'b001110;
      12'd2038 :  mem_out_dec = 6'b001110;
      12'd2039 :  mem_out_dec = 6'b001110;
      12'd2040 :  mem_out_dec = 6'b001101;
      12'd2041 :  mem_out_dec = 6'b001110;
      12'd2042 :  mem_out_dec = 6'b001110;
      12'd2043 :  mem_out_dec = 6'b001111;
      12'd2044 :  mem_out_dec = 6'b001111;
      12'd2045 :  mem_out_dec = 6'b010000;
      12'd2046 :  mem_out_dec = 6'b010000;
      12'd2047 :  mem_out_dec = 6'b010001;
      12'd2048 :  mem_out_dec = 6'b111111;
      12'd2049 :  mem_out_dec = 6'b111111;
      12'd2050 :  mem_out_dec = 6'b111111;
      12'd2051 :  mem_out_dec = 6'b111111;
      12'd2052 :  mem_out_dec = 6'b111111;
      12'd2053 :  mem_out_dec = 6'b111111;
      12'd2054 :  mem_out_dec = 6'b111111;
      12'd2055 :  mem_out_dec = 6'b111111;
      12'd2056 :  mem_out_dec = 6'b111111;
      12'd2057 :  mem_out_dec = 6'b111111;
      12'd2058 :  mem_out_dec = 6'b111111;
      12'd2059 :  mem_out_dec = 6'b111111;
      12'd2060 :  mem_out_dec = 6'b111111;
      12'd2061 :  mem_out_dec = 6'b111111;
      12'd2062 :  mem_out_dec = 6'b111111;
      12'd2063 :  mem_out_dec = 6'b111111;
      12'd2064 :  mem_out_dec = 6'b111111;
      12'd2065 :  mem_out_dec = 6'b111111;
      12'd2066 :  mem_out_dec = 6'b111111;
      12'd2067 :  mem_out_dec = 6'b111111;
      12'd2068 :  mem_out_dec = 6'b111111;
      12'd2069 :  mem_out_dec = 6'b111111;
      12'd2070 :  mem_out_dec = 6'b111111;
      12'd2071 :  mem_out_dec = 6'b111111;
      12'd2072 :  mem_out_dec = 6'b111111;
      12'd2073 :  mem_out_dec = 6'b111111;
      12'd2074 :  mem_out_dec = 6'b111111;
      12'd2075 :  mem_out_dec = 6'b111111;
      12'd2076 :  mem_out_dec = 6'b111111;
      12'd2077 :  mem_out_dec = 6'b111111;
      12'd2078 :  mem_out_dec = 6'b111111;
      12'd2079 :  mem_out_dec = 6'b111111;
      12'd2080 :  mem_out_dec = 6'b111111;
      12'd2081 :  mem_out_dec = 6'b111111;
      12'd2082 :  mem_out_dec = 6'b111111;
      12'd2083 :  mem_out_dec = 6'b111111;
      12'd2084 :  mem_out_dec = 6'b111111;
      12'd2085 :  mem_out_dec = 6'b111111;
      12'd2086 :  mem_out_dec = 6'b000100;
      12'd2087 :  mem_out_dec = 6'b000101;
      12'd2088 :  mem_out_dec = 6'b000101;
      12'd2089 :  mem_out_dec = 6'b000110;
      12'd2090 :  mem_out_dec = 6'b000110;
      12'd2091 :  mem_out_dec = 6'b000111;
      12'd2092 :  mem_out_dec = 6'b001000;
      12'd2093 :  mem_out_dec = 6'b001001;
      12'd2094 :  mem_out_dec = 6'b001001;
      12'd2095 :  mem_out_dec = 6'b001010;
      12'd2096 :  mem_out_dec = 6'b001010;
      12'd2097 :  mem_out_dec = 6'b001011;
      12'd2098 :  mem_out_dec = 6'b001011;
      12'd2099 :  mem_out_dec = 6'b001100;
      12'd2100 :  mem_out_dec = 6'b001100;
      12'd2101 :  mem_out_dec = 6'b001100;
      12'd2102 :  mem_out_dec = 6'b001100;
      12'd2103 :  mem_out_dec = 6'b001101;
      12'd2104 :  mem_out_dec = 6'b001100;
      12'd2105 :  mem_out_dec = 6'b001100;
      12'd2106 :  mem_out_dec = 6'b001101;
      12'd2107 :  mem_out_dec = 6'b001101;
      12'd2108 :  mem_out_dec = 6'b001110;
      12'd2109 :  mem_out_dec = 6'b001111;
      12'd2110 :  mem_out_dec = 6'b010000;
      12'd2111 :  mem_out_dec = 6'b010000;
      12'd2112 :  mem_out_dec = 6'b111111;
      12'd2113 :  mem_out_dec = 6'b111111;
      12'd2114 :  mem_out_dec = 6'b111111;
      12'd2115 :  mem_out_dec = 6'b111111;
      12'd2116 :  mem_out_dec = 6'b111111;
      12'd2117 :  mem_out_dec = 6'b111111;
      12'd2118 :  mem_out_dec = 6'b111111;
      12'd2119 :  mem_out_dec = 6'b111111;
      12'd2120 :  mem_out_dec = 6'b111111;
      12'd2121 :  mem_out_dec = 6'b111111;
      12'd2122 :  mem_out_dec = 6'b111111;
      12'd2123 :  mem_out_dec = 6'b111111;
      12'd2124 :  mem_out_dec = 6'b111111;
      12'd2125 :  mem_out_dec = 6'b111111;
      12'd2126 :  mem_out_dec = 6'b111111;
      12'd2127 :  mem_out_dec = 6'b111111;
      12'd2128 :  mem_out_dec = 6'b111111;
      12'd2129 :  mem_out_dec = 6'b111111;
      12'd2130 :  mem_out_dec = 6'b111111;
      12'd2131 :  mem_out_dec = 6'b111111;
      12'd2132 :  mem_out_dec = 6'b111111;
      12'd2133 :  mem_out_dec = 6'b111111;
      12'd2134 :  mem_out_dec = 6'b111111;
      12'd2135 :  mem_out_dec = 6'b111111;
      12'd2136 :  mem_out_dec = 6'b111111;
      12'd2137 :  mem_out_dec = 6'b111111;
      12'd2138 :  mem_out_dec = 6'b111111;
      12'd2139 :  mem_out_dec = 6'b111111;
      12'd2140 :  mem_out_dec = 6'b111111;
      12'd2141 :  mem_out_dec = 6'b111111;
      12'd2142 :  mem_out_dec = 6'b111111;
      12'd2143 :  mem_out_dec = 6'b111111;
      12'd2144 :  mem_out_dec = 6'b111111;
      12'd2145 :  mem_out_dec = 6'b111111;
      12'd2146 :  mem_out_dec = 6'b111111;
      12'd2147 :  mem_out_dec = 6'b111111;
      12'd2148 :  mem_out_dec = 6'b111111;
      12'd2149 :  mem_out_dec = 6'b111111;
      12'd2150 :  mem_out_dec = 6'b111111;
      12'd2151 :  mem_out_dec = 6'b000100;
      12'd2152 :  mem_out_dec = 6'b000100;
      12'd2153 :  mem_out_dec = 6'b000101;
      12'd2154 :  mem_out_dec = 6'b000110;
      12'd2155 :  mem_out_dec = 6'b000111;
      12'd2156 :  mem_out_dec = 6'b000111;
      12'd2157 :  mem_out_dec = 6'b001000;
      12'd2158 :  mem_out_dec = 6'b001001;
      12'd2159 :  mem_out_dec = 6'b001001;
      12'd2160 :  mem_out_dec = 6'b001010;
      12'd2161 :  mem_out_dec = 6'b001010;
      12'd2162 :  mem_out_dec = 6'b001011;
      12'd2163 :  mem_out_dec = 6'b001011;
      12'd2164 :  mem_out_dec = 6'b001011;
      12'd2165 :  mem_out_dec = 6'b001011;
      12'd2166 :  mem_out_dec = 6'b001011;
      12'd2167 :  mem_out_dec = 6'b001100;
      12'd2168 :  mem_out_dec = 6'b001011;
      12'd2169 :  mem_out_dec = 6'b001011;
      12'd2170 :  mem_out_dec = 6'b001100;
      12'd2171 :  mem_out_dec = 6'b001101;
      12'd2172 :  mem_out_dec = 6'b001110;
      12'd2173 :  mem_out_dec = 6'b001110;
      12'd2174 :  mem_out_dec = 6'b001111;
      12'd2175 :  mem_out_dec = 6'b010000;
      12'd2176 :  mem_out_dec = 6'b111111;
      12'd2177 :  mem_out_dec = 6'b111111;
      12'd2178 :  mem_out_dec = 6'b111111;
      12'd2179 :  mem_out_dec = 6'b111111;
      12'd2180 :  mem_out_dec = 6'b111111;
      12'd2181 :  mem_out_dec = 6'b111111;
      12'd2182 :  mem_out_dec = 6'b111111;
      12'd2183 :  mem_out_dec = 6'b111111;
      12'd2184 :  mem_out_dec = 6'b111111;
      12'd2185 :  mem_out_dec = 6'b111111;
      12'd2186 :  mem_out_dec = 6'b111111;
      12'd2187 :  mem_out_dec = 6'b111111;
      12'd2188 :  mem_out_dec = 6'b111111;
      12'd2189 :  mem_out_dec = 6'b111111;
      12'd2190 :  mem_out_dec = 6'b111111;
      12'd2191 :  mem_out_dec = 6'b111111;
      12'd2192 :  mem_out_dec = 6'b111111;
      12'd2193 :  mem_out_dec = 6'b111111;
      12'd2194 :  mem_out_dec = 6'b111111;
      12'd2195 :  mem_out_dec = 6'b111111;
      12'd2196 :  mem_out_dec = 6'b111111;
      12'd2197 :  mem_out_dec = 6'b111111;
      12'd2198 :  mem_out_dec = 6'b111111;
      12'd2199 :  mem_out_dec = 6'b111111;
      12'd2200 :  mem_out_dec = 6'b111111;
      12'd2201 :  mem_out_dec = 6'b111111;
      12'd2202 :  mem_out_dec = 6'b111111;
      12'd2203 :  mem_out_dec = 6'b111111;
      12'd2204 :  mem_out_dec = 6'b111111;
      12'd2205 :  mem_out_dec = 6'b111111;
      12'd2206 :  mem_out_dec = 6'b111111;
      12'd2207 :  mem_out_dec = 6'b111111;
      12'd2208 :  mem_out_dec = 6'b111111;
      12'd2209 :  mem_out_dec = 6'b111111;
      12'd2210 :  mem_out_dec = 6'b111111;
      12'd2211 :  mem_out_dec = 6'b111111;
      12'd2212 :  mem_out_dec = 6'b111111;
      12'd2213 :  mem_out_dec = 6'b111111;
      12'd2214 :  mem_out_dec = 6'b111111;
      12'd2215 :  mem_out_dec = 6'b111111;
      12'd2216 :  mem_out_dec = 6'b000100;
      12'd2217 :  mem_out_dec = 6'b000101;
      12'd2218 :  mem_out_dec = 6'b000101;
      12'd2219 :  mem_out_dec = 6'b000110;
      12'd2220 :  mem_out_dec = 6'b000111;
      12'd2221 :  mem_out_dec = 6'b000111;
      12'd2222 :  mem_out_dec = 6'b001000;
      12'd2223 :  mem_out_dec = 6'b001001;
      12'd2224 :  mem_out_dec = 6'b001001;
      12'd2225 :  mem_out_dec = 6'b001010;
      12'd2226 :  mem_out_dec = 6'b001010;
      12'd2227 :  mem_out_dec = 6'b001010;
      12'd2228 :  mem_out_dec = 6'b001010;
      12'd2229 :  mem_out_dec = 6'b001010;
      12'd2230 :  mem_out_dec = 6'b001010;
      12'd2231 :  mem_out_dec = 6'b001010;
      12'd2232 :  mem_out_dec = 6'b001010;
      12'd2233 :  mem_out_dec = 6'b001011;
      12'd2234 :  mem_out_dec = 6'b001100;
      12'd2235 :  mem_out_dec = 6'b001100;
      12'd2236 :  mem_out_dec = 6'b001101;
      12'd2237 :  mem_out_dec = 6'b001110;
      12'd2238 :  mem_out_dec = 6'b001111;
      12'd2239 :  mem_out_dec = 6'b010000;
      12'd2240 :  mem_out_dec = 6'b111111;
      12'd2241 :  mem_out_dec = 6'b111111;
      12'd2242 :  mem_out_dec = 6'b111111;
      12'd2243 :  mem_out_dec = 6'b111111;
      12'd2244 :  mem_out_dec = 6'b111111;
      12'd2245 :  mem_out_dec = 6'b111111;
      12'd2246 :  mem_out_dec = 6'b111111;
      12'd2247 :  mem_out_dec = 6'b111111;
      12'd2248 :  mem_out_dec = 6'b111111;
      12'd2249 :  mem_out_dec = 6'b111111;
      12'd2250 :  mem_out_dec = 6'b111111;
      12'd2251 :  mem_out_dec = 6'b111111;
      12'd2252 :  mem_out_dec = 6'b111111;
      12'd2253 :  mem_out_dec = 6'b111111;
      12'd2254 :  mem_out_dec = 6'b111111;
      12'd2255 :  mem_out_dec = 6'b111111;
      12'd2256 :  mem_out_dec = 6'b111111;
      12'd2257 :  mem_out_dec = 6'b111111;
      12'd2258 :  mem_out_dec = 6'b111111;
      12'd2259 :  mem_out_dec = 6'b111111;
      12'd2260 :  mem_out_dec = 6'b111111;
      12'd2261 :  mem_out_dec = 6'b111111;
      12'd2262 :  mem_out_dec = 6'b111111;
      12'd2263 :  mem_out_dec = 6'b111111;
      12'd2264 :  mem_out_dec = 6'b111111;
      12'd2265 :  mem_out_dec = 6'b111111;
      12'd2266 :  mem_out_dec = 6'b111111;
      12'd2267 :  mem_out_dec = 6'b111111;
      12'd2268 :  mem_out_dec = 6'b111111;
      12'd2269 :  mem_out_dec = 6'b111111;
      12'd2270 :  mem_out_dec = 6'b111111;
      12'd2271 :  mem_out_dec = 6'b111111;
      12'd2272 :  mem_out_dec = 6'b111111;
      12'd2273 :  mem_out_dec = 6'b111111;
      12'd2274 :  mem_out_dec = 6'b111111;
      12'd2275 :  mem_out_dec = 6'b111111;
      12'd2276 :  mem_out_dec = 6'b111111;
      12'd2277 :  mem_out_dec = 6'b111111;
      12'd2278 :  mem_out_dec = 6'b111111;
      12'd2279 :  mem_out_dec = 6'b111111;
      12'd2280 :  mem_out_dec = 6'b111111;
      12'd2281 :  mem_out_dec = 6'b000100;
      12'd2282 :  mem_out_dec = 6'b000101;
      12'd2283 :  mem_out_dec = 6'b000101;
      12'd2284 :  mem_out_dec = 6'b000110;
      12'd2285 :  mem_out_dec = 6'b000111;
      12'd2286 :  mem_out_dec = 6'b001000;
      12'd2287 :  mem_out_dec = 6'b001001;
      12'd2288 :  mem_out_dec = 6'b001001;
      12'd2289 :  mem_out_dec = 6'b001001;
      12'd2290 :  mem_out_dec = 6'b001001;
      12'd2291 :  mem_out_dec = 6'b001001;
      12'd2292 :  mem_out_dec = 6'b001001;
      12'd2293 :  mem_out_dec = 6'b001001;
      12'd2294 :  mem_out_dec = 6'b001001;
      12'd2295 :  mem_out_dec = 6'b001001;
      12'd2296 :  mem_out_dec = 6'b001010;
      12'd2297 :  mem_out_dec = 6'b001010;
      12'd2298 :  mem_out_dec = 6'b001011;
      12'd2299 :  mem_out_dec = 6'b001100;
      12'd2300 :  mem_out_dec = 6'b001101;
      12'd2301 :  mem_out_dec = 6'b001110;
      12'd2302 :  mem_out_dec = 6'b001110;
      12'd2303 :  mem_out_dec = 6'b001111;
      12'd2304 :  mem_out_dec = 6'b111111;
      12'd2305 :  mem_out_dec = 6'b111111;
      12'd2306 :  mem_out_dec = 6'b111111;
      12'd2307 :  mem_out_dec = 6'b111111;
      12'd2308 :  mem_out_dec = 6'b111111;
      12'd2309 :  mem_out_dec = 6'b111111;
      12'd2310 :  mem_out_dec = 6'b111111;
      12'd2311 :  mem_out_dec = 6'b111111;
      12'd2312 :  mem_out_dec = 6'b111111;
      12'd2313 :  mem_out_dec = 6'b111111;
      12'd2314 :  mem_out_dec = 6'b111111;
      12'd2315 :  mem_out_dec = 6'b111111;
      12'd2316 :  mem_out_dec = 6'b111111;
      12'd2317 :  mem_out_dec = 6'b111111;
      12'd2318 :  mem_out_dec = 6'b111111;
      12'd2319 :  mem_out_dec = 6'b111111;
      12'd2320 :  mem_out_dec = 6'b111111;
      12'd2321 :  mem_out_dec = 6'b111111;
      12'd2322 :  mem_out_dec = 6'b111111;
      12'd2323 :  mem_out_dec = 6'b111111;
      12'd2324 :  mem_out_dec = 6'b111111;
      12'd2325 :  mem_out_dec = 6'b111111;
      12'd2326 :  mem_out_dec = 6'b111111;
      12'd2327 :  mem_out_dec = 6'b111111;
      12'd2328 :  mem_out_dec = 6'b111111;
      12'd2329 :  mem_out_dec = 6'b111111;
      12'd2330 :  mem_out_dec = 6'b111111;
      12'd2331 :  mem_out_dec = 6'b111111;
      12'd2332 :  mem_out_dec = 6'b111111;
      12'd2333 :  mem_out_dec = 6'b111111;
      12'd2334 :  mem_out_dec = 6'b111111;
      12'd2335 :  mem_out_dec = 6'b111111;
      12'd2336 :  mem_out_dec = 6'b111111;
      12'd2337 :  mem_out_dec = 6'b111111;
      12'd2338 :  mem_out_dec = 6'b111111;
      12'd2339 :  mem_out_dec = 6'b111111;
      12'd2340 :  mem_out_dec = 6'b111111;
      12'd2341 :  mem_out_dec = 6'b111111;
      12'd2342 :  mem_out_dec = 6'b111111;
      12'd2343 :  mem_out_dec = 6'b111111;
      12'd2344 :  mem_out_dec = 6'b111111;
      12'd2345 :  mem_out_dec = 6'b111111;
      12'd2346 :  mem_out_dec = 6'b000100;
      12'd2347 :  mem_out_dec = 6'b000101;
      12'd2348 :  mem_out_dec = 6'b000110;
      12'd2349 :  mem_out_dec = 6'b000111;
      12'd2350 :  mem_out_dec = 6'b000111;
      12'd2351 :  mem_out_dec = 6'b001000;
      12'd2352 :  mem_out_dec = 6'b001000;
      12'd2353 :  mem_out_dec = 6'b001000;
      12'd2354 :  mem_out_dec = 6'b001000;
      12'd2355 :  mem_out_dec = 6'b001000;
      12'd2356 :  mem_out_dec = 6'b001000;
      12'd2357 :  mem_out_dec = 6'b001000;
      12'd2358 :  mem_out_dec = 6'b001000;
      12'd2359 :  mem_out_dec = 6'b001001;
      12'd2360 :  mem_out_dec = 6'b001001;
      12'd2361 :  mem_out_dec = 6'b001010;
      12'd2362 :  mem_out_dec = 6'b001011;
      12'd2363 :  mem_out_dec = 6'b001100;
      12'd2364 :  mem_out_dec = 6'b001100;
      12'd2365 :  mem_out_dec = 6'b001101;
      12'd2366 :  mem_out_dec = 6'b001110;
      12'd2367 :  mem_out_dec = 6'b001111;
      12'd2368 :  mem_out_dec = 6'b111111;
      12'd2369 :  mem_out_dec = 6'b111111;
      12'd2370 :  mem_out_dec = 6'b111111;
      12'd2371 :  mem_out_dec = 6'b111111;
      12'd2372 :  mem_out_dec = 6'b111111;
      12'd2373 :  mem_out_dec = 6'b111111;
      12'd2374 :  mem_out_dec = 6'b111111;
      12'd2375 :  mem_out_dec = 6'b111111;
      12'd2376 :  mem_out_dec = 6'b111111;
      12'd2377 :  mem_out_dec = 6'b111111;
      12'd2378 :  mem_out_dec = 6'b111111;
      12'd2379 :  mem_out_dec = 6'b111111;
      12'd2380 :  mem_out_dec = 6'b111111;
      12'd2381 :  mem_out_dec = 6'b111111;
      12'd2382 :  mem_out_dec = 6'b111111;
      12'd2383 :  mem_out_dec = 6'b111111;
      12'd2384 :  mem_out_dec = 6'b111111;
      12'd2385 :  mem_out_dec = 6'b111111;
      12'd2386 :  mem_out_dec = 6'b111111;
      12'd2387 :  mem_out_dec = 6'b111111;
      12'd2388 :  mem_out_dec = 6'b111111;
      12'd2389 :  mem_out_dec = 6'b111111;
      12'd2390 :  mem_out_dec = 6'b111111;
      12'd2391 :  mem_out_dec = 6'b111111;
      12'd2392 :  mem_out_dec = 6'b111111;
      12'd2393 :  mem_out_dec = 6'b111111;
      12'd2394 :  mem_out_dec = 6'b111111;
      12'd2395 :  mem_out_dec = 6'b111111;
      12'd2396 :  mem_out_dec = 6'b111111;
      12'd2397 :  mem_out_dec = 6'b111111;
      12'd2398 :  mem_out_dec = 6'b111111;
      12'd2399 :  mem_out_dec = 6'b111111;
      12'd2400 :  mem_out_dec = 6'b111111;
      12'd2401 :  mem_out_dec = 6'b111111;
      12'd2402 :  mem_out_dec = 6'b111111;
      12'd2403 :  mem_out_dec = 6'b111111;
      12'd2404 :  mem_out_dec = 6'b111111;
      12'd2405 :  mem_out_dec = 6'b111111;
      12'd2406 :  mem_out_dec = 6'b111111;
      12'd2407 :  mem_out_dec = 6'b111111;
      12'd2408 :  mem_out_dec = 6'b111111;
      12'd2409 :  mem_out_dec = 6'b111111;
      12'd2410 :  mem_out_dec = 6'b111111;
      12'd2411 :  mem_out_dec = 6'b000101;
      12'd2412 :  mem_out_dec = 6'b000101;
      12'd2413 :  mem_out_dec = 6'b000110;
      12'd2414 :  mem_out_dec = 6'b000111;
      12'd2415 :  mem_out_dec = 6'b001000;
      12'd2416 :  mem_out_dec = 6'b000111;
      12'd2417 :  mem_out_dec = 6'b000111;
      12'd2418 :  mem_out_dec = 6'b000111;
      12'd2419 :  mem_out_dec = 6'b000111;
      12'd2420 :  mem_out_dec = 6'b000111;
      12'd2421 :  mem_out_dec = 6'b000111;
      12'd2422 :  mem_out_dec = 6'b001000;
      12'd2423 :  mem_out_dec = 6'b001001;
      12'd2424 :  mem_out_dec = 6'b001001;
      12'd2425 :  mem_out_dec = 6'b001010;
      12'd2426 :  mem_out_dec = 6'b001010;
      12'd2427 :  mem_out_dec = 6'b001011;
      12'd2428 :  mem_out_dec = 6'b001100;
      12'd2429 :  mem_out_dec = 6'b001101;
      12'd2430 :  mem_out_dec = 6'b001101;
      12'd2431 :  mem_out_dec = 6'b001110;
      12'd2432 :  mem_out_dec = 6'b111111;
      12'd2433 :  mem_out_dec = 6'b111111;
      12'd2434 :  mem_out_dec = 6'b111111;
      12'd2435 :  mem_out_dec = 6'b111111;
      12'd2436 :  mem_out_dec = 6'b111111;
      12'd2437 :  mem_out_dec = 6'b111111;
      12'd2438 :  mem_out_dec = 6'b111111;
      12'd2439 :  mem_out_dec = 6'b111111;
      12'd2440 :  mem_out_dec = 6'b111111;
      12'd2441 :  mem_out_dec = 6'b111111;
      12'd2442 :  mem_out_dec = 6'b111111;
      12'd2443 :  mem_out_dec = 6'b111111;
      12'd2444 :  mem_out_dec = 6'b111111;
      12'd2445 :  mem_out_dec = 6'b111111;
      12'd2446 :  mem_out_dec = 6'b111111;
      12'd2447 :  mem_out_dec = 6'b111111;
      12'd2448 :  mem_out_dec = 6'b111111;
      12'd2449 :  mem_out_dec = 6'b111111;
      12'd2450 :  mem_out_dec = 6'b111111;
      12'd2451 :  mem_out_dec = 6'b111111;
      12'd2452 :  mem_out_dec = 6'b111111;
      12'd2453 :  mem_out_dec = 6'b111111;
      12'd2454 :  mem_out_dec = 6'b111111;
      12'd2455 :  mem_out_dec = 6'b111111;
      12'd2456 :  mem_out_dec = 6'b111111;
      12'd2457 :  mem_out_dec = 6'b111111;
      12'd2458 :  mem_out_dec = 6'b111111;
      12'd2459 :  mem_out_dec = 6'b111111;
      12'd2460 :  mem_out_dec = 6'b111111;
      12'd2461 :  mem_out_dec = 6'b111111;
      12'd2462 :  mem_out_dec = 6'b111111;
      12'd2463 :  mem_out_dec = 6'b111111;
      12'd2464 :  mem_out_dec = 6'b111111;
      12'd2465 :  mem_out_dec = 6'b111111;
      12'd2466 :  mem_out_dec = 6'b111111;
      12'd2467 :  mem_out_dec = 6'b111111;
      12'd2468 :  mem_out_dec = 6'b111111;
      12'd2469 :  mem_out_dec = 6'b111111;
      12'd2470 :  mem_out_dec = 6'b111111;
      12'd2471 :  mem_out_dec = 6'b111111;
      12'd2472 :  mem_out_dec = 6'b111111;
      12'd2473 :  mem_out_dec = 6'b111111;
      12'd2474 :  mem_out_dec = 6'b111111;
      12'd2475 :  mem_out_dec = 6'b111111;
      12'd2476 :  mem_out_dec = 6'b000101;
      12'd2477 :  mem_out_dec = 6'b000110;
      12'd2478 :  mem_out_dec = 6'b000111;
      12'd2479 :  mem_out_dec = 6'b000111;
      12'd2480 :  mem_out_dec = 6'b000110;
      12'd2481 :  mem_out_dec = 6'b000110;
      12'd2482 :  mem_out_dec = 6'b000110;
      12'd2483 :  mem_out_dec = 6'b000110;
      12'd2484 :  mem_out_dec = 6'b000110;
      12'd2485 :  mem_out_dec = 6'b000111;
      12'd2486 :  mem_out_dec = 6'b000111;
      12'd2487 :  mem_out_dec = 6'b001000;
      12'd2488 :  mem_out_dec = 6'b001001;
      12'd2489 :  mem_out_dec = 6'b001001;
      12'd2490 :  mem_out_dec = 6'b001010;
      12'd2491 :  mem_out_dec = 6'b001011;
      12'd2492 :  mem_out_dec = 6'b001011;
      12'd2493 :  mem_out_dec = 6'b001100;
      12'd2494 :  mem_out_dec = 6'b001101;
      12'd2495 :  mem_out_dec = 6'b001110;
      12'd2496 :  mem_out_dec = 6'b111111;
      12'd2497 :  mem_out_dec = 6'b111111;
      12'd2498 :  mem_out_dec = 6'b111111;
      12'd2499 :  mem_out_dec = 6'b111111;
      12'd2500 :  mem_out_dec = 6'b111111;
      12'd2501 :  mem_out_dec = 6'b111111;
      12'd2502 :  mem_out_dec = 6'b111111;
      12'd2503 :  mem_out_dec = 6'b111111;
      12'd2504 :  mem_out_dec = 6'b111111;
      12'd2505 :  mem_out_dec = 6'b111111;
      12'd2506 :  mem_out_dec = 6'b111111;
      12'd2507 :  mem_out_dec = 6'b111111;
      12'd2508 :  mem_out_dec = 6'b111111;
      12'd2509 :  mem_out_dec = 6'b111111;
      12'd2510 :  mem_out_dec = 6'b111111;
      12'd2511 :  mem_out_dec = 6'b111111;
      12'd2512 :  mem_out_dec = 6'b111111;
      12'd2513 :  mem_out_dec = 6'b111111;
      12'd2514 :  mem_out_dec = 6'b111111;
      12'd2515 :  mem_out_dec = 6'b111111;
      12'd2516 :  mem_out_dec = 6'b111111;
      12'd2517 :  mem_out_dec = 6'b111111;
      12'd2518 :  mem_out_dec = 6'b111111;
      12'd2519 :  mem_out_dec = 6'b111111;
      12'd2520 :  mem_out_dec = 6'b111111;
      12'd2521 :  mem_out_dec = 6'b111111;
      12'd2522 :  mem_out_dec = 6'b111111;
      12'd2523 :  mem_out_dec = 6'b111111;
      12'd2524 :  mem_out_dec = 6'b111111;
      12'd2525 :  mem_out_dec = 6'b111111;
      12'd2526 :  mem_out_dec = 6'b111111;
      12'd2527 :  mem_out_dec = 6'b111111;
      12'd2528 :  mem_out_dec = 6'b111111;
      12'd2529 :  mem_out_dec = 6'b111111;
      12'd2530 :  mem_out_dec = 6'b111111;
      12'd2531 :  mem_out_dec = 6'b111111;
      12'd2532 :  mem_out_dec = 6'b111111;
      12'd2533 :  mem_out_dec = 6'b111111;
      12'd2534 :  mem_out_dec = 6'b111111;
      12'd2535 :  mem_out_dec = 6'b111111;
      12'd2536 :  mem_out_dec = 6'b111111;
      12'd2537 :  mem_out_dec = 6'b111111;
      12'd2538 :  mem_out_dec = 6'b111111;
      12'd2539 :  mem_out_dec = 6'b111111;
      12'd2540 :  mem_out_dec = 6'b111111;
      12'd2541 :  mem_out_dec = 6'b000101;
      12'd2542 :  mem_out_dec = 6'b000110;
      12'd2543 :  mem_out_dec = 6'b000110;
      12'd2544 :  mem_out_dec = 6'b000110;
      12'd2545 :  mem_out_dec = 6'b000110;
      12'd2546 :  mem_out_dec = 6'b000101;
      12'd2547 :  mem_out_dec = 6'b000101;
      12'd2548 :  mem_out_dec = 6'b000110;
      12'd2549 :  mem_out_dec = 6'b000111;
      12'd2550 :  mem_out_dec = 6'b000111;
      12'd2551 :  mem_out_dec = 6'b001000;
      12'd2552 :  mem_out_dec = 6'b001000;
      12'd2553 :  mem_out_dec = 6'b001001;
      12'd2554 :  mem_out_dec = 6'b001010;
      12'd2555 :  mem_out_dec = 6'b001010;
      12'd2556 :  mem_out_dec = 6'b001011;
      12'd2557 :  mem_out_dec = 6'b001100;
      12'd2558 :  mem_out_dec = 6'b001101;
      12'd2559 :  mem_out_dec = 6'b001101;
      12'd2560 :  mem_out_dec = 6'b111111;
      12'd2561 :  mem_out_dec = 6'b111111;
      12'd2562 :  mem_out_dec = 6'b111111;
      12'd2563 :  mem_out_dec = 6'b111111;
      12'd2564 :  mem_out_dec = 6'b111111;
      12'd2565 :  mem_out_dec = 6'b111111;
      12'd2566 :  mem_out_dec = 6'b111111;
      12'd2567 :  mem_out_dec = 6'b111111;
      12'd2568 :  mem_out_dec = 6'b111111;
      12'd2569 :  mem_out_dec = 6'b111111;
      12'd2570 :  mem_out_dec = 6'b111111;
      12'd2571 :  mem_out_dec = 6'b111111;
      12'd2572 :  mem_out_dec = 6'b111111;
      12'd2573 :  mem_out_dec = 6'b111111;
      12'd2574 :  mem_out_dec = 6'b111111;
      12'd2575 :  mem_out_dec = 6'b111111;
      12'd2576 :  mem_out_dec = 6'b111111;
      12'd2577 :  mem_out_dec = 6'b111111;
      12'd2578 :  mem_out_dec = 6'b111111;
      12'd2579 :  mem_out_dec = 6'b111111;
      12'd2580 :  mem_out_dec = 6'b111111;
      12'd2581 :  mem_out_dec = 6'b111111;
      12'd2582 :  mem_out_dec = 6'b111111;
      12'd2583 :  mem_out_dec = 6'b111111;
      12'd2584 :  mem_out_dec = 6'b111111;
      12'd2585 :  mem_out_dec = 6'b111111;
      12'd2586 :  mem_out_dec = 6'b111111;
      12'd2587 :  mem_out_dec = 6'b111111;
      12'd2588 :  mem_out_dec = 6'b111111;
      12'd2589 :  mem_out_dec = 6'b111111;
      12'd2590 :  mem_out_dec = 6'b111111;
      12'd2591 :  mem_out_dec = 6'b111111;
      12'd2592 :  mem_out_dec = 6'b111111;
      12'd2593 :  mem_out_dec = 6'b111111;
      12'd2594 :  mem_out_dec = 6'b111111;
      12'd2595 :  mem_out_dec = 6'b111111;
      12'd2596 :  mem_out_dec = 6'b111111;
      12'd2597 :  mem_out_dec = 6'b111111;
      12'd2598 :  mem_out_dec = 6'b111111;
      12'd2599 :  mem_out_dec = 6'b111111;
      12'd2600 :  mem_out_dec = 6'b111111;
      12'd2601 :  mem_out_dec = 6'b111111;
      12'd2602 :  mem_out_dec = 6'b111111;
      12'd2603 :  mem_out_dec = 6'b111111;
      12'd2604 :  mem_out_dec = 6'b111111;
      12'd2605 :  mem_out_dec = 6'b111111;
      12'd2606 :  mem_out_dec = 6'b000100;
      12'd2607 :  mem_out_dec = 6'b000101;
      12'd2608 :  mem_out_dec = 6'b000100;
      12'd2609 :  mem_out_dec = 6'b000100;
      12'd2610 :  mem_out_dec = 6'b000100;
      12'd2611 :  mem_out_dec = 6'b000101;
      12'd2612 :  mem_out_dec = 6'b000101;
      12'd2613 :  mem_out_dec = 6'b000110;
      12'd2614 :  mem_out_dec = 6'b000111;
      12'd2615 :  mem_out_dec = 6'b000111;
      12'd2616 :  mem_out_dec = 6'b000111;
      12'd2617 :  mem_out_dec = 6'b001000;
      12'd2618 :  mem_out_dec = 6'b001001;
      12'd2619 :  mem_out_dec = 6'b001010;
      12'd2620 :  mem_out_dec = 6'b001010;
      12'd2621 :  mem_out_dec = 6'b001011;
      12'd2622 :  mem_out_dec = 6'b001100;
      12'd2623 :  mem_out_dec = 6'b001101;
      12'd2624 :  mem_out_dec = 6'b111111;
      12'd2625 :  mem_out_dec = 6'b111111;
      12'd2626 :  mem_out_dec = 6'b111111;
      12'd2627 :  mem_out_dec = 6'b111111;
      12'd2628 :  mem_out_dec = 6'b111111;
      12'd2629 :  mem_out_dec = 6'b111111;
      12'd2630 :  mem_out_dec = 6'b111111;
      12'd2631 :  mem_out_dec = 6'b111111;
      12'd2632 :  mem_out_dec = 6'b111111;
      12'd2633 :  mem_out_dec = 6'b111111;
      12'd2634 :  mem_out_dec = 6'b111111;
      12'd2635 :  mem_out_dec = 6'b111111;
      12'd2636 :  mem_out_dec = 6'b111111;
      12'd2637 :  mem_out_dec = 6'b111111;
      12'd2638 :  mem_out_dec = 6'b111111;
      12'd2639 :  mem_out_dec = 6'b111111;
      12'd2640 :  mem_out_dec = 6'b111111;
      12'd2641 :  mem_out_dec = 6'b111111;
      12'd2642 :  mem_out_dec = 6'b111111;
      12'd2643 :  mem_out_dec = 6'b111111;
      12'd2644 :  mem_out_dec = 6'b111111;
      12'd2645 :  mem_out_dec = 6'b111111;
      12'd2646 :  mem_out_dec = 6'b111111;
      12'd2647 :  mem_out_dec = 6'b111111;
      12'd2648 :  mem_out_dec = 6'b111111;
      12'd2649 :  mem_out_dec = 6'b111111;
      12'd2650 :  mem_out_dec = 6'b111111;
      12'd2651 :  mem_out_dec = 6'b111111;
      12'd2652 :  mem_out_dec = 6'b111111;
      12'd2653 :  mem_out_dec = 6'b111111;
      12'd2654 :  mem_out_dec = 6'b111111;
      12'd2655 :  mem_out_dec = 6'b111111;
      12'd2656 :  mem_out_dec = 6'b111111;
      12'd2657 :  mem_out_dec = 6'b111111;
      12'd2658 :  mem_out_dec = 6'b111111;
      12'd2659 :  mem_out_dec = 6'b111111;
      12'd2660 :  mem_out_dec = 6'b111111;
      12'd2661 :  mem_out_dec = 6'b111111;
      12'd2662 :  mem_out_dec = 6'b111111;
      12'd2663 :  mem_out_dec = 6'b111111;
      12'd2664 :  mem_out_dec = 6'b111111;
      12'd2665 :  mem_out_dec = 6'b111111;
      12'd2666 :  mem_out_dec = 6'b111111;
      12'd2667 :  mem_out_dec = 6'b111111;
      12'd2668 :  mem_out_dec = 6'b111111;
      12'd2669 :  mem_out_dec = 6'b111111;
      12'd2670 :  mem_out_dec = 6'b111111;
      12'd2671 :  mem_out_dec = 6'b000100;
      12'd2672 :  mem_out_dec = 6'b000011;
      12'd2673 :  mem_out_dec = 6'b000011;
      12'd2674 :  mem_out_dec = 6'b000100;
      12'd2675 :  mem_out_dec = 6'b000100;
      12'd2676 :  mem_out_dec = 6'b000101;
      12'd2677 :  mem_out_dec = 6'b000110;
      12'd2678 :  mem_out_dec = 6'b000110;
      12'd2679 :  mem_out_dec = 6'b000111;
      12'd2680 :  mem_out_dec = 6'b000111;
      12'd2681 :  mem_out_dec = 6'b001000;
      12'd2682 :  mem_out_dec = 6'b001001;
      12'd2683 :  mem_out_dec = 6'b001001;
      12'd2684 :  mem_out_dec = 6'b001010;
      12'd2685 :  mem_out_dec = 6'b001011;
      12'd2686 :  mem_out_dec = 6'b001100;
      12'd2687 :  mem_out_dec = 6'b001100;
      12'd2688 :  mem_out_dec = 6'b111111;
      12'd2689 :  mem_out_dec = 6'b111111;
      12'd2690 :  mem_out_dec = 6'b111111;
      12'd2691 :  mem_out_dec = 6'b111111;
      12'd2692 :  mem_out_dec = 6'b111111;
      12'd2693 :  mem_out_dec = 6'b111111;
      12'd2694 :  mem_out_dec = 6'b111111;
      12'd2695 :  mem_out_dec = 6'b111111;
      12'd2696 :  mem_out_dec = 6'b111111;
      12'd2697 :  mem_out_dec = 6'b111111;
      12'd2698 :  mem_out_dec = 6'b111111;
      12'd2699 :  mem_out_dec = 6'b111111;
      12'd2700 :  mem_out_dec = 6'b111111;
      12'd2701 :  mem_out_dec = 6'b111111;
      12'd2702 :  mem_out_dec = 6'b111111;
      12'd2703 :  mem_out_dec = 6'b111111;
      12'd2704 :  mem_out_dec = 6'b111111;
      12'd2705 :  mem_out_dec = 6'b111111;
      12'd2706 :  mem_out_dec = 6'b111111;
      12'd2707 :  mem_out_dec = 6'b111111;
      12'd2708 :  mem_out_dec = 6'b111111;
      12'd2709 :  mem_out_dec = 6'b111111;
      12'd2710 :  mem_out_dec = 6'b111111;
      12'd2711 :  mem_out_dec = 6'b111111;
      12'd2712 :  mem_out_dec = 6'b111111;
      12'd2713 :  mem_out_dec = 6'b111111;
      12'd2714 :  mem_out_dec = 6'b111111;
      12'd2715 :  mem_out_dec = 6'b111111;
      12'd2716 :  mem_out_dec = 6'b111111;
      12'd2717 :  mem_out_dec = 6'b111111;
      12'd2718 :  mem_out_dec = 6'b111111;
      12'd2719 :  mem_out_dec = 6'b111111;
      12'd2720 :  mem_out_dec = 6'b111111;
      12'd2721 :  mem_out_dec = 6'b111111;
      12'd2722 :  mem_out_dec = 6'b111111;
      12'd2723 :  mem_out_dec = 6'b111111;
      12'd2724 :  mem_out_dec = 6'b111111;
      12'd2725 :  mem_out_dec = 6'b111111;
      12'd2726 :  mem_out_dec = 6'b111111;
      12'd2727 :  mem_out_dec = 6'b111111;
      12'd2728 :  mem_out_dec = 6'b111111;
      12'd2729 :  mem_out_dec = 6'b111111;
      12'd2730 :  mem_out_dec = 6'b111111;
      12'd2731 :  mem_out_dec = 6'b111111;
      12'd2732 :  mem_out_dec = 6'b111111;
      12'd2733 :  mem_out_dec = 6'b111111;
      12'd2734 :  mem_out_dec = 6'b111111;
      12'd2735 :  mem_out_dec = 6'b111111;
      12'd2736 :  mem_out_dec = 6'b000011;
      12'd2737 :  mem_out_dec = 6'b000011;
      12'd2738 :  mem_out_dec = 6'b000100;
      12'd2739 :  mem_out_dec = 6'b000100;
      12'd2740 :  mem_out_dec = 6'b000101;
      12'd2741 :  mem_out_dec = 6'b000101;
      12'd2742 :  mem_out_dec = 6'b000110;
      12'd2743 :  mem_out_dec = 6'b000111;
      12'd2744 :  mem_out_dec = 6'b000111;
      12'd2745 :  mem_out_dec = 6'b001000;
      12'd2746 :  mem_out_dec = 6'b001000;
      12'd2747 :  mem_out_dec = 6'b001001;
      12'd2748 :  mem_out_dec = 6'b001010;
      12'd2749 :  mem_out_dec = 6'b001011;
      12'd2750 :  mem_out_dec = 6'b001011;
      12'd2751 :  mem_out_dec = 6'b001100;
      12'd2752 :  mem_out_dec = 6'b111111;
      12'd2753 :  mem_out_dec = 6'b111111;
      12'd2754 :  mem_out_dec = 6'b111111;
      12'd2755 :  mem_out_dec = 6'b111111;
      12'd2756 :  mem_out_dec = 6'b111111;
      12'd2757 :  mem_out_dec = 6'b111111;
      12'd2758 :  mem_out_dec = 6'b111111;
      12'd2759 :  mem_out_dec = 6'b111111;
      12'd2760 :  mem_out_dec = 6'b111111;
      12'd2761 :  mem_out_dec = 6'b111111;
      12'd2762 :  mem_out_dec = 6'b111111;
      12'd2763 :  mem_out_dec = 6'b111111;
      12'd2764 :  mem_out_dec = 6'b111111;
      12'd2765 :  mem_out_dec = 6'b111111;
      12'd2766 :  mem_out_dec = 6'b111111;
      12'd2767 :  mem_out_dec = 6'b111111;
      12'd2768 :  mem_out_dec = 6'b111111;
      12'd2769 :  mem_out_dec = 6'b111111;
      12'd2770 :  mem_out_dec = 6'b111111;
      12'd2771 :  mem_out_dec = 6'b111111;
      12'd2772 :  mem_out_dec = 6'b111111;
      12'd2773 :  mem_out_dec = 6'b111111;
      12'd2774 :  mem_out_dec = 6'b111111;
      12'd2775 :  mem_out_dec = 6'b111111;
      12'd2776 :  mem_out_dec = 6'b111111;
      12'd2777 :  mem_out_dec = 6'b111111;
      12'd2778 :  mem_out_dec = 6'b111111;
      12'd2779 :  mem_out_dec = 6'b111111;
      12'd2780 :  mem_out_dec = 6'b111111;
      12'd2781 :  mem_out_dec = 6'b111111;
      12'd2782 :  mem_out_dec = 6'b111111;
      12'd2783 :  mem_out_dec = 6'b111111;
      12'd2784 :  mem_out_dec = 6'b111111;
      12'd2785 :  mem_out_dec = 6'b111111;
      12'd2786 :  mem_out_dec = 6'b111111;
      12'd2787 :  mem_out_dec = 6'b111111;
      12'd2788 :  mem_out_dec = 6'b111111;
      12'd2789 :  mem_out_dec = 6'b111111;
      12'd2790 :  mem_out_dec = 6'b111111;
      12'd2791 :  mem_out_dec = 6'b111111;
      12'd2792 :  mem_out_dec = 6'b111111;
      12'd2793 :  mem_out_dec = 6'b111111;
      12'd2794 :  mem_out_dec = 6'b111111;
      12'd2795 :  mem_out_dec = 6'b111111;
      12'd2796 :  mem_out_dec = 6'b111111;
      12'd2797 :  mem_out_dec = 6'b111111;
      12'd2798 :  mem_out_dec = 6'b111111;
      12'd2799 :  mem_out_dec = 6'b111111;
      12'd2800 :  mem_out_dec = 6'b111111;
      12'd2801 :  mem_out_dec = 6'b000011;
      12'd2802 :  mem_out_dec = 6'b000011;
      12'd2803 :  mem_out_dec = 6'b000100;
      12'd2804 :  mem_out_dec = 6'b000101;
      12'd2805 :  mem_out_dec = 6'b000101;
      12'd2806 :  mem_out_dec = 6'b000110;
      12'd2807 :  mem_out_dec = 6'b000111;
      12'd2808 :  mem_out_dec = 6'b000111;
      12'd2809 :  mem_out_dec = 6'b000111;
      12'd2810 :  mem_out_dec = 6'b001000;
      12'd2811 :  mem_out_dec = 6'b001001;
      12'd2812 :  mem_out_dec = 6'b001010;
      12'd2813 :  mem_out_dec = 6'b001010;
      12'd2814 :  mem_out_dec = 6'b001011;
      12'd2815 :  mem_out_dec = 6'b001100;
      12'd2816 :  mem_out_dec = 6'b111111;
      12'd2817 :  mem_out_dec = 6'b111111;
      12'd2818 :  mem_out_dec = 6'b111111;
      12'd2819 :  mem_out_dec = 6'b111111;
      12'd2820 :  mem_out_dec = 6'b111111;
      12'd2821 :  mem_out_dec = 6'b111111;
      12'd2822 :  mem_out_dec = 6'b111111;
      12'd2823 :  mem_out_dec = 6'b111111;
      12'd2824 :  mem_out_dec = 6'b111111;
      12'd2825 :  mem_out_dec = 6'b111111;
      12'd2826 :  mem_out_dec = 6'b111111;
      12'd2827 :  mem_out_dec = 6'b111111;
      12'd2828 :  mem_out_dec = 6'b111111;
      12'd2829 :  mem_out_dec = 6'b111111;
      12'd2830 :  mem_out_dec = 6'b111111;
      12'd2831 :  mem_out_dec = 6'b111111;
      12'd2832 :  mem_out_dec = 6'b111111;
      12'd2833 :  mem_out_dec = 6'b111111;
      12'd2834 :  mem_out_dec = 6'b111111;
      12'd2835 :  mem_out_dec = 6'b111111;
      12'd2836 :  mem_out_dec = 6'b111111;
      12'd2837 :  mem_out_dec = 6'b111111;
      12'd2838 :  mem_out_dec = 6'b111111;
      12'd2839 :  mem_out_dec = 6'b111111;
      12'd2840 :  mem_out_dec = 6'b111111;
      12'd2841 :  mem_out_dec = 6'b111111;
      12'd2842 :  mem_out_dec = 6'b111111;
      12'd2843 :  mem_out_dec = 6'b111111;
      12'd2844 :  mem_out_dec = 6'b111111;
      12'd2845 :  mem_out_dec = 6'b111111;
      12'd2846 :  mem_out_dec = 6'b111111;
      12'd2847 :  mem_out_dec = 6'b111111;
      12'd2848 :  mem_out_dec = 6'b111111;
      12'd2849 :  mem_out_dec = 6'b111111;
      12'd2850 :  mem_out_dec = 6'b111111;
      12'd2851 :  mem_out_dec = 6'b111111;
      12'd2852 :  mem_out_dec = 6'b111111;
      12'd2853 :  mem_out_dec = 6'b111111;
      12'd2854 :  mem_out_dec = 6'b111111;
      12'd2855 :  mem_out_dec = 6'b111111;
      12'd2856 :  mem_out_dec = 6'b111111;
      12'd2857 :  mem_out_dec = 6'b111111;
      12'd2858 :  mem_out_dec = 6'b111111;
      12'd2859 :  mem_out_dec = 6'b111111;
      12'd2860 :  mem_out_dec = 6'b111111;
      12'd2861 :  mem_out_dec = 6'b111111;
      12'd2862 :  mem_out_dec = 6'b111111;
      12'd2863 :  mem_out_dec = 6'b111111;
      12'd2864 :  mem_out_dec = 6'b111111;
      12'd2865 :  mem_out_dec = 6'b111111;
      12'd2866 :  mem_out_dec = 6'b000011;
      12'd2867 :  mem_out_dec = 6'b000100;
      12'd2868 :  mem_out_dec = 6'b000100;
      12'd2869 :  mem_out_dec = 6'b000101;
      12'd2870 :  mem_out_dec = 6'b000110;
      12'd2871 :  mem_out_dec = 6'b000110;
      12'd2872 :  mem_out_dec = 6'b000110;
      12'd2873 :  mem_out_dec = 6'b000111;
      12'd2874 :  mem_out_dec = 6'b001000;
      12'd2875 :  mem_out_dec = 6'b001001;
      12'd2876 :  mem_out_dec = 6'b001001;
      12'd2877 :  mem_out_dec = 6'b001010;
      12'd2878 :  mem_out_dec = 6'b001011;
      12'd2879 :  mem_out_dec = 6'b001100;
      12'd2880 :  mem_out_dec = 6'b111111;
      12'd2881 :  mem_out_dec = 6'b111111;
      12'd2882 :  mem_out_dec = 6'b111111;
      12'd2883 :  mem_out_dec = 6'b111111;
      12'd2884 :  mem_out_dec = 6'b111111;
      12'd2885 :  mem_out_dec = 6'b111111;
      12'd2886 :  mem_out_dec = 6'b111111;
      12'd2887 :  mem_out_dec = 6'b111111;
      12'd2888 :  mem_out_dec = 6'b111111;
      12'd2889 :  mem_out_dec = 6'b111111;
      12'd2890 :  mem_out_dec = 6'b111111;
      12'd2891 :  mem_out_dec = 6'b111111;
      12'd2892 :  mem_out_dec = 6'b111111;
      12'd2893 :  mem_out_dec = 6'b111111;
      12'd2894 :  mem_out_dec = 6'b111111;
      12'd2895 :  mem_out_dec = 6'b111111;
      12'd2896 :  mem_out_dec = 6'b111111;
      12'd2897 :  mem_out_dec = 6'b111111;
      12'd2898 :  mem_out_dec = 6'b111111;
      12'd2899 :  mem_out_dec = 6'b111111;
      12'd2900 :  mem_out_dec = 6'b111111;
      12'd2901 :  mem_out_dec = 6'b111111;
      12'd2902 :  mem_out_dec = 6'b111111;
      12'd2903 :  mem_out_dec = 6'b111111;
      12'd2904 :  mem_out_dec = 6'b111111;
      12'd2905 :  mem_out_dec = 6'b111111;
      12'd2906 :  mem_out_dec = 6'b111111;
      12'd2907 :  mem_out_dec = 6'b111111;
      12'd2908 :  mem_out_dec = 6'b111111;
      12'd2909 :  mem_out_dec = 6'b111111;
      12'd2910 :  mem_out_dec = 6'b111111;
      12'd2911 :  mem_out_dec = 6'b111111;
      12'd2912 :  mem_out_dec = 6'b111111;
      12'd2913 :  mem_out_dec = 6'b111111;
      12'd2914 :  mem_out_dec = 6'b111111;
      12'd2915 :  mem_out_dec = 6'b111111;
      12'd2916 :  mem_out_dec = 6'b111111;
      12'd2917 :  mem_out_dec = 6'b111111;
      12'd2918 :  mem_out_dec = 6'b111111;
      12'd2919 :  mem_out_dec = 6'b111111;
      12'd2920 :  mem_out_dec = 6'b111111;
      12'd2921 :  mem_out_dec = 6'b111111;
      12'd2922 :  mem_out_dec = 6'b111111;
      12'd2923 :  mem_out_dec = 6'b111111;
      12'd2924 :  mem_out_dec = 6'b111111;
      12'd2925 :  mem_out_dec = 6'b111111;
      12'd2926 :  mem_out_dec = 6'b111111;
      12'd2927 :  mem_out_dec = 6'b111111;
      12'd2928 :  mem_out_dec = 6'b111111;
      12'd2929 :  mem_out_dec = 6'b111111;
      12'd2930 :  mem_out_dec = 6'b111111;
      12'd2931 :  mem_out_dec = 6'b000100;
      12'd2932 :  mem_out_dec = 6'b000100;
      12'd2933 :  mem_out_dec = 6'b000101;
      12'd2934 :  mem_out_dec = 6'b000101;
      12'd2935 :  mem_out_dec = 6'b000110;
      12'd2936 :  mem_out_dec = 6'b000110;
      12'd2937 :  mem_out_dec = 6'b000111;
      12'd2938 :  mem_out_dec = 6'b001000;
      12'd2939 :  mem_out_dec = 6'b001000;
      12'd2940 :  mem_out_dec = 6'b001001;
      12'd2941 :  mem_out_dec = 6'b001010;
      12'd2942 :  mem_out_dec = 6'b001011;
      12'd2943 :  mem_out_dec = 6'b001011;
      12'd2944 :  mem_out_dec = 6'b111111;
      12'd2945 :  mem_out_dec = 6'b111111;
      12'd2946 :  mem_out_dec = 6'b111111;
      12'd2947 :  mem_out_dec = 6'b111111;
      12'd2948 :  mem_out_dec = 6'b111111;
      12'd2949 :  mem_out_dec = 6'b111111;
      12'd2950 :  mem_out_dec = 6'b111111;
      12'd2951 :  mem_out_dec = 6'b111111;
      12'd2952 :  mem_out_dec = 6'b111111;
      12'd2953 :  mem_out_dec = 6'b111111;
      12'd2954 :  mem_out_dec = 6'b111111;
      12'd2955 :  mem_out_dec = 6'b111111;
      12'd2956 :  mem_out_dec = 6'b111111;
      12'd2957 :  mem_out_dec = 6'b111111;
      12'd2958 :  mem_out_dec = 6'b111111;
      12'd2959 :  mem_out_dec = 6'b111111;
      12'd2960 :  mem_out_dec = 6'b111111;
      12'd2961 :  mem_out_dec = 6'b111111;
      12'd2962 :  mem_out_dec = 6'b111111;
      12'd2963 :  mem_out_dec = 6'b111111;
      12'd2964 :  mem_out_dec = 6'b111111;
      12'd2965 :  mem_out_dec = 6'b111111;
      12'd2966 :  mem_out_dec = 6'b111111;
      12'd2967 :  mem_out_dec = 6'b111111;
      12'd2968 :  mem_out_dec = 6'b111111;
      12'd2969 :  mem_out_dec = 6'b111111;
      12'd2970 :  mem_out_dec = 6'b111111;
      12'd2971 :  mem_out_dec = 6'b111111;
      12'd2972 :  mem_out_dec = 6'b111111;
      12'd2973 :  mem_out_dec = 6'b111111;
      12'd2974 :  mem_out_dec = 6'b111111;
      12'd2975 :  mem_out_dec = 6'b111111;
      12'd2976 :  mem_out_dec = 6'b111111;
      12'd2977 :  mem_out_dec = 6'b111111;
      12'd2978 :  mem_out_dec = 6'b111111;
      12'd2979 :  mem_out_dec = 6'b111111;
      12'd2980 :  mem_out_dec = 6'b111111;
      12'd2981 :  mem_out_dec = 6'b111111;
      12'd2982 :  mem_out_dec = 6'b111111;
      12'd2983 :  mem_out_dec = 6'b111111;
      12'd2984 :  mem_out_dec = 6'b111111;
      12'd2985 :  mem_out_dec = 6'b111111;
      12'd2986 :  mem_out_dec = 6'b111111;
      12'd2987 :  mem_out_dec = 6'b111111;
      12'd2988 :  mem_out_dec = 6'b111111;
      12'd2989 :  mem_out_dec = 6'b111111;
      12'd2990 :  mem_out_dec = 6'b111111;
      12'd2991 :  mem_out_dec = 6'b111111;
      12'd2992 :  mem_out_dec = 6'b111111;
      12'd2993 :  mem_out_dec = 6'b111111;
      12'd2994 :  mem_out_dec = 6'b111111;
      12'd2995 :  mem_out_dec = 6'b111111;
      12'd2996 :  mem_out_dec = 6'b000100;
      12'd2997 :  mem_out_dec = 6'b000101;
      12'd2998 :  mem_out_dec = 6'b000101;
      12'd2999 :  mem_out_dec = 6'b000110;
      12'd3000 :  mem_out_dec = 6'b000110;
      12'd3001 :  mem_out_dec = 6'b000111;
      12'd3002 :  mem_out_dec = 6'b000111;
      12'd3003 :  mem_out_dec = 6'b001000;
      12'd3004 :  mem_out_dec = 6'b001001;
      12'd3005 :  mem_out_dec = 6'b001010;
      12'd3006 :  mem_out_dec = 6'b001010;
      12'd3007 :  mem_out_dec = 6'b001011;
      12'd3008 :  mem_out_dec = 6'b111111;
      12'd3009 :  mem_out_dec = 6'b111111;
      12'd3010 :  mem_out_dec = 6'b111111;
      12'd3011 :  mem_out_dec = 6'b111111;
      12'd3012 :  mem_out_dec = 6'b111111;
      12'd3013 :  mem_out_dec = 6'b111111;
      12'd3014 :  mem_out_dec = 6'b111111;
      12'd3015 :  mem_out_dec = 6'b111111;
      12'd3016 :  mem_out_dec = 6'b111111;
      12'd3017 :  mem_out_dec = 6'b111111;
      12'd3018 :  mem_out_dec = 6'b111111;
      12'd3019 :  mem_out_dec = 6'b111111;
      12'd3020 :  mem_out_dec = 6'b111111;
      12'd3021 :  mem_out_dec = 6'b111111;
      12'd3022 :  mem_out_dec = 6'b111111;
      12'd3023 :  mem_out_dec = 6'b111111;
      12'd3024 :  mem_out_dec = 6'b111111;
      12'd3025 :  mem_out_dec = 6'b111111;
      12'd3026 :  mem_out_dec = 6'b111111;
      12'd3027 :  mem_out_dec = 6'b111111;
      12'd3028 :  mem_out_dec = 6'b111111;
      12'd3029 :  mem_out_dec = 6'b111111;
      12'd3030 :  mem_out_dec = 6'b111111;
      12'd3031 :  mem_out_dec = 6'b111111;
      12'd3032 :  mem_out_dec = 6'b111111;
      12'd3033 :  mem_out_dec = 6'b111111;
      12'd3034 :  mem_out_dec = 6'b111111;
      12'd3035 :  mem_out_dec = 6'b111111;
      12'd3036 :  mem_out_dec = 6'b111111;
      12'd3037 :  mem_out_dec = 6'b111111;
      12'd3038 :  mem_out_dec = 6'b111111;
      12'd3039 :  mem_out_dec = 6'b111111;
      12'd3040 :  mem_out_dec = 6'b111111;
      12'd3041 :  mem_out_dec = 6'b111111;
      12'd3042 :  mem_out_dec = 6'b111111;
      12'd3043 :  mem_out_dec = 6'b111111;
      12'd3044 :  mem_out_dec = 6'b111111;
      12'd3045 :  mem_out_dec = 6'b111111;
      12'd3046 :  mem_out_dec = 6'b111111;
      12'd3047 :  mem_out_dec = 6'b111111;
      12'd3048 :  mem_out_dec = 6'b111111;
      12'd3049 :  mem_out_dec = 6'b111111;
      12'd3050 :  mem_out_dec = 6'b111111;
      12'd3051 :  mem_out_dec = 6'b111111;
      12'd3052 :  mem_out_dec = 6'b111111;
      12'd3053 :  mem_out_dec = 6'b111111;
      12'd3054 :  mem_out_dec = 6'b111111;
      12'd3055 :  mem_out_dec = 6'b111111;
      12'd3056 :  mem_out_dec = 6'b111111;
      12'd3057 :  mem_out_dec = 6'b111111;
      12'd3058 :  mem_out_dec = 6'b111111;
      12'd3059 :  mem_out_dec = 6'b111111;
      12'd3060 :  mem_out_dec = 6'b111111;
      12'd3061 :  mem_out_dec = 6'b000100;
      12'd3062 :  mem_out_dec = 6'b000101;
      12'd3063 :  mem_out_dec = 6'b000110;
      12'd3064 :  mem_out_dec = 6'b000110;
      12'd3065 :  mem_out_dec = 6'b000111;
      12'd3066 :  mem_out_dec = 6'b000111;
      12'd3067 :  mem_out_dec = 6'b001000;
      12'd3068 :  mem_out_dec = 6'b001001;
      12'd3069 :  mem_out_dec = 6'b001001;
      12'd3070 :  mem_out_dec = 6'b001010;
      12'd3071 :  mem_out_dec = 6'b001011;
      12'd3072 :  mem_out_dec = 6'b111111;
      12'd3073 :  mem_out_dec = 6'b111111;
      12'd3074 :  mem_out_dec = 6'b111111;
      12'd3075 :  mem_out_dec = 6'b111111;
      12'd3076 :  mem_out_dec = 6'b111111;
      12'd3077 :  mem_out_dec = 6'b111111;
      12'd3078 :  mem_out_dec = 6'b111111;
      12'd3079 :  mem_out_dec = 6'b111111;
      12'd3080 :  mem_out_dec = 6'b111111;
      12'd3081 :  mem_out_dec = 6'b111111;
      12'd3082 :  mem_out_dec = 6'b111111;
      12'd3083 :  mem_out_dec = 6'b111111;
      12'd3084 :  mem_out_dec = 6'b111111;
      12'd3085 :  mem_out_dec = 6'b111111;
      12'd3086 :  mem_out_dec = 6'b111111;
      12'd3087 :  mem_out_dec = 6'b111111;
      12'd3088 :  mem_out_dec = 6'b111111;
      12'd3089 :  mem_out_dec = 6'b111111;
      12'd3090 :  mem_out_dec = 6'b111111;
      12'd3091 :  mem_out_dec = 6'b111111;
      12'd3092 :  mem_out_dec = 6'b111111;
      12'd3093 :  mem_out_dec = 6'b111111;
      12'd3094 :  mem_out_dec = 6'b111111;
      12'd3095 :  mem_out_dec = 6'b111111;
      12'd3096 :  mem_out_dec = 6'b111111;
      12'd3097 :  mem_out_dec = 6'b111111;
      12'd3098 :  mem_out_dec = 6'b111111;
      12'd3099 :  mem_out_dec = 6'b111111;
      12'd3100 :  mem_out_dec = 6'b111111;
      12'd3101 :  mem_out_dec = 6'b111111;
      12'd3102 :  mem_out_dec = 6'b111111;
      12'd3103 :  mem_out_dec = 6'b111111;
      12'd3104 :  mem_out_dec = 6'b111111;
      12'd3105 :  mem_out_dec = 6'b111111;
      12'd3106 :  mem_out_dec = 6'b111111;
      12'd3107 :  mem_out_dec = 6'b111111;
      12'd3108 :  mem_out_dec = 6'b111111;
      12'd3109 :  mem_out_dec = 6'b111111;
      12'd3110 :  mem_out_dec = 6'b111111;
      12'd3111 :  mem_out_dec = 6'b111111;
      12'd3112 :  mem_out_dec = 6'b111111;
      12'd3113 :  mem_out_dec = 6'b111111;
      12'd3114 :  mem_out_dec = 6'b111111;
      12'd3115 :  mem_out_dec = 6'b111111;
      12'd3116 :  mem_out_dec = 6'b111111;
      12'd3117 :  mem_out_dec = 6'b111111;
      12'd3118 :  mem_out_dec = 6'b111111;
      12'd3119 :  mem_out_dec = 6'b111111;
      12'd3120 :  mem_out_dec = 6'b111111;
      12'd3121 :  mem_out_dec = 6'b111111;
      12'd3122 :  mem_out_dec = 6'b111111;
      12'd3123 :  mem_out_dec = 6'b111111;
      12'd3124 :  mem_out_dec = 6'b111111;
      12'd3125 :  mem_out_dec = 6'b111111;
      12'd3126 :  mem_out_dec = 6'b000100;
      12'd3127 :  mem_out_dec = 6'b000101;
      12'd3128 :  mem_out_dec = 6'b000101;
      12'd3129 :  mem_out_dec = 6'b000110;
      12'd3130 :  mem_out_dec = 6'b000110;
      12'd3131 :  mem_out_dec = 6'b000111;
      12'd3132 :  mem_out_dec = 6'b001000;
      12'd3133 :  mem_out_dec = 6'b001000;
      12'd3134 :  mem_out_dec = 6'b001001;
      12'd3135 :  mem_out_dec = 6'b001010;
      12'd3136 :  mem_out_dec = 6'b111111;
      12'd3137 :  mem_out_dec = 6'b111111;
      12'd3138 :  mem_out_dec = 6'b111111;
      12'd3139 :  mem_out_dec = 6'b111111;
      12'd3140 :  mem_out_dec = 6'b111111;
      12'd3141 :  mem_out_dec = 6'b111111;
      12'd3142 :  mem_out_dec = 6'b111111;
      12'd3143 :  mem_out_dec = 6'b111111;
      12'd3144 :  mem_out_dec = 6'b111111;
      12'd3145 :  mem_out_dec = 6'b111111;
      12'd3146 :  mem_out_dec = 6'b111111;
      12'd3147 :  mem_out_dec = 6'b111111;
      12'd3148 :  mem_out_dec = 6'b111111;
      12'd3149 :  mem_out_dec = 6'b111111;
      12'd3150 :  mem_out_dec = 6'b111111;
      12'd3151 :  mem_out_dec = 6'b111111;
      12'd3152 :  mem_out_dec = 6'b111111;
      12'd3153 :  mem_out_dec = 6'b111111;
      12'd3154 :  mem_out_dec = 6'b111111;
      12'd3155 :  mem_out_dec = 6'b111111;
      12'd3156 :  mem_out_dec = 6'b111111;
      12'd3157 :  mem_out_dec = 6'b111111;
      12'd3158 :  mem_out_dec = 6'b111111;
      12'd3159 :  mem_out_dec = 6'b111111;
      12'd3160 :  mem_out_dec = 6'b111111;
      12'd3161 :  mem_out_dec = 6'b111111;
      12'd3162 :  mem_out_dec = 6'b111111;
      12'd3163 :  mem_out_dec = 6'b111111;
      12'd3164 :  mem_out_dec = 6'b111111;
      12'd3165 :  mem_out_dec = 6'b111111;
      12'd3166 :  mem_out_dec = 6'b111111;
      12'd3167 :  mem_out_dec = 6'b111111;
      12'd3168 :  mem_out_dec = 6'b111111;
      12'd3169 :  mem_out_dec = 6'b111111;
      12'd3170 :  mem_out_dec = 6'b111111;
      12'd3171 :  mem_out_dec = 6'b111111;
      12'd3172 :  mem_out_dec = 6'b111111;
      12'd3173 :  mem_out_dec = 6'b111111;
      12'd3174 :  mem_out_dec = 6'b111111;
      12'd3175 :  mem_out_dec = 6'b111111;
      12'd3176 :  mem_out_dec = 6'b111111;
      12'd3177 :  mem_out_dec = 6'b111111;
      12'd3178 :  mem_out_dec = 6'b111111;
      12'd3179 :  mem_out_dec = 6'b111111;
      12'd3180 :  mem_out_dec = 6'b111111;
      12'd3181 :  mem_out_dec = 6'b111111;
      12'd3182 :  mem_out_dec = 6'b111111;
      12'd3183 :  mem_out_dec = 6'b111111;
      12'd3184 :  mem_out_dec = 6'b111111;
      12'd3185 :  mem_out_dec = 6'b111111;
      12'd3186 :  mem_out_dec = 6'b111111;
      12'd3187 :  mem_out_dec = 6'b111111;
      12'd3188 :  mem_out_dec = 6'b111111;
      12'd3189 :  mem_out_dec = 6'b111111;
      12'd3190 :  mem_out_dec = 6'b111111;
      12'd3191 :  mem_out_dec = 6'b000100;
      12'd3192 :  mem_out_dec = 6'b000100;
      12'd3193 :  mem_out_dec = 6'b000101;
      12'd3194 :  mem_out_dec = 6'b000110;
      12'd3195 :  mem_out_dec = 6'b000110;
      12'd3196 :  mem_out_dec = 6'b000111;
      12'd3197 :  mem_out_dec = 6'b001000;
      12'd3198 :  mem_out_dec = 6'b001000;
      12'd3199 :  mem_out_dec = 6'b001001;
      12'd3200 :  mem_out_dec = 6'b111111;
      12'd3201 :  mem_out_dec = 6'b111111;
      12'd3202 :  mem_out_dec = 6'b111111;
      12'd3203 :  mem_out_dec = 6'b111111;
      12'd3204 :  mem_out_dec = 6'b111111;
      12'd3205 :  mem_out_dec = 6'b111111;
      12'd3206 :  mem_out_dec = 6'b111111;
      12'd3207 :  mem_out_dec = 6'b111111;
      12'd3208 :  mem_out_dec = 6'b111111;
      12'd3209 :  mem_out_dec = 6'b111111;
      12'd3210 :  mem_out_dec = 6'b111111;
      12'd3211 :  mem_out_dec = 6'b111111;
      12'd3212 :  mem_out_dec = 6'b111111;
      12'd3213 :  mem_out_dec = 6'b111111;
      12'd3214 :  mem_out_dec = 6'b111111;
      12'd3215 :  mem_out_dec = 6'b111111;
      12'd3216 :  mem_out_dec = 6'b111111;
      12'd3217 :  mem_out_dec = 6'b111111;
      12'd3218 :  mem_out_dec = 6'b111111;
      12'd3219 :  mem_out_dec = 6'b111111;
      12'd3220 :  mem_out_dec = 6'b111111;
      12'd3221 :  mem_out_dec = 6'b111111;
      12'd3222 :  mem_out_dec = 6'b111111;
      12'd3223 :  mem_out_dec = 6'b111111;
      12'd3224 :  mem_out_dec = 6'b111111;
      12'd3225 :  mem_out_dec = 6'b111111;
      12'd3226 :  mem_out_dec = 6'b111111;
      12'd3227 :  mem_out_dec = 6'b111111;
      12'd3228 :  mem_out_dec = 6'b111111;
      12'd3229 :  mem_out_dec = 6'b111111;
      12'd3230 :  mem_out_dec = 6'b111111;
      12'd3231 :  mem_out_dec = 6'b111111;
      12'd3232 :  mem_out_dec = 6'b111111;
      12'd3233 :  mem_out_dec = 6'b111111;
      12'd3234 :  mem_out_dec = 6'b111111;
      12'd3235 :  mem_out_dec = 6'b111111;
      12'd3236 :  mem_out_dec = 6'b111111;
      12'd3237 :  mem_out_dec = 6'b111111;
      12'd3238 :  mem_out_dec = 6'b111111;
      12'd3239 :  mem_out_dec = 6'b111111;
      12'd3240 :  mem_out_dec = 6'b111111;
      12'd3241 :  mem_out_dec = 6'b111111;
      12'd3242 :  mem_out_dec = 6'b111111;
      12'd3243 :  mem_out_dec = 6'b111111;
      12'd3244 :  mem_out_dec = 6'b111111;
      12'd3245 :  mem_out_dec = 6'b111111;
      12'd3246 :  mem_out_dec = 6'b111111;
      12'd3247 :  mem_out_dec = 6'b111111;
      12'd3248 :  mem_out_dec = 6'b111111;
      12'd3249 :  mem_out_dec = 6'b111111;
      12'd3250 :  mem_out_dec = 6'b111111;
      12'd3251 :  mem_out_dec = 6'b111111;
      12'd3252 :  mem_out_dec = 6'b111111;
      12'd3253 :  mem_out_dec = 6'b111111;
      12'd3254 :  mem_out_dec = 6'b111111;
      12'd3255 :  mem_out_dec = 6'b111111;
      12'd3256 :  mem_out_dec = 6'b000100;
      12'd3257 :  mem_out_dec = 6'b000100;
      12'd3258 :  mem_out_dec = 6'b000101;
      12'd3259 :  mem_out_dec = 6'b000110;
      12'd3260 :  mem_out_dec = 6'b000110;
      12'd3261 :  mem_out_dec = 6'b000111;
      12'd3262 :  mem_out_dec = 6'b001000;
      12'd3263 :  mem_out_dec = 6'b001001;
      12'd3264 :  mem_out_dec = 6'b111111;
      12'd3265 :  mem_out_dec = 6'b111111;
      12'd3266 :  mem_out_dec = 6'b111111;
      12'd3267 :  mem_out_dec = 6'b111111;
      12'd3268 :  mem_out_dec = 6'b111111;
      12'd3269 :  mem_out_dec = 6'b111111;
      12'd3270 :  mem_out_dec = 6'b111111;
      12'd3271 :  mem_out_dec = 6'b111111;
      12'd3272 :  mem_out_dec = 6'b111111;
      12'd3273 :  mem_out_dec = 6'b111111;
      12'd3274 :  mem_out_dec = 6'b111111;
      12'd3275 :  mem_out_dec = 6'b111111;
      12'd3276 :  mem_out_dec = 6'b111111;
      12'd3277 :  mem_out_dec = 6'b111111;
      12'd3278 :  mem_out_dec = 6'b111111;
      12'd3279 :  mem_out_dec = 6'b111111;
      12'd3280 :  mem_out_dec = 6'b111111;
      12'd3281 :  mem_out_dec = 6'b111111;
      12'd3282 :  mem_out_dec = 6'b111111;
      12'd3283 :  mem_out_dec = 6'b111111;
      12'd3284 :  mem_out_dec = 6'b111111;
      12'd3285 :  mem_out_dec = 6'b111111;
      12'd3286 :  mem_out_dec = 6'b111111;
      12'd3287 :  mem_out_dec = 6'b111111;
      12'd3288 :  mem_out_dec = 6'b111111;
      12'd3289 :  mem_out_dec = 6'b111111;
      12'd3290 :  mem_out_dec = 6'b111111;
      12'd3291 :  mem_out_dec = 6'b111111;
      12'd3292 :  mem_out_dec = 6'b111111;
      12'd3293 :  mem_out_dec = 6'b111111;
      12'd3294 :  mem_out_dec = 6'b111111;
      12'd3295 :  mem_out_dec = 6'b111111;
      12'd3296 :  mem_out_dec = 6'b111111;
      12'd3297 :  mem_out_dec = 6'b111111;
      12'd3298 :  mem_out_dec = 6'b111111;
      12'd3299 :  mem_out_dec = 6'b111111;
      12'd3300 :  mem_out_dec = 6'b111111;
      12'd3301 :  mem_out_dec = 6'b111111;
      12'd3302 :  mem_out_dec = 6'b111111;
      12'd3303 :  mem_out_dec = 6'b111111;
      12'd3304 :  mem_out_dec = 6'b111111;
      12'd3305 :  mem_out_dec = 6'b111111;
      12'd3306 :  mem_out_dec = 6'b111111;
      12'd3307 :  mem_out_dec = 6'b111111;
      12'd3308 :  mem_out_dec = 6'b111111;
      12'd3309 :  mem_out_dec = 6'b111111;
      12'd3310 :  mem_out_dec = 6'b111111;
      12'd3311 :  mem_out_dec = 6'b111111;
      12'd3312 :  mem_out_dec = 6'b111111;
      12'd3313 :  mem_out_dec = 6'b111111;
      12'd3314 :  mem_out_dec = 6'b111111;
      12'd3315 :  mem_out_dec = 6'b111111;
      12'd3316 :  mem_out_dec = 6'b111111;
      12'd3317 :  mem_out_dec = 6'b111111;
      12'd3318 :  mem_out_dec = 6'b111111;
      12'd3319 :  mem_out_dec = 6'b111111;
      12'd3320 :  mem_out_dec = 6'b111111;
      12'd3321 :  mem_out_dec = 6'b000100;
      12'd3322 :  mem_out_dec = 6'b000100;
      12'd3323 :  mem_out_dec = 6'b000101;
      12'd3324 :  mem_out_dec = 6'b000110;
      12'd3325 :  mem_out_dec = 6'b000111;
      12'd3326 :  mem_out_dec = 6'b001000;
      12'd3327 :  mem_out_dec = 6'b001000;
      12'd3328 :  mem_out_dec = 6'b111111;
      12'd3329 :  mem_out_dec = 6'b111111;
      12'd3330 :  mem_out_dec = 6'b111111;
      12'd3331 :  mem_out_dec = 6'b111111;
      12'd3332 :  mem_out_dec = 6'b111111;
      12'd3333 :  mem_out_dec = 6'b111111;
      12'd3334 :  mem_out_dec = 6'b111111;
      12'd3335 :  mem_out_dec = 6'b111111;
      12'd3336 :  mem_out_dec = 6'b111111;
      12'd3337 :  mem_out_dec = 6'b111111;
      12'd3338 :  mem_out_dec = 6'b111111;
      12'd3339 :  mem_out_dec = 6'b111111;
      12'd3340 :  mem_out_dec = 6'b111111;
      12'd3341 :  mem_out_dec = 6'b111111;
      12'd3342 :  mem_out_dec = 6'b111111;
      12'd3343 :  mem_out_dec = 6'b111111;
      12'd3344 :  mem_out_dec = 6'b111111;
      12'd3345 :  mem_out_dec = 6'b111111;
      12'd3346 :  mem_out_dec = 6'b111111;
      12'd3347 :  mem_out_dec = 6'b111111;
      12'd3348 :  mem_out_dec = 6'b111111;
      12'd3349 :  mem_out_dec = 6'b111111;
      12'd3350 :  mem_out_dec = 6'b111111;
      12'd3351 :  mem_out_dec = 6'b111111;
      12'd3352 :  mem_out_dec = 6'b111111;
      12'd3353 :  mem_out_dec = 6'b111111;
      12'd3354 :  mem_out_dec = 6'b111111;
      12'd3355 :  mem_out_dec = 6'b111111;
      12'd3356 :  mem_out_dec = 6'b111111;
      12'd3357 :  mem_out_dec = 6'b111111;
      12'd3358 :  mem_out_dec = 6'b111111;
      12'd3359 :  mem_out_dec = 6'b111111;
      12'd3360 :  mem_out_dec = 6'b111111;
      12'd3361 :  mem_out_dec = 6'b111111;
      12'd3362 :  mem_out_dec = 6'b111111;
      12'd3363 :  mem_out_dec = 6'b111111;
      12'd3364 :  mem_out_dec = 6'b111111;
      12'd3365 :  mem_out_dec = 6'b111111;
      12'd3366 :  mem_out_dec = 6'b111111;
      12'd3367 :  mem_out_dec = 6'b111111;
      12'd3368 :  mem_out_dec = 6'b111111;
      12'd3369 :  mem_out_dec = 6'b111111;
      12'd3370 :  mem_out_dec = 6'b111111;
      12'd3371 :  mem_out_dec = 6'b111111;
      12'd3372 :  mem_out_dec = 6'b111111;
      12'd3373 :  mem_out_dec = 6'b111111;
      12'd3374 :  mem_out_dec = 6'b111111;
      12'd3375 :  mem_out_dec = 6'b111111;
      12'd3376 :  mem_out_dec = 6'b111111;
      12'd3377 :  mem_out_dec = 6'b111111;
      12'd3378 :  mem_out_dec = 6'b111111;
      12'd3379 :  mem_out_dec = 6'b111111;
      12'd3380 :  mem_out_dec = 6'b111111;
      12'd3381 :  mem_out_dec = 6'b111111;
      12'd3382 :  mem_out_dec = 6'b111111;
      12'd3383 :  mem_out_dec = 6'b111111;
      12'd3384 :  mem_out_dec = 6'b111111;
      12'd3385 :  mem_out_dec = 6'b111111;
      12'd3386 :  mem_out_dec = 6'b000100;
      12'd3387 :  mem_out_dec = 6'b000101;
      12'd3388 :  mem_out_dec = 6'b000110;
      12'd3389 :  mem_out_dec = 6'b000110;
      12'd3390 :  mem_out_dec = 6'b000111;
      12'd3391 :  mem_out_dec = 6'b001000;
      12'd3392 :  mem_out_dec = 6'b111111;
      12'd3393 :  mem_out_dec = 6'b111111;
      12'd3394 :  mem_out_dec = 6'b111111;
      12'd3395 :  mem_out_dec = 6'b111111;
      12'd3396 :  mem_out_dec = 6'b111111;
      12'd3397 :  mem_out_dec = 6'b111111;
      12'd3398 :  mem_out_dec = 6'b111111;
      12'd3399 :  mem_out_dec = 6'b111111;
      12'd3400 :  mem_out_dec = 6'b111111;
      12'd3401 :  mem_out_dec = 6'b111111;
      12'd3402 :  mem_out_dec = 6'b111111;
      12'd3403 :  mem_out_dec = 6'b111111;
      12'd3404 :  mem_out_dec = 6'b111111;
      12'd3405 :  mem_out_dec = 6'b111111;
      12'd3406 :  mem_out_dec = 6'b111111;
      12'd3407 :  mem_out_dec = 6'b111111;
      12'd3408 :  mem_out_dec = 6'b111111;
      12'd3409 :  mem_out_dec = 6'b111111;
      12'd3410 :  mem_out_dec = 6'b111111;
      12'd3411 :  mem_out_dec = 6'b111111;
      12'd3412 :  mem_out_dec = 6'b111111;
      12'd3413 :  mem_out_dec = 6'b111111;
      12'd3414 :  mem_out_dec = 6'b111111;
      12'd3415 :  mem_out_dec = 6'b111111;
      12'd3416 :  mem_out_dec = 6'b111111;
      12'd3417 :  mem_out_dec = 6'b111111;
      12'd3418 :  mem_out_dec = 6'b111111;
      12'd3419 :  mem_out_dec = 6'b111111;
      12'd3420 :  mem_out_dec = 6'b111111;
      12'd3421 :  mem_out_dec = 6'b111111;
      12'd3422 :  mem_out_dec = 6'b111111;
      12'd3423 :  mem_out_dec = 6'b111111;
      12'd3424 :  mem_out_dec = 6'b111111;
      12'd3425 :  mem_out_dec = 6'b111111;
      12'd3426 :  mem_out_dec = 6'b111111;
      12'd3427 :  mem_out_dec = 6'b111111;
      12'd3428 :  mem_out_dec = 6'b111111;
      12'd3429 :  mem_out_dec = 6'b111111;
      12'd3430 :  mem_out_dec = 6'b111111;
      12'd3431 :  mem_out_dec = 6'b111111;
      12'd3432 :  mem_out_dec = 6'b111111;
      12'd3433 :  mem_out_dec = 6'b111111;
      12'd3434 :  mem_out_dec = 6'b111111;
      12'd3435 :  mem_out_dec = 6'b111111;
      12'd3436 :  mem_out_dec = 6'b111111;
      12'd3437 :  mem_out_dec = 6'b111111;
      12'd3438 :  mem_out_dec = 6'b111111;
      12'd3439 :  mem_out_dec = 6'b111111;
      12'd3440 :  mem_out_dec = 6'b111111;
      12'd3441 :  mem_out_dec = 6'b111111;
      12'd3442 :  mem_out_dec = 6'b111111;
      12'd3443 :  mem_out_dec = 6'b111111;
      12'd3444 :  mem_out_dec = 6'b111111;
      12'd3445 :  mem_out_dec = 6'b111111;
      12'd3446 :  mem_out_dec = 6'b111111;
      12'd3447 :  mem_out_dec = 6'b111111;
      12'd3448 :  mem_out_dec = 6'b111111;
      12'd3449 :  mem_out_dec = 6'b111111;
      12'd3450 :  mem_out_dec = 6'b111111;
      12'd3451 :  mem_out_dec = 6'b000100;
      12'd3452 :  mem_out_dec = 6'b000101;
      12'd3453 :  mem_out_dec = 6'b000110;
      12'd3454 :  mem_out_dec = 6'b000111;
      12'd3455 :  mem_out_dec = 6'b001000;
      12'd3456 :  mem_out_dec = 6'b111111;
      12'd3457 :  mem_out_dec = 6'b111111;
      12'd3458 :  mem_out_dec = 6'b111111;
      12'd3459 :  mem_out_dec = 6'b111111;
      12'd3460 :  mem_out_dec = 6'b111111;
      12'd3461 :  mem_out_dec = 6'b111111;
      12'd3462 :  mem_out_dec = 6'b111111;
      12'd3463 :  mem_out_dec = 6'b111111;
      12'd3464 :  mem_out_dec = 6'b111111;
      12'd3465 :  mem_out_dec = 6'b111111;
      12'd3466 :  mem_out_dec = 6'b111111;
      12'd3467 :  mem_out_dec = 6'b111111;
      12'd3468 :  mem_out_dec = 6'b111111;
      12'd3469 :  mem_out_dec = 6'b111111;
      12'd3470 :  mem_out_dec = 6'b111111;
      12'd3471 :  mem_out_dec = 6'b111111;
      12'd3472 :  mem_out_dec = 6'b111111;
      12'd3473 :  mem_out_dec = 6'b111111;
      12'd3474 :  mem_out_dec = 6'b111111;
      12'd3475 :  mem_out_dec = 6'b111111;
      12'd3476 :  mem_out_dec = 6'b111111;
      12'd3477 :  mem_out_dec = 6'b111111;
      12'd3478 :  mem_out_dec = 6'b111111;
      12'd3479 :  mem_out_dec = 6'b111111;
      12'd3480 :  mem_out_dec = 6'b111111;
      12'd3481 :  mem_out_dec = 6'b111111;
      12'd3482 :  mem_out_dec = 6'b111111;
      12'd3483 :  mem_out_dec = 6'b111111;
      12'd3484 :  mem_out_dec = 6'b111111;
      12'd3485 :  mem_out_dec = 6'b111111;
      12'd3486 :  mem_out_dec = 6'b111111;
      12'd3487 :  mem_out_dec = 6'b111111;
      12'd3488 :  mem_out_dec = 6'b111111;
      12'd3489 :  mem_out_dec = 6'b111111;
      12'd3490 :  mem_out_dec = 6'b111111;
      12'd3491 :  mem_out_dec = 6'b111111;
      12'd3492 :  mem_out_dec = 6'b111111;
      12'd3493 :  mem_out_dec = 6'b111111;
      12'd3494 :  mem_out_dec = 6'b111111;
      12'd3495 :  mem_out_dec = 6'b111111;
      12'd3496 :  mem_out_dec = 6'b111111;
      12'd3497 :  mem_out_dec = 6'b111111;
      12'd3498 :  mem_out_dec = 6'b111111;
      12'd3499 :  mem_out_dec = 6'b111111;
      12'd3500 :  mem_out_dec = 6'b111111;
      12'd3501 :  mem_out_dec = 6'b111111;
      12'd3502 :  mem_out_dec = 6'b111111;
      12'd3503 :  mem_out_dec = 6'b111111;
      12'd3504 :  mem_out_dec = 6'b111111;
      12'd3505 :  mem_out_dec = 6'b111111;
      12'd3506 :  mem_out_dec = 6'b111111;
      12'd3507 :  mem_out_dec = 6'b111111;
      12'd3508 :  mem_out_dec = 6'b111111;
      12'd3509 :  mem_out_dec = 6'b111111;
      12'd3510 :  mem_out_dec = 6'b111111;
      12'd3511 :  mem_out_dec = 6'b111111;
      12'd3512 :  mem_out_dec = 6'b111111;
      12'd3513 :  mem_out_dec = 6'b111111;
      12'd3514 :  mem_out_dec = 6'b111111;
      12'd3515 :  mem_out_dec = 6'b111111;
      12'd3516 :  mem_out_dec = 6'b000101;
      12'd3517 :  mem_out_dec = 6'b000110;
      12'd3518 :  mem_out_dec = 6'b000110;
      12'd3519 :  mem_out_dec = 6'b000111;
      12'd3520 :  mem_out_dec = 6'b111111;
      12'd3521 :  mem_out_dec = 6'b111111;
      12'd3522 :  mem_out_dec = 6'b111111;
      12'd3523 :  mem_out_dec = 6'b111111;
      12'd3524 :  mem_out_dec = 6'b111111;
      12'd3525 :  mem_out_dec = 6'b111111;
      12'd3526 :  mem_out_dec = 6'b111111;
      12'd3527 :  mem_out_dec = 6'b111111;
      12'd3528 :  mem_out_dec = 6'b111111;
      12'd3529 :  mem_out_dec = 6'b111111;
      12'd3530 :  mem_out_dec = 6'b111111;
      12'd3531 :  mem_out_dec = 6'b111111;
      12'd3532 :  mem_out_dec = 6'b111111;
      12'd3533 :  mem_out_dec = 6'b111111;
      12'd3534 :  mem_out_dec = 6'b111111;
      12'd3535 :  mem_out_dec = 6'b111111;
      12'd3536 :  mem_out_dec = 6'b111111;
      12'd3537 :  mem_out_dec = 6'b111111;
      12'd3538 :  mem_out_dec = 6'b111111;
      12'd3539 :  mem_out_dec = 6'b111111;
      12'd3540 :  mem_out_dec = 6'b111111;
      12'd3541 :  mem_out_dec = 6'b111111;
      12'd3542 :  mem_out_dec = 6'b111111;
      12'd3543 :  mem_out_dec = 6'b111111;
      12'd3544 :  mem_out_dec = 6'b111111;
      12'd3545 :  mem_out_dec = 6'b111111;
      12'd3546 :  mem_out_dec = 6'b111111;
      12'd3547 :  mem_out_dec = 6'b111111;
      12'd3548 :  mem_out_dec = 6'b111111;
      12'd3549 :  mem_out_dec = 6'b111111;
      12'd3550 :  mem_out_dec = 6'b111111;
      12'd3551 :  mem_out_dec = 6'b111111;
      12'd3552 :  mem_out_dec = 6'b111111;
      12'd3553 :  mem_out_dec = 6'b111111;
      12'd3554 :  mem_out_dec = 6'b111111;
      12'd3555 :  mem_out_dec = 6'b111111;
      12'd3556 :  mem_out_dec = 6'b111111;
      12'd3557 :  mem_out_dec = 6'b111111;
      12'd3558 :  mem_out_dec = 6'b111111;
      12'd3559 :  mem_out_dec = 6'b111111;
      12'd3560 :  mem_out_dec = 6'b111111;
      12'd3561 :  mem_out_dec = 6'b111111;
      12'd3562 :  mem_out_dec = 6'b111111;
      12'd3563 :  mem_out_dec = 6'b111111;
      12'd3564 :  mem_out_dec = 6'b111111;
      12'd3565 :  mem_out_dec = 6'b111111;
      12'd3566 :  mem_out_dec = 6'b111111;
      12'd3567 :  mem_out_dec = 6'b111111;
      12'd3568 :  mem_out_dec = 6'b111111;
      12'd3569 :  mem_out_dec = 6'b111111;
      12'd3570 :  mem_out_dec = 6'b111111;
      12'd3571 :  mem_out_dec = 6'b111111;
      12'd3572 :  mem_out_dec = 6'b111111;
      12'd3573 :  mem_out_dec = 6'b111111;
      12'd3574 :  mem_out_dec = 6'b111111;
      12'd3575 :  mem_out_dec = 6'b111111;
      12'd3576 :  mem_out_dec = 6'b111111;
      12'd3577 :  mem_out_dec = 6'b111111;
      12'd3578 :  mem_out_dec = 6'b111111;
      12'd3579 :  mem_out_dec = 6'b111111;
      12'd3580 :  mem_out_dec = 6'b111111;
      12'd3581 :  mem_out_dec = 6'b000101;
      12'd3582 :  mem_out_dec = 6'b000110;
      12'd3583 :  mem_out_dec = 6'b000110;
      12'd3584 :  mem_out_dec = 6'b111111;
      12'd3585 :  mem_out_dec = 6'b111111;
      12'd3586 :  mem_out_dec = 6'b111111;
      12'd3587 :  mem_out_dec = 6'b111111;
      12'd3588 :  mem_out_dec = 6'b111111;
      12'd3589 :  mem_out_dec = 6'b111111;
      12'd3590 :  mem_out_dec = 6'b111111;
      12'd3591 :  mem_out_dec = 6'b111111;
      12'd3592 :  mem_out_dec = 6'b111111;
      12'd3593 :  mem_out_dec = 6'b111111;
      12'd3594 :  mem_out_dec = 6'b111111;
      12'd3595 :  mem_out_dec = 6'b111111;
      12'd3596 :  mem_out_dec = 6'b111111;
      12'd3597 :  mem_out_dec = 6'b111111;
      12'd3598 :  mem_out_dec = 6'b111111;
      12'd3599 :  mem_out_dec = 6'b111111;
      12'd3600 :  mem_out_dec = 6'b111111;
      12'd3601 :  mem_out_dec = 6'b111111;
      12'd3602 :  mem_out_dec = 6'b111111;
      12'd3603 :  mem_out_dec = 6'b111111;
      12'd3604 :  mem_out_dec = 6'b111111;
      12'd3605 :  mem_out_dec = 6'b111111;
      12'd3606 :  mem_out_dec = 6'b111111;
      12'd3607 :  mem_out_dec = 6'b111111;
      12'd3608 :  mem_out_dec = 6'b111111;
      12'd3609 :  mem_out_dec = 6'b111111;
      12'd3610 :  mem_out_dec = 6'b111111;
      12'd3611 :  mem_out_dec = 6'b111111;
      12'd3612 :  mem_out_dec = 6'b111111;
      12'd3613 :  mem_out_dec = 6'b111111;
      12'd3614 :  mem_out_dec = 6'b111111;
      12'd3615 :  mem_out_dec = 6'b111111;
      12'd3616 :  mem_out_dec = 6'b111111;
      12'd3617 :  mem_out_dec = 6'b111111;
      12'd3618 :  mem_out_dec = 6'b111111;
      12'd3619 :  mem_out_dec = 6'b111111;
      12'd3620 :  mem_out_dec = 6'b111111;
      12'd3621 :  mem_out_dec = 6'b111111;
      12'd3622 :  mem_out_dec = 6'b111111;
      12'd3623 :  mem_out_dec = 6'b111111;
      12'd3624 :  mem_out_dec = 6'b111111;
      12'd3625 :  mem_out_dec = 6'b111111;
      12'd3626 :  mem_out_dec = 6'b111111;
      12'd3627 :  mem_out_dec = 6'b111111;
      12'd3628 :  mem_out_dec = 6'b111111;
      12'd3629 :  mem_out_dec = 6'b111111;
      12'd3630 :  mem_out_dec = 6'b111111;
      12'd3631 :  mem_out_dec = 6'b111111;
      12'd3632 :  mem_out_dec = 6'b111111;
      12'd3633 :  mem_out_dec = 6'b111111;
      12'd3634 :  mem_out_dec = 6'b111111;
      12'd3635 :  mem_out_dec = 6'b111111;
      12'd3636 :  mem_out_dec = 6'b111111;
      12'd3637 :  mem_out_dec = 6'b111111;
      12'd3638 :  mem_out_dec = 6'b111111;
      12'd3639 :  mem_out_dec = 6'b111111;
      12'd3640 :  mem_out_dec = 6'b111111;
      12'd3641 :  mem_out_dec = 6'b111111;
      12'd3642 :  mem_out_dec = 6'b111111;
      12'd3643 :  mem_out_dec = 6'b111111;
      12'd3644 :  mem_out_dec = 6'b111111;
      12'd3645 :  mem_out_dec = 6'b111111;
      12'd3646 :  mem_out_dec = 6'b000100;
      12'd3647 :  mem_out_dec = 6'b000101;
      12'd3648 :  mem_out_dec = 6'b111111;
      12'd3649 :  mem_out_dec = 6'b111111;
      12'd3650 :  mem_out_dec = 6'b111111;
      12'd3651 :  mem_out_dec = 6'b111111;
      12'd3652 :  mem_out_dec = 6'b111111;
      12'd3653 :  mem_out_dec = 6'b111111;
      12'd3654 :  mem_out_dec = 6'b111111;
      12'd3655 :  mem_out_dec = 6'b111111;
      12'd3656 :  mem_out_dec = 6'b111111;
      12'd3657 :  mem_out_dec = 6'b111111;
      12'd3658 :  mem_out_dec = 6'b111111;
      12'd3659 :  mem_out_dec = 6'b111111;
      12'd3660 :  mem_out_dec = 6'b111111;
      12'd3661 :  mem_out_dec = 6'b111111;
      12'd3662 :  mem_out_dec = 6'b111111;
      12'd3663 :  mem_out_dec = 6'b111111;
      12'd3664 :  mem_out_dec = 6'b111111;
      12'd3665 :  mem_out_dec = 6'b111111;
      12'd3666 :  mem_out_dec = 6'b111111;
      12'd3667 :  mem_out_dec = 6'b111111;
      12'd3668 :  mem_out_dec = 6'b111111;
      12'd3669 :  mem_out_dec = 6'b111111;
      12'd3670 :  mem_out_dec = 6'b111111;
      12'd3671 :  mem_out_dec = 6'b111111;
      12'd3672 :  mem_out_dec = 6'b111111;
      12'd3673 :  mem_out_dec = 6'b111111;
      12'd3674 :  mem_out_dec = 6'b111111;
      12'd3675 :  mem_out_dec = 6'b111111;
      12'd3676 :  mem_out_dec = 6'b111111;
      12'd3677 :  mem_out_dec = 6'b111111;
      12'd3678 :  mem_out_dec = 6'b111111;
      12'd3679 :  mem_out_dec = 6'b111111;
      12'd3680 :  mem_out_dec = 6'b111111;
      12'd3681 :  mem_out_dec = 6'b111111;
      12'd3682 :  mem_out_dec = 6'b111111;
      12'd3683 :  mem_out_dec = 6'b111111;
      12'd3684 :  mem_out_dec = 6'b111111;
      12'd3685 :  mem_out_dec = 6'b111111;
      12'd3686 :  mem_out_dec = 6'b111111;
      12'd3687 :  mem_out_dec = 6'b111111;
      12'd3688 :  mem_out_dec = 6'b111111;
      12'd3689 :  mem_out_dec = 6'b111111;
      12'd3690 :  mem_out_dec = 6'b111111;
      12'd3691 :  mem_out_dec = 6'b111111;
      12'd3692 :  mem_out_dec = 6'b111111;
      12'd3693 :  mem_out_dec = 6'b111111;
      12'd3694 :  mem_out_dec = 6'b111111;
      12'd3695 :  mem_out_dec = 6'b111111;
      12'd3696 :  mem_out_dec = 6'b111111;
      12'd3697 :  mem_out_dec = 6'b111111;
      12'd3698 :  mem_out_dec = 6'b111111;
      12'd3699 :  mem_out_dec = 6'b111111;
      12'd3700 :  mem_out_dec = 6'b111111;
      12'd3701 :  mem_out_dec = 6'b111111;
      12'd3702 :  mem_out_dec = 6'b111111;
      12'd3703 :  mem_out_dec = 6'b111111;
      12'd3704 :  mem_out_dec = 6'b111111;
      12'd3705 :  mem_out_dec = 6'b111111;
      12'd3706 :  mem_out_dec = 6'b111111;
      12'd3707 :  mem_out_dec = 6'b111111;
      12'd3708 :  mem_out_dec = 6'b111111;
      12'd3709 :  mem_out_dec = 6'b111111;
      12'd3710 :  mem_out_dec = 6'b111111;
      12'd3711 :  mem_out_dec = 6'b000100;
      12'd3712 :  mem_out_dec = 6'b111111;
      12'd3713 :  mem_out_dec = 6'b111111;
      12'd3714 :  mem_out_dec = 6'b111111;
      12'd3715 :  mem_out_dec = 6'b111111;
      12'd3716 :  mem_out_dec = 6'b111111;
      12'd3717 :  mem_out_dec = 6'b111111;
      12'd3718 :  mem_out_dec = 6'b111111;
      12'd3719 :  mem_out_dec = 6'b111111;
      12'd3720 :  mem_out_dec = 6'b111111;
      12'd3721 :  mem_out_dec = 6'b111111;
      12'd3722 :  mem_out_dec = 6'b111111;
      12'd3723 :  mem_out_dec = 6'b111111;
      12'd3724 :  mem_out_dec = 6'b111111;
      12'd3725 :  mem_out_dec = 6'b111111;
      12'd3726 :  mem_out_dec = 6'b111111;
      12'd3727 :  mem_out_dec = 6'b111111;
      12'd3728 :  mem_out_dec = 6'b111111;
      12'd3729 :  mem_out_dec = 6'b111111;
      12'd3730 :  mem_out_dec = 6'b111111;
      12'd3731 :  mem_out_dec = 6'b111111;
      12'd3732 :  mem_out_dec = 6'b111111;
      12'd3733 :  mem_out_dec = 6'b111111;
      12'd3734 :  mem_out_dec = 6'b111111;
      12'd3735 :  mem_out_dec = 6'b111111;
      12'd3736 :  mem_out_dec = 6'b111111;
      12'd3737 :  mem_out_dec = 6'b111111;
      12'd3738 :  mem_out_dec = 6'b111111;
      12'd3739 :  mem_out_dec = 6'b111111;
      12'd3740 :  mem_out_dec = 6'b111111;
      12'd3741 :  mem_out_dec = 6'b111111;
      12'd3742 :  mem_out_dec = 6'b111111;
      12'd3743 :  mem_out_dec = 6'b111111;
      12'd3744 :  mem_out_dec = 6'b111111;
      12'd3745 :  mem_out_dec = 6'b111111;
      12'd3746 :  mem_out_dec = 6'b111111;
      12'd3747 :  mem_out_dec = 6'b111111;
      12'd3748 :  mem_out_dec = 6'b111111;
      12'd3749 :  mem_out_dec = 6'b111111;
      12'd3750 :  mem_out_dec = 6'b111111;
      12'd3751 :  mem_out_dec = 6'b111111;
      12'd3752 :  mem_out_dec = 6'b111111;
      12'd3753 :  mem_out_dec = 6'b111111;
      12'd3754 :  mem_out_dec = 6'b111111;
      12'd3755 :  mem_out_dec = 6'b111111;
      12'd3756 :  mem_out_dec = 6'b111111;
      12'd3757 :  mem_out_dec = 6'b111111;
      12'd3758 :  mem_out_dec = 6'b111111;
      12'd3759 :  mem_out_dec = 6'b111111;
      12'd3760 :  mem_out_dec = 6'b111111;
      12'd3761 :  mem_out_dec = 6'b111111;
      12'd3762 :  mem_out_dec = 6'b111111;
      12'd3763 :  mem_out_dec = 6'b111111;
      12'd3764 :  mem_out_dec = 6'b111111;
      12'd3765 :  mem_out_dec = 6'b111111;
      12'd3766 :  mem_out_dec = 6'b111111;
      12'd3767 :  mem_out_dec = 6'b111111;
      12'd3768 :  mem_out_dec = 6'b111111;
      12'd3769 :  mem_out_dec = 6'b111111;
      12'd3770 :  mem_out_dec = 6'b111111;
      12'd3771 :  mem_out_dec = 6'b111111;
      12'd3772 :  mem_out_dec = 6'b111111;
      12'd3773 :  mem_out_dec = 6'b111111;
      12'd3774 :  mem_out_dec = 6'b111111;
      12'd3775 :  mem_out_dec = 6'b111111;
      12'd3776 :  mem_out_dec = 6'b111111;
      12'd3777 :  mem_out_dec = 6'b111111;
      12'd3778 :  mem_out_dec = 6'b111111;
      12'd3779 :  mem_out_dec = 6'b111111;
      12'd3780 :  mem_out_dec = 6'b111111;
      12'd3781 :  mem_out_dec = 6'b111111;
      12'd3782 :  mem_out_dec = 6'b111111;
      12'd3783 :  mem_out_dec = 6'b111111;
      12'd3784 :  mem_out_dec = 6'b111111;
      12'd3785 :  mem_out_dec = 6'b111111;
      12'd3786 :  mem_out_dec = 6'b111111;
      12'd3787 :  mem_out_dec = 6'b111111;
      12'd3788 :  mem_out_dec = 6'b111111;
      12'd3789 :  mem_out_dec = 6'b111111;
      12'd3790 :  mem_out_dec = 6'b111111;
      12'd3791 :  mem_out_dec = 6'b111111;
      12'd3792 :  mem_out_dec = 6'b111111;
      12'd3793 :  mem_out_dec = 6'b111111;
      12'd3794 :  mem_out_dec = 6'b111111;
      12'd3795 :  mem_out_dec = 6'b111111;
      12'd3796 :  mem_out_dec = 6'b111111;
      12'd3797 :  mem_out_dec = 6'b111111;
      12'd3798 :  mem_out_dec = 6'b111111;
      12'd3799 :  mem_out_dec = 6'b111111;
      12'd3800 :  mem_out_dec = 6'b111111;
      12'd3801 :  mem_out_dec = 6'b111111;
      12'd3802 :  mem_out_dec = 6'b111111;
      12'd3803 :  mem_out_dec = 6'b111111;
      12'd3804 :  mem_out_dec = 6'b111111;
      12'd3805 :  mem_out_dec = 6'b111111;
      12'd3806 :  mem_out_dec = 6'b111111;
      12'd3807 :  mem_out_dec = 6'b111111;
      12'd3808 :  mem_out_dec = 6'b111111;
      12'd3809 :  mem_out_dec = 6'b111111;
      12'd3810 :  mem_out_dec = 6'b111111;
      12'd3811 :  mem_out_dec = 6'b111111;
      12'd3812 :  mem_out_dec = 6'b111111;
      12'd3813 :  mem_out_dec = 6'b111111;
      12'd3814 :  mem_out_dec = 6'b111111;
      12'd3815 :  mem_out_dec = 6'b111111;
      12'd3816 :  mem_out_dec = 6'b111111;
      12'd3817 :  mem_out_dec = 6'b111111;
      12'd3818 :  mem_out_dec = 6'b111111;
      12'd3819 :  mem_out_dec = 6'b111111;
      12'd3820 :  mem_out_dec = 6'b111111;
      12'd3821 :  mem_out_dec = 6'b111111;
      12'd3822 :  mem_out_dec = 6'b111111;
      12'd3823 :  mem_out_dec = 6'b111111;
      12'd3824 :  mem_out_dec = 6'b111111;
      12'd3825 :  mem_out_dec = 6'b111111;
      12'd3826 :  mem_out_dec = 6'b111111;
      12'd3827 :  mem_out_dec = 6'b111111;
      12'd3828 :  mem_out_dec = 6'b111111;
      12'd3829 :  mem_out_dec = 6'b111111;
      12'd3830 :  mem_out_dec = 6'b111111;
      12'd3831 :  mem_out_dec = 6'b111111;
      12'd3832 :  mem_out_dec = 6'b111111;
      12'd3833 :  mem_out_dec = 6'b111111;
      12'd3834 :  mem_out_dec = 6'b111111;
      12'd3835 :  mem_out_dec = 6'b111111;
      12'd3836 :  mem_out_dec = 6'b111111;
      12'd3837 :  mem_out_dec = 6'b111111;
      12'd3838 :  mem_out_dec = 6'b111111;
      12'd3839 :  mem_out_dec = 6'b111111;
      12'd3840 :  mem_out_dec = 6'b111111;
      12'd3841 :  mem_out_dec = 6'b111111;
      12'd3842 :  mem_out_dec = 6'b111111;
      12'd3843 :  mem_out_dec = 6'b111111;
      12'd3844 :  mem_out_dec = 6'b111111;
      12'd3845 :  mem_out_dec = 6'b111111;
      12'd3846 :  mem_out_dec = 6'b111111;
      12'd3847 :  mem_out_dec = 6'b111111;
      12'd3848 :  mem_out_dec = 6'b111111;
      12'd3849 :  mem_out_dec = 6'b111111;
      12'd3850 :  mem_out_dec = 6'b111111;
      12'd3851 :  mem_out_dec = 6'b111111;
      12'd3852 :  mem_out_dec = 6'b111111;
      12'd3853 :  mem_out_dec = 6'b111111;
      12'd3854 :  mem_out_dec = 6'b111111;
      12'd3855 :  mem_out_dec = 6'b111111;
      12'd3856 :  mem_out_dec = 6'b111111;
      12'd3857 :  mem_out_dec = 6'b111111;
      12'd3858 :  mem_out_dec = 6'b111111;
      12'd3859 :  mem_out_dec = 6'b111111;
      12'd3860 :  mem_out_dec = 6'b111111;
      12'd3861 :  mem_out_dec = 6'b111111;
      12'd3862 :  mem_out_dec = 6'b111111;
      12'd3863 :  mem_out_dec = 6'b111111;
      12'd3864 :  mem_out_dec = 6'b111111;
      12'd3865 :  mem_out_dec = 6'b111111;
      12'd3866 :  mem_out_dec = 6'b111111;
      12'd3867 :  mem_out_dec = 6'b111111;
      12'd3868 :  mem_out_dec = 6'b111111;
      12'd3869 :  mem_out_dec = 6'b111111;
      12'd3870 :  mem_out_dec = 6'b111111;
      12'd3871 :  mem_out_dec = 6'b111111;
      12'd3872 :  mem_out_dec = 6'b111111;
      12'd3873 :  mem_out_dec = 6'b111111;
      12'd3874 :  mem_out_dec = 6'b111111;
      12'd3875 :  mem_out_dec = 6'b111111;
      12'd3876 :  mem_out_dec = 6'b111111;
      12'd3877 :  mem_out_dec = 6'b111111;
      12'd3878 :  mem_out_dec = 6'b111111;
      12'd3879 :  mem_out_dec = 6'b111111;
      12'd3880 :  mem_out_dec = 6'b111111;
      12'd3881 :  mem_out_dec = 6'b111111;
      12'd3882 :  mem_out_dec = 6'b111111;
      12'd3883 :  mem_out_dec = 6'b111111;
      12'd3884 :  mem_out_dec = 6'b111111;
      12'd3885 :  mem_out_dec = 6'b111111;
      12'd3886 :  mem_out_dec = 6'b111111;
      12'd3887 :  mem_out_dec = 6'b111111;
      12'd3888 :  mem_out_dec = 6'b111111;
      12'd3889 :  mem_out_dec = 6'b111111;
      12'd3890 :  mem_out_dec = 6'b111111;
      12'd3891 :  mem_out_dec = 6'b111111;
      12'd3892 :  mem_out_dec = 6'b111111;
      12'd3893 :  mem_out_dec = 6'b111111;
      12'd3894 :  mem_out_dec = 6'b111111;
      12'd3895 :  mem_out_dec = 6'b111111;
      12'd3896 :  mem_out_dec = 6'b111111;
      12'd3897 :  mem_out_dec = 6'b111111;
      12'd3898 :  mem_out_dec = 6'b111111;
      12'd3899 :  mem_out_dec = 6'b111111;
      12'd3900 :  mem_out_dec = 6'b111111;
      12'd3901 :  mem_out_dec = 6'b111111;
      12'd3902 :  mem_out_dec = 6'b111111;
      12'd3903 :  mem_out_dec = 6'b111111;
      12'd3904 :  mem_out_dec = 6'b111111;
      12'd3905 :  mem_out_dec = 6'b111111;
      12'd3906 :  mem_out_dec = 6'b111111;
      12'd3907 :  mem_out_dec = 6'b111111;
      12'd3908 :  mem_out_dec = 6'b111111;
      12'd3909 :  mem_out_dec = 6'b111111;
      12'd3910 :  mem_out_dec = 6'b111111;
      12'd3911 :  mem_out_dec = 6'b111111;
      12'd3912 :  mem_out_dec = 6'b111111;
      12'd3913 :  mem_out_dec = 6'b111111;
      12'd3914 :  mem_out_dec = 6'b111111;
      12'd3915 :  mem_out_dec = 6'b111111;
      12'd3916 :  mem_out_dec = 6'b111111;
      12'd3917 :  mem_out_dec = 6'b111111;
      12'd3918 :  mem_out_dec = 6'b111111;
      12'd3919 :  mem_out_dec = 6'b111111;
      12'd3920 :  mem_out_dec = 6'b111111;
      12'd3921 :  mem_out_dec = 6'b111111;
      12'd3922 :  mem_out_dec = 6'b111111;
      12'd3923 :  mem_out_dec = 6'b111111;
      12'd3924 :  mem_out_dec = 6'b111111;
      12'd3925 :  mem_out_dec = 6'b111111;
      12'd3926 :  mem_out_dec = 6'b111111;
      12'd3927 :  mem_out_dec = 6'b111111;
      12'd3928 :  mem_out_dec = 6'b111111;
      12'd3929 :  mem_out_dec = 6'b111111;
      12'd3930 :  mem_out_dec = 6'b111111;
      12'd3931 :  mem_out_dec = 6'b111111;
      12'd3932 :  mem_out_dec = 6'b111111;
      12'd3933 :  mem_out_dec = 6'b111111;
      12'd3934 :  mem_out_dec = 6'b111111;
      12'd3935 :  mem_out_dec = 6'b111111;
      12'd3936 :  mem_out_dec = 6'b111111;
      12'd3937 :  mem_out_dec = 6'b111111;
      12'd3938 :  mem_out_dec = 6'b111111;
      12'd3939 :  mem_out_dec = 6'b111111;
      12'd3940 :  mem_out_dec = 6'b111111;
      12'd3941 :  mem_out_dec = 6'b111111;
      12'd3942 :  mem_out_dec = 6'b111111;
      12'd3943 :  mem_out_dec = 6'b111111;
      12'd3944 :  mem_out_dec = 6'b111111;
      12'd3945 :  mem_out_dec = 6'b111111;
      12'd3946 :  mem_out_dec = 6'b111111;
      12'd3947 :  mem_out_dec = 6'b111111;
      12'd3948 :  mem_out_dec = 6'b111111;
      12'd3949 :  mem_out_dec = 6'b111111;
      12'd3950 :  mem_out_dec = 6'b111111;
      12'd3951 :  mem_out_dec = 6'b111111;
      12'd3952 :  mem_out_dec = 6'b111111;
      12'd3953 :  mem_out_dec = 6'b111111;
      12'd3954 :  mem_out_dec = 6'b111111;
      12'd3955 :  mem_out_dec = 6'b111111;
      12'd3956 :  mem_out_dec = 6'b111111;
      12'd3957 :  mem_out_dec = 6'b111111;
      12'd3958 :  mem_out_dec = 6'b111111;
      12'd3959 :  mem_out_dec = 6'b111111;
      12'd3960 :  mem_out_dec = 6'b111111;
      12'd3961 :  mem_out_dec = 6'b111111;
      12'd3962 :  mem_out_dec = 6'b111111;
      12'd3963 :  mem_out_dec = 6'b111111;
      12'd3964 :  mem_out_dec = 6'b111111;
      12'd3965 :  mem_out_dec = 6'b111111;
      12'd3966 :  mem_out_dec = 6'b111111;
      12'd3967 :  mem_out_dec = 6'b111111;
      12'd3968 :  mem_out_dec = 6'b111111;
      12'd3969 :  mem_out_dec = 6'b111111;
      12'd3970 :  mem_out_dec = 6'b111111;
      12'd3971 :  mem_out_dec = 6'b111111;
      12'd3972 :  mem_out_dec = 6'b111111;
      12'd3973 :  mem_out_dec = 6'b111111;
      12'd3974 :  mem_out_dec = 6'b111111;
      12'd3975 :  mem_out_dec = 6'b111111;
      12'd3976 :  mem_out_dec = 6'b111111;
      12'd3977 :  mem_out_dec = 6'b111111;
      12'd3978 :  mem_out_dec = 6'b111111;
      12'd3979 :  mem_out_dec = 6'b111111;
      12'd3980 :  mem_out_dec = 6'b111111;
      12'd3981 :  mem_out_dec = 6'b111111;
      12'd3982 :  mem_out_dec = 6'b111111;
      12'd3983 :  mem_out_dec = 6'b111111;
      12'd3984 :  mem_out_dec = 6'b111111;
      12'd3985 :  mem_out_dec = 6'b111111;
      12'd3986 :  mem_out_dec = 6'b111111;
      12'd3987 :  mem_out_dec = 6'b111111;
      12'd3988 :  mem_out_dec = 6'b111111;
      12'd3989 :  mem_out_dec = 6'b111111;
      12'd3990 :  mem_out_dec = 6'b111111;
      12'd3991 :  mem_out_dec = 6'b111111;
      12'd3992 :  mem_out_dec = 6'b111111;
      12'd3993 :  mem_out_dec = 6'b111111;
      12'd3994 :  mem_out_dec = 6'b111111;
      12'd3995 :  mem_out_dec = 6'b111111;
      12'd3996 :  mem_out_dec = 6'b111111;
      12'd3997 :  mem_out_dec = 6'b111111;
      12'd3998 :  mem_out_dec = 6'b111111;
      12'd3999 :  mem_out_dec = 6'b111111;
      12'd4000 :  mem_out_dec = 6'b111111;
      12'd4001 :  mem_out_dec = 6'b111111;
      12'd4002 :  mem_out_dec = 6'b111111;
      12'd4003 :  mem_out_dec = 6'b111111;
      12'd4004 :  mem_out_dec = 6'b111111;
      12'd4005 :  mem_out_dec = 6'b111111;
      12'd4006 :  mem_out_dec = 6'b111111;
      12'd4007 :  mem_out_dec = 6'b111111;
      12'd4008 :  mem_out_dec = 6'b111111;
      12'd4009 :  mem_out_dec = 6'b111111;
      12'd4010 :  mem_out_dec = 6'b111111;
      12'd4011 :  mem_out_dec = 6'b111111;
      12'd4012 :  mem_out_dec = 6'b111111;
      12'd4013 :  mem_out_dec = 6'b111111;
      12'd4014 :  mem_out_dec = 6'b111111;
      12'd4015 :  mem_out_dec = 6'b111111;
      12'd4016 :  mem_out_dec = 6'b111111;
      12'd4017 :  mem_out_dec = 6'b111111;
      12'd4018 :  mem_out_dec = 6'b111111;
      12'd4019 :  mem_out_dec = 6'b111111;
      12'd4020 :  mem_out_dec = 6'b111111;
      12'd4021 :  mem_out_dec = 6'b111111;
      12'd4022 :  mem_out_dec = 6'b111111;
      12'd4023 :  mem_out_dec = 6'b111111;
      12'd4024 :  mem_out_dec = 6'b111111;
      12'd4025 :  mem_out_dec = 6'b111111;
      12'd4026 :  mem_out_dec = 6'b111111;
      12'd4027 :  mem_out_dec = 6'b111111;
      12'd4028 :  mem_out_dec = 6'b111111;
      12'd4029 :  mem_out_dec = 6'b111111;
      12'd4030 :  mem_out_dec = 6'b111111;
      12'd4031 :  mem_out_dec = 6'b111111;
      12'd4032 :  mem_out_dec = 6'b111111;
      12'd4033 :  mem_out_dec = 6'b111111;
      12'd4034 :  mem_out_dec = 6'b111111;
      12'd4035 :  mem_out_dec = 6'b111111;
      12'd4036 :  mem_out_dec = 6'b111111;
      12'd4037 :  mem_out_dec = 6'b111111;
      12'd4038 :  mem_out_dec = 6'b111111;
      12'd4039 :  mem_out_dec = 6'b111111;
      12'd4040 :  mem_out_dec = 6'b111111;
      12'd4041 :  mem_out_dec = 6'b111111;
      12'd4042 :  mem_out_dec = 6'b111111;
      12'd4043 :  mem_out_dec = 6'b111111;
      12'd4044 :  mem_out_dec = 6'b111111;
      12'd4045 :  mem_out_dec = 6'b111111;
      12'd4046 :  mem_out_dec = 6'b111111;
      12'd4047 :  mem_out_dec = 6'b111111;
      12'd4048 :  mem_out_dec = 6'b111111;
      12'd4049 :  mem_out_dec = 6'b111111;
      12'd4050 :  mem_out_dec = 6'b111111;
      12'd4051 :  mem_out_dec = 6'b111111;
      12'd4052 :  mem_out_dec = 6'b111111;
      12'd4053 :  mem_out_dec = 6'b111111;
      12'd4054 :  mem_out_dec = 6'b111111;
      12'd4055 :  mem_out_dec = 6'b111111;
      12'd4056 :  mem_out_dec = 6'b111111;
      12'd4057 :  mem_out_dec = 6'b111111;
      12'd4058 :  mem_out_dec = 6'b111111;
      12'd4059 :  mem_out_dec = 6'b111111;
      12'd4060 :  mem_out_dec = 6'b111111;
      12'd4061 :  mem_out_dec = 6'b111111;
      12'd4062 :  mem_out_dec = 6'b111111;
      12'd4063 :  mem_out_dec = 6'b111111;
      12'd4064 :  mem_out_dec = 6'b111111;
      12'd4065 :  mem_out_dec = 6'b111111;
      12'd4066 :  mem_out_dec = 6'b111111;
      12'd4067 :  mem_out_dec = 6'b111111;
      12'd4068 :  mem_out_dec = 6'b111111;
      12'd4069 :  mem_out_dec = 6'b111111;
      12'd4070 :  mem_out_dec = 6'b111111;
      12'd4071 :  mem_out_dec = 6'b111111;
      12'd4072 :  mem_out_dec = 6'b111111;
      12'd4073 :  mem_out_dec = 6'b111111;
      12'd4074 :  mem_out_dec = 6'b111111;
      12'd4075 :  mem_out_dec = 6'b111111;
      12'd4076 :  mem_out_dec = 6'b111111;
      12'd4077 :  mem_out_dec = 6'b111111;
      12'd4078 :  mem_out_dec = 6'b111111;
      12'd4079 :  mem_out_dec = 6'b111111;
      12'd4080 :  mem_out_dec = 6'b111111;
      12'd4081 :  mem_out_dec = 6'b111111;
      12'd4082 :  mem_out_dec = 6'b111111;
      12'd4083 :  mem_out_dec = 6'b111111;
      12'd4084 :  mem_out_dec = 6'b111111;
      12'd4085 :  mem_out_dec = 6'b111111;
      12'd4086 :  mem_out_dec = 6'b111111;
      12'd4087 :  mem_out_dec = 6'b111111;
      12'd4088 :  mem_out_dec = 6'b111111;
      12'd4089 :  mem_out_dec = 6'b111111;
      12'd4090 :  mem_out_dec = 6'b111111;
      12'd4091 :  mem_out_dec = 6'b111111;
      12'd4092 :  mem_out_dec = 6'b111111;
      12'd4093 :  mem_out_dec = 6'b111111;
      12'd4094 :  mem_out_dec = 6'b111111;
      12'd4095 :  mem_out_dec = 6'b111111;
    endcase
  end

  always @ (posedge clk) begin
    dec_cnt <= #TCQ mem_out_dec;
  end
endmodule

