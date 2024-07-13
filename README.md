# Wireguard FPGA
Virtual Private Networks (VPNs) are the central and indispensable component of Internet security. They comprise a set of technologies that connect geographically dispersed, heterogeneous networks through encrypted tunnels, creating the impression of a homogenous private network on the public shared physical medium. 

With traditional solutions (such as OpenVPN / IPSec) starting to run out of steam, Wireguard is increasingly coming to the forefront as the most modern, secure data tunneling and encryption method, also much easier to manage than the incumbents. Both software and hardware implementations of Wireguard already exist. However, the software performance is far below the speed of wire. Existing hardware approaches are both prohibitively expensive and based on proprietary, closed-source IP blocks and tools.

The intent of this project is to bridge these gaps with an FPGA based open source implementation of Wireguard, written in SystemVerilog HDL.

![wireguard-FPGA logo](https://github.com/user-attachments/assets/d12e18d1-13ba-4055-8ce7-3033846aad57)

## A Glimpse into History 
We have contributed to “Blackwire project”, which is a 100Gbps implementation of Wireguard switch in hardware, written in SpinalHDL, based on AMD/Xilinx-proprietary AlveoU50 PC-accelerator card (SmartNIC form-factor), and possible only with proprietary Vivado toolchain. 

While working on the Blackwire, we have touched multiple sections, and focused on the novel algorithm for the _Balanced Binary Tree Search_ of IP tables. However, the Blackwire hardware platform is very expensive, essentially priced out of reach of most educational institutions. Its gateware is written in SpinalHDL, which is a niche HDL, hardly popular in either academia or industry. While Blackwire is now released to open-source, that decision came out of financial hardship. Moreover, the company behind Blackwire (which was originaly meant for sale) has financial and potential lawsuit issues that bring into question the legality of ownership over the codebase they donated to the open source community. 

## Back to the Future
To make the hardware Wireguard truly accessible in the genuine spirit of open source movement, this project is implementing it:
-	on an [inexpensive hardware platform](https://www.alinx.com/en/detail/611) with four 1000Base-T ports
-	which is self-sufficient, i.e. it does not require PC host
-	using a commodity Artix7 FPGA
-	which is also supported by open-source tools  
-	and with gateware written in the ubiquitous Verilog / System Verilog

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
Phase1 is primarily **Proof of Concept**, and not a full-featured or deployable product. It is envisoned as an on-ramp base / platform for the subsequent build-up and refinements, to lay the foundation for future optimizations and improvements towards maximizing the channel capacity, efficiency and overall useability. 

Phase2 is therefore also in the plans, such as to increase the number of channels, facilitate management with a GUI app, or something else as identified by the community feedback.

## Challenges 
•	HW/SW partitioning, interactions, interface and workload distribution
> While we don’t have external PC and PCIE that Blackwire was relying upon, we will still have an on-chip RISC-V CPU and significant Embedded Software component that needs to control the hardware backbone of wire-speed datapath

•	HW/SW co-development, integration and debugging
> We intent put to test and use the very promissing new [VProc ISS](https://www.linkedin.com/posts/simon-southwell-7684482_riscv-iss-embeddedsoftware-activity-7217116220754411520-08xZ?utm_source=share&utm_medium=member_desktop)

•	Real-life, at-speed testing
•	Extent of open-source tools support for all needed FPGA primitives and IP functions
•	QOR of the (still maturing) open-source tools
> Blackwire used commercial, AMD/Xilinx-proprietary Vivado toolchain, as well as the high-end Alveo U50 FPGA silicon. Even with all of that, they ran into multiple timing closure, utilization and routing congestion challenges.

# Project Execution Plan
## Take1
**Board bring up. In-depth review of Wireguard prior art and ecosystem**

[x] Familiarization with HW platform
- Create our first FPGA program that blinks LEDs
- Verify pinouts and connectivity using simple test routines
- Generate a few Ethernet test patterns 

[ ] Familiarization with SW platform
- Initial bring up of embedded CPU
- Test simple SW interface into HW Ethernet datapath

[ ] Detailed analysis and comparisons of:
- the entirety of Blackwire open-source archive
- existing implementations in software: NetBird, Linux Kernel, TailScale
- Wireguard [White Paper](https://www.ndss-symposium.org/wp-content/uploads/2017/09/ndss2017_04A-3_Donenfeld_paper.pdf)
- [cryptographic algorithms](https://eprint.iacr.org/2018/080.pdf) used for Wireguard, including ChaCha20 for encryption, Poly1305 for authentication, Curve25519 for key exchange, and BLAKE2s for hashing
  
[ ] Identification and assimilation of all necessary IP blocks, tapping into Blackwire-100GE, 10GE Switch, as well as a number of other libraries and previous projects

[ ] Architectural design and HW/SW partitioning

[ ] Creation of the sufficient initial documentation set for the project divide-and-conquer across a good-size, multi-disciplinary team. 

The goal is to understand the SOC and get a good feel for our Fmax. Artix-7, being a low-cost family, does not support High-Performance (HP) I/O. Consequently, we cannot push its I/O beyond 600MHz, nor its core logic beyond 100 MHz. 

## Take2
**Implementation of a basic, statically pre-configured Wireguard link**

### Acknowledgements
We are grateful to NLnet Foundation for sponsoring of this development activity.

![logo_nlnet](https://github.com/chili-chips-ba/openeye/assets/67533663/18e7db5c-8c52-406b-a58e-8860caa327c2)
<img width="115" alt="NGI-Entrust-Logo" src="https://github.com/chili-chips-ba/openeye-CamSI/assets/67533663/013684f5-d530-42ab-807d-b4afd34c1522">

#### End of Document
