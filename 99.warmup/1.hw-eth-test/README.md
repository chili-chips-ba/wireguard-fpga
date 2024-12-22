# Ethernet Test

## Intro

This example is about achieving data communication between FPGA and PC, using 1Gbps Ethernet UDP communication protocol.

The FPGA talks to the Realtek RT8211EG PHY chip over RGMII interface. The PHY in turns sends data to the PC via RJ45 connector and Unshielded Twisted Pair (UTP) cable.

The example implements ARP, UDP and PING functions, as well as 100/1000Mbps self-adaptation.

## Block Diagram

<img src="0.doc/Ethernet-Test.png">

## Test Setup

We tested 2 parts of the system, ICMP (ping) and UDP (data transfer). For this we've connected the development board with the PC via ethernet cable and ethenet-to-usb adapter. The whole system is shown below.

![test_setup](https://github.com/user-attachments/assets/fec3eaed-9548-4738-b4b5-737ad04b64d2)


On the software side, you will need Wireshark to capture the traffic between PC and the board. But before that, one must configure the ethernet adapter and it's subnet to "192.168.0.3" and "255.255.255.0" (this was specified in the RTL). The IP address of the board will be "192.168.0.2". 

The following instructions outline how to configure a static IPv4 address and subnet mask using Command Prompt.
1. **Check the interface name**  
   Execute the following command to display all network interfaces and identify the name of your Ethernet adapter:  
   
   ```cmd
   netsh interface show interface
   
  ![image](https://github.com/user-attachments/assets/5490da41-3b54-4e7e-a459-ccd91eabd7f0)

3. **Set the IP address and subnet mask**  
   Use the command below to assign the desired IP address and subnet mask to the identified interface:
   > **Note**: Use the Interface Name from step 1 for the parameter "name".
   ```cmd
   netsh interface ip set address name="Ethernet" static 192.168.0.3 255.255.255.0

5. **Verify the configuration**  
   Confirm that the IP address and subnet mask have been applied correctly by executing:
   ```cmd
   ipconfig

![image](https://github.com/user-attachments/assets/fab37967-7c10-4c58-ace0-a9640a6ad892)

## Test Demo

The thing we tested is "pinging" or ICMP protocol, and the results are shown below:

![image](https://github.com/user-attachments/assets/21b3c026-c47a-4259-9a01-0d28373e4cf6)

The next functionality is UDP transfer, which we captured with Wireshark. The data we send every second is set in **mac_test.v** file:

![image](https://github.com/user-attachments/assets/c3c6e4a7-284d-4623-b8c4-c8a903e18ed3)

Wireshark traffic capture is shown below:

![Screenshot_1](https://github.com/user-attachments/assets/1b0ce39a-aa31-4b65-b4a8-1cc091182876)


## Resource Utilization

As you can see, not much of the FPGAs resources are used, so this gives us the opportunity to develop much more complex systems that are based on this one.

![image](https://github.com/user-attachments/assets/74bc6c1b-eef4-4327-8197-2215d80f13e2)


### End-of-File
