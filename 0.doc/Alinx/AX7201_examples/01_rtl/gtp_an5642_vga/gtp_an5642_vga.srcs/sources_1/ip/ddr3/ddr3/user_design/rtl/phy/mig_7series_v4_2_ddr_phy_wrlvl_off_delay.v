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
//  /   /         Filename: ddr_phy_ck_addr_cmd_delay.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Module to decrement initial PO delay to 0 and add 1/4 tck for tdqss
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_wrlvl_off_delay #
  (
   parameter TCQ           = 100,
   parameter tCK           = 3636,
   parameter nCK_PER_CLK   = 2,
   parameter CLK_PERIOD    = 4,
   parameter PO_INITIAL_DLY= 46,
   parameter DQS_CNT_WIDTH = 3,
   parameter DQS_WIDTH     = 8,
   parameter N_CTL_LANES   = 3
   )
  (
   input                        clk,
   input                        rst,
   input                        pi_fine_dly_dec_done,
   input                        cmd_delay_start,
   // Control lane being shifted using Phaser_Out fine delay taps
   output reg [DQS_CNT_WIDTH:0] ctl_lane_cnt,
   // Inc/dec Phaser_Out fine delay line
   output reg                   po_s2_incdec_f,
   output reg                   po_en_s2_f,
   // Inc/dec Phaser_Out coarse delay line
   output reg                   po_s2_incdec_c,
   output reg                   po_en_s2_c,
   // Completed adjusting delays for dq, dqs for tdqss
   output                      po_ck_addr_cmd_delay_done,
   // completed decrementing initialPO delays
   output                      po_dec_done,
   output                      phy_ctl_rdy_dly
   );


  localparam TAP_LIMIT = 63;



// PO fine delay tap resolution change by frequency. tCK > 2500, need
// twice the amount of taps
//  localparam D_DLY_F = (tCK > 2500 ) ? D_DLY * 2 : D_DLY;

 // coarse delay tap is added DQ/DQS to meet the TDQSS specification.
 //localparam TDQSS_DLY = (tCK > 2500 )? 2: 1;
 localparam TDQSS_DLY = 2; // DIV2 change

   reg       delay_done;
   reg       delay_done_r1;
   reg       delay_done_r2;
   reg       delay_done_r3;
   reg       delay_done_r4;
   reg [5:0] po_delay_cnt_r;
   reg       po_cnt_inc;
   reg       cmd_delay_start_r1;
   reg       cmd_delay_start_r2;
   reg       cmd_delay_start_r3;
   reg       cmd_delay_start_r4;
   reg       cmd_delay_start_r5;
   reg       cmd_delay_start_r6;
   reg       po_delay_done;
   reg       po_delay_done_r1;
   reg       po_delay_done_r2;
   reg       po_delay_done_r3;
   reg       po_delay_done_r4;
   reg       pi_fine_dly_dec_done_r;
   reg       po_en_stg2_c;
   reg       po_en_stg2_f;
   reg       po_stg2_incdec_c;
   reg       po_stg2_f_incdec;
   reg [DQS_CNT_WIDTH:0] lane_cnt_dqs_c_r;
   reg [DQS_CNT_WIDTH:0] lane_cnt_po_r;
   reg [5:0]         delay_cnt_r;

   always @(posedge clk) begin
      cmd_delay_start_r1     <= #TCQ cmd_delay_start;
      cmd_delay_start_r2     <= #TCQ cmd_delay_start_r1;
      cmd_delay_start_r3     <= #TCQ cmd_delay_start_r2;
      cmd_delay_start_r4     <= #TCQ cmd_delay_start_r3;
      cmd_delay_start_r5     <= #TCQ cmd_delay_start_r4;
      cmd_delay_start_r6     <= #TCQ cmd_delay_start_r5;
      pi_fine_dly_dec_done_r <= #TCQ pi_fine_dly_dec_done;
    end

   assign phy_ctl_rdy_dly  = cmd_delay_start_r6;


  // logic for decrementing initial fine delay taps for all PO
  // Decrement done for add, ctrl and data phaser outs

  assign po_dec_done = (PO_INITIAL_DLY == 0) ? 1 : po_delay_done_r4;


  always @(posedge clk)
    if (rst || ~cmd_delay_start_r6 || po_delay_done) begin
      po_stg2_f_incdec  <= #TCQ 1'b0;
      po_en_stg2_f    <= #TCQ 1'b0;
    end else if (po_delay_cnt_r > 6'd0) begin
      po_en_stg2_f    <= #TCQ ~po_en_stg2_f;
    end

  always @(posedge clk)
    if (rst || ~cmd_delay_start_r6 || (po_delay_cnt_r == 6'd0))
      // set all the PO delays to 31. Decrement from 46 to 31.
      // Requirement comes from dqs_found logic
      po_delay_cnt_r  <= #TCQ (PO_INITIAL_DLY - 31);
    else if ( po_en_stg2_f && (po_delay_cnt_r > 6'd0))
      po_delay_cnt_r  <= #TCQ po_delay_cnt_r - 1;

  always @(posedge clk)
    if (rst)
      lane_cnt_po_r  <= #TCQ 'd0;
    else if ( po_en_stg2_f  && (po_delay_cnt_r == 6'd1))
      lane_cnt_po_r  <= #TCQ lane_cnt_po_r + 1;

  always @(posedge clk)
    if (rst || ~cmd_delay_start_r6 )
      po_delay_done    <= #TCQ 1'b0;
    else if ((po_delay_cnt_r == 6'd1) && (lane_cnt_po_r ==1'b0))
      po_delay_done    <= #TCQ 1'b1;

  always @(posedge clk) begin
    po_delay_done_r1 <= #TCQ po_delay_done;
    po_delay_done_r2 <= #TCQ po_delay_done_r1;
    po_delay_done_r3 <= #TCQ po_delay_done_r2;
    po_delay_done_r4 <= #TCQ po_delay_done_r3;
  end

  // logic to select between all PO delays and data path delay.
  always @(posedge clk) begin
    po_s2_incdec_f <= #TCQ po_stg2_f_incdec;
    po_en_s2_f <= #TCQ po_en_stg2_f;
  end

// Logic to add 1/4 taps amount of delay to data path for tdqss.
// After all the initial PO delays are decremented the 1/4 delay will
// be added. Coarse delay taps will be added here .
// Delay added only to data path

   assign po_ck_addr_cmd_delay_done = (TDQSS_DLY == 0) ? pi_fine_dly_dec_done_r
                                     : delay_done_r4;

  always @(posedge clk)
    if (rst || ~pi_fine_dly_dec_done_r || delay_done) begin
      po_stg2_incdec_c   <= #TCQ 1'b1;
      po_en_stg2_c    <= #TCQ 1'b0;
    end else if (delay_cnt_r > 6'd0) begin
      po_en_stg2_c    <= #TCQ ~po_en_stg2_c;
    end

  always @(posedge clk)
    if (rst || ~pi_fine_dly_dec_done_r || (delay_cnt_r == 6'd0))
     delay_cnt_r  <= #TCQ TDQSS_DLY;
    else if ( po_en_stg2_c && (delay_cnt_r > 6'd0))
      delay_cnt_r  <= #TCQ delay_cnt_r - 1;

  always @(posedge clk)
    if (rst)
      lane_cnt_dqs_c_r  <= #TCQ 'd0;
    else if ( po_en_stg2_c && (delay_cnt_r == 6'd1))
      lane_cnt_dqs_c_r  <= #TCQ lane_cnt_dqs_c_r + 1;

  always @(posedge clk)
    if (rst || ~pi_fine_dly_dec_done_r)
      delay_done    <= #TCQ 1'b0;
    else if ((delay_cnt_r == 6'd1) && (lane_cnt_dqs_c_r == 1'b0))
      delay_done    <= #TCQ 1'b1;


   always @(posedge clk) begin
     delay_done_r1 <= #TCQ delay_done;
     delay_done_r2 <= #TCQ delay_done_r1;
     delay_done_r3 <= #TCQ delay_done_r2;
     delay_done_r4 <= #TCQ delay_done_r3;
   end

  always @(posedge clk) begin
    po_s2_incdec_c <= #TCQ po_stg2_incdec_c;
    po_en_s2_c <= #TCQ po_en_stg2_c;
    ctl_lane_cnt <= #TCQ lane_cnt_dqs_c_r;
  end

endmodule

