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
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 2.0
//  \   \         Application        : MIG
//  /   /         Filename           : mig_7series_v4_2_axi_fi_xor.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
//*****************************************************************************
///////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
`default_nettype none

module mig_7series_v4_2_fi_xor #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  // External Memory Data Width
  parameter integer DQ_WIDTH               = 72,
  parameter integer DQS_WIDTH              = 9,
  parameter integer nCK_PER_CLK            = 4
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations     
///////////////////////////////////////////////////////////////////////////////
  input  wire                              clk           , 
  input  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0] wrdata_in     , 
  output wire [2*nCK_PER_CLK*DQ_WIDTH-1:0] wrdata_out    , 
  input  wire                              wrdata_en     , 
  input  wire [DQS_WIDTH-1:0]              fi_xor_we     ,
  input  wire [DQ_WIDTH-1:0]               fi_xor_wrdata
);

/////////////////////////////////////////////////////////////////////////////
// Functions
/////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam DQ_PER_DQS = DQ_WIDTH / DQS_WIDTH;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg [DQ_WIDTH-1:0]              fi_xor_data = {DQ_WIDTH{1'b0}};

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
///////////////////////////////////////////////////////////////////////////////

// Register in the fi_xor_wrdata on a byte width basis
generate
begin
  genvar i;
  for (i = 0; i < DQS_WIDTH; i = i + 1) begin : assign_fi_xor_data
    always @(posedge clk) begin
      if (wrdata_en) begin
        fi_xor_data[i*DQ_PER_DQS+:DQ_PER_DQS] <= {DQ_PER_DQS{1'b0}};
      end
      else if (fi_xor_we[i]) begin
        fi_xor_data[i*DQ_PER_DQS+:DQ_PER_DQS] <= fi_xor_wrdata[i*DQ_PER_DQS+:DQ_PER_DQS];
      end 
      else begin
        fi_xor_data[i*DQ_PER_DQS+:DQ_PER_DQS] <= fi_xor_data[i*DQ_PER_DQS+:DQ_PER_DQS];
      end
    end
  end
  
end
endgenerate

assign wrdata_out[0+:DQ_WIDTH] = wrdata_in[0+:DQ_WIDTH] ^ fi_xor_data[0+:DQ_WIDTH];
 
 // Pass through upper bits
assign wrdata_out[DQ_WIDTH+:(2*nCK_PER_CLK-1)*DQ_WIDTH] = wrdata_in[DQ_WIDTH+:(2*nCK_PER_CLK-1)*DQ_WIDTH];

endmodule

`default_nettype wire

