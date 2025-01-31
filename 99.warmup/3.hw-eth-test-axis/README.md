# Ethernet Test

## Intro
In this exmaple we implemented only the 125MHz clock region shown in the image below:

![image](https://github.com/user-attachments/assets/d647326f-922c-4d82-84e8-e69c2912e2d0)

To make this happen we used "eth_mac_1g_gmii_fifo" from "https://github.com/alexforencich/verilog-ethernet".

## Block Diagram
Within this example, block diagram shown below was implemented:

![image](https://github.com/user-attachments/assets/e379fbe3-06a5-4f08-badf-f83566d377fa)

As you can see the output of Rx FIFO and the input of Tx FIFO are connected for testing purposes. When ping happens, message received and the message trasmitted are the same, which is shown in next section.

## Test Setup
Multiple test cases were done for all ports and different ethernet speeds.

### 1Gbps:

![image](https://github.com/user-attachments/assets/700bad9a-4135-483e-8f0d-9bbd201ed353)

![image](https://github.com/user-attachments/assets/cd4465df-9a35-4c2f-ad02-57de80147492)

![image](https://github.com/user-attachments/assets/7aa9871a-dbb9-4f33-b0d3-f0fee7b7cafd)

It can be seen that the received and trasmitted package are basically the same. The only difference is the padding added which is expected, because of the set parameters:

<pre>.ENABLE_PADDING(1), 
.MIN_FRAME_LENGTH(64)</pre>

One thing to mention, in Wireshark, 4 bytes of the frame aren't shown which is the CRC. So the frame really is 64 bytes

### 100Mbps:

Same can be see in this case:

![image](https://github.com/user-attachments/assets/b3baa308-c256-4c82-b5b7-bf679117556b)


### End-of-File
