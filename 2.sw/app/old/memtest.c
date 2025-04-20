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
//   - Test of external SDRAM / DMEM
//--------------------------------------------------------------------------
// This is a bare-metal (aka non-hosted / freestanding) program!
//  For more, see:
//    - http://cs107e.github.io/guides/gcc
//    - https://godbolt.org/z/4hzWrcqW6
//    - https://popovicu.com/posts/bare-metal-programming-risc-v
//
//  Reach out to us if you desire to upgrade this project to a hosted env,
//   such as to FreeRTOS
//==========================================================================

#ifdef MEMTEST

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#include "MEMTEST.h"

/**********************************************************************
 * Function:    memTestDataBus()
 *
 * Description: Validate data bus wiring by performing a walking 1's
 *              test for a given address, as specified by the caller
 *
 * Returns:     0 if test succeeds.
 *              A non-zero result is the first pattern that failed.
 **********************************************************************/
datum memTestDataBus(volatile datum *address) {
   datum pattern;

   // Perform a walking 1's data test for the given address
   for (pattern = 1; pattern != 0; pattern <<= 1) {
      // Write the test pattern
      *address = pattern;

      // Read it back (immediately is okay for this test)
      if (*address != pattern) {
         return (pattern);
      }
   }

   return (0);
}

/**********************************************************************
 * Function:    memTestDataMask()
 *
 * Description: Validate byte-level data masks by performing a walking
 *              1's on them for a given address, selected by the caller.
 *              Also activate HalfWord combinations
 *
 * Returns:     0 if test succeeds.
 *              A non-zero result is the first data mask bit that failed.
 **********************************************************************/
int memTestDataMask(volatile datum *address) {
   volatile datum8  *address8;
   volatile datum16 *address16;

   datum8  pattern8;
   datum16 pattern16;

   int   i;

   // 1) Perform a walking 1's mask test for the given address
   pattern8 = 0xAF;
   address8 = (volatile datum8 *) address;

   for (i = 0; i < 8; i++) {
      // Write the test pattern
      *address8 = pattern8;

      // Read it back (immediately is okay for this test)
      if (*address8 != pattern8) {
         return (-i);
      }

      // go to next byte address and next data value
      address8++;

      if (i == 3) {
         pattern8 = ~pattern8;
      }
      else {
         pattern8--;
      };
   }

   // 2) Perform Half-word tests
   pattern16 = 4321;
   address16 = (volatile datum16 *) address8;

   for (i = 0; i < 8; i++) {
      // Write the test pattern
      *address16 = pattern16;

      // Read it back (immediately is okay for this test)
      if (*address16 != pattern16) {
         return (-i);
      }

      // go to next halfword address and next data value
      address16++;

      if (i == 3) {
         pattern16 = ~pattern16;
      }
      else {
         pattern16--;
      };
   }

   return (0);
}

/**********************************************************************
 * Function:    memTestAddressBus()
 *
 * Description: Test the address bus wiring in a memory region by
 *              performing a walking 1's test on the relevant bits
 *              of the address and checking for aliasing. This test
 *              will find single-bit address failures such as stuck
 *              -high, stuck-low, and shorted pins. The base address
 *              and size of the region are selected by the caller.
 *
 *              For best results, the selected base address should
 *              have enough LSB 0's to guarantee single address bit
 *              changes. For example, to test a 64-Kbyte region,
 *              select a base address on a 64-Kbyte boundary. Also,
 *              select the region size as a power-of-two--if at all
 *              possible.
 *
 * Returns:     0 if test succeeds.
 *              A non-zero result is the first address at which an
 *              aliasing problem was uncovered. By examining the
 *              contents of memory, it may be possible to gather
 *              additional information about the problem.
 **********************************************************************/
datum *memTestAddressBus(volatile datum *baseAddress, unsigned long nBytes) {
   unsigned long addressMask = (nBytes/sizeof(datum) - 1);
   unsigned long offset;
   unsigned long testOffset;

   datum pattern     = (datum) 0xAAAAAAAA;
   datum antipattern = (datum) 0x55555555;

   // Write the default pattern at each of the power-of-two offsets
   for (offset = 1; (offset & addressMask) != 0; offset <<= 1) {
      baseAddress[offset] = pattern;
   }

   // Check for address bits stuck high
   testOffset = 0;
   baseAddress[testOffset] = antipattern;

   for (offset = 1; (offset & addressMask) != 0; offset <<= 1) {
     if (baseAddress[offset] != pattern) {
        return ((datum *) &baseAddress[offset]);
     }
   }

   baseAddress[testOffset] = pattern;

   // Check for address bits stuck low or shorted
   for (testOffset = 1; (testOffset & addressMask) != 0; testOffset <<= 1) {
      baseAddress[testOffset] = antipattern;

      if (baseAddress[0] != pattern) {
         return ((datum *) &baseAddress[testOffset]);
      }

      for (offset = 1; (offset & addressMask) != 0; offset <<= 1) {
         if ((baseAddress[offset] != pattern) && (offset != testOffset)) {
            return ((datum *) &baseAddress[testOffset]);
         }
      }

      baseAddress[testOffset] = pattern;
   }

   return (0);
}

/**********************************************************************
 * Function:    memTestDevice()
 *
 * Description: Test the integrity of a physical memory device by
 *              performing an increment/decrement test over the
 *              entire region. In the process every storage bit
 *              in the device is tested as a zero and a one. The
 *              base address and the size of the region are
 *              selected by the caller.
 *
 * Returns:     0 if test succeeds.
 *              A non-zero result is the first address at which an
 *              incorrect value was read back.  By examining the
 *              contents of memory, it may be possible to gather
 *              additional information about the problem.
 **********************************************************************/
datum *memTestDevice(volatile datum *baseAddress, unsigned long nBytes){
   unsigned long offset;
   unsigned long nWords = nBytes / sizeof(datum);

   datum pattern;
   datum antipattern;

   // Fill memory with a known incrementing pattern
   for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++) {
      baseAddress[offset] = pattern;
   }

   // Check each location and invert it for the second pass
   for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++) {
      if (baseAddress[offset] != pattern) {
        return ((datum *) &baseAddress[offset]);
      }

      antipattern = ~pattern;
      baseAddress[offset] = antipattern;
   }

   // Check each location for the inverted pattern and zero it.
   for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++) {
      antipattern = ~pattern;
      if (baseAddress[offset] != antipattern) {
         return ((datum *) &baseAddress[offset]);
      }
   }
   return (0);
}

/**********************************************************************
 * Function:    memTestAll()
 *
 * Description: Full test that combines all 4 individual tests.
 *              The objectives are to:
 *               - test the RTL implementation of all relevant logic
 *               - test off-chip SDRAM component
 *               - illustrate the handshake between SW and HW
 *               - provide a foundation for development of "production"
 *                 code for SDRAM resource
 *
 * Returns:     0 if test succeeds; -1 when it fails
 **********************************************************************/
int memTestAll(unsigned char memoryType){
   volatile datum *baseAddress;
   uint32_t numBytes;

   if (memoryType == MEMORY_TYPE_SDRAM) {
      baseAddress  = SDRAM_BASE_ADDRESS_FIRST;
      numBytes     = SDRAM_NUM_BYTES;
   }
   else if(memoryType == MEMORY_TYPE_DMEM) {
      baseAddress  = DMEM_BASE_ADDRESS_FIRST;
      numBytes     = DMEM_NUM_BYTES;
   }
   else{
      return (-2);
   }

   if ((memTestDataBus   (baseAddress)           != 0) ||
       (memTestDataMask  (baseAddress)           != 0) ||
       (memTestAddressBus(baseAddress, numBytes) != 0) ||
       (memTestDevice    (baseAddress, numBytes) != 0))
   {
      return (-1);
   }
   else {
      return (0);
   }
}

/**********************************************************************
 * Function:    mem_test()
 *
 * Description: main entry point into these test
 *
 * Returns:     None
 **********************************************************************/
void mem_test() {
   int result = memTestAll(MEMORY_TYPE_SDRAM);
   if (result == 0) CSR->gpo.fld.led_off = 0b10; // Pass
}

#endif // MEMTEST

//==========================================================================
// End-of-File
//==========================================================================
