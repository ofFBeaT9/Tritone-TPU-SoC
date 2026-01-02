# Performance Analysis Script
# Analyzes CPU simulation output to calculate CPI and other metrics

param(
    [Parameter(Mandatory=$true)]
    [string]$LogFile
)

if (-not (Test-Path $LogFile)) {
    Write-Host "Error: Log file not found: $LogFile" -ForegroundColor Red
    exit 1
}

$content = Get-Content $LogFile

# Extract metrics
$cycles = ($content | Select-String -Pattern "\[Cycle (\d+)\]" | Measure-Object).Count
$instructions = ($content | Select-String -Pattern "Valid=1" | Measure-Object).Count  
$stalls = ($content | Select-String -Pattern "Stall=1" | Measure-Object).Count
$forwards = ($content | Select-String -Pattern "Fwd=1" | Measure-Object).Count

# Calculate CPI
if ($instructions -gt 0) {
    $cpi = [math]::Round($cycles / $instructions, 3)
    $ipc = [math]::Round($instructions / $cycles, 3)
} else {
    $cpi = 0
    $ipc = 0
}

# Display results
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "=== Performance Analysis ===" -ForegroundColor Cyan  
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Log File:           $LogFile"
Write-Host "Total Cycles:       $cycles"
Write-Host "Instructions:       $instructions"  
Write-Host "Stall Cycles:       $stalls ($([math]::Round(100.0 * $stalls / $cycles, 1))%)"
Write-Host "Forward Events:     $forwards"
Write-Host "CPI:                $cpi" -ForegroundColor Yellow
Write-Host "IPC:                $ipc" -ForegroundColor Yellow
Write-Host "===========================================`n" -ForegroundColor Cyan

# Return metrics as object
[PSCustomObject]@{
    LogFile = $LogFile
    Cycles = $cycles
    Instructions = $instructions
    Stalls = $stalls
    Forwards = $forwards
    CPI = $cpi
    IPC = $ipc
}
