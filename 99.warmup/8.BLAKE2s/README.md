# BLAKE2s lib

This component provides a compact and self-contained reference implementation of the
BLAKE2s cryptographic hash function.

The implementation is written in portable C and is designed to run on both x86 and
32-bit RISC-V (RV32) architectures without relying on platform-specific intrinsics.
All core operations are implemented using explicit bit manipulation and integer
arithmetic, ensuring predictable behavior across different targets.

This library is used as a fundamental cryptographic primitive within the Noise protocol
implementation for WireGuard, including hashing, key derivation, and HMAC construction.

## Provided Functionality

- BLAKE2s hash (incremental API: init / update / final)
- One-shot hash helper function
- HMAC based on BLAKE2s

## Implementation Notes

- Implements the official BLAKE2s compression function and permutation.
- Uses explicit bitwise operations (XOR, shifts, rotations) and 32-bit arithmetic.
- Little-endian data handling is implemented manually for portability.
- No dynamic memory allocation.
- Suitable for bare-metal and hosted environments.
- Compatible with x86 and RV32 architectures.
- **Successfully tested on real hardware.**
