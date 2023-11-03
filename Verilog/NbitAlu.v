`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: NbitAlu.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting an n bit arithmetic logic unit
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module NbitAlu#(parameter N= 32)(
    input [N-1:0] Alu1stSource,
    input [N-1:0] Alu2ndSource,
    input [3:0] ALUSelection,
    output reg [N-1:0] AluOut,
    output Zflag
    );
    
    wire [N-1:0] Sum, RCAinput2, AND, OR;
    wire Carry_out; // told to ignore this
    assign RCAinput2 = ALUSelection[2] ? ~Alu2ndSource : Alu2ndSource; 
    NbitRCA#(N) rcaInst (.input_1(Alu1stSource),.input_0(RCAinput2),.Sum(Sum),.Carry_in(ALUSelection[2]),.Carry_out(Carry_out));
    assign AND = Alu1stSource & Alu2ndSource;
    assign OR = Alu1stSource | Alu2ndSource;
    always@(*) begin
        case(ALUSelection)
            4'b0010: begin
                //add
                out = Sum;
            end
            4'b0110: begin
                //sub
                out = Sum;
            end
            4'b0000: begin
                //and
                out = AND;
            end
            4'b0001: begin
                //or
                out = OR;
            end
            default: out = 0;
    
        endcase
    end
    assign Zflag = out ? 1'b0: 1'b1;
endmodule
