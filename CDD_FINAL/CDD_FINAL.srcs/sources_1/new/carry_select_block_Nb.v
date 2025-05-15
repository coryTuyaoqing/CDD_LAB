`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 15:23:15
// Design Name: 
// Module Name: carry_select_block_Nb
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


module carry_select_block_Nb #(
    parameter N = 8
)(
    input  wire [N-1:0] iA,
    input  wire [N-1:0] iB,
    input  wire         iCarry,  // 本段的实际进位
    output wire [N-1:0] oSum,
    output wire        oCarry
);

    // 预计算两种进位下的局部和与局部进位
    wire [N-1:0] sum0, sum1;
    wire         c0,   c1;

    // 假设进位=0
    carry_lookahead_adder_Nb_new #(.N(N)) cla0 (
        .iA    (iA),
        .iB    (iB),
        .iCarry(1'b0),
        .oSum  (sum0),
        .oCarry(c0)
    );

    // 假设进位=1
    carry_lookahead_adder_Nb_new #(.N(N)) cla1 (
        .iA    (iA),
        .iB    (iB),
        .iCarry(1'b1),
        .oSum  (sum1),
        .oCarry(c1)
    );

    // 根据真正进位选出对应的和与进位
    assign oSum   = iCarry ? sum1 : sum0;
    assign oCarry = iCarry ? c1    : c0;

endmodule

