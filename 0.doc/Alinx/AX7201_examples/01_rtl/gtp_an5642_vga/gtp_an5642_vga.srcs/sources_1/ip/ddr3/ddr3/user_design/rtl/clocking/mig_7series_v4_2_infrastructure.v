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
//  /   /         Filename: infrastructure.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:34:56 $
// \   \  /  \    Date Created:Tue Jun 30 2009
//  \___\/\___\
//
//Device: Virtex-6
//Design Name: DDR3 SDRAM
//Purpose:
//   Clock generation/distribution and reset synchronization
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: infrastructure.v,v 1.1 2011/06/02 08:34:56 mishra Exp $
**$Date: 2011/06/02 08:34:56 $
**$Author: mishra $
**$Revision: 1.1 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/clocking/infrastructure.v,v $
******************************************************************************/

`timescale 1ps/1ps


module mig_7series_v4_2_infrastructure #
  (
   parameter SIMULATION      = "FALSE",  // Should be TRUE during design simulations and
                                         // FALSE during implementations
   parameter TCQ             = 100,      // clk->out delay (sim only)
   parameter CLKIN_PERIOD    = 3000,     // Memory clock period
   parameter nCK_PER_CLK     = 2,        // Fabric clk period:Memory clk period
   parameter SYSCLK_TYPE     = "DIFFERENTIAL",
                                         // input clock type
                                         // "DIFFERENTIAL","SINGLE_ENDED"
   parameter UI_EXTRA_CLOCKS = "FALSE",
                                         // Generates extra clocks as
                                         // 1/2, 1/4 and 1/8 of fabrick clock.
                                         // Valid for DDR2/DDR3 AXI interfaces
                                         // based on GUI selection
   parameter CLKFBOUT_MULT   = 4,        // write PLL VCO multiplier
   parameter DIVCLK_DIVIDE   = 1,        // write PLL VCO divisor
   parameter CLKOUT0_PHASE   = 45.0,     // VCO output divisor for clkout0
   parameter CLKOUT0_DIVIDE   = 16,      // VCO output divisor for PLL clkout0
   parameter CLKOUT1_DIVIDE   = 4,       // VCO output divisor for PLL clkout1
   parameter CLKOUT2_DIVIDE   = 64,      // VCO output divisor for PLL clkout2
   parameter CLKOUT3_DIVIDE   = 16,      // VCO output divisor for PLL clkout3
   parameter MMCM_VCO             = 1200,     // Max Freq (MHz) of MMCM VCO
   parameter MMCM_MULT_F          = 4,        // write MMCM VCO multiplier
   parameter MMCM_DIVCLK_DIVIDE   = 1,        // write MMCM VCO divisor
   parameter MMCM_CLKOUT0_EN       = "FALSE",  // Enabled (or) Disable MMCM clkout0
   parameter MMCM_CLKOUT1_EN       = "FALSE",  // Enabled (or) Disable MMCM clkout1
   parameter MMCM_CLKOUT2_EN       = "FALSE",  // Enabled (or) Disable MMCM clkout2
   parameter MMCM_CLKOUT3_EN       = "FALSE",  // Enabled (or) Disable MMCM clkout3
   parameter MMCM_CLKOUT4_EN       = "FALSE",  // Enabled (or) Disable MMCM clkout4
   parameter MMCM_CLKOUT0_DIVIDE   = 1,  // VCO output divisor for MMCM clkout0
   parameter MMCM_CLKOUT1_DIVIDE   = 1,  // VCO output divisor for MMCM clkout1
   parameter MMCM_CLKOUT2_DIVIDE   = 1,  // VCO output divisor for MMCM clkout2
   parameter MMCM_CLKOUT3_DIVIDE   = 1,  // VCO output divisor for MMCM clkout3
   parameter MMCM_CLKOUT4_DIVIDE   = 1,  // VCO output divisor for MMCM clkout4
   parameter RST_ACT_LOW           = 1,
   parameter tCK                   = 1250,
                                     // memory tCK paramter.
                                     // # = Clock Period in pS.
   parameter MEM_TYPE              = "DDR3"
   )
  (
   // Clock inputs
   input  mmcm_clk,           // System clock diff input
   // System reset input
   input  sys_rst,            // core reset from user application
   // PLLE2/IDELAYCTRL Lock status
   input  [1:0] iodelay_ctrl_rdy,   // IDELAYCTRL lock status
   // Clock outputs

   output clk,                // fabric clock freq ; either  half rate or quarter rate and is
                              // determined by  PLL parameters settings.
   output clk_div2,           // mem_refclk divided by 2 for PI incdec
   output rst_div2,           // reset in clk_div2 domain
   output mem_refclk,         // equal to  memory clock
   output freq_refclk,        // freq above 400 MHz:  set freq_refclk = mem_refclk
                              // freq below 400 MHz:  set freq_refclk = 2* mem_refclk or 4* mem_refclk;
                              // to hard PHY for phaser
   output sync_pulse,         // exactly 1/16 of mem_refclk and the sync pulse is exactly 1 memref_clk wide
//   output auxout_clk,         // IO clk used to clock out Aux_Out ports
   output mmcm_ps_clk,        // Phase shift clock
   output poc_sample_pd,      // Tell POC when to sample phase detector output.
   output ui_addn_clk_0,      // MMCM out0 clk
   output ui_addn_clk_1,      // MMCM out1 clk
   output ui_addn_clk_2,      // MMCM out2 clk
   output ui_addn_clk_3,      // MMCM out3 clk
   output ui_addn_clk_4,      // MMCM out4 clk
   output pll_locked,         // locked output from PLLE2_ADV
   output mmcm_locked,        // locked output from MMCME2_ADV
   // Reset outputs
   output rstdiv0,             // Reset CLK and CLKDIV logic (incl I/O),
   output iddr_rst

   ,output rst_phaser_ref
   ,input  ref_dll_lock
   ,input  psen
   ,input  psincdec
   ,output psdone
   );

  // # of clock cycles to delay deassertion of reset. Needs to be a fairly
  // high number not so much for metastability protection, but to give time
  // for reset (i.e. stable clock cycles) to propagate through all state
  // machines and to all control signals (i.e. not all control signals have
  // resets, instead they rely on base state logic being reset, and the effect
  // of that reset propagating through the logic). Need this because we may not
  // be getting stable clock cycles while reset asserted (i.e. since reset
  // depends on DCM lock status)
  localparam RST_SYNC_NUM = 25;

  // Round up for clk reset delay to ensure that CLKDIV reset deassertion
  // occurs at same time or after CLK reset deassertion (still need to
  // consider route delay - add one or two extra cycles to be sure!)
  localparam RST_DIV_SYNC_NUM = (RST_SYNC_NUM+1)/2;

  // Input clock is assumed to be equal to the memory clock frequency
  // User should change the parameter as necessary if a different input
  // clock frequency is used
  localparam real CLKIN1_PERIOD_NS = CLKIN_PERIOD / 1000.0;
  localparam CLKOUT4_DIVIDE = 2 * CLKOUT1_DIVIDE;

  localparam integer VCO_PERIOD
             = (CLKIN1_PERIOD_NS * DIVCLK_DIVIDE * 1000) / CLKFBOUT_MULT;

  localparam CLKOUT0_PERIOD = VCO_PERIOD * CLKOUT0_DIVIDE;
  localparam CLKOUT1_PERIOD = VCO_PERIOD * CLKOUT1_DIVIDE;
  localparam CLKOUT2_PERIOD = VCO_PERIOD * CLKOUT2_DIVIDE;
  localparam CLKOUT3_PERIOD = VCO_PERIOD * CLKOUT3_DIVIDE;
  localparam CLKOUT4_PERIOD = VCO_PERIOD * CLKOUT4_DIVIDE;

  localparam CLKOUT4_PHASE  = (SIMULATION == "TRUE") ? 22.5 : 168.75;

  localparam real CLKOUT3_PERIOD_NS = CLKOUT3_PERIOD / 1000.0;
  localparam real CLKOUT4_PERIOD_NS = CLKOUT4_PERIOD / 1000.0;

  //synthesis translate_off
  initial begin
    $display("############# Write Clocks PLLE2_ADV Parameters #############\n");
    $display("nCK_PER_CLK      = %7d",   nCK_PER_CLK     );
    $display("CLK_PERIOD       = %7d",   CLKIN_PERIOD    );
    $display("CLKIN1_PERIOD    = %7.3f", CLKIN1_PERIOD_NS);
    $display("DIVCLK_DIVIDE    = %7d",   DIVCLK_DIVIDE   );
    $display("CLKFBOUT_MULT    = %7d",   CLKFBOUT_MULT );
    $display("VCO_PERIOD       = %7.1f", VCO_PERIOD      );
    $display("CLKOUT0_DIVIDE_F = %7d",   CLKOUT0_DIVIDE  );
    $display("CLKOUT1_DIVIDE   = %7d",   CLKOUT1_DIVIDE  );
    $display("CLKOUT2_DIVIDE   = %7d",   CLKOUT2_DIVIDE  );
    $display("CLKOUT3_DIVIDE   = %7d",   CLKOUT3_DIVIDE  );
    $display("CLKOUT0_PERIOD   = %7d",   CLKOUT0_PERIOD  );
    $display("CLKOUT1_PERIOD   = %7d",   CLKOUT1_PERIOD  );
    $display("CLKOUT2_PERIOD   = %7d",   CLKOUT2_PERIOD  );
    $display("CLKOUT3_PERIOD   = %7d",   CLKOUT3_PERIOD  );
    $display("CLKOUT4_PERIOD   = %7d",   CLKOUT4_PERIOD  );
    $display("############################################################\n");
  end
  //synthesis translate_on

  wire                       clk_bufg;
  wire                       clk_pll_i;
  wire                       clkfbout_pll;
  wire                       pll_clkfbout;
  wire                       pll_locked_i
                             /* synthesis syn_maxfan = 10 */;
  (* max_fanout = 50 *) reg [RST_DIV_SYNC_NUM-2:0] rstdiv0_sync_r;
  wire                       rst_tmp;
  (* max_fanout = 50 *) reg rstdiv0_sync_r1
                            /* synthesis syn_maxfan = 50 */;
  reg [RST_DIV_SYNC_NUM-2:0] rst_sync_r;
 (* max_fanout = 10  *) reg rst_sync_r1
                             /* synthesis syn_maxfan = 10 */;
  reg [RST_DIV_SYNC_NUM-2:0] rstdiv2_sync_r;
  (* max_fanout = 10  *) reg rstdiv2_sync_r1
                             /* synthesis syn_maxfan = 10 */;
  wire                       sys_rst_act_hi;

  wire                       rst_tmp_phaser_ref;
  (* max_fanout = 50 *) reg [RST_DIV_SYNC_NUM-1:0] rst_phaser_ref_sync_r
                             /* synthesis syn_maxfan = 10 */;

  // Instantiation of the MMCM primitive
  wire        clkfbout;
  wire        MMCM_Locked_i;

  wire        mmcm_clkout0;
  wire        mmcm_clkout1;
  wire        mmcm_clkout2;
  wire        mmcm_clkout3;
  wire        mmcm_clkout4;
  wire        mmcm_ps_clk_bufg_in;
  wire        clk_div2_bufg_in;

  wire        pll_clk3_out;
  wire        pll_clk3;

  assign sys_rst_act_hi = RST_ACT_LOW ? ~sys_rst: sys_rst;

  //***************************************************************************
  // Assign global clocks:
  //   2. clk     : Half rate / Quarter rate(used for majority of internal logic)
  //***************************************************************************

  assign clk        = clk_bufg;
  assign pll_locked = pll_locked_i & MMCM_Locked_i;
  assign mmcm_locked = MMCM_Locked_i;


  //***************************************************************************
  // Global base clock generation and distribution
  //***************************************************************************

  //*****************************************************************
  // NOTES ON CALCULTING PROPER VCO FREQUENCY
  //  1. VCO frequency =
  //     1/((DIVCLK_DIVIDE * CLKIN_PERIOD)/(CLKFBOUT_MULT * nCK_PER_CLK))
  //  2. VCO frequency must be in the range [TBD, TBD]
  //*****************************************************************

  PLLE2_ADV #
    (
     .BANDWIDTH          ("OPTIMIZED"),
     .COMPENSATION       ("INTERNAL"),
     .STARTUP_WAIT       ("FALSE"),
     .CLKOUT0_DIVIDE     (CLKOUT0_DIVIDE),  // 4 freq_ref
     .CLKOUT1_DIVIDE     (CLKOUT1_DIVIDE),  // 4 mem_ref
     .CLKOUT2_DIVIDE     (CLKOUT2_DIVIDE),  // 16 sync
     .CLKOUT3_DIVIDE     (CLKOUT3_DIVIDE),  // 16 sysclk
     .CLKOUT4_DIVIDE     (CLKOUT4_DIVIDE),
     .CLKOUT5_DIVIDE     (),
     .DIVCLK_DIVIDE      (DIVCLK_DIVIDE),
     .CLKFBOUT_MULT      (CLKFBOUT_MULT),
     .CLKFBOUT_PHASE     (0.000),
     .CLKIN1_PERIOD      (CLKIN1_PERIOD_NS),
     .CLKIN2_PERIOD      (),
     .CLKOUT0_DUTY_CYCLE (0.500),
     .CLKOUT0_PHASE      (CLKOUT0_PHASE),
     .CLKOUT1_DUTY_CYCLE (0.500),
     .CLKOUT1_PHASE      (0.000),
     .CLKOUT2_DUTY_CYCLE (1.0/16.0),
     .CLKOUT2_PHASE      (9.84375),     // PHASE shift is required for sync pulse generation.
     .CLKOUT3_DUTY_CYCLE (0.500),
     .CLKOUT3_PHASE      (0.000),
     .CLKOUT4_DUTY_CYCLE (0.500),
     .CLKOUT4_PHASE      (CLKOUT4_PHASE),
     .CLKOUT5_DUTY_CYCLE (0.500),
     .CLKOUT5_PHASE      (0.000),
     .REF_JITTER1        (0.010),
     .REF_JITTER2        (0.010)
     )
    plle2_i
      (
       .CLKFBOUT (pll_clkfbout),
       .CLKOUT0  (freq_refclk),
       .CLKOUT1  (mem_refclk),
       .CLKOUT2  (sync_pulse),  // always 1/16 of mem_ref_clk
       .CLKOUT3  (pll_clk3_out),
//       .CLKOUT4  (auxout_clk_i),
       .CLKOUT4  (),
       .CLKOUT5  (),
       .DO       (),
       .DRDY     (),
       .LOCKED   (pll_locked_i),
       .CLKFBIN  (pll_clkfbout),
       .CLKIN1   (mmcm_clk),
       .CLKIN2   (),
       .CLKINSEL (1'b1),
       .DADDR    (7'b0),
       .DCLK     (1'b0),
       .DEN      (1'b0),
       .DI       (16'b0),
       .DWE      (1'b0),
       .PWRDWN   (1'b0),
       .RST      ( sys_rst_act_hi)
       );


//  BUFH u_bufh_auxout_clk
//    (
//     .O (auxout_clk),
//     .I (auxout_clk_i)
//     );

  BUFG u_bufg_clkdiv0
    (
     .O (clk_bufg),
     .I (clk_pll_i)
     );

  BUFH u_bufh_pll_clk3
    (
     .O (pll_clk3),
     .I (pll_clk3_out)
     );

  localparam  real    MMCM_VCO_PERIOD       = 1000000.0/MMCM_VCO;

  //synthesis translate_off
  initial begin
    $display("############# MMCME2_ADV Parameters #############\n");
    $display("MMCM_MULT_F           = %d", MMCM_MULT_F);
//    $display("MMCM_VCO_FREQ (MHz)   = %7.3f", MMCM_VCO*1000.0);
    $display("MMCM_VCO_FREQ (MHz)   = %7.3f", MMCM_VCO*1.000);
    $display("MMCM_VCO_PERIOD       = %7.3f", MMCM_VCO_PERIOD);
    $display("#################################################\n");
  end
  //synthesis translate_on

  generate
    if (UI_EXTRA_CLOCKS == "TRUE") begin: gen_ui_extra_clocks

      localparam MMCM_CLKOUT0_DIVIDE_CAL = (MMCM_CLKOUT0_EN == "TRUE") ? MMCM_CLKOUT0_DIVIDE : MMCM_MULT_F;
      localparam MMCM_CLKOUT1_DIVIDE_CAL = (MMCM_CLKOUT1_EN == "TRUE") ? MMCM_CLKOUT1_DIVIDE : MMCM_MULT_F;
      localparam MMCM_CLKOUT2_DIVIDE_CAL = (MMCM_CLKOUT2_EN == "TRUE") ? MMCM_CLKOUT2_DIVIDE : MMCM_MULT_F;
      localparam MMCM_CLKOUT3_DIVIDE_CAL = (MMCM_CLKOUT3_EN == "TRUE") ? MMCM_CLKOUT3_DIVIDE : MMCM_MULT_F;
      localparam MMCM_CLKOUT4_DIVIDE_CAL = (MMCM_CLKOUT4_EN == "TRUE") ? MMCM_CLKOUT4_DIVIDE : MMCM_MULT_F;

      MMCME2_ADV
      #(.BANDWIDTH            ("HIGH"),
        .CLKOUT4_CASCADE      ("FALSE"),
        .COMPENSATION         ("BUF_IN"),
        .STARTUP_WAIT         ("FALSE"),
//        .DIVCLK_DIVIDE        (1),
        .DIVCLK_DIVIDE        (MMCM_DIVCLK_DIVIDE),
        .CLKFBOUT_MULT_F      (MMCM_MULT_F),
        .CLKFBOUT_PHASE       (0.000),
        .CLKFBOUT_USE_FINE_PS ("FALSE"),
        .CLKOUT0_DIVIDE_F     (MMCM_CLKOUT0_DIVIDE_CAL),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKOUT0_USE_FINE_PS  ("FALSE"),
        .CLKOUT1_DIVIDE       (MMCM_CLKOUT1_DIVIDE_CAL),
        .CLKOUT1_PHASE        (0.000),
        .CLKOUT1_DUTY_CYCLE   (0.500),
        .CLKOUT1_USE_FINE_PS  ("FALSE"),
        .CLKOUT2_DIVIDE       (MMCM_CLKOUT2_DIVIDE_CAL),
        .CLKOUT2_PHASE        (0.000),
        .CLKOUT2_DUTY_CYCLE   (0.500),
        .CLKOUT2_USE_FINE_PS  ("FALSE"),
        .CLKOUT3_DIVIDE       (MMCM_CLKOUT3_DIVIDE_CAL),
        .CLKOUT3_PHASE        (0.000),
        .CLKOUT3_DUTY_CYCLE   (0.500),
        .CLKOUT3_USE_FINE_PS  ("FALSE"),
        .CLKOUT4_DIVIDE       (MMCM_CLKOUT4_DIVIDE_CAL),
        .CLKOUT4_PHASE        (0.000),
        .CLKOUT4_DUTY_CYCLE   (0.500),
        .CLKOUT4_USE_FINE_PS  ("FALSE"),
        .CLKOUT5_DIVIDE       (((MMCM_MULT_F*2)/MMCM_DIVCLK_DIVIDE)),
        .CLKOUT5_PHASE        (0.000),
        .CLKOUT5_DUTY_CYCLE   (0.500),
        .CLKOUT5_USE_FINE_PS  ("TRUE"),
        .CLKOUT6_DIVIDE       (MMCM_MULT_F/2),
        .CLKOUT6_PHASE        (0.000),
        .CLKOUT6_DUTY_CYCLE   (0.500),
        .CLKOUT6_USE_FINE_PS  ("FALSE"),
        .CLKIN1_PERIOD        (CLKOUT3_PERIOD_NS),
        .REF_JITTER1          (0.000))
      mmcm_i
        // Output clocks
       (.CLKFBOUT            (clk_pll_i),
        .CLKFBOUTB           (),
        .CLKOUT0             (mmcm_clkout0),
        .CLKOUT0B            (),
        .CLKOUT1             (mmcm_clkout1),
        .CLKOUT1B            (),
        .CLKOUT2             (mmcm_clkout2),
        .CLKOUT2B            (),
        .CLKOUT3             (mmcm_clkout3),
        .CLKOUT3B            (),
        .CLKOUT4             (mmcm_clkout4),
        .CLKOUT5             (mmcm_ps_clk_bufg_in),
        .CLKOUT6             (clk_div2_bufg_in),
         // Input clock control
        .CLKFBIN             (clk_bufg),      // From BUFH network
        .CLKIN1              (pll_clk3),      // From PLL
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
        .PSCLK               (clk),
        .PSEN                (psen),
        .PSINCDEC            (psincdec),
        .PSDONE              (psdone),
        // Other control and status signals
        .LOCKED              (MMCM_Locked_i),
        .CLKINSTOPPED        (),
        .CLKFBSTOPPED        (),
        .PWRDWN              (1'b0),
        .RST                 (~pll_locked_i));

      BUFG u_bufg_ui_addn_clk_0
        (
         .O (ui_addn_clk_0),
         .I (mmcm_clkout0)
         );

      BUFG u_bufg_ui_addn_clk_1
        (
         .O (ui_addn_clk_1),
         .I (mmcm_clkout1)
         );

      BUFG u_bufg_ui_addn_clk_2
        (
         .O (ui_addn_clk_2),
         .I (mmcm_clkout2)
         );

      BUFG u_bufg_ui_addn_clk_3
        (
         .O (ui_addn_clk_3),
         .I (mmcm_clkout3)
         );

      BUFG u_bufg_ui_addn_clk_4
        (
         .O (ui_addn_clk_4),
         .I (mmcm_clkout4)
         );

      BUFG u_bufg_mmcm_ps_clk
        (
         .O (mmcm_ps_clk),
         .I (mmcm_ps_clk_bufg_in)
         );
       
      BUFG u_bufg_clk_div2
        (
         .O (clk_div2),
         .I (clk_div2_bufg_in)
         );
    end else begin: gen_mmcm

      MMCME2_ADV
      #(.BANDWIDTH            ("HIGH"),
        .CLKOUT4_CASCADE      ("FALSE"),
        .COMPENSATION         ("BUF_IN"),
        .STARTUP_WAIT         ("FALSE"),
//        .DIVCLK_DIVIDE        (1),
        .DIVCLK_DIVIDE        (MMCM_DIVCLK_DIVIDE),
        .CLKFBOUT_MULT_F      (MMCM_MULT_F),
        .CLKFBOUT_PHASE       (0.000),
        .CLKFBOUT_USE_FINE_PS ("FALSE"),
        .CLKOUT0_DIVIDE_F     (((MMCM_MULT_F*2)/MMCM_DIVCLK_DIVIDE)),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKOUT0_USE_FINE_PS  ("TRUE"),
        .CLKOUT1_DIVIDE       (MMCM_MULT_F/2),
        .CLKOUT1_PHASE        (0.000),
        .CLKOUT1_DUTY_CYCLE   (0.500),
        .CLKOUT1_USE_FINE_PS  ("FALSE"),
        .CLKIN1_PERIOD        (CLKOUT3_PERIOD_NS),
        .REF_JITTER1          (0.000))
      mmcm_i
        // Output clocks
       (.CLKFBOUT            (clk_pll_i),
        .CLKFBOUTB           (),
        .CLKOUT0             (mmcm_ps_clk_bufg_in),
        .CLKOUT0B            (),
        .CLKOUT1             (clk_div2_bufg_in),
        .CLKOUT1B            (),
        .CLKOUT2             (),
        .CLKOUT2B            (),
        .CLKOUT3             (),
        .CLKOUT3B            (),
        .CLKOUT4             (),
        .CLKOUT5             (),
        .CLKOUT6             (),
         // Input clock control
        .CLKFBIN             (clk_bufg),      // From BUFH network
        .CLKIN1              (pll_clk3),      // From PLL
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
        .PSCLK               (clk),
        .PSEN                (psen),
        .PSINCDEC            (psincdec),
        .PSDONE              (psdone),
        // Other control and status signals
        .LOCKED              (MMCM_Locked_i),
        .CLKINSTOPPED        (),
        .CLKFBSTOPPED        (),
        .PWRDWN              (1'b0),
        .RST                 (~pll_locked_i));

    BUFG u_bufg_mmcm_ps_clk
    (
     .O (mmcm_ps_clk),
     .I (mmcm_ps_clk_bufg_in)
     );
	 
    BUFG u_bufg_clk_div2
    (
     .O (clk_div2),
     .I (clk_div2_bufg_in)
     );
	 
    end // block: gen_mmcm
  endgenerate

  //***************************************************************************
  // Generate poc_sample_pd.
  //
  // As the phase shift clocks precesses around kclk, it also precesses
  // around the fabric clock.  Noise may be generated as output of the
  // IDDR is registered into the fabric clock domain.
  //
  // The mmcm_ps_clk signal runs at half the rate of the fabric clock.
  // This means that there are two rising edges of fabric clock per mmcm_ps_clk.
  // If we can guarantee that the POC uses the data sampled on the second
  // fabric clock, then we are certain that the setup time to the second
  // fabric clock is greater than 1 fabric clock cycle.
  //
  // To predict when the phase detctor output is from this second edge, we
  // need to know two things.  The initial phase of fabric clock and mmcm_ps_clk
  // and the number of phase offsets set into the mmcm.  The later is a
  // trivial count of the PSEN signal.
  //
  // The former is a bit tricky because latching a clock with a clock is
  // not well defined.  This problem is solved by generating a signal
  // the goes high on the first rising edge of mmcm_ps_clk.  Logic in
  // the fabric domain can look at this signal and then develop an analog
  // the mmcm_ps_clk with zero offset.
  //
  // This all depends on the timing tools making the timing work when
  // when the mmcm phase offset is zero.
  //
  // poc_sample_pd tells the POC when to sample the phase detector output.
  // Setup from the IDDR to the fabric clock is always one plus some
  // fraction of the fabric clock.
  //***************************************************************************

  localparam ONE = 1;
  localparam integer TAPSPERFCLK = 56 * MMCM_MULT_F;
  localparam TAPSPERFCLK_MINUS_ONE = TAPSPERFCLK - 1;
  localparam QCNTR_WIDTH = clogb2(TAPSPERFCLK);
  
  function integer clogb2 (input integer size); // ceiling logb2
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2

  reg [QCNTR_WIDTH-1:0] qcntr_ns, qcntr_r;
  always @(posedge clk) qcntr_r <= #TCQ qcntr_ns;

  reg inv_poc_sample_ns, inv_poc_sample_r;
  always @(posedge clk) inv_poc_sample_r <= #TCQ inv_poc_sample_ns;
  
  always @(*) begin
    qcntr_ns = qcntr_r;
    inv_poc_sample_ns = inv_poc_sample_r;
    if (rstdiv0) begin
      qcntr_ns = 'b0;
      inv_poc_sample_ns = 'b0;
    end else if (psen) begin
      if (qcntr_r < TAPSPERFCLK_MINUS_ONE[QCNTR_WIDTH-1:0])
        qcntr_ns = (qcntr_r + ONE[QCNTR_WIDTH-1:0]);
      else begin
        qcntr_ns = {QCNTR_WIDTH{1'b0}};
	inv_poc_sample_ns = ~inv_poc_sample_r;
      end
    end
  end 

  // Be vewy vewy careful to make sure this path is aligned with the
  // phase detector out pipeline.  
  reg first_rising_ps_clk_ns, first_rising_ps_clk_r;
  always @(posedge mmcm_ps_clk) first_rising_ps_clk_r <= #TCQ first_rising_ps_clk_ns;
  always @(*) first_rising_ps_clk_ns = ~rstdiv0;

  reg mmcm_hi0_ns, mmcm_hi0_r;
  always @(posedge clk) mmcm_hi0_r <= #TCQ mmcm_hi0_ns;
  always @(*) mmcm_hi0_ns = ~first_rising_ps_clk_r || ~mmcm_hi0_r;

  reg poc_sample_pd_ns, poc_sample_pd_r;
  always @(*) poc_sample_pd_ns = inv_poc_sample_ns ^ mmcm_hi0_r;
  always @(posedge clk) poc_sample_pd_r <= #TCQ poc_sample_pd_ns;
  assign poc_sample_pd = poc_sample_pd_r;

  //***************************************************************************
  // Make sure logic acheives 90 degree setup time from rising mmcm_ps_clk
  // to the appropriate edge of fabric clock
  //***************************************************************************

  //synthesis translate_off
  generate 
    if ( tCK <= 2500 ) begin : check_ocal_timing
      localparam CLK_PERIOD_PS = MMCM_VCO_PERIOD * MMCM_MULT_F;
      localparam integer CLK_PERIOD_PS_DIV4 = CLK_PERIOD_PS/4;

      time rising_mmcm_ps_clk;
      always @(posedge mmcm_ps_clk) rising_mmcm_ps_clk = $time();

      time pdiff;  // Not used, except in waveform plots.
      always @(posedge clk) pdiff = $time() - rising_mmcm_ps_clk;
    end
  endgenerate

  //synthesis translate_on

  //***************************************************************************
  // RESET SYNCHRONIZATION DESCRIPTION:
  //  Various resets are generated to ensure that:
  //   1. All resets are synchronously deasserted with respect to the clock
  //      domain they are interfacing to. There are several different clock
  //      domains - each one will receive a synchronized reset.
  //   2. The reset deassertion order starts with deassertion of SYS_RST,
  //      followed by deassertion of resets for various parts of the design
  //      (see "RESET ORDER" below) based on the lock status of PLLE2s.
  // RESET ORDER:
  //   1. User deasserts SYS_RST
  //   2. Reset PLLE2 and IDELAYCTRL
  //   3. Wait for PLLE2 and IDELAYCTRL to lock
  //   4. Release reset for all I/O primitives and internal logic
  // OTHER NOTES:
  //   1. Asynchronously assert reset. This way we can assert reset even if
  //      there is no clock (needed for things like 3-stating output buffers
  //      to prevent initial bus contention). Reset deassertion is synchronous.
  //***************************************************************************

  //*****************************************************************
  // CLKDIV logic reset
  //*****************************************************************

  // Wait for PLLE2 and IDELAYCTRL to lock before releasing reset

  // current O,25.0 unisim phaser_ref never locks.  Need to find out why .
  generate
    if (MEM_TYPE == "DDR3" && tCK <= 1500) begin: rst_tmp_300_400
      assign rst_tmp = sys_rst_act_hi | ~iodelay_ctrl_rdy[1] |
                       ~ref_dll_lock | ~MMCM_Locked_i;
    end else begin: rst_tmp_200
      assign rst_tmp = sys_rst_act_hi | ~iodelay_ctrl_rdy[0] |
                       ~ref_dll_lock | ~MMCM_Locked_i;
    end
  endgenerate

  always @(posedge clk_bufg or posedge rst_tmp) begin
    if (rst_tmp) begin
      rstdiv0_sync_r  <= #TCQ {RST_DIV_SYNC_NUM-1{1'b1}};
      rstdiv0_sync_r1 <= #TCQ 1'b1 ;
    end else begin
      rstdiv0_sync_r  <= #TCQ rstdiv0_sync_r << 1;
      rstdiv0_sync_r1 <= #TCQ rstdiv0_sync_r[RST_DIV_SYNC_NUM-2];
    end
  end

  assign rstdiv0 = rstdiv0_sync_r1 ;

//IDDR rest
  always @(posedge mmcm_ps_clk  or posedge rst_tmp) begin
    if (rst_tmp) begin
      rst_sync_r  <= #TCQ {RST_DIV_SYNC_NUM-1{1'b1}};
      rst_sync_r1 <= #TCQ 1'b1 ;
    end else begin
      rst_sync_r  <= #TCQ rst_sync_r << 1;
      rst_sync_r1 <= #TCQ rst_sync_r[RST_DIV_SYNC_NUM-2];
    end
  end

  assign iddr_rst = rst_sync_r1 ;
  
// Sync reset in the clk_div2 domain
  always @(posedge clk_div2  or posedge rst_tmp) begin
    if (rst_tmp) begin
      rstdiv2_sync_r  <= #TCQ {RST_DIV_SYNC_NUM-1{1'b1}};
      rstdiv2_sync_r1 <= #TCQ 1'b1 ;
    end else begin
      rstdiv2_sync_r  <= #TCQ rstdiv2_sync_r << 1;
      rstdiv2_sync_r1 <= #TCQ rstdiv2_sync_r[RST_DIV_SYNC_NUM-2];
    end
  end

  assign rst_div2 = rstdiv2_sync_r1 ;

  generate
    if (MEM_TYPE == "DDR3" && tCK <= 1500) begin: rst_tmp_phaser_ref_300_400
      assign rst_tmp_phaser_ref = sys_rst_act_hi | ~MMCM_Locked_i | ~iodelay_ctrl_rdy[1];
    end else begin: rst_tmp_phaser_ref_200
      assign rst_tmp_phaser_ref = sys_rst_act_hi | ~MMCM_Locked_i | ~iodelay_ctrl_rdy[0];
    end
  endgenerate

  always @(posedge clk_bufg or posedge rst_tmp_phaser_ref)
    if (rst_tmp_phaser_ref)
      rst_phaser_ref_sync_r <= #TCQ {RST_DIV_SYNC_NUM{1'b1}};
    else
      rst_phaser_ref_sync_r <= #TCQ rst_phaser_ref_sync_r << 1;

  assign rst_phaser_ref = rst_phaser_ref_sync_r[RST_DIV_SYNC_NUM-1];

endmodule

