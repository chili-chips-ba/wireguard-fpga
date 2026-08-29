# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone decrypt design + its synthesizable-style
testbench (fixed 10-string vectors baked into hardware register arrays at
elaboration time). For the non-synthesizable @sim_input/@sim_output variant
(on-the-fly random vectors), see chacha20poly1305_decrypt_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_decrypt_tb.c.
(The C #define SIMULATION -> here: the flattened hardware IO module
chacha20poly1305_decrypt_hw_io is simply not imported.)

Build/sim (from pypeline_build/): ./build_syn_tb_comb_dec.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, sim_finish, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import decrypt_dataflow  # noqa: F401
import decrypt_syn_tb  # noqa: F401


# decrypt_syn_tb() only signals completion via its decrypt_all_done Wire, rather
# than calling sim_finish() itself -- see decrypt_syn_tb.py and
# chacha20poly1305_encrypt_syn_tb.py's matching checker for why.
#
# @wires: nothing here to actually synthesize/measure a path delay for --
# see encrypt_syn_tb_finish_checker's matching comment.
@MAIN
@wires
def decrypt_syn_tb_finish_checker():
    if decrypt_syn_tb.decrypt_all_done:
        sim_finish()
