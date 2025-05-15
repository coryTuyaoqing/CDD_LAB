`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15  
// Design Name: Wrap for Variable Carry-Select Adder
// Module Name: wrap_variable_carry_select_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Wrap around the 128-bit variable_carry_select_adder.
//   Feeds operands and carry-in from a free-running counter,
//   registers the outputs, and XORs the sum bits to
//   prevent optimizer removal.
// 
// Dependencies: variable_carry_select_adder.v
// 
//////////////////////////////////////////////////////////////////////////////////

module wrap_variable_carry_select_adder #(
    parameter ADDER_WIDTH = 128  // must match the CSA width
)(
    input  wire             iClk,
    input  wire             iRst,
    output wire             oXORResult,
    output reg              oCarryOut
);

    // counter width = A width + B width + carry in
    localparam COUNTER_LENGTH = ADDER_WIDTH + ADDER_WIDTH + 1;
    
    // free-running wrap-around counter
    reg [COUNTER_LENGTH-1:0] rCnt;
    always @(posedge iClk) begin
        if (iRst)
            rCnt <= {COUNTER_LENGTH{1'b0}};
        else
            rCnt <= rCnt + 1'b1;
    end

    // break counter into A, B and carry-in
    wire [ADDER_WIDTH-1:0] wA      = rCnt[2*ADDER_WIDTH   : ADDER_WIDTH+1];
    wire [ADDER_WIDTH-1:0] wB      = rCnt[ADDER_WIDTH     : 1];
    wire                  wCin    = rCnt[0];

    // instantiate the 128-bit variable carry-select adder
    wire [ADDER_WIDTH-1:0] wSum;
    wire                   wCout;
    variable_carry_select_adder u_csa (
        .iA    (wA),
        .iB    (wB),
        .iCarry(wCin),
        .oSum  (wSum),
        .oCarry(wCout)
    );

    // register the outputs for R-to-R timing
    reg [ADDER_WIDTH-1:0] rSum;
    always @(posedge iClk) begin
        if (iRst) begin
            rSum      <= {ADDER_WIDTH{1'b0}};
            oCarryOut <= 1'b0;
        end else begin
            rSum      <= wSum;
            oCarryOut <= wCout;
        end
    end

    // XOR all sum bits to keep the logic alive
    assign oXORResult = ^rSum;

endmodule
