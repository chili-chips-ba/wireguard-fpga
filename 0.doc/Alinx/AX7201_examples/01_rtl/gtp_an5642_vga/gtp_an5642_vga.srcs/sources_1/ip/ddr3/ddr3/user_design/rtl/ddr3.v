//*****************************************************************************
// (c) Copyright 2009 - 2012 Xilinx, Inc. All rights reserved.
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
//  /   /         Filename           : ddr3.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Wed Feb 01 2012
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   Wrapper module for the user design top level file. This module can be 
//   instantiated in the system and interconnect as shown in example design 
//   (example_top module).
// Revision History :
//*****************************************************************************
//`define SKIP_CALIB
`timescale 1ps/1ps

module ddr3 (
  // Inouts
  inout [31:0]       ddr3_dq,
  inout [3:0]        ddr3_dqs_n,
  inout [3:0]        ddr3_dqs_p,
  // Outputs
  output [14:0]     ddr3_addr,
  output [2:0]        ddr3_ba,
  output            ddr3_ras_n,
  output            ddr3_cas_n,
  output            ddr3_we_n,
  output            ddr3_reset_n,
  output [0:0]       ddr3_ck_p,
  output [0:0]       ddr3_ck_n,
  output [0:0]       ddr3_cke,
  output [0:0]        ddr3_cs_n,
  output [3:0]     ddr3_dm,
  output [0:0]       ddr3_odt,
  // Inputs
  // Single-ended system clock
  input             sys_clk_i,
  // user interface signals
  output            ui_clk,
  output            ui_clk_sync_rst,
  output            mmcm_locked,
  input         aresetn,
  input         app_sr_req,
  input         app_ref_req,
  input         app_zq_req,
  output            app_sr_active,
  output            app_ref_ack,
  output            app_zq_ack,
  // Slave Interface Write Address Ports
  input [3:0]           s_axi_awid,
  input [29:0]         s_axi_awaddr,
  input [7:0]           s_axi_awlen,
  input [2:0]           s_axi_awsize,
  input [1:0]           s_axi_awburst,
  input [0:0]           s_axi_awlock,
  input [3:0]           s_axi_awcache,
  input [2:0]           s_axi_awprot,
  input [3:0]           s_axi_awqos,
  input         s_axi_awvalid,
  output            s_axi_awready,
  // Slave Interface Write Data Ports
  input [63:0]         s_axi_wdata,
  input [7:0]         s_axi_wstrb,
  input         s_axi_wlast,
  input         s_axi_wvalid,
  output            s_axi_wready,
  // Slave Interface Write Response Ports
  input         s_axi_bready,
  output [3:0]          s_axi_bid,
  output [1:0]          s_axi_bresp,
  output            s_axi_bvalid,
  // Slave Interface Read Address Ports
  input [3:0]           s_axi_arid,
  input [29:0]         s_axi_araddr,
  input [7:0]           s_axi_arlen,
  input [2:0]           s_axi_arsize,
  input [1:0]           s_axi_arburst,
  input [0:0]           s_axi_arlock,
  input [3:0]           s_axi_arcache,
  input [2:0]           s_axi_arprot,
  input [3:0]           s_axi_arqos,
  input         s_axi_arvalid,
  output            s_axi_arready,
  // Slave Interface Read Data Ports
  input         s_axi_rready,
  output [3:0]          s_axi_rid,
  output [63:0]            s_axi_rdata,
  output [1:0]          s_axi_rresp,
  output            s_axi_rlast,
  output            s_axi_rvalid,
  output            init_calib_complete,
  output [11:0]                                device_temp,
`ifdef SKIP_CALIB
   output                                      calib_tap_req,
   input                                       calib_tap_load,
   input [6:0]                                 calib_tap_addr,
   input [7:0]                                 calib_tap_val,
   input                                       calib_tap_load_done,
`endif
  
  input			sys_rst
  );

// Start of IP top instance
  ddr3_mig u_ddr3_mig (

    // Memory interface ports
    .ddr3_addr                      (ddr3_addr),
    .ddr3_ba                        (ddr3_ba),
    .ddr3_cas_n                     (ddr3_cas_n),
    .ddr3_ck_n                      (ddr3_ck_n),
    .ddr3_ck_p                      (ddr3_ck_p),
    .ddr3_cke                       (ddr3_cke),
    .ddr3_ras_n                     (ddr3_ras_n),
    .ddr3_reset_n                   (ddr3_reset_n),
    .ddr3_we_n                      (ddr3_we_n),
    .ddr3_dq                        (ddr3_dq),
    .ddr3_dqs_n                     (ddr3_dqs_n),
    .ddr3_dqs_p                     (ddr3_dqs_p),
    .init_calib_complete            (init_calib_complete),
      
    .ddr3_cs_n                      (ddr3_cs_n),
    .ddr3_dm                        (ddr3_dm),
    .ddr3_odt                       (ddr3_odt),
    // Application interface ports
    .ui_clk                         (ui_clk),
    .ui_clk_sync_rst                (ui_clk_sync_rst),
    .mmcm_locked                    (mmcm_locked),
    .aresetn                        (aresetn),
    .app_sr_req                     (app_sr_req),
    .app_ref_req                    (app_ref_req),
    .app_zq_req                     (app_zq_req),
    .app_sr_active                  (app_sr_active),
    .app_ref_ack                    (app_ref_ack),
    .app_zq_ack                     (app_zq_ack),
    // Slave Interface Write Address Ports
    .s_axi_awid                     (s_axi_awid),
    .s_axi_awaddr                   (s_axi_awaddr),
    .s_axi_awlen                    (s_axi_awlen),
    .s_axi_awsize                   (s_axi_awsize),
    .s_axi_awburst                  (s_axi_awburst),
    .s_axi_awlock                   (s_axi_awlock),
    .s_axi_awcache                  (s_axi_awcache),
    .s_axi_awprot                   (s_axi_awprot),
    .s_axi_awqos                    (s_axi_awqos),
    .s_axi_awvalid                  (s_axi_awvalid),
    .s_axi_awready                  (s_axi_awready),
    // Slave Interface Write Data Ports
    .s_axi_wdata                    (s_axi_wdata),
    .s_axi_wstrb                    (s_axi_wstrb),
    .s_axi_wlast                    (s_axi_wlast),
    .s_axi_wvalid                   (s_axi_wvalid),
    .s_axi_wready                   (s_axi_wready),
    // Slave Interface Write Response Ports
    .s_axi_bid                      (s_axi_bid),
    .s_axi_bresp                    (s_axi_bresp),
    .s_axi_bvalid                   (s_axi_bvalid),
    .s_axi_bready                   (s_axi_bready),
    // Slave Interface Read Address Ports
    .s_axi_arid                     (s_axi_arid),
    .s_axi_araddr                   (s_axi_araddr),
    .s_axi_arlen                    (s_axi_arlen),
    .s_axi_arsize                   (s_axi_arsize),
    .s_axi_arburst                  (s_axi_arburst),
    .s_axi_arlock                   (s_axi_arlock),
    .s_axi_arcache                  (s_axi_arcache),
    .s_axi_arprot                   (s_axi_arprot),
    .s_axi_arqos                    (s_axi_arqos),
    .s_axi_arvalid                  (s_axi_arvalid),
    .s_axi_arready                  (s_axi_arready),
    // Slave Interface Read Data Ports
    .s_axi_rid                      (s_axi_rid),
    .s_axi_rdata                    (s_axi_rdata),
    .s_axi_rresp                    (s_axi_rresp),
    .s_axi_rlast                    (s_axi_rlast),
    .s_axi_rvalid                   (s_axi_rvalid),
    .s_axi_rready                   (s_axi_rready),
    // System Clock Ports
    .sys_clk_i                       (sys_clk_i),
       .device_temp            (device_temp),
       `ifdef SKIP_CALIB
       .calib_tap_req                    (calib_tap_req),
       .calib_tap_load                   (calib_tap_load),
       .calib_tap_addr                   (calib_tap_addr),
       .calib_tap_val                    (calib_tap_val),
       .calib_tap_load_done              (calib_tap_load_done),
       `endif
    .sys_rst                        (sys_rst)
    );
// End of IP top instance

endmodule


