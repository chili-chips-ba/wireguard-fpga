"""Build-time architecture, clock and automatic-latency profiles (no hardware imports)."""
import os

IMPLEMENTATIONS = ("pipelined", "legacy")


def selected_implementation(value=None):
    choice = value if value is not None else os.environ.get("WG_POLY1305_IMPL", "pipelined")
    if choice not in IMPLEMENTATIONS:
        raise ValueError(f"WG_POLY1305_IMPL must be one of {IMPLEMENTATIONS}, got {choice!r}")
    return choice


def implementation_out_dir(base, implementation):
    return f"{base}-poly1305-{selected_implementation(implementation)}"


TARGETS_MHZ = (30, 40, 80)
DEFAULT_TARGET_MHZ = 30
LEGACY_TARGET_MHZ = 80

# Core register counts for AUTO_PIPELINE; setup counts for AUTO_MULTI_CYCLE.
# Source: the retained shared hardware observation in measurements/
# shared-30mhz-poly1305-pipelined-30mhz-primary-20261001-1559Z/.
# The private ChaCha core reuses the shared core's hint (not an independent
# timing result). Legacy Poly1305 retains its historical 80 MHz starting 5.
# Add measured clock profiles here; uncharacterized clocks use the 30 MHz
# hints, not fixed depths or limits. Boundary registers are NOT included.
START_LATENCIES_BY_MHZ = {
    30: {
        "chacha20": 4,
        "chacha20_shared": 4,
        "poly1305_body_encrypt": 0,
        "poly1305_body_decrypt": 0,
        "poly1305_prologue_encrypt": 1,
        "poly1305_prologue_decrypt": 1,
        "poly1305_epilogue_encrypt": 2,
        "poly1305_epilogue_decrypt": 2,
        "poly1305_legacy": 5,
    },
}


def default_target_mhz(implementation=None):
    """Validated pipelined profile, or the historical legacy profile."""
    return LEGACY_TARGET_MHZ if selected_implementation(implementation) == "legacy" else DEFAULT_TARGET_MHZ


def selected_target(value=None):
    raw = value if value is not None else os.environ.get("WG_TARGET_MHZ")
    if raw is None:
        raw = default_target_mhz()
    try:
        target = float(raw)
    except (TypeError, ValueError):
        target = None
    if target not in TARGETS_MHZ:
        raise ValueError(f"WG_TARGET_MHZ must be one of {TARGETS_MHZ}, got {raw!r}")
    return int(target)


def starting_latencies(target_mhz=None):
    """Independent copy of the clock's hints; fall back to the measured 30 MHz profile."""
    target = selected_target(target_mhz)
    return dict(START_LATENCIES_BY_MHZ.get(target, START_LATENCIES_BY_MHZ[DEFAULT_TARGET_MHZ]))


def target_out_dir(base, target_mhz):
    target = selected_target(target_mhz)
    # Preserve all historical default-clock directory names.
    return base if target == LEGACY_TARGET_MHZ else f"{base}-{target}mhz"
