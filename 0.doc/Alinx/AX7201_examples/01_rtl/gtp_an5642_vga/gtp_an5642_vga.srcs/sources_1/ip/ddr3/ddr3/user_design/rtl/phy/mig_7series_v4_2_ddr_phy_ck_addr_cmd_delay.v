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
//Purpose: Shift CK/Address/Commands/Controls
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay #
  (
   parameter TCQ            = 100,
   parameter tCK            = 3636,
   parameter DQS_CNT_WIDTH  = 3,
   parameter N_CTL_LANES    = 3,
   parameter SIM_CAL_OPTION = "NONE"
   )
  (
   input                        clk,
   input                        rst,
   // Start only after PO_CIRC_BUF_DELAY decremented
   input                        cmd_delay_start,
   // Control lane being shifted using Phaser_Out fine delay taps
   output reg [N_CTL_LANES-1:0] ctl_lane_cnt,
   // Inc/dec Phaser_Out fine delay line
   output reg       po_stg2_f_incdec,
   output reg       po_en_stg2_f,
   output reg       po_stg2_c_incdec,
   output reg       po_en_stg2_c,
   // Completed delaying CK/Address/Commands/Controls
   output           po_ck_addr_cmd_delay_done
   );

   localparam TAP_CNT_LIMIT = 63;

   //Calculate the tap resolution of the PHASER based on the clock period
   localparam FREQ_REF_DIV           = (tCK > 5000 ? 4 :
                                        tCK > 2500 ? 2 : 1);

   localparam integer PHASER_TAP_RES = ((tCK/2)/64);

   // Determine whether 300 ps or 350 ps delay required
   localparam CALC_TAP_CNT = (tCK >= 1250) ? 350 : 300;

   // Determine the number of Phaser_Out taps required to delay by 300 ps
   // 300 ps is the PCB trace uncertainty between CK and DQS byte groups


   // Increment control byte lanes
   localparam TAP_CNT = 0;
   //localparam TAP_CNT = (CALC_TAP_CNT + PHASER_TAP_RES - 1)/PHASER_TAP_RES;
   //Decrement control byte lanes
   localparam TAP_DEC = (SIM_CAL_OPTION == "FAST_CAL") ? 0 : 29;




   reg       delay_dec_done;
   reg       delay_done_r1;
   reg       delay_done_r2;
   reg       delay_done_r3;
   reg       delay_done_r4 /* synthesis syn_maxfan = 10 */;
   reg [5:0] delay_cnt_r;
   reg [5:0] delaydec_cnt_r;
   reg       po_cnt_inc;
   reg       po_cnt_dec;
   reg [3:0] wait_cnt_r;

   assign po_ck_addr_cmd_delay_done = ((TAP_CNT == 0) && (TAP_DEC == 0)) ? 1'b1 : delay_done_r4;

   always @(posedge clk) begin
     if (rst || po_cnt_dec || po_cnt_inc)
       wait_cnt_r <= #TCQ 'd8;
     else if (cmd_delay_start && (wait_cnt_r > 'd0))
       wait_cnt_r <= #TCQ wait_cnt_r - 1;
   end

   always @(posedge clk) begin
     if (rst || (delaydec_cnt_r > 6'd0) || (delay_cnt_r == 'd0) || (TAP_DEC == 0))
       po_cnt_inc      <= #TCQ 1'b0;
     else if ((delay_cnt_r > 'd0) && (wait_cnt_r == 'd1))
       po_cnt_inc      <= #TCQ 1'b1;
     else
       po_cnt_inc      <= #TCQ 1'b0;
   end

   //Tap decrement
   always @(posedge clk) begin
     if (rst || (delaydec_cnt_r == 'd0))
       po_cnt_dec      <= #TCQ 1'b0;
     else if (cmd_delay_start && (delaydec_cnt_r > 'd0) && (wait_cnt_r == 'd1))
       po_cnt_dec      <= #TCQ 1'b1;
     else
       po_cnt_dec      <= #TCQ 1'b0;
   end

   //po_stg2_f_incdec and po_en_stg2_f stay asserted HIGH for TAP_COUNT cycles for every control byte lane
   //the alignment is started once the
   always @(posedge clk) begin
     if (rst) begin
       po_stg2_f_incdec <= #TCQ 1'b0;
       po_en_stg2_f     <= #TCQ 1'b0;
       po_stg2_c_incdec <= #TCQ 1'b0;
       po_en_stg2_c     <= #TCQ 1'b0;
     end else begin
       if (po_cnt_dec) begin
         po_stg2_f_incdec <= #TCQ 1'b0;
         po_en_stg2_f     <= #TCQ 1'b1;
       end else begin
         po_stg2_f_incdec <= #TCQ 1'b0;
         po_en_stg2_f     <= #TCQ 1'b0;
       end
       if (po_cnt_inc) begin
         po_stg2_c_incdec <= #TCQ 1'b1;
         po_en_stg2_c     <= #TCQ 1'b1;
       end else begin
         po_stg2_c_incdec <= #TCQ 1'b0;
         po_en_stg2_c     <= #TCQ 1'b0;
       end
     end
   end

   // delay counter to count 2 cycles
   // Increment coarse taps by 2 for all control byte lanes
   // to mitigate late writes
   always @(posedge clk) begin
     // load delay counter with init value
     if (rst || (tCK >= 2500) || (SIM_CAL_OPTION == "FAST_CAL"))
       delay_cnt_r  <= #TCQ 'd0;
     else if ((delaydec_cnt_r > 6'd0) ||((delay_cnt_r == 6'd0) && (ctl_lane_cnt != N_CTL_LANES-1)))
       delay_cnt_r  <= #TCQ 'd1;
     else if (po_cnt_inc && (delay_cnt_r > 6'd0))
       delay_cnt_r  <= #TCQ delay_cnt_r - 1;
   end

   // delay counter to count TAP_DEC cycles
   always @(posedge clk) begin
     // load delay counter with init value of TAP_DEC
     if (rst || ~cmd_delay_start ||((delaydec_cnt_r == 6'd0) && (delay_cnt_r == 6'd0) && (ctl_lane_cnt != N_CTL_LANES-1)))
       delaydec_cnt_r  <= #TCQ TAP_DEC;
     else if (po_cnt_dec && (delaydec_cnt_r > 6'd0))
       delaydec_cnt_r  <= #TCQ delaydec_cnt_r - 1;
   end

   //ctl_lane_cnt is used to count the number of CTL_LANES or byte lanes that have the address/command phase shifted by 1/4 mem. cycle
   //This ensures all ctrl byte lanes have had their output phase shifted.
   always @(posedge clk) begin
     if (rst || ~cmd_delay_start )
       ctl_lane_cnt <= #TCQ 6'b0;
     else if (~delay_dec_done && (ctl_lane_cnt == N_CTL_LANES-1) && (delaydec_cnt_r == 6'd1))
       ctl_lane_cnt <= #TCQ ctl_lane_cnt;
     else if ((ctl_lane_cnt != N_CTL_LANES-1) && (delaydec_cnt_r == 6'd0) && (delay_cnt_r == 'd0))
       ctl_lane_cnt <= #TCQ ctl_lane_cnt + 1;
   end

   // All control lanes have decremented to 31 fine taps from 46
   always @(posedge clk) begin
     if (rst || ~cmd_delay_start)  begin
       delay_dec_done    <= #TCQ 1'b0;
     end else if (((TAP_CNT == 0) && (TAP_DEC == 0)) ||
                 ((delaydec_cnt_r == 6'd0) && (delay_cnt_r == 'd0) && (ctl_lane_cnt == N_CTL_LANES-1))) begin
       delay_dec_done    <= #TCQ 1'b1;
     end
   end



   always @(posedge clk) begin
     delay_done_r1 <= #TCQ delay_dec_done;
     delay_done_r2 <= #TCQ delay_done_r1;
     delay_done_r3 <= #TCQ delay_done_r2;
     delay_done_r4 <= #TCQ delay_done_r3;
   end

endmodule

