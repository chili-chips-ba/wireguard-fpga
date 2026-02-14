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
