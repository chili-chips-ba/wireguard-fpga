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
//   DPE Demultiplexer with multicast/broadcast support
//==========================================================================

module dpe_demultiplexer #(
    parameter TDATA_WIDTH = 128,
    parameter TUSER_WIDTH = 5
) (
    input  logic      clk,
    input  logic      rst,
    
    dpe_if.s_axis     inp,
	dpe_if.m_axis     outp0,
    dpe_if.m_axis     outp1,
    dpe_if.m_axis     outp2,
    dpe_if.m_axis     outp3,
    dpe_if.m_axis     outp4
);
    logic                          s0_tready;
    logic                          s0_tvalid;
    logic [TDATA_WIDTH-1:0]        s0_tdata;
    logic                          s0_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s0_tkeep;
	logic                          s1_tready;
    logic                          s1_tvalid;
    logic [TDATA_WIDTH-1:0]        s1_tdata;
    logic                          s1_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s1_tkeep;
	logic                          s2_tready;
    logic                          s2_tvalid;
    logic [TDATA_WIDTH-1:0]        s2_tdata;
    logic                          s2_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s2_tkeep;
	logic                          s3_tready;
    logic                          s3_tvalid;
    logic [TDATA_WIDTH-1:0]        s3_tdata;
    logic                          s3_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s3_tkeep;
	logic                          s4_tready;
    logic                          s4_tvalid;
    logic [TDATA_WIDTH-1:0]        s4_tdata;
    logic                          s4_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s4_tkeep;
	
	// Backpressure
	assign inp.tready = (!inp.tuser[0] | s0_tready) &
	                    (!inp.tuser[1] | s1_tready) &
						(!inp.tuser[2] | s2_tready) &
						(!inp.tuser[3] | s3_tready) &
						(!inp.tuser[4] | s4_tready);
	
	// Demultiplexer
	always_comb begin
		if (inp.tuser[0] == 1'b1) begin
			s0_tvalid = inp.tvalid;
			s0_tdata = inp.tdata;
			s0_tkeep = inp.tkeep;
			s0_tlast = inp.tlast;
		end else begin
			s0_tvalid = 1'b0;
			s0_tdata = '0;
			s0_tkeep = '0;
			s0_tlast = '0;
		end
		if (inp.tuser[1] == 1'b1) begin
			s1_tvalid = inp.tvalid;
			s1_tdata = inp.tdata;
			s1_tkeep = inp.tkeep;
			s1_tlast = inp.tlast;
		end else begin
			s1_tvalid = 1'b0;
			s1_tdata = '0;
			s1_tkeep = '0;
			s1_tlast = '0;
		end
		if (inp.tuser[2] == 1'b1) begin
			s2_tvalid = inp.tvalid;
			s2_tdata = inp.tdata;
			s2_tkeep = inp.tkeep;
			s2_tlast = inp.tlast;
		end else begin
			s2_tvalid = 1'b0;
			s2_tdata = '0;
			s2_tkeep = '0;
			s2_tlast = '0;
		end
		if (inp.tuser[3] == 1'b1) begin
			s3_tvalid = inp.tvalid;
			s3_tdata = inp.tdata;
			s3_tkeep = inp.tkeep;
			s3_tlast = inp.tlast;
		end else begin
			s3_tvalid = 1'b0;
			s3_tdata = '0;
			s3_tkeep = '0;
			s3_tlast = '0;
		end
		if (inp.tuser[4] == 1'b1) begin
			s4_tvalid = inp.tvalid;
			s4_tdata = inp.tdata;
			s4_tkeep = inp.tkeep;
			s4_tlast = inp.tlast;
		end else begin
			s4_tvalid = 1'b0;
			s4_tdata = '0;
			s4_tkeep = '0;
			s4_tlast = '0;
		end
	end
	
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH),
		.USER_ENABLE(0)
    ) sbuff0 (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s0_tvalid),
        .s_axis_tready(s0_tready),
        .s_axis_tdata(s0_tdata),
        .s_axis_tkeep(s0_tkeep),
        .s_axis_tlast(s0_tlast),
        .s_axis_tuser('0),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp0.tvalid),
        .m_axis_tready(outp0.tready),
        .m_axis_tdata(outp0.tdata),
        .m_axis_tkeep(outp0.tkeep),
        .m_axis_tlast(outp0.tlast),
        .m_axis_tuser(),
        .m_axis_tid(),
        .m_axis_tdest()
    );
	
	// Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH),
		.USER_ENABLE(0)
    ) sbuff1 (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s1_tvalid),
        .s_axis_tready(s1_tready),
        .s_axis_tdata(s1_tdata),
        .s_axis_tkeep(s1_tkeep),
        .s_axis_tlast(s1_tlast),
        .s_axis_tuser('0),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp1.tvalid),
        .m_axis_tready(outp1.tready),
        .m_axis_tdata(outp1.tdata),
        .m_axis_tkeep(outp1.tkeep),
        .m_axis_tlast(outp1.tlast),
        .m_axis_tuser(),
        .m_axis_tid(),
        .m_axis_tdest()
    );
	
	// Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH),
		.USER_ENABLE(0)
    ) sbuff2 (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s2_tvalid),
        .s_axis_tready(s2_tready),
        .s_axis_tdata(s2_tdata),
        .s_axis_tkeep(s2_tkeep),
        .s_axis_tlast(s2_tlast),
        .s_axis_tuser('0),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp2.tvalid),
        .m_axis_tready(outp2.tready),
        .m_axis_tdata(outp2.tdata),
        .m_axis_tkeep(outp2.tkeep),
        .m_axis_tlast(outp2.tlast),
        .m_axis_tuser(),
        .m_axis_tid(),
        .m_axis_tdest()
    );
	
	// Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH),
		.USER_ENABLE(0)
    ) sbuff3 (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s3_tvalid),
        .s_axis_tready(s3_tready),
        .s_axis_tdata(s3_tdata),
        .s_axis_tkeep(s3_tkeep),
        .s_axis_tlast(s3_tlast),
        .s_axis_tuser('0),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp3.tvalid),
        .m_axis_tready(outp3.tready),
        .m_axis_tdata(outp3.tdata),
        .m_axis_tkeep(outp3.tkeep),
        .m_axis_tlast(outp3.tlast),
        .m_axis_tuser(),
        .m_axis_tid(),
        .m_axis_tdest()
    );
	
	// Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH),
		.USER_ENABLE(0)
    ) sbuff4 (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s4_tvalid),
        .s_axis_tready(s4_tready),
        .s_axis_tdata(s4_tdata),
        .s_axis_tkeep(s4_tkeep),
        .s_axis_tlast(s4_tlast),
        .s_axis_tuser('0),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp4.tvalid),
        .m_axis_tready(outp4.tready),
        .m_axis_tdata(outp4.tdata),
        .m_axis_tkeep(outp4.tkeep),
        .m_axis_tlast(outp4.tlast),
        .m_axis_tuser(),
        .m_axis_tid(),
        .m_axis_tdest()
    );
endmodule
