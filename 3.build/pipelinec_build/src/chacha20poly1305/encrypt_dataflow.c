// The primary dataflow for single clock domain ChaCha20-Poly1305 encryption
#pragma MAIN_MHZ encrypt_dataflow 80.0
void encrypt_dataflow(){
    // Connect chacha20poly1305_encrypt_* input stream to chacha20
    chacha20_axis_in = chacha20poly1305_encrypt_axis_in;
    chacha20poly1305_encrypt_axis_in_ready = chacha20_axis_in_ready;
    chacha20_key = chacha20poly1305_encrypt_key;
    chacha20_nonce = chacha20poly1305_encrypt_nonce;

    // Connect chacha20 output poly key into poly1305_mac key input
    poly1305_mac_key = chacha20_poly_key;
    chacha20_poly_key_ready = poly1305_mac_key_ready;

    // Connect chacha20 ciphertext output to both
    //  prep_auth_data input
    //  append auth tag input
    // Fork the stream by combining valids and readys
    //  default no data passing, invalidate passthrough
    prep_auth_data_encrypt_axis_in = chacha20_axis_out;
    prep_auth_data_encrypt_axis_in.valid = 0;
    append_auth_tag_axis_in = chacha20_axis_out;
    append_auth_tag_axis_in.valid = 0;
    //  allow pass through if both sinks are ready
    //  or if sink isnt ready (no data passing anyway)
    chacha20_axis_out_ready = prep_auth_data_encrypt_axis_in_ready & append_auth_tag_axis_in_ready;
    if(chacha20_axis_out_ready | ~prep_auth_data_encrypt_axis_in_ready){
        prep_auth_data_encrypt_axis_in.valid = chacha20_axis_out.valid;
    }
    if(chacha20_axis_out_ready | ~append_auth_tag_axis_in_ready){
        append_auth_tag_axis_in.valid = chacha20_axis_out.valid;
    }

    // Prep auth data CSR inputs
    prep_auth_data_encrypt_aad = chacha20poly1305_encrypt_aad;
    prep_auth_data_encrypt_aad_len = chacha20poly1305_encrypt_aad_len;

    // Connect prep_auth_data output to poly1305_mac input
    poly1305_mac_data_in = prep_auth_data_encrypt_axis_out;
    prep_auth_data_encrypt_axis_out_ready = poly1305_mac_data_in_ready;

    // Connect poly1305_mac auth tag output to append auth tag input
    append_auth_tag_auth_tag_in = poly1305_mac_auth_tag;
    poly1305_mac_auth_tag_ready = append_auth_tag_auth_tag_in_ready;
    
    // Connect append auth tag output to chacha20poly1305_encrypt_* output
    chacha20poly1305_encrypt_axis_out = append_auth_tag_axis_out;
    append_auth_tag_axis_out_ready = chacha20poly1305_encrypt_axis_out_ready;
}
