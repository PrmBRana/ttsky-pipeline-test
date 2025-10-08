import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

def safe_int(sig, default=0):
    try:
        return int(sig.value)
    except (ValueError, TypeError):
        return default

async def reset(dut, cycles=2):
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, cycles)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

@cocotb.test()
async def test_all(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    prev_pc = safe_int(dut.PC_OUT)

    cocotb.log.info("Cycle |   PC   | DATA_MEM_OUT ")
    cocotb.log.info("-" * 40)

    for cycle in range(40):
        await RisingEdge(dut.clk)
        pc = safe_int(dut.PC_OUT)
        mem_out = safe_int(dut.DATA_MEM_OUT_TOP)

        cocotb.log.info(f"{cycle:02d} | {pc:06d} | {mem_out:010d}")

        expected_pc = prev_pc + 4
        if pc != expected_pc:
            cocotb.log.warning(
                f"[Cycle {cycle}] PC not incrementing correctly: got {pc}, expected {expected_pc}"
            )
        prev_pc = pc

    cocotb.log.info("Simulation finished successfully.")
