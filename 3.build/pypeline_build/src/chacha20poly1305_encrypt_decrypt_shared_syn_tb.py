# pyright: reportInvalidTypeForm=none
"""Simulation top for the shared encrypt+decrypt design — both the encrypt
and decrypt side synthesizable-style testbenches (fixed 10-string vectors
baked into hardware register arrays at elaboration time) running at the same
time against the design sharing one ChaCha20 compute pipeline. For the
non-synthesizable @sim_input/@sim_output variant (on-the-fly random
vectors), see chacha20poly1305_encrypt_decrypt_shared_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt_decrypt_shared_tb.c.

Build/sim (from pypeline_build/): ./build_syn_tb_comb_shared.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, sim_finish, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
# Both testbenches at once
import encrypt_syn_tb  # noqa: F401
import decrypt_syn_tb  # noqa: F401


# Both encrypt_syn_tb() and decrypt_syn_tb() run concurrently in this build, each
# only signaling completion via its own Wire (not calling sim_finish() itself --
# see encrypt_syn_tb.py/decrypt_syn_tb.py). Encrypt has 10 packets, decrypt has 11,
# so they don't finish at the same time -- only stop the whole simulation once
# BOTH are done, or decrypt's remaining checks would be silently skipped.
#
# @wires: nothing here to actually synthesize/measure a path delay for --
# see encrypt_syn_tb_finish_checker's matching comment.
@MAIN
@wires
def shared_syn_tb_finish_checker():
    if encrypt_syn_tb.encrypt_all_done & decrypt_syn_tb.decrypt_all_done:
        sim_finish()
