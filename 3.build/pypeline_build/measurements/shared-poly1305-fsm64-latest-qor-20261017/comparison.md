# Shared AUTO_FSM versus MCP baseline

Both records use shared ChaCha20, shared Poly1305 setup/finalization, hybrid_square,
ten body lanes per direction and an 80 MHz synthesis goal. Traffic is concurrent,
four packets per direction at each size, seed 8439, with all internal taps.
Area is the performance-testbench top. Compiler revisions differ, so the figures
compare the complete designs rather than isolating the wrapper under one compiler.

| Resource | MCP baseline | Shared FSMs | Change |
| --- | ---: | ---: | ---: |
| LUTs | 108,078 | 104,668 | -3.16% |
| Flip-flops | 43,955 | 93,372 | +112.43% |
| DSP48s | 711 | 413 | -41.91% |
| BRAM tiles | 18.5 | 18.5 | +0.00% |

Rates below use a common **80 MHz** clock. The FSM design's limiting synthesis
fmax is **81.037 MHz**, versus **85.543 MHz** for the MCP baseline. Rates at each
record's different fmax are not used for the percentage comparison.

| Payload bytes | MCP enc/dec Gbit/s | FSM encrypt Gbit/s | FSM decrypt Gbit/s | Enc change | Dec change |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 16 | 0.452 / 0.327 | 0.094 | 0.078 | -79.27% | -76.26% |
| 64 | 1.807 / 1.267 | 0.375 | 0.310 | -79.27% | -75.51% |
| 256 | 6.827 / 4.509 | 1.499 | 1.241 | -78.05% | -72.47% |
| 1024 | 9.638 / 9.638 | 5.994 | 4.965 | -37.80% | -48.48% |
| 1420 | 9.668 / 9.668 | 7.724 | 6.476 | -20.11% | -33.02% |
| 1920 | 9.910 / 9.910 | 9.125 | 9.125 | -7.92% | -7.92% |

The FSM design saves 298 DSPs and 3,410 LUTs, while adding 49,417 flip-flops.
BRAM usage is unchanged. At 1920 bytes, goodput falls 7.92% in each direction;
the longer shared setup/finalization services penalize smaller packets more.
The result meets the 80 MHz synthesis goal but delivers 9.125 Gbit/s per
direction at 1920 bytes, rather than the baseline's 9.910 Gbit/s.

The FSM cores were capped at 64 cycles. The compiler chose 64-cycle prologue
and 41-cycle epilogue cores; the wrapper adds one response/handshake cycle.
Epilogue timing refinement went through 60-, 62- and 41-state plans. At the
final grain its DAG crossed the compiler's 20K-node area-search limit, so that
area search was skipped; the actual synthesized implementation above is the
retained result. There was no application arithmetic rewrite or multiplier
leaf-size override in this run.

See [the full FSM result](summary.md), [block measurements](blocks.md),
[the baseline](../shared-verify-fifo-qor-20261015/README.md) and
[comparison data](comparison.json).
