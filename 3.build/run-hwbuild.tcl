#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#
# Tcl script for Gowin synth and par in batch mode.
# For more, see SUG100-3.9E_Gowin Software User Guide.pdf (Section 8)
#=============================================================

set HW_SRC  ../../1.hw
set BLD_DIR ./..


#-------------------------------------------------------------
# Read and parse filelist into Tcl list
#-------------------------------------------------------------
set incdir     ""
set define     ""
set src_files  ""
set top_module ""

proc parse_filelist {} {
   set    HW_SRC    $::HW_SRC
   set    BLD_DIR   $::BLD_DIR

   set    file_ptr [open $HW_SRC/top.filelist r]
   set    file_buf [read $file_ptr]
   close $file_ptr
    
   set file_lines [split $file_buf "\n"]
    
   #___loop through all lines (which may dynamically grow due to -f expansion)
   for {set i 0} {$i < [llength $file_lines]} {incr i} {  
       set f [lindex $file_lines $i]
       #puts "i=$i f=$f length=[llength $file_lines]"; #debug printout
       
       # process only lines that aren't empty and don't start with comment
       if {([string trim $f] == "") || ([regexp {^[ \t]*#} $f] != 0)} {continue}
           
       # for the rest, first substitute env vars that might be part of filename
       set ff [subst -nocommands $f]
    
       # ...then dispatch to proper bucket
       switch -regexp -- $ff {
    
         {^[ \t]*\+incdir\+} {
             # extract '+incdir+' line(s) and convert them to $incdir
             set t [string map {"+incdir+" ""} $ff]
             append ::incdir  " $t "
             puts "Adding incdir: $t"
         }
    
         {^[ \t]*\+define\+} {
             # extract '+define+' line(s) and convert them to $define
             set t [string map {"+define+" ""} $ff]
             append ::define  " $t "
             puts "Adding define: $t"
         }
    
         {^[ \t]*\-f} {
             # extract filename behind '-f' option
             set t [string map {"-f" ""} $ff]
             set t [string trim $t]
             puts "Adding -f list: $t"
    
             # read-in that file
             set file_ptr  [open $t r]
             set file_buf  [read $file_ptr]
             close $file_ptr
              
             # replace '-f' line with contents of that file
             set t  [split $file_buf "\n"]
             set t1 [lreplace $file_lines $i $i]
    
             for {set j 0} {$j < [llength $t]} {incr j} { 
                set t1 [linsert $t1 [expr $i+1+$j] [lindex $t $j]]
             }
    
             set file_lines $t1
         } 
    
         {^[ \t]*\+top_module\+} {
             # extract '+top_module+' and move it into a Tcl variable
             set t [string map {"+top_module+" ""} $ff]
             set ::top_module " $t "
             puts "Setting TOP_MODULE: $t"
             set_option -top_module $t
         }
    
         {^[ \t]*\+} {
             # ...but, ignore all other '+' options (such as sim +plusarg)
             puts "Ignoring line: $ff"
         } 
    
         {^[ \t]*\-v} {
             # if '-v' option is present, extract the filename behind it
             set t [string map {"-v" ""} $ff]
             set t [string trim $t]
             set ff $t
             puts "Ignoring -v prefix of: $ff"
             parse_line $ff
         }
   
         default {parse_line $ff}

     } ;#switch -regexp -- $ff
   } ;#for
}

#------------------------------------------------------------
proc parse_line {LINE} {

   # any other line is considered a source file
   #puts "Adding source: $LINE"
   append ::src_files " $LINE "
   
   # library can be optionally specified with semicolon
   set LINE    [lindex [split $LINE ":"] 0]
   set library [lindex [split $LINE ":"] 1]
   if {$library == ""} {set library "work"}

   #puts "LINE=$LINE library=$library\n"; #debug printout
   #set_file_prop -lib $library $LINE

   #________________________________
   switch [file extension $LINE] {
       ".v" - ".sv" - ".vhd" {
           if {[catch {add_file $LINE} errmsg]} {
              puts "FAILED in 'add_file' step: $errmsg"
              exit 1
           }
       }     
    
       default {
              puts "Unknown file type"
              exit 2
       }
   }
}


#-------------------------------------------------------------
# Start of main program
#-------------------------------------------------------------
create_project \
    -name hw_build.TCL \
    -pn   GW2AR-LV18QN88C8/I7 \
    -device_version C \
    -force

#set_device -device_version C  GW2AR-LV18QN88C8/I7

#---
add_file ${HW_SRC}/constraints/top.pinout.cst
add_file ${HW_SRC}/constraints/top.timing.sdc

#---
#import_files -fileList ${HW_SRC}/top.filelist
parse_filelist

#---Project-level options
set_option -output_base_name            eduSOC 
#set_option -synthesis_tool              Gowin
set_option -top_module                  top
set_option -include_path                $incdir
#set_option -inc                         <incremental.cfg >
#set_option -define                     $define
#FIXME: Gowin does not seem to have this option yet

#---Global Configuration
#set_option -global_freq                  <default|value>
#Specify the frequency value, default is "default"
# (50MHz for LittleBee family, 100MHz for Arora family)

#---Synthesis Configuration                                                   
set_option -verilog_std                 sysv2017
set_option -vhdl_std                    vhd2008
set_option -print_all_synthesis_warning 0
set_option -disable_io_insertion        0
set_option -looplimit                   2000
set_option -maxfan                      10000
set_option -rw_check_on_ram             1
# If there is an RAM read or write conflict, enable
# this option to insert bypass logic around RAM to
# prevent simulation mismatch. Default is 0 (Disabled)

#---Place & Route Configuration
set_option -vccx                        3.3
set_option -gen_sdf                     0
set_option -gen_io_cst                  0
set_option -gen_ibis                    0
set_option -gen_posp                    0
set_option -gen_text_timing_rpt         0
set_option -gen_verilog_sim_netlist     0
set_option -gen_vhdl_sim_netlist        0
set_option -show_init_in_vo             0
set_option -show_all_warn               0
set_option -timing_driven               1
set_option -cst_warn_to_error           1
set_option -rpt_auto_place_io_info      1
set_option -place_option                0  ;#0, 1, 2
set_option -route_option                0  ;#0, 1, 2
set_option -ireg_in_iob                 1
set_option -oreg_in_iob                 1
set_option -ioreg_in_iob                1 
set_option -replicate_resources         0
set_option -clock_route_order           0
set_option -route_maxfan                23 ;#1 to 100
set_option -correct_hold_violation      1

#---Dual-purpose Pins Configuration
set_option -use_jtag_as_gpio       0
set_option -use_sspi_as_gpio       1 ;# NOTE: 0 is default
set_option -use_mspi_as_gpio       0
set_option -use_ready_as_gpio      0
set_option -use_done_as_gpio       0
set_option -use_reconfign_as_gpio  0
set_option -use_i2c_as_gpio        0

#---BitStream Configuration
set_option -bit_format             bin ;#txt
set_option -bit_crc_check          1
set_option -bit_compress           1
set_option -bit_encrypt            0
set_option -bit_encrypt_key        00000000000000000000000000000000
set_option -bit_security           1
set_option -bit_incl_bsram_init    1
set_option -bg_programming         off
# off | jtag | i2c | goconfig | userlogic | i2c_jtag_sspi_qsspi | jtag_sspi_qsspi
# Background programming, programming Flash without interrupting the
# current FPGA running
# -Off                : Background programming off (Default)
# -Jtag               : Using JTAG mode for background programming
# -I2C                : Using I2C mode for background programming
# -Goconfig           : Using goConfig IP for background programming
# -userlogic          : Using I2C internal logic for background programming
# -i2c_jtag_sspi_qsspi: Using I2C/JTAG/SSPI/QSSPI for background programming
# -jtag_sspi_qsspi    : Using JTAG/SSPI/QSSPI for background programming

set_option -hotboot                0
set_option -i2c_slave_addr         00 ;#(Hex): 00~7F
set_option -secure_mode            0
#Enable secure mode. Use JTAG pin as GPIO, and device can be programmed only once

set_option -seu_handler                0
set_option -seu_handler_mode           auto  ;#auto, userlogic
set_option -seu_handler_checksum       0
set_option -error_detection            0
set_option -error_detection_correction 0
set_option -stop_seu_handler           0
# 1 to stop SEU Handler when an uncorrectable ECC error or CRC
# checksum mismatch error is detected, and the default is 0.

#set_option -osc_div                    8
set_option -error_injection            0
set_option -ext_cclk                   0
# Enable external master configuration clock

set_option -multi_boot                  0
set_option -multiboot_address_width     24 ;#32
set_option -multiboot_spi_flash_address 000000 ;# Hex
#Specify SPI Flash address; the SPI Flash address refers to the initial
#address to which the bitstream will be loaded for the next multiboot

set_option -multiboot_mode              normal ;#normal, fast, dual, quad
set_option -mspi_jump                   0
set_option -merge_jumpbit               0
set_option -mspijump_address_width      24 ;#32
set_option -mspijump_spi_flash_address  000000 ;# Hex
set_option -mspijump_mode               normal ;# normal, fast, dual, quad

set_option -program_done_bypass         0
# with 1, when the Done Final internal signal takes effect,
# the external Done Pin remains low so that new bitstream
# can be forwarded after the bitstream is loaded

set_option -power_on_reset_monitor      1
set_option -turn_off_bg                 0 ;#Bandgap
set_option -wakeup_mode                 0
set_option -user_code                   F00DD00D

#---Unused Pin Configuration
set_option -unused_pin                  default ;# default, open_drain

#---
run all

#=============================================================
# End-of-File
#=============================================================
