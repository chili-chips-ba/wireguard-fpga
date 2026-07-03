# pyright: reportInvalidTypeForm=none
"""Append the auth tag after the ciphertext.

Pypeline port of ../pipelinec_build/src/auth_tag/append_auth_tag.c.
Wire names elaborate as append_auth_tag_<wire> to match the C globals.
"""
import pypeline_env  # noqa: F401

from enum import IntEnum

from pypeline import (
    MAIN,
    Wire,
    Reg,
    enum,
    uint1_t,
    uint8_t,
    uint_to_array_le,
)

from aead_types import (
    POLY1305_AUTH_TAG_SIZE,
    axis128_t,
    axis128_null,
    poly1305_auth_tag_stream_t,
)

# Input stream of ciphertext
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Input of auth tag output from poly1305_mac
auth_tag_in: Wire[poly1305_auth_tag_stream_t]  # input
auth_tag_in_ready: Wire[uint1_t]  # output
# Output stream of ciphertext followed by appended auth tag
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input


@enum
class append_auth_tag_state_t(IntEnum):
    CIPHERTEXT = 0
    AUTH_TAG = 1


@MAIN
def append_auth_tag():
    state: Reg[append_auth_tag_state_t]

    # Locals for the wires this MAIN drives (single wire assignment at the end)
    # Default not ready for incoming data
    axis_in_ready_s: uint1_t = 0
    auth_tag_in_ready_s: uint1_t = 0
    # Default not outputting data
    axis_out_s: axis128_t = axis128_null()

    if state == append_auth_tag_state_t.CIPHERTEXT:
        # Pass through ciphertext
        axis_out_s = axis_in
        axis_in_ready_s = axis_out_ready
        # Except for tlast since adding extra actual last auth tag cycle next
        axis_out_s.data.eod[0] = 0
        if axis_in.data.eod[0] & axis_in.valid & axis_in_ready_s:
            state = append_auth_tag_state_t.AUTH_TAG
    else:  # if state == append_auth_tag_state_t.AUTH_TAG
        # Insert auth tag as new last cycle
        tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE] = uint_to_array_le(
            auth_tag_in.data, 8
        )
        for i in range(POLY1305_AUTH_TAG_SIZE):
            axis_out_s.data.frag.data[i] = tag_bytes[i]
            axis_out_s.data.frag.keep[i] = 1
        axis_out_s.data.eod[0] = 1
        axis_out_s.valid = auth_tag_in.valid
        auth_tag_in_ready_s = axis_out_ready
        if axis_out_s.valid & axis_out_ready:
            state = append_auth_tag_state_t.CIPHERTEXT

    # Drive output wires
    axis_in_ready = axis_in_ready_s
    auth_tag_in_ready = auth_tag_in_ready_s
    axis_out = axis_out_s
