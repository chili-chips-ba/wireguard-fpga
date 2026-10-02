# Shared Poly1305: primary-checkout 30 MHz results

New results: [shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z](summary.md).
Body II=1 is checked by the continuous-input standalone RTL test, not inferred from packet throughput.
Accumulator counts and MCP cycles below come from the final performance build:

```json
{
  "implementation": "pipelined",
  "directions": {
    "encrypt": {
      "body_core_latency": 0,
      "body_latency": 2,
      "accumulator_count": 2,
      "body_ii": 1,
      "prologue_mcp_latency": 1,
      "epilogue_mcp_latency": 2,
      "prologue_response_cycles": 2,
      "epilogue_response_cycles": 3
    },
    "decrypt": {
      "body_core_latency": 0,
      "body_latency": 2,
      "accumulator_count": 2,
      "body_ii": 1,
      "prologue_mcp_latency": 1,
      "epilogue_mcp_latency": 2,
      "prologue_response_cycles": 2,
      "epilogue_response_cycles": 3
    }
  },
  "arithmetic": "residue130"
}
```

## Comparison with recorded legacy results

Legacy was measured at 80 MHz; new hardware is characterized at 30 MHz. Cycles/packet compare architecture costs independently of MHz. Legacy-at-30 throughput below is a mathematical rescaling, not a new legacy run.

The legacy record is checked into this repo at `measurements/shared-80mhz-probed/results.json`; its original compiler and dirty-tree provenance are retained below. No new legacy synthesis or QoR run was performed.

| bytes | direction | legacy cycles/packet | new cycles/packet | legacy at 80 MHz (Gb/s) | new at 30 MHz (Gb/s) | actual-clock rate ratio | legacy scaled to 30 MHz (Gb/s) |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 16 | encrypt | 31.00 | 16.00 | 0.330 | 0.240 | 0.727 | 0.124 |
| 16 | decrypt | 39.67 | 18.00 | 0.258 | 0.213 | 0.826 | 0.097 |
| 64 | encrypt | 49.00 | 19.33 | 0.836 | 0.794 | 0.950 | 0.313 |
| 64 | decrypt | 57.67 | 27.33 | 0.710 | 0.562 | 0.791 | 0.266 |
| 256 | encrypt | 121.00 | 34.00 | 1.354 | 1.807 | 1.335 | 0.508 |
| 256 | decrypt | 129.33 | 44.33 | 1.267 | 1.386 | 1.094 | 0.475 |
| 1024 | encrypt | 418.33 | 84.67 | 1.567 | 2.903 | 1.853 | 0.587 |
| 1024 | decrypt | 561.67 | 101.33 | 1.167 | 2.425 | 2.079 | 0.438 |
| 1420 | encrypt | 565.67 | 107.33 | 1.607 | 3.175 | 1.976 | 0.602 |
| 1420 | decrypt | 857.67 | 135.33 | 1.060 | 2.518 | 2.377 | 0.397 |
| 1920 | encrypt | 758.33 | 140.67 | 1.620 | 3.276 | 2.022 | 0.608 |
| 1920 | decrypt | 1040.33 | 158.00 | 1.181 | 2.916 | 2.469 | 0.443 |

The arithmetic and toolchain differ: legacy used the recorded limb-based implementation; the new body uses full-width 130-bit residues and shared corrected reduction. New builds use the current primary compiler with MCP/sweep/package fixes, not the historical compiler or private-tree artifacts. Synthesis timing is not routed timing.

The MAC's block-rate ceiling is not the end-to-end packet rate: setup, drain, finalization, framing, shared ChaCha arbitration and backpressure are measured separately. The old 80 MHz pipeline also differs from the new 30 MHz ChaCha depth; this comparison does not isolate the MAC change as the sole cause of performance differences.

Legacy provenance:

```json
{
  "wireguard_fpga_git": "db70c9753c44dc8adb865d79e30d697398f467c4-dirty",
  "pipelinec_git": "32356330ec7c0c6ec62c46c7456734da83a53482",
  "vivado_version": "2019.2",
  "host": "home",
  "build_wall_s": null,
  "build_returncode": null,
  "cycles_run": 11567,
  "sim_wall_s": 8168.667,
  "synthesis_reused": false,
  "log": "measurements/shared-80mhz-probed/pypelinec.log",
  "perf_raw": "measurements/shared-80mhz-probed/perf_raw.json"
}
```

New provenance:

```json
{
  "wireguard_fpga_git": "295ea46cbdd224ef2d0d713765fc5c9ec0a68f3d-dirty",
  "pipelinec_git": "0cc6aed9caf7d6cfbdb7dd345e12d950e3303300-dirty",
  "vivado_version": "2019.2",
  "host": "home",
  "build_wall_s": 9192.747926712036,
  "build_returncode": 0,
  "cycles_run": 2351,
  "sim_wall_s": 3196.936,
  "synthesis_reused": true,
  "log": "measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/pypelinec.log",
  "perf_raw": "measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/perf_raw.json"
}
```
