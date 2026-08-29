# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone encrypt design + its non-synthesizable
testbench (@sim_input/@sim_output, 10 on-the-fly random packets). For the
synthesizable-style variant (fixed 10-string vectors), see
chacha20poly1305_encrypt_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL, no real autopipelining):
@sim_input/@sim_output calls are elaborated away entirely for any real-VHDL
path, so this variant has no cocotb/pipe equivalent.

Build/sim (from pypeline_build/): ./build_sim_comb_native.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, sim_finish, sim_output, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow  # noqa: F401
import encrypt_tb  # noqa: F401
import tb_common_sim as common


# encrypt_tb.check_out()'s _enc_state dict is plain Python state, invisible to
# the elaborator like the rest of this @sim_input/@sim_output-based
# testbench -- safe to reference it directly from another @sim_output-marked
# function and call sim_finish() once the last packet is confirmed, ending
# native simulation without a hand-tuned --run cycle count.
@sim_output
def check_done():
    if encrypt_tb._enc_state["out_packet_idx"] >= common.NUM_RANDOM_PACKETS:
        sim_finish()


# @wires: nothing here to actually synthesize/measure a path delay for -- see
# chacha20poly1305_encrypt_syn_tb.py's matching checker comment (this variant
# never reaches real synthesis anyway, per the module docstring, but marking
# it keeps the pattern consistent with the syn_tb checkers).
@MAIN
@wires
def encrypt_tb_finish_checker():
    check_done()
