# pyright: reportInvalidTypeForm=none
"""Two blocks per clock: coefficient preprocessing followed by interleaved feedback.

Ownership spans both free-running pipelines. Only feedback latency determines
the lane count; accumulator reads occur after coefficient preprocessing.
"""
import functools
import wireguard_env  # noqa: F401

from enum import auto
from pypeline import (
    AUTO_PIPELINE, NamedTuple, Reg, Feedback, struct, enum, hw_func,
    uint1_t, uint8_t, make_uint_t, uint_to_array_le, array_to_uint_le, sim_assert,
)
from stream.stream import make_stream_t, make_stream_interface
from poly1305_service import make_compute_service
from aead_types import (
    aead_axis_intrf, poly1305_key_stream_intrf, poly1305_auth_tag_stream_intrf,
)
from poly1305_math import (
    u8_16_t, uint128_t, uint130_t, clamp,
    residue_mul_add_mod, feedback_mul_add_mod,
)
from stream import stream_perf_probe as perf_taps


@struct
class body_in_t(NamedTuple):
    accumulator: uint130_t
    stride: uint130_t
    coefficient: uint130_t


body_in_stream_t = make_stream_t(body_in_t)
body_out_stream_t = make_stream_t(uint130_t)


@hw_func
def poly1305_pair_accumulate(x: body_in_stream_t) -> body_out_stream_t:
    o: body_out_stream_t
    o.data = feedback_mul_add_mod(x.data.accumulator, x.data.stride, x.data.coefficient)
    o.valid = x.valid
    return o


# Keep the arithmetic body inside each latency region so the sweep can
# attribute its critical paths and mini-sweep it. Region roots are not
# mini-swept. Neither wrapper captures the derived lane count.
@hw_func
def poly1305_pair_accumulate_encrypt(x: body_in_stream_t) -> body_out_stream_t:
    return poly1305_pair_accumulate(x)


@hw_func
def poly1305_pair_accumulate_decrypt(x: body_in_stream_t) -> body_out_stream_t:
    return poly1305_pair_accumulate(x)


@struct
class coefficient_in_t(NamedTuple):
    r: uint130_t
    blocks: uint8_t[32]


coefficient_in_stream_t = make_stream_t(coefficient_in_t)


@hw_func
def poly1305_pair_coefficient(x: coefficient_in_stream_t) -> body_out_stream_t:
    lo: uint8_t[16]
    hi: uint8_t[16]
    for j in range(16):
        lo[j] = x.data.blocks[j]
        hi[j] = x.data.blocks[j + 16]
    c0: uint130_t = array_to_uint_le(lo)
    c1: uint130_t = array_to_uint_le(hi)
    c0 = c0 | (1 << 128)
    c1 = c1 | (1 << 128)
    o: body_out_stream_t
    o.data = residue_mul_add_mod(c0, x.data.r, c1)
    o.valid = x.valid
    return o


@hw_func
def poly1305_pair_coefficient_encrypt(x: coefficient_in_stream_t) -> body_out_stream_t:
    return poly1305_pair_coefficient(x)


@hw_func
def poly1305_pair_coefficient_decrypt(x: coefficient_in_stream_t) -> body_out_stream_t:
    return poly1305_pair_coefficient(x)


@functools.lru_cache(maxsize=None)
def get_coefficient_auto_pipeline(direction, coefficient_latency=None):
    func = (poly1305_pair_coefficient_encrypt if direction == "encrypt"
            else poly1305_pair_coefficient_decrypt)
    name = f"poly1305_pair_coefficient_{direction}"
    if coefficient_latency is not None:
        return AUTO_PIPELINE(func, latency=coefficient_latency, name=name)
    return AUTO_PIPELINE(func, name=name)

# Architectural storage/phase boundaries, also consumed by FIFO sizing.
PACKET_CONTEXTS = 2
KEY_CAPTURE_CYCLES = 1
PREPARED_REGISTER_CYCLES = 1
BODY_CONTEXT_REGISTER_CYCLES = 1
BODY_COMMIT_CYCLES = 1
COMPLETION_REGISTER_CYCLES = 1
TAG_REGISTER_CYCLES = 1


@enum
class prologue_state_t:
    IDLE = auto()
    PROLOGUE_LAUNCH = auto()
    PROLOGUE_WAIT = auto()
    OUTPUT_DESCRIPTOR = auto()


@enum
class bank_state_t:
    EMPTY = auto()
    READY = auto()
    STREAM_BODY = auto()
    DRAIN = auto()


@enum
class epilogue_state_t:
    IDLE = auto()
    EPILOGUE_WAIT = auto()
    OUTPUT_TAG = auto()


PROLOGUE_STATE_NAMES = tuple(prologue_state_t.__members__)
BANK_STATE_NAMES = tuple(bank_state_t.__members__)
EPILOGUE_STATE_NAMES = tuple(epilogue_state_t.__members__)


@struct
class mac_result_t(NamedTuple):
    key_if: poly1305_key_stream_intrf.fb_t
    data_in_if: aead_axis_intrf.fb_t
    auth_tag_if: poly1305_auth_tag_stream_intrf.fwd_t


@functools.lru_cache(maxsize=None)
def get_body_auto_pipeline(direction, body_latency=None):
    """One named latency group per direction, also used to size shared MCP arrays.
    body_latency: a fixed body depth instead of the automatic one -- only the
    standalone paired testbench sets it."""
    if direction not in ("encrypt", "decrypt"):
        raise ValueError("Poly1305 direction must be encrypt or decrypt")
    body_func = poly1305_pair_accumulate_encrypt if direction == "encrypt" else poly1305_pair_accumulate_decrypt
    name = f"poly1305_pair_accumulate_{direction}"
    if body_latency is not None:
        return AUTO_PIPELINE(body_func, latency=body_latency, name=name)
    return AUTO_PIPELINE(body_func, name=name)


def make_poly1305_mac_paired(direction, share_mcp=False, *, body_latency=None, coefficient_latency=None):
    body_ap = get_body_auto_pipeline(direction, body_latency)
    coefficient_ap = get_coefficient_auto_pipeline(direction, coefficient_latency)
    coefficient_cycles = coefficient_ap.latency + 2
    lanes = body_ap.latency + 2
    total_cycles = coefficient_cycles + lanes
    lane_t = make_uint_t(max(1, (lanes - 1).bit_length()))
    count_t = make_uint_t(total_cycles.bit_length())

    @hw_func
    def body_pipeline(x: body_in_stream_t) -> body_out_stream_t:
        input_reg: Reg[body_in_stream_t]
        output_reg: Reg[body_out_stream_t]
        result: body_out_stream_t = output_reg
        output_reg = body_ap(input_reg)
        input_reg = x
        return result

    @hw_func
    def coefficient_pipeline(x: coefficient_in_stream_t) -> body_out_stream_t:
        input_reg: Reg[coefficient_in_stream_t]
        output_reg: Reg[body_out_stream_t]
        result: body_out_stream_t = output_reg
        output_reg = coefficient_ap(input_reg)
        input_reg = x
        return result

    from poly1305_paired_compute import make_paired_compute
    compute = make_paired_compute(lanes, direction=direction)
    powers_t, epilogue_in_t = compute.powers_t, compute.epilogue_in_t
    prologue, epilogue = compute.prologue, compute.epilogue

    if share_mcp:
        from poly1305_mcp_shared import make_shared_adapters

        adapters = make_shared_adapters(direction, lanes, powers_t, epilogue_in_t)
        prologue_mcp = adapters.prologue
        epilogue_mcp = adapters.epilogue
    else:
        prologue_mcp = make_compute_service(
            prologue, name=f"poly1305_paired_prologue_{direction}", phase="prologue"
        )
        epilogue_mcp = make_compute_service(
            epilogue, name=f"poly1305_paired_epilogue_{direction}", phase="epilogue"
        )

    @struct
    class prepared_t(NamedTuple):
        context: uint1_t
        powers: powers_t
        r: uint130_t
        s: uint128_t

    @struct
    class completed_t(NamedTuple):
        context: uint1_t
        data: epilogue_in_t

    prepared_intrf = make_stream_interface(prepared_t)
    completed_intrf = make_stream_interface(completed_t)

    @struct
    class prologue_stage_result_t(NamedTuple):
        key_if: poly1305_key_stream_intrf.fb_t
        prepared_if: prepared_intrf.fwd_t
        computing: uint1_t

    @hw_func
    def prologue_stage(
        key_if: poly1305_key_stream_intrf.fwd_t,
        prepared_if: prepared_intrf.fb_t,
    ) -> prologue_stage_result_t:
        state: Reg[prologue_state_t]
        r: Reg[uint130_t]
        descriptor: Reg[prepared_t]
        next_context: Reg[uint1_t]
        result: Feedback[prologue_mcp.return_t]
        o: prologue_stage_result_t
        o.key_if.ready = state == prologue_state_t.IDLE
        o.prepared_if.stream.data = descriptor
        o.prepared_if.stream.valid = state == prologue_state_t.OUTPUT_DESCRIPTOR
        o.computing = ((state == prologue_state_t.PROLOGUE_LAUNCH)
                       | (state == prologue_state_t.PROLOGUE_WAIT))
        request: prologue_mcp.in_intrf.stream_t
        request.data = r
        request.valid = state == prologue_state_t.PROLOGUE_LAUNCH
        response_ready: uint1_t = state == prologue_state_t.PROLOGUE_WAIT
        perf_taps.state("poly1305.prologue.fsm", state, PROLOGUE_STATE_NAMES)

        if state == prologue_state_t.IDLE:
            if key_if.stream.valid:
                key_bytes: uint8_t[32] = uint_to_array_le(key_if.stream.data, 8)
                r_bytes: u8_16_t
                s_bytes: uint8_t[16]
                for j in range(16):
                    r_bytes.bytes[j] = key_bytes[j]
                    s_bytes[j] = key_bytes[j + 16]
                r_bytes = clamp(r_bytes)
                r = array_to_uint_le(r_bytes.bytes)
                descriptor.r = r
                descriptor.s = array_to_uint_le(s_bytes)
                descriptor.context = next_context
                next_context = ~next_context
                state = prologue_state_t.PROLOGUE_LAUNCH
        elif state == prologue_state_t.PROLOGUE_LAUNCH:
            if result.stream_in_if.ready:
                state = prologue_state_t.PROLOGUE_WAIT
        elif state == prologue_state_t.PROLOGUE_WAIT:
            if result.stream_out_if.stream.valid:
                descriptor.powers = result.stream_out_if.stream.data
                state = prologue_state_t.OUTPUT_DESCRIPTOR
        elif prepared_if.ready:
            state = prologue_state_t.IDLE

        result = prologue_mcp(
            prologue_mcp.in_fwd_t(stream=request),
            prologue_mcp.out_fb_t(ready=response_ready),
        )
        perf_taps.hs("poly1305.prologue_in", request.valid, result.stream_in_if.ready)
        perf_taps.hs("poly1305.prologue_out", result.stream_out_if.stream.valid, response_ready)
        perf_taps.hs("poly1305.prepared.in", result.stream_out_if.stream.valid, response_ready)
        perf_taps.hs("poly1305.prepared.out", o.prepared_if.stream.valid, prepared_if.ready)
        perf_taps.occupancy("poly1305.prepared.occupancy",
                            result.stream_out_if.stream.valid, response_ready,
                            o.prepared_if.stream.valid, prepared_if.ready, 1)
        return o

    @struct
    class bank_t(NamedTuple):
        state: bank_state_t
        data: epilogue_in_t
        retire_lane: lane_t
        outstanding: count_t

    @struct
    class body_owner_t(NamedTuple):
        context: uint1_t
        lane: lane_t
        valid: uint1_t

    @struct
    class body_stage_result_t(NamedTuple):
        prepared_if: prepared_intrf.fb_t
        data_in_if: aead_axis_intrf.fb_t
        completed_if: completed_intrf.fwd_t

    @hw_func
    def body_stage(
        prepared_if: prepared_intrf.fwd_t,
        data_in_if: aead_axis_intrf.fwd_t,
        completed_if: completed_intrf.fb_t,
    ) -> body_stage_result_t:
        banks: Reg[bank_t[PACKET_CONTEXTS]]
        issue_context: Reg[uint1_t]
        complete_context: Reg[uint1_t]
        completion: Reg[completed_intrf.stream_t]
        owners: Reg[body_owner_t[lanes]]
        result: Feedback[body_out_stream_t]
        coefficients: Feedback[body_out_stream_t]
        coefficient_owners: Reg[body_owner_t[coefficient_cycles]]

        # Snapshot the old registers before writeback/issue mutate them.
        issuing_context: uint1_t = issue_context
        issuing_lane: lane_t = banks[issuing_context].data.next_lane
        owner: body_owner_t = owners[lanes - 1]
        retiring_context: uint1_t = owner.context
        retiring_lane: lane_t = owner.lane
        can_snapshot: uint1_t = (
            (banks[complete_context].state == bank_state_t.DRAIN)
            & (banks[complete_context].outstanding == 0)
        )
        streaming: uint1_t = (
            (banks[issuing_context].state == bank_state_t.READY)
            | (banks[issuing_context].state == bank_state_t.STREAM_BODY)
        )
        draining: uint1_t = (
            (banks[0].state == bank_state_t.DRAIN)
            | (banks[1].state == bank_state_t.DRAIN)
        )
        o: body_stage_result_t
        o.data_in_if.ready = streaming
        o.completed_if.stream = completion
        admitted: uint1_t = data_in_if.stream.valid & streaming
        paired: uint1_t = data_in_if.stream.data.frag.keep[31]
        coefficient_request: coefficient_in_stream_t
        coefficient_request.data.r = banks[issuing_context].data.r
        coefficient_request.data.blocks = data_in_if.stream.data.frag.data
        coefficient_request.valid = admitted & paired
        coefficient_owner: body_owner_t = coefficient_owners[coefficient_cycles - 1]
        feedback_context: uint1_t = coefficient_owner.context
        feedback_lane: lane_t = coefficient_owner.lane
        request: body_in_stream_t
        request.data.accumulator = banks[feedback_context].data.accumulators[feedback_lane]
        request.data.stride = banks[feedback_context].data.powers.values[lanes - 1]
        request.data.coefficient = coefficients.data
        request.valid = coefficients.valid
        sim_assert(coefficients.valid == coefficient_owner.valid,
                   "Poly1305 coefficient ownership delay mismatch")
        if admitted:
            for j in range(16):
                sim_assert(data_in_if.stream.data.frag.keep[j], "Incomplete first authentication block")
                sim_assert(data_in_if.stream.data.frag.keep[j + 16] == paired,
                           "Incomplete second authentication block")
            sim_assert(paired | data_in_if.stream.data.eod[0], "Single block must terminate authentication")

        perf_taps.state("poly1305.body.bank0", banks[0].state, BANK_STATE_NAMES)
        perf_taps.state("poly1305.body.bank1", banks[1].state, BANK_STATE_NAMES)
        perf_taps.state("poly1305.body.fsm", streaming, ("WAIT_CONTEXT", "STREAM_BODY"))
        perf_taps.state("poly1305.fsm", streaming, ("WAIT_CONTEXT", "STREAM_BODY"))
        perf_taps.hs("poly1305.drain", draining, 1)
        perf_taps.hs("poly1305.body_drain_overlap", request.valid & draining, 1)

        # Results cannot be backpressured. The metadata line advances every
        # clock, including bubbles, just like the single arithmetic pipeline.
        sim_assert(result.valid == owner.valid, "Poly1305 body ownership delay mismatch")
        if result.valid:
            sim_assert(banks[retiring_context].state != bank_state_t.EMPTY,
                       "Poly1305 writeback into a released context")
            sim_assert(banks[retiring_context].outstanding != 0,
                       "Poly1305 outstanding result underflow")
            sim_assert(banks[retiring_context].retire_lane == retiring_lane,
                       "Poly1305 result lane ordering mismatch")
            if (feedback_context == retiring_context) & (feedback_lane == retiring_lane):
                request.data.accumulator = result.data
            banks[retiring_context].data.accumulators[retiring_lane] = result.data
            banks[retiring_context].outstanding -= 1
            if retiring_lane == lanes - 1:
                banks[retiring_context].retire_lane = 0
            else:
                banks[retiring_context].retire_lane = retiring_lane + 1

        if admitted:
            banks[issuing_context].state = bank_state_t.STREAM_BODY
            if paired:
                sim_assert(banks[issuing_context].outstanding < total_cycles,
                           "Poly1305 too many outstanding pairs")
                banks[issuing_context].outstanding += 1
                if issuing_lane == lanes - 1:
                    banks[issuing_context].data.next_lane = 0
                else:
                    banks[issuing_context].data.next_lane = issuing_lane + 1
            else:
                tail_bytes: uint8_t[16]
                for j in range(16):
                    tail_bytes[j] = data_in_if.stream.data.frag.data[j]
                tail: uint130_t = array_to_uint_le(tail_bytes)
                banks[issuing_context].data.tail = tail | (1 << 128)
                banks[issuing_context].data.has_tail = 1
            if data_in_if.stream.data.eod[0]:
                banks[issuing_context].state = bank_state_t.DRAIN
                issue_context = ~issuing_context

        if completion.valid & completed_if.ready:
            completion.valid = 0
        snapshot: uint1_t = can_snapshot & ~completion.valid
        if snapshot:
            # can_snapshot uses the old outstanding count: this boundary
            # includes the final committed writeback, while the other bank
            # remains free to issue arithmetic work.
            completion.data.context = complete_context
            completion.data.data = banks[complete_context].data
            completion.valid = 1
            banks[complete_context].state = bank_state_t.EMPTY
            complete_context = ~complete_context

        # A released bank may accept the next descriptor on this same edge.
        # Issue eligibility above still came from the old bank state.
        o.prepared_if.ready = banks[prepared_if.stream.data.context].state == bank_state_t.EMPTY
        if prepared_if.stream.valid & o.prepared_if.ready:
            context: uint1_t = prepared_if.stream.data.context
            sim_assert(banks[context].outstanding == 0,
                       "Poly1305 context reused before drain")
            banks[context].state = bank_state_t.READY
            banks[context].data.powers = prepared_if.stream.data.powers
            banks[context].data.s = prepared_if.stream.data.s
            banks[context].data.r = prepared_if.stream.data.r
            banks[context].data.tail = 0
            banks[context].data.has_tail = 0
            banks[context].data.lane_count = lanes
            banks[context].data.next_lane = 0
            banks[context].retire_lane = 0
            for j in range(lanes):
                banks[context].data.accumulators[j] = 0

        for k in range(lanes - 1, 0, -1):
            owners[k] = owners[k - 1]
        owners[0].context = feedback_context
        owners[0].lane = feedback_lane
        owners[0].valid = request.valid
        result = body_pipeline(request)
        for k in range(coefficient_cycles - 1, 0, -1):
            coefficient_owners[k] = coefficient_owners[k - 1]
        coefficient_owners[0].context = issuing_context
        coefficient_owners[0].lane = issuing_lane
        coefficient_owners[0].valid = coefficient_request.valid
        coefficients = coefficient_pipeline(coefficient_request)

        perf_taps.hs("poly1305.coefficient_in", coefficient_request.valid, 1)
        perf_taps.hs("poly1305.coefficient_out", coefficients.valid, 1)
        perf_taps.hs("poly1305.tail_in", admitted & ~paired, 1)

        perf_taps.hs("poly1305.to_compute", request.valid, 1)
        perf_taps.hs("poly1305.from_compute", result.valid, 1)
        perf_taps.hs("poly1305.contexts.in", prepared_if.stream.valid, o.prepared_if.ready)
        perf_taps.hs("poly1305.contexts.out", snapshot, 1)
        perf_taps.occupancy("poly1305.contexts.occupancy",
                            prepared_if.stream.valid, o.prepared_if.ready, snapshot, 1,
                            PACKET_CONTEXTS)
        perf_taps.hs("poly1305.completion.in", snapshot, 1)
        perf_taps.hs("poly1305.completion.out", o.completed_if.stream.valid, completed_if.ready)
        perf_taps.occupancy("poly1305.completion.occupancy", snapshot, 1,
                            o.completed_if.stream.valid, completed_if.ready, 1)
        return o

    @struct
    class epilogue_stage_result_t(NamedTuple):
        completed_if: completed_intrf.fb_t
        auth_tag_if: poly1305_auth_tag_stream_intrf.fwd_t
        computing: uint1_t

    @hw_func
    def epilogue_stage(
        completed_if: completed_intrf.fwd_t,
        auth_tag_if: poly1305_auth_tag_stream_intrf.fb_t,
    ) -> epilogue_stage_result_t:
        state: Reg[epilogue_state_t]
        owner_context: Reg[uint1_t]
        tag_context: Reg[uint1_t]
        tag: Reg[uint128_t]
        result: Feedback[epilogue_mcp.return_t]
        o: epilogue_stage_result_t
        o.completed_if.ready = (state == epilogue_state_t.IDLE) & result.stream_in_if.ready
        o.auth_tag_if.stream.data = tag
        o.auth_tag_if.stream.valid = state == epilogue_state_t.OUTPUT_TAG
        o.computing = ((state == epilogue_state_t.EPILOGUE_WAIT)
                       | ((state == epilogue_state_t.IDLE) & completed_if.stream.valid))
        request: epilogue_mcp.in_intrf.stream_t
        request.data = completed_if.stream.data.data
        request.valid = completed_if.stream.valid & (state == epilogue_state_t.IDLE)
        response_ready: uint1_t = state == epilogue_state_t.EPILOGUE_WAIT
        perf_taps.state("poly1305.epilogue.fsm", state, EPILOGUE_STATE_NAMES)

        if state == epilogue_state_t.IDLE:
            if request.valid & result.stream_in_if.ready:
                owner_context = completed_if.stream.data.context
                state = epilogue_state_t.EPILOGUE_WAIT
        elif state == epilogue_state_t.EPILOGUE_WAIT:
            if result.stream_out_if.stream.valid:
                tag = result.stream_out_if.stream.data
                tag_context = owner_context
                state = epilogue_state_t.OUTPUT_TAG
        elif auth_tag_if.ready:
            sim_assert(tag_context == owner_context, "Poly1305 tag ownership mismatch")
            state = epilogue_state_t.IDLE

        result = epilogue_mcp(
            epilogue_mcp.in_fwd_t(stream=request),
            epilogue_mcp.out_fb_t(ready=response_ready),
        )
        perf_taps.hs("poly1305.epilogue_in", request.valid, result.stream_in_if.ready)
        perf_taps.hs("poly1305.epilogue_out", result.stream_out_if.stream.valid, response_ready)
        perf_taps.hs("poly1305.tags.in", result.stream_out_if.stream.valid, response_ready)
        perf_taps.hs("poly1305.tags.out", o.auth_tag_if.stream.valid, auth_tag_if.ready)
        perf_taps.occupancy("poly1305.tags.occupancy",
                            result.stream_out_if.stream.valid, response_ready,
                            o.auth_tag_if.stream.valid, auth_tag_if.ready, 1)
        return o

    @hw_func
    def poly1305_mac_paired(
        key_if: poly1305_key_stream_intrf.fwd_t,
        data_in_if: aead_axis_intrf.fwd_t,
        auth_tag_if: poly1305_auth_tag_stream_intrf.fb_t,
    ) -> mac_result_t:
        body_result: Feedback[body_stage_result_t]
        epilogue_result: Feedback[epilogue_stage_result_t]
        prepared = prologue_stage(key_if, prepared_intrf.fb_t(body_result.prepared_if.ready))
        body_result = body_stage(prepared.prepared_if, data_in_if,
                                 completed_intrf.fb_t(epilogue_result.completed_if.ready))
        epilogue_result = epilogue_stage(body_result.completed_if, auth_tag_if)
        o: mac_result_t
        o.key_if = prepared.key_if
        o.data_in_if = body_result.data_in_if
        o.auth_tag_if = epilogue_result.auth_tag_if
        perf_taps.hs("poly1305.key_in", key_if.stream.valid, o.key_if.ready)
        perf_taps.hs("poly1305.data_in", data_in_if.stream.valid, o.data_in_if.ready,
                     data_in_if.stream.data.frag.keep)
        perf_taps.hs("poly1305.tag_out", o.auth_tag_if.stream.valid, auth_tag_if.ready)
        issuing: uint1_t = data_in_if.stream.valid & o.data_in_if.ready
        perf_taps.hs("poly1305.setup_body_overlap", prepared.computing & issuing, 1)
        perf_taps.hs("poly1305.epilogue_body_overlap", epilogue_result.computing & issuing, 1)
        return o

    # Plain Python metadata/test hooks; these do not add hardware ports.
    poly1305_mac_paired.coefficient_auto_pipeline = coefficient_ap
    poly1305_mac_paired.coefficient_pipeline = coefficient_pipeline
    poly1305_mac_paired.coefficient_latency = coefficient_cycles
    poly1305_mac_paired.total_body_latency = total_cycles
    poly1305_mac_paired.body_auto_pipeline = body_ap
    poly1305_mac_paired.body_pipeline = body_pipeline
    poly1305_mac_paired.accumulator_count = lanes
    poly1305_mac_paired.prologue_mcp = prologue_mcp
    poly1305_mac_paired.epilogue_mcp = epilogue_mcp
    poly1305_mac_paired.prologue = prologue
    poly1305_mac_paired.epilogue = epilogue
    poly1305_mac_paired.shared_mcps = bool(share_mcp)
    poly1305_mac_paired.packet_architecture = "overlapped"
    poly1305_mac_paired.prologue_handoff_cycles = (
        KEY_CAPTURE_CYCLES + PREPARED_REGISTER_CYCLES + BODY_CONTEXT_REGISTER_CYCLES
    )
    poly1305_mac_paired.body_commit_cycles = BODY_COMMIT_CYCLES
    poly1305_mac_paired.epilogue_handoff_cycles = (
        COMPLETION_REGISTER_CYCLES + TAG_REGISTER_CYCLES
    )
    poly1305_mac_paired.packet_buffers = {
        "poly1305.prepared": 1, "poly1305.contexts": PACKET_CONTEXTS,
        "poly1305.completion": 1, "poly1305.tags": 1,
    }
    return poly1305_mac_paired
