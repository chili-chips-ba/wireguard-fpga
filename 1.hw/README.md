## Hardware Architecture and Theory of Operation
![HWArchitecture](./0.doc/Wireguard/wireguard-fpga-muxed-Architecture-HW.webp)

The hardware architecture essentially follows the HW/SW partitioning and consists of two domains: a soft CPU for the control plane and RTL for the data plane.

The soft CPU is equipped with a Boot ROM and a DDR3 SDRAM controller for interfacing with off-chip memory. External memory is exclusively used for control plane processes and does not store packets. The connection between the control and data planes is established through a CSR-based HAL.

The data plane consists of several IP cores, including data plane engine (DPE) and supporting components, which are listed and explained in the direction of network traffic propagation:
- _PHY Controller_ - initial configuration of Realtek PHYs and monitoring link activity (link up/down events)
- _1G MAC_ - execution of the 1G Ethernet protocol (framing, flow control, FCS, etc.)
- _Rx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling
- _Per-Packet Round Robin Multiplexer_ - servicing Rx FIFOs on a per-packet basis using a round-robin algorithm
- _Header Parser_ - extraction of Wireguard-related information from packet headers (IP addresses, UDP ports, Wireguard message type, peer ID, etc.)
- _Wireguard/UDP Packet Disassembler_ - decapsulation of the payload from the Wireguard data packet for decryption of tunneled traffic
- _ChaCha20-Poly1305 Decryptor_ - decryption and authentication of tunneled traffic
- _IP Lookup Engine_ - routing/forwarding table lookup, mapping packets to the appropriate Wireguard peer, and making packet accept/reject decisions
- _ChaCha20-Poly1305 Encryptor_ - encryption and authentication of traffic to be tunneled
- _Wireguard/UDP Packet Assembler_ - encapsulation of the encrypted packet into a Wireguard data packet for tunneling to the remote peer
- _Per-Packet Demultiplexer_ - forwarding packets to Tx FIFOs based on packet type and destination
- _Tx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling

_ChaCha20-Poly1305 Encryptor/Decryptor_ are using [RFC7539's](https://datatracker.ietf.org/doc/html/rfc7539) AEAD (Authenticated Encryption Authenticated Data) construction based on [ChaCha20](http://cr.yp.to/chacha.html) for symmetric encryption and [Poly1305](http://cr.yp.to/mac.html) for authentication.

## Hardware Data Flow
The hardware architecture features three clock signal domains:
- 125 MHz domain with an 8-bit bus for interfacing data plane with 1G MAC cores (marked in blue)
- 80 MHz domain with a 32-bit bus for interfacing data plane with the CPU (marked in red)
- 80 MHz domain with a 128-bit bus for the packet transfer through the data plane pipeline (marked in green)

The blue domain is defined based on the SDR GMII interface, which operates at 125 MHz and connects the Realtek PHY controller with the MAC cores on the FPGA.

The red domain encompasses the entire CSR with all peripherals. The clock signal frequency and bus width are defined based on the assumption that Wireguard peers exchange handshake messages sporadically—during connection initialization and periodically, typically every few minutes, for key rotation. Since handshake signaling does not significantly impact network traffic, we decided to implement the connection between the data and control planes without DMA, utilizing direct CPU interaction with Tx/Rx FIFOs through a CSR interface.

Although the Data Plane Engine (green domain) transfers packets at approximately 10 Gbps, the cores in the DPE pipeline are not expected to process packets at such a rate. Given that we have 4 x 1Gbps Ethernet interfaces, the cryptographic cores must process packets at a rate of at least 4 Gbps to ensure the system works at wire speed. For some components, such as the _IP Lookup Engine_, packet rate is more critical than data rate because their processing focuses on the packet headers rather than the payload. Assuming that, in the worst-case scenario, the smallest packets (64 bytes) arrive via the 1 Gbps Ethernet interface, the packet rate for each Ethernet interface would be 1,488,096 packets per second (pps). Therefore, in the worst-case scenario, such components must process packets at approximately 6 Mpps rate (e.g. 6 million IP table lookups per second).

### HW Flow Chart, Throughputs and Pushbacks
![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-Interfaces.webp)

The cores within the DPE transmit packets via the AXI4-Stream interface with standard signals (TREADY, TVALID, TDATA, TKEEP, TLAST, TUSER, and TID). Although data transfer on the TDATA bus is organized as little-endian, it is important to note that the internal organization of fields within the headers of Ethernet, IP, and UDP protocols follows big-endian format (also known as network byte order). On the other hand, the fields within the headers of the Wireguard protocol are transmitted in little-endian format. In this setup, TUSER is used to carry instructions for internal packet routing:
- TUSER\[7:7\] = bypass_all – Instructs that the packet should not be routed through the DPE but sent directly to the ETH interface or the CPU (and vice versa).
- TUSER\[6:6\] = bypass_stage – Instructs the packet to skip the next stage within the DPE (used internally within the DPE).
- TUSER\[5:3\] = src – Internal source address of the packet (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4).
- TUSER\[2:0\] = dst – Internal destination address of the packet (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4, 7 - broadcast).

TID\[7:0\] will be used internally within the DPE to carry the peer index (a result of the peer table lookup).

![ExampleToplogy](../0.doc/Wireguard/hw_st_if_packet_data.png)

## HW/SW Working Together as a Coherent System
The example is based on a capture of real Wireguard traffic, recorded and decoded using the Wireshark tool ([encrypted](https://gitlab.com/wireshark/wireshark/-/blob/master/test/captures/wireguard-ping-tcp.pcap) and [decrypted](https://gitlab.com/wireshark/wireshark/-/blob/master/test/captures/wireguard-ping-tcp-dsb.pcapng)). The experimental topology consists of four nodes:
- 10.10.0.2 - the end-user host at site A
- 10.9.0.1 - Wireguard peer A
- 10.9.0.2 - Wireguard peer B
- 10.10.0.1 - the end-user host at site B

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-Example-Topology.webp)

To illustrate the operation of the system as a whole, we will follow the step-by-step passage of packets through the system in several phases:
- Sending a Handshake Initiation from peer A
- Receiving the Handshake Initiation on peer B and sending a Handshake Response back to peer A
- Receiving the Handshake Response on peer A
- Encryption and tunneling of the ICMP Echo Request packet (from host A to host B via peer A)
- Detunneling and decryption of the ICMP Echo Request packet (from host A to host B via peer B)

![Example1](../0.doc/Wireguard/wireguard-fpga-muxed-Example-1-A-Handshake-Initiation.webp)

1. The Wireguard Agent on peer A initiates the establishment of the VPN tunnel by generating the contents of the _Handshake Initiation_ packet.
2. The CPU transfers the _Handshake Initiation_ packet from RAM to the Rx FIFO via the CSR interface towards the data plane.
3. Once the entire packet is stored in the Rx FIFO, the Round Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
4. In the first three cycles of the packet transfer, the Header Parser extracts important information from the packet header (including the destination IP address and type of Wireguard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Initiation_), the Wireguard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
5. The IP Lookup Engine searches the routing table based on the destination IP address and determines the outgoing Ethernet interface, supplementing this information to the packet before forwarding it. Similar to the previous step, the Wireguard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
6. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (to _if1_).
7. Once the entire packet is stored in the Tx FIFO, it is dispatched to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
8. The 1G MAC writes its MAC address as the source address, calculates the FCS on the fly, adds it to the end of the Ethernet frame, and sends it to peer B.

![Example23](../0.doc/Wireguard/wireguard-fpga-muxed-Example-2-3-B-Handshake-Initiation-Response.webp)

9. On peer B, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
10. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
11. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
12. The Header Parser extracts important information from the packet header (including the destination IP address and type of Wireguard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Initiation_), the Wireguard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
13. The IP Lookup Engine searches the routing table based on the destination IP address and determines that the control plane is the destination, supplementing this information to the packet before forwarding it. Similar to the previous step, the Wireguard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
14. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward the CPU).
15. Once the entire packet is stored in the Tx FIFO, the CPU transfers the packet from the FIFO to RAM via the CSR-based interface and hands it over to the Wireguard Agent for further processing.
16. The Wireguard Agent processes the _Handshake Initiation_ request and generates the _Handshake Response_.
17. The Routing DB Updater updates the routing table per the Wireguard Agent's instructions (adding the peer's IP address and Wireguard-related data).
18. The CPU updates the registers from which the data plane reads the routing table and the corresponding cryptographic keys via the CSR interface.
19. The CPU transfers the _Handshake Response_ packet from RAM to the Rx FIFO (to the data plane) via the CSR interface.
20. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
21. The Header Parser extracts important information from the packet header (including the destination IP address and type of Wireguard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Response_), the Wireguard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
22. The IP Lookup Engine searches the routing table based on the destination IP address and determines the outgoing Ethernet interface, supplementing this information to the packet before forwarding it. Similar to the previous step, the Wireguard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
23. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if1_).
24. Once the entire packet is stored in the Tx FIFO, it is dispatched to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
25. The 1G MAC writes its MAC address as the source address, calculates the FCS on the fly, adds it to the end of the Ethernet frame, and sends it to peer A.

![Example4](../0.doc/Wireguard/wireguard-fpga-muxed-Example-4-A-Handshake-Response.webp)

26. On peer A, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
27. Once the entire packet is stored, the Rx FIFO signals the Roung-Robin Multiplexer.
28. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
29. The Header Parser extracts important information from the packet header (including the destination IP address and type of Wireguard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Response_), the Wireguard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
30. The IP Lookup Engine searches the routing table based on the destination IP address and determines that the control plane is the destination, supplementing this information to the packet before forwarding it. Similar to the previous step, the Wireguard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
31. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward the CPU).
32. Once the entire packet is stored in the Tx FIFO, the CPU transfers the packet from the FIFO to RAM via the CSR-based interface and hands it over to the Wireguard Agent for further processing.
33. The Wireguard Agent processes the _Handshake Response_.
34. The Routing DB Updater updates the routing table per the Wireguard Agent's instructions (adding the peer's IP address and Wireguard-related data).
35. The CPU updates the registers from which the data plane reads the routing table and the corresponding cryptographic keys. The session is now officially established, and the exchange of user data over the encrypted VPN tunnel can commence.

![Example5](../0.doc/Wireguard/wireguard-fpga-muxed-Example-5-A-Transfer-Data.webp)

36. On peer A, an end-user packet (_ICMP Echo Request_) arrives via the _if2_ Ethernet interface. The 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if2_).
37. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
38. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
39. The Header Parser extracts important information from the packet header (including the destination IP address and protocol type) and supplements the extracted metadata to the packet before passing it along. Now, knowing the protocol type (ICMP), the Wireguard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
40. The IP Lookup Engine searches the routing table based on the destination IP address and determines the target Wireguard peer and the outgoing Ethernet interface, supplementing this information to the packet before forwarding it.
41. Based on the information about the target peer and the corresponding key, the ChaCha20-Poly1305 Encryptor encrypts the packet and adds an authentication tag.
42. The Wireguard/UDP Packet Assembler adds Wireguard, UDP, IP, and Ethernet headers filled with the appropriate data to the encrypted packet and forwards it.
43. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if1_).
44. Once the entire packet is stored in the Tx FIFO, it is sent to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
45. The 1G MAC writes its MAC address as the source, calculates the FCS on the fly, which it ultimately appends to the end of the Ethernet frame, and then sends it to peer B.

![Example6](../0.doc/Wireguard/wireguard-fpga-muxed-Example-6-B-Transfer-Data.webp)

46. On peer B, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
47. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
48. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
49. The Header Parser extracts important information from the packet header (including source/destination IP addresses and the type of Wireguard message) and supplements the extracted metadata to the packet before passing it along.
50. Based on the destination IP address, the Wireguard/UDP Packet Disassembler knows that the packet is intended for this peer, extracting the encrypted payload and forwarding it for further processing.
51. The ChaCha20-Poly1305 Decryptor decrypts the packet and, after verifying the authentication tag, forwards it further.
52. The IP Lookup Engine now receives the decrypted plaintext user packet (_ICMP Echo Request_). After searching the cryptokey routing table based on the source IP address of the decrypted plaintext packet, a decision is made to accept or reject the packet. If the packet correspondingly routes, it is forwarded.
53. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if2_).
54. Once the entire packet is stored in the Tx FIFO, it is sent to the MAC core of the outgoing interface _if2_, provided that the corresponding 1 Gbps link is active and ready.
55. The 1G MAC writes its MAC address as the source, calculates the FCS on the fly, which it ultimately appends to the end of the Ethernet frame, and then sends it to the end-user host of peer B.
