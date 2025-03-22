/**
 * @file main.c
 * @brief Test program for ChaCha20-Poly1305 AEAD implementation
 */

#include <stdint.h>
#include "string_bare.h"
#include <stdint.h>
#include "wireguard.h"

#define reg_gpio (*(volatile uint32_t*)0x03000000)
#define LED0 (1 << 0)

void delay(uint32_t count) {
    volatile uint32_t i;
    for (i = 0; i < count; i++);
}

int main(void)
{
    reg_gpio |= LED0;
    delay(3000000);
    reg_gpio &= ~LED0;
    delay(3000000);

    // Test vectors
    uint8_t key[32] = {
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
        0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
        0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
        0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f};

    uint8_t nonce[12] = {
        0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43,
        0x44, 0x45, 0x46, 0x47};

    const char *aad_str = "Additional authenticated data";
    uint8_t *aad = (uint8_t *)aad_str;
    size_t aad_len = strlen(aad_str);

    const char *plaintext_str = "Hello CHILIChips - Wireguard team, let's test this aead!";
    uint8_t *plaintext = (uint8_t *)plaintext_str;
    size_t plaintext_len = strlen(plaintext_str);

    // Use stack allocation instead of malloc
    uint8_t ciphertext[256]; // Buffer large enough for the plaintext
    uint8_t decrypted[256];  // Buffer large enough for the plaintext
    uint8_t auth_tag[16];
    // Encrypt
    int ret = chacha20poly1305_encrypt(
        ciphertext, auth_tag, key, nonce,
        plaintext, plaintext_len, aad, aad_len);

    if (ret != 0)
    {
        return -1;
    }
    // Decrypt
    ret = chacha20poly1305_decrypt(
        decrypted, key, nonce, ciphertext, plaintext_len,
        auth_tag, aad, aad_len);

    if (ret == 0)
    {    
        reg_gpio |= LED0; //encryption succesfull
    }
	
	/*
    // Verify
    decrypted[plaintext_len] = '\0'; // Null-terminate for printing
    //printf("Decrypted (%zu bytes): \"%s\"\n\n", plaintext_len, decrypted);

    int success = (memcmp(plaintext, decrypted, plaintext_len) == 0);
    //printf("Test %s\n", success ? "PASSED" : "FAILED");

    // Test with tampered data
    //printf("\n=== Tampering Test ===\n\n");
    //printf("Modifying ciphertext and attempting to decrypt...\n");
    ciphertext[0] ^= 1; // Flip one bit

    ret = chacha20poly1305_decrypt(
        decrypted, key, nonce, ciphertext, plaintext_len,
        auth_tag, aad, aad_len);

    if (ret != 0)
    {
        //printf("Decryption correctly failed with tampered ciphertext\n");
        //printf("Test PASSED\n");
    }
    else
    {
        //printf("SECURITY WARNING: Tampered ciphertext was accepted!\n");
        //printf("Test FAILED\n");
    }

    // Test with tampered AAD
    //printf("\nModifying AAD and attempting to decrypt...\n");
    ciphertext[0] ^= 1; // Restore ciphertext

    // Use stack allocation for modified AAD
    uint8_t modified_aad[256];
    memcpy(modified_aad, aad, aad_len);
    modified_aad[0] ^= 1; // Flip one bit in AAD

    ret = chacha20poly1305_decrypt(
        decrypted, key, nonce, ciphertext, plaintext_len,
        auth_tag, modified_aad, aad_len);

    if (ret != 0)
    {
        //printf("Decryption correctly failed with tampered AAD\n");
        //printf("Test PASSED\n");
    }
    else
    {
        //printf("SECURITY WARNING: Tampered AAD was accepted!\n");
        //printf("Test FAILED\n");
    }

    // Test with tampered tag
    //printf("\nModifying auth tag and attempting to decrypt...\n");
    uint8_t modified_tag[16];
    memcpy(modified_tag, auth_tag, 16);
    modified_tag[0] ^= 1; // Flip one bit in tag

    ret = chacha20poly1305_decrypt(
        decrypted, key, nonce, ciphertext, plaintext_len,
        modified_tag, aad, aad_len);

    if (ret != 0)
    {
        //printf("Decryption correctly failed with tampered tag\n");
        //printf("Test PASSED\n");
    }
    else
    {
        //printf("SECURITY WARNING: Tampered tag was accepted!\n");
        //printf("Test FAILED\n");
    }
	 */

    return 0;
}