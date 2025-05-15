`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 13:17:35
// Design Name: 
// Module Name: arithmetic_unit_nbit
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


module arithmetic_unit_nbit #(
    parameter N = 64,
    parameter B_SIZE = 8
)(
    input  wire [N-1:0] iA,
    input  wire [N-1:0] iB,
    input  wire [1:0]   iOperation,  // 00: add, 01: sub, 10: cmp
    output wire [N-1:0] oResult,
    output wire         oCarry,
    output wire         oEqual,
    output wire         oGreater,
    output wire         oLess
);

    wire [N-1:0] B_mux;
    wire         carry_in;
    wire [N-1:0] sum;
    wire         final_carry;
    wire isSub = (iOperation == 2'b01 || iOperation == 2'b10);


    // 选择加法或减法（减法为 A + ~B + 1）
//    assign B_mux   = (iOperation == 2'b01 || iOperation == 2'b10) ? ~iB : iB;
//    assign carry_in = (iOperation == 2'b01 || iOperation == 2'b10) ? 1'b1 : 1'b0;
    
    assign B_mux = iB ^ {N{isSub}};
    assign carry_in = isSub;


    // 调用 Carry Select Adder
    carry_select_adder #(.N(N), .B_SIZE(B_SIZE)) u_csa (
        .iA(iA),
        .iB(B_mux),
        .iCarry(carry_in),
        .oSum(sum),
        .oCarry(final_carry)
    );

    // 输出结果（只有加法和减法使用）
    assign oResult = (iOperation == 2'b00 || iOperation == 2'b01) ? sum : {N{1'b0}};
    assign oCarry  = final_carry;

    // 比较逻辑（基于 A - B 的结果）
    assign oEqual   = (iOperation == 2'b10) ? (sum == 0) : 1'b0;
    assign oLess    = (iOperation == 2'b10) ? sum[N-1] : 1'b0;
    assign oGreater = (iOperation == 2'b10) ? (~sum[N-1] & ~(sum == 0)) : 1'b0;

endmodule

