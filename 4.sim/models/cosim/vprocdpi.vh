// SPDX-License-Identifier: GPL-3.0-or-later

// ====================================================================
//
// Verilog side Virtual Processor, for running host
// programs as control in simulation.
//
// Copyright (c) 2024 Simon Southwell.
//
// This file is part of VProc.
//
// VProc is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// VProc is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with VProc. If not, see <http://www.gnu.org/licenses/>.
//
// ====================================================================

// Import DPI-C fuctions

import "DPI-C" function void VInit     (input  int node);

import "DPI-C" function void VSched    (input  int node, 
                                        input  int Interrupt,
                                        input  int VPDataIn, 
                                        output int VPDataOut,
                                        output int VPAddr, 
                                        output int VPRw,
                                        output int VPTicks);
                                        
import "DPI-C" function void VAccess   (input  int node,
                                        input  int idx,
                                        input  int VPDataIn,
                                        output int VPDataOut);
                                        
import "DPI-C" function void VProcUser (input  int  node, input int value);

import "DPI-C" function void VIrq      (input  int  node, input int irq);
