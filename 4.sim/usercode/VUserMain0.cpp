// =============================================================
//
// VProc user code for WireGuard test bench
//
// Copyright (c) 2024 Simon Southwell. Confidential
//
// This file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this file. If not, see <http://www.gnu.org/licenses/>.
//
// =============================================================

#include <stdio.h>
#include <stdint.h>

#include "VProcClass.h"

extern "C" {
#include "mem.h"
}

static const int node    = 0;

// ----------------------------------------------------------------------------
// VProc node 0 main entry point
// ----------------------------------------------------------------------------

extern "C" void VUserMain0(void)
{
    VPrint("Entered VuserMain%d()\n", node);
    
    // Create VProc access object for this node
    VProc* vp0 = new VProc(node);
    
    // Wait a bit
    vp0->tick(100);
    
    uint32_t addr  = 0x10001000;
    uint32_t wdata = 0x900dc0de;
    
    vp0->write(addr, wdata);
    VPrint("Written   0x%08x  to  addr 0x%08x\n", wdata, addr);
    
    vp0->tick(3);
    
    uint32_t rdata;
    vp0->read(addr, &rdata);
    
    if (rdata == wdata)
    {
        VPrint("Read back 0x%08x from addr 0x%08x\n", rdata, addr);
    }
    else
    {   VPrint("***ERROR: data mis-match at addr = 0x%08x. Got 0x%08x, expected 0x%08x\n", addr, rdata, wdata);
    }

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp0->tick(GO_TO_SLEEP);
}