import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import Simulated
from cocotb.regression import TestCase
from cocotb.regression import run
from cocotb.regression import coroutine
from cocotb.regression import Simulation

@cocotb.coroutine
def test_ternary_adder(dut):
    # Test cases for the ternary adder
    dut.a <= 0
    dut.b <= 0
    dut.c <= 0
    yield cocotb.start_soon(Simulation(dut))
    assert dut.result == 0

    dut.a <= 1
    dut.b <= 1
    dut.c <= 1
    yield cocotb.start_soon(Simulation(dut))
    assert dut.result == 3

    dut.a <= 2
    dut.b <= 2
    dut.c <= 2
    yield cocotb.start_soon(Simulation(dut))
    assert dut.result == 6

tf = TestFactory(test_ternary_adder)
tf.generate_tests()