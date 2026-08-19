# pyright: reportInvalidTypeForm=none
"""Non-synthesizable testbench for the standalone encrypt design: generates
10 random-length (1-1024 byte) plaintext packets on the fly, during live
simulation, using Python's `random` (default-seeded, seed printed for
replayability) and streams/checks them via @sim_input/@sim_output -- no
fixed-size hardware register arrays, no elaboration-time pre-baking. For the
synthesizable-style variant (fixed 8-string vectors), see encrypt_syn_tb.py.

Only runs under Pypeline's native --sim mode: @sim_input/@sim_output calls
are elaborated away entirely for any real-VHDL path (cocotb+GHDL, real
autopipelining), so this variant has no cocotb/pipe equivalent.

Each packet's expected ciphertext + auth tag is computed once, lazily, right
when that packet's random plaintext is generated (aead_ref_model.py, RFC
8439 via the `cryptography` package) -- not batched at elaboration time.
Printing follows the same "ERROR: ..." / "Encrypt: Test N DONE!" convention
as the synthesizable variant, so the same "no ERROR lines, N DONE lines"
pass criterion applies (N = tb_common_sim.NUM_RANDOM_PACKETS).

The hand-rolled input shift register, per-lane output checker, and ad hoc
dict-of-expected-packets this testbench used to maintain are now the shared
`AxisSimSource`/`AxisSimSink`/`Scoreboard` testbench library (see
PipelineC's include/pypeline/axi/axis_sim.py) -- only the genuinely
wireguard-specific bits (lazy packet generation, the reference ciphertext+tag
computation) remain here.
"""
import random

import wireguard_env  # noqa: F401

from pypeline import MAIN, wires, uint8_t, sim_input, sim_output, sim_print, hex

import chacha20poly1305_encrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
)
from axi.axis_sim import AxisSimSource, AxisSimSink, Scoreboard
from aead_ref_model import generate_encrypt_vector
import tb_common_sim as common

# Mutable state shared between @sim_input/@sim_output callbacks, only ever
# mutated in place (never rebound) -- @sim_input/@sim_output bodies run
# against a detached snapshot of module globals, so rebinding a plain
# module-level name would not be visible across calls.
_enc_state = {
    "rng": None,
    "announced": False,
    "in_packet_idx": 0,
    "gen_log": [],  # plaintext lengths, in generation order (for reporting only)
    "printed_gen_count": 0,
    "out_packet_idx": 0,  # count of packets checked so far; read externally by
    # chacha20poly1305_encrypt_tb.py's finish-checker to know when to sim_finish()
}

_scoreboard = Scoreboard()
_src = AxisSimSource(axis128_intrf, 16)
_snk = AxisSimSink(axis128_intrf, 16, scoreboard=_scoreboard)


@sim_input
def drive_in_word() -> axis128_intrf.stream_t:
    if _enc_state["rng"] is None:
        _enc_state["rng"] = random.Random(common.DEFAULT_SEED)

    if _enc_state["in_packet_idx"] < common.NUM_RANDOM_PACKETS and _src.idle():
        # Starting a new packet: pick its length (stratified corner cases
        # first, then uniform-random), generate random plaintext, and
        # compute the reference ciphertext+tag right now, once, lazily.
        idx = _enc_state["in_packet_idx"]
        length = common.next_packet_length(_enc_state["rng"], idx)
        plaintext = bytes(_enc_state["rng"].randrange(256) for _ in range(length))
        aad_bytes = bytes(common.AAD[: common.AAD_LEN])
        ciphertext, tag = generate_encrypt_vector(
            bytes(common.KEY), bytes(common.NONCE), aad_bytes, plaintext
        )
        _enc_state["gen_log"].append(length)
        _scoreboard.expect(ciphertext + tag, idx=idx)
        _src.send(plaintext)
        _enc_state["in_packet_idx"] += 1

    # axis_in_ready is Reg-driven downstream (buffer-occupancy-based, not a
    # same-cycle combinational function of this cycle's axis_in.valid), so
    # it already holds a stable value at the start of the cycle -- safe to
    # read directly here to decide whether this word was accepted.
    return _src.step(chacha20poly1305_encrypt_ports.axis_in_if.ready).stream


@sim_output
def announce():
    if not _enc_state["announced"]:
        _enc_state["announced"] = True
        sim_print(
            "=== ChaCha20-Poly1305 Encryption Test (non-synthesizable, on-the-fly random vectors) ==="
        )
        sim_print(f"Encrypt: RNG seed = {common.DEFAULT_SEED}")
        sim_print(f"Encrypt Key: {bytes(common.KEY).hex()}")
        sim_print(f"Encrypt Nonce: {bytes(common.NONCE).hex()}")


@sim_output
def report_new_packets():
    while _enc_state["printed_gen_count"] < len(_enc_state["gen_log"]):
        idx = _enc_state["printed_gen_count"]
        length = _enc_state["gen_log"][idx]
        sim_print(f"Encrypt: Generated packet {idx} ({length} bytes)")
        _enc_state["printed_gen_count"] += 1


@sim_output
def check_out():
    _snk.step(axis128_intrf.fwd_t(chacha20poly1305_encrypt_ports.axis_out_if.stream))
    result = _snk.check_nowait()
    if result is None:
        return

    idx = result.get("idx", "?")
    if not result["passed"]:
        if "error" in result:
            sim_print(f"ERROR: Encrypt: {result['error']} (packet {idx})")
        else:
            expected, got = result["expected"], result["got"]
            n = min(len(expected), len(got))
            first_diff = next((i for i in range(n) if expected[i] != got[i]), n)
            sim_print(
                f"ERROR: Encrypt: Ciphertext/Tag mismatch packet {idx}. expected {len(expected)} bytes got {len(got)} bytes, first differing byte[{first_diff}]"
            )
    sim_print(f"Encrypt: Test {idx} DONE!")
    _enc_state["out_packet_idx"] += 1


@MAIN
@wires
def encrypt_tb() -> axis128_intrf.fwd_t:
    key: uint8_t[CHACHA20_KEY_SIZE] = common.KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = common.NONCE
    aad: uint8_t[AAD_MAX_LEN] = common.AAD

    chacha20poly1305_encrypt_ports.key = key
    chacha20poly1305_encrypt_ports.nonce = nonce
    chacha20poly1305_encrypt_ports.aad = aad
    chacha20poly1305_encrypt_ports.aad_len = common.AAD_LEN

    chacha20poly1305_encrypt_ports.axis_in_if.stream = drive_in_word()
    chacha20poly1305_encrypt_ports.axis_out_if.ready = 1

    announce()
    report_new_packets()
    check_out()

    # dummy return so nothing optimizes away
    return axis128_intrf.fwd_t(chacha20poly1305_encrypt_ports.axis_out_if.stream)
