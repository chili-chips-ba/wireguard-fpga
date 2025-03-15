mkdir output
mkdir output/sw
peakrdl regblock wireguard.rdl -o output/hw/ --cpuif passthrough --top csr
peakrdl c-header wireguard.rdl -o output/sw/wireguard.h --top csr --bitfields ltoh --type-style hier --testcase
peakrdl html wireguard.rdl -o output/html/ --top wireguard
peakrdl markdown wireguard.rdl -o output/html/wireguard.md --top wireguard
