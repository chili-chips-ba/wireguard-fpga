// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   Class to configure rv32 ISS timing model
//==========================================================================

#include <stdint.h>

#include "rv32.h"

class rv32_timing_config
{
public:

    typedef struct {
        uint32_t linear_cycles;
        uint32_t jump_cycles;
        uint32_t load_cycles;
        uint32_t store_cycles;
        uint32_t trap_cycles;
        uint32_t mul_div_cycles;
        uint32_t float_cycles;
    } rv32_iss_timing_t;


private:

    // Core Timing models
    const rv32_iss_timing_t riscV         = {1, 4, 3, 3, 4, 34, 4};
    const rv32_iss_timing_t picorv32      = {4, 4, 5, 5, 4,  4, 4};
    const rv32_iss_timing_t edubos5_2stg  = {2, 2, 3, 3, 2,  2, 2};
    const rv32_iss_timing_t edubos5_3stg  = {3, 3, 4, 4, 3,  3, 3};
    const rv32_iss_timing_t ibex_mul_sgl  = {1, 2, 2, 2, 1,  1, 1};
    const rv32_iss_timing_t ibex_mul_fast = {1, 2, 2, 2, 1,  3, 1};
    const rv32_iss_timing_t ibex_mul_slow = {1, 2, 2, 2, 1, 33, 1};

public:

    // Core selection enumerated type
    enum class risc_v_core_e {
        DEFAULT,                // Default timing values
        PICORV32,               // picoRV32
        EDUBOS5STG2,            // 2 stage eduBOS5
        EDUBOS5STG3,            // 3 stage eduBOS5
        IBEXMULSGL,             // IBEX single cycle multipler/divide
        IBEXMULFAST,            // IBEX fast multi-cycle multiplier
        IBEXMULSLOW             // IBEX slow multi-cycle multiplier
    };

    // Method to configure rv32 ISS timing
    int update_timing(rv32 *iss, risc_v_core_e core = risc_v_core_e::DEFAULT)
    {
        int error = 0;

        rv32_iss_timing_t model;

        // Select timing model for that specified
        switch(core)
        {
            case risc_v_core_e::DEFAULT:     model = riscV;         break;
            case risc_v_core_e::PICORV32:    model = picorv32;      break;
            case risc_v_core_e::EDUBOS5STG2: model = edubos5_2stg;  break;
            case risc_v_core_e::EDUBOS5STG3: model = edubos5_3stg;  break;
            case risc_v_core_e::IBEXMULSGL:  model = ibex_mul_sgl;  break;
            case risc_v_core_e::IBEXMULFAST: model = ibex_mul_fast; break;
            case risc_v_core_e::IBEXMULSLOW: model = ibex_mul_slow; break;
            default:                         error++;               break;
        }

        if (!error)
        {
            error += iss->update_timing(rv32::timing_index_e::TIMING_LINEAR,  model.linear_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_JUMP,    model.jump_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_LOAD,    model.load_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_STORE,   model.store_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_TRAP,    model.trap_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_MUL_DIV, model.mul_div_cycles);
            error += iss->update_timing(rv32::timing_index_e::TIMING_FLOAT,   model.float_cycles);
        }

        return error;
    }
};
