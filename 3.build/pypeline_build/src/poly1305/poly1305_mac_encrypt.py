# pyright: reportInvalidTypeForm=none
"""poly1305_mac instance for the encrypt design: globally visible wires +
the multi-cycle-path compute instance + the FSM MAIN.

Pypeline port of ../pipelinec_build/src/poly1305/poly1305_mac.c with
POLY_MAC_INST=poly1305_mac_encrypt
(wire names elaborate as poly1305_mac_encrypt_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, Wire, uint1_t
from multi_cycle_path import make_valid_ready_mcp

import poly1305
from poly1305 import poly1305_mac_loop_body_stream_t, u320_stream_t

from aead_types import (
    axis128_t,
    poly1305_key_stream_t,
    poly1305_auth_tag_stream_t,
)

# Declare poly1305_mac_loop_body compute module to use
# Multi cycle path with valid ready handshake
# (C GLOBAL_VALID_READY_MCP_INST(poly1305_mac_encrypt_compute, u320_t,
#  poly1305_mac_loop_body, poly1305_mac_loop_body_in_t, 4))
compute_in: Wire[poly1305_mac_loop_body_stream_t]
compute_in_ready: Wire[uint1_t]
compute_out: Wire[u320_stream_t]
compute_out_ready: Wire[uint1_t]

compute_mcp, compute_mcp_t = make_valid_ready_mcp(poly1305.poly1305_mac_loop_body, 4)


@MAIN
def poly1305_mac_encrypt_compute():
    result = compute_mcp(compute_in, compute_out_ready)
    compute_out = result.stream_out
    compute_in_ready = result.ready_for_stream_in


# Global input and output wires for FSM
# 32-byte key (r || s) input
key: Wire[poly1305_key_stream_t]  # input
key_ready: Wire[uint1_t]  # output
# 16 byte wide AXIS port for data input
data_in: Wire[axis128_t]
data_in_ready: Wire[uint1_t]
# 16-byte authentication tag output as DVR handshake
auth_tag: Wire[poly1305_auth_tag_stream_t]  # output
auth_tag_ready: Wire[uint1_t]  # input


# FSM that uses compute iteratively to compute poly1305 MAC
@MAIN
def poly1305_mac_encrypt():
    fsm_out = poly1305.poly1305_mac_fsm(
        key,
        data_in,
        auth_tag_ready,
        compute_out.data,
        compute_out.valid,
        compute_in_ready,
    )
    key_ready = fsm_out.ready_for_key
    data_in_ready = fsm_out.ready_for_data_in
    auth_tag = fsm_out.auth_tag
    compute_in_s: poly1305_mac_loop_body_stream_t
    compute_in_s.data = fsm_out.to_compute
    compute_in_s.valid = fsm_out.to_compute_valid
    compute_in = compute_in_s
    compute_out_ready = 1
