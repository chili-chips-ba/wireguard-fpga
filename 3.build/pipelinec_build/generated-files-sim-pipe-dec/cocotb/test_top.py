
import cocotb
from cocotb.triggers import Timer

from pipelinec_cocotb import * # Generated

@cocotb.test()
async def my_first_test(dut):
    """Try accessing the design."""
    # Do first cycle print a little different
    # to work around 'metavalue detected' warnings from ieee libs
    cycle = 0
    print("Clock: ", cycle, flush=True)
    DUMP_PIPELINEC_DEBUG(dut)
    dut.clk_80p0.value = 1
    await Timer(6.250, units="ns")
    print("^End Clock: ", cycle, flush=True)
    for i in range(249):
        dut.clk_80p0.value = 0
        await Timer(6.250, units="ns")
        print("")
        print("Clock: ", i+1, flush=True)
        DUMP_PIPELINEC_DEBUG(dut)
        dut.clk_80p0.value = 1
        await Timer(6.250, units="ns")
