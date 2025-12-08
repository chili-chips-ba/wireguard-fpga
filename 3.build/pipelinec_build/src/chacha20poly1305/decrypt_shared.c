// Decrypt part of shared design
// intended to look alot like stand alone top level chacha20poly1305_decrypt.c
// without including the shared compute pipelines...
#include "arrays.h"
// Top level IO port config, named like chacha20poly1305_decrypt_*
#include "chacha20poly1305_decrypt.h"
// Instance of chacha20 part of decryption
#define CHACHA_INST chacha20_decrypt
#define CHACHA_EXCLUDES_PIPELINE
#include "../chacha20/chacha20.c"
// Instance of preparing auth data part of decryption
#define PREP_AUTH_DATA_INST prep_auth_data_decrypt
#include "../prep_auth_data/prep_auth_data.c"
// Instance of poly1305 part of decryption
#define POLY_MAC_INST poly1305_mac_decrypt
#define POLY_EXCLUDES_PIPELINE
#include "../poly1305/poly1305_mac.c"
// Instance of the poly1305 verification block
#include "../poly1305/poly1305_verify_decrypt.c"
// Instance of strip auth tag
#include "../auth_tag/strip_auth_tag.c"
// Instance wait to verify block 
#include "../auth_tag/wait_to_verify.c"
// Instance of decrypt dataflow connecting everything together
#include "decrypt_dataflow.c"
