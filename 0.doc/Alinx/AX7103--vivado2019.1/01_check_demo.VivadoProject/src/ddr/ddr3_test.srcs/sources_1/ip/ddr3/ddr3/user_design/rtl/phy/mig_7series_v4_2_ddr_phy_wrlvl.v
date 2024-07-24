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
//  /   /         Filename: ddr_phy_wrlvl.v
// /___/   /\     Date Last Modified: $Date: 2011/06/24 14:49:00 $
// \   \  /  \    Date Created: Mon Jun 23 2008
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  Memory initialization and overall master state control during
//  initialization and calibration. Specifically, the following functions
//  are performed:
//    1. Memory initialization (initial AR, mode register programming, etc.)
//    2. Initiating write leveling
//    3. Generate training pattern writes for read leveling. Generate
//       memory readback for read leveling.
//  This module has a DFI interface for providing control/address and write
//  data to the rest of the PHY datapath during initialization/calibration.
//  Once initialization is complete, control is passed to the MC. 
//  NOTES:
//    1. Multiple CS (multi-rank) not supported
//    2. DDR2 not supported
//    3. ODT not supported
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_wrlvl.v,v 1.3 2011/06/24 14:49:00 mgeorge Exp $
**$Date: 2011/06/24 14:49:00 $
**$Author: mgeorge $
**$Revision: 1.3 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_phy_wrlvl.v,v $
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_wrlvl #
  (
   parameter TCQ = 100,
   parameter DQS_CNT_WIDTH     = 3,
   parameter DQ_WIDTH          = 64,
   parameter DQS_WIDTH         = 2,
   parameter DRAM_WIDTH        = 8,
   parameter RANKS             = 1,
   parameter nCK_PER_CLK       = 4,
   parameter CLK_PERIOD        = 4,
   parameter SIM_CAL_OPTION    = "NONE"
   )
  (
   input                        clk,
   input                        rst,
   input                        phy_ctl_ready,
   input                        wr_level_start,
   input                        wl_sm_start,
   input                        wrlvl_final,
   input                        wrlvl_byte_redo,
   input [DQS_CNT_WIDTH:0]      wrcal_cnt,
   input                        early1_data,
   input                        early2_data,
   input [DQS_CNT_WIDTH:0]      oclkdelay_calib_cnt,
   input                        oclkdelay_calib_done,
   input [(DQ_WIDTH)-1:0]       rd_data_rise0,
   output reg                   wrlvl_byte_done,
    output reg dqs_po_dec_done /* synthesis syn_maxfan = 2 */,
   output                       phy_ctl_rdy_dly,
    output reg wr_level_done /* synthesis syn_maxfan = 2 */,
   // to phy_init for cs logic
   output                       wrlvl_rank_done,
   output                       done_dqs_tap_inc,
   output [DQS_CNT_WIDTH:0]     po_stg2_wl_cnt,
   // Fine delay line used only during write leveling
   // Inc/dec Phaser_Out fine delay line
   output reg                   dqs_po_stg2_f_incdec,
   // Enable Phaser_Out fine delay inc/dec
   output reg                   dqs_po_en_stg2_f,
   // Coarse delay line used during write leveling
   // only if 64 taps of fine delay line were not
   // sufficient to detect a 0->1 transition
   // Inc Phaser_Out coarse delay line
   output reg                   dqs_wl_po_stg2_c_incdec,
   // Enable Phaser_Out coarse delay inc/dec
   output reg                   dqs_wl_po_en_stg2_c,
   // Read Phaser_Out delay value
   input [8:0]                  po_counter_read_val,
//   output reg                   dqs_wl_po_stg2_load,
//   output reg [8:0]             dqs_wl_po_stg2_reg_l,
   // CK edge undetected
   output reg                   wrlvl_err,
   output reg [3*DQS_WIDTH-1:0] wl_po_coarse_cnt,
   output reg [6*DQS_WIDTH-1:0] wl_po_fine_cnt,
   // Debug ports
   output [5:0]                 dbg_wl_tap_cnt,
   output                       dbg_wl_edge_detect_valid,
   output [(DQS_WIDTH)-1:0]     dbg_rd_data_edge_detect,
   output [DQS_CNT_WIDTH:0]     dbg_dqs_count,
   output [4:0]                 dbg_wl_state,
   output [6*DQS_WIDTH-1:0]     dbg_wrlvl_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]     dbg_wrlvl_coarse_tap_cnt,
   output [255:0]               dbg_phy_wrlvl   
   );


   localparam WL_IDLE               = 5'h0;
   localparam WL_INIT               = 5'h1;
   localparam WL_INIT_FINE_INC      = 5'h2;
   localparam WL_INIT_FINE_INC_WAIT1= 5'h3;
   localparam WL_INIT_FINE_INC_WAIT = 5'h4;
   localparam WL_INIT_FINE_DEC      = 5'h5;
   localparam WL_INIT_FINE_DEC_WAIT = 5'h6;
   localparam WL_FINE_INC           = 5'h7;
   localparam WL_WAIT               = 5'h8;
   localparam WL_EDGE_CHECK         = 5'h9;
   localparam WL_DQS_CHECK          = 5'hA;
   localparam WL_DQS_CNT            = 5'hB;
   localparam WL_2RANK_TAP_DEC      = 5'hC;
   localparam WL_2RANK_DQS_CNT      = 5'hD;
   localparam WL_FINE_DEC           = 5'hE;
   localparam WL_FINE_DEC_WAIT      = 5'hF;
   localparam WL_CORSE_INC          = 5'h10;
   localparam WL_CORSE_INC_WAIT     = 5'h11;
   localparam WL_CORSE_INC_WAIT1    = 5'h12;
   localparam WL_CORSE_INC_WAIT2    = 5'h13;
   localparam WL_CORSE_DEC          = 5'h14;
   localparam WL_CORSE_DEC_WAIT     = 5'h15;
   localparam WL_CORSE_DEC_WAIT1    = 5'h16;
   localparam WL_FINE_INC_WAIT      = 5'h17;
   localparam WL_2RANK_FINAL_TAP    = 5'h18;
   localparam WL_INIT_FINE_DEC_WAIT1= 5'h19;
   localparam WL_FINE_DEC_WAIT1     = 5'h1A;
   localparam WL_CORSE_INC_WAIT_TMP = 5'h1B;

   localparam  COARSE_TAPS = 7;
   
   localparam FAST_CAL_FINE   = (CLK_PERIOD/nCK_PER_CLK <= 2500) ? 45 : 48;
   localparam FAST_CAL_COARSE = (CLK_PERIOD/nCK_PER_CLK <= 2500) ? 1 : 2;
   localparam REDO_COARSE = (CLK_PERIOD/nCK_PER_CLK <= 2500) ? 2 : 5;


   integer     i, j, k, l, p, q, r, s, t, m, n, u, v, w, x,y;

   reg                   phy_ctl_ready_r1;
   reg                   phy_ctl_ready_r2;
   reg                   phy_ctl_ready_r3;
   reg                   phy_ctl_ready_r4;
   reg                   phy_ctl_ready_r5;
   reg                   phy_ctl_ready_r6;
   (* max_fanout = 50 *) reg [DQS_CNT_WIDTH:0] dqs_count_r;
   reg [1:0]             rank_cnt_r;
   reg [DQS_WIDTH-1:0]   rd_data_rise_wl_r;
   reg [DQS_WIDTH-1:0]   rd_data_previous_r;
   reg [DQS_WIDTH-1:0]   rd_data_edge_detect_r;
   reg                   wr_level_done_r;
   reg                   wrlvl_rank_done_r;
   reg                   wr_level_start_r;
   reg [4:0]             wl_state_r, wl_state_r1;
   reg                   inhibit_edge_detect_r;
   reg                   wl_edge_detect_valid_r;
   reg [5:0]             wl_tap_count_r;
   reg [5:0]             fine_dec_cnt;
   reg [5:0]             fine_inc[0:DQS_WIDTH-1];  // DQS_WIDTH number of counters 6-bit each
   reg [2:0]             corse_dec[0:DQS_WIDTH-1];
   reg [2:0]             corse_inc[0:DQS_WIDTH-1];
   reg                   dq_cnt_inc;
   reg [3:0]             stable_cnt;
   reg                   flag_ck_negedge;
   //reg                   past_negedge;
   reg                   flag_init;
   reg [2:0]             corse_cnt[0:DQS_WIDTH-1];
   reg [3*DQS_WIDTH-1:0] corse_cnt_dbg;
   reg [2:0]             wl_corse_cnt[0:RANKS-1][0:DQS_WIDTH-1];
   //reg [3*DQS_WIDTH-1:0] coarse_tap_inc;
   reg [2:0]             final_coarse_tap[0:DQS_WIDTH-1];
   reg [5:0]             add_smallest[0:DQS_WIDTH-1];
   reg [5:0]             add_largest[0:DQS_WIDTH-1];
 //reg [6*DQS_WIDTH-1:0] fine_tap_inc;
   //reg [6*DQS_WIDTH-1:0] fine_tap_dec;
   reg                   wr_level_done_r1;
   reg                   wr_level_done_r2;
   reg                   wr_level_done_r3;
   reg                   wr_level_done_r4;
   reg                   wr_level_done_r5;
   reg [5:0]             wl_dqs_tap_count_r[0:RANKS-1][0:DQS_WIDTH-1];
   reg [5:0]             smallest[0:DQS_WIDTH-1];
   reg [5:0]             largest[0:DQS_WIDTH-1];
   reg [5:0]             final_val[0:DQS_WIDTH-1];
   reg [5:0]             po_dec_cnt[0:DQS_WIDTH-1];
   reg                   done_dqs_dec;
   reg [8:0]             po_rdval_cnt;
   reg                   po_cnt_dec;
   reg                   po_dec_done;
   reg                   dual_rnk_dec;
   wire [DQS_CNT_WIDTH+2:0] dqs_count_w;
   reg [5:0]             fast_cal_fine_cnt;
   reg [2:0]             fast_cal_coarse_cnt;
   reg                   wrlvl_byte_redo_r;
   reg [2:0]             wrlvl_redo_corse_inc;
   reg                   wrlvl_final_r;
   reg                   final_corse_dec;
   wire [DQS_CNT_WIDTH+2:0] oclk_count_w;
   reg                   wrlvl_tap_done_r ;
   reg [3:0]             wait_cnt;
   reg [3:0]             incdec_wait_cnt;
 


  // Debug ports
   assign dbg_wl_edge_detect_valid = wl_edge_detect_valid_r;
   assign dbg_rd_data_edge_detect  = rd_data_edge_detect_r;
   assign dbg_wl_tap_cnt           = wl_tap_count_r;
   assign dbg_dqs_count            = dqs_count_r;
   assign dbg_wl_state             = wl_state_r;
   assign dbg_wrlvl_fine_tap_cnt   = wl_po_fine_cnt;
   assign dbg_wrlvl_coarse_tap_cnt = wl_po_coarse_cnt;

   always @(*) begin
     for (v = 0; v < DQS_WIDTH; v = v + 1)
       corse_cnt_dbg[3*v+:3] = corse_cnt[v];
   end
  
   assign dbg_phy_wrlvl[0+:27]  = corse_cnt_dbg;
   assign dbg_phy_wrlvl[27+:5]  = wl_state_r;
   assign dbg_phy_wrlvl[32+:4]  = dqs_count_r;
   assign dbg_phy_wrlvl[36+:9]  = rd_data_rise_wl_r;
   assign dbg_phy_wrlvl[45+:9]  = rd_data_previous_r;
   assign dbg_phy_wrlvl[54+:4]  = stable_cnt;
   assign dbg_phy_wrlvl[58]     = 'd0;
   assign dbg_phy_wrlvl[59]     = flag_ck_negedge;

   assign dbg_phy_wrlvl [60]    = wl_edge_detect_valid_r;
   assign dbg_phy_wrlvl [61+:6] = wl_tap_count_r;
   assign dbg_phy_wrlvl [67+:9] = rd_data_edge_detect_r;
   assign dbg_phy_wrlvl [76+:54]  = wl_po_fine_cnt;
   assign dbg_phy_wrlvl [130+:27] = wl_po_coarse_cnt;
  

   
   //**************************************************************************
   // DQS count to hard PHY during write leveling using Phaser_OUT Stage2 delay 
   //**************************************************************************
   assign po_stg2_wl_cnt = dqs_count_r;

   assign wrlvl_rank_done = wrlvl_rank_done_r;
   
   assign done_dqs_tap_inc = done_dqs_dec;
   
   assign phy_ctl_rdy_dly = phy_ctl_ready_r6;
   
   always @(posedge clk) begin
     phy_ctl_ready_r1  <= #TCQ phy_ctl_ready;
     phy_ctl_ready_r2  <= #TCQ phy_ctl_ready_r1;
     phy_ctl_ready_r3  <= #TCQ phy_ctl_ready_r2;
     phy_ctl_ready_r4  <= #TCQ phy_ctl_ready_r3;
     phy_ctl_ready_r5  <= #TCQ phy_ctl_ready_r4;
     phy_ctl_ready_r6  <= #TCQ phy_ctl_ready_r5;
     wrlvl_byte_redo_r <= #TCQ wrlvl_byte_redo;
     wrlvl_final_r     <= #TCQ wrlvl_final;
     if ((wrlvl_byte_redo && ~wrlvl_byte_redo_r) ||
         (wrlvl_final && ~wrlvl_final_r))
       wr_level_done  <= #TCQ 1'b0;
     else
       wr_level_done  <= #TCQ done_dqs_dec;
   end

// Status signal that will be asserted once the first 
// pass of write leveling is done.  
   always @(posedge clk) begin
     if(rst) begin
       wrlvl_tap_done_r <= #TCQ 1'b0 ;
     end else begin
       if(wrlvl_tap_done_r == 1'b0) begin
         if(oclkdelay_calib_done) begin
	   wrlvl_tap_done_r <= #TCQ 1'b1 ;
	 end
       end
     end
   end
   
   always @(posedge clk) begin
     if (rst || po_cnt_dec)
       wait_cnt <= #TCQ 'd8;
     else if (phy_ctl_ready_r6 && (wait_cnt > 'd0))
       wait_cnt <= #TCQ wait_cnt - 1;
   end
   
   always @(posedge clk) begin
     if (rst) begin
       po_rdval_cnt    <= #TCQ 'd0;
     end else if (phy_ctl_ready_r5 && ~phy_ctl_ready_r6) begin
       po_rdval_cnt    <= #TCQ po_counter_read_val;
     end else if (po_rdval_cnt > 'd0) begin
       if (po_cnt_dec)
         po_rdval_cnt  <= #TCQ po_rdval_cnt - 1;
       else            
         po_rdval_cnt  <= #TCQ po_rdval_cnt;
     end else if (po_rdval_cnt == 'd0) begin
       po_rdval_cnt    <= #TCQ po_rdval_cnt;
     end
   end

   always @(posedge clk) begin
     if (rst || (po_rdval_cnt == 'd0))
       po_cnt_dec      <= #TCQ 1'b0;
     else if (phy_ctl_ready_r6 && (po_rdval_cnt > 'd0) && (wait_cnt == 'd1))
       po_cnt_dec      <= #TCQ 1'b1;
     else
       po_cnt_dec      <= #TCQ 1'b0;
     end
   
   always @(posedge clk) begin
     if (rst)
       po_dec_done <= #TCQ 1'b0;
     else if (((po_cnt_dec == 'd1) && (po_rdval_cnt == 'd1)) || 
              (phy_ctl_ready_r6 && (po_rdval_cnt == 'd0))) begin
       po_dec_done <= #TCQ 1'b1;
     end
   end

   
   always @(posedge clk) begin
     dqs_po_dec_done  <= #TCQ po_dec_done;
     wr_level_done_r1 <= #TCQ wr_level_done_r;
     wr_level_done_r2 <= #TCQ wr_level_done_r1;
     wr_level_done_r3 <= #TCQ wr_level_done_r2;
     wr_level_done_r4 <= #TCQ wr_level_done_r3;
     wr_level_done_r5 <= #TCQ wr_level_done_r4;
     for (l = 0; l < DQS_WIDTH; l = l + 1) begin 
       wl_po_coarse_cnt[3*l+:3] <= #TCQ final_coarse_tap[l];
       if ((RANKS == 1) || ~oclkdelay_calib_done)
         wl_po_fine_cnt[6*l+:6] <= #TCQ smallest[l];
       else 
         wl_po_fine_cnt[6*l+:6] <= #TCQ final_val[l];
     end
   end
   
   generate
   if (RANKS == 2) begin: dual_rank
     always @(posedge clk) begin
       if (rst || (wrlvl_byte_redo && ~wrlvl_byte_redo_r) ||
         (wrlvl_final && ~wrlvl_final_r))
         done_dqs_dec <= #TCQ 1'b0;
       else if ((SIM_CAL_OPTION == "FAST_CAL") || ~oclkdelay_calib_done)
         done_dqs_dec <= #TCQ wr_level_done_r;
       else if (wr_level_done_r5 && (wl_state_r == WL_IDLE))
         done_dqs_dec <= #TCQ 1'b1;
     end
   end else begin: single_rank
     always @(posedge clk) begin
       if (rst || (wrlvl_byte_redo && ~wrlvl_byte_redo_r) ||
         (wrlvl_final && ~wrlvl_final_r))
         done_dqs_dec <= #TCQ 1'b0;
       else if (~oclkdelay_calib_done)
         done_dqs_dec <= #TCQ wr_level_done_r;
       else if (wr_level_done_r3 && ~wr_level_done_r4)
         done_dqs_dec <= #TCQ 1'b1;
     end
   end
   endgenerate
   
   always @(posedge clk)
     if (rst || (wrlvl_byte_redo && ~wrlvl_byte_redo_r))
       wrlvl_byte_done <= #TCQ 1'b0;
     else if (wrlvl_byte_redo && wr_level_done_r3 && ~wr_level_done_r4)
       wrlvl_byte_done <= #TCQ 1'b1;
  
   // Storing DQS tap values at the end of each DQS write leveling
   always @(posedge clk) begin
     if (rst) begin
       for (k = 0; k < RANKS; k = k + 1) begin: rst_wl_dqs_tap_count_loop
         for (n = 0; n < DQS_WIDTH; n = n + 1) begin
           wl_corse_cnt[k][n]       <= #TCQ 'b0;
           wl_dqs_tap_count_r[k][n] <= #TCQ 'b0;
         end
       end
     end else if ((wl_state_r == WL_DQS_CNT) | (wl_state_r == WL_WAIT) | 
                  (wl_state_r == WL_FINE_DEC_WAIT1) |
                  (wl_state_r == WL_2RANK_TAP_DEC)) begin
         wl_dqs_tap_count_r[rank_cnt_r][dqs_count_r] <= #TCQ wl_tap_count_r;
         wl_corse_cnt[rank_cnt_r][dqs_count_r]       <= #TCQ corse_cnt[dqs_count_r];
     end else if ((SIM_CAL_OPTION == "FAST_CAL") & (wl_state_r == WL_DQS_CHECK)) begin
       for (p = 0; p < RANKS; p = p +1) begin: dqs_tap_rank_cnt   
         for(q = 0; q < DQS_WIDTH; q = q +1) begin: dqs_tap_dqs_cnt
           wl_dqs_tap_count_r[p][q] <= #TCQ wl_tap_count_r;
           wl_corse_cnt[p][q]       <= #TCQ corse_cnt[0];
         end
       end
     end
   end
   
   // Convert coarse delay to fine taps in case of unequal number of coarse
   // taps between ranks. Assuming a difference of 1 coarse tap counts
   // between ranks. A common fine and coarse tap value must be used for both ranks
   // because Phaser_Out has only one rank register.
   // Coarse tap1 = period(ps)*93/360 = 34 fine taps
   // Other coarse taps = period(ps)*103/360 = 38 fine taps

   generate
   genvar cnt;
   if (RANKS == 2) begin // Dual rank
     for(cnt = 0; cnt < DQS_WIDTH; cnt = cnt +1) begin: coarse_dqs_cnt
       always @(posedge clk) begin
         if (rst) begin
           //coarse_tap_inc[3*cnt+:3]  <= #TCQ 'b0;
           add_smallest[cnt]         <= #TCQ 'd0;
           add_largest[cnt]          <= #TCQ 'd0;
           final_coarse_tap[cnt]     <= #TCQ 'd0;
         end else if (wr_level_done_r1 & ~wr_level_done_r2) begin
           if (~oclkdelay_calib_done) begin
	    for(y = 0 ; y < DQS_WIDTH; y = y+1) begin
              final_coarse_tap[y] <= #TCQ wl_corse_cnt[0][y]; 
              add_smallest[y]     <= #TCQ 'd0;
              add_largest[y]      <= #TCQ 'd0;
	     end
           end else 
	   if (wl_corse_cnt[0][cnt] == wl_corse_cnt[1][cnt]) begin
           // Both ranks have use the same number of coarse delay taps.
           // No conversion of coarse tap to fine taps required. 
             //coarse_tap_inc[3*cnt+:3]  <= #TCQ wl_corse_cnt[1][3*cnt+:3];
             final_coarse_tap[cnt]     <= #TCQ wl_corse_cnt[1][cnt];
             add_smallest[cnt]         <= #TCQ 'd0;
             add_largest[cnt]          <= #TCQ 'd0;
           end else if (wl_corse_cnt[0][cnt] < wl_corse_cnt[1][cnt]) begin
           // Rank 0 uses fewer coarse delay taps than rank1.
           // conversion of coarse tap to fine taps required for rank1.
           // The final coarse count will the smaller value.
             //coarse_tap_inc[3*cnt+:3]  <= #TCQ wl_corse_cnt[1][3*cnt+:3] - 1;
             final_coarse_tap[cnt]     <= #TCQ wl_corse_cnt[1][cnt] - 1;
             if (|wl_corse_cnt[0][cnt])
               // Coarse tap 2 or higher being converted to fine taps
               // This will be added to 'largest' value in final_val
               // computation 
               add_largest[cnt] <= #TCQ 'd38;
             else
               // Coarse tap 1 being converted to fine taps
               // This will be added to 'largest' value in final_val
               // computation
               add_largest[cnt] <= #TCQ 'd34;
           end else if (wl_corse_cnt[0][cnt] > wl_corse_cnt[1][cnt]) begin
           // This may be an unlikely scenario in a real system.
           // Rank 0 uses more coarse delay taps than rank1.
           // conversion of coarse tap to fine taps required.
             //coarse_tap_inc[3*cnt+:3]  <= #TCQ 'd0;
             final_coarse_tap[cnt]   <= #TCQ wl_corse_cnt[1][cnt];
             if (|wl_corse_cnt[1][cnt])
               // Coarse tap 2 or higher being converted to fine taps
               // This will be added to 'smallest' value in final_val
               // computation
               add_smallest[cnt] <= #TCQ 'd38;
             else
               // Coarse tap 1 being converted to fine taps
               // This will be added to 'smallest' value in
               // final_val computation
               add_smallest[cnt] <= #TCQ 'd34;
           end
         end
       end
     end
   end else begin
 // Single rank
     always @(posedge clk) begin
       //coarse_tap_inc   <= #TCQ 'd0;
       for(w = 0; w < DQS_WIDTH; w = w + 1) begin
         final_coarse_tap[w] <= #TCQ wl_corse_cnt[0][w];
         add_smallest[w]     <= #TCQ 'd0;
         add_largest[w]      <= #TCQ 'd0;
       end
     end
   end
   endgenerate

   
   // Determine delay value for DQS in multirank system
   // Assuming delay value is the smallest for rank 0 DQS 
   // and largest delay value for rank 4 DQS
   // Set to smallest + ((largest-smallest)/2)
   always @(posedge clk) begin
     if (rst) begin
       for(x = 0; x < DQS_WIDTH; x = x +1) begin
         smallest[x] <= #TCQ 'b0;
         largest[x]  <= #TCQ 'b0;
       end
     end else if ((wl_state_r == WL_DQS_CNT) & wrlvl_byte_redo) begin
       smallest[dqs_count_r] <= #TCQ wl_dqs_tap_count_r[0][dqs_count_r];
       largest[dqs_count_r]  <= #TCQ wl_dqs_tap_count_r[0][dqs_count_r];
     end else if ((wl_state_r == WL_DQS_CNT) | 
                  (wl_state_r == WL_2RANK_TAP_DEC)) begin
       smallest[dqs_count_r] <= #TCQ wl_dqs_tap_count_r[0][dqs_count_r];
       largest[dqs_count_r]  <= #TCQ wl_dqs_tap_count_r[RANKS-1][dqs_count_r];
     end else if (((SIM_CAL_OPTION == "FAST_CAL") | 
                   (~oclkdelay_calib_done & ~wrlvl_byte_redo)) & 
                  wr_level_done_r1 & ~wr_level_done_r2) begin
       for(i = 0; i < DQS_WIDTH; i = i +1) begin: smallest_dqs
         smallest[i] <= #TCQ wl_dqs_tap_count_r[0][i];
         largest[i]  <= #TCQ wl_dqs_tap_count_r[0][i];
       end
     end
   end

   
// final_val to be used for all DQSs in all ranks   
   genvar wr_i;
   generate
     for (wr_i = 0; wr_i < DQS_WIDTH; wr_i = wr_i +1) begin: gen_final_tap
      always @(posedge clk) begin
        if (rst)
          final_val[wr_i] <= #TCQ 'b0;
        else if (wr_level_done_r2 && ~wr_level_done_r3) begin
          if (~oclkdelay_calib_done)
            final_val[wr_i] <= #TCQ (smallest[wr_i] + add_smallest[wr_i]); 
          else if ((smallest[wr_i] + add_smallest[wr_i]) < 
                   (largest[wr_i] + add_largest[wr_i]))
            final_val[wr_i] <= #TCQ ((smallest[wr_i] + add_smallest[wr_i]) +
                                     (((largest[wr_i] + add_largest[wr_i]) -
                                     (smallest[wr_i] + add_smallest[wr_i]))/2));
          else if ((smallest[wr_i] + add_smallest[wr_i]) >
                   (largest[wr_i] + add_largest[wr_i]))
            final_val[wr_i] <= #TCQ ((largest[wr_i] + add_largest[wr_i]) +
                                     (((smallest[wr_i] + add_smallest[wr_i]) -
                                     (largest[wr_i] + add_largest[wr_i]))/2));
          else if ((smallest[wr_i] + add_smallest[wr_i]) ==
                   (largest[wr_i] + add_largest[wr_i]))
            final_val[wr_i] <= #TCQ (largest[wr_i] + add_largest[wr_i]);
        end
      end
     end
   endgenerate
    
//    // fine tap inc/dec value for all DQSs in all ranks
//    genvar dqs_i;
//    generate
//      for (dqs_i = 0; dqs_i < DQS_WIDTH; dqs_i = dqs_i +1) begin: gen_fine_tap
//       always @(posedge clk) begin
//         if (rst)
//           fine_tap_inc[6*dqs_i+:6] <= #TCQ 'd0;
//           //fine_tap_dec[6*dqs_i+:6] <= #TCQ 'd0;
//         else if (wr_level_done_r3 && ~wr_level_done_r4) begin
//           fine_tap_inc[6*dqs_i+:6] <= #TCQ final_val[6*dqs_i+:6];
//             //fine_tap_dec[6*dqs_i+:6] <= #TCQ 'd0;
//       end
//      end
//    endgenerate

   
   // Inc/Dec Phaser_Out stage 2 fine delay line
   always @(posedge clk) begin
     if (rst) begin
     // Fine delay line used only during write leveling
       dqs_po_stg2_f_incdec   <= #TCQ 1'b0;
       dqs_po_en_stg2_f       <= #TCQ 1'b0;
     // Dec Phaser_Out fine delay (1)before write leveling,
     // (2)if no 0 to 1 transition detected with 63 fine delay taps, or 
     // (3)dual rank case where fine taps for the first rank need to be 0
     end else if (po_cnt_dec || (wl_state_r == WL_INIT_FINE_DEC) ||
                  (wl_state_r == WL_FINE_DEC)) begin
       dqs_po_stg2_f_incdec <= #TCQ 1'b0;
       dqs_po_en_stg2_f     <= #TCQ 1'b1;
     // Inc Phaser_Out fine delay during write leveling
     end else if ((wl_state_r == WL_INIT_FINE_INC) ||
                  (wl_state_r == WL_FINE_INC)) begin
       dqs_po_stg2_f_incdec <= #TCQ 1'b1;
       dqs_po_en_stg2_f     <= #TCQ 1'b1;
     end else begin
       dqs_po_stg2_f_incdec <= #TCQ 1'b0;
       dqs_po_en_stg2_f     <= #TCQ 1'b0; 
     end
   end
   

   // Inc Phaser_Out stage 2 Coarse delay line
   always @(posedge clk) begin
     if (rst) begin
     // Coarse delay line used during write leveling
     // only if no 0->1 transition undetected with 64
     // fine delay line taps
       dqs_wl_po_stg2_c_incdec   <= #TCQ 1'b0;
       dqs_wl_po_en_stg2_c       <= #TCQ 1'b0;
     end else if (wl_state_r == WL_CORSE_INC) begin
     // Inc Phaser_Out coarse delay during write leveling
       dqs_wl_po_stg2_c_incdec <= #TCQ 1'b1;
       dqs_wl_po_en_stg2_c     <= #TCQ 1'b1;
     end else begin
       dqs_wl_po_stg2_c_incdec <= #TCQ 1'b0;
       dqs_wl_po_en_stg2_c     <= #TCQ 1'b0; 
     end
   end
     

   // only storing the rise data for checking. The data comming back during
   // write leveling will be a static value. Just checking for rise data is
   // enough. 

genvar rd_i;
generate
  for(rd_i = 0; rd_i < DQS_WIDTH; rd_i = rd_i +1)begin: gen_rd
   always @(posedge clk)
     rd_data_rise_wl_r[rd_i] <=
     #TCQ |rd_data_rise0[(rd_i*DRAM_WIDTH)+DRAM_WIDTH-1:rd_i*DRAM_WIDTH];
  end
endgenerate


   // storing the previous data for checking later.
   always @(posedge clk)begin
     if ((wl_state_r == WL_INIT) || //(wl_state_r == WL_INIT_FINE_INC_WAIT) ||
         //(wl_state_r == WL_INIT_FINE_INC_WAIT1) ||
		 ((wl_state_r1 == WL_INIT_FINE_INC_WAIT) & (wl_state_r == WL_INIT_FINE_INC)) ||
         (wl_state_r == WL_FINE_DEC) || (wl_state_r == WL_FINE_DEC_WAIT1) || (wl_state_r == WL_FINE_DEC_WAIT) ||
         (wl_state_r == WL_CORSE_INC) || (wl_state_r == WL_CORSE_INC_WAIT) || (wl_state_r == WL_CORSE_INC_WAIT_TMP) || 
         (wl_state_r == WL_CORSE_INC_WAIT1) || (wl_state_r == WL_CORSE_INC_WAIT2) ||
         ((wl_state_r == WL_EDGE_CHECK) & (wl_edge_detect_valid_r)))
       rd_data_previous_r         <= #TCQ rd_data_rise_wl_r;
   end
   
   // changed stable count from 3 to 7 because of fine tap resolution
   always @(posedge clk)begin
      if (rst | (wl_state_r == WL_DQS_CNT) |
         (wl_state_r == WL_2RANK_TAP_DEC) |
         (wl_state_r == WL_FINE_DEC) |
         (rd_data_previous_r[dqs_count_r] != rd_data_rise_wl_r[dqs_count_r]) |
         (wl_state_r1 == WL_INIT_FINE_DEC))
        stable_cnt <= #TCQ 'd0;
      else if ((wl_tap_count_r > 6'd0) & 
         (((wl_state_r == WL_EDGE_CHECK) & (wl_edge_detect_valid_r)) |
         ((wl_state_r1 == WL_INIT_FINE_INC_WAIT) & (wl_state_r == WL_INIT_FINE_INC)))) begin
        if ((rd_data_previous_r[dqs_count_r] == rd_data_rise_wl_r[dqs_count_r])
           & (stable_cnt < 'd14))
          stable_cnt <= #TCQ stable_cnt + 1;
      end
   end
   
   // Signal to ensure that flag_ck_negedge does not incorrectly assert
   // when DQS is very close to CK rising edge
   //always @(posedge clk) begin
   //  if (rst | (wl_state_r == WL_DQS_CNT) |
   //     (wl_state_r == WL_DQS_CHECK) | wr_level_done_r)
   //    past_negedge <= #TCQ 1'b0;
   //  else if (~flag_ck_negedge && ~rd_data_previous_r[dqs_count_r] &&
   //           (stable_cnt == 'd0) && ((wl_state_r == WL_CORSE_INC_WAIT1) |
   //           (wl_state_r == WL_CORSE_INC_WAIT2)))
   //    past_negedge <= #TCQ 1'b1;
   //end 
   
   // Flag to indicate negedge of CK detected and ignore 0->1 transitions
   // in this region
   always @(posedge clk)begin
      if (rst | (wl_state_r == WL_DQS_CNT) |
         (wl_state_r == WL_DQS_CHECK) | wr_level_done_r |
         (wl_state_r1 == WL_INIT_FINE_DEC))
        flag_ck_negedge <= #TCQ 1'd0;
      else if ((rd_data_previous_r[dqs_count_r] && ((stable_cnt > 'd0) |
              (wl_state_r == WL_FINE_DEC) | (wl_state_r == WL_FINE_DEC_WAIT) | (wl_state_r == WL_FINE_DEC_WAIT1))) |
			  (wl_state_r == WL_CORSE_INC)) 
        flag_ck_negedge <= #TCQ 1'd1;
      else if (~rd_data_previous_r[dqs_count_r] && (stable_cnt == 'd14))
               //&& flag_ck_negedge)
        flag_ck_negedge <= #TCQ 1'd0;
   end
   
   // Flag to inhibit rd_data_edge_detect_r before stable DQ
   always @(posedge clk) begin
     if (rst)
       flag_init <= #TCQ 1'b1;
     else if ((wl_state_r == WL_WAIT) && ((wl_state_r1 == WL_INIT_FINE_INC_WAIT) ||
              (wl_state_r1 == WL_INIT_FINE_DEC_WAIT)))
       flag_init <= #TCQ 1'b0;
   end

   //checking for transition from 0 to 1
   always @(posedge clk)begin
     if (rst | flag_ck_negedge | flag_init | (wl_tap_count_r < 'd1) |
         inhibit_edge_detect_r)
       rd_data_edge_detect_r     <= #TCQ {DQS_WIDTH{1'b0}};
     else if (rd_data_edge_detect_r[dqs_count_r] == 1'b1) begin
       if ((wl_state_r == WL_FINE_DEC) || (wl_state_r == WL_FINE_DEC_WAIT) || (wl_state_r == WL_FINE_DEC_WAIT1) ||
           (wl_state_r == WL_CORSE_INC) || (wl_state_r == WL_CORSE_INC_WAIT) || (wl_state_r == WL_CORSE_INC_WAIT_TMP) ||
           (wl_state_r == WL_CORSE_INC_WAIT1) || (wl_state_r == WL_CORSE_INC_WAIT2))
         rd_data_edge_detect_r <= #TCQ {DQS_WIDTH{1'b0}};
       else
         rd_data_edge_detect_r <= #TCQ rd_data_edge_detect_r;
     end else if (rd_data_previous_r[dqs_count_r] && (stable_cnt < 'd14))
       rd_data_edge_detect_r     <= #TCQ {DQS_WIDTH{1'b0}};
     else
       rd_data_edge_detect_r <= #TCQ (~rd_data_previous_r & rd_data_rise_wl_r);
   end


  
  // registring the write level start signal
   always@(posedge clk) begin
     wr_level_start_r <= #TCQ wr_level_start;
   end

   // Assign dqs_count_r to dqs_count_w to perform the shift operation 
   // instead of multiply operation    
   assign dqs_count_w = {2'b00, dqs_count_r};

   assign oclk_count_w = {2'b00, oclkdelay_calib_cnt};
   
   always @(posedge clk) begin
     if (rst)
       incdec_wait_cnt <= #TCQ 'd0;
     else if ((wl_state_r == WL_FINE_DEC_WAIT1) ||
             (wl_state_r == WL_INIT_FINE_DEC_WAIT1) ||
             (wl_state_r == WL_CORSE_INC_WAIT_TMP))
       incdec_wait_cnt <= #TCQ incdec_wait_cnt + 1;
     else
       incdec_wait_cnt <= #TCQ 'd0;
   end
   
 
   // state machine to initiate the write leveling sequence
   // The state machine operates on one byte at a time.
   // It will increment the delays to the DQS OSERDES
   // and sample the DQ from the memory. When it detects
   // a transition from 1 to 0 then the write leveling is considered
   // done. 
   always @(posedge clk) begin
      if(rst)begin
         wrlvl_err              <= #TCQ 1'b0;
         wr_level_done_r        <= #TCQ 1'b0;
         wrlvl_rank_done_r      <= #TCQ 1'b0;
         dqs_count_r            <= #TCQ {DQS_CNT_WIDTH+1{1'b0}};
         dq_cnt_inc             <= #TCQ 1'b1;
         rank_cnt_r             <= #TCQ 2'b00;
         wl_state_r             <= #TCQ WL_IDLE;
         wl_state_r1            <= #TCQ WL_IDLE;
         inhibit_edge_detect_r  <= #TCQ 1'b1;
         wl_edge_detect_valid_r <= #TCQ 1'b0;
         wl_tap_count_r         <= #TCQ 6'd0;
         fine_dec_cnt           <= #TCQ 6'd0;
         for (r = 0; r < DQS_WIDTH; r = r + 1) begin
           fine_inc[r]          <= #TCQ 6'b0;
           corse_dec[r]         <= #TCQ 3'b0;
           corse_inc[r]         <= #TCQ 3'b0;
           corse_cnt[r]         <= #TCQ 3'b0;
         end
         dual_rnk_dec           <= #TCQ 1'b0;
         fast_cal_fine_cnt      <= #TCQ FAST_CAL_FINE;
         fast_cal_coarse_cnt    <= #TCQ FAST_CAL_COARSE;
         final_corse_dec        <= #TCQ 1'b0;
         //zero_tran_r            <= #TCQ 1'b0;
         wrlvl_redo_corse_inc   <= #TCQ 'd0;
      end else begin
         wl_state_r1            <= #TCQ wl_state_r;
         case (wl_state_r)
           
           WL_IDLE: begin
              wrlvl_rank_done_r      <= #TCQ 1'd0;
              inhibit_edge_detect_r  <= #TCQ 1'b1;
              if (wrlvl_byte_redo && ~wrlvl_byte_redo_r) begin
                wr_level_done_r      <= #TCQ 1'b0;
                dqs_count_r          <= #TCQ wrcal_cnt;
                corse_cnt[wrcal_cnt] <= #TCQ final_coarse_tap[wrcal_cnt];
                wl_tap_count_r       <= #TCQ smallest[wrcal_cnt];
                if (early1_data && 
                    (((final_coarse_tap[wrcal_cnt] < 'd6) && (CLK_PERIOD/nCK_PER_CLK <= 2500)) ||
                    ((final_coarse_tap[wrcal_cnt] < 'd3) && (CLK_PERIOD/nCK_PER_CLK > 2500))))
                  wrlvl_redo_corse_inc <= #TCQ REDO_COARSE;
                else if (early2_data && (final_coarse_tap[wrcal_cnt] < 'd2))
                  wrlvl_redo_corse_inc <= #TCQ 3'd6;
                else begin
                  wl_state_r   <= #TCQ WL_IDLE;
                  wrlvl_err    <= #TCQ 1'b1;
                end
              end else if (wrlvl_final && ~wrlvl_final_r) begin
                wr_level_done_r <= #TCQ 1'b0;
                dqs_count_r     <= #TCQ 'd0;
              end
							// verilint STARC-2.2.3.3 off
              if(!wr_level_done_r & wr_level_start_r & wl_sm_start) begin
                if (SIM_CAL_OPTION == "FAST_CAL")
                  wl_state_r <= #TCQ WL_FINE_INC;
                else
                  wl_state_r <= #TCQ WL_INIT;
              end
           end
           // verilint STARC-2.2.3.3 on
           WL_INIT: begin
              wl_edge_detect_valid_r <= #TCQ 1'b0;
              inhibit_edge_detect_r  <= #TCQ 1'b1;
              wrlvl_rank_done_r      <= #TCQ 1'd0;
              //zero_tran_r <= #TCQ 1'b0;
              if (wrlvl_final)
                corse_cnt[dqs_count_w ]  <= #TCQ final_coarse_tap[dqs_count_w ]; 
              if (wrlvl_byte_redo) begin
                if (|wl_tap_count_r) begin
                  wl_state_r   <= #TCQ WL_FINE_DEC;
                  fine_dec_cnt <= #TCQ wl_tap_count_r;
                end else if ((corse_cnt[dqs_count_w] + wrlvl_redo_corse_inc) <= 'd7)
                  wl_state_r   <= #TCQ WL_CORSE_INC;
                else begin
                  wl_state_r   <= #TCQ WL_IDLE;
                  wrlvl_err    <= #TCQ 1'b1;
                end
              end else if(wl_sm_start)
                wl_state_r <= #TCQ WL_INIT_FINE_INC;
           end
           
           // Initially Phaser_Out fine delay taps incremented
           // until stable_cnt=14. A stable_cnt of 14 indicates
           // that rd_data_rise_wl_r=rd_data_previous_r for 14 fine
           // tap increments. This is done to inhibit false 0->1 
           // edge detection when DQS is initially aligned to the
           // negedge of CK
           WL_INIT_FINE_INC: begin
              wl_state_r   <= #TCQ WL_INIT_FINE_INC_WAIT1;
              wl_tap_count_r <= #TCQ wl_tap_count_r + 1'b1;
              final_corse_dec <= #TCQ 1'b0;
           end

           WL_INIT_FINE_INC_WAIT1: begin
              if (wl_sm_start)
                wl_state_r <= #TCQ WL_INIT_FINE_INC_WAIT;
           end

           // Case1: stable value of rd_data_previous_r=0 then
           // proceed to 0->1 edge detection.
           // Case2: stable value of rd_data_previous_r=1 then
           // decrement fine taps to '0' and proceed to 0->1
           // edge detection. Need to decrement in this case to
           // make sure a valid 0->1 transition was not left 
           // undetected. 
           WL_INIT_FINE_INC_WAIT: begin
              if (wl_sm_start) begin
                if (stable_cnt < 'd14)
                  wl_state_r   <= #TCQ WL_INIT_FINE_INC;
                else if (~rd_data_previous_r[dqs_count_r]) begin
                  wl_state_r             <= #TCQ WL_WAIT;
                  inhibit_edge_detect_r  <= #TCQ 1'b0;
                end else begin
                  wl_state_r   <= #TCQ WL_INIT_FINE_DEC;
                  fine_dec_cnt <= #TCQ wl_tap_count_r;
                end
              end
           end

           // Case2: stable value of rd_data_previous_r=1 then
           // decrement fine taps to '0' and proceed to 0->1
           // edge detection. Need to decrement in this case to
           // make sure a valid 0->1 transition was not left 
           // undetected.
           WL_INIT_FINE_DEC: begin
              wl_tap_count_r <= #TCQ 'd0;
              wl_state_r   <= #TCQ WL_INIT_FINE_DEC_WAIT1;
              if (fine_dec_cnt > 6'd0)
                fine_dec_cnt <= #TCQ fine_dec_cnt - 1;
              else
                fine_dec_cnt <= #TCQ fine_dec_cnt;
           end
           
           WL_INIT_FINE_DEC_WAIT1: begin
             if (incdec_wait_cnt == 'd8)
               wl_state_r   <= #TCQ WL_INIT_FINE_DEC_WAIT;
           end
           
           WL_INIT_FINE_DEC_WAIT: begin
              if (fine_dec_cnt > 6'd0) begin
                wl_state_r             <= #TCQ WL_INIT_FINE_DEC;
                inhibit_edge_detect_r  <= #TCQ 1'b1;
              end else begin
                wl_state_r             <= #TCQ WL_WAIT;
                inhibit_edge_detect_r  <= #TCQ 1'b0;
              end
           end
           
           // Inc DQS Phaser_Out Stage2 Fine Delay line
           WL_FINE_INC: begin
              wl_edge_detect_valid_r <= #TCQ 1'b0;
              if (SIM_CAL_OPTION == "FAST_CAL") begin
                wl_state_r <= #TCQ WL_FINE_INC_WAIT;
                if (fast_cal_fine_cnt > 'd0)
                  fast_cal_fine_cnt <= #TCQ fast_cal_fine_cnt - 1;
                else
                  fast_cal_fine_cnt <= #TCQ fast_cal_fine_cnt;
              end else if (wr_level_done_r5) begin
                wl_tap_count_r <= #TCQ 'd0;
                wl_state_r <= #TCQ WL_FINE_INC_WAIT;
                if (|fine_inc[dqs_count_w])
                      fine_inc[dqs_count_w] <= #TCQ fine_inc[dqs_count_w] - 1;
              end else begin
                wl_state_r <= #TCQ WL_WAIT;
                wl_tap_count_r <= #TCQ wl_tap_count_r + 1'b1;
              end
           end
           
           WL_FINE_INC_WAIT: begin
              if (SIM_CAL_OPTION == "FAST_CAL") begin
                if (fast_cal_fine_cnt > 'd0)
                  wl_state_r <= #TCQ WL_FINE_INC;
                else if (fast_cal_coarse_cnt > 'd0)
                  wl_state_r <= #TCQ WL_CORSE_INC;
                else
                  wl_state_r <= #TCQ WL_DQS_CNT;
              end else if (|fine_inc[dqs_count_w])
                wl_state_r   <= #TCQ WL_FINE_INC;
              else if (dqs_count_r == (DQS_WIDTH-1))
                wl_state_r   <= #TCQ WL_IDLE;
              else begin
                wl_state_r   <= #TCQ WL_2RANK_FINAL_TAP;
                dqs_count_r  <= #TCQ dqs_count_r + 1;
              end
           end
           
           WL_FINE_DEC: begin
              wl_edge_detect_valid_r <= #TCQ 1'b0;
              wl_tap_count_r <= #TCQ 'd0;
              wl_state_r   <= #TCQ WL_FINE_DEC_WAIT1;
              if (fine_dec_cnt > 6'd0)
                fine_dec_cnt <= #TCQ fine_dec_cnt - 1;
              else
                fine_dec_cnt <= #TCQ fine_dec_cnt;
           end
           
           WL_FINE_DEC_WAIT1: begin
             if (incdec_wait_cnt == 'd8)
               wl_state_r   <= #TCQ WL_FINE_DEC_WAIT;
           end
           
           WL_FINE_DEC_WAIT: begin
              if (fine_dec_cnt > 6'd0)
                wl_state_r   <= #TCQ WL_FINE_DEC;
              //else if (zero_tran_r)
              //  wl_state_r <= #TCQ WL_DQS_CNT;
              else if (dual_rnk_dec) begin 
                if (|corse_dec[dqs_count_r])
                  wl_state_r <= #TCQ WL_CORSE_DEC;
                else
                  wl_state_r <= #TCQ WL_2RANK_DQS_CNT;
              end else if (wrlvl_byte_redo) begin
                if ((corse_cnt[dqs_count_w] + wrlvl_redo_corse_inc) <= 'd7)
                  wl_state_r <= #TCQ WL_CORSE_INC;
                else begin
                  wl_state_r <= #TCQ WL_IDLE;
                  wrlvl_err  <= #TCQ 1'b1;
                end
              end else
                wl_state_r <= #TCQ WL_CORSE_INC;
           end
           
           WL_CORSE_DEC: begin
              wl_state_r   <= #TCQ WL_CORSE_DEC_WAIT;
              dual_rnk_dec <= #TCQ 1'b0;
              if (|corse_dec[dqs_count_r])
                corse_dec[dqs_count_r] <= #TCQ corse_dec[dqs_count_r] - 1;
              else
                corse_dec[dqs_count_r]  <= #TCQ corse_dec[dqs_count_r];
           end
           
           WL_CORSE_DEC_WAIT: begin
              if (wl_sm_start) begin
              //if (|corse_dec[dqs_count_r])
              //  wl_state_r <= #TCQ WL_CORSE_DEC;
              if (|corse_dec[dqs_count_r])
                wl_state_r <= #TCQ WL_CORSE_DEC_WAIT1;
                else
                wl_state_r <= #TCQ WL_2RANK_DQS_CNT;
              end
           end
           
           WL_CORSE_DEC_WAIT1: begin
              if (wl_sm_start)
                wl_state_r <= #TCQ WL_CORSE_DEC;
           end
           
           WL_CORSE_INC: begin
              wl_state_r <= #TCQ WL_CORSE_INC_WAIT_TMP;
              if (SIM_CAL_OPTION == "FAST_CAL") begin
                if (fast_cal_coarse_cnt > 'd0)
                  fast_cal_coarse_cnt <= #TCQ fast_cal_coarse_cnt - 1;
                else
                  fast_cal_coarse_cnt <= #TCQ fast_cal_coarse_cnt;
              end else if (wrlvl_byte_redo) begin
                corse_cnt[dqs_count_w] <= #TCQ corse_cnt[dqs_count_w] + 1;
                if (|wrlvl_redo_corse_inc)                             
                  wrlvl_redo_corse_inc <= #TCQ wrlvl_redo_corse_inc - 1;
              end else if (~wr_level_done_r5)
                corse_cnt[dqs_count_r] <= #TCQ corse_cnt[dqs_count_r] + 1;
              else if (|corse_inc[dqs_count_w])                             
                corse_inc[dqs_count_w] <= #TCQ corse_inc[dqs_count_w] - 1;
           end

           WL_CORSE_INC_WAIT_TMP: begin
             if (incdec_wait_cnt == 'd8)
             wl_state_r <= #TCQ WL_CORSE_INC_WAIT;
           end
           
           WL_CORSE_INC_WAIT: begin
              if (SIM_CAL_OPTION == "FAST_CAL") begin
                if (fast_cal_coarse_cnt > 'd0)
                  wl_state_r   <= #TCQ WL_CORSE_INC;
                else
                  wl_state_r <= #TCQ WL_DQS_CNT;
              end else if (wrlvl_byte_redo) begin
                if (|wrlvl_redo_corse_inc)
                  wl_state_r   <= #TCQ WL_CORSE_INC;
                else begin
                  wl_state_r            <= #TCQ WL_INIT_FINE_INC;
                  inhibit_edge_detect_r <= #TCQ 1'b1;
                end
              end else if (~wr_level_done_r5 && wl_sm_start)
                wl_state_r <= #TCQ WL_CORSE_INC_WAIT1;
              else if (wr_level_done_r5) begin
                if (|corse_inc[dqs_count_r])
                  wl_state_r   <= #TCQ WL_CORSE_INC;
                else if (|fine_inc[dqs_count_w]) 
                  wl_state_r   <= #TCQ WL_FINE_INC;
                else if (dqs_count_r == (DQS_WIDTH-1))
                  wl_state_r   <= #TCQ WL_IDLE;
                else begin
                  wl_state_r   <= #TCQ WL_2RANK_FINAL_TAP;
                  dqs_count_r  <= #TCQ dqs_count_r + 1;
                end
              end
           end
           
           WL_CORSE_INC_WAIT1: begin
              if (wl_sm_start)
                wl_state_r <= #TCQ WL_CORSE_INC_WAIT2;
           end

           WL_CORSE_INC_WAIT2: begin
             if (wl_sm_start)
                wl_state_r <= #TCQ WL_WAIT;
           end
           
           WL_WAIT: begin
              if (wl_sm_start)
              wl_state_r <= #TCQ WL_EDGE_CHECK;
           end
           
           WL_EDGE_CHECK: begin // Look for the edge
              if (wl_edge_detect_valid_r == 1'b0) begin
                wl_state_r <= #TCQ WL_WAIT;
                wl_edge_detect_valid_r <= #TCQ 1'b1;
              end
              // 0->1 transition detected with DQS
              else if(rd_data_edge_detect_r[dqs_count_r] &&
                      wl_edge_detect_valid_r)
                begin
                  wl_tap_count_r <= #TCQ wl_tap_count_r;
                  if ((SIM_CAL_OPTION == "FAST_CAL") || (RANKS < 2) ||
                      ~oclkdelay_calib_done)
                    wl_state_r <= #TCQ WL_DQS_CNT;
                  else
                    wl_state_r <= #TCQ WL_2RANK_TAP_DEC;
                end
              // For initial writes check only upto 56 taps. Reserving the 
              // remaining taps for OCLK calibration. 
              else if((~wrlvl_tap_done_r) && (wl_tap_count_r > 6'd55)) begin
                if (corse_cnt[dqs_count_r] < COARSE_TAPS) begin
                  wl_state_r   <= #TCQ WL_FINE_DEC;
                  fine_dec_cnt <= #TCQ wl_tap_count_r;
                end  else begin
                  wrlvl_err <= #TCQ 1'b1;
                  wl_state_r   <= #TCQ WL_IDLE;
                end
	      end else begin
	          if (wl_tap_count_r < 6'd56)  //for reuse wrlvl for complex ocal	       
                    wl_state_r <= #TCQ WL_FINE_INC;
	          else if (corse_cnt[dqs_count_r] < COARSE_TAPS) begin
                    wl_state_r   <= #TCQ WL_FINE_DEC;
                    fine_dec_cnt <= #TCQ wl_tap_count_r;
                  end else begin
                   wrlvl_err <= #TCQ 1'b1;
                   wl_state_r   <= #TCQ WL_IDLE;
                  end
	      end
           end

           WL_2RANK_TAP_DEC: begin
              wl_state_r    <= #TCQ WL_FINE_DEC;
              fine_dec_cnt  <= #TCQ wl_tap_count_r;
              for (m = 0; m < DQS_WIDTH; m = m + 1)
                corse_dec[m] <= #TCQ corse_cnt[m];
              wl_edge_detect_valid_r <= #TCQ 1'b0;
              dual_rnk_dec <= #TCQ 1'b1;
           end
           
           WL_DQS_CNT: begin
              if ((SIM_CAL_OPTION == "FAST_CAL") ||
                  (dqs_count_r == (DQS_WIDTH-1)) ||
                  wrlvl_byte_redo) begin
                dqs_count_r <= #TCQ dqs_count_r;
                dq_cnt_inc  <= #TCQ 1'b0;
              end else begin
                dqs_count_r <= #TCQ dqs_count_r + 1'b1;
                dq_cnt_inc  <= #TCQ 1'b1;
              end
              wl_state_r <= #TCQ WL_DQS_CHECK;
              wl_edge_detect_valid_r <= #TCQ 1'b0;
           end
           
           WL_2RANK_DQS_CNT: begin
              if ((SIM_CAL_OPTION == "FAST_CAL") ||
                 (dqs_count_r == (DQS_WIDTH-1))) begin
                dqs_count_r <= #TCQ dqs_count_r;
                dq_cnt_inc  <= #TCQ 1'b0;
              end else begin
                dqs_count_r <= #TCQ dqs_count_r + 1'b1;
                dq_cnt_inc  <= #TCQ 1'b1;
              end
              wl_state_r <= #TCQ WL_DQS_CHECK;
              wl_edge_detect_valid_r <= #TCQ 1'b0;
              dual_rnk_dec <= #TCQ 1'b0;
           end   
           
           WL_DQS_CHECK: begin // check if all DQS have been calibrated
              wl_tap_count_r <= #TCQ 'd0;
              if (dq_cnt_inc == 1'b0)begin
                wrlvl_rank_done_r <= #TCQ 1'd1;
                for (t = 0; t < DQS_WIDTH; t = t + 1)
                  corse_cnt[t] <= #TCQ 3'b0;
                if ((SIM_CAL_OPTION == "FAST_CAL") || (RANKS < 2) || ~oclkdelay_calib_done) begin
                  wl_state_r  <= #TCQ WL_IDLE;
                  if (wrlvl_byte_redo)
                    dqs_count_r <= #TCQ dqs_count_r;
                  else 
                  dqs_count_r <= #TCQ 'd0;
                end else if (rank_cnt_r == RANKS-1) begin
                  dqs_count_r <= #TCQ dqs_count_r;
                  if (RANKS > 1)
                    wl_state_r  <= #TCQ WL_2RANK_FINAL_TAP;
                  else
                    wl_state_r  <= #TCQ WL_IDLE;
                end else begin
                  wl_state_r  <= #TCQ WL_INIT;
                  dqs_count_r <= #TCQ 'd0;
                end
                if ((SIM_CAL_OPTION == "FAST_CAL") ||
                    (rank_cnt_r == RANKS-1)) begin
                  wr_level_done_r <= #TCQ 1'd1;
                  rank_cnt_r      <= #TCQ 2'b00;
                end else begin
                  wr_level_done_r <= #TCQ 1'd0;
                  rank_cnt_r      <= #TCQ rank_cnt_r + 1'b1;
                end
              end else
                wl_state_r  <= #TCQ WL_INIT;
           end
           
           WL_2RANK_FINAL_TAP: begin
              if (wr_level_done_r4 && ~wr_level_done_r5) begin
                for(u = 0; u < DQS_WIDTH; u = u + 1) begin
                  corse_inc[u] <= #TCQ final_coarse_tap[u];
                  fine_inc[u]  <= #TCQ final_val[u];
                end
                dqs_count_r    <= #TCQ 'd0;
              end else if (wr_level_done_r5) begin
                if (|corse_inc[dqs_count_r])
                  wl_state_r   <= #TCQ WL_CORSE_INC;
                else if (|fine_inc[dqs_count_w])
                  wl_state_r   <= #TCQ WL_FINE_INC;
              end  
           end
        endcase
     end
   end // always @ (posedge clk)

endmodule
              
                 
                
   
     

   

