# pyright: reportInvalidTypeForm=none
"""Simulation top: the selected design (-D DESIGN=encrypt|decrypt|shared) with
each enabled direction's non-synthesizable testbench (@sim_input/@sim_output,
on-the-fly random packets). In the combined design both testbenches run at the
same time against the selected sharing configuration (-D SHARE). For the
synthesizable-style variant (fixed vectors), see chacha20poly1305_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL): @sim_input/@sim_output calls
are elaborated away for any real-VHDL path. Without --comb, pypelinec first
autopipelines and then native-sims the built latencies.

Build/sim (from pypeline_build/): ./build.py --enc|--dec|--shared --sim --native [--comb]
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env

from pypeline import MAIN, PART, sim_finish, sim_output, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
if wireguard_env.ENCRYPT:
    import encrypt_dataflow  # noqa: F401
    import encrypt_tb
if wireguard_env.DECRYPT:
    import decrypt_dataflow  # noqa: F401
    import decrypt_tb
import tb_common_sim as common


# Each direction's checker state (_enc_state/_dec_state) is plain Python state,
# invisible to the elaborator like the rest of these @sim_input/@sim_output
# testbenches, so it is safe to read here. Stop only once EVERY enabled
# direction is done (encrypt: NUM_RANDOM_PACKETS, decrypt: NUM_TOTAL_PACKETS),
# or whichever finishes first would silently cut off the other's remaining
# checks.
@sim_output
def check_done():
    if wireguard_env.ENCRYPT and encrypt_tb._enc_state["out_packet_idx"] < common.NUM_RANDOM_PACKETS:
        return
    if wireguard_env.DECRYPT and decrypt_tb._dec_state["out_packet_idx"] < decrypt_tb.NUM_TOTAL_PACKETS:
        return
    sim_finish()


# @wires: nothing here to actually synthesize/measure a path delay for -- see
# chacha20poly1305_syn_tb.py's matching checker comment (this variant never
# reaches real synthesis anyway, per the module docstring, but marking it
# keeps the pattern consistent with the syn_tb checker).
@MAIN(wireguard_env.TARGET_MHZ)
@wires
def tb_finish_checker():
    check_done()
