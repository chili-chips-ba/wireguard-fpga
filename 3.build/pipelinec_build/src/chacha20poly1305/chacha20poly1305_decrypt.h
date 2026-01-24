// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Header file defining top-level IO ports and internal wires for the
 * Chacha20-Poly1305 decryption pipeline
 *
 * This file handles the conversion between VHDL ports and C-streams 
 * */

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
DECL_INPUT(key_uint_t, decrypt_key)
DECL_INPUT(nonce_uint_t, decrypt_nonce)
DECL_INPUT(aad_uint_t, decrypt_aad)
DECL_INPUT(uint8_t, decrypt_aad_len)
// Top level input stream of plaintext
DECL_INPUT(uint128_t, decrypt_s_axis_tdata)
DECL_INPUT(uint16_t, decrypt_s_axis_tkeep)
DECL_INPUT(uint1_t, decrypt_s_axis_tlast)
DECL_INPUT(uint1_t, decrypt_s_axis_tvalid)
DECL_OUTPUT(uint1_t, decrypt_s_axis_tready)
// Top level output stream of ciphertext w/ auth tag
DECL_OUTPUT(uint128_t, decrypt_m_axis_tdata)
DECL_OUTPUT(uint16_t, decrypt_m_axis_tkeep)
DECL_OUTPUT(uint1_t, decrypt_m_axis_tlast)
DECL_OUTPUT(uint1_t, decrypt_m_axis_tvalid)
DECL_INPUT(uint1_t, decrypt_m_axis_tready)

// Parallel output (verification status)
DECL_OUTPUT(uint1_t, decrypt_m_verified)
#endif

// Nice struct/array type globally visible wires to use instead of flattened top level ports
// in simluation these wires are driven by the testbench
// in hardware these wires are driven by the top level ports
stream(axis128_t) chacha20poly1305_decrypt_axis_in; // input
uint1_t chacha20poly1305_decrypt_axis_in_ready; // output
uint8_t chacha20poly1305_decrypt_key[CHACHA20_KEY_SIZE]; // input
uint8_t chacha20poly1305_decrypt_nonce[CHACHA20_NONCE_SIZE]; // input
uint8_t chacha20poly1305_decrypt_aad[AAD_MAX_LEN]; // input
uint8_t chacha20poly1305_decrypt_aad_len; // input
stream(axis128_t) chacha20poly1305_decrypt_axis_out; // output
uint1_t chacha20poly1305_decrypt_axis_out_ready; // input

// Parallel output (verification result)
uint1_t chacha20poly1305_decrypt_is_verified_out; //output

// For real hardware connect top level ports to these wires
#ifndef SIMULATION
#pragma MAIN chacha20poly1305_decrypt_io_wires
#pragma FUNC_WIRES chacha20poly1305_decrypt_io_wires
void chacha20poly1305_decrypt_io_wires(){
  // Convert flattened multiple input wires to stream(axis128_t)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_decrypt_axis_in.data.tdata, 16, decrypt_s_axis_tdata)
  UINT_TO_BIT_ARRAY(chacha20poly1305_decrypt_axis_in.data.tkeep, 16, decrypt_s_axis_tkeep)
  chacha20poly1305_decrypt_axis_in.data.tlast = decrypt_s_axis_tlast;
  chacha20poly1305_decrypt_axis_in.valid = decrypt_s_axis_tvalid;
  decrypt_s_axis_tready = chacha20poly1305_decrypt_axis_in_ready;
  UINT_TO_BYTE_ARRAY(chacha20poly1305_decrypt_key, CHACHA20_KEY_SIZE, decrypt_key)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_decrypt_nonce, CHACHA20_NONCE_SIZE, decrypt_nonce)
  UINT_TO_BYTE_ARRAY(chacha20poly1305_decrypt_aad, AAD_MAX_LEN, decrypt_aad)
  chacha20poly1305_decrypt_aad_len = decrypt_aad_len;
  // Convert stream(axis128_t) to flattened output multiple wires
  decrypt_m_axis_tdata = uint8_array16_le(chacha20poly1305_decrypt_axis_out.data.tdata);
  decrypt_m_axis_tkeep = uint1_array16_le(chacha20poly1305_decrypt_axis_out.data.tkeep);
  decrypt_m_axis_tlast = chacha20poly1305_decrypt_axis_out.data.tlast;
  decrypt_m_axis_tvalid = chacha20poly1305_decrypt_axis_out.valid;
  chacha20poly1305_decrypt_axis_out_ready = decrypt_m_axis_tready;

  // Connect the parallel verification output wire
  decrypt_m_verified = chacha20poly1305_decrypt_is_verified_out;
}
#endif
