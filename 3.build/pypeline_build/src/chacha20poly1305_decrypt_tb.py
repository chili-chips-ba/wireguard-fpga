# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone decrypt design + its testbench.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_decrypt_tb.c.
(The C #define SIMULATION -> here: the flattened hardware IO module
chacha20poly1305_decrypt_hw_io is simply not imported.)

Build/sim (from pypeline_build/): ./build_sim_comb_dec.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import decrypt_dataflow  # noqa: F401
import decrypt_tb  # noqa: F401
