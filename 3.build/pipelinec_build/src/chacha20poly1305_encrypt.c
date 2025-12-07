/**
 * based on code from
 * https://github.com/chili-chips-ba/wireguard-fpga/blob/main/2.sw/app/chacha20poly1305/
*/
#include "arrays.h"
// Top level IO port config, named like chacha20poly1305_encrypt_*
#include "chacha20poly1305/chacha20poly1305_encrypt.h"
// Instance of chacha20 part of encryption
#define CHACHA_INST chacha20_encrypt
#include "chacha20/chacha20.c"
// Instance of preparing auth data part of encryption
#define PREP_AUTH_DATA_INST prep_auth_data_encrypt
#include "prep_auth_data/prep_auth_data.c"
// Instance of poly1305 part of encryption
#define POLY_MAC_INST poly1305_mac_encrypt
#include "poly1305/poly1305_mac.c"
// Instance of the appending auth tag part of encryption
#include "auth_tag/append_auth_tag.c"

// The primary dataflow for single clock domain ChaCha20-Poly1305 encryption
#pragma PART "xc7a200tffg1156-2" // Artix 7 200T
#include "chacha20poly1305/encrypt_dataflow.c"