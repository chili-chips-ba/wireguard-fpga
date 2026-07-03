# pyright: reportInvalidTypeForm=none
"""prep_auth_data instance for the decrypt design: globally visible wires +
the FSM MAIN.

Pypeline port of ../pipelinec_build/src/prep_auth_data/prep_auth_data.c with
PREP_AUTH_DATA_INST=prep_auth_data_decrypt
(wire names elaborate as prep_auth_data_decrypt_<wire>).
"""
import pypeline_env  # noqa: F401

from pypeline import MAIN, Wire, uint1_t, uint8_t

import prep_auth_data

from aead_types import AAD_MAX_LEN, axis128_t

# Additional authenticated data input wires
aad: Wire[uint8_t[AAD_MAX_LEN]]  # input
aad_len: Wire[uint8_t]  # input
# Input stream of ciphertext
axis_in: Wire[axis128_t]  # input
axis_in_ready: Wire[uint1_t]  # output
# Output stream of authenticated data
axis_out: Wire[axis128_t]  # output
axis_out_ready: Wire[uint1_t]  # input


@MAIN
def prep_auth_data_decrypt():
    fsm_out = prep_auth_data.prep_auth_data_fsm(aad, aad_len, axis_in, axis_out_ready)
    axis_in_ready = fsm_out.ready_for_axis_in
    axis_out = fsm_out.axis
