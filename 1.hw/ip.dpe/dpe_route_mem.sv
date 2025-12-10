//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Data Plane Engine (DPE) Routing Memory (TCAM & RAM).
//   Stores IPv4 routing rules (Prefix, Mask) and actions (Destination, Peer).
//   
//   Architecture:
//   - Implements a TCAM-like structure for parallel IP lookup.
//   - Uses a Priority Encoder logic (First Match Wins).
//   - Relies on software/driver to sort entries by Longest Prefix Match (LPM),
//     where the most specific route is at Index 0.
//==========================================================================
`timescale 1ns/1ps

module dpe_route_mem #(
  parameter int ENTRY_COUNT     = 64,
  parameter int ROUTE_IDX_W     = $clog2(ENTRY_COUNT),
  parameter logic [2:0]  DEFAULT_DST_PORT = 3'd0,
  parameter logic [7:0]  DEFAULT_PEER_IDX = 8'd0,
  parameter bit          DEFAULT_BYPASS   = 1'b0
) (
  input  logic                     clk,
  input  logic                     rst,

  // Write Interface
  input  logic [ROUTE_IDX_W-1:0]   waddr,
  input  logic                     we_prefix,
  input  logic [31:0]              wdata_prefix,
  input  logic                     we_mask,
  input  logic [31:0]              wdata_mask,
  input  logic                     we_peer,
  input  logic [7:0]               wdata_peer,
  input  logic                     we_dst,
  input  logic [2:0]               wdata_dst,

  // Read Interface
  input  logic [ROUTE_IDX_W-1:0]   raddr,
  output logic [31:0]              rdata_prefix,
  output logic [31:0]              rdata_mask,
  output logic [7:0]               rdata_peer,
  output logic [2:0]               rdata_dst,

  // Lookup Interface
  input  logic [31:0]              req_ip,
  input  logic                     req_valid,     
  output logic                     resp_hit,
  output logic [ROUTE_IDX_W-1:0]   resp_route_idx,
  output logic [2:0]               resp_dst,
  output logic [7:0]               resp_peer,
  output logic                     resp_bypass
);

  // Debug signals
  logic [31:0] debug_mask_0;
  logic [31:0] debug_mask_1;
  
  // Storage arrays
  logic [31:0] cam_prefix [ENTRY_COUNT];
  logic [31:0] cam_mask   [ENTRY_COUNT];
  

  logic [2:0]  ram_dst    [ENTRY_COUNT];
  logic [7:0]  ram_peer   [ENTRY_COUNT];
  logic        ram_bypass [ENTRY_COUNT];

  assign debug_mask_0 = cam_mask[0];
  assign debug_mask_1 = cam_mask[1];

  // ---------------------------
  // WRITE LOGIC
  // ---------------------------
  always_ff @(posedge clk) begin
    if (we_prefix) cam_prefix[waddr] <= wdata_prefix;
    if (we_mask)   cam_mask  [waddr] <= wdata_mask;       
    if (we_peer)   ram_peer  [waddr] <= wdata_peer;
    if (we_dst)    ram_dst   [waddr] <= wdata_dst;
  end

  // ---------------------------
  // READ LOGIC
  // ---------------------------
  always_ff @(posedge clk) begin
    rdata_prefix <= cam_prefix[raddr];
    rdata_mask   <= cam_mask  [raddr];
    rdata_peer   <= ram_peer  [raddr];
    rdata_dst    <= ram_dst   [raddr];
  end

  // ---------------------------
  // LOOKUP LOGIC (Priority Encoder)
  // ---------------------------
  logic [ENTRY_COUNT-1:0] hit_vec;

  genvar k;
  generate
    for (k = 0; k < ENTRY_COUNT; k++) begin : GEN_CAM_MATCH
      assign hit_vec[k] = ((req_ip & cam_mask[k]) == (cam_prefix[k] & cam_mask[k]));
    end
  endgenerate

  logic [ROUTE_IDX_W-1:0] best_idx;
  logic                   hit_found;
  integer i;

  always_comb begin
    best_idx  = '0;
    hit_found = 1'b0;

    for (i = 0; i < ENTRY_COUNT; i++) begin
      if (hit_vec[i]) begin
        if (!hit_found) begin 
            hit_found = 1'b1;
            best_idx  = i[ROUTE_IDX_W-1:0];
        end
      end
    end
  end

  assign resp_hit       = hit_found;
  assign resp_route_idx = hit_found ? best_idx : '0;
  
  assign resp_dst       = hit_found ? ram_dst[best_idx]    : DEFAULT_DST_PORT;
  assign resp_peer      = hit_found ? ram_peer[best_idx]   : DEFAULT_PEER_IDX;
  assign resp_bypass    = hit_found ? ram_bypass[best_idx] : DEFAULT_BYPASS;

endmodule

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2025/12/7 IV: original creation
*/