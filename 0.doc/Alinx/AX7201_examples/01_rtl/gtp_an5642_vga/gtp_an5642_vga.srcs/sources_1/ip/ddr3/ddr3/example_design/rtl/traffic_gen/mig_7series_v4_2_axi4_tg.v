//*****************************************************************************
// (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
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
// \   \   \/     Version: 3.6
//  \   \         Application: MIG
//  /   /         Filename: axi4_wrapper.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:37:18 $
// \   \  /  \    Date Created: Sept 16, 2009
//  \___\/\___\
//
//Device: Virtex-6, Spartan-6 and 7series
//Design Name: DDR3 SDRAM
//Purpose:
//   This module is wrapper for converting the reads and writes to transactions
//   that follow the AXI protocol.
//
//Reference:
//Revision History:
//*****************************************************************************
`timescale 1ps/1ps

module mig_7series_v4_2_axi4_tg #(
    
     parameter C_AXI_ID_WIDTH           = 4, // The AXI id width used for read and write
                                             // This is an integer between 1-16
     parameter C_AXI_ADDR_WIDTH         = 32, // This is AXI address width for all 
                                              // SI and MI slots
     parameter C_AXI_DATA_WIDTH         = 32, // Width of the AXI write and read data
  
     parameter C_AXI_NBURST_SUPPORT     = 0, // Support for narrow burst transfers
                                             // 1-supported, 0-not supported 
     parameter C_EN_WRAP_TRANS          = 0, // Set 1 to enable wrap transactions

     parameter C_BEGIN_ADDRESS          = 0, // Start address of the address map
  
     parameter C_END_ADDRESS            = 32'hFFFF_FFFF, // End address of the address map
     
     parameter PRBS_EADDR_MASK_POS      = 32'hFFFFD000,

     parameter PRBS_SADDR_MASK_POS      = 32'h00002000,

     parameter DBG_WR_STS_WIDTH         = 40,

     parameter DBG_RD_STS_WIDTH         = 40,
  
     parameter ENFORCE_RD_WR            = 0,

     parameter ENFORCE_RD_WR_CMD        = 8'h11,

     parameter EN_UPSIZER               = 0,

     parameter ENFORCE_RD_WR_PATTERN    = 3'b000
  
)
(
   input                               aclk,    // AXI input clock
   input                               aresetn, // Active low AXI reset signal

// Input control signals
   input                               init_cmptd, // Initialization completed
   input                               init_test,  // Initialize the test
   input                               wdog_mask,  // Mask the watchdog timeouts
   input                               wrap_en,    // Enable wrap transactions

// AXI write address channel signals
   input                               axi_wready, // Indicates slave is ready to accept a 
   output [C_AXI_ID_WIDTH-1:0]         axi_wid,    // Write ID
   output [C_AXI_ADDR_WIDTH-1:0]       axi_waddr,  // Write address
   output [7:0]                        axi_wlen,   // Write Burst Length
   output [2:0]                        axi_wsize,  // Write Burst size
   output [1:0]                        axi_wburst, // Write Burst type
   output [1:0]                        axi_wlock,  // Write lock type
   output [3:0]                        axi_wcache, // Write Cache type
   output [2:0]                        axi_wprot,  // Write Protection type
   output                              axi_wvalid, // Write address valid
  
// AXI write data channel signals
   input                               axi_wd_wready,  // Write data ready
   output [C_AXI_ID_WIDTH-1:0]         axi_wd_wid,     // Write ID tag
   output [C_AXI_DATA_WIDTH-1:0]       axi_wd_data,    // Write data
   output [C_AXI_DATA_WIDTH/8-1:0]     axi_wd_strb,    // Write strobes
   output                              axi_wd_last,    // Last write transaction   
   output                              axi_wd_valid,   // Write valid
  
// AXI write response channel signals
   input  [C_AXI_ID_WIDTH-1:0]         axi_wd_bid,     // Response ID
   input  [1:0]                        axi_wd_bresp,   // Write response
   input                               axi_wd_bvalid,  // Write reponse valid
   output                              axi_wd_bready,  // Response ready
  
// AXI read address channel signals
   input                               axi_rready,     // Read address ready
   output [C_AXI_ID_WIDTH-1:0]         axi_rid,        // Read ID
   output [C_AXI_ADDR_WIDTH-1:0]       axi_raddr,      // Read address
   output [7:0]                        axi_rlen,       // Read Burst Length
   output [2:0]                        axi_rsize,      // Read Burst size
   output [1:0]                        axi_rburst,     // Read Burst type
   output [1:0]                        axi_rlock,      // Read lock type
   output [3:0]                        axi_rcache,     // Read Cache type
   output [2:0]                        axi_rprot,      // Read Protection type
   output                              axi_rvalid,     // Read address valid
  
// AXI read data channel signals   
   input  [C_AXI_ID_WIDTH-1:0]         axi_rd_bid,     // Response ID
   input  [1:0]                        axi_rd_rresp,   // Read response
   input                               axi_rd_rvalid,  // Read reponse valid
   input  [C_AXI_DATA_WIDTH-1:0]       axi_rd_data,    // Read data
   input                               axi_rd_last,    // Read last
   output                              axi_rd_rready,  // Read Response ready

// Error status signals
   output                              cmd_err,      // Error during command phase
   output                              data_msmatch_err, // Data mismatch
   output                              write_err,    // Write error occured
   output                              read_err,     // Read error occured
   output                              test_cmptd,   // Data pattern test completed
   output                              write_cmptd,  // Write test completed
   output                              read_cmptd,   // Read test completed
   output reg                          cmptd_one_wr_rd, // Completed atleast one write
                                                        // and read

// Debug status signals
   output                              cmp_data_en,
   output [C_AXI_DATA_WIDTH-1:0]       cmp_data_o,     // Compare data 
   output [C_AXI_DATA_WIDTH-1:0]       rdata_cmp,      // Read data 
   output                              dbg_wr_sts_vld, // Write debug status valid,
   output [DBG_WR_STS_WIDTH-1:0]       dbg_wr_sts,     // Write status
   output                              dbg_rd_sts_vld, // Read debug status valid
   output [DBG_RD_STS_WIDTH-1:0]       dbg_rd_sts      // Read status
);

//*****************************************************************************
// Parameter declarations
//*****************************************************************************

  localparam CTL_SIG_WIDTH             = 3;  // Control signal width
  localparam RD_STS_WIDTH              = 16; // Read port status signal width
  localparam WDG_TIMER_WIDTH           = 11;
  localparam WR_STS_WIDTH              = 16; // Write port status signal width

//*****************************************************************************
// Internal register and wire declarations
//*****************************************************************************

  wire                                 cmd_en;
  wire [2:0]                           cmd;
  wire [7:0]                           blen;
  wire [31:0]                          addr;
  wire [CTL_SIG_WIDTH-1:0]             ctl;
  wire                                 cmd_ack;

// User interface write ports
  wire                                 wrdata_vld;
  wire [C_AXI_DATA_WIDTH-1:0]          wrdata;
  wire [C_AXI_DATA_WIDTH/8-1:0]        wrdata_bvld;
  wire                                 wrdata_cmptd;
  wire                                 wrdata_rdy;
  wire                                 wrdata_sts_vld;
  wire [WR_STS_WIDTH-1:0]              wrdata_sts;

// User interface read ports
  wire                                 rddata_rdy;
  wire                                 rddata_vld;
  wire [C_AXI_DATA_WIDTH-1:0]          rddata;
  wire [C_AXI_DATA_WIDTH/8-1:0]        rddata_bvld;
  wire                                 rddata_cmptd;
  wire [RD_STS_WIDTH-1:0]              rddata_sts;
  reg                                  cmptd_one_wr;
  reg                                  cmptd_one_rd;

//*****************************************************************************
// AXI4 wrapper instance
//*****************************************************************************

  mig_7series_v4_2_axi4_wrapper #
    (
    
     .C_AXI_ID_WIDTH                   (C_AXI_ID_WIDTH),
     .C_AXI_ADDR_WIDTH                 (C_AXI_ADDR_WIDTH),
     .C_AXI_DATA_WIDTH                 (C_AXI_DATA_WIDTH),
     .C_AXI_NBURST_SUPPORT             (C_AXI_NBURST_SUPPORT),
     .C_BEGIN_ADDRESS                  (C_BEGIN_ADDRESS),
     .C_END_ADDRESS                    (C_END_ADDRESS),
     .CTL_SIG_WIDTH                    (CTL_SIG_WIDTH),
     .WR_STS_WIDTH                     (WR_STS_WIDTH),
     .RD_STS_WIDTH                     (RD_STS_WIDTH),
     .EN_UPSIZER                       (EN_UPSIZER),
     .WDG_TIMER_WIDTH                  (WDG_TIMER_WIDTH)
  
  ) axi4_wrapper_inst
  (
     .aclk                             (aclk),
     .aresetn                          (aresetn),
     
// User interface command port
     .cmd_en                           (cmd_en),
     .cmd                              (cmd),
     .blen                             (blen),
     .addr                             (addr),
     .ctl                              (ctl),
     .wdog_mask                        (wdog_mask),
     .cmd_ack                          (cmd_ack),
  
// User interface write ports
     .wrdata_vld                       (wrdata_vld),
     .wrdata                           (wrdata),
     .wrdata_bvld                      (wrdata_bvld),
     .wrdata_cmptd                     (wrdata_cmptd),
     .wrdata_rdy                       (wrdata_rdy),
     .wrdata_sts_vld                   (wrdata_sts_vld),
     .wrdata_sts                       (wrdata_sts),
  
// User interface read ports
     .rddata_rdy                       (rddata_rdy),
     .rddata_vld                       (rddata_vld),
     .rddata                           (rddata),
     .rddata_bvld                      (rddata_bvld),
     .rddata_cmptd                     (rddata_cmptd),
     .rddata_sts                       (rddata_sts),
  
// AXI write address channel signals
     .axi_wready                       (axi_wready),
     .axi_wid                          (axi_wid),
     .axi_waddr                        (axi_waddr),
     .axi_wlen                         (axi_wlen),
     .axi_wsize                        (axi_wsize),
     .axi_wburst                       (axi_wburst),
     .axi_wlock                        (axi_wlock),
     .axi_wcache                       (axi_wcache),
     .axi_wprot                        (axi_wprot),
     .axi_wvalid                       (axi_wvalid),
  
// AXI write data channel signals
     .axi_wd_wready                    (axi_wd_wready),
     .axi_wd_wid                       (axi_wd_wid),
     .axi_wd_data                      (axi_wd_data),
     .axi_wd_strb                      (axi_wd_strb),
     .axi_wd_last                      (axi_wd_last),
     .axi_wd_valid                     (axi_wd_valid),
  
// AXI write response channel signals
     .axi_wd_bid                       (axi_wd_bid),
     .axi_wd_bresp                     (axi_wd_bresp),
     .axi_wd_bvalid                    (axi_wd_bvalid),
     .axi_wd_bready                    (axi_wd_bready),
  
// AXI read address channel signals
     .axi_rready                       (axi_rready),
     .axi_rid                          (axi_rid),
     .axi_raddr                        (axi_raddr),
     .axi_rlen                         (axi_rlen),
     .axi_rsize                        (axi_rsize),
     .axi_rburst                       (axi_rburst),
     .axi_rlock                        (axi_rlock),
     .axi_rcache                       (axi_rcache),
     .axi_rprot                        (axi_rprot),
     .axi_rvalid                       (axi_rvalid),
  
// AXI read data channel signals   
     .axi_rd_bid                       (axi_rd_bid),
     .axi_rd_rresp                     (axi_rd_rresp),
     .axi_rd_rvalid                    (axi_rd_rvalid),
     .axi_rd_data                      (axi_rd_data),
     .axi_rd_last                      (axi_rd_last),
     .axi_rd_rready                    (axi_rd_rready)
  );

//*****************************************************************************
// Traffic Generator instance
//*****************************************************************************

  mig_7series_v4_2_tg #
    (
  
    .C_AXI_ADDR_WIDTH                  (C_AXI_ADDR_WIDTH),
    .C_AXI_DATA_WIDTH                  (C_AXI_DATA_WIDTH),
    .C_AXI_NBURST_SUPPORT              (C_AXI_NBURST_SUPPORT),
    .C_BEGIN_ADDRESS                   (C_BEGIN_ADDRESS),
    .C_END_ADDRESS                     (C_END_ADDRESS),
    .C_EN_WRAP_TRANS                   (C_EN_WRAP_TRANS),
    .CTL_SIG_WIDTH                     (CTL_SIG_WIDTH),
    .WR_STS_WIDTH                      (WR_STS_WIDTH),
    .RD_STS_WIDTH                      (RD_STS_WIDTH),
    .DBG_WR_STS_WIDTH                  (DBG_WR_STS_WIDTH),
    .DBG_RD_STS_WIDTH                  (DBG_RD_STS_WIDTH),
    .ENFORCE_RD_WR                     (ENFORCE_RD_WR),
    .ENFORCE_RD_WR_CMD                 (ENFORCE_RD_WR_CMD),
    .PRBS_EADDR_MASK_POS               (PRBS_EADDR_MASK_POS),
    .PRBS_SADDR_MASK_POS               (PRBS_SADDR_MASK_POS),
    .ENFORCE_RD_WR_PATTERN             (ENFORCE_RD_WR_PATTERN)

  ) traffic_gen_inst
  (
    .clk                               (aclk),
    .resetn                            (aresetn),

// Input start signals
    .init_cmptd                        (init_cmptd),
    .init_test                         (init_test),
    .wrap_en                           (wrap_en),

// Control ports
    .cmd_ack                           (cmd_ack),
    .cmd_en                            (cmd_en),
    .cmd                               (cmd),
    .blen                              (blen),
    .addr                              (addr),
    .ctl                               (ctl),

// Write port
    .wdata_rdy                         (wrdata_rdy),
    .wdata_vld                         (wrdata_vld),
    .wdata_cmptd                       (wrdata_cmptd),
    .wdata                             (wrdata),
    .wdata_bvld                        (wrdata_bvld),
    .wdata_sts_vld                     (wrdata_sts_vld),
    .wdata_sts                         (wrdata_sts),

// Read Port
    .rdata_vld                         (rddata_vld),
    .rdata                             (rddata),
    .rdata_bvld                        (rddata_bvld),
    .rdata_cmptd                       (rddata_cmptd),
    .rdata_sts                         (rddata_sts),
    .rdata_rdy                         (rddata_rdy),

// Error status signals
    .cmd_err                           (cmd_err),
    .data_msmatch_err                  (data_msmatch_err),
    .write_err                         (write_err),
    .read_err                          (read_err),
    .test_cmptd                        (test_cmptd),
    .write_cmptd                       (write_cmptd),
    .read_cmptd                        (read_cmptd),

// Debug status signals
    .cmp_data_en                       (cmp_data_en),
    .rdata_cmp                         (rdata_cmp),
    .dbg_wr_sts_vld                    (dbg_wr_sts_vld),
    .dbg_wr_sts                        (dbg_wr_sts),
    .dbg_rd_sts_vld                    (dbg_rd_sts_vld),
    .dbg_rd_sts                        (dbg_rd_sts)
  );

  assign cmp_data_o = wrdata;

  always @(posedge aclk)
    if (!aresetn) 
      cmptd_one_wr <= 1'b0;
    else if (write_cmptd)
      cmptd_one_wr <= 1'b1;

  always @(posedge aclk)
    if (!aresetn) 
      cmptd_one_rd <= 1'b0;
    else if (read_cmptd)
      cmptd_one_rd <= 1'b1;

  always @(posedge aclk)
    if (!aresetn) 
      cmptd_one_wr_rd <= 1'b0;
    else if (cmptd_one_wr & cmptd_one_rd)
      cmptd_one_wr_rd <= 1'b1;

endmodule
