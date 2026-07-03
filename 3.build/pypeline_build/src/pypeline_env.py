"""sys.path bootstrap for this pypeline design tree.

Import this first in every design file:

    import pypeline_env  # noqa: F401

Adds to sys.path:
  - the PipelineC repo's src/ (the `pypeline` module) and include/pypeline/
    (stream/, axi/, kept_data_bus, ndarray, multi_cycle_path, ...)
  - this tree's subdirectories, so modules import with flat names
    (`import chacha20`, `import poly1305_mac_encrypt`, ...) while files keep
    the same directory layout as ../pipelinec_build/src/.

The PipelineC repo is located via $PIPELINEC (path to <repo>/src/pipelinec,
same env var the build scripts use), falling back to the sibling checkout.
"""

import os
import sys

_here = os.path.dirname(os.path.abspath(__file__))


def _add(path):
    path = os.path.abspath(path)
    if path not in sys.path:
        sys.path.insert(0, path)


_pipelinec_exe = os.environ.get("PIPELINEC")
if _pipelinec_exe:
    _repo = os.path.dirname(os.path.dirname(os.path.abspath(_pipelinec_exe)))
else:
    # .../git/wireguard-fpga/3.build/pypeline_build/src -> .../git/PipelineC
    _repo = os.path.join(_here, "..", "..", "..", "..", "PipelineC")

_add(os.path.join(_repo, "src"))
_add(os.path.join(_repo, "include", "pypeline"))

for _sub in ("chacha20", "poly1305", "prep_auth_data", "auth_tag", "chacha20poly1305"):
    _add(os.path.join(_here, _sub))
_add(_here)
