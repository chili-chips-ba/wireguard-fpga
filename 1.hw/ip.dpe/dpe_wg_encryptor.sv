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
//   DPE WireGuard Encryptor
//==========================================================================

module dpe_wg_encryptor (
   dpe_if.s_axis        inp,
   dpe_if.m_axis        outp,

   output logic         fcr_idle,

   output logic [7:0]   ram_peer_idx,
   input  logic [47:0]  ram_local_mac,
   input  logic [31:0]  ram_local_ip,
   input  logic [15:0]  ram_local_port,
   input  logic [47:0]  ram_remote_mac,
   input  logic [31:0]  ram_remote_ip,
   input  logic [15:0]  ram_remote_port,
   input  logic [31:0]  ram_remote_id,
   input  logic [255:0] ram_encrypt_key,
   input  logic [63:0]  ram_send_cnt,
   output logic [63:0]  ram_new_send_cnt,
   output logic         ram_update_send_cnt
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
      PAYLOAD_LAST
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
   logic [255:0] encrypt_key, encrypt_key_next;
   logic [63:0] send_cnt, send_cnt_next;
   logic [63:0] new_send_cnt, new_send_cnt_next;
   logic update_send_cnt, update_send_cnt_next;
   logic [127:0] plaintext_data, plaintext_data_next;
   logic plaintext_valid, plaintext_valid_next;
   logic [127:0] encrypted_data, encrypted_data_next;
   logic input_finished, input_finished_next;

// Internal signals
   dpe_if to_encrypt (.clk(inp.clk), .rst(inp.rst));
   dpe_if from_encrypt (.clk(inp.clk), .rst(inp.rst));
   dpe_if piped (.clk(inp.clk), .rst(inp.rst));
   dpe_if muxed (.clk(inp.clk), .rst(inp.rst));

// FSM registers
   always_ff @(posedge inp.clk) begin
      if (inp.rst) begin
         state <= IDLE;
         tuser_dst <= '0;
         tuser_src <= '0;
         peer_idx <= '0;
         local_mac <= '0;
         local_ip <= '0;
         local_port <= '0;
         remote_ip <= '0;
         remote_port <= '0;
         remote_id <= '0;
         encrypt_key <= '0;
         send_cnt <= '0;
         new_send_cnt <= '0;
         update_send_cnt <= '0;
         plaintext_data <= '0;
         plaintext_valid <= 1'b0;
         encrypted_data <= '0;
         input_finished <= 1'b0;
      end else begin
         state <= state_next;
         tuser_dst <= tuser_dst_next;
         tuser_src <= tuser_src_next;
         peer_idx <= peer_idx_next;
         local_mac <= local_mac_next;
         local_ip <= local_ip_next;
         local_port <= local_port_next;
         remote_mac <= remote_mac_next;
         remote_ip <= remote_ip_next;
         remote_port <= remote_port_next;
         remote_id <= remote_id_next;
         encrypt_key <= encrypt_key_next;
         send_cnt <= send_cnt_next;
         new_send_cnt <= new_send_cnt_next;
         update_send_cnt <= update_send_cnt_next;
         plaintext_data <= plaintext_data_next;
         plaintext_valid <= plaintext_valid_next;
         encrypted_data <= encrypted_data_next;
         input_finished <= input_finished_next;
      end
   end

// FSM transition logic
   always_comb begin
      state_next = state;
      tuser_dst_next = tuser_dst;
      tuser_src_next = tuser_src;
      peer_idx_next = peer_idx;
      local_mac_next = local_mac;
      local_ip_next = local_ip;
      local_port_next = local_port;
      remote_mac_next = remote_mac;
      remote_ip_next = remote_ip;
      remote_port_next = remote_port;
      remote_id_next = remote_id;
      encrypt_key_next = encrypt_key;
      send_cnt_next = send_cnt;
      new_send_cnt_next = new_send_cnt;
      update_send_cnt_next = update_send_cnt;
      plaintext_data_next = plaintext_data;
      plaintext_valid_next = plaintext_valid;
      encrypted_data_next = encrypted_data;
      input_finished_next = input_finished;

      unique case (state)
         IDLE: begin
            if (inp.tvalid && inp.tready) begin
               if (inp.tuser_bypass_stage || inp.tuser_bypass_all) begin
                  state_next = BYPASS;
               end else begin
                  tuser_dst_next = inp.tuser_dst;
                  tuser_src_next = inp.tuser_src;
                  peer_idx_next = inp.tid;
                  state_next = WAIT_RAM;
               end
            end
         end

         BYPASS: begin
            if (inp.tlast && inp.tvalid) begin
               state_next = IDLE;
            end
         end

         WAIT_RAM: begin
            local_mac_next = ram_local_mac;
            local_ip_next = ram_local_ip;
            local_port_next = ram_local_port;
            remote_mac_next = ram_remote_mac;
            remote_ip_next = ram_remote_ip;
            remote_port_next = ram_remote_port;
            remote_id_next = ram_remote_id;
            encrypt_key_next = ram_encrypt_key;
            send_cnt_next = ram_send_cnt;

            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
            end
            plaintext_valid_next = piped.tvalid;

            if (muxed.tready) begin
               state_next = HEADER_1;
            end
         end

         HEADER_1: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               state_next = HEADER_2;
            end
            plaintext_valid_next = piped.tvalid;
         end

         HEADER_2: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) begin
                  input_finished_next = 1'b1;
               end
               state_next = HEADER_3;
            end
            plaintext_valid_next = piped.tvalid;
         end

         HEADER_3: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) begin
                  input_finished_next = 1'b1;
               end
               state_next = HEADER_4;
            end
            plaintext_valid_next = piped.tvalid;
         end

         HEADER_4: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) begin
                  input_finished_next = 1'b1;
               end
            end
            plaintext_valid_next = piped.tvalid;

            if (muxed.tready && from_encrypt.tvalid) begin
               encrypted_data_next = from_encrypt.tdata;
               state_next = PAYLOAD;
            end
         end

         PAYLOAD: begin
            if (piped.tvalid && piped.tready) begin
               plaintext_data_next = piped.tdata;
               if (piped.tlast) begin
                  input_finished_next = 1'b1;
               end
            end
            plaintext_valid_next = piped.tvalid;

            if (muxed.tready && from_encrypt.tvalid) begin
               encrypted_data_next = from_encrypt.tdata;
               if (from_encrypt.tlast) begin
                  new_send_cnt_next = send_cnt + 1;
                  update_send_cnt_next = 1'b1;
                  state_next = PAYLOAD_LAST;
               end
            end
         end

         PAYLOAD_LAST: begin
            update_send_cnt_next = 1'b0;
            if (muxed.tready) begin
               input_finished_next = 1'b0;
               state_next = IDLE;
            end
         end

         default: state_next = IDLE;
      endcase
   end

// Outputs logic
   always_comb begin
      to_encrypt.tvalid = 1'b0;
      to_encrypt.tdata = '0;
      to_encrypt.tlast = 1'b0;
      to_encrypt.tkeep = '0;

      muxed.tvalid = 1'b0;
      muxed.tdata = '0;
      muxed.tlast = 1'b0;
      muxed.tkeep = '0;
      muxed.tuser_bypass_all = 1'b0;
      muxed.tuser_bypass_stage = 1'b0;
      muxed.tuser_src = '0;
      muxed.tuser_dst = '0;
      muxed.tid = '0;

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

         WAIT_RAM: begin
            //NOP
         end

         HEADER_1: begin
            to_encrypt.tvalid = piped.tvalid;
            to_encrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_encrypt.tlast = 1'b0;
            to_encrypt.tkeep = 16'hFFFF;

            muxed.tvalid = 1'b1;
            //             IP:DSCP IP:VER ETH:TL    ETH:SA     ETH:DA
            muxed.tdata = {8'h00, 8'h45, 16'h0008, local_mac, remote_mac};
            muxed.tlast = 1'b0;
            muxed.tkeep = 16'hFFFF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         HEADER_2: begin
            to_encrypt.tvalid = piped.tvalid;
            to_encrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_encrypt.tlast = 1'b0;
            to_encrypt.tkeep = 16'hFFFF;

            muxed.tvalid = 1'b1;
            //             IP:DA            IP:SA           IP:HCHK  IP:PROT IP:TTL IP:FLG    IP:ID     IP:TL
            muxed.tdata = {remote_ip[15:0], local_ip[31:0], 16'h0000, 8'h11, 8'd64, 16'h0000, 16'h0000, 16'h3C00};
            muxed.tlast = 1'b0;
            muxed.tkeep = 16'hFFFF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         HEADER_3: begin
            to_encrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_encrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_encrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_encrypt.tkeep = 16'hFFFF;

            muxed.tvalid = 1'b1;
            //             WG:RCV           WG:TYPE       UDP:CHK   UDP:LEN   UDP:DP       UDP:SP      IP:DA
            muxed.tdata = {remote_id[15:0], 32'h00000004, 16'h0000, 16'h2800, remote_port, local_port, remote_ip[31:16]};
            muxed.tlast = 1'b0;
            muxed.tkeep = 16'hFFFF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         HEADER_4: begin
            to_encrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_encrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_encrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_encrypt.tkeep = 16'hFFFF;

            muxed.tvalid = from_encrypt.tvalid;
            //             WG:ENP WG:CNT    WG:RCV
            muxed.tdata = {from_encrypt.tdata[47:0], send_cnt, remote_id[31:16]};
            muxed.tlast = 1'b0;
            muxed.tkeep = 16'hFFFF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         PAYLOAD: begin
            to_encrypt.tvalid = (piped.tkeep[15:14] == 2'b00) ? plaintext_valid : piped.tvalid;
            to_encrypt.tdata = {piped.tdata[111:0], plaintext_data[127:112]};
            to_encrypt.tlast = (piped.tkeep[15:14] == 2'b00) ? 1'b1 : 1'b0;
            to_encrypt.tkeep = 16'hFFFF;

            muxed.tvalid = from_encrypt.tvalid;
            //             WG:ENP
            muxed.tdata = {from_encrypt.tdata[47:0], encrypted_data[127:48]};
            muxed.tlast = 1'b0;
            muxed.tkeep = 16'hFFFF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         PAYLOAD_LAST: begin
            muxed.tvalid = 1'b1;
            //             WG:ENP
            muxed.tdata = {48'd0, encrypted_data[127:48]};
            muxed.tlast = 1'b1;
            muxed.tkeep = 16'h03FF;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_dst = tuser_dst;
            muxed.tuser_src = tuser_src;
            muxed.tid = peer_idx;
         end

         default: begin
            to_encrypt.tdata = '0;
            to_encrypt.tkeep = '0;
            to_encrypt.tlast = '0;
            to_encrypt.tvalid = '0;

            muxed.tdata = '0;
            muxed.tkeep = '0;
            muxed.tlast = '0;
            muxed.tvalid = '0;
            muxed.tuser_bypass_all = 1'b0;
            muxed.tuser_bypass_stage = 1'b0;
            muxed.tuser_src = '0;
            muxed.tuser_dst = '0;
            muxed.tid = '0;
         end
      endcase
   end
   assign piped.tready = muxed.tready & to_encrypt.tready & ~input_finished;
   assign from_encrypt.tready = muxed.tready;
   assign fcr_idle = ((state == IDLE) ? 1'b1 : 1'b0) & ~outp.tvalid;
   assign ram_peer_idx = peer_idx;
   assign ram_new_send_cnt = new_send_cnt;
   assign ram_update_send_cnt = update_send_cnt;

// Encryptor core
   chacha20poly1305_encrypt encrypt (
      .clk_80p0(inp.clk),
      .key(encrypt_key),
      .nonce({32'd0, send_cnt}),
      .aad(256'd0),
      .aad_len(8'd0),
      .s_axis_tdata(to_encrypt.tdata),
      .s_axis_tkeep(to_encrypt.tkeep),
      .s_axis_tlast(to_encrypt.tlast),
      .s_axis_tvalid(to_encrypt.tvalid),
      .m_axis_tready(from_encrypt.tready),
      .s_axis_tready(to_encrypt.tready),
      .m_axis_tdata(from_encrypt.tdata),
      .m_axis_tkeep(from_encrypt.tkeep),
      .m_axis_tlast(from_encrypt.tlast),
      .m_axis_tvalid(from_encrypt.tvalid)
   );

// Input pipeline
   dpe_if_pipeline #(
      .LENGTH(1)
   ) input_pipe (
      .inp(inp),
      .outp(piped)
   );

// Output skid buffer
   dpe_if_skid_buffer output_sbuff (
      .inp(muxed),
      .outp(outp)
   );
endmodule
