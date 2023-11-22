`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 07:01:26 PM
// Design Name: 
// Module Name: SSDGenerator
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


module SSDGenerator(
input [3:0] ssd_Selection,
input[12:0] PCOutput,
input[12:0] Pc4Out,
input[12:0] BranchTarget,
input[12:0] PCInput,
input[12:0] Rs1Read,
input[12:0] Rs2Read,
input[12:0] RegFileInputData,
input[12:0] ImmGenOut,
input[12:0] Alu2ndSource,
input[12:0] AluOut,
input[12:0] MemOut,
output reg [12:0] ssd);
    always@(*) begin
        case(ssd_Selection)
            0: begin
                ssd= PCOutput;
            end
            1: begin
                ssd= Pc4Out;
            end
            2: begin
                ssd= BranchTarget;
            end
            3: begin
                ssd= PCInput;
            end
            4: begin
                ssd= Rs1Read;
            end
            5: begin
                ssd= Rs2Read;
            end
            6: begin
                ssd= RegFileInputData;
            end
            7: begin
                ssd=  ImmGenOut;
            end
            8: begin
                ssd= Alu2ndSource;
            end
            9: begin
                ssd= AluOut;
            end
            10: begin
                ssd= MemOut;
            end
            default: begin
                ssd= 0;
            end
        endcase
    end
endmodule
