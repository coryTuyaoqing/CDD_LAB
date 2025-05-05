`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 08:27:38 AM
// Design Name: 
// Module Name: ripple_carry_adder_Nb
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


module ripple_carry_adder_Nb #(
    parameter   ADDER_WIDTH = 16
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
);

    wire [ADDER_WIDTH-2:0] internal_carry;
    
    // connenct iC of the first fa to iCarry and the oC to the first bit of internal carry
    full_adder fa_0 (iA[0], iB[0], iCarry, oSum[0], internal_carry[0]);
    
    // from the first fa to the second to last
    genvar i;
    generate
        for(i=1; i<ADDER_WIDTH-1; i=i+1) begin 
            // connect each iC of each fa to the previous internal carry and oC to the next one
            full_adder fa_i (iA[i], iB[i], internal_carry[i-1], oSum[i], internal_carry[i]);
        end
    endgenerate 
        
    //connect the iC of last fa to the last internal carry and oC to the output carry
    full_adder fa_ADDER_WIDTH (iA[ADDER_WIDTH-1], iB[ADDER_WIDTH-1], internal_carry[ADDER_WIDTH-2], oSum[ADDER_WIDTH-1], oCarry);

endmodule
