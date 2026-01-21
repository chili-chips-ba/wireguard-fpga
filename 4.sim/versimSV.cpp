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
