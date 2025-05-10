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
//   DPE dummy switch
//--------------------------------------------------------------------------
// Default configuration
// (can be overridden by assertion of tuser_bypass_all or tuser_bypass_stage)
//
//   .----------.                             .----------.
//   | From CPU |                 .---------->|  To CPU  |
//   |   FIFO   |------------.   /  .-------->|   FIFO   |
//   '----------'             \ /  /          '----------'
//                             X  /
//   .----------.             / \/            .----------.
//   |From ETH_1|------------'  /\            | To ETH_1 |
//   |   FIFO   |              /  '---------->|   FIFO   |
//   '----------'             /               '----------'
//                           /
//   .----------.           /                 .----------.
//   |From ETH_2|----------'             0--->| To ETH_2 |
//   |   FIFO   |                             |   FIFO   |
//   '----------'                             '----------'
//
//   .----------.                             .----------.
//   |From ETH_3|                             | To ETH_3 |
//   |   FIFO   |------------.   .----------->|   FIFO   |
//   '----------'             \ /             '----------'
//                             X
//   .----------.             / \             .----------.
//   |From ETH_4|------------'   '----------->| To ETH_4 |
//   |   FIFO   |                             |   FIFO   |
//   '----------'                             '----------'
//
//==========================================================================

module dpe_dummy_switch (
   dpe_if.s_axis inp,
   dpe_if.m_axis outp
);
   import dpe_pkg::*;

   dpe_if outp_sbuff (.clk(inp.clk), .rst(inp.rst));

// Backpressure
   assign inp.tready = outp_sbuff.tready;

// Switch
   always_comb begin
      outp_sbuff.tvalid = inp.tvalid;
      outp_sbuff.tdata = inp.tdata;
      outp_sbuff.tkeep = inp.tkeep;
      outp_sbuff.tlast = inp.tlast;
      outp_sbuff.tuser_bypass_all = inp.tuser_bypass_all;
      outp_sbuff.tuser_bypass_stage = 1'b0;
      outp_sbuff.tuser_src = inp.tuser_src;
      if (inp.tuser_bypass_all == 1'b0 && inp.tuser_bypass_stage == 1'b0) begin
         unique case (inp.tuser_src)
            DPE_ADDR_CPU: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_1;
            end
            DPE_ADDR_ETH_1: begin
               outp_sbuff.tuser_dst = DPE_ADDR_CPU;
            end
            DPE_ADDR_ETH_2: begin
               outp_sbuff.tuser_dst = DPE_ADDR_CPU;
            end
            DPE_ADDR_ETH_3: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_4;
            end
            DPE_ADDR_ETH_4: begin
               outp_sbuff.tuser_dst = DPE_ADDR_ETH_3;
            end
            default: begin
               outp_sbuff.tuser_dst = inp.tuser_dst;
            end
         endcase
      end else begin
         outp_sbuff.tuser_dst = inp.tuser_dst;
      end
   end

// Skid buffers
   dpe_if_skid_buffer skid_buffer_outp (
      .inp(outp_sbuff),
      .outp(outp)
   );
endmodule
