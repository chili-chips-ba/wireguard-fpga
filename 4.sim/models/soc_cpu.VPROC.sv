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
   parameter logic    EN_IMEM        = 0,               // Default no IMEM (use direct mem.c API)
   parameter [3:0]    NODE           = 0                // CPU defaults to VProc node 0
)(
   soc_if.MST         bus,

// access point for reloading CPU program memory
// (unused if EN_IMEM is 0)
   input logic        imem_we,
   input logic [31:2] imem_waddr,
   input logic [31:0] imem_wdat
);

//----------------------------------------------------
// Local constant definitions
//----------------------------------------------------

// Specify IMEM/DMEM boundary
localparam [31:0] IMEM_TOP = 32'h0FFF_FFFF;

//----------------------------------------------------
// Internal signal definitions
//----------------------------------------------------

// Signals for VProc
logic                 vp_wack, vp_rack,vp_we, vp_rd;
logic [3:0]           vp_be;
logic [31:0]          vp_addr;
logic [31:0]          vp_rdat;

// Signals for memory model
logic                 mem_we, mem_rd, mem_rvld;
logic [31:0]          mem_rdat;

// Signals for address decode
logic                 imem_access;

//--------------------------------------------------------
// Combinatorial logic
//
//   IMEM: 0x0000_0000 - 0x0FFF_FFFF - Instruction Space
//   BUS : 0x1000_0000 - 0x1FFF_FFFF - Data Space
//--------------------------------------------------------

// Flag whether IMEM or DMEM access
assign imem_access    = bus.addr <= IMEM_TOP[31:2];

// Combine VProc's WE with BE to produce bus write enables
assign bus.we         = vp_be & {4{vp_we}};

// Bus access valid on read or write and address not an IMEM access
assign bus.vld        = (vp_we | vp_rd) & ~imem_access;

// Bus output is a word address
assign bus.addr       = vp_addr[31:2];

// Write acknowledge VProc when writing and either always for IMEM or bus.rdy for DMEM
assign vp_wack        = vp_we & (imem_access | bus.rdy);

// Read acknowledge VProc when reading and either mem_rvld for IMEM or bus.rdy for DMEM
assign vp_rack        = vp_rd & (imem_access ? mem_rvld : bus.rdy);

// Mux read data sources: bus.rdata when DMEM, mem_rdat when IMEM
assign vp_rdat        = ~imem_access ? bus.rdat : mem_rdat;

// Access the memory only when an IMEM access
assign mem_we         = vp_we & imem_access;
assign mem_rd         = vp_rd & imem_access;

//-----------------------------------------------------
// VProc virtual processor
//-----------------------------------------------------

   VProc #(
      .DISABLE_DELTA         (1)
   )
   u_cpu (
      .Clk                   (bus.clk),                // i

      .Addr                  (vp_addr),                // o

      .DataOut               (bus.wdat),               // o
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
// Instruction memory for the CPU
//
// Only instantiatiate a mem_model port for IMEM
// reads (slower) if using rv32 ISS *and* not using its
// internal memory or direct mem.c API interface (which
// are faster and use no logic simulation processing)
//-----------------------------------------------------

  generate
     if (EN_IMEM != 0)

       mem_model u_imem (
          .clk               (bus.clk),                // i
          .rst_n             (bus.arst_n),             // i

          .address           (vp_addr),                // i
          .byteenable        (vp_be),                  // i
          .write             (mem_we),                 // i
          .writedata         (bus.wdat),               // i
          .read              (mem_rd),                 // i
          .readdata          (mem_rdat),               // o
          .readdatavalid     (mem_rvld),               // o

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

   else
      // When no mem_model interface, tie off read valid signal
      assign mem_rvld = 1'b1;

  endgenerate

endmodule: soc_cpu

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/10/30 SS: initial creation
*/