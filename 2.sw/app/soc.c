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
//   - A collection of common useful routines, including elements from the
//      missing STDLIB
//
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

#include "soc.h"

/**********************************************************************
 * Relevant parts of STDLIB which, due to bare-metal nature of this
 *  project, have to be provided separately
 **********************************************************************/
void *memcpy (void *dest, void *src, uint32_t n) {
   for (uint32_t i = 0; i < n; i++) {
      ((char*)dest)[i] = ((char*)src)[i];
   }
}

/**********************************************************************
 * Description: Compares two strings. Returns 0 if strings are equal
 **********************************************************************/
int strcmp(const char *s1, const char *s2) {
   while ((*s1 == *s2) && *s1) { ++s1; ++s2; }
   return ((int)(unsigned char) *s1) - ((int)(unsigned char) *s2);
}


/**********************************************************************
 * Description: Multiplies input by 3
 **********************************************************************/
uint32_t mul3 (uint32_t i) {
   uint32_t m;
   m = i << 2; //x4
   m = m - i;  //-1 = x3
   return m;
}

//==========================================================================
// End-of-File
//==========================================================================
