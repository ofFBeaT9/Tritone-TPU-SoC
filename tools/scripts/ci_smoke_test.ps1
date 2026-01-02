# ============================================================================
# CI Smoke Test - Quick validation of project integrity
# ============================================================================
# Runs essential checks that should pass on any properly configured machine:
#   1. Assembler syntax check on all .btasm files
#   2. RTL compile check (iverilog)
#   3. Quick simulation run
#
# Usage: .\ci_smoke_test.ps1
#        .\ci_smoke_test.ps1 -SkipSim   # Skip simulation (compile only)
#        .\ci_smoke_test.ps1 -ShowDetails   # Show detailed output
# ============================================================================

param(
    [switch]$SkipSim,
    [switch]$ShowDetails,
    [switch]$StopOnError
)

$ErrorActionPreference = if ($StopOnError) { "Stop" } else { "Continue" }
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$StartTime = Get-Date

# Results tracking
$script:PassCount = 0
$script:FailCount = 0
$script:SkipCount = 0

$IverilogBinFallback = "C:\\iverilog\\bin"

function Ensure-IcarusVerilog {
    if (-not (Get-Command iverilog -ErrorAction SilentlyContinue) -or -not (Get-Command vvp -ErrorAction SilentlyContinue)) {
        if (Test-Path "$IverilogBinFallback\\iverilog.exe") {
            $env:PATH = "$IverilogBinFallback;$env:PATH"
        }
    }
}

function Write-TestSkip {
    param([string]$Test, [string]$Reason = "")
    Write-Host "[SKIP] " -NoNewline -ForegroundColor Yellow
    $script:SkipCount++
    Write-Host $Test
    if ($Reason -and $ShowDetails) {
        Write-Host "       $Reason" -ForegroundColor Gray
    }
}

function Write-TestResult {
    param([string]$Test, [bool]$Passed, [string]$Details = "")
    
    if ($Passed) {
        Write-Host "[PASS] " -NoNewline -ForegroundColor Green
        $script:PassCount++
    } else {
        Write-Host "[FAIL] " -NoNewline -ForegroundColor Red
        $script:FailCount++
    }
    Write-Host $Test
    if ($Details -and $ShowDetails) {
        Write-Host "       $Details" -ForegroundColor Gray
    }
}

function Write-Section {
    param([string]$Title)
    Write-Host "`n============================================" -ForegroundColor Cyan
    Write-Host "=== $Title" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
}

# ============================================================================
# Section 1: Tool Availability
# ============================================================================
Write-Section "Tool Availability"

Ensure-IcarusVerilog

# Check Python
$pythonVersion = try { & python --version 2>&1 } catch { "" }
Write-TestResult "Python available" ($pythonVersion -match "Python 3") $pythonVersion

# Check Icarus Verilog
$iverilogVersion = try { & iverilog -V 2>&1 | Select-Object -First 1 } catch { "" }
if ($iverilogVersion -match "Icarus") {
    Write-TestResult "Icarus Verilog available" $true $iverilogVersion
} elseif ($SkipSim) {
    Write-TestSkip "Icarus Verilog available" "Not found (ok for -SkipSim). If installed in C:\\iverilog, scripts will auto-detect it."
} else {
    Write-TestResult "Icarus Verilog available" $false $iverilogVersion
}

# ============================================================================
# Section 2: Assembler Tests
# ============================================================================
Write-Section "Assembler Validation"

$programsDir = "$ProjectRoot\tools\programs"
$asmFiles = Get-ChildItem "$programsDir\*.btasm" -ErrorAction SilentlyContinue

foreach ($file in $asmFiles) {
    try {
        $output = & python "$ProjectRoot\tools\btisa_assembler.py" $file.FullName 2>&1
        $success = $LASTEXITCODE -eq 0 -or $output -match "imem\["
        Write-TestResult "Assemble $($file.Name)" $success
    }
    catch {
        Write-TestResult "Assemble $($file.Name)" $false $_.Exception.Message
    }
}

# ============================================================================
# Section 3: RTL Compile Tests
# ============================================================================
Write-Section "RTL Compilation"

if (-not ($iverilogVersion -match "Icarus")) {
    Write-Host "[SKIP] RTL tests skipped - iverilog not found" -ForegroundColor Yellow
    $script:SkipCount += 3
} else {
    $rtlDir = "$ProjectRoot\hdl\rtl"
    $tbDir = "$ProjectRoot\hdl\tb"
    $outDir = "$ProjectRoot\hdl\sim\output"
    
    if (-not (Test-Path $outDir)) {
        New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }
    
    # Test 1: Core package compilation
    # Packages alone don't produce a runnable output; compile with a tiny dummy top.
    try {
        $vvp = "$outDir\smoke_pkg.vvp"
        $dummyTop = "$outDir\smoke_pkg_dummy.sv"
        @"
module smoke_pkg_dummy;
  import ternary_pkg::*;
endmodule
"@ | Set-Content -Path $dummyTop -Encoding ASCII

        & iverilog -g2012 -o $vvp -s smoke_pkg_dummy `
            "$rtlDir\ternary_pkg.sv" `
            $dummyTop 2>&1 | Out-Null
        Write-TestResult "Compile ternary_pkg.sv" ($LASTEXITCODE -eq 0)
        Remove-Item $vvp -ErrorAction SilentlyContinue
        Remove-Item $dummyTop -ErrorAction SilentlyContinue
    }
    catch {
        Write-TestResult "Compile ternary_pkg.sv" $false
        Remove-Item "$outDir\smoke_pkg_dummy.sv" -ErrorAction SilentlyContinue
    }
    
    # Test 2: ALU compilation
    try {
        $vvp = "$outDir\smoke_alu.vvp"
        & iverilog -g2012 -o $vvp `
            "$rtlDir\ternary_pkg.sv" `
            "$rtlDir\btfa.sv" `
            "$rtlDir\ternary_adder.sv" `
            "$rtlDir\ternary_alu.sv" 2>&1 | Out-Null
        Write-TestResult "Compile ALU hierarchy" ($LASTEXITCODE -eq 0)
        Remove-Item $vvp -ErrorAction SilentlyContinue
    }
    catch {
        Write-TestResult "Compile ALU hierarchy" $false
    }
    
    # Test 3: Full CPU compilation
    try {
        $vvp = "$outDir\smoke_cpu.vvp"
        & iverilog -g2012 -DSIMULATION -o $vvp `
            "$rtlDir\ternary_pkg.sv" `
            "$rtlDir\btfa.sv" `
            "$rtlDir\ternary_adder.sv" `
            "$rtlDir\ternary_alu.sv" `
            "$rtlDir\btisa_decoder.sv" `
            "$rtlDir\ternary_regfile.sv" `
            "$rtlDir\ternary_hazard_unit.sv" `
            "$rtlDir\ternary_forward_unit.sv" `
            "$rtlDir\ternary_memory.sv" `
            "$rtlDir\ternary_cpu.sv" `
            "$tbDir\tb_ternary_cpu.sv" 2>&1 | Out-Null
        Write-TestResult "Compile full CPU + testbench" ($LASTEXITCODE -eq 0)
    }
    catch {
        Write-TestResult "Compile full CPU + testbench" $false
    }
    
    # ============================================================================
    # Section 4: Simulation Test
    # ============================================================================
    if (-not $SkipSim) {
        Write-Section "Simulation Test"
        
        $vvp = "$outDir\smoke_cpu.vvp"
        if (Test-Path $vvp) {
            try {
                $simOutput = & vvp $vvp 2>&1
                $passed = $simOutput -match "\[PASS\]" -or $simOutput -match "Test Complete"
                $failed = $simOutput -match "\[FAIL\]"
                
                Write-TestResult "CPU simulation runs" (-not $failed -and $passed)
                
                if ($ShowDetails) {
                    $simOutput | Where-Object { $_ -match "===|PASS|FAIL|CPI" } | ForEach-Object {
                        Write-Host "       $_" -ForegroundColor Gray
                    }
                }
            }
            catch {
                Write-TestResult "CPU simulation runs" $false
            }
        } else {
            Write-Host "[SKIP] Simulation skipped - compilation failed" -ForegroundColor Yellow
            $script:SkipCount++
        }
        
        # Cleanup
        Remove-Item $vvp -ErrorAction SilentlyContinue
    }
}

# ============================================================================
# Summary
# ============================================================================
$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Section "Summary"
Write-Host "Passed:  $script:PassCount" -ForegroundColor Green
Write-Host "Failed:  $script:FailCount" -ForegroundColor $(if ($script:FailCount -gt 0) { "Red" } else { "Gray" })
Write-Host "Skipped: $script:SkipCount" -ForegroundColor Yellow
Write-Host "Time:    $($Duration.TotalSeconds.ToString('F1'))s"

if ($script:FailCount -gt 0) {
    Write-Host "`n*** SMOKE TEST FAILED ***" -ForegroundColor Red
    exit 1
} else {
    Write-Host "`n*** SMOKE TEST PASSED ***" -ForegroundColor Green
    exit 0
}

