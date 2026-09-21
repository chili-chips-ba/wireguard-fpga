# pyright: reportInvalidTypeForm=none
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Decrypt-side PERFORMANCE testbench: the mirror of encrypt_perf_tb.py --
streams ciphertext+tag frames for the perf_tb_common.py phase plan and measures
duty cycle, per-packet latency and window cycles on the decrypt datapath.

Only valid (verifiable) packets are measured, and `is_verified_out` must be 1
for every one of them; the tampered-tag negative case stays in decrypt_tb.py /
decrypt_syn_tb.py, where it cannot perturb a timing window.

Note the decrypt input frame carries 16 bytes of auth tag on top of the
plaintext length, so its line bytes exceed the encrypt side's for the same
goodput -- perf_probe.py records goodput and line bytes separately rather than
averaging the asymmetry away.

Only runs under Pypeline's native --sim mode (`./build.py --shared --perf`).
"""
import wireguard_env  # noqa: F401

from pypeline import MAIN, initial, sim_input, sim_output, sim_print, uint8_t, wires

import chacha20poly1305_decrypt_ports

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
)
from axi.axis_sim import AxisSimSource, AxisSimSink, Scoreboard
import tb_common_sim as common
import perf_tb_common as perf

_scoreboard = Scoreboard()
_src = AxisSimSource(axis128_intrf, perf.BUS_BYTES)
_snk = AxisSimSink(axis128_intrf, perf.BUS_BYTES, scoreboard=_scoreboard)
_runner = perf.make_runner(
    "decrypt", _src, _snk, _scoreboard, perf.decrypt_frame_builder
)

def _keep_count(stream):
    keep = stream.data.frag.keep
    return sum(1 for i in range(perf.BUS_BYTES) if keep[i])


@sim_input
def drive_in_word() -> axis128_intrf.stream_t:
    _runner.prepare_input()
    # Reg-driven ready, stable at the start of the cycle -- see encrypt_perf_tb.py.
    ready = 1 if chacha20poly1305_decrypt_ports.axis_in_if.ready else 0
    word = _src.step(ready)
    stream = word.stream
    valid = 1 if stream.valid else 0
    _runner.note_in(
        valid=valid,
        ready=ready,
        keep_count=_keep_count(stream) if valid else 0,
        eod=1 if stream.data.eod[0] else 0,
    )
    return stream


@initial(sim=True)
def announce():
    sim_print("=== ChaCha20-Poly1305 PERFORMANCE measurement (decrypt side) ===")
    sim_print(f"Decrypt: phases = {[p['name'] for p in perf.PHASES]}")
    sim_print(f"Decrypt: seed = {perf.SEED}, json = {perf.JSON_PATH or '(none)'}")


@sim_output
def measure_out():
    stream = chacha20poly1305_decrypt_ports.axis_out_if.stream
    # is_verified_out is constant for the whole output packet, so sampling it
    # when the frame completes is equivalent to checking every beat.
    got_verified = 1 if chacha20poly1305_decrypt_ports.is_verified_out else 0
    valid = 1 if stream.valid else 0
    _runner.note_out(
        valid=valid,
        keep_count=_keep_count(stream) if valid else 0,
        eod=1 if stream.data.eod[0] else 0,
    )
    _snk.step(axis128_intrf.fwd_t(stream))
    result = _snk.check_nowait()
    if result is not None:
        idx = result.get("idx", "?")
        passed = result["passed"]
        message = None
        if not passed:
            if "error" in result:
                message = f"{result['error']} (packet {idx})"
            else:
                expected, got = result["expected"], result["got"]
                n = min(len(expected), len(got))
                first_diff = next((i for i in range(n) if expected[i] != got[i]), n)
                message = (
                    f"Plaintext mismatch packet {idx}: expected {len(expected)} "
                    f"bytes got {len(got)} bytes, first differing byte[{first_diff}]"
                )
        expected_verified = result.get("expected_verified")
        if expected_verified is not None and got_verified != expected_verified:
            passed = False
            message = (
                f"is_verified mismatch packet {idx}: expected "
                f"{expected_verified} got {got_verified}"
            )
        _runner.note_checked(passed, message)
    for line in _runner.drain_log():
        sim_print(line)
    _runner.tick()


@MAIN
@wires
def decrypt_perf_tb() -> axis128_intrf.fwd_t:
    key: uint8_t[CHACHA20_KEY_SIZE] = common.KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = common.NONCE
    aad: uint8_t[AAD_MAX_LEN] = common.AAD

    chacha20poly1305_decrypt_ports.key = key
    chacha20poly1305_decrypt_ports.nonce = nonce
    chacha20poly1305_decrypt_ports.aad = aad
    chacha20poly1305_decrypt_ports.aad_len = common.AAD_LEN

    chacha20poly1305_decrypt_ports.axis_in_if.stream = drive_in_word()
    # Never backpressure the output -- see encrypt_perf_tb.py.
    chacha20poly1305_decrypt_ports.axis_out_if.ready = 1

    measure_out()

    # dummy return so nothing optimizes away
    return axis128_intrf.fwd_t(chacha20poly1305_decrypt_ports.axis_out_if.stream)
