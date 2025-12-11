// Encrypt part of shared design
// intended to look alot like stand alone top level chacha20poly1305_encrypt.c
// without including the shared compute pipelines...
#include "arrays.h"
// Top level IO port config, named like chacha20poly1305_encrypt_*
#include "chacha20poly1305_encrypt.h"
// Instance of chacha20 part of encryption
#define CHACHA_INST chacha20_encrypt
#define CHACHA_EXCLUDES_PIPELINE
#include "../chacha20/chacha20.c"
// Instance of preparing auth data part of encryption
#define PREP_AUTH_DATA_INST prep_auth_data_encrypt
#include "../prep_auth_data/prep_auth_data.c"
// Instance of poly1305 part of encryption
#define POLY_MAC_INST poly1305_mac_encrypt
#define POLY_EXCLUDES_PIPELINE
#include "../poly1305/poly1305_mac.c"
// Instance of the appending auth tag part of encryption
#include "../auth_tag/append_auth_tag.c"
// Instance of encrypt dataflow connecting everything together
#include "encrypt_dataflow.c"