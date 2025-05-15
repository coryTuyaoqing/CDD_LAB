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
// Description: 通用的 N 位加/减/比较单元，支持外部进位（借位）输入
// 
// Dependencies: carry_select_adder
// 
//////////////////////////////////////////////////////////////////////////////////
module arithmetic_unit_nbit #(
    parameter N      = 64,
    parameter B_SIZE = 8
)(
    input  wire [N-1:0] iA,
    input  wire [N-1:0] iB,
    input  wire [1:0]   iOperation,  // 00: add, 01: sub, 10: cmp
    input  wire         iCarryIn,    // ← 新增：外部进位/借位输入
    output wire [N-1:0] oResult,
    output wire         oCarry,
    output wire         oEqual,
    output wire         oGreater,
    output wire         oLess
);

    // 如果是减法或比较，将 iB 全位取反；否则原样传入
    wire isSub = (iOperation == 2'b01 || iOperation == 2'b10);
    wire [N-1:0] B_mux = iB ^ {N{isSub}};
    
    // 直接使用外部给定的初始进位/借位
    wire carry_in = iCarryIn;
    
    // 真正做 N 位加法的 Carry-Select Adder
    wire [N-1:0] sum;
    wire         final_carry;
    carry_select_adder #(.N(N), .B_SIZE(B_SIZE)) u_csa (
        .iA(iA),
        .iB(B_mux),
        .iCarry(carry_in),
        .oSum(sum),
        .oCarry(final_carry)
    );

    // oResult 只在加/减时有效
    assign oResult = sum;
    assign oCarry  = final_carry;

    // 比较（cmp）模式下，根据 A-B 的结果做标志
    assign oEqual   = (iOperation == 2'b10) ? (sum == 0)                             : 1'b0;
    assign oLess    = (iOperation == 2'b10) ? sum[N-1]                                : 1'b0;
    assign oGreater = (iOperation == 2'b10) ? (~sum[N-1] && (sum != 0))               : 1'b0;

endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2025/05/15 13:17:35
//// Design Name: 
//// Module Name: arithmetic_unit_nbit
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module arithmetic_unit_nbit #(
//    parameter N = 64,
//    parameter B_SIZE = 8
//)(
//    input  wire [N-1:0] iA,
//    input  wire [N-1:0] iB,
//    input  wire [1:0]   iOperation,  // 00: add, 01: sub, 10: cmp
//    output wire [N-1:0] oResult,
//    output wire         oCarry,
//    output wire         oEqual,
//    output wire         oGreater,
//    output wire         oLess
//);

//    wire [N-1:0] B_mux;
//    wire         carry_in;
//    wire [N-1:0] sum;
//    wire         final_carry;
//    wire isSub = (iOperation == 2'b01 || iOperation == 2'b10);


//    // 选择加法或减法（减法为 A + ~B + 1）
////    assign B_mux   = (iOperation == 2'b01 || iOperation == 2'b10) ? ~iB : iB;
////    assign carry_in = (iOperation == 2'b01 || iOperation == 2'b10) ? 1'b1 : 1'b0;
    
//    assign B_mux = iB ^ {N{isSub}};
//    assign carry_in = isSub;


//    // 调用 Carry Select Adder
//    carry_select_adder #(.N(N), .B_SIZE(B_SIZE)) u_csa (
//        .iA(iA),
//        .iB(B_mux),
//        .iCarry(carry_in),
//        .oSum(sum),
//        .oCarry(final_carry)
//    );

//    // 输出结果（只有加法和减法使用）
//    assign oResult = (iOperation == 2'b00 || iOperation == 2'b01) ? sum : {N{1'b0}};
//    assign oCarry  = final_carry;

//    // 比较逻辑（基于 A - B 的结果）
//    assign oEqual   = (iOperation == 2'b10) ? (sum == 0) : 1'b0;
//    assign oLess    = (iOperation == 2'b10) ? sum[N-1] : 1'b0;
//    assign oGreater = (iOperation == 2'b10) ? (~sum[N-1] & ~(sum == 0)) : 1'b0;

//endmodule

