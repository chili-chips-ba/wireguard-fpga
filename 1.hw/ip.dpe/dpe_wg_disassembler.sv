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
//                        |---------------------------------------->
//                        |                                is_idle
//                     --------
//   inp               |      |----------|
//  ------------------>| FSMD |          |
//      |              |      |----|    \v
//      |              --------    |----|\         ----------
//      |                 ^             | |        |  SKID  |
//      |  ------------   |             | |--------| BUFFER |------>
//      |  | PIPELINE |   |             | | s_outp | DEPTH=1| outp
//      |->|  BUFFER  |-----------------|/         ----------
//         |  DEPTH=3 | s_inp           /
//         ------------                 MUX
//==========================================================================

module dpe_wg_disassembler (
    input  logic      clk,
    input  logic      rst,
    
    output logic      is_idle,
    
    dpe_if.s_axis     inp,
    dpe_if.m_axis     outp
);
    localparam TDATA_WIDTH = 128;
    localparam INP_TUSER_WIDTH = 5;
    localparam OUTP_TUSER_WIDTH = 128;
    
    localparam PROT_IP = 16'h0008;
    localparam PROT_IPv4 = 4'h4;
    localparam PROT_UDP = 8'h11;
    localparam PROT_WG = 16'h6cca;
    localparam PROT_WGD = 8'h04;
    
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
    state_t state, next_state;
    logic [31:0] wg_rcv, next_wg_rcv;
    logic [63:0] wg_cnt, next_wg_cnt;
    logic [47:0] wg_enp, next_wg_enp;
    
    // Internal wires
    dpe_if #(TDATA_WIDTH, INP_TUSER_WIDTH) s_inp();
    dpe_if #(TDATA_WIDTH, OUTP_TUSER_WIDTH) s_outp();
    
    // FSM registers
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            wg_rcv <= '0;
            wg_cnt <= '0;
            wg_enp <= '0;
        end else begin
            state <= next_state;
            wg_rcv <= next_wg_rcv;
            wg_cnt <= next_wg_cnt;
            wg_enp <= next_wg_enp;
        end
    end
    
    // FSM transition logic
    always_comb begin
        next_state = state;
        next_wg_rcv = wg_rcv;
        next_wg_cnt = wg_cnt;
        next_wg_enp = wg_enp;
        
        case (state)
            IDLE: begin
                if (inp.tvalid && inp.tready && (inp.tdata[111:96] == PROT_IP) && (inp.tdata[119:116] == PROT_IPv4)) begin
                    next_state = HEADER_1;
                end else if (inp.tvalid && inp.tready) begin
                    next_state = BYPASS_1;
                end
            end
            
            HEADER_1: begin
                if (inp.tvalid && inp.tready && (inp.tdata[63:56] == PROT_UDP)) begin
                    next_state = HEADER_2;
                end else if (inp.tvalid && inp.tready) begin
                    next_state = BYPASS_2;
                end
            end
            
            HEADER_2: begin
                if (inp.tvalid && inp.tready && ((inp.tdata[47:32] == PROT_WG) || (inp.tdata[31:16] == PROT_WG)) && (inp.tdata[87:80] == PROT_WGD)) begin
                    next_state = PAYLOAD_1;
                    next_wg_rcv[15:0] = inp.tdata[127:112];
                end else if (inp.tvalid && inp.tready) begin
                    next_state = BYPASS_3;
                end
            end
            
            BYPASS_1: begin
                if (inp.tvalid && inp.tready) begin
                    next_state = BYPASS_2;
                end
            end
            
            BYPASS_2: begin
                if (inp.tvalid && inp.tready) begin
                    next_state = BYPASS_3;
                end
            end
            
            BYPASS_3: begin
                if (inp.tvalid && inp.tready && inp.tlast) begin
                    next_state = IDLE;
                end
            end
            
            PAYLOAD_1: begin
                if (inp.tvalid && inp.tready) begin
                    next_state = PAYLOAD_2;
                    next_wg_rcv[31:16] = inp.tdata[15:0];
                    next_wg_cnt = inp.tdata[79:16];
                end
            end
            
            PAYLOAD_2: begin
                if (inp.tvalid && inp.tready) begin
                    next_state = PAYLOAD_3;
                end
            end
            
            PAYLOAD_3: begin
                if (s_inp.tvalid && s_inp.tready) begin
                    next_state = PAYLOAD_4;
                end
            end
            
            PAYLOAD_4: begin
                if (s_inp.tvalid && s_inp.tready && s_inp.tlast) begin
                    next_state = IDLE;
                    next_wg_enp = s_inp.tdata[127:80];
                end else if (s_inp.tvalid && s_inp.tready) begin
                    next_state = PAYLOAD_5;
                    next_wg_enp = s_inp.tdata[127:80];
                end
            end
            
            PAYLOAD_5: begin
                if (s_inp.tvalid && s_inp.tready && s_inp.tlast) begin
                    next_state = IDLE;
                    next_wg_enp = s_inp.tdata[127:80];
                end else if (s_inp.tvalid && s_inp.tready) begin
                    next_wg_enp = s_inp.tdata[127:80];
                end
            end
            
            default: begin
                next_state = state;
                next_wg_rcv = wg_rcv;
                next_wg_cnt = wg_cnt;
                next_wg_enp = wg_enp;
            end
        endcase
    end
    
    // Outputs logic
    always_comb begin
        s_outp.tvalid = 0;
        s_outp.tdata = '0;
        s_outp.tkeep = '0;
        s_outp.tlast = 0;
        s_outp.tuser = '0;
        case (state)
            IDLE, HEADER_1, HEADER_2, BYPASS_1, BYPASS_2, BYPASS_3: begin
                s_outp.tvalid = s_inp.tvalid;
                s_outp.tdata = s_inp.tdata;
                s_outp.tkeep = s_inp.tkeep;
                s_outp.tlast = s_inp.tlast;
                s_outp.tuser[4:0] = s_inp.tuser;
            end

            PAYLOAD_5: begin
                s_outp.tvalid = s_inp.tvalid;
                s_outp.tdata[127:48] = s_inp.tdata[79:0];
                s_outp.tdata[47:0] = wg_enp;
                s_outp.tkeep = '1;
                s_outp.tlast = s_inp.tlast;
                s_outp.tuser[127:96] = wg_rcv;
                s_outp.tuser[95:32] = wg_cnt;
                s_outp.tuser[5] = 1;
                s_outp.tuser[4:0] = s_inp.tuser;
            end
            
            default: begin
                s_outp.tvalid = 0;
                s_outp.tdata = '0;
                s_outp.tkeep = '0;
                s_outp.tlast = 0;
                s_outp.tuser = '0;
            end
        endcase
    end
    assign s_inp.tready = s_outp.tready;
    assign is_idle = (state == IDLE) & !outp.tvalid;
    
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
        .m_axis_tvalid(s_inp.tvalid),
        .m_axis_tready(s_inp.tready),
        .m_axis_tdata(s_inp.tdata),
        .m_axis_tkeep(s_inp.tkeep),
        .m_axis_tlast(s_inp.tlast),
        .m_axis_tuser(s_inp.tuser),
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
        .s_axis_tvalid(s_outp.tvalid),
        .s_axis_tready(s_outp.tready),
        .s_axis_tdata(s_outp.tdata),
        .s_axis_tkeep(s_outp.tkeep),
        .s_axis_tlast(s_outp.tlast),
        .s_axis_tuser(s_outp.tuser),
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
