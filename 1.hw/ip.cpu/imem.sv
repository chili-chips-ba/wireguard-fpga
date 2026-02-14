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
//   Instruction memory that keeps CPU SW, with option to load it live.
//
//   There are two Python scripts for it:
//    - imem.INIT.py - Generates initial values to load at Compile time
//    - imem.UART.py - Generates and loads (via UART) at Run time / Live
//==========================================================================

module imem
#(
    parameter int       NUM_WORDS = 8192 // in 32-bit: 8KWords = 32KBytes
)(
 // Clock & reset
    input  logic        clk,
    input  logic        arst_n,

 // CPU Read-Only port
    input  logic        rvld,
    output logic        rrdy,
    input  logic [31:2] raddr,
    output logic [31:0] rdat,

 // Write port for reloading new CPU program
    input  logic        we,
    input  logic [31:2] waddr,
    input  logic [31:0] wdat
);

 //============================================================================
 //import soc_pkg::clog2;

  localparam ADDR_MSB  = $clog2(NUM_WORDS) + 1;

`ifdef YOSYS
    (* ram_style = "block" *) logic [31:0] mem [NUM_WORDS];

`else // Gowin
    logic [31:0] mem [NUM_WORDS] /* synthesis syn_ramstyle = "block_ram" */;
  //logic [31:0] mem [NUM_WORDS] /* synthesis syn_ramstyle = "distributed_ram" */;

  // Our IMEM is not a ROM! Just for completness, Gowin supports the following
  //  'syn_romstyle' attributes: <block_rom, distributed_rom, logic>
`endif

  logic [ADDR_MSB:2] raddr_int;
  logic [ADDR_MSB:2] waddr_int;

  assign raddr_int = raddr[ADDR_MSB:2];
  assign waddr_int = waddr[ADDR_MSB:2];

  initial begin
    `include "imem.INIT.vh"
  end

//------------------------------------------------------------
// storage element: Writes and Reads are synchronous
//------------------------------------------------------------
  always_ff @(posedge clk) begin
     rdat <= mem[raddr_int];

     if (we == 1'b1) begin
        mem[waddr_int] <= wdat;
     end
  end

//------------------------------------------------------------
// handshake: Data is RDY one cycle after VLD. RDY must
//            not be asserted for more than one cycle
//----------------------------------------------------------
  always_ff @(negedge arst_n or posedge clk) begin
    if (arst_n == 1'b0) begin
       rrdy <= '0;
    end
    else begin
       rrdy <= rvld & ~rrdy;
    end
  end

endmodule: imem

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/3 JI: initial creation
*/
