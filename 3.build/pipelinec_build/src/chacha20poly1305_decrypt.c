/**
 * Decryption Pipeline for ChaCha20-Poly1305
*/
#include "arrays.h"
// Top level IO port config, named like chacha20poly1305_decrypt_*
#include "chacha20poly1305_decrypt.h"
// Instance of chacha20 part of decryption
#include "chacha20/chacha20.c"
// Instance of preparing auth data part of decryption
#include "prep_auth_data/prep_auth_data.c"
// Instance of poly1305 part of decryption
#include "poly1305/poly1305_mac.c"
// Instance of the poly1305 verification block
#include "poly1305/poly1305_verify_decrypt.c"
// Instance of strip auth tag
#include "auth_tag/strip_auth_tag.c"
// Instance wait to verify block 
#include "auth_tag/wait_to_verify.c"


// The primary dataflow for single clock domain ChaCha20-Poly1305 decryption
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T
#pragma MAIN_MHZ main 80.0
void main(){

    // Strip auth tag (splits input streams)
    // Connect chacha20poly1305_decrypt_* input stream to strip_auth_tag
    strip_auth_tag_axis_in = chacha20poly1305_decrypt_axis_in;
    chacha20poly1305_decrypt_axis_in_ready = strip_auth_tag_axis_in_ready;


    // Poly1305 key generation and MAC connection
    // The key goes to chacha20 first to generate the Poly1305 key
    // Corrected to use chacha20_key/nonce based on chacha20.c definition
    chacha20_key = chacha20poly1305_decrypt_key;
    chacha20_nonce = chacha20poly1305_decrypt_nonce;

    // Connect chacha20 poly key output to poly1305_mac key input
    poly1305_mac_key = chacha20_poly_key;
    chacha20_poly_key_ready = poly1305_mac_key_ready;


    // Ciphertext stream fork
    // The stripped ciphertext stream must be forked to two consumers:
    // a) prep_auth_data (for MAC calculation)
    // b) chacha20 (for actual decryption)

    // Default: no data passing
    prep_auth_data_axis_in.valid = 0;
    chacha20_axis_in.valid = 0; 

    // The source (strip_auth_tag_axis_out) is ready only if both sinks are ready
    strip_auth_tag_axis_out_ready = prep_auth_data_axis_in_ready & chacha20_axis_in_ready; 
    // If a sink is not ready its allowed to see the pending valid=1 since no transfer happens anyway
    if (strip_auth_tag_axis_out.valid){
      if (strip_auth_tag_axis_out_ready | ~prep_auth_data_axis_in_ready){ 
        prep_auth_data_axis_in.valid = 1;
      }
      if (strip_auth_tag_axis_out_ready | ~chacha20_axis_in_ready ){
        chacha20_axis_in.valid = 1; 
      }
    }

    // Connect data streams
    prep_auth_data_axis_in.data = strip_auth_tag_axis_out.data;
    chacha20_axis_in.data = strip_auth_tag_axis_out.data;

    // Prepare auth data and calculate MAC
    // prep_auth_data CSR inputs
    prep_auth_data_aad = chacha20poly1305_decrypt_aad;
    prep_auth_data_aad_len = chacha20poly1305_decrypt_aad_len;

    // Connect prep_auth_data output to poly1305_mac input
    poly1305_mac_data_in = prep_auth_data_axis_out;
    prep_auth_data_axis_out_ready = poly1305_mac_data_in_ready;


    // Poly1305 verification
    // Connect strip_auth_tag (input tag) and poly1305_mac (calculated tag) to poly1305_verify
    poly1305_verify_auth_tag = strip_auth_tag_auth_tag_out; 
    strip_auth_tag_auth_tag_out_ready = poly1305_verify_auth_tag_ready;

    poly1305_verify_calc_tag = poly1305_mac_auth_tag;
    poly1305_mac_auth_tag_ready = poly1305_verify_calc_tag_ready;


    // Wait to verify (buffer plaintext)
    // Connect chacha20 decrypt output (plaintext stream) to wait_to_verify input (buffering FIFO)
    wait_to_verify_axis_in = chacha20_axis_out; 
    chacha20_axis_out_ready = wait_to_verify_axis_in_ready; 

    // Connect poly1305_verify output (result bit) to wait_to_verify trigger input
    wait_to_verify_verify_bit = poly1305_verify_tags_match;
    poly1305_verify_tags_match_ready = wait_to_verify_verify_bit_ready;

    // Connect wait_to_verify output to the top-level final output
    chacha20poly1305_decrypt_axis_out = wait_to_verify_axis_out;
    wait_to_verify_axis_out_ready = chacha20poly1305_decrypt_axis_out_ready;

    // Connect final verification result parallel wire
    chacha20poly1305_decrypt_is_verified_out = wait_to_verify_is_verified_out;
}