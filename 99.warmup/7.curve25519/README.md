<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# curve25519 (x25519) lib

This component provides a minimal Curve25519 (X25519) implementation used for
Elliptic Curve Diffie–Hellman (ECDH) key exchange within the Noise protocol
as used by WireGuard.

The implementation is based on the public-domain TweetNaCl reference code
(https://tweetnacl.cr.yp.to/software.html). Only the Curve25519 (X25519)
scalar multiplication functionality was extracted and integrated; no other
TweetNaCl primitives are included.

A small wrapper API is provided to expose a clean and simple interface for
public key generation and shared secret computation.

## Provided Functionality

- X25519 scalar multiplication
- Public key generation from a private scalar
- Shared secret computation for ECDH

## Implementation Notes

- Based on the TweetNaCl public-domain X25519 implementation.
- Uses Montgomery curves and the Montgomery ladder.
- Constant-time scalar multiplication with respect to the secret scalar.
- Implemented using explicit integer arithmetic.
- No dynamic memory allocation.
- Suitable for bare-metal environments.
- Only the Curve25519 code was imported; all other TweetNaCl components were excluded.

## API Overview

- `curve25519_generate_public_key(uint8_t public_key[32], const uint8_t private_key[32])`  
  Computes the public key using scalar multiplication with the Curve25519 base point.

- `curve25519_compute_shared_secret(uint8_t shared_secret[32], const uint8_t private_key[32], const uint8_t public_key[32])`  
  Computes the shared secret using scalar multiplication with a peer’s public key.

## Testing and Validation

- The implementation was **successfully tested** using known-good key pairs and
  shared secret comparisons.
- The code builds and runs correctly on the target hardware platform.
- Correctness relies on the well-established TweetNaCl reference implementation.
