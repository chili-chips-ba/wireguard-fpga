# pyright: reportInvalidTypeForm=none
"""chacha20 instance for the standalone decrypt design: globally visible
wires + the chacha20_loop_body stream pipeline + the FSM MAIN.

Pypeline port of ../pipelinec_build/src/chacha20/chacha20.c with
CHACHA_INST=chacha20_decrypt (wire names elaborate as chacha20_decrypt_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, Wire, uint1_t, uint8_t
from stream.stream_pipeline import make_stream_pipeline

import chacha20
from chacha20 import chacha20_loop_body_stream_t

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    axis128_t,
    axis512_t,
    poly1305_key_stream_t,
)

# Globally visible ports
# CSR inputs
key: Wire[uint8_t[CHACHA20_KEY_SIZE]]  # input
nonce: Wire[uint8_t[CHACHA20_NONCE_SIZE]]  # input
# Input ciphertext
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Output poly1305_key
poly_key: Wire[poly1305_key_stream_t]  # output
poly_key_ready: Wire[uint1_t]  # input
# Output plaintext
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input

# Global instance of the chacha20_loop_body pipeline
# (C GLOBAL_VALID_READY_PIPELINE_INST(chacha20_decrypt_pipeline, axis512_t,
#  chacha20_loop_body, chacha20_loop_body_in_t, 64))
pipeline_in: Wire[chacha20_loop_body_stream_t]
pipeline_in_ready: Wire[uint1_t]
pipeline_out: Wire[axis512_t]
pipeline_out_ready: Wire[uint1_t]

pipeline_func, pipeline_result_t = make_stream_pipeline(
    chacha20.chacha20_loop_body, 64
)


@MAIN
def chacha20_decrypt_pipeline():
    result = pipeline_func(pipeline_in, pipeline_out_ready)
    pipeline_out = result.stream_out
    pipeline_in_ready = result.ready_for_stream_in


# Instance of FSM to control pipeline
@MAIN
def chacha20_decrypt():
    fsm_out = chacha20.chacha20_fsm(
        key,
        nonce,
        axis_in,
        poly_key_ready,
        axis_out_ready,
        pipeline_in_ready,
        pipeline_out,
    )
    axis_in_ready = fsm_out.ready_for_axis_in
    poly_key = fsm_out.poly_key
    axis_out = fsm_out.axis
    pipeline_in = fsm_out.to_pipeline
    pipeline_out_ready = fsm_out.ready_for_from_pipeline
