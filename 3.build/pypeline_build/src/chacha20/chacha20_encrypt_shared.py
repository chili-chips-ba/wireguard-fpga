# pyright: reportInvalidTypeForm=none
"""chacha20 instance for the encrypt half of the shared design: same globally
visible wires + FSM MAIN as chacha20_encrypt.py, but with no pipeline of its
own — the FSM talks to the shared pipeline's encrypt-side wires in
chacha20_pipeline_shared.py instead.

Pypeline port of ../pipelinec_build/src/chacha20/chacha20.c with
CHACHA_INST=chacha20_encrypt + CHACHA_EXCLUDES_PIPELINE
(wire names elaborate as chacha20_encrypt_shared_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, Wire, uint1_t, uint8_t

import chacha20
import chacha20_pipeline_shared

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    axis128_t,
    poly1305_key_stream_t,
)

# Globally visible ports
# CSR inputs
key: Wire[uint8_t[CHACHA20_KEY_SIZE]]  # input
nonce: Wire[uint8_t[CHACHA20_NONCE_SIZE]]  # input
# Input plaintext
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Output poly1305_key
poly_key: Wire[poly1305_key_stream_t]  # output
poly_key_ready: Wire[uint1_t]  # input
# Output ciphertext
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input


# Instance of FSM to control (the shared) pipeline
@MAIN
def chacha20_encrypt_shared():
    fsm_out = chacha20.chacha20_fsm(
        key,
        nonce,
        axis_in,
        poly_key_ready,
        axis_out_ready,
        chacha20_pipeline_shared.encrypt_pipeline_in_ready,
        chacha20_pipeline_shared.encrypt_pipeline_out,
    )
    axis_in_ready = fsm_out.ready_for_axis_in
    poly_key = fsm_out.poly_key
    axis_out = fsm_out.axis
    chacha20_pipeline_shared.encrypt_pipeline_in = fsm_out.to_pipeline
    chacha20_pipeline_shared.encrypt_pipeline_out_ready = fsm_out.ready_for_from_pipeline
