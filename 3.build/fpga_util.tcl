#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A collection of utilities for FPGA
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#------------------------------------------------------------
# import all env variables into Tcl
#------------------------------------------------------------
foreach e [array names ::env] {
   if {$e != "env"} {set "$e" $::env($e)}
}

#------------------------------------------------------------
# return FPGA PART and FAMILY for target HW_PLATFORM
#------------------------------------------------------------
#  HW_PLATFORM envar is constructed from the following elements:
#    - optional DESCription
#    - MOBO              name
#    - PERIF-or-TestName name
#    - FPGA Reference Designator
#  each separated by underscore, except that optional DESCription is separated by hyphen. 
#
#  E.g
#      NN397_NN375_U21 –> test of NN375 Peripheral Card (USB2/3 PHY), mounted to NN397 Carrier, connected to U21 FPGA
#  or: usb2-NN397_NN375_U21
#
#      emac-NN397_PE273_U11
#
#      NN397_PE270_U41
#      NN392_PE270_U11
#      NN397_ddr_U21   -> test of soldered-down DDR4 memory on NN397 Carrier Card (there is no Peripheral Card for it)  
#      NN397_clk_U21   -> test of on-board Clocks 
#------------------------------------------------------------

set FPGA_PART    UNSUPPORTED
set FPGA_FAMILY  UNSUPPORTED

proc decode_fpga {} {

   # optional DESC field (which is separated by hyphen)
   set KEY [split  $::HW_PLATFORM "-"]
    
   if {[llength $KEY] == 1} {
      set DESC ""
   } else {
      set DESC [lindex $KEY 0]
      set KEY  [lindex $KEY 1]
   }
    
   # remaining fields are separated by underscore
   set KEY    [split  $KEY "_"]
   set MOBO   [lindex $KEY 0]
   set PERIF  [lindex $KEY 1]
   set REFDES [lindex $KEY 2]
    
   switch $MOBO {

       "ZC706" {
          # Xilinx Zynq7000 Eval Board
          set ::FPGA_FAMILY  zynq-7000
          set ::FPGA_PART    xc7z045ffg900-2
       }

       "VCU118" {
          # Xilinx Virtex Ultrascale+ Eval Board
          set ::FPGA_FAMILY  virtexuplus
          set ::FPGA_PART    xcvu9p-flga2104-2L-e-es1
       }

       "NN371" {
          # Rumi4 Zynq-Ultrascale+ MDC
          set ::FPGA_FAMILY  virtexuplus
          set ::FPGA_PART    xczu9cg-ffvb1156-2-e
       }

       "NN374" {
          # Rumi4.5 Zynq-Ultrascale+ MDC (Rev.2 of NN371)
          set ::FPGA_FAMILY  virtexuplus
          set ::FPGA_PART    xczu19eg-ffvd1760-2L-e
       }

       "NN392"   {
          # Rumi4.0 Tile
          set ::FPGA_FAMILY  virtex7
          set ::FPGA_PART    xc7v2000t-flg1925-1
       }

       "NN397" {
          # Rumi4.5 Tile
          set ::FPGA_FAMILY  virtexu
          set ::FPGA_PART    xcvu440-flga2892-1-c
       }

       "NN399" {
          # Rumi5.0 Tile
          set ::FPGA_FAMILY  virtexu
          set ::FPGA_PART    xcvu440-flga2892-2-e
       }
   }

   puts "\nQRDF MSG: HW_PLATFORM is '$::HW_PLATFORM' ($::FPGA_FAMILY $::FPGA_PART)\n"
}


#------------------------------------------------------------
# Read and parse filelist into Tcl list
#------------------------------------------------------------
set      incdir     ""
set      define     ""
set      src_files  ""
set      top_module ""


proc parse_filelist {FILELIST {TOOL "VIVADO"}} {
   set    rtl $::rtl

   set    incdirOpt ""
   set    defineOpt ""
    
   set    file_ptr [open ${FILELIST} r]
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
             append incdirOpt " -include_dirs $t "
             puts "Adding incdir: $t"
         }
    
         {^[ \t]*\+define\+} {
             # extract '+define+' line(s) and convert them to $define
             set t [string map {"+define+" ""} $ff]
             append ::define  " $t "
             append defineOpt " -verilog_define $t "
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
             # for Vivado only, extract '+top_module+' and move it into a Tcl variable
             if {$TOOL == "VIVADO"} {
                 set t [string map {"+top_module+" ""} $ff]
                 set ::top_module " $t "
                 puts "Setting TOP_MODULE: $t"
                 set_property top $t [current_fileset]
             }
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
             parse_line $ff $TOOL
         }
   
         default {parse_line $ff $TOOL}

     } ;#switch -regexp -- $ff
   } ;#for
}


#------------------------------------------------------------
proc parse_line {LINE {TOOL "VIVADO"}} {

   # any other line is considered a source file
   puts "Adding source: $LINE"
   append ::src_files " $LINE "
   
   # library can be optionally specified with semicolon
   set library [lindex [split $LINE ":"] 1]
   set LINE    [lindex [split $LINE ":"] 0]
   if {$library == ""} {set library "work"}

   #puts "TOOL=$TOOL LINE=$LINE library=$library\n"; #debug printout

   #________________________________
   if {$TOOL == "VIVADO"} {
      switch [file extension $LINE] {
          ".vhd" {
              if {[catch {read_vhdl -library $library $LINE} errmsg]} {
                 puts "FAILED in 'read_vhdl' step: $errmsg"
                 exit 1
          }}
       
          ".v" - ".sv" {
              if {[catch {read_verilog -sv -library $library $LINE} errmsg]} {
                 puts "FAILED in 'read_verilog' step: $errmsg"
                 exit 2
          }}     
       
          ".xdc" {
              if {[catch {read_xdc $LINE} errmsg]} {
                 puts "FAILED in 'read_xdc' step: $errmsg"
                 exit 3
          }}
       
          ".xdctcl" {
              if {[catch {read_xdc -unmanaged $LINE} errmsg]} {
                 puts "FAILED in 'read_xdc -unmanaged' step: $errmsg"
                 exit 4
          }}
       
          ".tcl" {
              if {[string match {*_mcu.tcl} $LINE] == 1} {
                 # project-specific MicroBlaze Board Design
                 if {[catch {source $LINE} errmsg]} {
                    puts "FAILED in 'source $LINE' step: $errmsg"
                    exit 5
                 }
                 make_wrapper -files [get_files ${::HW_PLATFORM}.srcs/sources_1/bd/mcu/mcu.bd] -top -import

             # any other Tcl, such as for special instructions to Vivado
             } elseif {[catch {add_files -norecurse $LINE} errmsg]} {
                 puts "FAILED in 'add_files -norecurse' step: $errmsg"
                 exit 6
             }
          }

          default {
          # this is for .xci, .dcp, .edif or other special Vivado file
              if {[catch {add_files -norecurse $LINE} errmsg]} {
                 puts "FAILED in 'add_files -norecurse' step: $errmsg"
                 exit 7
              }
              set_property library $library [get_files $LINE]
          }
      }
   } ; #if {$TOOL == "VIVADO"}

   #________________________________
   if {$TOOL == "QUESTASIM"} {
      switch [file extension $LINE] {
          ".vhd" {vcom -2008 -work $library $LINE}
       
          ".v" - ".sv" {
             vlog -sv -incr +nowarnSVCHK +acc=mnprt -time -mfcu -lint -work $library $LINE
          }     
      }
   } ;# if {$TOOL == "QUESTASIM"}

   #puts "'parse_line' DONE\n"; #debug printout
}


#~~~~{End-of-File}~~~~
