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
//   Wrapper for any CPU to make it Plug-and-Play compatible with our SOC
//   infrastructure. We hereby instantiate the CPU itself, along with its
//   Instruction Memory (IMEM). See individual files for details...
//--------------------------------------------------------
// Address mapping is:
//  0x0000_0000 - 0xFFFF_FFFF - IMEM/PROGRAM space: ADDR_RESET = 0x0000_0000
//  0x1000_0000 - 0xFFFF_FFFF - BUS/DATA space, see 'soc_fabric.sv' for details
//
//  This is compatible with both HARVARD and VON-NEUMANN architecture (as the
//  Linker does not understand overlapping memory spaces). Even in the full
//  HARVARD architecture, to fool it, we would fictitiously specify that DATA
//  is starting from 0x1000_0000, leaving 256MB for CODE and 256MB for DATA.
//
//  We use VON-NEUMANN memory architecture. The DATA space layout is:
//  0x1000_0000 - 0x1FFF_FFFF - DMEM. Max space is 256MB
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//  0x4000_0000 - 0xFFFF_FFFF - SDRAM:8MBytes, which needs 00_0000-7F_FFFF
//
//  This shows total allocation. Actual resources take much less, and alias
//==========================================================================
//
// For background, the original TetriSaraj address mapping was also
// completely in DATA space (VON-NEUMANN). INSTRUCTION space (HARVARD)
// was not used at all.
//
// -----------------------------------------------MEM_WORDS=8192 (32kB)
//  0x0000_0000 - 0x0000_7FFF - DMEM (32kBytes): (cpu_addr < 4*MEM_WORDS)
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

module soc_cpu #(
   parameter [31:0]   ADDR_RESET     = 32'h 0000_0000,
   parameter int      NUM_WORDS_IMEM = 8192
)(
   soc_if.MST         bus,

// access point for reloading CPU program memory
   input logic        imem_cpu_rstn,
   input logic        imem_we,
   input logic [31:2] imem_waddr,
   input logic [31:0] imem_wdat
);

   logic        cpu_valid; //-\
   logic        cpu_instr; // |
   logic        cpu_ready; // | CPU
   logic [31:0] cpu_addr;  // | memory
   logic [31:0] cpu_wdata; // | interface
   logic [3:0]  cpu_wstrb; // |
   logic [31:0] cpu_rdata; //-/

   logic        imem_vld, imem_rdy;
   logic [31:0] imem_rdat;

   always_comb begin: _decode

   // IMEM: 0x0000_0000 - 0xFFFF_FFFF - Instruction Space
   // BUS : 0x1000_0000 - 0xFFFF_FFFF - Data Space
   //
   // However, rather than using CPU-generated 'cpu_instr' for IMEM
   // selection, we generate it localy from address. In that way, the
   // CPU program can read from what is nominally instruction space
      cpu_instr =  cpu_addr[31:28] == '0;
      imem_vld  =  cpu_valid &  cpu_instr;
      bus.vld   =  cpu_valid & ~cpu_instr;

      bus.we    =  cpu_wstrb;
      bus.addr  =  cpu_addr[31:2];
      bus.wdat  =  cpu_wdata;

     if (cpu_instr == 1'b1) begin
         cpu_ready = imem_rdy;
         cpu_rdata = imem_rdat;
      end
      else begin
         cpu_ready =  bus.rdy;
         cpu_rdata =  bus.rdat;
      end
   end: _decode


//--------------------------------------------------------
// PicoRV32 itself
// RISC-V convention for the StackPointer is to point to the last word in
// use, i.e. free memory is at the addresses below the current SP value.
//--------------------------------------------------------
   logic        trace_valid;
   logic [35:0] trace_data;

   picorv32 #(
      .PROGADDR_RESET       (ADDR_RESET),
      .STACKADDR            (32'h 1000_8000), // 32KB

      .COMPRESSED_ISA       (0), // C:1200B; UN=1600B

      .TWO_STAGE_SHIFT      (1),
      .TWO_CYCLE_COMPARE    (0),
      .TWO_CYCLE_ALU        (0),

      .LATCHED_MEM_RDATA    (0),
      .BARREL_SHIFTER       (0),
      .ENABLE_MUL           (0),
      .ENABLE_FAST_MUL      (0),
      .ENABLE_DIV           (0),

      .ENABLE_REGS_DUALPORT (1),
      .ENABLE_REGS_16_31    (1),
      .ENABLE_PCPI          (0),
      .ENABLE_COUNTERS      (0),
      .ENABLE_COUNTERS64    (0),
`ifdef DEBUGTRACE
      .ENABLE_TRACE         (1),
`else
      .ENABLE_TRACE         (0),
`endif

      .ENABLE_IRQ           (0),
      .ENABLE_IRQ_QREGS     (0),
      .ENABLE_IRQ_TIMER     (0),
      .MASKED_IRQ           (32'h0000_0000),
      .LATCHED_IRQ          (32'hffff_ffff),
      .PROGADDR_IRQ         (32'h 0000_0010),

      .CATCH_MISALIGN       (1),
      .CATCH_ILLINSN        (1),
      .REGS_INIT_ZERO       (0)
   ) u_cpu (
      .clk          (bus.clk),     //i
      .resetn       (bus.arst_n | imem_cpu_rstn),  //i

      .trap         (), //o

      .mem_valid    (cpu_valid),   //o
      .mem_instr    (), //o
      .mem_ready    (cpu_ready),   //i

      .mem_addr     (cpu_addr),    //o[31:0]
      .mem_wdata    (cpu_wdata),   //o[31:0]
      .mem_wstrb    (cpu_wstrb),   //o[3:0]
      .mem_rdata    (cpu_rdata),   //i[31:0]

      // NOT-USED: Look-Ahead Interface
      .mem_la_read  (),            //o
      .mem_la_write (),            //o
      .mem_la_addr  (),            //o[31:0]
      .mem_la_wdata (),            //o[31:0]
      .mem_la_wstrb (),            //o[3:0]

      // NOT-USED: Pico Co-Processor Interface (PCPI)
      .pcpi_valid   (),            //o
      .pcpi_insn    (),            //o[31:0]
      .pcpi_rsrc1   (),            //o[31:0]
      .pcpi_rsrc2   (),            //o[31:0]

      .pcpi_wr      ('0),          //i
      .pcpi_rdst    ('0),          //i[31:0]
      .pcpi_wait    ('0),          //i
      .pcpi_ready   ('0),          //i

      // NOT-USED: IRQ Interface
      .irq          ('0),          //i[31:0]
      .eoi          (),            //o[31:0]

      // NOT-USED: Trace Interface
      .trace_valid  (trace_valid), //o
      .trace_data   (trace_data)   //o[35:0]
   );

//----------------------------------------------------
// Instruction (aka Program) memory for the CPU
//----------------------------------------------------
   imem #(
      .NUM_WORDS (NUM_WORDS_IMEM)
   )
   u_imem (
      .clk    (bus.clk),
      .arst_n (bus.arst_n),

   // CPU Read-Only port
      .rvld   (imem_vld),
      .rrdy   (imem_rdy),
      .raddr  (cpu_addr [31:2]),
      .rdat   (imem_rdat),

   // Write port for reloading new CPU program
      .we     (imem_we),
      .waddr  (imem_waddr),
      .wdat   (imem_wdat)
   );

endmodule: soc_cpu

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/01 JI: initial creation
 2024/02/16 JI: updated based on Verilator Linting reports
*/
