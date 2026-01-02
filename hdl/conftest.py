import cocotb
from cocotb.regression import TestFactory
from cocotb.regression import Simulated
from cocotb.regression import Simulation
from cocotb.utils import get_sim_time

@pytest.fixture
def my_fixture():
    pass

@pytest.fixture(scope="module")
def setup():
    pass

def pytest_configure(config):
    config.addinivalue_line("markers", "cocotb: mark test as cocotb test")