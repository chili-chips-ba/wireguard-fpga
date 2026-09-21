# pyright: reportInvalidTypeForm=none
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Encrypt-side PERFORMANCE testbench: streams the perf_tb_common.py phase plan
(N back-to-back packets per packet size, then one long packet) through the
encrypt datapath with zero source gaps and no output backpressure, while
perf_probe.py measures duty cycle, per-packet latency and window cycles.

This is a measurement rig, not a replacement for encrypt_tb.py / encrypt_syn_tb.py:
it still checks every packet's ciphertext+tag against the reference model (a perf
run that silently computed garbage would be worthless), but its packet mix is
chosen to characterise throughput vs packet size, not to hunt corner cases.

Only runs under Pypeline's native --sim mode (`./build.py --shared --perf`):
@sim_input/@sim_output are elaborated away entirely on any real-VHDL path.
Sim-time knobs come from the environment (see perf_tb_common.py) so the
elaborated hardware never changes between measurement runs.
"""
import wireguard_env  # noqa: F401

from pypeline import MAIN, initial, sim_input, sim_output, sim_print, uint8_t, wires

import chacha20poly1305_encrypt_ports

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
    "encrypt", _src, _snk, _scoreboard, perf.encrypt_frame_builder
)

def _keep_count(stream):
    keep = stream.data.frag.keep
    return sum(1 for i in range(perf.BUS_BYTES) if keep[i])


@sim_input
def drive_in_word() -> axis128_intrf.stream_t:
    _runner.prepare_input()
    # axis_in_if.ready is Reg-driven downstream (buffer-occupancy based, not a
    # same-cycle function of this cycle's valid), so it is stable at the start
    # of the cycle -- safe to read here to tell an accepted beat from a stall.
    ready = 1 if chacha20poly1305_encrypt_ports.axis_in_if.ready else 0
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
    sim_print("=== ChaCha20-Poly1305 PERFORMANCE measurement (encrypt side) ===")
    sim_print(f"Encrypt: phases = {[p['name'] for p in perf.PHASES]}")
    sim_print(f"Encrypt: seed = {perf.SEED}, json = {perf.JSON_PATH or '(none)'}")


@sim_output
def measure_out():
    stream = chacha20poly1305_encrypt_ports.axis_out_if.stream
    valid = 1 if stream.valid else 0
    _runner.note_out(
        valid=valid,
        keep_count=_keep_count(stream) if valid else 0,
        eod=1 if stream.data.eod[0] else 0,
    )
    _snk.step(axis128_intrf.fwd_t(stream))
    result = _snk.check_nowait()
    if result is not None:
        message = None
        if not result["passed"]:
            if "error" in result:
                message = f"{result['error']} (packet {result.get('idx', '?')})"
            else:
                expected, got = result["expected"], result["got"]
                n = min(len(expected), len(got))
                first_diff = next((i for i in range(n) if expected[i] != got[i]), n)
                message = (
                    f"Ciphertext/Tag mismatch packet {result.get('idx', '?')}: "
                    f"expected {len(expected)} bytes got {len(got)} bytes, "
                    f"first differing byte[{first_diff}]"
                )
        _runner.note_checked(result["passed"], message)
    for line in _runner.drain_log():
        sim_print(line)
    _runner.tick()


@MAIN
@wires
def encrypt_perf_tb() -> axis128_intrf.fwd_t:
    key: uint8_t[CHACHA20_KEY_SIZE] = common.KEY
    nonce: uint8_t[CHACHA20_NONCE_SIZE] = common.NONCE
    aad: uint8_t[AAD_MAX_LEN] = common.AAD

    chacha20poly1305_encrypt_ports.key = key
    chacha20poly1305_encrypt_ports.nonce = nonce
    chacha20poly1305_encrypt_ports.aad = aad
    chacha20poly1305_encrypt_ports.aad_len = common.AAD_LEN

    chacha20poly1305_encrypt_ports.axis_in_if.stream = drive_in_word()
    # Never backpressure the output: every measured number is an upper bound
    # with an infinitely fast consumer (documented in README).
    chacha20poly1305_encrypt_ports.axis_out_if.ready = 1

    measure_out()

    # dummy return so nothing optimizes away
    return axis128_intrf.fwd_t(chacha20poly1305_encrypt_ports.axis_out_if.stream)
