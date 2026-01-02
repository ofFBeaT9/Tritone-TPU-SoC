module tb_hello_world;
    reg clk;
    reg reset;
    wire [7:0] output_signal;

    // Instantiate the design under test (DUT)
    my_design dut (
        .clk(clk),
        .reset(reset),
        .output_signal(output_signal)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Add test cases
        #10; // Wait for some time
        // Check output_signal
        if (output_signal !== expected_value) begin
            $display("Test failed: output_signal = %h, expected = %h", output_signal, expected_value);
        end else begin
            $display("Test passed!");
        end

        // Finish simulation
        #10 $finish;
    end

    always #5 clk = ~clk; // Generate clock signal

endmodule