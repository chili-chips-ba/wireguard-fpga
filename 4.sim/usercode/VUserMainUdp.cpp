// =============================================================
//
// VProc user code for WireGuard test bench udpPgIp BFM nodes
//
// Copyright (c) 2025 Simon Southwell. Confidential
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

// ----------------------------------------------------------------------------
// VProc node main entry points for udpIpPg nodes
// ----------------------------------------------------------------------------

extern "C" void VUserMain1(void)
{
    
    // Create VProc access object for this node
    VProc* vp = new VProc(1);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}

extern "C" void VUserMain2(void)
{
    
    // Create VProc access object for this node
    VProc* vp = new VProc(2);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}

extern "C" void VUserMain3(void)
{
    
    // Create VProc access object for this node
    VProc* vp = new VProc(3);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}
extern "C" void VUserMain4(void)
{
    
    // Create VProc access object for this node
    VProc* vp = new VProc(4);

    // Sleep forever (and allow simulation to continue)
    while(true)
        vp->tick(GO_TO_SLEEP);
}