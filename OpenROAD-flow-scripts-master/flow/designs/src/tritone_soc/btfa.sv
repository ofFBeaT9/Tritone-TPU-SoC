// Balanced Ternary Full Adder (BTFA)
// Single trit addition with carry
//
// Truth table for sum and carry based on balanced ternary arithmetic
// Input range: a, b, cin ∈ {-1, 0, +1}
// Sum range: -3 to +3, decomposed into sum ∈ {-1, 0, +1} and cout ∈ {-1, 0, +1}

`include "ternary_defs.vh"

module btfa (
  input  wire [1:0] a,
  input  wire [1:0] b,
  input  wire [1:0] cin,
  output reg  [1:0] sum,
  output reg  [1:0] cout
);

  // Convert trits to signed values, add, convert back
  reg signed [2:0] a_val, b_val, cin_val, total;

  always @(*) begin
    // Convert inputs to signed integers
    case (a)
      `T_NEG_ONE: a_val = -1;
      `T_ZERO:    a_val = 0;
      `T_POS_ONE: a_val = 1;
      default:    a_val = 0;
    endcase

    case (b)
      `T_NEG_ONE: b_val = -1;
      `T_ZERO:    b_val = 0;
      `T_POS_ONE: b_val = 1;
      default:    b_val = 0;
    endcase

    case (cin)
      `T_NEG_ONE: cin_val = -1;
      `T_ZERO:    cin_val = 0;
      `T_POS_ONE: cin_val = 1;
      default:    cin_val = 0;
    endcase

    // Compute sum
    total = a_val + b_val + cin_val;

    // Convert back to balanced ternary
    case (total)
      -3: begin sum = `T_ZERO;    cout = `T_NEG_ONE; end
      -2: begin sum = `T_POS_ONE; cout = `T_NEG_ONE; end
      -1: begin sum = `T_NEG_ONE; cout = `T_ZERO;    end
       0: begin sum = `T_ZERO;    cout = `T_ZERO;    end
       1: begin sum = `T_POS_ONE; cout = `T_ZERO;    end
       2: begin sum = `T_NEG_ONE; cout = `T_POS_ONE; end
       3: begin sum = `T_ZERO;    cout = `T_POS_ONE; end
      default: begin sum = `T_INVALID; cout = `T_INVALID; end
    endcase
  end

endmodule
