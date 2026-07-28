# pyright: reportInvalidTypeForm=none
"""Nice struct/array type globally visible wires used as the decrypt design's
DUT-facing ports. In simulation these wires are driven by the testbench; in
hardware they are driven by the flattened top level ports
(chacha20poly1305_decrypt_hw_io.py).

Pypeline port of the wire declarations in
../pipelinec_build/src/chacha20poly1305/chacha20poly1305_decrypt.h
(wire names elaborate as chacha20poly1305_decrypt_ports_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import Wire, uint1_t, uint8_t

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
)

axis_in_if: Wire[axis128_intrf]  # .stream is input, .ready is output
key: Wire[uint8_t[CHACHA20_KEY_SIZE]]  # input
nonce: Wire[uint8_t[CHACHA20_NONCE_SIZE]]  # input
aad: Wire[uint8_t[AAD_MAX_LEN]]  # input
aad_len: Wire[uint8_t]  # input
axis_out_if: Wire[axis128_intrf]  # .stream is output, .ready is input

# Parallel output (verification result)
is_verified_out: Wire[uint1_t]  # output
