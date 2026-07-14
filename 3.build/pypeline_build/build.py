#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
# SPDX-License-Identifier: BSD-3-Clause

import argparse
import os
import sys
import subprocess
import shutil

def main():
    parser = argparse.ArgumentParser(description="Unified build script for ChaCha20Poly1305 Pypeline design.")
    
    # Design Selection (Mutually Exclusive)
    design_group = parser.add_mutually_exclusive_group()
    design_group.add_argument("--enc", action="store_true", help="Select encrypt design")
    design_group.add_argument("--dec", action="store_true", help="Select decrypt design")
    design_group.add_argument("--shared", action="store_true", help="Select shared encrypt+decrypt design (Default)")

    # Build Configuration
    parser.add_argument("--comb", action="store_true", help="Combinational (zero pipeline stages) build. If omitted, defaults to pipelined.")
    parser.add_argument("--sim", action="store_true", help="Enable running simulation. If omitted, builds final Verilog.")
    parser.add_argument("--syn_tb", action="store_true", help="Select synthesizable test bench (_syn_tb_). Otherwise non-syn (_sim_) style.")
    parser.add_argument("--native", action="store_true", help="Select native python build/sim. Otherwise normal cocotb ghdl style vhdl sim.")

    args = parser.parse_args()

    # 1. Determine Design Details
    if args.enc:
        design_name = "encrypt"
        design_short = "enc"
    elif args.dec:
        design_name = "decrypt"
        design_short = "dec"
    else:
        # Default behavior: Shared design
        design_name = "encrypt_decrypt_shared"
        design_short = "shared"

    pipelinec_bin = os.environ.get("PIPELINEC")
    if not pipelinec_bin:
        print("WARNING: $PIPELINEC environment variable not set. Falling back to 'pipelinec' in PATH.")
        pipelinec_bin = "pipelinec"

    # 2. Map Cycle Counts (Derived from original scripts)
    # Map key: (design_short, is_syn_tb, is_comb) -> run cycles
    run_cycles = {
        ("dec", False, True): "1350",   # standalone decrypt, non-syn tb, comb native
        ("shared", False, True): "2400",# shared, non-syn tb, comb native
        ("dec", True, True): "380",     # standalone decrypt, syn tb, comb
        ("shared", True, True): "600",  # shared, syn tb, comb
        ("dec", True, False): "900",    # standalone decrypt, syn tb, pipelined
        ("shared", True, False): "1200",# shared, syn tb, pipelined
    }
    
    # 3. Construct Build Parameters
    if not args.sim:
        # --- VERILOG BUILD PATH ---
        # Default behavior with no args generates final shared verilog 
        dir_suffix = design_name if design_name != "encrypt_decrypt_shared" else "shared"
        out_dir = f"./build.py-generated-files-verilog-{dir_suffix}"
        src_file = f"./src/chacha20poly1305_{design_name}.py"
        
        cmd = [
            pipelinec_bin, src_file, 
            "--out_dir", out_dir, 
            "--top", f"chacha20poly1305_{design_name}", 
            "--verilog"
        ]
        
    else:
        # --- SIMULATION BUILD PATH ---
        tb_type = "syn_tb" if args.syn_tb else "tb"
        src_file = f"./src/chacha20poly1305_{design_name}_{tb_type}.py"
        
        # Construct directory name based on flags
        dir_parts = ["build.py-generated-files"]
        dir_parts.append("syn-tb" if args.syn_tb else "sim")
        dir_parts.append("comb" if args.comb else "pipe")
        dir_parts.append(design_short)
        if args.native:
            dir_parts.append("native")
            
        out_dir = "./" + "-".join(dir_parts)
        
        cmd = [pipelinec_bin, src_file, "--out_dir", out_dir, "--sim"]
        
        if args.comb:
            cmd.append("--comb")
            
        if not args.native:
            cmd.extend(["--cocotb", "--ghdl"])
            
        # Look up run cycles. If a novel combination is used (e.g., enc), fallback to 'dec' equivalents or a default.
        cycle_key = (design_short if design_short != "enc" else "dec", args.syn_tb, args.comb)
        cycles = run_cycles.get(cycle_key, "1000") # Default to 1000 if not mapped
        cmd.extend(["--run", cycles])

    # 4. Execute standard directory cleanup and pipelinec command
    print(f"--- Preparing output directory: {out_dir} ---")
    os.makedirs(out_dir, exist_ok=True)
    # Replicating `rm -rf ./<dir>/*`
    for filename in os.listdir(out_dir):
        file_path = os.path.join(out_dir, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print(f'Failed to delete {file_path}. Reason: {e}')

    cmd_str = " ".join(cmd)
    print(f"--- Running Command ---\n{cmd_str}\n")
    
    try:
        subprocess.run(cmd_str, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Build failed with exit code {e.returncode}")
        sys.exit(e.returncode)

if __name__ == "__main__":
    main()
