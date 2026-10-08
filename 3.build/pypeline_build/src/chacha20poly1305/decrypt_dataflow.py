# pyright: reportInvalidTypeForm=none
"""The primary dataflow for single clock domain ChaCha20-Poly1305 decryption,
used by the decrypt design and by the combined design (-D DESIGN=shared).

In the combined design, ChaCha20 can use its shared pipeline and Poly1305 its
shared prologue/epilogue services (-D SHARE). The MAC body pipeline and packet
state always remain private.

Pypeline port of ../pipelinec_build/src/chacha20poly1305/decrypt_dataflow.c
(also as included by decrypt_shared.c).
"""
import wireguard_env

from pypeline import MAIN

import chacha20poly1305_decrypt_ports
from poly1305_select import make_poly1305_mac

if wireguard_env.SHARING["chacha20"]:
    import chacha20_pipeline_shared
    chacha_func = chacha20_pipeline_shared.chacha20_decrypt_shared
else:
    import chacha20
    chacha_func = chacha20.chacha20_instance
if wireguard_env.SHARING["poly1305"]:
    import poly1305_mcp_shared  # noqa: F401

from aead_types import axis128_intrf
from decrypt_dataflow_core import make_decrypt_dataflow_core

decrypt_dataflow_core, decrypt_dataflow_core_t = make_decrypt_dataflow_core(
    chacha_func, make_poly1305_mac("decrypt", share_mcp=wireguard_env.SHARING["poly1305"])
)


@MAIN(wireguard_env.TARGET_MHZ)
def decrypt_dataflow():
    # Crossing out of the implied-feedback world: the dataflow core is an
    # ordinary hw_func here, so the reverse halves go in as arguments and come
    # back out as named return fields, and are unpacked onto the design's
    # flat DUT-facing port wires.
    r = decrypt_dataflow_core(
        # forward half of the input port, constructed inline
        axis_in_if=axis128_intrf.fwd_t(chacha20poly1305_decrypt_ports.axis_in_if.stream),
        key=chacha20poly1305_decrypt_ports.key,
        nonce=chacha20poly1305_decrypt_ports.nonce,
        aad=chacha20poly1305_decrypt_ports.aad,
        aad_len=chacha20poly1305_decrypt_ports.aad_len,
        # reverse half of the output port, constructed inline
        axis_out_if=axis128_intrf.fb_t(chacha20poly1305_decrypt_ports.axis_out_if.ready),
    )
    chacha20poly1305_decrypt_ports.axis_in_if.ready = r.axis_in_if.ready
    chacha20poly1305_decrypt_ports.axis_out_if.stream = r.axis_out_if.stream
    chacha20poly1305_decrypt_ports.is_verified_out = r.is_verified_out
