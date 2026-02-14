// SPDX-License-Identifier: GPL-3.0-or-later

// ====================================================================
//
// SystemVerilog side Virtual Processor, for running host
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

// The SystemVerilog VProc HDL is the same as the Verilog, 
// with VPROC_SV defined to select DPI-C over VPI

`define VPROC_SV

`include "f_VProc.v"
