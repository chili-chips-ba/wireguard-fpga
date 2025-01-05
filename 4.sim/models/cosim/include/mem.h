//=====================================================================
//
// mem.h                                              Date: 2021/08/01 
//
// Copyright (c) 2021 Simon Southwell
//
//=====================================================================

#ifndef _MEM_H_
#define _MEM_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

// -------------------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------------------

#define MEM_VERSION_MAJOR   1
#define MEM_VERSION_MINOR   0
#define MEM_VERSION_PATCH   0

#define TABLESIZE      (4096UL)
#define TABLEMASK      (TABLESIZE-1)

#define MEM_BAD_STATUS  1
#define MEM_GOOD_STATUS 0

#ifndef VP_MAX_NODES
#define VP_MAX_NODES 64
#endif

#ifdef DEBUG
# ifndef Debugprintf
# define Debugprintf printf
# endif
#else
#define Debugprintf(__VA_ARGS_) {}
#endif

// -------------------------------------------------------------------------
// TYPEDEFS
// -------------------------------------------------------------------------

typedef struct {
    char** p;
    uint64_t addr;
    bool   valid;
} PrimaryTbl_t, *pPrimaryTbl_t;

typedef uint16_t  PktData_t;
typedef uint16_t* pPktData_t;

// -------------------------------------------------------------------------
// PROTOTYPES
// -------------------------------------------------------------------------

extern void     InitialiseMem       (int node);

extern void     WriteRamByteBlock   (const uint64_t addr, const PktData_t* const data, const int fbe, const int lbe, const int length, const uint32_t node);
extern int      ReadRamByteBlock    (const uint64_t addr, PktData_t* const data, const int length, const uint32_t node);
extern void     WriteRamByte        (const uint64_t addr, const uint32_t data, const uint32_t node);
extern void     WriteRamHWord       (const uint64_t addr, const uint32_t data, const int little_endian, const uint32_t node);
extern void     WriteRamWord        (const uint64_t addr, const uint32_t data, const int little_endian, const uint32_t node);
extern void     WriteRamDWord       (const uint64_t addr, const uint64_t data, const int little_endian, const uint32_t node);
extern uint32_t ReadRamByte         (const uint64_t addr, const uint32_t node);
extern uint32_t ReadRamHWord        (const uint64_t addr, const int little_endian, const uint32_t node);
extern uint32_t ReadRamWord         (const uint64_t addr, const int little_endian, const uint32_t node);
extern uint64_t ReadRamDWord        (const uint64_t addr, const int little_endian, const uint32_t node);
#endif
