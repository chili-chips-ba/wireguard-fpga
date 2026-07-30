# pyright: reportInvalidTypeForm=none
"""Flattened top level ports with AXIS style manager/subordinate naming for
the standalone decrypt design, and the just-wires MAIN converting them to the
nice struct/array wires in chacha20poly1305_decrypt_ports.py.

Only imported by the hardware top (chacha20poly1305_decrypt.py) — the sim
testbench drives the ports wires directly instead
(the C header's #ifndef SIMULATION block).

Pypeline port of the DECL_INPUT/DECL_OUTPUT + io_wires MAIN in
../pipelinec_build/src/chacha20poly1305/chacha20poly1305_decrypt.h.
"""
import wireguard_env  # noqa: F401

from pypeline import (
    MAIN,
    wires,
    Input,
    Output,
    uint1_t,
    uint8_t,
    uint16_t,
    uint_to_array_le,
    array_to_uint_le,
)

import chacha20poly1305_decrypt_ports

from aead_types import (
    key_uint_t,
    nonce_uint_t,
    aad_uint_t,
    uint128_t,
    axis128_intrf,
)

# Top level input wires
decrypt_key: Input[key_uint_t]
decrypt_nonce: Input[nonce_uint_t]
decrypt_aad: Input[aad_uint_t]
decrypt_aad_len: Input[uint8_t]
# Top level input stream of ciphertext w/ auth tag
decrypt_s_axis_tdata: Input[uint128_t]
decrypt_s_axis_tkeep: Input[uint16_t]
decrypt_s_axis_tlast: Input[uint1_t]
decrypt_s_axis_tvalid: Input[uint1_t]
decrypt_s_axis_tready: Output[uint1_t]
# Top level output stream of plaintext
decrypt_m_axis_tdata: Output[uint128_t]
decrypt_m_axis_tkeep: Output[uint16_t]
decrypt_m_axis_tlast: Output[uint1_t]
decrypt_m_axis_tvalid: Output[uint1_t]
decrypt_m_axis_tready: Input[uint1_t]

# Parallel output (verification status)
decrypt_m_verified: Output[uint1_t]


# For real hardware connect top level ports to these wires
@MAIN
@wires
def chacha20poly1305_decrypt_io_wires():
    # Convert flattened multiple input wires to the axis128 stream wire
    axis_in_s: axis128_intrf.stream_t
    axis_in_s.data.frag.data = uint_to_array_le(decrypt_s_axis_tdata, 8)
    axis_in_s.data.frag.keep = uint_to_array_le(decrypt_s_axis_tkeep, 1)
    axis_in_s.data.eod[0] = decrypt_s_axis_tlast
    axis_in_s.valid = decrypt_s_axis_tvalid
    chacha20poly1305_decrypt_ports.axis_in_if.stream = axis_in_s
    decrypt_s_axis_tready = chacha20poly1305_decrypt_ports.axis_in_if.ready
    chacha20poly1305_decrypt_ports.key = uint_to_array_le(decrypt_key, 8)
    chacha20poly1305_decrypt_ports.nonce = uint_to_array_le(decrypt_nonce, 8)
    chacha20poly1305_decrypt_ports.aad = uint_to_array_le(decrypt_aad, 8)
    chacha20poly1305_decrypt_ports.aad_len = decrypt_aad_len
    # Convert the axis128 stream wire to flattened output multiple wires
    decrypt_m_axis_tdata = array_to_uint_le(
        chacha20poly1305_decrypt_ports.axis_out_if.stream.data.frag.data
    )
    decrypt_m_axis_tkeep = array_to_uint_le(
        chacha20poly1305_decrypt_ports.axis_out_if.stream.data.frag.keep
    )
    decrypt_m_axis_tlast = chacha20poly1305_decrypt_ports.axis_out_if.stream.data.eod[0]
    decrypt_m_axis_tvalid = chacha20poly1305_decrypt_ports.axis_out_if.stream.valid
    chacha20poly1305_decrypt_ports.axis_out_if.ready = decrypt_m_axis_tready

    # Connect the parallel verification output wire
    decrypt_m_verified = chacha20poly1305_decrypt_ports.is_verified_out
