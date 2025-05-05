`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 11:06:49 AM
// Design Name: 
// Module Name: carry_lookahead_adder_4B
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carry_lookahead_adder_4B(
    input   wire [3:0]  iA, iB, 
    input   wire        iCarry,
    output  wire [3:0]  oSum, 
    output  wire        oCarry
    );
    
    wire [3:0] internal_carry;
    wire [3:0] propagate_carry;
    wire [3:0] generate_carry;
    
    assign internal_carry[0] = iCarry;
    
    // initiate partial full adder
    partial_full_adder pfa0(iA[0], iB[0], internal_carry[0], oSum[0], propagate_carry[0], generate_carry[0]);
    partial_full_adder pfa1(iA[1], iB[1], internal_carry[1], oSum[1], propagate_carry[1], generate_carry[1]);
    partial_full_adder pfa2(iA[2], iB[2], internal_carry[2], oSum[2], propagate_carry[2], generate_carry[2]);
    partial_full_adder pfa3(iA[3], iB[3], internal_carry[3], oSum[3], propagate_carry[3], generate_carry[3]);
    
    // carry lookahead logic
    assign internal_carry[1] = generate_carry[0] | (propagate_carry[0] & internal_carry[0]);
    assign internal_carry[2] = generate_carry[1] | 
                                (propagate_carry[1] & generate_carry[0]) |
                                (propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[3] = generate_carry[2] | 
                                (propagate_carry[2] & generate_carry[1]) |
                                (propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                                (propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign oCarry = generate_carry[3] | 
                    (propagate_carry[3] & generate_carry[2]) |
                    (propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                    (propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                    (propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);                            
    
    
endmodule
