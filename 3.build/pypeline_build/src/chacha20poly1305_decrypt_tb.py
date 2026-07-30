# pyright: reportInvalidTypeForm=none
"""Simulation top for the standalone decrypt design + its non-synthesizable
testbench (@sim_input/@sim_output, 10 + 1 on-the-fly random packets). For
the synthesizable-style variant (fixed 8-string vectors + 1 fixed
tampered-tag packet), see chacha20poly1305_decrypt_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL, no real autopipelining):
@sim_input/@sim_output calls are elaborated away entirely for any real-VHDL
path, so this variant has no cocotb/pipe equivalent.

Build/sim (from pypeline_build/): ./build_sim_comb_dec_native.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, sim_finish, sim_output, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import decrypt_dataflow  # noqa: F401
import decrypt_tb  # noqa: F401


# decrypt_tb.check_out()'s _dec_state dict is plain Python state, invisible
# to the elaborator -- see chacha20poly1305_encrypt_tb.py's matching checker
# for why this is safe.
@sim_output
def check_done():
    if decrypt_tb._dec_state["out_packet_idx"] >= decrypt_tb.NUM_TOTAL_PACKETS:
        sim_finish()


# @wires: nothing here to actually synthesize/measure a path delay for -- see
# chacha20poly1305_encrypt_syn_tb.py's matching checker comment.
@MAIN
@wires
def decrypt_tb_finish_checker():
    check_done()
