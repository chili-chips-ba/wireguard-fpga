# Pipelined Poly1305: design and measured checkpoints

Combined builds share ChaCha20 and the Poly1305 prologue/epilogue MCPs by
default, targeting **85 MHz** with `hybrid_square` arithmetic. Other pipelined
sharing sets and standalone directions retain 30 MHz defaults. The current source combines packet overlap with automatically sized
plaintext verification storage. All 48 concurrent reference checks at
16, 64, 256, 1024, 1420 and 1920 bytes, body II=1, buffer conservation and
final synthesis timing/fit passed. At 1920 bytes and a common 85 MHz,
payload goodput is **10.529 Gb/s encrypt / 10.529 Gb/s decrypt**, gaining
**30.1% encrypt / 29.6% decrypt** over the pre-overlap controller.
The shared performance-testbench top uses 108,078 LUTs,
43,955 FFs, 711 DSPs and 18.5 BRAM tiles,
with 85.543 MHz limiting synthesis fmax under an 80 MHz constraint.
Routed timing and external-port area remain untested. See the
[full measurement](../../measurements/shared-verify-fifo-qor-20261015/README.md),
[README](../../README.md) (which now holds the 256-bit 80 MHz record)
and [storage derivation](#plaintext-verification-storage). The accepted
packet-overlap and pre-overlap checkpoints below remain historical records.

## Measured packet overlap, 2026-10-15

Payload goodput at a common 85 MHz, calculated from measured packet periods.
The original target was 80 MHz; its reported effective fmax is 85.543 MHz.

| Bytes | Direction | Before Gb/s | After Gb/s | Gain | Packet period (cycles) |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1420 | encrypt | 7.390 | 10.024 | 35.6% | 96.3 |
| 1420 | decrypt | 7.409 | 10.024 | 35.3% | 96.3 |
| 1920 | encrypt | 8.093 | 9.130 | 12.8% | 143.0 |
| 1920 | decrypt | 8.126 | 9.695 | 19.3% | 134.7 |

At 1920 bytes each packet has 123 authentication blocks (120 payload,
two padded AAD blocks and one length block). The remaining packet-period
cost beyond those transfers is:

- encrypt: 20.0 cycles beyond body transfers; body overlaps setup/drain/finalization for 35/23/26 clocks over the four-packet burst; 0 tag-output stall clocks.
- decrypt: 11.7 cycles beyond body transfers; body overlaps setup/drain/finalization for 50/20/20 clocks over the four-packet burst; 0 tag-output stall clocks.

The previous controller spent at least 37 sequential non-body cycles per
packet. Independent stage costs now overlap and must not be summed.
The payload-edge diagnoses below describe remaining observed backpressure;
the full state, FIFO and shared-service counters are in the block report:

- encrypt: `append_auth_tag`, dominant state `CIPHERTEXT`.
- decrypt: `prep_auth_data`, dominant state `CIPHERTEXT`.

Four packets provide three completion intervals; these figures describe
that concurrent workload rather than a long contention-window benchmark.

The 20% gain target at 1920 bytes was missed. The existing decrypt plaintext
verification FIFO backpressures the shared ChaCha path; encrypt's MAC
then has 50 body-input gap clocks across the four-packet burst. Neither
tag acceptance nor the new encrypt fork FIFOs block admissions at this
size. See the [stall investigation](../../measurements/shared-poly1305-overlap-resume-20261015/investigation.md).

Synthesis used an 80 MHz constraint and reported 85.543 MHz effective fmax.
The 85 MHz rates above scale the measured cycle counts; no additional
85 MHz synthesis was performed. Area is the shared performance-testbench
top: 108,066 LUTs, 43,952 FFs, 711 DSPs and 18.5 BRAM tiles. The replay
used the latest local compiler snapshot and the synthesis-confirmed
19/8/8 and 12/8 latency maps. Historical checkpoint notes below describe
the earlier intermediate state. Full evidence and reproduction are in
[the measurement record](../../measurements/shared-poly1305-overlap-resume-20261015/README.md).

## Overlapped packet stages

### Overlap checkpoint, 2026-10-14

This checkpoint implements the independent stages, two accumulator banks per
direction, context/lane ownership delay, one completion snapshot, one held tag,
and latency-derived fork buffering described below. The existing arithmetic
engines and external packet ordering are retained. Measurement now records
independent stage activity, body/drain overlap and stage-register occupancy.
Stage costs overlap and must not be summed as a sequential packet budget;
historical single-context reports remain supported.

The three requested basic native checks exited zero with retained compiler
revision `75a27b9fab2628d925e91b4b1bacab667917c976`, `hybrid_square` arithmetic
and seed 8439:

| Command | Packet checks | Simulation cycles | Result |
| --- | ---: | ---: | --- |
| `./build.py --enc --sim --comb --native --target-mhz 85` | 12 | 295 | Pass |
| `./build.py --dec --sim --comb --native --target-mhz 85` | 13 | 417 | Pass |
| `./build.py --shared --sim --comb --native --target-mhz 85` | 25 | 426 | Pass |

These 50 reference checks cover packet ordering, partial-word framing,
repeated context reuse and decrypt's tampered-tag case. A subsequent
compiler-compatibility edit names the retiring context/lane in local scalars
before indexing the banks, preserving the intended writeback behavior.
The final source and its longer ownership delay still require the pending
pipelined native measurement. Combinational simulation does not establish
correctness at the synthesis-resolved pipeline/MCP latencies, body II=1,
device fit, achievable clock rate or the throughput gain.

Local basic-bench logs and their result summary are under
`generated-files/poly1305-overlap-validation/` (`*-comb-native.log` and
`basic-native-results.json`). These are ignored build outputs. The ongoing
shared measurement writes
`measurements/shared-85mhz-poly1305-overlap/pypelinec.log`; no completed
throughput result is available at this checkpoint.

The active measurement uses Vivado 2019.2 and a private copy of the retained
compiler at `generated-files/compiler-75a27b9f-overlap/src/pypelinec`.
Its only source overlay is in `src/SYN.py`, at the return from
`GET_VHDL_FILES_TCL_TEXT_AND_TOP`:

```diff
-    return files_txt, top_entity_name
+    return files_txt, VHDL.EMITTED_NAME(top_entity_name, parser_state)
```

This makes the vendor synthesis top match the identifier emitted in the VHDL
wrapper while preserving the generated filename. Without it, characterization
of a long bank helper failed with a missing-top error. The snapshot's
`snapshot-overlay.json` records both source hashes. Neither the original
compiler used by the basic benches nor the live sibling compiler was edited.
Only specifically rejected vendor logs were quarantined; valid synthesis
caches were preserved.

An intervening run with a snapshot of the newer compiler did not restore the
accepted profile, selected body depth 9 (11 lanes), and stopped on a
783-DSP request against 740 available before packet simulation. It supplies
no accepted timing or throughput result. The active retained-compiler retry
has restored starting values **ChaCha core 19, body cores 8/8, shared MCP
counts 12/8**. Restored values seed the sweep; synthesis must confirm the
changed design.

The remaining design check is one shared pipelined measurement, from the
build directory with that compiler selected:

```sh
PYPELINEC="$PWD/generated-files/compiler-75a27b9f-overlap/src/pypelinec" \
./measure.py --shared --poly1305 pipelined \
  --poly1305-mult hybrid_square --target-mhz 85 \
  --sizes 1420,1920 --packets 4 --peak-bytes 0 \
  --dirs both --taps all --seed 8439 \
  --no-per-module-area -j 1 --reuse-syn --save-evidence \
  --out-dir generated-files/qor-shared-85mhz-poly1305-overlap \
  --label shared-85mhz-poly1305-overlap
```

Do not start a duplicate while the current run is active. Acceptance requires
all 16 packet results, ownership/outstanding assertions, drained and conserved
buffers, body II=1, synthesis timing of at least 85 MHz and device fit.
Compare both directions at 1420 bytes against **7.390/7.409 Gb/s** and at
1920 bytes against **8.093/8.126 Gb/s**; investigate remaining packet-boundary
stalls if the 1920-byte gain is below the **20% target**. Report final area
as the **shared performance-testbench top**. Archive final source/compiler
identities, resolved latencies, sizing ledger and synthesis/packet evidence,
then update this document and the build README with measured gains and the
remaining bottleneck. Until then, the previous accepted results remain the
highest confirmed throughput.

Legacy changes, additional clock sweeps, standalone synthesis, generated-HDL
simulation and final Verilog export are outside this checkpoint's scope.

### Stage ownership and buffering

The pipelined MAC composes three independent hardware submodules:

```text
key -> prologue MCP -> prepared descriptor -> two-bank body
                                            | one arithmetic pipeline
                                            | context/lane delay = body latency
                                            v
                     completion snapshot -> epilogue MCP -> held tag
```

Each direction owns two accumulator/power banks. Dispatch switches banks at
the final authentication block, while the previous bank drains. Every body
launch carries its bank and lane through a clocked metadata line, including
bubbles. Writeback checks ownership and outstanding counts; forwarding matches
both identities. A bank is released only after all results have committed and
its full epilogue input has been copied into the completion register.
Epilogue therefore reads an immutable snapshot even after the bank is reused.

Prepared descriptors, completion snapshots and tags each have one holding
slot. Prologue and epilogue reserve their response storage before requesting
the shared single-flight MCP, then consume its response promptly. A blocked
tag consumer stops subsequent local epilogues through bounded backpressure.
There is no additional tag FIFO and no packet-data FIFO inside Poly1305.
The physical arithmetic remains one body per direction and one shared MCP
per setup/finalization phase.

Encrypt buffers both ciphertext fork copies: authentication before framing,
and ciphertext before tag append. This allows the next key to reach prologue
before the current authentication body ends, and prevents tag append's packet
tail wait from stopping the next body. Decrypt retains its authentication
fork FIFO and its existing whole-packet plaintext verification storage.

### Plaintext verification storage

Pipelined decrypt sizes `wait_to_verify` separately from the authentication
fork. This FIFO holds plaintext until the tag verdict; blocking it also
blocks the ordered shared ChaCha result stream and can starve encrypt's MAC.
`aead_types.decrypt_verify_fifo_sizing` adds the following to the resolved
decrypt authentication admission/service bound:

- `ceil(AEAD_MAX_PLAINTEXT_BYTES / AXIS128_BEAT_BYTES)` for the held packet;
- `R + 1` beats for ChaCha's narrowing converter and output register;
- the tag comparator's four state handoffs and one plaintext-release handoff.

The inherited bound covers ChaCha's selected in-flight credits, widening
storage, fork lead, FIFO/framing startup, shared prologue service and body
drain/commit/shared epilogue service. It conservatively adds phases that can
overlap. It does not use the benchmark's packet size, measured occupancy or
requested clock as a proxy for selected latency. External sink stalls still
propagate once the finite storage fills.

At the accepted 19-cycle ChaCha / 8-cycle body / 12- and 8-cycle MCP depths,
the authentication bound is 170 beats. The plaintext bound is
`170 + 127 + 5 + 4 + 1 = 307`, rounded to **512 memory beats plus one FWFT
output beat**. The supported payload envelope remains **2032 bytes**;
the tag is stripped before this FIFO and consumes no plaintext storage.
Legacy retains its original 128 memory beats. The decrypt factory accepts
`verify_fifo_depth` for explicit sizing experiments; automatic production
sizing is the default. The probed FIFO reports occupancy, transfers and
conservation under `decrypt/verify_fifo`.

The accepted [packet-overlap measurement](../../measurements/shared-poly1305-overlap-resume-20261015/README.md)
remains the comparison checkpoint. The changed storage passed the full six-size
native run, independent full-capacity stress and new synthesis timing/fit
checks in the [verification FIFO record](../../measurements/shared-verify-fifo-qor-20261015/README.md).

### Latency-derived overlap FIFO budgets

`aead_types.overlap_fifo_sizing` uses the selected, resolved wrapper depths,
credits and MAC handoff metadata. At most one input beat arrives per clock;
both shared MCPs allow one preceding peer transaction. External output stalls
use backpressure rather than an unbounded time allowance.

Let `R = CHACHA20_BLOCK_SIZE / AXIS128_BEAT_BYTES`,
`C = ChaCha max_in_flight`, `A = ceil(AAD_MAX_LEN / AXIS128_BEAT_BYTES)`,
`P/E = prologue/epilogue MCP constraints`, `D = body_core_latency + 2`,
and `S = 1` for shared MCPs, otherwise zero. Let `Hp` and `He` count the
explicit prologue and epilogue register handoffs, `B` the final writeback
commit boundary, and `T` the maximum packed ciphertext-tail/tag beats.

```text
setup      = (1+S)*(P+1) + Hp
completion = D + B + (1+S)*(E+1) + He + T
framing    = A + IDLE_transition + lengths_block
transport  = FIFO_startup + fork_copy_lead

encrypt_auth_required   = setup + framing + transport + (R+1)
encrypt_append_required = setup + framing + transport
                          + actual_auth_FIFO_capacity + completion
decrypt_auth_required   = setup + framing + transport
                          + R*C + (R+1) + completion

memory_depth   = ceil_pow2(max(2, required))
total_capacity = memory_depth + FWFT_output_register
```

The register handoffs are architectural boundaries declared by the MAC,
not guessed arithmetic depths. Framing has one registered IDLE transition
and one lengths beat; FIFO startup spans memory read and output-register
loading; the fork can lead by one copy. Converter storage is `R+1`.
`T` follows the beat and tag widths. Every input and summand is retained
under each buffer's `sizing` metadata and checked by measurement acceptance.
Depths are regenerated during normal pin-and-confirm re-elaboration.

At the restored starting profile (ChaCha core 19 with 24 block credits,
body response 10, shared prologue/epilogue counts 12/8), setup and completion
budgets are 29 and 33 cycles. Encrypt authentication requires 41 beats,
encrypt append 134 and decrypt authentication 170, allocating 64/256/256
memory beats plus one output register each. The append calculation includes
the authentication FIFO's actual 65-beat capacity. These are elaborated
budgets, not measured peak occupancies or final QoR results.

The older single-context credit-only derivation below remains a historical
record; overlapped designs use this versioned budget.

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
In that pre-overlap profile, the decrypt authentication FIFO used **256 memory
beats plus one output beat** for a computed 135-beat requirement. The automatic
90 MHz configuration selected thirteen lanes, requesting 918 DSPs and exceeding
device capacity.

Focused generated-HDL multiplier, square and prologue checks passed. Native
`*` simulation computes Python products without exercising the registered
decomposition, so HDL verification is tracked separately. All six packet sizes
remain in the pre-overlap QoR evidence, whose highest sustained rates occur
at 1920 bytes. In the two-size overlap measurement, 1420 bytes is fastest.

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

As of October 10, 2026, passing native simulation is accepted for this work.
The additional shared pipelined generated-HDL checks were stopped before
completion; they are not a remaining development acceptance requirement.
Development relies on native simulation as the hardware model. Run one
generated-HDL/GHDL check immediately before an explicitly requested final
Verilog export. Routine WireGuard development does not export final Verilog
or repeat compiler-rendering checks; compiler regressions belong in PipelineC's
suite. Routed timing is untested. Two older
synthetic native latency-cache tests reproduce failures on untouched sources
with this compiler (expecting three lanes, receiving two); they do not establish
a production arithmetic regression.

From the build directory, use a PipelineC checkout providing the API above.
These public commands select the measured profiles without investigation scripts:

```sh
# Development native simulation at the highest measured throughput profile.
./build.py --shared --sim --syn_tb --native --target-mhz 85 --poly1305-mult hybrid_square -j 1 --continue
# Lowest-DSP checkpoint and original arithmetic baseline.
./build.py --shared --sim --syn_tb --native --target-mhz 60 --poly1305-mult hybrid_square -j 1
./build.py --shared --sim --syn_tb --native --target-mhz 60 --poly1305-mult inferred -j 1
# Only immediately before an explicitly requested final Verilog export.
./build.py --shared --sim --syn_tb --target-mhz 85 --poly1305-mult hybrid_square -j 1 --continue
```

For the full QoR workload, use the command in the
[README measurement section](../../README.md#measuring-qor-fmax-area-throughput-latency).
Use `--area-from-dir` only with a separately completed external-port hardware
build of the same profile. `--continue` retains one output directory;
`--syn-cache` reuses matching HDL/XDC/device/tool inputs across directories.
Separate source copies must use the same absolute synthesis-store location.

### Latency-memory verification

Automatic memory reuse passed the minimal 85 MHz QoR check on October 13,
using Vivado 2019.2, `xc7a200tffg1156-2`, and the current PipelineC checkout
(base revision `75a27b9f`). The compiler restored ChaCha depth 19, body depths
8/8 and shared MCP counts 12/8, replayed all five MAIN implementations, and
confirmed them with one cached whole-design synthesis. There were no new
synthesis runs.

The check sends one 64-byte packet per direction concurrently, with seed 8439,
all taps and no peak phase. It exits zero, measuring 85.543 MHz, 93,561 perf-top
LUTs, 30,161 FFs, 711 DSPs and 13.5 BRAM tiles. The six-size README reference
has 93,566 LUTs, 30,168 FFs and the same DSP/BRAM use. Packet checks, timing and
device fit pass; native simulation finishes after 96 cycles. Both directions
have 10 accumulator lanes, all consumed latencies match the built pipelines,
and the compiler records 13 verified memory pieces.

The local record is retained in
`generated-files/latency-hints-85mhz-qor-20261013/memory-replay/`, including
`results.json`, `run-status.json`, `pypelinec.log`, `perf_raw.json`, CSVs and
summaries. The preceding measurement is retained in the sibling `measurement/`
directory. Generated profiles and memory remain at the build directory's root
and in the shared synthesis store. These local outputs are ignored by git.
The existing six-size README measurement remains the full throughput reference.

For a minimal check of automatic memory reuse, run from the build directory
using a current PipelineC checkout:

```sh
./measure.py --shared --poly1305 pipelined --poly1305-mult hybrid_square \
  --target-mhz 85 --sizes 64 --packets 1 --peak-bytes 0 \
  --dirs both --taps all --seed 8439 --no-per-module-area -j 1 \
  --reuse-syn \
  --label "$(pwd)/generated-files/latency-hints-85mhz-qor-20261013/memory-replay" \
  --out-dir generated-files/latency-hints-85mhz-qor-20261013
```

Use a fresh build directory and omit `--reuse-syn` for a cold check. An absolute
label puts the measurement outputs under `generated-files/` as well. The
memory-replay record contains the follow-up build's status and results.

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

The arithmetic factory `make_shared_compute(capacity)` returns a named bundle:
`.prologue` and `.epilogue` are callable kernels, `.powers_t` is the prologue
result payload type, and `.epilogue_in_t` is the epilogue request payload type.
The module's production bundle is `compute`. For example,
`compute.prologue.return_t` is `compute.powers_t`, while
`compute.epilogue.return_t` is the 128-bit tag type. Calls through these named
attributes are valid inside hardware functions too.

`make_shared_adapters(direction, lanes, local_powers_t, local_epilogue_in_t)`
returns a bundle with `.prologue` and `.epilogue` adapters. Each callable
exposes `.return_t` for the complete result: input feedback in `stream_in_if`
and output feedforward in `stream_out_if`. The MAC declares
`Feedback[prologue_mcp.return_t]` / `Feedback[epilogue_mcp.return_t]` for both
private and shared selections. `.in_intrf` / `.out_intrf` describe stream
interfaces; their `.stream_t.typeof("data")` gives the payload type.
`.in_fwd_t` and `.out_fb_t` name the caller-supplied halves. `.mcp` refers to the corresponding physical shared MCP tag, preserving
latency sizing through `.mcp.latency`.

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

### Inferred higher-clock limits

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

### Historical single-context authentication FIFO sizing

`aead_types.decrypt_auth_fifo_sizing` reads the **selected** private/shared
ChaCha stream wrapper's `.max_in_flight` and `.auto_pipeline.latency`, plus
the selected MAC's `.prologue_mcp.mcp.latency`. PipelineC's normal
pin-and-confirm re-elaboration regenerates the depth and native metadata from
the final latencies.
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
30 MHz shared depths (`C=9`, `P=1`) give 53 beats, rounded to 64 memory beats.
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
The [record's README](../../measurements/shared-verify-fifo-qor-20261015/README.md)
documents the selected toolchain, depths and automatic FIFO metadata.

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
packet. Two private accumulator banks allow dispatch for the next packet while
the previous bank drains; the independent stages and their compact holding
registers are described in [overlapped packet stages](#overlapped-packet-stages).

Let P be the discovered body `AUTO_PIPELINE.latency`. Including its explicit
input and output registers, D = P + 2; use L = D accumulators with same-cycle
writeback forwarding. Builds use named AUTO tags and PipelineC's built-in
latency memory. Tool-generated profiles and memory live in each build output
directory; matching verified pieces also
live in `generated-files/syn_cache/latency/v2/`. They survive clearing the build
directory and can seed other directories at the same or a higher goal. Changed
hardware pieces are ignored before synthesis. A build with no matching memory
runs the normal sweep. L follows the actual discovered body latency.

The encrypt/decrypt body wrappers remain so `poly1305_body` is an interior
mini-sweep target. Direct imported-function tagging has a known PipelineC
attribution issue, and region roots are not mini-swept; see PipelineC's
`docs/issues_inventory.md`, issue 37. Stable tag names still provide independent
latency groups and readable profiles for the two directions.

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

Historical single-context controller schematic: one FSM orchestrates the
prologue MCP, body pipeline and epilogue MCP. The current controller instead
uses the independent [overlapped stages](#overlapped-packet-stages); the
arithmetic convention and per-packet algorithm illustrated below are retained.

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
requires additional key/accumulator contexts. The current controller supplies
two body banks without changing the dedicated epilogue arithmetic.

The final 128-bit addition of s is included in the whole epilogue MCP. It is
not assumed to cost zero constrained cycles; the auto characterization measures
the whole function. PipelineC remembers verified counts in its output/store
latency memory; these are setup counts, not the MCP's count+1 stream response
cycles. This reuse is a build-time optimization.


## Standalone testbenches

Run from `3.build/pypeline_build`, using `PYPELINEC` or `pypelinec` on PATH.
The single source `src/poly1305_pipelined_syn_tb.py` selects its cases at
elaboration through these design parameters (`-D NAME=VALUE`; `--list_params`
prints them); no special runner is needed:

| Parameter | Choices / default | Coverage |
| --- | --- | --- |
| POLY1305_TB_MODE | mac (default), body, arithmetic, components, sharing | Reference tags; body latency/bubbles; integer-oracle arithmetic; power graph/rotation; independent shared MCP arbitration and response ownership. |
| POLY1305_TB_DIRECTION | encrypt (default), decrypt | Select the direction's named body latency group. |
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
3*2^128 rather than zero. The legacy FSM is unchanged; its automatic MCP uses
the compiler's verified latency memory and normal sweep.

The complete-block MAC and full AEAD testbenches use independent integer or
cryptography references, including the RFC 8439 known-answer vector.
The original C designs remain unfixed; their tags and padded-length framing
are not this port's expected outputs.

# References:

[1] Improve chacha poly per-packet overhead [Issue39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)

[2] [Illustration](https://share.gemini.google/dCzLp7lhYqaR) of the algorithm


## Paired-coefficient two-block mode

Select `--data-bitwidth 256` in `build.py` or `measure.py`, or
`-D DATA_BITWIDTH=256` with pypelinec. Selection is static; only the
chosen MAC is instantiated. The default remains `--data-bitwidth 128`, with
one authentication block per clock and its historical directory names.
256-bit directories retain the existing `-blocks2` suffix.
All packet streams and flattened data/keep ports become 256/32 bits; the
explicit `axis128_*` types remain 128 bits. There is one clock domain.

For p = 2^130 - 5 and complete padded authentication blocks
c_i = LE(block_i) + 2^128, the coefficient pipeline computes

```
q = r*r mod p
d_t = (c_(2t)*r + c_(2t+1)) mod p
A_(t mod L) = (A_(t mod L)*q^L + d_t) mod p
```

The coefficient pipeline and the accumulator pipeline each accept one request
per cycle. L is **only** the accumulator pipeline's latency, including its two
boundary registers. Coefficient preprocessing happens before accumulator
reads; ownership is delayed with the coefficients and same-cycle retirement
forwarding is preserved. Both pipelines continue advancing through bubbles.
Outstanding-pair accounting spans both pipelines; snapshots and context reuse
wait for the final accumulator writeback. Two context banks permit the next
packet to start while the previous one drains or finalizes.

The prologue calculates q^1 through q^L, using specialized squares when
selected. The finalization descriptor also holds r, s, and an optional unmatched
last block. For M full pairs:

```
S = sum_j A_j * q^((M-1-j) mod L) mod p
H = r*S mod p
if unmatched block c_tail:
    H = (H+c_tail)*r mod p
tag = (H+s) mod 2^128
```

q^0 is explicitly one, including r=0. A singleton final beat has 16 valid
bytes; it is captured as a tail without a fictitious second block or an
accumulator-lane advance. A complete pair has 32 valid bytes. All operands
remain canonical 130-bit residues. Powers of q are general residues, so the
feedback multiplier cannot assume the clamped bit pattern of r.

The finalization kernel uses the equivalent odd-tail expression
`H = q*S + r*c_tail mod p`. It selects `q` or `r` before scaling `S` and
computes the tail product independently. This avoids a third serial
multiplication through the lane reduction while retaining the same recurrence
and the existing 64-cycle FSM cap.

The wide authentication formatter queues four 16-byte blocks and packs across
AAD/ciphertext/length boundaries. AAD and ciphertext are padded independently
to multiples of 16 bytes. Only the lengths block ends authentication. Tag
append and strip preserve contiguous ciphertext||tag byte frames, including
single-beat frames and tags split across beats. The ciphertext/tag consumers
can stall independently. FIFO sizing uses the selected packet width, resolved
coefficient-plus-feedback latency, formatter storage and service handoffs.

Per-MAC metadata distinguishes `body_latency` (feedback latency, equal to accumulator
count), `coefficient_latency`, and `total_body_latency` (their sum). `body_ii`
remains one request per cycle; `blocks_per_cycle` identifies the two-block
request. Performance conservation checks compare authentication blocks,
coefficient launches/retirements, feedback launches/retirements, unmatched
tails and packet tags. The ideal body input-service count is ceil(N/2), where
N = ceil(AAD_bytes/16) + ceil(ciphertext_bytes/16) + 1.

### 40 MHz AUTO_FSM hardware checkpoint

Matched shared builds of both widths, 2026-10-21:
- 40 MHz goal, hybrid_square, FSM setup/finalization at a fixed capacity of 12;
- seed 8439, four concurrent packets per size;
- the same frozen PipelineC compiler (base `701a5c45` plus the AUTO_FSM
  working tree, `AUTO_FSM.py` sha256 `c52412ca…`).

Both pass synthesis timing, device fit, all 48 reference checks, body II=1 and
buffer conservation. 256-bit conservation also holds: per direction,
1248 blocks = 2 × 616 pairs + 16 tails, and the four arithmetic counters agree.

| | 128-bit | 256-bit |
|---|---:|---:|
| fmax (all MAINs pass) | 40.87 MHz | 40.87 MHz |
| LUT / FF | 45,116 / 30,668 | 58,992 / 36,306 |
| DSP / BRAM tiles | 138 / 18.5 | 210 / 26.5 |
| Lanes; body response | 3; 3 cycles | 3; 3+3 cycles |
| Prologue / epilogue FSM | 30 / 39 cycles | 35 / 45 cycles |
| 1920 B goodput | 15.48 B/cycle | 20.79 B/cycle (1.34×) |
| 1420 B goodput enc / dec | 15.11 / 14.84 | 15.44 / 15.44 |
| 16–256 B packet period | 80 cycles | 92 cycles (0.87×) |

Both FSM services are shared and accept one request at a time, so each
direction gets a service every 2 × (latency + 1) cycles. The epilogue sets that
floor: 2 × 40 = 80 cycles at 128 bits and 2 × 46 = 92 at 256 bits. At 1920
bytes, 128 bits are body-limited (124 cycles for 123 blocks). 256 bits need only
62 pair cycles but hold the 92-cycle epilogue period, so the gain is 1.34×, not 2×.
Short packets are slower at 256 bits because the epilogue is longer.

Records:
- [128-bit](../../measurements/shared-autofsm-c52412ca-128-40mhz-20261020-r4/README.md)
- [256-bit](../../measurements/shared-autofsm-c52412ca-256-40mhz-20261020-r4/README.md)

Synthesis timing only; routed timing was not run. A higher 256-bit gain needs
shorter or unshared setup/finalization.

### 80 MHz: inferred feedback body, private AUTO_FSM services

2026-10-25, frozen PipelineC `39aef859` (`…-frozen-d8de5ac222f7`), 80 MHz goal, seed 8439,
four concurrent packets per size.
[Record](../../measurements/private-autofsm-39aef859-256-inferred_body-80mhz-20261025-r3/);
the investigation (kernel probes, body-depth probes, build-time analysis) is in
`generated-files/paired-80mhz-investigation-20261021/README.md`.

**Two changes reach 80 MHz.**
- **`--poly1305-mult inferred_body`.**
  - The feedback product `A*stride + d` is a pinned wide inferred multiply, so the feedback
    body needs 2–3 stages at 80 MHz instead of 10. Lanes (feedback latency + 2) drop from 12
    to 5 for encrypt and 4 for decrypt.
  - Everything else stays `hybrid_square`: the coefficient body, which does not set lanes,
    and the AUTO_FSM kernels.
- **`--share-chacha20`.**
  - Each direction has its own prologue and epilogue FSM.
  - A single shared single-flight service costs 2 × (latency + 1) cycles per packet pair.
    The 256-bit body needs ~63 cycles per 1920-byte packet, so shared services would have
    to fit in 28 cycles, below the ~30–40-state prologue floor.

Measured at 1920 bytes and the 80 MHz target, against the 128-bit 80 MHz record
(`shared-poly1305-fsm64-latest-qor-20261017`, earlier compiler, not a matched build):

| | 128-bit record | 256-bit |
|---|---:|---:|
| fmax (all MAINs pass) | 81.04 MHz | 81.73 MHz, WNS +0.265 ns |
| LUT / FF | 104,668 / 93,372 | 50,768 / 39,589 |
| DSP / BRAM tiles | 413 / 18.5 | 160 / 23.5 |
| Lanes enc / dec | 10 / 10 | 5 / 4 |
| Prologue / epilogue FSM enc | 64 / 41 cycles | 64 / 45 cycles |
| Prologue / epilogue FSM dec | shared | 63 / 35 cycles |
| Encrypt goodput | 9.125 Gb/s | 18.071 Gb/s (1.98×) |
| Decrypt goodput | 9.125 Gb/s | 13.166 Gb/s (1.44×) |
| 16 B period enc / dec | 109.3 / 132.0 cycles | 68.0 / 90.7 cycles |

All 48 reference checks pass, and conservation holds: per direction 492 blocks =
2 × 244 pairs + 4 tails.
- **Encrypt** runs at its prologue service rate (68 cycles).
- **Decrypt's setup is less hidden.** Its Poly1305 consumes ciphertext in parallel with
  ChaCha20, so the next packet's key arrives at the end of the current body, leaving ~30 of
  its 65 setup cycles exposed (91–98-cycle periods).
- **Prologue cap 44** (`--poly1305-prologue-cap 44`,
  [record](../../measurements/private-autofsm-39aef859-256-inferred_body-procap44-80mhz-20261026/)).
  The prologue floors are 40 states at 5 lanes (encrypt) and 30 at 4 (decrypt).
  - The prologues schedule at 42/43 states, and timing is met: WNS +0.203 ns, 81.32 MHz.
  - Area: 50,574 LUT, 166 DSP.
  - Gb/s at 1920 bytes, encrypt / decrypt: 19.20 / 14.34 (2.10× / 1.57× the 128-bit record).
  - At 1024 bytes: 13.65 / 9.02.
  - Encrypt is now body-limited at 1920 bytes (64 cycles) and prologue-bound below it
    (48 cycles).
  - Decrypt still waits on its next key, which follows the current packet's keystream
    through the 19-stage ChaCha20 pipeline: 62.7 cycles at 16 bytes, 85.7 at 1920.

Comb-function rewrites measured on standalone L=5 kernels:
- **Epilogue, reducing the summed lane products once:** 34 instead of 50 states, for 24% more
  LUTs.
- **Prologue, partial reduction on its chain:** no improvement; its floor rose from 40 to 44.

Synthesis timing only; routed timing was not run.

### Focused native checks

The dedicated `src/poly1305_paired_tb.py` uses cryptography tags and independent
byte-frame scoreboards. It includes arbitrary non-kept input bytes, every final
32-byte-beat occupancy, AAD lengths 0/1/15/16/17/31/32, maximum payloads, input
gaps, independently stalled tag/ciphertext outputs, changing and repeated keys,
odd tails and lane-wrap boundaries. It asserts continuous pair admission.

```sh
for mode in mac prep tags; do
  "${PYPELINEC:-../../../PipelineC/src/pypelinec}" src/poly1305_paired_tb.py \
    --sim --comb --run all -D DATA_BITWIDTH=256 \
    -D PAIRED_TB_MODE="$mode" --out_dir "generated-files/paired-$mode-comb"
done
```

`PAIRED_TB_DIRECTION=encrypt|decrypt` selects the named arithmetic regions.
`PAIRED_TB_BODY_DEPTH` and `PAIRED_TB_COEFFICIENT_DEPTH` independently select
test-only fixed core depths 0/1/3/6/8/10. Production uses resolved automatic depths;
these fixed configurations establish functional scheduling, not production
80 MHz timing. Add `-D POLY1305_MULT_IMPL=inferred|hybrid|hybrid_square` and
`-D POLY1305_COMPUTE_IMPL=fsm|mcp` to exercise the alternate implementations.
MAC runs check authentication bytes, pair/tail counts, all four arithmetic
launch/retirement counts and tag counts against the generated messages.
They execute the original arithmetic by default. For a separate scheduling
check at larger depths, `-D PAIRED_TB_ARITHMETIC_MODELS=1` explicitly enables
the checked stateless arithmetic models; the result log identifies that mode.
The existing sharing testbench also checks paired setup/finalization, including
nonzero inactive slots, unequal local lane counts, odd tails and held responses:

```sh
"${PYPELINEC:-../../../PipelineC/src/pypelinec}" src/poly1305_pipelined_syn_tb.py \
  --sim --comb --run all -D DATA_BITWIDTH=256 \
  -D POLY1305_TB_MODE=sharing --out_dir generated-files/paired-sharing-comb
```

Native combinational checks establish functionality only. Acceptance also
requires an automatically pipelined shared 80 MHz measurement, synthesis
timing/device fit, resolved II=1 accounting, reference checks and FIFO
conservation. End-to-end rates must be compared with one-block mode using the
same compiler, target, payload seed, packet sizes and packet counts. Retained
measurement records state their actual status; a body capacity is never a
substitute for a measured packet-goodput result.

The temporary shared MCP profile at 80 MHz does not fit xc7a200tffg1156-2:
the performance top uses 232,173 LUTs (172.49%), 59,162 FFs, 740 DSPs and
26.5 BRAM tiles. Its [development QoR record](../../measurements/shared-poly1305-paired-mcp-80mhz-20261019/README.md)
is separate from the [passed native checkpoint](../../measurements/paired-poly1305-native-validation-20261019/README.md).
The synthesis timing summary also misses 80 MHz (−1.013 ns worst setup slack).
The FSM profile replaces those MCPs. Its 40 MHz hardware acceptance and matched
goodput are in [the checkpoint above](#40-mhz-auto_fsm-hardware-checkpoint). An 80 MHz
FSM-profile result and further setup/finalization optimization are still open.


Performance testbenches install stateless native models for ChaCha20 block
arithmetic and canonical Poly1305 operations. Pypeline's `sim_model` API leaves
HDL elaboration unchanged; stream controllers, context ownership, FIFOs,
backpressure and resolved pipeline/FSM delays still execute the design. The
ordinary functional and paired testbenches execute the original arithmetic.
Before performance runs, `python3 test_native_arithmetic_models.py -v` compares
168 boundary/random inputs against those original functions, then checks model
dispatch. Performance JSON records `native_arithmetic` so the simulation method
is explicit. `python3 test_paired_profile.py -v` checks block/pair/tail accounting,
latency separation, stale-profile rejection and cache/CLI compatibility.
`python3 test_paired_arithmetic.py -v` checks 3,768 finalization cases and
20 prologues against integer arithmetic, covering capacities 2/3/5/10/12, every
local lane count and rotation, odd/even tails, zero/unit/maximal/random
clamped keys, nonzero inactive slots and changes to `s`.

For an original-arithmetic performance replay, pass
`-D PERF_ARITHMETIC_MODELS=0` to `build.py --perf` (with the same `PERF_*`
workload definitions). The small simultaneous encrypt/decrypt replay was
checked to have identical complete phase records, every internal tap, reference
checks and total cycle count with and without arithmetic models. The external
`PYPELINE_SIM_SOFT_OPS` policy is also recorded explicitly in performance JSON.
