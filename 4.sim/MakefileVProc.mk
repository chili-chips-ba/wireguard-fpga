# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

# --------------------------------------------
# Command line modifiable variables
# --------------------------------------------

USER_C           =              # user sources for libuser (UDP nodes)
USRCODEDIR       = $(CURDIR)/usercode
OPTFLAG          = -g
TIMINGOPT        = --timing
TRACEOPTS        = --trace-fst --trace-structs
TOPFILELIST      = top.filelist
SOCCPUMATCH      = ip.cpu
USRSIMOPTS       =
USRCFLAGS        =
WAVESAVEFILE     = wave.CSR_ETHERNET_TEST.gtkw
BUILD            = DEFAULT
# vproc: VProc is soc_cpu (BUILD=DEFAULT or ISS); rtl: the RTL soc_cpu that
# 1.hw/top.filelist lists (PicoRV32 or eduBOS5), running 3.build/sw_build
CPU              = vproc
TIMEOUTUS        = 10000
DISABLE_SIM_CTRL = 1
# BUILD=ISS only. 1: bus credit and no fetch/load wait states (as openPCIE),
# 0: wireguard's original ISS timing (see models/rv32/usercode/VUserMain0.cpp)
ISS_BUS_CREDIT   = 0

# --------------------------------------------
# Global exported environment variables
# --------------------------------------------

HW_SRC          := $(CURDIR)/../1.hw
BLD_DIR         := $(CURDIR)/../3.build
SIM_DIR         := $(CURDIR)/../4.sim
TB_NAME         := tb

export BLD_DIR HW_SRC SIM_DIR TB_NAME

# --------------------------------------------
# VProc C/C++ variables
# --------------------------------------------

# Location of VProc and memory model libraries
COSIMDIR       = $(CURDIR)/models/cosim
UDPDIR         = $(CURDIR)/models/udpIpPg
UDP_C          = VUserMainUdp.cpp
UDPCODEDIR     = $(CURDIR)/usercode

# VProc external dependency (for VerilatorSimCtrl). Cloned next to the repo,
# one directory per version, so that a version bump gets a fresh clone.
# The HDL and headers in models/cosim are the same version (tools/vip-upgrade.sh).
VPROC_REPO     = https://github.com/wyvernSemi/vproc.git
VLIB           = $(CURDIR)/libvproc.a
VPROCVERSION   = VERSION_1_13_4
VPROCDIR       = $(CURDIR)/../../vproc-$(VPROCVERSION)
VPROCMKFILE    = makefile.verilator
AUX_C          = VerilatorSimCtrl.cpp
AUXDIR         = $(VPROCDIR)/verilator/src

# Memory model (required by VProc build), at a commit past its last tag
MEMMODEL_REPO  = https://github.com/wyvernSemi/mem_model.git
MEMVERSION     = c7b9c62
MEMMODELDIR    = $(CURDIR)/../../mem_model-$(MEMVERSION)
MEM_C          = mem.c mem_model.c

# VProc user code lives in models/rv32/usercode: the sim-control node (VSC,
# node 15) always, the rv32 ISS for node 0 with BUILD=ISS. With BUILD=DEFAULT,
# node 0 runs the 2.sw firmware itself, compiled for the host (libuser).
VPROC_USRCDIR  = $(CURDIR)/models/rv32/usercode
VPROC_USER_C   = VUserMainVSC.cpp
ISS_USER_C     = VUserMain0.cpp mem_vproc_api.cpp uart.cpp rv32_cache.cpp vuserutils.cpp

# --------------------------------------------
# RV32 ISS variables (Linux/WSL only)
# --------------------------------------------
#
# If BUILD is ISS, then override user source code list and directory
# and define extra flags
#
VOBJDIR          = $(CURDIR)/obj

ifeq ("$(BUILD)", "ISS")

  # VProc ISS build: rv32 user code for node0 + VSC (node15) built into libvproc
  VPROC_USER_C   := $(VPROC_USER_C) $(ISS_USER_C)

  # UDP BFMs (nodes 1-4) stay in libuser from usercode/
  UDP_C          = VUserMainUdp.cpp

  # The ISS library is built here from the rv32 sources (upstream iss/src,
  # plus models/rv32/rv32-openpcie.patch), with upstream's flags
  RV32DIR        = $(CURDIR)/models/rv32
  RV32SRC        = $(RV32DIR)/src
  RV32INCLOPTS   = -I$(RV32SRC)
  RV32OBJDIR     = $(VOBJDIR)/rv32
  RV32LIB        = $(RV32OBJDIR)/librv32.a
  RV32LDOPTS     = $(RV32LIB)
  RV32OPTFLAG    = -O3
  RV32_CPP       = rv32i_cpu_elf rv32_cpu_gdb rv32i_cpu rv32csr_cpu rv32m_cpu rv32a_cpu \
                   rv32f_cpu rv32d_cpu rv32c_cpu rv32zba_cpu rv32zbb_cpu rv32zbs_cpu rv32zbc_cpu
  RV32OBJS       = $(addprefix $(RV32OBJDIR)/, $(RV32_CPP:=.o))
  RV32DEFS       = -DRV32_BUS_CREDIT=$(ISS_BUS_CREDIT)
else
  # node 0: the 2.sw firmware, compiled for the host as C++ with main()
  # renamed fw_main() for usercode/VUserMain0.cpp to call. Under VPROC its
  # register accesses (csr_regs.h) are VProc bus cycles. The same
  # sources and defines as 3.build/MakefileSW.
  USER_C        := VUserMain0.cpp $(USER_C)
  FW_C           = uart ethernet network string_bare chacha20 poly1305 chacha20poly1305 \
                   curve25519 tweetnacl_x25519 blake2s hkdf random timer
  FW_CPP         = main
endif

# --------------------------------------------
# VProc user code build variables
# --------------------------------------------

# Compiler executables and standard flags
CC               = gcc
C++              = g++
CPPSTD           = -std=c++20

# C/C++ include paths for VProc, memory model and user code. The VProc and
# mem_model headers come from the clones only (not models/cosim/include, which
# is for the RTL-only Makefile), so one version is used.
INCLPATHS        = -I$(USRCODEDIR) -I$(UDPCODEDIR) -I$(UDPDIR)/include -I$(VPROCDIR)/code -I$(VPROCDIR)/verilator/src -I$(MEMMODELDIR)/src -I$(VPROC_USRCDIR) $(RV32INCLOPTS)
DEFS             = -DVERILATOR -DVPROC_SV -DVPROC

# Object directories: libuser, libvproc (VProc's make file) and the ISS
# library each have their own, so a file name in two of them cannot collide
USROBJDIR        = $(VOBJDIR)/user
VPROCOBJDIR      = $(VOBJDIR)/vproc

# Separate C and C++ source files
USER_CPP_BASE    = $(notdir $(filter %cpp, $(USER_C) $(UDP_C)))
USER_C_BASE      = $(notdir $(filter %c,   $(USER_C) $(UDP_C)))

# Create list of object files (excluding any veriuser object)
VOBJS            = $(addprefix $(USROBJDIR)/,                 \
                    $(USER_C_BASE:%.c=%.o)                    \
                    $(USER_CPP_BASE:%.cpp=%.o)                \
                    $(addprefix fw_,$(FW_C:=.o) $(FW_CPP:=.o)))

# The firmware (BUILD=DEFAULT): its own directory first, as the ISS code
# has a uart.h too
FW_SRC_DIR       = $(CURDIR)/../2.sw/app
FW_HOST_FLAGS    = -x c++ -Dmain=fw_main -Wno-volatile -DTCM=1 -DHARVARD=1 -DUART_TEST \
                   -I$(FW_SRC_DIR) -I$(BLD_DIR)/csr_build -I$(BLD_DIR)/csr_build/generated-files
FW_HOST_DEPS     = $(wildcard $(FW_SRC_DIR)/*.h) $(BLD_DIR)/csr_build/csr_regs.h

USERLIB          = libuser.a

# Rule to build object file temporary directories
$(USROBJDIR) $(VPROCOBJDIR):
	@mkdir -p $@

# Rule to build user C sources
$(USROBJDIR)/%.o: $(USRCODEDIR)/%.c | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(CC) -c -fPIC $(OPTFLAG) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build user C++ sources
$(USROBJDIR)/%.o: $(USRCODEDIR)/%.cpp | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rules to build the firmware for the host (BUILD=DEFAULT)
$(USROBJDIR)/fw_%.o: $(FW_SRC_DIR)/%.c $(FW_HOST_DEPS) | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) $(FW_HOST_FLAGS) $(DEFS) $(INCLPATHS) $< -o $@

$(USROBJDIR)/fw_%.o: $(FW_SRC_DIR)/%.cpp $(FW_HOST_DEPS) | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) $(FW_HOST_FLAGS) $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build UDP user C sources
$(USROBJDIR)/%.o: $(UDPCODEDIR)/%.c | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(CC) -c -fPIC $(OPTFLAG) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# Rule to build UDP user C++ sources
$(USROBJDIR)/%.o: $(UDPCODEDIR)/%.cpp | $(USROBJDIR) $(VPROCDIR) $(MEMMODELDIR)
	@$(C++) -c -fPIC $(OPTFLAG) $(CPPSTD) -Wno-write-strings $(DEFS) $(INCLPATHS) $< -o $@

# The node 0 code differs per BUILD (native test code in libuser, or the ISS
# in libvproc): a change of BUILD, of the model versions, of ISS_BUS_CREDIT
# or of the user code lists (USER_C, UDP_C) throws the objects and both
# libraries away, so the next build cannot mix them. obj/.build holds the
# configuration of the last build.
BUILD_CFG        = $(CPU) $(BUILD) $(VPROCVERSION) $(MEMVERSION) $(ISS_BUS_CREDIT) $(USER_C) $(UDP_C)
BUILD_STAMP      = $(VOBJDIR)/.build
$(BUILD_STAMP): FORCE
	@mkdir -p $(VOBJDIR)
	@if [ "$$(cat $@ 2>/dev/null)" != "$(BUILD_CFG)" ]; then              \
	    rm -rf $(USROBJDIR) $(VPROCOBJDIR) $(USERLIB) $(VLIB);            \
	    echo "$(BUILD_CFG)" > $@;                                         \
	fi

FORCE:

# Rule to build library of user code
# Note: delete existing archive first to avoid stale objects (e.g. switching UDP_C),
# and the simulator: Verilator's make does not see a new library, so it relinks
$(USERLIB): $(BUILD_STAMP) $(VOBJS)
	@rm -f $(USERLIB) $(SIMEXE)
	@ar crs $(USERLIB) $(VOBJS)

# Rules to build the rv32 ISS library (BUILD=ISS)
ifeq ("$(BUILD)", "ISS")
$(RV32OBJDIR):
	@mkdir -p $@

$(RV32OBJDIR)/%.o: $(RV32SRC)/%.cpp $(wildcard $(RV32SRC)/*.h) | $(RV32OBJDIR)
	@$(C++) -c -fPIC $(RV32OPTFLAG) -I$(RV32SRC) -D_REENTRANT $< -o $@

$(RV32LIB): $(RV32OBJS)
	@rm -f $@
	@ar cr $@ $(RV32OBJS)
endif

UDPLDOPT         = -ludplnx

WARNOPTS       = -Wall models/config.vlt
USRCDEFS      = -DMEM_MODEL_DEFAULT_ENDIAN=1

# --------------------------------------------
# Simulation variables
# --------------------------------------------

TBFILELIST    = $(TB_NAME).filelist

WORKDIR          = output

SIMOPTS       = --cc                                          \
                --timescale-override 1ps/1ps                  \
                --exe versimSV.cpp                            \
                -sv                                           \
                $(TRACEOPTS) $(TIMINGOPT) $(USRSIMOPTS)       \
                -GRUN_SIM_US=$(TIMEOUTUS)                     \
                -GDISABLE_SIM_CTRL=$(DISABLE_SIM_CTRL)        \
                $(VPROCDIR)/verilator/verilator_sim_ctrl.sv   \
                -Mdir $(WORKDIR)                              \
                -Wno-WIDTH

SIMDEFS          = +define+VPROC_BYTE_ENABLE                  \
                   +define+SIM_ONLY                           \
#                                                             \
#                   +define+SDRAM_DEBUG                       \
#                   +define+UART_BFM_DEBUG

SIMINCLPATHS     = -I$(CURDIR) -I$(COSIMDIR) -I$(UDPDIR)/verilator -I$(VPROCDIR) -I$(VPROCDIR)/verilator -I$(MEMMODELDIR)
SIMCFLAGS        = -std=c++20 -Wno-attributes $(USRCFLAGS)

# Get OS type
OSTYPE          := $(shell uname)

ifneq ($(OSTYPE), Linux)
  SIMLDFLAGS     = -Wl,-export-all-symbols
else
  SIMLDFLAGS     = -Wl,-E
endif

SIMMAKEFLAGS     = --quiet
SIMEXE           = $(WORKDIR)/V$(TB_NAME)

#
# GTKWave variables
#
GTKWAVEOPTS    = --saveonexit                                 \
                 --stems   ./tb.stems                         \
                 --logfile sim.log                            \
                 --dump    $(WAVEFILE)

WAVEFILE         = wave.fst

#
# Formatting
#

SPC =

#======================================================
# BUILD RULES
#======================================================

.PHONY: all compile run rungui gui help clean FORCE

all: $(TOPFILELIST) $(SIMEXE)

#
# Call VProc's Verilator test makefile to compile library into
# this directory, including the memory model code and user code.
#
$(VLIB): $(BUILD_STAMP) $(VPROCDIR) $(MEMMODELDIR) $(addprefix $(VPROC_USRCDIR)/,$(VPROC_USER_C)) | $(VPROCOBJDIR)
	@make --no-print-directory -C $(VPROCDIR)/test        \
              -f $(VPROCMKFILE) ARCHFLAG=$(OPTFLAG)           \
              USRFLAGS="$(INCLPATHS) $(USRCDEFS) $(RV32DEFS) $(USRFLAGS)" \
              USRCDIR=$(VPROC_USRCDIR)                        \
              USER_C="$(VPROC_USER_C)"                        \
              MEMMODELDIR=$(MEMMODELDIR)/src                  \
              MEM_C="$(MEM_C)"                                \
              AUXDIR=$(AUXDIR)                                \
              AUX_C="$(AUX_C)"                                \
              TESTDIR=$(CURDIR)                               \
              VOBJDIR=$(VPROCOBJDIR)                          \
              $(VLIB)

#
# Compile simulation C++ code. The executable is always relinked: the
# Verilator make file does not track the libraries, and the linker (mold)
# fails to overwrite an existing executable on a network share.
#
compile: $(USERLIB) $(VLIB) $(RV32LIB)
	@rm -f $(SIMEXE)
	@verilator    $(WARNOPTS)                            \
	               -F $(TOPFILELIST)                      \
                   -F $(TBFILELIST)                       \
	               $(SIMOPTS)                             \
	               $(SIMDEFS) $(SIMINCLPATHS)             \
	               $(ARE_TESTS)                           \
	   --top       $(TB_NAME)                             \
	   -MAKEFLAGS "$(SIMMAKEFLAGS)"                       \
	   -CFLAGS    "$(SIMCFLAGS)"                          \
	   -LDFLAGS   "$(SIMLDFLAGS)                          \
	               -Wl,-whole-archive                     \
	               -L$(CURDIR) -lvproc                    \
	               -L$(CURDIR) -luser                     \
	               -L$(UDPDIR)/lib $(UDPLDOPT)            \
	               -Wl,-no-whole-archive                  \
	               -ldl $(RV32LDOPTS)"

#
# Generate Verilator test bench executable
#
$(SIMEXE): compile
	@+make --no-print-directory $(SIMMAKEFLAGS) -C$(WORKDIR) -f V$(TB_NAME).mk V$(TB_NAME)

# Create local file list for top, with the RTL soc_cpu files removed, so
# soc_cpu.VPROC is used instead (CPU=vproc). CPU=rtl keeps them, and drops
# soc_cpu.VPROC from the test bench list.
ifeq ("$(CPU)", "rtl")
  SOCCPUMATCH    = __rtl_soc_cpu_kept__
  TBFILELIST     = $(VOBJDIR)/$(TB_NAME)_rtl.filelist
compile: $(TBFILELIST)
$(TBFILELIST): $(TB_NAME).filelist $(BUILD_STAMP)
	@grep -v "soc_cpu.VPROC.sv" $< > $@
endif
$(TOPFILELIST): $(HW_SRC)/$(TOPFILELIST) $(BUILD_STAMP)
	@sed -e "/$(SOCCPUMATCH)/d" $< > $@

# Clone the VIP models (VProc, mem_model) only
.PHONY: vip
vip: $(VPROCDIR) $(MEMMODELDIR)

# Check out VProc repo if not at expected location
$(VPROCDIR):
	@git clone --depth 1 --branch $(VPROCVERSION) $(VPROC_REPO) $(VPROCDIR) --recursive

# Check out memory model repo if not at expected location. MEMVERSION is a
# commit, which --branch cannot take: clone, then check it out.
$(MEMMODELDIR):
	@git clone -q $(MEMMODEL_REPO) $(MEMMODELDIR)
	@git -C $(MEMMODELDIR) -c advice.detachedHead=false checkout -q $(MEMVERSION)

xml2stems: $(TOPFILELIST)
	@verilator                                            \
            $(WARNOPTS)                                   \
	        --timing                                      \
	        -xml-only                                     \
	        -xml-output tb.xml                            \
	        --timescale 1ps/1ps                           \
	        $(SIMINCLPATHS) $(SIMDEFS)                    \
	        -F $(TOPFILELIST)                             \
	        -F $(TBFILELIST)                              \
	        -MAKEFLAGS "$(SIMMAKEFLAGS)"                  \
	        -Wno-WIDTH                                    \
	        --top-module $(TB_NAME)
	@xml2stems tb.xml tb.stems

#======================================================
# EXECUTION RULES
#======================================================

run: all
	@$(SIMEXE)

rungui: all xml2stems
	@$(SIMEXE) | tee sim.log
	@if [ -e $(WAVESAVEFILE) ]; then                      \
	    gtkwave -a $(WAVESAVEFILE) $(GTKWAVEOPTS);        \
	else                                                  \
	    gtkwave $(GTKWAVEOPTS);                           \
	fi

gui: rungui

help:
	@$(info make -f MakefileVProc.mk help          Display this message)
	@$(info make -f MakefileVProc.mk               Build C/C++ and HDL code without running simulation)
	@$(info make -f MakefileVProc.mk run           Build and run batch simulation)
	@$(info make -f MakefileVProc.mk rungui/gui    Build and run GUI simulation)
	@$(info make -f MakefileVProc.mk clean         clean previous build artefacts)
	@$(info )
	@$(info Command line configurable variables:)
	@$(info $(SPC) $(SPC) USER_C:           list of user source code files (default VUserMain0.cpp))
	@$(info $(SPC) $(SPC) USRCODEDIR:       directory containing user source code (default $$(CURDIR)/usercode))
	@$(info $(SPC) $(SPC) OPTFLAG:          Optimisation flag for VProc code (default -g))
	@$(info $(SPC) $(SPC) TIMINGOPT:        Verilator timing flags (default --timing))
	@$(info $(SPC) $(SPC) TRACEOPTS:        Verilator trace flags (default --trace-fst --trace-structs))
	@$(info $(SPC) $(SPC) TOPFILELIST:      RTL file list name (default top.filelist))
	@$(info $(SPC) $(SPC) SOCCPUMATCH:      string to match for soc_cpu filtering in h/w file list (default ip.cpu))
	@$(info $(SPC) $(SPC) USRSIMOPTS:       additional Verilator flags, such as setting generics (default blank))
	@$(info $(SPC) $(SPC) WAVESAVEFILE:     name of .gtkw file to use when displaying waveforms (default wave.CSR_ETHERNET_TEST.gtkw))
	@$(info $(SPC) $(SPC) BUILD:            Select build type from DEFAULT or ISS (default DEFAULT))
	@$(info $(SPC) $(SPC) CPU:              vproc (VProc soc_cpu) or rtl (the RTL soc_cpu in 1.hw/top.filelist) (default vproc))
	@$(info $(SPC) $(SPC) TIMEOUTUS:        Test bench timeout period in microseconds (default 10000))
	@$(info $(SPC) $(SPC) DISABLE_SIM_CTRL: Disable/enable Verilator simulation control (default disabled))
	@$(info $(SPC) $(SPC) ISS_BUS_CREDIT:   BUILD=ISS: 1 for bus credit and no fetch/load wait states (default 0))
	@$(info )

#======================================================
# CLEANING RULES
#======================================================

clean:
	@rm -rf $(WORKDIR) $(WAVEFILE) $(TOPFILELIST) $(VOBJDIR) $(USERLIB) $(VLIB) obj_dir
