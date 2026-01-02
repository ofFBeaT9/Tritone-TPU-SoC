@echo off
REM Ternary CPU Simulation Script for Windows
REM Uses Icarus Verilog (iverilog) and VVP

echo ==========================================
echo Balanced Ternary CPU Simulation
echo ==========================================

set RTL_DIR=..\rtl
set TB_DIR=..\tb
set OUT_DIR=.\output

REM Create output directory if it doesn't exist
if not exist %OUT_DIR% mkdir %OUT_DIR%

echo.
echo Compiling RTL and Testbench...
echo.

REM Compile with Icarus Verilog (SystemVerilog 2012)
iverilog -g2012 -o %OUT_DIR%\cpu_sim.vvp ^
    -DSIMULATION ^
    %RTL_DIR%\ternary_pkg.sv ^
    %RTL_DIR%\btfa.sv ^
    %RTL_DIR%\ternary_adder.sv ^
    %RTL_DIR%\ternary_alu.sv ^
    %RTL_DIR%\btisa_decoder.sv ^
    %RTL_DIR%\ternary_regfile.sv ^
    %RTL_DIR%\ternary_cpu.sv ^
    %TB_DIR%\tb_ternary_cpu.sv

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** Compilation FAILED ***
    exit /b 1
)

echo Compilation successful!
echo.
echo Running simulation...
echo.

REM Run the simulation
vvp %OUT_DIR%\cpu_sim.vvp

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** Simulation FAILED ***
    exit /b 1
)

echo.
echo ==========================================
echo Simulation Complete!
echo ==========================================
