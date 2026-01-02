// Auto-generated from: test_hazards.btasm
// Generated: 2025-12-19 04:31:02
// Instruction count: 11

initial begin
    imem[0] = '{ T_ZERO, T_POS_ONE, T_ZERO, T_ZERO, T_POS_ONE, T_ZERO, T_ZERO, T_NEG_ONE, T_ZERO };
    imem[1] = '{ T_ZERO, T_POS_ONE, T_ZERO, T_ZERO, T_NEG_ONE, T_ZERO, T_ZERO, T_NEG_ONE, T_ZERO };
    imem[2] = '{ T_POS_ONE, T_ZERO, T_NEG_ONE, T_ZERO, T_ZERO, T_POS_ONE, T_ZERO, T_ZERO, T_ZERO };
    imem[3] = '{ T_POS_ONE, T_ZERO, T_ZERO, T_POS_ONE, T_POS_ONE, T_POS_ONE, T_ZERO, T_ZERO, T_ZERO };
    imem[4] = '{ T_ZERO, T_POS_ONE, T_POS_ONE, T_POS_ONE, T_NEG_ONE, T_POS_ONE, T_POS_ONE, T_ZERO, T_ZERO };
    imem[5] = '{ T_ZERO, T_ZERO, T_NEG_ONE, T_POS_ONE, T_ZERO, T_NEG_ONE, T_NEG_ONE, T_ZERO, T_ZERO };
    imem[6] = '{ T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_NEG_ONE, T_NEG_ONE };
    imem[7] = '{ T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_NEG_ONE, T_NEG_ONE };
    imem[8] = '{ T_ZERO, T_ZERO, T_POS_ONE, T_ZERO, T_POS_ONE, T_NEG_ONE, T_ZERO, T_ZERO, T_ZERO };
    imem[9] = '{ T_POS_ONE, T_NEG_ONE, T_POS_ONE, T_NEG_ONE, T_NEG_ONE, T_NEG_ONE, T_ZERO, T_ZERO, T_ZERO };
    imem[10] = '{ T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_ZERO, T_POS_ONE, T_NEG_ONE, T_NEG_ONE };
end
