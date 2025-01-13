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
//   DPE Multiplexer Testbench
//==========================================================================

`timescale 1ps/1ps

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
    logic is_idle;
    
    // Interfaces
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp0();
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp1();
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp2();
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp3();
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp4();
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
        .is_idle(is_idle),
        .inp0(inp0),
        .inp1(inp1),
        .inp2(inp2),
        .inp3(inp3),
        .inp4(inp4),
        .outp(outp)
    );
    
    // Main stimulus process
    initial begin
        // Initialize all input interfaces
        inp0.tvalid = 0;
        inp0.tlast = 0;
        inp0.tkeep = '0;
        inp0.tdata = '0;
        
        inp1.tvalid = 0;
        inp1.tlast = 0;
        inp1.tkeep = '0;
        inp1.tdata = '0;
        
        inp2.tvalid = 0;
        inp2.tlast = 0;
        inp2.tkeep = '0;
        inp2.tdata = '0;
        
        inp3.tvalid = 0;
        inp3.tlast = 0;
        inp3.tkeep = '0;
        inp3.tdata = '0;
        
        inp4.tvalid = 0;
        inp4.tlast = 0;
        inp4.tkeep = '0;
        inp4.tdata = '0;
        
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
                inp0.tvalid = 1;
                for (int i = 0; i < 6; i++) begin
                    inp0.tdata = '0;
                    inp0.tdata[7:0] = packet_data[0][i];
                    inp0.tkeep = '1;
                    inp0.tlast = (i == 5);
                    @(posedge clk);
                    while (!inp0.tready) @(posedge clk);
                    #1ps;
                end
                inp0.tvalid = 0;
                inp0.tlast = 0;
            end
            
            // Input 1 stimulus
            begin
                @(posedge clk);
                #1ps;
                inp1.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    inp1.tdata = '0;
                    inp1.tdata[7:0] = packet_data[1][i];
                    inp1.tkeep = '1;
                    inp1.tlast = (i == 3);
                    @(posedge clk);                    
                    while (!inp1.tready) @(posedge clk);
                    #1ps;
                end
                inp1.tvalid = 0;
                inp1.tlast = 0;
            end
            
            // Input 2 stimulus
            begin
                @(posedge clk);
                #1ps;
                inp2.tvalid = 1;
                for (int i = 0; i < 5; i++) begin
                    inp2.tdata = '0;
                    inp2.tdata[7:0] = packet_data[2][i];
                    inp2.tkeep = '1;
                    inp2.tlast = (i == 4);
                    @(posedge clk);
                    while (!inp2.tready) @(posedge clk);
                    #1ps;
                end
                inp2.tvalid = 0;
                inp2.tlast = 0;
            end
            
            // Input 3 stimulus
            begin
                @(posedge clk);
                #1ps;
                inp3.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    inp3.tdata = '0;
                    inp3.tdata[7:0] = packet_data[3][i];
                    inp3.tkeep = '1;
                    inp3.tlast = (i == 3);
                    @(posedge clk);
                    while (!inp3.tready) @(posedge clk);
                    #1ps;
                end
                inp3.tvalid = 0;
                inp3.tlast = 0;
            end
            
            // Input 4 stimulus
            begin
                @(posedge clk);
                #1ps;
                inp4.tvalid = 1;
                for (int i = 0; i < 4; i++) begin
                    inp4.tdata = '0;
                    inp4.tdata[7:0] = packet_data[4][i];
                    inp4.tkeep = '1;
                    inp4.tlast = (i == 3);
                    @(posedge clk);
                    while (!inp4.tready) @(posedge clk);
                    #1ps;
                end
                inp4.tvalid = 0;
                inp4.tlast = 0;
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
