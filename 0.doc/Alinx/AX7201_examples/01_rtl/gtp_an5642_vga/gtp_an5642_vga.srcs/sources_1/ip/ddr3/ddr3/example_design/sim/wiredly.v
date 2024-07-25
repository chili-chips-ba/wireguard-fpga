//*****************************************************************************
// (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
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
// \   \   \/     Version            : 4.2
//  \   \         Application        : MIG
//  /   /         Filename           : wiredly.v
// /___/   /\     Date Last Modified : $Date: 2011/06/23 08:25:20 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   This module provide the definition of a zero ohm component (A, B).
//
//   The applications of this component include:
//     . Normal operation of a jumper wire (data flowing in both directions)
//       This can corrupt data from DRAM to FPGA useful for verifying ECC function. 
//
//   The component consists of 2 ports:
//      . Port A: One side of the pass-through switch
//      . Port B: The other side of the pass-through switch

//   The model is sensitive to transactions on all ports.  Once a transaction
//   is detected, all other transactions are ignored for that simulation time
//   (i.e. further transactions in that delta time are ignored).

// Model Limitations and Restrictions:
//   Signals asserted on the ports of the error injector should not have
//   transactions occuring in multiple delta times because the model
//   is sensitive to transactions on port A, B ONLY ONCE during
//   a simulation time.  Thus, once fired, a process will
//   not refire if there are multiple transactions occuring in delta times.
//   This condition may occur in gate level simulations with
//   ZERO delays because transactions may occur in multiple delta times.
//
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ns / 1ps

module WireDelay # (
  parameter Delay_g = 0,
  parameter Delay_rd = 0,
  parameter ERR_INSERT = "OFF"
)
(
  inout A,
  inout B,
  input reset,
  input phy_init_done
);

  reg A_r;
  reg B_r;
  reg B_inv ;
  reg line_en;

  reg B_nonX;

  assign A = A_r;
  assign B = B_r;

  always @ (*)
  begin
    if (B === 1'bx)
      B_nonX <= $random;
    else
      B_nonX <= B;
   end
   
  always@(*)
  begin
    if((B_nonX == 'b1) || (B_nonX == 'b0))
      B_inv <= #0 ~B_nonX ;
    else
      B_inv <= #0 'bz ;
   end
   
  always @(*) begin
    if (!reset) begin
      A_r <= 1'bz;
      B_r <= 1'bz;
      line_en <= 1'b0;
    end else begin
      if (line_en) begin
	B_r <= 1'bz;
	  if ((ERR_INSERT == "ON") & (phy_init_done))
            A_r <= #Delay_rd B_inv;
	  else
            A_r <= #Delay_rd B_nonX;
      end else begin
        B_r <= #Delay_g A;
	A_r <= 1'bz;
      end
    end
  end

  always @(A or B) begin
    if (!reset) begin
      line_en <= 1'b0;
    end else if (A !== A_r) begin
      line_en <= 1'b0;
    end else if (B_r !== B) begin
      line_en <= 1'b1;
    end else begin
      line_en <= line_en;
    end
  end
endmodule

