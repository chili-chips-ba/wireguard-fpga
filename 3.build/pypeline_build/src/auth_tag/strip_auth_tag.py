# pyright: reportInvalidTypeForm=none
"""Strip the auth tag from the end of the ciphertext stream (splits the input
into a ciphertext stream + an auth tag stream).

Pypeline port of ../pipelinec_build/src/auth_tag/strip_auth_tag.c.
Wire names elaborate as strip_auth_tag_<wire> to match the C globals.
"""
import pypeline_env  # noqa: F401

from pypeline import (
    MAIN,
    NamedTuple,
    struct,
    hw_func,
    Wire,
    Reg,
    Feedback,
    uint1_t,
    array_to_uint_le,
)

from aead_types import (
    axis128_t,
    axis128_null,
    poly1305_auth_tag_stream_t,
    poly1305_auth_tag_stream_null,
)

# Input stream of ciphertext followed by appended auth tag
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Output stream of ciphertext
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input
# Output auth tag output
auth_tag_out: Wire[poly1305_auth_tag_stream_t]  # output
auth_tag_out_ready: Wire[uint1_t]  # input


@struct
class axis128_early_tlast_t(NamedTuple):
    # Outputs
    axis_out: axis128_t
    next_axis_out_is_tlast: uint1_t
    ready_for_axis_in: uint1_t


@hw_func
def axis128_early_tlast(
    # Inputs
    stream_in: axis128_t,
    ready_for_axis_out: uint1_t,
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
    if o.axis_out.valid & ready_for_axis_out:
        buffer_reg.valid = 0

    # Ready for input data if room in buffer
    o.ready_for_axis_in = ~buffer_reg.valid
    # Incoming transfer puts data into buffer
    if stream_in.valid & o.ready_for_axis_in:
        buffer_reg = stream_in

    return o


@MAIN
def strip_auth_tag():
    ready_for_axis_in: Feedback[uint1_t]

    early_tlast = axis128_early_tlast(axis_in, ready_for_axis_in)

    # Ready for axis into early module
    axis_in_ready_s: uint1_t = early_tlast.ready_for_axis_in
    # stream coming out of early module
    stream_in: axis128_t = early_tlast.axis_out

    # Default passing input axis data to ciphertext output
    axis_out_s: axis128_t = stream_in
    ready_for_axis_in = axis_out_ready

    # With override to use the early tlast for ciphertext tlast
    axis_out_s.data.eod[0] = early_tlast.next_axis_out_is_tlast
    # and not passing data to auth tag out
    auth_tag_out_s: poly1305_auth_tag_stream_t = poly1305_auth_tag_stream_null()

    # If this is last input cycle then it's auth tag
    if stream_in.valid & stream_in.data.eod[0]:
        # not passing ciphertext output
        axis_out_s.valid = 0
        # Connect to auth tag output
        auth_tag_out_s.data = array_to_uint_le(stream_in.data.frag.data)
        auth_tag_out_s.valid = stream_in.valid
        ready_for_axis_in = auth_tag_out_ready

    # Drive output wires
    axis_in_ready = axis_in_ready_s
    axis_out = axis_out_s
    auth_tag_out = auth_tag_out_s
