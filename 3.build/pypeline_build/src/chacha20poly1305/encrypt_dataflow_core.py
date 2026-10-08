# pyright: reportInvalidTypeForm=none
"""The encrypt dataflow graph, directly instantiating every component as a
submodule call:
  chacha20 -> [broadcast: prep_auth_data, append_auth_tag]
  prep_auth_data -> poly1305_mac -> append_auth_tag -> output register slice

This is an *interface function*: the body below is the whole design. Every
component's ready signal, and the ordering feedback needed because the graph is
not a straight line, is generated from it -- see the call graph in the docstring
above, which the body now reproduces one-for-one.

What differs between the encrypt design and the combined design with shared
resources (both built by encrypt_dataflow.py, chosen by -D DESIGN/SHARE) is
which chacha20 instance and which MAC feed this graph, so
encrypt_dataflow_core is a factory parameterized by those callables (same
elaboration-time-closure idiom as
chacha20.make_quarter_round/stream.make_stream_auto_pipeline).
"""
import wireguard_env  # noqa: F401

from pypeline import NamedTuple, uint8_t

from interface.interface import interface
from interface.interface_func import make_hw_func_from_interface_func

import prep_auth_data
from poly1305_select import IMPLEMENTATION, make_poly1305_mac
import append_auth_tag

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
    axis128_2broadcast,
    make_aead_output_slice,
)


@interface
class encrypt_dataflow_core_ports(NamedTuple):
    axis_out_if: axis128_intrf


def make_encrypt_dataflow_core(chacha_func, mac_func=None):
    """chacha_func(key, nonce, axis_in_if, key_if, axis_out_if) ->
    chacha20.chacha20_ports -- either chacha20.chacha20_instance (owns its own
    private pipeline) or a shared-pipeline instance such as
    chacha20_pipeline_shared.chacha20_encrypt_shared (uses the arbitrated
    shared pipeline)."""

    if mac_func is None:
        mac_func = make_poly1305_mac("encrypt")
    append_func = append_auth_tag.append_auth_tag
    if IMPLEMENTATION == "pipelined":
        output_slice = make_aead_output_slice(axis128_intrf, "output_slice", "encrypt")

        def buffered_append(
            axis_in_if: axis128_intrf,
            auth_tag_in_if: append_auth_tag.poly1305_auth_tag_stream_intrf,
        ) -> encrypt_dataflow_core_ports:
            packed = append_auth_tag.append_auth_tag(
                axis_in_if=axis_in_if, auth_tag_in_if=auth_tag_in_if
            )
            # The comb ciphertext interlock may suppress valid when the other
            # fork stalls. Do not expose that directly as external AXIS valid;
            # the registered slice holds accepted words until external ready.
            sliced = output_slice(stream_in_if=packed.axis_out_if)
            return encrypt_dataflow_core_ports(axis_out_if=sliced.stream_out_if)

        append_func, _append_t = make_hw_func_from_interface_func(buffered_append)

    def encrypt_dataflow_core(
        axis_in_if: axis128_intrf,
        key: uint8_t[CHACHA20_KEY_SIZE],
        nonce: uint8_t[CHACHA20_NONCE_SIZE],
        aad: uint8_t[AAD_MAX_LEN],
        aad_len: uint8_t,
    ) -> encrypt_dataflow_core_ports:
        # chacha20 encrypts; its ciphertext forks to both the MAC calculation
        # and the final output, and its poly key seeds poly1305_mac
        chacha = chacha_func(key=key, nonce=nonce, axis_in_if=axis_in_if)
        bcast = axis128_2broadcast(axis_in_if=chacha.axis_out_if)
        # prep_auth_data frames AAD+ciphertext+lengths for the MAC
        prep = prep_auth_data.prep_auth_data_fsm(
            aad=aad, aad_len=aad_len, axis_in_if=bcast.axis_out_if[0]
        )
        # poly1305_mac computes the tag from the poly key + the framed data
        mac = mac_func(key_if=chacha.key_if, data_in_if=prep.axis_if)
        # append_auth_tag appends the tag onto the other ciphertext fork
        append = append_func(
            axis_in_if=bcast.axis_out_if[1], auth_tag_in_if=mac.auth_tag_if
        )
        return encrypt_dataflow_core_ports(axis_out_if=append.axis_out_if)

    return make_hw_func_from_interface_func(encrypt_dataflow_core)
