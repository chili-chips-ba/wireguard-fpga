// main.c
// Tests for BLAKE2s.

#include <stdint.h>
#include "blake2s.h"

#define reg_gpio (*(volatile uint32_t*)0x03000000)
#define LED0 (1 << 0)

void delay(uint32_t count) {
    volatile uint32_t i;
    for (i = 0; i < count; i++);
}

// Deterministic sequences (Fibonacci generator).
static void selftest_seq(uint8_t *out, size_t len, uint32_t seed)
{
    size_t i;
    uint32_t t, a, b;

    a = 0xDEAD4BAD * seed; // prime
    b = 1;

    for (i = 0; i < len; i++)
    { // fill the buf
        t = a + b;
        a = b;
        b = t;
        out[i] = (t >> 24) & 0xFF;
    }
}

// BLAKE2s self-test validation. Return 0 when OK.
int blake2s_selftest()
{
    // Grand hash of hash results.
    const uint8_t blake2s_res[32] = {
        0x6A, 0x41, 0x1F, 0x08, 0xCE, 0x25, 0xAD, 0xCD,
        0xFB, 0x02, 0xAB, 0xA6, 0x41, 0x45, 0x1C, 0xEC,
        0x53, 0xC5, 0x98, 0xB2, 0x4F, 0x4F, 0xC7, 0x87,
        0xFB, 0xDC, 0x88, 0x79, 0x7F, 0x4C, 0x1D, 0xFE};
    // Parameter sets.
    const size_t b2s_md_len[4] = {16, 20, 28, 32};
    const size_t b2s_in_len[6] = {0, 3, 64, 65, 255, 1024};

    size_t i, j, outlen, inlen;
    uint8_t in[1024], md[32], key[32];
    blake2s_ctx ctx;

    // 256-bit hash for testing.
    if (blake2s_init(&ctx, 32, NULL, 0))
        return -1;

    for (i = 0; i < 4; i++)
    {
        outlen = b2s_md_len[i];
        for (j = 0; j < 6; j++)
        {
            inlen = b2s_in_len[j];

            selftest_seq(in, inlen, inlen); // unkeyed hash
            blake2s(md, outlen, NULL, 0, in, inlen);
            blake2s_update(&ctx, md, outlen); // hash the hash

            selftest_seq(key, outlen, outlen); // keyed hash
            blake2s(md, outlen, key, outlen, in, inlen);
            blake2s_update(&ctx, md, outlen); // hash the hash
        }
    }

    // Compute and compare the hash of hashes.
    blake2s_final(&ctx, md);
    for (i = 0; i < 32; i++)
    {
        if (md[i] != blake2s_res[i])
            return -1;
    }

    return 0;
}

// Helper to compare against expected value
static int compare_digest(const uint8_t *a, const uint8_t *b, size_t len)
{
    for (size_t i = 0; i < len; i++)
        if (a[i] != b[i])
            return 0;
    return 1;
}

int main(int argc, char **argv)
{
    // test the LEDs, so we can see the LED change when tests finish
    reg_gpio |= LED0;
    delay(3000000);
    reg_gpio &= ~LED0;
    delay(3000000);

    uint8_t out[32];
    int pass = 1;

    if (blake2s_selftest() != 0) pass = 0;

    struct {
        const char *input;
        const uint8_t expected[32];
    } tests[] = {
        // RFC 7693 official test vectors (BLAKE2s-256)
        {
            "", // empty string
            {0x69, 0x21, 0x7a, 0x30, 0x79, 0x90, 0x80, 0x94,
            0xe1, 0x11, 0x21, 0xd0, 0x42, 0x35, 0x4a, 0x7c,
            0x1f, 0x55, 0xb6, 0x48, 0x2c, 0xa1, 0xa5, 0x1e,
            0x1b, 0x25, 0x0d, 0xfd, 0x1e, 0xd0, 0xee, 0xf9}
        },
        {
            "abc",
            {0x50, 0x8c, 0x5e, 0x8c, 0x32, 0x7c, 0x14, 0xe2,
            0xe1, 0xa7, 0x2b, 0xa3, 0x4e, 0xeb, 0x45, 0x2f,
            0x37, 0x45, 0x8b, 0x20, 0x9e, 0xd6, 0x3a, 0x29,
            0x4d, 0x99, 0x9b, 0x4c, 0x86, 0x67, 0x59, 0x82}
        }
    };

    size_t num_tests = sizeof(tests) / sizeof(tests[0]);

    for (size_t i = 0; i < num_tests; i++) 
    {
        const char *msg = tests[i].input;
        const uint8_t *expected = tests[i].expected;

        // Compute hash
        blake2s(out, 32, NULL, 0, msg, strlen(msg)); 

        // Compare
        int ok = 1;
        for (int j = 0; j < 32; j++) 
        {
            if (out[j] != expected[j]) 
            {
                ok = 0;
                break;
            }
        }

    if (!ok) pass = 0;
}

    if (pass) 
    {
        reg_gpio |= LED0; //hashing successful
    }
    return 0;
}