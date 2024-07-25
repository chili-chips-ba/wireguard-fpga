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
//  /   /         Filename: ddr_phy_dqs_found_cal.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:35:08 $
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  Read leveling calibration logic
//  NOTES:
//    1. Phaser_In DQSFOUND calibration
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_dqs_found_cal.v,v 1.1 2011/06/02 08:35:08 mishra Exp $
**$Date: 2011/06/02 08:35:08 $
**$Author: 
**$Revision:
**$Source: 
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_dqs_found_cal_hr #
  (
   parameter TCQ              = 100,    // clk->out delay (sim only)
   parameter nCK_PER_CLK      = 2,      // # of memory clocks per CLK
   parameter nCL              = 5,      // Read CAS latency
   parameter AL               = "0",
   parameter nCWL             = 5,      // Write CAS latency
   parameter DRAM_TYPE        = "DDR3",  // Memory I/F type: "DDR3", "DDR2"
   parameter RANKS            = 1,      // # of memory ranks in the system
   parameter DQS_CNT_WIDTH    = 3,      // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH        = 8,      // # of DQS (strobe)
   parameter DRAM_WIDTH       = 8,      // # of DQ per DQS
   parameter REG_CTRL         = "ON",   // "ON" for registered DIMM
   parameter SIM_CAL_OPTION   = "NONE",  // Performs all calibration steps
   parameter NUM_DQSFOUND_CAL = 3,      // Number of times to iterate
   parameter N_CTL_LANES      = 3,      // Number of control byte lanes
   parameter HIGHEST_LANE     = 12,     // Sum of byte lanes (Data + Ctrl)
   parameter HIGHEST_BANK     = 3,      // Sum of I/O Banks
   parameter BYTE_LANES_B0    = 4'b1111,
   parameter BYTE_LANES_B1    = 4'b0000,
   parameter BYTE_LANES_B2    = 4'b0000,
   parameter BYTE_LANES_B3    = 4'b0000,
   parameter BYTE_LANES_B4    = 4'b0000,
   parameter DATA_CTL_B0      = 4'hc,
   parameter DATA_CTL_B1      = 4'hf,
   parameter DATA_CTL_B2      = 4'hf,
   parameter DATA_CTL_B3      = 4'hf,
   parameter DATA_CTL_B4      = 4'hf
   )
  (
   input                         clk,
   input                         rst,
   input                         dqsfound_retry,
   // From phy_init
   input                         pi_dqs_found_start,
   input                         detect_pi_found_dqs,
   input                         prech_done,
   // DQSFOUND per Phaser_IN
   input [HIGHEST_LANE-1:0]      pi_dqs_found_lanes,

   output reg [HIGHEST_BANK-1:0] pi_rst_stg1_cal,
   
   // To phy_init
   output [5:0]                  rd_data_offset_0,
   output [5:0]                  rd_data_offset_1,
   output [5:0]                  rd_data_offset_2,
   output                        pi_dqs_found_rank_done,
   output                        pi_dqs_found_done,
   output reg                    pi_dqs_found_err,
   output [6*RANKS-1:0]          rd_data_offset_ranks_0,
   output [6*RANKS-1:0]          rd_data_offset_ranks_1,
   output [6*RANKS-1:0]          rd_data_offset_ranks_2,
   output reg                    dqsfound_retry_done,
   output reg                    dqs_found_prech_req,
   //To MC
   output [6*RANKS-1:0]          rd_data_offset_ranks_mc_0,
   output [6*RANKS-1:0]          rd_data_offset_ranks_mc_1,
   output [6*RANKS-1:0]          rd_data_offset_ranks_mc_2,

   input [8:0]                   po_counter_read_val,
   output                        rd_data_offset_cal_done,
   output                        fine_adjust_done,
   output [N_CTL_LANES-1:0]      fine_adjust_lane_cnt,
   output reg                    ck_po_stg2_f_indec,
   output reg                    ck_po_stg2_f_en,
   output [255:0]                dbg_dqs_found_cal
  );
  

   // For non-zero AL values
   localparam nAL = (AL == "CL-1") ? nCL - 1 : 0;   

   // Adding the register dimm latency to write latency
   localparam CWL_M = (REG_CTRL == "ON") ? nCWL + nAL + 1 : nCWL + nAL;

   // Added to reduce simulation time
   localparam LATENCY_FACTOR = 13;
   
   localparam NUM_READS = (SIM_CAL_OPTION == "NONE") ? 7 : 1;
   
   localparam [19:0] DATA_PRESENT = {(DATA_CTL_B4[3] & BYTE_LANES_B4[3]),
                                     (DATA_CTL_B4[2] & BYTE_LANES_B4[2]),
                                     (DATA_CTL_B4[1] & BYTE_LANES_B4[1]),
                                     (DATA_CTL_B4[0] & BYTE_LANES_B4[0]),
                                     (DATA_CTL_B3[3] & BYTE_LANES_B3[3]),
                                     (DATA_CTL_B3[2] & BYTE_LANES_B3[2]),
                                     (DATA_CTL_B3[1] & BYTE_LANES_B3[1]),
                                     (DATA_CTL_B3[0] & BYTE_LANES_B3[0]),
                                     (DATA_CTL_B2[3] & BYTE_LANES_B2[3]),
                                     (DATA_CTL_B2[2] & BYTE_LANES_B2[2]),
                                     (DATA_CTL_B2[1] & BYTE_LANES_B2[1]),
                                     (DATA_CTL_B2[0] & BYTE_LANES_B2[0]),
                                     (DATA_CTL_B1[3] & BYTE_LANES_B1[3]),
                                     (DATA_CTL_B1[2] & BYTE_LANES_B1[2]),
                                     (DATA_CTL_B1[1] & BYTE_LANES_B1[1]),
                                     (DATA_CTL_B1[0] & BYTE_LANES_B1[0]),
                                     (DATA_CTL_B0[3] & BYTE_LANES_B0[3]),
                                     (DATA_CTL_B0[2] & BYTE_LANES_B0[2]),
                                     (DATA_CTL_B0[1] & BYTE_LANES_B0[1]),
                                     (DATA_CTL_B0[0] & BYTE_LANES_B0[0])};
   
   localparam FINE_ADJ_IDLE    = 4'h0;
   localparam RST_POSTWAIT     = 4'h1;
   localparam RST_POSTWAIT1    = 4'h2;
   localparam RST_WAIT         = 4'h3;
   localparam FINE_ADJ_INIT    = 4'h4;
   localparam FINE_INC         = 4'h5;
   localparam FINE_INC_WAIT    = 4'h6;
   localparam FINE_INC_PREWAIT = 4'h7;
   localparam DETECT_PREWAIT   = 4'h8;
   localparam DETECT_DQSFOUND  = 4'h9;
   localparam PRECH_WAIT       = 4'hA;
   localparam FINE_DEC         = 4'hB;
   localparam FINE_DEC_WAIT    = 4'hC;
   localparam FINE_DEC_PREWAIT = 4'hD;
   localparam FINAL_WAIT       = 4'hE;
   localparam FINE_ADJ_DONE    = 4'hF;
   

  integer k,l,m,n,p,q,r,s;
  
  reg                       dqs_found_start_r;
  reg [6*HIGHEST_BANK-1:0]  rd_byte_data_offset[0:RANKS-1];
  reg                       rank_done_r;
  reg                       rank_done_r1;
  reg                       dqs_found_done_r;
  (* ASYNC_REG = "TRUE" *) reg [HIGHEST_LANE-1:0] pi_dqs_found_lanes_r1;
  (* ASYNC_REG = "TRUE" *) reg [HIGHEST_LANE-1:0] pi_dqs_found_lanes_r2;
  (* ASYNC_REG = "TRUE" *) reg [HIGHEST_LANE-1:0] pi_dqs_found_lanes_r3;
  reg                       init_dqsfound_done_r;
  reg                       init_dqsfound_done_r1;
  reg                       init_dqsfound_done_r2;
  reg                       init_dqsfound_done_r3;
  reg                       init_dqsfound_done_r4;
  reg                       init_dqsfound_done_r5;
  reg [1:0]                 rnk_cnt_r;
  reg [2:0 ]                final_do_index[0:RANKS-1];
  reg [5:0 ]                final_do_max[0:RANKS-1];
  reg [6*HIGHEST_BANK-1:0]  final_data_offset[0:RANKS-1];
  reg [6*HIGHEST_BANK-1:0]  final_data_offset_mc[0:RANKS-1];
  reg [HIGHEST_BANK-1:0]    pi_rst_stg1_cal_r;
  reg [HIGHEST_BANK-1:0]    pi_rst_stg1_cal_r1;
  reg [10*HIGHEST_BANK-1:0] retry_cnt;
  reg                       dqsfound_retry_r1;
  wire [4*HIGHEST_BANK-1:0] pi_dqs_found_lanes_int;
  reg [HIGHEST_BANK-1:0]    pi_dqs_found_all_bank;
  reg [HIGHEST_BANK-1:0]    pi_dqs_found_all_bank_r;
  reg [HIGHEST_BANK-1:0]    pi_dqs_found_any_bank;
  reg [HIGHEST_BANK-1:0]    pi_dqs_found_any_bank_r;
  reg [HIGHEST_BANK-1:0]    pi_dqs_found_err_r;
  
  // CK/Control byte lanes fine adjust stage
  reg                       fine_adjust;
  reg [N_CTL_LANES-1:0]     ctl_lane_cnt;
  reg [3:0]                 fine_adj_state_r;
  reg                       fine_adjust_done_r;
  reg                       rst_dqs_find;
  reg                       rst_dqs_find_r1;
  reg                       rst_dqs_find_r2;
  reg [5:0]                 init_dec_cnt;
  reg [5:0]                 dec_cnt;
  reg [5:0]                 inc_cnt;
  reg                       final_dec_done;
  reg                       init_dec_done;
  reg                       first_fail_detect;
  reg                       second_fail_detect;
  reg [5:0]                 first_fail_taps;
  reg [5:0]                 second_fail_taps;
  reg [5:0]                 stable_pass_cnt;
  reg [3:0]                 detect_rd_cnt;
  

  
  
  //***************************************************************************
  // Debug signals
  //
  //***************************************************************************
  assign dbg_dqs_found_cal[5:0]  = first_fail_taps;
  assign dbg_dqs_found_cal[11:6] = second_fail_taps;
  assign dbg_dqs_found_cal[12]   = first_fail_detect;
  assign dbg_dqs_found_cal[13]   = second_fail_detect;
  assign dbg_dqs_found_cal[14]   = fine_adjust_done_r;
  

  assign pi_dqs_found_rank_done    = rank_done_r;
  assign pi_dqs_found_done         = dqs_found_done_r;

  generate
  genvar rnk_cnt;
    if (HIGHEST_BANK == 3) begin // Three Bank Interface
      for (rnk_cnt = 0; rnk_cnt < RANKS; rnk_cnt = rnk_cnt + 1) begin: rnk_loop
        assign rd_data_offset_ranks_0[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][5:0];
        assign rd_data_offset_ranks_1[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][11:6];
        assign rd_data_offset_ranks_2[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][17:12];
        assign rd_data_offset_ranks_mc_0[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][5:0];
        assign rd_data_offset_ranks_mc_1[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][11:6];
        assign rd_data_offset_ranks_mc_2[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][17:12];
      end
    end else if (HIGHEST_BANK == 2) begin // Two Bank Interface
      for (rnk_cnt = 0; rnk_cnt < RANKS; rnk_cnt = rnk_cnt + 1) begin: rnk_loop
        assign rd_data_offset_ranks_0[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][5:0];
        assign rd_data_offset_ranks_1[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][11:6];
        assign rd_data_offset_ranks_2[6*rnk_cnt+:6] = 'd0;
        assign rd_data_offset_ranks_mc_0[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][5:0];
        assign rd_data_offset_ranks_mc_1[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][11:6];
        assign rd_data_offset_ranks_mc_2[6*rnk_cnt+:6] = 'd0;
      end
    end else begin // Single Bank Interface
      for (rnk_cnt = 0; rnk_cnt < RANKS; rnk_cnt = rnk_cnt + 1) begin: rnk_loop
        assign rd_data_offset_ranks_0[6*rnk_cnt+:6] = final_data_offset[rnk_cnt][5:0];
        assign rd_data_offset_ranks_1[6*rnk_cnt+:6] = 'd0;
        assign rd_data_offset_ranks_2[6*rnk_cnt+:6] = 'd0;
        assign rd_data_offset_ranks_mc_0[6*rnk_cnt+:6] = final_data_offset_mc[rnk_cnt][5:0];
        assign rd_data_offset_ranks_mc_1[6*rnk_cnt+:6] = 'd0;
        assign rd_data_offset_ranks_mc_2[6*rnk_cnt+:6] = 'd0;
      end
    end
  endgenerate
  
  // final_data_offset is used during write calibration and during
  // normal operation. One rd_data_offset value per rank for entire
  // interface
  generate
  if (HIGHEST_BANK == 3) begin // Three I/O Bank interface
    assign rd_data_offset_0 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][0+:6] :
                               final_data_offset[rnk_cnt_r][0+:6];
    assign rd_data_offset_1 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][6+:6] :
                               final_data_offset[rnk_cnt_r][6+:6];
    assign rd_data_offset_2 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][12+:6] :
                               final_data_offset[rnk_cnt_r][12+:6];
  end else if (HIGHEST_BANK == 2) begin // Two I/O Bank interface
    assign rd_data_offset_0 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][0+:6] :
                               final_data_offset[rnk_cnt_r][0+:6];
    assign rd_data_offset_1 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][6+:6] :
                               final_data_offset[rnk_cnt_r][6+:6];
    assign rd_data_offset_2 = 'd0;
  end else begin
    assign rd_data_offset_0 = (~init_dqsfound_done_r2) ? rd_byte_data_offset[rnk_cnt_r][0+:6] :
                               final_data_offset[rnk_cnt_r][0+:6];
    assign rd_data_offset_1 = 'd0;
    assign rd_data_offset_2 = 'd0;
  end
  endgenerate
  
  assign rd_data_offset_cal_done = init_dqsfound_done_r;
  assign fine_adjust_lane_cnt    = ctl_lane_cnt;
  
  //**************************************************************************
  // DQSFOUND all and any generation
  // pi_dqs_found_all_bank[x] asserted when all Phaser_INs in Bankx are
  // asserted
  // pi_dqs_found_any_bank[x] asserted when at least one Phaser_IN in Bankx
  // is asserted
  //**************************************************************************

  generate
  if ((HIGHEST_LANE == 4) || (HIGHEST_LANE == 8) || (HIGHEST_LANE == 12))
    assign pi_dqs_found_lanes_int = pi_dqs_found_lanes_r3;
  else if ((HIGHEST_LANE == 3) || (HIGHEST_LANE == 7) || (HIGHEST_LANE == 11))
    assign pi_dqs_found_lanes_int = {1'b0, pi_dqs_found_lanes_r3};
  else if ((HIGHEST_LANE == 6) || (HIGHEST_LANE == 10))
    assign pi_dqs_found_lanes_int = {2'b00, pi_dqs_found_lanes_r3};
  else if ((HIGHEST_LANE == 5) || (HIGHEST_LANE == 9))
    assign pi_dqs_found_lanes_int = {3'b000, pi_dqs_found_lanes_r3};
  endgenerate
  
  always @(posedge clk) begin
    if (rst) begin
      for (k = 0; k < HIGHEST_BANK; k = k + 1) begin: rst_pi_dqs_found
        pi_dqs_found_all_bank[k] <= #TCQ 'b0;
        pi_dqs_found_any_bank[k] <= #TCQ 'b0;
      end
    end else if (pi_dqs_found_start) begin
      for (p = 0; p < HIGHEST_BANK; p = p +1) begin: assign_pi_dqs_found
          pi_dqs_found_all_bank[p] <= #TCQ (!DATA_PRESENT[4*p+0] | pi_dqs_found_lanes_int[4*p+0]) &
                                           (!DATA_PRESENT[4*p+1] | pi_dqs_found_lanes_int[4*p+1]) &
                                           (!DATA_PRESENT[4*p+2] | pi_dqs_found_lanes_int[4*p+2]) &
                                           (!DATA_PRESENT[4*p+3] | pi_dqs_found_lanes_int[4*p+3]);
          pi_dqs_found_any_bank[p] <= #TCQ (DATA_PRESENT[4*p+0] & pi_dqs_found_lanes_int[4*p+0]) |
                                           (DATA_PRESENT[4*p+1] & pi_dqs_found_lanes_int[4*p+1]) |
                                           (DATA_PRESENT[4*p+2] & pi_dqs_found_lanes_int[4*p+2]) |
                                           (DATA_PRESENT[4*p+3] & pi_dqs_found_lanes_int[4*p+3]);
      end
    end
  end

  
  always @(posedge clk) begin
    pi_dqs_found_all_bank_r <= #TCQ pi_dqs_found_all_bank;
    pi_dqs_found_any_bank_r <= #TCQ pi_dqs_found_any_bank;
  end
  
//*****************************************************************************
// Counter to increase number of 4 back-to-back reads per rd_data_offset and
// per CK/A/C tap value
//*****************************************************************************

  always @(posedge clk) begin
    if (rst || (detect_rd_cnt == 'd0))
	  detect_rd_cnt <= #TCQ NUM_READS;
	else if (detect_pi_found_dqs && (detect_rd_cnt > 'd0))
	  detect_rd_cnt <= #TCQ detect_rd_cnt - 1;
  end
  
   //**************************************************************************
   // Adjust Phaser_Out stage 2 taps on CK/Address/Command/Controls 
   // 
   //**************************************************************************
   
   assign fine_adjust_done = fine_adjust_done_r;
   
   always @(posedge clk) begin
     rst_dqs_find_r1 <= #TCQ rst_dqs_find;
	 rst_dqs_find_r2 <= #TCQ rst_dqs_find_r1;
   end
   
   always @(posedge clk) begin
      if(rst)begin
        fine_adjust        <= #TCQ 1'b0;
        ctl_lane_cnt       <= #TCQ 'd0;
        fine_adj_state_r   <= #TCQ FINE_ADJ_IDLE;
        fine_adjust_done_r <= #TCQ 1'b0;
        ck_po_stg2_f_indec <= #TCQ 1'b0;
        ck_po_stg2_f_en    <= #TCQ 1'b0;
        rst_dqs_find       <= #TCQ 1'b0;
        init_dec_cnt       <= #TCQ 'd31;
        dec_cnt            <= #TCQ 'd0;
        inc_cnt            <= #TCQ 'd0;
        init_dec_done      <= #TCQ 1'b0;
        final_dec_done     <= #TCQ 1'b0;
        first_fail_detect  <= #TCQ 1'b0;
        second_fail_detect <= #TCQ 1'b0;
        first_fail_taps    <= #TCQ 'd0;
        second_fail_taps   <= #TCQ 'd0;
        stable_pass_cnt    <= #TCQ 'd0;
        dqs_found_prech_req<= #TCQ 1'b0;
      end else begin
        case (fine_adj_state_r)
           
           FINE_ADJ_IDLE: begin
             if (init_dqsfound_done_r5) begin
               if (SIM_CAL_OPTION == "FAST_CAL") begin
                 fine_adjust      <= #TCQ 1'b1;
                 fine_adj_state_r <= #TCQ FINE_ADJ_DONE;
                 rst_dqs_find     <= #TCQ 1'b0;
               end else begin
                 fine_adjust      <= #TCQ 1'b1;
                 fine_adj_state_r <= #TCQ RST_WAIT;
                 rst_dqs_find     <= #TCQ 1'b1;
               end
             end
           end
           
           RST_WAIT: begin
             if (~(|pi_dqs_found_any_bank) && rst_dqs_find_r2) begin
               rst_dqs_find     <= #TCQ 1'b0;
               if (|init_dec_cnt)
                 fine_adj_state_r <= #TCQ FINE_DEC_PREWAIT;
               else if (final_dec_done)
                 fine_adj_state_r <= #TCQ FINE_ADJ_DONE;
               else
                 fine_adj_state_r <= #TCQ RST_POSTWAIT;
             end
           end
           
           RST_POSTWAIT: begin
             fine_adj_state_r <= #TCQ RST_POSTWAIT1;
           end
           
           RST_POSTWAIT1: begin
             fine_adj_state_r <= #TCQ FINE_ADJ_INIT;
           end
           
           FINE_ADJ_INIT: begin
             //if (detect_pi_found_dqs && (inc_cnt < 'd63))
               fine_adj_state_r <= #TCQ FINE_INC;
           end
           
           FINE_INC: begin
             fine_adj_state_r   <= #TCQ FINE_INC_WAIT;
             ck_po_stg2_f_indec <= #TCQ 1'b1;
             ck_po_stg2_f_en    <= #TCQ 1'b1;
             if (ctl_lane_cnt == N_CTL_LANES-1)
               inc_cnt          <= #TCQ inc_cnt + 1;
           end
           
           FINE_INC_WAIT: begin
             ck_po_stg2_f_indec <= #TCQ 1'b0;
             ck_po_stg2_f_en    <= #TCQ 1'b0;
             if (ctl_lane_cnt != N_CTL_LANES-1) begin
               ctl_lane_cnt     <= #TCQ ctl_lane_cnt + 1;
               fine_adj_state_r <= #TCQ FINE_INC_PREWAIT;
             end else if (ctl_lane_cnt == N_CTL_LANES-1) begin
               ctl_lane_cnt     <= #TCQ 'd0;
               fine_adj_state_r <= #TCQ DETECT_PREWAIT;
             end
           end
           
           FINE_INC_PREWAIT: begin
             fine_adj_state_r <= #TCQ FINE_INC;
           end
           
           DETECT_PREWAIT: begin
             if (detect_pi_found_dqs && (detect_rd_cnt == 'd1))
               fine_adj_state_r <= #TCQ DETECT_DQSFOUND;
			 else
			   fine_adj_state_r <= #TCQ DETECT_PREWAIT;
           end
           
           DETECT_DQSFOUND: begin
             if (detect_pi_found_dqs && ~(&pi_dqs_found_all_bank)) begin
               stable_pass_cnt     <= #TCQ 'd0;
               if (~first_fail_detect && (inc_cnt == 'd63)) begin
                 // First failing tap detected at 63 taps
                 // then decrement to 31
                 first_fail_detect <= #TCQ 1'b1;
                 first_fail_taps   <= #TCQ inc_cnt;
                 fine_adj_state_r  <= #TCQ FINE_DEC;
                 dec_cnt           <= #TCQ 'd32;
               end else if (~first_fail_detect && (inc_cnt > 'd30) && (stable_pass_cnt > 'd29)) begin
                 // First failing tap detected at greater than 30 taps
                 // then stop looking for second edge and decrement
                 first_fail_detect <= #TCQ 1'b1;
                 first_fail_taps   <= #TCQ inc_cnt;
                 fine_adj_state_r  <= #TCQ FINE_DEC;
                 dec_cnt           <= #TCQ (inc_cnt>>1) + 1;				 
			   end else if (~first_fail_detect || (first_fail_detect && (stable_pass_cnt < 'd30) && (inc_cnt <= 'd32))) begin
                 // First failing tap detected, continue incrementing
                 // until either second failing tap detected or 63
                 first_fail_detect <= #TCQ 1'b1;
                 first_fail_taps   <= #TCQ inc_cnt;
                 rst_dqs_find      <= #TCQ 1'b1;
                 if ((inc_cnt == 'd12) || (inc_cnt == 'd24)) begin
                   dqs_found_prech_req <= #TCQ 1'b1;
                   fine_adj_state_r    <= #TCQ PRECH_WAIT;
                 end else
                 fine_adj_state_r  <= #TCQ RST_WAIT;
               end else if (first_fail_detect && (inc_cnt > 'd32) && (inc_cnt < 'd63) && (stable_pass_cnt < 'd30)) begin
                 // Consecutive 30 taps of passing region was not found
                 // continue incrementing
                 first_fail_detect <= #TCQ 1'b1;
                 first_fail_taps   <= #TCQ inc_cnt;
                 rst_dqs_find      <= #TCQ 1'b1;
                 if ((inc_cnt == 'd36) || (inc_cnt == 'd48) || (inc_cnt == 'd60)) begin
                   dqs_found_prech_req <= #TCQ 1'b1;
                   fine_adj_state_r    <= #TCQ PRECH_WAIT;
                 end else
                   fine_adj_state_r  <= #TCQ RST_WAIT;
               end else if (first_fail_detect && (inc_cnt == 'd63)) begin
                 if (stable_pass_cnt < 'd30) begin
                   // Consecutive 30 taps of passing region was not found
                   // from tap 0 to 63 so decrement back to 31
                   first_fail_detect <= #TCQ 1'b1;
                   first_fail_taps   <= #TCQ inc_cnt;
                   fine_adj_state_r  <= #TCQ FINE_DEC;
                   dec_cnt           <= #TCQ 'd32;
                 end else begin
                   // Consecutive 30 taps of passing region was found
                   // between first_fail_taps and 63
                   fine_adj_state_r  <= #TCQ FINE_DEC;
                   dec_cnt           <= #TCQ ((inc_cnt - first_fail_taps)>>1);
                 end
               end else begin
                 // Second failing tap detected, decrement to center of
                 // failing taps
                 second_fail_detect <= #TCQ 1'b1;
                 second_fail_taps   <= #TCQ inc_cnt;
                 dec_cnt            <= #TCQ ((inc_cnt - first_fail_taps)>>1);
                 fine_adj_state_r   <= #TCQ FINE_DEC;
               end
             end else if (detect_pi_found_dqs && (&pi_dqs_found_all_bank)) begin
               stable_pass_cnt    <= #TCQ stable_pass_cnt + 1;
               if ((inc_cnt == 'd12) || (inc_cnt == 'd24) || (inc_cnt == 'd36) || 
                   (inc_cnt == 'd48) || (inc_cnt == 'd60)) begin
                 dqs_found_prech_req <= #TCQ 1'b1;
                 fine_adj_state_r    <= #TCQ PRECH_WAIT;
               end else if (inc_cnt < 'd63) begin
                 rst_dqs_find     <= #TCQ 1'b1;
                 fine_adj_state_r <= #TCQ RST_WAIT;
               end else begin
                 fine_adj_state_r <= #TCQ FINE_DEC;
                 if (~first_fail_detect || (first_fail_taps > 'd33))
                   // No failing taps detected, decrement by 31
                   dec_cnt <= #TCQ 'd32;
                 //else if (first_fail_detect && (stable_pass_cnt > 'd28))
                 //  // First failing tap detected between 0 and 34
                 //  // decrement midpoint between 63 and failing tap
                 //  dec_cnt <= #TCQ ((inc_cnt - first_fail_taps)>>1);
                 else
                   // First failing tap detected
                   // decrement to midpoint between 63 and failing tap
                   dec_cnt <= #TCQ ((inc_cnt - first_fail_taps)>>1);
               end
             end
           end
           
           PRECH_WAIT: begin
             if (prech_done) begin
               dqs_found_prech_req <= #TCQ 1'b0;
               rst_dqs_find        <= #TCQ 1'b1;
               fine_adj_state_r    <= #TCQ RST_WAIT;
             end
           end
               
               
           FINE_DEC: begin
             fine_adj_state_r   <= #TCQ FINE_DEC_WAIT;
             ck_po_stg2_f_indec <= #TCQ 1'b0;
             ck_po_stg2_f_en    <= #TCQ 1'b1;
             if ((ctl_lane_cnt == N_CTL_LANES-1) && (init_dec_cnt > 'd0))
               init_dec_cnt     <= #TCQ init_dec_cnt - 1;
             else if ((ctl_lane_cnt == N_CTL_LANES-1) && (dec_cnt > 'd0))
               dec_cnt          <= #TCQ dec_cnt - 1;
           end
           
           FINE_DEC_WAIT: begin
             ck_po_stg2_f_indec <= #TCQ 1'b0;
             ck_po_stg2_f_en    <= #TCQ 1'b0;
             if (ctl_lane_cnt != N_CTL_LANES-1) begin
               ctl_lane_cnt     <= #TCQ ctl_lane_cnt + 1;
               fine_adj_state_r <= #TCQ FINE_DEC_PREWAIT;
             end else if (ctl_lane_cnt == N_CTL_LANES-1) begin
               ctl_lane_cnt     <= #TCQ 'd0;
               if ((dec_cnt > 'd0) || (init_dec_cnt > 'd0))
                 fine_adj_state_r <= #TCQ FINE_DEC_PREWAIT;
               else begin
                 fine_adj_state_r <= #TCQ FINAL_WAIT;
                 if ((init_dec_cnt == 'd0) && ~init_dec_done)
                   init_dec_done <= #TCQ 1'b1;
                 else
                   final_dec_done   <= #TCQ 1'b1;
               end
             end
           end
           
           FINE_DEC_PREWAIT: begin
             fine_adj_state_r <= #TCQ FINE_DEC;
           end
           
           FINAL_WAIT: begin
             rst_dqs_find     <= #TCQ 1'b1;
             fine_adj_state_r <= #TCQ RST_WAIT;
           end
           
           FINE_ADJ_DONE: begin
             if (&pi_dqs_found_all_bank) begin
               fine_adjust_done_r <= #TCQ 1'b1;
               rst_dqs_find       <= #TCQ 1'b0;
               fine_adj_state_r   <= #TCQ FINE_ADJ_DONE;
             end
           end
           
        endcase
      end
   end
               

   
   
//*****************************************************************************     
  

  always@(posedge clk)
    dqs_found_start_r <= #TCQ pi_dqs_found_start;
  

  always @(posedge clk) begin
    if (rst)
      rnk_cnt_r <= #TCQ 2'b00;
    else if (init_dqsfound_done_r)
      rnk_cnt_r <= #TCQ rnk_cnt_r;
    else if (rank_done_r)
      rnk_cnt_r <= #TCQ rnk_cnt_r + 1;
  end
  
  //*****************************************************************
  // Read data_offset calibration done signal
  //*****************************************************************
  
    always @(posedge clk) begin
    if (rst || (|pi_rst_stg1_cal_r))
      init_dqsfound_done_r  <= #TCQ 1'b0;
    else if (&pi_dqs_found_all_bank) begin
      if (rnk_cnt_r == RANKS-1)
        init_dqsfound_done_r  <= #TCQ 1'b1;
      else
        init_dqsfound_done_r  <= #TCQ 1'b0;
    end
  end
  
  always @(posedge clk) begin
    if (rst  ||
       (init_dqsfound_done_r && (rnk_cnt_r == RANKS-1)))
      rank_done_r       <= #TCQ 1'b0;
    else if (&pi_dqs_found_all_bank && ~(&pi_dqs_found_all_bank_r))
      rank_done_r <= #TCQ 1'b1;
    else
      rank_done_r       <= #TCQ 1'b0;
  end
  
  always @(posedge clk) begin
    pi_dqs_found_lanes_r1   <= #TCQ pi_dqs_found_lanes;
    pi_dqs_found_lanes_r2   <= #TCQ pi_dqs_found_lanes_r1;
    pi_dqs_found_lanes_r3   <= #TCQ pi_dqs_found_lanes_r2;
    init_dqsfound_done_r1   <= #TCQ init_dqsfound_done_r;
    init_dqsfound_done_r2   <= #TCQ init_dqsfound_done_r1;
    init_dqsfound_done_r3   <= #TCQ init_dqsfound_done_r2;
    init_dqsfound_done_r4   <= #TCQ init_dqsfound_done_r3;
    init_dqsfound_done_r5   <= #TCQ init_dqsfound_done_r4;
    rank_done_r1            <= #TCQ rank_done_r;
    dqsfound_retry_r1       <= #TCQ dqsfound_retry;
  end

  
  always @(posedge clk) begin
    if (rst)
      dqs_found_done_r <= #TCQ 1'b0;
    else if (&pi_dqs_found_all_bank && (rnk_cnt_r == RANKS-1) && init_dqsfound_done_r1 &&
             (fine_adj_state_r == FINE_ADJ_DONE))
      dqs_found_done_r <= #TCQ 1'b1;
    else
      dqs_found_done_r <= #TCQ 1'b0;
  end
  

  generate
    if (HIGHEST_BANK == 3) begin // Three I/O Bank interface

      // Reset read data offset calibration in all DQS Phaser_INs
      // in a Bank after the read data offset value for a rank is determined
      // or if within a Bank DQSFOUND is not asserted for all DQSs
      always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[0] || fine_adjust)
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[0]) ||
                 (pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0]) ||
                 (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[1] || fine_adjust)
          pi_rst_stg1_cal_r[1] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[1]) ||
                 (pi_dqs_found_any_bank_r[1] && ~pi_dqs_found_all_bank[1]) ||
                 (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[1] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[2] || fine_adjust)
          pi_rst_stg1_cal_r[2] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[2]) ||
                 (pi_dqs_found_any_bank_r[2] && ~pi_dqs_found_all_bank[2]) ||
                 (rd_byte_data_offset[rnk_cnt_r][12+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[2] <= #TCQ 1'b1;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[1])
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[1] && ~pi_dqs_found_all_bank[1])
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b0;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[2]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[2])
          pi_rst_stg1_cal_r1[2]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[2] && ~pi_dqs_found_all_bank[2])
          pi_rst_stg1_cal_r1[2]  <= #TCQ 1'b0;
      end

      //*****************************************************************************
      // Retry counter to track number of DQSFOUND retries
      //*****************************************************************************
    
      always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[0+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[0])
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10] + 1;
        else
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10];
      end
	  
	  always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[10+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[1])
          retry_cnt[10+:10] <= #TCQ retry_cnt[10+:10] + 1;
        else
          retry_cnt[10+:10] <= #TCQ retry_cnt[10+:10];
      end
	  
	  always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[20+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][12+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[2])
          retry_cnt[20+:10] <= #TCQ retry_cnt[20+:10] + 1;
        else
          retry_cnt[20+:10] <= #TCQ retry_cnt[20+:10];
      end

      // Error generation in case pi_dqs_found_all_bank
      // is not asserted
      always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[0] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[0] && (retry_cnt[0+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[0] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[1] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[1] && (retry_cnt[10+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[1] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[2] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[2] && (retry_cnt[20+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][12+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[2] <= #TCQ 1'b1;
      end

      // Read data offset value for all DQS in a Bank
      always @(posedge clk) begin
        if (rst) begin
          for (q = 0; q < RANKS; q = q + 1) begin: three_bank0_rst_loop
            rd_byte_data_offset[q][0+:6] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
            rd_byte_data_offset[rnk_cnt_r][0+:6] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[0] &&
                 //(rd_byte_data_offset[rnk_cnt_r][0+:6] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r][0+:6]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r][0+:6] + 1;
      end

      always @(posedge clk) begin
        if (rst) begin
          for (r = 0; r < RANKS; r = r + 1) begin: three_bank1_rst_loop
            rd_byte_data_offset[r][6+:6] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
            rd_byte_data_offset[rnk_cnt_r][6+:6] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[1] &&
                 //(rd_byte_data_offset[rnk_cnt_r][6+:6] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r][6+:6]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r][6+:6] + 1;
      end

      always @(posedge clk) begin
        if (rst) begin
          for (s = 0; s < RANKS; s = s + 1) begin: three_bank2_rst_loop
            rd_byte_data_offset[s][12+:6] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r][12+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
            rd_byte_data_offset[rnk_cnt_r][12+:6] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[2] &&
                 //(rd_byte_data_offset[rnk_cnt_r][12+:6] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r][12+:6]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r][12+:6] + 1;
      end

//*****************************************************************************
// Two I/O Bank Interface
//*****************************************************************************
    end else if (HIGHEST_BANK == 2) begin  // Two I/O Bank interface

      // Reset read data offset calibration in all DQS Phaser_INs
      // in a Bank after the read data offset value for a rank is determined
      // or if within a Bank DQSFOUND is not asserted for all DQSs
      always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[0] || fine_adjust)
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[0]) ||
                 (pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0]) ||
                 (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[1] || fine_adjust)
          pi_rst_stg1_cal_r[1] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[1]) ||
                 (pi_dqs_found_any_bank_r[1] && ~pi_dqs_found_all_bank[1]) ||
                 (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[1] <= #TCQ 1'b1;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[1])
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[1] && ~pi_dqs_found_all_bank[1])
          pi_rst_stg1_cal_r1[1]  <= #TCQ 1'b0;
      end

      //*****************************************************************************
      // Retry counter to track number of DQSFOUND retries
      //*****************************************************************************
    
      always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[0+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[0])
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10] + 1;
        else
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10];
      end
	  
	  always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[10+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[1])
          retry_cnt[10+:10] <= #TCQ retry_cnt[10+:10] + 1;
        else
          retry_cnt[10+:10] <= #TCQ retry_cnt[10+:10];
      end


      // Error generation in case pi_dqs_found_all_bank
      // is not asserted
      always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[0] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[0] && (retry_cnt[0+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[0] <= #TCQ 1'b1;
      end

      always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[1] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[1] && (retry_cnt[10+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[1] <= #TCQ 1'b1;
      end


      // Read data offset value for all DQS in a Bank
      always @(posedge clk) begin
        if (rst) begin
          for (q = 0; q < RANKS; q = q + 1) begin: two_bank0_rst_loop
            rd_byte_data_offset[q][0+:6] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
            rd_byte_data_offset[rnk_cnt_r][0+:6] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[0] &&
                 //(rd_byte_data_offset[rnk_cnt_r][0+:6] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r][0+:6]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r][0+:6] + 1;
      end

      always @(posedge clk) begin
        if (rst) begin
          for (r = 0; r < RANKS; r = r + 1) begin: two_bank1_rst_loop
            rd_byte_data_offset[r][6+:6] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r][6+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
            rd_byte_data_offset[rnk_cnt_r][6+:6] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[1] &&
                 //(rd_byte_data_offset[rnk_cnt_r][6+:6] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r][6+:6]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r][6+:6] + 1;
      end
//*****************************************************************************
// One I/O Bank Interface
//*****************************************************************************
    end else begin // One I/O Bank Interface

      // Read data offset value for all DQS in Bank0
      always @(posedge clk) begin
        if (rst) begin
          for (l = 0; l < RANKS; l = l + 1) begin: bank_rst_loop
            rd_byte_data_offset[l] <= #TCQ nCL + nAL - 2;
          end
        end else if ((rank_done_r1 && ~init_dqsfound_done_r) ||
		             (rd_byte_data_offset[rnk_cnt_r] > (nCL + nAL + LATENCY_FACTOR - 1)))
          rd_byte_data_offset[rnk_cnt_r] <= #TCQ nCL + nAL - 2;
        else if (dqs_found_start_r && ~pi_dqs_found_all_bank[0] &&
                 //(rd_byte_data_offset[rnk_cnt_r] < (nCL + nAL + LATENCY_FACTOR)) &&
                 (detect_pi_found_dqs && (detect_rd_cnt == 'd1)) && ~init_dqsfound_done_r && ~fine_adjust)
          rd_byte_data_offset[rnk_cnt_r]
          <= #TCQ rd_byte_data_offset[rnk_cnt_r] + 1;
      end

      // Reset read data offset calibration in all DQS Phaser_INs
      // in a Bank after the read data offset value for a rank is determined
      // or if within a Bank DQSFOUND is not asserted for all DQSs
       always @(posedge clk) begin
        if (rst || pi_rst_stg1_cal_r1[0] || fine_adjust)
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b0;
        else if ((pi_dqs_found_start && ~dqs_found_start_r) ||
                 //(dqsfound_retry[0]) ||
                 (pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0]) ||
                 (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_rst_stg1_cal_r[0] <= #TCQ 1'b1;
      end
      
      always @(posedge clk) begin
        if (rst || fine_adjust)
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
        else if (pi_rst_stg1_cal_r[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b1;
        else if (~pi_dqs_found_any_bank_r[0] && ~pi_dqs_found_all_bank[0])
          pi_rst_stg1_cal_r1[0]  <= #TCQ 1'b0;
      end

      //*****************************************************************************
      // Retry counter to track number of DQSFOUND retries
      //*****************************************************************************
    
      always @(posedge clk) begin
        if (rst || rank_done_r)
          retry_cnt[0+:10] <= #TCQ 'b0;
        else if ((rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)) &&
                 ~pi_dqs_found_all_bank[0])
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10] + 1;
        else
          retry_cnt[0+:10] <= #TCQ retry_cnt[0+:10];
      end


      // Error generation in case pi_dqs_found_all_bank
      // is not asserted even with 3 dqfound retries
       always @(posedge clk) begin
        if (rst)
          pi_dqs_found_err_r[0] <= #TCQ 1'b0;
        else if (~pi_dqs_found_all_bank[0] && (retry_cnt[0+:10] == NUM_DQSFOUND_CAL) &&
                (rd_byte_data_offset[rnk_cnt_r][0+:6] > (nCL + nAL + LATENCY_FACTOR - 1)))
          pi_dqs_found_err_r[0] <= #TCQ 1'b1;
      end

    end
  endgenerate
  
  always @(posedge clk) begin
    if (rst)
      pi_rst_stg1_cal <= #TCQ {HIGHEST_BANK{1'b0}};
    else if (rst_dqs_find)
      pi_rst_stg1_cal <= #TCQ {HIGHEST_BANK{1'b1}};
    else
      pi_rst_stg1_cal <= #TCQ pi_rst_stg1_cal_r;
  end
  


  // Final read data offset value to be used during write calibration and
  // normal operation
  generate
  genvar i;
  genvar j;
    for (i = 0; i < RANKS; i = i + 1) begin: rank_final_loop
       reg [5:0] final_do_cand [RANKS-1:0];
       // combinatorially select the candidate offset for the bank
       //  indexed by final_do_index
       if (HIGHEST_BANK == 3) begin
         always @(*) begin
            case (final_do_index[i])
	      3'b000:  final_do_cand[i]  = final_data_offset[i][5:0];
	      3'b001:  final_do_cand[i]  = final_data_offset[i][11:6];
	      3'b010:  final_do_cand[i]  = final_data_offset[i][17:12];
	      default: final_do_cand[i]  = 'd0;
	    endcase
         end
       end else if (HIGHEST_BANK == 2) begin
         always @(*) begin
            case (final_do_index[i])
	      3'b000:  final_do_cand[i]  = final_data_offset[i][5:0];
	      3'b001:  final_do_cand[i]  = final_data_offset[i][11:6];
	      3'b010:  final_do_cand[i]  = 'd0;
	      default: final_do_cand[i]  = 'd0;
	    endcase
         end
       end else begin
         always @(*) begin
            case (final_do_index[i])
	      3'b000:  final_do_cand[i]  = final_data_offset[i][5:0];
	      3'b001:  final_do_cand[i]  = 'd0;
	      3'b010:  final_do_cand[i]  = 'd0;
	      default: final_do_cand[i]  = 'd0;
	    endcase
         end
       end
        
       always @(posedge clk)  begin
          if (rst) 
	      final_do_max[i] <= #TCQ 0;
	  else begin
	     final_do_max[i] <= #TCQ final_do_max[i]; // default
             case (final_do_index[i])
	        3'b000: if ( | DATA_PRESENT[3:0]) 
	               if (final_do_max[i] < final_do_cand[i])
	                 if (CWL_M % 2) // odd latency CAS slot 1
		            final_do_max[i] <= #TCQ final_do_cand[i] - 1;
		         else
		            final_do_max[i] <= #TCQ final_do_cand[i];
	        3'b001: if ( | DATA_PRESENT[7:4]) 
	               if (final_do_max[i] < final_do_cand[i])
		         if (CWL_M % 2) // odd latency CAS slot 1
		            final_do_max[i] <= #TCQ final_do_cand[i] - 1;
		         else
		            final_do_max[i] <= #TCQ final_do_cand[i];
	        3'b010: if ( | DATA_PRESENT[11:8]) 
	               if (final_do_max[i] < final_do_cand[i])
		         if (CWL_M % 2) // odd latency CAS slot 1
		            final_do_max[i] <= #TCQ final_do_cand[i] - 1;
		         else
		            final_do_max[i] <= #TCQ final_do_cand[i];
                default:
	               final_do_max[i] <= #TCQ final_do_max[i];
	      endcase
	   end
	end

	always @(posedge clk) 
	    if (rst) begin
	       final_do_index[i] <= #TCQ 0;
	    end
	    else begin
	       final_do_index[i] <= #TCQ final_do_index[i] + 1;
	    end

      for (j = 0; j < HIGHEST_BANK; j = j + 1) begin: bank_final_loop
        
        always @(posedge clk) begin
          if (rst) begin
            final_data_offset[i][6*j+:6] <= #TCQ 'b0;
	  end
          else begin
	  //if (dqsfound_retry[j])
           // final_data_offset[i][6*j+:6] <= #TCQ rd_byte_data_offset[i][6*j+:6];
          //else 
          if (init_dqsfound_done_r && ~init_dqsfound_done_r1) begin
	    if ( DATA_PRESENT [ j*4+:4] != 0) begin // has a data lane
               final_data_offset[i][6*j+:6] <= #TCQ rd_byte_data_offset[i][6*j+:6];
               if (CWL_M % 2) // odd latency CAS slot 1
                 final_data_offset_mc[i][6*j+:6] <= #TCQ rd_byte_data_offset[i][6*j+:6] - 1;
               else // even latency CAS slot 0
                 final_data_offset_mc[i][6*j+:6] <= #TCQ rd_byte_data_offset[i][6*j+:6];
            end 
	  end
          else if (init_dqsfound_done_r5 ) begin
	       if ( DATA_PRESENT [ j*4+:4] == 0) begin // all control lanes
                  final_data_offset[i][6*j+:6] <= #TCQ final_do_max[i];
                  final_data_offset_mc[i][6*j+:6] <= #TCQ final_do_max[i];
               end	
          end
	  end
        end
      end
    end
  endgenerate

  
  // Error generation in case pi_found_dqs signal from Phaser_IN
  // is not asserted when a common rddata_offset value is used
  
  always @(posedge clk) begin
    pi_dqs_found_err    <= #TCQ |pi_dqs_found_err_r;
  end
  

  
endmodule
           
        
      
       

      

