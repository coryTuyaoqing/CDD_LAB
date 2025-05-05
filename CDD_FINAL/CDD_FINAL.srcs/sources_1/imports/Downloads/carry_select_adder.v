`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025
// Design Name: Carry Select Adder (CSA)
// Module Name: carry_select_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Parameterized N-bit Carry Select Adder based on 1-bit full adder
// Splits the N bits into B_SIZE-bit blocks; computes sums for both carry-in=0/1
// and selects the correct results via multiplexers.
// 
// Dependencies: full_adder.v
// 
//////////////////////////////////////////////////////////////////////////////////

module carry_select_adder #(
    parameter N      = 16,      // Total adder width
    parameter B_SIZE = 4        // Bits per carry-select block
)(
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire         Cin,
    output wire [N-1:0] Sum,
    output wire         Cout
);

    // Number of blocks
    localparam NUM_BLOCKS = (N + B_SIZE - 1) / B_SIZE;

    // Internal carry signals between blocks
    wire [NUM_BLOCKS:0] carry;
    assign carry[0] = Cin;

    genvar blk;
    generate
        for (blk = 0; blk < NUM_BLOCKS; blk = blk + 1) begin : BLOCK_LOOP
            // Determine block bit range
            localparam L = blk * B_SIZE;
            localparam H = (blk+1)*B_SIZE - 1 < N ? (blk+1)*B_SIZE - 1 : N-1;
            localparam WIDTH = H - L + 1;
            
//            localparam int L = blk * B_SIZE;
//            localparam int H = (blk+1)*B_SIZE - 1 < N ? (blk+1)*B_SIZE - 1 : N-1;
//            localparam int WIDTH = H - L + 1;

            // Wires for sums when carry-in=0 and carry-in=1
            wire [WIDTH-1:0] sum0, sum1;
            wire c0, c1;

            // Compute for Cin=0
            carry_select_block #(.WIDTH(WIDTH)) u0 (
                .A   (A[L +: WIDTH]),
                .B   (B[L +: WIDTH]),
                .Cin (1'b0),
                .Sum (sum0),
                .Cout(c0)
            );

            // Compute for Cin=1
            carry_select_block #(.WIDTH(WIDTH)) u1 (
                .A   (A[L +: WIDTH]),
                .B   (B[L +: WIDTH]),
                .Cin (1'b1),
                .Sum (sum1),
                .Cout(c1)
            );

            // Select correct sum and carry based on actual carry-in
            assign Sum[L +: WIDTH] = carry[blk] ? sum1 : sum0;
            assign carry[blk+1]   = carry[blk] ? c1    : c0;
        end
    endgenerate

    assign Cout = carry[NUM_BLOCKS];

endmodule
