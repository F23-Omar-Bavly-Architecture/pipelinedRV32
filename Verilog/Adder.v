`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 05:53:49 PM
// Design Name: 
// Module Name: Adder
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


module Adder(
    input [31:0] input_1,
    input [31:0] input_0,
    input Carry_in,
    output [31:0] Sum,
    output Carry_out
    );
    
    assign {Carry_out,Sum} = input_0 + input_1 + Carry_in;
    
endmodule
