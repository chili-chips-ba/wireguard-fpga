#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""wireguard-fpga's own Vivado `report_utilization` parser: reads the area
numbers straight out of the `vivado*.log` files pypelinec leaves in a build's
output directory, keeping LUTs / FFs / DSPs / BRAM separate.

Deliberately independent of PipelineC's `VIVADO.ParsedUtilizationReport`, which
is documented upstream as diagnostic-only ("never used to decide a QoR winner"),
reports just three fields (slice_luts / slice_registers / carry4), and takes the
first utilization block in a log. Timing/fmax parsing is NOT reimplemented here
-- measure.py reuses pypelinec's own numbers for that.

Where the numbers come from: pypelinec's synthesis TCL runs `report_utilization`
inline in every synthesis run (VIVADO.GET_SYN_IMP_AND_REPORT_TIMING_TCL), so

  <out_dir>/top/vivado_<hash>.log                whole design (top level)
  <out_dir>/<module>/vivado_<N>CLK_<hash>.log    one module, out-of-context

Per-module numbers are out-of-context syntheses: no constant folding from the
testbench and no cross-module sharing, so they do NOT sum to the top-level
total. They are an attribution aid ("which module got bigger"), not a
decomposition.

Usage:
  ./vivado_area.py <log-file>            # human-readable table
  ./vivado_area.py <log-file> --json
  ./vivado_area.py <out_dir> --per-module [--json]
  ./vivado_area.py --selftest            # parse known logs, check known values
"""

import argparse
import glob
import json
import os
import re
import sys

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


_MODULE_LOG_RE = re.compile(r"vivado_(\d+)CLK_[0-9a-f]+\.log$")


def parse_out_dir(out_dir, per_module=True):
    """Parse a whole pypelinec output directory: the top-level design plus, if
    asked, every module's out-of-context synthesis."""
    result = {"out_dir": os.path.abspath(out_dir), "top": None, "per_module": {}}
    top_logs = sorted(
        glob.glob(os.path.join(out_dir, "top", "vivado_*.log")),
        key=os.path.getmtime,
    )
    if top_logs:
        result["top"] = parse_log(top_logs[-1])
        result["top"]["logs_available"] = len(top_logs)
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
        # One module can have several logs (one per pipelining depth tried);
        # keep the deepest, which is the one the final build uses.
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
        "generated-files-syn-tb-pipe-dec/top/vivado_8d44bac9.log",
        {
            "lut_total": 26917,
            "lut_logic": 25784,
            "lut_memory": 1133,
            "lut_dram": 388,
            "lut_srl": 745,
            "ff_total": 16693,
            "dsp48": 210,
            "bram_tiles": 8.5,
            "ramb36": 8,
            "ramb18": 1,
            "carry4": 3960,
            "part": "7a200tffg1156-2",
        },
    ),
    (
        "generated-files-syn-tb-pipe-dec/chacha20_block_step/vivado_1CLK_d7b761f3.log",
        {},  # values unknown up front; only checked for "parses, has LUTs+FFs"
    ),
)


def selftest(base_dir):
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


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("target", nargs="?", help="a vivado*.log file, or a pypelinec out_dir")
    ap.add_argument("--json", action="store_true", help="emit JSON instead of a table")
    ap.add_argument("--per-module", action="store_true", help="also parse per-module OOC logs (out_dir target)")
    ap.add_argument("--selftest", action="store_true", help="parse known logs and check known values")
    args = ap.parse_args()

    if args.selftest:
        sys.exit(selftest(os.path.dirname(os.path.abspath(__file__))))
    if not args.target:
        ap.error("need a log file or out_dir (or --selftest)")

    if os.path.isdir(args.target):
        result = parse_out_dir(args.target, per_module=args.per_module)
        if args.json:
            print(json.dumps(result, indent=1))
        else:
            print(format_area(result["top"]) if result["top"] else "no top-level log found")
            for name, mod in sorted(result["per_module"].items()):
                print(f"  {name:<60} LUT {mod.get('lut_total')} FF {mod.get('ff_total')} "
                      f"DSP {mod.get('dsp48')} BRAM {mod.get('bram_tiles')}")
    else:
        parsed = parse_log(args.target)
        print(json.dumps(parsed, indent=1) if args.json else format_area(parsed))


if __name__ == "__main__":
    main()
