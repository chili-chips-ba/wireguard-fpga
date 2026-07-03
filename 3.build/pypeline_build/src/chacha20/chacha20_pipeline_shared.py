# pyright: reportInvalidTypeForm=none
"""Shared ChaCha20 compute pipeline for the encrypt+decrypt shared design.

Replaces the encrypt vs decrypt specific pipeline instances with one shared
pipeline just named chacha20_pipeline. The pipeline takes the same input and
output as before but wrapped with an ID for is-encrypt vs decrypt, plus
round-robin muxing logic at the pipeline input and ID-based demuxing at the
output.

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
    uint1_t,
)
from stream.stream import make_stream_t
from stream.stream_pipeline import make_stream_pipeline

import chacha20
from chacha20 import (
    chacha20_loop_body_in_t,
    chacha20_loop_body_stream_t,
    chacha20_loop_body_in_null,
    chacha20_loop_body_stream_null,
)

from aead_types import (
    axis512_frag_t,
    axis512_t,
    axis512_frag_null,
    axis512_null,
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


chacha_shared_pipeline_in_stream_t = make_stream_t(chacha_shared_pipeline_in_t)
chacha_shared_pipeline_out_stream_t = make_stream_t(chacha_shared_pipeline_out_t)


def chacha_shared_pipeline_in_stream_null():
    return chacha_shared_pipeline_in_stream_t(
        data=chacha_shared_pipeline_in_t(
            data=chacha20_loop_body_in_null(), is_encrypt=0
        ),
        valid=0,
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


# The one shared pipeline instance
# (C GLOBAL_VALID_READY_PIPELINE_INST(chacha20_pipeline,
#  chacha_shared_pipeline_out_t, chacha_shared_pipeline,
#  chacha_shared_pipeline_in_t, 64))
pipeline_in: Wire[chacha_shared_pipeline_in_stream_t]
pipeline_in_ready: Wire[uint1_t]
pipeline_out: Wire[chacha_shared_pipeline_out_stream_t]
pipeline_out_ready: Wire[uint1_t]

pipeline_func, pipeline_result_t = make_stream_pipeline(chacha_shared_pipeline, 64)


@MAIN
def chacha20_pipeline():
    result = pipeline_func(pipeline_in, pipeline_out_ready)
    pipeline_out = result.stream_out
    pipeline_in_ready = result.ready_for_stream_in


# Expose global interface that looks like individual pipelines with names
# including encrypt vs decrypt
encrypt_pipeline_in: Wire[chacha20_loop_body_stream_t]
encrypt_pipeline_in_ready: Wire[uint1_t]
decrypt_pipeline_in: Wire[chacha20_loop_body_stream_t]
decrypt_pipeline_in_ready: Wire[uint1_t]
encrypt_pipeline_out: Wire[axis512_t]
encrypt_pipeline_out_ready: Wire[uint1_t]
decrypt_pipeline_out: Wire[axis512_t]
decrypt_pipeline_out_ready: Wire[uint1_t]


# Muxing logic at input and output of pipeline
@MAIN
def chacha20_sharing_mux():
    # Default no data flowing (locals, driven onto wires once at the end)
    pipeline_in_s: chacha_shared_pipeline_in_stream_t = (
        chacha_shared_pipeline_in_stream_null()
    )  # into pipeline
    pipeline_out_ready_s: uint1_t = 0  # from pipeline
    encrypt_pipeline_out_s: axis512_t = axis512_null()  # to encrypt
    encrypt_pipeline_in_ready_s: uint1_t = 0  # from encrypt
    decrypt_pipeline_out_s: axis512_t = axis512_null()  # to decrypt
    decrypt_pipeline_in_ready_s: uint1_t = 0  # from decrypt

    # Input side state toggles round robin
    is_encrypt: Reg[uint1_t]
    pipeline_in_s.data.is_encrypt = is_encrypt
    if is_encrypt:
        pipeline_in_s.data.data = encrypt_pipeline_in.data
        pipeline_in_s.valid = encrypt_pipeline_in.valid
        encrypt_pipeline_in_ready_s = pipeline_in_ready
    else:
        pipeline_in_s.data.data = decrypt_pipeline_in.data
        pipeline_in_s.valid = decrypt_pipeline_in.valid
        decrypt_pipeline_in_ready_s = pipeline_in_ready
    is_encrypt = ~is_encrypt

    # Output side muxing based on id flag out of pipeline
    if pipeline_out.valid:
        if pipeline_out.data.is_encrypt:
            encrypt_pipeline_out_s.data = pipeline_out.data.data
            encrypt_pipeline_out_s.valid = pipeline_out.valid
            pipeline_out_ready_s = encrypt_pipeline_out_ready
        else:
            decrypt_pipeline_out_s.data = pipeline_out.data.data
            decrypt_pipeline_out_s.valid = pipeline_out.valid
            pipeline_out_ready_s = decrypt_pipeline_out_ready

    # Drive output wires
    pipeline_in = pipeline_in_s
    pipeline_out_ready = pipeline_out_ready_s
    encrypt_pipeline_out = encrypt_pipeline_out_s
    encrypt_pipeline_in_ready = encrypt_pipeline_in_ready_s
    decrypt_pipeline_out = decrypt_pipeline_out_s
    decrypt_pipeline_in_ready = decrypt_pipeline_in_ready_s
