# pyright: reportInvalidTypeForm=none
"""Buffer decrypted plaintext in a FIFO until the Poly1305 verify bit arrives,
then stream it out alongside the verification result.

Pypeline port of ../pipelinec_build/src/auth_tag/wait_to_verify.c.
Wire names elaborate as wait_to_verify_<wire> to match the C globals;
the C GLOBAL_STREAM_FIFO(axis128_t, verify_fifo, 128) becomes a
make_stream_fifo instance in its own MAIN with verify_fifo_* wires.
"""
import pypeline_env  # noqa: F401

from enum import auto

from pypeline import (
    MAIN,
    Wire,
    Reg,
    enum,
    uint1_t,
)
from stream.stream_fifo import make_stream_fifo

from aead_types import (
    axis128_t,
    axis128_frag_t,
    uint1_stream_t,
)

# Input stream of plaintext
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Input verify bit
verify_bit: Wire[uint1_stream_t]  # input
verify_bit_ready: Wire[uint1_t]  # output
# Output stream of plaintext
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input
# Output for the verification result
is_verified_out: Wire[uint1_t]  # output

# C GLOBAL_STREAM_FIFO(axis128_t, verify_fifo, 128)
verify_fifo_in: Wire[axis128_t]
verify_fifo_in_ready: Wire[uint1_t]
verify_fifo_out: Wire[axis128_t]
verify_fifo_out_ready: Wire[uint1_t]

verify_fifo_func, verify_fifo_t = make_stream_fifo(axis128_frag_t, 128)


@MAIN
def verify_fifo():
    result = verify_fifo_func(verify_fifo_out_ready, verify_fifo_in)
    verify_fifo_out = result.out_stream
    verify_fifo_in_ready = result.in_ready


@enum
class wait_to_verify_state_t:
    # Place the input plaintext into fifo until verify bit arrives
    WAIT_TO_VERIFY_BIT = auto()
    # once verify bit arrives output plaintext and verify bit
    OUTPUT_PLAINTEXT = auto()


@MAIN
def wait_to_verify():
    state: Reg[wait_to_verify_state_t]
    # Reg to hold the received verification result (tags_match)
    tags_match_reg: Reg[uint1_t]

    # Write side of FIFO
    # the data+valid for input stream (aka fifo write data, write enable)
    verify_fifo_in_s: axis128_t = axis_in
    # the ready signal for the input stream (aka fifo not full signal)
    axis_in_ready_s: uint1_t = verify_fifo_in_ready

    # Read side of FIFO
    # the data+valid for output stream (aka fifo read data, not empty signal)
    axis_out_s: axis128_t = verify_fifo_out

    # Default not ready for the single verify bit input
    verify_bit_ready_s: uint1_t = 0
    # Default FIFO Read Enable is set by FSM
    verify_fifo_out_ready_s: uint1_t = 0
    # Default output valid/tlast for stream is 0
    axis_out_s.valid = 0
    # Default is_verified output
    is_verified_out_s: uint1_t = 0

    if state == wait_to_verify_state_t.WAIT_TO_VERIFY_BIT:
        # FIFO Read Enable: Disconnected, data stays buffered
        verify_fifo_out_ready_s = 0

        # Output stream: invalid
        axis_out_s.valid = 0

        # Wait for verify bit
        # Be ready to accept the single bit
        verify_bit_ready_s = 1

        if verify_bit.valid:
            # Capture the result and signal reception
            tags_match_reg = verify_bit.data

            # Move to output state
            state = wait_to_verify_state_t.OUTPUT_PLAINTEXT
    else:  # if state == wait_to_verify_state_t.OUTPUT_PLAINTEXT
        # Plaintext output
        verify_fifo_out_ready_s = axis_out_ready
        # Valid only if FIFO is not empty
        axis_out_s.valid = verify_fifo_out.valid

        # Verified bit output
        # Synchronize with stream valid
        is_verified_out_s = tags_match_reg

        # Check for successful consumption of the last packet
        if axis_out_s.valid & axis_out_ready:
            # If output is consumed, check for tlast
            if axis_out_s.data.eod[0]:
                # End of buffered plaintext, reset the FSM
                state = wait_to_verify_state_t.WAIT_TO_VERIFY_BIT

        # Input ready's are disconnected in this state
        verify_bit_ready_s = 0

    # Drive output wires
    verify_fifo_in = verify_fifo_in_s
    axis_in_ready = axis_in_ready_s
    axis_out = axis_out_s
    verify_bit_ready = verify_bit_ready_s
    verify_fifo_out_ready = verify_fifo_out_ready_s
    is_verified_out = is_verified_out_s
