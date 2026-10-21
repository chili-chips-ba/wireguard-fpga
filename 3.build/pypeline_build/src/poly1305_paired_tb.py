# pyright: reportInvalidTypeForm=none
"""Native tests for the real paired MAC, authentication formatter and tag path.

pypelinec src/poly1305_paired_tb.py --sim --comb --run all
  -D DATA_BITWIDTH=256 -D PAIRED_TB_MODE=mac|prep|tags
Optional PAIRED_TB_BODY_DEPTH/COEFFICIENT_DEPTH exercise independent latencies.
"""
import os
import sys
import random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env
from pypeline import MAIN, PART, Wire, wires, hw_func, param, sim_input, sim_output, final, sim_finish, uint8_t
from aead_types import (aead_axis_intrf, poly1305_key_stream_intrf, poly1305_auth_tag_stream_intrf,
                        poly1305_auth_tag_uint_t, aad_uint_t)
from axi.axis_sim import ConvergedAxisSimSource, ConvergedAxisSimSink, Scoreboard
from cryptography.hazmat.primitives.poly1305 import Poly1305
from stream import stream_perf_probe as perf_taps

PART("xc7a200tffg1156-2")
MODE = param("PAIRED_TB_MODE", "mac", choices=("mac", "prep", "tags"))
DIRECTION = param("PAIRED_TB_DIRECTION", "encrypt", choices=("encrypt", "decrypt"))
BODY_DEPTH = param("PAIRED_TB_BODY_DEPTH", type=int, choices=(0, 1, 3, 6, 8, 10))
COEFFICIENT_DEPTH = param("PAIRED_TB_COEFFICIENT_DEPTH", type=int, choices=(0, 1, 3, 6, 8, 10))
ARITHMETIC_MODELS = param("PAIRED_TB_ARITHMETIC_MODELS", False,
                          help="native MAC scheduling only: use checked stateless arithmetic models")
if wireguard_env.POLY1305_BLOCKS_PER_CYCLE != 2:
    raise ValueError("Paired testbench requires -D DATA_BITWIDTH=256")

rng = random.Random(8439)
state = {"cycle": 0, "received": 0, "sent_keys": 0, "held_tag": None,
         "run": 0, "longest_run": 0, "launches": 0, "saw_stall": False}
in_if: Wire[aead_axis_intrf]
out_if: Wire[aead_axis_intrf]
key_if: Wire[poly1305_key_stream_intrf]
tag_if: Wire[poly1305_auth_tag_stream_intrf]
extracted_tag_if: Wire[poly1305_auth_tag_stream_intrf]
packed_if: Wire[aead_axis_intrf]
aad_wire: Wire[aad_uint_t]
aad_len_wire: Wire[uint8_t]
source = ConvergedAxisSimSource(aead_axis_intrf, 32)
scoreboard = Scoreboard()
sink = ConvergedAxisSimSink(aead_axis_intrf, 32, scoreboard=scoreboard)

if MODE == "mac":
    perf_taps.REGISTRY.enable(("poly1305.coefficient_in", "poly1305.coefficient_out",
                               "poly1305.to_compute", "poly1305.from_compute",
                               "poly1305.tail_in", "poly1305.data_in", "poly1305.tag_out"))
    if ARITHMETIC_MODELS:
        from native_arithmetic_models import install
        install()
    from poly1305_mac_paired import make_poly1305_mac_paired
    mac = make_poly1305_mac_paired(DIRECTION, body_latency=BODY_DEPTH,
                                   coefficient_latency=COEFFICIENT_DEPTH)
    L = mac.accumulator_count
    lengths = sorted(set(range(1, 4 * L + 2)) | {123, 130, 257})
    keys, expected, block_counts = [], [], []
    for n in lengths:
        for kind in range(4):
            raw_r = (0, 1, (1 << 128) - 1, rng.getrandbits(128))[kind]
            key = raw_r.to_bytes(16, "little") + rng.getrandbits(128).to_bytes(16, "little")
            msg = bytes(rng.randrange(256) for _ in range(n * 16))
            keys.append(int.from_bytes(key, "little"))
            block_counts.append(n)
            expected.append(int.from_bytes(Poly1305.generate_tag(key, msg), "little"))
            source.send(msg)
    repeated_key = bytes(range(32))
    for n, key in ((17, repeated_key), (17, repeated_key),
                   (3, repeated_key[:16] + bytes([255] * 16))):
        msg = bytes(rng.randrange(256) for _ in range(n * 16))
        keys.append(int.from_bytes(key, "little"))
        block_counts.append(n)
        expected.append(int.from_bytes(Poly1305.generate_tag(key, msg), "little"))
        source.send(msg)
    TOTAL = len(expected)
else:
    # Every final beat occupancy, 16/32/64-byte boundaries and the maximum.
    lengths = sorted(set(range(1, 66)) | {127, 128, 129, 2031, 2032})
    cases = []
    if MODE == "prep":
        from prep_auth_data_wide import prep_auth_data_wide
        for aad_len in (0, 1, 15, 16, 17, 31, 32):
            for n in lengths:
                aad = bytes((j * 7 + aad_len) & 255 for j in range(aad_len))
                ct = bytes(rng.randrange(256) for _ in range(n))
                framed = aad + bytes((-aad_len) % 16) + ct + bytes((-n) % 16)
                framed += aad_len.to_bytes(8, "little") + n.to_bytes(8, "little")
                cases.append((aad, ct))
                source.send(ct)
                scoreboard.expect(framed, idx=len(cases)-1)
    else:
        from auth_tag_wide import append_auth_tag_wide, strip_auth_tag_wide
        for n in lengths:
            ct = bytes(rng.randrange(256) for _ in range(n))
            tag = bytes(rng.randrange(256) for _ in range(16))
            cases.append((ct, tag))
            source.send(ct)
            scoreboard.expect(ct, idx=len(cases)-1)
    TOTAL = len(cases)
    state.update({"input_packet": 0, "tags_sent": 0, "tags_received": 0, "packed_received": 0})
    if MODE == "tags":
        packed_scoreboard = Scoreboard()
        packed_sink = ConvergedAxisSimSink(aead_axis_intrf, 32, scoreboard=packed_scoreboard)
        for index, (ct, tag) in enumerate(cases):
            packed_scoreboard.expect(ct + tag, idx=index)


@sim_input
def drive_word() -> aead_axis_intrf.stream_t:
    # Include an unstalled window long enough to demonstrate body II=1.
    paused = (state["cycle"] % 193 < 5) and state["cycle"] < 600
    word = source.drive(paused).stream
    # Non-kept bytes are arbitrary AXIS data. Padding must explicitly clear
    # them, and append/strip must never include them in the packet.
    for j in range(32):
        if not word.data.frag.keep[j]:
            word.data.frag.data[j] = 0xA5
    return word


@sim_input
def drive_key() -> poly1305_key_stream_intrf.stream_t:
    k = state["sent_keys"]
    return poly1305_key_stream_intrf.stream_t(data=keys[k] if k < TOTAL else 0, valid=int(k < TOTAL))


@sim_input
def drive_ready() -> uint8_t:
    return int(state["cycle"] % 79 >= 23)


@sim_output
def check():
    state["cycle"] += 1
    assert state["cycle"] < 100000, "Testbench timed out"
    data = in_if.stream
    accepted = bool(data.valid and in_if.ready)
    source.commit(in_if.ready)
    if MODE == "mac":
        if key_if.stream.valid and key_if.ready:
            state["sent_keys"] += 1
        if accepted and data.data.frag.keep[31]:
            state["run"] += 1
            state["launches"] += 1
            state["longest_run"] = max(state["run"], state["longest_run"])
        else:
            state["run"] = 0
        if state["held_tag"] is not None:
            assert tag_if.stream.valid and tag_if.stream.data == state["held_tag"], "Stalled tag changed"
        if tag_if.stream.valid:
            assert state["received"] < TOTAL, "Extra MAC tag"
            assert tag_if.stream.data == expected[state["received"]], (state["received"], tag_if.stream.data, expected[state["received"]])
        state["held_tag"] = tag_if.stream.data if tag_if.stream.valid and not tag_if.ready else None
        state["saw_stall"] |= state["held_tag"] is not None
        if tag_if.stream.valid and tag_if.ready:
            state["received"] += 1
    else:
        if accepted and data.data.eod[0]:
            state["input_packet"] += 1
        sink.step(aead_axis_intrf.fwd_t(out_if.stream), ready=out_if.ready)
        result = sink.check_nowait()
        if result is not None:
            assert result["passed"], result
            state["received"] += 1
        if MODE == "tags":
            packed_sink.step(aead_axis_intrf.fwd_t(packed_if.stream), ready=packed_if.ready)
            packed_result = packed_sink.check_nowait()
            if packed_result is not None:
                assert packed_result["passed"], packed_result
                state["packed_received"] += 1
            if tag_if.stream.valid and tag_if.ready:
                state["tags_sent"] += 1
            if state["held_tag"] is not None:
                assert extracted_tag_if.stream.valid and extracted_tag_if.stream.data == state["held_tag"], "Stripped tag changed or withdrew valid while stalled"
            if extracted_tag_if.stream.valid:
                tag = int.from_bytes(cases[state["tags_received"]][1], "little")
                assert extracted_tag_if.stream.data == tag, "Stripped tag differs"
                if extracted_tag_if.ready:
                    state["tags_received"] += 1
            state["held_tag"] = int(extracted_tag_if.stream.data) if extracted_tag_if.stream.valid and not extracted_tag_if.ready else None
            state["saw_stall"] |= state["held_tag"] is not None
    if state["received"] == TOTAL:
        if MODE != "tags" or state["tags_received"] == TOTAL:
            sim_finish()


@final(sim=True)
def finish_checks():
    assert state["received"] == TOTAL, state
    if MODE == "mac":
        assert state["sent_keys"] == TOTAL and state["longest_run"] >= 16 and state["saw_stall"], state
        taps = perf_taps.REGISTRY.snapshot()
        prefix = "paired_mac_tb/poly1305."
        expected_pairs = sum(n // 2 for n in block_counts)
        expected_tails = sum(n % 2 for n in block_counts)
        counts = {name: taps[prefix + name]["xfer_cycles"] for name in
                  ("coefficient_in", "coefficient_out", "to_compute", "from_compute", "tail_in", "tag_out")}
        assert all(counts[name] == expected_pairs for name in
                   ("coefficient_in", "coefficient_out", "to_compute", "from_compute")), counts
        assert counts["tail_in"] == expected_tails and counts["tag_out"] == TOTAL, counts
        assert state["launches"] == expected_pairs, state
        assert taps[prefix + "data_in"]["bytes"] == 16 * sum(block_counts), counts
        assert sum(block_counts) == 2 * expected_pairs + expected_tails
        print("Paired conservation: blocks=%d pairs=%d tails=%d counters=%s arithmetic=%s" %
              (sum(block_counts), expected_pairs, expected_tails, counts,
               "checked-stateless-models-v1" if ARITHMETIC_MODELS else "original-hw-functions"))
    if MODE == "tags":
        assert state["tags_received"] == TOTAL and state["tags_sent"] == TOTAL and state["packed_received"] == TOTAL, state
        assert sink.stalled_cycles > 0 and packed_sink.stalled_cycles > 0 and state["saw_stall"], "Did not exercise all three independently stalled outputs"
    print("Paired %s: PASS (%d cases, %d cycles, longest pair run %d)" % (MODE, TOTAL, state["cycle"], state["longest_run"]))


if MODE == "mac":
    @MAIN(wireguard_env.TARGET_MHZ)
    @wires
    def paired_mac_tb() -> poly1305_auth_tag_stream_intrf.fwd_t:
        in_if.stream = drive_word()
        key_if.stream = drive_key()
        tag_if.ready = drive_ready()
        result = mac(key_if=poly1305_key_stream_intrf.fwd_t(key_if.stream),
                     data_in_if=aead_axis_intrf.fwd_t(in_if.stream),
                     auth_tag_if=poly1305_auth_tag_stream_intrf.fb_t(tag_if.ready))
        in_if.ready = result.data_in_if.ready
        key_if.ready = result.key_if.ready
        tag_if.stream = result.auth_tag_if.stream
        check()
        return result.auth_tag_if
elif MODE == "prep":
    from aead_types import aad_uint_t

    @sim_input
    def aad_value() -> aad_uint_t:
        k = min(state["input_packet"], TOTAL - 1)
        return int.from_bytes(cases[k][0], "little")

    @sim_input
    def aad_size() -> uint8_t:
        k = min(state["input_packet"], TOTAL - 1)
        return len(cases[k][0])

    from pypeline import uint_to_array_le

    @MAIN(wireguard_env.TARGET_MHZ)
    @wires
    def paired_prep_tb() -> aead_axis_intrf.fwd_t:
        in_if.stream = drive_word()
        out_if.ready = drive_ready()
        aad_wire = aad_value()
        aad_len_wire = aad_size()
        aad: uint8_t[32] = uint_to_array_le(aad_wire, 8)
        result = prep_auth_data_wide(aad=aad, aad_len=aad_len_wire,
                                    axis_in_if=aead_axis_intrf.fwd_t(in_if.stream),
                                    axis_if=aead_axis_intrf.fb_t(out_if.ready))
        in_if.ready = result.axis_in_if.ready
        out_if.stream = result.axis_if.stream
        check()
        return result.axis_if
else:
    from pypeline import Feedback

    @sim_input
    def drive_tag() -> poly1305_auth_tag_stream_intrf.stream_t:
        k = state["tags_sent"]
        return poly1305_auth_tag_stream_intrf.stream_t(
            data=int.from_bytes(cases[k][1], "little") if k < TOTAL else 0,
            valid=int(k < TOTAL))

    @sim_input
    def drive_tag_ready() -> uint8_t:
        return int(state["cycle"] % 53 >= 41)

    @MAIN(wireguard_env.TARGET_MHZ)
    @wires
    def paired_tags_tb() -> aead_axis_intrf.fwd_t:
        strip_ready: Feedback[aead_axis_intrf.fb_t]
        in_if.stream = drive_word()
        tag_if.stream = drive_tag()
        out_if.ready = drive_ready()
        extracted_tag_if.ready = drive_tag_ready()
        appended = append_auth_tag_wide(aead_axis_intrf.fwd_t(in_if.stream),
                                        poly1305_auth_tag_stream_intrf.fwd_t(tag_if.stream), strip_ready)
        stripped = strip_auth_tag_wide(appended.axis_out_if, aead_axis_intrf.fb_t(out_if.ready),
                                       poly1305_auth_tag_stream_intrf.fb_t(extracted_tag_if.ready))
        strip_ready = stripped.axis_in_if
        packed_if.stream = appended.axis_out_if.stream
        packed_if.ready = stripped.axis_in_if.ready
        in_if.ready = appended.axis_in_if.ready
        tag_if.ready = appended.auth_tag_in_if.ready
        extracted_tag_if.stream = stripped.auth_tag_out_if.stream
        out_if.stream = stripped.axis_out_if.stream
        check()
        return stripped.axis_out_if
