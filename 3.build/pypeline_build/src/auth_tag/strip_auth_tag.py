# pyright: reportInvalidTypeForm=none
"""Strip the auth tag from the end of the ciphertext stream (splits the input
into a ciphertext stream + an auth tag stream).

Pypeline port of ../pipelinec_build/src/auth_tag/strip_auth_tag.c.
Wire names elaborate as strip_auth_tag_<wire> to match the C globals.
"""
import pypeline_env  # noqa: F401

from pypeline import (
    NamedTuple,
    struct,
    hw_func,
    Reg,
    Feedback,
    uint1_t,
    array_to_uint_le,
)

from aead_types import (
    axis128_t,
    axis128_fb_t,
    axis128_null,
    poly1305_auth_tag_stream_t,
    poly1305_auth_tag_stream_fb_t,
    poly1305_auth_tag_stream_null,
)


@struct
class axis128_early_tlast_t(NamedTuple):
    # Outputs
    axis_out: axis128_t  # output port's feedforward half
    next_axis_out_is_tlast: uint1_t  # plain sideband, no reverse companion
    stream_in: axis128_fb_t  # input port's reverse half


@hw_func
def axis128_early_tlast(
    # Inputs
    stream_in: axis128_t,
    axis_out: axis128_fb_t,
) -> axis128_early_tlast_t:
    o: axis128_early_tlast_t  # outputs

    # Output comes via the buffer reg
    buffer_reg: Reg[axis128_t]

    # Stop data from flowing buffer -> out
    # until we can determine if last is next
    buffer_is_tlast: uint1_t = buffer_reg.valid & buffer_reg.data.eod[0]
    buff_to_out_connected: uint1_t = (
        # Connect if the buffer itself is tlast
        # (kinda corner case for single word packet)
        buffer_is_tlast
        # Or if next word is incoming now
        # (so we can know if it is last)
        | stream_in.valid
    )
    o.axis_out = axis128_null()
    o.next_axis_out_is_tlast = 0
    if buff_to_out_connected:
        o.axis_out = buffer_reg
        o.next_axis_out_is_tlast = stream_in.valid & stream_in.data.eod[0]

    # Outgoing transfer clears buffer valid
    if o.axis_out.valid & axis_out.ready:
        buffer_reg.valid = 0

    # Ready for input data if room in buffer
    o.stream_in.ready = ~buffer_reg.valid
    # Incoming transfer puts data into buffer
    if stream_in.valid & o.stream_in.ready:
        buffer_reg = stream_in

    return o


@struct
class strip_auth_tag_out_t(NamedTuple):
    axis_in: axis128_fb_t
    axis_out: axis128_t
    auth_tag_out: poly1305_auth_tag_stream_t


@hw_func
def strip_auth_tag(
    axis_in: axis128_t,
    axis_out: axis128_fb_t,
    auth_tag_out: poly1305_auth_tag_stream_fb_t,
) -> strip_auth_tag_out_t:
    o: strip_auth_tag_out_t
    early_out_ready: Feedback[axis128_fb_t]

    early_tlast = axis128_early_tlast(stream_in=axis_in, axis_out=early_out_ready)

    # Ready for axis into early module
    o.axis_in = early_tlast.stream_in
    # stream coming out of early module
    stream_in: axis128_t = early_tlast.axis_out

    # Default passing input axis data to ciphertext output
    o.axis_out = stream_in
    early_out_ready = axis128_fb_t(ready=axis_out.ready)

    # With override to use the early tlast for ciphertext tlast
    o.axis_out.data.eod[0] = early_tlast.next_axis_out_is_tlast
    # and not passing data to auth tag out
    o.auth_tag_out = poly1305_auth_tag_stream_null()

    # If this is last input cycle then it's auth tag
    if stream_in.valid & stream_in.data.eod[0]:
        # not passing ciphertext output
        o.axis_out.valid = 0
        # Connect to auth tag output
        o.auth_tag_out.data = array_to_uint_le(stream_in.data.frag.data)
        o.auth_tag_out.valid = stream_in.valid
        early_out_ready = axis128_fb_t(ready=auth_tag_out.ready)

    return o
