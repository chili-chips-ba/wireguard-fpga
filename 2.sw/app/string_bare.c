// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description:
//   Bare metal string library
//==========================================================================

#include "string_bare.h"

__attribute__((used)) void *memset(void *dest, int value, size_t len) {
   unsigned char *d = (unsigned char *)dest;
   unsigned char v = (unsigned char)value;

   /* Fill memory byte by byte */
   for (size_t i = 0; i < len; i++) {
      d[i] = v;
   }

   return dest;
}

__attribute__((used)) void *memcpy(void *dest, const void *src, size_t len) {

   unsigned char *d = (unsigned char *)dest;
   const unsigned char *s = (const unsigned char *)src;

   /* Copy memory byte by byte */
   for (size_t i = 0; i < len; i++) {
      d[i] = s[i];
   }

   return dest;
}

int memcmp(const void *s1, const void *s2, size_t len) {
   const unsigned char *p1 = (const unsigned char *)s1;
   const unsigned char *p2 = (const unsigned char *)s2;

   for (size_t i = 0; i < len; i++) {
      if (p1[i] != p2[i]) {
         return p1[i] - p2[i];
      }
   }

   return 0;
}

size_t strlen(const char *str) {
   size_t len = 0;

   /* Count characters until null terminator is reached */
   while (str[len] != '\0')
   {
      len++;
   }

   return len;
}

int strcmp(const void *s1, const void *s2) {
   return memcmp(s1, s2, strlen((const char *)s1));
}

uint8_t str_parse_uint32(const char* str, uint32_t* value, uint32_t min, uint32_t max) {
   uint32_t val = 0;
   if (*str == '\n' || *str == '\0') {
      return 0; // Empty string
   }
   while (*str != '\n' && *str != '\0') {
      if (*str >= '0' && *str <= '9') {
         val = val * 10 + (*str - '0');
      } else {
         return 0; // Invalid character
      }
      str++;
   }
   if (val < min || val > max) {
      return 0; // Out of range
   }
   *value = val;
   return 1; // Success
}

uint8_t str_parse_uint8(const char* str, uint8_t* value, uint8_t min, uint8_t max) {
   uint32_t val = 0;
   if (str_parse_uint32(str, &val, min, max) == 0) {
      return 0; // Failed to parse or out of range
   }
   *value = (uint8_t)val;
   return 1; // Success
}

uint8_t str_parse_hex(const char* str, uint32_t* value, uint32_t min, uint32_t max) {
   uint32_t val = 0;
   if (*str == '\n' || *str == '\0') {
      return 0; // Empty string
   }
   while (*str != '\n' && *str != '\0') {
      if (*str >= '0' && *str <= '9') {
         val = (val << 4) | (*str - '0');
      } else if (*str >= 'A' && *str <= 'F') {
         val = (val << 4) | (*str - 'A' + 10);
      } else if (*str >= 'a' && *str <= 'f') {
         val = (val << 4) | (*str - 'a' + 10);
      } else {
         return 0; // Invalid character
      }
      str++;
   }
   if (val < min || val > max) {
      return 0; // Out of range
   }
   *value = val;
   return 1; // Success
}
