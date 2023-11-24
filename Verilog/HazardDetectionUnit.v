`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 01:45:24 PM
// Design Name: 
// Module Name: HazardDetectionUnit
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


module HazardDetectionUnit(
    input [4:0] IF_ID_Rs1, 
    input [4:0] IF_ID_Rs2,
    input [4:0] ID_EX_Rd,
    input ID_EX_MemRead,
    output reg stall
    );
    always@(*) begin
    //stall = 1'b0;
    if(((IF_ID_Rs1 == ID_EX_Rd) || (IF_ID_Rs2 == ID_EX_Rd)) && (ID_EX_MemRead) && (ID_EX_Rd!=0))
        stall = 1'b1;
    else
        stall = 1'b0;
    
    end
    
endmodule
