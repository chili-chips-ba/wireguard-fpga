// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description:
//   SOC interconnect Fabric.
//
//   Standardized template, then customized to each particular SOC design.
//   This is the central module which all other SOC blocks, be they Masters
//   or Slaves, connect to. It is responsible for routing, address decoding
//   and muxing of data returned by the Slaves.
//--------------------------------------------------------------------------
// Address Decoding is as follows:
//  0x1000_0000 - 0x1FFF_FFFF - DMEM. For 32kB DMEM, use ADDR_STACK=0x1000_8000
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//
//  This shows total allocation. Actual resources take much less, and alias
//==========================================================================

module soc_fabric (
// From Master(s):
   soc_if.SLV  cpu,  //interface for the controlling CPU (this SOC has only 1 CPU)
   soc_if.SLV  uart, //interface for the bus mastering via UART

// To Peripheral(s):
   soc_if.MST  dmem, //interface to Data Memory of the CPU
   soc_if.MST  csr   //interface to CSR register block
);

//-----------------------------------------------------------
// propagate/replicate common controls from Master to all Peripherals
//-----------------------------------------------------------
   logic cpu_ack;    // 1 as soon as CPU gets the bus
   logic uart_busy;  // 1 when UART is already using the bus
   logic uart_done;  // 1 when UART is done with using bus
   
   assign dmem.addr  = cpu_ack ? cpu.addr : uart.addr;
   assign dmem.we    = cpu_ack ? cpu.we   : uart.we;
   assign dmem.wdat  = cpu_ack ? cpu.wdat : uart.wdat;

   assign csr.addr   = cpu_ack ? cpu.addr : uart.addr;
   assign csr.we     = cpu_ack ? cpu.we   : uart.we;
   assign csr.wdat   = cpu_ack ? cpu.wdat : uart.wdat;

//-----------------------------------------------------------
// assign peripheral Point-to-Point controls per Memory Map
//-----------------------------------------------------------
// peripheral selects
   logic dmem_sel, csr_sel;

//address decode: All selects must be mutually exclusive!
   assign dmem_sel  = cpu_ack ? (cpu.addr[31:28] == 4'd1) : (uart.addr[31:28] == 4'd1); //0x1000_0000 - 0x1FFF_FFFF
   assign csr_sel   = cpu_ack ? (cpu.addr[31:29] == 3'd1) : (uart.addr[31:29] == 3'd1); //0x2000_0000 - 0x3FFF_FFFF

//peripheral access is when peripheral is SELected and UART/CPU VLD
   assign dmem.vld      = (uart.vld | cpu.vld) & dmem_sel;
   assign csr.vld       = (uart.vld | cpu.vld) & csr_sel;

//return RDY+RDAT to UART from the selected peripheral
   assign uart.rdy  = dmem_sel ? dmem.rdy & uart_busy
                    : csr_sel  ? csr.rdy & uart_busy
                               : 1'b0;

   assign uart.rdat = dmem_sel ? dmem.rdat
                    : csr_sel  ? csr.rdat
                               : '0;
                               
//return RDY+RDAT to CPU from the selected peripheral
   assign cpu.rdy   = dmem_sel ? dmem.rdy & ~uart_busy
                    : csr_sel  ? csr.rdy & ~uart_busy
                               : 1'b0;

   assign cpu.rdat  = dmem_sel ? dmem.rdat
                    : csr_sel  ? csr.rdat
                               : '0;

//-----------------------------------------------------------
// Arbitration between UART and CPU accesses to the bus.
//
// ACK must be combo because:
//  -transaction is started w/o waiting for arbitration result
//  -DMEM/CSR captures ADDR+WE on the cycle it sees VLD=1
//  -and ACK is used for ADDR+WE selection
//
// CPU gets the bus if UART is not on it, or they both request it
// at the same time. If UART is already using the bus, CPU has to
// wait till UART is done. UART has to wait if CPU is already 
// using the bus, or wants it at the same time as CPU
//-----------------------------------------------------------   
   always_ff @(negedge cpu.arst_n or posedge cpu.clk) begin
      if (cpu.arst_n == 1'b0) begin
         uart_busy <= 1'b0;
      end
      else begin
         uart_busy <= uart_busy
         // once started, UART keeps the bus until transaction is over
                    //? uart.vld
                    //? ~(dmem.rdy & csr.rdy) | uart.vld
                    ? ~uart_done | uart.vld

         // UART gets bus if CPU doesn't want it at that very moment
                    : ({cpu.vld, uart.vld} == 2'b01);
      end
   end
   
   // UART is done with using bus
   assign uart_done = (dmem_sel & dmem.rdy) | (csr_sel & csr.rdy);
   
   // CPU cannot interrupt an ongoing UART transaction
   assign cpu_ack = cpu.vld & ~uart_busy;
endmodule: soc_fabric
