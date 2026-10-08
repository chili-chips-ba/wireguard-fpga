"""Build configuration for this wireguard-fpga pypeline design tree.

Import this first in every design file:

    import wireguard_env  # noqa: F401

It does three things:

1. Adds this tree's subdirectories to sys.path, so modules import with flat
   names (`import chacha20`, `import poly1305`, ...) while files keep the same
   directory layout as ../pipelinec_build/src/. This has nothing to do with the
   PipelineC repo's own src/ or include/pypeline/ library: `pypelinec`
   bootstraps both of those onto sys.path itself before importing any design
   file.
2. Declares the build parameters, set with `pypelinec ... -D NAME=VALUE`.
   build.py sets them from its flags:
     DESIGN         encrypt | decrypt | shared (default shared)
     POLY1305_IMPL  pipelined | legacy (default pipelined)
     SHARE          auto | none | chacha20 | poly1305 | both. auto means both
                    resources for the shared design, none for one direction
     TARGET_MHZ     30..80 (default: the profile's clock, see default_target_mhz)
3. Resolves them into this build's profile: DESIGN, ENCRYPT, DECRYPT,
   POLY1305_IMPL, SHARING, TARGET_MHZ and START_LATENCIES.

The profile tables and output-directory names below are plain Python, shared
with build.py and measure.py. Those import this module without PipelineC on
sys.path; every parameter is then its default.
"""

import os
import sys

try:
    from pypeline import DesignParamError, param
except ImportError:
    # build.py / measure.py: no PipelineC on sys.path, so no -D table either
    DesignParamError = ValueError

    def param(name, default=None, **_kwargs):
        return default


IMPLEMENTATIONS = ("pipelined", "legacy")
DESIGNS = ("encrypt", "decrypt", "shared")
SHARE_CHOICES = ("auto", "none", "chacha20", "poly1305", "both")

TARGETS_MHZ = (30, 40, 50, 60, 70, 80)
DEFAULT_TARGET_MHZ = 60  # Confirmed sharing-both fixed-vector and QoR point.
BASE_TARGET_MHZ = 30  # Other pipelined selections and uncharacterized hints.
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
        # Also confirmed by the sharing-both, two-lane 30 MHz hardware run.
        "poly1305_prologue_shared": 1,
        "poly1305_epilogue_shared": 2,
        "poly1305_legacy": 5,
    },
}

# Confirmed sharing-both 60 MHz fixed-vector syn_tb: ChaCha=17, both
# body cores=3 (L=5), shared prologue/epilogue=6/5. The perf wrapper retained
# decrypt core=0 after constant folding; do not use that as a hardware hint.
# Private ChaCha/MCP hints remain the 30 MHz fallback, not measured at 60 MHz.
# These are starting guesses only; all automatic blocks remain unrestricted.
START_LATENCIES_BY_MHZ[60] = dict(
    START_LATENCIES_BY_MHZ[30],
    chacha20_shared=17,
    poly1305_body_encrypt=3,
    poly1305_body_decrypt=3,
    poly1305_prologue_shared=6,
    poly1305_epilogue_shared=5,
)


def selected_implementation(value=None):
    choice = "pipelined" if value is None else value
    if choice not in IMPLEMENTATIONS:
        raise ValueError(f"POLY1305_IMPL must be one of {IMPLEMENTATIONS}, got {choice!r}")
    return choice


def selected_sharing(chacha20=True, poly1305=True, *, implementation=None):
    """The shared-resource set: {"chacha20": bool, "poly1305": bool}."""
    result = {"chacha20": bool(chacha20), "poly1305": bool(poly1305)}
    if result["poly1305"] and selected_implementation(implementation) == "legacy":
        raise ValueError("Legacy has no prologue/epilogue MCPs to share; use --share-chacha20 --poly1305 legacy")
    return result


def resolve_sharing(design, implementation, share):
    """SHARE (a SHARE_CHOICES name) -> the shared-resource set for this design."""
    if share not in SHARE_CHOICES:
        raise ValueError(f"SHARE must be one of {SHARE_CHOICES}, got {share!r}")
    if share == "auto":
        share = "both" if design == "shared" else "none"
    if design != "shared" and share != "none":
        raise ValueError(f"SHARE={share} needs DESIGN=shared: one direction has nothing to share")
    return selected_sharing(share in ("chacha20", "both"), share in ("poly1305", "both"),
                            implementation=implementation)


def default_target_mhz(implementation=None, sharing=None):
    """Sharing-both 60 MHz, other pipelined 30 MHz, or legacy 80 MHz."""
    implementation = selected_implementation(implementation)
    if implementation == "legacy":
        return LEGACY_TARGET_MHZ
    if sharing is None:
        sharing = selected_sharing(implementation=implementation)
    return DEFAULT_TARGET_MHZ if sharing["chacha20"] and sharing["poly1305"] else BASE_TARGET_MHZ


def selected_target(value):
    try:
        target = float(value)
    except (TypeError, ValueError):
        target = None
    if target not in TARGETS_MHZ:
        raise ValueError(f"TARGET_MHZ must be one of {TARGETS_MHZ}, got {value!r}")
    return int(target)


def resolve_profile(design="shared", implementation="pipelined", share="auto", target_mhz=None):
    """The one place a build profile's defaults are decided: the design itself,
    build.py and measure.py all call this, so a direct pypelinec run builds
    exactly what build.py would."""
    if design not in DESIGNS:
        raise ValueError(f"DESIGN must be one of {DESIGNS}, got {design!r}")
    implementation = selected_implementation(implementation)
    sharing = resolve_sharing(design, implementation, share)
    if target_mhz is None:
        target_mhz = default_target_mhz(implementation, sharing)
    return {
        "design": design,
        "implementation": implementation,
        "sharing": sharing,
        "target_mhz": selected_target(target_mhz),
    }


def share_name_for(sharing):
    """The SHARE value that selects this shared-resource set."""
    if sharing["chacha20"] and sharing["poly1305"]:
        return "both"
    if sharing["chacha20"]:
        return "chacha20"
    return "poly1305" if sharing["poly1305"] else "none"


def starting_latencies(target_mhz):
    """Independent copy of the clock's hints; fall back to the measured 30 MHz profile."""
    target = selected_target(target_mhz)
    return dict(START_LATENCIES_BY_MHZ.get(target, START_LATENCIES_BY_MHZ[BASE_TARGET_MHZ]))


def implementation_out_dir(base, implementation):
    return f"{base}-poly1305-{selected_implementation(implementation)}"


def target_out_dir(base, target_mhz):
    target = selected_target(target_mhz)
    # Preserve all historical default-clock directory names.
    return base if target == LEGACY_TARGET_MHZ else f"{base}-{target}mhz"


def add_sharing_arguments(parser):
    """A supplied flag selects the complete sharing set, not an extra toggle."""
    parser.add_argument("--share-chacha20", action="store_true",
                        help="Share ChaCha20 (alone unless --share-poly1305 is also supplied)")
    parser.add_argument("--share-poly1305", action="store_true",
                        help="Share Poly1305 prologue/epilogue MCPs (pipelined MAC only)")
    parser.add_argument("--share-none", action="store_true",
                        help="Combined design with private ChaCha20 and Poly1305 for each direction")


def sharing_from_args(args, *, standalone=False):
    share_none = getattr(args, "share_none", False)
    explicit = (args.share_chacha20 or args.share_poly1305 or share_none
                or getattr(args, "shared", False))
    if standalone:
        if explicit:
            raise ValueError("Sharing selectors cannot be combined with --enc or --dec")
        return {"chacha20": False, "poly1305": False}
    if share_none:
        if args.share_chacha20 or args.share_poly1305 or getattr(args, "shared", False):
            raise ValueError("--share-none cannot be combined with --shared or another sharing flag")
        return {"chacha20": False, "poly1305": False}
    if explicit and not getattr(args, "shared", False):
        return selected_sharing(args.share_chacha20, args.share_poly1305,
                                implementation=args.poly1305)
    return selected_sharing(implementation=args.poly1305)


def sharing_name(sharing):
    return "-".join(name for name in ("chacha20", "poly1305") if sharing[name]) or "none"


def sharing_out_dir(base, sharing):
    return f"{base}-share-{sharing_name(sharing)}"


# Every build/measure output directory lives under generated-files/<name>/.
GENERATED_FILES = "generated-files"


def generated_out_dir(path):
    """Map a pre-relayout `generated-files-<name>` path to `generated-files/<name>`."""
    head, name = os.path.split(os.path.normpath(path))
    prefix = GENERATED_FILES + "-"
    if name.startswith(prefix) and not os.path.exists(path):
        return os.path.join(head, GENERATED_FILES, name[len(prefix):])
    return path


# ─── This build's profile ───────────────────────────────────────────────────

DESIGN = param("DESIGN", "shared", choices=DESIGNS,
               help="encrypt or decrypt alone, or both directions (shared)")
POLY1305_IMPL = param("POLY1305_IMPL", "pipelined", choices=IMPLEMENTATIONS,
                      help="Poly1305 MAC architecture")
SHARE = param("SHARE", "auto", choices=SHARE_CHOICES,
              help="resources both directions share (DESIGN=shared only); "
                   "auto: both for the shared design, none for one direction")
_TARGET_MHZ = param("TARGET_MHZ", type=int, choices=TARGETS_MHZ,
                    help="clock goal in MHz (default: the profile's)")
try:
    _PROFILE = resolve_profile(DESIGN, POLY1305_IMPL, SHARE, _TARGET_MHZ)
except ValueError as e:
    raise DesignParamError(str(e)) from None

ENCRYPT = DESIGN in ("encrypt", "shared")
DECRYPT = DESIGN in ("decrypt", "shared")
SHARING = _PROFILE["sharing"]
TARGET_MHZ = float(_PROFILE["target_mhz"])
START_LATENCIES = starting_latencies(_PROFILE["target_mhz"])


# ─── sys.path bootstrap ─────────────────────────────────────────────────────

_here = os.path.dirname(os.path.abspath(__file__))


def _add(path):
    path = os.path.abspath(path)
    if path not in sys.path:
        sys.path.insert(0, path)


for _sub in ("chacha20", "poly1305", "prep_auth_data", "auth_tag", "chacha20poly1305"):
    _add(os.path.join(_here, _sub))
_add(_here)
