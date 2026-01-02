# ============================================================================
# Ternary CPU Test Runner - Assemble + Run in One Command
# ============================================================================
# Usage: .\run_test.ps1 -Program test_arithmetic
#        .\run_test.ps1 -Program test_hazards -ShowDetails
#        .\run_test.ps1 -ListPrograms
# ============================================================================

param(
    [Parameter(Position=0)]
    [string]$Program,
    
    [switch]$ListPrograms,
    [switch]$ShowDetails,
    [switch]$KeepOutput,
    [string]$OutputDir = "$PSScriptRoot\..\..\hdl\sim\output"
)

$ErrorActionPreference = "Stop"
$IverilogBinFallback = "C:\\iverilog\\bin"

function Ensure-IcarusVerilog {
    if (-not (Get-Command iverilog -ErrorAction SilentlyContinue) -or -not (Get-Command vvp -ErrorAction SilentlyContinue)) {
        if (Test-Path "$IverilogBinFallback\\iverilog.exe") {
            $env:PATH = "$IverilogBinFallback;$env:PATH"
        }
    }
}

$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ToolsDir = "$ProjectRoot\tools"
$ProgramsDir = "$ToolsDir\programs"
$HdlDir = "$ProjectRoot\hdl"
$RtlDir = "$HdlDir\rtl"
$TbDir = "$HdlDir\tb"

# Colors
function Write-Success { param([string]$msg) Write-Host "[PASS] $msg" -ForegroundColor Green }
function Write-Failure { param([string]$msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }
function Write-Info { param([string]$msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Step { param([string]$msg) Write-Host "`n=== $msg ===" -ForegroundColor Yellow }

# List available programs
if ($ListPrograms) {
    Write-Step "Available Test Programs"
    Get-ChildItem "$ProgramsDir\*.btasm" | ForEach-Object {
        $name = $_.BaseName
        Write-Host "  - $name"
    }
    exit 0
}

# Validate program parameter
if (-not $Program) {
    Write-Host "Usage: .\run_test.ps1 -Program <name> [-ShowDetails] [-KeepOutput]"
    Write-Host "       .\run_test.ps1 -ListPrograms"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\run_test.ps1 -Program test_arithmetic"
    Write-Host "  .\run_test.ps1 -Program test_hazards -ShowDetails"
    exit 1
}

# Find program file
$programFile = "$ProgramsDir\$Program.btasm"
if (-not (Test-Path $programFile)) {
    $programFile = "$ProgramsDir\$Program.asm"
}
if (-not (Test-Path $programFile)) {
    Write-Failure "Program not found: $Program"
    Write-Host "Use -ListPrograms to see available programs"
    exit 1
}

Write-Step "Ternary CPU Test Runner"
Write-Info "Program: $Program"
Write-Info "Source: $programFile"

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Step 1: Assemble the program
Write-Step "Assembling Program"
$memFile = "$OutputDir\$Program.mem"
$assembleCmd = "python `"$ToolsDir\btisa_assembler.py`" `"$programFile`""
Write-Info "Command: $assembleCmd"

try {
    $assembleOutput = & python "$ToolsDir\btisa_assembler.py" $programFile 2>&1
    $assembleOutput | Out-File -FilePath $memFile -Encoding UTF8
    
    if ($ShowDetails) {
        Write-Host "`nAssembler Output:" -ForegroundColor Gray
        $assembleOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    }
    Write-Success "Assembly complete: $memFile"
}
catch {
    Write-Failure "Assembly failed: $_"
    exit 1
}

# Step 2: Generate testbench with embedded program
Write-Step "Generating Testbench"
$tbGenFile = "$OutputDir\tb_cpu_$Program.sv"

# Extract SV initialization lines from assembler output
$svLines = $assembleOutput | Where-Object { $_ -match "^imem\[\d+\]" }

# Generate a self-contained testbench that loads the assembled program.
# NOTE: Use single-quoted here-string to avoid PowerShell expanding $display, $time, etc.
$tbTemplate = @'
// Auto-generated CPU program testbench
// Program: __PROGRAM__
// Source:  __SOURCE__
// Generated: __GEN_DATE__

`timescale 1ns/1ps

module tb_ternary_cpu_program;
    import ternary_pkg::*;

    localparam int TRIT_WIDTH = 27;
    localparam int IMEM_DEPTH = 243;
    localparam int DMEM_DEPTH = 729;
    localparam int CLK_PERIOD = 10;

    logic clk;
    logic rst_n;

    // Instruction memory interface
    trit_t [7:0]            imem_addr;
    trit_t [8:0]            imem_data;

    // Data memory interface
    trit_t [8:0]            dmem_addr;
    trit_t [TRIT_WIDTH-1:0] dmem_wdata;
    trit_t [TRIT_WIDTH-1:0] dmem_rdata;
    logic                   dmem_we;
    logic                   dmem_re;

    // Status
    logic                   halted;
    trit_t [7:0]            pc_out;
    logic                   valid_out;

    // Debug ports
    logic [3:0]             dbg_reg_idx;
    trit_t [TRIT_WIDTH-1:0] dbg_reg_data;
    logic                   stall_out;
    logic                   fwd_a_out;
    logic                   fwd_b_out;

    // Memory arrays
    trit_t [8:0]            imem [IMEM_DEPTH];
    trit_t [TRIT_WIDTH-1:0] dmem [DMEM_DEPTH];

    // Helpers
    function automatic int trit8_to_int(trit_t [7:0] val);
        int result, power3, i;
        result = 0;
        power3 = 1;
        for (i = 0; i < 8; i++) begin
            case (val[i])
                T_NEG_ONE: result = result - power3;
                T_POS_ONE: result = result + power3;
                default: ;
            endcase
            power3 = power3 * 3;
        end
        return result;
    endfunction

    function automatic int trit9_to_int(trit_t [8:0] val);
        int result, power3, i;
        result = 0;
        power3 = 1;
        for (i = 0; i < 9; i++) begin
            case (val[i])
                T_NEG_ONE: result = result - power3;
                T_POS_ONE: result = result + power3;
                default: ;
            endcase
            power3 = power3 * 3;
        end
        return result;
    endfunction

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // DUT instantiation
    ternary_cpu #(
        .TRIT_WIDTH (TRIT_WIDTH),
        .IMEM_DEPTH (IMEM_DEPTH),
        .DMEM_DEPTH (DMEM_DEPTH)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .imem_addr    (imem_addr),
        .imem_data    (imem_data),
        .dmem_addr    (dmem_addr),
        .dmem_wdata   (dmem_wdata),
        .dmem_rdata   (dmem_rdata),
        .dmem_we      (dmem_we),
        .dmem_re      (dmem_re),
        .halted       (halted),
        .pc_out       (pc_out),
        .valid_out    (valid_out),
        .dbg_reg_idx  (dbg_reg_idx),
        .dbg_reg_data (dbg_reg_data),
        .stall_out    (stall_out),
        .fwd_a_out    (fwd_a_out),
        .fwd_b_out    (fwd_b_out)
    );

    // Instruction memory read
    always_comb begin
        int idx;
        idx = trit8_to_int(imem_addr);
        if (idx >= 0 && idx < IMEM_DEPTH)
            imem_data = imem[idx];
        else
            imem_data = TRIT9_ZERO;  // NOP
    end

    // Data memory read/write
    always_ff @(posedge clk) begin
        int idx;
        idx = trit9_to_int(dmem_addr);
        if (dmem_we && idx >= 0 && idx < DMEM_DEPTH) begin
            dmem[idx] <= dmem_wdata;
        end
    end

    always_comb begin
        int idx;
        idx = trit9_to_int(dmem_addr);
        if (idx >= 0 && idx < DMEM_DEPTH)
            dmem_rdata = dmem[idx];
        else
            dmem_rdata = TRIT27_ZERO;
    end

    // Performance counters (match analyze_performance.ps1 patterns)
    int cycle_count;
    int instruction_count;
    int stall_count;
    int forward_count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count <= 0;
            instruction_count <= 0;
            stall_count <= 0;
            forward_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;

            if (valid_out && !stall_out)
                instruction_count <= instruction_count + 1;

            if (stall_out)
                stall_count <= stall_count + 1;

            if (fwd_a_out || fwd_b_out)
                forward_count <= forward_count + 1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst_n && !halted) begin
            $display("[Cycle %0d] PC=%0d Valid=%0d Stall=%0d Fwd=%0d",
                             cycle_count, trit8_to_int(pc_out), valid_out, stall_out,
                             (fwd_a_out || fwd_b_out));
        end
    end

    // Test sequence
    initial begin
        dbg_reg_idx = 0;

        // Initialize memories
        for (int i = 0; i < IMEM_DEPTH; i++) imem[i] = TRIT9_ZERO;
        for (int i = 0; i < DMEM_DEPTH; i++) dmem[i] = TRIT27_ZERO;

        // Load program
__IMEM_INIT__

        // Reset
        rst_n = 0;
        #(CLK_PERIOD * 5);
        rst_n = 1;

        // Run until halt or timeout
        fork
            begin
                wait(halted);
                $display("[TB] CPU halted at time %0t", $time);
            end
            begin
                #(CLK_PERIOD * 5000);
                $display("[TB] TIMEOUT at time %0t", $time);
            end
        join_any
        disable fork;

        // Final summary
        $display("Total Cycles: %0d", cycle_count);
        $display("Instructions: %0d", instruction_count);
        $display("Stalls: %0d", stall_count);
        $display("Forwards: %0d", forward_count);

        $finish;
    end

endmodule

'@

$imemInitBlock = ""
foreach ($line in $svLines) {
        $imemInitBlock += "    $line`n"
}

$tbContent = $tbTemplate.Replace("__PROGRAM__", $Program)
$tbContent = $tbContent.Replace("__SOURCE__", $programFile)
$tbContent = $tbContent.Replace("__GEN_DATE__", (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
$tbContent = $tbContent.Replace("__IMEM_INIT__", $imemInitBlock.TrimEnd())

$tbContent | Out-File -FilePath $tbGenFile -Encoding UTF8
Write-Success "Testbench generated: $tbGenFile"

# Step 3: Compile with Icarus Verilog
Write-Step "Compiling RTL"
$vvpFile = "$OutputDir\cpu_$Program.vvp"

Ensure-IcarusVerilog
if (-not (Get-Command iverilog -ErrorAction SilentlyContinue) -or -not (Get-Command vvp -ErrorAction SilentlyContinue)) {
    Write-Failure "iverilog/vvp not found. If you have it installed under C:\\iverilog, ensure C:\\iverilog\\bin is on PATH."
    exit 1
}

$rtlFiles = @(
    "$RtlDir\ternary_pkg.sv",
    "$RtlDir\btfa.sv",
    "$RtlDir\ternary_adder.sv",
    "$RtlDir\ternary_alu.sv",
    "$RtlDir\btisa_decoder.sv",
    "$RtlDir\ternary_regfile.sv",
    "$RtlDir\ternary_hazard_unit.sv",
    "$RtlDir\ternary_forward_unit.sv",
    "$RtlDir\ternary_memory.sv",
    "$RtlDir\ternary_cpu.sv",
    "$tbGenFile"
)

$iverilogArgs = @("-g2012", "-DSIMULATION", "-o", $vvpFile) + $rtlFiles

if ($ShowDetails) {
    Write-Info "iverilog $($iverilogArgs -join ' ')"
}

# Capture output and check for actual errors (not just warnings)
# Use ErrorAction to prevent PowerShell from treating stderr as terminating
$ErrorActionPreference = 'Continue'
$compileOutput = & iverilog @iverilogArgs 2>&1 | Out-String -Stream
$hasErrors = $false
foreach ($line in $compileOutput) {
    # Icarus warnings contain "warning:" - only fail on lines with "error:" but not "warning:"
    if ($line -match '\berror:' -and $line -notmatch '\bwarning:') {
        $hasErrors = $true
    }
    if ($ShowDetails) { Write-Host "  $line" -ForegroundColor Gray }
}

if ($hasErrors) { 
    Write-Failure "Compilation errors detected"
    exit 1
}
Write-Success "Compilation successful: $vvpFile"

# Step 4: Run simulation
Write-Step "Running Simulation"
$logFile = "$OutputDir\$Program.log"

try {
    $simOutput = & vvp $vvpFile 2>&1
    $simOutput | Out-File -FilePath $logFile -Encoding UTF8
    
    # Display output
    $simOutput | ForEach-Object {
        if ($_ -match "\[PASS\]") { Write-Success ($_ -replace "\[PASS\]\s*", "") }
        elseif ($_ -match "\[FAIL\]") { Write-Failure ($_ -replace "\[FAIL\]\s*", "") }
        elseif ($ShowDetails -or $_ -match "===|Performance|CPI|IPC") { Write-Host $_ }
    }
    
    Write-Success "Simulation complete: $logFile"
}
catch {
    Write-Failure "Simulation failed: $_"
    exit 1
}

# Step 5: Analyze performance
Write-Step "Performance Summary"
& "$PSScriptRoot\analyze_performance.ps1" -LogFile $logFile

# Cleanup
if (-not $KeepOutput) {
    # Keep log and mem files, remove intermediate files
    if (Test-Path $tbGenFile) { Remove-Item $tbGenFile -ErrorAction SilentlyContinue }
}

Write-Step "Test Complete"
Write-Host ""
