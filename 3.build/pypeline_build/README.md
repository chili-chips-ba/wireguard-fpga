# pypeline_build — ChaCha20-Poly1305 AEAD in Pypeline

Pypeline (Python front-end for PipelineC) port of the C designs in
`../pipelinec_build/`. Same three design variants, same Artix-7
xc7a200tffg1156-2 @ 80 MHz target — but with the C originals' Poly1305 math
and ciphertext-length bugs fixed, so this port is RFC 8439-conformant and its
tags/ciphertext lengths deliberately differ from the (still-unfixed) C
designs (see "Test Vectors" below).

Each of the three design variants has **two testbench styles**: a
synthesizable-style testbench (fixed vectors, compiles through cocotb/GHDL or
real hardware) and a non-synthesizable testbench (`@sim_input`/`@sim_output`,
on-the-fly random vectors, native sim only) — see "Testbench Styles" below.

The `$PIPELINEC` environment variable must point to the PipelineC executable
(`<PipelineC repo>/src/pipelinec`) before running any build script — both the
scripts and the design files' `sys.path` bootstrap (`src/pypeline_env.py`)
use it to locate the repo (with a fallback to the sibling `../../../PipelineC`
checkout).

## Build Commands

**Native Pypeline sim — non-synthesizable testbench (fastest to iterate on;
`@sim_input`/`@sim_output`, on-the-fly random vectors — see "Testbench
Styles" below):**
```bash
./build.py --enc --sim --comb --native     # Combinational sim, encrypt TB  -> generated-files-sim-comb-enc-native/
./build.py --dec --sim --comb --native     # Combinational sim, decrypt TB  -> generated-files-sim-comb-dec-native/
./build.py --shared --sim --comb --native  # Combinational sim, shared TB   -> generated-files-sim-comb-shared-native/
```
These don't invoke GHDL/cocotb or generate real VHDL at all, and this
testbench style has no cocotb/GHDL or `_pipe` equivalent (see "Testbench
Styles" below for why) — this is the only way to run it. Pass criteria: no
`ERROR` lines, and per side one `Test N DONE!` print per randomly generated
packet (`tb_common_sim.NUM_RANDOM_PACKETS`, currently 10, `Test 0 DONE!` …
`Test 9 DONE!`), plus one extra decrypt-side `Test 10 DONE!` for the
tampered-tag negative packet. The RNG seed in use is printed at the start of
each run (`tb_common_sim.DEFAULT_SEED` by default) so a failing run's exact
vectors can be reproduced.

**Native Pypeline sim — synthesizable-style testbench (fixed vectors; no
cocotb/GHDL, Pypeline's own Python simulator, zero pipeline stages):**
```bash
./build.py --enc --sim --syn_tb --comb --native     # Combinational sim, encrypt TB  -> generated-files-syn-tb-comb-enc-native/
./build.py --dec --sim --syn_tb --comb --native     # Combinational sim, decrypt TB  -> generated-files-syn-tb-comb-dec-native/
./build.py --shared --sim --syn_tb --comb --native  # Combinational sim, shared TB   -> generated-files-syn-tb-comb-shared-native/
```
Quickest correctness check for the synthesizable-style testbench while
iterating on the `.py` sources — run these before the slower cocotb/GHDL
variants below.

**Simulate with cocotb + GHDL (the designs' acceptance tests — synthesizable-style
testbench only, see "Testbench Styles" below):**
```bash
./build.py --enc --sim --syn_tb --comb     # Combinational sim, encrypt TB  -> generated-files-syn-tb-comb-enc/
./build.py --dec --sim --syn_tb --comb     # Combinational sim, decrypt TB  -> generated-files-syn-tb-comb-dec/
./build.py --shared --sim --syn_tb --comb  # Combinational sim, shared TB   -> generated-files-syn-tb-comb-shared/ (slow!)
./build.py --enc --sim --syn_tb            # Pipelined sim, encrypt TB      -> generated-files-syn-tb-pipe-enc/ (hours!)
./build.py --dec --sim --syn_tb            # Pipelined sim, decrypt TB      -> generated-files-syn-tb-pipe-dec/ (hours!)
./build.py --shared --sim --syn_tb         # Pipelined sim, shared TB       -> generated-files-syn-tb-pipe-shared/ (hours!)
```
Pass criteria: no `ERROR` lines anywhere in the output, and per side one
`Test N DONE!` print per string in `tb_common.py`'s `PLAINTEXT_TEST_STRS`
(currently 8, `Test 0 DONE!` … `Test 7 DONE!`), plus one extra decrypt-side
`Test 8 DONE!` for the corrupted-tag negative packet (see "Test Vectors"
below). The `_pipe` variants run real
autopipelining through the synthesis tool first (like the C
`build_sim_pipe*.sh`), which is what takes hours — see "Wiring Style: Old vs
New" below for why that takes noticeably longer here than in the C design.

**Generate Verilog (for FPGA synthesis):**
```bash
./build.py --enc      # Standalone encrypt     -> generated-files-verilog-encrypt/
./build.py --dec      # Standalone decrypt     -> generated-files-verilog-decrypt/
./build.py --shared   # Shared encrypt+decrypt -> generated-files-verilog-shared/
```

## Source Layout (mirrors ../pipelinec_build/src/)

```
src/
  pypeline_env.py               sys.path bootstrap (import first in every file)
  aead_types.py                 shared sizes/types (axis128/axis512, streams, null helpers)
  chacha20/
    chacha20.py                 ChaCha20 math + pipeline-control FSM + chacha20_instance
                                 (FSM and stream pipeline merged into one function; chacha20.h)
    chacha20_pipeline_shared.py the one shared pipeline + round-robin mux, merged into one
                                 function, plus chacha20_encrypt_shared/chacha20_decrypt_shared
                                 (the shared design's per-direction instances that read/write
                                 this file's Wires — chacha20_pipeline_shared.c)
  poly1305/
    poly1305.py                 u320 limb math + MAC FSM + poly1305_mac_instance
                                 (FSM and MCP compute merged into one function; poly1305.h)
    poly1305_verify_decrypt.py  tag comparison FSM
  prep_auth_data/
    prep_auth_data.py           AAD||ciphertext||lengths framing FSM (prep_auth_data_fsm,
                                 called directly by both directions; prep_auth_data.h)
  auth_tag/
    append_auth_tag.py          append tag after ciphertext (encrypt output)
    strip_auth_tag.py           split tag off ciphertext (decrypt input, early-tlast buffer)
    wait_to_verify.py           128-deep FIFO + wait-for-verdict FSM, merged into one
                                 function, holding plaintext until tag verdict
  chacha20poly1305/
    chacha20poly1305_encrypt_ports.py   DUT-facing global wires (the .h wires)
    chacha20poly1305_encrypt_hw_io.py   flattened Input[]/Output[] ports + io conversion MAIN
    chacha20poly1305_decrypt_ports.py / chacha20poly1305_decrypt_hw_io.py
    encrypt_dataflow_core.py / decrypt_dataflow_core.py   make_encrypt_dataflow_core /
                                 make_decrypt_dataflow_core: factories returning the direct-call
                                 dataflow graph, parameterized by which chacha20 instance feeds
                                 it (see "Wiring Style: Old vs New" below)
    encrypt_dataflow.py / decrypt_dataflow.py            standalone wiring MAINs (80 MHz):
                                 instantiate the factory with chacha20.chacha20_instance
    encrypt_dataflow_shared.py / decrypt_dataflow_shared.py  shared design: instantiate the
                                 same factory with chacha20_pipeline_shared's
                                 chacha20_encrypt_shared / chacha20_decrypt_shared
    tb_common.py                 synthesizable-style testbench's fixed 8-string vectors,
                                  computed once at elaboration time
    tb_common_sim.py             non-synthesizable testbench's shared support: fixed
                                  KEY/NONCE/AAD + on-the-fly random-packet-length helper
                                  (no precomputed vectors — those are generated lazily,
                                  per packet, during simulation)
    aead_ref_model.py            pure-Python (no pypeline/hardware dependency) reference
                                  model both tb_common.py and tb_common_sim.py call to
                                  generate vectors — see "Test Vectors" below
    encrypt_syn_tb.py / decrypt_syn_tb.py   synthesizable-style testbench MAINs (fixed
                                  vectors, cocotb/GHDL/pipe-compatible)
    encrypt_tb.py / decrypt_tb.py           non-synthesizable testbench MAINs
                                  (@sim_input/@sim_output, on-the-fly random vectors,
                                  native sim only) — see "Testbench Styles" below
  chacha20poly1305_encrypt.py / _tb.py / _syn_tb.py                    tops (hw / sim non-synth / sim synth)
  chacha20poly1305_decrypt.py / _tb.py / _syn_tb.py
  chacha20poly1305_encrypt_decrypt_shared.py / _tb.py / _syn_tb.py
```

## Testbench Styles: Synthesizable vs Non-Synthesizable

Each of the three design variants has two independent testbenches, sharing
the same DUT-facing `*_ports.py` wires but differing entirely in how
stimulus is generated and outputs checked:

- **Synthesizable-style** (`encrypt_syn_tb.py`/`decrypt_syn_tb.py`, driven by
  the `_syn_tb.py` tops): a `@MAIN` hardware state machine streams/checks a
  fixed batch of test vectors — 8 plaintext strings, chosen to cover the
  partial-final-word and block-boundary corner cases — computed once via
  `aead_ref_model.py` at elaboration time and baked into fixed-size
  `Reg[uint8_t[N]]` hardware register arrays (`tb_common.py`). Because this
  testbench is itself synthesizable Pypeline, it can run through cocotb+GHDL
  against real generated VHDL, or through real autopipelining (`_pipe`
  builds) — these are the designs' acceptance tests.
- **Non-synthesizable** (`encrypt_tb.py`/`decrypt_tb.py`, driven by the plain
  `_tb.py` tops): uses Pypeline's `@sim_input`/`@sim_output` decorators to
  generate stimulus and check outputs as arbitrary Python, live,
  cycle-by-cycle during simulation. Each run generates 10 random-length
  (1-1024 byte) packets per direction on the fly — a few pinned to the same
  corner-case lengths as the fixed vectors, the rest uniform-random — calling
  `aead_ref_model.py` lazily, once per packet, right when that packet's
  random plaintext is generated (`tb_common_sim.py`), rather than batching
  everything up front. No fixed-size arrays, no elaboration-time
  pre-baking — packets can be any length. The decrypt side adds an 11th
  packet with a deliberately bit-flipped tag (reject-path coverage,
  mirroring the synthesizable variant's fixed tampered-tag packet). The RNG
  is seeded by default (`tb_common_sim.DEFAULT_SEED`) and the seed is printed
  at the start of each run, so a failing run's exact vectors are
  reproducible.

  `@sim_input`/`@sim_output` calls are entirely invisible to the hardware
  elaborator — skipped unconditionally, whether or not `--sim` is passed —
  so this style **only runs under Pypeline's native `--sim` mode**. Routing
  it through `--cocotb --ghdl` would first generate real VHDL with every
  `@sim_input`/`@sim_output` call site stripped out, leaving no stimulus
  generation or output checking left anywhere; the same reasoning rules out
  a `_pipe` (real-autopipelining) variant, since `_pipe` builds are
  exclusively cocotb+GHDL runs against post-autopipelining VHDL in this
  repo. Use this style for fast iteration and broader random coverage; use
  the synthesizable style for the cocotb/GHDL and `_pipe` acceptance tests.

## Wiring Style: Old vs New

This port originally followed the same style as the C source in
`../pipelinec_build/`: every "module" was a set of module-level `Wire[T]`
globals plus one or more `@MAIN`s, and modules were wired together by an
outer `@MAIN` reading one module's output globals and writing them into
another module's input globals. Two variants of this existed:

- **Cross-module wiring**: `encrypt_dataflow.py`/`decrypt_dataflow.py` took
  ~20 scalar arguments' worth of globals from chacha20/prep_auth_data/
  poly1305_mac/append_auth_tag and scattered results back onto other files'
  globals — the actual dataflow graph was only visible by reading the
  field-name conventions, not a normal call graph.
- **Same-module FSM+datapath split**: chacha20, poly1305_mac, and
  wait_to_verify were each *two* `@MAIN`s (an FSM plus a separate pipelined/
  FIFO datapath instance) joined by more `Wire`s, when they could be one
  function with the datapath call inlined directly.

Pypeline's plain-function-call model replaces both: a normal (non-`@MAIN`)
function call already instantiates a hardware submodule, with each call site
getting its own independent state — no global wires required. The current
source uses this directly:

- **Direct calls chained with `Feedback[T]`**: `encrypt_dataflow_core.py`/
  `decrypt_dataflow_core.py` call `chacha_func`, `prep_auth_data.prep_auth_data_fsm`,
  `poly1305.poly1305_mac_instance`, `append_auth_tag.append_auth_tag` (etc. for
  decrypt) directly, chaining struct fields from one call into the next
  call's arguments. Data flows forward through the chain but backpressure
  (`ready`) flows backward, so wherever a downstream call's `ready` output is
  needed as an upstream call's input, a `Feedback[T]` local — a same-cycle
  combinational signal whose driving assignment textually follows its first
  read — declares that signal before either call, lets both calls happen,
  then drives it from the result.
- **FSM+datapath merges**: `chacha20.chacha20_instance`,
  `poly1305.poly1305_mac_instance`, and `wait_to_verify.wait_to_verify` each
  merge what used to be an FSM `@MAIN` and a datapath `@MAIN` into one
  function, using the same `Feedback[T]` pattern for the pair's mutual
  same-cycle dependency. This is safe because `make_stream_pipeline`/
  `make_valid_ready_mcp`/`make_stream_fifo` (the library wrappers backing
  the datapath side) already do their own internal `autopipeline(...)`
  wrapping and expose purely `Reg`-driven `ready` outputs — so this is an
  ordering fix, not a new combinational loop.
- **Factory functions for the one real axis of variation**: chacha20 is the
  only component whose concrete instance differs between the standalone
  build (owns a private pipeline) and the shared build (uses an arbitrated
  pipeline shared between encrypt and decrypt). Rather than keep it as a
  special external-argument exception, `encrypt_dataflow_core.py`/
  `decrypt_dataflow_core.py` are `make_encrypt_dataflow_core(chacha_func)`/
  `make_decrypt_dataflow_core(chacha_func)` factories — elaboration-time
  Python closures, the same idiom `chacha20.py`'s `make_quarter_round` and
  Pypeline's own `make_stream_pipeline`/`make_valid_ready_mcp` already use.
  `encrypt_dataflow.py` instantiates the factory once with
  `chacha20.chacha20_instance`; `encrypt_dataflow_shared.py` instantiates the
  same factory with `chacha20_pipeline_shared.chacha20_encrypt_shared`.
- **The one deliberate remaining `Wire` boundary**: `chacha20_pipeline_shared.py`
  still exposes 8 `Wire`s and stays a separate `@MAIN`, because it's a
  genuinely arbitrated resource shared across two otherwise-independent
  dataflow graphs (encrypt and decrypt don't call each other or share any
  other state) — not an artifact of the old wiring style.

**Measured tradeoff (real autopipelining, `_pipe` builds):** collapsing the
old `Wire`/`@MAIN` seams removed pipeline-register cut points that PipelineC's
autopipelining sweep used to get for free — each old seam was already its own
small, independently-timed retiming problem. With everything chained by
direct calls, the whole dataflow graph (chacha20 core included, for the
standalone builds) becomes one large combinational region that the sweep
must slice from scratch, and its coarse-grained "guess a slice count from
total path delay" heuristic can't tell a single slow submodule apart from
many evenly-slow ones. In practice this meant the standalone encrypt/decrypt
`_pipe` builds needed roughly 3x more synthesis iterations and gave up at the
whole-graph level at least once, falling back to slicing chacha20's
submodules individually before the top level converged — costing about 2x
the wall-clock time of the old structure (~1h vs ~2.5h each). The shared
build was less affected (~1.5x) since `chacha20_pipeline_shared` kept its
`Wire` boundary and so the crypto core was never folded into the larger
region. Final synthesized behavior is cycle-identical in both styles (verified
via cocotb sim after the real autopipelining pass) — the cost is purely
extra build-time search, not a functional regression.

## Test Vectors

### Synthesizable-style Testbench

`tb_common.py` no longer hardcodes expected ciphertext/tag bytes. It defines
`KEY`/`NONCE`/`AAD_TEST_STR`/`PLAINTEXT_TEST_STRS` (plain Python data — add or
remove a string from `PLAINTEXT_TEST_STRS` and everything else, including
`NUM_PLAINTEXT_TEST_STRS` and both testbenches' array sizes/loop bounds,
follows automatically) and calls `aead_ref_model.generate_encrypt_vector(...)`
per string to compute the expected ciphertext+tag at elaboration time.

`aead_ref_model.py` is a standalone reference model — it does not import
`pypeline`/`chacha20.py`/`poly1305.py` or call into the hardware design at
all, so the DUT is never used to validate itself. It is simply standard
RFC 8439 ChaCha20-Poly1305 via the `cryptography` package, with an
import-time known-answer self-test against the official RFC 8439 §2.8.2 AEAD
test vector (so a broken `cryptography` install fails loudly at elaboration
rather than as unexplained testbench `ERROR`s).

The test strings' byte lengths (56, 71, 58, 3, 16, 17, 64, 128) deliberately
cover the partial-final-word and block corner cases: shorter than one
16-byte AXIS word, exactly one word, one word plus one byte, several
mid-word endings, exactly one 64-byte ChaCha20 block, and the 128-byte
maximum (a multiple of both 16 and 64). Both testbenches check the exact
per-lane `keep` pattern and packet framing (`eod` only on the auth tag word
for encrypt output / on the final plaintext word for decrypt output), not
just the data bytes.

The decrypt testbench additionally replays test string 0's ciphertext with a
deliberately corrupted auth tag (`tb_common.TAMPERED_TAG`) as an extra final
packet: the DUT must still emit that packet's plaintext but with
`is_verified_out` low — exercising the Poly1305 verify path's reject case,
which the all-valid vectors never hit.

### Test Vectors — Non-synthesizable Testbench

`tb_common_sim.py` reuses the same fixed `KEY`/`NONCE`/`AAD` as
`tb_common.py`, but does not precompute any ciphertext/tag vectors — instead
it holds `NUM_RANDOM_PACKETS = 10`, the `PACKET_LEN_MIN`/`PACKET_LEN_MAX`
range (1-1024 bytes), the stratified `CORNER_CASE_LENS` list (`[16, 17, 64,
128]`, matching the synthesizable variant's coverage of the partial-final-
word and block-boundary cases) and `DEFAULT_SEED`. `encrypt_tb.py`/
`decrypt_tb.py` call `next_packet_length(rng, packet_idx)` and
`aead_ref_model.generate_encrypt_vector(...)` live, during simulation, right
when each packet's random plaintext is generated: the first
`len(CORNER_CASE_LENS)` packets each run are pinned to those lengths
(guaranteed every run), the rest are uniform-random over
`[PACKET_LEN_MIN, PACKET_LEN_MAX]`.

The decrypt testbench's 11th packet mirrors the synthesizable variant's
tampered-tag negative test: a genuinely valid packet (fresh random
plaintext, real ciphertext+tag from the reference model) with one tag bit
flipped after generation — the DUT must still emit that packet's plaintext
but with `is_verified_out` low.

The RNG (`random.Random(seed)`) is seeded by default
(`tb_common_sim.DEFAULT_SEED`); the seed actually used is printed via
`sim_print` at the start of each run, so a failing run's exact packet
lengths/content can be reproduced by re-seeding with the same value. Unlike
the fixed-vector synthesizable testbench, the exact bytes streamed differ
every run (only the pinned corner-case lengths and packet/test count are
constant) — the `ERROR`-free / `Test N DONE!` convention itself is the fixed,
diffable pass criterion here, not any particular byte sequence.

### Fixed: exact ciphertext length via real `keep` handling (was: rounded up to 16 bytes)

The design used to output `ceil(len(plaintext)/16)*16` ciphertext bytes
(encrypting its own zero padding) because the testbench marked all 16 lanes
of the final input word "kept" and `chacha20.py`'s `chacha20_loop_body` XORed
the full 64-byte block regardless of `keep`. Now the testbenches drive exact
per-lane `keep` on the final (partial) word of each packet, `keep` flows
through the whole datapath (the dwidth converters and every FSM already
passed it through correctly), `chacha20_loop_body` XORs only kept lanes
(forcing non-kept lanes to zero so raw keystream bytes never leak
downstream), and `prep_auth_data.py`'s keep-bit length accumulator therefore
authenticates the *true* ciphertext length in the Poly1305 length field, per
RFC 8439. The auth tag is a separate full 16-byte word appended after the
final (possibly partial) ciphertext word, which is exactly how the decrypt
testbench frames its input in return.

### Fixed: Poly1305 320-bit math is now RFC 8439-correct

`poly1305.py`'s limb math (originally ported line-for-line from
`../pipelinec_build/src/poly1305/poly1305.h`) had three interlocking bugs
that made its tag a non-standard MAC — internally self-consistent between
this design's own encrypt and decrypt paths, but not interoperable with any
spec-compliant ChaCha20-Poly1305 peer:

1. `uint320_mul` truncated each 64×64-bit limb-pair product to its low 64
   bits, discarding the high word (only addition-overflow carries propagated
   between limbs).
2. `uint320_mod_prime` used a wrong "bits below 2^130 within limb 2" mask
   (`0x3FFFFFFFFFF`, 42 bits, instead of `0x3` — 2^130 is bit 2 of limb 2).
3. `uint320_mod_prime` discarded limbs 3 and 4 outright instead of folding
   them back in (harmless while bug 1 kept products artificially small, but
   a real bug once the multiply is correct and products reach limb 3).

All three are fixed here: `uint320_mul` now accumulates the full 128-bit
product per limb pair with a standard carry chain, and `uint320_mod_prime`
does three `uint320_fold` partial-reduction passes (`x = q*2^130 + rem ->
rem + 5*q`, folding *all* bits at/above 2^130 from every limb) which bring
any 320-bit value strictly below 2^130 before the final conditional subtract
of `2^130 - 5`. The fixed math was validated against a big-integer Poly1305
reference on thousands of random inputs and, end-to-end through the
testbenches, against the `cryptography` package and the RFC 8439 §2.8.2
known-answer vector (see `aead_ref_model.py`).

**The C original still has all of these bugs** —
`../pipelinec_build/src/poly1305/poly1305.h` (math bugs) and the C
testbenches' padded-length framing — so this pypeline port now deliberately
diverges from the C: the two produce different tags and different ciphertext
lengths, and the C design's hardcoded test vectors do not apply here.

Conventions vs the C sources:

- C's `#define INST_NAME` + re-`#include` per-instance trick, where it still
  applies (the ports/hw_io modules, and `chacha20_pipeline_shared.py`'s
  Wires), becomes a module-name prefix on the global wire name (e.g.
  `chacha20_pipeline_shared.py`'s `encrypt_pipeline_in` elaborates as
  `chacha20_pipeline_shared_encrypt_pipeline_in`). Elsewhere it's gone
  entirely — plain function calls give each call site its own independent
  state without needing per-instance wires at all (see "Wiring Style: Old vs
  New" above).
- C's `#ifndef SIMULATION` hardware ports become separate `*_hw_io.py` modules
  imported only by the hardware tops (the sim TB tops omit them).
- `GLOBAL_VALID_READY_PIPELINE_INST` / `GLOBAL_VALID_READY_MCP_INST` /
  `GLOBAL_STREAM_FIFO` become `make_stream_pipeline` / `make_valid_ready_mcp` /
  `make_stream_fifo` instances, called directly from the function they back
  (`chacha20.chacha20_instance`, `poly1305.poly1305_mac_instance`,
  `wait_to_verify.wait_to_verify`) rather than wired up in a separate `@MAIN`
  — except `chacha20_pipeline_shared.py`, which is the one case that
  legitimately stays a dedicated `@MAIN` (see above).
- Every top `.py` imports ALL hardware modules explicitly (sub-module imports
  are not followed for hardware elaboration).
- MAINs compute into locals and drive each global wire exactly once at the end
  (a function may not both read and write the same wire).
- Cross-module wire references (`module.wire`) support nested field/array
  access (`module.wire.field`, `other_module.wire.arr[i]`) directly, at
  arbitrary depth. An earlier version of this port avoided that syntax (a
  compiler limitation at the time restricted cross-module access to whole
  wires only), staging a local copy of the wire first purely to read/write
  its fields; that limitation is fixed upstream and the local-copy workaround
  has been removed.
