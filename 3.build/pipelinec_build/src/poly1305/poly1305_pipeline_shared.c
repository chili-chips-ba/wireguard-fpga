#include "poly1305.h"
#include "global_func_inst.h"

// Replace encrypt vs decrypt specific pipeline instance with shared one just named poly1305_mac_pipeline
// Macro includes ID bits to encode is_encrypt
GLOBAL_PIPELINE_INST_W_VALID_ID(poly1305_mac_pipeline, u320_t, poly1305_mac_loop_body, poly1305_mac_loop_body_in_t)

// Expose global interface that looks like indivdual pipelines with names including encrypt vs decrypt
poly1305_mac_loop_body_in_t poly1305_mac_encrypt_pipeline_in;
uint1_t poly1305_mac_encrypt_pipeline_in_valid;
uint1_t poly1305_mac_encrypt_pipeline_in_ready;
poly1305_mac_loop_body_in_t poly1305_mac_decrypt_pipeline_in;
uint1_t poly1305_mac_decrypt_pipeline_in_valid;
uint1_t poly1305_mac_decrypt_pipeline_in_ready;
u320_t poly1305_mac_encrypt_pipeline_out;
uint1_t poly1305_mac_encrypt_pipeline_out_valid;
uint1_t poly1305_mac_encrypt_pipeline_out_ready;
u320_t poly1305_mac_decrypt_pipeline_out;
uint1_t poly1305_mac_decrypt_pipeline_out_valid;
//uint1_t poly1305_mac_decrypt_pipeline_out_ready;

// Muxing logic at input and output of pipeline
#pragma MAIN poly1305_mac_sharing_mux
void poly1305_mac_sharing_mux(){
  // Default no data flowing
  poly1305_mac_pipeline_in_valid = 0; // into pipeline
  //poly1305_mac_pipeline_out_ready = 0; // from pipeline
  poly1305_mac_encrypt_pipeline_out_valid = 0; // to encrypt
  poly1305_mac_encrypt_pipeline_in_ready = 0; // from encrypt
  poly1305_mac_decrypt_pipeline_out_valid = 0; // to decrypt
  poly1305_mac_decrypt_pipeline_in_ready = 0; // from decrypt

  // Input side state toggles round robin
  static uint1_t is_encrypt;
  poly1305_mac_pipeline_in_id = is_encrypt;
  if(is_encrypt){
    poly1305_mac_pipeline_in = poly1305_mac_encrypt_pipeline_in;
    poly1305_mac_pipeline_in_valid = poly1305_mac_encrypt_pipeline_in_valid;
    poly1305_mac_encrypt_pipeline_in_ready = 1; //poly1305_mac_pipeline_in_ready;
  }else{
    poly1305_mac_pipeline_in = poly1305_mac_decrypt_pipeline_in;
    poly1305_mac_pipeline_in_valid = poly1305_mac_decrypt_pipeline_in_valid;
    poly1305_mac_decrypt_pipeline_in_ready = 1; //poly1305_mac_pipeline_in_ready;
  }
  is_encrypt = ~is_encrypt;

  // Output side muxing based on id flag out of pipeline
  if(poly1305_mac_pipeline_out_valid){
    if(poly1305_mac_pipeline_out_id){ // is_encrypt
      poly1305_mac_encrypt_pipeline_out = poly1305_mac_pipeline_out;
      poly1305_mac_encrypt_pipeline_out_valid = poly1305_mac_pipeline_out_valid;
      //poly1305_mac_pipeline_out_ready = poly1305_mac_encrypt_pipeline_out_ready;
    }else{
      poly1305_mac_decrypt_pipeline_out = poly1305_mac_pipeline_out;
      poly1305_mac_decrypt_pipeline_out_valid = poly1305_mac_pipeline_out_valid;
      //poly1305_mac_pipeline_out_ready = poly1305_mac_decrypt_pipeline_out_ready;
    }
  }
}