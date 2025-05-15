`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 13:35:07
// Design Name: 
// Module Name: top_arithmetic_wrap_TB
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


module top_arithmetic_wrap_TB;

    localparam CLK_PERIOD = 10;
    localparam ADDER_WIDTH = 64;

    // Clock & Reset
    reg iClk;
    reg iRst;
    reg [1:0] iOperation;

    // DUT outputs
    wire [ADDER_WIDTH-1:0] oResult;
    wire oCarry;
    wire oEqual, oGreater, oLess;
    wire oXORResult;

    // DUT input override interface
    wire [ADDER_WIDTH-1:0] iA = dut.iA;
    wire [ADDER_WIDTH-1:0] iB = dut.iB;

    // Instantiate DUT
    top_arithmetic_wrap #(
        .ADDER_WIDTH(ADDER_WIDTH),
        .B_SIZE(8)
    ) dut (
        .iClk(iClk),
        .iRst(iRst),
        .iOperation(iOperation),
        .oResult(oResult),
        .oCarry(oCarry),
        .oEqual(oEqual),
        .oGreater(oGreater),
        .oLess(oLess),
        .oXORResult(oXORResult)
    );

    // Clock generation
    initial iClk = 0;
    always #(CLK_PERIOD / 2) iClk = ~iClk;

    // Force DUT input
    initial begin
        $display("Start 64-bit Arithmetic Unit Simulation");
        iRst = 1;
        #(CLK_PERIOD * 2);
        iRst = 0;

        // ===== Test 1: 64-bit ADD =====
        force dut.rCnt = {64'h0000_0000_0000_0032, 64'h0000_0000_0000_0023, 1'b0};  // A=50, B=35
        iOperation = 2'b00;
        #(CLK_PERIOD);
        $display("[ADD] %0d + %0d = %0d (Expect: 85)", iA, iB, oResult);

        // ===== Test 2: 64-bit SUB =====
        force dut.rCnt = {64'h0000_0000_0000_0064, 64'h0000_0000_0000_0014, 1'b0};  // A=100, B=20
        iOperation = 2'b01;
        #(CLK_PERIOD);
        $display("[SUB] %0d - %0d = %0d (Expect: 80)", iA, iB, oResult);

        // ===== Test 3: CMP Equal =====
        force dut.rCnt = {64'd1000, 64'd1000, 1'b0};
        iOperation = 2'b10;
        #(CLK_PERIOD);
        $display("[CMP EQ] A=%0d, B=%0d -> EQ=%b, GT=%b, LT=%b (Expect: 1 0 0)", iA, iB, oEqual, oGreater, oLess);

        // ===== Test 4: CMP Greater =====
        force dut.rCnt = {64'd2000, 64'd1999, 1'b0};
        iOperation = 2'b10;
        #(CLK_PERIOD);
        $display("[CMP GT] A=%0d, B=%0d -> EQ=%b, GT=%b, LT=%b (Expect: 0 1 0)", iA, iB, oEqual, oGreater, oLess);

        // ===== Test 5: CMP Less =====
        force dut.rCnt = {64'd17, 64'd88, 1'b0};
        iOperation = 2'b10;
        #(CLK_PERIOD);
        $display("[CMP LT] A=%0d, B=%0d -> EQ=%b, GT=%b, LT=%b (Expect: 0 0 1)", iA, iB, oEqual, oGreater, oLess);

        $display("64-bit Arithmetic Test Completed.");
        $stop;
    end

endmodule



