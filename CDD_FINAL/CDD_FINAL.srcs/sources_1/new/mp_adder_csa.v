`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/15 22:25:02
// Design Name: 
// Module Name: mp_adder_csa_new
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


module mp_adder_csa #(
      // to avoid extra complexity, it is best that OPERAND_WIDTH is a multiple of ADDER_WIDTH
      parameter OPERAND_WIDTH = 512,
      parameter ADDER_WIDTH   = 64,
      parameter N_ITERATIONS  = OPERAND_WIDTH / ADDER_WIDTH,
      parameter B_SIZE = 8
    )(
    input  wire                       iClk,
    input  wire                       iRst,
    input  wire                       iStart,
    input  wire [OPERAND_WIDTH-1:0]   iOpA,
    input  wire [OPERAND_WIDTH-1:0]   iOpB,
    input  wire [1:0]                 iOperation, // 00=add, 01=sub, 10=cmp
    output wire [OPERAND_WIDTH:0]     oRes,
    output wire                       oDone
);

    // Internal flags
    wire isSub = (iOperation == 2'b01 || iOperation == 2'b10);

    // Describe an OPERAND_WIDTH-bit register for A
    wire [OPERAND_WIDTH-1:0] regA_D;
    reg  [OPERAND_WIDTH-1:0] regA_Q;
    always @(posedge iClk) begin
        if (iRst)      regA_Q <= {OPERAND_WIDTH{1'b0}};
        else           regA_Q <= regA_D;
    end

    // Describe an OPERAND_WIDTH-bit register for B
    wire [OPERAND_WIDTH-1:0] regB_D;
    reg  [OPERAND_WIDTH-1:0] regB_Q;
    always @(posedge iClk) begin
        if (iRst)      regB_Q <= {OPERAND_WIDTH{1'b0}};
        else           regB_Q <= regB_D;
    end

    // Mux for A
    reg          muxA_sel;
    assign regA_D = (muxA_sel == 0) ? iOpA : {{ADDER_WIDTH{1'b0}}, regA_Q[OPERAND_WIDTH-1:ADDER_WIDTH]};

    // Mux for B (invert when subtract/compare)
    reg          muxB_sel;
    wire [OPERAND_WIDTH-1:0] B_inv = ~regB_Q;
    assign regB_D = (muxB_sel == 0)
                    ? iOpB
                    : {{ADDER_WIDTH{1'b0}}, regB_Q[OPERAND_WIDTH-1:ADDER_WIDTH]};

    // Slice operands for ripple adder
    wire [ADDER_WIDTH-1:0] operandA = regA_Q[ADDER_WIDTH-1:0];
//    wire [ADDER_WIDTH-1:0] operandB = operandB_mux;
    wire [ADDER_WIDTH-1:0] operandB_mux = isSub ? (regB_Q[ADDER_WIDTH-1:0] ^ {ADDER_WIDTH{1'b1}}) : regB_Q[ADDER_WIDTH-1:0];

    // Instantiate the combinational ripple adder
    wire [ADDER_WIDTH-1:0] result;
    wire                  carry_out;

    // Carry register
    reg regCout;
    always @(posedge iClk) begin
        if (iRst)      regCout <= 1'b0;
        else           regCout <= carry_out;
    end
    
    // Carry-in selection: for first iteration, use isSub; thereafter, use regCout
    reg  muxCarry_sel;
    wire carry_in = (muxCarry_sel == 0) ? isSub : regCout;


    arithmetic_unit_nbit #(.N(ADDER_WIDTH), .B_SIZE(B_SIZE)) au_inst (
        .iA    (operandA),
        .iB    (operandB_mux),
        .iOperation(iOperation),
        .iCarryIn(carry_in),
//        .oSum  (result),
        .oCarry(carry_out),
        .oResult(result),
        .oEqual(),
        .oGreater(),
        .oLess()
    );

    // Result shift register
    reg [OPERAND_WIDTH-1:0] regResult;
    always @(posedge iClk) begin
        if (iRst)      regResult <= {OPERAND_WIDTH{1'b0}};
        else           regResult <= {result, regResult[OPERAND_WIDTH-1:ADDER_WIDTH]};
    end



    // Output assignment
    assign oRes = {regCout, regResult};

    // FSM states
    localparam s_IDLE      = 3'b000,
               s_STORE_OPS = 3'b001,
               s_ADD_FIRST = 3'b010,
               s_ADD_WORDS = 3'b011,
               s_DONE      = 3'b100;
    reg [2:0] rFSM_current, wFSM_next;
    reg [$clog2(N_ITERATIONS):0] rCnt_Current, wCnt_next;
    reg regDone;

    // State and counter update
    always @(posedge iClk) begin
        if (iRst) begin
            rFSM_current <= s_IDLE;
            rCnt_Current <= 0;
            regDone      <= 1'b0;
        end else begin
            rFSM_current <= wFSM_next;
            rCnt_Current <= wCnt_next;
            regDone      <= (wFSM_next == s_DONE)? 1'b1 : 1'b0;
        end
    end
    assign oDone = regDone;

    // Next-state logic and control signals
    always @(*) begin
        // defaults
        
        
        case (rFSM_current)
            s_IDLE: begin
            
                muxA_sel     = 1'b0;
                muxB_sel     = 1'b0;
                muxCarry_sel = 1'b0;
                wCnt_next    = 0;

//                wCnt_next    = rCnt_Current;
//                wFSM_next    = s_IDLE;
                
                if (iStart) begin
                    wFSM_next = s_STORE_OPS;
                    wCnt_next = 0;
                end else begin
                    wFSM_next = s_IDLE;
                end
            end
            s_STORE_OPS: begin
                muxA_sel     = 1'b0;
                muxB_sel     = 1'b0;
                muxCarry_sel = 1'b0;
                wFSM_next    = s_ADD_FIRST;
                wCnt_next    = rCnt_Current + 1;
            end
            s_ADD_FIRST: begin
                muxA_sel     = 1'b1;
                muxB_sel     = 1'b1;
                // initial carry_in = isSub (0 for add, 1 for sub/cmp)
                muxCarry_sel = 1'b0;
                wFSM_next    = s_ADD_WORDS;
                wCnt_next    = rCnt_Current + 1;
            end
            s_ADD_WORDS: begin
                muxA_sel     = 1'b1;
                muxB_sel     = 1'b1;
                // subsequent carry_in = regCout
                muxCarry_sel = 1'b1;
                wCnt_next    = rCnt_Current + 1;
                if (rCnt_Current < N_ITERATIONS-1)
                    wFSM_next = s_ADD_WORDS;
                else
                    wFSM_next = s_DONE;
            end
            s_DONE: begin
                muxA_sel     = 1'b1;
                muxB_sel     = 1'b1;
                muxCarry_sel = 1'b1;
                wCnt_next    = 0;
                wFSM_next    = s_IDLE;
            end
            default: begin
//                wFSM_next    = s_IDLE;
                wCnt_next    = 0;
                muxA_sel = 0;
                muxB_sel = 0;
                muxCarry_sel = 0;

            end
        endcase
    end

endmodule
