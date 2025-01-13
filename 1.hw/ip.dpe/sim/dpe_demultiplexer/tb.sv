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
//   DPE Demultiplexer Testbench
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
    
    // Interfaces
    dpe_if #(DATA_WIDTH, USER_WIDTH) inp();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp0();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp1();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp2();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp3();
    dpe_if #(DATA_WIDTH, USER_WIDTH) outp4();
    
    // Test data type and constants
    typedef logic [7:0] test_data_t [6];
    typedef test_data_t packet_data_t [6];
    
    const packet_data_t packet_data = '{
        '{8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06},  // to Output 0
        '{8'h0B, 8'h0C, 8'h0D, 8'h0E, 8'h00, 8'h00},  // to Output 1
        '{8'h15, 8'h16, 8'h17, 8'h18, 8'h19, 8'h00},  // to Output 2
        '{8'h1F, 8'h20, 8'h21, 8'h22, 8'h00, 8'h00},  // to Output 3
        '{8'h29, 8'h2A, 8'h2B, 8'h2C, 8'h00, 8'h00},  // to Output 4
		'{8'h33, 8'h34, 8'h35, 8'h36, 8'h37, 8'h00}   // to all outputs
    };
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // DUT instantiation
    dpe_demultiplexer #(
        .TDATA_WIDTH(DATA_WIDTH),
        .TUSER_WIDTH(USER_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .inp(inp),
		.outp0(outp0),
        .outp1(outp1),
        .outp2(outp2),
        .outp3(outp3),
        .outp4(outp4)
    );
    
    // Main stimulus process
    initial begin
        // Initialize input interface
        inp.tvalid = 0;
        inp.tlast = 0;
        inp.tkeep = '0;
        inp.tdata = '0;
               
        // Reset assertion
        #(CLK_PERIOD * 4);
        @(posedge clk);
        #1ps;
        rst = 0;
        #(CLK_PERIOD);
        
        // Input stimulus
        begin
            @(posedge clk);
            // Send packet 0
			#1ps;
            inp.tvalid = 1;
            for (int i = 0; i < 6; i++) begin
				inp.tuser = 5'b00001;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[0][i];
                inp.tkeep = '1;
                inp.tlast = (i == 5);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
			// Send packet 1
            inp.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
				inp.tuser = 5'b00010;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[1][i];
                inp.tkeep = '1;
                inp.tlast = (i == 3);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
			// Send packet 2
            inp.tvalid = 1;
            for (int i = 0; i < 5; i++) begin
				inp.tuser = 5'b00100;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[2][i];
                inp.tkeep = '1;
                inp.tlast = (i == 4);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
			// Send packet 3
            inp.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
				inp.tuser = 5'b01000;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[3][i];
                inp.tkeep = '1;
                inp.tlast = (i == 3);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
			// Send packet 4
            inp.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
				inp.tuser = 5'b10000;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[4][i];
                inp.tkeep = '1;
                inp.tlast = (i == 3);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
			// Send packet 5
            inp.tvalid = 1;
            for (int i = 0; i < 5; i++) begin
				inp.tuser = 5'b11111;
                inp.tdata = '0;
                inp.tdata[7:0] = packet_data[5][i];
                inp.tkeep = '1;
                inp.tlast = (i == 4);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
        end
        
        #(CLK_PERIOD * 7);
        $display("Stimulus completed successfully");
	$finish(2);
    end
    
    // Outputs ready control process
    initial begin
        @(posedge clk);
        #1ps;
        outp0.tready = 1;
		outp1.tready = 1;
		outp2.tready = 1;
		outp3.tready = 1;
		outp4.tready = 1;
        #(CLK_PERIOD * 7);
        outp0.tready = 0;
		outp1.tready = 0;
		outp2.tready = 0;
		outp3.tready = 0;
		outp4.tready = 0;
        #CLK_PERIOD;
        outp0.tready = 1;
		outp1.tready = 1;
		outp2.tready = 1;
		outp3.tready = 1;
		outp4.tready = 1;
        #(CLK_PERIOD * 4);
        outp0.tready = 0;
		outp1.tready = 0;
		outp2.tready = 0;
		outp3.tready = 0;
		outp4.tready = 0;
        #(CLK_PERIOD * 3);
        outp0.tready = 1;
		outp1.tready = 1;
		outp2.tready = 1;
		outp3.tready = 1;
		outp4.tready = 1;
        #(CLK_PERIOD * 4);
        outp0.tready = 0;
		outp1.tready = 0;
		outp2.tready = 0;
		outp3.tready = 0;
		outp4.tready = 0;
        #(CLK_PERIOD * 2);
        outp0.tready = 1;
		outp1.tready = 1;
		outp2.tready = 1;
		outp3.tready = 1;
		outp4.tready = 1;
        #(CLK_PERIOD * 6);
        outp0.tready = 0;
		outp1.tready = 0;
		outp2.tready = 0;
		outp3.tready = 0;
		outp4.tready = 0;
        #(CLK_PERIOD * 2);
        outp0.tready = 1;
		outp1.tready = 1;
		outp2.tready = 1;
		outp3.tready = 1;
		outp4.tready = 1;
    end
    
    // Monitor process
    int expected_data_count0 = 0;
	int expected_data_count1 = 0;
	int expected_data_count2 = 0;
	int expected_data_count3 = 0;
	int expected_data_count4 = 0;
    
    always @(posedge clk) begin
        if (!rst) begin
            if (outp0.tvalid && outp0.tready) begin
                expected_data_count0++;
                
                if (outp0.tlast) begin
                    $display("Packet received with %0d words at port 0", expected_data_count0);
                    expected_data_count0 = 0;
                end
            end
			if (outp1.tvalid && outp1.tready) begin
                expected_data_count1++;
                
                if (outp1.tlast) begin
                    $display("Packet received with %0d words at port 1", expected_data_count1);
                    expected_data_count1 = 0;
                end
            end
			if (outp2.tvalid && outp2.tready) begin
                expected_data_count2++;
                
                if (outp2.tlast) begin
                    $display("Packet received with %0d words at port 2", expected_data_count2);
                    expected_data_count2 = 0;
                end
            end
			if (outp3.tvalid && outp3.tready) begin
                expected_data_count3++;
                
                if (outp3.tlast) begin
                    $display("Packet received with %0d words at port 3", expected_data_count3);
                    expected_data_count3 = 0;
                end
            end
			if (outp4.tvalid && outp4.tready) begin
                expected_data_count4++;
                
                if (outp4.tlast) begin
                    $display("Packet received with %0d words at port 4", expected_data_count4);
                    expected_data_count4 = 0;
                end
            end
        end
    end
endmodule
