// -- (c) Copyright 2013 Xilinx, Inc. All rights reserved. 
// --                                                             
// -- This file contains confidential and proprietary information 
// -- of Xilinx, Inc. and is protected under U.S. and             
// -- international copyright and other intellectual property     
// -- laws.                                                       
// --                                                             
// -- DISCLAIMER                                                  
// -- This disclaimer is not a license and does not grant any     
// -- rights to the materials distributed herewith. Except as     
// -- otherwise provided in a valid license issued to you by      
// -- Xilinx, and to the maximum extent permitted by applicable   
// -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND     
// -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES 
// -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING   
// -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-      
// -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and    
// -- (2) Xilinx shall not be liable (whether in contract or tort,
// -- including negligence, or under any other theory of          
// -- liability) for any loss or damage of any kind or nature     
// -- related to, arising under or in connection with these       
// -- materials, including for any direct, or any indirect,       
// -- special, incidental, or consequential loss or damage        
// -- (including loss of data, profits, goodwill, or any type of  
// -- loss or damage suffered as a result of any action brought   
// -- by a third party) even if such damage or loss was           
// -- reasonably foreseeable or Xilinx had been advised of the    
// -- possibility of the same.                                    
// --                                                             
// -- CRITICAL APPLICATIONS                                       
// -- Xilinx products are not designed or intended to be fail-    
// -- safe, or for use in any application requiring fail-safe     
// -- performance, such as life-support or safety devices or      
// -- systems, Class III medical devices, nuclear facilities,     
// -- applications related to the deployment of airbags, or any   
// -- other applications that could lead to death, personal       
// -- injury, or severe property or environmental damage          
// -- (individually and collectively, "Critical                   
// -- Applications"). Customer assumes the sole risk and          
// -- liability of any use of Xilinx products in Critical         
// -- Applications, subject only to applicable laws and           
// -- regulations governing limitations on product liability.     
// --                                                             
// -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS    
// -- PART OF THIS FILE AT ALL TIMES.                             
// --  
///////////////////////////////////////////////////////////////////////////////
//
// File name: axi_mc_b_channel.v
//
// Description: 
// This module is responsible for returning the write response to the master
// that initiated the write.  The write address channel module will push the
// transaction ID into a FIFO in the write response module after the
// completion of the address write phase of the transaction.   If strict
// coherency is enabled (C_STRICT_COHERENCY == 1), then this module will
// monitor the MCB command/write FIFOs to determine when to send back the
// response.  It will not send the response until it is guaranteed that the
// write has been committed completely to memory.
// 
// ERROR RESPONSE
// If the MCB write channel indicates there is an error or write FIFO under
// run then the AXI SLVERR response is returned otherwise the OKAY response
// is returned.
//
// WRITE COHERENCY CHECKING
// The MCB hard block can have up to 6 independent ports to memory.  If the
// MCB block is configured as single port or as multi-port with separate
// regions then write coherency logic is not required.  In all other cases,
// once a transaction has been sent to the MCB CMD channel, it is not
// guaranteed that it will commit to memory before a transaction on another
// port.  To ensure that the response is only sent after the data has been
// written to external memory the write response will not be sent until
// either the write data FIFO is empty or that the command FIFO is empty.
//
// Assertions: 
// 1. Standard FIFO assertions on bid_fifo_0.
// 2. bvalid == 0, when C_STRICT_COHERENCY == 1 and mcb_empty == 0.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
`default_nettype none

module mig_7series_v4_2_axi_mc_b_channel #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
                    // Width of ID signals.
                    // Range: >= 1.
  parameter integer C_ID_WIDTH                = 4 
                    
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations     
///////////////////////////////////////////////////////////////////////////////
  input  wire                                 clk,
  input  wire                                 reset,

  // AXI signals
  output wire [C_ID_WIDTH-1:0]                bid,
  output wire [1:0]                           bresp,
  output wire                                 bvalid,
  input  wire                                 bready,

  // Signals to/from the axi_mc_aw_channel modules
  input  wire                                 b_push,
  input  wire [C_ID_WIDTH-1:0]                b_awid,
  input  wire                                 b_resp_rdy,
  output wire                                 b_full

);

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
// FIFO settings
localparam P_WIDTH  = C_ID_WIDTH;
localparam P_DEPTH  = 8;
localparam P_AWIDTH = 3;
// AXI protocol responses:
localparam P_OKAY   = 2'b00;
localparam P_EXOKAY = 2'b01;
localparam P_SLVERR = 2'b10;
localparam P_DECERR = 2'b11;

localparam B_RESP_PERF = 1'b1; 	// Set to 1 to increase the write response performance for back to back single beats.
				// Set to 0 in case of timing issues, but performance degrades for back to back single beats.
wire                    empty;
wire                    bhandshake;
wire [C_ID_WIDTH-1:0]   bid_i;

reg                     b_pop;
reg                     bvalid_i;
reg  [C_ID_WIDTH-1:0]   bid_t;

assign bresp      = P_OKAY;

generate
  if (B_RESP_PERF == 1) begin
  
    assign bid        = bid_t;
    assign bvalid     = bvalid_i;
    assign bhandshake  = ~bvalid | bready;
    
    always @(*)
      b_pop = bhandshake & ~empty;
    
    always @(posedge clk) begin
      if(reset) begin
        bid_t <= 'b0;
        bvalid_i <= 1'b0;
      end else if(bhandshake) begin
        bid_t <= bid_i;
        bvalid_i <= ~empty;
      end
    end
  
  end else begin // B_RESP_PERF
  
    assign bid        = bid_i;
    assign bvalid     = bvalid_i;
    assign bhandshake = bvalid & bready;
    
    always @(posedge clk)
      b_pop <= bhandshake;
       
    always @(posedge clk) begin
      if (reset | bhandshake) begin
        bvalid_i <= 1'b0;
      end else if (~empty & (~b_pop)) begin
        bvalid_i <= 1'b1;
      end
    end
    
  end // B_RESP_PERF
endgenerate

mig_7series_v4_2_axi_mc_fifo #
  (
  .C_WIDTH                  (P_WIDTH),
  .C_AWIDTH                 (P_AWIDTH),
  .C_DEPTH                  (P_DEPTH)
)
bid_fifo_0
(
  .clk     ( clk        ) ,
  .rst     ( reset      ) ,
  .wr_en   ( b_push     ) ,
  .rd_en   ( b_pop      ) ,
  .din     ( b_awid     ) ,
  .dout    ( bid_i      ) ,
  .a_full  (            ) ,
  .full    ( b_full     ) ,
  .a_empty (            ) ,
  .empty   ( empty      ) 
);

endmodule

`default_nettype wire

