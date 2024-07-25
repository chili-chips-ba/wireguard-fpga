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
##  /   /         Filename           : ies_run.sh
## /___/   /\     Date Last Modified : $Date: 2011/06/02 08:31:17 $
## \   \  /  \    Date Created       : Tue Oct 29 2013
##  \___\/\___\
##
## Device           : 7 Series
## Purpose          :
##                   Sample ies_run.sh file to compile and simulate memory interface
##                   design and run the simulation for specified period of time.
##                   Display the waveforms that are listed with "add wave" command.
## Assumptions      :
##                   Simulation takes place in \sim folder of MIG output directory.
## Reference        :
## Revision History :
###############################################################################

#echo Simulation Tool: IES

#Compile the required libraries here#
#libraries path#

#Compile all modules#
ncvlog -work worklib -sv -messages mig_7series*.v > ies_sim.log
ncvlog -sv -work worklib -messages ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3.v >> ies_sim.log
ncvlog -sv -work worklib -messages ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3_mig_sim.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/*.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/*.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/*.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/*.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/*.v >> ies_sim.log
ncvlog -work worklib -messages -sv ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/*.v >> ies_sim.log
ncvlog -sv -work worklib -messages ../ddr3_ex.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/axi/*.v >> ies_sim.log 


ncvlog -sv -work worklib -messages example_top.v >> ies_sim.log

#Compile files in sim folder (excluding model parameter file)#
#$XILINX variable must be set
ncvlog -work worklib -messages $XILINX_VIVADO/data/verilog/src/glbl.v >> ies_sim.log
ncvlog -work worklib -messages wiredly.v >> ies_sim.log
ncvlog -work worklib -messages sim_tb_top.v >> ies_sim.log

#Pass the parameters for memory model parameter file#
ncvlog -work worklib -messages -sv +define+x4Gb +define+sg125 +define+x16 ddr3_model.sv >> ies_sim.log 

#Simulate the design with sim_tb_top as the top module
ncelab -namemap_mixgen -timescale '1ps/1ps' -vhdlsync -v93 -messages -nettype_port_relax -access +rwc sim_tb_top glbl >> ies_sim.log
ncsim sim_tb_top >> ies_sim.log
#echo done

