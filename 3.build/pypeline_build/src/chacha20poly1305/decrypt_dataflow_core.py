# pyright: reportInvalidTypeForm=none
"""The decrypt dataflow graph, directly instantiating every component as a
submodule call:
  strip_auth_tag -> [broadcast: prep_auth_data, chacha20]
  chacha20 -> wait_to_verify
  prep_auth_data -> poly1305_mac -> poly1305_verify_decrypt -> wait_to_verify

The only thing that differs between the standalone build (decrypt_dataflow.py)
and the shared-pipeline build (decrypt_dataflow_shared.py) is which chacha20
instance feeds this graph, so decrypt_dataflow_core is a factory parameterized
by that one callable (mirrors encrypt_dataflow_core's make_encrypt_dataflow_core).
"""
import pypeline_env  # noqa: F401

from pypeline import hw_func, struct, NamedTuple, Feedback, uint1_t, uint8_t

import strip_auth_tag
import prep_auth_data
import poly1305
import poly1305_verify_decrypt
import wait_to_verify

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_t,
    axis128_2broadcast,
)


@struct
class decrypt_dataflow_core_t(NamedTuple):
    ports_axis_in_ready: uint1_t
    ports_axis_out: axis128_t
    ports_is_verified_out: uint1_t


def make_decrypt_dataflow_core(chacha_func):
    """chacha_func(key, nonce, axis_in, poly_key_ready, axis_out_ready) ->
    chacha20.chacha20_stream_out_t -- either chacha20.chacha20_instance (owns
    its own private pipeline) or a shared-pipeline instance such as
    chacha20_pipeline_shared.chacha20_decrypt_shared (uses the arbitrated
    shared pipeline)."""

    @hw_func
    def decrypt_dataflow_core(
        ports_axis_in: axis128_t,
        ports_key: uint8_t[CHACHA20_KEY_SIZE],
        ports_nonce: uint8_t[CHACHA20_NONCE_SIZE],
        ports_aad: uint8_t[AAD_MAX_LEN],
        ports_aad_len: uint8_t,
        ports_axis_out_ready: uint1_t,
    ) -> decrypt_dataflow_core_t:
        o: decrypt_dataflow_core_t

        # strip_auth_tag splits ciphertext+tag into stripped-ciphertext + tag
        strip_axis_out_ready: Feedback[uint1_t]
        strip_auth_tag_out_ready: Feedback[uint1_t]
        strip_out = strip_auth_tag.strip_auth_tag(
            ports_axis_in, strip_axis_out_ready, strip_auth_tag_out_ready
        )
        o.ports_axis_in_ready = strip_out.axis_in_ready

        # Fork the stripped ciphertext to prep_auth_data (for MAC
        # calculation) and chacha20 (for actual decryption)
        prep_axis_in_ready: Feedback[uint1_t]
        chacha_axis_in_ready: Feedback[uint1_t]
        sink_ready_s: uint1_t[2]
        sink_ready_s[0] = prep_axis_in_ready
        sink_ready_s[1] = chacha_axis_in_ready
        bcast = axis128_2broadcast(strip_out.axis_out, sink_ready_s)
        strip_axis_out_ready = bcast.axis_in_ready

        # chacha20 decrypts (keystream XOR); its poly key seeds poly1305_mac
        chacha_poly_key_ready: Feedback[uint1_t]
        chacha_axis_out_ready: Feedback[uint1_t]
        chacha_out = chacha_func(
            ports_key,
            ports_nonce,
            bcast.axis_out[1],
            chacha_poly_key_ready,
            chacha_axis_out_ready,
        )
        chacha_axis_in_ready = chacha_out.axis_in_ready

        # prep_auth_data frames AAD+ciphertext+lengths, feeds poly1305_mac
        prep_axis_out_ready: Feedback[uint1_t]
        prep_out = prep_auth_data.prep_auth_data_fsm(
            ports_aad, ports_aad_len, bcast.axis_out[0], prep_axis_out_ready
        )
        prep_axis_in_ready = prep_out.ready_for_axis_in

        # poly1305_mac recomputes the tag from chacha20's poly key + prep's
        # framed data
        mac_auth_tag_ready: Feedback[uint1_t]
        mac_out = poly1305.poly1305_mac_instance(
            chacha_out.poly_key, prep_out.axis, mac_auth_tag_ready
        )
        chacha_poly_key_ready = mac_out.key_ready
        prep_axis_out_ready = mac_out.data_in_ready

        # poly1305_verify_decrypt compares the stripped tag vs. the
        # recomputed tag
        verify_tags_match_ready: Feedback[uint1_t]
        verify_out = poly1305_verify_decrypt.poly1305_verify_decrypt(
            strip_out.auth_tag_out, mac_out.auth_tag, verify_tags_match_ready
        )
        strip_auth_tag_out_ready = verify_out.auth_tag_ready
        mac_auth_tag_ready = verify_out.calc_tag_ready

        # wait_to_verify buffers chacha20's plaintext until poly1305_verify's
        # match bit arrives, then releases both
        wtv_out = wait_to_verify.wait_to_verify(
            chacha_out.axis_out, verify_out.tags_match, ports_axis_out_ready
        )
        chacha_axis_out_ready = wtv_out.axis_in_ready
        verify_tags_match_ready = wtv_out.verify_bit_ready
        o.ports_axis_out = wtv_out.axis_out
        o.ports_is_verified_out = wtv_out.is_verified_out

        return o

    return decrypt_dataflow_core
