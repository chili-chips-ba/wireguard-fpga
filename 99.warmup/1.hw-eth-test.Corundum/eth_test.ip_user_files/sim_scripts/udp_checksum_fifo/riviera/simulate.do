onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+udp_checksum_fifo -L xil_defaultlib -L xpm -L fifo_generator_v13_2_4 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.udp_checksum_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {udp_checksum_fifo.udo}

run -all

endsim

quit -force
