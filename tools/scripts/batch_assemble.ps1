# ============================================================================
# Batch Assembler - Assemble all test programs
# ============================================================================
# Assembles all .btasm files and outputs to a standardized format.
#
# Usage: .\batch_assemble.ps1
#        .\batch_assemble.ps1 -OutputFormat mem     # Memory init files
#        .\batch_assemble.ps1 -OutputFormat sv      # SystemVerilog snippets
#        .\batch_assemble.ps1 -OutputFormat both    # Both formats
# ============================================================================

param(
    [ValidateSet("mem", "sv", "both")]
    [string]$OutputFormat = "both",
    
    [string]$OutputDir = "$PSScriptRoot\..\..\hdl\sim\programs",
    [switch]$ShowDetails
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ToolsDir = "$ProjectRoot\tools"
$ProgramsDir = "$ToolsDir\programs"

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "=== BTISA Batch Assembler" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Source:  $ProgramsDir"
Write-Host "Output:  $OutputDir"
Write-Host "Format:  $OutputFormat"
Write-Host ""

$files = Get-ChildItem "$ProgramsDir\*.btasm"
$successCount = 0
$failCount = 0

foreach ($file in $files) {
    $name = $file.BaseName
    
    try {
        $output = & python "$ToolsDir\btisa_assembler.py" $file.FullName 2>&1
        
        if ($OutputFormat -eq "mem" -or $OutputFormat -eq "both") {
            $memFile = "$OutputDir\$name.mem"
            $output | Out-File -FilePath $memFile -Encoding UTF8
        }
        
        if ($OutputFormat -eq "sv" -or $OutputFormat -eq "both") {
            $svFile = "$OutputDir\$name.sv"
            $svLines = $output | Where-Object { $_ -match "^imem\[" }
            $svContent = @"
// Auto-generated from: $name.btasm
// Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
// Instruction count: $($svLines.Count)

initial begin
$($svLines | ForEach-Object { "    $_" } | Out-String)end
"@
            $svContent | Out-File -FilePath $svFile -Encoding UTF8
        }
        
        Write-Host "[OK] $name" -ForegroundColor Green
        $successCount++
        
        if ($ShowDetails) {
            $instrCount = ($output | Where-Object { $_ -match "^imem\[" }).Count
            Write-Host "     $instrCount instructions" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[FAIL] $name - $_" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Success: $successCount  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Yellow" } else { "Green" })
Write-Host "============================================" -ForegroundColor Cyan

if ($failCount -gt 0) { exit 1 }
