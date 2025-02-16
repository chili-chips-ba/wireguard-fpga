// ====================================================================
//
// SystemVerilog side mem_model
//
// Copyright (c) 2024 Simon Southwell.
//
// This file is part of mem_model.
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
// ====================================================================

// The SystemVerilog mem_model HDL is the same as the Verilog, 
// with MEM_MODEL_SV defined to select DPI-C over PLI

`timescale 1ps / 1ps

`define MEM_MODEL_SV

// verilator lint_save
// verilator lint_off UNUSEDSIGNAL
// verilator lint_off PINCONNECTEMPTY
// verilator lint_off BLKSEQ
// verilator lint_off GENUNNAMED
// verilator lint_off DECLFILENAME
`include "f_mem_model.v"
// verilator lint_restore
