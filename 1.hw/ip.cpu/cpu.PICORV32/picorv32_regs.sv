//--------------------------------------------------------------------------
// Improved by Chili.CHIPS (2023/24)
//--------------------------------------------------------------------------

// This is a simple example implementation of PICORV32_REGS.
// Use the PICORV32_REGS mechanism if you want to use custom
// memory resources to implement the processor register file.
// Note that your implementation must match the requirements of
// the PicoRV32 configuration. (e.g. QREGS, etc)

module picorv32_regs (
   input  logic        clk, 
   input  logic        wen,
   input  logic [5:0]  waddr,
   input  logic [5:0]  raddr1,
   input  logic [5:0]  raddr2,
   input  logic [31:0] wdata,

   output logic [31:0] rdata1,
   output logic [31:0] rdata2
);
   reg [31:0] regs [0:30];

   always_ff @(posedge clk) begin
      if (wen) regs[~waddr[4:0]] <= wdata;
   end

   assign rdata1 = regs[~raddr1[4:0]];
   assign rdata2 = regs[~raddr2[4:0]];

endmodule: picorv32_regs

