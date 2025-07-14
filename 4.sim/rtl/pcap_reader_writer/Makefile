#=============================================================
# Copyright (C) 2024-2025 Chili.CHIPS*ba
#=============================================================
SHELL   := /bin/bash

BLD_DIR := $(CURDIR)/../../../3.build
HW_SRC  := $(CURDIR)
TB_NAME := tb

ARE_TESTS :=

COLOR_YELLOW=\033[1;33m
COLOR_RESET=\033[0m

export BLD_DIR HW_SRC TB_NAME

#------------------------
.PHONY: all
all: clean sim wave

#------------------------
clean:
	rm -rf output

compile:
	verilator \
		-Wall \
		-Wno-PINCONNECTEMPTY \
		-Wno-UNUSEDPARAM \
                -Wno-UNUSEDSIGNAL \
		-Wno-GENUNNAMED \
                -Wno-PROCASSINIT \
		--cc \
		--timing \
		--trace-fst \
		--trace-structs \
		--timescale-override 1ps/1ps \
		--exe versimSV.cpp \
		--Mdir ./output \
		+define+SIM_ONLY \
		$(ARE_TESTS) \
		-f ${HW_SRC}/top.filelist \
		${TB_NAME}.sv \
		--top-module ${TB_NAME}

#------------------------
sim: compile
	cd output; \
	make -f V${TB_NAME}.mk  V${TB_NAME}; \
	./V${TB_NAME} | tee sim.log

#------------------------
wave: xml2stems
	cd output; \
	gtkwave --saveonexit \
		--slider-zoom \
		--stems   ../tb.stems \
		--logfile sim.log \
		-rc       ../.gtkwaverc \
		--dump    wave.fst &

#------------------------
wave-alt:
	cd output; \
	surfer.exe -s ../wave.surfer.ron wave.fst &

#------------------------
xml2stems:
	verilator \
                -Wno-DEPRECATED \
		--timing \
		-xml-only \
		-xml-output tb.xml \
		--timescale 1ps/1ps \
		-f ${HW_SRC}/top.filelist \
		${TB_NAME}.sv \
		--top-module ${TB_NAME}
	xml2stems tb.xml tb.stems

#------------------------
rtlbrowse: xml2stems
	rtlbrowse tb.stems
#------------------------

#=============================================================
# End-of-File
#=============================================================

