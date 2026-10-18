"""One elaboration-time selection for both Poly1305 setup/finalization services."""
import wireguard_env
from stream.stream_auto_fsm import make_stream_auto_fsm
from stream.stream_multi_cycle import make_stream_auto_multi_cycle


def make_compute_service(func, name):
    """The same stream contract; FSM compute is capped at 64 cycles.

    compute_tag.latency excludes the wrapper's one result/handshake cycle in
    both modes. FIFO sizing and measurement use that common convention.
    """
    if wireguard_env.POLY1305_COMPUTE_IMPL == "fsm":
        service = make_stream_auto_fsm(func, max_latency=64)
        service.compute_tag = service.fsm
    else:
        service = make_stream_auto_multi_cycle(func, name=name)
        service.compute_tag = service.mcp
    return service
