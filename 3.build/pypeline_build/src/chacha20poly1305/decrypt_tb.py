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
"""
import random

import pypeline_env  # noqa: F401

from pypeline import MAIN, wires, uint8_t, sim_input, sim_output, sim_print, hex

import chacha20poly1305_decrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
    axis128_frag_t,
    axis128_bus_t,
    axis128_null,
)
from aead_ref_model import generate_encrypt_vector
import tb_common_sim as common

NUM_TOTAL_PACKETS = common.NUM_RANDOM_PACKETS + 1  # + 1 tampered-tag negative test

# Mutable state shared between @sim_input/@sim_output callbacks, only ever
# mutated in place (never rebound) -- see encrypt_tb.py for why.
_dec_state = {
    "rng": None,
    "announced": False,
    "in_packet_idx": 0,
    "in_started": False,
    "in_ciphertext_remaining": None,  # bytes still to stream, or None
    "in_tag_remaining": None,  # bytes (the 16-byte tag word), or None
    "packets": [],  # [{"plaintext","ciphertext","tag","expected_verified"}, ...]
    "printed_gen_count": 0,
    "out_packet_idx": 0,
    "out_remaining": None,  # bytes of plaintext still to check
}


def _build_axis_word(chunk: bytes, eod: int) -> axis128_intrf.fwd_t:
    # Functional (non-mutating) construction -- see encrypt_tb.py.
    data = [0] * 16
    keep = [0] * 16
    for i, b in enumerate(chunk):
        data[i] = b
        keep[i] = 1
    return axis128_intrf.fwd_t(
        stream=axis128_intrf.stream_t(
            data=axis128_frag_t(frag=axis128_bus_t(data=data, keep=keep), eod=[eod]),
            valid=1,
        )
    )


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
def drive_in_word() -> axis128_intrf.fwd_t:
    if _dec_state["rng"] is None:
        _dec_state["rng"] = random.Random(common.DEFAULT_SEED)

    if _dec_state["in_packet_idx"] >= NUM_TOTAL_PACKETS:
        return axis128_null()

    if not _dec_state["in_started"]:
        pkt = _generate_packet(_dec_state["rng"], _dec_state["in_packet_idx"])
        _dec_state["packets"].append(pkt)
        _dec_state["in_ciphertext_remaining"] = pkt["ciphertext"]
        _dec_state["in_tag_remaining"] = None
        _dec_state["in_started"] = True

    if _dec_state["in_ciphertext_remaining"] is not None:
        remaining = _dec_state["in_ciphertext_remaining"]
        chunk = remaining[:16]
        # Ciphertext words never carry eod -- the tag word follows.
        word = _build_axis_word(chunk, eod=0)
        # axis_in_ready is Reg-driven downstream -- stable at cycle start.
        if chacha20poly1305_decrypt_ports.axis_in_ready:
            if len(remaining) <= 16:
                pkt = _dec_state["packets"][_dec_state["in_packet_idx"]]
                _dec_state["in_ciphertext_remaining"] = None
                _dec_state["in_tag_remaining"] = pkt["tag"]
            else:
                _dec_state["in_ciphertext_remaining"] = remaining[16:]
        return word

    # Tag phase: one full 16-byte word, all lanes kept, eod set.
    tag = _dec_state["in_tag_remaining"]
    word = _build_axis_word(tag, eod=1)
    if chacha20poly1305_decrypt_ports.axis_in_ready:
        _dec_state["in_tag_remaining"] = None
        _dec_state["in_started"] = False
        _dec_state["in_packet_idx"] += 1
    return word


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
    while _dec_state["printed_gen_count"] < len(_dec_state["packets"]):
        idx = _dec_state["printed_gen_count"]
        pkt = _dec_state["packets"][idx]
        tamper_note = "" if pkt["expected_verified"] else " [tampered tag, expect reject]"
        sim_print(
            f"Decrypt: Generated packet {idx} ({len(pkt['plaintext'])} bytes){tamper_note}"
        )
        _dec_state["printed_gen_count"] += 1


@sim_output
def check_out():
    out = chacha20poly1305_decrypt_ports.axis_out
    if not out.stream.valid:
        return

    idx = _dec_state["out_packet_idx"]
    if idx >= len(_dec_state["packets"]):
        sim_print(f"ERROR: Decrypt: unexpected output before packet {idx} was generated!")
        return
    pkt = _dec_state["packets"][idx]

    expected_verified = pkt["expected_verified"]
    got_verified = chacha20poly1305_decrypt_ports.is_verified_out
    if got_verified != expected_verified:
        sim_print(
            f"ERROR: Decrypt: is_verified mismatch packet {idx}. expected {expected_verified} got {got_verified}"
        )

    if _dec_state["out_remaining"] is None:
        _dec_state["out_remaining"] = pkt["plaintext"]

    remaining = _dec_state["out_remaining"]
    n = len(remaining)
    for i in range(16):
        expected_keep = 1 if i < n else 0
        got_keep = out.stream.data.frag.keep[i]
        if got_keep != expected_keep:
            sim_print(
                f"ERROR: Decrypt: Plaintext keep mismatch at lane {i} packet {idx}. expected {expected_keep} got {got_keep}"
            )
        if expected_keep:
            expected_byte = remaining[i]
            got_byte = out.stream.data.frag.data[i]
            if got_byte != expected_byte:
                pos = len(pkt["plaintext"]) - n + i
                sim_print(
                    f"ERROR: Decrypt: Plaintext mismatch at byte[{pos}] packet {idx}. expected {hex(expected_byte)} got {hex(got_byte)}"
                )

    if out.stream.data.eod[0]:
        if n > 16:
            sim_print(f"ERROR: Decrypt: Early end to Plaintext output packet {idx}!")
        sim_print(f"Decrypt: Test {idx} DONE!")
        _dec_state["out_packet_idx"] = idx + 1
        _dec_state["out_remaining"] = None
    else:
        if n > 16:
            _dec_state["out_remaining"] = remaining[16:]
        else:
            sim_print(f"ERROR: Decrypt: Plaintext word missing end of packet {idx}!")


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

    chacha20poly1305_decrypt_ports.axis_in = drive_in_word()
    chacha20poly1305_decrypt_ports.axis_out_ready = 1

    announce()
    report_new_packets()
    check_out()

    # dummy return so nothing optimizes away
    return chacha20poly1305_decrypt_ports.axis_out
