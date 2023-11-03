`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: ControlUnit.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting the control unit
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module ControlUnit(
    input [`IR_opcode] instruction_opcode, 
    input inst20, 
    output reg Branch, 
    output reg MemRead, 
    output reg MemtoReg, 
    output reg [1:0] ALUOp, 
    output reg MemWrite, 
    output reg ALUSrc, 
    output reg RegWrite, 
    output reg PCWrite,
    output reg [1:0] rfWriteSelect
    );
    
/*    assign Branch = instruction_opcode[6];
    assign MemRead = !instruction_opcode;
    assign MemtoReg = MemRead;
    *//*assign ALUOp[1] = instruction_opcode[4];
    assign ALUOp[0] = instruction_opcode[6];*//**/
    always@(*) begin
        case(instruction_opcode)
            `OPCODE_JALR:begin
                            ALUOp = `ALUOP_ADD;
                            Branch = 1'b1;
                            MemRead =1'b0;
                            MemtoReg =1'b0;// Dont care
                            MemWrite =1'b0;
                            ALUSrc = 1'b1;
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'd3;
                        end
            `OPCODE_Branch:begin
                            ALUOp = `ALUOP_SUB;     //BLTU and BGEU ??????
                            Branch =1'b1;
                            MemRead =1'b0;
                            MemtoReg =1'b0; // DC
                            MemWrite =1'b0;
                            ALUSrc =1'b0;
                            RegWrite =1'b0;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                          end
            `OPCODE_Load:begin
                            ALUOp = `ALUOP_ADD;     //sign Extension???????
                            Branch =1'b0;
                            MemRead =1'b1;
                            MemtoReg =1'b1;
                            MemWrite =1'b0;
                            ALUSrc =1'b1;
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                        end
            `OPCODE_Store:begin
                            ALUOp = `ALUOP_ADD;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;// DC
                            MemWrite =1'b1;
                            ALUSrc =1'b1;
                            RegWrite =1'b0;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                         end
            `OPCODE_Arith_I:begin     
                            ALUOp = `ALUOP_FUNC;    //unsigned ???????????????
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg = 1'b0;
                            MemWrite = 1'b0;
                            ALUSrc = 1'b1;
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                           end
            `OPCODE_Arith_R:begin
                            ALUOp = `ALUOP_FUNC;    //unsigned ???????????????
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b0;
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                           end
            `OPCODE_SYSTEM:begin      
                            ALUOp = `ALUOP_FUNC;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b1;
                            RegWrite =1'b0; // so that register files dont change
                            PCWrite = ~inst20;
                            rfWriteSelect = 2'b0;
                           end
            `OPCODE_FENCE:begin
                            ALUOp = `ALUOP_ADD;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b0;
                            RegWrite =1'b0;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                         end
            `OPCODE_JAL: begin
                            ALUOp = `ALUOP_ADD;
                            Branch =1'b1;
                            MemRead =1'b0;
                            MemtoReg =1'b0; // dont care
                            MemWrite =1'b0;
                            ALUSrc =1'b0; // dont care
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'd3;
                        end
            `OPCODE_AUIPC: begin
                            ALUOp = 2'b11;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b0;
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'd2;
                        end
            `OPCODE_LUI: begin
                            ALUOp = 2'b11;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b0; // dont care
                            RegWrite =1'b1;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'd1;
                        end
            default: begin
                            ALUOp = 2'b11;
                            Branch =1'b0;
                            MemRead =1'b0;
                            MemtoReg =1'b0;
                            MemWrite =1'b0;
                            ALUSrc =1'b0;
                            RegWrite =1'b0;
                            PCWrite = 1'b1;
                            rfWriteSelect = 2'b0;
                     end
        endcase
    end
    /*assign MemWrite = (instruction_opcode == 5'b01000);
    assign ALUSrc = MemRead || MemWrite;
    assign RegWrite = MemRead || instruction_opcode[4];*/
endmodule
