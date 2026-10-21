#!/bin/bash
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause
#
# Upgrade the co-simulation models in 4.sim/models from their upstream sources
# (github.com/wyvernSemi): VProc, mem_model, rv32. Rebuilds libcosimlnx.a,
# copies headers and HDL, refreshes the rv32 sources and re-applies our local
# changes (see 4.sim/README.md, "Local changes"), and sets VPROCVERSION and
# MEMVERSION in MakefileVProc.mk, which clones the same versions for its build.
# mem_model and rv32 are used at commits past their last tags, so pass their
# refs to keep them.
#
# usage:  bash 4.sim/tools/vip-upgrade.sh          latest tag of each model
#         VPROC_REF=VERSION_1_13_4 MEM_MODEL_REF=c7b9c62 RV32_REF=774d84fa \
#         bash 4.sim/tools/vip-upgrade.sh
#
# Upstream clones go to VIP_WORK (default ~/.cache/wireguard-vip). Linux/WSL
# only. Needs git, gcc, make, sed, patch. Afterwards: make -f MakefileVProc.mk
# run, with BUILD=DEFAULT and BUILD=ISS, update the version table in
# 4.sim/README.md, and review the diff before committing.
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
M=$HERE/../models
MK=$HERE/../MakefileVProc.mk
W=${VIP_WORK:-$HOME/.cache/wireguard-vip}
mkdir -p "$W"

# clone or update a repo, check out $2 (default: its newest tag); prints the ref
fetch() {
    local repo=$1 ref=${2:-}
    [ -d "$W/$repo" ] || git clone -q "https://github.com/wyvernSemi/$repo.git" "$W/$repo"
    git -C "$W/$repo" fetch -q --tags origin
    [ -n "$ref" ] || ref=$(git -C "$W/$repo" tag --sort=-creatordate | head -1)
    git -C "$W/$repo" -c advice.detachedHead=false checkout -q "$ref"
    echo "$ref"
}

# upstream mixes CRLF and LF; we keep LF, with our SPDX line on top
# REUSE-IgnoreStart
SPDX_LINE='// SPDX-License-Identifier: GPL-3.0-or-later'
# REUSE-IgnoreEnd
put() {
    { printf '%s\n\n' "$SPDX_LINE"; tr -d '\r' < "$1"; } > "$2"
    [ -z "$(tail -c1 "$2")" ] || echo >> "$2"
}

VPROC_REF=$(fetch vproc "${VPROC_REF:-}")
MEM_MODEL_REF=$(fetch mem_model "${MEM_MODEL_REF:-}")
RV32_REF=$(fetch rv32 "${RV32_REF:-}")
echo "VProc $VPROC_REF, mem_model $MEM_MODEL_REF, rv32 $RV32_REF"

O=$(mktemp -d)
trap 'rm -rf "$O"' EXIT

# ---- VProc + mem_model: libcosimlnx.a (for the RTL-only Makefile) ----------
V=$W/vproc
MM=$W/mem_model
F="-c -fPIC -m64 -g -DVPROC_SV -DVERILATOR -DVP_MAX_NODES=64 -DMEM_MODEL_DEFAULT_ENDIAN=1 -I$V/code -I$MM/src"
for f in "$V/code/VSched.c" "$V/code/VUser.c" "$MM/src/mem.c" "$MM/src/mem_model.c"; do
    gcc $F "$f" -o "$O/$(basename "$f" .c).o"
done
rm -f "$M/cosim/lib/libcosimlnx.a"
ar cr "$M/cosim/lib/libcosimlnx.a" "$O"/VSched.o "$O"/VUser.o "$O"/mem.o "$O"/mem_model.o

# ---- VProc headers and HDL --------------------------------------------------
for f in VProc.h VProcClass.h VProcIrqClass.h VSched_pli.h VUser.h; do
    put "$V/code/$f" "$M/cosim/include/$f"
done
for f in f_VProc.v f_VProc.sv extradefs.v vprocdefs.vh vprocdpi.vh; do put "$V/$f" "$M/cosim/$f"; done

# ---- mem_model headers and HDL; mem_model.sv is ours ------------------------
for f in mem.h mem_model.h mem_model_pli.h; do put "$MM/src/$f" "$M/cosim/include/$f"; done
put "$MM/mem_model.v" "$M/cosim/f_mem_model.v"
put "$MM/mem_model_dpi.vh" "$M/cosim/mem_model_dpi.vh"

# ---- the versions MakefileVProc.mk clones for libvproc.a --------------------
MEM_HASH=$(git -C "$MM" rev-parse --short=7 HEAD)
sed -i -E -e "s/^(VPROCVERSION +=).*/\1 $VPROC_REF/" -e "s/^(MEMVERSION +=).*/\1 $MEM_HASH/" "$MK"

# ---- rv32: library sources (MakefileVProc.mk builds the library) -----------
# Only the files in models/rv32/src are refreshed; a file upstream adds to the
# library must be added there and to RV32_CPP in MakefileVProc.mk by hand.
R=$W/rv32/iss
for f in "$M"/rv32/src/*; do
    src="$R/src/$(basename "$f")"
    if [ -f "$src" ]; then tr -d '\r' < "$src" > "$f"; else echo "note: $(basename "$f") not in rv32 $RV32_REF, kept"; fi
done
if ! patch -s --no-backup-if-mismatch -p0 -d "$M/rv32/src" < "$M/rv32/rv32-openpcie.patch"; then
    echo "ERROR: rv32-openpcie.patch no longer applies to rv32 $RV32_REF."
    echo "       Port the fixes by hand into models/rv32/src, then regenerate the patch."
    exit 1
fi

echo "Done. Next: make -f MakefileVProc.mk run (BUILD=DEFAULT and BUILD=ISS),"
echo "update the version table in 4.sim/README.md, review the diff."
