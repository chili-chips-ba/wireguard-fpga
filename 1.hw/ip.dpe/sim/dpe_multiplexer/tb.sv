`timescale 1ps/1ps
//`include "../../dpe_if.sv"

module tb;
    // Constants
    localparam CLK_PERIOD = 12_500;
    localparam DATA_WIDTH = 128;
    localparam KEEP_WIDTH = DATA_WIDTH/8;
    localparam USER_WIDTH = 5;
    
    // Clock and reset signals
    logic clk = 0;
    logic rst = 1;
    logic pause = 0;
    logic paused;
    
    // Interfaces
    dpe_if #(DATA_WIDTH, USER_WIDTH) in0();
    dpe_if #(DATA_WIDTH, USER_WIDTH) in1();
    dpe_if #(DATA_WIDTH, USER_WIDTH) in2();
    dpe_if #(DATA_WIDTH, USER_WIDTH) in3();
    dpe_if #(DATA_WIDTH, USER_WIDTH) in4();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp();
    
    // Test data type and constants
    typedef logic [7:0] test_data_t [6];
    typedef test_data_t packet_data_t [5];
    
    const packet_data_t packet_data = '{
        '{8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06},  // Input 0
        '{8'h0B, 8'h0C, 8'h0D, 8'h0E, 8'h00, 8'h00},  // Input 1
        '{8'h15, 8'h16, 8'h17, 8'h18, 8'h19, 8'h00},  // Input 2
        '{8'h1F, 8'h20, 8'h21, 8'h22, 8'h00, 8'h00},  // Input 3
        '{8'h29, 8'h2A, 8'h2B, 8'h2C, 8'h00, 8'h00}   // Input 4
    };
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // DUT instantiation
    dpe_multiplexer #(
        .TDATA_WIDTH(DATA_WIDTH),
        .TUSER_WIDTH(USER_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .pause(pause),
        .paused(paused),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .outp(outp)
    );
    
    // Main stimulus process
    initial begin
        // Initialize all input interfaces
        in0.tvalid = 0;
        in0.tlast = 0;
        in0.tkeep = '0;
        in0.tdata = '0;
        
        in1.tvalid = 0;
        in1.tlast = 0;
        in1.tkeep = '0;
        in1.tdata = '0;
        
        in2.tvalid = 0;
        in2.tlast = 0;
        in2.tkeep = '0;
        in2.tdata = '0;
        
        in3.tvalid = 0;
        in3.tlast = 0;
        in3.tkeep = '0;
        in3.tdata = '0;
        
        in4.tvalid = 0;
        in4.tlast = 0;
        in4.tkeep = '0;
        in4.tdata = '0;
        
        // Reset assertion
        #(CLK_PERIOD * 4);
        @(posedge clk);
        #1ps;
        rst = 0;
        #(CLK_PERIOD);
        
        // Start all stimulus processes in parallel
        fork
            // Input 0 stimulus
            begin
                @(posedge clk);
                #1ps;
                in0.tvalid = 1;
                for (int i = 0; i < 6; i++) begin
                    in0.tdata = '0;
                    in0.tdata[7:0] = packet_data[0][i];
                    in0.tkeep = '1;
                    in0.tlast = (i == 5);
                    @(posedge clk);
                    while (!in0.tready) @(posedge clk);
                    #1ps;
                end
                in0.tvalid = 0;
                in0.tlast = 0;
            end
            
            // Input 1 stimulus
            begin
                @(posedge clk);
                #1ps;
                in1.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    in1.tdata = '0;
                    in1.tdata[7:0] = packet_data[1][i];
                    in1.tkeep = '1;
                    in1.tlast = (i == 3);
                    @(posedge clk);                    
                    while (!in1.tready) @(posedge clk);
                    #1ps;
                end
                in1.tvalid = 0;
                in1.tlast = 0;
            end
            
            // Input 2 stimulus
            begin
                @(posedge clk);
                #1ps;
                in2.tvalid = 1;
                for (int i = 0; i < 5; i++) begin
                    in2.tdata = '0;
                    in2.tdata[7:0] = packet_data[2][i];
                    in2.tkeep = '1;
                    in2.tlast = (i == 4);
                    @(posedge clk);
                    while (!in2.tready) @(posedge clk);
                    #1ps;
                end
                in2.tvalid = 0;
                in2.tlast = 0;
            end
            
            // Input 3 stimulus
            begin
                @(posedge clk);
                #1ps;
                in3.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    in3.tdata = '0;
                    in3.tdata[7:0] = packet_data[3][i];
                    in3.tkeep = '1;
                    in3.tlast = (i == 3);
                    @(posedge clk);
                    while (!in3.tready) @(posedge clk);
                    #1ps;
                end
                in3.tvalid = 0;
                in3.tlast = 0;
            end
            
            // Input 4 stimulus
            begin
                @(posedge clk);
                #1ps;
                in4.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    in4.tdata = '0;
                    in4.tdata[7:0] = packet_data[4][i];
                    in4.tkeep = '1;
                    in4.tlast = (i == 3);
                    @(posedge clk);
                    while (!in4.tready) @(posedge clk);
                    #1ps;
                end
                in4.tvalid = 0;
                in4.tlast = 0;
            end
        join
        
        #(CLK_PERIOD * 7);
        $display("Stimulus completed successfully");
	$finish(2);
    end
    
    // Output ready control process
    initial begin
        @(posedge clk);
        #1ps;
        outp.tready = 1;
        #(CLK_PERIOD * 7);
        outp.tready = 0;
        #CLK_PERIOD;
        outp.tready = 1;
        #(CLK_PERIOD * 4);
        outp.tready = 0;
        pause = 1;
        #(CLK_PERIOD * 3);
        outp.tready = 1;
        #(CLK_PERIOD * 4);
        outp.tready = 0;
        #(CLK_PERIOD * 2);
        outp.tready = 1;
        #(CLK_PERIOD * 6);
        outp.tready = 0;
        #(CLK_PERIOD * 2);
        outp.tready = 1;
        pause = 0;
    end
    
    // Monitor process
    int expected_data_count = 0;
    
    always @(posedge clk) begin
        if (!rst) begin
            if (outp.tvalid && outp.tready) begin
                expected_data_count++;
                
                if (outp.tlast) begin
                    $display("Packet received with %0d words", expected_data_count);
                    expected_data_count = 0;
                end
            end
        end
    end
endmodule
