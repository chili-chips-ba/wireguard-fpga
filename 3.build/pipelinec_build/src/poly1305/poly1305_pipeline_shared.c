#include "poly1305.h"
#include "global_func_inst.h"

// Replace encrypt vs decrypt specific compute instance with shared one just named poly1305_mac_compute
// Macro includes ID bits to encode is_encrypt
GLOBAL_PIPELINE_INST_W_VALID_ID(poly1305_mac_compute, u320_t, poly1305_mac_loop_body, poly1305_mac_loop_body_in_t)

// Expose global interface that looks like indivdual computes with names including encrypt vs decrypt
stream(poly1305_mac_loop_body_in_t) poly1305_mac_encrypt_compute_in;
uint1_t poly1305_mac_encrypt_compute_in_ready;
stream(poly1305_mac_loop_body_in_t) poly1305_mac_decrypt_compute_in;
uint1_t poly1305_mac_decrypt_compute_in_ready;
stream(u320_t) poly1305_mac_encrypt_compute_out;
uint1_t poly1305_mac_encrypt_compute_out_ready;
stream(u320_t) poly1305_mac_decrypt_compute_out;
uint1_t poly1305_mac_decrypt_compute_out_ready;

// Muxing logic at input and output of compute
#pragma MAIN poly1305_mac_sharing_mux
void poly1305_mac_sharing_mux(){
  // Default no data flowing
  poly1305_mac_compute_in_valid = 0; // into compute
  //poly1305_mac_compute_out_ready = 0; // from compute
  poly1305_mac_encrypt_compute_out.valid = 0; // to encrypt
  poly1305_mac_encrypt_compute_in_ready = 0; // from encrypt
  poly1305_mac_decrypt_compute_out.valid = 0; // to decrypt
  poly1305_mac_decrypt_compute_in_ready = 0; // from decrypt

  // Input side state toggles round robin
  static uint1_t is_encrypt;
  poly1305_mac_compute_in_id = is_encrypt;
  if(is_encrypt){
    poly1305_mac_compute_in = poly1305_mac_encrypt_compute_in.data;
    poly1305_mac_compute_in_valid = poly1305_mac_encrypt_compute_in.valid;
    poly1305_mac_encrypt_compute_in_ready = 1; //poly1305_mac_compute_in_ready;
  }else{
    poly1305_mac_compute_in = poly1305_mac_decrypt_compute_in.data;
    poly1305_mac_compute_in_valid = poly1305_mac_decrypt_compute_in.valid;
    poly1305_mac_decrypt_compute_in_ready = 1; //poly1305_mac_compute_in_ready;
  }
  is_encrypt = ~is_encrypt;

  // Output side muxing based on id flag out of compute
  if(poly1305_mac_compute_out_valid){
    if(poly1305_mac_compute_out_id){ // is_encrypt
      poly1305_mac_encrypt_compute_out.data = poly1305_mac_compute_out;
      poly1305_mac_encrypt_compute_out.valid = poly1305_mac_compute_out_valid;
      //poly1305_mac_compute_out_ready = poly1305_mac_encrypt_compute_out_ready;
    }else{
      poly1305_mac_decrypt_compute_out.data = poly1305_mac_compute_out;
      poly1305_mac_decrypt_compute_out.valid = poly1305_mac_compute_out_valid;
      //poly1305_mac_compute_out_ready = poly1305_mac_decrypt_compute_out_ready;
    }
  }
}