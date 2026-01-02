@echo off
REM Tritone v8 CLA - ASAP7 Docker Build Script (Windows)
REM Runs OpenROAD-flow-scripts in Docker container
REM Date: Dec 2025

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set RESULTS_DIR=%SCRIPT_DIR%..\asic_results

echo ==========================================
echo  Tritone v8 CLA - ASAP7 7nm Flow
echo  Docker-based OpenROAD Build (Windows)
echo ==========================================

REM Check Docker
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker not found. Please install Docker Desktop.
    exit /b 1
)

REM Parse arguments
set VARIANT=%1
if "%VARIANT%"=="" set VARIANT=aggressive

set JOBS=%2
if "%JOBS%"=="" set JOBS=4

if "%VARIANT%"=="aggressive" goto :aggressive
if "%VARIANT%"=="1.5ghz" goto :aggressive
if "%VARIANT%"=="1500mhz" goto :aggressive
if "%VARIANT%"=="baseline" goto :baseline
if "%VARIANT%"=="1ghz" goto :baseline
if "%VARIANT%"=="1000mhz" goto :baseline
if "%VARIANT%"=="both" goto :both
if "%VARIANT%"=="all" goto :both
goto :usage

:aggressive
set FLOW_VARIANT=
set TARGET_FREQ=1.5 GHz
set RUN_NAME=tritone_v8_asap7_1500mhz
goto :run

:baseline
set FLOW_VARIANT=baseline
set TARGET_FREQ=1.0 GHz
set RUN_NAME=tritone_v8_asap7_1000mhz
goto :run

:both
echo Running both variants...
call %0 baseline %JOBS%
call %0 aggressive %JOBS%
exit /b 0

:usage
echo Usage: %0 [aggressive^|baseline^|both] [jobs]
echo.
echo Variants:
echo   aggressive (default): 1.5 GHz target
echo   baseline:             1.0 GHz target
echo   both:                 Run both variants
echo.
echo Example: %0 aggressive 8
exit /b 1

:run
echo.
echo Configuration:
echo   Target Frequency: %TARGET_FREQ%
echo   Flow Variant:     %FLOW_VARIANT%
echo   Parallel Jobs:    %JOBS%
echo   Output:           %RESULTS_DIR%\%RUN_NAME%
echo.

REM Create results directory
if not exist "%RESULTS_DIR%\%RUN_NAME%" mkdir "%RESULTS_DIR%\%RUN_NAME%"

REM Convert Windows path to Docker path
set DOCKER_SCRIPT_DIR=%SCRIPT_DIR:\=/%
set DOCKER_SCRIPT_DIR=%DOCKER_SCRIPT_DIR:E:=/e%
set DOCKER_RESULTS_DIR=%RESULTS_DIR:\=/%
set DOCKER_RESULTS_DIR=%DOCKER_RESULTS_DIR:E:=/e%

echo Starting Docker build...

REM Build make command
if "%FLOW_VARIANT%"=="" (
    set MAKE_CMD=make DESIGN_CONFIG=designs/asap7/tritone/config.mk -j%JOBS%
) else (
    set MAKE_CMD=make DESIGN_CONFIG=designs/asap7/tritone/config.mk FLOW_VARIANT=%FLOW_VARIANT% -j%JOBS%
)

REM Run Docker
docker run --rm ^
    -v "%DOCKER_SCRIPT_DIR%:/OpenROAD-flow-scripts" ^
    -v "%DOCKER_RESULTS_DIR%/%RUN_NAME%:/output" ^
    -w /OpenROAD-flow-scripts ^
    openroad/flow-ubuntu22.04-builder:latest ^
    bash -c "cd /OpenROAD-flow-scripts/flow && %MAKE_CMD% && cp -r results/asap7/tritone/* /output/ 2>/dev/null; cp -r logs/asap7/tritone/* /output/logs/ 2>/dev/null; exit 0"

echo.
echo ==========================================
echo  Build Complete
echo ==========================================
echo Results: %RESULTS_DIR%\%RUN_NAME%

endlocal
