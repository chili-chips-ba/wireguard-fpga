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
//   CPU FIFOs
//==========================================================================

module cpu_fifo
   import csr_pkg::*;
(
   input  csr_pkg::csr__out_t from_csr,
   output csr_pkg::csr__in_t  to_csr,
   dpe_if.s_axis              to_cpu,
   dpe_if.m_axis              from_cpu
);
   axis_fifo #(
      .DEPTH                  (4096),
      .DATA_WIDTH             (128),
      .USER_WIDTH             (8),
      .FRAME_FIFO             (1),
      .DROP_WHEN_FULL         (1)
   ) tx_fifo (
      .clk                    (to_cpu.clk),
      .rst                    (to_cpu.rst),

      .s_axis_tdata           (to_cpu.tdata),
      .s_axis_tkeep           (to_cpu.tkeep),
      .s_axis_tvalid          (to_cpu.tvalid),
      .s_axis_tready          (to_cpu.tready),
      .s_axis_tlast           (to_cpu.tlast),
      .s_axis_tuser           ({to_cpu.tuser_bypass_all,
                                to_cpu.tuser_bypass_stage,
                                to_cpu.tuser_src,
                                to_cpu.tuser_dst}),
      .s_axis_tid             (),
      .s_axis_tdest           (),

      .m_axis_tdata           ({to_csr.cpu_fifo.tx.data_127_96.tdata.next,
                                to_csr.cpu_fifo.tx.data_95_64.tdata.next,
                                to_csr.cpu_fifo.tx.data_63_32.tdata.next,
                                to_csr.cpu_fifo.tx.data_31_0.tdata.next}),
      .m_axis_tkeep           (to_csr.cpu_fifo.tx.control.tkeep.next),
      .m_axis_tvalid          (to_csr.cpu_fifo.tx.status.tvalid.next),
      .m_axis_tready          (from_csr.cpu_fifo.tx.trigger.tready.value),
      .m_axis_tlast           (to_csr.cpu_fifo.tx.control.tlast.next),
      .m_axis_tuser           ({to_csr.cpu_fifo.tx.control.tuser_bypass_all.next,
                                to_csr.cpu_fifo.tx.control.tuser_bypass_stage.next,
                                to_csr.cpu_fifo.tx.control.tuser_src.next,
                                to_csr.cpu_fifo.tx.control.tuser_dst.next}),
      .m_axis_tid             (),
      .m_axis_tdest           (),
      
      .pause_req              (),
      .pause_ack              (),
      .status_depth           (),
      .status_depth_commit    (),
      .status_overflow        (),
      .status_bad_frame       (),
      .status_good_frame      ()
   );

   axis_fifo #(
      .DEPTH                  (4096),
      .DATA_WIDTH             (128),
      .USER_WIDTH             (8),
      .FRAME_FIFO             (1),
      .DROP_WHEN_FULL         (1)
   ) rx_fifo (
      .clk                    (to_cpu.clk),
      .rst                    (to_cpu.rst),

      .s_axis_tdata           ({from_csr.cpu_fifo.rx.data_127_96.tdata.value,
                                from_csr.cpu_fifo.rx.data_95_64.tdata.value,
                                from_csr.cpu_fifo.rx.data_63_32.tdata.value,
                                from_csr.cpu_fifo.rx.data_31_0.tdata.value}),
      .s_axis_tkeep           (from_csr.cpu_fifo.rx.control.tkeep.value),
      .s_axis_tvalid          (from_csr.cpu_fifo.rx.trigger.tvalid.value),
      .s_axis_tready          (to_csr.cpu_fifo.rx.status.tready.next),
      .s_axis_tlast           (from_csr.cpu_fifo.rx.control.tlast.value),
      .s_axis_tuser           ({from_csr.cpu_fifo.rx.control.tuser_bypass_all.value,
                                from_csr.cpu_fifo.rx.control.tuser_bypass_stage.value,
                                from_csr.cpu_fifo.rx.control.tuser_src.value,
                                from_csr.cpu_fifo.rx.control.tuser_dst.value}),
      .s_axis_tid             (),
      .s_axis_tdest           (),

      .m_axis_tdata           (from_cpu.tdata),
      .m_axis_tkeep           (from_cpu.tkeep),
      .m_axis_tvalid          (from_cpu.tvalid),
      .m_axis_tready          (from_cpu.tready),
      .m_axis_tlast           (from_cpu.tlast),
      .m_axis_tuser           ({from_cpu.tuser_bypass_all,
                                from_cpu.tuser_bypass_stage,
                                from_cpu.tuser_src,
                                from_cpu.tuser_dst}),
      .m_axis_tid             (),
      .m_axis_tdest           (),
      
      .pause_req              (),
      .pause_ack              (),
      .status_depth           (),
      .status_depth_commit    (),
      .status_overflow        (),
      .status_bad_frame       (),
      .status_good_frame      ()
   );
endmodule
