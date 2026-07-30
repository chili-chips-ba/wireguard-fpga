# pyright: reportInvalidTypeForm=none
"""The decrypt dataflow graph, directly instantiating every component as a
submodule call:
  strip_auth_tag -> [broadcast: prep_auth_data, chacha20]
  chacha20 -> wait_to_verify
  prep_auth_data -> poly1305_mac -> poly1305_verify_decrypt -> wait_to_verify

This is an *interface function*: the body below is the whole design. Every
component's ready signal, and the ordering feedback needed because the graph is
not a straight line, is generated from it -- the body is a one-for-one
transcription of the call graph in the docstring above. `is_verified_out` shows
a plain (non-interface) output riding along in the same return bundle.

The only thing that differs between the standalone build (decrypt_dataflow.py)
and the shared-pipeline build (decrypt_dataflow_shared.py) is which chacha20
instance feeds this graph, so decrypt_dataflow_core is a factory parameterized
by that one callable (mirrors encrypt_dataflow_core's make_encrypt_dataflow_core).
"""
import wireguard_env  # noqa: F401

from pypeline import NamedTuple, uint1_t, uint8_t

from interface.interface import interface
from interface.interface_func import make_hw_func_from_interface_func

import strip_auth_tag
import prep_auth_data
import poly1305
import poly1305_verify_decrypt
import wait_to_verify

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
    axis128_2broadcast,
)


@interface
class decrypt_dataflow_core_ports(NamedTuple):
    axis_out_if: axis128_intrf
    is_verified_out: uint1_t  # plain sideband, no reverse companion


def make_decrypt_dataflow_core(chacha_func):
    """chacha_func(key, nonce, axis_in_if, key_if, axis_out_if) ->
    chacha20.chacha20_ports -- either chacha20.chacha20_instance (owns its own
    private pipeline) or a shared-pipeline instance such as
    chacha20_pipeline_shared.chacha20_decrypt_shared (uses the arbitrated
    shared pipeline)."""

    def decrypt_dataflow_core(
        axis_in_if: axis128_intrf,
        key: uint8_t[CHACHA20_KEY_SIZE],
        nonce: uint8_t[CHACHA20_NONCE_SIZE],
        aad: uint8_t[AAD_MAX_LEN],
        aad_len: uint8_t,
    ) -> decrypt_dataflow_core_ports:
        # strip_auth_tag splits ciphertext+tag into stripped-ciphertext + tag,
        # and the stripped ciphertext forks to the MAC calculation and chacha20
        strip = strip_auth_tag.strip_auth_tag(axis_in_if=axis_in_if)
        bcast = axis128_2broadcast(axis_in_if=strip.axis_out_if)
        # chacha20 decrypts (keystream XOR); its poly key seeds poly1305_mac
        chacha = chacha_func(key=key, nonce=nonce, axis_in_if=bcast.axis_out_if[1])
        # prep_auth_data frames AAD+ciphertext+lengths for the MAC
        prep = prep_auth_data.prep_auth_data_fsm(
            aad=aad, aad_len=aad_len, axis_in_if=bcast.axis_out_if[0]
        )
        # poly1305_mac recomputes the tag from the poly key + the framed data
        mac = poly1305.poly1305_mac_instance(key_if=chacha.key_if, data_in_if=prep.axis_if)
        # ...which is compared against the tag stripped off the input
        verify = poly1305_verify_decrypt.poly1305_verify_decrypt(
            auth_tag_if=strip.auth_tag_out_if, calc_tag_if=mac.auth_tag_if
        )
        # wait_to_verify buffers the plaintext until the match bit arrives
        wtv = wait_to_verify.wait_to_verify(
            axis_in_if=chacha.axis_out_if, verify_bit_if=verify.tags_match_if
        )
        return decrypt_dataflow_core_ports(
            axis_out_if=wtv.axis_out_if, is_verified_out=wtv.is_verified_out
        )

    return make_hw_func_from_interface_func(decrypt_dataflow_core)
