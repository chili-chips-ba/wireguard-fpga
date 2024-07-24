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
//  /   /         Filename: mig_7series_v4_2_poc_pd.v
// /___/   /\     Date Last Modified: $$
// \   \  /  \    Date Created:Tue 15 Jan 2014
//  \___\/\___\
//
//Device: Virtex-7
//Design Name: DDR3 SDRAM
//Purpose: IDDR used as phase detector.  The pos_edge and neg_edge stuff
//         prevents any noise that could happen when the phase shift clock is very
//         nearly aligned to the fabric clock.
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_poc_pd #
  (parameter POC_USE_METASTABLE_SAMP    = "FALSE",
   parameter SIM_CAL_OPTION             = "NONE",
   parameter TCQ                        = 100)
  (/*AUTOARG*/
  // Outputs
  pd_out,
  // Inputs
  iddr_rst, clk, kclk, mmcm_ps_clk
  );

  input iddr_rst;
  input clk;
  input kclk;
  input mmcm_ps_clk;

  wire q1;
  IDDR #
    (.DDR_CLK_EDGE    ("OPPOSITE_EDGE"),
     .INIT_Q1         (1'b0),
     .INIT_Q2         (1'b0),
     .SRTYPE          ("SYNC")) 
  u_phase_detector 
    (.Q1              (q1),
     .Q2              (),
     .C               (mmcm_ps_clk),
     .CE              (1'b1),
     .D               (kclk),
     .R               (iddr_rst),
     .S               (1'b0));

  // Path from q1 to xxx_edge_samp must be constrained to be less than 1/4 cycle.  FIXME

  reg pos_edge_samp;

  generate if (SIM_CAL_OPTION == "NONE" || POC_USE_METASTABLE_SAMP == "TRUE") begin : no_eXes
    always @(posedge clk) pos_edge_samp <= #TCQ q1;
  end else begin : eXes
    reg q1_delayed;
    reg rising_clk_seen;
    always @(posedge mmcm_ps_clk) begin
      rising_clk_seen <= 1'b0;
      q1_delayed <= 1'bx;
    end
    always @(posedge clk) begin
      rising_clk_seen = 1'b1;
      if (rising_clk_seen) q1_delayed <= q1;
    end
    always @(posedge clk) begin
      pos_edge_samp <= q1_delayed;
    end
  end endgenerate

  reg pd_out_r;
  always @(posedge clk) pd_out_r <= #TCQ pos_edge_samp;

  output pd_out;
  assign pd_out = pd_out_r;


endmodule // mic_7series_v4_0_poc_pd


