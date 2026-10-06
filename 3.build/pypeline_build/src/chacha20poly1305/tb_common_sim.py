"""Shared support for the non-synthesizable @sim_input/@sim_output
testbenches (plain Python data/helpers, no hardware, no pypeline import).

KEY/NONCE/AAD match tb_common.py's synthesizable-style vectors (duplicated
here rather than cross-imported, so the two testbench styles stay fully
decoupled). Unlike tb_common.py, this module does not precompute any
ciphertext/tag vectors -- encrypt_tb.py/decrypt_tb.py call
aead_ref_model.generate_encrypt_vector(...) lazily, once per randomly
generated packet, during live simulation.
"""

import os
import random


class ConvergedAxisSource:
    """AXIS source with separate presentation and converged acceptance.

    Call drive() from @sim_input and commit(ready) from @sim_output. Ready
    can depend on same-cycle downstream arbitration: sampling it before
    convergence can discard a word the DUT never accepted. The underlying
    AxisSimSource is held with ready=0 until the converged handshake commits.
    drive(pause=True) inserts a gap only between accepted beats: an already
    stalled valid beat is held unchanged until accepted. Do not attach a pause
    generator to the underlying source, whose step() also runs at commit.
    """

    def __init__(self, axis_intrf, bus_bytes):
        from axi.axis_sim import AxisSimSource
        from pypeline import sim_zero

        self._source = AxisSimSource(axis_intrf, bus_bytes)
        self._offered = None
        self._held = False
        self._null = sim_zero(axis_intrf.fwd_t)

    def send(self, frame):
        self._source.send(frame)

    def idle(self):
        return self._source.idle()

    def drive(self, pause=False):
        self._offered = self._null if pause and not self._held else self._source.step(0)
        self._held = bool(self._offered.stream.valid)
        return self._offered

    def commit(self, ready):
        accepted = bool(self._offered is not None and self._offered.stream.valid and ready)
        if accepted:
            self._source.step(1)
            self._held = False
        self._offered = None
        return accepted


class ConvergedAxisSink:
    """Scoreboard sink accepting only transfers, checking stalled stability."""

    def __init__(self, axis_intrf, bus_bytes, scoreboard):
        from axi.axis_sim import AxisSimSink

        self._sink = AxisSimSink(axis_intrf, bus_bytes, scoreboard=scoreboard)
        self._bus_bytes = bus_bytes
        self._stalled = None
        self.accepted_beats = 0
        self.stalled_cycles = 0

    def step(self, word, ready=1, sideband=None):
        stream = word.stream
        payload = (
            tuple(int(stream.data.frag.data[i]) for i in range(self._bus_bytes)),
            tuple(int(stream.data.frag.keep[i]) for i in range(self._bus_bytes)),
            int(stream.data.eod[0]),
            None if sideband is None else int(sideband),
        )
        if self._stalled is not None:
            assert stream.valid and payload == self._stalled, (
                "AXIS output changed or withdrew valid while stalled"
            )
        self._stalled = payload if stream.valid and not ready else None
        if stream.valid and not ready:
            self.stalled_cycles += 1
        if stream.valid and ready:
            self.accepted_beats += 1
            self._sink.step(word)

    def check_nowait(self):
        return self._sink.check_nowait()

    def empty(self):
        return self._sink.empty()


# Optional native functional stress. Performance testbenches never use these
# pauses: their sinks remain always ready and their sources always offer work.
STRESS = os.environ.get("WG_TB_STRESS", "0") == "1"


def input_paused(direction, cycle):
    offset = 0 if direction == "encrypt" else 9
    return STRESS and (cycle + offset) % 37 < 6


def output_ready(direction, cycle):
    if not STRESS:
        return 1
    offset = 0 if direction == "encrypt" else 173
    slot = (cycle + offset) % 1100
    return int(not (200 <= slot < 500 or slot % 23 < 5))


# Test vectors (same fixed values as tb_common.py)
KEY = list(range(0x80, 0xA0))  # 0x80, 0x81, ... 0x9f

NONCE = [0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47]

AAD_TEST_STR = "Additional authenticated data"
AAD_MAX_LEN = 32
AAD_LEN = len(AAD_TEST_STR)  # 29
AAD = list(AAD_TEST_STR.encode()) + [0] * (AAD_MAX_LEN - AAD_LEN)

# Random packet generation
NUM_RANDOM_PACKETS = 16 if STRESS else 12
PACKET_LEN_MIN = 1
PACKET_LEN_MAX = 1024

# The first len(CORNER_CASE_LENS) packets each run are pinned to these
# lengths -- the same corner cases tb_common.py's PLAINTEXT_TEST_STRS
# comment covers (15/31 pin r=15, see there and README's "Xilinx-style
# tkeep" section): 16 is exactly one word, 17 is one word plus one byte, 64
# is exactly one ChaCha20 block, 128 is the old fixed-vector max. Remaining
# packets are uniform-random over [PACKET_LEN_MIN, PACKET_LEN_MAX].
CORNER_CASE_LENS = [15, 16, 17, 31, 64, 128]
if STRESS:
    CORNER_CASE_LENS = [15, 16, 17, 31, 63, 64, 65, 128, 511, 512, 513,
                        1024, 1420, 1920, 1920, 1920]

# Fixed default seed (nod to RFC 8439) so a failing run's exact vectors are
# reproducible by re-seeding with the same value; the seed actually used is
# always printed via sim_print at the start of each run.
DEFAULT_SEED = 8439


def next_packet_length(rng: random.Random, packet_idx: int) -> int:
    """Length in bytes for random packet `packet_idx` (0-based) of a run.

    The first few packets are pinned to CORNER_CASE_LENS (guaranteed
    coverage every run); the rest are uniform-random.
    """
    if packet_idx < len(CORNER_CASE_LENS):
        return CORNER_CASE_LENS[packet_idx]
    return rng.randint(PACKET_LEN_MIN, PACKET_LEN_MAX)
