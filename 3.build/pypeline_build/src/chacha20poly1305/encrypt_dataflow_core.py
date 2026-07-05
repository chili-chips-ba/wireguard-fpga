# pyright: reportInvalidTypeForm=none
"""The encrypt dataflow graph, directly instantiating every component as a
submodule call:
  chacha20 -> [broadcast: prep_auth_data, append_auth_tag]
  prep_auth_data -> poly1305_mac -> append_auth_tag -> output

The only thing that differs between the standalone build (encrypt_dataflow.py)
and the shared-pipeline build (encrypt_dataflow_shared.py) is which chacha20
instance feeds this graph, so encrypt_dataflow_core is a factory parameterized
by that one callable (same elaboration-time-closure idiom as
chacha20.make_quarter_round/stream.make_stream_pipeline).
"""
import pypeline_env  # noqa: F401

from pypeline import hw_func, struct, NamedTuple, Feedback, uint1_t, uint8_t

import prep_auth_data
import poly1305
import append_auth_tag

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_t,
    axis128_2broadcast,
)


@struct
class encrypt_dataflow_core_t(NamedTuple):
    ports_axis_in_ready: uint1_t
    ports_axis_out: axis128_t


def make_encrypt_dataflow_core(chacha_func):
    """chacha_func(key, nonce, axis_in, poly_key_ready, axis_out_ready) ->
    chacha20.chacha20_stream_out_t -- either chacha20.chacha20_instance (owns
    its own private pipeline) or a shared-pipeline instance such as
    chacha20_pipeline_shared.chacha20_encrypt_shared (uses the arbitrated
    shared pipeline)."""

    @hw_func
    def encrypt_dataflow_core(
        ports_axis_in: axis128_t,
        ports_key: uint8_t[CHACHA20_KEY_SIZE],
        ports_nonce: uint8_t[CHACHA20_NONCE_SIZE],
        ports_aad: uint8_t[AAD_MAX_LEN],
        ports_aad_len: uint8_t,
        ports_axis_out_ready: uint1_t,
    ) -> encrypt_dataflow_core_t:
        o: encrypt_dataflow_core_t

        # chacha20's poly-key-ready and ciphertext-ready inputs are only
        # known once poly1305_mac / the broadcast are called, further down
        chacha_poly_key_ready: Feedback[uint1_t]
        chacha_axis_out_ready: Feedback[uint1_t]
        chacha_out = chacha_func(
            ports_key,
            ports_nonce,
            ports_axis_in,
            chacha_poly_key_ready,
            chacha_axis_out_ready,
        )
        o.ports_axis_in_ready = chacha_out.axis_in_ready

        # Fork chacha20's ciphertext output to both prep_auth_data and
        # append_auth_tag
        prep_axis_in_ready: Feedback[uint1_t]
        append_axis_in_ready: Feedback[uint1_t]
        sink_ready_s: uint1_t[2]
        sink_ready_s[0] = prep_axis_in_ready
        sink_ready_s[1] = append_axis_in_ready
        bcast = axis128_2broadcast(chacha_out.axis_out, sink_ready_s)
        chacha_axis_out_ready = bcast.axis_in_ready

        # prep_auth_data frames AAD+ciphertext+lengths, then feeds
        # poly1305_mac's data input
        prep_axis_out_ready: Feedback[uint1_t]
        prep_out = prep_auth_data.prep_auth_data_fsm(
            ports_aad, ports_aad_len, bcast.axis_out[0], prep_axis_out_ready
        )
        prep_axis_in_ready = prep_out.ready_for_axis_in

        # poly1305_mac computes the tag from chacha20's poly key + prep's
        # framed data, then feeds append_auth_tag's tag input
        mac_auth_tag_ready: Feedback[uint1_t]
        mac_out = poly1305.poly1305_mac_instance(
            chacha_out.poly_key, prep_out.axis, mac_auth_tag_ready
        )
        chacha_poly_key_ready = mac_out.key_ready
        prep_axis_out_ready = mac_out.data_in_ready

        # append_auth_tag appends the computed tag onto the broadcast-forked
        # ciphertext branch, producing the final output stream
        append_out = append_auth_tag.append_auth_tag(
            bcast.axis_out[1], mac_out.auth_tag, ports_axis_out_ready
        )
        append_axis_in_ready = append_out.axis_in_ready
        mac_auth_tag_ready = append_out.auth_tag_in_ready
        o.ports_axis_out = append_out.axis_out

        return o

    return encrypt_dataflow_core
