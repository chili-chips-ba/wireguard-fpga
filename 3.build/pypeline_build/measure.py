#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""QoR measurement orchestrator: one command that produces a complete, diffable
(fmax, area, throughput, latency) record for a design variant.

What it does:
  1. runs `./build.py --shared --perf` -- ONE pypelinec command line that
     autopipelines for the design's 80 MHz goal through Vivado and then runs the
     native simulation of exactly what it built (autopipelined latencies
     modeled), with the perf testbench's phase plan passed in via WG_PERF_* env
     so the elaborated hardware never changes between runs;
  2. reads fmax + pipeline depth from pypelinec's OWN numbers -- the per-MAIN
     "final" records in <out_dir>/top/sweep_history.json (schema 2), with the
     build's stdout outcome lines as cross-check -- timing parsing is not
     reimplemented here;
  3. reads area from that same build's Vivado log via vivado_area.py
     (this repo's own parser, not pypelinec's diagnostic-only one);
  4. merges everything into measurements/<label>/results.json (machine
     readable), summary.csv (one row per phase x direction), and a markdown
     table ready to paste into README.md;
  5. rolls the run's INTERNAL taps (src/perf_taps.py probes inside the design's
     own hardware functions) up into per-block throughput/stall numbers and an
     automated bottleneck verdict per phase -- see bottleneck.py.

Cycle-domain measurements and MHz live in separate steps on purpose: the
testbench records cycles/beats/bytes only, so throughput can be re-expressed at
a different fmax without re-simulating.

Typical use:
  ./measure.py --label shared-80mhz          # fresh autopipelining + sim (hours)
  ./measure.py --label X --reuse-syn         # sim only, reuse cached synthesis
  ./measure.py --label smoke --comb          # fast rig check, no Vivado at all
  ./measure.py --label X --parse-only        # re-merge an existing run's outputs
  ./measure.py --label X --sizes 64,1420 --packets 4
"""

import argparse
import csv
import datetime
import json
import os
import re
import socket
import subprocess
import sys
import time

import bottleneck
import vivado_area

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_PIPELINEC_REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", "PipelineC"))
BUS_BYTES = 16
DEFAULT_TARGET_MHZ = 80.0  # @MAIN(80.0) on the dataflow MAINs

# pypelinec stdout lines worth keeping as a cross-check on sweep_history.json.
RE_FMAX = re.compile(r"(?:(PASS|FAIL)\s+)?Clock (\S+) FMAX: ([\d.]+) MHz \(([\d.]+) ns\)")
RE_SWEEP_ITER = re.compile(
    r"\[sweep\] iter=(\d+) main=(\S+) goal=([\d.]+)MHz got=([\d.]+)MHz"
)
RE_TIMING_NOT_MET = re.compile(r"ERROR: TIMING NOT MET: .*")
# The FINAL per-MAIN outcome lines. A schema-2 sweep_history.json's "final"
# records are authoritative and these are the cross-check; for a schema-1 file
# (an iteration log that could stop before the iteration that met timing, its
# last entry a mid-sweep number) these lines are the only final numbers.
RE_MET = re.compile(
    r"\[sweep\]\s+(\S+): met timing, (\d+) slice\(s\) built \((\d+) pipeline stages\), "
    r"cuts=(\d+), locked=(\d+) inst\(s\), iterations=(\d+)"
)
RE_STANDALONE = re.compile(
    r"\[sweep\]\s+(\S+) synthesized as written \(standalone check\): "
    r"([\d.]+) MHz vs ([\d.]+) MHz goal - (PASS|FAIL)"
)
RE_CONFIRM = re.compile(
    r"^(PASS|FAIL)\s+(\S+): ([\d.]+) MHz vs ([\d.]+) MHz goal \(confirmation run\)"
)
RE_NOT_MET_MAIN = re.compile(
    r"ERROR: TIMING NOT MET: (\S+) achieved ([\d.]+) MHz vs ([\d.]+) MHz goal"
)
RE_NOT_AUTOPIPELINED = re.compile(r"\[sweep\]\s+(\S+): not autopipelined")
RE_DEPTH = re.compile(r"\[sweep\]\s+(\S+): (\d+) slice\(s\) total \((\d+) pipeline stages")
RE_CLOCK_LINE = re.compile(r"^Clock:\s+\d+\s*$")
RE_SIM_SPEED = re.compile(r"(\d+) cycles in ([\d.]+)s")


def git_describe(repo):
    def run(*args):
        try:
            return subprocess.run(
                ["git", "-C", repo] + list(args),
                capture_output=True, text=True, check=True,
            ).stdout.strip()
        except (subprocess.CalledProcessError, FileNotFoundError):
            return None
    sha = run("rev-parse", "HEAD")
    if sha is None:
        return None
    dirty = run("status", "--porcelain")
    return sha + ("-dirty" if dirty else "")


def out_dir_for(comb):
    return os.path.join(
        HERE, f"generated-files-perf-{'comb' if comb else 'pipe'}-shared-native"
    )


def run_build(args, json_path, log_path):
    """Run build.py --perf, teeing its (very chatty) stdout to log_path.

    The per-cycle 'Clock: N' lines are dropped from the saved log -- they are
    the bulk of it and carry no information the JSON doesn't -- but they are
    counted, which is how cycles_run is recovered.
    """
    env = dict(os.environ)
    env["WG_PERF_JSON"] = json_path
    if not env.get("PYPELINEC"):
        candidate = os.path.join(DEFAULT_PIPELINEC_REPO, "src", "pypelinec")
        if os.path.exists(candidate):
            env["PYPELINEC"] = candidate
            # Mirror it into our own environment so provenance below records the
            # same PipelineC checkout the build actually used.
            os.environ["PYPELINEC"] = candidate
            print(f"--> $PYPELINEC not set, using {candidate}")
    if args.sizes:
        env["WG_PERF_SIZES"] = args.sizes
    if args.packets:
        env["WG_PERF_PACKETS"] = str(args.packets)
    if args.peak_bytes is not None:
        env["WG_PERF_PEAK_BYTES"] = str(args.peak_bytes)
    if args.dirs:
        env["WG_PERF_DIRS"] = args.dirs
    if args.taps:
        env["WG_PERF_TAPS"] = args.taps
    if args.seed is not None:
        env["WG_PERF_SEED"] = str(args.seed)

    cmd = [os.path.join(HERE, "build.py"), "--shared", "--perf"]
    if args.comb:
        cmd.append("--comb")
    if args.reuse_syn:
        cmd.append("--continue")

    print(f"--> {' '.join(cmd)}")
    print(f"--> log: {log_path}")
    # Pin the PipelineC revision NOW, not after the run: a sweep takes hours and
    # that checkout may be under active development in the meantime, so a SHA
    # read at merge time can name a revision this build never used.
    pipelinec_git = git_describe(
        os.path.dirname(os.path.dirname(env.get("PYPELINEC", DEFAULT_PIPELINEC_REPO + "/src/x")))
    )
    clock_lines = 0
    started = time.time()
    with open(log_path, "w") as log:
        proc = subprocess.Popen(
            cmd, cwd=HERE, env=env, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, text=True, bufsize=1,
        )
        for line in proc.stdout:
            if RE_CLOCK_LINE.match(line):
                clock_lines += 1
                continue
            log.write(line)
            log.flush()
        rc = proc.wait()
    elapsed = time.time() - started
    return {
        "cmd": " ".join(cmd),
        "returncode": rc,
        "wall_s": elapsed,
        "clock_lines": clock_lines,
        "pipelinec_git": pipelinec_git,
    }


def parse_stdout(log_path):
    """Cross-check numbers + provenance from pypelinec's own printed output."""
    info = {
        "fmax_lines": [],
        "sweep_iters": [],
        "timing_not_met": [],
        "pipeline_depth_summary": [],
        "final": {},  # main -> final outcome (see RE_MET above)
        "sim_cycles": None,
        "sim_wall_s": None,
    }
    if not os.path.exists(log_path):
        return info
    in_depth_summary = False
    with open(log_path, errors="replace") as f:
        for line in f:
            line = line.rstrip("\n")
            m = RE_FMAX.search(line)
            if m:
                info["fmax_lines"].append(
                    {
                        "passfail": m.group(1),
                        "clock": m.group(2),
                        "mhz": float(m.group(3)),
                        "ns": float(m.group(4)),
                    }
                )
            m = RE_SWEEP_ITER.search(line)
            if m:
                info["sweep_iters"].append(line.strip())
            if RE_TIMING_NOT_MET.search(line):
                info["timing_not_met"].append(line.strip())

            def final(name):
                return info["final"].setdefault(name, {})

            m = RE_MET.search(line)
            if m:
                # Met its goal, but pypelinec prints no achieved MHz in this
                # case ("no failing timing path reported ... assuming met"), so
                # achieved_mhz stays unknown and the goal is a lower bound.
                entry = final(m.group(1))
                entry.update(
                    met=True, slices=int(m.group(2)),
                    pipeline_stages=int(m.group(3)), final_cuts=int(m.group(4)),
                    locked_instances=int(m.group(5)), iterations=int(m.group(6)),
                    outcome="met timing (achieved MHz not reported)",
                )
            m = RE_STANDALONE.search(line)
            if m:
                entry = final(m.group(1))
                entry.update(
                    standalone_mhz=float(m.group(2)), goal_mhz=float(m.group(3)),
                    met=m.group(4) == "PASS", autopipelined=False,
                    outcome="synthesized as written (standalone check)",
                )
            m = RE_CONFIRM.match(line.strip())
            if m:
                entry = final(m.group(2))
                entry.update(
                    achieved_mhz=float(m.group(3)), goal_mhz=float(m.group(4)),
                    met=m.group(1) == "PASS", outcome="confirmation run",
                )
            m = RE_NOT_MET_MAIN.search(line)
            if m:
                entry = final(m.group(1))
                entry.update(
                    achieved_mhz=float(m.group(2)), goal_mhz=float(m.group(3)),
                    met=False, outcome="TIMING NOT MET",
                )
            m = RE_NOT_AUTOPIPELINED.search(line)
            if m:
                final(m.group(1)).setdefault("autopipelined", False)
            m = RE_DEPTH.search(line)
            if m:
                entry = final(m.group(1))
                entry.setdefault("slices", int(m.group(2)))
                entry.setdefault("pipeline_stages", int(m.group(3)))
                entry["autopipelined"] = True
            if "[sweep] Pipeline depth summary:" in line:
                in_depth_summary = True
                info["pipeline_depth_summary"].append(line.strip())
                continue
            if in_depth_summary:
                if line.startswith("[sweep]"):
                    info["pipeline_depth_summary"].append(line.strip())
                else:
                    in_depth_summary = False
            m = RE_SIM_SPEED.search(line)
            if m:
                info["sim_cycles"] = int(m.group(1))
                info["sim_wall_s"] = float(m.group(2))
    return info


# Schema-2 sweep_history.json "final" field -> per_main field (the names the
# stdout parser above already uses, so both sources merge the same way)
HISTORY_FINAL_FIELDS = (
    ("met", "met"),
    ("achieved_mhz", "achieved_mhz"),
    ("mhz_is_lower_bound", "mhz_is_lower_bound"),
    ("met_basis", "met_basis"),
    ("source", "outcome"),
    ("standalone_mhz", "standalone_mhz"),
    ("autopipelined", "autopipelined"),
    ("slices_built", "slices"),
    ("pipeline_stages", "pipeline_stages"),
    ("cuts", "final_cuts"),
    ("locked_instances", "locked_instances"),
    ("failure_reason", "failure_reason"),
)
# Verdict numbers compared against stdout. Depth is not: the sweep's "met
# timing, N slice(s)" line predates any pin-and-confirm re-realization, which
# the final record (read off the final table) already includes.
CROSS_CHECK_FIELDS = ("met", "achieved_mhz", "standalone_mhz")


def final_from_history(final):
    """Map one schema-2 "final" record onto per_main fields. The mapping keeps
    a met-but-unmeasured MAIN's achieved_mhz None -- its goal is a lower bound."""
    mapped = {}
    for src, dst in HISTORY_FINAL_FIELDS:
        if src in final and (final[src] is not None or src == "achieved_mhz"):
            mapped[dst] = final[src]
    return mapped


def cross_check_final(from_history, from_stdout):
    """{field: {"sweep_history": a, "stdout": b}} where both sources state a
    value and disagree (MHz compared to the 2 decimals stdout prints)."""
    mismatches = {}
    for key in CROSS_CHECK_FIELDS:
        a, b = from_history.get(key), from_stdout.get(key)
        if a is None or b is None:
            continue
        if isinstance(a, bool) or isinstance(b, bool):
            same = a == b
        else:
            same = abs(float(a) - float(b)) <= 0.01
        if not same:
            mismatches[key] = {"sweep_history": a, "stdout": b}
    return mismatches


def parse_fmax(out_dir, stdout_info):
    """fmax + per-MAIN pipelining from pypelinec's own numbers.

    A schema-2 `sweep_history.json` from a complete build carries one "final"
    record per MAIN describing the design as built (after any confirmation run,
    restored snapshot or as-written check); those records are authoritative and
    the build's stdout outcome lines are only a cross-check
    (`source.cross_check_mismatches`). A schema-1 file is only the sweep's
    iteration log -- it could stop before the iteration that met timing -- so
    for those the stdout outcome lines stay authoritative and the history is
    kept as diagnostics (`last_sweep_iter.mid_sweep_mhz`).

    A MAIN that met its goal with no MHz ever measured for it ("no failing
    timing path reported ... assuming met") has an unknown exact fmax; its goal
    is a lower bound -- `design_mhz_is_lower_bound` says when that is the case.
    """
    sweep_path = os.path.join(out_dir, "top", "sweep_history.json")
    result = {
        "design_mhz": None,
        "design_mhz_is_lower_bound": False,
        "design_mhz_basis": None,
        "min_reported_mhz": None,
        "limiting_main": None,
        "target_mhz": None,
        "timing_met": None,
        "per_main": {},
        "source": {
            "sweep_history": None,
            "sweep_history_schema": None,
            # "sweep_history.json final records" or "stdout outcome lines"
            "final_basis": None,
            "cross_check_mismatches": {},
            "stdout_fmax_lines": stdout_info["fmax_lines"],
            "final_outcomes": stdout_info["final"],
        },
        "pipeline_depth_summary": stdout_info["pipeline_depth_summary"],
        "timing_not_met": stdout_info["timing_not_met"],
    }
    history_finals = {}  # main -> schema-2 "final" record (complete builds only)
    if os.path.exists(sweep_path):
        result["source"]["sweep_history"] = sweep_path
        with open(sweep_path) as f:
            history = json.load(f)
        if "schema_version" in history:
            result["source"]["sweep_history_schema"] = history["schema_version"]
            for main, record in history.get("mains", {}).items():
                entry = result["per_main"].setdefault(main, {})
                entry["sweep_iters"] = len(record.get("iterations", []))
                entry.setdefault("goal_mhz", record.get("goal_mhz"))
                # A provisional file (build died after the sweep) has no
                # verdict for the design as built
                if history.get("build_complete") and record.get("final"):
                    history_finals[main] = record["final"]
        else:
            result["source"]["sweep_history_schema"] = 1
            for main, iters in history.items():
                entry = result["per_main"].setdefault(main, {})
                entry["sweep_iters"] = len(iters)
                if not iters:
                    continue
                last = iters[-1]
                # Explicitly NOT the final fmax -- see this function's docstring.
                entry["last_sweep_iter"] = {
                    "iter": last.get("iter"),
                    "mid_sweep_mhz": last.get("achieved_mhz"),
                    "cuts": last.get("cuts"),
                    "pipeline_stages": last.get("pipeline_stages"),
                    "bottleneck": last.get("bottleneck"),
                    "action": last.get("action"),
                }
                entry.setdefault("goal_mhz", last.get("goal_mhz"))
                entry.setdefault("bottleneck", last.get("bottleneck"))
    if stdout_info["fmax_lines"] and not stdout_info["final"]:
        # --comb builds run no sweep: the printed per-clock FMAX lines are all
        # there is.
        for entry in stdout_info["fmax_lines"]:
            result["per_main"].setdefault(entry["clock"], {}).update(
                achieved_mhz=entry["mhz"],
                met=entry["passfail"] != "FAIL",
                outcome="comb FMAX line",
            )

    # Merge the authoritative final outcomes over the diagnostics.
    if history_finals:
        result["source"]["final_basis"] = "sweep_history.json final records"
        for main, final in history_finals.items():
            mapped = final_from_history(final)
            mismatches = cross_check_final(
                mapped, stdout_info["final"].get(main, {})
            )
            if mismatches:
                result["source"]["cross_check_mismatches"][main] = mismatches
            result["per_main"].setdefault(main, {}).update(mapped)
    elif stdout_info["final"]:
        result["source"]["final_basis"] = "stdout outcome lines"
        for main, final in stdout_info["final"].items():
            result["per_main"].setdefault(main, {}).update(final)

    with_goal = {
        name: info
        for name, info in result["per_main"].items()
        if info.get("goal_mhz")
    }
    goals = [info["goal_mhz"] for info in with_goal.values()]
    result["target_mhz"] = max(goals) if goals else None

    if with_goal:
        result["timing_met"] = all(
            info.get("met") for info in with_goal.values()
        ) and not stdout_info["timing_not_met"]

    # Lowest MHz anyone actually printed (a standalone/confirmation/comb number).
    reported = [
        v
        for info in result["per_main"].values()
        for v in (info.get("achieved_mhz"), info.get("standalone_mhz"))
        if v
    ]
    result["min_reported_mhz"] = min(reported) if reported else None

    unknown = sorted(
        name
        for name, info in with_goal.items()
        if info.get("met") and not (info.get("achieved_mhz") or info.get("standalone_mhz"))
    )
    if result["timing_met"] and with_goal:
        if unknown:
            # Every goal met, but the limiting MAIN's exact fmax was never
            # printed: the goal is the honest, conservative number to quote.
            result["design_mhz"] = result["target_mhz"]
            result["design_mhz_is_lower_bound"] = True
            result["limiting_main"] = unknown[0]
            result["design_mhz_basis"] = (
                f"all MAINs met the {result['target_mhz']} MHz goal; "
                f"{', '.join(unknown)} met timing with no failing path reported, so "
                f"its exact achieved MHz is not printed -- the goal is a lower bound "
                f"(lowest reported elsewhere: {result['min_reported_mhz']} MHz)"
            )
        else:
            per_main_mhz = {
                name: info.get("achieved_mhz") or info.get("standalone_mhz")
                for name, info in with_goal.items()
            }
            limiting = min(per_main_mhz, key=per_main_mhz.get)
            result["design_mhz"] = per_main_mhz[limiting]
            result["limiting_main"] = limiting
            result["design_mhz_basis"] = "slowest MAIN's reported achieved MHz"
    else:
        failing = {
            name: info.get("achieved_mhz")
            for name, info in with_goal.items()
            if info.get("achieved_mhz") and not info.get("met")
        }
        candidates = failing or {
            name: info.get("achieved_mhz")
            for name, info in result["per_main"].items()
            if info.get("achieved_mhz")
        }
        if candidates:
            limiting = min(candidates, key=candidates.get)
            result["design_mhz"] = candidates[limiting]
            result["limiting_main"] = limiting
            result["design_mhz_basis"] = (
                "slowest MAIN that failed its goal"
                if failing
                else "slowest reported MHz (no goal met/failed verdict available)"
            )
    return result


def parse_area(out_dir, per_module=True):
    try:
        parsed = vivado_area.parse_out_dir(out_dir, per_module=per_module)
    except Exception as exc:  # a missing/incomplete build must not lose the sim data
        return {"available": False, "reason": f"{type(exc).__name__}: {exc}"}
    if not parsed["top"]:
        return {
            "available": False,
            "reason": (
                "no top-level vivado*.log in this build (a --comb build runs no "
                "synthesis, so it reports no area)"
            ),
            "per_module": parsed["per_module"],
        }
    area = dict(parsed["top"])
    area["available"] = True
    area["scope"] = "perf_tb_top"
    # The perf testbench drives key/nonce/aad as constants, so Vivado folds some
    # ChaCha20 logic away: this number is consistent ACROSS VARIANTS but is not
    # an absolute DUT area. --area-from-dir on a hardware (./build.py --shared)
    # build gives the folding-free cross-check; per-module OOC areas below are
    # folding-free too.
    area["constant_key_folding"] = True
    area["per_module"] = parsed["per_module"]
    return area


def derive_throughput(perf_raw, fmax_mhz, target_mhz):
    """Add MHz-dependent columns to the testbench's cycle-domain numbers."""
    phases = []
    for phase in perf_raw.get("phases", []):
        entry = {
            k: phase[k]
            for k in ("name", "packet_bytes", "num_packets")
            if k in phase
        }
        if "taps" in phase:
            entry["taps"] = phase["taps"]
        if phase.get("timed_out"):
            entry["timed_out"] = True
        for direction in ("encrypt", "decrypt"):
            res = phase.get(direction)
            if not res:
                continue
            res = dict(res)
            bpc = res.get("bytes_per_cycle")
            steady_in = res.get("steady_in_bytes_per_cycle")
            # Primary throughput figure: the sustained (inter-packet period) rate
            # averaged over the phase's same-size packets, which is what a long
            # stream of that size would achieve. Falls back to the whole-window
            # rate for a phase with a single packet (no period to measure).
            rate = res.get("sustained_bytes_per_cycle") or bpc
            res["throughput_bytes_per_cycle"] = rate
            res["throughput_basis"] = (
                "sustained (inter-packet period)"
                if res.get("sustained_bytes_per_cycle")
                else "whole window (single packet)"
            )
            res["line_rate_frac"] = (rate / BUS_BYTES) if rate else None
            if rate and fmax_mhz:
                res["gbps_at_fmax"] = rate * 8 * fmax_mhz / 1000.0
            if rate and target_mhz:
                res["gbps_at_target"] = rate * 8 * target_mhz / 1000.0
            if bpc and fmax_mhz:
                res["window_gbps_at_fmax"] = bpc * 8 * fmax_mhz / 1000.0
            # Only the INPUT-side steady rate is a throughput figure; the
            # output-side one is a drain rate (see perf_probe's docstring).
            if steady_in and fmax_mhz:
                res["steady_in_gbps_at_fmax"] = steady_in * 8 * fmax_mhz / 1000.0
            entry[direction] = res
        phases.append(entry)
    return phases


def summarize(phases):
    summary = {}
    for phase in phases:
        for direction in ("encrypt", "decrypt"):
            res = phase.get(direction)
            if not res:
                continue
            key = f"{phase['name']}_{direction}"
            summary[key] = {
                "bytes_per_cycle": res.get("bytes_per_cycle"),
                "sustained_bytes_per_cycle": res.get("sustained_bytes_per_cycle"),
                "line_rate_frac": res.get("line_rate_frac"),
                "gbps_at_fmax": res.get("gbps_at_fmax"),
                "steady_in_bytes_per_cycle": res.get("steady_in_bytes_per_cycle"),
                "total_latency_med": res.get("latency_cycles", {}).get("total_med"),
            }
    # Headline peak is the window-based goodput rate: conservative, end-to-end,
    # and immune to the output-burst artifact that makes a decrypt phase's
    # output-side steady rate read as full line rate.
    for direction in ("encrypt", "decrypt"):
        rates = [
            phase[direction].get("bytes_per_cycle") or 0
            for phase in phases
            if phase.get(direction)
        ]
        sustained = [
            phase[direction].get("throughput_bytes_per_cycle") or 0
            for phase in phases
            if phase.get(direction)
        ]
        summary[f"peak_bytes_per_cycle_{direction}"] = max(rates) if rates else None
        summary[f"peak_sustained_bytes_per_cycle_{direction}"] = (
            max(sustained) if sustained else None
        )
    return summary


CSV_COLUMNS = (
    "label", "phase", "packet_bytes", "num_packets", "direction",
    "window_cycles", "goodput_bytes", "in_beats", "out_beats",
    "bytes_per_cycle", "sustained_bytes_per_cycle", "packet_period_cycles",
    "steady_in_bytes_per_cycle", "steady_out_bytes_per_cycle", "line_rate_frac",
    "gbps_at_fmax", "gbps_at_target", "in_duty", "out_duty", "in_stall_frac",
    "cold_head_latency", "head_med", "total_med", "total_max", "timed_out",
)


def write_csv(path, label, phases):
    with open(path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(CSV_COLUMNS)
        for phase in phases:
            for direction in ("encrypt", "decrypt"):
                res = phase.get(direction)
                if not res:
                    continue
                lat = res.get("latency_cycles", {})
                writer.writerow([
                    label, phase["name"], phase["packet_bytes"], phase["num_packets"],
                    direction, res.get("window_cycles"), res.get("goodput_bytes"),
                    res.get("in_beats"), res.get("out_beats"),
                    res.get("bytes_per_cycle"),
                    res.get("sustained_bytes_per_cycle"),
                    res.get("packet_period_cycles"),
                    res.get("steady_in_bytes_per_cycle"),
                    res.get("steady_out_bytes_per_cycle"),
                    res.get("line_rate_frac"), res.get("gbps_at_fmax"),
                    res.get("gbps_at_target"), res.get("in_duty"), res.get("out_duty"),
                    res.get("in_stall_frac"), lat.get("cold_head"), lat.get("head_med"),
                    lat.get("total_med"), lat.get("total_max"),
                    res.get("timed_out"),
                ])


def write_tap_csvs(meas_dir, label, phases):
    """Per-tap and per-block rows, one file each -- the internal-stall curve, in
    the same flat shape as summary.csv so the two diff/plot the same way."""
    written = []
    tap_rows = list(bottleneck.tap_rows(label, phases))
    if tap_rows:
        path = os.path.join(meas_dir, "taps.csv")
        with open(path, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(bottleneck.TAP_CSV_COLUMNS)
            writer.writerows(tap_rows)
        written.append(path)
    block_rows = list(bottleneck.block_rows(label, phases))
    if block_rows:
        path = os.path.join(meas_dir, "blocks.csv")
        with open(path, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(bottleneck.BLOCK_CSV_COLUMNS)
            writer.writerows(block_rows)
        written.append(path)
    return written


def _fmt(value, spec=".3f"):
    return format(value, spec) if isinstance(value, (int, float)) else "-"


def markdown_table(results):
    lines = []
    fmax = results["fmax"].get("design_mhz")
    area = results["area"]
    lines.append(
        f"Design `{results['config']['design']}` | target "
        f"{_fmt(results['fmax'].get('target_mhz'), '.1f')} MHz | measured fmax "
        f"**{_fmt(fmax, '.2f')} MHz** | limiting MAIN `{results['fmax'].get('limiting_main')}`"
    )
    if area.get("available"):
        lines.append(
            f"Area ({area['scope']}): **{area.get('lut_total')} LUT** "
            f"({area.get('lut_logic')} logic + {area.get('lut_memory')} mem), "
            f"**{area.get('ff_total')} FF**, **{area.get('dsp48')} DSP48**, "
            f"**{area.get('bram_tiles')} BRAM tiles**, {area.get('carry4')} CARRY4"
        )
    lines.append("")
    target = results["fmax"].get("target_mhz")
    # When fmax is quoted as the met goal, @fmax and @target are the same number:
    # printing both columns would just be noise.
    same_mhz = bool(fmax and target and abs(fmax - target) < 1e-9)
    mhz_cols = (
        f"Gb/s @{_fmt(fmax, '.0f')} MHz |"
        if same_mhz
        else "Gb/s @fmax | Gb/s @target |"
    )
    lines.append(
        "| phase | bytes | pkts | dir | sustained B/cyc | pkt period (clk) | "
        "% line rate | " + mhz_cols + " in stall | cold head (clk) | total lat med (clk) |"
    )
    lines.append("|---|---|---|---|---|---|---|---|---|---|---|" + ("" if same_mhz else "---|"))
    for phase in results["phases"]:
        for direction in ("encrypt", "decrypt"):
            res = phase.get(direction)
            if not res:
                continue
            lat = res.get("latency_cycles", {})
            frac = res.get("line_rate_frac")
            gbps = f"| {_fmt(res.get('gbps_at_fmax'))} "
            if not same_mhz:
                gbps += f"| {_fmt(res.get('gbps_at_target'))} "
            lines.append(
                f"| {phase['name']} | {phase['packet_bytes']} | {phase['num_packets']} "
                f"| {direction} | {_fmt(res.get('throughput_bytes_per_cycle'))} "
                f"| {_fmt(res.get('packet_period_cycles'), '.1f')} "
                f"| {_fmt(frac * 100 if frac else None, '.1f')}% "
                + gbps
                + f"| {_fmt(res.get('in_stall_frac'))} | {lat.get('cold_head')} "
                f"| {lat.get('total_med')} |"
            )
    return "\n".join(lines)


README_BEGIN = "<!-- MEASURED-RESULTS:BEGIN -->"
README_END = "<!-- MEASURED-RESULTS:END -->"
BLOCKS_BEGIN = "<!-- BLOCK-RESULTS:BEGIN -->"
BLOCKS_END = "<!-- BLOCK-RESULTS:END -->"


def _stamp(results):
    provenance = results["provenance"]
    return (
        f"_Measured by `./measure.py --label {results['label']}`"
        f" on {results['generated_utc']}"
        f" — wireguard-fpga `{(provenance.get('wireguard_fpga_git') or '?')[:12]}`,"
        f" PipelineC `{(provenance.get('pipelinec_git') or '?')[:12]}`,"
        f" Vivado {provenance.get('vivado_version')},"
        f" {provenance.get('cycles_run')} cycles."
        f" Regenerate with `./measure.py --label {results['label']} --parse-only --update-readme`._"
    )


def _splice(text, begin, end, body):
    """Replace whatever sits between two markers. None if they are not there."""
    if begin not in text or end not in text:
        return None
    head, rest = text.split(begin, 1)
    _, tail = rest.split(end, 1)
    return head + f"{begin}\n\n{body}\n\n{end}" + tail


def update_readme(table, results, block_summary=None):
    """Splice the generated results into README.md so their numbers are never
    hand-copied (and so re-measuring a variant updates the docs in one step).

    The README carries exactly one table -- the boundary QoR table -- plus a text
    summary of the block analysis; the full block tables live in the run's
    measurements/<label>/blocks.md."""
    path = os.path.join(HERE, "README.md")
    with open(path) as f:
        text = f.read()
    stamp = _stamp(results)
    spliced = _splice(text, README_BEGIN, README_END, f"{stamp}\n\n{table}")
    if spliced is None:
        print(
            f"!! {path} has no {README_BEGIN} / {README_END} markers; not updating",
            file=sys.stderr,
        )
    else:
        text = spliced
        print("--> README.md results table updated")
    if block_summary:
        # No second stamp: both regions come from the same run, and the README
        # holds only the current record -- one provenance line is enough.
        spliced = _splice(text, BLOCKS_BEGIN, BLOCKS_END, block_summary)
        if spliced is None:
            print(
                f"!! {path} has no {BLOCKS_BEGIN} / {BLOCKS_END} markers; "
                f"block summary not updated",
                file=sys.stderr,
            )
        else:
            text = spliced
            print("--> README.md block summary updated")
    with open(path, "w") as f:
        f.write(text)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--label", default=None, help="measurement name (dir under measurements/)")
    ap.add_argument("--comb", action="store_true", help="combinational build: fast rig check, no Vivado, no area/fmax")
    ap.add_argument("--reuse-syn", action="store_true", help="keep the out_dir so pypelinec re-reads its cached Vivado logs (sim-only re-measure)")
    ap.add_argument("--parse-only", action="store_true", help="run nothing; re-merge an existing run's perf JSON + build log")
    ap.add_argument("--area-from-dir", default=None, help="also parse DUT-only area from another build's out_dir (e.g. generated-files-verilog-shared)")
    ap.add_argument("--no-per-module-area", action="store_true", help="skip per-module out-of-context area parsing")
    ap.add_argument("--sizes", default=None, help="comma-separated packet sizes (default: see perf_tb_common.py)")
    ap.add_argument("--packets", type=int, default=None, help="back-to-back packets per size")
    ap.add_argument("--peak-bytes", type=int, default=None, help="single long packet size for the peak phase (0 disables)")
    ap.add_argument("--dirs", default=None, choices=("both", "enc", "dec"), help="which directions to stream")
    ap.add_argument("--taps", default="all", help="internal taps to enable: 'all' (default), a block or direction prefix ('poly1305', 'encrypt'), or exact names; pass --taps '' to measure boundaries only (see src/perf_taps.py)")
    ap.add_argument("--seed", type=int, default=None, help="packet payload RNG seed")
    ap.add_argument("--update-readme", action="store_true", help="splice the results table into README.md between its MEASURED-RESULTS markers")
    args = ap.parse_args()

    label = args.label or ("comb-smoke" if args.comb else "shared-80mhz")
    meas_dir = os.path.join(HERE, "measurements", label)
    os.makedirs(meas_dir, exist_ok=True)
    json_path = os.path.join(meas_dir, "perf_raw.json")
    log_path = os.path.join(meas_dir, "pypelinec.log")
    out_dir = out_dir_for(args.comb)

    build_info = {"skipped": True}
    if not args.parse_only:
        build_info = run_build(args, json_path, log_path)
        if build_info["returncode"] != 0:
            print(
                f"!! build/sim exited {build_info['returncode']} -- merging whatever "
                f"was measured so far (see {log_path})",
                file=sys.stderr,
            )

    if not os.path.exists(json_path):
        print(f"ERROR: no perf JSON at {json_path}; nothing to merge", file=sys.stderr)
        return 1
    with open(json_path) as f:
        perf_raw = json.load(f)

    stdout_info = parse_stdout(log_path)
    fmax = parse_fmax(out_dir, stdout_info)
    area = parse_area(out_dir, per_module=not args.no_per_module_area)
    target_mhz = fmax.get("target_mhz") or DEFAULT_TARGET_MHZ
    phases = derive_throughput(perf_raw, fmax.get("design_mhz"), target_mhz)
    # Internal taps -> per-block throughput/ceiling, a bottleneck verdict and the
    # model cross-check. A run with no taps leaves the phases untouched.
    aad_len = perf_raw.get("config", {}).get("aad_len") or 0
    bottleneck.analyze(phases, aad_len=aad_len)

    results = {
        "schema_version": 1,
        "label": label,
        "generated_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"),
        "config": dict(
            perf_raw.get("config", {}),
            comb=args.comb,
            out_dir=os.path.relpath(out_dir, HERE),
            target_mhz=target_mhz,
            build_cmd=build_info.get("cmd"),
            reuse_syn=bool(args.reuse_syn),
        ),
        "provenance": {
            "wireguard_fpga_git": git_describe(os.path.join(HERE, "..", "..")),
            # Recorded at build launch when there was a build (see run_build).
            "pipelinec_git": build_info.get("pipelinec_git")
            or git_describe(
                os.path.dirname(os.path.dirname(os.environ.get("PYPELINEC", DEFAULT_PIPELINEC_REPO + "/src/x")))
            ),
            "vivado_version": area.get("vivado_version") if area.get("available") else None,
            "host": socket.gethostname(),
            "build_wall_s": build_info.get("wall_s"),
            "build_returncode": build_info.get("returncode"),
            "cycles_run": stdout_info["sim_cycles"] or build_info.get("clock_lines"),
            "sim_wall_s": stdout_info["sim_wall_s"],
            # With --reuse-syn the Vivado logs (hence fmax/area) were produced by
            # an EARLIER run, so they can predate pipelinec_git above, which is
            # the revision that ran this sim.
            "synthesis_reused": bool(args.reuse_syn),
            "log": os.path.relpath(log_path, HERE),
            "perf_raw": os.path.relpath(json_path, HERE),
        },
        "fmax": fmax,
        "area": area,
        "phases": phases,
        "summary": summarize(phases),
        "checks": perf_raw.get("checks", {}),
        "sim": perf_raw.get("sim", {}),
    }
    if args.area_from_dir:
        results["area_hw_build"] = parse_area(
            os.path.join(HERE, args.area_from_dir),
            per_module=not args.no_per_module_area,
        )
        results["area_hw_build"]["scope"] = "hardware_top"
        results["area_hw_build"]["constant_key_folding"] = False

    results_path = os.path.join(meas_dir, "results.json")
    with open(results_path, "w") as f:
        json.dump(results, f, indent=1)
    write_csv(os.path.join(meas_dir, "summary.csv"), label, phases)
    table = markdown_table(results)
    with open(os.path.join(meas_dir, "summary.md"), "w") as f:
        f.write(table + "\n")
    extra_csvs = write_tap_csvs(meas_dir, label, phases)
    block_table = None
    blocks_path = os.path.join(meas_dir, "blocks.md")
    if any(phase.get("blocks") for phase in phases):
        block_table = bottleneck.markdown_blocks(phases)
        with open(blocks_path, "w") as f:
            f.write(block_table + "\n")
    # The README gets a text summary only; the full tables stay in blocks.md.
    # Always produced -- a run without taps yields a "no internal taps" note, so
    # the README never pairs this run's table with a previous run's summary.
    block_summary = bottleneck.markdown_summary(
        phases, os.path.relpath(blocks_path, HERE)
    )

    if args.update_readme:
        update_readme(table, results, block_summary)

    print()
    print(table)
    if block_table:
        print()
        print(block_table)
    print()
    print(f"--> {results_path}")
    print(f"--> {os.path.join(meas_dir, 'summary.csv')}")
    for path in extra_csvs:
        print(f"--> {path}")
    if block_table:
        print(f"--> {os.path.join(meas_dir, 'blocks.md')}")
    elif perf_raw.get("config", {}).get("taps"):
        print(
            "!! taps were requested but none fired -- check the names against "
            "src/perf_taps.py's probe call sites",
            file=sys.stderr,
        )
    for phase in phases:
        check = phase.get("taps_check")
        if check and not check["consistent"]:
            print(
                f"!! phase {phase['name']}: taps disagree on cycle count "
                f"{check['cycles_seen']} -- a probe fired more than once per "
                f"cycle ({', '.join(check['disagreeing_taps'][:4])}), so its "
                f"per-cycle rates are inflated",
                file=sys.stderr,
            )
    checks = results["checks"]
    if not checks.get("functional_pass", True):
        print(f"!! FUNCTIONAL FAILURES: {checks.get('errors')}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
