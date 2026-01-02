# Branch Prediction Enhancement Proposal
**Date:** December 18, 2025
**Status:** Proposal for Phase 5
**Priority:** Medium (Performance Optimization)

## Executive Summary

This document proposes adding branch prediction to the ternary CPU to improve 
performance by reducing branch penalties. Current implementation: branch decisions 
resolved in EX stage (2-cycle penalty). With prediction: most branches can achieve 
0-cycle penalty.

## Current Branch Handling

### Branch Resolution
- Branch decision made in **EX stage** (stage 2 of 4)
- Branch penalty: **2 cycles** (flush IF and ID stages)
- Affects: BEQ, BNE, BEQZ, BNEZ, BLT, BGE (6 branch instructions)

### Performance Impact
- Branch penalty: 2 cycles per misprediction
- Typical branch frequency: 15-20% of instructions
- CPI increase: ~0.3-0.4 cycles per instruction

## Proposed Enhancement: Static Branch Prediction

### Option 1: Always Not-Taken (Simplest)
**Prediction:** All branches predicted as not-taken
- **Pros:** No hardware cost, easy to implement
- **Cons:** Poor performance for loops (backward branches)
- **Expected CPI improvement:** Minimal (0.1-0.15)

### Option 2: Backward Taken, Forward Not-Taken (Recommended)
**Prediction:** Backward branches taken (loops), forward branches not-taken
- **Implementation:** Check branch offset sign in ID stage
- **Hardware cost:** 1 comparator, 1 mux
- **Expected accuracy:** 70-80%
- **Expected CPI improvement:** 0.15-0.25

### Option 3: 1-Bit Branch History Table
**Prediction:** Remember last outcome for each branch
- **Implementation:** Small table (16-32 entries) indexed by PC
- **Hardware cost:** 16-32 flip-flops, lookup logic
- **Expected accuracy:** 85-90%
- **Expected CPI improvement:** 0.2-0.3

## Implementation Plan (Option 2 - Recommended)

### Module: ternary_branch_predictor.sv
```systemverilog
module ternary_branch_predictor (
    input  logic [7:0]  pc,           // Current PC
    input  logic [8:0]  instruction,  // Current instruction
    input  logic        is_branch,    // Branch detected
    output logic        predict_taken // Prediction
);
    // Extract branch offset (signed)
    logic branch_backward;
    
    // Check if offset is negative (backward branch)
    assign branch_backward = (instruction[1] == T_NEG_ONE) ||
                             (instruction[2] == T_NEG_ONE && 
                              instruction[1] == T_ZERO);
    
    // Predict: backward=taken, forward=not-taken
    assign predict_taken = is_branch && branch_backward;
endmodule
```

### Integration Changes
1. **IF Stage:** Add speculative PC calculation
2. **ID Stage:** Instantiate predictor, generate prediction
3. **EX Stage:** Compare prediction with actual outcome
4. **Pipeline Control:** Only flush on misprediction

### Expected Results
- **Branch accuracy:** 70-80%
- **Average branch penalty:** 0.4-0.6 cycles (vs 2.0 current)
- **CPI improvement:** 0.15-0.25
- **Performance gain:** 5-8% overall

## Testing Requirements

### New Test Programs Needed
1. **test_branch_loops.btasm** - Loop-heavy code
2. **test_branch_conditionals.btasm** - If-else patterns
3. **test_branch_mixed.btasm** - Mixed forward/backward

### Validation Criteria
-  Correct execution (no functional errors)
-  Reduced average branch penalty
-  Improved CPI in branch-heavy workloads
-  No timing violations

## Resource Estimates

### Development Time
- Design: 2 hours
- Implementation: 3 hours
- Testing: 2 hours
- **Total: 7 hours (1 day)**

### Hardware Cost (Option 2)
- Additional logic: ~50 gates
- Flip-flops: 0 (combinational only)
- Critical path impact: Minimal (<5%)

## Recommendations

1. **Phase 5 Priority:** Implement Option 2 (backward taken predictor)
2. **Phase 6 Enhancement:** Consider Option 3 (BHT) if more performance needed
3. **Prerequisite:** Complete current testing and establish baseline CPI
4. **Success Metric:** >5% performance improvement on typical workloads

## References

- Branch Prediction Basics (Hennessy & Patterson, "Computer Architecture")
- Ternary Computing Branch Patterns (TBD - empirical data needed)
- Current CPU: 4-stage pipeline with 2-cycle branch penalty

---
**Next Steps:**
1. Establish baseline CPI with current tests
2. Analyze branch behavior in test programs
3. Implement Option 2 predictor
4. Validate and measure improvement

**Approval Required:** Architecture review before implementation
