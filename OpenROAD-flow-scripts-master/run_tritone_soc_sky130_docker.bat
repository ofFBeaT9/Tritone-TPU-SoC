@echo off
REM ============================================================
REM Tritone TPU SoC - Docker OpenROAD Flow (Sky130HD)
REM ============================================================
REM Usage: run_tritone_soc_sky130_docker.bat [baseline|aggressive]
REM
REM Variants:
REM   baseline   - 150 MHz target (default, recommended for 130nm)
REM   aggressive - 200 MHz target (aggressive for 130nm)
REM
REM Note: Sky130 is a mature 130nm process node and cannot achieve
REM       the frequencies possible on ASAP7 (7nm). Maximum practical
REM       frequency is typically 150-200 MHz for complex designs.
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
echo Tritone TPU SoC - Sky130HD Physical Implementation via Docker
echo ============================================================
echo Target Variant: %VARIANT%
echo Docker Image:   %DOCKER_IMAGE%
echo Mount Path:     %MOUNT_PATH%
echo.

if "%VARIANT%"=="baseline" (
    echo Running baseline 150 MHz flow...
    set CLOCK_TARGET=6667 ps ^(150 MHz^)
) else if "%VARIANT%"=="aggressive" (
    echo Running aggressive 200 MHz flow...
    echo WARNING: 200 MHz is aggressive for 130nm; expect potential timing violations
    set CLOCK_TARGET=5000 ps ^(200 MHz^)
) else (
    echo ERROR: Unknown variant '%VARIANT%'
    echo Valid options: baseline, aggressive
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
    make DESIGN_CONFIG=designs/sky130hd/tritone_soc/config.mk FLOW_VARIANT=%VARIANT%

echo.
echo ============================================================
echo Flow Complete!
echo ============================================================
echo.
echo Results directory: flow\results\sky130hd\tritone_soc\
echo.
echo Key output files:
echo   - 6_final.gds    : Final layout
echo   - 6_final.def    : Final DEF
echo   - 6_final.v      : Final netlist
echo.

endlocal
