
// VCD Dump for Power Analysis
// Add this to tb_tpu_benchmarks.sv or create tb_tpu_power.sv

initial begin
    // Create VCD file for power analysis
    $dumpfile("tpu_benchmark.vcd");
    $dumpvars(0, u_tpu);

    // For larger designs, dump specific modules to reduce file size:
    // $dumpvars(1, u_tpu.u_pe_array);
    // $dumpvars(1, u_tpu.u_weight_buffer);
    // $dumpvars(1, u_tpu.u_activation_buffer);
end

// Optional: Dump only during active computation
// This reduces VCD file size significantly
reg dumping;
initial dumping = 0;

always @(posedge clk) begin
    if (busy && !dumping) begin
        $dumpoff;
        dumping <= 1;
        $dumpon;
    end
    if (!busy && dumping) begin
        $dumpoff;
        dumping <= 0;
    end
end

// SAIF file generation (if supported by simulator)
// Questa: Use -vcd2saif to convert VCD to SAIF
// VCS: Use $set_toggle_region and $toggle_start/$toggle_stop

