# pyright: reportInvalidTypeForm=none
"""The decrypt dataflow graph, directly instantiating every component as a
submodule call:
  strip_auth_tag -> [broadcast: auth FIFO -> prep_auth_data, chacha20]
  chacha20 -> wait_to_verify
  prep_auth_data -> poly1305_mac -> poly1305_verify_decrypt -> wait_to_verify

This is an *interface function*: the body below is the whole design. Every
component's ready signal, and the ordering feedback needed because the graph is
not a straight line, is generated from it -- the body is a one-for-one
transcription of the call graph in the docstring above. `is_verified_out` shows
a plain (non-interface) output riding along in the same return bundle.

What differs between the decrypt design and the combined design with shared
resources (both built by decrypt_dataflow.py, chosen by -D DESIGN/SHARE) is
which chacha20 instance and which MAC feed this graph, so
decrypt_dataflow_core is a factory parameterized by those callables (mirrors
encrypt_dataflow_core's make_encrypt_dataflow_core).
"""
import wireguard_env  # noqa: F401

from pypeline import NamedTuple, uint1_t, uint8_t

from interface.interface import interface
from interface.interface_func import make_hw_func_from_interface_func

import strip_auth_tag
import prep_auth_data
from poly1305_select import IMPLEMENTATION, make_poly1305_mac
import poly1305_verify_decrypt
import wait_to_verify

from aead_types import (
    CHACHA20_KEY_SIZE,
    CHACHA20_NONCE_SIZE,
    AAD_MAX_LEN,
    axis128_intrf,
    axis128_frag_t,
    axis128_2broadcast,
    decrypt_auth_fifo_sizing,
    make_aead_fifo,
)


@interface
class decrypt_dataflow_core_ports(NamedTuple):
    axis_out_if: axis128_intrf
    is_verified_out: uint1_t  # plain sideband, no reverse companion


@interface
class buffered_prep_ports(NamedTuple):
    axis_if: axis128_intrf


def make_decrypt_dataflow_core(chacha_func, mac_func=None, auth_fifo_depth=None):
    """chacha_func(key, nonce, axis_in_if, key_if, axis_out_if) ->
    chacha20.chacha20_ports -- either chacha20.chacha20_instance (owns its own
    private pipeline) or a shared-pipeline instance such as
    chacha20_pipeline_shared.chacha20_decrypt_shared (uses the arbitrated
    shared pipeline)."""

    if mac_func is None:
        mac_func = make_poly1305_mac("decrypt")
    sizing = None
    if IMPLEMENTATION == "pipelined":
        if auth_fifo_depth is None:
            sizing = decrypt_auth_fifo_sizing(chacha_func, mac_func)
            auth_fifo_depth = sizing["memory_depth_beats"]
        elif type(auth_fifo_depth) is not int or (auth_fifo_depth != 0 and auth_fifo_depth < 2):
            raise ValueError("auth_fifo_depth must be None, 0, or an integer >= 2")
        else:
            sizing = {"method": "explicit"}

    # Select plain Python wiring, not a hardware mux. Legacy keeps its original
    # unbuffered graph. The depth parameter also permits isolated native sizing
    # experiments without adding diagnostic switches to build.py.
    prep_func = prep_auth_data.prep_auth_data_fsm
    if IMPLEMENTATION == "pipelined" and auth_fifo_depth:
        auth_fifo = make_aead_fifo(
            axis128_frag_t, auth_fifo_depth, "auth_fifo", "decrypt", sizing=sizing
        )

        def buffered_prep(
            aad: uint8_t[AAD_MAX_LEN],
            aad_len: uint8_t,
            axis_in_if: axis128_intrf,
        ) -> buffered_prep_ports:
            queued = auth_fifo(in_stream_if=axis_in_if)
            framed = prep_auth_data.prep_auth_data_fsm(
                aad=aad, aad_len=aad_len, axis_in_if=queued.out_stream_if
            )
            return buffered_prep_ports(axis_if=framed.axis_if)

        prep_func, _prep_t = make_hw_func_from_interface_func(buffered_prep)

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
        # Pipelined MACs buffer the authentication fork, letting ChaCha consume
        # ciphertext during MAC key/setup waits. Legacy uses framing directly.
        prep = prep_func(
            aad=aad, aad_len=aad_len, axis_in_if=bcast.axis_out_if[0]
        )
        # poly1305_mac recomputes the tag from the poly key + the framed data
        mac = mac_func(key_if=chacha.key_if, data_in_if=prep.axis_if)
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
