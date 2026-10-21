//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 5th July 2021
//
// Header for the ELF executable reader method of rv32i_cpu
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
// along with thiscode. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#ifndef _RV32I_CPU_ELF_H_
#define _RV32I_CPU_ELF_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#define   ELF_IDENT                               "\177ELF"

// -------------------------------------------------------------------------
// RV32 ELF constants
// -------------------------------------------------------------------------
class rv32elf_consts
{
public:
    static const uint32_t EI_NIDENT               = 16;

    static const uint32_t ET_NONE                 = 0;
    static const uint32_t ET_REL                  = 1;
    static const uint32_t ET_EXEC                 = 2;
    static const uint32_t ET_DYN                  = 3;
    static const uint32_t ET_CORE                 = 4;
    static const uint32_t ET_LOPROC               = 0xff00;
    static const uint32_t ET_HIPROC               = 0xffff;

    static const uint32_t EM_NONE                 = 0;
    static const uint32_t EM_M32                  = 1;
    static const uint32_t EM_SPARC                = 2;
    static const uint32_t EM_386                  = 3;
    static const uint32_t EM_68K                  = 4;
    static const uint32_t EM_88K                  = 5;
    static const uint32_t EM_860                  = 7;
    static const uint32_t EM_MIPS                 = 8;

    static const uint32_t EM_RISCV                = 243;

    static const uint32_t ELF_MAX_NUM_PHDR        = 16;

    static const uint32_t PF_X                    = 0x1;            /* Executable. */
    static const uint32_t PF_W                    = 0x2;            /* Writable. */
    static const uint32_t PF_R                    = 0x4;            /* Readable. */

    static const uint32_t PT_NULL                 = 0;
    static const uint32_t PT_LOAD                 = 1;
    static const uint32_t PT_DYNAMIC              = 2;
    static const uint32_t PT_INTERP               = 3;
    static const uint32_t PT_NOTE                 = 4;
    static const uint32_t PT_SHLIB                = 5;
    static const uint32_t PT_PHDR                 = 6;
    static const uint32_t PT_LOSUNW               = 0x6ffffffa;
    static const uint32_t PT_SUNWBSS              = 0x6ffffffb;
    static const uint32_t PT_SUNWSTACK            = 0x6ffffffa;
    static const uint32_t PT_HISUNW               = 0x6fffffff;
    static const uint32_t PT_LOPROC               = 0x70000000;
    static const uint32_t PT_HIPROC               = 0x7fffffff;

};

#define PrintPhdr(_P) {\
    fprintf(stderr, " p_type = %x\n p_offset = %x\n p_vaddr = %x\n p_paddr = %x\n p_filesz = %x\n p_memsz = %x\n p_flags = %x\n p_align = %x\n\n", \
                    SWAP(_P->p_type), SWAP(_P->p_offset),  SWAP(_P->p_vaddr), SWAP(_P->p_paddr),  SWAP(_P->p_filesz), SWAP(_P->p_memsz),  SWAP(_P->p_flags), SWAP(_P->p_align)); }


#define PrintPhdrNoSwap(_P) {\
    fprintf(stderr, " p_type = %x\n p_offset = %x\n p_vaddr = %x\n p_paddr = %x\n p_filesz = %x\n p_memsz = %x\n p_flags = %x\n p_align = %x\n\n", \
                    (_P->p_type), (_P->p_offset),  (_P->p_vaddr), (_P->p_paddr),  (_P->p_filesz), (_P->p_memsz),  (_P->p_flags), (_P->p_align)); }

// -------------------------------------------------------------------------
// TYPEDEFS
// -------------------------------------------------------------------------

typedef uint32_t Elf32_Addr;
typedef uint32_t Elf32_Word;
typedef uint32_t Elf32_Sword;
typedef uint32_t Elf32_Off;
typedef uint16_t Elf32_Half;

typedef struct {
    unsigned char e_ident[rv32elf_consts::EI_NIDENT] ;
    Elf32_Half e_type ;        
    Elf32_Half e_machine ;    
    Elf32_Word e_version ;
    Elf32_Addr e_entry ;
    Elf32_Off  e_phoff ;
    Elf32_Off  e_shoff;
    Elf32_Word e_flags ;
    Elf32_Half e_ehsize ;
    Elf32_Half e_phentsize ;
    Elf32_Half e_phnum ;
    Elf32_Half e_shentsize ;
    Elf32_Half e_shnum ;
    Elf32_Half e_shstrndx ;
} Elf32_Ehdr, *pElf32_Ehdr ;

typedef struct {
    Elf32_Word p_type;
    Elf32_Off  p_offset;
    Elf32_Addr p_vaddr;
    Elf32_Addr p_paddr;
    Elf32_Word p_filesz;
    Elf32_Word p_memsz;
    Elf32_Word p_flags;
    Elf32_Word p_align;
} Elf32_Phdr, *pElf32_Phdr;


#endif
