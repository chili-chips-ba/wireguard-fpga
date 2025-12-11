#include "tb.h"

// CSR values available all at once do not need to be static=registers
// Streaming inputs data is done as shift register
#pragma MAIN encrypt_tb
stream(axis128_t) encrypt_tb()
{
    // Test vectors
    uint8_t key[CHACHA20_KEY_SIZE] = {
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
        0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
        0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
        0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f};

    uint8_t nonce[CHACHA20_NONCE_SIZE] = {
        0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43,
        0x44, 0x45, 0x46, 0x47};

    #define AAD_TEST_STR "Additional authenticated data"
    uint8_t aad[AAD_MAX_LEN] = AAD_TEST_STR;
    uint32_t aad_len = strlen(AAD_TEST_STR);

    #define NUM_PLAINTEXT_TEST_STRS 2
    #define PLAINTEXT_TEST_STR_MAX_SIZE 128
    #define PLAINTEXT_TEST_STR0 "Hello CHILIChips - Wireguard team, let's test this aead!"
    #define PLAINTEXT_TEST_STR0_LEN strlen(PLAINTEXT_TEST_STR0)
    #define PLAINTEXT_TEST_STR1 "PipelineC is the best HDL around :) Let's go CHILIChips Wireguard team!"
    #define PLAINTEXT_TEST_STR1_LEN strlen(PLAINTEXT_TEST_STR1)
    char plaintexts[NUM_PLAINTEXT_TEST_STRS][PLAINTEXT_TEST_STR_MAX_SIZE] = {
        PLAINTEXT_TEST_STR0,
        PLAINTEXT_TEST_STR1
    };
    uint32_t plaintext_lens[NUM_PLAINTEXT_TEST_STRS] = {
        PLAINTEXT_TEST_STR0_LEN,
        PLAINTEXT_TEST_STR1_LEN
    };

    // Expected ciphertext and auth tag output from running software main.c demo
    #define CIPHERTEXT_OUT_MAX_SIZE (PLAINTEXT_TEST_STR_MAX_SIZE + POLY1305_AUTH_TAG_SIZE)
    #define CIPHERTEXT0_SIZE (64 + POLY1305_AUTH_TAG_SIZE)
    uint8_t expected_ciphertext0[CIPHERTEXT_OUT_MAX_SIZE] = {
        // Ciphertext:
        0xd7, 0x1e, 0x85, 0x31, 0x6e, 0xdd, 0x03, 0xf2, 
        0x5c, 0xae, 0xc6, 0xb8, 0x5e, 0xe8, 0x7a, 0xdd,
        0xe1, 0xed, 0xa8, 0x68, 0x60, 0x73, 0x0b, 0xb9,
        0xa8, 0xeb, 0xa2, 0xe3, 0x75, 0xf6, 0x66, 0xc4,
        0x23, 0xb2, 0xeb, 0x54, 0xc9, 0xfa, 0x79, 0x58,
        0x98, 0xae, 0xd7, 0x7c, 0x8e, 0xfb, 0x26, 0x80,
        0x1c, 0x77, 0x92, 0x0f, 0xdb, 0x08, 0x09, 0x6e,
        0x60, 0xa4, 0x85, 0xcf, 0x11, 0xb8, 0x1b, 0x59,
        // Auth Tag: 
        0x5d, 0xa8, 0x7d, 0x6a, 0x2d, 0x03, 0xc9, 0xba,
        0xdf, 0x5c, 0xb9, 0x47, 0x74, 0x42, 0x12, 0x3f
    };
    #define CIPHERTEXT1_SIZE (80 + POLY1305_AUTH_TAG_SIZE)
    uint8_t expected_ciphertext1[CIPHERTEXT_OUT_MAX_SIZE] = {
        // Ciphertext:
        0xcf, 0x12, 0x99, 0x38, 0x6d, 0x94, 0x2e, 0xdf, 
        0x56, 0xc2, 0xe6, 0x88, 0x16, 0xf5, 0x62, 0xcb, 
        0xe1, 0xa2, 0xed, 0x4c, 0x7d, 0x21, 0x26, 0x9a, 
        0x91, 0xaa, 0xb1, 0xf5, 0x3a, 0xf7, 0x6d, 0xc1, 
        0x6e, 0xa4, 0xe2, 0x18, 0xe0, 0xeb, 0x2a, 0x0c, 
        0xcb, 0xfa, 0xd5, 0x60, 0xda, 0x98, 0x1a, 0xa1, 
        0x39, 0x4d, 0xf1, 0x06, 0xd7, 0x19, 0x1e, 0x6f, 
        0x37, 0xcd, 0xf7, 0xaa, 0x76, 0xcd, 0x7a, 0x2b, 
        0x98, 0x91, 0xb0, 0x3a, 0x23, 0x74, 0xcf, 0xac, 
        0xec, 0x6a, 0xde, 0xc3, 0x4e, 0x66, 0x69, 0x78,
        // Auth Tag:
        0x07, 0xc7, 0xe3, 0x1f, 0x0f, 0xeb, 0x4b, 0x61, 
        0xea, 0x2d, 0xd2, 0xa4, 0x59, 0x7c, 0xae, 0xe9
    };
    uint8_t expected_ciphertexts[NUM_PLAINTEXT_TEST_STRS][CIPHERTEXT_OUT_MAX_SIZE] = {
        expected_ciphertext0,
        expected_ciphertext1
    };
    uint32_t ciphertext_lens[NUM_PLAINTEXT_TEST_STRS] = {
        CIPHERTEXT0_SIZE,
        CIPHERTEXT1_SIZE
    };

    // Connect CSR inputs to dut
    chacha20poly1305_encrypt_key = key;
    chacha20poly1305_encrypt_nonce = nonce;
    chacha20poly1305_encrypt_aad = aad;
    chacha20poly1305_encrypt_aad_len = aad_len;

    // Registers for the input side of testbench state machine
    static uint32_t input_packet_count;
    static char plaintext[PLAINTEXT_TEST_STR_MAX_SIZE];
    static uint32_t plaintext_remaining;
    static uint32_t cycle_counter;

    // Encrypt:
    if(cycle_counter == 0)
    {
        printf("=== ChaCha20-Poly1305 Encryption Test ===\n");
        // Print test inputs
        PRINT_32_BYTES("Encrypt Key: ", key)
        PRINT_12_BYTES("Encrypt Nonce: ", nonce)
        print_aad(aad, aad_len);
        // Init regs with first test string
        plaintext = plaintexts[input_packet_count];
        plaintext_remaining = plaintext_lens[input_packet_count];
        printf("Encrypting test string %d...\n", input_packet_count);
    }

    // Stream plaintext into dut
    chacha20poly1305_encrypt_axis_in.valid = 0;
    // Have valid data if there is more plaintext to send
    if(plaintext_remaining > 0)
    {
        // Up to 16 bytes of plaintext onto axis128
        // padded with zeros if needed
        for(int32_t i=0; i<16; i+=1)
        {
            chacha20poly1305_encrypt_axis_in.data.tkeep[i] = 1;
            chacha20poly1305_encrypt_axis_in.data.tdata[i] = 0;
            if(plaintext_remaining > i)
            {
                chacha20poly1305_encrypt_axis_in.data.tdata[i] = plaintext[i];
            }
        }
        chacha20poly1305_encrypt_axis_in.data.tlast = (plaintext_remaining <= 16);
        chacha20poly1305_encrypt_axis_in.valid = 1;
        if(chacha20poly1305_encrypt_axis_in.valid & chacha20poly1305_encrypt_axis_in_ready)
        {
            PRINT_16_BYTES("Encrypt: Input Plaintext next 16 bytes: ", chacha20poly1305_encrypt_axis_in.data.tdata)
            if(chacha20poly1305_encrypt_axis_in.data.tlast){
                printf("Encrypt: End of input plaintext for test %d\n", input_packet_count);
                plaintext_remaining = 0;
                input_packet_count += 1;
                if(input_packet_count < NUM_PLAINTEXT_TEST_STRS)
                {
                    // Reset for next test string
                    plaintext = plaintexts[input_packet_count];
                    plaintext_remaining = plaintext_lens[input_packet_count];
                    printf("Encrypting next test string %d...\n", input_packet_count);
                }
            }else{
                plaintext_remaining -= 16;
                ARRAY_SHIFT_DOWN(plaintext, PLAINTEXT_TEST_STR_MAX_SIZE, 16)
            }
        }
    }
    
    // Registers for the output side of testbench state machine
    static uint32_t output_packet_count;
    static uint32_t ciphertext_size;
    static uint32_t ciphertext_remaining;
    static uint8_t expected_ciphertext[CIPHERTEXT_OUT_MAX_SIZE];

    // Check encrypted ciphertext output:
    if(cycle_counter == 0)
    {
        // Init regs for first test string
        expected_ciphertext = expected_ciphertexts[output_packet_count];
        ciphertext_size = ciphertext_lens[output_packet_count];
        ciphertext_remaining = ciphertext_size;
        printf("Encrypt: Checking ciphertext for test string %d...\n", output_packet_count);
    }

    // Stream ciphertext out of dut
    chacha20poly1305_encrypt_axis_out_ready = 1;
    if(chacha20poly1305_encrypt_axis_out.valid & chacha20poly1305_encrypt_axis_out_ready)
    {
        // Print ciphertext as it flows out of dut
        PRINT_16_BYTES("Encrypt: Output Ciphertext next 16 bytes: ", chacha20poly1305_encrypt_axis_out.data.tdata)
        // compare to expected_ciphertext and shift
        for(int32_t i = 0; i<16; i+=1)
        {
            if(ciphertext_remaining > i)
            {
                if(chacha20poly1305_encrypt_axis_out.data.tdata[i] != expected_ciphertext[i])
                {
                    uint32_t ciphertext_pos = (ciphertext_size-ciphertext_remaining) + i;
                    printf("ERROR: Encrypt: Ciphertext mismatch at byte[%d]. expected 0x%X got 0x%X\n", 
                           ciphertext_pos, expected_ciphertext[i], chacha20poly1305_encrypt_axis_out.data.tdata[i]);
                }
            }
        }
        // Too much data?
        if(ciphertext_remaining == 0){
            printf("ERROR: Encrypt: Extra ciphertext output!\n");
        }
        // Too little data? Or more to come?
        if(chacha20poly1305_encrypt_axis_out.data.tlast){
            if(ciphertext_remaining > 16){
                printf("ERROR: Encrypt: Early end to ciphertext output!\n");
            }else{
                printf("Encrypt: Test %d DONE!\n", output_packet_count);
                ciphertext_remaining = 0;
                output_packet_count += 1;
                if(output_packet_count < NUM_PLAINTEXT_TEST_STRS)
                {
                    // Reset for next test string
                    expected_ciphertext = expected_ciphertexts[output_packet_count];
                    ciphertext_size = ciphertext_lens[output_packet_count];
                    ciphertext_remaining = ciphertext_size;
                    printf("Encrypt: Checking ciphertext for next test string %d...\n", output_packet_count);
                }
            }
        }else{
            ciphertext_remaining -= 16;
            ARRAY_SHIFT_DOWN(expected_ciphertext, CIPHERTEXT_OUT_MAX_SIZE, 16)
        }   
    }

    cycle_counter += 1;

    // dummy return for synthesis
    // so everything doesnt optimize away
    return chacha20poly1305_encrypt_axis_out;
}
