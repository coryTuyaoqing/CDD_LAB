`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 09:00:50 AM
// Design Name: 
// Module Name: PFA_TB
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

module partial_full_adder_TB;

    // Inputs
    reg iA, iB, iCin;

    // Outputs
    wire oSum, oP, oG;

    // Instantiate the Unit Under Test (UUT)
    partial_full_adder PFA_inst (
        .iA(iA), 
        .iB(iB), 
        .iCin(iCin), 
        .oSum(oSum), 
        .oP(oP), 
        .oG(oG)
    );

    initial begin
        $display("A B Cin | Sum P G");
        $display("--------|--------");

                // Test case 0: 000
        iA = 0; iB = 0; iCin = 0; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 1: 001
        iA = 0; iB = 0; iCin = 1; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 2: 010
        iA = 0; iB = 1; iCin = 0; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 3: 011
        iA = 0; iB = 1; iCin = 1; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 4: 100
        iA = 1; iB = 0; iCin = 0; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 5: 101
        iA = 1; iB = 0; iCin = 1; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 6: 110
        iA = 1; iB = 1; iCin = 0; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        // Test case 7: 111
        iA = 1; iB = 1; iCin = 1; #10;
        $display(" %b %b  %b  |  %b   %b %b", iA, iB, iCin, oSum, oP, oG);

        $stop;
    end

endmodule
