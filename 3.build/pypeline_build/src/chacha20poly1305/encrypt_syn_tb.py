# pyright: reportInvalidTypeForm=none
"""Synthesizable-style testbench for the standalone encrypt design: fixed
8-string test vectors baked into hardware register arrays at elaboration
time. For the non-synthesizable @sim_input/@sim_output variant (10
on-the-fly random packets), see encrypt_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_tb.c.
Streams the test plaintexts into the DUT wires (with exact tkeep, partial on
the final word of each packet) and checks the ciphertext + auth tag stream
coming out — data bytes, the exact per-lane keep pattern, and packet framing
(eod only on the appended auth tag word) — printing "ERROR: ..." on any
mismatch and "Encrypt: Test N DONE!" per passing packet.

The per-lane keep/eod/shift-register bookkeeping this testbench used to
hand-roll is now the shared `make_axis_byte_source`/`make_axis_byte_sink`
testbench library (see PipelineC's include/pypeline/axi/axis.py) -- only the
genuinely wireguard-specific bits (which test string is loaded, matching the
expected ciphertext+tag, is_verified reporting) remain here.
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

import chacha20poly1305_encrypt_ports

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
)

# Ciphertext + the appended 16-byte auth tag word, as one continuous frame --
# matches exactly what the DUT emits (ciphertext words, then one full-keep
# tag word carrying eod). The tag must be packed immediately after the real
# ciphertext bytes -- EXPECTED_CIPHERTEXTS entries are themselves already
# zero-padded out to CIPHERTEXT_MAX_SIZE (see tb_common.py), so the real
# length must come from CIPHERTEXT_LENS, not len(ct) (always CIPHERTEXT_MAX_SIZE).
OUT_FRAME_MAX_SIZE = CIPHERTEXT_MAX_SIZE + POLY1305_AUTH_TAG_SIZE
EXPECTED_OUT_FRAMES = [
    (ct[:ct_len] + tag) + [0] * (OUT_FRAME_MAX_SIZE - ct_len - len(tag))
    for ct, tag, ct_len in zip(EXPECTED_CIPHERTEXTS, EXPECTED_TAGS, CIPHERTEXT_LENS)
]
EXPECTED_OUT_FRAME_LENS = [n + POLY1305_AUTH_TAG_SIZE for n in CIPHERTEXT_LENS]

byte_source, byte_source_t = make_axis_byte_source(
    axis128_intrf, 16, PLAINTEXT_TEST_STR_MAX_SIZE
)
byte_sink, byte_sink_t = make_axis_byte_sink(axis128_intrf, 16, OUT_FRAME_MAX_SIZE)


# Sticky (stays 1 forever once set) and one clock cycle delayed relative to the
# "Test N DONE!" print that marks completion -- read by top-level *_syn_tb.py files
# to decide when to call sim_finish(). This testbench doesn't call sim_finish()
# directly since the shared build runs it alongside decrypt_syn_tb() in one
# simulation, and only the top-level file knows whether it needs to wait for one or
# both testbenches. Sticky (rather than a one-cycle pulse) so the shared build's
# checker can correctly wait for both flags even though encrypt/decrypt finish at
# different cycle counts. The one-cycle delay (see encrypt_all_done_reg below --
# this Wire mirrors its *previous*-cycle value, not its newly-written value) gives
# the completing cycle's own "Test N DONE!" print process a full clock edge to
# flush before a finish-checker's std.env.finish can possibly preempt it -- VHDL
# gives no ordering guarantee between different processes triggered by the same
# clock edge, confirmed empirically (without this delay, the final packet's DONE
# print was sometimes lost from the GHDL sim log).
encrypt_all_done: Wire[uint1_t]


# CSR values available all at once do not need to be static=registers
@MAIN
@wires
def encrypt_syn_tb() -> axis128_intrf.fwd_t:
    # Test vectors
    key: uint8_t[CHACHA20_KEY_SIZE] = KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = NONCE
    aad: uint8_t[AAD_MAX_LEN] = AAD
    plaintexts: uint8_t[NUM_PLAINTEXT_TEST_STRS][PLAINTEXT_TEST_STR_MAX_SIZE] = (
        PLAINTEXTS
    )
    plaintext_lens: uint32_t[NUM_PLAINTEXT_TEST_STRS] = PLAINTEXT_LENS
    expected_out_frames: uint8_t[NUM_PLAINTEXT_TEST_STRS][OUT_FRAME_MAX_SIZE] = (
        EXPECTED_OUT_FRAMES
    )
    expected_out_frame_lens: uint32_t[NUM_PLAINTEXT_TEST_STRS] = (
        EXPECTED_OUT_FRAME_LENS
    )

    # Connect CSR inputs to dut
    chacha20poly1305_encrypt_ports.key = key
    chacha20poly1305_encrypt_ports.nonce = nonce
    chacha20poly1305_encrypt_ports.aad = aad
    chacha20poly1305_encrypt_ports.aad_len = AAD_LEN

    cycle_counter: Reg[uint32_t]
    encrypt_all_done_reg: Reg[uint1_t]

    # Drive the Wire from the sticky reg's *previous*-cycle value (read here,
    # before encrypt_all_done_reg is possibly written later in this same
    # execution) -- see encrypt_all_done's declaration above for why this
    # one-cycle delay matters.
    encrypt_all_done = encrypt_all_done_reg

    if cycle_counter == 0:
        sim_print("=== ChaCha20-Poly1305 Encryption Test ===")
        key_u: uint256_t = array_to_uint_be(key)
        sim_print(
            f"Encrypt Key: {hex(key_u[255:224])}{hex(key_u[223:192])}{hex(key_u[191:160])}{hex(key_u[159:128])}{hex(key_u[127:96])}{hex(key_u[95:64])}{hex(key_u[63:32])}{hex(key_u[31:0])}"
        )
        nonce_u: uint96_t = array_to_uint_be(nonce)
        sim_print(
            f"Encrypt Nonce: {hex(nonce_u[95:64])}{hex(nonce_u[63:32])}{hex(nonce_u[31:0])}"
        )
        sim_print("AAD (29 bytes): Additional authenticated data")

    # --- Input side: stream each test string's plaintext through byte_source ---
    input_packet_count: Reg[uint32_t]
    input_loaded: Reg[uint1_t]

    dut_in_ready: Feedback[uint1_t]
    src = byte_source(
        load=~input_loaded,
        load_data=plaintexts[input_packet_count],
        load_len=plaintext_lens[input_packet_count],
        stream_out_if=axis128_intrf.fb_t(ready=dut_in_ready),
    )
    if ~input_loaded:
        sim_print(f"Encrypting test string {input_packet_count}...")
        input_loaded = 1
    if src.idle & input_loaded & (input_packet_count < NUM_PLAINTEXT_TEST_STRS - 1):
        input_packet_count = input_packet_count + 1
        input_loaded = 0
    chacha20poly1305_encrypt_ports.axis_in_if.stream = src.stream_out_if.stream
    dut_in_ready = chacha20poly1305_encrypt_ports.axis_in_if.ready

    # --- Output side: collect ciphertext+tag via byte_sink, compare whole frames ---
    output_packet_count: Reg[uint32_t]

    chacha20poly1305_encrypt_ports.axis_out_if.ready = 1
    snk = byte_sink(
        stream_in_if=axis128_intrf.fwd_t(stream=chacha20poly1305_encrypt_ports.axis_out_if.stream)
    )

    if snk.frame_valid:
        expected_len: uint32_t = expected_out_frame_lens[output_packet_count]
        sim_assert(
            snk.frame_len == expected_len,
            f"Encrypt: Test {output_packet_count} output length mismatch. expected {expected_len} got {snk.frame_len}",
        )
        for i in range(OUT_FRAME_MAX_SIZE):
            byte_idx: uint32_t = i
            if byte_idx < expected_len:
                sim_assert(
                    snk.frame_data[i] == expected_out_frames[output_packet_count][i],
                    f"Encrypt: Test {output_packet_count} mismatch at byte[{byte_idx}]. expected {hex(expected_out_frames[output_packet_count][i])} got {hex(snk.frame_data[i])}",
                )
        sim_print(f"Encrypt: Test {output_packet_count} DONE!")
        output_packet_count = output_packet_count + 1
        if output_packet_count >= NUM_PLAINTEXT_TEST_STRS:
            # All packets checked -- signal completion (sticky; see
            # encrypt_all_done's declaration above). The top-level file
            # decides when it's safe to actually call sim_finish().
            encrypt_all_done_reg = 1

    cycle_counter = cycle_counter + 1

    # dummy return for synthesis
    # so everything doesnt optimize away
    return axis128_intrf.fwd_t(stream=chacha20poly1305_encrypt_ports.axis_out_if.stream)
