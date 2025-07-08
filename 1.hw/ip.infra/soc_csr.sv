//==========================================================================
// Copyright (C) 2024-2025 Chili.CHIPS*ba
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
//   CSR wrapper for PeakRDL-generated CSR
//==========================================================================

module soc_csr
   import soc_pkg::*;
   import csr_pkg::*;
(
   soc_if.SLV                 bus,
   input csr_pkg::csr__in_t   hwif_in,
   output csr_pkg::csr__out_t hwif_out
);
   logic [31:0]               s_cpuif_wr_biten;

   assign s_cpuif_wr_biten[31:24] = bus.we[3] ? '1 : '0;
   assign s_cpuif_wr_biten[23:16] = bus.we[2] ? '1 : '0;
   assign s_cpuif_wr_biten[15:8]  = bus.we[1] ? '1 : '0;
   assign s_cpuif_wr_biten[7:0]   = bus.we[0] ? '1 : '0;

   assign bus.rdy = 1'b1;

   csr csr_inst (
      .clk                  (bus.clk),
      .rst                  (~bus.arst_n),

      .s_cpuif_req          (bus.vld),
      .s_cpuif_req_is_wr    (|bus.we),
      .s_cpuif_addr         ({bus.addr[12:2],2'b00}),
      .s_cpuif_wr_data      (bus.wdat),
      .s_cpuif_wr_biten     (s_cpuif_wr_biten),
      .s_cpuif_req_stall_wr (),
      .s_cpuif_req_stall_rd (),
      .s_cpuif_rd_ack       (),
      .s_cpuif_rd_err       (),
      .s_cpuif_rd_data      (bus.rdat),
      .s_cpuif_wr_ack       (),
      .s_cpuif_wr_err       (),

      .hwif_in              (hwif_in),
      .hwif_out             (hwif_out)
   );

//=========================================
// Sim-only
//=========================================
`ifdef SIM_ONLY
`ifdef CSR_DEBUG

   always @(posedge bus.clk) begin
      if ({bus.vld, bus.rdy} == 2'b11) begin
         if (|bus.we == 1) begin
            $display("%t %m WRITE [%08x]<=%08x", $time,
                     {bus.addr, 2'd0}, bus.wdat);
         end
         if (|bus.we == 0) begin
            $display("%t %m READ [%08x]=>%08x", $time,
                     {bus.addr, 2'd0}, bus.rdat);
         end
      end
   end

`endif
`endif

endmodule: soc_csr
