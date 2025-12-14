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
//   DPE AXI-Stream Interface
//==========================================================================

interface dpe_if (
   // verilator lint_off UNUSED
   input logic   clk,
   input logic   rst
);
   logic         tready;
   logic         tvalid;
   logic [127:0] tdata;
   logic         tlast;
   logic [15:0]  tkeep;
   logic         tuser_bypass_all;
   logic         tuser_bypass_stage;
   logic [2:0]   tuser_src;
   logic [2:0]   tuser_dst;
   logic [7:0]   tid;
   // verilator lint_on UNUSED

   modport m_axis (
      input     clk,
      input     rst,
      input     tready,
      output    tvalid,
      output    tdata,
      output    tlast,
      output    tkeep,
      output    tuser_bypass_all,
      output    tuser_bypass_stage,
      output    tuser_src,
      output    tuser_dst,
      output    tid
   );

   modport s_axis (
      input     clk,
      input     rst,
      output    tready,
      input     tvalid,
      input     tdata,
      input     tlast,
      input     tkeep,
      input     tuser_bypass_all,
      input     tuser_bypass_stage,
      input     tuser_src,
      input     tuser_dst,
      input     tid
   );
endinterface
