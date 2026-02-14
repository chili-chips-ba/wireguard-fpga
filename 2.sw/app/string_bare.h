// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

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
#include <stdint.h> /* For uint8_t, uint32_t */

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

/**
 * @brief Parse uint32_t from string
 *
 * @param str Pointer to the null-terminated string
 * @param value Pointer to store the parsed uint32_t
 * @param min Minimum acceptable value
 * @param max Maximum acceptable value
 * @return uint8_t 1 if successful, 0 otherwise
 */
uint8_t str_parse_uint32(const char* str, uint32_t* value, uint32_t min, uint32_t max);

/**
 * @brief Parse uint8_t from string
 *
 * @param str Pointer to the null-terminated string
 * @param value Pointer to store the parsed uint8_t
 * @param min Minimum acceptable value
 * @param max Maximum acceptable value
 * @return uint8_t 1 if successful, 0 otherwise
 */
uint8_t str_parse_uint8(const char* str, uint8_t* value, uint8_t min, uint8_t max);

/**
 * @brief Parse hexadecimal uint32_t from string
 *
 * @param str Pointer to the null-terminated string
 * @param value Pointer to store the parsed uint32_t
 * @param min Minimum acceptable value
 * @param max Maximum acceptable value
 * @return uint8_t 1 if successful, 0 otherwise
 */
uint8_t str_parse_hex(const char* str, uint32_t* value, uint32_t min, uint32_t max);

#ifdef __cplusplus
}
#endif

#endif /* STRING_BARE_H */
