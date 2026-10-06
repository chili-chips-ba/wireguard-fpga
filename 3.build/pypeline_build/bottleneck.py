#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Turns raw internal taps into a per-block throughput table and a named
bottleneck, so "where is the time going" is an output of the measurement rather
than a reading exercise.

The generic analysis (block rollup, bottleneck walk, headline, tables, CSV
rows) is PipelineC's stream performance library,
include/pypeline/stream/stream_bottleneck.py (guide:
include/pypeline/stream/pypeline_stream_perf_guide.md). This file holds what is
WireGuard's own: the AEAD block graph below, the Poly1305/ChaCha20 cost model,
the Poly1305 lifecycle and shared-MCP service tables, and WireGuard's report
wording.

Consumed by measure.py; importable and `--selftest`-able on its own (no
pypeline, no build, no Vivado).

Three things are derived from the taps the design's stream_perf_probe calls
collect:

1. **Per-block throughput and ceiling.** A block's input tap says how many bytes
   it actually moved (`bytes_per_cycle`) and -- via `service_period_cycles`,
   cycles per accepted beat *while work was offered* -- how fast it could move
   them if never starved. The latter is the block's in-situ ceiling and is what
   makes "ChaCha20 is faster than Poly1305" a measured statement.

2. **A bottleneck verdict.** The bottleneck is the block that backpressures its
   producer hardest without itself being backpressured. Blocks that merely relay
   somebody else's backpressure are walked through, so the verdict names the
   origin rather than the nearest symptom.

3. **A model cross-check.** The body service cost is predictable from the
   Poly1305 block count x its implementation-specific initiation interval.
   Packet setup and finalization are reported separately. Comparing each phase makes a
   design change legible immediately: a change that moves the measurement but
   not the model means the model's assumption is now wrong, and vice versa.
"""

import json
import math
import os
import sys

# The library lives in PipelineC's include/pypeline: find the checkout the way
# measure.py does ($PYPELINEC = <repo>/src/pypelinec, else a sibling checkout).
_PYPELINEC = os.environ.get("PYPELINEC")
PIPELINEC_REPO = (
    os.path.dirname(os.path.dirname(os.path.abspath(_PYPELINEC))) if _PYPELINEC
    else os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                      "..", "..", "..", "PipelineC"))
)
_PYPELINE_INCLUDE = os.path.join(PIPELINEC_REPO, "include", "pypeline")
if _PYPELINE_INCLUDE not in sys.path:
    sys.path.insert(0, _PYPELINE_INCLUDE)

from stream import stream_bottleneck as lib  # noqa: E402
from stream.stream_bottleneck import (  # noqa: E402,F401  (re-exported)
    best_ceiling, blocked_frac, bottleneck_tally, check_taps, get_tap, num, pct,
    TAP_CSV_COLUMNS, tap_rows,
)

# --- design facts the model needs -------------------------------------------
# Historical records used make_valid_ready_mcp(poly1305_mac_loop_body, 5).
# PipelineC's MCP asserts output valid at cycles_since_launch == ncycles+1 and
# re-arms `ready` the same cycle, so launch-to-launch is ncycles+1 cycles per
# 16 B Poly1305 block. This fallback is ONLY for files without MAC metadata;
# new measurements record the selected implementation's resolved latencies.
POLY1305_MCP_NCYCLES = 5
POLY1305_BLOCK_PERIOD_CYCLES = POLY1305_MCP_NCYCLES + 1
POLY1305_BLOCK_BYTES = 16
# ChaCha20's 128->512 dwidth converter takes 4 x 16 B beats per 64 B block and
# its compute is an II=1 stream pipeline, so 4 cycles per block is the floor.
CHACHA20_BLOCK_BYTES = 64
CHACHA20_BEATS_PER_BLOCK = 4
BUS_BYTES = 16

# --- the dataflow graph, as tap names ---------------------------------------
# `consumes` is the block's input handshake (where its own backpressure shows
# up); `produces` is its output handshake (where it in turn gets backpressured).
# `downstream` names who consumes `produces` -- a TUPLE, because the ciphertext
# fork (axis128_2broadcast) has two sinks and because chacha20's consumer differs
# by direction (prep+append on encrypt, wait_to_verify on decrypt). Only blocks
# actually present in a direction's rollup are considered, and the walk follows
# whichever consumer is stalling hardest. This is how the verdict gets past a
# block that is only relaying somebody else's backpressure.
#
# The broadcast itself is deliberately not a block: it is purely combinational
# (source ready = AND of both sinks), so it has no service rate of its own and
# would only ever mirror whichever sink is slower.
BLOCKS = {
    "chacha20": {
        "consumes": "chacha20.axis_in",
        "produces": "chacha20.axis_out",
        "downstream": ("prep_auth_data", "append_auth_tag", "wait_to_verify"),
        "state": "chacha20.in_state",
        "what": "ChaCha20 keystream XOR (shared II=1 pipeline)",
    },
    "prep_auth_data": {
        "consumes": "prep.axis_in",
        "produces": "prep.axis_out",
        "downstream": ("poly1305",),
        "state": "prep.fsm",
        "what": "AAD||ciphertext||lengths framing for the MAC",
    },
    "auth_buffer": {
        "consumes": "auth_fifo.in",
        "produces": "auth_fifo.out",
        "downstream": ("prep_auth_data",),
        "state": None,
        "what": "ciphertext FIFO decoupling decrypt key/setup waits",
    },
    "poly1305": {
        "consumes": "poly1305.data_in",
        "produces": "poly1305.tag_out",
        "downstream": (),
        "state": "poly1305.fsm",
        "what": "Poly1305 MAC (selected architecture)",
    },
    "append_auth_tag": {
        "consumes": "append.axis_in",
        "produces": "append.axis_out",
        "downstream": ("output_slice",),
        "state": "append.fsm",
        "what": "tag merge into the ciphertext tail (encrypt out)",
    },
    "output_slice": {
        "consumes": "output_slice.in",
        "produces": "output_slice.out",
        "downstream": (),
        "state": None,
        "what": "II=1 registered encrypt AXIS output boundary",
    },
    "strip_auth_tag": {
        "consumes": "strip.axis_in",
        "produces": "strip.axis_out",
        "downstream": ("chacha20", "auth_buffer", "prep_auth_data"),
        "state": None,
        "what": "tag split off the ciphertext tail (decrypt in)",
    },
    "wait_to_verify": {
        "consumes": "wtv.axis_in",
        "produces": "wtv.axis_out",
        "downstream": (),
        "state": "wtv.fsm",
        "what": "plaintext FIFO held until the tag verdict (decrypt out)",
    },
    "verify": {
        "consumes": "verify.calc_tag",
        "produces": "verify.tags_match",
        "downstream": (),
        "state": "verify.fsm",
        "what": "tag comparison (decrypt)",
    },
}

DIRECTIONS = ("encrypt", "decrypt")


def block_rollup(taps, label):
    """Per-block achieved throughput, in-situ ceiling and stall split."""
    return lib.block_rollup(taps, label, BLOCKS, BUS_BYTES)


def find_bottleneck(blocks):
    """Name the block whose own slowness limits the direction (see
    stream_bottleneck.find_bottleneck)."""
    return lib.find_bottleneck(blocks, BLOCKS)


def model_for(packet_bytes, aad_len, measured_period, poly_tap=None, mac_config=None):
    """First-principles per-packet cycle cost, against the measured period.

    Poly1305 sees ceil(aad/16) AAD blocks + ceil(len/16) ciphertext blocks + 1
    length block. Their count times the recorded body II is the body service
    cost. Setup, drain, epilogue, framing, arbitration and tag stalls are
    separate costs. Missing metadata denotes historical legacy measurements.
    """
    aad_blocks = math.ceil(aad_len / POLY1305_BLOCK_BYTES) if aad_len else 0
    ct_blocks = math.ceil(packet_bytes / POLY1305_BLOCK_BYTES)
    blocks = aad_blocks + ct_blocks + 1  # +1 for the aad_len||ct_len block
    measured_block_period = (poly_tap or {}).get("service_period_cycles")
    mac_config = mac_config or {}
    block_period = mac_config.get("body_ii", POLY1305_BLOCK_PERIOD_CYCLES)
    model = {
        "poly1305_blocks": blocks,
        "poly1305_block_period_cycles": block_period,
        "poly1305_model_cycles": blocks * block_period,
        "poly1305_body_ii": block_period,
        "poly1305_accumulator_count": mac_config.get("accumulator_count", 1),
        "poly1305_body_latency": mac_config.get("body_latency"),
        "poly1305_prologue_response_cycles": mac_config.get("prologue_response_cycles"),
        "poly1305_epilogue_response_cycles": mac_config.get("epilogue_response_cycles"),
        "poly1305_measured_block_period_cycles": measured_block_period,
        "chacha20_model_cycles": (
            math.ceil(packet_bytes / CHACHA20_BLOCK_BYTES) * CHACHA20_BEATS_PER_BLOCK
        ),
        "measured_packet_period_cycles": measured_period,
    }
    if measured_block_period:
        model["poly1305_measured_cycles"] = blocks * measured_block_period
    if measured_period:
        model["poly1305_frac_of_period"] = (
            model["poly1305_model_cycles"] / measured_period
        )
        model["residual_cycles"] = measured_period - model["poly1305_model_cycles"]
    # Structural ceilings, for the headline block comparison.
    model["poly1305_ceiling_bytes_per_cycle"] = (
        POLY1305_BLOCK_BYTES / block_period
    )
    model["chacha20_ceiling_bytes_per_cycle"] = (
        CHACHA20_BLOCK_BYTES / CHACHA20_BEATS_PER_BLOCK
    )
    return model


def poly1305_lifecycle(taps, direction):
    """Disjoint FSM phase counts plus body service and tag-stall counters.

    Input backpressure outside STREAM_BODY belongs to packet setup/drain,
    not to the body's II. Only new-architecture states support this split.
    Per-packet values average over completed tags in this measurement window;
    IDLE includes both upstream key wait and measurement settle cycles.
    """
    state = get_tap(taps, direction, "poly1305.fsm") or {}
    states = state.get("states") or {}
    if "STREAM_BODY" not in states:
        return None
    tag = get_tap(taps, direction, "poly1305.tag_out") or {}
    body = get_tap(taps, direction, "poly1305.to_compute") or {}
    retire = get_tap(taps, direction, "poly1305.from_compute") or {}
    packets = tag.get("xfer_cycles", 0)
    groups = {
        "idle": ("IDLE",),
        "setup": ("PROLOGUE_LAUNCH", "PROLOGUE_WAIT"),
        "body": ("STREAM_BODY",),
        "drain": ("DRAIN",),
        "finalization": ("EPILOGUE_LAUNCH", "EPILOGUE_WAIT"),
        "tag_output": ("OUTPUT_TAG",),
    }
    cycles = {name: sum(states.get(s, {}).get("cycles", 0) for s in names)
              for name, names in groups.items()}
    return {
        "completed_packets": packets,
        "phase_cycles": cycles,
        "cycles_per_packet": {k: v / packets for k, v in cycles.items()} if packets else {},
        "body_launches": body.get("xfer_cycles"),
        "body_retirements": retire.get("xfer_cycles"),
        "body_service_cycles": body.get("service_period_cycles"),
        "body_input_gap_cycles": cycles["body"] - body.get("xfer_cycles", 0),
        "tag_stall_cycles": tag.get("stall_cycles"),
        "tag_stalls_per_packet": tag.get("stall_cycles", 0) / packets if packets else None,
        "prologue_launches": (get_tap(taps, direction, "poly1305.prologue_in") or {}).get("xfer_cycles"),
        "epilogue_launches": (get_tap(taps, direction, "poly1305.epilogue_in") or {}).get("xfer_cycles"),
        "prologue_request_wait_cycles": (get_tap(taps, direction, "poly1305.prologue_in") or {}).get("stall_cycles"),
        "epilogue_request_wait_cycles": (get_tap(taps, direction, "poly1305.epilogue_in") or {}).get("stall_cycles"),
    }

def analyze_phase(phase, aad_len=0, mac_config=None):
    """Add the library's `taps_check`/`blocks`/`bottleneck`/`arbitration`, plus
    WireGuard's `throughput_comparison`, `model`, `poly1305_lifecycle` and
    `poly1305_shared_services`, to one phase dict, in place."""
    comparison = concurrent_throughput(phase)
    if comparison:
        phase["throughput_comparison"] = comparison
    taps = phase.get("taps")
    if not taps:
        return phase
    # A direction disabled via WG_PERF_DIRS (measure.py --dirs enc|dec) still
    # has probes firing; the library drops a label whose blocks moved nothing.
    lib.analyze_phase(phase, BLOCKS, DIRECTIONS, BUS_BYTES)
    model = {}
    for label in phase.get("blocks", {}):
        direction = phase.get(label) or {}
        model[label] = model_for(
            phase.get("packet_bytes"),
            aad_len,
            direction.get("packet_period_cycles"),
            get_tap(taps, label, BLOCKS["poly1305"]["consumes"]),
            ((mac_config or {}).get("directions") or {}).get(label),
        )
        lifecycle = poly1305_lifecycle(taps, label)
        if lifecycle:
            phase.setdefault("poly1305_lifecycle", {})[label] = lifecycle
    if model:
        phase["model"] = model
    services = {}
    for name in ("prologue", "epilogue"):
        prefix = "shared/poly1305." + name
        service_state = (taps.get(prefix + ".service") or {}).get("states", {})
        if service_state:
            services[name] = {
                "compute_cycles": service_state.get("COMPUTE", {}).get("cycles", 0),
                "response_valid_cycles": service_state.get("OUTPUT", {}).get("cycles", 0),
                "response_stall_cycles": (taps.get(prefix + ".service_out") or {}).get("stall_cycles"),
                "launches": (taps.get(prefix + ".service_in") or {}).get("xfer_cycles"),
                "responses": (taps.get(prefix + ".service_out") or {}).get("xfer_cycles"),
            }
    if services:
        phase["poly1305_shared_services"] = services
    return phase


def analyze(phases, aad_len=0, mac_config=None):
    for phase in phases:
        analyze_phase(phase, aad_len=aad_len, mac_config=mac_config)
    return phases


def concurrent_throughput(phase):
    """Compare equal-size traffic, with a separate genuinely contending window.

    The full-phase metric intentionally preserves historical interpretation.
    The overlap metric drops the first two output completions and stops when
    either direction admits its final ChaCha request. It never includes an
    interval straddling either boundary. Short bursts may have no such interval.
    """
    directions = {d: phase.get(d, {}) for d in DIRECTIONS}
    rates = {d: v.get("sustained_bytes_per_cycle") for d, v in directions.items()}
    if not all(rates.values()):
        return None
    result = {"full_phase_decrypt_to_encrypt_ratio": rates["decrypt"] / rates["encrypt"]}
    packets = {d: v.get("packets", []) for d, v in directions.items()}
    ends = [(phase.get("taps", {}).get(d + "/chacha20.to_pipeline") or {}).get(
        "last_transfer_cycle") for d in DIRECTIONS]
    if any(len(p) < 3 for p in packets.values()) or any(e is None for e in ends):
        result["contention_window"] = {"available": False}
        return result
    first = max(p[1]["last_out"] for p in packets.values())
    last = min(ends)
    overlap = {"available": True, "first_cycle": first, "last_cycle": last}
    for d, entries in packets.items():
        periods = [b["last_out"] - a["last_out"] for a, b in zip(entries, entries[1:])
                   if first <= a["last_out"] < b["last_out"] <= last]
        period = sum(periods) / len(periods) if periods else None
        overlap[d] = {"intervals": len(periods), "packet_period_cycles": period,
                      "bytes_per_cycle": phase["packet_bytes"] / period if period else None}
    overlap["enough_intervals"] = all(overlap[d]["intervals"] >= 8 for d in DIRECTIONS)
    if all(overlap[d]["bytes_per_cycle"] for d in DIRECTIONS):
        overlap["decrypt_to_encrypt_ratio"] = (overlap["decrypt"]["bytes_per_cycle"] /
                                               overlap["encrypt"]["bytes_per_cycle"])
    result["contention_window"] = overlap
    return result


# --- reporting ---------------------------------------------------------------
# WireGuard's block CSV keeps its historical `direction` column name.
BLOCK_CSV_COLUMNS = ("label", "phase", "packet_bytes", "direction") + lib.BLOCK_CSV_COLUMNS[4:]
block_rows = lib.block_rows

HEADLINE_COMPARE = ("chacha20", "poly1305")
HEADLINE_NAMES = {"chacha20": "ChaCha20", "poly1305": "Poly1305"}

# Wording overrides that keep blocks.md identical to the pre-library reports.
TEXT = {
    "label_header": "dir",
    "label_noun": "direction",
    "no_taps": (
        "_No internal taps in this run — re-measure with "
        "`./measure.py --taps all` to populate this section._"
    ),
    "arbitration_intro": (
        "**Shared-pipeline arbitration** — includes ChaCha20 and each shared "
        "Poly1305 MCP separately. *Resource not ready* means the selected "
        "request cannot launch (compute busy or output backpressure); "
        "*contention* means the other side holds the slot and wants it; "
        "*wasted slot* means the other side holds an empty slot. Current "
        "request-aware arbiters recover lone requests; historical arbiters "
        "may have wasted slots. These waits are not body-pipeline II:"
    ),
}


def headline(phases):
    """One generated sentence per direction: which of ChaCha20/Poly1305 is the
    slower block, by how much, and how close the datapath runs to its ceiling."""
    return lib.headline(phases, DIRECTIONS, HEADLINE_COMPARE, HEADLINE_NAMES)


def markdown_blocks(phases):
    """The generated block-level table + per-phase bottleneck verdicts."""
    return lib.markdown_blocks(
        phases, DIRECTIONS, BLOCKS, HEADLINE_COMPARE, HEADLINE_NAMES,
        extra_sections=(markdown_model(phases), markdown_poly1305_lifecycle(phases),
                        markdown_poly1305_services(phases)),
        text=TEXT,
    )


def markdown_arbitration(phases):
    """Round-robin cost per resource and direction, including shared MCPs."""
    return lib.markdown_arbitration(phases, TEXT)


def markdown_summary(phases, detail_path=None):
    """The README form of the block analysis: a few lines of TEXT, no tables.

    Carries the numbers worth keeping in view -- the block ceilings and gap, the
    bottleneck verdict across the sweep, why the MAC is slow, which ceilings are
    only lower bounds, the shared-pipeline arbitration split and the model fit --
    while the full per-phase, per-block tables stay in the run's blocks.md.
    """
    analysed = [p for p in phases if p.get("blocks")]
    if not analysed:
        return (
            "_No internal taps in this run — re-measure with "
            "`./measure.py --taps all` to populate this summary._"
        )
    lines = [line for line in headline(phases) if line.startswith("- ")]

    # Bottleneck verdict across every phase x direction.
    verdicts, total = bottleneck_tally(analysed, DIRECTIONS)
    if verdicts:
        parts = []
        for name in sorted(verdicts, key=lambda n: -len(verdicts[n])):
            where = verdicts[name]
            text = f"**{name}** {len(where)}/{total}"
            if len(where) <= total / 2:
                text += f" ({', '.join(where)})"
            parts.append(text)
        lines.append(
            "- **Bottleneck verdict** (per phase × direction): " + "; ".join(parts) + "."
        )

    big = max(analysed, key=lambda p: p.get("packet_bytes") or 0)

    # Why the MAC is slow, at the largest size.
    mac = []
    for direction in DIRECTIONS:
        entry = ((big.get("blocks") or {}).get(direction) or {}).get("poly1305")
        if not entry:
            continue
        top = sorted(
            (entry.get("state_fracs") or {}).items(), key=lambda kv: kv[1], reverse=True
        )[:2]
        states = ", ".join(f"{n} {pct(f)}" for n, f in top if f >= 0.10)
        text = (
            f"{direction} one beat per {num(entry.get('service_period_cycles'))} "
            f"cycles, stalling its producer {pct(entry.get('in_stall_frac'))} of cycles"
        )
        if states:
            text += f", FSM in {states}"
        mac.append(text)
    if mac:
        lines.append(f"- **Poly1305 at {big['packet_bytes']} B:** " + "; ".join(mac) + ".")

    # Which ChaCha20 ceilings are only lower bounds.
    relay = []
    for direction in DIRECTIONS:
        seen = [
            (p, p["blocks"][direction]["chacha20"])
            for p in analysed
            if ((p.get("blocks") or {}).get(direction) or {}).get("chacha20")
        ]
        limited = [(p, e) for p, e in seen if e.get("relay_limited")]
        if limited:
            p, e = max(limited, key=lambda pe: pe[1].get("out_stall_frac") or 0.0)
            relay.append(
                f"{direction} at {len(limited)}/{len(seen)} sizes (own output stalled "
                f"up to {pct(e.get('out_stall_frac'))}, at {p['packet_bytes']} B)"
            )
    if relay:
        lines.append(
            "- **ChaCha20 relay-limited** — its own output backpressured by the MAC, "
            "so its in-situ ceiling there is only a lower bound (≥): "
            + "; ".join(relay) + "."
        )

    # Shared-pipeline arbitration, at the largest size.
    arb = next(iter((big.get("arbitration") or {}).values()), None)
    if arb:
        parts = []
        for label, per in (arb.get("per_requester") or {}).items():
            if not per.get("req_cycles"):
                continue
            parts.append(
                f"{label} launched on {per['xfer_cycles']} of {per['req_cycles']} "
                f"wanted cycles (pipeline not ready {pct(blocked_frac(per))}, "
                f"contention {pct(per.get('contention_frac'))}, wasted slot "
                f"{pct(per.get('wasted_slot_frac'))})"
            )
        if parts:
            lines.append(
                f"- **Shared ChaCha20 pipeline at {big['packet_bytes']} B:** "
                + "; ".join(parts) + "."
            )

    # Model fit across the sweep.
    fits = []
    for direction in DIRECTIONS:
        models = [
            (p.get("model") or {}).get(direction) for p in analysed
        ]
        models = [m for m in models if m and m.get("poly1305_frac_of_period")]
        if not models:
            continue
        fr = [m["poly1305_frac_of_period"] for m in models]
        rs = [m["residual_cycles"] for m in models]
        fits.append(
            f"{direction} {pct(min(fr))}–{pct(max(fr))} (residual "
            f"{num(min(rs), '.0f')}–{num(max(rs), '.0f')} cycles per packet)"
        )
    if fits:
        periods = sorted({m["poly1305_block_period_cycles"]
                          for p in analysed for m in (p.get("model") or {}).values()})
        period_text = "/".join(str(p) for p in periods)
        lines.append(
            f"- **Model cross-check:** Poly1305 block count × its "
            f"{period_text}-cycle body block period accounts for "
            + "; ".join(fits) + " of the measured packet period."
        )

    if detail_path:
        lines.append(
            f"- Full per-phase, per-block tables (FSM states, bottleneck evidence, "
            f"arbitration, model): `{detail_path}`."
        )
    return "\n".join(lines)


def markdown_poly1305_lifecycle(phases):
    rows = []
    for phase in phases:
        for direction, lifecycle in (phase.get("poly1305_lifecycle") or {}).items():
            per = lifecycle["cycles_per_packet"]
            rows.append(
                f"| {phase['name']} | {direction} "
                f"| {num(lifecycle.get('body_service_cycles'))} "
                + "".join(f"| {num(per.get(key))} " for key in
                          ("setup", "body", "drain", "finalization", "tag_output"))
                + f"| {num(lifecycle.get('tag_stalls_per_packet'))} "
                + f"| {num(lifecycle.get('prologue_request_wait_cycles'))} "
                + f"| {num(lifecycle.get('epilogue_request_wait_cycles'))} |"
            )
    if not rows:
        return []
    return [
        "**Poly1305 lifecycle** — measured body service cycles per offered block "
        "are separate from FSM cycles per completed packet. Body time includes "
        "input gaps; setup includes the prologue handshake; finalization includes "
        "the epilogue handshake. Tag stalls are a subset of tag-output cycles, "
        "not an additional cost. IDLE/key wait and settle cycles remain in JSON. "
        "MCP request waits (total clocks in the window) are subsets of "
        "setup/finalization, including sharing contention. These are MAC-local "
        "costs, not additive whole-datapath latency:",
        "",
        "| phase | dir | body service (clk/block) | setup (clk/pkt) | body (clk/pkt) "
        "| drain (clk/pkt) | finalization (clk/pkt) | tag output (clk/pkt) | tag stalls (clk/pkt) "
        "| prologue request wait (clk) | epilogue request wait (clk) |",
        "|---|---|---|---|---|---|---|---|---|---|---|",
    ] + rows


def markdown_poly1305_services(phases):
    rows = []
    for phase in phases:
        for name, service in (phase.get("poly1305_shared_services") or {}).items():
            launches = service.get("launches")
            compute = service.get("compute_cycles")
            per_request = compute / launches if launches and compute is not None else None
            rows.append(
                f"| {phase['name']} | {name} | {num(launches, '.0f')} "
                f"| {num(service.get('responses'), '.0f')} | {num(compute, '.0f')} "
                f"| {num(per_request)} | {num(service.get('response_valid_cycles'), '.0f')} "
                f"| {num(service.get('response_stall_cycles'), '.0f')} |"
            )
    if not rows:
        return []
    return [
        "**Shared Poly1305 MCP service** — physical-service occupancy, separate "
        "from each requester's arbitration wait and private body II. Compute "
        "cycles run from accepted launch until a valid response; output stalls "
        "are a subset of response-valid cycles, not additional compute time:",
        "",
        "| phase | service | requests | responses | compute (clk) | compute (clk/request) "
        "| response valid (clk) | response stalls (clk) |",
        "|---|---|---|---|---|---|---|---|",
    ] + rows


def markdown_model(phases):
    rows = []
    for phase in phases:
        for direction in DIRECTIONS:
            m = (phase.get("model") or {}).get(direction)
            if not m or not m.get("measured_packet_period_cycles"):
                continue
            rows.append(
                f"| {phase['name']} | {phase['packet_bytes']} | {direction} "
                f"| {m['poly1305_blocks']} | {m['poly1305_model_cycles']} "
                f"| {num(m.get('poly1305_measured_block_period_cycles'))} "
                f"| {num(m['measured_packet_period_cycles'], '.1f')} "
                f"| {pct(m.get('poly1305_frac_of_period'))} "
                f"| {num(m.get('residual_cycles'), '.1f')} |"
            )
    if not rows:
        return []
    head = [
        "**Model cross-check** — Poly1305 block count x its recorded body "
        "initiation interval, against the "
        "measured packet period. The residual is everything that is not the MAC "
        "loop (prologue, body drain, epilogue, poly key round trip, framing, "
        "tag stalls, arbitration). This is a body-cost model, not a claim "
        "of one-cycle whole-packet service:",
        "",
        "| phase | bytes | dir | poly blocks | model (clk) | measured blk period "
        "| measured period (clk) | model / measured | residual (clk) |",
        "|---|---|---|---|---|---|---|---|---|",
    ]
    return head + rows


# --- selftest ----------------------------------------------------------------
def _selftest():
    """Attribution and model math, against hand-built synthetic taps."""
    failures = []

    def check(name, got, want, tol=1e-9):
        ok = (
            abs(got - want) < tol
            if isinstance(want, float) and isinstance(got, (int, float))
            else got == want
        )
        if not ok:
            failures.append(f"{name}: expected {want!r} got {got!r}")

    # A phase where Poly1305 is the limiter: its input stalls hard and is never
    # starved, while ChaCha20's input is mostly starved (it is waiting for the
    # backpressure to clear), and prep only RELAYS poly's stall.
    cycles = 600
    taps = {
        "encrypt/chacha20.axis_in": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
            "stall_cycles": 60, "starved_cycles": 440, "idle_cycles": 0,
            "accept_rate": 100 / 160, "service_period_cycles": 1.6,
            "beats_per_cycle": 100 / cycles, "bytes_per_cycle": 1600 / cycles,
            "bytes_per_beat": 16.0, "stall_frac": 0.10, "starve_frac": 440 / cycles,
        },
        "encrypt/chacha20.axis_out": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
            "stall_cycles": 300, "stall_frac": 0.50, "starve_frac": 0.1,
            "service_period_cycles": 4.0, "bytes_per_beat": 16.0,
        },
        "encrypt/prep.axis_in": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
            "stall_cycles": 300, "starved_cycles": 200, "idle_cycles": 0,
            "accept_rate": 0.25, "service_period_cycles": 4.0,
            "bytes_per_beat": 16.0, "bytes_per_cycle": 1600 / cycles,
            "stall_frac": 0.50, "starve_frac": 200 / cycles,
        },
        # prep's OUTPUT is stalled just as hard as its input -> it is relaying.
        "encrypt/prep.axis_out": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
            "stall_cycles": 500, "stall_frac": 0.83, "starve_frac": 0.0,
            "service_period_cycles": 6.0, "bytes_per_beat": 16.0,
        },
        "encrypt/poly1305.data_in": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
            "stall_cycles": 500, "starved_cycles": 0, "idle_cycles": 0,
            "accept_rate": 100 / 600, "service_period_cycles": 6.0,
            "bytes_per_beat": 16.0, "bytes_per_cycle": 1600 / cycles,
            "stall_frac": 500 / cycles, "starve_frac": 0.0,
        },
        "encrypt/poly1305.tag_out": {
            "kind": "handshake", "cycles": cycles, "xfer_cycles": 4,
            "stall_cycles": 0, "stall_frac": 0.0, "starve_frac": 0.2,
            "service_period_cycles": 1.0,
        },
        "encrypt/poly1305.fsm": {
            "kind": "state", "cycles": cycles, "dominant": "FINISH_ITER",
            "states": {"START_ITER": {"cycles": 100, "frac": 100 / cycles},
                       "FINISH_ITER": {"cycles": 500, "frac": 500 / cycles}},
        },
    }
    phase = {
        "name": "b2b-1420", "packet_bytes": 1420, "num_packets": 4, "taps": taps,
        "encrypt": {"packet_period_cycles": 565.667},
    }
    analyze_phase(phase, aad_len=29)

    blocks = phase["blocks"]["encrypt"]
    check("blocks found", sorted(blocks), ["chacha20", "poly1305", "prep_auth_data"])
    # Ceiling: 16 B per beat over 6.0 cycles/beat while offered -> 2.667 B/cyc.
    check("poly ceiling", blocks["poly1305"]["ceiling_bytes_per_cycle"], 16 / 6.0)
    # ChaCha20: 16 B per beat over 1.6 cycles/beat -> 10 B/cyc, far above poly.
    check("chacha ceiling", blocks["chacha20"]["ceiling_bytes_per_cycle"], 10.0)
    check(
        "chacha faster than poly",
        blocks["chacha20"]["ceiling_bytes_per_cycle"]
        > blocks["poly1305"]["ceiling_bytes_per_cycle"],
        True,
    )

    verdict = phase["bottleneck"]["encrypt"]
    # prep_auth_data has the joint-highest input stall but its own output is
    # stalled harder still, so the walk must land on poly1305, not prep.
    check("bottleneck", verdict["block"], "poly1305")
    check("bottleneck stall", verdict["in_stall_frac"], 500 / cycles)
    check("bottleneck state", verdict["dominant_state"], "FINISH_ITER")
    if "poly1305" not in verdict["evidence"] or "FINISH_ITER" not in verdict["evidence"]:
        failures.append(f"evidence line unhelpful: {verdict['evidence']!r}")

    model = phase["model"]["encrypt"]
    # 2 AAD blocks (29 B) + 89 ciphertext blocks (1420 B) + 1 length block.
    check("poly blocks", model["poly1305_blocks"], 92)
    check("poly model cycles", model["poly1305_model_cycles"], 552)
    check("poly measured cycles", model["poly1305_measured_cycles"], 552.0)
    check("poly frac of period", round(model["poly1305_frac_of_period"], 4), 0.9758)
    check("residual", round(model["residual_cycles"], 3), 13.667)
    check("poly ceiling (model)", model["poly1305_ceiling_bytes_per_cycle"], 16 / 6)
    check("chacha ceiling (model)", model["chacha20_ceiling_bytes_per_cycle"], 16.0)

    # A fork must be followed toward the sink that is actually stalling. Here
    # strip relays, and of its two sinks only prep (-> poly1305) is backed up;
    # chacha20 is wide open. The verdict must not stop at chacha20.
    fork = dict(taps)
    fork["encrypt/strip.axis_in"] = {
        "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
        "stall_cycles": 520, "starved_cycles": 0, "idle_cycles": 0,
        "accept_rate": 100 / 620, "service_period_cycles": 6.2,
        "bytes_per_beat": 16.0, "bytes_per_cycle": 1600 / cycles,
        "stall_frac": 0.87, "starve_frac": 0.0,
    }
    fork["encrypt/strip.axis_out"] = {
        "kind": "handshake", "cycles": cycles, "xfer_cycles": 100,
        "stall_cycles": 520, "stall_frac": 0.87, "starve_frac": 0.0,
        "service_period_cycles": 6.2, "bytes_per_beat": 16.0,
    }
    fv = find_bottleneck(block_rollup(fork, "encrypt"))
    check("fork walk lands on poly1305", fv["block"], "poly1305")

    # A relay chain with nothing downstream must not loop forever.
    lonely = {"encrypt/append.axis_in": {"kind": "handshake", "cycles": 10,
                                         "xfer_cycles": 1, "stall_cycles": 9,
                                         "stall_frac": 0.9, "starve_frac": 0.0,
                                         "service_period_cycles": 10.0,
                                         "bytes_per_beat": 16.0}}
    v = find_bottleneck(block_rollup(lonely, "encrypt"))
    check("single-block verdict", v["block"], "append_auth_tag")

    # A direction that never streamed (measure.py --dirs enc|dec) must not get a
    # verdict: its probes fired all run, but every block sat idle.
    idle = {
        "name": "b2b-64", "packet_bytes": 64, "num_packets": 2,
        "taps": {
            "decrypt/poly1305.data_in": {
                "kind": "handshake", "cycles": 100, "xfer_cycles": 0,
                "stall_cycles": 0, "starved_cycles": 0, "idle_cycles": 100,
                "accept_rate": None, "service_period_cycles": None,
                "stall_frac": 0.0, "starve_frac": 0.0,
            }
        },
    }
    analyze_phase(idle, aad_len=29)
    check("idle direction gets no blocks", "blocks" in idle, False)
    check("idle direction gets no verdict", "bottleneck" in idle, False)

    # No taps at all: analysis is a no-op, never an exception.
    bare = {"name": "x", "packet_bytes": 64, "num_packets": 1}
    analyze_phase(bare)
    check("no taps -> no blocks", "blocks" in bare, False)

    # The once-per-cycle invariant guard must catch a tap that inflated.
    good = check_taps({"a": {"cycles": 10}, "b": {"cycles": 10}})
    check("taps_check consistent", good["consistent"], True)
    check("taps_check cycles", good["cycles"], 10)
    bad = check_taps({"a": {"cycles": 10}, "b": {"cycles": 30}})
    check("taps_check inconsistent", bad["consistent"], False)
    check("taps_check names", bad["disagreeing_taps"], ["b"])
    check("phase taps_check present", phase["taps_check"]["consistent"], True)

    phase["arbitration"] = {
        "shared/pipe.arb": {
            "kind": "arb", "cycles": cycles, "labels": ["encrypt", "decrypt"],
            "per_requester": {
                "encrypt": {"req_cycles": 40, "sel_cycles": 300, "xfer_cycles": 20,
                            "contention_cycles": 0, "wasted_slot_cycles": 20,
                            "arb_loss_frac": 0.5, "contention_frac": 0.0,
                            "wasted_slot_frac": 0.5},
                "decrypt": {"req_cycles": 0, "sel_cycles": 300, "xfer_cycles": 0,
                            "contention_cycles": 0, "wasted_slot_cycles": 0,
                            "arb_loss_frac": 0.0, "contention_frac": 0.0,
                            "wasted_slot_frac": 0.0},
            },
        }
    }
    # The headline must name the slower block and quantify the gap.
    phase["encrypt"]["sustained_bytes_per_cycle"] = 2.51
    head = "\n".join(headline([phase]))
    for needle in ("ChaCha20", "Poly1305", "slower block", "ceiling"):
        if needle not in head:
            failures.append(f"headline missing {needle!r}: {head!r}")
    if "10.00 B/cyc" not in head or "2.67 B/cyc" not in head:
        failures.append(f"headline ceilings wrong: {head!r}")
    if "3.8x" not in head:  # 10.0 / 2.667
        failures.append(f"headline ratio wrong: {head!r}")
    if "94%" not in head:  # 2.51 / 2.667
        failures.append(f"headline saturation wrong: {head!r}")

    # Relay-limited blocks: in that fixture ChaCha20's output stalls 50% vs 10%
    # on its input -> flagged, ceiling rendered as a lower bound. Poly1305's
    # output never stalls -> exact.
    check("chacha relay_limited", blocks["chacha20"]["relay_limited"], True)
    check("poly not relay_limited", blocks["poly1305"]["relay_limited"], False)
    # Across a sweep, a relay-limited block is quoted at its BEST observation
    # (tightest lower bound), a clean one at the largest packet size.
    small = {"name": "b2b-256", "packet_bytes": 256, "blocks": {"encrypt": {
        "chacha20": {"ceiling_bytes_per_cycle": 14.2, "relay_limited": True},
        "poly1305": {"ceiling_bytes_per_cycle": 2.79, "relay_limited": False}}}}
    big = {"name": "peak-1920", "packet_bytes": 1920,
           "encrypt": {"sustained_bytes_per_cycle": 2.532},
           "blocks": {"encrypt": {
        "chacha20": {"ceiling_bytes_per_cycle": 2.98, "relay_limited": True},
        "poly1305": {"ceiling_bytes_per_cycle": 2.70, "relay_limited": False}}}}
    c = best_ceiling([small, big], "encrypt", "chacha20")
    check("relay-limited best ceiling", (c[0], c[1]["packet_bytes"], c[2]), (14.2, 256, False))
    pl = best_ceiling([small, big], "encrypt", "poly1305")
    check("clean block ceiling at largest size", (pl[0], pl[1]["packet_bytes"], pl[2]), (2.70, 1920, True))
    sweep_head = "\n".join(headline([small, big]))
    for needle in ("≥14.20 B/cyc", "2.70 B/cyc", "at least **5.3x", "94% of Poly1305"):
        if needle not in sweep_head:
            failures.append(f"sweep headline missing {needle!r}: {sweep_head!r}")

    table = markdown_blocks([phase])
    service_table = markdown_poly1305_services([{
        "name": "b2b-16", "poly1305_shared_services": {
            "epilogue": {"launches": 8, "responses": 8, "compute_cycles": 24,
                         "response_valid_cycles": 12, "response_stall_cycles": 4}
        }
    }])
    if "| b2b-16 | epilogue | 8 | 8 | 24 | 3.00 | 12 | 4 |" not in "\n".join(service_table):
        failures.append("shared MCP service occupancy table missing or malformed")
    if "≥10.000" not in table:
        failures.append("relay-limited ceiling not marked as a lower bound in the table")
    if "Shared-pipeline arbitration" not in table or "| 40 | 20 |" not in table:
        failures.append("arbitration table missing or malformed")
    # "pipeline not ready" derived from the identity for a snapshot without
    # blocked_cycles: 100 wanted - 10 launched - 30 contention - 20 wasted = 40%.
    phase["arbitration"]["shared/pipe.arb"]["per_requester"]["decrypt"] = {
        "req_cycles": 100, "sel_cycles": 300, "xfer_cycles": 10,
        "contention_cycles": 30, "wasted_slot_cycles": 20, "arb_loss_frac": 0.5,
        "contention_frac": 0.3, "wasted_slot_frac": 0.2}
    if "| decrypt | 100 | 10 | 40% | 30% | 20% |" not in markdown_blocks([phase]):
        failures.append("pipeline-not-ready share not derived for an old snapshot")
    phase["arbitration"]["shared/pipe.arb"]["per_requester"]["decrypt"]["req_cycles"] = 0
    # A direction that never asked for the pipeline must not appear as a row.
    if table.count("| b2b-1420 | 1420 | decrypt | 0 |"):
        failures.append("idle requester should be omitted from the arb table")
    for needle in ("poly1305", "FINISH_ITER", "Model cross-check", "| 92 |"):
        if needle not in table:
            failures.append(f"markdown missing {needle!r}")

    # The README summary: the key numbers, as text, with no tables at all.
    summary = markdown_summary([phase], "measurements/X/blocks.md")
    if "|---|" in summary or "\n| " in summary:
        failures.append("README summary must not contain a table")
    for needle in ("ChaCha20 serves", "**Bottleneck verdict**", "**poly1305** 1/1",
                   "FINISH_ITER", "**ChaCha20 relay-limited**",
                   "launched on 20 of 40 wanted cycles", "**Model cross-check:**",
                   "measurements/X/blocks.md"):
        if needle not in summary:
            failures.append(f"README summary missing {needle!r}: {summary!r}")
    if "No internal taps" not in markdown_summary([{"name": "x", "packet_bytes": 1}]):
        failures.append("summary of a tapless run should say so")

    for f in failures:
        print("FAIL: " + f)
    print(
        "bottleneck selftest: "
        + ("PASS" if not failures else f"{len(failures)} FAILURE(S)")
    )
    return 1 if failures else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(_selftest())
    if len(sys.argv) > 1:
        with open(sys.argv[1]) as f:
            results = json.load(f)
        analyze(results.get("phases", []), aad_len=results.get("config", {}).get("aad_len", 0),
                mac_config=results.get("config", {}).get("poly1305"))
        print(markdown_blocks(results.get("phases", [])))
        sys.exit(0)
    print(__doc__)
    print("run with --selftest, or pass a measurements/<label>/results.json")
