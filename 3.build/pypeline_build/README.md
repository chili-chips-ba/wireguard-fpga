# pypeline_build — ChaCha20-Poly1305 AEAD in Pypeline

Pypeline (Python front-end for PipelineC) port of the C designs in
`../pipelinec_build/`. Same three design variants, same synthesizable
testbenches, same Artix-7 xc7a200tffg1156-2 @ 80 MHz target.

The `$PIPELINEC` environment variable must point to the PipelineC executable
(`<PipelineC repo>/src/pipelinec`) before running any build script — both the
scripts and the design files' `sys.path` bootstrap (`src/pypeline_env.py`)
use it to locate the repo (with a fallback to the sibling `../../../PipelineC`
checkout).

## Build Commands

**Native Pypeline sim (fastest — no cocotb/GHDL, Pypeline's own Python
simulator, zero pipeline stages):**
```bash
./build_sim_comb_native.sh         # Combinational sim, encrypt TB  -> generated-files-sim-comb-native/
./build_sim_comb_dec_native.sh     # Combinational sim, decrypt TB  -> generated-files-sim-comb-dec-native/
./build_sim_comb_shared_native.sh  # Combinational sim, shared TB   -> generated-files-sim-comb-shared-native/
```
These don't invoke GHDL/cocotb or generate real VHDL at all, so they're the
quickest correctness check while iterating on the `.py` sources — run these
first, before the slower variants below.

**Simulate with cocotb + GHDL (the designs' acceptance tests):**
```bash
./build_sim_comb.sh         # Combinational sim, encrypt TB  -> generated-files-sim-comb/
./build_sim_comb_dec.sh     # Combinational sim, decrypt TB  -> generated-files-sim-comb-dec/
./build_sim_comb_shared.sh  # Combinational sim, shared TB   -> generated-files-sim-comb-shared/ (slow!)
./build_sim_pipe.sh         # Pipelined sim, encrypt TB      -> generated-files-sim-pipe/ (hours!)
./build_sim_pipe_dec.sh     # Pipelined sim, decrypt TB      -> generated-files-sim-pipe-dec/ (hours!)
./build_sim_pipe_shared.sh  # Pipelined sim, shared TB       -> generated-files-sim-pipe-shared/ (hours!)
```
Pass criteria: no `ERROR` lines anywhere in the output, and per side
`Test 0 DONE!` / `Test 1 DONE!` / `Test 2 DONE!` prints (one per string in
`tb_common.py`'s `PLAINTEXT_TEST_STRS`). The `_pipe` variants run real
autopipelining through the synthesis tool first (like the C
`build_sim_pipe*.sh`), which is what takes hours — see "Wiring Style: Old vs
New" below for why that takes noticeably longer here than in the C design.

**Generate Verilog (for FPGA synthesis):**
```bash
./build_verilog.sh          # Standalone encrypt -> generated-files-verilog/
./build_verilog_decrypt.sh  # Standalone decrypt -> generated-files-verilog-decrypt/
./build_verilog_shared.sh   # Shared encrypt+decrypt -> generated-files-verilog-shared/
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
    tb_common.py                 test strings + on-the-fly generated expected ciphertext/tag
    aead_ref_model.py            pure-Python (no pypeline/hardware dependency) reference
                                  model tb_common.py calls to generate those vectors —
                                  see "Test Vectors" below
    encrypt_tb.py / decrypt_tb.py   synthesizable testbench MAINs
  chacha20poly1305_encrypt.py / _tb.py                    tops (hw / sim)
  chacha20poly1305_decrypt.py / _tb.py
  chacha20poly1305_encrypt_decrypt_shared.py / _tb.py
```

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

`tb_common.py` no longer hardcodes expected ciphertext/tag bytes. It defines
`KEY`/`NONCE`/`AAD_TEST_STR`/`PLAINTEXT_TEST_STRS` (plain Python data — add or
remove a string from `PLAINTEXT_TEST_STRS` and everything else, including
`NUM_PLAINTEXT_TEST_STRS` and both testbenches' array sizes/loop bounds,
follows automatically) and calls `aead_ref_model.generate_encrypt_vector(...)`
per string to compute the expected ciphertext+tag at elaboration time.

`aead_ref_model.py` is a standalone reference model — it does not import
`pypeline`/`chacha20.py`/`poly1305.py` or call into the hardware design at
all, so the DUT is never used to validate itself. It uses the `cryptography`
package for standard ChaCha20, plus a from-scratch transcription of this
design's own Poly1305 limb math (see below for why that math itself is
non-standard). It deliberately reproduces the *current* hardware's behavior,
including the deviation from RFC 8439 described next — not the spec-correct
behavior.

### Known issue: ciphertext length is rounded up, not exact (framing bug)

`encrypt_tb.py`'s input-streaming loop marks all 16 AXI-stream lanes "kept"
on every beat, even the final partial one, only zero-filling the unused
`data` bytes — it never clears `keep`. `chacha20.py`'s `chacha20_loop_body`
XORs the full 64-byte block regardless of `keep` (there's a
`# TODO partial in data, i.e. partial tkeep` marking this unfinished), and
`prep_auth_data.py`'s length accumulator sums `axis128_keep_count(...)`,
which is therefore always the *padded* count. Net effect: ciphertext output
is `ceil(len(plaintext)/16)*16` bytes, not `len(plaintext)`, with the extra
tail bytes being real ChaCha20 keystream (XOR of zero padding). AAD is
unaffected — it's correctly zero-padded to 16 bytes for the MAC only, with
the true `aad_len` in the length field. `aead_ref_model.py` reproduces this
rounding faithfully so today's vectors keep matching; fixing `chacha20.py` /
`prep_auth_data.py` to respect `keep` properly should be paired with
simplifying `generate_encrypt_vector()`'s framing to match (drop the
round-up, use the true length in the Poly1305 length field).

### Known issue: Poly1305's 320-bit multiply is not RFC 8439-correct (a real crypto bug, not just a test-vector quirk)

`poly1305.py`'s `uint320_mul` (ported line-for-line from
`../pipelinec_build/src/poly1305/poly1305.h`, so **this bug is in the
original C too, not something introduced by the pypeline port**) computes
each 64×64-bit limb-pair product and keeps only its low 64 bits — the high
64 bits of every partial product are silently discarded, with just the small
addition-overflow carry propagating to the next limb:

```python
product: uint64_t = a.limbs[i] * b.limbs[j]   # truncated to 64 bits!
...
temp.limbs[i + j] = low                        # high word of the product is lost
```

A correct 320-bit (or any sufficiently wide) schoolbook multiply must carry
the *full* 128-bit product of each 64×64-bit limb pair into position
`i+j` (low half) **and** `i+j+1` (high half). Dropping the high half outright
is not a rounding/precision tradeoff — it silently produces a different,
incorrect large-integer result whenever any single limb×limb product
exceeds 64 bits, which happens routinely once the Poly1305 accumulator grows
across more than a couple of blocks (confirmed while building
`aead_ref_model.py`: a straight, RFC-8439-correct big-integer Poly1305
implementation, validated against the official RFC 8439 §2.5.2/§2.8.2 test
vectors, does **not** reproduce this design's tags at all).

Net effect: **the Poly1305 tag this hardware computes is not the standard,
cryptographically-specified Poly1305 MAC** — it's a different (and weaker/
unvalidated) computation that happens to be internally self-consistent
between this design's own encrypt and decrypt paths, but would not
interoperate with any spec-compliant ChaCha20-Poly1305 peer, and has no
external security analysis behind it. `aead_ref_model.py`'s `uint320_mul`
intentionally mirrors this exact truncation (with one subtlety already fixed
there: `uint320_mod_prime`'s `mul5.limbs[0] = (high_bits >> 2) * 5` step can
itself overflow 64 bits and must be masked mod 2⁶⁴ to match — C's `uint64_t`
does this wrapping implicitly, so it wasn't obvious from reading the C alone)
purely so today's test vectors keep matching; it is not an endorsement of the
math being correct.

**To fix:** `uint320_mul` needs to compute and propagate the full 128-bit
product per limb pair (e.g. split each `a.limbs[i] * b.limbs[j]` into
high/low 64-bit halves and add the high half into `temp.limbs[i+j+1]`, with
carry propagation extended accordingly), in both
`../pipelinec_build/src/poly1305/poly1305.h` and this pypeline
`poly1305.py`. After that fix, `aead_ref_model.py`'s `uint320_mul` should be
simplified to a straightforward correct multiply (or replaced with Python's
native arbitrary-precision integers) to match, and the hardcoded/generated
test vectors will change since the tags will differ from today's.

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
