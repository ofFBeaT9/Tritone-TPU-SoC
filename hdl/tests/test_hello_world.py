import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import Simulated

@cocotb.coroutine
def hello_world_test(dut):
    assert True

tf = TestFactory(hello_world_test)