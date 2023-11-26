`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 12:15:54 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input [4:0] ID_EX_Rs1,
    input [4:0] ID_EX_Rs2,
    input [4:0] EX_MEM_Rd,
    input [4:0] MEM_WB_Rd,
    input [4:0] EX_MEM_Rs2,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB,
    output reg forwardMem
    );
    
    always@(*) begin
    //EX HAZARD
        forwardA = 0;
        forwardB = 0;
        forwardMem = 0;
        if(EX_MEM_RegWrite && (EX_MEM_Rd!=0)&& (EX_MEM_Rd == ID_EX_Rs1)) begin
            forwardA = 2'b10;
        end else if(MEM_WB_RegWrite && (MEM_WB_Rd != 0)&&(MEM_WB_Rd == ID_EX_Rs1) && !(EX_MEM_RegWrite && (EX_MEM_Rd!=0) &&(EX_MEM_Rd==ID_EX_Rs1))) begin
            forwardA =2'b01;
        end else begin
            forwardA = 0;
        end
        
        if(EX_MEM_RegWrite && (EX_MEM_Rd!=0)&& (EX_MEM_Rd == ID_EX_Rs2)) begin
            forwardB = 2'b10;
        end else if(MEM_WB_RegWrite && (MEM_WB_Rd != 0)&&(MEM_WB_Rd == ID_EX_Rs2) && !(EX_MEM_RegWrite && (EX_MEM_Rd!=0) &&(EX_MEM_Rd==ID_EX_Rs2))) begin
            forwardB =2'b01;
        end else begin
            forwardB = 0;
        end
        
        if(MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == EX_MEM_Rs2)) begin
            forwardMem = 1;
        end else forwardMem = 0;
    end
    
endmodule