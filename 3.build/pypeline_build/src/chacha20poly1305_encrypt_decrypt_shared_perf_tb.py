# pyright: reportInvalidTypeForm=none
# SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

"""PERFORMANCE measurement top for the shared encrypt+decrypt design: both
perf testbenches stream concurrently against the design sharing one ChaCha20
compute pipeline -- the configuration whose (fmax, area, throughput, latency)
this repo actually cares about.

Both directions are held in the same phase by perf_probe.PhaseBarrier, so every
measured packet size sees the same contention on the shared pipeline. Results
are written incrementally to $WG_PERF_JSON (see perf_tb_common.py) and merged
with the synthesis fmax/area numbers by ../measure.py.

Build/sim (from pypeline_build/): ./build.py --shared --perf
"""
import sys, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wireguard_env  # noqa: F401

from pypeline import MAIN, PART, final, sim_finish, sim_output, sim_print, wires

PART("xc7a200tffg1156-2")  # Artix 7 200T

# Hardware modules are discovered transitively through each other's own
# imports; only the modules not otherwise reachable need listing here.
import encrypt_dataflow_shared  # noqa: F401
import decrypt_dataflow_shared  # noqa: F401

# Both perf testbenches at once -- importing both is what registers both
# directions with perf_tb_common's barrier/recorder.
import encrypt_perf_tb  # noqa: F401
import decrypt_perf_tb  # noqa: F401
import perf_tb_common as perf


@sim_output
def check_all_done():
    if perf.all_done():
        sim_finish()


@final(sim=True)
def write_results():
    # Every phase result was already written when that phase drained; this
    # only adds the run-level totals. A run that ended early (an error, or a
    # --run N cutoff) keeps "finalized": false in its JSON.
    if not perf.all_done():
        sim_print("PERF: simulation ended before every phase finished -- "
                  f"{perf.JSON_PATH or '(no WG_PERF_JSON set)'} left unfinalized")
        return
    perf.finalize()
    for line in perf.summary_line():
        sim_print("PERF: " + line)
    sim_print(f"PERF: wrote {perf.JSON_PATH or '(no WG_PERF_JSON set)'}")


# @wires: nothing here to synthesize/measure a path delay for -- see
# chacha20poly1305_encrypt_syn_tb.py's matching checker comment.
@MAIN
@wires
def shared_perf_tb_finish_checker():
    check_all_done()
