//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
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
//   Header file for memory access API, selecting between HDL transaction or
//   memory model direct access API.
//
//==========================================================================

#ifndef _MEM_VPROC_API_H_
#define _MEM_VPROC_API_H_

#include <cstdio>
#include <cstdlib>
#include <cstdint>

extern "C" {
#include "VUser.h"
#include "mem.h"
}

// Define VProc call normal and delta values
#define NORMAL_UPDATE                           0
#define DELTA_UPDATE                            1
#define BIG_ENDIAN                              0
#define LITTLE_ENDIAN                           1

#ifndef ENDIAN
#define ENDIAN                                   LITTLE_ENDIAN
#endif

extern int      node;

extern void     write_word  (uint32_t byte_addr, uint32_t data, bool access_sim = false);
extern void     write_hword (uint32_t byte_addr, uint32_t data, bool access_sim = false);
extern void     write_byte  (uint32_t byte_addr, uint32_t data, bool access_sim = false);
extern uint32_t read_word   (uint32_t byte_addr, bool access_sim = false);
extern uint32_t read_instr  (uint32_t byte_addr, bool access_sim = false);
extern uint32_t read_hword  (uint32_t byte_addr, bool access_sim = false);
extern uint32_t read_byte   (uint32_t byte_addr, bool access_sim = false);

#endif


