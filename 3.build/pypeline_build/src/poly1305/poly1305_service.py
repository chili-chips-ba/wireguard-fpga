"""One elaboration-time selection for both Poly1305 setup/finalization services."""
import functools
import wireguard_env
from stream.stream_auto_fsm import make_stream_auto_fsm
from stream.stream_multi_cycle import make_stream_auto_multi_cycle


@functools.lru_cache(maxsize=None)
def make_compute_service(func, name, phase):
    """The same stream contract for the prologue or epilogue service. One
    service per (kernel, name, phase): every caller instantiates the same
    definition, and each instance keeps its own state.

    FSM compute is capped at POLY1305_PROLOGUE_MAX_LATENCY cycles for the
    prologue and POLY1305_EPILOGUE_MAX_LATENCY for the epilogue. compute_tag.latency
    excludes the wrapper's one result/handshake cycle in both modes. FIFO
    sizing and measurement use that common convention.
    """
    if phase not in ("prologue", "epilogue"):
        raise ValueError(f"Poly1305 compute phase must be prologue or epilogue, got {phase!r}")
    if wireguard_env.POLY1305_COMPUTE_IMPL == "fsm":
        cap = (wireguard_env.POLY1305_PROLOGUE_MAX_LATENCY if phase == "prologue"
               else wireguard_env.POLY1305_EPILOGUE_MAX_LATENCY)
        service = make_stream_auto_fsm(func, max_latency=cap)
        service.compute_tag = service.fsm
    else:
        service = make_stream_auto_multi_cycle(func, name=name)
        service.compute_tag = service.mcp
    return service
