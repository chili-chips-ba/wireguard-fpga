// SPDX-License-Identifier: GPL-3.0-or-later

//=====================================================================
//
// VSched_pli.h                                       Date: 2004/12/13
//
// Copyright (c) 2004-2024 Simon Southwell.
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
//=====================================================================
//
// VSched function's export prototypes
//
//=====================================================================

#include <string.h>

#ifndef _VSCHED_PLI_H_
#define _VSCHED_PLI_H_
#endif

// VHPI implies VHDL
#ifdef VPROC_VHDL_VHPI
# ifndef VPROC_VHDL
#define VPROC_VHDL
# endif
#endif

// VERILATOR implies SystemVerilog
#ifdef VERILATOR
# ifndef VPROC_SV
# define VPROC_SV
# endif
#endif

// NVC, GHDL or SystemVerilog imples no PLI/VPI
#if defined(NVC) || defined (GHDL) || defined (VPROC_SV)
#define VPROC_NO_PLI
#endif

// Define a string of the configured programming interface
#if !defined(VPROC_VHDL) && !defined(VPROC_SV)
#  define PLI_STRING "VPI"
#else
# ifdef VPROC_VHDL_VHPI
#  define PLI_STRING "VHPI"
# else
#  if !defined(VPROC_NO_PLI)
#   define PLI_STRING "FLI"
#  else
#   if defined (VPROC_SV)
#    define PLI_STRING "DPI-C"
#   else
#    define PLI_STRING "VHPIDIRECT"
#   endif
#  endif
# endif
#endif

#if !defined(VPROC_NO_PLI)
#include "vpi_user.h"
#endif

#ifdef INCL_VLOG_MEM_MODEL
#include "mem_model.h"
#endif

# if defined(VPROC_VHDL) || defined (VPROC_SV)

#  ifdef VPROC_VHDL_VHPI

#   ifdef DEBUG
#   define debug_io_printf vhpi_printf
#   else
#   define debug_io_printf //
#   endif

#include <vhpi_user.h>

#define VINIT_PARAMS       const struct vhpiCbDataS* cb
#define VSCHED_PARAMS      const struct vhpiCbDataS* cb
#define VPROCUSER_PARAMS   const struct vhpiCbDataS* cb
#define VIRQ_PARAMS        const struct vhpiCbDataS* cb
#define VACCESS_PARAMS     const struct vhpiCbDataS* cb
#define VHALT_PARAMS       int, int

#define VINIT_NUM_ARGS     1
#define VSCHED_NUM_ARGS    7
#define VPROCUSER_NUM_ARGS 2
#define VIRQ_NUM_ARGS      2
#define VACCESS_NUM_ARGS   4

#define VPROC_RTN_TYPE     void

#  else

#   ifdef DEBUG
#    ifdef VPROC_SV
#    define debug_io_printf printf
#    else
#    define debug_io_printf mti_PrintFormatted
#    endif
#   else
#   define debug_io_printf //
#   endif

#define VINIT_PARAMS       int  node
#define VSCHED_PARAMS      int  node, int Interrupt, int VPDataIn, int* VPDataOut, int* VPAddr, int* VPRw, int* VPTicks
#define VPROCUSER_PARAMS   int  node, int value
#define VIRQ_PARAMS        int  node, int value
#define VACCESS_PARAMS     int  node, int idx, int VPDataIn, int* VPDataOut
#define VHALT_PARAMS       int, int

#define VPROC_RTN_TYPE     void

#  endif

# else

#  ifdef DEBUG
#   define debug_io_printf vpi_printf
#  else
#   define debug_io_printf //
#  endif

#define VPROC_VPI_TBL {vpiSysTask, 0, "$vinit",     VInit,     0, 0, 0}, \
                      {vpiSysTask, 0, "$vsched",    VSched,    0, 0, 0}, \
                      {vpiSysTask, 0, "$vaccess",   VAccess,   0, 0, 0}, \
                      {vpiSysTask, 0, "$vprocuser", VProcUser, 0, 0, 0}, \
                      {vpiSysTask, 0, "$virq",      VIrq,      0, 0, 0},

#define VINIT_PARAMS      char* userdata
#define VSCHED_PARAMS     char* userdata
#define VPROCUSER_PARAMS  char* userdata
#define VIRQ_PARAMS       char* userdata
#define VACCESS_PARAMS    char* userdata
#define VHALT_PARAMS      int data, int reason

#define VPROC_RTN_TYPE    int

extern int getArgs    (vpiHandle taskHdl, int value[]);
extern int updateArgs (vpiHandle taskHdl, int value[]);

# endif

extern VPROC_RTN_TYPE VInit     (VINIT_PARAMS);
extern VPROC_RTN_TYPE VSched    (VSCHED_PARAMS);
extern VPROC_RTN_TYPE VProcUser (VPROCUSER_PARAMS);
extern VPROC_RTN_TYPE VIrq      (VIRQ_PARAMS);
extern VPROC_RTN_TYPE VAccess   (VACCESS_PARAMS);
extern int            VHalt     (VHALT_PARAMS);

