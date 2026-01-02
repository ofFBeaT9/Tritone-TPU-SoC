@echo off
REM Ternary HDL Simulation Script for Windows
REM Requires Icarus Verilog (iverilog) or compatible simulator

setlocal enabledelayedexpansion

REM Set paths
set SCRIPT_DIR=%~dp0
set RTL_DIR=%SCRIPT_DIR%..\rtl
set TB_DIR=%SCRIPT_DIR%..\tb
set OUT_DIR=%SCRIPT_DIR%output

REM Create output directory
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

echo ==========================================
echo Ternary HDL Simulation
echo ==========================================
echo.

if "%1"=="" (
    REM Run all tests
    echo Running all testbenches...
    echo.

    call :run_test btfa tb_btfa.sv
    call :run_test ternary_adder tb_ternary_adder.sv
    call :run_test ternary_alu tb_ternary_alu.sv

    echo ==========================================
    echo All simulations complete!
    echo Logs saved to: %OUT_DIR%
    echo ==========================================
) else (
    REM Run specific test
    if "%1"=="btfa" (
        call :run_test btfa tb_btfa.sv
    ) else if "%1"=="adder" (
        call :run_test ternary_adder tb_ternary_adder.sv
    ) else if "%1"=="alu" (
        call :run_test ternary_alu tb_ternary_alu.sv
    ) else (
        echo Unknown test: %1
        echo Available tests: btfa, adder, alu
        exit /b 1
    )
)

exit /b 0

:run_test
set TB_NAME=%1
set TB_FILE=%2

echo --- Running %TB_NAME% ---

REM Compile with Icarus Verilog
iverilog -g2012 -o "%OUT_DIR%\%TB_NAME%.vvp" ^
    "%RTL_DIR%\ternary_pkg.sv" ^
    "%RTL_DIR%\btfa.sv" ^
    "%RTL_DIR%\ternary_adder.sv" ^
    "%RTL_DIR%\ternary_alu.sv" ^
    "%TB_DIR%\%TB_FILE%"

if %ERRORLEVEL% equ 0 (
    echo Compilation successful.
    echo Running simulation...
    vvp "%OUT_DIR%\%TB_NAME%.vvp"
    echo.
) else (
    echo Compilation failed!
)

exit /b 0
