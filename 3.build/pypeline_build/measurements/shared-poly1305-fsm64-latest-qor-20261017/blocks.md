**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **15.77 B/cyc** when fed (@1920 B), Poly1305 **13.55 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.2x**; at 1920 B the whole datapath delivers 14.26 B/cyc, **105% of Poly1305's ceiling**.
- **decrypt**: ChaCha20 serves **15.80 B/cyc** when fed (@1920 B), Poly1305 **11.66 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.4x**; at 1920 B the whole datapath delivers 14.26 B/cyc, **122% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.103 | 7.111 | 2.25 | 1% | 0% | POLY_KEY (99%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.103 | ≥0.199 | 80.25 | 51% | 0% | AAD_STATE (50%) |
| b2b-16 | 16 | encrypt | auth_buffer | 0.103 | ≥16.000 | 1.00 | 0% | 99% | - |
| b2b-16 | 16 | encrypt | poly1305 | 0.411 | 0.798 | 20.06 | 49% | 0% | WAIT_CONTEXT (97%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.103 | 0.571 | 28.00 | 17% | 30% | TAG_TAIL (70%) |
| b2b-16 | 16 | encrypt | append_buffer | 0.103 | ≥16.000 | 1.00 | 0% | 99% | - |
| b2b-16 | 16 | encrypt | output_slice | 0.205 | 16.000 | 1.00 | 0% | 99% | - |
| b2b-16 | 16 | decrypt | chacha20 | 0.103 | 8.000 | 2.00 | 1% | 1% | POLY_KEY (98%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.103 | ≥0.116 | 137.75 | 88% | 0% | AAD_STATE (87%) |
| b2b-16 | 16 | decrypt | auth_buffer | 0.103 | ≥16.000 | 1.00 | 0% | 99% | - |
| b2b-16 | 16 | decrypt | poly1305 | 0.411 | 0.467 | 34.25 | 85% | 0% | WAIT_CONTEXT (97%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.205 | 0.365 | 43.88 | 55% | 12% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.103 | 16.000 | 1.00 | 0% | 99% | WAIT_TO_VERIFY_BIT (99%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 95% | TAKE_CALC_TAG (96%) |
| b2b-64 | 64 | encrypt | chacha20 | 0.407 | 12.190 | 1.31 | 1% | 0% | POLY_KEY (97%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 0.407 | ≥0.780 | 20.50 | 50% | 0% | AAD_STATE (49%) |
| b2b-64 | 64 | encrypt | auth_buffer | 0.407 | ≥16.000 | 1.00 | 0% | 97% | - |
| b2b-64 | 64 | encrypt | poly1305 | 0.712 | 1.374 | 11.64 | 47% | 0% | WAIT_CONTEXT (96%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 0.407 | 1.984 | 8.06 | 18% | 30% | TAG_TAIL (67%) |
| b2b-64 | 64 | encrypt | append_buffer | 0.407 | ≥16.000 | 1.00 | 0% | 97% | - |
| b2b-64 | 64 | encrypt | output_slice | 0.509 | 16.000 | 1.00 | 0% | 97% | - |
| b2b-64 | 64 | decrypt | chacha20 | 0.407 | 11.636 | 1.38 | 1% | 1% | POLY_KEY (96%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 0.407 | ≥0.462 | 34.62 | 86% | 0% | AAD_STATE (84%) |
| b2b-64 | 64 | decrypt | auth_buffer | 0.407 | ≥16.000 | 1.00 | 0% | 97% | - |
| b2b-64 | 64 | decrypt | poly1305 | 0.712 | 0.813 | 19.68 | 83% | 0% | WAIT_CONTEXT (96%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 0.509 | 0.896 | 17.85 | 54% | 13% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 0.407 | 16.000 | 1.00 | 0% | 97% | WAIT_TO_VERIFY_BIT (97%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 94% | TAKE_CALC_TAG (95%) |
| b2b-256 | 256 | encrypt | chacha20 | 1.568 | 14.841 | 1.08 | 1% | 0% | POLY_KEY (90%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 1.568 | ≥2.909 | 5.50 | 44% | 0% | IDLE (46%) |
| b2b-256 | 256 | encrypt | auth_buffer | 1.568 | ≥16.000 | 1.00 | 0% | 90% | - |
| b2b-256 | 256 | encrypt | poly1305 | 1.862 | 3.474 | 4.61 | 42% | 0% | WAIT_CONTEXT (88%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 1.568 | 4.995 | 3.20 | 22% | 30% | TAG_TAIL (61%) |
| b2b-256 | 256 | encrypt | append_buffer | 1.568 | ≥16.000 | 1.00 | 0% | 90% | - |
| b2b-256 | 256 | encrypt | output_slice | 1.666 | 16.000 | 1.00 | 0% | 90% | - |
| b2b-256 | 256 | decrypt | chacha20 | 1.568 | 14.629 | 1.09 | 1% | 1% | POLY_KEY (89%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 1.568 | ≥1.809 | 8.84 | 77% | 0% | AAD_STATE (76%) |
| b2b-256 | 256 | decrypt | auth_buffer | 1.568 | ≥16.000 | 1.00 | 0% | 90% | - |
| b2b-256 | 256 | decrypt | poly1305 | 1.862 | 2.160 | 7.41 | 75% | 0% | WAIT_CONTEXT (88%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 1.666 | 2.856 | 5.60 | 48% | 14% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 1.568 | 16.000 | 1.00 | 0% | 90% | WAIT_TO_VERIFY_BIT (90%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 91% | TAKE_CALC_TAG (92%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 5.469 | 13.699 | 1.17 | 6% | 0% | POLY_KEY (60%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 5.469 | ≥9.143 | 1.75 | 26% | 0% | IDLE (40%) |
| b2b-1024 | 1024 | encrypt | auth_buffer | 5.469 | ≥16.000 | 1.00 | 0% | 66% | - |
| b2b-1024 | 1024 | encrypt | poly1305 | 5.725 | 9.614 | 1.66 | 24% | 0% | WAIT_CONTEXT (64%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 5.469 | 9.309 | 1.72 | 25% | 32% | CIPHERTEXT (66%) |
| b2b-1024 | 1024 | encrypt | append_buffer | 5.469 | ≥16.000 | 1.00 | 0% | 66% | - |
| b2b-1024 | 1024 | encrypt | output_slice | 5.554 | 16.000 | 1.00 | 0% | 65% | - |
| b2b-1024 | 1024 | decrypt | chacha20 | 5.469 | 11.977 | 1.34 | 11% | 1% | POLY_KEY (54%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 5.469 | ≥6.671 | 2.40 | 48% | 0% | AAD_STATE (47%) |
| b2b-1024 | 1024 | decrypt | auth_buffer | 5.469 | ≥16.000 | 1.00 | 0% | 66% | - |
| b2b-1024 | 1024 | decrypt | poly1305 | 5.725 | 7.018 | 2.28 | 46% | 0% | WAIT_CONTEXT (64%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 5.554 | 8.721 | 1.83 | 29% | 19% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 5.469 | 16.000 | 1.00 | 0% | 66% | WAIT_TO_VERIFY_BIT (66%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 79% | TAKE_CALC_TAG (80%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 6.893 | 14.602 | 1.09 | 4% | 1% | POLY_KEY (53%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 6.893 | 11.315 | 1.41 | 18% | 0% | CIPHERTEXT (43%) |
| b2b-1420 | 1420 | encrypt | auth_buffer | 6.893 | ≥15.955 | 1.00 | 0% | 57% | - |
| b2b-1420 | 1420 | encrypt | poly1305 | 7.146 | 11.800 | 1.36 | 16% | 0% | WAIT_CONTEXT (55%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 6.893 | 11.008 | 1.45 | 19% | 32% | CIPHERTEXT (75%) |
| b2b-1420 | 1420 | encrypt | append_buffer | 6.893 | ≥15.955 | 1.00 | 0% | 57% | - |
| b2b-1420 | 1420 | encrypt | output_slice | 6.971 | 15.956 | 1.00 | 0% | 56% | - |
| b2b-1420 | 1420 | decrypt | chacha20 | 6.893 | 14.715 | 1.08 | 4% | 1% | POLY_KEY (53%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 6.893 | ≥8.554 | 1.87 | 37% | 0% | CIPHERTEXT (43%) |
| b2b-1420 | 1420 | decrypt | auth_buffer | 6.893 | ≥15.955 | 1.00 | 0% | 57% | - |
| b2b-1420 | 1420 | decrypt | poly1305 | 7.146 | 8.908 | 1.80 | 36% | 0% | WAIT_CONTEXT (55%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 6.971 | 10.899 | 1.46 | 20% | 23% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 6.893 | 15.955 | 1.00 | 0% | 57% | WAIT_TO_VERIFY_BIT (57%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 75% | TAKE_CALC_TAG (76%) |
| b2b-1920 | 1920 | encrypt | chacha20 | 8.838 | 15.770 | 1.01 | 1% | 0% | PLAINTEXT (56%) |
| b2b-1920 | 1920 | encrypt | prep_auth_data | 8.838 | 13.151 | 1.22 | 12% | 0% | CIPHERTEXT (55%) |
| b2b-1920 | 1920 | encrypt | auth_buffer | 8.838 | ≥16.000 | 1.00 | 0% | 45% | - |
| b2b-1920 | 1920 | encrypt | poly1305 | 9.059 | 13.549 | 1.18 | 10% | 0% | STREAM_BODY (57%) |
| b2b-1920 | 1920 | encrypt | append_auth_tag | 8.838 | 12.632 | 1.27 | 15% | 26% | CIPHERTEXT (82%) |
| b2b-1920 | 1920 | encrypt | append_buffer | 8.838 | ≥16.000 | 1.00 | 0% | 45% | - |
| b2b-1920 | 1920 | encrypt | output_slice | 8.911 | 16.000 | 1.00 | 0% | 44% | - |
| b2b-1920 | 1920 | decrypt | chacha20 | 8.838 | 15.802 | 1.01 | 1% | 1% | PLAINTEXT (56%) |
| b2b-1920 | 1920 | decrypt | prep_auth_data | 8.838 | ≥11.327 | 1.41 | 23% | 0% | CIPHERTEXT (55%) |
| b2b-1920 | 1920 | decrypt | auth_buffer | 8.838 | ≥16.000 | 1.00 | 0% | 45% | - |
| b2b-1920 | 1920 | decrypt | poly1305 | 9.059 | 11.662 | 1.37 | 21% | 0% | STREAM_BODY (57%) |
| b2b-1920 | 1920 | decrypt | strip_auth_tag | 8.911 | 13.148 | 1.22 | 12% | 30% | - |
| b2b-1920 | 1920 | decrypt | wait_to_verify | 8.838 | 16.000 | 1.00 | 0% | 45% | OUTPUT_PLAINTEXT (55%) |
| b2b-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 69% | TAKE_CALC_TAG (70%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **poly1305** | poly1305 backpressured its producer 49% of the phase (accept rate 0.050, 20.06 cyc/beat while offered work, ceiling 0.80 B/cyc); its FSM sat in WAIT_CONTEXT 97% of cycles; next-worst prep_auth_data stalled 51% but was itself starved 0% |
| b2b-16 | 16 | decrypt | **poly1305** | poly1305 backpressured its producer 85% of the phase (accept rate 0.029, 34.25 cyc/beat while offered work, ceiling 0.47 B/cyc); its FSM sat in WAIT_CONTEXT 97% of cycles; next-worst prep_auth_data stalled 88% but was itself starved 0% |
| b2b-64 | 64 | encrypt | **poly1305** | poly1305 backpressured its producer 47% of the phase (accept rate 0.086, 11.64 cyc/beat while offered work, ceiling 1.37 B/cyc); its FSM sat in WAIT_CONTEXT 96% of cycles; next-worst prep_auth_data stalled 50% but was itself starved 0% |
| b2b-64 | 64 | decrypt | **poly1305** | poly1305 backpressured its producer 83% of the phase (accept rate 0.051, 19.68 cyc/beat while offered work, ceiling 0.81 B/cyc); its FSM sat in WAIT_CONTEXT 96% of cycles; next-worst prep_auth_data stalled 86% but was itself starved 0% |
| b2b-256 | 256 | encrypt | **poly1305** | poly1305 backpressured its producer 42% of the phase (accept rate 0.217, 4.61 cyc/beat while offered work, ceiling 3.47 B/cyc); its FSM sat in WAIT_CONTEXT 88%, STREAM_BODY 12% of cycles; next-worst prep_auth_data stalled 44% but was itself starved 0% |
| b2b-256 | 256 | decrypt | **poly1305** | poly1305 backpressured its producer 75% of the phase (accept rate 0.135, 7.41 cyc/beat while offered work, ceiling 2.16 B/cyc); its FSM sat in WAIT_CONTEXT 88%, STREAM_BODY 12% of cycles; next-worst prep_auth_data stalled 77% but was itself starved 0% |
| b2b-1024 | 1024 | encrypt | **poly1305** | poly1305 backpressured its producer 24% of the phase (accept rate 0.601, 1.66 cyc/beat while offered work, ceiling 9.61 B/cyc); its FSM sat in WAIT_CONTEXT 64%, STREAM_BODY 36% of cycles; next-worst prep_auth_data stalled 26% but was itself starved 0% |
| b2b-1024 | 1024 | decrypt | **poly1305** | poly1305 backpressured its producer 46% of the phase (accept rate 0.439, 2.28 cyc/beat while offered work, ceiling 7.02 B/cyc); its FSM sat in WAIT_CONTEXT 64%, STREAM_BODY 36% of cycles; next-worst prep_auth_data stalled 48% but was itself starved 0% |
| b2b-1420 | 1420 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 19% of the phase (accept rate 0.690, 1.45 cyc/beat while offered work, ceiling 11.01 B/cyc); its FSM sat in CIPHERTEXT 75%, MERGED_WORD 24% of cycles; next-worst prep_auth_data stalled 18% but was itself starved 0% |
| b2b-1420 | 1420 | decrypt | **poly1305** | poly1305 backpressured its producer 36% of the phase (accept rate 0.557, 1.80 cyc/beat while offered work, ceiling 8.91 B/cyc); its FSM sat in WAIT_CONTEXT 55%, STREAM_BODY 45% of cycles; next-worst prep_auth_data stalled 37% but was itself starved 0% |
| b2b-1920 | 1920 | encrypt | **append_auth_tag** | append_auth_tag backpressured its producer 15% of the phase (accept rate 0.789, 1.27 cyc/beat while offered work, ceiling 12.63 B/cyc); its FSM sat in CIPHERTEXT 82%, TAG_TAIL 18% of cycles; next-worst prep_auth_data stalled 12% but was itself starved 0% |
| b2b-1920 | 1920 | decrypt | **poly1305** | poly1305 backpressured its producer 21% of the phase (accept rate 0.729, 1.37 cyc/beat while offered work, ceiling 11.66 B/cyc); its FSM sat in STREAM_BODY 57%, WAIT_CONTEXT 43% of cycles; next-worst prep_auth_data stalled 23% but was itself starved 0% |

**Shared-pipeline arbitration** — includes ChaCha20 and each shared Poly1305 compute separately. *Resource not ready* means the selected request cannot launch (compute busy or output backpressure); *contention* means the other side holds the slot and wants it; *wasted slot* means the other side holds an empty slot. Current request-aware arbiters recover lone requests; historical arbiters may have wasted slots. These waits are not body-pipeline II:

| phase | bytes | resource | dir | wanted (clk) | launched (clk) | resource not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | shared/pipe.arb | encrypt | 12 | 8 | 8% | 25% | 0% |
| b2b-16 | 16 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | encrypt | 128 | 4 | 97% | 0% | 0% |
| b2b-16 | 16 | shared/poly1305.prologue.arb | decrypt | 193 | 4 | 98% | 0% | 0% |
| b2b-64 | 64 | shared/pipe.arb | encrypt | 9 | 8 | 0% | 11% | 0% |
| b2b-64 | 64 | shared/pipe.arb | decrypt | 10 | 8 | 0% | 20% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | encrypt | 128 | 4 | 97% | 0% | 0% |
| b2b-64 | 64 | shared/poly1305.prologue.arb | decrypt | 193 | 4 | 98% | 0% | 0% |
| b2b-256 | 256 | shared/pipe.arb | encrypt | 21 | 20 | 0% | 5% | 0% |
| b2b-256 | 256 | shared/pipe.arb | decrypt | 22 | 20 | 0% | 9% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | encrypt | 128 | 4 | 97% | 0% | 0% |
| b2b-256 | 256 | shared/poly1305.prologue.arb | decrypt | 181 | 4 | 98% | 0% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | encrypt | 107 | 68 | 0% | 36% | 0% |
| b2b-1024 | 1024 | shared/pipe.arb | decrypt | 151 | 68 | 54% | 1% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | encrypt | 128 | 4 | 97% | 0% | 0% |
| b2b-1024 | 1024 | shared/poly1305.prologue.arb | decrypt | 153 | 4 | 97% | 0% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | encrypt | 128 | 96 | 12% | 13% | 0% |
| b2b-1420 | 1420 | shared/pipe.arb | decrypt | 127 | 96 | 15% | 9% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.epilogue.arb | decrypt | 6 | 4 | 33% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | encrypt | 75 | 4 | 95% | 0% | 0% |
| b2b-1420 | 1420 | shared/poly1305.prologue.arb | decrypt | 181 | 4 | 98% | 0% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | encrypt | 127 | 124 | 0% | 2% | 0% |
| b2b-1920 | 1920 | shared/pipe.arb | decrypt | 126 | 124 | 0% | 2% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | encrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.epilogue.arb | decrypt | 4 | 4 | 0% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | encrypt | 51 | 4 | 92% | 0% | 0% |
| b2b-1920 | 1920 | shared/poly1305.prologue.arb | decrypt | 130 | 4 | 97% | 0% | 0% |

**Model cross-check** — Poly1305 block count x its recorded body initiation interval, against the measured packet period. The residual is everything that is not the MAC loop (prologue, body drain, epilogue, poly key round trip, framing, tag stalls, arbitration). This is a body-cost model, not a claim of one-cycle whole-packet service:

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 4 | 20.06 | 109.3 | 4% | 105.3 |
| b2b-16 | 16 | decrypt | 4 | 4 | 34.25 | 132.0 | 3% | 128.0 |
| b2b-64 | 64 | encrypt | 7 | 7 | 11.64 | 109.3 | 6% | 102.3 |
| b2b-64 | 64 | decrypt | 7 | 7 | 19.68 | 132.0 | 5% | 125.0 |
| b2b-256 | 256 | encrypt | 19 | 19 | 4.61 | 109.3 | 17% | 90.3 |
| b2b-256 | 256 | decrypt | 19 | 19 | 7.41 | 132.0 | 14% | 113.0 |
| b2b-1024 | 1024 | encrypt | 67 | 67 | 1.66 | 109.3 | 61% | 42.3 |
| b2b-1024 | 1024 | decrypt | 67 | 67 | 2.28 | 132.0 | 51% | 65.0 |
| b2b-1420 | 1420 | encrypt | 92 | 92 | 1.36 | 117.7 | 78% | 25.7 |
| b2b-1420 | 1420 | decrypt | 92 | 92 | 1.80 | 140.3 | 66% | 48.3 |
| b2b-1920 | 1920 | encrypt | 123 | 123 | 1.18 | 134.7 | 91% | 11.7 |
| b2b-1920 | 1920 | decrypt | 123 | 123 | 1.37 | 134.7 | 91% | 11.7 |

**Poly1305 lifecycle** — measured body service cycles per offered block are separate from FSM cycles per completed packet. Body time includes input gaps; setup includes the prologue handshake; finalization includes the epilogue handshake. Tag stalls are a subset of tag-output cycles, not an additional cost. IDLE/key wait and settle cycles remain in JSON. Compute request waits (total clocks in the window) are subsets of setup/finalization, including sharing contention. These are MAC-local costs, not additive whole-datapath latency:

| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) | drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) | prologue request wait (clk) | epilogue request wait (clk) |
|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | encrypt | 1.00 | 97.00 | 4.00 | 11.00 | 43.00 | 1.00 | 0.00 | 124.00 | 0.00 |
| b2b-16 | decrypt | 1.00 | 113.25 | 4.00 | 11.00 | 43.00 | 1.00 | 0.00 | 189.00 | 0.00 |
| b2b-64 | encrypt | 1.00 | 97.00 | 7.00 | 11.00 | 43.00 | 1.00 | 0.00 | 124.00 | 0.00 |
| b2b-64 | decrypt | 1.00 | 113.25 | 7.00 | 11.00 | 43.00 | 1.00 | 0.00 | 189.00 | 0.00 |
| b2b-256 | encrypt | 1.00 | 97.00 | 19.00 | 11.00 | 43.00 | 1.00 | 0.00 | 124.00 | 0.00 |
| b2b-256 | decrypt | 1.00 | 110.25 | 19.00 | 11.00 | 43.00 | 1.00 | 0.00 | 177.00 | 0.00 |
| b2b-1024 | encrypt | 1.00 | 97.00 | 67.00 | 11.00 | 43.00 | 1.00 | 0.00 | 124.00 | 0.00 |
| b2b-1024 | decrypt | 1.00 | 103.25 | 67.00 | 11.00 | 43.00 | 1.00 | 0.00 | 149.00 | 0.00 |
| b2b-1420 | encrypt | 1.00 | 83.75 | 92.25 | 11.00 | 43.00 | 2.00 | 1.00 | 71.00 | 0.00 |
| b2b-1420 | decrypt | 1.00 | 110.25 | 92.25 | 11.00 | 43.50 | 1.00 | 0.00 | 177.00 | 2.00 |
| b2b-1920 | encrypt | 1.00 | 77.75 | 123.00 | 11.00 | 43.00 | 1.00 | 0.00 | 47.00 | 0.00 |
| b2b-1920 | decrypt | 1.00 | 97.50 | 123.00 | 11.00 | 43.00 | 1.00 | 0.00 | 126.00 | 0.00 |

Overlapped MAC stage costs run concurrently and must not be summed into a packet period. Drain counts bank clocks; the following counts clocks actually issuing body work during other stages:

| phase | dir | body + setup | body + drain | body + finalization |
|---|---|---|---|---|
| b2b-16 | encrypt | 9 | 0 | 0 |
| b2b-16 | decrypt | 6 | 0 | 0 |
| b2b-64 | encrypt | 18 | 0 | 0 |
| b2b-64 | decrypt | 12 | 0 | 0 |
| b2b-256 | encrypt | 54 | 0 | 5 |
| b2b-256 | decrypt | 36 | 0 | 5 |
| b2b-1024 | encrypt | 198 | 10 | 43 |
| b2b-1024 | decrypt | 132 | 10 | 43 |
| b2b-1420 | encrypt | 195 | 10 | 75 |
| b2b-1420 | decrypt | 169 | 10 | 61 |
| b2b-1920 | encrypt | 213 | 8 | 119 |
| b2b-1920 | decrypt | 228 | 8 | 119 |

**Shared Poly1305 compute service** — physical-service occupancy, separate from each requester's arbitration wait and private body II. Compute cycles run from accepted launch until a valid response; output stalls are a subset of response-valid cycles, not additional compute time:

| phase | service | requests | responses | compute (clk) | compute (clk/request) | response valid (clk) | response stalls (clk) |
|---|---|---|---|---|---|---|---|
| b2b-16 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-16 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |
| b2b-64 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-64 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |
| b2b-256 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-256 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |
| b2b-1024 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-1024 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |
| b2b-1420 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-1420 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |
| b2b-1920 | prologue | 8 | 8 | 512 | 64.00 | 8 | 0 |
| b2b-1920 | epilogue | 8 | 8 | 328 | 41.00 | 8 | 0 |

**Buffers** (total storage capacity, including any output register):

| phase | buffer | capacity | high water | accepted | retired | simultaneous | end fill |
|---|---|---:|---:|---:|---:|---:|---:|
| b2b-16 | decrypt/auth_fifo.occupancy | 513 | 2 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | decrypt/verify_fifo.occupancy | 513 | 2 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/append_fifo.occupancy | 513 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/auth_fifo.occupancy | 257 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/output_slice.occupancy | 2 | 1 | 8 | 8 | 2 | 0 |
| b2b-16 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-16 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/auth_fifo.occupancy | 513 | 8 | 16 | 16 | 0 | 0 |
| b2b-64 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | decrypt/verify_fifo.occupancy | 513 | 8 | 16 | 16 | 0 | 0 |
| b2b-64 | encrypt/append_fifo.occupancy | 513 | 4 | 16 | 16 | 4 | 0 |
| b2b-64 | encrypt/auth_fifo.occupancy | 257 | 4 | 16 | 16 | 5 | 0 |
| b2b-64 | encrypt/output_slice.occupancy | 2 | 1 | 20 | 20 | 14 | 0 |
| b2b-64 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-64 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/auth_fifo.occupancy | 513 | 32 | 64 | 64 | 0 | 0 |
| b2b-256 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | decrypt/verify_fifo.occupancy | 513 | 32 | 64 | 64 | 10 | 0 |
| b2b-256 | encrypt/append_fifo.occupancy | 513 | 16 | 64 | 64 | 24 | 0 |
| b2b-256 | encrypt/auth_fifo.occupancy | 257 | 16 | 64 | 64 | 29 | 0 |
| b2b-256 | encrypt/output_slice.occupancy | 2 | 1 | 68 | 68 | 63 | 0 |
| b2b-256 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.contexts.occupancy | 2 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-256 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/auth_fifo.occupancy | 513 | 128 | 256 | 256 | 37 | 0 |
| b2b-1024 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | decrypt/verify_fifo.occupancy | 513 | 128 | 256 | 256 | 53 | 0 |
| b2b-1024 | encrypt/append_fifo.occupancy | 513 | 64 | 256 | 256 | 177 | 0 |
| b2b-1024 | encrypt/auth_fifo.occupancy | 257 | 64 | 256 | 256 | 127 | 0 |
| b2b-1024 | encrypt/output_slice.occupancy | 2 | 1 | 260 | 260 | 255 | 0 |
| b2b-1024 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1024 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/auth_fifo.occupancy | 513 | 139 | 356 | 356 | 139 | 0 |
| b2b-1420 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | decrypt/verify_fifo.occupancy | 513 | 178 | 356 | 356 | 85 | 0 |
| b2b-1420 | encrypt/append_fifo.occupancy | 513 | 104 | 356 | 356 | 244 | 0 |
| b2b-1420 | encrypt/auth_fifo.occupancy | 257 | 89 | 356 | 356 | 221 | 0 |
| b2b-1420 | encrypt/output_slice.occupancy | 2 | 1 | 360 | 360 | 355 | 0 |
| b2b-1420 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1420 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/auth_fifo.occupancy | 513 | 153 | 480 | 480 | 293 | 0 |
| b2b-1920 | decrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | decrypt/verify_fifo.occupancy | 513 | 240 | 480 | 480 | 206 | 0 |
| b2b-1920 | encrypt/append_fifo.occupancy | 513 | 120 | 480 | 480 | 356 | 0 |
| b2b-1920 | encrypt/auth_fifo.occupancy | 257 | 96 | 480 | 480 | 374 | 0 |
| b2b-1920 | encrypt/output_slice.occupancy | 2 | 1 | 484 | 484 | 479 | 0 |
| b2b-1920 | encrypt/poly1305.completion.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.contexts.occupancy | 2 | 2 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.prepared.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
| b2b-1920 | encrypt/poly1305.tags.occupancy | 1 | 1 | 4 | 4 | 0 | 0 |
