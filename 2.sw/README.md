# Software Architecture and Theory of Operation
![SWArchitecture](../0.doc/Wireguard/wireguard-fpga-muxed-Architecture-SW.webp)

The conceptual class diagram provides an overview of the components in the software part of the system without delving into implementation details. The focus is on the WireGuard Agent, which implements the protocol's handshake procedures, along with the following supplementary components:
- [Curve25519](http://cr.yp.to/ecdh.html) - an ECDH algorithm implementation for establishing a shared secret using a public-private key pair between two remote parties connected via an insecure channel, such as the Internet
- ChaCha20-Poly1305 - an AEAD algorithm implementation for encryption and authentication of static keys and nonce values to prevent replay attacks
- XChaCha20-Poly1305 - a XAEAD algorithm implementation for encrypting and authenticating nonce values in Cookie Replay messages to mitigate potential DoS attacks
- [BLAKE2s](https://www.blake2.net) - an implementation of the BLAKE2s hash function for MAC authentication and keyed hashing, per [RFC7693](https://datatracker.ietf.org/doc/html/rfc7693)
- RNG - a random number generator used to initialize the DH key generator and generate peer identifiers
- Timer - timers for rekey, retry, and keepalive procedures
- [HKDF](https://eprint.iacr.org/2010/264) - an implementation of the algorithm for expanding the ECDH result
- RTC - a real-time clock used to generate the TAI64N timestamp
- [SipHash](https://en.wikipedia.org/wiki/SipHash) - a simple non-cryptographic function used for implementing a hashtable for fast lookup of decrypted static public keys of remote peers
- Routing DB Updater - a subsystem for maintaining the cryptokey routing table content and deploying it to the data plane via the HAL/CSR interface
- ICMP - implementing basic ICMP protocol functions (echo request/reply, TTL exceeded, etc.)
- CLI - a USB/UART-based command-line interface for configuring the WireGuard node (setting the local IP address, remote peer IP addresses, network addresses, keys, etc.)
- HAL/CSR Driver - a CSR-based abstraction for DPE components with an interface for reading/writing the corresponding registers

## curve25519 (x25519) lib
This component provides a minimal Curve25519 (X25519) implementation used for
Elliptic Curve Diffie–Hellman (ECDH) key exchange within the Noise protocol
as used by WireGuard.

The implementation is based on the public-domain TweetNaCl reference code
(https://tweetnacl.cr.yp.to/software.html). Only the Curve25519 (X25519)
scalar multiplication functionality was extracted and integrated; no other
TweetNaCl primitives are included.

A small wrapper API is provided to expose a clean and simple interface for
public key generation and shared secret computation.

### Provided Functionality
- X25519 scalar multiplication
- Public key generation from a private scalar
- Shared secret computation for ECDH

### Implementation Notes
- Based on the TweetNaCl public-domain X25519 implementation.
- Uses Montgomery curves and the Montgomery ladder.
- Constant-time scalar multiplication with respect to the secret scalar.
- Implemented using explicit integer arithmetic.
- No dynamic memory allocation.
- Suitable for bare-metal environments.
- Only the Curve25519 code was imported; all other TweetNaCl components were excluded.

### API Overview
- `curve25519_generate_public_key(uint8_t public_key[32], const uint8_t private_key[32])`  
  Computes the public key using scalar multiplication with the Curve25519 base point.

- `curve25519_compute_shared_secret(uint8_t shared_secret[32], const uint8_t private_key[32], const uint8_t public_key[32])`  
  Computes the shared secret using scalar multiplication with a peer’s public key.

### Testing and Validation
- The implementation was [**successfully tested**](https://github.com/chili-chips-ba/wireguard-fpga/tree/main/99.warmup/7.curve25519) using known-good key pairs and
  shared secret comparisons.
- The code builds and runs correctly on the target hardware platform.
- Correctness relies on the well-established TweetNaCl reference implementation.

## ChaCha20-Poly1305 lib
This component implements the ChaCha20–Poly1305 authenticated encryption
algorithm (AEAD) as specified in RFC 8439.

It combines a standalone ChaCha20 stream cipher implementation with a
Poly1305 message authentication code to provide confidentiality, integrity,
and authenticity. The library is intended for use within the Noise protocol
as used by WireGuard and is suitable for bare-metal embedded systems.

All cryptographic operations are implemented in portable C using explicit
bit manipulation and integer arithmetic, without relying on platform-specific
accelerations.

### Provided Functionality
- ChaCha20 stream cipher
- Poly1305 message authentication code
- ChaCha20–Poly1305 AEAD encryption and decryption
- Support for Additional Authenticated Data (AAD)

### Component Overview
#### ChaCha20
- 256-bit key, 96-bit nonce
- 64-byte block size
- Counter-based stream cipher
- Same function used for encryption and decryption

#### Poly1305
- One-time message authentication code
- 128-bit authentication tag
- Key derived from ChaCha20 keystream as per RFC 8439

#### ChaCha20–Poly1305 AEAD
- Encrypt-then-MAC construction
- Produces a 16-byte authentication tag
- Verifies integrity before accepting decrypted data

### Implementation Notes
- Follows RFC 8439 specification.
- Uses explicit bitwise operations (XOR, shifts, rotations).
- No dynamic memory allocation.
- Designed for bare-metal environments.
- Portable across architectures.
- Suitable for Noise / WireGuard usage.
- [**Successfully tested on real hardware.**](https://github.com/chili-chips-ba/wireguard-fpga/tree/main/99.warmup/6.chacha20poly1305_picoRV32)

## BLAKE2s lib
This component provides a compact and self-contained reference implementation of the
BLAKE2s cryptographic hash function.

The implementation is written in portable C and is designed to run on both x86 and
32-bit RISC-V (RV32) architectures without relying on platform-specific intrinsics.
All core operations are implemented using explicit bit manipulation and integer
arithmetic, ensuring predictable behavior across different targets.

This library is used as a fundamental cryptographic primitive within the Noise protocol
implementation for WireGuard, including hashing, key derivation, and HMAC construction.

### Provided Functionality
- BLAKE2s hash (incremental API: init / update / final)
- One-shot hash helper function
- HMAC based on BLAKE2s

### Implementation Notes
- Implements the official BLAKE2s compression function and permutation (based on: "A clean & simple implementation of BLAKE2b and [BLAKE2s](https://github.com/mjosaarinen/blake2_mjosref) hash functions -- written while writing the RFC.")
- Uses explicit bitwise operations (XOR, shifts, rotations) and 32-bit arithmetic.
- Little-endian data handling is implemented manually for portability.
- No dynamic memory allocation.
- Suitable for bare-metal and hosted environments.
- Compatible with x86 and RV32 architectures.
- [**Successfully tested on real hardware.**](https://github.com/chili-chips-ba/wireguard-fpga/edit/main/99.warmup/8.BLAKE2s)

## Random number generator lib
This component implements a lightweight random number generator suitable for bare-metal
RISC-V systems without access to a hardware RNG.

Entropy is gathered from the RISC-V cycle counter (`rdcycle`) and execution timing jitter,
and the collected data is mixed using BLAKE2s to produce uniformly distributed output.
Additional bit manipulation and arithmetic mixing are applied to the raw cycle counter
values to further decorrelate consecutive samples.  
While not cryptographically secure on its own, this generator provides sufficient entropy
for embedded use and as an input source for higher-level cryptographic constructions
within the Noise protocol used by WireGuard.

### Provided Functions
- `random_32bytes(uint8_t *out)`  
  Generates 32 pseudo-random bytes by collecting multiple cycle counter samples, applying
  bitwise mixing operations, and hashing the result using BLAKE2s.

- `random_range(uint32_t min, uint32_t max)`  
  Returns a random 32-bit integer in the inclusive range `[min, max]`.
  Uses arithmetic reduction to limit modulo bias.

### Implementation Notes
- Uses the `rdcycle` instruction as a primary entropy source.
- Applies bit manipulation (shifts, XORs) and arithmetic scrambling to raw samples.
- Introduces small execution delays to increase timing variability.
- Mixes entropy using the BLAKE2s hash function.
- Designed for bare-metal, single-core RISC-V environments.
- Blocking implementation.
- [**Successfully tested on real hardware.**](https://github.com/chili-chips-ba/wireguard-fpga/edit/main/99.warmup/9.rng)

## Timer lib
This component provides simple delay utilities based on the RISC-V cycle counter (`rdcycle`).  
It implements millisecond and microsecond delays without relying on interrupts or external timers.

The functions are intended for low-level embedded use and are primarily used within the
Noise protocol implementation for WireGuard, where short, deterministic delays are required
during cryptographic operations and protocol handling.

### Provided Functions
- `delay_us(uint32_t us)`  
  Busy-wait delay based on the current RISC-V cycle count.

- `delay_ms(uint32_t ms)`  
  Millisecond delay implemented as a wrapper around the microsecond delay.

### Implementation Notes
- Uses the `rdcycle` instruction to read the CPU cycle counter.
- Delay accuracy depends on the configured CPU clock frequency.
- Designed for bare-metal environments without an operating system.
- Blocking implementation (busy-wait).
- [**Successfully tested on the hardware.**](https://github.com/chili-chips-ba/wireguard-fpga/edit/main/99.warmup/10.timer)

## HKDF (Noise KDF) lib
This component implements the HKDF-style key derivation function used by the
Noise protocol, as specified and used in WireGuard.

The implementation combines the existing BLAKE2s hash function with HMAC and
the Noise KDF construction to derive up to three 32-byte keys from a chaining
key and input data. The code is written in portable C and is intended for use
in bare-metal environments.

The HMAC and KDF logic is derived from the WireGuard Linux implementation and
adapted to use the local BLAKE2s component.

### Provided Functionality
- Noise-compatible HKDF (KDF) using BLAKE2s
- Derivation of up to three output keys in a single call
- Optional outputs (any output buffer may be omitted)

### Implementation Notes
- Uses BLAKE2s-256 as the underlying hash function (`NOISE_HASH_LEN = 32`).
- Implements the Noise-specific HKDF expansion (up to three outputs).
- Based on the HMAC and KDF logic used in the WireGuard Linux kernel.
- Relies on explicit memory handling suitable for bare-metal systems.
- No dynamic memory allocation.
- Build passes successfully on all target platforms.

### Testing and Validation
- This component has [**not been tested in isolation**](https://github.com/chili-chips-ba/wireguard-fpga/edit/main/99.warmup/11.hkdf) using dedicated HKDF test vectors.
- No official Noise KDF test vectors were available at the time of implementation.
- Correctness of this component is therefore validated indirectly through
  successful testing of the complete Noise protocol.
- The underlying BLAKE2s implementation has been **successfully tested on real hardware**.
- Since HMAC and KDF logic is taken directly from WireGuard, and BLAKE2s is verified,
  the implementation is assumed to be functionally correct for current use.

# Software Control Flow
## Sending and receiving packets
The DPE and CPU are connected through Rx and Tx FIFOs. Here, the Tx and Rx labels are relative to the DPE, not the CPU, meaning CPU → Rx FIFO → DPE and DPE → Tx FIFO → CPU. To ensure efficient communication, we maintained the same data bus width (128 bits) on both sides of the FIFO. The Rx and Tx FIFOs are mapped to the CPU by directly mapping AXIS signals to CSR. Since the CPU operates on a 32-bit data bus, all CSR registers had to be organized as 32-bit registers. Additionally, to prevent the CPU from entering Read-Modify-Write (RMW) cycles, which would reduce the interface throughput, all register fields had to be [aligned to 8 bits](https://github.com/chili-chips-ba/wireguard-fpga/issues/9).

It is important to note that triggering a data transfer cycle on the AXIS interface is achieved using [single-pulse](https://peakrdl-regblock.readthedocs.io/en/latest/props/field.html#singlepulse) TVALID/TREADY signals. This frees the CPU from the requirement to synchronize the AXIS clock cycle with its instruction cycle. 

Here is the process of sending a packet from the CPU to the ETH interface. The packet is divided into 16-byte segments, and for each segment:
1. The CPU reads `csr.cpu_fifo.rx.status.tready`; if it equals 1, it proceeds (since the FIFO is set to _drop-on-full_ mode, tready will always be 1).
2. The CPU writes `csr.cpu_fifo.rx.data_31_0.tdata`.
3. The CPU writes `csr.cpu_fifo.rx.data_63_32.tdata`.
4. The CPU writes `csr.cpu_fifo.rx.data_95_64.tdata`.
5. The CPU writes `csr.cpu_fifo.rx.data_127_96.tdata`.
6. The CPU writes `csr.cpu_fifo.rx.control.tkeep` (all ones, except in the last transfer).
7. The CPU writes `csr.cpu_fifo.rx.control.tlast` (0, except in the last transfer).
8. The CPU writes `csr.cpu_fifo.rx.control.tuser_bypass_all = 1`.
9. The CPU writes `csr.cpu_fifo.rx.control.tuser_dst` (1 - _eth1_, 2 - _eth2_, 3 - _eth3_, 4 - _eth4_, 7 - _broadcast_).
10. The CPU writes `csr.cpu_fifo.rx.trigger.tvalid = 1`.
11. If `tlast == 0`, return to step (1).

A similar process applies to receiving packets from the ETH interface. The CPU prepares a buffer and starts reading 16-byte segments from the Tx FIFO:
1. The CPU reads `csr.cpu_fifo.tx.status.tvalid`; if it equals 1, it proceeds (if it is 0, it stops since the FIFO is set to _store-and-forward_ mode).
2. The CPU reads `csr.cpu_fifo.tx.data_31_0.tdata`.
3. The CPU reads `csr.cpu_fifo.tx.data_63_32.tdata`.
4. The CPU reads `csr.cpu_fifo.tx.data_95_64.tdata`.
5. The CPU reads `csr.cpu_fifo.tx.data_127_96.tdata`.
6. The CPU reads `csr.cpu_fifo.tx.control.tlast`; if it is 1, proceed to step (7), otherwise go to step (9).
7. The CPU reads `csr.cpu_fifo.tx.control.tkeep`.
8. The CPU reads `csr.cpu_fifo.tx.control.tuser_src`.
9. The CPU writes `csr.cpu_fifo.tx.trigger.tready = 1`.
10. If `tlast == 0`, return to step (1).

If we assume that each step takes 1-2 instructions on average (1.5 on average) and that each instruction requires 4 clock cycles, we can estimate the throughput: 80 MHz × 128 bits ÷ (10 steps × 1.5 instructions × 4 cycles per instruction) = 170 Mbps. Clearly, this CSR-based FIFO interface cannot be used to implement a 1G datapath through the CPU, but since the CPU will only process WireGuard handshake messages, this will be more than sufficient.

## Updating DPE registers and tables
During the initial WireGuard handshake and subsequent periodic key rotations,  the control plane must update the cryptokey routing table implemented in register memory within the CSR. Since the CSR manages the operation of the DPE, such changes must be made atomically to prevent unpredictable behavior in the DPE. One way to achieve this is by using [Write-Buffered Registers](https://peakrdl-regblock.readthedocs.io/en/latest/udps/write_buffering.html) (WBR). However, implementing 1 bit of WBR  memory requires three flip-flops: one to store the current value, one to hold the future value, and one for the write-enable signal. Therefore, we consider an alternative mechanism for atomic CSR updates based on flow control between the CPU and the DPE. Suppose the CPU needs to update the contents of a routing table implemented using many registers. Before starting the update, the CPU must pause packet processing within the DPE. However, such a pause cannot be implemented using the inherent stall mechanism supported by the AXI protocol (by deactivating the TREADY signal at the end of the pipeline), as a packet that has already entered the DPE must be processed according to the rules in effect at the time of its entry. We introduce a graceful flow control mechanism coordinated through a dedicated Flow Control Register (FCR) to address this.

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-CSR-Flow-Control.webp)

The atomic CSR update mechanism works as follows:
1. When the CPU needs to update the routing table, it asserts the PAUSE signal by writing to the FCR register (i.e. `csr.dpe.fcr.pause = 1`).
2. The active `csr.dpe.fcr.pause` signal instructs the input multiplexer to transition into the PAUSED state after completing the servicing of the current queue. The CPU periodically checks the ready bits in the FCR register.
3. Once the first component finishes processing its packet and clears its datapath, it deactivates the TVALID signal and transitions to the IDLE state. The CPU continues to check the ready bits in the FCR register.
4. The processing of remaining packets and datapath clearing continues until all components transition to the IDLE state. The CPU monitors the ready bits in the FCR register, which now indicates that the DPE has been successfully paused (i.e. `csr.dpe.fcr.idle == 1`).
5. The CPU updates the necessary registers (e.g., the routing table) over multiple cycles.
6. Upon completing the updates, the CPU deactivates the PAUSE signal (i.e. `csr.dpe.fcr.pause = 0`).
7. The multiplexer returns to its default operation mode and begins accepting packets from the next queue in a round-robin fashion.
8. As packets start arriving, all components within the DPE gradually transition back to their active states.

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-CSR-Flow-Control-Animated.gif)
