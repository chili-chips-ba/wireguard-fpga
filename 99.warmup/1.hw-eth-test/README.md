# Ethernet Test

## Intro

This example is about achieving data communication between FPGA and PC, using 1Gbps Ethernet UDP communication protocol.

The FPGA talks to the Realtek RT8211EG PHY chip over RGMII interface. The PHY in turns sends data to the PC via RJ45 connector and Unshielded Twisted Pair (UTP) cable.

The example implements ARP, UDP and PING functions, as well as 100/1000Mbps self-adaptation.

## Block Diagram

<img src="0.doc/Ethernet-Test.png">

## Test Setup

We tested 2 parts of the system, ICMP (ping) and UDP (data transfer). For this we've connected the development board with the PC via ethernet cable and ethenet-to-usb adapter. The whole system is shown below.

// image

On the software side, you will need Wireshark to capture the traffic between PC and the board. But before that, one must configure the ethernet adapter and it's subnet to "192.168.0.3" and "255.255.255.0" (this was specified in the RTL). The IP address of the board will be "192.168.0.2". This is shown on the image below.

## Test Demo

The thing we tested is "pinging" or ICMP protocol, and the results are shown below:

![image](https://github.com/user-attachments/assets/21b3c026-c47a-4259-9a01-0d28373e4cf6)

The next functionality is UDP transfer, which we captured with Wireshark. The data we send every second is set in **mac_test.v** file:

![image](https://github.com/user-attachments/assets/3ccc78de-2be0-42fd-a8a3-c5d31528eef7)

Wireshark traffic capture is shown below:

![image](https://github.com/user-attachments/assets/42ca2b36-c787-4329-9b96-9b1bae84660f)


## Resource Utilization

As you can see, not much of the FPGAs resources are used, so this gives us the opportunity to develop much more complex systems that are based on this one.

![image](https://github.com/user-attachments/assets/74bc6c1b-eef4-4327-8197-2215d80f13e2)


### End-of-File
