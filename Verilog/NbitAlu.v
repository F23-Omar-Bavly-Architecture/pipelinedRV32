`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:36:20 AM
// Design Name: 
// Module Name: NbitAlu
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


module NbitAlu#(parameter N= 32)(
    input[N-1:0] A,
    input[N-1:0] B,
    input [3:0]S,
    output reg [N-1:0] out,
    output Zflag
    );
    wire [N-1:0] Sum, RCAinput2, AND, OR;
    wire Cout; // told to ignore this
    assign RCAinput2 = S[2] ? ~B : B; 
    NbitRCA#(N) rcaInst (.A(A),.B(RCAinput2),.Sum(Sum),.Cin(S[2]),.Cout(Cout));
    assign AND = A & B;
    assign OR = A | B;
    always@(*) begin
        case(S)
            4'b0010: begin
                //add
                out = Sum;
            end
            4'b0110: begin
                //sub
                out = Sum;
            end
            4'b0000: begin
                //and
                out = AND;
            end
            4'b0001: begin
                //or
                out = OR;
            end
            default: out = 0;
    
        endcase
    end
    assign Zflag = out ? 1'b0: 1'b1;
endmodule
