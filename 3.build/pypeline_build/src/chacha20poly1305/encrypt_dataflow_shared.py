# pyright: reportInvalidTypeForm=none
"""Encrypt dataflow for the shared design — identical to encrypt_dataflow.py
except the chacha20 instance is chacha20_pipeline_shared.chacha20_encrypt_shared
(which uses the shared compute pipeline).

Pypeline port of ../pipelinec_build/src/chacha20poly1305/encrypt_dataflow.c
as included by encrypt_shared.c.
"""
import wireguard_env  # noqa: F401

from pypeline import MAIN

import chacha20poly1305_encrypt_ports
import chacha20_pipeline_shared

from aead_types import axis128_intrf
from encrypt_dataflow_core import make_encrypt_dataflow_core

encrypt_dataflow_core, encrypt_dataflow_core_t = make_encrypt_dataflow_core(
    chacha20_pipeline_shared.chacha20_encrypt_shared
)


@MAIN(80.0)
def encrypt_dataflow_shared():
    # Crossing out of the implied-feedback world: the dataflow core is an
    # ordinary hw_func here, so the reverse halves go in as arguments and come
    # back out as named return fields, and are unpacked onto the design's
    # flat DUT-facing port wires.
    r = encrypt_dataflow_core(
        # forward half of the input port, constructed inline
        axis_in_if=axis128_intrf.fwd_t(stream=chacha20poly1305_encrypt_ports.axis_in_if.stream),
        key=chacha20poly1305_encrypt_ports.key,
        nonce=chacha20poly1305_encrypt_ports.nonce,
        aad=chacha20poly1305_encrypt_ports.aad,
        aad_len=chacha20poly1305_encrypt_ports.aad_len,
        # reverse half of the output port, constructed inline
        axis_out_if=axis128_intrf.fb_t(ready=chacha20poly1305_encrypt_ports.axis_out_if.ready),
    )
    chacha20poly1305_encrypt_ports.axis_in_if.ready = r.axis_in_if.ready
    chacha20poly1305_encrypt_ports.axis_out_if.stream = r.axis_out_if.stream
