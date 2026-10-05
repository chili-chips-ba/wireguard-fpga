# pyright: reportInvalidTypeForm=none
"""Interleaved Poly1305: automatic prologue/epilogue MCPs and II=1 body.

The body is free running and valid-only. L = AUTO_PIPELINE.latency + 2
includes its explicit input/output registers. Same-cycle retirement bypass
lets a lane be revisited exactly L accepted-beat cycles after its launch.
"""
import wireguard_env  # noqa: F401

from enum import auto
from pypeline import (
    AUTO_PIPELINE, NamedTuple, Reg, Feedback, struct, enum, hw_func,
    uint1_t, uint8_t, make_uint_t, uint_to_array_le, array_to_uint_le,
)
from stream.stream import make_stream_t
from stream.stream_multi_cycle import make_stream_auto_multi_cycle
from aead_types import (
    axis128_intrf, poly1305_key_stream_intrf, poly1305_auth_tag_stream_intrf,
)
from poly1305_math import (
    u8_16_t, uint128_t, uint130_t, clamp,
    residue_add_mod, residue_mul_mod, residue_mul_add_mod,
)
import perf_taps


@struct
class body_in_t(NamedTuple):
    accumulator: uint130_t
    stride: uint130_t
    block: uint8_t[16]


body_in_stream_t = make_stream_t(body_in_t)
body_out_stream_t = make_stream_t(uint130_t)


@hw_func
def poly1305_body(x: body_in_stream_t) -> body_out_stream_t:
    o: body_out_stream_t
    c: uint130_t = array_to_uint_le(x.data.block)
    c = c | (1 << 128)  # Complete, AEAD-padded 16-byte authentication block.
    o.data = residue_mul_add_mod(x.data.accumulator, x.data.stride, c)
    o.valid = x.valid
    return o


# Separate canonical identities allow independently discovered depths in the
# encrypt/decrypt MAINs. Neither identity captures the derived lane count.
@hw_func
def poly1305_body_encrypt(x: body_in_stream_t) -> body_out_stream_t:
    return poly1305_body(x)


@hw_func
def poly1305_body_decrypt(x: body_in_stream_t) -> body_out_stream_t:
    return poly1305_body(x)


@enum
class mac_state_t:
    IDLE = auto()
    PROLOGUE_LAUNCH = auto()
    PROLOGUE_WAIT = auto()
    STREAM_BODY = auto()
    DRAIN = auto()
    EPILOGUE_LAUNCH = auto()
    EPILOGUE_WAIT = auto()
    OUTPUT_TAG = auto()


STATE_NAMES = tuple(mac_state_t.__members__)


@struct
class mac_result_t(NamedTuple):
    key_if: poly1305_key_stream_intrf.fb_t
    data_in_if: axis128_intrf.fb_t
    auth_tag_if: poly1305_auth_tag_stream_intrf.fwd_t


_body_auto_pipelines = {}


def get_body_auto_pipeline(direction):
    """One stable tag per direction, also used to size shared MCP arrays."""
    if direction not in ("encrypt", "decrypt"):
        raise ValueError("Poly1305 direction must be encrypt or decrypt")
    if direction not in _body_auto_pipelines:
        body_func = poly1305_body_encrypt if direction == "encrypt" else poly1305_body_decrypt
        _body_auto_pipelines[direction] = AUTO_PIPELINE(
            body_func, start_latency=wireguard_env.START_LATENCIES[f"poly1305_body_{direction}"]
        )
    return _body_auto_pipelines[direction]


def make_poly1305_mac_pipelined(direction, share_mcp=False):
    body_ap = get_body_auto_pipeline(direction)
    lanes = body_ap.latency + 2
    lane_t = make_uint_t(max(1, (lanes - 1).bit_length()))
    count_t = make_uint_t(lanes.bit_length())
    # Signed subtraction is unnecessary in the epilogue's rotated index.
    index_t = make_uint_t((2 * lanes).bit_length())
    tree_size = 1 << (lanes - 1).bit_length()

    @hw_func
    def body_pipeline(x: body_in_stream_t) -> body_out_stream_t:
        input_reg: Reg[body_in_stream_t]
        output_reg: Reg[body_out_stream_t]
        result: body_out_stream_t = output_reg
        output_reg = body_ap(input_reg)
        input_reg = x
        return result

    @struct
    class powers_t(NamedTuple):
        values: uint130_t[lanes]

    @hw_func
    def prologue(r: uint130_t) -> powers_t:
        o: powers_t
        o.values[0] = r
        for k in range(2, lanes + 1):
            o.values[k - 1] = residue_mul_mod(
                o.values[k // 2 - 1], o.values[(k + 1) // 2 - 1]
            )
        return o

    @struct
    class epilogue_in_t(NamedTuple):
        accumulators: uint130_t[lanes]
        powers: powers_t
        next_lane: lane_t
        s: uint128_t

    @hw_func
    def epilogue(x: epilogue_in_t) -> uint128_t:
        tree: uint130_t[2 * tree_size]
        for j in range(tree_size):
            tree[tree_size + j] = 0
        for j in range(lanes):
            power_index: index_t = x.next_lane + lanes - 1 - j
            if x.next_lane > j:
                power_index = x.next_lane - 1 - j
            tree[tree_size + j] = residue_mul_mod(
                x.accumulators[j], x.powers.values[power_index]
            )
        for k in range(tree_size - 1, 0, -1):
            tree[k] = residue_add_mod(tree[2 * k], tree[2 * k + 1])
        low: uint128_t = tree[1]
        tag: uint128_t = low + x.s
        return tag

    if share_mcp:
        from poly1305_mcp_shared import make_shared_adapters
        prologue_mcp, prologue_result_t, epilogue_mcp, epilogue_result_t = (
            make_shared_adapters(direction, lanes, powers_t, epilogue_in_t)
        )
    else:
        prologue_mcp, prologue_result_t = make_stream_auto_multi_cycle(
            prologue, start_latency=wireguard_env.START_LATENCIES[f"poly1305_prologue_{direction}"]
        )
        epilogue_mcp, epilogue_result_t = make_stream_auto_multi_cycle(
            epilogue, start_latency=wireguard_env.START_LATENCIES[f"poly1305_epilogue_{direction}"]
        )

    @hw_func
    def poly1305_mac_pipelined(
        key_if: poly1305_key_stream_intrf.fwd_t,
        data_in_if: axis128_intrf.fwd_t,
        auth_tag_if: poly1305_auth_tag_stream_intrf.fb_t,
    ) -> mac_result_t:
        state: Reg[mac_state_t]
        accumulators: Reg[uint130_t[lanes]]
        powers: Reg[powers_t]
        r: Reg[uint130_t]
        s: Reg[uint128_t]
        issue_lane: Reg[lane_t]
        retire_lane: Reg[lane_t]
        outstanding: Reg[count_t]
        tag: Reg[uint128_t]

        # These are same-cycle wires, driven by private blocks or shared adapters
        # at the end of the function. Their registered outputs break the loop.
        prologue_result: Feedback[prologue_result_t]
        epilogue_result: Feedback[epilogue_result_t]
        body_result: Feedback[body_out_stream_t]

        o: mac_result_t
        o.key_if.ready = 0
        o.data_in_if.ready = 0
        o.auth_tag_if.stream.valid = 0
        o.auth_tag_if.stream.data = tag

        prologue_in: prologue_mcp.in_intrf.stream_t
        prologue_in.data = r
        prologue_in.valid = 0
        prologue_ready: uint1_t = 0
        epilogue_in: epilogue_mcp.in_intrf.stream_t
        epilogue_in.data.accumulators = accumulators
        epilogue_in.data.powers = powers
        epilogue_in.data.next_lane = issue_lane
        epilogue_in.data.s = s
        epilogue_in.valid = 0
        epilogue_ready: uint1_t = 0
        body_in: body_in_stream_t
        body_in.data.accumulator = accumulators[issue_lane]
        body_in.data.stride = powers.values[lanes - 1]
        body_in.data.block = data_in_if.stream.data.frag.data
        body_in.valid = 0

        # Snapshot before either pointer advances. The explicit forwarding
        # mux is required when launch and writeback use the same lane.
        retiring: uint1_t = body_result.valid
        if retiring:
            if issue_lane == retire_lane:
                body_in.data.accumulator = body_result.data
            accumulators[retire_lane] = body_result.data
            if retire_lane == lanes - 1:
                retire_lane = 0
            else:
                retire_lane += 1

        perf_taps.state("poly1305.fsm", state, STATE_NAMES)
        if state == mac_state_t.IDLE:
            o.key_if.ready = 1
            if key_if.stream.valid:
                key_bytes: uint8_t[32] = uint_to_array_le(key_if.stream.data, 8)
                r_bytes: u8_16_t
                s_bytes: uint8_t[16]
                for j in range(16):
                    r_bytes.bytes[j] = key_bytes[j]
                    s_bytes[j] = key_bytes[j + 16]
                r_bytes = clamp(r_bytes)
                r = array_to_uint_le(r_bytes.bytes)
                s = array_to_uint_le(s_bytes)
                for j in range(lanes):
                    accumulators[j] = 0
                issue_lane = 0
                retire_lane = 0
                outstanding = 0
                state = mac_state_t.PROLOGUE_LAUNCH
        elif state == mac_state_t.PROLOGUE_LAUNCH:
            prologue_in.valid = 1
            if prologue_result.stream_in_if.ready:
                state = mac_state_t.PROLOGUE_WAIT
        elif state == mac_state_t.PROLOGUE_WAIT:
            prologue_ready = 1
            if prologue_result.stream_out_if.stream.valid:
                powers = prologue_result.stream_out_if.stream.data
                state = mac_state_t.STREAM_BODY
        elif state == mac_state_t.STREAM_BODY:
            o.data_in_if.ready = 1
            body_in.valid = data_in_if.stream.valid
            if body_in.valid:
                if issue_lane == lanes - 1:
                    issue_lane = 0
                else:
                    issue_lane += 1
                if data_in_if.stream.data.eod[0]:
                    state = mac_state_t.DRAIN
        elif state == mac_state_t.DRAIN:
            # One explicit phase boundary ensures the epilogue snapshots
            # committed lane registers, including the final writeback.
            if outstanding == 0:
                state = mac_state_t.EPILOGUE_LAUNCH
        elif state == mac_state_t.EPILOGUE_LAUNCH:
            epilogue_in.valid = 1
            if epilogue_result.stream_in_if.ready:
                state = mac_state_t.EPILOGUE_WAIT
        elif state == mac_state_t.EPILOGUE_WAIT:
            epilogue_ready = 1
            if epilogue_result.stream_out_if.stream.valid:
                tag = epilogue_result.stream_out_if.stream.data
                state = mac_state_t.OUTPUT_TAG
        elif state == mac_state_t.OUTPUT_TAG:
            o.auth_tag_if.stream.valid = 1
            if auth_tag_if.ready:
                state = mac_state_t.IDLE

        if body_in.valid & ~retiring:
            outstanding += 1
        elif retiring & ~body_in.valid:
            outstanding -= 1

        prologue_result = prologue_mcp(
            prologue_mcp.in_fwd_t(stream=prologue_in),
            prologue_mcp.out_fb_t(ready=prologue_ready),
        )
        body_result = body_pipeline(body_in)
        epilogue_result = epilogue_mcp(
            epilogue_mcp.in_fwd_t(stream=epilogue_in),
            epilogue_mcp.out_fb_t(ready=epilogue_ready),
        )

        perf_taps.hs("poly1305.key_in", key_if.stream.valid, o.key_if.ready)
        perf_taps.hs("poly1305.data_in", data_in_if.stream.valid, o.data_in_if.ready,
                     data_in_if.stream.data.frag.keep)
        perf_taps.hs("poly1305.tag_out", o.auth_tag_if.stream.valid, auth_tag_if.ready)
        perf_taps.hs("poly1305.to_compute", body_in.valid, 1)
        perf_taps.hs("poly1305.from_compute", body_result.valid, 1)
        perf_taps.hs("poly1305.prologue_in", prologue_in.valid,
                     prologue_result.stream_in_if.ready)
        perf_taps.hs("poly1305.prologue_out", prologue_result.stream_out_if.stream.valid,
                     prologue_ready)
        perf_taps.hs("poly1305.epilogue_in", epilogue_in.valid,
                     epilogue_result.stream_in_if.ready)
        perf_taps.hs("poly1305.epilogue_out", epilogue_result.stream_out_if.stream.valid,
                     epilogue_ready)
        return o

    # Plain Python metadata/test hooks; these do not add hardware ports.
    poly1305_mac_pipelined.body_auto_pipeline = body_ap
    poly1305_mac_pipelined.body_pipeline = body_pipeline
    poly1305_mac_pipelined.accumulator_count = lanes
    poly1305_mac_pipelined.prologue_mcp = prologue_mcp
    poly1305_mac_pipelined.epilogue_mcp = epilogue_mcp
    poly1305_mac_pipelined.prologue = prologue
    poly1305_mac_pipelined.epilogue = epilogue
    poly1305_mac_pipelined.shared_mcps = bool(share_mcp)
    return poly1305_mac_pipelined
