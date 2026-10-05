"""Import only the selected MAC; selection creates no hardware mux."""
import wireguard_env  # noqa: F401
from poly1305_config import selected_implementation

IMPLEMENTATION = selected_implementation()
_instances = {}

if IMPLEMENTATION == "pipelined":
    from poly1305_mac_pipelined import make_poly1305_mac_pipelined
else:
    import poly1305


def make_poly1305_mac(direction, share_mcp=False):
    if direction not in ("encrypt", "decrypt"):
        raise ValueError("Invalid Poly1305 direction")
    if share_mcp and IMPLEMENTATION != "pipelined":
        raise ValueError("Only pipelined Poly1305 has shareable prologue/epilogue MCPs")
    if direction in _instances and bool(share_mcp) != getattr(_instances[direction], "shared_mcps", False):
        raise ValueError("Cannot mix private and shared MACs for one direction in a top")
    if direction not in _instances:
        if IMPLEMENTATION == "pipelined":
            _instances[direction] = make_poly1305_mac_pipelined(direction, share_mcp=share_mcp)
        else:
            _instances[direction] = poly1305.poly1305_mac_instance
    return _instances[direction]


def implementation_metadata():
    result = {"implementation": IMPLEMENTATION, "directions": {},
              "arithmetic": "residue130" if IMPLEMENTATION == "pipelined" else "limb320-corrected"}
    if any(getattr(mac, "shared_mcps", False) for mac in _instances.values()):
        from poly1305_mcp_shared import CAPACITY, prologue_arbiter, epilogue_arbiter
        result["shared_mcps"] = {
            "capacity_lanes": CAPACITY,
            "prologue_mcp_latency": prologue_arbiter.mcp.latency,
            "epilogue_mcp_latency": epilogue_arbiter.mcp.latency,
        }
    for direction, mac in _instances.items():
        if IMPLEMENTATION == "pipelined":
            result["directions"][direction] = {
                "body_core_latency": mac.body_auto_pipeline.latency,
                "body_latency": mac.body_auto_pipeline.latency + 2,
                "accumulator_count": mac.accumulator_count,
                "body_ii": 1,
                "shared_mcps": mac.shared_mcps,
                "prologue_mcp_latency": mac.prologue_mcp.mcp.latency,
                "epilogue_mcp_latency": mac.epilogue_mcp.mcp.latency,
                "prologue_response_cycles": mac.prologue_mcp.mcp.latency + 1,
                "epilogue_response_cycles": mac.epilogue_mcp.mcp.latency + 1,
            }
        else:
            result["directions"][direction] = {
                "body_ii": poly1305.compute_mcp.mcp.latency + 1,
                "body_mcp_latency": poly1305.compute_mcp.mcp.latency,
                "accumulator_count": 1,
            }
    return result
