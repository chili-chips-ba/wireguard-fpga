// test_main.c
// Self test Modules for BLAKE2b and BLAKE2s -- and a stub main().

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "blake2s.h"

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

// Helper to print a digest as hex
static void print_hex(const uint8_t *digest, size_t len)
{
    for (size_t i = 0; i < len; i++)
        printf("%02x", digest[i]);
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
    printf("blake2s_selftest() = %s\n", blake2s_selftest() ? "FAIL" : "OK");

    uint8_t out[32];
    int pass = 1;

    struct {
        const char *input;
        const char *expected_hex;
    } tests[] = {
        // RFC 7693 official test vectors (BLAKE2s-256)
        {
            "", // empty string
            "69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9"
        },
        {
            "abc",
            "508c5e8c327c14e2e1a72ba34eeb452f37458b209ed63a294d999b4c86675982"
        }
    };

    size_t num_tests = sizeof(tests) / sizeof(tests[0]);

    printf("Running BLAKE2s KATs (RFC 7693)...\n\n");

    for (size_t i = 0; i < num_tests; i++) {
        const char *msg = tests[i].input;
        const char *expected_hex = tests[i].expected_hex;

        // Compute hash
        blake2s(out, 32, NULL, 0, msg, strlen(msg));

        // Convert expected hex to bytes for comparison
        uint8_t expected[32];
        for (int j = 0; j < 32; j++) {
            sscanf(&expected_hex[j * 2], "%2hhx", &expected[j]);
        }

        // Compare
        int ok = compare_digest(out, expected, 32);

        printf("Test %zu: \"%s\"\n", i + 1, msg);
        printf("Expected: %s\nGot:      ", expected_hex);
        print_hex(out, 32);
        printf("\nResult:   %s\n\n", ok ? "✅ PASS" : "❌ FAIL");

        if (!ok) pass = 0;
    }

    printf("Final result: %s\n", pass ? "✅ All KATs passed!" : "❌ Some tests failed.");
    return 0;
}