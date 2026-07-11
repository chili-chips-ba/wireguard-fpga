# pyright: reportInvalidTypeForm=none
"""Simulation top for the shared encrypt+decrypt design — both the encrypt
and decrypt side non-synthesizable testbenches (@sim_input/@sim_output,
on-the-fly random vectors) running at the same time against the design
sharing one ChaCha20 compute pipeline. For the synthesizable-style variant
(fixed 8-string vectors), see chacha20poly1305_encrypt_decrypt_shared_syn_tb.py.

Only runs under native --sim (no cocotb/GHDL, no real autopipelining):
@sim_input/@sim_output calls are elaborated away entirely for any real-VHDL
path, so this variant has no cocotb/pipe equivalent.

Build/sim (from pypeline_build/): ./build_sim_comb_shared_native.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
# Both testbenches at once
import encrypt_tb  # noqa: F401
import decrypt_tb  # noqa: F401
