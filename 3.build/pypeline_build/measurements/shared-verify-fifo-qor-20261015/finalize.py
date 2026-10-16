# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause
"""Archive six-size native QoR after matching synthesis confirms, then publish."""
import argparse
import datetime
import json
import os
from pathlib import Path
import shutil
import sys
import time

sys.dont_write_bytecode = True
from replay_native import RECORD, ROOT, digest, prepare, read_json

CONFIG = read_json(RECORD / "replay-config.json")
RUN = Path(CONFIG["run_directory"])
BUILD = Path(CONFIG["synthesis_build"])


def readiness():
    pending = []
    status_file = RUN / "full-qor-status.json"
    if not status_file.exists():
        pending.append("six-size native run has not started")
    else:
        try:
            status = read_json(status_file)
        except json.JSONDecodeError:
            return ["native completion status is being written"]
        if status.get("running"):
            pending.append("six-size native run is running")
        elif status.get("exit_code") != 0:
            raise ValueError("Six-size native run failed: " + str(status))
    history_file = BUILD / "top/sweep_history.json"
    try:
        complete = history_file.exists() and read_json(history_file).get("build_complete")
    except json.JSONDecodeError:
        complete = False
    if not complete:
        pending.append("final synthesis confirmation is pending")
        console = RUN / "qor-console.log"
        if console.exists() and "ERROR: no perf JSON" in console.read_text():
            raise ValueError("Synthesis/build stopped; inspect qor-console.log")
    return pending


def validate_inputs():
    config, compiler, source, out_dir = prepare()
    for rel, expected in config["design_source_sha256"].items():
        if digest(ROOT / "src" / rel) != expected:
            raise ValueError("Working design changed during measurement: " + rel)
    history = read_json(BUILD / "top/sweep_history.json")
    if not history["build_complete"] or history["fit_status"] != "within_reported_limits":
        raise ValueError("Synthesis is incomplete or does not fit")
    if not all(main["final"]["met"] for main in history["mains"].values()):
        raise ValueError("Final synthesis timing failed")
    retained = history["retained_observation"]
    actual_ap = {key.rsplit(":", 1)[-1]: value for key, value in retained["latencies"].items()
                 if key.startswith("AUTO_PIPELINE:")}
    actual_main = {key[len("MAIN:"):]: value for key, value in retained["latencies"].items()
                   if key.startswith("MAIN:")}
    if actual_ap != config["auto_pipeline_latencies"]:
        raise ValueError("Final compute pipeline depths differ from the replay; rerun with actual depths")
    if actual_main != config["main_latencies"]:
        raise ValueError("Final MAIN latencies differ from the replay")
    if retained["auto_multi_cycle_ncycles"] != config["auto_multi_cycle_latencies"]:
        raise ValueError("Final MCP cycle counts differ from the replay")
    raw = read_json(RUN / "full-qor_raw.json")
    expected_checks = len(config["measurement_sizes"]) * config["packets_per_size"] * 2
    if not raw["checks"]["functional_pass"] or raw["checks"]["packets_checked"] != expected_checks:
        raise ValueError("The complete reference packet checks did not pass")
    if not raw["sim"]["finalized"]:
        raise ValueError("Six-size native run did not finalize")
    if [phase["packet_bytes"] for phase in raw["phases"]] != config["measurement_sizes"]:
        raise ValueError("Incomplete or reordered packet-size plan")
    if any(phase["num_packets"] != config["packets_per_size"] for phase in raw["phases"]):
        raise ValueError("Packet count differs from the recorded workload")
    if raw["config"]["poly1305_mult_impl"] != "hybrid_square" or raw["config"]["target_mhz"] != 80:
        raise ValueError("Replay profile differs from the synthesized profile")
    component = read_json(RECORD / "verification-component.json")
    if not component["passed"] or component["peak_occupancy"] != 513 or component["packets"] != 8:
        raise ValueError("Full-capacity plaintext verification test did not pass")
    for rel, expected in read_json(RECORD / "publication-inputs.json").items():
        if digest(ROOT / rel) != expected:
            raise ValueError("Documentation changed during measurement; review before publishing: " + rel)
    return compiler, history, raw


def completed_replay(args, json_path, log_path):
    """Ordinary measure.py reporting, using independently completed evidence."""
    status = read_json(RUN / "full-qor-status.json")
    shutil.copyfile(RUN / "full-qor_raw.json", json_path)
    synthesis_log = (RUN / "qor/pypelinec.log").read_text()
    replay_log = (RUN / "full-qor.log").read_text()
    Path(log_path).write_text(synthesis_log + "\n=== Separate six-size native replay; matching final depths ===\n" + replay_log)
    return {"cmd": "python3 " + str(RECORD / "replay_native.py"), "returncode": status["exit_code"],
            "wall_s": status["elapsed_seconds"], "clock_lines": read_json(RUN / "full-qor_raw.json")["sim"]["total_cycles"],
            "pipelinec_git": CONFIG["compiler_revision"] + "-dirty"}


def comparison(results):
    pre = read_json(ROOT / "measurements" / CONFIG["pre_overlap_record"] / "results.json")
    overlap = read_json(ROOT / "measurements" / CONFIG["comparison_record"] / "results.json")
    new = next(phase for phase in results["phases"] if phase["packet_bytes"] == 1920)
    old = next(phase for phase in pre["phases"] if phase["packet_bytes"] == 1920)
    accepted = next(phase for phase in overlap["phases"] if phase["packet_bytes"] == 1920)
    rows = []
    for direction in ("encrypt", "decrypt"):
        rate = new[direction]["sustained_bytes_per_cycle"] * .68
        old_rate = old[direction]["sustained_bytes_per_cycle"] * .68
        overlap_rate = accepted[direction]["sustained_bytes_per_cycle"] * .68
        rows.append(dict(direction=direction, packet_bytes=1920, packet_period_cycles=new[direction]["packet_period_cycles"],
                         pre_overlap_gbps=old_rate, accepted_overlap_gbps=overlap_rate, new_gbps=rate,
                         gain_from_pre_overlap_percent=100 * (rate / old_rate - 1),
                         gain_from_accepted_overlap_percent=100 * (rate / overlap_rate - 1)))
    return dict(common_clock_mhz=85, target_gain_percent=20,
                targets_met=all(row["gain_from_pre_overlap_percent"] >= 20 for row in rows), rows=rows)


def document_text(results, report):
    """Replace current-result prose; historical detail remains in its archives."""
    import measure
    enc, dec = report["rows"]
    area, fmax = results["area"], results["fmax"]["design_mhz"]
    full = "16, 64, 256, 1024, 1420 and 1920 bytes"
    link = "measurements/" + RECORD.name
    rate_text = f"{enc['new_gbps']:.3f} Gb/s encrypt / {dec['new_gbps']:.3f} Gb/s decrypt"
    gains = f"{enc['gain_from_pre_overlap_percent']:.1f}% encrypt / {dec['gain_from_pre_overlap_percent']:.1f}% decrypt"
    synopsis = (
        f"**Measured verification FIFO recovery, 2026-10-16:** all 48 concurrent\n"
        f"reference checks passed across six packet sizes, with body II=1, buffer\n"
        f"conservation and final synthesis timing/fit accepted. At a common 85 MHz,\n"
        f"1920-byte payload goodput is **{rate_text}**,\n"
        f"improving **{gains}** over the pre-overlap baseline.\n"
        f"The shared performance-testbench top uses **{area['dsp48']}/740 DSPs**,\n"
        f"**{area['lut_total']:,} LUTs** and **{fmax:.3f} MHz** limiting synthesis fmax.\n"
        f"The synthesis constraint remains **80 MHz**; the 85 MHz comparison scales\n"
        f"the measured cycles within that confirmed fmax. See the\n"
        f"[full measurement and reproduction]({link}/README.md),\n"
        f"[stall comparison]({link}/investigation.md) and\n"
        f"[Poly1305 design notes](src/poly1305/throughput.md#plaintext-verification-storage).\n\n")
    current = (ROOT / "README.md").read_text()
    start = current.index("<!-- VERIFY-FIFO-PENDING:BEGIN -->")
    end = current.index("Pipelined decrypt buffers ciphertext", start)
    current = current[:start] + synopsis + current[end:]
    start = current.index("### Current results:")
    end = current.index("### Re-measuring without re-synthesizing", start)
    table = measure.markdown_table(results, include_mac_details=False)
    section = (
        f"### Current results: verification FIFO recovery, 80 MHz synthesis\n\n"
        f"Four packets per direction ran concurrently at {full},\n"
        f"seed 8439 and all internal taps. All 48 reference checks, context ownership\n"
        f"assertions, body II=1 and buffer accounting passed. An independent full-FIFO\n"
        f"stress test passed eight packets with mixed verdicts and output stalls.\n"
        f"Area is the shared performance-testbench top. Routed timing and external-port\n"
        f"area were not measured. The table reports the 80 MHz target and measured fmax.\n\n"
        f"Synthesis and native replay use the same frozen PipelineC working tree at\n"
        f"base revision `{CONFIG['compiler_revision']}`. The compiler manifest and\n"
        f"archived design sources identify the dirty bytes. Publication checked that\n"
        f"the replay's 19/8/8 pipeline and 12/8 MCP counts match the final synthesized\n"
        f"implementation. Reproduction and archived evidence are in the\n"
        f"[measurement README]({link}/README.md).\n\n"
        f"<!-- MEASURED-RESULTS:BEGIN -->\n\n{measure._stamp(results)}\n\n{table}\n\n"
        f"<!-- MEASURED-RESULTS:END -->\n\n"
        f"<!-- BLOCK-RESULTS:BEGIN -->\n\n"
        f"Detailed per-block stalls, stage occupancy and shared-service counters are\n"
        f"in the [block report]({link}/blocks.md).\n\n<!-- BLOCK-RESULTS:END -->\n\n"
        f"#### Interpretation: packet lifecycle at 1920 bytes\n\n"
        f"At 85 MHz, the measured packet periods give **{rate_text}**\n"
        f"and gains of **{gains}** over the original sequential\n"
        f"controller. Each packet authenticates 123 blocks: 120 payload blocks,\n"
        f"two padded AAD blocks and one length block. The two directions issue\n"
        f"and retire 492 body blocks each over the four-packet burst at II=1.\n"
        f"Setup, drain and finalization overlap adjacent packets; their phase\n"
        f"counts must not be summed as sequential packet overhead.\n\n"
        f"The plaintext verification FIFO now has 512 memory beats plus one FWFT\n"
        f"output beat, from a conservative 307-beat bound. This relieves pressure\n"
        f"on the ordered shared ChaCha results. The measured counters and the\n"
        f"[comparison]({link}/comparison.md) retain the exact remaining stalls.\n"
        f"The [accepted overlap record](measurements/{CONFIG['comparison_record']}/README.md)\n"
        f"and [pre-overlap baseline](measurements/{CONFIG['pre_overlap_record']}/README.md)\n"
        f"are preserved unchanged. Four packets give three completion intervals,\n"
        f"rather than a long contention-window measurement.\n\n")
    current = current[:start] + section + current[end:]
    current = current.replace(
        "The current\noverlap record documents a native replay of the completed reviewed80 handoff\nwith a fresh compiler snapshot, without rerunning synthesis.",
        "The current\nrecord combines a complete six-size native replay with matching final\nsynthesis of the changed FIFO design.")
    notes = (ROOT / "src/poly1305/throughput.md").read_text()
    start = notes.index("The current\nsource implements packet overlap")
    end = notes.index("## Measured packet overlap, 2026-10-15")
    notes = notes[:start] + (
        f"The current source combines packet overlap with automatically sized\n"
        f"plaintext verification storage. All 48 concurrent reference checks at\n"
        f"{full}, body II=1, buffer conservation and\n"
        f"final synthesis timing/fit passed. At 1920 bytes and a common 85 MHz,\n"
        f"payload goodput is **{rate_text}**, gaining\n"
        f"**{gains}** over the pre-overlap controller.\n"
        f"The shared performance-testbench top uses {area['lut_total']:,} LUTs,\n"
        f"{area['ff_total']:,} FFs, {area['dsp48']} DSPs and {area['bram_tiles']} BRAM tiles,\n"
        f"with {fmax:.3f} MHz limiting synthesis fmax under an 80 MHz constraint.\n"
        f"Routed timing and external-port area remain untested. See the\n"
        f"[full measurement](../../{link}/README.md),\n"
        f"[current README table](../../README.md#current-results-hybrid-karatsuba-and-squaring-sharing-both-85-mhz)\n"
        f"and [storage derivation](#plaintext-verification-storage). The accepted\n"
        f"packet-overlap and pre-overlap checkpoints below remain historical records.\n\n") + notes[end:]
    notes = notes.replace(
        "The changed storage requires its own\nnative validation and synthesis timing/fit evidence before replacing that\naccepted QoR result.",
        f"The changed storage passed the full six-size\nnative run, independent full-capacity stress and new synthesis timing/fit\nchecks in the [verification FIFO record](../../{link}/README.md).")
    return {"README.md": current, "src/poly1305/throughput.md": notes}


def finalize(update_readme):
    compiler, history, raw = validate_inputs()
    os.environ["PYPELINEC"] = str(compiler / "src/pypelinec")
    sys.path.insert(0, str(ROOT))
    import measure
    old_run_build, old_argv = measure.run_build, sys.argv
    measure.run_build = completed_replay
    sys.argv = [str(ROOT / "measure.py"), "--shared", "--poly1305", "pipelined",
                "--poly1305-mult", "hybrid_square", "--target-mhz", "80",
                "--sizes", "16,64,256,1024,1420,1920", "--packets", "4", "--peak-bytes", "0",
                "--dirs", "both", "--taps", "all", "--seed", "8439", "--no-per-module-area",
                "--reuse-syn", "--out-dir", str(BUILD), "--label", RECORD.name]
    try:
        rc = measure.main()
    finally:
        measure.run_build, sys.argv = old_run_build, old_argv
    if rc:
        raise ValueError("Ordinary measurement acceptance failed; inspect results.json")
    results = read_json(RECORD / "results.json")
    results["provenance"]["native_replay"] = {
        "configuration": "replay-config.json", "compiler_manifest": "compiler-snapshot.json",
        "compute_latencies_match_final_synthesis": True,
        "source_sha256": CONFIG["design_source_sha256"], "simulation_exit_code": 0,
        "new_synthesis_runs_by_finalizer": 0,
        "synthesis_input_signature": history["retained_observation"]["input_signature"]}
    (RECORD / "results.json").write_text(json.dumps(results, indent=1) + "\n")
    for src, dst in [("full-qor-status.json", "native-status.json"), ("full-qor.log", "native-replay.log")]:
        shutil.copyfile(RUN / src, RECORD / dst)
    report = comparison(results)
    if results["fmax"]["design_mhz"] < 85:
        raise ValueError("New synthesis does not support the common 85 MHz comparison clock")
    if not report["targets_met"]:
        raise ValueError("1920-byte improvement target was missed; review before publishing")
    (RECORD / "comparison.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = ["Payload goodput at a common 85 MHz; exact archived packet periods determine gains.", "",
             "| Direction | Pre-overlap Gb/s | Accepted overlap Gb/s | New Gb/s | Gain from pre-overlap | Period (clocks) |",
             "| --- | ---: | ---: | ---: | ---: | ---: |"]
    for row in report["rows"]:
        lines.append(f"| {row['direction']} | {row['pre_overlap_gbps']:.3f} | {row['accepted_overlap_gbps']:.3f} | "
                     f"{row['new_gbps']:.3f} | {row['gain_from_pre_overlap_percent']:.1f}% | {row['packet_period_cycles']:.3f} |")
    (RECORD / "comparison.md").write_text("\n".join(lines) + "\n")
    old_phase = next(p for p in read_json(ROOT / "measurements" / CONFIG["comparison_record"] / "results.json")["phases"] if p["packet_bytes"] == 1920)
    phase = next(p for p in results["phases"] if p["packet_bytes"] == 1920)
    taps = ["decrypt/wtv.axis_in", "decrypt/chacha20.from_pipeline", "encrypt/chacha20.to_pipeline"]
    text = ["# Verification storage and shared ChaCha pressure", "",
            "The accepted overlap measurement is preserved unchanged. At 1920 bytes:", "",
            "| Probe stalled clocks | Accepted overlap | Verification FIFO candidate |",
            "| --- | ---: | ---: |"]
    for tap in taps:
        text.append(f"| `{tap}` | {old_phase['taps'][tap]['stall_cycles']} | {phase['taps'][tap]['stall_cycles']} |")
    occupancy = phase["taps"]["decrypt/verify_fifo.occupancy"]
    text += ["", f"Verification FIFO high water: {occupancy['high_water_beats']}/{occupancy['capacity_beats']} beats; "
             f"end occupancy {occupancy['end_occupancy']}. All {occupancy['accepted_beats']} admitted beats "
             f"were retired. All native assertions and measurement guards passed.", "",
             "This storage intervention supports verification backpressure through the ordered shared",
             "ChaCha results as the prior cross-direction throughput limit. Aggregate counters",
             "do not give an exact cycle-by-cycle causal partition. Four packets provide three",
             "completion intervals per direction; the result is not a long contention-window limit."]
    (RECORD / "investigation.md").write_text("\n".join(text) + "\n")
    readme = (RECORD / "README.md").read_text()
    start, end = "<!-- STATUS:BEGIN -->", "<!-- STATUS:END -->"
    status = (f"Accepted: all 48 reference checks across six packet sizes, body II=1, buffer\n"
              f"conservation, shared MCP HDL audit, final synthesis timing/device fit and\n"
              f"the independent full-FIFO stress check passed. Limiting fmax is\n"
              f"{results['fmax']['design_mhz']:.3f} MHz. See [the full table](summary.md),\n"
              f"[comparison](comparison.md), [stall investigation](investigation.md) and\n"
              f"[block report](blocks.md).")
    readme = readme[:readme.index(start)+len(start)] + "\n\n" + status + "\n\n" + readme[readme.index(end):]
    readme = readme.replace(
        "One full native replay is running; packet sizes are simulation parameters,\n"
        "so no additional synthesis build is needed for the missing curve points.",
        "The full native run completed on 2026-10-16 with all 48 checks passing\n"
        "in 2275 clocks. Packet sizes are simulation parameters; no additional\n"
        "synthesis build was needed for the complete curve.")
    readme = readme.replace(
        "The already-running ordinary synthesis/native build uses:",
        "Reproduce the confirmed synthesis and its focused native workload with:")
    (RECORD / "README.md").write_text(readme)
    measure.save_evidence(str(RECORD), results)
    for name in (CONFIG["comparison_record"], CONFIG["pre_overlap_record"]):
        check = measure.check_record(ROOT / "measurements" / name)
        if not check["passed"]:
            raise ValueError("Accepted comparison archive failed integrity: " + str(check))
    documents = document_text(results, report)
    for rel, text in documents.items():
        (RUN / (Path(rel).name + ".ready")).write_text(text)
    published_hashes = {}
    if update_readme:
        for rel, text in documents.items():
            target = ROOT / rel
            temporary = target.with_name(target.name + ".qor-tmp")
            temporary.write_text(text)
            temporary.replace(target)
            published_hashes[rel] = digest(target)
    return dict(passed=True, published=update_readme, measurement=str(RECORD),
                archive_verified=True, documentation_sha256=published_hashes)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--wait", action="store_true", help="Wait in background for existing jobs")
    parser.add_argument("--update-readme", action="store_true", help="Publish accepted current results")
    parser.add_argument("--check-ready", action="store_true", help="Read-only readiness check")
    args = parser.parse_args()
    status_file = RUN / "publication-status.json"
    try:
        previous_status = read_json(status_file) if status_file.exists() else {}
    except json.JSONDecodeError:
        # A disk-full interruption in an earlier run may have truncated it.
        previous_status = {}
    if previous_status.get("published"):
        print("Already published; use measure.py --check-record to inspect the archive.")
        return 0
    try:
        previous = None
        while True:
            pending = readiness()
            if args.check_ready:
                print(json.dumps(dict(ready=not pending, pending=pending), indent=2))
                return 0
            if not pending:
                break
            if pending != previous:
                print("Waiting: " + "; ".join(pending), flush=True)
                previous = pending
            if not args.wait:
                return 2
            time.sleep(30)
        status = finalize(args.update_readme)
    except Exception as exc:
        status = dict(passed=False, published=False, error=repr(exc))
        print("Publication stopped:", exc, file=sys.stderr)
    status["finished_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    temporary_status = status_file.with_suffix(".json.tmp")
    temporary_status.write_text(json.dumps(status, indent=2) + "\n")
    temporary_status.replace(status_file)
    return 0 if status["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
