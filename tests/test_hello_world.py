"""
Hello World Test - Basic smoke test for pytest infrastructure
"""

import pytest


def test_hello_world():
    """Basic sanity check"""
    assert 1 + 1 == 2


def test_pytest_markers():
    """Verify pytest infrastructure is working"""
    assert True


def test_import_system():
    """Verify Python imports work correctly"""
    import sys
    import os
    assert sys.version_info >= (3, 8), "Python 3.8+ required"