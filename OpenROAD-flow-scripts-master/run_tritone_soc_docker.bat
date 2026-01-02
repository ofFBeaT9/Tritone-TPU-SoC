@echo off
REM ============================================================
REM Tritone TPU SoC - Docker OpenROAD Flow (ASAP7)
REM ============================================================
REM Usage: run_tritone_soc_docker.bat [baseline|aggressive|maxperf]
REM
REM Variants:
REM   baseline   - 1.0 GHz target (default, recommended)
REM   aggressive - 1.5 GHz target
REM   maxperf    - 2.0 GHz target (requires pipelined MAC)
REM
REM Date: Jan 2026
REM ============================================================

setlocal EnableDelayedExpansion

set VARIANT=%1
if "%VARIANT%"=="" set VARIANT=baseline

set DOCKER_IMAGE=openroad/orfs:latest
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Convert Windows path to Docker-friendly format
set MOUNT_PATH=%SCRIPT_DIR:\=/%
set MOUNT_PATH=/%MOUNT_PATH::=%

echo ============================================================
echo Tritone TPU SoC - ASAP7 Physical Implementation via Docker
echo ============================================================
echo Target Variant: %VARIANT%
echo Docker Image:   %DOCKER_IMAGE%
echo Mount Path:     %MOUNT_PATH%
echo.

if "%VARIANT%"=="baseline" (
    echo Running baseline 1.0 GHz flow...
    set CLOCK_TARGET=1000 ps ^(1.0 GHz^)
) else if "%VARIANT%"=="aggressive" (
    echo Running aggressive 1.5 GHz flow...
    set CLOCK_TARGET=667 ps ^(1.5 GHz^)
) else if "%VARIANT%"=="maxperf" (
    echo Running maximum performance 2.0 GHz flow...
    echo NOTE: Using USE_2GHZ_PIPELINE for pipelined MAC
    set CLOCK_TARGET=500 ps ^(2.0 GHz^)
) else (
    echo ERROR: Unknown variant '%VARIANT%'
    echo Valid options: baseline, aggressive, maxperf
    exit /b 1
)

echo Clock Period: %CLOCK_TARGET%
echo.

REM Pull latest image if not available
echo Checking Docker image...
docker pull %DOCKER_IMAGE% 2>nul

echo.
echo Starting OpenROAD synthesis and P&R...
echo ============================================================

set MSYS_NO_PATHCONV=1
docker run --rm -it ^
    -v "%MOUNT_PATH%":/work ^
    -w /work/flow ^
    %DOCKER_IMAGE% ^
    make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=%VARIANT%

echo.
echo ============================================================
echo Flow Complete!
echo ============================================================
echo.
echo Results directory: flow\results\asap7\tritone_soc\
echo.
echo Key output files:
echo   - 6_final.gds    : Final layout
echo   - 6_final.def    : Final DEF
echo   - 6_final.v      : Final netlist
echo.

endlocal
