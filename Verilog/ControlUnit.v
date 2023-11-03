`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:34:18 AM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(input [6:2] inst,output Branch, output MemRead, output MemtoReg, output [1:0] ALUOp, output MemWrite, output ALUSrc, output RegWrite );
    assign Branch = inst[6];
    assign MemRead = !inst;
    assign MemtoReg = MemRead;
    assign ALUOp[1] = inst[4];
    assign ALUOp[0] = inst[6];
    assign MemWrite = (inst == 5'b01000);
    assign ALUSrc = MemRead || MemWrite;
    assign RegWrite = MemRead || inst[4];
endmodule
