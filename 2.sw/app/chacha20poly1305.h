/**
 * @file chacha20poly1305.h
 * @brief ChaCha20-Poly1305 AEAD implementation
 */

#ifndef CHACHA20POLY1305_H
#define CHACHA20POLY1305_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>

#define CHACHA20POLY1305_KEY_SIZE 32
#define CHACHA20POLY1305_NONCE_SIZE 12
#define CHACHA20POLY1305_TAG_SIZE 16

/**
 * @brief Encrypt and authenticate data using ChaCha20-Poly1305 AEAD
 *
 * @param ciphertext Output buffer for encrypted data
 * @param auth_tag Output buffer for the 16-byte authentication tag
 * @param key 32-byte encryption key
 * @param nonce 12-byte nonce
 * @param plaintext Input plaintext buffer
 * @param plaintext_len Length of plaintext in bytes
 * @param aad Additional authenticated data (can be NULL)
 * @param aad_len Length of AAD in bytes (can be 0)
 * @return 0 on success, non-zero on failure
 */
int chacha20poly1305_encrypt(
    uint8_t *ciphertext,
    uint8_t *auth_tag,
    const uint8_t *key,
    const uint8_t *nonce,
    const uint8_t *plaintext,
    size_t plaintext_len,
    const uint8_t *aad,
    size_t aad_len);

/**
 * @brief Decrypt and verify data using ChaCha20-Poly1305 AEAD
 *
 * @param plaintext Output buffer for decrypted data
 * @param key 32-byte encryption key
 * @param nonce 12-byte nonce
 * @param ciphertext Input ciphertext buffer
 * @param ciphertext_len Length of ciphertext in bytes
 * @param auth_tag The 16-byte authentication tag to verify
 * @param aad Additional authenticated data (can be NULL)
 * @param aad_len Length of AAD in bytes (can be 0)
 * @return 0 on success (tag verified), non-zero on failure
 */
int chacha20poly1305_decrypt(
    uint8_t *plaintext,
    const uint8_t *key,
    const uint8_t *nonce,
    const uint8_t *ciphertext,
    size_t ciphertext_len,
    const uint8_t *auth_tag,
    const uint8_t *aad,
    size_t aad_len);

#ifdef __cplusplus
}
#endif

#endif // CHACHA20POLY1305_H