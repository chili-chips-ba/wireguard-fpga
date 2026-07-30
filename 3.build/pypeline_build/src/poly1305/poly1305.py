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
from multi_cycle_path import make_valid_ready_mcp

from aead_types import (
    POLY1305_BLOCK_SIZE,
    POLY1305_KEY_SIZE,
    axis128_intrf,
    poly1305_key_stream_intrf,
    poly1305_auth_tag_stream_intrf,
)

U320_NLIMBS = 5
U320_NBYTES = 40
uint320_t = make_uint_t(320)
uint128_t = make_uint_t(128)

# 2^130 is bit 2 of limb 2, so within limb 2 the bits below 2^130 are just
# the low two
_MASK = 0x3


# Structure to hold a 320-bit unsigned integer for Poly1305 calculations
@struct
class u320_t(NamedTuple):
    limbs: uint64_t[U320_NLIMBS]  # 64-bit limbs


u320_stream_intrf = make_stream_interface(u320_t)


def u320_null():
    return u320_t(limbs=[0] * U320_NLIMBS)


# 16-byte array wrapper for the r/s key halves
@struct
class u8_16_t(NamedTuple):
    bytes: uint8_t[16]


# Apply clamping to the 'r' part of the key
@hw_func
def clamp(r: u8_16_t) -> u8_16_t:
    o: u8_16_t = r
    o.bytes[3] = o.bytes[3] & 15
    o.bytes[7] = o.bytes[7] & 15
    o.bytes[11] = o.bytes[11] & 15
    o.bytes[15] = o.bytes[15] & 15
    o.bytes[4] = o.bytes[4] & 252
    o.bytes[8] = o.bytes[8] & 252
    o.bytes[12] = o.bytes[12] & 252
    return o


# Bytes to u320_t, little-endian per 64b limb.
bytes_to_uint320 = make_type_from_bytes(u320_t)


# 16-byte (zero-extended) variant used for the r/s key halves.
# (The C passes 16-byte arrays to the 40-byte bytes_to_uint320 parameter and
# relies on implicit zero-fill; here the zero-extension is explicit.)
@hw_func
def bytes16_to_uint320(src: uint8_t[16]) -> u320_t:
    padded: uint8_t[U320_NBYTES] = [0] * U320_NBYTES
    for i in range(16):
        padded[i] = src[i]
    rv: u320_t = bytes_to_uint320(padded)
    return rv


# Add two u320_t values (PipelineC built-in uint320_t + uint320_t)
@hw_func
def uint320_add(a: u320_t, b: u320_t) -> u320_t:
    a_uint: uint320_t = array_to_uint_le(a.limbs)
    b_uint: uint320_t = array_to_uint_le(b.limbs)
    rv_uint: uint320_t = a_uint + b_uint
    rv: u320_t
    for i in range(U320_NLIMBS):
        rv.limbs[i] = rv_uint >> (i * 64)
    return rv


# Multiply two u320_t values (schoolbook, result truncated to 320 bits)
@hw_func
def uint320_mul(a: u320_t, b: u320_t) -> u320_t:
    temp: u320_t = u320_null()

    # Schoolbook multiplication: each 64x64 limb-pair product is a full
    # 128-bit value whose low half accumulates into limb i+j and whose high
    # half carries into limb i+j+1 (via `carry` on the next j iteration).
    # acc's three terms sum to at most 2^128 - 1, so uint128_t holds the
    # accumulation exactly.
    for i in range(U320_NLIMBS):
        carry: uint64_t = 0
        for j in range(U320_NLIMBS - i):
            acc: uint128_t = (a.limbs[i] * b.limbs[j]) + temp.limbs[i + j] + carry
            temp.limbs[i + j] = acc  # low 64 bits
            carry = acc >> 64  # high 64 bits

    res: u320_t = temp
    return res


# One partial-reduction pass folding the bits at/above 2^130 back into the
# low bits: x = q*2^130 + rem  =>  x == rem + 5*q (mod 2^130 - 5)
@hw_func
def uint320_fold(v: u320_t) -> u320_t:
    # rem = v mod 2^130
    rem: u320_t = v
    rem.limbs[2] = v.limbs[2] & _MASK
    rem.limbs[3] = 0
    rem.limbs[4] = 0
    # q = v >> 130 (fits in 3 limbs)
    q0: uint64_t = (v.limbs[2] >> 2) | (v.limbs[3] << 62)
    q1: uint64_t = (v.limbs[3] >> 2) | (v.limbs[4] << 62)
    q2: uint64_t = v.limbs[4] >> 2
    # mul5 = 5*q, carrying between limbs (each q_i*5 is up to 67 bits)
    mul5: u320_t = u320_null()
    p: uint128_t = q0 * 5
    mul5.limbs[0] = p
    p = (q1 * 5) + (p >> 64)
    mul5.limbs[1] = p
    p = (q2 * 5) + (p >> 64)
    mul5.limbs[2] = p
    mul5.limbs[3] = p >> 64
    rv: u320_t = uint320_add(rem, mul5)
    return rv


# Reduce a u320_t modulo 2^130 - 5 (full reduction, any 320-bit input)
@hw_func
def uint320_mod_prime(a: u320_t) -> u320_t:
    # Three folds bring any 320-bit value strictly below 2^130:
    #   320 bits -> < 2^193 -> < 2^130 + 2^66 -> < 2^130
    v: u320_t = uint320_fold(a)
    v = uint320_fold(v)
    v = uint320_fold(v)

    # Check if result is still >= 2^130 - 5
    if (
        ((v.limbs[2] & _MASK) == _MASK)
        and (v.limbs[1] == 0xFFFFFFFFFFFFFFFF)
        and (v.limbs[0] >= 0xFFFFFFFFFFFFFFFB)
    ):
        # Subtract 2^130 - 5
        diff: uint64_t = v.limbs[0] - 0xFFFFFFFFFFFFFFFB
        borrow: uint64_t = diff > v.limbs[0]
        v.limbs[0] = diff

        diff = v.limbs[1] - 0xFFFFFFFFFFFFFFFF - borrow
        borrow = (diff > v.limbs[1]) | ((diff == v.limbs[1]) & borrow)
        v.limbs[1] = diff

        v.limbs[2] = v.limbs[2] - borrow
        v.limbs[2] = v.limbs[2] & _MASK  # Ensure top bits are zero
    return v


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
    return o


# One full poly1305_mac instance: poly1305_mac_fsm plus its own private
# poly1305_mac_loop_body multi-cycle-path compute, combined into a single
# callable (replaces what used to be two MAINs -- an FSM and a compute
# instance -- joined by global wires). Meant to be called once per direction
# (encrypt, decrypt) from that direction's dataflow core; each call site gets
# its own independent compute + FSM hardware state.
compute_mcp, _compute_mcp_t = make_valid_ready_mcp(poly1305_mac_loop_body, 5)


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
