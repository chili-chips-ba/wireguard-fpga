# Verification storage and shared ChaCha pressure

The accepted overlap measurement is preserved unchanged. At 1920 bytes:

| Probe stalled clocks | Accepted overlap | Verification FIFO candidate |
| --- | ---: | ---: |
| `decrypt/wtv.axis_in` | 76 | 0 |
| `decrypt/chacha20.from_pipeline` | 238 | 0 |
| `encrypt/chacha20.to_pipeline` | 50 | 2 |

Verification FIFO high water: 168/513 beats; end occupancy 0. All 480 admitted beats were retired. All native assertions and measurement guards passed.

This storage intervention supports verification backpressure through the ordered shared
ChaCha results as the prior cross-direction throughput limit. Aggregate counters
do not give an exact cycle-by-cycle causal partition. Four packets provide three
completion intervals per direction; the result is not a long contention-window limit.
