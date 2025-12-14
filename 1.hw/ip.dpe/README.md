# Egress IP Lookup Engine

The Egress IP Lookup Engine is part of the data-plane pipeline. Its primary function is to perform routing table lookups based on the destination IPv4 address and to augment packet metadata before forwarding the packet to the next pipeline stage. The routing table is configured and updated by the control-plane CPU through a CSR interface.

## TCAM-Based Forwarding Table Lookup

The forwarding table is implemented using a TCAM-like structure to support longest prefix match (LPM) routing for IPv4 addresses. Tree-based lookup tables typically require multiple clock cycles to compare a packet’s destination IP address against all entries. While such approaches scale well to large routing tables, they introduce additional latency and control complexity.

In the target deployment environments for this WireGuard implementation, the routing table is expected to contain at most 64 entries. This makes a parallel CAM-based approach practical and efficient. All routing entries are compared in parallel during a lookup operation, and the first matching entry is selected. Although TCAM-style designs tend to have higher power consumption and longer critical paths than tree-based lookups, these trade-offs are acceptable at this scale.

To implement LPM correctly, routing entries must be ordered by prefix length in descending order. This ordering is performed by the control-plane CPU during routing table updates via the CSR interface, ensuring that the first match corresponds to the longest prefix.

### Route Memory Implementation

The module `dpe_route_mem.sv` implements the TCAM table. For each entry `k`, a hit signal `hit_vec[k]` is asserted when:
```
(req_ip & cam_mask[k]) == (cam_prefix[k] & cam_mask[k])
```
The entries are scanned in ascending index order, and the first matching index is selected as `best_idx`. Because the table is pre-sorted by prefix length in descending order, this selection logic yields the correct longest prefix match.

### Top-Level Module: dpe_egress_ip_lookup

The top-level module `dpe_egress_ip_lookup` instantiates `dpe_route_mem` and coordinates control-plane configuration with data-plane packet processing. Its responsibilities include:
- CSR Interface (Control Plane): decodes incoming transactions (`hwif_out`) to determine which routing table entry is being accessed. Read responses and acknowledgements are returned on `hwif_in`.
- Packet Buffering: Incoming packets arrive on an AXI-Stream interface (`s_axis`). The IPv4 destination address spans the second and third 128-bit beats of the packet header. To support store-and-forward operation and decouple header parsing from routing decisions, the module uses a small circular buffer. This allows packet data to continue streaming while the routing lookup is performed.
- Metadata Assignment: On the outgoing AXI-Stream interface (`m_axis`), the module sets `m_axis.tuser_dst`, `m_axis.tid`, and `m_axis.tuser_bypass_stage` based on the routing table lookup result. This ensures that the selected forwarding path and peer association are applied consistently to all beats of the packet.

### Lookup Table Format:
The lookup table contains ENTRY_COUNT entries (default: 64). Each entry consists of:
- Prefix: 32 bits
- Mask: 32 bits
- Peer ID: 8 bits
- Destination port: 3 bits

Previously explained concepts are depicted in the image:
<img width="1193" height="203" alt="image" src="https://github.com/user-attachments/assets/f559e3b9-e642-424d-a66c-2d44e0d010b7" />
