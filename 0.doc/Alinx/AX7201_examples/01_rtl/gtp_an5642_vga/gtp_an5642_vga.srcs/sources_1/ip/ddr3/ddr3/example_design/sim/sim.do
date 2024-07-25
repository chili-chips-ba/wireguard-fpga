###############################################################################
## (c) Copyright 2008 – 2009 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
###############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /    Vendor             : Xilinx
## \   \   \/     Version            : 4.2
##  \   \         Application        : MIG
##  /   /         Filename           : sim.do
## /___/   /\     Date Last Modified : $Date: 2011/06/02 08:31:17 $
## \   \  /  \    Date Created       : Tue Sept 21 2010
##  \___\/\___\
##
## Device           : 7 Series
## Purpose          :
##                   Sample sim .do file to compile and simulate memory interface
##                   design and run the simulation for specified period of time.
##                   Display the waveforms that are listed with "add wave" command.
## Assumptions      :
##                   Simulation takes place in \sim folder of MIG output directory.
## Reference        :
## Revision History :
###############################################################################

vlib work

#Map the required libraries here#
#vmap unisims_ver <unisims_ver lib path>
#vmap unisim <unisim lib path>
#vmap secureip <secureip lib path>

#Compile all modules#
vlog  -incr mig_7series*.v
vlog  ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3.v
vlog  ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3_mig_sim.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/*.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/*.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/*.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/*.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/*.v
vlog  -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/*.v
vlog -incr ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/axi/*


vlog  example_top.v

#Compile files in sim folder (excluding model parameter file)#
#$XILINX variable must be set
vlog  -incr $env(XILINX_VIVADO)/data/verilog/src/glbl.v
vlog wiredly.v
vlog sim_tb_top.v

#Pass the parameters for memory model parameter file#
vlog -sv +define+x4Gb +define+sg125 +define+x16 ddr3_model.sv

#Load the design. Use required libraries.#
vsim -t fs -novopt +notimingchecks -L unisims_ver -L secureip work.sim_tb_top glbl

onerror {resume}
#Log all the objects in design. These will appear in .wlf file#
#This helps in viewing all signals of the design instead of 
#re-running the simulation for viewing the signals.
#Uncomment below line to log all objects in the design. 
#log -r /*

#View sim_tb_top signals in waveform#
add wave sim:/sim_tb_top/*
#Change radix to Hexadecimal#
radix hex
#Supress Numeric Std package and Arith package warnings.#
#For VHDL designs we get some warnings due to unknown values on some signals at startup#
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0#
#We may also get some Arithmetic packeage warnings because of unknown values on#
#some of the signals that are used in an Arithmetic operation.#
#In order to suppress these warnings, we use following two commands#
set NumericStdNoWarnings 1
set StdArithNoWarnings 1

# Choose simulation run time by inserting a breakpoint and then run for specified #
# period. For more details, refer to user guide (UG586).#
# Status reporting logic exists both in simulation test bench (sim_tb_top)
# and sim.do file for ModelSim. Any update in simulation run time or time out
# in this file need to be updated in sim_tb_top file as well.
when {/sim_tb_top/init_calib_complete = 1} {
if {[when -label a_100] == ""} {
when -label a_100 { $now = 50 us } {
nowhen a_100
report simulator control
report simulator state
if {[examine /sim_tb_top/tg_compare_error] == 0} {
echo "TEST PASSED"
stop
}
if {[examine /sim_tb_top/tg_compare_error] != 0} {
echo "TEST FAILED: DATA ERROR"
stop
}
}
}
}

#In case calibration fails to complete, choose the run time and then stop#
when {$now = @1000 us and /sim_tb_top/init_calib_complete != 1} {
echo "TEST FAILED: CALIBRATION DID NOT COMPLETE"
stop
}

run -all
stop

