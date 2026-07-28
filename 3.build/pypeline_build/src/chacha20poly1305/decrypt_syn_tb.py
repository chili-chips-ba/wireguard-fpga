# pyright: reportInvalidTypeForm=none
"""Synthesizable-style testbench for the standalone decrypt design: fixed
8-string test vectors baked into hardware register arrays at elaboration
time. For the non-synthesizable @sim_input/@sim_output variant (10 + 1
on-the-fly random packets), see decrypt_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_tb.c.
Streams the test ciphertext+tag packets into the DUT wires exactly as the
encrypt side frames them — ciphertext words with exact tkeep (partial on the
final word of an odd-length ciphertext, never eod) followed by the auth tag
as its own full 16-byte word carrying eod — and checks the plaintext stream
coming out (data bytes, the exact per-lane keep pattern, packet framing, and
the is_verified_out flag), printing "ERROR: ..." on any mismatch and
"Decrypt: Test N DONE!" per passing packet.

The final packet is a negative test: test string 0's ciphertext replayed
with a corrupted tag (tb_common.TAMPERED_TAG). The DUT must still emit that
packet's plaintext but with is_verified_out low.

The per-lane keep/eod/shift-register bookkeeping this testbench used to
hand-roll is now the shared `make_axis_byte_source`/`make_axis_byte_sink`
testbench library (see PipelineC's include/pypeline/axi/axis.py) -- only the
genuinely wireguard-specific bits (which test string is loaded, matching the
expected plaintext, is_verified reporting) remain here. The auth tag must
always start on a fresh beat (never merged into a partial final ciphertext
beat), so a non-block-aligned ciphertext is padded up to the lane width
first, with `byte_source`'s `use_keep_mask=True` marking the real ciphertext
bytes (and the tag) as kept and the padding bytes as not-kept.
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    Wire,
    wires,
    Feedback,
    Reg,
    uint1_t,
    uint8_t,
    uint32_t,
    sim_assert,
    sim_print,
    array_to_uint_be,
    hex,
)

import chacha20poly1305_decrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    uint96_t,
    uint128_t,
    uint256_t,
    axis128_intrf,
)
from axi.axis import make_axis_byte_source, make_axis_byte_sink
from tb_common import (
    KEY,
    NONCE,
    AAD,
    AAD_LEN,
    NUM_PLAINTEXT_TEST_STRS,
    PLAINTEXT_TEST_STR_MAX_SIZE,
    PLAINTEXTS,
    PLAINTEXT_LENS,
    POLY1305_AUTH_TAG_SIZE,
    CIPHERTEXT_MAX_SIZE,
    EXPECTED_CIPHERTEXTS,
    EXPECTED_TAGS,
    CIPHERTEXT_LENS,
    TAMPERED_TAG,
)

# Decrypt runs the encrypt vectors in reverse: input = ciphertext + auth tag
# packets, expected output = plaintexts. One extra final packet replays test
# 0's ciphertext with a corrupted tag (expected: plaintext still emitted,
# is_verified_out low).
NUM_PACKETS = NUM_PLAINTEXT_TEST_STRS + 1
PLAINTEXT_MAX_SIZE = PLAINTEXT_TEST_STR_MAX_SIZE

# Input frame = ciphertext bytes, padded up to the lane width so the auth tag
# always starts on a fresh beat (never merged into ciphertext's partial final
# beat), + the 16-byte tag. The keep mask marks the real ciphertext bytes and
# the tag as kept, the padding as not-kept -- see make_axis_byte_source's
# use_keep_mask docstring.
LANE_WIDTH = 16
IN_FRAME_MAX_SIZE = CIPHERTEXT_MAX_SIZE + POLY1305_AUTH_TAG_SIZE
_INPUT_CIPHERTEXTS = EXPECTED_CIPHERTEXTS + [EXPECTED_CIPHERTEXTS[0]]
_INPUT_TAGS = EXPECTED_TAGS + [TAMPERED_TAG]
_INPUT_CIPHERTEXT_LENS = CIPHERTEXT_LENS + [CIPHERTEXT_LENS[0]]


def _round_up(n, to):
    return ((n + to - 1) // to) * to


INPUT_FRAMES = []
INPUT_KEEP_MASKS = []
INPUT_FRAME_LENS = []
for _ct, _tag, _ct_len in zip(_INPUT_CIPHERTEXTS, _INPUT_TAGS, _INPUT_CIPHERTEXT_LENS):
    _padded_ct_len = _round_up(_ct_len, LANE_WIDTH)
    _total_len = _padded_ct_len + POLY1305_AUTH_TAG_SIZE
    _frame = (
        _ct[:_ct_len]
        + [0] * (_padded_ct_len - _ct_len)
        + _tag
        + [0] * (IN_FRAME_MAX_SIZE - _total_len)
    )
    _mask = (
        [1] * _ct_len
        + [0] * (_padded_ct_len - _ct_len)
        + [1] * POLY1305_AUTH_TAG_SIZE
        + [0] * (IN_FRAME_MAX_SIZE - _total_len)
    )
    INPUT_FRAMES.append(_frame)
    INPUT_KEEP_MASKS.append(_mask)
    INPUT_FRAME_LENS.append(_total_len)

EXPECTED_PLAINTEXTS = PLAINTEXTS + [PLAINTEXTS[0]]
EXPECTED_PLAINTEXT_LENS = PLAINTEXT_LENS + [PLAINTEXT_LENS[0]]
EXPECTED_VERIFIED = [1] * NUM_PLAINTEXT_TEST_STRS + [0]

byte_source, byte_source_t = make_axis_byte_source(
    axis128_intrf, LANE_WIDTH, IN_FRAME_MAX_SIZE, use_keep_mask=True
)
byte_sink, byte_sink_t = make_axis_byte_sink(axis128_intrf, 16, PLAINTEXT_MAX_SIZE)


# Sticky and one clock cycle delayed relative to the completing "Test N DONE!" print
# -- see encrypt_syn_tb.py's matching Wire declaration for the full explanation (why
# this testbench doesn't call sim_finish() itself, why sticky, why delayed).
decrypt_all_done: Wire[uint1_t]


@MAIN
@wires
def decrypt_syn_tb() -> axis128_intrf.fwd_t:
    # Test vectors
    key: uint8_t[CHACHA20_KEY_SIZE] = KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = NONCE
    aad: uint8_t[AAD_MAX_LEN] = AAD
    input_frames: uint8_t[NUM_PACKETS][IN_FRAME_MAX_SIZE] = INPUT_FRAMES
    input_frame_lens: uint32_t[NUM_PACKETS] = INPUT_FRAME_LENS
    input_keep_masks: uint1_t[NUM_PACKETS][IN_FRAME_MAX_SIZE] = INPUT_KEEP_MASKS
    expected_plaintexts: uint8_t[NUM_PACKETS][PLAINTEXT_MAX_SIZE] = (
        EXPECTED_PLAINTEXTS
    )
    expected_plaintext_lens: uint32_t[NUM_PACKETS] = EXPECTED_PLAINTEXT_LENS
    expected_verified_flags: uint1_t[NUM_PACKETS] = EXPECTED_VERIFIED

    # Connect CSR inputs to dut
    chacha20poly1305_decrypt_ports.key = key
    chacha20poly1305_decrypt_ports.nonce = nonce
    chacha20poly1305_decrypt_ports.aad = aad
    chacha20poly1305_decrypt_ports.aad_len = AAD_LEN

    cycle_counter: Reg[uint32_t]
    decrypt_all_done_reg: Reg[uint1_t]

    # Drive the Wire from the sticky reg's *previous*-cycle value -- see
    # encrypt_syn_tb.py's matching comment for why this one-cycle delay matters.
    decrypt_all_done = decrypt_all_done_reg

    if cycle_counter == 0:
        sim_print("=== ChaCha20-Poly1305 Decryption Test ===")
        key_u: uint256_t = array_to_uint_be(key)
        sim_print(
            f"Decrypt Key: {hex(key_u[255:224])}{hex(key_u[223:192])}{hex(key_u[191:160])}{hex(key_u[159:128])}{hex(key_u[127:96])}{hex(key_u[95:64])}{hex(key_u[63:32])}{hex(key_u[31:0])}"
        )
        nonce_u: uint96_t = array_to_uint_be(nonce)
        sim_print(
            f"Decrypt Nonce: {hex(nonce_u[95:64])}{hex(nonce_u[63:32])}{hex(nonce_u[31:0])}"
        )
        sim_print("AAD (29 bytes): Additional authenticated data")

    # --- Input side: stream each packet's ciphertext+tag through byte_source ---
    input_packet_count: Reg[uint32_t]
    input_loaded: Reg[uint1_t]

    dut_in_ready: Feedback[uint1_t]
    src = byte_source(
        load=~input_loaded,
        load_data=input_frames[input_packet_count],
        load_len=input_frame_lens[input_packet_count],
        load_keep_mask=input_keep_masks[input_packet_count],
        stream_out_if=axis128_intrf.fb_t(ready=dut_in_ready),
    )
    if ~input_loaded:
        sim_print(f"Decrypting test string {input_packet_count}...")
        input_loaded = 1
    if src.idle & input_loaded & (input_packet_count < NUM_PACKETS - 1):
        input_packet_count = input_packet_count + 1
        input_loaded = 0
    chacha20poly1305_decrypt_ports.axis_in_if.stream = src.stream_out_if.stream
    dut_in_ready = chacha20poly1305_decrypt_ports.axis_in_if.ready

    # --- Output side: collect plaintext via byte_sink, compare whole frames + is_verified ---
    output_packet_count: Reg[uint32_t]

    chacha20poly1305_decrypt_ports.axis_out_if.ready = 1
    snk = byte_sink(
        stream_in_if=axis128_intrf.fwd_t(stream=chacha20poly1305_decrypt_ports.axis_out_if.stream)
    )

    if snk.frame_valid:
        expected_verified: uint1_t = expected_verified_flags[output_packet_count]
        sim_assert(
            chacha20poly1305_decrypt_ports.is_verified_out == expected_verified,
            f"Decrypt: Test {output_packet_count} is_verified mismatch. expected {expected_verified} got {chacha20poly1305_decrypt_ports.is_verified_out}",
        )
        expected_len: uint32_t = expected_plaintext_lens[output_packet_count]
        sim_assert(
            snk.frame_len == expected_len,
            f"Decrypt: Test {output_packet_count} output length mismatch. expected {expected_len} got {snk.frame_len}",
        )
        for i in range(PLAINTEXT_MAX_SIZE):
            byte_idx: uint32_t = i
            if byte_idx < expected_len:
                sim_assert(
                    snk.frame_data[i] == expected_plaintexts[output_packet_count][i],
                    f"Decrypt: Test {output_packet_count} mismatch at byte[{byte_idx}]. expected {hex(expected_plaintexts[output_packet_count][i])} got {hex(snk.frame_data[i])}",
                )
        sim_print(f"Decrypt: Test {output_packet_count} DONE!")
        output_packet_count = output_packet_count + 1
        if output_packet_count >= NUM_PACKETS:
            # All packets checked -- signal completion (sticky; see
            # decrypt_all_done's declaration above). The top-level file
            # decides when it's safe to actually call sim_finish().
            decrypt_all_done_reg = 1

    cycle_counter = cycle_counter + 1

    # dummy return for synthesis
    # so everything doesnt optimize away
    return axis128_intrf.fwd_t(stream=chacha20poly1305_decrypt_ports.axis_out_if.stream)
