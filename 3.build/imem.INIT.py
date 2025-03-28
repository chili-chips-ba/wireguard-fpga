#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#-------------------------------------------------------------
# Script that generates Verilog IMEM contents file for the
# compiled RISC-V 'C' program
#=============================================================

import os
import sys
import struct

inp_file = 'sw_build/main.bin'

out_dir  = './'
out_file = os.path.join(out_dir, 'imem.INIT.vh')

imem_text = ''

try:
   with open(inp_file, 'rb') as bin_file:
        bin_contents = bin_file.read()
except Exception as e:
    print(f"Open bin file Exception: {e}")
    sys.exit(-1)

print(f"Bin file size: {len(bin_contents)} bytes")


hex_values = []
while len(bin_contents) != 0:
    hex_values.append(struct.unpack("<I", bin_contents[0:4])[0])
    bin_contents = bin_contents[4:]

addr = 0

# NEW ----------------------------------------------------------
try:
    with open(out_file, 'w') as imem_SW_file:

        for value in hex_values:
            imem_text += f"mem[\'h{addr:04X}] = 32\'h{value:08X};\n"
            addr += 1

        imem_SW_file.write(imem_text)

# OLD ----------------------------------------------------------
##  try:
##      with open('progmem.v', 'w') as prog_mem_file:
##
##          for value in hex_values:
##              progmem_text += f"    mem[\'h{addr:04X}] <= 32\'h{value:08X};\n"
##              addr += 1
##
##
##           progmem_body = f"""
##  module progmem (
##      // Clock & reset
##      input wire clk,
##      input wire rstn,
##
##      // PicoRV32 bus interface
##      input  wire        valid,
##      output wire        ready,
##      input  wire [31:0] addr,
##      output wire [31:0] rdata,
##          // Rewrite firmware
##      input  wire        wen,
##          input  wire [31:0] waddr,
##          input  wire [31:0] wdata
##  );
##
##    // ============================================================================
##
##    localparam MEM_SIZE_BITS = 13;  // In 32-bit words
##    localparam MEM_SIZE = 1 << MEM_SIZE_BITS;
##    localparam MEM_ADDR_MASK = 32'h0010_0000;
##
##    // ============================================================================
##
##    wire [MEM_SIZE_BITS-1:0] mem_addr;
##    reg  [             31:0] mem_data;
##    reg  [             31:0] mem      [0:MEM_SIZE];
##
##    initial begin
##  {progmem_text}
##    end
##
##    always @(posedge clk) mem_data <= mem[mem_addr];
##
##    // ============================================================================
##
##    reg o_ready;
##
##    always @(posedge clk or negedge rstn)
##      if (!rstn) o_ready <= 1'd0;
##      else o_ready <= valid && ((addr & MEM_ADDR_MASK) != 0);
##
##    // Output connectins
##    assign ready    = o_ready;
##    assign rdata    = mem_data;
##    assign mem_addr = addr[MEM_SIZE_BITS+1:2];
##
##    always @(posedge clk) begin
##      if (wen) mem[waddr] <= wdata;
##    end
##
##  endmodule
##  """
##
##	 prog_mem_file.write(progmem_body)

except Exception as e:
    print(f"Write file Exception: {e}")
    sys.exit(-1)


#=============================================================
# End-of-File
#=============================================================
