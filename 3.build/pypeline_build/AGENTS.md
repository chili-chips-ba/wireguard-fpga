# AGENTS.md

This file provides guidance to agents working in this Pypeline subproject.

## Project Overview

Pypeline (Python front-end for PipelineC) port of the C ChaCha20-Poly1305 AEAD
designs in `../pipelinec_build/`. Three design variants target Artix-7
xc7a200tffg1156-2: 256-bit pipelined Poly1305 at an **80 MHz** goal, using `inferred_body`,
with the best validated configuration published in README's current QoR table.
`DEFAULT_PROFILE` and `PUBLISHED_MEASUREMENT` in `src/wireguard_env.py` name
that profile and its measurement; build.py, measure.py and direct hardware
profile resolution use them. Promote a validated improvement by setting both to
it and running `--update-readme`, which refuses any other record, so the table
and script defaults stay together. PipelineC decides what each build must redo
(it reports an unchanged build up to date); every build shares the store
`generated-files/syn_cache`. Explicit flags select other profiles. Architectural comparisons, including
AUTO_FSM versus MCP, belong in historical measurement/component notes rather
than the ordinary build workflow. Legacy supports 128 bits at 80 MHz.
The C originals' Poly1305 math and
ciphertext-length bugs fixed — this port is RFC 8439-conformant and its
tags/ciphertext lengths **deliberately differ** from the still-unfixed C
designs. Do not port fixes back to `../pipelinec_build/` without being asked;
they are intentionally different designs now.

Set `$PYPELINEC` to the PipelineC executable (`<PipelineC repo>/src/pypelinec`)
before running any build script; `build.py` falls back to `pypelinec` on PATH.
`measure.py` and `bottleneck.py` derive the PipelineC repo from it (falling
back to a sibling `../../../PipelineC` checkout) and put its
`include/pypeline` on `sys.path` for the stream performance library.

Every design/test file starts with `import wireguard_env  # noqa: F401` —
this must be the first import; it's this tree's own `sys.path` bootstrap
(adds `src/{chacha20,poly1305,prep_auth_data,auth_tag,chacha20poly1305}` so
files import each other with flat names like `import chacha20`). It's
separate from `pypelinec`'s own bootstrapping of the PipelineC repo's
`src/`/`include/pypeline/` onto `sys.path`. It also declares the build
parameters (`param()`, set with `pypelinec -D NAME=VALUE`): `DESIGN`
(encrypt|decrypt|shared), `POLY1305_IMPL`, `POLY1305_MULT_IMPL`, `SHARE` and `TARGET_MHZ`, resolved
by `resolve_profile` into `DESIGN`/`ENCRYPT`/`DECRYPT`/`SHARING`/`TARGET_MHZ`.
Named AUTO tags identify independent latency groups. PipelineC discovers,
remembers and restores their depths automatically. Tool-generated
`latency_profile.json` and `latency_memory.json` live in the build output
directory. Matching verified
pieces also live in `generated-files/syn_cache/latency/v2/`, survive clearing
one build directory, and can seed other directories at the same or a higher
clock goal. Changed hardware pieces are ignored before synthesis.
build.py and measure.py import the same module for the profile tables and
output-directory names.
Design configuration never comes from environment variables.

Keep the `poly1305_body_region` / `poly1305_pair_*_region` wrappers: they keep
the arithmetic body inside its named AUTO region so the sweep can attribute
and mini-sweep it. Both directions instantiate the same groups and kernels,
so their depths and AUTO_FSM schedules cannot differ. Directly tagging the imported body currently loses useful
attribution, and the sweep does not mini-sweep region roots (PipelineC's
`docs/issues_inventory.md`, issue 37).

## Build Commands

Run from `pypeline_build/` (not `src/`):

```bash
./build.py --enc|--dec|--shared [--sim [--syn_tb] [--comb] [--native]] [--continue]
```

- No design selector uses the published default sharing/compute profile.
  An explicit MCP compute override automatically shares both services.
  Explicit `--shared` shares both,
  while body pipelines and packet contexts stay private. Explicit
  `--share-chacha20` / `--share-poly1305` select the complete sharing set;
  both selects both; `--share-none` keeps both private. These cannot be
  combined with `--enc`/`--dec`. build.py passes the profile to pypelinec as
  `-D DESIGN/POLY1305_IMPL/POLY1305_MULT_IMPL/SHARE/TARGET_MHZ`; `-D NAME=VALUE` on build.py
  passes anything else through (`-D TB_STRESS=1`, `-D PERF_*`).
- `--poly1305 legacy` automatically selects 128 bits, inferred multiplication
  and shared ChaCha20 for combined builds; explicit `--shared` is invalid.
  `--poly1305-mult inferred|hybrid|hybrid_square|inferred_body` selects the pipelined
  arithmetic. `inferred_body` gives the feedback bodies a wide inferred product: fewer stages,
  so fewer lanes and smaller setup/finalization. `--poly1305-prologue-cap N` sets the prologue
  AUTO_FSM cap; `--poly1305-epilogue-cap N` sets the epilogue cap. Defaults
  reproduce the published profile; other widths retain their packet budget.
  Historical cap-64 directory names remain stable; other values encode both caps. `--latency-hints FILE` and `--pipeline-min-effort N` pass through
  to pypelinec.
  `--target-mhz N` accepts any positive integer MHz clock goal.
  Automatic compute blocks use PipelineC's verified latency memory and normal
  sweep, without fixed or maximum latencies. Cache identities include
  architecture, sharing, multiplier
  and clock. Do not guess starting values. See `src/poly1305/throughput.md` for
  measured history.
- No `--sim`: the hardware build of the real top `src/chacha20poly1305.py`
  (external ports) into `generated-files/hardware-<profile>`
  (`--enc`/`--dec`/`--shared` select `-D DESIGN`; the top keeps its
  `chacha20poly1305_{encrypt,decrypt,encrypt_decrypt_shared}` name via `--top`).
  `--verilog` adds the final Verilog export, only when explicitly requested and
  after the one pre-export HDL check. A combined build fails when an encrypt
  AUTO_PIPELINE/AUTO_FSM latency differs from its decrypt twin's, or only one
  direction built it.
- **Timing comes only from the real top.** Never synthesize a testbench for
  timing: its constant stimulus lets Vivado remove logic (a synthesized perf
  testbench lost the whole decrypt MAC, and the sweep trimmed decrypt to 0
  stages). Pipelined native simulations run on the hardware build instead.
- `--sim --native`: Pypeline's own Python simulator, no cocotb/GHDL needed.
  Add `--syn_tb` for the fixed-vector synthesizable-style TB, omit it for the
  random-vector non-synthesizable TB (that style is native-only — see below).
  `--comb` = fast combinational sim; omit for a cycle-accurate pipelined native
  sim, which runs in the profile's hardware build directory on the hardware built
  there (build it first; PipelineC refuses a missing or out-of-date build and
  synthesizes nothing for the testbench).
- `--sim --syn_tb` (no `--native`): cocotb + GHDL against generated VHDL.
  Run the selected design's pipelined check once immediately before an
  explicitly requested final Verilog export. Development uses `--native`
  and synthesized QoR; passing native simulation is sufficient acceptance.
  Do not generate final Verilog or automatically run generated-HDL/compiler
  rendering checks during development. Compiler regressions belong in
  PipelineC's suite. `--comb` is quick; the pipelined form takes hours.
- `--continue`: skip clearing the output dir (`./generated-files/<variant>`;
  every build/measure cache lives under `generated-files/`, named from
  `wireguard_env.GENERATED_FILES` — old `generated-files-<name>` paths in
  records resolve there via `generated_out_dir`). Every build also shares the
  synthesis store `generated-files/syn_cache` (`--syn-cache DIR|none`):
  identical synthesis inputs are reused across profiles and output dirs.
  Keep retained local measurement records and diagnostic outputs under
  `generated-files/` too; use an absolute path there for `measure.py --label`.
  `--out-dir` selects hardware outputs independently of `--syn-cache`, which
  selects the synthesis store. Separate output directories can share a store.
  After interruption preserve good synthesis logs and rename only an identified
  incomplete/error vendor log.

Pass criteria for every sim build: process exits zero — never eyeball logs for
`ERROR`. `*_syn_tb` testbenches call `sim_assert(...)` per check, so a failure
raises immediately (native) or halts GHDL via a VHDL `assert ... severity
failure` (cocotb). The random `*_tb` testbenches print `ERROR:` per mismatch
and an `@final(sim=True)` hook asserts zero errors and every packet checked
once the sim ends. Start-of-run banners/seeds come from `@initial(sim=True)`
hooks (host Python, run by every simulator before the first clock). RNG-based
runs print their seed (`tb_common_sim.DEFAULT_SEED` by default) so a failing
run is reproducible.

**Native vs VHDL cycle-accuracy cross-check** (compares native latency-emulated
sim against real cocotb+GHDL VHDL sim, cycle by cycle, using the `syn_tb`
tops' `sim_print(..., debug=True)` probes):
```bash
pypeline_sim_debug.py ./src/chacha20poly1305_syn_tb.py --sim --run all -D DESIGN=encrypt
```

## Source Layout (mirrors `../pipelinec_build/src/`)

`src/wireguard_env.py` bootstrap · `src/aead_types.py` shared stream/scalar
types (`axis128_intrf`/`axis512_intrf` etc., built via
`stream.stream.make_stream_interface`) · per-component dirs `chacha20/`,
`poly1305/`, `prep_auth_data/`, `auth_tag/`, and `chacha20poly1305/` (the
per-direction dataflow wiring + both testbench styles' shared support:
`aead_ref_model.py`, `tb_common.py`, `tb_common_sim.py`) · top-level
`chacha20poly1305{,_tb,_syn_tb,_perf_tb}.py` (hw / sim-non-synth / sim-synth /
perf tops, each for `-D DESIGN=encrypt|decrypt|shared`). See `README.md`'s "Source Layout"
section for the full per-file breakdown.

## Testbench Styles (every one of the 3 design variants has both)

- **Synthesizable-style** (`*_syn_tb.py`): a `@MAIN` hardware FSM streams/checks
  10 fixed plaintext strings (chosen to hit partial-word/block-boundary corner
  cases), vectors computed once at elaboration by `aead_ref_model.py` and
  baked into `Reg[uint8_t[N]]` arrays (`tb_common.py`). Synthesizable, so it
  runs through cocotb+GHDL for the check immediately before final Verilog export.
- **Non-synthesizable** (`*_tb.py`): uses `@sim_input`/`@sim_output` to
  generate/check 12 random-length (1-1024B) packets live during simulation
  (`tb_common_sim.py`, calling `aead_ref_model.py` lazily per packet), plus a
  tampered-tag reject-path packet. `@sim_input`/`@sim_output` are stripped
  entirely from real hardware elaboration, so this style has **no cocotb/GHDL
  form** — `--native` is the only way to run it.

`-D TB_STRESS=1` selects twenty directed native packets through 2032 bytes,
source gaps and prolonged/periodic output stalls. Decrypt includes a tampered
tag between valid packets and an appended tampered-tag packet. Sources advance
on converged `valid && ready` in `@sim_output`; sinks
count only transfers and assert stable stalled data/keep/last/verification.
The performance testbench uses unpaused sources and always-ready sinks.

`aead_ref_model.py` is a standalone reference model (no pypeline/hardware
imports) using the `cryptography` package, with an RFC 8439 §2.8.2
known-answer self-test at import time — the DUT never validates itself.

## QoR measurement and in-design probes

Use `./measure.py` for the published profile's throughput measurement. It runs
the hardware build first, which PipelineC reports as up to date (no synthesis)
when nothing changed. `--reuse-syn` skips that step and replays the existing
build, which PipelineC refuses when its sources or compiler changed; `--rebuild`
forces a hardware build. `--show-config` on either script prints resolved
settings and paths.
It runs the native perf simulation with that build's actual pipeline latencies
and FSM/MCP schedules, retaining the hardware's fmax and area in
`measurements/<label>/`. Acceptance requires equal encrypt and decrypt MAC
latencies: identical arithmetic must build identically.

Apply this measurement strategy to throughput goals and design comparisons
generally:

- Start with only large payloads (1420 and 1920 bytes), four packets per size
  per direction, concurrent traffic: `--sizes 1420,1920 --packets 4
  --peak-bytes 0 --dirs both`. Measure the three packet-completion intervals;
  cold first-packet latency is a separate metric. Use the fewest packets that
  give a stable rate. Extend only when the observed intervals are inconsistent
  (the current gate allows a 5% spread), then stop when stable. Do not routinely
  add warm-up packets, a 64-packet window or extra samples for functional coverage.
- Reuse verified build artifacts, latency memory and cached schedules. Hints
  are starting suggestions, not proof of timing or the actual built depths.
  Build the real hardware top once if matching artifacts are missing or stale,
  or hardware/compiler/profile changes require it; PipelineC re-synthesizes only
  what changed. Changing only sizes, packet counts or seeds needs
  simulation alone. Never synthesize a testbench to obtain timing or area.
- Keep the independent per-packet reference checks in every perf replay.
  Longer functional, random, stress or soak campaigns are separate verification
  work, run when requested in the task; they are not a reason to increase
  performance packet counts.
- After meeting the large-packet throughput goals,
  collect the small-packet curve for the final README QoR table, also using
  only enough packets for a stable measurement on the existing hardware.

See README's [throughput measurement strategy](README.md#throughput-measurement-strategy)
for commands and interpretation. Every hardware variant shares the store
`generated-files/syn_cache`, which keeps latency memory, AUTO_FSM schedules and
exact synthesis reports; do not substitute an older snapshot or a hints file
for it. Cache warmth need not be identical between profiles for a QoR
comparison; cold-cache build-time measurements are separate, requested work.

Pass the same absolute `--syn-cache` path to build and measure when running
from frozen source copies. Check `built_hardware.json`, `latency_profile.json`
and the early reuse messages (`Up to date`, `Building again: ... changed`)
before allowing unchanged kernels to be characterized again. A `Synthesizing function:`
message may be followed by a restored cached report; distinguish that from an
actual Vivado launch. Investigate unexpected misses in the selected path,
snapshot contents and synthesis signatures; do not bypass compatibility checks
or force fixed latencies. See README's
[cache reuse guidance](README.md#choosing-and-carrying-forward-a-synthesis-cache).

Known block latencies do not replace whole-design timing/area confirmation after
a FIFO or connection change. Report whether running synthesis is block
characterization, schedule search or whole-design confirmation. Without
matching hardware, `measure.py` runs the hardware build and then its perf
simulation. The design-agnostic
half is PipelineC's stream performance library (`include/pypeline/stream/`
`stream_perf.py`, `stream_perf_probe.py`, `stream_bottleneck.py`,
`stream_perf_report.py`, plus `axi/axis_sim.py`'s converged source/sink; guide
`pypeline_stream_perf_guide.md`, metric tests in PipelineC's
`stream_perf_test.py`). WireGuard keeps the phase plan, `-D PERF_*` knobs and
MAIN labels in `perf_tb_common.py`, the block graph/model/report wording in
`bottleneck.py` (`--selftest`-able), and fmax/area parsing, acceptance and
evidence in `measure.py` (`--selftest`-able). Library bugs go to the user, not
a local copy. `aead_types.py`'s FIFO/slice factories use the library's probed
buffers, which report simulation-only occupancy and conservation.

The current accepted QoR profile, full-design resource counts and multiplier
findings are documented in `README.md`, `src/wireguard_env.py` and
`src/poly1305/throughput.md`. Keep defaults tied to that validated record.
Use the actual automatic depths and retained signatures, not a guessed
latency or a stale earlier top. Area and timing come from the external-port
hardware build; records that synthesized the perf testbench (`perf_tb_top`) lost
logic to constant folding and are not comparable. Timing is synthesis evidence
and routed timing is untested. Critical results belong in maintained component docs;
scratch workspaces and investigation reports are local. No separate `tests/` runner
directory or diagnostic build modes are needed; compiler regressions belong
in PipelineC's own suite.

Keep the compiler checkout stable during long builds: run them from a frozen
copy. The current record names its copy in `compiler-snapshot.json` (base
revision and source-tree hash) and archives the uncommitted compiler changes as
`compiler.patch` against that base.

**Internal taps go inside the design's own hardware functions**, via
`from stream import stream_perf_probe as perf_taps`: `perf_taps.hs(name, valid,
ready, keep=None)`, `perf_taps.state(name, reg, NAMES_TUPLE)`,
`perf_taps.arb(...)` (see the guide for `stream_hs`/`occupancy`/`arb_n`). These
are `@sim_output` calls and the elaborator deletes them, so they cost **no
hardware**; they fire once per cycle, Feedback bodies included. Caveat: generated VHDL
embeds source line numbers in comments and signal names, so adding or MOVING a
probe in a hardware source makes the hardware build out of date (the simulation
refuses it) and costs one rebuild; once the probes are in place,
`measure.py --reuse-syn` re-measures in sim time alone. Rules when adding one:

- plain `@hw_func`/`@MAIN` bodies only — an interface function's body (the
  dataflow cores) rejects statements that touch interface values;
- never inside an AUTO_PIPELINE core (`chacha20_loop_body`,
  `poly1305_mac_loop_body`) — probes there see stage-0 samples;
- **state** probes at the TOP of an FSM body (a `Reg` reads back the next state
  once assigned), **handshake** probes at the bottom (every `o.*` field final);
- names are auto-qualified per direction from the executing MAIN
  (`encrypt/poly1305.data_in`) via `perf_tb_common.py`'s
  `stream_perf_probe.MAIN_LABELS.update(...)` (update in place, never rebind),
  so the twice-instantiated FSMs stay separate;
- a new block needs an entry in `bottleneck.py`'s `BLOCKS` to appear in the
  rollup.

**README.md holds only the CURRENT QoR record and analysis** — it is not a
history or change log, and it carries exactly ONE results table: the boundary
QoR table between the `MEASURED-RESULTS` markers. The `BLOCK-RESULTS` region
holds only a generated link to the run's `measurements/<label>/blocks.md`,
which carries the full per-block, FSM-state, bottleneck-evidence, arbitration,
lifecycle, model and buffer tables. Both regions are written by
`./measure.py … --update-readme` (one provenance stamp, from the latest run); the
hand-written `#### Interpretation`
beneath them describes that run in the present tense and is rewritten, not
appended to, when a new run replaces it. Past measured points live only in
their own `measurements/<label>/` directories, and fix histories belong in
git history or component docs, not the README.

See README.md's "Measuring QoR" and "Probing inside the design" sections.

## Wiring Style: interface functions, not hand-threaded `Wire`s

Unlike `../pipelinec_build/`'s C style (module-level `Wire[T]` globals wired
together by outer `@MAIN`s), this port uses Pypeline's plain-function-call
model: a normal function call instantiates a hardware submodule with its own
independent state. Handshake ports are the two halves of a Pypeline
`@interface` (plain fields = feedforward, `Feedback[T]` fields = reverse),
sharing **one name** across a function's args and return struct, suffixed
`_if` (`axis_in_if`, `key_if`, ...) — the `@interface` type itself gets the
`_intrf` suffix so the two never collide.

`chacha20.chacha20_instance`, `poly1305.poly1305_mac_instance`, and the
dataflow cores (`encrypt_dataflow_core.py`/`decrypt_dataflow_core.py`, called
by `{encrypt,decrypt}_dataflow{,_shared}.py`) are **interface functions**:
the body names only the feedforward direction and the pass generates the
`Feedback` wiring (backpressure/`ready` flowing backward, and — where an FSM
consumes a value its own private pipeline produces — feedforward `Feedback`
too). Only the top-level `@MAIN`s cross back out of implied-feedback into
explicit `Wire` assignments, since that's what a hardware top always needs.

Both dataflow cores are `make_{encrypt,decrypt}_dataflow_core(chacha_func, mac_func=None)`
factories (elaboration-time closures), choosing private/shared resources at
elaboration. `chacha20_pipeline_shared.py` and `poly1305_mcp_shared.py` own
the deliberately explicit shared-resource `Wire`/`@MAIN` boundaries. Poly1305
prologue and epilogue arbitration are independent, not a packet ownership lock.

HDL factories return a single primary object. Function factories return the
callable with `.return_t` for its complete hardware result (including input
feedback), not just the output payload. `.in_intrf` / `.out_intrf` describe
stream interfaces; their `.stream_t.typeof("data")` gives the payload type.
Use `.in_fwd_t` / `.out_fb_t` for call arguments.
The shared ChaCha result contract is `chacha20.chacha20_instance.return_t`.
`make_shared_compute` returns a named bundle of `.prologue`, `.epilogue`,
`.powers_t` and `.epilogue_in_t`; its module-level production instance is
`poly1305_mcp_shared.compute`. `make_shared_adapters` returns `.prologue` /
`.epilogue` callables, each with `.return_t`, interface attributes and `.mcp`.
Keep named AUTO groups and function identities when changing this wiring.

Pipelined decrypt has an automatically sized ciphertext FIFO after its fork,
before framing. The selected ChaCha credits and prologue latency drive the
conservative budget in `aead_types.decrypt_auth_fifo_sizing`; the retained
60 MHz profile needs 115 beats, rounded to 128 memory beats plus the FWFT
output register. Read actual pipeline metadata for storage sizing. The
extracted-tag FIFO before comparison holds packet tags, independently of
payload bus width; it prevents the splitter's packet boundary from depending
on an earlier calculated tag. Its factory depth override is for local sizing
experiments; retained metadata and occupancy report actual capacity.
The private/shared ChaCha callables expose their selected `.pipeline_func`;
`make_stream_auto_pipeline` documents `.auto_pipeline` and `.max_in_flight` on
that wrapper as its sizing contract.
Explicit factory depth overrides (including zero) remain available. All MAINs
declare `wireguard_env.TARGET_MHZ`, including disconnected simulation checkers,
so their erased simulation calls cannot leave a `clk_None` constraint.
Pipelined encrypt has
a full two-slot, II=1 output register slice, one unstalled cycle, outside the
MAC body. Legacy has neither new buffer; the common tag packer suppresses a
partial tail until it can merge tag bytes. These adapters live in existing
`aead_types.py`; no new production helper module is necessary.

Gotcha: interface port names become VHDL identifiers and can collide with
enum literals (a port must not be named e.g. `poly_key` if
`POLY_KEY` is an enum member) — native sim/elaboration won't catch this, only
real synthesis will.

See `README.md`'s "Wiring Style" section for the full worked
example (the decrypt dataflow core's body) and the complete conventions list
vs. the C sources.
