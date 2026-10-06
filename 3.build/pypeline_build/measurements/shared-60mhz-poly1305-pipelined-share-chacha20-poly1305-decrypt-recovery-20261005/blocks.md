**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **14.12 B/cyc** when fed (@1920 B), Poly1305 **16.00 B/cyc** (@1920 B) — ChaCha20 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 13.03 B/cyc, **92% of ChaCha20's ceiling**.
- **decrypt**: ChaCha20 serves **14.17 B/cyc** when fed (@1920 B), Poly1305 **13.27 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 13.06 B/cyc, **98% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.362 | ≥7.111 | 2.25 | 3% | 1% | POLY_KEY (96%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.362 | 2.207 | 7.25 | 14% | 0% | IDLE (84%) |
| b2b-16 | 16 | encrypt | poly1305 | 1.446 | 8.828 | 1.81 | 7% | 1% | IDLE (40%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.362 | 16.000 | 1.00 | 0% | 64% | CIPHERTEXT (66%) |
| b2b-16 | 16 | encrypt | output_slice | 0.723 | 16.000 | 1.00 | 0% | 95% | - |
| b2b-16 | 16 | decrypt | chacha20 | 0.362 | 8.000 | 2.00 | 2% | 4% | POLY_KEY (94%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.362 | 0.438 | 36.50 | 80% | 0% | AAD_STATE (76%) |
| b2b-16 | 16 | decrypt | auth_buffer | 0.362 | ≥16.000 | 1.00 | 0% | 98% | - |
| b2b-16 | 16 | decrypt | poly1305 | 1.446 | 1.790 | 8.94 | 72% | 0% | IDLE (34%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.723 | 1.438 | 11.12 | 46% | 20% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.362 | 16.000 | 1.00 | 0% | 98% | WAIT_TO_VERIFY_BIT (98%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 84% | TAKE_CALC_TAG (86%) |
| b2b-64 | 64 | encrypt | chacha20 | 1.313 | ≥12.190 | 1.31 | 3% | 1% | POLY_KEY (91%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 1.313 | 6.919 | 2.31 | 11% | 0% | IDLE (81%) |
| b2b-64 | 64 | encrypt | poly1305 | 2.297 | 12.108 | 1.32 | 5% | 1% | IDLE (39%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 1.313 | 16.000 | 1.00 | 0% | 61% | CIPHERTEXT (69%) |
| b2b-64 | 64 | encrypt | output_slice | 1.641 | 16.000 | 1.00 | 0% | 90% | - |
| b2b-64 | 64 | decrypt | chacha20 | 1.313 | 11.636 | 1.38 | 3% | 4% | POLY_KEY (88%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 1.313 | 1.590 | 10.06 | 74% | 0% | AAD_STATE (71%) |
| b2b-64 | 64 | decrypt | auth_buffer | 1.313 | ≥16.000 | 1.00 | 0% | 92% | - |
| b2b-64 | 64 | decrypt | poly1305 | 2.297 | 2.835 | 5.64 | 67% | 0% | IDLE (34%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 1.641 | 3.265 | 4.90 | 40% | 22% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 1.313 | 16.000 | 1.00 | 0% | 92% | WAIT_TO_VERIFY_BIT (92%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 82% | TAKE_CALC_TAG (84%) |
| b2b-256 | 256 | encrypt | chacha20 | 3.631 | ≥14.841 | 1.08 | 2% | 1% | POLY_KEY (77%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 3.631 | 12.047 | 1.33 | 7% | 0% | IDLE (70%) |
| b2b-256 | 256 | encrypt | poly1305 | 4.312 | 14.306 | 1.12 | 3% | 1% | IDLE (41%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 3.631 | 16.000 | 1.00 | 0% | 56% | CIPHERTEXT (79%) |
| b2b-256 | 256 | encrypt | output_slice | 3.858 | 16.000 | 1.00 | 0% | 76% | - |
| b2b-256 | 256 | decrypt | chacha20 | 3.631 | 14.629 | 1.09 | 2% | 2% | POLY_KEY (75%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 3.631 | ≥4.339 | 3.69 | 61% | 0% | AAD_STATE (59%) |
| b2b-256 | 256 | decrypt | auth_buffer | 3.631 | ≥16.000 | 1.00 | 0% | 77% | - |
| b2b-256 | 256 | decrypt | poly1305 | 4.312 | 5.219 | 3.07 | 56% | 0% | IDLE (39%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 3.858 | 8.119 | 1.97 | 23% | 23% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 3.631 | 16.000 | 1.00 | 0% | 77% | WAIT_TO_VERIFY_BIT (77%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 79% | TAKE_CALC_TAG (80%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 8.790 | 12.800 | 1.25 | 14% | 0% | PLAINTEXT (67%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 8.790 | 15.284 | 1.05 | 3% | 0% | CIPHERTEXT (55%) |
| b2b-1024 | 1024 | encrypt | poly1305 | 9.202 | 16.000 | 1.00 | 0% | 1% | STREAM_BODY (58%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 8.790 | 16.000 | 1.00 | 0% | 32% | CIPHERTEXT (87%) |
| b2b-1024 | 1024 | encrypt | output_slice | 8.927 | 16.000 | 1.00 | 0% | 44% | - |
| b2b-1024 | 1024 | decrypt | chacha20 | 8.790 | 12.881 | 1.24 | 13% | 1% | PLAINTEXT (67%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 8.790 | 11.011 | 1.45 | 25% | 0% | CIPHERTEXT (55%) |
| b2b-1024 | 1024 | decrypt | auth_buffer | 8.790 | ≥16.000 | 1.00 | 0% | 45% | - |
| b2b-1024 | 1024 | decrypt | poly1305 | 9.202 | 11.621 | 1.38 | 22% | 0% | STREAM_BODY (58%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 8.927 | ≥12.919 | 1.24 | 13% | 31% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 8.790 | 16.000 | 1.00 | 0% | 45% | OUTPUT_PLAINTEXT (55%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 55% | TAKE_CALC_TAG (55%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 9.595 | 13.492 | 1.18 | 11% | 1% | PLAINTEXT (70%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 9.595 | 15.435 | 1.03 | 2% | 0% | CIPHERTEXT (60%) |
| b2b-1420 | 1420 | encrypt | poly1305 | 9.946 | 16.000 | 1.00 | 0% | 0% | STREAM_BODY (62%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 9.595 | 15.955 | 1.00 | 0% | 29% | CIPHERTEXT (89%) |
| b2b-1420 | 1420 | encrypt | output_slice | 9.703 | 15.956 | 1.00 | 0% | 39% | - |
| b2b-1420 | 1420 | decrypt | chacha20 | 9.595 | 13.556 | 1.18 | 11% | 1% | PLAINTEXT (70%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 9.595 | 12.008 | 1.33 | 20% | 0% | CIPHERTEXT (60%) |
| b2b-1420 | 1420 | decrypt | auth_buffer | 9.595 | ≥15.955 | 1.00 | 0% | 40% | - |
| b2b-1420 | 1420 | decrypt | poly1305 | 9.946 | 12.528 | 1.28 | 17% | 0% | STREAM_BODY (62%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 9.703 | ≥13.579 | 1.18 | 11% | 29% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 9.595 | 15.955 | 1.00 | 0% | 40% | OUTPUT_PLAINTEXT (60%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 43% | TAKE_AUTH_TAG (55%) |
| b2b-1920 | 1920 | encrypt | chacha20 | 10.295 | 14.118 | 1.13 | 9% | 0% | PLAINTEXT (72%) |
| b2b-1920 | 1920 | encrypt | prep_auth_data | 10.295 | 15.610 | 1.02 | 2% | 0% | CIPHERTEXT (64%) |
| b2b-1920 | 1920 | encrypt | poly1305 | 10.552 | 16.000 | 1.00 | 0% | 1% | STREAM_BODY (66%) |
| b2b-1920 | 1920 | encrypt | append_auth_tag | 10.295 | 16.000 | 1.00 | 0% | 28% | CIPHERTEXT (92%) |
| b2b-1920 | 1920 | encrypt | output_slice | 10.381 | 16.000 | 1.00 | 0% | 35% | - |
| b2b-1920 | 1920 | decrypt | chacha20 | 10.295 | 14.170 | 1.13 | 8% | 1% | PLAINTEXT (72%) |
| b2b-1920 | 1920 | decrypt | prep_auth_data | 10.295 | 12.886 | 1.24 | 16% | 0% | CIPHERTEXT (64%) |
| b2b-1920 | 1920 | decrypt | auth_buffer | 10.295 | ≥16.000 | 1.00 | 0% | 36% | - |
| b2b-1920 | 1920 | decrypt | poly1305 | 10.552 | 13.275 | 1.21 | 14% | 0% | STREAM_BODY (66%) |
| b2b-1920 | 1920 | decrypt | strip_auth_tag | 10.381 | ≥14.183 | 1.13 | 8% | 27% | - |
| b2b-1920 | 1920 | decrypt | wait_to_verify | 10.295 | 16.000 | 1.00 | 0% | 36% | OUTPUT_PLAINTEXT (64%) |
| b2b-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 34% | TAKE_AUTH_TAG (64%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 14% of the phase (accept rate 0.138, 7.25 cyc/beat while offered work, ceiling 2.21 B/cyc); its FSM sat in IDLE 84%, AAD_STATE 12% of cycles; next-worst poly1305 stalled 7% but was itself starved 1% |
| b2b-16 | 16 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 80% of the phase (accept rate 0.027, 36.50 cyc/beat while offered work, ceiling 0.44 B/cyc); its FSM sat in AAD_STATE 76%, IDLE 19% of cycles; next-worst poly1305 stalled 72% but was itself starved 0% |
| b2b-64 | 64 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 11% of the phase (accept rate 0.432, 2.31 cyc/beat while offered work, ceiling 6.92 B/cyc); its FSM sat in IDLE 81% of cycles; next-worst poly1305 stalled 5% but was itself starved 1% |
| b2b-64 | 64 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 74% of the phase (accept rate 0.099, 10.06 cyc/beat while offered work, ceiling 1.59 B/cyc); its FSM sat in AAD_STATE 71%, IDLE 19% of cycles; next-worst poly1305 stalled 67% but was itself starved 0% |
| b2b-256 | 256 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 7% of the phase (accept rate 0.753, 1.33 cyc/beat while offered work, ceiling 12.05 B/cyc); its FSM sat in IDLE 70%, CIPHERTEXT 23% of cycles; next-worst poly1305 stalled 3% but was itself starved 1% |
| b2b-256 | 256 | decrypt | **poly1305** | poly1305 backpressured its producer 56% of the phase (accept rate 0.326, 3.07 cyc/beat while offered work, ceiling 5.22 B/cyc); its FSM sat in IDLE 39%, STREAM_BODY 27% of cycles; next-worst prep_auth_data stalled 61% but was itself starved 0% |
| b2b-1024 | 1024 | encrypt | **chacha20** | chacha20 backpressured its producer 14% of the phase (accept rate 0.800, 1.25 cyc/beat while offered work, ceiling 12.80 B/cyc); its FSM sat in PLAINTEXT 67%, POLY_KEY 33% of cycles; next-worst prep_auth_data stalled 3% but was itself starved 0% |
| b2b-1024 | 1024 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 25% of the phase (accept rate 0.688, 1.45 cyc/beat while offered work, ceiling 11.01 B/cyc); its FSM sat in CIPHERTEXT 55%, AAD_STATE 23% of cycles; next-worst poly1305 stalled 22% but was itself starved 0% |
| b2b-1420 | 1420 | encrypt | **chacha20** | chacha20 backpressured its producer 11% of the phase (accept rate 0.846, 1.18 cyc/beat while offered work, ceiling 13.49 B/cyc); its FSM sat in PLAINTEXT 70%, POLY_KEY 30% of cycles; next-worst prep_auth_data stalled 2% but was itself starved 0% |
| b2b-1420 | 1420 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 20% of the phase (accept rate 0.753, 1.33 cyc/beat while offered work, ceiling 12.01 B/cyc); its FSM sat in CIPHERTEXT 60%, IDLE 21% of cycles; next-worst poly1305 stalled 17% but was itself starved 0% |
| b2b-1920 | 1920 | encrypt | **chacha20** | chacha20 backpressured its producer 9% of the phase (accept rate 0.882, 1.13 cyc/beat while offered work, ceiling 14.12 B/cyc); its FSM sat in PLAINTEXT 72%, POLY_KEY 28% of cycles; next-worst prep_auth_data stalled 2% but was itself starved 0% |
| b2b-1920 | 1920 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 16% of the phase (accept rate 0.805, 1.24 cyc/beat while offered work, ceiling 12.89 B/cyc); its FSM sat in CIPHERTEXT 64%, IDLE 21% of cycles; next-worst poly1305 stalled 14% but was itself starved 0% |

**Shared-pipeline arbitration** — includes ChaCha20 and each shared Poly1305 MCP separately. *Resource not ready* means the selected request cannot launch (compute busy or output backpressure); *contention* means the other side holds the slot and wants it; *wasted slot* means the other side holds an empty slot. Current request-aware arbiters recover lone requests; historical arbiters may have wasted slots. These waits are not body-pipeline II:

| phase | bytes | resource | dir | wanted (clk) | launched (clk) | resource not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | shared/pipe.arb | encrypt | 12 | 8 | 8% | 25% | 0% |
| b2b-16 | 16 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | decrypt | 5 | 4 | 20% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | decrypt | 15 | 4 | 73% | 0% | 0% |
| b2b-64 | 64 | shared/pipe.arb | encrypt | 9 | 8 | 0% | 11% | 0% |
| b2b-64 | 64 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | decrypt | 5 | 4 | 20% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | decrypt | 15 | 4 | 73% | 0% | 0% |
| b2b-256 | 256 | shared/pipe.arb | encrypt | 21 | 20 | 0% | 5% | 0% |
| b2b-256 | 256 | shared/pipe.arb | decrypt | 22 | 20 | 0% | 9% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | decrypt | 5 | 4 | 20% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | decrypt | 10 | 4 | 60% | 0% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | encrypt | 128 | 68 | 37% | 10% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | decrypt | 126 | 68 | 12% | 34% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | decrypt | 5 | 4 | 20% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | decrypt | 12 | 4 | 67% | 0% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | encrypt | 160 | 96 | 31% | 9% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | decrypt | 161 | 96 | 9% | 32% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | decrypt | 14 | 4 | 71% | 0% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | encrypt | 184 | 124 | 26% | 7% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | decrypt | 182 | 124 | 8% | 24% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | decrypt | 5 | 4 | 20% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | decrypt | 12 | 4 | 67% | 0% | 0% |

**Model cross-check** — Poly1305 block count x its recorded body initiation interval, against the measured packet period. The residual is everything that is not the MAC loop (prologue, body drain, epilogue, poly key round trip, framing, tag stalls, arbitration). This is a body-cost model, not a claim of one-cycle whole-packet service:

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 4 | 1.81 | 27.7 | 14% | 23.7 |
| b2b-16 | 16 | decrypt | 4 | 4 | 8.94 | 36.7 | 11% | 32.7 |
| b2b-64 | 64 | encrypt | 7 | 7 | 1.32 | 30.7 | 23% | 23.7 |
| b2b-64 | 64 | decrypt | 7 | 7 | 5.64 | 40.7 | 17% | 33.7 |
| b2b-256 | 256 | encrypt | 19 | 19 | 1.12 | 42.7 | 45% | 23.7 |
| b2b-256 | 256 | decrypt | 19 | 19 | 3.07 | 61.7 | 31% | 42.7 |
| b2b-1024 | 1024 | encrypt | 67 | 67 | 1.00 | 91.3 | 73% | 24.3 |
| b2b-1024 | 1024 | decrypt | 67 | 67 | 1.38 | 91.0 | 74% | 24.0 |
| b2b-1420 | 1420 | encrypt | 92 | 92 | 1.00 | 116.7 | 79% | 24.7 |
| b2b-1420 | 1420 | decrypt | 92 | 92 | 1.28 | 116.3 | 79% | 24.3 |
| b2b-1920 | 1920 | encrypt | 123 | 123 | 1.00 | 147.3 | 83% | 24.3 |
| b2b-1920 | 1920 | decrypt | 123 | 123 | 1.21 | 147.0 | 84% | 24.0 |

**Poly1305 lifecycle** — measured body service cycles per offered block are separate from FSM cycles per completed packet. Body time includes input gaps; setup includes the prologue handshake; finalization includes the epilogue handshake. Tag stalls are a subset of tag-output cycles, not an additional cost. IDLE/key wait and settle cycles remain in JSON. MCP request waits (total clocks in the window) are subsets of setup/finalization, including sharing contention. These are MAC-local costs, not additive whole-datapath latency:

| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) | drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) | prologue request wait (clk) | epilogue request wait (clk) |
|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | encrypt | 1.00 | 8.00 | 4.50 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-16 | decrypt | 1.00 | 10.75 | 4.00 | 6.00 | 7.25 | 1.00 | 0.00 | 11.00 | 1.00 |
| b2b-64 | encrypt | 1.00 | 8.00 | 7.50 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-64 | decrypt | 1.00 | 10.75 | 7.00 | 6.00 | 7.25 | 1.00 | 0.00 | 11.00 | 1.00 |
| b2b-256 | encrypt | 1.00 | 8.00 | 19.50 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-256 | decrypt | 1.00 | 9.50 | 19.00 | 6.00 | 7.25 | 1.00 | 0.00 | 6.00 | 1.00 |
| b2b-1024 | encrypt | 1.00 | 8.00 | 68.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1024 | decrypt | 1.00 | 10.00 | 67.00 | 6.00 | 7.25 | 1.00 | 0.00 | 8.00 | 1.00 |
| b2b-1420 | encrypt | 1.00 | 8.00 | 92.50 | 6.00 | 7.00 | 2.00 | 1.00 | 0.00 | 0.00 |
| b2b-1420 | decrypt | 1.00 | 10.50 | 92.00 | 6.00 | 7.00 | 1.00 | 0.00 | 10.00 | 0.00 |
| b2b-1920 | encrypt | 1.00 | 8.00 | 124.00 | 6.00 | 7.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1920 | decrypt | 1.00 | 10.00 | 123.00 | 6.00 | 7.25 | 1.00 | 0.00 | 8.00 | 1.00 |

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

**Buffers** (total storage capacity, including any output register):

| phase | buffer | capacity | high water | accepted | retired | simultaneous | end fill |
|---|---|---:|---:|---:|---:|---:|---:|
| b2b-16 | decrypt/auth_fifo.occupancy | 65 | 2 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/output_slice.occupancy | 2 | 1 | 8 | 8 | 0 | 0 |
| b2b-64 | decrypt/auth_fifo.occupancy | 65 | 8 | 16 | 16 | 0 | 0 |
| b2b-64 | encrypt/output_slice.occupancy | 2 | 1 | 20 | 20 | 12 | 0 |
| b2b-256 | decrypt/auth_fifo.occupancy | 65 | 32 | 64 | 64 | 9 | 0 |
| b2b-256 | encrypt/output_slice.occupancy | 2 | 1 | 68 | 68 | 60 | 0 |
| b2b-1024 | decrypt/auth_fifo.occupancy | 65 | 55 | 256 | 256 | 179 | 0 |
| b2b-1024 | encrypt/output_slice.occupancy | 2 | 1 | 260 | 260 | 252 | 0 |
| b2b-1420 | decrypt/auth_fifo.occupancy | 65 | 56 | 356 | 356 | 277 | 0 |
| b2b-1420 | encrypt/output_slice.occupancy | 2 | 1 | 360 | 360 | 352 | 0 |
| b2b-1920 | decrypt/auth_fifo.occupancy | 65 | 55 | 480 | 480 | 403 | 0 |
| b2b-1920 | encrypt/output_slice.occupancy | 2 | 1 | 484 | 484 | 476 | 0 |
