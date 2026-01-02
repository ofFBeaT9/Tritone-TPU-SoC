#!/usr/bin/env python3
"""
Ternary Logic Unit Tests
Tests the mathematical properties of balanced ternary operations
"""

import pytest


def int_to_balanced_ternary(n: int, width: int) -> str:
    """Convert integer to balanced ternary string."""
    if n == 0:
        return '0' * width
    
    result = []
    is_negative = n < 0
    n = abs(n)
    
    while n > 0:
        remainder = n % 3
        if remainder == 0:
            result.append('0')
        elif remainder == 1:
            result.append('+')
        else:  # remainder == 2
            result.append('-')
            n += 1
        n //= 3
    
    # Pad to width
    while len(result) < width:
        result.append('0')
    
    # Truncate if too long
    result = result[:width]
    
    # If original was negative, negate the result
    if is_negative:
        result = ['-' if t == '+' else '+' if t == '-' else '0' for t in result]
    
    return ''.join(result)


def balanced_ternary_to_int(bt_str: str) -> int:
    """Convert balanced ternary string to integer."""
    power = 1
    result = 0
    for char in bt_str:
        if char == '+':
            result += power
        elif char == '-':
            result -= power
        power *= 3
    return result


def t_neg(trit: str) -> str:
    """Ternary negation (STI function)"""
    if trit == '+':
        return '-'
    elif trit == '-':
        return '+'
    return '0'


def t_min(a: str, b: str) -> str:
    """Ternary MIN (AND-like)"""
    if a == '-' or b == '-':
        return '-'
    if a == '0' or b == '0':
        return '0'
    return '+'


def t_max(a: str, b: str) -> str:
    """Ternary MAX (OR-like)"""
    if a == '+' or b == '+':
        return '+'
    if a == '0' or b == '0':
        return '0'
    return '-'


def t_add_trit(a: str, b: str, cin: str) -> tuple:
    """Add three trits, return (sum, carry)"""
    # Convert to integers
    vals = {'-': -1, '0': 0, '+': 1}
    inv = {-1: '-', 0: '0', 1: '+'}
    
    total = vals[a] + vals[b] + vals[cin]
    
    # Convert back to balanced ternary
    if total == -3:
        return ('0', '-')
    elif total == -2:
        return ('+', '-')
    elif total == -1:
        return ('-', '0')
    elif total == 0:
        return ('0', '0')
    elif total == 1:
        return ('+', '0')
    elif total == 2:
        return ('-', '+')
    elif total == 3:
        return ('0', '+')
    else:
        raise ValueError(f"Invalid sum: {total}")


class TestTritNegation:
    """Test ternary negation (STI)"""
    
    def test_neg_positive(self):
        assert t_neg('+') == '-'
    
    def test_neg_negative(self):
        assert t_neg('-') == '+'
    
    def test_neg_zero(self):
        assert t_neg('0') == '0'
    
    def test_double_negation(self):
        """Double negation should return original"""
        for trit in ['-', '0', '+']:
            assert t_neg(t_neg(trit)) == trit


class TestTritMin:
    """Test ternary MIN (AND-like)"""
    
    def test_min_truth_table(self):
        """Test complete MIN truth table"""
        # MIN returns the minimum of two trits
        assert t_min('-', '-') == '-'
        assert t_min('-', '0') == '-'
        assert t_min('-', '+') == '-'
        assert t_min('0', '-') == '-'
        assert t_min('0', '0') == '0'
        assert t_min('0', '+') == '0'
        assert t_min('+', '-') == '-'
        assert t_min('+', '0') == '0'
        assert t_min('+', '+') == '+'
    
    def test_min_commutative(self):
        """MIN should be commutative"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                assert t_min(a, b) == t_min(b, a)
    
    def test_min_associative(self):
        """MIN should be associative"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                for c in ['-', '0', '+']:
                    left = t_min(t_min(a, b), c)
                    right = t_min(a, t_min(b, c))
                    assert left == right


class TestTritMax:
    """Test ternary MAX (OR-like)"""
    
    def test_max_truth_table(self):
        """Test complete MAX truth table"""
        # MAX returns the maximum of two trits
        assert t_max('-', '-') == '-'
        assert t_max('-', '0') == '0'
        assert t_max('-', '+') == '+'
        assert t_max('0', '-') == '0'
        assert t_max('0', '0') == '0'
        assert t_max('0', '+') == '+'
        assert t_max('+', '-') == '+'
        assert t_max('+', '0') == '+'
        assert t_max('+', '+') == '+'
    
    def test_max_commutative(self):
        """MAX should be commutative"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                assert t_max(a, b) == t_max(b, a)
    
    def test_max_associative(self):
        """MAX should be associative"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                for c in ['-', '0', '+']:
                    left = t_max(t_max(a, b), c)
                    right = t_max(a, t_max(b, c))
                    assert left == right


class TestTritAddition:
    """Test single trit addition with carry"""
    
    def test_add_truth_table(self):
        """Test complete addition truth table (27 combinations)"""
        expected = {
            ('-', '-', '-'): ('0', '-'),   # -3 = 0 with carry -1
            ('-', '-', '0'): ('+', '-'),   # -2 = +1 with carry -1
            ('-', '-', '+'): ('-', '0'),   # -1
            ('-', '0', '-'): ('+', '-'),   # -2
            ('-', '0', '0'): ('-', '0'),   # -1
            ('-', '0', '+'): ('0', '0'),   # 0
            ('-', '+', '-'): ('-', '0'),   # -1
            ('-', '+', '0'): ('0', '0'),   # 0
            ('-', '+', '+'): ('+', '0'),   # 1
            ('0', '-', '-'): ('+', '-'),   # -2
            ('0', '-', '0'): ('-', '0'),   # -1
            ('0', '-', '+'): ('0', '0'),   # 0
            ('0', '0', '-'): ('-', '0'),   # -1
            ('0', '0', '0'): ('0', '0'),   # 0
            ('0', '0', '+'): ('+', '0'),   # 1
            ('0', '+', '-'): ('0', '0'),   # 0
            ('0', '+', '0'): ('+', '0'),   # 1
            ('0', '+', '+'): ('-', '+'),   # 2 = -1 with carry +1
            ('+', '-', '-'): ('-', '0'),   # -1
            ('+', '-', '0'): ('0', '0'),   # 0
            ('+', '-', '+'): ('+', '0'),   # 1
            ('+', '0', '-'): ('0', '0'),   # 0
            ('+', '0', '0'): ('+', '0'),   # 1
            ('+', '0', '+'): ('-', '+'),   # 2
            ('+', '+', '-'): ('+', '0'),   # 1
            ('+', '+', '0'): ('-', '+'),   # 2
            ('+', '+', '+'): ('0', '+'),   # 3 = 0 with carry +1
        }
        
        for (a, b, c), (exp_sum, exp_cout) in expected.items():
            result = t_add_trit(a, b, c)
            assert result == (exp_sum, exp_cout), \
                f"Failed for {a}+{b}+{c}: expected {(exp_sum, exp_cout)}, got {result}"
    
    def test_add_commutative(self):
        """Addition should be commutative in all three inputs"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                for c in ['-', '0', '+']:
                    r1 = t_add_trit(a, b, c)
                    r2 = t_add_trit(b, a, c)
                    r3 = t_add_trit(c, b, a)
                    assert r1 == r2 == r3


class TestBalancedTernaryConversion:
    """Test balanced ternary number conversion"""
    
    def test_single_digit_values(self):
        """Test single-digit values (−1, 0, +1)"""
        assert balanced_ternary_to_int('-') == -1
        assert balanced_ternary_to_int('0') == 0
        assert balanced_ternary_to_int('+') == 1
    
    def test_two_digit_values(self):
        """Test two-digit values"""
        # In balanced ternary (LSB first), 2-digit numbers range from -4 to +4
        # Position 0 = units (3^0), Position 1 = threes (3^1)
        assert balanced_ternary_to_int('--') == -4  # -1 - 3 = -4
        assert balanced_ternary_to_int('0-') == -3  # 0 - 3 = -3
        assert balanced_ternary_to_int('+-') == -2  # 1 - 3 = -2
        assert balanced_ternary_to_int('-0') == -1  # -1 + 0 = -1
        assert balanced_ternary_to_int('00') == 0
        assert balanced_ternary_to_int('+0') == 1   # 1 + 0 = 1
        assert balanced_ternary_to_int('-+') == 2   # -1 + 3 = 2
        assert balanced_ternary_to_int('0+') == 3   # 0 + 3 = 3
        assert balanced_ternary_to_int('++') == 4   # 1 + 3 = 4
    
    def test_roundtrip_conversion(self):
        """Converting to/from balanced ternary should preserve value"""
        for val in range(-100, 101):
            bt = int_to_balanced_ternary(val, 8)
            back = balanced_ternary_to_int(bt)
            assert back == val, f"Roundtrip failed for {val}: bt='{bt}', back={back}"
    
    def test_27_trit_range(self):
        """27-trit balanced ternary can represent huge range"""
        # 27 trits can represent values from -(3^27-1)/2 to +(3^27-1)/2
        # That's roughly ±3.7 trillion
        max_val = (3**27 - 1) // 2
        assert max_val == 3812798742493  # Verify the math
        
        # Test some boundary values
        bt = int_to_balanced_ternary(1000000, 27)
        back = balanced_ternary_to_int(bt)
        assert back == 1000000
        
        bt = int_to_balanced_ternary(-1000000, 27)
        back = balanced_ternary_to_int(bt)
        assert back == -1000000


class TestTernaryArithmetic:
    """Test multi-trit arithmetic operations"""
    
    def add_balanced_ternary(self, a: str, b: str) -> str:
        """Add two balanced ternary numbers"""
        # Ensure same length
        max_len = max(len(a), len(b))
        a = a.ljust(max_len, '0')
        b = b.ljust(max_len, '0')
        
        result = []
        carry = '0'
        
        for i in range(max_len):
            trit_sum, carry = t_add_trit(a[i], b[i], carry)
            result.append(trit_sum)
        
        if carry != '0':
            result.append(carry)
        
        return ''.join(result)
    
    def test_addition_basic(self):
        """Test basic addition"""
        # 1 + 1 = 2
        result = self.add_balanced_ternary('+', '+')
        assert balanced_ternary_to_int(result) == 2
        
        # 1 + (-1) = 0
        result = self.add_balanced_ternary('+', '-')
        assert balanced_ternary_to_int(result) == 0
        
        # 3 + 4 = 7
        a = int_to_balanced_ternary(3, 4)
        b = int_to_balanced_ternary(4, 4)
        result = self.add_balanced_ternary(a, b)
        assert balanced_ternary_to_int(result) == 7
    
    def test_addition_many_values(self):
        """Test addition of many value pairs"""
        for x in range(-20, 21):
            for y in range(-20, 21):
                a = int_to_balanced_ternary(x, 8)
                b = int_to_balanced_ternary(y, 8)
                result = self.add_balanced_ternary(a, b)
                expected = x + y
                actual = balanced_ternary_to_int(result)
                assert actual == expected, \
                    f"Addition failed: {x} + {y} = {expected}, got {actual}"


class TestTernaryVsBinary:
    """Compare ternary and binary representations"""
    
    def test_information_density(self):
        """Balanced ternary should be more information-dense"""
        # In n trits, we can represent 3^n values
        # In n bits, we can represent 2^n values
        # For same number of symbols:
        # 8 bits = 256 values
        # 8 trits = 6561 values (25.6x more!)
        
        assert 3**8 == 6561
        assert 2**8 == 256
        assert 3**8 / 2**8 > 25
    
    def test_sign_representation(self):
        """Balanced ternary handles signs naturally"""
        # In balanced ternary, negation is just swapping + and -
        for val in range(-50, 51):
            bt_pos = int_to_balanced_ternary(val, 8)
            bt_neg = int_to_balanced_ternary(-val, 8)
            
            # Negation should swap + and -
            expected_neg = ''.join(
                '-' if t == '+' else '+' if t == '-' else '0'
                for t in bt_pos
            )
            assert bt_neg == expected_neg, \
                f"Negation failed for {val}: {bt_pos} -> {bt_neg} (expected {expected_neg})"


class TestDeMorganLaws:
    """Test De Morgan's laws for ternary logic"""
    
    def test_demorgan_min_max(self):
        """De Morgan: NOT(MIN(a,b)) = MAX(NOT(a), NOT(b))"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                left = t_neg(t_min(a, b))
                right = t_max(t_neg(a), t_neg(b))
                assert left == right, \
                    f"De Morgan MIN failed for ({a}, {b}): {left} != {right}"
    
    def test_demorgan_max_min(self):
        """De Morgan: NOT(MAX(a,b)) = MIN(NOT(a), NOT(b))"""
        for a in ['-', '0', '+']:
            for b in ['-', '0', '+']:
                left = t_neg(t_max(a, b))
                right = t_min(t_neg(a), t_neg(b))
                assert left == right, \
                    f"De Morgan MAX failed for ({a}, {b}): {left} != {right}"


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
