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
//   VUserMain utilities header
//
//==========================================================================

#include <stdio.h>
#include <stdlib.h>

#include "VUserMain0.h"
#include "rv32.h"

// ---------------------------------------------
// Parse configuration file arguments
// ---------------------------------------------

extern int  parseArgs (int argcIn, char** argvIn, rv32i_cfg_s &cfg, vusermain_cfg_t &vcfg, const int node);
extern void reg_dump  (rv32* pCpu, FILE* dfp, bool abi_en);
extern void csr_dump  (rv32* pCpu, FILE* dfp);