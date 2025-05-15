`timescale 1ns / 1ps

module subtractor_8b(
    input   wire [7:0]  iA,     // Minuend (被减数)
    input   wire [7:0]  iB,     // Subtrahend (减数)
    output  wire [7:0]  oDiff,  // Difference (差)
    output  wire        oBorrow // Borrow out (借位输出)
);

    // Invert iB for subtraction
    wire [7:0] inverted_B;
    assign inverted_B = ~iB;
    
    // Instantiate carry-lookahead adder
    // For subtraction: A - B = A + (-B) = A + (~B + 1)
    // We use carry input as 1 to add 1 to ~B
    carry_lookahead_adder_8b cla_sub(
        .iA(iA),
        .iB(inverted_B),
        .iCarry(1'b1),        // Add 1 to complete two's complement
        .oSum(oDiff),
        .oCarry(oBorrow)      // Borrow is inverse of carry
    );

endmodule 