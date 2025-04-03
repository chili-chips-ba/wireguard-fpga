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
//   WireGuard C++ standard library
//
//==========================================================================

#ifndef _WIREGUARD_LIBS_H_
#define _WIREGUARD_LIBS_H_

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

#endif
