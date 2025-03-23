`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 11:28:03 AM
// Design Name: 
// Module Name: full_adder_TB
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


module full_adder_TB();

    reg iA, iB, iCin;
    wire oSum, oCout;
    
    full_adder full_adder_inst (iA, iB, iCin, oSum, oCout);
    
    initial
    begin
        iA = 0; iB = 0; iCin = 0;
        # 10;
        iA = 0; iB = 0; iCin = 1;
        # 10;
        iA = 0; iB = 1; iCin = 0;
        # 10;
        iA = 0; iB = 1; iCin = 1;
        # 10;
        iA = 1; iB = 0; iCin = 0;
        # 10;
        iA = 1; iB = 0; iCin = 1;
        # 10;
        iA = 1; iB = 1; iCin = 0;
        # 10;
        iA = 1; iB = 1; iCin = 1;
        # 10;
        
        $stop;
    end

endmodule
