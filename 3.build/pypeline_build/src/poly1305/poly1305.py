# pyright: reportInvalidTypeForm=none
"""Poly1305 MAC (RFC 8439) 320-bit limb math + the FSM that iterates the
per-block compute, plus poly1305_mac_instance (FSM + private multi-cycle-path
compute combined) which each dataflow core instantiates directly, once per
direction.

Pypeline port of ../pipelinec_build/src/poly1305/poly1305.h and poly1305_mac.c
-- with the limb math fixed to be RFC 8439-correct, deliberately diverging
from the C original, which (as of this writing) still has its historical bugs:
truncating 64x64 limb products in uint320_mul, and a uint320_mod_prime that
used a wrong below-2^130 mask (0x3FFFFFFFFFF instead of 0x3) and discarded
limbs 3/4 outright instead of folding them. The fixed math here matches a
big-integer Poly1305 reference and the official RFC 8439 test vectors (see
../chacha20poly1305/aead_ref_model.py, which validates the expected testbench
vectors against the `cryptography` package and the RFC 8439 2.8.2
known-answer test).
"""
import wireguard_env  # noqa: F401

from enum import auto

from pypeline import (
    NamedTuple,
    struct,
    enum,
    hw_func,
    Reg,
    Feedback,
    uint1_t,
    uint8_t,
    uint32_t,
    uint64_t,
    make_uint_t,
    concat,
    array_to_uint_le,
    uint_to_array_le,
    make_type_from_bytes,
)
from interface.interface import interface
from interface.interface_func import make_hw_func_from_interface_func
from stream.stream import make_stream_interface
from stream.stream_multi_cycle import make_stream_auto_multi_cycle

from stream import stream_perf_probe as perf_taps

from aead_types import (
    POLY1305_BLOCK_SIZE,
    POLY1305_KEY_SIZE,
    axis128_intrf,
    poly1305_key_stream_intrf,
    poly1305_auth_tag_stream_intrf,
)

from poly1305_math import (
    U320_NLIMBS, U320_NBYTES, uint320_t, uint128_t, u320_t,
    u320_stream_intrf, u320_null, u8_16_t, clamp, bytes_to_uint320,
    bytes16_to_uint320, uint320_add, uint320_mul, uint320_fold,
    uint320_mod_prime,
)


# Pass by value version of body part of per-block loop:
#   want in form: output_t func_name(input_t)
@struct
class poly1305_mac_loop_body_in_t(NamedTuple):
    block_bytes: uint8_t[POLY1305_BLOCK_SIZE]
    r: u320_t
    a: u320_t


poly1305_mac_loop_body_stream_intrf = make_stream_interface(poly1305_mac_loop_body_in_t)


def poly1305_mac_loop_body_in_null():
    return poly1305_mac_loop_body_in_t(
        block_bytes=[0] * POLY1305_BLOCK_SIZE, r=u320_null(), a=u320_null()
    )


@hw_func
def poly1305_mac_loop_body(inputs: poly1305_mac_loop_body_in_t) -> u320_t:
    n_bytes: uint8_t[U320_NBYTES] = [0] * U320_NBYTES
    for i in range(POLY1305_BLOCK_SIZE):
        n_bytes[i] = inputs.block_bytes[i]
    n: u320_t = bytes_to_uint320(n_bytes)

    # Set the high bit (2^128)
    n.limbs[2] = n.limbs[2] | 0x1

    # a += n
    a: u320_t = uint320_add(inputs.a, n)

    # a *= r
    temp: u320_t = a
    a = uint320_mul(temp, inputs.r)

    # a %= p
    a = uint320_mod_prime(a)

    return a


# FSM that uses compute iteratively to compute poly1305 MAC
@enum
class poly1305_state_t:
    # TODO can combine states for lower per block latency
    IDLE = auto()  # Wait for poly1305_key
    START_ITER = auto()  # Put data into compute
    FINISH_ITER = auto()  # Wait for data out of compute
    A_PLUS_S = auto()  # Add s to a final step before output
    OUTPUT_AUTH_TAG = auto()  # Output the auth tag


# Member names in declaration order, for the perf_taps state histogram: pypeline
# @enum with auto() numbers members 0..n-1 in exactly this order, so a state
# value indexes this tuple directly. Plain Python -- never elaborated.
POLY1305_STATE_NAMES = tuple(poly1305_state_t.__members__)


@struct
class poly1305_mac_fsm_t(NamedTuple):
    key_if: poly1305_key_stream_intrf.fb_t
    data_in_if: axis128_intrf.fb_t
    auth_tag_if: poly1305_auth_tag_stream_intrf.fwd_t
    to_compute_if: poly1305_mac_loop_body_stream_intrf.fwd_t
    from_compute_if: u320_stream_intrf.fb_t


@hw_func
def poly1305_mac_fsm(
    # Inputs
    key_if: poly1305_key_stream_intrf.fwd_t,
    data_in_if: axis128_intrf.fwd_t,
    auth_tag_if: poly1305_auth_tag_stream_intrf.fb_t,
    from_compute_if: u320_stream_intrf.fwd_t,
    to_compute_if: poly1305_mac_loop_body_stream_intrf.fb_t,
) -> poly1305_mac_fsm_t:
    o: poly1305_mac_fsm_t
    # The compute result is consumed the cycle it arrives (as before, when this
    # port had no ready at all).
    o.from_compute_if.ready = 1
    # Default not ready for incoming poly key
    o.key_if.ready = 0
    # Default not ready for incoming data
    o.data_in_if.ready = 0
    # Default not outputting an auth tag
    o.auth_tag_if.stream.data = 0
    o.auth_tag_if.stream.valid = 0
    # Default nothing into compute
    o.to_compute_if.stream.data = poly1305_mac_loop_body_in_null()
    o.to_compute_if.stream.valid = 0

    # The FSM
    state: Reg[poly1305_state_t]
    is_last_block: Reg[uint1_t]
    a: Reg[u320_t]
    r: Reg[u320_t]
    s: Reg[u320_t]

    # Perf probe (sim-only, elaborated away -- see stream/stream_perf_probe.py). Sampled
    # HERE, before the FSM body runs, because `state` reads back the NEXT state
    # once assigned: the trailing `if state == START_ITER` below deliberately
    # relies on that same-cycle readback, so a probe at the end of the body
    # would histogram next-states, not the state actually occupied this cycle.
    perf_taps.state("poly1305.fsm", state, POLY1305_STATE_NAMES)

    if state == poly1305_state_t.IDLE:
        # Reset state
        is_last_block = 0  # Not the last block yet
        u320_zero: u320_t = u320_null()
        a = u320_zero  # Initialize accumulator to 0
        r = u320_zero  # Initialize r to 0
        s = u320_zero  # Initialize s to 0
        # Wait for poly1305_key
        o.key_if.ready = 1
        if key_if.stream.valid & o.key_if.ready:
            key_bytes: uint8_t[POLY1305_KEY_SIZE] = uint_to_array_le(key_if.stream.data, 8)
            # Split key into r and s
            r_bytes: u8_16_t  # r part of the key
            s_bytes: u8_16_t  # s part of the key
            for i in range(POLY1305_KEY_SIZE // 2):
                r_bytes.bytes[i] = key_bytes[i]
                s_bytes.bytes[i] = key_bytes[i + 16]
            # Clamp r according to the spec
            r_bytes = clamp(r_bytes)
            # Convert r and s to u320_t and save in regs
            r = bytes16_to_uint320(r_bytes.bytes)
            s = bytes16_to_uint320(s_bytes.bytes)
            # Then start per block iterations
            state = poly1305_state_t.START_ITER
    elif state == poly1305_state_t.FINISH_ITER:
        # Wait for 'a' data out of compute
        if from_compute_if.stream.valid:
            a = from_compute_if.stream.data
            # if last block do final step
            if is_last_block:
                state = poly1305_state_t.A_PLUS_S
            else:
                # More blocks using 'a' next
                state = poly1305_state_t.START_ITER
    elif state == poly1305_state_t.A_PLUS_S:
        # a += s
        a = uint320_add(a, s)
        # Output a next
        state = poly1305_state_t.OUTPUT_AUTH_TAG
    elif state == poly1305_state_t.OUTPUT_AUTH_TAG:
        # First 16 bytes of 'a' are the output
        o.auth_tag_if.stream.data = concat(a.limbs[1], a.limbs[0])
        o.auth_tag_if.stream.valid = 1
        if o.auth_tag_if.stream.valid & auth_tag_if.ready:
            state = poly1305_state_t.IDLE

    # Same cycle transition from finish->start iter in one cycle
    # latency reduction = throughput increase in this case...
    if state == poly1305_state_t.START_ITER:
        # Ready to take an input data block
        o.data_in_if.ready = to_compute_if.ready
        # Put 'a' and data block into compute
        o.to_compute_if.stream.data.block_bytes = data_in_if.stream.data.frag.data
        o.to_compute_if.stream.data.a = a
        o.to_compute_if.stream.data.r = r
        o.to_compute_if.stream.valid = data_in_if.stream.valid & o.data_in_if.ready
        # Record if this is the last block
        is_last_block = data_in_if.stream.data.eod[0]
        # And then wait for the output once input into compute happens
        if o.to_compute_if.stream.valid & o.data_in_if.ready:
            state = poly1305_state_t.FINISH_ITER

    # Perf probes (sim-only, elaborated away -- see stream/stream_perf_probe.py). At the
    # end of the body so every o.* reverse/forward field below is final.
    #
    # `poly1305.data_in` is THE bottleneck measurement for this design:
    # o.data_in_if.ready is asserted only in START_ITER, and the compute MCP
    # (make_stream_auto_multi_cycle(..., start_latency=5), settled at 5) re-arms
    # every latency+1 = 6 cycles, so this
    # tap's service_period_cycles reads ~6.0 -- 16 B per 6 cycles = 2.667
    # B/cycle, against ChaCha20's II=1 stream pipeline at up to 16 B/cycle.
    perf_taps.hs(
        "poly1305.data_in",
        data_in_if.stream.valid,
        o.data_in_if.ready,
        data_in_if.stream.data.frag.keep,
    )
    perf_taps.hs("poly1305.key_in", key_if.stream.valid, o.key_if.ready)
    perf_taps.hs("poly1305.tag_out", o.auth_tag_if.stream.valid, auth_tag_if.ready)
    # Launch/retire edges of the multi-cycle compute itself: to_compute stalls
    # exactly while the MCP is still settling; from_compute never stalls
    # (o.from_compute_if.ready is hardwired 1 above), so it is a pure retire count.
    perf_taps.hs(
        "poly1305.to_compute", o.to_compute_if.stream.valid, to_compute_if.ready
    )
    perf_taps.hs("poly1305.from_compute", from_compute_if.stream.valid, 1)
    return o


# One full poly1305_mac instance: poly1305_mac_fsm plus its own private
# poly1305_mac_loop_body multi-cycle-path compute, combined into a single
# callable (replaces what used to be two MAINs -- an FSM and a compute
# instance -- joined by global wires). Meant to be called once per direction
# (encrypt, decrypt) from that direction's dataflow core; each call site gets
# its own independent compute + FSM hardware state.
#
# The multi-cycle count is automatic: the sweep raises it if the launch->capture
# path fails timing. The clock profile retains the historical starting guess
# of 5 at 80 MHz (4 failed); compute_mcp.mcp.latency reads the actual built count.
compute_mcp, _compute_mcp_t = make_stream_auto_multi_cycle(
    poly1305_mac_loop_body, start_latency=wireguard_env.START_LATENCIES["poly1305_legacy"]
)


@interface
class poly1305_mac_ports(NamedTuple):
    """The single output port of a poly1305_mac instance."""

    auth_tag_if: poly1305_auth_tag_stream_intrf


# An interface function: only the feedforward direction is written. The FSM and
# its private multi-cycle compute form a loop (the FSM consumes `from_compute_if`,
# which the compute -- called after it -- produces), so the generated wiring
# places a Feedback on the feedforward edge as well as the reverse edge --
# exactly the compute_out / compute_in_ready pair this used to thread by hand.
def poly1305_mac_instance_wiring(
    key_if: poly1305_key_stream_intrf,
    data_in_if: axis128_intrf,
) -> poly1305_mac_ports:
    fsm_out = poly1305_mac_fsm(
        key_if=key_if, data_in_if=data_in_if, from_compute_if=compute.stream_out_if
    )
    compute = compute_mcp(stream_in_if=fsm_out.to_compute_if)
    return poly1305_mac_ports(auth_tag_if=fsm_out.auth_tag_if)


# Fields: .key_if / .data_in_if (reverse halves of the input ports), .auth_tag_if
# (feedforward half of the output port).
poly1305_mac_instance, poly1305_mac_stream_out_t = make_hw_func_from_interface_func(
    poly1305_mac_instance_wiring
)
