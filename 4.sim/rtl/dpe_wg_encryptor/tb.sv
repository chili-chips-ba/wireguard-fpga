//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                 PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   WireGuard Encryptor testbench
//==========================================================================

`timescale 1ps / 1ps
`define NULL 0

module tb;
   // Inputs
   logic clk;
   logic rst;
   logic pcapfinished;
   logic fcr_idle;
   localparam CLOCK_PERIOD = 12500;

   dpe_if to_encryptor(.clk(clk), .rst(rst));
   dpe_if from_encryptor(.clk(clk), .rst(rst));

   dpe_pcapreader #(
      .PCAP_FILENAME("../plaintext_128.pcap"),
      .TUSER_BYPASS_STAGE(1'b0)
   ) pcaprd (
	   .outp(to_encryptor),
      .pcapfinished(pcapfinished)
   );

   dpe_wg_encryptor encryptor (
      .inp(to_encryptor),
      .outp(from_encryptor),

      .fcr_idle(fcr_idle),

      .ram_peer_idx(),
      .ram_local_mac(48'hAABBCCDDEEFF),
      .ram_local_ip(32'h0100A8C0),
      .ram_local_port(16'h6DCA),
      .ram_remote_mac(48'hFFEEDDCCBBAA),
      .ram_remote_ip(32'h0200A8C0),
      .ram_remote_port(16'h6CCA),
      .ram_remote_id(32'hAABBCCDD),
      .ram_encrypt_key(256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF),
      .ram_send_cnt(64'd1),
      .ram_new_send_cnt(),
      .ram_update_send_cnt()
   );

   dpe_pcapwriter #(
	   .PCAP_FILENAME("../ciphertext_128.pcap")
   ) pcapwr (
	   .inp(from_encryptor)
   );

   always #(CLOCK_PERIOD/2) clk <= ~clk;

   integer i = 0;
   initial begin
      rst = 1;
      #(CLOCK_PERIOD);
      rst = 0;

      while (~pcapfinished) begin
	      #(CLOCK_PERIOD);
	   end

      while (~fcr_idle) begin
	      #(CLOCK_PERIOD);
	   end

      #(2*CLOCK_PERIOD);

      $finish;
   end
endmodule
