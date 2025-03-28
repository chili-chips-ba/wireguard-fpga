//==========================================================================
// Copyright (C) 2023 Chili.CHIPS*ba
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
