# Wireguard FPGA
Virtual Private Networks (VPNs) are the central and indispensable component of Internet security. They comprise a set of technologies that connect geographically dispersed, heterogeneous networks through encrypted tunnels, creating the impression of a homogenous private network on the public shared physical medium. 

With traditional solutions (such as OpenVPN / IPSec) starting to run out of steam, Wireguard is increasingly coming to the forefront as a modern, secure data tunneling and encryption method, also much easier to manage than the incumbents. Both software and hardware implementations of Wireguard already exist. However, the software performance is far below the speed of wire. Existing hardware approaches are both prohibitively expensive, and based on proprietary, closed-source IP blocks and tools.

The intent of this project is to bridge these gaps with an FPGA based open-source implementation of Wireguard, written in SystemVerilog HDL.

![wireguard-FPGA logo](https://github.com/user-attachments/assets/d12e18d1-13ba-4055-8ce7-3033846aad57)

## A Glimpse into History 
We have contributed to “Blackwire project”, which is a 100Gbps hardware implementation of Wireguard switch based on AMD/Xilinx-proprietary AlveoU50 PC-accelerator card (SmartNIC form-factor), and implementable only with proprietary Vivado toolchain. 

While working on the Blackwire, we have touched multiple sections, and focused on the novel algorithm for the _Balanced Binary Tree Search_ of IP tables. However, the Blackwire hardware platform is expensive, essentially priced out of reach of most educational institutions. Its gateware is written in SpinalHDL, which is a niche HDL, hardly popular in either academia or industry. While Blackwire is now released to open-source, that decision came out of financial hardship. Moreover, the company behind Blackwire (which was originaly meant for sale) has financial and potential lawsuit issues that bring into question the legality of ownership over the codebase they donated to the open source community. 

## Back to the Future
To make the hardware Wireguard truly accessible in the genuine spirit of open-source movement, this project is implementing it:
-	for an [inexpensive hardware platform](https://www.alinx.com/en/detail/611) with four 1000Base-T ports
-	in a self-sufficient way, i.e. w/o requiring PC host
-	using a commodity Artix7 FPGA
-	which is supported by open-source tools  
-	and with all gateware written in the ubiquitous Verilog / System Verilog

## References
  1) Wireguard implementations in software:
     - https://github.com/netbirdio/netbird
     - https://tailscale.com/blog/more-throughput
     - Linux Kernel
  2) 100Gbps Blackwire Wireguard https://github.com/brightai-nl/BrightAI-Blackwire
  3) 10Gbps Ethernet Switch https://github.com/ZipCPU/eth10g
  4) https://github.com/corundum/corundum
  5) https://github.com/mrdcvlsc/ChaCha20-Poly1305
  6) https://github.com/openXC7
  7) https://github.com/chili-chips-ba/openXC7-TetriSaraj

# Project Outline

## Scope
The Phase1 is primarily **Proof of Concept**, i.e. not full-featured, and definitely not a deployable product. It is envisoned as a mere on-ramp, a springboard for future build-up and optimizations.

The Phase2 continuation project is therefore also in the plans, to maximize efficiency and overall useability, such as to increase the number of channels, facilitate management with a GUI app, or something else as identified by the community feedback.

## Recognized Challenges 
1) HW/SW partitioning, interactions, interface and workload distribution
> - While, contrary to Blackwire, we don’t have external PC connected via PCIE, we will still have an on-chip RISC-V CPU and significant Embedded Software component that needs to control the hardware backbone of wire-speed datapath

2) HW/SW co-development, integration and debugging
> - Standard simulation is impractical for the project of this size and complexity. We therefore intend put to test and good use the very promissing new [VProc ISS](https://www.linkedin.com/posts/simon-southwell-7684482_riscv-iss-embeddedsoftware-activity-7217116220754411520-08xZ?utm_source=share&utm_medium=member_desktop)
> - It’s also impractical and expensive to provide the test system with real traffic generators and checkers to all developers. We therefore plan to rent some space for a central lab that will host two full test systems, then provide remote access to all developers
3)	Real-life, at-speed testing
4)	Extent of open-source tools support for all needed FPGA primitives and IP functions
5)	QOR of the (still maturing) open-source tools
> - Blackwire used commercial, AMD/Xilinx-proprietary Vivado toolchain, as well as the high-end Alveo U50 FPGA silicon. Even with all of that, they ran into multiple timing closure, utilization and routing congestion challenges.
6) Financial resources
> - Given that this is a complex, multi-disciplinary dev effort, the available funding may not be sufficient for bringing it to completion. Blackwire, despite a larger budget, ended up with funding crisis and abrupt cessation of dev activities.

# Project Execution Plan
## Take1
**Board bring up. In-depth review of prior art and Wireguard ecosystem. Create design blueprint**

While the board we're using is low cost, it is also unknown in the open-source community. We certainly don’t have prior experience with it. Objective of this first take is to build a solid foundation for efficient project execution. Good preparation is crucial for a smooth run. Hence we seek to first _`understand and document what we will be designing, the SOC architecture, datapath microarchitecture, hardware/software partitioning`_, as well as to get a good feel for our Fmax. Artix-7 does not support High-Performance (HP) I/O. Consequently, we cannot push its I/O beyond 600MHz, nor its core logic beyond 100 MHz. 

- [ ] Familiarization with HW platform
- Create our first FPGA program that blinks LEDs
- Verify pinouts and connectivity using simple test routines
- Generate a few Ethernet test patterns 

- [ ] Familiarization with SW platform
- Initial bring up of embedded CPU
- Test simple SW interface into HW Ethernet datapath

- [ ] Detailed analysis and comparisons of:
- the entirety of Blackwire open-source archive
- existing implementations in software: NetBird, Linux Kernel, TailScale
- Wireguard [White Paper](https://www.ndss-symposium.org/wp-content/uploads/2017/09/ndss2017_04A-3_Donenfeld_paper.pdf)
- [cryptographic algorithms](https://eprint.iacr.org/2018/080.pdf) used for Wireguard, including ChaCha20 for encryption, Poly1305 for authentication, Curve25519 for key exchange, and BLAKE2s for hashing
  
- [x] Identification and assimilation of all necessary IP blocks, starting with the ones from References 

- [ ] Architectural design and HW/SW partitioning

- [ ] Creation of sufficient initial documentation for project divide-and-conquer across a sizeable, multi-disciplinary team

## Take2
**Implementation of a basic, statically pre-configured Wireguard link**

We are now moving onto implementation of Wireguard encryption protocols, using Vivado and Xilinx primitives.

- [ ] Integration of collected RTL blocks into a coherent HW system that implements the basic Wireguard datapath for a handful of manually pre-configured channels.
-	IP Core for ChaCha20-Poly1305
> - https://github.com/Goshik92/FpgaCha
> - https://github.com/secworks/ChaCha20-Poly1305
- Curve25519 module for key exchange
> - https://github.com/kazkojima/x25519-fpga
- BLAKE2s module for hashing
> - https://github.com/secworks/blake2
- [ ] Timing closure. Resolution of FPGA device utilization and routing congestion issues
- [ ] Creation of cocoTB DV in the CI environment and representative test cases for datapath simulation

## Take3
**Development and integration of embedded management software (Control Plane)**

This work package is about hardware/software codesign and integration. The firmware will run on a soft RISC V processor, inside the FPGA. This work can to some extent overlap with, and go on in parallel to the hardware activities within Take2. 

- [ ]	SW design for the embedded on-chip processor
- Code is to be written in bare-metal C with, as necessary, few sections in Assembly
- Responsible for configuration and management of hardware blocks, without participation in the bulk datapath transfers
- It may however intercept low frequency management packets
- Efficient IP Address Search (our novel balanced binary tree algorithm) and Key Management Module

- [ ] HW/SW Integration

## Take4
**VPN Tunnel: Session initialization, maintenance, and secure closure**
This is about managing the bring-up, maintenance and tear-down of VPN tunnels between two devices.
- [ ] Session Initialization: Starting the handshake process to establish secure communication with another device
- [ ] Maintenance: Keeping the session active through the regular exchange of control messages, which allows detection and recovery from problems such as connection interruptions
- [ ] Closing: Securely close the VPN tunnel when communication is no longer needed, ensuring that all temporary keys and sensitive data are deleted

### Acknowledgements
We are grateful to NLnet Foundation for sponsoring of this development activity.

![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)
<img width="115" alt="NGI-Entrust-Logo" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/67533663/013684f5-d530-42ab-807d-b4afd34c1522">

#### End of Document
