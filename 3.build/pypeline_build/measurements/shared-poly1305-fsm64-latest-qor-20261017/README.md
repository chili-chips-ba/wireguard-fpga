# Shared Poly1305 AUTO_FSM QoR, 2026-10-18

Accepted: the build exited zero; all **48 native reference checks** across
six packet sizes, body II=1, buffer conservation, final synthesized timing/device
fit, and the measurement's acceptance checks passed. The run completed in
**4,348 simulation cycles**. Archived synthesis integrity was checked with
`measure.py --check-record`.

The Artix-7 xc7a200tffg1156-2 performance-testbench top meets the **80 MHz**
synthesis goal, with limiting fmax **81.037 MHz** (epilogue); prologue is
**82.665 MHz**. Routed timing and external-port hardware area were not measured.
At 1920 bytes, concurrent payload goodput is **9.125 Gbit/s encrypt and decrypt
at 80 MHz**, or **9.243 Gbit/s each at the measured fmax**. At 1420 bytes,
80 MHz gives **7.724 Gbit/s encrypt / 6.476 Gbit/s decrypt**.

## Sharing and selected configuration

- `--shared --poly1305 pipelined --poly1305-mult hybrid_square --poly1305-compute fsm`.
- One prologue FSM and one epilogue FSM serve both encrypt and decrypt.
  The services have independent round-robin arbiters and can overlap each other.
  Direction tags route responses back to the requesting MAC.
- Each direction retains its own II=1 pipelined Poly1305 body: eight-cycle core
  latency, ten response cycles and ten accumulator lanes.
- Both service cores use `max_latency=64`. Actual core latencies are
  prologue **64**, epilogue **41**; wrapper responses take **65/42 cycles**,
  before contention waits. ChaCha20 is also shared, with core latency 19.
- Concurrent encrypt/decrypt, 16/64/256/1024/1420/1920-byte payloads, four
  packets per direction per size, 29-byte AAD, seed 8439, all taps, no extra
  peak phase, always-ready sinks and no deliberate source pauses.
- Vivado 2019.2, `--target-mhz 80 -j 2`, completed synthesis reused.

In the 1920-byte phase each shared service recorded **8 launches and 8
responses**: four from each direction. Shared prologue compute occupancy was
512 cycles and epilogue 328, matching eight requests at 64/41 cycles.
Historical module/JSON names containing `mcp` remain for compatibility;
`compute_impl=fsm` records the actual implementation.

## Resources and throughput tradeoff

| Resource | MCP baseline | Shared FSMs | Change |
| --- | ---: | ---: | ---: |
| LUTs | 108,078 | 104,668 | -3.16% |
| Flip-flops | 43,955 | 93,372 | +112.43% |
| DSP48s | 711 | 413 | -41.91% |
| BRAM tiles | 18.5 | 18.5 | +0.00% |

Compared with the accepted MCP baseline at the same 80 MHz clock, 1920-byte
goodput decreases **7.92%** in both directions. The smaller-packet regressions
are larger; see [the complete comparison](comparison.md). The DSP reduction
comes with increased FF storage and longer service latency.

Full reports: [summary](summary.md), [blocks](blocks.md), [results](results.json)
and [raw reference checks](perf_raw.json).

## Compiler and source identity

PipelineC base **8ed96ba4c4e1d5612814182a1a5c3f430a315ad0**, plus the
uncommitted changes in [compiler.patch](compiler.patch). The working tree was
copied from `/media/1TB/Dropbox/PipelineC/git/PipelineC` and verified against
655 compiler source hashes. The compiler copy and all 38 production design
hashes still matched the launch snapshot when results were accepted.
[compiler-snapshot.json](compiler-snapshot.json) records both paths and hashes;
[design-source.tar.gz](design-source.tar.gz) contains the measured design and
build/report scripts. The production arithmetic and constant-index epilogue
workaround were used; the earlier experimental word-arithmetic probes were
not part of this design.

Synthesis took three FSM passes. The retained top is identified by the archived
[inputs](perf-inputs.json), [sweep history](perf-sweep-history.json) and
[Vivado log](perf-vivado.log). Early 62.25/64.50 MHz epilogue failures remain
in the console log; final sweep records and the retained log establish the
81.037 MHz result. This was one build/simulation flow using the same final
latencies, rather than a native replay with guessed counts.

## Reproduction

Run from `3.build/pypeline_build`. Select the retained compiler copy:

```sh
export PYPELINEC="$PWD/generated-files/poly1305-fsm-compiler-attempt8-latest/compiler/src/pypelinec"
```

If that local copy is unavailable, reconstruct the measured compiler from a
PipelineC checkout containing the recorded base commit, then apply the archived
working-tree patch:

```sh
git clone /path/to/PipelineC /tmp/wireguard-fsm-compiler-8ed96
git -C /tmp/wireguard-fsm-compiler-8ed96 checkout --detach 8ed96ba4c4e1d5612814182a1a5c3f430a315ad0
git -C /tmp/wireguard-fsm-compiler-8ed96 apply "$PWD/measurements/shared-poly1305-fsm64-latest-qor-20261017/compiler.patch"
export PYPELINEC=/tmp/wireguard-fsm-compiler-8ed96/src/pypelinec
```

With `PYPELINEC` set by either method, the original measurement command is:

```sh
export PYPELINEC_CACHE_DIR="$PWD/generated-files/pypelinec-cache"
python3 measure.py --shared --poly1305 pipelined --poly1305-mult hybrid_square \
  --poly1305-compute fsm --target-mhz 80 -j 2 \
  --label shared-poly1305-fsm64-latest-qor-20261017 \
  --out-dir generated-files/shared-poly1305-fsm-qor-20261016 --reuse-syn \
  --sizes 16,64,256,1024,1420,1920 --packets 4 --peak-bytes 0 \
  --dirs both --taps all --seed 8439 --no-per-module-area --save-evidence
```

Preserve the accepted record; use a new label for a new run. To verify the
saved archive without new synthesis or simulation:

```sh
python3 measure.py --check-record measurements/shared-poly1305-fsm64-latest-qor-20261017
```

From the repository root, [git-add.txt](git-add.txt) contains the exact staging
command for the implementation, documentation and this accepted record.
[commit-message.txt](commit-message.txt) contains a suggested commit message.
