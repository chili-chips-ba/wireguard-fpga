<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# Random number generator lib

This component implements a lightweight random number generator suitable for bare-metal
RISC-V systems without access to a hardware RNG.

Entropy is gathered from the RISC-V cycle counter (`rdcycle`) and execution timing jitter,
and the collected data is mixed using BLAKE2s to produce uniformly distributed output.
Additional bit manipulation and arithmetic mixing are applied to the raw cycle counter
values to further decorrelate consecutive samples.  
While not cryptographically secure on its own, this generator provides sufficient entropy
for embedded use and as an input source for higher-level cryptographic constructions
within the Noise protocol used by WireGuard.

## Provided Functions

- `random_32bytes(uint8_t *out)`  
  Generates 32 pseudo-random bytes by collecting multiple cycle counter samples, applying
  bitwise mixing operations, and hashing the result using BLAKE2s.

- `random_range(uint32_t min, uint32_t max)`  
  Returns a random 32-bit integer in the inclusive range `[min, max]`.
  Uses arithmetic reduction to limit modulo bias.

## Implementation Notes

- Uses the `rdcycle` instruction as a primary entropy source.
- Applies bit manipulation (shifts, XORs) and arithmetic scrambling to raw samples.
- Introduces small execution delays to increase timing variability.
- Mixes entropy using the BLAKE2s hash function.
- Designed for bare-metal, single-core RISC-V environments.
- Blocking implementation.
- **Successfully tested on real hardware.**
