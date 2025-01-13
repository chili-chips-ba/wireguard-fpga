//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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

module dpe_top #(
    parameter TDATA_WIDTH = 128
) (
    input  logic      clk,
    input  logic      rst,
    
    input  logic      pause,
    output logic      is_idle,
    
    dpe_if.s_axis     inp0,
    dpe_if.s_axis     inp1,
    dpe_if.s_axis     inp2,
    dpe_if.s_axis     inp3,
    dpe_if.s_axis     inp4,
    dpe_if.m_axis     outp0,
    dpe_if.m_axis     outp1,
    dpe_if.m_axis     outp2,
    dpe_if.m_axis     outp3,
    dpe_if.m_axis     outp4
);
    dpe_if #(TDATA_WIDTH, 5) muxed();
    
    // DPE multiplexer
    dpe_multiplexer #(
        .TDATA_WIDTH(TDATA_WIDTH),
        .TUSER_WIDTH(5)
    ) mux (
        .clk(clk),
        .rst(rst),
        .pause(pause),
        .is_idle(is_idle),
        .inp0(inp0),
        .inp1(inp1),
        .inp2(inp2),
        .inp3(inp3),
        .inp4(inp4),
        .outp(muxed)
    );
    
    // DPE demultiplexer
    dpe_demultiplexer #(
        .TDATA_WIDTH(TDATA_WIDTH),
        .TUSER_WIDTH(5)
    ) demux (
        .clk(clk),
        .rst(rst),
        .inp(muxed),
        .outp0(outp0),
        .outp1(outp1),
        .outp2(outp2),
        .outp3(outp3),
        .outp4(outp4)
    );
endmodule
