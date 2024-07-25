//*****************************************************************************
// (c) Copyright 2009 - 2012 Xilinx, Inc. All rights reserved.
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
// \   \   \/     Version:%version
//  \   \         Application: MIG
//  /   /         Filename: mig_7series_v4_2_poc_meta.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Fri 24 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: Phaser output calibration edge store.
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_edge_store #
  (parameter TCQ                        = 100,
   parameter TAPCNTRWIDTH               = 7,
   parameter TAPSPERKCLK                = 112)
  (/*AUTOARG*/
  // Outputs
  fall_lead, fall_trail, rise_lead, rise_trail,
  // Inputs
  clk, run_polarity, run_end, select0, select1, tap, run
  );
  
  input clk;

  input run_polarity;
  input run_end;
  input select0;
  input select1;
  input [TAPCNTRWIDTH-1:0] tap;
  input [TAPCNTRWIDTH-1:0] run;

  wire [TAPCNTRWIDTH:0] trailing_edge = run > tap ? tap + TAPSPERKCLK[TAPCNTRWIDTH-1:0] - run
                                                  : tap - run;

  wire run_end_this = run_end && select0 && select1;

  reg [TAPCNTRWIDTH-1:0] fall_lead_r, fall_trail_r, rise_lead_r, rise_trail_r;
  output [TAPCNTRWIDTH-1:0] fall_lead, fall_trail, rise_lead, rise_trail;
  assign fall_lead = fall_lead_r;
  assign fall_trail = fall_trail_r;
  assign rise_lead = rise_lead_r;
  assign rise_trail = rise_trail_r;
  
  wire [TAPCNTRWIDTH-1:0] fall_lead_ns = run_end_this & run_polarity ? tap : fall_lead_r;
  wire [TAPCNTRWIDTH-1:0] rise_trail_ns = run_end_this & run_polarity ? trailing_edge[TAPCNTRWIDTH-1:0]
                                                                      : rise_trail_r;
  wire [TAPCNTRWIDTH-1:0] rise_lead_ns = run_end_this & ~run_polarity ? tap : rise_lead_r;
  wire [TAPCNTRWIDTH-1:0] fall_trail_ns = run_end_this & ~run_polarity ? trailing_edge[TAPCNTRWIDTH-1:0]
                                                                       : fall_trail_r;
     
  always @(posedge clk) fall_lead_r <= #TCQ fall_lead_ns;
  always @(posedge clk) fall_trail_r <= #TCQ fall_trail_ns;
  always @(posedge clk) rise_lead_r <= #TCQ rise_lead_ns;
  always @(posedge clk) rise_trail_r <= #TCQ rise_trail_ns;
  
endmodule // mig_7series_v4_2_poc_edge_store

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-extensions:(".v")
// End:

