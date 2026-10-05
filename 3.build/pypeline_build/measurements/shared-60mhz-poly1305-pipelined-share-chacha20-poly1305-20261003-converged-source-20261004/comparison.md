# Shared ChaCha20 and Poly1305 MCPs: 60 MHz QoR

The [new summary](summary.md) and [block report](blocks.md) describe the accepted
2026-10-04 run: six sizes, four packets per size, both directions concurrently,
all taps, 48 reference-checked packets and 3012 simulated cycles. Measurement,
timing/capacity, physical MCP audit and archive-integrity gates all pass.

## Sustained plaintext throughput at each actual target clock

| Packet bytes | Legacy 80 MHz enc / dec (Gb/s) | ChaCha-only pipelined 30 MHz enc / dec (Gb/s) | Sharing-both pipelined 60 MHz enc / dec (Gb/s) |
| ---: | --- | --- | --- |
| 16 | 0.330 / 0.258 | 0.240 / 0.213 | 0.284 / 0.211 |
| 64 | 0.836 / 0.710 | 0.794 / 0.562 | 1.024 / 0.781 |
| 256 | 1.354 / 1.267 | 1.807 / 1.386 | 2.926 / 2.378 |
| 1024 | 1.567 / 1.167 | 2.903 / 2.425 | 5.461 / 3.762 |
| 1420 | 1.607 / 1.060 | 3.175 / 2.518 | 5.876 / 4.009 |
| 1920 | 1.620 / 1.181 | 3.276 / 2.916 | 6.312 / 4.800 |

Historical records:
[legacy 80 MHz](../shared-80mhz-probed/results.json),
[ChaCha-only pipelined 30 MHz](../shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/results.json).
The legacy 1920-byte point is its four-packet `peak-1920` phase; the newer
records use four-packet `b2b-1920`. Neither historical QoR was rerun.

At 1920 bytes the new actual-clock rates are **1.93× encrypt / 1.65× decrypt**
versus the 30 MHz record, or **3.90× / 4.06×** versus legacy. The 16-byte
decrypt point is slightly slower than the 30 MHz record. Shared MCP setup
and finalization are not free; clock-normalized costs must be kept separate
from the higher-frequency throughput gain.

| 1920-byte metric | ChaCha-only 30 MHz enc / dec | Sharing-both 60 MHz enc / dec |
| --- | --- | --- |
| Packet completion period (cycles) | 140.67 / 158.00 | 146.00 / 192.00 |
| Sustained plaintext bytes/cycle | 13.649 / 12.152 | 13.151 / 10.000 |
| Median complete-packet latency (cycles) | 165 / 284 | 198 / 316.5 |
| Median complete-packet latency at target (µs) | 5.50 / 9.47 | 3.30 / 5.28 |

## Timing, area and sharing

The accepted perf top passes synthesis timing at **63.032 MHz** against
60 MHz, limited by shared ChaCha20. Its area is **44,442 LUTs, 17,935 FFs,
640 DSP48s and 11 BRAM tiles**. ChaCha retains 17 core registers; body cores
are encrypt=3/decrypt=0, local lane counts=5/2, shared capacity=5.
Prologue/epilogue MCP setup constraints are six/five cycles, with one extra
response handshake cycle. HDL auditing finds exactly one physical MCP per
phase and no internal arithmetic registers.

Both bodies accept one offered authentication block per cycle. Per-packet
setup/drain/finalization, tag backpressure and request arbitration waits are
not body II; the block report measures them independently. Each shared phase
handles eight requests per packet-size phase. Compute occupancy is six
cycles/request for prologue and five for epilogue, with no response stalls
in this run. Decrypt's request waits reflect contention, not wrong ownership.

This is **perf-testbench area/timing**, with constant-key and fixture-context
optimization. It is not DUT-only evidence. The distinct 60 MHz fixed-vector
top passed 21 native tests and capacity with 704 DSPs and both bodies at
core=3/local L=5; its conservative whole-top fmax statement is passing the
60 MHz goal, because its finish checker has no measured failing path.
The [workflow record](workflow-evidence.json) retains those results and the
corrected-source replay, with [fixed-testbench build output](syn-tb-build.log).

External-port sharing-both hardware is validated **only at 30 MHz**:
[hardware checkpoint](../shared-30mhz-poly1305-pipelined-share-chacha20-poly1305-20261003/hardware-evidence.json).
It uses 320 DSPs versus the prior private-MCP hardware's 512:
**192 DSPs / 37.5% saved**. This supports the area benefit at a matching
clock, but compiler revisions differ. No external-port 60 MHz hardware
timing/capacity/area result, or routed timing sign-off, is claimed.

## Comparison limitations and provenance

All three points used Vivado 2019.2 and xc7a200tffg1156-2. Compiler revisions:

| Record | PipelineC at launch |
| --- | --- |
| Legacy 80 MHz | `32356330ec7c0c6ec62c46c7456734da83a53482` |
| ChaCha-only pipelined 30 MHz | `0cc6aed9caf7d6cfbdb7dd345e12d950e3303300-dirty` |
| Sharing-both pipelined 60 MHz | `ff0a3ec6835bac3cb3c33e3c413738baa2e3c673-dirty` |

New WireGuard provenance is `214bcf56934b71d6f1459f80d64cb68cd5ba86b2-dirty`.
The [frozen design/include hashes](perf-source-provenance.json), retained
input manifests, constraints and logs identify the measured inputs more
precisely than a dirty revision alone. Synthesis continuation reused four
of six whole-design observations; two observations were newly synthesized
after interruption. The resumed build took 2:03:15, including 3210.407
seconds of native simulation; this excludes the preserved interrupted
attempt and is not the total development/discovery time.

Legacy used limb-based arithmetic and a serial MCP body. Both pipelined
records use corrected full-width 130-bit residue arithmetic. The newer
compiler includes MCP/package/sweep fixes and the depths, sharing, clock
and fixtures differ; this is not an isolated sharing-only or compiler-only A/B.

The native source now holds a word until the final converged
`valid & ready` handshake. The original fresh 60 MHz attempt was rejected
for dropped words and remains local diagnostic evidence, not an accepted
comparison point. The corrected eight-packet replay and full sweep pass
reference and exact input/output/tap byte checks.

The current perf wrapper also exposes `decrypt_perf_verified` to HDL.
Historical wrappers consumed verification only in an erased native checker;
their area/timing can include pruning of unobserved arithmetic as well as
constant folding. Even the corrected native fixture differs from arbitrary
external inputs, as the unequal retained body depths demonstrate. Original
archives are untouched; their results are not reclassified as new hardware
validation.

The source default remains 30 MHz. The new 60 MHz starting hints come from
the passing fixed-vector top, not the optimized decrypt perf depth. They
remain unrestricted hints, and were added after this QoR run. No timing or
synthesis-run reduction is claimed for a new seeded sweep until measured.
