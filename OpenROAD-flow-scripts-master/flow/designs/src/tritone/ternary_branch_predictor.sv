// Ternary Branch Predictor - Static Backward-Taken Strategy
//
// Prediction Strategy:
//   - Backward branches (negative offset) -> Predict TAKEN (optimized for loops)
//   - Forward branches (positive offset)  -> Predict NOT-TAKEN (optimized for if-else)
//   - Zero offset -> Predict NOT-TAKEN
//
// This simple predictor achieves ~70-80% accuracy on typical workloads
// with minimal hardware cost (pure combinational logic).
//
// Future enhancements could include:
//   - 1-bit Branch History Table (BHT)
//   - 2-bit saturating counters
//   - Branch Target Buffer (BTB)

module ternary_branch_predictor
  import ternary_pkg::*;
(
  // Inputs from decoder
  input  logic        is_branch,      // Instruction is a branch
  input  trit_t [1:0] branch_offset,  // 2-trit signed branch offset (imm field)

  // Prediction output
  output logic        predict_taken   // 1 = predict taken, 0 = predict not-taken
);

  // Determine if offset is negative (backward branch)
  // In balanced ternary with 2 trits:
  //   imm[1] weight = 3, imm[0] weight = 1
  //   Negative if: imm[1] == -1 (always negative: -3 + {-1,0,+1} = {-4,-3,-2})
  //                OR imm[1] == 0 AND imm[0] == -1 (value = -1)

  logic offset_is_negative;

  always_comb begin
    offset_is_negative = 1'b0;

    // Check MSB (trit 1) first - weight 3
    if (branch_offset[1] == T_NEG_ONE) begin
      // MSB is -1: total = -3 + imm[0] -> always negative (-4 to -2)
      offset_is_negative = 1'b1;
    end else if (branch_offset[1] == T_ZERO) begin
      // MSB is 0: total = imm[0] -> check LSB
      if (branch_offset[0] == T_NEG_ONE) begin
        // Total = -1 (negative)
        offset_is_negative = 1'b1;
      end
      // T_ZERO (0) or T_POS_ONE (+1) are non-negative
    end
    // MSB is +1: total = +3 + imm[0] -> always positive (+2 to +4)
  end

  // Predict taken for backward branches (negative offset)
  // Only predict when instruction is actually a branch
  assign predict_taken = is_branch && offset_is_negative;

endmodule
