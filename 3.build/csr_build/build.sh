rm -rf generated-files/html/
peakrdl regblock csr.rdl -o generated-files/ --cpuif passthrough --top csr
peakrdl html csr.rdl -o generated-files/html/ --top wireguard
peakrdl markdown csr.rdl -o generated-files/wireguard.md --top wireguard
