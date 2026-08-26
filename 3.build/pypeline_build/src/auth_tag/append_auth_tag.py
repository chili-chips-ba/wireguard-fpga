# pyright: reportInvalidTypeForm=none
"""Append the auth tag after the ciphertext, Xilinx-style: packed contiguously
into the ciphertext stream rather than as its own always-full-keep word, so
`tkeep` is never partial anywhere except the true final beat (wireguard-fpga
issue #44 -- AMD/Xilinx AXIS-interop IP does not tolerate mid-packet null
bytes, only ARM's strict AXI4-Stream spec permits them).

No longer a 1:1 port of ../pipelinec_build/src/auth_tag/append_auth_tag.c --
the C source still emits the tag as a separate full-keep word; see
README.md's "Xilinx-style tkeep" section for why this Pypeline port
deliberately diverges.
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
    # The packet's final ciphertext word, held back one beat so the tag can
    # be packed into its unused lanes, plus how many of its 16 lanes were
    # actually kept ciphertext (r).
    held_data_reg: Reg[uint8_t[POLY1305_AUTH_TAG_SIZE]]
    held_keep_count_reg: Reg[axis128_keep_count_t]

    # Default not ready for incoming data
    o.axis_in_if.ready = 0
    o.auth_tag_in_if.ready = 0
    # Default not outputting data
    o.axis_out_if.stream = axis128_stream_null()

    # Shared datapath for both emitting states, built the same way
    # strip_auth_tag.py's tag-reassembly window is: a fixed-position
    # {held ciphertext word, tag} buffer (constant-indexed writes only, no
    # dynamic write index) read back at a register-derived offset (dynamic
    # *read* index, matching strip_auth_tag.py's proven-good
    # `window[last_keep_count + i]` idiom) -- a dynamic *write* index here
    # (`packed[held_keep_count_reg + i] = ...`) previously produced a
    # native-sim-vs-real-VHDL mismatch (wrong byte from a GHDL cocotb run,
    # not reproduced in native sim); see
    # pypeline-bugs/dynamic-array-write-vs-ghdl-mismatch.md.
    #
    # base = 16 - r is how far into the tag lanes [16, 32) of `combined`
    # TAG_TAIL's kept lanes start; MERGED_WORD's borrowed tag lanes read
    # from the same offset. Always in [0, 15] since r (held_keep_count_reg)
    # is always in [1, 16] by the time these states run (the r == 0 guard
    # below forces it to 16). `combined` is oversized to 48 (not 32) so
    # every dynamic read stays in-bounds even for the *unused* lanes of a
    # per-lane mux (e.g. TAG_TAIL's don't-care lanes i >= r) -- worst case
    # 16 + base + i = 16 + 15 + 15 = 46.
    tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE] = uint_to_array_le(
        auth_tag_in_if.stream.data, 8
    )
    combined: uint8_t[3 * POLY1305_AUTH_TAG_SIZE]
    for i in range(3 * POLY1305_AUTH_TAG_SIZE):
        combined[i] = 0
    for i in range(POLY1305_AUTH_TAG_SIZE):
        combined[i] = held_data_reg[i]
        combined[POLY1305_AUTH_TAG_SIZE + i] = tag_bytes[i]
    base: axis128_keep_count_t = POLY1305_AUTH_TAG_SIZE - held_keep_count_reg

    if state == append_auth_tag_state_t.CIPHERTEXT:
        # Pass through ciphertext
        o.axis_out_if = axis_in_if
        o.axis_in_if.ready = axis_out_if.ready
        # Except for eod/tlast -- the true last beat is generated below,
        # once the tag has been merged in
        o.axis_out_if.stream.data.eod[0] = 0
        if axis_in_if.stream.data.eod[0] & axis_in_if.stream.valid & o.axis_in_if.ready:
            # Hold this last ciphertext word back one beat instead of
            # forwarding it, so its unused lanes can carry the start of the
            # tag. Accepted unconditionally here (not gated on the tag being
            # ready) -- this stream and the copy poly1305_mac consumes (to
            # produce the tag) are two ends of the same axis128_2broadcast
            # interlock, so the MAC cannot even see this word until this
            # copy is accepted. Waiting for the tag before accepting would
            # deadlock the broadcast.
            o.axis_out_if.stream.valid = 0
            held_data_reg = axis_in_if.stream.data.frag.data
            held_keep_count_reg = axis128_keep_count(axis_in_if.stream.data.frag)
            state = append_auth_tag_state_t.MERGED_WORD
            if axis128_keep_count(axis_in_if.stream.data.frag) == 0:
                # Empty final beat (e.g. a zero-length payload): nothing to
                # merge the tag into, so emit the whole tag as one full-keep
                # last word instead.
                held_keep_count_reg = POLY1305_AUTH_TAG_SIZE
                state = append_auth_tag_state_t.TAG_TAIL
    elif state == append_auth_tag_state_t.MERGED_WORD:
        # Emit the held ciphertext word with tag[0 : 16-r] merged into its
        # unused lanes (r = held_keep_count_reg), full keep, not yet eod.
        # Lane i < r is ciphertext (static-index read); lane i >= r is
        # tag[i - r] == combined[16 + (i - r)] == combined[base + i]
        # (dynamic-index read, base = 16 - r). A word-aligned ciphertext
        # (r == 16) never takes the tag branch, so it need not wait for the
        # tag -- keeps today's cycle behavior for aligned lengths.
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out_if.stream.data.frag.data[i] = combined[i]
            if i >= held_keep_count_reg:
                o.axis_out_if.stream.data.frag.data[i] = combined[base + i]
            o.axis_out_if.stream.data.frag.keep[i] = 1
        o.axis_out_if.stream.data.eod[0] = 0
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid | (
            held_keep_count_reg == POLY1305_AUTH_TAG_SIZE
        )
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            state = append_auth_tag_state_t.TAG_TAIL
    else:  # if state == append_auth_tag_state_t.TAG_TAIL
        # Emit tag[16-r : 16] as the true final beat, keep = r ones, eod=1.
        # Lane i = tag[base + i] == combined[16 + base + i] (dynamic-index
        # read); only lanes i < r are actually kept, the rest don't-care.
        for i in range(POLY1305_AUTH_TAG_SIZE):
            o.axis_out_if.stream.data.frag.data[i] = combined[
                POLY1305_AUTH_TAG_SIZE + base + i
            ]
        o.axis_out_if.stream.data.frag.keep = axis128_count_to_keep(held_keep_count_reg)
        o.axis_out_if.stream.data.eod[0] = 1
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid
        o.auth_tag_in_if.ready = axis_out_if.ready
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            state = append_auth_tag_state_t.CIPHERTEXT

    return o
