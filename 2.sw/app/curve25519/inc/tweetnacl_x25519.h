#ifndef TWEETNACL_X25519_H
#define TWEETNACL_X25519_H

#include <stdint.h>

/**
 * X25519 scalar multiplication with base point
 * Generates a public key from a private key by multiplying the private key
 * with the Curve25519 base point (9).
 *
 * @param q Output buffer for the 32-byte result (public key)
 * @param n Input 32-byte scalar (private key, will be clamped internally)
 * @return 0 on success
 */
int x25519_scalarmult_base(uint8_t *q, const uint8_t *n);

/**
 * X25519 scalar multiplication with arbitrary point
 * Computes the scalar multiplication of a private key with a public key point.
 * Used for computing shared secrets in Diffie-Hellman key exchange.
 *
 * @param q Output buffer for the 32-byte result (shared secret)
 * @param n Input 32-byte scalar (private key, will be clamped internally)
 * @param p Input 32-byte point (public key)
 * @return 0 on success
 */
int x25519_scalarmult(uint8_t *q, const uint8_t *n, const uint8_t *p);

#endif /* TWEETNACL_X25519_H */