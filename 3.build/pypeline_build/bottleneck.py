#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Turns raw internal taps into a per-block throughput table and a named
bottleneck, so "where is the time going" is an output of the measurement rather
than a reading exercise.

Consumed by measure.py; importable and `--selftest`-able on its own (no
pypeline, no build, no Vivado -- same convention as perf_probe.py and
vivado_area.py).

Three things are derived from the taps that perf_taps.py collects:

1. **Per-block throughput and ceiling.** A block's input tap says how many bytes
   it actually moved (`bytes_per_cycle`) and -- via `service_period_cycles`,
   cycles per accepted beat *while work was offered* -- how fast it could move
   them if never starved. The latter is the block's in-situ ceiling and is what
   makes "ChaCha20 is faster than Poly1305" a measured statement.

2. **A bottleneck verdict.** The bottleneck is the block that backpressures its
   producer hardest without itself being backpressured. Blocks that merely relay
   somebody else's backpressure are walked through, so the verdict names the
   origin rather than the nearest symptom.

3. **A model cross-check.** The dominant per-packet cost of this design is
   predictable from first principles (Poly1305 block count x the MCP's
   launch-to-launch period). Reporting predicted-vs-measured per phase makes a
   design change legible immediately: a change that moves the measurement but
   not the model means the model's assumption is now wrong, and vice versa.
"""

import json
import math
import sys

# --- design facts the model needs -------------------------------------------
# make_valid_ready_mcp(poly1305_mac_loop_body, 5) in src/poly1305/poly1305.py.
# PipelineC's MCP asserts output valid at cycles_since_launch == ncycles+1 and
# re-arms `ready` the same cycle, so launch-to-launch is ncycles+1 cycles per
# 16 B Poly1305 block. This is the DESIGN INTENT figure; the measured period
# comes from the poly1305.data_in tap and is reported alongside it.
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
    "poly1305": {
        "consumes": "poly1305.data_in",
        "produces": "poly1305.tag_out",
        "downstream": (),
        "state": "poly1305.fsm",
        "what": "Poly1305 MAC (multi-cycle compute loop)",
    },
    "append_auth_tag": {
        "consumes": "append.axis_in",
        "produces": "append.axis_out",
        "downstream": (),
        "state": "append.fsm",
        "what": "tag merge into the ciphertext tail (encrypt out)",
    },
    "strip_auth_tag": {
        "consumes": "strip.axis_in",
        "produces": "strip.axis_out",
        "downstream": ("chacha20", "prep_auth_data"),
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


def _get(taps, label, name):
    return (taps or {}).get(f"{label}/{name}")


def _bytes_per_beat(tap):
    if not tap:
        return None
    bpb = tap.get("bytes_per_beat")
    if bpb:
        return bpb
    return BUS_BYTES if tap.get("xfer_cycles") else None


def block_rollup(taps, label):
    """Per-block achieved throughput, in-situ ceiling and stall split."""
    out = {}
    for name, spec in BLOCKS.items():
        tap_in = _get(taps, label, spec["consumes"])
        if not tap_in:
            continue
        tap_out = _get(taps, label, spec["produces"]) if spec["produces"] else None
        state = _get(taps, label, spec["state"]) if spec["state"] else None
        period = tap_in.get("service_period_cycles")
        per_beat = _bytes_per_beat(tap_in)
        entry = {
            "what": spec["what"],
            "in_tap": spec["consumes"],
            "cycles": tap_in.get("cycles"),
            "beats": tap_in.get("xfer_cycles"),
            # What it actually moved, over the whole phase window.
            "bytes_per_cycle": tap_in.get("bytes_per_cycle"),
            # What it could move if never starved: bytes/beat over cycles/beat
            # measured only across the cycles work was being offered to it.
            "ceiling_bytes_per_cycle": (
                (per_beat / period) if (per_beat and period) else None
            ),
            "service_period_cycles": period,
            "accept_rate": tap_in.get("accept_rate"),
            # Stall = this block backpressuring its producer (its own slowness).
            # Starve = this block waiting on its producer (somebody else's).
            "in_stall_frac": tap_in.get("stall_frac"),
            "in_starve_frac": tap_in.get("starve_frac"),
            "out_stall_frac": tap_out.get("stall_frac") if tap_out else None,
        }
        # Relay-limited: the block's own consumer pushed back on it at least as
        # hard as the block pushed back on its producer. Its input stalls are
        # then (at least partly) somebody else's, so its service period only
        # bounds its true speed from above and the ceiling is a LOWER bound.
        # (Measured case: encrypt ChaCha20 at 1920 B serves a beat every 5.4
        # cycles while its output stalls 57% of cycles behind Poly1305; with
        # slack at 256 B the same block serves one every 1.12 cycles.)
        out_stall = entry["out_stall_frac"] or 0.0
        in_stall = entry["in_stall_frac"] or 0.0
        entry["relay_limited"] = bool(
            tap_out and out_stall > 0.02 and out_stall >= in_stall * 0.9
        )
        if state:
            entry["dominant_state"] = state.get("dominant")
            entry["state_fracs"] = {
                k: v["frac"] for k, v in (state.get("states") or {}).items()
            }
        out[name] = entry
    return out


def find_bottleneck(blocks):
    """Name the block whose own slowness limits the direction.

    Ranked by how much of the phase it spent backpressuring its producer. A
    block that is itself backpressured at least as hard on its output is only
    relaying, so the walk continues downstream to the block actually causing it.
    """
    if not blocks:
        return None
    ranked = sorted(
        blocks.items(),
        key=lambda kv: (kv[1].get("in_stall_frac") or 0.0),
        reverse=True,
    )
    name, entry = ranked[0]
    seen = set()
    while True:
        seen.add(name)
        out_stall = entry.get("out_stall_frac") or 0.0
        in_stall = entry.get("in_stall_frac") or 0.0
        # Relaying: it holds up its producer only because its own consumer holds
        # IT up just as hard. Follow the hardest-stalling consumer we can see.
        candidates = [
            n
            for n in BLOCKS.get(name, {}).get("downstream", ())
            if n in blocks and n not in seen
        ]
        if candidates and out_stall >= in_stall * 0.9:
            nxt = max(candidates, key=lambda n: blocks[n].get("in_stall_frac") or 0.0)
            name, entry = nxt, blocks[nxt]
            continue
        break
    runner_up = next(((n, e) for n, e in ranked if n != name), None)
    verdict = {
        "block": name,
        "what": entry.get("what"),
        "in_stall_frac": entry.get("in_stall_frac"),
        "in_starve_frac": entry.get("in_starve_frac"),
        "service_period_cycles": entry.get("service_period_cycles"),
        "ceiling_bytes_per_cycle": entry.get("ceiling_bytes_per_cycle"),
        "dominant_state": entry.get("dominant_state"),
    }
    if runner_up:
        verdict["runner_up"] = {
            "block": runner_up[0],
            "in_stall_frac": runner_up[1].get("in_stall_frac"),
            "in_starve_frac": runner_up[1].get("in_starve_frac"),
        }
    verdict["evidence"] = _evidence_line(name, entry, runner_up)
    return verdict


def _pct(value):
    return "-" if value is None else f"{value * 100:.0f}%"


def _num(value, spec=".2f"):
    return "-" if not isinstance(value, (int, float)) else format(value, spec)


def _evidence_line(name, entry, runner_up):
    parts = [
        f"{name} backpressured its producer {_pct(entry.get('in_stall_frac'))} of the "
        f"phase (accept rate {_num(entry.get('accept_rate'), '.3f')}, "
        f"{_num(entry.get('service_period_cycles'))} cyc/beat while offered work, "
        f"ceiling {_num(entry.get('ceiling_bytes_per_cycle'))} B/cyc)"
    ]
    fracs = entry.get("state_fracs") or {}
    if fracs:
        # Top two states, not just the dominant one: on decrypt the MAC's IDLE
        # share (waiting for ChaCha20's poly key while prep already presents
        # AAD) is the part of its stall that is not the MCP itself.
        top = sorted(fracs.items(), key=lambda kv: kv[1], reverse=True)[:2]
        shown = [f"{n} {_pct(f)}" for n, f in top if f >= 0.10] or [
            f"{top[0][0]} {_pct(top[0][1])}"
        ]
        parts.append(f"its FSM sat in {', '.join(shown)} of cycles")
    if runner_up:
        parts.append(
            f"next-worst {runner_up[0]} stalled {_pct(runner_up[1].get('in_stall_frac'))} "
            f"but was itself starved {_pct(runner_up[1].get('in_starve_frac'))}"
        )
    return "; ".join(parts)


def model_for(packet_bytes, aad_len, measured_period, poly_tap=None):
    """First-principles per-packet cycle cost, against the measured period.

    Poly1305 sees ceil(aad/16) AAD blocks + ceil(len/16) ciphertext blocks + 1
    length block, each costing one MCP launch-to-launch period. That product
    alone accounts for the large majority of this design's packet period; the
    residual is everything else (key round trip, framing, tag tail, arbitration).
    """
    aad_blocks = math.ceil(aad_len / POLY1305_BLOCK_BYTES) if aad_len else 0
    ct_blocks = math.ceil(packet_bytes / POLY1305_BLOCK_BYTES)
    blocks = aad_blocks + ct_blocks + 1  # +1 for the aad_len||ct_len block
    measured_block_period = (poly_tap or {}).get("service_period_cycles")
    model = {
        "poly1305_blocks": blocks,
        "poly1305_block_period_cycles": POLY1305_BLOCK_PERIOD_CYCLES,
        "poly1305_model_cycles": blocks * POLY1305_BLOCK_PERIOD_CYCLES,
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
        POLY1305_BLOCK_BYTES / POLY1305_BLOCK_PERIOD_CYCLES
    )
    model["chacha20_ceiling_bytes_per_cycle"] = (
        CHACHA20_BLOCK_BYTES / CHACHA20_BEATS_PER_BLOCK
    )
    return model


def check_taps(taps):
    """Every probe fires exactly once per simulated cycle, so within a phase all
    taps must report the SAME cycle count.

    This is the guard on the epoch de-duplication in perf_probe._EpochTap: a body
    declaring Feedback[T] re-executes until it converges, and if that buffering
    ever broke, the taps inside such a body (chacha20_fsm, the shared-pipeline
    MAIN) would inflate while the ones outside it would not -- which shows up
    here as a spread, and would silently overstate every per-cycle rate.
    """
    counts = sorted({(t or {}).get("cycles") for t in taps.values()} - {None})
    if not counts:
        return None
    check = {"cycles": counts[0], "consistent": len(counts) == 1}
    if not check["consistent"]:
        check["cycles_seen"] = counts
        check["disagreeing_taps"] = sorted(
            name
            for name, t in taps.items()
            if (t or {}).get("cycles") not in (None, counts[0])
        )
    return check


def analyze_phase(phase, aad_len=0):
    """Add `blocks`, `bottleneck` and `model` to one phase dict, in place."""
    taps = phase.get("taps")
    if not taps:
        return phase
    check = check_taps(taps)
    if check:
        phase["taps_check"] = check
    blocks, bottleneck, model = {}, {}, {}
    for label in DIRECTIONS:
        rollup = block_rollup(taps, label)
        if not rollup:
            continue
        # A direction disabled via WG_PERF_DIRS (measure.py --dirs enc|dec) still
        # has probes firing -- its blocks just sit idle all run. Reporting a
        # "bottleneck" for a direction that moved nothing is noise, so an idle
        # direction is dropped rather than rolled up.
        if not any(entry.get("beats") for entry in rollup.values()):
            continue
        blocks[label] = rollup
        verdict = find_bottleneck(rollup)
        if verdict:
            bottleneck[label] = verdict
        direction = phase.get(label) or {}
        model[label] = model_for(
            phase.get("packet_bytes"),
            aad_len,
            direction.get("packet_period_cycles"),
            _get(taps, label, BLOCKS["poly1305"]["consumes"]),
        )
    # The shared ChaCha20 pipeline's arbitration is not per-direction.
    arb = {k: v for k, v in taps.items() if (v or {}).get("kind") == "arb"}
    if blocks:
        phase["blocks"] = blocks
    if bottleneck:
        phase["bottleneck"] = bottleneck
    if model:
        phase["model"] = model
    if arb:
        phase["arbitration"] = arb
    return phase


def analyze(phases, aad_len=0):
    for phase in phases:
        analyze_phase(phase, aad_len=aad_len)
    return phases


# --- reporting ---------------------------------------------------------------
BLOCK_CSV_COLUMNS = (
    "label", "phase", "packet_bytes", "direction", "block",
    "cycles", "beats", "bytes_per_cycle", "ceiling_bytes_per_cycle",
    "service_period_cycles", "accept_rate", "in_stall_frac", "in_starve_frac",
    "out_stall_frac", "dominant_state",
)


def block_rows(label, phases):
    for phase in phases:
        for direction, blocks in (phase.get("blocks") or {}).items():
            for name, e in blocks.items():
                yield [
                    label, phase["name"], phase["packet_bytes"], direction, name,
                    e.get("cycles"), e.get("beats"), e.get("bytes_per_cycle"),
                    e.get("ceiling_bytes_per_cycle"), e.get("service_period_cycles"),
                    e.get("accept_rate"), e.get("in_stall_frac"),
                    e.get("in_starve_frac"), e.get("out_stall_frac"),
                    e.get("dominant_state"),
                ]


TAP_CSV_COLUMNS = (
    "label", "phase", "packet_bytes", "tap", "kind", "cycles", "xfer_cycles",
    "stall_cycles", "starved_cycles", "idle_cycles", "accept_rate",
    "service_period_cycles", "beats_per_cycle", "bytes_per_cycle",
    "stall_frac", "starve_frac", "dominant_state",
)


def tap_rows(label, phases):
    for phase in phases:
        for name, tap in sorted((phase.get("taps") or {}).items()):
            if not tap:
                continue
            yield [
                label, phase["name"], phase["packet_bytes"], name, tap.get("kind"),
                tap.get("cycles"), tap.get("xfer_cycles"), tap.get("stall_cycles"),
                tap.get("starved_cycles"), tap.get("idle_cycles"),
                tap.get("accept_rate"), tap.get("service_period_cycles"),
                tap.get("beats_per_cycle"), tap.get("bytes_per_cycle"),
                tap.get("stall_frac"), tap.get("starve_frac"), tap.get("dominant"),
            ]


def best_ceiling(phases, direction, block):
    """(ceiling B/cyc, phase, exact?) for one block across the whole sweep.

    Contamination only ever ADDS stall cycles to a block's input, so a service
    period is an upper bound on the block's true period. For a block that is not
    relay-limited the largest packet size is the cleanest reading; for a
    relay-limited one the best (highest) observation is the tightest lower bound.
    """
    rows = []
    for phase in phases:
        entry = ((phase.get("blocks") or {}).get(direction) or {}).get(block)
        if entry and entry.get("ceiling_bytes_per_cycle"):
            rows.append((phase, entry))
    if not rows:
        return None
    phase, entry = max(rows, key=lambda r: r[0].get("packet_bytes") or 0)
    if not entry.get("relay_limited"):
        return entry["ceiling_bytes_per_cycle"], phase, True
    phase, entry = max(rows, key=lambda r: r[1]["ceiling_bytes_per_cycle"])
    return entry["ceiling_bytes_per_cycle"], phase, False


def headline(phases):
    """One generated sentence per direction answering the question the whole tap
    system exists for: which block is slower, by how much, and how close to that
    block's ceiling the design is already running.

    Taken from the largest packet size measured, where per-packet fixed costs are
    most amortised and the block ceilings are therefore most visible.
    """
    out = []
    for direction in DIRECTIONS:
        chacha = best_ceiling(phases, direction, "chacha20")
        poly = best_ceiling(phases, direction, "poly1305")
        if not (chacha and poly):
            continue
        (c_val, c_phase, c_exact), (p_val, p_phase, p_exact) = chacha, poly
        slower = "Poly1305" if p_val < c_val else "ChaCha20"
        s_val, s_phase = (p_val, p_phase) if slower == "Poly1305" else (c_val, c_phase)
        ratio = max(c_val, p_val) / min(c_val, p_val)
        at_least = "at least " if not (c_exact and p_exact) else ""
        text = (
            f"- **{direction}**: ChaCha20 serves **{'' if c_exact else '≥'}"
            f"{_num(c_val)} B/cyc** when fed (@{c_phase['packet_bytes']} B), "
            f"Poly1305 **{'' if p_exact else '≥'}{_num(p_val)} B/cyc** "
            f"(@{p_phase['packet_bytes']} B) — {slower} is the slower block by "
            f"{at_least}**{_num(ratio, '.1f')}x**"
        )
        achieved = (s_phase.get(direction) or {}).get("sustained_bytes_per_cycle")
        if achieved:
            text += (
                f"; at {s_phase['packet_bytes']} B the whole datapath delivers "
                f"{_num(achieved)} B/cyc, **{_pct(achieved / s_val)} of "
                f"{slower}'s ceiling**"
            )
        out.append(text + ".")
    if not out:
        return []
    return [
        "**Headline.** A block that is not relay-limited is quoted at the largest "
        "packet size (least per-packet overhead); a relay-limited one (its own "
        "output backpressured, so its in-situ ceiling is only a lower bound, "
        "marked ≥) is quoted at its best observation across the sweep:",
        "",
    ] + out


def markdown_blocks(phases):
    """The generated block-level table + per-phase bottleneck verdicts."""
    any_blocks = any(p.get("blocks") for p in phases)
    if not any_blocks:
        return (
            "_No internal taps in this run — re-measure with "
            "`./measure.py --taps all` to populate this section._"
        )
    lines = []
    head = headline(phases)
    if head:
        lines.extend(head)
        lines.append("")
    lines.append(
        "| phase | bytes | dir | block | B/cyc | ceiling B/cyc | svc period (clk) "
        "| in stall | in starved | dominant FSM state |"
    )
    lines.append("|---|---|---|---|---|---|---|---|---|---|")
    table_start = len(lines)
    for phase in phases:
        for direction in DIRECTIONS:
            blocks = (phase.get("blocks") or {}).get(direction)
            if not blocks:
                continue
            order = [b for b in BLOCKS if b in blocks]
            for name in order:
                e = blocks[name]
                state = e.get("dominant_state") or "-"
                frac = (e.get("state_fracs") or {}).get(e.get("dominant_state"))
                if frac is not None:
                    state = f"{state} ({_pct(frac)})"
                lines.append(
                    f"| {phase['name']} | {phase['packet_bytes']} | {direction} "
                    f"| {name} | {_num(e.get('bytes_per_cycle'), '.3f')} "
                    f"| {'≥' if e.get('relay_limited') else ''}"
                    f"{_num(e.get('ceiling_bytes_per_cycle'), '.3f')} "
                    f"| {_num(e.get('service_period_cycles'))} "
                    f"| {_pct(e.get('in_stall_frac'))} "
                    f"| {_pct(e.get('in_starve_frac'))} | {state} |"
                )
    lines.append("")
    lines.append(
        "`ceiling B/cyc` marked **≥** is a lower bound: that block's own output was "
        "backpressured at least as hard as its input, so part of its input stall "
        "is relayed from downstream rather than its own."
    )
    lines.append("")
    lines.append("**Bottleneck per phase** (the block whose own service rate limits "
                 "the direction, after walking past blocks that only relay "
                 "backpressure):")
    lines.append("")
    lines.append("| phase | bytes | dir | bottleneck | why |")
    lines.append("|---|---|---|---|---|")
    for phase in phases:
        for direction in DIRECTIONS:
            verdict = (phase.get("bottleneck") or {}).get(direction)
            if not verdict:
                continue
            lines.append(
                f"| {phase['name']} | {phase['packet_bytes']} | {direction} "
                f"| **{verdict['block']}** | {verdict['evidence']} |"
            )
    arb_lines = markdown_arbitration(phases)
    if arb_lines:
        lines.append("")
        lines.extend(arb_lines)
    model_lines = markdown_model(phases)
    if model_lines:
        lines.append("")
        lines.extend(model_lines)
    return "\n".join(lines)


def _blocked_frac(per):
    """Share of a requester's wanted cycles spent on its own slot with the shared
    resource not ready. Derived from the partition identity when an older
    snapshot has no blocked_cycles field."""
    req = per.get("req_cycles") or 0
    if not req:
        return None
    blocked = per.get("blocked_cycles")
    if blocked is None:
        blocked = (
            req - per["xfer_cycles"] - per["contention_cycles"]
            - per["wasted_slot_cycles"]
        )
    return blocked / req


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
    verdicts = {}
    total = 0
    for phase in analysed:
        for direction in DIRECTIONS:
            verdict = (phase.get("bottleneck") or {}).get(direction)
            if verdict:
                verdicts.setdefault(verdict["block"], []).append(
                    f"{direction} @ {phase['packet_bytes']} B"
                )
                total += 1
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
        states = ", ".join(f"{n} {_pct(f)}" for n, f in top if f >= 0.10)
        text = (
            f"{direction} one beat per {_num(entry.get('service_period_cycles'))} "
            f"cycles, stalling its producer {_pct(entry.get('in_stall_frac'))} of cycles"
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
                f"up to {_pct(e.get('out_stall_frac'))}, at {p['packet_bytes']} B)"
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
                f"wanted cycles (pipeline not ready {_pct(_blocked_frac(per))}, "
                f"contention {_pct(per.get('contention_frac'))}, wasted slot "
                f"{_pct(per.get('wasted_slot_frac'))})"
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
            f"{direction} {_pct(min(fr))}–{_pct(max(fr))} (residual "
            f"{_num(min(rs), '.0f')}–{_num(max(rs), '.0f')} cycles per packet)"
        )
    if fits:
        lines.append(
            f"- **Model cross-check:** Poly1305 block count × its "
            f"{POLY1305_BLOCK_PERIOD_CYCLES}-cycle block period accounts for "
            + "; ".join(fits) + " of the measured packet period."
        )

    if detail_path:
        lines.append(
            f"- Full per-phase, per-block tables (FSM states, bottleneck evidence, "
            f"arbitration, model): `{detail_path}`."
        )
    return "\n".join(lines)


def markdown_arbitration(phases):
    """The shared ChaCha20 pipeline's round-robin cost, per direction."""
    rows = []
    for phase in phases:
        for name, tap in sorted((phase.get("arbitration") or {}).items()):
            for label, per in (tap.get("per_requester") or {}).items():
                req = per.get("req_cycles")
                if not req:
                    continue
                # Every wanted cycle is exactly one of: launched, selected but the
                # pipeline not ready, other side selected and wanting it
                # (contention), other side selected and idle (wasted slot). Older
                # snapshots lack blocked_cycles, so derive it from that identity.
                blocked = per.get("blocked_cycles")
                if blocked is None:
                    blocked = (
                        req - per["xfer_cycles"] - per["contention_cycles"]
                        - per["wasted_slot_cycles"]
                    )
                rows.append(
                    f"| {phase['name']} | {phase['packet_bytes']} | {label} "
                    f"| {req} | {per['xfer_cycles']} "
                    f"| {_pct(blocked / req)} "
                    f"| {_pct(per['contention_frac'])} "
                    f"| {_pct(per['wasted_slot_frac'])} |"
                )
    if not rows:
        return []
    head = [
        "**Shared-pipeline arbitration** — of the cycles a direction wanted to "
        "launch into the shared ChaCha20 pipeline: *pipeline not ready* is its "
        "own slot with the pipeline unable to accept (a full pipeline — including "
        "head-of-line blocking by the OTHER direction's blocks waiting at the "
        "shared output), *contention* is the other side holding the slot and "
        "wanting it, *wasted slot* is the other side holding the slot with nothing "
        "to launch (`is_encrypt` flips every cycle unconditionally; a "
        "request-aware arbiter would recover these):",
        "",
        "| phase | bytes | dir | wanted (clk) | launched (clk) | pipeline not ready "
        "| contention | wasted slot |",
        "|---|---|---|---|---|---|---|---|",
    ]
    return head + rows


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
                f"| {_num(m.get('poly1305_measured_block_period_cycles'))} "
                f"| {_num(m['measured_packet_period_cycles'], '.1f')} "
                f"| {_pct(m.get('poly1305_frac_of_period'))} "
                f"| {_num(m.get('residual_cycles'), '.1f')} |"
            )
    if not rows:
        return []
    head = [
        "**Model cross-check** — Poly1305 block count x the MCP's "
        f"{POLY1305_BLOCK_PERIOD_CYCLES}-cycle launch-to-launch period, against the "
        "measured packet period. The residual is everything that is not the MAC "
        "loop (poly key round trip, framing, tag tail, arbitration):",
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
        analyze(results.get("phases", []), aad_len=results.get("config", {}).get("aad_len", 0))
        print(markdown_blocks(results.get("phases", [])))
        sys.exit(0)
    print(__doc__)
    print("run with --selftest, or pass a measurements/<label>/results.json")
