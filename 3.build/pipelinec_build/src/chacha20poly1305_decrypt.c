// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
// SPDX-FileCopyrightText: 2026 Julian Kammerer
//
// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Decryption Pipeline for ChaCha20-Poly1305
*/
#include "arrays.h"
// Top level IO port config, named like chacha20poly1305_decrypt_*
#include "chacha20poly1305/chacha20poly1305_decrypt.h"
// Instance of chacha20 part of decryption
#define CHACHA_INST chacha20_decrypt
#include "chacha20/chacha20.c"
// Instance of preparing auth data part of decryption
#define PREP_AUTH_DATA_INST prep_auth_data_decrypt
#include "prep_auth_data/prep_auth_data.c"
// Instance of poly1305 part of decryption
#define POLY_MAC_INST poly1305_mac_decrypt
#include "poly1305/poly1305_mac.c"
// Instance of the poly1305 verification block
#include "poly1305/poly1305_verify_decrypt.c"
// Instance of strip auth tag
#include "auth_tag/strip_auth_tag.c"
// Instance wait to verify block 
#include "auth_tag/wait_to_verify.c"


// The primary dataflow for single clock domain ChaCha20-Poly1305 decryption
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T
#include "chacha20poly1305/decrypt_dataflow.c"
