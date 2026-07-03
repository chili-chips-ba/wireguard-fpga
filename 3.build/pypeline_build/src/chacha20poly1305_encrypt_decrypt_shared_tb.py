# pyright: reportInvalidTypeForm=none
"""Simulation top for the shared encrypt+decrypt design — both the encrypt
and decrypt side testbenches running at the same time against the design
sharing one ChaCha20 compute pipeline.

Pypeline port of ../pipelinec_build/src/chacha20poly1305_encrypt_decrypt_shared_tb.c.

Build/sim (from pypeline_build/): ./build_sim_comb_shared.sh
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
# The shared parts between encrypt and decrypt: the big compute pipeline
import chacha20_pipeline_shared  # noqa: F401
# The encrypt specific part of the shared design
import chacha20_encrypt_shared  # noqa: F401
import prep_auth_data  # noqa: F401
import prep_auth_data_encrypt  # noqa: F401
import poly1305  # noqa: F401
import poly1305_mac_encrypt  # noqa: F401
import append_auth_tag  # noqa: F401
import chacha20poly1305_encrypt_ports  # noqa: F401
import encrypt_dataflow_shared  # noqa: F401
# The decrypt specific part of the shared design
import chacha20_decrypt_shared  # noqa: F401
import prep_auth_data_decrypt  # noqa: F401
import poly1305_mac_decrypt  # noqa: F401
import poly1305_verify_decrypt  # noqa: F401
import strip_auth_tag  # noqa: F401
import wait_to_verify  # noqa: F401
import chacha20poly1305_decrypt_ports  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401
# Both testbenches at once
import encrypt_tb  # noqa: F401
import decrypt_tb  # noqa: F401
