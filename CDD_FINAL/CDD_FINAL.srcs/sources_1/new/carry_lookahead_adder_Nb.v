`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 11:45:55 AM
// Design Name: 
// Module Name: carry_lookahead_adder_Nb
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


module carry_lookahead_adder_Nb#(
    parameter   ADDER_WIDTH = 4
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
);

    wire [ADDER_WIDTH-1:0] internal_carry;
    wire [ADDER_WIDTH-1:0] propagate_carry;
    wire [ADDER_WIDTH-1:0] generate_carry;
    
    assign internal_carry[0] = iCarry;
    
    // initiate partial full adder
    genvar i;
    generate
        for(i=0; i<ADDER_WIDTH; i=i+1) begin 
            // connect each iC of each fa to the previous internal carry and oC to the next one
            partial_full_adder fa_i (iA[i], iB[i], internal_carry[i], oSum[i], propagate_carry[i], generate_carry[i]);
        end
    endgenerate 
    
    // carry lookahead logic
    generate 
        for(i=1; i<ADDER_WIDTH; i=i+1) begin
            assign internal_carry[i] = generate_carry[i-1] | (propagate_carry[i-1] & internal_carry[i-1]);
        end
    endgenerate 
    
    assign oCarry = generate_carry[ADDER_WIDTH-1] | (propagate_carry[ADDER_WIDTH-1] & internal_carry[ADDER_WIDTH-1]);
    
endmodule
