# Decrypt throughput recovery: accepted shared 60 MHz QoR

The [summary](summary.md), [block report](blocks.md) and [results](results.json)
describe the completed 2026-10-06 run: six sizes, four packets per size per
direction, concurrent encrypt/decrypt, all taps, 48 passing reference checks
and 2459 simulated cycles. Timing/capacity, physical MCP audit, buffer
conservation and the archive-integrity check passed. No further builds or
tests were run for commit preparation.

## What changed and why

Decrypt's stripped ciphertext forks to ChaCha and authentication framing.
Without buffering, the framing/MAC branch backpressures that fork while it
waits for the ChaCha-derived key and prologue. That prevents ChaCha input from
advancing even when its pipeline and the plaintext-verification FIFO have
capacity. At packet boundaries, an ordered shared return can also wait on a
next-packet key that the MAC is not yet ready to accept. The observed
asymmetry was missing work at the authentication body, not a body II problem.

The pipelined path now stores ciphertext, keep masks and packet-last state
after that fork and before framing. Its 64 memory entries plus one FWFT
output entry let ChaCha advance during those waits. No key queues or
shared-result-buffer redesign were necessary for the measured workload.
The original legacy graph is unchanged.

Backpressure checks also exposed a pre-existing tag-packer fault: a partial
ciphertext tail was advertised while stalled, then withdrawn on ready.
It now captures that tail internally before merging tag bytes. A two-slot
full output register slice on pipelined encrypt prevents the combinational
fork's valid interlock from reaching the external AXIS port. It has II=1 and
one unstalled output cycle; it is outside the Poly1305 body. The common packer
fix applies to legacy too, but legacy receives no new FIFO or output slice.

## Separate compiler-wrapper and FIFO effects

The compiler stream-wrapper credit fix was present before taking a fresh,
unbuffered baseline. Historical pre-fix results must not be used as the
controlled FIFO baseline.

The [FIFO-only native record](native-fifo64-pilot.json) retains the before/after
loaded-source hashes, workload, packet timelines and MAC key/body/tag events.
Captured compiler-source hashes match across this pair. It replays ChaCha
core 17, body cores encrypt=3/decrypt=0 and MCP setup 6/5 in memory; these
experimental depths are not production fixed latencies or synthesis evidence.

| 1920 bytes, four packets/direction | Fixed-wrapper unbuffered | 64-memory-beat FIFO |
| --- | ---: | ---: |
| Encrypt completion period | 146 cycles | 147 cycles |
| Decrypt completion period | 194⅔ cycles | 147 cycles |
| Decrypt/encrypt sustained-goodput ratio | 75% | 100% |
| Extra decrypt key waits, packets 1–3 | 37 / 33 / 33 cycles | 0 / 0 / 0 |
| Decrypt body gaps, packets 0–3 | 0 / 30 / 22 / 0 cycles | 0 / 0 / 0 |

This isolates a **32.4% decrypt gain** and **0.68% encrypt loss** attributable
to the FIFO candidate, not to the compiler credit fix. Both bodies retain
offered II=1. Its auth high water is 55/65 beats and it drains completely.
The final source, including the output slice and tag correction, also passed
the same recorded-depth four-packet workload at 147/147 cycles.

A smaller 32-memory-beat candidate passed all eight reference checks but
measured 146/160 cycles: **91.25%** decrypt/encrypt parity, below the 95%
goal. Retain 64 rather than complicate the controller to recover those last
cycles with smaller storage; 128 was unnecessary. The 32-beat experiment
predated the output slice and is not a synthesis result.

Completed longer replays are retained in [workflow-evidence.json](workflow-evidence.json):

| Sixteen packets/direction | Body cores enc/dec | Unbuffered period enc/dec | Final buffered period enc/dec |
| --- | --- | --- | --- |
| 1420 bytes | 3 / 0 | 116⅔ / 167⅓ | 116 / 116 |
| 1920 bytes | 3 / 0 | 146 / 196.8 | 147 / 147 |
| 1420 bytes | 3 / 3 | 116⅔ / 167.467 | 116.533 / 116.467 |
| 1920 bytes | 3 / 3 | 146 / 196.933 | 147.067 / 147 |

The 3/3 final replay was interrupted after its completed 1420-byte phase;
1920 was then replayed separately and passed. Do not count the interrupted
run as a completed two-size run. Initial standalone baseline measurements
are retained as diagnostics; final standalone performance was not remeasured.

These periods exclude first-packet fill but can include uncontended final
drain. The previously analyzed 16-packet 1420-byte baseline had seven decrypt
completion intervals wholly inside the common contention window, below the
originally planned eight. On 2026-10-06 the user accepted final QoR and asked
for no additional comparisons or tests. Accordingly no 32-packet extension
or new single-direction candidate measurements were run, and no stronger
eight-interval before/after contention-window qualification is claimed.
Matched workload sizes/counts/seed do not assert byte-identical random
payloads across process hash seeds.

## Final synthesis-backed result and historical records

Rates below are sustained plaintext goodput at each record's target clock,
not at its reported maximum and not just the plaintext output burst speed.

| Packet bytes | Legacy 80 MHz enc / dec (Gb/s) | ChaCha-only pipelined 30 MHz enc / dec | Sharing-both 60 MHz, before buffering enc / dec | Sharing-both 60 MHz, recovery enc / dec |
| ---: | --- | --- | --- | --- |
| 16 | 0.330 / 0.258 | 0.240 / 0.213 | 0.284 / 0.211 | 0.278 / 0.209 |
| 64 | 0.836 / 0.710 | 0.794 / 0.562 | 1.024 / 0.781 | 1.002 / 0.755 |
| 256 | 1.354 / 1.267 | 1.807 / 1.386 | 2.926 / 2.378 | 2.880 / 1.993 |
| 1024 | 1.567 / 1.167 | 2.903 / 2.425 | 5.461 / 3.762 | 5.382 / 5.401 |
| 1420 | 1.607 / 1.060 | 3.175 / 2.518 | 5.876 / 4.009 | 5.842 / 5.859 |
| 1920 | 1.620 / 1.181 | 3.276 / 2.916 | 6.312 / 4.800 | 6.255 / 6.269 |

Original records:
[legacy 80 MHz](../shared-80mhz-probed/results.json),
[ChaCha-only pipelined 30 MHz](../shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/results.json),
[pre-buffering sharing-both 60 MHz](../shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-20261003-converged-source-20261004/results.json).
None was rerun or rewritten. Legacy's 1920-byte phase is `peak-1920`;
the newer points use `b2b-1920`. Legacy's 80 MHz timing was a lower bound,
not a measured maximum.

Final decrypt/encrypt sustained-goodput ratios are **100.29% at 1420** and
**100.23% at 1920** bytes. Against pre-buffering 60 MHz, 1920-byte decrypt
gains **30.6%**, encrypt loses **0.9%**. Against the 30 MHz archive the
actual-clock gains are **1.91×/2.15×**, and versus legacy **3.86×/5.31×**.
These historical comparisons combine clock, compiler, body-depth and
architecture changes; the controlled native pair above isolates the FIFO.

At 1920 bytes the final completion periods are 147⅓/147 cycles and median
complete-packet latencies are 203/329 cycles (3.38/5.48 µs at 60 MHz).
The FIFO does not bypass authentication: decrypt still waits for its verdict.
Equal large-packet goodput does not imply equal cold latency or small-packet
rates. The 16/64/256-byte asymmetry and AAD/length/setup overhead remain visible.

## Timing, utilization, constraints and provenance

The performance top passes the **60 MHz** goal with reported synthesis Fmax
**63.032 MHz**, limited by shared ChaCha20. It uses **48,497 LUTs, 20,540 FFs,
704/740 DSP48s and 13.5 BRAM tiles**. This is **performance-testbench area**
with constant-key folding, not new DUT-only area or routed sign-off.
No external-port or area-only build was run for this recovery change; the
earlier external-port sharing-both hardware checkpoint remains at 30 MHz.

Automatic sizes converge to ChaCha core=17, bodies=3/3, D=L=5 per direction,
shared capacity=5, prologue setup=6 and epilogue setup=5. Starting hints match
those results; automatic sizing remains unrestricted. Two sweep iterations
were used and consumed/built depths matched, avoiding another pin-confirm pass.
This is not a controlled wall-time comparison.

The previous 60 MHz perf fixture retained body depths 3/0 and used
44,442 LUTs, 17,935 FFs, 640 DSPs and 11 BRAM tiles. The new FIFO has no
arithmetic multipliers: the 64-DSP increase accompanies the changed retained
decrypt body, compiler and fixture context. Do not label the entire area
delta as the FIFO's cost. The earlier fixed-vector top also used 704 DSPs.

The retained XDC has prologue setup/hold **6/5** and epilogue **5/4** between
the MCP launch and capture registers, with matching retained input hashes.
HDL auditing finds one physical prologue and one physical epilogue, and no
registered arithmetic inside either. In every size phase each service
handled eight requests: six/five compute cycles per request, no response
stalls. Each response adds one handshake cycle; arbitration waits are
reported independently from body II and service time.

Latest auth high water is **56/65 beats** (55 at 1920); the encrypt slice
high water is one of two slots under the always-ready QoR sink. All phases
conserve accepted/retired transfers and finish with both buffers empty.
The separate comb stress exercises prolonged/periodic sink stalls.

All historical points and this run use Vivado 2019.2 and xc7a200tffg1156-2.

| Record | PipelineC at launch |
| --- | --- |
| Legacy 80 MHz | `32356330ec7c0c6ec62c46c7456734da83a53482` |
| ChaCha-only 30 MHz | `0cc6aed9caf7d6cfbdb7dd345e12d950e3303300-dirty` |
| Pre-buffering sharing-both 60 MHz | `ff0a3ec6835bac3cb3c33e3c413738baa2e3c673-dirty` |
| Final recovery QoR | `b47d0fcdf8c36fa615b8759c6bbf6cc099b2780f` (clean) |

WireGuard at final QoR was `77116452cdf9a5c51608667e5bf8dba384075689-dirty`.
[Design/include hashes](perf-source-provenance.json), [inputs](perf-inputs.json),
[sweep history](perf-sweep-history.json), [constraints](perf-clocks.xdc) and
[Vivado log](perf-vivado.log) retain the measured bytes/observations.
The resumed build+sim took 9669.1 seconds, including 5192.8 seconds of native
simulation; this excludes the interrupted attempt and earlier characterization.
The interruption was not recorded as a timing failure. Good caches were
preserved and only signature-matched observations were reusable.

Both pipelined archives use corrected 130-bit-residue arithmetic; legacy
uses the earlier limb/serial-MCP architecture. Historical wrappers could prune
verification arithmetic observed only by native checkers; the current perf
top retains verification as a real HDL output. These are not controlled
sharing-only, compiler-only or absolute external-port area comparisons.

## Impact on Issue #39

[Issue #39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)
identifies decrypt-specific key-wait overhead and proposes ciphertext
buffering before authentication framing. This implements that position in
the pipelined Pypeline design and addresses its primary measured large-packet
throughput penalty: observed extra key waits and body-input bubbles disappear,
and final large-packet encrypt/decrypt goodput is essentially equal.

It does not eliminate unavoidable AAD/length words, MCP setup/finalization,
cold verification latency, all small-packet asymmetry, or arbitrary prolonged
peer-stall coupling. The C design is unchanged. Legacy Pypeline wiring is
unchanged, although its common tag packer also receives the protocol correction.
No issue comment or closure was made. Treat this as a scoped implementation result, not closure of every
per-packet-overhead concern.
