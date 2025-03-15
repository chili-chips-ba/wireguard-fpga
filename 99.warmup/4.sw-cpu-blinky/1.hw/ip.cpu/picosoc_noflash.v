/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  This is a modified PicoSoC example which has removed the requirement
 *  for an external SPI flash. The PicoRV32 program is stored in ROM implemented
 *  as a number of case statements. The ROM file is generated using an external
 *  script.
 *
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
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

`ifndef PICORV32_REGS
`ifdef PICORV32_V
//`error "picosoc.v must be read before picorv32.v!"
`endif

`define PICORV32_REGS picosoc_regs
`endif

module picosoc_noflash (
	input clk,
	input resetn,

	output        iomem_valid,
	input         iomem_ready,
	output [ 3:0] iomem_wstrb,
	output [31:0] iomem_addr,
	output [31:0] iomem_wdata,
	input  [31:0] iomem_rdata,
	
	// Rewrite firmware 
    input		  progmem_wen,
	input  [31:0] progmem_waddr,
	input  [31:0] progmem_wdata,
	
	input  irq_5,
	input  irq_6,
	input  irq_7,

	output ser_tx,
	input  ser_rx
);
	parameter integer MEM_WORDS = 8192;
	parameter [31:0] STACKADDR = (4*MEM_WORDS);       // end of memory
	parameter [31:0] PROGADDR_RESET = 32'h 0010_0000; // 1 MB into flash

	reg [31:0] irq;
	wire irq_stall = 0;
	wire irq_uart = 0;

	always @* begin
		irq = 0;
		irq[3] = irq_stall;
		irq[4] = irq_uart;
		irq[5] = irq_5;
		irq[6] = irq_6;
		irq[7] = irq_7;
	end

	wire mem_valid;
	wire mem_instr;
	wire mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	wire [31:0] mem_rdata;

	wire progmem_ready;
	wire [31:0] progmem_rdata;

	reg ram_ready;
	wire [31:0] ram_rdata;

	assign iomem_valid = mem_valid && (mem_addr[31:24] > 8'h 01);
	assign iomem_wstrb = mem_wstrb;
	assign iomem_addr = mem_addr;
	assign iomem_wdata = mem_wdata;

	wire        spimemio_cfgreg_sel    = mem_valid && (mem_addr == 32'h 0200_0000);

	wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 0200_0004);
	wire [31:0] simpleuart_reg_div_do;

	wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 0200_0008);
	wire [31:0] simpleuart_reg_dat_do;
	wire        simpleuart_reg_dat_wait;

	assign mem_ready = 
            (iomem_valid && iomem_ready) || progmem_ready || ram_ready || spimemio_cfgreg_sel ||
			simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);

	assign mem_rdata = 
            (iomem_valid && iomem_ready) ? iomem_rdata :
            progmem_ready ? progmem_rdata :
            ram_ready ? ram_rdata :
            spimemio_cfgreg_sel ? 32'h0000_0000 : // Mockup, will always read 0
			simpleuart_reg_div_sel ? simpleuart_reg_div_do :
			simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : 32'h 0000_0000;

`ifdef SIMULATION    
	wire        trace_valid;
	wire [35:0] trace_data;
    integer     trace_file;
`endif

	picorv32 #(
		.STACKADDR(STACKADDR),
		.PROGADDR_RESET(PROGADDR_RESET),
		.PROGADDR_IRQ(32'h 0000_0000),
		.BARREL_SHIFTER(1),
		.COMPRESSED_ISA(1),
		.ENABLE_MUL(1),
		.ENABLE_DIV(1),
		.ENABLE_IRQ(1),
`ifdef SIMULATION    
		.ENABLE_IRQ_QREGS(0),
        .ENABLE_TRACE(1)
`else
		.ENABLE_IRQ_QREGS(0)
`endif
	) cpu (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
`ifdef SIMULATION
		.irq         (irq        ),
		.trace_valid (trace_valid),
		.trace_data  (trace_data )
`else
		.irq         (irq        )
`endif
	);

    // This it the program ROM memory for the PicoRV32
    progmem progmem (
        .clk    (clk),
        .rstn   (resetn),

        .valid  (mem_valid && mem_addr >= 4*MEM_WORDS && mem_addr < 32'h 0200_0000),
        .ready  (progmem_ready),
        .addr   (mem_addr),
        .rdata  (progmem_rdata),
		.wen	(progmem_wen),
		.waddr	(progmem_waddr),
		.wdata	(progmem_wdata)
    );

	simpleuart simpleuart (
		.clk         (clk         ),
		.resetn      (resetn      ),

		.ser_tx      (ser_tx      ),
		.ser_rx      (ser_rx      ),

		.reg_div_we  (simpleuart_reg_div_sel ? mem_wstrb : 4'b 0000),
		.reg_div_di  (mem_wdata),
		.reg_div_do  (simpleuart_reg_div_do),

		.reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0),
		.reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
		.reg_dat_di  (mem_wdata),
		.reg_dat_do  (simpleuart_reg_dat_do),
		.reg_dat_wait(simpleuart_reg_dat_wait)
	);

	always @(posedge clk)
		ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;

	picosoc_mem #(.WORDS(MEM_WORDS)) memory (
		.clk(clk),
		.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
		.addr(mem_addr[23:2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
	);

    // Simulation debug
`ifdef SIMULATION
    always @(posedge clk)
        if (resetn) begin
            if ( mem_instr && mem_valid && mem_ready)
                $display("Inst rd: [0x%08X] = 0x%08X", mem_addr, mem_rdata);
            if (!mem_instr && mem_valid && mem_ready)
                $display("Data rd: [0x%08X] = 0x%08X", mem_addr, mem_rdata);
        end

    // Trace
    initial begin

        trace_file = $fopen("testbench.trace", "w");
        repeat (10) @(posedge clk);

        while(1) begin
            @(posedge clk)
            if (resetn && trace_valid)
                $fwrite(trace_file, "%x\n", trace_data);
                $fflush(trace_file);
                //$display("Trace  : %09X", trace_data);
        end
    end

`endif // SIMULATION

endmodule

// Implementation note:
// Replace the following two modules with wrappers for your SRAM cells.

module picosoc_regs (
	input clk, wen,
	input [5:0] waddr,
	input [5:0] raddr1,
	input [5:0] raddr2,
	input [31:0] wdata,
	output [31:0] rdata1,
	output [31:0] rdata2
);
	(* ram_style = "distributed" *) reg [31:0] regs [0:31];

	always @(posedge clk)
		if (wen) regs[waddr[4:0]] <= wdata;

	assign rdata1 = regs[raddr1[4:0]];
	assign rdata2 = regs[raddr2[4:0]];
endmodule

module picosoc_mem #(
	parameter integer WORDS = 32
) (
	input clk,
	input [3:0] wen,
	input [21:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata
);
	(* ram_style = "block" *) reg [31:0] mem [0:WORDS-1];

	//initial $readmemh("firmware.hex", mem);
	always @(posedge clk) begin
		rdata <= mem[addr];
		if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
		if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
		if (wen[2]) mem[addr][23:16] <= wdata[23:16];
		if (wen[3]) mem[addr][31:24] <= wdata[31:24];
	end
endmodule
