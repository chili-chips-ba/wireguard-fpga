// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description:
//   Bus Functional Model (BFM) for Egress Routing Table configuration.
//   This module acts as a management controller/CPU that populates the
//   hardware routing table via a CSR (Control & Status Register) interface.
//
//   Key capabilities:
//     - Manages a high-level queue of route objects (IP, Netmask, Prefix,
//       Port, Peer ID).
//     - Performs automatic software-side sorting based on Prefix Length
//       to ensure correct Longest Prefix Match (LPM) hardware behavior.
//     - Automatically inserts a default route (0.0.0.0/0).
//
//   Parameters:
//     - ENTRY_COUNT: Number of hardware routing entries (default: 64).
//==========================================================================

`timescale 1ns / 1ps

module bfm_egress #(
  parameter int ENTRY_COUNT = 64
)(
  input  logic                        clk,
  input  logic                        rst,
  
  output csr_pkg::csr__dpe__routing_table__external__out_t csr_req [ENTRY_COUNT],
  input  csr_pkg::csr__dpe__routing_table__external__in_t  csr_rsp [ENTRY_COUNT]
);

  import csr_pkg::*;

  typedef struct {
     logic [31:0] ip_addr;
     logic [31:0] netmask;
     int          prefix_len;
     logic [2:0]  dst_port;
     logic [7:0]  peer_id;
  } route_t;

  // Route queue
  route_t route_queue[$];

  // -----------------------------------------------------------------------
  // Helper Functions
  // -----------------------------------------------------------------------
  function automatic logic [31:0] mask_from_len (int n);
    if (n <= 0)        return 32'h0;
    else if (n >= 32)  return 32'hFFFF_FFFF;
    else               return ~((32'hFFFF_FFFF >> n));
  endfunction

  function automatic logic [31:0] ip (int a, int b, int c, int d);
    return {a[7:0], b[7:0], c[7:0], d[7:0]};
  endfunction

  // -----------------------------------------------------------------------
  // Low-level CSR Write Task (Synchronous)
  // -----------------------------------------------------------------------
  task automatic csr_write_word(input logic [31:0] global_addr, input logic [31:0] data);
    int idx;
    logic [3:0] offset;
    begin
      idx    = global_addr >> 4;   
      offset = global_addr[3:0];   

      if (idx >= ENTRY_COUNT) begin
         $error("[BFM] Error: Address out of bounds");
         return;
      end

      // Setup Request
      csr_req[idx].addr      <= offset;
      csr_req[idx].wr_data   <= data;
      csr_req[idx].req_is_wr <= 1'b1;
      csr_req[idx].wr_biten  <= 32'hFFFFFFFF; 
      csr_req[idx].req       <= 1'b1;         

      // Wait for ACK (Hardware Handshake)
      while (csr_rsp[idx].wr_ack === 1'b0) begin
        @(posedge clk);
      end

      // Cleanup
      csr_req[idx].req       <= 1'b0;
      csr_req[idx].req_is_wr <= 1'b0;
      csr_req[idx].wr_data   <= 32'd0;
      csr_req[idx].wr_biten  <= 32'd0;
      
      @(posedge clk); 
    end
  endtask

  // -----------------------------------------------------------------------
  // High-level Abstraction
  // -----------------------------------------------------------------------
  task automatic write_entry_to_hw (input int idx, input route_t r); 
    logic [31:0] base_addr;
    begin
      base_addr = idx * 16; 

      // Write MASK (offset 4)
      csr_write_word(base_addr + 4, r.netmask);
      
      // Write PEER (offset 8)
      csr_write_word(base_addr + 8, {24'd0, r.peer_id});

      // Write DST (offset 12)
      csr_write_word(base_addr + 12, {29'd0, r.dst_port});

      // Write PREFIX (offset 0)
      csr_write_word(base_addr + 0, r.ip_addr);
    end
  endtask

  function void add_route(int a, int b, int c, int d, int len, int dst, int peer);
     route_t r;
     r.ip_addr    = ip(a,b,c,d);
     r.prefix_len = len;
     r.netmask    = mask_from_len(len);
     r.dst_port   = dst[2:0];
     r.peer_id    = peer[7:0];
     
     route_queue.push_back(r);
  endfunction

  initial begin
    bit has_default_route;

    // 1. Initialize signals to zero
    for(int k=0; k<ENTRY_COUNT; k++) begin
       csr_req[k].req       = 1'b0;
       csr_req[k].req_is_wr = 1'b0;
       csr_req[k].addr      = 4'd0;
       csr_req[k].wr_data   = 32'd0;
       csr_req[k].wr_biten  = 32'd0;
    end

    wait(rst == 0);
    repeat(100) @(posedge clk);

    // ---------------------------------------------------------
    // ROUTE DEFINITION (Insertion order is irrelevant due to sorting)
    // ---------------------------------------------------------

    add_route(192, 168, 152, 1,  32,  2, 20); // Node 2
    add_route(192, 168, 1,   4,  32,  4, 40); // Node 4

    add_route(10, 0, 0, 0,       8,   1, 100);
    add_route(10, 10, 0, 0,      16,  2, 101);
    add_route(10, 10, 10, 10,    32,  3, 102);

    add_route(172, 16, 0, 0,     12,  2, 110);
    add_route(192, 168, 50, 0,   24,  1, 111);
    add_route(8, 8, 8, 8,        32,  4, 200);
    add_route(1, 1, 1, 1,        32,  4, 201);
    
    add_route(224, 0, 0, 0,      4,   3, 210);

    add_route(50, 50, 50, 0,     24,  1, 220);
    add_route(60, 0, 0, 0,       8,   2, 221);
    add_route(70, 70, 0, 0,      16,  3, 222);
    add_route(80, 80, 80, 80,    32,  4, 223);
    add_route(200, 100, 50, 25,  32,  1, 224);

    // ---------------------------------------------------------
    // AUTOMATIC DEFAULT ROUTE
    // ---------------------------------------------------------
    has_default_route = 0;
    foreach(route_queue[i]) begin
        if (route_queue[i].prefix_len == 0) has_default_route = 1;
    end

    if (!has_default_route) begin
        add_route(0, 0, 0, 0, 0, 1, 255);
    end

    // ---------------------------------------------------------
    // SORTING
    // ---------------------------------------------------------
    route_queue.rsort(x) with (x.prefix_len);
    
    $display("[BFM] Sorted %0d routes. Writing to hardware...", route_queue.size());

    // ---------------------------------------------------------
    // WRITE TO HARDWARE
    // ---------------------------------------------------------
    foreach(route_queue[i]) begin
      $display("[BFM] Writing Index %0d: IP %h / %0d -> Port %0d", i, route_queue[i].ip_addr, route_queue[i].prefix_len, route_queue[i].dst_port);
      write_entry_to_hw(i, route_queue[i]);
    end

    $display("[BFM] Table population complete.");
  end

endmodule

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2025/12/7 IV: original creation
*/
