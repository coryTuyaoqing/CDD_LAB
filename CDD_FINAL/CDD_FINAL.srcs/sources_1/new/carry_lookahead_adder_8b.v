`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2025 07:30:19 PM
// Design Name: 
// Module Name: carry_lookahead_adder_8b
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


module carry_lookahead_adder_8b(
    input   wire [7:0]  iA, iB, 
    input   wire        iCarry,
    output  wire [7:0]  oSum, 
    output  wire        oCarry
    );
    
    wire [7:0] internal_carry;
    wire [7:0] propagate_carry;
    wire [7:0] generate_carry;
    
    assign internal_carry[0] = iCarry;
    
    // Instantiate partial full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pfa_block
            partial_full_adder pfa(
                .iA(iA[i]),
                .iB(iB[i]),
                .iCin(internal_carry[i]),
                .oSum(oSum[i]),
                .oP(propagate_carry[i]),
                .oG(generate_carry[i])
            );
        end
    endgenerate
    
    // Carry lookahead logic
    assign internal_carry[1] = generate_carry[0] | (propagate_carry[0] & internal_carry[0]);
    assign internal_carry[2] = generate_carry[1] |
                               (propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[3] = generate_carry[2] |
                               (propagate_carry[2] & generate_carry[1]) |
                               (propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[4] = generate_carry[3] |
                               (propagate_carry[3] & generate_carry[2]) |
                               (propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                               (propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[5] = generate_carry[4] |
                               (propagate_carry[4] & generate_carry[3]) |
                               (propagate_carry[4] & propagate_carry[3] & generate_carry[2]) |
                               (propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                               (propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[6] = generate_carry[5] |
                               (propagate_carry[5] & generate_carry[4]) |
                               (propagate_carry[5] & propagate_carry[4] & generate_carry[3]) |
                               (propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & generate_carry[2]) |
                               (propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                               (propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign internal_carry[7] = generate_carry[6] |
                               (propagate_carry[6] & generate_carry[5]) |
                               (propagate_carry[6] & propagate_carry[5] & generate_carry[4]) |
                               (propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & generate_carry[3]) |
                               (propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & generate_carry[2]) |
                               (propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                               (propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                               (propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);
    assign oCarry = generate_carry[7] |
                    (propagate_carry[7] & generate_carry[6]) |
                    (propagate_carry[7] & propagate_carry[6] & generate_carry[5]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & generate_carry[4]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & generate_carry[3]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & generate_carry[2]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & generate_carry[1]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & generate_carry[0]) |
                    (propagate_carry[7] & propagate_carry[6] & propagate_carry[5] & propagate_carry[4] & propagate_carry[3] & propagate_carry[2] & propagate_carry[1] & propagate_carry[0] & internal_carry[0]);             

endmodule
