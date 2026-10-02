Design `shared` | target 30.0 MHz | measured fmax **30.07 MHz** | limiting MAIN `chacha20_pipeline_shared`
Area (perf_tb_top): **33778 LUT** (33642 logic + 136 mem), **9877 FF**, **448 DSP48**, **11 BRAM tiles**, 5193 CARRY4
DUT-only area (external key/data ports): **42617 LUT**, **12934 FF**, **512 DSP48**, **11 BRAM tiles**.
Hardware-top timing: PASS, 30.05 MHz against 30.0 MHz.
Poly1305 implementation: `pipelined`.
decrypt: body II=1, accumulators=2, body response=2 cycles, prologue response=2 cycles, epilogue response=3 cycles.
encrypt: body II=1, accumulators=2, body response=2 cycles, prologue response=2 cycles, epilogue response=3 cycles.

| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | % line rate | Gb/s @fmax | Gb/s @target | in stall | cold head (clk) | total lat med (clk) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| b2b-16 | 16 | 4 | encrypt | 1.000 | 16.0 | 6.2% | 0.241 | 0.240 | 0.081 | 16 | 47.0 |
| b2b-16 | 16 | 4 | decrypt | 0.889 | 18.0 | 5.6% | 0.214 | 0.213 | 0.818 | 66 | 49.0 |
| b2b-64 | 64 | 4 | encrypt | 3.310 | 19.3 | 20.7% | 0.796 | 0.794 | 0.090 | 18 | 51.5 |
| b2b-64 | 64 | 4 | decrypt | 2.341 | 27.3 | 14.6% | 0.563 | 0.562 | 0.738 | 59 | 50.5 |
| b2b-256 | 256 | 4 | encrypt | 7.529 | 34.0 | 47.1% | 1.811 | 1.807 | 0.338 | 18 | 59.5 |
| b2b-256 | 256 | 4 | decrypt | 5.774 | 44.3 | 36.1% | 1.389 | 1.386 | 0.525 | 50 | 70.0 |
| b2b-1024 | 1024 | 4 | encrypt | 12.094 | 84.7 | 75.6% | 2.909 | 2.903 | 0.177 | 18 | 109.0 |
| b2b-1024 | 1024 | 4 | decrypt | 10.105 | 101.3 | 63.2% | 2.431 | 2.425 | 0.275 | 94 | 171.0 |
| b2b-1420 | 1420 | 4 | encrypt | 13.230 | 107.3 | 82.7% | 3.182 | 3.175 | 0.128 | 18 | 133.0 |
| b2b-1420 | 1420 | 4 | decrypt | 10.493 | 135.3 | 65.6% | 2.524 | 2.518 | 0.270 | 135 | 227.0 |
| b2b-1920 | 1920 | 4 | encrypt | 13.649 | 140.7 | 85.3% | 3.283 | 3.276 | 0.111 | 18 | 165.0 |
| b2b-1920 | 1920 | 4 | decrypt | 12.152 | 158.0 | 75.9% | 2.923 | 2.916 | 0.173 | 150 | 284.0 |
