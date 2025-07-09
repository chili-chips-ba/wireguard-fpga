<!---
Markdown description for SystemRDL register map.

Don't override. Generated from: wireguard
  - csr_build/csr.rdl
-->

## wireguard address map

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x20000088

|  Offset  |Identifier|Name|
|----------|----------|----|
|0x00000000|   imem   |imem|
|0x10000000|   dmem   |dmem|
|0x20000000|    csr   | csr|

## imem memory

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x8000

<p>CPU Program Memory</p>

No supported members.


## dmem memory

- Absolute Address: 0x10000000
- Base Offset: 0x10000000
- Size: 0x8000

<p>CPU Data Memory</p>

No supported members.


## csr address map

- Absolute Address: 0x20000000
- Base Offset: 0x20000000
- Size: 0x88

<p>WireGuard FPGA CSR</p>

|Offset| Identifier|       Name       |
|------|-----------|------------------|
| 0x00 |  cpu_fifo |   csr.cpu_fifo   |
| 0x38 |    uart   |     csr.uart     |
| 0x48 |    gpio   |     csr.gpio     |
| 0x4C |ethernet[0]|csr.ethernet[0..3]|
| 0x58 |ethernet[1]|csr.ethernet[0..3]|
| 0x64 |ethernet[2]|csr.ethernet[0..3]|
| 0x70 |ethernet[3]|csr.ethernet[0..3]|
| 0x7C |    dpe    |      csr.dpe     |
| 0x80 |   hw_id   |     csr.hw_id    |
| 0x84 | hw_version|  csr.hw_version  |

## cpu_fifo register file

- Absolute Address: 0x20000000
- Base Offset: 0x0
- Size: 0x38

<p>CPU FIFOs CSR</p>

|Offset|Identifier|      Name     |
|------|----------|---------------|
| 0x00 |    rx    |csr.cpu_fifo.rx|
| 0x1C |    tx    |csr.cpu_fifo.tx|

## rx register file

- Absolute Address: 0x20000000
- Base Offset: 0x0
- Size: 0x1C

<p>Rx FIFO CSR (CPU --&gt; DPE)</p>

|Offset| Identifier|            Name           |
|------|-----------|---------------------------|
| 0x00 | data_31_0 | csr.cpu_fifo.rx.data_31_0 |
| 0x04 | data_63_32| csr.cpu_fifo.rx.data_63_32|
| 0x08 | data_95_64| csr.cpu_fifo.rx.data_95_64|
| 0x0C |data_127_96|csr.cpu_fifo.rx.data_127_96|
| 0x10 |  control  |  csr.cpu_fifo.rx.control  |
| 0x14 |  trigger  |  csr.cpu_fifo.rx.trigger  |
| 0x18 |   status  |   csr.cpu_fifo.rx.status  |

### data_31_0 register

- Absolute Address: 0x20000000
- Base Offset: 0x0
- Size: 0x4

<p>Rx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|   tdata  |  rw  | 0x0 |csr.cpu_fifo.rx.data_31_0.tdata[31:0]|

#### tdata field

<p>1st 4-byte segment of TDATA, i.e. TDATA[31:0]</p>

### data_63_32 register

- Absolute Address: 0x20000004
- Base Offset: 0x4
- Size: 0x4

<p>Rx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|31:0|   tdata  |  rw  | 0x0 |csr.cpu_fifo.rx.data_63_32.tdata[31:0]|

#### tdata field

<p>2nd 4-byte segment of TDATA, i.e. TDATA[63:32]</p>

### data_95_64 register

- Absolute Address: 0x20000008
- Base Offset: 0x8
- Size: 0x4

<p>Rx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|31:0|   tdata  |  rw  | 0x0 |csr.cpu_fifo.rx.data_95_64.tdata[31:0]|

#### tdata field

<p>3rd 4-byte segment of TDATA, i.e. TDATA[95:64]</p>

### data_127_96 register

- Absolute Address: 0x2000000C
- Base Offset: 0xC
- Size: 0x4

<p>Rx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                  Name                 |
|----|----------|------|-----|---------------------------------------|
|31:0|   tdata  |  rw  | 0x0 |csr.cpu_fifo.rx.data_127_96.tdata[31:0]|

#### tdata field

<p>4th 4-byte segment of TDATA, i.e. TDATA[127:96]</p>

### control register

- Absolute Address: 0x20000010
- Base Offset: 0x10
- Size: 0x4

<p>Rx FIFO Control Register</p>

| Bits|    Identifier    |Access|Reset|                   Name                   |
|-----|------------------|------|-----|------------------------------------------|
| 2:0 |     tuser_dst    |  rw  | 0x0 |  csr.cpu_fifo.rx.control.tuser_dst[2:0]  |
| 5:3 |     tuser_src    |  rw  | 0x0 |  csr.cpu_fifo.rx.control.tuser_src[2:0]  |
|  6  |tuser_bypass_stage|  rw  | 0x0 |csr.cpu_fifo.rx.control.tuser_bypass_stage|
|  7  | tuser_bypass_all |  rw  | 0x0 | csr.cpu_fifo.rx.control.tuser_bypass_all |
|  15 |       tlast      |  rw  | 0x0 |       csr.cpu_fifo.rx.control.tlast      |
|31:16|       tkeep      |  rw  | 0x0 |    csr.cpu_fifo.rx.control.tkeep[15:0]   |

#### tuser_dst field

<p>Internal destination address (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4, 7 - broadcast)</p>

#### tuser_src field

<p>Internal source address (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4)</p>

#### tuser_bypass_stage field

<p>Next stage of the DPE is bypassed when active</p>

#### tuser_bypass_all field

<p>DPE is bypassed when active</p>

#### tlast field

<p>Indicates boundary of a packet, i.e. active on last transfer</p>

#### tkeep field

<p>Byte-enable for TDATA (e.g. TKEEP[15] corresponds to TDATA[127:119])</p>

### trigger register

- Absolute Address: 0x20000014
- Base Offset: 0x14
- Size: 0x4

<p>Rx FIFO Trigger Register</p>

|Bits|Identifier|Access|Reset|             Name             |
|----|----------|------|-----|------------------------------|
|  0 |  tvalid  |  rw  | 0x0 |csr.cpu_fifo.rx.trigger.tvalid|

#### tvalid field

<p>Indicates valid transfer from the CPU to the Rx FIFO (single pulse trigger)</p>

### status register

- Absolute Address: 0x20000018
- Base Offset: 0x18
- Size: 0x4

<p>Rx FIFO Status Register</p>

|Bits|Identifier|Access|Reset|             Name            |
|----|----------|------|-----|-----------------------------|
|  0 |  tready  |   r  | 0x0 |csr.cpu_fifo.rx.status.tready|

#### tready field

<p>Indicates that the Rx FIFO can accept a transfer</p>

## tx register file

- Absolute Address: 0x2000001C
- Base Offset: 0x1C
- Size: 0x1C

<p>Tx FIFO CSR (DPE --&gt; CPU)</p>

|Offset| Identifier|            Name           |
|------|-----------|---------------------------|
| 0x00 | data_31_0 | csr.cpu_fifo.tx.data_31_0 |
| 0x04 | data_63_32| csr.cpu_fifo.tx.data_63_32|
| 0x08 | data_95_64| csr.cpu_fifo.tx.data_95_64|
| 0x0C |data_127_96|csr.cpu_fifo.tx.data_127_96|
| 0x10 |  control  |  csr.cpu_fifo.tx.control  |
| 0x14 |  trigger  |  csr.cpu_fifo.tx.trigger  |
| 0x18 |   status  |   csr.cpu_fifo.tx.status  |

### data_31_0 register

- Absolute Address: 0x2000001C
- Base Offset: 0x0
- Size: 0x4

<p>Tx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|   tdata  |   r  | 0x0 |csr.cpu_fifo.tx.data_31_0.tdata[31:0]|

#### tdata field

<p>1st 4-byte segment of TDATA, i.e. TDATA[31:0]</p>

### data_63_32 register

- Absolute Address: 0x20000020
- Base Offset: 0x4
- Size: 0x4

<p>Tx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|31:0|   tdata  |   r  | 0x0 |csr.cpu_fifo.tx.data_63_32.tdata[31:0]|

#### tdata field

<p>2nd 4-byte segment of TDATA, i.e. TDATA[63:32]</p>

### data_95_64 register

- Absolute Address: 0x20000024
- Base Offset: 0x8
- Size: 0x4

<p>Tx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|31:0|   tdata  |   r  | 0x0 |csr.cpu_fifo.tx.data_95_64.tdata[31:0]|

#### tdata field

<p>3rd 4-byte segment of TDATA, i.e. TDATA[95:64]</p>

### data_127_96 register

- Absolute Address: 0x20000028
- Base Offset: 0xC
- Size: 0x4

<p>Tx FIFO Data Register</p>

|Bits|Identifier|Access|Reset|                  Name                 |
|----|----------|------|-----|---------------------------------------|
|31:0|   tdata  |   r  | 0x0 |csr.cpu_fifo.tx.data_127_96.tdata[31:0]|

#### tdata field

<p>4th 4-byte segment of TDATA, i.e. TDATA[127:96]</p>

### control register

- Absolute Address: 0x2000002C
- Base Offset: 0x10
- Size: 0x4

<p>Tx FIFO Control Register</p>

| Bits|    Identifier    |Access|Reset|                   Name                   |
|-----|------------------|------|-----|------------------------------------------|
| 2:0 |     tuser_dst    |   r  | 0x0 |  csr.cpu_fifo.tx.control.tuser_dst[2:0]  |
| 5:3 |     tuser_src    |   r  | 0x0 |  csr.cpu_fifo.tx.control.tuser_src[2:0]  |
|  6  |tuser_bypass_stage|   r  | 0x0 |csr.cpu_fifo.tx.control.tuser_bypass_stage|
|  7  | tuser_bypass_all |   r  | 0x0 | csr.cpu_fifo.tx.control.tuser_bypass_all |
|  15 |       tlast      |   r  | 0x0 |       csr.cpu_fifo.tx.control.tlast      |
|31:16|       tkeep      |   r  | 0x0 |    csr.cpu_fifo.tx.control.tkeep[15:0]   |

#### tuser_dst field

<p>Internal destination address (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4, 7 - broadcast)</p>

#### tuser_src field

<p>Internal source address (0 - CPU, 1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4)</p>

#### tuser_bypass_stage field

<p>If active, last stage of the DPE was bypassed</p>

#### tuser_bypass_all field

<p>If active, DPE was bypassed</p>

#### tlast field

<p>Indicates boundary of a packet, i.e. active on last transfer</p>

#### tkeep field

<p>Byte-enable for TDATA (e.g. TKEEP[15] corresponds to TDATA[127:119])</p>

### trigger register

- Absolute Address: 0x20000030
- Base Offset: 0x14
- Size: 0x4

<p>Tx FIFO Trigger Register</p>

|Bits|Identifier|Access|Reset|             Name             |
|----|----------|------|-----|------------------------------|
|  0 |  tready  |  rw  | 0x0 |csr.cpu_fifo.tx.trigger.tready|

#### tready field

<p>Indicates that the CPU can accept a transfer</p>

### status register

- Absolute Address: 0x20000034
- Base Offset: 0x18
- Size: 0x4

<p>Tx FIFO Status Register</p>

|Bits|Identifier|Access|Reset|             Name            |
|----|----------|------|-----|-----------------------------|
|  0 |  tvalid  |   r  | 0x0 |csr.cpu_fifo.tx.status.tvalid|

#### tvalid field

<p>Indicates valid transfer from the Tx FIFO to the CPU</p>

## uart register file

- Absolute Address: 0x20000038
- Base Offset: 0x38
- Size: 0x10

<p>UART CSR</p>

|Offset|Identifier|        Name       |
|------|----------|-------------------|
|  0x0 |    rx    |    csr.uart.rx    |
|  0x4 |rx_trigger|csr.uart.rx_trigger|
|  0x8 |    tx    |    csr.uart.tx    |
|  0xC |tx_trigger|csr.uart.tx_trigger|

### rx register

- Absolute Address: 0x20000038
- Base Offset: 0x0
- Size: 0x4

<p>UART Rx Register</p>

|Bits|Identifier|Access|Reset|         Name        |
|----|----------|------|-----|---------------------|
| 7:0|   data   |   r  | 0x0 |csr.uart.rx.data[7:0]|
| 30 |   oflow  |   r  | 0x0 |  csr.uart.rx.oflow  |
| 31 |   valid  |   r  | 0x0 |  csr.uart.rx.valid  |

#### data field

<p>Received data</p>

#### oflow field

<p>Indicates that some data bytes are lost</p>

#### valid field

<p>Indicates valid data transfer from the UART to the CPU</p>

### rx_trigger register

- Absolute Address: 0x2000003C
- Base Offset: 0x4
- Size: 0x4

<p>UART Rx Trigger Register</p>

|Bits|Identifier|Access|Reset|          Name          |
|----|----------|------|-----|------------------------|
|  0 |   read   |  rw  | 0x0 |csr.uart.rx_trigger.read|

#### read field

<p>Indicates that the CPU can accept next data transfer, used internally - don't try to read or write!</p>

### tx register

- Absolute Address: 0x20000040
- Base Offset: 0x8
- Size: 0x4

<p>UART Tx Register</p>

|Bits|Identifier|Access|Reset|         Name        |
|----|----------|------|-----|---------------------|
| 7:0|   data   |  rw  | 0x0 |csr.uart.tx.data[7:0]|
| 31 |   busy   |   r  | 0x0 |   csr.uart.tx.busy  |

#### data field

<p>Data to send</p>

#### busy field

<p>Indicates that UART cannot accept next data transfer</p>

### tx_trigger register

- Absolute Address: 0x20000044
- Base Offset: 0xC
- Size: 0x4

<p>UART Tx Trigger Register</p>

|Bits|Identifier|Access|Reset|           Name          |
|----|----------|------|-----|-------------------------|
|  0 |   write  |  rw  | 0x0 |csr.uart.tx_trigger.write|

#### write field

<p>Indicates valid data transfer from the CPU to the UART, used internally - don't try to read or write!</p>

### gpio register

- Absolute Address: 0x20000048
- Base Offset: 0x48
- Size: 0x4

<p>GPIO Register</p>

|Bits|Identifier|Access|Reset|     Name    |
|----|----------|------|-----|-------------|
|  0 |   key1   |   r  | 0x0 |csr.gpio.key1|
|  1 |   key2   |   r  | 0x0 |csr.gpio.key2|
|  8 |   led1   |  rw  | 0x0 |csr.gpio.led1|
|  9 |   led2   |  rw  | 0x0 |csr.gpio.led2|

#### key1 field

<p>Input from KEY1 (0 - not pressed, 1 - pressed)</p>

#### key2 field

<p>Input from KEY2 (0 - not pressed, 1 - pressed)</p>

#### led1 field

<p>Output to LED1 (0 - off, 1 - on)</p>

#### led2 field

<p>Output to LED2 (0 - off, 1 - on)</p>

## ethernet register file

- Absolute Address: 0x2000004C
- Base Offset: 0x4C
- Size: 0xC
- Array Dimensions: [4]
- Array Stride: 0xC
- Total Size: 0x30

<p>Ethernet CSR</p>

|Offset|Identifier|            Name            |
|------|----------|----------------------------|
|  0x0 |  status  |  csr.ethernet[0..3].status |
|  0x4 | mac_47_32|csr.ethernet[0..3].mac_47_32|
|  0x8 | mac_31_0 | csr.ethernet[0..3].mac_31_0|

### status register

- Absolute Address: 0x2000004C
- Base Offset: 0x0
- Size: 0x4

<p>Ethernet Status Register</p>

|Bits|Identifier|Access|Reset|                Name                |
|----|----------|------|-----|------------------------------------|
| 1:0|   speed  |   r  | 0x0 |csr.ethernet[0..3].status.speed[1:0]|

#### speed field

<p>Indicates the established link speed on a particular Ethernet interface (0 - 10 Mbps, 1 - 100 Mbps, 2 - 1000 Mbps)</p>

### mac_47_32 register

- Absolute Address: 0x20000050
- Base Offset: 0x4
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|15:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_47_32.mac[15:0]|

#### mac field

<p>Ethernet Interface MAC Address (upper word)</p>

### mac_31_0 register

- Absolute Address: 0x20000054
- Base Offset: 0x8
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_31_0.mac[31:0]|

#### mac field

<p>Ethernet Interface MAC Address (lower word)</p>

## ethernet register file

- Absolute Address: 0x20000058
- Base Offset: 0x4C
- Size: 0xC
- Array Dimensions: [4]
- Array Stride: 0xC
- Total Size: 0x30

<p>Ethernet CSR</p>

|Offset|Identifier|            Name            |
|------|----------|----------------------------|
|  0x0 |  status  |  csr.ethernet[0..3].status |
|  0x4 | mac_47_32|csr.ethernet[0..3].mac_47_32|
|  0x8 | mac_31_0 | csr.ethernet[0..3].mac_31_0|

### status register

- Absolute Address: 0x20000058
- Base Offset: 0x0
- Size: 0x4

<p>Ethernet Status Register</p>

|Bits|Identifier|Access|Reset|                Name                |
|----|----------|------|-----|------------------------------------|
| 1:0|   speed  |   r  | 0x0 |csr.ethernet[0..3].status.speed[1:0]|

#### speed field

<p>Indicates the established link speed on a particular Ethernet interface (0 - 10 Mbps, 1 - 100 Mbps, 2 - 1000 Mbps)</p>

### mac_47_32 register

- Absolute Address: 0x2000005C
- Base Offset: 0x4
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|15:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_47_32.mac[15:0]|

#### mac field

<p>Ethernet Interface MAC Address (upper word)</p>

### mac_31_0 register

- Absolute Address: 0x20000060
- Base Offset: 0x8
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_31_0.mac[31:0]|

#### mac field

<p>Ethernet Interface MAC Address (lower word)</p>

## ethernet register file

- Absolute Address: 0x20000064
- Base Offset: 0x4C
- Size: 0xC
- Array Dimensions: [4]
- Array Stride: 0xC
- Total Size: 0x30

<p>Ethernet CSR</p>

|Offset|Identifier|            Name            |
|------|----------|----------------------------|
|  0x0 |  status  |  csr.ethernet[0..3].status |
|  0x4 | mac_47_32|csr.ethernet[0..3].mac_47_32|
|  0x8 | mac_31_0 | csr.ethernet[0..3].mac_31_0|

### status register

- Absolute Address: 0x20000064
- Base Offset: 0x0
- Size: 0x4

<p>Ethernet Status Register</p>

|Bits|Identifier|Access|Reset|                Name                |
|----|----------|------|-----|------------------------------------|
| 1:0|   speed  |   r  | 0x0 |csr.ethernet[0..3].status.speed[1:0]|

#### speed field

<p>Indicates the established link speed on a particular Ethernet interface (0 - 10 Mbps, 1 - 100 Mbps, 2 - 1000 Mbps)</p>

### mac_47_32 register

- Absolute Address: 0x20000068
- Base Offset: 0x4
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|15:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_47_32.mac[15:0]|

#### mac field

<p>Ethernet Interface MAC Address (upper word)</p>

### mac_31_0 register

- Absolute Address: 0x2000006C
- Base Offset: 0x8
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_31_0.mac[31:0]|

#### mac field

<p>Ethernet Interface MAC Address (lower word)</p>

## ethernet register file

- Absolute Address: 0x20000070
- Base Offset: 0x4C
- Size: 0xC
- Array Dimensions: [4]
- Array Stride: 0xC
- Total Size: 0x30

<p>Ethernet CSR</p>

|Offset|Identifier|            Name            |
|------|----------|----------------------------|
|  0x0 |  status  |  csr.ethernet[0..3].status |
|  0x4 | mac_47_32|csr.ethernet[0..3].mac_47_32|
|  0x8 | mac_31_0 | csr.ethernet[0..3].mac_31_0|

### status register

- Absolute Address: 0x20000070
- Base Offset: 0x0
- Size: 0x4

<p>Ethernet Status Register</p>

|Bits|Identifier|Access|Reset|                Name                |
|----|----------|------|-----|------------------------------------|
| 1:0|   speed  |   r  | 0x0 |csr.ethernet[0..3].status.speed[1:0]|

#### speed field

<p>Indicates the established link speed on a particular Ethernet interface (0 - 10 Mbps, 1 - 100 Mbps, 2 - 1000 Mbps)</p>

### mac_47_32 register

- Absolute Address: 0x20000074
- Base Offset: 0x4
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                 |
|----|----------|------|-----|--------------------------------------|
|15:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_47_32.mac[15:0]|

#### mac field

<p>Ethernet Interface MAC Address (upper word)</p>

### mac_31_0 register

- Absolute Address: 0x20000078
- Base Offset: 0x8
- Size: 0x4

<p>Ethernet Interface MAC Address</p>

|Bits|Identifier|Access|Reset|                 Name                |
|----|----------|------|-----|-------------------------------------|
|31:0|    mac   |  rw  | 0x0 |csr.ethernet[0..3].mac_31_0.mac[31:0]|

#### mac field

<p>Ethernet Interface MAC Address (lower word)</p>

## dpe register file

- Absolute Address: 0x2000007C
- Base Offset: 0x7C
- Size: 0x4

<p>Data Plane Engine CSR</p>

|Offset|Identifier|    Name   |
|------|----------|-----------|
|  0x0 |    fcr   |csr.dpe.fcr|

### fcr register

- Absolute Address: 0x2000007C
- Base Offset: 0x0
- Size: 0x4

<p>DPE Flow Control Register</p>

|Bits|Identifier|Access|Reset|       Name      |
|----|----------|------|-----|-----------------|
|  0 |   idle   |   r  | 0x0 | csr.dpe.fcr.idle|
|  1 |   pause  |  rw  | 0x0 |csr.dpe.fcr.pause|

#### idle field

<p>Indicates that all stages of DPE have been succesfully paused</p>

#### pause field

<p>Pauses DPE</p>

### hw_id register

- Absolute Address: 0x20000080
- Base Offset: 0x80
- Size: 0x4

<p>Hardware IDs</p>

| Bits|Identifier|Access| Reset|       Name      |
|-----|----------|------|------|-----------------|
| 15:0|  PRODUCT |   r  |0xCACA|csr.hw_id.PRODUCT|
|31:16|  VENDOR  |   r  |0xCCAE| csr.hw_id.VENDOR|

#### PRODUCT field

<p>Product ID</p>

#### VENDOR field

<p>Vendor ID</p>

### hw_version register

- Absolute Address: 0x20000084
- Base Offset: 0x84
- Size: 0x4

<p>Hardware Version</p>

| Bits|Identifier|Access|Reset|        Name        |
|-----|----------|------|-----|--------------------|
| 15:0|   PATCH  |   r  | 0x0 |csr.hw_version.PATCH|
|23:16|   MINOR  |   r  | 0x2 |csr.hw_version.MINOR|
|31:24|   MAJOR  |   r  | 0x0 |csr.hw_version.MAJOR|

#### PATCH field

<p>Patch version</p>

#### MINOR field

<p>Minor version</p>

#### MAJOR field

<p>Major version</p>
