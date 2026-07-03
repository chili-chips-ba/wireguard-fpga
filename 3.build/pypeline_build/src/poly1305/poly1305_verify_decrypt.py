# pyright: reportInvalidTypeForm=none
"""Check if auth_tag and calculated_tag are the same.

Pypeline port of ../pipelinec_build/src/poly1305/poly1305_verify_decrypt.c.
Wire names elaborate as poly1305_verify_decrypt_<wire>; the C globals were
poly1305_verify_<wire> (prefix differs slightly, connections unchanged).
"""
import pypeline_env  # noqa: F401

from enum import IntEnum

from pypeline import (
    MAIN,
    Wire,
    Reg,
    enum,
    uint1_t,
)

from aead_types import (
    poly1305_auth_tag_uint_t,
    poly1305_auth_tag_stream_t,
    uint1_stream_t,
    uint1_stream_null,
)

# Input auth_tag
auth_tag: Wire[poly1305_auth_tag_stream_t]  # input
auth_tag_ready: Wire[uint1_t]  # output

# Input calc_tag
calc_tag: Wire[poly1305_auth_tag_stream_t]  # input
calc_tag_ready: Wire[uint1_t]  # output

# Output stream is_verified/tags_match bit
tags_match: Wire[uint1_stream_t]  # output
tags_match_ready: Wire[uint1_t]  # input


@enum
class poly1305_verify_state_t(IntEnum):
    TAKE_AUTH_TAG = 0  # take auth_tag and place it into a register
    TAKE_CALC_TAG = 1  # take calculated tag and place it into a reg
    COMPARE_TAGS = 2  # compare the two tags ("==") and place res in reg
    OUTPUT_COMPARE_RESULT = 3  # output the compare value


@MAIN
def poly1305_verify_decrypt():
    # Define static variables
    state: Reg[poly1305_verify_state_t]

    # Regs to hold the tag value
    auth_tag_reg: Reg[poly1305_auth_tag_uint_t]
    calc_tag_reg: Reg[poly1305_auth_tag_uint_t]

    # Reg to hold compare result
    tags_match_reg: Reg[uint1_t]

    auth_tag_ready_s: uint1_t = 0
    calc_tag_ready_s: uint1_t = 0
    tags_match_s: uint1_stream_t = uint1_stream_null()

    if state == poly1305_verify_state_t.TAKE_AUTH_TAG:
        # Ready to take the input tag
        auth_tag_ready_s = 1

        if auth_tag.valid & auth_tag_ready_s:
            # Copy data to the register
            auth_tag_reg = auth_tag.data
            state = poly1305_verify_state_t.TAKE_CALC_TAG
    elif state == poly1305_verify_state_t.TAKE_CALC_TAG:
        # Ready to take the calculated tag
        calc_tag_ready_s = 1

        if calc_tag.valid & calc_tag_ready_s:
            calc_tag_reg = calc_tag.data
            state = poly1305_verify_state_t.COMPARE_TAGS
    elif state == poly1305_verify_state_t.COMPARE_TAGS:
        # Perform comparison logic
        tags_match_reg = auth_tag_reg == calc_tag_reg

        # Output the result
        state = poly1305_verify_state_t.OUTPUT_COMPARE_RESULT
    else:  # state == poly1305_verify_state_t.OUTPUT_COMPARE_RESULT
        # Output result stored in register via local stream
        tags_match_s.data = tags_match_reg
        tags_match_s.valid = 1

        if tags_match_ready & tags_match_s.valid:
            # Successful output transfer
            # Reset the FSM for the next verification
            state = poly1305_verify_state_t.TAKE_AUTH_TAG

    # Drive output wires
    auth_tag_ready = auth_tag_ready_s
    calc_tag_ready = calc_tag_ready_s
    tags_match = tags_match_s
