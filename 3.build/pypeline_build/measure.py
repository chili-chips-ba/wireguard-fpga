#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""QoR measurement orchestrator: one command that produces a complete, diffable
(fmax, area, throughput, latency) record for a design variant.

What it does:
  1. runs `./build.py <profile>` -- the real top (src/chacha20poly1305.py, real
     ports) autopipelined for the selected clock goal through Vivado. Only a top
     with real ports gives trustworthy timing: the testbench's constant stimulus
     lets synthesis remove logic, and a sweep that trusts that timing builds
     wrong hardware. Matching existing hardware is reused automatically;
     --reuse-syn requires replay and --rebuild requests a hardware build;
  2. runs `./build.py --perf <profile>` -- the native simulation of the perf
     testbench on exactly that built hardware (its latencies modeled, no
     elaboration or synthesis), with the phase plan passed in as -D PERF_*
     design parameters;
  3. reads fmax + pipeline depth from pypelinec's OWN numbers -- the per-MAIN
     "final" records in the hardware build's sweep_history.json (schemas 2/3),
     with that build's stdout outcome lines as cross-check -- timing parsing is
     not reimplemented here; and area from that build's Vivado log using the
     utilization parser below (not pypelinec's diagnostic-only one);
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
  ./measure.py --label throughput-check     # published profile; reuse matching hardware
  ./measure.py --share-chacha20 --poly1305 legacy # historical architecture, 80 MHz goal
  ./measure.py --label X --reuse-syn         # sim only, on the existing hardware build
  ./measure.py --label smoke --comb          # fast rig check, no Vivado at all
  ./measure.py --label X --parse-only        # re-merge an existing run's outputs
  ./measure.py --label X --sizes 1420,1920 --packets 4
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
    IMPLEMENTATIONS, implementation_out_dir,
    selected_target, default_target_mhz, target_out_dir, GENERATED_FILES, generated_out_dir,
    MULT_IMPLEMENTATIONS, mult_out_dir,
    DATA_BITWIDTHS, blocks_out_dir,
    COMPUTE_IMPLEMENTATIONS, compute_out_dir,
    selected_prologue_cap, selected_epilogue_cap, prologue_cap_out_dir, epilogue_cap_out_dir,
    profile_from_args, resolve_profile, hardware_out_dir, BUILT_HARDWARE_FILE,
    add_sharing_arguments, sharing_from_args, sharing_name, sharing_out_dir,
    DEFAULT_BUILD, DEFAULT_PROFILE,
)
from build_state import select_build_state, hardware_reuse_error, publish_default, profile_from_record, selftest as build_state_selftest
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


def correct_frozen_compiler_revision(provenance, log_path):
    """Repair one known provenance artifact in place, keeping the recorded value.

    Before compiler_revision existed, a frozen snapshot inside this repository was
    recorded with WireGuard's own commit as its PipelineC revision. A PipelineC revision
    equal to the record's wireguard-fpga revision can only be that artifact, so it is
    recomputed from the compiler path the build log itself names."""
    recorded = provenance.get("pipelinec_git")
    if not recorded or recorded != provenance.get("wireguard_fpga_git"):
        return
    try:
        with open(log_path) as f:
            head = "".join(f.readline() for _ in range(20))
    except OSError:
        return
    match = re.search(r"Command: (\S+)/src/pypelinec\b", head)
    if match:
        fixed = compiler_revision(match.group(1))
        if fixed and fixed != recorded:
            provenance["pipelinec_git_recorded"] = recorded
            provenance["pipelinec_git"] = fixed


def compiler_revision(repo):
    """The PipelineC revision a build used.

    A frozen snapshot (<snap>/compiler beside <snap>/compiler-snapshot.json) is not a git
    checkout of its own; inside this repository, git would answer with WireGuard's commit.
    Report the snapshot's recorded base and source-tree hash instead."""
    snapshot = Path(repo).parent / "compiler-snapshot.json"
    if snapshot.is_file():
        manifest = json.loads(snapshot.read_text())
        return f"{manifest['base_revision']}-frozen-{manifest['src_tree_sha256'][:12]}"
    try:
        top = subprocess.run(["git", "-C", repo, "rev-parse", "--show-toplevel"],
                             capture_output=True, text=True, check=True).stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None
    if os.path.realpath(top) != os.path.realpath(repo):
        return None
    return git_describe(repo)


def historical_target_mhz(implementation, sharing=None):
    """Clock fallback for saved records created before the multiplier selector."""
    if (implementation == "pipelined" and sharing is not None
            and sharing["chacha20"] and sharing["poly1305"]):
        return 60
    return 80 if implementation == "legacy" else 30


def out_dir_for(comb, implementation, target_mhz=None, sharing=None, multiplier=None, compute=None, blocks=1):
    if target_mhz is None:
        # Records without sharing metadata predate the sharing-both default.
        target_mhz = (historical_target_mhz(implementation, sharing) if multiplier is None
                      else default_target_mhz(implementation, sharing))
    base = os.path.join(
        HERE, GENERATED_FILES, f"perf-{'comb' if comb else 'pipe'}-shared-native"
    )
    base = implementation_out_dir(base, implementation)
    # None means a historical record, whose directory predates sharing flags.
    if sharing is not None:
        base = sharing_out_dir(base, sharing)
    return blocks_out_dir(target_out_dir(compute_out_dir(mult_out_dir(base, multiplier), compute), target_mhz), blocks)


def build_mult_impl(out_dir):
    """Read the compiler's actual selection, including pre-selector inferred builds."""
    path = Path(out_dir) / "source_provenance.json"
    if not path.is_file():
        return None
    provenance = json.loads(path.read_text())
    params = {entry["name"]: entry["value"] for entry in provenance.get("design_params", [])}
    return params.get("POLY1305_MULT_IMPL", "inferred")


def build_compute_impl(out_dir):
    """Read the emitted selection; records before this selector used MCPs."""
    path = Path(out_dir) / "source_provenance.json"
    if not path.is_file():
        return None
    params = {entry["name"]: entry["value"]
              for entry in json.loads(path.read_text()).get("design_params", [])}
    return params.get("POLY1305_COMPUTE_IMPL", "mcp")


def build_prologue_cap(out_dir):
    """The emitted prologue AUTO_FSM cap; records before this parameter used 64."""
    path = Path(out_dir) / "source_provenance.json"
    if not path.is_file():
        return None
    params = {entry["name"]: entry["value"]
              for entry in json.loads(path.read_text()).get("design_params", [])}
    value = params.get("POLY1305_PROLOGUE_MAX_LATENCY", 64)
    return selected_prologue_cap(value, emitted_cap_width(params))


def emitted_cap_width(params):
    """Resolve width for direct compiler runs using the deprecated block flag."""
    width = params.get("DATA_BITWIDTH")
    if width is None and params.get("POLY1305_BLOCKS_PER_CYCLE") is not None:
        width = 128 * params["POLY1305_BLOCKS_PER_CYCLE"]
    if width is None and params.get("POLY1305_IMPL") == "legacy":
        width = 128
    return width


def build_epilogue_cap(out_dir):
    """Historical epilogues were capped at 64 before this parameter existed."""
    path = Path(out_dir) / "source_provenance.json"
    if not path.is_file():
        return None
    params = {entry["name"]: entry["value"]
              for entry in json.loads(path.read_text()).get("design_params", [])}
    value = params.get("POLY1305_EPILOGUE_MAX_LATENCY", 64)
    return selected_epilogue_cap(value, emitted_cap_width(params))


def build_blocks_per_cycle(out_dir):
    path = Path(out_dir) / "source_provenance.json"
    if not path.is_file():
        return None
    params = {entry["name"]: entry["value"]
              for entry in json.loads(path.read_text()).get("design_params", [])}
    return recorded_data_bitwidth({
        "data_bitwidth": params.get("DATA_BITWIDTH"),
        "poly1305_blocks_per_cycle": params.get("POLY1305_BLOCKS_PER_CYCLE") or 1,
    }) // 128


def recorded_data_bitwidth(config):
    """Resolve both current width records and historical block-rate records."""
    width = config.get("data_bitwidth")
    return width if width is not None else 128 * config.get("poly1305_blocks_per_cycle", 1)


def _profile_flags(args):
    """build.py flags selecting this measurement's profile and output directory."""
    flags = ["--poly1305", args.poly1305, "--target-mhz", str(args.target_mhz),
             "--poly1305-mult", args.poly1305_mult,
             "--poly1305-compute", args.poly1305_compute,
             "--poly1305-prologue-cap", str(args.poly1305_prologue_cap),
             "--poly1305-epilogue-cap", str(args.poly1305_epilogue_cap),
             "--data-bitwidth", str(args.data_bitwidth)]
    for name in ("chacha20", "poly1305"):
        if args.sharing[name]:
            flags.append("--share-" + name)
    if not (args.sharing["chacha20"] or args.sharing["poly1305"]):
        flags.append("--share-none")
    if args.jobs is not None:
        flags.extend(["-j", str(args.jobs)])
    if args.out_dir:
        flags.extend(["--out-dir", args.out_dir])
    if args.syn_cache is not None:
        flags.extend(["--syn-cache", args.syn_cache])
    return flags


def _run_build_py(cmd, log_path):
    """Run build.py, teeing its (very chatty) stdout to log_path.

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
    print(f"--> {' '.join(cmd)}")
    print(f"--> log: {log_path}")
    # Pin the PipelineC revision NOW, not after the run: a sweep takes hours and
    # that checkout may be under active development in the meantime, so a SHA
    # read at merge time can name a revision this build never used.
    pipelinec_git = compiler_revision(
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
        "log": os.path.relpath(log_path, HERE),
    }


def run_hardware_build(args, log_path):
    """Build the real top (build.py without --sim): the source of fmax, area and
    every latency the performance simulation then simulates."""
    cmd = [os.path.join(HERE, "build.py")] + _profile_flags(args)
    output = args.out_dir or os.path.join(HERE, hardware_out_dir(
        'shared', args.poly1305, args.sharing, args.poly1305_mult, args.poly1305_compute,
        args.target_mhz, args.data_bitwidth, args.poly1305_prologue_cap, args.poly1305_epilogue_cap))
    if os.path.isfile(os.path.join(output, BUILT_HARDWARE_FILE)):
        cmd.append('--continue')
    for hints in args.latency_hints:
        cmd.extend(["--latency-hints", hints])
    if args.pipeline_min_effort is not None:
        cmd.extend(["--pipeline-min-effort", str(args.pipeline_min_effort)])
    return _run_build_py(cmd, log_path)


def run_build(args, json_path, log_path):
    """Run build.py --perf: the native simulation of the built hardware (with
    --comb, the zero-latency rig check, which builds nothing)."""
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
    cmd = [os.path.join(HERE, "build.py"), "--perf"] + _profile_flags(args)
    for define in defines:
        cmd.extend(["-D", define])
    if args.comb:
        cmd.append("--comb")
    return _run_build_py(cmd, log_path)


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


def parse_area(out_dir, per_module=True, scope="hardware_top"):
    """Area from a build's top-level Vivado log. scope "hardware_top": the real top
    (external ports); "perf_tb_top": a historical synthesized perf testbench, whose
    constant key/nonce/aad let Vivado fold logic away."""
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
    area["scope"] = scope
    area["constant_key_folding"] = scope == "perf_tb_top"
    area["per_module"] = parsed["per_module"]
    return area


DIRECTIONS = bottleneck.DIRECTIONS


def derive_throughput(perf_raw, fmax_mhz, target_mhz, steady_trim=0):
    """Add MHz-dependent columns to the testbench's cycle-domain numbers."""
    phases = perf_report.derive_throughput(perf_raw, fmax_mhz, target_mhz, perf_raw.get("config", {}).get("bus_bytes", BUS_BYTES), DIRECTIONS)
    if steady_trim:
        for phase in phases:
            for direction in DIRECTIONS:
                stats = phase.get(direction)
                if not stats:
                    continue
                steady = steady_packet_window(stats.get("packets", []), phase["packet_bytes"], steady_trim)
                stats["steady_state"] = steady
                if not steady["available"]:
                    continue
                for key in ("packet_period_cycles", "sustained_bytes_per_cycle", "throughput_bytes_per_cycle",
                            "throughput_basis", "line_rate_frac", "gbps_at_fmax", "gbps_at_target"):
                    stats["burst_" + key] = stats.get(key)
                rate = steady["bytes_per_cycle"]
                stats.update(packet_period_cycles=steady["packet_period_cycles"],
                             sustained_bytes_per_cycle=rate, throughput_bytes_per_cycle=rate,
                             throughput_basis="packet completions, warm-up/drain excluded",
                             line_rate_frac=rate / perf_raw.get("config", {}).get("bus_bytes", BUS_BYTES),
                             gbps_at_fmax=rate * fmax_mhz * .008 if fmax_mhz else None,
                             gbps_at_target=rate * target_mhz * .008 if target_mhz else None)
    return phases


def steady_packet_window(packets, packet_bytes, trim=8):
    """Payload rate between interior completions; do not count fill or drain."""
    selected = packets[trim:-trim] if trim else packets
    result = {"available": False, "trim_packets": trim, "total_packets": len(packets)}
    if len(selected) < 3:
        return result
    periods = [b["last_out"] - a["last_out"] for a, b in zip(selected, selected[1:])]
    if any(p <= 0 for p in periods):
        return result
    split = len(periods) // 2
    first = sum(periods[:split]) / split
    second = sum(periods[split:]) / (len(periods) - split)
    period = sum(periods) / len(periods)
    stability = min(first, second) / max(first, second)
    result.update(available=True, first_packet=selected[0]["idx"], last_packet=selected[-1]["idx"],
                  first_cycle=selected[0]["last_out"], last_cycle=selected[-1]["last_out"],
                  intervals=len(periods), packet_period_cycles=period, bytes_per_cycle=packet_bytes / period,
                  first_half_period_cycles=first, second_half_period_cycles=second,
                  stability_ratio=stability, stable=stability >= .99)
    return result


def throughput_parity_errors(results):
    """Near-max decision gate; small-packet curves are collected afterward."""
    if not results.get("config", {}).get("require_throughput_parity"):
        return []
    errors = []
    config = results["config"]
    if config.get("dirs") != list(DIRECTIONS):
        errors.append("Throughput parity requires both directions")
    trim = config.get("steady_trim_packets", 0)
    seen = set()
    for phase in results.get("phases", []):
        if phase["packet_bytes"] < 1420:
            continue
        seen.add(phase["packet_bytes"])
        rates = []
        for direction in DIRECTIONS:
            stats = phase.get(direction, {})
            packets = stats.get("packets", [])
            selected = packets[trim:-trim] if trim else packets
            label = phase["name"] + "/" + direction
            window = steady_packet_window(packets, phase["packet_bytes"], trim)
            if len(selected) < 4 or not window["available"]:
                errors.append(label + ": parity requires at least four completed packets in the measurement window")
                continue
            periods = [b["last_out"] - a["last_out"] for a, b in zip(selected, selected[1:])]
            if min(periods) / max(periods) < .95:
                errors.append(label + ": completion intervals vary by more than 5%; extend run")
            rate = window["bytes_per_cycle"]
            rates.append(rate)
            if (any(abs(stats.get(key, 0) - rate) > 1e-9 for key in
                    ("throughput_bytes_per_cycle", "sustained_bytes_per_cycle"))
                    or abs(stats.get("gbps_at_target", 0) - rate * config.get("target_mhz", 0) * .008) > 1e-9):
                errors.append(label + ": headline rate disagrees with packet completions")
            if phase["packet_bytes"] == 1420 and rate * config.get("target_mhz", 0) * .008 < 17.986666666666668:
                errors.append(label + ": throughput below 17.986667 Gb/s")
        if len(rates) == 2 and min(rates) / max(rates) < .95:
            errors.append(phase["name"] + ": encrypt/decrypt throughput differs by more than 5%")
    if not {1420, 1920} <= seen:
        errors.append("Throughput parity requires 1420- and 1920-byte decision phases")
    return errors


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
    lines.append("Packet datapath: `" + str(recorded_data_bitwidth(results["config"])) + "` bits; Poly1305 blocks/cycle: `" + str(results["config"].get("poly1305_blocks_per_cycle", 1)) + "`.")
    lines.append("Poly1305 multiplier: `" + results["config"].get("poly1305_mult_impl", "inferred") + "`.")
    if results["config"].get("poly1305_impl") == "pipelined":
        lines.append("Poly1305 prologue/epilogue: `" + results["config"].get("poly1305_compute_impl", "mcp") + "`.")
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
        elif sizing.get("method") == "poly1305-overlap-fork-v2":
            terms = ", ".join(f"{key}={value}" for key, value in sizing["terms_beats"].items())
            lines.append(f"Automatic overlap sizing: {sizing['required_beats']} required beats "
                         f"({terms}); memory rounded to a power of two.")
        elif sizing.get("method") == "plaintext-verdict-credit-bound-v1":
            terms = ", ".join(f"{key}={value}" for key, value in sizing["terms_beats"].items())
            lines.append(f"Automatic verification sizing: {sizing['required_beats']} required beats "
                         f"({terms}); memory rounded to a power of two.")
    for name, stream_slice in sorted(results.get("config", {}).get("stream_slices", {}).items()):
        lines.append(f"Register slice `{name}`: mode `{stream_slice['mode']}`, "
                     f"{stream_slice['capacity_beats']} slots, "
                     f"{stream_slice['latency_cycles']} unstalled cycle(s), II=1.")
    if mac:
        lines.append(f"Poly1305 implementation: `{mac['implementation']}`.")
        service = mac.get("shared_mcps")
        if service and include_mac_details:
            lines.append(
                f"Shared compute capacity={service['capacity_lanes']} lanes; "
                f"prologue compute={service['prologue_mcp_latency']} cycles, "
                f"epilogue compute={service['epilogue_mcp_latency']} cycles. "
                "Each response adds one handshake cycle; arbitration waits are measured separately."
            )
        for direction, timing in (sorted(mac.get("directions", {}).items()) if include_mac_details else []):
            details = (f"{direction}: body II={timing['body_ii']}, "
                       f"accumulators={timing['accumulator_count']}")
            if "body_latency" in timing:
                if timing.get("blocks_per_cycle", 1) == 2:
                    details += (
                        f", coefficient response={timing['coefficient_latency']} cycles"
                        f", feedback response={timing['body_latency']} cycles"
                        f", total body response={timing['total_body_latency']} cycles"
                    )
                else:
                    details += f", body response={timing['body_latency']} cycles"
                details += (
                    f", prologue response={timing['prologue_response_cycles']} cycles"
                    f", epilogue response={timing['epilogue_response_cycles']} cycles"
                )
            lines.append(details + ".")
            if timing.get("packet_architecture") == "overlapped":
                capacities = ", ".join(f"{name.rsplit('.', 1)[-1]}={capacity}"
                                       for name, capacity in timing["packet_buffers"].items())
                lines.append(f"{direction}: independent packet stages ({capacities}); "
                             "stage costs overlap.")
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
        raise ValueError(f"{path} has no {README_BEGIN} / {README_END} markers; not publishing")
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
    publish_default(HERE, results)
    with open(path, "w") as f:
        f.write(text)


ENTITY = re.compile(r"^\s*entity\s+(\w+)\s+is\b", re.MULTILINE | re.IGNORECASE)
CHILD = re.compile(r":\s*entity\s+work\.(\w+)", re.IGNORECASE)
LATENCY = re.compile(r"ADDED_PIPELINE_LATENCY\s*:\s*integer\s*:=\s*(\d+)", re.IGNORECASE)
# The prologue/epilogue arithmetic roots. Both directions instantiate the same
# kernels (one set per lane count), so a root names its phase, not a direction.
MCP_BODY = re.compile(
    r"^(prologue|epilogue)_from_poly1305_(?:mac_pipelined_make_pipelined_compute_lanes"
    r"|paired_compute_make_paired_compute_capacity|mcp_shared_make_shared_compute"
    r"_capacity)_\d+_\d+clk_", re.IGNORECASE)


def audit_poly1305_hdl(out_dir, directions=("encrypt", "decrypt"), top_vhdl=None, shared=False):
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
    # same kernel. Traverse instantiation edges (duplicates included),
    # stopping at the arithmetic roots, then audit each root's descendants.
    pending = [(top_match.group(1).lower(), ())]
    while pending:
        entity, ancestors = pending.pop()
        if entity in ancestors:
            errors.append("Cyclic HDL instantiation: " + entity)
            continue
        match = MCP_BODY.match(entity)
        if match:
            phase = match.group(1).lower()
            roots.setdefault(phase, set()).add(entity)
            physical_counts[phase] = physical_counts.get(phase, 0) + 1
            continue
        info = entities.get(entity)
        if info is None:
            errors.append("Missing emitted entity: " + entity)
            continue
        pending.extend((child, ancestors + (entity,)) for child in info["children"])
    # One physical instance per phase when the MCPs are shared, else one per
    # direction. Shared and private kernels can have the same name, so the
    # requested architecture decides which count is right.
    expected = 1 if shared else len(directions)
    reports = {}
    for phase in ("prologue", "epilogue"):
        if phase not in roots:
            errors.append(f"Missing reachable MCP arithmetic: {phase}")
            continue
        if len(roots[phase]) != 1:
            errors.append(f"{phase}: expected one MCP arithmetic kernel, got "
                          + ", ".join(sorted(roots[phase])))
        count = physical_counts[phase]
        if count != expected:
            errors.append(f"{phase}: expected {expected} physical MCP arithmetic "
                          f"instance(s) ({'shared' if shared else 'one per direction'}), "
                          f"got {count}")
        for root in sorted(roots[phase]):
            label = phase if len(roots[phase]) == 1 else f"{phase}/{root}"
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
            "shared": shared,
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
    minimum_service_latency = 0 if config.get("comb") else 1
    if credits != core + 5 or ratio < 1 or prologue < minimum_service_latency:
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


def overlap_fifo_sizing_errors(config):
    """Validate the latency ledger and allocated fork storage."""
    errors = []
    buffers = config.get("buffering", {})
    for name, buffer in buffers.items():
        sizing = buffer.get("sizing", {})
        if sizing.get("method") != "poly1305-overlap-fork-v2":
            continue
        direction = name.split("/")[0]
        mac = config.get("poly1305", {}).get("directions", {}).get(direction, {})
        label = name + ": "
        try:
            shared = sizing["shared_mcps"]
            if type(shared) is not bool or shared != mac["shared_mcps"]:
                raise ValueError("sharing selection")
            for key in ("prologue_mcp_latency", "epilogue_mcp_latency", "body_latency",
                        "prologue_handoff_cycles", "body_commit_cycles", "epilogue_handoff_cycles"):
                expected_value = mac.get("total_body_latency", mac.get(key)) if key == "body_latency" else mac[key]
                minimum = 0 if config.get("comb") and key in ("prologue_mcp_latency", "epilogue_mcp_latency") else 1
                if type(sizing[key]) is not int or sizing[key] < minimum or sizing[key] != expected_value:
                    raise ValueError(key)
            core = sizing["chacha20_core_latency"]
            credits = sizing["chacha20_max_in_flight_blocks"]
            ratio = sizing["chacha20_block_beats"]
            beat_bytes = config.get("bus_bytes", 16)
            if credits != core + 5 or ratio != 64 // beat_bytes or sizing["max_aad_beats"] != (32 + beat_bytes - 1) // beat_bytes:
                raise ValueError("ChaCha/framing storage")
            if sizing["preceding_peer_requests"] != int(shared) or sizing["max_packed_tag_beats"] != 2:
                raise ValueError("peer/tag bound")
            setup = ((1 + int(shared)) * (sizing["prologue_mcp_latency"] + 1)
                     + sizing["prologue_handoff_cycles"])
            completion = (sizing["body_latency"] + sizing["body_commit_cycles"]
                          + (1 + int(shared)) * (sizing["epilogue_mcp_latency"] + 1)
                          + sizing["epilogue_handoff_cycles"] + sizing["max_packed_tag_beats"])
            terms = {"setup_service_and_handoffs": setup, "aad_framing": sizing["max_aad_beats"],
                     "framing_idle": 1, "length_framing": 1, "fifo_startup": 2, "fork_copy_lead": 1}
            if name == "encrypt/auth_fifo":
                terms["narrowing_storage"] = ratio + 1
            elif name == "encrypt/append_fifo":
                capacity = buffers["encrypt/auth_fifo"]["capacity_beats"]
                if sizing["authentication_capacity_beats"] != capacity:
                    raise ValueError("authentication queue capacity")
                terms["authentication_queue"] = capacity
                terms["completion_service_and_handoffs"] = completion
            elif name == "decrypt/auth_fifo":
                terms["pipeline_credits"] = ratio * credits
                terms["widening_storage"] = ratio + 1
                terms["completion_service_and_handoffs"] = completion
            else:
                raise ValueError("unknown buffer")
            if beat_bytes == 32:
                terms["formatter_storage"] = 2
            required = sum(terms.values())
            depth = 1 << (max(2, required) - 1).bit_length()
            if sizing["buffer"] != name or sizing["terms_beats"] != terms or sizing["required_beats"] != required:
                raise ValueError("budget terms")
            if sizing["memory_depth_beats"] != depth or buffer["memory_depth_beats"] != depth:
                raise ValueError("allocated depth")
        except (KeyError, TypeError, ValueError) as exc:
            errors.append(label + "overlap sizing metadata disagree: " + str(exc))
    return errors


def verify_fifo_sizing_errors(config):
    """Reject stale credit, packet-limit, handoff or allocation metadata."""
    buffer = config.get("buffering", {}).get("decrypt/verify_fifo", {})
    sizing = buffer.get("sizing", {})
    if sizing.get("method") != "plaintext-verdict-credit-bound-v1":
        return []  # Historical records and explicit sizing experiments.
    label = "decrypt/verify_fifo: "
    try:
        packet_bytes = sizing["max_plaintext_bytes"]
        beat_bytes = sizing["axis_beat_bytes"]
        if type(packet_bytes) is not int or packet_bytes < 1 or packet_bytes != config["max_packet_bytes"]:
            raise ValueError("supported plaintext limit")
        if beat_bytes != config.get("bus_bytes", BUS_BYTES) or sizing["verify_handoff_cycles"] != 4:
            raise ValueError("converter/verdict handoffs")
        terms = dict(sizing["terms_beats"])
        expected_extra = {
            "held_maximum_packet": (packet_bytes + beat_bytes - 1) // beat_bytes,
            "narrowing_storage": sizing["chacha20_block_beats"] + 1,
            "verification_handoffs": sizing["verify_handoff_cycles"],
            "release_handoff": 1,
        }
        for key, value in expected_extra.items():
            if terms.pop(key) != value:
                raise ValueError(key)
        # Revalidate the inherited admission/service bound against the actual
        # selected MAC, independently of the verification FIFO's allocation.
        inherited = copy.deepcopy(sizing)
        method = inherited["authentication_sizing_method"]
        if method not in ("chacha-credit-bound-v1", "poly1305-overlap-fork-v2"):
            raise ValueError("authentication sizing method")
        inherited.update(method=method, buffer="decrypt/auth_fifo", terms_beats=terms,
                         required_beats=sum(terms.values()),
                         memory_depth_beats=1 << (max(2, sum(terms.values())) - 1).bit_length())
        derived_config = copy.deepcopy(config)
        derived_config["buffering"] = {"decrypt/auth_fifo": {
            "sizing": inherited, "memory_depth_beats": inherited["memory_depth_beats"]}}
        errors = auth_fifo_sizing_errors(derived_config) + overlap_fifo_sizing_errors(derived_config)
        if errors:
            raise ValueError("; ".join(errors))
        required = sum(sizing["terms_beats"].values())
        depth = 1 << (max(2, required) - 1).bit_length()
        if sizing["buffer"] != "decrypt/verify_fifo" or sizing["required_beats"] != required:
            raise ValueError("required budget")
        if sizing["memory_depth_beats"] != depth or buffer["memory_depth_beats"] != depth:
            raise ValueError("allocated depth")
        return []
    except (KeyError, TypeError, ValueError) as exc:
        return [label + "verification sizing metadata disagree: " + str(exc)]


def measurement_errors(results):
    """Acceptance checks; failed runs still retain all diagnostic artifacts."""
    errors = []
    config = results.get("config", {})
    width = recorded_data_bitwidth(config)
    rate = config.get("poly1305_blocks_per_cycle", width // 128)
    if width not in DATA_BITWIDTHS or width != 128 * rate or config.get("bus_bytes", 16) * 8 != width:
        errors.append("Packet width disagrees with Poly1305 block rate")
    requested_width = config.get("requested_data_bitwidth")
    if requested_width is not None:
        if requested_width != width:
            errors.append("Performance simulation data bitwidth differs from the request")
        for scope, actual in results.get("build_block_rates", {}).items():
            if scope == "perf" and config.get("comb"):
                continue
            if actual is None or actual * 128 != requested_width:
                errors.append(scope + ": emitted data bitwidth differs from the request or is unknown")
    requested_rate = config.get("requested_poly1305_blocks_per_cycle")
    if requested_rate is not None:
        if requested_rate != rate:
            errors.append("Performance simulation block rate differs from the request")
        for scope, actual in results.get("build_block_rates", {}).items():
            if scope == "perf" and config.get("comb"):
                continue  # Native --comb does not emit hardware provenance.
            if actual != requested_rate:
                errors.append(scope + ": emitted block rate differs from the request or is unknown")
    requested_mult = config.get("requested_poly1305_mult_impl")
    if requested_mult is not None:
        if config.get("poly1305_mult_impl") != requested_mult:
            errors.append("Performance simulation multiplier differs from the requested implementation")
        for scope, actual in results.get("build_mult_impls", {}).items():
            if scope == "perf" and config.get("comb"):
                continue  # Native --comb does not emit hardware provenance.
            if actual != requested_mult:
                errors.append(scope + ": emitted multiplier selection differs from the request or is unknown")
    requested_compute = config.get("requested_poly1305_compute_impl")
    if requested_compute is not None and config.get("poly1305_impl") == "pipelined":
        if config.get("poly1305_compute_impl") != requested_compute:
            errors.append("Performance simulation compute differs from the requested implementation")
        if config.get("poly1305", {}).get("compute_impl") != requested_compute:
            errors.append("Resolved Poly1305 compute metadata differs from the request")
        for scope, actual in results.get("build_compute_impls", {}).items():
            if scope == "perf" and config.get("comb"):
                continue  # Native --comb does not emit hardware provenance.
            if actual != requested_compute:
                errors.append(scope + ": emitted compute selection differs from the request or is unknown")
    if config.get("poly1305_impl") == "pipelined" and config.get("poly1305_compute_impl") == "fsm":
        for phase in ("prologue", "epilogue"):
            key = "poly1305_" + phase + "_max_latency"
            requested = config.get("requested_" + key)
            actual = config.get(key)
            if requested is not None and actual != requested:
                errors.append("Emitted " + phase + " cap differs from the request")
            simulated = config.get("simulated_" + key)
            if simulated is not None and simulated != actual:
                errors.append("Performance simulation " + phase + " cap differs from the hardware")
            if actual is not None:
                for direction, meta in config.get("poly1305", {}).get("directions", {}).items():
                    latency = meta.get(phase + "_mcp_latency")
                    if latency is not None and latency > actual:
                        errors.append(direction + ": " + phase + " latency exceeds its cap")
    errors.extend(auth_fifo_sizing_errors(results.get("config", {})))
    errors.extend(overlap_fifo_sizing_errors(config))
    errors.extend(verify_fifo_sizing_errors(config))
    errors.extend(throughput_parity_errors(results))
    returncode = results.get("provenance", {}).get("build_returncode")
    if returncode:
        errors.append(f"Build/simulation exited {returncode}")
    hardware_returncode = results.get("provenance", {}).get("hardware_build", {}).get("returncode")
    if hardware_returncode:
        errors.append(f"Hardware build exited {hardware_returncode}")
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
        if config.get("steady_trim_packets", 0):
            for direction in config.get("dirs", []):
                stats = phase.get(direction, {})
                window = steady_packet_window(stats.get("packets", []), phase["packet_bytes"],
                                              config["steady_trim_packets"])
                if not window["available"] or stats.get("steady_state") != window:
                    errors.append(phase["name"] + "/" + direction + ": invalid interior completion window")
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
        for direction, metadata in config.get("poly1305", {}).get("directions", {}).items():
            if metadata.get("packet_architecture") == "overlapped":
                expected = {"poly1305.prepared": 1, "poly1305.contexts": 2,
                            "poly1305.completion": 1, "poly1305.tags": 1}
                if metadata.get("packet_buffers") != expected:
                    errors.append(direction + ": packet stage capacities disagree")
                buffers.update({direction + "/" + name: capacity for name, capacity in expected.items()})
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
        errors.extend(direction_latency_errors(mac.get("directions", {})))
        for direction, meta in mac.get("directions", {}).items():
            depth = meta.get("body_core_latency")
            latency = meta.get("body_latency")
            if depth is None or latency != depth + 2 or meta.get("accumulator_count") != latency:
                errors.append(direction + ": body D=P+2 and L=D metadata disagree")
            if meta.get("body_ii") != 1:
                errors.append(direction + ": pipelined body II is not 1")
            if meta.get("blocks_per_cycle", 1) != rate:
                errors.append(direction + ": resolved body block rate differs from the profile")
            if meta.get("axis_beat_bytes", 16 if rate == 1 else None) != 16 * rate:
                errors.append(direction + ": resolved packet width differs from the profile")
            if rate == 2:
                coefficient = meta.get("coefficient_latency")
                coefficient_core = meta.get("coefficient_core_latency")
                if (type(coefficient) is not int or type(coefficient_core) is not int
                        or coefficient_core < 0 or coefficient != coefficient_core + 2
                        or meta.get("total_body_latency") != coefficient + latency):
                    errors.append(direction + ": coefficient/feedback latency metadata disagree")
                for phase in results.get("phases", []):
                    life = phase.get("poly1305_lifecycle", {}).get(direction, {})
                    counts = [life.get(k) for k in ("coefficient_launches", "coefficient_retirements", "body_launches", "body_retirements")]
                    if None in counts or len(set(counts)) != 1:
                        errors.append(direction + ": paired arithmetic conservation failed")
                    nblocks = life.get("authentication_blocks")
                    tails = life.get("unmatched_tails")
                    expected_blocks = (phase.get("model", {}).get(direction, {}).get("poly1305_blocks", 0)
                                       * life.get("completed_packets", 0))
                    if nblocks is None or tails is None or nblocks != 2 * (counts[0] or 0) + (tails or 0) or nblocks != expected_blocks:
                        errors.append(direction + ": authentication block/pair/tail conservation failed")
        sharing = results.get("config", {}).get("sharing") or {}
        if sharing.get("poly1305"):
            if results.get("config", {}).get("source_handshake") != "converged":
                errors.append("Shared MCP measurement lacks converged source handshakes")
            if results.get("config", {}).get("decrypt_verification_retained") is not True:
                errors.append("Shared MCP measurement does not retain decrypt verification in HDL")
            service = mac.get("shared_mcps") or {}
            counts = [m.get("accumulator_count") for m in mac.get("directions", {}).values()]
            capacity = service.get("capacity_lanes")
            # Historical records may carry a fixed capacity above the lanes; unused slots are zero.
            fixed = results.get("config", {}).get("requested_poly1305_compute_capacity")
            if (not counts or None in counts or type(capacity) is not int or capacity < max(counts)
                    or capacity != (fixed if fixed is not None else max(counts))):
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


# The MAC latencies the compiler decides per direction: the AUTO_PIPELINE body and
# coefficient depths and the AUTO_FSM prologue/epilogue latencies
DIRECTION_LATENCY_FIELDS = ("body_core_latency", "coefficient_core_latency",
                            "prologue_mcp_latency", "epilogue_mcp_latency")


def direction_latency_errors(directions):
    """Encrypt and decrypt run identical MAC arithmetic, so one build must give them
    identical latencies. A difference means the build measured one direction's
    hardware wrongly (for example timing from a top whose synthesis removed it)."""
    if not {"encrypt", "decrypt"} <= set(directions):
        return []
    encrypt, decrypt = directions["encrypt"], directions["decrypt"]
    differ = [f"{field} {encrypt.get(field)} vs {decrypt.get(field)}"
              for field in DIRECTION_LATENCY_FIELDS if encrypt.get(field) != decrypt.get(field)]
    if not differ:
        return []
    return ["Encrypt and decrypt MAC latencies differ (encrypt vs decrypt): " + "; ".join(differ)]


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


def compare_block_rates(before, after):
    """Matched one-/two-block QoR: gate 1920-byte goodput in both directions.

    Short-packet changes are reported. This is deliberately separate from the
    older FIFO-recovery comparison, whose acceptance thresholds are different.
    """
    errors = []
    for label, record in (("baseline", before), ("paired", after)):
        errors.extend(label + ": " + error for error in measurement_errors(record))
        if record.get("config", {}).get("comb"):
            errors.append(label + ": requires synthesized timing and area")
    old_config, new_config = before.get("config", {}), after.get("config", {})
    if recorded_data_bitwidth(old_config) != 128 or recorded_data_bitwidth(new_config) != 256:
        errors.append("Comparison requires 128-bit baseline and 256-bit result")
    for key in ("target_mhz", "dirs", "seed", "sizes", "packets_per_size", "peak_bytes", "peak_packets", "sharing",
                "poly1305_mult_impl", "poly1305_compute_impl", "native_arithmetic", "native_soft_ops"):
        if old_config.get(key) != new_config.get(key):
            errors.append("Comparison workload/config differs: " + key)
    compiler = before.get("provenance", {}).get("pipelinec_git")
    if not compiler or compiler != after.get("provenance", {}).get("pipelinec_git"):
        errors.append("Comparison requires the same recorded compiler revision")
    baseline = {(p["packet_bytes"], p["num_packets"]): p for p in before.get("phases", [])}
    comparisons = []
    for phase in after.get("phases", []):
        key = (phase["packet_bytes"], phase["num_packets"])
        old = baseline.get(key)
        if old is None:
            errors.append("Missing matched baseline phase: " + str(key))
            continue
        gains = {}
        for direction in ("encrypt", "decrypt"):
            old_rate = old.get(direction, {}).get("sustained_bytes_per_cycle", 0)
            new_rate = phase.get(direction, {}).get("sustained_bytes_per_cycle", 0)
            if not old_rate or not new_rate:
                errors.append(str(key) + ": missing concurrent " + direction + " goodput")
                continue
            gains[direction] = new_rate / old_rate
            if key[0] == 1920 and new_rate < old_rate:
                errors.append("1920-byte " + direction + " goodput regressed")
        comparisons.append({"packet_bytes": key[0], "num_packets": key[1],
                            "after_to_before_goodput": gains})
    if not any(p["packet_bytes"] == 1920 for p in comparisons):
        errors.append("Comparison lacks a matched 1920-byte phase")
    return {"passed": not errors, "errors": errors, "phases": comparisons,
            "criteria": {"minimum_1920_encrypt_gain": 1.0, "minimum_1920_decrypt_gain": 1.0}}


def evidence_scopes(results):
    """(archive prefix, area key, timing key) of each synthesized build a record
    measured: its own build ("hardware" for a real top, "perf" for a historical
    synthesized perf testbench) and a historical separate hardware-top build."""
    scopes = []
    if "area" in results:
        own = "hardware" if results["area"].get("scope") == "hardware_top" else "perf"
        scopes.append((own, "area", "fmax"))
    if "area_hw_build" in results:
        scopes.append(("hardware", "area_hw_build", "fmax_hw_build"))
    return scopes


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
        for prefix, area_key, timing_key in evidence_scopes(results):
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
    for prefix, area_key, timing_key in evidence_scopes(results):
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
    build_state_selftest()
    workflow_selftest()
    # Four completions yield three service intervals without charging cold
    # first-packet latency. Small-packet asymmetry must not block the decision.
    phases = []
    for size, periods in ((1420, (50, 49, 49)), (1920, (64, 64, 64))):
        phase = {"name": "b2b-" + str(size), "packet_bytes": size, "num_packets": 4}
        for direction in DIRECTIONS:
            clocks = [100]
            for period in periods:
                clocks.append(clocks[-1] + period)
            entries = [{"idx": i, "last_out": clock} for i, clock in enumerate(clocks)]
            rate = steady_packet_window(entries, size, 0)["bytes_per_cycle"]
            phase[direction] = {"packets": entries, "sustained_bytes_per_cycle": rate,
                                "throughput_bytes_per_cycle": rate, "gbps_at_target": rate * 80 * .008}
        phases.append(phase)
    parity = {"config": {"require_throughput_parity": True, "dirs": list(DIRECTIONS),
                         "steady_trim_packets": 0, "target_mhz": 80}, "phases": phases}
    if throughput_parity_errors(parity):
        raise ValueError("Valid near-max parity fixture rejected: " + repr(throughput_parity_errors(parity)))
    with_small = copy.deepcopy(parity)
    with_small["phases"].append({"name": "b2b-16", "packet_bytes": 16, "num_packets": 4,
                                  "encrypt": {"sustained_bytes_per_cycle": 1},
                                  "decrypt": {"sustained_bytes_per_cycle": .1}})
    if throughput_parity_errors(with_small):
        raise ValueError("Small-packet asymmetry incorrectly blocks the near-max decision")
    for label, mutate in (
        ("direction asymmetry", lambda r: r["phases"][0]["decrypt"].update(packets=[
            {"idx": i, "last_out": 100 + 70 * i} for i in range(4)])),
        ("too few completions", lambda r: r["phases"][0]["decrypt"].update(packets=[
            {"idx": i, "last_out": 100 + 49 * i} for i in range(3)])),
        ("missing near-max size", lambda r: r["phases"].pop()),
        ("inconsistent intervals", lambda r: r["phases"][0]["decrypt"].update(packets=[
            {"idx": i, "last_out": c} for i,c in enumerate((100,149,248,297))])),
        ("missing direction", lambda r: r["config"].update(dirs=["encrypt"])),
    ):
        changed = copy.deepcopy(parity)
        mutate(changed)
        if not throughput_parity_errors(changed):
            raise ValueError("Near-max parity guard accepted " + label)
    """Measurement guards/models/archive checks; no compiler or Vivado runs."""
    default = resolve_profile()
    if any(default[k] != value for k, value in DEFAULT_PROFILE.items()):
        raise ValueError("Default profile differs from the published QoR profile")
    with open(os.path.join(HERE, DEFAULT_BUILD['measurement'], 'results.json')) as f:
        published = json.load(f)
    if profile_from_record(published) != DEFAULT_PROFILE:
        raise ValueError("Published default differs from its validated measurement")
    with open(os.path.join(HERE, 'README.md')) as f:
        current_table = f.read().split(README_BEGIN, 1)[1].split(README_END, 1)[0]
    if '--label ' + published['label'] not in current_table:
        raise ValueError("README QoR table and published default name different measurements")
    if resolve_profile(compute="mcp")["sharing"] != {"chacha20": True, "poly1305": True}:
        raise ValueError("Automatic MCP profile must share both services")
    if resolve_profile(share="both")["sharing"]["poly1305"] is not True:
        raise ValueError("Explicit sharing selection was overridden")
    narrow = resolve_profile(data_bitwidth=128)
    legacy = resolve_profile(implementation="legacy")
    if (narrow["prologue_cap"], narrow["epilogue_cap"]) != (64, 64):
        raise ValueError("128-bit default caps must stay loose")
    if (legacy["data_bitwidth"], legacy["multiplier"], legacy["target_mhz"]) != (128, "inferred", 80):
        raise ValueError("Legacy profile defaults changed")
    for selector in (selected_prologue_cap, selected_epilogue_cap):
        for invalid in (0, -1, True, 1.5, "40"):
            try:
                selector(invalid)
            except ValueError:
                pass
            else:
                raise ValueError("Invalid compute cap was accepted: " + repr(invalid))
    if prologue_cap_out_dir("historical", 64) != "historical":
        raise ValueError("Historical prologue directory identity changed")
    if epilogue_cap_out_dir("historical", 64) != "historical":
        raise ValueError("Historical epilogue directory identity changed")
    if epilogue_cap_out_dir(prologue_cap_out_dir("run", 44), 45) != "run-procap44-epicap45":
        raise ValueError("Nonhistorical caps must have distinct directory identities")
    with tempfile.TemporaryDirectory(prefix="wg-caps-") as directory:
        path = Path(directory) / "source_provenance.json"
        path.write_text(json.dumps({"design_params": []}))
        if (build_prologue_cap(directory), build_epilogue_cap(directory)) != (64, 64):
            raise ValueError("Historical emitted caps must default to 64")
        path.write_text(json.dumps({"design_params": [
            {"name": "DATA_BITWIDTH", "value": 256},
            {"name": "POLY1305_PROLOGUE_MAX_LATENCY", "value": None},
            {"name": "POLY1305_EPILOGUE_MAX_LATENCY", "value": None},
        ]}))
        if (build_prologue_cap(directory), build_epilogue_cap(directory)) != (
                default['prologue_cap'], default['epilogue_cap']):
            raise ValueError("Direct compiler defaults disagree with emitted profile caps")
        for width_params in (
                [{"name": "POLY1305_BLOCKS_PER_CYCLE", "value": 1}],
                [{"name": "POLY1305_IMPL", "value": "legacy"}]):
            path.write_text(json.dumps({"design_params": width_params + [
                {"name": "POLY1305_PROLOGUE_MAX_LATENCY", "value": None},
                {"name": "POLY1305_EPILOGUE_MAX_LATENCY", "value": None},
            ]}))
            if (build_prologue_cap(directory), build_epilogue_cap(directory)) != (64, 64):
                raise ValueError("Direct legacy/block-rate width must retain 64/64 caps")
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
    verify_config = copy.deepcopy(sizing_config)
    verify_config["max_packet_bytes"] = 2032
    verify = copy.deepcopy(verify_config["buffering"]["decrypt/auth_fifo"])
    verify["memory_depth_beats"] = 256
    verify["sizing"].update(
        method="plaintext-verdict-credit-bound-v1", buffer="decrypt/verify_fifo",
        authentication_sizing_method="chacha-credit-bound-v1", max_plaintext_bytes=2032,
        axis_beat_bytes=16, verify_handoff_cycles=4, required_beats=252, memory_depth_beats=256,
    )
    verify["sizing"]["terms_beats"].update(
        held_maximum_packet=127, narrowing_storage=5, verification_handoffs=4, release_handoff=1)
    verify_config["buffering"] = {"decrypt/verify_fifo": verify}
    if verify_fifo_sizing_errors(verify_config):
        raise ValueError("Valid verification FIFO sizing rejected")
    for section, key, value in (
        ("buffer", "memory_depth_beats", 128),
        ("sizing", "chacha20_max_in_flight_blocks", 9),
        ("sizing", "max_plaintext_bytes", 1920),
        ("sizing", "verify_handoff_cycles", 1),
        ("sizing", "required_beats", 128),
        ("sizing", "memory_depth_beats", 128),
        ("terms", "held_maximum_packet", 120),
        ("terms", "narrowing_storage", 0),
        ("terms", "release_handoff", 0),
    ):
        changed = copy.deepcopy(verify_config)
        buffer = changed["buffering"]["decrypt/verify_fifo"]
        target = {"buffer": buffer, "sizing": buffer["sizing"],
                  "terms": buffer["sizing"]["terms_beats"]}[section]
        target[key] = value
        if not verify_fifo_sizing_errors(changed):
            raise ValueError("Verification sizing guard accepted stale " + key)
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
        ("direction latency mismatch", lambda r: r["config"]["poly1305"]["directions"]["decrypt"].update(
            body_core_latency=r["config"]["poly1305"]["directions"]["encrypt"]["body_core_latency"] + 1,
            body_latency=r["config"]["poly1305"]["directions"]["encrypt"]["body_latency"] + 1,
            accumulator_count=r["config"]["poly1305"]["directions"]["encrypt"]["accumulator_count"] + 1)),
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
    fixed = copy.deepcopy(shared)
    fixed["config"]["requested_poly1305_compute_capacity"] = 99
    fixed["config"]["poly1305"]["shared_mcps"]["capacity_lanes"] = 99
    if measurement_errors(fixed):
        raise ValueError("Valid fixed shared capacity rejected: " + repr(measurement_errors(fixed)))
    for label, mutate in (
        ("shared capacity", lambda r: r["config"]["poly1305"]["shared_mcps"].update(capacity_lanes=99)),
        ("fixed capacity below lanes", lambda r: (
            r["config"].update(requested_poly1305_compute_capacity=1),
            r["config"]["poly1305"]["shared_mcps"].update(capacity_lanes=1))),
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


def workflow_selftest():
    """Check dispatch without launching a compiler, synthesis or simulation."""
    import contextlib
    import io
    from unittest.mock import patch

    with tempfile.TemporaryDirectory(prefix='wg-workflow-') as temporary:
        root = Path(temporary)
        out = root / 'hardware';out.mkdir()
        source = root / 'source.py';source.write_text('version 1\n')
        p = resolve_profile();sharing = p['sharing']
        share = ('both' if sharing['poly1305'] else 'chacha20') if sharing['chacha20'] else ('poly1305' if sharing['poly1305'] else 'none')
        metadata = dict(top=os.path.join(HERE, 'src', 'chacha20poly1305.py'),
                        native_sim_problems=[], sources={str(source): hashlib.sha256(source.read_bytes()).hexdigest()},
                        design_params=dict(DESIGN='shared', DATA_BITWIDTH=p['data_bitwidth'],
                            POLY1305_IMPL=p['implementation'], POLY1305_MULT_IMPL=p['multiplier'],
                            POLY1305_COMPUTE_IMPL=p['compute'], TARGET_MHZ=p['target_mhz'], SHARE=share,
                            POLY1305_PROLOGUE_MAX_LATENCY=p['prologue_cap'],
                            POLY1305_EPILOGUE_MAX_LATENCY=p['epilogue_cap']))
        (out / BUILT_HARDWARE_FILE).write_text(json.dumps(metadata))
        arguments = ['measure.py','--label',str(root/'record'),'--out-dir',str(out),'--syn-cache','none']
        for extra, expected in (([], 'perf'), (['--rebuild'], 'hardware')):
            with patch.object(sys, 'argv', arguments+extra), contextlib.redirect_stdout(io.StringIO()), \
                    patch(__name__+'.run_hardware_build', side_effect=StopIteration('hardware')) as hardware, \
                    patch(__name__+'.run_build', side_effect=StopIteration('perf')) as perf:
                try:
                    main()
                except StopIteration as stop:
                    assert str(stop) == expected
                else:
                    raise AssertionError('Workflow did not reach expected dispatch')
                called = perf if expected == 'perf' else hardware
                resolved = called.call_args[0][0]
                assert (resolved.sizes,resolved.packets,resolved.peak_bytes) == ('1420,1920',4,0)
                assert hardware.call_count == (expected == 'hardware')
        source.write_text('version 2\n')
        with patch.object(sys,'argv',arguments+['--reuse-syn']), \
                contextlib.redirect_stderr(io.StringIO()), \
                patch(__name__+'.run_hardware_build') as hardware, patch(__name__+'.run_build') as perf:
            assert main() == 1 and not hardware.called and not perf.called
    print('workflow selftest: PASS (automatic replay, requested rebuild, strict stale rejection)')


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--label", default=None, help="measurement name (dir under measurements/)")
    ap.add_argument("--shared", action="store_true", help="Explicitly share both resources")
    add_sharing_arguments(ap)
    ap.add_argument("--poly1305", choices=IMPLEMENTATIONS, default=None,
                    help="MAC architecture (default pipelined)")
    ap.add_argument("--data-bitwidth", type=int, choices=DATA_BITWIDTHS,
                    help="Encrypt/decrypt packet datapath width in bits (default 256; legacy 128)")
    ap.add_argument("--poly1305-mult", choices=MULT_IMPLEMENTATIONS,
                    help="130-bit multiply implementation (default inferred_body; legacy inferred)")
    ap.add_argument("--poly1305-compute", choices=COMPUTE_IMPLEMENTATIONS,
                    help="Prologue/epilogue implementation (default: published QoR profile)")
    ap.add_argument("--poly1305-prologue-cap", type=int, default=None, metavar="N",
                    help="AUTO_FSM prologue cap (default: published QoR profile; fsm only)")
    ap.add_argument("--poly1305-epilogue-cap", type=int, default=None, metavar="N",
                    help="AUTO_FSM epilogue cap (default: published QoR profile; fsm only)")
    ap.add_argument("--target-mhz", type=selected_target, default=None,
                    help="Clock goal (default: 256-bit inferred_body 80 MHz; other profiles retain their clock)")
    ap.add_argument("--latency-hints", action="append", default=[], metavar="FILE",
                    help="Starting AUTO_PIPELINE latencies passed to build.py (repeatable)")
    ap.add_argument("--pipeline-min-effort", type=int, default=None, metavar="N",
                    help="Stage-trimming syntheses after timing is met, passed to build.py (0 = none)")
    ap.add_argument("-j", "--jobs", type=int, default=None,
                    help="Maximum simultaneous synthesis jobs (use 1 on low-RAM systems)")
    ap.add_argument("--comb", action="store_true", help="combinational build: fast rig check, no Vivado, no area/fmax")
    reuse = ap.add_mutually_exclusive_group()
    reuse.add_argument("--reuse-syn", action="store_true", help="require an existing matching hardware build; never synthesize")
    reuse.add_argument("--rebuild", action="store_true", help="run the hardware build even when matching hardware is available")
    ap.add_argument("--show-config", action="store_true", help="Print the resolved profile and cache paths without building or simulating")
    ap.add_argument("--out-dir", help="Explicit hardware build directory (same rules as build.py --out-dir)")
    ap.add_argument("--syn-cache", default=None, metavar="DIR|none",
                    help="Synthesis store (default: latest compatible successful store)")
    ap.add_argument("--parse-only", action="store_true", help="run nothing; re-merge an existing run's perf JSON + build log")
    ap.add_argument("--no-per-module-area", action="store_true", help="skip per-module out-of-context area parsing")
    ap.add_argument("--sizes", default="1420,1920", help="comma-separated packet sizes (default: 1420,1920)")
    ap.add_argument("--packets", type=int, default=4, help="back-to-back packets per size (default: 4)")
    ap.add_argument("--steady-trim", type=int, default=None, metavar="N",
                    help="exclude N warm-up and N drain packets from headline completion throughput")
    ap.add_argument("--require-parity", action="store_true",
                    help="require 1420/1920-byte phases, 4+ packets, 5%% direction parity and consistent completion intervals")
    ap.add_argument("--peak-bytes", type=int, default=0, help="extra peak phase size (default: 0, disabled)")
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
    if args.steady_trim is not None and args.steady_trim < 0:
        ap.error("--steady-trim must be nonnegative")
    if args.require_parity:
        if args.steady_trim is None:
            args.steady_trim = 0
        if args.comb:
            ap.error("--require-parity requires a retained hardware build")
    try:
        if args.selftest:
            return measurement_selftest()
        if args.check_record or args.audit_mcps:
            report = (check_record(args.check_record) if args.check_record else
                      audit_poly1305_hdl(generated_out_dir(args.audit_mcps),
                                         tuple(args.audit_directions.split(",")),
                                         shared=sharing_from_args(args)["poly1305"]))
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
        if args.parse_only:
            # Resolve only neutral argument defaults; the saved record supplies
            # its own architecture/sharing/caps below, including legacy records.
            profile = resolve_profile(
                implementation=args.poly1305, target_mhz=args.target_mhz,
                multiplier=args.poly1305_mult, data_bitwidth=args.data_bitwidth,
                compute=args.poly1305_compute, prologue_cap=args.poly1305_prologue_cap,
                epilogue_cap=args.poly1305_epilogue_cap,
            )
            args.poly1305 = profile["implementation"]
            args.data_bitwidth = profile["data_bitwidth"]
            args.poly1305_mult = profile["multiplier"]
            args.poly1305_compute = profile["compute"]
            args.poly1305_prologue_cap = profile["prologue_cap"]
            args.poly1305_epilogue_cap = profile["epilogue_cap"]
            args.target_mhz = profile["target_mhz"]
            args.sharing = None
        else:
            profile = profile_from_args(args)
            args.sharing = profile["sharing"]
            select_build_state(HERE, args, profile, DEFAULT_BUILD)
        args.poly1305_blocks_per_cycle = args.data_bitwidth // 128
    except ValueError as exc:
        ap.error(str(exc))

    label = args.label or (("comb-smoke" + (f"-{args.target_mhz}mhz" if args.target_mhz != 80 else "")
                           if args.comb else f"shared-{args.target_mhz}mhz")
                           + "-poly1305-" + args.poly1305
                           + ("-share-" + sharing_name(args.sharing) if args.sharing is not None else "")
                           + "-mult-" + args.poly1305_mult
                           + ("-compute-" + args.poly1305_compute if args.poly1305 == "pipelined" else ""))
    if args.label is None and args.poly1305 == "pipelined" and args.poly1305_compute == "fsm":
        label = prologue_cap_out_dir(label, args.poly1305_prologue_cap)
        label = epilogue_cap_out_dir(label, args.poly1305_epilogue_cap)
    if args.label is None:
        label = blocks_out_dir(label, args.poly1305_blocks_per_cycle)
    meas_dir = os.path.join(HERE, "measurements", label)
    json_path = os.path.join(meas_dir, "perf_raw.json")
    log_path = os.path.join(meas_dir, "pypelinec.log")
    hardware_log_path = os.path.join(meas_dir, "pypelinec-hardware.log")
    if args.comb or args.parse_only:
        # A comb rig check builds nothing; parse-only reads the recorded directory below
        out_dir = out_dir_for(args.comb, args.poly1305, args.target_mhz, args.sharing, args.poly1305_mult,
                              args.poly1305_compute if args.poly1305 == "pipelined" else None, args.poly1305_blocks_per_cycle)
        if args.poly1305 == "pipelined" and args.poly1305_compute == "fsm":
            out_dir = prologue_cap_out_dir(out_dir, args.poly1305_prologue_cap)
            out_dir = epilogue_cap_out_dir(out_dir, args.poly1305_epilogue_cap)
    else:
        out_dir = os.path.normpath(os.path.join(HERE, hardware_out_dir(
            "shared", args.poly1305, args.sharing, args.poly1305_mult, args.poly1305_compute,
            args.target_mhz, args.data_bitwidth, args.poly1305_prologue_cap, args.poly1305_epilogue_cap)))
    if args.out_dir:
        out_dir = os.path.abspath(args.out_dir)
    if args.show_config:
        print(json.dumps(dict(default_measurement=DEFAULT_BUILD['measurement'], profile=profile,
                              out_dir=out_dir, syn_cache=args.syn_cache,
                              latency_hints=args.latency_hints,
                              reuse_error=hardware_reuse_error(HERE, out_dir, profile)), indent=2))
        return 0
    os.makedirs(meas_dir, exist_ok=True)

    build_info = {"skipped": True}
    hardware_info = {"skipped": True}
    if not args.parse_only and not args.comb:
        reuse_error = hardware_reuse_error(HERE, out_dir, profile)
        if not args.rebuild and not reuse_error:
            args.reuse_syn = True
        if args.reuse_syn:
            if reuse_error:
                print(f"ERROR: --reuse-syn: {reuse_error} ({out_dir})", file=sys.stderr)
                return 1
            print(f"--> --reuse-syn: simulating the hardware already built in {out_dir}")
        else:
            print(f"--> Hardware build required: {reuse_error or '--rebuild requested'}")
            hardware_info = run_hardware_build(args, hardware_log_path)
            if hardware_info["returncode"] != 0:
                print(f"!! hardware build exited {hardware_info['returncode']} -- nothing to "
                      f"simulate (see {hardware_log_path})", file=sys.stderr)
                return hardware_info["returncode"]
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
        recorded_multiplier = perf_raw.get("config", {}).get("poly1305_mult_impl")
        recorded_compute = perf_raw.get("config", {}).get("poly1305_compute_impl")
        args.data_bitwidth = recorded_data_bitwidth(perf_raw.get("config", {}))
        args.poly1305_blocks_per_cycle = args.data_bitwidth // 128
        args.poly1305_compute = recorded_compute or "mcp"
        args.poly1305_mult = recorded_multiplier or "inferred"
        previous_path = os.path.join(meas_dir, "results.json")
        if os.path.exists(previous_path):
            with open(previous_path) as f:
                previous = json.load(f)
            args.comb = previous.get("config", {}).get("comb", args.comb)
            if args.steady_trim is None:
                args.steady_trim = previous.get("config", {}).get("steady_trim_packets", 0)
            args.require_parity = args.require_parity or previous.get("config", {}).get("require_throughput_parity", False)
        if mac_config:
            args.poly1305 = mac_config["implementation"]
            recorded_sharing = perf_raw.get("config", {}).get("sharing")
            args.target_mhz = (previous.get("config", {}).get("target_mhz")
                               or perf_raw.get("config", {}).get("target_mhz")
                               or historical_target_mhz(args.poly1305, recorded_sharing))
            out_dir = out_dir_for(args.comb, args.poly1305, args.target_mhz, recorded_sharing,
                                  recorded_multiplier, recorded_compute, args.poly1305_blocks_per_cycle)
        else:
            args.poly1305 = "legacy"
            args.target_mhz = 80
            out_dir = os.path.join(HERE, GENERATED_FILES, f"perf-{'comb' if args.comb else 'pipe'}-shared-native")
        recorded_dir = previous.get("config", {}).get("out_dir")
        if recorded_dir:
            out_dir = generated_out_dir(os.path.join(HERE, recorded_dir))
        args.sharing = perf_raw.get("config", {}).get("sharing", {"chacha20": True, "poly1305": False})
        for phase in ("prologue", "epilogue"):
            key = "poly1305_" + phase + "_max_latency"
            cap = previous.get("config", {}).get(key)
            if cap is None:
                cap = perf_raw.get("config", {}).get(key, 64)
            setattr(args, "poly1305_" + phase + "_cap", cap)

    stdout_info = parse_stdout(log_path)
    # Timing comes from the hardware build's log; a historical record's perf
    # build synthesized the testbench itself, so its own log has it
    timing_log = hardware_log_path if os.path.exists(hardware_log_path) else log_path
    hardware_scope = os.path.exists(os.path.join(out_dir, BUILT_HARDWARE_FILE)) or (
        previous.get("area", {}).get("scope") == "hardware_top")
    fmax = parse_fmax(out_dir, parse_stdout(timing_log))
    area = parse_area(out_dir, per_module=not args.no_per_module_area,
                      scope="hardware_top" if hardware_scope else "perf_tb_top")
    # Committed records remain reformatable after local synthesis caches are
    # removed. Never replace their accepted evidence with "unavailable".
    if args.parse_only and previous:
        if not os.path.isdir(out_dir):
            fmax = previous.get("fmax", fmax)
            area = previous.get("area", area)
    target_mhz = fmax.get("target_mhz") or args.target_mhz
    phases = derive_throughput(perf_raw, fmax.get("design_mhz"), target_mhz, args.steady_trim or 0)
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
            poly1305_mult_impl=perf_raw.get("config", {}).get("poly1305_mult_impl", "inferred"),
            requested_poly1305_mult_impl=None if args.parse_only else args.poly1305_mult,
            poly1305_blocks_per_cycle=perf_raw.get("config", {}).get("poly1305_blocks_per_cycle",
                                                                   recorded_data_bitwidth(perf_raw.get("config", {})) // 128),
            requested_poly1305_blocks_per_cycle=None if args.parse_only else args.poly1305_blocks_per_cycle,
            data_bitwidth=recorded_data_bitwidth(perf_raw.get("config", {})),
            requested_data_bitwidth=None if args.parse_only else args.data_bitwidth,
            poly1305_compute_impl=perf_raw.get("config", {}).get("poly1305_compute_impl", "mcp"),
            requested_poly1305_compute_impl=None if args.parse_only else args.poly1305_compute,
            poly1305_prologue_max_latency=(args.poly1305_prologue_cap if args.parse_only
                                           else build_prologue_cap(out_dir)),
            requested_poly1305_prologue_max_latency=None if args.parse_only else args.poly1305_prologue_cap,
            poly1305_epilogue_max_latency=(args.poly1305_epilogue_cap if args.parse_only
                                           else build_epilogue_cap(out_dir)),
            requested_poly1305_epilogue_max_latency=None if args.parse_only else args.poly1305_epilogue_cap,
            simulated_poly1305_prologue_max_latency=perf_raw.get("config", {}).get("poly1305_prologue_max_latency"),
            simulated_poly1305_epilogue_max_latency=perf_raw.get("config", {}).get("poly1305_epilogue_max_latency"),
            # Only records made before AUTO_FSM scheduled re-elaborated call sites fixed it.
            requested_poly1305_compute_capacity=previous.get("config", {}).get(
                "requested_poly1305_compute_capacity"),
            sharing=args.sharing,
            out_dir=os.path.relpath(out_dir, HERE),
            target_mhz=target_mhz,
            requested_target_mhz=(previous.get("config", {}).get("requested_target_mhz")
                                  if args.parse_only else args.target_mhz),
            build_cmd=build_info.get("cmd"),
            reuse_syn=bool(args.reuse_syn),
            steady_trim_packets=args.steady_trim or 0,
            require_throughput_parity=args.require_parity,
        ),
        "provenance": {
            "wireguard_fpga_git": git_describe(os.path.join(HERE, "..", "..")),
            # Recorded at build launch when there was a build (see run_build).
            "pipelinec_git": build_info.get("pipelinec_git")
            or compiler_revision(
                os.path.dirname(os.path.dirname(os.environ.get("PYPELINEC", DEFAULT_PIPELINEC_REPO + "/src/x")))
            ),
            "vivado_version": area.get("vivado_version") if area.get("available") else None,
            "host": socket.gethostname(),
            "build_wall_s": build_info.get("wall_s"),
            "build_returncode": build_info.get("returncode"),
            "cycles_run": stdout_info["sim_cycles"] or build_info.get("clock_lines"),
            "sim_wall_s": stdout_info["sim_wall_s"],
            # With --reuse-syn the hardware (hence fmax/area) was built by an
            # EARLIER run, so it can predate pipelinec_git above, which is the
            # revision that ran this sim.
            "synthesis_reused": bool(args.reuse_syn),
            "hardware_build": hardware_info,
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
        correct_frozen_compiler_revision(results["provenance"], log_path)
        for key in ("build_cmd", "reuse_syn"):
            if key in previous.get("config", {}):
                results["config"][key] = previous["config"][key]
        if "area_hw_build" in previous:
            results["area_hw_build"] = previous["area_hw_build"]
        if "fmax_hw_build" in previous:
            results["fmax_hw_build"] = previous["fmax_hw_build"]
        if "build_mult_impls" in previous:
            results["build_mult_impls"] = previous["build_mult_impls"]
        if "build_compute_impls" in previous:
            results["build_compute_impls"] = previous["build_compute_impls"]
        if "build_block_rates" in previous:
            results["build_block_rates"] = previous["build_block_rates"]
        results["config"]["requested_poly1305_blocks_per_cycle"] = previous.get("config", {}).get(
            "requested_poly1305_blocks_per_cycle")
        results["config"]["requested_data_bitwidth"] = previous.get("config", {}).get(
            "requested_data_bitwidth")
        results["config"]["requested_poly1305_compute_impl"] = previous.get("config", {}).get(
            "requested_poly1305_compute_impl")
        results["config"]["requested_poly1305_mult_impl"] = previous.get("config", {}).get(
            "requested_poly1305_mult_impl")
        for phase in ("prologue", "epilogue"):
            key = "requested_poly1305_" + phase + "_max_latency"
            results["config"][key] = previous.get("config", {}).get(key)
    elif not args.parse_only:
        # The comb rig check builds nothing; otherwise the hardware build's own selections
        scope = "perf" if args.comb else "hardware"
        results["build_mult_impls"] = {scope: build_mult_impl(out_dir)}
        results["build_compute_impls"] = {scope: build_compute_impl(out_dir)}
        results["build_block_rates"] = {scope: build_blocks_per_cycle(out_dir)}

    if (not args.parse_only and not args.comb and args.poly1305 == "pipelined"
            and args.poly1305_compute == "mcp"):
        try:
            audit = audit_poly1305_hdl(out_dir, shared=args.sharing["poly1305"])
        except (OSError, ValueError) as exc:
            audit = {"passed": False, "errors": [str(exc)]}
        results["mcp_hdl_audits"] = {"hardware": audit}
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
