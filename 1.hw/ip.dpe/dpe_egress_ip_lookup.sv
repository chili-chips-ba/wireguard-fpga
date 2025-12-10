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
//   Egress IP Lookup module for WireGuard Data Plane.
//
//   Functionality:
//   1. Control Plane: Acts as a bridge between the CSR interface and the internal 
//      Routing Memory (`dpe_route_mem`). Handles address decoding/multiplexing
//      for writing and reading routing rules.
//
//   2. Data Plane: Parses incoming AXI Stream packets to extract the IPv4 
//      Destination Address. Uses a store-and-forward mechanism (beat buffer) 
//      to hold data while performing the routing table lookup.
//
//   3. Routing Action: Updates the outgoing AXI Stream sideband signals 
//      (tuser_dst, tid/peer_id) based on the lookup result, directing the 
//      packet to the correct physical port and associating it with a Peer.
//==========================================================================

`timescale 1ns/1ps

module dpe_egress_ip_lookup #(
  parameter int ENTRY_COUNT = 64,
  parameter bit USE_BYPASS_FROM_MEM = 1'b0
) (
  dpe_if.s_axis  s_axis,
  dpe_if.m_axis  m_axis,

  input  csr_pkg::csr__dpe__routing_table__external__out_t hwif_out [ENTRY_COUNT], 
  output csr_pkg::csr__dpe__routing_table__external__in_t  hwif_in  [ENTRY_COUNT]
);

  logic        req;
  logic        is_wr;
  logic [31:0] wr_data;
  logic [3:0]  addr_offset;
  logic [5:0]  mem_idx;

  logic we_prefix, we_mask, we_peer, we_dst;
  logic [31:0] rdata_prefix, rdata_mask;
  logic [7:0]  rdata_peer;
  logic [2:0]  rdata_dst;

  // -----------------------------------------------------------
  // INPUT MULTIPLEXER
  // -----------------------------------------------------------  
  always_comb begin
    req         = 1'b0;
    is_wr       = 1'b0;
    wr_data     = 32'd0;
    addr_offset = 4'd0;
    mem_idx     = 6'd0;

    for (int i = 0; i < ENTRY_COUNT; i++) begin
       if (hwif_out[i].req) begin
          req         = 1'b1;
          is_wr       = hwif_out[i].req_is_wr;
          wr_data     = hwif_out[i].wr_data;
          addr_offset = hwif_out[i].addr; 
          mem_idx     = i[5:0];
       end
    end
  end

  // -----------------------------------------------------------
  // OUTPUT DEMULTIPLEXER
  // -----------------------------------------------------------
  generate
    genvar k;
    for (k = 0; k < ENTRY_COUNT; k++) begin : GEN_RESP
       assign hwif_in[k].wr_ack = (mem_idx == k) ? (req && is_wr)  : 1'b0;
       assign hwif_in[k].rd_ack = (mem_idx == k) ? (req && !is_wr) : 1'b0;
       
       always_comb begin
          hwif_in[k].rd_data = 32'd0;
          if (mem_idx == k) begin
             case (addr_offset[3:2]) // Offset 0, 4, 8, C
                2'b00: hwif_in[k].rd_data = rdata_prefix;
                2'b01: hwif_in[k].rd_data = rdata_mask;
                2'b10: hwif_in[k].rd_data = {24'd0, rdata_peer};
                2'b11: hwif_in[k].rd_data = {29'd0, rdata_dst};
             endcase
          end
       end
    end
  endgenerate

  // -----------------------------------------------------------
  // WRITING TO MEMORY
  // -----------------------------------------------------------
  always_comb begin
    we_prefix = 1'b0; we_mask = 1'b0; we_peer = 1'b0; we_dst = 1'b0;
    
    if (req && is_wr) begin
      case (addr_offset[3:2])
        2'b00: begin we_prefix = 1'b1; end
        2'b01: we_mask   = 1'b1;
        2'b10: we_peer   = 1'b1;
        2'b11: we_dst    = 1'b1;
      endcase
    end
  end
  
  logic        route_hit;
  logic [5:0]  route_idx;
  logic [2:0]  route_dst;
  logic [7:0]  route_peer;
  logic        route_bypass;
  logic [31:0] route_req_ip;
  logic        route_req_valid;

  dpe_route_mem #(
    .ENTRY_COUNT(ENTRY_COUNT)
  ) u_mem (
    .clk        (s_axis.clk),
    .rst        (s_axis.rst),

    .waddr      (mem_idx),
    .we_prefix  (we_prefix), .wdata_prefix(wr_data),
    .we_mask    (we_mask),   .wdata_mask (wr_data),
    .we_peer    (we_peer),   .wdata_peer (wr_data[7:0]),
    .we_dst     (we_dst),    .wdata_dst  (wr_data[2:0]),

    .raddr      (mem_idx),
    .rdata_prefix(rdata_prefix), .rdata_mask(rdata_mask),
    .rdata_peer(rdata_peer),     .rdata_dst(rdata_dst),

    .req_ip     (route_req_ip),
    .req_valid  (route_req_valid),
    .resp_hit   (route_hit),
    .resp_route_idx(route_idx),
    .resp_dst   (route_dst),
    .resp_peer  (route_peer),
    .resp_bypass(route_bypass)
  );

  // --------------------------------------------------------------------------
  // 3. DATA PLANE LOGIC (Packet Processing FSM)
  // --------------------------------------------------------------------------

  typedef enum logic [2:0] {S_IDLE, S_COLLECT, S_DECIDE, S_FLUSH, S_FWD} state_e;
  state_e state, state_next;

  logic [1:0]  beat;          
  logic [31:0] ipv4_da;

  typedef struct packed {
    logic [127:0] data;
    logic [15:0]  keep;
    logic         last;
    logic         valid;
  } beat_t;

  beat_t beat_buf[0:2];
  logic [1:0] buf_rd_ptr;

  logic [2:0] decided_dst, decided_dst_n;
  logic [7:0] decided_peer, decided_peer_n;
  logic       decided_bypass, decided_bypass_n;

  logic [1:0] flush_limit, flush_limit_n;

  logic in_hs;
  assign in_hs = s_axis.tvalid && s_axis.tready;

  always_comb begin
    unique case (state)
      S_IDLE,
      S_COLLECT:  s_axis.tready = 1'b1;                
      S_DECIDE,
      S_FLUSH:    s_axis.tready = 1'b0;                
      S_FWD:      s_axis.tready = m_axis.tready;       
      default:    s_axis.tready = 1'b0;
    endcase
  end

  always_comb begin
    state_next        = state;
    decided_dst_n     = decided_dst;
    decided_peer_n    = decided_peer;
    decided_bypass_n  = decided_bypass;
    flush_limit_n     = flush_limit;
    route_req_valid   = 1'b0;

    case (state)
      S_IDLE: begin
        if (in_hs) begin
          if (s_axis.tuser_bypass_all) begin
            decided_dst_n     = s_axis.tuser_dst;
            decided_peer_n    = s_axis.tid;
            decided_bypass_n  = s_axis.tuser_bypass_stage;
            flush_limit_n     = 2'd0;
            state_next        = S_FLUSH;
          end else begin
            state_next        = S_COLLECT;
          end
        end
      end

      S_COLLECT: begin
        if (in_hs) begin
          case (beat)
            // Beat 1 corresponds to Beat 2 in waveforms (contains IP:DA3, IP:DA2)
            2'd1: begin
              ipv4_da[31:24] = s_axis.tdata[119:112]; 
              ipv4_da[23:16] = s_axis.tdata[127:120]; 
            end

            // Beat 2 corresponds to Beat 3 in waveforms (contains IP:DA1, IP:DA0)
            2'd2: begin
              ipv4_da[15: 8] = s_axis.tdata[  7:  0]; 
              ipv4_da[ 7: 0] = s_axis.tdata[ 15:  8]; 
              state_next      = S_DECIDE;
            end
            
            default: ;
          endcase
        end
      end

      S_DECIDE: begin
        route_req_valid   = 1'b1;
        decided_dst_n     = route_dst;
        decided_peer_n    = route_peer;
        decided_bypass_n  = (USE_BYPASS_FROM_MEM) ? route_bypass : s_axis.tuser_bypass_stage;
        flush_limit_n     = 2'd2;
        state_next        = S_FLUSH;
      end

      S_FLUSH: begin
        if (m_axis.tready && beat_buf[buf_rd_ptr].valid) begin
          if (beat_buf[buf_rd_ptr].last) begin
            state_next = S_IDLE;
          end else if (buf_rd_ptr == flush_limit) begin
            state_next = S_FWD;
          end
        end
      end

      S_FWD: begin
        if (in_hs && s_axis.tlast) begin
          state_next = S_IDLE;
        end
      end

      default: begin
        state_next = state;
      end

    endcase
  end

  always_ff @(posedge s_axis.clk or posedge s_axis.rst) begin
    if (s_axis.rst) begin
      state <= S_IDLE;
      beat  <= 2'd0;
      buf_rd_ptr <= 2'd0;
      beat_buf[0].valid <= 1'b0; beat_buf[1].valid <= 1'b0; beat_buf[2].valid <= 1'b0;
      decided_dst <= 3'd0;
      decided_peer<= 8'd0;
      decided_bypass <= 1'b0;
      route_req_ip <= 32'd0;
      flush_limit  <= 2'd0;
    end else begin
      state <= state_next;
      flush_limit <= flush_limit_n;

      if (state == S_IDLE) begin
        if (in_hs && !s_axis.tuser_bypass_all) beat <= 2'd1;
        else                                    beat <= 2'd0;
      end else if (state == S_COLLECT && in_hs) begin
        beat <= beat + 2'd1; 
      end else if (state == S_FWD && in_hs && s_axis.tlast) begin
        beat <= 2'd0;
      end

      if (state == S_IDLE && in_hs) begin
         beat_buf[0].data  <= s_axis.tdata;
         beat_buf[0].keep  <= s_axis.tkeep;
         beat_buf[0].last  <= s_axis.tlast;
         beat_buf[0].valid <= 1'b1;
      end

      if (state == S_COLLECT && in_hs) begin
        beat_buf[beat].data  <= s_axis.tdata;
        beat_buf[beat].keep  <= s_axis.tkeep;
        beat_buf[beat].last  <= s_axis.tlast;
        beat_buf[beat].valid <= 1'b1;

        if (beat == 2'd1) begin
            route_req_ip[31:24] <= s_axis.tdata[119:112];
            route_req_ip[23:16] <= s_axis.tdata[127:120];
        end
        if (beat == 2'd2) begin
            route_req_ip[15: 8] <= s_axis.tdata[  7:  0];
            route_req_ip[ 7: 0] <= s_axis.tdata[ 15:  8];
        end
      end
      
      // (FLUSH)
      if (state == S_FLUSH && m_axis.tready && beat_buf[buf_rd_ptr].valid) begin
        beat_buf[buf_rd_ptr].valid <= 1'b0;
        if (!beat_buf[buf_rd_ptr].last && (buf_rd_ptr < flush_limit)) begin
          buf_rd_ptr <= buf_rd_ptr + 2'd1;
        end else begin
          buf_rd_ptr <= 2'd0; 
        end
      end

      // Buffer reset after IDLE
      if (state_next == S_IDLE) begin
        beat_buf[0].valid <= 1'b0; beat_buf[1].valid <= 1'b0; beat_buf[2].valid <= 1'b0;
        buf_rd_ptr   <= 2'd0;
      end

      decided_dst    <= decided_dst_n;
      decided_peer   <= decided_peer_n;
      decided_bypass <= decided_bypass_n;
    end
  end


  logic [127:0] flush_tdata;
  logic [15:0]  flush_tkeep;
  logic         flush_tlast;
  logic         flush_tvalid;

  assign flush_tdata  = beat_buf[buf_rd_ptr].data;
  assign flush_tkeep  = beat_buf[buf_rd_ptr].keep;
  assign flush_tlast  = beat_buf[buf_rd_ptr].last;
  assign flush_tvalid = (state == S_FLUSH) && beat_buf[buf_rd_ptr].valid;

  assign m_axis.tvalid = (state == S_FLUSH) ? flush_tvalid :
                         (state == S_FWD)   ? s_axis.tvalid : 1'b0;
  assign m_axis.tdata  = (state == S_FLUSH) ? flush_tdata  :
                         (state == S_FWD)   ? s_axis.tdata  : '0;
  assign m_axis.tkeep  = (state == S_FLUSH) ? flush_tkeep  :
                         (state == S_FWD)   ? s_axis.tkeep  : '0;
  assign m_axis.tlast  = (state == S_FLUSH) ? flush_tlast  :
                         (state == S_FWD)   ? s_axis.tlast  : 1'b0;

  assign m_axis.tuser_bypass_all   = s_axis.tuser_bypass_all;
  assign m_axis.tuser_src          = s_axis.tuser_src;
  assign m_axis.tuser_bypass_stage = decided_bypass;
  assign m_axis.tuser_dst          = decided_dst;
  assign m_axis.tid                = decided_peer;

endmodule

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2025/12/7 IV: original creation
*/