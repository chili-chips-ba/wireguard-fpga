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

#ifndef VPROC

#ifdef __cplusplus
extern "C" {
#endif

extern char heap_memory[32768];
extern int heap_memory_used;

void* malloc(int size);

#ifdef __cplusplus
}
void* operator new(unsigned int size);
void operator delete(void* p);
#endif

#endif  // VPROC

#endif  // _WIREGUARD_LIBS_H_
