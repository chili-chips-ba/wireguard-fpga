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
//   ChaCha20-Poly1305 AEAD library
//==========================================================================

#include "chacha20poly1305.h"
#include "chacha20.h"
#include "poly1305.h"
#include "string_bare.h"

// Helper function to encode a 64-bit value in little-endian format
static void encode_le64(uint8_t *dst, uint64_t value)
{
    dst[0] = (uint8_t)(value);
    dst[1] = (uint8_t)(value >> 8);
    dst[2] = (uint8_t)(value >> 16);
    dst[3] = (uint8_t)(value >> 24);
    dst[4] = (uint8_t)(value >> 32);
    dst[5] = (uint8_t)(value >> 40);
    dst[6] = (uint8_t)(value >> 48);
    dst[7] = (uint8_t)(value >> 56);
}

// Generate Poly1305 one-time key using ChaCha20
static void poly1305_key_gen(uint8_t *poly1305_key, const uint8_t *key, const uint8_t *nonce)
{
    // Use counter 0 and generate a block
    uint8_t block[CHACHA20_BLOCK_SIZE] = {0};
    chacha20_encrypt(block, block, CHACHA20_BLOCK_SIZE, key, nonce, 0);

    // First 32 bytes of the block become the Poly1305 key
    memcpy(poly1305_key, block, 32);
}

int chacha20poly1305_encrypt(
    uint8_t *ciphertext,
    uint8_t *auth_tag,
    const uint8_t *key,
    const uint8_t *nonce,
    const uint8_t *plaintext,
    size_t plaintext_len,
    const uint8_t *aad,
    size_t aad_len)
{
    // 1. Generate Poly1305 one-time key using the first 32 bytes of ChaCha20 keystream with counter 0
    uint8_t poly1305_key[32];
    poly1305_key_gen(poly1305_key, key, nonce);

    // 2. Encrypt plaintext using ChaCha20 starting with counter 1
    chacha20_encrypt(ciphertext, plaintext, plaintext_len, key, nonce, 1);

    // 3. Prepare the authenticated data for Poly1305
    // Allocate memory for AAD || padding || ciphertext || padding || AAD length || ciphertext length
    size_t aad_padding = (16 - (aad_len % 16)) % 16;
    size_t ciphertext_padding = (16 - (plaintext_len % 16)) % 16;
    size_t auth_data_len = aad_len + aad_padding + plaintext_len + ciphertext_padding + 16;

    // Use stack allocation with a reasonable maximum size
    uint8_t auth_data_stack[1024];
    memset(auth_data_stack, 0, sizeof(auth_data_stack));

    uint8_t *auth_data = auth_data_stack;
    if (!auth_data)
        return -1; // Memory allocation failure

    // Copy AAD
    if (aad && aad_len > 0)
        memcpy(auth_data, aad, aad_len);

    // Copy ciphertext after AAD (and padding)
    memcpy(auth_data + aad_len + aad_padding, ciphertext, plaintext_len);

    // Append AAD and ciphertext lengths as little-endian 64-bit integers
    uint8_t *lengths = auth_data + aad_len + aad_padding + plaintext_len + ciphertext_padding;
    encode_le64(lengths, aad_len);
    encode_le64(lengths + 8, plaintext_len);

    // 4. Compute the Poly1305 tag over the authenticated data
    poly1305_mac(auth_tag, poly1305_key, auth_data, auth_data_len);

    return 0;
}

int chacha20poly1305_decrypt(
    uint8_t *plaintext,
    const uint8_t *key,
    const uint8_t *nonce,
    const uint8_t *ciphertext,
    size_t ciphertext_len,
    const uint8_t *auth_tag,
    const uint8_t *aad,
    size_t aad_len)
{
    // 1. Generate Poly1305 one-time key using the first 32 bytes of ChaCha20 keystream with counter 0
    uint8_t poly1305_key[32];
    poly1305_key_gen(poly1305_key, key, nonce);

    // 2. Prepare the authenticated data for Poly1305
    size_t aad_padding = (16 - (aad_len % 16)) % 16;
    size_t ciphertext_padding = (16 - (ciphertext_len % 16)) % 16;
    size_t auth_data_len = aad_len + aad_padding + ciphertext_len + ciphertext_padding + 16;

    // Use stack allocation with a reasonable maximum size
    uint8_t auth_data_stack[1024];
    memset(auth_data_stack, 0, sizeof(auth_data_stack));

    uint8_t *auth_data = auth_data_stack;
    if (!auth_data)
        return -1; // Memory allocation failure

    // Copy AAD
    if (aad && aad_len > 0)
        memcpy(auth_data, aad, aad_len);

    // Copy ciphertext after AAD (and padding)
    memcpy(auth_data + aad_len + aad_padding, ciphertext, ciphertext_len);

    // Append AAD and ciphertext lengths as little-endian 64-bit integers
    uint8_t *lengths = auth_data + aad_len + aad_padding + ciphertext_len + ciphertext_padding;
    encode_le64(lengths, aad_len);
    encode_le64(lengths + 8, ciphertext_len);

    // 3. Compute and verify the Poly1305 tag
    uint8_t calculated_tag[16];
    poly1305_mac(calculated_tag, poly1305_key, auth_data, auth_data_len);

    if (!poly1305_verify(auth_tag, calculated_tag))
        return -1; // Authentication failed

    // 4. Decrypt ciphertext using ChaCha20 starting with counter 1
    chacha20_decrypt(plaintext, ciphertext, ciphertext_len, key, nonce, 1);

    return 0;
}