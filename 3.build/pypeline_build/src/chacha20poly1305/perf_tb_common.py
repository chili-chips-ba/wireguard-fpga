# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Plain-Python (no pypeline/hardware import) configuration and shared
singletons for the performance testbenches (encrypt_perf_tb.py /
decrypt_perf_tb.py / chacha20poly1305_encrypt_decrypt_shared_perf_tb.py).

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

import tb_common_sim as common
from aead_ref_model import generate_encrypt_vector
from perf_probe import DirectionRunner, PerfRecorder, PhaseBarrier, TapRegistry

# ---------------------------------------------------------------------------
# Hard design limit: wait_to_verify buffers the decrypt-side ciphertext in a
# 128-deep x 16 B stream FIFO (make_stream_fifo(axis128_frag_t, 128), see
# src/auth_tag/wait_to_verify.py) while Poly1305 decides the verdict, so a
# packet whose ciphertext exceeds 128 * 16 = 2048 B deadlocks rather than
# measuring anything. The 16 B auth tag shares that budget, hence 2032 B of
# plaintext. Revisit this constant if that FIFO depth changes.
MAX_PACKET_BYTES = 2032
BUS_BYTES = 16  # axis128_intrf: 16 byte lanes per beat

# Default plan sized against MEASURED native-sim speed: this design simulates
# at roughly 0.5 s per cycle (2 cycles/s), so the whole plan below is a few
# thousand cycles / order of an hour, not a day. Packet sizes are a log-ish
# sweep from one bus beat to MTU; the final single long packet is the peak
# (steady-state) point. Widen it with WG_PERF_SIZES / WG_PERF_PACKETS or
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


def _build_phases():
    """Back-to-back phases (throughput vs packet size), then a single long
    packet whose steady-state rate is the peak-throughput number."""
    phases = []
    for size in SIZES:
        phases.append(
            {"name": f"b2b-{size}", "packet_bytes": size, "num_packets": PACKETS}
        )
    if PEAK_BYTES:
        phases.append(
            {
                "name": f"peak-{PEAK_BYTES}",
                "packet_bytes": PEAK_BYTES,
                "num_packets": PEAK_PACKETS,
            }
        )
    for phase in phases:
        if not 0 < phase["packet_bytes"] <= MAX_PACKET_BYTES:
            raise ValueError(
                f"phase {phase['name']}: packet_bytes must be in "
                f"1..{MAX_PACKET_BYTES} (wait_to_verify FIFO limit), got "
                f"{phase['packet_bytes']}"
            )
    return phases


PHASES = _build_phases()

CONFIG = {
    "design": "shared",
    "bus_bytes": BUS_BYTES,
    "dirs": ENABLED_DIRS,
    "seed": SEED,
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
TAPS = TapRegistry(TAP_NAMES)

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
    """One DirectionRunner per direction; a direction disabled via
    WG_PERF_DIRS gets an empty phase plan (drives valid=0 for the whole run)."""
    runner = DirectionRunner(
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
    RECORDER.config["taps_measured"] = TAPS.snapshot()
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
