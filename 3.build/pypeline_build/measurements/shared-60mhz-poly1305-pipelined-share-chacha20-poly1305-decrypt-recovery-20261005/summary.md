Design `shared` | target 60.0 MHz | measured fmax **63.03 MHz** | limiting MAIN `chacha20_pipeline_shared`
Area (perf_tb_top): **48497 LUT** (47749 logic + 748 mem), **20540 FF**, **704 DSP48**, **13.5 BRAM tiles**, 6752 CARRY4
Shared resources: `chacha20-poly1305`.
Buffer `decrypt/auth_fifo`: 64 memory beats + 1 output beat; 65 total capacity.
Register slice `encrypt/output_slice`: mode `full`, 2 slots, 1 unstalled cycle(s), II=1.
Poly1305 implementation: `pipelined`.
Shared MCP capacity=5 lanes; prologue constraint=6 cycles, epilogue constraint=5 cycles. Each response adds one handshake cycle; arbitration waits are measured separately.
decrypt: body II=1, accumulators=5, body response=5 cycles, prologue response=7 cycles, epilogue response=6 cycles.
encrypt: body II=1, accumulators=5, body response=5 cycles, prologue response=7 cycles, epilogue response=6 cycles.

| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | % line rate | Gb/s @fmax | Gb/s @target | in stall | cold head (clk) | total lat med (clk) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | 4 | encrypt | 0.578 | 27.7 | 3.6% | 0.292 | 0.278 | 0.038 | 32 | 88.0 |
| b2b-16 | 16 | 4 | decrypt | 0.436 | 36.7 | 2.7% | 0.220 | 0.209 | 0.479 | 58 | 82.0 |
| b2b-64 | 64 | 4 | encrypt | 2.087 | 30.7 | 13.0% | 1.052 | 1.002 | 0.035 | 32 | 90.0 |
| b2b-64 | 64 | 4 | decrypt | 1.574 | 40.7 | 9.8% | 0.794 | 0.755 | 0.417 | 61 | 91.0 |
| b2b-256 | 256 | 4 | encrypt | 6.000 | 42.7 | 37.5% | 3.026 | 2.880 | 0.026 | 32 | 102.0 |
| b2b-256 | 256 | 4 | decrypt | 4.151 | 61.7 | 25.9% | 2.093 | 1.993 | 0.241 | 73 | 134.5 |
| b2b-1024 | 1024 | 4 | encrypt | 11.212 | 91.3 | 70.1% | 5.654 | 5.382 | 0.166 | 32 | 147.0 |
| b2b-1024 | 1024 | 4 | decrypt | 11.253 | 91.0 | 70.3% | 5.674 | 5.401 | 0.135 | 121 | 217.0 |
| b2b-1420 | 1420 | 4 | encrypt | 12.171 | 116.7 | 76.1% | 6.138 | 5.842 | 0.133 | 32 | 173.0 |
| b2b-1420 | 1420 | 4 | decrypt | 12.206 | 116.3 | 76.3% | 6.155 | 5.859 | 0.108 | 146 | 267.5 |
| b2b-1920 | 1920 | 4 | encrypt | 13.032 | 147.3 | 81.4% | 6.571 | 6.255 | 0.105 | 32 | 203.0 |
| b2b-1920 | 1920 | 4 | decrypt | 13.061 | 147.0 | 81.6% | 6.586 | 6.269 | 0.084 | 177 | 329.0 |
