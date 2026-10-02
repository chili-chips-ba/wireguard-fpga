"""Build-time MAC/clock profiles; usable without importing any hardware."""
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


def target_out_dir(base, target_mhz):
    target = selected_target(target_mhz)
    # Preserve all historical default-clock directory names.
    return base if target == LEGACY_TARGET_MHZ else f"{base}-{target}mhz"
