# pyright: reportInvalidTypeForm=none
"""Packed ciphertext||16-byte-tag framing on a 32-byte packet bus."""
import wireguard_env  # noqa: F401
from pypeline import NamedTuple, struct, hw_func, Reg, uint1_t, uint8_t, make_uint_t, uint_to_array_le, array_to_uint_le, sim_assert
from aead_types import (aead_axis_intrf, aead_stream_null, aead_keep_count,
                        aead_count_to_keep, poly1305_auth_tag_stream_intrf,
                        poly1305_auth_tag_stream_null)
from stream import stream_perf_probe as perf_taps

count_t = make_uint_t(7)


@struct
class append_result_t(NamedTuple):
    axis_in_if: aead_axis_intrf.fb_t
    auth_tag_in_if: poly1305_auth_tag_stream_intrf.fb_t
    axis_out_if: aead_axis_intrf.fwd_t


@hw_func
def append_auth_tag_wide(axis_in_if: aead_axis_intrf.fwd_t,
                         auth_tag_in_if: poly1305_auth_tag_stream_intrf.fwd_t,
                         axis_out_if: aead_axis_intrf.fb_t) -> append_result_t:
    waiting: Reg[uint1_t]
    second: Reg[uint1_t]
    held: Reg[uint8_t[32]]
    held_count: Reg[count_t]
    o: append_result_t
    o.axis_in_if.ready = 0
    o.auth_tag_in_if.ready = 0
    o.axis_out_if.stream = aead_stream_null()
    n = aead_keep_count(axis_in_if.stream.data.frag)
    tag: uint8_t[16] = uint_to_array_le(auth_tag_in_if.stream.data, 8)
    merged: uint8_t[64]
    for j in range(32):
        merged[j] = held[j]
        merged[j + 32] = 0
    for j in range(16):
        merged[held_count + j] = tag[j]

    if ~waiting:
        o.axis_out_if = axis_in_if
        o.axis_out_if.stream.data.eod[0] = 0
        o.axis_in_if.ready = axis_out_if.ready
        if axis_in_if.stream.data.eod[0] & (n != 32):
            # Capture without waiting for the tag: the other fork needs this
            # transfer to finish authentication and produce that tag.
            o.axis_out_if.stream.valid = 0
            o.axis_in_if.ready = 1
        if axis_in_if.stream.valid & o.axis_in_if.ready & axis_in_if.stream.data.eod[0]:
            sim_assert(n > 0, "Empty plaintext frame")
            held = axis_in_if.stream.data.frag.data
            held_count = n
            second = n == 32
            waiting = 1
    else:
        total: count_t = held_count + 16
        keep_count: count_t = total
        for j in range(32):
            o.axis_out_if.stream.data.frag.data[j] = merged[j]
        if second:
            keep_count = total - 32
            for j in range(32):
                o.axis_out_if.stream.data.frag.data[j] = merged[j + 32]
        elif total > 32:
            keep_count = 32
        final: uint1_t = second | (total <= 32)
        o.axis_out_if.stream.data.frag.keep = aead_count_to_keep(keep_count)
        o.axis_out_if.stream.data.eod[0] = final
        o.axis_out_if.stream.valid = auth_tag_in_if.stream.valid
        o.auth_tag_in_if.ready = axis_out_if.ready & final
        if auth_tag_in_if.stream.valid & axis_out_if.ready:
            if final:
                waiting = 0
            else:
                second = 1
    perf_taps.state("append.fsm", waiting, ("CIPHERTEXT", "TAG"))
    perf_taps.hs("append.axis_in", axis_in_if.stream.valid, o.axis_in_if.ready, axis_in_if.stream.data.frag.keep)
    perf_taps.hs("append.axis_out", o.axis_out_if.stream.valid, axis_out_if.ready, o.axis_out_if.stream.data.frag.keep)
    perf_taps.hs("append.tag_in", auth_tag_in_if.stream.valid, o.auth_tag_in_if.ready)
    return o


@struct
class strip_result_t(NamedTuple):
    axis_in_if: aead_axis_intrf.fb_t
    axis_out_if: aead_axis_intrf.fwd_t
    auth_tag_out_if: poly1305_auth_tag_stream_intrf.fwd_t


@hw_func
def strip_auth_tag_wide(axis_in_if: aead_axis_intrf.fwd_t,
                        axis_out_if: aead_axis_intrf.fb_t,
                        auth_tag_out_if: poly1305_auth_tag_stream_intrf.fb_t) -> strip_result_t:
    held: Reg[uint8_t[32]]
    held_valid: Reg[uint1_t]
    finishing: Reg[uint1_t]
    tail: Reg[uint8_t[64]]
    tail_count: Reg[count_t]
    tail_second: Reg[uint1_t]
    tag: Reg[uint8_t[16]]
    tag_valid: Reg[uint1_t]
    o: strip_result_t
    o.axis_in_if.ready = 0
    o.axis_out_if.stream = aead_stream_null()
    o.auth_tag_out_if.stream = poly1305_auth_tag_stream_null()
    o.auth_tag_out_if.stream.data = array_to_uint_le(tag)
    o.auth_tag_out_if.stream.valid = tag_valid
    if tag_valid & auth_tag_out_if.ready:
        tag_valid = 0

    if finishing:
        if tail_count > 0:
            nout: count_t = tail_count
            if tail_count > 32:
                nout = 32
            for j in range(32):
                o.axis_out_if.stream.data.frag.data[j] = tail[j]
                if tail_second:
                    o.axis_out_if.stream.data.frag.data[j] = tail[j + 32]
            o.axis_out_if.stream.data.frag.keep = aead_count_to_keep(nout)
            o.axis_out_if.stream.data.eod[0] = tail_count <= 32
            o.axis_out_if.stream.valid = 1
            if axis_out_if.ready:
                tail_count -= nout
                tail_second = 1
        if (tail_count == 0) & ~tag_valid:
            finishing = 0
    else:
        # The held word is safe to forward only once a nonfinal successor is
        # present. Capture the final two-word window before exposing its tail.
        n = aead_keep_count(axis_in_if.stream.data.frag)
        if axis_in_if.stream.data.eod[0]:
            o.axis_in_if.ready = 1
            if axis_in_if.stream.valid:
                total: count_t = n
                if held_valid:
                    total += 32
                sim_assert(total > 16, "Ciphertext frame contains no payload")
                window: uint8_t[64]
                for j in range(32):
                    window[j] = axis_in_if.stream.data.frag.data[j]
                    window[j + 32] = 0
                    if held_valid:
                        window[j] = held[j]
                        window[j + 32] = axis_in_if.stream.data.frag.data[j]
                for j in range(64):
                    tail[j] = window[j]
                for j in range(16):
                    tag[j] = window[total - 16 + j]
                tag_valid = 1
                tail_count = total - 16
                tail_second = 0
                finishing = 1
                held_valid = 0
        else:
            o.axis_in_if.ready = ~held_valid | axis_out_if.ready
            o.axis_out_if.stream.valid = held_valid & axis_in_if.stream.valid
            for j in range(32):
                o.axis_out_if.stream.data.frag.data[j] = held[j]
                o.axis_out_if.stream.data.frag.keep[j] = 1
            if axis_in_if.stream.valid & o.axis_in_if.ready:
                sim_assert(n == 32, "Partial nonfinal ciphertext/tag beat")
                held = axis_in_if.stream.data.frag.data
                held_valid = 1
    perf_taps.hs("strip.axis_in", axis_in_if.stream.valid, o.axis_in_if.ready, axis_in_if.stream.data.frag.keep)
    perf_taps.hs("strip.axis_out", o.axis_out_if.stream.valid, axis_out_if.ready, o.axis_out_if.stream.data.frag.keep)
    perf_taps.hs("strip.tag_out", o.auth_tag_out_if.stream.valid, auth_tag_out_if.ready)
    return o
