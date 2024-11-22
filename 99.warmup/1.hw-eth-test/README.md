This example is about achieving data communication between FPGA and PC, using 1Gbps Ethernet UDP communication protocol.

The FPGA talks to the Realtek RT8211EG PHY chip over RGMII interface. The PHY in turns sends data to the PC via RJ45 connector and Unshielded Twisted Pair (UTP) cable.

The example implements ARP, UDP and PING functions, as well as 100/1000Mbps self-adaptation.