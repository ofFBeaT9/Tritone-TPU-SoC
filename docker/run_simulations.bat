@echo off
REM ============================================================================
REM SKY130 BSIM4 Multi-Vth STI Simulation Runner (Windows)
REM ============================================================================
REM Builds Docker image and runs full PVT characterization
REM ============================================================================

echo ============================================
echo SKY130 BSIM4 Multi-Vth STI Characterization
echo ============================================
echo.

REM Check for Docker
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker not found. Please install Docker Desktop.
    echo https://www.docker.com/products/docker-desktop
    exit /b 1
)

echo Step 1: Building Docker image...
docker build -t tritone-spice .
if %errorlevel% neq 0 (
    echo ERROR: Docker build failed
    exit /b 1
)

echo.
echo Step 2: Creating results directory...
if not exist "..\spice\results" mkdir ..\spice\results

echo.
echo Step 3: Running TT corner simulation...
docker run --rm -v "%cd%\..":/tritone tritone-spice /bin/bash -c "cd /tritone/spice && mkdir -p results && ngspice -b testbenches/tb_sti_multivth_bsim4.spice 2>&1 | tee results/sim_tt.log"

echo.
echo Step 4: Running all process corners...
docker run --rm -v "%cd%\..":/tritone tritone-spice /bin/bash -c "cd /tritone/spice && ngspice -b testbenches/tb_sti_multicorner_bsim4.spice 2>&1 | tee results/sim_multicorner.log"

echo.
echo ============================================
echo Simulation Complete!
echo ============================================
echo Results saved to: ..\spice\results\
echo.
echo Key files:
echo   - sim_tt.log         : TT corner full results
echo   - sim_multicorner.log: All corners summary
echo   - dc_*.dat           : DC transfer data
echo.
pause
