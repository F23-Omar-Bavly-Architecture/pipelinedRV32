`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: ALUControlUnit.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for immediate generator
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module ALUControlUnit(
    input [1:0] ALUOp,
    input [14:12] func3,
    input instruction5,
    input inst30,
    output reg [3:0] ALUSelection
    );
    wire [3:0] caseSelector;
    assign caseSelector = {func3,inst30};
    always@(*) begin
        if(ALUOp == 2'b00) begin
            ALUSelection = `ALU_ADD;
        end else if(ALUOp == 2'b01) begin
            ALUSelection = `ALU_SUB;
        end else if(ALUOp ==2'b10) begin // aluop 10
            /*if(instruction5) begin
                case(caseSelector)
                    4'b0000: ALUSelection = `ALU_ADD;
                    4'b0001: ALUSelection = `ALU_SUB;
                    4'b0010: ALUSelection = `ALU_SLL;
                    4'b0100: ALUSelection = `ALU_SLT; 
                    4'b0110: ALUSelection = `ALU_SLTU;
                    4'b1000: ALUSelection = `ALU_XOR;
                    4'b1010: ALUSelection = `ALU_SRL;
                    4'b1011: ALUSelection = `ALU_SRA;
                    4'b1100: ALUSelection = `ALU_OR;
                    4'b1110: ALUSelection = `ALU_AND;
                    
                    default: ALUSelection = `ALU_PASS;
                endcase
            end else begin
                case(func3)
                    0: ALUSelection = `ALU_ADD;
                    4: ALUSelection = `ALU_XOR;
                    6: ALUSelection = `ALU_OR;
                    7: ALUSelection = `ALU_AND;
                    1: ALUSelection = `ALU_SLL;
                    5: begin
                        if(inst30) begin
                            ALUSelection = `ALU_SRA;
                        end else begin
                            ALUSelection = `ALU_SRL;
                        end
                       end
                    2: ALUSelection = `ALU_SLT;
                    3: ALUSelection = `ALU_SLTU;
                    default: ALUSelection = `ALU_PASS;
                endcase
            
            end*/
            case(func3)
                0: begin
                    ALUSelection = (inst30 && instruction5)? `ALU_SUB : `ALU_ADD;
                end
                1: begin
                    ALUSelection = `ALU_SLL;
                end
                2: begin
                    ALUSelection = `ALU_SLT;
                end
                3: begin
                    ALUSelection = `ALU_SLTU;
                end
                4: begin
                    ALUSelection = `ALU_XOR;
                end
                5: begin
                    ALUSelection = inst30? `ALU_SRA: `ALU_SRL;
                end
                6: begin
                    ALUSelection = `ALU_OR;
                end
                7: begin
                    ALUSelection = `ALU_AND;
                end
                default ALUSelection = `ALU_PASS;
            endcase 
        end else begin
            ALUSelection = `ALU_PASS;
        end
    end
endmodule