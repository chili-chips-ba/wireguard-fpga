# pyright: reportInvalidTypeForm=none
"""Synthesizable testbench for the standalone decrypt design.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_tb.c.
Streams the test ciphertext+tag packets into the DUT wires and checks the
plaintext stream coming out, printing "ERROR: ..." on any mismatch and
"Decrypt: Test N DONE!" per passing packet.
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    wires,
    Reg,
    uint8_t,
    uint32_t,
    sim_print,
    array_to_uint_be,
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
    CIPHERTEXT_OUT_MAX_SIZE,
    EXPECTED_CIPHERTEXTS,
    CIPHERTEXT_LENS,
)

# Decrypt runs the encrypt vectors in reverse:
# input = ciphertext+auth tag packets, expected output = plaintexts
NUM_PACKETS = NUM_PLAINTEXT_TEST_STRS
PLAINTEXT_MAX_SIZE = PLAINTEXT_TEST_STR_MAX_SIZE
CIPHERTEXT_IN_MAX_SIZE = CIPHERTEXT_OUT_MAX_SIZE
INPUT_CIPHERTEXTS = EXPECTED_CIPHERTEXTS


# CSR values available all at once do not need to be static=registers
# Streaming inputs data is done as shift register
@MAIN
@wires
def decrypt_tb() -> axis128_t:
    # Test vectors
    key: uint8_t[CHACHA20_KEY_SIZE] = KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = NONCE
    aad: uint8_t[AAD_MAX_LEN] = AAD
    plaintexts: uint8_t[NUM_PACKETS][PLAINTEXT_MAX_SIZE] = PLAINTEXTS
    plaintext_lens: uint32_t[NUM_PACKETS] = PLAINTEXT_LENS
    input_ciphertexts: uint8_t[NUM_PACKETS][CIPHERTEXT_IN_MAX_SIZE] = INPUT_CIPHERTEXTS
    ciphertext_lens: uint32_t[NUM_PACKETS] = CIPHERTEXT_LENS

    # Connect CSR inputs to dut
    chacha20poly1305_decrypt_ports.key = key
    chacha20poly1305_decrypt_ports.nonce = nonce
    chacha20poly1305_decrypt_ports.aad = aad
    chacha20poly1305_decrypt_ports.aad_len = AAD_LEN

    # --- Input State Machine (Streams CIPHERTEXT) ---
    input_packet_count: Reg[uint32_t]
    ciphertext_in_stream: Reg[uint8_t[CIPHERTEXT_IN_MAX_SIZE]]
    ciphertext_remaining_in: Reg[uint32_t]
    cycle_counter: Reg[uint32_t]

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
        sim_print(f"Decrypting test string {input_packet_count}...")

    # Stream ciphertext into dut
    axis_in_s: axis128_t = axis128_null()
    # Have valid data if there is more ciphertext to send
    if ciphertext_remaining_in > 0:
        # Up to 16 bytes of ciphertext/tag onto axis128
        for i in range(16):
            axis_in_s.data.frag.keep[i] = 1
            axis_in_s.data.frag.data[i] = 0
            if ciphertext_remaining_in > i:
                axis_in_s.data.frag.data[i] = ciphertext_in_stream[i]
        axis_in_s.data.eod[0] = ciphertext_remaining_in <= 16
        axis_in_s.valid = 1
        if axis_in_s.valid & chacha20poly1305_decrypt_ports.axis_in_ready:
            in_chunk: uint128_t = array_to_uint_be(axis_in_s.data.frag.data)
            sim_print(
                f"Decrypt: Input Ciphertext/Tag next 16 bytes: {hex(in_chunk[127:96])}{hex(in_chunk[95:64])}{hex(in_chunk[63:32])}{hex(in_chunk[31:0])}"
            )
            if axis_in_s.data.eod[0]:
                sim_print(
                    f"Decrypt: End of input Ciphertext/Tag for test {input_packet_count}"
                )
                ciphertext_remaining_in = 0
                input_packet_count = input_packet_count + 1
                if input_packet_count < NUM_PACKETS:
                    # Reset for next test string
                    ciphertext_in_stream = input_ciphertexts[input_packet_count]
                    ciphertext_remaining_in = ciphertext_lens[input_packet_count]
                    sim_print(f"Decrypting next test string {input_packet_count}...")
            else:
                ciphertext_remaining_in = ciphertext_remaining_in - 16
                # ARRAY_SHIFT_DOWN(ciphertext_in_stream, CIPHERTEXT_IN_MAX_SIZE, 16)
                for i in range(CIPHERTEXT_IN_MAX_SIZE - 16):
                    ciphertext_in_stream[i] = ciphertext_in_stream[i + 16]
    chacha20poly1305_decrypt_ports.axis_in = axis_in_s

    # --- Output State Machine (Checks PLAINTEXT) ---
    output_packet_count: Reg[uint32_t]
    plaintext_out_size: Reg[uint32_t]
    plaintext_remaining_out: Reg[uint32_t]
    plaintext_out_expected: Reg[uint8_t[PLAINTEXT_MAX_SIZE]]

    if cycle_counter == 0:
        # Init output regs with first expected plaintext
        plaintext_out_expected = plaintexts[output_packet_count]
        plaintext_out_size = plaintext_lens[output_packet_count]
        plaintext_remaining_out = plaintext_out_size
        sim_print(f"Decrypt: Checking Plaintext for test string {output_packet_count}...")

    # Testbench is ready to receive plaintext
    chacha20poly1305_decrypt_ports.axis_out_ready = 1
    out_s: axis128_t = chacha20poly1305_decrypt_ports.axis_out
    if out_s.valid:
        # Print plaintext as it flows out of dut
        out_chunk: uint128_t = array_to_uint_be(out_s.data.frag.data)
        sim_print(
            f"Decrypt: Output Plaintext next 16 bytes: {hex(out_chunk[127:96])}{hex(out_chunk[95:64])}{hex(out_chunk[63:32])}{hex(out_chunk[31:0])}"
        )

        # Compare to expected plaintext and shift expected array
        for i in range(16):
            if plaintext_remaining_out > i:
                if out_s.data.frag.data[i] != plaintext_out_expected[i]:
                    plaintext_pos: uint32_t = (
                        plaintext_out_size - plaintext_remaining_out
                    ) + i
                    sim_print(
                        f"ERROR: Decrypt: Plaintext mismatch at byte[{plaintext_pos}]. expected {hex(plaintext_out_expected[i])} got {hex(out_s.data.frag.data[i])}"
                    )

        # Too much data?
        if plaintext_remaining_out == 0:
            sim_print("ERROR: Decrypt: Extra Plaintext output!")
        # Handle stream end
        if out_s.data.eod[0]:
            if plaintext_remaining_out > 16:
                sim_print("ERROR: Decrypt: Early end to Plaintext output!")
            else:
                sim_print(f"Decrypt: Test {output_packet_count} DONE!")
                plaintext_remaining_out = 0
                output_packet_count = output_packet_count + 1
                if output_packet_count < NUM_PACKETS:
                    # Reset for next test string
                    plaintext_out_expected = plaintexts[output_packet_count]
                    plaintext_out_size = plaintext_lens[output_packet_count]
                    plaintext_remaining_out = plaintext_out_size
                    sim_print(
                        f"Decrypt: Checking plaintext for next test string {output_packet_count}..."
                    )
        else:
            plaintext_remaining_out = plaintext_remaining_out - 16
            # ARRAY_SHIFT_DOWN(plaintext_out_expected, PLAINTEXT_MAX_SIZE, 16)
            for i in range(PLAINTEXT_MAX_SIZE - 16):
                plaintext_out_expected[i] = plaintext_out_expected[i + 16]

    cycle_counter = cycle_counter + 1

    # dummy return for synthesis
    # so everything doesnt optimize away
    return chacha20poly1305_decrypt_ports.axis_out
