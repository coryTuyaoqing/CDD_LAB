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
    parameter N      = 64,      // Total adder width
    parameter B_SIZE = 8        // Bits per carry-select block
)(
    input  wire [N-1:0] iA,
    input  wire [N-1:0] iB,
    input  wire         iCarry,
    output wire [N-1:0] oSum,
    output wire         oCarry
);

    // Number of blocks
    localparam NUM_BLOCKS = (N + B_SIZE - 1) / B_SIZE;

    // Internal carry signals between blocks
    wire [NUM_BLOCKS:0] carry;
    assign carry[0] = iCarry;

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
            carry_lookahead_adder_8b u0 (
                .iA   (iA[L +: WIDTH]),
                .iB   (iB[L +: WIDTH]),
                .iCarry (1'b0),
                .oSum (sum0),
                .oCarry(c0)
            );

            // Compute for Cin=1
            carry_lookahead_adder_8b u1 (
                .iA   (iA[L +: WIDTH]),
                .iB   (iB[L +: WIDTH]),
                .iCarry(1'b1),
                .oSum (sum1),
                .oCarry(c1)
            );

            // Select correct sum and carry based on actual carry-in
            assign oSum[L +: WIDTH] = carry[blk] ? sum1 : sum0;
            assign carry[blk+1]   = carry[blk] ? c1    : c0;
        end
    endgenerate

    assign oCarry = carry[NUM_BLOCKS];

endmodule
