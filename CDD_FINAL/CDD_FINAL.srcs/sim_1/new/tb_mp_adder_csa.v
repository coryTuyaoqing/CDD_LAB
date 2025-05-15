`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 18:09:50
// Design Name: 
// Module Name: tb_mp_adder_csa
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



//////////////////////////////////////////////////////////////////////////////////
// Testbench for mp_adder: tests add, sub, and cmp operations
//////////////////////////////////////////////////////////////////////////////////
module tb_mp_adder_csa;
    // Parameters for quick simulation
    parameter OPERAND_WIDTH = 512;
    parameter ADDER_WIDTH   = 64;
    parameter N_ITERATIONS  = OPERAND_WIDTH / ADDER_WIDTH;
    parameter B_SIZE = 8;

    // Clock and reset
    reg                     iClk;
    reg                     iRst;
    // Inputs to DUT
    reg                     iStart;
    reg  [OPERAND_WIDTH-1:0] iOpA;
    reg  [OPERAND_WIDTH-1:0] iOpB;
    reg  [1:0]              iOperation;
    // Outputs from DUT
    wire [OPERAND_WIDTH:0]  oRes;
    wire                    oDone;

    // Instantiate the DUT
    mp_adder_csa_new #(
        .OPERAND_WIDTH(OPERAND_WIDTH),
        .ADDER_WIDTH(ADDER_WIDTH),
        .B_SIZE(B_SIZE)
    ) dut (
        .iClk       (iClk),
        .iRst       (iRst),
        .iStart     (iStart),
        .iOpA       (iOpA),
        .iOpB       (iOpB),
        .iOperation (iOperation),
        .oRes       (oRes),
        .oDone      (oDone)
    );

    // Clock: 10ns period
    initial begin
        iClk = 0;
        forever #5 iClk = ~iClk;
    end

    // Test sequence
    initial begin
        // Initialize
        iRst       = 1;
        iStart     = 0;
        iOpA       = 0;
        iOpB       = 0;
        iOperation = 2'b00;
        #20;
        iRst = 0;
        #20;

        // Test ADD
        run_test(32'h0000000A, 32'h00000005, 2'b00);
        // Test SUBTRACT (no borrow)
        run_test(32'h0000000F, 32'h00000003, 2'b01);
        // Test SUBTRACT (with borrow)
        run_test(32'h00000003, 32'h00000005, 2'b01);
        // Test CMP equal
        run_test(32'h12345678, 32'h12345678, 2'b10);
        // Test CMP greater
        run_test(32'h000000FF, 32'h0000000F, 2'b10);
        // Test CMP less
        run_test(32'h0000000F, 32'h000000FF, 2'b10);

//// Test ADD
//run_test(512'h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000A, 
//         512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005, 2'b00);

//// Test SUBTRACT (no borrow)
//run_test(512'h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F, 
//         512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003, 2'b01);

//// Test SUBTRACT (with borrow)
//run_test(512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003, 
//         512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005, 2'b01);

//// Test CMP equal
//run_test(512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678, 
//         512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678, 2'b10);

//// Test CMP greater
//run_test(512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FF, 
//         512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F, 2'b10);

//// Test CMP less
//run_test(512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F, 
//         512'h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FF, 2'b10);


        $display("All tests completed.");
        $finish;
    end

    // Task: apply inputs, pulse start, wait oDone, then display
    task run_test;
        input [OPERAND_WIDTH-1:0] a;
        input [OPERAND_WIDTH-1:0] b;
        input [1:0] op;
        begin
            @(negedge iClk);
            iOpA       = a;
            iOpB       = b;
            iOperation = op;
            iStart     = 1;
            @(negedge iClk);
            iStart     = 0;
            // Wait for done
            wait(oDone);
            @(posedge iClk);
            case (op)
                2'b00: $display("ADD: A=%h + B=%h => Res=%h, Carry=%b", a, b, oRes[OPERAND_WIDTH-1:0], oRes[OPERAND_WIDTH]);
                2'b01: $display("SUB: A=%h - B=%h => Res=%h, Borrow=%b", a, b, oRes[OPERAND_WIDTH-1:0], oRes[OPERAND_WIDTH]);
                2'b10: $display("CMP: A=%h ? B=%h => Result MSB=%b, Value=%h", a, b, oRes[OPERAND_WIDTH], oRes[OPERAND_WIDTH-1:0]);
            endcase
            #20;
        end
    endtask
endmodule


