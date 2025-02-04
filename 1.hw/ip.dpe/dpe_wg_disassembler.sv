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
//   DPE WireGuard Disassembler
//
//  ---------------------. .--------------------------------------->
//   wg_idx              | |                                wg_rcv
//  -------------------. | | .------------------------------------->
//   wg_match          | | | |                            fcr_idle
//                     v v v v
//                    .-------.
//   inp              |       |----------.
//  ----+------------>| FSMD  |          |
//      |             |       |----.    \v
//      |             '-------'    '--->|\         .--------.
//      |                 ^             | |        |  SKID  |
//      |  .----------.   |             | |------->| BUFFER |------>
//      |  | PIPELINE |   |             | | muxed  | DEPTH=1| outp
//      '->|  BUFFER  |---+------------>|/         '--------'
//         |  DEPTH=3 | piped           /
//         '----------'                 MUX
//==========================================================================

module dpe_wg_disassembler (
    input  logic        clk,
    input  logic        rst,
    
    output logic        fcr_idle,
	
	output logic [31:0] wg_rcv,
	input  logic [6:0]  wg_idx,
	input  logic        wg_idx_match,
    
    dpe_if.s_axis       inp,
    dpe_if.m_axis       outp
);
    localparam TDATA_WIDTH = 128;
    localparam INP_TUSER_WIDTH = 5;
    localparam OUTP_TUSER_WIDTH = 128;
    
    localparam PROT_IP = 16'h0008;
    localparam PROT_IPv4 = 4'h4;
    localparam PROT_UDP = 8'h11;
    localparam PROT_WG = 32'h00000004;
    
    typedef enum logic [3:0] {
        IDLE,
        HEADER_1,
        HEADER_2,
        BYPASS_1,
        BYPASS_2,
        BYPASS_3,
        PAYLOAD_1,
        PAYLOAD_2,
        PAYLOAD_3,
        PAYLOAD_4,
        PAYLOAD_5
    } state_t;
    
    // Internal states
    state_t state_reg, state_next;
    logic [31:0] wg_rcv_reg, wg_rcv_next;
    logic [63:0] wg_cnt_reg, wg_cnt_next;
    logic [47:0] wg_enp_reg, wg_enp_next;
    
    // Internal wires
    dpe_if #(TDATA_WIDTH, INP_TUSER_WIDTH) piped();
    dpe_if #(TDATA_WIDTH, OUTP_TUSER_WIDTH) muxed();
    
    // FSM registers
    always_ff @(posedge clk) begin
        if (rst) begin
            state_reg <= IDLE;
            wg_rcv_reg <= '0;
            wg_cnt_reg <= '0;
            wg_enp_reg <= '0;
        end else begin
            state_reg <= state_next;
            wg_rcv_reg <= wg_rcv_next;
            wg_cnt_reg <= wg_cnt_next;
            wg_enp_reg <= wg_enp_next;
        end
    end
    
    // FSM transition logic
    always_comb begin
        state_next = state_reg;
        wg_rcv_next = wg_rcv_reg;
        wg_cnt_next = wg_cnt_reg;
        wg_enp_next = wg_enp_reg;
        
        case (state)
            IDLE: begin
                if (inp.tvalid && inp.tready && (inp.tdata[111:96] == PROT_IP) && (inp.tdata[119:116] == PROT_IPv4)) begin
                    state_next = HEADER_1;
                end else if (inp.tvalid && inp.tready) begin
                    state_next = BYPASS_1;
                end
            end
            
            HEADER_1: begin
                if (inp.tvalid && inp.tready && (inp.tdata[63:56] == PROT_UDP)) begin
                    state_next = HEADER_2;
                end else if (inp.tvalid && inp.tready) begin
                    state_next = BYPASS_2;
                end
            end
            
            HEADER_2: begin
                if (inp.tvalid && inp.tready && (inp.tdata[111:80] == PROT_WG)) begin
                    state_next = PAYLOAD_1;
                    wg_rcv_next[15:0] = inp.tdata[127:112];
                end else if (inp.tvalid && inp.tready) begin
                    state_next = BYPASS_3;
                end
            end
            
            BYPASS_1: begin
                if (inp.tvalid && inp.tready) begin
                    state_next = BYPASS_2;
                end
            end
            
            BYPASS_2: begin
                if (inp.tvalid && inp.tready) begin
                    state_next = BYPASS_3;
                end
            end
            
            BYPASS_3: begin
                if (inp.tvalid && inp.tready && inp.tlast) begin
                    state_next = IDLE;
                end
            end
            
            PAYLOAD_1: begin
                if (inp.tvalid && inp.tready) begin
                    state_next = PAYLOAD_2;
                    wg_rcv_next[31:16] = inp.tdata[15:0];
                    wg_cnt_next = inp.tdata[79:16];
                end
            end
            
            PAYLOAD_2: begin
                if (inp.tvalid && inp.tready) begin
                    state_next = PAYLOAD_3;
                end
            end
            
            PAYLOAD_3: begin
                if (piped.tvalid && piped.tready) begin
                    state_next = PAYLOAD_4;
                end
            end
            
            PAYLOAD_4: begin
                if (piped.tvalid && piped.tready && piped.tlast) begin
                    state_next = IDLE;
                    wg_enp_next = piped.tdata[127:80];
                end else if (piped.tvalid && piped.tready) begin
                    state_next = PAYLOAD_5;
                    wg_enp_next = piped.tdata[127:80];
                end
            end
            
            PAYLOAD_5: begin
                if (piped.tvalid && piped.tready && piped.tlast) begin
                    state_next = IDLE;
                    wg_enp_next = piped.tdata[127:80];
                end else if (piped.tvalid && piped.tready) begin
                    wg_enp_next = piped.tdata[127:80];
                end
            end
            
            default: begin
                state_next = state_reg;
                wg_rcv_next = wg_rcv_reg;
                wg_cnt_next = wg_cnt_reg;
                wg_enp_next = wg_enp_reg;
            end
        endcase
    end
    
    // Outputs logic
    always_comb begin
        muxed.tvalid = 0;
        muxed.tdata = '0;
        muxed.tkeep = '0;
        muxed.tlast = 0;
        muxed.tuser = '0;
        case (state)
            IDLE, HEADER_1, HEADER_2, BYPASS_1, BYPASS_2, BYPASS_3: begin
                muxed.tvalid = piped.tvalid;
                muxed.tdata = piped.tdata;
                muxed.tkeep = piped.tkeep;
                muxed.tlast = piped.tlast;
                muxed.tuser[4:0] = piped.tuser;
            end

            PAYLOAD_5: begin
                muxed.tvalid = piped.tvalid;
                muxed.tdata[127:48] = piped.tdata[79:0];
                muxed.tdata[47:0] = wg_enp_reg;
                muxed.tkeep = '1;
                muxed.tlast = piped.tlast;
                muxed.tuser[127:96] = wg_rcv_reg;
                muxed.tuser[95:32] = wg_cnt_reg;
                muxed.tuser[5] = 1;
                muxed.tuser[4:0] = piped.tuser;
            end
            
            default: begin
                muxed.tvalid = 0;
                muxed.tdata = '0;
                muxed.tkeep = '0;
                muxed.tlast = 0;
                muxed.tuser = '0;
            end
        endcase
    end
    assign piped.tready = muxed.tready;
    assign fcr_idle = (state == IDLE) & !outp.tvalid;
    
    // Packet pipeline
    axis_pipeline_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(INP_TUSER_WIDTH),
        .LENGTH(3),
        .REG_TYPE(2)
    ) pipeline (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(inp.tvalid),
        .s_axis_tready(inp.tready),
        .s_axis_tdata(inp.tdata),
        .s_axis_tkeep(inp.tkeep),
        .s_axis_tlast(inp.tlast),
        .s_axis_tuser(inp.tuser),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(piped.tvalid),
        .m_axis_tready(piped.tready),
        .m_axis_tdata(piped.tdata),
        .m_axis_tkeep(piped.tkeep),
        .m_axis_tlast(piped.tlast),
        .m_axis_tuser(piped.tuser),
        .m_axis_tid(),
        .m_axis_tdest()
    );
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(OUTP_TUSER_WIDTH)
    ) sbuff (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(muxed.tvalid),
        .s_axis_tready(muxed.tready),
        .s_axis_tdata(muxed.tdata),
        .s_axis_tkeep(muxed.tkeep),
        .s_axis_tlast(muxed.tlast),
        .s_axis_tuser(muxed.tuser),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(outp.tvalid),
        .m_axis_tready(outp.tready),
        .m_axis_tdata(outp.tdata),
        .m_axis_tkeep(outp.tkeep),
        .m_axis_tlast(outp.tlast),
        .m_axis_tuser(outp.tuser),
        .m_axis_tid(),
        .m_axis_tdest()
    );
endmodule
