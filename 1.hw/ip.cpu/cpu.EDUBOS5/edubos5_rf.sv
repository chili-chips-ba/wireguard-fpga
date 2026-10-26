// SPDX-FileCopyrightText: 2022 Chili.CHIPS
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// eduBOS5 register file, reset handled in software
// 2 asynchronous read ports, 1 synchronous write port
//==========================================================================
module edubos5_rf
  import edubos5_pkg::*;
#(
    parameter bit TARGET_IS_ASIC = 1'b0  // 1: x0 forced to 0 by a read mux, not RAM init
) (
    input logic            clk,
    input logic      [4:0] rs1_addr,
    input logic      [4:0] rs2_addr,
    input logic      [4:0] rd_addr,
    input logic            rf_we,
    input cpu_data_t       rf_wdat,

    output cpu_data_t rs1,
    output cpu_data_t rs2
);

  cpu_data_t rf[32]  /* synthesis syn_ramstyle = "distributed_ram" */;

  // rf[0] is x0 and never written. FPGA: it reads 0 because the LUT RAM starts
  // at 0, its INIT value. ASIC: no power-up value, so a read mux forces it.
  initial begin
    if (!TARGET_IS_ASIC) begin
      for (int i = 0; i < 32; i++) begin
        rf[i] = '0;
      end
    end
  end

  assign rs1 = (TARGET_IS_ASIC && rs1_addr == '0) ? '0 : rf[rs1_addr];
  assign rs2 = (TARGET_IS_ASIC && rs2_addr == '0) ? '0 : rf[rs2_addr];

  always_ff @(posedge clk) begin : rf_writeback
    if (rf_we == HI) begin
      rf[rd_addr] <= rf_wdat;  // one write port
    end
  end : rf_writeback

endmodule : edubos5_rf

// -----------------------------------------------------------------------------
// Project:     openPCIE
// Description: NLnet-sponsored open-source implementation
// Version:     1.0
// Date:        May 5, 2024
// -----------------------------------------------------------------------------
