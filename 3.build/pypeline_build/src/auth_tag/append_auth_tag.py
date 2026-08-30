# pyright: reportInvalidTypeForm=none
"""Append the auth tag after the ciphertext, Xilinx-style (packed into the
stream, not a separate full-keep word) -- see README.md's "Xilinx-style
tkeep" section for the framing and why.

No longer a 1:1 port of ../pipelinec_build/src/auth_tag/append_auth_tag.c,
which still uses the old separate-tag-word framing.
"""
import wireguard_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    hw_func,
    Reg,
    enum,
    uint8_t,
    uint_to_array_le,
    sim_assert,
)

from aead_types import (
    POLY1305_AUTH_TAG_SIZE,
    axis128_intrf,
    axis128_stream_null,
    axis128_keep_count,
    axis128_keep_count_t,
    axis128_count_to_keep,
    poly1305_auth_tag_stream_intrf,
)


@enum
class append_auth_tag_state_t:
    CIPHERTEXT = auto()
    MERGED_WORD = auto()
    TAG_TAIL = auto()


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
    # The packet's final ciphertext word, and how many of its 16 lanes are
    # really ciphertext (r, in [1, 16])
    held_data_reg: Reg[uint8_t[POLY1305_AUTH_TAG_SIZE]]
    held_keep_count_reg: Reg[axis128_keep_count_t]

    # Default not ready for incoming data
    o.axis_in_if.ready = 0
    o.auth_tag_in_if.ready = 0
    # Default not outputting data
    o.axis_out_if.stream = axis128_stream_null()

    # {held ciphertext word, tag} packed contiguously: ct in lanes [0, r),
    # tag in lanes [r, r+16) -- low 16 = MERGED_WORD beat, high 16 = TAG_TAIL
    # beat. Max write index r+15 = 31, in range for the array and keep_count_t.
    tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE] = uint_to_array_le(
        auth_tag_in_if.stream.data, 8
    )
    merged: uint8_t[2 * POLY1305_AUTH_TAG_SIZE]
    for i in range(POLY1305_AUTH_TAG_SIZE):
        merged[i] = held_data_reg[i]
        merged[POLY1305_AUTH_TAG_SIZE + i] = 0
    for i in range(POLY1305_AUTH_TAG_SIZE):
        merged[held_keep_count_reg + i] = tag_bytes[i]

    if state == append_auth_tag_state_t.CIPHERTEXT:
        # Pass through ciphertext
        o.axis_out_if = axis_in_if
        o.axis_in_if.ready = axis_out_if.ready
        # Except for eod/tlast -- TAG_TAIL emits the true last beat
        o.axis_out_if.stream.data.eod[0] = 0
        if axis_in_if.stream.data.eod[0] & axis_in_if.stream.valid & o.axis_in_if.ready:
            keep_count: axis128_keep_count_t = axis128_keep_count(
                axis_in_if.stream.data.frag
            )
            sim_assert(
                keep_count != 0,
                "append_auth_tag: zero-length payload (tlast beat with tkeep all zero)",
            )
            held_data_reg = axis_in_if.stream.data.frag.data
            held_keep_count_reg = keep_count
            if keep_count == POLY1305_AUTH_TAG_SIZE:
                # Full keep: no tag bytes to merge, this beat already went
                # out above as ordinary ciphertext -- go straight to the tag
                state = append_auth_tag_state_t.TAG_TAIL
            else:
                # Hold it back a beat so the tag can fill its unused lanes.
                # Accepted unconditionally, not gated on the tag being
                # ready: this copy and poly1305_mac's are two ends of one
                # axis128_2broadcast, so the MAC cannot see this word until
                # this copy is taken -- waiting for the tag would deadlock.
                o.axis_out_if.stream.valid = 0
                state = append_auth_tag_state_t.MERGED_WORD
    elif state == append_auth_tag_state_t.MERGED_WORD:
        # r ct bytes || tag[0 : 16-r], full keep, not yet eod (r < 16 here)
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out_if.stream.data.frag.data[i] = merged[i]
            o.axis_out_if.stream.data.frag.keep[i] = 1
        o.axis_out_if.stream.data.eod[0] = 0
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            state = append_auth_tag_state_t.TAG_TAIL
    else:  # if state == append_auth_tag_state_t.TAG_TAIL
        # tag[16-r : 16], keep = r ones, eod = 1 -- the true final beat
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out_if.stream.data.frag.data[i] = merged[POLY1305_AUTH_TAG_SIZE + i]
        o.axis_out_if.stream.data.frag.keep = axis128_count_to_keep(held_keep_count_reg)
        o.axis_out_if.stream.data.eod[0] = 1
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid
        o.auth_tag_in_if.ready = axis_out_if.ready
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            state = append_auth_tag_state_t.CIPHERTEXT

    return o
