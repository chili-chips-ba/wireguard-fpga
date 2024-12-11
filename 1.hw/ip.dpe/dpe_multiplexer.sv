module dpe_multiplexer #(
    parameter TDATA_WIDTH = 128,
    parameter TUSER_WIDTH = 5
) (
    input  logic      clk,
    input  logic      rst,
    
    input  logic      pause,
    output logic      paused,
    
    dpe_if.s_axis     in0,
    dpe_if.s_axis     in1,
    dpe_if.s_axis     in2,
    dpe_if.s_axis     in3,
    dpe_if.s_axis     in4,
    dpe_if.m_axis     outp
);

    typedef enum logic [3:0] {
        IDLE,
        R0, S0,
        R1, S1,
        R2, S2,
        R3, S3,
        R4, S4
    } state_t;
    
    state_t state, next_state;
    
    logic                          s_tready;
    logic                          s_tvalid;
    logic [TDATA_WIDTH-1:0]        s_tdata;
    logic                          s_tlast;
    logic [(TDATA_WIDTH+7)/8-1:0]  s_tkeep;
    logic [TUSER_WIDTH-1:0]        s_tuser;
    logic                          s_out_tvalid;
    
    // FSM registers
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // FSM transition logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (!pause) next_state = R0;
            end
            
            R0: begin
                if (in0.tvalid && s_tready)         next_state = S0;
                else if (pause)                     next_state = IDLE;
                else if (!in0.tvalid && s_tready)   next_state = R1;
            end
            
            S0: begin
                if (in0.tlast && in0.tvalid && s_tready) begin
                    next_state = pause ? IDLE : R1;
                end
            end
            
            R1: begin
                if (in1.tvalid && s_tready)         next_state = S1;
                else if (pause)                     next_state = IDLE;
                else if (!in1.tvalid && s_tready)   next_state = R2;
            end
            
            S1: begin
                if (in1.tlast && in1.tvalid && s_tready) begin
                    next_state = pause ? IDLE : R2;
                end
            end
            
            R2: begin
                if (in2.tvalid && s_tready)         next_state = S2;
                else if (pause)                     next_state = IDLE;
                else if (!in2.tvalid && s_tready)   next_state = R3;
            end
            
            S2: begin
                if (in2.tlast && in2.tvalid && s_tready) begin
                    next_state = pause ? IDLE : R3;
                end
            end
            
            R3: begin
                if (in3.tvalid && s_tready)         next_state = S3;
                else if (pause)                     next_state = IDLE;
                else if (!in3.tvalid && s_tready)   next_state = R4;
            end
            
            S3: begin
                if (in3.tlast && in3.tvalid && s_tready) begin
                    next_state = pause ? IDLE : R4;
                end
            end
            
            R4: begin
                if (in4.tvalid && s_tready)         next_state = S4;
                else if (pause)                     next_state = IDLE;
                else if (!in4.tvalid && s_tready)   next_state = R0;
            end
            
            S4: begin
                if (in4.tlast && in4.tvalid && s_tready) begin
                    next_state = pause ? IDLE : R0;
                end
            end
            
            default:
                next_state = state;
        endcase
    end
    
    // Outputs logic
    always_comb begin
        // Default assignments
        paused = 0;
        s_tvalid = 0;
        s_tdata = '0;
        s_tlast = 0;
        s_tkeep = '0;
        s_tuser = '0;
        in0.tready = 0;
        in1.tready = 0;
        in2.tready = 0;
        in3.tready = 0;
        in4.tready = 0;
        
        case (state)
            IDLE: begin
                paused = !s_out_tvalid;
            end
            
            R0, S0: begin
                paused = 0;
                s_tvalid = in0.tvalid;
                s_tdata = in0.tdata;
                s_tlast = in0.tlast;
                s_tkeep = in0.tkeep;
                s_tuser = 5'b00001;
                in0.tready = s_tready;
            end
            
            R1, S1: begin
                paused = 0;
                s_tvalid = in1.tvalid;
                s_tdata = in1.tdata;
                s_tlast = in1.tlast;
                s_tkeep = in1.tkeep;
                s_tuser = 5'b00010;
                in1.tready = s_tready;
            end
            
            R2, S2: begin
                paused = 0;
                s_tvalid = in2.tvalid;
                s_tdata = in2.tdata;
                s_tlast = in2.tlast;
                s_tkeep = in2.tkeep;
                s_tuser = 5'b00100;
                in2.tready = s_tready;
            end
            
            R3, S3: begin
                paused = 0;
                s_tvalid = in3.tvalid;
                s_tdata = in3.tdata;
                s_tlast = in3.tlast;
                s_tkeep = in3.tkeep;
                s_tuser = 5'b01000;
                in3.tready = s_tready;
            end
            
            R4, S4: begin
                paused = 0;
                s_tvalid = in4.tvalid;
                s_tdata = in4.tdata;
                s_tlast = in4.tlast;
                s_tkeep = in4.tkeep;
                s_tuser = 5'b10000;
                in4.tready = s_tready;
            end
            
            default:
                paused = !s_out_tvalid;
        endcase
    end
    
    assign outp.tvalid = s_out_tvalid;
    
    // Skid buffer
    axis_register #(
        .DATA_WIDTH(TDATA_WIDTH),
        .USER_WIDTH(TUSER_WIDTH)
    ) sbuff (
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s_tvalid),
        .s_axis_tready(s_tready),
        .s_axis_tdata(s_tdata),
        .s_axis_tkeep(s_tkeep),
        .s_axis_tlast(s_tlast),
        .s_axis_tuser(s_tuser),
        .s_axis_tid('0),
        .s_axis_tdest('0),
        .m_axis_tvalid(s_out_tvalid),
        .m_axis_tready(outp.tready),
        .m_axis_tdata(outp.tdata),
        .m_axis_tkeep(outp.tkeep),
        .m_axis_tlast(outp.tlast),
        .m_axis_tuser(outp.tuser),
        .m_axis_tid(),
        .m_axis_tdest()
    );

endmodule
