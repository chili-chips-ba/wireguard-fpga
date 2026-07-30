# pyright: reportInvalidTypeForm=none
"""Hardware top for the standalone ChaCha20-Poly1305 encrypt design, with
flattened top level IO ports.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt.c.

Build (from pypeline_build/): ./build_verilog.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import chacha20poly1305_encrypt_hw_io  # noqa: F401
import encrypt_dataflow  # noqa: F401
