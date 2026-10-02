# Pipelined Poly1305: design and measured checkpoint

The shared design is characterized at **30 MHz**, now the default selected by
`build.py` and `measure.py`. Use `--poly1305 legacy` for the historical
80 MHz architecture, or `--target-mhz` to override the profile clock. Outputs
are isolated by implementation and target. Automatic body/MCP discovery
remains unseeded and uncapped.

The completed 2026-10-02 run's [summary](../../measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/summary.md),
[comparison](../../measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/comparison.md),
and [hardware evidence](../../measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/hardware-evidence.json)
are durable. Scratch `validation/` and generated caches are not required to
read these results. Legacy QoR was not rerun.

## Logical checkpoint at 30 MHz

The primary shared hardware build confirmed an automatic body core latency of
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
Compiler cache/re-elaboration/sweep regressions are described in the
[compiler-test handoff](../../COMPILER_TEST_HANDOFF.md), not a WireGuard
unit-test directory.

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

# New Design

## Implemented contract

The implementation uses separate, whole-function automatic MCPs for the
prologue and epilogue, with a free-running valid-only automatic body pipeline.
There is no body ready signal, skid buffer, or output FIFO. The public MAC
ports retain their valid/ready contracts. Powers are recomputed for every
packet, with one packet context active at a time.

Let P be the discovered body `AUTO_PIPELINE.latency`. Including its explicit
input and output registers, D = P + 2; use L = D accumulators with same-cycle
writeback forwarding. No initial latency guesses, fixed depths, or maximum
latencies are supplied to the new automatic pipeline/MCPs.

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
the whole function. Seeding known-good starting latencies remains a possible
follow-up, not part of the unseeded design that produced these results.


## Standalone testbenches

Run from `3.build/pypeline_build`, using `PYPELINEC` or `pypelinec` on PATH.
The single source `src/poly1305_pipelined_syn_tb.py` selects its cases at
elaboration via these environment variables; no special runner is needed:

| Variable | Choices / default | Coverage |
| --- | --- | --- |
| WG_POLY1305_TB_MODE | mac (default), body, arithmetic, components | Independent reference tags; exact body latency/bubbles; integer-oracle arithmetic; production power graph and rotated final sum. |
| WG_POLY1305_TB_DIRECTION | encrypt (default), decrypt | Select the direction's stable body callable identity. |
| WG_POLY1305_TB_BODY_DEPTH | unset (automatic), or 0,1,3,6 | Testbench-only fixed stages, giving L=2,3,5,8; not valid in arithmetic mode. |

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
for mode in arithmetic body components mac; do
  WG_POLY1305_IMPL=pipelined WG_TARGET_MHZ=30 \
  WG_POLY1305_TB_MODE="$mode" WG_POLY1305_TB_DIRECTION=encrypt \
  WG_POLY1305_TB_BODY_DEPTH= \
    "${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
      --sim --comb --run all \
      --out_dir "generated-files-poly1305-$mode-encrypt-comb-native"
done
```

For automatically sized MAC RTL at the selected 30 MHz goal:

```sh
WG_POLY1305_IMPL=pipelined WG_TARGET_MHZ=30 \
WG_POLY1305_TB_MODE=mac WG_POLY1305_TB_DIRECTION=encrypt \
WG_POLY1305_TB_BODY_DEPTH= \
  "${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
    --sim --cocotb --ghdl --run all -j 1 --stop_on_over_capacity \
    --out_dir generated-files-poly1305-mac-encrypt-pipe-30mhz
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
      WG_POLY1305_IMPL=pipelined WG_TARGET_MHZ=30 \
      WG_POLY1305_TB_MODE="$mode" WG_POLY1305_TB_DIRECTION="$direction" \
      WG_POLY1305_TB_BODY_DEPTH="$depth" \
        "${PYPELINEC:-pypelinec}" ./src/poly1305_pipelined_syn_tb.py \
          --sim --comb --run all \
          --out_dir "generated-files-poly1305-$mode-$direction-depth$depth-native"
    done
  done
done
```

The shared production build's emitted MCP arithmetic can be audited without
another synthesis:

```sh
./measure.py --audit-mcps generated-files-verilog-shared-poly1305-pipelined-30mhz
```

This rejects registered arithmetic descendants inside all four MCPs; wrapper
and body registers are allowed. It is not timing/constraint sign-off.
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
3*2^128 rather than zero. The legacy FSM and its MCP starting configuration
remain unchanged.

The complete-block MAC and full AEAD testbenches use independent integer or
cryptography references, including the RFC 8439 known-answer vector.
The original C designs remain unfixed; their tags and padded-length framing
are not this port's expected outputs.

# References:

[1] Improve chacha poly per-packet overhead [Issue39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)

[2] [Illustration](https://share.gemini.google/dCzLp7lhYqaR) of the algorithm
