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

int memcmp(const void *s1, const void *s2, size_t len)
{
    const unsigned char *p1 = (const unsigned char *)s1;
    const unsigned char *p2 = (const unsigned char *)s2;

    for (size_t i = 0; i < len; i++)
    {
        if (p1[i] != p2[i])
        {
            return p1[i] - p2[i];
        }
    }

    return 0;
}

size_t strlen(const char *str)
{
    size_t len = 0;

    /* Count characters until null terminator is reached */
    while (str[len] != '\0')
    {
        len++;
    }

    return len;
}