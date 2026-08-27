# pyright: reportInvalidTypeForm=none
"""Strip the auth tag from the ciphertext stream (splits input into a
ciphertext stream + an auth tag stream), Xilinx-style packed ct||tag framing
-- see README.md's "Xilinx-style tkeep" section for the framing and why.

No longer a 1:1 port of ../pipelinec_build/src/auth_tag/strip_auth_tag.c,
which still uses the old separate-tag-word framing.
"""
import wireguard_env  # noqa: F401

from pypeline import (
    NamedTuple,
    struct,
    hw_func,
    Reg,
    Feedback,
    uint1_t,
    uint8_t,
    array_to_uint_le,
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
    poly1305_auth_tag_stream_null,
)


@struct
class axis128_early_tlast_t(NamedTuple):
    # Outputs
    axis_out_if: axis128_intrf.fwd_t  # output port's feedforward half
    next_axis_out_is_tlast: uint1_t  # plain sideband, no reverse companion
    stream_in_if: axis128_intrf.fb_t  # input port's reverse half


@hw_func
def axis128_early_tlast(
    # Inputs
    stream_in_if: axis128_intrf.fwd_t,
    axis_out_if: axis128_intrf.fb_t,
) -> axis128_early_tlast_t:
    o: axis128_early_tlast_t  # outputs

    # Output comes via the buffer reg
    buffer_reg: Reg[axis128_intrf.stream_t]

    # Stop data from flowing buffer -> out
    # until we can determine if last is next
    buffer_is_tlast: uint1_t = buffer_reg.valid & buffer_reg.data.eod[0]
    buff_to_out_connected: uint1_t = (
        # Connect if the buffer itself is tlast
        # (kinda corner case for single word packet)
        buffer_is_tlast
        # Or if next word is incoming now
        # (so we can know if it is last)
        | stream_in_if.stream.valid
    )
    o.axis_out_if.stream = axis128_stream_null()
    o.next_axis_out_is_tlast = 0
    if buff_to_out_connected:
        o.axis_out_if.stream = buffer_reg
        o.next_axis_out_is_tlast = stream_in_if.stream.valid & stream_in_if.stream.data.eod[0]

    # Outgoing transfer clears buffer valid
    if o.axis_out_if.stream.valid & axis_out_if.ready:
        buffer_reg.valid = 0

    # Ready for input data if room in buffer
    o.stream_in_if.ready = ~buffer_reg.valid
    # Incoming transfer puts data into buffer
    if stream_in_if.stream.valid & o.stream_in_if.ready:
        buffer_reg = stream_in_if.stream

    return o


@struct
class strip_auth_tag_out_t(NamedTuple):
    axis_in_if: axis128_intrf.fb_t
    axis_out_if: axis128_intrf.fwd_t
    auth_tag_out_if: poly1305_auth_tag_stream_intrf.fwd_t


@hw_func
def strip_auth_tag(
    axis_in_if: axis128_intrf.fwd_t,
    axis_out_if: axis128_intrf.fb_t,
    auth_tag_out_if: poly1305_auth_tag_stream_intrf.fb_t,
) -> strip_auth_tag_out_t:
    o: strip_auth_tag_out_t
    early_out_ready: Feedback[uint1_t]
    # Second-to-last beat: true final ciphertext, tag[0:16-r] merged in.
    # Held until the true last beat (tag[16-r:16]) arrives to recombine.
    prev_data_reg: Reg[uint8_t[POLY1305_AUTH_TAG_SIZE]]

    early_tlast = axis128_early_tlast(
        stream_in_if=axis_in_if, axis_out_if=axis128_intrf.fb_t(early_out_ready)
    )

    # Ready for axis into early module
    o.axis_in_if = early_tlast.stream_in_if
    # stream coming out of early module
    stream_in: axis128_intrf.stream_t = early_tlast.axis_out_if.stream

    # Default passing input axis data to ciphertext output
    o.axis_out_if.stream = stream_in
    early_out_ready = axis_out_if.ready

    # With override to use the early tlast for ciphertext tlast
    o.axis_out_if.stream.data.eod[0] = early_tlast.next_axis_out_is_tlast
    if early_tlast.next_axis_out_is_tlast:
        # Buffered beat = ciphertext's true final beat (r kept lanes, tag
        # head in the rest). axis_in_if right now is the tag-tail beat --
        # its keep is already the Xilinx-style prefix this beat needs (see
        # README's "Xilinx-style tkeep" section), so reuse it directly.
        recomputed_keep = axis128_count_to_keep(
            axis128_keep_count(axis_in_if.stream.data.frag)
        )
        keep_is_prefix: uint1_t = 1
        for i in range(16):
            if recomputed_keep[i] != axis_in_if.stream.data.frag.keep[i]:
                keep_is_prefix = 0
        sim_assert(
            keep_is_prefix,
            "strip_auth_tag: tag-tail beat's keep is not a Xilinx-style prefix",
        )
        o.axis_out_if.stream.data.frag.keep = axis_in_if.stream.data.frag.keep
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            prev_data_reg = stream_in.data.frag.data
    # and not passing data to auth tag out
    o.auth_tag_out_if.stream = poly1305_auth_tag_stream_null()

    # Last input beat = tag's final (r-byte) beat -- reassemble the full
    # 16-byte tag from it plus the merged beat held in prev_data_reg.
    if stream_in.valid & stream_in.data.eod[0]:
        last_keep_count: axis128_keep_count_t = axis128_keep_count(stream_in.data.frag)
        window: uint8_t[2 * POLY1305_AUTH_TAG_SIZE]
        for i in range(POLY1305_AUTH_TAG_SIZE):
            window[i] = prev_data_reg[i]
            window[POLY1305_AUTH_TAG_SIZE + i] = stream_in.data.frag.data[i]
        tag_bytes: uint8_t[POLY1305_AUTH_TAG_SIZE]
        for i in range(POLY1305_AUTH_TAG_SIZE):
            tag_bytes[i] = window[last_keep_count + i]

        # not passing ciphertext output
        o.axis_out_if.stream.valid = 0
        # Connect to auth tag output
        o.auth_tag_out_if.stream.data = array_to_uint_le(tag_bytes)
        o.auth_tag_out_if.stream.valid = stream_in.valid
        early_out_ready = auth_tag_out_if.ready

    return o
