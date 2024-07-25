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
//  /   /         Filename              : ecc_dec_fix.v
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
`timescale 1ps/1ps

module mig_7series_v4_2_ecc_dec_fix
  #(
    parameter TCQ = 100,
    parameter PAYLOAD_WIDTH      = 64,
    parameter CODE_WIDTH         = 72,
    parameter DATA_WIDTH         = 64,
    parameter DQ_WIDTH           = 72,
    parameter ECC_WIDTH          = 8,
    parameter nCK_PER_CLK         = 4
   )
   (
    /*AUTOARG*/
  // Outputs
  rd_data, ecc_single, ecc_multiple,
  // Inputs
  clk, rst, h_rows, phy_rddata, correct_en, ecc_status_valid
  );

  input clk;
  input rst;

  // Compute syndromes.
  input [CODE_WIDTH*ECC_WIDTH-1:0] h_rows;
  input [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rddata;
  wire [2*nCK_PER_CLK*ECC_WIDTH-1:0] syndrome_ns;
  genvar k;
  genvar m;
  generate
    for (k=0; k<2*nCK_PER_CLK; k=k+1) begin : ecc_word
      for (m=0; m<ECC_WIDTH; m=m+1) begin : ecc_bit
        assign syndrome_ns[k*ECC_WIDTH+m] =
   ^(phy_rddata[k*DQ_WIDTH+:CODE_WIDTH] & h_rows[m*CODE_WIDTH+:CODE_WIDTH]);
      end
    end
  endgenerate
  reg [2*nCK_PER_CLK*ECC_WIDTH-1:0] syndrome_r;
  always @(posedge clk) syndrome_r <= #TCQ syndrome_ns;

  // Extract payload bits from raw DRAM bits and register.
  wire [2*nCK_PER_CLK*PAYLOAD_WIDTH-1:0] ecc_rddata_ns;
  genvar i;
  generate
    for (i=0; i<2*nCK_PER_CLK; i=i+1) begin : extract_payload
      assign ecc_rddata_ns[i*PAYLOAD_WIDTH+:PAYLOAD_WIDTH] =
               phy_rddata[i*DQ_WIDTH+:PAYLOAD_WIDTH];
    end
  endgenerate
  reg [2*nCK_PER_CLK*PAYLOAD_WIDTH-1:0] ecc_rddata_r;
  always @(posedge clk) ecc_rddata_r <= #TCQ ecc_rddata_ns;

  // Regenerate h_matrix from h_rows leaving out the identity part
  // since we're not going to correct the ECC bits themselves.
  genvar n;
  genvar p;
  wire [ECC_WIDTH-1:0] h_matrix [DATA_WIDTH-1:0];
  generate
    for (n=0; n<DATA_WIDTH; n=n+1) begin : h_col
      for (p=0; p<ECC_WIDTH; p=p+1) begin : h_bit
        assign h_matrix [n][p] = h_rows [p*CODE_WIDTH+n];
      end
    end
  endgenerate             
      
  // Compute flip bits.                
  wire [2*nCK_PER_CLK*DATA_WIDTH-1:0] flip_bits;
  genvar q;
  genvar r;
  generate
    for (q=0; q<2*nCK_PER_CLK; q=q+1) begin : flip_word
      for (r=0; r<DATA_WIDTH; r=r+1) begin : flip_bit
        assign flip_bits[q*DATA_WIDTH+r] = 
          h_matrix[r] == syndrome_r[q*ECC_WIDTH+:ECC_WIDTH];
      end
    end
  endgenerate

  // Correct data.
  output reg [2*nCK_PER_CLK*PAYLOAD_WIDTH-1:0] rd_data;
  input correct_en;
  integer s;
  always @(/*AS*/correct_en or ecc_rddata_r or flip_bits)
    for (s=0; s<2*nCK_PER_CLK; s=s+1)
      if (correct_en)
        rd_data[s*PAYLOAD_WIDTH+:DATA_WIDTH] = 
          ecc_rddata_r[s*PAYLOAD_WIDTH+:DATA_WIDTH] ^ 
              flip_bits[s*DATA_WIDTH+:DATA_WIDTH];
      else rd_data[s*PAYLOAD_WIDTH+:DATA_WIDTH] = 
           ecc_rddata_r[s*PAYLOAD_WIDTH+:DATA_WIDTH];

  // Copy raw payload bits if ECC_TEST is ON.
  localparam RAW_BIT_WIDTH = PAYLOAD_WIDTH - DATA_WIDTH;
  genvar t;
  generate
    if (RAW_BIT_WIDTH > 0)
      for (t=0; t<2*nCK_PER_CLK; t=t+1) begin : copy_raw_bits
        always @(/*AS*/ecc_rddata_r)
          rd_data[(t+1)*PAYLOAD_WIDTH-1-:RAW_BIT_WIDTH] =
            ecc_rddata_r[(t+1)*PAYLOAD_WIDTH-1-:RAW_BIT_WIDTH];
      end
  endgenerate

  // Generate status information.
  input ecc_status_valid;
  output wire [2*nCK_PER_CLK-1:0] ecc_single;
  output wire [2*nCK_PER_CLK-1:0] ecc_multiple;
  genvar v;
  generate
    for (v=0; v<2*nCK_PER_CLK; v=v+1) begin : compute_status
      wire zero = ~|syndrome_r[v*ECC_WIDTH+:ECC_WIDTH];
      wire odd = ^syndrome_r[v*ECC_WIDTH+:ECC_WIDTH];
      assign ecc_single[v] = ecc_status_valid && ~zero && odd;
      assign ecc_multiple[v] = ecc_status_valid && ~zero && ~odd;
    end
  endgenerate

endmodule

