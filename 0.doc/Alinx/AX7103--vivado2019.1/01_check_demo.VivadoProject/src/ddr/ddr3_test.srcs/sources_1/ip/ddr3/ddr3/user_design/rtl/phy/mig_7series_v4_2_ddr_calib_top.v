//*****************************************************************************
// (c) Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
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
//  /   /         Filename: ddr_calib_top.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:35:06 $
// \   \  /  \    Date Created: Aug 03 2009
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//Purpose:
//   Top-level for memory physical layer (PHY) interface
//   NOTES:
//     1. Need to support multiple copies of CS outputs
//     2. DFI_DRAM_CKE_DISABLE not supported
//
//Reference:
//Revision History:
//*****************************************************************************

/******************************************************************************
**$Id: ddr_calib_top.v,v 1.1 2011/06/02 08:35:06 mishra Exp $
**$Date: 2011/06/02 08:35:06 $
**$Author: mishra $
**$Revision: 1.1 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_calib_top.v,v $
******************************************************************************/

`timescale 1ps/1ps

module mig_7series_v4_2_ddr_calib_top #
  (
   parameter TCQ             = 100,
   parameter nCK_PER_CLK     = 2,       // # of memory clocks per CLK
   parameter tCK             = 2500,    // DDR3 SDRAM clock period
   parameter DDR3_VDD_OP_VOLT = "135",     // Voltage mode used for DDR3
   parameter CLK_PERIOD      = 3333,    // Internal clock period (in ps)
   parameter N_CTL_LANES     = 3,       // # of control byte lanes in the PHY
   parameter DRAM_TYPE       = "DDR3",  // Memory I/F type: "DDR3", "DDR2"
   parameter PRBS_WIDTH      = 8,      // The PRBS sequence is 2^PRBS_WIDTH
   parameter HIGHEST_LANE    = 4,
   parameter HIGHEST_BANK    = 3,
   parameter BANK_TYPE       = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
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
   parameter DQS_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00,
   parameter CTL_BYTE_LANE   = 8'hE4,    // Control byte lane map
   parameter CTL_BANK        = 3'b000,  // Bank used for control byte lanes
   // Slot Conifg parameters
   parameter [7:0] SLOT_1_CONFIG = 8'b0000_0000,
   // DRAM bus widths
   parameter BANK_WIDTH      = 2,       // # of bank bits
   parameter CA_MIRROR       = "OFF",   // C/A mirror opt for DDR3 dual rank
   parameter COL_WIDTH       = 10,      // column address width
   parameter nCS_PER_RANK    = 1,       // # of unique CS outputs per rank
   parameter DQ_WIDTH        = 64,      // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,       // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,       // # of DQS (strobe)
   parameter DRAM_WIDTH      = 8,       // # of DQ per DQS
   parameter ROW_WIDTH       = 14,      // DRAM address bus width
   parameter RANKS           = 1,       // # of memory ranks in the interface
   parameter CS_WIDTH        = 1,       // # of CS# signals in the interface
   parameter CKE_WIDTH       = 1,       // # of cke outputs
   parameter DDR2_DQSN_ENABLE = "YES",  // Enable differential DQS for DDR2
   parameter PER_BIT_DESKEW  = "ON",
   // calibration Address. The address given below will be used for calibration
   // read and write operations.
   parameter NUM_DQSFOUND_CAL = 1020,      // # of iteration of DQSFOUND calib
   parameter CALIB_ROW_ADD   = 16'h0000,// Calibration row address
   parameter CALIB_COL_ADD   = 12'h000, // Calibration column address
   parameter CALIB_BA_ADD    = 3'h0,    // Calibration bank address
   // DRAM mode settings
   parameter AL              = "0",     // Additive Latency option
   parameter TEST_AL         = "0",     // Additive Latency for internal use
   parameter ADDR_CMD_MODE   = "1T",    // ADDR/CTRL timing: "2T", "1T"
   parameter BURST_MODE      = "8",     // Burst length
   parameter BURST_TYPE      = "SEQ",   // Burst type
   parameter nCL             = 5,       // Read CAS latency (in clk cyc)
   parameter nCWL            = 5,       // Write CAS latency (in clk cyc)
   parameter tRFC            = 110000,  // Refresh-to-command delay
   parameter tREFI           = 7800000, // pS Refresh-to-Refresh delay
   parameter OUTPUT_DRV      = "HIGH",  // DRAM reduced output drive option
   parameter REG_CTRL        = "ON",    // "ON" for registered DIMM
   parameter RTT_NOM         = "60",    // ODT Nominal termination value
   parameter RTT_WR          = "60",    // ODT Write termination value
   parameter USE_ODT_PORT    = 0,       // 0 - No ODT output from FPGA
                                        // 1 - ODT output from FPGA
   parameter WRLVL           = "OFF",   // Enable write leveling
   parameter PRE_REV3ES       = "OFF",       // Delay O/Ps using Phaser_Out fine dly
   parameter POC_USE_METASTABLE_SAMP = "FALSE",

    // Simulation /debug options
   parameter SIM_INIT_OPTION = "NONE",  // Performs all initialization steps
   parameter SIM_CAL_OPTION  = "NONE",  // Performs all calibration steps
   parameter CKE_ODT_AUX     = "FALSE",
   parameter IDELAY_ADJ      = "ON",
   parameter FINE_PER_BIT    = "ON",
   parameter CENTER_COMP_MODE = "ON",
   parameter PI_VAL_ADJ       = "ON",
   parameter TAPSPERKCLK      = 56,
   parameter DEBUG_PORT       = "OFF",    // Enable debug port
   parameter SKIP_CALIB       = "FALSE",
   parameter PI_DIV2_INCDEC   = "TRUE"
   )
  (
   input                              clk,         // Internal (logic) clock
   input                              rst,         // Reset sync'ed to CLK
   // Slot present inputs
   input [7:0]                        slot_0_present,
   input [7:0]                        slot_1_present,
   // Hard PHY signals
   // From PHY Ctrl Block
   input                              phy_ctl_ready,
   input                              phy_ctl_full,
   input                              phy_cmd_full,
   input                              phy_data_full,
   // To PHY Ctrl Block
   output                             write_calib,
   output                             read_calib,
   output                             calib_ctl_wren,
   output                             calib_cmd_wren,
   output [1:0]                       calib_seq,
   output [3:0]                       calib_aux_out,
   output [nCK_PER_CLK -1:0]          calib_cke,
   output [1:0]               calib_odt,
   output [2:0]                       calib_cmd,
   output                             calib_wrdata_en,
   output [1:0]                       calib_rank_cnt,
   output [1:0]                       calib_cas_slot,
   output [5:0]                       calib_data_offset_0,
   output [5:0]                       calib_data_offset_1,
   output [5:0]                       calib_data_offset_2,
   output [nCK_PER_CLK*ROW_WIDTH-1:0] phy_address,
   output [nCK_PER_CLK*BANK_WIDTH-1:0]phy_bank,
   output [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] phy_cs_n,
   output [nCK_PER_CLK-1:0]           phy_ras_n,
   output [nCK_PER_CLK-1:0]           phy_cas_n,
   output [nCK_PER_CLK-1:0]           phy_we_n,
   output                             phy_reset_n,
   // To hard PHY wrapper
 output reg [5:0] calib_sel/* synthesis syn_maxfan = 10 */,
 output reg       calib_in_common/* synthesis syn_maxfan = 10 */,
 output reg [HIGHEST_BANK-1:0] calib_zero_inputs/* synthesis syn_maxfan = 10 */,
   output reg [HIGHEST_BANK-1:0]      calib_zero_ctrl,
   output                             phy_if_empty_def,
   output reg                         phy_if_reset,
//   output reg                         ck_addr_ctl_delay_done,
   // From DQS Phaser_In
   input                              pi_phaselocked,
   input                              pi_phase_locked_all,
   input                              pi_found_dqs,
   input                              pi_dqs_found_all,
   input [HIGHEST_LANE-1:0]           pi_dqs_found_lanes,
   input [5:0]                        pi_counter_read_val,
   // To DQS Phaser_In
   output [HIGHEST_BANK-1:0]          pi_rst_stg1_cal,
   output                             pi_en_stg2_f,
   output                             pi_stg2_f_incdec,
   output                             pi_stg2_load,
   output [5:0]                       pi_stg2_reg_l,
   // To DQ IDELAY
   output                             idelay_ce,
   output                             idelay_inc,
   output                             idelay_ld,
   // To DQS Phaser_Out
 output [2:0]       po_sel_stg2stg3 /* synthesis syn_maxfan = 3 */,
 output [2:0]       po_stg2_c_incdec /* synthesis syn_maxfan = 3 */,
 output [2:0]       po_en_stg2_c /* synthesis syn_maxfan = 3 */,
 output [2:0]       po_stg2_f_incdec /* synthesis syn_maxfan = 3 */,
 output [2:0]       po_en_stg2_f /* synthesis syn_maxfan = 3 */,
   output                             po_counter_load_en,
   input [8:0]                        po_counter_read_val,
   // To command Phaser_Out
   input                              phy_if_empty,
   input [4:0]                        idelaye2_init_val,
   input [5:0]                        oclkdelay_init_val,

   input                              tg_err,
   output                             rst_tg_mc,
   // Write data to OUT_FIFO
   output [2*nCK_PER_CLK*DQ_WIDTH-1:0]phy_wrdata,
   // To CNTVALUEIN input of DQ IDELAYs for perbit de-skew
   output [5*RANKS*DQ_WIDTH-1:0]      dlyval_dq,
   // IN_FIFO read enable during write leveling, write calibration,
   // and read leveling
   // Read data from hard PHY fans out to mc and calib logic
   input[2*nCK_PER_CLK*DQ_WIDTH-1:0]  phy_rddata,
   // To MC
   output [6*RANKS-1:0]               calib_rd_data_offset_0,
   output [6*RANKS-1:0]               calib_rd_data_offset_1,
   output [6*RANKS-1:0]               calib_rd_data_offset_2,
   output                             phy_rddata_valid,
   output                             calib_writes,
   (* max_fanout = 50 *) output reg   init_calib_complete/* synthesis syn_maxfan = 10 */,
   output                             init_wrcal_complete,
   output                             pi_phase_locked_err,
   output                             pi_dqsfound_err,
   output                             wrcal_err,
   input                              pd_out,
  // input                              mmcm_ps_clk,  //phase shift clock
  // input                              oclkdelay_fb_clk,  //Write DQS feedback clk
   //phase shift clock control
   output                             psen,
   output                             psincdec,
   input                              psdone,
   input                              poc_sample_pd,

   // Ports to be used when SKIP_CALIB="TRUE"
   output reg                         calib_tap_req,
   input [6:0]                        calib_tap_addr,
   input                              calib_tap_load,
   input [7:0]                        calib_tap_val,
   input                              calib_tap_load_done,

   // Debug Port
   output                             dbg_pi_phaselock_start,
   output                             dbg_pi_dqsfound_start,
   output                             dbg_pi_dqsfound_done,
   output                             dbg_wrcal_start,
   output                             dbg_wrcal_done,
   output                             dbg_wrlvl_start,
   output                             dbg_wrlvl_done,
   output                             dbg_wrlvl_err,
   output [6*DQS_WIDTH-1:0]           dbg_wrlvl_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]           dbg_wrlvl_coarse_tap_cnt,
   output [255:0]                     dbg_phy_wrlvl,
   output [5:0]                       dbg_tap_cnt_during_wrlvl,
   output                             dbg_wl_edge_detect_valid,
   output [DQS_WIDTH-1:0]             dbg_rd_data_edge_detect,

   // Write Calibration Logic
   output [6*DQS_WIDTH-1:0]           dbg_final_po_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]           dbg_final_po_coarse_tap_cnt,
   output [99:0]                      dbg_phy_wrcal,

   // Read leveling logic
   output [1:0]                       dbg_rdlvl_start,
   output [1:0]                       dbg_rdlvl_done,
   output [1:0]                       dbg_rdlvl_err,
   output [6*DQS_WIDTH*RANKS-1:0]     dbg_cpt_first_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0]     dbg_cpt_second_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0]     dbg_cpt_tap_cnt,
   output [5*DQS_WIDTH*RANKS-1:0]     dbg_dq_idelay_tap_cnt,

   // Delay control
   input  [11:0]                      device_temp,
   input                              tempmon_sample_en,
   input                              dbg_sel_pi_incdec,
   input                              dbg_sel_po_incdec,
   input [DQS_CNT_WIDTH:0]            dbg_byte_sel,
   input                              dbg_pi_f_inc,
   input                              dbg_pi_f_dec,
   input                              dbg_po_f_inc,
   input                              dbg_po_f_stg23_sel,
   input                              dbg_po_f_dec,
   input                              dbg_idel_up_all,
   input                              dbg_idel_down_all,
   input                              dbg_idel_up_cpt,
   input                              dbg_idel_down_cpt,
   input [DQS_CNT_WIDTH-1:0]          dbg_sel_idel_cpt,
   input                              dbg_sel_all_idel_cpt,
   output [255:0]                     dbg_phy_rdlvl, // Read leveling calibration
   output [255:0]                     dbg_calib_top,   // General PHY debug
   output                             dbg_oclkdelay_calib_start,
   output                             dbg_oclkdelay_calib_done,
   output [255:0]                     dbg_phy_oclkdelay_cal,
   output [DRAM_WIDTH*16 -1:0]        dbg_oclkdelay_rd_data,
   output [255:0]                     dbg_phy_init,
   output [255:0]                     dbg_prbs_rdlvl,
   output [255:0]                     dbg_dqs_found_cal,
   output [1023:0]                    dbg_poc,

   output [6*DQS_WIDTH*RANKS-1:0] prbs_final_dqs_tap_cnt_r,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_first_edge_taps,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_prbs_second_edge_taps,
   output reg [DQS_CNT_WIDTH:0]   byte_sel_cnt,
   output [DRAM_WIDTH-1:0]        fine_delay_incdec_pb,  //fine_delay decreament per bit
   output                         fine_delay_sel
   );

   function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
   endfunction

// Advance ODELAY of DQ by extra 0.25*tCK (quarter clock cycle) to center
// align DQ and DQS on writes. Round (up or down) value to nearest integer
// localparam integer SHIFT_TBY4_TAP
//             = (CLK_PERIOD + (nCK_PER_CLK*(1000000/(REFCLK_FREQ*64))*2)-1) /
//             (nCK_PER_CLK*(1000000/(REFCLK_FREQ*64))*4);

// Calculate number of slots in the system
  localparam nSLOTS  = 1 + (|SLOT_1_CONFIG ? 1 : 0);

  localparam OCAL_EN = ((SIM_CAL_OPTION == "FAST_CAL") || (tCK >= 2500) || (SKIP_CALIB == "TRUE")) ? "OFF" : "ON"; //DIV2 change

  // Different CTL_LANES value for DDR2. In DDR2 during DQS found all
  // the add,ctl & data phaser out fine delays will be adjusted.
  // In DDR3 only the add/ctrl lane delays will be adjusted
  localparam DQS_FOUND_N_CTL_LANES = (DRAM_TYPE == "DDR3") ? N_CTL_LANES : 1;

  localparam DQSFOUND_CAL    = (BANK_TYPE == "HR_IO" || BANK_TYPE == "HRL_IO" || (BANK_TYPE == "HPL_IO" && tCK >= 2500)) ? "LEFT" : "RIGHT"; // DIV2 change IO Bank used for Memory I/F: "LEFT", "RIGHT"

  localparam FIXED_VICTIM  = (SIM_CAL_OPTION == "NONE") ? "FALSE" : "TRUE";
  localparam VCCO_PAT_EN   = 1;  // Enable VCCO pattern during calibration
  localparam VCCAUX_PAT_EN = 1;  // Enable VCCAUX pattern during calibration
  localparam ISI_PAT_EN    = 1;  // Enable VCCO pattern during calibration

  //Per-bit deskew for higher freqency (>800Mhz)
  //localparam FINE_DELAY = (tCK < 1250) ? "ON" : "OFF";

  //BYPASS
  localparam BYPASS_COMPLEX_RDLVL = ((tCK > 2500) || (SKIP_CALIB == "TRUE")) ? "TRUE": "FALSE"; //"TRUE";
  localparam BYPASS_COMPLEX_OCAL = "TRUE";
  //localparam BYPASS_COMPLEX_OCAL = ((DRAM_TYPE == "DDR2") || (nCK_PER_CLK == 2) || (OCAL_EN == "OFF")) ? "TRUE" : "FALSE";

  // 8*tREFI in ps is divided by the fabric clock period in ps
  // 270 fabric clock cycles is subtracted to account for PRECHARGE, WR, RD times
  localparam REFRESH_TIMER = (8*tREFI/(tCK*nCK_PER_CLK)) - 270;

  localparam REFRESH_TIMER_WIDTH = clogb2(REFRESH_TIMER);

  wire [2*8*nCK_PER_CLK-1:0]          prbs_seed;
  //wire [2*8*nCK_PER_CLK-1:0]          prbs_out;
  wire [8*DQ_WIDTH-1:0]               prbs_out;
  wire [7:0]                          prbs_rise0;
  wire [7:0]                          prbs_fall0;
  wire [7:0]                          prbs_rise1;
  wire [7:0]                          prbs_fall1;
  wire [7:0]                          prbs_rise2;
  wire [7:0]                          prbs_fall2;
  wire [7:0]                          prbs_rise3;
  wire [7:0]                          prbs_fall3;
  //wire [2*8*nCK_PER_CLK-1:0]          prbs_o;
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0]   prbs_o;
  wire                                dqsfound_retry;
  wire                                dqsfound_retry_done;
  wire                                phy_rddata_en;
  wire                                prech_done;
  wire                                rdlvl_stg1_done;
  reg                                 rdlvl_stg1_done_r1;
  wire                                pi_dqs_found_done;
  wire                                rdlvl_stg1_err;
  wire                                pi_dqs_found_err;
  wire                                wrcal_pat_resume;
  wire                                wrcal_resume_w;
  wire                                rdlvl_prech_req;
  wire                                rdlvl_last_byte_done;
  wire                                rdlvl_stg1_start;
  wire                                rdlvl_stg1_rank_done;
  wire                                rdlvl_assrt_common;
  wire                                pi_dqs_found_start;
  wire                                pi_dqs_found_rank_done;
  wire                                wl_sm_start;
  wire                                wrcal_start;
  wire                                wrcal_rd_wait;
  wire                                wrcal_prech_req;
  wire                                wrcal_pat_err;
  wire                                wrcal_done;
  wire                                wrlvl_done;
  wire                                wrlvl_err;
  wire                                wrlvl_start;
  wire                                ck_addr_cmd_delay_done;
  wire                                po_ck_addr_cmd_delay_done;
  wire                                pi_calib_done;
  wire                                detect_pi_found_dqs;
  wire [5:0]                          rd_data_offset_0;
  wire [5:0]                          rd_data_offset_1;
  wire [5:0]                          rd_data_offset_2;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_0;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_1;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_2;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_mc_0;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_mc_1;
  wire [6*RANKS-1:0]                  rd_data_offset_ranks_mc_2;
  wire                                cmd_po_stg2_f_incdec;
  wire                                cmd_po_stg2_incdec_ddr2_c;
  wire                                cmd_po_en_stg2_f;
  wire                                cmd_po_en_stg2_ddr2_c;
  wire                                cmd_po_stg2_c_incdec;
  wire                                cmd_po_en_stg2_c;
  wire                                po_stg2_ddr2_incdec;
  wire                                po_en_stg2_ddr2;
  wire                                dqs_po_stg2_f_incdec;
  wire                                dqs_po_en_stg2_f;
  wire                                dqs_wl_po_stg2_c_incdec;
  wire                                wrcal_po_stg2_c_incdec;
  wire                                dqs_wl_po_en_stg2_c;
  wire                                wrcal_po_en_stg2_c;
  wire [N_CTL_LANES-1:0]              ctl_lane_cnt;
  reg [N_CTL_LANES-1:0]               ctl_lane_sel;
  wire [DQS_CNT_WIDTH:0]              po_stg2_wrcal_cnt;
  wire [DQS_CNT_WIDTH:0]              po_stg2_wl_cnt;
  wire [DQS_CNT_WIDTH:0]              po_stg2_ddr2_cnt;
  wire [8:0]                          dqs_wl_po_stg2_reg_l;
  wire                                dqs_wl_po_stg2_load;
  wire [8:0]                          dqs_po_stg2_reg_l;
  wire                                dqs_po_stg2_load;
  wire                                dqs_po_dec_done;
  wire                                pi_fine_dly_dec_done;
  wire                                rdlvl_pi_stg2_f_incdec;
  wire                                rdlvl_pi_stg2_f_en;
  wire [DQS_CNT_WIDTH:0]              pi_stg2_rdlvl_cnt;
  //reg [DQS_CNT_WIDTH:0]               byte_sel_cnt;
  wire [3*DQS_WIDTH-1:0]              wl_po_coarse_cnt;
  wire [6*DQS_WIDTH-1:0]              wl_po_fine_cnt;
  wire                                phase_locked_err;
  wire                                phy_ctl_rdy_dly;
  wire                                idelay_ce_int;
  wire                                idelay_inc_int;
  reg                                 idelay_ce_r1;
  reg                                 idelay_ce_r2;
  reg                                 idelay_inc_r1;
 reg        idelay_inc_r2 /* synthesis syn_maxfan = 30 */;
  reg                                 po_dly_req_r;
  wire                                wrcal_read_req;
  wire                                wrcal_act_req;
  wire                                temp_wrcal_done;
  wire                                tg_timer_done;
  wire                                no_rst_tg_mc;
  wire                                calib_complete;
  reg                                 reset_if_r1;
  reg                                 reset_if_r2;
  reg                                 reset_if_r3;
  reg                                 reset_if_r4;
  reg                                 reset_if_r5;
  reg                                 reset_if_r6;
  reg                                 reset_if_r7;
  reg                                 reset_if_r8;
  reg                                 reset_if_r9;
  reg                                 reset_if;
  wire                                phy_if_reset_w;
  wire                                pi_phaselock_start;

  reg                                 dbg_pi_f_inc_r;
  reg                                 dbg_pi_f_en_r;
  reg                                 dbg_sel_pi_incdec_r;

  reg                                 dbg_po_f_inc_r;
  reg                                 dbg_po_f_stg23_sel_r;
  reg                                 dbg_po_f_en_r;
  reg                                 dbg_sel_po_incdec_r;

  reg                                 tempmon_pi_f_inc_r;
  reg                                 tempmon_pi_f_en_r;
  reg                                 tempmon_sel_pi_incdec_r;

  reg                                 ck_addr_cmd_delay_done_r1;
  reg                                 ck_addr_cmd_delay_done_r2;
  reg                                 ck_addr_cmd_delay_done_r3;
  reg                                 ck_addr_cmd_delay_done_r4;
  reg                                 ck_addr_cmd_delay_done_r5;
  reg                                 ck_addr_cmd_delay_done_r6;
//  wire                                oclk_init_delay_start;
  wire                                oclk_prech_req;
  wire                                oclk_calib_resume;
  wire [DQS_CNT_WIDTH:0]              oclkdelay_calib_cnt;
  wire [DQS_CNT_WIDTH:0]              complex_oclkdelay_calib_cnt;
  wire                                oclkdelay_calib_start;
  wire                                oclkdelay_calib_done;
  wire                                complex_oclk_prech_req;
  wire                                complex_oclk_calib_resume;
  wire                                complex_oclkdelay_calib_start;
  wire                                complex_oclkdelay_calib_done;
  wire                                complex_ocal_num_samples_inc;
  wire                                complex_ocal_num_samples_done_r;
  wire [2:0]                          complex_ocal_rd_victim_sel;
  wire                                complex_ocal_ref_req;
  wire                                complex_ocal_ref_done;
  wire [6*DQS_WIDTH-1:0]              oclkdelay_left_edge_val;
  wire [6*DQS_WIDTH-1:0]              oclkdelay_right_edge_val;

  wire                                wrlvl_final;
  wire                                complex_wrlvl_final;
  reg                                 wrlvl_final_mux;
  wire                                wrlvl_final_if_rst;
  wire                                wrlvl_byte_redo;
  wire                                wrlvl_byte_done;
  wire                                early1_data;
  wire                                early2_data;
  wire                                po_stg23_sel;
  wire                                po_stg23_incdec;
  wire                                po_en_stg23;
  wire                                complex_po_stg23_sel;
  wire                                complex_po_stg23_incdec;
  wire                                complex_po_en_stg23;
  wire                                mpr_rdlvl_done;
  wire                                mpr_rdlvl_start;
  wire                                mpr_last_byte_done;
  wire                                mpr_rnk_done;
  wire                                mpr_end_if_reset;
  wire                                mpr_rdlvl_err;
  wire                                rdlvl_err;
  wire                                prbs_rdlvl_start;
  wire                                prbs_rdlvl_done;
  wire                                prbs_rdlvl_done_complex;
  reg                                 prbs_rdlvl_done_r1;
  wire                                prbs_last_byte_done;
  wire                                prbs_rdlvl_prech_req;
  wire                                prbs_pi_stg2_f_incdec;
  wire                                prbs_pi_stg2_f_en;
  wire                                complex_sample_cnt_inc;
  wire                                complex_sample_cnt_inc_ocal;
  wire [DQS_CNT_WIDTH:0]              pi_stg2_prbs_rdlvl_cnt;
  wire                                prbs_gen_clk_en;
  wire                                prbs_gen_oclk_clk_en;
  wire                                rd_data_offset_cal_done;
  wire                                fine_adjust_done;
  wire [N_CTL_LANES-1:0]              fine_adjust_lane_cnt;
  wire                                ck_po_stg2_f_indec;
  wire                                ck_po_stg2_f_en;
  wire                                dqs_found_prech_req;
  wire                                tempmon_pi_f_inc;
  wire                                tempmon_pi_f_dec;
  wire                                tempmon_sel_pi_incdec;
  wire                                wrcal_sanity_chk;
  wire                                wrcal_sanity_chk_done;
  wire                                wrlvl_done_w;
  wire                                wrlvl_rank_done;
  wire                                done_dqs_tap_inc;
  wire [2:0]                          rd_victim_sel;
  wire [2:0]                          victim_sel;
  wire [DQS_CNT_WIDTH:0]              victim_byte_cnt;
  wire                                complex_wr_done;
  wire                                complex_victim_inc;

  wire                                reset_rd_addr;
  wire                                complex_ocal_reset_rd_addr;

  wire                                oclkdelay_center_calib_start;
  wire                                poc_error;

  wire                                prbs_ignore_first_byte;
  wire                                prbs_ignore_last_bytes;

  //stg3 tap values
 // wire [6*DQS_WIDTH-1:0]              oclkdelay_center_val;

   //byte selection
 // wire [DQS_CNT_WIDTH:0]              oclkdelay_center_cnt;

   //INC/DEC for stg3 taps
 // wire                                ocal_ctr_po_stg23_sel;
 // wire                                ocal_ctr_po_stg23_incdec;
 // wire                                ocal_ctr_po_en_stg23;

  //Write resume for DQS toggling
  wire                                oclk_center_write_resume;
  wire                                oclkdelay_center_calib_done;

  //Write request to toggle DQS for limit module
  wire                                lim2init_write_request;
  wire                                lim_done;

  // Bypass complex ocal
  wire                                complex_oclkdelay_calib_start_w;
  wire                                complex_oclkdelay_calib_done_w;
  wire [2:0]                          complex_ocal_rd_victim_sel_w;
  wire                                complex_wrlvl_final_w;

  wire [255:0]                        dbg_ocd_lim;

   //with MMCM phase detect logic
  //wire                                mmcm_edge_detect_rdy;    // ready for MMCM detect
  //wire                                ktap_at_rightedge;       // stg3 tap at right edge
  //wire                                ktap_at_leftedge;        // stg3 tap at left edge
  //wire                                mmcm_tap_at_center;     // indicate stg3 tap at center
  //wire                                mmcm_ps_clkphase_ok;    // ps clkphase is OK
  //wire                                mmcm_edge_detect_done;  // mmcm edge detect is done
  //wire                                mmcm_lbclk_edges_aligned; // mmcm edge detect is done
  //wire                                reset_mmcm;             //mmcm detect logic reset per byte

 // wire [255:0]                        dbg_phy_oclkdelay_center_cal;

 //PI inc/dec prevention during READ
 wire                                 rdlvl_pi_incdec;
 wire                                 complex_act_start;
 wire                                 complex_pi_incdec_done;
 wire                                 num_samples_done_r;
 wire                                 complex_init_pi_dec_done;

  wire                                calib_tap_inc_start;
  wire                                calib_tap_inc_done;
  wire                                calib_tap_end_if_reset;
  wire [5:0]                          calib_tap_inc_byte_cnt;
  wire                                calib_po_f_en;
  wire                                calib_po_f_incdec;
  wire                                calib_po_sel_stg2stg3;
  wire                                calib_po_c_en;
  wire                                calib_po_c_inc;
  wire                                calib_pi_f_en;
  wire                                calib_pi_f_incdec;
  wire                                calib_idelay_ce;
  wire                                calib_idelay_inc;
  wire                                coarse_dec_err;
  reg                                 skip_cal_tempmon_samp_en;
  wire                                tempmon_done_skip;

  wire                                skip_cal_po_pi_dec_done;
  reg [6*DQS_WIDTH-1:0]               calib_po_stage2_tap_cnt;
  reg [6*DQS_WIDTH-1:0]               calib_po_stage3_tap_cnt;
  reg [3*DQS_WIDTH-1:0]               calib_po_coarse_tap_cnt;
  reg [6*DQS_WIDTH-1:0]               calib_pi_stage2_tap_cnt;
  reg [5*DQS_WIDTH-1:0]               calib_idelay_tap_cnt;
  reg [11:0]                          calib_device_temp;
  wire [127:0]                        dbg_skip_cal;

  //*****************************************************************************
  // Assertions to check correctness of parameter values
  //*****************************************************************************
  // synthesis translate_off
  initial
  begin
    if (RANKS == 0) begin
      $display ("Error: Invalid RANKS parameter. Must be 1 or greater");
      $finish;
    end
    if (phy_ctl_full == 1'b1) begin
      $display ("Error: Incorrect phy_ctl_full input value in 2:1 or 4:1 mode");
      $finish;
    end
  end
  // synthesis translate_on

  //***************************************************************************
  // Debug
  //***************************************************************************
  reg if_empty_reg;
  reg pi_stg2_en_reg;

  assign prbs_rdlvl_done = (SIM_CAL_OPTION == "FAST_CAL")? rdlvl_stg1_done : prbs_rdlvl_done_complex;

  assign dbg_pi_phaselock_start = pi_phaselock_start;
  assign dbg_pi_dqsfound_start  = pi_dqs_found_start;
  assign dbg_pi_dqsfound_done   = pi_dqs_found_done;
  assign dbg_wrcal_start        = wrcal_start;
  assign dbg_wrcal_done         = wrcal_done;

  // Unused for now - use these as needed to bring up lower level signals
  //assign dbg_calib_top = dbg_ocd_lim;
  assign dbg_calib_top[0] = pi_stg2_en_reg ;
  assign dbg_calib_top[1] = if_empty_reg ;
  assign dbg_calib_top[3]     = coarse_dec_err;
  assign dbg_calib_top[4]     = calib_tap_inc_start;
  assign dbg_calib_top[5]     = calib_tap_inc_done;
  assign dbg_calib_top[6+:63] = dbg_skip_cal;

  always @ (posedge clk) begin
    if_empty_reg <= #TCQ  phy_if_empty;
    pi_stg2_en_reg <= #TCQ pi_en_stg2_f;
  end

  // Write Level and write calibration debug observation ports
  assign dbg_wrlvl_start           = wrlvl_start;
  assign dbg_wrlvl_done            = wrlvl_done;
  assign dbg_wrlvl_err             = wrlvl_err;

  // Read Level debug observation ports
  assign dbg_rdlvl_start           = {mpr_rdlvl_start, rdlvl_stg1_start};
  assign dbg_rdlvl_done            = {mpr_rdlvl_done, rdlvl_stg1_done};
  assign dbg_rdlvl_err             = {mpr_rdlvl_err, rdlvl_err};

  assign dbg_oclkdelay_calib_done  = oclkdelay_calib_done;
  assign dbg_oclkdelay_calib_start = oclkdelay_calib_start;

  //***************************************************************************
  // Write leveling dependent signals
  //***************************************************************************

  assign wrcal_resume_w = (WRLVL == "ON") ? wrcal_pat_resume : 1'b0;
  assign wrlvl_done_w   = (WRLVL == "ON") ? wrlvl_done : 1'b1;
  assign ck_addr_cmd_delay_done = (WRLVL == "ON") ? po_ck_addr_cmd_delay_done :
                                                    (po_ck_addr_cmd_delay_done
                                                    && pi_fine_dly_dec_done) ;

generate
   if((WRLVL == "ON") && (BYPASS_COMPLEX_OCAL=="FALSE")) begin: complex_oclk_calib
    assign complex_oclkdelay_calib_start_w = complex_oclkdelay_calib_start;
    assign complex_oclkdelay_calib_done_w  = complex_oclkdelay_calib_done;
    assign complex_ocal_rd_victim_sel_w    = complex_ocal_rd_victim_sel;
    assign complex_wrlvl_final_w           = complex_wrlvl_final;
   end else begin: bypass_complex_ocal
    assign complex_oclkdelay_calib_start_w = 1'b0;
    assign complex_oclkdelay_calib_done_w  = prbs_rdlvl_done;
    assign complex_ocal_rd_victim_sel_w    = 'd0;
    assign complex_wrlvl_final_w           = 1'b0;
   end
endgenerate


  generate
  genvar i;
    for (i = 0; i <= 2; i = i+1) begin : bankwise_signal

      assign po_sel_stg2stg3[i]  = ((ck_addr_cmd_delay_done && ~oclkdelay_calib_done && mpr_rdlvl_done) ? po_stg23_sel :
                                   (complex_oclkdelay_calib_start_w&&~complex_oclkdelay_calib_done_w? po_stg23_sel : 1'b0 )
                                  // (~oclkdelay_center_calib_done? ocal_ctr_po_stg23_sel:1'b0))
                                   ) || calib_po_sel_stg2stg3 || dbg_po_f_stg23_sel_r;

      assign po_stg2_c_incdec[i] =  cmd_po_stg2_c_incdec ||
                                    cmd_po_stg2_incdec_ddr2_c ||
                                    calib_po_c_inc ||
                                    dqs_wl_po_stg2_c_incdec;

      assign po_en_stg2_c[i]     = cmd_po_en_stg2_c ||
                                   cmd_po_en_stg2_ddr2_c ||
                                   calib_po_c_en ||
                                   dqs_wl_po_en_stg2_c;

      assign po_stg2_f_incdec[i] = dqs_po_stg2_f_incdec ||
                                   cmd_po_stg2_f_incdec ||
                                   ck_po_stg2_f_indec ||
                                   po_stg23_incdec ||
                                   calib_po_f_incdec ||
                                  // complex_po_stg23_incdec ||
                                  // ocal_ctr_po_stg23_incdec ||
                                   dbg_po_f_inc_r;

      assign po_en_stg2_f[i]     = dqs_po_en_stg2_f ||
                                   cmd_po_en_stg2_f ||
                                   ck_po_stg2_f_en ||
                                   po_en_stg23 ||
                                   calib_po_f_en ||
                                  // complex_po_en_stg23 ||
                                  // ocal_ctr_po_en_stg23 ||
                                   dbg_po_f_en_r;

    end
  endgenerate

  assign pi_stg2_f_incdec = (calib_pi_f_incdec | dbg_pi_f_inc_r | rdlvl_pi_stg2_f_incdec | prbs_pi_stg2_f_incdec | tempmon_pi_f_inc_r);
  assign pi_en_stg2_f     = (calib_pi_f_en | dbg_pi_f_en_r | rdlvl_pi_stg2_f_en | prbs_pi_stg2_f_en | tempmon_pi_f_en_r);

  assign idelay_ce  = (idelay_ce_r2 | calib_idelay_ce);
  assign idelay_inc = (idelay_inc_r2 | calib_idelay_inc);

  assign po_counter_load_en = 1'b0;

  assign complex_oclkdelay_calib_cnt = oclkdelay_calib_cnt;
  assign complex_oclk_calib_resume   = oclk_calib_resume;
  assign complex_ocal_ref_req        = oclk_prech_req;


// Added single stage flop to meet timing
  always @(posedge clk) begin
    if (SKIP_CALIB == "FALSE")
    init_calib_complete <= calib_complete;
    else
      init_calib_complete <= tempmon_done_skip;
  end

  assign calib_rd_data_offset_0 = rd_data_offset_ranks_mc_0;
  assign calib_rd_data_offset_1 = rd_data_offset_ranks_mc_1;
  assign calib_rd_data_offset_2 = rd_data_offset_ranks_mc_2;

  //***************************************************************************
  // Hard PHY signals
  //***************************************************************************

  assign pi_phase_locked_err = phase_locked_err;
  assign pi_dqsfound_err     = pi_dqs_found_err;
  assign wrcal_err           = wrcal_pat_err;
  assign rst_tg_mc           = 1'b0;

//Restart WRLVL after oclkdealy cal
  always @ (posedge clk)
    wrlvl_final_mux <= #TCQ complex_oclkdelay_calib_start_w? complex_wrlvl_final_w: wrlvl_final;


  always @(posedge clk)
    phy_if_reset <= #TCQ (phy_if_reset_w | mpr_end_if_reset |
                          reset_if | wrlvl_final_if_rst | calib_tap_end_if_reset);

  //***************************************************************************
  // Phaser_IN inc dec control for debug
  //***************************************************************************

  always @(posedge clk) begin
    if (rst) begin
      dbg_pi_f_inc_r      <= #TCQ 1'b0;
      dbg_pi_f_en_r       <= #TCQ 1'b0;
      dbg_sel_pi_incdec_r <= #TCQ 1'b0;
    end else begin
      dbg_pi_f_inc_r      <= #TCQ dbg_pi_f_inc;
      dbg_pi_f_en_r       <= #TCQ (dbg_pi_f_inc | dbg_pi_f_dec);
      dbg_sel_pi_incdec_r <= #TCQ dbg_sel_pi_incdec;
    end
  end

  //***************************************************************************
  // Phaser_OUT inc dec control for debug
  //***************************************************************************

  always @(posedge clk) begin
    if (rst) begin
      dbg_po_f_inc_r      <= #TCQ 1'b0;
      dbg_po_f_stg23_sel_r<= #TCQ 1'b0;
      dbg_po_f_en_r       <= #TCQ 1'b0;
      dbg_sel_po_incdec_r <= #TCQ 1'b0;
    end else begin
      dbg_po_f_inc_r      <= #TCQ dbg_po_f_inc;
      dbg_po_f_stg23_sel_r<= #TCQ dbg_po_f_stg23_sel;
      dbg_po_f_en_r       <= #TCQ (dbg_po_f_inc | dbg_po_f_dec);
      dbg_sel_po_incdec_r <= #TCQ dbg_sel_po_incdec;
    end
  end

  //***************************************************************************
  // Phaser_IN inc dec control for temperature tracking
  //***************************************************************************

  always @(posedge clk) begin
    if (rst) begin
      tempmon_pi_f_inc_r      <= #TCQ 1'b0;
      tempmon_pi_f_en_r       <= #TCQ 1'b0;
      tempmon_sel_pi_incdec_r <= #TCQ 1'b0;
    end else begin
      tempmon_pi_f_inc_r      <= #TCQ tempmon_pi_f_inc;
      tempmon_pi_f_en_r       <= #TCQ (tempmon_pi_f_inc | tempmon_pi_f_dec);
      tempmon_sel_pi_incdec_r <= #TCQ tempmon_sel_pi_incdec;
    end
  end

  //***************************************************************************
  // OCLKDELAY calibration signals
  //***************************************************************************

  // Minimum of 5 'clk' cycles required between assertion of po_sel_stg2stg3
  // and increment/decrement of Phaser_Out stage 3 delay
  always @(posedge clk) begin
    ck_addr_cmd_delay_done_r1 <= #TCQ ck_addr_cmd_delay_done;
    ck_addr_cmd_delay_done_r2 <= #TCQ ck_addr_cmd_delay_done_r1;
    ck_addr_cmd_delay_done_r3 <= #TCQ ck_addr_cmd_delay_done_r2;
    ck_addr_cmd_delay_done_r4 <= #TCQ ck_addr_cmd_delay_done_r3;
    ck_addr_cmd_delay_done_r5 <= #TCQ ck_addr_cmd_delay_done_r4;
    ck_addr_cmd_delay_done_r6 <= #TCQ ck_addr_cmd_delay_done_r5;
  end




  //***************************************************************************
  // MUX select logic to select current byte undergoing calibration
  // Use DQS_CAL_MAP to determine the correlation between the physical
  // byte numbering, and the byte numbering within the hard PHY
  //***************************************************************************
generate
  if (SKIP_CALIB == "TRUE") begin: gen_byte_sel_skip_calib
    always @(posedge clk) begin
      if (rst) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b0;
      end else if (~skip_cal_po_pi_dec_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done && (WRLVL !="ON")) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done) begin
        ctl_lane_sel    <= #TCQ ctl_lane_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~fine_adjust_done && rd_data_offset_cal_done) begin
        if ((|pi_rst_stg1_cal) || (DRAM_TYPE == "DDR2")) begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ 'd0;
          calib_in_common <= #TCQ 1'b1;
        end else begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ fine_adjust_lane_cnt;
          calib_in_common <= #TCQ 1'b0;
        end
      end else if (~pi_calib_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~pi_dqs_found_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~calib_tap_inc_done) begin
        byte_sel_cnt    <= #TCQ calib_tap_inc_byte_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (dbg_sel_pi_incdec_r | dbg_sel_po_incdec_r) begin
        byte_sel_cnt    <= #TCQ dbg_byte_sel;
        calib_in_common <= #TCQ 1'b0;
      end else if (tempmon_sel_pi_incdec) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end
    end
  end else if (tCK >= 2500) begin: gen_byte_sel_div2  // DIV2 change

    always @(posedge clk) begin
      if (rst) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b0;
      end else if (~(dqs_po_dec_done && pi_fine_dly_dec_done)) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done && (WRLVL !="ON")) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done) begin
        ctl_lane_sel    <= #TCQ ctl_lane_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~fine_adjust_done && rd_data_offset_cal_done) begin
        if ((|pi_rst_stg1_cal) || (DRAM_TYPE == "DDR2")) begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ 'd0;
          calib_in_common <= #TCQ 1'b1;
        end else begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ fine_adjust_lane_cnt;
          calib_in_common <= #TCQ 1'b0;
        end
      end else if (~pi_calib_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~pi_dqs_found_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~wrlvl_done_w) begin
        if (SIM_CAL_OPTION != "FAST_CAL") begin
          byte_sel_cnt    <= #TCQ po_stg2_wl_cnt;
          calib_in_common <= #TCQ 1'b0;
        end else begin
          // Special case for FAST_CAL simulation only to ensure that
          // calib_in_common isn't asserted too soon
          if (!phy_ctl_rdy_dly) begin
            byte_sel_cnt    <= #TCQ 'd0;
            calib_in_common <= #TCQ 1'b0;
          end else begin
            byte_sel_cnt    <= #TCQ po_stg2_wl_cnt;
            calib_in_common <= #TCQ 1'b1;
          end
        end
      end else if (~mpr_rdlvl_done) begin
        byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~oclkdelay_calib_done) begin
        byte_sel_cnt    <= #TCQ oclkdelay_calib_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~rdlvl_stg1_done && pi_calib_done) begin
        if ((SIM_CAL_OPTION == "FAST_CAL") && rdlvl_assrt_common) begin
          byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
          calib_in_common <= #TCQ 1'b1;
        end else begin
          byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
          calib_in_common <= #TCQ 1'b0;
        end
      end else if (~prbs_rdlvl_done && rdlvl_stg1_done) begin
        byte_sel_cnt    <= #TCQ pi_stg2_prbs_rdlvl_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~complex_oclkdelay_calib_done_w && prbs_rdlvl_done) begin
        byte_sel_cnt    <= #TCQ complex_oclkdelay_calib_cnt;
            calib_in_common <= #TCQ 1'b0;
      end else if ((~wrcal_done) && (DRAM_TYPE == "DDR3")) begin
        byte_sel_cnt    <= #TCQ po_stg2_wrcal_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (dbg_sel_pi_incdec_r | dbg_sel_po_incdec_r) begin
        byte_sel_cnt    <= #TCQ dbg_byte_sel;
        calib_in_common <= #TCQ 1'b0;
      end else if (tempmon_sel_pi_incdec) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end
    end
  end else begin: gen_byte_sel_div1

    always @(posedge clk) begin
      if (rst) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b0;
      end else if (~(dqs_po_dec_done && pi_fine_dly_dec_done)) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done && (WRLVL !="ON")) begin
        byte_sel_cnt    <= #TCQ 'd0;
        ctl_lane_sel    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~ck_addr_cmd_delay_done) begin
        ctl_lane_sel    <= #TCQ ctl_lane_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~fine_adjust_done && rd_data_offset_cal_done) begin
        if ((|pi_rst_stg1_cal) || (DRAM_TYPE == "DDR2")) begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ 'd0;
          calib_in_common <= #TCQ 1'b1;
        end else begin
          byte_sel_cnt    <= #TCQ 'd0;
          ctl_lane_sel    <= #TCQ fine_adjust_lane_cnt;
          calib_in_common <= #TCQ 1'b0;
        end
      end else if (~pi_calib_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~pi_dqs_found_done) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end else if (~wrlvl_done_w) begin
        if (SIM_CAL_OPTION != "FAST_CAL") begin
          byte_sel_cnt    <= #TCQ po_stg2_wl_cnt;
          calib_in_common <= #TCQ 1'b0;
        end else begin
          // Special case for FAST_CAL simulation only to ensure that
          // calib_in_common isn't asserted too soon
          if (!phy_ctl_rdy_dly) begin
            byte_sel_cnt    <= #TCQ 'd0;
            calib_in_common <= #TCQ 1'b0;
          end else begin
            byte_sel_cnt    <= #TCQ po_stg2_wl_cnt;
            calib_in_common <= #TCQ 1'b1;
          end
        end
      end else if (~mpr_rdlvl_done) begin
        byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~oclkdelay_calib_done) begin
        byte_sel_cnt    <= #TCQ oclkdelay_calib_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if ((~wrcal_done)&& (DRAM_TYPE == "DDR3")) begin
        byte_sel_cnt    <= #TCQ po_stg2_wrcal_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~rdlvl_stg1_done && pi_calib_done) begin
        if ((SIM_CAL_OPTION == "FAST_CAL") && rdlvl_assrt_common) begin
          byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
          calib_in_common <= #TCQ 1'b1;
        end else begin
          byte_sel_cnt    <= #TCQ pi_stg2_rdlvl_cnt;
          calib_in_common <= #TCQ 1'b0;
        end
      end else if (~prbs_rdlvl_done && rdlvl_stg1_done) begin
        byte_sel_cnt    <= #TCQ pi_stg2_prbs_rdlvl_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (~complex_oclkdelay_calib_done_w && prbs_rdlvl_done) begin
        byte_sel_cnt    <= #TCQ complex_oclkdelay_calib_cnt;
        calib_in_common <= #TCQ 1'b0;
      end else if (dbg_sel_pi_incdec_r | dbg_sel_po_incdec_r) begin
        byte_sel_cnt    <= #TCQ dbg_byte_sel;
        calib_in_common <= #TCQ 1'b0;
      end else if (tempmon_sel_pi_incdec) begin
        byte_sel_cnt    <= #TCQ 'd0;
        calib_in_common <= #TCQ 1'b1;
      end
    end

  end
endgenerate

  // verilint STARC-2.2.3.3 off
  always @(posedge clk) begin
    if (rst || (calib_complete && ~ (dbg_sel_pi_incdec_r|dbg_sel_po_incdec_r|tempmon_sel_pi_incdec) )) begin
      calib_sel         <= #TCQ 6'b000100;
      calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b1}};
      calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
    end else if (~(dqs_po_dec_done && pi_fine_dly_dec_done) || ~skip_cal_po_pi_dec_done) begin
      calib_sel[2]   <= #TCQ 1'b0;
      calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
      calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
      calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
      if (~dqs_po_dec_done && (WRLVL != "ON"))
      //if (~dqs_po_dec_done && ((SIM_CAL_OPTION == "FAST_CAL") ||(WRLVL != "ON")))
        calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b0}};
      else
        calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
    end else if (~ck_addr_cmd_delay_done || (~fine_adjust_done && rd_data_offset_cal_done)) begin
      if(WRLVL =="ON") begin
        calib_sel[2]   <= #TCQ 1'b0;
        calib_sel[1:0] <= #TCQ CTL_BYTE_LANE[(ctl_lane_sel*2)+:2];
        calib_sel[5:3] <= #TCQ CTL_BANK;
        if (|pi_rst_stg1_cal) begin
          calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
        end else begin
          calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b1}};
          calib_zero_inputs[1*CTL_BANK] <= #TCQ 1'b0;
        end
        calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
      end else begin // if (WRLVL =="ON")
        calib_sel[2]   <= #TCQ 1'b0;
        calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
        calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
        calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
        if(~ck_addr_cmd_delay_done)
        calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
        else
          calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b0}};
      end // else: !if(WRLVL =="ON")
    end else if ((~wrlvl_done_w) && (SIM_CAL_OPTION == "FAST_CAL")) begin
      calib_sel[2]   <= #TCQ 1'b0;
      calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
      calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
      calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
      calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
    end else if (~rdlvl_stg1_done && (SIM_CAL_OPTION == "FAST_CAL") &&
                 rdlvl_assrt_common) begin
      calib_sel[2]   <= #TCQ 1'b0;
      calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
      calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
      calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
      calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
    end else if (tempmon_sel_pi_incdec) begin
      calib_sel[2]   <= #TCQ 1'b0;
      calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
      calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
      calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
      calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
    end else begin
      calib_sel[2]   <= #TCQ 1'b0;
      calib_sel[1:0] <= #TCQ DQS_BYTE_MAP[(byte_sel_cnt*8)+:2];
      calib_sel[5:3] <= #TCQ DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3];
      calib_zero_ctrl   <= #TCQ {HIGHEST_BANK{1'b1}};
      if (~calib_in_common) begin
        calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b1}};
        calib_zero_inputs[(1*DQS_BYTE_MAP[((byte_sel_cnt*8)+4)+:3])] <= #TCQ 1'b0;
      end else
        calib_zero_inputs <= #TCQ {HIGHEST_BANK{1'b0}};
    end
  end
  // verilint STARC-2.2.3.3  on
  // Logic to reset IN_FIFO flags to account for the possibility that
  // one or more PHASER_IN's have not correctly found the DQS preamble
  // If this happens, we can still complete read leveling, but the # of
  // words written into the IN_FIFO's may be an odd #, so that if the
  // IN_FIFO is used in 2:1 mode ("8:4 mode"), there may be a "half" word
  // of data left that can only be flushed out by reseting the IN_FIFO
  always @(posedge clk) begin
    rdlvl_stg1_done_r1  <= #TCQ rdlvl_stg1_done;
    prbs_rdlvl_done_r1  <= #TCQ prbs_rdlvl_done;
    reset_if_r1         <= #TCQ reset_if;
    reset_if_r2         <= #TCQ reset_if_r1;
    reset_if_r3         <= #TCQ reset_if_r2;
    reset_if_r4         <= #TCQ reset_if_r3;
    reset_if_r5         <= #TCQ reset_if_r4;
    reset_if_r6         <= #TCQ reset_if_r5;
    reset_if_r7         <= #TCQ reset_if_r6;
    reset_if_r8         <= #TCQ reset_if_r7;
    reset_if_r9         <= #TCQ reset_if_r8;
  end

  always @(posedge clk) begin
    if (rst || reset_if_r9)
      reset_if <= #TCQ 1'b0;
    else if ((rdlvl_stg1_done && ~rdlvl_stg1_done_r1) ||
             (prbs_rdlvl_done && ~prbs_rdlvl_done_r1))
      reset_if <= #TCQ 1'b1;
  end

  assign phy_if_empty_def = 1'b0;

  // DQ IDELAY tap inc and ce signals registered to control calib_in_common
  // signal during read leveling in FAST_CAL mode. The calib_in_common signal
  // is only asserted for IDELAY tap increments not Phaser_IN tap increments
  // in FAST_CAL mode. For Phaser_IN tap increments the Phaser_IN counter load
  // inputs are used.
  always @(posedge clk) begin
    if (rst) begin
      idelay_ce_r1  <= #TCQ 1'b0;
      idelay_ce_r2  <= #TCQ 1'b0;
      idelay_inc_r1 <= #TCQ 1'b0;
      idelay_inc_r2 <= #TCQ 1'b0;
    end else begin
      idelay_ce_r1  <= #TCQ idelay_ce_int;
      idelay_ce_r2  <= #TCQ idelay_ce_r1;
      idelay_inc_r1 <= #TCQ idelay_inc_int;
      idelay_inc_r2 <= #TCQ idelay_inc_r1;
    end
  end

  //***************************************************************************
  // Delay all Outputs using Phaser_Out fine taps
  //***************************************************************************

  assign init_wrcal_complete = 1'b0;

  //***************************************************************************
  // PRBS Generator for Read Leveling Stage 1 - read window detection and
  // DQS Centering
  //***************************************************************************

  // Assign initial seed (used for 1st data word in 8-burst sequence); use alternating 1/0 pat
  assign prbs_seed = 64'h9966aa559966aa55;

  // A single PRBS generator
  // writes 64-bits every 4to1 fabric clock cycle and
  // write 32-bits every 2to1 fabric clock cycle
  // used for complex read leveling and complex oclkdealy calib
  mig_7series_v4_2_ddr_prbs_gen #
    (
     .TCQ           (TCQ),
     .PRBS_WIDTH    (2*8*nCK_PER_CLK),
     .DQS_CNT_WIDTH (DQS_CNT_WIDTH),
     .DQ_WIDTH      (DQ_WIDTH),
     .VCCO_PAT_EN   (VCCO_PAT_EN),
     .VCCAUX_PAT_EN (VCCAUX_PAT_EN),
     .ISI_PAT_EN    (ISI_PAT_EN),
     .FIXED_VICTIM  (FIXED_VICTIM)
    )
    u_ddr_prbs_gen
      (.prbs_ignore_first_byte (prbs_ignore_first_byte),
       .prbs_ignore_last_bytes (prbs_ignore_last_bytes),
       .clk_i              (clk),
       .clk_en_i           (prbs_gen_clk_en | prbs_gen_oclk_clk_en),
       .rst_i              (rst),
       .prbs_o             (prbs_out),
       .prbs_seed_i        (prbs_seed),
       .phy_if_empty       (phy_if_empty),
       .prbs_rdlvl_start   (prbs_rdlvl_start),
       .prbs_rdlvl_done    (prbs_rdlvl_done),
       .complex_wr_done    (complex_wr_done),
       .victim_sel         (victim_sel),
       .byte_cnt           (victim_byte_cnt),
       .dbg_prbs_gen       (),
       .reset_rd_addr      (reset_rd_addr | complex_ocal_reset_rd_addr)
      );


// PRBS data slice that decides the Rise0, Fall0, Rise1, Fall1,
// Rise2, Fall2, Rise3, Fall3 data
  generate
    if (nCK_PER_CLK == 4) begin: gen_ck_per_clk4
      assign prbs_o = prbs_out;
      /*assign prbs_rise0 = prbs_out[7:0];
      assign prbs_fall0 = prbs_out[15:8];
      assign prbs_rise1 = prbs_out[23:16];
      assign prbs_fall1 = prbs_out[31:24];
      assign prbs_rise2 = prbs_out[39:32];
      assign prbs_fall2 = prbs_out[47:40];
      assign prbs_rise3 = prbs_out[55:48];
      assign prbs_fall3 = prbs_out[63:56];
      assign prbs_o = {prbs_fall3, prbs_rise3, prbs_fall2, prbs_rise2,
                       prbs_fall1, prbs_rise1, prbs_fall0, prbs_rise0};*/
    end else begin :gen_ck_per_clk2
      assign prbs_o = prbs_out[4*DQ_WIDTH-1:0];
      /*assign prbs_rise0 = prbs_out[7:0];
      assign prbs_fall0 = prbs_out[15:8];
      assign prbs_rise1 = prbs_out[23:16];
      assign prbs_fall1 = prbs_out[31:24];
      assign prbs_o = {prbs_fall1, prbs_rise1, prbs_fall0, prbs_rise0};*/
    end
  endgenerate


  //***************************************************************************
  // Initialization / Master PHY state logic (overall control during memory
  // init, timing leveling)
  //***************************************************************************

  mig_7series_v4_2_ddr_phy_init #
    (
     .tCK             (tCK),
     .DDR3_VDD_OP_VOLT (DDR3_VDD_OP_VOLT),
     .TCQ             (TCQ),
     .nCK_PER_CLK     (nCK_PER_CLK),
     .CLK_PERIOD      (CLK_PERIOD),
     .DRAM_TYPE       (DRAM_TYPE),
     .PRBS_WIDTH      (PRBS_WIDTH),
     .BANK_WIDTH      (BANK_WIDTH),
     .CA_MIRROR       (CA_MIRROR),
     .COL_WIDTH       (COL_WIDTH),
     .nCS_PER_RANK    (nCS_PER_RANK),
     .DQ_WIDTH        (DQ_WIDTH),
     .DQS_WIDTH       (DQS_WIDTH),
     .DQS_CNT_WIDTH   (DQS_CNT_WIDTH),
     .ROW_WIDTH       (ROW_WIDTH),
     .CS_WIDTH        (CS_WIDTH),
     .RANKS           (RANKS),
     .CKE_WIDTH       (CKE_WIDTH),
     .CALIB_ROW_ADD   (CALIB_ROW_ADD),
     .CALIB_COL_ADD   (CALIB_COL_ADD),
     .CALIB_BA_ADD    (CALIB_BA_ADD),
     .AL              (AL),
     .BURST_MODE      (BURST_MODE),
     .BURST_TYPE      (BURST_TYPE),
     .nCL             (nCL),
     .nCWL            (nCWL),
     .tRFC            (tRFC),
     .REFRESH_TIMER   (REFRESH_TIMER),
     .REFRESH_TIMER_WIDTH (REFRESH_TIMER_WIDTH),
     .OUTPUT_DRV      (OUTPUT_DRV),
     .REG_CTRL        (REG_CTRL),
     .ADDR_CMD_MODE   (ADDR_CMD_MODE),
     .RTT_NOM         (RTT_NOM),
     .RTT_WR          (RTT_WR),
     .WRLVL           (WRLVL),
     .USE_ODT_PORT    (USE_ODT_PORT),
     .DDR2_DQSN_ENABLE(DDR2_DQSN_ENABLE),
     .nSLOTS          (nSLOTS),
     .SIM_INIT_OPTION (SIM_INIT_OPTION),
     .SIM_CAL_OPTION  (SIM_CAL_OPTION),
     .CKE_ODT_AUX     (CKE_ODT_AUX),
     .PRE_REV3ES      (PRE_REV3ES),
     .TEST_AL         (TEST_AL),
     .FIXED_VICTIM    (FIXED_VICTIM),
     .BYPASS_COMPLEX_OCAL(BYPASS_COMPLEX_OCAL),
     .SKIP_CALIB      (SKIP_CALIB)
     )
    u_ddr_phy_init
      (
       .clk                   (clk),
       .rst                   (rst),
       .prbs_o                (prbs_o),
       .ck_addr_cmd_delay_done(ck_addr_cmd_delay_done),
       .delay_incdec_done     (ck_addr_cmd_delay_done),
       .pi_phase_locked_all   (pi_phase_locked_all),
       .pi_phaselock_start    (pi_phaselock_start),
       .pi_phase_locked_err   (phase_locked_err),
       .pi_calib_done         (pi_calib_done),
       .phy_if_empty          (phy_if_empty),
       .phy_ctl_ready         (phy_ctl_ready),
       .phy_ctl_full          (phy_ctl_full),
       .phy_cmd_full          (phy_cmd_full),
       .phy_data_full         (phy_data_full),
       .calib_ctl_wren        (calib_ctl_wren),
       .calib_cmd_wren        (calib_cmd_wren),
       .calib_wrdata_en       (calib_wrdata_en),
       .calib_seq             (calib_seq),
       .calib_aux_out         (calib_aux_out),
       .calib_rank_cnt        (calib_rank_cnt),
       .calib_cas_slot        (calib_cas_slot),
       .calib_data_offset_0   (calib_data_offset_0),
       .calib_data_offset_1   (calib_data_offset_1),
       .calib_data_offset_2   (calib_data_offset_2),
       .calib_cmd             (calib_cmd),
       .calib_cke             (calib_cke),
       .calib_odt             (calib_odt),
       .write_calib           (write_calib),
       .read_calib            (read_calib),
       .wrlvl_done            (wrlvl_done),
       .wrlvl_rank_done       (wrlvl_rank_done),
       .wrlvl_byte_done       (wrlvl_byte_done),
       .wrlvl_byte_redo       (wrlvl_byte_redo),
       .wrlvl_final           (wrlvl_final_mux),
       .wrlvl_final_if_rst    (wrlvl_final_if_rst),
       .oclkdelay_calib_start (oclkdelay_calib_start),
       .oclkdelay_calib_done  (oclkdelay_calib_done),
       .oclk_prech_req        (oclk_prech_req),
       .oclk_calib_resume     (oclk_calib_resume),
       .lim_wr_req            (lim2init_write_request),
       .lim_done              (lim_done),
       .complex_oclkdelay_calib_start (complex_oclkdelay_calib_start),
       .complex_oclkdelay_calib_done  (complex_oclkdelay_calib_done_w),
       .complex_oclk_calib_resume     (complex_oclk_calib_resume),
       .complex_oclkdelay_calib_cnt   (complex_oclkdelay_calib_cnt),
       .complex_sample_cnt_inc_ocal   (complex_sample_cnt_inc_ocal),
       .complex_ocal_num_samples_inc  (complex_ocal_num_samples_inc),
       .complex_ocal_num_samples_done_r (complex_ocal_num_samples_done_r),
       .complex_ocal_reset_rd_addr      (complex_ocal_reset_rd_addr),
       .complex_ocal_ref_req            (complex_ocal_ref_req),
       .complex_ocal_ref_done           (complex_ocal_ref_done),
       .done_dqs_tap_inc      (done_dqs_tap_inc),
       .wl_sm_start           (wl_sm_start),
       .wr_lvl_start          (wrlvl_start),
       .slot_0_present        (slot_0_present),
       .slot_1_present        (slot_1_present),
       .mpr_rdlvl_done        (mpr_rdlvl_done),
       .mpr_rdlvl_start       (mpr_rdlvl_start),
       .mpr_last_byte_done    (mpr_last_byte_done),
       .mpr_rnk_done          (mpr_rnk_done),
       .mpr_end_if_reset      (mpr_end_if_reset),
       .rdlvl_stg1_done       (rdlvl_stg1_done),
       .rdlvl_stg1_rank_done  (rdlvl_stg1_rank_done),
       .rdlvl_stg1_start      (rdlvl_stg1_start),
       .rdlvl_prech_req       (rdlvl_prech_req),
       .rdlvl_last_byte_done  (rdlvl_last_byte_done),
       .prbs_rdlvl_start      (prbs_rdlvl_start),
       .complex_wr_done       (complex_wr_done),
       .prbs_rdlvl_done       (prbs_rdlvl_done),
       .prbs_last_byte_done   (prbs_last_byte_done),
       .prbs_rdlvl_prech_req  (prbs_rdlvl_prech_req),
       .complex_victim_inc    (complex_victim_inc),
       .rd_victim_sel         (rd_victim_sel),
       .complex_ocal_rd_victim_sel (complex_ocal_rd_victim_sel),
       .pi_stg2_prbs_rdlvl_cnt(pi_stg2_prbs_rdlvl_cnt),
       .victim_sel            (victim_sel),
       .victim_byte_cnt       (victim_byte_cnt),
       .prbs_gen_clk_en       (prbs_gen_clk_en),
       .prbs_gen_oclk_clk_en  (prbs_gen_oclk_clk_en),
       .complex_sample_cnt_inc(complex_sample_cnt_inc),
       .pi_dqs_found_start    (pi_dqs_found_start),
       .dqsfound_retry        (dqsfound_retry),
       .dqs_found_prech_req   (dqs_found_prech_req),
       .pi_dqs_found_rank_done(pi_dqs_found_rank_done),
       .pi_dqs_found_done     (pi_dqs_found_done),
       .detect_pi_found_dqs   (detect_pi_found_dqs),
       .rd_data_offset_0      (rd_data_offset_0),
       .rd_data_offset_1      (rd_data_offset_1),
       .rd_data_offset_2      (rd_data_offset_2),
       .rd_data_offset_ranks_0(rd_data_offset_ranks_0),
       .rd_data_offset_ranks_1(rd_data_offset_ranks_1),
       .rd_data_offset_ranks_2(rd_data_offset_ranks_2),
       .wrcal_start           (wrcal_start),
       .wrcal_rd_wait         (wrcal_rd_wait),
       .wrcal_prech_req       (wrcal_prech_req),
       .wrcal_resume          (wrcal_resume_w),
       .wrcal_read_req        (wrcal_read_req),
       .wrcal_act_req         (wrcal_act_req),
       .wrcal_sanity_chk      (wrcal_sanity_chk),
       .temp_wrcal_done       (temp_wrcal_done),
       .wrcal_sanity_chk_done (wrcal_sanity_chk_done),
       .tg_timer_done         (tg_timer_done),
       .no_rst_tg_mc          (no_rst_tg_mc),
       .wrcal_done            (wrcal_done),
       .prech_done            (prech_done),
       .calib_writes          (calib_writes),
       .init_calib_complete   (calib_complete),
       .phy_address           (phy_address),
       .phy_bank              (phy_bank),
       .phy_cas_n             (phy_cas_n),
       .phy_cs_n              (phy_cs_n),
       .phy_ras_n             (phy_ras_n),
       .phy_reset_n           (phy_reset_n),
       .phy_we_n              (phy_we_n),
       .phy_wrdata            (phy_wrdata),
       .phy_rddata_en         (phy_rddata_en),
       .phy_rddata_valid      (phy_rddata_valid),
       .dbg_phy_init          (dbg_phy_init),
       .reset_rd_addr         (reset_rd_addr | complex_ocal_reset_rd_addr),
       .oclkdelay_center_calib_start (oclkdelay_center_calib_start),
       .oclk_center_write_resume     (oclk_center_write_resume),
       .oclkdelay_center_calib_done  (oclkdelay_center_calib_done),
       .rdlvl_pi_incdec              (rdlvl_pi_incdec),
       .complex_act_start            (complex_act_start),
       .complex_pi_incdec_done       (complex_pi_incdec_done),
       .complex_init_pi_dec_done     (complex_init_pi_dec_done),
       .num_samples_done_r           (num_samples_done_r),
       .calib_tap_inc_start          (calib_tap_inc_start),
       .calib_tap_end_if_reset       (calib_tap_end_if_reset),
       .calib_tap_inc_done           (calib_tap_inc_done)
       );


  //*****************************************************************
  // Write Calibration
  //*****************************************************************

  mig_7series_v4_2_ddr_phy_wrcal #
    (
     .TCQ            (TCQ),
     .nCK_PER_CLK    (nCK_PER_CLK),
     .CLK_PERIOD     (CLK_PERIOD),
     .DQ_WIDTH       (DQ_WIDTH),
     .DQS_CNT_WIDTH  (DQS_CNT_WIDTH),
     .DQS_WIDTH      (DQS_WIDTH),
     .DRAM_WIDTH     (DRAM_WIDTH),
     .SIM_CAL_OPTION (SIM_CAL_OPTION)
     )
    u_ddr_phy_wrcal
      (
       .clk                         (clk),
       .rst                         (rst),
       .wrcal_start                 (wrcal_start),
       .wrcal_rd_wait               (wrcal_rd_wait),
       .wrcal_sanity_chk            (wrcal_sanity_chk),
       .dqsfound_retry_done         (pi_dqs_found_done),
       .dqsfound_retry              (dqsfound_retry),
       .wrcal_read_req              (wrcal_read_req),
       .wrcal_act_req               (wrcal_act_req),
       .phy_rddata_en               (phy_rddata_en),
       .wrcal_done                  (wrcal_done),
       .wrcal_pat_err               (wrcal_pat_err),
       .wrcal_prech_req             (wrcal_prech_req),
       .temp_wrcal_done             (temp_wrcal_done),
       .wrcal_sanity_chk_done       (wrcal_sanity_chk_done),
       .prech_done                  (prech_done),
       .rd_data                     (phy_rddata),
       .wrcal_pat_resume            (wrcal_pat_resume),
       .po_stg2_wrcal_cnt           (po_stg2_wrcal_cnt),
       .phy_if_reset                (phy_if_reset_w),
       .wl_po_coarse_cnt            (wl_po_coarse_cnt),
       .wl_po_fine_cnt              (wl_po_fine_cnt),
       .wrlvl_byte_redo             (wrlvl_byte_redo),
       .wrlvl_byte_done             (wrlvl_byte_done),
       .early1_data                 (early1_data),
       .early2_data                 (early2_data),
       .idelay_ld                   (idelay_ld),
       .dbg_phy_wrcal               (dbg_phy_wrcal),
       .dbg_final_po_fine_tap_cnt   (dbg_final_po_fine_tap_cnt),
       .dbg_final_po_coarse_tap_cnt (dbg_final_po_coarse_tap_cnt)
   );



  //***************************************************************************
  // Write-leveling calibration logic
  //***************************************************************************

  generate
    if ((WRLVL == "ON") && (SKIP_CALIB == "FALSE")) begin: mb_wrlvl_inst

      mig_7series_v4_2_ddr_phy_wrlvl #
        (
         .TCQ               (TCQ),
         .DQS_CNT_WIDTH     (DQS_CNT_WIDTH),
         .DQ_WIDTH          (DQ_WIDTH),
         .DQS_WIDTH         (DQS_WIDTH),
         .DRAM_WIDTH        (DRAM_WIDTH),
         .RANKS             (1),
         .CLK_PERIOD        (CLK_PERIOD),
         .nCK_PER_CLK       (nCK_PER_CLK),
         .SIM_CAL_OPTION    (SIM_CAL_OPTION)
         )
        u_ddr_phy_wrlvl
          (
           .clk                         (clk),
           .rst                         (rst),
           .phy_ctl_ready               (phy_ctl_ready),
           .wr_level_start              (wrlvl_start),
           .wl_sm_start                 (wl_sm_start),
           .wrlvl_byte_redo             (wrlvl_byte_redo),
           .wrcal_cnt                   (po_stg2_wrcal_cnt),
           .early1_data                 (early1_data),
           .early2_data                 (early2_data),
           .wrlvl_final                 (wrlvl_final_mux),
           .oclkdelay_calib_cnt         (oclkdelay_calib_cnt),
           .wrlvl_byte_done             (wrlvl_byte_done),
           .oclkdelay_calib_done        (oclkdelay_calib_done),
           .rd_data_rise0               (phy_rddata[DQ_WIDTH-1:0]),
           .dqs_po_dec_done             (dqs_po_dec_done),
           .phy_ctl_rdy_dly             (phy_ctl_rdy_dly),
           .wr_level_done               (wrlvl_done),
           .wrlvl_rank_done             (wrlvl_rank_done),
           .done_dqs_tap_inc            (done_dqs_tap_inc),
           .dqs_po_stg2_f_incdec        (dqs_po_stg2_f_incdec),
           .dqs_po_en_stg2_f            (dqs_po_en_stg2_f),
           .dqs_wl_po_stg2_c_incdec     (dqs_wl_po_stg2_c_incdec),
           .dqs_wl_po_en_stg2_c         (dqs_wl_po_en_stg2_c),
           .po_counter_read_val         (po_counter_read_val),
           .po_stg2_wl_cnt              (po_stg2_wl_cnt),
           .wrlvl_err                   (wrlvl_err),
           .wl_po_coarse_cnt            (wl_po_coarse_cnt),
           .wl_po_fine_cnt              (wl_po_fine_cnt),
           .dbg_wl_tap_cnt              (dbg_tap_cnt_during_wrlvl),
           .dbg_wl_edge_detect_valid    (dbg_wl_edge_detect_valid),
           .dbg_rd_data_edge_detect     (dbg_rd_data_edge_detect),
           .dbg_dqs_count               (),
           .dbg_wl_state                (),
           .dbg_wrlvl_fine_tap_cnt      (dbg_wrlvl_fine_tap_cnt),
           .dbg_wrlvl_coarse_tap_cnt    (dbg_wrlvl_coarse_tap_cnt),
           .dbg_phy_wrlvl               (dbg_phy_wrlvl)
           );


        mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay #
         (
          .TCQ           (TCQ),
          .tCK           (tCK),
          .DQS_CNT_WIDTH (DQS_CNT_WIDTH),
          .N_CTL_LANES   (N_CTL_LANES),
          .SIM_CAL_OPTION(SIM_CAL_OPTION)
          )
          u_ddr_phy_ck_addr_cmd_delay
            (
             .clk                        (clk),
             .rst                        (rst),
             .cmd_delay_start            (dqs_po_dec_done & pi_fine_dly_dec_done),
             .ctl_lane_cnt               (ctl_lane_cnt),
             .po_stg2_f_incdec           (cmd_po_stg2_f_incdec),
             .po_en_stg2_f               (cmd_po_en_stg2_f),
             .po_stg2_c_incdec           (cmd_po_stg2_c_incdec),
             .po_en_stg2_c               (cmd_po_en_stg2_c),
             .po_ck_addr_cmd_delay_done  (po_ck_addr_cmd_delay_done)
            );

      assign cmd_po_stg2_incdec_ddr2_c = 1'b0;
      assign cmd_po_en_stg2_ddr2_c = 1'b0;

    end else if ((WRLVL == "ON") && (SKIP_CALIB == "TRUE")) begin: wrlvl_on_skip_calib

        mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay #
         (
          .TCQ           (TCQ),
          .tCK           (tCK),
          .DQS_CNT_WIDTH (DQS_CNT_WIDTH),
          .N_CTL_LANES   (N_CTL_LANES),
          .SIM_CAL_OPTION(SIM_CAL_OPTION)
          )
          u_ddr_phy_ck_addr_cmd_delay
            (
             .clk                        (clk),
             .rst                        (rst),
             .cmd_delay_start            (skip_cal_po_pi_dec_done),
             .ctl_lane_cnt               (ctl_lane_cnt),
             .po_stg2_f_incdec           (cmd_po_stg2_f_incdec),
             .po_en_stg2_f               (cmd_po_en_stg2_f),
             .po_stg2_c_incdec           (cmd_po_stg2_c_incdec),
             .po_en_stg2_c               (cmd_po_en_stg2_c),
             .po_ck_addr_cmd_delay_done  (po_ck_addr_cmd_delay_done)
            );

      assign dqs_po_dec_done             = 1'b1;
      assign wrlvl_byte_done             = 1'b1;
      assign wrlvl_rank_done             = 1'b1;
      assign phy_ctl_rdy_dly             = 1'b1;
      assign done_dqs_tap_inc            = 1'b1;
      assign po_stg2_wl_cnt              = 'h0;
      assign wl_po_coarse_cnt            = 'h0;
      assign wl_po_fine_cnt              = 'h0;
      assign dbg_tap_cnt_during_wrlvl    = 'h0;
      assign dbg_wl_edge_detect_valid    = 'h0;
      assign dbg_rd_data_edge_detect     = 'h0;
      assign dbg_wrlvl_fine_tap_cnt      = 'h0;
      assign dbg_wrlvl_coarse_tap_cnt    = 'h0;
      assign dbg_phy_wrlvl               = 'h0;

      assign wrlvl_done   = 1'b1;
      assign wrlvl_err    = 1'b0;
      assign dqs_po_stg2_f_incdec = 1'b0;
      assign dqs_po_en_stg2_f = 1'b0;
      assign dqs_wl_po_en_stg2_c = 1'b0;
      assign dqs_wl_po_stg2_c_incdec = 1'b0;

      assign cmd_po_stg2_incdec_ddr2_c = 1'b0;
      assign cmd_po_en_stg2_ddr2_c = 1'b0;

    end else begin: mb_wrlvl_off

        mig_7series_v4_2_ddr_phy_wrlvl_off_delay #
         (
          .TCQ           (TCQ),
          .tCK           (tCK),
          .nCK_PER_CLK   (nCK_PER_CLK),
          .CLK_PERIOD    (CLK_PERIOD),
          .PO_INITIAL_DLY(60),
          .DQS_CNT_WIDTH (DQS_CNT_WIDTH),
          .DQS_WIDTH     (DQS_WIDTH),
          .N_CTL_LANES   (N_CTL_LANES)
          )
          u_phy_wrlvl_off_delay
            (
             .clk                        (clk),
             .rst                        (rst),
             .pi_fine_dly_dec_done       (pi_fine_dly_dec_done),
             .cmd_delay_start            (phy_ctl_ready),
             .ctl_lane_cnt               (ctl_lane_cnt),
             .po_s2_incdec_f             (cmd_po_stg2_f_incdec),
             .po_en_s2_f                 (cmd_po_en_stg2_f),
             .po_s2_incdec_c             (cmd_po_stg2_incdec_ddr2_c),
             .po_en_s2_c                 (cmd_po_en_stg2_ddr2_c),
             .po_ck_addr_cmd_delay_done  (po_ck_addr_cmd_delay_done),
             .po_dec_done                (dqs_po_dec_done),
             .phy_ctl_rdy_dly            (phy_ctl_rdy_dly)
            );

      assign wrlvl_byte_done             = 1'b1;
      assign wrlvl_rank_done             = 1'b1;
      assign po_stg2_wl_cnt              = 'h0;
      assign wl_po_coarse_cnt            = 'h0;
      assign wl_po_fine_cnt              = 'h0;
      assign dbg_tap_cnt_during_wrlvl    = 'h0;
      assign dbg_wl_edge_detect_valid    = 'h0;
      assign dbg_rd_data_edge_detect     = 'h0;
      assign dbg_wrlvl_fine_tap_cnt      = 'h0;
      assign dbg_wrlvl_coarse_tap_cnt    = 'h0;
      assign dbg_phy_wrlvl               = 'h0;

      assign wrlvl_done   = 1'b1;
      assign wrlvl_err    = 1'b0;
      assign dqs_po_stg2_f_incdec = 1'b0;
      assign dqs_po_en_stg2_f = 1'b0;
      assign dqs_wl_po_en_stg2_c = 1'b0;
      assign cmd_po_stg2_c_incdec = 1'b0;
      assign dqs_wl_po_stg2_c_incdec = 1'b0;
      assign cmd_po_en_stg2_c = 1'b0;

    end
  endgenerate

   generate
   if((WRLVL == "ON") && (OCAL_EN == "ON")) begin: oclk_calib

     localparam SAMPCNTRWIDTH = 17;
     localparam SAMPLES = (SIM_CAL_OPTION=="NONE") ? 512 : 4; //MG from 2048
     localparam TAPCNTRWIDTH = clogb2(TAPSPERKCLK);
     localparam MMCM_SAMP_WAIT = (SIM_CAL_OPTION=="NONE") ? 256 : 10;
     localparam OCAL_SIMPLE_SCAN_SAMPS = (SIM_CAL_OPTION=="NONE") ? 512 : 1; //MG from 2048
     localparam POC_PCT_SAMPS_SOLID = 80;
     localparam SCAN_PCT_SAMPS_SOLID = 95;

     mig_7series_v4_2_ddr_phy_oclkdelay_cal #
       (/*AUTOINSTPARAM*/
    // Parameters
    .DQS_CNT_WIDTH      (DQS_CNT_WIDTH),
    .DQS_WIDTH          (DQS_WIDTH),
    .DQ_WIDTH           (DQ_WIDTH),
    //.DRAM_TYPE            (DRAM_TYPE),
    .DRAM_WIDTH         (DRAM_WIDTH),
    //.OCAL_EN          (OCAL_EN),
    .OCAL_SIMPLE_SCAN_SAMPS (OCAL_SIMPLE_SCAN_SAMPS),
    .PCT_SAMPS_SOLID                (POC_PCT_SAMPS_SOLID),
    .POC_USE_METASTABLE_SAMP        (POC_USE_METASTABLE_SAMP),
    .SCAN_PCT_SAMPS_SOLID           (SCAN_PCT_SAMPS_SOLID),
    .SAMPCNTRWIDTH      (SAMPCNTRWIDTH),
    .SAMPLES            (SAMPLES),
    .MMCM_SAMP_WAIT             (MMCM_SAMP_WAIT),
    .SIM_CAL_OPTION             (SIM_CAL_OPTION),
    .TAPCNTRWIDTH               (TAPCNTRWIDTH),
    .TAPSPERKCLK                (TAPSPERKCLK),
    .TCQ                (TCQ),
    .nCK_PER_CLK                (nCK_PER_CLK),
    .BYPASS_COMPLEX_OCAL        (BYPASS_COMPLEX_OCAL)
    //.tCK              (tCK)
    )
     u_ddr_phy_oclkdelay_cal
       (/*AUTOINST*/
    // Outputs
    .prbs_ignore_first_byte           (prbs_ignore_first_byte),
    .prbs_ignore_last_bytes           (prbs_ignore_last_bytes),
    .complex_oclkdelay_calib_done   (complex_oclkdelay_calib_done),
    .dbg_oclkdelay_rd_data          (dbg_oclkdelay_rd_data[16*DRAM_WIDTH-1:0]),
    .dbg_phy_oclkdelay_cal          (dbg_phy_oclkdelay_cal[255:0]),
    .lim2init_write_request         (lim2init_write_request),
    .lim_done                       (lim_done),
    .oclk_calib_resume              (oclk_calib_resume),
    .oclk_prech_req                 (oclk_prech_req),
    .oclkdelay_calib_cnt            (oclkdelay_calib_cnt[DQS_CNT_WIDTH:0]),
    .oclkdelay_calib_done           (oclkdelay_calib_done),
    .po_en_stg23                    (po_en_stg23),
    .po_stg23_incdec                (po_stg23_incdec),
    .po_stg23_sel                   (po_stg23_sel),
    .psen                           (psen),
    .psincdec                       (psincdec),
    .wrlvl_final                    (wrlvl_final),
    .rd_victim_sel                  (complex_ocal_rd_victim_sel),
    .ocal_num_samples_done_r        (complex_ocal_num_samples_done_r),
    .complex_wrlvl_final            (complex_wrlvl_final),
    .poc_error                      (poc_error),
    // Inputs
    .clk                            (clk),
    .complex_oclkdelay_calib_start  (complex_oclkdelay_calib_start_w),
    .metaQ                          (pd_out),
    //.oclk_init_delay_start            (oclk_init_delay_start),
    .po_counter_read_val            (po_counter_read_val),
    .oclkdelay_calib_start          (oclkdelay_calib_start),
    .oclkdelay_init_val             (oclkdelay_init_val[5:0]),
    .poc_sample_pd                  (poc_sample_pd),
    .phy_rddata                     (phy_rddata[2*nCK_PER_CLK*DQ_WIDTH-1:0]),
    .phy_rddata_en                  (phy_rddata_en),
    .prbs_o                         (prbs_o[2*nCK_PER_CLK*DQ_WIDTH-1:0]),
    .prech_done                     (prech_done),
    .psdone                         (psdone),
    .rst                            (rst),
    .wl_po_fine_cnt                 (wl_po_fine_cnt[6*DQS_WIDTH-1:0]),
    .ocal_num_samples_inc           (complex_ocal_num_samples_inc),
    .oclkdelay_center_calib_start   (oclkdelay_center_calib_start),
    .oclk_center_write_resume       (oclk_center_write_resume),
    .oclkdelay_center_calib_done    (oclkdelay_center_calib_done),
    .dbg_ocd_lim                    (dbg_ocd_lim),
    .dbg_poc                         (dbg_poc[1023:0]) );

     end else begin : oclk_calib_disabled

       assign   wrlvl_final = 'b0;
       assign   psen        = 'b0;
       assign   psincdec    = 'b0;
       assign   po_stg23_sel = 'b0;
       assign   po_stg23_incdec = 'b0;
       assign   po_en_stg23 = 'b0;
       assign   oclkdelay_calib_cnt = 'b0;
       assign   oclk_prech_req = 'b0;
       assign   oclk_calib_resume = 'b0;
       assign   oclkdelay_calib_done = 1'b1;
       assign   dbg_phy_oclkdelay_cal = 'h0;
       assign   dbg_oclkdelay_rd_data = 'h0;

     end
   endgenerate
  //***************************************************************************
  // Read data-offset calibration required for Phaser_In
  //***************************************************************************

 generate
   if(DQSFOUND_CAL == "RIGHT") begin: dqsfind_calib_right
     mig_7series_v4_2_ddr_phy_dqs_found_cal #
        (
         .TCQ              (TCQ),
         .nCK_PER_CLK      (nCK_PER_CLK),
         .nCL              (nCL),
         .AL               (AL),
         .nCWL             (nCWL),
         //.RANKS            (RANKS),
         .RANKS            (1),
         .DQS_CNT_WIDTH    (DQS_CNT_WIDTH),
         .DQS_WIDTH        (DQS_WIDTH),
         .DRAM_WIDTH       (DRAM_WIDTH),
         .REG_CTRL         (REG_CTRL),
         .SIM_CAL_OPTION   (SIM_CAL_OPTION),
         .DRAM_TYPE        (DRAM_TYPE),
         .NUM_DQSFOUND_CAL (NUM_DQSFOUND_CAL),
         .N_CTL_LANES      (DQS_FOUND_N_CTL_LANES),
         .HIGHEST_LANE     (HIGHEST_LANE),
         .HIGHEST_BANK     (HIGHEST_BANK),
         .BYTE_LANES_B0    (BYTE_LANES_B0),
         .BYTE_LANES_B1    (BYTE_LANES_B1),
         .BYTE_LANES_B2    (BYTE_LANES_B2),
         .BYTE_LANES_B3    (BYTE_LANES_B3),
         .BYTE_LANES_B4    (BYTE_LANES_B4),
         .DATA_CTL_B0      (DATA_CTL_B0),
         .DATA_CTL_B1      (DATA_CTL_B1),
         .DATA_CTL_B2      (DATA_CTL_B2),
         .DATA_CTL_B3      (DATA_CTL_B3),
         .DATA_CTL_B4      (DATA_CTL_B4)
         )
         u_ddr_phy_dqs_found_cal
           (
            .clk                       (clk),
            .rst                       (rst),
            .pi_dqs_found_start        (pi_dqs_found_start),
            .dqsfound_retry            (dqsfound_retry),
            .detect_pi_found_dqs       (detect_pi_found_dqs),
            .prech_done                (prech_done),
            .pi_dqs_found_lanes        (pi_dqs_found_lanes),
            .pi_rst_stg1_cal           (pi_rst_stg1_cal),
            .rd_data_offset_0          (rd_data_offset_0),
            .rd_data_offset_1          (rd_data_offset_1),
            .rd_data_offset_2          (rd_data_offset_2),
            .pi_dqs_found_rank_done    (pi_dqs_found_rank_done),
            .pi_dqs_found_done         (pi_dqs_found_done),
            .dqsfound_retry_done       (dqsfound_retry_done),
            .dqs_found_prech_req       (dqs_found_prech_req),
            .pi_dqs_found_err          (pi_dqs_found_err),
            .rd_data_offset_ranks_0    (rd_data_offset_ranks_0),
            .rd_data_offset_ranks_1    (rd_data_offset_ranks_1),
            .rd_data_offset_ranks_2    (rd_data_offset_ranks_2),
            .rd_data_offset_ranks_mc_0 (rd_data_offset_ranks_mc_0),
            .rd_data_offset_ranks_mc_1 (rd_data_offset_ranks_mc_1),
            .rd_data_offset_ranks_mc_2 (rd_data_offset_ranks_mc_2),
            .po_counter_read_val       (po_counter_read_val),
            .rd_data_offset_cal_done   (rd_data_offset_cal_done),
            .fine_adjust_done          (fine_adjust_done),
            .fine_adjust_lane_cnt      (fine_adjust_lane_cnt),
            .ck_po_stg2_f_indec        (ck_po_stg2_f_indec),
            .ck_po_stg2_f_en           (ck_po_stg2_f_en),
            .dbg_dqs_found_cal         (dbg_dqs_found_cal)
            );
   end else begin: dqsfind_calib_left
     mig_7series_v4_2_ddr_phy_dqs_found_cal_hr #
        (
         .TCQ              (TCQ),
         .nCK_PER_CLK      (nCK_PER_CLK),
         .nCL              (nCL),
         .AL               (AL),
         .nCWL             (nCWL),
         //.RANKS            (RANKS),
         .RANKS            (1),
         .DQS_CNT_WIDTH    (DQS_CNT_WIDTH),
         .DQS_WIDTH        (DQS_WIDTH),
         .DRAM_WIDTH       (DRAM_WIDTH),
         .REG_CTRL         (REG_CTRL),
         .SIM_CAL_OPTION   (SIM_CAL_OPTION),
         .DRAM_TYPE        (DRAM_TYPE),
         .NUM_DQSFOUND_CAL (NUM_DQSFOUND_CAL),
         .N_CTL_LANES      (DQS_FOUND_N_CTL_LANES),
         .HIGHEST_LANE     (HIGHEST_LANE),
         .HIGHEST_BANK     (HIGHEST_BANK),
         .BYTE_LANES_B0    (BYTE_LANES_B0),
         .BYTE_LANES_B1    (BYTE_LANES_B1),
         .BYTE_LANES_B2    (BYTE_LANES_B2),
         .BYTE_LANES_B3    (BYTE_LANES_B3),
         .BYTE_LANES_B4    (BYTE_LANES_B4),
         .DATA_CTL_B0      (DATA_CTL_B0),
         .DATA_CTL_B1      (DATA_CTL_B1),
         .DATA_CTL_B2      (DATA_CTL_B2),
         .DATA_CTL_B3      (DATA_CTL_B3),
         .DATA_CTL_B4      (DATA_CTL_B4)
         )
         u_ddr_phy_dqs_found_cal_hr
           (
            .clk                       (clk),
            .rst                       (rst),
            .pi_dqs_found_start        (pi_dqs_found_start),
            .dqsfound_retry            (dqsfound_retry),
            .detect_pi_found_dqs       (detect_pi_found_dqs),
            .prech_done                (prech_done),
            .pi_dqs_found_lanes        (pi_dqs_found_lanes),
            .pi_rst_stg1_cal           (pi_rst_stg1_cal),
            .rd_data_offset_0          (rd_data_offset_0),
            .rd_data_offset_1          (rd_data_offset_1),
            .rd_data_offset_2          (rd_data_offset_2),
            .pi_dqs_found_rank_done    (pi_dqs_found_rank_done),
            .pi_dqs_found_done         (pi_dqs_found_done),
            .dqsfound_retry_done       (dqsfound_retry_done),
            .dqs_found_prech_req       (dqs_found_prech_req),
            .pi_dqs_found_err          (pi_dqs_found_err),
            .rd_data_offset_ranks_0    (rd_data_offset_ranks_0),
            .rd_data_offset_ranks_1    (rd_data_offset_ranks_1),
            .rd_data_offset_ranks_2    (rd_data_offset_ranks_2),
            .rd_data_offset_ranks_mc_0 (rd_data_offset_ranks_mc_0),
            .rd_data_offset_ranks_mc_1 (rd_data_offset_ranks_mc_1),
            .rd_data_offset_ranks_mc_2 (rd_data_offset_ranks_mc_2),
            .po_counter_read_val       (po_counter_read_val),
            .rd_data_offset_cal_done   (rd_data_offset_cal_done),
            .fine_adjust_done          (fine_adjust_done),
            .fine_adjust_lane_cnt      (fine_adjust_lane_cnt),
            .ck_po_stg2_f_indec        (ck_po_stg2_f_indec),
            .ck_po_stg2_f_en           (ck_po_stg2_f_en),
            .dbg_dqs_found_cal         (dbg_dqs_found_cal)
            );
   end
 endgenerate

  //***************************************************************************
  // Read-leveling calibration logic
  //***************************************************************************
generate
if (SKIP_CALIB == "FALSE") begin:ddr_phy_rdlvl_gen
  mig_7series_v4_2_ddr_phy_rdlvl #
    (
     .TCQ             (TCQ),
     .nCK_PER_CLK     (nCK_PER_CLK),
     .CLK_PERIOD      (CLK_PERIOD),
     .DQ_WIDTH        (DQ_WIDTH),
     .DQS_CNT_WIDTH   (DQS_CNT_WIDTH),
     .DQS_WIDTH       (DQS_WIDTH),
     .DRAM_WIDTH      (DRAM_WIDTH),
     .RANKS           (1),
     .PER_BIT_DESKEW  (PER_BIT_DESKEW),
     .SIM_CAL_OPTION  (SIM_CAL_OPTION),
     .DEBUG_PORT      (DEBUG_PORT),
     .DRAM_TYPE       (DRAM_TYPE),
     .OCAL_EN         (OCAL_EN),
     .IDELAY_ADJ      (IDELAY_ADJ),
     .PI_DIV2_INCDEC  (PI_DIV2_INCDEC)
     )
    u_ddr_phy_rdlvl
      (
       .clk                     (clk),
       .rst                     (rst),
       .mpr_rdlvl_done          (mpr_rdlvl_done),
       .mpr_rdlvl_start         (mpr_rdlvl_start),
       .mpr_last_byte_done      (mpr_last_byte_done),
       .mpr_rnk_done            (mpr_rnk_done),
       .rdlvl_stg1_start        (rdlvl_stg1_start),
       .rdlvl_stg1_done         (rdlvl_stg1_done),
       .rdlvl_stg1_rnk_done     (rdlvl_stg1_rank_done),
       .rdlvl_stg1_err          (rdlvl_stg1_err),
       .mpr_rdlvl_err           (mpr_rdlvl_err),
       .rdlvl_err               (rdlvl_err),
       .rdlvl_prech_req         (rdlvl_prech_req),
       .rdlvl_last_byte_done    (rdlvl_last_byte_done),
       .rdlvl_assrt_common      (rdlvl_assrt_common),
       .prech_done              (prech_done),
       .phy_if_empty            (phy_if_empty),
       .idelaye2_init_val       (idelaye2_init_val),
       .rd_data                 (phy_rddata),
       .pi_en_stg2_f            (rdlvl_pi_stg2_f_en),
       .pi_stg2_f_incdec        (rdlvl_pi_stg2_f_incdec),
       .pi_stg2_load            (pi_stg2_load),
       .pi_stg2_reg_l           (pi_stg2_reg_l),
       .dqs_po_dec_done         (dqs_po_dec_done),
       .pi_counter_read_val     (pi_counter_read_val),
       .pi_fine_dly_dec_done    (pi_fine_dly_dec_done),
       .idelay_ce               (idelay_ce_int),
       .idelay_inc              (idelay_inc_int),
       .idelay_ld               (idelay_ld),
       .wrcal_cnt               (po_stg2_wrcal_cnt),
       .pi_stg2_rdlvl_cnt       (pi_stg2_rdlvl_cnt),
       .dlyval_dq               (dlyval_dq),
       .rdlvl_pi_incdec         (rdlvl_pi_incdec),
       .dbg_cpt_first_edge_cnt  (dbg_cpt_first_edge_cnt),
       .dbg_cpt_second_edge_cnt (dbg_cpt_second_edge_cnt),
       .dbg_cpt_tap_cnt         (dbg_cpt_tap_cnt),
       .dbg_dq_idelay_tap_cnt   (dbg_dq_idelay_tap_cnt),
       .dbg_idel_up_all         (dbg_idel_up_all),
       .dbg_idel_down_all       (dbg_idel_down_all),
       .dbg_idel_up_cpt         (dbg_idel_up_cpt),
       .dbg_idel_down_cpt       (dbg_idel_down_cpt),
       .dbg_sel_idel_cpt        (dbg_sel_idel_cpt),
       .dbg_sel_all_idel_cpt    (dbg_sel_all_idel_cpt),
       .dbg_phy_rdlvl           (dbg_phy_rdlvl)
       );
end else begin:ddr_phy_rdlvl_off

     assign mpr_rdlvl_done          = 1'b1;
     assign mpr_last_byte_done      = 1'b1;
     assign mpr_rnk_done            = 1'b1;
     assign rdlvl_stg1_done         = 1'b1;
     assign rdlvl_stg1_rank_done    = 1'b1;
     assign rdlvl_last_byte_done    = 1'b1;
     assign pi_fine_dly_dec_done    = 1'b1;
     assign rdlvl_prech_req         = 1'b0;
     assign rdlvl_stg1_err          = 1'b0;
     assign mpr_rdlvl_err           = 1'b0;
     assign rdlvl_err               = 1'b0;
     assign rdlvl_assrt_common      = 1'b0;
     assign rdlvl_pi_stg2_f_en      = 1'b0;
     assign rdlvl_pi_stg2_f_incdec  = 1'b0;
     assign pi_stg2_rdlvl_cnt       = 'h0;
     assign idelay_ce_int           = 1'b0;
     assign idelay_inc_int          = 1'b0;
     assign rdlvl_pi_incdec         = 1'b0;
     assign dbg_phy_rdlvl           = 'h0;
     assign dbg_cpt_first_edge_cnt  = 'h0;
     assign dbg_cpt_second_edge_cnt = 'h0;
     assign dbg_cpt_tap_cnt         = 'h0;
     assign dbg_dq_idelay_tap_cnt   = 'h0;

end
endgenerate

generate
if((DRAM_TYPE == "DDR3") && (nCK_PER_CLK == 4) && (BYPASS_COMPLEX_RDLVL=="FALSE")) begin:ddr_phy_prbs_rdlvl_gen
  mig_7series_v4_2_ddr_phy_prbs_rdlvl #
    (
     .TCQ            (TCQ),
     .nCK_PER_CLK    (nCK_PER_CLK),
     .DQ_WIDTH       (DQ_WIDTH),
     .DQS_CNT_WIDTH  (DQS_CNT_WIDTH),
     .DQS_WIDTH      (DQS_WIDTH),
     .DRAM_WIDTH     (DRAM_WIDTH),
     .RANKS          (1),
     .SIM_CAL_OPTION (SIM_CAL_OPTION),
     .PRBS_WIDTH     (PRBS_WIDTH),
     .FIXED_VICTIM   (FIXED_VICTIM),
     .FINE_PER_BIT   (FINE_PER_BIT),
     .CENTER_COMP_MODE (CENTER_COMP_MODE),
     .PI_VAL_ADJ       (PI_VAL_ADJ)
     )
    u_ddr_phy_prbs_rdlvl
      (
       .clk                    (clk),
       .rst                    (rst),
       .prbs_rdlvl_start       (prbs_rdlvl_start),
       .prbs_rdlvl_done        (prbs_rdlvl_done_complex),
       .prbs_last_byte_done    (prbs_last_byte_done),
       .prbs_rdlvl_prech_req   (prbs_rdlvl_prech_req),
       .complex_sample_cnt_inc (complex_sample_cnt_inc),
       .prech_done             (prech_done),
       .phy_if_empty           (phy_if_empty),
       .rd_data                (phy_rddata),
       .compare_data           (prbs_o),
       .pi_counter_read_val    (pi_counter_read_val),
       .pi_en_stg2_f           (prbs_pi_stg2_f_en),
       .pi_stg2_f_incdec       (prbs_pi_stg2_f_incdec),
       .dbg_prbs_rdlvl         (dbg_prbs_rdlvl),
       .pi_stg2_prbs_rdlvl_cnt (pi_stg2_prbs_rdlvl_cnt),
       .prbs_final_dqs_tap_cnt_r (prbs_final_dqs_tap_cnt_r),
       .dbg_prbs_first_edge_taps (dbg_prbs_first_edge_taps),
       .dbg_prbs_second_edge_taps (dbg_prbs_second_edge_taps),
       .rd_victim_sel          (rd_victim_sel),
       .complex_victim_inc     (complex_victim_inc),
       .reset_rd_addr          (reset_rd_addr),
       .fine_delay_incdec_pb   (fine_delay_incdec_pb),
       .fine_delay_sel         (fine_delay_sel),
       .complex_act_start      (complex_act_start),
       .num_samples_done_r     (num_samples_done_r),
       .complex_pi_incdec_done (complex_pi_incdec_done),
       .complex_init_pi_dec_done     (complex_init_pi_dec_done)
       );
end else begin:ddr_phy_prbs_rdlvl_off

     assign prbs_rdlvl_done_complex = rdlvl_stg1_done ;
     //assign prbs_last_byte_done     = rdlvl_stg1_rank_done ;
     assign prbs_last_byte_done     = rdlvl_stg1_done;
     assign reset_rd_addr           = 1'b0;
     assign prbs_rdlvl_prech_req    = 1'b0 ;
     assign prbs_pi_stg2_f_en       = 1'b0 ;
     assign prbs_pi_stg2_f_incdec   = 1'b0 ;
     assign pi_stg2_prbs_rdlvl_cnt  = 'b0 ;
     assign dbg_prbs_rdlvl          = 'h0 ;
     assign prbs_final_dqs_tap_cnt_r  = {(6*DQS_WIDTH*RANKS){1'b0}};
     assign dbg_prbs_first_edge_taps  = {(6*DQS_WIDTH*RANKS){1'b0}};
     assign dbg_prbs_second_edge_taps = {(6*DQS_WIDTH*RANKS){1'b0}};
     assign complex_pi_incdec_done  = 'b0;
     assign complex_init_pi_dec_done  = 'b1;
     assign num_samples_done_r      = 'b0;
end
endgenerate

  //***************************************************************************
  // Inc/Dec Phaser_Out, Phaser_In, and IDELAY taps to match calibration values
  //***************************************************************************

  generate
  if (SKIP_CALIB == "TRUE") begin: gen_skip_calib_tap

    // Generate request to get calibration tap values per byte
    always @(posedge clk) begin
      if (rst)
        calib_tap_req  <= #TCQ 1'b0;
      else if (phy_ctl_ready)
        calib_tap_req <= #TCQ 1'b1;
    end


    // Store calibration values to registers
    always @(posedge clk) begin
      if (rst) begin
        calib_po_coarse_tap_cnt <= #TCQ 'd0;
        calib_po_stage3_tap_cnt <= #TCQ 'd0;
        calib_po_stage2_tap_cnt <= #TCQ 'd0;
        calib_pi_stage2_tap_cnt <= #TCQ 'd0;
        calib_idelay_tap_cnt    <= #TCQ 'd0;
        calib_device_temp       <= #TCQ 'd0;
      end else if (calib_tap_load) begin
        case (calib_tap_addr[2:0])
          3'b000:
            calib_po_coarse_tap_cnt[3*calib_tap_addr[6:3]+:3] <= #TCQ calib_tap_val[2:0];
          3'b001:
            calib_po_stage3_tap_cnt[6*calib_tap_addr[6:3]+:6] <= #TCQ calib_tap_val[5:0];
          3'b010:
            calib_po_stage2_tap_cnt[6*calib_tap_addr[6:3]+:6] <= #TCQ calib_tap_val[5:0];
          3'b011:
            calib_pi_stage2_tap_cnt[6*calib_tap_addr[6:3]+:6] <= #TCQ calib_tap_val[5:0];
          3'b100:
            calib_idelay_tap_cnt[5*calib_tap_addr[6:3]+:5] <= #TCQ calib_tap_val[4:0];
          3'b110:
            if (&calib_tap_addr[6:3])
              calib_device_temp[7:0] <= #TCQ calib_tap_val[7:0];
          3'b111:
            if (&calib_tap_addr[6:3])
              calib_device_temp[11:8] <= #TCQ calib_tap_val[3:0];
          default:
            calib_po_coarse_tap_cnt[3*calib_tap_addr[6:3]+:3] <= #TCQ calib_tap_val[2:0];
        endcase
      end
    end


    mig_7series_v4_2_ddr_skip_calib_tap #
    (
        .TCQ       (TCQ),
        .DQS_WIDTH (DQS_WIDTH)
     )
       u_ddr_skip_calib_tap
      (
       .rst                   (rst),
       .clk                   (clk),
       .phy_ctl_ready         (phy_ctl_ready),
       .load_done                (calib_tap_load_done),
       .calib_tap_inc_start      (calib_tap_inc_start),
       .calib_tap_inc_done       (calib_tap_inc_done),
       .calib_tap_inc_byte_cnt   (calib_tap_inc_byte_cnt),
       .calib_po_stage2_tap_cnt  (calib_po_stage2_tap_cnt),
       .calib_po_stage3_tap_cnt  (calib_po_stage3_tap_cnt),
       .calib_po_coarse_tap_cnt  (calib_po_coarse_tap_cnt),
       .calib_pi_stage2_tap_cnt  (calib_pi_stage2_tap_cnt),
       .calib_idelay_tap_cnt     (calib_idelay_tap_cnt),
       .po_counter_read_val      (po_counter_read_val),
       .pi_counter_read_val      (pi_counter_read_val),
       .calib_po_f_en            (calib_po_f_en),
       .calib_po_f_incdec        (calib_po_f_incdec),
       .calib_po_sel_stg2stg3    (calib_po_sel_stg2stg3),
       .calib_po_c_en            (calib_po_c_en),
       .calib_po_c_inc           (calib_po_c_inc),
       .calib_pi_f_en            (calib_pi_f_en),
       .calib_pi_f_incdec        (calib_pi_f_incdec),
       .calib_idelay_ce          (calib_idelay_ce),
       .calib_idelay_inc         (calib_idelay_inc),
       .skip_cal_po_pi_dec_done  (skip_cal_po_pi_dec_done),
       .coarse_dec_err           (coarse_dec_err),
       .dbg_skip_cal             (dbg_skip_cal)
       );

    // Generate tempmon_sample_en pulses for temperature adjustment
    reg [8:0] samp_en_cnt;

    always @ (posedge clk) begin
      if (rst || tempmon_done_skip || (samp_en_cnt == 'd0))
        samp_en_cnt <= #TCQ 'd267;
      else if (calib_complete && (samp_en_cnt > 'd0))
        samp_en_cnt <= #TCQ samp_en_cnt - 1;
    end

    always @ (posedge clk) begin
      if (rst || tempmon_done_skip)
        skip_cal_tempmon_samp_en <= #TCQ 1'b0;
      else if (samp_en_cnt == 'd260)
        skip_cal_tempmon_samp_en <= #TCQ 1'b1;
      else
        skip_cal_tempmon_samp_en <= #TCQ 1'b0;
    end



  end else begin: skip_calib_tap_off
    assign calib_po_f_en          = 1'b0;
    assign calib_po_f_incdec      = 1'b0;
    assign calib_po_sel_stg2stg3  = 1'b0;
    assign calib_po_c_en          = 1'b0;
    assign calib_po_c_inc         = 1'b0;
    assign calib_pi_f_en          = 1'b0;
    assign calib_pi_f_incdec      = 1'b0;
    assign calib_idelay_ce        = 1'b0;
    assign calib_idelay_inc       = 1'b0;
    assign calib_tap_inc_done     = 1'b0;
    assign calib_tap_inc_byte_cnt = 'd0;
    assign skip_cal_po_pi_dec_done = 1'b1;

    always @(posedge clk) begin
      calib_tap_req     <= #TCQ 1'b0;
      calib_device_temp <= #TCQ 'd0;
      skip_cal_tempmon_samp_en <= #TCQ 1'b0;
    end

end
endgenerate

  //***************************************************************************
  // Temperature induced PI tap adjustment logic
  //***************************************************************************

  mig_7series_v4_2_ddr_phy_tempmon #
    (
     .SKIP_CALIB  (SKIP_CALIB),
     .TCQ         (TCQ)
     )
    ddr_phy_tempmon_0
      (
       .rst                   (rst),
       .clk                   (clk),
       .calib_complete        (calib_complete),
       .tempmon_pi_f_inc      (tempmon_pi_f_inc),
       .tempmon_pi_f_dec      (tempmon_pi_f_dec),
       .tempmon_sel_pi_incdec (tempmon_sel_pi_incdec),
       .device_temp           (device_temp),
       .calib_device_temp     (calib_device_temp),
       .tempmon_sample_en     (tempmon_sample_en | skip_cal_tempmon_samp_en),
       .tempmon_done_skip     (tempmon_done_skip)
       );

endmodule

