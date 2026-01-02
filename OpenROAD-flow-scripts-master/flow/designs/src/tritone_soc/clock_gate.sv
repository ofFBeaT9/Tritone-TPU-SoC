// Clock Gating Cell for Tritone Ternary CPU
// Implements integrated clock gating (ICG) for power reduction
//
// This module uses a latch-based design to prevent glitches:
// - Enable is latched on the falling edge of clock
// - Gated clock only transitions when enable is stable

module clock_gate (
    input  logic clk,      // Input clock
    input  logic en,       // Enable signal (active high)
    input  logic test_en,  // Test mode enable (bypasses gating)
    output logic gclk      // Gated clock output
);

    // Latch enable on falling edge to prevent glitches
    logic en_latch;

    // Negative-level sensitive latch
    always_latch begin
        if (!clk) begin
            en_latch <= en | test_en;
        end
    end

    // AND gate for clock gating
    assign gclk = clk & en_latch;

endmodule
