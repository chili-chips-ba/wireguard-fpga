//==========================================================================
// Copyright (C) 2023 Chili.CHIPS*ba
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
//   SOC interconnect Fabric.
//
//   Standardized template, then customized to each particular SOC design. 
//   This is the central module which all other SOC blocks, be they Masters 
//   or Slaves, connect to. It is responsible for routing, address decoding 
//   and muxing of data returned by the Slaves. 
//
//   We support Direct Memory Access (DMA) from ADC to SDRAM. Arbitration is
//   simple: In case of concurrent requests, it always gives precedence to
//   ADC DMA. However, ADC cannot interrupt an ongoing CPU transfer to SDRAM. 
// 
//   SW handshake with ADC is constructed so that the CPU does not need to
//   access SDRAM while ADC is active. If it does, CPU can still get through,
//   as ADC is a good citizen who does not keep the bus longer than needed. 
//   The CPU is forced to wait only for concurrent access requests, or 
//   requests that arrive while ADC is already using SDRAM.
//--------------------------------------------------------------------------
// Address Decoding is as follows:
//  0x1000_0000 - 0x1FFF_FFFF - DMEM. For 32kB DMEM, use ADDR_STACK=0x1000_8000
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//  0x4000_0000 - 0xFFFF_FFFF - SDRAM:8MBytes, which needs 00_0000-7F_FFFF
//
//  This shows total allocation. Actual resources take much less, and alias
//==========================================================================

module soc_fabric (
// From Master(s):
   soc_if.SLV  cpu,  //interface for the controlling CPU (this SOC has only 1 CPU)
   soc_if.SLV  adc,  //interface for ADC path to SDRAM

// To Peripheral(s):                   
   soc_if.MST  dmem, //interface to Data Memory of the CPU
   soc_if.MST  csr,  //interface to CSR register block (aka GPIO)
   soc_if.MST  sdram //interface to SDRAM block
);

//-----------------------------------------------------------
// propagate/replicate common controls from Master to all Peripherals
//-----------------------------------------------------------
   assign dmem.addr  = cpu.addr;
   assign dmem.we    = cpu.we;
   assign dmem.wdat  = cpu.wdat;
                      
   assign csr.addr   = cpu.addr;
   assign csr.we     = cpu.we;
   assign csr.wdat   = cpu.wdat;

 // SDRAM latches ADDR and WE as soon as its sees VLD. WDAT is
 // taken 1 cycle later, hence can be selected with flopped signal,
 // helping timing closure by lowering the load on combo 'adc_sdram_ack'

   logic adc_sdram_ack;  // 1 as soon as ADC gets the bus
   logic cpu_sdram_busy; // 1 when CPU is already using the bus

   assign sdram.addr = adc_sdram_ack  ? adc.addr : cpu.addr;
   assign sdram.we   = adc_sdram_ack  ? adc.we   : cpu.we;
   assign sdram.wdat = cpu_sdram_busy ? cpu.wdat : adc.wdat; 

//-----------------------------------------------------------
// assign peripheral Point-to-Point controls per Memory Map
//-----------------------------------------------------------
// peripheral selects
   logic dmem_sel, csr_sel, sdram_sel, cpu_sdram_vld;
    
//address decode: All selects must be mutually exclusive!
   assign dmem_sel  = (cpu.addr[31:28] == 4'd1); //0x1000_0000 - 0x1FFF_FFFF
   assign csr_sel   = (cpu.addr[31:29] == 3'd1); //0x2000_0000 - 0x3FFF_FFFF
   assign sdram_sel = (cpu.addr[31:30] != 2'd0); //0x4000_0000 - 0xFFFF_FFFF
     
//peripheral access is when peripheral is SELected and CPU VLD
   assign dmem.vld      = cpu.vld & dmem_sel;
   assign csr.vld       = cpu.vld & csr_sel;
   assign cpu_sdram_vld = cpu.vld & sdram_sel;

// SDRAM transaction is started w/o waiting for arbitration.
// VLD does not need to drop to 0 upon getting RDY. It can
// be back-to-back. That maximizes the throughput
   assign sdram.vld = cpu_sdram_vld | adc.vld;

//return RDY+RDAT to CPU from the selected peripheral
   assign cpu.rdy   = dmem_sel ? dmem.rdy 
                    : csr_sel  ? csr.rdy
                               :(sdram.rdy & cpu_sdram_busy);
                     
   assign cpu.rdat  = dmem_sel ? dmem.rdat 
                    : csr_sel  ? csr.rdat
                               : sdram.rdat;

//return RDY+RDAT to ADC from SDRAM
   assign adc.rdy   = sdram.rdy & ~cpu_sdram_busy;
   assign adc.rdat  = sdram.rdat;


//-----------------------------------------------------------
// Arbitration between ADC and CPU accesses to SDRAM.
//
// ACK must be combo because:
//  -transaction is started w/o waiting for arbitration result
//  -SDRAM captures ADDR+WE on the cycle it sees VLD=1
//  -and ACK is used for ADDR+WE selection
//
// ADC gets SDRAM if CPU is not on it, or they both request it
// at the same time. If CPU is already using SDRAM, ADC has to
// wait till CPU is done. CPU has to wait if ADC is already 
// using SDRAM, or wants it at the same time as CPU
//-----------------------------------------------------------   
   always_ff @(negedge adc.arst_n or posedge adc.clk) begin
      if (adc.arst_n == 1'b0) begin
         cpu_sdram_busy <= 1'b0;
      end   
      else begin
         cpu_sdram_busy <= cpu_sdram_busy
         //once started, CPU keeps the bus until transaction is over
          ? ~sdram.rdy                

         //CPU gets bus if ADC doesn't want it at that very moment
          : ({adc.vld, cpu_sdram_vld} == 2'b01);
      end
   end

   // ADC cannot interrupt an ongoing CPU transaction
   assign adc_sdram_ack = adc.vld & ~cpu_sdram_busy;

endmodule: soc_fabric

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2023/12/20 JI: initial creation    
 2024/03/16 JI: replaced always_comb with assigns
 2024/04/07 JI: added ADC DMA path for SDRAM, and arbitration with CPU
*/
