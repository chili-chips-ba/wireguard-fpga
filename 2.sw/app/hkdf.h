#ifndef HKDF_H
#define HKDF_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>

#include "blake2s.h"
#include "string_bare.h"

/* Noise uses 32-byte hashes (BLAKE2s-256) */
#define NOISE_HASH_LEN 32

/* HKDF-style KDF used in Noise. Hugo Krawczyk's HKDF
 * Produces up to 3 keys (first, second, third).
 * Any output may be NULL or length = 0 to skip it.
 */
void kdf(
    uint8_t *first_dst, size_t first_len,
    uint8_t *second_dst, size_t second_len,
    uint8_t *third_dst, size_t third_len,
    const uint8_t *data, size_t data_len,
    const uint8_t chaining_key[NOISE_HASH_LEN]);

#ifdef __cplusplus
}
#endif

#endif // HKDF_H
