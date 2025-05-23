## Hardware Architecture and Theory of Operation
![HWArchitecture](../0.doc/Wireguard/wireguard-fpga-muxed-Architecture-HW.webp)

The hardware architecture essentially follows the HW/SW partitioning and consists of two domains: a soft CPU for the control plane and RTL for the data plane.

The soft CPU is equipped with a Boot ROM and a DDR3 SDRAM controller for interfacing with off-chip memory. External memory is exclusively used for control plane processes and does not store packets. The connection between the control and data planes is established through a CSR-based HAL.

The data plane consists of several IP cores, including data plane engine (DPE) and supporting components, which are listed and explained in the direction of network traffic propagation:
- _PHY Controller_ - initial configuration of Realtek PHYs and monitoring link activity (link up/down events)
- _1G MAC_ - execution of the 1G Ethernet protocol (framing, flow control, FCS, etc.)
- _Rx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling
- _Per-Packet Round Robin Multiplexer_ - servicing Rx FIFOs on a per-packet basis using a round-robin algorithm
- _Header Parser_ - extraction of WireGuard-related information from packet headers (IP addresses, UDP ports, WireGuard message type, peer ID, etc.)
- _Wireguard/UDP Packet Disassembler_ - decapsulation of the payload from the WireGuard data packet for decryption of tunneled traffic
- _ChaCha20-Poly1305 Decryptor_ - decryption and authentication of tunneled traffic
- _IP Lookup Engine_ - routing/forwarding table lookup, mapping packets to the appropriate WireGuard peer, and making packet accept/reject decisions
- _ChaCha20-Poly1305 Encryptor_ - encryption and authentication of traffic to be tunneled
- _Wireguard/UDP Packet Assembler_ - encapsulation of the encrypted packet into a WireGuard data packet for tunneling to the remote peer
- _Per-Packet Demultiplexer_ - forwarding packets to Tx FIFOs based on packet type and destination
- _Tx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling

_ChaCha20-Poly1305 Encryptor/Decryptor_ are using [RFC7539's](https://datatracker.ietf.org/doc/html/rfc7539) AEAD (Authenticated Encryption Authenticated Data) construction based on [ChaCha20](http://cr.yp.to/chacha.html) for symmetric encryption and [Poly1305](http://cr.yp.to/mac.html) for authentication.

## Hardware Data Flow
The hardware architecture features three clock signal domains:
- 125 MHz domain with an 8-bit bus for interfacing the DPE with 1G MAC cores (marked in blue)
- 80 MHz domain with a 32-bit bus for interfacing the DPE with the CPU (marked in red)
- 80 MHz domain with a 128-bit bus for the packet transfer through the DPE pipeline (marked in green)

The blue domain is defined based on the SDR GMII interface, which operates at 125 MHz and connects the Realtek PHY controller with the MAC cores on the FPGA.

The red domain encompasses the entire CSR with all peripherals. The clock signal frequency and bus width are defined based on the assumption that WireGuard peers exchange handshake messages sporadically—during connection initialization and periodically, typically every few minutes, for key rotation. Since handshake signaling does not significantly impact network traffic, we decided to implement the connection between the data and control planes without DMA, utilizing direct CPU interaction with Tx/Rx FIFOs through a CSR interface.

Although the DPE (green domain) transfers packets at approximately 10 Gbps, the cores in the DPE pipeline are not expected to process packets at such a rate. Given that we have 4 x 1Gbps Ethernet interfaces, the cryptographic cores must process packets at a rate of at least 4 Gbps to ensure the system works at wire speed. For some components, such as the _IP Lookup Engine_, packet rate is more critical than data rate because their processing focuses on the packet headers rather than the payload. Assuming that, in the worst-case scenario, the smallest packets (64 bytes) arrive via the 1 Gbps Ethernet interface, the packet rate for each Ethernet interface would be 1,488,096 packets per second (pps). Therefore, in the worst-case scenario, such components must process packets at approximately 6 Mpps rate (e.g. 6 million IP table lookups per second).

### DPE Data Flow
![DPEInterfaces](../0.doc/Wireguard/wireguard-fpga-muxed-Interfaces.webp)

The cores within the DPE transmit packets via the AXI4-Stream interface with standard signals (`TREADY`, `TVALID`, `TDATA`, `TKEEP`, `TLAST`, `TUSER`, and `TID`). Although data transfer on the `TDATA` bus is organized as little-endian, it is important to note that the internal organization of fields within the headers of Ethernet, IP, and UDP protocols follows big-endian format (also known as network byte order). On the other hand, the fields within the headers of the WireGuard protocol are transmitted in little-endian format. In this setup, `TUSER` is used to carry instructions for internal packet routing:
- `TUSER[7:7] = bypass_all` – Instructs that the packet should not be routed through the DPE but sent directly to the ETH interface or the CPU (and vice versa).
- `TUSER[6:6] = bypass_stage` – Instructs the packet to skip the next stage within the DPE (used internally within the DPE).
- `TUSER[5:3] = src` – Internal source address of the packet (0 - _CPU_, 1 - _eth1_, 2 - _eth2_, 3 - _eth3_, 4 - _eth4_).
- `TUSER[2:0] = dst` – Internal destination address of the packet (0 - _CPU_, 1 - _eth1_, 2 - _eth2_, 3 - _eth3_, 4 - _eth4_, 7 - _broadcast_).

`TID[7:0]` will be used internally within the DPE to carry the peer index (a result of the peer table lookup).

![DPEPacketTransfer](../0.doc/Wireguard/hw_st_if_packet_data.png)

### UART Data Flow
The UART interface is implemented with a dual purpose:
- Standard data exchange of printable characters between the PC host and the CPU within the FPGA SoC, supporting a CLI in the software
- A special mode for binary data exchange between the PC host and the FPGA SoC

The special mode enables four functionalities:
- Programming the IMEM, ie. modifying the entire content with CPU reset (`IMPR`)
- Modifying a single instruction in the IMEM without resetting the CPU (`IMWR`)
- Reading data from the DMEM/CSR bus (`BUSR`)
- Writing data to the DMEM/CSR bus (`BUSW`)

The following diagrams illustrate these functionalities. They are not cycle-accurate, but rather show the relative timing and relationships between the data sent by the PC host (`uart_rx_data`) and the data sent by the UART module (`uart_tx_data`). Additionally, several internal signals such as FSM states and bus signals are shown to clarify what is happening.

Entry into the special mode is triggered when the PC host sends the `C_SOP` character. Upon receiving `C_SOP`, the UART FSM transitions into a state where it waits for an instruction indicating which mode to switch to. Upon receiving `C_IMPR`, UART FSM assert CPU reset signal and the procedure for programming the IMEM begins (`IMPR`). At the beginning of the `IMPR` procedure, the UART FSM expects the lower and upper byte of the length of the binary/hex file that will be transferred over UART and programmed into the IMEM. After that, the file transfer begins word by word (4 bytes each), where the UART FSM sends an acknowledgment (`C_ACK`) after receiving each word. Once the last word has been transferred and acknowledged, an 8-bit checksum is sent, calculated over all bytes starting from the length field up to the last data word:

```
CHECKSUM = LEN[7:0] + LEN[15:8] + DATA_1[7:0] + DATA_1[15:8] + DATA_1[23:16] + DATA_1[31:24] + DATA_2[7:0] + ... + DATA_N[31:24]
```

After that, CPU reset is deasserted. This allows the application on the PC host to verify that the entire file has been transferred without errors and to conclude the communication by sending a `C_EOP`.

![UARTIMPROk](../0.doc/Wireguard/uart_impr_ok.png)

The UART FSM also implements a timeout mechanism to ensure correct system operation even in the event of a communication interruption between the PC host and the FPGA SoC during an active transaction. The following figure illustrates a timeout occurring during IMEM programming.

![UARTIMPRTimeout](../0.doc/Wireguard/uart_impr_timeout.png)

In addition to programming the entire IMEM, it is also possible to modify a single instruction within IMEM. This is achieved using the `C_IMWR` command. Upon receiving `C_IMWR`, the UART FSM expects a 2-byte address and a 4-byte data word to determine the location within IMEM where the existing instruction will be replaced. After that, the UART FSM responds with a checksum calculated over all received bytes, starting from the address up to the data to be written:

```
CHECKSUM = ADDR[7:0] + ADDR[15:8] + DATA[7:0] + DATA[15:8] + DATA[23:16] + DATA[31:24]
```

In this process, the CPU is not reset, which enables real-time modifications of the running program. This can be useful for inserting breakpoints for debugging purposes.

![UARTIMWR](../0.doc/Wireguard/uart_imwr.png)

When the special communication mode is initiated, the UART FSM activates the `bus.vld` signal, thereby taking control of the bus and effectively pausing the CPU operation. This allows observation or modification of entire memory blocks in DMEM/CSR without the risk of the CPU making changes during that period. Therefore, we can safely say that accesses to DMEM/CSR are atomic.

The C_BUSR command is used for reading from the bus, after which the UART FSM expects a 4-byte address from which it will read the data. This data can originate from either the DMEM or CSR address space. After reading the data from the bus, it is sent to the PC host byte by byte. The data is then followed by a checksum, which is calculated based over all received and transmitted bytes, starting from the address up to the read data:

```
CHECKSUM = ADDR[7:0] + ADDR[15:8] + ADDR[23:16] + ADDR[31:24] + DATA[7:0] + DATA[15:8] + DATA[23:16] + DATA[31:24]
```

![UARTBUSR](../0.doc/Wireguard/uart_busr.png)

The `C_BUSW` command is used for writing data to the bus. Upon receiving `C_BUSW`, the UART FSM expects a 4-byte address and a 4-byte data word to be written to the specified address. After that, it responds with a checksum calculated in the same way as in the `BUSR` procedure.

![UARTBUSW](../0.doc/Wireguard/uart_busw.png)

It is important to note that immediately upon entering the special mode, the UART FSM takes control of the bus and effectively halts the CPU for the duration of the special communication mode. This allows multiple read/write transactions on the bus, which can be useful for implementing software-in-the-loop (SIL) co-emulation techniques.

## HW/SW Working Together as a Coherent System
The example is based on a capture of real Wireguard traffic, recorded and decoded using the Wireshark tool ([encrypted](https://gitlab.com/wireshark/wireshark/-/blob/master/test/captures/wireguard-ping-tcp.pcap) and [decrypted](https://gitlab.com/wireshark/wireshark/-/blob/master/test/captures/wireguard-ping-tcp-dsb.pcapng)). The experimental topology consists of four nodes:
- 10.10.0.2 - the end-user host at site A
- 10.9.0.1 - WireGuard peer A
- 10.9.0.2 - WireGuard peer B
- 10.10.0.1 - the end-user host at site B

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-Example-Topology.webp)

To illustrate the operation of the system as a whole, we will follow the step-by-step passage of packets through the system in several phases:
- Sending a Handshake Initiation from peer A
- Receiving the Handshake Initiation on peer B and sending a Handshake Response back to peer A
- Receiving the Handshake Response on peer A
- Encryption and tunneling of the ICMP Echo Request packet (from host A to host B via peer A)
- Detunneling and decryption of the ICMP Echo Request packet (from host A to host B via peer B)

![Example1](../0.doc/Wireguard/wireguard-fpga-muxed-Example-1-A-Handshake-Initiation.webp)

1. The WireGuard Agent on peer A initiates the establishment of the VPN tunnel by generating the contents of the _Handshake Initiation_ packet.
2. The CPU transfers the _Handshake Initiation_ packet from RAM to the Rx FIFO via the CSR interface towards the data plane.
3. Once the entire packet is stored in the Rx FIFO, the Round Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
4. In the first three cycles of the packet transfer, the Header Parser extracts important information from the packet header (including the destination IP address and type of WireGuard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Initiation_), the WireGuard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
5. The IP Lookup Engine searches the routing table based on the destination IP address and determines the outgoing Ethernet interface, supplementing this information to the packet before forwarding it. Similar to the previous step, the WireGuard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
6. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (to _if1_).
7. Once the entire packet is stored in the Tx FIFO, it is dispatched to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
8. The 1G MAC writes its MAC address as the source address, calculates the FCS on the fly, adds it to the end of the Ethernet frame, and sends it to peer B.

![Example23](../0.doc/Wireguard/wireguard-fpga-muxed-Example-2-3-B-Handshake-Initiation-Response.webp)

9. On peer B, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
10. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
11. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
12. The Header Parser extracts important information from the packet header (including the destination IP address and type of WireGuard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Initiation_), the WireGuard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
13. The IP Lookup Engine searches the routing table based on the destination IP address and determines that the control plane is the destination, supplementing this information to the packet before forwarding it. Similar to the previous step, the WireGuard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
14. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward the CPU).
15. Once the entire packet is stored in the Tx FIFO, the CPU transfers the packet from the FIFO to RAM via the CSR-based interface and hands it over to the WireGuard Agent for further processing.
16. The WireGuard Agent processes the _Handshake Initiation_ request and generates the _Handshake Response_.
17. The Routing DB Updater updates the routing table per the WireGuard Agent's instructions (adding the peer's IP address and WireGuard-related data).
18. The CPU updates the registers from which the data plane reads the routing table and the corresponding cryptographic keys via the CSR interface.
19. The CPU transfers the _Handshake Response_ packet from RAM to the Rx FIFO (to the data plane) via the CSR interface.
20. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
21. The Header Parser extracts important information from the packet header (including the destination IP address and type of WireGuard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Response_), the WireGuard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
22. The IP Lookup Engine searches the routing table based on the destination IP address and determines the outgoing Ethernet interface, supplementing this information to the packet before forwarding it. Similar to the previous step, the WireGuard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
23. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if1_).
24. Once the entire packet is stored in the Tx FIFO, it is dispatched to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
25. The 1G MAC writes its MAC address as the source address, calculates the FCS on the fly, adds it to the end of the Ethernet frame, and sends it to peer A.

![Example4](../0.doc/Wireguard/wireguard-fpga-muxed-Example-4-A-Handshake-Response.webp)

26. On peer A, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
27. Once the entire packet is stored, the Rx FIFO signals the Roung-Robin Multiplexer.
28. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
29. The Header Parser extracts important information from the packet header (including the destination IP address and type of WireGuard message) and supplements the extracted metadata to the packet before passing it along. Now, knowing the message type (_Handshake Response_), the WireGuard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
30. The IP Lookup Engine searches the routing table based on the destination IP address and determines that the control plane is the destination, supplementing this information to the packet before forwarding it. Similar to the previous step, the WireGuard/UDP Packet Assembler and ChaCha20-Poly1305 Encryptor forward the packet without any additional processing.
31. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward the CPU).
32. Once the entire packet is stored in the Tx FIFO, the CPU transfers the packet from the FIFO to RAM via the CSR-based interface and hands it over to the WireGuard Agent for further processing.
33. The WireGuard Agent processes the _Handshake Response_.
34. The Routing DB Updater updates the routing table per the WireGuard Agent's instructions (adding the peer's IP address and WireGuard-related data).
35. The CPU updates the registers from which the data plane reads the routing table and the corresponding cryptographic keys. The session is now officially established, and the exchange of user data over the encrypted VPN tunnel can commence.

![Example5](../0.doc/Wireguard/wireguard-fpga-muxed-Example-5-A-Transfer-Data.webp)

36. On peer A, an end-user packet (_ICMP Echo Request_) arrives via the _if2_ Ethernet interface. The 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if2_).
37. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
38. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
39. The Header Parser extracts important information from the packet header (including the destination IP address and protocol type) and supplements the extracted metadata to the packet before passing it along. Now, knowing the protocol type (ICMP), the WireGuard/UDP Packet Disassembler and ChaCha20-Poly1305 Decryptor forward the packet without any further processing.
40. The IP Lookup Engine searches the routing table based on the destination IP address and determines the target WireGuard peer and the outgoing Ethernet interface, supplementing this information to the packet before forwarding it.
41. Based on the information about the target peer and the corresponding key, the ChaCha20-Poly1305 Encryptor encrypts the packet and adds an authentication tag.
42. The WireGuard/UDP Packet Assembler adds WireGuard, UDP, IP, and Ethernet headers filled with the appropriate data to the encrypted packet and forwards it.
43. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if1_).
44. Once the entire packet is stored in the Tx FIFO, it is sent to the MAC core of the outgoing interface _if1_, provided that the corresponding 1 Gbps link is active and ready.
45. The 1G MAC writes its MAC address as the source, calculates the FCS on the fly, which it ultimately appends to the end of the Ethernet frame, and then sends it to peer B.

![Example6](../0.doc/Wireguard/wireguard-fpga-muxed-Example-6-B-Transfer-Data.webp)

46. On peer B, the 1G MAC receives the incoming Ethernet frame and calculates the FCS on the fly. If the frame is valid, it is forwarded to the Rx FIFO (from _if1_).
47. Once the entire packet is stored, the Rx FIFO signals the Round-Robin Multiplexer.
48. The Round-Robin Multiplexer services the packet from the FIFO and injects it into the data plane pipeline.
49. The Header Parser extracts important information from the packet header (including source/destination IP addresses and the type of WireGuard message) and supplements the extracted metadata to the packet before passing it along.
50. Based on the destination IP address, the WireGuard/UDP Packet Disassembler knows that the packet is intended for this peer, extracting the encrypted payload and forwarding it for further processing.
51. The ChaCha20-Poly1305 Decryptor decrypts the packet and, after verifying the authentication tag, forwards it further.
52. The IP Lookup Engine now receives the decrypted plaintext user packet (_ICMP Echo Request_). After searching the cryptokey routing table based on the source IP address of the decrypted plaintext packet, a decision is made to accept or reject the packet. If the packet correspondingly routes, it is forwarded.
53. Based on the accompanying metadata, the Demultiplexer directs the packet to the corresponding Tx FIFO (toward _if2_).
54. Once the entire packet is stored in the Tx FIFO, it is sent to the MAC core of the outgoing interface _if2_, provided that the corresponding 1 Gbps link is active and ready.
55. The 1G MAC writes its MAC address as the source, calculates the FCS on the fly, which it ultimately appends to the end of the Ethernet frame, and then sends it to the end-user host of peer B.
