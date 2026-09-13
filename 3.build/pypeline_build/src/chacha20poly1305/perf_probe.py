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

Alongside the boundary meters, `HandshakeTap`/`StateTap`/`ArbTap` (+ the
`TapRegistry` that owns them) measure the design's INTERNAL block boundaries.
Those are fed from probe calls placed inside the design's own hardware
functions -- see src/perf_taps.py, which is the pypeline-side half of this and
the only part that imports pypeline. They are snapshotted and zeroed per phase,
landing under each phase's `"taps"` in the results.
"""

import json
import os
import statistics


class _EpochTap:
    """Common sampling discipline for every tap.

    `note(...)` commits a sample immediately. `sample(epoch, ...)` buffers one
    and commits the PREVIOUS one when the epoch changes, which is what the
    in-design probes use, because a hardware function body that declares any
    `Feedback[T]` is wrapped by PipelineC in a `while True:` convergence loop
    (see pypeline.py's "__fb_iters" body rewriting) and therefore re-executes --
    probes included -- until its feedback settles. Only the LAST firing of a
    cycle carries converged values, so keeping the last one is both correct and
    the only choice that does not undercount or double-count.

    The epoch comes from perf_taps.py, which derives it from a `@sim_input`
    (pypeline clears that cache exactly once per simulated cycle), so it is
    independent of MAIN ordering and of how many convergence passes ran.
    """

    def __init__(self, name):
        self.name = name
        self._epoch = None
        self._pending = None
        self.reset()

    def sample(self, epoch, args):
        if self._pending is not None and epoch != self._epoch:
            self._commit(self._pending)
        self._epoch = epoch
        self._pending = args

    def flush(self):
        """Commit the buffered sample -- called before every snapshot, so the
        last cycle of a phase is not silently dropped at the phase boundary."""
        if self._pending is not None:
            self._commit(self._pending)
            self._pending = None
            self._epoch = None

    def _commit(self, args):
        raise NotImplementedError


class HandshakeTap(_EpochTap):
    """Per-cycle valid/ready accounting for ONE handshake -- the unit of
    internal bottleneck analysis.

    Boundary metrics (DirectionMeter below) answer "how fast is the design";
    these answer "which block is holding it up". The four mutually exclusive
    cycle classes are what make that attribution automatic:

        xfer     valid &  ready   a beat moved
        stall    valid & ~ready   CONSUMER backpressured the producer
        starved ~valid &  ready   consumer was ready, PRODUCER had nothing
        idle    ~valid & ~ready   neither side had anything to do

    A block that is the bottleneck shows high `stall` on its own input while
    everything downstream of it shows high `starved`. The two derived numbers
    that matter most:

      `service_period_cycles` = offered/xfer -- cycles per accepted beat *while
        work is being offered*. This is the block's throughput ceiling in
        situ, independent of how often it is fed. Poly1305's data input reads
        ~6.0 here (make_valid_ready_mcp(..., 5) re-arms every ncycles+1 cycles);
        ChaCha20's edges read ~1.0.
      `accept_rate` = xfer/offered -- the same thing as a fraction (1/period).

    Deliberately NOT a trimmed steady-state window like
    DirectionMeter._steady_bytes_per_cycle: accepts in this design are bursty
    (see the README metric table on steady_in_bytes_per_cycle reading 14.3
    B/cycle at 256 B), so an offered/accepted ratio is the honest per-block
    rate and a windowed one is not.
    """

    kind = "handshake"

    def _commit(self, args):
        self.note(*args)

    def reset(self):
        self.cycles = 0
        self.valid_cycles = 0
        self.ready_cycles = 0
        self.xfer_cycles = 0
        self.stall_cycles = 0  # valid & ~ready: consumer backpressures producer
        self.starved_cycles = 0  # ~valid & ready: consumer idle, producer dry
        self.idle_cycles = 0  # ~valid & ~ready
        self.bytes = 0
        self.has_bytes = False

    def note(self, valid, ready, nbytes=None):
        valid = 1 if valid else 0
        ready = 1 if ready else 0
        self.cycles += 1
        self.valid_cycles += valid
        self.ready_cycles += ready
        if valid and ready:
            self.xfer_cycles += 1
            if nbytes is not None:
                self.has_bytes = True
                self.bytes += int(nbytes)
        elif valid:
            self.stall_cycles += 1
        elif ready:
            self.starved_cycles += 1
        else:
            self.idle_cycles += 1

    def snapshot(self):
        window = self.cycles or 1
        offered = self.xfer_cycles + self.stall_cycles
        snap = {
            "kind": self.kind,
            "cycles": self.cycles,
            "valid_cycles": self.valid_cycles,
            "ready_cycles": self.ready_cycles,
            "xfer_cycles": self.xfer_cycles,
            "stall_cycles": self.stall_cycles,
            "starved_cycles": self.starved_cycles,
            "idle_cycles": self.idle_cycles,
            "offered_cycles": offered,
            # The block's in-situ ceiling: how it serves work that IS offered.
            "accept_rate": (self.xfer_cycles / offered) if offered else None,
            "service_period_cycles": (
                (offered / self.xfer_cycles) if self.xfer_cycles else None
            ),
            "beats_per_cycle": self.xfer_cycles / window,
            "duty": self.xfer_cycles / window,
            "stall_frac": self.stall_cycles / window,
            "starve_frac": self.starved_cycles / window,
            "idle_frac": self.idle_cycles / window,
        }
        if self.has_bytes:
            snap["bytes"] = self.bytes
            snap["bytes_per_cycle"] = self.bytes / window
            snap["bytes_per_beat"] = (
                (self.bytes / self.xfer_cycles) if self.xfer_cycles else None
            )
        return snap


class StateTap(_EpochTap):
    """Cycles-per-FSM-state histogram for one state register.

    Turns "the block is slow" into "the block spent 83% of its cycles in
    FINISH_ITER", which names the mechanism rather than the symptom. Pypeline
    `@enum` members declared with auto() are 0-based in declaration order (see
    PipelineC pypeline.py's enum decorator), so a names tuple in declaration
    order indexes directly by value.
    """

    kind = "state"

    def __init__(self, name):
        self.state_names = ()
        super().__init__(name)

    def _commit(self, args):
        self.note(*args)

    def reset(self):
        self.cycles = 0
        self.counts = {}

    def note(self, value, names=None):
        if names and not self.state_names:
            self.state_names = tuple(str(n) for n in names)
        self.cycles += 1
        key = int(value)
        self.counts[key] = self.counts.get(key, 0) + 1

    def name_of(self, value):
        if 0 <= value < len(self.state_names):
            return self.state_names[value]
        return f"state_{value}"

    def snapshot(self):
        window = self.cycles or 1
        states = {}
        for value, count in sorted(self.counts.items()):
            states[self.name_of(value)] = {"cycles": count, "frac": count / window}
        dominant = None
        if states:
            dominant = max(states, key=lambda k: states[k]["cycles"])
        return {
            "kind": self.kind,
            "cycles": self.cycles,
            "states": states,
            "dominant": dominant,
        }


class ArbTap(_EpochTap):
    """Round-robin arbitration accounting for a shared resource.

    Built for chacha20_pipeline_shared, whose `is_encrypt` toggles every cycle
    unconditionally, so a direction can only launch on alternate cycles. Every
    cycle a requester wants the resource is exactly one of:

      xfer         its slot, resource ready -- launched
      blocked      its slot, resource NOT ready -- the pipeline is full. In the
                   shared design this includes head-of-line blocking: the other
                   direction's finished blocks waiting at the shared output
                   (behind that direction's backpressure) stop both directions
      contention   the other side's slot, and the other side wanted it too --
                   the real cost of sharing
      wasted_slot  the other side's slot, and the other side had NOTHING -- pure
                   round-robin waste that a request-aware arbiter would recover

    `note(sel, reqs, granted)`: `sel` is the index the mux points at this cycle,
    `reqs` the per-requester valid bits, `granted` the resource's ready.
    """

    kind = "arb"

    def __init__(self, name, labels=("a", "b")):
        self.labels = tuple(labels)
        super().__init__(name)

    def _commit(self, args):
        self.note(*args)

    def reset(self):
        n = len(self.labels)
        self.cycles = 0
        self.granted_ready_cycles = 0
        self.sel_cycles = [0] * n
        self.req_cycles = [0] * n
        self.xfer_cycles = [0] * n
        self.blocked_cycles = [0] * n
        self.contention_cycles = [0] * n
        self.wasted_slot_cycles = [0] * n

    def note(self, sel, reqs, granted):
        sel = int(sel)
        reqs = [1 if r else 0 for r in reqs]
        granted = 1 if granted else 0
        self.cycles += 1
        self.granted_ready_cycles += granted
        if 0 <= sel < len(self.sel_cycles):
            self.sel_cycles[sel] += 1
        sel_wants = reqs[sel] if 0 <= sel < len(reqs) else 0
        for i, req in enumerate(reqs):
            self.req_cycles[i] += req
            if not req:
                continue
            if i == sel:
                if granted:
                    self.xfer_cycles[i] += 1
                else:
                    self.blocked_cycles[i] += 1
            elif sel_wants:
                self.contention_cycles[i] += 1
            else:
                self.wasted_slot_cycles[i] += 1

    def snapshot(self):
        window = self.cycles or 1
        per = {}
        for i, label in enumerate(self.labels):
            req = self.req_cycles[i] or 1
            per[label] = {
                "req_cycles": self.req_cycles[i],
                "sel_cycles": self.sel_cycles[i],
                "xfer_cycles": self.xfer_cycles[i],
                "blocked_cycles": self.blocked_cycles[i],
                "blocked_frac": self.blocked_cycles[i] / req,
                "contention_cycles": self.contention_cycles[i],
                "wasted_slot_cycles": self.wasted_slot_cycles[i],
                # Of the cycles this side wanted the resource, how often it lost
                # the slot -- split by whether losing it was necessary.
                "arb_loss_frac": (
                    self.contention_cycles[i] + self.wasted_slot_cycles[i]
                )
                / req,
                "contention_frac": self.contention_cycles[i] / req,
                "wasted_slot_frac": self.wasted_slot_cycles[i] / req,
            }
        return {
            "kind": self.kind,
            "cycles": self.cycles,
            "labels": list(self.labels),
            "granted_ready_frac": self.granted_ready_cycles / window,
            "per_requester": per,
        }


class NullTap:
    """A tap that was not enabled this run: every call is a no-op. Accepts any
    tap's note() signature so probe call sites never branch on availability."""

    name = None
    kind = "null"

    def note(self, *args, **kwargs):
        pass

    def sample(self, *args, **kwargs):
        pass

    def flush(self):
        pass

    def reset(self):
        pass

    def snapshot(self):
        return None


class TapRegistry:
    """Name -> tap for the taps enabled this run; unknown/disabled names get a
    NullTap.

    Names are `<label>/<block>.<port>` (e.g. `encrypt/poly1305.data_in`), the
    label coming from the MAIN the probe fired under -- see src/perf_taps.py.
    `enable()` accepts exact names, a `<label>/` or `<block>` prefix, or the
    literal "all", so `--taps poly1305` picks up both directions' MAC taps.
    """

    ALL = "all"

    def __init__(self, enabled=()):
        self.enabled = []
        self._taps = {}
        self._null = NullTap()
        self._lookup = {}
        self.enable(enabled)

    # ---- enablement -------------------------------------------------------
    def enable(self, names):
        for name in names or ():
            name = str(name).strip()
            if name and name not in self.enabled:
                self.enabled.append(name)
        self._lookup.clear()

    def any_enabled(self):
        return bool(self.enabled)

    def _matches(self, full_name):
        if not self.enabled:
            return False
        bare = full_name.split("/", 1)[-1]
        for token in self.enabled:
            if token == self.ALL:
                return True
            if token == full_name or token == bare:
                return True
            if full_name.startswith(token) or bare.startswith(token):
                return True
        return False

    # ---- tap access -------------------------------------------------------
    def tap(self, full_name, factory=HandshakeTap, *args, **kwargs):
        """Return the tap for `full_name`, creating it on first use. Result is
        cached per name, so a probe call site costs one dict hit per cycle."""
        cached = self._lookup.get(full_name)
        if cached is not None:
            return cached
        tap = (
            factory(full_name, *args, **kwargs)
            if self._matches(full_name)
            else self._null
        )
        self._lookup[full_name] = tap
        if tap is not self._null:
            self._taps[full_name] = tap
        return tap

    def active_names(self):
        """Names that actually matched a probe call site and fired this run. An
        enabled name that never appears here did not match anything."""
        return sorted(self._taps)

    def snapshot(self):
        for tap in self._taps.values():
            tap.flush()
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
        self._taps_done = set()  # phase indices whose taps were already taken

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

    def record_taps(self, phase_idx, phase, registry):
        """Snapshot and zero the internal taps for one phase, exactly once.

        Both directions call this on the same cycle (the barrier release that
        ends the phase); the first caller wins, so the counters are never split
        across two half-windows. The tap window is barrier-to-barrier -- a bit
        wider than a direction's own `window_cycles`, since it also covers the
        drain and settle cycles at the end of the phase -- which is what makes
        the per-tap fractions comparable across phases.
        """
        if registry is None or phase_idx in self._taps_done:
            return
        self._taps_done.add(phase_idx)
        snapshot = registry.snapshot()
        registry.reset()
        if not snapshot:
            return
        entry = self.phases.setdefault(
            phase_idx,
            {
                "name": phase["name"],
                "packet_bytes": phase["packet_bytes"],
                "num_packets": phase["num_packets"],
            },
        )
        entry["taps"] = snapshot
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
        taps=None,
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
        # Shared across directions (one registry per run); snapshotted per phase
        # by whichever direction reaches the barrier release first.
        self.taps = taps
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
            self.recorder.record_taps(self.phase_idx, phase, self.taps)
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

    # ---- internal taps -----------------------------------------------------
    # The per-block definitions every future variant gets compared on, checked
    # here so they have regression cover without a build or a simulator.
    reg = TapRegistry(["all"])
    hs = reg.tap("encrypt/poly1305.data_in")
    # The Poly1305 shape: work offered every cycle, accepted 1 cycle in 6
    # (make_valid_ready_mcp(..., 5) re-arms every ncycles+1 cycles).
    for cycle in range(60):
        hs.note(1, 1 if cycle % 6 == 0 else 0, bus if cycle % 6 == 0 else None)
    snap = hs.snapshot()
    tap_checks = [
        ("tap cycles", snap["cycles"], 60),
        ("tap xfer", snap["xfer_cycles"], 10),
        ("tap stall", snap["stall_cycles"], 50),
        ("tap starved", snap["starved_cycles"], 0),
        ("tap idle", snap["idle_cycles"], 0),
        ("tap offered", snap["offered_cycles"], 60),
        # THE per-block throughput number: 6 cycles per accepted 16 B beat.
        ("tap service_period", snap["service_period_cycles"], 6.0),
        ("tap accept_rate", snap["accept_rate"], 1 / 6),
        ("tap bytes_per_beat", snap["bytes_per_beat"], 16.0),
        ("tap bytes_per_cycle", snap["bytes_per_cycle"], 160 / 60),
        ("tap stall_frac", snap["stall_frac"], 50 / 60),
    ]
    # A consumer that is never offered work must read as starved, not as slow.
    starved = reg.tap("encrypt/append.axis_in")
    for _ in range(40):
        starved.note(0, 1)
    ssnap = starved.snapshot()
    tap_checks += [
        ("starved tap starve_frac", ssnap["starve_frac"], 1.0),
        ("starved tap stall_frac", ssnap["stall_frac"], 0.0),
        ("starved tap service_period", ssnap["service_period_cycles"], None),
    ]
    for name, got, want in tap_checks:
        ok = (
            got == want
            if want is None or not isinstance(want, float)
            else abs(got - want) < 1e-9
        )
        if not ok:
            failures.append(f"{name}: expected {want!r} got {got!r}")

    # Epoch buffering: a body carrying Feedback[T] re-executes until it
    # converges, so a probe there fires several times per cycle and only the
    # LAST firing is converged. Three firings per cycle must count as one cycle,
    # and must record the last sample -- not the first, and not all three.
    fb = reg.tap("encrypt/chacha20.axis_in")
    for cycle in range(10):
        fb.sample(cycle, (1, 0, None))  # mid-convergence: not yet ready
        fb.sample(cycle, (1, 0, None))
        fb.sample(cycle, (1, 1, bus))  # converged: accepted
    fb.flush()
    fsnap = fb.snapshot()
    if fsnap["cycles"] != 10:
        failures.append(f"epoch dedupe: expected 10 cycles got {fsnap['cycles']}")
    if fsnap["xfer_cycles"] != 10 or fsnap["stall_cycles"] != 0:
        failures.append(
            "epoch dedupe kept the wrong sample: "
            f"xfer={fsnap['xfer_cycles']} stall={fsnap['stall_cycles']} "
            "(the converged, last firing of each cycle must win)"
        )

    # State histogram: 0-based enum values index the declaration-order names.
    st = reg.tap("encrypt/poly1305.fsm", StateTap)
    names = ("IDLE", "START_ITER", "FINISH_ITER", "A_PLUS_S", "OUTPUT_AUTH_TAG")
    for cycle in range(60):
        st.note(1 if cycle % 6 == 0 else 2, names)
    stsnap = st.snapshot()
    if stsnap["dominant"] != "FINISH_ITER":
        failures.append(f"state dominant: expected FINISH_ITER got {stsnap['dominant']}")
    if abs(stsnap["states"]["FINISH_ITER"]["frac"] - 50 / 60) > 1e-9:
        failures.append("state frac wrong for FINISH_ITER")

    # Arbitration: a round robin that flips unconditionally throws away every
    # other slot when only one side has work.
    arb = reg.tap("shared/pipe.arb", ArbTap, ("encrypt", "decrypt"))
    for cycle in range(40):
        arb.note(0 if cycle % 2 == 0 else 1, (1, 0), 1)
    asnap = arb.snapshot()["per_requester"]["encrypt"]
    if asnap["xfer_cycles"] != 20 or asnap["wasted_slot_cycles"] != 20:
        failures.append(f"arb split wrong: {asnap}")
    if abs(asnap["wasted_slot_frac"] - 0.5) > 1e-9 or asnap["contention_frac"] != 0.0:
        failures.append(f"arb fracs wrong: {asnap}")
    full = reg.tap("shared/pipe.arb_full", ArbTap, ("encrypt", "decrypt"))
    for cycle in range(40):
        # both always want it; the resource is ready only on even cycles
        full.note(0 if cycle % 2 == 0 else 1, (1, 1), 1 if cycle % 4 < 2 else 0)
    fsnap_arb = full.snapshot()["per_requester"]["encrypt"]
    parts = (fsnap_arb["xfer_cycles"], fsnap_arb["blocked_cycles"],
             fsnap_arb["contention_cycles"], fsnap_arb["wasted_slot_cycles"])
    if parts != (10, 10, 20, 0) or sum(parts) != fsnap_arb["req_cycles"]:
        failures.append(f"arb categories must partition wanted cycles: {fsnap_arb}")

    # Enablement: "all", exact names and prefixes; everything else is a NullTap.
    narrow = TapRegistry(["poly1305"])
    if narrow.tap("encrypt/poly1305.data_in").snapshot() is None:
        failures.append("prefix match on the bare name should enable a tap")
    if narrow.tap("encrypt/chacha20.axis_in").snapshot() is not None:
        failures.append("an unmatched tap must be a NullTap")
    bydir = TapRegistry(["decrypt/"])
    if bydir.tap("decrypt/poly1305.data_in").snapshot() is None:
        failures.append("direction prefix should enable a tap")
    off = TapRegistry([])
    if off.any_enabled() or off.tap("encrypt/poly1305.data_in").snapshot() is not None:
        failures.append("an empty registry must enable nothing")

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
