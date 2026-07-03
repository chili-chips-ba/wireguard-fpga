# pyright: reportInvalidTypeForm=none
"""The primary dataflow for single clock domain ChaCha20-Poly1305 decryption.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_dataflow.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, uint1_t

import chacha20poly1305_decrypt_ports
import chacha20_decrypt
import prep_auth_data_decrypt
import poly1305_mac_decrypt
import poly1305_verify_decrypt
import strip_auth_tag
import wait_to_verify

from aead_types import axis128_t


@MAIN(80.0)
def decrypt_dataflow():
    # Strip auth tag (splits input streams)
    # Connect chacha20poly1305_decrypt_* input stream to strip_auth_tag
    strip_auth_tag.axis_in = chacha20poly1305_decrypt_ports.axis_in
    chacha20poly1305_decrypt_ports.axis_in_ready = strip_auth_tag.axis_in_ready

    # Poly1305 key generation and MAC connection
    # The key goes to chacha20 first to generate the Poly1305 key
    chacha20_decrypt.key = chacha20poly1305_decrypt_ports.key
    chacha20_decrypt.nonce = chacha20poly1305_decrypt_ports.nonce

    # Connect chacha20 poly key output to poly1305_mac key input
    poly1305_mac_decrypt.key = chacha20_decrypt.poly_key
    chacha20_decrypt.poly_key_ready = poly1305_mac_decrypt.key_ready

    # Ciphertext stream fork
    # The stripped ciphertext stream must be forked to two consumers:
    # a) prep_auth_data (for MAC calculation)
    # b) chacha20 (for actual decryption)

    # Default: no data passing
    prep_axis_in_s: axis128_t = strip_auth_tag.axis_out
    prep_axis_in_s.valid = 0
    chacha_axis_in_s: axis128_t = strip_auth_tag.axis_out
    chacha_axis_in_s.valid = 0

    # The source (strip_auth_tag_axis_out) is ready only if both sinks are ready
    strip_axis_out_ready_s: uint1_t = (
        prep_auth_data_decrypt.axis_in_ready & chacha20_decrypt.axis_in_ready
    )
    # If a sink is not ready its allowed to see the pending valid=1
    # since no transfer happens anyway
    if strip_auth_tag.axis_out.valid:
        if strip_axis_out_ready_s | ~prep_auth_data_decrypt.axis_in_ready:
            prep_axis_in_s.valid = 1
        if strip_axis_out_ready_s | ~chacha20_decrypt.axis_in_ready:
            chacha_axis_in_s.valid = 1

    # Connect data streams
    prep_auth_data_decrypt.axis_in = prep_axis_in_s
    chacha20_decrypt.axis_in = chacha_axis_in_s
    strip_auth_tag.axis_out_ready = strip_axis_out_ready_s

    # Prepare auth data and calculate MAC
    # prep_auth_data CSR inputs
    prep_auth_data_decrypt.aad = chacha20poly1305_decrypt_ports.aad
    prep_auth_data_decrypt.aad_len = chacha20poly1305_decrypt_ports.aad_len

    # Connect prep_auth_data output to poly1305_mac input
    poly1305_mac_decrypt.data_in = prep_auth_data_decrypt.axis_out
    prep_auth_data_decrypt.axis_out_ready = poly1305_mac_decrypt.data_in_ready

    # Poly1305 verification
    # Connect strip_auth_tag (input tag) and poly1305_mac (calculated tag)
    # to poly1305_verify
    poly1305_verify_decrypt.auth_tag = strip_auth_tag.auth_tag_out
    strip_auth_tag.auth_tag_out_ready = poly1305_verify_decrypt.auth_tag_ready

    poly1305_verify_decrypt.calc_tag = poly1305_mac_decrypt.auth_tag
    poly1305_mac_decrypt.auth_tag_ready = poly1305_verify_decrypt.calc_tag_ready

    # Wait to verify (buffer plaintext)
    # Connect chacha20 decrypt output (plaintext stream) to wait_to_verify
    # input (buffering FIFO)
    wait_to_verify.axis_in = chacha20_decrypt.axis_out
    chacha20_decrypt.axis_out_ready = wait_to_verify.axis_in_ready

    # Connect poly1305_verify output (result bit) to wait_to_verify trigger input
    wait_to_verify.verify_bit = poly1305_verify_decrypt.tags_match
    poly1305_verify_decrypt.tags_match_ready = wait_to_verify.verify_bit_ready

    # Connect wait_to_verify output to the top-level final output
    chacha20poly1305_decrypt_ports.axis_out = wait_to_verify.axis_out
    wait_to_verify.axis_out_ready = chacha20poly1305_decrypt_ports.axis_out_ready

    # Connect final verification result parallel wire
    chacha20poly1305_decrypt_ports.is_verified_out = wait_to_verify.is_verified_out
