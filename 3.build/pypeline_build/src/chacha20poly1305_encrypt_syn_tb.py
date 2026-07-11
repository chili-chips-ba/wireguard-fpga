# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone encrypt design + its synthesizable-style
testbench (fixed 8-string vectors baked into hardware register arrays at
elaboration time). For the non-synthesizable @sim_input/@sim_output variant
(on-the-fly random vectors), see chacha20poly1305_encrypt_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt_tb.c.
(The C #define SIMULATION -> here: the flattened hardware IO module
chacha20poly1305_encrypt_hw_io is simply not imported.)

Build/sim (from pypeline_build/): ./build_syn_tb_comb.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow  # noqa: F401
import encrypt_syn_tb  # noqa: F401
