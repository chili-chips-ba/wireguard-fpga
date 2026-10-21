#!/bin/bash
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause
#
# Format our RTL (own_rtl in sources.sh) in the project style:
#   1. every if, else, always, for, foreach, while, forever and initial body is
#      a begin ... end block, also when it is a single statement (the statement
#      positions come from the verible-verilog-syntax tree);
#   2. verible-verilog-format: Verible defaults (100-column limit) plus every
#      alignment option set to align, end and else on separate lines, LF line
#      endings. It does not wrap lines over the limit: wrap those by hand.
#
# usage:  bash run-format.sh            format every RTL file in place
#         bash run-format.sh --check    only report the files that are not
#                                       formatted; exit 1 if there are any
#
# Needs python3 and Verible (VERIBLE_FORMAT, VERIBLE_SYNTAX, VERIBLE_LINT can
# override the commands). Generated code (the PeakRDL csr.sv / csr_pkg.sv in
# 3.build/csr_build) is left as the generator writes it; third-party code
# (external_lib, PicoRV32) keeps its own style.

set -u
HERE=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$HERE/../.." && pwd)
. "$HERE/sources.sh"
VERIBLE_FORMAT=${VERIBLE_FORMAT:-verible-verilog-format}
VERIBLE_SYNTAX=${VERIBLE_SYNTAX:-verible-verilog-syntax}
VERIBLE_LINT=${VERIBLE_LINT:-verible-verilog-lint}

STYLE=(
  --line_terminator=LF
  --column_limit=100
  --assignment_statement_alignment=align
  --case_items_alignment=align
  --distribution_items_alignment=align
  --enum_assignment_statement_alignment=align
  --formal_parameters_alignment=align
  --module_net_variable_alignment=align
  --named_parameter_alignment=align
  --named_port_alignment=align
  --parameter_declaration_alignment=align
  --port_declarations_alignment=align
  --struct_union_members_alignment=align
  --wrap_end_else_clauses=true
)

for t in python3 "$VERIBLE_FORMAT" "$VERIBLE_SYNTAX" "$VERIBLE_LINT"; do
  command -v "$t" >/dev/null || { echo "run-format: $t not found" >&2; exit 2; }
done

MODE=format
[ "${1:-}" = "--check" ] && MODE=check

# Step 1: begin ... end around single-statement bodies. The syntax tree leaves
# out code under an undefined `ifdef, so a file is parsed as is, with all its
# `ifdef/`ifndef/`elsif macros defined, and once per macro with only that one
# defined (a `define put in front). --count only reports the number of bodies.
explicit_begin() {
  VERIBLE_SYNTAX="$VERIBLE_SYNTAX" python3 - "$@" <<'PY'
import json, os, re, subprocess, sys, tempfile

LOOPS = ('kForLoopStatement', 'kWhileLoopStatement', 'kForeachLoopStatement',
         'kForeverLoopStatement', 'kInitialStatement')

def leaves(n):
    if 'children' in n:
        for c in n['children']:
            if c is not None: yield from leaves(c)
    elif 'start' in n:
        yield n

def span(n):
    ls = list(leaves(n)); return ls[0]['start'], ls[-1]['end']

def bodies(n, parent, out):
    t, ks = n.get('tag'), [c for c in n.get('children', []) if c is not None]
    b = ks[-1] if ks else None
    if b is not None and b.get('tag') != 'kSeqBlock':
        if t == 'kIfBody' or (t == 'kElseBody' and b.get('tag') != 'kConditionalStatement') \
           or (t == 'kProceduralTimingControlStatement' and parent == 'kAlwaysStatement') \
           or (t in LOOPS and b.get('tag') != 'kGenerateBlock'):
            out.add(span(b))
    for c in ks:
        bodies(c, t, out)

def parse(data):
    with tempfile.NamedTemporaryFile(suffix='.sv', delete=False) as f:
        f.write(data)
    try:
        r = subprocess.run([os.environ['VERIBLE_SYNTAX'], '--export_json', '--printtree', f.name],
                           capture_output=True, text=True)
        tree = list(json.loads(r.stdout).values())[0].get('tree')
    finally:
        os.unlink(f.name)
    out = set()
    if tree: bodies(tree, None, out)
    return out

def views(data):
    """the file as is, all macros defined, each macro defined alone: (text, prefix length)"""
    names = sorted(set(re.findall(rb'`(?:ifn?def|elsif)\s+(\w+)', data)))
    sets = [[]] + ([names] if len(names) > 1 else []) + [[n] for n in names]
    for ns in sets:
        pre = b''.join(b'`define ' + n + b'\n' for n in ns)
        yield pre + data, len(pre)

count_only = sys.argv[1] == '--count'
total = 0
for path in sys.argv[2:]:
    data = open(path, 'rb').read()
    spans = set()
    for text, n in views(data):
        spans |= {(a - n, e - n) for a, e in parse(text) if a >= n}
    total += len(spans)
    if count_only or not spans:
        if spans: print('needs begin/end: %d body(ies) in %s' % (len(spans), os.path.basename(path)))
        continue
    ins = []
    for a, e in spans:
        ins.append((a, b'begin '))
        m = re.match(rb'[ \t]*//[^\n]*', data[e:])      # keep a trailing comment on its statement
        ins.append((e + m.end(), b'\nend') if m else (e, b' end'))
    for p, txt in sorted(ins, key=lambda x: x[0], reverse=True):
        data = data[:p] + txt + data[p:]
    open(path, 'wb').write(data)
print('-- explicit-begin: %d body(ies) %s' % (total, 'without begin/end' if count_only else 'wrapped'))
sys.exit(1 if count_only and total else 0)
PY
}

FILES=($(own_rtl "$REPO/1.hw" "$REPO/3.build"))
bad=0
if [ $MODE = check ]; then
  explicit_begin --count "${FILES[@]}" || bad=$((bad + 1))
else
  explicit_begin --apply "${FILES[@]}" || bad=$((bad + 1))
fi

# Step 2: verible-verilog-format. It can exit 0 on a file it cannot parse, so a
# message on stderr also counts as a failure.
nf=0
for f in "${FILES[@]}"; do
  if [ $MODE = check ]; then
    err=$("$VERIBLE_FORMAT" "${STYLE[@]}" --verify "$f" 2>&1 >/dev/null); rc=$?
    if [ $rc -ne 0 ] || [ -n "$err" ]; then echo "not formatted: ${f#$REPO/}"; nf=$((nf + 1)); fi
  else
    err=$("$VERIBLE_FORMAT" "${STYLE[@]}" --inplace "$f" 2>&1); rc=$?
    if [ $rc -ne 0 ] || [ -n "$err" ]; then echo "failed: ${f#$REPO/}: $(echo "$err" | head -1)" >&2; nf=$((nf + 1)); fi
  fi
done

# Cross-check with the Verible lint rule for the same thing
nl=$("$VERIBLE_LINT" --ruleset=none --rules=explicit-begin "${FILES[@]}" 2>&1 | grep -c 'explicit-begin')

if [ $MODE = check ]; then
  echo "-- verible-format: $nf file(s) not formatted"
else
  echo "-- verible-format: done, $nf failure(s)"
fi
echo "-- verible-lint explicit-begin: $nl finding(s)"

# Lines over the 100-column limit (the formatter leaves them as they are)
awk 'length > 100 { sub(".*/1.hw/", "1.hw/", FILENAME); print "over 100 columns: " FILENAME ":" FNR }' "${FILES[@]}"
nc=$(awk 'length > 100' "${FILES[@]}" | wc -l)
echo "-- line length: $nc line(s) over 100 columns"
[ $bad -eq 0 ] && [ $nf -eq 0 ] && [ $nl -eq 0 ] && [ $nc -eq 0 ]

# -----------------------------------------------------------------------------
# Project:     WireGuard-FPGA
# Description: NLnet-sponsored open-source implementation
# Ported from: openPCIE / openCologne-PCIE (4.build)
# -----------------------------------------------------------------------------
