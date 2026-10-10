# pyright: reportInvalidTypeForm=none
"""Independent round-robin prologue and epilogue services for two MACs.

Only this module owns the two MCPs. Per-direction adapters own no compute
resource or packet state. Capacity follows both actual body AUTO_PIPELINE
depths; a request's local lane count determines its epilogue rotation.
"""
import wireguard_env
from pypeline import MAIN, NamedTuple, Reg, Feedback, Wire, struct, hw_func, uint1_t, uint2_t, make_uint_t
from stream.stream import make_stream_interface
from stream.stream_multi_cycle import make_stream_auto_multi_cycle
from poly1305_math import uint128_t, uint130_t, residue_mul_mod, residue_add_mod, residue_square_mod
from poly1305_mac_pipelined import get_body_auto_pipeline
from stream import stream_perf_probe as perf_taps

CAPACITY = max(get_body_auto_pipeline(d).latency + 2 for d in ("encrypt", "decrypt"))


def make_shared_compute(capacity):
    """Pure arithmetic, also exercised directly by the standalone testbench."""
    lane_t = make_uint_t(max(1, (capacity - 1).bit_length()))
    count_t = make_uint_t(capacity.bit_length())
    index_t = make_uint_t((2 * capacity).bit_length())
    tree_size = 1 << (capacity - 1).bit_length()

    @struct
    class powers_t(NamedTuple):
        values: uint130_t[capacity]

    @struct
    class epilogue_in_t(NamedTuple):
        accumulators: uint130_t[capacity]
        powers: powers_t
        lane_count: count_t
        next_lane: lane_t
        s: uint128_t

    @hw_func
    def prologue(r: uint130_t) -> powers_t:
        o: powers_t
        o.values[0] = r
        for k in range(2, capacity + 1):
            if wireguard_env.POLY1305_MULT_IMPL == "hybrid_square" and k % 2 == 0:
                o.values[k - 1] = residue_square_mod(o.values[k // 2 - 1])
            else:
                o.values[k - 1] = residue_mul_mod(
                    o.values[k // 2 - 1], o.values[(k + 1) // 2 - 1]
                )
        return o

    @hw_func
    def epilogue(x: epilogue_in_t) -> uint128_t:
        tree: uint130_t[2 * tree_size]
        for j in range(tree_size):
            tree[tree_size + j] = 0
        for j in range(capacity):
            weight: uint130_t = 0
            if j < x.lane_count:
                power_index: index_t = x.next_lane
                power_index += x.lane_count
                power_index -= 1 + j
                if x.next_lane > j:
                    power_index = x.next_lane - 1 - j
                weight = x.powers.values[power_index]
            # Exactly one product per capacity slot, not one set per direction.
            tree[tree_size + j] = residue_mul_mod(x.accumulators[j], weight)
        for k in range(tree_size - 1, 0, -1):
            tree[k] = residue_add_mod(tree[2 * k], tree[2 * k + 1])
        low: uint128_t = tree[1]
        tag: uint128_t = low + x.s
        return tag

    return prologue, epilogue, powers_t, epilogue_in_t


prologue, epilogue, powers_t, epilogue_in_t = make_shared_compute(CAPACITY)
prologue_in_intrf = make_stream_interface(uint130_t)
prologue_out_intrf = make_stream_interface(powers_t)
epilogue_in_intrf = make_stream_interface(epilogue_in_t)
epilogue_out_intrf = make_stream_interface(uint128_t)


def make_mcp_arbiter(func, input_t, output_t, phase):
    """Two requesters, one single-flight MCP; no coupling to the other phase."""
    in_intrf = make_stream_interface(input_t)
    out_intrf = make_stream_interface(output_t)

    @struct
    class tagged_in_t(NamedTuple):
        data: input_t
        is_encrypt: uint1_t

    @struct
    class tagged_out_t(NamedTuple):
        data: output_t
        is_encrypt: uint1_t

    @hw_func
    def tagged_compute(x: tagged_in_t) -> tagged_out_t:
        o: tagged_out_t
        o.data = func(x.data)
        o.is_encrypt = x.is_encrypt
        return o

    mcp, mcp_result_t = make_stream_auto_multi_cycle(
        tagged_compute, start_latency=wireguard_env.START_LATENCIES[f"poly1305_{phase}_shared"]
    )

    @struct
    class result_t(NamedTuple):
        encrypt_in_if: in_intrf.fb_t
        decrypt_in_if: in_intrf.fb_t
        encrypt_out_if: out_intrf.fwd_t
        decrypt_out_if: out_intrf.fwd_t

    arb_tap = f"poly1305.{phase}.arb"
    enc_in_tap, dec_in_tap = f"poly1305.{phase}.enc_in", f"poly1305.{phase}.dec_in"
    enc_out_tap, dec_out_tap = f"poly1305.{phase}.enc_out", f"poly1305.{phase}.dec_out"
    service_in_tap, service_out_tap = f"poly1305.{phase}.service_in", f"poly1305.{phase}.service_out"
    service_state_tap = f"poly1305.{phase}.service"

    @hw_func
    def arbiter(
        encrypt_in_if: in_intrf.fwd_t, decrypt_in_if: in_intrf.fwd_t,
        encrypt_out_if: out_intrf.fb_t, decrypt_out_if: out_intrf.fb_t,
    ) -> result_t:
        result: Feedback[mcp_result_t]
        priority_encrypt: Reg[uint1_t]  # Decrypt wins the first tie.
        grant_stalled: Reg[uint1_t]
        stalled_is_encrypt: Reg[uint1_t]
        busy: Reg[uint1_t]
        enc_valid: uint1_t = encrypt_in_if.stream.valid
        dec_valid: uint1_t = decrypt_in_if.stream.valid
        is_encrypt: uint1_t = priority_encrypt
        o: result_t
        o.encrypt_in_if.ready = 0
        o.decrypt_in_if.ready = 0
        if grant_stalled:
            is_encrypt = stalled_is_encrypt
            if is_encrypt:
                o.encrypt_in_if.ready = result.stream_in_if.ready
            else:
                o.decrypt_in_if.ready = result.stream_in_if.ready
        else:
            if enc_valid & ~dec_valid:
                is_encrypt = 1
            elif dec_valid & ~enc_valid:
                is_encrypt = 0
            o.encrypt_in_if.ready = result.stream_in_if.ready & (priority_encrypt | ~dec_valid)
            o.decrypt_in_if.ready = result.stream_in_if.ready & (~priority_encrypt | ~enc_valid)

        request: mcp.in_intrf.stream_t
        request.data.is_encrypt = is_encrypt
        if is_encrypt:
            request.data.data = encrypt_in_if.stream.data
            request.valid = enc_valid
        else:
            request.data.data = decrypt_in_if.stream.data
            request.valid = dec_valid

        if request.valid & result.stream_in_if.ready:
            priority_encrypt = ~is_encrypt
            grant_stalled = 0
        elif request.valid:
            grant_stalled = 1
            stalled_is_encrypt = is_encrypt

        o.encrypt_out_if.stream.data = result.stream_out_if.stream.data.data
        o.decrypt_out_if.stream.data = result.stream_out_if.stream.data.data
        o.encrypt_out_if.stream.valid = 0
        o.decrypt_out_if.stream.valid = 0
        response_ready: uint1_t = 0
        if result.stream_out_if.stream.valid:
            if result.stream_out_if.stream.data.is_encrypt:
                o.encrypt_out_if.stream.valid = 1
                response_ready = encrypt_out_if.ready
            else:
                o.decrypt_out_if.stream.valid = 1
                response_ready = decrypt_out_if.ready

        # Service occupancy is separate from each MAC's arbitration wait.
        service_state: uint2_t = busy
        if result.stream_out_if.stream.valid:
            service_state = 2
        perf_taps.state(service_state_tap, service_state, ("IDLE", "COMPUTE", "OUTPUT"))
        if result.stream_out_if.stream.valid & response_ready:
            busy = 0
        if request.valid & result.stream_in_if.ready:
            busy = 1

        result = mcp(mcp.in_fwd_t(stream=request), mcp.out_fb_t(ready=response_ready))
        perf_taps.arb(arb_tap, is_encrypt, enc_valid, dec_valid,
                      result.stream_in_if.ready, "encrypt", "decrypt")
        perf_taps.hs(enc_in_tap, enc_valid, o.encrypt_in_if.ready)
        perf_taps.hs(dec_in_tap, dec_valid, o.decrypt_in_if.ready)
        perf_taps.hs(enc_out_tap, o.encrypt_out_if.stream.valid, encrypt_out_if.ready)
        perf_taps.hs(dec_out_tap, o.decrypt_out_if.stream.valid, decrypt_out_if.ready)
        perf_taps.hs(service_in_tap, request.valid, result.stream_in_if.ready)
        perf_taps.hs(service_out_tap, result.stream_out_if.stream.valid, response_ready)
        return o

    arbiter.mcp = mcp.mcp
    return arbiter


prologue_arbiter = make_mcp_arbiter(prologue, uint130_t, powers_t, "prologue")
epilogue_arbiter = make_mcp_arbiter(epilogue, epilogue_in_t, uint128_t, "epilogue")

# Each compound Wire has exactly one forward and one reverse writer.
encrypt_prologue_in_if: Wire[prologue_in_intrf]
decrypt_prologue_in_if: Wire[prologue_in_intrf]
encrypt_prologue_out_if: Wire[prologue_out_intrf]
decrypt_prologue_out_if: Wire[prologue_out_intrf]
encrypt_epilogue_in_if: Wire[epilogue_in_intrf]
decrypt_epilogue_in_if: Wire[epilogue_in_intrf]
encrypt_epilogue_out_if: Wire[epilogue_out_intrf]
decrypt_epilogue_out_if: Wire[epilogue_out_intrf]


@MAIN(wireguard_env.TARGET_MHZ)
def poly1305_prologue_shared():
    o = prologue_arbiter(
        prologue_in_intrf.fwd_t(encrypt_prologue_in_if.stream),
        prologue_in_intrf.fwd_t(decrypt_prologue_in_if.stream),
        prologue_out_intrf.fb_t(encrypt_prologue_out_if.ready),
        prologue_out_intrf.fb_t(decrypt_prologue_out_if.ready),
    )
    encrypt_prologue_in_if.ready = o.encrypt_in_if.ready
    decrypt_prologue_in_if.ready = o.decrypt_in_if.ready
    encrypt_prologue_out_if.stream = o.encrypt_out_if.stream
    decrypt_prologue_out_if.stream = o.decrypt_out_if.stream


@MAIN(wireguard_env.TARGET_MHZ)
def poly1305_epilogue_shared():
    o = epilogue_arbiter(
        epilogue_in_intrf.fwd_t(encrypt_epilogue_in_if.stream),
        epilogue_in_intrf.fwd_t(decrypt_epilogue_in_if.stream),
        epilogue_out_intrf.fb_t(encrypt_epilogue_out_if.ready),
        epilogue_out_intrf.fb_t(decrypt_epilogue_out_if.ready),
    )
    encrypt_epilogue_in_if.ready = o.encrypt_in_if.ready
    decrypt_epilogue_in_if.ready = o.decrypt_in_if.ready
    encrypt_epilogue_out_if.stream = o.encrypt_out_if.stream
    decrypt_epilogue_out_if.stream = o.decrypt_out_if.stream


@struct
class prologue_result_t(NamedTuple):
    stream_in_if: prologue_in_intrf.fb_t
    stream_out_if: prologue_out_intrf.fwd_t


@struct
class epilogue_result_t(NamedTuple):
    stream_in_if: epilogue_in_intrf.fb_t
    stream_out_if: epilogue_out_intrf.fwd_t


@hw_func
def encrypt_prologue_client(stream_in_if: prologue_in_intrf.fwd_t,
                            stream_out_if: prologue_out_intrf.fb_t) -> prologue_result_t:
    encrypt_prologue_in_if.stream = stream_in_if.stream
    encrypt_prologue_out_if.ready = stream_out_if.ready
    return prologue_result_t(prologue_in_intrf.fb_t(encrypt_prologue_in_if.ready),
                             prologue_out_intrf.fwd_t(encrypt_prologue_out_if.stream))


@hw_func
def decrypt_prologue_client(stream_in_if: prologue_in_intrf.fwd_t,
                            stream_out_if: prologue_out_intrf.fb_t) -> prologue_result_t:
    decrypt_prologue_in_if.stream = stream_in_if.stream
    decrypt_prologue_out_if.ready = stream_out_if.ready
    return prologue_result_t(prologue_in_intrf.fb_t(decrypt_prologue_in_if.ready),
                             prologue_out_intrf.fwd_t(decrypt_prologue_out_if.stream))


@hw_func
def encrypt_epilogue_client(stream_in_if: epilogue_in_intrf.fwd_t,
                            stream_out_if: epilogue_out_intrf.fb_t) -> epilogue_result_t:
    encrypt_epilogue_in_if.stream = stream_in_if.stream
    encrypt_epilogue_out_if.ready = stream_out_if.ready
    return epilogue_result_t(epilogue_in_intrf.fb_t(encrypt_epilogue_in_if.ready),
                             epilogue_out_intrf.fwd_t(encrypt_epilogue_out_if.stream))


@hw_func
def decrypt_epilogue_client(stream_in_if: epilogue_in_intrf.fwd_t,
                            stream_out_if: epilogue_out_intrf.fb_t) -> epilogue_result_t:
    decrypt_epilogue_in_if.stream = stream_in_if.stream
    decrypt_epilogue_out_if.ready = stream_out_if.ready
    return epilogue_result_t(epilogue_in_intrf.fb_t(decrypt_epilogue_in_if.ready),
                             epilogue_out_intrf.fwd_t(decrypt_epilogue_out_if.stream))


def _stream_attrs(func, in_intrf, out_intrf, mcp):
    func.in_intrf, func.out_intrf = in_intrf, out_intrf
    func.in_fwd_t, func.out_fb_t = in_intrf.fwd_t, out_intrf.fb_t
    func.mcp = mcp


def make_shared_adapters(direction, lanes, local_powers_t, local_epilogue_in_t):
    """Present private-sized MCP interfaces to the unchanged MAC controller."""
    if lanes > CAPACITY:
        raise ValueError("Shared MCP capacity differs from consumed body latency")
    pro_client = encrypt_prologue_client if direction == "encrypt" else decrypt_prologue_client
    epi_client = encrypt_epilogue_client if direction == "encrypt" else decrypt_epilogue_client
    pro_out = make_stream_interface(local_powers_t)
    epi_in = make_stream_interface(local_epilogue_in_t)

    @struct
    class local_prologue_result_t(NamedTuple):
        stream_in_if: prologue_in_intrf.fb_t
        stream_out_if: pro_out.fwd_t

    @hw_func
    def prologue_adapter(stream_in_if: prologue_in_intrf.fwd_t,
                         stream_out_if: pro_out.fb_t) -> local_prologue_result_t:
        response = pro_client(stream_in_if, prologue_out_intrf.fb_t(stream_out_if.ready))
        o: local_prologue_result_t
        o.stream_in_if = response.stream_in_if
        o.stream_out_if.stream.valid = response.stream_out_if.stream.valid
        for j in range(lanes):
            o.stream_out_if.stream.data.values[j] = response.stream_out_if.stream.data.values[j]
        return o

    @struct
    class local_epilogue_result_t(NamedTuple):
        stream_in_if: epi_in.fb_t
        stream_out_if: epilogue_out_intrf.fwd_t

    @hw_func
    def epilogue_adapter(stream_in_if: epi_in.fwd_t,
                         stream_out_if: epilogue_out_intrf.fb_t) -> local_epilogue_result_t:
        request: epilogue_in_intrf.stream_t
        request.valid = stream_in_if.stream.valid
        request.data.lane_count = lanes
        request.data.next_lane = stream_in_if.stream.data.next_lane
        request.data.s = stream_in_if.stream.data.s
        for j in range(CAPACITY):
            request.data.accumulators[j] = 0
            request.data.powers.values[j] = 0
        for j in range(lanes):
            request.data.accumulators[j] = stream_in_if.stream.data.accumulators[j]
            request.data.powers.values[j] = stream_in_if.stream.data.powers.values[j]
        response = epi_client(epilogue_in_intrf.fwd_t(request), stream_out_if)
        o: local_epilogue_result_t
        o.stream_in_if.ready = response.stream_in_if.ready
        o.stream_out_if = response.stream_out_if
        return o

    _stream_attrs(prologue_adapter, prologue_in_intrf, pro_out, prologue_arbiter.mcp)
    _stream_attrs(epilogue_adapter, epi_in, epilogue_out_intrf, epilogue_arbiter.mcp)
    return prologue_adapter, local_prologue_result_t, epilogue_adapter, local_epilogue_result_t
