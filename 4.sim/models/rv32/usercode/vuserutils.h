// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   VUserMain utilities header
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
