"""Shared support for the non-synthesizable @sim_input/@sim_output
testbenches (plain Python data/helpers, no hardware, no pypeline import).

KEY/NONCE/AAD match tb_common.py's synthesizable-style vectors (duplicated
here rather than cross-imported, so the two testbench styles stay fully
decoupled). Unlike tb_common.py, this module does not precompute any
ciphertext/tag vectors -- encrypt_tb.py/decrypt_tb.py call
aead_ref_model.generate_encrypt_vector(...) lazily, once per randomly
generated packet, during live simulation.
"""

import random

# Test vectors (same fixed values as tb_common.py)
KEY = list(range(0x80, 0xA0))  # 0x80, 0x81, ... 0x9f

NONCE = [0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47]

AAD_TEST_STR = "Additional authenticated data"
AAD_MAX_LEN = 32
AAD_LEN = len(AAD_TEST_STR)  # 29
AAD = list(AAD_TEST_STR.encode()) + [0] * (AAD_MAX_LEN - AAD_LEN)

# Random packet generation
NUM_RANDOM_PACKETS = 10
PACKET_LEN_MIN = 1
PACKET_LEN_MAX = 1024

# The first len(CORNER_CASE_LENS) packets each run are pinned to these
# lengths -- the same partial-final-word/block-boundary corner cases
# tb_common.py's fixed 8-string set was chosen to cover (see its comment):
# shorter than one 16-byte AXIS word would also be nice but 16 doubles as
# "exactly one word"; 17 is one word plus one byte; 64 is exactly one
# ChaCha20 block; 128 is the old fixed-vector max and a multiple of both 16
# and 64. The remaining packets are uniform-random over
# [PACKET_LEN_MIN, PACKET_LEN_MAX], so every run is guaranteed to exercise
# these boundaries at least once while still covering fresh random lengths.
CORNER_CASE_LENS = [16, 17, 64, 128]

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
