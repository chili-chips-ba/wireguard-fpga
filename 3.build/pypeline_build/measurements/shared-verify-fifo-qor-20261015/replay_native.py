# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause
"""Replay the frozen verification-FIFO design without invoking synthesis."""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import re
import sys
import tarfile
import time
import traceback

sys.dont_write_bytecode = True
RECORD = Path(__file__).resolve().parent
ROOT = RECORD.parents[1]


def read_json(path):
    return json.loads(Path(path).read_text())


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def prepare(compiler=None, out_dir=None):
    """Verify compiler identity and restore the exact archived Python sources."""
    config = read_json(RECORD / "replay-config.json")
    compiler = Path(compiler or config["simulation_compiler"]).resolve()
    out_dir = Path(out_dir or config["run_directory"]).resolve()
    for rel, expected in read_json(RECORD / config["compiler_manifest"])["files"].items():
        if digest(compiler / rel) != expected:
            raise ValueError("Compiler snapshot changed: " + rel)
    source = out_dir / "src"
    if not source.exists():
        with tarfile.open(RECORD / config["source_archive"], "r:gz") as archive:
            for rel in config["design_source_sha256"]:
                if Path(rel).is_absolute() or ".." in Path(rel).parts:
                    raise ValueError("Invalid archived source path")
                target = source / rel
                target.parent.mkdir(parents=True, exist_ok=True)
                member = archive.getmember("src/" + rel)
                if not member.isfile():
                    raise ValueError("Archived source is not a regular file: " + rel)
                target.write_bytes(archive.extractfile(member).read())
    for rel, expected in config["design_source_sha256"].items():
        if digest(source / rel) != expected:
            raise ValueError("Frozen design changed: " + rel)
    sys.path[:0] = [str(compiler / "src"), str(compiler / "include/pypeline"), str(source)]
    return config, compiler, source, out_dir


class LogOutput:
    def __init__(self, log):
        self.log, self.pending, self.cycles = log, "", 0
        self.start = time.monotonic()

    def write(self, value):
        self.pending += value
        while "\n" in self.pending:
            line, self.pending = self.pending.split("\n", 1)
            if re.fullmatch(r"Clock:\s*\d+", line.strip()):
                self.cycles += 1
                if self.cycles % 25 == 0:
                    self.log.write(f"Progress: {self.cycles} cycles, {time.monotonic()-self.start:.1f} s\n")
            elif line.strip():
                self.log.write(line + "\n")
            self.log.flush()
        return len(value)

    def flush(self):
        self.log.flush()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, help="Matching frozen compiler snapshot")
    parser.add_argument("--out-dir", type=Path, help="Replay output/source cache")
    parser.add_argument("--sizes", default="16,64,256,1024,1420,1920")
    parser.add_argument("--packets", type=int, default=4)
    parser.add_argument("--name", default="full-qor")
    args = parser.parse_args()
    config, compiler, source, out_dir = prepare(args.compiler, args.out_dir)
    import pypeline
    import pypeline_sim
    params = dict(config["design_params"])
    params.update(PERF_SIZES=args.sizes, PERF_PACKETS=args.packets,
                  PERF_JSON=str(out_dir / (args.name + "_raw.json")), TB_STRESS=0)
    pypeline.SET_DESIGN_PARAMS({key: ",".join(map(str, value)) if isinstance(value, list)
                              else str(value) for key, value in params.items()})
    status = dict(running=True, started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  source=str(source), compiler=str(compiler), params=params, kind="perf",
                  compute_latencies_replayed=True, synthesis_performed=False)
    status_file = out_dir / (args.name + "-status.json")
    status_file.write_text(json.dumps(status, indent=2) + "\n")
    start = time.monotonic()
    old_out, old_err = sys.stdout, sys.stderr
    rc = 0
    with (out_dir / (args.name + ".log")).open("w") as log:
        sys.stdout = sys.stderr = LogOutput(log)
        try:
            pypeline_sim.run_sim(str(source / "chacha20poly1305_perf_tb.py"), "all",
                main_latencies=config["main_latencies"],
                auto_pipeline_latencies=config["auto_pipeline_latencies"],
                auto_multi_cycle_latencies=config["auto_multi_cycle_latencies"])
        except BaseException as exc:
            rc = 130 if isinstance(exc, KeyboardInterrupt) else 1
            status["error"] = repr(exc)
            traceback.print_exc()
        finally:
            sys.stdout, sys.stderr = old_out, old_err
            status.update(running=False, exit_code=rc, elapsed_seconds=time.monotonic()-start,
                          finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
            status_file.write_text(json.dumps(status, indent=2) + "\n")
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
