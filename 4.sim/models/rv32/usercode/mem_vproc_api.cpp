// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//==========================================================================
// Description:
//   Memory access API, selecting between HDL transaction or memory model
//   direct access.
//==========================================================================

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "mem_vproc_api.h"

void write_word(uint32_t byte_addr, uint32_t data, bool access_sim)
{
    //printf("write_word: addr=0x%08x data=0x%08x sim=%d\n", byte_addr, data, access_sim);
    if (access_sim)
        VWriteBE(byte_addr & ~0x3UL, data, 0xf, NORMAL_UPDATE, node);
    else
        WriteRamWord(byte_addr, data, ENDIAN, node);
}

void write_hword(uint32_t byte_addr, uint32_t data, bool access_sim)
{
    if (access_sim)
        VWriteBE(byte_addr & ~0x3UL, data << ((byte_addr & 0x2) * 8), 0x3 << (byte_addr & 0x2), NORMAL_UPDATE, node);
    else
        WriteRamHWord(byte_addr, data, ENDIAN, node);
}

void write_byte(uint32_t byte_addr, uint32_t data, bool access_sim)
{
    if (access_sim)
        VWriteBE (byte_addr & ~0x3UL, data << ((byte_addr & 0x3) * 8), 0x1 << (byte_addr & 0x3), NORMAL_UPDATE, node);
    else
        WriteRamByte(byte_addr, data, node);
}

uint32_t read_word(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;
    
    //printf("read_word: addr=0x%08x sim=%d\n", byte_addr, access_sim);

    if (access_sim)
        VRead(byte_addr & ~0x3, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(byte_addr, ENDIAN, node);

    return word;
}

uint32_t read_hword(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;

    if (access_sim)
        VRead(byte_addr & ~0x3UL, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(byte_addr & ~0x3, ENDIAN, node);

    return (word >> ((byte_addr & 0x2UL) * 8)) & 0xffff;
}

uint32_t read_byte(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;

    if (access_sim)
        VRead(byte_addr & ~0x3UL, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(byte_addr & ~0x03, ENDIAN, node);

    return (word >> ((byte_addr & 0x3UL) * 8)) & 0xff;
}

uint32_t read_instr(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;

    word = read_word(byte_addr, access_sim);

    return word;
}
