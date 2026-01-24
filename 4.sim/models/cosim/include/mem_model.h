// SPDX-License-Identifier: GPL-3.0-or-later

//=====================================================================
//
// mem_model.h                                       Date: 2021/08/01
//
// Copyright (c) 2021 Simon Southwell
//
//=====================================================================

#ifndef _MEM_MODEL_H_
#define _MEM_MODEL_H_

#if defined(MEM_MODEL_VHDL) && !defined(VPROC_VHDL)
#define VPROC_VHDL
#endif

#if defined(MEM_MODEL_SV) && !defined(VPROC_SV)
#define VPROC_SV
#endif

#if !defined(VPROC_VHDL)
# include "string.h"
# if !defined(VPROC_SV)
# include "veriuser.h"
# include "vpi_user.h"
# endif
#endif

#include "mem.h"

#define MEM_MODEL_TF_TBL_SIZE 2

#define MEM_MODEL_ADDR_ARG          1
#define MEM_MODEL_DATA_ARG          2
#define MEM_MODEL_BE_ARG            3

#define MEM_MODEL_DEFAULT_NODE      0

#define MEM_MODEL_BE                0
#define MEM_MODEL_LE                1

#ifndef MEM_MODEL_DEFAULT_ENDIAN
#define MEM_MODEL_DEFAULT_ENDIAN    MEM_MODEL_BE
#endif

# if defined (VPROC_VHDL) || defined(VPROC_SV)

#define MEM_MODEL_TF_TBL

#define MEM_READ_PARAMS    const int  address,       int* data, const int be
#define MEM_WRITE_PARAMS   const int  address, const int  data, const int be

#define MEM_RTN_TYPE       void

# else

#define MEM_MODEL_VPI_TBL \
  {vpiSysTask, 0, "$memread",     MemRead,     0, 0, 0}, \
  {vpiSysTask, 0, "$memwrite",    MemWrite,    0, 0, 0}

#define MEM_MODEL_VPI_TBL_SIZE 2

#define MEM_READ_PARAMS   char* userdata
#define MEM_WRITE_PARAMS  char* userdata

#define MEM_RTN_TYPE int

# endif

extern MEM_RTN_TYPE MemRead     (MEM_READ_PARAMS);
extern MEM_RTN_TYPE MemWrite    (MEM_WRITE_PARAMS);

#endif
