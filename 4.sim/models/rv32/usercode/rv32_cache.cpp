// SPDX-License-Identifier: GPL-3.0-or-later

//=============================================================
//
// Copyright (c) 2024 Simon Southwell. All rights reserved.
//
// Date: 15th November 2024
//
// This file is part of the rv32 instruction set simulator.
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
//=============================================================

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "rv32_cache.h"

// -------------------------------------------------------------------------
// rv32_cache()
//
// Constructor for rv32_cache class. Validates parameters, allocates some
// space for the cache lines and invalidates the cache, ready for use.
//
// -------------------------------------------------------------------------

rv32_cache::rv32_cache (const int bytes_per_line,
                        const int num_of_ways,
                        const int num_of_sets,
                        const uint32_t cache_base_addr,
                        const uint32_t upper_limit)
{
    // Check bytes_per_line is a valid value
    switch (bytes_per_line)
    {
    case 4:
    case 8:
    case 16:
        line_width = bytes_per_line;
        break;
    default:
        fprintf(stderr, "***ERROR: invalid cache line byte width(%d)\n", bytes_per_line);
        exit(RV32_USER_ERROR);
        break;
    }

    // Validate the specified number of ways
    if (num_of_ways == 1 || num_of_ways == 2)
    {
        ways = num_of_ways;
    }
    else
    {
        fprintf(stderr, "***ERROR: invalid cache ways (%d)\n", num_of_ways);
        exit(RV32_USER_ERROR);
    }

    switch(num_of_sets)
    {
    case 128:
    case 256:
    case 512:
    case 1024:
        sets = num_of_sets;
        break;
    default:
        fprintf(stderr, "***ERROR: invalid cache sets (%d)\n", num_of_sets);
        exit(RV32_USER_ERROR);
    }

    // Generate a mask to align region boundaries to a cache set (in bytes)
    uint32_t mask;

    switch(sets * line_width) {
    case 512:   mask = 0xfffffe00UL; break;
    case 1024:  mask = 0xfffffc00UL; break;
    case 2048:  mask = 0xfffff800UL; break;
    case 4096:  mask = 0xfffff000UL; break;
    case 8192:  mask = 0xffffe000UL; break;
    case 16384: mask = 0xffffc000UL; break;
    }

    base_addr = cache_base_addr   & mask;
    limit     = (upper_limit + 1) & mask;

    // Invalidate the cache lines
    rv32_cache_invalidate();

    // Use the first way to start off with
    for (int idx = 0; idx < RV32_MAX_SETS; idx++)
    {
        next_way_update[idx] = 0;
    }
}

// -------------------------------------------------------------------------
// rv32_cache_invalidate()
//
// Invalidates the entire cache, effectively clearing it's contents
//
// -------------------------------------------------------------------------

void rv32_cache::rv32_cache_invalidate (void)
{
    for (int widx = 0; widx < ways; widx++)
    {
        for (int sidx = 0; sidx < sets; sidx++)
        {
            m[widx][sidx].valid = false;
        }
    }
}

// -------------------------------------------------------------------------
// rv32_cache_access()
//
// All reads (and only reads) to cached regions should call this function
// with the read address. Returns a non-zero value of a hit.
//
// -------------------------------------------------------------------------

int rv32_cache::rv32_cache_access (const uint32_t rd_byte_addr)
{

    // Check that the address lies in a cacheable region, and return
    // if it isn't with a cache miss.
    if (rd_byte_addr < base_addr || rd_byte_addr >= limit)
    {
        return RV32_CACHE_MISS;
    }

    int hit = RV32_CACHE_MISS;

    // Normalise the address to be for line sized words
    int line_addr = rd_byte_addr / line_width;

    // Get byte offset within the line for the read address
    int byte_addr = rd_byte_addr % line_width;

    // Get the line offset within a set for the address
    int line_offset = line_addr % sets;

    // Check for a hit in way 1
    if (m[0][line_offset].valid && m[0][line_offset].addr == line_addr)
    {
        hit = RV32_CACHE_HIT_WAY1;
    }
    // Check way 2 if configured
    else if (ways == 2 && m[1][line_offset].valid && m[1][line_offset].addr == line_addr)
    {
        hit = RV32_CACHE_HIT_WAY2;
    }

    // Update cache if missed
    if (!hit)
    {
        // Mark the line as valid, and store the address bits associated with this line
        m[next_way_update[line_offset]][line_offset].valid = true;
        m[next_way_update[line_offset]][line_offset].addr  = line_addr;

        // Choose which way to update next time (if two way cache)
        if (ways == 2)
        {
            next_way_update[line_offset] = (next_way_update[line_offset] == 1) ? 0 : 1;
        }
    }

    return hit;
}

