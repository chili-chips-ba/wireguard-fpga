# pyright: reportInvalidTypeForm=none
"""ChaCha20 core (RFC 8439): state struct, block function pipeline, and the
input/output FSMs that drive the per-block pipeline, plus chacha20_instance
(FSM + private pipeline combined) which each dataflow core instantiates
directly, once per direction.

Pypeline port of ../pipelinec_build/src/chacha20/chacha20.h and chacha20.c.
"""
import pypeline_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    enum,
    hw_func,
    Reg,
    Feedback,
    uint1_t,
    uint8_t,
    uint32_t,
    rotl,
    array_to_uint_le,
    make_type_to_bytes,
    make_type_from_bytes,
)
from interface.interface import (
    interface,
    make_interface_feedback_type,
    make_interface_type,
)
from interface.interface_func import make_hw_func_from_interface_func
from stream.stream import make_stream_interface
from stream.stream_pipeline import make_stream_pipeline
from axi.axis import make_dwidth_widen, make_dwidth_narrow

from aead_types import (
    CHACHA20_STATE_NWORDS,
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    CHACHA20_BLOCK_SIZE,
    POLY1305_KEY_SIZE,
    axis128_intrf,
    axis128_t,
    axis128_fb_t,
    axis512_frag_t,
    axis512_intrf,
    axis512_t,
    axis512_fb_t,
    poly1305_key_stream_intrf,
    poly1305_key_stream_t,
    poly1305_key_stream_fb_t,
    axis128_null,
    axis512_null,
    axis512_frag_null,
    poly1305_key_stream_null,
)


# ChaCha20 state structure
@struct
class chacha20_state(NamedTuple):
    state: uint32_t[CHACHA20_STATE_NWORDS]


# Generic byte <-> word-array conversions (little-endian), replacing what used
# to be hand-written concat()/bit-slicing loops per use site.
chacha20_state_to_bytes = make_type_to_bytes(chacha20_state)  # keystream serialization
_key_words_from_bytes = make_type_from_bytes(uint32_t[CHACHA20_KEY_SIZE // 4])
_nonce_words_from_bytes = make_type_from_bytes(uint32_t[CHACHA20_NONCE_SIZE // 4])


# The ChaCha20 quarter round function.
# a/b/c/d are compile-time indices (the C TODO suggested exactly this:
# "abcd are constants and might get better results if this function made into macro")
def make_quarter_round(a, b, c, d):
    @hw_func
    def quarter_round(s: chacha20_state) -> chacha20_state:
        o: chacha20_state = s

        # decompose ops
        a1: uint32_t = o.state[a] + o.state[b]
        d1: uint32_t = rotl(o.state[d] ^ a1, 16)
        c1: uint32_t = o.state[c] + d1
        b1: uint32_t = rotl(o.state[b] ^ c1, 12)
        a2: uint32_t = a1 + b1
        d2: uint32_t = rotl(d1 ^ a2, 8)
        c2: uint32_t = c1 + d2
        b2: uint32_t = rotl(b1 ^ c2, 7)

        # join output
        o.state[a] = a2
        o.state[b] = b2
        o.state[c] = c2
        o.state[d] = d2

        return o

    return quarter_round


quarter_round_0_4_8_12 = make_quarter_round(0, 4, 8, 12)
quarter_round_1_5_9_13 = make_quarter_round(1, 5, 9, 13)
quarter_round_2_6_10_14 = make_quarter_round(2, 6, 10, 14)
quarter_round_3_7_11_15 = make_quarter_round(3, 7, 11, 15)
quarter_round_0_5_10_15 = make_quarter_round(0, 5, 10, 15)
quarter_round_1_6_11_12 = make_quarter_round(1, 6, 11, 12)
quarter_round_2_7_8_13 = make_quarter_round(2, 7, 8, 13)
quarter_round_3_4_9_14 = make_quarter_round(3, 4, 9, 14)


@hw_func
def chacha20_block_step(state0: chacha20_state) -> chacha20_state:
    # make a giant pipeline with 8 parallel ops
    state1 = quarter_round_0_4_8_12(state0)
    state2 = quarter_round_1_5_9_13(state1)
    state3 = quarter_round_2_6_10_14(state2)
    state4 = quarter_round_3_7_11_15(state3)
    state5 = quarter_round_0_5_10_15(state4)
    state6 = quarter_round_1_6_11_12(state5)
    state7 = quarter_round_2_7_8_13(state6)
    state8 = quarter_round_3_4_9_14(state7)
    return state8


# ChaCha20 block function pipeline
@hw_func
def chacha20_block(state: chacha20_state) -> chacha20_state:
    output: chacha20_state

    # 1. do 20 rounds (2 rounds per step) (giant pipeline)
    step1 = chacha20_block_step(state)
    step2 = chacha20_block_step(step1)
    step3 = chacha20_block_step(step2)
    step4 = chacha20_block_step(step3)
    step5 = chacha20_block_step(step4)
    step6 = chacha20_block_step(step5)
    step7 = chacha20_block_step(step6)
    step8 = chacha20_block_step(step7)
    step9 = chacha20_block_step(step8)
    step10 = chacha20_block_step(step9)

    # 2. final parallel add
    for i in range(CHACHA20_STATE_NWORDS):
        output.state[i] = step10.state[i] + state.state[i]

    return output


# ChaCha20 initialization function
@hw_func
def chacha20_init(
    key: uint8_t[CHACHA20_KEY_SIZE],
    nonce: uint8_t[CHACHA20_NONCE_SIZE],
    counter: uint32_t,
) -> chacha20_state:
    state: chacha20_state
    # Set the initial state (constants + key + nonce)
    # "expand 32-byte k"
    state.state[0] = 0x61707865
    state.state[1] = 0x3320646E
    state.state[2] = 0x79622D32
    state.state[3] = 0x6B206574

    # Key (bytes packed little-endian into words)
    key_words = _key_words_from_bytes(key)
    for i in range(CHACHA20_KEY_SIZE // 4):
        state.state[4 + i] = key_words[i]

    # Counter
    state.state[12] = counter

    # Nonce
    nonce_words = _nonce_words_from_bytes(nonce)
    for i in range(CHACHA20_NONCE_SIZE // 4):
        state.state[13 + i] = nonce_words[i]

    return state


# Pass by value version of body part of per-block loop:
#   want in form: output_t func_name(input_t)
@struct
class chacha20_loop_body_in_t(NamedTuple):
    axis_in: axis512_frag_t  # one 64 byte block
    # TODO key and nonce dont change every block right? only per packet?
    key: uint8_t[CHACHA20_KEY_SIZE]
    nonce: uint8_t[CHACHA20_NONCE_SIZE]
    counter: uint32_t


chacha20_loop_body_stream_intrf = make_stream_interface(chacha20_loop_body_in_t)
chacha20_loop_body_stream_t = make_interface_type(chacha20_loop_body_stream_intrf)
chacha20_loop_body_stream_fb_t = make_interface_feedback_type(chacha20_loop_body_stream_intrf)


def chacha20_loop_body_in_null():
    return chacha20_loop_body_in_t(
        axis_in=axis512_frag_null(),
        key=[0] * CHACHA20_KEY_SIZE,
        nonce=[0] * CHACHA20_NONCE_SIZE,
        counter=0,
    )


def chacha20_loop_body_stream_null():
    return chacha20_loop_body_stream_t(
        data=chacha20_loop_body_in_null(),
        valid=0,
    )


@hw_func
def chacha20_loop_body(inputs: chacha20_loop_body_in_t) -> axis512_frag_t:
    state = chacha20_init(inputs.key, inputs.nonce, inputs.counter)
    block = chacha20_block(state)

    # Output passes through tkeep/tlast; kept data bytes are input XOR
    # keystream, non-kept (padding) lanes are forced to zero so partial final
    # blocks never leak raw keystream bytes downstream.
    # Keystream block state words serialize to bytes little-endian per word.
    keystream: uint8_t[CHACHA20_BLOCK_SIZE] = chacha20_state_to_bytes(block)
    axis_out: axis512_frag_t = inputs.axis_in
    for i in range(CHACHA20_BLOCK_SIZE):
        axis_out.frag.data[i] = 0
        if inputs.axis_in.frag.keep[i]:
            axis_out.frag.data[i] = inputs.axis_in.frag.data[i] ^ keystream[i]
    return axis_out


# FSM for the two parts of chacha20 encrypt/decrypt
# Is actually two independent FSMs:
# one handling inputs to the pipeline
# and another handling output from the pipeline

# Two uses of the chacha20_pipeline
@enum
class chacha20_state_t:
    POLY_KEY = auto()
    PLAINTEXT = auto()


# Data width converters to-from 512b wide blocks and the 128b bus
axis128_to_axis512, _, _ = make_dwidth_widen(uint8_t, 16, 4)
axis512_to_axis128, _, _ = make_dwidth_narrow(uint8_t, 16, 4)


@struct
class chacha20_fsm_t(NamedTuple):
    # One field per port: input ports return their reverse half, output ports
    # return their feedforward half (the other half is an arg of the same
    # name, suffixed `_if` to mark it as one bidirectional port, not two
    # same-named directional signals).
    axis_in_if: axis128_fb_t
    key_if: poly1305_key_stream_t
    axis_out_if: axis128_t
    to_pipeline_if: chacha20_loop_body_stream_t
    from_pipeline_if: axis512_fb_t


@hw_func
def chacha20_fsm(
    # Inputs
    key: uint8_t[CHACHA20_KEY_SIZE],
    nonce: uint8_t[CHACHA20_NONCE_SIZE],
    axis_in_if: axis128_t,
    key_if: poly1305_key_stream_fb_t,
    axis_out_if: axis128_fb_t,
    to_pipeline_if: chacha20_loop_body_stream_fb_t,
    from_pipeline_if: axis512_t,
) -> chacha20_fsm_t:
    o: chacha20_fsm_t

    # INPUT SIDE FSM
    # Puts poly1305_key_gen blocks=0,count=0 followed by plaintext into pipeline

    # Pipeline input muxing FSM
    input_side_state: Reg[chacha20_state_t]
    block_count: Reg[uint32_t]
    # Default no input into width conversion
    dwidth_conv_data_in: axis128_t = axis128_null()
    o.axis_in_if.ready = 0
    # Default no input into pipeline
    o.to_pipeline_if = chacha20_loop_body_stream_null()
    #  other than CSR inputs and such
    o.to_pipeline_if.data.key = key
    o.to_pipeline_if.data.nonce = nonce
    o.to_pipeline_if.data.counter = block_count
    # Default not outputting poly key
    o.key_if = poly1305_key_stream_null()

    # Convert input axis to 512b
    # Input axis into dwidth conv default gated until in plaintext state
    if input_side_state == chacha20_state_t.PLAINTEXT:
        dwidth_conv_data_in = axis_in_if
    block_in_ready: Feedback[axis512_fb_t]
    in_to_block = axis128_to_axis512(dwidth_conv_data_in, block_in_ready)
    block_in_stream: axis512_t = in_to_block.wide_out
    # Default not ready for incoming blocks
    block_in_ready = axis512_fb_t(ready=0)
    # Input axis into dwidth conv default gated until in plaintext state
    if input_side_state == chacha20_state_t.PLAINTEXT:
        o.axis_in_if = in_to_block.narrow_in

    if input_side_state == chacha20_state_t.POLY_KEY:
        # Wait for incoming plaintext
        if axis_in_if.valid | block_in_stream.valid:
            # Do poly1305_key_gen, use counter 0 and generate a block
            # Start by putting zero data and block_count=0 into chacha pipeline
            for i in range(CHACHA20_BLOCK_SIZE):
                o.to_pipeline_if.data.axis_in.frag.data[i] = 0
                o.to_pipeline_if.data.axis_in.frag.keep[i] = 1
            o.to_pipeline_if.valid = 1
            # Wait until data accepted into pipeline
            if to_pipeline_if.ready:
                block_count = block_count + 1
                # then allow a packet of plaintext to flow into the pipeline
                input_side_state = chacha20_state_t.PLAINTEXT
    else:  # if input_side_state == chacha20_state_t.PLAINTEXT:
        o.to_pipeline_if.data.axis_in = block_in_stream.data
        o.to_pipeline_if.valid = block_in_stream.valid
        block_in_ready = axis512_fb_t(ready=to_pipeline_if.ready)  # FEEDBACK
        if o.to_pipeline_if.valid & to_pipeline_if.ready:
            block_count = block_count + 1
            # if this was last block into pipeline then reset counter and poly key next
            if o.to_pipeline_if.data.axis_in.eod[0]:
                block_count = 0
                input_side_state = chacha20_state_t.POLY_KEY

    # Output side FSM
    # Get poly1305_key_gen data or ciphertext out of pipeline

    # Pipeline output demuxing FSM
    output_side_state: Reg[chacha20_state_t]
    # Default not ready for pipeline output
    o.from_pipeline_if.ready = 0
    # Default no block going out
    block_to_out_axis_in: axis512_t = axis512_null()
    block_to_out_axis_in_ready: Feedback[axis512_fb_t]
    if output_side_state == chacha20_state_t.POLY_KEY:
        # Wait for the poly key cycle of data to come out of the pipeline
        # it goes out the poly1305_key output stream
        # First 32 bytes of the block become the Poly1305 key
        poly_key_bytes: uint8_t[POLY1305_KEY_SIZE]
        for i in range(POLY1305_KEY_SIZE):
            poly_key_bytes[i] = from_pipeline_if.data.frag.data[i]
        o.key_if.data = array_to_uint_le(poly_key_bytes)
        o.key_if.valid = from_pipeline_if.valid
        o.from_pipeline_if.ready = key_if.ready
        # When output of key happens move on to plaintext
        if o.key_if.valid & key_if.ready:
            output_side_state = chacha20_state_t.PLAINTEXT
    else:  # if output_side_state == chacha20_state_t.PLAINTEXT
        # Wait for the last cycle of ciphertext data to come out of the pipeline
        block_to_out_axis_in = from_pipeline_if
        o.from_pipeline_if.ready = block_to_out_axis_in_ready.ready
        if from_pipeline_if.valid & o.from_pipeline_if.ready:
            # If this was last block then reset state
            if from_pipeline_if.data.eod[0]:
                output_side_state = chacha20_state_t.POLY_KEY

    # Convert pipeline output 512b block stream to 128b
    block_to_out = axis512_to_axis128(block_to_out_axis_in, axis_out_if)
    o.axis_out_if = block_to_out.narrow_out
    block_to_out_axis_in_ready = block_to_out.wide_in  # FEEDBACK

    return o


# One full chacha20 instance: chacha20_fsm plus its own private
# chacha20_loop_body pipeline, combined into a single callable (replaces what
# used to be two MAINs -- an FSM and a pipeline instance -- joined by global
# wires). Meant to be called once per direction (encrypt, decrypt) from that
# direction's dataflow core; each call site gets its own independent pipeline
# + FSM hardware state, same as any other function call in pypeline.
pipeline_func, _pipeline_result_t = make_stream_pipeline(chacha20_loop_body)


@interface
class chacha20_ports(NamedTuple):
    """The two output ports of a chacha20 instance."""

    key_if: poly1305_key_stream_intrf
    axis_out_if: axis128_intrf


# An interface function: only the feedforward direction is written. The FSM and
# its private pipeline form a loop (the FSM consumes `from_pipeline_if`, which
# the pipeline -- called after it -- produces), so the generated wiring places
# a Feedback on the feedforward edge as well as on the reverse edge. That is
# exactly the pipeline_out / pipeline_in_ready pair this used to thread by hand.
def chacha20_instance_wiring(
    key: uint8_t[CHACHA20_KEY_SIZE],
    nonce: uint8_t[CHACHA20_NONCE_SIZE],
    axis_in_if: axis128_intrf,
) -> chacha20_ports:
    fsm_out = chacha20_fsm(key, nonce, axis_in_if, pipe.stream_out)
    pipe = pipeline_func(fsm_out.to_pipeline_if)
    return chacha20_ports(key_if=fsm_out.key_if, axis_out_if=fsm_out.axis_out_if)


# chacha20_stream_out_t stays the one contract shared with the
# chacha20_{encrypt,decrypt}_shared variants, so a dataflow core can call
# either. Fields: .axis_in_if (reverse half of the input port), .key_if,
# .axis_out_if (feedforward halves of the output ports).
chacha20_instance, chacha20_stream_out_t = make_hw_func_from_interface_func(
    chacha20_instance_wiring
)
