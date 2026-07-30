# pyright: reportInvalidTypeForm=none
"""Non-synthesizable testbench for the standalone decrypt design: generates
10 random-length (1-1024 byte) packets on the fly (ciphertext+tag streamed
in, plaintext + is_verified_out checked at the output), plus an 11th
tampered-tag negative packet (a valid packet with one tag bit flipped after
generation -- DUT must still emit the plaintext but with is_verified_out
low). For the synthesizable-style variant (fixed 8-string vectors + 1 fixed
tampered-tag packet), see decrypt_syn_tb.py.

Only runs under Pypeline's native --sim mode: @sim_input/@sim_output calls
are elaborated away entirely for any real-VHDL path (cocotb+GHDL, real
autopipelining), so this variant has no cocotb/pipe equivalent.

Each packet's ciphertext+tag is computed once, lazily, right when that
packet's random plaintext is generated (aead_ref_model.py, RFC 8439 via the
`cryptography` package) -- not batched at elaboration time. Printing follows
the same "ERROR: ..." / "Decrypt: Test N DONE!" convention as the
synthesizable variant, so the same "no ERROR lines, N DONE lines" pass
criterion applies (N = tb_common_sim.NUM_RANDOM_PACKETS, plus one more for
the tamper packet).

The hand-rolled two-phase (ciphertext-then-tag) input shift register, per-lane
output checker, and ad hoc dict-of-expected-packets this testbench used to
maintain are now the shared `AxisSimSource`/`AxisSimSink`/`Scoreboard`
testbench library (see PipelineC's include/pypeline/axi/axis_sim.py) -- only
the genuinely wireguard-specific bits (lazy packet generation, is_verified
reporting) remain here.
"""
import random

import wireguard_env  # noqa: F401

from pypeline import MAIN, wires, uint8_t, sim_input, sim_output, sim_print, hex

import chacha20poly1305_decrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
)
from axi.axis_sim import AxisSimSource, AxisSimSink, Scoreboard
from aead_ref_model import generate_encrypt_vector
import tb_common_sim as common

NUM_TOTAL_PACKETS = common.NUM_RANDOM_PACKETS + 1  # + 1 tampered-tag negative test

# Mutable state shared between @sim_input/@sim_output callbacks, only ever
# mutated in place (never rebound) -- see encrypt_tb.py for why.
_dec_state = {
    "rng": None,
    "announced": False,
    "in_packet_idx": 0,
    "gen_log": [],  # [(plaintext_len, expected_verified), ...] for reporting only
    "printed_gen_count": 0,
    "out_packet_idx": 0,  # count of packets checked so far; read externally by
    # chacha20poly1305_decrypt_tb.py's finish-checker to know when to sim_finish()
}

_scoreboard = Scoreboard()
_src = AxisSimSource(axis128_intrf, 16)
_snk = AxisSimSink(axis128_intrf, 16, scoreboard=_scoreboard)


def _generate_packet(rng: random.Random, packet_idx: int) -> dict:
    aad_bytes = bytes(common.AAD[: common.AAD_LEN])
    if packet_idx < common.NUM_RANDOM_PACKETS:
        length = common.next_packet_length(rng, packet_idx)
        plaintext = bytes(rng.randrange(256) for _ in range(length))
        ciphertext, tag = generate_encrypt_vector(
            bytes(common.KEY), bytes(common.NONCE), aad_bytes, plaintext
        )
        return {
            "plaintext": plaintext,
            "ciphertext": ciphertext,
            "tag": tag,
            "expected_verified": 1,
        }
    # Tampered-tag negative packet: a genuinely valid packet with one tag
    # bit flipped after generation -- DUT must still emit the plaintext but
    # report is_verified_out low.
    length = rng.randint(common.PACKET_LEN_MIN, common.PACKET_LEN_MAX)
    plaintext = bytes(rng.randrange(256) for _ in range(length))
    ciphertext, tag = generate_encrypt_vector(
        bytes(common.KEY), bytes(common.NONCE), aad_bytes, plaintext
    )
    tampered_tag = bytearray(tag)
    tampered_tag[0] ^= 0x01
    return {
        "plaintext": plaintext,
        "ciphertext": ciphertext,
        "tag": bytes(tampered_tag),
        "expected_verified": 0,
    }


@sim_input
def drive_in_word() -> axis128_intrf.stream_t:
    if _dec_state["rng"] is None:
        _dec_state["rng"] = random.Random(common.DEFAULT_SEED)

    if _dec_state["in_packet_idx"] < NUM_TOTAL_PACKETS and _src.idle():
        idx = _dec_state["in_packet_idx"]
        pkt = _generate_packet(_dec_state["rng"], idx)
        _dec_state["gen_log"].append((len(pkt["plaintext"]), pkt["expected_verified"]))
        _scoreboard.expect(
            pkt["plaintext"], idx=idx, expected_verified=pkt["expected_verified"]
        )
        # The auth tag must always start on a fresh beat, never merged into a
        # partial final ciphertext beat -- pad the ciphertext up to the lane
        # width first, marking the padding not-kept via keep_mask (see
        # make_axis_byte_source's use_keep_mask docstring for why).
        ciphertext = pkt["ciphertext"]
        pad_len = (-len(ciphertext)) % 16
        frame = ciphertext + bytes(pad_len) + pkt["tag"]
        keep_mask = [1] * len(ciphertext) + [0] * pad_len + [1] * len(pkt["tag"])
        _src.send(frame, keep_mask=keep_mask)
        _dec_state["in_packet_idx"] += 1

    # axis_in_ready is Reg-driven downstream (buffer-occupancy-based, not a
    # same-cycle combinational function of this cycle's axis_in.valid), so it
    # already holds a stable value at the start of the cycle -- safe to read
    # directly here to decide whether this word was accepted.
    return _src.step(chacha20poly1305_decrypt_ports.axis_in_if.ready).stream


@sim_output
def announce():
    if not _dec_state["announced"]:
        _dec_state["announced"] = True
        sim_print(
            "=== ChaCha20-Poly1305 Decryption Test (non-synthesizable, on-the-fly random vectors) ==="
        )
        sim_print(f"Decrypt: RNG seed = {common.DEFAULT_SEED}")
        sim_print(f"Decrypt Key: {bytes(common.KEY).hex()}")
        sim_print(f"Decrypt Nonce: {bytes(common.NONCE).hex()}")


@sim_output
def report_new_packets():
    while _dec_state["printed_gen_count"] < len(_dec_state["gen_log"]):
        idx = _dec_state["printed_gen_count"]
        length, expected_verified = _dec_state["gen_log"][idx]
        tamper_note = "" if expected_verified else " [tampered tag, expect reject]"
        sim_print(f"Decrypt: Generated packet {idx} ({length} bytes){tamper_note}")
        _dec_state["printed_gen_count"] += 1


@sim_output
def check_out():
    out = chacha20poly1305_decrypt_ports.axis_out_if.stream
    # is_verified_out rides alongside the whole output packet (constant for
    # its duration), so sampling it once when the frame completes below is
    # equivalent to checking every beat.
    got_verified = chacha20poly1305_decrypt_ports.is_verified_out
    _snk.step(axis128_intrf.fwd_t(stream=out))
    result = _snk.check_nowait()
    if result is None:
        return

    idx = result.get("idx", "?")
    if not result["passed"]:
        if "error" in result:
            sim_print(f"ERROR: Decrypt: {result['error']} (packet {idx})")
        else:
            expected, got = result["expected"], result["got"]
            n = min(len(expected), len(got))
            first_diff = next((i for i in range(n) if expected[i] != got[i]), n)
            sim_print(
                f"ERROR: Decrypt: Plaintext mismatch packet {idx}. expected {len(expected)} bytes got {len(got)} bytes, first differing byte[{first_diff}]"
            )

    expected_verified = result.get("expected_verified")
    if expected_verified is not None and got_verified != expected_verified:
        sim_print(
            f"ERROR: Decrypt: is_verified mismatch packet {idx}. expected {expected_verified} got {got_verified}"
        )

    sim_print(f"Decrypt: Test {idx} DONE!")
    _dec_state["out_packet_idx"] += 1


@MAIN
@wires
def decrypt_tb() -> axis128_intrf.fwd_t:
    key: uint8_t[CHACHA20_KEY_SIZE] = common.KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = common.NONCE
    aad: uint8_t[AAD_MAX_LEN] = common.AAD

    chacha20poly1305_decrypt_ports.key = key
    chacha20poly1305_decrypt_ports.nonce = nonce
    chacha20poly1305_decrypt_ports.aad = aad
    chacha20poly1305_decrypt_ports.aad_len = common.AAD_LEN

    chacha20poly1305_decrypt_ports.axis_in_if.stream = drive_in_word()
    chacha20poly1305_decrypt_ports.axis_out_if.ready = 1

    announce()
    report_new_packets()
    check_out()

    # dummy return so nothing optimizes away
    return axis128_intrf.fwd_t(stream=chacha20poly1305_decrypt_ports.axis_out_if.stream)
