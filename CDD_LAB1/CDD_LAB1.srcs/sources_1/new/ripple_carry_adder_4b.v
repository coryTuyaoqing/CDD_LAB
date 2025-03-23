`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 11:44:43 AM
// Design Name: 
// Module Name: ripple_carry_adder_4b
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


module ripple_carry_adder_4b(
    input   wire [3:0]  iA, iB, 
    input   wire        iCarry,
    output  wire [3:0]  oSum, 
    output  wire        oCarry
    );
    
    wire [2:0] internal_carry;
    
    full_adder fa0(iA[0], iB[0], iCarry, oSum[0], internal_carry[0]);
    full_adder fa1(iA[1], iB[1], internal_carry[0], oSum[1], internal_carry[1]);
    full_adder fa2(iA[2], iB[2], internal_carry[1], oSum[2], internal_carry[2]);
    full_adder fa3(iA[3], iB[3], internal_carry[2], oSum[3], oCarry);
    
endmodule
