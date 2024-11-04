
#ifndef _MEM_VPROC_API_H_
#define _MEM_VPROC_API_H_

#include <cstdio>
#include <cstdlib>
#include <cstdint>

extern "C" {
#include "VUser.h"
#include "mem.h"
}

// Define VProc call normal and delta values
#define NORMAL_UPDATE                           0
#define DELTA_UPDATE                            1
#define BIG_ENDIAN                              0
#define LITTLE_ENDIAN                           1

#ifndef ENDIAN
#define ENDIAN                                   LITTLE_ENDIAN
#endif                                    

extern int      node;

extern void     write_word  (uint32_t addr, uint32_t data, bool access_sim = false);
extern void     write_hword (uint32_t addr, uint32_t data, bool access_sim = false);
extern void     write_byte  (uint32_t addr, uint32_t data, bool access_sim = false);
extern uint32_t read_word   (uint32_t addr, bool access_sim = false);
extern uint32_t read_instr  (uint32_t addr, bool access_sim = false);
extern uint32_t read_hword  (uint32_t addr, bool access_sim = false);
extern uint32_t read_byte   (uint32_t addr, bool access_sim = false);

#endif


