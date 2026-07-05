# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Pure-Python (no pypeline/hardware dependency) ChaCha20-Poly1305 reference
model used to generate test vectors for the encrypt/decrypt testbenches on the
fly, instead of hardcoding them.

Deliberately reproduces the *current* chacha20poly1305 hardware design's
behavior, which deviates from RFC 8439 in two ways (see chacha20poly1305/
encrypt_tb.py, chacha20/chacha20.py, prep_auth_data/prep_auth_data.py,
poly1305/poly1305.py for the hardware side of each):

1. Ciphertext length is rounded up to the next 16-byte boundary, not exactly
   len(plaintext): the testbench's input AXI-stream always marks all 16 lanes
   of the final beat "kept" even when only part of it is real plaintext, and
   chacha20_loop_body always XORs the full 64-byte block regardless of keep
   (marked with a "# TODO partial in data, i.e. partial tkeep" comment in
   chacha20.py). The zero-padding bytes therefore get encrypted and appended
   to the ciphertext output as if they were real plaintext.
2. The Poly1305 MAC's ciphertext-length field authenticates that same
   rounded-up length (prep_auth_data.py's byte counter sums keep-bits, which
   are always "all kept" per #1), not the true plaintext length. AAD framing
   is unaffected: it's zero-padded to 16 bytes for the MAC as RFC 8439
   requires, and its length field uses the true (unpadded) aad_len.

A future task may fix the hardware to conform to RFC 8439 (exact-length
ciphertext, true-length MAC accounting) -- when that happens, only
generate_encrypt_vector()'s framing below needs to change to match.

Separately, poly1305.py's own 320-bit multiply is *itself* non-standard: it
truncates each 64x64-bit limb product to 64 bits (dropping the high word,
propagating only addition-overflow carries) rather than doing an exact
arbitrary-precision multiply -- see poly1305.py's uint320_mul docstring,
which says this is "a bit-exact translation of the C: including the
schoolbook multiply's truncating 64x64 products (only addition carries
propagate between limbs, matching the reference software implementation
this design validates against)". A standard/RFC-8439-correct Poly1305 will
NOT reproduce this design's auth tags. The uint320_* functions below are a
from-scratch (no hardware-code dependency) transcription of that same
truncating math, careful to mask every intermediate value to 64 bits exactly
where the hardware's uint64_t type would -- including the one easy-to-miss
overflow point in uint320_mod_prime's `(high_bits >> 2) * 5` step, which can
itself exceed 64 bits.
"""

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms

MASK64 = (1 << 64) - 1
NLIMBS = 5
# 2^130 - 1 mask for limbs[2] (bits above 2^130 within the third limb)
_MASK = 0x3FFFFFFFFFF
_NOT_MASK = (~_MASK) & MASK64


def chacha20_keystream(key: bytes, nonce: bytes, counter: int, nbytes: int) -> bytes:
    """One or more IETF ChaCha20 keystream blocks (RFC 8439): 32-byte key,
    12-byte nonce, 4-byte little-endian counter prefixed onto the nonce."""
    full_nonce = counter.to_bytes(4, "little") + nonce
    c = Cipher(algorithms.ChaCha20(key, full_nonce), mode=None, backend=default_backend())
    return c.encryptor().update(b"\x00" * nbytes)


def chacha20_keystream_xor(key: bytes, nonce: bytes, counter0: int, data: bytes) -> bytes:
    """XOR data (a multiple of 64 bytes) against the keystream starting at
    counter0, incrementing the counter once per 64-byte block."""
    out = bytearray()
    for i in range(0, len(data), 64):
        ks = chacha20_keystream(key, nonce, counter0 + i // 64, 64)
        chunk = data[i : i + 64]
        out += bytes(a ^ b for a, b in zip(chunk, ks))
    return bytes(out)


def pad16(data: bytes) -> bytes:
    return data + b"\x00" * ((-len(data)) % 16)


def _u320_from_bytes_le(b40: bytes):
    return [int.from_bytes(b40[i * 8 : (i + 1) * 8], "little") for i in range(NLIMBS)]


def uint320_add(a, b):
    out = [0] * NLIMBS
    carry = 0
    for i in range(NLIMBS):
        s = a[i] + b[i] + carry
        out[i] = s & MASK64
        carry = s >> 64
    return out


def uint320_mul(a, b):
    """Schoolbook multiply -- NOT a full 320-bit multiply. Each 64x64-bit
    limb product is truncated to its low 64 bits (only addition-overflow
    carries propagate between limbs), matching poly1305.py's uint320_mul."""
    temp = [0] * NLIMBS
    for i in range(NLIMBS):
        carry = 0
        for j in range(NLIMBS - i):
            product = (a[i] * b[j]) & MASK64
            old_value = temp[i + j]
            low = (product + old_value) & MASK64
            high = 1 if low < product else 0
            low = (low + carry) & MASK64
            high = high + (1 if low < carry else 0)
            temp[i + j] = low
            carry = high
    return temp


def uint320_mod_prime(v):
    """Reduce modulo 2^130 - 5, matching poly1305.py's uint320_mod_prime."""
    v = list(v)
    high_bits = v[2] & _NOT_MASK
    if high_bits or v[3] or v[4]:
        v[2] = v[2] & _MASK
        v[3] = 0
        v[4] = 0
        mul5 = [0] * NLIMBS
        # uint64_t assignment in hardware -- must truncate mod 2^64 here too.
        mul5[0] = ((high_bits >> 2) * 5) & MASK64
        v = uint320_add(v, mul5)
    if (v[2] & _MASK) == _MASK and v[1] == MASK64 and v[0] >= 0xFFFFFFFFFFFFFFFB:
        diff = (v[0] - 0xFFFFFFFFFFFFFFFB) & MASK64
        borrow = 1 if diff > v[0] else 0
        v[0] = diff
        diff2 = (v[1] - 0xFFFFFFFFFFFFFFFF - borrow) & MASK64
        borrow2 = 1 if (diff2 > v[1]) or (diff2 == v[1] and borrow) else 0
        v[1] = diff2
        v[2] = (v[2] - borrow2) & _MASK
    return v


def _clamp_r(r_bytes16: bytes) -> bytes:
    r = bytearray(r_bytes16)
    r[3] &= 15
    r[7] &= 15
    r[11] &= 15
    r[15] &= 15
    r[4] &= 252
    r[8] &= 252
    r[12] &= 252
    return bytes(r)


def _bytes16_to_u320(b16: bytes):
    return _u320_from_bytes_le(b16 + b"\x00" * 24)


def poly1305_mac(msg: bytes, key32: bytes) -> bytes:
    """msg must already be a multiple of 16 bytes -- this design's Poly1305
    primitives always operate on full, pre-padded blocks (every block always
    gets the bit-128 marker set, never a genuinely-partial final block)."""
    assert len(msg) % 16 == 0
    r = _bytes16_to_u320(_clamp_r(key32[0:16]))
    s = _bytes16_to_u320(key32[16:32])
    a = [0] * NLIMBS
    for i in range(0, len(msg), 16):
        block = msg[i : i + 16]
        n = _u320_from_bytes_le(block + b"\x00" * 24)
        n[2] |= 0x1
        a = uint320_add(a, n)
        a = uint320_mul(a, r)
        a = uint320_mod_prime(a)
    a = uint320_add(a, s)
    tag_int = a[0] | (a[1] << 64)
    return tag_int.to_bytes(16, "little")


def generate_encrypt_vector(key: bytes, nonce: bytes, aad: bytes, plaintext: bytes):
    """Returns (ciphertext_plus_tag, ciphertext_plus_tag_len), matching the
    current hardware's rounded-up-to-16-bytes ciphertext length (see module
    docstring) rather than RFC 8439's exact-length ciphertext."""
    padded_len = -(-len(plaintext) // 16) * 16  # round up to next multiple of 16
    plaintext_padded = plaintext + b"\x00" * (padded_len - len(plaintext))

    poly_key = chacha20_keystream(key, nonce, 0, 64)[:32]
    ciphertext = chacha20_keystream_xor(key, nonce, 1, plaintext_padded)

    mac_data = (
        pad16(aad)
        + ciphertext  # already 16-byte aligned, no further padding needed
        + len(aad).to_bytes(8, "little")
        + padded_len.to_bytes(8, "little")
    )
    tag = poly1305_mac(mac_data, poly_key)

    return ciphertext + tag, padded_len + len(tag)
