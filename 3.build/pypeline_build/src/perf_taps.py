# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""In-design performance probes: the pypeline-side half of the QoR tap system.

Boundary measurement (chacha20poly1305/{encrypt,decrypt}_perf_tb.py) answers
"how fast is the design". These probes answer "which block is holding it up" --
they are called from inside the design's OWN hardware functions
(poly1305_mac_fsm, chacha20_fsm, prep_auth_data_fsm, chacha20_pipeline_shared,
...), passing that block's handshake and FSM-state signals straight out to the
plain-Python counters in chacha20poly1305/perf_probe.py.

WHY THIS COSTS NO HARDWARE
--------------------------
Every function here is `@sim_output`-decorated, and the hardware elaborator
DELETES calls to those: PipelineC/src/PY_TO_LOGIC.py's _elab_stmt turns a call
to a function carrying `_is_sim_output` into `pass`, and such functions are
excluded from the top-level "elaborate every annotated function" sweep. So the
elaborated design is bit-identical with the probes present, pypelinec re-reads
its cached hash-named vivado_*.log files, and ./measure.py --reuse-syn still
re-measures in sim time alone -- which matters a lot when a fresh autopipelining
sweep is 1-3 hours and the sim itself is ~0.8 s/cycle.

The argument expressions are never elaborated either (the whole statement is
skipped), so a probe may be handed anything -- a `keep` array to popcount, a
Python tuple of state names -- without that turning into logic.

WHERE PROBES MAY GO
-------------------
1. Plain `@hw_func`/`@MAIN` bodies only. An interface function's body (the
   dataflow cores) cannot host them: PipelineC's interface_func pass rejects any
   plain statement referencing an interface value ("interface values may only be
   produced by calls and consumed as call arguments"). Not a limitation in
   practice -- every signal worth probing is a local or port inside some plain
   hw_func.
2. Stateful, zero-latency contexts only -- never inside an AUTO_PIPELINE core
   (chacha20_loop_body, poly1305_mac_loop_body) or a pipelined pure MAIN, where
   native sim's delay-line model would report stage-0 samples and the cycle
   alignment vs real VHDL would be wrong. See PipelineC/docs/README.md's
   "probe rules". Every call site in this design is an FSM or the stateful
   chacha20_pipeline_shared MAIN, which native sim never delays.

PER-INSTANCE NAMING
-------------------
poly1305_mac_fsm, chacha20_fsm and prep_auth_data_fsm are each instantiated
TWICE in the shared design (once per direction), so a bare tap name would merge
both. During the final (converged) pass of each cycle, pypeline_sim.py sets
`pypeline._sim_current_main` to the MAIN being executed, so a probe knows which
direction's graph it is running inside and qualifies its name with it:

    encrypt/poly1305.data_in     decrypt/poly1305.data_in     shared/pipe.enc_in

Names are resolved to a tap object once and cached, so a live probe costs one
dict hit per cycle and a disabled one costs a no-op call.

ENABLEMENT
----------
$WG_PERF_TAPS (set by measure.py --taps) selects which taps are live: exact
names, a `<label>/` or `<block>` prefix, or the literal "all". Everything else
is a NullTap.
"""

import wireguard_env  # noqa: F401

import os

import pypeline
from pypeline import sim_input, sim_output

from perf_probe import ArbTap, HandshakeTap, StateTap, TapRegistry

# One registry per run, created ONCE and only ever mutated in place: a
# @sim_output body executes against a rebuilt, detached copy of its module's
# globals (see pypeline.sim_output's docstring), so rebinding this name later
# would leave the probes writing into an orphaned object. perf_tb_common.py
# calls REGISTRY.enable(...) rather than replacing it for exactly this reason.
REGISTRY = TapRegistry(
    t for t in os.environ.get("WG_PERF_TAPS", "").replace(" ", "").split(",") if t
)

# MAIN name -> short label used to qualify tap names. Anything unlisted falls
# back to the MAIN's own name, so a new top still produces usable tap names.
_MAIN_LABELS = {
    "encrypt_dataflow_shared": "encrypt",
    "decrypt_dataflow_shared": "decrypt",
    "encrypt_dataflow": "encrypt",
    "decrypt_dataflow": "decrypt",
    "chacha20_pipeline_shared": "shared",
}


def _qualified(name):
    """`<direction label>/<name>`, from whichever MAIN is currently executing."""
    main = getattr(pypeline, "_sim_current_main", None)
    if main is None:
        return name
    label = getattr(main, "__name__", "")
    return (_MAIN_LABELS.get(label, label) or "?") + "/" + name


# --- the per-cycle epoch --------------------------------------------------
# A hardware function body that declares any Feedback[T] is wrapped by PipelineC
# in a `while True:` convergence loop and re-executes -- probes included --
# until its feedback settles (chacha20_fsm and the chacha20_pipeline_shared MAIN
# both do this). Only the LAST firing of a cycle carries converged values, so
# every tap buffers one sample and commits it when the epoch changes.
#
# @sim_input is the right clock here: pypeline_sim.py clears the @sim_input
# result cache exactly once per simulated cycle, and pypeline.sim_call's own
# clearing is skipped under pypeline_sim.py (it only fires on a non-reentrant
# outermost call). So this body runs exactly once per cycle no matter which MAIN
# reaches a probe first or how many convergence passes run. Mutated IN PLACE,
# for the same detached-globals reason REGISTRY is never rebound.
_EPOCH = [0]


@sim_input
def _epoch_tick():
    _EPOCH[0] = _EPOCH[0] + 1
    return 0


def _keep_count(keep):
    """Popcount of an AXIS `keep` array, as bytes. None if it is not an array
    (so a probe can pass `None` to mean 'no byte accounting on this edge')."""
    if keep is None:
        return None
    try:
        n = len(keep)
    except TypeError:
        return None
    return sum(1 for i in range(n) if keep[i])


# --- the plain-Python workers (kept out of the @sim_output bodies, which are
# --- AST-rewritten; a one-line body keeps that rewriting trivial) ------------
def _note_hs(name, valid, ready, keep, epoch):
    if not REGISTRY.any_enabled():
        return
    tap = REGISTRY.tap(_qualified(name), HandshakeTap)
    tap.sample(
        epoch, (valid, ready, _keep_count(keep) if valid and ready else None)
    )


def _note_state(name, value, names, epoch):
    if not REGISTRY.any_enabled():
        return
    REGISTRY.tap(_qualified(name), StateTap).sample(epoch, (value, names))


def _note_arb(name, sel, req_a, req_b, granted, label_a, label_b, epoch):
    if not REGISTRY.any_enabled():
        return
    tap = REGISTRY.tap(_qualified(name), ArbTap, (label_a, label_b))
    tap.sample(epoch, (sel, (req_a, req_b), granted))


@sim_output
def hs(name, valid, ready, keep=None):
    """Sample one valid/ready handshake for this cycle.

    `keep` is optional: pass an AXIS beat's keep array to get exact byte
    accounting on that edge, omit it on non-AXIS edges (poly key, auth tag,
    compute launch) where beats are the natural unit.
    """
    _epoch_tick()
    _note_hs(name, valid, ready, keep, _EPOCH[0])


@sim_output
def state(name, value, names=None):
    """Sample one FSM state register for this cycle.

    `names` is a module-level tuple of member names in DECLARATION order --
    pypeline `@enum` with auto() numbers members 0..n-1 in that order, so the
    state value indexes it directly.
    """
    _epoch_tick()
    _note_state(name, value, names, _EPOCH[0])


@sim_output
def arb(name, sel, req_a, req_b, granted, label_a="a", label_b="b"):
    """Sample a two-way arbitrated resource for this cycle.

    `sel` is 1 when the mux points at requester A, 0 for B (matching
    chacha20_pipeline_shared's `is_encrypt`); `granted` is the resource's ready.
    """
    _epoch_tick()
    _note_arb(
        name, 0 if sel else 1, req_a, req_b, granted, label_a, label_b, _EPOCH[0]
    )
