## Software Architecture and Theory of Operation
![SWArchitecture](../0.doc/Wireguard/wireguard-fpga-muxed-Architecture-SW.webp)

The conceptual class diagram provides an overview of the components in the software part of the system without delving into implementation details. The focus is on the Wireguard Agent, which implements the protocol's handshake procedures, along with the following supplementary components:
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
- CLI - a USB/UART-based command-line interface for configuring the Wireguard node (setting the local IP address, remote peer IP addresses, network addresses, keys, etc.)
- HAL/CSR Driver - a CSR-based abstraction for DPE components with an interface for reading/writing the corresponding registers

## Software Control Flow
### Sending and receiving packets
The DPE and CPU are connected through Rx and Tx FIFOs. Here, the Tx and Rx labels are relative to the DPE, not the CPU, meaning CPU → Rx FIFO → DPE and DPE → Tx FIFO → CPU. To ensure efficient communication, we maintained the same data bus width (128 bits) on both sides of the FIFO. The Rx and Tx FIFOs are mapped to the CPU by directly mapping AXIS signals to CSR. Since the CPU operates on a 32-bit data bus, all CSR registers had to be organized as 32-bit registers. Additionally, to prevent the CPU from entering Read-Modify-Write (RMW) cycles, which would reduce the interface throughput, all register fields had to be [aligned to 8 bits](https://github.com/chili-chips-ba/wireguard-fpga/issues/9).

It is important to note that triggering a data transfer cycle on the AXIS interface is achieved using [single-pulse](https://peakrdl-regblock.readthedocs.io/en/latest/props/field.html#singlepulse) TVALID/TREADY signals. This frees the CPU from the requirement to synchronize the AXIS clock cycle with its instruction cycle. 

Here is the process of sending a packet from the CPU to the ETH interface. The packet is divided into 16-byte segments, and for each segment:
- The CPU reads csr.cpu_fifo.rx.status.tready; if it equals 1, it proceeds (since the FIFO is set to drop-on-full mode, tready will always be 1).
- The CPU writes csr.cpu_fifo.rx.data_31_0.tdata.
- The CPU writes csr.cpu_fifo.rx.data_63_32.tdata.
- The CPU writes csr.cpu_fifo.rx.data_95_64.tdata.
- The CPU writes csr.cpu_fifo.rx.data_127_96.tdata.
- The CPU writes csr.cpu_fifo.rx.control.tkeep (all ones, except in the last transfer).
- The CPU writes csr.cpu_fifo.rx.control.tlast (0, except in the last transfer).
- The CPU writes csr.cpu_fifo.rx.control.tuser_bypass_all = 1.
- The CPU writes csr.cpu_fifo.rx.control.tuser_dst (1 - eth1, 2 - eth2, 3 - eth3, 4 - eth4, 7 - broadcast).
- The CPU writes csr.cpu_fifo.rx.trigger.tvalid = 1.
- If tlast == 0, return to step (1).

A similar process applies to receiving packets from the ETH interface. The CPU prepares a buffer and starts reading 16-byte segments from the Tx FIFO:
1. The CPU reads csr.cpu_fifo.tx.status.tvalid; if it equals 1, it proceeds (if it is 0, it stops since the FIFO is set to store-and-forward mode).
2. The CPU reads csr.cpu_fifo.tx.status.tvalid.data_31_0.tdata.
3. The CPU reads csr.cpu_fifo.tx.status.tvalid.data_63_32.tdata.
4. The CPU reads csr.cpu_fifo.tx.status.tvalid.data_95_64.tdata.
5. The CPU reads csr.cpu_fifo.tx.status.tvalid.data_127_96.tdata.
6. The CPU reads csr.cpu_fifo.tx.status.tvalid.control.tlast; if it is 1, proceed to step (7), otherwise go to step (9).
7. The CPU reads csr.cpu_fifo.tx.status.tvalid.control.tkeep.
8. The CPU reads csr.cpu_fifo.tx.status.tvalid.control.tuser_src.
9. The CPU writes csr.cpu_fifo.tx.status.tvalid.trigger.tready = 1.
10. If tlast == 0, return to step (1).

If we assume that each step takes 1-2 instructions on average (1.5 on average) and that each instruction requires 4 clock cycles, we can estimate the throughput: 80 MHz × 128 bits ÷ (10 steps × 1.5 instructions × 4 cycles per instruction) = 170 Mbps. Clearly, this CSR-based FIFO interface cannot be used to implement a 1G datapath through the CPU, but since the CPU will only process WireGuard handshake messages, this will be more than sufficient.

### Updating DPE registers and tables
During the initial Wireguard handshake and subsequent periodic key rotations,  the control plane must update the cryptokey routing table implemented in register memory within the CSR. Since the CSR manages the operation of the DPE, such changes must be made atomically to prevent unpredictable behavior in the DPE. One way to achieve this is by using [Write-Buffered Registers](https://peakrdl-regblock.readthedocs.io/en/latest/udps/write_buffering.html) (WBR). However, implementing 1 bit of WBR  memory requires three flip-flops: one to store the current value, one to hold the future value, and one for the write-enable signal. Therefore, we consider an alternative mechanism for atomic CSR updates based on flow control between the CPU and the DPE. Suppose the CPU needs to update the contents of a routing table implemented using many registers. Before starting the update, the CPU must pause packet processing within the DPE. However, such a pause cannot be implemented using the inherent stall mechanism supported by the AXI protocol (by deactivating the TREADY signal at the end of the pipeline), as a packet that has already entered the DPE must be processed according to the rules in effect at the time of its entry. We introduce a graceful flow control mechanism coordinated through a dedicated Flow Control Register (FCR) to address this.

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-CSR-Flow-Control.webp)

The atomic CSR update mechanism works as follows:
1. When the CPU needs to update the routing table, it asserts the PAUSE signal by writing to the FCR register (i.e. csr.dpe.fcr.pause = 1).
2. The active csr.dpe.fcr.pause signal instructs the input multiplexer to transition into the PAUSED state after completing the servicing of the current queue. The CPU periodically checks the ready bits in the FCR register.
3. Once the first component finishes processing its packet and clears its datapath, it deactivates the TVALID signal and transitions to the IDLE state. The CPU continues to check the ready bits in the FCR register.
4. The processing of remaining packets and datapath clearing continues until all components transition to the IDLE state. The CPU monitors the ready bits in the FCR register, which now indicates that the DPE has been successfully paused (i.e. csr.dpe.fcr.idle == 1).
5. The CPU updates the necessary registers (e.g., the routing table) over multiple cycles.
6. Upon completing the updates, the CPU deactivates the PAUSE signal (i.e. csr.dpe.fcr.pause = 0).
7. The multiplexer returns to its default operation mode and begins accepting packets from the next queue in a round-robin fashion.
8. As packets start arriving, all components within the DPE gradually transition back to their active states.

![ExampleToplogy](../0.doc/Wireguard/wireguard-fpga-muxed-CSR-Flow-Control-Animated.gif)