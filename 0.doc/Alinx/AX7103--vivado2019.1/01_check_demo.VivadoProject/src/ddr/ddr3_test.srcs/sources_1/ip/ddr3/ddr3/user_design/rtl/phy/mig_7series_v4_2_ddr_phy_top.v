//*****************************************************************************
// (c) Copyright 2008 - 2014 Xilinx, Inc. All rights reserved.
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
// \   \   \/     Version               : 4.2
//  \   \         Application           : MIG
//  /   /         Filename              : ddr_phy_top.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Aug 03 2009
//  \___\/\___\
//
//Device            : 7 Series
//Design Name       : DDR3 SDRAM
//Purpose           : Top level memory interface block. Instantiates a clock
//                    and reset generator, the memory controller, the phy and
//                    the user interface blocks.
//Reference         :
//Revision History  :
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_ddr_phy_top #
  (
   parameter TCQ             = 100,     // Register delay (simulation only)
   parameter DDR3_VDD_OP_VOLT = 135,     // Voltage mode used for DDR3
   parameter AL              = "0",     // Additive Latency option
   parameter BANK_WIDTH      = 3,       // # of bank bits
   parameter BURST_MODE      = "8",     // Burst length
   parameter BURST_TYPE      = "SEQ",   // Burst type
   parameter CA_MIRROR       = "OFF",   // C/A mirror opt for DDR3 dual rank
   parameter CK_WIDTH        = 1,       // # of CK/CK# outputs to memory
   parameter CL              = 5,
   parameter COL_WIDTH       = 12,      // column address width
   parameter CS_WIDTH        = 1,       // # of unique CS outputs
   parameter CKE_WIDTH       = 1,       // # of cke outputs
   parameter CWL             = 5,
   parameter DM_WIDTH        = 8,       // # of DM (data mask)
   parameter DQ_WIDTH        = 64,      // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,       // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,       // # of DQS (strobe)
   parameter DRAM_TYPE       = "DDR3",
   parameter DRAM_WIDTH      = 8,       // # of DQ per DQS
   parameter MASTER_PHY_CTL  = 0,       // The bank number where master PHY_CONTROL resides
   parameter LP_DDR_CK_WIDTH = 2,

   // Hard PHY parameters
   parameter PHYCTL_CMD_FIFO = "FALSE",
   // five fields, one per possible I/O bank, 4 bits in each field,
   // 1 per lane data=1/ctl=0
   parameter DATA_CTL_B0     = 4'hc,
   parameter DATA_CTL_B1     = 4'hf,
   parameter DATA_CTL_B2     = 4'hf,
   parameter DATA_CTL_B3     = 4'hf,
   parameter DATA_CTL_B4     = 4'hf,
   // defines the byte lanes in I/O banks being used in the interface
   // 1- Used, 0- Unused
   parameter BYTE_LANES_B0   = 4'b1111,
   parameter BYTE_LANES_B1   = 4'b0000,
   parameter BYTE_LANES_B2   = 4'b0000,
   parameter BYTE_LANES_B3   = 4'b0000,
   parameter BYTE_LANES_B4   = 4'b0000,
   // defines the bit lanes in I/O banks being used in the interface. Each
   // parameter = 1 I/O bank = 4 byte lanes = 48 bit lanes. 1-Used, 0-Unused
   parameter PHY_0_BITLANES  = 48'h0000_0000_0000,
   parameter PHY_1_BITLANES  = 48'h0000_0000_0000,
   parameter PHY_2_BITLANES  = 48'h0000_0000_0000,

   // control/address/data pin mapping parameters
   parameter CK_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00,
   parameter ADDR_MAP
     = 192'h000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000,
   parameter BANK_MAP   = 36'h000_000_000,
   parameter CAS_MAP    = 12'h000,
   parameter CKE_ODT_BYTE_MAP = 8'h00,
   parameter CKE_MAP    = 96'h000_000_000_000_000_000_000_000,
   parameter ODT_MAP    = 96'h000_000_000_000_000_000_000_000,
   parameter CKE_ODT_AUX = "FALSE",
   parameter CS_MAP     = 120'h000_000_000_000_000_000_000_000_000_000,
   parameter PARITY_MAP = 12'h000,
   parameter RAS_MAP    = 12'h000,
   parameter WE_MAP     = 12'h000,
   parameter DQS_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00,
   parameter DATA0_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA1_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA2_MAP  = 96'h000_000_000_000_000_000_000_000,
   parameter DATA3_MAP  = 96'h000_000_000_000_000_000_000_000,
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
   parameter MASK0_MAP  = 108'h000_000_000_000_000_000_000_000_000,
   parameter MASK1_MAP  = 108'h000_000_000_000_000_000_000_000_000,

   // This parameter must be set based on memory clock frequency
   // It must be set to 4 for frequencies above 533 MHz?? (undecided)
   // and set to 2 for 533 MHz and below
   parameter PRE_REV3ES      = "OFF",   // Delay O/Ps using Phaser_Out fine dly
   parameter nCK_PER_CLK     = 2,       // # of memory CKs per fabric CLK
   parameter nCS_PER_RANK    = 1,       // # of unique CS outputs per rank
   parameter ADDR_CMD_MODE   = "1T",    // ADDR/CTRL timing: "2T", "1T"
   parameter BANK_TYPE       = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
   parameter DATA_IO_PRIM_TYPE = "DEFAULT", // # = "HP_LP", "HR_LP", "DEFAULT"
   parameter DATA_IO_IDLE_PWRDWN = "ON",  // "ON" or "OFF"
   parameter IODELAY_GRP     = "IODELAY_MIG",
   parameter FPGA_SPEED_GRADE = 1,
   parameter IBUF_LPWR_MODE  = "OFF",   // input buffer low power option
   parameter OUTPUT_DRV      = "HIGH",  // to calib_top
   parameter REG_CTRL        = "OFF",   // to calib_top
   parameter RTT_NOM         = "60",    // to calib_top
   parameter RTT_WR          = "120",   // to calib_top
   parameter tCK             = 2500,    // pS
   parameter tRFC            = 110000,  // pS
   parameter tREFI           = 7800000, // pS
   parameter DDR2_DQSN_ENABLE = "YES",  // Enable differential DQS for DDR2
   parameter WRLVL           = "OFF",   // to calib_top
   parameter DEBUG_PORT      = "OFF",   // to calib_top
   parameter RANKS           = 4,
   parameter ODT_WIDTH       = 1,
   parameter ROW_WIDTH       = 16,      // DRAM address bus width
   parameter [7:0] SLOT_1_CONFIG = 8'b0000_0000,
   // calibration Address. The address given below will be used for calibration
   // read and write operations.
   parameter CALIB_ROW_ADD   = 16'h0000,// Calibration row address
   parameter CALIB_COL_ADD   = 12'h000, // Calibration column address
   parameter CALIB_BA_ADD    = 3'h0,    // Calibration bank address
   // Simulation /debug options
   parameter SIM_BYPASS_INIT_CAL = "OFF",
                                        // Parameter used to force skipping
                                        // or abbreviation of initialization
                                        // and calibration. Overrides
                                        // SIM_INIT_OPTION, SIM_CAL_OPTION,
                                        // and disables various other blocks
   //parameter SIM_INIT_OPTION = "SKIP_PU_DLY", // Skip various init steps
   //parameter SIM_CAL_OPTION  = "NONE",        // Skip various calib steps
   parameter REFCLK_FREQ     = 200.0,         // IODELAY ref clock freq (MHz)
   parameter USE_CS_PORT     = 1,             // Support chip select output
   parameter USE_DM_PORT     = 1,             // Support data mask output
   parameter USE_ODT_PORT    = 1,             // Support ODT output
   parameter RD_PATH_REG     = 0,              // optional registers in the read path
                                              // to MC for timing improvement.
                                              // =1 enabled, = 0 disabled
   parameter IDELAY_ADJ       = "ON",          //ON : IDELAY-1, OFF: No change
   parameter FINE_PER_BIT     = "ON",          //ON : Use per bit calib for complex rdlvl
   parameter CENTER_COMP_MODE = "ON",        //ON: use PI stg2 tap compensation
   parameter PI_VAL_ADJ       = "ON",        //ON: PI stg2 tap -1 for centering
   parameter TAPSPERKCLK      = 56,
   parameter POC_USE_METASTABLE_SAMP = "FALSE",
   parameter SKIP_CALIB       = "FALSE",
   parameter FPGA_VOLT_TYPE   = "N"
  )
  (
   input                     clk,            // Fabric logic clock
                                             // To MC, calib_top, hard PHY
   input                     clk_div2,       // mem_refclk divided by 2 for PI incdec
   input                     rst_div2,       // reset in clk_div2 domain
   input                     clk_ref,        // Idelay_ctrl reference clock
                                             // To hard PHY (external source)
   input                     freq_refclk,    // To hard PHY for Phasers
   input                     mem_refclk,     // Memory clock to hard PHY
   input                     pll_lock,       // System PLL lock signal
   input                     sync_pulse,     // 1/N sync pulse used to synchronize all PHASERS
   input                     mmcm_ps_clk,    // Phase shift clock for oclk stg3 centering
   input                     poc_sample_pd,  // Tell POC how to avoid metastability.

   input                     error,          // Support for TG error detect
   output                    rst_tg_mc,      // Support for TG error detect

   input  [11:0]             device_temp,
   input                     tempmon_sample_en,

   input                     dbg_sel_pi_incdec,
   input                     dbg_sel_po_incdec,
   input [DQS_CNT_WIDTH:0]   dbg_byte_sel,
   input                     dbg_pi_f_inc,
   input                     dbg_pi_f_dec,
   input                     dbg_po_f_inc,
   input                     dbg_po_f_stg23_sel,
   input                     dbg_po_f_dec,
   input                     dbg_idel_down_all,
   input                     dbg_idel_down_cpt,
   input                     dbg_idel_up_all,
   input                     dbg_idel_up_cpt,
   input                     dbg_sel_all_idel_cpt,
   input [DQS_CNT_WIDTH-1:0] dbg_sel_idel_cpt,
   input                     rst,
   input                     iddr_rst,
   input [7:0]               slot_0_present,
   input [7:0]               slot_1_present,
   // From MC
   input [nCK_PER_CLK-1:0]   mc_ras_n,
   input [nCK_PER_CLK-1:0]   mc_cas_n,
   input [nCK_PER_CLK-1:0]   mc_we_n,
   input [nCK_PER_CLK*ROW_WIDTH-1:0] mc_address,
   input [nCK_PER_CLK*BANK_WIDTH-1:0] mc_bank,
   input [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mc_cs_n,
   input                     mc_reset_n,
   input [1:0]           mc_odt,
   input [nCK_PER_CLK-1:0]   mc_cke,
   // AUX - For ODT and CKE assertion during reads and writes
   input [3:0]               mc_aux_out0,
   input [3:0]               mc_aux_out1,
   input                     mc_cmd_wren,
   input                     mc_ctl_wren,
   input [2:0]               mc_cmd,
   input [1:0]               mc_cas_slot,
   input [5:0]               mc_data_offset,
   input [5:0]               mc_data_offset_1,
   input [5:0]               mc_data_offset_2,
   input [1:0]               mc_rank_cnt,
   // Write
   input                     mc_wrdata_en,
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] mc_wrdata,
   input [2*nCK_PER_CLK*(DQ_WIDTH/8)-1:0] mc_wrdata_mask,
   input                     idle,
   // DDR bus signals
   output [ROW_WIDTH-1:0]              ddr_addr,
   output [BANK_WIDTH-1:0]             ddr_ba,
   output                              ddr_cas_n,
   output [CK_WIDTH-1:0]               ddr_ck_n,
   output [CK_WIDTH-1:0]               ddr_ck,
   output [CKE_WIDTH-1:0]              ddr_cke,
   output [CS_WIDTH*nCS_PER_RANK-1:0]  ddr_cs_n,
   output [DM_WIDTH-1:0]               ddr_dm,
   output [ODT_WIDTH-1:0]              ddr_odt,
   output                              ddr_ras_n,
   output                              ddr_reset_n,
   output                              ddr_parity,
   output                              ddr_we_n,
   inout [DQ_WIDTH-1:0]                ddr_dq,
   inout [DQS_WIDTH-1:0]               ddr_dqs_n,
   inout [DQS_WIDTH-1:0]               ddr_dqs,

   // Ports to be used when SKIP_CALIB="TRUE"
   output                              calib_tap_req,
   input [6:0]                         calib_tap_addr,
   input                               calib_tap_load,
   input [7:0]                         calib_tap_val,
   input                               calib_tap_load_done,

   //phase shift clock control
   output                              psen,
   output                              psincdec,
   input                               psdone,
   // Debug Port Outputs
   output [255:0]                      dbg_calib_top,
   output [6*DQS_WIDTH*RANKS-1:0]      dbg_cpt_first_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0]      dbg_cpt_second_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0]      dbg_cpt_tap_cnt,
   output [5*DQS_WIDTH*RANKS-1:0]      dbg_dq_idelay_tap_cnt,
   output [255:0]                      dbg_phy_rdlvl,
   output [99:0]                       dbg_phy_wrcal,
   output [6*DQS_WIDTH-1:0]            dbg_final_po_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]            dbg_final_po_coarse_tap_cnt,
   output [DQS_WIDTH-1:0]              dbg_rd_data_edge_detect,
   output [2*nCK_PER_CLK*DQ_WIDTH-1:0] dbg_rddata,
   output                              dbg_rddata_valid,
   output [1:0]                        dbg_rdlvl_done,
   output [1:0]                        dbg_rdlvl_err,
   output [1:0]                        dbg_rdlvl_start,
   output [5:0]                        dbg_tap_cnt_during_wrlvl,
   output                              dbg_wl_edge_detect_valid,
   output                              dbg_wrlvl_done,
   output                              dbg_wrlvl_err,
   output                              dbg_wrlvl_start,
   output [6*DQS_WIDTH-1:0]            dbg_wrlvl_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]            dbg_wrlvl_coarse_tap_cnt,
   output [255:0]                      dbg_phy_wrlvl,
   output                              dbg_pi_phaselock_start,
   output                              dbg_pi_phaselocked_done,
   output                              dbg_pi_phaselock_err,
   output [11:0]                       dbg_pi_phase_locked_phy4lanes,
   output                              dbg_pi_dqsfound_start,
   output                              dbg_pi_dqsfound_done,
   output                              dbg_pi_dqsfound_err,
   output [11:0]                       dbg_pi_dqs_found_lanes_phy4lanes,
   output                              dbg_wrcal_start,
   output                              dbg_wrcal_done,
   output                              dbg_wrcal_err,
   output [1023:0]                     dbg_poc,
   // FIFO status flags
   output                              phy_mc_ctl_full,
   output                              phy_mc_cmd_full,
   output                              phy_mc_data_full,
   // Calibration status and resultant outputs
   output                              init_calib_complete,
   output                              init_wrcal_complete,
   output [6*RANKS-1:0]                calib_rd_data_offset_0,
   output [6*RANKS-1:0]                calib_rd_data_offset_1,
   output [6*RANKS-1:0]                calib_rd_data_offset_2,
   output                              phy_rddata_valid,
   output [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rd_data,

   output                              ref_dll_lock,
   input                               rst_phaser_ref,
   output [6*RANKS-1:0]                dbg_rd_data_offset,
   output [255:0]                      dbg_phy_init,
   output [255:0]                      dbg_prbs_rdlvl,
   output [255:0]                      dbg_dqs_found_cal,
   output [5:0]                        dbg_pi_counter_read_val,
   output [8:0]                        dbg_po_counter_read_val,
   output                              dbg_oclkdelay_calib_start,
   output                              dbg_oclkdelay_calib_done,
   output [255:0]                      dbg_phy_oclkdelay_cal,
   output [DRAM_WIDTH*16 -1:0]         dbg_oclkdelay_rd_data,
   output [6*DQS_WIDTH*RANKS-1:0]      prbs_final_dqs_tap_cnt_r,
   output [6*DQS_WIDTH*RANKS-1:0]      dbg_prbs_first_edge_taps,
   output [6*DQS_WIDTH*RANKS-1:0]      dbg_prbs_second_edge_taps
   );

  // Calculate number of slots in the system
  localparam nSLOTS  = 1 + (|SLOT_1_CONFIG ? 1 : 0);
  localparam CLK_PERIOD = tCK * nCK_PER_CLK;

  // Parameter used to force skipping or abbreviation of initialization
  // and calibration. Overrides SIM_INIT_OPTION, SIM_CAL_OPTION, and
  // disables various other blocks depending on the option selected
  // This option should only be used during simulation. In the case of
  // the "SKIP" option, the testbench used should also not be modeling
  // propagation delays.
  // Allowable options = {"NONE", "SIM_FULL", "SKIP", "FAST"}
  //  "NONE"     = options determined by the individual parameter settings
  //  "SIM_FULL" = skip power-up delay. FULL calibration performed without
  //               averaging algorithm turned ON during window detection.
  //  "SKIP"     = skip power-up delay. Skip calibration not yet supported.
  //  "FAST"     = skip power-up delay, and calibrate (read leveling, write
  //               leveling, and phase detector) only using one DQS group, and
  //               apply the results to all other DQS groups.
  localparam SIM_INIT_OPTION
             = ((SIM_BYPASS_INIT_CAL == "SKIP") ? "SKIP_INIT" :
               ((SIM_BYPASS_INIT_CAL == "FAST") ||
                (SIM_BYPASS_INIT_CAL == "SIM_FULL")) ? "SKIP_PU_DLY" :
                "NONE");
  localparam SIM_CAL_OPTION
             = ((SIM_BYPASS_INIT_CAL == "SKIP") ? "SKIP_CAL" :
                (SIM_BYPASS_INIT_CAL == "FAST") ? "FAST_CAL" :
               ((SIM_BYPASS_INIT_CAL == "SIM_FULL") ||
                (SIM_BYPASS_INIT_CAL == "SIM_INIT_CAL_FULL")) ? "FAST_WIN_DETECT" :
                "NONE");
  localparam WRLVL_W
             = (SIM_BYPASS_INIT_CAL == "SKIP") ? "OFF" : WRLVL;

  localparam HIGHEST_BANK = (BYTE_LANES_B4 != 0 ? 5 : (BYTE_LANES_B3 != 0 ? 4 :
                            (BYTE_LANES_B2 != 0 ? 3 :
                            (BYTE_LANES_B1 != 0  ? 2 : 1))));

  localparam HIGHEST_LANE_B0  =  BYTE_LANES_B0[3] ? 4 : BYTE_LANES_B0[2] ? 3 :
                                 BYTE_LANES_B0[1] ? 2 : BYTE_LANES_B0[0] ? 1 :
                                 0;
  localparam HIGHEST_LANE_B1  =  BYTE_LANES_B1[3] ? 4 : BYTE_LANES_B1[2] ? 3 :
                                 BYTE_LANES_B1[1] ? 2 : BYTE_LANES_B1[0] ? 1 :
                                 0;
  localparam HIGHEST_LANE_B2  =  BYTE_LANES_B2[3] ? 4 : BYTE_LANES_B2[2] ? 3 :
                                 BYTE_LANES_B2[1] ? 2 : BYTE_LANES_B2[0] ? 1 :
                                 0;
  localparam HIGHEST_LANE_B3  =  BYTE_LANES_B3[3] ? 4 : BYTE_LANES_B3[2] ? 3 :
                                 BYTE_LANES_B3[1] ? 2 : BYTE_LANES_B3[0] ? 1 :
                                 0;
  localparam HIGHEST_LANE_B4  =  BYTE_LANES_B4[3] ? 4 : BYTE_LANES_B4[2] ? 3 :
                                 BYTE_LANES_B4[1] ? 2 : BYTE_LANES_B4[0] ? 1 :
                                 0;
  localparam HIGHEST_LANE =
             (HIGHEST_LANE_B4 != 0) ? (HIGHEST_LANE_B4+16) :
             ((HIGHEST_LANE_B3 != 0) ? (HIGHEST_LANE_B3 + 12) :
              ((HIGHEST_LANE_B2 != 0) ? (HIGHEST_LANE_B2 + 8)  :
               ((HIGHEST_LANE_B1 != 0) ? (HIGHEST_LANE_B1 + 4) :
                HIGHEST_LANE_B0)));

  localparam N_CTL_LANES = ((0+(!DATA_CTL_B0[0]) & BYTE_LANES_B0[0]) +
                           (0+(!DATA_CTL_B0[1]) & BYTE_LANES_B0[1]) +
                           (0+(!DATA_CTL_B0[2]) & BYTE_LANES_B0[2]) +
                           (0+(!DATA_CTL_B0[3]) & BYTE_LANES_B0[3])) +
                           ((0+(!DATA_CTL_B1[0]) & BYTE_LANES_B1[0]) +
                           (0+(!DATA_CTL_B1[1]) & BYTE_LANES_B1[1]) +
                           (0+(!DATA_CTL_B1[2]) & BYTE_LANES_B1[2]) +
                           (0+(!DATA_CTL_B1[3]) & BYTE_LANES_B1[3])) +
                           ((0+(!DATA_CTL_B2[0]) & BYTE_LANES_B2[0]) +
                           (0+(!DATA_CTL_B2[1]) & BYTE_LANES_B2[1]) +
                           (0+(!DATA_CTL_B2[2]) & BYTE_LANES_B2[2]) +
                           (0+(!DATA_CTL_B2[3]) & BYTE_LANES_B2[3])) +
                           ((0+(!DATA_CTL_B3[0]) & BYTE_LANES_B3[0]) +
                           (0+(!DATA_CTL_B3[1]) & BYTE_LANES_B3[1]) +
                           (0+(!DATA_CTL_B3[2]) & BYTE_LANES_B3[2]) +
                           (0+(!DATA_CTL_B3[3]) & BYTE_LANES_B3[3])) +
                           ((0+(!DATA_CTL_B4[0]) & BYTE_LANES_B4[0]) +
                           (0+(!DATA_CTL_B4[1]) & BYTE_LANES_B4[1]) +
                           (0+(!DATA_CTL_B4[2]) & BYTE_LANES_B4[2]) +
                           (0+(!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]));

  // Assuming Ck/Addr/Cmd and Control are placed in a single IO Bank
  // This should be the case since the PLL should be placed adjacent
  // to the same IO Bank as Ck/Addr/Cmd and Control
  localparam [2:0] CTL_BANK  = (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0]) |
                                ((!DATA_CTL_B0[1]) & BYTE_LANES_B0[1]) |
                                ((!DATA_CTL_B0[2]) & BYTE_LANES_B0[2]) |
                                ((!DATA_CTL_B0[3]) & BYTE_LANES_B0[3])) ?
                                3'b000 :
                               (((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0]) |
                                ((!DATA_CTL_B1[1]) & BYTE_LANES_B1[1]) |
                                ((!DATA_CTL_B1[2]) & BYTE_LANES_B1[2]) |
                                ((!DATA_CTL_B1[3]) & BYTE_LANES_B1[3])) ?
                                3'b001 :
                               (((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0]) |
                                ((!DATA_CTL_B2[1]) & BYTE_LANES_B2[1]) |
                                ((!DATA_CTL_B2[2]) & BYTE_LANES_B2[2]) |
                                ((!DATA_CTL_B2[3]) & BYTE_LANES_B2[3])) ?
                                3'b010 :
                               (((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0]) |
                                ((!DATA_CTL_B3[1]) & BYTE_LANES_B3[1]) |
                                ((!DATA_CTL_B3[2]) & BYTE_LANES_B3[2]) |
                                ((!DATA_CTL_B3[3]) & BYTE_LANES_B3[3])) ?
                                3'b011 :
                               (((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0]) |
                                ((!DATA_CTL_B4[1]) & BYTE_LANES_B4[1]) |
                                ((!DATA_CTL_B4[2]) & BYTE_LANES_B4[2]) |
                                ((!DATA_CTL_B4[3]) & BYTE_LANES_B4[3])) ?
                                3'b100 : 3'b000;

  localparam [7:0] CTL_BYTE_LANE  = (N_CTL_LANES == 4) ? 8'b11_10_01_00 :
                                    ((N_CTL_LANES == 3) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[1]) & BYTE_LANES_B0[1] &
                                       (!DATA_CTL_B0[2]) & BYTE_LANES_B0[2]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[1]) & BYTE_LANES_B1[1] &
                                       (!DATA_CTL_B1[2]) & BYTE_LANES_B1[2]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[1]) & BYTE_LANES_B2[1] &
                                       (!DATA_CTL_B2[2]) & BYTE_LANES_B2[2]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[1]) & BYTE_LANES_B3[1] &
                                       (!DATA_CTL_B3[2]) & BYTE_LANES_B3[2]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[1]) & BYTE_LANES_B4[1] &
                                       (!DATA_CTL_B4[2]) & BYTE_LANES_B4[2]))) ?
                                    8'b00_10_01_00 :
                                    ((N_CTL_LANES == 3) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[1]) & BYTE_LANES_B0[1] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[1]) & BYTE_LANES_B1[1] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[1]) & BYTE_LANES_B2[1] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[1]) & BYTE_LANES_B3[1] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[1]) & BYTE_LANES_B4[1] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_11_01_00 :
                                    ((N_CTL_LANES == 3) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[2]) & BYTE_LANES_B0[2] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[2]) & BYTE_LANES_B1[2] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[2]) & BYTE_LANES_B2[2] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[2]) & BYTE_LANES_B3[2] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[2]) & BYTE_LANES_B4[2] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_11_10_00 :
                                    ((N_CTL_LANES == 3) &
                                     (((!DATA_CTL_B0[1]) & BYTE_LANES_B0[1] &
                                       (!DATA_CTL_B0[2]) & BYTE_LANES_B0[2] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[1]) & BYTE_LANES_B1[1] &
                                       (!DATA_CTL_B1[2]) & BYTE_LANES_B1[2] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[1]) & BYTE_LANES_B2[1] &
                                       (!DATA_CTL_B2[2]) & BYTE_LANES_B2[2] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[1]) & BYTE_LANES_B3[1] &
                                       (!DATA_CTL_B3[2]) & BYTE_LANES_B3[2] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[1]) & BYTE_LANES_B4[1] &
                                       (!DATA_CTL_B4[2]) & BYTE_LANES_B4[2] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_11_10_01 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[1]) & BYTE_LANES_B0[1]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[1]) & BYTE_LANES_B1[1]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[1]) & BYTE_LANES_B2[1]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[1]) & BYTE_LANES_B3[1]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[1]) & BYTE_LANES_B4[1]))) ?
                                    8'b00_00_01_00 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_00_11_00 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[2]) & BYTE_LANES_B0[2] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[2]) & BYTE_LANES_B1[2] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[2]) & BYTE_LANES_B2[2] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[2]) & BYTE_LANES_B3[2] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[2]) & BYTE_LANES_B4[2] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_00_11_10 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[1]) & BYTE_LANES_B0[1] &
                                       (!DATA_CTL_B0[2]) & BYTE_LANES_B0[2]) |
                                      ((!DATA_CTL_B1[1]) & BYTE_LANES_B1[1] &
                                       (!DATA_CTL_B1[2]) & BYTE_LANES_B1[2]) |
                                      ((!DATA_CTL_B2[1]) & BYTE_LANES_B2[1] &
                                       (!DATA_CTL_B2[2]) & BYTE_LANES_B2[2]) |
                                      ((!DATA_CTL_B3[1]) & BYTE_LANES_B3[1] &
                                       (!DATA_CTL_B3[2]) & BYTE_LANES_B3[2]) |
                                      ((!DATA_CTL_B4[1]) & BYTE_LANES_B4[1] &
                                       (!DATA_CTL_B4[2]) & BYTE_LANES_B4[2]))) ?
                                    8'b00_00_10_01 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[1]) & BYTE_LANES_B0[1] &
                                       (!DATA_CTL_B0[3]) & BYTE_LANES_B0[3]) |
                                      ((!DATA_CTL_B1[1]) & BYTE_LANES_B1[1] &
                                       (!DATA_CTL_B1[3]) & BYTE_LANES_B1[3]) |
                                      ((!DATA_CTL_B2[1]) & BYTE_LANES_B2[1] &
                                       (!DATA_CTL_B2[3]) & BYTE_LANES_B2[3]) |
                                      ((!DATA_CTL_B3[1]) & BYTE_LANES_B3[1] &
                                       (!DATA_CTL_B3[3]) & BYTE_LANES_B3[3]) |
                                      ((!DATA_CTL_B4[1]) & BYTE_LANES_B4[1] &
                                       (!DATA_CTL_B4[3]) & BYTE_LANES_B4[3]))) ?
                                    8'b00_00_11_01 :
                                    ((N_CTL_LANES == 2) &
                                     (((!DATA_CTL_B0[0]) & BYTE_LANES_B0[0] &
                                       (!DATA_CTL_B0[2]) & BYTE_LANES_B0[2]) |
                                      ((!DATA_CTL_B1[0]) & BYTE_LANES_B1[0] &
                                       (!DATA_CTL_B1[2]) & BYTE_LANES_B1[2]) |
                                      ((!DATA_CTL_B2[0]) & BYTE_LANES_B2[0] &
                                       (!DATA_CTL_B2[2]) & BYTE_LANES_B2[2]) |
                                      ((!DATA_CTL_B3[0]) & BYTE_LANES_B3[0] &
                                       (!DATA_CTL_B3[2]) & BYTE_LANES_B3[2]) |
                                      ((!DATA_CTL_B4[0]) & BYTE_LANES_B4[0] &
                                       (!DATA_CTL_B4[2]) & BYTE_LANES_B4[2]))) ?
                                    8'b00_00_10_00 : 8'b11_10_01_00;

  localparam PI_DIV2_INCDEC = (DRAM_TYPE == "DDR2") ? "FALSE" : (((FPGA_VOLT_TYPE == "L") && (nCK_PER_CLK == 4)) ? "TRUE" : "FALSE");

  wire [HIGHEST_LANE*80-1:0]            phy_din;
  wire [HIGHEST_LANE*80-1:0]            phy_dout;
  wire [(HIGHEST_LANE*12)-1:0]          ddr_cmd_ctl_data;
  wire [(((HIGHEST_LANE+3)/4)*4)-1:0]   aux_out;
  wire [(CK_WIDTH * LP_DDR_CK_WIDTH)-1:0] ddr_clk;
  wire                                  phy_mc_go;
  wire                                  phy_ctl_full;
  wire                                  phy_cmd_full;
  wire                                  phy_data_full;
  wire                                  phy_pre_data_a_full;
  wire                                  if_empty /* synthesis syn_maxfan = 3 */;
  wire                                  phy_write_calib;
  wire                                  phy_read_calib;
  wire [HIGHEST_BANK-1:0]               rst_stg1_cal;
  wire [5:0]                            calib_sel;
  wire                                  calib_in_common /* synthesis syn_maxfan = 10 */;
  wire [HIGHEST_BANK-1:0]               calib_zero_inputs;
  wire [HIGHEST_BANK-1:0]               calib_zero_ctrl;
  wire                                  pi_phase_locked;
  wire                                  pi_phase_locked_all;
  wire                                  pi_found_dqs;
  wire                                  pi_dqs_found_all;
  wire                                  pi_dqs_out_of_range;
  wire                                  pi_enstg2_f;
  wire                                  pi_stg2_fincdec;
  wire                                  pi_stg2_load;
  wire [5:0]                            pi_stg2_reg_l;
  wire                                  idelay_ce;
  wire                                  idelay_inc;
  wire                                  idelay_ld;
  wire [2:0]                            po_sel_stg2stg3;
  wire [2:0]                            po_stg2_cincdec;
  wire [2:0]                            po_enstg2_c;
  wire [2:0]                            po_stg2_fincdec;
  wire [2:0]                            po_enstg2_f;
  wire [8:0]                            po_counter_read_val;
  wire [5:0]                            pi_counter_read_val;
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0]     phy_wrdata;
  reg [nCK_PER_CLK-1:0]                 parity;
  wire [nCK_PER_CLK*ROW_WIDTH-1:0]      phy_address;
  wire [nCK_PER_CLK*BANK_WIDTH-1:0]     phy_bank;
  wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] phy_cs_n;
  wire [nCK_PER_CLK-1:0]                phy_ras_n;
  wire [nCK_PER_CLK-1:0]                phy_cas_n;
  wire [nCK_PER_CLK-1:0]                phy_we_n;
  wire                                  phy_reset_n;
  wire [3:0]                            calib_aux_out;
  wire [nCK_PER_CLK-1:0]                calib_cke;
  wire [1:0]                            calib_odt;
  wire                                  calib_ctl_wren;
  wire                                  calib_cmd_wren;
  wire                                  calib_wrdata_en;
  wire [2:0]                            calib_cmd;
  wire [1:0]                            calib_seq;
  wire [5:0]                            calib_data_offset_0;
  wire [5:0]                            calib_data_offset_1;
  wire [5:0]                            calib_data_offset_2;
  wire [1:0]                            calib_rank_cnt;
  wire [1:0]                            calib_cas_slot;
  wire [nCK_PER_CLK*ROW_WIDTH-1:0]      mux_address;
  wire [3:0]                            mux_aux_out;
  wire [3:0]                            aux_out_map;
  wire [nCK_PER_CLK*BANK_WIDTH-1:0]     mux_bank;
  wire [2:0]                            mux_cmd;
  wire                                  mux_cmd_wren;
  wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mux_cs_n;
  wire                                  mux_ctl_wren;
  wire [1:0]                            mux_cas_slot;
  wire [5:0]                            mux_data_offset;
  wire [5:0]                            mux_data_offset_1;
  wire [5:0]                            mux_data_offset_2;
  wire [nCK_PER_CLK-1:0]                mux_ras_n;
  wire [nCK_PER_CLK-1:0]                mux_cas_n;
  wire [1:0]                            mux_rank_cnt;
  wire                                  mux_reset_n;
  wire [nCK_PER_CLK-1:0]                mux_we_n;
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0]     mux_wrdata;
  wire [2*nCK_PER_CLK*(DQ_WIDTH/8)-1:0] mux_wrdata_mask;
  wire                                  mux_wrdata_en;
  wire [nCK_PER_CLK-1:0]        mux_cke ;
  wire [1:0]                mux_odt ;
  wire                                  phy_if_empty_def;
  wire                                  phy_if_reset;
  wire                                  phy_init_data_sel;
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0]     rd_data_map;
  wire                                  phy_rddata_valid_w;
  reg                                   rddata_valid_reg;
  reg  [2*nCK_PER_CLK*DQ_WIDTH-1:0]     rd_data_reg;
  wire [4:0]                            idelaye2_init_val;
  wire [5:0]                            oclkdelay_init_val;
  wire                                  po_counter_load_en;
  wire [DQS_CNT_WIDTH:0]                byte_sel_cnt;
  wire [DRAM_WIDTH-1:0]                 fine_delay_incdec_pb;
  wire                                  fine_delay_sel;
  wire                                  pd_out;

  //***************************************************************************

  assign dbg_rddata_valid = rddata_valid_reg;
  assign dbg_rddata       = rd_data_reg;

  assign dbg_rd_data_offset = calib_rd_data_offset_0;
  assign dbg_pi_phaselocked_done = pi_phase_locked_all;

  assign dbg_po_counter_read_val = po_counter_read_val;
  assign dbg_pi_counter_read_val = pi_counter_read_val;

  //***************************************************************************

  //***************************************************************************
  // Clock domain crossing from DIV4 to DIV2 for Phaser_In stage2 incdec
  //***************************************************************************
  //localparam PI_DIV2_INCDEC = "TRUE";

  wire pi_fine_enable;
  wire pi_fine_inc;
  wire pi_counter_load_en;
  wire [5:0] pi_counter_load_val;
  wire [HIGHEST_BANK-1:0] pi_rst_dqs_find;

  generate
  if (PI_DIV2_INCDEC == "TRUE") begin: div2_incdec
      // 3-stage synchronizer registers
      (* ASYNC_REG = "TRUE" *) reg pi_enstg2_f_div2r1;
      (* ASYNC_REG = "TRUE" *) reg pi_enstg2_f_div2r2;
      (* ASYNC_REG = "TRUE" *) reg pi_enstg2_f_div2r3;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_fincdec_div2r1;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_fincdec_div2r2;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_fincdec_div2r3;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_load_div2r1;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_load_div2r2;
      (* ASYNC_REG = "TRUE" *) reg pi_stg2_load_div2r3;
      (* ASYNC_REG = "TRUE" *) reg [HIGHEST_BANK-1:0] rst_stg1_cal_div2r1;
      (* ASYNC_REG = "TRUE" *) reg [HIGHEST_BANK-1:0] rst_stg1_cal_div2r2;
      (* ASYNC_REG = "TRUE" *) reg [5:0] pi_stg2_reg_l_div2r1;
      (* ASYNC_REG = "TRUE" *) reg [5:0] pi_stg2_reg_l_div2r2;
      (* ASYNC_REG = "TRUE" *) reg [5:0] pi_stg2_reg_l_div2r3;

      reg  pi_stg2_fine_enable, pi_stg2_fine_enable_r1;
      reg  pi_stg2_fine_inc, pi_stg2_fine_inc_r1;
      reg  pi_stg2_load_en, pi_stg2_load_en_r1;
      reg [5:0] pi_stg2_load_val;
      (* ASYNC_REG = "TRUE" *) reg [HIGHEST_BANK-1:0] pi_dqs_find_rst;

      // 3-stage synchronizer
      always @(posedge clk_div2) begin
        //Phaser_In fine enable
        pi_enstg2_f_div2r1 <= #TCQ pi_enstg2_f;
        pi_enstg2_f_div2r2 <= #TCQ pi_enstg2_f_div2r1;
        pi_enstg2_f_div2r3 <= #TCQ pi_enstg2_f_div2r2;
        //Phaser_In fine incdec
        pi_stg2_fincdec_div2r1 <= #TCQ pi_stg2_fincdec;
        pi_stg2_fincdec_div2r2 <= #TCQ pi_stg2_fincdec_div2r1;
        pi_stg2_fincdec_div2r3 <= #TCQ pi_stg2_fincdec_div2r2;
        //Phaser_In stage2 load
        pi_stg2_load_div2r1 <= #TCQ pi_stg2_load;
        pi_stg2_load_div2r2 <= #TCQ pi_stg2_load_div2r1;
        pi_stg2_load_div2r3 <= #TCQ pi_stg2_load_div2r2;
        //Phaser_In stage2 load value
        pi_stg2_reg_l_div2r1 <= #TCQ pi_stg2_reg_l;
        pi_stg2_reg_l_div2r2 <= #TCQ pi_stg2_reg_l_div2r1;
        pi_stg2_reg_l_div2r3 <= #TCQ pi_stg2_reg_l_div2r2;
        //Phaser_In reset DQSFOUND
        rst_stg1_cal_div2r1 <= #TCQ rst_stg1_cal;
        rst_stg1_cal_div2r2 <= #TCQ rst_stg1_cal_div2r1;
        pi_dqs_find_rst     <= #TCQ rst_stg1_cal_div2r2;
      end

      always @(posedge clk_div2) begin
        pi_stg2_fine_enable_r1 <= #TCQ pi_stg2_fine_enable;
        pi_stg2_fine_inc_r1    <= #TCQ pi_stg2_fine_inc;
        pi_stg2_load_en_r1     <= #TCQ pi_stg2_load_en;
      end

      always @(posedge clk_div2) begin
        if (rst_div2 || pi_stg2_fine_enable || pi_stg2_fine_enable_r1)
          pi_stg2_fine_enable <= #TCQ 1'b0;
        else if (pi_enstg2_f_div2r3)
          pi_stg2_fine_enable <= #TCQ 1'b1;
      end

      always @(posedge clk_div2) begin
        if (rst_div2 || pi_stg2_fine_inc || pi_stg2_fine_inc_r1)
          pi_stg2_fine_inc <= #TCQ 1'b0;
        else if (pi_stg2_fincdec_div2r3)
          pi_stg2_fine_inc <= #TCQ 1'b1;
      end

      always @(posedge clk_div2) begin
        if (rst_div2 || pi_stg2_load_en || pi_stg2_load_en_r1)
          pi_stg2_load_en <= #TCQ 1'b0;
        else if (pi_stg2_load_div2r3)
          pi_stg2_load_en <= #TCQ 1'b1;
      end

      always @(posedge clk_div2) begin
        if (rst_div2 || pi_stg2_load_en || pi_stg2_load_en_r1)
          pi_stg2_load_val <= #TCQ 6'd0;
        else if (pi_stg2_load_div2r3)
          pi_stg2_load_val <= #TCQ pi_stg2_reg_l_div2r3;
      end


      assign pi_fine_enable      = pi_stg2_fine_enable;
      assign pi_fine_inc         = pi_stg2_fine_inc;
      assign pi_counter_load_en  = pi_stg2_load_en;
      assign pi_counter_load_val = pi_stg2_load_val;
      assign pi_rst_dqs_find     = pi_dqs_find_rst;

    end else begin: div4_incdec
      assign pi_fine_enable      = pi_enstg2_f;
      assign pi_fine_inc         = pi_stg2_fincdec;
      assign pi_counter_load_en  = pi_stg2_load;
      assign pi_counter_load_val = pi_stg2_reg_l;
      assign pi_rst_dqs_find     = rst_stg1_cal;

    end
  endgenerate

  genvar i;
  generate
     for (i = 0; i < CK_WIDTH; i = i+1) begin: clock_gen
        assign ddr_ck[i]   = ddr_clk[LP_DDR_CK_WIDTH * i];
        assign ddr_ck_n[i] = ddr_clk[(LP_DDR_CK_WIDTH * i) + 1];
     end
  endgenerate

  //***************************************************************************
  // During memory initialization and calibration the calibration logic drives
  // the memory signals. After calibration is complete the memory controller
  // drives the memory signals.
  // Do not expect timing issues in 4:1 mode at 800 MHz/1600 Mbps
  //***************************************************************************

  wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mc_cs_n_temp ;
  genvar v ;

  generate
    if((REG_CTRL == "ON") && (DRAM_TYPE == "DDR3") && (RANKS == 1) && (nCS_PER_RANK ==2)) begin : cs_rdimm
      for(v = 0 ; v < CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK ; v = v+1 ) begin
        if((v%(CS_WIDTH*nCS_PER_RANK)) == 0) begin
         assign mc_cs_n_temp[v] = mc_cs_n[v] ;
    end else begin
         assign mc_cs_n_temp[v] = 'b1 ;
    end
      end
    end else begin
      assign mc_cs_n_temp = mc_cs_n ;
    end
  endgenerate

  assign mux_wrdata      = (phy_init_data_sel | init_wrcal_complete) ? mc_wrdata : phy_wrdata;
  assign mux_wrdata_mask = (phy_init_data_sel | init_wrcal_complete) ? mc_wrdata_mask : 'b0;
  assign mux_address     = (phy_init_data_sel | init_wrcal_complete) ? mc_address : phy_address;
  assign mux_bank        = (phy_init_data_sel | init_wrcal_complete) ? mc_bank : phy_bank;
  assign mux_cs_n        = (phy_init_data_sel | init_wrcal_complete) ? mc_cs_n_temp : phy_cs_n;
  assign mux_ras_n       = (phy_init_data_sel | init_wrcal_complete) ? mc_ras_n : phy_ras_n;
  assign mux_cas_n       = (phy_init_data_sel | init_wrcal_complete) ? mc_cas_n : phy_cas_n;
  assign mux_we_n        = (phy_init_data_sel | init_wrcal_complete) ? mc_we_n : phy_we_n;
  assign mux_reset_n     = (phy_init_data_sel | init_wrcal_complete) ? mc_reset_n : phy_reset_n;
  assign mux_aux_out     = (phy_init_data_sel | init_wrcal_complete) ? mc_aux_out0 : calib_aux_out;
  assign mux_odt         = (phy_init_data_sel | init_wrcal_complete) ? mc_odt      : calib_odt    ;
  assign mux_cke         = (phy_init_data_sel | init_wrcal_complete) ? mc_cke      : calib_cke    ;
  assign mux_cmd_wren    = (phy_init_data_sel | init_wrcal_complete) ? mc_cmd_wren :
                                                 calib_cmd_wren;
  assign mux_ctl_wren  =   (phy_init_data_sel | init_wrcal_complete) ? mc_ctl_wren :
                                                 calib_ctl_wren;
  assign mux_wrdata_en   = (phy_init_data_sel | init_wrcal_complete) ? mc_wrdata_en :
                                                 calib_wrdata_en;
  assign mux_cmd         = (phy_init_data_sel | init_wrcal_complete) ? mc_cmd : calib_cmd;
  assign mux_cas_slot    = (phy_init_data_sel | init_wrcal_complete) ? mc_cas_slot : calib_cas_slot;
  assign mux_data_offset = (phy_init_data_sel | init_wrcal_complete) ? mc_data_offset :
                                                 calib_data_offset_0;
  assign mux_data_offset_1 = (phy_init_data_sel | init_wrcal_complete) ? mc_data_offset_1 :
                                                 calib_data_offset_1;
  assign mux_data_offset_2 = (phy_init_data_sel | init_wrcal_complete) ? mc_data_offset_2 :
                                                 calib_data_offset_2;
  // Reserved field. Hard coded to 2'b00 irrespective of the number of ranks. CR 643601
  assign mux_rank_cnt    = 2'b00;


  // Assigning cke & odt for DDR2 & DDR3
  // No changes for DDR3 & DDR2 dual rank
  // DDR2 single rank systems might potentially need 3 odt signals.
  // Aux_out[2] will have the odt toggled by phy and controller
  // wiring aux_out[2] to 0 & 3. Depending upon the odt parameter
  // all of the three odt bits or some of them might be used.
  // mapping done in mc_phy_wrapper module
   generate
     if(CKE_ODT_AUX == "TRUE") begin
       assign aux_out_map = ((DRAM_TYPE == "DDR2") && (RANKS == 1)) ?
       {mux_aux_out[1],mux_aux_out[1],mux_aux_out[1],mux_aux_out[0]} :
            mux_aux_out;
     end else begin
       assign aux_out_map = 4'b0000 ;
     end
  endgenerate

  assign init_calib_complete = phy_init_data_sel;

  assign phy_mc_ctl_full  = phy_ctl_full;
  assign phy_mc_cmd_full  = phy_cmd_full;
  assign phy_mc_data_full = phy_pre_data_a_full;

  //***************************************************************************
  // Generate parity for DDR3 RDIMM.
  //***************************************************************************

  generate
    if ((DRAM_TYPE == "DDR3") && (REG_CTRL == "ON")) begin: gen_ddr3_parity
      if (nCK_PER_CLK == 4) begin
        always @(posedge clk) begin
          parity[0] <= #TCQ (^{mux_address[(ROW_WIDTH*4)-1:ROW_WIDTH*3],
                               mux_bank[(BANK_WIDTH*4)-1:BANK_WIDTH*3],
                               mux_cas_n[3], mux_ras_n[3], mux_we_n[3]});
        end
        always @(*) begin
          parity[1] = (^{mux_address[ROW_WIDTH-1:0], mux_bank[BANK_WIDTH-1:0],
                         mux_cas_n[0],mux_ras_n[0], mux_we_n[0]});
          parity[2] = (^{mux_address[(ROW_WIDTH*2)-1:ROW_WIDTH],
                         mux_bank[(BANK_WIDTH*2)-1:BANK_WIDTH],
                         mux_cas_n[1], mux_ras_n[1], mux_we_n[1]});
          parity[3] = (^{mux_address[(ROW_WIDTH*3)-1:ROW_WIDTH*2],
                         mux_bank[(BANK_WIDTH*3)-1:BANK_WIDTH*2],
                         mux_cas_n[2],mux_ras_n[2], mux_we_n[2]});
        end
      end else begin
        always @(posedge clk) begin
        parity[0] <= #TCQ(^{mux_address[(ROW_WIDTH*2)-1:ROW_WIDTH],
                            mux_bank[(BANK_WIDTH*2)-1:BANK_WIDTH],
                            mux_cas_n[1], mux_ras_n[1], mux_we_n[1]});
        end
        always @(*) begin
          parity[1] = (^{mux_address[ROW_WIDTH-1:0],
                         mux_bank[BANK_WIDTH-1:0],
                         mux_cas_n[0], mux_ras_n[0], mux_we_n[0]});
        end
      end
    end else begin: gen_ddr3_noparity
      if (nCK_PER_CLK == 4) begin
        always @(posedge clk) begin
          parity[0] <= #TCQ 1'b0;
          parity[1] <= #TCQ 1'b0;
          parity[2] <= #TCQ 1'b0;
          parity[3] <= #TCQ 1'b0;
        end
      end else begin
        always @(posedge clk) begin
          parity[0] <= #TCQ 1'b0;
          parity[1] <= #TCQ 1'b0;
        end
      end
    end
  endgenerate

  //***************************************************************************
  // Code for optional register stage in read path to MC for timing
  //***************************************************************************
  generate
    if(RD_PATH_REG == 1)begin:RD_REG_TIMING
      always @(posedge clk)begin
        rddata_valid_reg <= #TCQ phy_rddata_valid_w;
        rd_data_reg <= #TCQ rd_data_map;
      end // always @ (posedge clk)
    end else begin : RD_REG_NO_TIMING // block: RD_REG_TIMING
      always @(phy_rddata_valid_w or rd_data_map)begin
        rddata_valid_reg = phy_rddata_valid_w;
        rd_data_reg = rd_data_map;
      end
    end
  endgenerate

  assign phy_rddata_valid = rddata_valid_reg;
  assign phy_rd_data = rd_data_reg;

  //***************************************************************************
  // Hard PHY and accompanying bit mapping logic
  //***************************************************************************

  mig_7series_v4_2_ddr_mc_phy_wrapper #
    (
     .TCQ                (TCQ),
     .tCK                (tCK),
     .BANK_TYPE          (BANK_TYPE),
     .DATA_IO_PRIM_TYPE  (DATA_IO_PRIM_TYPE),
     .DATA_IO_IDLE_PWRDWN(DATA_IO_IDLE_PWRDWN),
     .IODELAY_GRP        (IODELAY_GRP),
     .FPGA_SPEED_GRADE   (FPGA_SPEED_GRADE),
     .nCK_PER_CLK        (nCK_PER_CLK),
     .nCS_PER_RANK       (nCS_PER_RANK),
     .BANK_WIDTH         (BANK_WIDTH),
     .CKE_WIDTH          (CKE_WIDTH),
     .CS_WIDTH           (CS_WIDTH),
     .CK_WIDTH           (CK_WIDTH),
     .LP_DDR_CK_WIDTH    (LP_DDR_CK_WIDTH),
     .DDR2_DQSN_ENABLE   (DDR2_DQSN_ENABLE),
     .CWL                (CWL),
     .DM_WIDTH           (DM_WIDTH),
     .DQ_WIDTH           (DQ_WIDTH),
     .DQS_CNT_WIDTH      (DQS_CNT_WIDTH),
     .DQS_WIDTH          (DQS_WIDTH),
     .DRAM_TYPE          (DRAM_TYPE),
     .RANKS              (RANKS),
     .ODT_WIDTH          (ODT_WIDTH),
     .REG_CTRL           (REG_CTRL),
     .ROW_WIDTH          (ROW_WIDTH),
     .USE_CS_PORT        (USE_CS_PORT),
     .USE_DM_PORT        (USE_DM_PORT),
     .USE_ODT_PORT       (USE_ODT_PORT),
     .IBUF_LPWR_MODE     (IBUF_LPWR_MODE),
     .PHYCTL_CMD_FIFO    (PHYCTL_CMD_FIFO),
     .DATA_CTL_B0        (DATA_CTL_B0),
     .DATA_CTL_B1        (DATA_CTL_B1),
     .DATA_CTL_B2        (DATA_CTL_B2),
     .DATA_CTL_B3        (DATA_CTL_B3),
     .DATA_CTL_B4        (DATA_CTL_B4),
     .BYTE_LANES_B0      (BYTE_LANES_B0),
     .BYTE_LANES_B1      (BYTE_LANES_B1),
     .BYTE_LANES_B2      (BYTE_LANES_B2),
     .BYTE_LANES_B3      (BYTE_LANES_B3),
     .BYTE_LANES_B4      (BYTE_LANES_B4),
     .PHY_0_BITLANES     (PHY_0_BITLANES),
     .PHY_1_BITLANES     (PHY_1_BITLANES),
     .PHY_2_BITLANES     (PHY_2_BITLANES),
     .HIGHEST_BANK       (HIGHEST_BANK),
     .HIGHEST_LANE       (HIGHEST_LANE),
     .CK_BYTE_MAP        (CK_BYTE_MAP),
     .ADDR_MAP           (ADDR_MAP),
     .BANK_MAP           (BANK_MAP),
     .CAS_MAP            (CAS_MAP),
     .CKE_ODT_BYTE_MAP   (CKE_ODT_BYTE_MAP),
     .CKE_MAP            (CKE_MAP),
     .ODT_MAP            (ODT_MAP),
     .CKE_ODT_AUX        (CKE_ODT_AUX),
     .CS_MAP             (CS_MAP),
     .PARITY_MAP         (PARITY_MAP),
     .RAS_MAP            (RAS_MAP),
     .WE_MAP             (WE_MAP),
     .DQS_BYTE_MAP       (DQS_BYTE_MAP),
     .DATA0_MAP          (DATA0_MAP),
     .DATA1_MAP          (DATA1_MAP),
     .DATA2_MAP          (DATA2_MAP),
     .DATA3_MAP          (DATA3_MAP),
     .DATA4_MAP          (DATA4_MAP),
     .DATA5_MAP          (DATA5_MAP),
     .DATA6_MAP          (DATA6_MAP),
     .DATA7_MAP          (DATA7_MAP),
     .DATA8_MAP          (DATA8_MAP),
     .DATA9_MAP          (DATA9_MAP),
     .DATA10_MAP         (DATA10_MAP),
     .DATA11_MAP         (DATA11_MAP),
     .DATA12_MAP         (DATA12_MAP),
     .DATA13_MAP         (DATA13_MAP),
     .DATA14_MAP         (DATA14_MAP),
     .DATA15_MAP         (DATA15_MAP),
     .DATA16_MAP         (DATA16_MAP),
     .DATA17_MAP         (DATA17_MAP),
     .MASK0_MAP          (MASK0_MAP),
     .MASK1_MAP          (MASK1_MAP),
     .SIM_CAL_OPTION     (SIM_CAL_OPTION),
     .MASTER_PHY_CTL     (MASTER_PHY_CTL),
     .DRAM_WIDTH         (DRAM_WIDTH),
     .POC_USE_METASTABLE_SAMP (POC_USE_METASTABLE_SAMP),
     .PI_DIV2_INCDEC     (PI_DIV2_INCDEC)
     )
    u_ddr_mc_phy_wrapper
      (
       .rst                 (rst),
       .iddr_rst            (iddr_rst),
       .clk                 (clk),
       .clk_div2            (clk_div2),
       // For memory frequencies between 400~1066 MHz freq_refclk = mem_refclk
       // For memory frequencies below 400 MHz mem_refclk = mem_refclk and
       // freq_refclk = 2x or 4x mem_refclk such that it remains in the
       // 400~1066 MHz range
       .freq_refclk         (freq_refclk),
       .mem_refclk          (mem_refclk),
       .mmcm_ps_clk         (mmcm_ps_clk),
       .pll_lock            (pll_lock),
       .sync_pulse          (sync_pulse),
       .idelayctrl_refclk   (clk_ref),
       .phy_cmd_wr_en       (mux_cmd_wren),
       .phy_data_wr_en      (mux_wrdata_en),
       // phy_ctl_wd = {ACTPRE[31:30],EventDelay[29:25],seq[24:23],
       //               DataOffset[22:17],HiIndex[16:15],LowIndex[14:12],
       //               AuxOut[11:8],ControlOffset[7:3],PHYCmd[2:0]}
       // The fields ACTPRE, and BankCount are only used
       // when the hard PHY counters are used by the MC.
       .phy_ctl_wd             ({5'd0, mux_cas_slot, calib_seq, mux_data_offset,
                                 mux_rank_cnt, 3'd0, aux_out_map,
                                 5'd0, mux_cmd}),
       .phy_ctl_wr             (mux_ctl_wren),
       .phy_if_empty_def       (phy_if_empty_def),
       .phy_if_reset           (phy_if_reset),
       .data_offset_1          (mux_data_offset_1),
       .data_offset_2          (mux_data_offset_2),
       .aux_in_1               (aux_out_map),
       .aux_in_2               (aux_out_map),
       .idelaye2_init_val      (idelaye2_init_val),
       .oclkdelay_init_val     (oclkdelay_init_val),
       .if_empty               (if_empty),
       .phy_ctl_full           (phy_ctl_full),
       .phy_cmd_full           (phy_cmd_full),
       .phy_data_full          (phy_data_full),
       .phy_pre_data_a_full    (phy_pre_data_a_full),
       .ddr_clk                (ddr_clk),
       .phy_mc_go              (phy_mc_go),
       .phy_write_calib        (phy_write_calib),
       .phy_read_calib         (phy_read_calib),
       .po_fine_enable         (po_enstg2_f),
       .po_coarse_enable       (po_enstg2_c),
       .po_fine_inc            (po_stg2_fincdec),
       .po_coarse_inc          (po_stg2_cincdec),
       .po_counter_load_en     (po_counter_load_en),
       .po_counter_read_en     (1'b1),
       .po_sel_fine_oclk_delay (po_sel_stg2stg3),
       .po_counter_load_val    (),
       .po_counter_read_val    (po_counter_read_val),
       .pi_rst_dqs_find        (pi_rst_dqs_find),
       .pi_fine_enable         (pi_fine_enable),
       .pi_fine_inc            (pi_fine_inc),
       .pi_counter_load_en     (pi_counter_load_en),
       .pi_counter_load_val    (pi_counter_load_val),
       .pi_counter_read_val    (pi_counter_read_val),
       .idelay_ce              (idelay_ce),
       .idelay_inc             (idelay_inc),
       .idelay_ld              (idelay_ld),
       .pi_phase_locked        (pi_phase_locked),
       .pi_phase_locked_all    (pi_phase_locked_all),
       .pi_dqs_found           (pi_found_dqs),
       .pi_dqs_found_all       (pi_dqs_found_all),
       // Currently not being used. May be used in future if periodic reads
       // become a requirement. This output could also be used to signal a
       // catastrophic failure in read capture and the need for re-cal
       .pi_dqs_out_of_range    (pi_dqs_out_of_range),
       .phy_init_data_sel      (phy_init_data_sel),
       .calib_sel              (calib_sel),
       .calib_in_common        (calib_in_common),
       .calib_zero_inputs      (calib_zero_inputs),
       .calib_zero_ctrl        (calib_zero_ctrl),
       .mux_address            (mux_address),
       .mux_bank               (mux_bank),
       .mux_cs_n               (mux_cs_n),
       .mux_ras_n              (mux_ras_n),
       .mux_cas_n              (mux_cas_n),
       .mux_we_n               (mux_we_n),
       .mux_reset_n            (mux_reset_n),
       .parity_in              (parity),
       .mux_wrdata             (mux_wrdata),
       .mux_wrdata_mask        (mux_wrdata_mask),
       .mux_odt                (mux_odt),
       .mux_cke            (mux_cke),
       .idle                   (idle),
       .rd_data                (rd_data_map),
       .ddr_addr               (ddr_addr),
       .ddr_ba                 (ddr_ba),
       .ddr_cas_n              (ddr_cas_n),
       .ddr_cke                (ddr_cke),
       .ddr_cs_n               (ddr_cs_n),
       .ddr_dm                 (ddr_dm),
       .ddr_odt                (ddr_odt),
       .ddr_parity             (ddr_parity),
       .ddr_ras_n              (ddr_ras_n),
       .ddr_we_n               (ddr_we_n),
       .ddr_dq                 (ddr_dq),
       .ddr_dqs                (ddr_dqs),
       .ddr_dqs_n              (ddr_dqs_n),
       .ddr_reset_n            (ddr_reset_n),
       .dbg_pi_counter_read_en (1'b1),
       .ref_dll_lock           (ref_dll_lock),
       .rst_phaser_ref         (rst_phaser_ref),
       .dbg_pi_phase_locked_phy4lanes (dbg_pi_phase_locked_phy4lanes),
       .dbg_pi_dqs_found_lanes_phy4lanes (dbg_pi_dqs_found_lanes_phy4lanes),
       .byte_sel_cnt           (byte_sel_cnt),
       .pd_out                 (pd_out),
       .fine_delay_incdec_pb   (fine_delay_incdec_pb),
       .fine_delay_sel         (fine_delay_sel)
       );

  //***************************************************************************
  // Soft memory initialization and calibration logic
  //***************************************************************************

  mig_7series_v4_2_ddr_calib_top #
    (
     .TCQ              (TCQ),
     .DDR3_VDD_OP_VOLT (DDR3_VDD_OP_VOLT),
     .nCK_PER_CLK      (nCK_PER_CLK),
     .PRE_REV3ES       (PRE_REV3ES),
     .tCK              (tCK),
     .CLK_PERIOD       (CLK_PERIOD),
     .N_CTL_LANES      (N_CTL_LANES),
     .CTL_BYTE_LANE    (CTL_BYTE_LANE),
     .CTL_BANK         (CTL_BANK),
     .DRAM_TYPE        (DRAM_TYPE),
     .PRBS_WIDTH       (8),
     .DQS_BYTE_MAP     (DQS_BYTE_MAP),
     .HIGHEST_BANK     (HIGHEST_BANK),
     .BANK_TYPE        (BANK_TYPE),
     .HIGHEST_LANE     (HIGHEST_LANE),
     .BYTE_LANES_B0    (BYTE_LANES_B0),
     .BYTE_LANES_B1    (BYTE_LANES_B1),
     .BYTE_LANES_B2    (BYTE_LANES_B2),
     .BYTE_LANES_B3    (BYTE_LANES_B3),
     .BYTE_LANES_B4    (BYTE_LANES_B4),
     .DATA_CTL_B0      (DATA_CTL_B0),
     .DATA_CTL_B1      (DATA_CTL_B1),
     .DATA_CTL_B2      (DATA_CTL_B2),
     .DATA_CTL_B3      (DATA_CTL_B3),
     .DATA_CTL_B4      (DATA_CTL_B4),
     .SLOT_1_CONFIG    (SLOT_1_CONFIG),
     .BANK_WIDTH       (BANK_WIDTH),
     .CA_MIRROR        (CA_MIRROR),
     .COL_WIDTH        (COL_WIDTH),
     .CKE_ODT_AUX      (CKE_ODT_AUX),
     .nCS_PER_RANK     (nCS_PER_RANK),
     .DQ_WIDTH         (DQ_WIDTH),
     .DQS_CNT_WIDTH    (DQS_CNT_WIDTH),
     .DQS_WIDTH        (DQS_WIDTH),
     .DRAM_WIDTH       (DRAM_WIDTH),
     .ROW_WIDTH        (ROW_WIDTH),
     .RANKS            (RANKS),
     .CS_WIDTH         (CS_WIDTH),
     .CKE_WIDTH        (CKE_WIDTH),
     .DDR2_DQSN_ENABLE (DDR2_DQSN_ENABLE),
     .PER_BIT_DESKEW   ("OFF"),
     .CALIB_ROW_ADD    (CALIB_ROW_ADD),
     .CALIB_COL_ADD    (CALIB_COL_ADD),
     .CALIB_BA_ADD     (CALIB_BA_ADD),
     .AL               (AL),
     .BURST_MODE       (BURST_MODE),
     .BURST_TYPE       (BURST_TYPE),
     .nCL              (CL),
     .nCWL             (CWL),
     .tRFC             (tRFC),
     .tREFI            (tREFI),
     .OUTPUT_DRV       (OUTPUT_DRV),
     .REG_CTRL         (REG_CTRL),
     .ADDR_CMD_MODE    (ADDR_CMD_MODE),
     .RTT_NOM          (RTT_NOM),
     .RTT_WR           (RTT_WR),
     .WRLVL            (WRLVL_W),
     .USE_ODT_PORT     (USE_ODT_PORT),
     .SIM_INIT_OPTION  (SIM_INIT_OPTION),
     .SIM_CAL_OPTION   (SIM_CAL_OPTION),
     .DEBUG_PORT       (DEBUG_PORT),
     .IDELAY_ADJ       (IDELAY_ADJ),
     .FINE_PER_BIT     (FINE_PER_BIT),
     .CENTER_COMP_MODE (CENTER_COMP_MODE),
     .PI_VAL_ADJ       (PI_VAL_ADJ),
     .TAPSPERKCLK      (TAPSPERKCLK),
     .POC_USE_METASTABLE_SAMP (POC_USE_METASTABLE_SAMP),
     .SKIP_CALIB       (SKIP_CALIB),
     .PI_DIV2_INCDEC   (PI_DIV2_INCDEC)
     )
    u_ddr_calib_top
      (
       .clk                         (clk),
       .rst                         (rst),

       .tg_err                      (error),
       .rst_tg_mc                   (rst_tg_mc),

       .slot_0_present              (slot_0_present),
       .slot_1_present              (slot_1_present),
       // PHY Control Block and IN_FIFO status
       .phy_ctl_ready               (phy_mc_go),
       .phy_ctl_full                (1'b0),
       .phy_cmd_full                (1'b0),
       .phy_data_full               (1'b0),
       .phy_if_empty                (if_empty),
       .idelaye2_init_val           (idelaye2_init_val),
       .oclkdelay_init_val          (oclkdelay_init_val),
       // From calib logic To data IN_FIFO
       // DQ IDELAY tap value from Calib logic
       // port to be added to mc_phy by Gary
       .dlyval_dq                   (),
       // hard PHY calibration modes
       .write_calib                 (phy_write_calib),
       .read_calib                  (phy_read_calib),
       // DQS count and ck/addr/cmd to be mapped to calib_sel
       // based on parameter that defines placement of ctl lanes
       // and DQS byte groups in each bank. When phy_write_calib
       // is de-asserted calib_sel should select CK/addr/cmd/ctl.
       .calib_sel                   (calib_sel),
       .calib_in_common             (calib_in_common),
       .calib_zero_inputs           (calib_zero_inputs),
       .calib_zero_ctrl             (calib_zero_ctrl),
       .phy_if_empty_def            (phy_if_empty_def),
       .phy_if_reset                (phy_if_reset),
       // Signals from calib logic to be MUXED with MC
       // signals before sending to hard PHY
       .calib_ctl_wren              (calib_ctl_wren),
       .calib_cmd_wren              (calib_cmd_wren),
       .calib_seq                   (calib_seq),
       .calib_aux_out               (calib_aux_out),
       .calib_odt               (calib_odt),
       .calib_cke           (calib_cke),
       .calib_cmd                   (calib_cmd),
       .calib_wrdata_en             (calib_wrdata_en),
       .calib_rank_cnt              (calib_rank_cnt),
       .calib_cas_slot              (calib_cas_slot),
       .calib_data_offset_0         (calib_data_offset_0),
       .calib_data_offset_1         (calib_data_offset_1),
       .calib_data_offset_2         (calib_data_offset_2),
       .phy_reset_n                 (phy_reset_n),
       .phy_address                 (phy_address),
       .phy_bank                    (phy_bank),
       .phy_cs_n                    (phy_cs_n),
       .phy_ras_n                   (phy_ras_n),
       .phy_cas_n                   (phy_cas_n),
       .phy_we_n                    (phy_we_n),
       .phy_wrdata                  (phy_wrdata),
       // DQS Phaser_IN calibration/status signals
       .pi_phaselocked              (pi_phase_locked),
       .pi_phase_locked_all         (pi_phase_locked_all),
       .pi_found_dqs                (pi_found_dqs),
       .pi_dqs_found_all            (pi_dqs_found_all),
       .pi_dqs_found_lanes          (dbg_pi_dqs_found_lanes_phy4lanes),
       .pi_rst_stg1_cal             (rst_stg1_cal),
       .pi_en_stg2_f                (pi_enstg2_f),
       .pi_stg2_f_incdec            (pi_stg2_fincdec),
       .pi_stg2_load                (pi_stg2_load),
       .pi_stg2_reg_l               (pi_stg2_reg_l),
       .pi_counter_read_val      (pi_counter_read_val),
       .device_temp                 (device_temp),
       .tempmon_sample_en           (tempmon_sample_en),
       // IDELAY tap enable and inc signals
       .idelay_ce                   (idelay_ce),
       .idelay_inc                  (idelay_inc),
       .idelay_ld                   (idelay_ld),
       // DQS Phaser_OUT calibration/status signals
       .po_sel_stg2stg3             (po_sel_stg2stg3),
       .po_stg2_c_incdec            (po_stg2_cincdec),
       .po_en_stg2_c                (po_enstg2_c),
       .po_stg2_f_incdec            (po_stg2_fincdec),
       .po_en_stg2_f                (po_enstg2_f),
       .po_counter_load_en          (po_counter_load_en),
       .po_counter_read_val         (po_counter_read_val),
       // From data IN_FIFO To Calib logic and MC/UI
       .phy_rddata                  (rd_data_map),
       // From calib logic To MC
       .phy_rddata_valid            (phy_rddata_valid_w),
       .calib_rd_data_offset_0      (calib_rd_data_offset_0),
       .calib_rd_data_offset_1      (calib_rd_data_offset_1),
       .calib_rd_data_offset_2      (calib_rd_data_offset_2),
       .calib_writes                (),
       // Mem Init and Calibration status To MC
       .init_calib_complete         (phy_init_data_sel),
       .init_wrcal_complete         (init_wrcal_complete),
       // Debug Error signals
       .pi_phase_locked_err         (dbg_pi_phaselock_err),
       .pi_dqsfound_err             (dbg_pi_dqsfound_err),
       .wrcal_err                   (dbg_wrcal_err),
       //used for oclk stg3 centering
       .pd_out                           (pd_out),
       .psen                             (psen),
       .psincdec                         (psincdec),
       .psdone                           (psdone),
       .poc_sample_pd                    (poc_sample_pd),
       .calib_tap_req               (calib_tap_req),
       .calib_tap_addr              (calib_tap_addr),
       .calib_tap_load              (calib_tap_load),
       .calib_tap_val               (calib_tap_val),
       .calib_tap_load_done         (calib_tap_load_done),
       // Debug Signals
       .dbg_pi_phaselock_start      (dbg_pi_phaselock_start),
       .dbg_pi_dqsfound_start       (dbg_pi_dqsfound_start),
       .dbg_pi_dqsfound_done        (dbg_pi_dqsfound_done),
       .dbg_wrlvl_start             (dbg_wrlvl_start),
       .dbg_wrlvl_done              (dbg_wrlvl_done),
       .dbg_wrlvl_err               (dbg_wrlvl_err),
       .dbg_wrlvl_fine_tap_cnt      (dbg_wrlvl_fine_tap_cnt),
       .dbg_wrlvl_coarse_tap_cnt    (dbg_wrlvl_coarse_tap_cnt),
       .dbg_phy_wrlvl               (dbg_phy_wrlvl),
       .dbg_tap_cnt_during_wrlvl    (dbg_tap_cnt_during_wrlvl),
       .dbg_wl_edge_detect_valid    (dbg_wl_edge_detect_valid),
       .dbg_rd_data_edge_detect     (dbg_rd_data_edge_detect),
       .dbg_wrcal_start             (dbg_wrcal_start),
       .dbg_wrcal_done              (dbg_wrcal_done),
       .dbg_phy_wrcal               (dbg_phy_wrcal),
       .dbg_final_po_fine_tap_cnt   (dbg_final_po_fine_tap_cnt),
       .dbg_final_po_coarse_tap_cnt (dbg_final_po_coarse_tap_cnt),
       .dbg_rdlvl_start             (dbg_rdlvl_start),
       .dbg_rdlvl_done              (dbg_rdlvl_done),
       .dbg_rdlvl_err               (dbg_rdlvl_err),
       .dbg_cpt_first_edge_cnt      (dbg_cpt_first_edge_cnt),
       .dbg_cpt_second_edge_cnt     (dbg_cpt_second_edge_cnt),
       .dbg_cpt_tap_cnt             (dbg_cpt_tap_cnt),
       .dbg_dq_idelay_tap_cnt       (dbg_dq_idelay_tap_cnt),
       .dbg_sel_pi_incdec           (dbg_sel_pi_incdec),
       .dbg_sel_po_incdec           (dbg_sel_po_incdec),
       .dbg_byte_sel                (dbg_byte_sel),
       .dbg_pi_f_inc                (dbg_pi_f_inc),
       .dbg_pi_f_dec                (dbg_pi_f_dec),
       .dbg_po_f_inc                (dbg_po_f_inc),
       .dbg_po_f_stg23_sel          (dbg_po_f_stg23_sel),
       .dbg_po_f_dec                (dbg_po_f_dec),
       .dbg_idel_up_all             (dbg_idel_up_all),
       .dbg_idel_down_all           (dbg_idel_down_all),
       .dbg_idel_up_cpt             (dbg_idel_up_cpt),
       .dbg_idel_down_cpt           (dbg_idel_down_cpt),
       .dbg_sel_idel_cpt            (dbg_sel_idel_cpt),
       .dbg_sel_all_idel_cpt        (dbg_sel_all_idel_cpt),
       .dbg_phy_rdlvl               (dbg_phy_rdlvl),
       .dbg_calib_top               (dbg_calib_top),
       .dbg_phy_init                (dbg_phy_init),
       .dbg_prbs_rdlvl              (dbg_prbs_rdlvl),
       .dbg_dqs_found_cal           (dbg_dqs_found_cal),
       .dbg_phy_oclkdelay_cal       (dbg_phy_oclkdelay_cal),
       .dbg_oclkdelay_rd_data       (dbg_oclkdelay_rd_data),
       .dbg_oclkdelay_calib_start   (dbg_oclkdelay_calib_start),
       .dbg_oclkdelay_calib_done    (dbg_oclkdelay_calib_done),
       .dbg_poc                     (dbg_poc[1023:0]),
       .prbs_final_dqs_tap_cnt_r (prbs_final_dqs_tap_cnt_r),
       .dbg_prbs_first_edge_taps (dbg_prbs_first_edge_taps),
       .dbg_prbs_second_edge_taps (dbg_prbs_second_edge_taps),
       .byte_sel_cnt           (byte_sel_cnt),
       .fine_delay_incdec_pb   (fine_delay_incdec_pb),
       .fine_delay_sel         (fine_delay_sel)
       );

endmodule

