# pyright: reportInvalidTypeForm=none
"""Buffer decrypted plaintext in a FIFO until the Poly1305 verify bit arrives,
then stream it out alongside the verification result.

Pypeline port of ../pipelinec_build/src/auth_tag/wait_to_verify.c.
Wire names elaborate as wait_to_verify_<wire> to match the C globals;
the C GLOBAL_STREAM_FIFO(axis128_intrf.fwd_t, verify_fifo, 128) becomes a
make_stream_fifo instance in its own MAIN with verify_fifo_* wires.
"""
import wireguard_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    hw_func,
    Reg,
    Feedback,
    enum,
    uint1_t,
)
from stream.stream_fifo import make_stream_fifo

from aead_types import (
    axis128_intrf,
    axis128_frag_t,
    uint1_stream_intrf,
)

# C GLOBAL_STREAM_FIFO(axis128_intrf.fwd_t, verify_fifo, 128)
verify_fifo_func, _verify_fifo_t = make_stream_fifo(axis128_frag_t, 128)


@enum
class wait_to_verify_state_t:
    # Place the input plaintext into fifo until verify bit arrives
    WAIT_TO_VERIFY_BIT = auto()
    # once verify bit arrives output plaintext and verify bit
    OUTPUT_PLAINTEXT = auto()


@struct
class wait_to_verify_out_t(NamedTuple):
    axis_in_if: axis128_intrf.fb_t
    verify_bit_if: uint1_stream_intrf.fb_t
    axis_out_if: axis128_intrf.fwd_t
    is_verified_out: uint1_t  # plain sideband, no reverse companion


@hw_func
def wait_to_verify(
    axis_in_if: axis128_intrf.fwd_t,
    verify_bit_if: uint1_stream_intrf.fwd_t,
    axis_out_if: axis128_intrf.fb_t,
) -> wait_to_verify_out_t:
    o: wait_to_verify_out_t
    state: Reg[wait_to_verify_state_t]
    # Reg to hold the received verification result (tags_match)
    tags_match_reg: Reg[uint1_t]

    # verify_fifo <-> this FSM's own mutual dependency (fifo's read data/ready
    # feed the FSM, which in turn drives the fifo's write data/read-enable)
    verify_fifo_in_ready: Feedback[uint1_t]
    verify_fifo_out: Feedback[axis128_intrf.stream_t]

    # Write side of FIFO
    # the data+valid for input stream (aka fifo write data, write enable)
    verify_fifo_in_s: axis128_intrf.stream_t = axis_in_if.stream
    # the ready signal for the input stream (aka fifo not full signal)
    o.axis_in_if.ready = verify_fifo_in_ready

    # Read side of FIFO
    # the data+valid for output stream (aka fifo read data, not empty signal)
    o.axis_out_if.stream = verify_fifo_out

    # Default not ready for the single verify bit input
    o.verify_bit_if.ready = 0
    # Default FIFO Read Enable is set by FSM
    verify_fifo_out_ready_s: uint1_t = 0
    # Default output valid/tlast for stream is 0
    o.axis_out_if.stream.valid = 0
    # Default is_verified output
    o.is_verified_out = 0

    if state == wait_to_verify_state_t.WAIT_TO_VERIFY_BIT:
        # FIFO Read Enable: Disconnected, data stays buffered
        verify_fifo_out_ready_s = 0

        # Output stream: invalid
        o.axis_out_if.stream.valid = 0

        # Wait for verify bit
        # Be ready to accept the single bit
        o.verify_bit_if.ready = 1

        if verify_bit_if.stream.valid:
            # Capture the result and signal reception
            tags_match_reg = verify_bit_if.stream.data

            # Move to output state
            state = wait_to_verify_state_t.OUTPUT_PLAINTEXT
    else:  # if state == wait_to_verify_state_t.OUTPUT_PLAINTEXT
        # Plaintext output
        verify_fifo_out_ready_s = axis_out_if.ready
        # Valid only if FIFO is not empty
        o.axis_out_if.stream.valid = verify_fifo_out.valid

        # Verified bit output
        # Synchronize with stream valid
        o.is_verified_out = tags_match_reg

        # Check for successful consumption of the last packet
        if o.axis_out_if.stream.valid & axis_out_if.ready:
            # If output is consumed, check for tlast
            if o.axis_out_if.stream.data.eod[0]:
                # End of buffered plaintext, reset the FSM
                state = wait_to_verify_state_t.WAIT_TO_VERIFY_BIT

        # Input ready's are disconnected in this state
        o.verify_bit_if.ready = 0

    fifo_result = verify_fifo_func(
        in_stream_if=axis128_intrf.fwd_t(stream=verify_fifo_in_s),
        out_stream_if=axis128_intrf.fb_t(ready=verify_fifo_out_ready_s),
    )
    verify_fifo_out = fifo_result.out_stream_if.stream
    verify_fifo_in_ready = fifo_result.in_stream_if.ready

    return o
