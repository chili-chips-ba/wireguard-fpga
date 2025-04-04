//==========================================================================
// Copyright (C) 2025 Chili.CHIPS*ba
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
//   WireGuard software top level CSR definition header
//
//==========================================================================

#ifndef _WIREGUARD_REGS_H_
#define _WIREGUARD_REGS_H_

// Select appropriate auto-generated HAL header for the build type.
// To build these headers, use "make -f MakefileCosim" in 3.build/ directory
# ifdef VPROC
#  include "csr_cosim.h"
# else
   static char heap_memory[2048];
   static int heap_memory_used = 0;

   void *malloc(int size)
   {
      char *p = heap_memory + heap_memory_used;
      heap_memory_used += size;
      if (heap_memory_used > 2048)
         asm volatile ("ebreak");
      return p;
   }

   void *operator new(unsigned int size)
   {
      void *const p = malloc(size);
      return p;
   }

   void operator delete(void *p) // or delete(void *, std::size_t)
   {
      return;
   }
#  include "csr_hw.h"
# endif

#endif
