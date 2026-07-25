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
"""
import random

import pypeline_env  # noqa: F401

from pypeline import MAIN, wires, uint8_t, sim_input, sim_output, sim_print, hex

import chacha20poly1305_encrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_t,
    axis128_frag_t,
    axis128_bus_t,
    axis128_null,
)
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
    "in_plaintext": None,  # bytes remaining to stream for the current packet
    "packets": [],  # [{"plaintext","ciphertext","tag"}, ...] as generated
    "printed_gen_count": 0,
    "out_packet_idx": 0,
    "out_remaining": None,  # bytes of ciphertext still to check
    "out_tag_phase": False,
}


def _build_axis_word(chunk: bytes, eod: int) -> axis128_t:
    # Functional (non-mutating) construction: @sim_input/@sim_output bodies
    # run as plain Python, without the struct-field-mutation AST rewrite
    # @MAIN/@hw_func bodies get, so build a fresh struct rather than
    # mutating axis128_null()'s (immutable) result in place.
    data = [0] * 16
    keep = [0] * 16
    for i, b in enumerate(chunk):
        data[i] = b
        keep[i] = 1
    return axis128_t(
        stream=axis128_t.typeof("stream")(
            data=axis128_frag_t(frag=axis128_bus_t(data=data, keep=keep), eod=[eod]),
            valid=1,
        )
    )


@sim_input
def drive_in_word() -> axis128_t:
    if _enc_state["rng"] is None:
        _enc_state["rng"] = random.Random(common.DEFAULT_SEED)

    if _enc_state["in_packet_idx"] >= common.NUM_RANDOM_PACKETS:
        return axis128_null()

    if _enc_state["in_plaintext"] is None:
        # Starting a new packet: pick its length (stratified corner cases
        # first, then uniform-random), generate random plaintext, and
        # compute the reference ciphertext+tag right now, once, lazily.
        length = common.next_packet_length(_enc_state["rng"], _enc_state["in_packet_idx"])
        plaintext = bytes(_enc_state["rng"].randrange(256) for _ in range(length))
        aad_bytes = bytes(common.AAD[: common.AAD_LEN])
        ciphertext, tag = generate_encrypt_vector(
            bytes(common.KEY), bytes(common.NONCE), aad_bytes, plaintext
        )
        _enc_state["packets"].append(
            {"plaintext": plaintext, "ciphertext": ciphertext, "tag": tag}
        )
        _enc_state["in_plaintext"] = plaintext

    remaining = _enc_state["in_plaintext"]
    chunk = remaining[:16]
    eod = 1 if len(remaining) <= 16 else 0
    word = _build_axis_word(chunk, eod)

    # axis_in_ready is Reg-driven downstream (buffer-occupancy-based, not a
    # same-cycle combinational function of this cycle's axis_in.valid), so
    # it already holds a stable value at the start of the cycle -- safe to
    # read directly here to decide whether this word was accepted.
    if chacha20poly1305_encrypt_ports.axis_in_ready:
        if len(remaining) <= 16:
            _enc_state["in_plaintext"] = None
            _enc_state["in_packet_idx"] += 1
        else:
            _enc_state["in_plaintext"] = remaining[16:]

    return word


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
    while _enc_state["printed_gen_count"] < len(_enc_state["packets"]):
        idx = _enc_state["printed_gen_count"]
        length = len(_enc_state["packets"][idx]["plaintext"])
        sim_print(f"Encrypt: Generated packet {idx} ({length} bytes)")
        _enc_state["printed_gen_count"] += 1


@sim_output
def check_out():
    out = chacha20poly1305_encrypt_ports.axis_out
    if not out.stream.valid:
        return

    idx = _enc_state["out_packet_idx"]
    if idx >= len(_enc_state["packets"]):
        sim_print(f"ERROR: Encrypt: unexpected output before packet {idx} was generated!")
        return
    pkt = _enc_state["packets"][idx]

    if _enc_state["out_remaining"] is None:
        _enc_state["out_remaining"] = pkt["ciphertext"]
        _enc_state["out_tag_phase"] = False

    if not _enc_state["out_tag_phase"]:
        remaining = _enc_state["out_remaining"]
        n = len(remaining)
        for i in range(16):
            expected_keep = 1 if i < n else 0
            got_keep = out.stream.data.frag.keep[i]
            if got_keep != expected_keep:
                sim_print(
                    f"ERROR: Encrypt: Ciphertext keep mismatch at lane {i} packet {idx}. expected {expected_keep} got {got_keep}"
                )
            if expected_keep:
                expected_byte = remaining[i]
                got_byte = out.stream.data.frag.data[i]
                if got_byte != expected_byte:
                    pos = len(pkt["ciphertext"]) - n + i
                    sim_print(
                        f"ERROR: Encrypt: Ciphertext mismatch at byte[{pos}] packet {idx}. expected {hex(expected_byte)} got {hex(got_byte)}"
                    )
        if out.stream.data.eod[0]:
            sim_print(f"ERROR: Encrypt: Early end to ciphertext output packet {idx} (before auth tag)!")
        if n > 16:
            _enc_state["out_remaining"] = remaining[16:]
        else:
            _enc_state["out_remaining"] = b""
            _enc_state["out_tag_phase"] = True
    else:
        tag = pkt["tag"]
        for i in range(16):
            if not out.stream.data.frag.keep[i]:
                sim_print(f"ERROR: Encrypt: Auth tag keep not set at lane {i} packet {idx}!")
            if out.stream.data.frag.data[i] != tag[i]:
                sim_print(
                    f"ERROR: Encrypt: Auth tag mismatch at byte[{i}] packet {idx}. expected {hex(tag[i])} got {hex(out.stream.data.frag.data[i])}"
                )
        if not out.stream.data.eod[0]:
            sim_print(f"ERROR: Encrypt: Auth tag word missing end of packet {idx}!")
        sim_print(f"Encrypt: Test {idx} DONE!")
        _enc_state["out_packet_idx"] = idx + 1
        _enc_state["out_remaining"] = None
        _enc_state["out_tag_phase"] = False


@MAIN
@wires
def encrypt_tb() -> axis128_t:
    key: uint8_t[CHACHA20_KEY_SIZE] = common.KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = common.NONCE
    aad: uint8_t[AAD_MAX_LEN] = common.AAD

    chacha20poly1305_encrypt_ports.key = key
    chacha20poly1305_encrypt_ports.nonce = nonce
    chacha20poly1305_encrypt_ports.aad = aad
    chacha20poly1305_encrypt_ports.aad_len = common.AAD_LEN

    chacha20poly1305_encrypt_ports.axis_in = drive_in_word()
    chacha20poly1305_encrypt_ports.axis_out_ready = 1

    announce()
    report_new_packets()
    check_out()

    # dummy return so nothing optimizes away
    return chacha20poly1305_encrypt_ports.axis_out
