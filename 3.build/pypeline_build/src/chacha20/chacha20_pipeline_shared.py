# pyright: reportInvalidTypeForm=none
"""Shared ChaCha20 compute pipeline for the encrypt+decrypt shared design.

Combines what used to be three separate MAINs (a pipeline instance, a
round-robin mux/demux arbiter FSM, and two per-direction FSM wrapper MAINs)
into: one merged MAIN owning the arbitrated pipeline (a genuinely shared
resource crossing the otherwise-independent encrypt and decrypt dataflow
graphs, so it stays a separate always-running process rather than being
inlined into either), plus two plain per-direction functions matching
chacha20's ordinary chacha20_stream_out_t interface so they can be passed to
make_encrypt_dataflow_core/make_decrypt_dataflow_core exactly like
chacha20.chacha20_instance is for the standalone (non-shared) builds.

Pypeline port of ../pipelinec_build/src/chacha20/chacha20_pipeline_shared.c
(wire names elaborate as chacha20_pipeline_shared_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    NamedTuple,
    struct,
    hw_func,
    Wire,
    Reg,
    Feedback,
    uint1_t,
    uint8_t,
)
from stream.stream import make_stream_interface
from stream.stream_pipeline import make_stream_pipeline

import chacha20
from chacha20 import (
    chacha20_loop_body_in_t,
    chacha20_loop_body_stream_intrf,
    chacha20_loop_body_in_null,
)

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    axis128_intrf,
    axis512_frag_t,
    axis512_intrf,
    axis512_null,
    poly1305_key_stream_intrf,
)


# Pipeline takes same input and output as before but wrapped with ID for
# is encrypt vs decrypt
@struct
class chacha_shared_pipeline_in_t(NamedTuple):
    data: chacha20_loop_body_in_t
    is_encrypt: uint1_t


@struct
class chacha_shared_pipeline_out_t(NamedTuple):
    data: axis512_frag_t
    is_encrypt: uint1_t


chacha_shared_pipeline_in_stream_intrf = make_stream_interface(chacha_shared_pipeline_in_t)
chacha_shared_pipeline_out_stream_intrf = make_stream_interface(chacha_shared_pipeline_out_t)


def chacha_shared_pipeline_in_stream_null():
    return chacha_shared_pipeline_in_stream_intrf.fwd_t(
        stream=chacha_shared_pipeline_in_stream_intrf.stream_t(
            data=chacha_shared_pipeline_in_t(
                data=chacha20_loop_body_in_null(), is_encrypt=0
            ),
            valid=0,
        ),
    )


# Pipeline function is same as old function by passing through ID from
# input to output
@hw_func
def chacha_shared_pipeline(
    inputs: chacha_shared_pipeline_in_t,
) -> chacha_shared_pipeline_out_t:
    outputs: chacha_shared_pipeline_out_t
    outputs.data = chacha20.chacha20_loop_body(inputs.data)
    outputs.is_encrypt = inputs.is_encrypt
    return outputs


pipeline_func, _pipeline_result_t = make_stream_pipeline(chacha_shared_pipeline)


# Externally-exposed interface: looks like individual per-direction pipelines.
# This is the one deliberately-surviving Wire boundary in the whole refactor
# -- a genuinely arbitrated resource shared across the otherwise-independent
# encrypt and decrypt dataflow graphs, not leftover wiring style.
encrypt_pipeline_in: Wire[chacha20_loop_body_stream_intrf.fwd_t]
encrypt_pipeline_in_ready: Wire[uint1_t]
decrypt_pipeline_in: Wire[chacha20_loop_body_stream_intrf.fwd_t]
decrypt_pipeline_in_ready: Wire[uint1_t]
encrypt_pipeline_out: Wire[axis512_intrf.fwd_t]
encrypt_pipeline_out_ready: Wire[uint1_t]
decrypt_pipeline_out: Wire[axis512_intrf.fwd_t]
decrypt_pipeline_out_ready: Wire[uint1_t]


# The pipeline instance plus its round-robin input mux / ID-based output
# demux, combined into one MAIN (used to be two: chacha20_pipeline +
# chacha20_sharing_mux, joined by pipeline_in/pipeline_in_ready/pipeline_out/
# pipeline_out_ready global wires).
@MAIN
def chacha20_pipeline_shared():
    pipeline_in_ready: Feedback[uint1_t]
    pipeline_out: Feedback[chacha_shared_pipeline_out_stream_intrf.fwd_t]

    # Default no data flowing (locals, driven onto wires once at the end)
    pipeline_in_s: chacha_shared_pipeline_in_stream_intrf.stream_t = (
        chacha_shared_pipeline_in_stream_null().stream
    )  # into pipeline
    pipeline_out_ready_s: uint1_t = 0  # from pipeline
    encrypt_pipeline_out_s: axis512_intrf.stream_t = axis512_null().stream  # to encrypt
    encrypt_pipeline_in_ready_s: uint1_t = 0  # from encrypt
    decrypt_pipeline_out_s: axis512_intrf.stream_t = axis512_null().stream  # to decrypt
    decrypt_pipeline_in_ready_s: uint1_t = 0  # from decrypt

    # Input side state toggles round robin
    is_encrypt: Reg[uint1_t]
    pipeline_in_s.data.is_encrypt = is_encrypt
    if is_encrypt:
        pipeline_in_s.data.data = encrypt_pipeline_in.stream.data
        pipeline_in_s.valid = encrypt_pipeline_in.stream.valid
        encrypt_pipeline_in_ready_s = pipeline_in_ready
    else:
        pipeline_in_s.data.data = decrypt_pipeline_in.stream.data
        pipeline_in_s.valid = decrypt_pipeline_in.stream.valid
        decrypt_pipeline_in_ready_s = pipeline_in_ready
    is_encrypt = ~is_encrypt

    # Output side muxing based on id flag out of pipeline
    if pipeline_out.stream.valid:
        if pipeline_out.stream.data.is_encrypt:
            encrypt_pipeline_out_s.data = pipeline_out.stream.data.data
            encrypt_pipeline_out_s.valid = pipeline_out.stream.valid
            pipeline_out_ready_s = encrypt_pipeline_out_ready
        else:
            decrypt_pipeline_out_s.data = pipeline_out.stream.data.data
            decrypt_pipeline_out_s.valid = pipeline_out.stream.valid
            pipeline_out_ready_s = decrypt_pipeline_out_ready

    # Drive output wires
    encrypt_pipeline_out = axis512_intrf.fwd_t(stream=encrypt_pipeline_out_s)
    encrypt_pipeline_in_ready = encrypt_pipeline_in_ready_s
    decrypt_pipeline_out = axis512_intrf.fwd_t(stream=decrypt_pipeline_out_s)
    decrypt_pipeline_in_ready = decrypt_pipeline_in_ready_s

    result = pipeline_func(
        stream_in_if=chacha_shared_pipeline_in_stream_intrf.fwd_t(stream=pipeline_in_s),
        stream_out_if=chacha_shared_pipeline_out_stream_intrf.fb_t(ready=pipeline_out_ready_s),
    )
    pipeline_out = result.stream_out_if
    pipeline_in_ready = result.stream_in_if.ready


# Per-direction FSM wrappers: same chacha20.chacha20_fsm as
# chacha20.chacha20_instance uses, but talking to the shared pipeline's
# exposed wires above instead of owning a private pipeline. Same external
# signature/struct (chacha20.chacha20_stream_out_t) as chacha20_instance, so
# either can be passed to make_encrypt_dataflow_core/make_decrypt_dataflow_core.
@hw_func
def chacha20_encrypt_shared(
    key: uint8_t[CHACHA20_KEY_SIZE],
    nonce: uint8_t[CHACHA20_NONCE_SIZE],
    axis_in_if: axis128_intrf.fwd_t,
    key_if: poly1305_key_stream_intrf.fb_t,
    axis_out_if: axis128_intrf.fb_t,
) -> chacha20.chacha20_stream_out_t:
    o: chacha20.chacha20_stream_out_t
    from_pipe_fwd: axis512_intrf.stream_t = encrypt_pipeline_out.stream
    fsm_out = chacha20.chacha20_fsm(
        key=key,
        nonce=nonce,
        axis_in_if=axis_in_if,
        key_if=key_if,
        axis_out_if=axis_out_if,
        to_pipeline_if=chacha20.chacha20_loop_body_stream_intrf.fb_t(
            ready=encrypt_pipeline_in_ready
        ),
        from_pipeline_if=axis512_intrf.fwd_t(stream=from_pipe_fwd),
    )
    o.axis_in_if = fsm_out.axis_in_if
    o.key_if = fsm_out.key_if
    o.axis_out_if = fsm_out.axis_out_if
    encrypt_pipeline_in = fsm_out.to_pipeline_if
    encrypt_pipeline_out_ready = fsm_out.from_pipeline_if.ready
    return o


@hw_func
def chacha20_decrypt_shared(
    key: uint8_t[CHACHA20_KEY_SIZE],
    nonce: uint8_t[CHACHA20_NONCE_SIZE],
    axis_in_if: axis128_intrf.fwd_t,
    key_if: poly1305_key_stream_intrf.fb_t,
    axis_out_if: axis128_intrf.fb_t,
) -> chacha20.chacha20_stream_out_t:
    o: chacha20.chacha20_stream_out_t
    from_pipe_fwd: axis512_intrf.stream_t = decrypt_pipeline_out.stream
    fsm_out = chacha20.chacha20_fsm(
        key=key,
        nonce=nonce,
        axis_in_if=axis_in_if,
        key_if=key_if,
        axis_out_if=axis_out_if,
        to_pipeline_if=chacha20.chacha20_loop_body_stream_intrf.fb_t(
            ready=decrypt_pipeline_in_ready
        ),
        from_pipeline_if=axis512_intrf.fwd_t(stream=from_pipe_fwd),
    )
    o.axis_in_if = fsm_out.axis_in_if
    o.key_if = fsm_out.key_if
    o.axis_out_if = fsm_out.axis_out_if
    decrypt_pipeline_in = fsm_out.to_pipeline_if
    decrypt_pipeline_out_ready = fsm_out.from_pipeline_if.ready
    return o
