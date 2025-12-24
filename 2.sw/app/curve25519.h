#ifndef CURVE25519_H
#define CURVE25519_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/**
 * Generate a Curve25519 public key from a private key
 *
 * @param public_key  Output buffer for the 32-byte public key
 * @param private_key Input 32-byte private key
 * @return 0 on success, -1 on error
 */
int curve25519_generate_public_key(uint8_t public_key[32], const uint8_t private_key[32]);

/**
 * Compute shared secret from private key and peer's public key
 *
 * @param shared_secret Output buffer for the 32-byte shared secret
 * @param private_key   Input 32-byte private key
 * @param public_key    Input 32-byte peer's public key
 * @return 0 on success, -1 on error
 */
int curve25519_compute_shared_secret(uint8_t shared_secret[32], const uint8_t private_key[32], const uint8_t public_key[32]);

#ifdef __cplusplus
}
#endif

#endif /* CURVE25519_H */