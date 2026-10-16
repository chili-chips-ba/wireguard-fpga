**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **15.80 B/cyc** when fed (@1920 B), Poly1305 **15.84 B/cyc** (@1920 B) — ChaCha20 is the slower block by **1.0x**; at 1920 B the whole datapath delivers 15.48 B/cyc, **98% of ChaCha20's ceiling**.
- **decrypt**: ChaCha20 serves **15.80 B/cyc** when fed (@1920 B), Poly1305 **14.60 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 15.48 B/cyc, **106% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.348 | 7.111 | 2.25 | 3% | 1% | POLY_KEY (96%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.348 | 1.049 | 15.25 | 31% | 0% | IDLE (67%) |
| b2b-16 | 16 | encrypt | auth_buffer | 0.348 | ≥16.000 | 1.00 | 0% | 98% | - |
| b2b-16 | 16 | encrypt | poly1305 | 1.391 | 4.197 | 3.81 | 24% | 0% | WAIT_CONTEXT (91%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.348 | 1.185 | 13.50 | 27% | 44% | TAG_TAIL (54%) |
| b2b-16 | 16 | encrypt | append_buffer | 0.348 | ≥16.000 | 1.00 | 0% | 98% | - |
| b2b-16 | 16 | encrypt | output_slice | 0.696 | 16.000 | 1.00 | 0% | 96% | - |
| b2b-16 | 16 | decrypt | chacha20 | 0.348 | 8.000 | 2.00 | 2% | 4% | POLY_KEY (94%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.348 | 0.451 | 35.50 | 75% | 0% | AAD_STATE (72%) |
| b2b-16 | 16 | decrypt | auth_buffer | 0.348 | ≥16.000 | 1.00 | 0% | 98% | - |
| b2b-16 | 16 | decrypt | poly1305 | 1.391 | 1.829 | 8.75 | 67% | 0% | WAIT_CONTEXT (91%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.696 | 1.164 | 13.75 | 55% | 19% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.348 | 16.000 | 1.00 | 0% | 98% | WAIT_TO_VERIFY_BIT (98%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 84% | TAKE_CALC_TAG (86%) |
| b2b-64 | 64 | encrypt | chacha20 | 1.326 | 12.190 | 1.31 | 3% | 1% | POLY_KEY (91%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 1.326 | 3.765 | 4.25 | 27% | 0% | IDLE (66%) |
| b2b-64 | 64 | encrypt | auth_buffer | 1.326 | ≥16.000 | 1.00 | 0% | 92% | - |
| b2b-64 | 64 | encrypt | poly1305 | 2.321 | 6.788 | 2.36 | 20% | 0% | WAIT_CONTEXT (85%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 1.326 | 3.606 | 4.44 | 28% | 47% | CIPHERTEXT (55%) |
| b2b-64 | 64 | encrypt | append_buffer | 1.326 | ≥16.000 | 1.00 | 0% | 92% | - |
| b2b-64 | 64 | encrypt | output_slice | 1.658 | 16.000 | 1.00 | 0% | 90% | - |
| b2b-64 | 64 | decrypt | chacha20 | 1.326 | 11.636 | 1.38 | 3% | 4% | POLY_KEY (88%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 1.326 | 1.730 | 9.25 | 68% | 0% | AAD_STATE (65%) |
| b2b-64 | 64 | decrypt | auth_buffer | 1.326 | ≥16.000 | 1.00 | 0% | 92% | - |
| b2b-64 | 64 | decrypt | poly1305 | 2.321 | 3.068 | 5.21 | 61% | 0% | WAIT_CONTEXT (85%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 1.658 | 2.759 | 5.80 | 50% | 20% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 1.326 | 16.000 | 1.00 | 0% | 92% | WAIT_TO_VERIFY_BIT (92%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 82% | TAKE_CALC_TAG (84%) |
| b2b-256 | 256 | encrypt | chacha20 | 4.472 | 14.841 | 1.08 | 2% | 1% | POLY_KEY (71%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 4.472 | 10.667 | 1.50 | 14% | 0% | IDLE (59%) |
| b2b-256 | 256 | encrypt | auth_buffer | 4.472 | ≥16.000 | 1.00 | 0% | 72% | - |
| b2b-256 | 256 | encrypt | poly1305 | 5.310 | 13.075 | 1.22 | 7% | 0% | WAIT_CONTEXT (66%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 4.472 | 9.570 | 1.67 | 19% | 48% | CIPHERTEXT (76%) |
| b2b-256 | 256 | encrypt | append_buffer | 4.472 | ≥16.000 | 1.00 | 0% | 72% | - |
| b2b-256 | 256 | encrypt | output_slice | 4.751 | 16.000 | 1.00 | 0% | 70% | - |
| b2b-256 | 256 | decrypt | chacha20 | 4.472 | 14.629 | 1.09 | 3% | 3% | POLY_KEY (69%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 4.472 | 5.953 | 2.69 | 47% | 0% | AAD_STATE (45%) |
| b2b-256 | 256 | decrypt | auth_buffer | 4.472 | ≥16.000 | 1.00 | 0% | 72% | - |
| b2b-256 | 256 | decrypt | poly1305 | 5.310 | 7.153 | 2.24 | 41% | 0% | WAIT_CONTEXT (67%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 4.751 | 7.771 | 2.06 | 31% | 22% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 4.472 | 16.000 | 1.00 | 0% | 72% | WAIT_TO_VERIFY_BIT (72%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 74% | TAKE_CALC_TAG (76%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 9.752 | 15.634 | 1.02 | 1% | 0% | PLAINTEXT (61%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 9.752 | 14.841 | 1.08 | 5% | 0% | CIPHERTEXT (61%) |
| b2b-1024 | 1024 | encrypt | auth_buffer | 9.752 | ≥16.000 | 1.00 | 0% | 39% | - |
| b2b-1024 | 1024 | encrypt | poly1305 | 10.210 | 15.707 | 1.02 | 1% | 0% | STREAM_BODY (64%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 9.752 | 13.980 | 1.14 | 9% | 29% | CIPHERTEXT (90%) |
| b2b-1024 | 1024 | encrypt | append_buffer | 9.752 | ≥16.000 | 1.00 | 0% | 39% | - |
| b2b-1024 | 1024 | encrypt | output_slice | 9.905 | 16.000 | 1.00 | 0% | 38% | - |
| b2b-1024 | 1024 | decrypt | chacha20 | 9.752 | 15.634 | 1.02 | 1% | 2% | PLAINTEXT (63%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 9.752 | 12.881 | 1.24 | 15% | 0% | CIPHERTEXT (61%) |
| b2b-1024 | 1024 | decrypt | auth_buffer | 9.752 | ≥16.000 | 1.00 | 0% | 39% | - |
| b2b-1024 | 1024 | decrypt | poly1305 | 10.210 | 13.613 | 1.18 | 11% | 0% | STREAM_BODY (64%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 9.905 | 14.964 | 1.07 | 4% | 33% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 9.752 | 16.000 | 1.00 | 0% | 39% | OUTPUT_PLAINTEXT (61%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 63% | TAKE_CALC_TAG (64%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 10.365 | 15.519 | 1.03 | 2% | 1% | PLAINTEXT (66%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 10.365 | 14.987 | 1.06 | 4% | 0% | CIPHERTEXT (65%) |
| b2b-1420 | 1420 | encrypt | auth_buffer | 10.365 | ≥15.955 | 1.00 | 0% | 35% | - |
| b2b-1420 | 1420 | encrypt | poly1305 | 10.745 | 15.660 | 1.02 | 1% | 0% | STREAM_BODY (68%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 10.365 | 14.343 | 1.11 | 7% | 26% | CIPHERTEXT (91%) |
| b2b-1420 | 1420 | encrypt | append_buffer | 10.365 | ≥15.955 | 1.00 | 0% | 35% | - |
| b2b-1420 | 1420 | encrypt | output_slice | 10.482 | 15.956 | 1.00 | 0% | 34% | - |
| b2b-1420 | 1420 | decrypt | chacha20 | 10.365 | 15.604 | 1.02 | 1% | 1% | PLAINTEXT (66%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 10.365 | 13.492 | 1.18 | 12% | 0% | CIPHERTEXT (65%) |
| b2b-1420 | 1420 | decrypt | auth_buffer | 10.365 | ≥15.955 | 1.00 | 0% | 35% | - |
| b2b-1420 | 1420 | decrypt | poly1305 | 10.745 | 14.086 | 1.14 | 9% | 0% | STREAM_BODY (68%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 10.482 | 15.609 | 1.02 | 1% | 33% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 10.365 | 15.955 | 1.00 | 0% | 35% | OUTPUT_PLAINTEXT (65%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 56% | TAKE_CALC_TAG (57%) |
| b2b-1920 | 1920 | encrypt | chacha20 | 10.971 | 15.802 | 1.01 | 1% | 0% | PLAINTEXT (69%) |
| b2b-1920 | 1920 | encrypt | prep_auth_data | 10.971 | 15.360 | 1.04 | 3% | 0% | CIPHERTEXT (69%) |
| b2b-1920 | 1920 | encrypt | auth_buffer | 10.971 | ≥16.000 | 1.00 | 0% | 31% | - |
| b2b-1920 | 1920 | encrypt | poly1305 | 11.246 | 15.839 | 1.01 | 1% | 0% | STREAM_BODY (71%) |
| b2b-1920 | 1920 | encrypt | append_auth_tag | 10.971 | 14.855 | 1.08 | 5% | 25% | CIPHERTEXT (94%) |
| b2b-1920 | 1920 | encrypt | append_buffer | 10.971 | ≥16.000 | 1.00 | 0% | 31% | - |
| b2b-1920 | 1920 | encrypt | output_slice | 11.063 | 16.000 | 1.00 | 0% | 31% | - |
| b2b-1920 | 1920 | decrypt | chacha20 | 10.971 | 15.802 | 1.01 | 1% | 1% | PLAINTEXT (69%) |
| b2b-1920 | 1920 | decrypt | prep_auth_data | 10.971 | 14.170 | 1.13 | 9% | 0% | CIPHERTEXT (69%) |
| b2b-1920 | 1920 | decrypt | auth_buffer | 10.971 | ≥16.000 | 1.00 | 0% | 31% | - |
| b2b-1920 | 1920 | decrypt | poly1305 | 11.246 | 14.605 | 1.10 | 7% | 0% | STREAM_BODY (71%) |
| b2b-1920 | 1920 | decrypt | strip_auth_tag | 11.063 | 15.804 | 1.01 | 1% | 30% | - |
| b2b-1920 | 1920 | decrypt | wait_to_verify | 10.971 | 16.000 | 1.00 | 0% | 31% | OUTPUT_PLAINTEXT (69%) |
| b2b-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 43% | TAKE_AUTH_TAG (55%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 31% of the phase (accept rate 0.066, 15.25 cyc/beat while offered work, ceiling 1.05 B/cyc); its FSM sat in IDLE 67%, AAD_STATE 29% of cycles; next-worst append_auth_tag stalled 27% but was itself starved 44% |
| b2b-16 | 16 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 75% of the phase (accept rate 0.028, 35.50 cyc/beat while offered work, ceiling 0.45 B/cyc); its FSM sat in AAD_STATE 72%, IDLE 24% of cycles; next-worst poly1305 stalled 67% but was itself starved 0% |
| b2b-64 | 64 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 28% of the phase (accept rate 0.225, 4.44 cyc/beat while offered work, ceiling 3.61 B/cyc); its FSM sat in CIPHERTEXT 55%, TAG_TAIL 45% of cycles; next-worst prep_auth_data stalled 27% but was itself starved 0% |
| b2b-64 | 64 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 68% of the phase (accept rate 0.108, 9.25 cyc/beat while offered work, ceiling 1.73 B/cyc); its FSM sat in AAD_STATE 65%, IDLE 24% of cycles; next-worst poly1305 stalled 61% but was itself starved 0% |
| b2b-256 | 256 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 19% of the phase (accept rate 0.598, 1.67 cyc/beat while offered work, ceiling 9.57 B/cyc); its FSM sat in CIPHERTEXT 76%, TAG_TAIL 24% of cycles; next-worst prep_auth_data stalled 14% but was itself starved 0% |
| b2b-256 | 256 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 47% of the phase (accept rate 0.372, 2.69 cyc/beat while offered work, ceiling 5.95 B/cyc); its FSM sat in AAD_STATE 45%, CIPHERTEXT 28% of cycles; next-worst poly1305 stalled 41% but was itself starved 0% |
| b2b-1024 | 1024 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 9% of the phase (accept rate 0.874, 1.14 cyc/beat while offered work, ceiling 13.98 B/cyc); its FSM sat in CIPHERTEXT 90%, TAG_TAIL 10% of cycles; next-worst prep_auth_data stalled 5% but was itself starved 0% |
| b2b-1024 | 1024 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 15% of the phase (accept rate 0.805, 1.24 cyc/beat while offered work, ceiling 12.88 B/cyc); its FSM sat in CIPHERTEXT 61%, IDLE 25% of cycles; next-worst poly1305 stalled 11% but was itself starved 0% |
| b2b-1420 | 1420 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 7% of the phase (accept rate 0.899, 1.11 cyc/beat while offered work, ceiling 14.34 B/cyc); its FSM sat in CIPHERTEXT 91% of cycles; next-worst prep_auth_data stalled 4% but was itself starved 0% |
| b2b-1420 | 1420 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 12% of the phase (accept rate 0.846, 1.18 cyc/beat while offered work, ceiling 13.49 B/cyc); its FSM sat in CIPHERTEXT 65%, IDLE 24% of cycles; next-worst poly1305 stalled 9% but was itself starved 0% |
| b2b-1920 | 1920 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 5% of the phase (accept rate 0.928, 1.08 cyc/beat while offered work, ceiling 14.85 B/cyc); its FSM sat in CIPHERTEXT 94% of cycles; next-worst prep_auth_data stalled 3% but was itself starved 0% |
| b2b-1920 | 1920 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 9% of the phase (accept rate 0.886, 1.13 cyc/beat while offered work, ceiling 14.17 B/cyc); its FSM sat in CIPHERTEXT 69%, IDLE 23% of cycles; next-worst poly1305 stalled 7% but was itself starved 0% |

**Shared-pipeline arbitration** — includes ChaCha20 and each shared Poly1305 MCP separately. *Resource not ready* means the selected request cannot launch (compute busy or output backpressure); *contention* means the other side holds the slot and wants it; *wasted slot* means the other side holds an empty slot. Current request-aware arbiters recover lone requests; historical arbiters may have wasted slots. These waits are not body-pipeline II:

| phase | bytes | resource | dir | wanted (clk) | launched (clk) | resource not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | shared/pipe.arb | encrypt | 12 | 8 | 8% | 25% | 0% |
| b2b-16 | 16 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | encrypt | 24 | 4 | 83% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | decrypt | 26 | 4 | 85% | 0% | 0% |
| b2b-64 | 64 | shared/pipe.arb | encrypt | 9 | 8 | 0% | 11% | 0% |
| b2b-64 | 64 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | encrypt | 24 | 4 | 83% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | decrypt | 26 | 4 | 85% | 0% | 0% |
| b2b-256 | 256 | shared/pipe.arb | encrypt | 21 | 20 | 0% | 5% | 0% |
| b2b-256 | 256 | shared/pipe.arb | decrypt | 22 | 20 | 0% | 9% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | encrypt | 19 | 4 | 79% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | decrypt | 26 | 4 | 85% | 0% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | encrypt | 70 | 68 | 0% | 3% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | decrypt | 70 | 68 | 0% | 3% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | decrypt | 30 | 4 | 87% | 0% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | encrypt | 103 | 96 | 0% | 7% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | decrypt | 104 | 96 | 0% | 8% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | decrypt | 52 | 4 | 92% | 0% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | encrypt | 126 | 124 | 0% | 2% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | decrypt | 126 | 124 | 0% | 2% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | decrypt | 49 | 4 | 92% | 0% | 0% |

**Model cross-check** — Poly1305 block count x its recorded body initiation interval, against the measured packet period. The residual is everything that is not the MAC loop (prologue, body drain, epilogue, poly key round trip, framing, tag stalls, arbitration). This is a body-cost model, not a claim of one-cycle whole-packet service:

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 4 | 3.81 | 22.7 | 18% | 18.7 |
| b2b-16 | 16 | decrypt | 4 | 4 | 8.75 | 31.3 | 13% | 27.3 |
| b2b-64 | 64 | encrypt | 7 | 7 | 2.36 | 22.7 | 31% | 15.7 |
| b2b-64 | 64 | decrypt | 7 | 7 | 5.21 | 32.3 | 22% | 25.3 |
| b2b-256 | 256 | encrypt | 19 | 19 | 1.22 | 24.0 | 79% | 5.0 |
| b2b-256 | 256 | decrypt | 19 | 19 | 2.24 | 36.3 | 52% | 17.3 |
| b2b-1024 | 1024 | encrypt | 67 | 67 | 1.02 | 68.0 | 99% | 1.0 |
| b2b-1024 | 1024 | decrypt | 67 | 67 | 1.18 | 68.0 | 99% | 1.0 |
| b2b-1420 | 1420 | encrypt | 92 | 92 | 1.02 | 94.0 | 98% | 2.0 |
| b2b-1420 | 1420 | decrypt | 92 | 92 | 1.14 | 94.0 | 98% | 2.0 |
| b2b-1920 | 1920 | encrypt | 123 | 123 | 1.01 | 124.0 | 99% | 1.0 |
| b2b-1920 | 1920 | decrypt | 123 | 123 | 1.10 | 124.0 | 99% | 1.0 |

**Poly1305 lifecycle** — measured body service cycles per offered block are separate from FSM cycles per completed packet. Body time includes input gaps; setup includes the prologue handshake; finalization includes the epilogue handshake. Tag stalls are a subset of tag-output cycles, not an additional cost. IDLE/key wait and settle cycles remain in JSON. MCP request waits (total clocks in the window) are subsets of setup/finalization, including sharing contention. These are MAC-local costs, not additive whole-datapath latency:

| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) | drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) | prologue request wait (clk) | epilogue request wait (clk) |
|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | encrypt | 1.00 | 19.00 | 4.00 | 11.00 | 10.00 | 1.00 | 0.00 | 20.00 | 0.00 |
| b2b-16 | decrypt | 1.00 | 19.50 | 4.00 | 11.00 | 10.00 | 1.00 | 0.00 | 22.00 | 0.00 |
| b2b-64 | encrypt | 1.00 | 19.00 | 7.00 | 11.00 | 10.00 | 1.00 | 0.00 | 20.00 | 0.00 |
| b2b-64 | decrypt | 1.00 | 19.50 | 7.00 | 11.00 | 10.00 | 1.00 | 0.00 | 22.00 | 0.00 |
| b2b-256 | encrypt | 1.00 | 17.75 | 19.25 | 11.00 | 10.00 | 1.00 | 0.00 | 15.00 | 0.00 |
| b2b-256 | decrypt | 1.00 | 19.50 | 19.00 | 11.00 | 10.00 | 1.00 | 0.00 | 22.00 | 0.00 |
| b2b-1024 | encrypt | 1.00 | 14.00 | 67.50 | 11.00 | 10.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1024 | decrypt | 1.00 | 20.50 | 67.50 | 11.00 | 10.00 | 1.00 | 0.00 | 26.00 | 0.00 |
| b2b-1420 | encrypt | 1.00 | 14.00 | 92.50 | 11.00 | 10.00 | 2.00 | 1.00 | 0.00 | 0.00 |
| b2b-1420 | decrypt | 1.00 | 26.00 | 92.50 | 11.00 | 10.00 | 1.00 | 0.00 | 48.00 | 0.00 |
| b2b-1920 | encrypt | 1.00 | 14.00 | 123.50 | 11.00 | 10.00 | 1.00 | 0.00 | 0.00 | 0.00 |
| b2b-1920 | decrypt | 1.00 | 25.25 | 123.50 | 11.00 | 10.00 | 1.00 | 0.00 | 45.00 | 0.00 |

Overlapped MAC stage costs run concurrently and must not be summed into a packet period. Drain counts bank clocks; the following counts clocks actually issuing body work during other stages:

| phase | dir | body + setup | body + drain | body + finalization |
|---|---|---|---|---|
| b2b-16 | encrypt | 9 | 0 | 4 |
| b2b-16 | decrypt | 3 | 0 | 0 |
| b2b-64 | encrypt | 18 | 2 | 9 |
| b2b-64 | decrypt | 6 | 0 | 4 |
| b2b-256 | encrypt | 45 | 18 | 29 |
| b2b-256 | decrypt | 26 | 8 | 20 |
| b2b-1024 | encrypt | 42 | 30 | 30 |
| b2b-1024 | decrypt | 56 | 30 | 30 |
| b2b-1420 | encrypt | 39 | 27 | 30 |
| b2b-1420 | decrypt | 75 | 27 | 30 |
| b2b-1920 | encrypt | 42 | 30 | 30 |
| b2b-1920 | decrypt | 75 | 30 | 30 |

**Shared Poly1305 MCP service** — physical-service occupancy, separate from each requester's arbitration wait and private body II. Compute cycles run from accepted launch until a valid response; output stalls are a subset of response-valid cycles, not additional compute time:

| phase | service | requests | responses | compute (clk) | compute (clk/request) | response valid (clk) | response stalls (clk) |
|---|---|---|---|---|---|---|---|
| b2b-16 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-16 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |
| b2b-64 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-64 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |
| b2b-256 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-256 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |
| b2b-1024 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-1024 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |
| b2b-1420 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-1420 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |
| b2b-1920 | prologue | 8 | 8 | 96 | 12.00 | 8 | 0 |
| b2b-1920 | epilogue | 8 | 8 | 64 | 8.00 | 8 | 0 |

**Buffers** (total storage capacity, including any output register):

| phase | buffer | capacity | high water | accepted | retired | simultaneous | end fill |
|---|---|---:|---:|---:|---:|---:|---:|
| b2b-16 | decrypt/auth_fifo.occupancy | 257 | 2 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/verify_fifo.occupancy | 513 | 2 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/append_fifo.occupancy | 257 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/auth_fifo.occupancy | 65 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/output_slice.occupancy | 2 | 1 | 8 | 8 | 3 | 0 |
| b2b-16 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/auth_fifo.occupancy | 257 | 8 | 16 | 16 | 0 | 0 |
| b2b-64 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/verify_fifo.occupancy | 513 | 8 | 16 | 16 | 0 | 0 |
| b2b-64 | encrypt/append_fifo.occupancy | 257 | 4 | 16 | 16 | 9 | 0 |
| b2b-64 | encrypt/auth_fifo.occupancy | 65 | 4 | 16 | 16 | 5 | 0 |
| b2b-64 | encrypt/output_slice.occupancy | 2 | 1 | 20 | 20 | 15 | 0 |
| b2b-64 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/auth_fifo.occupancy | 257 | 32 | 64 | 64 | 2 | 0 |
| b2b-256 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/verify_fifo.occupancy | 513 | 32 | 64 | 64 | 10 | 0 |
| b2b-256 | encrypt/append_fifo.occupancy | 257 | 28 | 64 | 64 | 27 | 0 |
| b2b-256 | encrypt/auth_fifo.occupancy | 65 | 16 | 64 | 64 | 39 | 0 |
| b2b-256 | encrypt/output_slice.occupancy | 2 | 1 | 68 | 68 | 63 | 0 |
| b2b-256 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/auth_fifo.occupancy | 257 | 53 | 256 | 256 | 192 | 0 |
| b2b-1024 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/verify_fifo.occupancy | 513 | 108 | 256 | 256 | 140 | 0 |
| b2b-1024 | encrypt/append_fifo.occupancy | 257 | 36 | 256 | 256 | 215 | 0 |
| b2b-1024 | encrypt/auth_fifo.occupancy | 65 | 17 | 256 | 256 | 234 | 0 |
| b2b-1024 | encrypt/output_slice.occupancy | 2 | 1 | 260 | 260 | 255 | 0 |
| b2b-1024 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/auth_fifo.occupancy | 257 | 58 | 356 | 356 | 289 | 0 |
| b2b-1420 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/verify_fifo.occupancy | 513 | 138 | 356 | 356 | 212 | 0 |
| b2b-1420 | encrypt/append_fifo.occupancy | 257 | 36 | 356 | 356 | 312 | 0 |
| b2b-1420 | encrypt/auth_fifo.occupancy | 65 | 16 | 356 | 356 | 331 | 0 |
| b2b-1420 | encrypt/output_slice.occupancy | 2 | 1 | 360 | 360 | 355 | 0 |
| b2b-1420 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/auth_fifo.occupancy | 257 | 57 | 480 | 480 | 416 | 0 |
| b2b-1920 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/verify_fifo.occupancy | 513 | 168 | 480 | 480 | 308 | 0 |
| b2b-1920 | encrypt/append_fifo.occupancy | 257 | 36 | 480 | 480 | 439 | 0 |
| b2b-1920 | encrypt/auth_fifo.occupancy | 65 | 17 | 480 | 480 | 458 | 0 |
| b2b-1920 | encrypt/output_slice.occupancy | 2 | 1 | 484 | 484 | 479 | 0 |
| b2b-1920 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
