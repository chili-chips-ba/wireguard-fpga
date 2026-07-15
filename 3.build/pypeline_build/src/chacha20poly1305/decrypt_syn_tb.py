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
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    Wire,
    wires,
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
    axis128_t,
    axis128_null,
)
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
CIPHERTEXT_IN_MAX_SIZE = CIPHERTEXT_MAX_SIZE
INPUT_CIPHERTEXTS = EXPECTED_CIPHERTEXTS + [EXPECTED_CIPHERTEXTS[0]]
INPUT_TAGS = EXPECTED_TAGS + [TAMPERED_TAG]
INPUT_CIPHERTEXT_LENS = CIPHERTEXT_LENS + [CIPHERTEXT_LENS[0]]
EXPECTED_PLAINTEXTS = PLAINTEXTS + [PLAINTEXTS[0]]
EXPECTED_PLAINTEXT_LENS = PLAINTEXT_LENS + [PLAINTEXT_LENS[0]]
EXPECTED_VERIFIED = [1] * NUM_PLAINTEXT_TEST_STRS + [0]


# Sticky and one clock cycle delayed relative to the completing "Test N DONE!" print
# -- see encrypt_syn_tb.py's matching Wire declaration for the full explanation (why
# this testbench doesn't call sim_finish() itself, why sticky, why delayed).
decrypt_all_done: Wire[uint1_t]


# CSR values available all at once do not need to be static=registers
# Streaming inputs data is done as shift register
@MAIN
@wires
def decrypt_syn_tb() -> axis128_t:
    # Test vectors
    key: uint8_t[CHACHA20_KEY_SIZE] = KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = NONCE
    aad: uint8_t[AAD_MAX_LEN] = AAD
    expected_plaintexts: uint8_t[NUM_PACKETS][PLAINTEXT_MAX_SIZE] = (
        EXPECTED_PLAINTEXTS
    )
    plaintext_lens: uint32_t[NUM_PACKETS] = EXPECTED_PLAINTEXT_LENS
    input_ciphertexts: uint8_t[NUM_PACKETS][CIPHERTEXT_IN_MAX_SIZE] = (
        INPUT_CIPHERTEXTS
    )
    ciphertext_lens: uint32_t[NUM_PACKETS] = INPUT_CIPHERTEXT_LENS
    input_tags: uint8_t[NUM_PACKETS][POLY1305_AUTH_TAG_SIZE] = INPUT_TAGS
    expected_verified_flags: uint1_t[NUM_PACKETS] = EXPECTED_VERIFIED

    # Connect CSR inputs to dut
    chacha20poly1305_decrypt_ports.key = key
    chacha20poly1305_decrypt_ports.nonce = nonce
    chacha20poly1305_decrypt_ports.aad = aad
    chacha20poly1305_decrypt_ports.aad_len = AAD_LEN

    # --- Input State Machine (Streams CIPHERTEXT then AUTH TAG) ---
    input_packet_count: Reg[uint32_t]
    ciphertext_in_stream: Reg[uint8_t[CIPHERTEXT_IN_MAX_SIZE]]
    ciphertext_remaining_in: Reg[uint32_t]
    input_tag: Reg[uint8_t[POLY1305_AUTH_TAG_SIZE]]
    cycle_counter: Reg[uint32_t]
    decrypt_all_done_reg: Reg[uint1_t]

    # Drive the Wire from the sticky reg's *previous*-cycle value -- see
    # encrypt_syn_tb.py's matching comment for why this one-cycle delay matters.
    decrypt_all_done = decrypt_all_done_reg

    # Initialize/Reset Logic
    if cycle_counter == 0:
        sim_print("=== ChaCha20-Poly1305 Decryption Test ===")
        # Print test inputs
        key_u: uint256_t = array_to_uint_be(key)
        sim_print(
            f"Decrypt Key: {hex(key_u[255:224])}{hex(key_u[223:192])}{hex(key_u[191:160])}{hex(key_u[159:128])}{hex(key_u[127:96])}{hex(key_u[95:64])}{hex(key_u[63:32])}{hex(key_u[31:0])}"
        )
        nonce_u: uint96_t = array_to_uint_be(nonce)
        sim_print(
            f"Decrypt Nonce: {hex(nonce_u[95:64])}{hex(nonce_u[63:32])}{hex(nonce_u[31:0])}"
        )
        sim_print("AAD (29 bytes): Additional authenticated data")
        # Init input regs with first test ciphertext
        ciphertext_in_stream = input_ciphertexts[input_packet_count]
        ciphertext_remaining_in = ciphertext_lens[input_packet_count]
        input_tag = input_tags[input_packet_count]
        sim_print(f"Decrypting test string {input_packet_count}...")

    # Stream ciphertext + auth tag into dut
    axis_in_s: axis128_t = axis128_null()
    if ciphertext_remaining_in > 0:
        # Ciphertext words: keep marks exactly the remaining bytes (partial
        # on the final word), eod never set (the auth tag word follows)
        for i in range(16):
            axis_in_s.data.frag.keep[i] = ciphertext_remaining_in > i
            axis_in_s.data.frag.data[i] = 0
            if ciphertext_remaining_in > i:
                axis_in_s.data.frag.data[i] = ciphertext_in_stream[i]
        axis_in_s.data.eod[0] = 0
        axis_in_s.valid = 1
        if axis_in_s.valid & chacha20poly1305_decrypt_ports.axis_in_ready:
            in_chunk: uint128_t = array_to_uint_be(axis_in_s.data.frag.data)
            sim_print(
                f"Decrypt: Input Ciphertext next 16 bytes: {hex(in_chunk[127:96])}{hex(in_chunk[95:64])}{hex(in_chunk[63:32])}{hex(in_chunk[31:0])}"
            )
            if ciphertext_remaining_in > 16:
                ciphertext_remaining_in = ciphertext_remaining_in - 16
                # ARRAY_SHIFT_DOWN(ciphertext_in_stream, CIPHERTEXT_IN_MAX_SIZE, 16)
                for i in range(CIPHERTEXT_IN_MAX_SIZE - 16):
                    ciphertext_in_stream[i] = ciphertext_in_stream[i + 16]
            else:
                # Final (possibly partial) ciphertext word sent: tag is next
                ciphertext_remaining_in = 0
    elif input_packet_count < NUM_PACKETS:
        # Auth tag word: all 16 lanes kept, ends the input packet
        for i in range(POLY1305_AUTH_TAG_SIZE):
            axis_in_s.data.frag.keep[i] = 1
            axis_in_s.data.frag.data[i] = input_tag[i]
        axis_in_s.data.eod[0] = 1
        axis_in_s.valid = 1
        if axis_in_s.valid & chacha20poly1305_decrypt_ports.axis_in_ready:
            tag_chunk: uint128_t = array_to_uint_be(axis_in_s.data.frag.data)
            sim_print(
                f"Decrypt: Input Auth Tag: {hex(tag_chunk[127:96])}{hex(tag_chunk[95:64])}{hex(tag_chunk[63:32])}{hex(tag_chunk[31:0])}"
            )
            sim_print(
                f"Decrypt: End of input Ciphertext/Tag for test {input_packet_count}"
            )
            input_packet_count = input_packet_count + 1
            if input_packet_count < NUM_PACKETS:
                # Reset for next test string
                ciphertext_in_stream = input_ciphertexts[input_packet_count]
                ciphertext_remaining_in = ciphertext_lens[input_packet_count]
                input_tag = input_tags[input_packet_count]
                sim_print(f"Decrypting next test string {input_packet_count}...")
    chacha20poly1305_decrypt_ports.axis_in = axis_in_s

    # --- Output State Machine (Checks PLAINTEXT + is_verified) ---
    output_packet_count: Reg[uint32_t]
    plaintext_out_size: Reg[uint32_t]
    plaintext_remaining_out: Reg[uint32_t]
    plaintext_out_expected: Reg[uint8_t[PLAINTEXT_MAX_SIZE]]
    expected_verified: Reg[uint1_t]

    if cycle_counter == 0:
        # Init output regs with first expected plaintext
        plaintext_out_expected = expected_plaintexts[output_packet_count]
        plaintext_out_size = plaintext_lens[output_packet_count]
        plaintext_remaining_out = plaintext_out_size
        expected_verified = expected_verified_flags[output_packet_count]
        sim_print(f"Decrypt: Checking Plaintext for test string {output_packet_count}...")

    # Testbench is ready to receive plaintext
    chacha20poly1305_decrypt_ports.axis_out_ready = 1
    out_axis: axis128_t = chacha20poly1305_decrypt_ports.axis_out
    if out_axis.valid:
        # Print plaintext as it flows out of dut
        out_chunk: uint128_t = array_to_uint_be(out_axis.data.frag.data)
        sim_print(
            f"Decrypt: Output Plaintext next 16 bytes: {hex(out_chunk[127:96])}{hex(out_chunk[95:64])}{hex(out_chunk[63:32])}{hex(out_chunk[31:0])}"
        )

        # The verification result rides alongside the whole output packet
        sim_assert(
            chacha20poly1305_decrypt_ports.is_verified_out == expected_verified,
            f"Decrypt: is_verified mismatch. expected {expected_verified} got {chacha20poly1305_decrypt_ports.is_verified_out}",
        )

        # Compare keep pattern (partial on the final word) and, for kept
        # lanes, the data bytes to the expected plaintext
        for i in range(16):
            expected_keep: uint1_t = plaintext_remaining_out > i
            # lane index as a fixed-width value: a bare {i} literal's width
            # would vary across the unrolled iterations, giving each
            # sim_assert instance a different port width
            lane: uint8_t = i
            sim_assert(
                out_axis.data.frag.keep[i] == expected_keep,
                f"Decrypt: Plaintext keep mismatch at lane {lane}. expected {expected_keep} got {out_axis.data.frag.keep[i]}",
            )
            if expected_keep:
                plaintext_pos: uint32_t = (
                    plaintext_out_size - plaintext_remaining_out
                ) + i
                sim_assert(
                    out_axis.data.frag.data[i] == plaintext_out_expected[i],
                    f"Decrypt: Plaintext mismatch at byte[{plaintext_pos}]. expected {hex(plaintext_out_expected[i])} got {hex(out_axis.data.frag.data[i])}",
                )

        # Handle stream end
        if out_axis.data.eod[0]:
            sim_assert(
                plaintext_remaining_out <= 16,
                "Decrypt: Early end to Plaintext output!",
            )
            sim_print(f"Decrypt: Test {output_packet_count} DONE!")
            output_packet_count = output_packet_count + 1
            if output_packet_count < NUM_PACKETS:
                # Reset for next test string
                plaintext_out_expected = expected_plaintexts[output_packet_count]
                plaintext_out_size = plaintext_lens[output_packet_count]
                plaintext_remaining_out = plaintext_out_size
                expected_verified = expected_verified_flags[output_packet_count]
                sim_print(
                    f"Decrypt: Checking plaintext for next test string {output_packet_count}..."
                )
            else:
                # All packets checked -- signal completion (sticky; see
                # decrypt_all_done's declaration above). The top-level file
                # decides when it's safe to actually call sim_finish().
                decrypt_all_done_reg = 1
        else:
            sim_assert(
                plaintext_remaining_out > 16,
                "Decrypt: Plaintext word missing end of packet!",
            )
            if plaintext_remaining_out > 16:
                plaintext_remaining_out = plaintext_remaining_out - 16
                # ARRAY_SHIFT_DOWN(plaintext_out_expected, PLAINTEXT_MAX_SIZE, 16)
                for i in range(PLAINTEXT_MAX_SIZE - 16):
                    plaintext_out_expected[i] = plaintext_out_expected[i + 16]

    cycle_counter = cycle_counter + 1

    # dummy return for synthesis
    # so everything doesnt optimize away
    return chacha20poly1305_decrypt_ports.axis_out
