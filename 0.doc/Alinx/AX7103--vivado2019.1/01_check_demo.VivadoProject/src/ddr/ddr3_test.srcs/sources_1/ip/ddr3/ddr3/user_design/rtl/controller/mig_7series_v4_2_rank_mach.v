//*****************************************************************************
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
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
// /___/  \  /    Vendor                : Xilinx
// \   \   \/     Version               : %version
//  \   \         Application           : MIG
//  /   /         Filename              : rank_mach.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Tue Jun 30 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           :
//Reference         :
//Revision History  :
//*****************************************************************************

// Top level rank machine structural block.  This block
// instantiates a configurable number of rank controller blocks.

`timescale 1ps/1ps

module mig_7series_v4_2_rank_mach #
  (
   parameter BURST_MODE               = "8",
   parameter CS_WIDTH                 = 4,
   parameter DRAM_TYPE                = "DDR3",
   parameter MAINT_PRESCALER_DIV      = 40,  
   parameter nBANK_MACHS              = 4,
   parameter nCKESR                   = 4,
   parameter nCK_PER_CLK              = 2,
   parameter CL                       = 5,
   parameter CWL                      = 5,
   parameter DQRD2DQWR_DLY            = 2,
   parameter nFAW                     = 30,
   parameter nREFRESH_BANK            = 8,
   parameter nRRD                     = 4,
   parameter nWTR                     = 4,
   parameter PERIODIC_RD_TIMER_DIV    = 20,  
   parameter RANK_BM_BV_WIDTH         = 16,
   parameter RANK_WIDTH               = 2,
   parameter RANKS                    = 4,
   parameter REFRESH_TIMER_DIV        = 39,  
   parameter ZQ_TIMER_DIV             = 640000
  )
  (/*AUTOARG*/
  // Outputs
  periodic_rd_rank_r, periodic_rd_r, maint_req_r, inhbt_act_faw_r, inhbt_rd,
  inhbt_wr, maint_rank_r, maint_zq_r, maint_sre_r, maint_srx_r, app_sr_active,
  app_ref_ack, app_zq_ack, col_rd_wr, maint_ref_zq_wip,
  // Inputs
  wr_this_rank_r, slot_1_present, slot_0_present, sending_row,
  sending_col, rst, rd_this_rank_r, rank_busy_r, periodic_rd_ack_r,
  maint_wip_r, insert_maint_r1, init_calib_complete, clk, app_zq_req,
  app_sr_req, app_ref_req, app_periodic_rd_req, act_this_rank_r
  );

  /*AUTOINPUT*/
  // Beginning of automatic inputs (from unused autoinst inputs)
  input [RANK_BM_BV_WIDTH-1:0] act_this_rank_r; // To rank_cntrl0 of rank_cntrl.v
  input                 app_periodic_rd_req;    // To rank_cntrl0 of rank_cntrl.v
  input                 app_ref_req;            // To rank_cntrl0 of rank_cntrl.v
  input                 app_zq_req;             // To rank_common0 of rank_common.v
  input                 app_sr_req;             // To rank_common0 of rank_common.v
  input                 clk;                    // To rank_cntrl0 of rank_cntrl.v, ...
  input                 col_rd_wr;              // To rank_cntrl0 of rank_cntrl.v, ...
  input                 init_calib_complete;    // To rank_cntrl0 of rank_cntrl.v, ...
  input                 insert_maint_r1;        // To rank_cntrl0 of rank_cntrl.v, ...
  input                 maint_wip_r;            // To rank_common0 of rank_common.v
  input                 periodic_rd_ack_r;      // To rank_common0 of rank_common.v
  input [(RANKS*nBANK_MACHS)-1:0] rank_busy_r;  // To rank_cntrl0 of rank_cntrl.v
  input [RANK_BM_BV_WIDTH-1:0] rd_this_rank_r;  // To rank_cntrl0 of rank_cntrl.v
  input                 rst;                    // To rank_cntrl0 of rank_cntrl.v, ...
  input [nBANK_MACHS-1:0] sending_col;          // To rank_cntrl0 of rank_cntrl.v
  input [nBANK_MACHS-1:0] sending_row;          // To rank_cntrl0 of rank_cntrl.v
  input [7:0]           slot_0_present;         // To rank_common0 of rank_common.v
  input [7:0]           slot_1_present;         // To rank_common0 of rank_common.v
  input [RANK_BM_BV_WIDTH-1:0] wr_this_rank_r;  // To rank_cntrl0 of rank_cntrl.v
  // End of automatics

  /*AUTOOUTPUT*/
  // Beginning of automatic outputs (from unused autoinst outputs)
  output                maint_req_r;            // From rank_common0 of rank_common.v
  output                periodic_rd_r;          // From rank_common0 of rank_common.v
  output [RANK_WIDTH-1:0] periodic_rd_rank_r;   // From rank_common0 of rank_common.v
  // End of automatics
  
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  maint_prescaler_tick_r; // From rank_common0 of rank_common.v
  wire                  refresh_tick;           // From rank_common0 of rank_common.v
  // End of automatics


  output [RANKS-1:0] inhbt_act_faw_r;
  output [RANKS-1:0] inhbt_rd;
  output [RANKS-1:0] inhbt_wr;
  output [RANK_WIDTH-1:0] maint_rank_r;
  output maint_zq_r;
  output maint_sre_r;
  output maint_srx_r;
  output app_sr_active;
  output app_ref_ack;
  output app_zq_ack;
  output maint_ref_zq_wip;

  wire [RANKS-1:0] refresh_request;
  wire [RANKS-1:0] periodic_rd_request;
  wire [RANKS-1:0] clear_periodic_rd_request;
  
  genvar ID;
  generate
    for (ID=0; ID<RANKS; ID=ID+1) begin:rank_cntrl
      mig_7series_v4_2_rank_cntrl #
        (/*AUTOINSTPARAM*/
         // Parameters
         .BURST_MODE                    (BURST_MODE),
         .ID                            (ID),
         .nBANK_MACHS                   (nBANK_MACHS),
         .nCK_PER_CLK                   (nCK_PER_CLK),
         .CL                            (CL),
         .CWL                           (CWL),
         .DQRD2DQWR_DLY                 (DQRD2DQWR_DLY),
         .nFAW                          (nFAW),
         .nREFRESH_BANK                 (nREFRESH_BANK),
         .nRRD                          (nRRD),
         .nWTR                          (nWTR),
         .PERIODIC_RD_TIMER_DIV         (PERIODIC_RD_TIMER_DIV),
         .RANK_BM_BV_WIDTH              (RANK_BM_BV_WIDTH),
         .RANK_WIDTH                    (RANK_WIDTH),
         .RANKS                         (RANKS),
         .REFRESH_TIMER_DIV             (REFRESH_TIMER_DIV))
        rank_cntrl0 
          (.clear_periodic_rd_request   (clear_periodic_rd_request[ID]),
           .inhbt_act_faw_r             (inhbt_act_faw_r[ID]),
           .inhbt_rd                    (inhbt_rd[ID]),
           .inhbt_wr                    (inhbt_wr[ID]),
           .periodic_rd_request         (periodic_rd_request[ID]),
           .refresh_request             (refresh_request[ID]),
           /*AUTOINST*/
           // Inputs
           .clk                         (clk),
           .rst                         (rst),
           .col_rd_wr                   (col_rd_wr),
           .sending_row                 (sending_row[nBANK_MACHS-1:0]),
           .act_this_rank_r             (act_this_rank_r[RANK_BM_BV_WIDTH-1:0]),
           .sending_col                 (sending_col[nBANK_MACHS-1:0]),
           .wr_this_rank_r              (wr_this_rank_r[RANK_BM_BV_WIDTH-1:0]),
           .app_ref_req                 (app_ref_req),
           .init_calib_complete         (init_calib_complete),
           .rank_busy_r                 (rank_busy_r[(RANKS*nBANK_MACHS)-1:0]),
           .refresh_tick                (refresh_tick),
           .insert_maint_r1             (insert_maint_r1),
           .maint_zq_r                  (maint_zq_r),
           .maint_sre_r                 (maint_sre_r),
           .maint_srx_r                 (maint_srx_r),
           .maint_rank_r                (maint_rank_r[RANK_WIDTH-1:0]),
           .app_periodic_rd_req         (app_periodic_rd_req),
           .maint_prescaler_tick_r      (maint_prescaler_tick_r),
           .rd_this_rank_r              (rd_this_rank_r[RANK_BM_BV_WIDTH-1:0]));
    end
  endgenerate

  mig_7series_v4_2_rank_common #
    (/*AUTOINSTPARAM*/
     // Parameters
     .DRAM_TYPE                         (DRAM_TYPE),
     .MAINT_PRESCALER_DIV               (MAINT_PRESCALER_DIV),
     .nBANK_MACHS                       (nBANK_MACHS),
     .nCKESR                            (nCKESR),
     .nCK_PER_CLK                       (nCK_PER_CLK),
     .PERIODIC_RD_TIMER_DIV             (PERIODIC_RD_TIMER_DIV),
     .RANK_WIDTH                        (RANK_WIDTH),
     .RANKS                             (RANKS),
     .REFRESH_TIMER_DIV                 (REFRESH_TIMER_DIV),
     .ZQ_TIMER_DIV                      (ZQ_TIMER_DIV))
    rank_common0
    (.clear_periodic_rd_request         (clear_periodic_rd_request[RANKS-1:0]),
     /*AUTOINST*/
     // Outputs
     .maint_prescaler_tick_r            (maint_prescaler_tick_r),
     .refresh_tick                      (refresh_tick),
     .maint_zq_r                        (maint_zq_r),
     .maint_sre_r                       (maint_sre_r),
     .maint_srx_r                       (maint_srx_r),
     .maint_req_r                       (maint_req_r),
     .maint_rank_r                      (maint_rank_r[RANK_WIDTH-1:0]),
     .maint_ref_zq_wip                  (maint_ref_zq_wip),
     .periodic_rd_r                     (periodic_rd_r),
     .periodic_rd_rank_r                (periodic_rd_rank_r[RANK_WIDTH-1:0]),
     // Inputs
     .clk                               (clk),
     .rst                               (rst),
     .init_calib_complete               (init_calib_complete),
     .app_ref_req                       (app_ref_req),
     .app_ref_ack                       (app_ref_ack),
     .app_zq_req                        (app_zq_req),
     .app_zq_ack                        (app_zq_ack),
     .app_sr_req                        (app_sr_req),
     .app_sr_active                     (app_sr_active),
     .insert_maint_r1                   (insert_maint_r1),
     .refresh_request                   (refresh_request[RANKS-1:0]),
     .maint_wip_r                       (maint_wip_r),
     .slot_0_present                    (slot_0_present[7:0]),
     .slot_1_present                    (slot_1_present[7:0]),
     .periodic_rd_request               (periodic_rd_request[RANKS-1:0]),
     .periodic_rd_ack_r                 (periodic_rd_ack_r));

   
endmodule

