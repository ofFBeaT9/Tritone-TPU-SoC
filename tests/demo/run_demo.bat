@echo off
REM Tritone CPU Demo - Windows
REM Run from project root directory

echo === Tritone CPU Demo ===
echo.

REM Step 1: Assemble
echo [1/3] Assembling counter.btasm...
python tools\btisa_assembler.py tests\demo\counter.btasm -o tests\demo\counter.mem
if errorlevel 1 (
    echo ERROR: Assembly failed
    exit /b 1
)
echo Assembly complete.
echo.

REM Step 2: Simulate
echo [2/3] Running simulation...
cd hdl
iverilog -g2012 -o demo.vvp ^
    rtl\ternary_pkg.sv ^
    rtl\btfa.sv ^
    rtl\ternary_adder.sv ^
    rtl\ternary_alu.sv ^
    rtl\ternary_regfile.sv ^
    rtl\btisa_decoder.sv ^
    rtl\ternary_hazard_unit.sv ^
    rtl\ternary_forward_unit.sv ^
    rtl\ternary_memory.sv ^
    rtl\ternary_cpu.sv ^
    rtl\ternary_cpu_system.sv ^
    tb\tb_ternary_cpu.sv

if errorlevel 1 (
    echo ERROR: Compilation failed
    cd ..
    exit /b 1
)

vvp demo.vvp
cd ..
echo.

REM Step 3: Report
echo [3/3] Verification
echo Expected: R1=5, R2=5, halted=1
echo See simulation output above for actual values.
echo.
echo === Demo Complete ===
