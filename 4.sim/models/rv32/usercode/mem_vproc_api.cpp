
#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "mem_vproc_api.h"

void write_word(uint32_t addr, uint32_t data, bool access_sim)
{
if (access_sim)
        VWriteBE(addr & ~0x3UL, data, 0xf, NORMAL_UPDATE, node);
    else
        WriteRamWord(addr, data, ENDIAN, node);
}

void write_hword(uint32_t addr, uint32_t data, bool access_sim)
{
    if (access_sim)
        VWriteBE(addr & ~0x3UL, data << ((addr & 0x2) * 8), 0x3 << (addr & 0x2), NORMAL_UPDATE, node);
    else
        WriteRamHWord(addr, data, ENDIAN, node);
}

void write_byte(uint32_t addr, uint32_t data, bool access_sim)
{
    if (access_sim)
        VWriteBE (addr & ~0x3UL, data << ((addr & 0x3) * 8), 0x1 << (addr & 0x3), NORMAL_UPDATE, node);
    else
        WriteRamByte(addr, data, ENDIAN, node);
}

uint32_t read_word(uint32_t addr, bool access_sim)
{
    uint32_t word;

    if (access_sim)
        VRead(addr & ~0x3, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(addr, ENDIAN, node);
    
    return word;
}

uint32_t read_hword(uint32_t addr, bool access_sim)
{
    uint32_t word;
    
    if (access_sim)
        VRead(addr & ~0x3UL, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(addr & ~0x3, ENDIAN, node);

    return (word >> ((addr & 0x2UL) * 8)) & 0xffff;
}

uint32_t read_byte(uint32_t addr, bool access_sim)
{
    uint32_t word;

    if (access_sim)
        VRead(addr & ~0x3UL, &word, NORMAL_UPDATE, node);
    else
        word = ReadRamWord(addr & ~0x03, ENDIAN, node);

    return (word >> ((addr & 0x3UL) * 8)) & 0xff;
}

uint32_t read_instr(uint32_t addr, bool access_sim)
{
    uint32_t word;

    word = read_word(addr, access_sim);

    return word;
}