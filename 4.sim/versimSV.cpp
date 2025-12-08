///////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2024 -- CHILI CHIPS LLC, All rights reserved.
//
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//-----------------------------------------------------------------------------
// C++ DPI which allows Verilator to use System Verilog behavioral constructs,
//    i.e. create SV testbenches
///////////////////////////////////////////////////////////////////////////////

#if TRACE_VCD
#include <verilated_vcd_c.h>
#else
#include <verilated_fst_c.h>
#endif 
#include "verilated.h"
#include "Vtb.h" //change to V<projectname>

double sc_time_stamp() { return 0; }

#ifndef NO_TRACE
static bool           do_flush = true;

//-----------------------------------------
// Flush FST wave output for use externally
//-----------------------------------------

void flushfst()
{
   do_flush = true;
}
#else
void flushfst() {}
#endif

//----------------------------------------
int main(int argc, char** argv, char**) {
   // Setup context, defaults, and parse command line
   Verilated::debug(0);
   const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
   contextp->traceEverOn(true);
   contextp->commandArgs(argc, argv);

   // Construct the Verilated model, from Vtop.h generated from Verilating
   const std::unique_ptr<Vtb> topp{new Vtb{contextp.get()}};

#ifndef NO_TRACE
# if TRACE_VCD
   VerilatedVcdC *m_trace = new VerilatedVcdC;
# else
   VerilatedFstC *m_trace = new VerilatedFstC;
# endif
   
   m_trace->set_time_resolution("1ps");
   m_trace->set_time_unit("1ps");
   topp->trace(m_trace, 20);
# if TRACE_VCD
   m_trace->open("wave.vcd");
# else
   m_trace->open("wave.fst");
#endif
#endif


   // Simulate until $finish
   long long int t0 = 0;
   while (!contextp->gotFinish()) {
      
      // If an outstanding external request to flush, do so now and clear request
#ifndef NO_TRACE
      if (do_flush)
      {
          m_trace->flush();
          do_flush = false;
      }
#endif
           
      // Evaluate model
      topp->eval();
#ifndef NO_TRACE
      m_trace->dump(contextp->time());
#endif
      // Advance time
      if (!topp->eventsPending()) break;
      contextp->time(topp->nextTimeSlot());
      t0++;
   }

   if (!contextp->gotFinish()) {
      VL_DEBUG_IF(VL_PRINTF("+ Exiting without $finish; no events left\n"););
   }

#ifndef NO_TRACE
   m_trace->close();
#endif

   // Closing cleanup
   topp->final();
   return 0;
}

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/02/14 TI: initial creation    
*/
