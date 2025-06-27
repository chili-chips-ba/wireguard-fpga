
/*
 * Simple Curve25519 API implementation
 * Uses TweetNaCl X25519 implementation
 */

#include "curve25519.h"
#include "tweetnacl_x25519.h"

int curve25519_generate_public_key(uint8_t public_key[32], const uint8_t private_key[32])
{
    if (!public_key || !private_key)
    {
        return -1;
    }

    /* Generate public key using scalar multiplication with base point */
    return x25519_scalarmult_base(public_key, private_key);
}

int curve25519_compute_shared_secret(uint8_t shared_secret[32], const uint8_t private_key[32], const uint8_t public_key[32])
{
    if (!shared_secret || !private_key || !public_key)
    {
        return -1; /* Invalid parameters */
    }

    /* Compute shared secret using scalar multiplication */
    return x25519_scalarmult(shared_secret, private_key, public_key);
}