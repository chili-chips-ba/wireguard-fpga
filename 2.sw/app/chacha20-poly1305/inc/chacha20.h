/**
 * @file chacha20.h
 * @brief Simple implementation of ChaCha20 encription algorithm
 */

#ifndef CHACHA20_H
#define CHACHA20_H

#include <stddef.h>
#include <stdint.h>

#define CHACHA20_KEY_SIZE 32
#define CHACHA20_NONCE_SIZE 12
#define CHACHA20_BLOCK_SIZE 64

// ChaCha20 state structure
typedef struct
{
    uint32_t state[16]; // ChaCha20 state (16 words)
} chacha20_state;

/**
 * @brief Initializes the ChaCha20 state with the given key, nonce, and counter.
 *
 * @param state Pointer to the 16-word state array.
 * @param key Pointer to the 32-byte encryption key.
 * @param nonce Pointer to the 12-byte nonce.
 * @param counter Initial counter value.
 */
void chacha20_init(chacha20_state *state, const uint8_t *key, const uint8_t *nonce, uint32_t counter);

/**
 * @brief Encrypts data using the ChaCha20 stream cipher.
 *
 * @param out Pointer to the output ciphertext buffer.
 * @param in Pointer to the input plaintext buffer.
 * @param length Number of bytes to encrypt.
 * @param key Pointer to the 32-byte encryption key.
 * @param nonce Pointer to the 12-byte nonce.
 * @param counter Initial counter value.
 */
void chacha20_encrypt(uint8_t *out, const uint8_t *in, size_t length, const uint8_t *key, const uint8_t *nonce, uint32_t counter);

/**
 * @brief Decrypts data using the ChaCha20 stream cipher (same as encryption).
 */
#define chacha20_decrypt chacha20_encrypt

void chacha20_block(chacha20_state *state, chacha20_state *output);

#endif // CHACHA20_H