#=======================================
# Timing Constraints file
#=======================================

# 37ns = 27MHz, which is the frequency of external XTAL oscillator
create_clock -name clk_27 -period 37.037 -waveform {0 18.518} [get_ports {clk_27}]

#___End-of-File