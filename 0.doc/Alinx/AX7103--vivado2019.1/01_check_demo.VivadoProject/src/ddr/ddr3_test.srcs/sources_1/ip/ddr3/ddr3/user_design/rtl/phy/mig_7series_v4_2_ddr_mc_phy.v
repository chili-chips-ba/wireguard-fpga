/***********************************************************
-- (c) Copyright 2010 - 2014 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). A Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

//
//
//  Owner:        Gary Martin
//  Revision:     $Id: //depot/icm/proj/common/head/rtl/v32_cmt/rtl/phy/mc_phy.v#5 $
//                $Author: gary $
//                $DateTime: 2010/05/11 18:05:17 $
//                $Change: 490882 $
//  Description:
//    This verilog file is a parameterizable wrapper instantiating
//    up to 5 memory banks of 4-lane phy primitives. There
//    There are always 2 control banks leaving 18 lanes for data.
//
//  History:
//  Date        Engineer    Description
//  04/01/2010  G. Martin   Initial Checkin.
//
////////////////////////////////////////////////////////////
***********************************************************/


`timescale 1ps/1ps

module mig_7series_v4_2_ddr_mc_phy
 #(
// five fields, one per possible I/O bank, 4 bits in each field, 1 per lane data=1/ctl=0
      parameter        BYTE_LANES_B0                 = 4'b1111,
      parameter        BYTE_LANES_B1                 = 4'b0000,
      parameter        BYTE_LANES_B2                 = 4'b0000,
      parameter        BYTE_LANES_B3                 = 4'b0000,
      parameter        BYTE_LANES_B4                 = 4'b0000,
      parameter        DATA_CTL_B0                   = 4'hc,
      parameter        DATA_CTL_B1                   = 4'hf,
      parameter        DATA_CTL_B2                   = 4'hf,
      parameter        DATA_CTL_B3                   = 4'hf,
      parameter        DATA_CTL_B4                   = 4'hf,
      parameter        RCLK_SELECT_BANK              = 0,
      parameter        RCLK_SELECT_LANE              = "B",
      parameter        RCLK_SELECT_EDGE              = 4'b1111,
      parameter        GENERATE_DDR_CK_MAP           = "0B",
      parameter        BYTELANES_DDR_CK              = 72'h00_0000_0000_0000_0002,
      parameter        USE_PRE_POST_FIFO             = "TRUE",
      parameter        SYNTHESIS                     = "FALSE",
      parameter        PO_CTL_COARSE_BYPASS          = "FALSE",
      parameter        PI_SEL_CLK_OFFSET             = 6,

      parameter        PHYCTL_CMD_FIFO               = "FALSE",
      parameter        PHY_CLK_RATIO                 = 4,          // phy to controller divide ratio

// common to all i/o banks
      parameter        PHY_FOUR_WINDOW_CLOCKS        = 63,
      parameter        PHY_EVENTS_DELAY              = 18,
      parameter        PHY_COUNT_EN                  = "TRUE",
      parameter        PHY_SYNC_MODE                 = "TRUE",
      parameter        PHY_DISABLE_SEQ_MATCH         = "FALSE",
      parameter        MASTER_PHY_CTL                = 0,
// common to instance 0
      parameter        PHY_0_BITLANES                = 48'hdffd_fffe_dfff,
      parameter        PHY_0_BITLANES_OUTONLY        = 48'h0000_0000_0000,
      parameter        PHY_0_LANE_REMAP              = 16'h3210,
      parameter        PHY_0_GENERATE_IDELAYCTRL     = "FALSE",
      parameter        PHY_0_IODELAY_GRP             = "IODELAY_MIG",
      parameter        FPGA_SPEED_GRADE              = 1,
      parameter        BANK_TYPE                     = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
      parameter        NUM_DDR_CK                    = 1,
      parameter        PHY_0_DATA_CTL                = DATA_CTL_B0,
      parameter        PHY_0_CMD_OFFSET              = 0,
      parameter        PHY_0_RD_CMD_OFFSET_0         = 0,
      parameter        PHY_0_RD_CMD_OFFSET_1         = 0,
      parameter        PHY_0_RD_CMD_OFFSET_2         = 0,
      parameter        PHY_0_RD_CMD_OFFSET_3         = 0,
      parameter        PHY_0_RD_DURATION_0           = 0,
      parameter        PHY_0_RD_DURATION_1           = 0,
      parameter        PHY_0_RD_DURATION_2           = 0,
      parameter        PHY_0_RD_DURATION_3           = 0,
      parameter        PHY_0_WR_CMD_OFFSET_0         = 0,
      parameter        PHY_0_WR_CMD_OFFSET_1         = 0,
      parameter        PHY_0_WR_CMD_OFFSET_2         = 0,
      parameter        PHY_0_WR_CMD_OFFSET_3         = 0,
      parameter        PHY_0_WR_DURATION_0           = 0,
      parameter        PHY_0_WR_DURATION_1           = 0,
      parameter        PHY_0_WR_DURATION_2           = 0,
      parameter        PHY_0_WR_DURATION_3           = 0,
      parameter        PHY_0_AO_WRLVL_EN             = 0,
      parameter        PHY_0_AO_TOGGLE               = 4'b0101, // odd bits are toggle (CKE)
      parameter        PHY_0_OF_ALMOST_FULL_VALUE    = 1,
      parameter        PHY_0_IF_ALMOST_EMPTY_VALUE   = 1,
// per lane parameters
      parameter        PHY_0_A_PI_FREQ_REF_DIV       = "NONE",
      parameter        PHY_0_A_PI_CLKOUT_DIV         = 2,
      parameter        PHY_0_A_PO_CLKOUT_DIV         = 2,
      parameter        PHY_0_A_BURST_MODE            = "TRUE",
      parameter        PHY_0_A_PI_OUTPUT_CLK_SRC     = "DELAYED_REF",
      parameter        PHY_0_A_PO_OUTPUT_CLK_SRC     = "DELAYED_REF",
      parameter        PHY_0_A_PO_OCLK_DELAY         = 25,
      parameter        PHY_0_B_PO_OCLK_DELAY         = PHY_0_A_PO_OCLK_DELAY,
      parameter        PHY_0_C_PO_OCLK_DELAY         = PHY_0_A_PO_OCLK_DELAY,
      parameter        PHY_0_D_PO_OCLK_DELAY         = PHY_0_A_PO_OCLK_DELAY,
      parameter        PHY_0_A_PO_OCLKDELAY_INV      = "FALSE",
      parameter        PHY_0_A_OF_ARRAY_MODE         = "ARRAY_MODE_8_X_4",
      parameter        PHY_0_B_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_C_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_D_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_A_IF_ARRAY_MODE         = "ARRAY_MODE_8_X_4",
      parameter        PHY_0_B_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_C_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_D_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_0_A_OSERDES_DATA_RATE     = "UNDECLARED",
      parameter        PHY_0_A_OSERDES_DATA_WIDTH    = "UNDECLARED",
      parameter        PHY_0_B_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_0_B_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_0_C_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_0_C_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_0_D_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_0_D_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_0_A_IDELAYE2_IDELAY_TYPE  = "VARIABLE",
      parameter        PHY_0_A_IDELAYE2_IDELAY_VALUE = 00,
      parameter        PHY_0_B_IDELAYE2_IDELAY_TYPE  = PHY_0_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_0_B_IDELAYE2_IDELAY_VALUE = PHY_0_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_0_C_IDELAYE2_IDELAY_TYPE  = PHY_0_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_0_C_IDELAYE2_IDELAY_VALUE = PHY_0_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_0_D_IDELAYE2_IDELAY_TYPE  = PHY_0_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_0_D_IDELAYE2_IDELAY_VALUE = PHY_0_A_IDELAYE2_IDELAY_VALUE,

// common to instance 1
      parameter        PHY_1_BITLANES                = PHY_0_BITLANES,
      parameter        PHY_1_BITLANES_OUTONLY        = 48'h0000_0000_0000,
      parameter        PHY_1_LANE_REMAP              = 16'h3210,
      parameter        PHY_1_GENERATE_IDELAYCTRL     =  "FALSE",
      parameter        PHY_1_IODELAY_GRP             = PHY_0_IODELAY_GRP,
      parameter        PHY_1_DATA_CTL                = DATA_CTL_B1,
      parameter        PHY_1_CMD_OFFSET              = PHY_0_CMD_OFFSET,
      parameter        PHY_1_RD_CMD_OFFSET_0         = PHY_0_RD_CMD_OFFSET_0,
      parameter        PHY_1_RD_CMD_OFFSET_1         = PHY_0_RD_CMD_OFFSET_1,
      parameter        PHY_1_RD_CMD_OFFSET_2         = PHY_0_RD_CMD_OFFSET_2,
      parameter        PHY_1_RD_CMD_OFFSET_3         = PHY_0_RD_CMD_OFFSET_3,
      parameter        PHY_1_RD_DURATION_0           = PHY_0_RD_DURATION_0,
      parameter        PHY_1_RD_DURATION_1           = PHY_0_RD_DURATION_1,
      parameter        PHY_1_RD_DURATION_2           = PHY_0_RD_DURATION_2,
      parameter        PHY_1_RD_DURATION_3           = PHY_0_RD_DURATION_3,
      parameter        PHY_1_WR_CMD_OFFSET_0         = PHY_0_WR_CMD_OFFSET_0,
      parameter        PHY_1_WR_CMD_OFFSET_1         = PHY_0_WR_CMD_OFFSET_1,
      parameter        PHY_1_WR_CMD_OFFSET_2         = PHY_0_WR_CMD_OFFSET_2,
      parameter        PHY_1_WR_CMD_OFFSET_3         = PHY_0_WR_CMD_OFFSET_3,
      parameter        PHY_1_WR_DURATION_0           = PHY_0_WR_DURATION_0,
      parameter        PHY_1_WR_DURATION_1           = PHY_0_WR_DURATION_1,
      parameter        PHY_1_WR_DURATION_2           = PHY_0_WR_DURATION_2,
      parameter        PHY_1_WR_DURATION_3           = PHY_0_WR_DURATION_3,
      parameter        PHY_1_AO_WRLVL_EN             = PHY_0_AO_WRLVL_EN,
      parameter        PHY_1_AO_TOGGLE               = PHY_0_AO_TOGGLE, // odd bits are toggle (CKE)
      parameter        PHY_1_OF_ALMOST_FULL_VALUE    = 1,
      parameter        PHY_1_IF_ALMOST_EMPTY_VALUE   = 1,
// per lane parameters
      parameter        PHY_1_A_PI_FREQ_REF_DIV       = PHY_0_A_PI_FREQ_REF_DIV,
      parameter        PHY_1_A_PI_CLKOUT_DIV         = PHY_0_A_PI_CLKOUT_DIV,
      parameter        PHY_1_A_PO_CLKOUT_DIV         = PHY_0_A_PO_CLKOUT_DIV,
      parameter        PHY_1_A_BURST_MODE            = PHY_0_A_BURST_MODE,
      parameter        PHY_1_A_PI_OUTPUT_CLK_SRC     = PHY_0_A_PI_OUTPUT_CLK_SRC,
      parameter        PHY_1_A_PO_OUTPUT_CLK_SRC     = PHY_0_A_PO_OUTPUT_CLK_SRC ,
      parameter        PHY_1_A_PO_OCLK_DELAY         = PHY_0_A_PO_OCLK_DELAY,
      parameter        PHY_1_B_PO_OCLK_DELAY         = PHY_1_A_PO_OCLK_DELAY,
      parameter        PHY_1_C_PO_OCLK_DELAY         = PHY_1_A_PO_OCLK_DELAY,
      parameter        PHY_1_D_PO_OCLK_DELAY         = PHY_1_A_PO_OCLK_DELAY,
      parameter        PHY_1_A_PO_OCLKDELAY_INV      = PHY_0_A_PO_OCLKDELAY_INV,
      parameter        PHY_1_A_IDELAYE2_IDELAY_TYPE  = PHY_0_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_1_A_IDELAYE2_IDELAY_VALUE = PHY_0_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_1_B_IDELAYE2_IDELAY_TYPE  = PHY_1_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_1_B_IDELAYE2_IDELAY_VALUE = PHY_1_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_1_C_IDELAYE2_IDELAY_TYPE  = PHY_1_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_1_C_IDELAYE2_IDELAY_VALUE = PHY_1_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_1_D_IDELAYE2_IDELAY_TYPE  = PHY_1_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_1_D_IDELAYE2_IDELAY_VALUE = PHY_1_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_1_A_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_B_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_C_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_D_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_A_IF_ARRAY_MODE         = PHY_0_A_IF_ARRAY_MODE,
      parameter        PHY_1_B_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_C_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_D_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_1_A_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_1_A_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_1_B_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_1_B_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_1_C_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_1_C_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_1_D_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_1_D_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,

// common to instance 2
      parameter        PHY_2_BITLANES                = PHY_0_BITLANES,
      parameter        PHY_2_BITLANES_OUTONLY        = 48'h0000_0000_0000,
      parameter        PHY_2_LANE_REMAP              = 16'h3210,
      parameter        PHY_2_GENERATE_IDELAYCTRL     =  "FALSE",
      parameter        PHY_2_IODELAY_GRP             = PHY_0_IODELAY_GRP,
      parameter        PHY_2_DATA_CTL                = DATA_CTL_B2,
      parameter        PHY_2_CMD_OFFSET              = PHY_0_CMD_OFFSET,
      parameter        PHY_2_RD_CMD_OFFSET_0         = PHY_0_RD_CMD_OFFSET_0,
      parameter        PHY_2_RD_CMD_OFFSET_1         = PHY_0_RD_CMD_OFFSET_1,
      parameter        PHY_2_RD_CMD_OFFSET_2         = PHY_0_RD_CMD_OFFSET_2,
      parameter        PHY_2_RD_CMD_OFFSET_3         = PHY_0_RD_CMD_OFFSET_3,
      parameter        PHY_2_RD_DURATION_0           = PHY_0_RD_DURATION_0,
      parameter        PHY_2_RD_DURATION_1           = PHY_0_RD_DURATION_1,
      parameter        PHY_2_RD_DURATION_2           = PHY_0_RD_DURATION_2,
      parameter        PHY_2_RD_DURATION_3           = PHY_0_RD_DURATION_3,
      parameter        PHY_2_WR_CMD_OFFSET_0         = PHY_0_WR_CMD_OFFSET_0,
      parameter        PHY_2_WR_CMD_OFFSET_1         = PHY_0_WR_CMD_OFFSET_1,
      parameter        PHY_2_WR_CMD_OFFSET_2         = PHY_0_WR_CMD_OFFSET_2,
      parameter        PHY_2_WR_CMD_OFFSET_3         = PHY_0_WR_CMD_OFFSET_3,
      parameter        PHY_2_WR_DURATION_0           = PHY_0_WR_DURATION_0,
      parameter        PHY_2_WR_DURATION_1           = PHY_0_WR_DURATION_1,
      parameter        PHY_2_WR_DURATION_2           = PHY_0_WR_DURATION_2,
      parameter        PHY_2_WR_DURATION_3           = PHY_0_WR_DURATION_3,
      parameter        PHY_2_AO_WRLVL_EN             = PHY_0_AO_WRLVL_EN,
      parameter        PHY_2_AO_TOGGLE               = PHY_0_AO_TOGGLE, // odd bits are toggle (CKE)
      parameter        PHY_2_OF_ALMOST_FULL_VALUE    = 1,
      parameter        PHY_2_IF_ALMOST_EMPTY_VALUE   = 1,
// per lane parameters
      parameter        PHY_2_A_PI_FREQ_REF_DIV       = PHY_0_A_PI_FREQ_REF_DIV,
      parameter        PHY_2_A_PI_CLKOUT_DIV         = PHY_0_A_PI_CLKOUT_DIV ,
      parameter        PHY_2_A_PO_CLKOUT_DIV         = PHY_0_A_PO_CLKOUT_DIV,
      parameter        PHY_2_A_BURST_MODE            = PHY_0_A_BURST_MODE ,
      parameter        PHY_2_A_PI_OUTPUT_CLK_SRC     = PHY_0_A_PI_OUTPUT_CLK_SRC,
      parameter        PHY_2_A_PO_OUTPUT_CLK_SRC     = PHY_0_A_PO_OUTPUT_CLK_SRC,
      parameter        PHY_2_A_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_B_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_C_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_D_OF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_A_IF_ARRAY_MODE         = PHY_0_A_IF_ARRAY_MODE,
      parameter        PHY_2_B_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_C_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_D_IF_ARRAY_MODE         = PHY_0_A_OF_ARRAY_MODE,
      parameter        PHY_2_A_PO_OCLK_DELAY         = PHY_0_A_PO_OCLK_DELAY,
      parameter        PHY_2_B_PO_OCLK_DELAY         = PHY_2_A_PO_OCLK_DELAY,
      parameter        PHY_2_C_PO_OCLK_DELAY         = PHY_2_A_PO_OCLK_DELAY,
      parameter        PHY_2_D_PO_OCLK_DELAY         = PHY_2_A_PO_OCLK_DELAY,
      parameter        PHY_2_A_PO_OCLKDELAY_INV      = PHY_0_A_PO_OCLKDELAY_INV,
      parameter        PHY_2_A_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_2_A_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_2_B_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_2_B_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_2_C_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_2_C_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_2_D_OSERDES_DATA_RATE     = PHY_0_A_OSERDES_DATA_RATE,
      parameter        PHY_2_D_OSERDES_DATA_WIDTH    = PHY_0_A_OSERDES_DATA_WIDTH,
      parameter        PHY_2_A_IDELAYE2_IDELAY_TYPE  = PHY_0_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_2_A_IDELAYE2_IDELAY_VALUE = PHY_0_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_2_B_IDELAYE2_IDELAY_TYPE  = PHY_2_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_2_B_IDELAYE2_IDELAY_VALUE = PHY_2_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_2_C_IDELAYE2_IDELAY_TYPE  = PHY_2_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_2_C_IDELAYE2_IDELAY_VALUE = PHY_2_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_2_D_IDELAYE2_IDELAY_TYPE  = PHY_2_A_IDELAYE2_IDELAY_TYPE,
      parameter        PHY_2_D_IDELAYE2_IDELAY_VALUE = PHY_2_A_IDELAYE2_IDELAY_VALUE,
      parameter        PHY_0_IS_LAST_BANK   = ((BYTE_LANES_B1 != 0) || (BYTE_LANES_B2 != 0) || (BYTE_LANES_B3 != 0) || (BYTE_LANES_B4 != 0)) ?  "FALSE" : "TRUE",
      parameter        PHY_1_IS_LAST_BANK   = ((BYTE_LANES_B1 != 0) && ((BYTE_LANES_B2 != 0) || (BYTE_LANES_B3 != 0) || (BYTE_LANES_B4 != 0))) ?  "FALSE" : ((PHY_0_IS_LAST_BANK) ? "FALSE" : "TRUE"),
      parameter        PHY_2_IS_LAST_BANK   = (BYTE_LANES_B2 != 0) && ((BYTE_LANES_B3 != 0) || (BYTE_LANES_B4 != 0)) ?  "FALSE" : ((PHY_0_IS_LAST_BANK || PHY_1_IS_LAST_BANK) ? "FALSE" : "TRUE"),
      parameter        TCK = 2500,

// local computational use, do not pass down
      parameter        N_LANES = (0+BYTE_LANES_B0[0]) + (0+BYTE_LANES_B0[1]) + (0+BYTE_LANES_B0[2]) + (0+BYTE_LANES_B0[3])
      +  (0+BYTE_LANES_B1[0]) + (0+BYTE_LANES_B1[1]) + (0+BYTE_LANES_B1[2]) + (0+BYTE_LANES_B1[3])  + (0+BYTE_LANES_B2[0]) + (0+BYTE_LANES_B2[1]) + (0+BYTE_LANES_B2[2]) + (0+BYTE_LANES_B2[3])
      ,  // must not delete comma for syntax
      parameter HIGHEST_BANK = (BYTE_LANES_B4 != 0 ? 5 : (BYTE_LANES_B3 != 0 ? 4 : (BYTE_LANES_B2 != 0 ? 3 :  (BYTE_LANES_B1 != 0  ? 2 : 1)))),
      parameter HIGHEST_LANE_B0  =   ((PHY_0_IS_LAST_BANK == "FALSE") ? 4 : BYTE_LANES_B0[3] ? 4 : BYTE_LANES_B0[2] ? 3 : BYTE_LANES_B0[1] ? 2 : BYTE_LANES_B0[0] ? 1 : 0)  ,
      parameter HIGHEST_LANE_B1  = (HIGHEST_BANK > 2) ? 4 : ( BYTE_LANES_B1[3] ? 4 : BYTE_LANES_B1[2] ? 3 : BYTE_LANES_B1[1] ? 2 : BYTE_LANES_B1[0] ? 1 : 0) ,
      parameter HIGHEST_LANE_B2  = (HIGHEST_BANK > 3) ? 4 : ( BYTE_LANES_B2[3] ? 4 : BYTE_LANES_B2[2] ? 3 : BYTE_LANES_B2[1] ? 2 : BYTE_LANES_B2[0] ? 1 : 0) ,
      parameter HIGHEST_LANE_B3  = 0,
      parameter HIGHEST_LANE_B4  = 0,

      parameter HIGHEST_LANE = (HIGHEST_LANE_B4 != 0) ? (HIGHEST_LANE_B4+16) : ((HIGHEST_LANE_B3 != 0) ? (HIGHEST_LANE_B3 + 12) : ((HIGHEST_LANE_B2 != 0) ? (HIGHEST_LANE_B2 + 8)  : ((HIGHEST_LANE_B1 != 0) ? (HIGHEST_LANE_B1 + 4) : HIGHEST_LANE_B0))),
      parameter LP_DDR_CK_WIDTH = 2,
      parameter GENERATE_SIGNAL_SPLIT = "FALSE"
      ,parameter CKE_ODT_AUX = "FALSE"
      ,parameter PI_DIV2_INCDEC = "FALSE"
 )
 (
      input            rst,
      input            ddr_rst_in_n ,
      input            phy_clk,
      input            clk_div2,
      input            freq_refclk,
      input            mem_refclk,
      input            mem_refclk_div4,
      input            pll_lock,
      input            sync_pulse,
      input            auxout_clk,
      input            idelayctrl_refclk,
      input [HIGHEST_LANE*80-1:0]    phy_dout,
      input            phy_cmd_wr_en,
      input            phy_data_wr_en,
      input            phy_rd_en,
      input [31:0]     phy_ctl_wd,
      input [3:0]      aux_in_1,
      input [3:0]      aux_in_2,
      input [5:0]      data_offset_1,
      input [5:0]      data_offset_2,
      input            phy_ctl_wr,
      input            if_rst,
      input            if_empty_def,
      input            cke_in,
      input            idelay_ce,
      input            idelay_ld,
      input            idelay_inc,
      input            phyGo,
      input            input_sink,
      output           if_a_empty,
      output           if_empty /* synthesis syn_maxfan = 3 */,
      output           if_empty_or,
      output           if_empty_and,
      output           of_ctl_a_full,
      output           of_data_a_full,
      output           of_ctl_full,
      output           of_data_full,
      output           pre_data_a_full,
      output [HIGHEST_LANE*80-1:0]   phy_din,
      output           phy_ctl_a_full,
      output wire [3:0]      phy_ctl_full,
      output [HIGHEST_LANE*12-1:0] mem_dq_out,
      output [HIGHEST_LANE*12-1:0] mem_dq_ts,
      input  [HIGHEST_LANE*10-1:0] mem_dq_in,
      output [HIGHEST_LANE-1:0]    mem_dqs_out,
      output [HIGHEST_LANE-1:0]    mem_dqs_ts,
      input  [HIGHEST_LANE-1:0]    mem_dqs_in,

(* IOB = "FORCE" *) output reg [(((HIGHEST_LANE+3)/4)*4)-1:0] aux_out, // to memory, odt ,  4 per phy controller
      output           phy_ctl_ready,          // to fabric
      output reg       rst_out,                // to memory
      output [(NUM_DDR_CK * LP_DDR_CK_WIDTH)-1:0]  ddr_clk,
//      output           rclk,
      output           mcGo,
      output           ref_dll_lock,
// calibration signals
      input            phy_write_calib,
      input            phy_read_calib,
      input  [5:0]     calib_sel,
      input  [HIGHEST_BANK-1:0]calib_zero_inputs, // bit calib_sel[2], one per bank
      input  [HIGHEST_BANK-1:0]calib_zero_ctrl,  // one  bit per bank, zero's only control lane calibration inputs
      input  [HIGHEST_LANE-1:0] calib_zero_lanes, // one bit per lane
      input            calib_in_common,
      input  [2:0]     po_fine_enable,
      input  [2:0]     po_coarse_enable,
      input  [2:0]     po_fine_inc,
      input  [2:0]     po_coarse_inc,
      input            po_counter_load_en,
      input  [2:0]     po_sel_fine_oclk_delay,
      input  [8:0]     po_counter_load_val,
      input            po_counter_read_en,
      output reg       po_coarse_overflow,
      output reg       po_fine_overflow,
      output reg [8:0] po_counter_read_val,


      input [HIGHEST_BANK-1:0] pi_rst_dqs_find,
      input            pi_fine_enable,
      input            pi_fine_inc,
      input            pi_counter_load_en,
      input            pi_counter_read_en,
      input  [5:0]     pi_counter_load_val,
      output reg       pi_fine_overflow,
      output reg [5:0] pi_counter_read_val,

      output reg       pi_phase_locked,
      output           pi_phase_locked_all,
      output reg       pi_dqs_found,
      output           pi_dqs_found_all,
      output           pi_dqs_found_any,
      output [HIGHEST_LANE-1:0] pi_phase_locked_lanes,
      output [HIGHEST_LANE-1:0] pi_dqs_found_lanes,
      output reg       pi_dqs_out_of_range,
      input [29:0]     fine_delay,
      input            fine_delay_sel
 );


wire  [7:0]     calib_zero_inputs_int ;
wire  [HIGHEST_BANK*4-1:0]     calib_zero_lanes_int ;

//Added the temporary variable for concadination operation
wire  [2:0]     calib_sel_byte0 ;
wire  [2:0]     calib_sel_byte1 ;
wire  [2:0]     calib_sel_byte2 ;

wire  [4:0]     po_coarse_overflow_w;
wire  [4:0]     po_fine_overflow_w;
wire  [8:0]     po_counter_read_val_w[4:0];
wire  [4:0]     pi_fine_overflow_w;
wire  [5:0]     pi_counter_read_val_w[4:0];
wire  [4:0]     pi_dqs_found_w;
wire  [4:0]     pi_dqs_found_all_w;
wire  [4:0]     pi_dqs_found_any_w;
wire  [4:0]     pi_dqs_out_of_range_w;
wire  [4:0]     pi_phase_locked_w;
wire  [4:0]     pi_phase_locked_all_w;
wire  [4:0]     rclk_w;
wire  [HIGHEST_BANK-1:0]     phy_ctl_ready_w;
wire  [(LP_DDR_CK_WIDTH*24)-1:0]     ddr_clk_w [HIGHEST_BANK-1:0];
wire  [(((HIGHEST_LANE+3)/4)*4)-1:0] aux_out_;


wire [3:0]    if_q0;
wire [3:0]    if_q1;
wire [3:0]    if_q2;
wire [3:0]    if_q3;
wire [3:0]    if_q4;
wire [7:0]    if_q5;
wire [7:0]    if_q6;
wire [3:0]    if_q7;
wire [3:0]    if_q8;
wire [3:0]    if_q9;

wire [31:0]   _phy_ctl_wd;
wire [3:0]    aux_in_[4:1];
wire [3:0]    rst_out_w;

wire           freq_refclk_split;
wire           mem_refclk_split;
wire           mem_refclk_div4_split;
wire           sync_pulse_split;
wire           phy_clk_split0;
wire           phy_ctl_clk_split0;
wire  [31:0]   phy_ctl_wd_split0;
wire           phy_ctl_wr_split0;
wire           phy_ctl_clk_split1;
wire           phy_clk_split1;
wire  [31:0]   phy_ctl_wd_split1;
wire           phy_ctl_wr_split1;
wire  [5:0]    phy_data_offset_1_split1;
wire           phy_ctl_clk_split2;
wire           phy_clk_split2;
wire  [31:0]   phy_ctl_wd_split2;
wire           phy_ctl_wr_split2;
wire  [5:0]    phy_data_offset_2_split2;
wire  [HIGHEST_LANE*80-1:0] phy_dout_split0;
wire           phy_cmd_wr_en_split0;
wire           phy_data_wr_en_split0;
wire           phy_rd_en_split0;
wire  [HIGHEST_LANE*80-1:0] phy_dout_split1;
wire           phy_cmd_wr_en_split1;
wire           phy_data_wr_en_split1;
wire           phy_rd_en_split1;
wire  [HIGHEST_LANE*80-1:0] phy_dout_split2;
wire           phy_cmd_wr_en_split2;
wire           phy_data_wr_en_split2;
wire           phy_rd_en_split2;

wire          phy_ctl_mstr_empty;
wire  [HIGHEST_BANK-1:0] phy_ctl_empty;

wire          _phy_ctl_a_full_f;
wire          _phy_ctl_a_empty_f;
wire          _phy_ctl_full_f;
wire          _phy_ctl_empty_f;
wire  [HIGHEST_BANK-1:0] _phy_ctl_a_full_p;
wire  [HIGHEST_BANK-1:0] _phy_ctl_full_p;
wire  [HIGHEST_BANK-1:0]  of_ctl_a_full_v;
wire  [HIGHEST_BANK-1:0]  of_ctl_full_v;
wire  [HIGHEST_BANK-1:0]  of_data_a_full_v;
wire  [HIGHEST_BANK-1:0]  of_data_full_v;
wire  [HIGHEST_BANK-1:0]  pre_data_a_full_v;
wire  [HIGHEST_BANK-1:0]  if_empty_v;
wire  [HIGHEST_BANK-1:0]  byte_rd_en_v;
wire  [HIGHEST_BANK*2-1:0]  byte_rd_en_oth_banks;
wire  [HIGHEST_BANK-1:0]  if_empty_or_v;
wire  [HIGHEST_BANK-1:0]  if_empty_and_v;
wire  [HIGHEST_BANK-1:0]  if_a_empty_v;

localparam IF_ARRAY_MODE         = "ARRAY_MODE_4_X_4";
localparam IF_SYNCHRONOUS_MODE   = "FALSE";
localparam IF_SLOW_WR_CLK        = "FALSE";
localparam IF_SLOW_RD_CLK        = "FALSE";

localparam PHY_MULTI_REGION      = (HIGHEST_BANK > 1) ? "TRUE" : "FALSE";
localparam RCLK_NEG_EDGE         = 3'b000;
localparam RCLK_POS_EDGE         = 3'b111;

localparam LP_PHY_0_BYTELANES_DDR_CK     =  BYTELANES_DDR_CK & 24'hFF_FFFF;
localparam LP_PHY_1_BYTELANES_DDR_CK     = (BYTELANES_DDR_CK >> 24) & 24'hFF_FFFF;
localparam LP_PHY_2_BYTELANES_DDR_CK     = (BYTELANES_DDR_CK >> 48) & 24'hFF_FFFF;

// hi, lo positions for data offset field, MIG doesn't allow defines
localparam PC_DATA_OFFSET_RANGE_HI    = 22;
localparam PC_DATA_OFFSET_RANGE_LO    = 17;

/* Phaser_In Output source coding table
    "PHASE_REF"         :  4'b0000;
    "DELAYED_MEM_REF"   :  4'b0101;
    "DELAYED_PHASE_REF" :  4'b0011;
    "DELAYED_REF"       :  4'b0001;
    "FREQ_REF"          :  4'b1000;
    "MEM_REF"           :  4'b0010;
*/

localparam  RCLK_PI_OUTPUT_CLK_SRC = "DELAYED_MEM_REF";


localparam  DDR_TCK = TCK;

localparam  real FREQ_REF_PERIOD = DDR_TCK / (PHY_0_A_PI_FREQ_REF_DIV == "DIV2" ? 2 : 1);
localparam  real L_FREQ_REF_PERIOD_NS = FREQ_REF_PERIOD /1000.0;
localparam  PO_S3_TAPS      = 64 ;  // Number of taps per clock cycle in OCLK_DELAYED delay line
localparam  PI_S2_TAPS      = 128 ; // Number of taps per clock cycle in stage 2 delay line
localparam  PO_S2_TAPS      = 128 ; // Number of taps per clock cycle in sta

/*
Intrinsic delay of Phaser In Stage 1
@3300ps - 1.939ns - 58.8%
@2500ps - 1.657ns - 66.3%
@1875ps - 1.263ns - 67.4%
@1500ps - 1.021ns - 68.1%
@1250ps - 0.868ns - 69.4%
@1072ps - 0.752ns - 70.1%
@938ps  - 0.667ns - 71.1%
*/

// If we use the Delayed Mem_Ref_Clk in the RCLK Phaser_In, then the Stage 1 intrinsic delay is 0.0
// Fraction of a full DDR_TCK period
localparam  real PI_STG1_INTRINSIC_DELAY  =  (RCLK_PI_OUTPUT_CLK_SRC == "DELAYED_MEM_REF") ? 0.0 :
                     ((DDR_TCK < 1005) ? 0.667 :
                      (DDR_TCK < 1160) ? 0.752 :
                      (DDR_TCK < 1375) ? 0.868 :
                      (DDR_TCK < 1685) ? 1.021 :
                      (DDR_TCK < 2185) ? 1.263 :
                      (DDR_TCK < 2900) ? 1.657 :
                      (DDR_TCK < 3100) ? 1.771 : 1.939)*1000;
/*
Intrinsic delay of Phaser In Stage 2
@3300ps - 0.912ns - 27.6% - single tap - 13ps
@3000ps - 0.848ns - 28.3% - single tap - 11ps
@2500ps - 1.264ns - 50.6% - single tap - 19ps
@1875ps - 1.000ns - 53.3% - single tap - 15ps
@1500ps - 0.848ns - 56.5% - single tap - 11ps
@1250ps - 0.736ns - 58.9% - single tap - 9ps
@1072ps - 0.664ns - 61.9% - single tap - 8ps
@938ps  - 0.608ns - 64.8% - single tap - 7ps
*/
// Intrinsic delay = (.4218 + .0002freq(MHz))period(ps)
localparam  real PI_STG2_INTRINSIC_DELAY  = (0.4218*FREQ_REF_PERIOD + 200) + 16.75;  // 12ps fudge factor
/*
Intrinsic delay of Phaser Out Stage 2 - coarse bypass = 1
@3300ps - 1.294ns - 39.2%
@2500ps - 1.294ns - 51.8%
@1875ps - 1.030ns - 54.9%
@1500ps - 0.878ns - 58.5%
@1250ps - 0.766ns - 61.3%
@1072ps - 0.694ns - 64.7%
@938ps  - 0.638ns - 68.0%

Intrinsic delay of Phaser Out Stage 2 - coarse bypass = 0
@3300ps - 2.084ns - 63.2% - single tap - 20ps
@2500ps - 2.084ns - 81.9% - single tap - 19ps
@1875ps - 1.676ns - 89.4% - single tap - 15ps
@1500ps - 1.444ns - 96.3% - single tap - 11ps
@1250ps - 1.276ns - 102.1% - single tap - 9ps
@1072ps - 1.164ns - 108.6% - single tap - 8ps
@938ps  - 1.076ns - 114.7% - single tap - 7ps
*/
// Fraction of a full DDR_TCK period
localparam  real  PO_STG1_INTRINSIC_DELAY  = 0;
localparam  real  PO_STG2_FINE_INTRINSIC_DELAY    = 0.4218*FREQ_REF_PERIOD + 200 + 42; // 42ps fudge factor
localparam  real  PO_STG2_COARSE_INTRINSIC_DELAY  = 0.2256*FREQ_REF_PERIOD + 200 + 29; // 29ps fudge factor
localparam  real  PO_STG2_INTRINSIC_DELAY  = PO_STG2_FINE_INTRINSIC_DELAY +
                                            (PO_CTL_COARSE_BYPASS  == "TRUE" ? 30 : PO_STG2_COARSE_INTRINSIC_DELAY);

// When the PO_STG2_INTRINSIC_DELAY is approximately equal to tCK, then the Phaser Out's circular buffer can
// go metastable. The circular buffer must be prevented from getting into a metastable state. To accomplish this,
// a default programmed value must be programmed into the stage 2 delay. This delay is only needed at reset, adjustments
// to the stage 2 delay can be made after reset is removed.

localparam  real    PO_S2_TAPS_SIZE        = 1.0*FREQ_REF_PERIOD / PO_S2_TAPS ; // average delay of taps in stage 2 fine delay line
localparam  real    PO_CIRC_BUF_META_ZONE  = 200.0;
localparam          PO_CIRC_BUF_EARLY      = (PO_STG2_INTRINSIC_DELAY < DDR_TCK) ? 1'b1 : 1'b0;
localparam  real    PO_CIRC_BUF_OFFSET     = (PO_STG2_INTRINSIC_DELAY < DDR_TCK) ? DDR_TCK - PO_STG2_INTRINSIC_DELAY : PO_STG2_INTRINSIC_DELAY - DDR_TCK;
// If the stage 2 intrinsic delay is less than the clock period, then see if it is less than the threshold
// If it is not more than the threshold than we must push the delay after the clock period plus a guardband.

//A change in PO_CIRC_BUF_DELAY value will affect the localparam TAP_DEC value(=PO_CIRC_BUF_DELAY - 31) in ddr_phy_ck_addr_cmd_delay.v. Update TAP_DEC value when PO_CIRC_BUF_DELAY is updated.
localparam  integer PO_CIRC_BUF_DELAY   = 60;

//localparam  integer PO_CIRC_BUF_DELAY   = PO_CIRC_BUF_EARLY ? (PO_CIRC_BUF_OFFSET > PO_CIRC_BUF_META_ZONE) ? 0 :
//                                       (PO_CIRC_BUF_META_ZONE + PO_CIRC_BUF_OFFSET) / PO_S2_TAPS_SIZE :
//                                       (PO_CIRC_BUF_META_ZONE - PO_CIRC_BUF_OFFSET) / PO_S2_TAPS_SIZE;

localparam  real    PI_S2_TAPS_SIZE     = 1.0*FREQ_REF_PERIOD / PI_S2_TAPS ; // average delay of taps in stage 2 fine delay line
localparam  real    PI_MAX_STG2_DELAY   = (PI_S2_TAPS/2 - 1) * PI_S2_TAPS_SIZE;
localparam  real    PI_INTRINSIC_DELAY  = PI_STG1_INTRINSIC_DELAY + PI_STG2_INTRINSIC_DELAY;
localparam  real    PO_INTRINSIC_DELAY  = PO_STG1_INTRINSIC_DELAY + PO_STG2_INTRINSIC_DELAY;
localparam  real    PO_DELAY            = PO_INTRINSIC_DELAY + (PO_CIRC_BUF_DELAY*PO_S2_TAPS_SIZE);
localparam          RCLK_BUFIO_DELAY    = 1200; // estimate of clock insertion delay of rclk through BUFIO to ioi
// The PI_OFFSET is the difference between the Phaser Out delay path and the intrinsic delay path
// of the Phaser_In that drives the rclk. The objective is to align either the rising edges of the
// oserdes_oclk and the rclk or to align the rising to falling edges depending on which adjustment
// is within the range of the stage 2 delay line in the Phaser_In.
localparam integer  RCLK_DELAY_INT= (PI_INTRINSIC_DELAY + RCLK_BUFIO_DELAY);
localparam integer  PO_DELAY_INT  = PO_DELAY;
localparam PI_OFFSET   = (PO_DELAY_INT % DDR_TCK) - (RCLK_DELAY_INT % DDR_TCK);

// if pi_offset >= 0 align to oclk posedge by delaying pi path to where oclk is
// if pi_offset < 0  align to oclk negedge by delaying pi path the additional distance to next oclk edge.
//   note that in this case PI_OFFSET is negative so invert before subtracting.
localparam  real    PI_STG2_DELAY_CAND = PI_OFFSET >= 0
                                          ? PI_OFFSET
                                          : ((-PI_OFFSET) <  DDR_TCK/2) ?
                                            (DDR_TCK/2 - (- PI_OFFSET)) :
                                            (DDR_TCK   - (- PI_OFFSET)) ;

localparam  real    PI_STG2_DELAY       =
                                          (PI_STG2_DELAY_CAND > PI_MAX_STG2_DELAY ?
                                          PI_MAX_STG2_DELAY : PI_STG2_DELAY_CAND);
localparam  integer DEFAULT_RCLK_DELAY  = PI_STG2_DELAY / PI_S2_TAPS_SIZE;

localparam          LP_RCLK_SELECT_EDGE    = (RCLK_SELECT_EDGE != 4'b1111 ) ? RCLK_SELECT_EDGE : (PI_OFFSET >= 0 ? RCLK_POS_EDGE : (PI_OFFSET <= TCK/2 ?  RCLK_NEG_EDGE : RCLK_POS_EDGE));

localparam  integer L_PHY_0_PO_FINE_DELAY = PO_CIRC_BUF_DELAY ;
localparam  integer L_PHY_1_PO_FINE_DELAY = PO_CIRC_BUF_DELAY ;
localparam  integer L_PHY_2_PO_FINE_DELAY = PO_CIRC_BUF_DELAY ;

localparam  L_PHY_0_A_PI_FINE_DELAY = (RCLK_SELECT_BANK == 0 && ! DATA_CTL_B0[0]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_0_B_PI_FINE_DELAY = (RCLK_SELECT_BANK == 0 && ! DATA_CTL_B0[1]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_0_C_PI_FINE_DELAY = (RCLK_SELECT_BANK == 0 && ! DATA_CTL_B0[2]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_0_D_PI_FINE_DELAY = (RCLK_SELECT_BANK == 0 && ! DATA_CTL_B0[3]) ? DEFAULT_RCLK_DELAY  : 33 ;

localparam  L_PHY_1_A_PI_FINE_DELAY = (RCLK_SELECT_BANK == 1 && ! DATA_CTL_B1[0]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_1_B_PI_FINE_DELAY = (RCLK_SELECT_BANK == 1 && ! DATA_CTL_B1[1]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_1_C_PI_FINE_DELAY = (RCLK_SELECT_BANK == 1 && ! DATA_CTL_B1[2]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_1_D_PI_FINE_DELAY = (RCLK_SELECT_BANK == 1 && ! DATA_CTL_B1[3]) ? DEFAULT_RCLK_DELAY  : 33 ;

localparam  L_PHY_2_A_PI_FINE_DELAY = (RCLK_SELECT_BANK == 2 && ! DATA_CTL_B2[0]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_2_B_PI_FINE_DELAY = (RCLK_SELECT_BANK == 2 && ! DATA_CTL_B2[1]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_2_C_PI_FINE_DELAY = (RCLK_SELECT_BANK == 2 && ! DATA_CTL_B2[2]) ? DEFAULT_RCLK_DELAY  : 33 ;
localparam  L_PHY_2_D_PI_FINE_DELAY = (RCLK_SELECT_BANK == 2 && ! DATA_CTL_B2[3]) ? DEFAULT_RCLK_DELAY  : 33 ;


localparam  L_PHY_0_A_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 0) ? (RCLK_SELECT_LANE == "A") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_0_B_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 0) ? (RCLK_SELECT_LANE == "B") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_0_C_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 0) ? (RCLK_SELECT_LANE == "C") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_0_D_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 0) ? (RCLK_SELECT_LANE == "D") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC : PHY_0_A_PI_OUTPUT_CLK_SRC;

localparam  L_PHY_1_A_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 1) ? (RCLK_SELECT_LANE == "A") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_1_B_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 1) ? (RCLK_SELECT_LANE == "B") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_1_C_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 1) ? (RCLK_SELECT_LANE == "C") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_1_D_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 1) ? (RCLK_SELECT_LANE == "D") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC : PHY_1_A_PI_OUTPUT_CLK_SRC;

localparam  L_PHY_2_A_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 2) ? (RCLK_SELECT_LANE == "A") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_2_B_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 2) ? (RCLK_SELECT_LANE == "B") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_2_C_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 2) ? (RCLK_SELECT_LANE == "C") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC;
localparam  L_PHY_2_D_PI_OUTPUT_CLK_SRC = (RCLK_SELECT_BANK == 2) ? (RCLK_SELECT_LANE == "D") ? RCLK_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC : PHY_2_A_PI_OUTPUT_CLK_SRC;

wire _phy_clk;

wire [2:0] mcGo_w;
wire [HIGHEST_BANK-1:0] ref_dll_lock_w;
reg  [15:0] mcGo_r;


assign ref_dll_lock = & ref_dll_lock_w;

initial begin
  if ( SYNTHESIS == "FALSE" ) begin
  $display("%m : BYTE_LANES_B0 = %x BYTE_LANES_B1 = %x DATA_CTL_B0 = %x DATA_CTL_B1 = %x", BYTE_LANES_B0, BYTE_LANES_B1, DATA_CTL_B0, DATA_CTL_B1);
  $display("%m : HIGHEST_LANE = %d HIGHEST_LANE_B0 = %d HIGHEST_LANE_B1 = %d",  HIGHEST_LANE, HIGHEST_LANE_B0, HIGHEST_LANE_B1);
  $display("%m : HIGHEST_BANK = %d", HIGHEST_BANK);

  $display("%m : FREQ_REF_PERIOD         = %0.2f ", FREQ_REF_PERIOD);
  $display("%m : DDR_TCK                 = %0d ", DDR_TCK);
  $display("%m : PO_S2_TAPS_SIZE         = %0.2f ", PO_S2_TAPS_SIZE);
  $display("%m : PO_CIRC_BUF_EARLY       = %0d ", PO_CIRC_BUF_EARLY);
  $display("%m : PO_CIRC_BUF_OFFSET      = %0.2f ", PO_CIRC_BUF_OFFSET);
  $display("%m : PO_CIRC_BUF_META_ZONE   = %0.2f ", PO_CIRC_BUF_META_ZONE);
  $display("%m : PO_STG2_FINE_INTR_DLY   = %0.2f ", PO_STG2_FINE_INTRINSIC_DELAY);
  $display("%m : PO_STG2_COARSE_INTR_DLY = %0.2f ", PO_STG2_COARSE_INTRINSIC_DELAY);
  $display("%m : PO_STG2_INTRINSIC_DELAY = %0.2f ", PO_STG2_INTRINSIC_DELAY);
  $display("%m : PO_CIRC_BUF_DELAY       = %0d ", PO_CIRC_BUF_DELAY);
  $display("%m : PO_INTRINSIC_DELAY      = %0.2f ", PO_INTRINSIC_DELAY);
  $display("%m : PO_DELAY                = %0.2f ", PO_DELAY);
  $display("%m : PO_OCLK_DELAY           = %0d ", PHY_0_A_PO_OCLK_DELAY);
  $display("%m : L_PHY_0_PO_FINE_DELAY   = %0d ", L_PHY_0_PO_FINE_DELAY);

  $display("%m : PI_STG1_INTRINSIC_DELAY = %0.2f ", PI_STG1_INTRINSIC_DELAY);
  $display("%m : PI_STG2_INTRINSIC_DELAY = %0.2f ", PI_STG2_INTRINSIC_DELAY);
  $display("%m : PI_INTRINSIC_DELAY      = %0.2f ", PI_INTRINSIC_DELAY);
  $display("%m : PI_MAX_STG2_DELAY       = %0.2f ", PI_MAX_STG2_DELAY);
  $display("%m : PI_OFFSET               = %0.2f ", PI_OFFSET);
  if ( PI_OFFSET < 0) $display("%m : a negative PI_OFFSET means that rclk path is longer than oclk path so rclk will be delayed to next oclk edge and the negedge of rclk may be used.");
  $display("%m : PI_STG2_DELAY           = %0.2f ", PI_STG2_DELAY);
  $display("%m :PI_STG2_DELAY_CAND       = %0.2f ",PI_STG2_DELAY_CAND);
  $display("%m : DEFAULT_RCLK_DELAY      = %0d ", DEFAULT_RCLK_DELAY);
  $display("%m : RCLK_SELECT_EDGE        = %0b ", LP_RCLK_SELECT_EDGE);
  end // SYNTHESIS
  if ( PI_STG2_DELAY_CAND > PI_MAX_STG2_DELAY) $display("WARNING: %m: The required delay though the phaser_in to internally match the aux_out clock  to ddr clock exceeds the maximum allowable delay. The clock edge  will occur at the output registers of aux_out %0.2f ps before the ddr clock  edge. If aux_out is used for memory inputs, this may violate setup or hold time.", PI_STG2_DELAY_CAND - PI_MAX_STG2_DELAY);
end

  assign sync_pulse_split       = sync_pulse;
  assign mem_refclk_split       = mem_refclk;
  assign freq_refclk_split      = freq_refclk;
  assign mem_refclk_div4_split  = mem_refclk_div4;
  assign phy_ctl_clk_split0     = _phy_clk;
  assign phy_ctl_wd_split0      = phy_ctl_wd;
  assign phy_ctl_wr_split0      = phy_ctl_wr;
  assign phy_clk_split0         = phy_clk;
  assign phy_cmd_wr_en_split0   = phy_cmd_wr_en;
  assign phy_data_wr_en_split0  = phy_data_wr_en;
  assign phy_rd_en_split0       = phy_rd_en;
  assign phy_dout_split0        = phy_dout;
  assign phy_ctl_clk_split1     = phy_clk;
  assign phy_ctl_wd_split1      = phy_ctl_wd;
  assign phy_data_offset_1_split1   = data_offset_1;
  assign phy_ctl_wr_split1      = phy_ctl_wr;
  assign phy_clk_split1         = phy_clk;
  assign phy_cmd_wr_en_split1   = phy_cmd_wr_en;
  assign phy_data_wr_en_split1  = phy_data_wr_en;
  assign phy_rd_en_split1       = phy_rd_en;
  assign phy_dout_split1        = phy_dout;
  assign phy_ctl_clk_split2     = phy_clk;
  assign phy_ctl_wd_split2      = phy_ctl_wd;
  assign phy_data_offset_2_split2   = data_offset_2;
  assign phy_ctl_wr_split2      = phy_ctl_wr;
  assign phy_clk_split2         = phy_clk;
  assign phy_cmd_wr_en_split2   = phy_cmd_wr_en;
  assign phy_data_wr_en_split2  = phy_data_wr_en;
  assign phy_rd_en_split2       = phy_rd_en;
  assign phy_dout_split2        = phy_dout;

// these wires are needed to coerce correct synthesis
// the synthesizer did not always see the widths of the
// parameters as 4 bits.

wire [3:0] blb0 = BYTE_LANES_B0;
wire [3:0] blb1 = BYTE_LANES_B1;
wire [3:0] blb2 = BYTE_LANES_B2;

wire [3:0] dcb0 = DATA_CTL_B0;
wire [3:0] dcb1 = DATA_CTL_B1;
wire [3:0] dcb2 = DATA_CTL_B2;

assign pi_dqs_found_all      = & (pi_dqs_found_lanes | ~ {blb2, blb1, blb0} |  ~ {dcb2, dcb1, dcb0});
assign pi_dqs_found_any      = | (pi_dqs_found_lanes & {blb2, blb1, blb0} & {dcb2, dcb1, dcb0});
assign pi_phase_locked_all   = & pi_phase_locked_all_w[HIGHEST_BANK-1:0];
assign calib_zero_inputs_int = {3'bxxx, calib_zero_inputs};
//Added to remove concadination in the instantiation
assign calib_sel_byte0       = {calib_zero_inputs_int[0], calib_sel[1:0]} ;
assign calib_sel_byte1       = {calib_zero_inputs_int[1], calib_sel[1:0]} ;
assign calib_sel_byte2       = {calib_zero_inputs_int[2], calib_sel[1:0]} ;

assign calib_zero_lanes_int = calib_zero_lanes;

assign phy_ctl_ready = &phy_ctl_ready_w[HIGHEST_BANK-1:0];

assign phy_ctl_mstr_empty  = phy_ctl_empty[MASTER_PHY_CTL];

assign of_ctl_a_full  = |of_ctl_a_full_v;
assign of_ctl_full    = |of_ctl_full_v;
assign of_data_a_full = |of_data_a_full_v;
assign of_data_full   = |of_data_full_v;
assign pre_data_a_full= |pre_data_a_full_v;
// if if_empty_def == 1, empty is asserted only if all are empty;
// this allows the user to detect a skewed fifo depth and self-clear
// if desired. It avoids a reset to clear the flags.
assign if_empty       = !if_empty_def ? |if_empty_v : &if_empty_v;
assign if_empty_or    =  |if_empty_or_v;
assign if_empty_and   =  &if_empty_and_v;
assign if_a_empty     = |if_a_empty_v;


generate
genvar i;
for (i = 0; i != NUM_DDR_CK; i = i + 1) begin : ddr_clk_gen
   case  ((GENERATE_DDR_CK_MAP >> (16*i)) & 16'hffff)
      16'h3041: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[0] >> (LP_DDR_CK_WIDTH*i)) & 2'b11;
      16'h3042: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[0] >> (LP_DDR_CK_WIDTH*i+12)) & 2'b11;
      16'h3043: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[0] >> (LP_DDR_CK_WIDTH*i+24)) & 2'b11;
      16'h3044: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[0] >> (LP_DDR_CK_WIDTH*i+36)) & 2'b11;
      16'h3141: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[1] >> (LP_DDR_CK_WIDTH*i)) & 2'b11;
      16'h3142: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[1] >> (LP_DDR_CK_WIDTH*i+12)) & 2'b11;
      16'h3143: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[1] >> (LP_DDR_CK_WIDTH*i+24)) & 2'b11;
      16'h3144: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[1] >> (LP_DDR_CK_WIDTH*i+36)) & 2'b11;
      16'h3241: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[2] >> (LP_DDR_CK_WIDTH*i)) & 2'b11;
      16'h3242: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[2] >> (LP_DDR_CK_WIDTH*i+12)) & 2'b11;
      16'h3243: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[2] >> (LP_DDR_CK_WIDTH*i+24)) & 2'b11;
      16'h3244: assign ddr_clk[(i+1)*LP_DDR_CK_WIDTH-1:(i*LP_DDR_CK_WIDTH)] = (ddr_clk_w[2] >> (LP_DDR_CK_WIDTH*i+36)) & 2'b11;
      default : initial $display("ERROR: mc_phy ddr_clk_gen : invalid specification for parameter GENERATE_DDR_CK_MAP , clock index =  %d, spec= %x (hex) ",  i, (( GENERATE_DDR_CK_MAP >> (16 * i )) & 16'hffff ));
   endcase
end
endgenerate

//assign rclk = rclk_w[RCLK_SELECT_BANK];

reg rst_auxout;
reg rst_auxout_r;
reg rst_auxout_rr;

always @(posedge auxout_clk or posedge rst) begin
  if ( rst) begin
     rst_auxout_r   <= #(1) 1'b1;
     rst_auxout_rr  <= #(1) 1'b1;
  end
  else begin
     rst_auxout_r   <= #(1) rst;
     rst_auxout_rr  <= #(1) rst_auxout_r;
  end
end
if ( LP_RCLK_SELECT_EDGE[0]) begin
  always @(posedge auxout_clk or posedge rst)  begin
    if ( rst) begin
       rst_auxout     <= #(1) 1'b1;
    end
    else begin
       rst_auxout     <= #(1) rst_auxout_rr;
    end
  end
end
else begin
  always @(negedge auxout_clk or posedge rst)  begin
    if ( rst) begin
       rst_auxout     <= #(1) 1'b1;
    end
    else begin
       rst_auxout     <= #(1) rst_auxout_rr;
    end
  end
end

localparam L_RESET_SELECT_BANK =
    (BYTE_LANES_B1 == 0 && BYTE_LANES_B2 == 0 && RCLK_SELECT_BANK) ? 0 : RCLK_SELECT_BANK;

always @(*) begin
      rst_out =  rst_out_w[L_RESET_SELECT_BANK] & ddr_rst_in_n;
end

always @(posedge phy_clk) begin
    if ( rst)
       mcGo_r <= #(1) 0;
    else
       mcGo_r <= #(1) (mcGo_r << 1) |  &mcGo_w;
end

assign mcGo = mcGo_r[15];


generate


// this is an optional  1 clock delay to add latency to the phy_control programming path

if (PHYCTL_CMD_FIFO == "TRUE") begin : cmd_fifo_soft
    reg  [31:0] phy_wd_reg = 0;
    reg  [3:0]  aux_in1_reg = 0;
    reg  [3:0]  aux_in2_reg = 0;
    reg         sfifo_ready = 0;
    assign _phy_ctl_wd     = phy_wd_reg;
    assign aux_in_[1]      = aux_in1_reg;
    assign aux_in_[2]      = aux_in2_reg;
    assign phy_ctl_a_full  = |_phy_ctl_a_full_p;
    assign phy_ctl_full[0] = |_phy_ctl_full_p;
    assign phy_ctl_full[1] = |_phy_ctl_full_p;
    assign phy_ctl_full[2] = |_phy_ctl_full_p;
    assign phy_ctl_full[3] = |_phy_ctl_full_p;
    assign _phy_clk        = phy_clk;

    always @(posedge phy_clk) begin
          phy_wd_reg   <= #1 phy_ctl_wd;
          aux_in1_reg  <= #1 aux_in_1;
          aux_in2_reg  <= #1 aux_in_2;
          sfifo_ready  <= #1 phy_ctl_wr;
    end

end

else if (PHYCTL_CMD_FIFO == "FALSE") begin
    assign _phy_ctl_wd     = phy_ctl_wd;
    assign aux_in_[1]      = aux_in_1;
    assign aux_in_[2]      = aux_in_2;
    assign phy_ctl_a_full  = |_phy_ctl_a_full_p;
    assign phy_ctl_full[0] = |_phy_ctl_full_p;
    assign phy_ctl_full[3:1] = 3'b000;
    assign _phy_clk        = phy_clk;

end
endgenerate


// instance of four-lane phy

generate

if (HIGHEST_BANK == 3) begin : banks_3
  assign byte_rd_en_oth_banks[1:0] = {byte_rd_en_v[1],byte_rd_en_v[2]};
  assign byte_rd_en_oth_banks[3:2] = {byte_rd_en_v[0],byte_rd_en_v[2]};
  assign byte_rd_en_oth_banks[5:4] = {byte_rd_en_v[0],byte_rd_en_v[1]};
end
else if (HIGHEST_BANK == 2) begin : banks_2
  assign byte_rd_en_oth_banks[1:0] = {byte_rd_en_v[1],1'b1};
  assign byte_rd_en_oth_banks[3:2] = {byte_rd_en_v[0],1'b1};
end
else begin : banks_1
  assign byte_rd_en_oth_banks[1:0] = {1'b1,1'b1};
end

if ( BYTE_LANES_B0 != 0)  begin : ddr_phy_4lanes_0
mig_7series_v4_2_ddr_phy_4lanes #
  (
     .BYTE_LANES                (BYTE_LANES_B0),        /* four bits, one per lanes */
     .DATA_CTL_N                (PHY_0_DATA_CTL), /* four bits, one per lane */
     .PO_CTL_COARSE_BYPASS      (PO_CTL_COARSE_BYPASS),
     .PO_FINE_DELAY             (L_PHY_0_PO_FINE_DELAY),
     .BITLANES                  (PHY_0_BITLANES),
     .BITLANES_OUTONLY          (PHY_0_BITLANES_OUTONLY),
     .BYTELANES_DDR_CK          (LP_PHY_0_BYTELANES_DDR_CK),
     .LAST_BANK                 (PHY_0_IS_LAST_BANK),
     .LANE_REMAP                (PHY_0_LANE_REMAP),
     .OF_ALMOST_FULL_VALUE      (PHY_0_OF_ALMOST_FULL_VALUE),
     .IF_ALMOST_EMPTY_VALUE     (PHY_0_IF_ALMOST_EMPTY_VALUE),
     .GENERATE_IDELAYCTRL       (PHY_0_GENERATE_IDELAYCTRL),
     .IODELAY_GRP               (PHY_0_IODELAY_GRP),
     .FPGA_SPEED_GRADE          (FPGA_SPEED_GRADE),
     .BANK_TYPE                 (BANK_TYPE),
     .NUM_DDR_CK                (NUM_DDR_CK),
     .TCK                       (TCK),
     .RCLK_SELECT_LANE          (RCLK_SELECT_LANE),
     .USE_PRE_POST_FIFO         (USE_PRE_POST_FIFO),
     .SYNTHESIS                 (SYNTHESIS),
     .PC_CLK_RATIO              (PHY_CLK_RATIO),
     .PC_EVENTS_DELAY           (PHY_EVENTS_DELAY),
     .PC_FOUR_WINDOW_CLOCKS     (PHY_FOUR_WINDOW_CLOCKS),
     .PC_BURST_MODE             (PHY_0_A_BURST_MODE),
     .PC_SYNC_MODE              (PHY_SYNC_MODE),
     .PC_MULTI_REGION           (PHY_MULTI_REGION),
     .PC_PHY_COUNT_EN           (PHY_COUNT_EN),
     .PC_DISABLE_SEQ_MATCH      (PHY_DISABLE_SEQ_MATCH),
     .PC_CMD_OFFSET             (PHY_0_CMD_OFFSET),
     .PC_RD_CMD_OFFSET_0        (PHY_0_RD_CMD_OFFSET_0),
     .PC_RD_CMD_OFFSET_1        (PHY_0_RD_CMD_OFFSET_1),
     .PC_RD_CMD_OFFSET_2        (PHY_0_RD_CMD_OFFSET_2),
     .PC_RD_CMD_OFFSET_3        (PHY_0_RD_CMD_OFFSET_3),
     .PC_RD_DURATION_0          (PHY_0_RD_DURATION_0),
     .PC_RD_DURATION_1          (PHY_0_RD_DURATION_1),
     .PC_RD_DURATION_2          (PHY_0_RD_DURATION_2),
     .PC_RD_DURATION_3          (PHY_0_RD_DURATION_3),
     .PC_WR_CMD_OFFSET_0        (PHY_0_WR_CMD_OFFSET_0),
     .PC_WR_CMD_OFFSET_1        (PHY_0_WR_CMD_OFFSET_1),
     .PC_WR_CMD_OFFSET_2        (PHY_0_WR_CMD_OFFSET_2),
     .PC_WR_CMD_OFFSET_3        (PHY_0_WR_CMD_OFFSET_3),
     .PC_WR_DURATION_0          (PHY_0_WR_DURATION_0),
     .PC_WR_DURATION_1          (PHY_0_WR_DURATION_1),
     .PC_WR_DURATION_2          (PHY_0_WR_DURATION_2),
     .PC_WR_DURATION_3          (PHY_0_WR_DURATION_3),
     .PC_AO_WRLVL_EN            (PHY_0_AO_WRLVL_EN),
     .PC_AO_TOGGLE              (PHY_0_AO_TOGGLE),

     .PI_SEL_CLK_OFFSET         (PI_SEL_CLK_OFFSET),

     .A_PI_FINE_DELAY           (L_PHY_0_A_PI_FINE_DELAY),
     .B_PI_FINE_DELAY           (L_PHY_0_B_PI_FINE_DELAY),
     .C_PI_FINE_DELAY           (L_PHY_0_C_PI_FINE_DELAY),
     .D_PI_FINE_DELAY           (L_PHY_0_D_PI_FINE_DELAY),

     .A_PI_FREQ_REF_DIV         (PHY_0_A_PI_FREQ_REF_DIV),
     .A_PI_BURST_MODE           (PHY_0_A_BURST_MODE),
     .A_PI_OUTPUT_CLK_SRC       (L_PHY_0_A_PI_OUTPUT_CLK_SRC),
     .B_PI_OUTPUT_CLK_SRC       (L_PHY_0_B_PI_OUTPUT_CLK_SRC),
     .C_PI_OUTPUT_CLK_SRC       (L_PHY_0_C_PI_OUTPUT_CLK_SRC),
     .D_PI_OUTPUT_CLK_SRC       (L_PHY_0_D_PI_OUTPUT_CLK_SRC),
     .A_PO_OUTPUT_CLK_SRC       (PHY_0_A_PO_OUTPUT_CLK_SRC),
     .A_PO_OCLK_DELAY           (PHY_0_A_PO_OCLK_DELAY),
     .A_PO_OCLKDELAY_INV        (PHY_0_A_PO_OCLKDELAY_INV),
     .A_OF_ARRAY_MODE           (PHY_0_A_OF_ARRAY_MODE),
     .B_OF_ARRAY_MODE           (PHY_0_B_OF_ARRAY_MODE),
     .C_OF_ARRAY_MODE           (PHY_0_C_OF_ARRAY_MODE),
     .D_OF_ARRAY_MODE           (PHY_0_D_OF_ARRAY_MODE),
     .A_IF_ARRAY_MODE           (PHY_0_A_IF_ARRAY_MODE),
     .B_IF_ARRAY_MODE           (PHY_0_B_IF_ARRAY_MODE),
     .C_IF_ARRAY_MODE           (PHY_0_C_IF_ARRAY_MODE),
     .D_IF_ARRAY_MODE           (PHY_0_D_IF_ARRAY_MODE),
     .A_OS_DATA_RATE            (PHY_0_A_OSERDES_DATA_RATE),
     .A_OS_DATA_WIDTH           (PHY_0_A_OSERDES_DATA_WIDTH),
     .B_OS_DATA_RATE            (PHY_0_B_OSERDES_DATA_RATE),
     .B_OS_DATA_WIDTH           (PHY_0_B_OSERDES_DATA_WIDTH),
     .C_OS_DATA_RATE            (PHY_0_C_OSERDES_DATA_RATE),
     .C_OS_DATA_WIDTH           (PHY_0_C_OSERDES_DATA_WIDTH),
     .D_OS_DATA_RATE            (PHY_0_D_OSERDES_DATA_RATE),
     .D_OS_DATA_WIDTH           (PHY_0_D_OSERDES_DATA_WIDTH),
     .A_IDELAYE2_IDELAY_TYPE    (PHY_0_A_IDELAYE2_IDELAY_TYPE),
     .A_IDELAYE2_IDELAY_VALUE   (PHY_0_A_IDELAYE2_IDELAY_VALUE)
     ,.CKE_ODT_AUX                   (CKE_ODT_AUX)
     ,.PI_DIV2_INCDEC           (PI_DIV2_INCDEC)
)
 u_ddr_phy_4lanes
(
      .rst                      (rst),
      .phy_clk                  (phy_clk_split0),
      .clk_div2                 (clk_div2),
      .phy_ctl_clk              (phy_ctl_clk_split0),
      .phy_ctl_wd               (phy_ctl_wd_split0),
      .data_offset              (phy_ctl_wd_split0[PC_DATA_OFFSET_RANGE_HI : PC_DATA_OFFSET_RANGE_LO]),
      .phy_ctl_wr               (phy_ctl_wr_split0),
      .mem_refclk               (mem_refclk_split),
      .freq_refclk              (freq_refclk_split),
      .mem_refclk_div4          (mem_refclk_div4_split),
      .sync_pulse               (sync_pulse_split),
      .phy_dout                 (phy_dout_split0[HIGHEST_LANE_B0*80-1:0]),
      .phy_cmd_wr_en            (phy_cmd_wr_en_split0),
      .phy_data_wr_en           (phy_data_wr_en_split0),
      .phy_rd_en                (phy_rd_en_split0),
      .pll_lock                 (pll_lock),
      .ddr_clk                  (ddr_clk_w[0]),
      .rclk                     (),
      .rst_out                  (rst_out_w[0]),
      .mcGo                     (mcGo_w[0]),
      .ref_dll_lock             (ref_dll_lock_w[0]),
      .idelayctrl_refclk        (idelayctrl_refclk),
      .idelay_inc               (idelay_inc),
      .idelay_ce                (idelay_ce),
      .idelay_ld                (idelay_ld),
      .phy_ctl_mstr_empty       (phy_ctl_mstr_empty),
      .if_rst                   (if_rst),
      .if_empty_def             (if_empty_def),
      .byte_rd_en_oth_banks     (byte_rd_en_oth_banks[1:0]),
      .if_a_empty               (if_a_empty_v[0]),
      .if_empty                 (if_empty_v[0]),
      .byte_rd_en               (byte_rd_en_v[0]),
      .if_empty_or              (if_empty_or_v[0]),
      .if_empty_and             (if_empty_and_v[0]),
      .of_ctl_a_full            (of_ctl_a_full_v[0]),
      .of_data_a_full           (of_data_a_full_v[0]),
      .of_ctl_full              (of_ctl_full_v[0]),
      .of_data_full             (of_data_full_v[0]),
      .pre_data_a_full          (pre_data_a_full_v[0]),
      .phy_din                  (phy_din[HIGHEST_LANE_B0*80-1:0]),
      .phy_ctl_a_full           (_phy_ctl_a_full_p[0]),
      .phy_ctl_full             (_phy_ctl_full_p[0]),
      .phy_ctl_empty            (phy_ctl_empty[0]),
      .mem_dq_out               (mem_dq_out[HIGHEST_LANE_B0*12-1:0]),
      .mem_dq_ts                (mem_dq_ts[HIGHEST_LANE_B0*12-1:0]),
      .mem_dq_in                (mem_dq_in[HIGHEST_LANE_B0*10-1:0]),
      .mem_dqs_out              (mem_dqs_out[HIGHEST_LANE_B0-1:0]),
      .mem_dqs_ts               (mem_dqs_ts[HIGHEST_LANE_B0-1:0]),
      .mem_dqs_in               (mem_dqs_in[HIGHEST_LANE_B0-1:0]),
      .aux_out                  (aux_out_[3:0]),
      .phy_ctl_ready            (phy_ctl_ready_w[0]),
      .phy_write_calib          (phy_write_calib),
      .phy_read_calib           (phy_read_calib),
//      .scan_test_bus_A          (scan_test_bus_A),
//      .scan_test_bus_B          (),
//      .scan_test_bus_C          (),
//      .scan_test_bus_D          (),
      .phyGo                    (phyGo),
      .input_sink               (input_sink),

      .calib_sel                (calib_sel_byte0),
      .calib_zero_ctrl          (calib_zero_ctrl[0]),
      .calib_zero_lanes         (calib_zero_lanes_int[3:0]),
      .calib_in_common          (calib_in_common),
      .po_coarse_enable         (po_coarse_enable[0]),
      .po_fine_enable           (po_fine_enable[0]),
      .po_fine_inc              (po_fine_inc[0]),
      .po_coarse_inc            (po_coarse_inc[0]),
      .po_counter_load_en       (po_counter_load_en),
      .po_sel_fine_oclk_delay   (po_sel_fine_oclk_delay[0]),
      .po_counter_load_val      (po_counter_load_val),
      .po_counter_read_en       (po_counter_read_en),
      .po_coarse_overflow       (po_coarse_overflow_w[0]),
      .po_fine_overflow         (po_fine_overflow_w[0]),
      .po_counter_read_val      (po_counter_read_val_w[0]),

      .pi_rst_dqs_find          (pi_rst_dqs_find[0]),
      .pi_fine_enable           (pi_fine_enable),
      .pi_fine_inc              (pi_fine_inc),
      .pi_counter_load_en       (pi_counter_load_en),
      .pi_counter_read_en       (pi_counter_read_en),
      .pi_counter_load_val      (pi_counter_load_val),
      .pi_fine_overflow         (pi_fine_overflow_w[0]),
      .pi_counter_read_val      (pi_counter_read_val_w[0]),
      .pi_dqs_found             (pi_dqs_found_w[0]),
      .pi_dqs_found_all         (pi_dqs_found_all_w[0]),
      .pi_dqs_found_any         (pi_dqs_found_any_w[0]),
      .pi_phase_locked_lanes      (pi_phase_locked_lanes[HIGHEST_LANE_B0-1:0]),
      .pi_dqs_found_lanes       (pi_dqs_found_lanes[HIGHEST_LANE_B0-1:0]),
      .pi_dqs_out_of_range      (pi_dqs_out_of_range_w[0]),
      .pi_phase_locked          (pi_phase_locked_w[0]),
      .pi_phase_locked_all      (pi_phase_locked_all_w[0]),
      .fine_delay               (fine_delay),
      .fine_delay_sel           (fine_delay_sel)
);

   always @(posedge auxout_clk or posedge rst_auxout)  begin
     if (rst_auxout) begin
         aux_out[0]  <= #100 0;
         aux_out[2]  <= #100 0;
     end
     else begin
         aux_out[0]  <= #100 aux_out_[0];
         aux_out[2]  <= #100 aux_out_[2];
     end
   end
   if ( LP_RCLK_SELECT_EDGE[0]) begin
      always @(posedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[1]  <= #100 0;
            aux_out[3]  <= #100 0;
        end
        else begin
            aux_out[1]  <= #100 aux_out_[1];
            aux_out[3]  <= #100 aux_out_[3];
        end
      end
   end
   else begin
      always @(negedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[1]  <= #100 0;
            aux_out[3]  <= #100 0;
        end
        else begin
            aux_out[1]  <= #100 aux_out_[1];
            aux_out[3]  <= #100 aux_out_[3];
        end
      end
   end
end
else begin
   if ( HIGHEST_BANK > 0) begin
       assign phy_din[HIGHEST_LANE_B0*80-1:0] = 0;
       assign _phy_ctl_a_full_p[0] = 0;
       assign of_ctl_a_full_v[0]   = 0;
       assign of_ctl_full_v[0]     = 0;
       assign of_data_a_full_v[0]  = 0;
       assign of_data_full_v[0]    = 0;
       assign pre_data_a_full_v[0] = 0;
       assign if_empty_v[0]        = 0;
       assign byte_rd_en_v[0]      = 1;
       always @(*)
           aux_out[3:0] = 0;
   end
   assign pi_dqs_found_w[0]    = 1;
   assign pi_dqs_found_all_w[0]    = 1;
   assign pi_dqs_found_any_w[0]    = 0;
   assign pi_phase_locked_lanes[HIGHEST_LANE_B0-1:0]  = 4'b1111;
   assign pi_dqs_found_lanes[HIGHEST_LANE_B0-1:0]  = 4'b1111;
   assign pi_dqs_out_of_range_w[0]    = 0;
   assign pi_phase_locked_w[0]    = 1;
   assign po_fine_overflow_w[0] = 0;
   assign po_coarse_overflow_w[0] = 0;
   assign po_fine_overflow_w[0] = 0;
   assign pi_fine_overflow_w[0] = 0;
   assign po_counter_read_val_w[0] = 0;
   assign pi_counter_read_val_w[0] = 0;
   assign mcGo_w[0] = 1;
   if ( RCLK_SELECT_BANK == 0)
     always @(*)
        aux_out[3:0] = 0;
end

if ( BYTE_LANES_B1 != 0) begin : ddr_phy_4lanes_1

mig_7series_v4_2_ddr_phy_4lanes #
  (
     .BYTE_LANES                (BYTE_LANES_B1),        /* four bits, one per lanes */
     .DATA_CTL_N                (PHY_1_DATA_CTL), /* four bits, one per lane */
     .PO_CTL_COARSE_BYPASS      (PO_CTL_COARSE_BYPASS),
     .PO_FINE_DELAY             (L_PHY_1_PO_FINE_DELAY),
     .BITLANES                  (PHY_1_BITLANES),
     .BITLANES_OUTONLY          (PHY_1_BITLANES_OUTONLY),
     .BYTELANES_DDR_CK          (LP_PHY_1_BYTELANES_DDR_CK),
     .LAST_BANK                 (PHY_1_IS_LAST_BANK ),
     .LANE_REMAP                (PHY_1_LANE_REMAP),
     .OF_ALMOST_FULL_VALUE      (PHY_1_OF_ALMOST_FULL_VALUE),
     .IF_ALMOST_EMPTY_VALUE     (PHY_1_IF_ALMOST_EMPTY_VALUE),
     .GENERATE_IDELAYCTRL       (PHY_1_GENERATE_IDELAYCTRL),
     .IODELAY_GRP               (PHY_1_IODELAY_GRP),
     .FPGA_SPEED_GRADE          (FPGA_SPEED_GRADE),
     .BANK_TYPE                 (BANK_TYPE),
     .NUM_DDR_CK                (NUM_DDR_CK),
     .TCK                       (TCK),
     .RCLK_SELECT_LANE          (RCLK_SELECT_LANE),
     .USE_PRE_POST_FIFO         (USE_PRE_POST_FIFO),
     .SYNTHESIS                 (SYNTHESIS),
     .PC_CLK_RATIO              (PHY_CLK_RATIO),
     .PC_EVENTS_DELAY           (PHY_EVENTS_DELAY),
     .PC_FOUR_WINDOW_CLOCKS     (PHY_FOUR_WINDOW_CLOCKS),
     .PC_BURST_MODE             (PHY_1_A_BURST_MODE),
     .PC_SYNC_MODE              (PHY_SYNC_MODE),
     .PC_MULTI_REGION           (PHY_MULTI_REGION),
     .PC_PHY_COUNT_EN           (PHY_COUNT_EN),
     .PC_DISABLE_SEQ_MATCH      (PHY_DISABLE_SEQ_MATCH),
     .PC_CMD_OFFSET             (PHY_1_CMD_OFFSET),
     .PC_RD_CMD_OFFSET_0        (PHY_1_RD_CMD_OFFSET_0),
     .PC_RD_CMD_OFFSET_1        (PHY_1_RD_CMD_OFFSET_1),
     .PC_RD_CMD_OFFSET_2        (PHY_1_RD_CMD_OFFSET_2),
     .PC_RD_CMD_OFFSET_3        (PHY_1_RD_CMD_OFFSET_3),
     .PC_RD_DURATION_0          (PHY_1_RD_DURATION_0),
     .PC_RD_DURATION_1          (PHY_1_RD_DURATION_1),
     .PC_RD_DURATION_2          (PHY_1_RD_DURATION_2),
     .PC_RD_DURATION_3          (PHY_1_RD_DURATION_3),
     .PC_WR_CMD_OFFSET_0        (PHY_1_WR_CMD_OFFSET_0),
     .PC_WR_CMD_OFFSET_1        (PHY_1_WR_CMD_OFFSET_1),
     .PC_WR_CMD_OFFSET_2        (PHY_1_WR_CMD_OFFSET_2),
     .PC_WR_CMD_OFFSET_3        (PHY_1_WR_CMD_OFFSET_3),
     .PC_WR_DURATION_0          (PHY_1_WR_DURATION_0),
     .PC_WR_DURATION_1          (PHY_1_WR_DURATION_1),
     .PC_WR_DURATION_2          (PHY_1_WR_DURATION_2),
     .PC_WR_DURATION_3          (PHY_1_WR_DURATION_3),
     .PC_AO_WRLVL_EN            (PHY_1_AO_WRLVL_EN),
     .PC_AO_TOGGLE              (PHY_1_AO_TOGGLE),

     .PI_SEL_CLK_OFFSET         (PI_SEL_CLK_OFFSET),

     .A_PI_FINE_DELAY           (L_PHY_1_A_PI_FINE_DELAY),
     .B_PI_FINE_DELAY           (L_PHY_1_B_PI_FINE_DELAY),
     .C_PI_FINE_DELAY           (L_PHY_1_C_PI_FINE_DELAY),
     .D_PI_FINE_DELAY           (L_PHY_1_D_PI_FINE_DELAY),

     .A_PI_FREQ_REF_DIV         (PHY_1_A_PI_FREQ_REF_DIV),
     .A_PI_BURST_MODE           (PHY_1_A_BURST_MODE),
     .A_PI_OUTPUT_CLK_SRC       (L_PHY_1_A_PI_OUTPUT_CLK_SRC),
     .B_PI_OUTPUT_CLK_SRC       (L_PHY_1_B_PI_OUTPUT_CLK_SRC),
     .C_PI_OUTPUT_CLK_SRC       (L_PHY_1_C_PI_OUTPUT_CLK_SRC),
     .D_PI_OUTPUT_CLK_SRC       (L_PHY_1_D_PI_OUTPUT_CLK_SRC),
     .A_PO_OUTPUT_CLK_SRC       (PHY_1_A_PO_OUTPUT_CLK_SRC),
     .A_PO_OCLK_DELAY           (PHY_1_A_PO_OCLK_DELAY),
     .A_PO_OCLKDELAY_INV        (PHY_1_A_PO_OCLKDELAY_INV),
     .A_OF_ARRAY_MODE           (PHY_1_A_OF_ARRAY_MODE),
     .B_OF_ARRAY_MODE           (PHY_1_B_OF_ARRAY_MODE),
     .C_OF_ARRAY_MODE           (PHY_1_C_OF_ARRAY_MODE),
     .D_OF_ARRAY_MODE           (PHY_1_D_OF_ARRAY_MODE),
     .A_IF_ARRAY_MODE           (PHY_1_A_IF_ARRAY_MODE),
     .B_IF_ARRAY_MODE           (PHY_1_B_IF_ARRAY_MODE),
     .C_IF_ARRAY_MODE           (PHY_1_C_IF_ARRAY_MODE),
     .D_IF_ARRAY_MODE           (PHY_1_D_IF_ARRAY_MODE),
     .A_OS_DATA_RATE            (PHY_1_A_OSERDES_DATA_RATE),
     .A_OS_DATA_WIDTH           (PHY_1_A_OSERDES_DATA_WIDTH),
     .B_OS_DATA_RATE            (PHY_1_B_OSERDES_DATA_RATE),
     .B_OS_DATA_WIDTH           (PHY_1_B_OSERDES_DATA_WIDTH),
     .C_OS_DATA_RATE            (PHY_1_C_OSERDES_DATA_RATE),
     .C_OS_DATA_WIDTH           (PHY_1_C_OSERDES_DATA_WIDTH),
     .D_OS_DATA_RATE            (PHY_1_D_OSERDES_DATA_RATE),
     .D_OS_DATA_WIDTH           (PHY_1_D_OSERDES_DATA_WIDTH),
     .A_IDELAYE2_IDELAY_TYPE    (PHY_1_A_IDELAYE2_IDELAY_TYPE),
     .A_IDELAYE2_IDELAY_VALUE   (PHY_1_A_IDELAYE2_IDELAY_VALUE)
     ,.CKE_ODT_AUX                   (CKE_ODT_AUX)
     ,.PI_DIV2_INCDEC           (PI_DIV2_INCDEC)
)
 u_ddr_phy_4lanes
(
      .rst                      (rst),
      .phy_clk                  (phy_clk_split1),
      .clk_div2                 (clk_div2),
      .phy_ctl_clk              (phy_ctl_clk_split1),
      .phy_ctl_wd               (phy_ctl_wd_split1),
      .data_offset              (phy_data_offset_1_split1),
      .phy_ctl_wr               (phy_ctl_wr_split1),
      .mem_refclk               (mem_refclk_split),
      .freq_refclk              (freq_refclk_split),
      .mem_refclk_div4          (mem_refclk_div4_split),
      .sync_pulse               (sync_pulse_split),
      .phy_dout                 (phy_dout_split1[HIGHEST_LANE_B1*80+320-1:320]),
      .phy_cmd_wr_en            (phy_cmd_wr_en_split1),
      .phy_data_wr_en           (phy_data_wr_en_split1),
      .phy_rd_en                (phy_rd_en_split1),
      .pll_lock                 (pll_lock),
      .ddr_clk                  (ddr_clk_w[1]),
      .rclk                     (),
      .rst_out                  (rst_out_w[1]),
      .mcGo                     (mcGo_w[1]),
      .ref_dll_lock             (ref_dll_lock_w[1]),
      .idelayctrl_refclk        (idelayctrl_refclk),
      .idelay_inc               (idelay_inc),
      .idelay_ce                (idelay_ce),
      .idelay_ld                (idelay_ld),
      .phy_ctl_mstr_empty       (phy_ctl_mstr_empty),
      .if_rst                   (if_rst),
      .if_empty_def             (if_empty_def),
      .byte_rd_en_oth_banks     (byte_rd_en_oth_banks[3:2]),
      .if_a_empty               (if_a_empty_v[1]),
      .if_empty                 (if_empty_v[1]),
      .byte_rd_en               (byte_rd_en_v[1]),
      .if_empty_or              (if_empty_or_v[1]),
      .if_empty_and             (if_empty_and_v[1]),
      .of_ctl_a_full            (of_ctl_a_full_v[1]),
      .of_data_a_full           (of_data_a_full_v[1]),
      .of_ctl_full              (of_ctl_full_v[1]),
      .of_data_full             (of_data_full_v[1]),
      .pre_data_a_full          (pre_data_a_full_v[1]),
      .phy_din                  (phy_din[HIGHEST_LANE_B1*80+320-1:320]),
      .phy_ctl_a_full           (_phy_ctl_a_full_p[1]),
      .phy_ctl_full             (_phy_ctl_full_p[1]),
      .phy_ctl_empty            (phy_ctl_empty[1]),
      .mem_dq_out               (mem_dq_out[HIGHEST_LANE_B1*12+48-1:48]),
      .mem_dq_ts                (mem_dq_ts[HIGHEST_LANE_B1*12+48-1:48]),
      .mem_dq_in                (mem_dq_in[HIGHEST_LANE_B1*10+40-1:40]),
      .mem_dqs_out              (mem_dqs_out[HIGHEST_LANE_B1+4-1:4]),
      .mem_dqs_ts               (mem_dqs_ts[HIGHEST_LANE_B1+4-1:4]),
      .mem_dqs_in               (mem_dqs_in[HIGHEST_LANE_B1+4-1:4]),
      .aux_out                  (aux_out_[7:4]),
      .phy_ctl_ready            (phy_ctl_ready_w[1]),
      .phy_write_calib          (phy_write_calib),
      .phy_read_calib           (phy_read_calib),
//      .scan_test_bus_A          (scan_test_bus_A),
//      .scan_test_bus_B          (),
//      .scan_test_bus_C          (),
//      .scan_test_bus_D          (),
      .phyGo                    (phyGo),
      .input_sink               (input_sink),

      .calib_sel                (calib_sel_byte1),
      .calib_zero_ctrl          (calib_zero_ctrl[1]),
      .calib_zero_lanes         (calib_zero_lanes_int[7:4]),
      .calib_in_common          (calib_in_common),
      .po_coarse_enable         (po_coarse_enable[1]),
      .po_fine_enable           (po_fine_enable[1]),
      .po_fine_inc              (po_fine_inc[1]),
      .po_coarse_inc            (po_coarse_inc[1]),
      .po_counter_load_en       (po_counter_load_en),
      .po_sel_fine_oclk_delay   (po_sel_fine_oclk_delay[1]),
      .po_counter_load_val      (po_counter_load_val),
      .po_counter_read_en       (po_counter_read_en),
      .po_coarse_overflow       (po_coarse_overflow_w[1]),
      .po_fine_overflow         (po_fine_overflow_w[1]),
      .po_counter_read_val      (po_counter_read_val_w[1]),

      .pi_rst_dqs_find          (pi_rst_dqs_find[1]),
      .pi_fine_enable           (pi_fine_enable),
      .pi_fine_inc              (pi_fine_inc),
      .pi_counter_load_en       (pi_counter_load_en),
      .pi_counter_read_en       (pi_counter_read_en),
      .pi_counter_load_val      (pi_counter_load_val),
      .pi_fine_overflow         (pi_fine_overflow_w[1]),
      .pi_counter_read_val      (pi_counter_read_val_w[1]),
      .pi_dqs_found             (pi_dqs_found_w[1]),
      .pi_dqs_found_all         (pi_dqs_found_all_w[1]),
      .pi_dqs_found_any         (pi_dqs_found_any_w[1]),
      .pi_phase_locked_lanes    (pi_phase_locked_lanes[HIGHEST_LANE_B1+4-1:4]),
      .pi_dqs_found_lanes       (pi_dqs_found_lanes[HIGHEST_LANE_B1+4-1:4]),
      .pi_dqs_out_of_range      (pi_dqs_out_of_range_w[1]),
      .pi_phase_locked          (pi_phase_locked_w[1]),
      .pi_phase_locked_all      (pi_phase_locked_all_w[1]),
      .fine_delay               (fine_delay),
      .fine_delay_sel           (fine_delay_sel)
);

   always @(posedge auxout_clk or posedge rst_auxout)  begin
     if (rst_auxout) begin
         aux_out[4]  <= #100 0;
         aux_out[6]  <= #100 0;
     end
     else begin
         aux_out[4]  <= #100 aux_out_[4];
         aux_out[6]  <= #100 aux_out_[6];
     end
   end
   if ( LP_RCLK_SELECT_EDGE[1]) begin
      always @(posedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[5]  <= #100 0;
            aux_out[7]  <= #100 0;
        end
        else begin
            aux_out[5]  <= #100 aux_out_[5];
            aux_out[7]  <= #100 aux_out_[7];
        end
      end
   end
   else begin
      always @(negedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[5]  <= #100 0;
            aux_out[7]  <= #100 0;
        end
        else begin
            aux_out[5]  <= #100 aux_out_[5];
            aux_out[7]  <= #100 aux_out_[7];
        end
      end
   end
end
else begin
   if ( HIGHEST_BANK > 1)  begin
       assign phy_din[HIGHEST_LANE_B1*80+320-1:320] = 0;
       assign _phy_ctl_a_full_p[1] = 0;
       assign of_ctl_a_full_v[1]   = 0;
       assign of_ctl_full_v[1]     = 0;
       assign of_data_a_full_v[1]  = 0;
       assign of_data_full_v[1]    = 0;
       assign pre_data_a_full_v[1] = 0;
       assign if_empty_v[1]        = 0;
       assign byte_rd_en_v[1]      = 1;
       assign pi_phase_locked_lanes[HIGHEST_LANE_B1+4-1:4]  = 4'b1111;
       assign pi_dqs_found_lanes[HIGHEST_LANE_B1+4-1:4]  = 4'b1111;
       always @(*)
          aux_out[7:4] = 0;
   end
       assign pi_dqs_found_w[1]    = 1;
       assign pi_dqs_found_all_w[1]    = 1;
       assign pi_dqs_found_any_w[1]    = 0;
       assign pi_dqs_out_of_range_w[1]    = 0;
       assign pi_phase_locked_w[1]    = 1;
       assign po_coarse_overflow_w[1] = 0;
       assign po_fine_overflow_w[1] = 0;
       assign pi_fine_overflow_w[1] = 0;
       assign po_counter_read_val_w[1] = 0;
       assign pi_counter_read_val_w[1] = 0;
       assign mcGo_w[1] = 1;
end

if ( BYTE_LANES_B2 != 0) begin : ddr_phy_4lanes_2

mig_7series_v4_2_ddr_phy_4lanes #
  (
     .BYTE_LANES                (BYTE_LANES_B2),        /* four bits, one per lanes */
     .DATA_CTL_N                (PHY_2_DATA_CTL), /* four bits, one per lane */
     .PO_CTL_COARSE_BYPASS      (PO_CTL_COARSE_BYPASS),
     .PO_FINE_DELAY             (L_PHY_2_PO_FINE_DELAY),
     .BITLANES                  (PHY_2_BITLANES),
     .BITLANES_OUTONLY          (PHY_2_BITLANES_OUTONLY),
     .BYTELANES_DDR_CK          (LP_PHY_2_BYTELANES_DDR_CK),
     .LAST_BANK                 (PHY_2_IS_LAST_BANK ),
     .LANE_REMAP                (PHY_2_LANE_REMAP),
     .OF_ALMOST_FULL_VALUE      (PHY_2_OF_ALMOST_FULL_VALUE),
     .IF_ALMOST_EMPTY_VALUE     (PHY_2_IF_ALMOST_EMPTY_VALUE),
     .GENERATE_IDELAYCTRL       (PHY_2_GENERATE_IDELAYCTRL),
     .IODELAY_GRP               (PHY_2_IODELAY_GRP),
     .FPGA_SPEED_GRADE          (FPGA_SPEED_GRADE),
     .BANK_TYPE                 (BANK_TYPE),
     .NUM_DDR_CK                (NUM_DDR_CK),
     .TCK                       (TCK),
     .RCLK_SELECT_LANE          (RCLK_SELECT_LANE),
     .USE_PRE_POST_FIFO         (USE_PRE_POST_FIFO),
     .SYNTHESIS                 (SYNTHESIS),
     .PC_CLK_RATIO              (PHY_CLK_RATIO),
     .PC_EVENTS_DELAY           (PHY_EVENTS_DELAY),
     .PC_FOUR_WINDOW_CLOCKS     (PHY_FOUR_WINDOW_CLOCKS),
     .PC_BURST_MODE             (PHY_2_A_BURST_MODE),
     .PC_SYNC_MODE              (PHY_SYNC_MODE),
     .PC_MULTI_REGION           (PHY_MULTI_REGION),
     .PC_PHY_COUNT_EN           (PHY_COUNT_EN),
     .PC_DISABLE_SEQ_MATCH      (PHY_DISABLE_SEQ_MATCH),
     .PC_CMD_OFFSET             (PHY_2_CMD_OFFSET),
     .PC_RD_CMD_OFFSET_0        (PHY_2_RD_CMD_OFFSET_0),
     .PC_RD_CMD_OFFSET_1        (PHY_2_RD_CMD_OFFSET_1),
     .PC_RD_CMD_OFFSET_2        (PHY_2_RD_CMD_OFFSET_2),
     .PC_RD_CMD_OFFSET_3        (PHY_2_RD_CMD_OFFSET_3),
     .PC_RD_DURATION_0          (PHY_2_RD_DURATION_0),
     .PC_RD_DURATION_1          (PHY_2_RD_DURATION_1),
     .PC_RD_DURATION_2          (PHY_2_RD_DURATION_2),
     .PC_RD_DURATION_3          (PHY_2_RD_DURATION_3),
     .PC_WR_CMD_OFFSET_0        (PHY_2_WR_CMD_OFFSET_0),
     .PC_WR_CMD_OFFSET_1        (PHY_2_WR_CMD_OFFSET_1),
     .PC_WR_CMD_OFFSET_2        (PHY_2_WR_CMD_OFFSET_2),
     .PC_WR_CMD_OFFSET_3        (PHY_2_WR_CMD_OFFSET_3),
     .PC_WR_DURATION_0          (PHY_2_WR_DURATION_0),
     .PC_WR_DURATION_1          (PHY_2_WR_DURATION_1),
     .PC_WR_DURATION_2          (PHY_2_WR_DURATION_2),
     .PC_WR_DURATION_3          (PHY_2_WR_DURATION_3),
     .PC_AO_WRLVL_EN            (PHY_2_AO_WRLVL_EN),
     .PC_AO_TOGGLE              (PHY_2_AO_TOGGLE),

     .PI_SEL_CLK_OFFSET         (PI_SEL_CLK_OFFSET),

     .A_PI_FINE_DELAY           (L_PHY_2_A_PI_FINE_DELAY),
     .B_PI_FINE_DELAY           (L_PHY_2_B_PI_FINE_DELAY),
     .C_PI_FINE_DELAY           (L_PHY_2_C_PI_FINE_DELAY),
     .D_PI_FINE_DELAY           (L_PHY_2_D_PI_FINE_DELAY),
     .A_PI_FREQ_REF_DIV         (PHY_2_A_PI_FREQ_REF_DIV),
     .A_PI_BURST_MODE           (PHY_2_A_BURST_MODE),
     .A_PI_OUTPUT_CLK_SRC       (L_PHY_2_A_PI_OUTPUT_CLK_SRC),
     .B_PI_OUTPUT_CLK_SRC       (L_PHY_2_B_PI_OUTPUT_CLK_SRC),
     .C_PI_OUTPUT_CLK_SRC       (L_PHY_2_C_PI_OUTPUT_CLK_SRC),
     .D_PI_OUTPUT_CLK_SRC       (L_PHY_2_D_PI_OUTPUT_CLK_SRC),
     .A_PO_OUTPUT_CLK_SRC       (PHY_2_A_PO_OUTPUT_CLK_SRC),
     .A_PO_OCLK_DELAY           (PHY_2_A_PO_OCLK_DELAY),
     .A_PO_OCLKDELAY_INV        (PHY_2_A_PO_OCLKDELAY_INV),
     .A_OF_ARRAY_MODE           (PHY_2_A_OF_ARRAY_MODE),
     .B_OF_ARRAY_MODE           (PHY_2_B_OF_ARRAY_MODE),
     .C_OF_ARRAY_MODE           (PHY_2_C_OF_ARRAY_MODE),
     .D_OF_ARRAY_MODE           (PHY_2_D_OF_ARRAY_MODE),
     .A_IF_ARRAY_MODE           (PHY_2_A_IF_ARRAY_MODE),
     .B_IF_ARRAY_MODE           (PHY_2_B_IF_ARRAY_MODE),
     .C_IF_ARRAY_MODE           (PHY_2_C_IF_ARRAY_MODE),
     .D_IF_ARRAY_MODE           (PHY_2_D_IF_ARRAY_MODE),
     .A_OS_DATA_RATE            (PHY_2_A_OSERDES_DATA_RATE),
     .A_OS_DATA_WIDTH           (PHY_2_A_OSERDES_DATA_WIDTH),
     .B_OS_DATA_RATE            (PHY_2_B_OSERDES_DATA_RATE),
     .B_OS_DATA_WIDTH           (PHY_2_B_OSERDES_DATA_WIDTH),
     .C_OS_DATA_RATE            (PHY_2_C_OSERDES_DATA_RATE),
     .C_OS_DATA_WIDTH           (PHY_2_C_OSERDES_DATA_WIDTH),
     .D_OS_DATA_RATE            (PHY_2_D_OSERDES_DATA_RATE),
     .D_OS_DATA_WIDTH           (PHY_2_D_OSERDES_DATA_WIDTH),
     .A_IDELAYE2_IDELAY_TYPE    (PHY_2_A_IDELAYE2_IDELAY_TYPE),
     .A_IDELAYE2_IDELAY_VALUE   (PHY_2_A_IDELAYE2_IDELAY_VALUE)
     ,.CKE_ODT_AUX                   (CKE_ODT_AUX)
     ,.PI_DIV2_INCDEC           (PI_DIV2_INCDEC)
)
 u_ddr_phy_4lanes
(
      .rst                      (rst),
      .phy_clk                  (phy_clk_split2),
      .clk_div2                 (clk_div2),
      .phy_ctl_clk              (phy_ctl_clk_split2),
      .phy_ctl_wd               (phy_ctl_wd_split2),
      .data_offset              (phy_data_offset_2_split2),
      .phy_ctl_wr               (phy_ctl_wr_split2),
      .mem_refclk               (mem_refclk_split),
      .freq_refclk              (freq_refclk_split),
      .mem_refclk_div4          (mem_refclk_div4_split),
      .sync_pulse               (sync_pulse_split),
      .phy_dout                 (phy_dout_split2[HIGHEST_LANE_B2*80+640-1:640]),
      .phy_cmd_wr_en            (phy_cmd_wr_en_split2),
      .phy_data_wr_en           (phy_data_wr_en_split2),
      .phy_rd_en                (phy_rd_en_split2),
      .pll_lock                 (pll_lock),
      .ddr_clk                  (ddr_clk_w[2]),
      .rclk                     (),
      .rst_out                  (rst_out_w[2]),
      .mcGo                     (mcGo_w[2]),
      .ref_dll_lock             (ref_dll_lock_w[2]),
      .idelayctrl_refclk        (idelayctrl_refclk),
      .idelay_inc               (idelay_inc),
      .idelay_ce                (idelay_ce),
      .idelay_ld                (idelay_ld),
      .phy_ctl_mstr_empty       (phy_ctl_mstr_empty),
      .if_rst                   (if_rst),
      .if_empty_def             (if_empty_def),
      .byte_rd_en_oth_banks     (byte_rd_en_oth_banks[5:4]),
      .if_a_empty               (if_a_empty_v[2]),
      .if_empty                 (if_empty_v[2]),
      .byte_rd_en               (byte_rd_en_v[2]),
      .if_empty_or              (if_empty_or_v[2]),
      .if_empty_and             (if_empty_and_v[2]),
      .of_ctl_a_full            (of_ctl_a_full_v[2]),
      .of_data_a_full           (of_data_a_full_v[2]),
      .of_ctl_full              (of_ctl_full_v[2]),
      .of_data_full             (of_data_full_v[2]),
      .pre_data_a_full          (pre_data_a_full_v[2]),
      .phy_din                  (phy_din[HIGHEST_LANE_B2*80+640-1:640]),
      .phy_ctl_a_full           (_phy_ctl_a_full_p[2]),
      .phy_ctl_full             (_phy_ctl_full_p[2]),
      .phy_ctl_empty            (phy_ctl_empty[2]),
      .mem_dq_out               (mem_dq_out[HIGHEST_LANE_B2*12+96-1:96]),
      .mem_dq_ts                (mem_dq_ts[HIGHEST_LANE_B2*12+96-1:96]),
      .mem_dq_in                (mem_dq_in[HIGHEST_LANE_B2*10+80-1:80]),
      .mem_dqs_out              (mem_dqs_out[HIGHEST_LANE_B2-1+8:8]),
      .mem_dqs_ts               (mem_dqs_ts[HIGHEST_LANE_B2-1+8:8]),
      .mem_dqs_in               (mem_dqs_in[HIGHEST_LANE_B2-1+8:8]),
      .aux_out                  (aux_out_[11:8]),
      .phy_ctl_ready            (phy_ctl_ready_w[2]),
      .phy_write_calib          (phy_write_calib),
      .phy_read_calib           (phy_read_calib),
//      .scan_test_bus_A          (scan_test_bus_A),
//      .scan_test_bus_B          (),
//      .scan_test_bus_C          (),
//      .scan_test_bus_D          (),
      .phyGo                    (phyGo),
      .input_sink               (input_sink),

      .calib_sel                (calib_sel_byte2),
      .calib_zero_ctrl          (calib_zero_ctrl[2]),
      .calib_zero_lanes         (calib_zero_lanes_int[11:8]),
      .calib_in_common          (calib_in_common),
      .po_coarse_enable         (po_coarse_enable[2]),
      .po_fine_enable           (po_fine_enable[2]),
      .po_fine_inc              (po_fine_inc[2]),
      .po_coarse_inc            (po_coarse_inc[2]),
      .po_counter_load_en       (po_counter_load_en),
      .po_sel_fine_oclk_delay   (po_sel_fine_oclk_delay[2]),
      .po_counter_load_val      (po_counter_load_val),
      .po_counter_read_en       (po_counter_read_en),
      .po_coarse_overflow       (po_coarse_overflow_w[2]),
      .po_fine_overflow         (po_fine_overflow_w[2]),
      .po_counter_read_val      (po_counter_read_val_w[2]),

      .pi_rst_dqs_find          (pi_rst_dqs_find[2]),
      .pi_fine_enable           (pi_fine_enable),
      .pi_fine_inc              (pi_fine_inc),
      .pi_counter_load_en       (pi_counter_load_en),
      .pi_counter_read_en       (pi_counter_read_en),
      .pi_counter_load_val      (pi_counter_load_val),
      .pi_fine_overflow         (pi_fine_overflow_w[2]),
      .pi_counter_read_val      (pi_counter_read_val_w[2]),
      .pi_dqs_found             (pi_dqs_found_w[2]),
      .pi_dqs_found_all         (pi_dqs_found_all_w[2]),
      .pi_dqs_found_any         (pi_dqs_found_any_w[2]),
      .pi_phase_locked_lanes    (pi_phase_locked_lanes[HIGHEST_LANE_B2+8-1:8]),
      .pi_dqs_found_lanes       (pi_dqs_found_lanes[HIGHEST_LANE_B2+8-1:8]),
      .pi_dqs_out_of_range      (pi_dqs_out_of_range_w[2]),
      .pi_phase_locked          (pi_phase_locked_w[2]),
      .pi_phase_locked_all      (pi_phase_locked_all_w[2]),
      .fine_delay               (fine_delay),
      .fine_delay_sel           (fine_delay_sel)
);
   always @(posedge auxout_clk or posedge rst_auxout)  begin
     if (rst_auxout) begin
         aux_out[8]  <= #100 0;
         aux_out[10] <= #100 0;
     end
     else begin
         aux_out[8]  <= #100 aux_out_[8];
         aux_out[10] <= #100 aux_out_[10];
     end
   end
   if ( LP_RCLK_SELECT_EDGE[1]) begin
      always @(posedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[9]  <= #100 0;
            aux_out[11] <= #100 0;
        end
        else begin
            aux_out[9]  <= #100 aux_out_[9];
            aux_out[11] <= #100 aux_out_[11];
        end
      end
   end
   else begin
      always @(negedge auxout_clk or posedge rst_auxout)  begin
        if (rst_auxout) begin
            aux_out[9]  <= #100 0;
            aux_out[11] <= #100 0;
        end
        else begin
            aux_out[9]  <= #100 aux_out_[9];
            aux_out[11] <= #100 aux_out_[11];
        end
      end
   end
end
else begin
   if ( HIGHEST_BANK > 2)  begin
       assign phy_din[HIGHEST_LANE_B2*80+640-1:640] = 0;
       assign _phy_ctl_a_full_p[2] = 0;
       assign of_ctl_a_full_v[2]   = 0;
       assign of_ctl_full_v[2]     = 0;
       assign of_data_a_full_v[2]  = 0;
       assign of_data_full_v[2]    = 0;
       assign pre_data_a_full_v[2] = 0;
       assign if_empty_v[2]        = 0;
       assign byte_rd_en_v[2]      = 1;
       assign pi_phase_locked_lanes[HIGHEST_LANE_B2+8-1:8]  = 4'b1111;
       assign pi_dqs_found_lanes[HIGHEST_LANE_B2+8-1:8]  = 4'b1111;
       always @(*)
         aux_out[11:8] = 0;
   end
       assign pi_dqs_found_w[2]    = 1;
       assign pi_dqs_found_all_w[2]    = 1;
       assign pi_dqs_found_any_w[2]    = 0;
       assign pi_dqs_out_of_range_w[2]    = 0;
       assign pi_phase_locked_w[2]    = 1;
       assign po_coarse_overflow_w[2] = 0;
       assign po_fine_overflow_w[2] = 0;
       assign po_counter_read_val_w[2] = 0;
       assign pi_counter_read_val_w[2] = 0;
       assign mcGo_w[2] = 1;
end
endgenerate

generate

// for single bank , emit an extra phaser_in to generate rclk
// so that auxout can be placed in another region
// if desired

if ( BYTE_LANES_B1 == 0 && BYTE_LANES_B2 == 0 && RCLK_SELECT_BANK>0)
begin : phaser_in_rclk

localparam L_EXTRA_PI_FINE_DELAY = DEFAULT_RCLK_DELAY;

PHASER_IN_PHY #(
  .BURST_MODE                       ( PHY_0_A_BURST_MODE),
  .CLKOUT_DIV                       ( PHY_0_A_PI_CLKOUT_DIV),
  .FREQ_REF_DIV                     ( PHY_0_A_PI_FREQ_REF_DIV),
  .REFCLK_PERIOD                    ( L_FREQ_REF_PERIOD_NS),
  .FINE_DELAY                       ( L_EXTRA_PI_FINE_DELAY),
  .OUTPUT_CLK_SRC                   ( RCLK_PI_OUTPUT_CLK_SRC)
) phaser_in_rclk (
  .DQSFOUND                         (),
  .DQSOUTOFRANGE                    (),
  .FINEOVERFLOW                     (),
  .PHASELOCKED                      (),
  .ISERDESRST                       (),
  .ICLKDIV                          (),
  .ICLK                             (),
  .COUNTERREADVAL                   (),
  .RCLK                             (),
  .WRENABLE                         (),
  .BURSTPENDINGPHY                  (),
  .ENCALIBPHY                       (),
  .FINEENABLE                       (0),
  .FREQREFCLK                       (freq_refclk),
  .MEMREFCLK                        (mem_refclk),
  .RANKSELPHY                       (0),
  .PHASEREFCLK                      (),
  .RSTDQSFIND                       (0),
  .RST                              (rst),
  .FINEINC                          (),
  .COUNTERLOADEN                    (),
  .COUNTERREADEN                    (),
  .COUNTERLOADVAL                   (),
  .SYNCIN                           (sync_pulse),
  .SYSCLK                           (phy_clk)
);

end

endgenerate



always @(*) begin
      case (calib_sel[5:3])
      3'b000: begin
          po_coarse_overflow  = po_coarse_overflow_w[0];
          po_fine_overflow    = po_fine_overflow_w[0];
          po_counter_read_val = po_counter_read_val_w[0];
          pi_fine_overflow    = pi_fine_overflow_w[0];
          pi_counter_read_val = pi_counter_read_val_w[0];
          pi_phase_locked     = pi_phase_locked_w[0];
          if ( calib_in_common)
             pi_dqs_found        = pi_dqs_found_any;
          else
             pi_dqs_found        = pi_dqs_found_w[0];
          pi_dqs_out_of_range = pi_dqs_out_of_range_w[0];
        end
      3'b001: begin
          po_coarse_overflow  = po_coarse_overflow_w[1];
          po_fine_overflow    = po_fine_overflow_w[1];
          po_counter_read_val = po_counter_read_val_w[1];
          pi_fine_overflow    = pi_fine_overflow_w[1];
          pi_counter_read_val = pi_counter_read_val_w[1];
          pi_phase_locked     = pi_phase_locked_w[1];
          if ( calib_in_common)
              pi_dqs_found        = pi_dqs_found_any;
          else
              pi_dqs_found        = pi_dqs_found_w[1];
          pi_dqs_out_of_range = pi_dqs_out_of_range_w[1];
        end
      3'b010: begin
          po_coarse_overflow  = po_coarse_overflow_w[2];
          po_fine_overflow    = po_fine_overflow_w[2];
          po_counter_read_val = po_counter_read_val_w[2];
          pi_fine_overflow    = pi_fine_overflow_w[2];
          pi_counter_read_val = pi_counter_read_val_w[2];
          pi_phase_locked     = pi_phase_locked_w[2];
          if ( calib_in_common)
             pi_dqs_found        = pi_dqs_found_any;
          else
             pi_dqs_found        = pi_dqs_found_w[2];
          pi_dqs_out_of_range = pi_dqs_out_of_range_w[2];
        end
       default: begin
          po_coarse_overflow  = 0;
          po_fine_overflow    = 0;
          po_counter_read_val = 0;
          pi_fine_overflow    = 0;
          pi_counter_read_val = 0;
          pi_phase_locked     = 0;
          pi_dqs_found        = 0;
          pi_dqs_out_of_range = 0;
        end
       endcase
end

endmodule // mc_phy

