//==========================================================================
// Copyright (C) 2024-2026 Chili.CHIPS*ba
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
