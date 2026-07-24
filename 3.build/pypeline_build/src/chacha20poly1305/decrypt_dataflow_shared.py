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

from aead_types import axis128_fb_t
from decrypt_dataflow_core import make_decrypt_dataflow_core

decrypt_dataflow_core, decrypt_dataflow_core_t = make_decrypt_dataflow_core(
    chacha20_pipeline_shared.chacha20_decrypt_shared
)


@MAIN(80.0)
def decrypt_dataflow_shared():
    # Crossing out of the implied-feedback world: the dataflow core is an
    # ordinary hw_func here, so the reverse halves go in as arguments and come
    # back out as named return fields, and are unpacked onto the design's
    # flat DUT-facing port wires.
    axis_out_rev: axis128_fb_t = axis128_fb_t(ready=chacha20poly1305_decrypt_ports.axis_out_ready)
    r = decrypt_dataflow_core(
        axis_in_if=chacha20poly1305_decrypt_ports.axis_in,
        key=chacha20poly1305_decrypt_ports.key,
        nonce=chacha20poly1305_decrypt_ports.nonce,
        aad=chacha20poly1305_decrypt_ports.aad,
        aad_len=chacha20poly1305_decrypt_ports.aad_len,
        axis_out_if=axis_out_rev,  # reverse half of the output port
    )
    chacha20poly1305_decrypt_ports.axis_in_ready = r.axis_in_if.ready
    chacha20poly1305_decrypt_ports.axis_out = r.axis_out_if
    chacha20poly1305_decrypt_ports.is_verified_out = r.is_verified_out
