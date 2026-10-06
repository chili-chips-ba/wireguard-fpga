# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pypeline (Python front-end for PipelineC) port of the C ChaCha20-Poly1305 AEAD
designs in `../pipelinec_build/`. Three design variants target Artix-7
xc7a200tffg1156-2: pipelined Poly1305 with both resources shared at **60 MHz**
by default; other pipelined selections default to 30 MHz, legacy to 80 MHz.
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
`src/`/`include/pypeline/` onto `sys.path`.

## Build Commands

Run from `pypeline_build/` (not `src/`):

```bash
./build.py --enc|--dec|--shared [--sim [--syn_tb] [--comb] [--native]] [--continue]
```

- No design selector or `--shared` shares ChaCha20 and Poly1305 prologue/epilogue
  MCPs, while body pipelines and packet contexts stay private. Explicit
  `--share-chacha20` / `--share-poly1305` select the complete sharing set;
  both selects both. These cannot be combined with `--enc`/`--dec`.
- `--poly1305 legacy` requires `--share-chacha20` for combined builds.
  `--target-mhz {30,40,50,60,70,80}` overrides the default clock.
  Automatic compute blocks use clock-profile starting hints, not fixed or
  maximum latencies. Cache identities include architecture, sharing and clock.
- No `--sim`: generate final Verilog (`--enc`/`--dec`/`--shared` select
  `src/chacha20poly1305_{encrypt,decrypt,encrypt_decrypt_shared}.py`).
- `--sim --native`: Pypeline's own Python simulator, no cocotb/GHDL needed.
  Add `--syn_tb` for the fixed-vector synthesizable-style TB, omit it for the
  random-vector non-synthesizable TB (that style is native-only — see below).
  `--comb` = fast combinational sim; omit for a slow but cycle-accurate
  pipelined native sim (runs real autopipelining first to discover latencies).
- `--sim --syn_tb` (no `--native`): the real acceptance test — cocotb + GHDL
  against generated VHDL. `--comb` is quick; the pipelined form takes hours.
- `--continue`: skip clearing the output dir (`./generated-files/<variant>`;
  every build/measure cache lives under `generated-files/`, named from
  `poly1305_config.GENERATED_FILES` — old `generated-files-<name>` paths in
  records resolve there via `generated_out_dir`).
  `--out-dir` selects an isolated cache; after interruption preserve good
  synthesis logs and rename only an identified incomplete/error vendor log.

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
pypeline_sim_debug.py ./src/chacha20poly1305_encrypt_syn_tb.py --sim --run all
```

## Source Layout (mirrors `../pipelinec_build/src/`)

`src/wireguard_env.py` bootstrap · `src/aead_types.py` shared stream/scalar
types (`axis128_intrf`/`axis512_intrf` etc., built via
`stream.stream.make_stream_interface`) · per-component dirs `chacha20/`,
`poly1305/`, `prep_auth_data/`, `auth_tag/`, and `chacha20poly1305/` (the
per-direction dataflow wiring + both testbench styles' shared support:
`aead_ref_model.py`, `tb_common.py`, `tb_common_sim.py`) · top-level
`chacha20poly1305_{encrypt,decrypt,encrypt_decrypt_shared}{,_tb,_syn_tb}.py`
(hw / sim-non-synth / sim-synth tops). See `README.md`'s "Source Layout"
section for the full per-file breakdown.

## Testbench Styles (every one of the 3 design variants has both)

- **Synthesizable-style** (`*_syn_tb.py`): a `@MAIN` hardware FSM streams/checks
  10 fixed plaintext strings (chosen to hit partial-word/block-boundary corner
  cases), vectors computed once at elaboration by `aead_ref_model.py` and
  baked into `Reg[uint8_t[N]]` arrays (`tb_common.py`). Synthesizable, so it
  runs through cocotb+GHDL — this is the acceptance test.
- **Non-synthesizable** (`*_tb.py`): uses `@sim_input`/`@sim_output` to
  generate/check 12 random-length (1-1024B) packets live during simulation
  (`tb_common_sim.py`, calling `aead_ref_model.py` lazily per packet), plus a
  tampered-tag reject-path packet. `@sim_input`/`@sim_output` are stripped
  entirely from real hardware elaboration, so this style has **no cocotb/GHDL
  form** — `--native` is the only way to run it.

`WG_TB_STRESS=1` selects sixteen directed native packets through 1920 bytes,
source gaps and prolonged/periodic output stalls, plus decrypt's tampered-tag
packet. Sources advance on converged `valid && ready` in `@sim_output`; sinks
count only transfers and assert stable stalled data/keep/last/verification.
The performance testbench uses unpaused sources and always-ready sinks.

`aead_ref_model.py` is a standalone reference model (no pypeline/hardware
imports) using the `cryptography` package, with an RFC 8439 §2.8.2
known-answer self-test at import time — the DUT never validates itself.

## QoR measurement and in-design probes

`./measure.py` is the one automated (fmax, area, throughput, latency) step; it
runs `./build.py --shared --perf` (autopipeline + native sim of exactly what it
built) and merges everything into `measurements/<label>/`. The design-agnostic
half is PipelineC's stream performance library (`include/pypeline/stream/`
`stream_perf.py`, `stream_perf_probe.py`, `stream_bottleneck.py`,
`stream_perf_report.py`, plus `axi/axis_sim.py`'s converged source/sink; guide
`pypeline_stream_perf_guide.md`, metric tests in PipelineC's
`stream_perf_test.py`). WireGuard keeps the phase plan, `WG_PERF_*` knobs and
MAIN labels in `perf_tb_common.py`, the block graph/model/report wording in
`bottleneck.py` (`--selftest`-able), and fmax/area parsing, acceptance and
evidence in `measure.py` (`--selftest`-able). Library bugs go to the user, not
a local copy. `aead_types.py`'s FIFO/slice factories use the library's probed
buffers, which report simulation-only occupancy and conservation.
`measure.py --out-dir ... --reuse-syn` can retain an isolated cache.

The current buffered 60 MHz QoR and compact native evidence are in
`measurements/shared-60mhz-poly1305-pipelined-share-chacha20-poly1305-decrypt-recovery-20261005/`.
Use its actual automatic depths and retained signatures, not a guessed
latency or a stale earlier top. Area is performance-testbench area and timing
is synthesis evidence, not new DUT-only area or routed sign-off. Critical
results belong in `measurements/` or component docs; `validation/` is a
disposable local workspace and is not committed. No separate `tests/` runner
directory or diagnostic build modes are needed; compiler regressions belong
in PipelineC's own suite.

**Internal taps go inside the design's own hardware functions**, via
`from stream import stream_perf_probe as perf_taps`: `perf_taps.hs(name, valid,
ready, keep=None)`, `perf_taps.state(name, reg, NAMES_TUPLE)`,
`perf_taps.arb(...)` (see the guide for `stream_hs`/`occupancy`/`arb_n`). These
are `@sim_output` calls and the elaborator deletes them, so they cost **no
hardware**; they fire once per cycle, Feedback bodies included. Caveat: generated VHDL
embeds source line numbers in comments and signal names, so adding or MOVING a
probe shifts those and costs one re-synthesis of the enclosing hierarchy; once
the probes are in place, `measure.py --reuse-syn` re-measures in sim time alone
as before. Rules when adding one:

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

Pipelined decrypt has a 64-memory-beat ciphertext FIFO after its fork, before
framing (65 slots including the FWFT output register). Pipelined encrypt has
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
