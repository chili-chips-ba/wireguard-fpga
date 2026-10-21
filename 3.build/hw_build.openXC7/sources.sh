# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause
#
# The RTL file lists, one place for run-lint.sh, run-format.sh and run-leq.sh.
# The design is 1.hw/top.filelist, the list Vivado and 4.sim use. Source this
# file, then call a function:
#
#   design_rtl <1.hw> <3.build>   every .sv/.v file of top, in filelist order
#   own_rtl <1.hw> <3.build>      our own RTL: the design's, plus both soc_cpu
#                                 wrappers and eduBOS5, whichever CPU is in;
#                                 what run-format.sh formats and the verible
#                                 phase lints. Not ours: external_lib (Alex
#                                 Forencich's verilog-ethernet and verilog-axis),
#                                 PicoRV32 (YosysHQ), the PeakRDL-generated CSR.
#   cpu_select <top.filelist> <picorv32|edubos5>
#                                 switch the CPU in a copy of top.filelist: the
#                                 PicoRV32 lines or the eduBOS5 lines (commented
#                                 out there) go in

design_rtl() {
  local hw=$1 bld=$2
  sed -e 's/\r$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$hw/top.filelist" |
    grep -E '^[^#+].*\.s?v$' | sed -e "s|\${HW_SRC}|$hw|" -e "s|\${BLD_DIR}|$bld|"
}

own_rtl() {
  { design_rtl "$1" "$2" | grep -v -e '/external_lib/' -e '/cpu.PICORV32/' -e '/csr_build/'
    ls "$1"/ip.cpu/soc_cpu.*.sv "$1"/ip.cpu/cpu.EDUBOS5/*.sv
  } | awk '!seen[$0]++'
}

cpu_select() {
  local p='(ip.cpu/cpu.PICORV32/picorv32.CHILI|ip.cpu/soc_cpu.PICORV32).sv'
  local e='(ip.cpu/cpu.EDUBOS5/edubos5[a-z_]*|ip.cpu/soc_cpu.EDUBOS5).sv'
  case $2 in
    picorv32) sed -i -E -e "s@^#(.*$p)@\1@" -e "s@^([^#].*$e)@#\1@" "$1" ;;
    edubos5)  sed -i -E -e "s@^#(.*$e)@\1@" -e "s@^([^#].*$p)@#\1@" "$1" ;;
    *) echo "CPU must be picorv32 or edubos5, got \"$2\"" >&2; return 1 ;;
  esac
}

# -----------------------------------------------------------------------------
# Project:     WireGuard-FPGA
# Description: NLnet-sponsored open-source implementation
# -----------------------------------------------------------------------------
