# pyright: reportInvalidTypeForm=none
"""Hardware top for the combined encrypt+decrypt design with external ports.

ChaCha20 pipeline and Poly1305 prologue/epilogue sharing are independently
selected; sharing both is the default. MAC bodies and packet state are private.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt_decrypt_shared.c.

Build (from pypeline_build/): ./build.py --shared
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import chacha20poly1305_encrypt_hw_io  # noqa: F401
import chacha20poly1305_decrypt_hw_io  # noqa: F401
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
