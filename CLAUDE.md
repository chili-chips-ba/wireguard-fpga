# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

An open-source, FPGA-based implementation of WireGuard VPN — a self-sufficient (no PC host) SoC on a low-cost Artix-7 (AX7201, 4x 1000Base-T) board, with all gateware in Verilog/SystemVerilog and supported by open-source tools end to end. The system splits into two layers:

- **Control plane** (software): a soft RISC-V CPU running bare-metal C/C++ that implements the WireGuard protocol handshake, session management, cryptokey routing table maintenance, and a UART CLI. Never touches the bulk datapath.
- **Data plane** (hardware): a Data Plane Engine (DPE) — a pipelined RTL AXI4-Stream datapath doing IP routing, WireGuard encapsulation/decapsulation, and ChaCha20-Poly1305 AEAD crypto at (aspirationally) wire speed across 4x 1Gbps ports.

The two planes talk exclusively through a CSR-based HAL, auto-generated from a single SystemRDL spec so hardware RTL, RISC-V firmware, and the co-simulation testbench all share one register API.

See the root `README.md` for the full architecture writeup (HW/SW partitioning diagrams, DPE dataflow example walkthrough, project phase tracker) — it's long and detailed; read it before making cross-cutting changes.

## Repository Layout

```
1.hw/          SystemVerilog RTL: DPE cores (ip.dpe/), infra (ip.infra/: CSR, FIFOs, UART, clocking),
               soft CPU wrapper (ip.cpu/: PicoRV32), top.sv + top.filelist
2.sw/          Bare-metal C/C++ firmware for the RISC-V control plane (app/), CSR register tests (tests/)
3.build/       Build orchestration — see "Build Commands" below
4.sim/         VProc/Verilator co-simulation testbench (RTL soc_cpu or virtual-processor RISC-V models)
5.lint/        Verible SystemVerilog lint (rules.md documents the enabled rule set)
6.test/        UART-based hardware bring-up/test scripts + lab test topology instructions (README.md)
99.warmup/     Standalone bring-up exercises (blinky, Ethernet, crypto primitives, PicoRV32) — early
               learning/prototyping, not part of the production build
0.doc/         Architecture docs, datasheets, diagrams — not code
```

`3.build/` has two independent, parallel HLS crypto-core subprojects, each with its own `CLAUDE.md` — **read the relevant one before touching either**:
- `3.build/pipelinec_build/` — the original C/PipelineC HLS ChaCha20-Poly1305 implementation (has known Poly1305 math and ciphertext-length bugs, intentionally left as-is).
- `3.build/pypeline_build/` — a from-scratch Python/Pypeline port of the same design, RFC 8439-conformant, with those bugs fixed. **Its tags/ciphertext lengths deliberately differ from the C version — do not port fixes back to `pipelinec_build/`.**

## Build Commands

The overall build is three independent stages, each with its own top-level Makefile in `3.build/`, run in this dependency order:

**1. CSR/HAL generation** (`3.build/MakefileCSR`) — compiles `3.build/csr_build/csr.rdl` (SystemRDL) via `peakrdl`/`systemrdl-compiler` into the CSR RTL and three header variants (hardware, co-sim, and the intermediate `c-header`) so the RISC-V firmware, the VProc cosim testbench, and the RTL all share one register API:
```bash
make -f MakefileCSR         # generates 3.build/csr_build/generated-files/*
make -f MakefileCSR clean
```

**2. Firmware build** (`3.build/MakefileSW`) — must run before the hardware build, since it produces `imem.INIT.vh`, consumed by synthesis. Requires `riscv64-unknown-elf-gcc` (see `0.doc/1.README.Tool-Installs.txt`):
```bash
make -f MakefileSW sw_all        # -> 3.build/sw_build/{main.elf,main.hex,main.bin,main.dump,imem.INIT.vh}
make -f MakefileSW program       # reprogram IMEM over UART on already-configured hardware, no resynthesis
```

**3. Hardware build** — two independent toolchains target the same RTL (`1.hw/top.filelist`):
```bash
# Vivado (proprietary reference flow)
make -f MakefileHW              # -> hw_build.Vivado/wireguard.runs/impl_1/top.bit
make -f MakefileHW program

# openXC7 (open-source Yosys + nextpnr-xilinx flow)
cd hw_build.openXC7
source /opt/openxc7/setup_env.sh
make convert                    # SystemVerilog -> Verilog via sv2v (converted/all_converted.v)
make all                        # -> build_artifacts/top.bit
```
openXC7 needs `sv2v` on PATH (`make install-sv2v` inside `hw_build.openXC7/`) and the software built first for `imem.INIT.vh`.

**Simulation** (`4.sim/`, Verilator-based, VProc co-sim):
```bash
make -f MakefileVProc.mk run                 # build + run batch sim, native VUserMain0.cpp test code
make -f MakefileVProc.mk BUILD=ISS run        # run RISC-V-compiled code on the rv32 ISS instead
make -f MakefileVProc.mk gui                  # same, with GTKWave
make -f MakefileVProc.mk clean
```
`soc_cpu` is auto-selected between RTL (PicoRV32/IBEX/EDUBOS5) and the VProc virtual-processor model depending on which files are in `top.filelist`; see `4.sim/README.md` for the full picture (co-sim HAL usage, ISS timing models, PCAP replay, gdb debugging). A standalone PicoRV32-RTL-only Makefile also exists directly in `4.sim/` for cycle-accurate sim without VProc.

**Lint** (`5.lint/`, Verible against `1.hw/top.filelist`):
```bash
./lint_run.sh          # results land in 5.lint/results/<file>.txt
```
Enabled/disabled rules and their rationale are in `5.lint/rules.md`.

**Crypto core HLS builds** (`3.build/pipelinec_build/`, `3.build/pypeline_build/`) — each has its own build scripts/`build.py` and CLAUDE.md with full sim/synth command reference; don't duplicate that detail here.

## Key Architectural Details

**CSR as the sole control/data-plane bridge.** Everything crossing between the RISC-V CPU and the DPE — including the Rx/Tx FIFO packet data itself — goes through 32-bit CSR registers (`csr.cpu_fifo.rx.*`/`tx.*`), not DMA. This is deliberate: control traffic (handshakes) is infrequent, so a CSR-mapped FIFO interface (~170 Mbps ceiling per `1.hw/README.md`'s estimate) is acceptable for it, but it must never carry bulk user data — that stays entirely in the DPE's AXI4-Stream pipeline.

**AXI4-Stream `TUSER` carries internal routing metadata**, not protocol data: `TUSER[7]=bypass_all` (skip the DPE entirely), `TUSER[6]=bypass_stage` (skip next DPE stage), `TUSER[5:3]=src`/`TUSER[2:0]=dst` (0=CPU, 1-4=eth ports, 7=broadcast). `TID[7:0]` carries the peer index from the routing-table lookup. Endianness is mixed by design: `TDATA` is little-endian, but Ethernet/IP/UDP header fields inside it are big-endian (network order) while WireGuard protocol fields are little-endian — get this backwards and header parsing silently corrupts.

**Atomic CSR updates use a pause/drain handshake, not double-buffering.** Because the cryptokey routing table lives in plain registers (not write-buffered — 1-bit WBR costs 3 flip-flops), updating it safely means: CPU sets `csr.dpe.fcr.pause`, the round-robin input mux stops accepting new packets after its current queue, every DPE stage drains in flight and goes IDLE, CPU polls `csr.dpe.fcr.idle`, only then writes the table, then clears `pause`. Never assume a register write to routing/key tables is safe while the DPE is running.

**Every HLS/RTL/SW component instance follows a factory or `#define`+`#include` naming-prefix pattern**, not hand-copied files — see each `3.build/*_build/CLAUDE.md` and `1.hw/ip.dpe/` for the concrete conventions before adding a new instance of chacha20/poly1305/etc.

**`99.warmup/`** exercises are intentionally standalone/duplicative (their own copies of chacha20, poly1305, curve25519, blake2s, etc.) — they predate and are independent of `2.sw/app/`'s integrated versions. Don't try to unify them; they're kept as isolated bring-up references.

## Licensing

Dual/multi-licensed via REUSE (`REUSE.toml`): BSD-3-Clause is the default project license; `0.doc/`, `99.warmup/`, and generated/vendored output directories (`3.build/*/generated-files/`, `hw_build.*` build artifacts, `pipelinec_build/**`) are annotated separately as aggregated/vendored content. Check `REUSE.toml` before assuming a new file's license.
