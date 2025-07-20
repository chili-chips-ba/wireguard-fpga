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
//   DPE wrapper for PCAP packet writer
//==========================================================================

module dpe_pcapwriter#
(
   parameter PCAP_FILENAME = "none"
) (
   dpe_if.s_axis inp
);
   avalon_if #(.DATA_WIDTH(128)) avalon_int(.clk(inp.clk),.rst(inp.rst));
   axis_if #(.DATA_WIDTH(128)) axis_int(.clk(inp.clk),.rst(inp.rst));

   assign axis_int.data = inp.tdata;
   assign axis_int.valid = inp.tvalid;
   assign axis_int.last = inp.tlast;
   assign axis_int.keep = inp.tkeep;
   assign inp.tready = axis_int.ready;

   pcapwriter #(
      .PCAP_FILENAME(PCAP_FILENAME),
      .SIGNAL_TYPE("axisif"),
      .DATA_WIDTH(128)
   ) pcap (
      .clk_in(inp.clk),
      .reset(inp.rst),

      .to_writer_avalon(avalon_int),
      .to_writer_axis(axis_int),

      .pktcount()
   );
endmodule
