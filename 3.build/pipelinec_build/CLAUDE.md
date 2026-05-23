# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This directory contains the **PipelineC** HLS (High-Level Synthesis) implementation of ChaCha20-Poly1305 AEAD encryption/decryption for the Wireguard FPGA project. It targets an Artix-7 xc7a200tffg1156-2 FPGA at 80 MHz.

PipelineC compiles C source files directly into synthesizable Verilog. The `$PIPELINEC` environment variable must point to the PipelineC executable before running any build script.

## Build Commands

All build scripts clear their output directory and regenerate from scratch.

**Generate Verilog (for FPGA synthesis):**
```bash
./build_verilog.sh          # Standalone encrypt → generated-files-verilog/
./build_verilog_decrypt.sh  # Standalone decrypt → generated-files-verilog-decrypt/
./build_verilog_shared.sh   # Shared encrypt+decrypt → generated-files-verilog-shared/
```

**Simulate with cocotb + GHDL:**
```bash
./build_sim_comb.sh         # Combinational sim, encrypt TB (100 steps)
./build_sim_pipe.sh         # Pipelined sim, encrypt TB (150 steps)
./build_sim_comb_dec.sh     # Combinational sim, decrypt TB
./build_sim_pipe_dec.sh     # Pipelined sim, decrypt TB (175 steps)
./build_sim_comb_shared.sh  # Combinational sim, shared TB (75 steps)
./build_sim_pipe_shared.sh  # Pipelined sim, shared TB
```

Pre-generated Verilog output committed to the repo lives in `generated-files/` (used by Vivado/openXC7 FPGA builds in `../hw_build.*`).

## Architecture

### Three Design Variants

| File | Description |
|---|---|
| `src/chacha20poly1305_encrypt.c` | Standalone encrypt: ChaCha20 + Poly1305 MAC + append_auth_tag |
| `src/chacha20poly1305_decrypt.c` | Standalone decrypt: ChaCha20 + Poly1305 MAC + strip_auth_tag + verify + wait_to_verify |
| `src/chacha20poly1305_encrypt_decrypt_shared.c` | Both paths sharing a single ChaCha20 pipeline (area-saving) |

### Datapath (Encrypt)
`plaintext → chacha20 → [ciphertext fork] → prep_auth_data → poly1305_mac → append_auth_tag → output`

The ciphertext stream is forked: one copy goes to `append_auth_tag` (direct passthrough to output), the other goes to `prep_auth_data` → `poly1305_mac` to compute the authentication tag, which is then appended after the ciphertext.

### Datapath (Decrypt)
`ciphertext+tag → strip_auth_tag → [ciphertext fork] → chacha20 → wait_to_verify → plaintext`
                                                     `→ prep_auth_data → poly1305_mac → poly1305_verify → wait_to_verify`

`wait_to_verify` is a 128-word FIFO that buffers decrypted plaintext until the Poly1305 tag comparison completes. If verification fails, the buffered plaintext is discarded.

### Resource Sharing (shared variant)
`chacha20_pipeline_shared` instantiates one ChaCha20 pipeline and multiplexes encrypt/decrypt requests via round-robin scheduling. A 1-bit `is_encrypt` tag is embedded in the pipeline transaction and propagated through all 64 stages to demultiplex outputs back to the correct consumer.

### Key PipelineC Conventions
- `#pragma MAIN_MHZ encrypt_dataflow 80.0` — sets the clock target and marks the top-level function
- `#pragma PART "xc7a200tffg1156-2"` — binds the design to the Artix-7 200T device
- `#pragma FEEDBACK` — required for combinational loops (e.g., width-conversion feedback)
- `DECL_INPUT` / `DECL_OUTPUT` macros — declare flattened top-level Verilog ports (only active when `SIMULATION` is not defined)
- AXI stream data width is 128-bit (`axis128_t`); ChaCha20 operates on 512-bit blocks (`axis512_t`); width converters are used at the ChaCha20 pipeline boundary

### Module Instantiation Pattern
Submodules (chacha20, poly1305, prep_auth_data, etc.) are instantiated by `#define`-ing an instance name prefix then `#include`-ing the `.c` file. This pattern allows multiple instances of the same module with different port names:
```c
#define CHACHA_INST chacha20_encrypt
#include "chacha20/chacha20.c"
```

### Testbench Pattern
Testbench files (`*_tb.c`) `#define SIMULATION` then `#include` the design under test, which disables the `DECL_INPUT`/`DECL_OUTPUT` hardware port declarations and replaces them with simulation-driven wires.
