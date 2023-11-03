`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: ImmGen.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for immediate generator
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module ImmGen( input [31:0] instruction, output reg [31:0] Imm);
    /*
    //reg [31:0] gen_out;
    always@(*) begin
        if(inst[6]==1'b1) begin
        // beq
        gen_out[11:0] = {inst[31], inst[7], inst[30:25], inst[11:8]};
        end else if(inst[5]==1'b1) begin
        // sw
        gen_out[11:0] = {inst[31:25],inst[11:7]};
        end else begin
        // lw
        gen_out[11:0] = inst[31:20];
        end
        gen_out[31:12] = {20{gen_out[11]}};
    end
    */
    always @(*) begin
	case (`OPCODE)
		`OPCODE_Arith_I   : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };
		`OPCODE_Store     :     Imm = { {21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7] };
		`OPCODE_LUI       :     Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };
		`OPCODE_AUIPC     :     Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };
		`OPCODE_JAL       : 	Imm = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0 };
		`OPCODE_JALR      : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };
		`OPCODE_Branch    : 	Imm = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
		default           : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] }; // IMM_I
	endcase 
end
    
endmodule
