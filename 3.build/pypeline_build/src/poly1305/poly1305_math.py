# pyright: reportInvalidTypeForm=none
"""Shared Poly1305 arithmetic, independent of either MAC controller.

Residues are canonical modulo 2**130-5. Multiplication returns the low 320
bits; all MAC products are at most 260 bits and therefore fit exactly.
"""
import wireguard_env  # noqa: F401

from pypeline import (
    NamedTuple, struct, hw_func, uint8_t, uint64_t, make_uint_t,
    array_to_uint_le, make_type_from_bytes, register_operator,
)
from stream.stream import make_stream_interface

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

        v.limbs[2] = v.limbs[2] - 3 - borrow
        v.limbs[2] = v.limbs[2] & _MASK  # Ensure top bits are zero
    return v


# The interleaved MAC transports canonical residues, not arbitrary 320-bit
# integers. Make those bounds part of its hardware types, including MCP
# launch/capture registers, so synthesis cannot retain 320x320 multipliers.
# The legacy datapath above intentionally keeps its original limb arithmetic.
uint130_t = make_uint_t(130)
uint131_t = make_uint_t(131)
uint133_t = make_uint_t(133)
uint260_t = make_uint_t(260)
uint3_t = make_uint_t(3)
POLY1305_P = (1 << 130) - 5

# Exact-type registration reaches both modular multiply helpers while leaving
# legacy 64-bit limbs and the reducer's constant products unchanged. Ordinary
# module-level hw_func scope= does not currently affect HDL elaboration.
# The library's pinned inferred leaves prevent recursive operator dispatch.
if wireguard_env.POLY1305_MULT_IMPL in ("hybrid", "hybrid_square"):
    from operators.soft_mult import make_mult_karatsuba_inferred_leaves
    register_operator("INFERRED_MULT", uint130_t, uint130_t,
                      make_mult_karatsuba_inferred_leaves(uint130_t, uint130_t, threshold=34))


@hw_func
def uint260_mod_prime(value: uint260_t) -> uint130_t:
    """Exact reduction for every 260-bit input, with explicit carry widths."""
    low: uint130_t = value
    high: uint130_t = value >> 130
    # < 6*2^130, so the remaining quotient fits three bits (at most 5).
    folded: uint133_t = low + high * 5
    low_again: uint130_t = folded
    high_again: uint3_t = folded >> 130
    # <= 2^130+24 < 2*p: one full-width subtraction canonicalizes it.
    reduced: uint131_t = low_again + high_again * 5
    if reduced >= POLY1305_P:
        reduced -= POLY1305_P
    result: uint130_t = reduced
    return result


@hw_func
def residue_mul_mod(a: uint130_t, b: uint130_t) -> uint130_t:
    product: uint260_t = a * b
    return uint260_mod_prime(product)


def make_hybrid_square(width):
    """Unsigned full square: Karatsuba above 34 bits, three DSP-sized products below.

    This is a local experiment, independent of the library's multiplier defaults.
    Every shift acts on an already widened value. Only the final recombination
    is narrowed to the exact 2*width-bit result.
    """
    from operators.soft_mult import make_inferred_mult
    if not isinstance(width, int) or width < 1:
        raise ValueError("square width must be a positive integer")
    input_t = make_uint_t(width)
    result_t = make_uint_t(2 * width)
    if width <= 17:
        multiply = make_inferred_mult(input_t, input_t)

        @hw_func
        def inferred_square(x: input_t) -> result_t:
            return multiply(x, x)
        return inferred_square

    half = width // 2
    lo_t = make_uint_t(half)
    hi_t = make_uint_t(width - half)
    if width <= 34:
        multiply_lo = make_inferred_mult(lo_t, lo_t)
        multiply_hi = make_inferred_mult(hi_t, hi_t)
        multiply_cross = make_inferred_mult(lo_t, hi_t)

        @hw_func
        def three_product_square(x: input_t) -> result_t:
            lo: lo_t = x
            hi: hi_t = x >> half
            z0: result_t = multiply_lo(lo, lo)
            z2: result_t = multiply_hi(hi, hi)
            cross: result_t = multiply_cross(lo, hi)
            result: result_t = z0 + (cross << (half + 1)) + (z2 << (2 * half))
            return result
        return three_product_square

    sum_t = make_uint_t(width - half + 1)
    square_lo = make_hybrid_square(half)
    square_hi = make_hybrid_square(width - half)
    square_sum = make_hybrid_square(width - half + 1)

    @hw_func
    def karatsuba_square(x: input_t) -> result_t:
        lo: lo_t = x
        hi: hi_t = x >> half
        total: sum_t = lo + hi
        z0: result_t = square_lo(lo)
        z2: result_t = square_hi(hi)
        zs: result_t = square_sum(total)
        cross: result_t = zs - z0 - z2
        result: result_t = z0 + (cross << half) + (z2 << (2 * half))
        return result
    return karatsuba_square


square130 = make_hybrid_square(130)


@hw_func
def residue_square_mod(a: uint130_t) -> uint130_t:
    product: uint260_t = square130(a)
    return uint260_mod_prime(product)


@hw_func
def residue_mul_add_mod(a: uint130_t, b: uint130_t, c: uint130_t) -> uint130_t:
    product: uint260_t = a * b
    # Even for all-ones 130-bit operands, a*b+c is strictly below 2^260.
    value: uint260_t = product + c
    return uint260_mod_prime(value)


@hw_func
def residue_add_mod(a: uint130_t, b: uint130_t) -> uint130_t:
    value: uint131_t = a + b
    low: uint130_t = value
    high: uint3_t = value >> 130
    folded: uint131_t = low + high * 5
    if folded >= POLY1305_P:
        folded -= POLY1305_P
    result: uint130_t = folded
    return result
