# pyright: reportInvalidTypeForm=none
"""Self-checking standalone Poly1305 testbenches, invoked directly by pypelinec.

MAC tags use cryptography; arithmetic/components use Python integer oracles.
Checks run in native or GHDL simulation. Normal MAC/body builds consume the
discovered automatic latency. WG_POLY1305_TB_BODY_DEPTH inserts real fixed
stages ONLY in an isolated testbench configuration, never production/QoR.

Set WG_POLY1305_TB_MODE=mac|body|arithmetic|components|sharing (default mac), and
WG_POLY1305_TB_DIRECTION=encrypt|decrypt (default encrypt). See src/poly1305/throughput.md
for direct native/GHDL commands and isolated output-directory conventions.
"""
import os
import random
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from cryptography.hazmat.primitives.poly1305 import Poly1305
from pypeline import (
    AUTO_PIPELINE, MAIN, PART, Reg, hw_func, uint1_t, uint8_t, uint32_t,
    array_to_uint_le, make_uint_t, sim_assert, sim_finish,
)
from aead_types import (
    axis128_intrf, poly1305_key_stream_intrf, poly1305_auth_tag_stream_intrf,
)
import poly1305_math as arithmetic
import poly1305_mac_pipelined as design

PART("xc7a200tffg1156-2")
MODE = os.environ.get("WG_POLY1305_TB_MODE", "mac")
DIRECTION = os.environ.get("WG_POLY1305_TB_DIRECTION", "encrypt")
DEPTH = os.environ.get("WG_POLY1305_TB_BODY_DEPTH", "")
if MODE not in ("mac", "body", "arithmetic", "components", "sharing"):
    raise ValueError("Invalid standalone Poly1305 testbench mode")
if DEPTH and (int(DEPTH) not in (0, 1, 3, 6) or MODE in ("arithmetic", "sharing")):
    raise ValueError("Invalid standalone testbench body depth")
P = (1 << 130) - 5
MASK128 = (1 << 128) - 1
MASK320 = (1 << 320) - 1
uint128_t = make_uint_t(128)
uint256_t = make_uint_t(256)
uint260_t = arithmetic.uint260_t
uint320_t = arithmetic.uint320_t
uint130_t = arithmetic.uint130_t

if MODE not in ("arithmetic", "sharing"):
    # Restore the binding immediately; no production source/API/cache edits.
    original_auto_pipeline = design.AUTO_PIPELINE
    try:
        if DEPTH:
            # A fixed-depth stress case replaces, rather than combines with,
            # the production starting guess (fixed latency and hints conflict).
            def fixed_auto_pipeline(func, *, start_latency=None):
                return AUTO_PIPELINE(func, latency=int(DEPTH))
            design.AUTO_PIPELINE = fixed_auto_pipeline
        mac = design.make_poly1305_mac_pipelined(DIRECTION)
    finally:
        design.AUTO_PIPELINE = original_auto_pipeline
    LANES = mac.accumulator_count
    body_pipeline = mac.body_pipeline
    prologue = mac.prologue
    epilogue = mac.epilogue
    epilogue_stream_t = mac.epilogue_mcp.in_intrf.stream_t
    print(f"Poly1305 {MODE} TB: {DIRECTION}, P={mac.body_auto_pipeline.latency}, D=L={LANES}")

if MODE == "sharing":
    import poly1305_mcp_shared as shared

    C = shared.CAPACITY
    REQUESTS = 12
    rng = random.Random(130513)
    CLAMP_MASK = 0x0ffffffc0ffffffc0ffffffc0fffffff
    R = [0, 1, CLAMP_MASK] + [rng.getrandbits(128) & CLAMP_MASK for _ in range(7)]
    R += [R[-1], R[-1]]  # Repeated keys must still run the prologue.
    PRO_R = R + list(reversed(R))
    PRO_EXPECTED = [pow(r, j + 1, P) for r in PRO_R for j in range(C)]
    COUNTS = [(i % C) + 1 for i in range(2 * REQUESTS)]
    NEXT = [i % COUNTS[i] for i in range(2 * REQUESTS)]
    SALTS = [rng.getrandbits(128) for _ in range(2 * REQUESTS)]
    ACCUM = [rng.randrange(P) for _ in range(2 * REQUESTS * C)]
    EPI_POWERS = [pow(PRO_R[i], j + 1, P) for i in range(2 * REQUESTS) for j in range(C)]
    EPI_EXPECTED = [((sum(ACCUM[i * C + j] * EPI_POWERS[i * C + (NEXT[i] - 1 - j) % COUNTS[i]]
                         for j in range(COUNTS[i])) % P) + SALTS[i]) & MASK128
                    for i in range(2 * REQUESTS)]
    PRO_ARRAY_SIZE = 2 * REQUESTS * C

    # A pure five-slot kernel checks the important unequal-lane case without
    # inserting guessed/fixed stages into either production body pipeline.
    pro5, epi5, powers5_t, epi5_in_t = shared.make_shared_compute(5)
    PURE_CASES = [(lanes, q, r) for lanes in (2, 3, 5) for q in range(lanes)
                  for r in (0, 1, CLAMP_MASK, P - 1)]
    PURE_N = len(PURE_CASES)
    PURE_LANES = [x[0] for x in PURE_CASES]
    PURE_NEXT = [x[1] for x in PURE_CASES]
    PURE_R = [x[2] for x in PURE_CASES]
    PURE_S = [rng.getrandbits(128) for _ in PURE_CASES]
    PURE_A = [rng.randrange(P) for _ in range(5 * PURE_N)]
    PURE_POW = [pow(r, j + 1, P) for r in PURE_R for j in range(5)]
    PURE_TAG = [((sum(PURE_A[i * 5 + j] * PURE_POW[i * 5 + (PURE_NEXT[i] - 1 - j) % PURE_LANES[i]]
                         for j in range(PURE_LANES[i])) % P) + PURE_S[i]) & MASK128
                for i in range(PURE_N)]
    PURE_ARRAY_SIZE = 5 * PURE_N

    @hw_func
    def run_testbench() -> uint128_t:
        cycle: Reg[uint32_t]
        sent: Reg[uint32_t[4]]
        received: Reg[uint32_t[4]]
        held: Reg[uint1_t[4]]
        relaunch_seen: Reg[uint1_t]
        independent_seen: Reg[uint1_t]
        stall_seen: Reg[uint1_t]
        pro_launches: Reg[uint32_t]
        last_pro_encrypt: Reg[uint1_t]
        r: uint130_t[2 * REQUESTS] = PRO_R
        expected_powers: uint130_t[PRO_ARRAY_SIZE] = PRO_EXPECTED
        counts: uint32_t[2 * REQUESTS] = COUNTS
        next_lane: uint32_t[2 * REQUESTS] = NEXT
        salts: uint128_t[2 * REQUESTS] = SALTS
        accum: uint130_t[PRO_ARRAY_SIZE] = ACCUM
        epi_powers: uint130_t[PRO_ARRAY_SIZE] = EPI_POWERS
        expected_tags: uint128_t[2 * REQUESTS] = EPI_EXPECTED
        pro_enc: shared.prologue_in_intrf.stream_t
        pro_dec: shared.prologue_in_intrf.stream_t
        epi_enc: shared.epilogue_in_intrf.stream_t
        epi_dec: shared.epilogue_in_intrf.stream_t
        # Early requests stay continuously asserted to check alternating ties;
        # later absolute start times add lone requesters without withdrawing a
        # valid that is stalled. Payload changes only after an input handshake.
        pro_enc.valid = (sent[0] < REQUESTS) & ((sent[0] < 6) | (cycle >= sent[0] * 9))
        pro_dec.valid = (sent[1] < REQUESTS) & ((sent[1] < 6) | (cycle >= sent[1] * 13))
        epi_enc.valid = (sent[2] < REQUESTS) & ((sent[2] < 6) | (cycle >= sent[2] * 11))
        epi_dec.valid = (sent[3] < REQUESTS) & ((sent[3] < 6) | (cycle >= sent[3] * 7))
        pro_enc.data = r[sent[0] % REQUESTS]
        pro_dec.data = r[REQUESTS + sent[1] % REQUESTS]
        enc_index: uint32_t = sent[2] % REQUESTS
        dec_index: uint32_t = REQUESTS + sent[3] % REQUESTS
        epi_enc.data.lane_count = counts[enc_index]
        epi_dec.data.lane_count = counts[dec_index]
        epi_enc.data.next_lane = next_lane[enc_index]
        epi_dec.data.next_lane = next_lane[dec_index]
        epi_enc.data.s = salts[enc_index]
        epi_dec.data.s = salts[dec_index]
        for j in range(C):
            # Inactive slots deliberately contain nonzero values. They must
            # contribute zero even when local lane count is less than capacity.
            epi_enc.data.accumulators[j] = accum[enc_index * C + j]
            epi_dec.data.accumulators[j] = accum[dec_index * C + j]
            epi_enc.data.powers.values[j] = epi_powers[enc_index * C + j]
            epi_dec.data.powers.values[j] = epi_powers[dec_index * C + j]
        # Check the actual production-capacity request arithmetic separately
        # from arbitration/capture, including nonzero inactive slots.
        enc_direct = shared.epilogue(epi_enc.data)
        dec_direct = shared.epilogue(epi_dec.data)
        sim_assert(enc_direct == expected_tags[enc_index], "direct encrypt epilogue mismatch")
        sim_assert(dec_direct == expected_tags[dec_index],
                   f"direct decrypt epilogue mismatch: cycle={cycle}, got={dec_direct}, expected={expected_tags[dec_index]}")
        ready: uint1_t[4]
        ready[0] = (cycle >= 30) & (cycle % 11 >= 4)
        ready[1] = (cycle >= 16) & (cycle % 13 >= 3)
        ready[2] = (cycle >= 12) & (cycle % 7 >= 2)
        ready[3] = (cycle >= 7) & (cycle % 9 >= 2)
        p_enc = shared.encrypt_prologue_client(shared.prologue_in_intrf.fwd_t(pro_enc),
                                               shared.prologue_out_intrf.fb_t(ready[0]))
        p_dec = shared.decrypt_prologue_client(shared.prologue_in_intrf.fwd_t(pro_dec),
                                               shared.prologue_out_intrf.fb_t(ready[1]))
        e_enc = shared.encrypt_epilogue_client(shared.epilogue_in_intrf.fwd_t(epi_enc),
                                               shared.epilogue_out_intrf.fb_t(ready[2]))
        e_dec = shared.decrypt_epilogue_client(shared.epilogue_in_intrf.fwd_t(epi_dec),
                                               shared.epilogue_out_intrf.fb_t(ready[3]))
        launches: uint1_t[4]
        launches[0] = pro_enc.valid & p_enc.stream_in_if.ready
        launches[1] = pro_dec.valid & p_dec.stream_in_if.ready
        launches[2] = epi_enc.valid & e_enc.stream_in_if.ready
        launches[3] = epi_dec.valid & e_dec.stream_in_if.ready
        valid: uint1_t[4]
        valid[0] = p_enc.stream_out_if.stream.valid
        valid[1] = p_dec.stream_out_if.stream.valid
        valid[2] = e_enc.stream_out_if.stream.valid
        valid[3] = e_dec.stream_out_if.stream.valid
        sim_assert(~(launches[0] & launches[1]), "prologue accepted both clients")
        sim_assert(~(launches[2] & launches[3]), "epilogue accepted both clients")
        sim_assert(~(valid[0] & valid[1]), "prologue response delivered twice")
        sim_assert(~(valid[2] & valid[3]), "epilogue response delivered twice")
        if launches[0] | launches[1]:
            if pro_launches == 0:
                sim_assert(launches[1], "initial tied grant did not go to decrypt")
            elif (sent[0] < 6) & (sent[1] < 6):
                sim_assert(launches[0] != last_pro_encrypt, "continuous ties did not alternate")
            last_pro_encrypt = launches[0]
            pro_launches += 1
        for j in range(C):
            if valid[0]:
                sim_assert(p_enc.stream_out_if.stream.data.values[j] == expected_powers[(received[0] % REQUESTS) * C + j],
                           "encrypt prologue ordering/data/stability mismatch")
            if valid[1]:
                sim_assert(p_dec.stream_out_if.stream.data.values[j] == expected_powers[(REQUESTS + received[1] % REQUESTS) * C + j],
                           "decrypt prologue ordering/data/stability mismatch")
        if valid[2]:
            sim_assert(e_enc.stream_out_if.stream.data == expected_tags[received[2] % REQUESTS],
                       "encrypt epilogue ownership/rotation/stability mismatch")
        if valid[3]:
            sim_assert(e_dec.stream_out_if.stream.data == expected_tags[REQUESTS + received[3] % REQUESTS],
                       f"decrypt epilogue ownership/rotation/stability mismatch: cycle={cycle}, response={received[3]}, got={e_dec.stream_out_if.stream.data}, expected={expected_tags[REQUESTS + received[3] % REQUESTS]}")
        if ((valid[2] & ready[2]) | (valid[3] & ready[3])) & (received[0] + received[1] == 0):
            independent_seen = 1
        if ((launches[0] | launches[1]) & ((valid[0] & ready[0]) | (valid[1] & ready[1]))) | (
            (launches[2] | launches[3]) & ((valid[2] & ready[2]) | (valid[3] & ready[3]))):
            relaunch_seen = 1
        for i in range(4):
            if held[i]:
                sim_assert(valid[i], "shared MCP withdrew a stalled response")
            held[i] = valid[i] & ~ready[i]
            if held[i]:
                stall_seen = 1
            if valid[i]:
                sim_assert(received[i] < sent[i], "response without a matching accepted request")
            if launches[i]:
                sent[i] += 1
            if valid[i] & ready[i]:
                received[i] += 1

        pure_counts: uint32_t[PURE_N] = PURE_LANES
        pure_next: uint32_t[PURE_N] = PURE_NEXT
        pure_r: uint130_t[PURE_N] = PURE_R
        pure_s: uint128_t[PURE_N] = PURE_S
        pure_a: uint130_t[PURE_ARRAY_SIZE] = PURE_A
        pure_pow: uint130_t[PURE_ARRAY_SIZE] = PURE_POW
        pure_tag: uint128_t[PURE_N] = PURE_TAG
        idx: uint32_t = cycle % PURE_N
        x: epi5_in_t
        x.lane_count = pure_counts[idx]
        x.next_lane = pure_next[idx]
        x.s = pure_s[idx]
        for j in range(5):
            x.accumulators[j] = pure_a[idx * 5 + j]
            x.powers.values[j] = pure_pow[idx * 5 + j]
        tag = epi5(x)
        power = pro5(pure_r[idx])
        sim_assert(tag == pure_tag[idx], "unequal-lane shared epilogue mismatch")
        for j in range(5):
            sim_assert(power.values[j] == pure_pow[idx * 5 + j], "shared power graph mismatch")
        if (received[0] == REQUESTS) & (received[1] == REQUESTS) & (
            received[2] == REQUESTS) & (received[3] == REQUESTS) & (cycle >= PURE_N):
            sim_assert(relaunch_seen & independent_seen & stall_seen,
                       "directed sharing scenarios were not all exercised")
            sim_finish()
        sim_assert(cycle < 1000, "shared MCP testbench timed out/starved")
        cycle += 1
        return tag

elif MODE == "mac":
    counts = sorted(set(range(1, 2 * LANES + 2)) | {4 * LANES + 1})
    rng = random.Random(8439)
    key_bytes = [bytes(32), (1).to_bytes(16, "little") + bytes([255] * 16),
                 bytes([255] * 32), rng.getrandbits(256).to_bytes(32, "little")]
    cases = [(n, key, k == 2, 40 if k == 3 else 7)
             for n in counts for k, key in enumerate(key_bytes)]
    repeated_key = bytes(range(32))
    cases += [(17, repeated_key, False, 40), (17, repeated_key, True, 40),
              (3, repeated_key[:16] + bytes([255] * 16), True, 40)]
    COUNTS = [case[0] for case in cases]
    KEYS = [int.from_bytes(case[1], "little") for case in cases]
    GAPS = [int(case[2]) for case in cases]
    STALLS = [case[3] for case in cases]
    EXPECTED = []
    for index, (count, key, _, _) in enumerate(cases):
        message = bytes((block * 17 + byte + index) & 255
                        for block in range(count) for byte in range(16))
        EXPECTED.append(int.from_bytes(Poly1305.generate_tag(key, message), "little"))
    NUM_CASES = len(cases)
    MAX_CYCLES = 4 * sum(n + LANES + mac.prologue_mcp.mcp.latency
                         + mac.epilogue_mcp.mcp.latency + stall + 32
                         for n, _, _, stall in cases)

    @hw_func
    def run_testbench() -> uint128_t:
        keys: uint256_t[NUM_CASES] = KEYS
        counts: uint32_t[NUM_CASES] = COUNTS
        tags: uint128_t[NUM_CASES] = EXPECTED
        gaps: uint1_t[NUM_CASES] = GAPS
        stalls: uint32_t[NUM_CASES] = STALLS
        packet: Reg[uint32_t]
        block_index: Reg[uint32_t]
        key_sent: Reg[uint1_t]
        cycle: Reg[uint32_t]
        last_launch: Reg[uint32_t]
        tag_stalls: Reg[uint32_t]
        held_tag: Reg[uint128_t]
        held_valid: Reg[uint1_t]
        gap: uint1_t = gaps[packet] & ((cycle % 5 == 1) | (cycle % 5 == 2))
        key_stream: poly1305_key_stream_intrf.stream_t
        key_stream.data = keys[packet]
        key_stream.valid = 1  # Offer another key while busy; it must not be accepted.
        data_stream: axis128_intrf.stream_t
        data_stream.valid = key_sent & (block_index < counts[packet]) & ~gap
        data_stream.data.eod[0] = block_index == counts[packet] - 1
        for j in range(16):
            value: uint8_t = block_index * 17 + j + packet
            data_stream.data.frag.data[j] = value
            data_stream.data.frag.keep[j] = 1
        tag_ready: uint1_t = tag_stalls >= stalls[packet]
        o = mac(poly1305_key_stream_intrf.fwd_t(stream=key_stream),
                axis128_intrf.fwd_t(stream=data_stream),
                poly1305_auth_tag_stream_intrf.fb_t(ready=tag_ready))
        if key_sent:
            sim_assert(~o.key_if.ready, "accepted another key before tag completion")
        if o.key_if.ready:
            key_sent = 1
        if data_stream.valid & o.data_in_if.ready:
            if ~gaps[packet] & (block_index > 0):
                sim_assert(cycle == last_launch + 1, "body inserted a bubble")
            last_launch = cycle
            block_index += 1
        if o.auth_tag_if.stream.valid:
            sim_assert(block_index == counts[packet], "tag arrived before all input blocks")
            sim_assert(cycle > last_launch + LANES, "tag observed unfinished body results")
            sim_assert(o.auth_tag_if.stream.data == tags[packet], "Poly1305 reference tag mismatch")
            if held_valid:
                sim_assert(o.auth_tag_if.stream.data == held_tag, "tag changed while stalled")
            held_tag = o.auth_tag_if.stream.data
            held_valid = 1
            if tag_ready:
                if packet == NUM_CASES - 1:
                    sim_finish()
                else:
                    packet += 1
                    block_index = 0
                    key_sent = 0
                    tag_stalls = 0
                    held_valid = 0
            else:
                tag_stalls += 1
        sim_assert(cycle < MAX_CYCLES, "standalone MAC timed out")
        cycle += 1
        return o.auth_tag_if.stream.data

elif MODE == "body":
    NUM_CASES = 64
    rng = random.Random(26)
    A = [rng.randrange(P) for _ in range(NUM_CASES)]
    B = [rng.randrange(P) for _ in range(NUM_CASES)]
    RAW = [rng.getrandbits(128) for _ in range(NUM_CASES)]
    EXPECTED = [(a * b + raw + (1 << 128)) % P for a, b, raw in zip(A, B, RAW)]

    @hw_func
    def run_testbench() -> uint128_t:
        a: uint130_t[NUM_CASES] = A
        b: uint130_t[NUM_CASES] = B
        raw: uint128_t[NUM_CASES] = RAW
        expected: uint130_t[NUM_CASES] = EXPECTED
        cycle: Reg[uint32_t]
        x: design.body_in_stream_t
        x.valid = (cycle < NUM_CASES) & (cycle % 5 != 2)
        index: uint32_t = cycle % NUM_CASES
        x.data.accumulator = a[index]
        x.data.stride = b[index]
        for j in range(16):
            x.data.block[j] = raw[index] >> (8 * j)
        o = body_pipeline(x)
        issued: uint32_t = cycle - LANES
        valid: uint1_t = (cycle >= LANES) & (issued < NUM_CASES) & (issued % 5 != 2)
        sim_assert(o.valid == valid, "body valid/bubble latency differs from D")
        if valid:
            sim_assert(o.data == expected[issued % NUM_CASES], "body arithmetic/ordering mismatch")
        if cycle == NUM_CASES + LANES:
            sim_finish()
        cycle += 1
        return o.data

elif MODE == "arithmetic":
    rng = random.Random(84391305)
    boundaries = [0, 1, P - 1, P, P + 1, 2 * P - 1, 2 * P, 2 * P + 1,
                  (1 << 130) - 1, 1 << 130, (1 << 260) - 1, MASK320]
    reductions = boundaries + [rng.getrandbits(320) for _ in range(100)]
    narrow = boundaries[:-1] + [rng.getrandbits(260) for _ in range(200)]
    mul = [((1 << 64) - 1, (1 << 64) - 1), (P - 1, P - 1),
           (1 << 128, 1 << 129), (MASK320, MASK320)]
    mul += [(rng.getrandbits(130), rng.getrandbits(130)) for _ in range(60)]
    add = [((1 << 64) - 1, 1), (P - 1, P - 1), (MASK320, 1)]
    add += [(rng.getrandbits(320), rng.getrandbits(320)) for _ in range(60)]
    edges = [0, 1, P - 1, P, P + 1, (1 << 130) - 1]
    triples = [(a, b, c) for a in edges for b in edges for c in (0, edges[-1])]
    triples += [tuple(rng.getrandbits(130) for _ in range(3)) for _ in range(100)]
    NUM_CASES = max(map(len, (reductions, narrow, mul, add, triples)))
    RED = [reductions[i % len(reductions)] for i in range(NUM_CASES)]
    NARROW = [narrow[i % len(narrow)] for i in range(NUM_CASES)]
    MA = [mul[i % len(mul)][0] for i in range(NUM_CASES)]
    MB = [mul[i % len(mul)][1] for i in range(NUM_CASES)]
    AA = [add[i % len(add)][0] for i in range(NUM_CASES)]
    AB = [add[i % len(add)][1] for i in range(NUM_CASES)]
    A = [triples[i % len(triples)][0] for i in range(NUM_CASES)]
    B = [triples[i % len(triples)][1] for i in range(NUM_CASES)]
    C = [triples[i % len(triples)][2] for i in range(NUM_CASES)]
    ER = [x % P for x in RED]
    EN = [x % P for x in NARROW]
    EM = [(a * b) & MASK320 for a, b in zip(MA, MB)]
    EA = [(a + b) & MASK320 for a, b in zip(AA, AB)]
    ERM = [(a * b) % P for a, b in zip(A, B)]
    ERMA = [(a * b + c) % P for a, b, c in zip(A, B, C)]
    ERA = [(a + b) % P for a, b in zip(A, B)]

    @hw_func
    def limbs(x: uint320_t) -> arithmetic.u320_t:
        o: arithmetic.u320_t
        for j in range(5):
            o.limbs[j] = x >> (64 * j)
        return o

    @hw_func
    def run_testbench() -> uint128_t:
        red: uint320_t[NUM_CASES] = RED
        narrow: uint260_t[NUM_CASES] = NARROW
        ma: uint320_t[NUM_CASES] = MA
        mb: uint320_t[NUM_CASES] = MB
        aa: uint320_t[NUM_CASES] = AA
        ab: uint320_t[NUM_CASES] = AB
        a: uint130_t[NUM_CASES] = A
        b: uint130_t[NUM_CASES] = B
        c: uint130_t[NUM_CASES] = C
        er: uint130_t[NUM_CASES] = ER
        en: uint130_t[NUM_CASES] = EN
        em: uint320_t[NUM_CASES] = EM
        ea: uint320_t[NUM_CASES] = EA
        erm: uint130_t[NUM_CASES] = ERM
        erma: uint130_t[NUM_CASES] = ERMA
        era: uint130_t[NUM_CASES] = ERA
        i: Reg[uint32_t]
        reduced = arithmetic.uint320_mod_prime(limbs(red[i]))
        multiplied = arithmetic.uint320_mul(limbs(ma[i]), limbs(mb[i]))
        added = arithmetic.uint320_add(limbs(aa[i]), limbs(ab[i]))
        sim_assert(array_to_uint_le(reduced.limbs) == er[i], "320-bit reduction mismatch")
        sim_assert(array_to_uint_le(multiplied.limbs) == em[i], "limb multiplication/carry mismatch")
        sim_assert(array_to_uint_le(added.limbs) == ea[i], "limb addition/carry mismatch")
        sim_assert(arithmetic.uint260_mod_prime(narrow[i]) == en[i], "260-bit reduction mismatch")
        sim_assert(arithmetic.residue_mul_mod(a[i], b[i]) == erm[i], "residue multiply mismatch")
        sim_assert(arithmetic.residue_mul_add_mod(a[i], b[i], c[i]) == erma[i], "residue multiply-add mismatch")
        sim_assert(arithmetic.residue_add_mod(a[i], b[i]) == era[i], "residue add mismatch")
        if i == NUM_CASES - 1:
            sim_finish()
        i += 1
        return reduced.limbs[0]

else:  # Pure production prologue/epilogue with arbitrary full-width residues.
    rng = random.Random(84391305)
    NUM_CASES = 10 * LANES
    NEXT = [i % LANES for i in range(NUM_CASES)]
    ACCUM = [rng.randrange(P) for _ in range(NUM_CASES * LANES)]
    POWERS = [rng.randrange(P) for _ in range(NUM_CASES * LANES)]
    SALTS = [rng.getrandbits(128) for _ in range(NUM_CASES)]
    R = [0, 1, P - 1] + [rng.randrange(P) for _ in range(NUM_CASES - 3)]
    EXPECTED_POWERS = [pow(r, j + 1, P) for r in R for j in range(LANES)]
    EXPECTED = [((sum(ACCUM[i * LANES + j] * POWERS[i * LANES + (NEXT[i] - 1 - j) % LANES]
                         for j in range(LANES)) % P) + SALTS[i]) & MASK128
                for i in range(NUM_CASES)]
    ARRAY_SIZE = NUM_CASES * LANES

    @hw_func
    def run_testbench() -> uint128_t:
        accum: uint130_t[ARRAY_SIZE] = ACCUM
        powers: uint130_t[ARRAY_SIZE] = POWERS
        salts: uint128_t[NUM_CASES] = SALTS
        next_lane: uint32_t[NUM_CASES] = NEXT
        r: uint130_t[NUM_CASES] = R
        expected_powers: uint130_t[ARRAY_SIZE] = EXPECTED_POWERS
        expected: uint128_t[NUM_CASES] = EXPECTED
        i: Reg[uint32_t]
        x: epilogue_stream_t
        x.data.next_lane = next_lane[i]
        x.data.s = salts[i]
        for j in range(LANES):
            x.data.accumulators[j] = accum[i * LANES + j]
            x.data.powers.values[j] = powers[i * LANES + j]
        tag = epilogue(x.data)
        computed_powers = prologue(r[i])
        sim_assert(tag == expected[i], "rotated full-width epilogue mismatch")
        for j in range(LANES):
            sim_assert(computed_powers.values[j] == expected_powers[i * LANES + j], "prologue powers mismatch")
        if i == NUM_CASES - 1:
            sim_finish()
        i += 1
        return tag


@MAIN(wireguard_env.TARGET_MHZ)
def poly1305_pipelined_syn_tb() -> uint128_t:
    return run_testbench()
