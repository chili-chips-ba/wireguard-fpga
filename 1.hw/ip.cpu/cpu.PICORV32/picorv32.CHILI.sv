// SPDX-FileCopyrightText: 2015 Clifford Wolf <clifford@clifford.at>
// SPDX-FileCopyrightText: 2023-2024 Chili.CHIPS
//
// SPDX-License-Identifier: ISC

/*
--------------------------------------------------------------------------
 Improved by Chili.CHIPS (2023/24)
--------------------------------------------------------------------------
 *
 *  PicoRV32 -- A Small RISC-V (RV32I) Processor Core
 *
 *  Copyright (C) 2015  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

// verilator lint_off WIDTH
// verilator lint_off CASEINCOMPLETE

// this macro can be used to check if the verilog files in your
// design are read in the correct order.
`define PICORV32_V

// the RVFI outputs are built from the debug state
`ifdef RISCV_FORMAL
`define CPU_DEBUG
`endif

`ifdef CPU_DEBUGFSM
longint dbgfsm_clk_cnt[2];
longint dbgfsm_insn_cnt;

`define CPU_DBGFSM(debug_command) debug_command
`else
`define CPU_DBGFSM(debug_command)
`endif

`ifdef CPU_FORMAL
`define FORMAL_KEEP (* keep *)
`define ASSERT(assert_expr) assert(assert_expr)

`else
`ifdef CPU_DEBUGNETS
`define FORMAL_KEEP (* keep *)
`else
`define FORMAL_KEEP
`endif

// In non-formal mode `ASSERT calls empty_statement, a no-op task declared
// inside module picorv32 below (empty statements are unsupported by plain
// Verilog syntax).
`define ASSERT(assert_expr) empty_statement
`endif

// uncomment this for register file in extra module
//[JI] ORIG `define PICORV32_REGS picorv32_regs
// `define PICORV32_REGS dprf_32x32bit


//##############################################################
// picorv32 CPU core
//##############################################################

module picorv32 #(
    parameter logic [31:0] PROGADDR_RESET = 32'h0010_0000,
    parameter logic [31:0] STACKADDR      = 32'hffff_ffff,
    parameter logic [ 0:0] COMPRESSED_ISA = 0,

    parameter logic [0:0] TWO_STAGE_SHIFT   = 1,
    parameter logic [0:0] TWO_CYCLE_COMPARE = 0,
    parameter logic [0:0] TWO_CYCLE_ALU     = 0,

    parameter logic [0:0] LATCHED_MEM_RDATA = 0,
    parameter logic [0:0] BARREL_SHIFTER    = 0,
    parameter logic [0:0] ENABLE_MUL        = 0,
    parameter logic [0:0] ENABLE_FAST_MUL   = 0,
    parameter logic [0:0] ENABLE_DIV        = 0,

    parameter logic [0:0] ENABLE_REGS_DUALPORT = 1,
    parameter logic [0:0] ENABLE_REGS_16_31    = 1,
    parameter logic [0:0] ENABLE_PCPI          = 0,
    parameter logic [0:0] ENABLE_COUNTERS      = 0,
    parameter logic [0:0] ENABLE_COUNTERS64    = 0,
    parameter logic [0:0] ENABLE_TRACE         = 0,

    parameter logic [ 0:0] ENABLE_IRQ       = 0,
    parameter logic [ 0:0] ENABLE_IRQ_QREGS = 0,
    parameter logic [ 0:0] ENABLE_IRQ_TIMER = 0,
    parameter logic [31:0] MASKED_IRQ       = 32'h0000_0000,
    parameter logic [31:0] LATCHED_IRQ      = 32'hffff_ffff,
    parameter logic [31:0] PROGADDR_IRQ     = 32'h0000_0010,

    parameter logic [0:0] CATCH_MISALIGN = 1,  // Misaligned Data or Instruction
    parameter logic [0:0] CATCH_ILLINSN  = 1,  // Illegal Instruction
    parameter logic [0:0] TARGET_IS_ASIC = 0   // 1: x0 forced to 0 by a read mux, not RAM init
) (
    input  logic clk,
    resetn,
    output logic trap,

    output logic mem_valid,
    output logic mem_instr,
    input  logic mem_ready,

    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    output logic [ 3:0] mem_wstrb,
    input  logic [31:0] mem_rdata,

    // Look-Ahead Interface
    output logic        mem_la_read,
    output logic        mem_la_write,
    output logic [31:0] mem_la_addr,
    output logic [31:0] mem_la_wdata,
    output logic [ 3:0] mem_la_wstrb,

    // Pico Co-Processor Interface (PCPI)
    output logic        pcpi_valid,
    output logic [31:0] pcpi_insn,
    output logic [31:0] pcpi_rsrc1,
    output logic [31:0] pcpi_rsrc2,

    input logic [31:0] pcpi_rdst,
    input logic        pcpi_wr,
    input logic        pcpi_wait,
    input logic        pcpi_ready,

    // IRQ Interface
    input  logic [31:0] irq,
    output logic [31:0] eoi,

`ifdef RISCV_FORMAL
    output logic        rvfi_valid,
    output logic [63:0] rvfi_order,
    output logic [31:0] rvfi_insn,
    output logic        rvfi_trap,
    output logic        rvfi_halt,
    output logic        rvfi_intr,

    output logic [ 4:0] rvfi_rs1_addr,
    output logic [31:0] rvfi_rs1_rdata,
    output logic [ 4:0] rvfi_rs2_addr,
    output logic [31:0] rvfi_rs2_rdata,
    output logic [ 4:0] rvfi_rd_addr,
    output logic [31:0] rvfi_rd_wdata,

    output logic [31:0] rvfi_pc_rdata,
    output logic [31:0] rvfi_pc_wdata,
    output logic [31:0] rvfi_mem_addr,
    output logic [31:0] rvfi_mem_wdata,
    output logic [ 3:0] rvfi_mem_wmask,
    output logic [31:0] rvfi_mem_rdata,
    output logic [ 3:0] rvfi_mem_rmask,
`endif

    // Trace Interface
    output logic        trace_valid,
    output logic [35:0] trace_data
);

`ifndef CPU_FORMAL
  // This task is used by the `ASSERT directive in non-formal mode to
  // avoid empty statement (which are unsupported by plain Verilog syntax).
  // Declared inside the module, not at file ($unit) scope, so that tools
  // without $unit support - and Verilog-2005 flows - accept it.
  task automatic empty_statement();
  endtask
`endif

  localparam int IRQ_TIMER = 0;
  localparam int IRQ_EBREAK = 1;
  localparam int IRQ_BUSERROR = 2;

  localparam int IRQREGS_OFFSET = ENABLE_REGS_16_31 ? 32 : 16;
  localparam int REGFILE_SIZE = (ENABLE_REGS_16_31 ? 32 : 16) + 4 * ENABLE_IRQ * ENABLE_IRQ_QREGS;
  localparam int REGINDEX_BITS = (ENABLE_REGS_16_31 ? 5 : 4) + ENABLE_IRQ * ENABLE_IRQ_QREGS;

  localparam logic WITH_PCPI = ENABLE_PCPI | ENABLE_MUL | ENABLE_FAST_MUL | ENABLE_DIV;

  localparam logic [35:0] TRACE_BRANCH = {4'b0001, 32'b0};
  localparam logic [35:0] TRACE_ADDR = {4'b0010, 32'b0};
  localparam logic [35:0] TRACE_IRQ = {4'b1000, 32'b0};

  logic [31:0] reg_pc, reg_next_pc, reg_op1, reg_op2, reg_out;
  logic [4:0] reg_sh;

`ifdef CPU_DEBUG
  logic [31:0] next_insn_opcode;
`endif

  logic [31:1] next_pc;  // bit 0 is next_pc_0, used by CPU_DEBUG only

  logic        irq_delay;
  logic        irq_active;
  logic [31:0] irq_mask;
  logic [31:0] irq_pending;
  logic [31:0] irq_timer;

  // Masked-pending IRQ vector, computed once and reused everywhere instead
  // of repeating `irq_pending & ~irq_mask` at each use site.
  logic [31:0] irq_pending_masked;
  assign irq_pending_masked = irq_pending & ~irq_mask;

  // Reduction to a provably 1-bit boolean ("is any unmasked IRQ pending?").
  // Built with the unary reduction-OR operator (not bitwise `|`), so it is
  // 1-bit by construction.
  logic any_irq_pending_masked;
  assign any_irq_pending_masked = |irq_pending_masked;

  logic [63:0] count_cycle, count_instr;  // used ENABLE_COUNTERS*


`ifndef PICORV32_REGS
  logic [31:0] cpuregs[REGFILE_SIZE];

  // FPGA: x0, never written, reads 0 because the RAM starts at 0 (its INIT value)
  initial begin
    if (!TARGET_IS_ASIC) begin
      for (int i = 0; i < REGFILE_SIZE; i++) begin
        cpuregs[i] = 0;
      end
    end
  end
`endif

  //=============================================================
  // Internal PCPI Cores
  //=============================================================
  // pcpi_insn: registered only when WITH_PCPI (it feeds the PCPI cores
  // below), tied to 0 otherwise -- one driver either way.
  // picorv32.ORIG.sv registers it on every Stage-2 decode regardless.
  generate
    if (WITH_PCPI) begin : g_pcpi_insn_reg
      always_ff @(posedge clk) begin
        if (stage2_decode_trigger) begin
          pcpi_insn <= mem_rdata_q;
        end
      end
    end
    else begin : g_pcpi_insn_tie
      assign pcpi_insn = '0;
    end
  endgenerate

  assign pcpi_rsrc1 = reg_op1;
  assign pcpi_rsrc2 = reg_op2;

  logic        pcpi_mul_wr;
  logic [31:0] pcpi_mul_rdst;
  logic        pcpi_mul_wait;
  logic        pcpi_mul_ready;

  logic        pcpi_div_wr;
  logic [31:0] pcpi_div_rdst;
  logic        pcpi_div_wait;
  logic        pcpi_div_ready;

  logic        pcpi_int_wr;
  logic [31:0] pcpi_int_rdst;
  logic        pcpi_int_wait;
  logic        pcpi_int_ready;

  generate
    if (ENABLE_FAST_MUL) begin : g_enable_fast_mul
      picorv32_pcpi_fast_mul pcpi_mul (
          .clk   (clk),    //i
          .resetn(resetn), //i

          .pcpi_valid(pcpi_valid),  //i
          .pcpi_insn (pcpi_insn),   //i
          .pcpi_rs1  (pcpi_rsrc1),  //i[31:0]
          .pcpi_rs2  (pcpi_rsrc2),  //i[31:0]

          .pcpi_wr   (pcpi_mul_wr),    //o
          .pcpi_rd   (pcpi_mul_rdst),  //o[31:0]
          .pcpi_wait (pcpi_mul_wait),  //o
          .pcpi_ready(pcpi_mul_ready)  //o
      );
    end
    else if (ENABLE_MUL) begin : g_enable_mul
      picorv32_pcpi_mul pcpi_mul (
          .clk   (clk),    //i
          .resetn(resetn), //i

          .pcpi_valid(pcpi_valid),  //i
          .pcpi_insn (pcpi_insn),   //i
          .pcpi_rs1  (pcpi_rsrc1),  //i[31:0]
          .pcpi_rs2  (pcpi_rsrc2),  //i[31:0]

          .pcpi_wr   (pcpi_mul_wr),    //o
          .pcpi_rd   (pcpi_mul_rdst),  //o[31:0]
          .pcpi_wait (pcpi_mul_wait),  //o
          .pcpi_ready(pcpi_mul_ready)  //o
      );
    end
    else begin : g_no_hw_mul
      assign pcpi_mul_wr    = '0;
      assign pcpi_mul_rdst  = '0;
      assign pcpi_mul_wait  = '0;
      assign pcpi_mul_ready = '0;
    end
  endgenerate

  //-----------------------------------------
  generate
    if (ENABLE_DIV) begin : g_enable_div
      picorv32_pcpi_div pcpi_div (
          .clk   (clk),    //i
          .resetn(resetn), //i

          .pcpi_valid(pcpi_valid),  //i
          .pcpi_insn (pcpi_insn),   //i
          .pcpi_rs1  (pcpi_rsrc1),  //i[31:0]
          .pcpi_rs2  (pcpi_rsrc2),  //i[31:0]

          .pcpi_wr   (pcpi_div_wr),    //o
          .pcpi_rdst (pcpi_div_rdst),  //o[31:0]
          .pcpi_wait (pcpi_div_wait),  //o
          .pcpi_ready(pcpi_div_ready)  //o
      );
    end
    else begin : g_no_hw_div
      assign pcpi_div_wr    = '0;
      assign pcpi_div_rdst  = '0;
      assign pcpi_div_wait  = '0;
      assign pcpi_div_ready = '0;
    end
  endgenerate

  //-----------------------------------------
  always_comb begin
    pcpi_int_wait  = (ENABLE_PCPI & pcpi_wait)
                     |((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_wait)
                     | (ENABLE_DIV & pcpi_div_wait);

    pcpi_int_ready =  (ENABLE_PCPI & pcpi_ready)
                     | ((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_ready)
                     |  (ENABLE_DIV & pcpi_div_ready);

    //[JI] (* parallel_case *)
    pcpi_int_wr = '0;
    pcpi_int_rdst = '0;

    if (ENABLE_PCPI & pcpi_ready) begin
      pcpi_int_wr   = pcpi_wr;
      pcpi_int_rdst = pcpi_rdst;
    end
    else if ((ENABLE_MUL | ENABLE_FAST_MUL) & pcpi_mul_ready) begin
      pcpi_int_wr   = pcpi_mul_wr;
      pcpi_int_rdst = pcpi_mul_rdst;
    end
    else if (ENABLE_DIV & pcpi_div_ready) begin
      pcpi_int_wr   = pcpi_div_wr;
      pcpi_int_rdst = pcpi_div_rdst;
    end
  end

  //=============================================================
  // Memory Interface
  //=============================================================
  logic [ 1:0] mem_state;
  logic [ 1:0] mem_wordsize;
  logic [31:0] mem_rdata_word;
  logic [31:0] mem_rdata_q;
  logic        mem_do_prefetch;
  logic        mem_do_rinst;
  logic        mem_do_rdata;
  logic        mem_do_wdata;

  logic        mem_xfer;
  logic mem_la_secondword, mem_la_firstword_reg, last_mem_valid;

  logic mem_la_firstword;
  assign mem_la_firstword = COMPRESSED_ISA
                                     & (mem_do_prefetch | mem_do_rinst)
                                     &  next_pc[1]
                                     & !mem_la_secondword;

  logic mem_la_firstword_xfer;
  assign mem_la_firstword_xfer = COMPRESSED_ISA
                                     & mem_xfer
                                     & (last_mem_valid ? mem_la_firstword_reg
                                                       : mem_la_firstword);

  logic        prefetched_high_word;
  logic        clear_prefetched_high_word;
  logic [15:0] mem_16bit_buffer;

  logic [31:0] mem_rdata_latched_noshuffle;
  logic [31:0] mem_rdata_latched;

  logic        mem_la_use_prefetched_high_word;
  assign mem_la_use_prefetched_high_word = COMPRESSED_ISA
                                          &  mem_la_firstword
                                          &  prefetched_high_word
                                          & ~clear_prefetched_high_word;

  assign mem_xfer = (mem_valid & mem_ready) | (mem_la_use_prefetched_high_word & mem_do_rinst);

  logic mem_done;
  assign mem_done = resetn
                   &((mem_xfer & |mem_state & |{mem_do_rinst, mem_do_rdata, mem_do_wdata})
                       | (&mem_state & mem_do_rinst))
                   &(~mem_la_firstword | (~&mem_rdata_latched[1:0] & mem_xfer));

  assign mem_la_write = resetn & (mem_state == 2'd0)  /* !mem_state [JI] */
      & mem_do_wdata;

  assign mem_la_read  = resetn
       & ((~mem_la_use_prefetched_high_word
            & (mem_state == 2'd0) /* !mem_state [JI] */
      & (mem_do_rinst | mem_do_prefetch | mem_do_rdata)
         )
       | (COMPRESSED_ISA & mem_xfer & (last_mem_valid ? mem_la_firstword_reg : mem_la_firstword) &
          ~mem_la_secondword & &mem_rdata_latched[1:0]));

  assign mem_la_addr[1:0] = 2'd0;
  assign mem_la_addr[31:2] = (mem_do_prefetch | mem_do_rinst)
                            ? (next_pc[31:2] + {29'd0, mem_la_firstword_xfer})
                            :  reg_op1[31:2];

  assign mem_rdata_latched_noshuffle = (mem_xfer | LATCHED_MEM_RDATA) ? mem_rdata : mem_rdata_q;

  assign mem_rdata_latched =
      COMPRESSED_ISA && mem_la_use_prefetched_high_word ? {16'hxxxx, mem_16bit_buffer} :
      COMPRESSED_ISA && mem_la_secondword ? {mem_rdata_latched_noshuffle[15:0], mem_16bit_buffer} :
      COMPRESSED_ISA && mem_la_firstword ? {16'hxxxx, mem_rdata_latched_noshuffle[31:16]} :
      mem_rdata_latched_noshuffle;

  // Declared here, ahead of its first use in the decoder below.
  // Compressed-ISA C.JALR recognition (quadrant 2, funct3=100, rd/rs1!=0,
  // rs2==0), computed once and reused at both of its call sites -- the
  // mem_rdata_q-populating pass and the instr_jalr-setting pass both check
  // this same bit pattern of mem_rdata_latched.
  logic is_c_jalr;
  assign is_c_jalr = mem_rdata_latched[12] != 0 && mem_rdata_latched[11:7] != 0 &&
                     mem_rdata_latched[6:2] == 0;

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      mem_la_firstword_reg <= '0;
      last_mem_valid       <= '0;
    end
    else begin
      if (!last_mem_valid) begin
        mem_la_firstword_reg <= mem_la_firstword;
      end
      last_mem_valid <= mem_valid && !mem_ready;
    end
  end

  always_comb begin
    //[JI] Added to eliminate Latch inference
    mem_la_wdata   = reg_op2;  //[JI]
    mem_la_wstrb   = 4'b1111;  //[JI]
    mem_rdata_word = mem_rdata;  //[JI]
    unique0 case (mem_wordsize)
      2'd0: begin  // Word
        mem_la_wdata   = reg_op2;
        mem_la_wstrb   = 4'b1111;
        mem_rdata_word = mem_rdata;
      end
      2'd1: begin  // Half
        mem_la_wdata = {2{reg_op2[15:0]}};
        mem_la_wstrb = reg_op1[1] ? 4'b1100 : 4'b0011;
        unique0 case (reg_op1[1])
          1'b0: mem_rdata_word = {16'b0, mem_rdata[15:0]};
          1'b1: mem_rdata_word = {16'b0, mem_rdata[31:16]};
        endcase
      end
      2'd2: begin  // Byte
        mem_la_wdata = {4{reg_op2[7:0]}};
        mem_la_wstrb = 4'b0001 << reg_op1[1:0];

        unique0 case (reg_op1[1:0])
          2'b00: mem_rdata_word = {24'b0, mem_rdata[7:0]};
          2'b01: mem_rdata_word = {24'b0, mem_rdata[15:8]};
          2'b10: mem_rdata_word = {24'b0, mem_rdata[23:16]};
          2'b11: mem_rdata_word = {24'b0, mem_rdata[31:24]};
        endcase
      end  // case: 2

    endcase
  end

  always_ff @(posedge clk) begin
    if (mem_xfer) begin
      mem_rdata_q <= COMPRESSED_ISA ? mem_rdata_latched : mem_rdata;
`ifdef CPU_DEBUG
      next_insn_opcode <= COMPRESSED_ISA ? mem_rdata_latched : mem_rdata;
`endif

      if (mem_instr == 1'b0) begin
        if (mem_wstrb == '0) begin  // read
          `CPU_DBGFSM($display("%14s| [%08X]=>%08X", cpu_state.name, mem_addr, mem_rdata);)
        end
        else begin  // write
          `CPU_DBGFSM($display(
                      "%14s| [%08X]<=%08X (WE=%b)", cpu_state.name, mem_addr, mem_wdata, mem_wstrb
                      );)
        end
      end

    end

    if (COMPRESSED_ISA && mem_done && (mem_do_prefetch || mem_do_rinst)) begin
      unique0 case (mem_rdata_latched[1:0])

        2'b00: begin  //_____Quadrant 0_____
          unique0 case (mem_rdata_latched[15:13])
            3'b000: begin  // C.ADDI4SPN
              mem_rdata_q[14:12] <= 3'b000;
              mem_rdata_q[31:30] <= 2'd0;
              mem_rdata_q[29:26] <= mem_rdata_latched[10:7];
              mem_rdata_q[25:24] <= mem_rdata_latched[12:11];
              mem_rdata_q[23]    <= mem_rdata_latched[5];
              mem_rdata_q[22]    <= mem_rdata_latched[6];
              mem_rdata_q[21:20] <= 2'd0;
            end
            3'b010: begin  // C.LW
              mem_rdata_q[31:20] <= {
                5'b0, mem_rdata_latched[5], mem_rdata_latched[12:10], mem_rdata_latched[6], 2'b00
              };
              mem_rdata_q[14:12] <= 3'b010;
            end
            3'b110: begin  // C.SW
              {mem_rdata_q[31:25], mem_rdata_q[11:7]} <= {
                5'b0, mem_rdata_latched[5], mem_rdata_latched[12:10], mem_rdata_latched[6], 2'b00
              };
              mem_rdata_q[14:12] <= 3'b010;
            end
          endcase
        end  // case: 2'b00

        2'b01: begin  //_____Quadrant 1_____
          unique0 case (mem_rdata_latched[15:13])

            3'b000: begin  // C.ADDI
              //mem_rdata_q[31:25] <={7{mem_rdata_latched[12]}}; //[JI] sign-extend
              //mem_rdata_q[24:20] <=   mem_rdata_latched[6:2];
              //mem_rdata_q[14:12] <= 3'd0;
              mem_rdata_q[14:12] <= 3'b000;
              mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
            end

            3'b010: begin  // C.LI
              //mem_rdata_q[31:25] <={7{mem_rdata_latched[12]}}; //[JI] sign-extend
              //mem_rdata_q[24:20] <=   mem_rdata_latched[6:2];
              //mem_rdata_q[14:12] <= 3'd0;
              mem_rdata_q[14:12] <= 3'b000;
              mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
            end

            3'b011: begin
              if (mem_rdata_latched[11:7] == 2) begin  // C.ADDI16SP
                // mem_rdata_q[14:12] <= 3'b000;
                //
                // mem_rdata_q[31:29] <={3{mem_rdata_latched[12]}}; //[JI] sign-extend
                // mem_rdata_q[28:27] <=   mem_rdata_latched[4:3];
                // mem_rdata_q[26]    <=   mem_rdata_latched[5];
                // mem_rdata_q[25]    <=   mem_rdata_latched[2];
                // mem_rdata_q[24]    <=   mem_rdata_latched[6];
                // mem_rdata_q[23:20] <= 4'd0;
                mem_rdata_q[14:12] <= 3'b000;
                mem_rdata_q[31:20] <= $signed(
                    {
                      mem_rdata_latched[12],
                      mem_rdata_latched[4:3],
                      mem_rdata_latched[5],
                      mem_rdata_latched[2],
                      mem_rdata_latched[6],
                      4'b0000
                    }
                );
              end
              else begin  // C.LUI
                //mem_rdata_q[31:17] <={15{mem_rdata_latched[12]}}; //[JI] sign-extend
                //mem_rdata_q[16:12] <=    mem_rdata_latched[6:2];
                mem_rdata_q[31:12] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
              end
            end

            3'b100: begin
              if (mem_rdata_latched[11:10] == 2'b00) begin  // C.SRLI
                mem_rdata_q[31:25] <= 7'b0000000;
                mem_rdata_q[14:12] <= 3'b101;
              end
              if (mem_rdata_latched[11:10] == 2'b01) begin  // C.SRAI
                mem_rdata_q[31:25] <= 7'b0100000;
                mem_rdata_q[14:12] <= 3'b101;
              end
              if (mem_rdata_latched[11:10] == 2'b10) begin  // C.ANDI
                //mem_rdata_q[31:25] <={7{mem_rdata_latched[12]}}; //[JI] sign-extend
                //mem_rdata_q[24:20] <=   mem_rdata_latched[6:2];
                //mem_rdata_q[14:12] <= 3'b111;
                mem_rdata_q[14:12] <= 3'b111;
                mem_rdata_q[31:20] <= $signed({mem_rdata_latched[12], mem_rdata_latched[6:2]});
              end
              if (mem_rdata_latched[12:10] == 3'b011) begin  // C.SUB, C.XOR, C.OR, C.AND
                if (mem_rdata_latched[6:5] == 2'b00) begin
                  mem_rdata_q[14:12] <= 3'b000;
                end
                if (mem_rdata_latched[6:5] == 2'b01) begin
                  mem_rdata_q[14:12] <= 3'b100;
                end
                if (mem_rdata_latched[6:5] == 2'b10) begin
                  mem_rdata_q[14:12] <= 3'b110;
                end
                if (mem_rdata_latched[6:5] == 2'b11) begin
                  mem_rdata_q[14:12] <= 3'b111;
                end

                mem_rdata_q[31:25] <= (mem_rdata_latched[6:5] == 2'd0) ? 7'b0100000 : 7'b0000000;
              end
            end  // case: 3'b100

            3'b110: begin  // C.BEQZ
              mem_rdata_q[14:12] <= 3'b000;

              {mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8]}
              // <= {{5{mem_rdata_latched[12]}}, //[JI] sign-extend
              //        mem_rdata_latched[6:5],
              //        mem_rdata_latched[2],
              //        mem_rdata_latched[11:10],
              //        mem_rdata_latched[4:3]};
              <= $signed(
                  {
                    mem_rdata_latched[12],
                    mem_rdata_latched[6:5],
                    mem_rdata_latched[2],
                    mem_rdata_latched[11:10],
                    mem_rdata_latched[4:3]
                  }
              );
            end
            3'b111: begin  // C.BNEZ
              // mem_rdata_q[14:12] <= 3'b001;
              //
              //{mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8]}
              // <= {{5{mem_rdata_latched[12]}}, //[JI] sign-extend
              //        mem_rdata_latched[6:5],
              //        mem_rdata_latched[2],
              //        mem_rdata_latched[11:10],
              //        mem_rdata_latched[4:3]};
              mem_rdata_q[14:12] <= 3'b001;
              {mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8]} <= $signed(
                  {
                    mem_rdata_latched[12],
                    mem_rdata_latched[6:5],
                    mem_rdata_latched[2],
                    mem_rdata_latched[11:10],
                    mem_rdata_latched[4:3]
                  }
              );
            end
          endcase
        end  // case: 2'b01

        2'b10: begin  //_____Quadrant 2_____
          unique0 case (mem_rdata_latched[15:13])
            3'b000: begin  // C.SLLI
              mem_rdata_q[31:25] <= 7'b0000000;
              mem_rdata_q[14:12] <= 3'b001;
            end
            3'b010: begin  // C.LWSP
              mem_rdata_q[31:20] <= {
                4'b0, mem_rdata_latched[3:2], mem_rdata_latched[12], mem_rdata_latched[6:4], 2'b00
              };
              mem_rdata_q[14:12] <= 3'b010;
            end
            3'b100: begin
              if (mem_rdata_latched[12] == 0 && mem_rdata_latched[6:2] == 0) begin  // C.JR
                mem_rdata_q[14:12] <= 3'b000;
                mem_rdata_q[31:20] <= 12'b0;
              end
              if (mem_rdata_latched[12] == 0 && mem_rdata_latched[6:2] != 0) begin  // C.MV
                mem_rdata_q[14:12] <= 3'b000;
                mem_rdata_q[31:25] <= 7'b0000000;
              end
              if (is_c_jalr) begin  // C.JALR
                mem_rdata_q[14:12] <= 3'b000;
                mem_rdata_q[31:20] <= 12'b0;
              end
              if (mem_rdata_latched[12] != 0 && mem_rdata_latched[6:2] != 0) begin  // C.ADD
                mem_rdata_q[14:12] <= 3'b000;
                mem_rdata_q[31:25] <= 7'b0000000;
              end
            end
            3'b110: begin  // C.SWSP
              {mem_rdata_q[31:25], mem_rdata_q[11:7]} <= {
                4'b0, mem_rdata_latched[8:7], mem_rdata_latched[12:9], 2'b00
              };
              mem_rdata_q[14:12] <= 3'b010;
            end
          endcase
        end  // case: 2'b10

      endcase
    end
  end  // always_ff @ (posedge clk)


  always_ff @(posedge clk) begin
    if (resetn && !trap) begin
      if (mem_do_prefetch || mem_do_rinst || mem_do_rdata) begin
        `ASSERT(!mem_do_wdata);
      end
      if (mem_do_prefetch || mem_do_rinst) begin
        `ASSERT(!mem_do_rdata);
      end
      if (mem_do_rdata) begin
        `ASSERT(!mem_do_prefetch && !mem_do_rinst);
      end
      if (mem_do_wdata) begin
        `ASSERT(!(mem_do_prefetch || mem_do_rinst || mem_do_rdata));
      end
      if (mem_state == 2'd2 || mem_state == 2'd3) begin
        `ASSERT(mem_valid || mem_do_prefetch);
      end
    end
  end

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      mem_valid            <= '0;
      mem_la_secondword    <= '0;
      prefetched_high_word <= '0;
      mem_addr             <= '0;
      mem_wstrb            <= '0;
      mem_wdata            <= '0;
      mem_instr            <= '0;
      mem_state            <= '0;
      mem_16bit_buffer     <= '0;
    end
    else begin
      if (trap) begin
        if (mem_ready) begin
          mem_valid <= '0;
        end
        mem_la_secondword    <= '0;
        prefetched_high_word <= '0;
      end
      else begin
        if (mem_la_read || mem_la_write) begin
          mem_addr  <= mem_la_addr;
          mem_wstrb <= mem_la_wstrb & {4{mem_la_write}};
        end
        if (mem_la_write) begin
          mem_wdata <= mem_la_wdata;
        end

        unique0 case (mem_state)
          //-------
          2'd0: begin
            if (|{mem_do_prefetch, mem_do_rinst, mem_do_rdata} == 1'b1) begin
              mem_valid <= ~mem_la_use_prefetched_high_word;
              mem_instr <= mem_do_prefetch | mem_do_rinst;
              mem_wstrb <= '0;
              mem_state <= 2'd1;
            end

            if (mem_do_wdata) begin
              mem_valid <= 1'b1;
              mem_instr <= 1'b0;
              mem_state <= 2'd2;
            end
          end
          //-------
          2'd1: begin
            `ASSERT(mem_wstrb == 0);
            `ASSERT(mem_do_prefetch | mem_do_rinst | mem_do_rdata);
            `ASSERT(mem_valid == ~mem_la_use_prefetched_high_word);
            `ASSERT(mem_instr == (mem_do_prefetch | mem_do_rinst));

            if (mem_xfer) begin
              if (COMPRESSED_ISA && mem_la_read) begin
                mem_valid         <= 1;
                mem_la_secondword <= 1;
                if (!mem_la_use_prefetched_high_word) begin
                  mem_16bit_buffer <= mem_rdata[31:16];
                end
              end
              else begin
                mem_valid         <= 0;
                mem_la_secondword <= 0;

                if (COMPRESSED_ISA && !mem_do_rdata) begin
                  if (~&mem_rdata[1:0] || mem_la_secondword) begin
                    mem_16bit_buffer     <= mem_rdata[31:16];
                    prefetched_high_word <= 1;
                  end
                  else begin
                    prefetched_high_word <= 0;
                  end
                end

                mem_state <= (mem_do_rinst | mem_do_rdata) ? 2'd0 : 2'd3;
              end
            end
          end
          //-------
          2'd2: begin
            `ASSERT(mem_wstrb != 0);
            `ASSERT(mem_do_wdata);

            if (mem_xfer) begin
              mem_valid <= '0;
              mem_state <= 2'd0;
            end
          end
          //-------
          2'd3: begin
            `ASSERT(mem_wstrb == 0);
            `ASSERT(mem_do_prefetch);

            if (mem_do_rinst) begin
              mem_state <= 2'd0;
            end
          end

          //-------
        endcase
      end

      if (clear_prefetched_high_word) begin
        prefetched_high_word <= 0;
      end
    end
  end  // always_ff @ (posedge clk)


  //=============================================================
  // Instruction Decoder
  //=============================================================
  logic instr_lui, instr_auipc, instr_jal, instr_jalr;
  logic instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu;
  logic instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw;
  logic
      instr_addi,
      instr_slti,
      instr_sltiu,
      instr_xori,
      instr_ori,
      instr_andi,
      instr_slli,
      instr_srli,
      instr_srai;
  logic
      instr_add,
      instr_sub,
      instr_sll,
      instr_slt,
      instr_sltu,
      instr_xor,
      instr_srl,
      instr_sra,
      instr_or,
      instr_and;
  logic instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh, instr_ecall_ebreak;
  logic instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer;
  logic instr_trap;

  logic [REGINDEX_BITS-1:0] decoded_rdst, decoded_rsrc1, decoded_rsrc2;
  logic [31:0] decoded_imm, decoded_imm_uj;
  logic decoder_trigger;
  logic decoder_trigger_q;
  logic decoder_pseudo_trigger;
  logic decoder_pseudo_trigger_q;
  logic compressed_instr;

  // Stage-2 decode fire condition, computed once and reused everywhere
  // instead of repeating `decoder_trigger && !decoder_pseudo_trigger`
  // verbatim at each use site (the main FSM's Stage-2 decode block, and
  // the pcpi_insn generate block below).
  logic stage2_decode_trigger;
  assign stage2_decode_trigger = decoder_trigger && !decoder_pseudo_trigger;

  logic is_lui_auipc_jal;
  logic is_lb_lh_lw_lbu_lhu;
  logic is_slli_srli_srai;
  logic is_jalr_addi_slti_sltiu_xori_ori_andi;
  logic is_sb_sh_sw;
  logic is_sll_srl_sra;
  logic is_lui_auipc_jal_jalr_addi_add_sub;
  logic is_slti_blt_slt;
  logic is_sltiu_bltu_sltu;
  logic is_beq_bne_blt_bge_bltu_bgeu;
  logic is_lbu_lhu_lw;
  logic is_alu_reg_imm;
  logic is_alu_reg_reg;
  logic is_compare;

  assign instr_trap = (CATCH_ILLINSN || WITH_PCPI) && !{
      instr_lui, instr_auipc, instr_jal, instr_jalr,
      instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu,
      instr_lb, instr_lh, instr_lw, instr_lbu, instr_lhu, instr_sb, instr_sh, instr_sw,
      instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi,
      instr_slli, instr_srli, instr_srai,
      instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor,
      instr_srl, instr_sra, instr_or, instr_and,
      instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh,
      instr_getq, instr_setq, instr_retirq, instr_maskirq, instr_waitirq, instr_timer
  };

  logic is_rdcycle_rdcycleh_rdinstr_rdinstrh;
  assign is_rdcycle_rdcycleh_rdinstr_rdinstrh =
      |{instr_rdcycle, instr_rdcycleh, instr_rdinstr, instr_rdinstrh};


  //--------------------------------------------------------------
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      decoded_imm_uj                        <= '0;
      is_lui_auipc_jal                      <= '0;
      is_lui_auipc_jal_jalr_addi_add_sub    <= '0;
      is_lbu_lhu_lw                         <= '0;
      is_compare                            <= 0;
      instr_lui                             <= '0;
      instr_auipc                           <= '0;
      instr_jal                             <= '0;
      instr_jalr                            <= '0;
      instr_retirq                          <= '0;
      instr_waitirq                         <= '0;
      is_beq_bne_blt_bge_bltu_bgeu          <= 0;
      is_lb_lh_lw_lbu_lhu                   <= '0;
      is_sb_sh_sw                           <= '0;
      is_alu_reg_imm                        <= '0;
      is_alu_reg_reg                        <= '0;
      decoded_rdst                          <= '0;
      decoded_rsrc1                         <= '0;
      decoded_rsrc2                         <= '0;
      compressed_instr                      <= '0;
      instr_beq                             <= 0;
      instr_bne                             <= 0;
      instr_blt                             <= 0;
      instr_bge                             <= 0;
      instr_bltu                            <= 0;
      instr_bgeu                            <= 0;
      instr_lb                              <= '0;
      instr_lh                              <= '0;
      instr_lw                              <= '0;
      instr_lbu                             <= '0;
      instr_lhu                             <= '0;
      instr_sb                              <= '0;
      instr_sh                              <= '0;
      instr_sw                              <= '0;
      instr_addi                            <= 0;
      instr_slti                            <= 0;
      instr_sltiu                           <= 0;
      instr_xori                            <= 0;
      instr_ori                             <= 0;
      instr_andi                            <= 0;
      instr_slli                            <= '0;
      instr_srli                            <= '0;
      instr_srai                            <= '0;
      instr_add                             <= 0;
      instr_sub                             <= 0;
      instr_sll                             <= 0;
      instr_slt                             <= 0;
      instr_sltu                            <= 0;
      instr_xor                             <= 0;
      instr_srl                             <= 0;
      instr_sra                             <= 0;
      instr_or                              <= 0;
      instr_and                             <= 0;
      is_slti_blt_slt                       <= '0;
      is_sltiu_bltu_sltu                    <= '0;
      instr_rdcycle                         <= '0;
      instr_rdcycleh                        <= '0;
      instr_rdinstr                         <= '0;
      instr_rdinstrh                        <= '0;
      instr_ecall_ebreak                    <= '0;
      instr_getq                            <= '0;
      instr_setq                            <= '0;
      instr_maskirq                         <= '0;
      instr_timer                           <= '0;
      is_slli_srli_srai                     <= '0;
      is_jalr_addi_slti_sltiu_xori_ori_andi <= '0;
      is_sll_srl_sra                        <= '0;
      decoded_imm                           <= '0;
    end
    else begin
      is_lui_auipc_jal <= |{instr_lui, instr_auipc, instr_jal};
      is_lui_auipc_jal_jalr_addi_add_sub <= |{instr_lui, instr_auipc, instr_jal, instr_jalr,
                                            instr_addi, instr_add, instr_sub};
      // is_slti_blt_slt / is_sltiu_bltu_sltu are set in the decode block,
      // next to instr_slti/instr_blt/instr_slt.
      is_lbu_lhu_lw <= |{instr_lbu, instr_lhu, instr_lw};
      is_compare <= |{is_beq_bne_blt_bge_bltu_bgeu, instr_slti, instr_slt, instr_sltiu, instr_sltu};

      if (mem_do_rinst && mem_done) begin
        instr_lui <= mem_rdata_latched[6:0] == 7'b0110111;
        instr_auipc <= mem_rdata_latched[6:0] == 7'b0010111;
        instr_jal <= mem_rdata_latched[6:0] == 7'b1101111;
        instr_jalr <= mem_rdata_latched[6:0] == 7'b1100111 && mem_rdata_latched[14:12] == 3'b000;
        instr_retirq  <= mem_rdata_latched[6:0] == 7'b0001011 &&
                         mem_rdata_latched[31:25] == 7'b0000010 && ENABLE_IRQ;
        instr_waitirq <= mem_rdata_latched[6:0] == 7'b0001011 &&
                         mem_rdata_latched[31:25] == 7'b0000100 && ENABLE_IRQ;

        is_beq_bne_blt_bge_bltu_bgeu <= mem_rdata_latched[6:0] == 7'b1100011;
        is_lb_lh_lw_lbu_lhu <= mem_rdata_latched[6:0] == 7'b0000011;
        is_sb_sh_sw <= mem_rdata_latched[6:0] == 7'b0100011;
        is_alu_reg_imm <= mem_rdata_latched[6:0] == 7'b0010011;
        is_alu_reg_reg <= mem_rdata_latched[6:0] == 7'b0110011;

        {decoded_imm_uj[31:20],
             decoded_imm_uj[10:1],
             decoded_imm_uj[11],
             decoded_imm_uj[19:12],
             decoded_imm_uj[0]} <= 32'($signed(
            {mem_rdata_latched[31:12], 1'b0}
        ));  //[JI]

        decoded_rdst <= mem_rdata_latched[11:7];
        decoded_rsrc1 <= mem_rdata_latched[19:15];
        decoded_rsrc2 <= mem_rdata_latched[24:20];

        if (mem_rdata_latched[6:0] == 7'b0001011 && mem_rdata_latched[31:25] == 7'b0000000 &&
            ENABLE_IRQ && ENABLE_IRQ_QREGS)
          begin
          decoded_rsrc1[REGINDEX_BITS-1] <= 1;  // instr_getq
        end

        if (mem_rdata_latched[6:0] == 7'b0001011 && mem_rdata_latched[31:25] == 7'b0000010 &&
            ENABLE_IRQ)
          begin
          decoded_rsrc1 <= ENABLE_IRQ_QREGS ? IRQREGS_OFFSET : 3;  // instr_retirq
        end

        compressed_instr <= 0;
        if (COMPRESSED_ISA && mem_rdata_latched[1:0] != 2'b11) begin
          compressed_instr <= 1;
          decoded_rdst <= 0;
          decoded_rsrc1 <= 0;
          decoded_rsrc2 <= 0;

          { decoded_imm_uj[31:11],
                 decoded_imm_uj[4],
                 decoded_imm_uj[9:8],
                 decoded_imm_uj[10],
                 decoded_imm_uj[6],
                 decoded_imm_uj[7],
                 decoded_imm_uj[3:1],
                 decoded_imm_uj[5],
                 decoded_imm_uj[0] } <= 32'($signed(
              {mem_rdata_latched[12:2], 1'b0}
          ));  //[JI]

          unique0 case (mem_rdata_latched[1:0])
            2'b00: begin  //______Quadrant 0______
              unique0 case (mem_rdata_latched[15:13])
                3'b000: begin  // C.ADDI4SPN
                  is_alu_reg_imm <= |mem_rdata_latched[12:5];
                  decoded_rsrc1  <= 2;
                  decoded_rdst   <= 8 + mem_rdata_latched[4:2];
                end
                3'b010: begin  // C.LW
                  is_lb_lh_lw_lbu_lhu <= 1;
                  decoded_rsrc1       <= 8 + mem_rdata_latched[9:7];
                  decoded_rdst        <= 8 + mem_rdata_latched[4:2];
                end
                3'b110: begin  // C.SW
                  is_sb_sh_sw   <= 1;
                  decoded_rsrc1 <= 8 + mem_rdata_latched[9:7];
                  decoded_rsrc2 <= 8 + mem_rdata_latched[4:2];
                end
              endcase
            end
            2'b01: begin  //______Quadrant 1______
              unique0 case (mem_rdata_latched[15:13])
                3'b000: begin  // C.NOP / C.ADDI
                  is_alu_reg_imm <= 1;
                  decoded_rdst   <= mem_rdata_latched[11:7];
                  decoded_rsrc1  <= mem_rdata_latched[11:7];
                end
                3'b001: begin  // C.JAL
                  instr_jal    <= 1;
                  decoded_rdst <= 1;
                end
                3'b010: begin  // C.LI
                  is_alu_reg_imm <= 1;
                  decoded_rdst   <= mem_rdata_latched[11:7];
                  decoded_rsrc1  <= 0;
                end
                3'b011: begin
                  if (mem_rdata_latched[12] || (mem_rdata_latched[6:2] != '0)) begin
                    if (mem_rdata_latched[11:7] == 2) begin  // C.ADDI16SP
                      is_alu_reg_imm <= 1;
                      decoded_rdst   <= mem_rdata_latched[11:7];
                      decoded_rsrc1  <= mem_rdata_latched[11:7];
                    end
                    else begin  // C.LUI
                      instr_lui     <= 1;
                      decoded_rdst  <= mem_rdata_latched[11:7];
                      decoded_rsrc1 <= 0;
                    end
                  end
                end
                3'b100: begin
                  if (!mem_rdata_latched[11] && !mem_rdata_latched[12]) begin  // C.SRLI, C.SRAI
                    is_alu_reg_imm <= 1;
                    decoded_rdst   <= 8 + mem_rdata_latched[9:7];
                    decoded_rsrc1  <= 8 + mem_rdata_latched[9:7];
                    //[JI]decoded_rsrc2 <= {mem_rdata_latched[12], mem_rdata_latched[6:2]};
                    decoded_rsrc2  <= mem_rdata_latched[6:2];
                  end
                  if (mem_rdata_latched[11:10] == 2'b10) begin  // C.ANDI
                    is_alu_reg_imm <= 1;
                    decoded_rdst   <= 8 + mem_rdata_latched[9:7];
                    decoded_rsrc1  <= 8 + mem_rdata_latched[9:7];
                  end
                  if (mem_rdata_latched[12:10] == 3'b011) begin  // C.SUB, C.XOR, C.OR, C.AND
                    is_alu_reg_reg <= 1;
                    decoded_rdst   <= 8 + mem_rdata_latched[9:7];
                    decoded_rsrc1  <= 8 + mem_rdata_latched[9:7];
                    decoded_rsrc2  <= 8 + mem_rdata_latched[4:2];
                  end
                end
                3'b101: begin  // C.J
                  instr_jal <= 1;
                end
                3'b110: begin  // C.BEQZ
                  is_beq_bne_blt_bge_bltu_bgeu <= 1;
                  decoded_rsrc1                <= 8 + mem_rdata_latched[9:7];
                  decoded_rsrc2                <= 0;
                end
                3'b111: begin  // C.BNEZ
                  is_beq_bne_blt_bge_bltu_bgeu <= 1;
                  decoded_rsrc1                <= 8 + mem_rdata_latched[9:7];
                  decoded_rsrc2                <= 0;
                end
              endcase
            end

            2'b10: begin  //______Quadrant 2______
              unique0 case (mem_rdata_latched[15:13])
                3'b000: begin  // C.SLLI
                  if (!mem_rdata_latched[12]) begin
                    is_alu_reg_imm <= 1;
                    decoded_rdst   <= mem_rdata_latched[11:7];
                    decoded_rsrc1  <= mem_rdata_latched[11:7];
                    //[JI]decoded_rsrc2 <= {mem_rdata_latched[12], mem_rdata_latched[6:2]};
                    decoded_rsrc2  <= mem_rdata_latched[6:2];
                  end
                end
                3'b010: begin  // C.LWSP
                  if (mem_rdata_latched[11:7] != '0) begin
                    is_lb_lh_lw_lbu_lhu <= 1;
                    decoded_rdst        <= mem_rdata_latched[11:7];
                    decoded_rsrc1       <= 2;
                  end
                end
                3'b100: begin
                  // C.JR
                  if (mem_rdata_latched[12] == 0 && mem_rdata_latched[11:7] != 0 &&
                      mem_rdata_latched[6:2] == 0) begin
                    instr_jalr    <= 1;
                    decoded_rdst  <= 0;
                    decoded_rsrc1 <= mem_rdata_latched[11:7];
                  end
                  if (mem_rdata_latched[12] == 0 && mem_rdata_latched[6:2] != 0) begin  // C.MV
                    is_alu_reg_reg <= 1;
                    decoded_rdst   <= mem_rdata_latched[11:7];
                    decoded_rsrc1  <= 0;
                    decoded_rsrc2  <= mem_rdata_latched[6:2];
                  end
                  if (is_c_jalr) begin  // C.JALR
                    instr_jalr    <= 1;
                    decoded_rdst  <= 1;
                    decoded_rsrc1 <= mem_rdata_latched[11:7];
                  end
                  if (mem_rdata_latched[12] != 0 && mem_rdata_latched[6:2] != 0) begin  // C.ADD
                    is_alu_reg_reg <= 1;
                    decoded_rdst   <= mem_rdata_latched[11:7];
                    decoded_rsrc1  <= mem_rdata_latched[11:7];
                    decoded_rsrc2  <= mem_rdata_latched[6:2];
                  end
                end
                3'b110: begin  // C.SWSP
                  is_sb_sh_sw   <= 1;
                  decoded_rsrc1 <= 2;
                  decoded_rsrc2 <= mem_rdata_latched[6:2];
                end
              endcase  // unique0 case (mem_rdata_latched[15:13])
            end  // case: 2'b10


          endcase  // unique0 case (mem_rdata_latched[1:0])
        end  // if (COMPRESSED_ISA && mem_rdata_latched[1:0] != 2'b11)
      end  // if (mem_do_rinst && mem_done)

      if (stage2_decode_trigger) begin
        instr_beq <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b000;
        instr_bne <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b001;
        instr_blt <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b100;
        instr_bge <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b101;
        instr_bltu <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b110;
        instr_bgeu <= is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b111;

        instr_lb <= is_lb_lh_lw_lbu_lhu && mem_rdata_q[14:12] == 3'b000;
        instr_lh <= is_lb_lh_lw_lbu_lhu && mem_rdata_q[14:12] == 3'b001;
        instr_lw <= is_lb_lh_lw_lbu_lhu && mem_rdata_q[14:12] == 3'b010;
        instr_lbu <= is_lb_lh_lw_lbu_lhu && mem_rdata_q[14:12] == 3'b100;
        instr_lhu <= is_lb_lh_lw_lbu_lhu && mem_rdata_q[14:12] == 3'b101;

        instr_sb <= is_sb_sh_sw && mem_rdata_q[14:12] == 3'b000;
        instr_sh <= is_sb_sh_sw && mem_rdata_q[14:12] == 3'b001;
        instr_sw <= is_sb_sh_sw && mem_rdata_q[14:12] == 3'b010;

        instr_addi <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b000;
        instr_slti <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b010;
        instr_sltiu <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b011;
        instr_xori <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b100;
        instr_ori <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b110;
        instr_andi <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b111;

        instr_slli  <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b001 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_srli  <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b101 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_srai  <= is_alu_reg_imm && mem_rdata_q[14:12] == 3'b101 &&
                       mem_rdata_q[31:25] == 7'b0100000;

        instr_add   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b000 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_sub   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b000 &&
                       mem_rdata_q[31:25] == 7'b0100000;
        instr_sll   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b001 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_slt   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b010 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_sltu  <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b011 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_xor   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b100 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_srl   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b101 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_sra   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b101 &&
                       mem_rdata_q[31:25] == 7'b0100000;
        instr_or    <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b110 &&
                       mem_rdata_q[31:25] == 7'b0000000;
        instr_and   <= is_alu_reg_reg && mem_rdata_q[14:12] == 3'b111 &&
                       mem_rdata_q[31:25] == 7'b0000000;

        // is_slti_blt_slt / is_sltiu_bltu_sltu, derived from the same decode
        // terms as instr_slti/instr_blt/instr_slt (and the *u variants)
        // above, on this same edge. This makes them provably exclusive with
        // instr_beq/bne/bge/bgeu: for a given mem_rdata_q sample,
        // is_beq_bne_blt_bge_bltu_bgeu, is_alu_reg_imm and is_alu_reg_reg are
        // mutually-exclusive opcode decodes (independent equality checks
        // against the same 7-bit opcode field), and mem_rdata_q[14:12] can
        // only hold one funct3 value at a time -- so at most one term below
        // can ever be true simultaneously with instr_beq/bne/bge/bgeu.
        is_slti_blt_slt    <= (is_alu_reg_imm && mem_rdata_q[14:12] == 3'b010)
                                || (is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b100)
                                || (is_alu_reg_reg && mem_rdata_q[14:12] == 3'b010 &&
                                    mem_rdata_q[31:25] == 7'b0000000);
        is_sltiu_bltu_sltu <= (is_alu_reg_imm && mem_rdata_q[14:12] == 3'b011)
                                || (is_beq_bne_blt_bge_bltu_bgeu && mem_rdata_q[14:12] == 3'b110)
                                || (is_alu_reg_reg && mem_rdata_q[14:12] == 3'b011 &&
                                    mem_rdata_q[31:25] == 7'b0000000);

        instr_rdcycle  <= ((mem_rdata_q[6:0] == 7'b1110011 &&
                            mem_rdata_q[31:12] == 'b11000000000000000010) ||
                           (mem_rdata_q[6:0] == 7'b1110011 &&
                            mem_rdata_q[31:12] == 'b11000000000100000010)) &&
                          ENABLE_COUNTERS;
        instr_rdcycleh <= ((mem_rdata_q[6:0] == 7'b1110011 &&
                            mem_rdata_q[31:12] == 'b11001000000000000010) ||
                           (mem_rdata_q[6:0] == 7'b1110011 &&
                            mem_rdata_q[31:12] == 'b11001000000100000010)) &&
                          ENABLE_COUNTERS && ENABLE_COUNTERS64;
        instr_rdinstr  <= (mem_rdata_q[6:0] == 7'b1110011 &&
                           mem_rdata_q[31:12] == 'b11000000001000000010) &&
                          ENABLE_COUNTERS;
        instr_rdinstrh <= (mem_rdata_q[6:0] == 7'b1110011 &&
                           mem_rdata_q[31:12] == 'b11001000001000000010) &&
                          ENABLE_COUNTERS && ENABLE_COUNTERS64;

        instr_ecall_ebreak <= ((mem_rdata_q[6:0] == 7'b1110011 &&
                                !mem_rdata_q[31:21] && !mem_rdata_q[19:7]) ||
                               (COMPRESSED_ISA && mem_rdata_q[15:0] == 16'h9002));

        instr_getq    <= mem_rdata_q[6:0] == 7'b0001011 && mem_rdata_q[31:25] == 7'b0000000 &&
                         ENABLE_IRQ && ENABLE_IRQ_QREGS;
        instr_setq    <= mem_rdata_q[6:0] == 7'b0001011 && mem_rdata_q[31:25] == 7'b0000001 &&
                         ENABLE_IRQ && ENABLE_IRQ_QREGS;
        instr_maskirq <= mem_rdata_q[6:0] == 7'b0001011 && mem_rdata_q[31:25] == 7'b0000011 &&
                         ENABLE_IRQ;
        instr_timer   <= mem_rdata_q[6:0] == 7'b0001011 && mem_rdata_q[31:25] == 7'b0000101 &&
                         ENABLE_IRQ && ENABLE_IRQ_TIMER;

        is_slli_srli_srai <= is_alu_reg_imm && |{
               mem_rdata_q[14:12] == 3'b001 && mem_rdata_q[31:25] == 7'b0000000,
               mem_rdata_q[14:12] == 3'b101 && mem_rdata_q[31:25] == 7'b0000000,
               mem_rdata_q[14:12] == 3'b101 && mem_rdata_q[31:25] == 7'b0100000
            };

        is_jalr_addi_slti_sltiu_xori_ori_andi <= instr_jalr || is_alu_reg_imm && |{
               mem_rdata_q[14:12] == 3'b000,
               mem_rdata_q[14:12] == 3'b010,
               mem_rdata_q[14:12] == 3'b011,
               mem_rdata_q[14:12] == 3'b100,
               mem_rdata_q[14:12] == 3'b110,
               mem_rdata_q[14:12] == 3'b111
            };

        is_sll_srl_sra <= is_alu_reg_reg && |{
               mem_rdata_q[14:12] == 3'b001 && mem_rdata_q[31:25] == 7'b0000000,
               mem_rdata_q[14:12] == 3'b101 && mem_rdata_q[31:25] == 7'b0000000,
               mem_rdata_q[14:12] == 3'b101 && mem_rdata_q[31:25] == 7'b0100000
            };

        is_lui_auipc_jal_jalr_addi_add_sub <= 0;
        is_compare <= 0;

        //[JI] (* parallel_case *)
        unique0 case (1'b1)
          instr_jal: decoded_imm <= decoded_imm_uj;

          |{instr_lui, instr_auipc} : decoded_imm <= mem_rdata_q[31:12] << 12;

          |{instr_jalr, is_lb_lh_lw_lbu_lhu, is_alu_reg_imm} :
          decoded_imm <= $signed(mem_rdata_q[31:20]);

          is_beq_bne_blt_bge_bltu_bgeu:
          decoded_imm <= $signed(
              {mem_rdata_q[31], mem_rdata_q[7], mem_rdata_q[30:25], mem_rdata_q[11:8], 1'b0}
          );

          is_sb_sh_sw: decoded_imm <= $signed({mem_rdata_q[31:25], mem_rdata_q[11:7]});

        endcase
      end

    end
  end

  //=============================================================
  // ALU
  //=============================================================
  typedef enum logic [2:0] {
    TRAP_HOLD    = 3'd0,
    FETCH_WR_REG = 3'd1,
    RD_REG       = 3'd2,
    RD_REG2      = 3'd3,
    EXEC         = 3'd4,
    SHIFT        = 3'd5,
    WR_MEM       = 3'd6,
    RD_MEM       = 3'd7
  } cpu_state_t;

  cpu_state_t                     cpu_state;

  logic       [              1:0] irq_state;

  logic                           latched_store;
  logic                           latched_stalu;
  logic                           latched_branch;
  logic                           latched_compr;
  logic                           latched_trace;
  logic                           latched_is_lu;
  logic                           latched_is_lh;
  logic                           latched_is_lb;
  logic       [REGINDEX_BITS-1:0] latched_rdst;

  assign next_pc = (latched_store & latched_branch) ? reg_out[31:1] : reg_next_pc[31:1];
`ifdef CPU_DEBUG
  logic next_pc_0;
  assign next_pc_0 = !(latched_store & latched_branch) & reg_next_pc[0];
`endif

  logic [3:0] pcpi_timeout_counter;
  logic       pcpi_timeout;

  logic       do_waitirq;

  logic [31:0] alu_out, alu_out_q;
  logic alu_out_0, alu_out_0_q;
  logic alu_wait, alu_wait_2;

  // Whether the upcoming ALU operation needs an extra wait cycle: either
  // the ALU itself is always two-cycle, or this specific instruction is a
  // two-cycle-compare-eligible branch. Computed once here and reused at
  // both RD_REG2 case sites (default branches of the is_sb_sh_sw/
  // is_sll_srl_sra-vs-default unique case, and the plain default case a few
  // states later) instead of repeating this formula verbatim in two places.
  logic alu_wait_needed;
  assign alu_wait_needed = TWO_CYCLE_ALU || (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu);

  logic alu_wait_2_needed;
  assign alu_wait_2_needed = TWO_CYCLE_ALU && (TWO_CYCLE_COMPARE && is_beq_bne_blt_bge_bltu_bgeu);

  // Whether each maskable trap-IRQ is currently allowed to be raised.
  // Computed once and reused at every trap-raising site in the FSM below,
  // instead of repeating `ENABLE_IRQ && !irq_mask[IRQ_x] && !irq_active`
  // verbatim at each one (3 sites each for EBREAK and BUSERROR).
  logic ebreak_irq_allowed;
  assign ebreak_irq_allowed = ENABLE_IRQ && !irq_mask[IRQ_EBREAK] && !irq_active;

  logic buserror_irq_allowed;
  assign buserror_irq_allowed = ENABLE_IRQ && !irq_mask[IRQ_BUSERROR] && !irq_active;

  // NOTE: the alu_out_0 case below uses is_slti_blt_slt / is_sltiu_bltu_sltu
  // without picorv32.ORIG.sv's TWO_CYCLE_COMPARE guard: they are exclusive
  // with instr_beq/bne/bge/bgeu by construction (see their assignment).

  logic [31:0] alu_add_sub;
  logic [31:0] alu_shl, alu_shr;
  logic alu_eq, alu_ltu, alu_lts;

  //----------------------------------
  generate
    if (TWO_CYCLE_ALU) begin : g_2cycle_alu
      always_ff @(posedge clk) begin
        alu_add_sub <= instr_sub ? (reg_op1 - reg_op2) : (reg_op1 + reg_op2);
        alu_eq <= reg_op1 == reg_op2;
        alu_lts <= $signed(reg_op1) < $signed(reg_op2);
        alu_ltu <= reg_op1 < reg_op2;
        alu_shl <= reg_op1 << reg_op2[4:0];
        alu_shr <= 32'($signed(
            {instr_sra || instr_srai ? reg_op1[31] : 1'b0, reg_op1}
        ) >>> reg_op2[4:0]);  //[JI]
      end
    end  //----------------------------------
    else begin : g_1cycle_alu
      always_comb begin
        alu_add_sub = instr_sub ? reg_op1 - reg_op2 : reg_op1 + reg_op2;
        alu_eq = reg_op1 == reg_op2;
        alu_lts = $signed(reg_op1) < $signed(reg_op2);
        alu_ltu = reg_op1 < reg_op2;
        alu_shl = reg_op1 << reg_op2[4:0];
        alu_shr = 32'($signed({instr_sra || instr_srai ? reg_op1[31] : 1'b0, reg_op1}) >>>
                      reg_op2[4:0]);  //[JI]
      end
    end
  endgenerate

  //----------------------------------
  always_comb begin
    alu_out_0 = 'X;

    //[JI] (* parallel_case, full_case *)
    unique0 case (1'b1)
      instr_beq:          alu_out_0 = alu_eq;
      instr_bne:          alu_out_0 = !alu_eq;
      instr_bge:          alu_out_0 = !alu_lts;
      instr_bgeu:         alu_out_0 = !alu_ltu;
      is_slti_blt_slt:    alu_out_0 = alu_lts;
      is_sltiu_bltu_sltu: alu_out_0 = alu_ltu;
    endcase

    alu_out = 'bx;

    //[JI] (* parallel_case, full_case *)
    unique0 case (1'b1)
      is_lui_auipc_jal_jalr_addi_add_sub: alu_out = alu_add_sub;

      is_compare: alu_out = alu_out_0;

      (instr_xori | instr_xor): alu_out = reg_op1 ^ reg_op2;

      (instr_ori | instr_or): alu_out = reg_op1 | reg_op2;

      (instr_andi | instr_and): alu_out = reg_op1 & reg_op2;

      (BARREL_SHIFTER & (instr_sll | instr_slli)): alu_out = alu_shl;

      (BARREL_SHIFTER & (instr_srl | instr_srli | instr_sra | instr_srai)): alu_out = alu_shr;
    endcase

`ifdef RISCV_FORMAL_BLACKBOX_ALU
    alu_out_0 = $anyseq;
    alu_out   = $anyseq;
`endif
  end  // always @ *


  logic clear_prefetched_high_word_q;
  always_ff @(posedge clk) begin
    clear_prefetched_high_word_q <= clear_prefetched_high_word;
  end

  always_comb begin
    clear_prefetched_high_word = clear_prefetched_high_word_q;

    if (!prefetched_high_word) begin
      clear_prefetched_high_word = '0;
    end
    if (latched_branch || (irq_state != '0)  /*JI irq_state*/ || !resetn) begin
      clear_prefetched_high_word = COMPRESSED_ISA;
    end
  end

  logic cpuregs_write, cpuregs_we;
  logic [             31:0] cpuregs_wrdata;
  logic [             31:0] cpuregs_rsrc1;
  logic [             31:0] cpuregs_rsrc2;
  logic [REGINDEX_BITS-1:0] decoded_rsrc;

  logic [31:0] wdat_branch, wdat_store, wdat_irq_pc, wdat_irq;

  always_comb begin
    wdat_branch    = reg_pc + (latched_compr ? 32'd2 : 32'd4);
    wdat_store     = latched_stalu ? alu_out_q : reg_out;
    wdat_irq_pc    = reg_next_pc | {31'd0, latched_compr};
    wdat_irq       = irq_pending_masked;

    cpuregs_write  = 1'b0;
    cpuregs_wrdata = 'X;

    if (cpu_state == FETCH_WR_REG) begin
      //[JI] (* parallel_case *)
      unique0 case (1'b1)

        latched_branch: begin
          cpuregs_wrdata = wdat_branch;
          cpuregs_write  = 1'b1;
        end

        ~latched_branch & latched_store: begin
          cpuregs_wrdata = wdat_store;
          cpuregs_write  = 1'b1;
        end

        ENABLE_IRQ & irq_state[0]: begin
          cpuregs_wrdata = wdat_irq_pc;
          cpuregs_write  = 1'b1;
        end

        ENABLE_IRQ & irq_state[1]: begin
          cpuregs_wrdata = wdat_irq;
          cpuregs_write  = 1'b1;
        end

      endcase  // unique0 case (1'b1)
    end

    //X0 is not writeable
    cpuregs_we = resetn & cpuregs_write & (latched_rdst != 0);
  end


`ifdef PICORV32_REGS
  //---------------------------------
  logic [31:0] cpuregs_rdata1;
  logic [31:0] cpuregs_rdata2;

  logic [ 5:0] cpuregs_raddr1;
  assign cpuregs_raddr1 = ENABLE_REGS_DUALPORT ? decoded_rsrc1 : decoded_rsrc;
  logic [5:0] cpuregs_raddr2;
  assign cpuregs_raddr2 = ENABLE_REGS_DUALPORT ? decoded_rsrc2 : '0;

  `PICORV32_REGS cpuregs (
      .clk(clk),

      .wen  (cpuregs_we),
      .waddr(latched_rdst),
      .wdata(cpuregs_wrdata),

      .raddr1(cpuregs_raddr1),
      .rdata1(cpuregs_rdata1),

      .raddr2(cpuregs_raddr2),
      .rdata2(cpuregs_rdata2)
  );

  always_comb begin
    decoded_rsrc = 'X;

    if (ENABLE_REGS_DUALPORT) begin
      //X0 must return 0
      cpuregs_rsrc1 = (decoded_rsrc1 != '0) ? cpuregs_rdata1 : '0;
      cpuregs_rsrc2 = (decoded_rsrc2 != '0) ? cpuregs_rdata2 : '0;
    end
    else begin
      decoded_rsrc  = (cpu_state == RD_REG2) ? decoded_rsrc2 : decoded_rsrc1;
      cpuregs_rsrc1 = (decoded_rsrc != '0) ? cpuregs_rdata1 : '0;
      cpuregs_rsrc2 = cpuregs_rsrc1;
    end
  end


`else
  //---------------------------------
  always_ff @(posedge clk) begin
    if (cpuregs_we == 1'b1) begin
      cpuregs[latched_rdst] <= cpuregs_wrdata;
    end
  end

  always_comb begin
    decoded_rsrc = 'X;

    //--dual-port register file
    if (ENABLE_REGS_DUALPORT) begin

`ifndef RISCV_FORMAL_BLACKBOX_REGS
      //X0 must return 0: ASIC by this read mux, FPGA by the RAM init above
      cpuregs_rsrc1 = (TARGET_IS_ASIC && decoded_rsrc1 == '0) ? '0 : cpuregs[decoded_rsrc1];
      cpuregs_rsrc2 = (TARGET_IS_ASIC && decoded_rsrc2 == '0) ? '0 : cpuregs[decoded_rsrc2];
`else
      cpuregs_rsrc1 = (decoded_rsrc1 != '0) ? $anyseq : '0;
      cpuregs_rsrc2 = (decoded_rsrc2 != '0) ? $anyseq : '0;
`endif
    end  //--single-port register file
    else begin
      decoded_rsrc = (cpu_state == RD_REG2) ? decoded_rsrc2 : decoded_rsrc1;

`ifndef RISCV_FORMAL_BLACKBOX_REGS
      cpuregs_rsrc1 = (TARGET_IS_ASIC && decoded_rsrc == '0) ? '0 : cpuregs[decoded_rsrc];
`else
      cpuregs_rsrc1 = (decoded_rsrc != '0) ? $anyseq : '0;
`endif
      cpuregs_rsrc2 = cpuregs_rsrc1;
    end  // else: !if(ENABLE_REGS_DUALPORT)
  end  // always @ *
`endif  // !`ifdef PICORV32_REGS

  //---------------------------------
`ifdef CPU_DEBUGFSM
  always_ff @(posedge clk) begin
    if (cpuregs_we == 1'b1) begin
      $display("%14s| X%-2d<= %08x", cpu_state.name, latched_rdst, cpuregs_wrdata);
    end
  end
`endif

  //---------------------------------
`ifdef CPU_DEBUG
  logic launch_next_insn;
  assign launch_next_insn = (cpu_state == FETCH_WR_REG)
            && decoder_trigger
            && (!ENABLE_IRQ || irq_delay || irq_active || !any_irq_pending_masked);

  `FORMAL_KEEP
  logic [31:0] dbg_rsrc1val;
  `FORMAL_KEEP
  logic [31:0] dbg_rsrc2val;
  `FORMAL_KEEP
  logic dbg_rsrc1val_valid;
  `FORMAL_KEEP
  logic dbg_rsrc2val_valid;
`endif

  // Same-cycle values the main FSM below uses: which memory access to start
  // (set_mem_do_*), the next irq_pending, and the PC of the next fetch
  // (current_pc, only used in FETCH_WR_REG). The conditions mirror the FSM.
  logic        set_mem_do_rinst;
  logic        set_mem_do_rdata;
  logic        set_mem_do_wdata;
  logic [31:0] next_irq_pending;
  logic [31:0] current_pc;

  always_comb begin
    set_mem_do_rinst = 1'b0;
    set_mem_do_rdata = 1'b0;
    set_mem_do_wdata = 1'b0;
    current_pc       = 'X;
    next_irq_pending = ENABLE_IRQ ? irq_pending & LATCHED_IRQ : 'X;

    if (ENABLE_IRQ && ENABLE_IRQ_TIMER && (irq_timer != '0)) begin
      if (irq_timer - 1 == '0) begin
        next_irq_pending[IRQ_TIMER] = 1'b1;
      end
    end

    if (ENABLE_IRQ) begin
      next_irq_pending = next_irq_pending | irq;
    end

    unique0 case (cpu_state)
      FETCH_WR_REG: begin
        current_pc = reg_next_pc;

        unique0 case (1'b1)
          latched_branch & latched_store: begin
            current_pc = wdat_store & 32'hFFFF_FFFE;
          end
          ENABLE_IRQ & irq_state[0]: begin
            current_pc = PROGADDR_IRQ;
          end
          ENABLE_IRQ & irq_state[1]: begin
            next_irq_pending = next_irq_pending & irq_mask;
          end
        endcase
      end

      RD_REG: begin
        if ((CATCH_ILLINSN || WITH_PCPI) && instr_trap) begin
          if (WITH_PCPI) begin
            if (ENABLE_REGS_DUALPORT && !pcpi_int_ready && CATCH_ILLINSN &&
                (pcpi_timeout || instr_ecall_ebreak) && ebreak_irq_allowed) begin
              next_irq_pending[IRQ_EBREAK] = 1'b1;
            end
          end
          else if (ebreak_irq_allowed) begin
            next_irq_pending[IRQ_EBREAK] = 1'b1;
          end
        end
      end

      RD_REG2: begin
        if (WITH_PCPI && instr_trap && !pcpi_int_ready && CATCH_ILLINSN &&
            (pcpi_timeout || instr_ecall_ebreak) && ebreak_irq_allowed) begin
          next_irq_pending[IRQ_EBREAK] = 1'b1;
        end
      end

      EXEC: begin
        if (!((TWO_CYCLE_ALU || TWO_CYCLE_COMPARE) && (alu_wait || alu_wait_2)) &&
            is_beq_bne_blt_bge_bltu_bgeu && (TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0)) begin
          set_mem_do_rinst = 1'b1;
        end
      end

      WR_MEM: begin
        if ((!mem_do_prefetch || mem_done) && !mem_do_wdata) begin
          set_mem_do_wdata = 1'b1;
        end
      end

      RD_MEM: begin
        if ((!mem_do_prefetch || mem_done) && !mem_do_rdata) begin
          set_mem_do_rdata = 1'b1;
        end
      end
    endcase

    // bus errors: misaligned data or instruction
    if (CATCH_MISALIGN && (mem_do_rdata || mem_do_wdata) && buserror_irq_allowed) begin
      if ((mem_wordsize == 2'd0) && (reg_op1[1:0] != '0)) begin
        next_irq_pending[IRQ_BUSERROR] = 1'b1;
      end
      if ((mem_wordsize == 2'd1) & (reg_op1[0] != '0)) begin
        next_irq_pending[IRQ_BUSERROR] = 1'b1;
      end
    end
    if (CATCH_MISALIGN && mem_do_rinst && (COMPRESSED_ISA ? reg_pc[0] : |reg_pc[1:0]) &&
        buserror_irq_allowed) begin
      next_irq_pending[IRQ_BUSERROR] = 1'b1;
    end
  end

  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      trap                     <= '0;
      reg_sh                   <= '0;
      reg_out                  <= STACKADDR;
      alu_out_0_q              <= '0;
      alu_out_q                <= '0;
      alu_wait                 <= '0;
      alu_wait_2               <= '0;
      pcpi_timeout_counter     <= '0;
      pcpi_timeout             <= '0;
      count_cycle              <= '0;
      count_instr              <= '0;
      irq_timer                <= '0;
      decoder_trigger          <= '0;
      decoder_trigger_q        <= '0;
      decoder_pseudo_trigger   <= '0;
      decoder_pseudo_trigger_q <= '0;
      do_waitirq               <= '0;
      trace_valid              <= '0;
      trace_data               <= '0;
      reg_pc                   <= PROGADDR_RESET;
      reg_next_pc              <= PROGADDR_RESET;
      latched_stalu            <= '0;
      latched_branch           <= '0;
      latched_trace            <= '0;
      latched_is_lu            <= '0;
      latched_is_lh            <= '0;
      latched_is_lb            <= '0;
      latched_store            <= 1'b1;
      latched_rdst             <= 2'd2;
      pcpi_valid               <= '0;
      irq_active               <= '0;
      irq_delay                <= '0;
      irq_mask                 <= '1;
      irq_state                <= '0;
      eoi                      <= '0;
      cpu_state                <= FETCH_WR_REG;
      mem_do_rinst             <= '0;
      mem_wordsize             <= '0;
      latched_compr            <= '0;
      mem_do_prefetch          <= '0;
      reg_op1                  <= '0;
      reg_op2                  <= '0;
      mem_do_rdata             <= '0;
      mem_do_wdata             <= '0;
      irq_pending              <= '0;
`ifdef CPU_DEBUGFSM
      dbgfsm_clk_cnt[0] <= '0;
      dbgfsm_clk_cnt[1] <= '0;
      dbgfsm_insn_cnt   <= 1;
`endif
`ifdef CPU_DEBUG
      dbg_rsrc1val       <= '0;
      dbg_rsrc2val       <= '0;
      dbg_rsrc1val_valid <= '0;
      dbg_rsrc2val_valid <= '0;
`endif
    end
    else begin
      trap        <= '0;
      reg_sh      <= 'X;
      reg_out     <= 'X;

      alu_out_0_q <= alu_out_0;
      alu_out_q   <= alu_out;

      alu_wait    <= '0;
      alu_wait_2  <= '0;

`ifdef CPU_DEBUG
      if (launch_next_insn) begin
        dbg_rsrc1val       <= 'X;
        dbg_rsrc2val       <= 'X;
        dbg_rsrc1val_valid <= '0;
        dbg_rsrc2val_valid <= '0;
      end
`endif

`ifdef CPU_DEBUGFSM
      dbgfsm_clk_cnt[0] <= dbgfsm_clk_cnt[0] + 1;
`endif

      if (WITH_PCPI && CATCH_ILLINSN) begin
        if (pcpi_valid && !pcpi_int_wait) begin
          if (pcpi_timeout_counter != '0) begin
            pcpi_timeout_counter <= pcpi_timeout_counter - 1;
          end
        end
        else begin
          pcpi_timeout_counter <= ~0;
        end

        pcpi_timeout <= !pcpi_timeout_counter;
      end

      if (ENABLE_COUNTERS) begin
        count_cycle <= count_cycle + 1;
        if (!ENABLE_COUNTERS64) begin
          count_cycle[63:32] <= 0;
        end
      end
      else begin
        count_cycle <= 'X;
        count_instr <= 'X;
      end

      if (ENABLE_IRQ && ENABLE_IRQ_TIMER && (irq_timer != '0)) begin
        irq_timer <= irq_timer - 1;
      end

      decoder_trigger          <= mem_do_rinst & mem_done;
      decoder_trigger_q        <= decoder_trigger;
      decoder_pseudo_trigger   <= '0;
      decoder_pseudo_trigger_q <= decoder_pseudo_trigger;
      do_waitirq               <= '0;

      trace_valid              <= '0;

      if (!ENABLE_TRACE) begin
        trace_data <= 'X;
      end


      //=============================================================
      // Main FSM
      //=============================================================
      //[JI] (* parallel_case, full_case *)
      unique0 case (cpu_state)
        //=================TRAP_HOLD
        TRAP_HOLD: begin
          trap <= 1'b1;
          //freeze until reset
        end

        //=================FETCH_WR_REG
        FETCH_WR_REG: begin
          mem_do_rinst <= ~decoder_trigger & ~do_waitirq;
          mem_wordsize <= 2'd0;

          //[JI] (* parallel_case *)
          unique0 case (1'b1)

            //--------------FETCH_WR_REG:Case1
            latched_branch & latched_store: begin
            end

            //--------------FETCH_WR_REG:Case2
            ENABLE_IRQ & irq_state[0]: begin
              irq_active   <= 1'b1;
              mem_do_rinst <= 1'b1;
            end

            //--------------FETCH_WR_REG:Case3
            ENABLE_IRQ & irq_state[1]: begin
              eoi <= wdat_irq;
            end

            //--------------FETCH_WR_REG:Default
          endcase

          //--------------FETCH_WR_REG:Trace
          if (ENABLE_TRACE && latched_trace) begin
            latched_trace <= 0;
            trace_valid   <= 1;

            if (latched_branch) begin
              trace_data <= (irq_active ? TRACE_IRQ : 36'd0)
                                 | TRACE_BRANCH
                                 | (current_pc & 32'hffff_fffe);
            end
            else begin
              trace_data <= (irq_active ? TRACE_IRQ : 36'd0)
                                 | (latched_stalu ? alu_out_q : reg_out);
            end
          end

          //--------------FETCH_WR_REG:Misc
          reg_pc         <= current_pc;
          reg_next_pc    <= current_pc;

          latched_store  <= '0;
          latched_stalu  <= '0;
          latched_branch <= '0;
          latched_is_lu  <= '0;
          latched_is_lh  <= '0;
          latched_is_lb  <= '0;
          latched_rdst   <= decoded_rdst;
          latched_compr  <= compressed_instr;

          //--------------FETCH_WR_REG:Interrupt
          if (   ENABLE_IRQ
                    & (  (decoder_trigger & ~irq_active & ~irq_delay & any_irq_pending_masked)
                        | (irq_state != '0) /* [JI] irq_state*/ )
                  ) begin

            irq_state     <= (irq_state == 2'b00) ? 2'b01 : (irq_state == 2'b01) ? 2'b10 : 2'b00;
            latched_compr <= latched_compr;

            if (ENABLE_IRQ_QREGS) begin
              latched_rdst <= IRQREGS_OFFSET | irq_state[0];
            end
            else begin
              latched_rdst <= irq_state[0] ? 4 : 3;
            end
          end
          else if (ENABLE_IRQ && (decoder_trigger || do_waitirq) && instr_waitirq) begin
            if (irq_pending != '0) begin
              latched_store <= 1'b1;
              reg_out       <= irq_pending;
              reg_next_pc   <= current_pc + (compressed_instr ? 2 : 4);
              mem_do_rinst  <= 1'b1;
            end
            else begin
              do_waitirq <= 1'b1;
            end
          end
          else if (decoder_trigger == 1'b1) begin
`ifdef CPU_DEBUGFSM
            $display("\n--- %0t Clk#%0d (+%0d, CPI=%1.2f) --- INSN#%0d @[%08x]", $time,
                     dbgfsm_clk_cnt[0], dbgfsm_clk_cnt[0] - dbgfsm_clk_cnt[1],
                     real'(dbgfsm_clk_cnt[0]) / real'(dbgfsm_insn_cnt), dbgfsm_insn_cnt,
                     current_pc[31:2]);

            dbgfsm_clk_cnt[1] <= dbgfsm_clk_cnt[0];
            dbgfsm_insn_cnt   <= dbgfsm_insn_cnt + 1;
`endif

            irq_delay   <= irq_active;
            reg_next_pc <= current_pc + (compressed_instr ? 2 : 4);

            if (ENABLE_TRACE) begin
              latched_trace <= 1;
            end

            if (ENABLE_COUNTERS) begin
              count_instr <= count_instr + 1;
              if (!ENABLE_COUNTERS64) begin
                count_instr[63:32] <= 0;
              end
            end

            if (instr_jal) begin
              mem_do_rinst   <= 1'b1;
              reg_next_pc    <= current_pc + decoded_imm_uj;
              latched_branch <= 1'b1;
            end
            else begin
              mem_do_rinst    <= 1'b0;
              mem_do_prefetch <= ~instr_jalr & ~instr_retirq;
              cpu_state       <= RD_REG;
            end
          end  // if (decoder_trigger == 1'b1)

`ifdef CPU_DEBUGFSM
          if (latched_branch == 1'b1) begin
            $display("BRANCH to [%08x]", current_pc);
          end
`endif

        end  // case: FETCH_WR_REG


        //=================RD_REG:
        RD_REG: begin
          reg_op1 <= 'X;
          reg_op2 <= 'X;

          //[JI](* parallel_case *)
          unique0 case (1'b1)

            //--------------RD_REG:Case1
            (CATCH_ILLINSN || WITH_PCPI) && instr_trap: begin
              if (WITH_PCPI) begin
                `CPU_DBGFSM($display("%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1,
                                     cpuregs_rsrc1);)

                reg_op1 <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
                dbg_rsrc1val       <= cpuregs_rsrc1;
                dbg_rsrc1val_valid <= 1;
`endif

                if (ENABLE_REGS_DUALPORT) begin
                  `CPU_DBGFSM($display("%14s| X%-2d=> %08x(port2)", cpu_state.name, decoded_rsrc2,
                                       cpuregs_rsrc2);)

                  pcpi_valid <= 1;
                  reg_sh     <= cpuregs_rsrc2;
                  reg_op2    <= cpuregs_rsrc2;

`ifdef CPU_DEBUG
                  dbg_rsrc2val       <= cpuregs_rsrc2;
                  dbg_rsrc2val_valid <= 1;
`endif

                  if (pcpi_int_ready) begin
                    mem_do_rinst  <= 1;
                    pcpi_valid    <= 0;
                    reg_out       <= pcpi_int_rdst;
                    latched_store <= pcpi_int_wr;
                    cpu_state     <= FETCH_WR_REG;
                  end
                  else if (CATCH_ILLINSN && (pcpi_timeout || instr_ecall_ebreak)) begin
                    `CPU_DBGFSM($display("%14s| EBREAK OR UNSUPPORTED INSN @[%08x]",
                                         cpu_state.name, reg_pc);)
                    pcpi_valid <= '0;

                    if (ebreak_irq_allowed) begin
                      cpu_state <= FETCH_WR_REG;
                    end
                    else begin
                      cpu_state <= TRAP_HOLD;
                    end
                  end
                end
                else begin
                  cpu_state <= RD_REG2;
                end
              end
              else begin
                `CPU_DBGFSM($display(
                            "%14s| EBREAK OR UNSUPPORTED INSN @[%08x]", cpu_state.name, reg_pc);)

                if (ebreak_irq_allowed) begin
                  cpu_state <= FETCH_WR_REG;
                end
                else begin
                  cpu_state <= TRAP_HOLD;
                end
              end
            end  // RD_REG:case1: (CATCH_ILLINSN || WITH_PCPI) && instr_trap

            //--------------RD_REG:Case2
            ENABLE_COUNTERS & is_rdcycle_rdcycleh_rdinstr_rdinstrh: begin
              //[JI] (* parallel_case, full_case *)
              unique0 case (1'b1)
                instr_rdcycle: reg_out <= count_cycle[31:0];

                instr_rdcycleh && ENABLE_COUNTERS64: reg_out <= count_cycle[63:32];

                instr_rdinstr: reg_out <= count_instr[31:0];

                instr_rdinstrh && ENABLE_COUNTERS64: reg_out <= count_instr[63:32];

              endcase

              latched_store <= 1;
              cpu_state     <= FETCH_WR_REG;
            end  // RD_REG:case2: ENABLE_COUNTERS & is_rdcycle_rdcycleh_rdinstr_rdinstrh

            //--------------RD_REG:Case3
            is_lui_auipc_jal: begin
              reg_op1 <= instr_lui ? 0 : reg_pc;
              reg_op2 <= decoded_imm;

              if (TWO_CYCLE_ALU) begin
                alu_wait <= 1;
              end
              else begin
                mem_do_rinst <= mem_do_prefetch;
              end

              cpu_state <= EXEC;
            end  // RD_REG:case3: is_lui_auipc_jal

            //--------------RD_REG:Case4
            ENABLE_IRQ && ENABLE_IRQ_QREGS && instr_getq: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_out <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              latched_store <= 1;
              cpu_state     <= FETCH_WR_REG;
            end  // RD_REG:case4: ENABLE_IRQ && ENABLE_IRQ_QREGS && instr_getq

            //--------------RD_REG:Case5
            ENABLE_IRQ && ENABLE_IRQ_QREGS && instr_setq: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_out <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              latched_rdst  <= latched_rdst | REGINDEX_BITS'(IRQREGS_OFFSET);
              latched_store <= 1;
              cpu_state     <= FETCH_WR_REG;
            end  // RD_REG:case5: ENABLE_IRQ && ENABLE_IRQ_QREGS && instr_setq

            //--------------RD_REG:Case6
            ENABLE_IRQ && instr_retirq: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_out <= CATCH_MISALIGN ? (cpuregs_rsrc1 & 32'hFFFF_FFFE) : cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              eoi            <= 0;
              irq_active     <= 0;
              latched_branch <= 1;
              latched_store  <= 1;

              cpu_state      <= FETCH_WR_REG;
            end  // RD_REG:case6: ENABLE_IRQ && instr_retirq

            //--------------RD_REG:Case7
            ENABLE_IRQ && instr_maskirq: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              latched_store <= 1;
              reg_out       <= irq_mask;
              irq_mask      <= cpuregs_rsrc1 | MASKED_IRQ;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              cpu_state <= FETCH_WR_REG;
            end  // RD_REG:case7: ENABLE_IRQ && instr_maskirq

            //--------------RD_REG:Case8
            ENABLE_IRQ && ENABLE_IRQ_TIMER && instr_timer: begin
              `CPU_DBGFSM($display(
                          "%14s| X#%0d=>%08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              latched_store <= 1;
              reg_out       <= irq_timer;
              irq_timer     <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              cpu_state <= FETCH_WR_REG;
            end

            is_lb_lh_lw_lbu_lhu && !instr_trap: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_op1 <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              cpu_state    <= RD_MEM;
              mem_do_rinst <= 1;
            end  // RD_REG:case8: is_lb_lh_lw_lbu_lhu && !instr_trap

            //--------------RD_REG:Case9
            is_slli_srli_srai && !BARREL_SHIFTER: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_op1 <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              reg_sh    <= decoded_rsrc2;
              cpu_state <= SHIFT;
            end  // RD_REG:case9: is_slli_srli_srai && !BARREL_SHIFTER

            //--------------RD_REG:Case10
            is_jalr_addi_slti_sltiu_xori_ori_andi, is_slli_srli_srai && BARREL_SHIFTER: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_op1 <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              reg_op2 <= is_slli_srli_srai && BARREL_SHIFTER ? decoded_rsrc2 : decoded_imm;

              if (TWO_CYCLE_ALU) begin
                alu_wait <= 1;
              end
              else begin
                mem_do_rinst <= mem_do_prefetch;
              end

              cpu_state <= EXEC;
              // RD_REG:case10: is_jalr_addi_slti_sltiu_xori_ori_andi,
              //                is_slli_srli_srai && BARREL_SHIFTER
            end

            //--------------RD_REG:Case11
            default: begin
              `CPU_DBGFSM($display(
                          "%14s| X%-2d=> %08x(port1)", cpu_state.name, decoded_rsrc1, cpuregs_rsrc1
                          );)

              reg_op1 <= cpuregs_rsrc1;

`ifdef CPU_DEBUG
              dbg_rsrc1val       <= cpuregs_rsrc1;
              dbg_rsrc1val_valid <= 1;
`endif

              if (ENABLE_REGS_DUALPORT) begin
                `CPU_DBGFSM($display("%14s| X%-2d=> %08x(port2)", cpu_state.name, decoded_rsrc2,
                                     cpuregs_rsrc2);)

                reg_sh  <=  /*[JI] cpuregs_rsrc2*/ cpuregs_rsrc2[4:0];
                reg_op2 <= cpuregs_rsrc2;

`ifdef CPU_DEBUG
                dbg_rsrc2val       <= cpuregs_rsrc2;
                dbg_rsrc2val_valid <= 1;
`endif

                //[JI] (* parallel_case *)
                unique0 case (1'b1)
                  is_sb_sh_sw: begin
                    cpu_state    <= WR_MEM;
                    mem_do_rinst <= 1;
                  end
                  is_sll_srl_sra && !BARREL_SHIFTER: begin
                    cpu_state <= SHIFT;
                  end
                  default: begin
                    if (alu_wait_needed) begin
                      alu_wait_2 <= alu_wait_2_needed;
                      alu_wait   <= 1;
                    end
                    else begin
                      mem_do_rinst <= mem_do_prefetch;
                    end
                    cpu_state <= EXEC;
                  end
                endcase  // unique0 case (1'b1)

              end
              else begin
                cpu_state <= RD_REG2;
              end
            end  // RD_REG:case11: Default

          endcase  // unique0 case (1'b1)
        end  // case: RD_REG


        //=================RD_REG2:
        RD_REG2: begin
          `CPU_DBGFSM($display(
                      "%14s| X%-2d=> %08x(port2)", cpu_state.name, decoded_rsrc2, cpuregs_rsrc2);)

          reg_sh  <=  /*[JI] cpuregs_rsrc2*/ cpuregs_rsrc2[4:0];
          reg_op2 <= cpuregs_rsrc2;

`ifdef CPU_DEBUG
          dbg_rsrc2val       <= cpuregs_rsrc2;
          dbg_rsrc2val_valid <= 1;
`endif

          //[JI] (* parallel_case *)
          unique0 case (1'b1)

            //--------------RD_REG2:Case1
            WITH_PCPI && instr_trap: begin
              pcpi_valid <= 1;

              if (pcpi_int_ready) begin
                mem_do_rinst  <= 1;
                pcpi_valid    <= 0;
                reg_out       <= pcpi_int_rdst;
                latched_store <= pcpi_int_wr;
                cpu_state     <= FETCH_WR_REG;
              end
              else if (CATCH_ILLINSN && (pcpi_timeout || instr_ecall_ebreak)) begin
                `CPU_DBGFSM($display("%14s| EBREAK OR UNSUPPORTED INSN @[%08x]", cpu_state.name,
                                     reg_pc);)

                pcpi_valid <= 0;

                if (ebreak_irq_allowed) begin
                  cpu_state <= FETCH_WR_REG;
                end
                else begin
                  cpu_state <= TRAP_HOLD;
                end
              end
            end  // case: WITH_PCPI && instr_trap

            //--------------RD_REG2:Case2
            is_sb_sh_sw: begin
              cpu_state    <= WR_MEM;
              mem_do_rinst <= 1;
            end

            //--------------RD_REG2:Case3
            is_sll_srl_sra && !BARREL_SHIFTER: begin
              cpu_state <= SHIFT;
            end

            //--------------RD_REG2:Case4
            default: begin
              if (alu_wait_needed) begin
                alu_wait_2 <= alu_wait_2_needed;
                alu_wait   <= 1;
              end
              else begin
                mem_do_rinst <= mem_do_prefetch;
              end

              cpu_state <= EXEC;
            end
          endcase
        end  // case: RD_REG2


        //=================EXEC
        EXEC: begin
          reg_out <= reg_pc + decoded_imm;

          if ((TWO_CYCLE_ALU || TWO_CYCLE_COMPARE) && (alu_wait || alu_wait_2)) begin
            mem_do_rinst <= mem_do_prefetch && !alu_wait_2;
            alu_wait     <= alu_wait_2;
          end
          else if (is_beq_bne_blt_bge_bltu_bgeu) begin
            latched_rdst   <= '0;
            latched_store  <= TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0;
            latched_branch <= TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0;

            if (mem_done) begin
              cpu_state <= FETCH_WR_REG;
            end

            if (TWO_CYCLE_COMPARE ? alu_out_0_q : alu_out_0) begin
              decoder_trigger <= 1'b0;
            end
          end
          else begin
            latched_branch <= instr_jalr;
            latched_store  <= 1'b1;
            latched_stalu  <= 1'b1;
            cpu_state      <= FETCH_WR_REG;
          end
        end  // case: EXEC


        //=================SHIFT
        SHIFT: begin
          latched_store <= 1'b1;

          if (reg_sh == 0) begin
            reg_out      <= reg_op1;
            mem_do_rinst <= mem_do_prefetch;
            cpu_state    <= FETCH_WR_REG;
          end
          else if (TWO_STAGE_SHIFT && reg_sh >= 4) begin
            //[JI] (* parallel_case, full_case *)
            unique0 case (1'b1)
              instr_slli || instr_sll: reg_op1 <= reg_op1 << 4;
              instr_srli || instr_srl: reg_op1 <= reg_op1 >> 4;
              instr_srai || instr_sra: reg_op1 <= $signed(reg_op1) >>> 4;
            endcase
            reg_sh <= 5'(reg_sh - 4);  //[JI]
          end
          else begin
            //[JI] (* parallel_case, full_case *)
            unique0 case (1'b1)
              instr_slli || instr_sll: reg_op1 <= reg_op1 << 1;
              instr_srli || instr_srl: reg_op1 <= reg_op1 >> 1;
              instr_srai || instr_sra: reg_op1 <= $signed(reg_op1) >>> 1;
            endcase
            reg_sh <= 5'(reg_sh - 1);  //[JI]
          end
        end  // case: SHIFT


        //=================WR_MEM
        WR_MEM: begin
          if (ENABLE_TRACE) begin
            reg_out <= reg_op2;
          end

          if (!mem_do_prefetch || mem_done) begin
            if (!mem_do_wdata) begin

              //[JI] (* parallel_case, full_case *)
              unique0 case (1'b1)
                instr_sb: mem_wordsize <= 2'd2;
                instr_sh: mem_wordsize <= 2'd1;
                instr_sw: mem_wordsize <= 2'd0;
              endcase

              if (ENABLE_TRACE) begin
                trace_valid <= 1'b1;
                trace_data  <= (irq_active ? TRACE_IRQ : 36'd0)
                                     | TRACE_ADDR
                                     | ((reg_op1 + decoded_imm) & 32'hffff_ffff);
              end
              reg_op1 <= reg_op1 + decoded_imm;
            end

            if (!mem_do_prefetch && mem_done) begin
              cpu_state              <= FETCH_WR_REG;
              decoder_trigger        <= 1;
              decoder_pseudo_trigger <= 1;
            end
          end
        end  // case: WR_MEM


        //=================RD_MEM
        RD_MEM: begin
          latched_store <= 1;

          if (!mem_do_prefetch || mem_done) begin
            if (!mem_do_rdata) begin

              //[JI]  (* parallel_case, full_case *)
              unique0 case (1'b1)
                instr_lb | instr_lbu: mem_wordsize <= 2'd2;
                instr_lh | instr_lhu: mem_wordsize <= 2'd1;
                instr_lw:             mem_wordsize <= 2'd0;
              endcase

              latched_is_lu <= is_lbu_lhu_lw;
              latched_is_lh <= instr_lh;
              latched_is_lb <= instr_lb;

              if (ENABLE_TRACE) begin
                trace_valid <= 1;
                trace_data  <= (irq_active ? TRACE_IRQ : 36'd0)
                                     | TRACE_ADDR
                                     | ((reg_op1 + decoded_imm) & 32'hffff_ffff);
              end
              reg_op1 <= reg_op1 + decoded_imm;
            end

            if (!mem_do_prefetch && mem_done) begin
              //[JI] (* parallel_case, full_case *)
              unique0 case (1'b1)
                //latched_is_lu: reg_out <= mem_rdata_word;
                //latched_is_lh: reg_out <= {{16{mem_rdata_word[15]}}, //[JI] sign extension
                //                               mem_rdata_word[15:0]};
                //
                //latched_is_lb: reg_out <= {{24{mem_rdata_word[7]}}, //[JI] sign extension
                //                               mem_rdata_word[7:0]};
                latched_is_lu: reg_out <= mem_rdata_word;
                latched_is_lh: reg_out <= $signed(mem_rdata_word[15:0]);
                latched_is_lb: reg_out <= $signed(mem_rdata_word[7:0]);

              endcase

              decoder_trigger        <= 1;
              decoder_pseudo_trigger <= 1;
              cpu_state              <= FETCH_WR_REG;
            end
          end
        end  // case: RD_MEM

        //=================dummy DEFAULT

      endcase  // unique0 case (cpu_state)


      //=============================================================
      // Error checking / Traps
      //=============================================================

      //------MISALIGNED DATA
      if (CATCH_MISALIGN && (mem_do_rdata || mem_do_wdata)) begin
        if ((mem_wordsize == 2'd0) && (reg_op1[1:0] != '0)) begin
          `CPU_DBGFSM($display("%14s| MISALIGNED DATA WORD %08x", cpu_state.name, reg_op1);)

          if (!buserror_irq_allowed) begin
            cpu_state <= TRAP_HOLD;
          end
        end

        if ((mem_wordsize == 2'd1) & (reg_op1[0] != '0)) begin
          `CPU_DBGFSM($display("%14s| MISALIGNED DATA HALFWORD %08x", cpu_state.name, reg_op1);)

          if (!buserror_irq_allowed) begin
            cpu_state <= TRAP_HOLD;
          end
        end
      end

      //------MISALIGNED INSTRUCTION
      if (CATCH_MISALIGN && mem_do_rinst && (COMPRESSED_ISA ? reg_pc[0] : |reg_pc[1:0])) begin
        `CPU_DBGFSM($display("%14s| MISALIGNED INSTRUCTION @[%08x]", cpu_state.name, reg_pc);)

        if (!buserror_irq_allowed) begin
          cpu_state <= TRAP_HOLD;
        end
      end

      //------ILLEGAL INSTRUCTION
      if (!CATCH_ILLINSN && decoder_trigger_q && !decoder_pseudo_trigger_q &&
          instr_ecall_ebreak) begin
        `CPU_DBGFSM($display("%14s| ILLEGAL INSTRUCTION @[%08x]", cpu_state.name, reg_pc);)

        cpu_state <= TRAP_HOLD;
      end

      //------Misc
      if (mem_done) begin
        mem_do_prefetch <= 1'b0;
        mem_do_rinst    <= 1'b0;
        mem_do_rdata    <= 1'b0;
        mem_do_wdata    <= 1'b0;
      end

      if (set_mem_do_rinst) begin
        mem_do_rinst <= 1'b1;
      end
      if (set_mem_do_rdata) begin
        mem_do_rdata <= 1'b1;
      end
      if (set_mem_do_wdata) begin
        mem_do_wdata <= 1'b1;
      end

      irq_pending <= next_irq_pending & ~MASKED_IRQ;

      if (!CATCH_MISALIGN) begin
        if (COMPRESSED_ISA) begin
          reg_pc[0]      <= '0;
          reg_next_pc[0] <= '0;
        end
        else begin
          reg_pc[1:0]      <= '0;
          reg_next_pc[1:0] <= '0;
        end
      end
    end
  end  // always_ff @ (posedge clk)


  //##############################################################
  // Verification-only section
  //##############################################################

  //--------------------------------------------------------------
  // DEBUG
  //--------------------------------------------------------------
`ifdef CPU_DEBUG

  typedef enum {
    ILLEGAL,

    LUI,
    AUIPC,
    JAL,
    JALR,

    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU,

    LB,
    LH,
    LW,
    LBU,
    LHU,
    SB,
    SH,
    SW,

    ADDI,
    SLTI,
    SLTIU,
    XORI,
    ORI,
    ANDI,
    SLLI,
    SRLI,
    SRAI,
    ADD,
    SUB,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    SRA,
    OR,
    AND,

    RDCYCLE,
    RDCYCLEH,
    RDINSTR,
    RDINSTRH,

    GETQ,
    SETQ,
    RETIRQ,
    MASKIRQ,
    WAITIRQ,
    TIMER
  } cpu_insn_t;

  logic [31:0] q_insn_imm;
  logic [31:0] q_insn_opcode;
  logic [ 4:0] q_insn_rsrc1;
  logic [ 4:0] q_insn_rsrc2;
  logic [ 4:0] q_insn_rdst;

  logic [31:0] cached_insn_imm;
  logic [31:0] cached_insn_opcode;
  logic [ 4:0] cached_insn_rsrc1;
  logic [ 4:0] cached_insn_rsrc2;
  logic [ 4:0] cached_insn_rdst;

  `FORMAL_KEEP
  logic [31:0] dbg_insn_imm;
  logic [31:0] dbg_insn_opcode;
  `FORMAL_KEEP
  logic [4:0] dbg_insn_rsrc1;
  `FORMAL_KEEP
  logic [4:0] dbg_insn_rsrc2;
  `FORMAL_KEEP
  logic      [ 4:0] dbg_insn_rdst;

  logic             dbg_next;
  logic             dbg_valid_insn;
  logic      [31:0] dbg_insn_addr;

  cpu_insn_t        new_ascii_insn;
  cpu_insn_t        cached_ascii_insn;
  cpu_insn_t        q_ascii_insn;
  `FORMAL_KEEP
  cpu_insn_t dbg_ascii_insn;


  // map decoded instruction to mnemonics
  always_comb begin
    new_ascii_insn = ILLEGAL;

    if (instr_lui) begin
      new_ascii_insn = LUI;
    end
    if (instr_auipc) begin
      new_ascii_insn = AUIPC;
    end
    if (instr_jal) begin
      new_ascii_insn = JAL;
    end
    if (instr_jalr) begin
      new_ascii_insn = JALR;
    end

    if (instr_beq) begin
      new_ascii_insn = BEQ;
    end
    if (instr_bne) begin
      new_ascii_insn = BNE;
    end
    if (instr_blt) begin
      new_ascii_insn = BLT;
    end
    if (instr_bge) begin
      new_ascii_insn = BGE;
    end
    if (instr_bltu) begin
      new_ascii_insn = BLTU;
    end
    if (instr_bgeu) begin
      new_ascii_insn = BGEU;
    end

    if (instr_lb) begin
      new_ascii_insn = LB;
    end
    if (instr_lh) begin
      new_ascii_insn = LH;
    end
    if (instr_lw) begin
      new_ascii_insn = LW;
    end
    if (instr_lbu) begin
      new_ascii_insn = LBU;
    end
    if (instr_lhu) begin
      new_ascii_insn = LHU;
    end
    if (instr_sb) begin
      new_ascii_insn = SB;
    end
    if (instr_sh) begin
      new_ascii_insn = SH;
    end
    if (instr_sw) begin
      new_ascii_insn = SW;
    end

    if (instr_addi) begin
      new_ascii_insn = ADDI;
    end
    if (instr_slti) begin
      new_ascii_insn = SLTI;
    end
    if (instr_sltiu) begin
      new_ascii_insn = SLTIU;
    end
    if (instr_xori) begin
      new_ascii_insn = XORI;
    end
    if (instr_ori) begin
      new_ascii_insn = ORI;
    end
    if (instr_andi) begin
      new_ascii_insn = ANDI;
    end
    if (instr_slli) begin
      new_ascii_insn = SLLI;
    end
    if (instr_srli) begin
      new_ascii_insn = SRLI;
    end
    if (instr_srai) begin
      new_ascii_insn = SRAI;
    end

    if (instr_add) begin
      new_ascii_insn = ADD;
    end
    if (instr_sub) begin
      new_ascii_insn = SUB;
    end
    if (instr_sll) begin
      new_ascii_insn = SLL;
    end
    if (instr_slt) begin
      new_ascii_insn = SLT;
    end
    if (instr_sltu) begin
      new_ascii_insn = SLTU;
    end
    if (instr_xor) begin
      new_ascii_insn = XOR;
    end
    if (instr_srl) begin
      new_ascii_insn = SRL;
    end
    if (instr_sra) begin
      new_ascii_insn = SRA;
    end
    if (instr_or) begin
      new_ascii_insn = OR;
    end
    if (instr_and) begin
      new_ascii_insn = AND;
    end

    if (instr_rdcycle) begin
      new_ascii_insn = RDCYCLE;
    end
    if (instr_rdcycleh) begin
      new_ascii_insn = RDCYCLEH;
    end
    if (instr_rdinstr) begin
      new_ascii_insn = RDINSTR;
    end
    if (instr_rdinstrh) begin
      new_ascii_insn = RDINSTRH;
    end

    if (instr_getq) begin
      new_ascii_insn = GETQ;
    end
    if (instr_setq) begin
      new_ascii_insn = SETQ;
    end
    if (instr_retirq) begin
      new_ascii_insn = RETIRQ;
    end
    if (instr_maskirq) begin
      new_ascii_insn = MASKIRQ;
    end
    if (instr_waitirq) begin
      new_ascii_insn = WAITIRQ;
    end
    if (instr_timer) begin
      new_ascii_insn = TIMER;
    end
  end

  always_ff @(posedge clk) begin
    q_ascii_insn  <= dbg_ascii_insn;

    q_insn_imm    <= dbg_insn_imm;
    q_insn_opcode <= dbg_insn_opcode;
    q_insn_rsrc1  <= dbg_insn_rsrc1;
    q_insn_rsrc2  <= dbg_insn_rsrc2;
    q_insn_rdst   <= dbg_insn_rdst;

    dbg_next      <= launch_next_insn;

    if (!resetn || trap) begin
      dbg_valid_insn <= 1'b0;
    end
    else if (launch_next_insn) begin
      dbg_valid_insn <= 1'b1;
    end

    if (decoder_trigger_q) begin
      cached_ascii_insn <= new_ascii_insn;
      cached_insn_imm   <= decoded_imm;

      if (&next_insn_opcode[1:0]) begin
        cached_insn_opcode <= next_insn_opcode;
      end
      else begin
        cached_insn_opcode <= {16'b0, next_insn_opcode[15:0]};
      end

      cached_insn_rsrc1 <= decoded_rsrc1;
      cached_insn_rsrc2 <= decoded_rsrc2;
      cached_insn_rdst  <= decoded_rdst;
    end

    if (launch_next_insn) begin
      dbg_insn_addr <= {next_pc, next_pc_0};
    end
  end

  always_comb begin
    dbg_ascii_insn  = q_ascii_insn;
    dbg_insn_imm    = q_insn_imm;
    dbg_insn_opcode = q_insn_opcode;
    dbg_insn_rsrc1  = q_insn_rsrc1;
    dbg_insn_rsrc2  = q_insn_rsrc2;
    dbg_insn_rdst   = q_insn_rdst;

    if (dbg_next) begin
      if (decoder_pseudo_trigger_q) begin
        dbg_ascii_insn  = cached_ascii_insn;
        dbg_insn_imm    = cached_insn_imm;
        dbg_insn_opcode = cached_insn_opcode;
        dbg_insn_rsrc1  = cached_insn_rsrc1;
        dbg_insn_rsrc2  = cached_insn_rsrc2;
        dbg_insn_rdst   = cached_insn_rdst;
      end
      else begin
        dbg_ascii_insn = new_ascii_insn;

        if (&next_insn_opcode[1:0]) begin
          dbg_insn_opcode = next_insn_opcode;
        end
        else begin
          dbg_insn_opcode = {16'b0, next_insn_opcode[15:0]};
        end

        dbg_insn_imm   = decoded_imm;
        dbg_insn_rsrc1 = decoded_rsrc1;
        dbg_insn_rsrc2 = decoded_rsrc2;
        dbg_insn_rdst  = decoded_rdst;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (dbg_next) begin

      if (&dbg_insn_opcode[1:0]) begin
        $display("[%08x] %08x %-0s", dbg_insn_addr, dbg_insn_opcode, dbg_ascii_insn.name);
      end
      else begin
        $display("[%08x] %04x %-0s", dbg_insn_addr, dbg_insn_opcode[15:0], dbg_ascii_insn.name);
      end

    end  // if (dbg_next)
  end  // always_ff @ (posedge clk)

`endif  // CPU_DEBUG


  //--------------------------------------------------------------
  // TRACE
  //--------------------------------------------------------------
`ifdef CPU_DEBUGTRACE
  int trace_file;

  initial begin
    trace_file = $fopen("testbench.trace", "w");
  end

  always_ff @(posedge clk) begin
    if (resetn == 1'b1) begin
      if ({mem_valid, mem_ready} == 2'b11) begin
        if (mem_instr == 1'b1) begin
          $fwrite(trace_file, "InsnRD [$%08X] $%08X", mem_addr, mem_rdata);
        end
        else begin
          $fwrite(trace_file, "DataRD [$%08X] $%08X", mem_addr, mem_rdata);
        end
      end

      if (trace_valid == 1'b1) begin
        $fwrite(trace_file, "%x\n", trace_data);
        $fflush(trace_file);
      end
    end
  end
`endif  // CPU_DEBUGTRACE


  //--------------------------------------------------------------
  // RISCV_FORMAL
  //--------------------------------------------------------------
`ifdef RISCV_FORMAL
  logic        dbg_irq_call;
  logic        dbg_irq_enter;
  logic [31:0] dbg_irq_ret;

  always_ff @(posedge clk) begin
    rvfi_valid     <= resetn && (launch_next_insn || trap) && dbg_valid_insn;
    rvfi_order     <= resetn ? rvfi_order + rvfi_valid : '0;

    rvfi_insn      <= dbg_insn_opcode;
    rvfi_rs1_addr  <= dbg_rsrc1val_valid ? dbg_insn_rsrc1 : '0;
    rvfi_rs2_addr  <= dbg_rsrc2val_valid ? dbg_insn_rsrc2 : '0;
    rvfi_pc_rdata  <= dbg_insn_addr;
    rvfi_rs1_rdata <= dbg_rsrc1val_valid ? dbg_rsrc1val : '0;
    rvfi_rs2_rdata <= dbg_rsrc2val_valid ? dbg_rsrc2val : '0;
    rvfi_trap      <= trap;
    rvfi_halt      <= trap;
    rvfi_intr      <= dbg_irq_enter;

    if (!resetn) begin
      dbg_irq_call  <= '0;
      dbg_irq_enter <= '0;
    end
    else if (rvfi_valid) begin
      dbg_irq_call  <= '0;
      dbg_irq_enter <= dbg_irq_call;
    end
    else if (irq_state == 2'd1) begin
      dbg_irq_call <= 1'b1;
      dbg_irq_ret  <= {next_pc, next_pc_0};
    end

    if (!resetn) begin
      rvfi_rd_addr  <= '0;
      rvfi_rd_wdata <= '0;
    end
    else if (cpuregs_write && (irq_state == '0)  /*[JI] !irq_state*/) begin
      rvfi_rd_addr  <= latched_rdst;
      rvfi_rd_wdata <= latched_rdst ? cpuregs_wrdata : '0;
    end
    else if (rvfi_valid) begin
      rvfi_rd_addr  <= '0;
      rvfi_rd_wdata <= '0;
    end

    unique0 casez (dbg_insn_opcode)
      32'b0000000_?????_000??_???_?????_0001011: begin  // getq
        rvfi_rs1_addr  <= '0;
        rvfi_rs1_rdata <= '0;
      end
      32'b0000001_?????_?????_???_000??_0001011: begin  // setq
        rvfi_rd_addr  <= '0;
        rvfi_rd_wdata <= '0;
      end
      32'b0000010_?????_00000_???_00000_0001011: begin  // retirq
        rvfi_rs1_addr  <= 0;
        rvfi_rs1_rdata <= 0;
      end
    endcase

    if (!dbg_irq_call) begin
      if (mem_instr) begin
        rvfi_mem_addr  <= '0;
        rvfi_mem_rmask <= '0;
        rvfi_mem_wmask <= '0;
        rvfi_mem_rdata <= '0;
        rvfi_mem_wdata <= '0;
      end
      else if ({mem_valid, mem_ready} == 2'b11) begin
        rvfi_mem_addr  <= mem_addr;
        rvfi_mem_rmask <= mem_wstrb ? '0 : '1;
        rvfi_mem_wmask <= mem_wstrb;
        rvfi_mem_rdata <= mem_rdata;
        rvfi_mem_wdata <= mem_wdata;
      end
    end
  end

  always_comb begin
    rvfi_pc_wdata = dbg_irq_call ? dbg_irq_ret : dbg_insn_addr;
  end
`endif  // RISCV_FORMAL


  //--------------------------------------------------
  // CPU_FORMAL
  //--------------------------------------------------------------
`ifdef CPU_FORMAL
  logic [3:0] last_mem_nowait;

  always_ff @(posedge clk) begin
    last_mem_nowait <= {last_mem_nowait, mem_ready || !mem_valid};
  end

  // stall the memory interface for max 4 cycles
  restrict property (|last_mem_nowait || mem_ready || !mem_valid);

  // resetn low in first cycle, after that resetn high
  restrict property (resetn != $initstate);

  // this just makes it much easier to read traces. uncomment as needed.
  // assume property (mem_valid || !mem_ready);

  logic ok;

  always_comb begin
    if (resetn) begin
      // instruction fetches are read-only
      if (mem_valid && mem_instr) begin
        assert (mem_wstrb == 0);
      end

      // cpu_state must be valid
      ok = 0;
      if (cpu_state == TRAP_HOLD) begin
        ok = 1'b1;
      end
      if (cpu_state == FETCH_WR_REG) begin
        ok = 1'b1;
      end
      if (cpu_state == RD_REG) begin
        ok = 1'b1;
      end
      if (cpu_state == RD_REG2) begin
        ok = ~ENABLE_REGS_DUALPORT;
      end
      if (cpu_state == EXEC) begin
        ok = 1'b1;
      end
      if (cpu_state == SHIFT) begin
        ok = 1'b1;
      end
      if (cpu_state == WR_MEM) begin
        ok = 1'b1;
      end
      if (cpu_state == RD_MEM) begin
        ok = 1'b1;
      end
      assert (ok);
    end
  end

  logic        last_mem_la_read = '0;
  logic        last_mem_la_write = '0;
  logic [31:0] last_mem_la_addr;
  logic [31:0] last_mem_la_wdata;
  logic [ 3:0] last_mem_la_wstrb = '0;

  always_ff @(posedge clk) begin
    last_mem_la_read  <= mem_la_read;
    last_mem_la_write <= mem_la_write;
    last_mem_la_addr  <= mem_la_addr;
    last_mem_la_wdata <= mem_la_wdata;
    last_mem_la_wstrb <= mem_la_wstrb;

    if (last_mem_la_read) begin
      assert (mem_valid);
      assert (mem_addr == last_mem_la_addr);
      assert (mem_wstrb == 0);
    end
    if (last_mem_la_write) begin
      assert (mem_valid);
      assert (mem_addr == last_mem_la_addr);
      assert (mem_wdata == last_mem_la_wdata);
      assert (mem_wstrb == last_mem_la_wstrb);
    end
    if (mem_la_read || mem_la_write) begin
      assert (!mem_valid || mem_ready);
    end
  end
`endif  // CPU_FORMAL

endmodule : picorv32

// verilator lint_on WIDTH
// verilator lint_on CASEINCOMPLETE

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/1/4  JI: initial creation
 2024/2/25 JI: finalized debug messaging

*/
