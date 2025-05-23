/**
 * @file string_bare.h
 * @brief Bare metal string.h implementation
 */

#ifndef STRING_BARE_H
#define STRING_BARE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h> /* For size_t */

/**
 * @brief Fill memory with a constant byte
 *
 * @param dest Pointer to the block of memory to fill
 * @param value Value to be set (converted to unsigned char)
 * @param len Number of bytes to be set
 * @return void* A pointer to the memory area dest
 */
__attribute__((used)) void *memset(void *dest, int value, size_t len);

/**
 * @brief Copy memory area
 *
 * @param dest Pointer to the destination array where content is to be copied
 * @param src Pointer to the source of data to be copied
 * @param len Number of bytes to copy
 * @return void* A pointer to the destination array
 */
__attribute__((used)) void *memcpy(void *dest, const void *src, size_t len);

/**
 * @brief Compare memory areas
 *
 * @param s1 Pointer to the first block of memory
 * @param s2 Pointer to the second block of memory
 * @param len Number of bytes to compare
 * @return int < 0 if s1 < s2, 0 if s1 = s2, > 0 if s1 > s2
 */
int memcmp(const void *s1, const void *s2, size_t len);

/**
 * @brief Calculate the length of a string
 *
 * @param str Pointer to the null-terminated string
 * @return size_t The number of characters in the string before the null terminator
 */
size_t strlen(const char *str);

/**
 * @brief Compare two strings
 *
 * @param s1 Pointer to the first string
 * @param s2 Pointer to the second string
 * @return int < 0 if s1 < s2, 0 if s1 = s2, > 0 if s1 > s2
 */
int strcmp(const void *s1, const void *s2);

#ifdef __cplusplus
}
#endif

#endif /* STRING_BARE_H */