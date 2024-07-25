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
// \   \   \/     Version               : %version
//  \   \         Application           : MIG
//  /   /         Filename              : mem_intfc.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Aug 03 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           : Top level memory interface block. Instantiates a clock
//                    and reset generator, the memory controller, the phy and
//                    the user interface blocks.
//Reference         :
//Revision History  :
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_mem_intfc #
  (
   parameter TCQ = 100,
   parameter DDR3_VDD_OP_VOLT = "135",     // Voltage mode used for DDR3
   parameter PAYLOAD_WIDTH   = 64,
   parameter ADDR_CMD_MODE   = "1T",
   parameter AL              = "0",     // Additive Latency option
   parameter BANK_WIDTH      = 3,       // # of bank bits
   parameter BM_CNT_WIDTH    = 2,       // Bank machine counter width
   parameter BURST_MODE      = "8",     // Burst length
   parameter BURST_TYPE      = "SEQ",   // Burst type
   parameter CA_MIRROR       = "OFF",   // C/A mirror opt for DDR3 dual rank
   parameter CK_WIDTH        = 1,       // # of CK/CK# outputs to memory
   // five fields, one per possible I/O bank, 4 bits in each field, 1 per lane
   // data=1/ctl=0
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

   // calibration Address. The address given below will be used for calibration
   // read and write operations.
   parameter CALIB_ROW_ADD   = 16'h0000,// Calibration row address
   parameter CALIB_COL_ADD   = 12'h000, // Calibration column address
   parameter CALIB_BA_ADD    = 3'h0,    // Calibration bank address
   parameter CL              = 5,
   parameter COL_WIDTH       = 12,      // column address width
   parameter CMD_PIPE_PLUS1  = "ON",    // add pipeline stage between MC and PHY
   parameter CS_WIDTH        = 1,       // # of unique CS outputs
   parameter CKE_WIDTH       = 1,       // # of cke outputs
   parameter CWL             = 5,
   parameter DATA_WIDTH      = 64,
   parameter DATA_BUF_ADDR_WIDTH = 8,
   parameter DATA_BUF_OFFSET_WIDTH = 1,
   parameter DDR2_DQSN_ENABLE = "YES",  // Enable differential DQS for DDR2
   parameter DM_WIDTH        = 8,       // # of DM (data mask)
   parameter DQ_CNT_WIDTH    = 6,       // = ceil(log2(DQ_WIDTH))
   parameter DQ_WIDTH        = 64,      // # of DQ (data)
   parameter DQS_CNT_WIDTH   = 3,       // = ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH       = 8,       // # of DQS (strobe)
   parameter DRAM_TYPE       = "DDR3",
   parameter DRAM_WIDTH      = 8,       // # of DQ per DQS
   parameter ECC             = "OFF",
   parameter ECC_WIDTH       = 8,
   parameter MC_ERR_ADDR_WIDTH = 31,
   parameter nAL             = 0,       // Additive latency (in clk cyc)
   parameter nBANK_MACHS     = 4,
   parameter PRE_REV3ES      = "OFF",   // Delay O/Ps using Phaser_Out fine dly
   parameter nCK_PER_CLK     = 4,       // # of memory CKs per fabric CLK
   parameter nCS_PER_RANK    = 1,       // # of unique CS outputs per rank
   // Hard PHY parameters
   parameter PHYCTL_CMD_FIFO = "FALSE",
   parameter ORDERING        = "NORM",
   parameter PHASE_DETECT    = "OFF"  ,  // to phy_top
   parameter IBUF_LPWR_MODE  = "OFF",    // to phy_top
   parameter BANK_TYPE       = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
   parameter DATA_IO_PRIM_TYPE = "DEFAULT", // # = "HP_LP", "HR_LP", "DEFAULT"
   parameter DATA_IO_IDLE_PWRDWN = "ON", // "ON" or "OFF"
   parameter IODELAY_GRP     = "IODELAY_MIG", //to phy_top
   parameter FPGA_SPEED_GRADE = 1,
   parameter OUTPUT_DRV      = "HIGH" ,  // to phy_top
   parameter REG_CTRL        = "OFF"  ,  // to phy_top
   parameter RTT_NOM         = "60"   ,  // to phy_top
   parameter RTT_WR          = "120"   , // to phy_top
   parameter STARVE_LIMIT    = 2,
   parameter tCK             = 2500,         // pS
   parameter tCKE            = 10000,        // pS
   parameter tFAW            = 40000,        // pS
   parameter tPRDI           = 1_000_000,    // pS
   parameter tRAS            = 37500,        // pS
   parameter tRCD            = 12500,        // pS
   parameter tREFI           = 7800000,      // pS
   parameter tRFC            = 110000,       // pS
   parameter tRP             = 12500,        // pS
   parameter tRRD            = 10000,        // pS
   parameter tRTP            = 7500,         // pS
   parameter tWTR            = 7500,         // pS
   parameter tZQI            = 128_000_000,  // nS
   parameter tZQCS           = 64,           // CKs
   parameter WRLVL           = "OFF"  ,  // to phy_top
   parameter DEBUG_PORT      = "OFF"  ,  // to phy_top
   parameter CAL_WIDTH       = "HALF" ,  // to phy_top
   parameter RANK_WIDTH      = 1,
   parameter RANKS           = 4,
   parameter ODT_WIDTH       = 1,
   parameter ROW_WIDTH       = 16,       // DRAM address bus width
   parameter [7:0] SLOT_0_CONFIG = 8'b0000_0001,
   parameter [7:0] SLOT_1_CONFIG = 8'b0000_0000,
   parameter SIM_BYPASS_INIT_CAL = "OFF",
   parameter REFCLK_FREQ     = 300.0,
   parameter nDQS_COL0       = DQS_WIDTH,
   parameter nDQS_COL1       = 0,
   parameter nDQS_COL2       = 0,
   parameter nDQS_COL3       = 0,
   parameter DQS_LOC_COL0    = 144'h11100F0E0D0C0B0A09080706050403020100,
   parameter DQS_LOC_COL1    = 0,
   parameter DQS_LOC_COL2    = 0,
   parameter DQS_LOC_COL3    = 0,
   parameter USE_CS_PORT     = 1,     // Support chip select output
   parameter USE_DM_PORT     = 1,     // Support data mask output
   parameter USE_ODT_PORT    = 1,     // Support ODT output
   parameter MASTER_PHY_CTL  = 0,     // The bank number where master PHY_CONTROL resides
   parameter USER_REFRESH    = "OFF", // Choose whether MC or User manages REF
   parameter TEMP_MON_EN     = "ON",   // Enable/disable temperature monitoring
   parameter IDELAY_ADJ      = "ON",   // Adjust IDELAY value (-1)
   parameter FINE_PER_BIT    = "ON",   // Use finedelay per-bit de-skew
   parameter CENTER_COMP_MODE = "ON",  // Use Center compensation table for PI
   parameter PI_VAL_ADJ       = "ON",  // Adjust PI final value (-1)
   parameter TAPSPERKCLK      = 56,
   parameter SKIP_CALIB       = "FALSE", // default value "FALSE"
   parameter FPGA_VOLT_TYPE   = "N"
  )
  (
   input                  clk_ref,
   input                  freq_refclk,
   input                  mem_refclk,
   input                  pll_lock,
   input                  sync_pulse,
   input                  mmcm_ps_clk,
   input                  poc_sample_pd,

   input                  error,
   input                  reset,
   output                 rst_tg_mc,

   input [BANK_WIDTH-1:0] bank,                   // To mc0 of mc.v
   input                  clk ,
   input                  clk_div2,       // mem_refclk divided by 2 for PI incdec
   input                  rst_div2,       // reset in clk_div2 domain
   input [2:0]            cmd,                    // To mc0 of mc.v
   input [COL_WIDTH-1:0]  col,                    // To mc0 of mc.v
   input                  correct_en,
   input [DATA_BUF_ADDR_WIDTH-1:0] data_buf_addr, // To mc0 of mc.v

   input                     dbg_idel_down_all,
   input                     dbg_idel_down_cpt,
   input                     dbg_idel_up_all,
   input                     dbg_idel_up_cpt,
   input                     dbg_sel_all_idel_cpt,
   input [DQS_CNT_WIDTH-1:0] dbg_sel_idel_cpt,
   input                     hi_priority,            // To mc0 of mc.v
   input [RANK_WIDTH-1:0]    rank,                   // To mc0 of mc.v
   input [2*nCK_PER_CLK-1:0]               raw_not_ecc,
   input [ROW_WIDTH-1:0]     row,                    // To mc0 of mc.v
   input                     rst,                    // To mc0 of mc.v, ...
   input                     size,                   // To mc0 of mc.v
   input [7:0]               slot_0_present,         // To mc0 of mc.v
   input [7:0]               slot_1_present,         // To mc0 of mc.v
   input                     use_addr,               // To mc0 of mc.v
   input [2*nCK_PER_CLK*PAYLOAD_WIDTH-1:0] wr_data,
   input [2*nCK_PER_CLK*DATA_WIDTH/8-1:0]  wr_data_mask,

   output                   accept,             // From mc0 of mc.v
   output                   accept_ns,          // From mc0 of mc.v
   output [BM_CNT_WIDTH-1:0] bank_mach_next,     // From mc0 of mc.v

   input                     app_sr_req,
   output                    app_sr_active,
   input                     app_ref_req,
   output                    app_ref_ack,
   input                     app_zq_req,
   output                    app_zq_ack,

   output [255:0]            dbg_calib_top,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_first_edge_cnt,
   output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_second_edge_cnt,
   output [255:0]            dbg_phy_rdlvl,
   output [99:0]             dbg_phy_wrcal,
   output [6*DQS_WIDTH-1:0]  dbg_final_po_fine_tap_cnt,
   output [3*DQS_WIDTH-1:0]  dbg_final_po_coarse_tap_cnt,
   output [DQS_WIDTH-1:0]    dbg_rd_data_edge_detect,
   output [2*nCK_PER_CLK*DQ_WIDTH-1:0] dbg_rddata,
   output [1:0]              dbg_rdlvl_done,
   output [1:0]              dbg_rdlvl_err,
   output [1:0]              dbg_rdlvl_start,
   output [5:0]              dbg_tap_cnt_during_wrlvl,
   output                    dbg_wl_edge_detect_valid,
   output                    dbg_wrlvl_done,
   output                    dbg_wrlvl_err,
   output                    dbg_wrlvl_start,

   output [ROW_WIDTH-1:0]    ddr_addr,           // From phy_top0 of phy_top.v
   output [BANK_WIDTH-1:0]   ddr_ba,             // From phy_top0 of phy_top.v
   output                    ddr_cas_n,          // From phy_top0 of phy_top.v
   output [CK_WIDTH-1:0]     ddr_ck_n,           // From phy_top0 of phy_top.v
   output [CK_WIDTH-1:0]     ddr_ck  ,           // From phy_top0 of phy_top.v
   output [CKE_WIDTH-1:0]    ddr_cke,            // From phy_top0 of phy_top.v
   output [CS_WIDTH*nCS_PER_RANK-1:0] ddr_cs_n,  // From phy_top0 of phy_top.v
   output [DM_WIDTH-1:0]     ddr_dm,             // From phy_top0 of phy_top.v
   output [ODT_WIDTH-1:0]    ddr_odt,            // From phy_top0 of phy_top.v
   output                    ddr_ras_n,          // From phy_top0 of phy_top.v
   output                    ddr_reset_n,        // From phy_top0 of phy_top.v
   output                    ddr_parity,
   output                    ddr_we_n,           // From phy_top0 of phy_top.v
   output                    init_calib_complete,
   output                    init_wrcal_complete,
   output [MC_ERR_ADDR_WIDTH-1:0] ecc_err_addr,
   output [2*nCK_PER_CLK-1:0]                   ecc_multiple,
   output [2*nCK_PER_CLK-1:0]                   ecc_single,

   output wire [2*nCK_PER_CLK*PAYLOAD_WIDTH-1:0] rd_data,
   output [DATA_BUF_ADDR_WIDTH-1:0]              rd_data_addr,
                                                      // From mc0 of mc.v
   output                             rd_data_en,     // From mc0 of mc.v
   output                             rd_data_end,    // From mc0 of mc.v
   output [DATA_BUF_OFFSET_WIDTH-1:0] rd_data_offset, // From mc0 of mc.v
   output [DATA_BUF_ADDR_WIDTH-1:0]   wr_data_addr,   // From mc0 of mc.v
   output                             wr_data_en,     // From mc0 of mc.v
   output [DATA_BUF_OFFSET_WIDTH-1:0] wr_data_offset, // From mc0 of mc.v

   // Ports to be used for SKIP_CALIB="TRUE"
   output                              calib_tap_req,
   input [6:0]                         calib_tap_addr,
   input                               calib_tap_load,
   input [7:0]                         calib_tap_val,
   input                               calib_tap_load_done,

   inout [DQ_WIDTH-1:0]      ddr_dq,       // To/From phy_top0 of phy_top.v
   inout [DQS_WIDTH-1:0]     ddr_dqs_n,    // To/From phy_top0 of phy_top.v
   inout [DQS_WIDTH-1:0]     ddr_dqs       // To/From phy_top0 of phy_top.v

   ,input [11:0]             device_temp

   //phase shift clock control
   ,output                   psen
   ,output                   psincdec
   ,input                    psdone
   ,input [DQ_WIDTH/8-1:0]   fi_xor_we
   ,input [DQ_WIDTH-1:0]     fi_xor_wrdata

   ,input                    dbg_sel_pi_incdec
   ,input                    dbg_sel_po_incdec
   ,input [DQS_CNT_WIDTH:0]  dbg_byte_sel
   ,input                    dbg_pi_f_inc
   ,input                    dbg_pi_f_dec
   ,input                    dbg_po_f_inc
   ,input                    dbg_po_f_stg23_sel
   ,input                    dbg_po_f_dec
   ,output [6*DQS_WIDTH*RANKS-1:0] dbg_cpt_tap_cnt
   ,output [5*DQS_WIDTH*RANKS-1:0] dbg_dq_idelay_tap_cnt
   ,output                   dbg_rddata_valid
   ,output [6*DQS_WIDTH-1:0] dbg_wrlvl_fine_tap_cnt
   ,output [3*DQS_WIDTH-1:0] dbg_wrlvl_coarse_tap_cnt
   ,output [255:0]           dbg_phy_wrlvl
   ,output [5:0]             dbg_pi_counter_read_val
   ,output [8:0]             dbg_po_counter_read_val
   ,output                   ref_dll_lock
   ,input                    rst_phaser_ref
   ,input                    iddr_rst
   ,output [6*RANKS-1:0]     dbg_rd_data_offset
   ,output [255:0]           dbg_phy_init
   ,output [255:0]           dbg_prbs_rdlvl
   ,output [255:0]           dbg_dqs_found_cal
   ,output                   dbg_pi_phaselock_start
   ,output                   dbg_pi_phaselocked_done
   ,output                   dbg_pi_phaselock_err
   ,output                   dbg_pi_dqsfound_start
   ,output                   dbg_pi_dqsfound_done
   ,output                   dbg_pi_dqsfound_err
   ,output                   dbg_wrcal_start
   ,output                   dbg_wrcal_done
   ,output                   dbg_wrcal_err
   ,output [11:0]            dbg_pi_dqs_found_lanes_phy4lanes
   ,output [11:0]            dbg_pi_phase_locked_phy4lanes
   ,output [6*RANKS-1:0]     dbg_calib_rd_data_offset_1
   ,output [6*RANKS-1:0]     dbg_calib_rd_data_offset_2
   ,output [5:0]             dbg_data_offset
   ,output [5:0]             dbg_data_offset_1
   ,output [5:0]             dbg_data_offset_2
   ,output                     dbg_oclkdelay_calib_start
   ,output                     dbg_oclkdelay_calib_done
   ,output [255:0]             dbg_phy_oclkdelay_cal
   ,output [DRAM_WIDTH*16 -1:0]dbg_oclkdelay_rd_data
   ,output [6*DQS_WIDTH*RANKS-1:0]      prbs_final_dqs_tap_cnt_r
   ,output [6*DQS_WIDTH*RANKS-1:0]      dbg_prbs_first_edge_taps
   ,output [6*DQS_WIDTH*RANKS-1:0]      dbg_prbs_second_edge_taps
   ,output [1023:0]          dbg_poc

   );

  localparam nSLOTS  = 1 + (|SLOT_1_CONFIG ? 1 : 0);
  localparam SLOT_0_CONFIG_MC = (nSLOTS == 2)? 8'b0000_0101 : 8'b0000_1111;
  localparam SLOT_1_CONFIG_MC = (nSLOTS == 2)? 8'b0000_1010 : 8'b0000_0000;

  // 8*tREFI in ps is divided by fabric clock period also in ps. 270 is the number
  // of fabric clock cycles that accounts for the Writes, read, and PRECHARGE time
  localparam REFRESH_TIMER = (8*tREFI/(tCK*nCK_PER_CLK)) - 270;

  reg [7:0]               slot_0_present_mc;
  reg [7:0]               slot_1_present_mc;

  reg user_periodic_rd_req = 1'b0;
  reg user_ref_req = 1'b0;
  reg user_zq_req = 1'b0;

  // MC/PHY interface
  wire [nCK_PER_CLK-1:0]              mc_ras_n;
  wire [nCK_PER_CLK-1:0]              mc_cas_n;
  wire [nCK_PER_CLK-1:0]              mc_we_n;
  wire [nCK_PER_CLK*ROW_WIDTH-1:0]    mc_address;
  wire [nCK_PER_CLK*BANK_WIDTH-1:0]   mc_bank;
  wire [nCK_PER_CLK-1 :0]             mc_cke ;
  wire [1:0]                  mc_odt ;
  wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mc_cs_n;
  wire                                mc_reset_n;
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0]   mc_wrdata;
  wire [2*nCK_PER_CLK*DQ_WIDTH/8-1:0] mc_wrdata_mask;
  wire                                mc_wrdata_en;
  wire                                mc_ref_zq_wip;
  wire                                tempmon_sample_en;
  wire                                idle;

  wire                                mc_cmd_wren;
  wire                                mc_ctl_wren;
  wire  [2:0]                         mc_cmd;
  wire  [1:0]                         mc_cas_slot;
  wire  [5:0]                         mc_data_offset;
  wire  [5:0]                         mc_data_offset_1;
  wire  [5:0]                         mc_data_offset_2;
  wire  [3:0]                         mc_aux_out0;
  wire  [3:0]                         mc_aux_out1;
  wire  [1:0]                         mc_rank_cnt;

  wire                                phy_mc_ctl_full;
  wire                                phy_mc_cmd_full;
  wire                                phy_mc_data_full;
  wire  [2*nCK_PER_CLK*DQ_WIDTH-1:0]  phy_rd_data;
  wire                                phy_rddata_valid;

  wire  [6*RANKS-1:0]                 calib_rd_data_offset_0;
  wire  [6*RANKS-1:0]                 calib_rd_data_offset_1;
  wire  [6*RANKS-1:0]                 calib_rd_data_offset_2;
  wire                                init_calib_complete_w;
  wire                                init_wrcal_complete_w;
  wire                                mux_rst;
  wire                                mux_calib_complete;
  // assigning CWL = CL -1 for DDR2. DDR2 customers will not know anything
  // about CWL. There is also nCWL parameter. Need to clean it up.
  localparam CWL_T = (DRAM_TYPE == "DDR3") ? CWL : CL-1;

  assign init_calib_complete = init_calib_complete_w;
  assign init_wrcal_complete = init_wrcal_complete_w;
  assign mux_calib_complete  = (PRE_REV3ES == "OFF") ? init_calib_complete_w :
                               (init_calib_complete_w | init_wrcal_complete_w);
  assign mux_rst             = (PRE_REV3ES == "OFF") ? rst : reset;
  assign dbg_calib_rd_data_offset_1 = calib_rd_data_offset_1;
  assign dbg_calib_rd_data_offset_2 = calib_rd_data_offset_2;
  assign dbg_data_offset     = mc_data_offset;
  assign dbg_data_offset_1   = mc_data_offset_1;
  assign dbg_data_offset_2   = mc_data_offset_2;

  // Enable / disable temperature monitoring
  assign tempmon_sample_en = TEMP_MON_EN == "OFF" ? 1'b0 : mc_ref_zq_wip;

  generate
    if (nSLOTS == 1) begin: gen_single_slot_odt
      always @ (slot_0_present or slot_1_present) begin
        slot_0_present_mc = slot_0_present;
        slot_1_present_mc = slot_1_present;
      end
    end else if (nSLOTS == 2) begin: gen_dual_slot_odt
        always @ (slot_0_present[0] or slot_0_present[1]
                or slot_1_present[0] or slot_1_present[1]) begin
        case ({slot_0_present[0],slot_0_present[1],
               slot_1_present[0],slot_1_present[1]})
          //Two slot configuration, one slot present, single rank
          4'b1000: begin
             slot_0_present_mc = 8'b0000_0001;
             slot_1_present_mc = 8'b0000_0000;
          end
          4'b0010: begin
            slot_0_present_mc = 8'b0000_0000;
            slot_1_present_mc = 8'b0000_0010;
          end
          // Two slot configuration, one slot present, dual rank
          4'b1100: begin
            slot_0_present_mc = 8'b0000_0101;
            slot_1_present_mc = 8'b0000_0000;
          end
          4'b0011: begin
            slot_0_present_mc = 8'b0000_0000;
            slot_1_present_mc = 8'b0000_1010;
          end
          // Two slot configuration, one rank per slot
          4'b1010: begin
            slot_0_present_mc = 8'b0000_0001;
            slot_1_present_mc = 8'b0000_0010;
          end
          // Two Slots - One slot with dual rank and the other with single rank
          4'b1011: begin
            slot_0_present_mc = 8'b0000_0001;
            slot_1_present_mc = 8'b0000_1010;
          end
          4'b1110: begin
            slot_0_present_mc = 8'b0000_0101;
            slot_1_present_mc = 8'b0000_0010;
          end
          // Two Slots - two ranks per slot
          4'b1111: begin
            slot_0_present_mc = 8'b0000_0101;
            slot_1_present_mc = 8'b0000_1010;
          end
        endcase
      end
    end
  endgenerate

  mig_7series_v4_2_mc #
   (
    .TCQ                                (TCQ),
    .PAYLOAD_WIDTH                      (PAYLOAD_WIDTH),
    .MC_ERR_ADDR_WIDTH                  (MC_ERR_ADDR_WIDTH),
    .ADDR_CMD_MODE                      (ADDR_CMD_MODE),
    .BANK_WIDTH                         (BANK_WIDTH),
    .BM_CNT_WIDTH                       (BM_CNT_WIDTH),
    .BURST_MODE                         (BURST_MODE),
    .COL_WIDTH                          (COL_WIDTH),
    .CMD_PIPE_PLUS1                     (CMD_PIPE_PLUS1),
    .CS_WIDTH                           (CS_WIDTH),
    .DATA_WIDTH                         (DATA_WIDTH),
    .DATA_BUF_ADDR_WIDTH                (DATA_BUF_ADDR_WIDTH),
    .DATA_BUF_OFFSET_WIDTH              (DATA_BUF_OFFSET_WIDTH),
    .DRAM_TYPE                          (DRAM_TYPE),
    .CKE_ODT_AUX                (CKE_ODT_AUX),
    .DQS_WIDTH                          (DQS_WIDTH),
    .DQ_WIDTH                           (DQ_WIDTH),
    .ECC                                (ECC),
    .ECC_WIDTH                          (ECC_WIDTH),
    .nBANK_MACHS                        (nBANK_MACHS),
    .nCK_PER_CLK                        (nCK_PER_CLK),
    .nSLOTS                             (nSLOTS),
    .CL                                 (CL),
    .nCS_PER_RANK                       (nCS_PER_RANK),
    .CWL                                (CWL_T),
    .ORDERING                           (ORDERING),
    .RANK_WIDTH                         (RANK_WIDTH),
    .RANKS                              (RANKS),
    .REG_CTRL                           (REG_CTRL),
    .ROW_WIDTH                          (ROW_WIDTH),
    .RTT_NOM                            (RTT_NOM),
    .RTT_WR                             (RTT_WR),
    .STARVE_LIMIT                       (STARVE_LIMIT),
    .SLOT_0_CONFIG                      (SLOT_0_CONFIG_MC),
    .SLOT_1_CONFIG                      (SLOT_1_CONFIG_MC),
    .tCK                                (tCK),
    .tCKE                               (tCKE),
    .tFAW                               (tFAW),
    .tRAS                               (tRAS),
    .tRCD                               (tRCD),
    .tREFI                              (tREFI),
    .tRFC                               (tRFC),
    .tRP                                (tRP),
    .tRRD                               (tRRD),
    .tRTP                               (tRTP),
    .tWTR                               (tWTR),
    .tZQI                               (tZQI),
    .tZQCS                              (tZQCS),
    .tPRDI                              (tPRDI),
    .USER_REFRESH                       (USER_REFRESH))
   mc0
     (.app_periodic_rd_req    (1'b0),
      .app_sr_req             (app_sr_req),
      .app_sr_active          (app_sr_active),
      .app_ref_req            (app_ref_req),
      .app_ref_ack            (app_ref_ack),
      .app_zq_req             (app_zq_req),
      .app_zq_ack             (app_zq_ack),
      .ecc_single             (ecc_single),
      .ecc_multiple           (ecc_multiple),
      .ecc_err_addr           (ecc_err_addr),
      .mc_address             (mc_address),
      .mc_aux_out0            (mc_aux_out0),
      .mc_aux_out1            (mc_aux_out1),
      .mc_bank                (mc_bank),
      .mc_cke                 (mc_cke),
      .mc_odt                 (mc_odt),
      .mc_cas_n               (mc_cas_n),
      .mc_cmd                 (mc_cmd),
      .mc_cmd_wren            (mc_cmd_wren),
      .mc_cs_n                (mc_cs_n),
      .mc_ctl_wren            (mc_ctl_wren),
      .mc_data_offset         (mc_data_offset),
      .mc_data_offset_1       (mc_data_offset_1),
      .mc_data_offset_2       (mc_data_offset_2),
      .mc_cas_slot            (mc_cas_slot),
      .mc_rank_cnt            (mc_rank_cnt),
      .mc_ras_n               (mc_ras_n),
      .mc_reset_n             (mc_reset_n),
      .mc_we_n                (mc_we_n),
      .mc_wrdata              (mc_wrdata),
      .mc_wrdata_en           (mc_wrdata_en),
      .mc_wrdata_mask         (mc_wrdata_mask),
      // Outputs
      .accept                 (accept),
      .accept_ns              (accept_ns),
      .bank_mach_next         (bank_mach_next[BM_CNT_WIDTH-1:0]),
      .rd_data_addr           (rd_data_addr[DATA_BUF_ADDR_WIDTH-1:0]),
      .rd_data_en             (rd_data_en),
      .rd_data_end            (rd_data_end),
      .rd_data_offset         (rd_data_offset),
      .wr_data_addr           (wr_data_addr[DATA_BUF_ADDR_WIDTH-1:0]),
      .wr_data_en             (wr_data_en),
      .wr_data_offset         (wr_data_offset),
      .rd_data                (rd_data),
      .wr_data                (wr_data),
      .wr_data_mask           (wr_data_mask),
      .mc_read_idle           (idle),
      .mc_ref_zq_wip          (mc_ref_zq_wip),
      // Inputs
      .init_calib_complete    (mux_calib_complete),
      .calib_rd_data_offset   (calib_rd_data_offset_0),
      .calib_rd_data_offset_1 (calib_rd_data_offset_1),
      .calib_rd_data_offset_2 (calib_rd_data_offset_2),
      .phy_mc_ctl_full        (phy_mc_ctl_full),
      .phy_mc_cmd_full        (phy_mc_cmd_full),
      .phy_mc_data_full       (phy_mc_data_full),
      .phy_rd_data            (phy_rd_data),
      .phy_rddata_valid       (phy_rddata_valid),
      .correct_en             (correct_en),
      .bank                   (bank[BANK_WIDTH-1:0]),
      .clk                    (clk),
      .cmd                    (cmd[2:0]),
      .col                    (col[COL_WIDTH-1:0]),
      .data_buf_addr          (data_buf_addr[DATA_BUF_ADDR_WIDTH-1:0]),
      .hi_priority            (hi_priority),
      .rank                   (rank[RANK_WIDTH-1:0]),
      .raw_not_ecc            (raw_not_ecc[2*nCK_PER_CLK-1 :0]),
      .row                    (row[ROW_WIDTH-1:0]),
      .rst                    (mux_rst),
      .size                   (size),
      .slot_0_present         (slot_0_present_mc[7:0]),
      .slot_1_present         (slot_1_present_mc[7:0]),
      .fi_xor_we          (fi_xor_we),
      .fi_xor_wrdata          (fi_xor_wrdata),
      .use_addr               (use_addr));

  // following calculations should be moved inside PHY
  // odt bus should  be added to PHY.
  localparam CLK_PERIOD = tCK * nCK_PER_CLK;
  localparam nCL  = CL;
  localparam nCWL = CWL_T;
`ifdef MC_SVA
  ddr2_improper_CL: assert property
     (@(posedge clk) (~((DRAM_TYPE == "DDR2") && ((CL > 6) || (CL < 3)))));
  // Not needed after the CWL fix for DDR2
  //  ddr2_improper_CWL: assert property
  //     (@(posedge clk) (~((DRAM_TYPE == "DDR2") && ((CL - CWL) != 1))));
`endif

  mig_7series_v4_2_ddr_phy_top #
    (
     .TCQ                (TCQ),
     .DDR3_VDD_OP_VOLT   (DDR3_VDD_OP_VOLT),
     .REFCLK_FREQ        (REFCLK_FREQ),
     .BYTE_LANES_B0      (BYTE_LANES_B0),
     .BYTE_LANES_B1      (BYTE_LANES_B1),
     .BYTE_LANES_B2      (BYTE_LANES_B2),
     .BYTE_LANES_B3      (BYTE_LANES_B3),
     .BYTE_LANES_B4      (BYTE_LANES_B4),
     .PHY_0_BITLANES     (PHY_0_BITLANES),
     .PHY_1_BITLANES     (PHY_1_BITLANES),
     .PHY_2_BITLANES     (PHY_2_BITLANES),
     .CA_MIRROR          (CA_MIRROR),
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
     .CALIB_ROW_ADD      (CALIB_ROW_ADD),
     .CALIB_COL_ADD      (CALIB_COL_ADD),
     .CALIB_BA_ADD       (CALIB_BA_ADD),
     .nCS_PER_RANK       (nCS_PER_RANK),
     .CS_WIDTH           (CS_WIDTH),
     .nCK_PER_CLK        (nCK_PER_CLK),
     .PRE_REV3ES         (PRE_REV3ES),
     .CKE_WIDTH          (CKE_WIDTH),
     .DATA_CTL_B0        (DATA_CTL_B0),
     .DATA_CTL_B1        (DATA_CTL_B1),
     .DATA_CTL_B2        (DATA_CTL_B2),
     .DATA_CTL_B3        (DATA_CTL_B3),
     .DATA_CTL_B4        (DATA_CTL_B4),
     .DDR2_DQSN_ENABLE   (DDR2_DQSN_ENABLE),
     .DRAM_TYPE          (DRAM_TYPE),
     .BANK_WIDTH         (BANK_WIDTH),
     .CK_WIDTH           (CK_WIDTH),
     .COL_WIDTH          (COL_WIDTH),
     .DM_WIDTH           (DM_WIDTH),
     .DQ_WIDTH           (DQ_WIDTH),
     .DQS_CNT_WIDTH      (DQS_CNT_WIDTH),
     .DQS_WIDTH          (DQS_WIDTH),
     .DRAM_WIDTH         (DRAM_WIDTH),
     .PHYCTL_CMD_FIFO    (PHYCTL_CMD_FIFO),
     .ROW_WIDTH          (ROW_WIDTH),
     .AL                 (AL),
     .ADDR_CMD_MODE      (ADDR_CMD_MODE),
     .BURST_MODE         (BURST_MODE),
     .BURST_TYPE         (BURST_TYPE),
     .CL                 (nCL),
     .CWL                (nCWL),
     .tRFC               (tRFC),
     .tREFI              (tREFI),
     .tCK                (tCK),
     .OUTPUT_DRV         (OUTPUT_DRV),
     .RANKS              (RANKS),
     .ODT_WIDTH          (ODT_WIDTH),
     .REG_CTRL           (REG_CTRL),
     .RTT_NOM            (RTT_NOM),
     .RTT_WR             (RTT_WR),
     .SLOT_1_CONFIG      (SLOT_1_CONFIG),
     .WRLVL              (WRLVL),
     .BANK_TYPE          (BANK_TYPE),
     .DATA_IO_PRIM_TYPE  (DATA_IO_PRIM_TYPE),
     .DATA_IO_IDLE_PWRDWN(DATA_IO_IDLE_PWRDWN),
     .IODELAY_GRP        (IODELAY_GRP),
     .FPGA_SPEED_GRADE   (FPGA_SPEED_GRADE),
     // Prevent the following simulation-related parameters from
     // being overridden for synthesis - for synthesis only the
     // default values of these parameters should be used
     // synthesis translate_off
     .SIM_BYPASS_INIT_CAL (SIM_BYPASS_INIT_CAL),
     // synthesis translate_on
     .USE_CS_PORT        (USE_CS_PORT),
     .USE_DM_PORT        (USE_DM_PORT),
     .USE_ODT_PORT       (USE_ODT_PORT),
     .MASTER_PHY_CTL     (MASTER_PHY_CTL),
     .DEBUG_PORT         (DEBUG_PORT),
     .IDELAY_ADJ         (IDELAY_ADJ),
     .FINE_PER_BIT       (FINE_PER_BIT),
     .CENTER_COMP_MODE   (CENTER_COMP_MODE),
     .PI_VAL_ADJ         (PI_VAL_ADJ),
     .TAPSPERKCLK        (TAPSPERKCLK),
     .SKIP_CALIB         (SKIP_CALIB),
     .FPGA_VOLT_TYPE     (FPGA_VOLT_TYPE)
     )
    ddr_phy_top0
      (
       // Outputs
       .calib_rd_data_offset_0      (calib_rd_data_offset_0),
       .calib_rd_data_offset_1      (calib_rd_data_offset_1),
       .calib_rd_data_offset_2      (calib_rd_data_offset_2),
       .ddr_ck                      (ddr_ck),
       .ddr_ck_n                    (ddr_ck_n),
       .ddr_addr                    (ddr_addr),
       .ddr_ba                      (ddr_ba),
       .ddr_ras_n                   (ddr_ras_n),
       .ddr_cas_n                   (ddr_cas_n),
       .ddr_we_n                    (ddr_we_n),
       .ddr_cs_n                    (ddr_cs_n),
       .ddr_cke                     (ddr_cke),
       .ddr_odt                     (ddr_odt),
       .ddr_reset_n                 (ddr_reset_n),
       .ddr_parity                  (ddr_parity),
       .ddr_dm                      (ddr_dm),
       .dbg_calib_top               (dbg_calib_top),
       .dbg_cpt_first_edge_cnt      (dbg_cpt_first_edge_cnt),
       .dbg_cpt_second_edge_cnt     (dbg_cpt_second_edge_cnt),
       .dbg_phy_rdlvl               (dbg_phy_rdlvl),
       .dbg_phy_wrcal               (dbg_phy_wrcal),
       .dbg_final_po_fine_tap_cnt   (dbg_final_po_fine_tap_cnt),
       .dbg_final_po_coarse_tap_cnt (dbg_final_po_coarse_tap_cnt),
       .dbg_rd_data_edge_detect     (dbg_rd_data_edge_detect),
       .dbg_rddata                  (dbg_rddata),
       .dbg_rdlvl_done              (dbg_rdlvl_done),
       .dbg_rdlvl_err               (dbg_rdlvl_err),
       .dbg_rdlvl_start             (dbg_rdlvl_start),
       .dbg_tap_cnt_during_wrlvl    (dbg_tap_cnt_during_wrlvl),
       .dbg_wl_edge_detect_valid    (dbg_wl_edge_detect_valid),
       .dbg_wrlvl_done              (dbg_wrlvl_done),
       .dbg_wrlvl_err               (dbg_wrlvl_err),
       .dbg_wrlvl_start             (dbg_wrlvl_start),
       .dbg_pi_phase_locked_phy4lanes (dbg_pi_phase_locked_phy4lanes),
       .dbg_pi_dqs_found_lanes_phy4lanes (dbg_pi_dqs_found_lanes_phy4lanes),
       .init_calib_complete         (init_calib_complete_w),
       .init_wrcal_complete         (init_wrcal_complete_w),
       .mc_address                  (mc_address),
       .mc_aux_out0                 (mc_aux_out0),
       .mc_aux_out1                 (mc_aux_out1),
       .mc_bank                     (mc_bank),
       .mc_cke                      (mc_cke),
       .mc_odt                      (mc_odt),
       .mc_cas_n                    (mc_cas_n),
       .mc_cmd                      (mc_cmd),
       .mc_cmd_wren                 (mc_cmd_wren),
       .mc_cas_slot                 (mc_cas_slot),
       .mc_cs_n                     (mc_cs_n),
       .mc_ctl_wren                 (mc_ctl_wren),
       .mc_data_offset              (mc_data_offset),
       .mc_data_offset_1            (mc_data_offset_1),
       .mc_data_offset_2            (mc_data_offset_2),
       .mc_rank_cnt                 (mc_rank_cnt),
       .mc_ras_n                    (mc_ras_n),
       .mc_reset_n                  (mc_reset_n),
       .mc_we_n                     (mc_we_n),
       .mc_wrdata                   (mc_wrdata),
       .mc_wrdata_en                (mc_wrdata_en),
       .mc_wrdata_mask              (mc_wrdata_mask),
       .idle                        (idle),
       .mem_refclk                  (mem_refclk),
       .phy_mc_ctl_full             (phy_mc_ctl_full),
       .phy_mc_cmd_full             (phy_mc_cmd_full),
       .phy_mc_data_full            (phy_mc_data_full),
       .phy_rd_data                 (phy_rd_data),
       .phy_rddata_valid            (phy_rddata_valid),
       .pll_lock                    (pll_lock),
       .sync_pulse                  (sync_pulse),
       // Inouts
       .ddr_dqs                     (ddr_dqs),
       .ddr_dqs_n                   (ddr_dqs_n),
       .ddr_dq                      (ddr_dq),
        // Inputs
       .clk_ref                     (clk_ref),
       .freq_refclk                 (freq_refclk),
       .clk                         (clk),
       .clk_div2                    (clk_div2),
       .rst_div2                    (rst_div2),
       .mmcm_ps_clk                 (mmcm_ps_clk),
       .poc_sample_pd               (poc_sample_pd),
       .rst                         (rst),
       .error                       (error),
       .rst_tg_mc                   (rst_tg_mc),
       .slot_0_present              (slot_0_present),
       .slot_1_present              (slot_1_present),
       .dbg_idel_up_all             (dbg_idel_up_all),
       .dbg_idel_down_all           (dbg_idel_down_all),
       .dbg_idel_up_cpt             (dbg_idel_up_cpt),
       .dbg_idel_down_cpt           (dbg_idel_down_cpt),
       .dbg_sel_idel_cpt            (dbg_sel_idel_cpt),
       .dbg_sel_all_idel_cpt        (dbg_sel_all_idel_cpt)

       ,.device_temp                (device_temp)
       ,.tempmon_sample_en          (tempmon_sample_en)
       ,.psen                       (psen)
       ,.psincdec                   (psincdec)
       ,.psdone                     (psdone)

       ,.calib_tap_req              (calib_tap_req)
       ,.calib_tap_addr             (calib_tap_addr)
       ,.calib_tap_load             (calib_tap_load)
       ,.calib_tap_val              (calib_tap_val)
       ,.calib_tap_load_done        (calib_tap_load_done)

       ,.dbg_sel_pi_incdec          (dbg_sel_pi_incdec)
       ,.dbg_sel_po_incdec          (dbg_sel_po_incdec)
       ,.dbg_byte_sel               (dbg_byte_sel)
       ,.dbg_pi_f_inc               (dbg_pi_f_inc)
       ,.dbg_po_f_inc               (dbg_po_f_inc)
       ,.dbg_po_f_stg23_sel         (dbg_po_f_stg23_sel)
       ,.dbg_pi_f_dec               (dbg_pi_f_dec)
       ,.dbg_po_f_dec               (dbg_po_f_dec)
       ,.dbg_cpt_tap_cnt            (dbg_cpt_tap_cnt)
       ,.dbg_dq_idelay_tap_cnt      (dbg_dq_idelay_tap_cnt)
       ,.dbg_rddata_valid           (dbg_rddata_valid)
       ,.dbg_wrlvl_fine_tap_cnt     (dbg_wrlvl_fine_tap_cnt)
       ,.dbg_wrlvl_coarse_tap_cnt   (dbg_wrlvl_coarse_tap_cnt)
       ,.dbg_phy_wrlvl              (dbg_phy_wrlvl)
       ,.ref_dll_lock               (ref_dll_lock)
       ,.rst_phaser_ref             (rst_phaser_ref)
       ,.iddr_rst                   (iddr_rst)
       ,.dbg_rd_data_offset         (dbg_rd_data_offset)
       ,.dbg_phy_init               (dbg_phy_init)
       ,.dbg_prbs_rdlvl             (dbg_prbs_rdlvl)
       ,.dbg_dqs_found_cal          (dbg_dqs_found_cal)
       ,.dbg_po_counter_read_val    (dbg_po_counter_read_val)
       ,.dbg_pi_counter_read_val    (dbg_pi_counter_read_val)
       ,.dbg_pi_phaselock_start     (dbg_pi_phaselock_start)
       ,.dbg_pi_phaselocked_done    (dbg_pi_phaselocked_done)
       ,.dbg_pi_phaselock_err       (dbg_pi_phaselock_err)
       ,.dbg_pi_dqsfound_start      (dbg_pi_dqsfound_start)
       ,.dbg_pi_dqsfound_done       (dbg_pi_dqsfound_done)
       ,.dbg_pi_dqsfound_err        (dbg_pi_dqsfound_err)
       ,.dbg_wrcal_start            (dbg_wrcal_start)
       ,.dbg_wrcal_done             (dbg_wrcal_done)
       ,.dbg_wrcal_err              (dbg_wrcal_err)
       ,.dbg_phy_oclkdelay_cal      (dbg_phy_oclkdelay_cal)
       ,.dbg_oclkdelay_rd_data      (dbg_oclkdelay_rd_data)
       ,.dbg_oclkdelay_calib_start  (dbg_oclkdelay_calib_start)
       ,.dbg_oclkdelay_calib_done   (dbg_oclkdelay_calib_done)
       ,.prbs_final_dqs_tap_cnt_r   (prbs_final_dqs_tap_cnt_r)
       ,.dbg_prbs_first_edge_taps   (dbg_prbs_first_edge_taps)
       ,.dbg_prbs_second_edge_taps  (dbg_prbs_second_edge_taps)
       ,.dbg_poc                    (dbg_poc[1023:0])
      );

endmodule

