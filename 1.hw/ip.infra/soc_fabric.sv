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

// To Peripheral(s):                   
   soc_if.MST  dmem, //interface to Data Memory of the CPU
   soc_if.MST  csr   //interface to CSR register block
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

//-----------------------------------------------------------
// assign peripheral Point-to-Point controls per Memory Map
//-----------------------------------------------------------
// peripheral selects
   logic dmem_sel, csr_sel;
    
//address decode: All selects must be mutually exclusive!
   assign dmem_sel  = (cpu.addr[31:28] == 4'd1); //0x1000_0000 - 0x1FFF_FFFF
   assign csr_sel   = (cpu.addr[31:29] == 3'd1); //0x2000_0000 - 0x3FFF_FFFF
     
//peripheral access is when peripheral is SELected and CPU VLD
   assign dmem.vld      = cpu.vld & dmem_sel;
   assign csr.vld       = cpu.vld & csr_sel;

//return RDY+RDAT to CPU from the selected peripheral
   assign cpu.rdy   = dmem_sel ? dmem.rdy 
                    : csr_sel  ? csr.rdy
                               : 1'b1;
                     
   assign cpu.rdat  = dmem_sel ? dmem.rdat 
                    : csr_sel  ? csr.rdat
                               : '0;

endmodule: soc_fabric
