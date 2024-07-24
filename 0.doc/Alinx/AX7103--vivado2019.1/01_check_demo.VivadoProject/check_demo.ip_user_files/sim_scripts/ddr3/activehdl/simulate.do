onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+ddr3 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ddr3 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ddr3.udo}

run -all

endsim

quit -force
