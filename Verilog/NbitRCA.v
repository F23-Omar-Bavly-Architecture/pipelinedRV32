`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:37:07 AM
// Design Name: 
// Module Name: NbitRCA
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


module NbitRCA #(N=8)(
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,
    output [N-1:0] Sum,
    output Cout
    );
    
    wire [N:0] Carrys;
    //assign Carrys[0]=1'b0;
    
    assign Carrys[0] = Cin;
    genvar i;
    
    generate
        for(i=0;i<N;i=i+1) begin
            FullAdder inst(.A(A[i]),.B(B[i]),.Cin(Carrys[i]),.Sum(Sum[i]),.Cout(Carrys[i+1]));
        end
    endgenerate
    
    
    assign Cout = Carrys[N];
    
endmodule
