# pyright: reportInvalidTypeForm=none
"""Synthesizable testbench for the standalone encrypt design.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_tb.c.
Streams the test plaintexts into the DUT wires (with exact tkeep, partial on
the final word of each packet) and checks the ciphertext + auth tag stream
coming out — data bytes, the exact per-lane keep pattern, and packet framing
(eod only on the appended auth tag word) — printing "ERROR: ..." on any
mismatch and "Encrypt: Test N DONE!" per passing packet.
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    wires,
    Reg,
    uint1_t,
    uint8_t,
    uint32_t,
    sim_print,
    array_to_uint_be,
)

import chacha20poly1305_encrypt_ports

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
)


# CSR values available all at once do not need to be static=registers
# Streaming inputs data is done as shift register
@MAIN
@wires
def encrypt_tb() -> axis128_t:
    # Test vectors
    key: uint8_t[CHACHA20_KEY_SIZE] = KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = NONCE
    aad: uint8_t[AAD_MAX_LEN] = AAD
    plaintexts: uint8_t[NUM_PLAINTEXT_TEST_STRS][PLAINTEXT_TEST_STR_MAX_SIZE] = (
        PLAINTEXTS
    )
    plaintext_lens: uint32_t[NUM_PLAINTEXT_TEST_STRS] = PLAINTEXT_LENS
    expected_ciphertexts: uint8_t[NUM_PLAINTEXT_TEST_STRS][CIPHERTEXT_MAX_SIZE] = (
        EXPECTED_CIPHERTEXTS
    )
    expected_tags: uint8_t[NUM_PLAINTEXT_TEST_STRS][POLY1305_AUTH_TAG_SIZE] = (
        EXPECTED_TAGS
    )
    ciphertext_lens: uint32_t[NUM_PLAINTEXT_TEST_STRS] = CIPHERTEXT_LENS

    # Connect CSR inputs to dut
    chacha20poly1305_encrypt_ports.key = key
    chacha20poly1305_encrypt_ports.nonce = nonce
    chacha20poly1305_encrypt_ports.aad = aad
    chacha20poly1305_encrypt_ports.aad_len = AAD_LEN

    # Registers for the input side of testbench state machine
    input_packet_count: Reg[uint32_t]
    plaintext: Reg[uint8_t[PLAINTEXT_TEST_STR_MAX_SIZE]]
    plaintext_remaining: Reg[uint32_t]
    cycle_counter: Reg[uint32_t]

    # Encrypt:
    if cycle_counter == 0:
        sim_print("=== ChaCha20-Poly1305 Encryption Test ===")
        # Print test inputs
        key_u: uint256_t = array_to_uint_be(key)
        sim_print(
            f"Encrypt Key: {hex(key_u[255:224])}{hex(key_u[223:192])}{hex(key_u[191:160])}{hex(key_u[159:128])}{hex(key_u[127:96])}{hex(key_u[95:64])}{hex(key_u[63:32])}{hex(key_u[31:0])}"
        )
        nonce_u: uint96_t = array_to_uint_be(nonce)
        sim_print(
            f"Encrypt Nonce: {hex(nonce_u[95:64])}{hex(nonce_u[63:32])}{hex(nonce_u[31:0])}"
        )
        sim_print("AAD (29 bytes): Additional authenticated data")
        # Init regs with first test string
        plaintext = plaintexts[input_packet_count]
        plaintext_remaining = plaintext_lens[input_packet_count]
        sim_print(f"Encrypting test string {input_packet_count}...")

    # Stream plaintext into dut
    axis_in_s: axis128_t = axis128_null()
    # Have valid data if there is more plaintext to send
    if plaintext_remaining > 0:
        # Up to 16 bytes of plaintext onto axis128: keep marks exactly the
        # valid lanes (partial on the final word), non-kept data lanes zero
        for i in range(16):
            axis_in_s.data.frag.keep[i] = plaintext_remaining > i
            axis_in_s.data.frag.data[i] = 0
            if plaintext_remaining > i:
                axis_in_s.data.frag.data[i] = plaintext[i]
        axis_in_s.data.eod[0] = plaintext_remaining <= 16
        axis_in_s.valid = 1
        if axis_in_s.valid & chacha20poly1305_encrypt_ports.axis_in_ready:
            in_chunk: uint128_t = array_to_uint_be(axis_in_s.data.frag.data)
            sim_print(
                f"Encrypt: Input Plaintext next 16 bytes: {hex(in_chunk[127:96])}{hex(in_chunk[95:64])}{hex(in_chunk[63:32])}{hex(in_chunk[31:0])}"
            )
            if axis_in_s.data.eod[0]:
                sim_print(f"Encrypt: End of input plaintext for test {input_packet_count}")
                plaintext_remaining = 0
                input_packet_count = input_packet_count + 1
                if input_packet_count < NUM_PLAINTEXT_TEST_STRS:
                    # Reset for next test string
                    plaintext = plaintexts[input_packet_count]
                    plaintext_remaining = plaintext_lens[input_packet_count]
                    sim_print(f"Encrypting next test string {input_packet_count}...")
            else:
                plaintext_remaining = plaintext_remaining - 16
                # ARRAY_SHIFT_DOWN(plaintext, PLAINTEXT_TEST_STR_MAX_SIZE, 16)
                for i in range(PLAINTEXT_TEST_STR_MAX_SIZE - 16):
                    plaintext[i] = plaintext[i + 16]
    chacha20poly1305_encrypt_ports.axis_in = axis_in_s

    # Registers for the output side of testbench state machine
    output_packet_count: Reg[uint32_t]
    ciphertext_size: Reg[uint32_t]
    ciphertext_remaining: Reg[uint32_t]
    expected_ciphertext: Reg[uint8_t[CIPHERTEXT_MAX_SIZE]]
    expected_tag: Reg[uint8_t[POLY1305_AUTH_TAG_SIZE]]

    # Check encrypted ciphertext output:
    if cycle_counter == 0:
        # Init regs for first test string
        expected_ciphertext = expected_ciphertexts[output_packet_count]
        expected_tag = expected_tags[output_packet_count]
        ciphertext_size = ciphertext_lens[output_packet_count]
        ciphertext_remaining = ciphertext_size
        sim_print(f"Encrypt: Checking ciphertext for test string {output_packet_count}...")

    # Stream ciphertext out of dut (testbench always ready)
    chacha20poly1305_encrypt_ports.axis_out_ready = 1
    out_axis: axis128_t = chacha20poly1305_encrypt_ports.axis_out
    if out_axis.valid:
        # Print output as it flows out of dut
        out_chunk: uint128_t = array_to_uint_be(out_axis.data.frag.data)
        sim_print(
            f"Encrypt: Output Ciphertext/Tag next 16 bytes: {hex(out_chunk[127:96])}{hex(out_chunk[95:64])}{hex(out_chunk[63:32])}{hex(out_chunk[31:0])}"
        )
        if ciphertext_remaining > 0:
            # Expecting a ciphertext word: keep marks exactly the remaining
            # bytes (partial on the final word of an odd-length ciphertext)
            # and eod is never set here (the auth tag word is still to come)
            for i in range(16):
                expected_keep: uint1_t = ciphertext_remaining > i
                if out_axis.data.frag.keep[i] != expected_keep:
                    # lane index as a fixed-width value: a bare {i} literal's
                    # width would vary across the unrolled iterations, giving
                    # each printf instance a different port width
                    lane: uint8_t = i
                    sim_print(
                        f"ERROR: Encrypt: Ciphertext keep mismatch at lane {lane}. expected {expected_keep} got {out_axis.data.frag.keep[i]}"
                    )
                if expected_keep:
                    if out_axis.data.frag.data[i] != expected_ciphertext[i]:
                        ciphertext_pos: uint32_t = (
                            ciphertext_size - ciphertext_remaining
                        ) + i
                        sim_print(
                            f"ERROR: Encrypt: Ciphertext mismatch at byte[{ciphertext_pos}]. expected {hex(expected_ciphertext[i])} got {hex(out_axis.data.frag.data[i])}"
                        )
            if out_axis.data.eod[0]:
                sim_print("ERROR: Encrypt: Early end to ciphertext output (before auth tag)!")
            if ciphertext_remaining > 16:
                ciphertext_remaining = ciphertext_remaining - 16
                # ARRAY_SHIFT_DOWN(expected_ciphertext, CIPHERTEXT_MAX_SIZE, 16)
                for i in range(CIPHERTEXT_MAX_SIZE - 16):
                    expected_ciphertext[i] = expected_ciphertext[i + 16]
            else:
                # Final (possibly partial) ciphertext word: auth tag is next
                ciphertext_remaining = 0
        else:
            # Expecting the auth tag word: all 16 lanes kept, ends the packet
            for i in range(POLY1305_AUTH_TAG_SIZE):
                # fixed-width lane index for printing (see ciphertext loop)
                tag_lane: uint8_t = i
                if ~out_axis.data.frag.keep[i]:
                    sim_print(f"ERROR: Encrypt: Auth tag keep not set at lane {tag_lane}!")
                if out_axis.data.frag.data[i] != expected_tag[i]:
                    sim_print(
                        f"ERROR: Encrypt: Auth tag mismatch at byte[{tag_lane}]. expected {hex(expected_tag[i])} got {hex(out_axis.data.frag.data[i])}"
                    )
            if ~out_axis.data.eod[0]:
                sim_print("ERROR: Encrypt: Auth tag word missing end of packet!")
            sim_print(f"Encrypt: Test {output_packet_count} DONE!")
            output_packet_count = output_packet_count + 1
            if output_packet_count < NUM_PLAINTEXT_TEST_STRS:
                # Reset for next test string
                expected_ciphertext = expected_ciphertexts[output_packet_count]
                expected_tag = expected_tags[output_packet_count]
                ciphertext_size = ciphertext_lens[output_packet_count]
                ciphertext_remaining = ciphertext_size
                sim_print(
                    f"Encrypt: Checking ciphertext for next test string {output_packet_count}..."
                )

    cycle_counter = cycle_counter + 1

    # dummy return for synthesis
    # so everything doesnt optimize away
    return chacha20poly1305_encrypt_ports.axis_out
