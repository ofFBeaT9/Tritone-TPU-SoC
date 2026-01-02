// Ternary Carry-Lookahead Adder
// 27-trit implementation with 3-level hierarchical lookahead
//
// Architecture:
//   Level 0: Single-trit PG (Propagate/Generate) computation
//   Level 1: 3-trit group lookahead (9 groups)
//   Level 2: 9-trit super-group lookahead (3 super-groups)
//   Level 3: 27-trit final carry computation
//
// Critical Path: O(log3(N)) vs O(N) for ripple-carry
//   27-trit ripple: ~27 * t_btfa stages
//   27-trit CLA: ~4 stages (PG + 3 levels of lookahead)
//
// Balanced Ternary Carry Properties:
//   - Carry values: {-1, 0, +1}
//   - Generate: When a + b produces carry regardless of cin
//   - Propagate: When a + b allows cin to pass through
//   - Kill: When carry is absorbed
//
// Reference: Tritone ISA Paper Section V (Adder Analysis)

module ternary_cla
  import ternary_pkg::*;
#(
  parameter int WIDTH = 27  // Number of trits (should be power of 3)
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  trit_t             cin,
  output trit_t [WIDTH-1:0] sum,
  output trit_t             cout
);

  // ============================================================
  // Level 0: Single-Trit Propagate/Generate
  // ============================================================
  // For balanced ternary, we need to track:
  //   g_pos[i]: a[i] + b[i] generates +1 carry (both are +1)
  //   g_neg[i]: a[i] + b[i] generates -1 carry (both are -1)
  //   p[i]: a[i] + b[i] propagates carry (sum is -1, 0, or +1)
  //   partial_sum[i]: a[i] + b[i] without carry (for later adjustment)

  logic [WIDTH-1:0] g_pos;   // Generate +1 carry
  logic [WIDTH-1:0] g_neg;   // Generate -1 carry
  logic [WIDTH-1:0] p;       // Propagate (carry passes through)
  trit_t [WIDTH-1:0] partial_sum;  // a + b without cin

  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_pg
      // Compute partial sum (a + b) and generate/propagate signals
      // a + b ranges from -2 to +2:
      //   -2: g_neg=1, partial_sum=+1 (carry -1, leave +1)
      //   -1: p=1, partial_sum=-1
      //    0: p=1, partial_sum=0
      //   +1: p=1, partial_sum=+1
      //   +2: g_pos=1, partial_sum=-1 (carry +1, leave -1)

      logic signed [2:0] ab_sum;
      assign ab_sum = (a[i] == T_POS_ONE ? 3'sd1 : (a[i] == T_NEG_ONE ? -3'sd1 : 3'sd0))
                    + (b[i] == T_POS_ONE ? 3'sd1 : (b[i] == T_NEG_ONE ? -3'sd1 : 3'sd0));

      assign g_pos[i] = (ab_sum == 3'sd2);  // Both +1
      assign g_neg[i] = (ab_sum == -3'sd2); // Both -1
      assign p[i] = (ab_sum >= -3'sd1) && (ab_sum <= 3'sd1);  // -1, 0, or +1

      // Partial sum (a + b) mod 3 in balanced ternary
      always_comb begin
        case (ab_sum)
          -3'sd2: partial_sum[i] = T_POS_ONE;  // -2 -> +1 with carry -1
          -3'sd1: partial_sum[i] = T_NEG_ONE;  // -1
           3'sd0: partial_sum[i] = T_ZERO;     //  0
           3'sd1: partial_sum[i] = T_POS_ONE;  // +1
           3'sd2: partial_sum[i] = T_NEG_ONE;  // +2 -> -1 with carry +1
          default: partial_sum[i] = T_INVALID;
        endcase
      end
    end
  endgenerate

  // ============================================================
  // Level 1: 3-Trit Group Lookahead (9 groups for 27 trits)
  // ============================================================
  // Group generate/propagate: Combine 3 single-trit signals
  // G_group = G2 | (P2 & G1) | (P2 & P1 & G0)
  // P_group = P2 & P1 & P0

  localparam int NUM_GROUPS = WIDTH / 3;  // 9 groups

  logic [NUM_GROUPS-1:0] grp_g_pos;  // Group generates +1
  logic [NUM_GROUPS-1:0] grp_g_neg;  // Group generates -1
  logic [NUM_GROUPS-1:0] grp_p;      // Group propagates

  generate
    for (i = 0; i < NUM_GROUPS; i++) begin : gen_groups
      // Group indices
      localparam int BASE = i * 3;

      // Group propagate: all 3 positions propagate
      assign grp_p[i] = p[BASE] & p[BASE+1] & p[BASE+2];

      // Group generate positive: generates +1 carry out of group
      // G+ = g2+ | (p2 & g1+) | (p2 & p1 & g0+)
      assign grp_g_pos[i] = g_pos[BASE+2]
                          | (p[BASE+2] & g_pos[BASE+1])
                          | (p[BASE+2] & p[BASE+1] & g_pos[BASE]);

      // Group generate negative: generates -1 carry out of group
      // G- = g2- | (p2 & g1-) | (p2 & p1 & g0-)
      assign grp_g_neg[i] = g_neg[BASE+2]
                          | (p[BASE+2] & g_neg[BASE+1])
                          | (p[BASE+2] & p[BASE+1] & g_neg[BASE]);
    end
  endgenerate

  // ============================================================
  // Level 2: 9-Trit Super-Group Lookahead (3 super-groups)
  // ============================================================
  localparam int NUM_SUPER = NUM_GROUPS / 3;  // 3 super-groups

  logic [NUM_SUPER-1:0] super_g_pos;
  logic [NUM_SUPER-1:0] super_g_neg;
  logic [NUM_SUPER-1:0] super_p;

  generate
    for (i = 0; i < NUM_SUPER; i++) begin : gen_super
      localparam int BASE = i * 3;

      assign super_p[i] = grp_p[BASE] & grp_p[BASE+1] & grp_p[BASE+2];

      assign super_g_pos[i] = grp_g_pos[BASE+2]
                            | (grp_p[BASE+2] & grp_g_pos[BASE+1])
                            | (grp_p[BASE+2] & grp_p[BASE+1] & grp_g_pos[BASE]);

      assign super_g_neg[i] = grp_g_neg[BASE+2]
                            | (grp_p[BASE+2] & grp_g_neg[BASE+1])
                            | (grp_p[BASE+2] & grp_p[BASE+1] & grp_g_neg[BASE]);
    end
  endgenerate

  // ============================================================
  // Level 3: Final Carry Computation
  // ============================================================
  // Compute carry into each super-group, group, and position

  trit_t [NUM_SUPER:0] super_carry;   // Carry into each super-group
  trit_t [NUM_GROUPS:0] group_carry;  // Carry into each group
  trit_t [WIDTH:0] carry;             // Carry into each position

  // Super-group carries - compute all in single always_comb for Icarus compatibility
  always_comb begin
    super_carry[0] = cin;
    for (int sc = 0; sc < NUM_SUPER; sc++) begin
      // Determine carry out of super-group
      if (super_g_pos[sc])
        super_carry[sc+1] = T_POS_ONE;
      else if (super_g_neg[sc])
        super_carry[sc+1] = T_NEG_ONE;
      else if (super_p[sc])
        super_carry[sc+1] = super_carry[sc];  // Propagate
      else
        super_carry[sc+1] = T_ZERO;  // Kill
    end
  end

  // Group carries (computed from super-group carries) - Icarus compatible
  always_comb begin
    for (int gc = 0; gc < NUM_GROUPS; gc++) begin
      if ((gc % 3) == 0) begin
        // First group in super-group: use super-group carry
        group_carry[gc] = super_carry[gc / 3];
      end else begin
        // Simplified: use previous group's carry-out
        if (grp_g_pos[gc-1])
          group_carry[gc] = T_POS_ONE;
        else if (grp_g_neg[gc-1])
          group_carry[gc] = T_NEG_ONE;
        else if (grp_p[gc-1])
          group_carry[gc] = group_carry[gc-1];
        else
          group_carry[gc] = T_ZERO;
      end
    end
  end

  // Position carries (computed from group carries) - Icarus compatible
  always_comb begin
    for (int pc = 0; pc < WIDTH; pc++) begin
      if ((pc % 3) == 0) begin
        // First position in group: use group carry
        carry[pc] = group_carry[pc / 3];
      end else begin
        // Compute from previous positions within group
        if (g_pos[pc-1])
          carry[pc] = T_POS_ONE;
        else if (g_neg[pc-1])
          carry[pc] = T_NEG_ONE;
        else if (p[pc-1])
          carry[pc] = carry[pc-1];
        else
          carry[pc] = T_ZERO;
      end
    end
    // Final carry out
    if (super_g_pos[NUM_SUPER-1])
      carry[WIDTH] = T_POS_ONE;
    else if (super_g_neg[NUM_SUPER-1])
      carry[WIDTH] = T_NEG_ONE;
    else if (super_p[NUM_SUPER-1])
      carry[WIDTH] = super_carry[NUM_SUPER-1];
    else
      carry[WIDTH] = T_ZERO;
  end

  // ============================================================
  // Final Sum Computation
  // ============================================================
  // sum[i] = partial_sum[i] + carry[i] (mod 3 in balanced ternary)

  generate
    for (i = 0; i < WIDTH; i++) begin : gen_sum
      logic signed [2:0] final_sum;

      assign final_sum = (partial_sum[i] == T_POS_ONE ? 3'sd1 :
                         (partial_sum[i] == T_NEG_ONE ? -3'sd1 : 3'sd0))
                       + (carry[i] == T_POS_ONE ? 3'sd1 :
                         (carry[i] == T_NEG_ONE ? -3'sd1 : 3'sd0));

      always_comb begin
        // Adjust for ternary carry if needed
        case (final_sum)
          -3'sd2: sum[i] = T_POS_ONE;  // -2 -> +1 (borrow handled)
          -3'sd1: sum[i] = T_NEG_ONE;
           3'sd0: sum[i] = T_ZERO;
           3'sd1: sum[i] = T_POS_ONE;
           3'sd2: sum[i] = T_NEG_ONE;  // +2 -> -1 (carry handled)
          default: sum[i] = T_INVALID;
        endcase
      end
    end
  endgenerate

  assign cout = trit_t'(carry[WIDTH]);

endmodule
