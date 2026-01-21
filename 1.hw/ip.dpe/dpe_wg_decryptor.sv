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
//    DPE WireGuard Decryptor with Verification Gate & Ethernet Re-wrap
//==========================================================================

// ============================================================================
// Module: sync_fifo
// Description: Internal buffer to hold decrypted data until verified.
// ============================================================================

module sync_fifo #(
    parameter WIDTH = 159,
    parameter DEPTH = 512
)(
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] data_in,
    input  logic             wr_en,
    output logic             full,
    output logic [WIDTH-1:0] data_out,
    input  logic             rd_en,
    output logic             empty
);
    localparam ADDR_W = $clog2(DEPTH);
    logic [WIDTH-1:0] mem [DEPTH];
    logic [ADDR_W:0]  wr_ptr, rd_ptr;

    assign full  = (wr_ptr[ADDR_W] != rd_ptr[ADDR_W]) && (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
    assign empty = (wr_ptr == rd_ptr);

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr[ADDR_W-1:0]] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end
    assign data_out = mem[rd_ptr[ADDR_W-1:0]];
endmodule

// ============================================================================
// Module: dpe_wg_decryptor
// Description: Main decryptor with FIFO-based verification gating.
// ============================================================================

module dpe_wg_decryptor (
   dpe_if.s_axis        inp,
   dpe_if.m_axis        outp,
   output logic          fcr_idle,
   output logic [7:0]    ram_peer_idx,
   input  logic [47:0]   ram_local_mac,
   input  logic [31:0]   ram_local_ip,
   input  logic [15:0]   ram_local_port,
   input  logic [47:0]   ram_remote_mac,
   input  logic [31:0]   ram_remote_ip,
   input  logic [15:0]   ram_remote_port,
   input  logic [31:0]   ram_remote_id,
   input  logic [255:0]  ram_decrypt_key,
   input  logic [63:0]   ram_send_cnt,
   output logic [63:0]   ram_new_send_cnt,
   output logic          ram_update_send_cnt
);
   import dpe_pkg::*;

   typedef enum logic [3:0] {
      IDLE,
      BYPASS,
      WAIT_RAM,
      HEADER_1,
      HEADER_2,
      HEADER_3,
      HEADER_4,
      PAYLOAD,
      PAYLOAD_LAST,
      DROP_PACKET
   } state_t;

   // Internal states
   state_t state, state_next;
   logic [2:0] tuser_dst, tuser_dst_next;
   logic [2:0] tuser_src, tuser_src_next;
   logic [7:0] peer_idx, peer_idx_next;
   logic [47:0] local_mac, local_mac_next;
   logic [31:0] local_ip, local_ip_next;
   logic [15:0] local_port, local_port_next;
   logic [47:0] remote_mac, remote_mac_next;
   logic [31:0] remote_ip, remote_ip_next;
   logic [15:0] remote_port, remote_port_next;
   logic [31:0] remote_id, remote_id_next;
   logic [255:0] decrypt_key, decrypt_key_next;
   logic [63:0] send_cnt, send_cnt_next;
   logic [63:0] new_send_cnt, new_send_cnt_next;
   logic update_send_cnt, update_send_cnt_next;
   logic [127:0] plaintext_data, plaintext_data_next;
   logic plaintext_valid, plaintext_valid_next;
   logic [127:0] decrypted_data, decrypted_data_next;
   logic input_finished, input_finished_next;
   logic [15:0] packet_ip_len, packet_ip_len_next;
   logic [15:0] packet_udp_len, packet_udp_len_next;

   // Internal signals
   dpe_if to_decrypt (.clk(inp.clk), .rst(inp.rst));
   dpe_if from_decrypt (.clk(inp.clk), .rst(inp.rst));
   dpe_if piped (.clk(inp.clk), .rst(inp.rst));
   dpe_if muxed (.clk(inp.clk), .rst(inp.rst));
   logic is_verified;

   // FIFO & Gate Logic Signals
   logic packet_authorized;
   logic fifo_full, fifo_empty, fifo_clear;   

   // FIFO Data Packing (tdata + tkeep + tlast + tuser signals)
   localparam FIFO_W = 128 + 16 + 1 + 3 + 3 + 8;
   logic [FIFO_W-1:0] fifo_din, fifo_dout;

   assign fifo_din = {
      muxed.tid,             // [158:151]
      muxed.tuser_src,       // [150:148]
      muxed.tuser_dst,       // [147:145]
      muxed.tlast,           // [144]
      muxed.tkeep,           // [143:128]
      muxed.tdata            // [127:0]
   };

   // Output Logic mapping from FIFO
   logic        fifo_out_tlast;
   logic [15:0] fifo_out_tkeep;
   logic [127:0] fifo_out_tdata;
   logic [2:0]  fifo_out_tuser_dst, fifo_out_tuser_src;
   logic [7:0]  fifo_out_tid;

   assign {fifo_out_tid, fifo_out_tuser_src, fifo_out_tuser_dst, 
           fifo_out_tlast, fifo_out_tkeep, fifo_out_tdata} = fifo_dout;

   // FIFO Instantiation
   sync_fifo #(.WIDTH(FIFO_W), .DEPTH(512)) out_fifo (
      .clk(inp.clk),
      .rst(inp.rst || fifo_clear),
      .data_in(fifo_din),
      .wr_en(muxed.tvalid && !fifo_full),
      .full(fifo_full),
      .data_out(fifo_dout),
      .rd_en(outp.tready && packet_authorized),
      .empty(fifo_empty)
   );

   // Verification Gate: Opens only if is_verified is true at the end of packet
   always_ff @(posedge inp.clk) begin
      if (inp.rst || fifo_clear) begin
         packet_authorized <= 1'b0;
      end else if (state == PAYLOAD_LAST && is_verified) begin
         packet_authorized <= 1'b1; 
      end else if (outp.tlast && outp.tready) begin
         packet_authorized <= 1'b0; 
      end
   end

   // FSM registers
   always_ff @(posedge inp.clk) begin
      if (inp.rst) begin
         state <= IDLE;
         tuser_dst <= '0; tuser_src <= '0; peer_idx <= '0;
         local_mac <= '0; local_ip <= '0; local_port <= '0;
         remote_mac <= '0; remote_ip <= '0; remote_port <= '0; remote_id <= '0;
         decrypt_key <= '0; send_cnt <= '0; new_send_cnt <= '0; update_send_cnt <= '0;
         plaintext_data <= '0; plaintext_valid <= 1'b0; decrypted_data <= '0;
         input_finished <= 1'b0; packet_ip_len <= '0; packet_udp_len <= '0;
      end else begin
         state <= state_next;
         tuser_dst <= tuser_dst_next; tuser_src <= tuser_src_next; peer_idx <= peer_idx_next;
         local_mac <= local_mac_next; local_ip <= local_ip_next; local_port <= local_port_next;
         remote_mac <= remote_mac_next; remote_ip <= remote_ip_next; remote_port <= remote_port_next;
         remote_id <= remote_id_next; decrypt_key <= decrypt_key_next;
         send_cnt <= send_cnt_next; new_send_cnt <= new_send_cnt_next; update_send_cnt <= update_send_cnt_next;
         plaintext_data <= plaintext_data_next; plaintext_valid <= plaintext_valid_next;
         decrypted_data <= decrypted_data_next; input_finished <= input_finished_next;
         packet_ip_len <= packet_ip_len_next; packet_udp_len <= packet_udp_len_next;
      end
   end

   // FSM transition logic
   always_comb begin
      state_next = state;
      tuser_dst_next = tuser_dst; tuser_src_next = tuser_src; peer_idx_next = peer_idx;
      local_mac_next = local_mac; local_ip_next = local_ip; local_port_next = local_port;
      remote_mac_next = remote_mac; remote_ip_next = remote_ip; remote_port_next = remote_port;
      remote_id_next = remote_id; decrypt_key_next = decrypt_key; send_cnt_next = send_cnt;
      new_send_cnt_next = new_send_cnt; update_send_cnt_next = update_send_cnt;
      plaintext_data_next = plaintext_data; plaintext_valid_next = plaintext_valid;
      decrypted_data_next = decrypted_data; input_finished_next = input_finished;
      packet_ip_len_next = packet_ip_len; packet_udp_len_next = packet_udp_len;
      fifo_clear = 1'b0;

      unique case (state)
         IDLE: begin
            if (inp.tvalid && inp.tready) begin
               if (inp.tuser_bypass_stage || inp.tuser_bypass_all) state_next = BYPASS;
               else begin
                  tuser_dst_next = inp.tuser_dst;
                  tuser_src_next = inp.tuser_src;
                  peer_idx_next = inp.tid;
                  state_next = WAIT_RAM;
               end
            end
         end

         BYPASS: if (inp.tlast && inp.tvalid) state_next = IDLE;

         WAIT_RAM: begin
            local_mac_next = ram_local_mac; 
            local_ip_next = ram_local_ip;
            local_port_next = ram_local_port; 
            remote_mac_next = ram_remote_mac;
            remote_ip_next = ram_remote_ip; 
            remote_port_next = ram_remote_port;
            remote_id_next = ram_remote_id; 
            decrypt_key_next = ram_decrypt_key;
            send_cnt_next = ram_send_cnt;
            if (piped.tvalid && piped.tready) plaintext_data_next = piped.tdata;
            plaintext_valid_next = piped.tvalid;
            if (!fifo_full) state_next = HEADER_1;
         end

         HEADER_1: begin

            if (piped.tvalid && piped.tready) begin

               plaintext_data_next = piped.tdata;
               packet_ip_len_next = {piped.tdata[7:0], piped.tdata[15:12], 4'd0} + 16'd76;
               packet_udp_len_next = {piped.tdata[7:0], piped.tdata[15:12], 4'd0} + 16'd56;
               state_next = HEADER_2;
            end
            plaintext_valid_next = piped.tvalid;
         end

         HEADER_2: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) input_finished_next = 1'b1;
               state_next = HEADER_3;
            end
            plaintext_valid_next = piped.tvalid;
         end


         HEADER_3: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) input_finished_next = 1'b1;
               state_next = HEADER_4;
            end
            plaintext_valid_next = piped.tvalid;
         end


         HEADER_4: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) input_finished_next = 1'b1;
            end
            plaintext_valid_next = piped.tvalid;
            if (!fifo_full && from_decrypt.tvalid) begin
               decrypted_data_next = from_decrypt.tdata;
               state_next = PAYLOAD;
            end
         end


         PAYLOAD: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) input_finished_next = 1'b1;
            end

            plaintext_valid_next = piped.tvalid;
            if (!fifo_full && from_decrypt.tvalid) begin
               decrypted_data_next = from_decrypt.tdata;
               if (from_decrypt.tlast) begin
                  new_send_cnt_next = send_cnt + 1;
                  update_send_cnt_next = 1'b1;
                  state_next = PAYLOAD_LAST;
               end
            end
         end

         PAYLOAD_LAST: begin
            update_send_cnt_next = 1'b0;
            if (!fifo_full) begin
               if (is_verified) begin
                  input_finished_next = 1'b0;
                  state_next = IDLE;
               end else begin
                  state_next = DROP_PACKET;
               end
            end
         end


         DROP_PACKET: begin
            fifo_clear = 1'b1;
            input_finished_next = 1'b0;
            state_next = IDLE;
         end


         default: state_next = IDLE;
      endcase
   end

   // Outputs logic (Muxing and Data Generation)

   always_comb begin
      to_decrypt.tvalid = 1'b0; 
      to_decrypt.tdata = '0; 
      to_decrypt.tlast = 1'b0; 
      to_decrypt.tkeep = '0;
      muxed.tvalid = 1'b0; 
      muxed.tdata = '0; 
      muxed.tlast = 1'b0; 
      muxed.tkeep = '0;
      muxed.tuser_bypass_all = 1'b0; 
      muxed.tuser_bypass_stage = 1'b0;
      muxed.tuser_src = tuser_src; 
      muxed.tuser_dst = tuser_dst; 
      muxed.tid = peer_idx;


      unique case (state)

         IDLE, BYPASS: begin
            muxed.tvalid = piped.tvalid; 
            muxed.tdata = piped.tdata; 
            muxed.tlast = piped.tlast;
            muxed.tkeep = piped.tkeep; 
            muxed.tuser_bypass_all = piped.tuser_bypass_all;
            muxed.tuser_bypass_stage = piped.tuser_bypass_stage; 
            muxed.tuser_src = piped.tuser_src;
            muxed.tuser_dst = piped.tuser_dst; 
            muxed.tid = piped.tid;
         end


         HEADER_1: begin
            to_decrypt.tvalid = piped.tvalid;
            to_decrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_decrypt.tkeep = 16'hFFFF;
            muxed.tvalid = !fifo_full;
            muxed.tdata = {8'h00, 8'h45, 16'h0008, local_mac, remote_mac};
            muxed.tkeep = 16'hFFFF;
         end


         HEADER_2: begin
            to_decrypt.tvalid = piped.tvalid;
            to_decrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_decrypt.tkeep = 16'hFFFF;
            muxed.tvalid = !fifo_full;
            muxed.tdata = {remote_ip[15:0], local_ip[31:0], 16'h0000, 8'h11, 8'd64, 16'h0000, 16'h0000, packet_ip_len[7:0], packet_ip_len[15:8]};
            muxed.tkeep = 16'hFFFF;
         end


         HEADER_3: begin
            to_decrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_decrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_decrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_decrypt.tkeep = 16'hFFFF;
            muxed.tvalid = !fifo_full;
            muxed.tdata = {remote_id[15:0], 32'h00000004, 16'h0000, packet_udp_len[7:0], packet_udp_len[15:8], remote_port, local_port, remote_ip[31:16]};
            muxed.tkeep = 16'hFFFF;
         end


         HEADER_4: begin
            to_decrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_decrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_decrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_decrypt.tkeep = 16'hFFFF;
            muxed.tvalid = !fifo_full && from_decrypt.tvalid;
            muxed.tdata = {from_decrypt.tdata[47:0], send_cnt, remote_id[31:16]};
            muxed.tkeep = 16'hFFFF;
         end


         PAYLOAD: begin
            to_decrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_decrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_decrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_decrypt.tkeep = 16'hFFFF;
            muxed.tvalid = !fifo_full && from_decrypt.tvalid;
            muxed.tdata = {from_decrypt.tdata[47:0], decrypted_data[127:48]};
            muxed.tkeep = 16'hFFFF;
         end


         PAYLOAD_LAST: begin
            muxed.tvalid = !fifo_full;
            muxed.tdata = {48'd0, decrypted_data[127:48]};
            muxed.tlast = 1'b1;
            muxed.tkeep = 16'h03FF;
         end
         default: ; 
      endcase
   end


   // Handshaking and interface assignments
   assign piped.tready = !fifo_full && to_decrypt.tready && !input_finished;
   assign from_decrypt.tready = !fifo_full;
   assign fcr_idle = ((state == IDLE) ? 1'b1 : 1'b0) && !outp.tvalid;
   assign ram_peer_idx = peer_idx;
   assign ram_new_send_cnt = new_send_cnt;
   assign ram_update_send_cnt = update_send_cnt;


   // Drive the external interface from FIFO outputs
   assign outp.tvalid = !fifo_empty && packet_authorized;
   assign outp.tlast  = fifo_out_tlast;
   assign outp.tkeep  = fifo_out_tkeep;
   assign outp.tdata  = fifo_out_tdata;
   assign outp.tid    = fifo_out_tid;
   assign outp.tuser_dst = fifo_out_tuser_dst;
   assign outp.tuser_src = fifo_out_tuser_src;

   // Sub-module instantiations

   chacha20poly1305_decrypt decrypt (
      .clk_80p0(inp.clk),
      .key(decrypt_key),
      .nonce({32'd0, send_cnt}),
      .aad(256'd0),
      .aad_len(8'd0),
      .s_axis_tdata(to_decrypt.tdata),
      .s_axis_tkeep(to_decrypt.tkeep),
      .s_axis_tlast(to_decrypt.tlast),
      .s_axis_tvalid(to_decrypt.tvalid),
      .m_axis_tready(from_decrypt.tready),
      .s_axis_tready(to_decrypt.tready),
      .m_axis_tdata(from_decrypt.tdata),
      .m_axis_tkeep(from_decrypt.tkeep),
      .m_axis_tlast(from_decrypt.tlast),
      .m_axis_tvalid(from_decrypt.tvalid),
      .m_verified(is_verified)
   );

   dpe_if_pipeline #(.LENGTH(1)) input_pipe (
      .inp(inp),
      .outp(piped)
   );
endmodule 
