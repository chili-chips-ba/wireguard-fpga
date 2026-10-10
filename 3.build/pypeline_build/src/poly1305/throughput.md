# Pipelined Poly1305: design and measured checkpoints

Combined builds share ChaCha20 and the Poly1305 prologue/epilogue MCPs by
default, targeting **85 MHz** with `hybrid_square` arithmetic. Other pipelined
sharing sets and standalone directions retain 30 MHz defaults. External-port
hardware and the six-size concurrent native QoR measurement pass synthesis
timing, capacity, II=1, packet results and retained-evidence integrity. At
1920 bytes the default delivers **8.093/8.126 Gb/s encrypt/decrypt**, with
**711 DSPs, 99,381 LUTs and 85.543 MHz** hardware synthesis timing.
Final pipelined fixed-vector HDL sign-off is pending; routed timing is untested.
See [verification and reproduction](#verification-and-reproduction).

The [current README results](../../README.md#current-results-hybrid-karatsuba-and-squaring-sharing-both-85-mhz)
document every size/direction, packet period and latency. The arithmetic
measurements, candidate selection and verification scope are recorded below.
The original [buffering comparison](../../measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/comparison.md),
earlier [ChaCha-only 30 MHz record](../../measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/summary.md)
and legacy 80 MHz archives are unchanged; no historical QoR was rerun.
Generated caches and scratch work files are not needed to read these results.

## Hybrid Karatsuba and explicit squares

`--poly1305-mult inferred|hybrid|hybrid_square` selects arithmetic at elaboration;
the default is `hybrid_square`. It is independent of the pipelined/legacy MAC
architecture selector. Legacy retains its five-limb schoolbook routine and
supports only `inferred`.

The pipelined helpers multiply full unsigned 130-bit canonical residues before
the existing `2^130 - 5` reducer. An exact-type registration selects the
reusable PyPeline factory `make_mult_karatsuba_inferred_leaves`, threshold 34,
for both `residue_mul_mod` and `residue_mul_add_mod`. Two sum-form Karatsuba
levels yield nine inferred 32–34-bit products. Vivado measured **36 DSPs per
130-bit multiply**, versus 64 for the original inferred wide product.
Pinned inferred leaves prevent recursive dispatch through the enclosing
operator override. The reducer's constant products are unaffected.

For even prologue exponents, `hybrid_square` uses `residue_square_mod`.
Above 34 bits the square uses sum-form Karatsuba; at 18–34 bits it computes
the two half-squares and one cross product, then doubles the cross term.
Every shift operates on a widened full-product value. A 130-bit square uses
**27 DSPs**. This shares the equal operands' cross term within a square;
it does not time-share products or change the controller/MCP architecture.

The FPGA decomposition was inspired by FPGA-House-AG's
[136-bit multiplier](https://github.com/FPGA-House-AG/ChaCha20Poly1305/blob/7e75c097af32429ff2c7979b976fe876efbdb9f3/src_dsp_opt/mul_136_kar.vhd)
and [68-bit level](https://github.com/FPGA-House-AG/ChaCha20Poly1305/blob/7e75c097af32429ff2c7979b976fe876efbdb9f3/src_dsp_opt/mul_68_kar.vhd).
WireGuard reuses independently implemented PyPeline arithmetic; no external
VHDL was copied. PyPeline's general soft/ASIC defaults remain threshold 16
with shift/add leaves. WireGuard explicitly opts into DSP-mappable leaves.

With shared MCP capacity `C`, equal local lane counts and both body products
present, the measured DSP model is `36*(2*C+1) - 9*floor(C/2)`.
At 60 MHz, automatic sizing gives seven lanes and **513 DSPs**, down from
704 for the original five-lane design. At 85 MHz, eight body core registers
give ten lanes, with shared MCP setup cycles **12/8** and **711 DSPs**.
The default authentication FIFO grows to **256 memory beats plus one output
beat** for a computed 135-beat requirement. The automatic 90 MHz configuration
selected thirteen lanes, requesting 918 DSPs and exceeding device capacity.

Focused generated-HDL multiplier, square and prologue checks passed. Native
`*` simulation computes Python products without exercising the registered
decomposition, so HDL verification is tracked separately. All six packet sizes
remain in the QoR evidence; the highest sustained rates occur at 1920 bytes.

### Operator selection and arithmetic bounds

The production registration in `poly1305_math.py` is:

```python
from operators.soft_mult import make_mult_karatsuba_inferred_leaves

register_operator("INFERRED_MULT", uint130_t, uint130_t,
                  make_mult_karatsuba_inferred_leaves(uint130_t, uint130_t,
                                                    threshold=34))
```

This is a reusable unsigned multiplier, with a WireGuard-specific exact-type
selection. It is not a key-clamp-specific product: body stride and epilogue
powers are general residues whose bits are not constrained by the original
key clamp. Both `a*b` and `a*b+c` retain a full 260-bit intermediate before
canonical modular reduction. The existing reducer folds using `2^130 ≡ 5`
and conditionally subtracts `2^130 - 5`; no general division is introduced.
The legacy schoolbook helper multiplies five 64-bit limbs, truncating to
320 bits. It remains separate; rewriting the pipelined recurrence in limbs
was not needed to obtain the measured DSP savings.

For `a=a0+2^h*a1` and `b=b0+2^h*b1`, sum-form Karatsuba computes
`z0=a0*b0`, `z2=a1*b1`, `zs=(a0+a1)*(b0+b1)`, then
`z0 + ((zs-z0-z2)<<h) + (z2<<(2*h))`. Carry growth gives two 32-bit,
four 33-bit and three 34-bit leaf products at width 130 and threshold 34.
Choosing a smaller threshold alone in the old all-soft factory would still
produce shift/add leaves. The new library's leaf policy supplies pinned
inferred multiplication while retaining the same recursion.

The measured compiler snapshot did not apply `scope=` to ordinary
module-level `@hw_func` registrations reliably. The exact-type global
registration avoids relying on that scope behavior. Its smaller inferred
leaves bypass other multiplier overrides. Configuration identity includes
the threshold and leaf policy, preventing incompatible cached elaborations.

### Arithmetic probes and candidate selection

The original isolated multiplier probes used Vivado 2019.2 on
`xc7a200tffg1156-2`, with identical explicit boundary registers and no internal
pipeline cuts. These are synthesis area comparisons, not standalone fmax
measurements: external I/O timing was unconstrained and DSP register absorption
can change the measured register-to-register span.

| Full product | Implementation | DSP48E1 | Slice LUTs |
| --- | --- | ---: | ---: |
| 130 × 130 | Inferred | 64 | 1,163 |
| 130 × 130 | Sum-form hybrid, threshold 34 | **36** | **2,081** |
| 130 × 130 | Difference-form experiment, 27 arithmetic leaves | 45 | 5,503 |
| 130 × 130 | All-soft Karatsuba, threshold 16 | 0 | 11,444 |
| 64 × 64 | Inferred | 16 | 161 |
| 64 × 64 | Sum-form hybrid, threshold 34 | 12 | 464 |

Each of these six cases passed 381 generated-HDL product checks: structured
boundaries plus deterministic random inputs, seed 8439. The difference form's
lower arithmetic leaf count did not translate to fewer DSPs. The all-soft
option trades substantial LUT cost for zero DSPs; these measurements did not
justify replacing all of the design's wide multipliers with it.

Subsequent square probes used the production reducer and a seven-lane
prologue power graph, with the same boundary-register policy for each
comparison. They also establish area, not full-design timing.

| Probe | Inferred DSP / LUT | Hybrid DSP / LUT | Hybrid square DSP / LUT |
| --- | ---: | ---: | ---: |
| Raw 130-bit square | 64 / 1,163 | 36 / 2,085 | **27 / 1,783** |
| Modular square, existing reducer | 64 / 1,545 | 36 / 2,450 | **27 / 2,148** |
| Seven-lane prologue | Not synthesized | 216 / 14,923 | **189 / 14,018** |

The explicit modular square saves nine DSPs and 302 LUTs versus a tied-input
hybrid multiply. The prologue saves 27 DSPs and 905 LUTs, with both versions
using 1,040 slice registers. This qualified squaring for the full-design trial.

All three arithmetic candidates then passed the same six-size QoR workload
and independent external-port hardware synthesis at **60 MHz**. The selection
criterion was minimum full-design DSPs, subject to correctness, timing and fit.

| 60 MHz external-port hardware | Inferred | Hybrid | Hybrid square |
| --- | ---: | ---: | ---: |
| DSP48E1 | 704 | 540 | **513** |
| Slice LUTs | 54,226 | 76,686 | 75,773 |
| Registers | 23,200 | 26,382 | 26,382 |
| BRAM tiles | 13.5 | 13.5 | 13.5 |
| Body core registers / lanes per direction | 3 / 5 | 5 / 7 | 5 / 7 |
| Prologue / epilogue MCP setup cycles | 6 / 5 | 7 / 5 | 7 / 5 |
| Slowest reported synthesis MHz | 62.889 | 62.162 | 62.162 |

Hybrid-square wins with **191 DSPs saved (27.1%)**. The initial 396-DSP
projection assumed five lanes stayed sufficient; actual automatic sizing
requires seven lanes. Both hybrid variants have identical measured goodput
at 60 MHz: 5.696/5.712 Gb/s at 1420 bytes and 6.130/6.158 Gb/s at 1920 bytes.
The DSP saving enables the higher-clock results in the README, culminating
in 85 MHz with 711 DSPs and 8.093/8.126 Gb/s at 1920 bytes.

There are `2*C+1` full-width product sites when both body pipelines are
present: two bodies, `C-1` prologue powers and `C` epilogue terms. Of these,
`floor(C/2)` are even-exponent squares. Thus `hybrid_square` uses the model
`36*(2*C+1) - 9*floor(C/2)`, matching 513 DSPs at seven lanes and 711 at ten.
At ten lanes, ordinary hybrid would project to 756 DSPs, beyond the 740-DSP
device; explicit squaring saves 45 DSPs in that configuration.

The automatic 90 MHz trial chose eleven body core registers and thirteen
lanes, projecting 918 DSPs. Vivado reported 918 requested against 740 available;
its final mapping still needed 174,122 LUTs against 134,600 available, with
737 DSPs mapped. The compiler stopped before timing feedback and packet
simulation. The measured automatic sweep therefore passes at 85 MHz and
fails capacity at 90 MHz. This does not prove every possible pipeline placement
at 90 MHz fails, or establish a routed timing limit.

### Verification and reproduction

The measured toolchain was Vivado 2019.2, with an isolated PipelineC snapshot
based on `2be7c274c8388905296a0afc143e1cfd6ea6ef2b`. Sources were frozen with
working-tree changes; a revision alone is not an exact source identity.
The compiler provides `make_mult_karatsuba_inferred_leaves` and pinned inferred
leaves. WireGuard integration did not modify the original compiler checkout.

Completed checks include:

- Seven CLI/profile/provenance checks, including the no-flag 85 MHz
  hybrid-square selection and historical cache naming.
- `measure.py --selftest`: report/model guards, historical parse-only behavior,
  saved provenance and archive integrity.
- 211 generated-HDL modular multiplication vectors.
- 572 native full-product and 38 modular square cases; 75 generated-HDL
  vectors per variant for raw squares, modular squares and prologue powers.
- All six packet sizes at each accepted 60/70/80/85 MHz QoR point, four packets
  per size and direction, with concurrent encrypt/decrypt, seed 8439 and all
  taps. Acceptance checks include timing, device fit, II=1 and MCP sharing.

As of October 10, 2026, final shared pipelined fixed-vector HDL sign-off is
running at 85 MHz, followed by the 60 MHz resource-saving checkpoint. It uses
the existing ten encrypt and eleven decrypt vectors, including tampered-tag
rejection. This sign-off is pending; routed timing is also untested. Two older
synthetic native latency-cache tests reproduce failures on untouched sources
with this compiler (expecting three lanes, receiving two); they do not establish
a production arithmetic regression.

From the build directory, use a PipelineC checkout providing the API above.
These public commands select the measured profiles without investigation scripts:

```sh
# Highest measured throughput profile; same as the current defaults.
./build.py --shared --target-mhz 85 --poly1305-mult hybrid_square -j 1 --continue
# Lowest-DSP checkpoint and original arithmetic baseline.
./build.py --shared --target-mhz 60 --poly1305-mult hybrid_square -j 1
./build.py --shared --target-mhz 60 --poly1305-mult inferred -j 1
# Generated-HDL packet sign-off; use --target-mhz 60 for the lower-clock profile.
./build.py --shared --sim --syn_tb --target-mhz 85 --poly1305-mult hybrid_square -j 1 --continue
```

For the full QoR workload, use the command in the
[README measurement section](../../README.md#measuring-qor-fmax-area-throughput-latency).
Use `--area-from-dir` only with a separately completed external-port hardware
build of the same profile. `--continue` retains one output directory;
`--syn-cache` reuses matching HDL/XDC/device/tool inputs across directories.
Separate source copies must use the same absolute synthesis-store location.

## Independent MCP sharing

Current combined builds select sharing independently: no flags or `--shared`
select both; either `--share-chacha20` or `--share-poly1305` alone selects only
that resource; both positive flags select both. Single-direction builds reject
sharing selectors. Legacy combined builds require
`--share-chacha20 --poly1305 legacy`. Direct compiler invocation takes the same
selection as the `-D SHARE=none|chacha20|poly1305|both` design parameter (see
`src/wireguard_env.py`). Cache names include implementation, sharing set and clock.

`poly1305_mcp_shared.py` owns two independent request-aware round-robin
arbiters and two whole-function automatic MCPs: one prologue, one epilogue.
A lone requester is served immediately. Priority changes only on accepted
requests; a stalled grant/payload remains stable under the requester's
valid/ready contract. A direction bit travels through each MCP and routes
its response independently of current priority. Responses remain valid and
stable until accepted. There is **no packet-wide ownership lock**: encrypt's
prologue and decrypt's epilogue can execute concurrently.

Each MAC retains its private free-running, valid-only body pipeline and
key/powers/accumulator context. For each direction,
`L_direction = body_core_latency + 2`, including the two actual body boundary
registers. Shared capacity is `C = max(L_encrypt, L_decrypt)`, derived from
the consumed automatic depths and checked through re-elaboration/confirmation.
The body callable identities do not depend on C or L.

The shared prologue computes powers through `r^C`; each client keeps its own
prefix and uses `r^L_direction` as the body stride. Epilogue requests carry
local L, the next-dispatch lane, s, and zero-padded accumulators/powers.
Rotation uses **local L, not C**. One product per capacity slot and a balanced
modular sum remain inside the epilogue MCP; inactive slots contribute zero.
There are no inverse powers, fixed production depths or automatic maximums.

### Historical inferred checkpoints

| Top / goal | ChaCha core | Body cores enc/dec | Local L enc/dec | C | Prologue / epilogue setup cycles | DSP48 | Outcome |
| --- | ---: | --- | --- | ---: | --- | ---: | --- |
| External-port hardware / 30 MHz | 4 | 0 / 0 | 2 / 2 | 2 | 1 / 2 | 320 | PASS, synthesis 30.05 MHz |
| Fixed-vector native syn_tb / 60 MHz | 17 | 3 / 3 | 5 / 5 | 5 | 6 / 5 | 704 | PASS, 21 checks, 688 cycles |
| Earlier perf/native QoR / 60 MHz, unbuffered | 17 | 3 / 0 | 5 / 2 | 5 | 6 / 5 | 640 | PASS, 48 packets, 3012 cycles, synthesis 63.032 MHz |
| Latest perf/native QoR / 60 MHz, buffered | 17 | 3 / 3 | 5 / 5 | 5 | 6 / 5 | 704 | PASS, 48 packets, 2459 cycles, synthesis 63.032 MHz |

The following discussion records the inferred arithmetic before the hybrid
integration. Current 60/70/80/85 MHz external-port results and the 90 MHz
capacity stop are documented in [the arithmetic comparison above](#arithmetic-probes-and-candidate-selection)
and the [README frequency comparison](../../README.md#resource-and-throughput-comparison).

MCP setup cycles exclude the one response handshake cycle: the latest
prologue/epilogue responses take seven/six cycles before arbitration wait.
The fixed-vector top passes the 60 MHz goal; its lowest measured compute
MAIN is ChaCha at 62.889 MHz, but an unmeasured finish checker means the
whole-top fmax claim remains a 60 MHz lower bound. The perf top has measured
final MAIN timing and 48,498 LUTs, 20,541 FFs and 13.5 BRAM tiles.

The latest perf wrapper retains `decrypt_perf_verified` as a real HDL
output, unlike the historical wrappers. Both latest body cores retain three
registers and L=5, matching the earlier fixed-vector checkpoint. The earlier
perf record retained encrypt L=5/decrypt L=2 and exercised unequal local
rotation through the same C=5 services. Different fixtures and compiler
revisions permit different optimizations: neither record is an arbitrary-key
external-port area result. In particular, the new FIFO does not introduce
arithmetic multipliers; do not attribute the 640-to-704 DSP change solely to it.

The 30 MHz [hardware checkpoint](../../measurements/shared-30mhz-poly1305-pipelined-share-chacha20-poly1305-20261003/hardware-evidence.json)
saves **192 DSPs (37.5%)** versus the archived private-MCP design's 512.
Measured 64-DSP full-width multipliers predict sharing-both capacity C=5
at 704 DSPs, C=6 at 832, C=7 at 960 when both bodies remain present.
Actual synthesis/capacity evidence is authoritative; the performance
wrapper's fixture-specific area is not an external-port hardware budget.

### Functional coverage and corrected native sources

Both native testbench styles passed for standalone enc/dec and all three
sharing sets; a legacy ChaCha-only fixed-vector smoke test also passed.
The existing standalone Poly1305 testbench's `sharing` mode checks
concurrent and lone requests, alternating ties, held grants, response
backpressure/ownership, simultaneous response/relaunch and independent
phases. Pure five-slot checks exercise local lane counts 2, 3 and 5, every
rotation, inactive nonzero slots and zero/unit/maximal keys. Normal MAC tests
cover short/long packets, changing/repeated keys, forwarding, drain and
stable held tags. The 60 MHz fixed-vector integration checks also cover
ciphertext/plaintext, tag, framing, keep masks and tampered-tag rejection.

The earlier sharing commit regression passed 14 checks: 11 native combinational
integration/fallback builds, the directed sharing mode, and two seeded-60
no-synthesis HDL checks. The hardware HDL check exercises the new 60 MHz
default without an explicit clock. Those earlier results remain in their
[workflow record](../../measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-20261003-converged-source-20261004/workflow-evidence.json);
these HDL checks are not additional synthesis timing evidence. The recovery
change passed another 11-build comb matrix (205 packet checks), a 33-packet
stress run, recorded-depth replays and a 48-packet QoR. Its historical
workflow record retains completed evidence and explicitly notes omitted
extended-overlap and standalone-performance comparisons.

An initial full QoR attempt was correctly rejected when five encrypt frames
were 16 bytes short. A replay proved that the native source advanced on
pre-convergence ready at cycle 46; the DUT never accepted those beats.
The converged AXIS source (`tb_common_sim.ConvergedAxisSource`, now PipelineC's
`axi.axis_sim.ConvergedAxisSimSource`) presents without advancing in
`@sim_input` and commits `valid & ready` in the converged `@sim_output` callback.
Input accounting uses that same handshake. This is a WireGuard testbench
correction, not a Poly1305 arithmetic or compiler change. The strict
eight-packet replay and corrected full 48-packet sweep pass exact
byte/tap accounting and reference checks. Historical records remain unchanged.

Measurement metadata records the implementation, shared capacity, local
body/core latencies and MCP cycles. HDL auditing checks **one physical MCP
per shared phase** and no registered arithmetic inside either MCP.
The block report separates private body service (II=1) from setup, drain,
finalization, tag stalls, arbitration waits and physical MCP service time.
Prologue and epilogue each handled eight requests per size, taking six
and five compute cycles respectively, without response stalls.

### Historical inferred starting hints and higher-clock limitations

The 30 MHz starting hints are unchanged. The 60 MHz starting entry uses the
confirmed fixed-vector ChaCha=17, bodies=3/3, shared MCPs=6/5 result;
private ChaCha/MCP hints remain their 30 MHz fallback. The perf-only
decrypt depth of zero is not used as a hardware hint. Profiles remain
unrestricted starting guesses; subsequent sweeps may change them.
The latest recovery QoR confirms those seeds unchanged in two sweep iterations;
all consumed depths matched the built pipelines, avoiding another
pin-and-confirm pass. This is not a controlled synthesis wall-time comparison.
The older QoR archive still records its pre-hint discovery source.

That earlier inferred campaign had no accepted 80 MHz result: private encrypt's confirmation exceeded
the 740-DSP device budget (896 DSPs) and also suffered an OOM kill.
Private enc/dec 70 MHz native syn_tb passed, each with 640 DSPs and body
core=3/L=5. Sharing-both 70 MHz instead confirmed C=7 at **960/740 DSPs**.
Its real fixed-vector critical path plateaued around 65.39 MHz through the
fixture's byte counter, shared ChaCha request/ready arbitration and packet
counter. Compute-depth growth did not split that boundary path; hotspot
attribution and restored-snapshot selection remain deferred sweep issues.
The 44-stage ChaCha result from that failed run is not the accepted 17-stage
60 MHz result. Failed timing/capacity results are not functional waivers.

Earlier compiler fixes for conditional MAIN discovery and native Reg-array
augmented assignment were made by the compiler session, not this session.
Stateful WireGuard fixed-vector MAINs were also incorrectly tagged
`@wires`; removing that promise gives them normal timing checks. The current
shared builds, native simulations and measurement acceptance report no
new blocking compiler issue. Generic sweep/compiler regressions belong in
PipelineC's suite, not a WireGuard `tests/` directory. Directed checks use
the existing unit testbench directly; see [standalone commands](#standalone-testbenches).

## Decrypt fork decoupling — accepted QoR, 2026-10-06

The pipelined dataflow now adds a ciphertext FIFO after decrypt's fork and
before authentication framing. It does not change the MAC's complete-16-byte
authentication-block contract, arithmetic, lane sizing or body II=1 pipeline.
The accepted recovery measurement used 64 memory beats plus the FWFT output
register (65 beats total). A 32-beat native candidate passed correctness but reached
only 91.25% decrypt/encrypt parity at 1920 bytes (146/160-cycle periods),
below the 95% goal. The 64-beat candidate reached parity; 128 was unnecessary
for that measured workload. The current default instead uses the conservative
automatic derivation below, covering all ChaCha credits rather than only the
observed concurrent occupancy. These are storage budgets, not automatic compute
latency limits. Legacy dataflow wiring is unchanged.

### Automatic authentication FIFO sizing

`aead_types.decrypt_auth_fifo_sizing` reads the **selected** private/shared
ChaCha stream wrapper's `.max_in_flight` and `.auto_pipeline.latency`, plus
the selected MAC's `.prologue_mcp.mcp.latency`. PipelineC's normal
pin-and-confirm re-elaboration regenerates the depth and native metadata from
the final latencies. Starting hints are never used as final storage limits.
The selected latency/credit values are recorded in the measurement's
configuration and checked by acceptance guards.

Let `R = CHACHA20_BLOCK_SIZE / AXIS128_BEAT_BYTES = 4`,
`C = ChaCha max_in_flight = core_latency + 5`,
`P = prologue MCP latency`, `S = 1` when MCPs are shared (`0` otherwise), and
`A = ceil(AAD_MAX_LEN / AXIS128_BEAT_BYTES) = 2`. The beat budget is:

```text
required = R*C + (R+1) + 1 + 2 + 1 + (1+S)*(P+1) + 2 + A
memory_depth = ceil_pow2(max(2, required))
total_capacity = memory_depth + 1
```

| Term | Storage or bounded wait |
| --- | --- |
| `R*C` | All shared-pipeline credits may belong to decrypt; each holds at most R ciphertext beats |
| `R+1` | Widening accumulator (R) plus its narrow input register (1) |
| `1` | Authentication fork can accept one copy ahead of ChaCha |
| `2` | FWFT push-to-valid startup |
| `1` | Framing IDLE-to-AAD/ciphertext transition |
| `(1+S)*(P+1)` | Own prologue service plus one preceding peer service when shared; each includes its response handshake |
| `2` | MAC key-to-prologue launch and response-to-body transitions |
| `A` | Maximum padded AAD beats before ciphertext |

At a next-key barrier ChaCha cannot retire that packet's payload until the
MAC accepts the key. Accepted ciphertext is therefore bounded by pipeline
credits, widening storage, and the fork's copy lead. Body drain, epilogue and
tag-output waits occur behind that barrier: they can fill the credit budget
but do not require an additional unbounded time-to-beats term. Once the key
is accepted, ingress can add at most one beat per setup/framing cycle; when
ciphertext framing starts, the II=1 body keeps pace. The service bound assumes
the existing two-client arbitration and both MACs promptly consuming their
prologue response. Prolonged external stalls still propagate backpressure.

For retained 60 MHz depths, `C=22`, `P=6`, `S=1`: the terms total **115
beats**, rounded to **128 memory beats / 129 total slots**. The confirmed
30 MHz shared hints (`C=9`, `P=1`) give 53 beats, rounded to 64 memory beats.
This is conservative automatic sizing, not a claim that the smallest FIFO
meeting a particular throughput target is 128 beats.

The decrypt factory retains `auth_fifo_depth=None` for automatic sizing,
an integer at least two for explicit sizing, and zero to disable the FIFO.
Legacy bypasses sizing altogether. Buffering metadata records the derivation,
requested memory depth, actual rounded memory depth, and output register;
measurement acceptance checks new automatic budgets while accepting older
records without sizing metadata.

The automatic-sizing qualification completed on **2026-10-07**: all 48
six-size QoR checks passed at retained depths 17 / 3,3 / 6,5, with 63.032 MHz
synthesis timing. Matched-depth native runs of automatic 128 and explicit 64
memory beats passed 32 checks and gave identical goodput at 1420/1920 bytes.
The fresh record's high water is 56/129 slots; all phases conserve transfers
and drain to zero. Explicit target rates on every WireGuard MAIN also remove
the unused finish checker's `clk_None` port: HDL/XDC contains only `clk_60p0`,
and Vivado reports no unclocked register or unconstrained internal pins.
The [current README results](../../README.md#current-results-hybrid-karatsuba-and-squaring-sharing-both-85-mhz)
document the selected toolchain, depths and automatic FIFO metadata.

### Original 64-beat recovery qualification

This implements the ciphertext-buffer position proposed by
[Issue #39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39) for the
pipelined Pypeline design. It allows ChaCha to accept ciphertext while the MAC
waits for its key/prologue. It does not eliminate common AAD/length overhead,
change the C design, or guarantee isolation from arbitrary peer stalls.
No per-direction key FIFOs were needed for the measured workload. Shared
result buffering and prolonged peer-stall isolation were not redesigned.

The compiler's stream-wrapper credit fix was established before the hardware
change. Under matched recorded depths, the fixed-wrapper baseline still
stalled decrypt on MAC key/setup; the FIFO removes those observed extra waits.
The fresh shared 60 MHz performance build then passed with the actual
converged ChaCha/body/MCP latencies 17 / 3,3 / 6,5. Its 1420-byte sustained
rates are 5.842/5.859 Gb/s and its 1920-byte rates 6.255/6.269 Gb/s
(encrypt/decrypt at target). Both body service periods remain one cycle.
This is performance-top synthesis and native QoR, not new external-port
timing/area or routed sign-off.

The completed FIFO-only 1920-byte native pilot (four packets/direction) has
147/147-clock encrypt/decrypt periods, versus 146/194⅔ for the fixed-wrapper
baseline. All 16 before/after packet checks passed; captured compiler-source
hashes match. Extra decrypt key waits and body gaps both disappear, with body
II=1 unchanged. This isolates the FIFO's 32.4% decrypt gain and 0.68% encrypt
loss from compiler changes, but is recorded-depth replay evidence, not
synthesized QoR. The final output-slice source also passes at those modeled
depths. Sixteen-packet replays at both 3/0 and 3/3 body profiles give near-equal
large-packet completion periods. The earlier 1420-byte baseline has only seven
decrypt intervals in the common contention window, below the planned eight;
the user accepted final QoR without requesting its 32-packet extension.
No stronger steady-contention before/after acceptance is claimed. Relevant
numbers and completion timelines are documented in the historical measurement
records linked above.

Backpressure qualification additionally found the tag packer advertising a
partial ciphertext tail before it could be merged, then withdrawing valid on
ready. It now holds that tail internally without offering a malformed beat.
The combinational fork's valid interlock must not be exposed directly at the
external encrypt port either. Pipelined encrypt therefore has a full two-slot
output register slice (II=1, one unstalled cycle), outside the MAC/body pipeline.
Body D=P+2 and L=D are unchanged. Legacy wiring remains unchanged; the common
partial-tail protocol correction applies to both architectures. Final-source
comb stress covers input gaps, simultaneous FIFO transfers, partial keeps,
prolonged output stalls and tampered tags. Original recovery QoR high water is 56/65
auth beats; all size phases conserve accepted/retired beats and drain to zero.
Equal sustained large-packet goodput does not eliminate cold verification
latency or small-packet framing/setup overhead. Thus the primary decrypt
key-wait throughput concern in Issue #39 is addressed here, not every
per-packet overhead or the untouched C/legacy path.

## Logical checkpoint at 30 MHz

The archived ChaCha-only shared hardware build confirmed an automatic body core latency of
zero for both directions. The actual body still has its explicit input and
output registers: `D = 2`, `L = 2`. It accepts one block per cycle; zero *extra*
core stages does not mean zero latency or a single-accumulator MCP loop. The
prologue and epilogue MCPs settled at one and two constrained cycles respectively,
and the emitted arithmetic inside all four MCPs contains no internal registers.

For example, after three blocks, the interleaved recurrence gives
`A0 = c0*r^2 + c2`, `A1 = c1` (all modulo p). Because the next-dispatch lane is
one, the epilogue computes `A0*r + A1*r^2 = c0*r^3 + c1*r^2 + c2*r`, exactly
the scalar Poly1305 accumulator. After two blocks, the weights instead give
`A0*r^2 + A1*r`. These rotated weights also cover short packets and `r = 0`
without inverse powers. Same-cycle writeback forwarding lets a lane be reused
exactly two cycles after launch; draining prevents finalization from reading
unfinished results. Arithmetic and native MAC regressions cover multiple body
depths, every lane rotation, key changes, input gaps and tag backpressure against
an independent reference. Standalone GHDL RTL checks passed in both combinational
and synthesized configurations, including continuous II=1 launches. The full
AEAD integration matrix and final QoR acceptance also passed.

Reproducible unit checks live in one standalone testbench invoked directly by
`pypelinec`, not through the top-level `build.py`. See
[standalone commands](#standalone-testbenches). Its isolated fixed-depth stress
configurations exercise L=2,3,5,8 without changing the automatic production
factory or claiming timing passes at those depths.
Compiler cache/re-elaboration/sweep regressions belong in PipelineC's own
suite, not a WireGuard unit-test directory. Local compiler handoffs and repros
remain in the disposable validation workspace.

The body-rate ceiling at 30 MHz is `16*30 = 480 MB/s` (3.84 Gb/s), versus the
recorded legacy six-cycle loop's `16*80/6` MB/s (1.707 Gb/s) at 80 MHz: a 2.25x
body-only ceiling ratio. These are not measured packet throughput. Shared ChaCha,
framing, setup, drain, finalization and stalls can dominate; both actual-clock
packet rates and cycle-normalized results must be compared before claiming an
end-to-end improvement. The 30 MHz timing pass is a checkpoint for this device,
not proof that a higher-frequency architecture is impossible.

## Legacy architecture (selectable fallback)

```text
                     key_if
                       │
                       ▼
               ┌───────────────────────────────┐
  data_in_if   │       poly1305_mac_fsm        │   auth_tag_if
  ────────────►│                               ├──────────────►
               │  Registers & Operations:      │
               │    • a (single accumulator)   │
               │    • r, s                     │
               │    • + s tag step             │
               └───┬───────────────────────▲───┘
                   │                       │
        to_compute │                       │ from_compute
         (a, r, c) │                       │ (a_next)
                   ▼                       │
               ┌───────────────────────────┴───┐
               │          compute_mcp          │
               │  (loop body multi-cycle path) │
               └───────────────────────────────┘

```

The recorded legacy implementation processes one 16-byte block every six
cycles: a five-cycle MCP constraint plus its handshake cycle. The selectable
legacy build still starts its automatic MCP search at five; its final count
may differ if timing requires it.

There is no start of packet prologue computation (`r` comes directly from `key`), and the epilogue is simply the `+ s` addition single cycle state inside FSM.

The development sketch with multiple staggered MCP engines was not implemented.
The current design instead has one feed-forward body pipeline per MAC; lane
count follows its complete registered latency, not a guessed MCP cycle count.

## Pipelined MAC design

## Implemented contract

The implementation uses separate, whole-function automatic MCPs for the
prologue and epilogue, with a free-running valid-only automatic body pipeline.
There is no body ready signal, skid buffer, or output FIFO. The public MAC
ports retain their valid/ready contracts. Powers are recomputed for every
packet, with one packet context active at a time.

Let P be the discovered body `AUTO_PIPELINE.latency`. Including its explicit
input and output registers, D = P + 2; use L = D accumulators with same-cycle
writeback forwarding. The recorded characterization was unseeded. Current
source supplies clock-profile `start_latency` hints (at 30 MHz, body P=0,
prologue=1, epilogue=2 in each direction), with no fixed depths or maximum
latencies. L still follows the actual discovered body latency, not the hint.

### Arithmetic representation and initial synthesis finding

The new design uses 130-bit residue values for lane state, powers, and every
pipeline/MCP boundary. Multiplication produces an exact 260-bit product. For
any 260-bit value, fold its upper 130 bits by five into the lower 130 bits;
the 133-bit sum is below `6*2^130`. A second fold leaves a 131-bit value below
`2^130+25`, so one subtraction of the full modulus produces a canonical
residue. Addition uses a 131-bit intermediate and the same modulus identity.
These helpers are in the shared arithmetic module; the legacy datapath keeps
its corrected 320-bit limb helpers.

An initial implementation transporting 320-bit values synthesized to 313,763
LUTs (233.11% of the device) and 727 DSPs (98.24%) before final lane/depth
convergence. That oversized search was stopped, and its artifacts preserved
in local generated caches. This is an intermediate diagnostic, not a passing
timing or QoR result. Narrowing the arithmetic preserves the equations and
control architecture; the completed functional gates cover the narrowed version.

### Corrected accumulator convention

The earlier combination of `(A+c)*r^L` and positive final lane weights
double-counted powers of r. Instead, for each complete 16-byte block:

$$c_i = \operatorname{LE}(\mathrm{block}_i)+2^{128},\quad
  A_{i\bmod L}\leftarrow(A_{i\bmod L}r^L+c_i)\bmod p.$$

For N blocks, the final accumulator is:

$$a=\sum_{j=0}^{L-1} A_j r^{1+((N-1-j)\bmod L)}\bmod p.$$

Only the next-dispatch lane N mod L is needed to select the weights. When
N mod L = 0 these are the r^L ... r weights drawn below; other packet endings
rotate the weights. Unused lanes remain zero. For a one-block message this
produces c_0*r, including when r=0. The tag is (a+s) mod 2^128.

The historical option comparisons below are architectural discussion, not
measured claims for this implementation. In particular, dedicated MCPs alone
do not enable packet overlap or guarantee zero inter-packet bubbles.

Schematic-style dataflow between blocks: The FSM orchestrates use of the prologue MCP, body pipeline, and epilogue MCP.

```text
                                                 key_if (r, s)
                                                       │
                                                       ▼
           ┌───────────────────────────────────────────┬───────────────────────────────────────────┐
           │                                 new_poly1305_mac_fsm                                  │
           │                                                                                       │
           │  Registers:                                                                           │
           │    • A_0 … A_{L-1} (L accumulators)                                                   │
           │    • r^1 … r^L (powers of r array), s                                                 │
           │                                                                                       │
data_in_if │  Input Dispatch:                                                 Output Writeback:    │ auth_tag_if
──────────►│    Round-robin select                                              Round-robin        ├────────────►
           │    (c_i -> lane j)                                                 retire to A_j      │
           │                                                                                       │
           └────┬─────────────────┬─────────────────┬──────────────┬────────────┬──────────────┬───┘
                │                 ▲                 │              ▲            │              ▲
    to_prologue │   from_prologue │      to_compute │ from_compute │to_epilogue │from_epilogue │
            (r) │ (r^1…r^L array) │ (A_j, r^L, c_i) │   (A_j_next) │  (A_regs,  │   (auth_tag) │
                │                 │                 │              │   r_pows,  │              │
                ▼                 │                 ▼              │      s)    │              │
                │                 │                 │              │            ▼              │
           ┌────┴─────────────────┴────┐       ┌────┴──────────────┴────┐  ┌────┴──────────────┴────┐
           │        prologue_mcp       │       │    compute_pipeline    │  │      epilogue_mcp      │
           │       (multi-cycle)       │       │ (autopipelined, II=1)  │  │     (multi-cycle)      │
           │                           │       │                        │  │                        │
           │     Computes powers:      │       │    Streaming loop:     │  │   Weighted Combine:    │
           │      r^2, r^3 … r^L       │       │   A_j · r^L + c_i    │  │   ∑ (A_j · r^{L-j})    │
           │                           │       │                        │  │   Final tag add: + s   │
           └───────────────────────────┘       └────────────────────────┘  └────────────────────────┘
```

Logical algorithm execution diagram (illustrative L=4; final weights shown
for N mod L=0 only; other endings rotate them):

```text
════════════════════════════════════════════════════════════════════════════
   Prologue: Start of Packet (Runs Once per Packet)
────────────────────────────────────────────────────────────────────────────
   Compute powers of r through r^L for each accepted packet key.
   r^L is body stride multiplier; r^1 -> r^L values for epilogue.

════════════════════════════════════════════════════════════════════════════
        Body: Incoming 16B Blocks (1 beat/cycle):
────────────────────────────────────────────────────────────────────────────
     ──► [ c_3 ] ──► [ c_2 ] ──► [ c_1 ] ──► [ c_0 ]
            │           │           │           │
            ▼           ▼           ▼           ▼
         [ A_3 ]     [ A_2 ]     [ A_1 ]     [ A_0 ]   (L Accumulator Registers)
            │           │           │           │
            └───────────┼───────────┼───────────┘
                        │
                        ▼
             Round-Robin Dispatch
          (Pairs c_j with A_j and r^L)
                        │
   Cycle 0: (A_0, r^L, c_0) ───┤
   Cycle 1: (A_1, r^L, c_1) ───┤  ◄── No cross-lane dependencies:
   Cycle 2: (A_2, r^L, c_2) ───┤      each beat reads a distinct A_j
   Cycle 3: (A_3, r^L, c_3) ───┘
                        │
                        ▼
                compute_pipeline (Depth D, II = 1)
 ───────────────────────────────────────────────────────────────────────────
   [ Stage 1 ]     ──►     [ Stage 2 ]     ──►  ...  ──►     [ Stage D ]
  (A_3, r^L, c_3)         (A_2, r^L, c_2)                   (A_0, r^L, c_0)
 ───────────────────────────────────────────────────────────────────────────
                        │
                        ▼
              Round-Robin Writeback
          (Retires A_j_next back to A_j)
            │           │           │           │
            ▼           ▼           ▼           ▼
         [ A_3 ]     [ A_2 ]     [ A_1 ]     [ A_0 ]   ◄── SAME L Accumulators as above
            │           │           │           │          (Updated and ready when block
            │           │           │           │           c_{j+L} arrives if L >= D)
            └───────────┼───────────┼───────────┘
                        │
                        ▼ (Loop repeats until Last Block)

════════════════════════════════════════════════════════════════════════════
        Epilogue: End of Packet Combine (Runs Once per Packet)
────────────────────────────────────────────────────────────────────────────
          A_0           A_1           A_2           A_3   (From registers above)
           │             │             │             │
        * r^4         * r^3         * r^2         * r^1   (Weighted Fold)
           │             │             │             │
           └──────►──────┴──────►──────┴──────►──────┘
                                │
                                ▼
                        ∑ (A_j · r^{L-j}) mod p
                                │
                             +  s  mod 2^128              (Final Tag Step)
                                │
                                ▼
                           auth_tag_if
```

**Core Architecture Shift**
The single-stream bottleneck is eliminated by replacing the multi-cycle path (MCP) with a fully autopipelined feedforward arithmetic block (**`compute_pipeline`**) with an initiation interval of $\text{II} = 1$ and a latency of $D$ cycles.

---

## **1. Prologue (Setup before message beats)**

* **Key Derivation:** ChaCha20 counter 0 produces a 32-byte keystream block, parsed and clamped into:
  * $r$ (clamped 128-bit key)
  * $s$ (128-bit additive tag key)


* **Power Computation (mod $p = 2^{130}-5$):** Compute and latch the set of powers up to $r^L$:
  * $r^2 = (r \cdot r) \pmod p$
  * $r^3 = (r^2 \cdot r) \pmod p$
  * $r^4 = (r^2 \cdot r^2) \pmod p$
  * In general, $r^k = r^{\lfloor k/2\rfloor}r^{\lceil k/2\rceil}\pmod p$.
    The whole unrolled dependency graph is inside one automatic MCP.
  * *Purpose:* $r^L$ serves as the constant stride multiplier during streaming; $r^1 \dots r^L$ are retained for the epilogue.


* **Accumulator Reset:** Initialize all $L$ lane accumulators to zero:



## **2. Streaming Message Loop (1 block/cycle, $\text{II} = 1$) Two-Part MAC FSM Architecture**
The FSM decouples into two concurrent, pipelined processes:

* **Input Dispatch (Round-Robin):**
  * Incoming 16-byte message blocks ($c_i$) are dispatched round-robin across $L$ independent accumulator registers ($A_0, \dots, A_{L-1}$).
  * Each accepted input cycle launches $(A_j, r^L, c_i)$ into `compute_pipeline`.
    Input gaps leave the dispatch pointer unchanged. All lanes step by the
    stride factor $r^L$ rather than $r$.
  * Multiple independent block computations remain in flight simultaneously, saturating the pipeline.


* **Output Writeback (Round-Robin):**
  * As valid updated accumulators emerge $D$ cycles later, an output round-robin tracker retires each $A_{j,\text{next}}$ into its designated accumulator register. Invalid pipeline bubbles do not advance this tracker.

* **Timing Constraint:** Here $D$ includes both boundary registers, and same-cycle writeback forwarding permits $L=D$. Sizing $L \ge D$ with that forwarding guarantees that by the time Lane 0 is scheduled to ingest block $c_L$, its previous update from block $c_0$ has already retired—achieving bubble-free, stall-free operation.



---

## **3. Epilogue (Finalization after last beat)**
After the final accepted block, the controller drains every outstanding body
result before launching the epilogue. Because the strided lanes compute
independent partial polynomials, combining them requires a **weighted sum**.
All lane products, the balanced modular-addition tree, and the final addition
of $s$ are inside one whole-function automatic MCP.

### **Weighted Combine:** Fold all $L$ partial polynomial accumulators using the precomputed powers, rotated by the accepted block count $N$ modulo $L$:

$a = \left(\sum_{j=0}^{L-1} A_j \cdot r^{1+((N-1-j)\bmod L)}\right) \pmod{2^{130}-5}$

### **Final Tag Addition:** Truncate to 128 bits and add key $s$:

$$\text{tag} = (a \bmod 2^{128} + s) \bmod 2^{128}$$

Just like the original design's `A_PLUS_S` state, the final 128-bit key addition $(a + s) \bmod 2^{128}$ must be applied. 

## Measured 30 MHz configuration

| Quantity | Encrypt | Decrypt |
| --- | ---: | ---: |
| Auto body core stages P | 0 | 0 |
| Actual body latency D = P + 2 | 2 | 2 |
| Accumulators L = D | 2 | 2 |
| Body II | 1 | 1 |
| Prologue MCP constrained cycles / response cycles | 1 / 2 | 1 / 2 |
| Epilogue MCP constrained cycles / response cycles | 2 / 3 | 2 / 3 |

MCP response cycles include their wrapper's handshake cycle; controller phases
add additional packet-level boundaries. In the QoR run, measured per-packet
setup is 3 cycles, drain 3, finalization 4, and tag output normally 1. The
1420-byte encrypt phase has one additional tag-stall cycle per packet. Input
gaps are included in body phase time, and tag stalls in tag-output time.

The external-port shared hardware passes synthesis timing at 30.05 MHz and
uses 42,617 LUTs, 12,934 FFs, 512 DSP48s (of 740), and 11 BRAM tiles. Its shared
ChaCha pipeline is the limiting MAIN; encrypt/decrypt MAINs report 33.519 MHz.
The perf top separately passes at 30.069 MHz; constant-key folding reduces its
area to 33,778 LUTs and 448 DSPs. Neither result is routed timing/fit sign-off.

The exact sweep measures 16, 64, 256, 1024, 1420 and 1920 bytes, four packets
per size per direction, all taps (48 packets total). At 1920 bytes, sustained
encrypt/decrypt rates are 3.276/2.916 Gb/s at 30 MHz versus the recorded
legacy 1.620/1.181 Gb/s at 80 MHz (2.02×/2.47×). At 1420 bytes they are
3.175/2.518 Gb/s. Small packets are slower at the new actual clock despite
lower cycle counts. Arithmetic, compiler revision and shared ChaCha depth also
differ; the comparison is not an isolated MAC-only A/B.

### Starting-guess validation (2026-10-02)

A fresh external-port shared build using the clock-profile hints converged to
the same configuration in the table above: each body core P=0, D=L=2, and
prologue/epilogue constrained counts 1/2. Shared ChaCha retained four core
registers. The final 30.05/33.519/33.519 MHz synthesis results and DUT area
matched the unseeded hardware exactly. All four MCP arithmetic audits passed;
prologue setup/hold counts were 1/0 and epilogue counts 2/1 in both directions.
The final 246 HDL input hashes and clock-constraint hash matched the retained
passing synthesis manifest, including after restoration from the failed trim.

There were two whole-design synthesis runs rather than three. The sweep
passed at four ChaCha core registers, failed its attempted trim to three,
and restored the passing implementation. Every consumed pipeline/MCP latency
matched the built result, so no second pin-and-confirm pass was needed.
Aggregate whole-design synthesis elapsed time was 2,069.3 seconds, compared
with 5,586.7 seconds for the reference; machine-load differences also affect
the observed runtime. The shared fixed-vector native combinational preflight
passed in 348 cycles. Packet throughput measurements above remain the original
unseeded QoR record; this run validated hardware/build convergence.

The generated output directory is
`generated-files/verilog-shared-poly1305-pipelined-30mhz-seeded-20261002-1939Z`.
This validation used Vivado 2019.2 and PipelineC `1c32492-dirty`, including
the stream-wrapper latency-option forwarding fix.
Its retained report is `chacha20poly1305_encrypt_decrypt_shared/`
`vivado_68754b09_bb94084203cc6c2b.log`, with input signature
`bb94084203cc6c2bc8ffdcab8dd4b1b9b87ed9c076549900d2f4fac70816e795`.
Build profile values remain hints. Since then 60 MHz has its own entry;
clocks without one (40/50/70/80 MHz) reuse the 30 MHz profile until
characterized.

## Area/latency alternatives, not implemented

The dedicated parallel epilogue is intentionally the implemented choice:
all L lane products and a balanced modular sum reside in one MCP. More body
stages mean more lanes, more prologue powers and more epilogue multipliers.
Higher-frequency experiments exceeded the device budget. Do not infer
multiplier DSP count from lane count alone or from an assumed optimized limb
decomposition; this implementation uses native full-width 130-bit products.
The retained Vivado reports are the authoritative resource evidence.

Reusing the body for epilogue products, or adding one time-multiplexed epilogue
multiplier, could save area at the expense of finalization latency and more
control. Both would require the same rotated weights for incomplete lane
rotations. Neither automatically allows the next packet to overlap: that
would require additional key/accumulator contexts, which this controller
does not implement.

The final 128-bit addition of s is included in the whole epilogue MCP. It is
not assumed to cost zero constrained cycles; the auto characterization measures
the whole function. Current source seeds the known-good starting counts from
`src/wireguard_env.py`; these are setup counts, not the MCP's count+1 stream
response cycles. This is a build-time optimization, not part of the unseeded
design that produced the recorded results. The fresh shared 30 MHz build
above confirmed timing and convergence with these hints.


## Standalone testbenches

Run from `3.build/pypeline_build`, using `PYPELINEC` or `pypelinec` on PATH.
The single source `src/poly1305_pipelined_syn_tb.py` selects its cases at
elaboration through these design parameters (`-D NAME=VALUE`; `--list_params`
prints them); no special runner is needed:

| Parameter | Choices / default | Coverage |
| --- | --- | --- |
| POLY1305_TB_MODE | mac (default), body, arithmetic, components, sharing | Reference tags; body latency/bubbles; integer-oracle arithmetic; power graph/rotation; independent shared MCP arbitration and response ownership. |
| POLY1305_TB_DIRECTION | encrypt (default), decrypt | Select the direction's stable body callable identity. |
| POLY1305_TB_BODY_DEPTH | unset (automatic), or 0,1,3,6 | Testbench-only fixed stages, giving L=2,3,5,8; not valid in arithmetic or sharing mode. |

MAC cases cross each length 1..2L+1 and 4L+1 with zero/unit/maximal/random
keys, then repeat a key and change s. They check input gaps, continuous II=1,
same-cycle forwarding, final-result drain, busy key rejection and stable tags
during stalls of up to 40 cycles. Arithmetic cases include p/2p/2^130 boundaries,
full-width operands and limb carries; components use arbitrary full-width
canonical accumulators/powers at every final-lane position.

For the ordinary native checks (automatic stages disabled, boundary registers
retained):

```sh
set -e
for mode in arithmetic body components mac sharing; do
  "${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
    --sim --comb --run all -D TARGET_MHZ=30 \
    -D POLY1305_TB_MODE="$mode" -D POLY1305_TB_DIRECTION=encrypt \
    --out_dir "generated-files/poly1305-$mode-encrypt-comb-native"
done
```

For automatically sized MAC RTL at the selected 30 MHz goal:

```sh
"${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
  --sim --cocotb --ghdl --run all -j 1 --stop_on_over_capacity \
  -D TARGET_MHZ=30 -D POLY1305_TB_MODE=mac -D POLY1305_TB_DIRECTION=encrypt \
  --out_dir generated-files/poly1305-mac-encrypt-pipe-30mhz
```

Add `--cocotb --ghdl` to native commands for RTL checks and use separate
`-ghdl` output directories. Explicit fixed stages can still require isolated
Vivado characterization to place slices, even with `--comb`; native stress
does not. Use `-j 1` on low-RAM systems. Fixed-depth configurations are functional
stress tests, not substitutes for automatic production timing validation.

To exercise all native lane shapes without touching compiler caches:

```sh
set -e
for direction in encrypt decrypt; do
  for depth in 0 1 3 6; do
    for mode in body components mac; do
      "${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
        --sim --comb --run all -D TARGET_MHZ=30 -D POLY1305_TB_MODE="$mode" \
        -D POLY1305_TB_DIRECTION="$direction" -D POLY1305_TB_BODY_DEPTH="$depth" \
        --out_dir "generated-files/poly1305-$mode-$direction-depth$depth-native"
    done
  done
done
```

The shared production build's emitted MCP arithmetic can be audited without
another synthesis:

```sh
./measure.py --audit-mcps generated-files/verilog-shared-poly1305-pipelined-share-chacha20-poly1305-30mhz
```

This checks exactly one physical MCP per shared phase and rejects registered
arithmetic descendants. ChaCha-only builds instead require each direction's
private prologue and epilogue (four MCPs). Wrapper and body registers are
allowed. It is not timing/constraint sign-off.
Fresh non-combinational measurements run this audit as part of acceptance.

## Legacy arithmetic corrections

The original C limb helpers had three interlocking issues: truncating each
64×64 product to its low half, an incorrect low-130-bit mask within limb 2,
and discarding upper limbs rather than folding them by the modulus identity.
The previously corrected Python implementation uses full 128-bit limb-pair
products with a carry chain, mask 0x3 in limb 2, and three folds
`x = q*2^130 + rem -> rem + 5*q` for arbitrary 320-bit inputs.

This change extracts those helpers into `poly1305_math.py`, shared by both
architectures, and fixes another reducer error: the final subtraction must
also subtract the top limb 3 of p=2^130-5. Without it, reducing p produced
3*2^128 rather than zero. The legacy FSM is unchanged; its historical MCP
starting guess of five is now selected from the clock-profile table.

The complete-block MAC and full AEAD testbenches use independent integer or
cryptography references, including the RFC 8439 known-answer vector.
The original C designs remain unfixed; their tags and padded-length framing
are not this port's expected outputs.

# References:

[1] Improve chacha poly per-packet overhead [Issue39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)

[2] [Illustration](https://share.gemini.google/dCzLp7lhYqaR) of the algorithm
