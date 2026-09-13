<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# `sweep_history.json` omits the final, timing-met iteration, so its last entry is a mid-sweep fmax

**Status:** Found and root-caused from the wireguard-fpga side while building the
QoR measurement rig (`measure.py`). No workaround needed in this repo's HDL --
the fix belongs in how PipelineC writes `sweep_history.json`
(`src/SWEEP.py`). `measure.py` works around it by treating the JSON as
diagnostics only and scraping the build's stdout for the authoritative final
numbers, which is exactly the brittleness a machine-readable artifact should
remove.

## Symptom

For the shared encrypt+decrypt design (`./build.py --shared --perf`, 80 MHz
goal), `<out_dir>/top/sweep_history.json` ends like this:

```json
{"chacha20_pipeline_shared": [
  {"iter":1,"goal_mhz":80.0,"achieved_mhz":47.923,"cuts":12,"pipeline_stages":13,
   "action":"densify(chacha20_block_step x1.75)"},
  {"iter":2,"goal_mhz":80.0,"achieved_mhz":62.972,"cuts":22,"pipeline_stages":23,
   "action":"minisweep(chacha20_block_step)"}]}
```

A consumer reading the last entry as "the result" concludes **62.97 MHz, timing
not met, 23 pipeline stages**. All three are wrong. The same build's stdout says:

```
[sweep] chacha20_pipeline_shared: about to synthesize, cuts=0, 19 slice(s) (20 pipeline stages)
[sweep] chacha20_pipeline_shared: no failing timing path reported for this main; assuming met.
[sweep] chacha20_pipeline_shared: met timing, 19 slice(s) built (20 pipeline stages), cuts=0, locked=10 inst(s), iterations=3
[sweep]   chacha20_pipeline_shared: 19 slice(s) total (20 pipeline stages: comb regions separated by those slices)
```

So the design **met its 80 MHz goal** at iteration 3 and was built with **19
slices / 20 stages** — an iteration and a configuration that appear nowhere in
the history file. The two `minisweep`/`densify` entries that *are* recorded are
intermediate probes that were superseded.

This is not a corner case: any sweep that ends by *succeeding* loses its result,
because the last recorded `action` is always the action that led to the
(unrecorded) final iteration.

## Impact

`sweep_history.json` and `placement_trace.json` are the only machine-readable
synthesis artifacts pypelinec produces, and the obvious ones for an external QoR
tool to consume. As written, the JSON cannot answer "what fmax did this build
achieve, and was the goal met?" — the two questions it looks like it answers.
Consumers must instead regex the stdout log (`met timing, N slice(s) built …`,
`synthesized as written (standalone check): X MHz vs Y MHz goal - PASS`,
`PASS <main>: X MHz vs Y MHz goal (confirmation run)`), which is version-fragile.

## Suggested fix

In `src/SWEEP.py` (`self.history` is built at line ~3697, written at line ~5580),
append a final record when the sweep concludes, and/or add a per-main summary
object next to the iteration list, e.g.:

```json
{"chacha20_pipeline_shared": {
   "iterations": [ …the existing per-iter dicts… ],
   "final": {"iter":3,"goal_mhz":80.0,"achieved_mhz":null,"met":true,
             "cuts":0,"slices_built":19,"pipeline_stages":20,
             "locked_instances":10,"action":"met",
             "note":"no failing timing path reported; achieved MHz not measured"}}}
```

Two details worth preserving in whatever shape is chosen:

1. **`achieved_mhz` can legitimately be unknown.** When a main meets timing,
   pypelinec reports "no failing timing path reported for this main; assuming
   met" and never derives an MHz number, so the honest encoding is
   `met: true, achieved_mhz: null` with `goal_mhz` present — the goal is then a
   *lower bound* on fmax, not the fmax. A consumer must be able to tell "met, at
   least 80 MHz" from "measured 80 MHz".
2. **Non-autopipelined mains need an entry too.** `encrypt_dataflow_shared` /
   `decrypt_dataflow_shared` have an 80 MHz goal but nothing sliceable; their
   verdicts only exist in stdout (`standalone check: 85.77 MHz … PASS`,
   `confirmation run: 93.69 MHz`). Today they appear in the history as empty
   lists, which reads as "no data" rather than "met, as written".

## How this repo's tooling handles it meanwhile

`measure.py::parse_fmax` treats `sweep_history.json` strictly as diagnostics
(exposed as `fmax.per_main[*].last_sweep_iter.mid_sweep_mhz`, explicitly named
*mid-sweep*), and derives `fmax.design_mhz` / `timing_met` from the final stdout
outcome lines. When every goal is met but the limiting main's achieved MHz was
never printed, it reports the goal with `design_mhz_is_lower_bound: true` and a
`design_mhz_basis` string, rather than silently quoting a number nobody measured.
