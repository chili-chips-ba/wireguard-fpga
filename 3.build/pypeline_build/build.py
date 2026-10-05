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
from poly1305_config import (
    IMPLEMENTATIONS, selected_implementation, implementation_out_dir,
    TARGETS_MHZ, default_target_mhz, target_out_dir, starting_latencies,
    add_sharing_arguments, sharing_from_args, sharing_name, sharing_out_dir,
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    design = parser.add_mutually_exclusive_group()
    design.add_argument("--enc", action="store_true", help="Encrypt top")
    design.add_argument("--dec", action="store_true", help="Decrypt top")
    design.add_argument("--shared", action="store_true", help="Share both ChaCha20 and Poly1305 MCPs (default)")
    add_sharing_arguments(parser)
    parser.add_argument("--poly1305", choices=IMPLEMENTATIONS,
                        help="MAC architecture (WG_POLY1305_IMPL, otherwise pipelined)")
    parser.add_argument("--target-mhz", type=int, choices=TARGETS_MHZ,
                        help="Clock goal (default: sharing-both 60 MHz, other pipelined 30 MHz, legacy 80 MHz)")
    parser.add_argument("--sim", action="store_true", help="Run simulation instead of producing Verilog")
    parser.add_argument("--comb", action="store_true", help="Simulate without automatic slicing")
    parser.add_argument("--syn_tb", action="store_true", help="Use the fixed-vector synthesizable testbench")
    parser.add_argument("--native", action="store_true", help="Use native simulation instead of cocotb/GHDL")
    parser.add_argument("--perf", action="store_true",
                        help="Shared QoR testbench; implies --sim --native (used by measure.py)")
    parser.add_argument("-j", "--jobs", type=int,
                        help="Maximum concurrent synthesis jobs (use 1 on low-RAM systems)")
    parser.add_argument("--continue", dest="continue_build", action="store_true",
                        help="Keep the selected output directory and reuse valid build caches")
    parser.add_argument("--out-dir", help="Separate output cache (must be empty unless --continue)")
    args = parser.parse_args()

    if args.jobs is not None and args.jobs < 1:
        parser.error("--jobs must be at least 1")
    if args.perf:
        if args.enc or args.dec:
            parser.error("--perf supports only the shared top; measure.py --dirs selects measured directions")
        if args.syn_tb:
            parser.error("--perf and --syn_tb select different testbenches")
        args.sim = args.native = True
    try:
        args.poly1305 = selected_implementation(args.poly1305)
        sharing = sharing_from_args(args, standalone=args.enc or args.dec)
    except ValueError as exc:
        parser.error(str(exc))
    if args.target_mhz is None:
        args.target_mhz = default_target_mhz(args.poly1305, sharing)
    build_env = dict(os.environ, WG_POLY1305_IMPL=args.poly1305,
                     WG_TARGET_MHZ=str(args.target_mhz),
                     WG_SHARE_CHACHA20=str(int(sharing["chacha20"])),
                     WG_SHARE_POLY1305=str(int(sharing["poly1305"])))

    if args.enc:
        design_name, design_short = "encrypt", "enc"
    elif args.dec:
        design_name, design_short = "decrypt", "dec"
    else:
        design_name, design_short = "encrypt_decrypt_shared", "shared"

    pipelinec_bin = os.environ.get("PYPELINEC") or "pypelinec"
    if args.sim:
        tb_type = "perf_tb" if args.perf else "syn_tb" if args.syn_tb else "tb"
        src_file = f"./src/chacha20poly1305_{design_name}_{tb_type}.py"
        kind = "perf" if args.perf else "syn-tb" if args.syn_tb else "sim"
        dir_parts = ["generated-files", kind, "comb" if args.comb else "pipe", design_short]
        if args.native:
            dir_parts.append("native")
        out_dir = "./" + "-".join(dir_parts)
        options = ["--sim"]
        if args.comb:
            options.append("--comb")
        if not args.native:
            options.extend(["--cocotb", "--ghdl"])
        options.extend(["--run", "all"])  # Testbenches finish themselves.
    else:
        src_file = f"./src/chacha20poly1305_{design_name}.py"
        suffix = "shared" if design_short == "shared" else design_name
        out_dir = f"./generated-files-verilog-{suffix}"
        options = ["--top", f"chacha20poly1305_{design_name}", "--verilog"]

    out_dir = target_out_dir(sharing_out_dir(implementation_out_dir(out_dir, args.poly1305), sharing), args.target_mhz)
    if args.out_dir:
        out_dir = args.out_dir
    cmd = [pipelinec_bin, src_file, "--out_dir", out_dir] + options
    if not (args.sim and args.comb):
        cmd.append("--stop_on_over_capacity")
    if args.jobs is not None:
        cmd.extend(["-j", str(args.jobs)])

    print(f"--> {design_short}: Poly1305 {args.poly1305}, clock target {args.target_mhz} MHz")
    print(f"--> Shared resources: {sharing_name(sharing)}")
    print(f"--> Automatic starting latencies: {starting_latencies(args.target_mhz)}")
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
        subprocess.run(cmd, env=build_env, check=True)
    except subprocess.CalledProcessError as exc:
        print(f"Build failed with exit code {exc.returncode}")
        return exc.returncode
    return 0


if __name__ == "__main__":
    sys.exit(main())
