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
//   GMII-to-GMII loopback testbench
//==========================================================================

`timescale 1ps/1ps

module tb;
    // Constants
    localparam CLK_PERIOD = 8_000;
    localparam DATA_WIDTH = 128;
    localparam KEEP_WIDTH = DATA_WIDTH/8;
    localparam INP_USER_WIDTH = 1;
    localparam OUTP_USER_WIDTH = 1;
    
    // Clock and reset signals
    logic clk = 0;
    logic rst = 1;
    logic is_idle;
    
    // Interfaces
    dpe_if #(DATA_WIDTH, INP_USER_WIDTH) inp();
    dpe_if #(DATA_WIDTH, OUTP_USER_WIDTH) outp();
    logic       gmii_rx_clk;
    logic [7:0] gmii_rxd;
    logic       gmii_rx_dv;
    logic       gmii_rx_er;
    logic       gmii_tx_clk;
    logic [7:0] gmii_txd;
    logic       gmii_tx_en;
    logic       gmii_tx_er;
    
    // Test data type and constants
    typedef logic [127:0] test_data_t [11];
    typedef test_data_t packet_data_t [4];
    
    const packet_data_t packet_data = '{
        '{128'h00050008F85ABFE5363A83B59434E6A2, 
          128'h090A0100090A26631140000017039C00,
          128'hF40600000001AE1488006CCAC6A90200,
          128'hCF2C3786BC020000000000000002AB7D,
          128'hD2302D3D2334C570347A3263B7398A20,
          128'h989CF26AF51C16BD8C5466DC08A9DB53,
          128'h85E58342D52EAB3CABF4B5FF0AF991C3,
          128'h08A437F52A662C69698CAA1B663078ED,
          128'h70BBF2FAB15757F16B1983B4E1E38051,
          128'h3319107F4160B4F8E66A004C3BBE7331,
          128'h0000000000005430B61799C89613B7E3},
        '{128'h00450008F85ABFE5363A83B59434E6A2, 
          128'h090A0100090A26631140000017039C00,
          128'hF40600000004AE1488006CCAC6A90200,
          128'hCF2C3786BC020000000000000002AB7D,
          128'hD2302D3D2334C570347A3263B7398A20,
          128'h989CF26AF51C16BD8C5466DC08A9DB53,
          128'h85E58342D52EAB3CABF4B5FF0AF991C3,
          128'h08A437F52A662C69698CAA1B663078ED,
          128'h70BBF2FAB15757F16B1983B4E1E38051,
          128'h3319107F4160B4F8E66A004C3BBE7331,
          128'h0000000000005430B61799C89613B7E3},
        '{128'h00450008F85ABFE5363A83B59434E6A2, 
          128'h090A0100090A26631140000017039C00,
          128'hF40600000001AE1488006CCAC6A90200,
          128'hCF2C3786BC020000000000000002AB7D,
          128'hD2302D3D2334C570347A3263B7398A20,
          128'h989CF26AF51C16BD8C5466DC08A9DB53,
          128'h85E58342D52EAB3CABF4B5FF0AF991C3,
          128'h08A437F52A662C69698CAA1B663078ED,
          128'h70BBF2FAB15757F16B1983B4E1E38051,
          128'h3319107F4160B4F8E66A004C3BBE7331,
          128'h0000000000005430B61799C89613B7E3},
        '{128'h00450008F85ABFE5363A83B59434E6A2, 
          128'h090A0100090A275D1140000076093C00,
          128'hF406000000044E1428006CCAC6A90200,
          128'h1D65B6E256190000000000000003AB7D,
          128'h0000000000007196D0A09230B29CF5D4,
          '0,
          '0,
          '0,
          '0,
          '0,
          '0}
    };
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // DUT instantiation
    eth_mac_1g_gmii_fifo #(
        .TARGET("GENERIC"),
        .IODDR_STYLE("IODDR"),
        .CLOCK_INPUT_STYLE("BUFR"),
        .AXIS_DATA_WIDTH(128),
        .ENABLE_PADDING(1),
        .MIN_FRAME_LENGTH(64),
        .TX_FIFO_DEPTH(4096),
        .TX_FRAME_FIFO(1),
        .RX_FIFO_DEPTH(4096),
        .RX_FRAME_FIFO(1)
    ) DUT (
        .gtx_clk(clk),
        .gtx_rst(rst),
        .logic_clk(clk),
        .logic_rst(rst),
        
        .tx_axis_tdata(inp.tdata),
        .tx_axis_tkeep(inp.tkeep),
        .tx_axis_tvalid(inp.tvalid),
        .tx_axis_tready(inp.tready),
        .tx_axis_tlast(inp.tlast),
        .tx_axis_tuser(inp.tuser),
        
        .rx_axis_tdata(outp.tdata),
        .rx_axis_tkeep(outp.tkeep),
        .rx_axis_tvalid(outp.tvalid),
        .rx_axis_tready(outp.tready),
        .rx_axis_tlast(outp.tlast),
        .rx_axis_tuser(outp.tuser),
        
        .gmii_rx_clk(gmii_rx_clk),
        .gmii_rxd(gmii_rxd),
        .gmii_rx_dv(gmii_rx_dv),
        .gmii_rx_er(gmii_rx_er),
        .mii_tx_clk(),
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_txd(gmii_txd),
        .gmii_tx_en(gmii_tx_en),
        .gmii_tx_er(gmii_tx_er),
        
        .tx_error_underflow(),
        .tx_fifo_overflow(),
        .tx_fifo_bad_frame(),
        .tx_fifo_good_frame(),
        .rx_error_bad_frame(),
        .rx_error_bad_fcs(),
        .rx_fifo_overflow(),
        .rx_fifo_bad_frame(),
        .rx_fifo_good_frame(),
        .speed(),

        .cfg_ifg(8'd12),
        .cfg_tx_enable(1'b1),
        .cfg_rx_enable(1'b1)
    );
    assign gmii_rx_clk = gmii_tx_clk;
    assign gmii_rxd = gmii_txd;
    assign gmii_rx_dv = gmii_tx_en;
    assign gmii_rx_er = gmii_tx_er;
    
    // Main stimulus process
    initial begin
        // Initialize input interface
        inp.tvalid = 0;
        inp.tlast = 0;
        inp.tkeep = '0;
        inp.tdata = '0;
        inp.tuser = 0;
               
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
            for (int i = 0; i < 11; i++) begin
                inp.tdata = packet_data[0][i];
                inp.tkeep = (i == 10)?16'h03FF:16'hFFFF;
                inp.tlast = (i == 10);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
            inp.tkeep = '0;
            inp.tdata = '0;
            /*
			// Send packet 1
            inp.tvalid = 1;
            for (int i = 0; i < 11; i++) begin
                inp.tdata = packet_data[1][i];
                inp.tkeep = (i == 10)?16'h03FF:16'hFFFF;
                inp.tlast = (i == 10);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
            inp.tkeep = '0;
            inp.tdata = '0;
            // Send packet 2
            inp.tvalid = 1;
            for (int i = 0; i < 11; i++) begin
                inp.tdata = packet_data[2][i];
                inp.tkeep = (i == 10)?16'h03FF:16'hFFFF;
                inp.tlast = (i == 10);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
            inp.tkeep = '0;
            inp.tdata = '0;
            // Send packet 3
            inp.tvalid = 1;
            for (int i = 0; i < 5; i++) begin
                inp.tdata = packet_data[3][i];
                inp.tkeep = (i == 4)?16'h03FF:16'hFFFF;
                inp.tlast = (i == 4);
                @(posedge clk);
                while (!inp.tready) @(posedge clk);
                #1ps;
            end
            inp.tvalid = 0;
            inp.tlast = 0;
            inp.tkeep = '0;
            inp.tdata = '0;*/
        end
        
        #(CLK_PERIOD * 300);
        $display("Stimulus completed successfully");
    $finish(2);
    end
    
    // Output ready control process
    initial begin
        @(posedge clk);
        #1ps;
        outp.tready = 1;
        /*#(CLK_PERIOD * 10);
        outp.tready = 0;
        #CLK_PERIOD;
        outp.tready = 1;
        #(CLK_PERIOD * 16);
        outp.tready = 0;
        #(CLK_PERIOD * 2);
        outp.tready = 1;
        */
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
