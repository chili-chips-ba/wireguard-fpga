# pyright: reportInvalidTypeForm=none
"""Shared types and sizes for the ChaCha20-Poly1305 AEAD designs.

One home for every cross-module type so all modules reference identical type
objects (struct C-names are canonical-by-shape anyway, but centralizing keeps
the design readable). Matches the C #defines in
../pipelinec_build/src/{chacha20/chacha20.h,poly1305/poly1305.h,prep_auth_data/prep_auth_data.h}.
"""
import pypeline_env  # noqa: F401

from pypeline import uint1_t, uint8_t, make_uint_t
from kept_data_bus import make_kept_data_bus_t
from ndarray import make_ndarray_fragment_t
from stream.stream import make_stream_t
from axi.axis import make_keep_count

# ChaCha20 sizes
CHACHA20_STATE_NWORDS = 16
CHACHA20_KEY_SIZE = 32
CHACHA20_NONCE_SIZE = 12
CHACHA20_BLOCK_SIZE = 64

# Poly1305 sizes
POLY1305_BLOCK_SIZE = 16
POLY1305_KEY_SIZE = 32
POLY1305_AUTH_TAG_SIZE = 16

# Additional authenticated data
AAD_MAX_LEN = 32

# Wide scalar types
uint96_t = make_uint_t(96)
uint128_t = make_uint_t(128)
uint256_t = make_uint_t(256)
key_uint_t = uint256_t
nonce_uint_t = uint96_t
aad_uint_t = uint256_t
poly1305_key_uint_t = uint256_t
poly1305_auth_tag_uint_t = uint128_t

# 128b AXIS bus: 16 byte lanes (C axis128_t / stream(axis128_t))
axis128_bus_t = make_kept_data_bus_t(uint8_t, 16)
axis128_frag_t = make_ndarray_fragment_t(axis128_bus_t, 1)  # C axis128_t
axis128_t = make_stream_t(axis128_frag_t)  # C stream(axis128_t)

# 512b AXIS bus: 64 byte lanes (C axis512_t / stream(axis512_t))
axis512_bus_t = make_kept_data_bus_t(uint8_t, 64)
axis512_frag_t = make_ndarray_fragment_t(axis512_bus_t, 1)  # C axis512_t
axis512_t = make_stream_t(axis512_frag_t)  # C stream(axis512_t)

# Scalar streams (C DECL_STREAM_TYPE(...))
poly1305_key_stream_t = make_stream_t(poly1305_key_uint_t)
poly1305_auth_tag_stream_t = make_stream_t(poly1305_auth_tag_uint_t)
uint1_stream_t = make_stream_t(uint1_t)

# C axis128_keep_count
axis128_keep_count = make_keep_count(axis128_bus_t, 16)


# Zero-valued compound-init helpers (C `... = {0}` initializers).
# Plain Python functions returning NamedTuples of ints — usable as
# elaboration-time compound initializers and in simulation.
def axis128_frag_null():
    return axis128_frag_t(
        frag=axis128_bus_t(data=[0] * 16, keep=[0] * 16), eod=[0]
    )


def axis128_null():
    return axis128_t(data=axis128_frag_null(), valid=0)


def axis512_frag_null():
    return axis512_frag_t(
        frag=axis512_bus_t(data=[0] * 64, keep=[0] * 64), eod=[0]
    )


def axis512_null():
    return axis512_t(data=axis512_frag_null(), valid=0)


def poly1305_key_stream_null():
    return poly1305_key_stream_t(data=0, valid=0)


def poly1305_auth_tag_stream_null():
    return poly1305_auth_tag_stream_t(data=0, valid=0)


def uint1_stream_null():
    return uint1_stream_t(data=0, valid=0)
