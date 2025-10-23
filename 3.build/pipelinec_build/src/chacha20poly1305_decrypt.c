/**
 * WIP
 * based on code from
 * https://github.com/chili-chips-ba/wireguard-fpga/blob/main/2.sw/app/chacha20poly1305/
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
// Instance of the appending auth tag part of decryption
#include "append_auth_tag/append_auth_tag.c"

// The primary dataflow for single clock domain ChaCha20-Poly1305 decryption
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T
#pragma MAIN_MHZ main 80.0
void main(){
    // Connect chacha20poly1305_decrypt_* input stream to chacha20_decrypt
    chacha20_decrypt_axis_in = chacha20poly1305_decrypt_axis_in;
    chacha20poly1305_decrypt_axis_in_ready = chacha20_decrypt_axis_in_ready;
    chacha20_decrypt_key = chacha20poly1305_decrypt_key;
    chacha20_decrypt_nonce = chacha20poly1305_decrypt_nonce;

    // Connect chacha20_decrypt output poly key into poly1305_mac key input
    poly1305_mac_key = chacha20_decrypt_poly_key;
    chacha20_decrypt_poly_key_ready = poly1305_mac_key_ready;

    // Connect chacha20_decrypt ciphertext output to both
    //  prep_auth_data input
    //  append auth tag input
    // Fork the stream by combining valids and readys
    //  default no data passing, invalidate passthrough
    prep_auth_data_axis_in = chacha20_decrypt_axis_out;
    prep_auth_data_axis_in.valid = 0;
    append_auth_tag_axis_in = chacha20_decrypt_axis_out;
    append_auth_tag_axis_in.valid = 0;
    //  allow pass through if both sinks are ready
    //  or if sink isnt ready (no data passing anyway)
    chacha20_decrypt_axis_out_ready = prep_auth_data_axis_in_ready & append_auth_tag_axis_in_ready;
    if(chacha20_decrypt_axis_out_ready | ~prep_auth_data_axis_in_ready){
        prep_auth_data_axis_in.valid = chacha20_decrypt_axis_out.valid;
    }
    if(chacha20_decrypt_axis_out_ready | ~append_auth_tag_axis_in_ready){
        append_auth_tag_axis_in.valid = chacha20_decrypt_axis_out.valid;
    }

    // Prep auth data CSR inputs
    prep_auth_data_aad = chacha20poly1305_decrypt_aad;
    prep_auth_data_aad_len = chacha20poly1305_decrypt_aad_len;

    // Connect prep_auth_data output to poly1305_mac input
    poly1305_mac_data_in = prep_auth_data_axis_out;
    prep_auth_data_axis_out_ready = poly1305_mac_data_in_ready;

    // Connect poly1305_mac auth tag output to append auth tag input
    append_auth_tag_auth_tag_in = poly1305_mac_auth_tag;
    poly1305_mac_auth_tag_ready = append_auth_tag_auth_tag_in_ready;
    
    // Connect append auth tag output to chacha20poly1305_decrypt_* output
    chacha20poly1305_decrypt_axis_out = append_auth_tag_axis_out;
    append_auth_tag_axis_out_ready = chacha20poly1305_decrypt_axis_out_ready;
}
