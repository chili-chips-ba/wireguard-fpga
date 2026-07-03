# pyright: reportInvalidTypeForm=none
"""Encrypt dataflow for the shared design — identical to encrypt_dataflow.py
except the chacha20 instance is chacha20_encrypt_shared (which uses the
shared compute pipeline).

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_dataflow.c
as included by encrypt_shared.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, uint1_t

import chacha20poly1305_encrypt_ports
import chacha20_encrypt_shared
import prep_auth_data_encrypt
import poly1305_mac_encrypt
import append_auth_tag

from aead_types import axis128_t


@MAIN(80.0)
def encrypt_dataflow_shared():
    # Connect chacha20poly1305_encrypt_* input stream to chacha20
    chacha20_encrypt_shared.axis_in = chacha20poly1305_encrypt_ports.axis_in
    chacha20poly1305_encrypt_ports.axis_in_ready = chacha20_encrypt_shared.axis_in_ready
    chacha20_encrypt_shared.key = chacha20poly1305_encrypt_ports.key
    chacha20_encrypt_shared.nonce = chacha20poly1305_encrypt_ports.nonce

    # Connect chacha20 output poly key into poly1305_mac key input
    poly1305_mac_encrypt.key = chacha20_encrypt_shared.poly_key
    chacha20_encrypt_shared.poly_key_ready = poly1305_mac_encrypt.key_ready

    # Connect chacha20 ciphertext output to both
    #  prep_auth_data input
    #  append auth tag input
    # Fork the stream by combining valids and readys
    #  default no data passing, invalidate passthrough
    prep_axis_in_s: axis128_t = chacha20_encrypt_shared.axis_out
    prep_axis_in_s.valid = 0
    append_axis_in_s: axis128_t = chacha20_encrypt_shared.axis_out
    append_axis_in_s.valid = 0
    #  allow pass through if both sinks are ready
    #  or if sink isnt ready (no data passing anyway)
    chacha_axis_out_ready_s: uint1_t = (
        prep_auth_data_encrypt.axis_in_ready & append_auth_tag.axis_in_ready
    )
    if chacha_axis_out_ready_s | ~prep_auth_data_encrypt.axis_in_ready:
        prep_axis_in_s.valid = chacha20_encrypt_shared.axis_out.valid
    if chacha_axis_out_ready_s | ~append_auth_tag.axis_in_ready:
        append_axis_in_s.valid = chacha20_encrypt_shared.axis_out.valid
    prep_auth_data_encrypt.axis_in = prep_axis_in_s
    append_auth_tag.axis_in = append_axis_in_s
    chacha20_encrypt_shared.axis_out_ready = chacha_axis_out_ready_s

    # Prep auth data CSR inputs
    prep_auth_data_encrypt.aad = chacha20poly1305_encrypt_ports.aad
    prep_auth_data_encrypt.aad_len = chacha20poly1305_encrypt_ports.aad_len

    # Connect prep_auth_data output to poly1305_mac input
    poly1305_mac_encrypt.data_in = prep_auth_data_encrypt.axis_out
    prep_auth_data_encrypt.axis_out_ready = poly1305_mac_encrypt.data_in_ready

    # Connect poly1305_mac auth tag output to append auth tag input
    append_auth_tag.auth_tag_in = poly1305_mac_encrypt.auth_tag
    poly1305_mac_encrypt.auth_tag_ready = append_auth_tag.auth_tag_in_ready

    # Connect append auth tag output to chacha20poly1305_encrypt_* output
    chacha20poly1305_encrypt_ports.axis_out = append_auth_tag.axis_out
    append_auth_tag.axis_out_ready = chacha20poly1305_encrypt_ports.axis_out_ready
