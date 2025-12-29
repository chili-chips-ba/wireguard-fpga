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
//   Data Plane Engine
//==========================================================================

module dpe
   import csr_pkg::*;
(
   input  csr_pkg::csr__out_t from_csr,
   output csr_pkg::csr__in_t  to_csr,
   dpe_if.s_axis              from_cpu,
   dpe_if.s_axis              from_eth_1,
   dpe_if.s_axis              from_eth_2,
   dpe_if.s_axis              from_eth_3,
   dpe_if.s_axis              from_eth_4,
   dpe_if.m_axis              to_cpu,
   dpe_if.m_axis              to_eth_1,
   dpe_if.m_axis              to_eth_2,
   dpe_if.m_axis              to_eth_3,
   dpe_if.m_axis              to_eth_4
);
   import dpe_pkg::*;

   localparam int ENTRY_COUNT = 64; 
   
   dpe_if                     muxed_1 (.clk(from_cpu.clk), .rst(from_cpu.rst));
   dpe_if                     muxed_2 (.clk(from_cpu.clk), .rst(from_cpu.rst));

// DPE multiplexer
   dpe_multiplexer mux (
      .pause                 (from_csr.dpe.fcr.pause.value),
      .is_idle               (to_csr.dpe.fcr.idle.next),
      .from_cpu              (from_cpu),
      .from_eth_1            (from_eth_1),
      .from_eth_2            (from_eth_2),
      .from_eth_3            (from_eth_3),
      .from_eth_4            (from_eth_4),
      .to_dpe                (muxed_1)
   );

// DPE dummy switch
   dpe_dummy_switch switch (
      .inp                   (muxed_1),
      .outp                  (muxed_2)
   );

// DPE demultiplexer
   dpe_demultiplexer demux (
      .from_dpe              (muxed_2),
      .to_cpu                (to_cpu),
      .to_eth_1              (to_eth_1),
      .to_eth_2              (to_eth_2),
      .to_eth_3              (to_eth_3),
      .to_eth_4              (to_eth_4)
   );


// DPE egress Engine
//   dpe_egress_ip_lookup #(
//      .ENTRY_COUNT(ENTRY_COUNT)
//   ) u_egress (
//      .s_axis   (muxed_1),
//      .m_axis   (muxed_2),

//      .hwif_out (from_csr.dpe.routing_table),
//      .hwif_in  (to_csr.dpe.routing_table)
//   );

endmodule
