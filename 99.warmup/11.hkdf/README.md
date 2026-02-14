<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# HKDF (Noise KDF) lib

This component implements the HKDF-style key derivation function used by the
Noise protocol, as specified and used in WireGuard.

The implementation combines the existing BLAKE2s hash function with HMAC and
the Noise KDF construction to derive up to three 32-byte keys from a chaining
key and input data. The code is written in portable C and is intended for use
in bare-metal environments.

The HMAC and KDF logic is derived from the WireGuard Linux implementation and
adapted to use the local BLAKE2s component.

## Provided Functionality

- Noise-compatible HKDF (KDF) using BLAKE2s
- Derivation of up to three output keys in a single call
- Optional outputs (any output buffer may be omitted)

## Implementation Notes

- Uses BLAKE2s-256 as the underlying hash function (`NOISE_HASH_LEN = 32`).
- Implements the Noise-specific HKDF expansion (up to three outputs).
- Based on the HMAC and KDF logic used in the WireGuard Linux kernel.
- Relies on explicit memory handling suitable for bare-metal systems.
- No dynamic memory allocation.
- Build passes successfully on all target platforms.

## Testing and Validation

- This component has **not been tested in isolation** using dedicated HKDF test vectors.
- No official Noise KDF test vectors were available at the time of implementation.
- Correctness of this component is therefore validated indirectly through
  successful testing of the complete Noise protocol.
- The underlying BLAKE2s implementation has been **successfully tested on real hardware**.
- Since HMAC and KDF logic is taken directly from WireGuard, and BLAKE2s is verified,
  the implementation is assumed to be functionally correct for current use.
