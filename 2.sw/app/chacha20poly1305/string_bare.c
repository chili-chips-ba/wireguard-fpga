/**
 * @file string_bare.c
 * @brief Bare metal string.c implementation
 */

#include "string_bare.h"

void *memset(void *dest, int value, size_t len)
{
    unsigned char *d = (unsigned char *)dest;
    unsigned char v = (unsigned char)value;

    /* Fill memory byte by byte */
    for (size_t i = 0; i < len; i++)
    {
        d[i] = v;
    }

    return dest;
}

void *memcpy(void *dest, const void *src, size_t len)
{
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;

    /* Copy memory byte by byte */
    for (size_t i = 0; i < len; i++)
    {
        d[i] = s[i];
    }

    return dest;
}