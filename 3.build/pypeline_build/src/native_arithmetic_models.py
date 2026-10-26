"""Stateless native-only acceleration for performance testbenches.

The Pypeline sim_model API leaves hardware elaboration untouched. Models cover
only pure arithmetic; all protocol, state, pipeline delays and storage execute
the design. test_native_arithmetic_models.py compares them with original hw_func
simulation before attaching models. Functional AEAD/paired testbenches do not
install these models.
"""
import chacha20
import poly1305_math as arithmetic
from pypeline import sim_model

P = (1 << 130) - 5
MASK32 = (1 << 32) - 1


class ChaChaBlockModel:
    def __call__(self, state):
        initial = [int(x) for x in state.state]
        x = list(initial)

        def rotate(v, n):
            return ((v << n) | (v >> (32 - n))) & MASK32

        def qr(a, b, c, d):
            x[a] = (x[a] + x[b]) & MASK32
            x[d] = rotate(x[d] ^ x[a], 16)
            x[c] = (x[c] + x[d]) & MASK32
            x[b] = rotate(x[b] ^ x[c], 12)
            x[a] = (x[a] + x[b]) & MASK32
            x[d] = rotate(x[d] ^ x[a], 8)
            x[c] = (x[c] + x[d]) & MASK32
            x[b] = rotate(x[b] ^ x[c], 7)

        for _ in range(10):
            qr(0, 4, 8, 12)
            qr(1, 5, 9, 13)
            qr(2, 6, 10, 14)
            qr(3, 7, 11, 15)
            qr(0, 5, 10, 15)
            qr(1, 6, 11, 12)
            qr(2, 7, 8, 13)
            qr(3, 4, 9, 14)
        return chacha20.chacha20_state(state=[(a + b) & MASK32 for a, b in zip(initial, x)])


class MultiplyModel:
    def __call__(self, a, b):
        return int(a) * int(b) % P


class MultiplyAddModel:
    def __call__(self, a, b, c):
        return (int(a) * int(b) + int(c)) % P


class AddModel:
    def __call__(self, a, b):
        return (int(a) + int(b)) % P


class SquareModel:
    def __call__(self, a):
        return int(a) ** 2 % P


MODELS = (
    (chacha20.chacha20_block, ChaChaBlockModel),
    (arithmetic.residue_mul_mod, MultiplyModel),
    (arithmetic.residue_mul_add_mod, MultiplyAddModel),
    (arithmetic.residue_add_mod, AddModel),
    (arithmetic.residue_square_mod, SquareModel),
)
if hasattr(arithmetic, "residue_mul_add_mod_inferred"):
    MODELS += ((arithmetic.residue_mul_add_mod_inferred, MultiplyAddModel),)


def install():
    # Each source import creates fresh hardware functions; an already-installed
    # matching model is harmless when two performance runners share a process.
    for target, model in MODELS:
        if target._sim_model_cell[0] is None:
            sim_model(target)(model)
