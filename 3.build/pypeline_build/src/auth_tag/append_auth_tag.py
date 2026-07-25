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
    axis128_intrf,
    axis128_null,
    poly1305_auth_tag_stream_intrf,
)


@enum
class append_auth_tag_state_t:
    CIPHERTEXT = auto()
    AUTH_TAG = auto()


@struct
class append_auth_tag_out_t(NamedTuple):
    axis_in_if: axis128_intrf.fb_t
    auth_tag_in_if: poly1305_auth_tag_stream_intrf.fb_t
    axis_out_if: axis128_intrf.fwd_t


@hw_func
def append_auth_tag(
    axis_in_if: axis128_intrf.fwd_t,
    auth_tag_in_if: poly1305_auth_tag_stream_intrf.fwd_t,
    axis_out_if: axis128_intrf.fb_t,
) -> append_auth_tag_out_t:
    o: append_auth_tag_out_t
    state: Reg[append_auth_tag_state_t]

    # Default not ready for incoming data
    o.axis_in_if.ready = 0
    o.auth_tag_in_if.ready = 0
    # Default not outputting data
    o.axis_out_if = axis128_null()

    if state == append_auth_tag_state_t.CIPHERTEXT:
        # Pass through ciphertext
        o.axis_out_if = axis_in_if
        o.axis_in_if.ready = axis_out_if.ready
        # Except for tlast since adding extra actual last auth tag cycle next
        o.axis_out_if.stream.data.eod[0] = 0
        if axis_in_if.stream.data.eod[0] & axis_in_if.stream.valid & o.axis_in_if.ready:
            state = append_auth_tag_state_t.AUTH_TAG
    else:  # if state == append_auth_tag_state_t.AUTH_TAG
        # Insert auth tag as new last cycle
        tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE] = uint_to_array_le(
            auth_tag_in_if.stream.data, 8
        )
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out_if.stream.data.frag.data[i] = tag_bytes[i]
            o.axis_out_if.stream.data.frag.keep[i] = 1
        o.axis_out_if.stream.data.eod[0] = 1
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid
        o.auth_tag_in_if.ready = axis_out_if.ready
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            state = append_auth_tag_state_t.CIPHERTEXT

    return o
