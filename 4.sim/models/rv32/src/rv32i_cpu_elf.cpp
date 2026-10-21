//=============================================================
//
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 5th July 2021
//
// ELF executable reader method of rv32i_cpu
//
// This file is part of the RISC-V instruction set simulator
// (rv32i_cpu)
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdint>

#include "rv32i_cpu_elf.h"
#include "rv32i_cpu.h"

// ----------------------------------
// read_elf()
//
// Read ELF formatted executable from
// filename, and load to memory
//
int rv32i_cpu::read_elf (const char * const filename)
{
    unsigned    i;
    int         c;
    uint32_t    pcount, bytecount = 0;
    uint32_t    word;
    pElf32_Ehdr h;
    pElf32_Phdr h2[rv32elf_consts::ELF_MAX_NUM_PHDR];
    char        buf[sizeof(Elf32_Ehdr)];
    char        buf2[sizeof(Elf32_Phdr)*rv32elf_consts::ELF_MAX_NUM_PHDR];
    const char* ptr;
    FILE*       elf_fp;
    bool        access_fault = false;


    // Open program file ready for loading
    if ((elf_fp = fopen(filename, "rb")) == NULL)
    {
        fprintf(stderr, "*** ERROR: read_elf(): Unable to open file %s for reading\n", filename); 
        return USER_ERROR;
    }

    // Read elf header
    h = (pElf32_Ehdr) buf;
    for (i = 0; i < sizeof(Elf32_Ehdr); i++)
    {
        buf[i] = fgetc(elf_fp);
        bytecount++;
        if (buf[i] == EOF)
        {
            fprintf(stderr, "*** ERROR: read_elf(): unexpected EOF\n");
            return USER_ERROR;
        }
    }

    //LCOV_EXCL_START
    // Check some things
    ptr= ELF_IDENT;
    for (i = 0; i < 4; i++)
    {
        if (h->e_ident[i] != ptr[i])
        {
            fprintf(stderr, "*** ERROR: read_elf(): not an ELF file\n");
            return USER_ERROR;
        }
    }

    if (h->e_type != rv32elf_consts::ET_EXEC)
    {
        fprintf(stderr, "*** ERROR: read_elf(): not an executable ELF file\n");
        return USER_ERROR;
    }

    if (h->e_machine != rv32elf_consts::EM_RISCV)
    {
        fprintf(stderr, "*** ERROR: read_elf(): not a RISC-V ELF file (e_machine=0x%03x)\n", h->e_machine);
        return USER_ERROR;
    }

    if (h->e_phnum > rv32elf_consts::ELF_MAX_NUM_PHDR)
    {
        fprintf(stderr, "*** ERROR: read_elf(): Number of Phdr (%d) exceeds maximum supported (%d)\n", h->e_phnum, rv32elf_consts::ELF_MAX_NUM_PHDR);
        return USER_ERROR;
    }
    //LCOV_EXCL_STOP

    // Read program headers
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        for (i = 0; i < sizeof(Elf32_Phdr); i++)
        {
            c = fgetc(elf_fp);
            if (c == EOF)
            {
                fprintf(stderr, "*** ERROR: read_elf(): unexpected EOF\n");                         
                return USER_ERROR;                                                     
            }
            buf2[i+(pcount * sizeof(Elf32_Phdr))] = c;
            bytecount++;
        }
    }

    // Load text/data segments
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        h2[pcount] = (pElf32_Phdr) &buf2[pcount * sizeof(Elf32_Phdr)];

        // If not a load segment skip it
        if (h2[pcount]->p_type != rv32elf_consts::PT_LOAD)
        {
            continue;
        }
        else
        {
            // Segment offsets in file can be out of order in memory, so always rewind
            // file top start from the beginning.
            rewind(elf_fp);
        }

        // Gobble bytes until section start
        for (bytecount = 0; bytecount < h2[pcount]->p_offset; bytecount++)
        {
            c = fgetc(elf_fp);
            if (c == EOF) {
                fprintf(stderr, "*** ERROR: read_elf(): unexpected EOF\n");                         
                return USER_ERROR;                                                      
            }
        }

        // Check we can load the segment to memory
        if (((uint64_t)h2[pcount]->p_vaddr + (uint64_t)h2[pcount]->p_memsz) >= (1ULL << MEM_SIZE_BITS))
        {
            fprintf(stderr, "*** ERROR: read_elf(): segment memory footprint outside of internal memory range\n"); 
            return USER_ERROR;                                                                        
        }

        // For p_filesz bytes ...
        i = (bytecount - h2[pcount]->p_offset);
        word = 0;
        uint32_t num_seg_bytes = h2[pcount]->p_offset + h2[pcount]->p_filesz;
        for (; bytecount < num_seg_bytes; bytecount++)
        {
            if ((c = fgetc(elf_fp)) == EOF)
            {
                fprintf(stderr, "*** ERROR: read_elf(): unexpected EOF\n");                          
                return USER_ERROR;                                                      
            }

            // Little endian
            word |= (c << ((bytecount & 3) * 8));

            if ((bytecount&3) == 3 || (num_seg_bytes - bytecount) == 1)
            {
                write_mem(h2[pcount]->p_vaddr + i, word, MEM_WR_ACCESS_INSTR, access_fault);
                i+=4;
                word = 0;

                if (access_fault)
                {
                    fprintf(stderr, "*** ERROR: read_elf(): memory access fault loading program\n");
                    return USER_ERROR;
                }
            }
        }
    }

    return NO_ERROR;
}

// ----------------------------------
// read_binary()
//
// Read raw binary executable from
// filename, and load to memory at
// load_addr
//
int rv32i_cpu::read_binary(const char *filename, const uint32_t load_addr)
{
    int         error = 0;
    FILE*       bin_fp;
    char        buf[4];
    int         c;
    uint32_t*   word = (uint32_t*)buf;
    bool        fault;

    if (load_addr & 0x3)
    {
        fprintf(stderr, "*** ERROR: read_binary(): load address (0x%08x) not word aligned\n", load_addr); 
        return USER_ERROR;
    }

    // Open program file ready for loading
    if ((bin_fp = fopen(filename, "rb")) == NULL)
    {
        fprintf(stderr, "***ERROR: read_binary(): Unable to open file %s for reading\n", filename); 
        return USER_ERROR;
    }

    for (int offset = 0; true; offset++)
    {
        // Read bytes from file until end-of-file
        if ((c = fgetc(bin_fp)) != EOF)
        {
            // Construct word
            buf[offset & 0x3] = c;

            // On last byte of word, write word to memory
            if ((offset & 0x3) == 3)
            {
                write_mem(load_addr + (offset & ~0x3U), *word, MEM_WR_ACCESS_INSTR, fault);
            }
        }
        else
        {
            // Flush any partial words
            if (offset & 0x3)
            {
                write_mem(load_addr + (offset & ~0x3U), *word & ((1 << (load_addr & 0x3)*8)-1), MEM_WR_ACCESS_INSTR, fault);
            }

            // Exit loop
            break;
        }
    }

    return NO_ERROR;
}