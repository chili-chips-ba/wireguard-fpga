onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib gtp_opt

do {wave.do}

view wave
view structure
view signals

do {gtp.udo}

run -all

quit -force
