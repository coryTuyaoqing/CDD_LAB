`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025
// Design Name: Carry Select Adder Testbench
// Module Name: tb_carry_select_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Testbench for parameterized N-bit Carry Select Adder
// Applies randomized vectors and checks correctness
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_carry_select_adder;
    // Parameters must match DUT defaults or override here
    parameter N      = 16;
    parameter B_SIZE = 4;

    // Inputs to DUT
    reg [N-1:0] A;
    reg [N-1:0] B;
    reg         Cin;

    // Outputs from DUT
    wire [N-1:0] Sum;
    wire         Cout;

    // Instantiate the Device Under Test (DUT)
    carry_select_adder #(
        .N(N),
        .B_SIZE(B_SIZE)
    ) dut (
        .A   (A),
        .B   (B),
        .Cin (Cin),
        .Sum (Sum),
        .Cout(Cout)
    );

    // Reference result
    reg [N:0] reference;

    integer i;

    initial begin
        // Dump waves for GTKWave or similar
        $dumpfile("tb_carry_select_adder.vcd");
        $dumpvars(0, tb_carry_select_adder);

        // Test cases
        for (i = 0; i < 20; i = i + 1
        ) begin
            // Randomize inputs
            A   = $random;
            B   = $random;
            Cin = $random & 1;

            #10; // wait for outputs to settle

            // Compute reference sum
            reference = A + B + Cin;

            // Check correctness
            if ({Cout, Sum} !== reference) begin
                $display("[ERROR] time=%0t A=%0h B=%0h Cin=%0b | Sum=%0h Cout=%0b expected=%0h", 
                         $time, A, B, Cin, Sum, Cout, reference);
                $finish;
            end else begin
                $display("[OK]    time=%0t A=%0h B=%0h Cin=%0b | Sum=%0h Cout=%0b", 
                         $time, A, B, Cin, Sum, Cout);
            end
        end

        $display("All tests passed!");
        $finish;
    end
endmodule
