`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 11:53:26 AM
// Design Name: 
// Module Name: ripple_carry_adder_4b_TB
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


module ripple_carry_adder_4b_TB();

    reg [3:0]  riA, riB;
    reg rCarry;
    wire [3:0]  wResult;
    wire wCarry;
    
    ripple_carry_adder_4b rca4b_inst (riA, riB, rCarry, wResult, wCarry);
    
    integer i;

    initial
    begin
        $monitor ("(%d + %d + %d) = %d", riA, riB, rCarry, {wCarry, wResult});  
    
        // Use a for loop to apply random values to the input  
        for (i = 0; i < 5; i = i+1) 
        begin  
            riA <= $random;  
            riB <= $random;  
            rCarry <= $random;  
            #10;
        end
        $stop;
    end
    

endmodule
