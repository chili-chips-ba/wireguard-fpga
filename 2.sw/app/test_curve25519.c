#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "curve25519.h"

static void print_hex(const char *label, const uint8_t *data, size_t len)
{
    printf("%s: ", label);
    for (size_t i = 0; i < len; i++)
    {
        printf("%02x", data[i]);
    }
    printf("\n");
}

static void random_bytes(uint8_t *buf, size_t len)
{
    for (size_t i = 0; i < len; i++)
    {
        buf[i] = rand() & 0xff;
    }
}

static void test_generate_public_key(void)
{
    printf("=== Test curve25519_generate_public_key() ===\n");

    /* Test 1: Basic functionality */
    printf("Test 1 - Basic public key generation:\n");
    uint8_t private_key[32];
    uint8_t public_key[32];

    random_bytes(private_key, 32);
    int result = curve25519_generate_public_key(public_key, private_key);

    print_hex("Private key", private_key, 32);
    print_hex("Public key ", public_key, 32);
    printf("Result: %s\n\n", result == 0 ? "SUCCESS" : "FAILED");

    /* Test 2: RFC 7748 test vector */
    printf("Test 2 - RFC 7748 test vector:\n");
    uint8_t alice_private[32] = {
        0x77, 0x07, 0x6d, 0x0a, 0x73, 0x18, 0xa5, 0x7d,
        0x3c, 0x16, 0xc1, 0x72, 0x51, 0xb2, 0x66, 0x45,
        0xdf, 0x4c, 0x2f, 0x87, 0xeb, 0xc0, 0x99, 0x2a,
        0xb1, 0x77, 0xfb, 0xa5, 0x1d, 0xb9, 0x2c, 0x2a};

    uint8_t alice_expected[32] = {
        0x85, 0x20, 0xf0, 0x09, 0x89, 0x30, 0xa7, 0x54,
        0x74, 0x8b, 0x7d, 0xdc, 0xb4, 0x3e, 0xf7, 0x5a,
        0x0d, 0xbf, 0x3a, 0x0d, 0x26, 0x38, 0x1a, 0xf4,
        0xeb, 0xa4, 0xa9, 0x8e, 0xaa, 0x9b, 0x4e, 0x6a};

    uint8_t alice_public[32];
    result = curve25519_generate_public_key(alice_public, alice_private);

    print_hex("Computed ", alice_public, 32);
    print_hex("Expected ", alice_expected, 32);
    printf("API Result: %s\n", result == 0 ? "SUCCESS" : "FAILED");
    printf("Vector Match: %s\n\n", memcmp(alice_public, alice_expected, 32) == 0 ? "PASS" : "FAIL");

    /* Test 3: Error handling */
    printf("Test 3 - Error handling:\n");
    result = curve25519_generate_public_key(NULL, private_key);
    printf("NULL public_key: %s\n", result == -1 ? "CORRECTLY REJECTED" : "ERROR NOT DETECTED");

    result = curve25519_generate_public_key(public_key, NULL);
    printf("NULL private_key: %s\n\n", result == -1 ? "CORRECTLY REJECTED" : "ERROR NOT DETECTED");
}

static void test_compute_shared_secret(void)
{
    printf("=== Test curve25519_compute_shared_secret() ===\n");

    /* Test 1: Basic functionality */
    printf("Test 1 - Basic shared secret computation:\n");
    uint8_t alice_private[32], bob_private[32];
    uint8_t alice_public[32], bob_public[32];
    uint8_t shared_secret[32];

    random_bytes(alice_private, 32);
    random_bytes(bob_private, 32);

    /* Generate public keys first */
    curve25519_generate_public_key(alice_public, alice_private);
    curve25519_generate_public_key(bob_public, bob_private);

    /* Alice computes shared secret */
    int result = curve25519_compute_shared_secret(shared_secret, alice_private, bob_public);

    print_hex("Alice private", alice_private, 32);
    print_hex("Bob public   ", bob_public, 32);
    print_hex("Shared secret", shared_secret, 32);
    printf("Result: %s\n\n", result == 0 ? "SUCCESS" : "FAILED");

    /* Test 2: RFC 7748 shared secret test */
    printf("Test 2 - RFC 7748 shared secret:\n");
    uint8_t rfc_alice_private[32] = {
        0x77, 0x07, 0x6d, 0x0a, 0x73, 0x18, 0xa5, 0x7d,
        0x3c, 0x16, 0xc1, 0x72, 0x51, 0xb2, 0x66, 0x45,
        0xdf, 0x4c, 0x2f, 0x87, 0xeb, 0xc0, 0x99, 0x2a,
        0xb1, 0x77, 0xfb, 0xa5, 0x1d, 0xb9, 0x2c, 0x2a};

    uint8_t rfc_bob_public[32] = {
        0xde, 0x9e, 0xdb, 0x7d, 0x7b, 0x7d, 0xc1, 0xb4,
        0xd3, 0x5b, 0x61, 0xc2, 0xec, 0xe4, 0x35, 0x37,
        0x3f, 0x83, 0x43, 0xc8, 0x5b, 0x78, 0x67, 0x4d,
        0xad, 0xfc, 0x7e, 0x14, 0x6f, 0x88, 0x2b, 0x4f};

    uint8_t rfc_expected_shared[32] = {
        0x4a, 0x5d, 0x9d, 0x5b, 0xa4, 0xce, 0x2d, 0xe1,
        0x72, 0x8e, 0x3b, 0xf4, 0x80, 0x35, 0x0f, 0x25,
        0xe0, 0x7e, 0x21, 0xc9, 0x47, 0xd1, 0x9e, 0x33,
        0x76, 0xf0, 0x9b, 0x3c, 0x1e, 0x16, 0x17, 0x42};

    uint8_t rfc_shared[32];
    result = curve25519_compute_shared_secret(rfc_shared, rfc_alice_private, rfc_bob_public);

    print_hex("Computed ", rfc_shared, 32);
    print_hex("Expected ", rfc_expected_shared, 32);
    printf("API Result: %s\n", result == 0 ? "SUCCESS" : "FAILED");
    printf("Vector Match: %s\n\n", memcmp(rfc_shared, rfc_expected_shared, 32) == 0 ? "PASS" : "FAIL");

    /* Test 3: Error handling */
    printf("Test 3 - Error handling:\n");
    result = curve25519_compute_shared_secret(NULL, alice_private, bob_public);
    printf("NULL shared_secret: %s\n", result == -1 ? "CORRECTLY REJECTED" : "ERROR NOT DETECTED");

    result = curve25519_compute_shared_secret(shared_secret, NULL, bob_public);
    printf("NULL private_key: %s\n", result == -1 ? "CORRECTLY REJECTED" : "ERROR NOT DETECTED");

    result = curve25519_compute_shared_secret(shared_secret, alice_private, NULL);
    printf("NULL public_key: %s\n\n", result == -1 ? "CORRECTLY REJECTED" : "ERROR NOT DETECTED");
}

static void test_complete_key_exchange(void)
{
    printf("=== Test Complete Key Exchange ===\n");

    /* Simulate Alice and Bob doing a complete key exchange */
    uint8_t alice_private[32], bob_private[32];
    uint8_t alice_public[32], bob_public[32];
    uint8_t alice_shared[32], bob_shared[32];

    printf("Step 1: Generate private keys\n");
    random_bytes(alice_private, 32);
    random_bytes(bob_private, 32);
    print_hex("Alice private", alice_private, 32);
    print_hex("Bob private  ", bob_private, 32);

    printf("\nStep 2: Generate public keys\n");
    int alice_keygen = curve25519_generate_public_key(alice_public, alice_private);
    int bob_keygen = curve25519_generate_public_key(bob_public, bob_private);

    print_hex("Alice public ", alice_public, 32);
    print_hex("Bob public   ", bob_public, 32);
    printf("Alice keygen: %s, Bob keygen: %s\n",
           alice_keygen == 0 ? "Finished!" : "Failed!", bob_keygen == 0 ? "Finished!" : "Failed!");

    printf("\nStep 3: Exchange public keys and compute shared secrets\n");
    int alice_shared_result = curve25519_compute_shared_secret(alice_shared, alice_private, bob_public);
    int bob_shared_result = curve25519_compute_shared_secret(bob_shared, bob_private, alice_public);

    print_hex("Alice shared ", alice_shared, 32);
    print_hex("Bob shared   ", bob_shared, 32);
    printf("Alice computation: %s, Bob computation: %s\n",
           alice_shared_result == 0 ? "Finished!" : "Failed!", bob_shared_result == 0 ? "Finished!" : "Failed!");

    printf("\nStep 4: Verify shared secrets match\n");
    int secrets_match = memcmp(alice_shared, bob_shared, 32) == 0;
    printf("Shared secrets match: %s\n", secrets_match ? "SUCCESS" : "FAILED");

    if (secrets_match)
    {
        printf("Key exchange successful! Alice and Bob have the same shared secret.\n");
    }
    else
    {
        printf("Key exchange failed! Shared secrets don't match.\n");
    }
    printf("\n");
}

static void test_multiple_exchanges(void)
{
    printf("=== Test Multiple Key Exchanges ===\n");

    const int num_tests = 10;
    int successes = 0;

    for (int i = 0; i < num_tests; i++)
    {
        uint8_t private_a[32], private_b[32];
        uint8_t public_a[32], public_b[32];
        uint8_t shared_a[32], shared_b[32];

        /* Generate random keys */
        random_bytes(private_a, 32);
        random_bytes(private_b, 32);

        /* Generate public keys */
        int keygen_a = curve25519_generate_public_key(public_a, private_a);
        int keygen_b = curve25519_generate_public_key(public_b, private_b);

        /* Compute shared secrets */
        int shared_a_result = curve25519_compute_shared_secret(shared_a, private_a, public_b);
        int shared_b_result = curve25519_compute_shared_secret(shared_b, private_b, public_a);

        /* Check if everything worked and secrets match */
        int test_passed = (keygen_a == 0) && (keygen_b == 0) &&
                          (shared_a_result == 0) && (shared_b_result == 0) &&
                          (memcmp(shared_a, shared_b, 32) == 0);

        if (test_passed)
        {
            successes++;
            printf("Test %2d: PASS\n", i + 1);
        }
        else
        {
            printf("Test %2d: FAIL (keygen_a:%d, keygen_b:%d, shared_a:%d, shared_b:%d, match:%d)\n",
                   i + 1, keygen_a, keygen_b, shared_a_result, shared_b_result,
                   memcmp(shared_a, shared_b, 32) == 0);
        }
    }

    printf("\nMultiple exchanges: %d/%d passed (%.1f%%)\n\n",
           successes, num_tests, (successes * 100.0) / num_tests);
}

int main(void)
{
    srand(time(NULL));

    printf("Curve25519 API Test Suite\n");
    printf("=========================\n\n");

    test_generate_public_key();
    test_compute_shared_secret();
    test_complete_key_exchange();
    test_multiple_exchanges();

    printf("All tests completed!\n");
    return 0;
}