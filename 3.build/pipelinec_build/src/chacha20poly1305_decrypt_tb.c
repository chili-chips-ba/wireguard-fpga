/*
 * Testbench for ChaCha20-Poly1305 Decryption
 */

#define SIMULATION
#include "chacha20poly1305_decrypt.c"

// Annoying fixed array sized single string printf funcs
// trying to match software print_hex
#define PRINT_32_BYTES(label, array) \
uint256_t PRINT_32_BYTES_uint = uint8_array32_be(array); \
printf(label \
    "%08X%08X%08X%08X%08X%08X%08X%08X\n", \
    PRINT_32_BYTES_uint >> (8*28), \
    PRINT_32_BYTES_uint >> (8*24), \
    PRINT_32_BYTES_uint >> (8*20), \
    PRINT_32_BYTES_uint >> (8*16), \
    PRINT_32_BYTES_uint >> (8*12), \
    PRINT_32_BYTES_uint >> (8*8), \
    PRINT_32_BYTES_uint >> (8*4), \
    PRINT_32_BYTES_uint >> (8*0) \
);

#define PRINT_16_BYTES(label, array) \
uint128_t PRINT_16_BYTES_uint = uint8_array16_be(array); \
printf(label \
    "%08X%08X%08X%08X\n", \
    PRINT_16_BYTES_uint >> (8*12), \
    PRINT_16_BYTES_uint >> (8*8), \
    PRINT_16_BYTES_uint >> (8*4), \
    PRINT_16_BYTES_uint >> (8*0) \
);

#define PRINT_12_BYTES(label, array) \
uint96_t PRINT_12_BYTES_uint = uint8_array12_be(array); \
printf(label \
    "%08X%08X%08X\n", \
    PRINT_12_BYTES_uint >> (8*8), \
    PRINT_12_BYTES_uint >> (8*4), \
    PRINT_12_BYTES_uint >> (8*0) \
);

void print_aad(uint8_t aad[AAD_MAX_LEN], uint32_t aad_len)
{
    // 32 chars
    printf("AAD (%u bytes): "
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "%c%c%c%c"
        "\n",
        aad_len,
        aad[0], aad[1], aad[2], aad[3],
        aad[4], aad[5], aad[6], aad[7],
        aad[8], aad[9], aad[10], aad[11],
        aad[12], aad[13], aad[14], aad[15],
        aad[16], aad[17], aad[18], aad[19],
        aad[20], aad[21], aad[22], aad[23],
        aad[24], aad[25], aad[26], aad[27],
        aad[28], aad[29], aad[30], aad[31]
    );
}

// CSR values available all at once do not need to be static=registers
// Streaming inputs data is done as shift register
#pragma MAIN tb
stream(axis128_t) tb()
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
    
    /*
     * We define the expected outputs (Plaintext) 
     */
    #define NUM_PACKETS 2
    #define PLAINTEXT_MAX_SIZE 128
    #define EXPECTED_PLAINTEXT_STR0 "Hello CHILIChips - Wireguard team, let's test this aead!"
    #define EXPECTED_PLAINTEXT_STR0_LEN strlen(EXPECTED_PLAINTEXT_STR0)
    #define EXPECTED_PLAINTEXT_STR1 "PipelineC is the best HDL around :) Let's go CHILIChips Wireguard team!"
    #define EXPECTED_PLAINTEXT_STR1_LEN strlen(EXPECTED_PLAINTEXT_STR1)

    char plaintexts[NUM_PACKETS][PLAINTEXT_MAX_SIZE] = {
        EXPECTED_PLAINTEXT_STR0,
        EXPECTED_PLAINTEXT_STR1
    };
    uint32_t plaintext_lens[NUM_PACKETS] = {
        EXPECTED_PLAINTEXT_STR0_LEN,
        EXPECTED_PLAINTEXT_STR1_LEN
    };

    /*
     * We define the input ciphertext and auth_tag (combined into one stream)
     */
    #define CIPHERTEXT_MAX_SIZE (PLAINTEXT_MAX_SIZE + POLY1305_AUTH_TAG_SIZE)
    #define CIPHERTEXT0_SIZE (64 + POLY1305_AUTH_TAG_SIZE)
    uint8_t input_ciphertext0[CIPHERTEXT_MAX_SIZE] = {
        // Ciphertext:
        0xd7, 0x1e, 0x85, 0x31, 0x6e, 0xdd, 0x03, 0xf2, 
        0x5c, 0xae, 0xc6, 0xb8, 0x5e, 0xe8, 0x7a, 0xdd,
        0xe1, 0xed, 0xa8, 0x68, 0x60, 0x73, 0x0b, 0xb9,
        0xa8, 0xeb, 0xa2, 0xe3, 0x75, 0xf6, 0x66, 0xc4,
        0x23, 0xb2, 0xeb, 0x54, 0xc9, 0xfa, 0x79, 0x58,
        0x98, 0xae, 0xd7, 0x7c, 0x8e, 0xfb, 0x26, 0x80,
        0x1c, 0x77, 0x92, 0x0f, 0xdb, 0x08, 0x09, 0x6e,
        0x60, 0xa4, 0x85, 0xcf, 0x11, 0xb8, 0x1b, 0x59,
        // Auth Tag (tlast=1 for this block): 
        0x5d, 0xa8, 0x7d, 0x6a, 0x2d, 0x03, 0xc9, 0xba,
        0xdf, 0x5c, 0xb9, 0x47, 0x74, 0x42, 0x12, 0x3f
    };
    #define CIPHERTEXT1_SIZE (80 + POLY1305_AUTH_TAG_SIZE)
    uint8_t input_ciphertext1[CIPHERTEXT_MAX_SIZE] = {
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
    uint8_t input_ciphertexts[NUM_PACKETS][CIPHERTEXT_MAX_SIZE] = {
        input_ciphertext0,
        input_ciphertext1
    };
    uint32_t ciphertext_lens[NUM_PACKETS] = {
        CIPHERTEXT0_SIZE,
        CIPHERTEXT1_SIZE
    };

    // Connect CSR inputs to dut
    chacha20poly1305_decrypt_key = key;
    chacha20poly1305_decrypt_nonce = nonce;
    chacha20poly1305_decrypt_aad = aad;
    chacha20poly1305_decrypt_aad_len = aad_len;

    // --- Input State Machine (Streams CIPHERTEXT) ---
    static uint32_t input_packet_count;
    // Note: Must be static array for array assignment (equals sign) to work
    static uint8_t ciphertext_in_stream[CIPHERTEXT_MAX_SIZE];
    static uint32_t ciphertext_remaining_in;
    static uint32_t cycle_counter;

    // --- Output State Machine (Checks PLAINTEXT) ---
    static uint32_t output_packet_count;
    static uint32_t plaintext_out_size;
    static uint32_t plaintext_remaining_out;
    static char plaintext_out_expected[PLAINTEXT_MAX_SIZE]; 
    static uint1_t tag_match_checked;

    // Initialize/Reset Logic
    if(cycle_counter == 0)
    {
        printf("=== ChaCha20-Poly1305 Decryption Test ===\n");
        // Print test inputs
        PRINT_32_BYTES("Key: ", key)
        PRINT_12_BYTES("Nonce: ", nonce)
        print_aad(aad, aad_len);
        
        // Init input regs with first test ciphertext
        ciphertext_in_stream = input_ciphertexts[input_packet_count]; 
        ciphertext_remaining_in = ciphertext_lens[input_packet_count];
        printf("Decrypting test string %u (Ciphertext size: %u)...\n", input_packet_count, ciphertext_remaining_in);

        // Init output regs with first expected plaintext
        plaintext_out_size = plaintext_lens[output_packet_count];
        plaintext_remaining_out = plaintext_out_size;
        
        plaintext_out_expected = plaintexts[output_packet_count];
        
        printf("Checking Plaintext for test string %u (Expected size: %u)...\n", output_packet_count, plaintext_out_size);
        tag_match_checked = 0;
    }

    // Stream ciphertext into dut
    chacha20poly1305_decrypt_axis_in.valid = 0;

    //DEBUGGING 
    printf("Length of remaining ciphertext: %d\n", ciphertext_remaining_in);
    
    // Have valid data if there is more ciphertext to send
    if(ciphertext_remaining_in > 0)
    {

        printf("Entering ciphertext_remaining_in > 0\n");
        // Up to 16 bytes of ciphertext/tag onto axis128
        for(int32_t i=0; i<16; i+=1)
        {
            chacha20poly1305_decrypt_axis_in.data.tkeep[i] = 1;
            chacha20poly1305_decrypt_axis_in.data.tdata[i] = 0; 
            if(ciphertext_remaining_in > i)
            {
                chacha20poly1305_decrypt_axis_in.data.tdata[i] = ciphertext_in_stream[i];
            }
        }
        // tlast is set when the remaining data is 16 bytes or less (i.e., the last block)
        chacha20poly1305_decrypt_axis_in.data.tlast = (ciphertext_remaining_in <= 16);
        chacha20poly1305_decrypt_axis_in.valid = 1;

        printf("chacha20poly1305_decrypt_axis_in.data.tlast = %u\n", chacha20poly1305_decrypt_axis_in.data.tlast);
        printf("chacha20poly1305_decrypt_axis_in.valid = %u\n", chacha20poly1305_decrypt_axis_in.valid);
        printf("chacha20poly1305_decrypt_axis_in_ready = %u\n", chacha20poly1305_decrypt_axis_in_ready);
        
        if(chacha20poly1305_decrypt_axis_in.valid ) //& chacha20poly1305_decrypt_axis_in_ready
        {
            PRINT_16_BYTES("Input Ciphertext/Tag next 16 bytes: ", chacha20poly1305_decrypt_axis_in.data.tdata)
            
            if(chacha20poly1305_decrypt_axis_in.data.tlast){
                printf("End of Ciphertext/Tag for test %u\n", input_packet_count);
                ciphertext_remaining_in = 0;
                input_packet_count += 1;
            } else {
                ciphertext_remaining_in -= 16;
                ARRAY_SHIFT_DOWN(ciphertext_in_stream, CIPHERTEXT_MAX_SIZE, 16)
            }
        }
    }
    
    // Testbench is ready to receive plaintext
    chacha20poly1305_decrypt_axis_out_ready = 1;

    if(chacha20poly1305_decrypt_axis_out.valid & chacha20poly1305_decrypt_axis_out_ready)
    {
        // Print plaintext as it flows out of dut
        PRINT_16_BYTES("Output Plaintext next 16 bytes: ", chacha20poly1305_decrypt_axis_out.data.tdata)
        
        // Compare to expected plaintext and shift expected array
        for(int32_t i = 0; i<16; i+=1)
        {
            if(plaintext_remaining_out > i)
            {
                if(chacha20poly1305_decrypt_axis_out.data.tdata[i] != plaintext_out_expected[i])
                {
                    uint32_t plaintext_pos = (plaintext_out_size-plaintext_remaining_out) + i;
                    printf("ERROR: Plaintext mismatch at byte[%u]. expected 0x%X got 0x%X\n", 
                           plaintext_pos, plaintext_out_expected[i], chacha20poly1305_decrypt_axis_out.data.tdata[i]);
                }
            }
        }
        
        // Handle stream end
        if(chacha20poly1305_decrypt_axis_out.data.tlast){
            if(plaintext_remaining_out > 16){
                printf("ERROR: Early end to Plaintext output!\n");
            } else {
                printf("Plaintext stream DONE for test %u.\n", output_packet_count);
                plaintext_remaining_out = 0;
            }
        }else{
            if(plaintext_remaining_out == 0){
                 printf("ERROR: Extra Plaintext output!\n");
            } else {
                plaintext_remaining_out -= 16;
                ARRAY_SHIFT_DOWN(plaintext_out_expected, PLAINTEXT_MAX_SIZE, 16)
            }
        }   
    }
    
    // Check the final authentication result after the stream is done
    if (plaintext_remaining_out == 0 && output_packet_count < NUM_PACKETS && !tag_match_checked)
    {
        if (chacha20poly1305_decrypt_is_verified_out == 1)
        {
            printf("SUCCESS: Test %u Authentication Tag MATCHES!\n", output_packet_count);
        } else {
            printf("FAILURE: Test %u Authentication Tag MISMATCHES!\n", output_packet_count);
        }

        // Reset for the next test vector if needed
        output_packet_count += 1;
        if(output_packet_count < NUM_PACKETS)
        {
            // Reset for next test vector (Only reset if the input flow is ready for the next packet too)
            if (input_packet_count == output_packet_count) {
                // Reset input regs with next test ciphertext
                ciphertext_in_stream = input_ciphertexts[input_packet_count]; 
                ciphertext_remaining_in = ciphertext_lens[input_packet_count];
                printf("Decrypting next test string %u (Ciphertext size: %u)...\n", input_packet_count, ciphertext_remaining_in);
                
                // Reset output regs with next expected plaintext
                plaintext_out_size = plaintext_lens[output_packet_count];
                plaintext_remaining_out = plaintext_out_size;
                
                plaintext_out_expected = plaintexts[output_packet_count];
                
                printf("Checking Plaintext for next test string %u (Expected size: %u)...\n", output_packet_count, plaintext_out_size);
            }
        }
        tag_match_checked = 1;
    }
    
    // If input flow is done and output flow is done, mark checked flag false for next run
    if (input_packet_count > output_packet_count) {
        tag_match_checked = 0;
    }

    cycle_counter += 1;

    // dummy return for synthesis
    // so everything doesnt optimize away
    return chacha20poly1305_decrypt_axis_out;
}