//*****************************************************************************
// (c) Copyright 2008-2009 Xilinx, Inc. All rights reserved.
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
//  /   /         Filename: data_gen_chk.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:37:19 $
// \   \  /  \    Date Created: Fri Sep 01 2006
//  \___\/\___\
//
//Device: Virtex6/Spartan6/7series
//Design Name: DDR/DDR2/DDR3/LPDDR 
//Purpose:  This module is used LFSR to generate random data for memory 
//          data write or memory data read comparison. This always 
//          generates 32-bit data only. This also checks the received 
//          data
//Reference:
//Revision History:
//*****************************************************************************
`timescale 1ps/1ps

module mig_7series_v4_2_data_gen_chk # (

  parameter C_AXI_DATA_WIDTH     = 32 // Width of the AXI write and read data
  
  ) 
  (
   input                          clk,
   input                          data_en,
   input [2:0]                    data_pattern,
   input                          pattern_init,    // when high the patterns are initialized
   input [31:0]                   prbs_seed_i,
   input [C_AXI_DATA_WIDTH-1:0]   rdata,
   input [C_AXI_DATA_WIDTH/8-1:0] rdata_bvld,
   input                          rdata_vld,
   input                          wrd_cntr_rst,
   output                         msmatch_err,     // Indicates there is a mismatch error
   output reg [7:0]               wrd_cntr,        // Word count output
   output reg [31:0]              data_o           // generated data
  );
  
  reg [31:0]                      prbs;  
  reg [32:1]                      lfsr_q;
  reg [31:0]                      walk0;
  reg [31:0]                      walk1;
  reg [C_AXI_DATA_WIDTH/32-1:0]   msmatch_err_sig;

//*****************************************************************************
// Data generate segment
//*****************************************************************************

  always @ (posedge clk) begin
    if (pattern_init) begin
      lfsr_q <= {prbs_seed_i + 32'h55555555};
    end
    else if (data_en) begin
      lfsr_q[32:9] <= lfsr_q[31:8];
      lfsr_q[8]    <= lfsr_q[32] ^ lfsr_q[7];
      lfsr_q[7]    <= lfsr_q[32] ^ lfsr_q[6];
      lfsr_q[6:4]  <= lfsr_q[5:3];
      
      lfsr_q[3]    <= lfsr_q[32] ^ lfsr_q[2];
      lfsr_q[2]    <= lfsr_q[1] ;
      lfsr_q[1]    <= lfsr_q[32];
    end
  end
  
  always @(posedge clk)
    if (pattern_init)
      walk0 <= 32'hFFFF_FFFE;
    else if (data_en)
      walk0 <= {walk0[30:0],walk0[31]};
  
  always @(posedge clk)
    if (pattern_init)
      walk1 <= 32'h0000_0001;
    else if (data_en)
      walk1 <= {walk1[30:0],walk1[31]};
  
  always @(*) begin
    prbs = lfsr_q[32:1];
  end
  
  always @(*) begin
    case (data_pattern)
      3'b001: data_o = prbs; // PRBS pattern
      3'b010: data_o = walk0; // Walking zeros
      3'b011: data_o = walk1; // Walking ones
      3'b100: data_o = 32'hFFFF_FFFF; // All ones
      3'b101: data_o = 32'h0000_0000; // All zeros
      default: data_o = 32'h5A5A_A5A5;
    endcase
  end

//*****************************************************************************
// Data check segment
//*****************************************************************************

  always @(posedge clk)
    if (wrd_cntr_rst)
      wrd_cntr <= 8'h00;
    else if (rdata_vld)
      wrd_cntr <= wrd_cntr + 8'h01;
  
  genvar i;
  generate 
    begin: data_check
      for (i = 0; i <= (C_AXI_DATA_WIDTH/32-1); i=i+1) begin: gen_data_check
        always @(posedge clk)
          if (wrd_cntr_rst)
            msmatch_err_sig[i] <= 1'b0;
          else if (rdata_vld & 
                   ((rdata[((i*32)+7):i*32] != data_o[7:0] & rdata_bvld[(i*4)]) |
                    (rdata[((i*32)+15):((i*32)+8)] != data_o[15:8] & rdata_bvld[(i*4)+1]) |
                    (rdata[((i*32)+23):((i*32)+16)] != data_o[23:16] & rdata_bvld[(i*4)+2]) |
                    (rdata[((i*32)+31):((i*32)+24)] != data_o[31:24] & rdata_bvld[(i*4)+3])))
            msmatch_err_sig[i] <= 1'b1;
          else
            msmatch_err_sig[i] <= 1'b0;
      end
    end
  endgenerate

  assign msmatch_err = |msmatch_err_sig;

// synthesis translate_off
//*****************************************************************************
// Simulation debug signals and messages
//*****************************************************************************
 
  always @(posedge clk) begin
    if (rdata_vld & ({{C_AXI_DATA_WIDTH/32}{data_o}} !== rdata)) begin
      $display ("[ERROR] : Written data and read data does not match");
      $display ("Data written : %h", {{C_AXI_DATA_WIDTH/32}{data_o}});
      $display ("Data read    : %h", rdata);
      $display ("Word number  : %h", wrd_cntr);
      $display ("Simulation time : %t", $time);
    end 
  end

// synthesis translate_on

endmodule
   
         
