Design `shared` | target 80.0 MHz | measured fmax **81.04 MHz** | limiting MAIN `poly1305_mcp_shared_poly1305_epilogue_shared`
Poly1305 multiplier: `hybrid_square`.
Poly1305 prologue/epilogue: `fsm`.
Area (perf_tb_top): **104668 LUT** (103524 logic + 1144 mem), **93372 FF**, **413 DSP48**, **18.5 BRAM tiles**, 11239 CARRY4
Shared resources: `chacha20-poly1305`.
Buffer `decrypt/auth_fifo`: 512 memory beats + 1 output beat; 513 total capacity.
Automatic overlap sizing: 340 required beats (setup_service_and_handoffs=133, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, pipeline_credits=96, widening_storage=5, completion_service_and_handoffs=99); memory rounded to a power of two.
Buffer `decrypt/verify_fifo`: 512 memory beats + 1 output beat; 513 total capacity.
Automatic verification sizing: 477 required beats (setup_service_and_handoffs=133, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, pipeline_credits=96, widening_storage=5, completion_service_and_handoffs=99, held_maximum_packet=127, narrowing_storage=5, verification_handoffs=4, release_handoff=1); memory rounded to a power of two.
Buffer `encrypt/append_fifo`: 512 memory beats + 1 output beat; 513 total capacity.
Automatic overlap sizing: 496 required beats (setup_service_and_handoffs=133, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, authentication_queue=257, completion_service_and_handoffs=99); memory rounded to a power of two.
Buffer `encrypt/auth_fifo`: 256 memory beats + 1 output beat; 257 total capacity.
Automatic overlap sizing: 145 required beats (setup_service_and_handoffs=133, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, narrowing_storage=5); memory rounded to a power of two.
Register slice `encrypt/output_slice`: mode `full`, 2 slots, 1 unstalled cycle(s), II=1.
Poly1305 implementation: `pipelined`.
Shared compute capacity=10 lanes; prologue compute=64 cycles, epilogue compute=41 cycles. Each response adds one handshake cycle; arbitration waits are measured separately.
decrypt: body II=1, accumulators=10, body response=10 cycles, prologue response=65 cycles, epilogue response=42 cycles.
decrypt: independent packet stages (prepared=1, contexts=2, completion=1, tags=1); stage costs overlap.
encrypt: body II=1, accumulators=10, body response=10 cycles, prologue response=65 cycles, epilogue response=42 cycles.
encrypt: independent packet stages (prepared=1, contexts=2, completion=1, tags=1); stage costs overlap.

| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | % line rate | Gb/s @fmax | Gb/s @target | in stall | cold head (clk) | total lat med (clk) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | 4 | encrypt | 0.146 | 109.3 | 0.9% | 0.095 | 0.094 | 0.010 | 30 | 342.5 |
| b2b-16 | 16 | 4 | decrypt | 0.121 | 132.0 | 0.8% | 0.079 | 0.078 | 0.558 | 218 | 297.0 |
| b2b-64 | 64 | 4 | encrypt | 0.585 | 109.3 | 3.7% | 0.379 | 0.375 | 0.010 | 33 | 340.0 |
| b2b-64 | 64 | 4 | decrypt | 0.485 | 132.0 | 3.0% | 0.314 | 0.310 | 0.543 | 221 | 300.0 |
| b2b-256 | 256 | 4 | encrypt | 2.341 | 109.3 | 14.6% | 1.518 | 1.499 | 0.010 | 33 | 334.0 |
| b2b-256 | 256 | 4 | decrypt | 1.939 | 132.0 | 12.1% | 1.257 | 1.241 | 0.485 | 233 | 312.0 |
| b2b-1024 | 1024 | 4 | encrypt | 9.366 | 109.3 | 58.5% | 6.072 | 5.994 | 0.079 | 33 | 291.0 |
| b2b-1024 | 1024 | 4 | decrypt | 7.758 | 132.0 | 48.5% | 5.029 | 4.965 | 0.293 | 281 | 367.5 |
| b2b-1420 | 1420 | 4 | encrypt | 12.068 | 117.7 | 75.4% | 7.824 | 7.724 | 0.056 | 33 | 292.0 |
| b2b-1420 | 1420 | 4 | decrypt | 10.119 | 140.3 | 63.2% | 6.560 | 6.476 | 0.205 | 306 | 406.0 |
| b2b-1920 | 1920 | 4 | encrypt | 14.257 | 134.7 | 89.1% | 9.243 | 9.125 | 0.010 | 33 | 282.0 |
| b2b-1920 | 1920 | 4 | decrypt | 14.257 | 134.7 | 89.1% | 9.243 | 9.125 | 0.122 | 337 | 424.5 |
