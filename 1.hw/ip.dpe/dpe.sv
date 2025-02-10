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
//   DPE top-level module
//==========================================================================

module dpe (
    input  logic  sys_clk,
    input  logic  sys_rst,
    
    input  logic  pause,
    output logic  is_idle,
    
    dpe_if.s_axis from_cpu,
    dpe_if.s_axis from_eth_1,
    dpe_if.s_axis from_eth_2,
    dpe_if.s_axis from_eth_3,
    dpe_if.s_axis from_eth_4,
    dpe_if.m_axis to_cpu,
    dpe_if.m_axis to_eth_1,
    dpe_if.m_axis to_eth_2,
    dpe_if.m_axis to_eth_3,
    dpe_if.m_axis to_eth_4
);
    dpe_if muxed(.clk(sys_clk), .rst(sys_rst));
    
    // DPE multiplexer
    dpe_multiplexer mux (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .pause(pause),
        .is_idle(is_idle),
        .from_cpu(from_cpu),
        .from_eth_1(from_eth_1),
        .from_eth_2(from_eth_2),
        .from_eth_3(from_eth_3),
        .from_eth_4(from_eth_4),
        .to_dpe(muxed)
    );
    
    // DPE demultiplexer
    dpe_demultiplexer demux (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .from_dpe(muxed),
        .to_cpu(to_cpu),
        .to_eth_1(to_eth_1),
        .to_eth_2(to_eth_2),
        .to_eth_3(to_eth_3),
        .to_eth_4(to_eth_4)
    );
endmodule
