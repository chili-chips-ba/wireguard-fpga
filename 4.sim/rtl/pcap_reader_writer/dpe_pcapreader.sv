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
//   DPE wrapper for PCAP packet reader
//==========================================================================

module dpe_pcapreader#
(
   parameter PCAP_FILENAME = "none",
   parameter TUSER_BYPASS_ALL = 1'b0,
   parameter TUSER_BYPASS_STAGE = 1'b0,
   parameter TUSER_SRC = DPE_ADDR_CPU,
   parameter TUSER_DST = DPE_ADDR_ETH_1,
   parameter TID = 8'd0
) (
   dpe_if.m_axis outp,
   output logic  pcapfinished
);
   import dpe_pkg::*;

   avalon_if #(.DATA_WIDTH(128)) avalon_int(.clk(outp.clk),.rst(outp.rst));
   axis_if #(.DATA_WIDTH(128)) axis_int(.clk(outp.clk),.rst(outp.rst));

   assign outp.tdata = axis_int.data;
   assign outp.tvalid = axis_int.valid;
   assign outp.tlast = axis_int.last;
   assign outp.tkeep = axis_int.keep;
   assign axis_int.ready = outp.tready;
   assign outp.tuser_bypass_all = TUSER_BYPASS_ALL;
   assign outp.tuser_bypass_stage = TUSER_BYPASS_STAGE;
   assign outp.tuser_src = TUSER_SRC;
   assign outp.tuser_dst = TUSER_DST;
   assign outp.tid = TID;
   assign avalon_int.ready = 1'b0;

   pcapreader #(
      .PCAP_FILENAME(PCAP_FILENAME),
      .SIGNAL_TYPE("axisif"),
      .DATA_WIDTH(128)
   ) pcap (
      .clk_out(outp.clk),
      .reset(outp.rst),
      .available(),
      .pktcount(),
      .newpkt(),
      .pcapfinished(pcapfinished),

      .from_reader_avalon(avalon_int),
      .from_reader_axis(axis_int)
   );
endmodule
