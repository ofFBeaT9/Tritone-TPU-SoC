@echo off
REM Run Tritone TPU SoC through OpenROAD flow (ASAP7 7nm)
REM Usage: run_tritone_soc_asap7.bat [baseline|aggressive]
REM
REM Variants:
REM   baseline   - 1.0 GHz target (default, recommended)
REM   aggressive - 1.5 GHz target
REM
REM Date: Dec 2025

cd /d "%~dp0flow"

set VARIANT=%1
if "%VARIANT%"=="" set VARIANT=baseline

echo ============================================================
echo Tritone TPU SoC - ASAP7 Physical Implementation
echo ============================================================
echo Target: %VARIANT%
echo.

if "%VARIANT%"=="aggressive" (
    echo Running aggressive 1.5 GHz flow...
    make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=aggressive
) else (
    echo Running baseline 1.0 GHz flow...
    make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk
)

echo.
echo ============================================================
echo Flow complete! Check results in:
echo   flow\results\asap7\tritone_soc\
echo ============================================================
