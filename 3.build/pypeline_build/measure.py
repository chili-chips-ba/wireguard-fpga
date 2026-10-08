#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""QoR measurement orchestrator: one command that produces a complete, diffable
(fmax, area, throughput, latency) record for a design variant.

What it does:
  1. runs `./build.py --shared --perf` -- ONE pypelinec command line that
     autopipelines for the selected clock goal through Vivado and then runs the
     native simulation of exactly what it built (autopipelined latencies
     modeled), with the perf testbench's phase plan passed in as -D PERF_*
     design parameters, so the elaborated hardware never changes between runs;
  2. reads fmax + pipeline depth from pypelinec's OWN numbers -- the per-MAIN
     "final" records in <out_dir>/top/sweep_history.json (schemas 2/3), with the
     build's stdout outcome lines as cross-check -- timing parsing is not
     reimplemented here;
  3. reads area from that same build's Vivado log using the utilization parser
     below (not pypelinec's diagnostic-only one);
  4. merges everything into measurements/<label>/results.json (machine
     readable), summary.csv (one row per phase x direction), and a markdown
     table ready to paste into README.md;
  5. rolls the run's INTERNAL taps (PipelineC stream/stream_perf_probe.py calls
     inside the design's own hardware functions) up into per-block
     throughput/stall numbers and an automated bottleneck verdict per phase --
     see bottleneck.py.

The generic report math (MHz conversion, summary, CSV rows, boundary table,
README marker splicing) is PipelineC's stream/stream_perf_report.py; this file
adds WireGuard's build orchestration, fmax/area parsing, acceptance checks and
evidence handling.

Cycle-domain measurements and MHz live in separate steps on purpose: the
testbench records cycles/beats/bytes only, so throughput can be re-expressed at
a different fmax without re-simulating.

Typical use:
  ./measure.py --label shared-60mhz          # default sharing-both 60 MHz; synthesis + sim (hours)
  ./measure.py --share-chacha20 --poly1305 legacy # historical architecture, 80 MHz goal
  ./measure.py --label X --reuse-syn         # sim only, reuse cached synthesis
  ./measure.py --label smoke --comb          # fast rig check, no Vivado at all
  ./measure.py --label X --parse-only        # re-merge an existing run's outputs
  ./measure.py --label X --sizes 64,1420 --packets 4
"""

import argparse
import copy
import datetime
import glob
import hashlib
import json
import os
import re
import socket
import shutil
import subprocess
import sys
import time
import tempfile
from pathlib import Path

import bottleneck  # also puts PipelineC's include/pypeline on sys.path
from stream import stream_perf_report as perf_report
from stream.stream_bottleneck import buffer_tap_errors
from stream.stream_perf import stream_fifo_capacity_beats

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "src"))
from wireguard_env import (
    IMPLEMENTATIONS, selected_implementation, implementation_out_dir,
    TARGETS_MHZ, default_target_mhz, target_out_dir, GENERATED_FILES, generated_out_dir,
    add_sharing_arguments, sharing_from_args, sharing_name, sharing_out_dir,
)
DEFAULT_PIPELINEC_REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", "PipelineC"))
BUS_BYTES = 16

# pypelinec stdout lines worth keeping as a cross-check on sweep_history.json.
RE_FMAX = re.compile(r"(?:(PASS|FAIL)\s+)?Clock (\S+) FMAX: ([\d.]+) MHz \(([\d.]+) ns\)")
RE_SWEEP_ITER = re.compile(
    r"\[sweep\] iter=(\d+) main=(\S+) goal=([\d.]+)MHz got=([\d.]+)MHz"
)
RE_TIMING_NOT_MET = re.compile(r"ERROR: TIMING NOT MET: .*")
# The FINAL per-MAIN outcome lines. A schema-2/3 sweep_history.json's "final"
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
    r"^(PASS|FAIL)\s+(\S+): ([\d.]+) MHz vs ([\d.]+) MHz goal"
    r"(?:; worst reported path)? \(confirmation run\)"
)
RE_NOT_MET_MAIN = re.compile(
    r"ERROR: TIMING NOT MET: (\S+) achieved ([\d.]+) MHz vs ([\d.]+) MHz goal"
)
RE_NOT_AUTOPIPELINED = re.compile(r"\[sweep\]\s+(\S+): not auto-?pipelined")
RE_DEPTH = re.compile(r"\[sweep\]\s+(\S+): (\d+) slice\(s\) total \((\d+) pipeline stages")
RE_CLOCK_LINE = re.compile(r"^Clock:\s+\d+\s*$")
RE_SIM_SPEED = re.compile(r"(\d+) cycles in ([\d.]+)s")


# Report row name (exact, after stripping indent and any trailing '*') -> key.
# Section-qualified so e.g. a "RAMB18" row can never be confused with a
# same-named primitive row.
_ROW_KEYS = {
    "slice logic": {
        "Slice LUTs": "lut_total",
        "CLB LUTs": "lut_total",  # UltraScale naming, harmless here
        "LUT as Logic": "lut_logic",
        "LUT as Memory": "lut_memory",
        "LUT as Distributed RAM": "lut_dram",
        "LUT as Shift Register": "lut_srl",
        "Slice Registers": "ff_total",
        "CLB Registers": "ff_total",
        "Register as Flip Flop": "ff_flipflop",
        "Register as Latch": "latches",
        "F7 Muxes": "muxf7",
        "F8 Muxes": "muxf8",
    },
    "memory": {
        "Block RAM Tile": "bram_tiles",
        "RAMB36/FIFO": "ramb36",
        "RAMB18": "ramb18",
    },
    "dsp": {
        "DSPs": "dsp48",
    },
    "primitives": {
        "CARRY4": "carry4",
    },
}

# Resources whose Available/Util% columns are worth keeping.
_AVAIL_KEYS = {
    "lut_total": "lut",
    "ff_total": "ff",
    "dsp48": "dsp",
    "bram_tiles": "bram_tiles",
}

_SECTION_RE = re.compile(r"^\d+(?:\.\d+)*\.\s+(.*?)\s*$")
_HEADER_RE = re.compile(r"^\|\s*(Design|Device|Design State|Tool Version)\s*:\s*(.*?)\s*$")
_TABLE_HEADER_CELLS = ("Site Type", "Ref Name")


def _num(cell):
    """Vivado cells are ints ('26917'), floats ('8.5') or blank."""
    cell = cell.strip()
    if not cell:
        return None
    try:
        return int(cell)
    except ValueError:
        pass
    try:
        return float(cell)
    except ValueError:
        return None


def _row_cells(line):
    """'| Slice LUTs* | 26917 | 0 | 134600 | 20.00 |' -> ['Slice LUTs*', '26917', ...]

    Column widths vary per run (a small module's table is much narrower), so
    split on '|' rather than slicing fixed offsets.
    """
    if not line.startswith("|"):
        return None
    inner = line.strip()
    if inner.startswith("|"):
        inner = inner[1:]
    if inner.endswith("|"):
        inner = inner[:-1]
    return [c.strip() for c in inner.split("|")]


def _split_blocks(text):
    """One entry per `report_utilization` in the log. A synthesis-only run (the
    pypelinec default, VIVADO.DO_PNR is None) has exactly one; a PnR run has
    more, so callers must be able to choose."""
    marker = "Utilization Design Information"
    blocks = []
    for m in re.finditer(re.escape(marker), text):
        start = text.rfind("\n# report_utilization", 0, m.start())
        if start == -1:
            # No echoed command (e.g. hand-saved report): fall back to the
            # report's own '---' header banner just above the marker.
            start = max(0, m.start() - 2000)
        # A block ends at the next echoed tcl command after the marker.
        end = text.find("\n# ", m.end())
        blocks.append(text[start : end if end != -1 else len(text)])
    return blocks


def parse_utilization(text):
    """Parse one utilization block's text into a flat dict of area numbers."""
    out = {
        "design": None,
        "part": None,
        "design_state": None,
        "vivado_version": None,
        "available": {},
        "util_pct": {},
    }
    section = None
    in_table = False
    for line in text.splitlines():
        stripped = line.rstrip()
        header = _HEADER_RE.match(stripped)
        if header:
            field, value = header.group(1), header.group(2)
            if field == "Design":
                out["design"] = value
            elif field == "Device":
                out["part"] = value
            elif field == "Design State":
                out["design_state"] = value
            elif field == "Tool Version":
                m = re.search(r"Vivado v\.?([\w.]+)", value)
                out["vivado_version"] = m.group(1) if m else value
            continue
        sect = _SECTION_RE.match(stripped)
        if sect:
            section = sect.group(1).strip().lower()
            in_table = False
            continue
        cells = _row_cells(stripped)
        if not cells:
            continue
        if cells[0] in _TABLE_HEADER_CELLS:
            in_table = True
            continue
        if not in_table or len(cells) < 2:
            continue
        name = cells[0].rstrip("*").strip()
        keys = _ROW_KEYS.get(section, {})
        key = keys.get(name)
        if key is None:
            continue
        value = _num(cells[1])
        if value is None:
            continue
        # First occurrence wins: Vivado's sub-rows ("1.1 Summary of Registers
        # by Type") repeat names with different meanings.
        out.setdefault(key, value)
        avail_key = _AVAIL_KEYS.get(key)
        if avail_key and len(cells) >= 5:
            avail, pct = _num(cells[3]), _num(cells[4])
            if avail is not None:
                out["available"].setdefault(avail_key, avail)
            if pct is not None:
                out["util_pct"].setdefault(avail_key, pct)
    return out


def parse_log(path, prefer="last"):
    """Parse the chosen utilization block of a pypelinec vivado log.

    prefer: 'last' (default) takes the final block, preferring a routed report
    over a synthesized one when both exist -- the routed numbers are the real
    ones. With pypelinec's default synthesis-only flow there is just one block.
    """
    with open(path, "r", errors="replace") as f:
        text = f.read()
    blocks = _split_blocks(text)
    if not blocks:
        raise ValueError(f"no report_utilization block found in {path}")
    parsed = [parse_utilization(b) for b in blocks]
    routed = [p for p in parsed if (p.get("design_state") or "").lower().find("rout") >= 0]
    if prefer == "last" and routed:
        chosen = routed[-1]
    else:
        chosen = parsed[-1]
    chosen["log"] = os.path.abspath(path)
    chosen["blocks_found"] = len(blocks)
    return chosen


_MODULE_LOG_RE = re.compile(r"vivado_(\d+)CLK_[0-9a-f]+(?:_[0-9a-f]+)?\.log$")
_TOP_LOG_RE = re.compile(r"vivado_([0-9a-f]+)(?:_[0-9a-f]+)?\.log$")


def find_top_dir(out_dir):
    """Support the default 'top' and hardware builds using --top <name>.

    Module characterization logs have NCLK in their names; whole-design
    sweep logs do not. Signed caches copied from other tops are not active
    builds: prefer directories with sweep history or final top HDL. Keep
    log-only historical support, and refuse genuinely mixed output directories.
    """
    histories = {os.path.dirname(path) for path in
                 glob.glob(os.path.join(out_dir, "*", "sweep_history.json"))}
    log_dirs = {os.path.dirname(path) for path in
                glob.glob(os.path.join(out_dir, "*", "vivado_*.log"))
                if _TOP_LOG_RE.fullmatch(os.path.basename(path))}
    built = histories | {path for path in log_dirs
                         if os.path.isfile(os.path.join(path, os.path.basename(path) + ".vhd"))}
    candidates = built or log_dirs
    if len(candidates) > 1:
        raise ValueError("multiple hardware tops in output directory: " + ", ".join(sorted(candidates)))
    return next(iter(candidates)) if candidates else os.path.join(out_dir, "top")


def _instantiated_entities(path):
    if not os.path.exists(path):
        return None
    with open(path) as source:
        return set(re.findall(r"\bentity\s+work\.([a-z][a-z0-9_]*)", source.read().lower()))


def _select_top_log(top_dir, logs):
    # The final top drops the timing-snapshot hash, but instantiates the
    # content-hashed MAIN entities that identify its actual built depths.
    # Match those before using mtime: a sweep can restore an earlier winner.
    top_name = os.path.basename(top_dir)
    history_path = os.path.join(top_dir, "sweep_history.json")
    if os.path.isfile(history_path):
        with open(history_path) as source:
            history = json.load(source)
        retained = history.get("retained_observation") or {}
        log = retained.get("log_path")
        # Basename permits moving a complete output directory without losing provenance.
        if history.get("build_complete") and log:
            candidate = os.path.join(top_dir, os.path.basename(log))
            if candidate in logs:
                return candidate, "retained implementation and constraints from sweep history"
    final_entities = _instantiated_entities(os.path.join(top_dir, top_name + ".vhd"))
    if final_entities:
        matching = []
        for log in logs:
            digest = _TOP_LOG_RE.fullmatch(os.path.basename(log)).group(1)
            snapshot = os.path.join(top_dir, top_name + "_" + digest + ".vhd")
            if _instantiated_entities(snapshot) == final_entities:
                matching.append(log)
        if not matching:
            raise ValueError("no utilization snapshot matches the final HDL MAIN entities")
        return max(matching, key=os.path.getmtime), "final HDL MAIN entities; latest matching run"
    return max(logs, key=os.path.getmtime), "latest top-level run; no final HDL available"


def parse_out_dir(out_dir, per_module=True):
    """Parse a whole pypelinec output directory: the top-level design plus, if
    asked, every module's out-of-context synthesis."""
    result = {"out_dir": os.path.abspath(out_dir), "top": None, "per_module": {}}
    top_dir = find_top_dir(out_dir)
    top_logs = [path for path in glob.glob(os.path.join(top_dir, "vivado_*.log"))
                if _TOP_LOG_RE.fullmatch(os.path.basename(path))]
    if top_logs:
        top_log, basis = _select_top_log(top_dir, top_logs)
        result["top"] = parse_log(top_log)
        result["top"]["logs_available"] = len(top_logs)
        result["top"]["selection_basis"] = basis
    if not per_module:
        return result
    for log in glob.glob(os.path.join(out_dir, "**", "vivado_*CLK_*.log"), recursive=True):
        rel = os.path.relpath(os.path.dirname(log), out_dir)
        m = _MODULE_LOG_RE.search(os.path.basename(log))
        latency = int(m.group(1)) if m else None
        try:
            parsed = parse_log(log)
        except ValueError:
            continue
        parsed["latency_clks"] = latency
        prev = result["per_module"].get(rel)
        # These are characterization data, not necessarily the final instance.
        # Keep the deepest tried depth and label it explicitly.
        parsed["selection_basis"] = "deepest characterized latency; not necessarily instantiated"
        if prev is None or (latency or 0) >= (prev.get("latency_clks") or 0):
            result["per_module"][rel] = parsed
    return result


_AREA_FIELDS = (
    "lut_total",
    "lut_logic",
    "lut_memory",
    "lut_dram",
    "lut_srl",
    "ff_total",
    "ff_flipflop",
    "latches",
    "muxf7",
    "muxf8",
    "dsp48",
    "bram_tiles",
    "ramb36",
    "ramb18",
    "carry4",
)


def format_area(parsed):
    lines = [
        f"design      : {parsed.get('design')}",
        f"part        : {parsed.get('part')}",
        f"state       : {parsed.get('design_state')}  (vivado {parsed.get('vivado_version')})",
    ]
    for field in _AREA_FIELDS:
        if parsed.get(field) is not None:
            lines.append(f"{field:<12}: {parsed[field]}")
    if parsed.get("util_pct"):
        lines.append(f"util%       : {parsed['util_pct']}")
    return "\n".join(lines)


_SELFTEST_CASES = (
    (
        "measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/hardware-vivado.log",
        {
            "lut_total": 42617,
            "ff_total": 12934,
            "dsp48": 512,
            "bram_tiles": 11,
            "part": "7a200tffg1156-2",
        },
    ),
    (
        "measurements/shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/perf-vivado.log",
        {"lut_total": 33778, "ff_total": 9877, "dsp48": 448, "bram_tiles": 11},
    ),
)


def area_selftest(base_dir):
    """Parse real logs already on disk and check the values read off them by
    hand. Free regression cover for the parser -- no Vivado run needed."""
    failures = []
    ran = 0
    for rel, expected in _SELFTEST_CASES:
        path = os.path.join(base_dir, rel)
        if not os.path.exists(path):
            print(f"SKIP (missing): {rel}")
            continue
        ran += 1
        parsed = parse_log(path)
        for key, want in expected.items():
            got = parsed.get(key)
            if got != want:
                failures.append(f"{rel}: {key} expected {want!r} got {got!r}")
        for key in ("lut_total", "ff_total"):
            if parsed.get(key) is None:
                failures.append(f"{rel}: {key} missing")
        print(f"OK: {rel} -> LUT {parsed.get('lut_total')} FF {parsed.get('ff_total')} "
              f"DSP {parsed.get('dsp48')} BRAM {parsed.get('bram_tiles')} CARRY4 {parsed.get('carry4')}")
    for f in failures:
        print("FAIL: " + f)
    if not ran:
        print("no logs available to test against")
        return 1
    print("selftest: " + ("PASS" if not failures else f"{len(failures)} FAILURE(S)"))
    return 1 if failures else 0


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


def out_dir_for(comb, implementation, target_mhz=None, sharing=None):
    if target_mhz is None:
        # Records without sharing metadata predate the sharing-both default.
        historical_sharing = {"chacha20": True, "poly1305": False}
        target_mhz = default_target_mhz(implementation, sharing if sharing is not None else historical_sharing)
    base = os.path.join(
        HERE, GENERATED_FILES, f"perf-{'comb' if comb else 'pipe'}-shared-native"
    )
    base = implementation_out_dir(base, implementation)
    # None means a historical record, whose directory predates sharing flags.
    if sharing is not None:
        base = sharing_out_dir(base, sharing)
    return target_out_dir(base, target_mhz)


def run_build(args, json_path, log_path):
    """Run build.py --perf, teeing its (very chatty) stdout to log_path.

    The per-cycle 'Clock: N' lines are dropped from the saved log -- they are
    the bulk of it and carry no information the JSON doesn't -- but they are
    counted, which is how cycles_run is recovered.
    """
    env = dict(os.environ)
    if not env.get("PYPELINEC"):
        candidate = os.path.join(DEFAULT_PIPELINEC_REPO, "src", "pypelinec")
        if os.path.exists(candidate):
            env["PYPELINEC"] = candidate
            # Mirror it into our own environment so provenance below records the
            # same PipelineC checkout the build actually used.
            os.environ["PYPELINEC"] = candidate
            print(f"--> $PYPELINEC not set, using {candidate}")
    # The perf testbench's phase plan: simulation-only design parameters
    defines = [f"PERF_JSON={json_path}"]
    if args.sizes:
        defines.append(f"PERF_SIZES={args.sizes}")
    if args.packets:
        defines.append(f"PERF_PACKETS={args.packets}")
    if args.peak_bytes is not None:
        defines.append(f"PERF_PEAK_BYTES={args.peak_bytes}")
    if args.dirs:
        defines.append(f"PERF_DIRS={args.dirs}")
    if args.taps is not None:
        defines.append(f"PERF_TAPS={args.taps}")
    if args.seed is not None:
        defines.append(f"PERF_SEED={args.seed}")

    cmd = [os.path.join(HERE, "build.py"), "--perf",
           "--poly1305", args.poly1305, "--target-mhz", str(args.target_mhz)]
    for name in ("chacha20", "poly1305"):
        if args.sharing[name]:
            cmd.append("--share-" + name)
    if not (args.sharing["chacha20"] or args.sharing["poly1305"]):
        cmd.append("--share-none")
    for define in defines:
        cmd.extend(["-D", define])
    if args.jobs is not None:
        cmd.extend(["-j", str(args.jobs)])
    if args.out_dir:
        cmd.extend(["--out-dir", args.out_dir])
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


# Schema-2/3 sweep_history.json "final" field -> per_main field (the names the
# stdout parser above already uses, so both sources merge the same way)
HISTORY_FINAL_FIELDS = (
    ("met", "met"),
    ("achieved_mhz", "achieved_mhz"),
    ("mhz_is_lower_bound", "mhz_is_lower_bound"),
    ("met_basis", "met_basis"),
    ("source", "outcome"),
    ("standalone_mhz", "standalone_mhz"),
    ("autopipelined", "autopipelined"),
    ("auto_pipelined", "autopipelined"),  # sweep_history key after the AUTO_PIPELINE rename
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

    A schema-2/3 `sweep_history.json` from a complete build carries one "final"
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
    sweep_path = os.path.join(find_top_dir(out_dir), "sweep_history.json")
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
        parsed = parse_out_dir(out_dir, per_module=per_module)
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
    area["resources_available"] = area.pop("available", {})
    area["available"] = True
    area["over_capacity"] = {
        name: percent for name, percent in area.get("util_pct", {}).items()
        if percent is not None and percent > 100
    }
    area["fits_device"] = not area["over_capacity"] if area.get("util_pct") else None
    area["scope"] = "perf_tb_top"
    # The perf testbench drives key/nonce/aad as constants, so Vivado folds some
    # ChaCha20 logic away: this number is consistent ACROSS VARIANTS but is not
    # an absolute DUT area. --area-from-dir on a hardware (./build.py --shared)
    # build gives the folding-free cross-check; per-module OOC areas below are
    # folding-free too.
    area["constant_key_folding"] = True
    area["per_module"] = parsed["per_module"]
    return area


DIRECTIONS = bottleneck.DIRECTIONS


def derive_throughput(perf_raw, fmax_mhz, target_mhz):
    """Add MHz-dependent columns to the testbench's cycle-domain numbers."""
    return perf_report.derive_throughput(perf_raw, fmax_mhz, target_mhz, BUS_BYTES, DIRECTIONS)


def summarize(phases):
    return perf_report.summarize(phases, DIRECTIONS)


# WireGuard's summary.csv keeps its historical `direction` column name.
CSV_COLUMNS = perf_report.CSV_COLUMNS[:4] + ("direction",) + perf_report.CSV_COLUMNS[5:]


def write_csv(path, label, phases):
    perf_report.write_csv(path, CSV_COLUMNS, perf_report.csv_rows(label, phases, DIRECTIONS))


def write_tap_csvs(meas_dir, label, phases):
    """Per-tap and per-block rows, one file each -- the internal-stall curve, in
    the same flat shape as summary.csv so the two diff/plot the same way."""
    written = []
    for name, columns, rows in (
        ("taps.csv", bottleneck.TAP_CSV_COLUMNS, list(bottleneck.tap_rows(label, phases))),
        ("blocks.csv", bottleneck.BLOCK_CSV_COLUMNS, list(bottleneck.block_rows(label, phases))),
    ):
        if rows:  # no empty files for a run without taps
            path = os.path.join(meas_dir, name)
            perf_report.write_csv(path, columns, rows)
            written.append(path)
    return written


_fmt = perf_report.fmt


def markdown_table(results, include_mac_details=True):
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
    hardware_area = results.get("area_hw_build") or {}
    if hardware_area.get("available"):
        lines.append(
            f"DUT-only area (external key/data ports): **{hardware_area.get('lut_total')} LUT**, "
            f"**{hardware_area.get('ff_total')} FF**, **{hardware_area.get('dsp48')} DSP48**, "
            f"**{hardware_area.get('bram_tiles')} BRAM tiles**."
        )
    hardware_fmax = results.get("fmax_hw_build") or {}
    if hardware_fmax:
        hardware_outcome = "PASS" if hardware_fmax.get("timing_met") is True else "not confirmed"
        lines.append(
            f"Hardware-top timing: {hardware_outcome}, "
            f"{_fmt(hardware_fmax.get('design_mhz'), '.2f')} MHz "
            f"against {_fmt(hardware_fmax.get('target_mhz'), '.1f')} MHz."
        )
    mac = results.get("config", {}).get("poly1305") or {}
    sharing = results.get("config", {}).get("sharing")
    if sharing is not None:
        lines.append(f"Shared resources: `{sharing_name(sharing)}`.")
    else:
        lines.append("Historical sharing metadata absent: interpreted as ChaCha20-only sharing.")
    for name, buffer in sorted(results.get("config", {}).get("buffering", {}).items()):
        lines.append(f"Buffer `{name}`: {buffer['memory_depth_beats']} memory beats + "
                     f"{buffer['output_register_beats']} output beat; "
                     f"{buffer['capacity_beats']} total capacity.")
        sizing = buffer.get("sizing", {})
        if sizing.get("method") == "chacha-credit-bound-v1":
            lines.append(
                f"Automatic sizing: {sizing['required_beats']} required beats; "
                f"ChaCha core={sizing['chacha20_core_latency']}, "
                f"credits={sizing['chacha20_max_in_flight_blocks']} blocks, "
                f"prologue MCP={sizing['prologue_mcp_latency']} cycles."
            )
    for name, stream_slice in sorted(results.get("config", {}).get("stream_slices", {}).items()):
        lines.append(f"Register slice `{name}`: mode `{stream_slice['mode']}`, "
                     f"{stream_slice['capacity_beats']} slots, "
                     f"{stream_slice['latency_cycles']} unstalled cycle(s), II=1.")
    if mac:
        lines.append(f"Poly1305 implementation: `{mac['implementation']}`.")
        service = mac.get("shared_mcps")
        if service and include_mac_details:
            lines.append(
                f"Shared MCP capacity={service['capacity_lanes']} lanes; "
                f"prologue constraint={service['prologue_mcp_latency']} cycles, "
                f"epilogue constraint={service['epilogue_mcp_latency']} cycles. "
                "Each response adds one handshake cycle; arbitration waits are measured separately."
            )
        for direction, timing in (sorted(mac.get("directions", {}).items()) if include_mac_details else []):
            details = (f"{direction}: body II={timing['body_ii']}, "
                       f"accumulators={timing['accumulator_count']}")
            if "body_latency" in timing:
                details += (
                    f", body response={timing['body_latency']} cycles"
                    f", prologue response={timing['prologue_response_cycles']} cycles"
                    f", epilogue response={timing['epilogue_response_cycles']} cycles"
                )
            lines.append(details + ".")
    lines.append("")
    lines.extend(perf_report.markdown_boundary_table(
        results["phases"], DIRECTIONS, fmax, results["fmax"].get("target_mhz"), label_header="dir"))
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


_splice = perf_report.splice_markers


def update_readme(table, results, block_summary=None):
    """Splice the generated results into README.md so their numbers are never
    hand-copied (and so re-measuring a variant updates the docs in one step).

    The README carries exactly one table -- the boundary QoR table -- plus a
    pointer to the block analysis; the full block tables live in the run's
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


ENTITY = re.compile(r"^\s*entity\s+(\w+)\s+is\b", re.MULTILINE | re.IGNORECASE)
CHILD = re.compile(r":\s*entity\s+work\.(\w+)", re.IGNORECASE)
LATENCY = re.compile(r"ADDED_PIPELINE_LATENCY\s*:\s*integer\s*:=\s*(\d+)", re.IGNORECASE)
MCP_BODY = re.compile(
    r"^(prologue|epilogue)_from_poly1305_mac_pipelined_make_poly1305_mac_pipelined"
    r"_direction_(encrypt|decrypt)(?:_share_mcp_false)?_\d+clk_", re.IGNORECASE)
SHARED_MCP_BODY = re.compile(
    r"^(prologue|epilogue)_from_poly1305_mcp_shared_make_shared_compute"
    r"_capacity_\d+_\d+clk_", re.IGNORECASE)


def audit_poly1305_hdl(out_dir, directions=("encrypt", "decrypt"), top_vhdl=None, shared=None):
    out_dir = Path(out_dir).resolve()
    if top_vhdl is None:
        top_dir = Path(find_top_dir(str(out_dir)))
        top_vhdl = top_dir / (top_dir.name + ".vhd")
    top_vhdl = Path(top_vhdl).resolve()
    if not top_vhdl.is_file():
        raise ValueError(f"Final top HDL is missing: {top_vhdl}")
    entities = {}
    for path in out_dir.rglob("*.vhd"):
        text = re.sub(r"--[^\n]*", "", path.read_text())
        name = ENTITY.search(text)
        if name:
            latency = LATENCY.search(text)
            entities[name.group(1).lower()] = {
                "file": str(path.relative_to(out_dir)),
                "latency": int(latency.group(1)) if latency else None,
                "clocked": bool(re.search(r"\b(?:rising|falling)_edge\s*\(", text,
                                          re.IGNORECASE)),
                "children": [child.lower() for child in CHILD.findall(text)],
            }
    top_match = ENTITY.search(re.sub(r"--[^\n]*", "", top_vhdl.read_text()))
    if not top_match:
        raise ValueError(f"No entity declaration in {top_vhdl}")
    errors = []

    def walk(root):
        seen = set()
        pending = [root]
        while pending:
            entity = pending.pop()
            if entity in seen:
                continue
            seen.add(entity)
            info = entities.get(entity)
            if info is None:
                errors.append(f"Missing emitted entity: {entity}")
                continue
            pending.extend(info["children"])
            yield entity, info

    roots, physical_counts = {}, {}
    # Counting distinct entity TYPES would miss two physical instances of the
    # same shared kernel. Traverse instantiation edges (duplicates included),
    # stopping at the arithmetic roots, then audit each root's descendants.
    pending = [(top_match.group(1).lower(), ())]
    while pending:
        entity, ancestors = pending.pop()
        if entity in ancestors:
            errors.append("Cyclic HDL instantiation: " + entity)
            continue
        match = MCP_BODY.match(entity)
        shared_match = SHARED_MCP_BODY.match(entity)
        label = None
        if match:
            label = (match.group(2).lower(), match.group(1).lower())
        elif shared_match:
            label = ("shared", shared_match.group(1).lower())
        if label is not None:
            roots[label] = entity
            physical_counts[label] = physical_counts.get(label, 0) + 1
            continue
        info = entities.get(entity)
        if info is None:
            errors.append("Missing emitted entity: " + entity)
            continue
        pending.extend((child, ancestors + (entity,)) for child in info["children"])
    detected_shared = any(direction == "shared" for direction, _ in roots)
    if shared is not None and bool(shared) != detected_shared:
        errors.append("Emitted MCP sharing does not match requested architecture")
    if detected_shared and any(direction != "shared" for direction, _ in roots):
        errors.append("Both shared and private MCP arithmetic is reachable")
    reports = {}
    for direction in (("shared",) if detected_shared else directions):
        for phase in ("prologue", "epilogue"):
            label = direction + "/" + phase
            root = roots.get((direction, phase))
            if root is None:
                errors.append(f"Missing reachable MCP arithmetic: {label}")
                continue
            count = physical_counts[(direction, phase)]
            if count != 1:
                errors.append(f"{label}: expected one physical MCP arithmetic instance, got {count}")
            descendants = list(walk(root))
            bad = [entity for entity, info in descendants
                   if info["latency"] not in (None, 0) or info["clocked"]]
            reports[label] = {"entity": root, "file": entities[root]["file"],
                              "physical_instances": count,
                              "entities_checked": len(descendants),
                              "registered_entities": bad}
            for entity in bad:
                errors.append(f"{label}: registered arithmetic inside MCP: {entity}")
    return {"out_dir": str(out_dir), "top_vhdl": str(top_vhdl),
            "scope": "emitted MCP arithmetic only; not timing/constraint sign-off",
            "shared": detected_shared,
            "mcps": reports, "passed": not errors, "errors": errors}


def auth_fifo_sizing_errors(config):
    """Check new automatic budgets; historical/explicit records stay readable."""
    buffer = config.get("buffering", {}).get("decrypt/auth_fifo", {})
    sizing = buffer.get("sizing", {})
    if sizing.get("method") != "chacha-credit-bound-v1":
        return []
    label = "decrypt/auth_fifo: "
    keys = ("chacha20_core_latency", "chacha20_max_in_flight_blocks",
            "chacha20_block_beats", "prologue_mcp_latency", "max_aad_beats")
    values = [sizing.get(key) for key in keys]
    if any(type(value) is not int or value < 0 for value in values):
        return [label + "automatic sizing inputs are missing/invalid"]
    core, credits, ratio, prologue, aad = values
    if credits != core + 5 or ratio < 1 or prologue < 1:
        return [label + "automatic sizing inputs disagree with stream contracts"]
    shared = sizing.get("shared_mcps")
    if type(shared) is not bool:
        return [label + "automatic sizing lacks MCP sharing selection"]
    expected = {
        "pipeline_credits": ratio * credits,
        "widening_storage": ratio + 1,
        "fork_copy_lead": 1,
        "fifo_startup": 2,
        "framing_idle": 1,
        "prologue_service": (1 + int(shared)) * (prologue + 1),
        "mac_transitions": 2,
        "aad_framing": aad,
    }
    required = sum(expected.values())
    depth = 1 << (max(2, required) - 1).bit_length()
    errors = []
    if sizing.get("terms_beats") != expected or sizing.get("required_beats") != required:
        errors.append(label + "automatic sizing budget disagrees with resolved inputs")
    if sizing.get("memory_depth_beats") != depth or buffer.get("memory_depth_beats") != depth:
        errors.append(label + "automatic sizing disagrees with allocated memory")
    mac = config.get("poly1305", {}).get("directions", {}).get("decrypt", {})
    if mac.get("prologue_mcp_latency") != prologue or bool(mac.get("shared_mcps")) != shared:
        errors.append(label + "automatic sizing disagrees with selected MAC metadata")
    return errors


def measurement_errors(results):
    """Acceptance checks; failed runs still retain all diagnostic artifacts."""
    errors = []
    errors.extend(auth_fifo_sizing_errors(results.get("config", {})))
    returncode = results.get("provenance", {}).get("build_returncode")
    if returncode:
        errors.append(f"Build/simulation exited {returncode}")
    checks = results.get("checks", {})
    if not checks.get("functional_pass", False):
        errors.append(f"Functional checks did not pass: {checks.get('errors')}")
    if not results.get("sim", {}).get("finalized", False):
        errors.append("Performance simulation did not finalize all phases")
    area = results.get("area", {})
    if not results.get("config", {}).get("comb", False):
        if results.get("fmax", {}).get("timing_met") is not True:
            errors.append("Measurement lacks a confirmed timing pass")
        if area.get("available") is not True:
            errors.append("Measurement lacks a synthesis area report")
        requested = results.get("config", {}).get("requested_target_mhz")
        if requested is not None and results.get("fmax", {}).get("target_mhz") != requested:
            errors.append("Measurement timing clock differs from the requested clock")
    hardware_area = results.get("area_hw_build")
    if hardware_area is not None:
        if hardware_area.get("available") is not True:
            errors.append("Requested hardware-top area report is unavailable")
        if results.get("fmax_hw_build", {}).get("timing_met") is not True:
            errors.append("Hardware-top build lacks a confirmed timing pass")
        requested = results.get("config", {}).get("requested_target_mhz")
        if requested is not None and results.get("fmax_hw_build", {}).get("target_mhz") != requested:
            errors.append("Hardware-top timing clock differs from the requested clock")
    for scope, report in (("Measurement", area), ("Hardware-top", hardware_area or {})):
        if report.get("fits_device") is False:
            errors.append(f"{scope} synthesis exceeds the selected device's resource capacity")
    for phase in results.get("phases", []):
        if phase.get("taps_check", {}).get("consistent") is False:
            errors.append(f"Phase {phase.get('name')}: performance taps disagree on cycle count")
        # Metadata must match each buffer's implementation; the occupancy taps
        # are then checked against that capacity by the library's buffer checks
        # (capacity, overflow, conservation, drained when settled, in/out taps).
        buffers = {}
        for name, buffer in results.get("config", {}).get("buffering", {}).items():
            depth = buffer.get("memory_depth_beats", 0)
            if depth < 2 or buffer.get("capacity_beats") != stream_fifo_capacity_beats(depth):
                errors.append(name + ": FIFO capacity metadata disagree")
                continue
            buffers[name] = buffer["capacity_beats"]
        for name, stream_slice in results.get("config", {}).get("stream_slices", {}).items():
            if stream_slice.get("mode") != "full" or stream_slice.get("capacity_beats") != 2 or stream_slice.get("latency_cycles") != 1:
                errors.append(f"Phase {phase.get('name')}/{name}: output slice metadata disagree with its implementation")
            buffers[name] = 2  # a full-mode skid buffer always holds two beats
        errors.extend(buffer_tap_errors(
            phase, buffers, taps_required="all" in results.get("config", {}).get("taps", []),
            settled=True))
        # New rigs commit source acceptance after convergence. Keep old records
        # readable, but require exact byte accounting from the corrected rig.
        if results.get("config", {}).get("source_handshake") == "converged":
            for direction in results.get("config", {}).get("dirs", []):
                stats = phase.get(direction, {})
                payload = phase["packet_bytes"] * phase["num_packets"]
                tags = 16 * phase["num_packets"]
                expected_in = payload + (tags if direction == "decrypt" else 0)
                expected_out = payload + (tags if direction == "encrypt" else 0)
                label = f"Phase {phase.get('name')}/{direction}"
                if stats.get("in_payload_bytes") != expected_in:
                    errors.append(label + ": input bytes differ from the planned frames")
                if stats.get("out_payload_bytes") != expected_out:
                    errors.append(label + ": output bytes differ from the planned frames")
                tap = phase.get("taps", {}).get(direction + "/chacha20.axis_in")
                if tap and tap.get("bytes") != payload:
                    errors.append(label + ": source byte accounting disagrees with converged DUT acceptance")
        for direction, life in phase.get("poly1305_lifecycle", {}).items():
            label = f"Phase {phase.get('name')}/{direction}"
            if life.get("body_launches") != life.get("body_retirements"):
                errors.append(label + ": body launches/retirements differ")
            for phase_name in ("prologue", "epilogue"):
                launches = life.get(phase_name + "_launches")
                if launches is not None and launches != life.get("completed_packets"):
                    errors.append(label + ": " + phase_name + " launches differ from completed tags")
    mac = results.get("config", {}).get("poly1305") or {}
    if mac.get("implementation") == "pipelined":
        if not mac.get("directions"):
            errors.append("Pipelined measurement lacks resolved per-direction MAC metadata")
        for direction, meta in mac.get("directions", {}).items():
            depth = meta.get("body_core_latency")
            latency = meta.get("body_latency")
            if depth is None or latency != depth + 2 or meta.get("accumulator_count") != latency:
                errors.append(direction + ": body D=P+2 and L=D metadata disagree")
            if meta.get("body_ii") != 1:
                errors.append(direction + ": pipelined body II is not 1")
        sharing = results.get("config", {}).get("sharing") or {}
        if sharing.get("poly1305"):
            if results.get("config", {}).get("source_handshake") != "converged":
                errors.append("Shared MCP measurement lacks converged source handshakes")
            if results.get("config", {}).get("decrypt_verification_retained") is not True:
                errors.append("Shared MCP measurement does not retain decrypt verification in HDL")
            service = mac.get("shared_mcps") or {}
            counts = [m.get("accumulator_count") for m in mac.get("directions", {}).values()]
            if not counts or None in counts or service.get("capacity_lanes") != max(counts):
                errors.append("Shared MCP capacity does not match the maximum local lane count")
            for direction, meta in mac.get("directions", {}).items():
                if meta.get("shared_mcps") is not True:
                    errors.append(direction + ": expected shared MCP metadata")
                for phase in ("prologue", "epilogue"):
                    key = phase + "_mcp_latency"
                    if service.get(key) is None or meta.get(key) != service[key]:
                        errors.append(direction + ": shared " + phase + " latency metadata disagree")
            for phase in results.get("phases", []):
                completed = sum(life.get("completed_packets", 0)
                                for life in phase.get("poly1305_lifecycle", {}).values())
                for name, service_counts in phase.get("poly1305_shared_services", {}).items():
                    if service_counts.get("launches") != completed or service_counts.get("responses") != completed:
                        errors.append(f"Phase {phase.get('name')}: shared {name} request/response accounting differs from completed tags")
    for scope, audit in results.get("mcp_hdl_audits", {}).items():
        if not audit.get("passed"):
            errors.append(scope + ": emitted MCP arithmetic audit failed")
    return errors


def compare_throughput(before, after):
    """Read-only recovery criteria for matched, same-clock concurrent workloads.

    These thresholds are not universal measurement acceptance rules: legacy
    records remain valid, and short-packet asymmetry is reported, not rejected.
    Callers retain source/latency provenance alongside this cycle-domain report.
    """
    errors = []
    for key in ("target_mhz", "dirs", "seed", "sizes", "packets_per_size"):
        if before.get("config", {}).get(key) != after.get("config", {}).get(key):
            errors.append("Comparison workload/config differs: " + key)
    old = {p["packet_bytes"]: p for p in before.get("phases", [])}
    phases = []
    for phase in after.get("phases", []):
        if phase["packet_bytes"] not in (1420, 1920):
            continue
        baseline = old.get(phase["packet_bytes"])
        if baseline is None:
            errors.append("Missing baseline for " + str(phase["packet_bytes"]))
            continue
        comparisons = [bottleneck.concurrent_throughput(p) for p in (baseline, phase)]
        if not all(comparisons):
            errors.append("Comparison requires completed concurrent traffic in both directions")
            continue
        parity = comparisons[1]["full_phase_decrypt_to_encrypt_ratio"]
        enc_gain = phase["encrypt"]["sustained_bytes_per_cycle"] / baseline["encrypt"][
            "sustained_bytes_per_cycle"]
        entry = {"packet_bytes": phase["packet_bytes"], "decrypt_to_encrypt_ratio": parity,
                 "encrypt_after_to_before_ratio": enc_gain,
                 "decrypt_after_to_before_ratio": phase["decrypt"]["sustained_bytes_per_cycle"] /
                 baseline["decrypt"]["sustained_bytes_per_cycle"],
                 "before": comparisons[0], "after": comparisons[1]}
        if parity < .95 or enc_gain < .98:
            errors.append(str(phase["packet_bytes"]) + ": full-phase recovery criteria not met")
        if phase["num_packets"] >= 16:
            windows = [c["contention_window"] for c in comparisons]
            if not all(w.get("enough_intervals") for w in windows):
                errors.append(str(phase["packet_bytes"]) + ": need at least eight overlap intervals; extend run")
            else:
                overlap_gain = windows[1]["encrypt"]["bytes_per_cycle"] / windows[0]["encrypt"]["bytes_per_cycle"]
                entry["overlap_encrypt_after_to_before_ratio"] = overlap_gain
                if windows[1].get("decrypt_to_encrypt_ratio", 0) < .95 or overlap_gain < .98:
                    errors.append(str(phase["packet_bytes"]) + ": contention-window recovery criteria not met")
        phases.append(entry)
    if not phases:
        errors.append("No large-packet phases to compare")
    return {"passed": not errors, "errors": errors, "phases": phases,
            "criteria": {"minimum_decrypt_to_encrypt_ratio": .95,
                         "minimum_encrypt_after_to_before_ratio": .98}}


def check_record(measurement_dir):
    """Read-only acceptance/integrity check, also usable after caches are deleted.

    Old records need no new metadata or manifest. When an archive manifest is
    present, every listed byte is verified and the retained signatures and XDC
    are checked together. Historical workspace paths are never dereferenced.
    """
    directory = Path(measurement_dir)
    results = json.loads((directory / "results.json").read_text())
    errors = measurement_errors(results)
    manifest_path = directory / "artifact-manifest.json"
    if manifest_path.exists():
        manifest = json.loads(manifest_path.read_text())
        artifacts = manifest.get("artifacts", {})
        if not artifacts:
            errors.append("Archive inventory is empty")
        for name, expected in artifacts.items():
            if Path(name).name != name:
                errors.append("Unsafe archive filename: " + name)
                continue
            path = directory / name
            if not path.is_file():
                errors.append("Missing archive artifact: " + name)
            elif path.stat().st_size != expected["bytes"] or hashlib.sha256(path.read_bytes()).hexdigest() != expected["sha256"]:
                errors.append("Archive bytes/checksum mismatch: " + name)
        for prefix, area_key, timing_key in (("perf", "area", "fmax"),
                                             ("hardware", "area_hw_build", "fmax_hw_build")):
            if area_key not in results:
                continue
            try:
                inputs = json.loads((directory / (prefix + "-inputs.json")).read_text())
                history = json.loads((directory / (prefix + "-sweep-history.json")).read_text())
                retained = history.get("retained_observation") or {}
                if not history.get("build_complete") or retained.get("input_signature") != inputs.get("signature"):
                    errors.append(prefix + ": incomplete/mismatched retained sweep observation")
                original_log = results[area_key].get("log")
                if not original_log or Path(original_log).name != Path(retained.get("log_path", "")).name:
                    errors.append(prefix + ": area and retained timing observation differ")
                entries = [entry for entry in inputs.get("inputs", [])
                           if entry.get("kind") == "xdc" and entry.get("name") == "clocks.xdc"]
                constraints = directory / (prefix + "-clocks.xdc")
                if len(entries) != 1 or hashlib.sha256(constraints.read_bytes()).hexdigest() != entries[0]["sha256"]:
                    errors.append(prefix + ": constraints differ from retained input manifest")
                log = directory / (prefix + "-vivado.log")
                text = log.read_text(errors="replace")
                if re.search(r"^ERROR:", text, re.MULTILINE) or "Exiting Vivado at" not in text:
                    errors.append(prefix + ": retained Vivado run has errors or is unfinished")
                area = parse_log(log)
                for field in _AREA_FIELDS:
                    if field in results[area_key] and results[area_key][field] != area.get(field):
                        errors.append(prefix + ": saved area differs from retained log: " + field)
                for main, record in history.get("mains", {}).items():
                    final = final_from_history(record.get("final") or {})
                    saved = results[timing_key].get("per_main", {}).get(main, {})
                    if not final.get("met") or cross_check_final(final, saved):
                        errors.append(prefix + ": saved timing differs from confirmed final: " + main)
            except (OSError, KeyError, ValueError) as exc:
                errors.append(prefix + ": incomplete archived evidence: " + str(exc))
    return {"measurement_dir": str(directory), "passed": not errors, "errors": errors,
            "archive_verified": manifest_path.exists()}


def save_evidence(measurement_dir, results):
    """Package retained observations, without one-off workflow-runner state."""
    directory = Path(measurement_dir)
    if measurement_errors(results):
        raise ValueError("Only accepted measurements can be packaged")
    sources = {}
    for prefix, area_key, timing_key in (("perf", "area", "fmax"),
                                         ("hardware", "area_hw_build", "fmax_hw_build")):
        if area_key not in results:
            continue
        area, timing = results[area_key], results[timing_key]
        log = Path(area["log"])
        input_path = log.with_suffix(".inputs.json")
        inputs = json.loads(input_path.read_text())
        entries = [entry for entry in inputs.get("inputs", [])
                   if entry.get("kind") == "xdc" and entry.get("name") == "clocks.xdc"]
        constraints = log.parent.parent / "clocks.xdc"
        if len(entries) != 1 or hashlib.sha256(constraints.read_bytes()).hexdigest() != entries[0]["sha256"]:
            raise ValueError(prefix + ": current constraints no longer match retained observation")
        sources.update({prefix + "-vivado.log": log, prefix + "-inputs.json": input_path,
                        prefix + "-sweep-history.json": Path(timing["source"]["sweep_history"]),
                        prefix + "-clocks.xdc": constraints})
        # A dirty checkout's revision alone cannot identify the design bytes.
        # Preserve the compiler's frozen design/include hashes when available;
        # historical outputs legitimately predate this manifest.
        provenance = log.parent.parent / "source_provenance.json"
        if provenance.is_file():
            sources[prefix + "-source-provenance.json"] = provenance
    for name, source in sources.items():
        destination = directory / name
        if source.resolve() != destination.resolve():
            shutil.copyfile(source, destination)
    artifacts = {}
    for path in sorted(directory.iterdir()):
        if path.is_file() and path.name != "artifact-manifest.json":
            artifacts[path.name] = {"original_path": str(sources.get(path.name, path)),
                                    "bytes": path.stat().st_size,
                                    "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    manifest = {"schema_version": 1, "archived_utc": datetime.datetime.now(
        datetime.timezone.utc).isoformat(), "artifacts": artifacts,
        "note": "Packaging retained evidence, not a new synthesis or simulation."}
    (directory / "artifact-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    report = check_record(directory)
    if not report["passed"]:
        raise ValueError("; ".join(report["errors"]))


def measurement_selftest():
    """Measurement guards/models/archive checks; no compiler or Vivado runs."""
    def concurrent_fixture(decrypt_period):
        phase = {"name": "b2b-1920", "packet_bytes": 1920, "num_packets": 16, "taps": {}}
        for direction, first, period in (("encrypt", 200, 100), ("decrypt", 320, decrypt_period)):
            phase[direction] = {"sustained_bytes_per_cycle": 1920 / period,
                                "packets": [{"last_out": first + i * period} for i in range(16)]}
            phase["taps"][direction + "/chacha20.to_pipeline"] = {"last_transfer_cycle": 1750}
        return {"config": {"target_mhz": 60, "dirs": ["encrypt", "decrypt"], "seed": 8439,
                           "sizes": [1920], "packets_per_size": 16}, "phases": [phase]}

    baseline = concurrent_fixture(130)
    improved = concurrent_fixture(102)
    if not compare_throughput(baseline, improved)["passed"]:
        raise ValueError("Throughput recovery comparison rejected passing full/overlap periods")
    if compare_throughput(baseline, concurrent_fixture(110))["passed"]:
        raise ValueError("Throughput recovery comparison accepted decrypt below parity threshold")
    slow_enc = copy.deepcopy(improved)
    slow_enc["phases"][0]["encrypt"]["sustained_bytes_per_cycle"] *= .97
    if compare_throughput(baseline, slow_enc)["passed"]:
        raise ValueError("Throughput recovery comparison accepted an encrypt regression")
    if area_selftest(HERE):
        return 1
    # Resolved credits and MCP selection must drive allocation, not a stale
    # starting guess or a requested depth mistaken for physical memory.
    sizing_config = {
        "poly1305": {"directions": {"decrypt": {
            "prologue_mcp_latency": 6, "shared_mcps": True,
        }}},
        "buffering": {"decrypt/auth_fifo": {
            "memory_depth_beats": 128,
            "sizing": {
                "method": "chacha-credit-bound-v1",
                "chacha20_core_latency": 17, "chacha20_max_in_flight_blocks": 22,
                "chacha20_block_beats": 4, "prologue_mcp_latency": 6,
                "shared_mcps": True, "max_aad_beats": 2,
                "terms_beats": {"pipeline_credits": 88, "widening_storage": 5,
                                "fork_copy_lead": 1, "fifo_startup": 2,
                                "framing_idle": 1, "prologue_service": 14,
                                "mac_transitions": 2, "aad_framing": 2},
                "required_beats": 115, "memory_depth_beats": 128,
            },
        }},
    }
    if auth_fifo_sizing_errors(sizing_config):
        raise ValueError("Valid automatic FIFO sizing rejected")
    for section, key, value in (
        ("buffer", "memory_depth_beats", 64),
        ("sizing", "chacha20_max_in_flight_blocks", 9),
        ("sizing", "prologue_mcp_latency", 1),
        ("sizing", "required_beats", 64),
        ("sizing", "shared_mcps", False),
        ("sizing", "memory_depth_beats", 64),
    ):
        changed = copy.deepcopy(sizing_config)
        buffer = changed["buffering"]["decrypt/auth_fifo"]
        target = buffer if section == "buffer" else buffer["sizing"]
        target[key] = value
        if not auth_fifo_sizing_errors(changed):
            raise ValueError("Sizing guard accepted stale " + key)
    directory = Path(HERE) / Path(_SELFTEST_CASES[0][0]).parent
    report = check_record(directory)
    if not report["passed"]:
        raise ValueError("; ".join(report["errors"]))
    original = json.loads((directory / "results.json").read_text())
    mutations = [
        ("functional", lambda r: r["checks"].update(functional_pass=False)),
        ("unfinished", lambda r: r["sim"].update(finalized=False)),
        ("build failure", lambda r: r["provenance"].update(build_returncode=7)),
        ("timing", lambda r: r["fmax"].update(timing_met=False)),
        ("missing area", lambda r: r["area"].update(available=False)),
        ("capacity", lambda r: r["area"].update(fits_device=False)),
        ("hardware timing", lambda r: r["fmax_hw_build"].update(timing_met=False)),
        ("missing hardware area", lambda r: r["area_hw_build"].update(available=False)),
        ("clock mismatch", lambda r: r["fmax"].update(target_mhz=80)),
        ("tap mismatch", lambda r: r["phases"][0].update(taps_check={"consistent": False})),
        ("lane mismatch", lambda r: r["config"]["poly1305"]["directions"]["encrypt"].update(accumulator_count=3)),
        ("II mismatch", lambda r: r["config"]["poly1305"]["directions"]["encrypt"].update(body_ii=2)),
        ("unfinished body", lambda r: r["phases"][0]["poly1305_lifecycle"]["encrypt"].update(body_retirements=0)),
        ("MCP audit", lambda r: r.update(mcp_hdl_audits={"perf": {"passed": False}})),
    ]
    for label, mutate in mutations:
        changed = copy.deepcopy(original)
        mutate(changed)
        if not measurement_errors(changed):
            raise ValueError("Guard accepted " + label)
    # Shared metadata/accounting guards must not be exercised only by private
    # historical records. Use a copy; never alter the archived measurement.
    shared = copy.deepcopy(original)
    shared["config"]["sharing"] = {"chacha20": True, "poly1305": True}
    shared["config"].update(source_handshake="converged", decrypt_verification_retained=True)
    directions = shared["config"]["poly1305"]["directions"]
    service = {"capacity_lanes": max(m["accumulator_count"] for m in directions.values())}
    for name in ("prologue", "epilogue"):
        key = name + "_mcp_latency"
        service[key] = directions["encrypt"][key]
        for meta in directions.values():
            meta["shared_mcps"] = True
            meta[key] = service[key]
    shared["config"]["poly1305"]["shared_mcps"] = service
    for phase in shared["phases"]:
        completed = sum(life["completed_packets"] for life in phase["poly1305_lifecycle"].values())
        phase["poly1305_shared_services"] = {
            name: {"launches": completed, "responses": completed}
            for name in ("prologue", "epilogue")
        }
    if measurement_errors(shared):
        raise ValueError("Valid shared metadata rejected: " + repr(measurement_errors(shared)))
    for label, mutate in (
        ("shared capacity", lambda r: r["config"]["poly1305"]["shared_mcps"].update(capacity_lanes=99)),
        ("shared latency", lambda r: r["config"]["poly1305"]["shared_mcps"].update(epilogue_mcp_latency=99)),
        ("shared owner", lambda r: r["config"]["poly1305"]["directions"]["decrypt"].update(shared_mcps=False)),
        ("shared accounting", lambda r: r["phases"][0]["poly1305_shared_services"]["epilogue"].update(responses=0)),
        ("source handshake", lambda r: r["config"].update(source_handshake="early")),
        ("verification output", lambda r: r["config"].update(decrypt_verification_retained=False)),
        ("source bytes", lambda r: r["phases"][0]["encrypt"].update(in_payload_bytes=0)),
        ("output bytes", lambda r: r["phases"][0]["encrypt"].update(out_payload_bytes=0)),
    ):
        changed = copy.deepcopy(shared)
        mutate(changed)
        if not measurement_errors(changed):
            raise ValueError("Guard accepted " + label)
    # Metadata-free records must retain the historical model and saved provenance.
    for label in ("shared-80mhz", "shared-80mhz-probed"):
        historical = Path(HERE) / "measurements" / label
        if not check_record(historical)["passed"]:
            raise ValueError("Historical record rejected: " + label)
    if bottleneck.model_for(1420, 29, None)["poly1305_body_ii"] != 6:
        raise ValueError("Historical six-cycle fallback changed")
    meta = original["config"]["poly1305"]["directions"]["encrypt"]
    if bottleneck.model_for(1420, 29, None, mac_config=meta)["poly1305_body_ii"] != 1:
        raise ValueError("Pipelined II model changed")
    with tempfile.TemporaryDirectory(prefix="wg-measure-check-") as scratch:
        scratch = Path(scratch)
        # Confirmation overrides provisional standalone checks. Support both
        # compiler print formats, including a final FAIL (never mask it).
        stdout = scratch / "confirmation.log"
        for qualifier in ("", "; worst reported path"):
            for verdict in ("PASS", "FAIL"):
                stdout.write_text(
                    "[sweep] example synthesized as written (standalone check): "
                    "34.34 MHz vs 60.00 MHz goal - FAIL\n"
                    f"{verdict} example: 69.42 MHz vs 60.00 MHz goal{qualifier} "
                    "(confirmation run)\n"
                )
                final = parse_stdout(str(stdout))["final"]["example"]
                expected = {"met": verdict == "PASS", "achieved_mhz": 69.42,
                            "standalone_mhz": 34.34}
                if final.get("outcome") != "confirmation run" or cross_check_final(expected, final):
                    raise ValueError("Confirmation stdout parsing changed: " + repr(final))
        # Cache seeding can carry logs from another named hardware top,
        # without importing that top's HDL/history into the current build.
        mixed = scratch / "mixed-cache"
        active, cached = mixed / "top", mixed / "other_hardware"
        active.mkdir(parents=True)
        cached.mkdir()
        (active / "sweep_history.json").write_text("{}")
        (cached / "vivado_abcd_1234.log").write_text("cache fixture")
        if find_top_dir(str(mixed)) != str(active):
            raise ValueError("Copied top logs were mistaken for an active build")
        # Real second builds must still be rejected, with either final HDL
        # or a sweep history claiming that output directory.
        for artifact in ("other_hardware.vhd", "sweep_history.json"):
            path = cached / artifact
            path.write_text("fixture")
            try:
                find_top_dir(str(mixed))
            except ValueError:
                pass
            else:
                raise ValueError("Ambiguous active tops accepted: " + artifact)
            path.unlink()
        (active / "sweep_history.json").unlink()
        if find_top_dir(str(mixed)) != str(cached):
            raise ValueError("Historical log-only top discovery changed")
        # Mutate only copies. Refreshing the outer inventory must not conceal
        # a bad retained input signature or stale production constraints.
        archived = scratch / "archive"
        shutil.copytree(directory, archived)
        for name in ("perf-clocks.xdc", "perf-inputs.json", "perf-sweep-history.json"):
            path = archived / name
            if name.endswith(".xdc"):
                path.write_bytes(path.read_bytes() + b"\n# stale constraint test\n")
            else:
                changed = json.loads(path.read_text())
                if name.endswith("inputs.json"):
                    changed["signature"] = "bad signature"
                else:
                    changed["build_complete"] = False
                path.write_text(json.dumps(changed))
            inventory = json.loads((directory / "artifact-manifest.json").read_text())
            inventory["artifacts"][name].update(
                bytes=path.stat().st_size, sha256=hashlib.sha256(path.read_bytes()).hexdigest())
            (archived / "artifact-manifest.json").write_text(json.dumps(inventory))
            if check_record(archived)["passed"]:
                raise ValueError("Archive guard accepted stale " + name)
            shutil.copyfile(directory / name, path)
        saved = copy.deepcopy(original)
        saved["config"]["out_dir"] = str(scratch / "deleted-cache")
        (scratch / "results.json").write_text(json.dumps(saved))
        shutil.copyfile(directory / "perf_raw.json", scratch / "perf_raw.json")
        shutil.copyfile(directory / "pypelinec.log", scratch / "pypelinec.log")
        proc = subprocess.run([sys.executable, str(Path(HERE) / "measure.py"),
                               "--label", str(scratch), "--parse-only", "--no-per-module-area"],
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        if proc.returncode:
            raise ValueError("Cache-free parse-only failed: " + proc.stdout[-2000:])
        parsed = json.loads((scratch / "results.json").read_text())
        for key in ("provenance", "fmax", "area", "fmax_hw_build", "area_hw_build"):
            if parsed.get(key) != saved.get(key):
                raise ValueError("Cache-free parse-only replaced saved " + key)
    print("measurement selftest: PASS (guards, models, saved provenance, archive integrity)")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--label", default=None, help="measurement name (dir under measurements/)")
    ap.add_argument("--shared", action="store_true", help="Share both resources (default)")
    add_sharing_arguments(ap)
    ap.add_argument("--poly1305", choices=IMPLEMENTATIONS, default=None,
                    help="MAC architecture (default pipelined)")
    ap.add_argument("--target-mhz", type=int, choices=TARGETS_MHZ, default=None,
                    help="Clock goal (default: sharing-both 60 MHz, other pipelined 30 MHz, legacy 80 MHz)")
    ap.add_argument("-j", "--jobs", type=int, default=None,
                    help="Maximum simultaneous synthesis jobs (use 1 on low-RAM systems)")
    ap.add_argument("--comb", action="store_true", help="combinational build: fast rig check, no Vivado, no area/fmax")
    ap.add_argument("--reuse-syn", action="store_true", help="keep the out_dir so pypelinec re-reads its cached Vivado logs (sim-only re-measure)")
    ap.add_argument("--out-dir", help="Explicit performance build cache (same rules as build.py --out-dir)")
    ap.add_argument("--parse-only", action="store_true", help="run nothing; re-merge an existing run's perf JSON + build log")
    ap.add_argument("--area-from-dir", default=None, help="also parse DUT-only area from another build's out_dir (e.g. generated-files/verilog-shared)")
    ap.add_argument("--no-per-module-area", action="store_true", help="skip per-module out-of-context area parsing")
    ap.add_argument("--sizes", default=None, help="comma-separated packet sizes (default: see perf_tb_common.py)")
    ap.add_argument("--packets", type=int, default=None, help="back-to-back packets per size")
    ap.add_argument("--peak-bytes", type=int, default=None, help="single long packet size for the peak phase (0 disables)")
    ap.add_argument("--dirs", default=None, choices=("both", "enc", "dec"), help="which directions to stream")
    ap.add_argument("--taps", default="all", help="internal taps to enable: 'all' (default), a block or direction prefix ('poly1305', 'encrypt'), or exact names; pass --taps '' to measure boundaries only (see PipelineC stream/stream_perf_probe.py)")
    ap.add_argument("--seed", type=int, default=None, help="packet payload RNG seed")
    ap.add_argument("--update-readme", action="store_true", help="splice the results table into README.md between its MEASURED-RESULTS markers")
    inspection = ap.add_mutually_exclusive_group()
    inspection.add_argument("--check-record", metavar="DIRECTORY", help="read-only acceptance/archive-integrity check; never reformat original results")
    inspection.add_argument("--audit-mcps", metavar="OUT_DIR", help="read-only recursive audit of emitted Poly1305 MCP arithmetic")
    inspection.add_argument("--area-report", metavar="LOG_OR_OUT_DIR", help="print Vivado utilization without building or measuring")
    inspection.add_argument("--selftest", action="store_true", help="check measurement guards, models, saved provenance and retained evidence; no synthesis")
    ap.add_argument("--audit-directions", choices=("encrypt", "decrypt", "encrypt,decrypt"), default="encrypt,decrypt")
    ap.add_argument("--per-module", action="store_true", help="include OOC modules in --area-report")
    ap.add_argument("--json", action="store_true", help="JSON output for --area-report")
    ap.add_argument("--save-evidence", action="store_true", help="package retained Vivado/input/sweep/constraint evidence and checksums with an accepted measurement")
    args = ap.parse_args()
    try:
        if args.selftest:
            return measurement_selftest()
        if args.check_record or args.audit_mcps:
            report = (check_record(args.check_record) if args.check_record else
                      audit_poly1305_hdl(generated_out_dir(args.audit_mcps), tuple(args.audit_directions.split(","))))
            print(json.dumps(report, indent=2))
            return 0 if report["passed"] else 1
        if args.area_report:
            if os.path.isdir(args.area_report):
                report = parse_out_dir(generated_out_dir(args.area_report), per_module=args.per_module)
                if args.json:
                    print(json.dumps(report, indent=2))
                else:
                    print(format_area(report["top"]) if report["top"] else "no top-level log found")
                    for name, module in sorted(report["per_module"].items()):
                        print(name + ": " + format_area(module))
            else:
                report = parse_log(args.area_report)
                print(json.dumps(report, indent=2) if args.json else format_area(report))
            return 0
    except (OSError, ValueError, KeyError) as exc:
        print("ERROR: " + str(exc), file=sys.stderr)
        return 1
    if args.save_evidence and args.comb:
        ap.error("--save-evidence requires synthesized timing/area evidence")
    if args.jobs is not None and args.jobs < 1:
        ap.error("--jobs must be at least 1")
    try:
        args.poly1305 = selected_implementation(args.poly1305)
        # A saved record supplies its own architecture; do not reject an old
        # legacy record using today's default sharing-both selection.
        args.sharing = None if args.parse_only else sharing_from_args(args)
    except ValueError as exc:
        ap.error(str(exc))
    if args.target_mhz is None:
        # Parse-only has no current sharing selection: old metadata will
        # supply its clock.
        args.target_mhz = default_target_mhz(args.poly1305, args.sharing if args.sharing is not None
                                           else {"chacha20": True, "poly1305": False})

    label = args.label or (("comb-smoke" + (f"-{args.target_mhz}mhz" if args.target_mhz != 80 else "")
                           if args.comb else f"shared-{args.target_mhz}mhz")
                           + "-poly1305-" + args.poly1305
                           + ("-share-" + sharing_name(args.sharing) if args.sharing is not None else ""))
    meas_dir = os.path.join(HERE, "measurements", label)
    os.makedirs(meas_dir, exist_ok=True)
    json_path = os.path.join(meas_dir, "perf_raw.json")
    log_path = os.path.join(meas_dir, "pypelinec.log")
    out_dir = out_dir_for(args.comb, args.poly1305, args.target_mhz, args.sharing)
    if args.out_dir:
        out_dir = os.path.abspath(args.out_dir)

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

    # Historical records predate the selector and used unsuffixed output dirs.
    # For parse-only runs the recorded design, not today's default, wins.
    mac_config = perf_raw.get("config", {}).get("poly1305")
    previous = {}
    if args.parse_only:
        previous_path = os.path.join(meas_dir, "results.json")
        if os.path.exists(previous_path):
            with open(previous_path) as f:
                previous = json.load(f)
            args.comb = previous.get("config", {}).get("comb", args.comb)
        if mac_config:
            args.poly1305 = mac_config["implementation"]
            recorded_sharing = perf_raw.get("config", {}).get("sharing")
            args.target_mhz = (previous.get("config", {}).get("target_mhz")
                               or perf_raw.get("config", {}).get("target_mhz")
                               or default_target_mhz(args.poly1305, recorded_sharing if recorded_sharing is not None
                                                     else {"chacha20": True, "poly1305": False}))
            out_dir = out_dir_for(args.comb, args.poly1305, args.target_mhz, recorded_sharing)
        else:
            args.poly1305 = "legacy"
            args.target_mhz = 80
            out_dir = os.path.join(HERE, GENERATED_FILES, f"perf-{'comb' if args.comb else 'pipe'}-shared-native")
        recorded_dir = previous.get("config", {}).get("out_dir")
        if recorded_dir:
            out_dir = generated_out_dir(os.path.join(HERE, recorded_dir))
        args.sharing = perf_raw.get("config", {}).get("sharing", {"chacha20": True, "poly1305": False})

    stdout_info = parse_stdout(log_path)
    fmax = parse_fmax(out_dir, stdout_info)
    area = parse_area(out_dir, per_module=not args.no_per_module_area)
    # Committed records remain reformatable after local synthesis caches are
    # removed. Never replace their accepted evidence with "unavailable".
    if args.parse_only and previous:
        if not os.path.isdir(out_dir):
            fmax = previous.get("fmax", fmax)
            area = previous.get("area", area)
    target_mhz = fmax.get("target_mhz") or args.target_mhz
    phases = derive_throughput(perf_raw, fmax.get("design_mhz"), target_mhz)
    # Internal taps -> per-block throughput/ceiling, a bottleneck verdict and the
    # model cross-check. A run with no taps leaves the phases untouched.
    aad_len = perf_raw.get("config", {}).get("aad_len") or 0
    bottleneck.analyze(phases, aad_len=aad_len, mac_config=mac_config)

    results = {
        "schema_version": 1,
        "label": label,
        "generated_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds"),
        "config": dict(
            perf_raw.get("config", {}),
            comb=args.comb,
            poly1305_impl=args.poly1305,
            sharing=args.sharing,
            out_dir=os.path.relpath(out_dir, HERE),
            target_mhz=target_mhz,
            requested_target_mhz=(previous.get("config", {}).get("requested_target_mhz")
                                  if args.parse_only else args.target_mhz),
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
    # Reformatting a saved run must not replace its build provenance with the
    # checkout doing the formatting, or silently drop its DUT-only area.
    if args.parse_only and previous:
        results["provenance"] = previous.get("provenance", results["provenance"])
        for key in ("build_cmd", "reuse_syn"):
            if key in previous.get("config", {}):
                results["config"][key] = previous["config"][key]
        if "area_hw_build" in previous:
            results["area_hw_build"] = previous["area_hw_build"]
        if "fmax_hw_build" in previous:
            results["fmax_hw_build"] = previous["fmax_hw_build"]
    if args.area_from_dir:
        hardware_out_dir = generated_out_dir(os.path.join(HERE, args.area_from_dir))
        results["area_hw_build"] = parse_area(
            hardware_out_dir,
            per_module=not args.no_per_module_area,
        )
        results["area_hw_build"]["scope"] = "hardware_top"
        results["area_hw_build"]["constant_key_folding"] = False
        results["area_hw_build"]["out_dir"] = os.path.relpath(hardware_out_dir, HERE)
        # The hardware build's schema-2 final records are authoritative, even
        # when its console log was saved outside the generated directory.
        results["fmax_hw_build"] = parse_fmax(
            hardware_out_dir, parse_stdout(os.path.join(hardware_out_dir, "pypelinec.log"))
        )

    if not args.parse_only and not args.comb and args.poly1305 == "pipelined":
        results["mcp_hdl_audits"] = {}
        for scope, directory in (("perf", out_dir), ("hardware", args.area_from_dir)):
            if directory is None:
                continue
            try:
                audit = audit_poly1305_hdl(os.path.join(HERE, directory), shared=args.sharing["poly1305"])
            except (OSError, ValueError) as exc:
                audit = {"passed": False, "errors": [str(exc)]}
            results["mcp_hdl_audits"][scope] = audit
    elif args.parse_only and "mcp_hdl_audits" in previous:
        results["mcp_hdl_audits"] = previous["mcp_hdl_audits"]
    errors = measurement_errors(results)
    results["validation"] = {"passed": not errors, "errors": errors}
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
    # Keep the README at top-level QoR; component detail stays in blocks.md.
    block_summary = (
        "Detailed per-block service/stall, shared arbitration and lifecycle measurements\n"
        f"are in the [block report]({os.path.relpath(blocks_path, HERE)})."
        if block_table else "No internal taps were recorded for this run."
    )

    if args.save_evidence and not errors:
        try:
            save_evidence(meas_dir, results)
        except (OSError, ValueError, KeyError) as exc:
            errors.append("Evidence packaging failed: " + str(exc))
            results["validation"] = {"passed": False, "errors": errors}
            with open(results_path, "w") as destination:
                json.dump(results, destination, indent=1)
    run_returncode = results["provenance"].get("build_returncode") or 0
    measurement_ok = not errors
    if args.update_readme and measurement_ok:
        update_readme(markdown_table(results, include_mac_details=False), results, block_summary)
    elif args.update_readme:
        print("!! Incomplete or failing measurement; README results not replaced", file=sys.stderr)

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
            "the design's stream_perf_probe call sites",
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
    for error in errors:
        print(f"!! {error}", file=sys.stderr)
    return run_returncode or (1 if errors else 0)


if __name__ == "__main__":
    sys.exit(main())
