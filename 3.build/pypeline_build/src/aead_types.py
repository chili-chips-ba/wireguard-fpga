# pyright: reportInvalidTypeForm=none
"""Shared types and sizes for the ChaCha20-Poly1305 AEAD designs.

One home for every cross-module type so all modules reference identical type
objects (struct C-names are canonical-by-shape anyway, but centralizing keeps
the design readable). Matches the C #defines in
../pipelinec_build/src/{chacha20/chacha20.h,poly1305/poly1305.h,prep_auth_data/prep_auth_data.h}.
"""
import wireguard_env  # noqa: F401

from copy import deepcopy

from pypeline import uint1_t, uint8_t, make_uint_t
from kept_data_bus import make_kept_data_bus_t
from ndarray import make_ndarray_fragment_t
from stream.stream import make_stream_interface
from axi.axis import make_keep_count, make_count_to_keep, make_axis_broadcast_interlock
from stream.stream_perf_probe import make_probed_stream_fifo, make_probed_skid_buffer

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

# Axis beat size used by the fork, FIFO and ChaCha width converters.
AXIS128_BEAT_BYTES = 16

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
axis128_bus_t = make_kept_data_bus_t(uint8_t, AXIS128_BEAT_BYTES)
axis128_frag_t = make_ndarray_fragment_t(axis128_bus_t, 1)  # C axis128_t
axis128_intrf = make_stream_interface(axis128_frag_t)  # C stream(axis128_t)

# 512b AXIS bus: 64 byte lanes (C axis512_t / stream(axis512_t))
axis512_bus_t = make_kept_data_bus_t(uint8_t, 64)
axis512_frag_t = make_ndarray_fragment_t(axis512_bus_t, 1)  # C axis512_t
axis512_intrf = make_stream_interface(axis512_frag_t)  # C stream(axis512_t)

# Scalar streams (C DECL_STREAM_TYPE(...))
poly1305_key_stream_intrf = make_stream_interface(poly1305_key_uint_t)
poly1305_auth_tag_stream_intrf = make_stream_interface(poly1305_auth_tag_uint_t)
uint1_stream_intrf = make_stream_interface(uint1_t)

# C axis128_keep_count
axis128_keep_count = make_keep_count(axis128_bus_t, 16)
axis128_keep_count_t = make_uint_t((16).bit_length())  # matches make_keep_count's count_t

# Inverse of axis128_keep_count: lane count -> thermometer-coded keep[16]
# (lanes [0, count) asserted). Used by append_auth_tag/strip_auth_tag to
# derive tkeep for the auth-tag beats of a Xilinx-style packed ct||tag frame
# (issue #44 -- no mid-packet null bytes).
axis128_count_to_keep = make_count_to_keep(16)

# Combinational 2-way broadcast/fork of an axis128 stream (shared by the
# encrypt/decrypt dataflows' ciphertext-stream forks). `axis_out` is an array
# interface port: two independently back-pressured copies of the input.
axis128_2broadcast, axis128_2broadcast_t = make_axis_broadcast_interlock(axis128_intrf, 2)


# Plain elaboration metadata, populated only for FIFOs actually instantiated.
_buffering = {}
_stream_slices = {}


def decrypt_auth_fifo_sizing(chacha_func, mac_func):
    """Conservative authentication-fork storage, in 128-bit beats.

    Until the MAC takes the next key, ChaCha cannot retire that packet's
    payload. All accepted ciphertext is therefore bounded by its pipeline
    credits, widening storage, and the fork's one-copy lead. After key
    acceptance add the bounded prologue/framing interval: ingress accepts at
    most one beat per cycle. Once ciphertext framing starts, the II=1 MAC
    keeps pace. Body drain/epilogue waits are behind the next-key barrier.

    This uses the selected instances' resolved metadata, never starting
    hints. Shared prologues allow one preceding peer transaction; both MACs
    consume prologue responses promptly. External stalls use backpressure.
    """
    pipeline = getattr(chacha_func, "pipeline_func", None)
    if pipeline is None:
        raise ValueError("Automatic decrypt FIFO sizing requires chacha_func.pipeline_func")
    if not hasattr(pipeline, "auto_pipeline") or not hasattr(pipeline, "max_in_flight"):
        raise RuntimeError(
            "PipelineC prerequisite missing: make_stream_auto_pipeline must expose "
            ".auto_pipeline and .max_in_flight; update the PipelineC checkout "
            "(see PIPELINEC_PLAN.md) or supply an explicit auth_fifo_depth"
        )
    core_latency = pipeline.auto_pipeline.latency
    credits = pipeline.max_in_flight
    prologue_latency = mac_func.prologue_mcp.mcp.latency
    shared_mcps = bool(mac_func.shared_mcps)
    block_beats = CHACHA20_BLOCK_SIZE // AXIS128_BEAT_BYTES
    aad_beats = (AAD_MAX_LEN + AXIS128_BEAT_BYTES - 1) // AXIS128_BEAT_BYTES
    terms = {
        "pipeline_credits": block_beats * credits,
        "widening_storage": block_beats + 1,
        "fork_copy_lead": 1,
        "fifo_startup": 2,
        "framing_idle": 1,
        "prologue_service": (1 + int(shared_mcps)) * (prologue_latency + 1),
        "mac_transitions": 2,
        "aad_framing": aad_beats,
    }
    required = sum(terms.values())
    return {
        "method": "chacha-credit-bound-v1",
        "chacha20_core_latency": core_latency,
        "chacha20_max_in_flight_blocks": credits,
        "chacha20_block_beats": block_beats,
        "prologue_mcp_latency": prologue_latency,
        "shared_mcps": shared_mcps,
        "max_aad_beats": aad_beats,
        "terms_beats": terms,
        "required_beats": required,
        "memory_depth_beats": 1 << (max(2, required) - 1).bit_length(),
    }


def make_aead_fifo(data_t, depth, tap_name, direction, *, sizing=None):
    """Stream FIFO with simulation-only handshake/occupancy probes."""
    fifo, _ = make_probed_stream_fifo(data_t, depth, tap_name)
    _buffering[direction + "/" + tap_name] = {
        "requested_memory_depth_beats": depth,
        "memory_depth_beats": fifo.capacity_beats - 1,
        "capacity_beats": fifo.capacity_beats,
        "output_register_beats": 1,
    }
    if sizing is not None:
        _buffering[direction + "/" + tap_name]["sizing"] = deepcopy(sizing)
    return fifo


def buffering_metadata():
    return deepcopy(_buffering)


def make_aead_output_slice(intrf, tap_name, direction):
    """Two-slot output register slice; II=1 and stable valid under stalls."""
    skid, _ = make_probed_skid_buffer(intrf, tap_name, mode="full")
    _stream_slices[direction + "/" + tap_name] = {
        "mode": skid.mode, "capacity_beats": skid.capacity_beats,
        "latency_cycles": skid.latency,
    }
    return skid


def stream_slice_metadata():
    return {name: dict(values) for name, values in _stream_slices.items()}


# Zero-valued compound-init helpers (C `... = {0}` initializers).
# Plain Python functions returning NamedTuples of ints — usable as
# elaboration-time compound initializers and in simulation.
def axis128_frag_null():
    return axis128_frag_t(
        frag=axis128_bus_t(data=[0] * 16, keep=[0] * 16), eod=[0]
    )


def axis128_stream_null():
    return axis128_intrf.stream_t(data=axis128_frag_null(), valid=0)


def axis512_frag_null():
    return axis512_frag_t(
        frag=axis512_bus_t(data=[0] * 64, keep=[0] * 64), eod=[0]
    )


def axis512_stream_null():
    return axis512_intrf.stream_t(data=axis512_frag_null(), valid=0)


def poly1305_key_stream_null():
    return poly1305_key_stream_intrf.stream_t(data=0, valid=0)


def poly1305_auth_tag_stream_null():
    return poly1305_auth_tag_stream_intrf.stream_t(data=0, valid=0)


def uint1_stream_null():
    return uint1_stream_intrf.stream_t(data=0, valid=0)
