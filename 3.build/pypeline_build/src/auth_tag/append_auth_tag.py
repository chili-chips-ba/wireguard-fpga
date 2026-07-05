# pyright: reportInvalidTypeForm=none
"""Append the auth tag after the ciphertext.

Pypeline port of ../pipelinec_build/src/auth_tag/append_auth_tag.c.
Wire names elaborate as append_auth_tag_<wire> to match the C globals.
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
    uint8_t,
    uint_to_array_le,
)

from aead_types import (
    POLY1305_AUTH_TAG_SIZE,
    axis128_t,
    axis128_null,
    poly1305_auth_tag_stream_t,
)


@enum
class append_auth_tag_state_t:
    CIPHERTEXT = auto()
    AUTH_TAG = auto()


@struct
class append_auth_tag_out_t(NamedTuple):
    axis_in_ready: uint1_t
    auth_tag_in_ready: uint1_t
    axis_out: axis128_t


@hw_func
def append_auth_tag(
    axis_in: axis128_t,
    auth_tag_in: poly1305_auth_tag_stream_t,
    axis_out_ready: uint1_t,
) -> append_auth_tag_out_t:
    o: append_auth_tag_out_t
    state: Reg[append_auth_tag_state_t]

    # Default not ready for incoming data
    o.axis_in_ready = 0
    o.auth_tag_in_ready = 0
    # Default not outputting data
    o.axis_out = axis128_null()

    if state == append_auth_tag_state_t.CIPHERTEXT:
        # Pass through ciphertext
        o.axis_out = axis_in
        o.axis_in_ready = axis_out_ready
        # Except for tlast since adding extra actual last auth tag cycle next
        o.axis_out.data.eod[0] = 0
        if axis_in.data.eod[0] & axis_in.valid & o.axis_in_ready:
            state = append_auth_tag_state_t.AUTH_TAG
    else:  # if state == append_auth_tag_state_t.AUTH_TAG
        # Insert auth tag as new last cycle
        tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE] = uint_to_array_le(
            auth_tag_in.data, 8
        )
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out.data.frag.data[i] = tag_bytes[i]
            o.axis_out.data.frag.keep[i] = 1
        o.axis_out.data.eod[0] = 1
        o.axis_out.valid = auth_tag_in.valid
        o.auth_tag_in_ready = axis_out_ready
        if o.axis_out.valid & axis_out_ready:
            state = append_auth_tag_state_t.CIPHERTEXT

    return o
