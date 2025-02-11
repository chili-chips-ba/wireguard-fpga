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
    input  logic  sys_clk,
    input  logic  sys_rst,
    
    dpe_if.s_axis from_dpe,
    dpe_if.m_axis to_cpu,
    dpe_if.m_axis to_eth_1,
    dpe_if.m_axis to_eth_2,
    dpe_if.m_axis to_eth_3,
    dpe_if.m_axis to_eth_4
);
    import dpe_pkg::*;
    
    dpe_if from_dpe_sbuff(.clk(sys_clk), .rst(sys_rst));
    dpe_if to_cpu_sbuff(.clk(sys_clk), .rst(sys_rst));
    dpe_if to_eth_1_sbuff(.clk(sys_clk), .rst(sys_rst));
    dpe_if to_eth_2_sbuff(.clk(sys_clk), .rst(sys_rst));
    dpe_if to_eth_3_sbuff(.clk(sys_clk), .rst(sys_rst));
    dpe_if to_eth_4_sbuff(.clk(sys_clk), .rst(sys_rst));
        
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
            to_cpu_sbuff.tuser_bypass_all = 0;
            to_cpu_sbuff.tuser_bypass_stage = 0;
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
            to_eth_1_sbuff.tuser_bypass_all = 0;
            to_eth_1_sbuff.tuser_bypass_stage = 0;
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
            to_eth_2_sbuff.tuser_bypass_all = 0;
            to_eth_2_sbuff.tuser_bypass_stage = 0;
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
            to_eth_3_sbuff.tuser_bypass_all = 0;
            to_eth_3_sbuff.tuser_bypass_stage = 0;
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
            to_eth_4_sbuff.tuser_bypass_all = 0;
            to_eth_4_sbuff.tuser_bypass_stage = 0;
            to_eth_4_sbuff.tuser_src = '0;
            to_eth_4_sbuff.tuser_dst = '0;
        end
    end
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_dpe (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(from_dpe.tvalid),
        .s_axis_tready(from_dpe.tready),
        .s_axis_tdata(from_dpe.tdata),
        .s_axis_tkeep(from_dpe.tkeep),
        .s_axis_tlast(from_dpe.tlast),
        .s_axis_tuser({from_dpe.tuser_bypass_all,from_dpe.tuser_bypass_stage,from_dpe.tuser_src,from_dpe.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(from_dpe_sbuff.tvalid),
        .m_axis_tready(from_dpe_sbuff.tready),
        .m_axis_tdata(from_dpe_sbuff.tdata),
        .m_axis_tkeep(from_dpe_sbuff.tkeep),
        .m_axis_tlast(from_dpe_sbuff.tlast),
        .m_axis_tuser({from_dpe_sbuff.tuser_bypass_all,from_dpe_sbuff.tuser_bypass_stage,from_dpe_sbuff.tuser_src,from_dpe_sbuff.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_cpu (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(to_cpu_sbuff.tvalid),
        .s_axis_tready(to_cpu_sbuff.tready),
        .s_axis_tdata(to_cpu_sbuff.tdata),
        .s_axis_tkeep(to_cpu_sbuff.tkeep),
        .s_axis_tlast(to_cpu_sbuff.tlast),
        .s_axis_tuser({to_cpu_sbuff.tuser_bypass_all,to_cpu_sbuff.tuser_bypass_stage,to_cpu_sbuff.tuser_src,to_cpu_sbuff.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(to_cpu.tvalid),
        .m_axis_tready(to_cpu.tready),
        .m_axis_tdata(to_cpu.tdata),
        .m_axis_tkeep(to_cpu.tkeep),
        .m_axis_tlast(to_cpu.tlast),
        .m_axis_tuser({to_cpu.tuser_bypass_all,to_cpu.tuser_bypass_stage,to_cpu.tuser_src,to_cpu.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_eth_1 (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(to_eth_1_sbuff.tvalid),
        .s_axis_tready(to_eth_1_sbuff.tready),
        .s_axis_tdata(to_eth_1_sbuff.tdata),
        .s_axis_tkeep(to_eth_1_sbuff.tkeep),
        .s_axis_tlast(to_eth_1_sbuff.tlast),
        .s_axis_tuser({to_eth_1_sbuff.tuser_bypass_all,to_eth_1_sbuff.tuser_bypass_stage,to_eth_1_sbuff.tuser_src,to_eth_1_sbuff.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(to_eth_1.tvalid),
        .m_axis_tready(to_eth_1.tready),
        .m_axis_tdata(to_eth_1.tdata),
        .m_axis_tkeep(to_eth_1.tkeep),
        .m_axis_tlast(to_eth_1.tlast),
        .m_axis_tuser({to_eth_1.tuser_bypass_all,to_eth_1.tuser_bypass_stage,to_eth_1.tuser_src,to_eth_1.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_eth_2 (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(to_eth_2_sbuff.tvalid),
        .s_axis_tready(to_eth_2_sbuff.tready),
        .s_axis_tdata(to_eth_2_sbuff.tdata),
        .s_axis_tkeep(to_eth_2_sbuff.tkeep),
        .s_axis_tlast(to_eth_2_sbuff.tlast),
        .s_axis_tuser({to_eth_2_sbuff.tuser_bypass_all,to_eth_2_sbuff.tuser_bypass_stage,to_eth_2_sbuff.tuser_src,to_eth_2_sbuff.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(to_eth_2.tvalid),
        .m_axis_tready(to_eth_2.tready),
        .m_axis_tdata(to_eth_2.tdata),
        .m_axis_tkeep(to_eth_2.tkeep),
        .m_axis_tlast(to_eth_2.tlast),
        .m_axis_tuser({to_eth_2.tuser_bypass_all,to_eth_2.tuser_bypass_stage,to_eth_2.tuser_src,to_eth_2.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_eth_3 (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(to_eth_3_sbuff.tvalid),
        .s_axis_tready(to_eth_3_sbuff.tready),
        .s_axis_tdata(to_eth_3_sbuff.tdata),
        .s_axis_tkeep(to_eth_3_sbuff.tkeep),
        .s_axis_tlast(to_eth_3_sbuff.tlast),
        .s_axis_tuser({to_eth_3_sbuff.tuser_bypass_all,to_eth_3_sbuff.tuser_bypass_stage,to_eth_3_sbuff.tuser_src,to_eth_3_sbuff.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(to_eth_3.tvalid),
        .m_axis_tready(to_eth_3.tready),
        .m_axis_tdata(to_eth_3.tdata),
        .m_axis_tkeep(to_eth_3.tkeep),
        .m_axis_tlast(to_eth_3.tlast),
        .m_axis_tuser({to_eth_3.tuser_bypass_all,to_eth_3.tuser_bypass_stage,to_eth_3.tuser_src,to_eth_3.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(128),
        .USER_WIDTH(8)
    ) sbuff_eth_4 (
        .clk(sys_clk),
        .rst(sys_rst),
        .s_axis_tvalid(to_eth_4_sbuff.tvalid),
        .s_axis_tready(to_eth_4_sbuff.tready),
        .s_axis_tdata(to_eth_4_sbuff.tdata),
        .s_axis_tkeep(to_eth_4_sbuff.tkeep),
        .s_axis_tlast(to_eth_4_sbuff.tlast),
        .s_axis_tuser({to_eth_4_sbuff.tuser_bypass_all,to_eth_4_sbuff.tuser_bypass_stage,to_eth_4_sbuff.tuser_src,to_eth_4_sbuff.tuser_dst}),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(to_eth_4.tvalid),
        .m_axis_tready(to_eth_4.tready),
        .m_axis_tdata(to_eth_4.tdata),
        .m_axis_tkeep(to_eth_4.tkeep),
        .m_axis_tlast(to_eth_4.tlast),
        .m_axis_tuser({to_eth_4.tuser_bypass_all,to_eth_4.tuser_bypass_stage,to_eth_4.tuser_src,to_eth_4.tuser_dst}),
        .m_axis_tid(),
        .m_axis_tdest()
    );
endmodule
