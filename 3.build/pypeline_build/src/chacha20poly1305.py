# pyright: reportInvalidTypeForm=none
"""Hardware top for ChaCha20-Poly1305, with flattened top level IO ports.

-D DESIGN=encrypt|decrypt|shared selects the encrypt direction, the decrypt
direction, or both (the default). In the combined design, -D SHARE selects
which of the ChaCha20 pipeline and the Poly1305 prologue/epilogue MCPs the two
directions share (both by default). MAC bodies and packet state stay private.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_{encrypt,decrypt,
encrypt_decrypt_shared}.c.

Build (from pypeline_build/): ./build.py --enc | --dec | --shared
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
if wireguard_env.ENCRYPT:
    import chacha20poly1305_encrypt_hw_io  # noqa: F401
    import encrypt_dataflow  # noqa: F401
if wireguard_env.DECRYPT:
    import chacha20poly1305_decrypt_hw_io  # noqa: F401
    import decrypt_dataflow  # noqa: F401
