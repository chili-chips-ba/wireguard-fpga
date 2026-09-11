# Original Design

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

One 16-byte block processed every ~5 cycles, stalling the stream while the unpipelined multi-cycle path settles.

# Intermediate Design: 

Before collapsing the hardware into an interleaved pipeline, the parallelism can be understood as multple physical copies of the original multi-cycle engine running in parallel, with launches staggered by 1 cycle. (And uses a special final end of packet step to combine the multiple parallel accumulator results, discussed later).

```text
Incoming 16B Blocks (1 beat/cycle):
 ... ──► [ c_3 ] ──► [ c_2 ] ──► [ c_1 ] ──► [ c_0 ]
            │           │           │           │
            ▼           ▼           ▼           ▼
         [ A_3 ]     [ A_2 ]     [ A_1 ]     [ A_0 ]   (4 Accumulator Registers)
            │           │           │           │
            └───────────┼───────────┼───────────┘
                        │
                        ▼
             Round-Robin Dispatch
      (Launches 1 block/cycle into next free engine)
      Cycle 0 ──► Engine 0 (A_0, r^4, c_0)
      Cycle 1 ──► Engine 1 (A_1, r^4, c_1)
      Cycle 2 ──► Engine 2 (A_2, r^4, c_2)
      Cycle 3 ──► Engine 3 (A_3, r^4, c_3)
                        │
        ┌───────────────┼───────────────┬───────────────┐
        ▼               ▼               ▼               ▼
 ┌──────────────┐┌──────────────┐┌──────────────┐┌──────────────┐
 │compute_mcp_0 ││compute_mcp_1 ││compute_mcp_2 ││compute_mcp_3 │
 │  (MCP = 4)   ││  (MCP = 4)   ││  (MCP = 4)   ││  (MCP = 4)   │
 │              ││              ││              ││              │
 │  Evaluates   ││  Evaluates   ││  Evaluates   ││  Evaluates   │
 │  Cycles 0..3 ││  Cycles 1..4 ││  Cycles 2..5 ││  Cycles 3..6 │
 └──────┬───────┘└──────┬───────┘└──────┬───────┘└──────┬───────┘
        │               │               │               │
        ▼               ▼               ▼               ▼
     [ A_0 ]         [ A_1 ]         [ A_2 ]         [ A_3 ]   ◄── SAME 4 Accumulators
        │               │               │               │          (Engine 0 settles at cycle 4,
        │               │               │               │           ready right as block c_4 arrives!)
        └───────────────┼───────────────┼───────────────┘
                        │
                        ▼ (Loop repeats until Last Block)


      (same 'End of Packet Combine' as show in below sections)
```

# New Design

Schematic-style dataflow between blocks:

```text
                            key_if (r powers, s)
                                     │
                                     ▼
             ┌─────────────────────────────────────────────────┐
             │              new_poly1305_mac_fsm               │
             │                                                 │
             │  Registers:                                     │
             │    • A_0 … A_{L-1} (L accumulators)             │
             │    • r^L (loop step), r^1…r^L (combine), s      │
             │                                                 │
  data_in_if │  Input Dispatch:               Output Writeback:│ auth_tag_if
  ──────────►│    Round-robin select            Round-robin    ├────────────►
             │    (c_i -> lane j)               retire to A_j  │
             │                                                 │
             │  End-of-Packet Combine:                         │
             │    1. Weighted combine: ∑ (A_j · r^{L-j}) mod p │
             │    2. Final tag add: (a + s) mod 2^128          │
             └───────┬─────────────────────────────────▲───────┘
                     │                                 │
          to_compute │                                 │ from_compute
      (A_j, r^L, c_i)│                                 │ (A_j_next)
                     ▼                                 │
             ┌─────────────────────────────────────────┴───────┐
             │                compute_pipeline                 │
             │        (autopipelined, II = 1, D stages)        │
             │   [ multiple (A_j, r^L, c_i) beats in flight ]  │
             └─────────────────────────────────────────────────┘
```

Logical algorithm execution diagram:

```text
Incoming 16B Blocks (1 beat/cycle):
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
 ═══════════════════════════════════════════════════════════════════════════
                      compute_pipeline (Depth D, II = 1)
 ───────────────────────────────────────────────────────────────────────────
   [ Stage 1 ]     ──►     [ Stage 2 ]     ──►  ...  ──►     [ Stage D ]
  (A_3, r^L, c_3)         (A_2, r^L, c_2)                   (A_0, r^L, c_0)
 ═══════════════════════════════════════════════════════════════════════════
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
                 End of Packet Combine (Runs Once per Packet)
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
  * $r^4 = (r^2 \cdot r^2) \pmod p \quad (\text{or } r^L \text{ for general } L)$
  * *Purpose:* $r^L$ serves as the constant stride multiplier during streaming; $r^1 \dots r^L$ are retained for the epilogue.


* **Accumulator Reset:** Initialize all $L$ lane accumulators to zero:



## **2. Streaming Message Loop (1 block/cycle, $\text{II} = 1$) Two-Part MAC FSM Architecture**
The FSM decouples into two concurrent, pipelined processes:

* **Input Dispatch (Round-Robin):**
  * Incoming 16-byte message blocks ($c_i$) are dispatched round-robin across $L$ independent accumulator registers ($A_0, \dots, A_{L-1}$).
  * Every cycle, the active lane launches its tuple $(A_j, r^L, c_i)$ into `compute_pipeline`. All lanes step by the stride factor $r^L$ rather than $r$.
  * Multiple independent block computations remain in flight simultaneously, saturating the pipeline.


* **Output Writeback (Round-Robin):**
  * As updated accumulators emerge $D$ cycles later, an output round-robin tracker retires each $A_{j,\text{next}}$ into its designated accumulator register.

* **Timing Constraint:** Sizing $L \ge D$ guarantees that by the time Lane 0 is scheduled to ingest block $c_L$, its previous update from block $c_0$ has already retired—achieving bubble-free, stall-free operation.



---

## **3. Epilogue (Finalization after last beat)**
Because the strided lanes compute independent partial polynomials, combining them at packet boundaries requires a **weighted sum**:

### **Weighted Combine:** Fold all $L$ partial polynomial accumulators using the precomputed powers:

$$a = \left(\sum_{j=0}^{L-1} A_j \cdot r^{L-j}\right) \pmod{2^{130}-5}$$

### **Final Tag Addition:** Truncate to 128 bits and add key $s$:

$$\text{tag} = (a \bmod 2^{128} + s) \bmod 2^{128}$$

Just like the original design's `A_PLUS_S` state, the final 128-bit key addition $(a + s) \bmod 2^{128}$ must be applied. 

### Comparison of Combine Options ($L = 4, D \approx 4\text{--}5$)

The choice of end-of-packet (EOP) combine architecture dictates the area ceiling of the entire crypto core and whether back-to-back packets incur inter-frame bubbles.

| Architecture | Additional DSP48s | EOP Drain Latency | Inter-Packet Bubble | Fit / Feasibility |
| --- | --- | --- | --- | --- |
| **Option 1: Pipeline Reuse (Time-Multiplexed)** | **0** (Reuses `compute_pipeline`) | $2D + L \approx 12\text{--}14\text{ cycles}$ | $2D + L$ cycles (unless hidden) | **Best for Artix-7 (A35T/A100T)**; minimal area |
| **Option 2: Dedicated Parallel Tree** | **+30 to +48** (3–4 full modular multipliers) | $D + \log_2 L \approx 6\text{--}7\text{ cycles}$ | **0 cycles** (pure streaming) | **Prohibitive on A35T**; burns 50–70% of total DSPs |
| **Option 3: Dedicated Serial Multiplier** | **+10 to +16** (1 dedicated modular multiplier) | $D + L \cdot D \approx 20\text{--}24\text{ cycles}$ | **0 cycles** on main pipeline | Compromise if main pipe cannot be interrupted |

---

### Option 1: Pipeline Reuse (Area-Optimized)

The $L$ accumulator registers are looped back into the main `compute_pipeline` over $L$ consecutive cycles with input block $c = 0$ and precomputed weights $r^{L-j}$.

* **Latency:**
1. **Pipeline Drain:** After the last block $c_{N-1}$ enters, wait $D$ cycles for all accumulators $A_0 \dots A_{L-1}$ to retire.
2. **Injection:** Inject the $L$ combine tuples $(A_0, r^4, 0), (A_1, r^3, 0), \dots$ over $L$ consecutive cycles.
3. **Output Accumulation:** As products emerge $D$ cycles later, sum them into a simple 130-bit modular accumulator.


* **Total EOP Latency:** $2D + L$ cycles ($\approx 12\text{--}14\text{ cycles}$ at $D=4, L=4$).


* **Throughput Impact:**
* If the next packet is waiting to stream, the pipeline is blocked for ~12–14 cycles.
* For a standard MTU packet (1420 bytes $\approx$ 89 blocks), a 13-cycle bubble reduces peak line throughput by **~12%** ($89 / (89 + 13) \approx 87\%$ of line rate).
* For small packets (e.g., 64 bytes = 4 blocks), throughput drops by **~75%**.


* **Area:** **0 additional multipliers**. Requires only input multiplexers on `to_compute_if` and a 130-bit adder on the output.

---

### Option 2: Dedicated Parallel Tree (Throughput-Optimized)

$L$ dedicated modular multipliers compute all terms $A_j \cdot r^{L-j}$ simultaneously, feeding a 2-level adder tree.

* **Latency:**
* Wait $D$ cycles for the message loop to drain.
* Multiply all lanes in parallel ($D_{\text{mult}} \approx 4\text{ cycles}$) and reduce through the adder tree ($2\text{ cycles}$).
* **Total EOP Latency:** $D + 6 \approx 10\text{ cycles}$.


* **Throughput Impact:**
* **Zero inter-packet stall on the main datapath.** The moment block $c_{N-1}$ enters `compute_pipeline`, Packet $k+1$ can begin streaming immediately into the main pipeline.


* **Area Penalty:**
* A single 130-bit modular multiplier uses **10 to 16 DSP48E1 slices** on Xilinx 7-series (depending on whether Karatsuba or radix-$2^{26}$ decomposition is used).
* Replicating this for 4 parallel paths requires **40 to 64 DSP48s** just for the combine block. On an Artix-7 35T (90 DSPs total), this will cause routing congestion or fit failures.

---

### Option 3: Dedicated Serial Multiplier / Horner Fold

Instead of $L$ parallel multipliers, a single separate modular multiplier evaluates the accumulators via Horner's rule:


$$a = \left(\left(\left(A_0 \cdot r + A_1\right) \cdot r + A_2\right) \cdot r + A_3\right) \cdot r \pmod p$$

* **Area:** Exactly 1 dedicated modular multiplier (~10–16 DSPs).
* **Throughput:** Zero stall on the main pipeline (Packet $k+1$ can start immediately).
* **Latency:** High sequential latency ($L \times D \approx 16\text{--}20\text{ cycles}$), but runs entirely in the background while the next packet starts.


### Final Tag Addition ($+ s$) Implementation

* **Folded into Final Combine Reduction (Recommended):**
* The final modular sum produces $a \pmod{2^{130}-5}$. The tag definition truncates to 128 bits: $(a[127:0] + s[127:0]) \bmod 2^{128}$.
* Because this is a standard 128-bit adder without carry-out or feedback, it can be placed directly in the output register slice of the modular adder tree. It adds **0 additional clock cycles**.


* **Standalone FSM State (`A_PLUS_S`):**
* Adding a dedicated cycle mirrors the existing design's state machine. It is simpler to verify in isolation, costing exactly **1 clock cycle** of tag latency before asserting `auth_tag_if.valid`.



---

# References:

[1] Improve chacha poly per-packet overhead [Issue39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)

[2] [Illustration](https://share.gemini.google/dCzLp7lhYqaR) of the algorithm



