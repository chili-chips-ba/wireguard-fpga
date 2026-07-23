# pyright: reportInvalidTypeForm=none
"""Check if auth_tag and calculated_tag are the same.

Pypeline port of ../pipelinec_build/src/poly1305/poly1305_verify_decrypt.c.
Wire names elaborate as poly1305_verify_decrypt_<wire>; the C globals were
poly1305_verify_<wire> (prefix differs slightly, connections unchanged).
"""
import pypeline_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    hw_func,
    Reg,
    enum,
    uint1_t,
)

from aead_types import (
    poly1305_auth_tag_uint_t,
    poly1305_auth_tag_stream_t,
    poly1305_auth_tag_stream_fb_t,
    uint1_stream_t,
    uint1_stream_fb_t,
    uint1_stream_null,
)


@enum
class poly1305_verify_state_t:
    TAKE_AUTH_TAG = auto()  # take auth_tag and place it into a register
    TAKE_CALC_TAG = auto()  # take calculated tag and place it into a reg
    COMPARE_TAGS = auto()  # compare the two tags ("==") and place res in reg
    OUTPUT_COMPARE_RESULT = auto()  # output the compare value


@struct
class poly1305_verify_decrypt_out_t(NamedTuple):
    auth_tag: poly1305_auth_tag_stream_fb_t
    calc_tag: poly1305_auth_tag_stream_fb_t
    tags_match: uint1_stream_t


@hw_func
def poly1305_verify_decrypt(
    auth_tag: poly1305_auth_tag_stream_t,
    calc_tag: poly1305_auth_tag_stream_t,
    tags_match: uint1_stream_fb_t,
) -> poly1305_verify_decrypt_out_t:
    o: poly1305_verify_decrypt_out_t
    # Define static variables
    state: Reg[poly1305_verify_state_t]

    # Regs to hold the tag value
    auth_tag_reg: Reg[poly1305_auth_tag_uint_t]
    calc_tag_reg: Reg[poly1305_auth_tag_uint_t]

    # Reg to hold compare result
    tags_match_reg: Reg[uint1_t]

    o.auth_tag.ready = 0
    o.calc_tag.ready = 0
    o.tags_match = uint1_stream_null()

    if state == poly1305_verify_state_t.TAKE_AUTH_TAG:
        # Ready to take the input tag
        o.auth_tag.ready = 1

        if auth_tag.valid & o.auth_tag.ready:
            # Copy data to the register
            auth_tag_reg = auth_tag.data
            state = poly1305_verify_state_t.TAKE_CALC_TAG
    elif state == poly1305_verify_state_t.TAKE_CALC_TAG:
        # Ready to take the calculated tag
        o.calc_tag.ready = 1

        if calc_tag.valid & o.calc_tag.ready:
            calc_tag_reg = calc_tag.data
            state = poly1305_verify_state_t.COMPARE_TAGS
    elif state == poly1305_verify_state_t.COMPARE_TAGS:
        # Perform comparison logic
        tags_match_reg = auth_tag_reg == calc_tag_reg

        # Output the result
        state = poly1305_verify_state_t.OUTPUT_COMPARE_RESULT
    else:  # state == poly1305_verify_state_t.OUTPUT_COMPARE_RESULT
        # Output result stored in register via local stream
        o.tags_match.data = tags_match_reg
        o.tags_match.valid = 1

        if tags_match.ready & o.tags_match.valid:
            # Successful output transfer
            # Reset the FSM for the next verification
            state = poly1305_verify_state_t.TAKE_AUTH_TAG

    return o
