//--------------------------------------------------------------------------
// Improved by Chili.CHIPS (2023/24)
//--------------------------------------------------------------------------

/***************************************************************
 * picorv32_wb
 ***************************************************************/

module picorv32_wb #(
   parameter [ 0:0] ENABLE_COUNTERS = 1,
   parameter [ 0:0] ENABLE_COUNTERS64 = 1,
   parameter [ 0:0] ENABLE_REGS_16_31 = 1,
   parameter [ 0:0] ENABLE_REGS_DUALPORT = 1,
   parameter [ 0:0] TWO_STAGE_SHIFT = 1,
   parameter [ 0:0] BARREL_SHIFTER = 0,
   parameter [ 0:0] TWO_CYCLE_COMPARE = 0,
   parameter [ 0:0] TWO_CYCLE_ALU = 0,
   parameter [ 0:0] COMPRESSED_ISA = 0,
   parameter [ 0:0] CATCH_MISALIGN = 1,
   parameter [ 0:0] CATCH_ILLINSN = 1,
   parameter [ 0:0] ENABLE_PCPI = 0,
   parameter [ 0:0] ENABLE_MUL = 0,
   parameter [ 0:0] ENABLE_FAST_MUL = 0,
   parameter [ 0:0] ENABLE_DIV = 0,
   parameter [ 0:0] ENABLE_IRQ = 0,
   parameter [ 0:0] ENABLE_IRQ_QREGS = 1,
   parameter [ 0:0] ENABLE_IRQ_TIMER = 1,
   parameter [ 0:0] ENABLE_TRACE = 0,
   parameter [ 0:0] REGS_INIT_ZERO = 0,
   parameter [31:0] MASKED_IRQ = 32'h 0000_0000,
   parameter [31:0] LATCHED_IRQ = 32'h ffff_ffff,
   parameter [31:0] PROGADDR_RESET = 32'h 0000_0000,
   parameter [31:0] PROGADDR_IRQ = 32'h 0000_0010,
   parameter [31:0] STACKADDR = 32'h ffff_ffff
) (
   output trap,

   // Wishbone interfaces
   input wb_rst_i,
   input wb_clk_i,

   output reg [31:0] wbm_adr_o,
   output reg [31:0] wbm_dat_o,
   input      [31:0] wbm_dat_i,
   output reg        wbm_we_o,
   output reg [3:0]  wbm_sel_o,
   output reg        wbm_stb_o,
   input             wbm_ack_i,
   output reg        wbm_cyc_o,

   // Pico Co-Processor Interface (PCPI)
   output        pcpi_valid,
   output [31:0] pcpi_insn,
   output [31:0] pcpi_rs1,
   output [31:0] pcpi_rs2,
   input         pcpi_wr,
   input  [31:0] pcpi_rd,
   input         pcpi_wait,
   input         pcpi_ready,

   // IRQ interface
   input  [31:0] irq,
   output [31:0] eoi,

`ifdef RISCV_FORMAL
   output        rvfi_valid,
   output [63:0] rvfi_order,
   output [31:0] rvfi_insn,
   output        rvfi_trap,
   output        rvfi_halt,
   output        rvfi_intr,
   output [ 4:0] rvfi_rs1_addr,
   output [ 4:0] rvfi_rs2_addr,
   output [31:0] rvfi_rs1_rdata,
   output [31:0] rvfi_rs2_rdata,
   output [ 4:0] rvfi_rd_addr,
   output [31:0] rvfi_rd_wdata,
   output [31:0] rvfi_pc_rdata,
   output [31:0] rvfi_pc_wdata,
   output [31:0] rvfi_mem_addr,
   output [ 3:0] rvfi_mem_rmask,
   output [ 3:0] rvfi_mem_wmask,
   output [31:0] rvfi_mem_rdata,
   output [31:0] rvfi_mem_wdata,
`endif

   // Trace Interface
   output        trace_valid,
   output [35:0] trace_data,

   output mem_instr
);
   wire        mem_valid;
   wire [31:0] mem_addr;
   wire [31:0] mem_wdata;
   wire [ 3:0] mem_wstrb;
   reg         mem_ready;
   reg [31:0] mem_rdata;

   wire clk;
   wire resetn;

   assign clk = wb_clk_i;
   assign resetn = ~wb_rst_i;

   picorv32 #(
      .ENABLE_COUNTERS     (ENABLE_COUNTERS     ),
      .ENABLE_COUNTERS64   (ENABLE_COUNTERS64   ),
      .ENABLE_REGS_16_31   (ENABLE_REGS_16_31   ),
      .ENABLE_REGS_DUALPORT(ENABLE_REGS_DUALPORT),
      .TWO_STAGE_SHIFT     (TWO_STAGE_SHIFT     ),
      .BARREL_SHIFTER      (BARREL_SHIFTER      ),
      .TWO_CYCLE_COMPARE   (TWO_CYCLE_COMPARE   ),
      .TWO_CYCLE_ALU       (TWO_CYCLE_ALU       ),
      .COMPRESSED_ISA      (COMPRESSED_ISA      ),
      .CATCH_MISALIGN      (CATCH_MISALIGN      ),
      .CATCH_ILLINSN       (CATCH_ILLINSN       ),
      .ENABLE_PCPI         (ENABLE_PCPI         ),
      .ENABLE_MUL          (ENABLE_MUL          ),
      .ENABLE_FAST_MUL     (ENABLE_FAST_MUL     ),
      .ENABLE_DIV          (ENABLE_DIV          ),
      .ENABLE_IRQ          (ENABLE_IRQ          ),
      .ENABLE_IRQ_QREGS    (ENABLE_IRQ_QREGS    ),
      .ENABLE_IRQ_TIMER    (ENABLE_IRQ_TIMER    ),
      .ENABLE_TRACE        (ENABLE_TRACE        ),
      .REGS_INIT_ZERO      (REGS_INIT_ZERO      ),
      .MASKED_IRQ          (MASKED_IRQ          ),
      .LATCHED_IRQ         (LATCHED_IRQ         ),
      .PROGADDR_RESET      (PROGADDR_RESET      ),
      .PROGADDR_IRQ        (PROGADDR_IRQ        ),
      .STACKADDR           (STACKADDR           )
   )
   picorv32_core (
      .clk      (clk   ),
      .resetn   (resetn),
      .trap     (trap  ),

      .mem_valid(mem_valid),
      .mem_addr (mem_addr ),
      .mem_wdata(mem_wdata),
      .mem_wstrb(mem_wstrb),
      .mem_instr(mem_instr),
      .mem_ready(mem_ready),
      .mem_rdata(mem_rdata),

      .pcpi_valid(pcpi_valid),
      .pcpi_insn (pcpi_insn ),
      .pcpi_rs1  (pcpi_rs1  ),
      .pcpi_rs2  (pcpi_rs2  ),
      .pcpi_wr   (pcpi_wr   ),
      .pcpi_rd   (pcpi_rd   ),
      .pcpi_wait (pcpi_wait ),
      .pcpi_ready(pcpi_ready),

      .irq(irq),
      .eoi(eoi),

   // Look-Ahead Interface (Not-Used)
      .mem_la_read   (), //o
      .mem_la_write  (), //o
      .mem_la_addr   (), //o[31:0]
      .mem_la_wdata  (), //o[31:0]
      .mem_la_wstrb  (), //o[3:0]

`ifdef RISCV_FORMAL
      .rvfi_valid    (rvfi_valid    ),
      .rvfi_order    (rvfi_order    ),
      .rvfi_insn     (rvfi_insn     ),
      .rvfi_trap     (rvfi_trap     ),
      .rvfi_halt     (rvfi_halt     ),
      .rvfi_intr     (rvfi_intr     ),
      .rvfi_rs1_addr (rvfi_rs1_addr ),
      .rvfi_rs2_addr (rvfi_rs2_addr ),
      .rvfi_rs1_rdata(rvfi_rs1_rdata),
      .rvfi_rs2_rdata(rvfi_rs2_rdata),
      .rvfi_rd_addr  (rvfi_rd_addr  ),
      .rvfi_rd_wdata (rvfi_rd_wdata ),
      .rvfi_pc_rdata (rvfi_pc_rdata ),
      .rvfi_pc_wdata (rvfi_pc_wdata ),
      .rvfi_mem_addr (rvfi_mem_addr ),
      .rvfi_mem_rmask(rvfi_mem_rmask),
      .rvfi_mem_wmask(rvfi_mem_wmask),
      .rvfi_mem_rdata(rvfi_mem_rdata),
      .rvfi_mem_wdata(rvfi_mem_wdata),
`endif

      .trace_valid(trace_valid),
      .trace_data (trace_data)
   );

   localparam IDLE = 2'b00;
   localparam WBSTART = 2'b01;
   localparam WBEND = 2'b10;

   reg [1:0] state;

   wire we;
   assign we = (mem_wstrb[0] | mem_wstrb[1] | mem_wstrb[2] | mem_wstrb[3]);

   always_ff @(posedge wb_clk_i) begin
      if (wb_rst_i) begin
         wbm_adr_o <= 0;
         wbm_dat_o <= 0;
         wbm_we_o <= 0;
         wbm_sel_o <= 0;
         wbm_stb_o <= 0;
         wbm_cyc_o <= 0;
         state <= IDLE;
      end else begin
         unique case (state)
            IDLE: begin
               if (mem_valid) begin
                  wbm_adr_o <= mem_addr;
                  wbm_dat_o <= mem_wdata;
                  wbm_we_o <= we;
                  wbm_sel_o <= mem_wstrb;

                  wbm_stb_o <= 1'b1;
                  wbm_cyc_o <= 1'b1;
                  state <= WBSTART;
               end else begin
                  mem_ready <= 1'b0;

                  wbm_stb_o <= 1'b0;
                  wbm_cyc_o <= 1'b0;
                  wbm_we_o <= 1'b0;
               end
            end // case: IDLE

            WBSTART:begin
               if (wbm_ack_i) begin
                  mem_rdata <= wbm_dat_i;
                  mem_ready <= 1'b1;

                  state <= WBEND;

                  wbm_stb_o <= 1'b0;
                  wbm_cyc_o <= 1'b0;
                  wbm_we_o <= 1'b0;
               end
            end // case: WBSTART

            WBEND: begin
               mem_ready <= 1'b0;

               state <= IDLE;
            end

            default:
               state <= IDLE;
         endcase
      end
   end
endmodule: picorv32_wb
