`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 08:58:53 AM
// Design Name: 
// Module Name: ripple_carry_adder_Nb_TB
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


module ripple_carry_adder_Nb_TB();
    localparam ADDER_WIDTH=16;

    reg [ADDER_WIDTH-1:0]  riA, riB;
    reg rCarry;
    wire [ADDER_WIDTH-1:0]  wResult;
    wire wCarry;
    
    ripple_carry_adder_Nb #(ADDER_WIDTH) 
    rcaNb_inst (riA, riB, rCarry, wResult, wCarry);
    
    integer i;

    initial
    begin
        $monitor ("(%d + %d + %d) = %d", riA, riB, rCarry, {wCarry, wResult});  
    
        // Use a for loop to apply random values to the input  
        for (i = 0; i < 16; i = i+1) 
        begin  
            riA <= $random;  
            riB <= $random;  
            rCarry <= $random;  
            #10;
        end
        $stop;
    end


endmodule
