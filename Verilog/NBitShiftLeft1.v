`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:38:54 AM
// Design Name: 
// Module Name: NBitShiftLeft1
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


module NBitShiftLeft1 #(parameter N = 32) (input [N-1 : 0] X, output [N-1 : 0] Y);
    assign Y = {X[N-2:0],1'b0};
endmodule
