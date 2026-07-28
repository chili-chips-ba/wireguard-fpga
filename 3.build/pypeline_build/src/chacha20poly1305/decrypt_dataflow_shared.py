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

from aead_types import axis128_intrf
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
    r = decrypt_dataflow_core(
        # forward half of the input port, constructed inline
        axis_in_if=axis128_intrf.fwd_t(stream=chacha20poly1305_decrypt_ports.axis_in_if.stream),
        key=chacha20poly1305_decrypt_ports.key,
        nonce=chacha20poly1305_decrypt_ports.nonce,
        aad=chacha20poly1305_decrypt_ports.aad,
        aad_len=chacha20poly1305_decrypt_ports.aad_len,
        # reverse half of the output port, constructed inline
        axis_out_if=axis128_intrf.fb_t(ready=chacha20poly1305_decrypt_ports.axis_out_if.ready),
    )
    chacha20poly1305_decrypt_ports.axis_in_if.ready = r.axis_in_if.ready
    chacha20poly1305_decrypt_ports.axis_out_if.stream = r.axis_out_if.stream
    chacha20poly1305_decrypt_ports.is_verified_out = r.is_verified_out
