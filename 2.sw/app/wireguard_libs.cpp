//==========================================================================
// Copyright (C) 2024-2026 Chili.CHIPS*ba
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
//   WireGuard C++ standard library
//==========================================================================

#include "wireguard_libs.h"

#ifndef VPROC

char heap_memory[32768];
int heap_memory_used = 0;

void* malloc(int size) {
   char* p = heap_memory + heap_memory_used;
   heap_memory_used += size;
   if (heap_memory_used > 32768)
      asm volatile ("ebreak");
   return p;
}

void* operator new(unsigned int size) {
   return malloc(size);
}

void operator delete(void* p) {
   // Dummy delete
}

#endif  // VPROC
