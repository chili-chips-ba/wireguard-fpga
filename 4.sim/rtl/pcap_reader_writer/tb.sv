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
//   PCAP reader and writer testbench
//==========================================================================

`timescale 1ps / 1ps
`define NULL 0

module tb;
   // Inputs
   logic clk;
   logic rst;
   logic pcapfinished;
   localparam CLOCK_PERIOD = 12500;

   dpe_if stream(.clk(clk), .rst(rst));

   dpe_pcapreader #(
      .PCAP_FILENAME("../test1.pcap")
   ) pcaprd (
	   .outp(stream),
      .pcapfinished(pcapfinished)
   );

   dpe_pcapwriter #(
	   .PCAP_FILENAME("../test2.pcap")
   ) pcapwr (
	   .inp(stream)
   );

   always #(CLOCK_PERIOD/2) clk <= ~clk;

   integer i = 0;
   initial begin
      rst = 1;
      #(CLOCK_PERIOD);
      rst = 0;

      while (~pcapfinished) begin
	      #20
	      i = i + 1;
	   end

      #(2*CLOCK_PERIOD);

      $finish;
   end
endmodule
