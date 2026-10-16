# Shared verification-FIFO QoR, 2026-10-15

<!-- STATUS:BEGIN -->

Accepted: all 48 reference checks across six packet sizes, body II=1, buffer
conservation, shared MCP HDL audit, final synthesis timing/device fit and
the independent full-FIFO stress check passed. Limiting fmax is
85.543 MHz. See [the full table](summary.md),
[comparison](comparison.md), [stall investigation](investigation.md) and
[block report](blocks.md).

<!-- STATUS:END -->

The full workload is **16, 64, 256, 1024, 1420 and 1920 bytes**, four packets
per direction per size, encrypt/decrypt concurrent, seed 8439, all taps,
unpaused sources and always-ready sinks. That gives **48 reference checks**.
The full native run completed on 2026-10-16 with all 48 checks passing
in 2275 clocks. Packet sizes are simulation parameters; no additional
synthesis build was needed for the complete curve.

The design derives plaintext-verification storage from the supported payload
limit, selected ChaCha credits/converters and Poly1305/verdict handoffs:
`170 + 127 + 5 + 4 + 1 = 307` required beats, rounded to **512 memory beats
plus one FWFT output beat**. The supported payload limit remains 2032 bytes.
Authentication/append fork capacities and shared ChaCha arbitration are unchanged.

The completed independent verification test exercised eight packets, including
six 2032-byte payloads and two partial-word cases, mixed verdicts, prolonged
and periodic output stalls. It reached all 513 slots, backpressured input
for 770 clocks, checked stable stalled words and no plaintext before a verdict,
and drained all 768 words with three rejected verdicts. Results are retained
in `verification-component.json`; `check_verification.py` reproduces it.

The [accepted overlap archive](../shared-poly1305-overlap-resume-20261015/README.md)
is preserved unchanged. Its 1920-byte periods were 143 / 134.667 clocks
encrypt/decrypt (9.130 / 9.695 Gb/s at 85 MHz). The original
[pre-overlap archive](../shared-85mhz-bottleneck-1920-4pkt-20261013/README.md)
has exact periods 161.333 / 160.667 clocks. Comparisons use those exact
cycle-derived rates, rather than rounded values in earlier prose.

Both new synthesis and native simulation use the same frozen PipelineC working
tree at base revision **`57f9b0c0a890bbce13ece1b273404dcfeeb20ee2`**.
`compiler-snapshot.json` records dirty files and file hashes; the replay checks
every hash. `replay-config.json` records all 37 design-source hashes and the
19/8/8 pipeline and 12/8 MCP maps. `design-source.tar.gz` preserves the exact
candidate bytes, including uncommitted changes. The accepted overlap archive's
older synthesis compiler is a separate identity and is not reused as new evidence.

The synthesis constraint is **80 MHz**, Vivado 2019.2, Artix-7 xc7a200tffg1156-2.
The replay is strict native simulation, with the recorded compute latencies.
Finalization requires those maps to match the final synthesized implementation,
confirmed timing, device fit, conservation, II=1, the shared MCP HDL audit,
48 reference checks and the >=20% gain target in both directions. Results
refer to the shared performance-testbench top. Routed timing and external-port
area are unmeasured. Four packets provide three completion intervals per size;
they do not establish a long contention-window limit.

From `3.build/pypeline_build`, reproduce the six-size native run without synthesis:

```bash
python3 measurements/shared-verify-fifo-qor-20261015/replay_native.py
```

The compiler snapshot path is recorded in `replay-config.json`; use
`--compiler /path/to/matching/snapshot` to relocate it. `--out-dir` selects
a separate output/source cache. The script restores the archived design
when necessary and verifies it before simulation. The actual initial
six-size job used the equivalent frozen local `generated-files/verify-fifo-20261015/replay.py`
with `--name full-qor --sizes 16,64,256,1024,1420,1920 --packets 4`.

Reproduce the confirmed synthesis and its focused native workload with:

```bash
PYPELINEC="$PWD/generated-files/compiler-overlap-20261015-latest/src/pypelinec" \
  python3 measure.py --shared --poly1305 pipelined --poly1305-mult hybrid_square \
  --target-mhz 80 --sizes 1420,1920 --packets 4 --peak-bytes 0 --dirs both \
  --taps all --seed 8439 --no-per-module-area --save-evidence \
  --out-dir generated-files/verify-fifo-20261015/synthesis-build \
  --label "$PWD/generated-files/verify-fifo-20261015/qor"
```

Preserve that existing build; `--reuse-syn` resumes its output directory.
Its simulation plan does not affect the elaborated hardware. Finalization
combines its confirmed synthesis with the complete six-size native run,
using the ordinary `measure.py` merger and acceptance checks:

```bash
python3 measurements/shared-verify-fifo-qor-20261015/finalize.py --check-ready
python3 measurements/shared-verify-fifo-qor-20261015/finalize.py --wait --update-readme
```

The second command can run in the background. It publishes the full current
README table and component summary only after all required checks pass.
Changed documentation or mismatched final latencies stop publication for review.
Completion is recorded in `generated-files/verify-fifo-20261015/publication-status.json`;
both `passed` and `published` must be true before committing.

After finalization, the archive includes `results.json`, `summary.md`/`.csv`,
`blocks.md`/`.csv`, `taps.csv`, exact comparison and stall reports, the retained
Vivado/input/sweep/constraint evidence and `artifact-manifest.json`. Check it
without rerunning simulation or synthesis:

```bash
PYPELINEC="$PWD/generated-files/compiler-overlap-20261015-latest/src/pypelinec" \
  python3 measure.py --check-record measurements/shared-verify-fifo-qor-20261015
```

`git-add.txt` contains the exact staging command to run from the repository
root after publication passes. The measurement subtree is ignored by default;
`-f` adds only the explicitly named paths and this new record. The command
excludes generated caches and unrelated files. `commit-message.txt` supplies
a proposed commit message; no staging or commit is performed automatically.
