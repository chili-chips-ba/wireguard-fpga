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
//  /   /         Filename: iodelay_ctrl.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:34:56 $
// \   \  /  \    Date Created: Wed Aug 16 2006
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//   This module instantiates the IDELAYCTRL primitive, which continously
//   calibrates the IODELAY elements in the region to account for varying
//   environmental conditions. A 200MHz or 300MHz reference clock (depending
//   on the desired IODELAY tap resolution) must be supplied
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: iodelay_ctrl.v,v 1.1 2011/06/02 08:34:56 mishra Exp $
**$Date: 2011/06/02 08:34:56 $
**$Author: mishra $
**$Revision: 1.1 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/clocking/iodelay_ctrl.v,v $
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_iodelay_ctrl #
  (
   parameter TCQ              = 100,
                                // clk->out delay (sim only)
   parameter IODELAY_GRP0     = "IODELAY_MIG0",
                                // May be assigned unique name when
                                // multiple IP cores used in design
   parameter IODELAY_GRP1     = "IODELAY_MIG1",
                                // May be assigned unique name when
                                // multiple IP cores used in design
   parameter REFCLK_TYPE      = "DIFFERENTIAL",
                                // Reference clock type
                                // "DIFFERENTIAL","SINGLE_ENDED"
                                // NO_BUFFER, USE_SYSTEM_CLOCK
   parameter SYSCLK_TYPE      = "DIFFERENTIAL",
                                // input clock type
                                // DIFFERENTIAL, SINGLE_ENDED,
                                // NO_BUFFER
   parameter SYS_RST_PORT     = "FALSE",
                                // "TRUE" - if pin is selected for sys_rst 
				//          and IBUF will be instantiated.
                                // "FALSE" - if pin is not selected for sys_rst
   parameter RST_ACT_LOW      = 1,
                                // Reset input polarity
                                // (0 = active high, 1 = active low)
   parameter DIFF_TERM_REFCLK = "TRUE",
                               // Differential Termination
   parameter FPGA_SPEED_GRADE      = 1,
                                     // FPGA speed grade
   parameter REF_CLK_MMCM_IODELAY_CTRL    = "FALSE"
   )
  (
   input        clk_ref_p,
   input        clk_ref_n,
   input        clk_ref_i,
   input        sys_rst,
   output [1:0] clk_ref,
   output       sys_rst_o,
   output [1:0] iodelay_ctrl_rdy
   );

  // # of clock cycles to delay deassertion of reset. Needs to be a fairly
  // high number not so much for metastability protection, but to give time
  // for reset (i.e. stable clock cycles) to propagate through all state
  // machines and to all control signals (i.e. not all control signals have
  // resets, instead they rely on base state logic being reset, and the effect
  // of that reset propagating through the logic). Need this because we may not
  // be getting stable clock cycles while reset asserted (i.e. since reset
  // depends on DCM lock status)
  // COMMENTED, RC, 01/13/09 - causes pack error in MAP w/ larger #
  localparam RST_SYNC_NUM = 15;
  //  localparam RST_SYNC_NUM = 25;

  wire                   clk_ref_ibufg;
  wire                   clk_ref_mmcm_300;
  wire                   clk_ref_mmcm_400;
  wire                   mmcm_clkfbout;
  wire                   mmcm_Locked;
  wire [1:0]             rst_ref;
  reg [RST_SYNC_NUM-1:0] rst_ref_sync_r [1:0] /* synthesis syn_maxfan = 10 */;
  wire                   rst_tmp_idelay;
  wire                   sys_rst_act_hi;
  (* keep = "TRUE" *) wire sys_rst_i;

  //***************************************************************************

  assign sys_rst_o = sys_rst_i;
  
  // If the pin is selected for sys_rst in GUI, IBUF will be instantiated. 
  // If the pin is not selected in GUI, sys_rst signal is expected to be 
  // driven internally.
  generate
    if (SYS_RST_PORT == "TRUE")
      IBUF u_sys_rst_ibuf
        (
         .I (sys_rst),
         .O (sys_rst_i)
         );
    else
      assign sys_rst_i = sys_rst;
  endgenerate

  // Possible inversion of system reset as appropriate
  assign  sys_rst_act_hi = RST_ACT_LOW ? ~sys_rst_i: sys_rst_i;

  //***************************************************************************
  // 1) Input buffer for IDELAYCTRL reference clock - handle either a
  //    differential or single-ended input. Global clock buffer is used to
  //    drive the rest of FPGA logic.
  // 2) For NO_BUFFER option, Reference clock will be driven from internal
  //    clock i.e., clock is driven from fabric. Input buffers and Global
  //    clock buffers will not be instaitaed.
  // 3) For USE_SYSTEM_CLOCK, input buffer output of system clock will be used
  //    as the input reference clock. Global clock buffer is used to drive
  //    the rest of FPGA logic.
  //***************************************************************************

  generate
    if (REFCLK_TYPE == "DIFFERENTIAL") begin: diff_clk_ref
      IBUFGDS #
        (
         .DIFF_TERM    (DIFF_TERM_REFCLK),
         .IBUF_LOW_PWR ("FALSE")
         )
        u_ibufg_clk_ref
          (
           .I  (clk_ref_p),
           .IB (clk_ref_n),
           .O  (clk_ref_ibufg)
           );

    end else if (REFCLK_TYPE == "SINGLE_ENDED") begin : se_clk_ref
      IBUFG #
        (
         .IBUF_LOW_PWR ("FALSE")
         )
        u_ibufg_clk_ref
          (
           .I (clk_ref_i),
           .O (clk_ref_ibufg)
           );

    end else if ((REFCLK_TYPE == "NO_BUFFER") ||
                 (REFCLK_TYPE == "USE_SYSTEM_CLOCK" && SYSCLK_TYPE == "NO_BUFFER")) begin : clk_ref_noibuf_nobuf
      assign clk_ref_ibufg = clk_ref_i;
    end else if (REFCLK_TYPE == "USE_SYSTEM_CLOCK" && SYSCLK_TYPE != "NO_BUFFER") begin : clk_ref_noibuf
      assign clk_ref_ibufg = clk_ref_i;
    end
  endgenerate

  // reference clock 300MHz and 400MHz generation with MMCM
  generate
    if (REF_CLK_MMCM_IODELAY_CTRL == "TRUE") begin: clk_ref_mmcm_gen

      MMCME2_ADV
      #(.BANDWIDTH            ("HIGH"),
        .CLKOUT4_CASCADE      ("FALSE"),
        .COMPENSATION         ("INTERNAL"),
        .STARTUP_WAIT         ("FALSE"),
        .DIVCLK_DIVIDE        (1),
        .CLKFBOUT_MULT_F      (6),
        .CLKFBOUT_PHASE       (0.000),
        .CLKFBOUT_USE_FINE_PS ("FALSE"),
        .CLKOUT0_DIVIDE_F     (4),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKOUT0_USE_FINE_PS  ("FALSE"),
        .CLKOUT1_DIVIDE       (3),
        .CLKOUT1_PHASE        (0.000),
        .CLKOUT1_DUTY_CYCLE   (0.500),
        .CLKOUT1_USE_FINE_PS  ("FALSE"),
        .CLKIN1_PERIOD        (5),
        .REF_JITTER1          (0.000))
      mmcm_i
        // Output clocks
       (.CLKFBOUT            (mmcm_clkfbout),
        .CLKFBOUTB           (),
        .CLKOUT0             (clk_ref_mmcm_300),
        .CLKOUT0B            (),
        .CLKOUT1             (clk_ref_mmcm_400),
        .CLKOUT1B            (),
        .CLKOUT2             (),
        .CLKOUT2B            (),
        .CLKOUT3             (),
        .CLKOUT3B            (),
        .CLKOUT4             (),
        .CLKOUT5             (),
        .CLKOUT6             (),
         // Input clock control
        .CLKFBIN             (mmcm_clkfbout),
        .CLKIN1              (clk_ref_ibufg),
        .CLKIN2              (1'b0),
         // Tied to always select the primary input clock
        .CLKINSEL            (1'b1),
        // Ports for dynamic reconfiguration
        .DADDR               (7'h0),
        .DCLK                (1'b0),
        .DEN                 (1'b0),
        .DI                  (16'h0),
        .DO                  (),
        .DRDY                (),
        .DWE                 (1'b0),
        // Ports for dynamic phase shift
        .PSCLK               (1'b0),
        .PSEN                (1'b0),
        .PSINCDEC            (1'b0),
        .PSDONE              (),
        // Other control and status signals
        .LOCKED              (mmcm_Locked),
        .CLKINSTOPPED        (),
        .CLKFBSTOPPED        (),
        .PWRDWN              (1'b0),
        .RST                 (sys_rst_act_hi));
    end
  endgenerate

  generate
    if (REF_CLK_MMCM_IODELAY_CTRL == "TRUE") begin : clk_ref_300_400_en
      if(FPGA_SPEED_GRADE == 1) begin: clk_ref_300
        BUFG u_bufg_clk_ref_300
          (
           .O (clk_ref[1]),
           .I (clk_ref_mmcm_300)
           );
      end else if (FPGA_SPEED_GRADE == 2 || FPGA_SPEED_GRADE == 3) begin: clk_ref_400
        BUFG u_bufg_clk_ref_400
          (
           .O (clk_ref[1]),
           .I (clk_ref_mmcm_400)
           );
      end
    end
  endgenerate

  generate
    if ((REFCLK_TYPE == "DIFFERENTIAL") || 
        (REFCLK_TYPE == "SINGLE_ENDED") ||
        (REFCLK_TYPE == "USE_SYSTEM_CLOCK" && SYSCLK_TYPE != "NO_BUFFER")) begin: clk_ref_200
      BUFG u_bufg_clk_ref
       (
        .O (clk_ref[0]),
        .I (clk_ref_ibufg)
        );
    end else begin: clk_ref_200_no_buffer
      assign clk_ref[0] = clk_ref_i;
    end
  endgenerate

  //*****************************************************************
  // IDELAYCTRL reset
  // This assumes an external clock signal driving the IDELAYCTRL
  // blocks. Otherwise, if a PLL drives IDELAYCTRL, then the PLL
  // lock signal will need to be incorporated in this.
  //*****************************************************************

  // Add PLL lock if PLL drives IDELAYCTRL in user design
  assign rst_tmp_idelay = sys_rst_act_hi;

  generate
    if (REF_CLK_MMCM_IODELAY_CTRL == "TRUE") begin: rst_ref_gen_1
      always @(posedge clk_ref[1] or posedge rst_tmp_idelay)
        if (rst_tmp_idelay)
          rst_ref_sync_r[1] <= #TCQ {RST_SYNC_NUM{1'b1}};
        else
          rst_ref_sync_r[1] <= #TCQ rst_ref_sync_r[1] << 1;
 
      assign rst_ref[1]  = rst_ref_sync_r[1][RST_SYNC_NUM-1];
    end
  endgenerate

  always @(posedge clk_ref[0] or posedge rst_tmp_idelay)
    if (rst_tmp_idelay)
      rst_ref_sync_r[0] <= #TCQ {RST_SYNC_NUM{1'b1}};
    else
      rst_ref_sync_r[0] <= #TCQ rst_ref_sync_r[0] << 1;

  assign rst_ref[0]  = rst_ref_sync_r[0][RST_SYNC_NUM-1];

  //*****************************************************************

  generate
    if (REF_CLK_MMCM_IODELAY_CTRL == "TRUE") begin: idelayctrl_gen_1
      (* IODELAY_GROUP = IODELAY_GRP1 *) IDELAYCTRL u_idelayctrl_300_400
        (
         .RDY    (iodelay_ctrl_rdy[1]),
         .REFCLK (clk_ref[1]),
         .RST    (rst_ref[1])
         );
    end
  endgenerate

  (* IODELAY_GROUP = IODELAY_GRP0 *) IDELAYCTRL u_idelayctrl_200
    (
     .RDY    (iodelay_ctrl_rdy[0]),
     .REFCLK (clk_ref[0]),
     .RST    (rst_ref[0])
     );

endmodule

