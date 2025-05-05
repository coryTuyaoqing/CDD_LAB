// Parameterized ripple-carry block using full adders
module carry_select_block #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire            Cin,
    output wire [WIDTH-1:0] Sum,
    output wire            Cout
);
    wire [WIDTH:0] c;
    assign c[0] = Cin;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : FA_LOOP
            full_adder u_fa (
                .iA   (A[i]),
                .iB   (B[i]),
                .iCin (c[i]),
                .oSum (Sum[i]),
                .oCout(c[i+1])
            );
        end
    endgenerate
    assign Cout = c[WIDTH];
endmodule