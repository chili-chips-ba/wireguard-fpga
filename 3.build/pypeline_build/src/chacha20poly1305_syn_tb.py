# pyright: reportInvalidTypeForm=none
"""Simulation top: the selected design (-D DESIGN=encrypt|decrypt|shared) with
each enabled direction's synthesizable-style testbench (fixed 10-string
vectors baked into hardware register arrays at elaboration time, plus
decrypt's tampered-tag packet). In the combined design both testbenches run
at the same time against the selected sharing configuration (-D SHARE). For
the non-synthesizable @sim_input/@sim_output variant (on-the-fly random
vectors), see chacha20poly1305_tb.py.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_{encrypt,decrypt,
encrypt_decrypt_shared}_tb.c. (The C #define SIMULATION -> here: the
flattened hardware IO modules chacha20poly1305_*_hw_io are simply not
imported.)

Build/sim (from pypeline_build/): ./build.py --enc|--dec|--shared --sim --syn_tb [--comb] [--native]
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env

from pypeline import MAIN, PART, sim_finish, uint1_t, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

ENCRYPT = wireguard_env.ENCRYPT
DECRYPT = wireguard_env.DECRYPT

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
if ENCRYPT:
    import encrypt_dataflow  # noqa: F401
    import encrypt_syn_tb
if DECRYPT:
    import decrypt_dataflow  # noqa: F401
    import decrypt_syn_tb


# Each syn_tb only signals completion through its own *_all_done Wire, rather
# than calling sim_finish() itself, so that the combined design (both
# testbenches in one simulation) can wait for both: encrypt has 10 packets and
# decrypt 11, so they don't finish at the same time, and stopping at the first
# would silently skip the other's remaining checks. ENCRYPT/DECRYPT are
# elaboration-time constants, so only the enabled directions' wires are read.
#
# @wires (#pragma FUNC_WIRES): this checker is pure control-flow around
# sim_finish() -- a void, simulation-only builtin with no real output -- so it
# has nothing to actually synthesize/measure a path delay for either; without
# @wires it was still sent through real per-function synthesis for
# pre-pipelining path-delay estimation (see LOGIC_IS_ZERO_DELAY in SYN.py,
# which checks parser_state.func_marked_wires -- what @wires sets -- before
# ever reaching the is_c_built_in/IS_SIM_CTRL_FUNC_NAME check that only
# applies to the sim_finish() submodule instance itself, not its containing
# MAIN).
@MAIN(wireguard_env.TARGET_MHZ)
@wires
def syn_tb_finish_checker():
    done: uint1_t = 1
    if ENCRYPT:
        done = done & encrypt_syn_tb.encrypt_all_done
    if DECRYPT:
        done = done & decrypt_syn_tb.decrypt_all_done
    if done:
        sim_finish()
