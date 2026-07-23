# pyright: reportInvalidTypeForm=none
"""FSM that adds leading and trailing bytes around the ciphertext stream to
prepare the stream to be authenticated by Poly1305:
AAD || padding || ciphertext || padding || AAD length || ciphertext length

Pypeline port of ../pipelinec_build/src/prep_auth_data/prep_auth_data.h and
prep_auth_data.c. prep_auth_data_fsm is instantiated directly, once per
direction, by each dataflow core.
"""
import pypeline_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    enum,
    hw_func,
    Reg,
    uint1_t,
    uint8_t,
    uint16_t,
)

import aead_types
from aead_types import (
    AAD_MAX_LEN,
    axis128_t,
    axis128_fb_t,
    axis128_null,
)


@enum
class prep_auth_data_state_t:
    IDLE = auto()
    AAD_STATE = auto()
    CIPHERTEXT = auto()
    LENGTHS = auto()


@struct
class prep_auth_data_fsm_t(NamedTuple):
    # Outputs
    axis_in: axis128_fb_t  # input port's reverse half
    axis: axis128_t  # output port's feedforward half


@hw_func
def prep_auth_data_fsm(
    # Inputs
    aad: uint8_t[AAD_MAX_LEN],
    aad_len: uint8_t,
    axis_in: axis128_t,
    axis: axis128_fb_t,
) -> prep_auth_data_fsm_t:
    o: prep_auth_data_fsm_t
    # FSM that adds leading and trailing bytes around the ciphertext stream
    state: Reg[prep_auth_data_state_t]
    aad_reg: Reg[uint8_t[AAD_MAX_LEN]]
    counter: Reg[uint16_t]

    # Default not ready for incoming data
    o.axis_in.ready = 0
    # Default not outputting data
    o.axis = axis128_null()

    if state == prep_auth_data_state_t.IDLE:
        # Wait for incoming ciphertext
        if axis_in.valid:
            # Not yet ready for data until CIPHERTEXT
            # If have AAD, then output it first
            if aad_len > 0:
                # AAD is first, save input into reg for shifting out
                aad_reg = aad
                # and init counter with AAD length
                counter = aad_len
                state = prep_auth_data_state_t.AAD_STATE
            else:
                # No AAD, so ciphertext is first
                state = prep_auth_data_state_t.CIPHERTEXT
                counter = 0
    elif state == prep_auth_data_state_t.AAD_STATE:
        # Output up to 128b|16 bytes of AAD this cycle
        # AAD is conveniently padded to multiple of 16 bytes
        # so always full tkeep, tdata=0 for padding
        for i in range(16):
            if counter > i:
                o.axis.data.frag.data[i] = aad_reg[i]
            o.axis.data.frag.keep[i] = 1
        o.axis.valid = 1

        # Count AAD bytes as xfer happens
        if o.axis.valid & axis.ready:
            # More AAD bytes?
            if counter > 16:
                # Prepare next AAD bytes to be at bottom of the array
                # (C ARRAY_SHIFT_DOWN(aad_reg, AAD_MAX_LEN, 16))
                for i in range(AAD_MAX_LEN - 16):
                    aad_reg[i] = aad_reg[i + 16]
                counter = counter - 16
            else:
                # No more AAD bytes, CIPHERTEXT is next
                state = prep_auth_data_state_t.CIPHERTEXT
                counter = 0
    elif state == prep_auth_data_state_t.CIPHERTEXT:
        # Pass through ciphertext
        o.axis = axis_in
        o.axis_in.ready = axis.ready
        # last cycle of ciphertext is not the last cycle of output stream
        o.axis.data.eod[0] = 0
        # Data needs to be padded to 16 bytes with zeros
        # during cycles with partial tkeep
        for i in range(16):
            o.axis.data.frag.keep[i] = 1
            if ~axis_in.data.frag.keep[i]:
                o.axis.data.frag.data[i] = 0

        # Count ciphertext length as xfer happens
        if axis_in.valid & o.axis_in.ready:
            counter = counter + aead_types.axis128_keep_count(axis_in.data.frag)
            # As last cycle on input ciphertext passes, move to next state
            if axis_in.data.eod[0]:
                state = prep_auth_data_state_t.LENGTHS
    else:  # if state == prep_auth_data_state_t.LENGTHS
        # Two 64b lengths of AAD and ciphertext
        # fit into one 128b AXIS cycle
        pos = 0
        # AAD length
        for i in range(8):
            o.axis.data.frag.data[pos] = aad_len >> (i * 8)
            o.axis.data.frag.keep[pos] = 1
            pos += 1
        # Ciphertext length
        for i in range(8):
            o.axis.data.frag.data[pos] = counter >> (i * 8)
            o.axis.data.frag.keep[pos] = 1
            pos += 1
        # Last cycle of output stream
        o.axis.data.eod[0] = 1
        o.axis.valid = 1

        # As xfer happens, go back to idle
        if o.axis.valid & axis.ready:
            state = prep_auth_data_state_t.IDLE
    return o
