"""Shared test vectors for the encrypt/decrypt testbenches (plain Python data,
no hardware). KEY/NONCE/AAD/plaintext strings match
../pipelinec_build/src/chacha20poly1305/{encrypt_tb.c,decrypt_tb.c}; the
expected ciphertext+tag for each plaintext is generated on the fly by
aead_ref_model.py instead of being hardcoded, so adding/removing a test
string is the only edit ever needed here.
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
PLAINTEXT_TEST_STRS = [
    "Hello CHILIChips - Wireguard team, let's test this aead!",
    "PipelineC is the best HDL around :) Let's go CHILIChips Wireguard team!",
    "Thanks Claude for helping CHILIChips Wireguard + Pypeline!",
]
assert all(len(s) <= PLAINTEXT_TEST_STR_MAX_SIZE for s in PLAINTEXT_TEST_STRS)
NUM_PLAINTEXT_TEST_STRS = len(PLAINTEXT_TEST_STRS)
PLAINTEXT_LENS = [len(s) for s in PLAINTEXT_TEST_STRS]  # 56, 71, 58
PLAINTEXTS = [
    list(s.encode()) + [0] * (PLAINTEXT_TEST_STR_MAX_SIZE - len(s))
    for s in PLAINTEXT_TEST_STRS
]

# Expected ciphertext and auth tag output, generated on the fly (see
# aead_ref_model.py) to match the current chacha20poly1305 hardware's
# behavior -- which pads the final AXI-stream beat with zeros but marks it
# fully "kept", so ciphertext length is rounded up to the next 16-byte
# boundary rather than exactly len(plaintext) (a deviation from RFC 8439 to
# be fixed in a future task).
POLY1305_AUTH_TAG_SIZE = 16
CIPHERTEXT_OUT_MAX_SIZE = PLAINTEXT_TEST_STR_MAX_SIZE + POLY1305_AUTH_TAG_SIZE

_AAD_BYTES = AAD_TEST_STR.encode()
_GENERATED = [
    generate_encrypt_vector(bytes(KEY), bytes(NONCE), _AAD_BYTES, s.encode())
    for s in PLAINTEXT_TEST_STRS
]
EXPECTED_CIPHERTEXTS = [
    list(ct) + [0] * (CIPHERTEXT_OUT_MAX_SIZE - ct_len)
    for ct, ct_len in _GENERATED
]
CIPHERTEXT_LENS = [ct_len for _, ct_len in _GENERATED]
