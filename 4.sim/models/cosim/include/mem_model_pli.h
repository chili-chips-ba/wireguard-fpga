// SPDX-License-Identifier: GPL-3.0-or-later

//=====================================================================
//
// mem_model_pli.h                                     Date: 2024/09/27
//
// Copyright (c) 2024 Simon Southwell
//
//=====================================================================

#ifndef _MEM_MODEL_PLI_H_
#define _MEM_MODEL_PLI_H_

# ifdef MEM_MODEL_INTERNAL_PLI

// -------------------------------------------------------------------------
// register_vpi_tasks()
//
// Registers the mem_model system tasks for VPI
// -------------------------------------------------------------------------

static void register_vpi_tasks()
{
    s_vpi_systf_data data[] = {
       MEM_MODEL_VPI_TBL
      };


    for (int idx= 0; idx < sizeof(data)/sizeof(s_vpi_systf_data); idx++)
    {
        vpi_register_systf(&data[idx]);
    }
}

// -------------------------------------------------------------------------
// Contains a zero-terminated list of functions that have
// to be called at startup
// -------------------------------------------------------------------------

void (*vlog_startup_routines[])() =
{
    register_vpi_tasks,
    0
};

# endif

#endif
