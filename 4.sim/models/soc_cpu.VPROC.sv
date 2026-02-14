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
//   Wrapper for any CPU to make it Plug-and-Play compatible with the SOC
//   infrastructure. Here is instantiated the VProc virtual processor,
//   optionally along with Instruction Memory (IMEM).
//   See individual files for details...
//--------------------------------------------------------------------------
// Address mapping is:
//  0x0000_0000 - 0x0FFF_FFFF - IMEM/PROGRAM space: ADDR_RESET = 0x0000_0000
//  0x1000_0000 - 0x1FFF_FFFF - BUS /DATA space, see 'soc_fabric.sv' for details
//
//  That's the full HARVARD architecture. However, as the Linker does not
//  understand overlapping memory spaces, to fool it, we fictitiously specify
//  that DATA is starting from 0x1000_0000, leaving 256MB for CODE and 256MB
//  for DATA. The 0x0000_0000-0x0FFF_FFFF DATA space is still valid as an alias.
//
//  The recommended DATA space layout is:
//  0x1000_0000 - 0x1FFF_FFFF - DMEM. Max space is 256MB
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//  0x4000_0000 - 0xFFFF_FFFF - SDRAM:8MBytes, which needs 00_0000-7F_FFFF
//
//  This shows total allocation. Actual resources take much less, and alias
//==========================================================================
//
// Just for background, the original TetriSaraj address mapping was
// completely in DATA space (VON-NEUMANN). INSTRUCTION space (HARVARD)
// was not used at all.
//
// -----------------------------------------------MEM_WORDS=8192 (32kB)
//  0x1000_0000 - 0x1000_7FFF - DMEM (32kBytes): (cpu_addr < 4*MEM_WORDS)
//                                                STACKADDR= 4*MEM_WORDS;
//                                                Top of DMEM block
// -----------------------------------------------
//  0x0000_8000 - 0x0000_FFFF - IMEM (32KBytes)  (cpu_addr >= 4*MEM_WORDS)
//                                              &(cpu_addr < 32'h 0200_0000)
//  0x0001_0000 - 0x0001_7FFF - IMEM image 1
//  0x0001_8000 - 0x0001_FFFF - IMEM image 2
//  0x0010_0000 - 0x0010_7FFF - IMEM image 3 -> PROGADDR_RESET=32'h0010_0000=FlashStart=1MB
//   ...                                                              (FlashEnd was on 5MB)
//  0x01FF_8000 - 0x01FF_FFFF - IMEM image N
// - - - - - - - - - - - - - - - - - - - - - - - -
//  0x0100_0000 - 0xFFFF_FFFF - IOMEM bus space  (cpu_addr[31:24] > 8'h01);
//   SPI_Flash         : 0x0200_0000 - 0x0200_0003
//   SimpleUART.REG_DIV: 0x0200_0004 - 0x0200_0007
//   SimpleUART.REG_DAT: 0x0200_0008 - 0x0200_000B
//   GPIO              : iomem_addr[31:24] == 8'h03
//   VGA               : iomem_addr[31:24] == 8'h05
//==========================================================================
/* verilator lint_off UNOPTFLAT */
module soc_cpu #(
   parameter [31:0]   ADDR_RESET     = 32'h 0000_0000,  // Unused
   parameter int      NUM_WORDS_IMEM = 8192,            // Unused
   parameter [3:0]    NODE           = 0                // CPU defaults to VProc node 0
)(
   soc_if.MST         bus,

// access point for reloading CPU program memory
   input logic        imem_cpu_rstn,
   input logic        imem_we,
   input logic [31:2] imem_waddr,
   input logic [31:0] imem_wdat
);

//----------------------------------------------------
// Internal signal definitions
//----------------------------------------------------

// Signals for VProc
logic                 vp_wack, vp_rack,vp_we, vp_rd;
logic [3:0]           vp_be;
logic [31:0]          vp_addr;
logic [31:0]          vp_wdat;
logic [31:0]          vp_rdat;
logic                 cpu_access;

logic                 imem_write;
logic                 imem_read;
logic [31:0]          imem_readdata;
logic                 imem_readdatavalid;

//--------------------------------------------------------
// Combinatorial logic
//
// Maps VProc's generic memory mapped interface to comply
// with the soc_if protocol.
//
//--------------------------------------------------------

// Flag if accessin the local IMEM
assign cpu_access     = vp_addr[31:28] == '0;

// Combine VProc's WE with BE to produce bus write enables
assign bus.we         = vp_be & {4{vp_we}};

// Bus access valid on read or write
assign bus.vld        = (vp_we | vp_rd) & ~cpu_access;

// Bus output is a word address
assign bus.addr       = vp_addr[31:2];

// Export write data onto bus
assign bus.wdat       = vp_wdat;

// Write to IMEM
assign imem_write     = vp_we & cpu_access;

// Read from IMEM
assign imem_read      = vp_rd & cpu_access;

`ifndef VERILATOR

  // Write acknowledge VProc when writing and bus.rdy
assign vp_wack        = vp_we & (bus.rdy | cpu_access);

  // Read acknowledge VProc when reading and bus.rdy
assign vp_rack        = vp_rd & (bus.rdy | imem_readdatavalid);

  // Mux source of read data
assign vp_rdat        = cpu_access ? imem_readdata : bus.rdat;

`else

// For Verilator, ensure all input signals resolved before sampling
always @(negedge bus.clk)
begin

  // Write acknowledge VProc when writing and bus.rdy
  vp_wack             = vp_we & (bus.rdy | cpu_access);

  // Read acknowledge VProc when reading and bus.rdy
  vp_rack             = vp_rd & (bus.rdy | imem_readdatavalid);

  // Mux source of read data
  vp_rdat             = cpu_access ? imem_readdata : bus.rdat;

end
`endif

//-----------------------------------------------------
// VProc virtual processor
//-----------------------------------------------------

   VProc #(
      .DISABLE_DELTA         (1)
   )
   u_cpu (
      .Clk                   (bus.clk),                // i

      .Addr                  (vp_addr),                // o

      .DataOut               (vp_wdat),                // o
      .WE                    (vp_we),                  // o
      .WRAck                 (vp_wack),                // i

      // Compile VProc with VPROC_BYTE_ENABLE defined for BE port
      .BE                    (vp_be),                  // o

      .DataIn                (vp_rdat),                // i
      .RD                    (vp_rd),                  // o
      .RDAck                 (vp_rack),                // i

      .Interrupt             ('0),                     // i (unused)

      .Update                (),                       // o (unused)
      .UpdateResponse        ('0),                     // i (unused)

      .Node                  (NODE)
   );

//-----------------------------------------------------
// Memory model port for the imem write bus.
//
//-----------------------------------------------------

   mem_model u_imem (
      .clk               (bus.clk),                // i
      .rst_n             (bus.arst_n),             // i

      // Port used for reading program from VProc
      // when not using memory model's direct C API
      .address           (vp_addr),                // i
      .byteenable        (4'hf),                   // i
      .write             (imem_write),             // i
      .writedata         (vp_wdat),                // i
      .read              (imem_read),              // i
      .readdata          (imem_readdata),          // o
      .readdatavalid     (imem_readdatavalid),     // o

       // Port used when loading program via UART
      .wr_port_valid     (imem_we),                // i
      .wr_port_data      (imem_wdat),              // i
      .wr_port_addr      ({imem_waddr, 2'b00}),    // i

       // Unused burst ports
      .rx_waitrequest    (),                       // o (unused)
      .rx_burstcount     ('0),                     // i (unused)
      .rx_address        ('0),                     // i (unused)
      .rx_read           ('0),                     // i (unused)
      .rx_readdata       (),                       // o (unused)
      .rx_readdatavalid  (),                       // o (unused)

      .tx_waitrequest    (),                       // o (unused)
      .tx_burstcount     ('0),                     // i (unused)
      .tx_address        ('0),                     // i (unused)
      .tx_write          ('0),                     // i (unused)
      .tx_writedata      ('0)                      // i (unused)
   );

endmodule: soc_cpu

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/10/30 SS: initial creation
*/
