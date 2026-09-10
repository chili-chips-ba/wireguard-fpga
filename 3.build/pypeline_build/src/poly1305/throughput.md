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

**Two-Part MAC FSM Architecture**
The FSM decouples into two concurrent, pipelined processes:

* **Input Dispatch (Round-Robin):**
* Incoming 16-byte message blocks ($c_i$) are dispatched round-robin across $L$ independent accumulator registers ($A_0, \dots, A_{L-1}$).
* Every cycle, the active lane launches its tuple $(A_j, r^L, c_i)$ into `compute_pipeline`. All lanes step by the stride factor $r^L$ rather than $r$.
* Multiple independent block computations remain in flight simultaneously, saturating the pipeline.


* **Output Writeback (Round-Robin):**
* As updated accumulators emerge $D$ cycles later, an output round-robin tracker retires each $A_{j,\text{next}}$ into its designated accumulator register.
* **Timing Constraint:** Sizing $L \ge D$ guarantees that by the time Lane 0 is scheduled to ingest block $c_L$, its previous update from block $c_0$ has already retired—achieving bubble-free, stall-free operation.



---

**End-of-Packet Finalization**
Because the strided lanes compute independent partial polynomials, combining them at packet boundaries requires a **weighted sum**:


$$a = \sum_{j=0}^{L-1} \left(A_j \cdot r^{L-j}\right) \pmod{2^{130}-5}$$

Two approaches can handle this end-of-packet combine:

1. **Pipeline Reuse (Area-Optimized):** Re-route the $L$ accumulator registers through `compute_pipeline` over $L$ consecutive cycles using $c=0$ and the precomputed weights $r^{L-j}$.
2. **Dedicated Combine Tree (Throughput-Optimized):** Implement a dedicated pipelined multiplier/adder tree running in parallel to drain the packet without reconfiguring the main pipeline inputs.

**Final Tag Addition ($+ s$):**
Just like the original design's `A_PLUS_S` state, the final 128-bit key addition $(a + s) \bmod 2^{128}$ must be applied. This can be kept as a standalone terminal state or folded directly into the final reduction stage of the weighted combine before presenting the result on `auth_tag_if`.

---

### References:

[1] Improve chacha poly per-packet overhead [Issue39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39)

[2] [Illustration](https://share.gemini.google/dCzLp7lhYqaR) of the algorithm
