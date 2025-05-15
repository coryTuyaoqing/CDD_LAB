`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 09:13:04 AM
// Design Name: 
// Module Name: uart_top
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

module uart_top #(
    parameter   OPERAND_WIDTH = 512,
    parameter   ADDER_WIDTH   = 64,
    parameter   NBYTES        = OPERAND_WIDTH / 8,    
    // values for the UART (in case we want to change them)
    parameter   CLK_FREQ      = 125_000_000,
    parameter   BAUD_RATE     = 115_200
)  
(
    input   wire   iClk, iRst,
    input   wire   iRx,
    output  wire   oTx
);
  
  // Buffer that store iOp, iOpA, iOpB, and result for mp_adder
  reg [7:0]          rOp;
  reg [NBYTES*8-1:0] rA;
  reg [NBYTES*8-1:0] rB;
  reg [(NBYTES+1)*8-1:0]   rBuffer;
  
  // State definition  
  localparam s_IDLE         = 3'b000;
  localparam s_WAIT_RX_OP   = 3'b001;
  localparam s_WAIT_RX_A    = 3'b010;
  localparam s_WAIT_RX_B    = 3'b011;                            
  localparam s_ADD          = 3'b100;
  localparam s_TX           = 3'b101;
  localparam s_WAIT_TX      = 3'b110;
  localparam s_DONE         = 3'b111;
   
  // Declare all variables needed for the finite state machine 
  // -> the FSM state
  reg [2:0]   rFSM;  
  
  // Connection to UART TX (inputs = registers, outputs = wires)
  reg         rTxStart;
  reg [7:0]   rTxByte;
  
  wire        wTxBusy;
  wire        wTxDone;

  wire        wRxDone;
  wire [7:0]  wRxByte;
  
  wire [OPERAND_WIDTH:0] wAddRes;
  wire          wAddDone;
  reg           rAddStart;
      
  uart_tx #(  .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) )
  UART_TX_INST
    (.iClk(iClk),
     .iRst(iRst),
     .iTxStart(rTxStart),
     .iTxByte(rTxByte),
     .oTxSerial(oTx),
     .oTxBusy(wTxBusy),
     .oTxDone(wTxDone)
     );

  uart_rx #( .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) ) 
  UART_RX_INST
    (.iClk(iClk),
     .iRst(iRst),
     .iRxSerial(iRx),
     .oRxByte(wRxByte),
     .oRxDone(wRxDone)
     );
     
  mp_adder_csa_new #( .OPERAND_WIDTH(OPERAND_WIDTH), .ADDER_WIDTH(ADDER_WIDTH) )
  mp_adder_INST
  ( .iClk(iClk), .iRst(iRst), .iStart(rAddStart), .iOpA(rA), .iOpB(rB), .iOperation(rOp[1:0]), .oRes(wAddRes), .oDone(wAddDone) );
     
  reg [$clog2(NBYTES+1):0] rCnt;
  
  always @(posedge iClk)
  begin
  
  // reset all registers upon reset
  if (iRst == 1 ) 
    begin
      rFSM <= s_IDLE;
      rTxStart <= 0;
      rCnt <= 0;
      rTxByte <= 0;
      rA <= 0;
      rB <= 0;
      rOp <= 0;
    end 
  else 
    begin
      case (rFSM)
   
        s_IDLE :
          begin
            rFSM <= s_WAIT_RX_OP;
            rCnt <= 0;
          end
          
        s_WAIT_RX_OP:
            begin
                if(wRxDone == 1) begin
                    rOp <= wRxByte; // store opration byte into rOp
                    rFSM <= s_WAIT_RX_A; // jump to next state to receive first operand
                end
                else begin
                    rFSM <= s_WAIT_RX_OP; // nothing happen
                end
                
            end
          
        s_WAIT_RX_A :
          begin
            if (rCnt < NBYTES) begin
              if (wRxDone == 1) begin
                rA <= {rA[NBYTES*8-9:0] , wRxByte}; // shift left 1 byte and add wRxByte to the LSB
                rCnt <= rCnt + 1;
              end
                rFSM <= s_WAIT_RX_A;
            end
            else begin
              rFSM <= s_WAIT_RX_B;
              rCnt <= 0;
            end
          end
          
        s_WAIT_RX_B:
          begin
            if (rCnt < NBYTES) begin
              if (wRxDone == 1) begin
                rB <= {rB[NBYTES*8-9:0] , wRxByte}; // shift left 1 byte and add wRxByte to the LSB
                rCnt <= rCnt + 1;
              end
                rFSM <= s_WAIT_RX_B;
            end
            else begin
              rAddStart <= 1; // start mp_adder
              rCnt <= 0;
              rFSM <= s_ADD;
            end
          end
          
        s_ADD:
          begin
            rAddStart <= 0;
            if (wAddDone) begin
              rBuffer <= {7'b000_0000 , wAddRes};
              rFSM <= s_TX;
            end
            else begin
              rFSM <= s_ADD;
            end
          end
             
        s_TX :
          begin
            if ( (rCnt < NBYTES+1) && (wTxBusy ==0) ) 
              begin
                rFSM <= s_WAIT_TX;
                rTxStart <= 1; 
                rTxByte <= rBuffer[(NBYTES+1)*8-1:(NBYTES+1)*8-8];            // we send the uppermost byte
                rBuffer <= {rBuffer[(NBYTES+1)*8-9:0] , 8'b0000_0000};    // we shift from right to left
                rCnt <= rCnt + 1;
              end 
            else 
              begin
                rFSM <= s_DONE;
                rTxStart <= 0;
                rTxByte <= 0;
                rCnt <= 0;
              end
            end 
            
        s_WAIT_TX :
          begin
            if (wTxDone) begin
              rFSM <= s_TX;
            end else begin
              rFSM <= s_WAIT_TX;
              rTxStart <= 0;                   
            end
          end 
          
        s_DONE :
          begin
            rFSM <= s_IDLE;
          end 

        default :
          rFSM <= s_IDLE;
             
          endcase
      end
    end       
    
endmodule
