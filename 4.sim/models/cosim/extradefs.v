// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * User defined Extra definitions for verilog compilation
 *
 * Copyright (c) 2004-2024 Simon Southwell. 
 *
 * This file is part of VProc.
 *
 * VProc is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * VProc is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with VProc. If not, see <http://www.gnu.org/licenses/>.
 */

`ifndef external_timescale

 `ifdef resol_10ps
 `define VProcTimeScale  `timescale 1 ps / 10 ps
 `else
 `define VProcTimeScale  `timescale 1 ps / 1 ps
 `endif

`define PSEC   1
`define NSEC   1000
`define USEC   1000000
`define MSEC   1000000000

`endif





