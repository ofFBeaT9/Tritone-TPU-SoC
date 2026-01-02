// Ternary Logic Package
// Defines types, functions, and operators for balanced ternary
// Based on ROADMAP Phase 2 - RTL Synthesis Flow

package ternary_pkg;

  // 2-bit encoding for ternary values
  // 00 = 0 (zero)
  // 01 = +1 (positive one)
  // 10 = -1 (negative one)
  // 11 = X (invalid/error)

  typedef enum logic [1:0] {
    T_ZERO    = 2'b00,
    T_POS_ONE = 2'b01,
    T_NEG_ONE = 2'b10,
    T_INVALID = 2'b11
  } trit_t;

  // N-trit vector type
  typedef trit_t [7:0] trit8_t;   // 8-trit word
  typedef trit_t [26:0] trit27_t; // 27-trit word (standard)

  // Ternary inversion (STI function)
  function automatic trit_t t_neg(trit_t a);
    case (a)
      T_NEG_ONE: return T_POS_ONE;
      T_ZERO:    return T_ZERO;
      T_POS_ONE: return T_NEG_ONE;
      default:   return T_INVALID;
    endcase
  endfunction

  // Ternary MIN (AND-like)
  function automatic trit_t t_min(trit_t a, trit_t b);
    if (a == T_INVALID || b == T_INVALID) return T_INVALID;
    if (a == T_NEG_ONE || b == T_NEG_ONE) return T_NEG_ONE;
    if (a == T_ZERO || b == T_ZERO) return T_ZERO;
    return T_POS_ONE;
  endfunction

  // Ternary MAX (OR-like)
  function automatic trit_t t_max(trit_t a, trit_t b);
    if (a == T_INVALID || b == T_INVALID) return T_INVALID;
    if (a == T_POS_ONE || b == T_POS_ONE) return T_POS_ONE;
    if (a == T_ZERO || b == T_ZERO) return T_ZERO;
    return T_NEG_ONE;
  endfunction

  // Ternary addition (single trit with carry)
  function automatic logic [3:0] t_add_trit(trit_t a, trit_t b, trit_t cin);
    logic signed [2:0] sum;
    trit_t result, cout;

    // Convert to signed integers and add
    sum = $signed({1'b0, a == T_POS_ONE}) - $signed({1'b0, a == T_NEG_ONE})
        + $signed({1'b0, b == T_POS_ONE}) - $signed({1'b0, b == T_NEG_ONE})
        + $signed({1'b0, cin == T_POS_ONE}) - $signed({1'b0, cin == T_NEG_ONE});

    // Convert back to balanced ternary
    case (sum)
      -3: begin result = T_ZERO;    cout = T_NEG_ONE; end
      -2: begin result = T_POS_ONE; cout = T_NEG_ONE; end
      -1: begin result = T_NEG_ONE; cout = T_ZERO;    end
       0: begin result = T_ZERO;    cout = T_ZERO;    end
       1: begin result = T_POS_ONE; cout = T_ZERO;    end
       2: begin result = T_NEG_ONE; cout = T_POS_ONE; end
       3: begin result = T_ZERO;    cout = T_POS_ONE; end
      default: begin result = T_INVALID; cout = T_INVALID; end
    endcase

    return {cout, result};
  endfunction

  // Convert binary to balanced ternary
  function automatic trit27_t bin_to_ternary(logic signed [31:0] val);
    trit27_t result;
    logic signed [31:0] temp;
    int i;

    temp = val;
    for (i = 0; i < 27; i++) begin
      case (temp % 3)
        0: result[i] = T_ZERO;
        1: result[i] = T_POS_ONE;
        2: begin
          result[i] = T_NEG_ONE;
          temp = temp + 1;  // Adjust for balanced representation
        end
      endcase
      temp = temp / 3;
    end
    return result;
  endfunction

  // Convert balanced ternary to binary
  function automatic logic signed [31:0] ternary_to_bin(trit27_t val);
    logic signed [31:0] result;
    logic signed [31:0] power3;
    int i;

    result = 0;
    power3 = 1;
    for (i = 0; i < 27; i++) begin
      case (val[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ; // T_ZERO adds nothing
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Helper: Convert trit to integer for debug
  function automatic int trit_to_int(trit_t t);
    case (t)
      T_NEG_ONE: return -1;
      T_ZERO:    return 0;
      T_POS_ONE: return 1;
      default:   return 99;  // Invalid marker
    endcase
  endfunction

  // Helper: Convert integer to trit
  function automatic trit_t int_to_trit(int v);
    case (v)
      -1: return T_NEG_ONE;
       0: return T_ZERO;
       1: return T_POS_ONE;
      default: return T_INVALID;
    endcase
  endfunction

  // Helper constant for 8-trit zero (for Icarus compatibility)
  // Can't use '{default:X} in Icarus, so we define constants
  localparam trit_t [7:0] TRIT8_ZERO = {T_ZERO, T_ZERO, T_ZERO, T_ZERO,
                                        T_ZERO, T_ZERO, T_ZERO, T_ZERO};

  localparam trit_t [8:0] TRIT9_ZERO = {T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO,
                                        T_ZERO, T_ZERO, T_ZERO, T_ZERO};

  localparam trit_t [1:0] TRIT2_ZERO = {T_ZERO, T_ZERO};

  // Constant 1 in 8-trit format
  localparam trit_t [7:0] TRIT8_ONE = {T_ZERO, T_ZERO, T_ZERO, T_ZERO,
                                       T_ZERO, T_ZERO, T_ZERO, T_POS_ONE};

  // Constant 2 in 8-trit format (for dual-issue PC+2 increment)
  // In balanced ternary: 2 = 1×3 + (-1)×1 = 3 - 1
  // Encoding: trit[1]=+1, trit[0]=-1, rest=0
  localparam trit_t [7:0] TRIT8_TWO = {T_ZERO, T_ZERO, T_ZERO, T_ZERO,
                                       T_ZERO, T_ZERO, T_POS_ONE, T_NEG_ONE};

  // 27-trit zero for register file
  localparam trit_t [26:0] TRIT27_ZERO = {
    T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO,
    T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO,
    T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO
  };

endpackage

