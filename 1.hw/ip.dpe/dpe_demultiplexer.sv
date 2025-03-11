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
//   DPE demultiplexer with broadcast support
//==========================================================================

module dpe_demultiplexer (
   dpe_if.s_axis from_dpe,
   dpe_if.m_axis to_cpu,
   dpe_if.m_axis to_eth_1,
   dpe_if.m_axis to_eth_2,
   dpe_if.m_axis to_eth_3,
   dpe_if.m_axis to_eth_4
);
   import dpe_pkg::*;

   dpe_if from_dpe_sbuff (.clk(from_dpe.clk), .rst(from_dpe.rst));
   dpe_if to_cpu_sbuff   (.clk(from_dpe.clk), .rst(from_dpe.rst));
   dpe_if to_eth_1_sbuff (.clk(from_dpe.clk), .rst(from_dpe.rst));
   dpe_if to_eth_2_sbuff (.clk(from_dpe.clk), .rst(from_dpe.rst));
   dpe_if to_eth_3_sbuff (.clk(from_dpe.clk), .rst(from_dpe.rst));
   dpe_if to_eth_4_sbuff (.clk(from_dpe.clk), .rst(from_dpe.rst));

// Backpressure
   assign from_dpe_sbuff.tready = ((from_dpe_sbuff.tuser_dst != DPE_ADDR_CPU && from_dpe_sbuff.tuser_dst != DPE_ADDR_BCAST) | to_cpu_sbuff.tready) &
                                  ((from_dpe_sbuff.tuser_dst != DPE_ADDR_ETH_1 && from_dpe_sbuff.tuser_dst != DPE_ADDR_BCAST) | to_eth_1_sbuff.tready) &
                                  ((from_dpe_sbuff.tuser_dst != DPE_ADDR_ETH_2 && from_dpe_sbuff.tuser_dst != DPE_ADDR_BCAST) | to_eth_2_sbuff.tready) &
                                  ((from_dpe_sbuff.tuser_dst != DPE_ADDR_ETH_3 && from_dpe_sbuff.tuser_dst != DPE_ADDR_BCAST) | to_eth_3_sbuff.tready) &
                                  ((from_dpe_sbuff.tuser_dst != DPE_ADDR_ETH_4 && from_dpe_sbuff.tuser_dst != DPE_ADDR_BCAST) | to_eth_4_sbuff.tready);

// Demultiplexer
   always_comb begin
      if (from_dpe_sbuff.tuser_dst == DPE_ADDR_CPU || from_dpe_sbuff.tuser_dst == DPE_ADDR_BCAST) begin
         to_cpu_sbuff.tvalid = from_dpe_sbuff.tvalid;
         to_cpu_sbuff.tdata = from_dpe_sbuff.tdata;
         to_cpu_sbuff.tkeep = from_dpe_sbuff.tkeep;
         to_cpu_sbuff.tlast = from_dpe_sbuff.tlast;
         to_cpu_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
         to_cpu_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
         to_cpu_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
         to_cpu_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
      end else begin
         to_cpu_sbuff.tvalid = 1'b0;
         to_cpu_sbuff.tdata = '0;
         to_cpu_sbuff.tkeep = '0;
         to_cpu_sbuff.tlast = '0;
         to_cpu_sbuff.tuser_bypass_all = 1'b0;
         to_cpu_sbuff.tuser_bypass_stage = 1'b0;
         to_cpu_sbuff.tuser_src = '0;
         to_cpu_sbuff.tuser_dst = '0;
      end
      if (from_dpe_sbuff.tuser_dst == DPE_ADDR_ETH_1 || from_dpe_sbuff.tuser_dst == DPE_ADDR_BCAST) begin
         to_eth_1_sbuff.tvalid = from_dpe_sbuff.tvalid;
         to_eth_1_sbuff.tdata = from_dpe_sbuff.tdata;
         to_eth_1_sbuff.tkeep = from_dpe_sbuff.tkeep;
         to_eth_1_sbuff.tlast = from_dpe_sbuff.tlast;
         to_eth_1_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
         to_eth_1_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
         to_eth_1_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
         to_eth_1_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
      end else begin
         to_eth_1_sbuff.tvalid = 1'b0;
         to_eth_1_sbuff.tdata = '0;
         to_eth_1_sbuff.tkeep = '0;
         to_eth_1_sbuff.tlast = '0;
         to_eth_1_sbuff.tuser_bypass_all = 1'b0;
         to_eth_1_sbuff.tuser_bypass_stage = 1'b0;
         to_eth_1_sbuff.tuser_src = '0;
         to_eth_1_sbuff.tuser_dst = '0;
      end
      if (from_dpe_sbuff.tuser_dst == DPE_ADDR_ETH_2 || from_dpe_sbuff.tuser_dst == DPE_ADDR_BCAST) begin
         to_eth_2_sbuff.tvalid = from_dpe_sbuff.tvalid;
         to_eth_2_sbuff.tdata = from_dpe_sbuff.tdata;
         to_eth_2_sbuff.tkeep = from_dpe_sbuff.tkeep;
         to_eth_2_sbuff.tlast = from_dpe_sbuff.tlast;
         to_eth_2_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
         to_eth_2_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
         to_eth_2_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
         to_eth_2_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
      end else begin
         to_eth_2_sbuff.tvalid = 1'b0;
         to_eth_2_sbuff.tdata = '0;
         to_eth_2_sbuff.tkeep = '0;
         to_eth_2_sbuff.tlast = '0;
         to_eth_2_sbuff.tuser_bypass_all = 1'b0;
         to_eth_2_sbuff.tuser_bypass_stage = 1'b0;
         to_eth_2_sbuff.tuser_src = '0;
         to_eth_2_sbuff.tuser_dst = '0;
      end
      if (from_dpe_sbuff.tuser_dst == DPE_ADDR_ETH_3 || from_dpe_sbuff.tuser_dst == DPE_ADDR_BCAST) begin
         to_eth_3_sbuff.tvalid = from_dpe_sbuff.tvalid;
         to_eth_3_sbuff.tdata = from_dpe_sbuff.tdata;
         to_eth_3_sbuff.tkeep = from_dpe_sbuff.tkeep;
         to_eth_3_sbuff.tlast = from_dpe_sbuff.tlast;
         to_eth_3_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
         to_eth_3_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
         to_eth_3_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
         to_eth_3_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
      end else begin
         to_eth_3_sbuff.tvalid = 1'b0;
         to_eth_3_sbuff.tdata = '0;
         to_eth_3_sbuff.tkeep = '0;
         to_eth_3_sbuff.tlast = '0;
         to_eth_3_sbuff.tuser_bypass_all = 1'b0;
         to_eth_3_sbuff.tuser_bypass_stage = 1'b0;
         to_eth_3_sbuff.tuser_src = '0;
         to_eth_3_sbuff.tuser_dst = '0;
      end
      if (from_dpe_sbuff.tuser_dst == DPE_ADDR_ETH_4 || from_dpe_sbuff.tuser_dst == DPE_ADDR_BCAST) begin
         to_eth_4_sbuff.tvalid = from_dpe_sbuff.tvalid;
         to_eth_4_sbuff.tdata = from_dpe_sbuff.tdata;
         to_eth_4_sbuff.tkeep = from_dpe_sbuff.tkeep;
         to_eth_4_sbuff.tlast = from_dpe_sbuff.tlast;
         to_eth_4_sbuff.tuser_bypass_all = from_dpe_sbuff.tuser_bypass_all;
         to_eth_4_sbuff.tuser_bypass_stage = from_dpe_sbuff.tuser_bypass_stage;
         to_eth_4_sbuff.tuser_src = from_dpe_sbuff.tuser_src;
         to_eth_4_sbuff.tuser_dst = from_dpe_sbuff.tuser_dst;
      end else begin
         to_eth_4_sbuff.tvalid = 1'b0;
         to_eth_4_sbuff.tdata = '0;
         to_eth_4_sbuff.tkeep = '0;
         to_eth_4_sbuff.tlast = '0;
         to_eth_4_sbuff.tuser_bypass_all = 1'b0;
         to_eth_4_sbuff.tuser_bypass_stage = 1'b0;
         to_eth_4_sbuff.tuser_src = '0;
         to_eth_4_sbuff.tuser_dst = '0;
      end
   end

// Skid buffers
   dpe_if_skid_buffer skid_buffer_from_dpe (
      .inp(from_dpe),
      .outp(from_dpe_sbuff)
   );
   
   dpe_if_skid_buffer skid_buffer_to_cpu (
      .inp(to_cpu_sbuff),
      .outp(to_cpu)
   );
   
   dpe_if_skid_buffer skid_buffer_to_eth_1 (
      .inp(to_eth_1_sbuff),
      .outp(to_eth_1)
   );
   
   dpe_if_skid_buffer skid_buffer_to_eth_2 (
      .inp(to_eth_2_sbuff),
      .outp(to_eth_2)
   );
   
   dpe_if_skid_buffer skid_buffer_to_eth_3 (
      .inp(to_eth_3_sbuff),
      .outp(to_eth_3)
   );
   
   dpe_if_skid_buffer skid_buffer_to_eth_4 (
      .inp(to_eth_4_sbuff),
      .outp(to_eth_4)
   );
endmodule
