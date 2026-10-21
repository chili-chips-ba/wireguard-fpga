// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Checker for the UART bus master and the CPU sharing soc_fabric (#61).
// Enabled with UART_BUS_STRESS, where bfm_uart sends busw commands while
// the firmware runs. Flags:
//  - a CPU store that leaves the bus before it got ready (a lost store)
//  - a DMEM/CSR request raised by the CPU while the UART holds the bus
//    (it would reach the slave with the UART's address)
// and counts the collisions, so a PASS shows the case was exercised.
//==========================================================================
module chk_uart_bus;
  import soc_pkg::*;

  int        busw_cnt = 0;  // UART bus writes accepted
  int        collisions = 0;  // clocks with a CPU store while the UART has the bus
  int        dropped = 0;  // CPU stores dropped before ready
  int        spurious = 0;  // CPU requests that reached DMEM/CSR during a UART access

  logic      p_vld;
  logic      p_rdy;
  soc_we_t   p_we;
  soc_addr_t p_addr;

  always @(posedge tb.dut.u_fabric.cpu.clk) begin
    // the store pending last clock must still be on the bus, unchanged
    if (p_vld && (p_we != '0) && !p_rdy &&
        !(tb.dut.u_fabric.cpu.vld && tb.dut.u_fabric.cpu.we == p_we &&
          tb.dut.u_fabric.cpu.addr == p_addr)) begin
      dropped++;
      if (dropped <= 5) $display("%t CHK_UART_BUS: CPU store to %h dropped before ready",
                                 $time, {p_addr, 2'b00});
    end

    if (tb.dut.u_fabric.uart_busy && tb.dut.u_fabric.cpu.vld && !tb.dut.u_fabric.uart.vld &&
        (tb.dut.u_fabric.dmem.vld || tb.dut.u_fabric.csr.vld)) begin
      spurious++;
    end

    if (tb.dut.u_fabric.uart_busy && tb.dut.u_fabric.cpu.vld &&
        (tb.dut.u_fabric.cpu.we != '0)) begin
      collisions++;
    end

    if (tb.dut.u_fabric.uart.vld && tb.dut.u_fabric.uart.rdy &&
        (tb.dut.u_fabric.uart.we != '0)) begin
      busw_cnt++;
    end

    p_vld  <= tb.dut.u_fabric.cpu.vld;
    p_rdy  <= tb.dut.u_fabric.cpu.rdy;
    p_we   <= tb.dut.u_fabric.cpu.we;
    p_addr <= tb.dut.u_fabric.cpu.addr;
  end

  // store_stress firmware (2.sw/tests/store_stress) result, at DMEM 0x1000_F000
  function automatic logic [31:0] fw_word(input int idx);
    return tb.dut.u_dmem.mem[(32'h0000_F000 >> 2) + idx];
  endfunction

  final begin
    if (fw_word(0) == 32'h57AB_1E00) begin
      $display("CHK_UART_BUS: store_stress firmware: %0d passes, %0d read-back errors",
               fw_word(1), fw_word(2));
      if (fw_word(1) == 0 || fw_word(2) != 0) dropped++;  // no progress, or lost data
    end
    $display("CHK_UART_BUS: %s  busw=%0d collisions=%0d dropped_stores=%0d spurious=%0d",
             (dropped == 0 && spurious == 0 && collisions > 0 &&
              bfm_errors() == 0) ? "PASS" : "FAIL",
             busw_cnt, collisions, dropped, spurious);
  end

  function automatic int bfm_errors();
    return tb.bfm_uart.stress_errors;
  endfunction
endmodule : chk_uart_bus
