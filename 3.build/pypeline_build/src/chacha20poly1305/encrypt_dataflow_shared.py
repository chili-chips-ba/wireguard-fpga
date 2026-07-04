# pyright: reportInvalidTypeForm=none
"""Encrypt dataflow for the shared design — identical to encrypt_dataflow.py
except the chacha20 instance is chacha20_encrypt_shared (which uses the
shared compute pipeline).

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_dataflow.c
as included by encrypt_shared.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN

import chacha20poly1305_encrypt_ports
import chacha20_encrypt_shared
import prep_auth_data_encrypt
import poly1305_mac_encrypt
import append_auth_tag

from encrypt_dataflow_core import encrypt_dataflow_core


@MAIN(80.0)
def encrypt_dataflow_shared():
    r = encrypt_dataflow_core(
        chacha20poly1305_encrypt_ports.axis_in,
        chacha20poly1305_encrypt_ports.key,
        chacha20poly1305_encrypt_ports.nonce,
        chacha20poly1305_encrypt_ports.aad,
        chacha20poly1305_encrypt_ports.aad_len,
        chacha20poly1305_encrypt_ports.axis_out_ready,
        chacha20_encrypt_shared.axis_in_ready,
        chacha20_encrypt_shared.poly_key,
        chacha20_encrypt_shared.axis_out,
        prep_auth_data_encrypt.axis_in_ready,
        prep_auth_data_encrypt.axis_out,
        poly1305_mac_encrypt.key_ready,
        poly1305_mac_encrypt.data_in_ready,
        poly1305_mac_encrypt.auth_tag,
        append_auth_tag.axis_in_ready,
        append_auth_tag.auth_tag_in_ready,
        append_auth_tag.axis_out,
    )
    chacha20_encrypt_shared.axis_in = r.chacha_axis_in
    chacha20_encrypt_shared.key = r.chacha_key
    chacha20_encrypt_shared.nonce = r.chacha_nonce
    chacha20_encrypt_shared.poly_key_ready = r.chacha_poly_key_ready
    chacha20_encrypt_shared.axis_out_ready = r.chacha_axis_out_ready
    chacha20poly1305_encrypt_ports.axis_in_ready = r.ports_axis_in_ready
    chacha20poly1305_encrypt_ports.axis_out = r.ports_axis_out
    prep_auth_data_encrypt.aad = r.prep_aad
    prep_auth_data_encrypt.aad_len = r.prep_aad_len
    prep_auth_data_encrypt.axis_in = r.prep_axis_in
    prep_auth_data_encrypt.axis_out_ready = r.prep_axis_out_ready
    poly1305_mac_encrypt.key = r.mac_key
    poly1305_mac_encrypt.data_in = r.mac_data_in
    poly1305_mac_encrypt.auth_tag_ready = r.mac_auth_tag_ready
    append_auth_tag.axis_in = r.append_axis_in
    append_auth_tag.auth_tag_in = r.append_auth_tag_in
    append_auth_tag.axis_out_ready = r.append_axis_out_ready
