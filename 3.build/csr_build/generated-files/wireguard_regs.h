// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description: 
//   WireGuard software top level CSR definition header
//==========================================================================

#ifndef _WIREGUARD_REGS_H_
#define _WIREGUARD_REGS_H_

// Select appropriate auto-generated HAL header for the build type.
// To build these headers, use "make -f MakefileCosim" in 3.build/ directory
# ifdef VPROC
#  include "csr_cosim.h"
# else
#  include "csr_hw.h"
# endif

#endif
