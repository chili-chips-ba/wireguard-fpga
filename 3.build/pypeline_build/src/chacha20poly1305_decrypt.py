# pyright: reportInvalidTypeForm=none
"""Hardware top for the standalone ChaCha20-Poly1305 decrypt design, with
flattened top level IO ports.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_decrypt.c.

Build (from pypeline_build/): ./build_verilog_decrypt.sh
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pypeline_env  # noqa: F401

from pypeline import PART

PART("xc7a200tffg1156-2")  # Artix 7 200T

# All hardware modules must be imported by this top file
# (sub-module imports are not followed for hardware elaboration)
import aead_types  # noqa: F401
import chacha20  # noqa: F401
import chacha20_decrypt  # noqa: F401
import prep_auth_data  # noqa: F401
import prep_auth_data_decrypt  # noqa: F401
import poly1305  # noqa: F401
import poly1305_mac_decrypt  # noqa: F401
import poly1305_verify_decrypt  # noqa: F401
import strip_auth_tag  # noqa: F401
import wait_to_verify  # noqa: F401
import chacha20poly1305_decrypt_ports  # noqa: F401
import chacha20poly1305_decrypt_hw_io  # noqa: F401
import decrypt_dataflow  # noqa: F401
