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
//   Poly1305 library
//==========================================================================

#include "poly1305.h"
#include "string_bare.h"

#define BLOCK_SIZE 16

/**
 * @brief 130-bit prime: 2^130 - 5
 */
static const uint64_t PRIME[3] = {0xFFFFFFFFFFFFFFFB, 0xFFFFFFFFFFFFFFFF, 0x3};

/**
 * @brief Structure to hold a 320-bit unsigned integer for Poly1305 calculations
 */
typedef struct
{
    uint64_t limbs[5]; // 64-bit limbs
} uint320_t;

/**
 * @brief Apply clamping to the 'r' part of the key
 *
 * @param r 16-byte array to clamp
 */
static void clamp(uint8_t r[16])
{
    r[3] &= 15;
    r[7] &= 15;
    r[11] &= 15;
    r[15] &= 15;
    r[4] &= 252;
    r[8] &= 252;
    r[12] &= 252;
}

/**
 * @brief Copy bytes to a uint320_t
 *
 * @param dst Destination uint320_t
 * @param src Source byte array
 * @param len Number of bytes to copy (max 40)
 */
static void bytes_to_uint320(uint320_t *dst, const uint8_t *src, size_t len)
{
    memset(dst->limbs, 0, sizeof(dst->limbs));

    for (size_t i = 0; i < len && i < 40; i++)
    {
        size_t limb_idx = i / 8;
        size_t bit_shift = (i % 8) * 8;
        dst->limbs[limb_idx] |= ((uint64_t)src[i]) << bit_shift;
    }
}

/**
 * @brief Add two uint320_t values
 *
 * @param res Result: a + b
 * @param a First operand
 * @param b Second operand
 */
static void uint320_add(uint320_t *res, const uint320_t *a, const uint320_t *b)
{
    uint64_t carry = 0;

    for (int i = 0; i < 5; i++)
    {
        uint64_t sum = a->limbs[i] + b->limbs[i] + carry;
        carry = (sum < a->limbs[i]) || (sum == a->limbs[i] && carry);
        res->limbs[i] = sum;
    }
}

/**
 * @brief Multiply two uint320_t values
 *
 * @param res Result: a * b
 * @param a First operand
 * @param b Second operand
 */
static void uint320_mul(uint320_t *res, const uint320_t *a, const uint320_t *b)
{
    uint320_t temp;
    memset(&temp, 0, sizeof(temp));

    // Schoolbook multiplication algorithm
    for (int i = 0; i < 5; i++)
    {
        uint64_t carry = 0;
        for (int j = 0; j < 5 - i; j++)
        {
            uint64_t high;
            uint64_t low;
            uint64_t product = a->limbs[i] * b->limbs[j];
            uint64_t old_value = temp.limbs[i + j];

            // Add previous value and carry
            low = product + old_value;
            high = (low < product) ? 1 : 0;
            low += carry;
            high += (low < carry) ? 1 : 0;

            temp.limbs[i + j] = low;
            carry = high;
        }
    }

    memcpy(res, &temp, sizeof(uint320_t));
}

/**
 * @brief Reduce a uint320_t modulo 2^130 - 5
 *
 * @param a Value to reduce
 */
static void uint320_mod_prime(uint320_t *a)
{
    // First, handle the high bits (greater than or equal to 2^130)
    uint64_t mask = 0x3FFFFFFFFFF; // 2^130 - 1
    uint64_t high_bits = a->limbs[2] & ~mask;
    if (high_bits || a->limbs[3] || a->limbs[4])
    {
        // We have bits above 2^130, need to reduce

        // Clear high bits
        a->limbs[2] &= mask;
        a->limbs[3] = 0;
        a->limbs[4] = 0;

        // Multiply high bits by 5 and add to low bits
        uint320_t mul5;
        memset(&mul5, 0, sizeof(mul5));

        // high_bits * 5
        mul5.limbs[0] = (high_bits >> 2) * 5;

        // Add to original value
        uint320_add(a, a, &mul5);
    }

    // Check if result is still >= 2^130 - 5
    if ((a->limbs[2] & mask) == mask &&
        a->limbs[1] == 0xFFFFFFFFFFFFFFFF &&
        a->limbs[0] >= 0xFFFFFFFFFFFFFFFB)
    {

        // Subtract 2^130 - 5
        uint64_t borrow = 0;
        uint64_t diff;

        diff = a->limbs[0] - 0xFFFFFFFFFFFFFFFB;
        borrow = (diff > a->limbs[0]) ? 1 : 0;
        a->limbs[0] = diff;

        diff = a->limbs[1] - 0xFFFFFFFFFFFFFFFF - borrow;
        borrow = (diff > a->limbs[1]) || (diff == a->limbs[1] && borrow);
        a->limbs[1] = diff;

        a->limbs[2] -= borrow;
        a->limbs[2] &= mask; // Ensure top bits are zero
    }
}

/**
 * @brief Compute Poly1305 MAC for a message
 *
 * @param auth_tag Output buffer for the 16-byte authentication tag
 * @param key 32-byte key (r || s)
 * @param message Input message buffer
 * @param message_length Length of the message in bytes
 */
void poly1305_mac(uint8_t *auth_tag, const uint8_t *key, const uint8_t *message, size_t message_length)
{
    uint8_t r_bytes[16]; // r part of the key
    uint8_t s_bytes[16]; // s part of the key

    // Split key into r and s components
    memcpy(r_bytes, key, 16);
    memcpy(s_bytes, key + 16, 16);

    // Clamp r according to the spec
    clamp(r_bytes);

    // Convert r and s to uint320_t
    uint320_t r, s, a;
    memset(&a, 0, sizeof(a)); // Initialize accumulator to 0
    bytes_to_uint320(&r, r_bytes, 16);
    bytes_to_uint320(&s, s_bytes, 16);

    // Process message in 16-byte blocks
    size_t blocks = message_length / BLOCK_SIZE;
    size_t remain = message_length % BLOCK_SIZE;

    // Process full blocks
    for (size_t i = 0; i < blocks; i++)
    {
        uint320_t n;
        bytes_to_uint320(&n, message + (i * BLOCK_SIZE), BLOCK_SIZE);

        // Set the high bit (2^128)
        n.limbs[2] |= 0x1;

        // a += n
        uint320_add(&a, &a, &n);

        // a *= r
        uint320_t temp = a;
        uint320_mul(&a, &temp, &r);

        // a %= p
        uint320_mod_prime(&a);
    }

    // Process remaining bytes
    if (remain > 0)
    {
        uint8_t last_block[BLOCK_SIZE] = {0};
        memcpy(last_block, message + (blocks * BLOCK_SIZE), remain);

        // Add the padding byte
        last_block[remain] = 0x01;

        uint320_t n;
        bytes_to_uint320(&n, last_block, BLOCK_SIZE);

        // a += n
        uint320_add(&a, &a, &n);

        // a *= r
        uint320_t temp = a;
        uint320_mul(&a, &temp, &r);

        // a %= p
        uint320_mod_prime(&a);
    }

    // a += s
    uint320_add(&a, &a, &s);

    // Copy the first 16 bytes to output
    memcpy(auth_tag, &a, 16);
}

/**
 * @brief Verify if two Poly1305 tags match
 *
 * @param tag1 First tag to compare
 * @param tag2 Second tag to compare
 * @return 1 if tags match, 0 otherwise
 */
int poly1305_verify(const uint8_t *tag1, const uint8_t *tag2)
{
    uint64_t *a_hi = (uint64_t *)(tag1);
    uint64_t *a_lo = (uint64_t *)(tag1 + 8);
    uint64_t *b_hi = (uint64_t *)(tag2);
    uint64_t *b_lo = (uint64_t *)(tag2 + 8);

    return (a_hi[0] == b_hi[0]) && (a_lo[0] == b_lo[0]);
}