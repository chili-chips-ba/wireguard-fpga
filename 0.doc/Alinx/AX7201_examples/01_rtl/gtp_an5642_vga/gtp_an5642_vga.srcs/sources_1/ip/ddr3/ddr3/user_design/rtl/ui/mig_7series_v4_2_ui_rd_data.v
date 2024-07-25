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
//  /   /         Filename              : ui_rd_data.v
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

// User interface read buffer.  Re orders read data returned from the
// memory controller back to the request order.
//
// Consists of a large buffer for the data, a status RAM and two counters.
//
// The large buffer is implemented with distributed RAM in 6 bit wide,
// 1 read, 1 write mode.  The status RAM is implemented with a distributed
// RAM configured as 2 bits wide 1 read/write, 1 read mode.
//
// As read requests are received from the application, the data_buf_addr
// counter supplies the data_buf_addr sent into the memory controller.
// With each read request, the counter is incremented, eventually rolling
// over.  This mechanism labels each read request with an incrementing number.
//
// When the memory controller returns read data, it echos the original
// data_buf_addr with the read data.
//
// The status RAM is indexed with the same address as the data buffer
// RAM.  Each word of the data buffer RAM has an associated status bit
// and "end" bit.  Requests of size 1 return a data burst on two consecutive
// states.  Requests of size zero return with a single assertion of rd_data_en.
//
// Upon returning data, the status and end bits are updated for each
// corresponding location in the status RAM indexed by the data_buf_addr
// echoed on the rd_data_addr field.
//
// The other side of the status and data RAMs is indexed by the rd_buf_indx.
// The rd_buf_indx constantly monitors the status bit it is currently
// pointing to.  When the status becomes set to the proper state (more on
// this later) read data is returned to the application, and the rd_buf_indx
// is incremented.
//
// At rst the rd_buf_indx is initialized to zero.  Data will not have been
// returned from the memory controller yet, so there is nothing to return
// to the application. Evenutally, read requests will be made, and the
// memory controller will return the corresponding data.  The memory
// controller may not return this data in the request order.  In which
// case, the status bit at location zero, will not indicate
// the data for request zero is ready.  Eventually, the memory controller
// will return data for request zero.  The data is forwarded on to the
// application, and rd_buf_indx is incremented to point to the next status
// bits and data in the buffers.  The status bit will be examined, and if
// data is valid, this data will be returned as well.  This process
// continues until the status bit indexed by rd_buf_indx indicates data
// is not ready.  This may be because the rd_data_buf
// is empty, or that some data was returned out of order.   Since rd_buf_indx
// always increments sequentially, data is always returned to the application
// in request order.
//
// Some further discussion of the status bit is in order.  The rd_data_buf
// is a circular buffer.  The status bit is a single bit.  Distributed RAM
// supports only a single write port.  The write port is consumed by
// memory controller read data updates.  If a simple '1' were used to
// indicate the status, when rd_data_indx rolled over it would immediately
// encounter a one for a request that may not be ready.
//
// This problem is solved by causing read data returns to flip the
// status bit, and adding hi order bit beyond the size required to
// index the rd_data_buf.  Data is considered ready when the status bit
// and this hi order bit are equal.
//
// The status RAM needs to be initialized to zero after reset.  This is
// accomplished by cycling through all rd_buf_indx valus and writing a
// zero to the status bits directly following deassertion of reset.  This
// mechanism is used for similar purposes
// for the wr_data_buf.
//
// When ORDERING == "STRICT", read data reordering is unnecessary.  For thi
// case, most of the logic in the block is not generated.

`timescale 1 ps / 1 ps

// User interface read data.

module mig_7series_v4_2_ui_rd_data #
  (
   parameter TCQ = 100,
   parameter APP_DATA_WIDTH       = 256,
   parameter DATA_BUF_ADDR_WIDTH  = 5,
   parameter ECC                  = "OFF",
   parameter nCK_PER_CLK          = 2 ,
   parameter ORDERING             = "NORM"
  )
  (/*AUTOARG*/
  // Outputs
  ram_init_done_r, ram_init_addr, app_rd_data_valid, app_rd_data_end,
  app_rd_data, app_ecc_multiple_err, rd_buf_full, rd_data_buf_addr_r,
  app_ecc_single_err, 
  // Inputs
  rst, clk, rd_data_en, rd_data_addr, rd_data_offset, rd_data_end,
  rd_data, ecc_multiple, ecc_single, rd_accepted
  );

  input rst;
  input clk;

  output wire ram_init_done_r;
  output wire [3:0] ram_init_addr;

// rd_buf_indx points to the status and data storage rams for
// reading data out to the app.
  reg [5:0] rd_buf_indx_r;
  reg ram_init_done_r_lcl /* synthesis syn_maxfan = 10 */;
  assign ram_init_done_r = ram_init_done_r_lcl;
  wire app_rd_data_valid_ns;
  wire single_data;
  reg [5:0] rd_buf_indx_ns;
  generate begin : rd_buf_indx
      wire upd_rd_buf_indx = ~ram_init_done_r_lcl || app_rd_data_valid_ns;
// Loop through all status write addresses once after rst.  Initializes
// the status and pointer RAMs.
      wire ram_init_done_ns =
            ~rst && (ram_init_done_r_lcl || (rd_buf_indx_r[4:0] == 5'h1f));
      always @(posedge clk) ram_init_done_r_lcl <= #TCQ ram_init_done_ns;

      always @(/*AS*/rd_buf_indx_r or rst or single_data
               or upd_rd_buf_indx) begin
        rd_buf_indx_ns = rd_buf_indx_r;
        if (rst) rd_buf_indx_ns = 6'b0;
        else if (upd_rd_buf_indx) rd_buf_indx_ns =
          // need to use every slot of RAMB32 if all address bits are used
          rd_buf_indx_r + 6'h1 + (DATA_BUF_ADDR_WIDTH == 5 ? 0 : single_data);
      end
      always @(posedge clk) rd_buf_indx_r <= #TCQ rd_buf_indx_ns;
    end
  endgenerate
  assign ram_init_addr = rd_buf_indx_r[3:0];

  input rd_data_en;
  input [DATA_BUF_ADDR_WIDTH-1:0] rd_data_addr;
  input rd_data_offset;
  input rd_data_end;
  input [APP_DATA_WIDTH-1:0] rd_data;
  output reg app_rd_data_valid /* synthesis syn_maxfan = 10 */;
  output reg app_rd_data_end;
  output reg [APP_DATA_WIDTH-1:0] app_rd_data;
  input [(2*nCK_PER_CLK)-1:0] ecc_multiple;
  input [(2*nCK_PER_CLK)-1:0] ecc_single;
  reg [2*nCK_PER_CLK-1:0] app_ecc_multiple_err_r = 'b0;
  reg [2*nCK_PER_CLK-1:0] app_ecc_single_err_r = 'b0;
  output wire [2*nCK_PER_CLK-1:0] app_ecc_multiple_err;
  output wire [2*nCK_PER_CLK-1:0] app_ecc_single_err;
  assign app_ecc_multiple_err = app_ecc_multiple_err_r;
  assign app_ecc_single_err = app_ecc_single_err_r;
  input rd_accepted;
  output wire rd_buf_full;
  output wire [DATA_BUF_ADDR_WIDTH-1:0] rd_data_buf_addr_r;

// Compute dimensions of read data buffer.  Depending on width of
// DQ bus and DRAM CK
// to fabric ratio, number of RAM32Ms is variable.  RAM32Ms are used in
// single write, single read, 6 bit wide mode.
  localparam RD_BUF_WIDTH = APP_DATA_WIDTH + (ECC == "OFF" ? 0 : 2*2*nCK_PER_CLK);
  localparam FULL_RAM_CNT = (RD_BUF_WIDTH/6);
  localparam REMAINDER = RD_BUF_WIDTH % 6;
  localparam RAM_CNT = FULL_RAM_CNT + ((REMAINDER == 0 ) ? 0 : 1);
  localparam RAM_WIDTH = (RAM_CNT*6);
  generate
    if (ORDERING == "STRICT") begin : strict_mode
      assign app_rd_data_valid_ns = 1'b0;
      assign single_data = 1'b0;
      assign rd_buf_full = 1'b0;
      reg [DATA_BUF_ADDR_WIDTH-1:0] rd_data_buf_addr_r_lcl;
      wire [DATA_BUF_ADDR_WIDTH-1:0] rd_data_buf_addr_ns =
                   rst
                    ? 0
                    : rd_data_buf_addr_r_lcl + rd_accepted;
      always @(posedge clk) rd_data_buf_addr_r_lcl <=
                                #TCQ rd_data_buf_addr_ns;
      assign rd_data_buf_addr_r = rd_data_buf_addr_ns;
// app_* signals required to be registered.      
      if (ECC == "OFF") begin : ecc_off
        always @(/*AS*/rd_data) app_rd_data = rd_data;
        always @(/*AS*/rd_data_en) app_rd_data_valid = rd_data_en;
        always @(/*AS*/rd_data_end) app_rd_data_end = rd_data_end;
      end
      else begin : ecc_on  
        always @(posedge clk) app_rd_data <= #TCQ rd_data;
        always @(posedge clk) app_rd_data_valid <= #TCQ rd_data_en;
        always @(posedge clk) app_rd_data_end <= #TCQ rd_data_end;
        always @(posedge clk) app_ecc_multiple_err_r <= #TCQ ecc_multiple;
        always @(posedge clk) app_ecc_single_err_r <= #TCQ ecc_single;
      end
    end
    else begin : not_strict_mode
 wire rd_buf_we = ~ram_init_done_r_lcl || rd_data_en /* synthesis syn_maxfan = 10 */;
      // In configurations where read data is returned in a single fabric cycle
      // the offset is always zero and we can use the bit to get a deeper
      // FIFO. The RAMB32 has 5 address bits, so when the DATA_BUF_ADDR_WIDTH
      // is set to use them all, discard the offset. Otherwise, include the
      // offset.
      wire [4:0] rd_buf_wr_addr = DATA_BUF_ADDR_WIDTH == 5 ?
                                    rd_data_addr :
                                    {rd_data_addr, rd_data_offset};
      wire [1:0] rd_status;
// Instantiate status RAM.  One bit for status and one for "end".
      begin : status_ram
// Turns out read to write back status is a timing path.  Update
// the status in the ram on the state following the read.  Bypass
// the write data into the status read path.
        wire [4:0] status_ram_wr_addr_ns = ram_init_done_r_lcl
                                           ? rd_buf_wr_addr
                                           : rd_buf_indx_r[4:0];
        reg [4:0] status_ram_wr_addr_r;
        always @(posedge clk) status_ram_wr_addr_r <=
                             #TCQ status_ram_wr_addr_ns;
        wire [1:0] wr_status;
// Not guaranteed to write second status bit.  If it is written, always
// copy in the first status bit.
        reg wr_status_r1;
        always @(posedge clk) wr_status_r1 <= #TCQ wr_status[0];
        wire [1:0] status_ram_wr_data_ns =
                         ram_init_done_r_lcl
                           ? {rd_data_end, ~(rd_data_offset
                                              ? wr_status_r1
                                              : wr_status[0])}
                           : 2'b0;
        reg [1:0] status_ram_wr_data_r;
        always @(posedge clk) status_ram_wr_data_r <=
                              #TCQ status_ram_wr_data_ns;
        reg rd_buf_we_r1;
        always @(posedge clk) rd_buf_we_r1 <= #TCQ rd_buf_we;
        RAM32M
          #(.INIT_A(64'h0000000000000000),
            .INIT_B(64'h0000000000000000),
            .INIT_C(64'h0000000000000000),
            .INIT_D(64'h0000000000000000)
           ) RAM32M0 (
            .DOA(rd_status),
            .DOB(),
            .DOC(wr_status),
            .DOD(),
            .DIA(status_ram_wr_data_r),
            .DIB(2'b0),
            .DIC(status_ram_wr_data_r),
            .DID(status_ram_wr_data_r),
            .ADDRA(rd_buf_indx_r[4:0]),
            .ADDRB(5'b0),
            .ADDRC(status_ram_wr_addr_ns),
            .ADDRD(status_ram_wr_addr_r),
            .WE(rd_buf_we_r1),
            .WCLK(clk)
           );
      end // block: status_ram

      wire [RAM_WIDTH-1:0] rd_buf_out_data;
      begin : rd_buf
        wire [RAM_WIDTH-1:0] rd_buf_in_data;
        if (REMAINDER == 0)
          if (ECC == "OFF")
            assign rd_buf_in_data = rd_data;
          else
            assign rd_buf_in_data = {ecc_single, ecc_multiple, rd_data};
        else
          if (ECC == "OFF")
            assign rd_buf_in_data = {{6-REMAINDER{1'b0}}, rd_data};
          else
            assign rd_buf_in_data = 
              {{6-REMAINDER{1'b0}}, ecc_single, ecc_multiple, rd_data};

        // Dedicated copy for driving distributed RAM.
        (* keep = "true" *) reg [4:0] rd_buf_indx_copy_r /* synthesis syn_keep = 1 */;
        always @(posedge clk) rd_buf_indx_copy_r <= #TCQ rd_buf_indx_ns[4:0];

        genvar i;
        for (i=0; i<RAM_CNT; i=i+1) begin : rd_buffer_ram
          RAM32M
            #(.INIT_A(64'h0000000000000000),
              .INIT_B(64'h0000000000000000),
              .INIT_C(64'h0000000000000000),
              .INIT_D(64'h0000000000000000)
          ) RAM32M0 (
              .DOA(rd_buf_out_data[((i*6)+4)+:2]),
              .DOB(rd_buf_out_data[((i*6)+2)+:2]),
              .DOC(rd_buf_out_data[((i*6)+0)+:2]),
              .DOD(),
              .DIA(rd_buf_in_data[((i*6)+4)+:2]),
              .DIB(rd_buf_in_data[((i*6)+2)+:2]),
              .DIC(rd_buf_in_data[((i*6)+0)+:2]),
              .DID(2'b0),
              .ADDRA(rd_buf_indx_copy_r[4:0]),
              .ADDRB(rd_buf_indx_copy_r[4:0]),
              .ADDRC(rd_buf_indx_copy_r[4:0]),
              .ADDRD(rd_buf_wr_addr),
              .WE(rd_buf_we),
              .WCLK(clk)
             );
        end // block: rd_buffer_ram
      end

      wire rd_data_rdy = (rd_status[0] == rd_buf_indx_r[5]);
 wire bypass = rd_data_en && (rd_buf_wr_addr[4:0] == rd_buf_indx_r[4:0]) /* synthesis syn_maxfan = 10 */;
      assign app_rd_data_valid_ns =
              ram_init_done_r_lcl && (bypass || rd_data_rdy);
      wire app_rd_data_end_ns = bypass ? rd_data_end : rd_status[1];
      always @(posedge clk) app_rd_data_valid <= #TCQ app_rd_data_valid_ns;
      always @(posedge clk) app_rd_data_end <= #TCQ app_rd_data_end_ns;

      assign single_data =
          app_rd_data_valid_ns && app_rd_data_end_ns && ~rd_buf_indx_r[0];

      wire [APP_DATA_WIDTH-1:0] app_rd_data_ns =
                              bypass
                                ? rd_data
                                : rd_buf_out_data[APP_DATA_WIDTH-1:0];
      always @(posedge clk) app_rd_data <= #TCQ app_rd_data_ns;
      if (ECC != "OFF") begin : assign_app_ecc_multiple
        wire [(2*nCK_PER_CLK)-1:0] app_ecc_multiple_err_ns =
                              bypass
                                ? ecc_multiple
                                : rd_buf_out_data[APP_DATA_WIDTH+:(2*nCK_PER_CLK)];
        always @(posedge clk) app_ecc_multiple_err_r <= 
                                #TCQ app_ecc_multiple_err_ns;
      end
      if (ECC != "OFF") begin : assign_app_ecc_single
        wire [(2*nCK_PER_CLK)-1:0] app_ecc_single_err_ns =
                              bypass
                                ? ecc_single
                                : rd_buf_out_data[(APP_DATA_WIDTH+(2*nCK_PER_CLK))+:(2*nCK_PER_CLK)];
        always @(posedge clk) app_ecc_single_err_r <= 
                                #TCQ app_ecc_single_err_ns;
      end

      //Added to fix timing. The signal app_rd_data_valid has 
      //a very high fanout. So making a dedicated copy for usage
      //with the occ_cnt counter.
      (* equivalent_register_removal = "no" *)
      reg app_rd_data_valid_copy;
      always @(posedge clk) app_rd_data_valid_copy <= #TCQ app_rd_data_valid_ns;
// Keep track of how many entries in the queue hold data.
      wire free_rd_buf = app_rd_data_valid_copy && app_rd_data_end; //changed to use registered version
                                                                    //of the signals in ordered to fix timing
      reg [DATA_BUF_ADDR_WIDTH:0] occ_cnt_r;
      wire [DATA_BUF_ADDR_WIDTH:0] occ_minus_one = occ_cnt_r - 1;
      wire [DATA_BUF_ADDR_WIDTH:0] occ_plus_one = occ_cnt_r + 1;
      begin : occupied_counter
        reg [DATA_BUF_ADDR_WIDTH:0] occ_cnt_ns;
        always @(/*AS*/free_rd_buf or occ_cnt_r or rd_accepted or rst or occ_minus_one or occ_plus_one) begin
          occ_cnt_ns = occ_cnt_r;
          if (rst) occ_cnt_ns = 0;
          else case ({rd_accepted, free_rd_buf})
                 2'b01 : occ_cnt_ns = occ_minus_one;
                 2'b10 : occ_cnt_ns = occ_plus_one;
          endcase // case ({wr_data_end, new_rd_data})
        end
        always @(posedge clk) occ_cnt_r <= #TCQ occ_cnt_ns;
        assign rd_buf_full = occ_cnt_ns[DATA_BUF_ADDR_WIDTH];

`ifdef MC_SVA
  rd_data_buffer_full: cover property (@(posedge clk) (~rst && rd_buf_full));
  rd_data_buffer_inc_dec_15: cover property (@(posedge clk)
         (~rst && rd_accepted && free_rd_buf && (occ_cnt_r == 'hf)));
  rd_data_underflow: assert property (@(posedge clk)
         (rst || !((occ_cnt_r == 'b0) && (occ_cnt_ns == 'h1f))));
  rd_data_overflow: assert property (@(posedge clk)
         (rst || !((occ_cnt_r == 'h10) && (occ_cnt_ns == 'h11))));
`endif
    end // block: occupied_counter


// Generate the data_buf_address written into the memory controller
// for reads.  Increment with each accepted read, and rollover at 0xf.
      reg [DATA_BUF_ADDR_WIDTH-1:0] rd_data_buf_addr_r_lcl;
      assign rd_data_buf_addr_r = rd_data_buf_addr_r_lcl;
      begin : data_buf_addr
        reg [DATA_BUF_ADDR_WIDTH-1:0] rd_data_buf_addr_ns;
        always @(/*AS*/rd_accepted or rd_data_buf_addr_r_lcl or rst) begin
          rd_data_buf_addr_ns = rd_data_buf_addr_r_lcl;
          if (rst) rd_data_buf_addr_ns = 0;
          else if (rd_accepted) rd_data_buf_addr_ns =
                                  rd_data_buf_addr_r_lcl + 1;
        end
        always @(posedge clk) rd_data_buf_addr_r_lcl <=
                                #TCQ rd_data_buf_addr_ns;
      end // block: data_buf_addr
    end // block: not_strict_mode
  endgenerate

endmodule // ui_rd_data

// Local Variables:
// verilog-library-directories:(".")
// End:

