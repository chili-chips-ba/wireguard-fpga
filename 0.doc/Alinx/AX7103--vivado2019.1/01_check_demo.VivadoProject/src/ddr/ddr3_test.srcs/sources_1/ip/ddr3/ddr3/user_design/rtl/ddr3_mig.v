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
// \   \   \/     Version            : 4.2
//  \   \         Application        : MIG
//  /   /         Filename           : ddr3_mig.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   Top-level  module. This module can be instantiated in the
//   system and interconnect as shown in user design wrapper file (user top module).
//   In addition to the memory controller, the module instantiates:
//     1. Clock generation/distribution, reset logic
//     2. IDELAY control block
//     3. Debug logic
// Reference        :
// Revision History :
//*****************************************************************************

//`define SKIP_CALIB
`timescale 1ps/1ps

module ddr3_mig #
  (

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter CK_WIDTH              = 1,
                                     // # of CK/CK# outputs to memory.
   parameter COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter nCS_PER_RANK          = 1,
                                     // # of unique CS outputs per rank for phy
   parameter CKE_WIDTH             = 1,
                                     // # of CKE outputs to memory.
   parameter DATA_BUF_ADDR_WIDTH   = 5,
   parameter DQ_CNT_WIDTH          = 5,
                                     // = ceil(log2(DQ_WIDTH))
   parameter DQ_PER_DM             = 8,
   parameter DM_WIDTH              = 4,
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 32,
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 4,
   parameter DQS_CNT_WIDTH         = 2,
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter ECC                   = "OFF",
   parameter DATA_WIDTH            = 32,
   parameter ECC_TEST              = "OFF",
   parameter PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH,
   parameter MEM_ADDR_ORDER        = "BANK_ROW_COLUMN",
                                      //Possible Parameters
                                      //1.BANK_ROW_COLUMN : Address mapping is
                                      //                    in form of Bank Row Column.
                                      //2.ROW_BANK_COLUMN : Address mapping is
                                      //                    in the form of Row Bank Column.
                                      //3.TG_TEST : Scrambles Address bits
                                      //            for distributed Addressing.
      
   //parameter nBANK_MACHS           = 4,
   parameter nBANK_MACHS           = 4,
   parameter RANKS                 = 1,
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1,
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 15,
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 29,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
   parameter USE_CS_PORT          = 1,
                                     // # = 1, When Chip Select (CS#) output is enabled
                                     //   = 0, When Chip Select (CS#) output is disabled
                                     // If CS_N disabled, user must connect
                                     // DRAM CS_N input(s) to ground
   parameter USE_DM_PORT           = 1,
                                     // # = 1, When Data Mask option is enabled
                                     //   = 0, When Data Mask option is disbaled
                                     // When Data Mask option is disabled in
                                     // MIG Controller Options page, the logic
                                     // related to Data Mask should not get
                                     // synthesized
   parameter USE_ODT_PORT          = 1,
                                     // # = 1, When ODT output is enabled
                                     //   = 0, When ODT output is disabled
                                     // Parameter configuration for Dynamic ODT support:
                                     // USE_ODT_PORT = 0, RTT_NOM = "DISABLED", RTT_WR = "60/120".
                                     // This configuration allows to save ODT pin mapping from FPGA.
                                     // The user can tie the ODT input of DRAM to HIGH.
   parameter IS_CLK_SHARED          = "FALSE",
                                      // # = "true" when clock is shared
                                      //   = "false" when clock is not shared

   parameter PHY_CONTROL_MASTER_BANK = 1,
                                     // The bank index where master PHY_CONTROL resides,
                                     // equal to the PLL residing bank
   parameter MEM_DENSITY           = "4Gb",
                                     // Indicates the density of the Memory part
                                     // Added for the sake of Vivado simulations
   parameter MEM_SPEEDGRADE        = "125",
                                     // Indicates the Speed grade of Memory Part
                                     // Added for the sake of Vivado simulations
   parameter MEM_DEVICE_WIDTH      = 16,
                                     // Indicates the device width of the Memory Part
                                     // Added for the sake of Vivado simulations

   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter AL                    = "0",
                                     // DDR3 SDRAM:
                                     // Additive Latency (Mode Register 1).
                                     // # = "0", "CL-1", "CL-2".
                                     // DDR2 SDRAM:
                                     // Additive Latency (Extended Mode Register).
   parameter nAL                   = 0,
                                     // # Additive Latency in number of clock
                                     // cycles.
   parameter BURST_MODE            = "8",
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".
   parameter BURST_TYPE            = "SEQ",
                                     // DDR3 SDRAM: Burst Type (Mode Register 0).
                                     // DDR2 SDRAM: Burst Type (Mode Register).
                                     // # = "SEQ" - (Sequential),
                                     //   = "INT" - (Interleaved).
   parameter CL                    = 6,
                                     // in number of clock cycles
                                     // DDR3 SDRAM: CAS Latency (Mode Register 0).
                                     // DDR2 SDRAM: CAS Latency (Mode Register).
   parameter CWL                   = 5,
                                     // in number of clock cycles
                                     // DDR3 SDRAM: CAS Write Latency (Mode Register 2).
                                     // DDR2 SDRAM: Can be ignored
   parameter OUTPUT_DRV            = "HIGH",
                                     // Output Driver Impedance Control (Mode Register 1).
                                     // # = "HIGH" - RZQ/7,
                                     //   = "LOW" - RZQ/6.
   parameter RTT_NOM               = "60",
                                     // RTT_NOM (ODT) (Mode Register 1).
                                     //   = "120" - RZQ/2,
                                     //   = "60"  - RZQ/4,
                                     //   = "40"  - RZQ/6.
   parameter RTT_WR                = "OFF",
                                     // RTT_WR (ODT) (Mode Register 2).
                                     // # = "OFF" - Dynamic ODT off,
                                     //   = "120" - RZQ/2,
                                     //   = "60"  - RZQ/4,
   parameter ADDR_CMD_MODE         = "1T" ,
                                     // # = "1T", "2T".
   parameter REG_CTRL              = "OFF",
                                     // # = "ON" - RDIMMs,
                                     //   = "OFF" - Components, SODIMMs, UDIMMs.
   parameter CA_MIRROR             = "OFF",
                                     // C/A mirror opt for DDR3 dual rank

   parameter VDD_OP_VOLT           = "150",
                                     // # = "150" - 1.5V Vdd Memory part
                                     //   = "135" - 1.35V Vdd Memory part

   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter CLKIN_PERIOD          = 5000,
                                     // Input Clock Period
   parameter CLKFBOUT_MULT         = 4,
                                     // write PLL VCO multiplier
   parameter DIVCLK_DIVIDE         = 1,
                                     // write PLL VCO divisor
   parameter CLKOUT0_PHASE         = 0.0,
                                     // Phase for PLL output clock (CLKOUT0)
   parameter CLKOUT0_DIVIDE        = 1,
                                     // VCO output divisor for PLL output clock (CLKOUT0)
   parameter CLKOUT1_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT1)
   parameter CLKOUT2_DIVIDE        = 32,
                                     // VCO output divisor for PLL output clock (CLKOUT2)
   parameter CLKOUT3_DIVIDE        = 8,
                                     // VCO output divisor for PLL output clock (CLKOUT3)
   parameter MMCM_VCO              = 800,
                                     // Max Freq (MHz) of MMCM VCO
   parameter MMCM_MULT_F           = 8,
                                     // write MMCM VCO multiplier
   parameter MMCM_DIVCLK_DIVIDE    = 1,
                                     // write MMCM VCO divisor

   //***************************************************************************
   // Memory Timing Parameters. These parameters varies based on the selected
   // memory part.
   //***************************************************************************
   parameter tCKE                  = 5000,
                                     // memory tCKE paramter in pS
   parameter tFAW                  = 40000,
                                     // memory tRAW paramter in pS.
   parameter tPRDI                 = 1_000_000,
                                     // memory tPRDI paramter in pS.
   parameter tRAS                  = 35000,
                                     // memory tRAS paramter in pS.
   parameter tRCD                  = 13750,
                                     // memory tRCD paramter in pS.
   parameter tREFI                 = 7800000,
                                     // memory tREFI paramter in pS.
   parameter tRFC                  = 260000,
                                     // memory tRFC paramter in pS.
   parameter tRP                   = 13750,
                                     // memory tRP paramter in pS.
   parameter tRRD                  = 7500,
                                     // memory tRRD paramter in pS.
   parameter tRTP                  = 7500,
                                     // memory tRTP paramter in pS.
   parameter tWTR                  = 7500,
                                     // memory tWTR paramter in pS.
   parameter tZQI                  = 128_000_000,
                                     // memory tZQI paramter in nS.
   parameter tZQCS                 = 64,//64,
                                     // memory tZQCS paramter in clock cycles.

   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter SIM_BYPASS_INIT_CAL   = "OFF",
                                     // # = "OFF" -  Complete memory init &
                                     //              calibration sequence
                                     // # = "SKIP" - Not supported
                                     // # = "FAST" - Complete memory init & use
                                     //              abbreviated calib sequence

   parameter SIMULATION            = "FALSE",
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // The following parameters varies based on the pin out entered in MIG GUI.
   // Do not change any of these parameters directly by editing the RTL.
   // Any changes required should be done through GUI and the design regenerated.
   //***************************************************************************
   parameter BYTE_LANES_B0         = 4'b1111,
                                     // Byte lanes used in an IO column.
   parameter BYTE_LANES_B1         = 4'b1110,
                                     // Byte lanes used in an IO column.
   parameter BYTE_LANES_B2         = 4'b0000,
                                     // Byte lanes used in an IO column.
   parameter BYTE_LANES_B3         = 4'b0000,
                                     // Byte lanes used in an IO column.
   parameter BYTE_LANES_B4         = 4'b0000,
                                     // Byte lanes used in an IO column.
   parameter DATA_CTL_B0           = 4'b1111,
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   parameter DATA_CTL_B1           = 4'b0000,
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   parameter DATA_CTL_B2           = 4'b0000,
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   parameter DATA_CTL_B3           = 4'b0000,
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   parameter DATA_CTL_B4           = 4'b0000,
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   parameter PHY_0_BITLANES        = 48'h3FE_3FE_1FF_2FF,
   parameter PHY_1_BITLANES        = 48'h3FF_FFF_0C0_000,
   parameter PHY_2_BITLANES        = 48'h000_000_000_000,

   // control/address/data pin mapping parameters
   parameter CK_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_13,
   parameter ADDR_MAP
     = 192'h000_130_138_134_135_132_137_136_139_133_131_128_124_125_126_122,
   parameter BANK_MAP   = 36'h123_12B_12A,
   parameter CAS_MAP    = 12'h120,
   parameter CKE_ODT_BYTE_MAP = 8'h00,
   parameter CKE_MAP    = 96'h000_000_000_000_000_000_000_117,
   parameter ODT_MAP    = 96'h000_000_000_000_000_000_000_116,
   parameter CS_MAP     = 120'h000_000_000_000_000_000_000_000_000_127,
   parameter PARITY_MAP = 12'h000,
   parameter RAS_MAP    = 12'h121,
   parameter WE_MAP     = 12'h129,
   parameter DQS_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01_02_03,
   parameter DATA0_MAP  = 96'h035_039_032_036_031_038_033_037,
   parameter DATA1_MAP  = 96'h021_029_025_028_024_027_022_023,
   parameter DATA2_MAP  = 96'h011_018_013_016_012_017_015_010,
   parameter DATA3_MAP  = 96'h005_001_000_003_004_007_009_006,
   parameter DATA4_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA5_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA6_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA7_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA8_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA9_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA10_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA11_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA12_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA13_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA14_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA15_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA16_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter DATA17_MAP = 96'h000_000_000_000_000_000_000_000,
   parameter MASK0_MAP  = 108'h000_000_000_000_000_002_014_026_034,
   parameter MASK1_MAP  = 108'h000_000_000_000_000_000_000_000_000,

   parameter SLOT_0_CONFIG         = 8'b0000_0001,
                                     // Mapping of Ranks.
   parameter SLOT_1_CONFIG         = 8'b0000_0000,
                                     // Mapping of Ranks.

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter IBUF_LPWR_MODE        = "OFF",
                                     // to phy_top
   parameter DATA_IO_IDLE_PWRDWN   = "ON",
                                     // # = "ON", "OFF"
   parameter BANK_TYPE             = "HR_IO",
                                     // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
   parameter DATA_IO_PRIM_TYPE     = "HR_LP",
                                     // # = "HP_LP", "HR_LP", "DEFAULT"
   parameter CKE_ODT_AUX           = "FALSE",
   parameter USER_REFRESH          = "OFF",
   parameter WRLVL                 = "ON",
                                     // # = "ON" - DDR3 SDRAM
                                     //   = "OFF" - DDR2 SDRAM.
   parameter ORDERING              = "NORM",
                                     // # = "NORM", "STRICT", "RELAXED".
   parameter CALIB_ROW_ADD         = 16'h0000,
                                     // Calibration row address will be used for
                                     // calibration read and write operations
   parameter CALIB_COL_ADD         = 12'h000,
                                     // Calibration column address will be used for
                                     // calibration read and write operations
   parameter CALIB_BA_ADD          = 3'h0,
                                     // Calibration bank address will be used for
                                     // calibration read and write operations
   parameter TCQ                   = 100,
   parameter IDELAY_ADJ            = "OFF",
   parameter FINE_PER_BIT          = "OFF",
   parameter CENTER_COMP_MODE      = "OFF",
   parameter PI_VAL_ADJ            = "OFF",
   parameter IODELAY_GRP0          = "DDR3_IODELAY_MIG0",
                                     // It is associated to a set of IODELAYs with
                                     // an IDELAYCTRL that have same IODELAY CONTROLLER
                                     // clock frequency (200MHz).
   parameter IODELAY_GRP1          = "DDR3_IODELAY_MIG1",
                                     // It is associated to a set of IODELAYs with
                                     // an IDELAYCTRL that have same IODELAY CONTROLLER
                                     // clock frequency (300MHz/400MHz).
   parameter SYSCLK_TYPE           = "NO_BUFFER",
                                     // System clock type DIFFERENTIAL, SINGLE_ENDED,
                                     // NO_BUFFER
   parameter REFCLK_TYPE           = "USE_SYSTEM_CLOCK",
                                     // Reference clock type DIFFERENTIAL, SINGLE_ENDED,
                                     // NO_BUFFER, USE_SYSTEM_CLOCK
   parameter SYS_RST_PORT          = "FALSE",
                                     // "TRUE" - if pin is selected for sys_rst
                                     //          and IBUF will be instantiated.
                                     // "FALSE" - if pin is not selected for sys_rst
   parameter FPGA_SPEED_GRADE      = 2,
                                     // FPGA speed grade
      
   parameter CMD_PIPE_PLUS1        = "ON",
                                     // add pipeline stage between MC and PHY
   parameter DRAM_TYPE             = "DDR3",
   parameter CAL_WIDTH             = "HALF",
   parameter STARVE_LIMIT          = 2,
                                     // # = 2,3,4.
   parameter REF_CLK_MMCM_IODELAY_CTRL    = "FALSE",
      

   //***************************************************************************
   // Referece clock frequency parameters
   //***************************************************************************
   parameter REFCLK_FREQ           = 200.0,
                                     // IODELAYCTRL reference clock frequency
   parameter DIFF_TERM_REFCLK      = "TRUE",
                                     // Differential Termination for idelay
                                     // reference clock input pins
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter tCK                   = 2500,
                                     // memory tCK paramter.
                                     // # = Clock Period in pS.
   parameter nCK_PER_CLK           = 4,
   // # of memory CKs per fabric CLK
   
   parameter DIFF_TERM_SYSCLK      = "TRUE",
                                     // Differential Termination for System
                                     // clock input pins
      

   

   //***************************************************************************
   // Debug parameters
   //***************************************************************************
   parameter DEBUG_PORT            = "OFF",
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.

   //***************************************************************************
   // Temparature monitor parameter
   //***************************************************************************
   parameter TEMP_MON_CONTROL      = "INTERNAL",
                                     // # = "INTERNAL", "EXTERNAL"
   //***************************************************************************
   // FPGA Voltage Type parameter
   //***************************************************************************
   parameter FPGA_VOLT_TYPE        = "N",
                                     // # = "L", "N". When FPGA VccINT is 0.9v,
                                     // the value is "L", else it is "N"
      
   parameter RST_ACT_LOW           = 1
                                     // =1 for active low reset,
                                     // =0 for active high.
   )
  (

   // Inouts
   inout [DQ_WIDTH-1:0]                         ddr3_dq,
   inout [DQS_WIDTH-1:0]                        ddr3_dqs_n,
   inout [DQS_WIDTH-1:0]                        ddr3_dqs_p,

   // Outputs
   output [ROW_WIDTH-1:0]                       ddr3_addr,
   output [BANK_WIDTH-1:0]                      ddr3_ba,
   output                                       ddr3_ras_n,
   output                                       ddr3_cas_n,
   output                                       ddr3_we_n,
   output                                       ddr3_reset_n,
   output [CK_WIDTH-1:0]                        ddr3_ck_p,
   output [CK_WIDTH-1:0]                        ddr3_ck_n,
   output [CKE_WIDTH-1:0]                       ddr3_cke,
   
   output [(CS_WIDTH*nCS_PER_RANK)-1:0]           ddr3_cs_n,
   
   output [DM_WIDTH-1:0]                        ddr3_dm,
   
   output [ODT_WIDTH-1:0]                       ddr3_odt,
   

   // Inputs
   
   // Single-ended system clock
   input                                        sys_clk_i,
   
   
   // user interface signals
   input [ADDR_WIDTH-1:0]                       app_addr,
   input [2:0]                                  app_cmd,
   input                                        app_en,
   input [(nCK_PER_CLK*2*PAYLOAD_WIDTH)-1:0]    app_wdf_data,
   input                                        app_wdf_end,
   input [((nCK_PER_CLK*2*PAYLOAD_WIDTH)/8)-1:0]  app_wdf_mask,
   input                                        app_wdf_wren,
   output [(nCK_PER_CLK*2*PAYLOAD_WIDTH)-1:0]   app_rd_data,
   output                                       app_rd_data_end,
   output                                       app_rd_data_valid,
   output                                       app_rdy,
   output                                       app_wdf_rdy,
   input                                        app_sr_req,
   input                                        app_ref_req,
   input                                        app_zq_req,
   output                                       app_sr_active,
   output                                       app_ref_ack,
   output                                       app_zq_ack,
   output                                       ui_clk,
   output                                       ui_clk_sync_rst,
   
   
      
   
   output                                       init_calib_complete,
   
   output [11:0]                                 device_temp,
`ifdef SKIP_CALIB
   output                                      calib_tap_req,
   input                                       calib_tap_load,
   input [6:0]                                 calib_tap_addr,
   input [7:0]                                 calib_tap_val,
   input                                       calib_tap_load_done,
`endif
      

   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                                        sys_rst
   );

  function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
  endfunction // clogb2


  localparam BM_CNT_WIDTH = clogb2(nBANK_MACHS);
  localparam RANK_WIDTH = clogb2(RANKS);

  localparam ECC_WIDTH = (ECC == "OFF")?
                           0 : (DATA_WIDTH <= 4)?
                            4 : (DATA_WIDTH <= 10)?
                             5 : (DATA_WIDTH <= 26)?
                              6 : (DATA_WIDTH <= 57)?
                               7 : (DATA_WIDTH <= 120)?
                                8 : (DATA_WIDTH <= 247)?
                                 9 : 10;
  localparam DATA_BUF_OFFSET_WIDTH = 1;
  localparam MC_ERR_ADDR_WIDTH = ((CS_WIDTH == 1) ? 0 : RANK_WIDTH)
                                 + BANK_WIDTH + ROW_WIDTH + COL_WIDTH
                                 + DATA_BUF_OFFSET_WIDTH;

  localparam APP_DATA_WIDTH        = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
  localparam APP_MASK_WIDTH        = APP_DATA_WIDTH / 8;
  localparam TEMP_MON_EN           = (SIMULATION == "FALSE") ? "ON" : "OFF";
                                                 // Enable or disable the temp monitor module
  localparam tTEMPSAMPLE           = 10000000;   // sample every 10 us
  localparam XADC_CLK_PERIOD       = 5000;       // Use 200 MHz IODELAYCTRL clock
  `ifdef SKIP_CALIB
  localparam SKIP_CALIB = "TRUE";
  `else
  localparam SKIP_CALIB = "FALSE";
  `endif
      

  localparam TAPSPERKCLK = (56*MMCM_MULT_F)/nCK_PER_CLK;
  

  // Wire declarations
      
  wire [BM_CNT_WIDTH-1:0]           bank_mach_next;
  wire                              clk;
  wire [1:0]                        clk_ref;
  wire [1:0]                        iodelay_ctrl_rdy;
  wire                              clk_ref_in;
  wire                              sys_rst_o;
  wire                              clk_div2;
  wire                              rst_div2;
  wire                              freq_refclk ;
  wire                              mem_refclk ;
  wire                              pll_lock ;
  wire                              sync_pulse;
  wire                              mmcm_ps_clk;
  wire                              poc_sample_pd;
  wire                              psen;
  wire                              psincdec;
  wire                              psdone;
  wire                              iddr_rst;
  wire                              ref_dll_lock;
  wire                              rst_phaser_ref;
  wire                              pll_locked;

  wire                              rst;
  
  wire [(2*nCK_PER_CLK)-1:0]            app_ecc_multiple_err;
  wire [(2*nCK_PER_CLK)-1:0]            app_ecc_single_err;
  wire                                ddr3_parity;
      

  wire                              sys_clk_p;
  wire                              sys_clk_n;
  wire                              mmcm_clk;
  wire                              clk_ref_p;
  wire                              clk_ref_n;
  wire                              clk_ref_i;
  wire [11:0]                       device_temp_s;
  wire [11:0]                       device_temp_i;

  // Debug port signals
  wire                              dbg_idel_down_all;
  wire                              dbg_idel_down_cpt;
  wire                              dbg_idel_up_all;
  wire                              dbg_idel_up_cpt;
  wire                              dbg_sel_all_idel_cpt;
  wire [DQS_CNT_WIDTH-1:0]          dbg_sel_idel_cpt;
  wire                              dbg_sel_pi_incdec;
  wire [DQS_CNT_WIDTH:0]            dbg_byte_sel;
  wire                              dbg_pi_f_inc;
  wire                              dbg_pi_f_dec;
  wire [5:0]                        dbg_pi_counter_read_val;
  wire [8:0]                        dbg_po_counter_read_val;

  wire [(6*DQS_WIDTH*RANKS)-1:0]      dbg_cpt_tap_cnt;
  wire [(5*DQS_WIDTH*RANKS)-1:0]      dbg_dq_idelay_tap_cnt;
  wire [255:0]                      dbg_calib_top;
  wire [(6*DQS_WIDTH*RANKS)-1:0]      dbg_cpt_first_edge_cnt;
  wire [(6*DQS_WIDTH*RANKS)-1:0]      dbg_cpt_second_edge_cnt;
  wire [(6*RANKS)-1:0]                dbg_rd_data_offset;
  wire [255:0]                      dbg_phy_rdlvl;
  wire [99:0]                       dbg_phy_wrcal;
  wire [(6*DQS_WIDTH)-1:0]            dbg_final_po_fine_tap_cnt;
  wire [(3*DQS_WIDTH)-1:0]            dbg_final_po_coarse_tap_cnt;
  wire [255:0]                      dbg_phy_wrlvl;
  wire [255:0]                      dbg_phy_init;
  wire [255:0]                      dbg_prbs_rdlvl;
  wire [255:0]                      dbg_dqs_found_cal;
  wire                              dbg_pi_phaselock_start;
  wire                              dbg_pi_phaselocked_done;
  wire                              dbg_pi_phaselock_err;
  wire                              dbg_pi_dqsfound_start;
  wire                              dbg_pi_dqsfound_done;
  wire                              dbg_pi_dqsfound_err;
  wire                              dbg_wrcal_start;
  wire                              dbg_wrcal_done;
  wire                              dbg_wrcal_err;
  wire [11:0]                       dbg_pi_dqs_found_lanes_phy4lanes;
  wire [11:0]                       dbg_pi_phase_locked_phy4lanes;
  wire                              dbg_oclkdelay_calib_start;
  wire                              dbg_oclkdelay_calib_done;
  wire [255:0]                      dbg_phy_oclkdelay_cal;
  wire [(DRAM_WIDTH*16)-1:0]         dbg_oclkdelay_rd_data;
  wire [DQS_WIDTH-1:0]              dbg_rd_data_edge_detect;
  wire [(2*nCK_PER_CLK*DQ_WIDTH)-1:0] dbg_rddata;
  wire                              dbg_rddata_valid;
  wire [1:0]                        dbg_rdlvl_done;
  wire [1:0]                        dbg_rdlvl_err;
  wire [1:0]                        dbg_rdlvl_start;
  wire [(6*DQS_WIDTH)-1:0]            dbg_wrlvl_fine_tap_cnt;
  wire [(3*DQS_WIDTH)-1:0]            dbg_wrlvl_coarse_tap_cnt;
  wire [5:0]                        dbg_tap_cnt_during_wrlvl;
  wire                              dbg_wl_edge_detect_valid;
  wire                              dbg_wrlvl_done;
  wire                              dbg_wrlvl_err;
  wire                              dbg_wrlvl_start;
  reg [63:0]                        dbg_rddata_r;
  reg                               dbg_rddata_valid_r;
  wire [53:0]                       ocal_tap_cnt;
  wire [4:0]                        dbg_dqs;
  wire [8:0]                        dbg_bit;
  wire [8:0]                        rd_data_edge_detect_r;
  wire [53:0]                       wl_po_fine_cnt;
  wire [26:0]                       wl_po_coarse_cnt;
  wire [(6*RANKS)-1:0]                dbg_calib_rd_data_offset_1;
  wire [(6*RANKS)-1:0]                dbg_calib_rd_data_offset_2;
  wire [5:0]                        dbg_data_offset;
  wire [5:0]                        dbg_data_offset_1;
  wire [5:0]                        dbg_data_offset_2;

  wire [390:0]                      ddr3_ila_wrpath_int;
  wire [1023:0]                     ddr3_ila_rdpath_int;
  wire [119:0]                      ddr3_ila_basic_int;
  wire [(6*DQS_WIDTH*RANKS)-1:0] dbg_prbs_final_dqs_tap_cnt_r_int;
  wire [(6*DQS_WIDTH*RANKS)-1:0] dbg_prbs_first_edge_taps_int;
  wire [(6*DQS_WIDTH*RANKS)-1:0] dbg_prbs_second_edge_taps_int;
      

//***************************************************************************



  assign ui_clk = clk;
  assign ui_clk_sync_rst = rst;
  
  assign sys_clk_p = 1'b0;
  assign sys_clk_n = 1'b0;
  assign clk_ref_i = 1'b0;
  assign device_temp = device_temp_s;
      

  generate
    if (REFCLK_TYPE == "USE_SYSTEM_CLOCK")
      assign clk_ref_in = mmcm_clk;
    else
      assign clk_ref_in = clk_ref_i;
  endgenerate

  mig_7series_v4_2_iodelay_ctrl #
    (
     .TCQ                       (TCQ),
     .IODELAY_GRP0              (IODELAY_GRP0),
     .IODELAY_GRP1              (IODELAY_GRP1),
     .REFCLK_TYPE               (REFCLK_TYPE),
     .SYSCLK_TYPE               (SYSCLK_TYPE),
     .SYS_RST_PORT              (SYS_RST_PORT),
     .RST_ACT_LOW               (RST_ACT_LOW),
     .DIFF_TERM_REFCLK          (DIFF_TERM_REFCLK),
     .FPGA_SPEED_GRADE          (FPGA_SPEED_GRADE),
     .REF_CLK_MMCM_IODELAY_CTRL (REF_CLK_MMCM_IODELAY_CTRL)
     )
    u_iodelay_ctrl
      (
       // Outputs
       .iodelay_ctrl_rdy (iodelay_ctrl_rdy),
       .sys_rst_o        (sys_rst_o),
       .clk_ref          (clk_ref),
       // Inputs
       .clk_ref_p        (clk_ref_p),
       .clk_ref_n        (clk_ref_n),
       .clk_ref_i        (clk_ref_in),
       .sys_rst          (sys_rst)
       );
  mig_7series_v4_2_clk_ibuf #
    (
     .SYSCLK_TYPE      (SYSCLK_TYPE),
     .DIFF_TERM_SYSCLK (DIFF_TERM_SYSCLK)
     )
    u_ddr3_clk_ibuf
      (
       .sys_clk_p        (sys_clk_p),
       .sys_clk_n        (sys_clk_n),
       .sys_clk_i        (sys_clk_i),
       .mmcm_clk         (mmcm_clk)
       );
  // Temperature monitoring logic

  generate
    if (TEMP_MON_EN == "ON") begin: temp_mon_enabled

      mig_7series_v4_2_tempmon #
        (
         .TCQ              (TCQ),
         .TEMP_MON_CONTROL (TEMP_MON_CONTROL),
         .XADC_CLK_PERIOD  (XADC_CLK_PERIOD),
         .tTEMPSAMPLE      (tTEMPSAMPLE)
         )
        u_tempmon
          (
           .clk            (clk),
           .xadc_clk       (clk_ref[0]),
           .rst            (rst),
           .device_temp_i  (device_temp_i),
           .device_temp    (device_temp_s)
          );
    end else begin: temp_mon_disabled

      assign device_temp_s = 'b0;

    end
  endgenerate
         
  mig_7series_v4_2_infrastructure #
    (
     .TCQ                (TCQ),
     .nCK_PER_CLK        (nCK_PER_CLK),
     .CLKIN_PERIOD       (CLKIN_PERIOD),
     .SYSCLK_TYPE        (SYSCLK_TYPE),
     .CLKFBOUT_MULT      (CLKFBOUT_MULT),
     .DIVCLK_DIVIDE      (DIVCLK_DIVIDE),
     .CLKOUT0_PHASE      (CLKOUT0_PHASE),
     .CLKOUT0_DIVIDE     (CLKOUT0_DIVIDE),
     .CLKOUT1_DIVIDE     (CLKOUT1_DIVIDE),
     .CLKOUT2_DIVIDE     (CLKOUT2_DIVIDE),
     .CLKOUT3_DIVIDE     (CLKOUT3_DIVIDE),
     .MMCM_VCO           (MMCM_VCO),
     .MMCM_MULT_F        (MMCM_MULT_F),
     .MMCM_DIVCLK_DIVIDE (MMCM_DIVCLK_DIVIDE),
     .RST_ACT_LOW        (RST_ACT_LOW),
     .tCK                (tCK),
     .MEM_TYPE           (DRAM_TYPE)
     )
    u_ddr3_infrastructure
      (
       // Outputs
       .rstdiv0          (rst),
       .clk              (clk),
       .clk_div2         (clk_div2),
       .rst_div2         (rst_div2),
       .mem_refclk       (mem_refclk),
       .freq_refclk      (freq_refclk),
       .sync_pulse       (sync_pulse),
       .mmcm_ps_clk      (mmcm_ps_clk),
       .poc_sample_pd    (poc_sample_pd),
       .psdone           (psdone),
       .iddr_rst         (iddr_rst),
//       .auxout_clk       (),
       .ui_addn_clk_0    (),
       .ui_addn_clk_1    (),
       .ui_addn_clk_2    (),
       .ui_addn_clk_3    (),
       .ui_addn_clk_4    (),
       .pll_locked       (pll_locked),
       .mmcm_locked      (),
       .rst_phaser_ref   (rst_phaser_ref),
       // Inputs
       .psen             (psen),
       .psincdec         (psincdec),
       .mmcm_clk         (mmcm_clk),
       .sys_rst          (sys_rst_o),
       .iodelay_ctrl_rdy (iodelay_ctrl_rdy),
       .ref_dll_lock     (ref_dll_lock)
       );
      

  mig_7series_v4_2_memc_ui_top_std #
    (
     .TCQ                              (TCQ),
     .ADDR_CMD_MODE                    (ADDR_CMD_MODE),
     .AL                               (AL),
     .PAYLOAD_WIDTH                    (PAYLOAD_WIDTH),
     .BANK_WIDTH                       (BANK_WIDTH),
     .BM_CNT_WIDTH                     (BM_CNT_WIDTH),
     .BURST_MODE                       (BURST_MODE),
     .BURST_TYPE                       (BURST_TYPE),
     .CA_MIRROR                        (CA_MIRROR),
     .DDR3_VDD_OP_VOLT                 (VDD_OP_VOLT),
     .CK_WIDTH                         (CK_WIDTH),
     .COL_WIDTH                        (COL_WIDTH),
     .CMD_PIPE_PLUS1                   (CMD_PIPE_PLUS1),
     .CS_WIDTH                         (CS_WIDTH),
     .nCS_PER_RANK                     (nCS_PER_RANK),
     .CKE_WIDTH                        (CKE_WIDTH),
     .DATA_WIDTH                       (DATA_WIDTH),
     .DATA_BUF_ADDR_WIDTH              (DATA_BUF_ADDR_WIDTH),
     .DM_WIDTH                         (DM_WIDTH),
     .DQ_CNT_WIDTH                     (DQ_CNT_WIDTH),
     .DQ_WIDTH                         (DQ_WIDTH),
     .DQS_CNT_WIDTH                    (DQS_CNT_WIDTH),
     .DQS_WIDTH                        (DQS_WIDTH),
     .DRAM_TYPE                        (DRAM_TYPE),
     .DRAM_WIDTH                       (DRAM_WIDTH),
     .ECC                              (ECC),
     .ECC_WIDTH                        (ECC_WIDTH),
     .ECC_TEST                         (ECC_TEST),
     .MC_ERR_ADDR_WIDTH                (MC_ERR_ADDR_WIDTH),
     .REFCLK_FREQ                      (REFCLK_FREQ),
     .nAL                              (nAL),
     .nBANK_MACHS                      (nBANK_MACHS),
     .CKE_ODT_AUX                      (CKE_ODT_AUX),
     .nCK_PER_CLK                      (nCK_PER_CLK),
     .ORDERING                         (ORDERING),
     .OUTPUT_DRV                       (OUTPUT_DRV),
     .IBUF_LPWR_MODE                   (IBUF_LPWR_MODE),
     .DATA_IO_IDLE_PWRDWN              (DATA_IO_IDLE_PWRDWN),
     .BANK_TYPE                        (BANK_TYPE),
     .DATA_IO_PRIM_TYPE                (DATA_IO_PRIM_TYPE),
     .IODELAY_GRP0                     (IODELAY_GRP0),
     .IODELAY_GRP1                     (IODELAY_GRP1),
     .FPGA_SPEED_GRADE                 (FPGA_SPEED_GRADE),
     .REG_CTRL                         (REG_CTRL),
     .RTT_NOM                          (RTT_NOM),
     .RTT_WR                           (RTT_WR),
     .CL                               (CL),
     .CWL                              (CWL),
     .tCK                              (tCK),
     .tCKE                             (tCKE),
     .tFAW                             (tFAW),
     .tPRDI                            (tPRDI),
     .tRAS                             (tRAS),
     .tRCD                             (tRCD),
     .tREFI                            (tREFI),
     .tRFC                             (tRFC),
     .tRP                              (tRP),
     .tRRD                             (tRRD),
     .tRTP                             (tRTP),
     .tWTR                             (tWTR),
     .tZQI                             (tZQI),
     .tZQCS                            (tZQCS),
     .USER_REFRESH                     (USER_REFRESH),
     .TEMP_MON_EN                      (TEMP_MON_EN),
     .WRLVL                            (WRLVL),
     .DEBUG_PORT                       (DEBUG_PORT),
     .CAL_WIDTH                        (CAL_WIDTH),
     .RANK_WIDTH                       (RANK_WIDTH),
     .RANKS                            (RANKS),
     .ODT_WIDTH                        (ODT_WIDTH),
     .ROW_WIDTH                        (ROW_WIDTH),
     .ADDR_WIDTH                       (ADDR_WIDTH),
     .APP_DATA_WIDTH                   (APP_DATA_WIDTH),
     .APP_MASK_WIDTH                   (APP_MASK_WIDTH),
     .SIM_BYPASS_INIT_CAL              (SIM_BYPASS_INIT_CAL),
     .BYTE_LANES_B0                    (BYTE_LANES_B0),
     .BYTE_LANES_B1                    (BYTE_LANES_B1),
     .BYTE_LANES_B2                    (BYTE_LANES_B2),
     .BYTE_LANES_B3                    (BYTE_LANES_B3),
     .BYTE_LANES_B4                    (BYTE_LANES_B4),
     .DATA_CTL_B0                      (DATA_CTL_B0),
     .DATA_CTL_B1                      (DATA_CTL_B1),
     .DATA_CTL_B2                      (DATA_CTL_B2),
     .DATA_CTL_B3                      (DATA_CTL_B3),
     .DATA_CTL_B4                      (DATA_CTL_B4),
     .PHY_0_BITLANES                   (PHY_0_BITLANES),
     .PHY_1_BITLANES                   (PHY_1_BITLANES),
     .PHY_2_BITLANES                   (PHY_2_BITLANES),
     .CK_BYTE_MAP                      (CK_BYTE_MAP),
     .ADDR_MAP                         (ADDR_MAP),
     .BANK_MAP                         (BANK_MAP),
     .CAS_MAP                          (CAS_MAP),
     .CKE_ODT_BYTE_MAP                 (CKE_ODT_BYTE_MAP),
     .CKE_MAP                          (CKE_MAP),
     .ODT_MAP                          (ODT_MAP),
     .CS_MAP                           (CS_MAP),
     .PARITY_MAP                       (PARITY_MAP),
     .RAS_MAP                          (RAS_MAP),
     .WE_MAP                           (WE_MAP),
     .DQS_BYTE_MAP                     (DQS_BYTE_MAP),
     .DATA0_MAP                        (DATA0_MAP),
     .DATA1_MAP                        (DATA1_MAP),
     .DATA2_MAP                        (DATA2_MAP),
     .DATA3_MAP                        (DATA3_MAP),
     .DATA4_MAP                        (DATA4_MAP),
     .DATA5_MAP                        (DATA5_MAP),
     .DATA6_MAP                        (DATA6_MAP),
     .DATA7_MAP                        (DATA7_MAP),
     .DATA8_MAP                        (DATA8_MAP),
     .DATA9_MAP                        (DATA9_MAP),
     .DATA10_MAP                       (DATA10_MAP),
     .DATA11_MAP                       (DATA11_MAP),
     .DATA12_MAP                       (DATA12_MAP),
     .DATA13_MAP                       (DATA13_MAP),
     .DATA14_MAP                       (DATA14_MAP),
     .DATA15_MAP                       (DATA15_MAP),
     .DATA16_MAP                       (DATA16_MAP),
     .DATA17_MAP                       (DATA17_MAP),
     .MASK0_MAP                        (MASK0_MAP),
     .MASK1_MAP                        (MASK1_MAP),
     .CALIB_ROW_ADD                    (CALIB_ROW_ADD),
     .CALIB_COL_ADD                    (CALIB_COL_ADD),
     .CALIB_BA_ADD                     (CALIB_BA_ADD),
     .IDELAY_ADJ                       (IDELAY_ADJ),
     .FINE_PER_BIT                     (FINE_PER_BIT),
     .CENTER_COMP_MODE                 (CENTER_COMP_MODE),
     .PI_VAL_ADJ                       (PI_VAL_ADJ),
     .SLOT_0_CONFIG                    (SLOT_0_CONFIG),
     .SLOT_1_CONFIG                    (SLOT_1_CONFIG),
     .MEM_ADDR_ORDER                   (MEM_ADDR_ORDER),
     .STARVE_LIMIT                     (STARVE_LIMIT),
     .USE_CS_PORT                      (USE_CS_PORT),
     .USE_DM_PORT                      (USE_DM_PORT),
     .USE_ODT_PORT                     (USE_ODT_PORT),
     .MASTER_PHY_CTL                   (PHY_CONTROL_MASTER_BANK),
     .TAPSPERKCLK                      (TAPSPERKCLK),
     .SKIP_CALIB                       (SKIP_CALIB),
     .FPGA_VOLT_TYPE                   (FPGA_VOLT_TYPE)
     )
    u_memc_ui_top_std
      (
       .clk                              (clk),
       .clk_div2                         (clk_div2),
       .rst_div2                         (rst_div2),
       .clk_ref                          (clk_ref),
       .mem_refclk                       (mem_refclk), //memory clock
       .freq_refclk                      (freq_refclk),
       .pll_lock                         (pll_locked),
       .sync_pulse                       (sync_pulse),
       .mmcm_ps_clk                      (mmcm_ps_clk),
       .poc_sample_pd                    (poc_sample_pd),
       .psdone                           (psdone),
       .iddr_rst                         (iddr_rst),
       .psen                             (psen),
       .psincdec                         (psincdec),
       .rst                              (rst),
       .rst_phaser_ref                   (rst_phaser_ref),
       .ref_dll_lock                     (ref_dll_lock),

// Memory interface ports
       .ddr_dq                           (ddr3_dq),
       .ddr_dqs_n                        (ddr3_dqs_n),
       .ddr_dqs                          (ddr3_dqs_p),
       .ddr_addr                         (ddr3_addr),
       .ddr_ba                           (ddr3_ba),
       .ddr_cas_n                        (ddr3_cas_n),
       .ddr_ck_n                         (ddr3_ck_n),
       .ddr_ck                           (ddr3_ck_p),
       .ddr_cke                          (ddr3_cke),
       .ddr_cs_n                         (ddr3_cs_n),
       .ddr_dm                           (ddr3_dm),
       .ddr_odt                          (ddr3_odt),
       .ddr_ras_n                        (ddr3_ras_n),
       .ddr_reset_n                      (ddr3_reset_n),
       .ddr_parity                       (ddr3_parity),
       .ddr_we_n                         (ddr3_we_n),
       .bank_mach_next                   (bank_mach_next),

// Application interface ports
       .app_addr                         (app_addr),
       .app_cmd                          (app_cmd),
       .app_en                           (app_en),
       .app_hi_pri                       (1'b0),
       .app_wdf_data                     (app_wdf_data),
       .app_wdf_end                      (app_wdf_end),
       .app_wdf_mask                     (app_wdf_mask),
       .app_wdf_wren                     (app_wdf_wren),
       .app_ecc_multiple_err             (app_ecc_multiple_err),
       .app_ecc_single_err               (app_ecc_single_err),
       .app_rd_data                      (app_rd_data),
       .app_rd_data_end                  (app_rd_data_end),
       .app_rd_data_valid                (app_rd_data_valid),
       .app_rdy                          (app_rdy),
       .app_wdf_rdy                      (app_wdf_rdy),
       .app_sr_req                       (app_sr_req),
       .app_sr_active                    (app_sr_active),
       .app_ref_req                      (app_ref_req),
       .app_ref_ack                      (app_ref_ack),
       .app_zq_req                       (app_zq_req),
       .app_zq_ack                       (app_zq_ack),
       .app_raw_not_ecc                  ({2*nCK_PER_CLK{1'b0}}),
       .app_correct_en_i                 (1'b1),

       .device_temp                      (device_temp_s),

       // skip calibration ports
       `ifdef SKIP_CALIB
       .calib_tap_req                    (calib_tap_req),
       .calib_tap_load                   (calib_tap_load),
       .calib_tap_addr                   (calib_tap_addr),
       .calib_tap_val                    (calib_tap_val),
       .calib_tap_load_done              (calib_tap_load_done),
       `else
       .calib_tap_req                    (),
       .calib_tap_load                   (1'b0),
       .calib_tap_addr                   (7'b0),
       .calib_tap_val                    (8'b0),
       .calib_tap_load_done              (1'b0),
       `endif

// Debug logic ports
       .dbg_idel_up_all                  (dbg_idel_up_all),
       .dbg_idel_down_all                (dbg_idel_down_all),
       .dbg_idel_up_cpt                  (dbg_idel_up_cpt),
       .dbg_idel_down_cpt                (dbg_idel_down_cpt),
       .dbg_sel_idel_cpt                 (dbg_sel_idel_cpt),
       .dbg_sel_all_idel_cpt             (dbg_sel_all_idel_cpt),
       .dbg_sel_pi_incdec                (dbg_sel_pi_incdec),
       .dbg_sel_po_incdec                (dbg_sel_po_incdec),
       .dbg_byte_sel                     (dbg_byte_sel),
       .dbg_pi_f_inc                     (dbg_pi_f_inc),
       .dbg_pi_f_dec                     (dbg_pi_f_dec),
       .dbg_po_f_inc                     (dbg_po_f_inc),
       .dbg_po_f_stg23_sel               (dbg_po_f_stg23_sel),
       .dbg_po_f_dec                     (dbg_po_f_dec),
       .dbg_cpt_tap_cnt                  (dbg_cpt_tap_cnt),
       .dbg_dq_idelay_tap_cnt            (dbg_dq_idelay_tap_cnt),
       .dbg_calib_top                    (dbg_calib_top),
       .dbg_cpt_first_edge_cnt           (dbg_cpt_first_edge_cnt),
       .dbg_cpt_second_edge_cnt          (dbg_cpt_second_edge_cnt),
       .dbg_rd_data_offset               (dbg_rd_data_offset),
       .dbg_phy_rdlvl                    (dbg_phy_rdlvl),
       .dbg_phy_wrcal                    (dbg_phy_wrcal),
       .dbg_final_po_fine_tap_cnt        (dbg_final_po_fine_tap_cnt),
       .dbg_final_po_coarse_tap_cnt      (dbg_final_po_coarse_tap_cnt),
       .dbg_rd_data_edge_detect          (dbg_rd_data_edge_detect),
       .dbg_rddata                       (dbg_rddata),
       .dbg_rddata_valid                 (dbg_rddata_valid),
       .dbg_rdlvl_done                   (dbg_rdlvl_done),
       .dbg_rdlvl_err                    (dbg_rdlvl_err),
       .dbg_rdlvl_start                  (dbg_rdlvl_start),
       .dbg_wrlvl_fine_tap_cnt           (dbg_wrlvl_fine_tap_cnt),
       .dbg_wrlvl_coarse_tap_cnt         (dbg_wrlvl_coarse_tap_cnt),
       .dbg_tap_cnt_during_wrlvl         (dbg_tap_cnt_during_wrlvl),
       .dbg_wl_edge_detect_valid         (dbg_wl_edge_detect_valid),
       .dbg_wrlvl_done                   (dbg_wrlvl_done),
       .dbg_wrlvl_err                    (dbg_wrlvl_err),
       .dbg_wrlvl_start                  (dbg_wrlvl_start),
       .dbg_phy_wrlvl                    (dbg_phy_wrlvl),
       .dbg_phy_init                     (dbg_phy_init),
       .dbg_prbs_rdlvl                   (dbg_prbs_rdlvl),
       .dbg_pi_counter_read_val          (dbg_pi_counter_read_val),
       .dbg_po_counter_read_val          (dbg_po_counter_read_val),
       .dbg_prbs_final_dqs_tap_cnt_r     (dbg_prbs_final_dqs_tap_cnt_r_int),
       .dbg_prbs_first_edge_taps         (dbg_prbs_first_edge_taps_int),
       .dbg_prbs_second_edge_taps        (dbg_prbs_second_edge_taps_int),
       .dbg_pi_phaselock_start           (dbg_pi_phaselock_start),
       .dbg_pi_phaselocked_done          (dbg_pi_phaselocked_done),
       .dbg_pi_phaselock_err             (dbg_pi_phaselock_err),
       .dbg_pi_phase_locked_phy4lanes    (dbg_pi_phase_locked_phy4lanes),
       .dbg_pi_dqsfound_start            (dbg_pi_dqsfound_start),
       .dbg_pi_dqsfound_done             (dbg_pi_dqsfound_done),
       .dbg_pi_dqsfound_err              (dbg_pi_dqsfound_err),
       .dbg_pi_dqs_found_lanes_phy4lanes (dbg_pi_dqs_found_lanes_phy4lanes),
       .dbg_calib_rd_data_offset_1       (dbg_calib_rd_data_offset_1),
       .dbg_calib_rd_data_offset_2       (dbg_calib_rd_data_offset_2),
       .dbg_data_offset                  (dbg_data_offset),
       .dbg_data_offset_1                (dbg_data_offset_1),
       .dbg_data_offset_2                (dbg_data_offset_2),
       .dbg_wrcal_start                  (dbg_wrcal_start),
       .dbg_wrcal_done                   (dbg_wrcal_done),
       .dbg_wrcal_err                    (dbg_wrcal_err),
       .dbg_phy_oclkdelay_cal            (dbg_phy_oclkdelay_cal),
       .dbg_oclkdelay_rd_data            (dbg_oclkdelay_rd_data),
       .dbg_oclkdelay_calib_start        (dbg_oclkdelay_calib_start),
       .dbg_oclkdelay_calib_done         (dbg_oclkdelay_calib_done),
       .dbg_dqs_found_cal                (dbg_dqs_found_cal),  
       .init_calib_complete              (init_calib_complete),
       .dbg_poc                          ()
       );

      




   //*********************************************************************
   // Resetting all RTL debug inputs as the debug ports are not enabled
   //*********************************************************************
   assign dbg_idel_down_all    = 1'b0;
   assign dbg_idel_down_cpt    = 1'b0;
   assign dbg_idel_up_all      = 1'b0;
   assign dbg_idel_up_cpt      = 1'b0;
   assign dbg_sel_all_idel_cpt = 1'b0;
   assign dbg_sel_idel_cpt     = 'b0;
   assign dbg_byte_sel         = 'd0;
   assign dbg_sel_pi_incdec    = 1'b0;
   assign dbg_pi_f_inc         = 1'b0;
   assign dbg_pi_f_dec         = 1'b0;
   assign dbg_po_f_inc         = 'b0;
   assign dbg_po_f_dec         = 'b0;
   assign dbg_po_f_stg23_sel   = 'b0;
   assign dbg_sel_po_incdec    = 'b0;

      

endmodule


