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
//   Header for the VProc main program to instantiate and run the rv32 RISC-V
//   instruction set simulator
//
//==========================================================================

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern "C" {

#include "VUser.h"
}

#define CFGFILENAME                        "vusermain.cfg"
#define MAXARGS                            100
#define MEM_SIZE                           (1024*1024)
#define MEM_OFFSET                         0

#ifndef EXT_ACCESS_BASE
#define EXT_ACCESS_BASE                    0x20000000
#endif

#ifndef EXT_ACCESS_TOP
#define EXT_ACCESS_TOP                     0x40000000
#endif

// Define a sleep forever macro
#define SLEEP_FOREVER {while(1)            VTick(0x7fffffff, node);}

