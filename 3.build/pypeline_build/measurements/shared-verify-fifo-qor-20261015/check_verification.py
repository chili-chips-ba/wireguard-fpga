# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause
"""Exercise full verification storage, verdict isolation and stalled AXIS words."""
import json
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True
from replay_native import prepare

config, compiler, source, HERE = prepare()
import pypeline
pypeline.SET_DESIGN_PARAMS({"DESIGN": "shared", "SHARE": "both", "TARGET_MHZ": "80"})
pypeline.SET_AUTO_PIPELINE_LATENCY_CACHE(config["auto_pipeline_latencies"])
pypeline.SET_AUTO_MULTI_CYCLE_LATENCY_CACHE(config["auto_multi_cycle_latencies"])
import wireguard_env
from aead_types import (
    axis128_intrf, axis128_frag_t, axis128_bus_t, uint1_stream_intrf,
    decrypt_verify_fifo_sizing, buffering_metadata,
)
from chacha20_pipeline_shared import chacha20_decrypt_shared
from poly1305_select import make_poly1305_mac, implementation_metadata
from poly1305_verify_decrypt import VERIFY_HANDOFF_CYCLES
from wait_to_verify import make_wait_to_verify

sizing = decrypt_verify_fifo_sizing(chacha20_decrypt_shared,
    make_poly1305_mac("decrypt", share_mcp=True), verify_handoff_cycles=VERIFY_HANDOFF_CYCLES)
assert sizing["required_beats"] == 307, sizing
assert sizing["memory_depth_beats"] == 512, sizing
dut = make_wait_to_verify(sizing["memory_depth_beats"], sizing=sizing)
packets = [2032] * 6 + [15, 65]
verdicts = [1, 0, 1, 0, 1, 1, 0, 1]
rng = random.Random(8439)
words = []
ends = []
for size in packets:
    payload = bytes(rng.randrange(256) for _ in range(size))
    for start in range(0, size, 16):
        part = payload[start:start+16]
        words.append((tuple(part) + (0,) * (16-len(part)),
                      tuple([1] * len(part) + [0] * (16-len(part))), start+16 >= size))
    ends.append(len(words))

accepted = retired = sent_verdicts = retired_packets = stalled_input = 0
peak = 0
previous_stalled = None
pypeline.sim_reset()
for cycle in range(10000):
    valid_in = accepted < len(words)
    word = words[accepted] if valid_in else ((0,)*16, (0,)*16, False)
    fragment = axis128_frag_t(frag=axis128_bus_t(data=list(word[0]), keep=list(word[1])), eod=[int(word[2])])
    valid_verdict = (sent_verdicts < len(packets) and accepted >= ends[sent_verdicts] and cycle >= 200)
    ready = int(cycle >= 1200 and cycle % 17 >= 4)
    result = pypeline.sim_call(dut,
        axis_in_if=axis128_intrf.fwd_t(axis128_intrf.stream_t(data=fragment, valid=int(valid_in))),
        verify_bit_if=uint1_stream_intrf.fwd_t(uint1_stream_intrf.stream_t(
            data=verdicts[sent_verdicts] if sent_verdicts < len(packets) else 0, valid=int(valid_verdict))),
        axis_out_if=axis128_intrf.fb_t(ready))
    if valid_verdict and result.verify_bit_if.ready:
        sent_verdicts += 1
    if valid_in and result.axis_in_if.ready:
        accepted += 1
    elif valid_in:
        stalled_input += 1
    out = result.axis_out_if.stream
    observed = (tuple(map(int, out.data.frag.data)), tuple(map(int, out.data.frag.keep)), bool(out.data.eod[0]), int(result.is_verified_out))
    if previous_stalled is not None:
        assert out.valid and observed == previous_stalled, (cycle, "stalled output changed")
    previous_stalled = observed if out.valid and not ready else None
    if out.valid:
        assert retired_packets < sent_verdicts, (cycle, "plaintext before verdict")
        assert observed[:3] == words[retired], (cycle, retired, "plaintext/framing mismatch")
        assert observed[3] == verdicts[retired_packets], (cycle, "wrong packet verdict")
        if ready:
            retired += 1
            if observed[2]:
                retired_packets += 1
    peak = max(peak, accepted-retired)
    if retired == len(words):
        break
else:
    raise AssertionError("Verification FIFO did not drain")
assert accepted == retired == len(words)
assert sent_verdicts == retired_packets == len(packets)
assert stalled_input > 0
assert peak == 513, peak
result = dict(passed=True, cycles=cycle+1, packets=len(packets), words=len(words),
              peak_occupancy=peak, stalled_input_cycles=stalled_input,
              rejected_verdict_packets=verdicts.count(0), sizing=sizing,
              config=dict(buffering=buffering_metadata(), poly1305=implementation_metadata(), max_packet_bytes=2032))
(HERE / "verification-component.json").write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps({key: value for key, value in result.items() if key not in ("config", "sizing")}))
