# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Plain-Python (no pypeline/hardware import) QoR measurement layer for the
performance testbenches: per-cycle handshake/byte accounting, per-packet
latency bookkeeping, a phase sequencer with a cross-direction barrier, and the
incremental JSON writer.

Everything here is cycle-domain only -- cycles, beats, bytes. Nothing is
converted to MHz/Gb/s, so the same measured run can be re-expressed at any
fmax later without re-simulating (measure.py does that conversion).

Shape of a run (see perf_tb_common.py for the plan and the singletons):

    phase 0: N back-to-back packets of S bytes, both directions concurrently
             -> drain -> barrier -> phase 1 ...

One `DirectionMeter` per direction owns that direction's counters and its own
cycle counter, fed from the testbench's `@sim_input` (input side) and
`@sim_output` (output side) glue -- the same "stepped once per cycle from a
sim callback" shape as `AxisSimSource`/`AxisSimSink` in PipelineC's
include/pypeline/axi/axis_sim.py.

Cycle numbering: `note_in(...)` is called from `@sim_input` during the
convergence loop of cycle N, `note_out(...)`/`tick()` from `@sim_output` in the
final (converged) pass of the same cycle N, and `tick()` increments the counter
last -- so both sides of a cycle agree on N. `note_in`/`note_out` are
idempotent per cycle, so a convergence re-entry can never double-count.
"""

import json
import os
import statistics


class HandshakeTap:
    """Duty/stall counters for one internal valid/ready handshake -- the
    extension point for narrowing in on a bottleneck.

    To tap an internal stream, register a name in `WG_PERF_TAPS` and add one
    line to a `@sim_output` reading that interface's wires, e.g.

        tap = perf_tb_common.TAPS.tap("chacha_shared_enc_in")
        tap.note(chacha20_pipeline_shared.encrypt_pipeline_in_if.stream.valid,
                 chacha20_pipeline_shared.encrypt_pipeline_in_if.ready)

    Counters are snapshotted (and zeroed) per phase, landing in the phase's
    `"taps"` dict. Disabled taps are `NullTap`s, so an unused tap costs one
    no-op call per cycle.
    """

    def __init__(self, name):
        self.name = name
        self.reset()

    def reset(self):
        self.cycles = 0
        self.valid_cycles = 0
        self.ready_cycles = 0
        self.xfer_cycles = 0
        self.stall_cycles = 0  # valid & ~ready: producer held up by consumer

    def note(self, valid, ready):
        valid = 1 if valid else 0
        ready = 1 if ready else 0
        self.cycles += 1
        self.valid_cycles += valid
        self.ready_cycles += ready
        if valid and ready:
            self.xfer_cycles += 1
        elif valid:
            self.stall_cycles += 1

    def snapshot(self):
        window = self.cycles or 1
        return {
            "cycles": self.cycles,
            "valid_cycles": self.valid_cycles,
            "ready_cycles": self.ready_cycles,
            "xfer_cycles": self.xfer_cycles,
            "stall_cycles": self.stall_cycles,
            "duty": self.xfer_cycles / window,
            "stall_frac": self.stall_cycles / window,
        }


class NullTap:
    """A tap that was not enabled via WG_PERF_TAPS: every call is a no-op."""

    name = None

    def note(self, valid, ready):
        pass

    def reset(self):
        pass

    def snapshot(self):
        return None


class TapRegistry:
    """Name -> HandshakeTap for the taps enabled this run; unknown/disabled
    names get a NullTap so testbench code never branches on availability."""

    def __init__(self, enabled=()):
        self.enabled = set(n for n in enabled if n)
        self._taps = {}
        self._null = NullTap()

    def tap(self, name):
        if name not in self.enabled:
            return self._null
        if name not in self._taps:
            self._taps[name] = HandshakeTap(name)
        return self._taps[name]

    def snapshot(self):
        return {name: tap.snapshot() for name, tap in sorted(self._taps.items())}

    def reset(self):
        for tap in self._taps.values():
            tap.reset()


class PhaseBarrier:
    """Keeps every direction in the same phase: a direction that has drained
    `arrive()`s and waits until all participants have, so each phase measures
    the same packet size under the same contention on the shared ChaCha20
    pipeline."""

    def __init__(self, participants):
        self.participants = list(participants)
        self._arrived = {}

    def arrive(self, who, phase_idx):
        self._arrived.setdefault(phase_idx, set()).add(who)

    def released(self, phase_idx):
        return len(self._arrived.get(phase_idx, ())) >= len(self.participants)


class PerfRecorder:
    """Collects both directions' per-phase results and (re)writes the JSON
    after every completed phase, so a killed or hung run still leaves usable
    data behind."""

    def __init__(self, path, config):
        self.path = path
        self.config = dict(config)
        self.phases = {}  # phase_idx -> {"name":..., "encrypt": {...}, ...}
        self.errors = []
        self.packets_checked = 0
        self.finalized = False
        self.total_cycles = None

    def record_phase(self, phase_idx, phase, direction, result, taps=None):
        entry = self.phases.setdefault(
            phase_idx,
            {
                "name": phase["name"],
                "packet_bytes": phase["packet_bytes"],
                "num_packets": phase["num_packets"],
            },
        )
        entry[direction] = result
        if taps:
            entry["taps"] = taps
        if result.get("timed_out"):
            entry["timed_out"] = True
        self.write()

    def note_error(self, message):
        # Bounded: a systematically broken run must not grow the JSON without
        # limit (or hide the first, most useful, failure behind thousands).
        if len(self.errors) < 100:
            self.errors.append(message)

    def as_dict(self):
        return {
            "schema_version": 1,
            "source": "perf_tb",
            "config": self.config,
            "phases": [self.phases[i] for i in sorted(self.phases)],
            "checks": {
                "functional_pass": not self.errors,
                "packets_checked": self.packets_checked,
                "errors": self.errors,
            },
            "sim": {"total_cycles": self.total_cycles, "finalized": self.finalized},
        }

    def write(self):
        if not self.path:
            return
        tmp = self.path + ".tmp"
        d = os.path.dirname(os.path.abspath(self.path))
        if d:
            os.makedirs(d, exist_ok=True)
        with open(tmp, "w") as f:
            json.dump(self.as_dict(), f, indent=1, sort_keys=False)
        os.replace(tmp, self.path)

    def finalize(self, total_cycles=None):
        self.total_cycles = total_cycles
        self.finalized = True
        self.write()


def _median(values):
    return statistics.median(values) if values else None


class DirectionMeter:
    """Per-cycle measurement state for one direction's AXIS in/out pair."""

    STEADY_MIN_BEATS = 20
    STEADY_MIN_SPAN_CYCLES = 8

    def __init__(self, name, bus_bytes):
        self.name = name
        self.bus_bytes = bus_bytes
        self.cycle = 0
        self._in_noted_cycle = -1
        self._out_noted_cycle = -1
        self.reset_phase()

    def reset_phase(self):
        self.window_cycles_counted = 0
        self.in_valid_cycles = 0
        self.in_accepted_beats = 0
        self.in_stall_cycles = 0
        self.in_bytes = 0
        self.out_beats = 0
        self.out_bytes = 0
        self.first_in_cycle = None
        self.last_in_cycle = None
        self.first_out_cycle = None
        self.last_out_cycle = None
        self._in_packet_open = False
        self._out_packet_open = False
        self.in_packets = []  # [{"first_in":c, "last_in":c, "bytes":n}, ...]
        self.out_packets = []  # [{"first_out":c, "last_out":c, "bytes":n}, ...]
        self.out_trace = []  # [(cycle, cumulative_out_bytes)] for steady-state rate
        self.in_trace = []  # [(cycle, cumulative_accepted_in_bytes)], likewise
        self.last_activity_cycle = self.cycle

    # ---- input side, called once per cycle from @sim_input ----------------
    def note_in(self, valid, ready, keep_count, eod):
        if self._in_noted_cycle == self.cycle:
            return False
        self._in_noted_cycle = self.cycle
        valid = 1 if valid else 0
        ready = 1 if ready else 0
        if valid:
            self.in_valid_cycles += 1
        accepted = bool(valid and ready)
        if valid and not ready:
            self.in_stall_cycles += 1
        if not accepted:
            return False
        self.in_accepted_beats += 1
        self.in_bytes += keep_count
        self.in_trace.append((self.cycle, self.in_bytes))
        self.last_activity_cycle = self.cycle
        if self.first_in_cycle is None:
            self.first_in_cycle = self.cycle
        self.last_in_cycle = self.cycle
        if not self._in_packet_open:
            self.in_packets.append(
                {"first_in": self.cycle, "last_in": self.cycle, "bytes": 0}
            )
            self._in_packet_open = True
        pkt = self.in_packets[-1]
        pkt["last_in"] = self.cycle
        pkt["bytes"] += keep_count
        if eod:
            self._in_packet_open = False
        return True

    # ---- output side, called once per cycle from @sim_output --------------
    def note_out(self, valid, keep_count, eod):
        """Returns True on the cycle an output packet completes (eod beat).

        The sink always presents ready=1 (AxisSimSink), so a valid output beat
        is always accepted -- every throughput number here is therefore an
        upper bound with an infinitely fast consumer.
        """
        if self._out_noted_cycle == self.cycle:
            return False
        self._out_noted_cycle = self.cycle
        if not valid:
            return False
        self.out_beats += 1
        self.out_bytes += keep_count
        self.last_activity_cycle = self.cycle
        if self.first_out_cycle is None:
            self.first_out_cycle = self.cycle
        self.last_out_cycle = self.cycle
        self.out_trace.append((self.cycle, self.out_bytes))
        if not self._out_packet_open:
            self.out_packets.append(
                {"first_out": self.cycle, "last_out": self.cycle, "bytes": 0}
            )
            self._out_packet_open = True
        pkt = self.out_packets[-1]
        pkt["last_out"] = self.cycle
        pkt["bytes"] += keep_count
        if eod:
            self._out_packet_open = False
            return True
        return False

    def tick(self):
        """Once per cycle, last thing in the direction's @sim_output."""
        self.window_cycles_counted += 1
        self.cycle += 1

    # ---- results ---------------------------------------------------------
    def _steady_bytes_per_cycle(self, trace):
        """Byte rate over the middle 80% of `trace`'s beats -- excludes pipeline
        fill/drain, which is what makes a single long packet's number a peak
        rather than an average.

        Measured on BOTH sides, because they answer different questions and can
        differ by a lot:

        - input side (`steady_in_bytes_per_cycle`): how fast the DUT sustains
          *accepting* data. This is the throughput-relevant number -- it is
          limited by the datapath, via backpressure.
        - output side (`steady_out_bytes_per_cycle`): how fast bytes leave. For
          DECRYPT this is NOT a throughput figure: wait_to_verify holds the whole
          plaintext until Poly1305 returns its verdict and then drains it at full
          line rate, so this reads 16 B/cycle (the bus width) no matter how
          slowly the packet was actually processed.

        NEITHER is a sustained-throughput figure when packets are processed
        serially with gaps between them, which is this design's behaviour: both
        measure "how fast bytes move while they are moving", so a phase whose
        input arrives in one back-to-back burst per packet reads close to the
        16 B/cycle bus width on the input side too. They are diagnostics for
        burst behaviour. The sustained number is `sustained_bytes_per_cycle`
        (inter-packet period, above); `bytes_per_cycle` over the whole window is
        the conservative end-to-end alternative.
        """
        n = len(trace)
        # Needs enough beats that the middle 80% is a real window: with only a
        # handful of beats the trimmed span can collapse to one or two cycles
        # and report a meaningless burst rate (e.g. 16 B / 1 cycle).
        if n < self.STEADY_MIN_BEATS:
            return None
        lo = int(0.1 * n)
        hi = int(0.9 * n) - 1
        if hi <= lo:
            return None
        c_lo, b_lo = trace[lo]
        c_hi, b_hi = trace[hi]
        if c_hi - c_lo < self.STEADY_MIN_SPAN_CYCLES:
            return None
        return (b_hi - b_lo) / (c_hi - c_lo)

    def phase_result(self, phase, timed_out=False):
        goodput_bytes = phase["packet_bytes"] * phase["num_packets"]
        if self.first_in_cycle is None or self.last_out_cycle is None:
            window = None
        else:
            window = self.last_out_cycle - self.first_in_cycle + 1
        packets = []
        heads = []
        totals = []
        for idx, out_pkt in enumerate(self.out_packets):
            in_pkt = self.in_packets[idx] if idx < len(self.in_packets) else None
            head = total = None
            if in_pkt is not None:
                head = out_pkt["first_out"] - in_pkt["first_in"]
                total = out_pkt["last_out"] - in_pkt["first_in"]
                heads.append(head)
                totals.append(total)
            packets.append(
                {
                    "idx": idx,
                    "in_bytes": in_pkt["bytes"] if in_pkt else None,
                    "out_bytes": out_pkt["bytes"],
                    "first_in": in_pkt["first_in"] if in_pkt else None,
                    "first_out": out_pkt["first_out"],
                    "last_out": out_pkt["last_out"],
                    "head_latency": head,
                    "total_latency": total,
                }
            )
        # Sustained rate, averaged over same-size packets back to back: the mean
        # number of cycles between consecutive packet completions. This drops the
        # first packet's pipeline-fill cost entirely (it measures period, not
        # end-to-end time), so it is the number that extrapolates to a long
        # stream of this packet size -- whereas `bytes_per_cycle` over the whole
        # window still carries the one-off fill of the phase's first packet.
        # Needs at least 2 completed packets.
        packet_period = None
        sustained = None
        if len(self.out_packets) >= 2:
            span = self.out_packets[-1]["last_out"] - self.out_packets[0]["last_out"]
            intervals = len(self.out_packets) - 1
            packet_period = span / intervals
            if packet_period > 0:
                sustained = phase["packet_bytes"] / packet_period

        w = window or 1
        return {
            "window_cycles": window,
            "goodput_bytes": goodput_bytes,
            "in_beats": self.in_accepted_beats,
            "out_beats": self.out_beats,
            "in_line_bytes": self.in_accepted_beats * self.bus_bytes,
            "out_line_bytes": self.out_beats * self.bus_bytes,
            "in_payload_bytes": self.in_bytes,
            "out_payload_bytes": self.out_bytes,
            "beats_per_packet": (
                self.out_beats / phase["num_packets"] if phase["num_packets"] else None
            ),
            "bytes_per_cycle": (goodput_bytes / window) if window else None,
            "packet_period_cycles": packet_period,
            "sustained_bytes_per_cycle": sustained,
            "steady_in_bytes_per_cycle": self._steady_bytes_per_cycle(self.in_trace),
            "steady_out_bytes_per_cycle": self._steady_bytes_per_cycle(self.out_trace),
            "in_duty": self.in_accepted_beats / w,
            "out_duty": self.out_beats / w,
            "in_stall_cycles": self.in_stall_cycles,
            "in_stall_frac": self.in_stall_cycles / w,
            "latency_cycles": {
                "cold_head": heads[0] if heads else None,
                "head_min": min(heads) if heads else None,
                "head_med": _median(heads),
                "head_max": max(heads) if heads else None,
                "total_min": min(totals) if totals else None,
                "total_med": _median(totals),
                "total_max": max(totals) if totals else None,
            },
            "packets": packets,
            "packets_in": len(self.in_packets),
            "packets_out": len(self.out_packets),
            "timed_out": bool(timed_out),
            "first_in_cycle": self.first_in_cycle,
            "last_out_cycle": self.last_out_cycle,
        }


class DirectionRunner:
    """Drives one direction through the phase plan and records its metrics.

    `frame_builder(length, rng)` -> `(in_frame_bytes, expected_out_bytes, meta)`
    is the only direction-specific piece (encrypt streams plaintext in and
    expects ciphertext+tag out; decrypt streams ciphertext+tag in and expects
    plaintext out), so both testbenches share this whole state machine.
    """

    IDLE_SETTLE_CYCLES = 8  # let DUT internals settle between phases

    def __init__(
        self,
        name,
        phases,
        barrier,
        recorder,
        src,
        snk,
        scoreboard,
        frame_builder,
        bus_bytes=16,
        seed=0,
        max_cycles_per_phase=None,
        settle_cycles=None,
        stall_timeout_cycles=None,
    ):
        self.name = name
        self.phases = phases
        self.barrier = barrier
        self.recorder = recorder
        self.src = src
        self.snk = snk
        self.scoreboard = scoreboard
        self.frame_builder = frame_builder
        self.bus_bytes = bus_bytes
        self.seed = seed
        self.max_cycles_per_phase = max_cycles_per_phase
        # Fail fast on a real deadlock (a full/never-drained FIFO, a lost
        # handshake) instead of burning hours up to max_cycles_per_phase:
        # native sim of this design runs at roughly half a second per cycle.
        self.stall_timeout_cycles = stall_timeout_cycles
        self.settle_cycles = (
            self.IDLE_SETTLE_CYCLES if settle_cycles is None else settle_cycles
        )
        self.meter = DirectionMeter(name, bus_bytes)
        self.phase_idx = 0
        self.queued = False
        self.checked = 0
        self.phase_start_cycle = 0
        self.drained_at = None
        self.reported = False
        # A direction with an empty plan (disabled via WG_PERF_DIRS) is done
        # immediately: it never queues, so it drives valid=0 all run long.
        self.done = self.phase_idx >= len(self.phases)
        self.pending_log = []  # human-readable lines for the TB to sim_print

    # ---- phase plumbing --------------------------------------------------
    @property
    def phase(self):
        if self.phase_idx < len(self.phases):
            return self.phases[self.phase_idx]
        return None

    def prepare_input(self):
        """Queue the whole phase's packets at once (AxisSimSource streams them
        back-to-back with no inter-packet gap), from @sim_input."""
        phase = self.phase
        if phase is None or self.queued:
            return
        import random

        rng = random.Random((self.seed, self.phase_idx, self.name))
        for idx in range(phase["num_packets"]):
            in_frame, expected_out, meta = self.frame_builder(
                phase["packet_bytes"], rng
            )
            self.scoreboard.expect(expected_out, idx=idx, **meta)
            self.src.send(in_frame)
        self.queued = True
        self.pending_log.append(
            f"{self.name}: phase {self.phase_idx} '{phase['name']}': "
            f"{phase['num_packets']} x {phase['packet_bytes']} B queued"
        )

    def note_in(self, valid, ready, keep_count, eod):
        self.meter.note_in(valid, ready, keep_count, eod)

    def note_out(self, valid, keep_count, eod):
        return self.meter.note_out(valid, keep_count, eod)

    def note_checked(self, passed, message=None):
        self.checked += 1
        self.recorder.packets_checked += 1
        if not passed:
            text = f"{self.name}: {message}"
            self.recorder.note_error(text)
            self.pending_log.append("ERROR: " + text)

    def tick(self):
        """Advance the phase state machine, then the cycle counter. Last thing
        in this direction's @sim_output."""
        phase = self.phase
        if phase is not None and self.queued and not self.reported:
            elapsed = self.meter.cycle - self.phase_start_cycle
            idle_for = self.meter.cycle - self.meter.last_activity_cycle
            timed_out = (
                self.max_cycles_per_phase is not None
                and elapsed > self.max_cycles_per_phase
            ) or (
                self.stall_timeout_cycles is not None
                and idle_for > self.stall_timeout_cycles
            )
            complete = (
                self.checked >= phase["num_packets"]
                and self.src.idle()
                and self.snk.empty()
            )
            if complete and self.drained_at is None:
                self.drained_at = self.meter.cycle
            settled = (
                self.drained_at is not None
                and self.meter.cycle - self.drained_at >= self.settle_cycles
            )
            if settled or timed_out:
                if timed_out:
                    self.recorder.note_error(
                        f"{self.name}: phase '{phase['name']}' timed out after "
                        f"{elapsed} cycles, idle {idle_for} "
                        f"({self.checked}/{phase['num_packets']} packets checked)"
                    )
                self.recorder.record_phase(
                    self.phase_idx,
                    phase,
                    self.name,
                    self.meter.phase_result(phase, timed_out=timed_out),
                )
                self.pending_log.append(
                    f"{self.name}: phase {self.phase_idx} '{phase['name']}' DONE"
                )
                self.reported = True
                self.barrier.arrive(self.name, self.phase_idx)
        # Both directions reported this phase: start the next one together.
        if self.reported and self.barrier.released(self.phase_idx):
            self._next_phase()
        self.meter.tick()

    def _next_phase(self):
        self.phase_idx += 1
        self.queued = False
        self.checked = 0
        self.reported = False
        self.drained_at = None
        self.meter.reset_phase()
        self.phase_start_cycle = self.meter.cycle
        if self.phase is None:
            self.done = True

    def drain_log(self):
        lines = self.pending_log
        self.pending_log = []
        return lines


# ---------------------------------------------------------------------------
# Selftest: the metric definitions are what every future variant gets compared
# on, so they get checked against a hand-worked synthetic trace -- no build, no
# simulator, no Vivado needed. Run: python3 perf_probe.py --selftest
# ---------------------------------------------------------------------------
def _selftest():
    bus = 16
    phase = {"name": "t", "packet_bytes": 32, "num_packets": 2}
    m = DirectionMeter("t", bus)
    # Hand-worked schedule. in: pkt0 beats at cycles 0,1; a stall at 2 (valid but
    # not ready); pkt1 beats at 3,4. out: pkt0 at 10,11; pkt1 at 20,21.
    in_sched = {
        0: (1, 1, bus, 0),
        1: (1, 1, bus, 1),
        2: (1, 0, bus, 0),  # stalled by the DUT, not accepted
        3: (1, 1, bus, 0),
        4: (1, 1, bus, 1),
    }
    out_sched = {
        10: (1, bus, 0),
        11: (1, bus, 1),
        20: (1, bus, 0),
        21: (1, bus, 1),
    }
    for cycle in range(22):
        if cycle in in_sched:
            m.note_in(*in_sched[cycle])
            m.note_in(*in_sched[cycle])  # idempotence: must not double-count
        if cycle in out_sched:
            m.note_out(*out_sched[cycle])
            m.note_out(*out_sched[cycle])
        m.tick()

    res = m.phase_result(phase)
    lat = res["latency_cycles"]
    checks = [
        ("window_cycles", res["window_cycles"], 22),  # 21 - 0 + 1
        ("in_beats", res["in_beats"], 4),  # the stalled cycle is not a beat
        ("out_beats", res["out_beats"], 4),
        ("in_stall_cycles", res["in_stall_cycles"], 1),
        ("goodput_bytes", res["goodput_bytes"], 64),
        ("bytes_per_cycle", res["bytes_per_cycle"], 64 / 22),
        ("in_duty", res["in_duty"], 4 / 22),
        ("out_duty", res["out_duty"], 4 / 22),
        ("packets_out", res["packets_out"], 2),
        ("cold_head", lat["cold_head"], 10),  # pkt0: first out 10 - first in 0
        ("head_max", lat["head_max"], 17),  # pkt1: 20 - 3
        ("total_min", lat["total_min"], 11),  # pkt0: 11 - 0
        ("total_max", lat["total_max"], 18),  # pkt1: 21 - 3
        # too few beats for a trimmed steady-state window to mean anything
        ("steady_in_bytes_per_cycle", res["steady_in_bytes_per_cycle"], None),
        ("steady_out_bytes_per_cycle", res["steady_out_bytes_per_cycle"], None),
        ("beats_per_packet", res["beats_per_packet"], 2.0),
        ("packet_period_cycles", res["packet_period_cycles"], 10.0),  # 21 - 11
        ("sustained_bytes_per_cycle", res["sustained_bytes_per_cycle"], 32 / 10.0),
    ]
    failures = []
    for name, got, want in checks:
        ok = (
            got == want
            if not isinstance(want, float)
            else abs(got - want) < 1e-9
        )
        if not ok:
            failures.append(f"{name}: expected {want!r} got {got!r}")

    # A long single packet must produce a steady-state rate: 40 back-to-back
    # output beats, one per cycle, is exactly 16 B/cycle.
    m2 = DirectionMeter("t2", bus)
    for cycle in range(40):
        m2.note_in(1, 1, bus, 1 if cycle == 39 else 0)
        m2.note_out(1, bus, 1 if cycle == 39 else 0)
        m2.tick()
    res2 = m2.phase_result({"name": "p", "packet_bytes": 640, "num_packets": 1})
    for field in ("steady_in_bytes_per_cycle", "steady_out_bytes_per_cycle"):
        steady = res2[field]
        if steady is None or abs(steady - bus) > 1e-9:
            failures.append(f"{field}: expected {bus} got {steady!r}")

    # A DUT that accepts one beat every 4th cycle sustains 4 B/cycle on the input
    # side even while its output drains in a back-to-back burst (the decrypt
    # wait-to-verify shape): the two steady numbers must not be conflated.
    m3 = DirectionMeter("t3", bus)
    for cycle in range(120):
        accepted = cycle % 4 == 0
        m3.note_in(1, 1 if accepted else 0, bus, 1 if cycle == 116 else 0)
        burst = cycle >= 90
        if burst:
            m3.note_out(1, bus, 1 if cycle == 119 else 0)
        m3.tick()
    res3 = m3.phase_result({"name": "p", "packet_bytes": 480, "num_packets": 1})
    if abs((res3["steady_in_bytes_per_cycle"] or 0) - 4.0) > 0.2:
        failures.append(
            f"steady_in_bytes_per_cycle: expected ~4.0 got {res3['steady_in_bytes_per_cycle']!r}"
        )
    if abs((res3["steady_out_bytes_per_cycle"] or 0) - bus) > 1e-9:
        failures.append(
            f"steady_out_bytes_per_cycle: expected {bus} got {res3['steady_out_bytes_per_cycle']!r}"
        )

    for f in failures:
        print("FAIL: " + f)
    print("perf_probe selftest: " + ("PASS" if not failures else f"{len(failures)} FAILURE(S)"))
    return 1 if failures else 0


if __name__ == "__main__":
    import sys

    if "--selftest" in sys.argv:
        sys.exit(_selftest())
    print(__doc__)
    print("run with --selftest to check the metric math")
