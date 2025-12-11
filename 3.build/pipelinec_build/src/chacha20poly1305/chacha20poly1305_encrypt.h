#pragma once
#include "compiler.h"
#include "../chacha20/chacha20.h"
#include "../prep_auth_data/prep_auth_data.h"
#include "../poly1305/poly1305.h"

#ifndef SIMULATION
// Flattened top level ports with AXIS style manager/subordinate naming
// (could also have inputs and outputs of type stream(my_axis_t)
//  but ex. Verilog does not support VHDL arrays or records...)
// Top level input wires
DECL_INPUT(key_uint_t, encrypt_key)
DECL_INPUT(nonce_uint_t, encrypt_nonce)
DECL_INPUT(aad_uint_t, encrypt_aad)
DECL_INPUT(uint8_t, encrypt_aad_len)
// Top level input stream of plaintext
DECL_INPUT(uint128_t, encrypt_s_axis_tdata)
DECL_INPUT(uint16_t, encrypt_s_axis_tkeep)
DECL_INPUT(uint1_t, encrypt_s_axis_tlast)
DECL_INPUT(uint1_t, encrypt_s_axis_tvalid)
DECL_OUTPUT(uint1_t, encrypt_s_axis_tready)
// Top level output stream of ciphertext w/ auth tag
DECL_OUTPUT(uint128_t, encrypt_m_axis_tdata)
DECL_OUTPUT(uint16_t, encrypt_m_axis_tkeep)
DECL_OUTPUT(uint1_t, encrypt_m_axis_tlast)
DECL_OUTPUT(uint1_t, encrypt_m_axis_tvalid)
DECL_INPUT(uint1_t, encrypt_m_axis_tready)
#endif

// Nice struct/array type globally visible wires to use instead of flattened top level ports
// in simluation these wires are driven by the testbench
// in hardware these wires are driven by the top level ports
stream(axis128_t) chacha20poly1305_encrypt_axis_in; // input
uint1_t chacha20poly1305_encrypt_axis_in_ready; // output
uint8_t chacha20poly1305_encrypt_key[CHACHA20_KEY_SIZE]; // input
uint8_t chacha20poly1305_encrypt_nonce[CHACHA20_NONCE_SIZE]; // input
uint8_t chacha20poly1305_encrypt_aad[AAD_MAX_LEN]; // input
uint8_t chacha20poly1305_encrypt_aad_len; // input
stream(axis128_t) chacha20poly1305_encrypt_axis_out; // output
uint1_t chacha20poly1305_encrypt_axis_out_ready; // input

// For real hardware connect top level ports to these wires
#ifndef SIMULATION
#pragma MAIN chacha20poly1305_encrypt_io_wires
#pragma FUNC_WIRES chacha20poly1305_encrypt_io_wires
void chacha20poly1305_encrypt_io_wires(){
  // Convert flattened multiple input wires to stream(axis128_t)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_encrypt_axis_in.data.tdata, 16, encrypt_s_axis_tdata)
  UINT_TO_BIT_ARRAY(chacha20poly1305_encrypt_axis_in.data.tkeep, 16, encrypt_s_axis_tkeep)
  chacha20poly1305_encrypt_axis_in.data.tlast = encrypt_s_axis_tlast;
  chacha20poly1305_encrypt_axis_in.valid = encrypt_s_axis_tvalid;
  encrypt_s_axis_tready = chacha20poly1305_encrypt_axis_in_ready;
  UINT_TO_BYTE_ARRAY(chacha20poly1305_encrypt_key, CHACHA20_KEY_SIZE, encrypt_key)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_encrypt_nonce, CHACHA20_NONCE_SIZE, encrypt_nonce)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_encrypt_aad, AAD_MAX_LEN, encrypt_aad)
  chacha20poly1305_encrypt_aad_len = encrypt_aad_len;
  // Convert stream(axis128_t) to flattened output multiple wires
  encrypt_m_axis_tdata = uint8_array16_le(chacha20poly1305_encrypt_axis_out.data.tdata);
  encrypt_m_axis_tkeep = uint1_array16_le(chacha20poly1305_encrypt_axis_out.data.tkeep);
  encrypt_m_axis_tlast = chacha20poly1305_encrypt_axis_out.data.tlast;
  encrypt_m_axis_tvalid = chacha20poly1305_encrypt_axis_out.valid;
  chacha20poly1305_encrypt_axis_out_ready = encrypt_m_axis_tready;
}
#endif