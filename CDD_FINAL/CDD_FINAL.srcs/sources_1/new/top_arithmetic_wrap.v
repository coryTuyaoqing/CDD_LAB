`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 13:30:25
// Design Name: 
// Module Name: top_arithmetic_wrap
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

module top_arithmetic_wrap #(
    parameter ADDER_WIDTH = 64,
    parameter B_SIZE      = 8
)(
    input  wire               iClk,
    input  wire               iRst,
    input  wire [1:0]         iOperation,  // 00: add, 01: sub, 10: cmp
    output wire [ADDER_WIDTH-1:0] oResult,
    output wire               oCarry,
    output wire               oEqual,
    output wire               oGreater,
    output wire               oLess,
    output wire               oXORResult   // Prevent optimization
);

    // -------------------------------
    // 1. Counter to drive test inputs
    // -------------------------------
    localparam CNT_WIDTH = ADDER_WIDTH * 2 + 1;

    reg [CNT_WIDTH-1:0] rCnt;

    always @(posedge iClk) begin
        if (iRst)
            rCnt <= 0;
        else
            rCnt <= rCnt + 1;
    end

    wire [ADDER_WIDTH-1:0] iA = rCnt[2*ADDER_WIDTH:ADDER_WIDTH+1];
    wire [ADDER_WIDTH-1:0] iB = rCnt[ADDER_WIDTH:1];

    // -------------------------------
    // 2. Instantiate Arithmetic Unit
    // -------------------------------
    wire [ADDER_WIDTH-1:0] result;
    wire carry, eq, gt, lt;

    arithmetic_unit_nbit #(
        .N(ADDER_WIDTH),
        .B_SIZE(B_SIZE)
    ) alu_inst (
        .iA(iA),
        .iB(iB),
        .iOperation(iOperation),
        .oResult(result),
        .oCarry(carry),
        .oEqual(eq),
        .oGreater(gt),
        .oLess(lt)
    );

    assign oResult    = result;
    assign oCarry     = carry;
    assign oEqual     = eq;
    assign oGreater   = gt;
    assign oLess      = lt;

    // -------------------------------
    // 3. XOR Output Bits (Vivado Hack)
    // -------------------------------
    reg [ADDER_WIDTH-1:0] rResult;
    always @(posedge iClk) begin
        rResult <= result;
    end

    assign oXORResult = ^rResult;

endmodule

