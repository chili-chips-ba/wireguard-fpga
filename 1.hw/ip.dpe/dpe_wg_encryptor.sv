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
   dpe_if.s_axis inp,
   dpe_if.m_axis outp
);
   import dpe_pkg::*;

   dpe_if outp_sbuff (.clk(inp.clk), .rst(inp.rst));

// Encryptor core
   chacha20poly1305_encrypt DUT (
      .clk_80p0(inp.clk),
      .key(256'h9F9E9D9C9B9A999897969594939291908F8E8D8C8B8A89888786858483828180),
      .nonce(96'h474645444342414000000007),
      .aad(256'h0000006174616420646574616369746E6568747561206C616E6F697469646441),
      .aad_len(8'd29),
      .s_axis_tdata(inp.tdata),
      .s_axis_tkeep(inp.tkeep),
      .s_axis_tlast(inp.tlast),
      .s_axis_tvalid(inp.tvalid),
      .m_axis_tready(outp_sbuff.tready),
      .s_axis_tready(inp.tready),
      .m_axis_tdata(outp_sbuff.tdata),
      .m_axis_tkeep(outp_sbuff.tkeep),
      .m_axis_tlast(outp_sbuff.tlast),
      .m_axis_tvalid(outp_sbuff.tvalid)
   );

   assign outp_sbuff.tuser_bypass_all = inp.tuser_bypass_all;
   assign outp_sbuff.tuser_bypass_stage = inp.tuser_bypass_stage;
   assign outp_sbuff.tuser_src = inp.tuser_src;
   assign outp_sbuff.tuser_dst = inp.tuser_dst;
   assign outp_sbuff.tid = inp.tid;

// Skid buffers
   dpe_if_skid_buffer skid_buffer_outp (
      .inp(outp_sbuff),
      .outp(outp)
   );
endmodule
