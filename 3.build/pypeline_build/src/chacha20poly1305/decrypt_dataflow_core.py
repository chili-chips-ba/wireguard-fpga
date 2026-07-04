# pyright: reportInvalidTypeForm=none
"""Shared connecting logic for the decrypt dataflow, used by both
decrypt_dataflow.py and decrypt_dataflow_shared.py (which differ only in
which chacha20 instance's wires they pass in/scatter back to).
"""
import pypeline_env  # noqa: F401

from pypeline import hw_func, struct, NamedTuple, uint1_t, uint8_t

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_t,
    axis128_2broadcast,
    poly1305_key_stream_t,
    poly1305_auth_tag_stream_t,
    uint1_stream_t,
)


@struct
class decrypt_dataflow_core_t(NamedTuple):
    # To strip_auth_tag
    strip_axis_in: axis128_t
    strip_axis_out_ready: uint1_t
    strip_auth_tag_out_ready: uint1_t
    # To chacha20 instance
    chacha_key: uint8_t[CHACHA20_KEY_SIZE]
    chacha_nonce: uint8_t[CHACHA20_NONCE_SIZE]
    chacha_axis_in: axis128_t
    chacha_poly_key_ready: uint1_t
    chacha_axis_out_ready: uint1_t
    # To top-level ports
    ports_axis_in_ready: uint1_t
    ports_axis_out: axis128_t
    ports_is_verified_out: uint1_t
    # To prep_auth_data_decrypt
    prep_aad: uint8_t[AAD_MAX_LEN]
    prep_aad_len: uint8_t
    prep_axis_in: axis128_t
    prep_axis_out_ready: uint1_t
    # To poly1305_mac_decrypt
    mac_key: poly1305_key_stream_t
    mac_data_in: axis128_t
    mac_auth_tag_ready: uint1_t
    # To poly1305_verify_decrypt
    verify_auth_tag: poly1305_auth_tag_stream_t
    verify_calc_tag: poly1305_auth_tag_stream_t
    verify_tags_match_ready: uint1_t
    # To wait_to_verify
    wtv_axis_in: axis128_t
    wtv_verify_bit: uint1_stream_t
    wtv_axis_out_ready: uint1_t


@hw_func
def decrypt_dataflow_core(
    # From top-level ports
    ports_axis_in: axis128_t,
    ports_key: uint8_t[CHACHA20_KEY_SIZE],
    ports_nonce: uint8_t[CHACHA20_NONCE_SIZE],
    ports_aad: uint8_t[AAD_MAX_LEN],
    ports_aad_len: uint8_t,
    ports_axis_out_ready: uint1_t,
    # From strip_auth_tag
    strip_axis_in_ready: uint1_t,
    strip_axis_out: axis128_t,
    strip_auth_tag_out: poly1305_auth_tag_stream_t,
    # From chacha20 instance (chacha20_decrypt or chacha20_decrypt_shared)
    chacha_axis_in_ready: uint1_t,
    chacha_poly_key: poly1305_key_stream_t,
    chacha_axis_out: axis128_t,
    # From prep_auth_data_decrypt
    prep_axis_in_ready: uint1_t,
    prep_axis_out: axis128_t,
    # From poly1305_mac_decrypt
    mac_key_ready: uint1_t,
    mac_data_in_ready: uint1_t,
    mac_auth_tag: poly1305_auth_tag_stream_t,
    # From poly1305_verify_decrypt
    verify_auth_tag_ready: uint1_t,
    verify_calc_tag_ready: uint1_t,
    verify_tags_match: uint1_stream_t,
    # From wait_to_verify
    wtv_axis_in_ready: uint1_t,
    wtv_verify_bit_ready: uint1_t,
    wtv_axis_out: axis128_t,
    wtv_is_verified_out: uint1_t,
) -> decrypt_dataflow_core_t:
    o: decrypt_dataflow_core_t

    # Strip auth tag (splits input streams)
    # Connect chacha20poly1305_decrypt_* input stream to strip_auth_tag
    o.strip_axis_in = ports_axis_in
    o.ports_axis_in_ready = strip_axis_in_ready

    # Poly1305 key generation and MAC connection
    # The key goes to chacha20 first to generate the Poly1305 key
    o.chacha_key = ports_key
    o.chacha_nonce = ports_nonce

    # Connect chacha20 poly key output to poly1305_mac key input
    o.mac_key = chacha_poly_key
    o.chacha_poly_key_ready = mac_key_ready

    # Ciphertext stream fork
    # The stripped ciphertext stream must be forked to two consumers:
    # a) prep_auth_data (for MAC calculation)
    # b) chacha20 (for actual decryption)
    sink_ready_s: uint1_t[2]
    sink_ready_s[0] = prep_axis_in_ready
    sink_ready_s[1] = chacha_axis_in_ready
    bcast = axis128_2broadcast(strip_axis_out, sink_ready_s)
    o.prep_axis_in = bcast.axis_out[0]
    o.chacha_axis_in = bcast.axis_out[1]
    o.strip_axis_out_ready = bcast.axis_in_ready

    # Prepare auth data and calculate MAC
    # prep_auth_data CSR inputs
    o.prep_aad = ports_aad
    o.prep_aad_len = ports_aad_len

    # Connect prep_auth_data output to poly1305_mac input
    o.mac_data_in = prep_axis_out
    o.prep_axis_out_ready = mac_data_in_ready

    # Poly1305 verification
    # Connect strip_auth_tag (input tag) and poly1305_mac (calculated tag)
    # to poly1305_verify
    o.verify_auth_tag = strip_auth_tag_out
    o.strip_auth_tag_out_ready = verify_auth_tag_ready

    o.verify_calc_tag = mac_auth_tag
    o.mac_auth_tag_ready = verify_calc_tag_ready

    # Wait to verify (buffer plaintext)
    # Connect chacha20 decrypt output (plaintext stream) to wait_to_verify
    # input (buffering FIFO)
    o.wtv_axis_in = chacha_axis_out
    o.chacha_axis_out_ready = wtv_axis_in_ready

    # Connect poly1305_verify output (result bit) to wait_to_verify trigger input
    o.wtv_verify_bit = verify_tags_match
    o.verify_tags_match_ready = wtv_verify_bit_ready

    # Connect wait_to_verify output to the top-level final output
    o.ports_axis_out = wtv_axis_out
    o.wtv_axis_out_ready = ports_axis_out_ready

    # Connect final verification result parallel wire
    o.ports_is_verified_out = wtv_is_verified_out

    return o
