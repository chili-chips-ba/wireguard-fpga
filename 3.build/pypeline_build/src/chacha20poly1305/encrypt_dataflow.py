# pyright: reportInvalidTypeForm=none
"""The primary dataflow for single clock domain ChaCha20-Poly1305 encryption.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_dataflow.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN

import chacha20poly1305_encrypt_ports
import chacha20

from encrypt_dataflow_core import make_encrypt_dataflow_core

encrypt_dataflow_core = make_encrypt_dataflow_core(chacha20.chacha20_instance)


@MAIN(80.0)
def encrypt_dataflow():
    r = encrypt_dataflow_core(
        chacha20poly1305_encrypt_ports.axis_in,
        chacha20poly1305_encrypt_ports.key,
        chacha20poly1305_encrypt_ports.nonce,
        chacha20poly1305_encrypt_ports.aad,
        chacha20poly1305_encrypt_ports.aad_len,
        chacha20poly1305_encrypt_ports.axis_out_ready,
    )
    chacha20poly1305_encrypt_ports.axis_in_ready = r.ports_axis_in_ready
    chacha20poly1305_encrypt_ports.axis_out = r.ports_axis_out
