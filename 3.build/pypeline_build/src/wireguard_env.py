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
     DATA_BITWIDTH  128 | 256 packet datapath bits (default 128; ChaCha20 stays 512)
     SHARE          auto | none | chacha20 | poly1305 | both. auto means both
                    resources for the shared design, none for one direction
     POLY1305_MULT_IMPL inferred | hybrid | hybrid_square | inferred_body
                       (default hybrid_square; legacy uses inferred). inferred_body
                       is hybrid_square except an inferred feedback-body product
     POLY1305_COMPUTE_IMPL fsm | mcp (default fsm; pipelined setup/finalization)
     POLY1305_PROLOGUE_MAX_LATENCY positive integer AUTO_FSM cap for the prologue
                       services (default 64; fsm compute only)
     TARGET_MHZ     positive integer MHz (default: the profile's clock)
3. Resolves them into this build's profile: DESIGN, ENCRYPT, DECRYPT,
   DATA_BITWIDTH, POLY1305_IMPL, POLY1305_MULT_IMPL, SHARING and TARGET_MHZ.

The profile tables and output-directory names below are plain Python, shared
with build.py and measure.py. Those import this module without PipelineC on
sys.path; every parameter is then its default.
"""

import math
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

MULT_IMPLEMENTATIONS = ("inferred", "hybrid", "hybrid_square", "inferred_body")
DEFAULT_MULT_IMPL = "hybrid_square"
BLOCK_RATES = (1, 2)
DATA_BITWIDTHS = (128, 256)
COMPUTE_IMPLEMENTATIONS = ("fsm", "mcp")
DEFAULT_COMPUTE_IMPL = "fsm"
DEFAULT_TARGET_MHZ = 85  # Highest passing shared hardware and six-size QoR point.
BASE_TARGET_MHZ = 30  # Other pipelined selections.
LEGACY_TARGET_MHZ = 80

def selected_implementation(value=None):
    choice = "pipelined" if value is None else value
    if choice not in IMPLEMENTATIONS:
        raise ValueError(f"POLY1305_IMPL must be one of {IMPLEMENTATIONS}, got {choice!r}")
    return choice


def selected_data_bitwidth(value=None, implementation="pipelined"):
    choice = 128 if value is None else value
    if type(choice) is not int or choice not in DATA_BITWIDTHS:
        raise ValueError("DATA_BITWIDTH must be 128 or 256 bits")
    if implementation == "legacy" and choice != 128:
        raise ValueError("Legacy Poly1305 supports only --data-bitwidth 128")
    return choice


def selected_blocks_per_cycle(value=None, implementation="pipelined"):
    choice = 1 if value is None else value
    if type(choice) is not int or choice not in BLOCK_RATES:
        raise ValueError("POLY1305_BLOCKS_PER_CYCLE must be 1 or 2")
    selected_data_bitwidth(128 * choice, implementation)
    return choice


def blocks_out_dir(base, blocks=1):
    return base if blocks == 1 else f"{base}-blocks{selected_blocks_per_cycle(blocks)}"


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
    """Sharing-both 85 MHz, other pipelined 30 MHz, or legacy 80 MHz."""
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
    if (target is None or isinstance(value, bool) or not math.isfinite(target)
            or target <= 0 or not target.is_integer()):
        raise ValueError(f"TARGET_MHZ must be a positive integer MHz value, got {value!r}")
    return int(target)


def selected_mult(value=None, implementation="pipelined"):
    choice = ("inferred" if implementation == "legacy" else DEFAULT_MULT_IMPL) if value is None else value
    if choice not in MULT_IMPLEMENTATIONS:
        raise ValueError(f"POLY1305_MULT_IMPL must be one of {MULT_IMPLEMENTATIONS}, got {choice!r}")
    if implementation == "legacy" and choice != "inferred":
        raise ValueError("Legacy Poly1305 supports only --poly1305-mult inferred")
    return choice


def mult_out_dir(base, multiplier):
    # None is reserved for pre-selector measurement records.
    return base if multiplier is None else f"{base}-mult-{multiplier}"


def selected_compute(value=None):
    choice = DEFAULT_COMPUTE_IMPL if value is None else value
    if choice not in COMPUTE_IMPLEMENTATIONS:
        raise ValueError(f"POLY1305_COMPUTE_IMPL must be one of {COMPUTE_IMPLEMENTATIONS}, got {choice!r}")
    return choice


DEFAULT_PROLOGUE_MAX_LATENCY = 64


def selected_prologue_cap(value=None):
    cap = DEFAULT_PROLOGUE_MAX_LATENCY if value is None else value
    if not isinstance(cap, int) or isinstance(cap, bool) or cap < 1:
        raise ValueError(f"POLY1305_PROLOGUE_MAX_LATENCY must be a positive integer, got {cap!r}")
    return cap


def prologue_cap_out_dir(base, cap):
    # The default cap keeps every existing directory name.
    return base if cap in (None, DEFAULT_PROLOGUE_MAX_LATENCY) else f"{base}-procap{cap}"


def compute_out_dir(base, compute):
    # None identifies historical records, before this selector existed.
    return base if compute is None else f"{base}-compute-{selected_compute(compute)}"


def resolve_profile(design="shared", implementation="pipelined", share="auto", target_mhz=None,
                    multiplier=None, blocks_per_cycle=None, *, data_bitwidth=None):
    """The one place a build profile's defaults are decided: the design itself,
    build.py and measure.py all call this, so a direct pypelinec run builds
    exactly what build.py would."""
    if design not in DESIGNS:
        raise ValueError(f"DESIGN must be one of {DESIGNS}, got {design!r}")
    implementation = selected_implementation(implementation)
    # Accept the old compiler parameter for archived build commands. Width is
    # the public selection; the MAC block rate follows from 128-bit blocks.
    if blocks_per_cycle is not None:
        old_width = 128 * selected_blocks_per_cycle(blocks_per_cycle, implementation)
        if data_bitwidth is not None and data_bitwidth != old_width:
            raise ValueError("DATA_BITWIDTH conflicts with POLY1305_BLOCKS_PER_CYCLE")
        data_bitwidth = old_width
    data_bitwidth = selected_data_bitwidth(data_bitwidth, implementation)
    sharing = resolve_sharing(design, implementation, share)
    if target_mhz is None:
        target_mhz = default_target_mhz(implementation, sharing)
    return {
        "design": design,
        "implementation": implementation,
        "multiplier": selected_mult(multiplier, implementation),
        "data_bitwidth": data_bitwidth,
        "blocks_per_cycle": data_bitwidth // 128,
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
                        help="Share Poly1305 prologue/epilogue compute (pipelined MAC only)")
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
_DATA_BITWIDTH = param("DATA_BITWIDTH", type=int, choices=DATA_BITWIDTHS,
                       help="packet datapath width in bits (default 128; ChaCha20 block stays 512)")
_OLD_BLOCKS_PER_CYCLE = param("POLY1305_BLOCKS_PER_CYCLE", type=int, choices=BLOCK_RATES,
                             help="deprecated: use DATA_BITWIDTH=128 or 256")
SHARE = param("SHARE", "auto", choices=SHARE_CHOICES,
              help="resources both directions share (DESIGN=shared only); "
                   "auto: both for the shared design, none for one direction")
_MULT_IMPL = param("POLY1305_MULT_IMPL", choices=MULT_IMPLEMENTATIONS,
                   help="130-bit multiply implementation (pipelined MAC only)")
POLY1305_COMPUTE_IMPL = param("POLY1305_COMPUTE_IMPL", DEFAULT_COMPUTE_IMPL,
                            choices=COMPUTE_IMPLEMENTATIONS,
                            help="prologue and epilogue implementation (pipelined MAC only)")
POLY1305_PROLOGUE_MAX_LATENCY = param("POLY1305_PROLOGUE_MAX_LATENCY", DEFAULT_PROLOGUE_MAX_LATENCY,
                                      type=int,
                                      help="AUTO_FSM latency cap of the prologue services (fsm compute only)")
try:
    selected_prologue_cap(POLY1305_PROLOGUE_MAX_LATENCY)
except ValueError as e:
    raise DesignParamError(str(e)) from None
_TARGET_MHZ = param("TARGET_MHZ", type=int,
                    help="clock goal in MHz (default: the profile's)")
try:
    _PROFILE = resolve_profile(DESIGN, POLY1305_IMPL, SHARE, _TARGET_MHZ, _MULT_IMPL,
                               _OLD_BLOCKS_PER_CYCLE, data_bitwidth=_DATA_BITWIDTH)
except ValueError as e:
    raise DesignParamError(str(e)) from None

ENCRYPT = DESIGN in ("encrypt", "shared")
DECRYPT = DESIGN in ("decrypt", "shared")
SHARING = _PROFILE["sharing"]
DATA_BITWIDTH = _PROFILE["data_bitwidth"]
POLY1305_BLOCKS_PER_CYCLE = _PROFILE["blocks_per_cycle"]
POLY1305_MULT_IMPL = _PROFILE["multiplier"]
TARGET_MHZ = float(_PROFILE["target_mhz"])


# ─── sys.path bootstrap ─────────────────────────────────────────────────────

_here = os.path.dirname(os.path.abspath(__file__))


def _add(path):
    path = os.path.abspath(path)
    if path not in sys.path:
        sys.path.insert(0, path)


for _sub in ("chacha20", "poly1305", "prep_auth_data", "auth_tag", "chacha20poly1305"):
    _add(os.path.join(_here, _sub))
_add(_here)
