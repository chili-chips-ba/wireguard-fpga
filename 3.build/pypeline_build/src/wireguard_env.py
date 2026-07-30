"""sys.path bootstrap for this wireguard-fpga pypeline design tree's own subdirectories.

Import this first in every design file:

    import wireguard_env  # noqa: F401

Adds this tree's subdirectories to sys.path, so modules import with flat
names (`import chacha20`, `import poly1305`, ...) while files keep the same
directory layout as ../pipelinec_build/src/.

This is wireguard-fpga-specific: it has nothing to do with the PipelineC
repo's own src/ or include/pypeline/ library -- `pypelinec` bootstraps both
of those onto sys.path itself before importing any design file.
"""

import os
import sys

_here = os.path.dirname(os.path.abspath(__file__))


def _add(path):
    path = os.path.abspath(path)
    if path not in sys.path:
        sys.path.insert(0, path)


for _sub in ("chacha20", "poly1305", "prep_auth_data", "auth_tag", "chacha20poly1305"):
    _add(os.path.join(_here, _sub))
_add(_here)
