`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 06:03:29 PM
// Design Name: 
// Module Name: carry_lookahead_adder_16b_TB
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


module carry_lookahead_adder_16b_TB;

    reg [15:0]  riA, riB;
    reg rCarry;
    wire [15:0]  wResult;
    wire wCarry;
    
    carry_lookahead_adder_16b CLA_init(riA, riB, rCarry, wResult, wCarry);
    
    integer i;

    initial
    begin
        $monitor ("(%d + %d + %d) = %d", riA, riB, rCarry, {wCarry, wResult});  
    
        // Use a for loop to apply random values to the input  
        for (i = 0; i < 10; i = i+1) 
        begin  
            riA <= $random % 65536;  
            riB <= $random % 65536;  
            rCarry <= $random % 2;  
            #10;
        end
        $stop;
    end

endmodule
