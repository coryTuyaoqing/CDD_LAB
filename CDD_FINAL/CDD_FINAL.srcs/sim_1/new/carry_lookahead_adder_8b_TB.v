`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2025 07:39:06 PM
// Design Name: 
// Module Name: carry_lookahead_adder_8b_TB
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


module carry_lookahead_adder_8b_TB;

    reg [7:0]  riA, riB;
    reg rCarry;
    wire [7:0]  wResult;
    wire wCarry;
    
    carry_lookahead_adder_8b CLA_init(riA, riB, rCarry, wResult, wCarry);
    
    integer i;

    initial
    begin
        $monitor ("(%d + %d + %d) = %d", riA, riB, rCarry, {wCarry, wResult});  
    
        // Use a for loop to apply random values to the input  
        for (i = 0; i < 10; i = i+1) 
        begin  
            riA <= $random;  
            riB <= $random;  
            rCarry <= $random;  
            #10;
        end
        $stop;
    end

endmodule
