# Wireguard FPGA
Virtual Private Networks (VPNs) are the central and indispensable component of Internet security. They comprise a set of technologies that connect geographically dispersed, heterogeneous networks through encrypted tunnels, creating the impression of a homogenous private network on the public shared physical medium. 
<p align="center">
  <img width="200", src="0.doc/artwork/wireguard-fpga.logo.png">
  <img width="150", src="0.doc/artwork/ethernet-cable.png">
  <img width="200", src="0.doc/artwork/wireguard-fpga.logo.png">
</p>

With traditional solutions (such as OpenVPN / IPSec) starting to run out of steam, Wireguard is increasingly coming to the forefront as a modern, secure data tunneling and encryption method, one that's also easier to manage than the incumbents. Both software and hardware implementations of Wireguard already exist. However, the software performance is far below the speed of wire. Existing hardware approaches are both prohibitively expensive and based on proprietary, closed-source IP blocks and tools.<br> 

- The intent of this project is to bridge these gaps with an FPGA open-source implementation of Wireguard, written in SystemVerilog HDL.

## A Glimpse into History 
We have contributed to the **Blackwire** project, which is a 100Gbps hardware implementation of Wireguard switch based on AMD/Xilinx-proprietary AlveoU50 PC-accelerator card (SmartNIC form-factor), and implementable only with proprietary Vivado toolchain. 

While working on the _Blackwire_, we have touched multiple sections, and focused on the novel algorithm for [_Balanced Binary Tree Search_](0.doc/Wireguard/Scalable-Balanced-Pipelined-IPv6-Lookup.pdf) of IP tables. However, the _Blackwire_ hardware platform is expensive and priced out of reach of most educational institutions. Its gateware is written in SpinalHDL, a nice and powerfull but a niche HDL, which has not taken roots in the industry. While _Blackwire_ is now released to open-source, that decision came from their financial hardship -- It was originaly meant for sale. Moreover, the company behind it is subject to disputes and obligations that bring into question the legality of ownership over the codebase they "donated" to the open source community. 

## Back to the Future
To make the hardware Wireguard truly accessible in the genuine spirit of open-source movement, this project implements it:
-	for an [inexpensive hardware platform](https://www.alinx.com/en/detail/611) with four 1000Base-T ports
-	in a self-sufficient way, i.e. w/o requiring PC host
-	using a commodity Artix7 FPGA
-	which is supported by open-source tools  
-	and with all gateware written in the ubiquitous Verilog / System Verilog

<p align="center">
  <img width="600" src="0.doc/Alinx/ALINX7201x2.jpg">
  <img width="500" src="0.doc/Alinx/AX7201.jpg">
</p>

## References

**[Ref1]** Wireguard implementations in software:
  - [Netbird](https://github.com/netbirdio/netbird)
  - [Tailscale](https://tailscale.com/blog/more-throughput)
  - [Linux Kernel](https://thenewstack.io/Wireguard-vpn-protocol-coming-to-a-linux-kernel-near-you)
  
**[Ref2]** 100Gbps [_Blackwire_](https://github.com/brightai-nl/BrightAI-Blackwire) Wireguard 
  
**[Ref3]** [Corundum](https://github.com/corundum/corundum), open-source FPGA-NIC platform 
  
**[Ref4]** [ChaCha20-Poly1305](https://github.com/mrdcvlsc/ChaCha20-Poly1305) open-source Crypto RTL 
  
**[Ref5]** Cookie Cutter [SOC](https://github.com/chili-chips-ba/openXC7-TetriSaraj)

**[Ref6]** [RISC-V ISS](https://github.com/wyvernSemi/riscV/tree/main/iss)

**[Ref7]** [10Gbps Ethernet Switch](https://github.com/ZipCPU/eth10g)
  
**[Ref8]** [OpenXC7](https://github.com/openXC7) open-source tools for Xilinx Series7

**[Ref9]** [Alex's Ethernet Stack](https://github.com/alexforencich/verilog-ethernet)

**[Ref10]** [Amina's ADASEC-SDN](https://github.com/etf-tk-sdn/ADASEC-SDN)

# Project Outline

## Scope
The Phase1 (This!) is primarily **Proof of Concept**, i.e. not full-featured, and definitely not a deployable product. It is envisoned as a mere on-ramp, a springboard for future build-up and optimizations.

The Phase2 continuation project is therefore also in the plans, to maximize efficiency and overall useability, such as by increasing the number of channels, facilitating management with GUI apps, or something else as identified by the community feedback.

## Recognized Challenges 
1) HW/SW partitioning, interface, interactions and workload distribution
    - While, contrary to _Blackwire_, we don’t rely on an external PC connected via PCIE, we will still have an on-chip RISC-V CPU with intricate hardware interface and significant Embedded Software component that controls the backbone of wire-speed datapath

2) HW/SW co-development, integration and debugging
    - Standard simulation is impractical for the project of this size and complexity. We therefore intend to put to test and good use the very promissing new [VProc ISS](https://www.linkedin.com/posts/simon-southwell-7684482_riscv-iss-embeddedsoftware-activity-7217116220754411520-08xZ?utm_source=share&utm_medium=member_desktop) [Ref6]
    - It’s also impractical and expensive to provide full test systems with real traffic generators and checkers to all developers. We therefore plan to rent some space for a central lab that will host two test systems, then provide remote access to all developers

3)	Real-life, at-speed testing
4)	Extent of open-source tools support for SystemVerilog and all needed FPGA primitives and IP functions
5)	QOR of the (still maturing) open-source tools
    - _Blackwire_ used commercial, AMD/Xilinx-proprietary Vivado toolchain, as well as high-end Alveo U50 FPGA silicon. Even then, they ran into multiple timing closure, utilization and routing congestion challenges.
6) Financial resources
    - Given that this is a complex, multi-disciplinary dev effort, the available funding may not be sufficient to bring it to completion. _Blackwire_, despite a larger allocated budget, ended up with funding crisis and abrupt cessation of dev activities.

# Project Execution Plan / Tracking

This project is WIP at the moment. The checkmarks below indicate our status. Until all checkmarks are in place, anything you get from here is w/o guaranty -- Use at own risk, as you see fit, and don't blame us if it is not working 🌤️

## Take1
**Board bring up. In-depth review of Wireguard ecosystem and prior art. Design Blueprint**

While the board we're using is low cost, it is also not particularly known in the open-source community. We certainly don’t have prior experience with it. In this opening take we will build a solid foundation for efficient project execution. Good preparation is crucial for a smooth run. We thus seek to first _`understand and document what we will be designing: SOC Architecture, Datapath Microarchitecture, Hardware/Software Partitioning, DV and Validation Strategy`_. 

Getting a good feel for our Fmax is also a goal of this take. Artix-7 does not support High-Performance (HP) I/O. Consequently, we cannot push its I/O beyond 600MHz, nor its core logic beyond 100 MHz. 

- [x] Familiarization with HW platform
  - Create our first FPGA program that blinks LEDs
  - Verify pinouts and connectivity using simple test routines
  - Generate a few Ethernet test patterns 

- [x] Familiarization with SW platform
  - Initial bring up of embedded CPU within a _cookie-cutter_ SOC, such as [Ref5]
  - Design and test a simple SW interface to rudimentary HW Ethernet datapath

- [x] Detailed analysis and comparisons of:
  - Wireguard [White Papers](https://www.ndss-symposium.org/wp-content/uploads/2017/09/ndss2017_04A-3_Donenfeld_paper.pdf)
  - existing implementations in software [Ref1]
  - vs. _Blackwire_ hardware implementation [Ref2]
  - [cryptographic algorithms](https://eprint.iacr.org/2018/080.pdf) used for Wireguard, esp. **ChaCha20** for encryption, **Poly1305** for authentication [Ref4] and, to a lesser extent, _Curve25519_ for key exchange and _blake2_ for hashing
  
- [x] Identification and assimilation of prior art and building IP blocks, in particular **Corundum** [Ref3] and, to a lesser extent, _10GE Switch_ [Ref7] 

- [x] Architecture/uArch Design. HW/SW Partitioning. Verification Plan

- [x] Creation of sufficient initial documentation for project divide-and-conquer across a multi-disciplinary team of half a dozen developers

## Take2
**Implementation of a basic, statically pre-configured Wireguard link**

It it in this take that we start creating hardware Datapath and hardening Wireguard encryption protocols, all using Vivado and Xilinx primitives.

- [ ] Integration of collected RTL blocks into a coherent HW system that implements the basic Wireguard datapath for a handful of manually pre-configured channels.
  - Corundum FPGA-based NIC and platform for opensource Ethernet development [Ref3]
  -	IP Core for **ChaCha20-Poly1305** [Ref4] -- Definitely in hardware from the get-go
    - https://github.com/Goshik92/FpgaCha
    - https://github.com/secworks/ChaCha20-Poly1305
    - https://github.com/FPGA-House-AG/ChaCha20Poly1305
    - https://github.com/JulianKemmerer/PipelineC/tree/master/examples/chacha20poly1305

  - _Curve25519_ module for key exchange -- Likely in software at this point
    - https://github.com/kazkojima/x25519-fpga
  - _blake2_ module for hashing (we'll most likely do it in software)
    - https://github.com/secworks/blake2
      
- [ ] Timing closure. Resolution of FPGA device utilization and routing congestion issues
- [X] Creation of cocoTB DV in the CI/CD environmenT, and representative test cases for datapath simulation

## Take3
**Development and integration of embedded management software (Control Plane)**

This work package is about hardware/software codesign and integration. The firmware will run on a soft RISC V processor, inside the FPGA. Our vanilla SOC is at this point starting to be customized to Wireguard needs. This work can to some extent go on in parallel with hardware activities of Take2. 

- [X]	SW design for on-chip processor (Part 1)
  - Code is to be written in the bare-metal C with, as necessary, a few sections in Assembly
  - SW is responsible for configuration and management of hardware blocks
  - SW must not participate in the bulk datapath transfers
  - SW may however intercept the low-frequency management packets

- [ ]	SW design for on-chip processor (Part 2)
  - KMM function -- Key Management Module

- [X] HW/SW Integration

## Take4
**VPN Tunnel: Session initialization, maintenance, and secure closure**

This is about managing the bring-up, maintenance and tear-down of VPN tunnels between two devices.
- [ ] Session Initialization: Starting the handshake process to establish secure communication with another device
- [ ] Session Maintenance: Keeping the session active through the regular exchange of control messages, which allows detection and recovery from problems such as connection interruptions
- [ ] Session Closure: Securely close the VPN tunnel when communication is no longer needed, ensuring that all temporary keys and sensitive data are deleted

## Take5
**Testing, Profiling and Porting to OpenXC7**

- [ ] Functional testing on the real system. Does it work as intended? Bug fixes

- [ ] Performance testing. HW/SW profiling, updates and enhancements to ensure the design indeed operates at close to the wire speed on all preconfigured channels

- [ ] Porting to openXC7 [Ref8] using [SV2V](https://github.com/zachjs/sv2v), in the GoCD CI/CD setting 
  - This is challenging, as openXC7 has thus far been crashing for NES SV

- [ ] Timing closure with openXC7
  - This is definitely challenging, given that openXC7 is currently without accurate timing-driven STA

- [ ] Filing bug tickets with open source developers for issues found in their tools, supporting them all the way to the resolution
      
- [x] Creation and maintenance of an attractive and well-documented Github repo, to entice community interest
      
- [ ] Ongoing documentation updates and CI/CD script maintenance to keep it valid in the light of inevitable design mutations compared to the original Design Blueprint.


## Take6 (time-permitting Bonus)
**Flow control module for efficient and stable VPN tunnel data management**

The objective of this optional deliverable is to ensure stable and efficient links, thus taking this project one step closer to a deployable product.

- [ ] Develop software components for management of data flow within VPN tunnels


# Design Blueprint (WIP)
## HW/SW Partitioning
Since the WireGuard node essentially functions as an IP router with WireGuard protocol support, we have decided to design the system according to a two-layer architecture: a control plane responsible for managing IP routing processes and executing the WireGuard protocol (managing remote peers, sessions, and keys), and a data plane that will perform IP routing and cryptography processes at wire speed. The control plane will be implemented as software running on a soft CPU, while the data plane will be fully implemented in RTL on an FPGA.

![HWSWPartitioning](./0.doc/Wireguard/wireguard-fpga-muxed-Architecture-HW-SW-Partitioning.webp)

In the HW/SW partitioning diagram, we can observe two types of network traffic: control traffic, which originates from the control plane and goes toward the external network (and vice versa), and data traffic, which arrives from the external network and, after processing in the data plane, returns to the external network. Specifically, control traffic represents WireGuard protocol handshake messages, while data traffic consists of end-user traffic, either encrypted or in plaintext, depending on the perspective.

## Hardware Architecture and Theory of Operation
![HWArchitecture](./0.doc/Wireguard/wireguard-fpga-muxed-Architecture-HW.webp)

The hardware architecture essentially follows the HW/SW partitioning and consists of two domains: a soft CPU for the control plane and RTL for the data plane.

The soft CPU is equipped with a Boot ROM and a DDR3 SDRAM controller for interfacing with off-chip memory. External memory is exclusively used for control plane processes and does not store packets. The connection between the control and data planes is established through a CSR-based HAL.

The data plane consists of several IP cores, including data plane engine (DPE) and supporting components, which are listed and explained in the direction of network traffic propagation:
- _PHY Controller_ - initial configuration of Realtek PHYs and monitoring link activity (link up/down events)
- _1G MAC_ - execution of the 1G Ethernet protocol (framing, flow control, FCS, etc.)
- _Rx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling
- _Per-Packet Round Robin Multiplexer_ - servicing Rx FIFOs on a per-packet basis using a round-robin algorithm
- _Header Parser_ - extraction of WireGuard-related information from packet headers (IP addresses, UDP ports, WireGuard message type, peer ID, etc.)
- _Wireguard/UDP Packet Disassembler_ - decapsulation of the payload from the Wireguard data packet for decryption of tunneled traffic
- _ChaCha20-Poly1305 Decryptor_ - decryption and authentication of tunneled traffic
- _IP Lookup Engine_ - routing/forwarding table lookup, mapping packets to the appropriate WireGuard peer, and making packet accept/reject decisions
- _ChaCha20-Poly1305 Encryptor_ - encryption and authentication of traffic to be tunneled
- _Wireguard/UDP Packet Assembler_ - encapsulation of the encrypted packet into a WireGuard data packet for tunneling to the remote peer
- _Per-Packet Demultiplexer_ - forwarding packets to Tx FIFOs based on packet type and destination
- _Tx FIFOs_ - clock domain crossing, bus width conversion, and store & forward packet handling

_ChaCha20-Poly1305 Encryptor/Decryptor_ are using [RFC7539's](https://datatracker.ietf.org/doc/html/rfc7539) AEAD (Authenticated Encryption Authenticated Data) construction based on [ChaCha20](http://cr.yp.to/chacha.html) for symmetric encryption and [Poly1305](http://cr.yp.to/mac.html) for authentication.

The details of hardware architecture can be found in the [README.md](./1.hw/README.md) in the `1.hw/` directory.

## Software Architecture and Theory of Operation
![SWArchitecture](./0.doc/Wireguard/wireguard-fpga-muxed-Architecture-SW.webp)

The conceptual class diagram provides an overview of the components in the software part of the system without delving into implementation details. The focus is on the WireGuard Agent, which implements the protocol's handshake procedures, along with the following supplementary components:
- [Curve25519](http://cr.yp.to/ecdh.html) - an ECDH algorithm implementation for establishing a shared secret using a public-private key pair between two remote parties connected via an insecure channel, such as the Internet
- ChaCha20-Poly1305 - an AEAD algorithm implementation for encryption and authentication of static keys and nonce values to prevent replay attacks
- XChaCha20-Poly1305 - a XAEAD algorithm implementation for encrypting and authenticating nonce values in Cookie Replay messages to mitigate potential DoS attacks
- [BLAKE2s](https://www.blake2.net) - an implementation of the BLAKE2s hash function for MAC authentication and keyed hashing, per [RFC7693](https://datatracker.ietf.org/doc/html/rfc7693)
- RNG - a random number generator used to initialize the DH key generator and generate peer identifiers
- Timer - timers for rekey, retry, and keepalive procedures
- [HKDF](https://eprint.iacr.org/2010/264) - an implementation of the algorithm for expanding the ECDH result
- RTC - a real-time clock used to generate the TAI64N timestamp
- [SipHash](https://en.wikipedia.org/wiki/SipHash) - a simple non-cryptographic function used for implementing a hashtable for fast lookup of decrypted static public keys of remote peers
- Routing DB Updater - a subsystem for maintaining the cryptokey routing table content and deploying it to the data plane via the HAL/CSR interface
- ICMP - implementing basic ICMP protocol functions (echo request/reply, TTL exceeded, etc.)
- CLI - a USB/UART-based command-line interface for configuring the WireGuard node (setting the local IP address, remote peer IP addresses, network addresses, keys, etc.)
- HAL/CSR Driver - a CSR-based abstraction for data plane components with an interface for reading/writing the corresponding registers

The details of software architecture can be found in the [README.md](./2.sw/README.md) in the `2.sw/` directory.

## HW/SW Working Together as a Coherent System
To illustrate the operation of the system as a whole, we have prepared a step-by-step analysis of packets processing based on the capture of real WireGuard traffic. The experimental topology consists of four nodes:
- 10.10.0.2 - the end-user host at site A
- 10.9.0.1 - WireGuard peer A
- 10.9.0.2 - WireGuard peer B
- 10.10.0.1 - the end-user host at site B

![ExampleToplogy](./0.doc/Wireguard/wireguard-fpga-muxed-Example-Topology.webp)

The detailed analysis can be found in the [README.md](./1.hw/README.md#hwsw-working-together-as-a-coherent-system) in the `1.hw/` directory.

## Simulation Test Bench

The [Wireguard FPGA test bench](4.sim/README.md) aims to have a flexible approach to simulation which allows a common test environment to be used whilst selecting between alternative CPU components, one of which uses the [_VProc_ virtual processor](https://github.com/wyvernSemi/vproc) co-simulation element. This allows simulations to be fully HDL, with a RISC-V processor RTL implementation such as picoRV32, IBEX or EDUBOS5, or to co-simulate software using the virtual processor, with a significant speed up in simulation times. The test bench has the following features:

* A [_VProc_](https://github.com/wyvernSemi/vproc) virtual processor based [`soc_cpu.VPROC`](4.sim/models/README.md#soc-cpu-vproc) component
  * [Selectable](4.sim/README.md#auto-selection-of-soc_cpu-component) between this or an RTL softcore
  * Can run natively compiled test code
  * Can run the application compiled natively with the [auto-generated co-sim HAL](3.build/README.md#co-simulation-hal)
  * Can run RISC-V compiled code using the [rv32 RISC-V ISS model](4.sim/models/rv32/README.md)
* Uses a C [sparse memory model](https://github.com/wyvernSemi/mem_model)
  * An [HDL component](4.sim/models/cosim/README.md) instantiated in logic gives logic access to this memory
  * An API is provided to _VProc_ running code for direct access
* The [_udpIpPg VIP_](https://github.com/wyvernSemi/udpIpPg) is used to drive the logic's four ethernet ports in a four port [`bfm_ethernet`](4.sim/models/README.md#bfm_phy_ethernet) block.
  * An [MDIO slave interface](4.sim/models/README.md#bfm_phy_mdio) is also provided that maps *mem_model* memory areas to the registers with instantiated *mem_model* components

The figure below shows an oveview block diagram of the test bench HDL.

<p align="center">
<img src="https://github.com/user-attachments/assets/98cb3a19-11c7-4470-a4e1-41c503429e14" width=600>
</p>

More details on the architecture and usage of the Wireguard test bench can be found in the [README.md](4.sim/README.md) in the `4.sim` directory.

## Co-simulation HAL

The Wireguard control and status register harware abstraction layer (HAL) software is [auto-generated](3.build/README.md#co-simulation-hal), as is the CSR RTL, using [`peakrdl`](https://peakrdl-cheader.readthedocs.io/en/latest/). For co-simulation purposes an additional layer is auto-generated from the same SystemRDL specification using [`systemrdl-compiler`](https://systemrdl-compiler.readthedocs.io/en/stable/) that accompanies the `peakrdl` tools. This produces two header files that define a common API to the application layer for both the RISC-V platform and the *VProc* based co-simulation verification environment. The details of the HAL generation can be found in the [README.md](./3.build/README.md#co-simulation-hal) in the `3.build/` directory.

## Lab Test and Validation Setup
TODO

## Shared Linux Server with tools
**WIP**

### Tool Versions
#### Simulation
* _Verilator_ **v5.024**
* _VProc_ **v1.12.2**
* _Mem Model_ **v1.0.0**
* _rv32_ ISS **v1.1.4**
* _udpIpPg_ **v1.0.3**

## Build process
### Hardware
TODO
### Software
TODO

## CPU Live debug and reload
TODO

## Closing Notes
TODO

### Acknowledgements
We are grateful to **NLnet Foundation** for their sponsorship of this development activity.

<p align="center">
   <img src="https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2">
   <img width="115" alt="NGI-Entrust-Logo" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/67533663/013684f5-d530-42ab-807d-b4afd34c1522">
</p>

The **wyvernSemi**'s wisdom and contribution made a great deal of difference -- Thank you, we are honored to have you on the project.

<p align="center">
 <img width="115" alt="wyvernSemi-Logo" src="https://github.com/user-attachments/assets/94858fce-081a-43b4-a593-d7d79ef38e13">
</p>

### Public posts:
- [2025-06-07](https://www.linkedin.com/posts/simon-southwell-7684482_had-a-great-time-at-the-fpga-conference-europe-activity-7347534737554505729-pWYJ?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAJv-TcBSi_5ff0VNMrInrT-xg44YF3jnyU)
- [2025-05-17](https://www.linkedin.com/posts/chili-chips_opensource-wireguard-fpga-activity-7329738780876197888-ljJR?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAJv-TcBSi_5ff0VNMrInrT-xg44YF3jnyU)
- [2025-01-18](https://www.linkedin.com/feed/update/urn:li:activity:7283512029850533888?commentUrn=urn%3Ali%3Acomment%3A%28activity%3A7283512029850533888%2C7286441731925966848%29&replyUrn=urn%3Ali%3Acomment%3A%28activity%3A7283512029850533888%2C7286511091923202048%29&dashCommentUrn=urn%3Ali%3Afsd_comment%3A%287286441731925966848%2Curn%3Ali%3Aactivity%3A7283512029850533888%29&dashReplyUrn=urn%3Ali%3Afsd_comment%3A%287286511091923202048%2Curn%3Ali%3Aactivity%3A7283512029850533888%29)
- [2024-10-27](https://www.linkedin.com/posts/simon-southwell-7684482_riscv-iss-embeddedsoftware-activity-7256311551178027008-1nlZ?utm_source=share&utm_medium=member_desktop)
- [2024-09-19](https://www.linkedin.com/posts/chili-chips_fpga-cpu-ethernet-activity-7242729037771522048-as-C?utm_source=share&utm_medium=member_desktop)

#### End of Document
