///////////////////////////////////////////////////////
//  Copyright (c) 2008 Xilinx Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   / 
// /___/  \  /     Vendor      : Xilinx 
// \  \    \/      Version     : 12.i (O.4)
//  \  \           Description : 
//  /  /                      
// /__/   /\       Filename    : PLLE2_BASE.v
// \  \  /  \ 
//  \__\/\__ \                    
//                                 
//  Revision:		1.0
//    12/09/09 - Initial version 
//    03/23/10 - Change CLKFBOUT_MULT default from 1 to 5.
///////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

`celldefine

module PLLE2_BASE (
  CLKFBOUT,
  CLKOUT0,
  CLKOUT1,
  CLKOUT2,
  CLKOUT3,
  CLKOUT4,
  CLKOUT5,
  LOCKED,
  CLKFBIN,
  CLKIN1,
  PWRDWN,
  RST
);

  parameter BANDWIDTH = "OPTIMIZED";
  parameter integer CLKFBOUT_MULT = 5;
  parameter real CLKFBOUT_PHASE = 0.000;
  parameter real CLKIN1_PERIOD = 0.000;
  parameter integer CLKOUT0_DIVIDE = 1;
  parameter real CLKOUT0_DUTY_CYCLE = 0.500;
  parameter real CLKOUT0_PHASE = 0.000;
  parameter integer CLKOUT1_DIVIDE = 1;
  parameter real CLKOUT1_DUTY_CYCLE = 0.500;
  parameter real CLKOUT1_PHASE = 0.000;
  parameter integer CLKOUT2_DIVIDE = 1;
  parameter real CLKOUT2_DUTY_CYCLE = 0.500;
  parameter real CLKOUT2_PHASE = 0.000;
  parameter integer CLKOUT3_DIVIDE = 1;
  parameter real CLKOUT3_DUTY_CYCLE = 0.500;
  parameter real CLKOUT3_PHASE = 0.000;
  parameter integer CLKOUT4_DIVIDE = 1;
  parameter real CLKOUT4_DUTY_CYCLE = 0.500;
  parameter real CLKOUT4_PHASE = 0.000;
  parameter integer CLKOUT5_DIVIDE = 1;
  parameter real CLKOUT5_DUTY_CYCLE = 0.500;
  parameter real CLKOUT5_PHASE = 0.000;
  parameter integer DIVCLK_DIVIDE = 1;
  parameter real REF_JITTER1 = 0.010;
  parameter STARTUP_WAIT = "FALSE";

  `ifdef XIL_TIMING

    parameter LOC = "UNPLACED";

  `endif //

  output CLKFBOUT;
  output CLKOUT0;
  output CLKOUT1;
  output CLKOUT2;
  output CLKOUT3;
  output CLKOUT4;
  output CLKOUT5;
  output LOCKED;

  input CLKFBIN;
  input CLKIN1;
  input PWRDWN;
  input RST;

  wire OPEN_DRDY;
  wire OPEN_PSDONE;
  wire OPEN_FBS;
  wire OPEN_INS;
  wire [15:0] OPEN_DO;

  PLLE2_ADV #(
            .BANDWIDTH(BANDWIDTH),
            .STARTUP_WAIT(STARTUP_WAIT),
            .CLKOUT1_DIVIDE(CLKOUT1_DIVIDE),
            .CLKOUT2_DIVIDE(CLKOUT2_DIVIDE),
            .CLKOUT3_DIVIDE(CLKOUT3_DIVIDE),
            .CLKOUT4_DIVIDE(CLKOUT4_DIVIDE),
            .CLKOUT5_DIVIDE(CLKOUT5_DIVIDE),
            .DIVCLK_DIVIDE(DIVCLK_DIVIDE),
            .CLKFBOUT_MULT(CLKFBOUT_MULT),
            .CLKFBOUT_PHASE(CLKFBOUT_PHASE),
            .CLKIN1_PERIOD(CLKIN1_PERIOD),
            .CLKIN2_PERIOD(10),
            .CLKOUT0_DIVIDE(CLKOUT0_DIVIDE),
            .CLKOUT0_DUTY_CYCLE(CLKOUT0_DUTY_CYCLE),
            .CLKOUT0_PHASE(CLKOUT0_PHASE),
            .CLKOUT1_DUTY_CYCLE(CLKOUT1_DUTY_CYCLE),
            .CLKOUT1_PHASE(CLKOUT1_PHASE),
            .CLKOUT2_DUTY_CYCLE(CLKOUT2_DUTY_CYCLE),
            .CLKOUT2_PHASE(CLKOUT2_PHASE),
            .CLKOUT3_DUTY_CYCLE(CLKOUT3_DUTY_CYCLE),
            .CLKOUT3_PHASE(CLKOUT3_PHASE),
            .CLKOUT4_DUTY_CYCLE(CLKOUT4_DUTY_CYCLE),
            .CLKOUT4_PHASE(CLKOUT4_PHASE),
            .CLKOUT5_DUTY_CYCLE(CLKOUT5_DUTY_CYCLE),
            .CLKOUT5_PHASE(CLKOUT5_PHASE),
            .REF_JITTER1(REF_JITTER1) 
      )
      plle2_adv_1 (
        .CLKFBIN (CLKFBIN),
        .CLKFBOUT (CLKFBOUT),
        .CLKIN1 (CLKIN1),
        .CLKIN2 (1'b0),
        .CLKOUT0 (CLKOUT0),
        .CLKOUT1 (CLKOUT1),
        .CLKOUT2 (CLKOUT2),
        .CLKOUT3 (CLKOUT3),
        .CLKOUT4 (CLKOUT4),
        .CLKOUT5 (CLKOUT5),
        .DADDR (7'b0),
        .DCLK (1'b0),
        .DEN (1'b0),
        .DI (16'b0),
        .DO (OPEN_DO),
        .DRDY (OPEN_DRDY),
        .DWE (1'b0),
        .LOCKED (LOCKED),
        .CLKINSEL(1'b1),
        .PWRDWN(PWRDWN),
        .RST (RST)
    );

endmodule

`endcelldefine
