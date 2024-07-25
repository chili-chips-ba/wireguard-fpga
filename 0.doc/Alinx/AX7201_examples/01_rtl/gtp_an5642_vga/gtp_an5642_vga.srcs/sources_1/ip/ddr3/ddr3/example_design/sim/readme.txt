###############################################################################
## (c) Copyright 2009 - 2012 Xilinx, Inc. All rights reserved.
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
##  /   /         Filename           : readme.txt
## /___/   /\     Date Last Modified : $Date: 2011/06/02 08:31:16 $
## \   \  /  \    Date Created       : Tue Sept 21 2010
##  \___\/\___\
##
## Device          : 7 Series
## Design Name     : DDR3 SDRAM
## Purpose         : Steps to run simulations using Modelsim/QuestaSim,
##                   Cadence IES, and Synopsys VCS
## Assumptions     : Simulations are run in \sim folder of MIG output "Open IP
##                   Example Design" directory
## Reference       :
## Revision History:
###############################################################################

MIG outputs script files required to run the simulations for Modelsim/QuestaSim,
Vivado Simulator, IES and VCS. These scripts are valid only for running
simulations for "Open IP Example Design"

1. How to run simulations in Modelsim/QuestaSim simulator

   A) sim.do File :

      a) The 'sim.do' file has commands to compile and simulate memory
         interface design and run the simulation for specified period of time.

      b) It has the syntax to Map the required libraries (unisims_ver,
         unisim and secureip). The libraries should be mapped using
         the following command
         vmap unisims_ver <unisims_ver lib path>
         vmap unisim <unisim lib path>
         vmap secureip  <secureip lib path>

         Also, $XILINX_VIVADO environment variable must be set in order to compile glbl.v file

      c) Displays the waveforms that are listed with "add wave" command.

   B) Steps to run the Modelsim/QuestaSim simulation:

      a) The user should invoke the Modelsim/QuestaSim simulator GUI.

      b) Change the present working directory path to the sim folder.
         In Transcript window, at Modelsim/QuestaSim prompt, type the following
         command to change directory path.
            cd <sim directory path>

      c) Run the simulation using sim.do file.
         At Modelsim/QuestaSim prompt, type the following command:
            do sim.do

      d) To exit simulation, type the following command at Modelsim/QuestaSim
         prompt:
            quit -f

      e) Verify the transcript file for the memory transactions.

2. How to run simulations in Vivado simulator

   A) Following files are provided :

      a) The 'xsim_run.bat' is the executable file for Vivado simulator under
         MicroSoft Windows environment.

      b) The 'xsim_run.sh' is the executable file for Vivado simulator under
         Linux environment.

      c) The 'xsim_run.bat'/'xsim_run.sh' file has commands to compile and
         simulate memory interface design and run the simulation for specified
         period of time.

      d) xsim_options.tcl file has commands to add waveforms and simulation
         period.

      e) xsim_files.prj file has list of rtl files for simulating the design.

      f) $XILINX_VIVADO environment variable must be set in order to compile
         glbl.v file

   B) Steps to run the Vivado Simulator simulation:

      a) Change the present working directory path to the sim folder of "Open
         IP Example Design" path in the OS terminal.

      b) Run the simulation using xsim_run.sh file under Linux environment and
         xsim_run.bat under MicroSoft Windows environment.

      c) Verify the transcript file for the memory transactions.

3. How to run Cadence IES Simulations

   A) ies_run.sh File :

      a) The "ies_run.sh" file contains the commands for simulation of the
         hdl files.

      b) Libraries must be mapped before running simulations. Following
         procedure must be followed to before running simulations

        1. Create two files named cds.lib and hdl.var in this directory
        2. Create a directory 'worklib' in same directory.
            mkdir worklib
        3. Add following lines in the cds.lib file to map Xilinx libraries

            DEFINE unisim /proj/xbuilds/2014.4_daily_latest/clibs/ius/13.20.005/lin64/lib/./unisim
            DEFINE unisims_ver  /proj/xbuilds/2014.4_daily_latest/clibs/ius/13.20.005/lin64/lib/./unisims_ver
            DEFINE secureip  /proj/xbuilds/2014.4_daily_latest/clibs/ius/13.20.005/lin64/lib/./secureip
            DEFINE worklib ./worklib

        4. ATTENTION: In above lines replace the path for libraries as per your
            compiled Xilinx libraries directory
        5. ATTENTION: Add the lines in the same order given above
        6. Please make sure you need to map all Xilinx libraries mentioned above
        7. Save and close the cds.lib file

        Also, $XILINX_VIVADO environment variable must be set in order to
        compile glbl.v file and the above mentioned library files

   B) Steps to run the IES simulation:

      a) Change the present working directory path to the sim folder of "Open
         IP Example Design" path in the OS terminal.

      b) Run the simulation using ies_run.sh file. Type the following command:
         ./ies_run.sh

      c) Verify the ies_sim.log file for the memory transactions.

4. How to run Synopsys VCS Simulations

   A) vcs_run.sh File :

      a) The "vcs_run.sh" file contains the commands for simulation of hdl files.

      b) Libraries must be mapped before running simulations. Following
         procedure must be followed to before running simulations

        1. Create a file named synopsys_sim.setup in this directory
        2. Add following lines in the synopsys_sim.setup file to map Xilinx
           libraries

            unisim : /proj/xbuilds/2014.4_daily_latest/clibs/vcs/I-2014.03/lin64/lib/unisim
            secureip     : /proj/xbuilds/2014.4_daily_latest/clibs/vcs/I-2014.03/lin64/lib/secureip
            unisims_ver  : /proj/xbuilds/2014.4_daily_latest/clibs/vcs/I-2014.03/lin64/lib/unisims_ver

        3. ATTENTION: In above lines replace the path for libraries as per your
            Compiled Xilinx libraries directory
        4. Please make sure you need to map all Xilinx libraries mentioned above

        Also, $XILINX_VIVADO environment variable must be set in order to
        compile glbl.v file and the above mentioned library files

   B) Steps to run the VCS simulation:

      a) Change the present working directory path to the sim folder of "Open
         IP Example Design" path in the OS terminal.

      b) Run the simulation using vcs_run.sh file. Type the following command:
         ./vcs_run.sh

      c) Verify the vcs_sim.log file for the memory transactions.

5. SIM_BYPASS_INIT_CAL parameter value of SKIP, skips memory initialization sequence
   and calibration sequence. This could lead to simulation errors since design is not
   calibrated at all. Preferred values for parameter SIM_BYPASS_INIT_CAL to run
   simulations are FAST and OFF.

6. Simulations running with parameter MAX_MEM defined uses a temporary directory for model data.
   The default temporary directory specified in model file is /tmp which doesn't exist for Windows OS.
   Therfore users running on Windows OS should change the ddr3_model.v file as below

      tmp_model_dir = "/tmp";
            to
      tmp_model_dir = ".";

   This change works for All OS.


