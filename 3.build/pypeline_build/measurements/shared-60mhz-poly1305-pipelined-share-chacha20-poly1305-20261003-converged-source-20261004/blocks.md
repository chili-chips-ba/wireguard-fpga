**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **14.09 B/cyc** when fed (@1920 B), Poly1305 **15.59 B/cyc** (@1920 B) — ChaCha20 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 13.15 B/cyc, **93% of ChaCha20's ceiling**.
- **decrypt**: ChaCha20 serves **14.20 B/cyc** when fed (@1920 B), Poly1305 **11.54 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.2x**; at 1920 B the whole datapath delivers 10.00 B/cyc, **87% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.282 | ≥9.143 | 1.75 | 1% | 1% | POLY_KEY (97%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.282 | 1.882 | 8.50 | 13% | 0% | IDLE (85%) |
| b2b-16 | 16 | encrypt | poly1305 | 1.128 | 7.529 | 2.12 | 8% | 0% | IDLE (54%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.282 | 16.000 | 1.00 | 0% | 72% | CIPHERTEXT (74%) |
| b2b-16 | 16 | decrypt | chacha20 | 0.282 | 7.111 | 2.25 | 2% | 81% | PLAINTEXT (83%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.282 | ≥0.340 | 47.00 | 81% | 0% | AAD_STATE (79%) |
| b2b-16 | 16 | decrypt | poly1305 | 1.128 | 1.362 | 11.75 | 76% | 0% | IDLE (53%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.564 | ≥0.667 | 24.00 | 81% | 15% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.282 | 16.000 | 1.00 | 0% | 98% | WAIT_TO_VERIFY_BIT (60%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 19% | TAKE_AUTH_TAG (75%) |
| b2b-64 | 64 | encrypt | chacha20 | 1.032 | ≥12.800 | 1.25 | 2% | 1% | POLY_KEY (93%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 1.032 | 5.953 | 2.69 | 11% | 0% | IDLE (83%) |
| b2b-64 | 64 | encrypt | poly1305 | 1.806 | 10.419 | 1.54 | 6% | 0% | IDLE (53%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 1.032 | 16.000 | 1.00 | 0% | 69% | CIPHERTEXT (76%) |
| b2b-64 | 64 | decrypt | chacha20 | 1.032 | 12.190 | 1.31 | 2% | 77% | PLAINTEXT (83%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 1.032 | ≥1.243 | 12.88 | 77% | 0% | AAD_STATE (75%) |
| b2b-64 | 64 | decrypt | poly1305 | 1.806 | 2.175 | 7.36 | 72% | 0% | IDLE (52%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 1.290 | ≥1.524 | 10.50 | 77% | 15% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 1.032 | 16.000 | 1.00 | 0% | 94% | WAIT_TO_VERIFY_BIT (56%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 18% | TAKE_AUTH_TAG (77%) |
| b2b-256 | 256 | encrypt | chacha20 | 3.200 | ≥14.841 | 1.08 | 2% | 1% | POLY_KEY (79%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 3.200 | 11.506 | 1.39 | 8% | 0% | IDLE (72%) |
| b2b-256 | 256 | encrypt | poly1305 | 3.800 | 13.663 | 1.17 | 4% | 0% | IDLE (49%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 3.200 | 16.000 | 1.00 | 0% | 61% | CIPHERTEXT (81%) |
| b2b-256 | 256 | decrypt | chacha20 | 3.200 | 14.841 | 1.08 | 2% | 67% | PLAINTEXT (87%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 3.200 | ≥3.683 | 4.34 | 67% | 0% | AAD_STATE (66%) |
| b2b-256 | 256 | decrypt | poly1305 | 3.800 | 4.374 | 3.66 | 63% | 0% | IDLE (48%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 3.400 | ≥3.858 | 4.15 | 67% | 12% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 3.200 | 16.000 | 1.00 | 0% | 80% | WAIT_TO_VERIFY_BIT (58%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 14% | TAKE_AUTH_TAG (82%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 7.014 | 13.342 | 1.20 | 9% | 0% | PLAINTEXT (52%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 7.014 | 14.577 | 1.10 | 4% | 0% | IDLE (52%) |
| b2b-1024 | 1024 | encrypt | poly1305 | 7.342 | 15.260 | 1.05 | 2% | 0% | STREAM_BODY (46%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 7.014 | 16.000 | 1.00 | 0% | 46% | CIPHERTEXT (90%) |
| b2b-1024 | 1024 | decrypt | chacha20 | 7.014 | 14.076 | 1.14 | 6% | 36% | PLAINTEXT (84%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 7.014 | ≥8.752 | 1.83 | 36% | 4% | CIPHERTEXT (48%) |
| b2b-1024 | 1024 | decrypt | poly1305 | 7.342 | 9.162 | 1.75 | 34% | 4% | STREAM_BODY (50%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 7.123 | ≥8.353 | 1.92 | 41% | 15% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 7.014 | 16.000 | 1.00 | 0% | 56% | WAIT_TO_VERIFY_BIT (56%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 7% | TAKE_AUTH_TAG (91%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 7.553 | 14.025 | 1.14 | 7% | 0% | PLAINTEXT (53%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 7.553 | 14.947 | 1.07 | 3% | 0% | IDLE (49%) |
| b2b-1420 | 1420 | encrypt | poly1305 | 7.830 | 15.495 | 1.03 | 2% | 0% | STREAM_BODY (49%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 7.553 | 15.955 | 1.00 | 0% | 44% | CIPHERTEXT (91%) |
| b2b-1420 | 1420 | decrypt | chacha20 | 7.553 | 14.380 | 1.11 | 5% | 33% | PLAINTEXT (84%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 7.553 | ≥9.373 | 1.70 | 33% | 4% | CIPHERTEXT (51%) |
| b2b-1420 | 1420 | decrypt | poly1305 | 7.830 | 9.716 | 1.65 | 32% | 4% | STREAM_BODY (53%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 7.638 | ≥8.961 | 1.78 | 37% | 15% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 7.553 | 15.955 | 1.00 | 0% | 53% | WAIT_TO_VERIFY_BIT (53%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 6% | TAKE_AUTH_TAG (93%) |
| b2b-1920 | 1920 | encrypt | chacha20 | 8.727 | 14.092 | 1.14 | 7% | 0% | PLAINTEXT (62%) |
| b2b-1920 | 1920 | encrypt | prep_auth_data | 8.727 | 15.208 | 1.05 | 3% | 0% | CIPHERTEXT (55%) |
| b2b-1920 | 1920 | encrypt | poly1305 | 8.945 | 15.588 | 1.03 | 1% | 0% | STREAM_BODY (56%) |
| b2b-1920 | 1920 | encrypt | append_auth_tag | 8.727 | 16.000 | 1.00 | 0% | 39% | CIPHERTEXT (93%) |
| b2b-1920 | 1920 | decrypt | chacha20 | 8.727 | 14.196 | 1.13 | 7% | 22% | PLAINTEXT (83%) |
| b2b-1920 | 1920 | decrypt | prep_auth_data | 8.727 | ≥11.261 | 1.42 | 23% | 6% | CIPHERTEXT (60%) |
| b2b-1920 | 1920 | decrypt | poly1305 | 8.945 | 11.543 | 1.39 | 22% | 6% | STREAM_BODY (62%) |
| b2b-1920 | 1920 | decrypt | strip_auth_tag | 8.800 | ≥10.493 | 1.52 | 29% | 16% | - |
| b2b-1920 | 1920 | decrypt | wait_to_verify | 8.727 | 16.000 | 1.00 | 0% | 45% | OUTPUT_PLAINTEXT (55%) |
| b2b-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 5% | TAKE_AUTH_TAG (94%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 13% of the phase (accept rate 0.118, 8.50 cyc/beat while offered work, ceiling 1.88 B/cyc); its FSM sat in IDLE 85%, AAD_STATE 11% of cycles; next-worst poly1305 stalled 8% but was itself starved 0% |
| b2b-16 | 16 | decrypt | **poly1305** | poly1305 backpressured its producer 76% of the phase (accept rate 0.085, 11.75 cyc/beat while offered work, ceiling 1.36 B/cyc); its FSM sat in IDLE 53%, PROLOGUE_WAIT 12% of cycles; next-worst prep_auth_data stalled 81% but was itself starved 0% |
| b2b-64 | 64 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 11% of the phase (accept rate 0.372, 2.69 cyc/beat while offered work, ceiling 5.95 B/cyc); its FSM sat in IDLE 83% of cycles; next-worst poly1305 stalled 6% but was itself starved 0% |
| b2b-64 | 64 | decrypt | **poly1305** | poly1305 backpressured its producer 72% of the phase (accept rate 0.136, 7.36 cyc/beat while offered work, ceiling 2.17 B/cyc); its FSM sat in IDLE 52%, PROLOGUE_WAIT 11% of cycles; next-worst prep_auth_data stalled 77% but was itself starved 0% |
| b2b-256 | 256 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 8% of the phase (accept rate 0.719, 1.39 cyc/beat while offered work, ceiling 11.51 B/cyc); its FSM sat in IDLE 72%, CIPHERTEXT 20% of cycles; next-worst poly1305 stalled 4% but was itself starved 0% |
| b2b-256 | 256 | decrypt | **poly1305** | poly1305 backpressured its producer 63% of the phase (accept rate 0.273, 3.66 cyc/beat while offered work, ceiling 4.37 B/cyc); its FSM sat in IDLE 48%, STREAM_BODY 24% of cycles; next-worst prep_auth_data stalled 67% but was itself starved 0% |
| b2b-1024 | 1024 | encrypt | **chacha20** | chacha20 backpressured its producer 9% of the phase (accept rate 0.834, 1.20 cyc/beat while offered work, ceiling 13.34 B/cyc); its FSM sat in PLAINTEXT 52%, POLY_KEY 48% of cycles; next-worst prep_auth_data stalled 4% but was itself starved 0% |
| b2b-1024 | 1024 | decrypt | **poly1305** | poly1305 backpressured its producer 34% of the phase (accept rate 0.573, 1.75 cyc/beat while offered work, ceiling 9.16 B/cyc); its FSM sat in STREAM_BODY 50%, IDLE 35% of cycles; next-worst strip_auth_tag stalled 41% but was itself starved 15% |
| b2b-1420 | 1420 | encrypt | **chacha20** | chacha20 backpressured its producer 7% of the phase (accept rate 0.879, 1.14 cyc/beat while offered work, ceiling 14.02 B/cyc); its FSM sat in PLAINTEXT 53%, POLY_KEY 47% of cycles; next-worst prep_auth_data stalled 3% but was itself starved 0% |
| b2b-1420 | 1420 | decrypt | **poly1305** | poly1305 backpressured its producer 32% of the phase (accept rate 0.607, 1.65 cyc/beat while offered work, ceiling 9.72 B/cyc); its FSM sat in STREAM_BODY 53%, IDLE 35% of cycles; next-worst strip_auth_tag stalled 37% but was itself starved 15% |
| b2b-1920 | 1920 | encrypt | **chacha20** | chacha20 backpressured its producer 7% of the phase (accept rate 0.881, 1.14 cyc/beat while offered work, ceiling 14.09 B/cyc); its FSM sat in PLAINTEXT 62%, POLY_KEY 38% of cycles; next-worst prep_auth_data stalled 3% but was itself starved 0% |
| b2b-1920 | 1920 | decrypt | **poly1305** | poly1305 backpressured its producer 22% of the phase (accept rate 0.721, 1.39 cyc/beat while offered work, ceiling 11.54 B/cyc); its FSM sat in STREAM_BODY 62%, IDLE 29% of cycles; next-worst strip_auth_tag stalled 29% but was itself starved 16% |

**Shared-pipeline arbitration** — includes ChaCha20 and each shared Poly1305 MCP separately. *Resource not ready* means the selected request cannot launch (compute busy or output backpressure); *contention* means the other side holds the slot and wants it; *wasted slot* means the other side holds an empty slot. Current request-aware arbiters recover lone requests; historical arbiters may have wasted slots. These waits are not body-pipeline II:

| phase | bytes | resource | dir | wanted (clk) | launched (clk) | resource not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | shared/pipe.arb | encrypt | 9 | 8 | 11% | 0% | 0% |
| b2b-16 | 16 | shared/pipe.arb | decrypt | 9 | 8 | 0% | 11% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | decrypt | 8 | 4 | 50% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | decrypt | 14 | 4 | 71% | 0% | 0% |
| b2b-64 | 64 | shared/pipe.arb | encrypt | 8 | 8 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/pipe.arb | decrypt | 9 | 8 | 0% | 11% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | decrypt | 8 | 4 | 50% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | decrypt | 14 | 4 | 71% | 0% | 0% |
| b2b-256 | 256 | shared/pipe.arb | encrypt | 21 | 20 | 0% | 5% | 0% |
| b2b-256 | 256 | shared/pipe.arb | decrypt | 21 | 20 | 0% | 5% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | decrypt | 8 | 4 | 50% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | decrypt | 15 | 4 | 73% | 0% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | encrypt | 115 | 68 | 30% | 10% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | decrypt | 107 | 68 | 18% | 19% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | decrypt | 6 | 4 | 33% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | decrypt | 10 | 4 | 60% | 0% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | encrypt | 142 | 96 | 20% | 12% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | decrypt | 144 | 96 | 17% | 17% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | decrypt | 6 | 4 | 33% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | decrypt | 15 | 4 | 73% | 0% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | encrypt | 185 | 124 | 6% | 26% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | decrypt | 189 | 124 | 31% | 3% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | decrypt | 6 | 4 | 33% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | decrypt | 10 | 4 | 60% | 0% | 0% |

**Model cross-check** — Poly1305 block count x its recorded body initiation interval, against the measured packet period. The residual is everything that is not the MAC loop (prologue, body drain, epilogue, poly key round trip, framing, tag stalls, arbitration). This is a body-cost model, not a claim of one-cycle whole-packet service:

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 4 | 2.12 | 27.0 | 15% | 23.0 |
| b2b-16 | 16 | decrypt | 4 | 4 | 11.75 | 36.3 | 11% | 32.3 |
| b2b-64 | 64 | encrypt | 7 | 7 | 1.54 | 30.0 | 23% | 23.0 |
| b2b-64 | 64 | decrypt | 7 | 7 | 7.36 | 39.3 | 18% | 32.3 |
| b2b-256 | 256 | encrypt | 19 | 19 | 1.17 | 42.0 | 45% | 23.0 |
| b2b-256 | 256 | decrypt | 19 | 19 | 3.66 | 51.7 | 37% | 32.7 |
| b2b-1024 | 1024 | encrypt | 67 | 67 | 1.05 | 90.0 | 74% | 23.0 |
| b2b-1024 | 1024 | decrypt | 67 | 67 | 1.75 | 130.7 | 51% | 63.7 |
| b2b-1420 | 1420 | encrypt | 92 | 92 | 1.03 | 116.0 | 79% | 24.0 |
| b2b-1420 | 1420 | decrypt | 92 | 92 | 1.65 | 170.0 | 54% | 78.0 |
| b2b-1920 | 1920 | encrypt | 123 | 123 | 1.03 | 146.0 | 84% | 23.0 |
| b2b-1920 | 1920 | decrypt | 123 | 123 | 1.39 | 192.0 | 64% | 69.0 |

**Poly1305 lifecycle** — measured body service cycles per offered block are separate from FSM cycles per completed packet. Body time includes input gaps; setup includes the prologue handshake; finalization includes the epilogue handshake. Tag stalls are a subset of tag-output cycles, not an additional cost. IDLE/key wait and settle cycles remain in JSON. MCP request waits (total clocks in the window) are subsets of setup/finalization, including sharing contention. These are MAC-local costs, not additive whole-datapath latency:

| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) | drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) | prologue request wait (clk) | epilogue request wait (clk) |
|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | encrypt | 1.00 | 8.00 | 4.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-16 | decrypt | 1.00 | 10.50 | 4.00 | 3.00 | 8.00 | 1.00 | 0.00 | 10.00 | 4.00 |
| b2b-64 | encrypt | 1.00 | 8.00 | 7.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-64 | decrypt | 1.00 | 10.50 | 7.00 | 3.00 | 8.00 | 1.00 | 0.00 | 10.00 | 4.00 |
| b2b-256 | encrypt | 1.00 | 8.00 | 19.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-256 | decrypt | 1.00 | 10.75 | 19.00 | 3.00 | 8.00 | 1.00 | 0.00 | 11.00 | 4.00 |
| b2b-1024 | encrypt | 1.00 | 8.00 | 67.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1024 | decrypt | 1.00 | 9.50 | 73.50 | 3.00 | 7.50 | 1.00 | 0.00 | 6.00 | 2.00 |
| b2b-1420 | encrypt | 1.00 | 8.00 | 92.00 | 6.00 | 7.00 | 2.00 | 1.00 | 0.00 | 0.00 |
| b2b-1420 | decrypt | 1.00 | 10.75 | 99.75 | 3.00 | 7.50 | 1.00 | 0.00 | 11.00 | 2.00 |
| b2b-1920 | encrypt | 1.00 | 8.00 | 123.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1920 | decrypt | 1.00 | 9.50 | 136.00 | 3.00 | 7.50 | 1.00 | 0.00 | 6.00 | 2.00 |

**Shared Poly1305 MCP service** — physical-service occupancy, separate from each requester's arbitration wait and private body II. Compute cycles run from accepted launch until a valid response; output stalls are a subset of response-valid cycles, not additional compute time:

| phase | service | requests | responses | compute (clk) | compute (clk/request) | response valid (clk) | response stalls (clk) |
|---|---|---|---|---|---|---|---|
| b2b-16 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-16 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
| b2b-64 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-64 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
| b2b-256 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-256 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
| b2b-1024 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-1024 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
| b2b-1420 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-1420 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
| b2b-1920 | prologue | 8 | 8 | 48 | 6.00 | 8 | 0 |
| b2b-1920 | epilogue | 8 | 8 | 40 | 5.00 | 8 | 0 |
