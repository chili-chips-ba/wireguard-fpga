<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# Timer lib

This component provides simple delay utilities based on the RISC-V cycle counter (`rdcycle`).  
It implements millisecond and microsecond delays without relying on interrupts or external timers.

The functions are intended for low-level embedded use and are primarily used within the
Noise protocol implementation for WireGuard, where short, deterministic delays are required
during cryptographic operations and protocol handling.

## Provided Functions

- `delay_us(uint32_t us)`  
  Busy-wait delay based on the current RISC-V cycle count.

- `delay_ms(uint32_t ms)`  
  Millisecond delay implemented as a wrapper around the microsecond delay.

## Implementation Notes

- Uses the `rdcycle` instruction to read the CPU cycle counter.
- Delay accuracy depends on the configured CPU clock frequency.
- Designed for bare-metal environments without an operating system.
- Blocking implementation (busy-wait).
- **Successfully tested on the hardware.**
