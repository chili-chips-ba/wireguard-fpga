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
//  /   /         Filename: ddr_phy_v4_0_phy_ocd_cntlr.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Steps through the major sections of the output clock
// delay algorithm.  Enabling various subblocks at the right time.
//
// Steps through each byte of the interface.
//
// Implements both the simple and complex data pattern.
//
// for each byte in interface
//   begin
//     Limit
//     Scan - which includes DQS centering
//     Precharge
//   end
// set _wrlvl and _done equal to one
// 
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ocd_cntlr #
  (parameter TCQ             = 100,
   parameter DQS_CNT_WIDTH   = 3,
   parameter DQS_WIDTH       = 8)
  (/*AUTOARG*/
  // Outputs
  wrlvl_final, complex_wrlvl_final, oclk_init_delay_done,
  ocd_prech_req, lim_start, complex_oclkdelay_calib_done,
  oclkdelay_calib_done, phy_rddata_en_1, phy_rddata_en_2,
  phy_rddata_en_3, ocd_cntlr2stg2_dec, oclkdelay_calib_cnt,
  reset_scan,
  // Inputs
  clk, rst, prech_done, oclkdelay_calib_start,
  complex_oclkdelay_calib_start, lim_done, phy_rddata_en,
  po_counter_read_val, po_rdy, scan_done
  );

  localparam ONE = 1;
  
  input clk;
  input rst;
  
  output wrlvl_final, complex_wrlvl_final;
  reg wrlvl_final_ns, wrlvl_final_r, complex_wrlvl_final_ns, complex_wrlvl_final_r;
  always @(posedge clk) wrlvl_final_r <= #TCQ wrlvl_final_ns;
  always @(posedge clk) complex_wrlvl_final_r <= #TCQ complex_wrlvl_final_ns;
  assign wrlvl_final = wrlvl_final_r;
  assign complex_wrlvl_final = complex_wrlvl_final_r;
  
   // Completed initial delay increment
  output oclk_init_delay_done;  // may not need this... maybe for fast cal mode.
  assign oclk_init_delay_done = 1'b1;

  // Precharge done status from ddr_phy_init
  input prech_done;
  reg ocd_prech_req_ns, ocd_prech_req_r;
  always @(posedge clk) ocd_prech_req_r <= #TCQ ocd_prech_req_ns;
  output ocd_prech_req;
  assign ocd_prech_req = ocd_prech_req_r;

  input oclkdelay_calib_start, complex_oclkdelay_calib_start;
  input lim_done;

  reg lim_start_ns, lim_start_r;
  always @(posedge clk) lim_start_r <= #TCQ lim_start_ns;
  output lim_start;
  assign lim_start = lim_start_r;
    
  reg complex_oclkdelay_calib_done_ns, complex_oclkdelay_calib_done_r;
  always @(posedge clk) complex_oclkdelay_calib_done_r <= #TCQ complex_oclkdelay_calib_done_ns;
  output complex_oclkdelay_calib_done;
  assign complex_oclkdelay_calib_done = complex_oclkdelay_calib_done_r;
  
  reg oclkdelay_calib_done_ns, oclkdelay_calib_done_r;
  always @(posedge clk) oclkdelay_calib_done_r <= #TCQ oclkdelay_calib_done_ns;
  output oclkdelay_calib_done;
  assign oclkdelay_calib_done = oclkdelay_calib_done_r;

  input phy_rddata_en;
  reg prde_r1, prde_r2;
  always @(posedge clk) prde_r1 <= #TCQ phy_rddata_en;
  always @(posedge clk) prde_r2 <= #TCQ prde_r1;
  wire prde = complex_oclkdelay_calib_start ? prde_r2 : phy_rddata_en;
  
  reg phy_rddata_en_r1, phy_rddata_en_r2, phy_rddata_en_r3;
  always @(posedge clk) phy_rddata_en_r1 <= #TCQ prde;
  always @(posedge clk) phy_rddata_en_r2 <= #TCQ phy_rddata_en_r1;
  always @(posedge clk) phy_rddata_en_r3 <= #TCQ phy_rddata_en_r2;
  output phy_rddata_en_1, phy_rddata_en_2, phy_rddata_en_3;
  assign phy_rddata_en_1 = phy_rddata_en_r1;
  assign phy_rddata_en_2 = phy_rddata_en_r2;
  assign phy_rddata_en_3 = phy_rddata_en_r3;

  input [8:0] po_counter_read_val;
  reg ocd_cntlr2stg2_dec_r;
  output ocd_cntlr2stg2_dec;
  assign ocd_cntlr2stg2_dec = ocd_cntlr2stg2_dec_r;
  input po_rdy;

  reg [3:0] po_rd_wait_ns, po_rd_wait_r;
  always @(posedge clk) po_rd_wait_r <= #TCQ po_rd_wait_ns;

  reg [DQS_CNT_WIDTH-1:0] byte_ns, byte_r;
  always @(posedge clk) byte_r <= #TCQ byte_ns;
  output [DQS_CNT_WIDTH:0] oclkdelay_calib_cnt;
  assign oclkdelay_calib_cnt = {1'b0, byte_r};

  reg reset_scan_ns, reset_scan_r;
  always @(posedge clk) reset_scan_r <= #TCQ reset_scan_ns;
  output reset_scan;
  assign reset_scan = reset_scan_r;
  input scan_done;

  reg [2:0] sm_ns, sm_r;
  always @(posedge clk) sm_r <= #TCQ sm_ns;

  // Primary state machine.
  
  always @(*) begin

  // Default next state assignments.

    byte_ns = byte_r;
    complex_wrlvl_final_ns = complex_wrlvl_final_r;
    lim_start_ns = lim_start_r;
    oclkdelay_calib_done_ns = oclkdelay_calib_done_r;
    complex_oclkdelay_calib_done_ns = complex_oclkdelay_calib_done_r;
    ocd_cntlr2stg2_dec_r = 1'b0;
    po_rd_wait_ns = po_rd_wait_r;
    if (|po_rd_wait_r) po_rd_wait_ns = po_rd_wait_r - 4'b1;
    reset_scan_ns = reset_scan_r;
    wrlvl_final_ns = wrlvl_final_r;
    sm_ns = sm_r;
    ocd_prech_req_ns= 1'b0;
    
    if (rst == 1'b1) begin
      
  // RESET next states
      complex_oclkdelay_calib_done_ns = 1'b0;
      complex_wrlvl_final_ns = 1'b0;
      sm_ns = /*AK("READY")*/3'd0;
      lim_start_ns = 1'b0;
      oclkdelay_calib_done_ns = 1'b0;
      reset_scan_ns = 1'b1;
      wrlvl_final_ns = 1'b0;
    end else
      
  // State based actions and next states. 
      case (sm_r)
        /*AL("READY")*/3'd0: begin
	  byte_ns = {DQS_CNT_WIDTH{1'b0}};
	  if (oclkdelay_calib_start && ~oclkdelay_calib_done_r ||
	      complex_oclkdelay_calib_start && ~complex_oclkdelay_calib_done_r)
          begin
            sm_ns = /*AK("LIMIT_START")*/3'd1;
	    lim_start_ns = 1'b1;
	  end
        end	

        /*AL("LIMIT_START")*/3'd1:
	    sm_ns = /*AK("LIMIT_WAIT")*/3'd2;

       /*AL("LIMIT_WAIT")*/3'd2:begin
	  if (lim_done) begin
	    lim_start_ns = 1'b0;
	    sm_ns = /*AK("SCAN")*/3'd3;
	    reset_scan_ns = 1'b0;
	  end
        end

	/*AL("SCAN")*/3'd3:begin
	  if (scan_done) begin
	    reset_scan_ns = 1'b1;
	    sm_ns = /*AK("COMPUTE")*/3'd4;
	  end
        end

       /*AL("COMPUTE")*/3'd4:begin
	  sm_ns = /*AK("PRECHARGE")*/3'd5;
	  ocd_prech_req_ns = 1'b1;
       end
	
       /*AL("PRECHARGE")*/3'd5:begin
	 if (prech_done) sm_ns = /*AK("DONE")*/3'd6;
       end
	
	/*AL("DONE")*/3'd6:begin
	  byte_ns = byte_r + ONE[DQS_CNT_WIDTH-1:0];
	  if ({1'b0, byte_r} == DQS_WIDTH[DQS_CNT_WIDTH:0] - ONE[DQS_WIDTH:0]) begin
	    byte_ns = {DQS_CNT_WIDTH{1'b0}};
	    po_rd_wait_ns = 4'd8;
	    sm_ns = /*AK("STG2_2_ZERO")*/3'd7;
	  end else begin
	    sm_ns = /*AK("LIMIT_START")*/3'd1;
	    lim_start_ns = 1'b1;
	  end
        end

	/*AL("STG2_2_ZERO")*/3'd7:
	  if (~|po_rd_wait_r && po_rdy)
	    if (|po_counter_read_val[5:0]) ocd_cntlr2stg2_dec_r = 1'b1;
	    else begin
	      if ({1'b0, byte_r} == DQS_WIDTH[DQS_CNT_WIDTH:0] - ONE[DQS_WIDTH:0]) begin
	        sm_ns = /*AK("READY")*/3'd0;
	        oclkdelay_calib_done_ns= 1'b1;
	        wrlvl_final_ns = 1'b1;
	        if (complex_oclkdelay_calib_start) begin
                  complex_oclkdelay_calib_done_ns = 1'b1;
	          complex_wrlvl_final_ns = 1'b1;
	        end
	      end else begin
		byte_ns = byte_r + ONE[DQS_CNT_WIDTH-1:0];
		po_rd_wait_ns = 4'd8;
	      end
	    end // else: !if(|po_counter_read_val[5:0])
    
      endcase // case (sm_r)
  end // always @ begin
  
endmodule // mig_7series_v4_2_ddr_phy_ocd_cntlr

// Local Variables:
// verilog-autolabel-prefix: "3'd"
// End:

