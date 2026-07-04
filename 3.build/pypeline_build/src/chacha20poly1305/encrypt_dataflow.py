# pyright: reportInvalidTypeForm=none
"""The primary dataflow for single clock domain ChaCha20-Poly1305 encryption.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_dataflow.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, uint1_t

import chacha20poly1305_encrypt_ports
import chacha20_encrypt
import prep_auth_data_encrypt
import poly1305_mac_encrypt
import append_auth_tag

from aead_types import axis128_2broadcast


@MAIN(80.0)
def encrypt_dataflow():
    # Connect chacha20poly1305_encrypt_* input stream to chacha20
    chacha20_encrypt.axis_in = chacha20poly1305_encrypt_ports.axis_in
    chacha20poly1305_encrypt_ports.axis_in_ready = chacha20_encrypt.axis_in_ready
    chacha20_encrypt.key = chacha20poly1305_encrypt_ports.key
    chacha20_encrypt.nonce = chacha20poly1305_encrypt_ports.nonce

    # Connect chacha20 output poly key into poly1305_mac key input
    poly1305_mac_encrypt.key = chacha20_encrypt.poly_key
    chacha20_encrypt.poly_key_ready = poly1305_mac_encrypt.key_ready

    # Connect chacha20 ciphertext output to both
    #  prep_auth_data input
    #  append auth tag input
    sink_ready_s: uint1_t[2]
    sink_ready_s[0] = prep_auth_data_encrypt.axis_in_ready
    sink_ready_s[1] = append_auth_tag.axis_in_ready
    bcast = axis128_2broadcast(chacha20_encrypt.axis_out, sink_ready_s)
    prep_auth_data_encrypt.axis_in = bcast.axis_out[0]
    append_auth_tag.axis_in = bcast.axis_out[1]
    chacha20_encrypt.axis_out_ready = bcast.axis_in_ready

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
