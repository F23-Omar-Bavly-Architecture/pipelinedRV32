`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:33:40 AM
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(
    input [1:0] ALUOp,
    input [14:12] inst,
    input inst30,
    output reg [3:0] ALUSelection
    );
    wire [3:0] caseSelector;
    assign caseSelector = {inst,inst30};
    always@(*) begin
        if(ALUOp == 2'b00) begin
            ALUSelection = 4'b0010;
        end else if(ALUOp == 2'b01) begin
            ALUSelection = 4'b0110;
        end else begin // aluop 10
            case(caseSelector)
                4'b0000: ALUSelection = 4'b0010;
                4'b0001: ALUSelection = 4'b0110;
                4'b1110: ALUSelection = 4'b0000;
                4'b1100: ALUSelection = 4'b0001;
                default: ALUSelection = 4'b1111;
            endcase 
        end
    end
endmodule