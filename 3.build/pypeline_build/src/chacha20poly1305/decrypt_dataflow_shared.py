# pyright: reportInvalidTypeForm=none
"""Decrypt dataflow for the shared design — identical to decrypt_dataflow.py
except the chacha20 instance is chacha20_decrypt_shared (which uses the
shared compute pipeline).

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_dataflow.c
as included by decrypt_shared.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN

import chacha20poly1305_decrypt_ports
import chacha20_decrypt_shared
import prep_auth_data_decrypt
import poly1305_mac_decrypt
import poly1305_verify_decrypt
import strip_auth_tag
import wait_to_verify

from decrypt_dataflow_core import decrypt_dataflow_core


@MAIN(80.0)
def decrypt_dataflow_shared():
    r = decrypt_dataflow_core(
        chacha20poly1305_decrypt_ports.axis_in,
        chacha20poly1305_decrypt_ports.key,
        chacha20poly1305_decrypt_ports.nonce,
        chacha20poly1305_decrypt_ports.aad,
        chacha20poly1305_decrypt_ports.aad_len,
        chacha20poly1305_decrypt_ports.axis_out_ready,
        strip_auth_tag.axis_in_ready,
        strip_auth_tag.axis_out,
        strip_auth_tag.auth_tag_out,
        chacha20_decrypt_shared.axis_in_ready,
        chacha20_decrypt_shared.poly_key,
        chacha20_decrypt_shared.axis_out,
        prep_auth_data_decrypt.axis_in_ready,
        prep_auth_data_decrypt.axis_out,
        poly1305_mac_decrypt.key_ready,
        poly1305_mac_decrypt.data_in_ready,
        poly1305_mac_decrypt.auth_tag,
        poly1305_verify_decrypt.auth_tag_ready,
        poly1305_verify_decrypt.calc_tag_ready,
        poly1305_verify_decrypt.tags_match,
        wait_to_verify.axis_in_ready,
        wait_to_verify.verify_bit_ready,
        wait_to_verify.axis_out,
        wait_to_verify.is_verified_out,
    )
    strip_auth_tag.axis_in = r.strip_axis_in
    strip_auth_tag.axis_out_ready = r.strip_axis_out_ready
    strip_auth_tag.auth_tag_out_ready = r.strip_auth_tag_out_ready
    chacha20_decrypt_shared.key = r.chacha_key
    chacha20_decrypt_shared.nonce = r.chacha_nonce
    chacha20_decrypt_shared.axis_in = r.chacha_axis_in
    chacha20_decrypt_shared.poly_key_ready = r.chacha_poly_key_ready
    chacha20_decrypt_shared.axis_out_ready = r.chacha_axis_out_ready
    chacha20poly1305_decrypt_ports.axis_in_ready = r.ports_axis_in_ready
    chacha20poly1305_decrypt_ports.axis_out = r.ports_axis_out
    chacha20poly1305_decrypt_ports.is_verified_out = r.ports_is_verified_out
    prep_auth_data_decrypt.aad = r.prep_aad
    prep_auth_data_decrypt.aad_len = r.prep_aad_len
    prep_auth_data_decrypt.axis_in = r.prep_axis_in
    prep_auth_data_decrypt.axis_out_ready = r.prep_axis_out_ready
    poly1305_mac_decrypt.key = r.mac_key
    poly1305_mac_decrypt.data_in = r.mac_data_in
    poly1305_mac_decrypt.auth_tag_ready = r.mac_auth_tag_ready
    poly1305_verify_decrypt.auth_tag = r.verify_auth_tag
    poly1305_verify_decrypt.calc_tag = r.verify_calc_tag
    poly1305_verify_decrypt.tags_match_ready = r.verify_tags_match_ready
    wait_to_verify.axis_in = r.wtv_axis_in
    wait_to_verify.verify_bit = r.wtv_verify_bit
    wait_to_verify.axis_out_ready = r.wtv_axis_out_ready
