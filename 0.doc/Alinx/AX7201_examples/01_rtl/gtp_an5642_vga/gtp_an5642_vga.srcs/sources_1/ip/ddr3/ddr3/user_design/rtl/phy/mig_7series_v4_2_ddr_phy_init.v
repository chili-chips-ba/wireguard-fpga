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
//  /   /         Filename: ddr_phy_init.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:35:09 $
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: 7 Series
//Design Name: DDR3 SDRAM
//Purpose:
//  Memory initialization and overall master state control during
//  initialization and calibration. Specifically, the following functions
//  are performed:
//    1. Memory initialization (initial AR, mode register programming, etc.)
//    2. Initiating write leveling
//    3. Generate training pattern writes for read leveling. Generate
//       memory readback for read leveling.
//  This module has an interface for providing control/address and write
//  data to the PHY Control Block during initialization/calibration.
//  Once initialization and calibration are complete, control is passed to the MC. 
//
//Reference:
//Revision History:
// 
//*****************************************************************************

/******************************************************************************
**$Id: ddr_phy_init.v,v 1.1 2011/06/02 08:35:09 mishra Exp $
**$Date: 2011/06/02 08:35:09 $
**$Author: mishra $
**$Revision: 1.1 $
**$Source: /devl/xcs/repo/env/Databases/ip/src2/O/mig_7series_v1_3/data/dlib/7series/ddr3_sdram/verilog/rtl/phy/ddr_phy_init.v,v $
******************************************************************************/

`timescale 1ps/1ps


module mig_7series_v4_2_ddr_phy_init #
  (
   parameter tCK          = 1500,        // DDRx SDRAM clock period
   parameter TCQ          = 100,
   parameter nCK_PER_CLK  = 4,           // # of memory clocks per CLK
   parameter CLK_PERIOD   = 3000,        // Logic (internal) clk period (in ps)
   parameter USE_ODT_PORT = 0,           // 0 - No ODT output from FPGA
                                         // 1 - ODT output from FPGA
   parameter DDR3_VDD_OP_VOLT = "150",     // Voltage mode used for DDR3
                                         // 150 - 1.50 V
                                         // 135 - 1.35 V
                                         // 125 - 1.25 V
   parameter VREF         = "EXTERNAL",  // Internal or external Vref
   parameter PRBS_WIDTH   = 8,          // PRBS sequence = 2^PRBS_WIDTH
   parameter BANK_WIDTH   = 2,
   parameter CA_MIRROR    = "OFF",       // C/A mirror opt for DDR3 dual rank
   parameter COL_WIDTH    = 10,
   parameter nCS_PER_RANK = 1,           // # of CS bits per rank e.g. for 
                                         // component I/F with CS_WIDTH=1, 
                                         // nCS_PER_RANK=# of components
   parameter DQ_WIDTH     = 64,
   parameter DQS_WIDTH    = 8,
   parameter DQS_CNT_WIDTH   = 3,        // = ceil(log2(DQS_WIDTH))
   parameter ROW_WIDTH    = 14,
   parameter CS_WIDTH     = 1,
   parameter RANKS        = 1,       // # of memory ranks in the interface
   parameter CKE_WIDTH    = 1,       // # of cke outputs 
   parameter DRAM_TYPE    = "DDR3",
   parameter REG_CTRL     = "ON",
   parameter ADDR_CMD_MODE= "1T", 

   // calibration Address
   parameter CALIB_ROW_ADD   = 16'h0000,// Calibration row address
   parameter CALIB_COL_ADD   = 12'h000, // Calibration column address
   parameter CALIB_BA_ADD    = 3'h0,    // Calibration bank address 
   
   // DRAM mode settings
   parameter AL               = "0",     // Additive Latency option
   parameter BURST_MODE       = "8",     // Burst length
   parameter BURST_TYPE       = "SEQ",   // Burst type 
//   parameter nAL              = 0,       // Additive latency (in clk cyc)
   parameter nCL              = 5,       // Read CAS latency (in clk cyc)
   parameter nCWL             = 5,       // Write CAS latency (in clk cyc)
   parameter tRFC             = 110000,  // Refresh-to-command delay (in ps)
   parameter REFRESH_TIMER    = 1553,    // Refresh interval in fabrci cycles between 8 posted refreshes
   parameter REFRESH_TIMER_WIDTH = 8,
   parameter OUTPUT_DRV       = "HIGH",  // DRAM reduced output drive option
   parameter RTT_NOM          = "60",    // Nominal ODT termination value
   parameter RTT_WR           = "60",    // Write ODT termination value
   parameter WRLVL            = "ON",    // Enable write leveling
//   parameter PHASE_DETECT     = "ON",    // Enable read phase detector
   parameter DDR2_DQSN_ENABLE = "YES",   // Enable differential DQS for DDR2
   parameter nSLOTS           = 1,       // Number of DIMM SLOTs in the system
   parameter SIM_INIT_OPTION  = "NONE",  // "NONE", "SKIP_PU_DLY", "SKIP_INIT"
   parameter SIM_CAL_OPTION   = "NONE",  // "NONE", "FAST_CAL", "SKIP_CAL"
   parameter CKE_ODT_AUX      = "FALSE",
   parameter PRE_REV3ES       = "OFF",   // Enable TG error detection during calibration
   parameter TEST_AL          = "0",     // Internal use for ICM verification
   parameter FIXED_VICTIM     = "TRUE",
   parameter BYPASS_COMPLEX_OCAL = "FALSE",
   parameter SKIP_CALIB       = "FALSE"
   )
  (
   input                       clk,
   input                       rst,
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0] prbs_o,
   input                       delay_incdec_done,
   input                       ck_addr_cmd_delay_done,
   input                       pi_phase_locked_all,
   input                       pi_dqs_found_done,
   input                       dqsfound_retry,
   input                       dqs_found_prech_req,
   output reg                  pi_phaselock_start,
   output                      pi_phase_locked_err,
   output                      pi_calib_done,
   input                       phy_if_empty,
   // Read/write calibration interface
   input                       wrlvl_done,
   input                       wrlvl_rank_done,
   input                       wrlvl_byte_done,
   input                       wrlvl_byte_redo,
   input                       wrlvl_final,
   output reg                  wrlvl_final_if_rst,
   input                       oclkdelay_calib_done,
   input                       oclk_prech_req,
   input                       oclk_calib_resume,
   input                       lim_done,
   input                       lim_wr_req,
   output reg                  oclkdelay_calib_start,
   //complex oclkdelay calibration
   input                       complex_oclkdelay_calib_done,
   input                       complex_oclk_prech_req,
   input                       complex_oclk_calib_resume,
   output reg                  complex_oclkdelay_calib_start,
   input [DQS_CNT_WIDTH:0]     complex_oclkdelay_calib_cnt, // same as oclkdelay_calib_cnt
   output reg                  complex_ocal_num_samples_inc,
   input                       complex_ocal_num_samples_done_r,
   input [2:0]                 complex_ocal_rd_victim_sel,
   output reg                  complex_ocal_reset_rd_addr,
   input                       complex_ocal_ref_req,
   output reg                  complex_ocal_ref_done,
   
   input                       done_dqs_tap_inc,
   input [5:0]                 rd_data_offset_0,
   input [5:0]                 rd_data_offset_1,
   input [5:0]                 rd_data_offset_2,
   input [6*RANKS-1:0]         rd_data_offset_ranks_0,
   input [6*RANKS-1:0]         rd_data_offset_ranks_1,
   input [6*RANKS-1:0]         rd_data_offset_ranks_2,
   input                       pi_dqs_found_rank_done,
   input                       wrcal_done,
   input                       wrcal_prech_req,
   input                       wrcal_read_req,
   input                       wrcal_act_req,
   input                       temp_wrcal_done,
   input [7:0]                 slot_0_present,
   input [7:0]                 slot_1_present,
   output reg                  wl_sm_start,
   output reg                  wr_lvl_start,
   output reg                  wrcal_start,
   output reg                  wrcal_rd_wait,
   output reg                  wrcal_sanity_chk,
   output reg                  tg_timer_done,
   output reg                  no_rst_tg_mc,
   input                       rdlvl_stg1_done,
   input                       rdlvl_stg1_rank_done,
   output reg                  rdlvl_stg1_start,
   output reg                  pi_dqs_found_start,
   output reg                  detect_pi_found_dqs,
   // rdlvl stage 1 precharge requested after each DQS  
   input                       rdlvl_prech_req,
   input                       rdlvl_last_byte_done,
   input                       wrcal_resume,
   input                       wrcal_sanity_chk_done,
   // MPR read leveling
   input                       mpr_rdlvl_done,
   input                       mpr_rnk_done,
   input                       mpr_last_byte_done,
   output reg                  mpr_rdlvl_start,
   output reg                  mpr_end_if_reset,

   // PRBS Read Leveling
   input                       prbs_rdlvl_done,
   input                       prbs_last_byte_done,
   input                       prbs_rdlvl_prech_req,
   input                       complex_victim_inc,
   input [2:0]                 rd_victim_sel,
   input [DQS_CNT_WIDTH:0]     pi_stg2_prbs_rdlvl_cnt,
   output reg [2:0]            victim_sel,
   output reg [DQS_CNT_WIDTH:0]victim_byte_cnt,
   output reg                  prbs_rdlvl_start,
   output reg                  prbs_gen_clk_en,
   output reg                  prbs_gen_oclk_clk_en,
   output reg                  complex_sample_cnt_inc,
   output reg                  complex_sample_cnt_inc_ocal,
   output reg                  complex_wr_done,

   // Signals shared btw multiple calibration stages
   output reg                  prech_done,
   // Data select / status
   output reg                  init_calib_complete, 
   // Signal to mask memory model error for Invalid latching edge
   output reg                  calib_writes, 
   // PHY address/control
   // 2 commands to PHY Control Block per div 2 clock in 2:1 mode
   // 4 commands to PHY Control Block per div 4 clock in 4:1 mode
   output reg [nCK_PER_CLK*ROW_WIDTH-1:0] phy_address,
   output reg [nCK_PER_CLK*BANK_WIDTH-1:0]phy_bank,
   output reg [nCK_PER_CLK-1:0] phy_ras_n,
   output reg [nCK_PER_CLK-1:0] phy_cas_n,
   output reg [nCK_PER_CLK-1:0] phy_we_n,
   output reg                   phy_reset_n,
   output [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0]   phy_cs_n,

   // Hard PHY Interface signals
   input                       phy_ctl_ready,
   input                       phy_ctl_full,
   input                       phy_cmd_full,
   input                       phy_data_full,
   output reg                  calib_ctl_wren,
   output reg                  calib_cmd_wren,
   output reg [1:0]            calib_seq,
   output reg                  write_calib,
   output reg                  read_calib,
   // PHY_Ctl_Wd
   output reg [2:0]            calib_cmd,
   // calib_aux_out used for CKE and ODT
   output reg [3:0]            calib_aux_out,
   output reg [1:0]            calib_odt ,
   output reg [nCK_PER_CLK-1:0]            calib_cke ,
   output [1:0]                calib_rank_cnt,
   output reg [1:0]            calib_cas_slot,
   output reg [5:0]            calib_data_offset_0,
   output reg [5:0]            calib_data_offset_1,
   output reg [5:0]            calib_data_offset_2,
   // PHY OUT_FIFO
   output reg                  calib_wrdata_en,
   output reg [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_wrdata,
   // PHY Read
   output                      phy_rddata_en,
   output                      phy_rddata_valid,
   output [255:0]              dbg_phy_init,
   input                       reset_rd_addr,
   //OCAL centering calibration
   input                       oclkdelay_center_calib_start,
   input                       oclk_center_write_resume,
   input                       oclkdelay_center_calib_done,
   input                       rdlvl_pi_incdec,     //rdlvl pi dec   
   input                       complex_pi_incdec_done,
   input                       num_samples_done_r,
   input                       complex_init_pi_dec_done,
   output reg                  complex_act_start,
   output reg                  calib_tap_inc_start,
   output reg                  calib_tap_end_if_reset,
   input                       calib_tap_inc_done
   );

//*****************************************************************************
// Assertions to be added
//*****************************************************************************   
// The phy_ctl_full signal must never be asserted in synchronous mode of 
// operation either 4:1 or 2:1
//
// The RANKS parameter must never be set to '0' by the user 
// valid values: 1 to 4
//
//*****************************************************************************

  //***************************************************************************
  
  // Number of Read level stage 1 writes limited to a SDRAM row
  // The address of Read Level stage 1 reads must also be limited
  // to a single SDRAM row
  // (2^COL_WIDTH)/BURST_MODE = (2^10)/8 = 128
  localparam NUM_STG1_WR_RD = (BURST_MODE == "8") ? 4 :
                              (BURST_MODE == "4") ? 8 : 4;  


  localparam ADDR_INC = (BURST_MODE == "8") ? 8 :
                        (BURST_MODE == "4") ? 4 : 8; 
 
  // In a 2 slot dual rank per system RTT_NOM values 
  // for Rank2 and Rank3 default to 40 ohms
  localparam RTT_NOM2 = "40";
  localparam RTT_NOM3 = "40";

  localparam RTT_NOM_int = (USE_ODT_PORT == 1) ? RTT_NOM : RTT_WR;

  // Specifically for use with half-frequency controller (nCK_PER_CLK=2)
  // = 1 if burst length = 4, = 0 if burst length = 8. Determines how
  // often row command needs to be issued during read-leveling
  // For DDR3 the burst length is fixed during calibration 
  localparam BURST4_FLAG = (DRAM_TYPE == "DDR3")? 1'b0 : 
             (BURST_MODE == "8") ? 1'b0 : 
             ((BURST_MODE == "4") ? 1'b1 : 1'b0);
             



  //***************************************************************************
  // Counter values used to determine bus timing
  // NOTE on all counter terminal counts - these can/should be one less than 
  //   the actual delay to take into account extra clock cycle delay in 
  //   generating the corresponding "done" signal
  //***************************************************************************

  localparam CLK_MEM_PERIOD = CLK_PERIOD / nCK_PER_CLK;
  
  // Calculate initial delay required in number of CLK clock cycles
  // to delay initially. The counter is clocked by [CLK/1024] - which
  // is approximately division by 1000 - note that the formulas below will
  // result in more than the minimum wait time because of this approximation.
  // NOTE: For DDR3 JEDEC specifies to delay reset
  //       by 200us, and CKE by an additional 500us after power-up
  //       For DDR2 CKE is delayed by 200us after power up.
  localparam DDR3_RESET_DELAY_NS   = 200000;
  localparam DDR3_CKE_DELAY_NS     = 500000 + DDR3_RESET_DELAY_NS;
  localparam DDR2_CKE_DELAY_NS     = 200000;
  localparam PWRON_RESET_DELAY_CNT = 
             ((DDR3_RESET_DELAY_NS+CLK_PERIOD-1)/CLK_PERIOD);
  localparam PWRON_CKE_DELAY_CNT   = (DRAM_TYPE == "DDR3") ?
             (((DDR3_CKE_DELAY_NS+CLK_PERIOD-1)/CLK_PERIOD)) :
             (((DDR2_CKE_DELAY_NS+CLK_PERIOD-1)/CLK_PERIOD));
              // FOR DDR2 -1 taken out. With -1 not getting 200us. The equation
              // needs to be reworked. 
   localparam DDR2_INIT_PRE_DELAY_PS = 400000;
   localparam DDR2_INIT_PRE_CNT = 
              ((DDR2_INIT_PRE_DELAY_PS+CLK_PERIOD-1)/CLK_PERIOD)-1;
   
  // Calculate tXPR time: reset from CKE HIGH to valid command after power-up
  // tXPR = (max(5nCK, tRFC(min)+10ns). Add a few (blah, messy) more clock
  // cycles because this counter actually starts up before CKE is asserted
  // to memory.
  localparam TXPR_DELAY_CNT =
             (5*CLK_MEM_PERIOD > tRFC+10000) ?
             (((5+nCK_PER_CLK-1)/nCK_PER_CLK)-1)+11 :
             (((tRFC+10000+CLK_PERIOD-1)/CLK_PERIOD)-1)+11;

  // tDLLK/tZQINIT time = 512*tCK = 256*tCLKDIV
  localparam TDLLK_TZQINIT_DELAY_CNT = 255;
  
  // TWR values in ns. Both DDR2 and DDR3 have the same value.
  // 15000ns/tCK
  localparam TWR_CYC = ((15000) %  CLK_MEM_PERIOD) ?
                       (15000/CLK_MEM_PERIOD) + 1 : 15000/CLK_MEM_PERIOD;
  
  // time to wait between consecutive commands in PHY_INIT - this is a
  // generic number, and must be large enough to account for worst case
  // timing parameter (tRFC - refresh-to-active) across all memory speed
  // grades and operating frequencies. Expressed in clk 
  // (Divided by 4 or Divided by 2) clock cycles. 
  localparam  CNTNEXT_CMD = 7'b1111111;
  
  // Counter values to keep track of which MR register to load during init
  // Set value of INIT_CNT_MR_DONE to equal value of counter for last mode
  // register configured during initialization. 
  // NOTE: Reserve more bits for DDR2 - more MR accesses for DDR2 init
  localparam  INIT_CNT_MR2     = 2'b00;
  localparam  INIT_CNT_MR3     = 2'b01;
  localparam  INIT_CNT_MR1     = 2'b10;
  localparam  INIT_CNT_MR0     = 2'b11;
  localparam  INIT_CNT_MR_DONE = 2'b11;

  // Register chip programmable values for DDR3
  // The register chip for the registered DIMM needs to be programmed
  // before the initialization of the registered DIMM.
  // Address for the control word is in : DBA2, DA2, DA1, DA0
  // Data for the control word is in: DBA1 DBA0, DA4, DA3
  // The values will be stored in the local param in the following format
  // {DBA[2:0], DA[4:0]}
  
  // RC0 is global features control word. Address == 000

  localparam  REG_RC0 = 8'b00000000;
  
  // RC1 Clock driver enable control word. Enables or disables the four
  // output clocks in the register chip. For single rank and dual rank
  // two clocks will be enabled and for quad rank all the four clocks
  // will be enabled. Address == 000. Data = 0110 for single and dual rank.
  // = 0000 for quad rank 
  localparam REG_RC1 = 8'b00000001;

  // RC2 timing control word. Set in 1T timing mode
  // Address = 010. Data = 0000
  localparam REG_RC2 = 8'b00000010;
   
  // RC3 timing control word. Setting the data based on number of RANKS (inturn the number of loads)
  // This setting is specific to RDIMMs from Micron Technology
  localparam REG_RC3 = (RANKS >= 2) ? 8'b00101011 : 8'b00000011;

  // RC4 timing control work. Setting the data based on number of RANKS (inturn the number of loads)
  // This setting is specific to RDIMMs from Micron Technology
  localparam REG_RC4 = (RANKS >= 2) ? 8'b00101100 : 8'b00000100;
    
  // RC5 timing control work. Setting the data based on number of RANKS (inturn the number of loads)
  // This setting is specific to RDIMMs from Micron Technology
  localparam REG_RC5 = (RANKS >= 2) ? 8'b00101101 : 8'b00000101;   
  
  // RC10 timing control work. Setting the data to 0000 
  localparam [3:0] FREQUENCY_ENCODING = (tCK >= 1072 && tCK < 1250) ? 4'b0100 : 
                                        (tCK >= 1250 && tCK < 1500) ? 4'b0011 :
                                        (tCK >= 1500 && tCK < 1875) ? 4'b0010 :
                                        (tCK >= 1875 && tCK < 2500) ? 4'b0001 : 4'b0000;

  localparam REG_RC10 = {1'b1,FREQUENCY_ENCODING,3'b010};   

  localparam VREF_ENCODING = (VREF == "INTERNAL") ? 1'b1 : 1'b0;
  localparam [3:0] DDR3_VOLTAGE_ENCODING = (DDR3_VDD_OP_VOLT == "125") ? {1'b0,VREF_ENCODING,2'b10} :
                                           (DDR3_VDD_OP_VOLT == "135") ? {1'b0,VREF_ENCODING,2'b01} : 
                                                                         {1'b0,VREF_ENCODING,2'b00} ;

  localparam REG_RC11 = {1'b1,DDR3_VOLTAGE_ENCODING,3'b011};

  // For non-zero AL values
  localparam nAL = (AL == "CL-1") ? nCL - 1 : 0;   

  // Adding the register dimm latency to write latency
  localparam CWL_M = (REG_CTRL == "ON") ? nCWL + nAL + 1 : nCWL + nAL;

  // Count value to generate pi_phase_locked_err signal
  localparam PHASELOCKED_TIMEOUT = (SIM_CAL_OPTION == "NONE") ? 16383 : 1000; 

  // Timeout interval for detecting error with Traffic Generator
  localparam [13:0] TG_TIMER_TIMEOUT 
                    = (SIM_CAL_OPTION == "NONE") ? 14'h3FFF : 14'h0001;
  
  //bit num per DQS
  localparam DQ_PER_DQS = DQ_WIDTH/DQS_WIDTH;

  //COMPLEX_ROW_CNT_BYTE
  localparam COMPLEX_ROW_CNT_BYTE = (FIXED_VICTIM=="FALSE")? DQ_PER_DQS*2: 2;
  localparam COMPLEX_RD = (FIXED_VICTIM=="FALSE")? DQ_PER_DQS : 1; 
  
  // Master state machine encoding
  localparam  INIT_IDLE                     = 7'b0000000; //0
  localparam  INIT_WAIT_CKE_EXIT            = 7'b0000001; //1
  localparam  INIT_LOAD_MR                  = 7'b0000010; //2
  localparam  INIT_LOAD_MR_WAIT             = 7'b0000011; //3
  localparam  INIT_ZQCL                     = 7'b0000100; //4
  localparam  INIT_WAIT_DLLK_ZQINIT         = 7'b0000101; //5
  localparam  INIT_WRLVL_START              = 7'b0000110; //6
  localparam  INIT_WRLVL_WAIT               = 7'b0000111; //7
  localparam  INIT_WRLVL_LOAD_MR            = 7'b0001000; //8
  localparam  INIT_WRLVL_LOAD_MR_WAIT       = 7'b0001001; //9
  localparam  INIT_WRLVL_LOAD_MR2           = 7'b0001010; //A
  localparam  INIT_WRLVL_LOAD_MR2_WAIT      = 7'b0001011; //B
  localparam  INIT_RDLVL_ACT                = 7'b0001100; //C
  localparam  INIT_RDLVL_ACT_WAIT           = 7'b0001101; //D
  localparam  INIT_RDLVL_STG1_WRITE         = 7'b0001110; //E
  localparam  INIT_RDLVL_STG1_WRITE_READ    = 7'b0001111; //F
  localparam  INIT_RDLVL_STG1_READ          = 7'b0010000; //10
  localparam  INIT_RDLVL_STG2_READ          = 7'b0010001; //11
  localparam  INIT_RDLVL_STG2_READ_WAIT     = 7'b0010010; //12
  localparam  INIT_PRECHARGE_PREWAIT        = 7'b0010011; //13
  localparam  INIT_PRECHARGE                = 7'b0010100; //14
  localparam  INIT_PRECHARGE_WAIT           = 7'b0010101; //15
  localparam  INIT_DONE                     = 7'b0010110; //16
  localparam  INIT_DDR2_PRECHARGE           = 7'b0010111; //17
  localparam  INIT_DDR2_PRECHARGE_WAIT      = 7'b0011000; //18
  localparam  INIT_REFRESH                  = 7'b0011001; //19
  localparam  INIT_REFRESH_WAIT             = 7'b0011010; //1A
  localparam  INIT_REG_WRITE                = 7'b0011011; //1B
  localparam  INIT_REG_WRITE_WAIT           = 7'b0011100; //1C
  localparam  INIT_DDR2_MULTI_RANK          = 7'b0011101; //1D
  localparam  INIT_DDR2_MULTI_RANK_WAIT     = 7'b0011110; //1E
  localparam  INIT_WRCAL_ACT                = 7'b0011111; //1F
  localparam  INIT_WRCAL_ACT_WAIT           = 7'b0100000; //20
  localparam  INIT_WRCAL_WRITE              = 7'b0100001; //21
  localparam  INIT_WRCAL_WRITE_READ         = 7'b0100010; //22
  localparam  INIT_WRCAL_READ               = 7'b0100011; //23
  localparam  INIT_WRCAL_READ_WAIT          = 7'b0100100; //24
  localparam  INIT_WRCAL_MULT_READS         = 7'b0100101; //25
  localparam  INIT_PI_PHASELOCK_READS       = 7'b0100110; //26
  localparam  INIT_MPR_RDEN                 = 7'b0100111; //27
  localparam  INIT_MPR_WAIT                 = 7'b0101000; //28
  localparam  INIT_MPR_READ                 = 7'b0101001; //29
  localparam  INIT_MPR_DISABLE_PREWAIT      = 7'b0101010; //2A
  localparam  INIT_MPR_DISABLE              = 7'b0101011; //2B
  localparam  INIT_MPR_DISABLE_WAIT         = 7'b0101100; //2C
  localparam  INIT_OCLKDELAY_ACT            = 7'b0101101; //2D
  localparam  INIT_OCLKDELAY_ACT_WAIT       = 7'b0101110; //2E
  localparam  INIT_OCLKDELAY_WRITE          = 7'b0101111; //2F
  localparam  INIT_OCLKDELAY_WRITE_WAIT     = 7'b0110000; //30
  localparam  INIT_OCLKDELAY_READ           = 7'b0110001; //31
  localparam  INIT_OCLKDELAY_READ_WAIT      = 7'b0110010; //32
  localparam  INIT_REFRESH_RNK2_WAIT        = 7'b0110011; //33
  localparam  INIT_RDLVL_COMPLEX_PRECHARGE         = 7'b0110100; //34
  localparam  INIT_RDLVL_COMPLEX_PRECHARGE_WAIT    = 7'b0110101; //35
  localparam  INIT_RDLVL_COMPLEX_ACT               = 7'b0110110; //36
  localparam  INIT_RDLVL_COMPLEX_ACT_WAIT          = 7'b0110111; //37
  localparam  INIT_RDLVL_COMPLEX_READ              = 7'b0111000; //38
  localparam  INIT_RDLVL_COMPLEX_READ_WAIT         = 7'b0111001; //39
  localparam  INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT = 7'b0111010; //3A
  localparam  INIT_OCAL_COMPLEX_ACT                = 7'b0111011; //3B
  localparam  INIT_OCAL_COMPLEX_ACT_WAIT           = 7'b0111100; //3C
  localparam  INIT_OCAL_COMPLEX_WRITE_WAIT         = 7'b0111101; //3D 
  localparam  INIT_OCAL_COMPLEX_RESUME_WAIT        = 7'b0111110; //3E 
  localparam  INIT_OCAL_CENTER_ACT                 = 7'b0111111; //3F 
  localparam  INIT_OCAL_CENTER_WRITE               = 7'b1000000; //40
  localparam  INIT_OCAL_CENTER_WRITE_WAIT          = 7'b1000001; //41
  localparam  INIT_OCAL_CENTER_ACT_WAIT            = 7'b1000010; //42 
  localparam  INIT_RDLVL_COMPLEX_PI_WAIT           = 7'b1000011; //43
  localparam  INIT_SKIP_CALIB_WAIT                 = 7'b1000100; //44 

  integer i, j, k, l, m, n, p, q;

  reg                 pi_dqs_found_all_r;
  (* ASYNC_REG = "TRUE" *) reg pi_phase_locked_all_r1;
  (* ASYNC_REG = "TRUE" *) reg pi_phase_locked_all_r2;
  (* ASYNC_REG = "TRUE" *) reg pi_phase_locked_all_r3;
  (* ASYNC_REG = "TRUE" *) reg pi_phase_locked_all_r4;
  reg                 pi_calib_rank_done_r;
  reg [13:0]          pi_phaselock_timer;
  reg                 stg1_wr_done;
  reg                 rnk_ref_cnt;
  reg                 pi_dqs_found_done_r1;
  reg                 pi_dqs_found_rank_done_r;
  reg                 read_calib_int;
  reg                 read_calib_r;
  reg                 pi_calib_done_r;
  reg                 pi_calib_done_r1;
  reg                 burst_addr_r;  
  reg [1:0]           chip_cnt_r;
  reg [6:0]           cnt_cmd_r;
  reg                 cnt_cmd_done_r;  
  reg                 cnt_cmd_done_m7_r;
  reg [7:0]           cnt_dllk_zqinit_r;
  reg                 cnt_dllk_zqinit_done_r;
  reg                 cnt_init_af_done_r;  
  reg [1:0]           cnt_init_af_r;
  reg [1:0]           cnt_init_data_r;  
  reg [1:0]           cnt_init_mr_r;
  reg                 cnt_init_mr_done_r;
  reg                 cnt_init_pre_wait_done_r;
  reg [7:0]           cnt_init_pre_wait_r; 
  reg [9:0]           cnt_pwron_ce_r;  
  reg                 cnt_pwron_cke_done_r;
  reg                 cnt_pwron_cke_done_r1;  
  reg [8:0]           cnt_pwron_r;  
  reg                 cnt_pwron_reset_done_r; 
  reg                 cnt_txpr_done_r;  
  reg [7:0]           cnt_txpr_r;
  reg                 ddr2_pre_flag_r;
  reg                 ddr2_refresh_flag_r;
  reg                 ddr3_lm_done_r;
  reg [4:0]           enable_wrlvl_cnt;
  reg                 init_complete_r;
  reg                 init_complete_r1;
  reg                 init_complete_r2;
(* keep = "true" *)  reg                 init_complete_r_timing;
(* keep = "true" *)  reg                 init_complete_r1_timing;
  reg [6:0]           init_next_state;  
  reg [6:0]           init_state_r;
  reg [6:0]           init_state_r1;
  wire [15:0]         load_mr0;
  wire [15:0]         load_mr1;
  wire [15:0]         load_mr2;
  wire [15:0]         load_mr3;
  reg                 mem_init_done_r;
  reg [1:0]           mr2_r [0:3];
  reg [2:0]           mr1_r [0:3];
  reg                 new_burst_r;
  reg [15:0]          wrcal_start_dly_r;
  wire                wrcal_start_pre;
  reg                 wrcal_resume_r;
  // Only one ODT signal per rank in PHY Control Block
  reg [nCK_PER_CLK-1:0] phy_tmp_odt_r;
  reg [nCK_PER_CLK-1:0] phy_tmp_odt_r1;
  
  reg [CS_WIDTH*nCS_PER_RANK-1:0]   phy_tmp_cs1_r;
  reg [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0]   phy_int_cs_n;
  wire        prech_done_pre;
  reg [15:0]  prech_done_dly_r;  
  reg         prech_pending_r;
  reg         prech_req_posedge_r;  
  reg         prech_req_r;    
  reg         pwron_ce_r;
  reg         first_rdlvl_pat_r;
  reg         first_wrcal_pat_r;
  reg         phy_wrdata_en;
  reg         phy_wrdata_en_r1;
  reg [1:0]   wrdata_pat_cnt;
  reg [1:0]   wrcal_pat_cnt;
  reg [ROW_WIDTH-1:0] address_w;
  reg [BANK_WIDTH-1:0] bank_w;
  reg         rdlvl_stg1_done_r1;
  reg         rdlvl_stg1_start_int;
  reg [15:0]  rdlvl_start_dly0_r;
  reg         rdlvl_start_pre;
  reg         rdlvl_last_byte_done_r;
  wire        rdlvl_rd;
  wire        rdlvl_wr;
  reg         rdlvl_wr_r;
  wire        rdlvl_wr_rd;
  reg [3:0]   reg_ctrl_cnt_r;
  reg [1:0]   tmp_mr2_r [0:3];
  reg [2:0]   tmp_mr1_r [0:3];
  reg         wrlvl_done_r;
  reg         wrlvl_done_r1;
  reg         wrlvl_rank_done_r1;
  reg         wrlvl_rank_done_r2;
  reg         wrlvl_rank_done_r3;
  reg         wrlvl_rank_done_r4;
  reg         wrlvl_rank_done_r5;
  reg         wrlvl_rank_done_r6;
  reg         wrlvl_rank_done_r7;
  reg [2:0]   wrlvl_rank_cntr;
  reg         wrlvl_odt_ctl;
  reg         wrlvl_odt;
  reg         wrlvl_active;
  reg         wrlvl_active_r1;
  reg [2:0]   num_reads;
  reg         temp_wrcal_done_r;
  reg         temp_lmr_done;
  reg         extend_cal_pat;
  reg [13:0]  tg_timer;
  reg         tg_timer_go;
  reg         cnt_wrcal_rd;
  reg [3:0]   cnt_wait;
  reg [7:0]   wrcal_reads;
  reg [8:0]   stg1_wr_rd_cnt;
  reg         phy_data_full_r;
  reg         wr_level_dqs_asrt;
  reg         wr_level_dqs_asrt_r1;
  reg [1:0]   dqs_asrt_cnt;


  reg [3:0]  num_refresh;
  wire       oclkdelay_calib_start_pre;
  reg [15:0] oclkdelay_start_dly_r;
  reg [3:0]  oclk_wr_cnt;
  reg [3:0]  wrcal_wr_cnt;
  reg        wrlvl_final_r;

  
  reg        prbs_rdlvl_done_r1;
  reg        prbs_rdlvl_done_r2;
  reg        prbs_rdlvl_done_r3;
  reg        prbs_last_byte_done_r;
  reg        phy_if_empty_r;
  reg        prbs_pat_resume_int;
  reg        complex_row0_wr_done;
  reg        complex_row1_wr_done;
  reg        complex_row0_rd_done;
  reg        complex_row1_rd_done;
  reg        complex_row0_rd_done_r1;
  reg [3:0]  complex_wait_cnt;
  reg [3:0]  complex_num_reads;
  reg [3:0]  complex_num_reads_dec;
  reg [ROW_WIDTH-1:0] complex_address;
  reg        wr_victim_inc;
  reg [2:0]  wr_victim_sel;
  reg [7:0]  complex_row_cnt;

  reg        complex_sample_cnt_inc_r1;
  reg        complex_sample_cnt_inc_r2;
  reg        complex_odt_ext;
  reg        complex_ocal_odt_ext;

  reg        wrcal_final_chk;
  wire       prech_req;

  reg        reset_rd_addr_r1;
  reg        complex_rdlvl_int_ref_req;
  reg        ext_int_ref_req;

  //complex OCLK delay calibration
  reg [7:0]  complex_row_cnt_ocal;
  reg [4:0]  complex_num_writes;
  reg [4:0]  complex_num_writes_dec;
  reg        complex_oclkdelay_calib_start_int;  
  reg        complex_oclkdelay_calib_start_r1;
  reg        complex_oclkdelay_calib_start_r2;  
  reg        complex_oclkdelay_calib_done_r1;
 // reg [DQS_CNT_WIDTH:0] wr_byte_cnt_ocal;
  reg [2:0]  wr_victim_sel_ocal;
  
  reg        complex_row1_rd_done_r1;     //time for switch to write
  reg [2:0]  complex_row1_rd_cnt;         //row1 read number for the byte (8 (16 rows) row1)
  reg        complex_byte_rd_done;        //read for the byte is done
  reg        complex_byte_rd_done_r1;    
 // reg        complex_row_change;          //every 16 rows of read, it is set to "0" for write
  reg        ocal_num_samples_inc;         //1 read/write is done
  reg        complex_ocal_wr_start;       //indicate complex ocal write is started. used for prbs rd addr gen

  reg        prbs_rdlvl_done_pulse;       //rising edge for prbs_rdlvl_done. used for pipelining
  reg        prech_done_r1, prech_done_r2, prech_done_r3;
  reg        mask_lim_done;
  reg        complex_mask_lim_done;
  reg                           oclkdelay_calib_start_int;
  reg [REFRESH_TIMER_WIDTH-1:0] oclkdelay_ref_cnt;
  reg                           oclkdelay_int_ref_req;
  reg [3:0]                     ocal_act_wait_cnt;
  reg                           oclk_calib_resume_level;
  reg                           ocal_last_byte_done;
  wire       mmcm_wr;                         //MMCM centering write. no CS will be set

  wire       exit_ocal_complex_resume_wait = 
             init_state_r == INIT_OCAL_COMPLEX_RESUME_WAIT  && complex_oclk_calib_resume;

  reg calib_tap_inc_done_r1;


  
  //***************************************************************************
  // Debug
  //***************************************************************************

  //synthesis translate_off
  always @(posedge mem_init_done_r) begin 
    if (!rst)
      $display ("PHY_INIT: Memory Initialization completed at %t", $time);
  end

  always @(posedge wrlvl_done) begin
    if (!rst && (WRLVL == "ON"))
      $display ("PHY_INIT: Write Leveling completed at %t", $time);
  end

  always @(posedge rdlvl_stg1_done) begin
    if (!rst) 
      $display ("PHY_INIT: Read Leveling Stage 1 completed at %t", $time);
  end
  
  always @(posedge mpr_rdlvl_done) begin
    if (!rst) 
      $display ("PHY_INIT: MPR Read Leveling completed at %t", $time);
  end
  
  always @(posedge oclkdelay_calib_done) begin
    if (!rst) 
      $display ("PHY_INIT: OCLKDELAY calibration completed at %t", $time);
  end

  always @(posedge pi_calib_done_r1) begin
    if (!rst) 
      $display ("PHY_INIT: Phaser_In Phase Locked at %t", $time);
  end
  
  always @(posedge pi_dqs_found_done) begin
    if (!rst) 
      $display ("PHY_INIT: Phaser_In DQSFOUND completed at %t", $time);
  end

  always @(posedge wrcal_done) begin
    if (!rst && (WRLVL == "ON"))
      $display ("PHY_INIT: Write Calibration completed at %t", $time);
  end    

  always@(posedge prbs_rdlvl_done)begin
    if(!rst)
    	$display("PHY_INIT : PRBS/PER_BIT calibration completed at %t",$time);
  end 


  always@(posedge complex_oclkdelay_calib_done)begin
    if(!rst)
    	$display("PHY_INIT : COMPLEX OCLKDELAY calibration completed at %t",$time);
  end 
  always@(posedge oclkdelay_center_calib_done)begin
    if(!rst)
    	$display("PHY_INIT : OCLKDELAY CENTER CALIB calibration completed at %t",$time);
  end 
   
  //synthesis translate_on

  assign dbg_phy_init[5:0] = init_state_r;
  assign dbg_phy_init[6+:8] = complex_row_cnt;
  assign dbg_phy_init[14+:3] = victim_sel;
  assign dbg_phy_init[17+:4] = victim_byte_cnt;
  assign dbg_phy_init[21+:9] = stg1_wr_rd_cnt[8:0]; 
  assign dbg_phy_init[30+:15]  = complex_address;
  assign dbg_phy_init[(30+15)+:15]  = phy_address[14:0];
  assign dbg_phy_init[60]  =prbs_rdlvl_prech_req ;
  assign dbg_phy_init[61]  =prech_req_posedge_r ;


  //***************************************************************************
  // DQS count to be sent to hard PHY during Phaser_IN Phase Locking stage
  //***************************************************************************
  
//  assign pi_phaselock_calib_cnt = dqs_cnt_r;
  
  assign pi_calib_done = pi_calib_done_r1;
  
  //prevent PI incdec during complex read
  always @ (posedge clk) 
    complex_act_start <= #TCQ (init_state_r == INIT_RDLVL_COMPLEX_ACT) || (init_state_r == INIT_RDLVL_COMPLEX_PI_WAIT);

  //detect rising edge of prbs_rdlvl_done to reset all control sighals
  always @ (posedge clk) begin
    prbs_rdlvl_done_pulse <= #TCQ prbs_rdlvl_done & ~prbs_rdlvl_done_r1;
  end
  
  always @(posedge clk) begin
    if (rst)
      wrcal_final_chk <= #TCQ 1'b0;
    else if ((init_next_state == INIT_WRCAL_ACT) && (wrcal_done || (SKIP_CALIB == "TRUE")) && 
             (DRAM_TYPE == "DDR3"))
      wrcal_final_chk <= #TCQ 1'b1;
  end

  always @(posedge clk) begin
    rdlvl_stg1_done_r1      <= #TCQ rdlvl_stg1_done;
    prbs_rdlvl_done_r1      <= #TCQ prbs_rdlvl_done;
	prbs_rdlvl_done_r2      <= #TCQ prbs_rdlvl_done_r1;
	prbs_rdlvl_done_r3      <= #TCQ prbs_rdlvl_done_r2;
    wrcal_resume_r          <= #TCQ wrcal_resume;
    wrcal_sanity_chk        <= #TCQ wrcal_final_chk;
  end
  
  always @(posedge clk) begin
    if (rst)
      mpr_end_if_reset <= #TCQ 1'b0;
    else if (mpr_last_byte_done && (num_refresh != 'd0))
      mpr_end_if_reset <= #TCQ 1'b1;
    else
      mpr_end_if_reset <= #TCQ 1'b0;
  end
  
  // Siganl to mask memory model error for Invalid latching edge

  always @(posedge clk)
    if (rst)
      calib_writes <= #TCQ 1'b0;
    else if ((init_state_r == INIT_OCLKDELAY_WRITE) || 
             (init_state_r == INIT_OCAL_CENTER_WRITE) || 
             (init_state_r == INIT_RDLVL_STG1_WRITE) ||
             (init_state_r == INIT_RDLVL_STG1_WRITE_READ) ||
             (init_state_r == INIT_WRCAL_WRITE) ||
             (init_state_r == INIT_WRCAL_WRITE_READ))
      calib_writes <= #TCQ 1'b1;
    else
      calib_writes <= #TCQ 1'b0;

  always @(posedge clk)
    if (rst)
      wrcal_rd_wait <= #TCQ 1'b0;
    else if (init_state_r == INIT_WRCAL_READ_WAIT)
      wrcal_rd_wait <= #TCQ 1'b1;
    else
      wrcal_rd_wait <= #TCQ 1'b0;
  
  //***************************************************************************
  // Signal PHY completion when calibration is finished
  // Signal assertion is delayed by four clock cycles to account for the
  // multi cycle path constraint to (phy_init_data_sel) signal. 
  //***************************************************************************
  
  always @(posedge clk)
    if (rst) begin
      init_complete_r     <= #TCQ 1'b0;
      init_complete_r_timing <= #TCQ 1'b0;
      init_complete_r1    <= #TCQ 1'b0;
      init_complete_r1_timing <= #TCQ 1'b0; 
      init_complete_r2    <= #TCQ 1'b0;
      init_calib_complete <= #TCQ 1'b0;
    end else begin
      if (init_state_r == INIT_DONE) begin
        init_complete_r   <= #TCQ 1'b1;
        init_complete_r_timing <= #TCQ 1'b1;
      end
      init_complete_r1    <= #TCQ init_complete_r;
      init_complete_r1_timing <= #TCQ init_complete_r_timing; 
      init_complete_r2    <= #TCQ init_complete_r1; 
      init_calib_complete <= #TCQ init_complete_r2;
    end 

  always @ (posedge clk)
    if (rst) 
      complex_oclkdelay_calib_done_r1 <= #TCQ 1'b0;
    else
      complex_oclkdelay_calib_done_r1 <= #TCQ complex_oclkdelay_calib_done;

  //reset read address for starting complex ocaldealy calib      
  always @ (posedge clk) begin
    complex_ocal_reset_rd_addr <= #TCQ ((init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) && (complex_wait_cnt == 'd9)) || (prbs_last_byte_done && ~prbs_last_byte_done_r);
    
  end

  //first write for complex oclkdealy calib
  always @ (posedge clk) begin
    if (rst)
      complex_ocal_wr_start <= #TCQ 'b0;
    else
      complex_ocal_wr_start <= #TCQ complex_ocal_reset_rd_addr? 1'b1 : complex_ocal_wr_start;
  end

  //ocal stg3 centering start
//  always @ (posedge clk) 
//    if(rst) oclkdelay_center_calib_start <= #TCQ 1'b0;
//    else
//      oclkdelay_center_calib_start <= #TCQ ((init_state_r == INIT_OCAL_CENTER_ACT) && lim_done)? 1'b1: oclkdelay_center_calib_start;
    
  //***************************************************************************
  // Instantiate FF for the phy_init_data_sel signal. A multi cycle path 
  // constraint will be assigned to this signal. This signal will only be 
  // used within the PHY 
  //***************************************************************************

//  FDRSE u_ff_phy_init_data_sel
//    (
//     .Q   (phy_init_data_sel),
//     .C   (clk),
//     .CE  (1'b1),
//     .D   (init_complete_r),
//     .R   (1'b0),
//     .S   (1'b0)
//     ) /* synthesis syn_preserve=1 */
//       /* synthesis syn_replicate = 0 */;

  
  //***************************************************************************
  // Mode register programming
  //***************************************************************************
  
  //*****************************************************************
  // DDR3 Load mode reg0
  // Mode Register (MR0):
  //   [15:13]   - unused          - 000
  //   [12]      - Precharge Power-down DLL usage - 0 (DLL frozen, slow-exit), 
  //               1 (DLL maintained)
  //   [11:9]    - write recovery for Auto Precharge (tWR/tCK = 6)
  //   [8]       - DLL reset       - 0 or 1
  //   [7]       - Test Mode       - 0 (normal)
  //   [6:4],[2] - CAS latency     - CAS_LAT
  //   [3]       - Burst Type      - BURST_TYPE
  //   [1:0]     - Burst Length    - BURST_LEN
  // DDR2 Load mode register
  // Mode Register (MR):
  //   [15:14] - unused          - 00
  //   [13]    - reserved        - 0
  //   [12]    - Power-down mode - 0 (normal)
  //   [11:9]  - write recovery  - write recovery for Auto Precharge
  //                               (tWR/tCK = 6)
  //   [8]     - DLL reset       - 0 or 1
  //   [7]     - Test Mode       - 0 (normal)
  //   [6:4]   - CAS latency     - CAS_LAT
  //   [3]     - Burst Type      - BURST_TYPE
  //   [2:0]   - Burst Length    - BURST_LEN
                          
  //*****************************************************************
  generate
    if(DRAM_TYPE == "DDR3") begin: gen_load_mr0_DDR3
      assign load_mr0[1:0]   = (BURST_MODE == "8")   ? 2'b00 :
                               (BURST_MODE == "OTF") ? 2'b01 : 
                               (BURST_MODE == "4")   ? 2'b10 : 2'b11;
      assign load_mr0[2]     = (nCL >= 12) ? 1'b1 : 1'b0;   // LSb of CAS latency
      assign load_mr0[3]     = (BURST_TYPE == "SEQ") ? 1'b0 : 1'b1;
      assign load_mr0[6:4]   = ((nCL == 5) || (nCL == 13))  ? 3'b001 :
                               ((nCL == 6) || (nCL == 14))  ? 3'b010 : 
                               (nCL == 7)  ? 3'b011 : 
                               (nCL == 8)  ? 3'b100 :
                               (nCL == 9)  ? 3'b101 :
                               (nCL == 10) ? 3'b110 : 
                               (nCL == 11) ? 3'b111 :  
                               (nCL == 12) ? 3'b000 : 3'b111;
      assign load_mr0[7]     = 1'b0;
      assign load_mr0[8]     = 1'b1;   // Reset DLL (init only)    
      assign load_mr0[11:9]  = (TWR_CYC == 5)  ? 3'b001 :
                               (TWR_CYC == 6)  ? 3'b010 : 
                               (TWR_CYC == 7)  ? 3'b011 :
                               (TWR_CYC == 8)  ? 3'b100 :
                               (TWR_CYC == 9)  ? 3'b101 :
                               (TWR_CYC == 10)  ? 3'b101 :
                               (TWR_CYC == 11)  ? 3'b110 : 
                               (TWR_CYC == 12)  ? 3'b110 :
                               (TWR_CYC == 13)  ? 3'b111 :
                               (TWR_CYC == 14)  ? 3'b111 :
                               (TWR_CYC == 15)  ? 3'b000 :
                               (TWR_CYC == 16)  ? 3'b000 : 3'b010;
      assign load_mr0[12]    = 1'b0;   // Precharge Power-Down DLL 'slow-exit'
      assign load_mr0[15:13] = 3'b000;
    end else if (DRAM_TYPE == "DDR2") begin: gen_load_mr0_DDR2 // block: gen
      assign load_mr0[2:0]   = (BURST_MODE == "8")   ? 3'b011 :
                               (BURST_MODE == "4")   ? 3'b010 : 3'b111;
      assign load_mr0[3]     = (BURST_TYPE == "SEQ") ? 1'b0 : 1'b1;       
      assign load_mr0[6:4]   = (nCL == 3)  ? 3'b011 :
                               (nCL == 4)  ? 3'b100 :
                               (nCL == 5)  ? 3'b101 : 
                               (nCL == 6)  ? 3'b110 : 3'b111;
      assign load_mr0[7]     = 1'b0;
      assign load_mr0[8]     = 1'b1;   // Reset DLL (init only)
      assign load_mr0[11:9]  = (TWR_CYC == 2)  ? 3'b001 :
                               (TWR_CYC == 3)  ? 3'b010 :
                               (TWR_CYC == 4)  ? 3'b011 :
                               (TWR_CYC == 5)  ? 3'b100 : 
                               (TWR_CYC == 6)  ? 3'b101 : 3'b010;
      assign load_mr0[15:12]= 4'b0000; // Reserved
    end
  endgenerate
   
  //*****************************************************************
  // DDR3 Load mode reg1
  // Mode Register (MR1):
  //   [15:13] - unused          - 00
  //   [12]    - output enable   - 0 (enabled for DQ, DQS, DQS#)
  //   [11]    - TDQS enable     - 0 (TDQS disabled and DM enabled)
  //   [10]    - reserved   - 0 (must be '0')
  //   [9]     - RTT[2]     - 0 
  //   [8]     - reserved   - 0 (must be '0')
  //   [7]     - write leveling - 0 (disabled), 1 (enabled)
  //   [6]     - RTT[1]          - RTT[1:0] = 0(no ODT), 1(75), 2(150), 3(50)
  //   [5]     - Output driver impedance[1] - 0 (RZQ/6 and RZQ/7)
  //   [4:3]   - Additive CAS    - ADDITIVE_CAS
  //   [2]     - RTT[0]
  //   [1]     - Output driver impedance[0] - 0(RZQ/6), or 1 (RZQ/7)
  //   [0]     - DLL enable      - 0 (normal)
  // DDR2 ext mode register
  // Extended Mode Register (MR):
  //   [15:14] - unused          - 00
  //   [13]    - reserved        - 0
  //   [12]    - output enable   - 0 (enabled)
  //   [11]    - RDQS enable     - 0 (disabled)
  //   [10]    - DQS# enable     - 0 (enabled)
  //   [9:7]   - OCD Program     - 111 or 000 (first 111, then 000 during init)
  //   [6]     - RTT[1]          - RTT[1:0] = 0(no ODT), 1(75), 2(150), 3(50)
  //   [5:3]   - Additive CAS    - ADDITIVE_CAS
  //   [2]     - RTT[0]
  //   [1]     - Output drive    - REDUCE_DRV (= 0(full), = 1 (reduced)
  //   [0]     - DLL enable      - 0 (normal)
  //*****************************************************************
 
  generate
    if(DRAM_TYPE == "DDR3") begin: gen_load_mr1_DDR3
      assign load_mr1[0]     = 1'b0;   // DLL enabled during Imitialization
      assign load_mr1[1]     = (OUTPUT_DRV == "LOW") ? 1'b0 : 1'b1; 
      assign load_mr1[2]     = ((RTT_NOM_int == "30") || (RTT_NOM_int == "40") || 
                                (RTT_NOM_int == "60")) ? 1'b1 : 1'b0;
      assign load_mr1[4:3]   = (AL == "0")    ? 2'b00 :
                               (AL == "CL-1") ? 2'b01 :
                               (AL == "CL-2") ? 2'b10 : 2'b11;
      assign load_mr1[5]     = 1'b0; 
      assign load_mr1[6]     = ((RTT_NOM_int == "40") || (RTT_NOM_int == "120")) ? 
                               1'b1 : 1'b0;
      assign load_mr1[7]     = 1'b0;   // Enable write lvl after init sequence
      assign load_mr1[8]     = 1'b0;
      assign load_mr1[9]     = ((RTT_NOM_int == "20") || (RTT_NOM_int == "30")) ?
                                1'b1 : 1'b0;
      assign load_mr1[10]    = 1'b0;
      assign load_mr1[15:11] = 5'b00000;
    end else if (DRAM_TYPE == "DDR2") begin: gen_load_mr1_DDR2 
      assign load_mr1[0]     = 1'b0;   // DLL enabled during Imitialization
      assign load_mr1[1]     = (OUTPUT_DRV == "LOW") ? 1'b1 : 1'b0; 
      assign load_mr1[2]     = ((RTT_NOM_int == "75") || (RTT_NOM_int == "50")) ?
                                1'b1 : 1'b0;
      assign load_mr1[5:3]   = (AL == "0") ? 3'b000 :
                               (AL == "1") ? 3'b001 :
                               (AL == "2") ? 3'b010 :
                               (AL == "3") ? 3'b011 :
                               (AL == "4") ? 3'b100 : 3'b111;     
      assign load_mr1[6]     = ((RTT_NOM_int == "50") || 
                                (RTT_NOM_int == "150")) ? 1'b1 : 1'b0;
      assign load_mr1[9:7]   = 3'b000;
      assign load_mr1[10]    = (DDR2_DQSN_ENABLE == "YES") ? 1'b0 : 1'b1;
      assign load_mr1[15:11] = 5'b00000;

    end
  endgenerate

  //*****************************************************************
  // DDR3 Load mode reg2
  // Mode Register (MR2):
  //   [15:11] - unused     - 00
  //   [10:9]  - RTT_WR     - 00 (Dynamic ODT off) 
  //   [8]     - reserved   - 0 (must be '0')
  //   [7]     - self-refresh temperature range - 
  //               0 (normal), 1 (extended)
  //   [6]     - Auto Self-Refresh - 0 (manual), 1(auto)
  //   [5:3]   - CAS Write Latency (CWL) - 
  //               000 (5 for 400 MHz device), 
  //               001 (6 for 400 MHz to 533 MHz devices), 
  //               010 (7 for 533 MHz to 667 MHz devices), 
  //               011 (8 for 667 MHz to 800 MHz)
  //   [2:0]   - Partial Array Self-Refresh (Optional)      - 
  //               000 (full array)
  // Not used for DDR2 
  //*****************************************************************
  generate
    if(DRAM_TYPE == "DDR3") begin: gen_load_mr2_DDR3
      assign load_mr2[2:0]   = 3'b000; 
      assign load_mr2[5:3]   = (nCWL == 5) ? 3'b000 :
                               (nCWL == 6) ? 3'b001 : 
                               (nCWL == 7) ? 3'b010 : 
                               (nCWL == 8) ? 3'b011 : 
                               (nCWL == 9) ? 3'b100 :
                               (nCWL == 10) ? 3'b101 :
                               (nCWL == 11) ? 3'b110 : 3'b111;
      assign load_mr2[6]     = 1'b0;
      assign load_mr2[7]     = 1'b0;
      assign load_mr2[8]     = 1'b0;
                               // Dynamic ODT disabled
      assign load_mr2[10:9]  = 2'b00;
      assign load_mr2[15:11] = 5'b00000;
    end else begin: gen_load_mr2_DDR2
      assign load_mr2[15:0] = 16'd0;
    end
  endgenerate
   
  //*****************************************************************
  // DDR3 Load mode reg3
  // Mode Register (MR3):
  //   [15:3] - unused        - All zeros
  //   [2]    - MPR Operation - 0(normal operation), 1(data flow from MPR)
  //   [1:0]  - MPR location  - 00 (Predefined pattern)
  //*****************************************************************

  assign load_mr3[1:0]  = 2'b00;
  assign load_mr3[2]    = 1'b0;
  assign load_mr3[15:3] = 13'b0000000000000;
  
  // For multi-rank systems the rank being accessed during writes in 
  // Read Leveling must be sent to phy_write for the bitslip logic
  assign calib_rank_cnt = chip_cnt_r;

  //***************************************************************************
  // Logic to begin initial calibration, and to handle precharge requests
  // during read-leveling (to avoid tRAS violations if individual read 
  // levelling calibration stages take more than max{tRAS) to complete). 
  //***************************************************************************

  // Assert when readback for each stage of read-leveling begins. However,
  // note this indicates only when the read command is issued and when
  // Phaser_IN has phase aligned FREQ_REF clock to read DQS. It does not
  // indicate when the read data is present on the bus (when this happens 
  // after the read command is issued depends on CAS LATENCY) - there will 
  // need to be some delay before valid data is present on the bus.  
//  assign rdlvl_start_pre = (init_state_r == INIT_PI_PHASELOCK_READS);

  // Assert when read back for oclkdelay calibration begins
  assign oclkdelay_calib_start_pre = (init_state_r == INIT_OCAL_CENTER_ACT); //(init_state_r == INIT_OCLKDELAY_READ);
  
  // Assert when read back for write calibration begins
  assign wrcal_start_pre = (init_state_r == INIT_WRCAL_READ) || (init_state_r == INIT_WRCAL_MULT_READS);
  
  // Common precharge signal done signal - pulses only when there has been
  // a precharge issued as a result of a PRECH_REQ pulse. Note also a common
  // PRECH_DONE signal is used for all blocks
  assign prech_done_pre = (((init_state_r == INIT_RDLVL_STG1_READ) || (init_state_r == INIT_RDLVL_STG1_WRITE_READ) ||  
                           ((rdlvl_last_byte_done_r || prbs_last_byte_done_r) && (init_state_r == INIT_RDLVL_ACT_WAIT) && cnt_cmd_done_r) ||
                            (dqs_found_prech_req && (init_state_r == INIT_RDLVL_ACT_WAIT)) ||
                            (init_state_r == INIT_MPR_RDEN) ||
                            ((init_state_r == INIT_WRCAL_ACT_WAIT) && cnt_cmd_done_r) ||
                            (init_state_r == INIT_OCAL_CENTER_ACT) ||
                            ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT) && complex_oclkdelay_calib_start_r1) ||
                            ((init_state_r == INIT_OCLKDELAY_ACT_WAIT) && cnt_cmd_done_r) ||
                            ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) && prbs_last_byte_done_r) ||  //prbs_rdlvl_done
                            (wrlvl_final && (init_state_r == INIT_REFRESH_WAIT) && cnt_cmd_done_r && ~oclkdelay_calib_done)) &&
                           prech_pending_r && 
                           !prech_req_posedge_r);
  
  always @(posedge clk)
    if (rst)
	  calib_tap_inc_start <= #TCQ 1'b0;
	else if (init_state_r == INIT_SKIP_CALIB_WAIT)
	  calib_tap_inc_start <= #TCQ 1'b1;
	  
  always @(posedge clk)
    calib_tap_inc_done_r1 <= #TCQ calib_tap_inc_done;
  
  always @(posedge clk)
    if (rst || (init_state_r == INIT_WRCAL_WRITE))
	  calib_tap_end_if_reset <= #TCQ 1'b0;
	else if (calib_tap_inc_done && ~calib_tap_inc_done_r1)
	  calib_tap_end_if_reset <= #TCQ 1'b1;

  always @(posedge clk)
    if (rst)
      pi_phaselock_start <= #TCQ 1'b0;
    else if (init_state_r == INIT_PI_PHASELOCK_READS)
      pi_phaselock_start <= #TCQ 1'b1;
  
  // Delay start of each calibration by 16 clock cycles to ensure that when 
  // calibration logic begins, read data is already appearing on the bus.   
  // Each circuit should synthesize using an SRL16. Assume that reset is
  // long enough to clear contents of SRL16. 
  always @(posedge clk) begin 
    rdlvl_last_byte_done_r <= #TCQ rdlvl_last_byte_done;  
    prbs_last_byte_done_r  <= #TCQ prbs_last_byte_done;  
    rdlvl_start_dly0_r     <= #TCQ {rdlvl_start_dly0_r[14:0], 
                                     rdlvl_start_pre};
    wrcal_start_dly_r     <= #TCQ {wrcal_start_dly_r[14:0],
                                     wrcal_start_pre};
    oclkdelay_start_dly_r <= #TCQ {oclkdelay_start_dly_r[14:0],
                                   oclkdelay_calib_start_pre};
    prech_done_dly_r       <= #TCQ {prech_done_dly_r[14:0], 
                                     prech_done_pre};
  end
  
  always @(posedge clk)
    if (rst)
      oclkdelay_calib_start_int <= #TCQ 1'b0;
    else if (oclkdelay_start_dly_r[5])
      oclkdelay_calib_start_int <= #TCQ 1'b1;
  
  always @(posedge clk) begin
    if (rst)
	  ocal_last_byte_done <= #TCQ 1'b0;
	else if ((complex_oclkdelay_calib_cnt == DQS_WIDTH-1) && oclkdelay_center_calib_done)
	  ocal_last_byte_done <= #TCQ 1'b1;
  end

  always @(posedge clk) begin
    if (rst || (init_state_r == INIT_REFRESH) || prbs_rdlvl_done || ocal_last_byte_done || oclkdelay_center_calib_done)
	  oclkdelay_ref_cnt <= #TCQ REFRESH_TIMER;
	else if (oclkdelay_calib_start_int) begin
	  if (oclkdelay_ref_cnt > 'd0)
	    oclkdelay_ref_cnt <= #TCQ oclkdelay_ref_cnt - 1;
	  else
	    oclkdelay_ref_cnt <= #TCQ REFRESH_TIMER;
	end
  end
  
  always @(posedge clk) begin
    if (rst || (init_state_r == INIT_OCAL_CENTER_ACT) || oclkdelay_calib_done || ocal_last_byte_done || oclkdelay_center_calib_done)
	  oclkdelay_int_ref_req <= #TCQ 1'b0;
	else if (oclkdelay_ref_cnt == 'd1)
	  oclkdelay_int_ref_req <= #TCQ 1'b1;
  end
  
  always @(posedge clk) begin
    if (rst)
      ocal_act_wait_cnt <= #TCQ 'd0;
    else if ((init_state_r == INIT_OCAL_CENTER_ACT_WAIT) && ocal_act_wait_cnt < 'd15)
      ocal_act_wait_cnt <= #TCQ ocal_act_wait_cnt + 1;
    else
      ocal_act_wait_cnt <= #TCQ 'd0;
  end
  
  always @(posedge clk) begin
    if (rst || (init_state_r == INIT_OCLKDELAY_READ))
	  oclk_calib_resume_level <= #TCQ 1'b0;
	else if (oclk_calib_resume)
	  oclk_calib_resume_level <= #TCQ 1'b1;
  end
  
  always @(posedge clk) begin
    if (rst || (init_state_r == INIT_RDLVL_ACT_WAIT) || prbs_rdlvl_done)
	  complex_rdlvl_int_ref_req <= #TCQ 1'b0;
	else if (oclkdelay_ref_cnt == 'd1)
//	  complex_rdlvl_int_ref_req <= #TCQ 1'b1;
	  complex_rdlvl_int_ref_req <= #TCQ 1'b0;   //temporary fix for read issue
  end
  
  always @(posedge clk) begin
    if (rst || (init_state_r == INIT_RDLVL_COMPLEX_READ))
	  ext_int_ref_req <= #TCQ 1'b0;
	else if ((init_state_r == INIT_RDLVL_ACT_WAIT) && complex_rdlvl_int_ref_req)
	  ext_int_ref_req <= #TCQ 1'b1;
  end
  

  always @(posedge clk) begin    
    prech_done    <= #TCQ prech_done_dly_r[15];
	prech_done_r1 <= #TCQ prech_done_dly_r[15];
    prech_done_r2 <= #TCQ prech_done_r1;
	prech_done_r3 <= #TCQ prech_done_r2;
  end
	  

  always @(posedge clk)
    if (rst)
      mpr_rdlvl_start <= #TCQ 1'b0;
    else if (pi_dqs_found_done &&
           (init_state_r == INIT_MPR_READ))
      mpr_rdlvl_start <= #TCQ 1'b1;

  always @(posedge clk)
    phy_if_empty_r <= #TCQ phy_if_empty;

  always @(posedge clk)
    if (rst || 
        ((stg1_wr_rd_cnt == 'd2) && ~stg1_wr_done) || prbs_rdlvl_done)                        
      prbs_gen_clk_en <= #TCQ 1'b0;
    else if ((~phy_if_empty_r && rdlvl_stg1_done_r1 && ~prbs_rdlvl_done) ||
             ((init_state_r == INIT_RDLVL_ACT_WAIT) && rdlvl_stg1_done_r1 && (cnt_cmd_r == 'd127)) ||
             ((init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT) && rdlvl_stg1_done_r1 && (complex_wait_cnt == 'd14)) 
             || (init_state_r == INIT_RDLVL_COMPLEX_READ) || ((init_state_r == INIT_PRECHARGE_PREWAIT) && prbs_rdlvl_start)) 
      prbs_gen_clk_en <= #TCQ 1'b1;
 
 //Enable for complex oclkdelay - used in prbs gen
  always @(posedge clk)
    if (rst || 
        ((stg1_wr_rd_cnt == 'd2) && ~stg1_wr_done) || complex_oclkdelay_calib_done || 
          (complex_wait_cnt == 'd15 && complex_num_writes == 1 && complex_ocal_wr_start) ||
          ( init_state_r == INIT_RDLVL_STG1_WRITE && complex_num_writes_dec == 'd2) || ~complex_ocal_wr_start ||
          (complex_byte_rd_done && init_state_r == INIT_RDLVL_COMPLEX_ACT ) ||
	  (init_state_r != INIT_OCAL_COMPLEX_RESUME_WAIT && init_state_r1 == INIT_OCAL_COMPLEX_RESUME_WAIT) ||
          (init_state_r == INIT_OCAL_COMPLEX_ACT))                       
      prbs_gen_oclk_clk_en <= #TCQ 1'b0;
    else if ((~phy_if_empty_r && ~complex_oclkdelay_calib_done && prbs_rdlvl_done_r1) || // changed for new algo 3/26
             ((init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) && (complex_wait_cnt == 'd14)) ||
             ((init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) && (complex_wait_cnt == 'd14)) ||
	     exit_ocal_complex_resume_wait ||
             ((init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT) && ~stg1_wr_done && ~complex_row1_wr_done && ~complex_ocal_num_samples_done_r && (complex_wait_cnt == 'd14)) 
             || (init_state_r == INIT_RDLVL_COMPLEX_READ) )
      prbs_gen_oclk_clk_en <= #TCQ 1'b1;

generate
if (RANKS < 2) begin
  always @(posedge clk)
    if (rst) begin
      rdlvl_stg1_start   <= #TCQ 1'b0;
      rdlvl_stg1_start_int <= #TCQ 1'b0;
      rdlvl_start_pre <= #TCQ 1'b0;
      prbs_rdlvl_start     <= #TCQ 1'b0;
    end else begin      
      if (pi_dqs_found_done && cnt_cmd_done_r &&
         (init_state_r == INIT_RDLVL_ACT_WAIT))
        rdlvl_stg1_start_int <= #TCQ 1'b1;
      if (pi_dqs_found_done &&
         (init_state_r == INIT_RDLVL_STG1_READ))begin
        rdlvl_start_pre <= #TCQ 1'b1;
        rdlvl_stg1_start <= #TCQ  rdlvl_start_dly0_r[14];
      end 
      if (pi_dqs_found_done && rdlvl_stg1_done && ~prbs_rdlvl_done &&
         (init_state_r == INIT_RDLVL_COMPLEX_PI_WAIT) && (WRLVL == "ON")) begin
        prbs_rdlvl_start <= #TCQ 1'b1;
      end 
    end
end else begin
  always @(posedge clk)
    if (rst || rdlvl_stg1_rank_done) begin
      rdlvl_stg1_start   <= #TCQ 1'b0;
      rdlvl_stg1_start_int <= #TCQ 1'b0;
      rdlvl_start_pre <= #TCQ 1'b0;
      prbs_rdlvl_start     <= #TCQ 1'b0;
    end else begin      
      if (pi_dqs_found_done && cnt_cmd_done_r &&
         (init_state_r == INIT_RDLVL_ACT_WAIT))
        rdlvl_stg1_start_int <= #TCQ 1'b1;
      if (pi_dqs_found_done &&
         (init_state_r == INIT_RDLVL_STG1_READ))begin
        rdlvl_start_pre <= #TCQ 1'b1;
        rdlvl_stg1_start <= #TCQ  rdlvl_start_dly0_r[14];
      end 
      if (pi_dqs_found_done && rdlvl_stg1_done && ~prbs_rdlvl_done &&
         (init_state_r == INIT_RDLVL_COMPLEX_PI_WAIT) && (WRLVL == "ON")) begin
        prbs_rdlvl_start <= #TCQ 1'b1;
      end  
    end
end
endgenerate


    always @(posedge clk) begin
      if (rst || dqsfound_retry || wrlvl_byte_redo) begin
        pi_dqs_found_start <= #TCQ 1'b0;
        wrcal_start        <= #TCQ 1'b0;
      end else begin
        if (!pi_dqs_found_done && init_state_r == INIT_RDLVL_STG2_READ)
          pi_dqs_found_start <= #TCQ 1'b1;
        if (wrcal_start_dly_r[5])
          wrcal_start <= #TCQ 1'b1;
      end  
    end // else: !if(rst)


  always @(posedge clk)
    if (rst)
      oclkdelay_calib_start <= #TCQ 1'b0;
    else if (oclkdelay_start_dly_r[5])
      oclkdelay_calib_start <= #TCQ 1'b1;
  
  always @(posedge clk)
    if (rst)
      pi_dqs_found_done_r1 <= #TCQ 1'b0;
    else
      pi_dqs_found_done_r1 <= #TCQ pi_dqs_found_done;

  
  always @(posedge clk)
    wrlvl_final_r <= #TCQ wrlvl_final;
  
  // Reset IN_FIFO after final write leveling to make sure the FIFO
  // pointers are initialized
  always @(posedge clk)
    if (rst || (init_state_r == INIT_WRCAL_WRITE) || (init_state_r == INIT_REFRESH))
      wrlvl_final_if_rst <= #TCQ 1'b0;
    else if (wrlvl_done_r &&  //(wrlvl_final_r && wrlvl_done_r && 
            (init_state_r == INIT_WRLVL_LOAD_MR2))
      wrlvl_final_if_rst <= #TCQ 1'b1;

  // Constantly enable DQS while write leveling is enabled in the memory
  // This is more to get rid of warnings in simulation, can later change
  // this code to only enable WRLVL_ACTIVE when WRLVL_START is asserted

  always @(posedge clk)
    if (rst ||
       ((init_state_r1 != INIT_WRLVL_START) && 
       (init_state_r == INIT_WRLVL_START)))
      wrlvl_odt_ctl <= #TCQ 1'b0;
    else if (wrlvl_rank_done && ~wrlvl_rank_done_r1)
      wrlvl_odt_ctl <= #TCQ 1'b1;

  generate
    if (nCK_PER_CLK == 4) begin: en_cnt_div4
      always @ (posedge clk)
        if (rst)
          enable_wrlvl_cnt <= #TCQ 5'd0;
        else if ((init_state_r == INIT_WRLVL_START) ||
                 (wrlvl_odt && (enable_wrlvl_cnt == 5'd0)))
          enable_wrlvl_cnt <= #TCQ 5'd12;
        else if ((enable_wrlvl_cnt > 5'd0) && ~(phy_ctl_full || phy_cmd_full))
          enable_wrlvl_cnt <= #TCQ enable_wrlvl_cnt - 1;
          
      // ODT stays asserted as long as write_calib
      // signal is asserted        
      always @(posedge clk)
        if (rst || wrlvl_odt_ctl)
          wrlvl_odt <= #TCQ 1'b0;
        else if (enable_wrlvl_cnt == 5'd1)
          wrlvl_odt <= #TCQ 1'b1;
          
    end else begin: en_cnt_div2  
      always @ (posedge clk)
        if (rst)
          enable_wrlvl_cnt <= #TCQ 5'd0;
        else if ((init_state_r == INIT_WRLVL_START) ||
                 (wrlvl_odt && (enable_wrlvl_cnt == 5'd0)))
          enable_wrlvl_cnt <= #TCQ 5'd21;
        else if ((enable_wrlvl_cnt > 5'd0) && ~(phy_ctl_full || phy_cmd_full))
          enable_wrlvl_cnt <= #TCQ enable_wrlvl_cnt - 1;
          
      // ODT stays asserted as long as write_calib
      // signal is asserted        
      always @(posedge clk)
        if (rst || wrlvl_odt_ctl)
          wrlvl_odt <= #TCQ 1'b0;
        else if (enable_wrlvl_cnt == 5'd1)
          wrlvl_odt <= #TCQ 1'b1;
      
    end
  endgenerate
  
  always @(posedge clk)
    if (rst || wrlvl_rank_done || done_dqs_tap_inc)
      wrlvl_active <= #TCQ 1'b0;
    else if ((enable_wrlvl_cnt == 5'd1) && wrlvl_odt && !wrlvl_active)
      wrlvl_active <= #TCQ 1'b1;

// signal used to assert DQS for write leveling.
// the DQS will be asserted once every 16 clock cycles.
  always @(posedge clk)begin
     if(rst || (enable_wrlvl_cnt != 5'd1)) begin
       wr_level_dqs_asrt <= #TCQ 1'd0;
     end else if ((enable_wrlvl_cnt == 5'd1) && (wrlvl_active_r1)) begin
       wr_level_dqs_asrt <= #TCQ 1'd1;
     end
  end

  always @ (posedge clk) begin
     if (rst || (wrlvl_done_r && ~wrlvl_done_r1))
       dqs_asrt_cnt <= #TCQ 2'd0;
     else if (wr_level_dqs_asrt && dqs_asrt_cnt != 2'd3)
       dqs_asrt_cnt <= #TCQ (dqs_asrt_cnt + 1);
  end

  always @ (posedge clk) begin
     if (rst || ~wrlvl_active)
       wr_lvl_start <= #TCQ 1'd0;
     else if (dqs_asrt_cnt == 2'd3)
       wr_lvl_start <= #TCQ 1'd1;
  end

      
  always @(posedge clk) begin
    if (rst)
      wl_sm_start        <= #TCQ 1'b0;
    else
      wl_sm_start        <= #TCQ wr_level_dqs_asrt_r1;
  end


    always @(posedge clk) begin
      wrlvl_active_r1      <= #TCQ wrlvl_active;
      wr_level_dqs_asrt_r1 <= #TCQ wr_level_dqs_asrt;
      wrlvl_done_r         <= #TCQ wrlvl_done;
      wrlvl_done_r1        <= #TCQ wrlvl_done_r;
      wrlvl_rank_done_r1   <= #TCQ wrlvl_rank_done;
      wrlvl_rank_done_r2   <= #TCQ wrlvl_rank_done_r1;
      wrlvl_rank_done_r3   <= #TCQ wrlvl_rank_done_r2;
      wrlvl_rank_done_r4   <= #TCQ wrlvl_rank_done_r3;
      wrlvl_rank_done_r5   <= #TCQ wrlvl_rank_done_r4;
      wrlvl_rank_done_r6   <= #TCQ wrlvl_rank_done_r5;
      wrlvl_rank_done_r7   <= #TCQ wrlvl_rank_done_r6;
    end
    
    always @ (posedge clk) begin
      //if (rst)
        wrlvl_rank_cntr <= #TCQ 3'd0;
      //else if (wrlvl_rank_done)
      //  wrlvl_rank_cntr <= #TCQ wrlvl_rank_cntr + 1'b1;
    end               
      
  //*****************************************************************
  // Precharge request logic - those calibration logic blocks
  // that require greater than tRAS(max) to finish must break up
  // their calibration into smaller units of time, with precharges
  // issued in between. This is done using the XXX_PRECH_REQ and
  // PRECH_DONE handshaking between PHY_INIT and those blocks
  //*****************************************************************

  // Shared request from multiple sources
  assign prech_req = oclk_prech_req | rdlvl_prech_req | wrcal_prech_req | prbs_rdlvl_prech_req | 
                    (dqs_found_prech_req & (init_state_r == INIT_RDLVL_STG2_READ_WAIT));
  
  // Handshaking logic to force precharge during read leveling, and to
  // notify read leveling logic when precharge has been initiated and
  // it's okay to proceed with leveling again
  always @(posedge clk)
    if (rst) begin
      prech_req_r         <= #TCQ 1'b0;
      prech_req_posedge_r <= #TCQ 1'b0;
      prech_pending_r     <= #TCQ 1'b0;
    end else begin
      prech_req_r         <= #TCQ prech_req;
      prech_req_posedge_r <= #TCQ prech_req & ~prech_req_r;
      if (prech_req_posedge_r)
        prech_pending_r   <= #TCQ 1'b1;
      // Clear after we've finished with the precharge and have
      // returned to issuing read leveling calibration reads
      else if (prech_done_pre)
        prech_pending_r   <= #TCQ 1'b0;
    end
	
  always @(posedge clk) begin
    if (rst || prech_done_r3)
      mask_lim_done <= #TCQ 1'b0;
    else if (prech_pending_r)
      mask_lim_done <= #TCQ 1'b1;
  end
  
    always @(posedge clk) begin
    if (rst || prbs_rdlvl_done_r3)
      complex_mask_lim_done <= #TCQ 1'b0;
    else if (~prbs_rdlvl_done && complex_oclkdelay_calib_start_int)
      complex_mask_lim_done <= #TCQ 1'b1;
  end

  //Complex oclkdelay calibrration

  //***************************************************************************
  // Various timing counters
  //***************************************************************************
  
  //*****************************************************************
  // Generic delay for various states that require it (e.g. for turnaround
  // between read and write). Make this a sufficiently large number of clock
  // cycles to cover all possible frequencies and memory components)
  // Requirements for this counter:
  //  1. Greater than tMRD
  //  2. tRFC (refresh-active) for DDR2
  //  3. (list the other requirements, slacker...)
  //*****************************************************************

  always @(posedge clk) begin
    case (init_state_r)
      INIT_LOAD_MR_WAIT,
      INIT_WRLVL_LOAD_MR_WAIT,
      INIT_WRLVL_LOAD_MR2_WAIT,
      INIT_MPR_WAIT,
      INIT_MPR_DISABLE_PREWAIT,
      INIT_MPR_DISABLE_WAIT,
      INIT_OCLKDELAY_ACT_WAIT,
      INIT_OCLKDELAY_WRITE_WAIT,
      INIT_RDLVL_ACT_WAIT,
      INIT_RDLVL_STG1_WRITE_READ,
      INIT_RDLVL_STG2_READ_WAIT,
      INIT_WRCAL_ACT_WAIT,
      INIT_WRCAL_WRITE_READ,
      INIT_WRCAL_READ_WAIT,
      INIT_PRECHARGE_PREWAIT,
      INIT_PRECHARGE_WAIT,
      INIT_DDR2_PRECHARGE_WAIT,
      INIT_REG_WRITE_WAIT,
      INIT_REFRESH_WAIT,
      INIT_REFRESH_RNK2_WAIT: begin
        if (phy_ctl_full || phy_cmd_full)
          cnt_cmd_r <= #TCQ cnt_cmd_r;
        else
          cnt_cmd_r <= #TCQ cnt_cmd_r + 1;
      end
      INIT_WRLVL_WAIT:
        cnt_cmd_r <= #TCQ 'b0;
      default:
        cnt_cmd_r <= #TCQ 'b0;
    endcase
  end

  // pulse when count reaches terminal count
  always @(posedge clk)
    cnt_cmd_done_r <= #TCQ (cnt_cmd_r == CNTNEXT_CMD);
 
  // For ODT deassertion - hold throughout post read/write wait stage, but
  // deassert before next command. The post read/write stage is very long, so
  // we simply address the longest case here plus some margin.
  always @(posedge clk)
    cnt_cmd_done_m7_r <= #TCQ (cnt_cmd_r == (CNTNEXT_CMD - 7));

//************************************************************************
// Added to support PO fine delay inc when TG errors
  always @(posedge clk) begin
    case (init_state_r)
      INIT_WRCAL_READ_WAIT: begin
        if (phy_ctl_full || phy_cmd_full)
          cnt_wait <= #TCQ cnt_wait;
        else
          cnt_wait <= #TCQ cnt_wait + 1;
      end
      default:
        cnt_wait <= #TCQ 'b0;
    endcase
  end
  
  always @(posedge clk)
    cnt_wrcal_rd <= #TCQ (cnt_wait == 'd4);
  
  always @(posedge clk) begin
    if (rst || ~temp_wrcal_done)
      temp_lmr_done <= #TCQ 1'b0;
    else if (temp_wrcal_done && (init_state_r == INIT_LOAD_MR))
      temp_lmr_done <= #TCQ 1'b1;
  end
  
  always @(posedge clk)
    temp_wrcal_done_r <= #TCQ temp_wrcal_done;
    
  always @(posedge clk)
    if (rst) begin
      tg_timer_go     <= #TCQ 1'b0;
    end else if ((PRE_REV3ES == "ON") && temp_wrcal_done && temp_lmr_done &&
              (init_state_r == INIT_WRCAL_READ_WAIT)) begin
      tg_timer_go     <= #TCQ 1'b1;
    end else begin
      tg_timer_go     <= #TCQ 1'b0;
    end

  always @(posedge clk) begin
    if (rst || (temp_wrcal_done && ~temp_wrcal_done_r) ||
       (init_state_r == INIT_PRECHARGE_PREWAIT))
      tg_timer <= #TCQ 'd0;
    else if ((pi_phaselock_timer == PHASELOCKED_TIMEOUT) &&
            tg_timer_go &&
            (tg_timer != TG_TIMER_TIMEOUT))
      tg_timer <= #TCQ tg_timer + 1;
  end
  
  always @(posedge clk) begin
    if (rst)
      tg_timer_done <= #TCQ 1'b0;
    else if (tg_timer == TG_TIMER_TIMEOUT)
      tg_timer_done <= #TCQ 1'b1;
    else
      tg_timer_done <= #TCQ 1'b0;
  end
  
  always @(posedge clk) begin
    if (rst)
      no_rst_tg_mc <= #TCQ 1'b0;
    else if ((init_state_r == INIT_WRCAL_ACT) && wrcal_read_req)
      no_rst_tg_mc <= #TCQ 1'b1;
    else
      no_rst_tg_mc <= #TCQ 1'b0;
  end
  
//************************************************************************
 
  always @(posedge clk) begin
    if (rst)
      detect_pi_found_dqs <= #TCQ 1'b0;
    else if ((cnt_cmd_r == 7'b0111111) &&
             (init_state_r == INIT_RDLVL_STG2_READ_WAIT))
      detect_pi_found_dqs <= #TCQ 1'b1;
    else
      detect_pi_found_dqs <= #TCQ 1'b0;
  end 

  //*****************************************************************
  // Initial delay after power-on for RESET, CKE
  // NOTE: Could reduce power consumption by turning off these counters
  //       after initial power-up (at expense of more logic)
  // NOTE: Likely can combine multiple counters into single counter
  //*****************************************************************

  // Create divided by 1024 version of clock 
  always @(posedge clk)
    if (rst) begin
      cnt_pwron_ce_r <= #TCQ 10'h000;
      pwron_ce_r     <= #TCQ 1'b0;
    end else begin
      cnt_pwron_ce_r <= #TCQ cnt_pwron_ce_r + 1;
      pwron_ce_r     <= #TCQ (cnt_pwron_ce_r == 10'h3FF);
    end
  
  // "Main" power-on counter - ticks every CLKDIV/1024 cycles
  always @(posedge clk) 
    if (rst)
      cnt_pwron_r <= #TCQ 'b0;
    else if (pwron_ce_r)
      cnt_pwron_r <= #TCQ cnt_pwron_r + 1;

  always @(posedge clk)
    if (rst || ~phy_ctl_ready) begin
      cnt_pwron_reset_done_r <= #TCQ 1'b0;
      cnt_pwron_cke_done_r   <= #TCQ 1'b0;
    end else begin
      // skip power-up count for simulation purposes only
      if ((SIM_INIT_OPTION == "SKIP_PU_DLY") || 
          (SIM_INIT_OPTION == "SKIP_INIT")) begin
        cnt_pwron_reset_done_r <= #TCQ 1'b1;
        cnt_pwron_cke_done_r   <= #TCQ 1'b1;
      end else begin
        // otherwise, create latched version of done signal for RESET, CKE
        if (DRAM_TYPE == "DDR3") begin
           if (!cnt_pwron_reset_done_r)
             cnt_pwron_reset_done_r 
               <= #TCQ (cnt_pwron_r == PWRON_RESET_DELAY_CNT);
           if (!cnt_pwron_cke_done_r)
             cnt_pwron_cke_done_r   
               <= #TCQ (cnt_pwron_r == PWRON_CKE_DELAY_CNT);
           end else begin // DDR2
              cnt_pwron_reset_done_r <= #TCQ 1'b1; // not needed 
              if (!cnt_pwron_cke_done_r)
                 cnt_pwron_cke_done_r   
                   <= #TCQ (cnt_pwron_r == PWRON_CKE_DELAY_CNT);
           end        
      end
    end // else: !if(rst || ~phy_ctl_ready)


  always @(posedge clk)
    cnt_pwron_cke_done_r1   <= #TCQ cnt_pwron_cke_done_r;

  // Keep RESET asserted and CKE deasserted until after power-on delay
  always @(posedge clk or posedge rst) begin
    if (rst)
      phy_reset_n <= #TCQ 1'b0;
    else
      phy_reset_n <= #TCQ cnt_pwron_reset_done_r;
//    phy_cke    <= #TCQ {CKE_WIDTH{cnt_pwron_cke_done_r}};
  end

  //*****************************************************************
  // Counter for tXPR (pronouned "Tax-Payer") - wait time after 
  // CKE deassertion before first MRS command can be asserted
  //*****************************************************************

  always @(posedge clk)
    if (!cnt_pwron_cke_done_r) begin
      cnt_txpr_r      <= #TCQ 'b0;
      cnt_txpr_done_r <= #TCQ 1'b0;
    end else begin
      cnt_txpr_r <= #TCQ cnt_txpr_r + 1;
      if (!cnt_txpr_done_r)
        cnt_txpr_done_r <= #TCQ (cnt_txpr_r == TXPR_DELAY_CNT);
    end

  //*****************************************************************
  // Counter for the initial 400ns wait for issuing precharge all
  // command after CKE assertion. Only for DDR2. 
  //*****************************************************************

  always @(posedge clk)
    if (!cnt_pwron_cke_done_r) begin
      cnt_init_pre_wait_r      <= #TCQ 'b0;
      cnt_init_pre_wait_done_r <= #TCQ 1'b0;
    end else begin
      cnt_init_pre_wait_r <= #TCQ cnt_init_pre_wait_r + 1;
      if (!cnt_init_pre_wait_done_r)
        cnt_init_pre_wait_done_r 
          <= #TCQ (cnt_init_pre_wait_r >= DDR2_INIT_PRE_CNT);
    end
    
  //*****************************************************************
  // Wait for both DLL to lock (tDLLK) and ZQ calibration to finish
  // (tZQINIT). Both take the same amount of time (512*tCK)
  //*****************************************************************

  always @(posedge clk)
    if (init_state_r == INIT_ZQCL) begin
      cnt_dllk_zqinit_r      <= #TCQ 'b0;
      cnt_dllk_zqinit_done_r <= #TCQ 1'b0;
    end else if (~(phy_ctl_full || phy_cmd_full))  begin
      cnt_dllk_zqinit_r <= #TCQ cnt_dllk_zqinit_r + 1;
      if (!cnt_dllk_zqinit_done_r) 
        cnt_dllk_zqinit_done_r 
          <= #TCQ (cnt_dllk_zqinit_r == TDLLK_TZQINIT_DELAY_CNT);
    end

  //*****************************************************************  
  // Keep track of which MRS counter needs to be programmed during
  // memory initialization
  // The counter and the done signal are reset an additional time
  // for DDR2. The same signals are used for the additional DDR2
  // initialization sequence. 
  //*****************************************************************
  
  always @(posedge clk)
    if ((init_state_r == INIT_IDLE)||
        ((init_state_r == INIT_REFRESH)
          && (~mem_init_done_r))) begin
      cnt_init_mr_r      <= #TCQ 'b0;
      cnt_init_mr_done_r <= #TCQ 1'b0;
    end else if (init_state_r == INIT_LOAD_MR) begin
      cnt_init_mr_r      <= #TCQ cnt_init_mr_r + 1;
      cnt_init_mr_done_r <= #TCQ (cnt_init_mr_r == INIT_CNT_MR_DONE);
    end

  
  //*****************************************************************  
  // Flag to tell if the first precharge for DDR2 init sequence is
  // done 
  //*****************************************************************
  
  always @(posedge clk)
    if (init_state_r == INIT_IDLE) 
      ddr2_pre_flag_r<= #TCQ 'b0;
    else if (init_state_r == INIT_LOAD_MR) 
      ddr2_pre_flag_r<= #TCQ 1'b1;
    // reset the flag for multi rank case 
    else if ((ddr2_refresh_flag_r) &&
             (init_state_r == INIT_LOAD_MR_WAIT)&&
             (cnt_cmd_done_r) && (cnt_init_mr_done_r))
      ddr2_pre_flag_r <= #TCQ 'b0;

  //*****************************************************************  
  // Flag to tell if the refresh stat  for DDR2 init sequence is
  // reached 
  //*****************************************************************
  
  always @(posedge clk)
    if (init_state_r == INIT_IDLE) 
      ddr2_refresh_flag_r<= #TCQ 'b0;
    else if ((init_state_r == INIT_REFRESH) && (~mem_init_done_r)) 
      // reset the flag for multi rank case 
      ddr2_refresh_flag_r<= #TCQ 1'b1;
    else if ((ddr2_refresh_flag_r) &&
             (init_state_r == INIT_LOAD_MR_WAIT)&&
             (cnt_cmd_done_r) && (cnt_init_mr_done_r))
      ddr2_refresh_flag_r <= #TCQ 'b0;
   
  //*****************************************************************  
  // Keep track of the number of auto refreshes for DDR2 
  // initialization. The spec asks for a minimum of two refreshes.
  // Four refreshes are performed here. The two extra refreshes is to
  // account for the 200 clock cycle wait between step h and l.
  // Without the two extra refreshes we would have to have a
  // wait state. 
  //*****************************************************************
  
  always @(posedge clk)
    if (init_state_r == INIT_IDLE) begin
      cnt_init_af_r      <= #TCQ 'b0;
      cnt_init_af_done_r <= #TCQ 1'b0;
    end else if ((init_state_r == INIT_REFRESH) && (~mem_init_done_r))begin
      cnt_init_af_r      <= #TCQ cnt_init_af_r + 1;
      cnt_init_af_done_r <= #TCQ (cnt_init_af_r == 2'b11);
    end   

  //*****************************************************************  
  // Keep track of the register control word programming for
  // DDR3 RDIMM 
  //*****************************************************************
  
  always @(posedge clk)
    if (init_state_r == INIT_IDLE)
      reg_ctrl_cnt_r <= #TCQ 'b0;
    else if (init_state_r == INIT_REG_WRITE)
      reg_ctrl_cnt_r <= #TCQ reg_ctrl_cnt_r + 1;

  generate
  if (RANKS < 2) begin: one_rank
    always @(posedge clk)
      if ((init_state_r == INIT_IDLE) || rdlvl_last_byte_done || 
          (complex_byte_rd_done) || prbs_rdlvl_done_pulse )
        stg1_wr_done <= #TCQ 1'b0;
      else if (init_state_r == INIT_RDLVL_STG1_WRITE_READ)
        stg1_wr_done <= #TCQ 1'b1;
  end else begin: two_ranks
    always @(posedge clk)
      if ((init_state_r == INIT_IDLE) || rdlvl_last_byte_done || 
             (complex_byte_rd_done) || prbs_rdlvl_done_pulse ||
         (rdlvl_stg1_rank_done ))
        stg1_wr_done <= #TCQ 1'b0;
      else if (init_state_r == INIT_RDLVL_STG1_WRITE_READ)
        stg1_wr_done <= #TCQ 1'b1;
  end
  endgenerate
  
  always @(posedge clk)
    if (rst)
      rnk_ref_cnt <= #TCQ 1'b0;
    else if (stg1_wr_done && 
            (init_state_r == INIT_REFRESH_WAIT) && cnt_cmd_done_r)
      rnk_ref_cnt <= #TCQ ~rnk_ref_cnt;
  

  always @(posedge clk)
    if (rst || (init_state_r == INIT_MPR_RDEN) || (init_state_r == INIT_OCAL_CENTER_ACT) ||
       (init_state_r == INIT_OCLKDELAY_ACT) || (init_state_r == INIT_RDLVL_ACT) || 
       (init_state_r == INIT_OCAL_COMPLEX_ACT) || (init_state_r ==INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT))
      num_refresh <= #TCQ 'd0;
    else if ((init_state_r == INIT_REFRESH) &&
             (~pi_dqs_found_done || ((DRAM_TYPE == "DDR3") && ~oclkdelay_calib_done) ||
             (rdlvl_stg1_done && ~prbs_rdlvl_done) ||
             (prbs_rdlvl_done && ~complex_oclkdelay_calib_done) ||
             ((CLK_PERIOD/nCK_PER_CLK <= 2500) && wrcal_done && ~rdlvl_stg1_done) ||
             ((CLK_PERIOD/nCK_PER_CLK > 2500) && wrlvl_done_r1 && ~rdlvl_stg1_done)))
      num_refresh <= #TCQ num_refresh + 1;
  
  
  //***************************************************************************
  // Initialization state machine
  //***************************************************************************

  //*****************************************************************
  // Next-state logic 
  //*****************************************************************

  always @(posedge clk)
    if (rst)begin
      init_state_r  <= #TCQ INIT_IDLE;
      init_state_r1 <= #TCQ INIT_IDLE;
    end else begin
      init_state_r  <= #TCQ init_next_state;
      init_state_r1 <= #TCQ init_state_r;
    end 
  
  always @(*) begin     
    init_next_state = init_state_r;
    (* full_case, parallel_case *) case (init_state_r)

      //*******************************************************
      // DRAM initialization
      //*******************************************************

      // Initial state - wait for:
      //   1. Power-on delays to pass
      //   2. PHY Control Block to assert phy_ctl_ready
      //   3. PHY Control FIFO must not be FULL
      //   4. Read path initialization to finish
      INIT_IDLE:
        if (cnt_pwron_cke_done_r && phy_ctl_ready && ck_addr_cmd_delay_done  && delay_incdec_done
            && ~(phy_ctl_full || phy_cmd_full) ) begin 
          // If skipping memory initialization (simulation only)
          if (SIM_INIT_OPTION == "SKIP_INIT")       
            //if (WRLVL == "ON")      
            //   Proceed to write leveling 
            //  init_next_state = INIT_WRLVL_START;
            //else //if (SIM_CAL_OPTION != "SKIP_CAL")            
              // Proceed to Phaser_In phase lock 
              init_next_state = INIT_RDLVL_ACT;
           // else
              // Skip read leveling
              //init_next_state = INIT_DONE;        
          else
            init_next_state = INIT_WAIT_CKE_EXIT;
        end
        
      // Wait minimum of Reset CKE exit time (tXPR = max(tXS, 
      INIT_WAIT_CKE_EXIT:
        if ((cnt_txpr_done_r) && (DRAM_TYPE == "DDR3") 
           && ~(phy_ctl_full || phy_cmd_full)) begin
          if((REG_CTRL == "ON") && ((nCS_PER_RANK > 1) ||
             (RANKS > 1)))
            //register write for reg dimm. Some register chips
            // have the register chip in a pre-programmed state
            // in that case the nCS_PER_RANK == 1 && RANKS == 1 
            init_next_state = INIT_REG_WRITE;
          else
          // Load mode register - this state is repeated multiple times
          init_next_state = INIT_LOAD_MR;
        end else if ((cnt_init_pre_wait_done_r) && (DRAM_TYPE == "DDR2")
                     && ~(phy_ctl_full || phy_cmd_full))
          // DDR2 start with a precharge all command 
          init_next_state = INIT_DDR2_PRECHARGE;                             

      INIT_REG_WRITE:
          init_next_state = INIT_REG_WRITE_WAIT;

      INIT_REG_WRITE_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))  begin
           if(reg_ctrl_cnt_r == 4'd8)
             init_next_state = INIT_LOAD_MR;
           else
             init_next_state = INIT_REG_WRITE;
        end
        
      INIT_LOAD_MR:
          init_next_state = INIT_LOAD_MR_WAIT;
          // After loading MR, wait at least tMRD
     
      INIT_LOAD_MR_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin
          // If finished loading all mode registers, proceed to next step
          if (prbs_rdlvl_done && pi_dqs_found_done && rdlvl_stg1_done)
            // for ddr3 when the correct burst length is writtern at end
            init_next_state = INIT_PRECHARGE;
          else if (~wrcal_done && temp_lmr_done)
            init_next_state = INIT_PRECHARGE_PREWAIT;
          else if (cnt_init_mr_done_r)begin
            if(DRAM_TYPE == "DDR3")
              init_next_state = INIT_ZQCL;
            else begin //DDR2
              if(ddr2_refresh_flag_r)begin
                // memory initialization per rank for multi-rank case
                if (!mem_init_done_r && (chip_cnt_r <= RANKS-1))
                  init_next_state  = INIT_DDR2_MULTI_RANK;                     
                else 
                  init_next_state = INIT_RDLVL_ACT;
                // ddr2 initialization done.load mode state after refresh
              end else 
                init_next_state = INIT_DDR2_PRECHARGE;
            end  
          end else      
            init_next_state = INIT_LOAD_MR;
        end

      // DDR2 multi rank transition state
      INIT_DDR2_MULTI_RANK:
        init_next_state = INIT_DDR2_MULTI_RANK_WAIT;

      INIT_DDR2_MULTI_RANK_WAIT:
        init_next_state = INIT_DDR2_PRECHARGE;
 
      // Initial ZQ calibration 
      INIT_ZQCL:
          init_next_state = INIT_WAIT_DLLK_ZQINIT;

      // Wait until both DLL have locked, and ZQ calibration done
      INIT_WAIT_DLLK_ZQINIT:
        if (cnt_dllk_zqinit_done_r && ~(phy_ctl_full || phy_cmd_full))
          // memory initialization per rank for multi-rank case
          if (!mem_init_done_r && (chip_cnt_r <= RANKS-1))
            init_next_state = INIT_LOAD_MR;
          //else if (WRLVL == "ON")
          //  init_next_state = INIT_WRLVL_START;
          else
            // skip write-leveling (e.g. for DDR2 interface)
            init_next_state = INIT_RDLVL_ACT;

      // Initial precharge for DDR2
      INIT_DDR2_PRECHARGE: 
          init_next_state = INIT_DDR2_PRECHARGE_WAIT; 

      INIT_DDR2_PRECHARGE_WAIT: 
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin
          if (ddr2_pre_flag_r)
            init_next_state = INIT_REFRESH;
          else // from precharge state initially go to load mode  
            init_next_state = INIT_LOAD_MR;
        end                                  

      INIT_REFRESH:
        if ((SKIP_CALIB == "TRUE") && ~calib_tap_inc_done && pi_dqs_found_done)
		  init_next_state = INIT_SKIP_CALIB_WAIT;
		else if ((RANKS == 2) && (chip_cnt_r == RANKS - 1))
          init_next_state = INIT_REFRESH_RNK2_WAIT;
        else
          init_next_state = INIT_REFRESH_WAIT; 

      INIT_REFRESH_RNK2_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))
          init_next_state = INIT_PRECHARGE;
      
      INIT_REFRESH_WAIT: 
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))begin
          if(cnt_init_af_done_r && (~mem_init_done_r))
            // go to lm state as part of DDR2 init sequence 
            init_next_state = INIT_LOAD_MR;
          // Go to state to issue back-to-back writes during limit check and centering
          else if (~oclkdelay_calib_done && (mpr_last_byte_done || mpr_rdlvl_done) && (DRAM_TYPE == "DDR3")) begin
            if (num_refresh == 'd8)
              init_next_state = INIT_OCAL_CENTER_ACT;
            else
              init_next_state = INIT_REFRESH;
          end else if(rdlvl_stg1_done && oclkdelay_center_calib_done &&
	          complex_oclkdelay_calib_done && ~wrlvl_done_r1 && (WRLVL == "ON")) 
            init_next_state = INIT_WRLVL_START;
          else if (pi_dqs_found_done && ~wrlvl_done_r1 && ~wrlvl_final && ~wrlvl_byte_redo && (WRLVL == "ON"))
            init_next_state = INIT_WRLVL_START;
          else if ((((prbs_last_byte_done_r || prbs_rdlvl_done) && ~complex_oclkdelay_calib_done
                     && pi_dqs_found_done) && (WRLVL == "ON")) //&& rdlvl_stg1_done // changed for new algo 3/26
                    && mem_init_done_r) begin
            if (num_refresh == 'd8) begin
			  if (BYPASS_COMPLEX_OCAL == "FALSE")
                init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;
			  else
			    init_next_state = INIT_WRCAL_ACT;
            end else 
              init_next_state = INIT_REFRESH;
          end else if (~pi_dqs_found_done ||
                   (rdlvl_stg1_done && ~prbs_rdlvl_done && ~complex_oclkdelay_calib_done) ||
                   ((CLK_PERIOD/nCK_PER_CLK <= 2500) && wrcal_done && ~rdlvl_stg1_done) ||
                   ((CLK_PERIOD/nCK_PER_CLK > 2500) && wrlvl_done_r1 && ~rdlvl_stg1_done)) begin
            if (num_refresh == 'd8)
              init_next_state = INIT_RDLVL_ACT;
            else
              init_next_state = INIT_REFRESH;
          end else if ((~wrcal_done && wrlvl_byte_redo)&& (DRAM_TYPE == "DDR3")
                   && (CLK_PERIOD/nCK_PER_CLK > 2500))
            init_next_state = INIT_WRLVL_LOAD_MR2;
          else if (((prbs_rdlvl_done && rdlvl_stg1_done && complex_oclkdelay_calib_done && pi_dqs_found_done) && (WRLVL == "ON"))
                    && mem_init_done_r && (CLK_PERIOD/nCK_PER_CLK > 2500))
            init_next_state = INIT_WRCAL_ACT;
          else if (pi_dqs_found_done && (DRAM_TYPE == "DDR3") && ~(mpr_last_byte_done || mpr_rdlvl_done)) begin
            if (num_refresh == 'd8)
              init_next_state = INIT_MPR_RDEN;
            else
              init_next_state = INIT_REFRESH;
          end else if (((oclkdelay_calib_done && wrlvl_final && ~wrlvl_done_r1) ||  // changed for new algo 3/25
                       (~wrcal_done && wrlvl_byte_redo)) && (DRAM_TYPE == "DDR3"))
            init_next_state = INIT_WRLVL_LOAD_MR2;
          else if ((~wrcal_done && (WRLVL == "ON") && (CLK_PERIOD/nCK_PER_CLK <= 2500)) 
                       && pi_dqs_found_done)
            init_next_state = INIT_WRCAL_ACT;
          else if (mem_init_done_r) begin
            if (RANKS < 2)
              init_next_state = INIT_RDLVL_ACT;
            else if (stg1_wr_done && ~rnk_ref_cnt && ~rdlvl_stg1_done)
              init_next_state = INIT_PRECHARGE;
            else
              init_next_state = INIT_RDLVL_ACT;
          end else // to DDR2 init state as part of DDR2 init sequence  
            init_next_state = INIT_REFRESH;
        end
           
	  INIT_SKIP_CALIB_WAIT:
	    if (calib_tap_inc_done)
		  init_next_state = INIT_WRCAL_ACT;
		  
           
      //******************************************************
      // Write Leveling
      //*******************************************************

      // Enable write leveling in MR1 and start write leveling
      // for current rank
      INIT_WRLVL_START:
          init_next_state = INIT_WRLVL_WAIT;

      // Wait for both MR load and write leveling to complete
      // (write leveling should take much longer than MR load..)
      INIT_WRLVL_WAIT:
        if (wrlvl_rank_done_r7 && ~(phy_ctl_full || phy_cmd_full))
          init_next_state = INIT_WRLVL_LOAD_MR;

      // Disable write leveling in MR1 for current rank
      INIT_WRLVL_LOAD_MR:
          init_next_state = INIT_WRLVL_LOAD_MR_WAIT;
        
      INIT_WRLVL_LOAD_MR_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))
          init_next_state = INIT_WRLVL_LOAD_MR2;
        
      // Load MR2 to set ODT: Dynamic ODT for single rank case
      // And ODTs for multi-rank case as well
      INIT_WRLVL_LOAD_MR2:
          init_next_state = INIT_WRLVL_LOAD_MR2_WAIT;    

      // Wait tMRD before proceeding
      INIT_WRLVL_LOAD_MR2_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin  
          //if (wrlvl_byte_done)
          //  init_next_state = INIT_PRECHARGE_PREWAIT;
      //    else if ((RANKS == 2) && wrlvl_rank_done_r2)
      //      init_next_state = INIT_WRLVL_LOAD_MR2_WAIT;
          if (~wrlvl_done_r1)
            init_next_state = INIT_WRLVL_START;
          else if (SIM_CAL_OPTION == "SKIP_CAL")
            // If skip rdlvl, then we're done
            init_next_state = INIT_DONE;
          else 
            // Otherwise, proceed to read leveling 
            //init_next_state = INIT_RDLVL_ACT;
            init_next_state = INIT_PRECHARGE_PREWAIT;
        end
          
      //*******************************************************
      // Read Leveling
      //*******************************************************      

      // single row activate. All subsequent read leveling writes and 
      // read will take place in this row      
      INIT_RDLVL_ACT:
          init_next_state = INIT_RDLVL_ACT_WAIT;

      // hang out for awhile before issuing subsequent column commands
      // it's also possible to reach this state at various points
      // during read leveling - determine what the current stage is 
      INIT_RDLVL_ACT_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin
          // Just finished an activate. Now either write, read, or precharge 
          // depending on where we are in the training sequence
          if (!pi_calib_done_r1)
            init_next_state = INIT_PI_PHASELOCK_READS;
          else if (!pi_dqs_found_done)
                 // (!pi_dqs_found_start || pi_dqs_found_rank_done))
            init_next_state = INIT_RDLVL_STG2_READ;
          else if (~wrcal_done && (WRLVL == "ON") && (CLK_PERIOD/nCK_PER_CLK <= 2500))
            init_next_state = INIT_WRCAL_ACT_WAIT;
          else if ((!rdlvl_stg1_done && ~stg1_wr_done && ~rdlvl_last_byte_done) ||
                   (!prbs_rdlvl_done && ~stg1_wr_done && ~prbs_last_byte_done)) begin
            // Added to avoid rdlvl_stg1 write data pattern at the start of PRBS rdlvl
            if (!prbs_rdlvl_done && ~stg1_wr_done && rdlvl_last_byte_done)
              init_next_state = INIT_RDLVL_ACT_WAIT;
            else
            init_next_state = INIT_RDLVL_STG1_WRITE;
          end else if ((!rdlvl_stg1_done && rdlvl_stg1_start_int) || !prbs_rdlvl_done) begin
            if (rdlvl_last_byte_done || prbs_last_byte_done)
            // Added to avoid extra reads at the end of read leveling
              init_next_state = INIT_RDLVL_ACT_WAIT;
            else begin
            // Case 2: If in stage 1, and just precharged after training
            //   previous byte, then continue reading
               if (rdlvl_stg1_done)
                init_next_state = INIT_RDLVL_STG1_WRITE_READ;
               else
                init_next_state = INIT_RDLVL_STG1_READ;
            end
          end else if ((prbs_rdlvl_done && rdlvl_stg1_done && (RANKS == 1)) && (WRLVL == "ON") &&
                        (CLK_PERIOD/nCK_PER_CLK > 2500))
            init_next_state = INIT_WRCAL_ACT_WAIT;
          else
            // Otherwise, if we're finished with calibration, then precharge
            // the row - silly, because we just opened it - possible to take
            // this out by adding logic to avoid the ACT in first place. Make
            // sure that cnt_cmd_done will handle tRAS(min)
            init_next_state = INIT_PRECHARGE_PREWAIT;
        end

      //**************************************************
      // Back-to-back reads for Phaser_IN Phase locking
      // DQS to FREQ_REF clock
      //**************************************************
      
      INIT_PI_PHASELOCK_READS:
        if (pi_phase_locked_all_r3 && ~pi_phase_locked_all_r4)
          init_next_state = INIT_PRECHARGE_PREWAIT;
      
      //*********************************************      
      // Stage 1 read-leveling (write and continuous read)
      //*********************************************      

      // Write training pattern for stage 1
      // PRBS pattern of TBD length
      INIT_RDLVL_STG1_WRITE:
        // 4:1 DDR3 BL8 will require all 8 words in 1 DIV4 clock cycle
        // 2:1 DDR2/DDR3 BL8 will require 2 DIV2 clock cycles for 8 words
        // 2:1 DDR2 BL4 will require 1 DIV2 clock cycle for 4 words
        // An entire row worth of writes issued before proceeding to reads
        // The number of write is (2^column width)/burst length to accomodate
        // PRBS pattern for window detection.
        //VCCO/VCCAUX write is not done
        if ((complex_num_writes_dec == 1) && ~complex_row0_wr_done && prbs_rdlvl_done && rdlvl_stg1_done_r1)
          init_next_state = INIT_OCAL_COMPLEX_WRITE_WAIT;
        //back to back write from row1
        else if (stg1_wr_rd_cnt == 9'd1) begin
          if (rdlvl_stg1_done_r1)
            init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;
          else
            init_next_state = INIT_RDLVL_STG1_WRITE_READ;
        end

      INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT:
        if (complex_rdlvl_int_ref_req || (prbs_rdlvl_done && ~prbs_rdlvl_done_r1)) 
          init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (complex_wait_cnt == 'd15)
          //At the end of the byte, it goes to REFRESH
          init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE;
      
      INIT_RDLVL_COMPLEX_PRECHARGE:
        init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_WAIT;
        
      INIT_RDLVL_COMPLEX_PRECHARGE_WAIT:
        if (complex_rdlvl_int_ref_req || (prbs_rdlvl_done && ~prbs_rdlvl_done_r1))
          init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (complex_wait_cnt == 'd15) begin
          if (prbs_rdlvl_done || prbs_last_byte_done_r) begin // changed for new algo 3/26
		    // added condition to ensure that limit starts after rdlvl_stg1_done is asserted in the bypass complex rdlvl mode
		    if ((~prbs_rdlvl_done && complex_oclkdelay_calib_start_int) || ~lim_done)
              init_next_state = INIT_OCAL_CENTER_ACT; //INIT_OCAL_COMPLEX_ACT; // changed for new algo 3/26
			else if (lim_done && complex_oclkdelay_calib_start_r2)
			  init_next_state = INIT_RDLVL_COMPLEX_ACT;
			else
			  init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_WAIT;
          end else
		    init_next_state = INIT_RDLVL_COMPLEX_ACT;
		end
            
         
      INIT_RDLVL_COMPLEX_ACT:
        //only for sampling boundary it need to wait
        //when initial pi dec is not done in complex per-bit, it need to wait 
        if(prbs_rdlvl_start && (num_samples_done_r || ~complex_init_pi_dec_done))
          init_next_state = INIT_RDLVL_COMPLEX_PI_WAIT;
        else init_next_state = INIT_RDLVL_COMPLEX_ACT_WAIT;

      //wait PI movement is done before proceeding read
      INIT_RDLVL_COMPLEX_PI_WAIT:
        if(complex_pi_incdec_done) 
          init_next_state = INIT_RDLVL_COMPLEX_ACT_WAIT;
        
      INIT_RDLVL_COMPLEX_ACT_WAIT:  
        if (complex_rdlvl_int_ref_req || prech_req_posedge_r)  //prech req always happen in this state
          init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (complex_wait_cnt == 'd15) begin
          if (oclkdelay_center_calib_start)
            init_next_state = INIT_OCAL_CENTER_WRITE_WAIT;
          else if (stg1_wr_done)
            init_next_state = INIT_RDLVL_COMPLEX_READ;
          else if (~complex_row1_wr_done)
            if (complex_oclkdelay_calib_start_int && complex_ocal_num_samples_done_r) //WAIT for resume signal for write
              init_next_state = INIT_OCAL_COMPLEX_RESUME_WAIT;
            else 
              init_next_state = INIT_RDLVL_STG1_WRITE;
          else
            init_next_state = INIT_RDLVL_STG1_WRITE_READ;
        end
      
      // Write-read turnaround
      INIT_RDLVL_STG1_WRITE_READ: 
        if (reset_rd_addr_r1)
          init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;
        else if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))begin
          if (rdlvl_stg1_done_r1)
           //before going to read, wait for PI inc/dec done
            init_next_state = INIT_RDLVL_COMPLEX_PI_WAIT; 
          else
            init_next_state = INIT_RDLVL_STG1_READ;
        end

      // Continuous read, where interruptible by precharge request from
      // calibration logic. Also precharges when stage 1 is complete
      // No precharges when reads provided to Phaser_IN for phase locking
      // FREQ_REF to read DQS since data integrity is not important.
      INIT_RDLVL_STG1_READ:
        if (rdlvl_stg1_rank_done || (rdlvl_stg1_done && ~rdlvl_stg1_done_r1) ||
            prech_req_posedge_r || (prbs_rdlvl_done && ~prbs_rdlvl_done_r1))
          init_next_state = INIT_PRECHARGE_PREWAIT;

      INIT_RDLVL_COMPLEX_READ:
        if (prech_req_posedge_r || (prbs_rdlvl_done && ~prbs_rdlvl_done_r1))
          init_next_state = INIT_PRECHARGE_PREWAIT;  
       //For non-back-to-back reads from row0 (VCCO and VCCAUX pattern)
        else if (~prbs_rdlvl_done && (complex_num_reads_dec == 1) && ~complex_row0_rd_done) 
          init_next_state = INIT_RDLVL_COMPLEX_READ_WAIT;
        //For back-to-back reads from row1 (ISI pattern)
        else if (stg1_wr_rd_cnt == 'd1)
          init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;

      INIT_RDLVL_COMPLEX_READ_WAIT:
        if (prech_req_posedge_r || complex_rdlvl_int_ref_req || (prbs_rdlvl_done && ~prbs_rdlvl_done_r1))
            init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (stg1_wr_rd_cnt == 'd1)
          init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;
        else if (complex_wait_cnt == 'd15)
          init_next_state = INIT_RDLVL_COMPLEX_READ;        

      
      //*********************************************      
      // DQSFOUND calibration (set of 4 reads with gaps)
      //*********************************************   

      // Read of training data. Note that Stage 2 is not a constant read, 
      // instead there is a large gap between each set of back-to-back reads
      INIT_RDLVL_STG2_READ:
        // 4 read commands issued back-to-back
        if (num_reads == 'b1)
          init_next_state = INIT_RDLVL_STG2_READ_WAIT;

      // Wait before issuing the next set of reads. If a precharge request
      // comes in then handle - this can occur after stage 2 calibration is
      // completed for a DQS group
      INIT_RDLVL_STG2_READ_WAIT:
        if (~(phy_ctl_full || phy_cmd_full)) begin
          if (pi_dqs_found_rank_done ||
              pi_dqs_found_done || prech_req_posedge_r)
            init_next_state = INIT_PRECHARGE_PREWAIT;
          else if (cnt_cmd_done_r)
              init_next_state = INIT_RDLVL_STG2_READ;
        end
      
      
      //******************************************************************
      // MPR Read Leveling for DDR3 OCLK_DELAYED calibration
      //******************************************************************
      
      // Issue Load Mode Register 3 command with A[2]=1, A[1:0]=2'b00
      // to enable Multi Purpose Register (MPR) Read
      INIT_MPR_RDEN:
        init_next_state = INIT_MPR_WAIT;
        
      //Wait tMRD, tMOD
      INIT_MPR_WAIT:
        if (cnt_cmd_done_r) begin
          init_next_state = INIT_MPR_READ;
        end
      
      // Issue back-to-back read commands to read from MPR with
      // Address bus 0x0000 for BL=8. DQ[0] will output the pre-defined
      // MPR pattern of 01010101 (Rise0 = 1'b0, Fall0 = 1'b1 ...)
      INIT_MPR_READ:
        if (mpr_rdlvl_done || mpr_rnk_done || rdlvl_prech_req)
          init_next_state = INIT_MPR_DISABLE_PREWAIT;
      
      INIT_MPR_DISABLE_PREWAIT:
        if (cnt_cmd_done_r)
          init_next_state = INIT_MPR_DISABLE;
      
      // Issue Load Mode Register 3 command with A[2]=0 to disable
      // MPR read
      INIT_MPR_DISABLE:
        init_next_state = INIT_MPR_DISABLE_WAIT;
        
      INIT_MPR_DISABLE_WAIT:
        init_next_state = INIT_PRECHARGE_PREWAIT;
      
      
      //***********************************************************************
      // OCLKDELAY Calibration
      //***********************************************************************
      
      // This calibration requires single write followed by single read to
      // determine the Phaser_Out stage 3 delay required to center write DQS
      // in write DQ valid window.
      
      // Single Row Activate command before issuing Write command
      INIT_OCLKDELAY_ACT:
        init_next_state = INIT_OCLKDELAY_ACT_WAIT;
      
      INIT_OCLKDELAY_ACT_WAIT:
        if (cnt_cmd_done_r && ~oclk_prech_req)
          init_next_state = INIT_OCLKDELAY_WRITE;
        else if (oclkdelay_calib_done || prech_req_posedge_r)
          init_next_state = INIT_PRECHARGE_PREWAIT;
          
      INIT_OCLKDELAY_WRITE:
        if (oclk_wr_cnt == 4'd1)
        init_next_state = INIT_OCLKDELAY_WRITE_WAIT;
      
      INIT_OCLKDELAY_WRITE_WAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin
          if (oclkdelay_int_ref_req)
            init_next_state = INIT_PRECHARGE_PREWAIT;
          else			
            init_next_state = INIT_OCLKDELAY_READ;
		end
      
      INIT_OCLKDELAY_READ:
        init_next_state = INIT_OCLKDELAY_READ_WAIT;

      INIT_OCLKDELAY_READ_WAIT:
        if (~(phy_ctl_full || phy_cmd_full)) begin
          if ((oclk_calib_resume_level || oclk_calib_resume) && ~oclkdelay_int_ref_req)
            init_next_state = INIT_OCLKDELAY_WRITE;
          else if (oclkdelay_calib_done || prech_req_posedge_r ||
                   wrlvl_final || oclkdelay_int_ref_req)
            init_next_state = INIT_PRECHARGE_PREWAIT;
		  else if (oclkdelay_center_calib_start)
		    init_next_state = INIT_OCAL_CENTER_WRITE_WAIT;
        end
      
      
      //*********************************************      
      // Write calibration                                  
      //*********************************************

      // single row activate      
      INIT_WRCAL_ACT:
          init_next_state = INIT_WRCAL_ACT_WAIT;

      // hang out for awhile before issuing subsequent column command
      INIT_WRCAL_ACT_WAIT:
        if (cnt_cmd_done_r && ~wrcal_prech_req)
          init_next_state = INIT_WRCAL_WRITE;
        else if (wrcal_done || prech_req_posedge_r)
          init_next_state = INIT_PRECHARGE_PREWAIT;                                  

      // Write training pattern for write calibration
      INIT_WRCAL_WRITE:
        // Once we've issued enough commands for 8 words - proceed to reads
        //if (burst_addr_r == 1'b1)
        if (wrcal_wr_cnt == 4'd1)
          init_next_state = INIT_WRCAL_WRITE_READ;

      // Write-read turnaround
      INIT_WRCAL_WRITE_READ: 
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) 
          init_next_state = INIT_WRCAL_READ;
        else if (dqsfound_retry)
            init_next_state = INIT_RDLVL_STG2_READ_WAIT;


      INIT_WRCAL_READ:
        if (burst_addr_r == 1'b1)
          init_next_state = INIT_WRCAL_READ_WAIT;
          
      INIT_WRCAL_READ_WAIT:
        if (~(phy_ctl_full || phy_cmd_full)) begin
          if (wrcal_resume_r) begin
            if (wrcal_final_chk)
              init_next_state = INIT_WRCAL_READ;
            else
              init_next_state = INIT_WRCAL_WRITE;
          end else if (wrcal_done || prech_req_posedge_r || wrcal_act_req ||
          // Added to support PO fine delay inc when TG errors
                  wrlvl_byte_redo || (temp_wrcal_done && ~temp_lmr_done))
            init_next_state = INIT_PRECHARGE_PREWAIT;
          else if (dqsfound_retry)
            init_next_state = INIT_RDLVL_STG2_READ_WAIT;
          else if (wrcal_read_req && cnt_wrcal_rd)
            init_next_state = INIT_WRCAL_MULT_READS;
        end        

      INIT_WRCAL_MULT_READS:
        // multiple read commands issued back-to-back
        if (wrcal_reads == 'b1)
          init_next_state = INIT_WRCAL_READ_WAIT;        

      //*********************************************      
      // Handling of precharge during and in between read-level stages
      //*********************************************   

      // Make sure we aren't violating any timing specs by precharging
      //  immediately
      INIT_PRECHARGE_PREWAIT:
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full))
          init_next_state = INIT_PRECHARGE;                
                                     
      // Initiate precharge
      INIT_PRECHARGE: 
        init_next_state = INIT_PRECHARGE_WAIT; 

      INIT_PRECHARGE_WAIT: 
        if (cnt_cmd_done_r && ~(phy_ctl_full || phy_cmd_full)) begin
          if ((wrcal_sanity_chk_done && (DRAM_TYPE == "DDR3")) || 
              (rdlvl_stg1_done && prbs_rdlvl_done && pi_dqs_found_done && 
              (DRAM_TYPE == "DDR2")))
             init_next_state = INIT_DONE;               
          else if ((wrcal_done || (WRLVL == "OFF")) && rdlvl_stg1_done && prbs_rdlvl_done &&
             pi_dqs_found_done && complex_oclkdelay_calib_done && wrlvl_done_r1 && ((ddr3_lm_done_r) || (DRAM_TYPE == "DDR2")))
             init_next_state = INIT_WRCAL_ACT;             
          else if ((wrcal_done || (WRLVL == "OFF") || (~wrcal_done && temp_wrcal_done && ~temp_lmr_done)) 
                   && (rdlvl_stg1_done || (~wrcal_done && temp_wrcal_done && ~temp_lmr_done)) 
                   && prbs_rdlvl_done && complex_oclkdelay_calib_done && wrlvl_done_r1 &rdlvl_stg1_done && pi_dqs_found_done) begin
           // after all calibration program the correct burst length
            init_next_state = INIT_LOAD_MR; 
          // Added to support PO fine delay inc when TG errors
          end else if (~wrcal_done && temp_wrcal_done && temp_lmr_done)
            init_next_state = INIT_WRCAL_READ_WAIT;
          else if (rdlvl_stg1_done && pi_dqs_found_done && (WRLVL == "ON"))
            // If read leveling finished, proceed to write calibration
            init_next_state = INIT_REFRESH; 
          else
            // Otherwise, open row for read-leveling purposes
            init_next_state = INIT_REFRESH;
        end
          
      //*******************************************************
      // COMPLEX OCLK calibration - for fragmented write
      //*******************************************************      
      INIT_OCAL_COMPLEX_ACT:
        init_next_state = INIT_OCAL_COMPLEX_ACT_WAIT;
      
      INIT_OCAL_COMPLEX_ACT_WAIT:
        if (complex_wait_cnt =='d15)
          init_next_state = INIT_RDLVL_STG1_WRITE;
          
      INIT_OCAL_COMPLEX_WRITE_WAIT:
        if (prech_req_posedge_r || (complex_oclkdelay_calib_done && ~complex_oclkdelay_calib_done_r1))
            init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (stg1_wr_rd_cnt == 'd1)
          init_next_state = INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT;
        else if (complex_wait_cnt == 'd15)
          init_next_state = INIT_RDLVL_STG1_WRITE;    
    
      //wait for all srg2/stg3 tap movement is done and go back to write again    
      INIT_OCAL_COMPLEX_RESUME_WAIT:
        if (complex_oclk_calib_resume)
          init_next_state = INIT_RDLVL_STG1_WRITE;        
        else if (complex_oclkdelay_calib_done || complex_ocal_ref_req )        
            init_next_state = INIT_PRECHARGE_PREWAIT;          

      //*******************************************************
      // OCAL STG3 Centering calibration 
      //*******************************************************
      INIT_OCAL_CENTER_ACT: 
        init_next_state = INIT_OCAL_CENTER_ACT_WAIT;
          
      INIT_OCAL_CENTER_ACT_WAIT:
	    if (ocal_act_wait_cnt == 'd15)
	      init_next_state = INIT_OCAL_CENTER_WRITE_WAIT;
	  
	  INIT_OCAL_CENTER_WRITE:
        if(!oclk_center_write_resume && !lim_wr_req)
          init_next_state = INIT_OCAL_CENTER_WRITE_WAIT;
      
      INIT_OCAL_CENTER_WRITE_WAIT:
	    //if (oclkdelay_center_calib_done || prech_req_posedge_r)
		if (prech_req_posedge_r)
          init_next_state = INIT_PRECHARGE_PREWAIT;
        else if (lim_done && ~mask_lim_done && ~complex_mask_lim_done && oclkdelay_calib_done && ~oclkdelay_center_calib_start)
		  init_next_state = INIT_OCAL_COMPLEX_ACT_WAIT;
		else if (lim_done && ~mask_lim_done && ~complex_mask_lim_done && ~oclkdelay_center_calib_start)
		  init_next_state = INIT_OCLKDELAY_READ_WAIT; 
        else if (oclk_center_write_resume || lim_wr_req)
          init_next_state = INIT_OCAL_CENTER_WRITE;
     
      //*******************************************************
      // Initialization/Calibration done. Take a long rest, relax
      //*******************************************************

      INIT_DONE:
        init_next_state = INIT_DONE;

    endcase
  end
      
  //*****************************************************************
  // Initialization done signal - asserted before leveling starts
  //*****************************************************************

 
  always @(posedge clk)
    if (rst)
      mem_init_done_r <= #TCQ 1'b0;
    else if ((!cnt_dllk_zqinit_done_r && 
             (cnt_dllk_zqinit_r == TDLLK_TZQINIT_DELAY_CNT) &&
             (chip_cnt_r == RANKS-1) && (DRAM_TYPE == "DDR3"))
              || ( (init_state_r == INIT_LOAD_MR_WAIT) &&
             (ddr2_refresh_flag_r) && (chip_cnt_r == RANKS-1)
             && (cnt_init_mr_done_r) && (DRAM_TYPE == "DDR2")))
      mem_init_done_r <= #TCQ 1'b1;
  
  //*****************************************************************
  // Write Calibration signal to PHY Control Block - asserted before
  // Write Leveling starts
  //*****************************************************************

  //generate
  //if (RANKS < 2) begin: ranks_one
    always @(posedge clk) begin
      if (rst || (done_dqs_tap_inc &&
         (init_state_r == INIT_WRLVL_LOAD_MR2)))
        write_calib <= #TCQ 1'b0;
      else if (wrlvl_active_r1)
        write_calib <= #TCQ 1'b1;
    end
  //end else begin: ranks_two
  //  always @(posedge clk) begin
  //    if (rst || 
  //       ((init_state_r1 == INIT_WRLVL_LOAD_MR_WAIT) && 
  //         ((wrlvl_rank_done_r2 && (chip_cnt_r == RANKS-1)) || 
  //         (SIM_CAL_OPTION == "FAST_CAL"))))
  //      write_calib <= #TCQ 1'b0;
  //    else if (wrlvl_active_r1)
  //      write_calib <= #TCQ 1'b1;
  //  end
  //end
  //endgenerate
  
  //*****************************************************************
  // Read Calibration signal to PHY Control Block - asserted after
  // Write Leveling during PHASER_IN phase locking stage.
  // Must be de-asserted before Read Leveling
  //*****************************************************************
  
  always @(posedge clk) begin
    if (rst || pi_calib_done_r1)
      read_calib_int <= #TCQ 1'b0;
    else if (~pi_calib_done_r1 && (init_state_r == INIT_RDLVL_ACT_WAIT) &&
            (cnt_cmd_r == CNTNEXT_CMD))
      read_calib_int <= #TCQ 1'b1;
  end
  
  always @(posedge clk)
    read_calib_r <= #TCQ read_calib_int;
 
  
  always @(posedge clk) begin
    if (rst || pi_calib_done_r1)
      read_calib <= #TCQ 1'b0;
    else if (~pi_calib_done_r1 && (init_state_r == INIT_PI_PHASELOCK_READS))
      read_calib <= #TCQ 1'b1;
  end

  
  always @(posedge clk)
    if (rst)
      pi_calib_done_r <= #TCQ 1'b0;
    else if (pi_calib_rank_done_r)// && (chip_cnt_r == RANKS-1))
      pi_calib_done_r <= #TCQ 1'b1;
      
  always @(posedge clk)
    if (rst)
      pi_calib_rank_done_r <= #TCQ 1'b0;
    else if (pi_phase_locked_all_r3 && ~pi_phase_locked_all_r4)
      pi_calib_rank_done_r <= #TCQ 1'b1;
    else
      pi_calib_rank_done_r <= #TCQ 1'b0;

  always @(posedge clk) begin
    if (rst || ((PRE_REV3ES == "ON") && temp_wrcal_done && ~temp_wrcal_done_r))
      pi_phaselock_timer <= #TCQ 'd0;
    else if (((init_state_r == INIT_PI_PHASELOCK_READS) &&
             (pi_phaselock_timer != PHASELOCKED_TIMEOUT)) ||
             tg_timer_go)
      pi_phaselock_timer <= #TCQ pi_phaselock_timer + 1;
    else
      pi_phaselock_timer <= #TCQ pi_phaselock_timer;
  end
  
  assign pi_phase_locked_err = (pi_phaselock_timer == PHASELOCKED_TIMEOUT) ? 1'b1 : 1'b0;

  //*****************************************************************
  // DDR3 final burst length programming done. For DDR3 during
  // calibration the burst length is fixed to BL8. After calibration
  // the correct burst length is programmed. 
  //*****************************************************************
  always @(posedge clk)
    if (rst)
      ddr3_lm_done_r <= #TCQ 1'b0;
    else if ((init_state_r == INIT_LOAD_MR_WAIT) &&
            (chip_cnt_r == RANKS-1) && wrcal_done)
      ddr3_lm_done_r <= #TCQ 1'b1;

  always @(posedge clk) begin
    pi_dqs_found_rank_done_r <= #TCQ pi_dqs_found_rank_done;
    pi_phase_locked_all_r1   <= #TCQ pi_phase_locked_all;
    pi_phase_locked_all_r2   <= #TCQ pi_phase_locked_all_r1;
    pi_phase_locked_all_r3   <= #TCQ pi_phase_locked_all_r2;
    pi_phase_locked_all_r4   <= #TCQ pi_phase_locked_all_r3;
    pi_dqs_found_all_r       <= #TCQ pi_dqs_found_done;
    pi_calib_done_r1         <= #TCQ pi_calib_done_r;
  end
     
  //***************************************************************************
  // Logic for deep memory (multi-rank) configurations
  //***************************************************************************

  // For DDR3 asserted when  

generate
  if (RANKS < 2) begin: single_rank
    always @(posedge clk)
      chip_cnt_r <= #TCQ 2'b00;
  end else begin: dual_rank  
    always @(posedge clk)
      if (rst ||
         // Set chip_cnt_r to 2'b00 after both Ranks are read leveled 
         (rdlvl_stg1_done && prbs_rdlvl_done && ~wrcal_done && (SKIP_CALIB == "FALSE")) ||
         // Set chip_cnt_r to 2'b00 after both Ranks are write leveled 
         (wrlvl_done_r &&
         (init_state_r==INIT_WRLVL_LOAD_MR2_WAIT)))begin 
        chip_cnt_r <= #TCQ 2'b00;
      end else if ((((init_state_r == INIT_WAIT_DLLK_ZQINIT) &&
               (cnt_dllk_zqinit_r == TDLLK_TZQINIT_DELAY_CNT)) && 
               (DRAM_TYPE == "DDR3")) ||
               ((init_state_r==INIT_REFRESH_RNK2_WAIT) &&
               (cnt_cmd_r=='d36)) ||
               //mpr_rnk_done ||
               //(rdlvl_stg1_rank_done && ~rdlvl_last_byte_done)  ||
               //(stg1_wr_done && (init_state_r == INIT_REFRESH) &&
               //~(rnk_ref_cnt && rdlvl_last_byte_done)) ||
               
               // Increment chip_cnt_r to issue Refresh to second rank
               (~pi_dqs_found_all_r &&
               (init_state_r==INIT_PRECHARGE_PREWAIT) &&
               (cnt_cmd_r=='d36) && (SKIP_CALIB == "FALSE")) ||
               
               // Increment chip_cnt_r when DQSFOUND done for the Rank
               (pi_dqs_found_rank_done && ~pi_dqs_found_rank_done_r && (SKIP_CALIB == "FALSE")) ||
               ((init_state_r == INIT_LOAD_MR_WAIT)&& cnt_cmd_done_r 
               && wrcal_done) ||
               ((init_state_r == INIT_DDR2_MULTI_RANK)
                  && (DRAM_TYPE == "DDR2"))) begin
        if ((~mem_init_done_r || ~rdlvl_stg1_done || ~pi_dqs_found_done ||
            // condition to increment chip_cnt during
            // final burst length programming for DDR3 
           ~pi_calib_done_r || wrcal_done) //~mpr_rdlvl_done || 
           && (chip_cnt_r != RANKS-1)) 
          chip_cnt_r <= #TCQ chip_cnt_r + 1;
        else
          chip_cnt_r <= #TCQ 2'b00;
    end
  end
  endgenerate  
// verilint STARC-2.2.3.3 off
generate
   if ((REG_CTRL == "ON") && (RANKS == 1)) begin: DDR3_RDIMM_1rank
     always @(posedge clk) begin
       if (rst)
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
       else if (init_state_r == INIT_REG_WRITE) begin
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         if(!(CWL_M%2)) begin
           phy_int_cs_n[0%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[1%nCK_PER_CLK] <= #TCQ 1'b0;
         end else begin
           phy_int_cs_n[2%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[3%nCK_PER_CLK] <= #TCQ 1'b0;
     end
       end else if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||  
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
         phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         if (!(CWL_M % 2)) //even CWL 
           phy_int_cs_n[0] <= #TCQ 1'b0;
         else // odd CWL
           phy_int_cs_n[1*nCS_PER_RANK] <= #TCQ 1'b0;
       end else
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
     end
   end else if (RANKS == 1) begin: DDR3_1rank
     always @(posedge clk) begin
       if (rst)
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
       else if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||  
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
         phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         if (!(CWL_M % 2)) begin //even CWL
           for (n = 0; n < nCS_PER_RANK; n = n + 1) begin 
             phy_int_cs_n[n] <= #TCQ 1'b0;
           end
         end else begin //odd CWL
           for (p = nCS_PER_RANK; p < 2*nCS_PER_RANK; p = p + 1) begin 
             phy_int_cs_n[p] <= #TCQ 1'b0;
           end
         end
       end else
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
     end
   end else if ((REG_CTRL == "ON") && (RANKS == 2)) begin: DDR3_2rank
     always @(posedge clk) begin
       if (rst)
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
       else if (init_state_r == INIT_REG_WRITE) begin
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         if(!(CWL_M%2)) begin
           phy_int_cs_n[0%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[1%nCK_PER_CLK] <= #TCQ 1'b0;
         end else begin
           phy_int_cs_n[2%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[3%nCK_PER_CLK] <= #TCQ 1'b0;
         end
       end else begin
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         case (chip_cnt_r)
           2'b00:begin
             if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||    
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||  
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
               phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
               if (!(CWL_M % 2)) //even CWL 
                 phy_int_cs_n[0] <= #TCQ 1'b0;
               else // odd CWL
                 phy_int_cs_n[1*CS_WIDTH*nCS_PER_RANK] <= #TCQ 1'b0;
             end else
               phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
             //for (n = 0; n < nCS_PER_RANK*nCK_PER_CLK*2; n = n + (nCS_PER_RANK*2)) begin 
             //
             //  phy_int_cs_n[n+:nCS_PER_RANK] <= #TCQ {nCS_PER_RANK{1'b0}};
             //end
           end
           2'b01:begin
             if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                     (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
               phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
               if (!(CWL_M % 2)) //even CWL 
                 phy_int_cs_n[1] <= #TCQ 1'b0;
               else // odd CWL
                 phy_int_cs_n[1+1*CS_WIDTH*nCS_PER_RANK] <= #TCQ 1'b0;
             end else
               phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
             //for (p = nCS_PER_RANK; p < nCS_PER_RANK*nCK_PER_CLK*2; p = p + (nCS_PER_RANK*2)) begin 
             //
             //  phy_int_cs_n[p+:nCS_PER_RANK] <= #TCQ {nCS_PER_RANK{1'b0}};
             //end
           end
         endcase
       end
     end
   end else if (RANKS == 2) begin: DDR3_2rank
     always @(posedge clk) begin
       if (rst)
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
       else if (init_state_r == INIT_REG_WRITE) begin
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         if(!(CWL_M%2)) begin
           phy_int_cs_n[0%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[1%nCK_PER_CLK] <= #TCQ 1'b0;
         end else begin
           phy_int_cs_n[2%nCK_PER_CLK] <= #TCQ 1'b0;
           phy_int_cs_n[3%nCK_PER_CLK] <= #TCQ 1'b0;
     end
       end else begin
         phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
         case (chip_cnt_r)
           2'b00:begin
             if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
               phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
               if (!(CWL_M % 2)) begin //even CWL 
                 for (n = 0; n < nCS_PER_RANK; n = n + 1) begin 
                   phy_int_cs_n[n] <= #TCQ 1'b0;
                 end
               end else begin // odd CWL
                 for (p = CS_WIDTH*nCS_PER_RANK; p < (CS_WIDTH*nCS_PER_RANK + nCS_PER_RANK); p = p + 1) begin
                   phy_int_cs_n[p] <= #TCQ 1'b0;
                 end
               end
             end else
               phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
             //for (n = 0; n < nCS_PER_RANK*nCK_PER_CLK*2; n = n + (nCS_PER_RANK*2)) begin 
             //
             //  phy_int_cs_n[n+:nCS_PER_RANK] <= #TCQ {nCS_PER_RANK{1'b0}};
             //end
           end
           2'b01:begin
             if ((init_state_r == INIT_LOAD_MR) ||
                    (init_state_r == INIT_MPR_RDEN) ||
                    (init_state_r == INIT_MPR_DISABLE) ||
                    (init_state_r == INIT_WRLVL_START) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR) ||
                    (init_state_r == INIT_WRLVL_LOAD_MR2) ||
                    (init_state_r == INIT_ZQCL) ||
                    (init_state_r == INIT_RDLVL_ACT) ||
                    (init_state_r == INIT_WRCAL_ACT) ||
                    (init_state_r == INIT_OCLKDELAY_ACT) ||
                    (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                    (init_state_r == INIT_OCAL_CENTER_ACT) ||
                    (init_state_r == INIT_PRECHARGE) ||
                    (init_state_r == INIT_DDR2_PRECHARGE) ||
                    (init_state_r == INIT_REFRESH) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
                    (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                    (rdlvl_wr_rd && new_burst_r && ~mmcm_wr)) begin
               phy_int_cs_n    <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
               if (!(CWL_M % 2)) begin //even CWL
                 for (q = nCS_PER_RANK; q < (2 * nCS_PER_RANK); q = q + 1) begin 
                   phy_int_cs_n[q] <= #TCQ 1'b0;
                 end
               end else begin // odd CWL
                 for (m = (nCS_PER_RANK*CS_WIDTH + nCS_PER_RANK); m < (nCS_PER_RANK*CS_WIDTH + 2*nCS_PER_RANK); m = m + 1) begin
                   phy_int_cs_n[m] <= #TCQ 1'b0;
                 end
               end
             end else
               phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
             //for (p = nCS_PER_RANK; p < nCS_PER_RANK*nCK_PER_CLK*2; p = p + (nCS_PER_RANK*2)) begin 
             //
             //  phy_int_cs_n[p+:nCS_PER_RANK] <= #TCQ {nCS_PER_RANK{1'b0}};
             //end
           end
         endcase
       end
     end // always @ (posedge clk)
  end 
// verilint STARC-2.2.3.3  on
  // commented out for now. Need it for DDR2 2T timing 
 /*  end else begin: DDR2
  always @(posedge clk)
    if (rst) begin
      phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
    end else begin
      if (init_state_r == INIT_REG_WRITE) begin
        // All ranks selected simultaneously
        phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b0}};
      end else if ((wrlvl_odt) ||
          (init_state_r == INIT_LOAD_MR) ||
          (init_state_r  == INIT_ZQCL) ||
          (init_state_r == INIT_WRLVL_START) ||
          (init_state_r == INIT_WRLVL_LOAD_MR) ||
          (init_state_r == INIT_WRLVL_LOAD_MR2) ||
          (init_state_r == INIT_RDLVL_ACT) ||
          (init_state_r == INIT_PI_PHASELOCK_READS) ||
          (init_state_r == INIT_RDLVL_STG1_WRITE) ||
          (init_state_r == INIT_RDLVL_STG1_READ) ||
          (init_state_r == INIT_PRECHARGE) ||
          (init_state_r == INIT_RDLVL_STG2_READ) ||
          (init_state_r == INIT_WRCAL_ACT) ||
          (init_state_r == INIT_WRCAL_READ) ||
          (init_state_r == INIT_WRCAL_WRITE) ||
          (init_state_r == INIT_DDR2_PRECHARGE) ||
          (init_state_r == INIT_REFRESH)) begin
          phy_int_cs_n[0] <= #TCQ 1'b0;
      end    
      else phy_int_cs_n <= #TCQ {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};   
    end // else: !if(rst)
  end // block: DDR2 */ 
endgenerate

  assign phy_cs_n = phy_int_cs_n;

  //***************************************************************************
  // Write/read burst logic for calibration
  //***************************************************************************

  assign rdlvl_wr = (init_state_r == INIT_OCLKDELAY_WRITE) ||
                    (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                    (init_state_r == INIT_RDLVL_STG1_WRITE) ||
                    (init_state_r == INIT_WRCAL_WRITE);
  assign rdlvl_rd = (init_state_r == INIT_PI_PHASELOCK_READS) ||
                    ((init_state_r == INIT_RDLVL_STG1_READ) && ~rdlvl_pi_incdec) ||  //rdlvl pi dec
                    (init_state_r == INIT_RDLVL_COMPLEX_READ) ||
                    (init_state_r == INIT_RDLVL_STG2_READ) ||
                    (init_state_r == INIT_OCLKDELAY_READ) ||
                    (init_state_r == INIT_WRCAL_READ) ||
                    ((init_state_r == INIT_MPR_READ) && ~rdlvl_pi_incdec) ||
                    (init_state_r == INIT_WRCAL_MULT_READS);
  assign rdlvl_wr_rd = rdlvl_wr | rdlvl_rd;
  assign mmcm_wr = (init_state_r == INIT_OCAL_CENTER_WRITE); //used to de-assert cs_n during centering
//  assign mmcm_wr = 'b0; // (init_state_r == INIT_OCAL_CENTER_WRITE);

  //***************************************************************************
  // Address generation and logic to count # of writes/reads issued during
  // certain stages of calibration
  //***************************************************************************

  // Column address generation logic:
  // Keep track of the current column address - since all bursts are in
  // increments of 8 only during calibration, we need to keep track of
  // addresses [COL_WIDTH-1:3], lower order address bits will always = 0

  always @(posedge clk)
    if (rst || wrcal_done)
      burst_addr_r <= #TCQ 1'b0;
    else if ((init_state_r == INIT_WRCAL_ACT_WAIT) ||
             (init_state_r == INIT_OCLKDELAY_ACT_WAIT) ||
             (init_state_r == INIT_OCLKDELAY_WRITE) ||   
             (init_state_r == INIT_OCLKDELAY_READ) ||
             (init_state_r == INIT_WRCAL_WRITE) ||
             (init_state_r == INIT_WRCAL_WRITE_READ) ||
             (init_state_r == INIT_WRCAL_READ) ||
             (init_state_r == INIT_WRCAL_MULT_READS) ||
             (init_state_r == INIT_WRCAL_READ_WAIT))
      burst_addr_r <= #TCQ 1'b1;
    else if (rdlvl_wr_rd && new_burst_r)
      burst_addr_r <= #TCQ ~burst_addr_r;
    else
      burst_addr_r <= #TCQ 1'b0;

  // Read Level Stage 1 requires writes to the entire row since 
  // a PRBS pattern is being written. This counter keeps track
  // of the number of writes which depends on the column width
  // The (stg1_wr_rd_cnt==9'd0) condition was added so the col
  // address wraps around during stage1 reads
  always @(posedge clk)
    if (rst || ((init_state_r == INIT_RDLVL_STG1_WRITE_READ) && 
             ~rdlvl_stg1_done))
      stg1_wr_rd_cnt <= #TCQ NUM_STG1_WR_RD;
    else if (rdlvl_last_byte_done || (stg1_wr_rd_cnt == 9'd1) ||
             (prbs_rdlvl_prech_req && (init_state_r == INIT_RDLVL_ACT_WAIT)) ||
             (init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) ) begin
      if (~complex_row0_wr_done || wr_victim_inc ||
         (complex_row1_wr_done && (~complex_row0_rd_done || (complex_row0_rd_done && complex_row1_rd_done))))     
        stg1_wr_rd_cnt <= #TCQ 'd127;
      else
        stg1_wr_rd_cnt <= #TCQ prbs_rdlvl_done?'d30 :'d22;
    end else if (((init_state_r == INIT_RDLVL_STG1_WRITE) && new_burst_r && ~phy_data_full)
              ||((init_state_r == INIT_RDLVL_COMPLEX_READ) && rdlvl_stg1_done))
      stg1_wr_rd_cnt <= #TCQ stg1_wr_rd_cnt - 1;
      
  always @(posedge clk)
    if (rst)
      wr_victim_inc <= #TCQ 1'b0;
    else if (complex_row0_wr_done && (stg1_wr_rd_cnt == 9'd2) && ~stg1_wr_done)
      wr_victim_inc <= #TCQ 1'b1;
    else
      wr_victim_inc <= #TCQ 1'b0;

  always @(posedge clk)
    reset_rd_addr_r1 <= #TCQ reset_rd_addr;
  
generate
  if (FIXED_VICTIM == "FALSE") begin: row_cnt_victim_rotate  
    always @(posedge clk)
      if (rst || (wr_victim_inc && (complex_row_cnt == DQ_PER_DQS*2-1)) || ~rdlvl_stg1_done_r1 || prbs_rdlvl_done)
      complex_row_cnt <= #TCQ 'd0;
    else if ((((stg1_wr_rd_cnt == 'd22) && ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) || 
	                                        (complex_rdlvl_int_ref_req && (init_state_r == INIT_REFRESH_WAIT) && (cnt_cmd_r == 'd127)))) || 
             complex_victim_inc || (complex_sample_cnt_inc_r2 && ~complex_victim_inc) || wr_victim_inc || reset_rd_addr_r1)) begin
      // During writes row count is incremented with every wr_victim_in and stg1_wr_rd_cnt=='d22
      if ((complex_row_cnt < DQ_PER_DQS*2-1) && ~stg1_wr_done)
        complex_row_cnt <= #TCQ complex_row_cnt + 1;
      // During reads row count requires different conditions for increments
      else if (stg1_wr_done) begin
          if (reset_rd_addr_r1)
            complex_row_cnt <= #TCQ 'd0; 
        // When looping multiple times in the same victim bit in a byte
        else if (complex_sample_cnt_inc_r2 && ~complex_victim_inc)
          complex_row_cnt <= #TCQ rd_victim_sel*2;
        // When looping through victim bits within a byte
        else if (complex_row_cnt < DQ_PER_DQS*2-1)
          complex_row_cnt <= #TCQ complex_row_cnt + 1;
        // When the number of samples is done and tap is incremented within a byte
        else
          complex_row_cnt <= #TCQ 'd0; 
      end
    end
  end else begin: row_cnt_victim_fixed
    always @(posedge clk)
      if (rst || ~rdlvl_stg1_done_r1 || prbs_rdlvl_done)
        complex_row_cnt <= #TCQ 'd0;
      else if ((stg1_wr_rd_cnt == 'd22) && (((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE_WAIT) && (complex_wait_cnt == 'd15)) || complex_rdlvl_int_ref_req))
        complex_row_cnt <= #TCQ 'd1;
      else
        complex_row_cnt <= #TCQ 'd0;
  end
endgenerate

//row count 

    always @(posedge clk)
      if (rst || (wr_victim_inc && (complex_row_cnt_ocal == COMPLEX_ROW_CNT_BYTE-1)) || ~rdlvl_stg1_done_r1 || prbs_rdlvl_done_pulse || complex_byte_rd_done)
        complex_row_cnt_ocal <= #TCQ 'd0;
      else if ( prbs_rdlvl_done && (((stg1_wr_rd_cnt == 'd30) && (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE)) || 
             (complex_sample_cnt_inc_r2) || wr_victim_inc)) begin
        // During writes row count is incremented with every wr_victim_in and stg1_wr_rd_cnt=='d22
        if (complex_row_cnt_ocal < COMPLEX_ROW_CNT_BYTE-1)  begin
          complex_row_cnt_ocal <= #TCQ complex_row_cnt_ocal + 1;
    end
    end    
    
  always @(posedge clk)
    if (rst)
      complex_odt_ext <= #TCQ 1'b0;
    else if ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) || (init_state_r == INIT_PRECHARGE))
      complex_odt_ext <= #TCQ 1'b0;
    else if (rdlvl_stg1_done_r1 && (stg1_wr_rd_cnt == 9'd1) && (init_state_r == INIT_RDLVL_STG1_WRITE))
      complex_odt_ext <= #TCQ 1'b1;
  
  always @(posedge clk)
    if (rst || (wr_victim_inc && (complex_row_cnt == DQ_PER_DQS*2-1))) begin  
      wr_victim_sel <= #TCQ 'd0;
    end else if (rdlvl_stg1_done_r1 && wr_victim_inc) begin
      wr_victim_sel <= #TCQ wr_victim_sel + 1;
    end
    
  always @(posedge clk)
    if (rst) begin
      wr_victim_sel_ocal <= #TCQ 'd0;
    end else if (wr_victim_inc && (complex_row_cnt_ocal == COMPLEX_ROW_CNT_BYTE-1)) begin
      wr_victim_sel_ocal <= #TCQ 'd0;
    end else if (prbs_rdlvl_done && wr_victim_inc) begin
      wr_victim_sel_ocal <= #TCQ wr_victim_sel_ocal + 1;
    end

  always @(posedge clk)
    if (rst) begin
      victim_sel      <= #TCQ 'd0;
      victim_byte_cnt <= #TCQ 'd0;
    end else if ((~stg1_wr_done && ~prbs_rdlvl_done) || (prbs_rdlvl_done && ~complex_wr_done)) begin
      victim_sel      <= #TCQ prbs_rdlvl_done? wr_victim_sel_ocal: wr_victim_sel;
      victim_byte_cnt <= #TCQ 'd0; 
    end else begin
      if( (init_state_r == INIT_RDLVL_COMPLEX_ACT) || reset_rd_addr)
        victim_sel      <= #TCQ prbs_rdlvl_done? complex_ocal_rd_victim_sel:rd_victim_sel;  
        victim_byte_cnt <= #TCQ 'd0; 
    end
  
generate
  if (FIXED_VICTIM == "FALSE") begin: wr_done_victim_rotate
    always @(posedge clk)
      if (rst || (wr_victim_inc && (complex_row_cnt < DQ_PER_DQS*2-1) && ~prbs_rdlvl_done) ||  
                  (wr_victim_inc && prbs_rdlvl_done && complex_row_cnt_ocal <COMPLEX_ROW_CNT_BYTE-1) ||
               complex_byte_rd_done || prbs_rdlvl_done_pulse) begin  
      complex_row0_wr_done    <= #TCQ 1'b0;
      end else if ( rdlvl_stg1_done_r1 && (stg1_wr_rd_cnt == 9'd2)) begin
      complex_row0_wr_done    <= #TCQ 1'b1;
    end
    
    always @(posedge clk)
      if (rst || (wr_victim_inc && (complex_row_cnt < DQ_PER_DQS*2-1) && ~prbs_rdlvl_done) ||  
                 (wr_victim_inc && prbs_rdlvl_done && complex_row_cnt_ocal <COMPLEX_ROW_CNT_BYTE-1) || 
                     complex_byte_rd_done || prbs_rdlvl_done_pulse) begin  
      complex_row1_wr_done    <= #TCQ 1'b0;
      end else if (complex_row0_wr_done && (stg1_wr_rd_cnt == 9'd2)) begin
      complex_row1_wr_done    <= #TCQ 1'b1;
    end
  end else begin: wr_done_victim_fixed
    always @(posedge clk)
      if (rst || prbs_rdlvl_done_pulse ||
                (wr_victim_inc && prbs_rdlvl_done && complex_row_cnt_ocal <COMPLEX_ROW_CNT_BYTE-1) || 
        complex_byte_rd_done ) begin
        complex_row0_wr_done    <= #TCQ 1'b0;
      end else if (rdlvl_stg1_done_r1 && (stg1_wr_rd_cnt == 9'd2)) begin
        complex_row0_wr_done    <= #TCQ 1'b1;
    end
    
    always @(posedge clk)
      if (rst || prbs_rdlvl_done_pulse ||
              (wr_victim_inc && prbs_rdlvl_done && complex_row_cnt_ocal <COMPLEX_ROW_CNT_BYTE-1) || 
                        complex_byte_rd_done ) begin
        complex_row1_wr_done    <= #TCQ 1'b0;
      end else if (complex_row0_wr_done && (stg1_wr_rd_cnt == 9'd2)) begin
      complex_row1_wr_done    <= #TCQ 1'b1;
    end
  end
endgenerate
    
  always @(posedge clk)
    if (rst || prbs_rdlvl_done_pulse)
      complex_row0_rd_done    <= #TCQ 1'b0;
    else if (complex_sample_cnt_inc)
      complex_row0_rd_done    <= #TCQ 1'b0;
    else if ( (prbs_rdlvl_start || complex_oclkdelay_calib_start_int) && (stg1_wr_rd_cnt == 9'd2) && complex_row0_wr_done && complex_row1_wr_done)
      complex_row0_rd_done    <= #TCQ 1'b1;
      
  always @(posedge clk)
    complex_row0_rd_done_r1 <= #TCQ complex_row0_rd_done;
    
  always @(posedge clk)
    if (rst || prbs_rdlvl_done_pulse)
      complex_row1_rd_done    <= #TCQ 1'b0;
    else if ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) || (init_state_r == INIT_PRECHARGE))
      complex_row1_rd_done    <= #TCQ 1'b0;
    else if (complex_row0_rd_done && (stg1_wr_rd_cnt == 9'd2))
      complex_row1_rd_done    <= #TCQ 1'b1;
      
  always @(posedge clk)
    complex_row1_rd_done_r1 <= #TCQ complex_row1_rd_done;
    
  //calculate row rd num for complex_oclkdelay_calib
  //once it reached to 8  
  always @ (posedge clk)
    if (rst || prbs_rdlvl_done_pulse) complex_row1_rd_cnt <= #TCQ 'd0;
    else 
      complex_row1_rd_cnt <= #TCQ (complex_row1_rd_done & ~complex_row1_rd_done_r1) ? 
                                  ((complex_row1_rd_cnt == (COMPLEX_RD-1))? 0:complex_row1_rd_cnt + 'd1) 
				  : complex_row1_rd_cnt;
  //For write, reset rd_done for the byte 
  always @ (posedge clk) begin
    if (rst || (init_state_r == INIT_RDLVL_STG1_WRITE)  || prbs_rdlvl_done_pulse)
      complex_byte_rd_done <= #TCQ 'b0;
    else if (prbs_rdlvl_done && (complex_row1_rd_cnt == (COMPLEX_RD-1)) && (complex_row1_rd_done & ~complex_row1_rd_done_r1))
      complex_byte_rd_done <= #TCQ 'b1;
  end
    
  always @ (posedge clk) begin
      complex_byte_rd_done_r1 <= #TCQ complex_byte_rd_done;
      complex_ocal_num_samples_inc <= #TCQ (complex_byte_rd_done & ~complex_byte_rd_done_r1);
  end
  
generate
  if (RANKS < 2) begin: one_rank_complex
    always @(posedge clk)
      if ((init_state_r == INIT_IDLE) || rdlvl_last_byte_done || ( complex_oclkdelay_calib_done && (init_state_r == INIT_RDLVL_STG1_WRITE )) || 
         (complex_byte_rd_done && init_state_r == INIT_RDLVL_COMPLEX_ACT) || prbs_rdlvl_done_pulse )
        complex_wr_done <= #TCQ 1'b0;
      else if ((init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT) && complex_row1_wr_done && (complex_wait_cnt == 'd13))
        complex_wr_done <= #TCQ 1'b1;
      else if ((init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) && complex_row1_wr_done && (complex_wait_cnt == 'd13))
        complex_wr_done <= #TCQ 1'b1;
  end else begin: dual_rank_complex
    always @(posedge clk)
      if ((init_state_r == INIT_IDLE) || rdlvl_last_byte_done || ( complex_oclkdelay_calib_done && (init_state_r == INIT_RDLVL_STG1_WRITE )) ||
          (rdlvl_stg1_rank_done )  || (complex_byte_rd_done && init_state_r == INIT_RDLVL_COMPLEX_ACT) || prbs_rdlvl_done_pulse )
        complex_wr_done <= #TCQ 1'b0;
      else if ((init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT) && complex_row1_wr_done && (complex_wait_cnt == 'd13))
        complex_wr_done <= #TCQ 1'b1;
      else if ((init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) && complex_row1_wr_done && (complex_wait_cnt == 'd13))
        complex_wr_done <= #TCQ 1'b1;
  end
  endgenerate      

  always @(posedge clk)
    if (rst)
      complex_wait_cnt <= #TCQ 'd0;
    else if (((init_state_r == INIT_RDLVL_COMPLEX_READ_WAIT) ||
              (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
              (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT) ||
              (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE_WAIT) ||
              (init_state_r == INIT_OCAL_COMPLEX_ACT_WAIT) ||
              (init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT)) && complex_wait_cnt < 'd15)
      complex_wait_cnt <= #TCQ complex_wait_cnt + 1;
    else
      complex_wait_cnt <= #TCQ 'd0;

  always @(posedge clk)
    if (rst) begin
      complex_num_reads <= #TCQ 'd1;
    end else if ((((init_state_r == INIT_RDLVL_COMPLEX_READ_WAIT) && (complex_wait_cnt == 'd14)) || 
	              ((init_state_r == INIT_RDLVL_STG1_WRITE_READ) && ext_int_ref_req && (cnt_cmd_r == 'd127))) && 
				  ~complex_row0_rd_done) begin
      if (stg1_wr_rd_cnt > 'd85) begin
        if (complex_num_reads < 'd6)
          complex_num_reads <= #TCQ complex_num_reads + 1;
        else
          complex_num_reads <= #TCQ 'd1;
      // Initila value for VCCAUX pattern is 3, 7, and 12
      end else if (stg1_wr_rd_cnt > 'd73) begin
        if (stg1_wr_rd_cnt == 'd85) 
          complex_num_reads <= #TCQ 'd3;
        else if (complex_num_reads < 'd5)
          complex_num_reads <= #TCQ complex_num_reads + 1;
      end else if (stg1_wr_rd_cnt > 'd39) begin
        if (stg1_wr_rd_cnt == 'd73) 
          complex_num_reads <= #TCQ 'd7;
        else if (complex_num_reads < 'd10)
          complex_num_reads <= #TCQ complex_num_reads + 1;
      end else begin
        if (stg1_wr_rd_cnt == 'd39) 
          complex_num_reads <= #TCQ 'd12;
        else if (complex_num_reads < 'd14)
          complex_num_reads <= #TCQ complex_num_reads + 1;
      end 
    // Initialize to 1 at the start of reads or after precharge and activate
    end else if ((((init_state_r == INIT_RDLVL_STG1_WRITE_READ) || (init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT)) && ~ext_int_ref_req) ||
	             ((init_state_r == INIT_RDLVL_STG1_WRITE_READ) && (stg1_wr_rd_cnt == 'd22)))
      complex_num_reads <= #TCQ 'd1;

  always @(posedge clk)
    if (rst)
      complex_num_reads_dec <= #TCQ 'd1;
    else if (((init_state_r == INIT_RDLVL_COMPLEX_READ_WAIT) && (complex_wait_cnt == 'd15) && ~complex_row0_rd_done) ||
              ((init_state_r == INIT_RDLVL_STG1_WRITE_READ) || (init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT)))
      complex_num_reads_dec <= #TCQ complex_num_reads;
    else if ((init_state_r == INIT_RDLVL_COMPLEX_READ) && (complex_num_reads_dec > 'd0))
      complex_num_reads_dec <= #TCQ complex_num_reads_dec - 1;

   always @(posedge clk)
     if (rst)
       complex_address <= #TCQ 'd0;
     else if (((init_state_r == INIT_RDLVL_COMPLEX_READ_WAIT) && (init_state_r1 != INIT_RDLVL_COMPLEX_READ_WAIT)) ||
              ((init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) && (init_state_r1 != INIT_OCAL_COMPLEX_WRITE_WAIT)))              
       complex_address <= #TCQ phy_address[COL_WIDTH-1:0];
       

  always @ (posedge clk)
    if (rst) 
      complex_oclkdelay_calib_start_int <= #TCQ 'b0;
    else if ((init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE_PREWAIT) && prbs_last_byte_done_r) // changed for new algo 3/26
      complex_oclkdelay_calib_start_int <= #TCQ 'b1;
	  
  always @(posedge clk) begin
	complex_oclkdelay_calib_start_r1 <= #TCQ complex_oclkdelay_calib_start_int;
    complex_oclkdelay_calib_start_r2 <= #TCQ complex_oclkdelay_calib_start_r1;
  end
  
  always @ (posedge clk)
    if (rst) 
      complex_oclkdelay_calib_start <= #TCQ 'b0;
    else if (complex_oclkdelay_calib_start_int && (init_state_r == INIT_OCAL_CENTER_WRITE_WAIT) && prbs_rdlvl_done) // changed for new algo 3/26
      complex_oclkdelay_calib_start <= #TCQ 'b1;
        
  //packet fragmentation for complex oclkdealy calib write
  always @(posedge clk)
    if (rst || prbs_rdlvl_done_pulse) begin
      complex_num_writes <= #TCQ 'd1;
    end else if ((init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) && (complex_wait_cnt == 'd14) && ~complex_row0_wr_done) begin
      if (stg1_wr_rd_cnt > 'd85) begin
        if (complex_num_writes < 'd6)
          complex_num_writes <= #TCQ complex_num_writes + 1;
        else
          complex_num_writes <= #TCQ 'd1;
      // Initila value for VCCAUX pattern is 3, 7, and 12
      end else if (stg1_wr_rd_cnt > 'd73) begin
        if (stg1_wr_rd_cnt == 'd85) 
          complex_num_writes <= #TCQ 'd3;
        else if (complex_num_writes < 'd5)
          complex_num_writes <= #TCQ complex_num_writes + 1;
      end else if (stg1_wr_rd_cnt > 'd39) begin
        if (stg1_wr_rd_cnt == 'd73) 
          complex_num_writes <= #TCQ 'd7;
        else if (complex_num_writes < 'd10)
          complex_num_writes <= #TCQ complex_num_writes + 1;
      end else begin
        if (stg1_wr_rd_cnt == 'd39) 
          complex_num_writes <= #TCQ 'd12;
        else if (complex_num_writes < 'd14)
          complex_num_writes <= #TCQ complex_num_writes + 1;
      end 
    // Initialize to 1 at the start of write or after precharge and activate
    end else if ((init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT) && complex_row0_wr_done)
      complex_num_writes <= #TCQ 'd30;
    else if (init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT)
      complex_num_writes <= #TCQ 'd1;    

  always @(posedge clk)
    if (rst || prbs_rdlvl_done_pulse)
      complex_num_writes_dec <= #TCQ 'd1;
    else if (((init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) && (complex_wait_cnt == 'd15) && ~complex_row0_rd_done) ||
              ((init_state_r == INIT_RDLVL_STG1_WRITE_READ) || (init_state_r == INIT_RDLVL_COMPLEX_ACT_WAIT)))
      complex_num_writes_dec <= #TCQ complex_num_writes;
    else if ((init_state_r == INIT_RDLVL_STG1_WRITE) && (complex_num_writes_dec > 'd0))
      complex_num_writes_dec <= #TCQ complex_num_writes_dec - 1;

    always @(posedge clk)
     if (rst)
       complex_sample_cnt_inc_ocal <= #TCQ 1'b0;
     else if ((stg1_wr_rd_cnt == 9'd1) && complex_byte_rd_done && prbs_rdlvl_done)
       complex_sample_cnt_inc_ocal <= #TCQ 1'b1;
     else
       complex_sample_cnt_inc_ocal <= #TCQ 1'b0;

   always @(posedge clk)
     if (rst)
       complex_sample_cnt_inc <= #TCQ 1'b0;
     else if ((stg1_wr_rd_cnt == 9'd1) && complex_row1_rd_done)
       complex_sample_cnt_inc <= #TCQ 1'b1;
     else
       complex_sample_cnt_inc <= #TCQ 1'b0;
       
   always @(posedge clk) begin
     complex_sample_cnt_inc_r1 <= #TCQ complex_sample_cnt_inc;
     complex_sample_cnt_inc_r2 <= #TCQ complex_sample_cnt_inc_r1;
   end
   
   //complex refresh req 
   always @ (posedge clk) begin
     if(rst || (init_state_r == INIT_OCAL_COMPLEX_ACT) || 
               (prbs_rdlvl_done && (init_state_r == INIT_RDLVL_COMPLEX_ACT)) )
       complex_ocal_ref_done <= #TCQ 1'b1;   
     else if (init_state_r == INIT_RDLVL_STG1_WRITE)
       complex_ocal_ref_done <= #TCQ 1'b0; 
   end

  //complex ocal odt extention
  always @(posedge clk)
    if (rst)
      complex_ocal_odt_ext <= #TCQ 1'b0;
    else if (((init_state_r == INIT_PRECHARGE_PREWAIT) && cnt_cmd_done_m7_r) || (init_state_r == INIT_OCLKDELAY_READ_WAIT))
      complex_ocal_odt_ext <= #TCQ 1'b0;
    else if ((init_state_r == INIT_OCAL_CENTER_WRITE) || (init_state_r == INIT_OCAL_CENTER_WRITE_WAIT))
      complex_ocal_odt_ext <= #TCQ 1'b1;

   // OCLKDELAY calibration requires multiple writes because
   // write can be up to 2 cycles early since OCLKDELAY tap
   // can go down to 0
   always @(posedge clk)
     if (rst || (init_state_r == INIT_OCLKDELAY_WRITE_WAIT) ||
        (oclk_wr_cnt == 4'd0))
       oclk_wr_cnt <= #TCQ NUM_STG1_WR_RD;
     else if ((init_state_r == INIT_OCLKDELAY_WRITE) && 
             new_burst_r && ~phy_data_full)
       oclk_wr_cnt <= #TCQ oclk_wr_cnt - 1;
       
   // Write calibration requires multiple writes because
   // write can be up to 2 cycles early due to new write
   // leveling algorithm to avoid late writes
   always @(posedge clk)
     if (rst || (init_state_r == INIT_WRCAL_WRITE_READ) ||
        (wrcal_wr_cnt == 4'd0))
       wrcal_wr_cnt <= #TCQ NUM_STG1_WR_RD;
     else if ((init_state_r == INIT_WRCAL_WRITE) && 
             new_burst_r && ~phy_data_full)
       wrcal_wr_cnt <= #TCQ wrcal_wr_cnt - 1;


generate
if(nCK_PER_CLK == 4) begin:back_to_back_reads_4_1
  // 4 back-to-back reads with gaps for 
  // read data_offset calibration (rdlvl stage 2)      
  always @(posedge clk)
    if (rst || (init_state_r == INIT_RDLVL_STG2_READ_WAIT))
      num_reads <= #TCQ 3'b000;
    else if ((num_reads > 3'b000) && ~(phy_ctl_full || phy_cmd_full))
      num_reads <= #TCQ num_reads - 1;
    else if ((init_state_r == INIT_RDLVL_STG2_READ) || phy_ctl_full || 
             phy_cmd_full && new_burst_r)
      num_reads <= #TCQ 3'b011;
end else if(nCK_PER_CLK == 2) begin: back_to_back_reads_2_1 
  // 4 back-to-back reads with gaps for 
  // read data_offset calibration (rdlvl stage 2)      
  always @(posedge clk)
    if (rst || (init_state_r == INIT_RDLVL_STG2_READ_WAIT))
      num_reads <= #TCQ 3'b000;
    else if ((num_reads > 3'b000) && ~(phy_ctl_full || phy_cmd_full))
      num_reads <= #TCQ num_reads - 1;
    else if ((init_state_r == INIT_RDLVL_STG2_READ) || phy_ctl_full || 
             phy_cmd_full && new_burst_r)
      num_reads <= #TCQ 3'b111;
end
endgenerate
       
  // back-to-back reads during write calibration
  always @(posedge clk)
    if (rst ||(init_state_r == INIT_WRCAL_READ_WAIT))
      wrcal_reads <= #TCQ 2'b00;
    else if ((wrcal_reads > 2'b00) && ~(phy_ctl_full || phy_cmd_full))
      wrcal_reads <= #TCQ wrcal_reads - 1;
    else if ((init_state_r == INIT_WRCAL_MULT_READS) || phy_ctl_full || 
             phy_cmd_full && new_burst_r)
      wrcal_reads <= #TCQ 'd255;

  // determine how often to issue row command during read leveling writes
  // and reads
  always @(posedge clk)
    if (rdlvl_wr_rd) begin
      // 2:1 mode - every other command issued is a data command
      // 4:1 mode - every command issued is a data command
      if (nCK_PER_CLK == 2) begin
        if (!phy_ctl_full)
          new_burst_r <= #TCQ ~new_burst_r;
      end else
        new_burst_r <= #TCQ 1'b1;
    end else
      new_burst_r <= #TCQ 1'b1;
  
  // indicate when a write is occurring. PHY_WRDATA_EN must be asserted
  // simultaneous with the corresponding command/address for CWL = 5,6
  always @(posedge clk) begin
    rdlvl_wr_r      <= #TCQ rdlvl_wr;
    calib_wrdata_en <= #TCQ phy_wrdata_en;
  end 

  always @(posedge clk) begin
    if (rst || wrcal_done)
      extend_cal_pat <= #TCQ 1'b0;
    else if (temp_lmr_done && (PRE_REV3ES == "ON")) 
      extend_cal_pat <= #TCQ 1'b1;
  end


  generate
    if ((nCK_PER_CLK == 4) || (BURST_MODE == "4")) begin: wrdqen_div4
    // Write data enable asserted for one DIV4 clock cycle
    // Only BL8 supported with DIV4. DDR2 BL4 will use DIV2.
      always @(*) begin
        if (~phy_data_full && ((init_state_r == INIT_RDLVL_STG1_WRITE) ||
            (init_state_r == INIT_OCLKDELAY_WRITE) ||
            (init_state_r == INIT_OCAL_CENTER_WRITE) || 
            (init_state_r == INIT_WRCAL_WRITE)))
          phy_wrdata_en = 1'b1;
        else
          phy_wrdata_en = 1'b0;
      end
    end else begin: wrdqen_div2 // block: wrdqen_div4
      always @(*)
        if((rdlvl_wr & ~phy_ctl_full & new_burst_r & ~phy_data_full) 
             | phy_wrdata_en_r1)
          phy_wrdata_en = 1'b1;
        else
          phy_wrdata_en = 1'b0;

      always @(posedge clk)
        phy_wrdata_en_r1 <= #TCQ rdlvl_wr & ~phy_ctl_full & new_burst_r
                                 & ~phy_data_full;
    
      always @(posedge clk) begin
        if (!phy_wrdata_en & first_rdlvl_pat_r)
          wrdata_pat_cnt <= #TCQ 2'b00;
        else if (wrdata_pat_cnt == 2'b11)
          wrdata_pat_cnt <= #TCQ 2'b10;
        else
          wrdata_pat_cnt <= #TCQ wrdata_pat_cnt + 1;
      end
      
      always @(posedge clk) begin
        if (!phy_wrdata_en & first_wrcal_pat_r)
          wrcal_pat_cnt <= #TCQ 2'b00;
        else if (extend_cal_pat && (wrcal_pat_cnt == 2'b01))
          wrcal_pat_cnt <= #TCQ 2'b00;
        else if (wrcal_pat_cnt == 2'b11)
          wrcal_pat_cnt <= #TCQ 2'b10;
        else
          wrcal_pat_cnt <= #TCQ wrcal_pat_cnt + 1;
      end
    
    end
  endgenerate

      
  // indicate when a write is occurring. PHY_RDDATA_EN must be asserted
  // simultaneous with the corresponding command/address. PHY_RDDATA_EN
  // is used during read-leveling to determine read latency
  assign phy_rddata_en = ~phy_if_empty;

  // Read data valid generation for MC and User Interface after calibration is
  // complete    
  assign phy_rddata_valid = init_complete_r1_timing ? phy_rddata_en : 1'b0;

  //***************************************************************************
  // Generate training data written at start of each read-leveling stage
  // For every stage of read leveling, 8 words are written into memory
  // The format is as follows (shown as {rise,fall}):
  //   Stage 1: 0xF, 0x0, 0xF, 0x0, 0xF, 0x0, 0xF, 0x0
  //   Stage 2: 0xF, 0x0, 0xA, 0x5, 0x5, 0xA, 0x9, 0x6
  //***************************************************************************


  always @(posedge clk)
    if ((init_state_r == INIT_IDLE) ||
        (init_state_r == INIT_RDLVL_STG1_WRITE))
      cnt_init_data_r <= #TCQ 2'b00;
    else if (phy_wrdata_en)
      cnt_init_data_r <= #TCQ cnt_init_data_r + 1;
    else if (init_state_r == INIT_WRCAL_WRITE)
      cnt_init_data_r <= #TCQ 2'b10;     


  //  write different sequence for very
  //  first write to memory only. Used to help us differentiate
  //  if the writes are "early" or "on-time" during read leveling
  always @(posedge clk)
    if (rst || rdlvl_stg1_rank_done)
      first_rdlvl_pat_r <= #TCQ 1'b1;
    else if (phy_wrdata_en && (init_state_r == INIT_RDLVL_STG1_WRITE))
      first_rdlvl_pat_r <= #TCQ 1'b0;
      
      
  always @(posedge clk)
    if (rst || wrcal_resume ||
       (init_state_r == INIT_WRCAL_ACT_WAIT))
      first_wrcal_pat_r <= #TCQ 1'b1;
    else if (phy_wrdata_en && (init_state_r == INIT_WRCAL_WRITE))
      first_wrcal_pat_r <= #TCQ 1'b0;

generate
  if ((CLK_PERIOD/nCK_PER_CLK > 2500) && (nCK_PER_CLK == 2)) begin: wrdq_div2_2to1_rdlvl_first
    
    always @(posedge clk)
        if (~oclkdelay_calib_done)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hF}},
                              {DQ_WIDTH/4{4'h0}},
                              {DQ_WIDTH/4{4'hF}},
                              {DQ_WIDTH/4{4'h0}}};
        else if (!rdlvl_stg1_done) begin
          // The 16 words for stage 1 write data in 2:1 mode is written 
          // over 4 consecutive controller clock cycles. Note that write 
          // data follows phy_wrdata_en by one clock cycle
          case (wrdata_pat_cnt)
          2'b00: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h7}},
                                {DQ_WIDTH/4{4'h3}},
                                {DQ_WIDTH/4{4'h9}}};
          end
          
          2'b01: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'h2}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hC}}};
          end
          
          2'b10: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h7}},
                                {DQ_WIDTH/4{4'h1}},
                                {DQ_WIDTH/4{4'hB}}};
          end
          
          2'b11: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'h2}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hC}}};
          end
          endcase
        end else if (!prbs_rdlvl_done && ~phy_data_full) begin
          phy_wrdata <= #TCQ prbs_o;
          // prbs_o is 8-bits wide hence {DQ_WIDTH/8{prbs_o}} results in
          // prbs_o being concatenated 8 times resulting in DQ_WIDTH
          /*phy_wrdata <= #TCQ {{DQ_WIDTH/8{prbs_o[4*8-1:3*8]}},
                              {DQ_WIDTH/8{prbs_o[3*8-1:2*8]}},
                              {DQ_WIDTH/8{prbs_o[2*8-1:8]}},
                              {DQ_WIDTH/8{prbs_o[8-1:0]}}};*/
        end else if (!wrcal_done) begin
          case (wrcal_pat_cnt)
          2'b00: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h5}},
                                {DQ_WIDTH/4{4'hA}},
                                {DQ_WIDTH/4{4'h0}},
                                {DQ_WIDTH/4{4'hF}}};
          end
          2'b01: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h6}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hA}},
                                {DQ_WIDTH/4{4'h5}}};
          end
          2'b10: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h1}},
                                {DQ_WIDTH/4{4'hB}}};
          end
          2'b11: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h8}},
                                {DQ_WIDTH/4{4'hD}},
                                {DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h4}}};
          end
          endcase
        end
        
  end else if ((CLK_PERIOD/nCK_PER_CLK > 2500) && (nCK_PER_CLK == 4)) begin: wrdq_div2_4to1_rdlvl_first
    
    always @(posedge clk)
      if (~oclkdelay_calib_done)
        phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}}};
      else if (!rdlvl_stg1_done && ~phy_data_full)
        //  write different sequence for very
        //  first write to memory only. Used to help us differentiate
        //  if the writes are "early" or "on-time" during read leveling
        if (first_rdlvl_pat_r)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'h2}},
                              {DQ_WIDTH/4{4'h9}},{DQ_WIDTH/4{4'hC}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h7}},
                              {DQ_WIDTH/4{4'h3}},{DQ_WIDTH/4{4'h9}}};
        else
          // For all others, change the first two words written in order
          // to differentiate the "early write" and "on-time write"
          // readback patterns during read leveling
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'h2}},
                              {DQ_WIDTH/4{4'h9}},{DQ_WIDTH/4{4'hC}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h7}},
                              {DQ_WIDTH/4{4'h1}},{DQ_WIDTH/4{4'hB}}};
      else if (~(prbs_rdlvl_done || prbs_last_byte_done_r) && ~phy_data_full)
          phy_wrdata <= #TCQ prbs_o;
          // prbs_o is 8-bits wide hence {DQ_WIDTH/8{prbs_o}} results in
          // prbs_o being concatenated 8 times resulting in DQ_WIDTH
          /*phy_wrdata <= #TCQ {{DQ_WIDTH/8{prbs_o[8*8-1:7*8]}},{DQ_WIDTH/8{prbs_o[7*8-1:6*8]}},
                              {DQ_WIDTH/8{prbs_o[6*8-1:5*8]}},{DQ_WIDTH/8{prbs_o[5*8-1:4*8]}},
                              {DQ_WIDTH/8{prbs_o[4*8-1:3*8]}},{DQ_WIDTH/8{prbs_o[3*8-1:2*8]}},
                              {DQ_WIDTH/8{prbs_o[2*8-1:8]}},{DQ_WIDTH/8{prbs_o[8-1:0]}}};*/ 
      else if (!wrcal_done)
        if (first_wrcal_pat_r)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h6}},{DQ_WIDTH/4{4'h9}},
                              {DQ_WIDTH/4{4'hA}},{DQ_WIDTH/4{4'h5}},
                              {DQ_WIDTH/4{4'h5}},{DQ_WIDTH/4{4'hA}},
                              {DQ_WIDTH/4{4'h0}},{DQ_WIDTH/4{4'hF}}};
        else
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h8}},{DQ_WIDTH/4{4'hD}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h4}},
                              {DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'hE}},
                              {DQ_WIDTH/4{4'h1}},{DQ_WIDTH/4{4'hB}}};
      
  
  end else if (nCK_PER_CLK == 4) begin: wrdq_div1_4to1_wrcal_first
    
    always @(posedge clk)
      if ((~oclkdelay_calib_done) && (DRAM_TYPE == "DDR3"))
        phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}},
                            {DQ_WIDTH/4{4'hF}},{DQ_WIDTH/4{4'h0}}};
      else if ((!wrcal_done)&& (DRAM_TYPE == "DDR3")) begin
        if (extend_cal_pat)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h6}},{DQ_WIDTH/4{4'h9}},
                              {DQ_WIDTH/4{4'hA}},{DQ_WIDTH/4{4'h5}},
                              {DQ_WIDTH/4{4'h5}},{DQ_WIDTH/4{4'hA}},
                              {DQ_WIDTH/4{4'h0}},{DQ_WIDTH/4{4'hF}}};
        else if (first_wrcal_pat_r)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h6}},{DQ_WIDTH/4{4'h9}},
                              {DQ_WIDTH/4{4'hA}},{DQ_WIDTH/4{4'h5}},
                              {DQ_WIDTH/4{4'h5}},{DQ_WIDTH/4{4'hA}},
                              {DQ_WIDTH/4{4'h0}},{DQ_WIDTH/4{4'hF}}};
        else
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h8}},{DQ_WIDTH/4{4'hD}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h4}},
                              {DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'hE}},
                              {DQ_WIDTH/4{4'h1}},{DQ_WIDTH/4{4'hB}}};
      end else if (!rdlvl_stg1_done && ~phy_data_full) begin
        //  write different sequence for very
        //  first write to memory only. Used to help us differentiate
        //  if the writes are "early" or "on-time" during read leveling
        if (first_rdlvl_pat_r)
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'h2}},
                              {DQ_WIDTH/4{4'h9}},{DQ_WIDTH/4{4'hC}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h7}},
                              {DQ_WIDTH/4{4'h3}},{DQ_WIDTH/4{4'h9}}};
        else
          // For all others, change the first two words written in order
          // to differentiate the "early write" and "on-time write"
          // readback patterns during read leveling
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},{DQ_WIDTH/4{4'h2}},
                              {DQ_WIDTH/4{4'h9}},{DQ_WIDTH/4{4'hC}},
                              {DQ_WIDTH/4{4'hE}},{DQ_WIDTH/4{4'h7}},
                              {DQ_WIDTH/4{4'h1}},{DQ_WIDTH/4{4'hB}}};    
      end else if (!prbs_rdlvl_done && ~phy_data_full)
          phy_wrdata <= #TCQ prbs_o;
          // prbs_o is 8-bits wide hence {DQ_WIDTH/8{prbs_o}} results in
          // prbs_o being concatenated 8 times resulting in DQ_WIDTH
          /*phy_wrdata <= #TCQ {{DQ_WIDTH/8{prbs_o[8*8-1:7*8]}},{DQ_WIDTH/8{prbs_o[7*8-1:6*8]}},
                              {DQ_WIDTH/8{prbs_o[6*8-1:5*8]}},{DQ_WIDTH/8{prbs_o[5*8-1:4*8]}},
                              {DQ_WIDTH/8{prbs_o[4*8-1:3*8]}},{DQ_WIDTH/8{prbs_o[3*8-1:2*8]}},
                              {DQ_WIDTH/8{prbs_o[2*8-1:8]}},{DQ_WIDTH/8{prbs_o[8-1:0]}}};*/   
       else if (!complex_oclkdelay_calib_done && ~phy_data_full) 
          phy_wrdata <= #TCQ prbs_o;
  end else begin: wrdq_div1_2to1_wrcal_first
  
    always @(posedge clk)
        if ((~oclkdelay_calib_done)&& (DRAM_TYPE == "DDR3"))
          phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hF}},
                              {DQ_WIDTH/4{4'h0}},
                              {DQ_WIDTH/4{4'hF}},
                              {DQ_WIDTH/4{4'h0}}};
        else if ((!wrcal_done) && (DRAM_TYPE == "DDR3"))begin
          case (wrcal_pat_cnt)
          2'b00: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h5}},
                                {DQ_WIDTH/4{4'hA}},
                                {DQ_WIDTH/4{4'h0}},
                                {DQ_WIDTH/4{4'hF}}};
          end
          2'b01: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h6}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hA}},
                                {DQ_WIDTH/4{4'h5}}};
          end
          2'b10: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h1}},
                                {DQ_WIDTH/4{4'hB}}};
          end
          2'b11: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h8}},
                                {DQ_WIDTH/4{4'hD}},
                                {DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h4}}};
          end
          endcase
        end else if (!rdlvl_stg1_done) begin
          // The 16 words for stage 1 write data in 2:1 mode is written 
          // over 4 consecutive controller clock cycles. Note that write 
          // data follows phy_wrdata_en by one clock cycle
          case (wrdata_pat_cnt)
          2'b00: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h7}},
                                {DQ_WIDTH/4{4'h3}},
                                {DQ_WIDTH/4{4'h9}}};
          end
          
          2'b01: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'h2}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hC}}};
          end
          
          2'b10: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'hE}},
                                {DQ_WIDTH/4{4'h7}},
                                {DQ_WIDTH/4{4'h1}},
                                {DQ_WIDTH/4{4'hB}}};
          end
          
          2'b11: begin
            phy_wrdata <= #TCQ {{DQ_WIDTH/4{4'h4}},
                                {DQ_WIDTH/4{4'h2}},
                                {DQ_WIDTH/4{4'h9}},
                                {DQ_WIDTH/4{4'hC}}};
          end
          endcase
        end else if (!prbs_rdlvl_done && ~phy_data_full) begin
          phy_wrdata <= #TCQ prbs_o;
          // prbs_o is 8-bits wide hence {DQ_WIDTH/8{prbs_o}} results in
          // prbs_o being concatenated 8 times resulting in DQ_WIDTH
          /*phy_wrdata <= #TCQ {{DQ_WIDTH/8{prbs_o[4*8-1:3*8]}},
                              {DQ_WIDTH/8{prbs_o[3*8-1:2*8]}},
                              {DQ_WIDTH/8{prbs_o[2*8-1:8]}},
                              {DQ_WIDTH/8{prbs_o[8-1:0]}}};*/
        end else if (!complex_oclkdelay_calib_done && ~phy_data_full) begin
          phy_wrdata <= #TCQ prbs_o;
        end

   end
endgenerate
       
  //***************************************************************************
  // Memory control/address
  //***************************************************************************


  // Phases [2] and [3] are always deasserted for 4:1 mode
  generate
    if (nCK_PER_CLK == 4) begin: gen_div4_ca_tieoff
      always @(posedge clk) begin
        phy_ras_n[3:2] <= #TCQ 3'b11;
        phy_cas_n[3:2] <= #TCQ 3'b11;
        phy_we_n[3:2]  <= #TCQ 3'b11;
      end
    end
  endgenerate
  
      // Assert RAS when: (1) Loading MRS, (2) Activating Row, (3) Precharging
      // (4) auto refresh
            // verilint STARC-2.7.3.3b off
  generate 
      if (!(CWL_M % 2)) begin: even_cwl
        always @(posedge clk) begin
          if ((init_state_r == INIT_LOAD_MR) ||
              (init_state_r == INIT_MPR_RDEN) ||
              (init_state_r == INIT_MPR_DISABLE) ||
              (init_state_r == INIT_REG_WRITE) ||
              (init_state_r == INIT_WRLVL_START) ||
              (init_state_r == INIT_WRLVL_LOAD_MR) ||
              (init_state_r == INIT_WRLVL_LOAD_MR2) ||
              (init_state_r == INIT_RDLVL_ACT) ||
              (init_state_r == INIT_WRCAL_ACT) ||
              (init_state_r == INIT_OCLKDELAY_ACT) ||
              (init_state_r == INIT_OCAL_COMPLEX_ACT) ||    
              (init_state_r == INIT_OCAL_CENTER_ACT) ||              
              (init_state_r == INIT_PRECHARGE) ||
              (init_state_r == INIT_DDR2_PRECHARGE) ||
              (init_state_r == INIT_REFRESH) ||
              (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
              (init_state_r == INIT_RDLVL_COMPLEX_ACT))begin
          phy_ras_n[0] <= #TCQ 1'b0;
          phy_ras_n[1] <= #TCQ 1'b1;
        end else begin
          phy_ras_n[0] <= #TCQ 1'b1;
          phy_ras_n[1] <= #TCQ 1'b1;
          end
        end
  
        // Assert CAS when: (1) Loading MRS, (2) Issuing Read/Write command
        // (3) auto refresh
        always @(posedge clk) begin
          if ((init_state_r == INIT_LOAD_MR) ||
              (init_state_r == INIT_MPR_RDEN) ||
              (init_state_r == INIT_MPR_DISABLE) ||
              (init_state_r == INIT_REG_WRITE) ||
              (init_state_r == INIT_WRLVL_START) ||
              (init_state_r == INIT_WRLVL_LOAD_MR) ||
              (init_state_r == INIT_WRLVL_LOAD_MR2) ||
              (init_state_r == INIT_REFRESH) ||
              (rdlvl_wr_rd && new_burst_r))begin
          phy_cas_n[0] <= #TCQ 1'b0;
          phy_cas_n[1] <= #TCQ 1'b1;
        end else begin
          phy_cas_n[0] <= #TCQ 1'b1;
          phy_cas_n[1] <= #TCQ 1'b1;
          end
        end
        // Assert WE when: (1) Loading MRS, (2) Issuing Write command (only
        // occur during read leveling), (3) Issuing ZQ Long Calib command,
        // (4) Precharge
        always @(posedge clk) begin
          if ((init_state_r == INIT_LOAD_MR) ||
              (init_state_r == INIT_MPR_RDEN) ||
              (init_state_r == INIT_MPR_DISABLE) ||
              (init_state_r == INIT_REG_WRITE) ||
              (init_state_r == INIT_ZQCL) ||
              (init_state_r == INIT_WRLVL_START) ||
              (init_state_r == INIT_WRLVL_LOAD_MR) ||
              (init_state_r == INIT_WRLVL_LOAD_MR2) ||
              (init_state_r == INIT_PRECHARGE) ||
              (init_state_r == INIT_DDR2_PRECHARGE)||
              (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
              (rdlvl_wr && new_burst_r))begin
          phy_we_n[0] <= #TCQ 1'b0;
          phy_we_n[1] <= #TCQ 1'b1;
        end else begin
          phy_we_n[0] <= #TCQ 1'b1;
          phy_we_n[1] <= #TCQ 1'b1;
        end
      end
      end else begin: odd_cwl
        always @(posedge clk) begin
          if ((init_state_r == INIT_LOAD_MR) ||
              (init_state_r == INIT_MPR_RDEN) ||
              (init_state_r == INIT_MPR_DISABLE) ||
              (init_state_r == INIT_REG_WRITE) ||
              (init_state_r == INIT_WRLVL_START) ||
              (init_state_r == INIT_WRLVL_LOAD_MR) ||
              (init_state_r == INIT_WRLVL_LOAD_MR2) ||
              (init_state_r == INIT_RDLVL_ACT) ||
              (init_state_r == INIT_WRCAL_ACT) ||
              (init_state_r == INIT_OCLKDELAY_ACT) ||
              (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
              (init_state_r == INIT_OCAL_CENTER_ACT) ||              
              (init_state_r == INIT_PRECHARGE) ||
              (init_state_r == INIT_DDR2_PRECHARGE) ||
              (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
              (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
              (init_state_r == INIT_REFRESH))begin
          phy_ras_n[0] <= #TCQ 1'b1;
          phy_ras_n[1] <= #TCQ 1'b0;
        end else begin
          phy_ras_n[0] <= #TCQ 1'b1;
          phy_ras_n[1] <= #TCQ 1'b1;
        end
      end
      // Assert CAS when: (1) Loading MRS, (2) Issuing Read/Write command
      // (3) auto refresh
      always @(posedge clk) begin
        if ((init_state_r == INIT_LOAD_MR) ||
            (init_state_r == INIT_MPR_RDEN) ||
            (init_state_r == INIT_MPR_DISABLE) ||
            (init_state_r == INIT_REG_WRITE) ||
            (init_state_r == INIT_WRLVL_START) ||
            (init_state_r == INIT_WRLVL_LOAD_MR) ||
            (init_state_r == INIT_WRLVL_LOAD_MR2) ||
            (init_state_r == INIT_REFRESH) ||
            (rdlvl_wr_rd && new_burst_r))begin
          phy_cas_n[0] <= #TCQ 1'b1;
          phy_cas_n[1] <= #TCQ 1'b0;
        end else begin
          phy_cas_n[0] <= #TCQ 1'b1;
          phy_cas_n[1] <= #TCQ 1'b1;
        end
      end
      // Assert WE when: (1) Loading MRS, (2) Issuing Write command (only
      // occur during read leveling), (3) Issuing ZQ Long Calib command,
      // (4) Precharge
      always @(posedge clk) begin
        if ((init_state_r == INIT_LOAD_MR) ||
            (init_state_r == INIT_MPR_RDEN) ||
            (init_state_r == INIT_MPR_DISABLE) ||
            (init_state_r == INIT_REG_WRITE) ||
            (init_state_r == INIT_ZQCL) ||
            (init_state_r == INIT_WRLVL_START) ||
            (init_state_r == INIT_WRLVL_LOAD_MR) ||
            (init_state_r == INIT_WRLVL_LOAD_MR2) ||
            (init_state_r == INIT_PRECHARGE) ||
            (init_state_r == INIT_DDR2_PRECHARGE)||
            (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
            (rdlvl_wr && new_burst_r))begin
          phy_we_n[0] <= #TCQ 1'b1;
          phy_we_n[1] <= #TCQ 1'b0;
        end else begin
          phy_we_n[0] <= #TCQ 1'b1;
          phy_we_n[1] <= #TCQ 1'b1;
        end
      end
    end
  endgenerate
// verilint STARC-2.7.3.3b on


  // Assign calib_cmd for the command field in PHY_Ctl_Word
  always @(posedge clk) begin
    if (wr_level_dqs_asrt) begin
      // Request to toggle DQS during write leveling
      calib_cmd         <= #TCQ 3'b001;
      if (CWL_M % 2) begin // odd write latency
        calib_data_offset_0 <= #TCQ CWL_M + 3;
        calib_data_offset_1 <= #TCQ CWL_M + 3;
        calib_data_offset_2 <= #TCQ CWL_M + 3;
        calib_cas_slot      <= #TCQ 2'b01;
      end else begin // even write latency
        calib_data_offset_0 <= #TCQ CWL_M + 2;
        calib_data_offset_1 <= #TCQ CWL_M + 2;
        calib_data_offset_2 <= #TCQ CWL_M + 2;
        calib_cas_slot      <= #TCQ 2'b00;
      end
    end else if (rdlvl_wr && new_burst_r) begin
      // Write Command
      calib_cmd         <= #TCQ 3'b001;
      if (CWL_M % 2) begin // odd write latency
        calib_data_offset_0 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 3 : CWL_M  - 1;
        calib_data_offset_1 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 3 : CWL_M  - 1;
        calib_data_offset_2 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 3 : CWL_M  - 1;
        calib_cas_slot      <= #TCQ 2'b01;
      end else begin // even write latency
        calib_data_offset_0 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 2 : CWL_M - 2 ;
        calib_data_offset_1 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 2 : CWL_M - 2 ;
        calib_data_offset_2 <= #TCQ (nCK_PER_CLK == 4) ? CWL_M + 2 : CWL_M - 2 ;
        calib_cas_slot      <= #TCQ 2'b00;
      end
    end else if (rdlvl_rd && new_burst_r) begin
      // Read Command
      calib_cmd         <= #TCQ 3'b011;
      if (CWL_M % 2)
        calib_cas_slot    <= #TCQ 2'b01;
      else
        calib_cas_slot    <= #TCQ 2'b00;
      if (~pi_calib_done_r1) begin
        calib_data_offset_0 <= #TCQ 6'd0;
        calib_data_offset_1 <= #TCQ 6'd0;
        calib_data_offset_2 <= #TCQ 6'd0;
      end else if (~pi_dqs_found_done_r1) begin
        calib_data_offset_0 <= #TCQ rd_data_offset_0;
        calib_data_offset_1 <= #TCQ rd_data_offset_1;
        calib_data_offset_2 <= #TCQ rd_data_offset_2;
      end else begin
        calib_data_offset_0 <= #TCQ rd_data_offset_ranks_0[6*chip_cnt_r+:6];
        calib_data_offset_1 <= #TCQ rd_data_offset_ranks_1[6*chip_cnt_r+:6];
        calib_data_offset_2 <= #TCQ rd_data_offset_ranks_2[6*chip_cnt_r+:6];
      end
    end else begin
      // Non-Data Commands like NOP, MRS, ZQ Long Cal, Precharge,
      // Active, Refresh
      calib_cmd           <= #TCQ 3'b100;
      calib_data_offset_0 <= #TCQ 6'd0;
      calib_data_offset_1 <= #TCQ 6'd0;
      calib_data_offset_2 <= #TCQ 6'd0;
      if (CWL_M % 2)
        calib_cas_slot    <= #TCQ 2'b01;
      else
        calib_cas_slot    <= #TCQ 2'b00;
    end
  end
  
  // Write Enable to PHY_Control FIFO always asserted
  // No danger of this FIFO being Full with 4:1 sync clock ratio
  // This is also the write enable to the command OUT_FIFO
  always @(posedge clk) begin
    if (rst) begin
      calib_ctl_wren <= #TCQ 1'b0;
      calib_cmd_wren <= #TCQ 1'b0;
      calib_seq      <= #TCQ 2'b00;
    end else if (cnt_pwron_cke_done_r && phy_ctl_ready
                 && ~(phy_ctl_full || phy_cmd_full )) begin
      calib_ctl_wren <= #TCQ 1'b1;
      calib_cmd_wren <= #TCQ 1'b1;
      calib_seq      <= #TCQ calib_seq + 1;
    end else begin
      calib_ctl_wren <= #TCQ 1'b0;
      calib_cmd_wren <= #TCQ 1'b0;
      calib_seq      <= #TCQ calib_seq;
    end
  end

  generate
    genvar rnk_i;
    for (rnk_i = 0; rnk_i < 4; rnk_i = rnk_i + 1) begin: gen_rnk
      always @(posedge clk) begin
        if (rst) begin
          mr2_r[rnk_i]  <= #TCQ 2'b00;
          mr1_r[rnk_i]  <= #TCQ 3'b000;
        end else begin
          mr2_r[rnk_i]  <= #TCQ tmp_mr2_r[rnk_i];
          mr1_r[rnk_i]  <= #TCQ tmp_mr1_r[rnk_i];
        end
      end
    end
  endgenerate

  // ODT assignment based on slot config and slot present
  // For single slot systems slot_1_present input will be ignored
  // Assuming component interfaces to be single slot systems
  generate
    if (nSLOTS == 1) begin: gen_single_slot_odt
      always @(posedge clk) begin
        if (rst) begin
          tmp_mr2_r[1]   <= #TCQ 2'b00;
          tmp_mr2_r[2]   <= #TCQ 2'b00;
          tmp_mr2_r[3]   <= #TCQ 2'b00;
          tmp_mr1_r[1]   <= #TCQ 3'b000;
          tmp_mr1_r[2]   <= #TCQ 3'b000;
          tmp_mr1_r[3]   <= #TCQ 3'b000;
          phy_tmp_cs1_r <= #TCQ {CS_WIDTH*nCS_PER_RANK{1'b1}};
          phy_tmp_odt_r <= #TCQ 4'b0000;
          phy_tmp_odt_r1 <= #TCQ phy_tmp_odt_r;
        end else begin 
          case ({slot_0_present[0],slot_0_present[1],
                 slot_0_present[2],slot_0_present[3]})
            // Single slot configuration with quad rank
            // Assuming same behavior as single slot dual rank for now
            // DDR2 does not have quad rank parts 
            4'b1111: begin    
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 RTT_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40")  ? 3'b011 :
                                     (RTT_NOM_int == "60")  ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 RTT_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
              phy_tmp_odt_r <= #TCQ 4'b0001;
              // Chip Select assignments
              phy_tmp_cs1_r[((chip_cnt_r*nCS_PER_RANK)
                             ) +: nCS_PER_RANK] <= #TCQ 'b0;
            end 
        
            // Single slot configuration with single rank
            4'b1000: begin    
              phy_tmp_odt_r <= #TCQ 4'b0001;
              if ((REG_CTRL == "ON") && (nCS_PER_RANK > 1)) begin
                phy_tmp_cs1_r[chip_cnt_r] <= #TCQ 1'b0;
              end else begin
                phy_tmp_cs1_r <= #TCQ {CS_WIDTH*nCS_PER_RANK{1'b0}};
              end
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done && 
                   ((cnt_init_mr_r == 2'd0) || (USE_ODT_PORT == 1)))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 RTT_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40")  ? 3'b011 :
                                     (RTT_NOM_int == "60")  ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 RTT_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end 
            
            // Single slot configuration with dual rank
            4'b1100: begin
              phy_tmp_odt_r <= #TCQ 4'b0001;
              // Chip Select assignments
              
              phy_tmp_cs1_r[((chip_cnt_r*nCS_PER_RANK)
                             ) +: nCS_PER_RANK] <= #TCQ 'b0;
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end 
            
            default: begin    
              phy_tmp_odt_r <= #TCQ 4'b0001;
              phy_tmp_cs1_r <= #TCQ {CS_WIDTH*nCS_PER_RANK{1'b0}};
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done)) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end       
          endcase
        end
      end
    end else if (nSLOTS == 2) begin: gen_dual_slot_odt
      always @ (posedge clk) begin
        if (rst) begin
          tmp_mr2_r[1]   <= #TCQ 2'b00;
          tmp_mr2_r[2]   <= #TCQ 2'b00;
          tmp_mr2_r[3]   <= #TCQ 2'b00;
          tmp_mr1_r[1]   <= #TCQ 3'b000;
          tmp_mr1_r[2]   <= #TCQ 3'b000;
          tmp_mr1_r[3]   <= #TCQ 3'b000;
          phy_tmp_odt_r  <= #TCQ 4'b0000;
          phy_tmp_cs1_r  <= #TCQ {CS_WIDTH*nCS_PER_RANK{1'b1}};
          phy_tmp_odt_r1 <= #TCQ phy_tmp_odt_r;
        end else begin  
          case ({slot_0_present[0],slot_0_present[1],
                 slot_1_present[0],slot_1_present[1]})       
            // Two slot configuration, one slot present, single rank
            4'b10_00: begin
              if (//wrlvl_odt ||
                  (init_state_r == INIT_RDLVL_STG1_WRITE) ||
                  (init_state_r == INIT_WRCAL_WRITE) ||
                  (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                  (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                // odt turned on only during write 
                phy_tmp_odt_r <= #TCQ 4'b0001;
              end
              phy_tmp_cs1_r <= #TCQ {nCS_PER_RANK{1'b0}};
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done)) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end
            4'b00_10: begin
              
              //Rank1 ODT enabled
              if (//wrlvl_odt ||
                  (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                  (init_state_r == INIT_WRCAL_WRITE) ||
                  (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                  (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                // odt turned on only during write
                phy_tmp_odt_r <= #TCQ 4'b0001;
              end
              phy_tmp_cs1_r <= #TCQ {nCS_PER_RANK{1'b0}};
              if ((RTT_WR == "OFF") || 
                  ((WRLVL=="ON") && ~wrlvl_done)) begin
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM defaults to 120 ohms
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end
            // Two slot configuration, one slot present, dual rank
            4'b00_11: begin
              if (//wrlvl_odt ||
                  (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                  (init_state_r == INIT_WRCAL_WRITE) ||
                  (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                  (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                // odt turned on only during write
                phy_tmp_odt_r  
                  <= #TCQ 4'b0001;
              end
              
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};
              
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end
            4'b11_00: begin
              if (//wrlvl_odt ||
                  (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                  (init_state_r == INIT_WRCAL_WRITE) ||
                  (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                  (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                // odt turned on only during write
                phy_tmp_odt_r <= #TCQ 4'b0001;
              end
              
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};
              
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
            end
            // Two slot configuration, one rank per slot
            4'b10_10: begin
              if(DRAM_TYPE == "DDR2")begin
                if(chip_cnt_r == 2'b00)begin
                  phy_tmp_odt_r
                    <= #TCQ 4'b0010; //bit0 for rank0
                end else begin
                  phy_tmp_odt_r
                    <= #TCQ 4'b0001; //bit0 for rank0
                end
              end else begin
                if((init_state_r == INIT_WRLVL_WAIT) ||
                        (init_next_state == INIT_RDLVL_STG1_WRITE) ||
                        (init_next_state == INIT_WRCAL_WRITE) ||
                        (init_next_state == INIT_OCAL_CENTER_WRITE) || 
                        (init_next_state == INIT_OCLKDELAY_WRITE))
                  phy_tmp_odt_r <= #TCQ 4'b0011; // bit0 for rank0/1 (write)
                else if ((init_next_state == INIT_PI_PHASELOCK_READS) ||
                         (init_next_state == INIT_MPR_READ) ||
                         (init_next_state == INIT_RDLVL_STG1_READ) ||
                         (init_next_state == INIT_RDLVL_COMPLEX_READ) ||                         
                         (init_next_state == INIT_RDLVL_STG2_READ) ||
                         (init_next_state == INIT_OCLKDELAY_READ) ||
                         (init_next_state == INIT_WRCAL_READ) ||
                         (init_next_state == INIT_WRCAL_MULT_READS))
                  phy_tmp_odt_r <= #TCQ 4'b0010; // bit0 for rank1 (rank 0 rd)
              end
              
                 // Chip Select assignments
                 phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                  <= #TCQ {nCS_PER_RANK{1'b0}};

                 if ((RTT_WR == "OFF") ||
                    ((WRLVL=="ON") && ~wrlvl_done &&
                     (wrlvl_rank_cntr==3'd0))) begin
                   //Rank0 Dynamic ODT disabled
                   tmp_mr2_r[0] <= #TCQ 2'b00;
                   //Rank0 Rtt_NOM
                   tmp_mr1_r[0] <= #TCQ (RTT_WR == "60") ? 3'b001 :
                                        (RTT_WR == "120") ? 3'b010 :
                                        3'b000;
                   //Rank1 Dynamic ODT disabled
                   tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                       2'b10;
                   //Rank1 Rtt_NOM
                   tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                        (RTT_NOM_int == "60") ? 3'b001 :
                                        (RTT_NOM_int == "120") ? 3'b010 :
                                        3'b000;
                 end else begin
                   //Rank0 Dynamic ODT defaults to 120 ohms
                   tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                       2'b10;
                   //Rank0 Rtt_NOM
                   tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                        (RTT_NOM_int == "120") ? 3'b010 :
                                        (RTT_NOM_int == "20") ? 3'b100 :
                                        (RTT_NOM_int == "30") ? 3'b101 :
                                        (RTT_NOM_int == "40")  ? 3'b011 :
                                        3'b000;
                   //Rank1 Dynamic ODT defaults to 120 ohms
                   tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                       2'b10;
                   //Rank1 Rtt_NOM
                   tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                        (RTT_NOM_int == "120") ? 3'b010 :
                                        (RTT_NOM_int == "20") ? 3'b100 :
                                        (RTT_NOM_int == "30") ? 3'b101 :
                                        (RTT_NOM_int == "40")  ? 3'b011 :
                                        3'b000;
                 end
               end
            // Two Slots - One slot with dual rank and other with single rank
            4'b10_11: begin

              //Rank3 Rtt_NOM
              tmp_mr1_r[2] <= #TCQ (RTT_NOM_int == "60")  ? 3'b001 :
                                   (RTT_NOM_int == "120") ? 3'b010 :
                                   (RTT_NOM_int == "20")  ? 3'b100 :
                                   (RTT_NOM_int == "30")  ? 3'b101 :
                                   (RTT_NOM_int == "40")  ? 3'b011 :
                                   3'b000;
              tmp_mr2_r[2] <= #TCQ 2'b00;
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[1] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                   tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                   2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     (RTT_NOM_int == "20") ? 3'b100 :
                                     (RTT_NOM_int == "30") ? 3'b101 :
                                     (RTT_NOM_int == "40") ? 3'b011 :
                                     3'b000;
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM after write leveling completes
                tmp_mr1_r[1] <= #TCQ 3'b000;
              end
              //Slot1 Rank1 or Rank3 is being written
              if(DRAM_TYPE == "DDR2")begin
                if(chip_cnt_r == 2'b00)begin
                  phy_tmp_odt_r 
                    <= #TCQ 4'b0010;
                end else begin
                  phy_tmp_odt_r 
                    <= #TCQ 4'b0001;
                end
              end else begin               
                   if (//wrlvl_odt ||
                       (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                       (init_state_r == INIT_WRCAL_WRITE) ||
                       (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                       (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                     if (chip_cnt_r[0] == 1'b1) begin
                       phy_tmp_odt_r 
                         <= #TCQ 4'b0011;
                       //Slot0 Rank0 is being written
                     end else begin
                       phy_tmp_odt_r 
                         <= #TCQ 4'b0101; // ODT for ranks 0 and 2 aserted
                     end
                   end else if ((init_state_r == INIT_RDLVL_STG1_READ) ||
                                (init_state_r == INIT_RDLVL_COMPLEX_READ) ||                   
                                (init_state_r == INIT_PI_PHASELOCK_READS) ||
                                (init_state_r == INIT_RDLVL_STG2_READ) ||
                                (init_state_r == INIT_OCLKDELAY_READ) ||
                                (init_state_r == INIT_WRCAL_READ) ||
                                (init_state_r == INIT_WRCAL_MULT_READS))begin
                     if (chip_cnt_r == 2'b00) begin
                       phy_tmp_odt_r 
                         <= #TCQ 4'b0100;
                     end else begin
                       phy_tmp_odt_r
                       <= #TCQ 4'b0001;
                     end
                   end
              end
              
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};   
              
            end
            // Two Slots - One slot with dual rank and other with single rank
            4'b11_10: begin
              
              //Rank2 Rtt_NOM
              tmp_mr1_r[2] <= #TCQ (RTT_NOM2 == "60") ? 3'b001 :
                                   (RTT_NOM2 == "120") ? 3'b010 :
                                   (RTT_NOM2 == "20") ? 3'b100 :
                                   (RTT_NOM2 == "30") ? 3'b101 :
                                   (RTT_NOM2 == "40") ? 3'b011:
                                   3'b000;
              tmp_mr2_r[2] <= #TCQ 2'b00;
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[1] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     (RTT_NOM_int == "20") ? 3'b100 :
                                     (RTT_NOM_int == "30") ? 3'b101 :
                                     (RTT_NOM_int == "40") ? 3'b011:
                                     3'b000;
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
              
              if(DRAM_TYPE == "DDR2")begin
                if(chip_cnt_r[1] == 1'b1)begin
                  phy_tmp_odt_r <= 
                                   #TCQ 4'b0001;
                end else begin
                  phy_tmp_odt_r 
                    <= #TCQ 4'b0100; // rank 2 ODT asserted
                end
              end else begin 
                if (// wrlvl_odt ||
                    (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                    (init_state_r == INIT_WRCAL_WRITE) ||
                    (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                    (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                  
                  if (chip_cnt_r[1] == 1'b1) begin
                    phy_tmp_odt_r 
                      <= #TCQ 4'b0110;
                  end else begin
                    phy_tmp_odt_r <= 
                                     #TCQ 4'b0101;
                  end
                end else if ((init_state_r == INIT_RDLVL_STG1_READ) ||
                         (init_state_r == INIT_RDLVL_COMPLEX_READ) ||
                             (init_state_r == INIT_PI_PHASELOCK_READS) ||
                             (init_state_r == INIT_RDLVL_STG2_READ) ||
                             (init_state_r == INIT_OCLKDELAY_READ) ||
                             (init_state_r == INIT_WRCAL_READ) ||
                             (init_state_r == INIT_WRCAL_MULT_READS)) begin
                  
                     if (chip_cnt_r[1] == 1'b1) begin
                       phy_tmp_odt_r[(1*nCS_PER_RANK) +: nCS_PER_RANK] 
                         <= #TCQ 4'b0010;
                     end else begin
                       phy_tmp_odt_r 
                         <= #TCQ 4'b0100;
                     end
                end
              end
              
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};
            end
            // Two Slots - two ranks per slot
            4'b11_11: begin
              //Rank2 Rtt_NOM
              tmp_mr1_r[2] <= #TCQ (RTT_NOM2 == "60") ? 3'b001 :
                                   (RTT_NOM2 == "120") ? 3'b010 :
                                   (RTT_NOM2 == "20") ? 3'b100 :
                                   (RTT_NOM2 == "30") ? 3'b101 :
                                   (RTT_NOM2 == "40") ? 3'b011 :
                                   3'b000;
              //Rank3 Rtt_NOM
              tmp_mr1_r[3] <= #TCQ (RTT_NOM3 == "60") ? 3'b001 :
                                   (RTT_NOM3 == "120") ? 3'b010 :
                                   (RTT_NOM3 == "20") ? 3'b100 :
                                   (RTT_NOM3 == "30") ? 3'b101 :
                                   (RTT_NOM3 == "40") ? 3'b011 :
                                   3'b000;
              tmp_mr2_r[2] <= #TCQ 2'b00;
              tmp_mr2_r[3] <= #TCQ 2'b00;
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done &&
                   (wrlvl_rank_cntr==3'd0))) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[1] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM after write leveling completes
                tmp_mr1_r[1] <= #TCQ 3'b000;
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM after write leveling completes
                tmp_mr1_r[0] <= #TCQ 3'b000;
              end
              
              if(DRAM_TYPE == "DDR2")begin
                if(chip_cnt_r[1] == 1'b1)begin
                  phy_tmp_odt_r
                    <= #TCQ 4'b0001;
                end else begin
                  phy_tmp_odt_r
                    <= #TCQ 4'b0100;
                end
              end else begin
                if (//wrlvl_odt ||
                    (init_state_r == INIT_RDLVL_STG1_WRITE) || 
                    (init_state_r == INIT_WRCAL_WRITE) ||
                    (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                    (init_state_r == INIT_OCLKDELAY_WRITE)) begin
                  //Slot1 Rank1 or Rank3 is being written
                  if (chip_cnt_r[0] == 1'b1) begin
                    phy_tmp_odt_r
                      <= #TCQ 4'b0110;
                    //Slot0 Rank0 or Rank2 is being written
                  end else begin
                    phy_tmp_odt_r
                      <= #TCQ 4'b1001;
                  end
                end else if ((init_state_r == INIT_RDLVL_STG1_READ) ||
                             (init_state_r == INIT_RDLVL_COMPLEX_READ) ||                
                             (init_state_r == INIT_PI_PHASELOCK_READS) ||
                             (init_state_r == INIT_RDLVL_STG2_READ) ||
                             (init_state_r == INIT_OCLKDELAY_READ) ||
                             (init_state_r == INIT_WRCAL_READ) ||
                             (init_state_r == INIT_WRCAL_MULT_READS))begin
                  //Slot1 Rank1 or Rank3 is being read
                  if (chip_cnt_r[0] == 1'b1) begin
                    phy_tmp_odt_r
                      <= #TCQ 4'b0100;
                    //Slot0 Rank0 or Rank2 is being read
                  end else begin
                    phy_tmp_odt_r
                      <= #TCQ 4'b1000;
                  end
                end
              end
              
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};
            end
            default: begin
              phy_tmp_odt_r <= #TCQ 4'b1111;
              // Chip Select assignments
              phy_tmp_cs1_r[(chip_cnt_r*nCS_PER_RANK) +: nCS_PER_RANK] 
                <= #TCQ {nCS_PER_RANK{1'b0}};
              if ((RTT_WR == "OFF") ||
                  ((WRLVL=="ON") && ~wrlvl_done)) begin
                //Rank0 Dynamic ODT disabled
                tmp_mr2_r[0] <= #TCQ 2'b00;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     3'b000;
                //Rank1 Dynamic ODT disabled
                tmp_mr2_r[1] <= #TCQ 2'b00;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "40") ? 3'b011 :
                                     (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "60") ? 3'b010 :
                                     3'b000;
              end else begin
                //Rank0 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[0] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank0 Rtt_NOM
                tmp_mr1_r[0] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     (RTT_NOM_int == "20") ? 3'b100 :
                                     (RTT_NOM_int == "30") ? 3'b101 :
                                     (RTT_NOM_int == "40") ? 3'b011 :
                                     3'b000;
                //Rank1 Dynamic ODT defaults to 120 ohms
                tmp_mr2_r[1] <= #TCQ (RTT_WR == "60") ? 2'b01 :
                                2'b10;
                //Rank1 Rtt_NOM
                tmp_mr1_r[1] <= #TCQ (RTT_NOM_int == "60") ? 3'b001 :
                                     (RTT_NOM_int == "120") ? 3'b010 :
                                     (RTT_NOM_int == "20") ? 3'b100 :
                                     (RTT_NOM_int == "30") ? 3'b101 :
                                     (RTT_NOM_int == "40") ? 3'b011 :
                                     3'b000;
              end
            end
          endcase
        end
      end
    end
  endgenerate


  // PHY only supports two ranks.
  // calib_aux_out[0] is CKE for rank 0 and calib_aux_out[1] is ODT for rank 0
  // calib_aux_out[2] is CKE for rank 1 and calib_aux_out[3] is ODT for rank 1

generate
if(CKE_ODT_AUX == "FALSE") begin
  if ((nSLOTS == 1) && (RANKS < 2)) begin
    always @(posedge clk)
      if (rst) begin
    calib_cke <= #TCQ {nCK_PER_CLK{1'b0}} ;
    calib_odt <= 2'b00 ;
      end else begin
        if (cnt_pwron_cke_done_r /*&& ~cnt_pwron_cke_done_r1*/)begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b1}};
        end else begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b0}};
        end
        if ((((RTT_NOM == "DISABLED") && (RTT_WR == "OFF"))/* ||
         wrlvl_rank_done || wrlvl_rank_done_r1 ||
        (wrlvl_done && !wrlvl_done_r)*/) && (DRAM_TYPE == "DDR3")) begin
          calib_odt[0] <= #TCQ 1'b0;
          calib_odt[1] <= #TCQ 1'b0;
        end else if (((DRAM_TYPE == "DDR3") 
               ||((RTT_NOM != "DISABLED") && (DRAM_TYPE == "DDR2"))) 
               && (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt ) || 
               (init_state_r == INIT_RDLVL_STG1_WRITE) ||
               (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
               (init_state_r == INIT_RDLVL_STG1_WRITE_READ) ||
               complex_odt_ext ||
               (init_state_r == INIT_WRCAL_WRITE) ||
               (init_state_r == INIT_WRCAL_WRITE_READ) ||
               (init_state_r == INIT_OCAL_CENTER_WRITE) || 
               complex_ocal_odt_ext ||
               (init_state_r == INIT_OCLKDELAY_WRITE)||
	       (init_state_r == INIT_OCLKDELAY_WRITE_WAIT))) begin
          // Quad rank in a single slot  
          calib_odt[0] <= #TCQ phy_tmp_odt_r[0];
          calib_odt[1] <= #TCQ phy_tmp_odt_r[1];
        end else begin
          calib_odt[0] <= #TCQ 1'b0;
          calib_odt[1] <= #TCQ 1'b0;
        end
      end
  end else if ((nSLOTS == 1) && (RANKS <= 2)) begin
    always @(posedge clk)
      if (rst) begin
        calib_cke <= #TCQ {nCK_PER_CLK{1'b0}} ;
        calib_odt <= 2'b00 ;
      end else begin
        if (cnt_pwron_cke_done_r /*&& ~cnt_pwron_cke_done_r1*/)begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b1}};
        end else begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b0}};
        end
        if ((((RTT_NOM == "DISABLED") && (RTT_WR == "OFF"))/* ||
         wrlvl_rank_done_r2 ||
        (wrlvl_done && !wrlvl_done_r)*/) && (DRAM_TYPE == "DDR3")) begin
          calib_odt[0] <= #TCQ 1'b0;
          calib_odt[1] <= #TCQ 1'b0;
        end else if (((DRAM_TYPE == "DDR3") 
               ||((RTT_NOM != "DISABLED") && (DRAM_TYPE == "DDR2"))) 
               && (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt)|| 
               (init_state_r == INIT_RDLVL_STG1_WRITE) ||
               (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
               (init_state_r == INIT_RDLVL_STG1_WRITE_READ) ||
               complex_odt_ext ||
               (init_state_r == INIT_WRCAL_WRITE) ||
               (init_state_r == INIT_WRCAL_WRITE_READ) ||
               (init_state_r == INIT_OCAL_CENTER_WRITE) || 
               complex_ocal_odt_ext ||
               (init_state_r == INIT_OCLKDELAY_WRITE)||
               (init_state_r == INIT_OCLKDELAY_WRITE_WAIT))) begin
          // Dual rank in a single slot  
          calib_odt[0] <= #TCQ phy_tmp_odt_r[0];
          calib_odt[1] <= #TCQ phy_tmp_odt_r[1];
        end else begin
          calib_odt[0] <= #TCQ 1'b0;
          calib_odt[1] <= #TCQ 1'b0;
        end
      end
  end else if ((nSLOTS == 2) && (RANKS == 2)) begin
    always @(posedge clk)
      if (rst)begin
        calib_cke <= #TCQ {nCK_PER_CLK{1'b0}} ;
        calib_odt <= 2'b00 ;
      end else begin
        if (cnt_pwron_cke_done_r /*&& ~cnt_pwron_cke_done_r1*/)begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b1}};
        end else begin
          calib_cke <= #TCQ {nCK_PER_CLK{1'b0}};
        end
        if (((DRAM_TYPE == "DDR2") && (RTT_NOM == "DISABLED")) ||
            ((DRAM_TYPE == "DDR3") &&
             (RTT_NOM == "DISABLED") && (RTT_WR == "OFF"))) begin
          calib_odt[0] <= #TCQ 1'b0;
          calib_odt[1] <= #TCQ 1'b0;
        end else if (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt) || 
                      (init_state_r == INIT_RDLVL_STG1_WRITE) ||
                      (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
                      (init_state_r == INIT_WRCAL_WRITE) ||
                      (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                      (init_state_r == INIT_OCLKDELAY_WRITE)) begin
           // Quad rank in a single slot  
            if (nCK_PER_CLK == 2) begin
              calib_odt[0] 
                <= #TCQ (!calib_odt[0]) ? phy_tmp_odt_r[0] : 1'b0;
              calib_odt[1] 
                <= #TCQ (!calib_odt[1]) ? phy_tmp_odt_r[1] : 1'b0;
            end else begin 
              calib_odt[0] <= #TCQ phy_tmp_odt_r[0];
              calib_odt[1] <= #TCQ phy_tmp_odt_r[1];
            end
        // Turn on for idle rank during read if dynamic ODT is enabled in DDR3
        end else if(((DRAM_TYPE == "DDR3") && (RTT_WR != "OFF")) &&
                    ((init_state_r == INIT_PI_PHASELOCK_READS) ||
                     (init_state_r == INIT_MPR_READ) ||
                     (init_state_r == INIT_RDLVL_STG1_READ) ||
                     (init_state_r == INIT_RDLVL_COMPLEX_READ) ||
                     (init_state_r == INIT_RDLVL_STG2_READ) ||
                     (init_state_r == INIT_OCLKDELAY_READ) ||
                     (init_state_r == INIT_WRCAL_READ) ||
                     (init_state_r == INIT_WRCAL_MULT_READS))) begin
            if (nCK_PER_CLK == 2) begin
              calib_odt[0] 
                <= #TCQ (!calib_odt[0]) ? phy_tmp_odt_r[0] : 1'b0;
              calib_odt[1] 
                <= #TCQ (!calib_odt[1]) ? phy_tmp_odt_r[1] : 1'b0;
            end else begin 
              calib_odt[0] <= #TCQ phy_tmp_odt_r[0];
              calib_odt[1] <= #TCQ phy_tmp_odt_r[1];
            end
        // disable well before next command and before disabling write leveling
        end else if(cnt_cmd_done_m7_r ||
                   (init_state_r == INIT_WRLVL_WAIT && ~wrlvl_odt))
          calib_odt <= #TCQ 2'b00;
      end
  end
end else begin//USE AUX OUTPUT for routing CKE and ODT.
  if ((nSLOTS == 1) && (RANKS < 2)) begin
    always @(posedge clk)
      if (rst) begin
        calib_aux_out <= #TCQ 4'b0000;
      end else begin
        if (cnt_pwron_cke_done_r && ~cnt_pwron_cke_done_r1)begin
          calib_aux_out[0] <= #TCQ 1'b1;
          calib_aux_out[2] <= #TCQ 1'b1;
        end else begin
          calib_aux_out[0] <= #TCQ 1'b0;
          calib_aux_out[2] <= #TCQ 1'b0;
        end
        if ((((RTT_NOM == "DISABLED") && (RTT_WR == "OFF")) ||
         wrlvl_rank_done || wrlvl_rank_done_r1 ||
        (wrlvl_done && !wrlvl_done_r)) && (DRAM_TYPE == "DDR3")) begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end else if (((DRAM_TYPE == "DDR3") 
               ||((RTT_NOM != "DISABLED") && (DRAM_TYPE == "DDR2"))) 
               && (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt) || 
               (init_state_r == INIT_RDLVL_STG1_WRITE) ||
               (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
               (init_state_r == INIT_WRCAL_WRITE) ||
               (init_state_r == INIT_OCAL_CENTER_WRITE) || 
               (init_state_r == INIT_OCLKDELAY_WRITE))) begin
          // Quad rank in a single slot  
          calib_aux_out[1] <= #TCQ phy_tmp_odt_r[0];
          calib_aux_out[3] <= #TCQ phy_tmp_odt_r[1];
        end else begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end
      end
  end else if ((nSLOTS == 1) && (RANKS <= 2)) begin
    always @(posedge clk)
      if (rst) begin
        calib_aux_out <= #TCQ 4'b0000;
      end else begin
        if (cnt_pwron_cke_done_r && ~cnt_pwron_cke_done_r1)begin
          calib_aux_out[0] <= #TCQ 1'b1;
          calib_aux_out[2] <= #TCQ 1'b1;
        end else begin
          calib_aux_out[0] <= #TCQ 1'b0;
          calib_aux_out[2] <= #TCQ 1'b0;
        end
        if ((((RTT_NOM == "DISABLED") && (RTT_WR == "OFF")) ||
         wrlvl_rank_done_r2 ||
        (wrlvl_done && !wrlvl_done_r)) && (DRAM_TYPE == "DDR3")) begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end else if (((DRAM_TYPE == "DDR3") 
               ||((RTT_NOM != "DISABLED") && (DRAM_TYPE == "DDR2"))) 
               && (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt) || 
               (init_state_r == INIT_RDLVL_STG1_WRITE) ||
               (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
               (init_state_r == INIT_WRCAL_WRITE) ||
               (init_state_r == INIT_OCAL_CENTER_WRITE) || 
               (init_state_r == INIT_OCLKDELAY_WRITE))) begin
          // Dual rank in a single slot  
          calib_aux_out[1] <= #TCQ phy_tmp_odt_r[0];
          calib_aux_out[3] <= #TCQ phy_tmp_odt_r[1];
        end else begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end
      end
  end else if ((nSLOTS == 2) && (RANKS == 2)) begin
    always @(posedge clk)
      if (rst)
        calib_aux_out <= #TCQ 4'b0000;
      else begin
        if (cnt_pwron_cke_done_r && ~cnt_pwron_cke_done_r1)begin
          calib_aux_out[0] <= #TCQ 1'b1;
          calib_aux_out[2] <= #TCQ 1'b1;
        end else begin
          calib_aux_out[0] <= #TCQ 1'b0;
          calib_aux_out[2] <= #TCQ 1'b0;
        end
        if ((((RTT_NOM == "DISABLED") && (RTT_WR == "OFF")) ||
         wrlvl_rank_done_r2 ||
        (wrlvl_done && !wrlvl_done_r)) && (DRAM_TYPE == "DDR3")) begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end else if (((DRAM_TYPE == "DDR3") 
               ||((RTT_NOM != "DISABLED") && (DRAM_TYPE == "DDR2"))) 
               && (((init_state_r == INIT_WRLVL_WAIT) && wrlvl_odt) || 
               (init_state_r == INIT_RDLVL_STG1_WRITE) ||
               (init_state_r == INIT_OCAL_COMPLEX_WRITE_WAIT) ||
               (init_state_r == INIT_WRCAL_WRITE) ||
               (init_state_r == INIT_OCAL_CENTER_WRITE) || 
               (init_state_r == INIT_OCLKDELAY_WRITE))) begin 
           // Quad rank in a single slot  
            if (nCK_PER_CLK == 2) begin
              calib_aux_out[1] 
                <= #TCQ (!calib_aux_out[1]) ? phy_tmp_odt_r[0] : 1'b0;
              calib_aux_out[3] 
                <= #TCQ (!calib_aux_out[3]) ? phy_tmp_odt_r[1] : 1'b0;
            end else begin 
              calib_aux_out[1] <= #TCQ phy_tmp_odt_r[0];
              calib_aux_out[3] <= #TCQ phy_tmp_odt_r[1];
            end
        end else begin
          calib_aux_out[1] <= #TCQ 1'b0;
          calib_aux_out[3] <= #TCQ 1'b0;
        end
      end
  end
end 
endgenerate
   
  //*****************************************************************
  // memory address during init
  //*****************************************************************

  always @(posedge clk)
    phy_data_full_r <= #TCQ phy_data_full;
// verilint STARC-2.7.3.3b off
  always @(*)begin
    // Bus 0 for address/bank never used
    address_w = 'b0;
    bank_w   = 'b0;
    if ((init_state_r == INIT_PRECHARGE) ||
        (init_state_r == INIT_RDLVL_COMPLEX_PRECHARGE) ||
        (init_state_r == INIT_ZQCL) ||
        (init_state_r == INIT_DDR2_PRECHARGE)) begin
      // Set A10=1 for ZQ long calibration or Precharge All
      address_w     = 'b0;
      address_w[10] = 1'b1;
      bank_w        = 'b0;
    end else if (init_state_r == INIT_WRLVL_START) begin
      // Enable wrlvl in MR1
      bank_w[1:0]   = 2'b01;
      address_w     = load_mr1[ROW_WIDTH-1:0];
      address_w[2]  = mr1_r[chip_cnt_r][0];
      address_w[6]  = mr1_r[chip_cnt_r][1];
      address_w[9]  = mr1_r[chip_cnt_r][2];
      address_w[7]  = 1'b1;
    end else if (init_state_r == INIT_WRLVL_LOAD_MR) begin
      // Finished with write leveling, disable wrlvl in MR1
      // For single rank disable Rtt_Nom
      bank_w[1:0]   = 2'b01;
      address_w     = load_mr1[ROW_WIDTH-1:0];
      address_w[2]  = mr1_r[chip_cnt_r][0];
      address_w[6]  = mr1_r[chip_cnt_r][1];
      address_w[9]  = mr1_r[chip_cnt_r][2];
    end else if (init_state_r == INIT_WRLVL_LOAD_MR2) begin
      // Set RTT_WR in MR2 after write leveling disabled
      bank_w[1:0]     = 2'b10;
      address_w       = load_mr2[ROW_WIDTH-1:0];
      address_w[10:9] = mr2_r[chip_cnt_r];
    end else if (init_state_r == INIT_MPR_READ) begin
      address_w     = 'b0;
      bank_w        = 'b0;
    end else if (init_state_r == INIT_MPR_RDEN) begin
      // Enable MPR read with LMR3 and A2=1
      bank_w[BANK_WIDTH-1:0] = 'd3;
      address_w              = {ROW_WIDTH{1'b0}};
      address_w[2]           = 1'b1;
    end else if (init_state_r == INIT_MPR_DISABLE) begin
      // Disable MPR read with LMR3 and A2=0
      bank_w[BANK_WIDTH-1:0] = 'd3;
      address_w              = {ROW_WIDTH{1'b0}}; 
    end else if ((init_state_r == INIT_REG_WRITE)&
             (DRAM_TYPE == "DDR3"))begin
      // bank_w is assigned a 3 bit value. In some
      // DDR2 cases there will be only two bank bits.
      //Qualifying the condition with DDR3
      bank_w        = 'b0;
      address_w     = 'b0;
      case (reg_ctrl_cnt_r)
        4'h1:begin
          address_w[4:0] = REG_RC1[4:0];
          bank_w         = REG_RC1[7:5];
        end
        4'h2: address_w[4:0] = REG_RC2[4:0];
        4'h3: begin
          address_w[4:0] = REG_RC3[4:0];
          bank_w         = REG_RC3[7:5];
        end
        4'h4: begin
          address_w[4:0] = REG_RC4[4:0];
          bank_w         = REG_RC4[7:5];
        end
        4'h5: begin
          address_w[4:0] = REG_RC5[4:0];
          bank_w         = REG_RC5[7:5];
        end
        4'h6: begin
          address_w[4:0] = REG_RC10[4:0];
          bank_w         = REG_RC10[7:5];
        end
        4'h7: begin
          address_w[4:0] = REG_RC11[4:0];
          bank_w         = REG_RC11[7:5];
        end
        default: address_w[4:0] = REG_RC0[4:0];
      endcase
    end else if (init_state_r == INIT_LOAD_MR) begin
      // If loading mode register, look at cnt_init_mr to determine
      // which MR is currently being programmed
      address_w     = 'b0;
      bank_w        = 'b0;
      if(DRAM_TYPE == "DDR3")begin
        if(rdlvl_stg1_done && prbs_rdlvl_done && pi_dqs_found_done)begin
          // end of the calibration programming correct
          // burst length
          if (TEST_AL == "0") begin
            bank_w[1:0] = 2'b00;
            address_w   = load_mr0[ROW_WIDTH-1:0];
            address_w[8]= 1'b0; //Don't reset DLL
          end else begin
            // programming correct AL value
            bank_w[1:0]   = 2'b01;
            address_w     = load_mr1[ROW_WIDTH-1:0];
            if (TEST_AL == "CL-1")
              address_w[4:3]= 2'b01; // AL="CL-1"
            else
              address_w[4:3]= 2'b10; // AL="CL-2"
          end
        end else begin
         case (cnt_init_mr_r)
           INIT_CNT_MR2: begin
             bank_w[1:0] = 2'b10;
             address_w   = load_mr2[ROW_WIDTH-1:0];
             address_w[10:9] = mr2_r[chip_cnt_r];
           end
           INIT_CNT_MR3: begin
             bank_w[1:0] = 2'b11;
             address_w   = load_mr3[ROW_WIDTH-1:0];
           end
           INIT_CNT_MR1: begin
             bank_w[1:0] = 2'b01;
             address_w   = load_mr1[ROW_WIDTH-1:0];
             address_w[2] = mr1_r[chip_cnt_r][0];
             address_w[6] = mr1_r[chip_cnt_r][1];
             address_w[9] = mr1_r[chip_cnt_r][2];
           end
           INIT_CNT_MR0: begin
             bank_w[1:0] = 2'b00;
             address_w   = load_mr0[ROW_WIDTH-1:0];
             // fixing it to BL8 for calibration
             address_w[1:0] = 2'b00;
           end
           default: begin
             bank_w      = {BANK_WIDTH{1'bx}};
             address_w   = {ROW_WIDTH{1'bx}};
           end
          endcase
        end
      end else begin // DDR2
         case (cnt_init_mr_r)
           INIT_CNT_MR2: begin
             if(~ddr2_refresh_flag_r)begin
                bank_w[1:0] = 2'b10;
                address_w   = load_mr2[ROW_WIDTH-1:0];
             end else begin // second set of lm commands
                bank_w[1:0] = 2'b00;
                address_w   = load_mr0[ROW_WIDTH-1:0];
                address_w[8]= 1'b0;
                //MRS command without resetting DLL
             end
          end
           INIT_CNT_MR3: begin
             if(~ddr2_refresh_flag_r)begin
               bank_w[1:0] = 2'b11;
               address_w   = load_mr3[ROW_WIDTH-1:0];
             end else begin // second set of lm commands
               bank_w[1:0] = 2'b00;
               address_w   = load_mr0[ROW_WIDTH-1:0];
               address_w[8]= 1'b0;
               //MRS command without resetting DLL. Repeted again
               // because there is an extra state.
            end
           end
           INIT_CNT_MR1: begin
             bank_w[1:0] = 2'b01;            
             if(~ddr2_refresh_flag_r)begin               
               address_w   = load_mr1[ROW_WIDTH-1:0];  
             end else begin // second set of lm commands
               address_w   = load_mr1[ROW_WIDTH-1:0];
               address_w[9:7] = 3'b111;
               //OCD default state
             end
           end
           INIT_CNT_MR0: begin
             if(~ddr2_refresh_flag_r)begin
               bank_w[1:0] = 2'b00;
               address_w   = load_mr0[ROW_WIDTH-1:0];
             end else begin // second set of lm commands
               bank_w[1:0] = 2'b01;
               address_w   = load_mr1[ROW_WIDTH-1:0];
               if((chip_cnt_r == 2'd1) || (chip_cnt_r == 2'd3))begin
               // always disable odt for rank 1 and rank 3 as per SPEC
                 address_w[2] = 'b0;
                 address_w[6] = 'b0;
               end 
                //OCD exit
             end
           end
           default: begin
             bank_w      = {BANK_WIDTH{1'bx}};
             address_w   = {ROW_WIDTH{1'bx}};
           end
         endcase
       end
    end else if ( ~prbs_rdlvl_done && ((init_state_r == INIT_PI_PHASELOCK_READS) ||
                 (init_state_r == INIT_RDLVL_STG1_WRITE) ||
                 (init_state_r == INIT_RDLVL_STG1_READ) ||
                 (init_state_r == INIT_RDLVL_COMPLEX_READ))) begin
      // Writing and reading PRBS pattern for read leveling stage 1
      // Need to support burst length 4 or 8. PRBS pattern will be
      // written to entire row and read back from the same row repeatedly 
      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      address_w[ROW_WIDTH-1:COL_WIDTH] = {ROW_WIDTH-COL_WIDTH{1'b0}};
      if (((stg1_wr_rd_cnt == NUM_STG1_WR_RD) && ~rdlvl_stg1_done) || (stg1_wr_rd_cnt == 'd127) || 
          ((stg1_wr_rd_cnt == 'd22) && (((init_state_r1 != INIT_RDLVL_STG1_WRITE) && ~stg1_wr_done) || complex_row0_rd_done))) begin
          address_w[COL_WIDTH-1:0] = {COL_WIDTH{1'b0}};
      end else if (phy_data_full_r || (!new_burst_r))
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0];
      else if ((stg1_wr_rd_cnt >= 9'd0) && new_burst_r && ~phy_data_full_r) begin
        if ((init_state_r == INIT_RDLVL_COMPLEX_READ) && (init_state_r1 != INIT_RDLVL_COMPLEX_READ) )// ||
            // ((init_state_r == INIT_RDLVL_STG1_WRITE) && prbs_rdlvl_done) )
          address_w[COL_WIDTH-1:0] = complex_address[COL_WIDTH-1:0] + ADDR_INC;
        else
          address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0] + ADDR_INC;
      end
      //need to add address for complex oclkdelay calib
    end else if (prbs_rdlvl_done && ((init_state_r == INIT_RDLVL_STG1_WRITE) ||             
                 (init_state_r == INIT_RDLVL_COMPLEX_READ))) begin
      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      address_w[ROW_WIDTH-1:COL_WIDTH] = {ROW_WIDTH-COL_WIDTH{1'b0}};
       if ((stg1_wr_rd_cnt == 'd127) || ((stg1_wr_rd_cnt == 'd30) && (((init_state_r1 != INIT_RDLVL_STG1_WRITE) && ~stg1_wr_done) || complex_row0_rd_done))) begin
              address_w[COL_WIDTH-1:0] = {COL_WIDTH{1'b0}};
      end else if (phy_data_full_r || (!new_burst_r))
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0];
      else if ((stg1_wr_rd_cnt >= 9'd0) && new_burst_r && ~phy_data_full_r) begin
        if ((init_state_r == INIT_RDLVL_STG1_WRITE) && (init_state_r1 != INIT_RDLVL_STG1_WRITE) )
            // ((init_state_r == INIT_RDLVL_STG1_WRITE) && prbs_rdlvl_done) )
          address_w[COL_WIDTH-1:0] = complex_address[COL_WIDTH-1:0] + ADDR_INC;
        else
          address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0] + ADDR_INC;
      end      
      
    end else if ((init_state_r == INIT_OCLKDELAY_WRITE) ||
                 (init_state_r == INIT_OCAL_CENTER_WRITE) || 
                 (init_state_r == INIT_OCLKDELAY_READ)) begin
      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      address_w[ROW_WIDTH-1:COL_WIDTH] = {ROW_WIDTH-COL_WIDTH{1'b0}};
      if (oclk_wr_cnt == NUM_STG1_WR_RD)
        address_w[COL_WIDTH-1:0] = {COL_WIDTH{1'b0}};
      else if (phy_data_full_r || (!new_burst_r))
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0];
      else if ((oclk_wr_cnt >= 4'd0) && new_burst_r && ~phy_data_full_r)
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0] + ADDR_INC;
    end else if ((init_state_r == INIT_WRCAL_WRITE) ||
                 (init_state_r == INIT_WRCAL_READ)) begin
      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      address_w[ROW_WIDTH-1:COL_WIDTH] = {ROW_WIDTH-COL_WIDTH{1'b0}};
      if (wrcal_wr_cnt == NUM_STG1_WR_RD)
        address_w[COL_WIDTH-1:0] = {COL_WIDTH{1'b0}};
      else if (phy_data_full_r || (!new_burst_r))
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0];
      else if ((wrcal_wr_cnt >= 4'd0) && new_burst_r && ~phy_data_full_r)
        address_w[COL_WIDTH-1:0] = phy_address[COL_WIDTH-1:0] + ADDR_INC;      
    end else if ((init_state_r == INIT_WRCAL_MULT_READS) ||
                 (init_state_r == INIT_RDLVL_STG2_READ)) begin
      // when writing or reading back training pattern for read leveling stage2
      // need to support burst length of 4 or 8. This may mean issuing
      // multiple commands to cover the entire range of addresses accessed
      // during read leveling.
      // Hard coding A[12] to 1 so that it will always be burst length of 8
      // for DDR3. Does not have any effect on DDR2. 
      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      address_w[ROW_WIDTH-1:COL_WIDTH] = {ROW_WIDTH-COL_WIDTH{1'b0}};
      address_w[COL_WIDTH-1:0] = 
                {CALIB_COL_ADD[COL_WIDTH-1:3],burst_addr_r, 3'b000};
      address_w[12]            =  1'b1;
    end else if ((init_state_r == INIT_RDLVL_ACT) ||
                (init_state_r == INIT_RDLVL_COMPLEX_ACT) ||
                (init_state_r == INIT_WRCAL_ACT) ||
                (init_state_r == INIT_OCAL_COMPLEX_ACT) ||
                (init_state_r == INIT_OCAL_CENTER_ACT) ||
                (init_state_r == INIT_OCLKDELAY_ACT)) begin

      bank_w    = CALIB_BA_ADD[BANK_WIDTH-1:0];
      //if (stg1_wr_rd_cnt == 'd22)
      //  address_w = CALIB_ROW_ADD[ROW_WIDTH-1:0] + 1;
      //else
      address_w = prbs_rdlvl_done ? CALIB_ROW_ADD[ROW_WIDTH-1:0] + complex_row_cnt_ocal :
                  CALIB_ROW_ADD[ROW_WIDTH-1:0] + complex_row_cnt;
    end else begin
      bank_w    = {BANK_WIDTH{1'bx}};
      address_w = {ROW_WIDTH{1'bx}};
    end
  end      
  // verilint STARC-2.7.3.3b on
  // registring before sending out
  generate
    genvar r,s;
    if ((DRAM_TYPE != "DDR3") || (CA_MIRROR != "ON")) begin: gen_no_mirror
      for (r = 0; r < nCK_PER_CLK; r = r + 1) begin: div_clk_loop
        always @(posedge clk) begin
          phy_address[(r*ROW_WIDTH) +: ROW_WIDTH] <= #TCQ address_w;
          phy_bank[(r*BANK_WIDTH) +: BANK_WIDTH]  <= #TCQ bank_w;
        end
      end
    end else begin: gen_mirror
      // Control/addressing mirroring (optional for DDR3 dual rank DIMMs)
      // Mirror for the 2nd rank only. Logic needs to be enhanced to account
      // for multiple slots, currently only supports one slot, 2-rank config

      for (r = 0; r < nCK_PER_CLK; r = r + 1) begin: gen_ba_div_clk_loop        
        for (s = 0; s < BANK_WIDTH; s = s + 1) begin: gen_ba
          
          always @(posedge clk)
            if (chip_cnt_r == 2'b00) begin
              phy_bank[(r*BANK_WIDTH) + s] <= #TCQ bank_w[s];
            end else begin
              phy_bank[(r*BANK_WIDTH) + s] <= #TCQ bank_w[(s == 0) ? 1 : ((s == 1) ? 0 : s)];
            end

        end
      end

      for (r = 0; r < nCK_PER_CLK; r = r + 1) begin: gen_addr_div_clk_loop        
        for (s = 0; s < ROW_WIDTH; s = s + 1) begin: gen_addr
          always @(posedge clk) 
            if (chip_cnt_r == 2'b00) begin 
              phy_address[(r*ROW_WIDTH) + s] <= #TCQ address_w[s];
            end else begin 
              phy_address[(r*ROW_WIDTH) + s] <= #TCQ address_w[
                                                      (s == 3) ? 4 : 
                                                     ((s == 4) ? 3 :
                                                     ((s == 5) ? 6 : 
                                                     ((s == 6) ? 5 :
                                                     ((s == 7) ? 8 : 
                                                     ((s == 8) ? 7 : s)))))];
            end
        end
      end
      
    end
  endgenerate
  
endmodule

