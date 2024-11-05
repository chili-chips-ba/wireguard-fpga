//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Memory access API, selecting between HDL transaction or memory model
//   direct access.
//
//==========================================================================

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "mem_vproc_api.h"

void write_word(uint32_t byte_addr, uint32_t data, bool access_sim)
{
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
        word = ReadRamHWord(byte_addr & ~0x3, ENDIAN, node);

    return (word >> ((byte_addr & 0x2UL) * 8)) & 0xffff;
}

uint32_t read_byte(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;

    if (access_sim)
        VRead(byte_addr & ~0x3UL, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamByte(byte_addr & ~0x03, node);

    return (word >> ((byte_addr & 0x3UL) * 8)) & 0xff;
}

uint32_t read_instr(uint32_t byte_addr, bool access_sim)
{
    uint32_t word;

    word = read_word(byte_addr, access_sim);

    return word;
}