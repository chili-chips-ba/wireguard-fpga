// -----------------------------------------------------------------------------
//  Title      : Veriog memory model for simulations
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : mem_model.v
//  Author     : Simon Southwell
//  Created    : 2021-08-01
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is a Verilog wrapper around a C/C++ based memory model with
//  various style memory ports, for use in simulations. The full 32 bit address
//  space is available, with the underlying model dynamically allocating memory
//  blocks as they are accessed. It accesses the underlying C model via the
//  Verilog PLI interface.
// -----------------------------------------------------------------------------
//  Copyright (c) 2021 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation(), either version 3 of the License(), or
//  (at your option) any later version.
//
//  It is distributed in the hope that it will be useful(),
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------

`ifdef MEM_MODEL_SV
`include "mem_model_dpi.vh"

`define MEMREAD               MemRead
`define MEMWRITE              MemWrite

`else

`timescale 1ps/1ps

`define MEMREAD               $memread
`define MEMWRITE              $memwrite

`endif

module mem_model
#(parameter
  EN_READ_QUEUE                = 0,
  REG_READ_OVERLAP             = 0
)
(
  input                        clk,
  input                        rst_n,

  // Register style slave interface
  input      [31:0]            address,
  input                        write,
  input      [31:0]            writedata,
  input       [3:0]            byteenable,
  input                        read,
  output reg [31:0]            readdata,
  output reg                   readdatavalid,

  // Burst read style slave interface
  output                       rx_waitrequest,
  input      [11:0]            rx_burstcount,
  input      [31:0]            rx_address,
  input                        rx_read,
  output reg [31:0]            rx_readdata,
  output reg                   rx_readdatavalid,
  
`ifdef MEM_MODEL_STALL_RX
  input                        rx_stall,
`endif

  // Burst write style slave interface
  output reg                   tx_waitrequest,
  input      [11:0]            tx_burstcount,
  input      [31:0]            tx_address,
  input                        tx_write,
  input      [31:0]            tx_writedata,

`ifdef MEM_EN_TX_BYTEENABLE
  input       [3:0]            tx_byteenable,
`endif

  // SRAM style write port
  input                        wr_port_valid,
  input      [31:0]            wr_port_data,
  input      [31:0]            wr_port_addr

  );

// ----------------------------------------------------------------------------
// Registers
// ----------------------------------------------------------------------------

reg          [31:0]            rx_count;
reg          [31:0]            rd_addr;
reg          [31:0]            tx_count;
reg          [31:0]            wr_addr;
reg          [31:0]            readdata_int;

reg                            rx_readdatavalid_int;
reg          [31:0]            rx_readdata_int;
reg                            rx_waitrequest_int;
reg                            next_rx_waitrequest_int;

// ----------------------------------------------------------------------------
// Signal declarations
// ----------------------------------------------------------------------------

wire                           rx_read_q;
wire         [11:0]            rx_burstcount_q;
wire         [31:0]            rx_address_q;

wire                           q_full;
wire                           q_empty;

`ifndef MEM_EN_TX_BYTEENABLE
wire          [3:0]            tx_byteenable = 4'hf;
`endif

`ifndef MEM_MODEL_STALL_RX
wire                           rx_stall = 1'b0;
`endif
// ----------------------------------------------------------------------------
// Read Command Queue
// ----------------------------------------------------------------------------

generate
if (EN_READ_QUEUE != 0)
begin
  mem_model_q
  #(
    .DEPTH                     (8),
    .WIDTH                     (32+12)
  ) mem_model_q_i
  (
    .clk                       (clk),
    .reset_n                   (rst_n),

    .clr                       (1'b0),

    .write                     (rx_read),
    .wdata                     ({rx_burstcount, rx_address}),

    .read                      (rx_read_q & ~rx_waitrequest_int),
    .rdata                     ({rx_burstcount_q, rx_address_q}),

    .empty                     (q_empty),
    .full                      (q_full),
    .nearly_full               ()
  );

  assign rx_read_q             = ~q_empty;
  assign rx_waitrequest        = q_full;
end
else
begin

  // When not using a read command queue, wire the input command put straight through
  assign rx_read_q             = rx_read;
  assign rx_burstcount_q       = rx_burstcount;
  assign rx_address_q          = rx_address;
  assign rx_waitrequest        = rx_waitrequest_int;
end
endgenerate


// ----------------------------------------------------------------------------
// Synchronous Logic
// ----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0)
  begin

    rx_count                   <= 32'h00000000;
    rd_addr                    <= 32'h00000000;

    tx_count                   <= 32'h00000000;
    wr_addr                    <= 32'h00000000;

    tx_waitrequest             <= 1'b0;
    rx_waitrequest_int         <= 1'b0;
    rx_readdatavalid           <= 1'b0;
    rx_readdatavalid_int       <= 1'b0;
    next_rx_waitrequest_int    <= 1'b0;

    readdata                   <= 32'h00000000;
    readdatavalid              <= 1'b0;
  end
  else
  begin

    // Default some of the outputs
    readdata                   = 32'h00000000;

    // Update the output valid signal with that calculated last cycle
    rx_readdatavalid           = rx_readdatavalid_int;

    // read data is valid (internally) whenever the RX counter is non-zero
    rx_readdatavalid_int       = rx_count != 32'h00000000;

    // Update RX bus output with value calculated from last cycle
    rx_readdata                = rx_readdata_int;

    // Internal read data is updated from that fetched from model last cycle.
    rx_readdata_int            = readdata_int;
    
    rx_waitrequest_int         = next_rx_waitrequest_int;

    // If a slave read, return memory contents
    if (read == 1'b1 && (readdatavalid == 1'b0 || REG_READ_OVERLAP))
    begin
      `MEMREAD(address, readdata, byteenable);
      readdatavalid            = 1'b1;
    end
    else
    begin
      readdatavalid            = 1'b0;
    end

    @(negedge clk);

    // If a slave write, update memory
    if (write == 1'b1)
    begin
      `MEMWRITE(address, writedata, byteenable);
    end

    // If a new master read request comes in (and not active),
    // latch the rx_count and address values
    if (rx_read_q == 1'b1 && rx_waitrequest_int == 1'b0)
    begin
       // Load RX count with burst + 1 as we are going to decrement it immediately
       rx_count                = rx_burstcount_q + 1;
       rd_addr                 = rx_address_q;
    end

    // If a new master write request comes in (and not active), latch the tx_count and address values
    if (tx_write == 1'b1 && tx_waitrequest == 1'b0 && tx_count == 0)
    begin
       tx_count                = tx_burstcount;
       wr_addr                 = tx_address;
    end
    
    if (tx_count == 32'h00000000 && rx_count <= 32'h00000001)
    begin
      next_rx_waitrequest_int  = 1'b0;
    end
    else
    begin
      next_rx_waitrequest_int  = 1'b1;
    end

    if (rx_count == 32'h00000000 || tx_count != 32'h00000000)
    begin
      tx_waitrequest           = 1'b0;
    end
    else
    begin
      tx_waitrequest           = 1'b1;
    end

    // If an active read transfer in progress, transfer data
    if (rx_count != 32'h00000000 && rx_stall == 1'b0)
    begin

      `MEMREAD(rd_addr, readdata_int, byteenable);

      // Decrement the word count
      rx_count                 = rx_count - 32'h00000001;

      // Increment the read address
      rd_addr                  = rd_addr  + 32'h00000004;

    end

    // If an active write transfer in progress, transfer data
    if (tx_write == 1'b1 && tx_waitrequest == 1'b0 && tx_count != 32'h00000000)
    begin
      `MEMWRITE(wr_addr, tx_writedata, tx_byteenable);

      // Decrement the word count
      tx_count                 = tx_count - 32'h00000001;

      // Increment the write address
      wr_addr                  = wr_addr  + 32'h00000004;

    end

    // If a write port access valid, write data
    if (wr_port_valid == 1'b1)
    begin
      `MEMWRITE(wr_port_addr, wr_port_data, byteenable);
    end
  end
end

endmodule