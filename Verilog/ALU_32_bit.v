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
	input wire [2:0] func3,
	input wire instruction25,
	input [4:0] OpCode,
	input wire instruction5,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);
    
    wire signed  [31:0] a_s;
    assign a_s = a;
    
    wire signed [31:0] b_s;
    assign b_s = b;

    wire [31:0] add, sub, op_b;
    
    wire [31:0]  mulh, mulh_su, div, rem;
    wire signed [31:0] mul_s, mulh_s, div_s, rem_s;
    
    wire [63:0] a_long, b_long, a_s_long, b_s_long, mul_long;
    wire signed [63:0] mul_s_long, mul_su_long;
    
    assign a_long = {{32{1'b0}}, a};
    assign b_long = {{32{1'b0}}, b};
    assign a_s_long = {{32{a[31]}}, a};
    assign b_s_long = {{32{b[31]}}, b};
    
    assign mul_s_long = a_s_long * b_s_long;
    assign mul_long = a_long * b_long;
    assign mul_su_long = a_s_long * b_long;
    
    assign mul_s = mul_s_long[31:0];
    assign mulh_s = mul_s_long[63:32];
    assign mulh = mul_long [63:32];
    assign mulh_su = mul_su_long[63:32];
    
    assign div_s = a_s/b_s;
    assign div = a/b;
    assign rem_s = a_s%b_s;
    assign rem = a % b;
        
    wire cfa, cfs;
    
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
        /*(* parallel_case *)*/
        if(instruction25 && OpCode == 5'b01100) begin
            case(func3)
                0: r = mul_s;
                1: r = mulh_s;
                2: r = mulh_su;
                3: r = mulh;
                4: r = div_s;
                5: r = div;
                6: r = rem_s;
                7: r = rem;
                default r = 32'd999;
            endcase
        end else begin
            case (alufn)
            // arithmetic
            `ALU_ADD : r =  add;
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
            default: r = 32'd99;    	
            endcase
        end
        
    end
endmodule