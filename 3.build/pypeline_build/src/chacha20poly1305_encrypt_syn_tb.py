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

from pypeline import MAIN, PART, sim_finish

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow  # noqa: F401
import encrypt_syn_tb  # noqa: F401


# encrypt_syn_tb() only signals completion via its encrypt_all_done Wire, rather
# than calling sim_finish() itself, so that the shared build (which runs it
# alongside decrypt_syn_tb() in one simulation) can wait for both testbenches --
# see encrypt_syn_tb.py. For this solo build only encrypt's own flag matters.
@MAIN
def encrypt_syn_tb_finish_checker():
    if encrypt_syn_tb.encrypt_all_done:
        sim_finish()
