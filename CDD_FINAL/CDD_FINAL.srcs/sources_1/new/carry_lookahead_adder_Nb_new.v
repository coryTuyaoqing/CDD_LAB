`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 15:02:04
// Design Name: 
// Module Name: carry_lookahead_adder_Nb_new
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


module carry_lookahead_adder_Nb_new #(
    parameter N = 8
)(
    input  wire [N-1:0] iA,
    input  wire [N-1:0] iB,
    input  wire         iCarry,
    output wire [N-1:0] oSum,
    output wire         oCarry
);

    wire [N-1:0] G, P;  // Generate, Propagate
    wire [N:0]   C;
    assign C[0] = iCarry;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign G[i] = iA[i] & iB[i];
            assign P[i] = iA[i] ^ iB[i];
            assign C[i+1] = G[i] | (P[i] & C[i]);
            assign oSum[i] = P[i] ^ C[i];
        end
    endgenerate

    assign oCarry = C[N];

endmodule

