`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 14:59:18
// Design Name: 
// Module Name: variable_carry_select_adder
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


module variable_carry_select_adder (
    input  wire [127:0] iA,
    input  wire [127:0] iB,
    input  wire         iCarry,   // 全局输入进位
    output wire [127:0] oSum,
    output wire         oCarry    // 全局输出进位
);

    // 总共 5 段：参考 2‐2‐3‐4‐5 设计 ×8 → 16,16,24,32,40
    localparam BW0 = 16;
    localparam BW1 = 16;
    localparam BW2 = 24;
    localparam BW3 = 32;
    localparam BW4 = 40;

    // carry[0] 接外部 iCarry；carry[5] 就是 oCarry
    wire [5:0] carry;
    assign carry[0] = iCarry;

    //--- 段 0: bits [15:0]
    carry_select_block_Nb #(.N(BW0)) csb0 (
        .iA    (iA[15:0]),
        .iB    (iB[15:0]),
        .iCarry(carry[0]),
        .oSum  (oSum[15:0]),
        .oCarry(carry[1])
    );

    //--- 段 1: bits [31:16]
    carry_select_block_Nb #(.N(BW1)) csb1 (
        .iA    (iA[31:16]),
        .iB    (iB[31:16]),
        .iCarry(carry[1]),
        .oSum  (oSum[31:16]),
        .oCarry(carry[2])
    );

    //--- 段 2: bits [55:32]
    carry_select_block_Nb #(.N(BW2)) csb2 (
        .iA    (iA[55:32]),
        .iB    (iB[55:32]),
        .iCarry(carry[2]),
        .oSum  (oSum[55:32]),
        .oCarry(carry[3])
    );

    //--- 段 3: bits [87:56]
    carry_select_block_Nb #(.N(BW3)) csb3 (
        .iA    (iA[87:56]),
        .iB    (iB[87:56]),
        .iCarry(carry[3]),
        .oSum  (oSum[87:56]),
        .oCarry(carry[4])
    );

    //--- 段 4: bits [127:88]
    carry_select_block_Nb #(.N(BW4)) csb4 (
        .iA    (iA[127:88]),
        .iB    (iB[127:88]),
        .iCarry(carry[4]),
        .oSum  (oSum[127:88]),
        .oCarry(carry[5])
    );

    // 最终进位
    assign oCarry = carry[5];

endmodule


