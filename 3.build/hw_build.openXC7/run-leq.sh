#!/bin/bash
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause
#
# Formal equivalence check of the whole design (top: Ethernet MACs and PHY
# interfaces, DPE, SOC, CPU, CSR) between two versions of the RTL, with Yosys
# (read_slang), chip view (SYNTHESIS defined). Use it to prove that a cleanup
# does not change behaviour.
#
# usage:  bash run-leq.sh <gold 1.hw> <gate 1.hw> [sed script]
#         LEQ_EXTRA=<file> bash run-leq.sh ... Yosys commands run after equiv_make,
#                                              e.g. equiv_add for registers that
#                                              were regrouped into a struct
#                                              (gold: name_gold, gate: name_gate):
#           cd eq
#           equiv_add -try \u_x.ng_cur_state_gold \u_x.ng_q_gate[12]
#           cd ..
#   <gold 1.hw>, <gate 1.hw>  copies of 1.hw, e.g. before the change:
#                             mkdir -p /tmp/gold && git archive HEAD 1.hw | tar -x -C /tmp/gold
#                             bash run-leq.sh /tmp/gold/1.hw ../../1.hw
#   [sed script]              renames gold objects to their gate names, for a
#                             change that moves logic between modules, e.g.
#                             's|^u_soc\.u_x\.|u_soc.|'
#
# Both versions use the same generated CSR (3.build/csr_build/generated-files)
# and the same imem.INIT.vh (3.build/sw_build) for the IMEM contents.
#
# The Xilinx primitives (PLLE2_BASE, BUFG, IBUFGDS, ODDR, ...) are black boxes
# turned into ports (expose -evert): their inputs are compared, their outputs
# are shared free inputs. equiv_induct starts from any state, so logic that is
# only constant after reset shows up as unproven and needs a look by hand.
#
# Memories stay memory cells (memory -nomap): the FIFOs hold over 1M bits,
# too many to prove as flops. equiv_struct merges the memories whose inputs
# match; a memory whose inputs differ ends the run with "No SAT model
# available for cell ... ($mem_v2)". Only "Equivalence successfully proven"
# is a pass.
#
# Needs Yosys with read_slang: built into the openXC7 Yosys; with the OSS CAD
# Suite, YOSYS_ARGS="-m slang". YOSYS, YOSYS_CONFIG and PYTHON override the
# commands.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
. "$HERE/sources.sh"
GOLD=$(cd "$1" && pwd); GATE=$(cd "$2" && pwd); MAP=${3:-}
BLD=$(cd "$HERE/.." && pwd)
TOP=top
YOSYS=${YOSYS:-yosys}
YOSYS_CONFIG=${YOSYS_CONFIG:-yosys-config}
YOSYS_ARGS=${YOSYS_ARGS:-}
PYTHON=${PYTHON:-python3}
PRIMS="PLLE2_BASE BUFG IBUFGDS BUFGMUX BUFIO BUFIO2 BUFR ODDR ODDR2"
W=$(mktemp -d); cd "$W"

"$PYTHON" "$HERE/gen_xilinx_bb.py" "$("$YOSYS_CONFIG" --datdir)/xilinx" bb.sv $PRIMS >/dev/null

files() {  # $1 = 1.hw dir
  echo bb.sv $(design_rtl "$1" "$BLD" | tr '\n' ' ')
}
BB=$(for p in $PRIMS; do printf 't:%s ' $p; done)
READ="read_slang -D SYNTHESIS -D SYN_YOSYS_BUG --top $TOP -I $BLD/sw_build"
PREP="hierarchy -top $TOP; proc; flatten; memory -nomap; async2sync"

REN=""
if [ -n "$MAP" ]; then   # rename gold objects to their gate names (skip names the gold already has)
  cat > names.ys <<EOF
$READ $(files $GOLD)
$PREP
tee -q -o names.txt select -list $TOP/w:* $TOP/c:*
EOF
  "$YOSYS" $YOSYS_ARGS -q names.ys >/dev/null
  sed "s|^$TOP/||" names.txt | sed -n "h; $MAP; G; s/\n/ /; p" |
    awk 'NR==FNR {have[$1]=1; next} $1!=$2 && substr($2,1,1)!="$" && !($1 in have) {print "rename \\" $2 " \\" $1}' \
        <(sed "s|^$TOP/||" names.txt) - > ren.ys
  echo "renamed: $(wc -l < ren.ys)"
  REN="cd $TOP; script ren.ys; cd .."
fi

EXTRA=""
[ -n "${LEQ_EXTRA:-}" ] && EXTRA="script $(cd "$(dirname "$LEQ_EXTRA")" && pwd)/$(basename "$LEQ_EXTRA")"

cat > eq.ys <<EOF
$READ $(files $GOLD)
$PREP
$REN
expose -evert $BB; opt_clean; rename $TOP gold; design -stash gold
$READ $(files $GATE)
$PREP
expose -evert $BB; opt_clean; rename $TOP gate; design -stash gate
design -copy-from gold -as gold gold
design -copy-from gate -as gate gate
equiv_make gold gate eq
hierarchy -top eq
$EXTRA
equiv_struct
equiv_simple -seq 3
equiv_induct -seq 3
equiv_status
EOF
"$YOSYS" $YOSYS_ARGS -q -l eq.log eq.ys >/dev/null || true
grep -E "Found [0-9]+ .equiv|Of those cells|successfully proven|^ERROR" eq.log | tail -3
grep "Unproven" eq.log | sed -E 's/.*: .([^ ]*)_gold.*/\1/; s/\[[0-9]+\]//g' | sort | uniq -c
echo "log: $W/eq.log"

# -----------------------------------------------------------------------------
# Project:     WireGuard-FPGA
# Description: NLnet-sponsored open-source implementation
# Ported from: openPCIE / openCologne-PCIE (4.build)
# -----------------------------------------------------------------------------
