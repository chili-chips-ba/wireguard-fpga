# pyright: reportInvalidTypeForm=none
"""Shared connecting logic for the encrypt dataflow, used by both
encrypt_dataflow.py and encrypt_dataflow_shared.py (which differ only in
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
)


@struct
class encrypt_dataflow_core_t(NamedTuple):
    # To chacha20 instance
    chacha_axis_in: axis128_t
    chacha_key: uint8_t[CHACHA20_KEY_SIZE]
    chacha_nonce: uint8_t[CHACHA20_NONCE_SIZE]
    chacha_poly_key_ready: uint1_t
    chacha_axis_out_ready: uint1_t
    # To top-level ports
    ports_axis_in_ready: uint1_t
    ports_axis_out: axis128_t
    # To prep_auth_data_encrypt
    prep_aad: uint8_t[AAD_MAX_LEN]
    prep_aad_len: uint8_t
    prep_axis_in: axis128_t
    prep_axis_out_ready: uint1_t
    # To poly1305_mac_encrypt
    mac_key: poly1305_key_stream_t
    mac_data_in: axis128_t
    mac_auth_tag_ready: uint1_t
    # To append_auth_tag
    append_axis_in: axis128_t
    append_auth_tag_in: poly1305_auth_tag_stream_t
    append_axis_out_ready: uint1_t


@hw_func
def encrypt_dataflow_core(
    # From top-level ports
    ports_axis_in: axis128_t,
    ports_key: uint8_t[CHACHA20_KEY_SIZE],
    ports_nonce: uint8_t[CHACHA20_NONCE_SIZE],
    ports_aad: uint8_t[AAD_MAX_LEN],
    ports_aad_len: uint8_t,
    ports_axis_out_ready: uint1_t,
    # From chacha20 instance (chacha20_encrypt or chacha20_encrypt_shared)
    chacha_axis_in_ready: uint1_t,
    chacha_poly_key: poly1305_key_stream_t,
    chacha_axis_out: axis128_t,
    # From prep_auth_data_encrypt
    prep_axis_in_ready: uint1_t,
    prep_axis_out: axis128_t,
    # From poly1305_mac_encrypt
    mac_key_ready: uint1_t,
    mac_data_in_ready: uint1_t,
    mac_auth_tag: poly1305_auth_tag_stream_t,
    # From append_auth_tag
    append_axis_in_ready: uint1_t,
    append_auth_tag_in_ready: uint1_t,
    append_axis_out: axis128_t,
) -> encrypt_dataflow_core_t:
    o: encrypt_dataflow_core_t

    # Connect chacha20poly1305_encrypt_* input stream to chacha20
    o.chacha_axis_in = ports_axis_in
    o.ports_axis_in_ready = chacha_axis_in_ready
    o.chacha_key = ports_key
    o.chacha_nonce = ports_nonce

    # Connect chacha20 output poly key into poly1305_mac key input
    o.mac_key = chacha_poly_key
    o.chacha_poly_key_ready = mac_key_ready

    # Connect chacha20 ciphertext output to both
    #  prep_auth_data input
    #  append auth tag input
    sink_ready_s: uint1_t[2]
    sink_ready_s[0] = prep_axis_in_ready
    sink_ready_s[1] = append_axis_in_ready
    bcast = axis128_2broadcast(chacha_axis_out, sink_ready_s)
    o.prep_axis_in = bcast.axis_out[0]
    o.append_axis_in = bcast.axis_out[1]
    o.chacha_axis_out_ready = bcast.axis_in_ready

    # Prep auth data CSR inputs
    o.prep_aad = ports_aad
    o.prep_aad_len = ports_aad_len

    # Connect prep_auth_data output to poly1305_mac input
    o.mac_data_in = prep_axis_out
    o.prep_axis_out_ready = mac_data_in_ready

    # Connect poly1305_mac auth tag output to append auth tag input
    o.append_auth_tag_in = mac_auth_tag
    o.mac_auth_tag_ready = append_auth_tag_in_ready

    # Connect append auth tag output to chacha20poly1305_encrypt_* output
    o.ports_axis_out = append_axis_out
    o.append_axis_out_ready = ports_axis_out_ready

    return o
