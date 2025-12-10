// =============================================================
//
// VProc user code Verilator Simulation Control
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

#include "VerilatorSimCtrl.h"

#define SLEEPFOREVER {while(1) VTick(0x7fffffff, node);}

// I'm node 15
static const int node = 15;

// ---------------------------------------------
// MAIN ENTRY POINT FOR NODE 15
// ---------------------------------------------

extern "C" void VUserMain15 (void)
{
    VerilatorSimCtrl(node, "wave", true);

    SLEEPFOREVER;
}