# pyright: reportInvalidTypeForm=none
"""Poly1305 MAC (RFC 8439) 320-bit limb math + the FSM that iterates the
per-block compute.

Pypeline port of ../pipelinec_build/src/poly1305/poly1305.h (the per-instance
wire declarations + MCP compute instance live in poly1305_mac_encrypt.py /
poly1305_mac_decrypt.py, the C poly1305_mac.c equivalents).

The limb math is a bit-exact translation of the C: including the schoolbook
multiply's truncating 64x64 products (only addition carries propagate between
limbs, matching the reference software implementation this design validates
against).
"""
import pypeline_env  # noqa: F401

from enum import IntEnum

from pypeline import (
    NamedTuple,
    struct,
    enum,
    hw_func,
    Reg,
    uint1_t,
    uint8_t,
    uint32_t,
    uint64_t,
    make_uint_t,
    concat,
    array_to_uint_le,
    uint_to_array_le,
)
from stream.stream import make_stream_t

from aead_types import (
    POLY1305_BLOCK_SIZE,
    POLY1305_KEY_SIZE,
    axis128_t,
    poly1305_key_stream_t,
    poly1305_auth_tag_stream_t,
)

U320_NLIMBS = 5
U320_NBYTES = 40
uint320_t = make_uint_t(320)

# 2^130 - 1 mask for limbs[2] (bits above 2^130 within the third limb)
_MASK = 0x3FFFFFFFFFF
_NOT_MASK = (~_MASK) & 0xFFFFFFFFFFFFFFFF


# Structure to hold a 320-bit unsigned integer for Poly1305 calculations
@struct
class u320_t(NamedTuple):
    limbs: uint64_t[U320_NLIMBS]  # 64-bit limbs


u320_stream_t = make_stream_t(u320_t)


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


# Bytes to u320_t, little-endian per 64b limb (C bytes_to_u320_t built-in)
@hw_func
def bytes_to_uint320(src: uint8_t[U320_NBYTES]) -> u320_t:
    rv: u320_t
    for i in range(U320_NLIMBS):
        rv.limbs[i] = concat(
            src[i * 8 + 7],
            src[i * 8 + 6],
            src[i * 8 + 5],
            src[i * 8 + 4],
            src[i * 8 + 3],
            src[i * 8 + 2],
            src[i * 8 + 1],
            src[i * 8 + 0],
        )
    return rv


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


# Multiply two u320_t values (schoolbook, C-exact truncating 64x64 products)
@hw_func
def uint320_mul(a: u320_t, b: u320_t) -> u320_t:
    temp: u320_t = u320_null()

    # Schoolbook multiplication algorithm
    for i in range(U320_NLIMBS):
        carry: uint64_t = 0
        for j in range(U320_NLIMBS - i):
            product: uint64_t = a.limbs[i] * b.limbs[j]
            old_value: uint64_t = temp.limbs[i + j]

            # Add previous value and carry
            low: uint64_t = product + old_value
            high: uint64_t = low < product
            low = low + carry
            high = high + (low < carry)

            temp.limbs[i + j] = low
            carry = high

    res: u320_t = temp
    return res


# Reduce a u320_t modulo 2^130 - 5
@hw_func
def uint320_mod_prime(a: u320_t) -> u320_t:
    v: u320_t = a
    # First, handle the high bits (greater than or equal to 2^130)
    high_bits: uint64_t = v.limbs[2] & _NOT_MASK
    if high_bits or v.limbs[3] or v.limbs[4]:
        # We have bits above 2^130, need to reduce

        # Clear high bits
        v.limbs[2] = v.limbs[2] & _MASK
        v.limbs[3] = 0
        v.limbs[4] = 0

        # Multiply high bits by 5 and add to low bits
        mul5: u320_t = u320_null()
        mul5.limbs[0] = (high_bits >> 2) * 5

        # Add to original value
        v = uint320_add(v, mul5)

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


poly1305_mac_loop_body_stream_t = make_stream_t(poly1305_mac_loop_body_in_t)


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
class poly1305_state_t(IntEnum):
    # TODO can combine states for lower per block latency
    IDLE = 0  # Wait for poly1305_key
    START_ITER = 1  # Put data into compute
    FINISH_ITER = 2  # Wait for data out of compute
    A_PLUS_S = 3  # Add s to a final step before output
    OUTPUT_AUTH_TAG = 4  # Output the auth tag


@struct
class poly1305_mac_fsm_t(NamedTuple):
    ready_for_key: uint1_t
    ready_for_data_in: uint1_t
    auth_tag: poly1305_auth_tag_stream_t
    to_compute: poly1305_mac_loop_body_in_t
    to_compute_valid: uint1_t


@hw_func
def poly1305_mac_fsm(
    # Inputs
    key: poly1305_key_stream_t,
    data_in: axis128_t,
    ready_for_auth_tag_out: uint1_t,
    from_compute: u320_t,
    from_compute_valid: uint1_t,
    ready_for_to_compute: uint1_t,
) -> poly1305_mac_fsm_t:
    o: poly1305_mac_fsm_t
    # Default not ready for incoming poly key
    o.ready_for_key = 0
    # Default not ready for incoming data
    o.ready_for_data_in = 0
    # Default not outputting an auth tag
    o.auth_tag.data = 0
    o.auth_tag.valid = 0
    # Default nothing into compute
    compute_null_inputs: poly1305_mac_loop_body_in_t = poly1305_mac_loop_body_in_null()
    o.to_compute = compute_null_inputs
    o.to_compute_valid = 0

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
        o.ready_for_key = 1
        if key.valid & o.ready_for_key:
            key_bytes: uint8_t[POLY1305_KEY_SIZE] = uint_to_array_le(key.data, 8)
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
        if from_compute_valid:
            a = from_compute
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
        o.auth_tag.data = concat(a.limbs[1], a.limbs[0])
        o.auth_tag.valid = 1
        if o.auth_tag.valid & ready_for_auth_tag_out:
            state = poly1305_state_t.IDLE

    # Same cycle transition from finish->start iter in one cycle
    # latency reduction = throughput increase in this case...
    if state == poly1305_state_t.START_ITER:
        # Ready to take an input data block
        o.ready_for_data_in = ready_for_to_compute
        # Put 'a' and data block into compute
        o.to_compute.block_bytes = data_in.data.frag.data
        o.to_compute.a = a
        o.to_compute.r = r
        o.to_compute_valid = data_in.valid & o.ready_for_data_in
        # Record if this is the last block
        is_last_block = data_in.data.eod[0]
        # And then wait for the output once input into compute happens
        if o.to_compute_valid & o.ready_for_data_in:
            state = poly1305_state_t.FINISH_ITER
    return o
