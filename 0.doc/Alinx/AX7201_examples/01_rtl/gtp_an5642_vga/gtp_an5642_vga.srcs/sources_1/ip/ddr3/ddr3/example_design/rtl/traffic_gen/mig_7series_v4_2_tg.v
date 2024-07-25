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
//  /   /         Filename: tg.v
// /___/   /\     Date Last Modified: $Date: 2011/06/02 08:37:24 $
// \   \  /  \    Date Created: Sept 16, 2009
//  \___\/\___\
//
//Device: Virtex-6, Spartan-6 and 7series
//Design Name: DDR3 SDRAM
//Purpose:
//   This module generates and checks the AXI traffic 
//
//Reference:
//Revision History:
//*****************************************************************************
`timescale 1ps/1ps

module mig_7series_v4_2_tg #(
  
   parameter C_AXI_ADDR_WIDTH     = 32, // This is AXI address width for all 
                                        // SI and MI slots
   parameter C_AXI_DATA_WIDTH     = 32, // Width of the AXI write and read data

   parameter C_AXI_NBURST_SUPPORT = 0, // Support for narrow burst transfers
                                       // 1-supported, 0-not supported 
   parameter C_BEGIN_ADDRESS      = 32'h0, // Start address of the address map

   parameter C_END_ADDRESS        = 32'h0000_00FF, // End address of the address map
 
   parameter C_EN_WRAP_TRANS      = 0, // Should be set to 1 for wrap transactions

   parameter CTL_SIG_WIDTH        = 3,  // Control signal width

   parameter WR_STS_WIDTH         = 16, // Write port status signal width

   parameter RD_STS_WIDTH         = 16, // Read port status signal width
 
   parameter DBG_WR_STS_WIDTH     = 40,

   parameter DBG_RD_STS_WIDTH     = 40,

   parameter ENFORCE_RD_WR        = 0,

   parameter ENFORCE_RD_WR_CMD    = 8'h11,

   parameter PRBS_EADDR_MASK_POS  = 32'hFFFFD000,

   parameter PRBS_SADDR_MASK_POS  = 32'h00002000,

   parameter ENFORCE_RD_WR_PATTERN = 3'b000

)
(
   input                      clk,          // input clock
   input                      resetn,       // Active low reset signal

// Input start signals
   input                      init_cmptd,   // Initialization completed
   input                      init_test,    // Initialize the test
   input                      wrap_en,      // Enable wrap transactions

// Control ports
   input                      cmd_ack,      // Command has been accepted
   output reg                 cmd_en,       // Command enable
   output [2:0]               cmd,          // Command
   output reg [7:0]           blen,         // Length of the burst
   output reg [31:0]          addr,         // output address
   output [CTL_SIG_WIDTH-1:0] ctl,          // Control signal

// Write port
   input                      wdata_rdy,    // Write data ready to be accepted
   output                     wdata_vld,    // Write data valid
   output reg                 wdata_cmptd,  // Write data completed
   output [C_AXI_DATA_WIDTH-1:0] wdata,     // Write data 
   output [C_AXI_DATA_WIDTH/8-1:0] wdata_bvld, // Byte valids
   input                      wdata_sts_vld, // Status valid
   input [WR_STS_WIDTH-1:0]   wdata_sts,     // Write status 

// Read Port
   input                      rdata_vld,    // Read data valid 
   input [C_AXI_DATA_WIDTH-1:0] rdata,      // Write data 
   input [C_AXI_DATA_WIDTH/8-1:0] rdata_bvld, // Byte valids
   input                      rdata_cmptd,  // Read data completed
   input [RD_STS_WIDTH-1:0]   rdata_sts,    // Read status
   output                     rdata_rdy,    // Read data ready

// Error status signals
   output reg                 cmd_err,      // Error during command phase
   output reg                 data_msmatch_err, // Data mismatch
   output reg                 write_err,    // Write error occured
   output reg                 read_err,     // Read error occured
   output                     test_cmptd,   // Completed testing with all patterns
   output                     write_cmptd,  // Completed write operation
   output                     read_cmptd,   // Completed write operation

// Debug status signals
   output                     cmp_data_en,
   output [C_AXI_DATA_WIDTH-1:0] rdata_cmp,   // read data 
   output reg                 dbg_wr_sts_vld, // Write debug status valid,
   output [DBG_WR_STS_WIDTH-1:0] dbg_wr_sts,  // Write status
   output reg                 dbg_rd_sts_vld, // Read debug status valid
   output [DBG_RD_STS_WIDTH-1:0] dbg_rd_sts   // Read status
);   

//*****************************************************************************
// Internal parameter declarations
//*****************************************************************************

  parameter [8:0]             TG_IDLE       = 8'd0,
                              TG_GEN_PRBS   = 8'd1,
                              TG_WR_CMD     = 8'd2,
                              TG_WR_DATA    = 8'd3,
                              TG_WR_DONE    = 8'd4,
                              TG_RD_CMD     = 8'd5,
                              TG_RD_DATA    = 8'd6,
                              TG_UPDT_CNTR  = 8'd7;

//*****************************************************************************
// Internal wire and reg declarations
//*****************************************************************************

  wire [2:0]                       data_pattern;
  wire                             dgen_en;
  wire                             dgen_init;
  wire [31:0]                      prbs_seed;
  wire                             msmatch_err;
  wire [31:0]                      prbs_data;
  wire [31:0]                      prbs_blen;             
  wire [7:0]                       prbs_blen_mdfy;             
  wire [31:0]                      prbs_addr;             
  wire [31:0]                      prbs_addr_mdfy;
  wire                             cmd_gen_csr_sig;
  wire                             rdata_sig_vld;
  wire                             wdata_sig_vld;
  reg  [7:0]                       rd_mismatch_wrd_cntr_r;
  wire [7:0]                       rd_wrd_cntr;
  reg  [7:0]                       wr_wrd_cntr;
  reg  [7:0]                       rd_wrd_cntr_r;
  reg  [7:0]                       wr_wrd_cntr_r;
  wire                             wrd_cntr_rst;
  wire                             w_burst_4;
  wire                             w_burst_8;
  wire                             w_burst_16;
  
  reg  [7:0]                       tg_state;
  reg  [7:0]                       next_tg_state;
  reg  [2:0]                       shft_cntr;
  reg  [2:0]                       seed_cntr;
  reg                              cmd_vld;
  reg  [7:0]                       blen_cntr;
  reg                              wr_proc;
  reg                              curr_wr_ptr;
  reg                              curr_rd_ptr;
  reg  [31:0]                      curr_addr1;             
  reg  [31:0]                      curr_addr2;             
  reg  [7:0]                       curr_blen1;             
  reg  [7:0]                       curr_blen2;             
  reg                              cmd_wr_en;
  reg                              cmd_wr_en_r;
  reg                              cmd_rd_en;
  reg  [7:0]                       cmd_gen_csr;
  reg                              cmd_err_dbg;
  reg                              data_msmatch_err_dbg;
  reg                              write_err_dbg;
  reg                              read_err_dbg;
  reg  [WR_STS_WIDTH-1:0]          wdata_sts_r; // Write status registered 
  reg  [RD_STS_WIDTH-1:0]          rdata_sts_r; // Read status registered
  
//*****************************************************************************
// FSM Control Block
//*****************************************************************************

  always @(posedge clk) begin
    if (!resetn | init_test)
      tg_state <= 8'h1;
    else 
      tg_state <= next_tg_state;
  end

  always @(*) begin
    next_tg_state = 8'h0;
    case (1'b1)
      tg_state[TG_IDLE]: begin // 8'h01
        if (init_cmptd) 
          next_tg_state[TG_GEN_PRBS] = 1'b1;
        else
          next_tg_state[TG_IDLE] = 1'b1;
      end
      tg_state[TG_GEN_PRBS]: begin // 8'h02
        if (cmd_vld) begin
          if (cmd_gen_csr_sig)
            next_tg_state[TG_WR_CMD] = 1'b1;
          else
            next_tg_state[TG_RD_CMD] = 1'b1;
        end else
          next_tg_state[TG_GEN_PRBS] = 1'b1;
      end
      tg_state[TG_WR_CMD]: begin // 8'h04
        if (wdata_sts_vld) begin
          if (&shft_cntr)
            next_tg_state[TG_UPDT_CNTR] = 1'b1;
          else
            next_tg_state[TG_GEN_PRBS] = 1'b1;
        end
        else if (wdata_rdy)
          next_tg_state[TG_WR_DATA] = 1'b1;
        else
          next_tg_state[TG_WR_CMD] = 1'b1;
      end
      tg_state[TG_WR_DATA]: begin // 8'h08
        if (wdata_sts_vld) begin
          if (&shft_cntr)
            next_tg_state[TG_UPDT_CNTR] = 1'b1;
          else
            next_tg_state[TG_GEN_PRBS] = 1'b1;
        end
        else if (blen_cntr == 8'h0 & wdata_rdy)
          next_tg_state[TG_WR_DONE] = 1'b1;
        else
          next_tg_state[TG_WR_DATA] = 1'b1;
      end
      tg_state[TG_WR_DONE]: begin // 8'h10
        if (wdata_sts_vld) begin
          if (&shft_cntr)
            next_tg_state[TG_UPDT_CNTR] = 1'b1;
          else
            next_tg_state[TG_GEN_PRBS] = 1'b1;
        end
        else
          next_tg_state[TG_WR_DONE] = 1'b1;
      end
      tg_state[TG_RD_CMD]: begin // 8'h20
        if (rdata_cmptd) begin
          if (&shft_cntr)
            next_tg_state[TG_UPDT_CNTR] = 1'b1;
          else
            next_tg_state[TG_GEN_PRBS] = 1'b1;
        end
        else if (cmd_ack)
          next_tg_state[TG_RD_DATA] = 1'b1;
        else
          next_tg_state[TG_RD_CMD] = 1'b1;
      end
      tg_state[TG_RD_DATA]: begin // 8'h040
        if (rdata_cmptd & rdata_vld & rdata_rdy) begin
          if (&shft_cntr)
            next_tg_state[TG_UPDT_CNTR] = 1'b1;
          else
            next_tg_state[TG_GEN_PRBS] = 1'b1;
        end
        else
          next_tg_state[TG_RD_DATA] = 1'b1;
      end
      tg_state[TG_UPDT_CNTR]: begin // 8'h80
        if (&seed_cntr)
          next_tg_state[TG_IDLE] = 1'b1;
        else
          next_tg_state[TG_GEN_PRBS] = 1'b1;
      end
    endcase
  end

//*****************************************************************************
// Control Signals
//*****************************************************************************

  always @(posedge clk) begin
    if (!resetn)
      cmd_wr_en <= 1'b0;
    else if (next_tg_state[TG_WR_CMD] & tg_state[TG_GEN_PRBS])
      cmd_wr_en <= 1'b1;
    else 
      cmd_wr_en <= 1'b0;
  end

  always @(posedge clk) begin
    if (!resetn)
      cmd_rd_en <= 1'b0;
    else if (next_tg_state[TG_RD_CMD] & tg_state[TG_GEN_PRBS])
      cmd_rd_en <= 1'b1;
    else 
      cmd_rd_en <= 1'b0;
  end

  always @(posedge clk) begin
    if (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR])
      curr_wr_ptr <= 1'b0;
    else if (cmd_wr_en)    
      curr_wr_ptr <= ~curr_wr_ptr;
  end

  always @(posedge clk) begin
    if (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR])
      curr_rd_ptr <= 1'b0;
    else if (cmd_rd_en)    
      curr_rd_ptr <= ~curr_rd_ptr;
  end

  always @(posedge clk) begin
    if (!resetn)
      cmd_vld <= 1'b0;
    else if (tg_state[TG_WR_CMD] | tg_state[TG_RD_CMD])
      cmd_vld <= 1'b0;
    else if (tg_state[TG_GEN_PRBS])
      cmd_vld <= 1'b1;
  end

  always @(posedge clk) begin
    if (tg_state[TG_IDLE])
      wr_proc <= 1'b0;
    else if (cmd_wr_en)
      wr_proc <= 1'b1;
    else if (cmd_rd_en)
      wr_proc <= 1'b0;
  end     

  always @(posedge clk) begin
    if (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR])
      shft_cntr <= 3'b000;
    else if (tg_state[TG_GEN_PRBS] & (next_tg_state[TG_WR_CMD] | 
                                      next_tg_state[TG_RD_CMD]))
      shft_cntr <= shft_cntr + 3'b001;
  end

  always @(posedge clk)
    cmd_wr_en_r <= cmd_wr_en;

  assign prbs_seed = {{10{seed_cntr}}, 2'b10};
  assign dgen_init = next_tg_state[TG_GEN_PRBS] & !tg_state[TG_GEN_PRBS];
  assign agen_init = next_tg_state[TG_GEN_PRBS] & (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR]);
  assign cgen_init = next_tg_state[TG_GEN_PRBS] & (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR]);
  assign data_pattern = (ENFORCE_RD_WR == 1) ? ENFORCE_RD_WR_PATTERN :
                                               seed_cntr;
  assign dgen_en   = wr_proc ? (tg_state[TG_WR_DATA] & wdata_rdy) :
                               (tg_state[TG_RD_DATA] & rdata_vld) ;
  assign wrd_cntr_rst = tg_state[TG_GEN_PRBS] | tg_state[TG_IDLE];

//*****************************************************************************
// Data Generation, FIFO, Checker and Data Sizer block
//*****************************************************************************

  mig_7series_v4_2_data_gen_chk #
    (
   
    .C_AXI_DATA_WIDTH       (C_AXI_DATA_WIDTH)
    
    ) data_gen_chk_inst
    (
     .clk                   (clk),
     .data_en               (dgen_en),
     .data_pattern          (data_pattern),
     .pattern_init          (dgen_init),   
     .prbs_seed_i           (prbs_seed),
     .rdata                 (rdata),
     .rdata_bvld            (rdata_bvld),
     .rdata_vld             (rdata_sig_vld),
     .msmatch_err           (msmatch_err),   
     .wrd_cntr_rst          (wrd_cntr_rst),
     .wrd_cntr              (rd_wrd_cntr),
     .data_o                (prbs_data)       
    );

  assign rdata_rdy = tg_state[TG_RD_DATA];

  assign rdata_sig_vld = wr_proc ? 1'b0 : (rdata_vld & tg_state[TG_RD_DATA]);
  assign wdata_sig_vld = wr_proc ? (wdata_vld & tg_state[TG_WR_DATA]) : 1'b0;


//*****************************************************************************
// Command generation
//*****************************************************************************

  always @(posedge clk) begin
    if (tg_state[TG_IDLE])
      seed_cntr <= 3'b000;
    else if (next_tg_state[TG_UPDT_CNTR] & 
             (tg_state[TG_WR_DATA] | tg_state[TG_WR_DONE] |
              tg_state[TG_WR_CMD] | tg_state[TG_RD_CMD] | 
              tg_state[TG_RD_DATA] ))
      seed_cntr <= seed_cntr + 3'b001;
  end

  always @(posedge clk) begin
    if (tg_state[TG_IDLE] | tg_state[TG_UPDT_CNTR]) begin
      if (ENFORCE_RD_WR == 1)
        cmd_gen_csr <= ENFORCE_RD_WR_CMD;
      else
        cmd_gen_csr <= {seed_cntr, 1'b1, seed_cntr, 1'b1};
    end
    else if (next_tg_state[TG_GEN_PRBS] & 
             (tg_state[TG_WR_CMD] | tg_state[TG_WR_DATA] |
              tg_state[TG_RD_DATA] | tg_state[TG_RD_CMD] | 
              tg_state[TG_WR_DONE]))      
      cmd_gen_csr <= cmd_gen_csr >> 1;
  end

  assign cmd_gen_csr_sig = cmd_gen_csr[0];

//*****************************************************************************
// Burst Length generation PRBS
//*****************************************************************************

  mig_7series_v4_2_cmd_prbs_gen_axi #
    (
     .PRBS_CMD            ("BLEN"),
     .PRBS_WIDTH          (32),        //   64,15,20
     .SEED_WIDTH          (32),        //   32,15,4
     .ADDR_WIDTH          (C_AXI_ADDR_WIDTH) 
     ) blen_gen_inst
    (
     .clk_i                 (clk),
     .prbs_seed_init        (cgen_init),  
     .clk_en                (cmd_wr_en_r),
     .prbs_seed_i           (prbs_seed),
     .prbs_o                (prbs_blen)
    );

  assign w_burst_4      = (|prbs_blen[7:2]);
  assign w_burst_8      = (|prbs_blen[7:3]);
  assign w_burst_16     = (|prbs_blen[7:4]);
  assign prbs_blen_mdfy = (C_EN_WRAP_TRANS == 1 && wrap_en) ? {4'h0, w_burst_16, w_burst_8, 
                                                    w_burst_4, 1'b1} : prbs_blen[7:0];

  always @(posedge clk) begin
    if (tg_state[TG_IDLE]) begin
      curr_blen1 <= 8'h0;
      curr_blen2 <= 8'h0;
    end
    else if (cmd_wr_en) begin
      if (curr_wr_ptr)
        curr_blen2 <= prbs_blen_mdfy;
      else
        curr_blen1 <= prbs_blen_mdfy;
    end
  end

  always @(posedge clk) begin
    if (tg_state[TG_IDLE] | (next_tg_state[TG_GEN_PRBS] & !tg_state[TG_GEN_PRBS])) 
      blen_cntr <= 8'h00;
    else if (tg_state[TG_GEN_PRBS] & next_tg_state[TG_GEN_PRBS])
      blen_cntr <= prbs_blen_mdfy;
    else if (tg_state[TG_WR_DATA] & wdata_rdy & (blen_cntr != 8'h00))
      blen_cntr <= blen_cntr - 8'h01;
  end

//*****************************************************************************
// Address generation PRBS
//*****************************************************************************

  mig_7series_v4_2_cmd_prbs_gen_axi #
    (
     .FAMILY              ("VIRTEX7"),
     .ADDR_WIDTH          (C_AXI_ADDR_WIDTH),
     .PRBS_CMD            ("ADDRESS"), // "INSTR", "BLEN","ADDRESS"
     .PRBS_WIDTH          (32),        //   64,15,20
     .SEED_WIDTH          (32),        //   32,15,4
     .PRBS_EADDR_MASK_POS (PRBS_EADDR_MASK_POS),
     .PRBS_SADDR_MASK_POS (PRBS_SADDR_MASK_POS),
     .PRBS_EADDR          (C_END_ADDRESS),
     .PRBS_SADDR          (C_BEGIN_ADDRESS)
    ) addr_gen_inst
    (
     .clk_i                 (clk),
     .prbs_seed_init        (agen_init),  
     .clk_en                (cmd_wr_en_r),
     .prbs_seed_i           (prbs_seed),
     .prbs_o                (prbs_addr)
    );
 
  generate 
    begin: addr_axi_wr
      if (C_AXI_DATA_WIDTH == 256)
        assign prbs_addr_mdfy = prbs_addr[31:0] & 32'hffff_ffe0;
      else if (C_AXI_DATA_WIDTH == 128)
        assign prbs_addr_mdfy = prbs_addr[31:0] & 32'hffff_fff0;
      else if (C_AXI_DATA_WIDTH == 64)
        assign prbs_addr_mdfy = prbs_addr[31:0] & 32'hffff_fff8;
      else
        assign prbs_addr_mdfy = prbs_addr[31:0] & 32'hffff_fffc;
    end
  endgenerate
 
  always @(posedge clk) begin
    if (tg_state[TG_IDLE]) begin
      curr_addr1 <= 32'h0;
      curr_addr2 <= 32'h0;
    end
    else if (cmd_wr_en) begin
      if (curr_wr_ptr)
        curr_addr2 <= prbs_addr_mdfy;
      else
        curr_addr1 <= prbs_addr_mdfy;
    end
  end

//*****************************************************************************
// Control Output Signals
//*****************************************************************************

  always @(posedge clk) begin
    if (!resetn)
      cmd_en <= 1'b0;
    else if (tg_state[TG_WR_CMD] | tg_state[TG_RD_CMD])
      cmd_en <= 1'b1;
    else if (tg_state[TG_WR_DATA] | tg_state[TG_RD_DATA])
      cmd_en <= 1'b0;
  end

  assign cmd = {cmd_gen_csr_sig, 1'b0, wrap_en};

  always @(posedge clk) begin
    if (tg_state[TG_IDLE]) begin
      blen <= 8'h0;
      addr <= 32'h0;
    end
    else if (cmd_gen_csr_sig & tg_state[TG_GEN_PRBS]) begin
      blen <= prbs_blen_mdfy;
      addr <= prbs_addr_mdfy;
    end
    else if (tg_state[TG_GEN_PRBS]) begin
      case ({curr_wr_ptr, curr_rd_ptr})
        2'b01: begin
          blen <= curr_blen2;
          addr <= curr_addr2;
        end 
        default : begin 
          blen <= curr_blen1;
          addr <= curr_addr1;
        end
      endcase
    end
  end

  generate 
    begin: cntrl_sig
      if (C_AXI_NBURST_SUPPORT == 1) begin
      end
      else begin
        if (C_AXI_DATA_WIDTH == 1024) 
          assign ctl[2:0] = 3'b111;
        else if (C_AXI_DATA_WIDTH == 512) 
          assign ctl[2:0] = 3'b110;
        else if (C_AXI_DATA_WIDTH == 256) 
          assign ctl[2:0] = 3'b101;
        else if (C_AXI_DATA_WIDTH == 128) 
          assign ctl[2:0] = 3'b100;
        else if (C_AXI_DATA_WIDTH == 64) 
          assign ctl[2:0] = 3'b011;
        else
          assign ctl[2:0] = 3'b010;
      end
    end
  endgenerate

//*****************************************************************************
// Write Output Signals
//*****************************************************************************

  always @(posedge clk) begin
    if (!resetn)
      wdata_cmptd <= 1'b0;
    else if (tg_state[TG_WR_DONE])
      wdata_cmptd <= 1'b0;
    else if ((tg_state[TG_WR_DATA] & wdata_rdy & blen_cntr == 8'h01) |
             (next_tg_state[TG_WR_DATA] & tg_state[TG_WR_CMD] & blen_cntr == 8'h00))
      wdata_cmptd <= 1'b1;
  end

  assign wdata_vld = tg_state[TG_WR_DATA];
  assign wdata = {{C_AXI_DATA_WIDTH/32}{prbs_data}};

  generate 
    begin: data_sig
      if (C_AXI_NBURST_SUPPORT == 1) begin
      end
      else begin
        assign wdata_bvld = {{C_AXI_DATA_WIDTH/32}{4'hF}};
      end
    end
  endgenerate

//*****************************************************************************
// Status and Debug Signals
//*****************************************************************************

  always @(posedge clk) begin
    if (!resetn) begin
      cmd_err_dbg <= 1'b0;
      data_msmatch_err_dbg <= 1'b0;
      write_err_dbg <= 1'b0;
      read_err_dbg <= 1'b0;
    end
    else if (tg_state[TG_IDLE] & next_tg_state[TG_GEN_PRBS]) begin
      cmd_err_dbg <= 1'b0;
      data_msmatch_err_dbg <= 1'b0;
      write_err_dbg <= 1'b0;
      read_err_dbg <= 1'b0;
    end
    else begin
      if ((next_tg_state[TG_GEN_PRBS] | next_tg_state[TG_UPDT_CNTR]) &
          (tg_state[TG_RD_CMD] | tg_state[TG_WR_CMD])) 
        cmd_err_dbg <= 1'b0;
      if (msmatch_err & tg_state[TG_RD_DATA])
        data_msmatch_err_dbg <= 1'b1;
      if ((next_tg_state[TG_GEN_PRBS] | next_tg_state[TG_UPDT_CNTR]) &
          tg_state[TG_WR_DATA]) 
        write_err_dbg <= 1'b1;
      if (rdata_cmptd & rdata_vld & rdata_rdy)    
        read_err_dbg <= (rdata_sts[3:2] == 2'b01);
    end
  end

  always @(posedge clk) begin
    if (!resetn) begin
      cmd_err <= 1'b0;
      data_msmatch_err <= 1'b0;
      write_err <= 1'b0;
      read_err <= 1'b0;
    end
    else begin
      if (cmd_err_dbg)
        cmd_err <= 1'b1;
      if (data_msmatch_err_dbg)  
        data_msmatch_err <= 1'b1;
      if (write_err_dbg) 
        write_err <= 1'b1;
      if (read_err_dbg)
        read_err <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (!resetn) begin
      dbg_wr_sts_vld <= 1'b0;
      dbg_rd_sts_vld <= 1'b0;
    end
    else if (tg_state[TG_GEN_PRBS]) begin
      dbg_wr_sts_vld <= 1'b0;
      dbg_rd_sts_vld <= 1'b0;
    end
    else begin
      if (wdata_sts_vld)
        dbg_wr_sts_vld <= 1'b1;
      if (rdata_cmptd & rdata_vld & rdata_rdy)
        dbg_rd_sts_vld <= 1'b1;
    end
  end 

  always @(posedge clk) begin
    if (tg_state[TG_GEN_PRBS] | tg_state[TG_IDLE]) begin
      wdata_sts_r <= {WR_STS_WIDTH{1'b0}};
      rdata_sts_r <= {RD_STS_WIDTH{1'b0}};
    end
    else begin
      if (wdata_sts_vld)
        wdata_sts_r <= wdata_sts;
      if (rdata_cmptd & rdata_vld & rdata_rdy)
        rdata_sts_r <= rdata_sts;
    end
  end      

  //*****************************************************************************
  // Data count generation incremented for each burst to indicate activity
  //*****************************************************************************

  // Write count within a burst
  always @(posedge clk)
    if (wrd_cntr_rst)
      wr_wrd_cntr <= 8'h00;
    else if (wdata_sig_vld)
      wr_wrd_cntr <= wr_wrd_cntr + 8'h01;

  // Read count within a burst is implemented inside the data_gen_chk module

  // Storing last burst count for read and write
  always @(posedge clk)
    if (!resetn)
      wr_wrd_cntr_r <= 8'h00;
    else if (dbg_wr_sts_vld)
      wr_wrd_cntr_r <= wr_wrd_cntr;

  always @(posedge clk)
    if (!resetn)
      rd_wrd_cntr_r <= 8'h00;
    else if (dbg_rd_sts_vld)
      rd_wrd_cntr_r <= rd_wrd_cntr;

  // Computing the word count at which first data mismatch occured
  always @(posedge clk)
    if (wrd_cntr_rst)
      rd_mismatch_wrd_cntr_r <= 8'h00;
    else if (~data_msmatch_err_dbg)
      rd_mismatch_wrd_cntr_r <= rd_wrd_cntr - 1;
  
  assign dbg_wr_sts = {rd_wrd_cntr_r, 11'h0, data_pattern, write_err_dbg, cmd_err_dbg, wdata_sts_r};
  assign dbg_rd_sts = {wr_wrd_cntr_r, 2'b00, data_pattern, rd_mismatch_wrd_cntr_r, data_msmatch_err_dbg, read_err_dbg, cmd_err_dbg, rdata_sts_r}; 
  assign test_cmptd = tg_state[TG_UPDT_CNTR] & next_tg_state[TG_IDLE];
  assign write_cmptd = (tg_state[TG_WR_DATA] | tg_state[TG_WR_DONE]) & 
                       (next_tg_state[TG_GEN_PRBS] | next_tg_state[TG_UPDT_CNTR]);
  assign read_cmptd = tg_state[TG_RD_DATA] & (next_tg_state[TG_GEN_PRBS] | next_tg_state[TG_UPDT_CNTR]);
  assign cmp_data_en = dgen_en & tg_state[TG_RD_DATA];
  assign rdata_cmp  = rdata;

// synthesis translate_off
//*****************************************************************************
// Simulation debug signals and messages
//*****************************************************************************
 
  
  always @(*) begin
    if (test_cmptd) begin
      $display ("[INFO] : All tests have been completed");
      if (cmd_err)
        $display ("[ERROR] Command error has occured");
      if (data_msmatch_err)
        $display ("[ERROR] Data mismatch error occured");
      if (write_err)
        $display ("[ERROR] Timeout occured during write transaction");
      if (read_err)
        $display ("[ERROR] Timeout occured during read transaction");
      if (!cmd_err & !data_msmatch_err & !write_err & !read_err)
        $display ("[INFO] : Tests PASSED");
      $finish;
    end 
  end  

// synthesis translate_on

endmodule
