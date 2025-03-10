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
   soc_if.SLV          bus,
   csr_pkg::csr__in_t  hwif_in,
   csr_pkg::csr__out_t hwif_out
);
   logic cpuif_req_stall_wr;
   logic cpuif_req_stall_rd;
   logic cpuif_rd_ack;
   logic cpuif_wr_ack;
   
   assign bus.rdy = (!cpuif_req_stall_wr & cpuif_wr_ack) | (!cpuif_req_stall_rd & cpuif_rd_ack);
   
   csr csr_inst (
      .clk(bus.clk),
      .rst(~bus.arst_n),

      .s_cpuif_req(bus.vld),
      .s_cpuif_req_is_wr(|bus.we),
      .s_cpuif_addr({bus.addr[5:2],2'b00}),
      .s_cpuif_wr_data(bus.wdat),
      .s_cpuif_wr_biten(bus.we),
      .s_cpuif_req_stall_wr(cpuif_req_stall_wr),
      .s_cpuif_req_stall_rd(cpuif_req_stall_rd),
      .s_cpuif_rd_ack(cpuif_rd_ack),
      .s_cpuif_rd_err(),
      .s_cpuif_rd_data(bus.rdat),
      .s_cpuif_wr_ack(cpuif_wr_ack),
      .s_cpuif_wr_err(),

      .hwif_in(hwif_in),
      .hwif_out(hwif_out)
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
