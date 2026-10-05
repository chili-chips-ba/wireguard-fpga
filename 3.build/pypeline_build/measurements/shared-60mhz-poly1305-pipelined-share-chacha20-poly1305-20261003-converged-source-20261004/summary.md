Design `shared` | target 60.0 MHz | measured fmax **63.03 MHz** | limiting MAIN `chacha20_pipeline_shared`
Area (perf_tb_top): **44442 LUT** (43695 logic + 747 mem), **17935 FF**, **640 DSP48**, **11 BRAM tiles**, 6369 CARRY4
Shared resources: `chacha20-poly1305`.
Poly1305 implementation: `pipelined`.
Shared MCP capacity=5 lanes; prologue constraint=6 cycles, epilogue constraint=5 cycles. Each response adds one handshake cycle; arbitration waits are measured separately.
decrypt: body II=1, accumulators=2, body response=2 cycles, prologue response=7 cycles, epilogue response=6 cycles.
encrypt: body II=1, accumulators=5, body response=5 cycles, prologue response=7 cycles, epilogue response=6 cycles.

| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | % line rate | Gb/s @fmax | Gb/s @target | in stall | cold head (clk) | total lat med (clk) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | 4 | encrypt | 0.593 | 27.0 | 3.7% | 0.299 | 0.284 | 0.023 | 31 | 85.0 |
| b2b-16 | 16 | 4 | decrypt | 0.440 | 36.3 | 2.8% | 0.222 | 0.211 | 0.840 | 109 | 84.0 |
| b2b-64 | 64 | 4 | encrypt | 2.133 | 30.0 | 13.3% | 1.076 | 1.024 | 0.029 | 31 | 87.5 |
| b2b-64 | 64 | 4 | decrypt | 1.627 | 39.3 | 10.2% | 0.820 | 0.781 | 0.792 | 118 | 93.0 |
| b2b-256 | 256 | 4 | encrypt | 6.095 | 42.0 | 38.1% | 3.074 | 2.926 | 0.027 | 31 | 99.5 |
| b2b-256 | 256 | 4 | decrypt | 4.955 | 51.7 | 31.0% | 2.499 | 2.378 | 0.686 | 112 | 117.5 |
| b2b-1024 | 1024 | 4 | encrypt | 11.378 | 90.0 | 71.1% | 5.737 | 5.461 | 0.134 | 31 | 142.5 |
| b2b-1024 | 1024 | 4 | decrypt | 7.837 | 130.7 | 49.0% | 3.952 | 3.762 | 0.413 | 120 | 199.0 |
| b2b-1420 | 1420 | 4 | encrypt | 12.241 | 116.0 | 76.5% | 6.173 | 5.876 | 0.101 | 31 | 169.0 |
| b2b-1420 | 1420 | 4 | decrypt | 8.353 | 170.0 | 52.2% | 4.212 | 4.009 | 0.378 | 145 | 266.5 |
| b2b-1920 | 1920 | 4 | encrypt | 13.151 | 146.0 | 82.2% | 6.631 | 6.312 | 0.108 | 31 | 198.0 |
| b2b-1920 | 1920 | 4 | decrypt | 10.000 | 192.0 | 62.5% | 5.043 | 4.800 | 0.291 | 176 | 316.5 |
