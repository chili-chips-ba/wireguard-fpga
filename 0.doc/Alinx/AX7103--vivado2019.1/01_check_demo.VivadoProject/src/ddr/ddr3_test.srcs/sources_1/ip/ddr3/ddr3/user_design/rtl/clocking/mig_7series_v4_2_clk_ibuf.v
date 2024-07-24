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
// \   \   \/     Version:%version
//  \   \         Application: MIG
//  /   /         Filename: clk_ibuf.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:34:56 $
// \   \  /  \    Date Created:Mon Aug 3 2009
//  \___\/\___\
//
//Device: Virtex-6
//Design Name: DDR3 SDRAM
//Purpose:
//   Clock generation/distribution and reset synchronization
//Reference:
//Revision History:
//*****************************************************************************
`timescale 1ns/1ps

module mig_7series_v4_2_clk_ibuf #
  (
   parameter SYSCLK_TYPE      = "DIFFERENTIAL",
                                // input clock type
   parameter DIFF_TERM_SYSCLK = "TRUE"
                                // Differential Termination
   )
  (
   // Clock inputs
   input  sys_clk_p,          // System clock diff input
   input  sys_clk_n,
   input  sys_clk_i,
   output mmcm_clk
   );

   (* KEEP = "TRUE" *) wire sys_clk_ibufg /* synthesis syn_keep = 1 */;

  generate
    if (SYSCLK_TYPE == "DIFFERENTIAL") begin: diff_input_clk

      //***********************************************************************
      // Differential input clock input buffers
      //***********************************************************************

      IBUFGDS #
        (
         .DIFF_TERM    (DIFF_TERM_SYSCLK),
         .IBUF_LOW_PWR ("FALSE")
         )
        u_ibufg_sys_clk
          (
           .I  (sys_clk_p),
           .IB (sys_clk_n),
           .O  (sys_clk_ibufg)
           );

    end else if (SYSCLK_TYPE == "SINGLE_ENDED") begin: se_input_clk

      //***********************************************************************
      // SINGLE_ENDED input clock input buffers
      //***********************************************************************

      IBUFG #
        (
         .IBUF_LOW_PWR ("FALSE")
         )
        u_ibufg_sys_clk
          (
           .I  (sys_clk_i),
           .O  (sys_clk_ibufg)
           );
    end else if (SYSCLK_TYPE == "NO_BUFFER") begin: internal_clk

      //***********************************************************************
      // System clock is driven from FPGA internal clock (clock from fabric)
      //***********************************************************************
      assign sys_clk_ibufg = sys_clk_i;
   end
  endgenerate

  assign mmcm_clk = sys_clk_ibufg;

endmodule

