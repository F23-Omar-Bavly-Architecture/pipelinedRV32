`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:39:37 AM
// Design Name: 
// Module Name: NBit2x1Mux
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


module NBit2x1Mux#(parameter N=32)(input [N-1:0]A,input [N-1:0]B, output [N-1:0]out, input S);
    genvar i;
    generate 
        for(i = 0; i<N;i=i+1) begin 
            TwoXOneMux mux_inst(.A(A[i]),.B(B[i]),.out(out[i]),.S(S));
        end
    endgenerate 
endmodule