# pyright: reportInvalidTypeForm=none
"""Simulation top for the shared encrypt+decrypt design — both the encrypt
and decrypt side non-synthesizable testbenches (@sim_input/@sim_output,
on-the-fly random vectors) running at the same time against the design
using the selected independent ChaCha20/Poly1305 sharing configuration.
For the synthesizable-style variant
(fixed 10-string vectors), see chacha20poly1305_encrypt_decrypt_shared_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL):
@sim_input/@sim_output calls are elaborated away entirely for any real-VHDL
path. Without --comb, synthesis discovers the real automatic latencies and
the native simulator models them; stimulus/checkers still remain Python.

Build/sim (from pypeline_build/): ./build.py --shared --sim --comb --native
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, sim_finish, sim_output, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
# Both testbenches at once
import encrypt_tb  # noqa: F401
import decrypt_tb  # noqa: F401
import tb_common_sim as common


# Both encrypt_tb() and decrypt_tb() run concurrently in this build, each
# generating/checking its own random packets independently -- only stop the
# whole simulation once BOTH are done (encrypt: 12 packets, decrypt: 13), or
# whichever finishes first would silently cut off the other's remaining
# checks. See chacha20poly1305_encrypt_tb.py's matching checker for why
# referencing _enc_state/_dec_state directly here is safe.
@sim_output
def check_both_done():
    if (
        encrypt_tb._enc_state["out_packet_idx"] >= common.NUM_RANDOM_PACKETS
        and decrypt_tb._dec_state["out_packet_idx"] >= decrypt_tb.NUM_TOTAL_PACKETS
    ):
        sim_finish()


# @wires: nothing here to actually synthesize/measure a path delay for -- see
# chacha20poly1305_encrypt_syn_tb.py's matching checker comment.
@MAIN
@wires
def shared_tb_finish_checker():
    check_both_done()
