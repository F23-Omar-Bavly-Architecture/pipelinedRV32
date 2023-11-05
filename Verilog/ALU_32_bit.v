`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: ALU_32_bit.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a 32 bit arithimitic logic unit
*
* Change history:   11/3/2023 - Import from Supproting Code
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/

module ALU_32_bit(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	input wire instruction5,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    wire signed  [31:0] a_s;
    assign a_s = a;
    wire signed [4:0]  shamt_s;
    assign shamt_s =  shamt;
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    //wire[31:0] sh;
    //shifter shifter_inst(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD : r = add;
            `ALU_SUB : r = add;
            `ALU_PASS : r = b;
            // logic
            `ALU_OR:  r = a | b;
            `ALU_AND:  r = a & b;
            `ALU_XOR:  r = a ^ b;
            // shift
            `ALU_SRL:begin  
                        if(instruction5==1'b0)
                            r = a >> shamt;//r=sh;
                        else r = a >> b[4:0];
                            
                    end
            `ALU_SLL:begin  
                        if(instruction5==1'b0)
                            r = a << shamt;
                        else r = a << b[4:0];
                    end
            `ALU_SRA:begin 
                        if(instruction5==1'b0)
                            r = a_s >>> shamt_s;
                        else r = a_s >>> b[4:0];
                    end
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)}; 
            `ALU_SLTU:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule