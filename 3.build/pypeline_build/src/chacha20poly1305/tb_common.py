"""Shared test vectors for the encrypt/decrypt testbenches (plain Python data,
no hardware). KEY/NONCE/AAD match
../pipelinec_build/src/chacha20poly1305/{encrypt_tb.c,decrypt_tb.c}; the
expected ciphertext and auth tag for each plaintext are generated on the fly
by aead_ref_model.py (RFC 8439 via the `cryptography` package) instead of
being hardcoded, so adding/removing a test string is the only edit ever
needed here.
"""

from aead_ref_model import generate_encrypt_vector

# Test vectors
KEY = list(range(0x80, 0xA0))  # 0x80, 0x81, ... 0x9f

NONCE = [0x07, 0x00, 0x00, 0x00, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47]

AAD_TEST_STR = "Additional authenticated data"
AAD_MAX_LEN = 32
AAD_LEN = len(AAD_TEST_STR)  # 29
AAD = list(AAD_TEST_STR.encode()) + [0] * (AAD_MAX_LEN - AAD_LEN)

PLAINTEXT_TEST_STR_MAX_SIZE = 128
# Lengths deliberately cover the partial-final-word and block corner cases:
# shorter than one 16-byte AXIS word (3), exactly one word (16), one word
# plus one byte (17), mid-word endings (56, 71, 58), exactly one 64-byte
# ChaCha20 block (64), and the 128-byte max (a multiple of both 16 and 64).
PLAINTEXT_TEST_STRS = [
    "Hello CHILIChips - Wireguard team, let's test this aead!",
    "PipelineC is the best HDL around :) Let's go CHILIChips Wireguard team!",
    "Thanks Claude for helping CHILIChips Wireguard + Pypeline!",
    "Hi!",
    "Exactly 16 bytes",
    "Seventeen bytes!!",
    "One full sixty four byte ChaCha20 block exactly, nothing more!!!",
    "This one hundred twenty eight byte maximum size test string covers"
    " exactly two full sixty four byte ChaCha20 blocks of data!!!!!",
]
NUM_PLAINTEXT_TEST_STRS = len(PLAINTEXT_TEST_STRS)
PLAINTEXT_LENS = [len(s) for s in PLAINTEXT_TEST_STRS]
assert PLAINTEXT_LENS == [56, 71, 58, 3, 16, 17, 64, 128]
assert all(0 < n <= PLAINTEXT_TEST_STR_MAX_SIZE for n in PLAINTEXT_LENS)
PLAINTEXTS = [
    list(s.encode()) + [0] * (PLAINTEXT_TEST_STR_MAX_SIZE - len(s))
    for s in PLAINTEXT_TEST_STRS
]

# Expected DUT output, generated on the fly per RFC 8439 (see
# aead_ref_model.py): the ciphertext is exactly as long as the plaintext (the
# final AXIS word carries a partial keep when the length is not a multiple of
# 16), and the auth tag is a separate full 16-byte word the DUT appends after
# the final ciphertext word.
POLY1305_AUTH_TAG_SIZE = 16
CIPHERTEXT_MAX_SIZE = PLAINTEXT_TEST_STR_MAX_SIZE

_AAD_BYTES = AAD_TEST_STR.encode()
_GENERATED = [
    generate_encrypt_vector(bytes(KEY), bytes(NONCE), _AAD_BYTES, s.encode())
    for s in PLAINTEXT_TEST_STRS
]
CIPHERTEXT_LENS = [len(ct) for ct, _ in _GENERATED]
assert CIPHERTEXT_LENS == PLAINTEXT_LENS  # stream cipher: same length
EXPECTED_CIPHERTEXTS = [
    list(ct) + [0] * (CIPHERTEXT_MAX_SIZE - len(ct)) for ct, _ in _GENERATED
]
EXPECTED_TAGS = [list(tag) for _, tag in _GENERATED]

# Decrypt-side negative test vector: test string 0's ciphertext with a
# corrupted (bit-flipped) tag. The DUT must still emit the plaintext but with
# is_verified_out low (decrypt_tb.py replays this as an extra final packet).
TAMPERED_TAG = list(EXPECTED_TAGS[0])
TAMPERED_TAG[0] ^= 0x01
