#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause

"""Build or simulate the encrypt, decrypt, or shared WireGuard top."""

import argparse
import os
import shlex
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "src"))
from wireguard_env import (
    IMPLEMENTATIONS, selected_implementation, implementation_out_dir,
    selected_target, default_target_mhz, target_out_dir, GENERATED_FILES,
    MULT_IMPLEMENTATIONS, selected_mult, mult_out_dir,
    DATA_BITWIDTHS, selected_data_bitwidth, blocks_out_dir,
    COMPUTE_IMPLEMENTATIONS, selected_compute, compute_out_dir,
    selected_prologue_cap, prologue_cap_out_dir,
    add_sharing_arguments, sharing_from_args, sharing_name, sharing_out_dir, share_name_for,
)

# Design parameters this script sets from its own flags (see src/wireguard_env.py)
PROFILE_PARAMS = ("DESIGN", "DATA_BITWIDTH", "POLY1305_IMPL", "POLY1305_BLOCKS_PER_CYCLE", "POLY1305_MULT_IMPL", "POLY1305_COMPUTE_IMPL", "POLY1305_PROLOGUE_MAX_LATENCY", "SHARE", "TARGET_MHZ")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    design = parser.add_mutually_exclusive_group()
    design.add_argument("--enc", action="store_true", help="Encrypt top")
    design.add_argument("--dec", action="store_true", help="Decrypt top")
    design.add_argument("--shared", action="store_true", help="Share both ChaCha20 and Poly1305 compute (default)")
    add_sharing_arguments(parser)
    parser.add_argument("--poly1305", choices=IMPLEMENTATIONS,
                        help="MAC architecture (default pipelined)")
    parser.add_argument("--data-bitwidth", type=int, choices=DATA_BITWIDTHS, default=128,
                        help="Encrypt/decrypt packet datapath width in bits (default 128; ChaCha20 block stays 512)")
    parser.add_argument("--poly1305-mult", choices=MULT_IMPLEMENTATIONS,
                        help="130-bit multiply implementation (default hybrid_square; legacy inferred)")
    parser.add_argument("--poly1305-compute", choices=COMPUTE_IMPLEMENTATIONS,
                        help="Prologue and epilogue implementation (default fsm; pipelined MAC only)")
    parser.add_argument("--poly1305-prologue-cap", type=int, metavar="N",
                        help="AUTO_FSM latency cap of the prologue services (default 64; fsm compute only)")
    parser.add_argument("--target-mhz", type=selected_target,
                        help="Clock goal (default: sharing-both 85 MHz, other pipelined 30 MHz, legacy 80 MHz)")
    parser.add_argument("--sim", action="store_true", help="Run simulation instead of producing Verilog")
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
    parser.add_argument("--out-dir", help="Separate output cache (must be empty unless --continue)")
    parser.add_argument("--latency-hints", action="append", default=[], metavar="FILE",
                        help="Starting AUTO_PIPELINE latencies for pypelinec --latency_hints "
                             "(repeatable; a start like start_latency=, never a fixed depth)")
    parser.add_argument("--pipeline-min-effort", type=int, metavar="N",
                        help="pypelinec --pipeline_min_effort: extra syntheses spent trimming stages "
                             "after timing is met (0 accepts the first met result)")
    parser.add_argument("--syn-cache", default=os.path.join(".", GENERATED_FILES, "syn_cache"),
                        metavar="DIR|none",
                        help="Synthesis store every profile's output directory shares, so a run "
                             "whose exact inputs were already synthesized is reused "
                             "(default generated-files/syn_cache; 'none' disables it)")
    args = parser.parse_args()

    if args.jobs is not None and args.jobs < 1:
        parser.error("--jobs must be at least 1")
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
                         "(--enc/--dec/--shared, --share-*, --poly1305, --poly1305-mult, --poly1305-compute, --poly1305-prologue-cap, --data-bitwidth, --target-mhz)")
    try:
        args.poly1305 = selected_implementation(args.poly1305)
        args.data_bitwidth = selected_data_bitwidth(args.data_bitwidth, args.poly1305)
        args.poly1305_mult = selected_mult(args.poly1305_mult, args.poly1305)
        args.poly1305_compute = selected_compute(args.poly1305_compute)
        args.poly1305_prologue_cap = selected_prologue_cap(args.poly1305_prologue_cap)
        sharing = sharing_from_args(args, standalone=args.enc or args.dec)
    except ValueError as exc:
        parser.error(str(exc))
    if args.target_mhz is None:
        args.target_mhz = default_target_mhz(args.poly1305, sharing)

    if args.enc:
        design_param, design_name, design_short = "encrypt", "encrypt", "enc"
    elif args.dec:
        design_param, design_name, design_short = "decrypt", "decrypt", "dec"
    else:
        design_param, design_name, design_short = "shared", "encrypt_decrypt_shared", "shared"
    defines = [
        f"DESIGN={design_param}",
        f"POLY1305_IMPL={args.poly1305}",
        f"DATA_BITWIDTH={args.data_bitwidth}",
        f"POLY1305_MULT_IMPL={args.poly1305_mult}",
        f"POLY1305_COMPUTE_IMPL={args.poly1305_compute}",
        f"POLY1305_PROLOGUE_MAX_LATENCY={args.poly1305_prologue_cap}",
        f"SHARE={share_name_for(sharing)}",
        f"TARGET_MHZ={args.target_mhz}",
    ] + args.define

    pipelinec_bin = os.environ.get("PYPELINEC") or "pypelinec"
    if args.sim:
        tb_type = "perf_tb" if args.perf else "syn_tb" if args.syn_tb else "tb"
        src_file = f"./src/chacha20poly1305_{tb_type}.py"
        kind = "perf" if args.perf else "syn-tb" if args.syn_tb else "sim"
        dir_parts = [kind, "comb" if args.comb else "pipe", design_short]
        if args.native:
            dir_parts.append("native")
        out_dir = os.path.join(".", GENERATED_FILES, "-".join(dir_parts))
        options = ["--sim"]
        if args.comb:
            options.append("--comb")
        if not args.native:
            options.extend(["--cocotb", "--ghdl"])
        options.extend(["--run", "all"])  # Testbenches finish themselves.
    else:
        src_file = "./src/chacha20poly1305.py"
        suffix = "shared" if design_short == "shared" else design_name
        out_dir = os.path.join(".", GENERATED_FILES, f"verilog-{suffix}")
        # The Verilog module keeps the name each design always had
        options = ["--top", f"chacha20poly1305_{design_name}", "--verilog"]

    out_dir = target_out_dir(compute_out_dir(mult_out_dir(sharing_out_dir(
        implementation_out_dir(out_dir, args.poly1305), sharing), args.poly1305_mult),
        args.poly1305_compute if args.poly1305 == "pipelined" else None), args.target_mhz)
    out_dir = blocks_out_dir(out_dir, args.data_bitwidth // 128)
    if args.poly1305 == "pipelined" and args.poly1305_compute == "fsm":
        out_dir = prologue_cap_out_dir(out_dir, args.poly1305_prologue_cap)
    if args.out_dir:
        out_dir = args.out_dir
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
          + (f" (prologue cap {args.poly1305_prologue_cap})" if args.poly1305_compute == "fsm" else ""))
    print(f"--> Shared resources: {sharing_name(sharing)}")
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

    print(f"\n--- Running Command ---\n{shlex.join(cmd)}\n")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as exc:
        print(f"Build failed with exit code {exc.returncode}")
        return exc.returncode
    return 0


if __name__ == "__main__":
    sys.exit(main())
