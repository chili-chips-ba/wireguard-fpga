**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **≥14.22 B/cyc** when fed (@256 B), Poly1305 **2.70 B/cyc** (@1920 B) — Poly1305 is the slower block by at least **5.3x**; at 1920 B the whole datapath delivers 2.53 B/cyc, **94% of Poly1305's ceiling**.
- **decrypt**: ChaCha20 serves **6.83 B/cyc** when fed (@1920 B), Poly1305 **2.16 B/cyc** (@1920 B) — Poly1305 is the slower block by **3.2x**; at 1920 B the whole datapath delivers 1.85 B/cyc, **85% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.252 | ≥6.400 | 2.50 | 2% | 1% | POLY_KEY (96%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.252 | ≥1.143 | 14.00 | 20% | 0% | IDLE (70%) |
| b2b-16 | 16 | encrypt | poly1305 | 1.008 | 3.368 | 4.75 | 24% | 7% | IDLE (52%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.252 | 16.000 | 1.00 | 0% | 76% | CIPHERTEXT (78%) |
| b2b-16 | 16 | decrypt | chacha20 | 0.252 | 5.333 | 3.00 | 3% | 81% | PLAINTEXT (83%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.252 | ≥0.302 | 53.00 | 82% | 0% | AAD_STATE (67%) |
| b2b-16 | 16 | decrypt | poly1305 | 1.008 | 1.180 | 13.56 | 79% | 0% | IDLE (59%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.504 | ≥0.593 | 27.00 | 82% | 15% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.252 | 16.000 | 1.00 | 0% | 98% | WAIT_TO_VERIFY_BIT (55%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 19% | TAKE_AUTH_TAG (76%) |
| b2b-64 | 64 | encrypt | chacha20 | 0.698 | ≥11.130 | 1.44 | 2% | 1% | POLY_KEY (95%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 0.698 | ≥2.000 | 8.00 | 31% | 0% | IDLE (60%) |
| b2b-64 | 64 | encrypt | poly1305 | 1.221 | 3.027 | 5.29 | 33% | 6% | IDLE (46%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 0.698 | 16.000 | 1.00 | 0% | 80% | CIPHERTEXT (85%) |
| b2b-64 | 64 | decrypt | chacha20 | 0.698 | 10.667 | 1.50 | 2% | 83% | PLAINTEXT (87%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 0.698 | ≥0.795 | 20.12 | 83% | 0% | AAD_STATE (56%) |
| b2b-64 | 64 | decrypt | poly1305 | 1.221 | 1.370 | 11.68 | 81% | 0% | IDLE (52%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 0.872 | ≥0.982 | 16.30 | 83% | 11% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 0.698 | 16.000 | 1.00 | 0% | 96% | WAIT_TO_VERIFY_BIT (55%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 13% | TAKE_AUTH_TAG (84%) |
| b2b-256 | 256 | encrypt | chacha20 | 1.161 | ≥14.222 | 1.12 | 1% | 0% | POLY_KEY (93%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 1.161 | ≥2.462 | 6.50 | 40% | 0% | IDLE (51%) |
| b2b-256 | 256 | encrypt | poly1305 | 1.379 | 2.789 | 5.74 | 41% | 2% | FINISH_ITER (52%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 1.161 | 16.000 | 1.00 | 0% | 86% | CIPHERTEXT (94%) |
| b2b-256 | 256 | decrypt | chacha20 | 1.161 | 14.423 | 1.11 | 1% | 88% | PLAINTEXT (95%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 1.161 | ≥1.223 | 13.08 | 88% | 0% | AAD_STATE (49%) |
| b2b-256 | 256 | decrypt | poly1305 | 1.379 | 1.444 | 11.08 | 87% | 0% | FINISH_ITER (52%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 1.234 | ≥1.294 | 12.37 | 88% | 5% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 1.161 | 16.000 | 1.00 | 0% | 93% | WAIT_TO_VERIFY_BIT (55%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 5% | TAKE_AUTH_TAG (93%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 1.786 | ≥3.003 | 5.33 | 48% | 0% | PLAINTEXT (58%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 1.786 | ≥2.629 | 6.09 | 57% | 1% | CIPHERTEXT (68%) |
| b2b-1024 | 1024 | encrypt | poly1305 | 1.870 | 2.717 | 5.89 | 57% | 2% | FINISH_ITER (70%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 1.786 | 16.000 | 1.00 | 0% | 86% | CIPHERTEXT (98%) |
| b2b-1024 | 1024 | decrypt | chacha20 | 1.786 | 6.748 | 2.37 | 15% | 70% | PLAINTEXT (93%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 1.786 | ≥2.046 | 7.82 | 76% | 9% | CIPHERTEXT (76%) |
| b2b-1024 | 1024 | decrypt | poly1305 | 1.870 | 2.137 | 7.49 | 76% | 9% | FINISH_ITER (70%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 1.814 | ≥1.887 | 8.48 | 85% | 4% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 1.786 | 16.000 | 1.00 | 0% | 89% | WAIT_TO_VERIFY_BIT (79%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 2% | TAKE_AUTH_TAG (97%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 1.595 | ≥3.224 | 4.95 | 39% | 1% | POLY_KEY (55%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 1.595 | ≥2.626 | 6.08 | 51% | 0% | CIPHERTEXT (60%) |
| b2b-1420 | 1420 | encrypt | poly1305 | 1.653 | 2.697 | 5.93 | 51% | 1% | FINISH_ITER (62%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 1.595 | 15.955 | 1.00 | 0% | 88% | CIPHERTEXT (98%) |
| b2b-1420 | 1420 | decrypt | chacha20 | 1.595 | 5.000 | 3.19 | 22% | 65% | PLAINTEXT (96%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 1.595 | ≥2.048 | 7.79 | 68% | 19% | CIPHERTEXT (79%) |
| b2b-1420 | 1420 | decrypt | poly1305 | 1.653 | 2.120 | 7.55 | 68% | 19% | FINISH_ITER (62%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 1.613 | ≥1.666 | 9.58 | 87% | 3% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 1.595 | 15.955 | 1.00 | 0% | 90% | WAIT_TO_VERIFY_BIT (81%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 1% | TAKE_AUTH_TAG (98%) |
| peak-1920 | 1920 | encrypt | chacha20 | 1.825 | ≥2.977 | 5.38 | 50% | 0% | PLAINTEXT (61%) |
| peak-1920 | 1920 | encrypt | prep_auth_data | 1.825 | ≥2.652 | 6.03 | 57% | 1% | CIPHERTEXT (69%) |
| peak-1920 | 1920 | encrypt | poly1305 | 1.870 | 2.700 | 5.93 | 58% | 2% | FINISH_ITER (70%) |
| peak-1920 | 1920 | encrypt | append_auth_tag | 1.825 | 16.000 | 1.00 | 0% | 87% | CIPHERTEXT (99%) |
| peak-1920 | 1920 | decrypt | chacha20 | 1.825 | 6.827 | 2.34 | 15% | 70% | PLAINTEXT (94%) |
| peak-1920 | 1920 | decrypt | prep_auth_data | 1.825 | ≥2.112 | 7.58 | 75% | 10% | CIPHERTEXT (78%) |
| peak-1920 | 1920 | decrypt | poly1305 | 1.870 | 2.161 | 7.40 | 75% | 10% | FINISH_ITER (70%) |
| peak-1920 | 1920 | decrypt | strip_auth_tag | 1.840 | ≥1.905 | 8.40 | 85% | 3% | - |
| peak-1920 | 1920 | decrypt | wait_to_verify | 1.825 | 16.000 | 1.00 | 0% | 89% | WAIT_TO_VERIFY_BIT (80%) |
| peak-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 1% | TAKE_AUTH_TAG (99%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **poly1305** | poly1305 backpressured its producer 24% of the phase (accept rate 0.211, 4.75 cyc/beat while offered work, ceiling 3.37 B/cyc); its FSM sat in IDLE 52%, FINISH_ITER 38% of cycles; next-worst prep_auth_data stalled 20% but was itself starved 0% |
| b2b-16 | 16 | decrypt | **poly1305** | poly1305 backpressured its producer 79% of the phase (accept rate 0.074, 13.56 cyc/beat while offered work, ceiling 1.18 B/cyc); its FSM sat in IDLE 59%, FINISH_ITER 38% of cycles; next-worst prep_auth_data stalled 82% but was itself starved 0% |
| b2b-64 | 64 | encrypt | **poly1305** | poly1305 backpressured its producer 33% of the phase (accept rate 0.189, 5.29 cyc/beat while offered work, ceiling 3.03 B/cyc); its FSM sat in IDLE 46%, FINISH_ITER 46% of cycles; next-worst prep_auth_data stalled 31% but was itself starved 0% |
| b2b-64 | 64 | decrypt | **poly1305** | poly1305 backpressured its producer 81% of the phase (accept rate 0.086, 11.68 cyc/beat while offered work, ceiling 1.37 B/cyc); its FSM sat in IDLE 52%, FINISH_ITER 46% of cycles; next-worst prep_auth_data stalled 83% but was itself starved 0% |
| b2b-256 | 256 | encrypt | **poly1305** | poly1305 backpressured its producer 41% of the phase (accept rate 0.174, 5.74 cyc/beat while offered work, ceiling 2.79 B/cyc); its FSM sat in FINISH_ITER 52%, IDLE 45% of cycles; next-worst prep_auth_data stalled 40% but was itself starved 0% |
| b2b-256 | 256 | decrypt | **poly1305** | poly1305 backpressured its producer 87% of the phase (accept rate 0.090, 11.08 cyc/beat while offered work, ceiling 1.44 B/cyc); its FSM sat in FINISH_ITER 52%, IDLE 47% of cycles; next-worst prep_auth_data stalled 88% but was itself starved 0% |
| b2b-1024 | 1024 | encrypt | **poly1305** | poly1305 backpressured its producer 57% of the phase (accept rate 0.170, 5.89 cyc/beat while offered work, ceiling 2.72 B/cyc); its FSM sat in FINISH_ITER 70%, IDLE 27% of cycles; next-worst prep_auth_data stalled 57% but was itself starved 1% |
| b2b-1024 | 1024 | decrypt | **poly1305** | poly1305 backpressured its producer 76% of the phase (accept rate 0.134, 7.49 cyc/beat while offered work, ceiling 2.14 B/cyc); its FSM sat in FINISH_ITER 70%, IDLE 21% of cycles; next-worst strip_auth_tag stalled 85% but was itself starved 4% |
| b2b-1420 | 1420 | encrypt | **poly1305** | poly1305 backpressured its producer 51% of the phase (accept rate 0.169, 5.93 cyc/beat while offered work, ceiling 2.70 B/cyc); its FSM sat in FINISH_ITER 62%, IDLE 37% of cycles; next-worst prep_auth_data stalled 51% but was itself starved 0% |
| b2b-1420 | 1420 | decrypt | **poly1305** | poly1305 backpressured its producer 68% of the phase (accept rate 0.132, 7.55 cyc/beat while offered work, ceiling 2.12 B/cyc); its FSM sat in FINISH_ITER 62%, IDLE 19% of cycles; next-worst strip_auth_tag stalled 87% but was itself starved 3% |
| peak-1920 | 1920 | encrypt | **poly1305** | poly1305 backpressured its producer 58% of the phase (accept rate 0.169, 5.93 cyc/beat while offered work, ceiling 2.70 B/cyc); its FSM sat in FINISH_ITER 70%, IDLE 28% of cycles; next-worst prep_auth_data stalled 57% but was itself starved 1% |
| peak-1920 | 1920 | decrypt | **poly1305** | poly1305 backpressured its producer 75% of the phase (accept rate 0.135, 7.40 cyc/beat while offered work, ceiling 2.16 B/cyc); its FSM sat in FINISH_ITER 70%, IDLE 20% of cycles; next-worst strip_auth_tag stalled 85% but was itself starved 3% |

**Shared-pipeline arbitration** — of the cycles a direction wanted to launch into the shared ChaCha20 pipeline: *pipeline not ready* is its own slot with the pipeline unable to accept (a full pipeline — including head-of-line blocking by the OTHER direction's blocks waiting at the shared output), *contention* is the other side holding the slot and wanting it, *wasted slot* is the other side holding the slot with nothing to launch (`is_encrypt` flips every cycle unconditionally; a request-aware arbiter would recover these):

| phase | bytes | dir | wanted (clk) | launched (clk) | pipeline not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 16 | 8 | 0% | 0% | 50% |
| b2b-16 | 16 | decrypt | 16 | 8 | 0% | 6% | 44% |
| b2b-64 | 64 | encrypt | 11 | 8 | 0% | 0% | 27% |
| b2b-64 | 64 | decrypt | 16 | 8 | 0% | 6% | 44% |
| b2b-256 | 256 | encrypt | 24 | 20 | 0% | 8% | 8% |
| b2b-256 | 256 | decrypt | 35 | 20 | 0% | 3% | 40% |
| b2b-1024 | 1024 | encrypt | 1172 | 68 | 47% | 22% | 25% |
| b2b-1024 | 1024 | decrypt | 598 | 68 | 40% | 42% | 7% |
| b2b-1420 | 1420 | encrypt | 1541 | 96 | 47% | 21% | 27% |
| b2b-1420 | 1420 | decrypt | 1025 | 96 | 43% | 35% | 13% |
| peak-1920 | 1920 | encrypt | 2220 | 124 | 47% | 18% | 30% |
| peak-1920 | 1920 | decrypt | 1026 | 124 | 40% | 39% | 9% |

**Model cross-check** — Poly1305 block count x the MCP's 6-cycle launch-to-launch period, against the measured packet period. The residual is everything that is not the MAC loop (poly key round trip, framing, tag tail, arbitration):

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 24 | 4.75 | 31.0 | 77% | 7.0 |
| b2b-16 | 16 | decrypt | 4 | 24 | 13.56 | 39.7 | 61% | 15.7 |
| b2b-64 | 64 | encrypt | 7 | 42 | 5.29 | 49.0 | 86% | 7.0 |
| b2b-64 | 64 | decrypt | 7 | 42 | 11.68 | 57.7 | 73% | 15.7 |
| b2b-256 | 256 | encrypt | 19 | 114 | 5.74 | 121.0 | 94% | 7.0 |
| b2b-256 | 256 | decrypt | 19 | 114 | 11.08 | 129.3 | 88% | 15.3 |
| b2b-1024 | 1024 | encrypt | 67 | 402 | 5.89 | 418.3 | 96% | 16.3 |
| b2b-1024 | 1024 | decrypt | 67 | 402 | 7.49 | 561.7 | 72% | 159.7 |
| b2b-1420 | 1420 | encrypt | 92 | 552 | 5.93 | 565.7 | 98% | 13.7 |
| b2b-1420 | 1420 | decrypt | 92 | 552 | 7.55 | 857.7 | 64% | 305.7 |
| peak-1920 | 1920 | encrypt | 123 | 738 | 5.93 | 758.3 | 97% | 20.3 |
| peak-1920 | 1920 | decrypt | 123 | 738 | 7.40 | 1040.3 | 71% | 302.3 |
