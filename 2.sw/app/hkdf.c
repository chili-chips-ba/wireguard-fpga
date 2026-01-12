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
//   HKDF library
//==========================================================================

#include "hkdf.h"

/* HKDF (Noise variant using BLAKE2s) */
void kdf(
    uint8_t *first_dst,  size_t first_len,
    uint8_t *second_dst, size_t second_len,
    uint8_t *third_dst,  size_t third_len,
    const uint8_t *data, size_t data_len,
    const uint8_t chaining_key[NOISE_HASH_LEN])
{
    uint8_t output[BLAKE2S_HASH_SIZE + 1];
    uint8_t secret[BLAKE2S_HASH_SIZE];

    /* Extract: secret = HMAC(chaining_key, data) */
    hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);

    if (!first_dst || !first_len)
        goto out;

    /* Expand 1: output = HMAC(secret, 0x01) */
    output[0] = 1;
    hmac(output, output, secret, 1, BLAKE2S_HASH_SIZE);
    memcpy(first_dst, output, first_len);

    if (!second_dst || !second_len)
        goto out;

    /* Expand 2: output = HMAC(secret, first_key || 0x02) */
    output[BLAKE2S_HASH_SIZE] = 2;
    hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
    memcpy(second_dst, output, second_len);

    if (!third_dst || !third_len)
        goto out;

    /* Expand 3: output = HMAC(secret, second_key || 0x03) */
    output[BLAKE2S_HASH_SIZE] = 3;
    hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
    memcpy(third_dst, output, third_len);

out:
    /* Wipe stack using your bare-metal memset */
    memset(secret, 0, BLAKE2S_HASH_SIZE);
    memset(output, 0, BLAKE2S_HASH_SIZE + 1);
}
