/**
 * @file string_bare.h
 * @brief Bare metal string.h implementation
 */

#ifndef STRING_BARE_H
#define STRING_BARE_H

#include <stddef.h> /* For size_t */

/**
 * @brief Fill memory with a constant byte
 *
 * @param dest Pointer to the block of memory to fill
 * @param value Value to be set (converted to unsigned char)
 * @param len Number of bytes to be set
 * @return void* A pointer to the memory area dest
 */
void *memset(void *dest, int value, size_t len);

/**
 * @brief Copy memory area
 *
 * @param dest Pointer to the destination array where content is to be copied
 * @param src Pointer to the source of data to be copied
 * @param len Number of bytes to copy
 * @return void* A pointer to the destination array
 */
void *memcpy(void *dest, const void *src, size_t len);

#endif /* STRING_BARE_H */