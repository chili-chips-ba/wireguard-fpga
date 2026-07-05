# pyright: reportInvalidTypeForm=none
"""Decrypt dataflow for the shared design — identical to decrypt_dataflow.py
except the chacha20 instance is chacha20_pipeline_shared.chacha20_decrypt_shared
(which uses the shared compute pipeline).

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_dataflow.c
as included by decrypt_shared.c.
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN

import chacha20poly1305_decrypt_ports
import chacha20_pipeline_shared

from decrypt_dataflow_core import make_decrypt_dataflow_core

decrypt_dataflow_core = make_decrypt_dataflow_core(
    chacha20_pipeline_shared.chacha20_decrypt_shared
)


@MAIN(80.0)
def decrypt_dataflow_shared():
    r = decrypt_dataflow_core(
        chacha20poly1305_decrypt_ports.axis_in,
        chacha20poly1305_decrypt_ports.key,
        chacha20poly1305_decrypt_ports.nonce,
        chacha20poly1305_decrypt_ports.aad,
        chacha20poly1305_decrypt_ports.aad_len,
        chacha20poly1305_decrypt_ports.axis_out_ready,
    )
    chacha20poly1305_decrypt_ports.axis_in_ready = r.ports_axis_in_ready
    chacha20poly1305_decrypt_ports.axis_out = r.ports_axis_out
    chacha20poly1305_decrypt_ports.is_verified_out = r.ports_is_verified_out
