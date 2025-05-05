`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 08:52:59 AM
// Design Name: 
// Module Name: PFA
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


module partial_full_adder(
    input wire iA, iB, iCin,
    output wire oSum, oP, oG
    );
    
    assign oSum = iA^iB^iCin;
    assign oP = iA | iB;
    assign oG = iA & iB;
    
endmodule
