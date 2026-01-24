// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "chacha20.h"
#include "global_func_inst.h"

// Replace encrypt vs decrypt specific pipeline instance with shared one just named chacha20_pipeline
// Pipeline takes same input and output as before but wrapped with ID for is encrypt vs decrypt
typedef struct chacha_shared_pipeline_in_t{
  chacha20_loop_body_in_t data;
  uint1_t is_encrypt;
}chacha_shared_pipeline_in_t;
DECL_STREAM_TYPE(chacha_shared_pipeline_in_t)
typedef struct chacha_shared_pipeline_out_t{
  axis512_t data;
  uint1_t is_encrypt;
}chacha_shared_pipeline_out_t;
DECL_STREAM_TYPE(chacha_shared_pipeline_out_t)
// Pipeline function is same as old function by passing through ID from input to output
chacha_shared_pipeline_out_t chacha_shared_pipeline(chacha_shared_pipeline_in_t inputs){
  chacha_shared_pipeline_out_t outputs;
  outputs.data = chacha20_loop_body(inputs.data);
  outputs.is_encrypt = inputs.is_encrypt;
  return outputs;
}
// TODO use macro that includes ID instead like poly1305?
GLOBAL_VALID_READY_PIPELINE_INST(chacha20_pipeline, chacha_shared_pipeline_out_t, chacha_shared_pipeline, chacha_shared_pipeline_in_t, 64)

// Expose global interface that looks like indivdual pipelines with names including encrypt vs decrypt
stream(chacha20_loop_body_in_t) chacha20_encrypt_pipeline_in;
uint1_t chacha20_encrypt_pipeline_in_ready;
stream(chacha20_loop_body_in_t) chacha20_decrypt_pipeline_in;
uint1_t chacha20_decrypt_pipeline_in_ready;
stream(axis512_t) chacha20_encrypt_pipeline_out;
uint1_t chacha20_encrypt_pipeline_out_ready;
stream(axis512_t) chacha20_decrypt_pipeline_out;
uint1_t chacha20_decrypt_pipeline_out_ready;

// Muxing logic at input and output of pipeline
#pragma MAIN chacha20_sharing_mux
void chacha20_sharing_mux(){
  // Default no data flowing
  chacha20_pipeline_in.valid = 0; // into pipeline
  chacha20_pipeline_out_ready = 0; // from pipeline
  chacha20_encrypt_pipeline_out.valid = 0; // to encrypt
  chacha20_encrypt_pipeline_in_ready = 0; // from encrypt
  chacha20_decrypt_pipeline_out.valid = 0; // to decrypt
  chacha20_decrypt_pipeline_in_ready = 0; // from decrypt

  // Input side state toggles round robin
  static uint1_t is_encrypt;
  chacha20_pipeline_in.data.is_encrypt = is_encrypt;
  if(is_encrypt){
    chacha20_pipeline_in.data.data = chacha20_encrypt_pipeline_in.data;
    chacha20_pipeline_in.valid = chacha20_encrypt_pipeline_in.valid;
    chacha20_encrypt_pipeline_in_ready = chacha20_pipeline_in_ready;
  }else{
    chacha20_pipeline_in.data.data = chacha20_decrypt_pipeline_in.data;
    chacha20_pipeline_in.valid = chacha20_decrypt_pipeline_in.valid;
    chacha20_decrypt_pipeline_in_ready = chacha20_pipeline_in_ready;
  }
  is_encrypt = ~is_encrypt;

  // Output side muxing based on id flag out of pipeline
  if(chacha20_pipeline_out.valid){
    if(chacha20_pipeline_out.data.is_encrypt){
      chacha20_encrypt_pipeline_out.data = chacha20_pipeline_out.data.data;
      chacha20_encrypt_pipeline_out.valid = chacha20_pipeline_out.valid;
      chacha20_pipeline_out_ready = chacha20_encrypt_pipeline_out_ready;
    }else{
      chacha20_decrypt_pipeline_out.data = chacha20_pipeline_out.data.data;
      chacha20_decrypt_pipeline_out.valid = chacha20_pipeline_out.valid;
      chacha20_pipeline_out_ready = chacha20_decrypt_pipeline_out_ready;
    }
  }
}
