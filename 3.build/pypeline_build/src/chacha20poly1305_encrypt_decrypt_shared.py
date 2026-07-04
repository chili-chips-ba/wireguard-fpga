# pyright: reportInvalidTypeForm=none
"""Hardware top for the shared encrypt+decrypt design: encrypt and decrypt
datapaths sharing one ChaCha20 compute pipeline, with both sides' flattened
top level IO ports.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt_decrypt_shared.c.

Build (from pypeline_build/): ./build_verilog_shared.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import chacha20poly1305_encrypt_hw_io  # noqa: F401
import chacha20poly1305_decrypt_hw_io  # noqa: F401
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
