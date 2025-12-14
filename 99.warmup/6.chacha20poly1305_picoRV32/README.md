# ChaCha20 + Poly1305 lib

This component implements the ChaCha20–Poly1305 authenticated encryption
algorithm (AEAD) as specified in RFC 8439.

It combines a standalone ChaCha20 stream cipher implementation with a
Poly1305 message authentication code to provide confidentiality, integrity,
and authenticity. The library is intended for use within the Noise protocol
as used by WireGuard and is suitable for bare-metal embedded systems.

All cryptographic operations are implemented in portable C using explicit
bit manipulation and integer arithmetic, without relying on platform-specific
accelerations.

## Provided Functionality

- ChaCha20 stream cipher
- Poly1305 message authentication code
- ChaCha20–Poly1305 AEAD encryption and decryption
- Support for Additional Authenticated Data (AAD)

## Component Overview

### ChaCha20
- 256-bit key, 96-bit nonce
- 64-byte block size
- Counter-based stream cipher
- Same function used for encryption and decryption

### Poly1305
- One-time message authentication code
- 128-bit authentication tag
- Key derived from ChaCha20 keystream as per RFC 8439

### ChaCha20–Poly1305 AEAD
- Encrypt-then-MAC construction
- Produces a 16-byte authentication tag
- Verifies integrity before accepting decrypted data

## Implementation Notes

- Follows RFC 8439 specification.
- Uses explicit bitwise operations (XOR, shifts, rotations).
- No dynamic memory allocation.
- Designed for bare-metal environments.
- Portable across architectures.
- Suitable for Noise / WireGuard usage.
- **Successfully tested on real hardware.**
