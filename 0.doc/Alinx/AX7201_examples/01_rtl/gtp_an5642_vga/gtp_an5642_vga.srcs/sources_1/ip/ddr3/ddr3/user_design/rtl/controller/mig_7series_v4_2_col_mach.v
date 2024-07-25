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
//  /   /         Filename              : col_mach.v
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

// The column machine manages the dq bus.  Since there is a single DQ
// bus, and the column part of the DRAM is tightly coupled to this DQ
// bus, conceptually, the DQ bus and all of the column hardware in
// a multi rank DRAM array are managed as a single unit.
//
//
// The column machine does not "enforce" the column timing directly.
// It generates information and sends it to the bank machines.  If the
// bank machines incorrectly make a request, the column machine will
// simply overwrite the existing request with the new request even
// if this would result in a timing or protocol violation.
//
// The column machine
// hosts the block that controls read and write data transfer
// to and from the dq bus.
//
// And if configured, there is provision for tracking the address
// of a command as it moves through the column pipeline.  This
// address will be logged for detected ECC errors.

`timescale 1 ps / 1 ps

module mig_7series_v4_2_col_mach #
  (
   parameter TCQ = 100,
   parameter BANK_WIDTH               = 3,
   parameter BURST_MODE               = "8",
   parameter COL_WIDTH                = 12,
   parameter CS_WIDTH                 = 4,
   parameter DATA_BUF_ADDR_WIDTH      = 8,
   parameter DATA_BUF_OFFSET_WIDTH    = 1,
   parameter DELAY_WR_DATA_CNTRL      = 0,
   parameter DQS_WIDTH                = 8,
   parameter DRAM_TYPE                = "DDR3",
   parameter EARLY_WR_DATA_ADDR       = "OFF",
   parameter ECC                      = "OFF",
   parameter MC_ERR_ADDR_WIDTH        = 31,
   parameter nCK_PER_CLK              = 2,
   parameter nPHY_WRLAT               = 0,
   parameter RANK_WIDTH               = 2,
   parameter ROW_WIDTH                = 16
  )
  (/*AUTOARG*/
  // Outputs
  dq_busy_data, wr_data_offset, mc_wrdata_en, wr_data_en,
  wr_data_addr, rd_rmw, ecc_err_addr, ecc_status_valid, wr_ecc_buf, rd_data_end,
  rd_data_addr, rd_data_offset, rd_data_en, col_read_fifo_empty,
  // Inputs
  clk, rst, sent_col, col_size, col_wr_data_buf_addr,
  phy_rddata_valid, col_periodic_rd, col_data_buf_addr, col_rmw,
  col_rd_wr, col_ra, col_ba, col_row, col_a
  );

  input clk;
  input rst;

  input sent_col;
  input col_rd_wr;

  output reg dq_busy_data = 1'b0;

// The following generates a column command disable based mostly on the type
// of DRAM and the fabric to DRAM CK ratio.
  generate
    if ((nCK_PER_CLK == 1) && ((BURST_MODE == "8") || (DRAM_TYPE == "DDR3")))
    begin : three_bumps
      reg [1:0] granted_col_d_r;
      wire [1:0] granted_col_d_ns = {sent_col, granted_col_d_r[1]};
      always @(posedge clk) granted_col_d_r <= #TCQ granted_col_d_ns;
      always @(/*AS*/granted_col_d_r or sent_col)
                dq_busy_data = sent_col || |granted_col_d_r;
    end
    if (((nCK_PER_CLK == 2) && ((BURST_MODE == "8") || (DRAM_TYPE == "DDR3")))
    || ((nCK_PER_CLK == 1) && ((BURST_MODE == "4") || (DRAM_TYPE == "DDR2"))))
    begin : one_bump
       always @(/*AS*/sent_col) dq_busy_data = sent_col;
    end
  endgenerate

// This generates a data offset based on fabric clock to DRAM CK ratio and
// the size bit.  Note that this is different that the dq_busy_data signal
// generated above.
  reg [1:0] offset_r = 2'b0;
  reg [1:0] offset_ns = 2'b0;

  input col_size;
  wire data_end;
  generate

    if(nCK_PER_CLK == 4) begin : data_valid_4_1

      // For 4:1 mode all data is transfered in a single beat so the default
      // values of 0 for offset_r/offset_ns suffice - just tie off data_end
      assign data_end = 1'b1;

    end

    else begin
    
      if(DATA_BUF_OFFSET_WIDTH == 2) begin : data_valid_1_1
        
        always @(col_size or offset_r or rst or sent_col) begin
          if (rst) offset_ns = 2'b0;
          else begin
            offset_ns = offset_r;
            if (sent_col) offset_ns = 2'b1;
            else if (|offset_r && (offset_r != {col_size, 1'b1}))
              offset_ns = offset_r + 2'b1;
            else offset_ns = 2'b0;
          end
        
        end
          
        always @(posedge clk) offset_r <= #TCQ offset_ns;
        assign data_end = col_size ? (offset_r == 2'b11) : offset_r[0];
        
      end
      
      else begin : data_valid_2_1

        always @(col_size or rst or sent_col)
          offset_ns[0] = rst ? 1'b0 : sent_col && col_size;
        always @(posedge clk) offset_r[0] <= #TCQ offset_ns[0];
        assign data_end = col_size ? offset_r[0] : 1'b1;

      end

    end

  endgenerate

  reg [DATA_BUF_OFFSET_WIDTH-1:0] offset_r1 = {DATA_BUF_OFFSET_WIDTH{1'b0}};
  reg [DATA_BUF_OFFSET_WIDTH-1:0] offset_r2 = {DATA_BUF_OFFSET_WIDTH{1'b0}};
  reg col_rd_wr_r1;
  reg col_rd_wr_r2;
  generate
    if ((nPHY_WRLAT >= 1) || (DELAY_WR_DATA_CNTRL == 1)) begin : offset_pipe_0
      always @(posedge clk) offset_r1 <=
                              #TCQ offset_r[DATA_BUF_OFFSET_WIDTH-1:0];
      always @(posedge clk) col_rd_wr_r1 <= #TCQ col_rd_wr;
    end
    if(nPHY_WRLAT == 2) begin : offset_pipe_1
      always @(posedge clk) offset_r2 <=
                              #TCQ offset_r1[DATA_BUF_OFFSET_WIDTH-1:0];
      always @(posedge clk) col_rd_wr_r2 <= #TCQ col_rd_wr_r1;
    end
  endgenerate

  output wire [DATA_BUF_OFFSET_WIDTH-1:0] wr_data_offset;
  assign wr_data_offset = (DELAY_WR_DATA_CNTRL == 1)
                            ? offset_r1[DATA_BUF_OFFSET_WIDTH-1:0]
                            : (EARLY_WR_DATA_ADDR == "OFF")
                              ? offset_r[DATA_BUF_OFFSET_WIDTH-1:0]
                              : offset_ns[DATA_BUF_OFFSET_WIDTH-1:0];

  reg sent_col_r1;
  reg sent_col_r2;
  always @(posedge clk) sent_col_r1 <= #TCQ sent_col;
  always @(posedge clk) sent_col_r2 <= #TCQ sent_col_r1;

  wire wrdata_en =  (nPHY_WRLAT == 0) ?
                      (sent_col || |offset_r) & ~col_rd_wr :
                    (nPHY_WRLAT == 1) ?
                      (sent_col_r1 || |offset_r1) & ~col_rd_wr_r1 :
                  //(nPHY_WRLAT >= 2) ?
                      (sent_col_r2 || |offset_r2) & ~col_rd_wr_r2;

  output wire mc_wrdata_en;
  assign mc_wrdata_en = wrdata_en;

  output wire wr_data_en;
  assign wr_data_en = (DELAY_WR_DATA_CNTRL == 1)
                              ? ((sent_col_r1 || |offset_r1) && ~col_rd_wr_r1)
                              : ((sent_col || |offset_r) && ~col_rd_wr);


  input [DATA_BUF_ADDR_WIDTH-1:0] col_wr_data_buf_addr;
  output wire [DATA_BUF_ADDR_WIDTH-1:0] wr_data_addr;
  generate
    if (DELAY_WR_DATA_CNTRL == 1) begin : delay_wr_data_cntrl_eq_1
      reg [DATA_BUF_ADDR_WIDTH-1:0] col_wr_data_buf_addr_r;
      always @(posedge clk) col_wr_data_buf_addr_r <= 
                              #TCQ col_wr_data_buf_addr;
      assign wr_data_addr = col_wr_data_buf_addr_r;
    end
    else begin : delay_wr_data_cntrl_ne_1
      assign wr_data_addr = col_wr_data_buf_addr;
    end
  endgenerate

// CAS-RD to mc_rddata_en

  wire read_data_valid = (sent_col || |offset_r) && col_rd_wr;

function integer clogb2 (input integer size); // ceiling logb2
    begin
    size = size - 1;
    for (clogb2=1; size>1; clogb2=clogb2+1)
            size = size >> 1;
  end
endfunction // clogb2

// Implement FIFO that records reads as they are sent to the DRAM.
// When phy_rddata_valid is returned some unknown time later, the 
// FIFO output is used to control how the data is interpreted.
  
  input phy_rddata_valid;
  output wire rd_rmw;
  output reg [MC_ERR_ADDR_WIDTH-1:0] ecc_err_addr;
  output reg ecc_status_valid;
  output reg wr_ecc_buf;
  output reg rd_data_end;
  output reg [DATA_BUF_ADDR_WIDTH-1:0] rd_data_addr;  
  output reg [DATA_BUF_OFFSET_WIDTH-1:0] rd_data_offset;
  output reg rd_data_en /* synthesis syn_maxfan = 10 */;
  output col_read_fifo_empty;

  input col_periodic_rd;  
  input [DATA_BUF_ADDR_WIDTH-1:0] col_data_buf_addr;
  input col_rmw;
  input [RANK_WIDTH-1:0] col_ra;
  input [BANK_WIDTH-1:0] col_ba;
  input [ROW_WIDTH-1:0] col_row;
  input [ROW_WIDTH-1:0] col_a;
  
  // Real column address (skip A10/AP and A12/BC#). The maximum width is 12;
  // the width will be tailored for the target DRAM downstream.
  wire [11:0] col_a_full;

  // Minimum row width is 12; take remaining 11 bits after omitting A10/AP
  assign col_a_full[10:0] = {col_a[11], col_a[9:0]};
  
  // Get the 12th bit when row address width accommodates it; omit A12/BC#
  generate
     if (ROW_WIDTH >= 14) begin : COL_A_FULL_11_1
        assign col_a_full[11] = col_a[13];
     end else begin : COL_A_FULL_11_0
        assign col_a_full[11] = 0;
     end
  endgenerate
  
  // Extract only the width of the target DRAM
  wire [COL_WIDTH-1:0] col_a_extracted = col_a_full[COL_WIDTH-1:0];

  localparam MC_ERR_LINE_WIDTH = MC_ERR_ADDR_WIDTH-DATA_BUF_OFFSET_WIDTH;
  localparam FIFO_WIDTH = 1 /*data_end*/ +
                          1 /*periodic_rd*/ +
                          DATA_BUF_ADDR_WIDTH +
                          DATA_BUF_OFFSET_WIDTH +
                          ((ECC == "OFF") ? 0 : 1+MC_ERR_LINE_WIDTH);
  localparam FULL_RAM_CNT = (FIFO_WIDTH/6);
  localparam REMAINDER = FIFO_WIDTH % 6;
  localparam RAM_CNT = FULL_RAM_CNT + ((REMAINDER == 0 ) ? 0 : 1);
  localparam RAM_WIDTH = (RAM_CNT*6);

  generate
    begin : read_fifo

      wire [MC_ERR_LINE_WIDTH:0] ecc_line;
      if (CS_WIDTH == 1)
        assign ecc_line = {col_rmw, col_ba, col_row, col_a_extracted};
      else
        assign ecc_line = {col_rmw,
                           col_ra,
                           col_ba,
                           col_row,
                           col_a_extracted};

      wire [FIFO_WIDTH-1:0] real_fifo_data;
      if (ECC == "OFF")
         assign real_fifo_data = {data_end,
                                  col_periodic_rd,
                                  col_data_buf_addr,
                                  offset_r[DATA_BUF_OFFSET_WIDTH-1:0]};
      else
         assign real_fifo_data = {data_end,
                                  col_periodic_rd,
                                  col_data_buf_addr,
                                  offset_r[DATA_BUF_OFFSET_WIDTH-1:0],
                                  ecc_line};

      wire [RAM_WIDTH-1:0] fifo_in_data;
      if (REMAINDER == 0)
        assign fifo_in_data = real_fifo_data;
      else
        assign fifo_in_data = {{6-REMAINDER{1'b0}}, real_fifo_data};

      wire [RAM_WIDTH-1:0] fifo_out_data_ns;

      reg [4:0] head_r;
      wire [4:0] head_ns = rst ? 5'b0 : read_data_valid
                                          ? (head_r + 5'b1)
                                          : head_r;
      always @(posedge clk) head_r <= #TCQ head_ns;


      reg [4:0] tail_r;
      wire [4:0] tail_ns = rst ? 5'b0 : phy_rddata_valid
                                          ? (tail_r + 5'b1)
                                          : tail_r;
      always @(posedge clk) tail_r <= #TCQ tail_ns;

      assign col_read_fifo_empty = head_r == tail_r ? 1'b1 : 1'b0;

      genvar i;
      for (i=0; i<RAM_CNT; i=i+1) begin : fifo_ram
        RAM32M
          #(.INIT_A(64'h0000000000000000),
            .INIT_B(64'h0000000000000000),
            .INIT_C(64'h0000000000000000),
            .INIT_D(64'h0000000000000000)
          ) RAM32M0 (
            .DOA(fifo_out_data_ns[((i*6)+4)+:2]),
            .DOB(fifo_out_data_ns[((i*6)+2)+:2]),
            .DOC(fifo_out_data_ns[((i*6)+0)+:2]),
            .DOD(),
            .DIA(fifo_in_data[((i*6)+4)+:2]),
            .DIB(fifo_in_data[((i*6)+2)+:2]),
            .DIC(fifo_in_data[((i*6)+0)+:2]),
            .DID(2'b0),
            .ADDRA(tail_ns),
            .ADDRB(tail_ns),
            .ADDRC(tail_ns),
            .ADDRD(head_r),
            .WE(1'b1),
            .WCLK(clk)
           );
      end // block: fifo_ram

      reg [RAM_WIDTH-1:0] fifo_out_data_r;
      always @(posedge clk) fifo_out_data_r <= #TCQ fifo_out_data_ns;

// When ECC is ON, most of the FIFO output is delayed
// by one state.
      if (ECC == "OFF") begin
        reg periodic_rd;
        always @(/*AS*/phy_rddata_valid or fifo_out_data_r) begin
          {rd_data_end,
           periodic_rd,
           rd_data_addr,
           rd_data_offset} = fifo_out_data_r[FIFO_WIDTH-1:0];
          ecc_err_addr = {MC_ERR_ADDR_WIDTH{1'b0}};
          rd_data_en = phy_rddata_valid && ~periodic_rd;
          ecc_status_valid = 1'b0;
          wr_ecc_buf = 1'b0;
        end
        assign rd_rmw = 1'b0;
      end
      else begin
        wire rd_data_end_ns;
        wire periodic_rd;
        wire [DATA_BUF_ADDR_WIDTH-1:0] rd_data_addr_ns;
        wire [DATA_BUF_OFFSET_WIDTH-1:0] rd_data_offset_ns;
        wire [MC_ERR_ADDR_WIDTH-1:0] ecc_err_addr_ns;
        assign {rd_data_end_ns,
                periodic_rd,
                rd_data_addr_ns,
                rd_data_offset_ns,
                rd_rmw,
                ecc_err_addr_ns[DATA_BUF_OFFSET_WIDTH+:MC_ERR_LINE_WIDTH]} =
                  {fifo_out_data_r[FIFO_WIDTH-1:0]};
        assign ecc_err_addr_ns[0+:DATA_BUF_OFFSET_WIDTH] = rd_data_offset_ns;
        always @(posedge clk) rd_data_end <= #TCQ rd_data_end_ns;
        always @(posedge clk) rd_data_addr <= #TCQ rd_data_addr_ns;
        always @(posedge clk) rd_data_offset <= #TCQ rd_data_offset_ns;
        always @(posedge clk) ecc_err_addr <= #TCQ ecc_err_addr_ns;
        wire rd_data_en_ns = phy_rddata_valid && ~(periodic_rd || rd_rmw);
        always @(posedge clk) rd_data_en <= rd_data_en_ns;
        wire ecc_status_valid_ns = phy_rddata_valid && ~periodic_rd;
        always @(posedge clk) ecc_status_valid <= #TCQ ecc_status_valid_ns;
        wire wr_ecc_buf_ns = phy_rddata_valid && ~periodic_rd && rd_rmw;
        always @(posedge clk) wr_ecc_buf <= #TCQ wr_ecc_buf_ns;
      end
    end
  endgenerate

endmodule

