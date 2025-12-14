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
//   DPE AXIS skid buffer
//==========================================================================

module dpe_if_skid_buffer (
   dpe_if.s_axis inp,
   dpe_if.m_axis outp
);
   axis_register #(
      .DATA_WIDTH(128),
      .USER_WIDTH(8),
      .ID_WIDTH(8)
   ) sbuff (
      .clk(inp.clk),
      .rst(inp.rst),
      .s_axis_tvalid(inp.tvalid),
      .s_axis_tready(inp.tready),
      .s_axis_tdata(inp.tdata),
      .s_axis_tkeep(inp.tkeep),
      .s_axis_tlast(inp.tlast),
      .s_axis_tuser({inp.tuser_bypass_all,
                     inp.tuser_bypass_stage,
                     inp.tuser_src,
                     inp.tuser_dst}),
      .s_axis_tid(inp.tid),
      .s_axis_tdest('0),
      .m_axis_tvalid(outp.tvalid),
      .m_axis_tready(outp.tready),
      .m_axis_tdata(outp.tdata),
      .m_axis_tkeep(outp.tkeep),
      .m_axis_tlast(outp.tlast),
      .m_axis_tuser({outp.tuser_bypass_all,
                     outp.tuser_bypass_stage,
                     outp.tuser_src,
                     outp.tuser_dst}),
      .m_axis_tid(outp.tid),
      .m_axis_tdest()
   );
endmodule
