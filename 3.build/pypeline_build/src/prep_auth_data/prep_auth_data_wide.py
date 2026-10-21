# pyright: reportInvalidTypeForm=none
"""RFC 8439 framing in 16-byte blocks, packed two per packet beat."""
import wireguard_env  # noqa: F401
from enum import auto
from pypeline import NamedTuple, struct, enum, hw_func, Reg, uint1_t, uint8_t, uint16_t, make_uint_t, sim_assert
from stream import stream_perf_probe as perf_taps
from aead_types import AAD_MAX_LEN, aead_axis_intrf, aead_stream_null, aead_keep_count

count_t = make_uint_t(3)


@enum
class state_t:
    IDLE = auto()
    AAD_STATE = auto()
    CIPHERTEXT = auto()
    LENGTHS = auto()
    DRAIN = auto()


@struct
class block_t(NamedTuple):
    data: uint8_t[16]
    last: uint1_t


@struct
class result_t(NamedTuple):
    axis_in_if: aead_axis_intrf.fb_t
    axis_if: aead_axis_intrf.fwd_t


@hw_func
def prep_auth_data_wide(aad: uint8_t[AAD_MAX_LEN], aad_len: uint8_t,
                        axis_in_if: aead_axis_intrf.fwd_t,
                        axis_if: aead_axis_intrf.fb_t) -> result_t:
    state: Reg[state_t]
    aad_reg: Reg[uint8_t[AAD_MAX_LEN]]
    aad_length: Reg[uint8_t]
    ct_length: Reg[uint16_t]
    blocks: Reg[block_t[4]]
    count: Reg[count_t]
    o: result_t
    o.axis_if.stream = aead_stream_null()
    o.axis_in_if.ready = 0
    pop: count_t = 0
    if count >= 2:
        o.axis_if.stream.valid = 1
        o.axis_if.stream.data.eod[0] = blocks[1].last
        for j in range(16):
            o.axis_if.stream.data.frag.data[j] = blocks[0].data[j]
            o.axis_if.stream.data.frag.data[j + 16] = blocks[1].data[j]
            o.axis_if.stream.data.frag.keep[j] = 1
            o.axis_if.stream.data.frag.keep[j + 16] = 1
        if axis_if.ready:
            pop = 2
    elif (count == 1) & blocks[0].last:
        o.axis_if.stream.valid = 1
        o.axis_if.stream.data.eod[0] = 1
        for j in range(16):
            o.axis_if.stream.data.frag.data[j] = blocks[0].data[j]
            o.axis_if.stream.data.frag.keep[j] = 1
        if axis_if.ready:
            pop = 1

    remaining: count_t = count - pop
    incoming: block_t[2]
    push: count_t = 0
    nbytes = aead_keep_count(axis_in_if.stream.data.frag)
    if state == state_t.IDLE:
        if axis_in_if.stream.valid:
            sim_assert(aad_len <= AAD_MAX_LEN, "AAD exceeds supported size")
            aad_reg = aad
            aad_length = aad_len
            ct_length = 0
            if aad_len > 0:
                state = state_t.AAD_STATE
            else:
                state = state_t.CIPHERTEXT
    elif state == state_t.AAD_STATE:
        if remaining <= 2:
            push = 1
            if aad_length > 16:
                push = 2
            for j in range(16):
                incoming[0].data[j] = 0
                incoming[1].data[j] = 0
                if aad_length > j:
                    incoming[0].data[j] = aad_reg[j]
                if aad_length > j + 16:
                    incoming[1].data[j] = aad_reg[j + 16]
            state = state_t.CIPHERTEXT
    elif state == state_t.CIPHERTEXT:
        # Reserve room for both halves without depending on source valid.
        o.axis_in_if.ready = remaining <= 2
        if axis_in_if.stream.valid & o.axis_in_if.ready:
            sim_assert(nbytes > 0, "Empty ciphertext frame")
            sim_assert((nbytes == 32) | axis_in_if.stream.data.eod[0], "Partial nonfinal ciphertext beat")
            push = 1
            if nbytes > 16:
                push = 2
            for j in range(16):
                incoming[0].data[j] = 0
                incoming[1].data[j] = 0
                if axis_in_if.stream.data.frag.keep[j]:
                    incoming[0].data[j] = axis_in_if.stream.data.frag.data[j]
                if axis_in_if.stream.data.frag.keep[j + 16]:
                    incoming[1].data[j] = axis_in_if.stream.data.frag.data[j + 16]
            ct_length += nbytes
            if axis_in_if.stream.data.eod[0]:
                state = state_t.LENGTHS
    elif state == state_t.LENGTHS:
        if remaining < 4:
            push = 1
            for j in range(8):
                incoming[0].data[j] = aad_length >> (8 * j)
                incoming[0].data[j + 8] = ct_length >> (8 * j)
            incoming[0].last = 1
            state = state_t.DRAIN
    else:
        if remaining == 0:
            state = state_t.IDLE

    # Constant-index storage reads keep the queue cheap to synthesize.
    shifted: block_t[4]
    for k in range(4):
        shifted[k] = blocks[k]
        if pop == 2:
            if k < 2:
                shifted[k] = blocks[k + 2]
        elif pop == 1:
            if k < 3:
                shifted[k] = blocks[k + 1]
    for k in range(4):
        if (push > 0) & (remaining == k):
            shifted[k] = incoming[0]
        if (push == 2) & (remaining + 1 == k):
            shifted[k] = incoming[1]
        blocks[k] = shifted[k]
    count = remaining + push
    sim_assert(count <= 4, "Authentication formatter queue overflow")
    perf_taps.state("prep.fsm", state, tuple(state_t.__members__))
    perf_taps.hs("prep.axis_in", axis_in_if.stream.valid, o.axis_in_if.ready, axis_in_if.stream.data.frag.keep)
    perf_taps.hs("prep.axis_out", o.axis_if.stream.valid, axis_if.ready, o.axis_if.stream.data.frag.keep)
    return o
