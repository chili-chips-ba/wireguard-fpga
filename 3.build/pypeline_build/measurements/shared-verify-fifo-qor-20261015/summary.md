Design `shared` | target 80.0 MHz | measured fmax **85.54 MHz** | limiting MAIN `poly1305_mcp_shared_poly1305_prologue_shared`
Poly1305 multiplier: `hybrid_square`.
Area (perf_tb_top): **108078 LUT** (106934 logic + 1144 mem), **43955 FF**, **711 DSP48**, **18.5 BRAM tiles**, 19734 CARRY4
Shared resources: `chacha20-poly1305`.
Buffer `decrypt/auth_fifo`: 256 memory beats + 1 output beat; 257 total capacity.
Automatic overlap sizing: 170 required beats (setup_service_and_handoffs=29, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, pipeline_credits=96, widening_storage=5, completion_service_and_handoffs=33); memory rounded to a power of two.
Buffer `decrypt/verify_fifo`: 512 memory beats + 1 output beat; 513 total capacity.
Automatic verification sizing: 307 required beats (setup_service_and_handoffs=29, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, pipeline_credits=96, widening_storage=5, completion_service_and_handoffs=33, held_maximum_packet=127, narrowing_storage=5, verification_handoffs=4, release_handoff=1); memory rounded to a power of two.
Buffer `encrypt/append_fifo`: 256 memory beats + 1 output beat; 257 total capacity.
Automatic overlap sizing: 134 required beats (setup_service_and_handoffs=29, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, authentication_queue=65, completion_service_and_handoffs=33); memory rounded to a power of two.
Buffer `encrypt/auth_fifo`: 64 memory beats + 1 output beat; 65 total capacity.
Automatic overlap sizing: 41 required beats (setup_service_and_handoffs=29, aad_framing=2, framing_idle=1, length_framing=1, fifo_startup=2, fork_copy_lead=1, narrowing_storage=5); memory rounded to a power of two.
Register slice `encrypt/output_slice`: mode `full`, 2 slots, 1 unstalled cycle(s), II=1.
Poly1305 implementation: `pipelined`.
Shared MCP capacity=10 lanes; prologue constraint=12 cycles, epilogue constraint=8 cycles. Each response adds one handshake cycle; arbitration waits are measured separately.
decrypt: body II=1, accumulators=10, body response=10 cycles, prologue response=13 cycles, epilogue response=9 cycles.
decrypt: independent packet stages (prepared=1, contexts=2, completion=1, tags=1); stage costs overlap.
encrypt: body II=1, accumulators=10, body response=10 cycles, prologue response=13 cycles, epilogue response=9 cycles.
encrypt: independent packet stages (prepared=1, contexts=2, completion=1, tags=1); stage costs overlap.

| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | % line rate | Gb/s @fmax | Gb/s @target | in stall | cold head (clk) | total lat med (clk) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | 4 | encrypt | 0.706 | 22.7 | 4.4% | 0.483 | 0.452 | 0.038 | 30 | 101.5 |
| b2b-16 | 16 | 4 | decrypt | 0.511 | 31.3 | 3.2% | 0.349 | 0.327 | 0.580 | 81 | 74.5 |
| b2b-64 | 64 | 4 | encrypt | 2.824 | 22.7 | 17.6% | 1.932 | 1.807 | 0.037 | 33 | 99.0 |
| b2b-64 | 64 | 4 | decrypt | 1.979 | 32.3 | 12.4% | 1.355 | 1.267 | 0.519 | 84 | 80.5 |
| b2b-256 | 256 | 4 | encrypt | 10.667 | 24.0 | 66.7% | 7.300 | 6.827 | 0.033 | 33 | 93.0 |
| b2b-256 | 256 | 4 | decrypt | 7.046 | 36.3 | 44.0% | 4.822 | 4.509 | 0.326 | 96 | 104.5 |
| b2b-1024 | 1024 | 4 | encrypt | 15.059 | 68.0 | 94.1% | 10.305 | 9.638 | 0.018 | 33 | 132.0 |
| b2b-1024 | 1024 | 4 | decrypt | 15.059 | 68.0 | 94.1% | 10.305 | 9.638 | 0.044 | 144 | 203.0 |
| b2b-1420 | 1420 | 4 | encrypt | 15.106 | 94.0 | 94.4% | 10.338 | 9.668 | 0.023 | 33 | 160.5 |
| b2b-1420 | 1420 | 4 | decrypt | 15.106 | 94.0 | 94.4% | 10.338 | 9.668 | 0.015 | 169 | 261.5 |
| b2b-1920 | 1920 | 4 | encrypt | 15.484 | 124.0 | 96.8% | 10.596 | 9.910 | 0.011 | 33 | 188.0 |
| b2b-1920 | 1920 | 4 | decrypt | 15.484 | 124.0 | 96.8% | 10.596 | 9.910 | 0.009 | 200 | 320.5 |
