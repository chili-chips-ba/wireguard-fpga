// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation
//--------------------------------------------------------------------------
// Description:
//   VProc node 0 for the native build (BUILD=DEFAULT): runs the real
//   firmware.
//
//   MakefileVProc.mk compiles 2.sw/app for the host, as C++, with main()
//   renamed fw_main(). Its register accesses (CSR_REG32, CSR_GET, CSR_SET,
//   CSR_RMW in csr_regs.h) become VProc bus cycles on the SOC bus, at
//   the same addresses and with the same byte enables as on the RISC-V
//   core. So the RTL core, the rv32 ISS and this build all run one firmware
//   source; only the way it executes differs.
//==========================================================================

extern "C" {
#include "VUser.h"
}

int fw_main();

extern "C" void VUserMain0(void)
{
    VPrint("\n[native] firmware entered on VProc node 0\n");
    fw_main();

    // main() does not return; should it, keep the node alive
    while (true)
        VTick(10000, 0);
}

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2026/10/26   : runs the 2.sw firmware itself (was a write and read-back
                sanity test)
*/
