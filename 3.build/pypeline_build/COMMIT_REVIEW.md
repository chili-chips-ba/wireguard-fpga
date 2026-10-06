# Commit review: recover shared-design decrypt throughput

Prepared 2026-10-06 against WireGuard HEAD `77116452`. This is the buffering
follow-up to the already committed shared-Poly1305 work, not another commit
of that implementation. All work is in the primary WireGuard repo.

## Result and review conclusion

The shared 60 MHz performance build and six-size QoR sweep completed:
48/48 reference checks, synthesis timing and capacity pass, one physical MCP
per shared phase, valid MCP constraints, and body II=1 in both directions.
Reported synthesis Fmax is 63.032 MHz. The performance-testbench top uses
48,497 LUTs, 20,540 FFs, 704/740 DSPs and 13.5 BRAM tiles.

| Packet bytes | Encrypt at 60 MHz | Decrypt at 60 MHz |
| ---: | ---: | ---: |
| 1420 | 5.842 Gb/s | 5.859 Gb/s |
| 1920 | 6.255 Gb/s | 6.269 Gb/s |

The final source diff was reviewed with no blocking finding. The changes are
limited to bounded dataflow buffering, a tag-packer handshake correction,
existing native-testbench stress support, measurement reporting and evidence.
There are no new production modules or special test runners. `build.py`,
PipelineC, automatic profiles, arithmetic and sharing arbiters are unchanged.
The default remains pipelined sharing-both at 60 MHz; legacy and other
sharing selections remain selectable as before.

No tests, builds or new traffic comparisons were run during this final
commit-preparation pass. Only existing results were inspected/packaged and
documentation updated. Nothing has been staged or committed by this session.

### Design points checked in the source review

- Decrypt buffering is **after the ciphertext fork and before authentication
  framing**, not after plaintext verification. It stores data/keep/last as
  one stream item, preserves ordering and still waits for the tag verdict
  before releasing plaintext. The selected FIFO has 64 memory beats plus
  one FWFT output beat, not a 64-cycle compute-latency cap.
- The encrypt output slice is the existing library's full two-slot, II=1
  slice, with one unstalled output cycle. It holds accepted output words
  stable under external stalls; it does not change body `D=P+2` or lane sizing.
- The tag packer suppresses a partial ciphertext tail independently of
  downstream ready and accepts it into its free holding register on an
  actual input transfer. It does not require the tag to arrive before taking
  that tail, which would deadlock the fork. Its ready decision is independent
  of upstream valid to avoid an interlock loop.
- Both new buffers are selected only for pipelined MAC wiring. Legacy gets
  the shared tag-packer protocol correction, but neither new FIFO nor slice.
- Sources advance only on converged `valid && ready`. Optional source gaps
  never withdraw a held valid beat. Native sinks count transfers and check
  data/keep/last/verification stability during stalls. Performance traffic
  stays unpaused and its sinks always ready.
- Buffer probes are erased simulation callbacks, not new hardware counters.
  Capacity includes output storage; occupancy persists across phase resets.
  Measurement guards check conservation, capacity and empty settled phases.
- Production automatic sizing remains unrestricted. The new QoR converged
  to ChaCha core 17, body cores 3/3, local lanes 5/5 and shared capacity 5.
  MCP setup/hold constraints are prologue 6/5 and epilogue 5/4. Arithmetic
  inside each emitted MCP remains unregistered.

## Changed source and documentation files

Paths are relative to `3.build/pypeline_build/`. All rows except the review
itself are modifications to existing tracked files; no other source file is
part of this change.

| File | What changed / why it belongs |
| --- | --- |
| `README.md` | Latest complete six-size QoR table, compiler provenance, buffering/dataflow summary, stress invocation, measurement/cache commands, occupancy definitions and historical interpretation. Removes obsolete in-progress and old-latest claims. |
| `CLAUDE.md` | Refreshes existing contributor guidance for the actual clock/sharing defaults, buffered graph, converged stress handshakes, evidence scope and disposable validation workspace; removes stale fixed-vector count and old sole-arbiter claim. |
| `src/poly1305/throughput.md` | Latest converged depths/checkpoint, system-level key/fork dependency, 32-versus-64 selection, body-latency convention, scope of Issue #39 remedy and retained-evidence links. Arithmetic design is unchanged. |
| `src/aead_types.py` | Owns the 64-beat budget and small adapters around existing FIFO/output-slice library blocks, with simulation-only probes and instantiated-storage metadata. Avoids another production helper module. |
| `src/chacha20poly1305/decrypt_dataflow_core.py` | Adds the pipelined authentication-branch FIFO before framing; leaves legacy wiring unchanged. The internal factory parameter supports storage sizing without new build CLI modes. |
| `src/chacha20poly1305/encrypt_dataflow_core.py` | Adds the pipelined encrypt output slice so comb-fork interlocking does not violate the external stalled-valid contract. |
| `src/auth_tag/append_auth_tag.py` | Fixes pre-existing partial-tail validity withdrawal under backpressure while retaining packed ciphertext/tag bytes and packet ordering. Applies to both architectures. |
| `src/chacha20poly1305/tb_common_sim.py` | Converged source gaps, transfer-only sink/stability assertions, and opt-in directed native stress through 1920 bytes. No new runner or compiler-test directory. |
| `src/chacha20poly1305/encrypt_tb.py` | Uses the shared source/sink helpers and optional stress callbacks; ordinary sink readiness remains literal 1. |
| `src/chacha20poly1305/decrypt_tb.py` | Same stress integration with verification-sideband stability and existing tampered-tag checking. |
| `src/chacha20poly1305/perf_probe.py` | Buffer occupancy/high water/simultaneous-transfer accounting, transfer timestamps and packet input-end timestamps; existing synthetic selftest extended. |
| `src/perf_taps.py` | Simulation-only buffer/slice handshake and occupancy taps, using the existing per-direction naming and converged-cycle deduplication. |
| `src/chacha20poly1305/perf_tb_common.py` | Records only instantiated buffers/slices alongside actual compute-latency metadata. |
| `bottleneck.py` | Adds the storage boundaries to attribution, occupancy to reports and a separate common-contention-window diagnostic without redefining historical completion-period rates. |
| `measure.py` | Forwards existing `--out-dir`, reports buffer/slice metadata, validates storage conservation/capacity, and provides matched-workload recovery-comparison helpers and synthetic selftest cases. No diagnostic or area-only build added. |
| `COMMIT_REVIEW.md` (new) | Requested final file-by-file rationale, evidence/limitations, excluded files and explicit staging command. |

## New retained measurement files

Exactly one new accepted directory is included:

`measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/`

All files below are new to Git. These are measurement outputs or compact
durable evidence, not standalone Poly1305 measurements or development runners.

| File in that directory | Why retained |
| --- | --- |
| `results.json` | Accepted configuration, actual depths, timing/utilization, phases, reference checks, MCP HDL audit and measurement validation. |
| `perf_raw.json` | Original native six-size cycle-domain measurements before report formatting. |
| `summary.csv` | Flat packet-size/direction throughput and latency data. |
| `summary.md` | Human-readable accepted QoR table, source of README values. |
| `blocks.csv` | Per-block service/stall data for reuse and analysis. |
| `blocks.md` | Readable body lifecycle, arbitration, shared MCP service and buffer reports. |
| `taps.csv` | Raw internal handshake/state/arbitration/buffer accounting. |
| `pypelinec.log` | Completed compiler/build/native-simulation log, with per-cycle clock spam filtered. |
| `perf-vivado.log` | Retained successful synthesis timing and utilization observation, including vendor/tool details. |
| `perf-inputs.json` | HDL/constraint/tool-input signatures identifying the retained synthesis observation. |
| `perf-sweep-history.json` | Completed sweep, restored/retained observation and final per-MAIN timing/depth records. |
| `perf-clocks.xdc` | Hash-matched clocks and MCP setup/hold constraints. |
| `perf-source-provenance.json` | Frozen design/include source hashes and drift records identifying measured inputs. |
| `artifact-manifest.json` | SHA256/size inventory of every retained measurement file, refreshed after documentation/evidence packaging. |
| `native-fifo64-pilot.json` | Controlled pre/post FIFO pilot at matching compiler hashes/depths, packet and MAC timelines, key/body stall accounting. Explicitly distinct from final synthesized QoR. |
| `workflow-evidence.json` | Completed 11-build comb matrix, stress and recorded-depth replay summaries, source/log hashes and completion timelines formerly local to `validation/`; includes interrupted-run and omitted-comparison limitations. |
| `comparison.md` | Root-cause explanation, storage-selection rationale, compiler-versus-buffer effects, historical 60/30/80 comparisons and Issue #39 impact. Reuses an existing per-measurement document role. |

No critical result depends on retaining `validation/`: source hashes, packet
timelines, key/body waits, coverage summaries and synthesis evidence are
embedded or archived above. Large development traces, scratch runners,
interrupted/error logs and the old draft review remain disposable local work.
Original historical archives were not rewritten.

## Evidence boundaries and scope of acceptance

The final 48-packet QoR ran at **actual converged automatic latencies** and
passed. Earlier final-source comb coverage passed 205 packet checks in eleven
selection/style/fallback builds; the separate stress passed 33 checks with
gaps, partial beats, output stalls and a tampered tag. Completed 16-packet
replays show near-equal large-packet completion periods at both recorded
body-depth profiles. The interrupted 3/3 two-size replay is recorded only as
a completed 1420-byte phase plus a separate successful 1920-byte replay.

The 32-beat candidate passed correctness but achieved only 91.25% parity;
64 recovered parity. Latest QoR auth FIFO high water is 56/65 beats and every
phase drains empty. No key FIFO was needed. The fixed-wrapper native pair
isolates a 32.4% decrypt gain and 0.68% encrypt loss; the historical 60 MHz
comparison gives 30.6% and 0.9%, but also changes compiler/body depth.

The user explicitly requested no further comparisons/tests once final QoR
was available. The original eight-interval common-window criterion was not
fully demonstrated for the 16-packet 1420-byte baseline (seven decrypt
intervals), so no 32-packet extension or new final standalone-direction
performance sweep is included or claimed. This is a documented scope
decision, not a hidden passing test. Native standalone correctness is covered.

Area is **performance-testbench area**, not new DUT-only area. Timing is
**synthesis evidence**, not routed sign-off. The earlier external-port
sharing-both checkpoint remains 30 MHz. The old 640-DSP perf top retained
body depths 3/0; the new 704-DSP point retains 3/3. Do not attribute that
whole area delta to a storage FIFO. Small-packet asymmetry and verification
cold latency remain; there is no arbitrary prolonged peer-stall guarantee.

For [Issue #39](https://github.com/chili-chips-ba/wireguard-fpga/issues/39),
this implements its proposed ciphertext-buffer position and addresses the
primary measured decrypt key-wait penalty in the pipelined Pypeline design.
It does not remove framing/setup costs or update the C implementation.
No GitHub comment or issue closure was made.

## Excluded and untouched

- `validation/`, all generated directories, scratch scripts and retired
  local `tests/` are not part of this commit and were not deleted.
- `FPGA-House-AG-Compare.md` is untouched and not staged. Its SHA256 remains
  `1c0aff75120e682b2cf56ef9bfd93d7fe0477334b0df6a8f108068aaf1312802`.
- The untracked failed/older
  `measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-20261003-lower-clock-20261004/`
  is not staged or deleted. Existing committed historical measurements stay unchanged.
- Unrelated `.vscode/`, `2.sw/`, C-side generated directories and `.orig`
  files are preserved and omitted. No PipelineC file was edited.
- No source-selection/default-clock, automatic-latency-profile or build.py
  changes are included. This review does not recommit the parent sharing work.

## Final staging command

Run from the primary WireGuard repo root. This lists only the sixteen
source/document files and seventeen files in the new accepted measurement
directory. It does not stage `validation/`, generated files, historical
directories or unrelated work. The command has **not** been executed.

```sh
cd /media/1TB/Dropbox/PipelineC/git/wireguard-fpga
git add -- \
  3.build/pypeline_build/CLAUDE.md \
  3.build/pypeline_build/COMMIT_REVIEW.md \
  3.build/pypeline_build/README.md \
  3.build/pypeline_build/bottleneck.py \
  3.build/pypeline_build/measure.py \
  3.build/pypeline_build/src/aead_types.py \
  3.build/pypeline_build/src/auth_tag/append_auth_tag.py \
  3.build/pypeline_build/src/chacha20poly1305/decrypt_dataflow_core.py \
  3.build/pypeline_build/src/chacha20poly1305/decrypt_tb.py \
  3.build/pypeline_build/src/chacha20poly1305/encrypt_dataflow_core.py \
  3.build/pypeline_build/src/chacha20poly1305/encrypt_tb.py \
  3.build/pypeline_build/src/chacha20poly1305/perf_probe.py \
  3.build/pypeline_build/src/chacha20poly1305/perf_tb_common.py \
  3.build/pypeline_build/src/chacha20poly1305/tb_common_sim.py \
  3.build/pypeline_build/src/perf_taps.py \
  3.build/pypeline_build/src/poly1305/throughput.md \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/artifact-manifest.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/blocks.csv \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/blocks.md \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/comparison.md \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/native-fifo64-pilot.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf-clocks.xdc \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf-inputs.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf-source-provenance.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf-sweep-history.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf-vivado.log \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/perf_raw.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/pypelinec.log \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/results.json \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/summary.csv \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/summary.md \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/taps.csv \
  3.build/pypeline_build/measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/workflow-evidence.json
```
