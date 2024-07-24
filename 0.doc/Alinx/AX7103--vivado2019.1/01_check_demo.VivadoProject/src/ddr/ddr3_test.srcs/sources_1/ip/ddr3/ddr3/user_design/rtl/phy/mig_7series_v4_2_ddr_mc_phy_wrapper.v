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
//  /   /         Filename              : ddr_mc_phy_wrapper.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Oct 10 2010
//  \___\/\___\
//
//Device            : 7 Series
//Design Name       : DDR3 SDRAM
//Purpose           : Wrapper file that encompasses the MC_PHY module
//                    instantiation and handles the vector remapping between
//                    the MC_PHY ports and the user's DDR3 ports. Vector
//                    remapping affects DDR3 control, address, and DQ/DQS/DM.
//Reference         :
//Revision History  :
//*****************************************************************************

`timescale 1 ps / 1 ps

module mig_7series_v4_2_ddr_mc_phy_wrapper #
  (
   parameter TCQ              = 100,    // Register delay (simulation only)
   parameter tCK              = 2500,   // ps
   parameter BANK_TYPE        = "HP_IO", // # = "HP_IO", "HPL_IO", "HR_IO", "HRL_IO"
   parameter DATA_IO_PRIM_TYPE = "DEFAULT", // # = "HP_LP", "HR_LP", "DEFAULT"
   parameter DATA_IO_IDLE_PWRDWN = "ON",  // "ON" or "OFF"
   parameter IODELAY_GRP      = "IODELAY_MIG",
   parameter FPGA_SPEED_GRADE = 1,
   parameter nCK_PER_CLK      = 4,      // Memory:Logic clock ratio
   parameter nCS_PER_RANK     = 1,      // # of unique CS outputs per rank
   parameter BANK_WIDTH       = 3,      // # of bank address
   parameter CKE_WIDTH        = 1,      // # of clock enable outputs
   parameter CS_WIDTH         = 1,      // # of chip select
   parameter CK_WIDTH         = 1,      // # of CK
   parameter CWL              = 5,      // CAS Write latency
   parameter DDR2_DQSN_ENABLE = "YES",  // Enable differential DQS for DDR2
   parameter DM_WIDTH         = 8,      // # of data mask
   parameter DQ_WIDTH         = 16,     // # of data bits
   parameter DQS_CNT_WIDTH    = 3,      // ceil(log2(DQS_WIDTH))
   parameter DQS_WIDTH        = 8,      // # of strobe pairs
   parameter DRAM_TYPE        = "DDR3", // DRAM type (DDR2, DDR3)
   parameter RANKS            = 4,      // # of ranks
   parameter ODT_WIDTH        = 1,      // # of ODT outputs
   parameter POC_USE_METASTABLE_SAMP = "FALSE",
   parameter REG_CTRL         = "OFF",  // "ON" for registered DIMM
   parameter ROW_WIDTH        = 16,     // # of row/column address
   parameter USE_CS_PORT      = 1,      // Support chip select output
   parameter USE_DM_PORT      = 1,      // Support data mask output
   parameter USE_ODT_PORT     = 1,      // Support ODT output
   parameter IBUF_LPWR_MODE   = "OFF",  // input buffer low power option
   parameter LP_DDR_CK_WIDTH  = 2,

   // Hard PHY parameters
   parameter PHYCTL_CMD_FIFO = "FALSE",
   parameter DATA_CTL_B0     = 4'hc,
   parameter DATA_CTL_B1     = 4'hf,
   parameter DATA_CTL_B2     = 4'hf,
   parameter DATA_CTL_B3     = 4'hf,
   parameter DATA_CTL_B4     = 4'hf,
   parameter BYTE_LANES_B0   = 4'b1111,
   parameter BYTE_LANES_B1   = 4'b0000,
   parameter BYTE_LANES_B2   = 4'b0000,
   parameter BYTE_LANES_B3   = 4'b0000,
   parameter BYTE_LANES_B4   = 4'b0000,
   parameter PHY_0_BITLANES  = 48'h0000_0000_0000,
   parameter PHY_1_BITLANES  = 48'h0000_0000_0000,
   parameter PHY_2_BITLANES  = 48'h0000_0000_0000,
   // Parameters calculated outside of this block
   parameter HIGHEST_BANK    = 3,        // Highest I/O bank index
   parameter HIGHEST_LANE    = 12,       // Highest byte lane index
   // ** Pin mapping parameters
   // Parameters for mapping between hard PHY and physical DDR3 signals
   // There are 2 classes of parameters:
   //   - DQS_BYTE_MAP, CK_BYTE_MAP, CKE_ODT_BYTE_MAP: These consist of
   //      8-bit elements. Each element indicates the bank and byte lane
   //      location of that particular signal. The bit lane in this case
   //      doesn't need to be specified, either because there's only one
   //      pin pair in each byte lane that the DQS or CK pair can be
   //      located at, or in the case of CKE_ODT_BYTE_MAP, only the byte
   //      lane needs to be specified in order to determine which byte
   //      lane generates the RCLK (Note that CKE, and ODT must be located
   //      in the same bank, thus only one element in CKE_ODT_BYTE_MAP)
   //        [7:4] = bank # (0-4)
   //        [3:0] = byte lane # (0-3)
   //   - All other MAP parameters: These consist of 12-bit elements. Each
   //      element indicates the bank, byte lane, and bit lane location of
   //      that particular signal:
   //        [11:8] = bank # (0-4)
   //        [7:4]  = byte lane # (0-3)
   //        [3:0]  = bit lane # (0-11)
   // Note that not all elements in all parameters will be used - it
   // depends on the actual widths of the DDR3 buses. The parameters are
   // structured to support a maximum of:
   //   - DQS groups: 18
   //   - data mask bits: 18
   // In addition, the default parameter size of some of the parameters will
   // support a certain number of bits, however, this can be expanded at
   // compile time by expanding the width of the vector passed into this
   // parameter
   //   - chip selects: 10
   //   - bank bits: 3
   //   - address bits: 16
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
   // DATAx_MAP parameter is used for byte lane X in the design
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
   // MASK0_MAP used for bytes [8:0], MASK1_MAP for bytes [17:9]
   parameter MASK0_MAP  = 108'h000_000_000_000_000_000_000_000_000,
   parameter MASK1_MAP  = 108'h000_000_000_000_000_000_000_000_000,
   // Simulation options
   parameter SIM_CAL_OPTION  = "NONE",

   // The PHY_CONTROL primitive in the bank where PLL exists is declared
   // as the Master PHY_CONTROL.
   parameter MASTER_PHY_CTL  = 1,
   parameter DRAM_WIDTH = 8,
   parameter PI_DIV2_INCDEC = "FALSE"
  )
  (
   input                               rst,
   input                               iddr_rst,
   input                               clk,
   input                               clk_div2,
   input                               freq_refclk,
   input                               mem_refclk,
   input                               pll_lock,
   input                               sync_pulse,
   input                               mmcm_ps_clk,
   input                               idelayctrl_refclk,
   input                               phy_cmd_wr_en,
   input                               phy_data_wr_en,
   input [31:0]                        phy_ctl_wd,
   input                               phy_ctl_wr,
   input                               phy_if_empty_def,
   input                               phy_if_reset,
   input [5:0]                         data_offset_1,
   input [5:0]                         data_offset_2,
   input [3:0]                         aux_in_1,
   input [3:0]                         aux_in_2,
   output [4:0]                        idelaye2_init_val,
   output [5:0]                        oclkdelay_init_val,
   output                              if_empty,
   output                              phy_ctl_full,
   output                              phy_cmd_full,
   output                              phy_data_full,
   output                              phy_pre_data_a_full,
   output [(CK_WIDTH * LP_DDR_CK_WIDTH)-1:0] ddr_clk,
   output                              phy_mc_go,
   input                               phy_write_calib,
   input                               phy_read_calib,
   input                               calib_in_common,
   input [5:0]                         calib_sel,
   input [DQS_CNT_WIDTH:0]             byte_sel_cnt,
   input [DRAM_WIDTH-1:0]              fine_delay_incdec_pb,
   input                               fine_delay_sel,
   input [HIGHEST_BANK-1:0]            calib_zero_inputs,
   input [HIGHEST_BANK-1:0]            calib_zero_ctrl,
   input [2:0]                         po_fine_enable,
   input [2:0]                         po_coarse_enable,
   input [2:0]                         po_fine_inc,
   input [2:0]                         po_coarse_inc,
   input                               po_counter_load_en,
   input                               po_counter_read_en,
   input [2:0]                         po_sel_fine_oclk_delay,
   input [8:0]                         po_counter_load_val,
   output [8:0]                        po_counter_read_val,
   output [5:0]                        pi_counter_read_val,
   input [HIGHEST_BANK-1:0]            pi_rst_dqs_find,
   input                               pi_fine_enable,
   input                               pi_fine_inc,
   input                               pi_counter_load_en,
   input [5:0]                         pi_counter_load_val,
   input                               idelay_ce,
   input                               idelay_inc,
   input                               idelay_ld,
   input                               idle,
   output                              pi_phase_locked,
   output                              pi_phase_locked_all,
   output                              pi_dqs_found,
   output                              pi_dqs_found_all,
   output                              pi_dqs_out_of_range,
   // From/to calibration logic/soft PHY
   input                                         phy_init_data_sel,
   input [nCK_PER_CLK*ROW_WIDTH-1:0]             mux_address,
   input [nCK_PER_CLK*BANK_WIDTH-1:0]            mux_bank,
   input [nCK_PER_CLK-1:0]                       mux_cas_n,
   input [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mux_cs_n,
   input [nCK_PER_CLK-1:0]                       mux_ras_n,
   input [1:0]                                   mux_odt,
   input [nCK_PER_CLK-1:0]                       mux_cke,
   input [nCK_PER_CLK-1:0]                       mux_we_n,
   input [nCK_PER_CLK-1:0]                       parity_in,
   input [2*nCK_PER_CLK*DQ_WIDTH-1:0]            mux_wrdata,
   input [2*nCK_PER_CLK*(DQ_WIDTH/8)-1:0]        mux_wrdata_mask,
   input                                         mux_reset_n,
   output [2*nCK_PER_CLK*DQ_WIDTH-1:0]           rd_data,
   // Memory I/F
   output [ROW_WIDTH-1:0]                        ddr_addr,
   output [BANK_WIDTH-1:0]                       ddr_ba,
   output                                        ddr_cas_n,
   output [CKE_WIDTH-1:0]                        ddr_cke,
   output [CS_WIDTH*nCS_PER_RANK-1:0]            ddr_cs_n,
   output [DM_WIDTH-1:0]                         ddr_dm,
   output [ODT_WIDTH-1:0]                        ddr_odt,
   output                                        ddr_parity,
   output                                        ddr_ras_n,
   output                                        ddr_we_n,
   output                                        ddr_reset_n,
   inout [DQ_WIDTH-1:0]                          ddr_dq,
   inout [DQS_WIDTH-1:0]                         ddr_dqs,
   inout [DQS_WIDTH-1:0]                         ddr_dqs_n,
   //output                                        iodelay_ctrl_rdy,
   output                                        pd_out

   ,input                                        dbg_pi_counter_read_en
   ,output                                       ref_dll_lock
   ,input                                        rst_phaser_ref
   ,output [11:0]                                dbg_pi_phase_locked_phy4lanes
   ,output [11:0]                                dbg_pi_dqs_found_lanes_phy4lanes
   );

  function [71:0] generate_bytelanes_ddr_ck;
    input [143:0] ck_byte_map;
    integer v ;
    begin
      generate_bytelanes_ddr_ck = 'b0 ;
      for (v = 0; v < CK_WIDTH; v = v + 1) begin
        if ((CK_BYTE_MAP[((v*8)+4)+:4]) == 2)
          generate_bytelanes_ddr_ck[48+(4*v)+1*(CK_BYTE_MAP[(v*8)+:4])] = 1'b1;
        else if ((CK_BYTE_MAP[((v*8)+4)+:4]) == 1)
          generate_bytelanes_ddr_ck[24+(4*v)+1*(CK_BYTE_MAP[(v*8)+:4])] = 1'b1;
        else
          generate_bytelanes_ddr_ck[4*v+1*(CK_BYTE_MAP[(v*8)+:4])] = 1'b1;
      end
    end
  endfunction

  function [(2*CK_WIDTH*8)-1:0] generate_ddr_ck_map;
    input [143:0] ck_byte_map;
    integer g;
    begin
      generate_ddr_ck_map = 'b0 ;
      for(g = 0 ; g < CK_WIDTH ; g= g + 1) begin
        generate_ddr_ck_map[(g*2*8)+:8]  = (ck_byte_map[(g*8)+:4] == 4'd0) ? "A" :
                                           (ck_byte_map[(g*8)+:4] == 4'd1) ? "B" :
                                           (ck_byte_map[(g*8)+:4] == 4'd2) ? "C" : "D" ;
        generate_ddr_ck_map[(((g*2)+1)*8)+:8] = (ck_byte_map[((g*8)+4)+:4] == 4'd0) ? "0" :
                                                (ck_byte_map[((g*8)+4)+:4] == 4'd1) ? "1" :  "2" ; //each STRING charater takes 0 location
      end
    end
  endfunction



  // Enable low power mode for input buffer
  localparam IBUF_LOW_PWR
             = (IBUF_LPWR_MODE == "OFF") ? "FALSE" :
             ((IBUF_LPWR_MODE == "ON")  ? "TRUE" : "ILLEGAL");

  // Ratio of data to strobe
  localparam DQ_PER_DQS = DQ_WIDTH / DQS_WIDTH;
  // number of data phases per internal clock
  localparam PHASE_PER_CLK = 2*nCK_PER_CLK;
  // used to determine routing to OUT_FIFO for control/address for 2:1
  // vs. 4:1 memory:internal clock ratio modes
  localparam PHASE_DIV = 4 / nCK_PER_CLK;

  localparam CLK_PERIOD = tCK * nCK_PER_CLK;

  // Create an aggregate parameters for data mapping to reduce # of generate
  // statements required in remapping code. Need to account for the case
  // when the DQ:DQS ratio is not 8:1 - in this case, each DATAx_MAP
  // parameter will have fewer than 8 elements used
  localparam FULL_DATA_MAP = {DATA17_MAP[12*DQ_PER_DQS-1:0],
                              DATA16_MAP[12*DQ_PER_DQS-1:0],
                              DATA15_MAP[12*DQ_PER_DQS-1:0],
                              DATA14_MAP[12*DQ_PER_DQS-1:0],
                              DATA13_MAP[12*DQ_PER_DQS-1:0],
                              DATA12_MAP[12*DQ_PER_DQS-1:0],
                              DATA11_MAP[12*DQ_PER_DQS-1:0],
                              DATA10_MAP[12*DQ_PER_DQS-1:0],
                              DATA9_MAP[12*DQ_PER_DQS-1:0],
                              DATA8_MAP[12*DQ_PER_DQS-1:0],
                              DATA7_MAP[12*DQ_PER_DQS-1:0],
                              DATA6_MAP[12*DQ_PER_DQS-1:0],
                              DATA5_MAP[12*DQ_PER_DQS-1:0],
                              DATA4_MAP[12*DQ_PER_DQS-1:0],
                              DATA3_MAP[12*DQ_PER_DQS-1:0],
                              DATA2_MAP[12*DQ_PER_DQS-1:0],
                              DATA1_MAP[12*DQ_PER_DQS-1:0],
                              DATA0_MAP[12*DQ_PER_DQS-1:0]};
  // Same deal, but for data mask mapping
  localparam FULL_MASK_MAP = {MASK1_MAP, MASK0_MAP};
  localparam TMP_BYTELANES_DDR_CK  = generate_bytelanes_ddr_ck(CK_BYTE_MAP) ;
  localparam TMP_GENERATE_DDR_CK_MAP = generate_ddr_ck_map(CK_BYTE_MAP) ;

  // Temporary parameters to determine which bank is outputting the CK/CK#
  // Eventually there will be support for multiple CK/CK# output
  //localparam TMP_DDR_CLK_SELECT_BANK = (CK_BYTE_MAP[7:4]);
  //// Temporary method to force MC_PHY to generate ODDR associated with
  //// CK/CK# output only for a single byte lane in the design. All banks
  //// that won't be generating the CK/CK# will have "UNUSED" as their
  //// PHY_GENERATE_DDR_CK parameter
  //localparam TMP_PHY_0_GENERATE_DDR_CK
  //           = (TMP_DDR_CLK_SELECT_BANK != 0) ? "UNUSED" :
  //              ((CK_BYTE_MAP[1:0] == 2'b00) ? "A" :
  //               ((CK_BYTE_MAP[1:0] == 2'b01) ? "B" :
  //                ((CK_BYTE_MAP[1:0] == 2'b10) ? "C" : "D")));
  //localparam TMP_PHY_1_GENERATE_DDR_CK
  //           = (TMP_DDR_CLK_SELECT_BANK != 1) ? "UNUSED" :
  //              ((CK_BYTE_MAP[1:0] == 2'b00) ? "A" :
  //               ((CK_BYTE_MAP[1:0] == 2'b01) ? "B" :
  //                ((CK_BYTE_MAP[1:0] == 2'b10) ? "C" : "D")));
  //localparam TMP_PHY_2_GENERATE_DDR_CK
  //           = (TMP_DDR_CLK_SELECT_BANK != 2) ? "UNUSED" :
  //              ((CK_BYTE_MAP[1:0] == 2'b00) ? "A" :
  //               ((CK_BYTE_MAP[1:0] == 2'b01) ? "B" :
  //                ((CK_BYTE_MAP[1:0] == 2'b10) ? "C" : "D")));

  // Function to generate MC_PHY parameters PHY_BITLANES_OUTONLYx
  // which indicates which bit lanes in data byte lanes are
  // output-only bitlanes (e.g. used specifically for data mask outputs)
  function [143:0] calc_phy_bitlanes_outonly;
    input [215:0] data_mask_in;
    integer       z;
    begin
      calc_phy_bitlanes_outonly = 'b0;
      // Only enable BITLANES parameters for data masks if, well, if
      // the data masks are actually enabled
      if (USE_DM_PORT == 1)
        for (z = 0; z < DM_WIDTH; z = z + 1)
          calc_phy_bitlanes_outonly[48*data_mask_in[(12*z+8)+:3] +
                                    12*data_mask_in[(12*z+4)+:2] +
                                    data_mask_in[12*z+:4]] = 1'b1;
    end
  endfunction

  localparam PHY_BITLANES_OUTONLY   = calc_phy_bitlanes_outonly(FULL_MASK_MAP);
  localparam PHY_0_BITLANES_OUTONLY = PHY_BITLANES_OUTONLY[47:0];
  localparam PHY_1_BITLANES_OUTONLY = PHY_BITLANES_OUTONLY[95:48];
  localparam PHY_2_BITLANES_OUTONLY = PHY_BITLANES_OUTONLY[143:96];

  // Determine which bank and byte lane generates the RCLK used to clock
  // out the auxilliary (ODT, CKE) outputs
  localparam CKE_ODT_RCLK_SELECT_BANK_AUX_ON
             = (CKE_ODT_BYTE_MAP[7:4] == 4'h0) ? 0 :
                 ((CKE_ODT_BYTE_MAP[7:4] == 4'h1) ? 1 :
                  ((CKE_ODT_BYTE_MAP[7:4] == 4'h2) ? 2 :
                   ((CKE_ODT_BYTE_MAP[7:4] == 4'h3) ? 3 :
                    ((CKE_ODT_BYTE_MAP[7:4] == 4'h4) ? 4 : -1))));
  localparam CKE_ODT_RCLK_SELECT_LANE_AUX_ON
             = (CKE_ODT_BYTE_MAP[3:0] == 4'h0) ? "A" :
                 ((CKE_ODT_BYTE_MAP[3:0] == 4'h1) ? "B" :
                  ((CKE_ODT_BYTE_MAP[3:0] == 4'h2) ? "C" :
                   ((CKE_ODT_BYTE_MAP[3:0] == 4'h3) ? "D" : "ILLEGAL")));

  localparam CKE_ODT_RCLK_SELECT_BANK_AUX_OFF
             = (CKE_MAP[11:8] == 4'h0) ? 0 :
                 ((CKE_MAP[11:8] == 4'h1) ? 1 :
                  ((CKE_MAP[11:8] == 4'h2) ? 2 :
                   ((CKE_MAP[11:8] == 4'h3) ? 3 :
                    ((CKE_MAP[11:8] == 4'h4) ? 4 : -1))));
  localparam CKE_ODT_RCLK_SELECT_LANE_AUX_OFF
             = (CKE_MAP[7:4] == 4'h0) ? "A" :
                 ((CKE_MAP[7:4] == 4'h1) ? "B" :
                  ((CKE_MAP[7:4] == 4'h2) ? "C" :
                   ((CKE_MAP[7:4] == 4'h3) ? "D" : "ILLEGAL")));


  localparam CKE_ODT_RCLK_SELECT_BANK = (CKE_ODT_AUX == "TRUE") ? CKE_ODT_RCLK_SELECT_BANK_AUX_ON : CKE_ODT_RCLK_SELECT_BANK_AUX_OFF ;
  localparam CKE_ODT_RCLK_SELECT_LANE = (CKE_ODT_AUX == "TRUE") ? CKE_ODT_RCLK_SELECT_LANE_AUX_ON : CKE_ODT_RCLK_SELECT_LANE_AUX_OFF ;


  //***************************************************************************
  // OCLKDELAYED tap setting calculation:
  // Parameters for calculating amount of phase shifting output clock to
  // achieve 90 degree offset between DQS and DQ on writes
  //***************************************************************************

  //90 deg equivalent to 0.25 for MEM_RefClk <= 300 MHz
  // and 1.25 for Mem_RefClk > 300 MHz
  //localparam PO_OCLKDELAY_INV = (((SIM_CAL_OPTION == "NONE") && (tCK >= 2500)) || (tCK >= 3333)) ?  "FALSE" : "TRUE";//DIV2 change
  localparam PO_OCLKDELAY_INV = (tCK >= 2500) ?  "FALSE" : "TRUE";//DIV2 change

  //DIV1: MemRefClk >= 400 MHz, DIV2: 200 <= MemRefClk < 400,
  //DIV4: MemRefClk < 200 MHz
  localparam PHY_0_A_PI_FREQ_REF_DIV = tCK > 5000 ?  "DIV4" :
                                       tCK >= 2500 ? "DIV2": "NONE";//DIV2 change

  localparam FREQ_REF_DIV = (PHY_0_A_PI_FREQ_REF_DIV == "DIV4" ? 4 :
                             PHY_0_A_PI_FREQ_REF_DIV == "DIV2" ? 2 : 1);

  // Intrinsic delay between OCLK and OCLK_DELAYED Phaser Output
  localparam real INT_DELAY = 0.4392/FREQ_REF_DIV + 100.0/tCK;

  // Whether OCLK_DELAY output comes inverted or not
  localparam real HALF_CYCLE_DELAY = 0.5*(PO_OCLKDELAY_INV == "TRUE" ? 1 : 0);

  // Phaser-Out Stage3 Tap delay for 90 deg shift.
  // Maximum tap delay is FreqRefClk period distributed over 64 taps
  // localparam real TAP_DELAY = MC_OCLK_DELAY/64/FREQ_REF_DIV;
  localparam real MC_OCLK_DELAY = ((PO_OCLKDELAY_INV == "TRUE" ? 1.25 : 0.25) -
                                   (INT_DELAY + HALF_CYCLE_DELAY))
                                   * 63 * FREQ_REF_DIV;
  //localparam integer PHY_0_A_PO_OCLK_DELAY = MC_OCLK_DELAY;

  localparam integer PHY_0_A_PO_OCLK_DELAY_HW
                     = (tCK > 2273)  ? 34 :
                       (tCK > 2000)  ? 33 :
                       (tCK > 1724)  ? 32 :
                       (tCK > 1515)  ? 31 :
                       (tCK > 1315)  ? 30 :
                       (tCK > 1136)  ? 29 :
                       (tCK > 1021)  ? 28 : 27;

  // Note that simulation requires a different value than in H/W because of the
  // difference in the way delays are modeled
  localparam integer PHY_0_A_PO_OCLK_DELAY = (SIM_CAL_OPTION == "NONE") ?   // DIV2 change
                                               ((tCK >= 2500) ? 0 :
                                                (DRAM_TYPE == "DDR3") ? PHY_0_A_PO_OCLK_DELAY_HW : 30) :
                                               (tCK >= 2500) ? 0 : MC_OCLK_DELAY;

  // Initial DQ IDELAY value
  localparam PHY_0_A_IDELAYE2_IDELAY_VALUE = (SIM_CAL_OPTION != "FAST_CAL") ? 0 :
                  (tCK < 1000) ? 0 :
                  (tCK < 1330) ? 0 :
                  (tCK < 2300) ? 0 :
                  (tCK < 2500) ? 2 : 0;
  //localparam PHY_0_A_IDELAYE2_IDELAY_VALUE = 0;

  // Aux_out parameters RD_CMD_OFFSET = CL+2? and WR_CMD_OFFSET = CWL+3?
  localparam PHY_0_RD_CMD_OFFSET_0 = 10;
  localparam PHY_0_RD_CMD_OFFSET_1 = 10;
  localparam PHY_0_RD_CMD_OFFSET_2 = 10;
  localparam PHY_0_RD_CMD_OFFSET_3 = 10;
  // 4:1 and 2:1 have WR_CMD_OFFSET values for ODT timing
  localparam PHY_0_WR_CMD_OFFSET_0 = (nCK_PER_CLK == 4) ? 8 : 4;
  localparam PHY_0_WR_CMD_OFFSET_1 = (nCK_PER_CLK == 4) ? 8 : 4;
  localparam PHY_0_WR_CMD_OFFSET_2 = (nCK_PER_CLK == 4) ? 8 : 4;
  localparam PHY_0_WR_CMD_OFFSET_3 = (nCK_PER_CLK == 4) ? 8 : 4;
  // 4:1 and 2:1 have different values
  localparam PHY_0_WR_DURATION_0 = 7;
  localparam PHY_0_WR_DURATION_1 = 7;
  localparam PHY_0_WR_DURATION_2 = 7;
  localparam PHY_0_WR_DURATION_3 = 7;
  // Aux_out parameters for toggle mode (CKE)
  localparam CWL_M = (REG_CTRL == "ON") ? CWL + 1 : CWL;
  localparam PHY_0_CMD_OFFSET = (nCK_PER_CLK == 4) ?  (CWL_M % 2) ? 8 : 9 :
                                  (CWL < 7) ?
                                    4 + ((CWL_M % 2) ? 0 : 1) :
                                    5 + ((CWL_M % 2) ? 0 : 1);

  // temporary parameter to enable/disable PHY PC counters. In both 4:1 and
  // 2:1 cases, this should be disabled. For now, enable for 4:1 mode to
  // avoid making too many changes at once.
  localparam PHY_COUNT_EN = (nCK_PER_CLK == 4) ? "TRUE" : "FALSE";


  wire [((HIGHEST_LANE+3)/4)*4-1:0] aux_out;
  wire [HIGHEST_LANE-1:0]           mem_dqs_in;
  wire [HIGHEST_LANE-1:0]           mem_dqs_out;
  wire [HIGHEST_LANE-1:0]           mem_dqs_ts;
  wire [HIGHEST_LANE*10-1:0]        mem_dq_in;
  wire [HIGHEST_LANE*12-1:0]        mem_dq_out;
  wire [HIGHEST_LANE*12-1:0]        mem_dq_ts;
  wire [DQ_WIDTH-1:0]               in_dq;
  wire [DQS_WIDTH-1:0]              in_dqs;
  wire [ROW_WIDTH-1:0]              out_addr;
  wire [BANK_WIDTH-1:0]             out_ba;
  wire                              out_cas_n;
  wire [CS_WIDTH*nCS_PER_RANK-1:0]  out_cs_n;
  wire [DM_WIDTH-1:0]               out_dm;
  wire [ODT_WIDTH -1:0]             out_odt;
  wire [CKE_WIDTH -1 :0]            out_cke ;
  wire [DQ_WIDTH-1:0]               out_dq;
  wire [DQS_WIDTH-1:0]              out_dqs;
  wire                              out_parity;
  wire                              out_ras_n;
  wire                              out_we_n;
  wire [HIGHEST_LANE*80-1:0]        phy_din;
  wire [HIGHEST_LANE*80-1:0]        phy_dout;
  wire                              phy_rd_en;
  wire [DM_WIDTH-1:0]               ts_dm;
  wire [DQ_WIDTH-1:0]               ts_dq;
  wire [DQS_WIDTH-1:0]              ts_dqs;
  wire [DQS_WIDTH-1:0]              in_dqs_lpbk_to_iddr;
  wire [DQS_WIDTH-1:0]              pd_out_pre;
  //wire                              metaQ;

  reg [31:0]                        phy_ctl_wd_i1;
  reg [31:0]                        phy_ctl_wd_i2;
  reg                               phy_ctl_wr_i1;
  reg                               phy_ctl_wr_i2;
  reg [5:0]                         data_offset_1_i1;
  reg [5:0]                         data_offset_1_i2;
  reg [5:0]                         data_offset_2_i1;
  reg [5:0]                         data_offset_2_i2;
  wire [31:0]                       phy_ctl_wd_temp;
  wire                              phy_ctl_wr_temp;
  wire [5:0]                        data_offset_1_temp;
  wire [5:0]                        data_offset_2_temp;
  wire [5:0]                        data_offset_1_of;
  wire [5:0]                        data_offset_2_of;
  wire [31:0]                       phy_ctl_wd_of;
  wire          phy_ctl_wr_of /* synthesis syn_maxfan = 1 */;
  wire [3:0]                        phy_ctl_full_temp;

  wire                              data_io_idle_pwrdwn;
  reg  [29:0]                       fine_delay_mod;    //3 bit per DQ
  reg                               fine_delay_sel_r;  //timing adj with fine_delay_incdec_pb

  wire iddr_rst_i;

  (* use_dsp48 = "no" *) wire [DQS_CNT_WIDTH:0]             byte_sel_cnt_w1;

  // Always read from input data FIFOs when not empty
  assign phy_rd_en = !if_empty;

  // IDELAYE2 initial value
  assign idelaye2_init_val = PHY_0_A_IDELAYE2_IDELAY_VALUE;
  assign oclkdelay_init_val = PHY_0_A_PO_OCLK_DELAY;

  // Idle powerdown when there are no pending reads in the MC
  assign data_io_idle_pwrdwn = DATA_IO_IDLE_PWRDWN == "ON" ? idle : 1'b0;
  assign iddr_rst_i = iddr_rst;
  //***************************************************************************
  // Auxiliary output steering
  //***************************************************************************

  // For a 4 rank I/F the aux_out[3:0] from the addr/ctl bank will be
  // mapped to ddr_odt and the aux_out[7:4] from one of the data banks
  // will map to ddr_cke. For I/Fs less than 4 the aux_out[3:0] from the
  // addr/ctl bank would bank would map to both ddr_odt and ddr_cke.
  generate
  if(CKE_ODT_AUX == "TRUE")begin:cke_thru_auxpins
    if (CKE_WIDTH == 1) begin : gen_cke
      // Explicitly instantiate OBUF to ensure that these are present
      // in the netlist. Typically this is not required since NGDBUILD
      // at the top-level knows to infer an I/O/IOBUF and therefore a
      // top-level LOC constraint can be attached to that pin. This does
      // not work when a hierarchical flow is used and the LOC is applied
      // at the individual core-level UCF
      OBUF u_cke_obuf
        (
         .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK]),
         .O (ddr_cke)
         );
    end else begin: gen_2rank_cke
      OBUF u_cke0_obuf
        (
         .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK]),
         .O (ddr_cke[0])
         );
      OBUF u_cke1_obuf
        (
         .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+2]),
         .O (ddr_cke[1])
         );
    end
  end
  endgenerate

  generate
  if(CKE_ODT_AUX == "TRUE")begin:odt_thru_auxpins
    if (USE_ODT_PORT == 1) begin : gen_use_odt
      // Explicitly instantiate OBUF to ensure that these are present
      // in the netlist. Typically this is not required since NGDBUILD
      // at the top-level knows to infer an I/O/IOBUF and therefore a
      // top-level LOC constraint can be attached to that pin. This does
      // not work when a hierarchical flow is used and the LOC is applied
      // at the individual core-level UCF
        OBUF u_odt_obuf
          (
           .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+1]),
           .O (ddr_odt[0])
           );
      if (ODT_WIDTH == 2 && RANKS == 1) begin: gen_2port_odt
        OBUF u_odt1_obuf
          (
           .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+2]),
           .O (ddr_odt[1])
           );
      end else if (ODT_WIDTH == 2 && RANKS == 2) begin: gen_2rank_odt
        OBUF u_odt1_obuf
          (
           .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+3]),
           .O (ddr_odt[1])
           );
      end else if (ODT_WIDTH == 3 && RANKS == 1) begin: gen_3port_odt
        OBUF u_odt1_obuf
          (
           .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+2]),
           .O (ddr_odt[1])
           );
        OBUF u_odt2_obuf
          (
           .I (aux_out[4*CKE_ODT_RCLK_SELECT_BANK+3]),
           .O (ddr_odt[2])
           );
      end
    end else begin
        assign ddr_odt = 'b0;
    end
  end
  endgenerate

  //***************************************************************************
  // Read data bit steering
  //***************************************************************************

  // Transpose elements of rd_data_map to form final read data output:
  // phy_din elements are grouped according to "physical bit" - e.g.
  // for nCK_PER_CLK = 4, there are 8 data phases transfered per physical
  // bit per clock cycle:
  //   = {dq0_fall3, dq0_rise3, dq0_fall2, dq0_rise2,
  //      dq0_fall1, dq0_rise1, dq0_fall0, dq0_rise0}
  // whereas rd_data is are grouped according to "phase" - e.g.
  //   = {dq7_rise0, dq6_rise0, dq5_rise0, dq4_rise0,
  //      dq3_rise0, dq2_rise0, dq1_rise0, dq0_rise0}
  // therefore rd_data is formed by transposing phy_din - e.g.
  //   for nCK_PER_CLK = 4, and DQ_WIDTH = 16, and assuming MC_PHY
  //   bit_lane[0] maps to DQ[0], and bit_lane[1] maps to DQ[1], then
  //   the assignments for bits of rd_data corresponding to DQ[1:0]
  //   would be:
  //    {rd_data[112], rd_data[96], rd_data[80], rd_data[64],
  //     rd_data[48], rd_data[32], rd_data[16], rd_data[0]} = phy_din[7:0]
  //    {rd_data[113], rd_data[97], rd_data[81], rd_data[65],
  //     rd_data[49], rd_data[33], rd_data[17], rd_data[1]} = phy_din[15:8]
  generate
    genvar i, j;
    for (i = 0; i < DQ_WIDTH; i = i + 1) begin: gen_loop_rd_data_1
      for (j = 0; j < PHASE_PER_CLK; j = j + 1) begin: gen_loop_rd_data_2
        assign rd_data[DQ_WIDTH*j + i]
                 = phy_din[(320*FULL_DATA_MAP[(12*i+8)+:3]+
                            80*FULL_DATA_MAP[(12*i+4)+:2] +
                            8*FULL_DATA_MAP[12*i+:4]) + j];
      end
    end
  endgenerate

  //generage idelay_inc per bits

  reg [11:0] cal_tmp;
  reg [95:0] byte_sel_data_map;

  assign byte_sel_cnt_w1 = byte_sel_cnt;

  always @ (posedge clk) begin
     byte_sel_data_map <= #TCQ FULL_DATA_MAP[12*DQ_PER_DQS*byte_sel_cnt_w1+:96];
  end

  always @ (posedge clk) begin
     fine_delay_mod[((byte_sel_data_map[3:0])*3)+:3] <= #TCQ {fine_delay_incdec_pb[0],2'b00};
     fine_delay_mod[((byte_sel_data_map[12+3:12])*3)+:3] <= #TCQ {fine_delay_incdec_pb[1],2'b00};
     fine_delay_mod[((byte_sel_data_map[24+3:24])*3)+:3] <= #TCQ {fine_delay_incdec_pb[2],2'b00};
     fine_delay_mod[((byte_sel_data_map[36+3:36])*3)+:3] <= #TCQ {fine_delay_incdec_pb[3],2'b00};
     fine_delay_mod[((byte_sel_data_map[48+3:48])*3)+:3] <= #TCQ {fine_delay_incdec_pb[4],2'b00};
     fine_delay_mod[((byte_sel_data_map[60+3:60])*3)+:3] <= #TCQ {fine_delay_incdec_pb[5],2'b00};
     fine_delay_mod[((byte_sel_data_map[72+3:72])*3)+:3] <= #TCQ {fine_delay_incdec_pb[6],2'b00};
     fine_delay_mod[((byte_sel_data_map[84+3:84])*3)+:3] <= #TCQ {fine_delay_incdec_pb[7],2'b00};
     fine_delay_sel_r <= #TCQ fine_delay_sel;
  end

  //***************************************************************************
  // Control/address
  //***************************************************************************

  assign out_cas_n
    = mem_dq_out[48*CAS_MAP[10:8] + 12*CAS_MAP[5:4] + CAS_MAP[3:0]];

  generate
    // if signal placed on bit lanes [0-9]
    if (CAS_MAP[3:0] < 4'hA) begin: gen_cas_lt10
      // Determine routing based on clock ratio mode. If running in 4:1
      // mode, then all four bits from logic are used. If 2:1 mode, only
      // 2-bits are provided by logic, and each bit is repeated 2x to form
      // 4-bit input to IN_FIFO, e.g.
      //   4:1 mode: phy_dout[] = {in[3], in[2], in[1], in[0]}
      //   2:1 mode: phy_dout[] = {in[1], in[1], in[0], in[0]}
      assign phy_dout[(320*CAS_MAP[10:8] + 80*CAS_MAP[5:4] +
                       8*CAS_MAP[3:0])+:4]
               = {mux_cas_n[3/PHASE_DIV], mux_cas_n[2/PHASE_DIV],
                  mux_cas_n[1/PHASE_DIV], mux_cas_n[0]};
    end else begin: gen_cas_ge10
      // If signal is placed in bit lane [10] or [11], route to upper
      // nibble of phy_dout lane [5] or [6] respectively (in this case
      // phy_dout lane [5, 6] are multiplexed to take input for two
      // different SDR signals - this is how bits[10,11] need to be
      // provided to the OUT_FIFO
      assign phy_dout[(320*CAS_MAP[10:8] + 80*CAS_MAP[5:4] +
                       8*(CAS_MAP[3:0]-5) + 4)+:4]
               = {mux_cas_n[3/PHASE_DIV], mux_cas_n[2/PHASE_DIV],
                  mux_cas_n[1/PHASE_DIV], mux_cas_n[0]};
    end
  endgenerate

  assign out_ras_n
    = mem_dq_out[48*RAS_MAP[10:8] + 12*RAS_MAP[5:4] + RAS_MAP[3:0]];

  generate
    if (RAS_MAP[3:0] < 4'hA) begin: gen_ras_lt10
      assign phy_dout[(320*RAS_MAP[10:8] + 80*RAS_MAP[5:4] +
                       8*RAS_MAP[3:0])+:4]
               = {mux_ras_n[3/PHASE_DIV], mux_ras_n[2/PHASE_DIV],
                  mux_ras_n[1/PHASE_DIV], mux_ras_n[0]};
    end else begin: gen_ras_ge10
      assign phy_dout[(320*RAS_MAP[10:8] + 80*RAS_MAP[5:4] +
                       8*(RAS_MAP[3:0]-5) + 4)+:4]
               = {mux_ras_n[3/PHASE_DIV], mux_ras_n[2/PHASE_DIV],
                  mux_ras_n[1/PHASE_DIV], mux_ras_n[0]};
    end
  endgenerate

  assign out_we_n
    = mem_dq_out[48*WE_MAP[10:8] + 12*WE_MAP[5:4] + WE_MAP[3:0]];

  generate
    if (WE_MAP[3:0] < 4'hA) begin: gen_we_lt10
      assign phy_dout[(320*WE_MAP[10:8] + 80*WE_MAP[5:4] +
                       8*WE_MAP[3:0])+:4]
               = {mux_we_n[3/PHASE_DIV], mux_we_n[2/PHASE_DIV],
                  mux_we_n[1/PHASE_DIV], mux_we_n[0]};
    end else begin: gen_we_ge10
      assign phy_dout[(320*WE_MAP[10:8] + 80*WE_MAP[5:4] +
                       8*(WE_MAP[3:0]-5) + 4)+:4]
               = {mux_we_n[3/PHASE_DIV], mux_we_n[2/PHASE_DIV],
                  mux_we_n[1/PHASE_DIV], mux_we_n[0]};
    end
  endgenerate

  generate
    if (REG_CTRL == "ON") begin: gen_parity_out
      // Generate addr/ctrl parity output only for DDR3 and DDR2 registered DIMMs
      assign out_parity
        = mem_dq_out[48*PARITY_MAP[10:8] + 12*PARITY_MAP[5:4] +
                     PARITY_MAP[3:0]];
      if (PARITY_MAP[3:0] < 4'hA) begin: gen_lt10
        assign phy_dout[(320*PARITY_MAP[10:8] + 80*PARITY_MAP[5:4] +
                         8*PARITY_MAP[3:0])+:4]
                 = {parity_in[3/PHASE_DIV], parity_in[2/PHASE_DIV],
                    parity_in[1/PHASE_DIV], parity_in[0]};
      end else begin: gen_ge10
        assign phy_dout[(320*PARITY_MAP[10:8] + 80*PARITY_MAP[5:4] +
                         8*(PARITY_MAP[3:0]-5) + 4)+:4]
               = {parity_in[3/PHASE_DIV], parity_in[2/PHASE_DIV],
                  parity_in[1/PHASE_DIV], parity_in[0]};
      end
    end
  endgenerate

  //*****************************************************************

  generate
    genvar m, n,x;

    //*****************************************************************
    // Control/address (multi-bit) buses
    //*****************************************************************

    // Row/Column address
    for (m = 0; m < ROW_WIDTH; m = m + 1) begin: gen_addr_out
      assign out_addr[m]
               = mem_dq_out[48*ADDR_MAP[(12*m+8)+:3] +
                            12*ADDR_MAP[(12*m+4)+:2] +
                            ADDR_MAP[12*m+:4]];

      if (ADDR_MAP[12*m+:4] < 4'hA) begin: gen_lt10
        // For multi-bit buses, we also have to deal with transposition
        // when going from the logic-side control bus to phy_dout
        for (n = 0; n < 4; n = n + 1) begin: loop_xpose
          assign phy_dout[320*ADDR_MAP[(12*m+8)+:3] +
                          80*ADDR_MAP[(12*m+4)+:2] +
                          8*ADDR_MAP[12*m+:4] + n]
                   = mux_address[ROW_WIDTH*(n/PHASE_DIV) + m];
        end
      end else begin: gen_ge10
        for (n = 0; n < 4; n = n + 1) begin: loop_xpose
          assign phy_dout[320*ADDR_MAP[(12*m+8)+:3] +
                          80*ADDR_MAP[(12*m+4)+:2] +
                          8*(ADDR_MAP[12*m+:4]-5) + 4 + n]
                   = mux_address[ROW_WIDTH*(n/PHASE_DIV) + m];
        end
      end
    end

    // Bank address
    for (m = 0; m < BANK_WIDTH; m = m + 1) begin: gen_ba_out
        assign out_ba[m]
                 = mem_dq_out[48*BANK_MAP[(12*m+8)+:3] +
                              12*BANK_MAP[(12*m+4)+:2] +
                              BANK_MAP[12*m+:4]];

      if (BANK_MAP[12*m+:4] < 4'hA) begin: gen_lt10
        for (n = 0; n < 4; n = n + 1) begin: loop_xpose
          assign phy_dout[320*BANK_MAP[(12*m+8)+:3] +
                          80*BANK_MAP[(12*m+4)+:2] +
                          8*BANK_MAP[12*m+:4] + n]
                   = mux_bank[BANK_WIDTH*(n/PHASE_DIV) + m];
        end
      end else begin: gen_ge10
        for (n = 0; n < 4; n = n + 1) begin: loop_xpose
          assign phy_dout[320*BANK_MAP[(12*m+8)+:3] +
                          80*BANK_MAP[(12*m+4)+:2] +
                          8*(BANK_MAP[12*m+:4]-5) + 4 + n]
                   = mux_bank[BANK_WIDTH*(n/PHASE_DIV) + m];
        end
      end
    end

    // Chip select
    if (USE_CS_PORT == 1) begin: gen_cs_n_out
      for (m = 0; m < CS_WIDTH*nCS_PER_RANK; m = m + 1) begin: gen_cs_out
        assign out_cs_n[m]
                 = mem_dq_out[48*CS_MAP[(12*m+8)+:3] +
                              12*CS_MAP[(12*m+4)+:2] +
                              CS_MAP[12*m+:4]];
        if (CS_MAP[12*m+:4] < 4'hA) begin: gen_lt10
          for (n = 0; n < 4; n = n + 1) begin: loop_xpose
            assign phy_dout[320*CS_MAP[(12*m+8)+:3] +
                            80*CS_MAP[(12*m+4)+:2] +
                            8*CS_MAP[12*m+:4] + n]
                     = mux_cs_n[CS_WIDTH*nCS_PER_RANK*(n/PHASE_DIV) + m];
          end
        end else begin: gen_ge10
          for (n = 0; n < 4; n = n + 1) begin: loop_xpose
            assign phy_dout[320*CS_MAP[(12*m+8)+:3] +
                            80*CS_MAP[(12*m+4)+:2] +
                            8*(CS_MAP[12*m+:4]-5) + 4 + n]
                     = mux_cs_n[CS_WIDTH*nCS_PER_RANK*(n/PHASE_DIV) + m];
          end
        end
      end
    end


   if(CKE_ODT_AUX == "FALSE") begin
     // ODT_ports
     wire [ODT_WIDTH*nCK_PER_CLK -1 :0] mux_odt_remap  ;

     if(RANKS == 1) begin
        for(x =0 ; x < nCK_PER_CLK ; x = x+1) begin
          assign mux_odt_remap[(x*ODT_WIDTH)+:ODT_WIDTH] = {ODT_WIDTH{mux_odt[0]}} ;
        end
     end else begin
        for(x =0 ; x < 2*nCK_PER_CLK ; x = x+2) begin
          assign mux_odt_remap[(x*ODT_WIDTH/RANKS)+:ODT_WIDTH/RANKS] = {ODT_WIDTH/RANKS{mux_odt[0]}} ;
          assign mux_odt_remap[((x*ODT_WIDTH/RANKS)+(ODT_WIDTH/RANKS))+:ODT_WIDTH/RANKS] = {ODT_WIDTH/RANKS{mux_odt[1]}} ;
        end
     end

     if (USE_ODT_PORT == 1) begin: gen_odt_out
       for (m = 0; m < ODT_WIDTH; m = m + 1) begin: gen_odt_out_1
         assign out_odt[m]
                  = mem_dq_out[48*ODT_MAP[(12*m+8)+:3] +
                               12*ODT_MAP[(12*m+4)+:2] +
                               ODT_MAP[12*m+:4]];
         if (ODT_MAP[12*m+:4] < 4'hA) begin: gen_lt10
           for (n = 0; n < 4; n = n + 1) begin: loop_xpose
             assign phy_dout[320*ODT_MAP[(12*m+8)+:3] +
                             80*ODT_MAP[(12*m+4)+:2] +
                             8*ODT_MAP[12*m+:4] + n]
                      = mux_odt_remap[ODT_WIDTH*(n/PHASE_DIV) + m];
           end
         end else begin: gen_ge10
           for (n = 0; n < 4; n = n + 1) begin: loop_xpose
             assign phy_dout[320*ODT_MAP[(12*m+8)+:3] +
                             80*ODT_MAP[(12*m+4)+:2] +
                             8*(ODT_MAP[12*m+:4]-5) + 4 + n]
                      = mux_odt_remap[ODT_WIDTH*(n/PHASE_DIV) + m];
           end
         end
       end
     end


     wire [CKE_WIDTH*nCK_PER_CLK -1:0] mux_cke_remap ;

     for(x = 0 ; x < nCK_PER_CLK ; x = x +1) begin
      assign  mux_cke_remap[(x*CKE_WIDTH)+:CKE_WIDTH] = {CKE_WIDTH{mux_cke[x]}} ;
     end



     for (m = 0; m < CKE_WIDTH; m = m + 1) begin: gen_cke_out
       assign out_cke[m]
                = mem_dq_out[48*CKE_MAP[(12*m+8)+:3] +
                             12*CKE_MAP[(12*m+4)+:2] +
                             CKE_MAP[12*m+:4]];
       if (CKE_MAP[12*m+:4] < 4'hA) begin: gen_lt10
         for (n = 0; n < 4; n = n + 1) begin: loop_xpose
           assign phy_dout[320*CKE_MAP[(12*m+8)+:3] +
                           80*CKE_MAP[(12*m+4)+:2] +
                           8*CKE_MAP[12*m+:4] + n]
                    = mux_cke_remap[CKE_WIDTH*(n/PHASE_DIV) + m];
         end
       end else begin: gen_ge10
         for (n = 0; n < 4; n = n + 1) begin: loop_xpose
           assign phy_dout[320*CKE_MAP[(12*m+8)+:3] +
                           80*CKE_MAP[(12*m+4)+:2] +
                           8*(CKE_MAP[12*m+:4]-5) + 4 + n]
                    = mux_cke_remap[CKE_WIDTH*(n/PHASE_DIV) + m];
         end
       end
     end
   end

    //*****************************************************************
    // Data mask
    //*****************************************************************

    if (USE_DM_PORT == 1) begin: gen_dm_out
      for (m = 0; m < DM_WIDTH; m = m + 1) begin: gen_dm_out
        assign out_dm[m]
                 = mem_dq_out[48*FULL_MASK_MAP[(12*m+8)+:3] +
                              12*FULL_MASK_MAP[(12*m+4)+:2] +
                              FULL_MASK_MAP[12*m+:4]];
        assign ts_dm[m]
                 = mem_dq_ts[48*FULL_MASK_MAP[(12*m+8)+:3] +
                             12*FULL_MASK_MAP[(12*m+4)+:2] +
                             FULL_MASK_MAP[12*m+:4]];
        for (n = 0; n < PHASE_PER_CLK; n = n + 1) begin: loop_xpose
          assign phy_dout[320*FULL_MASK_MAP[(12*m+8)+:3] +
                          80*FULL_MASK_MAP[(12*m+4)+:2] +
                          8*FULL_MASK_MAP[12*m+:4] + n]
                   = mux_wrdata_mask[DM_WIDTH*n + m];
        end
      end
    end

    //*****************************************************************
    // Input and output DQ
    //*****************************************************************

    for (m = 0; m < DQ_WIDTH; m = m + 1) begin: gen_dq_inout
      // to MC_PHY
      assign mem_dq_in[40*FULL_DATA_MAP[(12*m+8)+:3] +
                       10*FULL_DATA_MAP[(12*m+4)+:2] +
                       FULL_DATA_MAP[12*m+:4]]
               = in_dq[m];
      // to I/O buffers
      assign out_dq[m]
               = mem_dq_out[48*FULL_DATA_MAP[(12*m+8)+:3] +
                            12*FULL_DATA_MAP[(12*m+4)+:2] +
                            FULL_DATA_MAP[12*m+:4]];
      assign ts_dq[m]
               = mem_dq_ts[48*FULL_DATA_MAP[(12*m+8)+:3] +
                           12*FULL_DATA_MAP[(12*m+4)+:2] +
                           FULL_DATA_MAP[12*m+:4]];
      for (n = 0; n < PHASE_PER_CLK; n = n + 1) begin: loop_xpose
        assign phy_dout[320*FULL_DATA_MAP[(12*m+8)+:3] +
                        80*FULL_DATA_MAP[(12*m+4)+:2] +
                        8*FULL_DATA_MAP[12*m+:4] + n]
                 = mux_wrdata[DQ_WIDTH*n + m];
      end
    end

    //*****************************************************************
    // Input and output DQS
    //*****************************************************************

    for (m = 0; m < DQS_WIDTH; m = m + 1) begin: gen_dqs_inout
      // to MC_PHY
      assign mem_dqs_in[4*DQS_BYTE_MAP[(8*m+4)+:3] + DQS_BYTE_MAP[(8*m)+:2]]
        = in_dqs[m];
      // to I/O buffers
      assign out_dqs[m]
        = mem_dqs_out[4*DQS_BYTE_MAP[(8*m+4)+:3] + DQS_BYTE_MAP[(8*m)+:2]];
      assign ts_dqs[m]
        = mem_dqs_ts[4*DQS_BYTE_MAP[(8*m+4)+:3] + DQS_BYTE_MAP[(8*m)+:2]];
    end
  endgenerate

  assign pd_out = pd_out_pre[byte_sel_cnt_w1];


  //***************************************************************************
  // Memory I/F output and I/O buffer instantiation
  //***************************************************************************

  // Note on instantiation - generally at the minimum, it's not required to
  // instantiate the output buffers - they can be inferred by the synthesis
  // tool, and there aren't any attributes that need to be associated with
  // them. Consider as a future option to take out the OBUF instantiations

  OBUF u_cas_n_obuf
    (
     .I (out_cas_n),
     .O (ddr_cas_n)
     );

  OBUF u_ras_n_obuf
    (
     .I (out_ras_n),
     .O (ddr_ras_n)
     );

  OBUF u_we_n_obuf
    (
     .I (out_we_n),
     .O (ddr_we_n)
     );

  generate
    genvar p;

    for (p = 0; p < ROW_WIDTH; p = p + 1) begin: gen_addr_obuf
      OBUF u_addr_obuf
        (
         .I (out_addr[p]),
         .O (ddr_addr[p])
         );
    end

    for (p = 0; p < BANK_WIDTH; p = p + 1) begin: gen_bank_obuf
      OBUF u_bank_obuf
        (
         .I (out_ba[p]),
         .O (ddr_ba[p])
         );
    end

    if (USE_CS_PORT == 1) begin: gen_cs_n_obuf
      for (p = 0; p < CS_WIDTH*nCS_PER_RANK; p = p + 1) begin: gen_cs_obuf
        OBUF u_cs_n_obuf
          (
           .I (out_cs_n[p]),
           .O (ddr_cs_n[p])
           );
      end
    end
    if(CKE_ODT_AUX == "FALSE")begin:cke_odt_thru_outfifo
      if (USE_ODT_PORT== 1) begin: gen_odt_obuf
        for (p = 0; p < ODT_WIDTH; p = p + 1) begin: gen_odt_obuf
          OBUF u_cs_n_obuf
            (
             .I (out_odt[p]),
             .O (ddr_odt[p])
             );
        end
      end
        for (p = 0; p < CKE_WIDTH; p = p + 1) begin: gen_cke_obuf
          OBUF u_cs_n_obuf
            (
             .I (out_cke[p]),
             .O (ddr_cke[p])
             );
        end
    end

    if (REG_CTRL == "ON") begin: gen_parity_obuf
      // Generate addr/ctrl parity output only for DDR3 registered DIMMs
      OBUF u_parity_obuf
        (
         .I (out_parity),
         .O (ddr_parity)
         );
    end else begin: gen_parity_tieoff
      assign ddr_parity = 1'b0;
    end

    if ((DRAM_TYPE == "DDR3") || (REG_CTRL == "ON")) begin: gen_reset_obuf
      // Generate reset output only for DDR3 and DDR2 RDIMMs
      OBUF u_reset_obuf
        (
         .I (mux_reset_n),
         .O (ddr_reset_n)
         );
    end else begin: gen_reset_tieoff
      assign ddr_reset_n = 1'b1;
    end

    if (USE_DM_PORT == 1) begin: gen_dm_obuf
      for (p = 0; p < DM_WIDTH; p = p + 1) begin: loop_dm
        OBUFT u_dm_obuf
          (
           .I (out_dm[p]),
           .T (ts_dm[p]),
           .O (ddr_dm[p])
           );
      end
    end else begin: gen_dm_tieoff
      assign ddr_dm = 'b0;
    end

    if (DATA_IO_PRIM_TYPE == "HP_LP") begin: gen_dq_iobuf_HP
      for (p = 0; p < DQ_WIDTH; p = p + 1) begin: gen_dq_iobuf
        IOBUF_DCIEN #
          (
           .IBUF_LOW_PWR (IBUF_LOW_PWR)
           )
          u_iobuf_dq
            (
             .DCITERMDISABLE (data_io_idle_pwrdwn),
             .IBUFDISABLE    (data_io_idle_pwrdwn),
             .I              (out_dq[p]),
             .T              (ts_dq[p]),
             .O              (in_dq[p]),
             .IO             (ddr_dq[p])
             );
      end
    end else if (DATA_IO_PRIM_TYPE == "HR_LP") begin: gen_dq_iobuf_HR
      for (p = 0; p < DQ_WIDTH; p = p + 1) begin: gen_dq_iobuf
        IOBUF_INTERMDISABLE #
          (
           .IBUF_LOW_PWR (IBUF_LOW_PWR)
           )
          u_iobuf_dq
            (
             .INTERMDISABLE  (data_io_idle_pwrdwn),
             .IBUFDISABLE    (data_io_idle_pwrdwn),
             .I              (out_dq[p]),
             .T              (ts_dq[p]),
             .O              (in_dq[p]),
             .IO             (ddr_dq[p])
             );
      end
    end else begin: gen_dq_iobuf_default
      for (p = 0; p < DQ_WIDTH; p = p + 1) begin: gen_dq_iobuf
        IOBUF #
          (
           .IBUF_LOW_PWR (IBUF_LOW_PWR)
           )
          u_iobuf_dq
            (
             .I  (out_dq[p]),
             .T  (ts_dq[p]),
             .O  (in_dq[p]),
             .IO (ddr_dq[p])
             );
      end
    end

    //if (DATA_IO_PRIM_TYPE == "HP_LP") begin: gen_dqs_iobuf_HP
    if ((BANK_TYPE == "HP_IO") || (BANK_TYPE == "HPL_IO")) begin: gen_dqs_iobuf_HP
      for (p = 0; p < DQS_WIDTH; p = p + 1) begin: gen_dqs_iobuf
        if ((DRAM_TYPE == "DDR2") &&
            (DDR2_DQSN_ENABLE != "YES")) begin: gen_ddr2_dqs_se
          IOBUF_DCIEN #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR)
             )
            u_iobuf_dqs
              (
               .DCITERMDISABLE (data_io_idle_pwrdwn),
               .IBUFDISABLE    (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .T              (ts_dqs[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p])
               );
          assign ddr_dqs_n[p] = 1'b0;
          assign pd_out_pre[p] = 1'b0;
        end else if ((DRAM_TYPE == "DDR2") ||
                     (tCK > 2500)) begin : gen_ddr2_or_low_dqs_diff
          IOBUFDS_DCIEN #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR),
             .DQS_BIAS     ("TRUE")
             )
            u_iobuf_dqs
              (
               .DCITERMDISABLE (data_io_idle_pwrdwn),
               .IBUFDISABLE    (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .T              (ts_dqs[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p]),
               .IOB            (ddr_dqs_n[p])
               );
          assign pd_out_pre[p] = 1'b0;
        end else begin: gen_dqs_diff
          IOBUFDS_DIFF_OUT_DCIEN #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR),
         .DQS_BIAS     ("TRUE"),
         .SIM_DEVICE   ("7SERIES"),
             .USE_IBUFDISABLE ("FALSE")
             )
            u_iobuf_dqs
              (
               .DCITERMDISABLE (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .TM             (ts_dqs[p]),
               .TS             (ts_dqs[p]),
               .OB             (in_dqs_lpbk_to_iddr[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p]),
               .IOB            (ddr_dqs_n[p])
               );

          mig_7series_v4_2_poc_pd #
          (
           .TCQ        (TCQ),
           .POC_USE_METASTABLE_SAMP (POC_USE_METASTABLE_SAMP)
          )
          u_iddr_edge_det
          (
            .clk         (clk),
            .iddr_rst         (iddr_rst_i),
            .kclk        (in_dqs_lpbk_to_iddr[p]),
            .mmcm_ps_clk (mmcm_ps_clk),
            .pd_out      (pd_out_pre[p])
          );
        end
      end
    //end else if (DATA_IO_PRIM_TYPE == "HR_LP") begin: gen_dqs_iobuf_HR
    end else if ((BANK_TYPE == "HR_IO") || (BANK_TYPE == "HRL_IO")) begin: gen_dqs_iobuf_HR
      for (p = 0; p < DQS_WIDTH; p = p + 1) begin: gen_dqs_iobuf
        if ((DRAM_TYPE == "DDR2") &&
            (DDR2_DQSN_ENABLE != "YES")) begin: gen_ddr2_dqs_se
          IOBUF_INTERMDISABLE #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR)
             )
            u_iobuf_dqs
              (
               .INTERMDISABLE  (data_io_idle_pwrdwn),
               .IBUFDISABLE    (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .T              (ts_dqs[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p])
               );
          assign ddr_dqs_n[p] = 1'b0;
          assign pd_out_pre[p] = 1'b0;
        end else if ((DRAM_TYPE == "DDR2") ||
                     (tCK > 2500)) begin: gen_ddr2_or_low_dqs_diff
          IOBUFDS_INTERMDISABLE #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR),
             .DQS_BIAS     ("TRUE")
             )
            u_iobuf_dqs
              (
               .INTERMDISABLE  (data_io_idle_pwrdwn),
               .IBUFDISABLE    (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .T              (ts_dqs[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p]),
               .IOB            (ddr_dqs_n[p])
               );
          assign pd_out_pre[p] = 1'b0;
        end else begin: gen_dqs_diff
          IOBUFDS_DIFF_OUT_INTERMDISABLE #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR),
             .DQS_BIAS     ("TRUE"),
         .SIM_DEVICE   ("7SERIES"),
             .USE_IBUFDISABLE ("FALSE")
             )
            u_iobuf_dqs
              (
               .INTERMDISABLE  (data_io_idle_pwrdwn),
               //.IBUFDISABLE    (data_io_idle_pwrdwn),
               .I              (out_dqs[p]),
               .TM             (ts_dqs[p]),
               .TS             (ts_dqs[p]),
               .OB             (in_dqs_lpbk_to_iddr[p]),
               .O              (in_dqs[p]),
               .IO             (ddr_dqs[p]),
               .IOB            (ddr_dqs_n[p])
               );

        mig_7series_v4_2_poc_pd #
        (
         .TCQ        (TCQ),
         .POC_USE_METASTABLE_SAMP (POC_USE_METASTABLE_SAMP)
        )
        u_iddr_edge_det
          (
           .clk         (clk),
               .iddr_rst    (iddr_rst_i),
           .kclk        (in_dqs_lpbk_to_iddr[p]),
               .mmcm_ps_clk (mmcm_ps_clk),
               .pd_out      (pd_out_pre[p])
          );
        end
      end
    end else begin: gen_dqs_iobuf_default
      for (p = 0; p < DQS_WIDTH; p = p + 1) begin: gen_dqs_iobuf
        if ((DRAM_TYPE == "DDR2") &&
            (DDR2_DQSN_ENABLE != "YES")) begin: gen_ddr2_dqs_se
          IOBUF #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR)
             )
            u_iobuf_dqs
              (
               .I   (out_dqs[p]),
               .T   (ts_dqs[p]),
               .O   (in_dqs[p]),
               .IO  (ddr_dqs[p])
               );
          assign ddr_dqs_n[p] = 1'b0;
          assign pd_out_pre[p] = 1'b0;
        end else begin: gen_dqs_diff
          IOBUFDS #
            (
             .IBUF_LOW_PWR (IBUF_LOW_PWR),
             .DQS_BIAS     ("TRUE")
             )
            u_iobuf_dqs
              (
               .I   (out_dqs[p]),
               .T   (ts_dqs[p]),
               .O   (in_dqs[p]),
               .IO  (ddr_dqs[p]),
               .IOB (ddr_dqs_n[p])
               );
          assign pd_out_pre[p] = 1'b0;
        end
      end
    end

  endgenerate

  always @(posedge clk) begin
    phy_ctl_wd_i1 <= #TCQ phy_ctl_wd;
    phy_ctl_wr_i1 <= #TCQ phy_ctl_wr;
    phy_ctl_wd_i2 <= #TCQ phy_ctl_wd_i1;
    phy_ctl_wr_i2 <= #TCQ phy_ctl_wr_i1;
    data_offset_1_i1 <= #TCQ data_offset_1;
    data_offset_1_i2 <= #TCQ data_offset_1_i1;
    data_offset_2_i1 <= #TCQ data_offset_2;
    data_offset_2_i2 <= #TCQ data_offset_2_i1;
  end


  // 2 cycles of command delay needed for 4;1 mode. 2:1 mode does not need it.
  // 2:1 mode the command goes through pre fifo
  assign phy_ctl_wd_temp = (nCK_PER_CLK == 4) ? phy_ctl_wd_i2 : phy_ctl_wd_of;
  assign phy_ctl_wr_temp = (nCK_PER_CLK == 4) ? phy_ctl_wr_i2 : phy_ctl_wr_of;
  assign data_offset_1_temp = (nCK_PER_CLK == 4) ? data_offset_1_i2 : data_offset_1_of;
  assign data_offset_2_temp = (nCK_PER_CLK == 4) ? data_offset_2_i2 : data_offset_2_of;

  generate
    begin

      mig_7series_v4_2_ddr_of_pre_fifo #
        (
         .TCQ   (25),
         .DEPTH (8),
         .WIDTH (32)
        )
        phy_ctl_pre_fifo_0
        (
         .clk       (clk),
         .rst       (rst),
         .full_in   (phy_ctl_full_temp[1]),
         .wr_en_in  (phy_ctl_wr),
         .d_in      (phy_ctl_wd),
         .wr_en_out (phy_ctl_wr_of),
         .d_out     (phy_ctl_wd_of)
        );

      mig_7series_v4_2_ddr_of_pre_fifo #
        (
         .TCQ   (25),
         .DEPTH (8),
         .WIDTH (6)
        )
        phy_ctl_pre_fifo_1
        (
         .clk       (clk),
         .rst       (rst),
         .full_in   (phy_ctl_full_temp[2]),
         .wr_en_in  (phy_ctl_wr),
         .d_in      (data_offset_1),
         .wr_en_out (),
         .d_out     (data_offset_1_of)
        );

      mig_7series_v4_2_ddr_of_pre_fifo #
        (
         .TCQ   (25),
         .DEPTH (8),
         .WIDTH (6)
        )
        phy_ctl_pre_fifo_2
        (
         .clk       (clk),
         .rst       (rst),
         .full_in   (phy_ctl_full_temp[3]),
         .wr_en_in  (phy_ctl_wr),
         .d_in      (data_offset_2),
         .wr_en_out (),
         .d_out     (data_offset_2_of)
        );

    end
  endgenerate



  //***************************************************************************
  // Hard PHY instantiation
  //***************************************************************************

   assign phy_ctl_full = phy_ctl_full_temp[0];

  mig_7series_v4_2_ddr_mc_phy #
    (
     .BYTE_LANES_B0                 (BYTE_LANES_B0),
     .BYTE_LANES_B1                 (BYTE_LANES_B1),
     .BYTE_LANES_B2                 (BYTE_LANES_B2),
     .BYTE_LANES_B3                 (BYTE_LANES_B3),
     .BYTE_LANES_B4                 (BYTE_LANES_B4),
     .DATA_CTL_B0                   (DATA_CTL_B0),
     .DATA_CTL_B1                   (DATA_CTL_B1),
     .DATA_CTL_B2                   (DATA_CTL_B2),
     .DATA_CTL_B3                   (DATA_CTL_B3),
     .DATA_CTL_B4                   (DATA_CTL_B4),
     .PHY_0_BITLANES                (PHY_0_BITLANES),
     .PHY_1_BITLANES                (PHY_1_BITLANES),
     .PHY_2_BITLANES                (PHY_2_BITLANES),
     .PHY_0_BITLANES_OUTONLY        (PHY_0_BITLANES_OUTONLY),
     .PHY_1_BITLANES_OUTONLY        (PHY_1_BITLANES_OUTONLY),
     .PHY_2_BITLANES_OUTONLY        (PHY_2_BITLANES_OUTONLY),
     .RCLK_SELECT_BANK              (CKE_ODT_RCLK_SELECT_BANK),
     .RCLK_SELECT_LANE              (CKE_ODT_RCLK_SELECT_LANE),
     //.CKE_ODT_AUX                   (CKE_ODT_AUX),
     .GENERATE_DDR_CK_MAP           (TMP_GENERATE_DDR_CK_MAP),
     .BYTELANES_DDR_CK              (TMP_BYTELANES_DDR_CK),
     .NUM_DDR_CK                    (CK_WIDTH),
     .LP_DDR_CK_WIDTH               (LP_DDR_CK_WIDTH),
     .PO_CTL_COARSE_BYPASS          ("FALSE"),
     .PHYCTL_CMD_FIFO               ("FALSE"),
     .PHY_CLK_RATIO                 (nCK_PER_CLK),
     .MASTER_PHY_CTL                (MASTER_PHY_CTL),
     .PHY_FOUR_WINDOW_CLOCKS        (63),
     .PHY_EVENTS_DELAY              (18),
     .PHY_COUNT_EN                  ("FALSE"), //PHY_COUNT_EN
     .PHY_SYNC_MODE                 ("FALSE"),
     .SYNTHESIS                     ((SIM_CAL_OPTION == "NONE") ? "TRUE" : "FALSE"),
     .PHY_DISABLE_SEQ_MATCH         ("TRUE"), //"TRUE"
     .PHY_0_GENERATE_IDELAYCTRL     ("FALSE"),
     .PHY_0_A_PI_FREQ_REF_DIV       (PHY_0_A_PI_FREQ_REF_DIV),
     .PHY_0_CMD_OFFSET              (PHY_0_CMD_OFFSET),   //for CKE
     .PHY_0_RD_CMD_OFFSET_0         (PHY_0_RD_CMD_OFFSET_0),
     .PHY_0_RD_CMD_OFFSET_1         (PHY_0_RD_CMD_OFFSET_1),
     .PHY_0_RD_CMD_OFFSET_2         (PHY_0_RD_CMD_OFFSET_2),
     .PHY_0_RD_CMD_OFFSET_3         (PHY_0_RD_CMD_OFFSET_3),
     .PHY_0_RD_DURATION_0           (6),
     .PHY_0_RD_DURATION_1           (6),
     .PHY_0_RD_DURATION_2           (6),
     .PHY_0_RD_DURATION_3           (6),
     .PHY_0_WR_CMD_OFFSET_0         (PHY_0_WR_CMD_OFFSET_0),
     .PHY_0_WR_CMD_OFFSET_1         (PHY_0_WR_CMD_OFFSET_1),
     .PHY_0_WR_CMD_OFFSET_2         (PHY_0_WR_CMD_OFFSET_2),
     .PHY_0_WR_CMD_OFFSET_3         (PHY_0_WR_CMD_OFFSET_3),
     .PHY_0_WR_DURATION_0           (PHY_0_WR_DURATION_0),
     .PHY_0_WR_DURATION_1           (PHY_0_WR_DURATION_1),
     .PHY_0_WR_DURATION_2           (PHY_0_WR_DURATION_2),
     .PHY_0_WR_DURATION_3           (PHY_0_WR_DURATION_3),
     .PHY_0_AO_TOGGLE               ((RANKS == 1) ? 1 : 5),
     .PHY_0_A_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_0_B_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_0_C_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_0_D_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_0_A_PO_OCLKDELAY_INV      (PO_OCLKDELAY_INV),
     .PHY_0_A_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_0_B_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_0_C_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_0_D_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_1_GENERATE_IDELAYCTRL     ("FALSE"),
     //.PHY_1_GENERATE_DDR_CK         (TMP_PHY_1_GENERATE_DDR_CK),
     //.PHY_1_NUM_DDR_CK              (1),
     .PHY_1_A_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_1_B_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_1_C_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_1_D_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_1_A_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_1_B_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_1_C_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_1_D_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_2_GENERATE_IDELAYCTRL     ("FALSE"),
     //.PHY_2_GENERATE_DDR_CK         (TMP_PHY_2_GENERATE_DDR_CK),
     //.PHY_2_NUM_DDR_CK              (1),
     .PHY_2_A_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_2_B_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_2_C_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_2_D_PO_OCLK_DELAY         (PHY_0_A_PO_OCLK_DELAY),
     .PHY_2_A_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_2_B_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_2_C_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .PHY_2_D_IDELAYE2_IDELAY_VALUE (PHY_0_A_IDELAYE2_IDELAY_VALUE),
     .TCK                           (tCK),
     .PHY_0_IODELAY_GRP             (IODELAY_GRP),
     .PHY_1_IODELAY_GRP             (IODELAY_GRP),
     .PHY_2_IODELAY_GRP             (IODELAY_GRP),
     .FPGA_SPEED_GRADE              (FPGA_SPEED_GRADE),
     .BANK_TYPE                     (BANK_TYPE),
     .CKE_ODT_AUX                   (CKE_ODT_AUX),
     .PI_DIV2_INCDEC                (PI_DIV2_INCDEC)
     )
    u_ddr_mc_phy
      (
       .rst                    (rst),
       // Don't use MC_PHY to generate DDR_RESET_N output. Instead
       // generate this output outside of MC_PHY (and synchronous to CLK)
       .ddr_rst_in_n           (1'b1),
       .phy_clk                (clk),
       .clk_div2               (clk_div2),
       .freq_refclk            (freq_refclk),
       .mem_refclk             (mem_refclk),
       // Remove later - always same connection as phy_clk port
       .mem_refclk_div4        (clk),
       .pll_lock               (pll_lock),
       .auxout_clk             (),
       .sync_pulse             (sync_pulse),
       // IDELAYCTRL instantiated outside of mc_phy module
       .idelayctrl_refclk      (),
       .phy_dout               (phy_dout),
       .phy_cmd_wr_en          (phy_cmd_wr_en),
       .phy_data_wr_en         (phy_data_wr_en),
       .phy_rd_en              (phy_rd_en),
       .phy_ctl_wd             (phy_ctl_wd_temp),
       .phy_ctl_wr             (phy_ctl_wr_temp),
       .if_empty_def           (phy_if_empty_def),
       .if_rst                 (phy_if_reset),
       .phyGo                  ('b1),
       .aux_in_1               (aux_in_1),
       .aux_in_2               (aux_in_2),
       // No support yet for different data offsets for different I/O banks
       // (possible use in supporting wider range of skew among bytes)
       .data_offset_1          (data_offset_1_temp),
       .data_offset_2          (data_offset_2_temp),
       .cke_in                 (),
       .if_a_empty             (),
       .if_empty               (if_empty),
       .if_empty_or            (),
       .if_empty_and           (),
       .of_ctl_a_full          (),
      // .of_data_a_full         (phy_data_full),
       .of_ctl_full            (phy_cmd_full),
       .of_data_full           (),
       .pre_data_a_full        (phy_pre_data_a_full),
       .idelay_ld              (idelay_ld),
       .idelay_ce              (idelay_ce),
       .idelay_inc             (idelay_inc),
       .input_sink             (),
       .phy_din                (phy_din),
       .phy_ctl_a_full         (),
       .phy_ctl_full           (phy_ctl_full_temp),
       .mem_dq_out             (mem_dq_out),
       .mem_dq_ts              (mem_dq_ts),
       .mem_dq_in              (mem_dq_in),
       .mem_dqs_out            (mem_dqs_out),
       .mem_dqs_ts             (mem_dqs_ts),
       .mem_dqs_in             (mem_dqs_in),
       .aux_out                (aux_out),
       .phy_ctl_ready          (),
       .rst_out                (),
       .ddr_clk                (ddr_clk),
       //.rclk                   (),
       .mcGo                   (phy_mc_go),
       .phy_write_calib        (phy_write_calib),
       .phy_read_calib         (phy_read_calib),
       .calib_sel              (calib_sel),
       .calib_in_common        (calib_in_common),
       .calib_zero_inputs      (calib_zero_inputs),
       .calib_zero_ctrl        (calib_zero_ctrl),
       .calib_zero_lanes       ('b0),
       .po_fine_enable         (po_fine_enable),
       .po_coarse_enable       (po_coarse_enable),
       .po_fine_inc            (po_fine_inc),
       .po_coarse_inc          (po_coarse_inc),
       .po_counter_load_en     (po_counter_load_en),
       .po_sel_fine_oclk_delay (po_sel_fine_oclk_delay),
       .po_counter_load_val    (po_counter_load_val),
       .po_counter_read_en     (po_counter_read_en),
       .po_coarse_overflow     (),
       .po_fine_overflow       (),
       .po_counter_read_val    (po_counter_read_val),
       .pi_rst_dqs_find        (pi_rst_dqs_find),
       .pi_fine_enable         (pi_fine_enable),
       .pi_fine_inc            (pi_fine_inc),
       .pi_counter_load_en     (pi_counter_load_en),
       .pi_counter_read_en     (dbg_pi_counter_read_en),
       .pi_counter_load_val    (pi_counter_load_val),
       .pi_fine_overflow       (),
       .pi_counter_read_val    (pi_counter_read_val),
       .pi_phase_locked        (pi_phase_locked),
       .pi_phase_locked_all    (pi_phase_locked_all),
       .pi_dqs_found           (),
       .pi_dqs_found_any       (pi_dqs_found),
       .pi_dqs_found_all       (pi_dqs_found_all),
       .pi_dqs_found_lanes     (dbg_pi_dqs_found_lanes_phy4lanes),
       // Currently not being used. May be used in future if periodic
       // reads become a requirement. This output could be used to signal
       // a catastrophic failure in read capture and the need for
       // re-calibration.
       .pi_dqs_out_of_range    (pi_dqs_out_of_range)

       ,.ref_dll_lock          (ref_dll_lock)
       ,.pi_phase_locked_lanes (dbg_pi_phase_locked_phy4lanes)
       ,.fine_delay            (fine_delay_mod)
       ,.fine_delay_sel        (fine_delay_sel_r)
//       ,.rst_phaser_ref        (rst_phaser_ref)
       );

endmodule

