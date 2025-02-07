# Simulation Models

This directory contains the following bus functional models

* `bfm_phy_mdio.sv` : MDIO slave bus functional model
* `soc_cpu.VPROC.sv` : _VProc_ based `soc_cpu` compatible virtual processor.
* `bfm_adc.sv`: Simple bus functional bodel of ADS1675 ADC
* `bfm_dac.sv` : Minimal Digital to Analog Converter behavioural bodel
* `bfm_uart.sv` : Minimal UART bus functional model
* `gowin.prim.CHILI.v` : Shortened version of gowin.prim_sim.v

In addition, sub-directories contain the following models

* [`cosim`](cosim/README.md) : Contains the _VProc_ and _mem_model_ co-simulation VIP.
* [`rv32`](rv32/README.md) : Contains the _rv32_ RISC-V RV32GC instruction set simulator C++ model
* [`udpIpPg`](udpIpPg/README.md) : Contains the Ethernet UDP/IPv4 pachet generator with GMII/RGMII interfaces

## soc_cpu.VPROC

The `soc_cpu.VPROC` module is pin compatible with the other `soc_cpu` components with RTL softcore implementations of 32-bit RISC-V processors, such as that based on PicoRV32 or EDUBOS5. In place of the softcore is a [_VProc_](https://github.com/wyvernSemi/vproc) virtual processor which can run natively compiled code and drive its memory mapped bus in the logic simulation (see [here](../README.md#vproc-software). The HDL has only two interfaces. The main memory mapped bus is of type `soc_if`, and this is the external bus to the rest of the logic, just as for the softcores. The other interface is a three wire write-only port (`imem_we`, `imem_waddr[31:2]` and `imem_wdat[31:0]`) for updating the proccor program via an external UART. In the `soc_cpu.VPROC` component this is connected to an instantiation of the [mem_model](https://github.com/wyvernSemi/mem_model) sparse memory VIP, used by _VProc_ for its [main memory](../README.md#the-mem_model-co-simulation-sparse-memory-model), allowing this upload to go to the same memory as the virtual processor.

<p align="center"><img width="400" src="https://github.com/user-attachments/assets/e0b58246-f6cc-47d1-abdc-1a9a10bb0acd"></p>


## The bfm_ethernet Ethernet Driver Module

The `bfm_ethernet` module, in the [`udpIpPg`](udpIpPg/README.md) sub-directory, is an ethernet driver module with four GMII ports than can receive and generate UDP/IPv4 packets for 1GbE. The GMII interfaces can be configured to generate RGMII signalling (mapped onto the GMII ports) using an internal `gmii_rgmii_conv.v` convertor module. In addition it has four matching MDIO slave serial interfaces to receive and respond to MDIO transactions used in the solution for configuring a the PHY block.

<p align="center"><img width= "600" src="https://github.com/user-attachments/assets/5d441c97-9d9f-43d7-99da-d5156b7d106d"></p>

The `bfm_ethernet` module has four parameters:

* `START_NODE` : Specifies the start node for the `udpIpPg` _VProc_ nodes. Default 1.
* `NUM_PORTS` : Specifes the number of GMII/MDIO ports supported. Default 4.
* `MDIO_BUFF_ADDR` : Specifies the base address in shared *mem_model* memory space. Default `0x50000000`.
* `RGMII` : Specifies, when non-zero, to use the RGMII signalling. Default 1.

Internal to the BFM are four instantiated [_udpIpPg_](https://github.com/wyvernSemi/udpIpPg) blocks for generating and receiving ethernet frames and four [`bfm_phy_mdio`](#the-bfm_phy_mdio-mdio-slave-driver-module) modules as MDIO slave devices. The `udpIpPg` VIP is a _VProc_ based module and is programmed in a similar fashion to the `soc_cpu.VPROC` module, but with a [different API](../README.md#udpippg-software). From this software packets can be received and packets transmitted. The software can also have accesss to the [*mem_model* API](cosim/README.md#mem_model), allowing recived data to be stored in the shared memory space, or for data packet payloads to be generated externally and fetched from the shared memory space. [More details](udpIpPg/README.md) of the _udpIpPg_ VIP can be found in its sub-directory.

## The bfm_phy_mdio MDIO Slave Driver Module

The `bfm_ethernet` module has a  MDIO interface and this is processed by instantiating the `bfm_mdio_phy` MDIO PHY slave bus functional model. This model decodes the register accesses as IEEE 802.3 Clause 22 registers and prints a message to the simulation output as to which register is being accessed upon reception. The read and write transactions are actually mapped to the shared sparse memory model via an instantiated `mem_model` HDL block. Using its address mapped read-write port, each register is mapped as a region of memory with base byte address offset specified in the `MDIO_BUFF_ADDR` parameter. Thus the `soc_cpu.VPROC` running program (or any of the _VProc_ programs) can access this memory to set values to be read, or check values that were write over MDIO.

<p align="center"><img width=550 src="https://github.com/user-attachments/assets/889aff76-549e-4a63-80f0-c21077fbe155"></p>

Within the four instantiations of the module in `bfm_ethernet`, each is assigned an offset from its `MDIO_BUFF_ADDR` base address (default `0x50000000`), spaced by 256 bytes. The `NODE` parameter is just for output display to identify from which `bfm_phy_mdio` the message originated. Within `bfm_ethernet` each of the four blocks are assigned a node starting from the `bfm_ethernet` module's `START_NODE` parameter (default 1).


## Others

TODO