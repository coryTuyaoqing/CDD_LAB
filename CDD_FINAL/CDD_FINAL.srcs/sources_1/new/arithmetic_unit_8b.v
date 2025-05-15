`timescale 1ns / 1ps

module arithmetic_unit_8b(
    input   wire [7:0]  iA,         // First operand
    input   wire [7:0]  iB,         // Second operand
    input   wire [1:0]  iOperation, // Operation select: 00=Add, 01=Subtract, 10=Compare
    output  wire [7:0]  oResult,    // Result of operation
    output  wire        oCarry,     // Carry/Borrow out
    output  wire        oEqual,     // Equal flag (A == B)
    output  wire        oGreater,   // Greater than flag (A > B)
    output  wire        oLess       // Less than flag (A < B)
);

    // Internal signals
    wire [7:0] operand_b;
    wire carry_in;
    wire [7:0] sum_result;
    wire carry_out;
    
    // Operation decode
    assign operand_b = (iOperation[0]) ? ~iB : iB;  // Invert B for subtraction/compare
    assign carry_in = iOperation[0];                 // Add 1 for subtraction/compare
    
    // Main CLA instance
    carry_lookahead_adder_8b cla_main(
        .iA(iA),
        .iB(operand_b),
        .iCarry(carry_in),
        .oSum(sum_result),
        .oCarry(carry_out)
    );
    
    // Result selection and flag generation
    assign oResult = sum_result;
    assign oCarry = carry_out;
    
    // Comparison flags
    assign oEqual = (sum_result == 8'd0);
    assign oLess = (iOperation[0]) ? ~carry_out : 1'b0;  // For subtraction: borrow = ~carry
    assign oGreater = ~(oEqual | oLess);

endmodule 