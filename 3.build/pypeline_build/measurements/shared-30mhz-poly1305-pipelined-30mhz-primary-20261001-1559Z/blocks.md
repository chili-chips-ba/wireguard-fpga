**Headline.** A block that is not relay-limited is quoted at the largest packet size (least per-packet overhead); a relay-limited one (its own output backpressured, so its in-situ ceiling is only a lower bound, marked ≥) is quoted at its best observation across the sweep:

- **encrypt**: ChaCha20 serves **14.14 B/cyc** when fed (@1920 B), Poly1305 **16.00 B/cyc** (@1920 B) — ChaCha20 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 13.65 B/cyc, **97% of ChaCha20's ceiling**.
- **decrypt**: ChaCha20 serves **14.46 B/cyc** when fed (@1920 B), Poly1305 **13.76 B/cyc** (@1920 B) — Poly1305 is the slower block by **1.1x**; at 1920 B the whole datapath delivers 12.15 B/cyc, **88% of Poly1305's ceiling**.

| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) | in stall | in starved | dominant FSM state |
|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | chacha20 | 0.496 | ≥6.400 | 2.50 | 5% | 2% | POLY_KEY (92%) |
| b2b-16 | 16 | encrypt | prep_auth_data | 0.496 | 4.000 | 4.00 | 9% | 0% | IDLE (88%) |
| b2b-16 | 16 | encrypt | poly1305 | 1.984 | 16.000 | 1.00 | 0% | 2% | IDLE (51%) |
| b2b-16 | 16 | encrypt | append_auth_tag | 0.496 | 16.000 | 1.00 | 0% | 69% | CIPHERTEXT (72%) |
| b2b-16 | 16 | decrypt | chacha20 | 0.496 | 5.333 | 3.00 | 6% | 74% | PLAINTEXT (78%) |
| b2b-16 | 16 | decrypt | prep_auth_data | 0.496 | 0.621 | 25.75 | 77% | 0% | AAD_STATE (74%) |
| b2b-16 | 16 | decrypt | poly1305 | 1.984 | 2.485 | 6.44 | 67% | 0% | IDLE (53%) |
| b2b-16 | 16 | decrypt | strip_auth_tag | 0.992 | ≥1.196 | 13.38 | 77% | 17% | - |
| b2b-16 | 16 | decrypt | wait_to_verify | 0.496 | 16.000 | 1.00 | 0% | 97% | WAIT_TO_VERIFY_BIT (62%) |
| b2b-16 | 16 | decrypt | verify | - | 16.000 | 1.00 | 0% | 22% | TAKE_AUTH_TAG (69%) |
| b2b-64 | 64 | encrypt | chacha20 | 1.673 | ≥10.667 | 1.50 | 5% | 8% | POLY_KEY (82%) |
| b2b-64 | 64 | encrypt | prep_auth_data | 1.673 | 9.143 | 1.75 | 8% | 0% | IDLE (82%) |
| b2b-64 | 64 | encrypt | poly1305 | 2.928 | 16.000 | 1.00 | 0% | 4% | IDLE (49%) |
| b2b-64 | 64 | encrypt | append_auth_tag | 1.673 | 16.000 | 1.00 | 0% | 66% | CIPHERTEXT (76%) |
| b2b-64 | 64 | decrypt | chacha20 | 1.673 | 7.314 | 2.19 | 12% | 61% | PLAINTEXT (72%) |
| b2b-64 | 64 | decrypt | prep_auth_data | 1.673 | 2.081 | 7.69 | 70% | 0% | AAD_STATE (67%) |
| b2b-64 | 64 | decrypt | poly1305 | 2.928 | 3.642 | 4.39 | 62% | 0% | IDLE (53%) |
| b2b-64 | 64 | decrypt | strip_auth_tag | 2.092 | ≥2.520 | 6.35 | 70% | 17% | - |
| b2b-64 | 64 | decrypt | wait_to_verify | 1.673 | 16.000 | 1.00 | 0% | 90% | WAIT_TO_VERIFY_BIT (65%) |
| b2b-64 | 64 | decrypt | verify | - | 16.000 | 1.00 | 0% | 18% | TAKE_AUTH_TAG (74%) |
| b2b-256 | 256 | encrypt | chacha20 | 4.923 | 9.062 | 1.77 | 24% | 1% | POLY_KEY (53%) |
| b2b-256 | 256 | encrypt | prep_auth_data | 4.923 | 13.474 | 1.19 | 6% | 1% | IDLE (62%) |
| b2b-256 | 256 | encrypt | poly1305 | 5.846 | 16.000 | 1.00 | 0% | 7% | STREAM_BODY (43%) |
| b2b-256 | 256 | encrypt | append_auth_tag | 4.923 | 16.000 | 1.00 | 0% | 52% | CIPHERTEXT (83%) |
| b2b-256 | 256 | decrypt | chacha20 | 4.923 | 11.770 | 1.36 | 11% | 42% | PLAINTEXT (79%) |
| b2b-256 | 256 | decrypt | prep_auth_data | 4.923 | 6.564 | 2.44 | 44% | 6% | AAD_STATE (42%) |
| b2b-256 | 256 | decrypt | poly1305 | 5.846 | 7.795 | 2.05 | 38% | 6% | STREAM_BODY (43%) |
| b2b-256 | 256 | decrypt | strip_auth_tag | 5.231 | ≥6.289 | 2.54 | 50% | 17% | - |
| b2b-256 | 256 | decrypt | wait_to_verify | 4.923 | 16.000 | 1.00 | 0% | 69% | WAIT_TO_VERIFY_BIT (64%) |
| b2b-256 | 256 | decrypt | verify | - | 16.000 | 1.00 | 0% | 13% | TAKE_AUTH_TAG (81%) |
| b2b-1024 | 1024 | encrypt | chacha20 | 8.715 | 12.921 | 1.24 | 13% | 0% | PLAINTEXT (66%) |
| b2b-1024 | 1024 | encrypt | prep_auth_data | 8.715 | 15.284 | 1.05 | 3% | 3% | CIPHERTEXT (57%) |
| b2b-1024 | 1024 | encrypt | poly1305 | 9.123 | 16.000 | 1.00 | 0% | 5% | STREAM_BODY (62%) |
| b2b-1024 | 1024 | encrypt | append_auth_tag | 8.715 | 16.000 | 1.00 | 0% | 38% | CIPHERTEXT (92%) |
| b2b-1024 | 1024 | decrypt | chacha20 | 8.715 | 13.430 | 1.19 | 10% | 18% | PLAINTEXT (80%) |
| b2b-1024 | 1024 | decrypt | prep_auth_data | 8.715 | 11.770 | 1.36 | 20% | 7% | CIPHERTEXT (62%) |
| b2b-1024 | 1024 | decrypt | poly1305 | 9.123 | 12.322 | 1.30 | 17% | 7% | STREAM_BODY (64%) |
| b2b-1024 | 1024 | decrypt | strip_auth_tag | 8.851 | ≥10.749 | 1.49 | 27% | 18% | - |
| b2b-1024 | 1024 | decrypt | wait_to_verify | 8.715 | 16.000 | 1.00 | 0% | 46% | OUTPUT_PLAINTEXT (54%) |
| b2b-1024 | 1024 | decrypt | verify | - | 16.000 | 1.00 | 0% | 6% | TAKE_AUTH_TAG (91%) |
| b2b-1420 | 1420 | encrypt | chacha20 | 8.903 | 13.786 | 1.16 | 9% | 1% | PLAINTEXT (64%) |
| b2b-1420 | 1420 | encrypt | prep_auth_data | 8.903 | 15.435 | 1.03 | 2% | 1% | CIPHERTEXT (57%) |
| b2b-1420 | 1420 | encrypt | poly1305 | 9.229 | 16.000 | 1.00 | 0% | 2% | STREAM_BODY (60%) |
| b2b-1420 | 1420 | encrypt | append_auth_tag | 8.903 | 15.955 | 1.00 | 0% | 38% | CIPHERTEXT (94%) |
| b2b-1420 | 1420 | decrypt | chacha20 | 8.903 | 12.822 | 1.24 | 14% | 14% | PLAINTEXT (81%) |
| b2b-1420 | 1420 | decrypt | prep_auth_data | 8.903 | 12.539 | 1.27 | 15% | 11% | CIPHERTEXT (67%) |
| b2b-1420 | 1420 | decrypt | poly1305 | 9.229 | 12.998 | 1.23 | 13% | 11% | STREAM_BODY (69%) |
| b2b-1420 | 1420 | decrypt | strip_auth_tag | 9.003 | ≥10.838 | 1.47 | 27% | 17% | - |
| b2b-1420 | 1420 | decrypt | wait_to_verify | 8.903 | 15.955 | 1.00 | 0% | 44% | OUTPUT_PLAINTEXT (56%) |
| b2b-1420 | 1420 | decrypt | verify | - | 16.000 | 1.00 | 0% | 4% | TAKE_AUTH_TAG (94%) |
| b2b-1920 | 1920 | encrypt | chacha20 | 10.213 | 14.144 | 1.13 | 8% | 0% | PLAINTEXT (71%) |
| b2b-1920 | 1920 | encrypt | prep_auth_data | 10.213 | 15.610 | 1.02 | 2% | 2% | CIPHERTEXT (66%) |
| b2b-1920 | 1920 | encrypt | poly1305 | 10.468 | 16.000 | 1.00 | 0% | 3% | STREAM_BODY (68%) |
| b2b-1920 | 1920 | encrypt | append_auth_tag | 10.213 | 16.000 | 1.00 | 0% | 31% | CIPHERTEXT (95%) |
| b2b-1920 | 1920 | decrypt | chacha20 | 10.213 | 14.463 | 1.11 | 7% | 11% | PLAINTEXT (80%) |
| b2b-1920 | 1920 | decrypt | prep_auth_data | 10.213 | 13.427 | 1.19 | 12% | 5% | CIPHERTEXT (69%) |
| b2b-1920 | 1920 | decrypt | poly1305 | 10.468 | 13.762 | 1.16 | 11% | 5% | STREAM_BODY (70%) |
| b2b-1920 | 1920 | decrypt | strip_auth_tag | 10.298 | ≥12.633 | 1.27 | 17% | 18% | - |
| b2b-1920 | 1920 | decrypt | wait_to_verify | 10.213 | 16.000 | 1.00 | 0% | 36% | OUTPUT_PLAINTEXT (64%) |
| b2b-1920 | 1920 | decrypt | verify | - | 16.000 | 1.00 | 0% | 4% | TAKE_AUTH_TAG (95%) |

`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was backpressured at least as hard as its input, so part of its input stall is relayed from downstream rather than its own.

**Bottleneck per phase** (the block whose own service rate limits the direction, after walking past blocks that only relay backpressure):

| phase | bytes | dir | bottleneck | why |
|---|---|---|---|---|
| b2b-16 | 16 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 9% of the phase (accept rate 0.250, 4.00 cyc/beat while offered work, ceiling 4.00 B/cyc); its FSM sat in IDLE 88% of cycles; next-worst chacha20 stalled 5% but was itself starved 2% |
| b2b-16 | 16 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 77% of the phase (accept rate 0.039, 25.75 cyc/beat while offered work, ceiling 0.62 B/cyc); its FSM sat in AAD_STATE 74%, IDLE 20% of cycles; next-worst strip_auth_tag stalled 77% but was itself starved 17% |
| b2b-64 | 64 | encrypt | **prep_auth_data** | prep_auth_data backpressured its producer 8% of the phase (accept rate 0.571, 1.75 cyc/beat while offered work, ceiling 9.14 B/cyc); its FSM sat in IDLE 82%, CIPHERTEXT 10% of cycles; next-worst chacha20 stalled 5% but was itself starved 8% |
| b2b-64 | 64 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 70% of the phase (accept rate 0.130, 7.69 cyc/beat while offered work, ceiling 2.08 B/cyc); its FSM sat in AAD_STATE 67%, IDLE 20% of cycles; next-worst strip_auth_tag stalled 70% but was itself starved 17% |
| b2b-256 | 256 | encrypt | **chacha20** | chacha20 backpressured its producer 24% of the phase (accept rate 0.566, 1.77 cyc/beat while offered work, ceiling 9.06 B/cyc); its FSM sat in POLY_KEY 53%, PLAINTEXT 47% of cycles; next-worst prep_auth_data stalled 6% but was itself starved 1% |
| b2b-256 | 256 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 44% of the phase (accept rate 0.410, 2.44 cyc/beat while offered work, ceiling 6.56 B/cyc); its FSM sat in AAD_STATE 42%, CIPHERTEXT 37% of cycles; next-worst strip_auth_tag stalled 50% but was itself starved 17% |
| b2b-1024 | 1024 | encrypt | **chacha20** | chacha20 backpressured its producer 13% of the phase (accept rate 0.808, 1.24 cyc/beat while offered work, ceiling 12.92 B/cyc); its FSM sat in PLAINTEXT 66%, POLY_KEY 34% of cycles; next-worst prep_auth_data stalled 3% but was itself starved 3% |
| b2b-1024 | 1024 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 20% of the phase (accept rate 0.736, 1.36 cyc/beat while offered work, ceiling 11.77 B/cyc); its FSM sat in CIPHERTEXT 62%, AAD_STATE 19% of cycles; next-worst strip_auth_tag stalled 27% but was itself starved 18% |
| b2b-1420 | 1420 | encrypt | **chacha20** | chacha20 backpressured its producer 9% of the phase (accept rate 0.864, 1.16 cyc/beat while offered work, ceiling 13.79 B/cyc); its FSM sat in PLAINTEXT 64%, POLY_KEY 36% of cycles; next-worst prep_auth_data stalled 2% but was itself starved 1% |
| b2b-1420 | 1420 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 15% of the phase (accept rate 0.786, 1.27 cyc/beat while offered work, ceiling 12.54 B/cyc); its FSM sat in CIPHERTEXT 67%, IDLE 18% of cycles; next-worst strip_auth_tag stalled 27% but was itself starved 17% |
| b2b-1920 | 1920 | encrypt | **chacha20** | chacha20 backpressured its producer 8% of the phase (accept rate 0.884, 1.13 cyc/beat while offered work, ceiling 14.14 B/cyc); its FSM sat in PLAINTEXT 71%, POLY_KEY 29% of cycles; next-worst prep_auth_data stalled 2% but was itself starved 2% |
| b2b-1920 | 1920 | decrypt | **prep_auth_data** | prep_auth_data backpressured its producer 12% of the phase (accept rate 0.839, 1.19 cyc/beat while offered work, ceiling 13.43 B/cyc); its FSM sat in CIPHERTEXT 69%, IDLE 19% of cycles; next-worst strip_auth_tag stalled 17% but was itself starved 18% |

**Shared-pipeline arbitration** — of the cycles a direction wanted to launch into the shared ChaCha20 pipeline: *pipeline not ready* is its own slot with the pipeline unable to accept (a full pipeline — including head-of-line blocking by the OTHER direction's blocks waiting at the shared output), *contention* is the other side holding the slot and wanting it, *wasted slot* is the other side holding the slot with nothing to launch (`is_encrypt` flips every cycle unconditionally; a request-aware arbiter would recover these):

| phase | bytes | dir | wanted (clk) | launched (clk) | pipeline not ready | contention | wasted slot |
|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 16 | 8 | 0% | 0% | 50% |
| b2b-16 | 16 | decrypt | 25 | 8 | 24% | 4% | 40% |
| b2b-64 | 64 | encrypt | 22 | 8 | 23% | 32% | 9% |
| b2b-64 | 64 | decrypt | 27 | 8 | 22% | 26% | 22% |
| b2b-256 | 256 | encrypt | 65 | 20 | 32% | 23% | 14% |
| b2b-256 | 256 | decrypt | 49 | 20 | 22% | 29% | 8% |
| b2b-1024 | 1024 | encrypt | 125 | 68 | 22% | 18% | 6% |
| b2b-1024 | 1024 | decrypt | 123 | 68 | 20% | 20% | 5% |
| b2b-1420 | 1420 | encrypt | 151 | 96 | 16% | 17% | 4% |
| b2b-1420 | 1420 | decrypt | 195 | 96 | 23% | 19% | 9% |
| b2b-1920 | 1920 | encrypt | 183 | 124 | 15% | 13% | 4% |
| b2b-1920 | 1920 | decrypt | 181 | 124 | 14% | 13% | 4% |

**Model cross-check** — Poly1305 block count x its recorded body initiation interval, against the measured packet period. The residual is everything that is not the MAC loop (prologue, body drain, epilogue, poly key round trip, framing, tag stalls, arbitration). This is a body-cost model, not a claim of one-cycle whole-packet service:

| phase | bytes | dir | poly blocks | model (clk) | measured blk period | measured period (clk) | model / measured | residual (clk) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | encrypt | 4 | 4 | 1.00 | 16.0 | 25% | 12.0 |
| b2b-16 | 16 | decrypt | 4 | 4 | 6.44 | 18.0 | 22% | 14.0 |
| b2b-64 | 64 | encrypt | 7 | 7 | 1.00 | 19.3 | 36% | 12.3 |
| b2b-64 | 64 | decrypt | 7 | 7 | 4.39 | 27.3 | 26% | 20.3 |
| b2b-256 | 256 | encrypt | 19 | 19 | 1.00 | 34.0 | 56% | 15.0 |
| b2b-256 | 256 | decrypt | 19 | 19 | 2.05 | 44.3 | 43% | 25.3 |
| b2b-1024 | 1024 | encrypt | 67 | 67 | 1.00 | 84.7 | 79% | 17.7 |
| b2b-1024 | 1024 | decrypt | 67 | 67 | 1.30 | 101.3 | 66% | 34.3 |
| b2b-1420 | 1420 | encrypt | 92 | 92 | 1.00 | 107.3 | 86% | 15.3 |
| b2b-1420 | 1420 | decrypt | 92 | 92 | 1.23 | 135.3 | 68% | 43.3 |
| b2b-1920 | 1920 | encrypt | 123 | 123 | 1.00 | 140.7 | 87% | 17.7 |
| b2b-1920 | 1920 | decrypt | 123 | 123 | 1.16 | 158.0 | 78% | 35.0 |

**Poly1305 lifecycle** — measured body service cycles per offered block are separate from FSM cycles per completed packet. Body time includes input gaps; setup includes the prologue handshake; finalization includes the epilogue handshake. Tag stalls are a subset of tag-output cycles, not an additional cost. IDLE/key wait and settle cycles remain in JSON. These are MAC-local costs, not additive whole-datapath latency:

| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) | drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) |
|---|---|---|---|---|---|---|---|---|
| b2b-16 | encrypt | 1.00 | 3.00 | 4.75 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-16 | decrypt | 1.00 | 3.00 | 4.00 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-64 | encrypt | 1.00 | 3.00 | 8.50 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-64 | decrypt | 1.00 | 3.00 | 7.00 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-256 | encrypt | 1.00 | 3.00 | 22.50 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-256 | decrypt | 1.00 | 3.00 | 22.25 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-1024 | encrypt | 1.00 | 3.00 | 72.50 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-1024 | decrypt | 1.00 | 3.00 | 75.75 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-1420 | encrypt | 1.00 | 3.00 | 95.00 | 3.00 | 4.00 | 2.00 | 1.00 |
| b2b-1420 | decrypt | 1.00 | 3.00 | 110.25 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-1920 | encrypt | 1.00 | 3.00 | 128.50 | 3.00 | 4.00 | 1.00 | 0.00 |
| b2b-1920 | decrypt | 1.00 | 3.00 | 132.25 | 3.00 | 4.00 | 1.00 | 0.00 |
