// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description:
//   DPE demultiplexer testbench
//==========================================================================

`timescale 1ps/1ps

module tb;
    // Constants
    localparam CLK_PERIOD = 12_500;
    import dpe_pkg::*;

    // Clock and reset signals
    logic clk = 0;
    logic rst = 1;

    // Interfaces
    dpe_if from_dpe(.clk(clk), .rst(rst));
    dpe_if to_cpu(.clk(clk), .rst(rst));
    dpe_if to_eth_1(.clk(clk), .rst(rst));
    dpe_if to_eth_2(.clk(clk), .rst(rst));
    dpe_if to_eth_3(.clk(clk), .rst(rst));
    dpe_if to_eth_4(.clk(clk), .rst(rst));

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
    always #(CLK_PERIOD/2) clk <= ~clk;

    // DUT instantiation
    dpe_demultiplexer DUT (
        .from_dpe(from_dpe),
        .to_cpu(to_cpu),
        .to_eth_1(to_eth_1),
        .to_eth_2(to_eth_2),
        .to_eth_3(to_eth_3),
        .to_eth_4(to_eth_4)
    );

    // Main stimulus process
    initial begin
        // Initialize input interface
        from_dpe.tvalid = 0;
        from_dpe.tlast = 0;
        from_dpe.tkeep = '0;
        from_dpe.tdata = '0;

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
            from_dpe.tvalid = 1;
            for (int i = 0; i < 6; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_CPU;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[0][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 5);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
            // Send packet 1
            from_dpe.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_ETH_1;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[1][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 3);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
            // Send packet 2
            from_dpe.tvalid = 1;
            for (int i = 0; i < 5; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_ETH_2;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[2][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 4);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
            // Send packet 3
            from_dpe.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_ETH_3;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[3][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 3);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
            // Send packet 4
            from_dpe.tvalid = 1;
            for (int i = 0; i < 4; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_ETH_4;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[4][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 3);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
            // Send packet 5
            from_dpe.tvalid = 1;
            for (int i = 0; i < 5; i++) begin
                from_dpe.tuser_bypass_all = 0;
                from_dpe.tuser_bypass_stage = 0;
                from_dpe.tuser_src = DPE_ADDR_CPU;
                from_dpe.tuser_dst = DPE_ADDR_BCAST;
                from_dpe.tdata = '0;
                from_dpe.tdata[7:0] = packet_data[5][i];
                from_dpe.tkeep = '1;
                from_dpe.tlast = (i == 4);
                @(posedge clk);
                while (!from_dpe.tready) @(posedge clk);
                #1ps;
            end
            from_dpe.tvalid = 0;
            from_dpe.tlast = 0;
        end

        #(CLK_PERIOD * 7);
        $display("Stimulus completed successfully");
    $finish(2);
    end

    // Outputs ready control process
    initial begin
        @(posedge clk);
        #1ps;
        to_cpu.tready = 1;
        to_eth_1.tready = 1;
        to_eth_2.tready = 1;
        to_eth_3.tready = 1;
        to_eth_4.tready = 1;
        #(CLK_PERIOD * 7);
        to_cpu.tready = 0;
        to_eth_1.tready = 0;
        to_eth_2.tready = 0;
        to_eth_3.tready = 0;
        to_eth_4.tready = 0;
        #CLK_PERIOD;
        to_cpu.tready = 1;
        to_eth_1.tready = 1;
        to_eth_2.tready = 1;
        to_eth_3.tready = 1;
        to_eth_4.tready = 1;
        #(CLK_PERIOD * 4);
        to_cpu.tready = 0;
        to_eth_1.tready = 0;
        to_eth_2.tready = 0;
        to_eth_3.tready = 0;
        to_eth_4.tready = 0;
        #(CLK_PERIOD * 3);
        to_cpu.tready = 1;
        to_eth_1.tready = 1;
        to_eth_2.tready = 1;
        to_eth_3.tready = 1;
        to_eth_4.tready = 1;
        #(CLK_PERIOD * 4);
        to_cpu.tready = 0;
        to_eth_1.tready = 0;
        to_eth_2.tready = 0;
        to_eth_3.tready = 0;
        to_eth_4.tready = 0;
        #(CLK_PERIOD * 2);
        to_cpu.tready = 1;
        to_eth_1.tready = 1;
        to_eth_2.tready = 1;
        to_eth_3.tready = 1;
        to_eth_4.tready = 1;
        #(CLK_PERIOD * 6);
        to_cpu.tready = 0;
        to_eth_1.tready = 0;
        to_eth_2.tready = 0;
        to_eth_3.tready = 0;
        to_eth_4.tready = 0;
        #(CLK_PERIOD * 2);
        to_cpu.tready = 1;
        to_eth_1.tready = 1;
        to_eth_2.tready = 1;
        to_eth_3.tready = 1;
        to_eth_4.tready = 1;
    end

    // Monitor process
    int expected_data_count0 = 0;
    int expected_data_count1 = 0;
    int expected_data_count2 = 0;
    int expected_data_count3 = 0;
    int expected_data_count4 = 0;

    always @(posedge clk) begin
        if (!rst) begin
            if (to_cpu.tvalid && to_cpu.tready) begin
                expected_data_count0 <= expected_data_count0 + 1;

                if (to_cpu.tlast) begin
                    $display("Packet received with %0d words at port 0", expected_data_count0);
                    expected_data_count0 <= 0;
                end
            end
            if (to_eth_1.tvalid && to_eth_1.tready) begin
                expected_data_count1 <= expected_data_count1 + 1;

                if (to_eth_1.tlast) begin
                    $display("Packet received with %0d words at port 1", expected_data_count1);
                    expected_data_count1 <= 0;
                end
            end
            if (to_eth_2.tvalid && to_eth_2.tready) begin
                expected_data_count2 <= expected_data_count2 + 1;

                if (to_eth_2.tlast) begin
                    $display("Packet received with %0d words at port 2", expected_data_count2);
                    expected_data_count2 <= 0;
                end
            end
            if (to_eth_3.tvalid && to_eth_3.tready) begin
                expected_data_count3 <= expected_data_count3 + 1;

                if (to_eth_3.tlast) begin
                    $display("Packet received with %0d words at port 3", expected_data_count3);
                    expected_data_count3 <= 0;
                end
            end
            if (to_eth_4.tvalid && to_eth_4.tready) begin
                expected_data_count4 <= expected_data_count4 + 1;

                if (to_eth_4.tlast) begin
                    $display("Packet received with %0d words at port 4", expected_data_count4);
                    expected_data_count4 <= 0;
                end
            end
        end
    end
endmodule
