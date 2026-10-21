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
// CSR_VP() gives the csr_vp_t pointer on either platform.
# ifdef VPROC
#  include "csr_cosim.h"
#  define CSR_VP()  (new csr_vp_t())                  // tree of VProc handles
# else
#  include "csr_hw.h"
#  define CSR_VP()  ((csr_vp_t*)CSR_VP_BASE_ADDR)     // the CSRs: nothing to construct
# endif

#endif
