//=============================================================
//
// Copyright (c) 2024 Simon Southwell. All rights reserved.
//
// Date: 15th November 2024
//
// This file is part of the rv32 instruction set simulator.
//
// The file is free software: you can redistribute it and/or modify
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
// along with rv32. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#ifndef _RV32_CACHE_H_
#define _RV32_CACHE_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdlib>

// -------------------------------------------------------------------------
// Cache definitions
// -------------------------------------------------------------------------

#define RV32_USER_ERROR              1

#define RV32_INVALIDATE_DCACHE       1
#define RV32_INVALIDATE_ICACHE       2

#define RV32_CACHE_DEFAULT_BASE      0x00000000U
#define RV32_CACHE_DEFAULT_DLIMIT    0x0fffffffU
#define RV32_CACHE_DEFAULT_ILIMIT    0x7fffffffU
#define RV32_CACHE_DEFAULT_SETS      256
#define RV32_CACHE_DEFAULT_WAYS      2
#define RV32_CACHE_DEFAULT_LINE      8

#define RV32_MAX_NUM_CACHES          2
#define RV32_MAX_BYTES               16
#define RV32_MAX_WAYS                2
#define RV32_MAX_SETS                1024

#define RV32_SLOW_MEM_PENALTY        4      

#define RV32_CACHE_MISS              0
#define RV32_CACHE_HIT_WAY1          1
#define RV32_CACHE_HIT_WAY2          2

// -------------------------------------------------------------------------
// TYPEDEFS
// -------------------------------------------------------------------------

typedef struct {
    uint32_t addr;
    int      valid;
} rv32_cache_line_t;

typedef rv32_cache_line_t rv32_cache_set_t [RV32_MAX_WAYS][RV32_MAX_SETS];

// -------------------------------------------------------------------------
// Class definition for LM32 cache
// -------------------------------------------------------------------------

class rv32_cache {

public:
    // Constructor
         rv32_cache            (const int      bytes_per_line = RV32_CACHE_DEFAULT_LINE,
                                const int      num_of_ways    = RV32_CACHE_DEFAULT_WAYS,
                                const int      num_of_sets    = RV32_CACHE_DEFAULT_SETS,
                                const uint32_t base_addr      = RV32_CACHE_DEFAULT_BASE,
                                const uint32_t limit          = RV32_CACHE_DEFAULT_ILIMIT);

    // Cache access method
    int  rv32_cache_access     (const uint32_t in_addr);

    // Invalidate cache method
    void rv32_cache_invalidate (void);

    // Return configured line width (in bytes)
    inline int get_line_width  (void) { return line_width; };


private:

    // Internal cache state
    int              line_width;                        // Number of bytes in a cache line (4, 8 or 16)
    int              ways;                              // Size of associativity, or ways (1 or 2)
    int              sets;                              // Size of set lines (128, 256, 512 or 1K)
    int              next_way_update[RV32_MAX_SETS];    // Flag per line in a set to indicate which way is next for update
    uint32_t         base_addr;                         // Base address of cached region
    uint32_t         limit;                             // Upper limit of cached region
    rv32_cache_set_t m;                                 // Cache line sets
};

#endif
