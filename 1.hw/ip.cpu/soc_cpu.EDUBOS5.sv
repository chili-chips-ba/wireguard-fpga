// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation
//--------------------------------------------------------------------------
// Description:
//   soc_cpu with the eduBOS5 core (cpu.EDUBOS5/, from openPCIE). Same module
//   name and ports as soc_cpu.PICORV32.sv: top.filelist picks the core by
//   which soc_cpu file it lists. Same address map:
//
//    0x0000_0000 - 0x0FFF_FFFF - IMEM: code, and rodata + .data image that
//                                the firmware reads as data (main.lds)
//    0x1000_0000 - 0xFFFF_FFFF - BUS: DMEM, CSR (soc_fabric.sv)
//
//   eduBOS5 is Harvard. It fetches on the IMEM read port, which answers in
//   one cycle, as eduBOS5 expects. Its data loads from IMEM space go to IMEM
//   port B, which also takes the UART program writes; those come while the
//   CPU is held in reset (imem_cpu_rstn), so the two do not meet. Stores to
//   IMEM space are dropped, as with PicoRV32 (IMEM has no CPU write path).
//
//   eduBOS5 stores are one-cycle requests that do not wait for ready. So
//   only the ready of a load reaches the core. A store issued while the UART
//   holds the bus (soc_fabric.sv) is lost: do not drive the bus from the
//   UART (busw/busr) while an eduBOS5 program runs.
//
//   eduBOS5 starts at address 0 (ADDR_RESET must be 0) and, unlike PicoRV32
//   (STACKADDR), does not set sp at reset: 2.sw/boot_crt.s does. It is pure
//   RV32I: any SYSTEM instruction (ecall, ebreak, csr*) halts it, so the
//   firmware reads csr.cycle instead of rdcycle; its ebreak error stops halt.
//
//   `define SOC_EDUBOS5_3STG selects the 3-stage pipeline (default 2-stage).
//==========================================================================

module soc_cpu #(
    parameter logic [31:0] ADDR_RESET     = 32'h0000_0000,
    parameter int          NUM_WORDS_IMEM = 8192
) (
    soc_if.MST bus,

    // access point for reloading CPU program memory
    input logic        imem_cpu_rstn,
    input logic        imem_we,
    input logic [31:2] imem_waddr,
    input logic [31:0] imem_wdat
);

  if (ADDR_RESET != 32'h0000_0000) begin : g_addr_reset_check
    $error("soc_cpu.EDUBOS5: eduBOS5 starts at address 0, ADDR_RESET must be 0");
  end

`ifdef SOC_EDUBOS5_3STG
  localparam int EDUBOS5_WAIT4REGS = 1;  // 3-stage pipeline
`else
  localparam int EDUBOS5_WAIT4REGS = 0;  // 2-stage pipeline
`endif

  // instruction port
  edubos5_pkg::cpu_pc_t          imem_addr;
  logic                          imem_vld;
  logic                   [31:0] imem_rdat;

  // data port
  edubos5_pkg::cpu_addr_t        dmem_addr;
  edubos5_pkg::we_bs_t           dmem_we;
  logic                   [31:0] dmem_wdat;
  logic                   [31:0] dmem_rdat;
  logic                          dmem_vld;
  logic                          dmem_rdy;
  logic                   [ 1:0] NC_dmem_addr;  // byte offset: dmem_we has it

  // IMEM space: data loads from IMEM port B
  logic                          is_imem;
  logic                          imem_load;
  logic                          imem_load_rdy;
  logic                   [31:0] imem_load_rdat;

  // BUS space: only the ready of a load goes to the core
  logic                          bus_load;
  logic                          bus_load_wait;
  logic                          bus_load_rdy;

  assign NC_dmem_addr = dmem_addr[1:0];

  always_comb begin : _decode
    is_imem      = dmem_addr[31:28] == '0;
    imem_load    = dmem_vld & is_imem & (dmem_we == '0);

    bus.vld      = dmem_vld & ~is_imem;
    bus.we       = dmem_we;
    bus.addr     = dmem_addr[31:2];
    bus.wdat     = dmem_wdat;

    bus_load     = bus.vld & (bus.we == '0);
    // a load gets its ready in the request cycle (comb) or later (flopped)
    bus_load_rdy = bus.rdy & (bus_load | bus_load_wait);

    dmem_rdy     = bus_load_rdy | imem_load_rdy;
    dmem_rdat    = imem_load_rdy ? imem_load_rdat : bus.rdat;
  end : _decode

  always_ff @(negedge bus.arst_n or posedge bus.clk) begin : _load_wait
    if (bus.arst_n == 1'b0) begin
      bus_load_wait <= 1'b0;
      imem_load_rdy <= 1'b0;
    end
    else begin
      bus_load_wait <= bus_load & ~bus.rdy;
      imem_load_rdy <= imem_load & ~imem_load_rdy;  // IMEM answers in one cycle
    end
  end : _load_wait

  //--------------------------------------------------------
  // eduBOS5 itself
  //--------------------------------------------------------
  edubos5 #(
      .EN_WAIT4REGS(EDUBOS5_WAIT4REGS)
  ) u_cpu (
      .clk   (bus.clk),
      .arst_n(bus.arst_n & imem_cpu_rstn),

      .imem_addr(imem_addr),
      .imem_rdat(imem_rdat),
      .imem_rdy (1'b1),       // IMEM answers in one cycle
      .imem_vld (imem_vld),

      .dmem_addr  (dmem_addr),
      .dmem_we    (dmem_we),
      .dmem_strobe(  /*LINT:OK*/),  // dmem_vld is the request
      .dmem_wdat  (dmem_wdat),
      .dmem_rdat  (dmem_rdat),
      .dmem_rdy   (dmem_rdy),
      .dmem_vld   (dmem_vld)
  );

  //----------------------------------------------------
  // Instruction (aka Program) memory for the CPU
  //----------------------------------------------------
  imem #(
      .NUM_WORDS(NUM_WORDS_IMEM)
  ) u_imem (
      .clk   (bus.clk),
      .arst_n(bus.arst_n),

      // instruction fetch
      .rvld (imem_vld),
      .rrdy (  /*LINT:OK*/),  // eduBOS5 takes the data one cycle after the address
      .raddr(imem_addr),
      .rdat (imem_rdat),

      // port B: program reload (CPU in reset), else CPU data loads
      .we   (imem_we),
      .waddr(imem_we ? imem_waddr : dmem_addr[31:2]),
      .wdat (imem_wdat),
      .wrdat(imem_load_rdat)
  );

endmodule : soc_cpu
