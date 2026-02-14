// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
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
