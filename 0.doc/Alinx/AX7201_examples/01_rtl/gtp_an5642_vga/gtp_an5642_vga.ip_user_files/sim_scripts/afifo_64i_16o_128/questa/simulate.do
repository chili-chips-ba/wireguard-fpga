onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib afifo_64i_16o_128_opt

do {wave.do}

view wave
view structure
view signals

do {afifo_64i_16o_128.udo}

run -all

quit -force
