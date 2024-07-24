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
//  /   /         Filename: ddr_phy_v4_0_phy_ocd_data.v
// /___/   /\     Date Last Modified: $Date: 2011/02/25 02:07:40 $
// \   \  /  \    Date Created: Aug 03 2009 
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose: Data comparison for both "non-complex" and "complex" data.
//
// Depending on complex_oclkdelay_calib_start, data provided on the phy_rddata
// bus is compared against a fixed ones and zeros pattern, or against data
// provided on the prob_o bus.
//
// In the case of complex data, the phy_rddata data is delayed by two
// clocks to match up with the prbs_o data.
//
// For 4:1 mode, in each fabric clock, a complete DRAM burst may be delivered.
// A DRAM burst is 8 times the width of the DQ bus.  For an 8 byte DQ
// bus, 64 bytes are delivered on each clock.
//
// In 2:1 mode the DRAM burst is delivered on two fabric clocks.  For
// an 8 byte bus, 32 bytes are delivered with each fabric clock.
//
// For the most part, this block does not use phy_rddata_en.  It delivers
// its results and depends on downstream logic to know when its valid.
//
// phy_rddata_en is used for the PRBS compares when the last line of data
// needs to be carried over to a subsequent line.
//
// Since we work on a byte at a time, the comparison only works on
// one byte of the DQ bus at a time.  The oclkdelay_calib_cnt field is used to
// select the proper 8 bytes out of both the phy_rddata and prob_o streams.
//
// Comparisons are computed for "zero" or "rise" data, and "oneeighty" or
// "fall" data.  The "oneeighty" compares assumes the rising edge clock is
// landing in the oneeighty data.
//
// For the simple data, we don't need to worry about first byte or last
// byte conditions because the sampled data is taken from the middle
// of a 4 burst segment.
//
// The complex (or PRBS) data starts and stops.  And we need to be
// careful about ignoring compares that might be using invalid latched
// data. The PRBS generator provides prbs_ignore_first_byte and 
// prbs_ignore_last_bytes.  The comparison block is procedural.  It
// first compares across the entire line, then comes back and overwrites
// any byte compare results as indicated by the _ignore_ wires.
// 
// The compares generate an eight bit vector, one for each byte.  The
// final step is to bitwise AND this eight bit vector.  We end up
// with two sets of two bits.  Zero and oneeighty for the fixed pattern
// and the prbs.   
//
// complex_oclkdelay_calib_start is used to
// select between the fixed and prbs compares.  The final output
// is a two bit match bus.
//
// There is a deprecated feature to mask the compare for any byte.
//
//      
//Reference:
//Revision History:
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_phy_ocd_data #
  (parameter TCQ                = 100,
   parameter nCK_PER_CLK        = 4,
   parameter DQS_CNT_WIDTH      = 3,
   parameter DQ_WIDTH           = 64)
  (/*AUTOARG*/
  // Outputs
  match,
  // Inputs
  clk, rst, complex_oclkdelay_calib_start, phy_rddata, prbs_o,
  oclkdelay_calib_cnt, prbs_ignore_first_byte, prbs_ignore_last_bytes,
  phy_rddata_en_1
  );

  localparam [7:0] OCAL_DQ_MASK = 8'b0000_0000;

  input clk;
  input rst;

  input complex_oclkdelay_calib_start;
  input [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rddata;
  input [2*nCK_PER_CLK*DQ_WIDTH-1:0] prbs_o;
  input [DQS_CNT_WIDTH:0] oclkdelay_calib_cnt;

  reg [DQ_WIDTH-1:0] word, word_shifted;
 
  reg [63:0] data_bytes_ns, data_bytes_r, data_bytes_r1, data_bytes_r2, prbs_bytes_ns, prbs_bytes_r;
  always @(posedge clk) data_bytes_r <= #TCQ data_bytes_ns;
  always @(posedge clk) data_bytes_r1 <= #TCQ data_bytes_r;
  always @(posedge clk) data_bytes_r2 <= #TCQ data_bytes_r1;
  always @(posedge clk) prbs_bytes_r <= #TCQ prbs_bytes_ns;

  input prbs_ignore_first_byte, prbs_ignore_last_bytes;
  reg prbs_ignore_first_byte_r, prbs_ignore_last_bytes_r;
  always @(posedge clk) prbs_ignore_first_byte_r <= #TCQ prbs_ignore_first_byte;
  always @(posedge clk) prbs_ignore_last_bytes_r <= #TCQ prbs_ignore_last_bytes;

  input phy_rddata_en_1;
  reg [7:0] last_byte_r;
  wire [63:0] data_bytes = complex_oclkdelay_calib_start ? data_bytes_r2 : data_bytes_r;
  
  wire [7:0] last_byte_ns;
  generate if (nCK_PER_CLK == 4) begin
    assign last_byte_ns = phy_rddata_en_1 ? data_bytes[63:56] : last_byte_r;
  end else begin
    assign last_byte_ns = phy_rddata_en_1 ? data_bytes[31:24] : last_byte_r;
  end endgenerate
  always @(posedge clk) last_byte_r <= #TCQ last_byte_ns;

  reg second_half_ns, second_half_r;
  always @(posedge clk) second_half_r <= #TCQ second_half_ns;
  always @(*) begin
    second_half_ns = second_half_r;
    if (rst) second_half_ns = 1'b0;
    else second_half_ns = phy_rddata_en_1 ^ second_half_r;
  end

  reg [7:0] comp0, comp180, prbs0, prbs180;
   
  integer ii;
  always @(*) begin
    comp0 = 8'hff;
    comp180 = 8'hff;
    prbs0 = 8'hff;
    prbs180 = 8'hff;
    data_bytes_ns = 64'b0;
    prbs_bytes_ns = 64'b0;
    for (ii=0; ii<2*nCK_PER_CLK; ii=ii+1) 
      begin
        word = phy_rddata[ii*DQ_WIDTH+:DQ_WIDTH];
	word_shifted = word >> oclkdelay_calib_cnt*8;
	data_bytes_ns[ii*8+:8] = word_shifted[7:0];
	
        word = prbs_o[ii*DQ_WIDTH+:DQ_WIDTH];
	word_shifted = word >> oclkdelay_calib_cnt*8;
	prbs_bytes_ns[ii*8+:8] = word_shifted[7:0];
	
	comp0[ii] = data_bytes[ii*8+:8] == (ii%2 ? 8'hff : 8'h00);
	comp180[ii] = data_bytes[ii*8+:8] == (ii%2 ? 8'h00 : 8'hff);
	
        prbs0[ii] = data_bytes[ii*8+:8] == prbs_bytes_r[ii*8+:8];
      end // for (ii=0; ii<2*nCK_PER_CLK; ii=ii+1)
    prbs180[0] = last_byte_r == prbs_bytes_r[7:0];
    for (ii=1; ii<2*nCK_PER_CLK; ii=ii+1)
       	prbs180[ii] = data_bytes[(ii-1)*8+:8] == prbs_bytes_r[ii*8+:8];
    if (nCK_PER_CLK == 4) begin
      if (prbs_ignore_last_bytes_r) begin
        prbs0[7:6] = 2'b11;
	prbs180[7] = 1'b1;
      end
      if (prbs_ignore_first_byte_r) prbs180[0] = 1'b1;
    end else begin
      if (second_half_r) begin
        if (prbs_ignore_last_bytes_r) begin
	    prbs0[3:2] = 2'b11;
	    prbs180[3] = 1'b1;
	end
      end else if (prbs_ignore_first_byte_r) prbs180[0] = 1'b1;
    end // else: !if(nCK_PER_CLK == 4)
  end // always @ (*)

  wire [7:0] comp0_masked = comp0 | OCAL_DQ_MASK;
  wire [7:0] comp180_masked = comp180 | OCAL_DQ_MASK;
  wire [7:0] prbs0_masked = prbs0 | OCAL_DQ_MASK;
  wire [7:0] prbs180_masked = prbs180 | OCAL_DQ_MASK;
  
  output [1:0] match;
  assign match = complex_oclkdelay_calib_start ? {&prbs180_masked, &prbs0_masked} : {&comp180_masked , &comp0_masked};


endmodule // mig_7series_v4_2_ddr_phy_ocd_data


