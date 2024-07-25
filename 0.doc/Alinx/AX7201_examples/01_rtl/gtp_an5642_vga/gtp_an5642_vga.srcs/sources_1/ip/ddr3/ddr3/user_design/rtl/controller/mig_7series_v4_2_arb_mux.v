//*****************************************************************************
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
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
//  /   /         Filename              : arb_mux.v
// /___/   /\     Date Last Modified    : $date$
// \   \  /  \    Date Created          : Tue Jun 30 2009
//  \___\/\___\
//
//Device            : 7-Series
//Design Name       : DDR3 SDRAM
//Purpose           :
//Reference         :
//Revision History  :
//*****************************************************************************


`timescale 1ps/1ps

module mig_7series_v4_2_arb_mux #
  (
   parameter TCQ = 100,
   parameter EVEN_CWL_2T_MODE         = "OFF",
   parameter ADDR_CMD_MODE            = "1T",
   parameter BANK_VECT_INDX           = 11,
   parameter BANK_WIDTH               = 3,
   parameter BURST_MODE               = "8",
   parameter CS_WIDTH                 = 4,
   parameter CL                       = 5,
   parameter CWL                      = 5,
   parameter DATA_BUF_ADDR_VECT_INDX  = 31,
   parameter DATA_BUF_ADDR_WIDTH      = 8,
   parameter DRAM_TYPE                = "DDR3",
   parameter CKE_ODT_AUX              = "FALSE",      //Parameter to turn on/off the aux_out signal
   parameter EARLY_WR_DATA_ADDR       = "OFF",
   parameter ECC                      = "OFF",
   parameter nBANK_MACHS              = 4,
   parameter nCK_PER_CLK              = 2,       // # DRAM CKs per fabric CLKs
   parameter nCS_PER_RANK             = 1,
   parameter nRAS                     = 37500,        // ACT->PRE cmd period (CKs)
   parameter nRCD                     = 12500,        // ACT->R/W delay (CKs)
   parameter nSLOTS                   = 2,
   parameter nWR                      = 6,            // Write recovery (CKs)
   parameter RANKS                    = 1,
   parameter RANK_VECT_INDX           = 15,
   parameter RANK_WIDTH               = 2,
   parameter ROW_VECT_INDX            = 63,
   parameter ROW_WIDTH                = 16,
   parameter RTT_NOM                  = "40",
   parameter RTT_WR                   = "120",
   parameter SLOT_0_CONFIG            = 8'b0000_0101,
   parameter SLOT_1_CONFIG            = 8'b0000_1010
  )
  (/*AUTOARG*/
  // Outputs
  output [ROW_WIDTH-1:0] col_a,                 // From arb_select0 of arb_select.v
  output [BANK_WIDTH-1:0] col_ba,               // From arb_select0 of arb_select.v
  output [DATA_BUF_ADDR_WIDTH-1:0] col_data_buf_addr,// From arb_select0 of arb_select.v
  output                col_periodic_rd,        // From arb_select0 of arb_select.v
  output [RANK_WIDTH-1:0] col_ra,               // From arb_select0 of arb_select.v
  output                col_rmw,                // From arb_select0 of arb_select.v
  output                col_rd_wr,
  output [ROW_WIDTH-1:0] col_row,               // From arb_select0 of arb_select.v
  output                col_size,               // From arb_select0 of arb_select.v
  output [DATA_BUF_ADDR_WIDTH-1:0] col_wr_data_buf_addr,// From arb_select0 of arb_select.v
  output wire [nCK_PER_CLK-1:0]             mc_ras_n,
  output wire [nCK_PER_CLK-1:0]             mc_cas_n,
  output wire [nCK_PER_CLK-1:0]             mc_we_n,
  output wire [nCK_PER_CLK*ROW_WIDTH-1:0]   mc_address,
  output wire [nCK_PER_CLK*BANK_WIDTH-1:0]  mc_bank,
  output wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mc_cs_n,
  output wire [1:0]                         mc_odt,
  output wire [nCK_PER_CLK-1:0]             mc_cke,
  output wire [3:0]                         mc_aux_out0,
  output wire [3:0]                         mc_aux_out1,
  output      [2:0]                         mc_cmd,
  output      [5:0]                         mc_data_offset,
  output      [5:0]                         mc_data_offset_1,
  output      [5:0]                         mc_data_offset_2,
  output      [1:0]                         mc_cas_slot,
  output [RANK_WIDTH-1:0] rnk_config,              // From arb_select0 of arb_select.v
  output                  rnk_config_valid_r,      // From arb_row_col0 of arb_row_col.v
  output [nBANK_MACHS-1:0] sending_row,         // From arb_row_col0 of arb_row_col.v
  output [nBANK_MACHS-1:0] sending_pre,
  output                sent_col,               // From arb_row_col0 of arb_row_col.v
  output                sent_col_r,             // From arb_row_col0 of arb_row_col.v
  output                sent_row,               // From arb_row_col0 of arb_row_col.v
  output [nBANK_MACHS-1:0] sending_col,
  output rnk_config_strobe,
  output insert_maint_r1,
  output rnk_config_kill_rts_col,

  // Inputs
  input clk,
  input rst,
  input                   init_calib_complete,
  input [6*RANKS-1:0]     calib_rddata_offset,
  input [6*RANKS-1:0]     calib_rddata_offset_1,
  input [6*RANKS-1:0]     calib_rddata_offset_2,
  input [ROW_VECT_INDX:0] col_addr,             // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] col_rdy_wr,           // To arb_row_col0 of arb_row_col.v
  input                 insert_maint_r,         // To arb_row_col0 of arb_row_col.v
  input [RANK_WIDTH-1:0] maint_rank_r,          // To arb_select0 of arb_select.v
  input                 maint_zq_r,             // To arb_select0 of arb_select.v
  input                 maint_sre_r,            // To arb_select0 of arb_select.v
  input                 maint_srx_r,            // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] rd_wr_r,              // To arb_select0 of arb_select.v
  input [BANK_VECT_INDX:0] req_bank_r,          // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] req_cas,              // To arb_select0 of arb_select.v
  input [DATA_BUF_ADDR_VECT_INDX:0] req_data_buf_addr_r,// To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] req_periodic_rd_r,    // To arb_select0 of arb_select.v
  input [RANK_VECT_INDX:0] req_rank_r,          // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] req_ras,              // To arb_select0 of arb_select.v
  input [ROW_VECT_INDX:0] req_row_r,            // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] req_size_r,           // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] req_wr_r,             // To arb_select0 of arb_select.v
  input [ROW_VECT_INDX:0] row_addr,             // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] row_cmd_wr,           // To arb_select0 of arb_select.v
  input [nBANK_MACHS-1:0] rtc,                  // To arb_row_col0 of arb_row_col.v
  input [nBANK_MACHS-1:0] rts_col,              // To arb_row_col0 of arb_row_col.v
  input [nBANK_MACHS-1:0] rts_row,              // To arb_row_col0 of arb_row_col.v
  input [nBANK_MACHS-1:0] rts_pre,              // To arb_row_col0 of arb_row_col.v
  input [7:0]           slot_0_present,         // To arb_select0 of arb_select.v
  input [7:0]           slot_1_present         // To arb_select0 of arb_select.v
  
  );

  /*AUTOINPUT*/
  // Beginning of automatic inputs (from unused autoinst inputs)
  // End of automatics

  /*AUTOOUTPUT*/
  // Beginning of automatic outputs (from unused autoinst outputs)
  
  // End of automatics

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire                  cs_en0;                 // From arb_row_col0 of arb_row_col.v
  wire                  cs_en1;                 // From arb_row_col0 of arb_row_col.v
  wire [nBANK_MACHS-1:0] grant_col_r;           // From arb_row_col0 of arb_row_col.v
  wire [nBANK_MACHS-1:0] grant_col_wr;          // From arb_row_col0 of arb_row_col.v
  wire [nBANK_MACHS-1:0] grant_config_r;        // From arb_row_col0 of arb_row_col.v
  wire [nBANK_MACHS-1:0] grant_row_r;           // From arb_row_col0 of arb_row_col.v
  wire [nBANK_MACHS-1:0] grant_pre_r;           // From arb_row_col0 of arb_row_col.v
  wire                  send_cmd0_row;          // From arb_row_col0 of arb_row_col.v
  wire                  send_cmd0_col;          // From arb_row_col0 of arb_row_col.v
  wire                  send_cmd1_row;          // From arb_row_col0 of arb_row_col.v
  wire                  send_cmd1_col;
  wire                  send_cmd2_row;
  wire                  send_cmd2_col;
  wire                  send_cmd2_pre;
  wire                  send_cmd3_col;
  wire [5:0]            col_channel_offset;
  // End of automatics

  wire                  sent_col_i;
  wire                  cs_en2;
  wire                  cs_en3;
  assign sent_col = sent_col_i;
  
  mig_7series_v4_2_arb_row_col #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TCQ                               (TCQ),
     .ADDR_CMD_MODE                     (ADDR_CMD_MODE),
     .CWL                               (CWL),
     .EARLY_WR_DATA_ADDR                (EARLY_WR_DATA_ADDR),
     .nBANK_MACHS                       (nBANK_MACHS),
     .nCK_PER_CLK                       (nCK_PER_CLK),
     .nRAS                              (nRAS),
     .nRCD                              (nRCD),
     .nWR                               (nWR))
    arb_row_col0
      (/*AUTOINST*/
       // Outputs
       .grant_row_r                     (grant_row_r[nBANK_MACHS-1:0]),
       .grant_pre_r                     (grant_pre_r[nBANK_MACHS-1:0]),
       .sent_row                        (sent_row),
       .sending_row                     (sending_row[nBANK_MACHS-1:0]),
       .sending_pre                     (sending_pre[nBANK_MACHS-1:0]),
       .grant_config_r                  (grant_config_r[nBANK_MACHS-1:0]),
       .rnk_config_strobe               (rnk_config_strobe),
       .rnk_config_kill_rts_col         (rnk_config_kill_rts_col),
       .rnk_config_valid_r              (rnk_config_valid_r),
       .grant_col_r                     (grant_col_r[nBANK_MACHS-1:0]),
       .sending_col                     (sending_col[nBANK_MACHS-1:0]),
       .sent_col                        (sent_col_i),
       .sent_col_r                      (sent_col_r),
       .grant_col_wr                    (grant_col_wr[nBANK_MACHS-1:0]),
       .send_cmd0_row                   (send_cmd0_row),
       .send_cmd0_col                   (send_cmd0_col),
       .send_cmd1_row                   (send_cmd1_row),
       .send_cmd1_col                   (send_cmd1_col),
       .send_cmd2_row                   (send_cmd2_row),
       .send_cmd2_col                   (send_cmd2_col),
       .send_cmd2_pre                   (send_cmd2_pre),
       .send_cmd3_col                   (send_cmd3_col),
       .col_channel_offset              (col_channel_offset),
       .cs_en0                          (cs_en0),
       .cs_en1                          (cs_en1),
       .cs_en2                          (cs_en2),
       .cs_en3                          (cs_en3),
       .insert_maint_r1                 (insert_maint_r1),
       // Inputs
       .clk                             (clk),
       .rst                             (rst),
       .rts_row                         (rts_row[nBANK_MACHS-1:0]),
       .rts_pre                         (rts_pre[nBANK_MACHS-1:0]),
       .insert_maint_r                  (insert_maint_r),
       .rts_col                         (rts_col[nBANK_MACHS-1:0]),
       .rtc                             (rtc[nBANK_MACHS-1:0]),
       .col_rdy_wr                      (col_rdy_wr[nBANK_MACHS-1:0]));

  mig_7series_v4_2_arb_select #
    (/*AUTOINSTPARAM*/
     // Parameters
     .TCQ                               (TCQ),
     .EVEN_CWL_2T_MODE                  (EVEN_CWL_2T_MODE),
     .ADDR_CMD_MODE                     (ADDR_CMD_MODE),
     .BANK_VECT_INDX                    (BANK_VECT_INDX),
     .BANK_WIDTH                        (BANK_WIDTH),
     .BURST_MODE                        (BURST_MODE),
     .CS_WIDTH                          (CS_WIDTH),
     .CL                                (CL),
     .CWL                               (CWL),
     .DATA_BUF_ADDR_VECT_INDX           (DATA_BUF_ADDR_VECT_INDX),
     .DATA_BUF_ADDR_WIDTH               (DATA_BUF_ADDR_WIDTH),
     .DRAM_TYPE                         (DRAM_TYPE),
     .EARLY_WR_DATA_ADDR                (EARLY_WR_DATA_ADDR),
     .ECC                               (ECC),
     .CKE_ODT_AUX                       (CKE_ODT_AUX),
     .nBANK_MACHS                       (nBANK_MACHS),
     .nCK_PER_CLK                       (nCK_PER_CLK),
     .nCS_PER_RANK                      (nCS_PER_RANK),
     .nSLOTS                            (nSLOTS),
     .RANKS                             (RANKS),
     .RANK_VECT_INDX                    (RANK_VECT_INDX),
     .RANK_WIDTH                        (RANK_WIDTH),
     .ROW_VECT_INDX                     (ROW_VECT_INDX),
     .ROW_WIDTH                         (ROW_WIDTH),
     .RTT_NOM                           (RTT_NOM),
     .RTT_WR                            (RTT_WR),
     .SLOT_0_CONFIG                     (SLOT_0_CONFIG),
     .SLOT_1_CONFIG                     (SLOT_1_CONFIG))
    arb_select0
      (/*AUTOINST*/
       // Outputs
       .col_periodic_rd                 (col_periodic_rd),
       .col_ra                          (col_ra[RANK_WIDTH-1:0]),
       .col_ba                          (col_ba[BANK_WIDTH-1:0]),
       .col_a                           (col_a[ROW_WIDTH-1:0]),
       .col_rmw                         (col_rmw),
       .col_rd_wr                       (col_rd_wr),
       .col_size                        (col_size),
       .col_row                         (col_row[ROW_WIDTH-1:0]),
       .col_data_buf_addr               (col_data_buf_addr[DATA_BUF_ADDR_WIDTH-1:0]),
       .col_wr_data_buf_addr            (col_wr_data_buf_addr[DATA_BUF_ADDR_WIDTH-1:0]),
       .mc_bank                         (mc_bank),
       .mc_address                      (mc_address),
       .mc_ras_n                        (mc_ras_n),
       .mc_cas_n                        (mc_cas_n),
       .mc_we_n                         (mc_we_n),
       .mc_cs_n                         (mc_cs_n),
       .mc_odt                          (mc_odt),
       .mc_cke                          (mc_cke),
       .mc_aux_out0                     (mc_aux_out0),
       .mc_aux_out1                     (mc_aux_out1),
       .mc_cmd                          (mc_cmd),
       .mc_data_offset                  (mc_data_offset),
       .mc_data_offset_1                (mc_data_offset_1),
       .mc_data_offset_2                (mc_data_offset_2),
       .mc_cas_slot                     (mc_cas_slot),
       .col_channel_offset              (col_channel_offset),
       .rnk_config                      (rnk_config),
       // Inputs
       .clk                             (clk),
       .rst                             (rst),
       .init_calib_complete             (init_calib_complete),
       .calib_rddata_offset             (calib_rddata_offset),
       .calib_rddata_offset_1           (calib_rddata_offset_1),
       .calib_rddata_offset_2           (calib_rddata_offset_2),
       .req_rank_r                      (req_rank_r[RANK_VECT_INDX:0]),
       .req_bank_r                      (req_bank_r[BANK_VECT_INDX:0]),
       .req_ras                         (req_ras[nBANK_MACHS-1:0]),
       .req_cas                         (req_cas[nBANK_MACHS-1:0]),
       .req_wr_r                        (req_wr_r[nBANK_MACHS-1:0]),
       .grant_row_r                     (grant_row_r[nBANK_MACHS-1:0]),
       .grant_pre_r                     (grant_pre_r[nBANK_MACHS-1:0]),
       .row_addr                        (row_addr[ROW_VECT_INDX:0]),
       .row_cmd_wr                      (row_cmd_wr[nBANK_MACHS-1:0]),
       .insert_maint_r1                 (insert_maint_r1),
       .maint_zq_r                      (maint_zq_r),
       .maint_sre_r                     (maint_sre_r),
       .maint_srx_r                     (maint_srx_r),
       .maint_rank_r                    (maint_rank_r[RANK_WIDTH-1:0]),
       .req_periodic_rd_r               (req_periodic_rd_r[nBANK_MACHS-1:0]),
       .req_size_r                      (req_size_r[nBANK_MACHS-1:0]),
       .rd_wr_r                         (rd_wr_r[nBANK_MACHS-1:0]),
       .req_row_r                       (req_row_r[ROW_VECT_INDX:0]),
       .col_addr                        (col_addr[ROW_VECT_INDX:0]),
       .req_data_buf_addr_r             (req_data_buf_addr_r[DATA_BUF_ADDR_VECT_INDX:0]),
       .grant_col_r                     (grant_col_r[nBANK_MACHS-1:0]),
       .grant_col_wr                    (grant_col_wr[nBANK_MACHS-1:0]),
       .send_cmd0_row                   (send_cmd0_row),
       .send_cmd0_col                   (send_cmd0_col),
       .send_cmd1_row                   (send_cmd1_row),
       .send_cmd1_col                   (send_cmd1_col),
       .send_cmd2_row                   (send_cmd2_row),
       .send_cmd2_col                   (send_cmd2_col),
       .send_cmd2_pre                   (send_cmd2_pre),
       .send_cmd3_col                   (send_cmd3_col),
       .sent_col                        (EVEN_CWL_2T_MODE == "ON" ? sent_col_r : sent_col),
       .cs_en0                          (cs_en0),
       .cs_en1                          (cs_en1),
       .cs_en2                          (cs_en2),
       .cs_en3                          (cs_en3),
       .grant_config_r                  (grant_config_r[nBANK_MACHS-1:0]),
       .rnk_config_strobe               (rnk_config_strobe),
       .slot_0_present                  (slot_0_present[7:0]),
       .slot_1_present                  (slot_1_present[7:0]));

endmodule

