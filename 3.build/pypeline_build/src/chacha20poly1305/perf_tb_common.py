# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Configuration and shared singletons for the performance testbenches
(encrypt_perf_tb.py / decrypt_perf_tb.py /
chacha20poly1305_encrypt_decrypt_shared_perf_tb.py).

The measurement math (taps, StreamMeter/PhaseRunner, barrier, recorder) is
PipelineC's stream performance library, include/pypeline/stream/stream_perf.py;
the design-side @sim_output probes are stream/stream_perf_probe.py, whose one
tap REGISTRY this file enables. See pypeline_stream_perf_guide.md there.

Every knob here is read from the environment at import time and NOTHING is
baked into hardware: the phase plan, packet sizes, counts and payload bytes
all live in Python `@sim_input`/`@sim_output` code. That is deliberate and
load-bearing -- it keeps the elaborated design bit-identical across
measurement runs, so pypelinec re-reads its cached hash-named `vivado_*.log`
files instead of re-running the 1-3 hour autopipelining sweep. Change a packet
size here and only the simulation re-runs (see measure.py --reuse-syn).

Key/nonce/AAD are reused from tb_common_sim.py rather than duplicated.
"""

import os
import wireguard_env

from stream import stream_perf_probe
from stream.stream_perf import PerfRecorder, PhaseBarrier, PhaseRunner, packet_size_phases
from poly1305_select import implementation_metadata
from aead_types import buffering_metadata, stream_slice_metadata
import tb_common_sim as common
from aead_ref_model import generate_encrypt_vector

# MAIN name -> short label that qualifies tap names (`encrypt/chacha20.in`).
# Update in place: the probes read this exact dict object.
stream_perf_probe.MAIN_LABELS.update({
    "encrypt_dataflow_shared": "encrypt",
    "decrypt_dataflow_shared": "decrypt",
    "encrypt_dataflow": "encrypt",
    "decrypt_dataflow": "decrypt",
    "chacha20_pipeline_shared": "shared",
    "poly1305_prologue_shared": "shared",
    "poly1305_epilogue_shared": "shared",
})

# ---------------------------------------------------------------------------
# Hard design limit: wait_to_verify buffers the decrypt-side ciphertext in a
# 128-deep x 16 B stream FIFO (make_stream_fifo(axis128_frag_t, 128), see
# src/auth_tag/wait_to_verify.py) while Poly1305 decides the verdict, so a
# packet whose ciphertext exceeds 128 * 16 = 2048 B deadlocks rather than
# measuring anything. The 16 B auth tag shares that budget, hence 2032 B of
# plaintext. Revisit this constant if that FIFO depth changes.
MAX_PACKET_BYTES = 2032
BUS_BYTES = 16  # axis128_intrf: 16 byte lanes per beat

# Default plan sized against MEASURED native-sim speed: the 60 MHz shared
# perf top simulates at roughly 2 s per cycle, so the whole plan below is a few
# thousand cycles / order of an hour or two, not a day. Packet sizes are a
# log-ish sweep from one bus beat to MTU; the final long-packet phase is the
# peak (steady-state) point. Widen it with WG_PERF_SIZES / WG_PERF_PACKETS or
# measure.py --sizes/--packets -- re-measuring needs NO re-synthesis
# (measure.py --reuse-syn), so more curve points cost only sim time.
DEFAULT_SIZES = (16, 64, 256, 1024, 1420)
DEFAULT_PACKETS = 4
DEFAULT_PEAK_BYTES = 1920  # 120 beats: long steady window, FIFO headroom
# The peak phase streams several same-size packets back to back like every other
# phase: one lone packet measures pipeline fill/drain, not sustained throughput.
DEFAULT_PEAK_PACKETS = 4
DEFAULT_MAX_CYCLES_PER_PHASE = 20000
DEFAULT_STALL_TIMEOUT = 1000  # cycles with no beat in or out => deadlock


def _env_int(name, default):
    raw = os.environ.get(name)
    return default if raw is None or raw == "" else int(raw)


def _env_ints(name, default):
    raw = os.environ.get(name)
    if raw is None or raw == "":
        return list(default)
    return [int(tok) for tok in raw.replace(" ", "").split(",") if tok]


JSON_PATH = os.environ.get("WG_PERF_JSON", "")
SIZES = _env_ints("WG_PERF_SIZES", DEFAULT_SIZES)
PACKETS = _env_int("WG_PERF_PACKETS", DEFAULT_PACKETS)
PEAK_BYTES = _env_int("WG_PERF_PEAK_BYTES", DEFAULT_PEAK_BYTES)
PEAK_PACKETS = _env_int("WG_PERF_PEAK_PACKETS", DEFAULT_PEAK_PACKETS)
SEED = _env_int("WG_PERF_SEED", common.DEFAULT_SEED)
MAX_CYCLES_PER_PHASE = _env_int(
    "WG_PERF_MAX_CYCLES_PER_PHASE", DEFAULT_MAX_CYCLES_PER_PHASE
)
STALL_TIMEOUT = _env_int("WG_PERF_STALL_TIMEOUT", DEFAULT_STALL_TIMEOUT)
SETTLE_CYCLES = _env_int("WG_PERF_SETTLE", 8)
DIRS = os.environ.get("WG_PERF_DIRS", "both").strip().lower()
TAP_NAMES = [
    t for t in os.environ.get("WG_PERF_TAPS", "").replace(" ", "").split(",") if t
]

_ALL_DIRS = ("encrypt", "decrypt")
if DIRS in ("both", "", "all"):
    ENABLED_DIRS = list(_ALL_DIRS)
elif DIRS in ("enc", "encrypt"):
    ENABLED_DIRS = ["encrypt"]
elif DIRS in ("dec", "decrypt"):
    ENABLED_DIRS = ["decrypt"]
else:
    raise ValueError(f"WG_PERF_DIRS must be both|enc|dec, got {DIRS!r}")


# Back-to-back phases (throughput vs packet size), then the long-packet peak.
# MAX_PACKET_BYTES is the wait_to_verify FIFO limit above.
PHASES = packet_size_phases(SIZES, PACKETS, PEAK_BYTES, PEAK_PACKETS, MAX_PACKET_BYTES)

CONFIG = {
    "design": "shared",
    "target_mhz": wireguard_env.TARGET_MHZ,
    "poly1305": implementation_metadata(),
    "sharing": wireguard_env.sharing(),
    "buffering": buffering_metadata(),
    "stream_slices": stream_slice_metadata(),
    "source_handshake": "converged",
    "decrypt_verification_retained": True,
    "bus_bytes": BUS_BYTES,
    "dirs": ENABLED_DIRS,
    "seed": SEED,
    # PhaseRunner seeds with the string "<seed>/<phase>/<runner>", so --seed
    # reproduces payload bytes. Records without this key used a tuple seed
    # whose hash varied per process (cycle results unaffected).
    "payload_seeding": "string seed/phase/runner (reproducible)",
    "sizes": SIZES,
    "packets_per_size": PACKETS,
    "peak_bytes": PEAK_BYTES,
    "peak_packets": PEAK_PACKETS,
    "max_cycles_per_phase": MAX_CYCLES_PER_PHASE,
    "stall_timeout_cycles": STALL_TIMEOUT,
    "settle_cycles": SETTLE_CYCLES,
    "taps": TAP_NAMES,
    "phase_plan": PHASES,
    "max_packet_bytes": MAX_PACKET_BYTES,
    "key": bytes(common.KEY).hex(),
    "nonce": bytes(common.NONCE).hex(),
    "aad_len": common.AAD_LEN,
}

BARRIER = PhaseBarrier(ENABLED_DIRS)
RECORDER = PerfRecorder(JSON_PATH, CONFIG)
# The ONE registry for the whole run, owned by stream_perf_probe so the design's
# own probe call sites (which never import this file) and the testbench share
# it. It starts empty; enable in place -- never rebind it.
TAPS = stream_perf_probe.REGISTRY
TAPS.enable(TAP_NAMES)

_RUNNERS = {}


def is_enabled(direction):
    return direction in ENABLED_DIRS


def _aad_bytes():
    return bytes(common.AAD[: common.AAD_LEN])


def encrypt_frame_builder(length, rng):
    """plaintext in -> ciphertext+tag out."""
    plaintext = bytes(rng.randrange(256) for _ in range(length))
    ciphertext, tag = generate_encrypt_vector(
        bytes(common.KEY), bytes(common.NONCE), _aad_bytes(), plaintext
    )
    return plaintext, ciphertext + tag, {}


def decrypt_frame_builder(length, rng):
    """ciphertext+tag in -> plaintext out. Only valid (verifiable) packets are
    measured; the tampered-tag negative case lives in the functional
    testbenches, where it cannot perturb a timing window."""
    plaintext = bytes(rng.randrange(256) for _ in range(length))
    ciphertext, tag = generate_encrypt_vector(
        bytes(common.KEY), bytes(common.NONCE), _aad_bytes(), plaintext
    )
    return ciphertext + tag, plaintext, {"expected_verified": 1}


def make_runner(direction, src, snk, scoreboard, frame_builder):
    """One PhaseRunner per direction; a direction disabled via
    WG_PERF_DIRS gets an empty phase plan (drives valid=0 for the whole run)."""
    runner = PhaseRunner(
        name=direction,
        phases=PHASES if is_enabled(direction) else [],
        barrier=BARRIER,
        recorder=RECORDER,
        src=src,
        snk=snk,
        scoreboard=scoreboard,
        frame_builder=frame_builder,
        bus_bytes=BUS_BYTES,
        seed=SEED,
        max_cycles_per_phase=MAX_CYCLES_PER_PHASE,
        settle_cycles=SETTLE_CYCLES,
        stall_timeout_cycles=STALL_TIMEOUT,
        taps=TAPS,
    )
    _RUNNERS[direction] = runner
    return runner


def all_done():
    """True once every registered runner has finished its phase plan. Both
    testbenches must have registered (imported) for this to mean anything, so
    the shared top imports both."""
    return bool(_RUNNERS) and all(r.done for r in _RUNNERS.values())


def total_cycles():
    return max((r.meter.cycle for r in _RUNNERS.values()), default=0)


def finalize():
    """Write the final JSON (phase results were already written incrementally
    after each phase, so this only adds the run-level totals)."""
    # Tap counters live per phase (PerfRecorder.record_taps zeroes them at each
    # barrier release), so there is no meaningful run-level total to report --
    # what IS worth recording is which taps actually fired, since a name that
    # matched nothing is the usual explanation for an empty "taps" section.
    RECORDER.config["taps_active"] = TAPS.active_names()
    RECORDER.finalize(total_cycles=total_cycles())


def summary_line():
    lines = []
    for phase in RECORDER.as_dict()["phases"]:
        for d in ENABLED_DIRS:
            res = phase.get(d)
            if not res or not res.get("bytes_per_cycle"):
                continue
            lines.append(
                f"{phase['name']:>12} {d:<8} {res['bytes_per_cycle']:6.3f} B/cyc "
                f"window={res['window_cycles']} cold_head="
                f"{res['latency_cycles']['cold_head']}"
            )
    return lines
