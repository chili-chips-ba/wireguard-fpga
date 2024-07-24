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
// \   \   \/     Version: %version
//  \   \         Application: MIG
//  /   /         Filename: ddr_skip_calib_tap.v
// /___/   /\     Date Last Modified: $Date: 2015/05/06 02:07:40 $
// \   \  /  \    Date Created: May 06 2015 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Phaser_Out, Phaser_In, and IDELAY tap adjustments to match
//         calibration values when SKIP_CALIB=="TRUE"
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_skip_calib_tap #
  (
   parameter TCQ             = 100,    // clk->out delay (sim only)
   parameter DQS_WIDTH       = 8       // number of bytes
   )
  (
   input                        clk,
   input                        rst,
   input                        phy_ctl_ready,
   // Completed loading calib tap values into registers
   input                        load_done,
   // Tap adjustment status
   input                        calib_tap_inc_start,    
   output                       calib_tap_inc_done,
   // Calibration tap values
   input [6*DQS_WIDTH-1:0]      calib_po_stage2_tap_cnt,
   input [6*DQS_WIDTH-1:0]      calib_po_stage3_tap_cnt,
   input [3*DQS_WIDTH-1:0]      calib_po_coarse_tap_cnt,
   input [6*DQS_WIDTH-1:0]      calib_pi_stage2_tap_cnt,
   input [5*DQS_WIDTH-1:0]      calib_idelay_tap_cnt,
   // Phaser_Out and Phaser_In tap count
   input [8:0]                  po_counter_read_val,
   input [5:0]                  pi_counter_read_val,
	// Phaser_Out and Phaser_In tap inc/dec control signals
   output [5:0]                 calib_tap_inc_byte_cnt,
   output                       calib_po_f_en,
   output                       calib_po_f_incdec,
   output                       calib_po_sel_stg2stg3,
   output                       calib_po_c_en,
   output                       calib_po_c_inc,
   output                       calib_pi_f_en,
   output                       calib_pi_f_incdec,
   output                       calib_idelay_ce,
   output                       calib_idelay_inc,
   output                       skip_cal_po_pi_dec_done,
   output reg                   coarse_dec_err,
   output [127:0]               dbg_skip_cal
   );
   
  //***************************************************************************
  // Decrement initial Phaser_OUT fine delay value before proceeding with
  // calibration
  //***************************************************************************


  reg phy_ctl_ready_r1, phy_ctl_ready_r2, phy_ctl_ready_r3, phy_ctl_ready_r4, phy_ctl_ready_r5, phy_ctl_ready_r6;
  reg po_cnt_dec;
  reg [3:0]   dec_wait_cnt;
  reg [8:0]   po_rdval_cnt;
  reg         po_dec_done;
  reg         dec_po_f_en_r;
  reg         dec_po_f_incdec_r;
  reg        dqs_po_dec_done_r1, dqs_po_dec_done_r2;
  reg        fine_dly_dec_done_r1, fine_dly_dec_done_r2, fine_dly_dec_done_r3;
  reg [5:0]  pi_rdval_cnt;
  reg        pi_cnt_dec;
  reg        dec_pi_f_en_r;
  reg        dec_pi_f_incdec_r;
  
  always @(posedge clk) begin
          phy_ctl_ready_r1  <= #TCQ phy_ctl_ready;
          phy_ctl_ready_r2  <= #TCQ phy_ctl_ready_r1;
          phy_ctl_ready_r3  <= #TCQ phy_ctl_ready_r2;
          phy_ctl_ready_r4  <= #TCQ phy_ctl_ready_r3;
          phy_ctl_ready_r5  <= #TCQ phy_ctl_ready_r4;
          phy_ctl_ready_r6  <= #TCQ phy_ctl_ready_r5;
  end

  always @(posedge clk) begin
     if (rst || po_cnt_dec || pi_cnt_dec)
       dec_wait_cnt <= #TCQ 'd8;
     else if (phy_ctl_ready_r6 && (dec_wait_cnt > 'd0))
       dec_wait_cnt <= #TCQ dec_wait_cnt - 1;
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
     else if (phy_ctl_ready_r6 && (po_rdval_cnt > 'd0) && (dec_wait_cnt == 'd1))
       po_cnt_dec      <= #TCQ 1'b1;
     else
       po_cnt_dec      <= #TCQ 1'b0;
   end
   
   // Inc/Dec Phaser_Out stage 2 fine delay line
   always @(posedge clk) begin
     if (rst) begin
       dec_po_f_incdec_r <= #TCQ 1'b0;
       dec_po_f_en_r     <= #TCQ 1'b0;
     end else if (po_cnt_dec) begin
       dec_po_f_incdec_r <= #TCQ 1'b0;
       dec_po_f_en_r     <= #TCQ 1'b1;
     end else begin
	   dec_po_f_incdec_r <= #TCQ 1'b0;
       dec_po_f_en_r     <= #TCQ 1'b0;
	 end
   end
   
   always @(posedge clk) begin
     if (rst)
       po_dec_done <= #TCQ 1'b0;
     else if (((po_cnt_dec == 'd1) && (po_rdval_cnt == 'd1)) || 
              (phy_ctl_ready_r6 && (po_rdval_cnt == 'd0))) begin
       po_dec_done <= #TCQ 1'b1;
     end
   end

  //***************************************************************************
  // Decrement initial Phaser_IN fine delay value before proceeding with
  // calibration
  //***************************************************************************
  
     always @(posedge clk) begin
       dqs_po_dec_done_r1   <= #TCQ po_dec_done;
       dqs_po_dec_done_r2   <= #TCQ dqs_po_dec_done_r1;
       fine_dly_dec_done_r2 <= #TCQ fine_dly_dec_done_r1;
       fine_dly_dec_done_r3 <= #TCQ fine_dly_dec_done_r2;
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
               	  && (dec_wait_cnt == 'd1))
       pi_cnt_dec      <= #TCQ 1'b1;
     else
       pi_cnt_dec      <= #TCQ 1'b0;
   end
   
   // Inc/Dec Phaser_In stage 2 fine delay line
   always @(posedge clk) begin
     if (rst) begin
       dec_pi_f_incdec_r <= #TCQ 1'b0;
       dec_pi_f_en_r     <= #TCQ 1'b0;
     end else if (pi_cnt_dec) begin
       dec_pi_f_incdec_r <= #TCQ 1'b0;
       dec_pi_f_en_r     <= #TCQ 1'b1;
     end else begin
	   dec_pi_f_incdec_r <= #TCQ 1'b0;
       dec_pi_f_en_r     <= #TCQ 1'b0;
	 end
   end
   
   always @(posedge clk) begin
     if (rst) begin
       fine_dly_dec_done_r1 <= #TCQ 1'b0;
     end else if (((pi_cnt_dec == 'd1) && (pi_rdval_cnt == 'd1)) ||
                  (dqs_po_dec_done_r2 && (pi_rdval_cnt == 'd0))) begin
       fine_dly_dec_done_r1 <= #TCQ 1'b1;
     end
   end
   
  assign skip_cal_po_pi_dec_done = fine_dly_dec_done_r3;

//*************************end Phaser_Out and Phaser_In decrement to zero*******
   
   
   
  localparam WAIT_CNT = 15;

  // State Machine  
  localparam [4:0] IDLE                      = 5'h00;
  localparam [4:0] READ_PO_PI_COUNTER_VAL    = 5'h01;
  localparam [4:0] CALC_INC_DEC_CNT_VAL      = 5'h02;
  localparam [4:0] WAIT_STG3_SEL             = 5'h03;
  localparam [4:0] PO_COARSE_CNT_CHECK       = 5'h04;
  localparam [4:0] PO_COARSE_INC             = 5'h05;
  localparam [4:0] PO_STG3_SEL               = 5'h06;
  localparam [4:0] PO_STG3_INC_CNT_CHECK     = 5'h07;
  localparam [4:0] PO_STG3_INC               = 5'h08;
  localparam [4:0] PO_STG3_DEC_CNT_CHECK     = 5'h09;
  localparam [4:0] PO_STG3_DEC               = 5'h0A;
  localparam [4:0] PO_STG2_INC_CNT_CHECK     = 5'h0B;
  localparam [4:0] PO_STG2_INC               = 5'h0C;
  localparam [4:0] PO_STG2_DEC_CNT_CHECK     = 5'h0D;
  localparam [4:0] PO_STG2_DEC               = 5'h0E;
  localparam [4:0] PI_STG2_INC_CNT_CHECK     = 5'h0F;
  localparam [4:0] PI_STG2_INC               = 5'h10;
  localparam [4:0] PI_STG2_DEC_CNT_CHECK     = 5'h11;
  localparam [4:0] PI_STG2_DEC               = 5'h12;
  localparam [4:0] IDELAY_CNT_CHECK          = 5'h13;
  localparam [4:0] IDELAY_TAP_INC            = 5'h14;
  localparam [4:0] WAIT_TAP_INC_DEC          = 5'h15;
  localparam [4:0] NEXT_BYTE                 = 5'h16;
  localparam [4:0] WAIT_PO_PI_COUNTER_VAL    = 5'h17;
  localparam [4:0] PO_PI_TAP_ADJ_DONE        = 5'h18;
  
  
  reg                   calib_tap_inc_start_r;
  reg [4:0]             skip_state_r;
  reg                   wait_cnt_en_r;
  reg                   wait_cnt_done;
  reg [3:0]             wait_cnt_r;
  reg                   po_sel_stg23_r;
  reg                   po_f_en_r;
  reg                   po_f_incdec_r;
  reg                   po_c_en_r;
  reg                   po_c_inc_r;
  reg                   pi_f_en_r;
  reg                   pi_f_incdec_r;
  reg                   idelay_ce_r;
  reg                   idelay_inc_r;
  reg [2:0]             po_c_inc_cnt;
  reg [5:0]             po_stg3_inc_cnt;
  reg [5:0]             po_stg3_dec_cnt;
  reg [5:0]             po_stg2_inc_cnt;
  reg [5:0]             po_stg2_dec_cnt;
  reg [5:0]             pi_stg2_inc_cnt;
  reg [5:0]             pi_stg2_dec_cnt;
  reg [4:0]             idelay_inc_cnt;
  reg                   po_stg3_cnt_load_r;
  reg                   po_c_inc_active_r;
  reg                   po_stg3_inc_active_r;
  reg                   po_stg3_dec_active_r;
  reg                   po_stg2_inc_active_r;
  reg                   po_stg2_dec_active_r;
  reg                   pi_stg2_inc_active_r;
  reg                   pi_stg2_dec_active_r;
  reg                   idelay_inc_active_r;
  reg [5:0]             byte_cnt_r;
  reg                   tap_adj_done_r;
  reg [2:0]             calib_byte_po_c_cnt;
  reg [5:0]             calib_byte_po_stg2_cnt;
  reg [5:0]             calib_byte_po_stg3_cnt;
  reg [5:0]             calib_byte_pi_stg2_cnt;
  reg [4:0]             calib_byte_idelay_cnt;
  
  reg [4:0]             skip_next_state;
  reg [5:0]             byte_cnt;
  reg                   tap_adj_done;
  reg                   po_sel_stg23;
  reg                   po_f_en;
  reg                   po_f_incdec;
  reg                   po_c_en;
  reg                   po_c_inc;
  reg                   pi_f_en;
  reg                   pi_f_incdec;
  reg                   idelay_ce;
  reg                   idelay_inc;
  reg                   po_stg3_cnt_load;
  reg                   po_c_inc_active;
  reg                   po_stg3_inc_active;
  reg                   po_stg3_dec_active;
  reg                   po_stg2_inc_active;
  reg                   po_stg2_dec_active;
  reg                   pi_stg2_inc_active;
  reg                   pi_stg2_dec_active;
  reg                   idelay_inc_active;
  

  
// Output assignments
  assign calib_tap_inc_byte_cnt = byte_cnt_r;
  assign calib_po_f_en          = fine_dly_dec_done_r3 ? po_f_en_r : dec_po_f_en_r;
  assign calib_po_f_incdec      = fine_dly_dec_done_r3 ? po_f_incdec_r : dec_po_f_incdec_r;
  assign calib_po_sel_stg2stg3  = po_sel_stg23_r;
  assign calib_po_c_en          = po_c_en_r;
  assign calib_po_c_inc         = po_c_inc_r;
  assign calib_pi_f_en          = fine_dly_dec_done_r3 ? pi_f_en_r : dec_pi_f_en_r;
  assign calib_pi_f_incdec      = fine_dly_dec_done_r3 ? pi_f_incdec_r : dec_pi_f_incdec_r;
  assign calib_idelay_ce        = idelay_ce_r;
  assign calib_idelay_inc       = idelay_inc_r;
  assign calib_tap_inc_done     = tap_adj_done_r;
  
// Register input calib_tap_inc_start
  always @(posedge clk)
    calib_tap_inc_start_r <= #TCQ calib_tap_inc_start;

  
/**************************Wait Counter Start*********************************/
// Wait counter enable for wait states WAIT_STG3_SEL, WAIT_TAP_INC_DEC, and
// WAIT_PO_PI_COUNTER_VAL  
  always @(posedge clk) begin
    if ((skip_state_r == WAIT_STG3_SEL) ||
        (skip_state_r == WAIT_TAP_INC_DEC) ||
		(skip_state_r == WAIT_PO_PI_COUNTER_VAL))
      wait_cnt_en_r <= #TCQ 1'b1;
    else
      wait_cnt_en_r <= #TCQ 1'b0;
  end

// Wait counter enable for wait states WAIT_STG3_SEL, WAIT_TAP_INC_DEC, and
// WAIT_PO_PI_COUNTER_VAL  
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

// Calibration tap values for current byte being adjusted 
  always @(posedge clk) begin
    if (rst) begin
	  calib_byte_po_c_cnt    <= #TCQ 'd0;
	  calib_byte_po_stg2_cnt <= #TCQ 'd0;
	  calib_byte_po_stg3_cnt <= #TCQ 'd0;
	  calib_byte_pi_stg2_cnt <= #TCQ 'd0;
	  calib_byte_idelay_cnt  <= #TCQ 'd0;
	end else begin
	  calib_byte_po_c_cnt    <= #TCQ calib_po_coarse_tap_cnt[3*byte_cnt_r+:3];
	  calib_byte_po_stg2_cnt <= #TCQ calib_po_stage2_tap_cnt[6*byte_cnt_r+:6];
	  calib_byte_po_stg3_cnt <= #TCQ calib_po_stage3_tap_cnt[6*byte_cnt_r+:6];
	  calib_byte_pi_stg2_cnt <= #TCQ calib_pi_stage2_tap_cnt[6*byte_cnt_r+:6];
	  calib_byte_idelay_cnt  <= #TCQ calib_idelay_tap_cnt[5*byte_cnt_r+:5];
	end
  end

// Phaser_Out, Phaser_In, and IDELAY inc/dec counters  
  always @(posedge clk) begin
    if (rst) begin
	  po_c_inc_cnt    <= #TCQ 'd0;
	  po_stg2_inc_cnt <= #TCQ 'd0;
	  po_stg2_dec_cnt <= #TCQ 'd0;
	  pi_stg2_inc_cnt <= #TCQ 'd0;
	  pi_stg2_dec_cnt <= #TCQ 'd0;
	  idelay_inc_cnt  <= #TCQ 'd0;
	end else if (skip_state_r == READ_PO_PI_COUNTER_VAL) begin
	  // IDELAY tap count setting
	  idelay_inc_cnt  <= #TCQ calib_byte_idelay_cnt;
      // Phaser_Out coarse tap setting	
	  if (po_counter_read_val[8:6] == 'd0) begin
	    coarse_dec_err <= #TCQ 1'b0;
	    po_c_inc_cnt   <= #TCQ calib_byte_po_c_cnt;
	  end else if (po_counter_read_val[8:6] < calib_byte_po_c_cnt) begin
	    coarse_dec_err <= #TCQ 1'b0;
	    po_c_inc_cnt   <= #TCQ calib_byte_po_c_cnt - po_counter_read_val[8:6];
	  end else begin
	    // Phaser_Out coarse taps cannot be decremented
	    coarse_dec_err <= #TCQ 1'b1;
	    po_c_inc_cnt   <= #TCQ 'd0;		
	  end
	  // Phaser_Out stage2 tap count setting when po_sel_stg23_r=0
	  if (po_counter_read_val[5:0] == 'd0) begin
	    po_stg2_inc_cnt <= #TCQ calib_byte_po_stg2_cnt;
		po_stg2_dec_cnt <= #TCQ 'd0;
	  end else if (po_counter_read_val[5:0] > calib_byte_po_stg2_cnt) begin
	    po_stg2_inc_cnt <= #TCQ 'd0;
		po_stg2_dec_cnt <= #TCQ po_counter_read_val[5:0] - calib_byte_po_stg2_cnt;
	  end else if (po_counter_read_val[5:0] < calib_byte_po_stg2_cnt) begin
	    po_stg2_inc_cnt <= #TCQ calib_byte_po_stg2_cnt - po_counter_read_val[5:0];
		po_stg2_dec_cnt <= #TCQ 'd0;
	  end else if (po_counter_read_val[5:0] == calib_byte_po_stg2_cnt) begin
	    po_stg2_inc_cnt <= #TCQ 'd0;
	    po_stg2_dec_cnt <= #TCQ 'd0;
	  end
	  //Phaser_In stgae2 tap count setting
	  if (pi_counter_read_val == 'd0) begin
	    pi_stg2_inc_cnt <= #TCQ calib_byte_pi_stg2_cnt;
	    pi_stg2_dec_cnt <= #TCQ 'd0;
	  end else if (pi_counter_read_val > calib_byte_pi_stg2_cnt) begin
	    pi_stg2_inc_cnt <= #TCQ 'd0;
	    pi_stg2_dec_cnt <= #TCQ pi_counter_read_val - calib_byte_pi_stg2_cnt;
	  end else if (pi_counter_read_val < calib_byte_pi_stg2_cnt) begin
	    pi_stg2_inc_cnt <= #TCQ calib_byte_pi_stg2_cnt - pi_counter_read_val;
		pi_stg2_dec_cnt <= #TCQ 'd0;
	  end else if (pi_counter_read_val == calib_byte_pi_stg2_cnt) begin
	    pi_stg2_inc_cnt <= #TCQ 'd0;
		pi_stg2_dec_cnt <= #TCQ 'd0;
	  end
	end else begin
	  if (skip_state_r == IDELAY_TAP_INC)
	    idelay_inc_cnt <= #TCQ idelay_inc_cnt - 1;
	  if (skip_state_r == PO_COARSE_INC)
	    po_c_inc_cnt <= #TCQ po_c_inc_cnt - 1;
	  if (skip_state_r == PO_STG2_INC)
	    po_stg2_inc_cnt <= #TCQ po_stg2_inc_cnt - 1;
	  if (skip_state_r == PO_STG2_DEC)
	    po_stg2_dec_cnt <= #TCQ po_stg2_dec_cnt - 1;
	  if (skip_state_r == PI_STG2_INC)
	    pi_stg2_inc_cnt <= #TCQ pi_stg2_inc_cnt - 1;
	  if (skip_state_r == PI_STG2_DEC)
	    pi_stg2_dec_cnt <= #TCQ pi_stg2_dec_cnt - 1;
	end
  end
  
  // Phaser_Out stage 3 tap count setting when po_sel_stg23_r=1
  always @(posedge clk) begin
    if (rst) begin
	  po_stg3_inc_cnt <= #TCQ 'd0;
	  po_stg3_dec_cnt <= #TCQ 'd0;
	end else if ((skip_state_r == WAIT_STG3_SEL) && wait_cnt_done && po_stg3_cnt_load_r) begin
	  if (po_counter_read_val[5:0] == 'd0) begin
	    po_stg3_inc_cnt <= #TCQ calib_byte_po_stg3_cnt;
		po_stg3_dec_cnt <= #TCQ 'd0;
	  end else if (po_counter_read_val[5:0] > calib_byte_po_stg3_cnt) begin
	    po_stg3_inc_cnt <= #TCQ 'd0;
		po_stg3_dec_cnt <= #TCQ po_counter_read_val[5:0] - calib_byte_po_stg3_cnt;
	  end else if (po_counter_read_val[5:0] < calib_byte_po_stg3_cnt) begin
	    po_stg3_inc_cnt <= #TCQ calib_byte_po_stg3_cnt - po_counter_read_val[5:0];
		po_stg3_dec_cnt <= #TCQ 'd0;
	  end else if (po_counter_read_val[5:0] == calib_byte_po_stg3_cnt) begin
	    po_stg3_inc_cnt <= #TCQ 'd0;
	    po_stg3_dec_cnt <= #TCQ 'd0;
	  end
	end else begin 
	  if (skip_state_r == PO_STG3_INC)
	    po_stg3_inc_cnt <= #TCQ po_stg3_inc_cnt - 1;
	  if (skip_state_r == PO_STG3_DEC)
	    po_stg3_dec_cnt <= #TCQ po_stg3_dec_cnt - 1;
	end
  end
	  
  always @(posedge clk) begin
    if (rst) begin
	  skip_state_r         <= #TCQ IDLE;
	  byte_cnt_r           <= #TCQ 'd0;
	  tap_adj_done_r       <= #TCQ 1'b0;
	  po_sel_stg23_r       <= #TCQ 1'b0;
	  po_f_en_r            <= #TCQ 1'b0;
	  po_f_incdec_r        <= #TCQ 1'b0;
	  po_c_en_r            <= #TCQ 1'b0;
	  po_c_inc_r           <= #TCQ 1'b0;
	  pi_f_en_r            <= #TCQ 1'b0;
	  pi_f_incdec_r        <= #TCQ 1'b0;
	  idelay_ce_r          <= #TCQ 1'b0;
	  idelay_inc_r         <= #TCQ 1'b0;
	  po_stg3_cnt_load_r   <= #TCQ 1'b0;
	  po_c_inc_active_r    <= #TCQ 1'b0;
	  po_stg3_inc_active_r <= #TCQ 1'b0;
	  po_stg3_dec_active_r <= #TCQ 1'b0;
	  po_stg2_inc_active_r <= #TCQ 1'b0;
	  po_stg2_dec_active_r <= #TCQ 1'b0;
	  pi_stg2_inc_active_r <= #TCQ 1'b0;
	  pi_stg2_dec_active_r <= #TCQ 1'b0;
	  idelay_inc_active_r  <= #TCQ 1'b0;
	end else begin
	  skip_state_r         <= #TCQ skip_next_state;
	  byte_cnt_r           <= #TCQ byte_cnt;
	  tap_adj_done_r       <= #TCQ tap_adj_done;
	  po_sel_stg23_r       <= #TCQ po_sel_stg23;
	  po_f_en_r            <= #TCQ po_f_en;
	  po_f_incdec_r        <= #TCQ po_f_incdec;
	  po_c_en_r            <= #TCQ po_c_en;
	  po_c_inc_r           <= #TCQ po_c_inc;
	  pi_f_en_r            <= #TCQ pi_f_en;
	  pi_f_incdec_r        <= #TCQ pi_f_incdec;
	  idelay_ce_r          <= #TCQ idelay_ce;
	  idelay_inc_r         <= #TCQ idelay_inc;
	  po_stg3_cnt_load_r   <= #TCQ po_stg3_cnt_load;
	  po_c_inc_active_r    <= #TCQ po_c_inc_active;
	  po_stg3_inc_active_r <= #TCQ po_stg3_inc_active;
	  po_stg3_dec_active_r <= #TCQ po_stg3_dec_active;
	  po_stg2_inc_active_r <= #TCQ po_stg2_inc_active;
	  po_stg2_dec_active_r <= #TCQ po_stg2_dec_active;
	  pi_stg2_inc_active_r <= #TCQ pi_stg2_inc_active;
	  pi_stg2_dec_active_r <= #TCQ pi_stg2_dec_active;
	  idelay_inc_active_r  <= #TCQ idelay_inc_active;
	end
  end

// State Machine
  always @(*) begin
	  skip_next_state    = skip_state_r;
	  byte_cnt           = byte_cnt_r;
	  tap_adj_done       = tap_adj_done_r;
	  po_sel_stg23       = po_sel_stg23_r;
	  po_f_en            = po_f_en_r;
	  po_f_incdec        = po_f_incdec_r;
	  po_c_en            = po_c_en_r;
	  po_c_inc           = po_c_inc_r;
	  pi_f_en            = pi_f_en_r;
	  pi_f_incdec        = pi_f_incdec_r;
	  idelay_ce          = idelay_ce_r;
	  idelay_inc         = idelay_inc_r;
	  po_stg3_cnt_load   = po_stg3_cnt_load_r;
	  po_c_inc_active    = po_c_inc_active_r;
	  po_stg3_inc_active = po_stg3_inc_active_r;
	  po_stg3_dec_active = po_stg3_dec_active_r;
	  po_stg2_inc_active = po_stg2_inc_active_r;
	  po_stg2_dec_active = po_stg2_dec_active_r;
	  pi_stg2_inc_active = pi_stg2_inc_active_r;
	  pi_stg2_dec_active = pi_stg2_dec_active_r;
	  idelay_inc_active  = idelay_inc_active_r;

	
	  case(skip_state_r)
	    IDLE: begin
		  // Begin tap adjustment on the rising edge of calib_tap_inc_start
		  // This logic assumes that load_done is asserted before calib_tap_inc_start
		  // If this is not the case this logic will have to change
	      if (calib_tap_inc_start && ~calib_tap_inc_start_r && load_done) begin
                skip_next_state = READ_PO_PI_COUNTER_VAL;
	      end
	    end
		
		READ_PO_PI_COUNTER_VAL: begin
		  skip_next_state = CALC_INC_DEC_CNT_VAL;
		end
		
		CALC_INC_DEC_CNT_VAL: begin
		  skip_next_state = WAIT_STG3_SEL;
		  po_sel_stg23     = 1'b1;
		  po_stg3_cnt_load = 1'b1;
		end
		
		WAIT_STG3_SEL: begin
		  if (wait_cnt_done) begin
		    if (po_stg3_cnt_load)
			  skip_next_state = PO_STG3_SEL;
			else
			  skip_next_state = PO_COARSE_CNT_CHECK;
		  end
		end
		
		PO_COARSE_CNT_CHECK: begin
		  if (po_c_inc_cnt > 'd0) begin
		    po_c_inc_active = 1'b1;
			skip_next_state = PO_COARSE_INC;
		  end else begin
		    po_c_inc_active = 1'b0;
			skip_next_state = PO_STG2_DEC_CNT_CHECK;
		  end
		end
		
		PO_COARSE_INC: begin
		  po_c_en  = 1'b1;
		  po_c_inc = 1'b1;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PO_STG3_SEL: begin
		  po_stg3_cnt_load = 1'b0;
		  if (po_stg3_inc_cnt > 'd0) begin
		    po_stg3_inc_active = 1'b1;
			skip_next_state    = PO_STG3_INC;
	      end else if (po_stg3_dec_cnt > 'd0) begin
		    po_stg3_dec_active = 1'b1;
			skip_next_state    = PO_STG3_DEC;
		  end else begin
		    po_sel_stg23       = 1'b0;
		    skip_next_state    = WAIT_STG3_SEL;
			
		  end
		end
		
		PO_STG3_INC_CNT_CHECK: begin
		  if (po_stg3_inc_cnt > 'd0) begin
		    po_stg3_inc_active = 1'b1;
			skip_next_state    = PO_STG3_INC;
		  end else begin
		    po_stg3_inc_active = 1'b0;
			po_sel_stg23       = 1'b0;
			skip_next_state    = WAIT_STG3_SEL;
	      end
		end
		
		PO_STG3_INC: begin
		  po_f_en     = 1'b1;
		  po_f_incdec = 1'b1;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PO_STG3_DEC_CNT_CHECK: begin		  
		  if (po_stg3_dec_cnt > 'd0) begin
		    po_stg3_dec_active = 1'b1;
			skip_next_state    = PO_STG3_DEC;
		  end else begin
		    po_stg3_dec_active = 1'b0;
			po_sel_stg23       = 1'b0;
			skip_next_state    = WAIT_STG3_SEL;
		  end
		end
		
		PO_STG3_DEC: begin
		  po_f_en     = 1'b1;
		  po_f_incdec = 1'b0;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PO_STG2_DEC_CNT_CHECK: begin
		  if (po_stg2_dec_cnt > 'd0) begin
		    po_stg2_dec_active = 1'b1;
			skip_next_state    = PO_STG2_DEC;
		  end else if (po_stg2_inc_cnt > 'd0) begin
		    po_stg2_dec_active = 1'b0;
			skip_next_state    = PO_STG2_INC_CNT_CHECK;
		  end else begin
		    po_stg2_dec_active = 1'b0;
			skip_next_state    = PI_STG2_DEC_CNT_CHECK;
		  end
		end
		
		PO_STG2_DEC: begin
		  po_f_en     = 1'b1;
		  po_f_incdec = 1'b0;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PO_STG2_INC_CNT_CHECK: begin
		  if (po_stg2_inc_cnt > 'd0) begin
		    po_stg2_inc_active = 1'b1;
			skip_next_state    = PO_STG2_INC;
		  end else begin
		    po_stg2_inc_active = 1'b0;
			skip_next_state    = PI_STG2_DEC_CNT_CHECK;
		  end
		end
		
		PO_STG2_INC: begin
		  po_f_en     = 1'b1;
		  po_f_incdec = 1'b1;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PI_STG2_DEC_CNT_CHECK: begin
		  if (pi_stg2_dec_cnt > 'd0) begin
		    pi_stg2_dec_active = 1'b1;
			skip_next_state    = PI_STG2_DEC;
		  end else if (pi_stg2_inc_cnt > 'd0) begin
		    pi_stg2_dec_active = 1'b0;
			skip_next_state    = PI_STG2_INC_CNT_CHECK;
		  end else begin
		    pi_stg2_dec_active = 1'b0;
			skip_next_state    = IDELAY_CNT_CHECK;
		  end
		end
		
		PI_STG2_DEC: begin
		  pi_f_en     = 1'b1;
		  pi_f_incdec = 1'b0;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		PI_STG2_INC_CNT_CHECK: begin
		  if (pi_stg2_inc_cnt > 'd0) begin
		    pi_stg2_inc_active = 1'b1;
			skip_next_state    = PI_STG2_INC;
		  end else begin
		    pi_stg2_inc_active = 1'b0;
			skip_next_state    = IDELAY_CNT_CHECK;
		  end
		end
		
		PI_STG2_INC: begin
		  pi_f_en     = 1'b1;
		  pi_f_incdec = 1'b1;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		IDELAY_CNT_CHECK: begin
		  if (idelay_inc_cnt > 'd0) begin
		    idelay_inc_active = 1'b1;
			skip_next_state   = IDELAY_TAP_INC;
		  end else begin
		    idelay_inc_active = 1'b0;
			skip_next_state   = NEXT_BYTE;
		  end
		end
		
		IDELAY_TAP_INC: begin
		  idelay_ce  = 1'b1;
		  idelay_inc = 1'b1;
		  skip_next_state = WAIT_TAP_INC_DEC;
		end
		
		WAIT_TAP_INC_DEC: begin
		  po_c_en     = 1'b0;
		  po_c_inc    = 1'b0;
		  po_f_en     = 1'b0;
		  po_f_incdec = 1'b0;
		  pi_f_en     = 1'b0;
		  pi_f_incdec = 1'b0;
		  idelay_ce   = 1'b0;
		  idelay_inc  = 1'b0;
		  if (wait_cnt_done) begin
		    if (po_c_inc_active_r)
			  skip_next_state = PO_COARSE_CNT_CHECK;
			else if (po_stg3_inc_active_r)
			  skip_next_state = PO_STG3_INC_CNT_CHECK;
			else if (po_stg3_dec_active_r)
			  skip_next_state = PO_STG3_DEC_CNT_CHECK;
			else if (po_stg2_dec_active_r)
			  skip_next_state = PO_STG2_DEC_CNT_CHECK;
			else if (po_stg2_inc_active_r)
			  skip_next_state = PO_STG2_INC_CNT_CHECK;
			else if (pi_stg2_dec_active_r)
			  skip_next_state = PI_STG2_DEC_CNT_CHECK;
			else if (pi_stg2_inc_active_r)
			  skip_next_state = PI_STG2_INC_CNT_CHECK;
			else if (idelay_inc_active_r)
			  skip_next_state = IDELAY_CNT_CHECK;
		  end
		end
		
		NEXT_BYTE: begin
		  if (byte_cnt_r >= DQS_WIDTH-1) begin
		    skip_next_state = PO_PI_TAP_ADJ_DONE;
		  end else begin
		    byte_cnt = byte_cnt + 1;
			skip_next_state = WAIT_PO_PI_COUNTER_VAL;
		  end
		end
		
		WAIT_PO_PI_COUNTER_VAL: begin
		  if (wait_cnt_done)
		    skip_next_state = READ_PO_PI_COUNTER_VAL;
		end
		
		PO_PI_TAP_ADJ_DONE: begin
		  tap_adj_done    = 1'b1;
		end
		
		default: begin
	      skip_next_state = IDLE;
	    end
		
	  endcase
  end		

  //Debug
  assign dbg_skip_cal[4:0]   = skip_state_r;
  assign dbg_skip_cal[7:5]   = po_c_inc_cnt;
  assign dbg_skip_cal[13:8]  = po_stg3_inc_cnt;
  assign dbg_skip_cal[19:14] = po_stg3_dec_cnt;
  assign dbg_skip_cal[25:20] = po_stg2_inc_cnt;
  assign dbg_skip_cal[31:26] = po_stg2_dec_cnt;
  assign dbg_skip_cal[37:32] = pi_stg2_inc_cnt;
  assign dbg_skip_cal[43:38] = pi_stg2_dec_cnt;
  assign dbg_skip_cal[48:44] = idelay_inc_cnt;
  assign dbg_skip_cal[54:49] = byte_cnt_r;
  assign dbg_skip_cal[55]    = po_c_inc_active;
  assign dbg_skip_cal[56]    = po_stg3_inc_active;
  assign dbg_skip_cal[57]    = po_stg3_dec_active;
  assign dbg_skip_cal[58]    = po_stg2_inc_active;
  assign dbg_skip_cal[59]    = po_stg2_dec_active;
  assign dbg_skip_cal[60]    = pi_stg2_inc_active;
  assign dbg_skip_cal[61]    = pi_stg2_dec_active;
  assign dbg_skip_cal[62]    = idelay_inc_active;
  
endmodule  

