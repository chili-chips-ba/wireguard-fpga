#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause

"""Build the encrypt, decrypt, or shared WireGuard hardware, or simulate it.

Without --sim this builds the real top (src/chacha20poly1305.py, real ports) for the selected
profile. A pipelined native simulation (--sim --native or --perf, without --comb) runs its
testbench in that build's output directory, on the hardware built there: no elaboration or
synthesis of the testbench.
"""

import argparse
import json
import os
import re
import shlex
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "src"))
from wireguard_env import (
    IMPLEMENTATIONS, selected_target, GENERATED_FILES,
    MULT_IMPLEMENTATIONS, DATA_BITWIDTHS, COMPUTE_IMPLEMENTATIONS,
    profile_from_args, profile_out_dir, hardware_out_dir, BUILT_HARDWARE_FILE,
    add_sharing_arguments, sharing_name, share_name_for,
    PUBLISHED_MEASUREMENT, SYN_CACHE_DIR,
)

# Design parameters this script sets from its own flags (see src/wireguard_env.py)
PROFILE_PARAMS = ("DESIGN", "DATA_BITWIDTH", "POLY1305_IMPL", "POLY1305_BLOCKS_PER_CYCLE", "POLY1305_MULT_IMPL", "POLY1305_COMPUTE_IMPL", "POLY1305_PROLOGUE_MAX_LATENCY", "POLY1305_EPILOGUE_MAX_LATENCY", "SHARE", "TARGET_MHZ")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    design = parser.add_mutually_exclusive_group()
    design.add_argument("--enc", action="store_true", help="Encrypt top")
    design.add_argument("--dec", action="store_true", help="Decrypt top")
    design.add_argument("--shared", action="store_true", help="Explicitly share both ChaCha20 and Poly1305 compute")
    add_sharing_arguments(parser)
    parser.add_argument("--poly1305", choices=IMPLEMENTATIONS,
                        help="MAC architecture (default pipelined)")
    parser.add_argument("--data-bitwidth", type=int, choices=DATA_BITWIDTHS,
                        help="Encrypt/decrypt packet datapath width in bits (default 256; legacy 128)")
    parser.add_argument("--poly1305-mult", choices=MULT_IMPLEMENTATIONS,
                        help="130-bit multiply implementation (default inferred_body; legacy inferred)")
    parser.add_argument("--poly1305-compute", choices=COMPUTE_IMPLEMENTATIONS,
                        help="Prologue/epilogue implementation (default: published QoR profile)")
    parser.add_argument("--poly1305-prologue-cap", type=int, metavar="N",
                        help="AUTO_FSM prologue cap (default: published QoR profile; fsm only)")
    parser.add_argument("--poly1305-epilogue-cap", type=int, metavar="N",
                        help="AUTO_FSM epilogue cap (default: published QoR profile; fsm only)")
    parser.add_argument("--target-mhz", type=selected_target,
                        help="Clock goal (default: 256-bit inferred_body 80 MHz; other profiles retain their clock)")
    parser.add_argument("--sim", action="store_true",
                        help="Simulate instead of building the hardware; a pipelined native run "
                             "simulates the hardware already built for this profile")
    parser.add_argument("--verilog", action="store_true",
                        help="Also convert the built hardware top to Verilog (GHDL + Yosys)")
    parser.add_argument("--comb", action="store_true", help="Simulate without automatic slicing")
    parser.add_argument("--syn_tb", action="store_true", help="Use the fixed-vector synthesizable testbench")
    parser.add_argument("--native", action="store_true", help="Use native simulation instead of cocotb/GHDL")
    parser.add_argument("--perf", action="store_true",
                        help="Shared QoR testbench; implies --sim --native (used by measure.py)")
    parser.add_argument("-D", "--define", action="append", default=[], metavar="NAME=VALUE",
                        help="Pass a design parameter on to pypelinec, e.g. -D TB_STRESS=1 or "
                             "-D PERF_SIZES=64,1420 (the profile itself comes from the flags above)")
    parser.add_argument("-j", "--jobs", type=int,
                        help="Maximum concurrent synthesis jobs (use 1 on low-RAM systems)")
    parser.add_argument("--continue", dest="continue_build", action="store_true",
                        help="Keep the selected output directory and reuse valid build caches")
    parser.add_argument("--rebuild", action="store_true",
                        help="Build the hardware even when its output directory already holds "
                             "a build of these exact inputs (pypelinec --rebuild); by default "
                             "pypelinec reports such a build as up to date and does nothing")
    parser.add_argument("--out-dir", help="Separate output cache (must be empty unless --continue); "
                                          "a pipelined native simulation runs on the hardware built there")
    parser.add_argument("--latency-hints", action="append", default=[], metavar="FILE",
                        help="Starting AUTO_PIPELINE latencies for pypelinec --latency_hints "
                             "(repeatable; a start like start_latency=, never a fixed depth)")
    parser.add_argument("--pipeline-min-effort", type=int, metavar="N",
                        help="pypelinec --pipeline_min_effort: extra syntheses spent trimming stages "
                             "after timing is met (0 accepts the first met result)")
    parser.add_argument("--show-config", action="store_true", help="Print the resolved profile and cache paths without building")
    parser.add_argument("--syn-cache", default=None,
                        metavar="DIR|none",
                        help="Synthesis store every profile's output directory shares, so a run "
                             "whose exact inputs were already synthesized is reused "
                             "(default: generated-files/syn_cache; 'none' disables it)")
    args = parser.parse_args()

    if args.jobs is not None and args.jobs < 1:
        parser.error("--jobs must be at least 1")
    if args.verilog and args.sim:
        parser.error("--verilog converts the built hardware; it does not apply to --sim")
    if args.rebuild and (args.sim or args.perf):
        parser.error("--rebuild builds the hardware; it does not apply to --sim")
    if args.perf:
        if args.enc or args.dec:
            parser.error("--perf supports only the shared top; measure.py --dirs selects measured directions")
        if args.syn_tb:
            parser.error("--perf and --syn_tb select different testbenches")
        args.sim = args.native = True
    for define in args.define:
        name = define.partition("=")[0].strip()
        if name in PROFILE_PARAMS:
            parser.error(f"-D {name}: set the profile with this script's flags "
                         "(--enc/--dec/--shared, --share-*, --poly1305, --poly1305-mult, --poly1305-compute, --poly1305-prologue-cap, --poly1305-epilogue-cap, --data-bitwidth, --target-mhz)")
    try:
        resolved = profile_from_args(args, standalone=args.enc or args.dec)
        sharing = resolved["sharing"]
    except ValueError as exc:
        parser.error(str(exc))

    if args.enc:
        design_param, design_name, design_short = "encrypt", "encrypt", "enc"
    elif args.dec:
        design_param, design_name, design_short = "decrypt", "decrypt", "dec"
    else:
        design_param, design_name, design_short = "shared", "encrypt_decrypt_shared", "shared"
    resolved["design"] = design_param
    here = os.path.dirname(os.path.abspath(__file__))
    if args.syn_cache is None:
        args.syn_cache = os.path.join(here, SYN_CACHE_DIR)
    defines = [
        f"DESIGN={design_param}",
        f"POLY1305_IMPL={args.poly1305}",
        f"DATA_BITWIDTH={args.data_bitwidth}",
        f"POLY1305_MULT_IMPL={args.poly1305_mult}",
        f"POLY1305_COMPUTE_IMPL={args.poly1305_compute}",
        f"POLY1305_PROLOGUE_MAX_LATENCY={args.poly1305_prologue_cap}",
        f"POLY1305_EPILOGUE_MAX_LATENCY={args.poly1305_epilogue_cap}",
        f"SHARE={share_name_for(sharing)}",
        f"TARGET_MHZ={args.target_mhz}",
    ] + args.define

    pipelinec_bin = os.environ.get("PYPELINEC") or "pypelinec"
    profile = (args.poly1305, sharing, args.poly1305_mult, args.poly1305_compute,
               args.target_mhz, args.data_bitwidth, args.poly1305_prologue_cap, args.poly1305_epilogue_cap)
    hardware_dir = args.out_dir or hardware_out_dir(design_short, *profile)
    if not args.out_dir and os.path.isfile(os.path.join(hardware_dir, BUILT_HARDWARE_FILE)):
        args.continue_build = True
    if args.show_config:
        print(json.dumps(dict(published_measurement=PUBLISHED_MEASUREMENT, profile=resolved,
                              out_dir=hardware_dir, syn_cache=args.syn_cache,
                              latency_hints=args.latency_hints), indent=2))
        return 0
    # Timing and stage counts come only from the real top: a testbench's synthesis can
    # remove logic its constant stimulus never exercises, so its timing misjudges the design
    on_built_hardware = args.sim and args.native and not args.comb
    if args.sim:
        tb_type = "perf_tb" if args.perf else "syn_tb" if args.syn_tb else "tb"
        src_file = f"./src/chacha20poly1305_{tb_type}.py"
        kind = "perf" if args.perf else "syn-tb" if args.syn_tb else "sim"
        dir_parts = [kind, "comb" if args.comb else "pipe", design_short]
        if args.native:
            dir_parts.append("native")
        out_dir = (hardware_dir if on_built_hardware
                   else args.out_dir or profile_out_dir("-".join(dir_parts), *profile))
        options = ["--sim"]
        if args.comb:
            options.append("--comb")
        if not args.native:
            options.extend(["--cocotb", "--ghdl"])
        options.extend(["--run", "all"])  # Testbenches finish themselves.
    else:
        src_file = "./src/chacha20poly1305.py"
        out_dir = hardware_dir
        # The Verilog module keeps the name each design always had
        options = ["--top", f"chacha20poly1305_{design_name}"]
        if args.verilog:
            options.append("--verilog")
        if args.rebuild:
            options.append("--rebuild")
    if on_built_hardware and not os.path.exists(os.path.join(out_dir, BUILT_HARDWARE_FILE)):
        parser.error(f"{out_dir} holds no hardware build that met timing: build it first with "
                     "this profile's flags and no --sim")
    cmd = [pipelinec_bin, src_file, "--out_dir", out_dir] + options
    for define in defines:
        cmd.extend(["-D", define])
    if not (args.sim and args.comb):
        cmd.append("--stop_on_over_capacity")
    if args.jobs is not None:
        cmd.extend(["-j", str(args.jobs)])
    if args.syn_cache != "none":
        cmd.extend(["--syn_cache", args.syn_cache])
    for hints in args.latency_hints:
        cmd.extend(["--latency_hints", os.path.abspath(hints)])
    if args.pipeline_min_effort is not None:
        cmd.extend(["--pipeline_min_effort", str(args.pipeline_min_effort)])
    print(f"--> {design_short}: Poly1305 {args.poly1305}, clock target {args.target_mhz} MHz")
    print(f"--> Packet datapath: {args.data_bitwidth} bits; Poly1305 blocks/cycle: {args.data_bitwidth // 128}")
    print(f"--> Poly1305 multiplier: {args.poly1305_mult}")
    print(f"--> Poly1305 prologue/epilogue: {args.poly1305_compute}"
          + (f" (prologue/epilogue caps {args.poly1305_prologue_cap}/{args.poly1305_epilogue_cap})"
             if args.poly1305_compute == "fsm" else ""))
    print(f"--> Shared resources: {sharing_name(sharing)}")
    if on_built_hardware:
        print(f"--> Simulating the hardware built in {out_dir}")
    else:
        prepare_out_dir(parser, args, out_dir)

    print(f"\n--- Running Command ---\n{shlex.join(cmd)}\n")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as exc:
        print(f"Build failed with exit code {exc.returncode}")
        return exc.returncode
    if not args.sim and design_short == "shared":
        mismatches = direction_latency_mismatches(out_dir)
        if mismatches:
            print("Build rejected: encrypt and decrypt instantiate identical hardware, but the "
                  "build gave them different latencies:\n  " + "\n  ".join(mismatches))
            return 1
    return 0


def direction_latency_mismatches(out_dir):
    """Every AUTO_PIPELINE and AUTO_FSM latency that differs between an encrypt instance
    and its decrypt twin (the same key with the other direction), or that only one
    direction built. A generated key's _s<digest> hashes its source, direction included,
    so pairing ignores it."""
    with open(os.path.join(out_dir, BUILT_HARDWARE_FILE)) as f:
        built = json.load(f)
    latencies = dict(built["auto_pipeline_latencies"])
    latencies.update({key: schedule["latency"] for key, schedule in built["auto_fsm_schedules"].items()})
    by_shape = {re.sub(r"_s[0-9a-f]{12}(?=_|$)", "", key): (key, latency)
                for key, latency in latencies.items()}
    direction = re.compile(r"(?<![^_])(encrypt|decrypt)(?![^_])")
    mismatches = []
    for shape, (key, latency) in sorted(by_shape.items()):
        found = direction.findall(shape)
        if len(found) != 1:
            continue
        twin_shape = direction.sub("decrypt" if found[0] == "encrypt" else "encrypt", shape)
        if twin_shape not in by_shape:
            mismatches.append(f"{key}: {latency}; {twin_shape}: not built")
        elif found[0] == "encrypt" and by_shape[twin_shape][1] != latency:
            twin_key, twin_latency = by_shape[twin_shape]
            mismatches.append(f"{key}: {latency}; {twin_key}: {twin_latency}")
    return mismatches


def prepare_out_dir(parser, args, out_dir):
    print(f"--- Preparing output directory: {out_dir} ---")
    os.makedirs(out_dir, exist_ok=True)
    if args.out_dir and not args.continue_build and os.listdir(out_dir):
        parser.error("Custom --out-dir is not empty; choose a fresh directory or use --continue")
    if args.continue_build:
        print("--> --continue active: Keeping output directory.")
    else:
        print("--> Clearing output directory...")
        for filename in os.listdir(out_dir):
            file_path = os.path.join(out_dir, filename)
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)


if __name__ == "__main__":
    sys.exit(main())
