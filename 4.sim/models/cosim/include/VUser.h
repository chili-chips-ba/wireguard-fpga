//=====================================================================
//
// VUser.h                                            Date: 2005/01/10
//
// Copyright (c) 2005-2024 Simon Southwell.
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

#ifndef _VUSER_H_
#define _VUSER_H_

#include "VProc.h"
#include "VSched_pli.h"

#define DELTA_CYCLE     -1
#define GO_TO_SLEEP     0x7fffffff

#define MAX_INT_LEVEL   7
#define MIN_INT_LEVEL   1

#define MAXBURSTLEN     4096

// When compiling in windows (32- or 64-bit) ...
#ifdef WIN32
# include <windows.h>

// Map Linux dynamic loading calls to Windows equivalents
# define dlsym GetProcAddress
# define dlopen(_dll, _args) {LoadLibrary(_dll)}
# define dlerror() ""
# define dlclose FreeLibrary

// Define a type to cast node in print statements to avoid warnings
# ifdef _WIN64
typedef long long nodecast_t;
# else
typedef long      nodecast_t;
# endif
#else
typedef long      nodecast_t;
#endif

// Needed for Icarus and Verilator
# ifndef RTLD_DEFAULT
# define RTLD_DEFAULT ((void *) 0)
# endif

// Pointer to pthread_create compatible function
typedef void *(*pThreadFunc_t)(void *);

// VUser function prototypes for API

extern int  VWrite        (const unsigned      addr,  const unsigned  data, const int      delta,   const unsigned node);
extern int  VWriteBE      (const unsigned      addr,  const unsigned  data, const unsigned be,      const int      delta, const unsigned node);
extern int  VRead         (const unsigned      addr,  unsigned       *data, const int      delta,   const unsigned node);
extern int  VBurstWrite   (const unsigned      addr,  void           *data, const unsigned wordlen, const unsigned node);
extern int  VBurstWriteBE (const unsigned      addr,  void           *data, const unsigned wordlen, const unsigned fbe, const unsigned lbe, const unsigned node);
extern int  VBurstRead    (const unsigned      addr,  void           *data, const unsigned wordlen, const unsigned node);
extern int  VTick         (const unsigned      ticks, const unsigned  node);
extern void VRegUser      (const pVUserCB_t    func,  const unsigned  node);
extern void VRegIrq       (const pVUserIrqCB_t func,  const unsigned  node);

// *** Deprecated in favour of VRegIrq ***/
extern void VRegInterrupt (const int           level, const pVUserInt_t  func, const unsigned node);

// Internal function for Python interface
extern void VRegIrqPy     (const pPyIrqCB_t    func,  const unsigned  node);

// VUser function prototype for VInit in VSched.c
extern int  VUser         (const unsigned   node);

#if defined(VPROC_VHDL) || defined (ICARUS) || defined (VPROC_SV)
# define VPrint(...) printf (__VA_ARGS__)
#else
# define VPrint(...) vpi_printf (__VA_ARGS__)
#endif

#ifdef DEBUG
#define DebugVPrint VPrint
#else
#define DebugVPrint //
#endif

// Pointer to VUserMain function type definition
typedef void (*pVUserMain_t)(void);

#endif
