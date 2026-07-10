# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""Pure-Python (no pypeline/hardware dependency) RFC 8439 ChaCha20-Poly1305
reference model used to generate the expected test vectors for the
encrypt/decrypt testbenches on the fly, instead of hardcoding them.

The AEAD is computed by the `cryptography` package's standard
ChaCha20Poly1305, so the hardware is validated against an independent,
spec-compliant implementation (the DUT is never used to validate itself).

Historical note: this file used to be a from-scratch transcription of the
hardware's then-buggy Poly1305 limb math (truncating 64x64 limb products, a
broken mod-(2^130-5) reduction) plus its rounded-up-to-16-bytes ciphertext
framing, purely so the old test vectors kept matching. Both hardware bugs are
fixed (see poly1305.py's uint320_mul/uint320_fold/uint320_mod_prime for the
math, and chacha20.py/encrypt_tb.py/decrypt_tb.py for exact-length keep
handling), so the model is now just the standard AEAD.

A known-answer self-test against the RFC 8439 2.8.2 AEAD test vector runs at
import time, so a broken/mismatched cryptography install fails loudly here
rather than as unexplained testbench ERRORs.
"""

from cryptography.hazmat.primitives.ciphers.aead import ChaCha20Poly1305

POLY1305_TAG_LEN = 16


def generate_encrypt_vector(key: bytes, nonce: bytes, aad: bytes, plaintext: bytes):
    """Returns (ciphertext, tag): the exact-length ciphertext
    (len(ciphertext) == len(plaintext)) and the 16-byte Poly1305 auth tag,
    per RFC 8439."""
    ct_and_tag = ChaCha20Poly1305(key).encrypt(nonce, plaintext, aad)
    return ct_and_tag[:-POLY1305_TAG_LEN], ct_and_tag[-POLY1305_TAG_LEN:]


# RFC 8439 2.8.2 known-answer self-test
_ct, _tag = generate_encrypt_vector(
    bytes(range(0x80, 0xA0)),
    bytes([0x07, 0, 0, 0, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47]),
    bytes.fromhex("50515253c0c1c2c3c4c5c6c7"),
    b"Ladies and Gentlemen of the class of '99: "
    b"If I could offer you only one tip for the future, sunscreen would be it.",
)
assert (
    _ct[:8].hex() == "d31a8d34648e60db"
    and _tag.hex() == "1ae10b594f09e26a7e902ecbd0600691"
), "cryptography package failed the RFC 8439 2.8.2 known-answer test"
