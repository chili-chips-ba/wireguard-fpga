#ifndef MEMTEST_H
#define MEMTEST_H

#include <stdint.h>
#include <stddef.h>

//-----------------------------------------------------------------------
// MEMORY Resources
//-----------------------------------------------------------------------
typedef unsigned char datum8;  // for Byte-level     ( 8-bit) testing
typedef uint16_t      datum16; // for Halfword-level (16-bit) testing
typedef uint32_t      datum;   // for Word-level     (32-bit) testing

#define MEMORY_TYPE_DMEM  1
#define MEMORY_TYPE_SDRAM 0

#define DMEM_BASE_ADDRESS_FIRST   (volatile datum *) 0x10000000
#define DMEM_BASE_ADDR_LAST       (volatile datum *) 0x10007FFC
#define DMEM_NUM_BYTES            (32 * 1024)       //32KByte

#define SDRAM_BASE_ADDRESS_FIRST  (volatile datum *) 0x40000000
#define SDRAM_BASE_ADDR_LAST      (volatile datum *) 0x407FFFFC
#define SDRAM_NUM_BYTES           (8 * 1024 * 1024) //8MByte


datum  memTestDataBus   (volatile datum *address);
int    memTestDataMask  (volatile datum *address);
datum *memTestAddressBus(volatile datum *baseAddress, unsigned long nBytes);
datum *memTestDevice    (volatile datum *baseAddress, unsigned long nBytes);
int    memTestAll       (unsigned char   memoryType);

void   mem_test         ();

#endif /* MEMTEST_H */
