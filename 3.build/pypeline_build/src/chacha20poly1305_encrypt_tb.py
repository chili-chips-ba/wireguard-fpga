# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone encrypt design + its non-synthesizable
testbench (@sim_input/@sim_output, 10 on-the-fly random packets). For the
synthesizable-style variant (fixed 8-string vectors), see
chacha20poly1305_encrypt_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL, no real autopipelining):
@sim_input/@sim_output calls are elaborated away entirely for any real-VHDL
path, so this variant has no cocotb/pipe equivalent.

Build/sim (from pypeline_build/): ./build_sim_comb_native.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow  # noqa: F401
import encrypt_tb  # noqa: F401
